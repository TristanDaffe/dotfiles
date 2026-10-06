vim.pack.add({ { src = 'https://github.com/mfussenegger/nvim-jdtls' } })

local mason = vim.fn.stdpath('data') .. '/mason'
-- jdtls requires Java 21+ to run, independent of what a project targets.
local JDK21 = '/opt/homebrew/opt/openjdk@21'

local function jdk_home(pattern)
    return vim.fn.glob(pattern, true, true)[1]
end

-- `name` must be a valid execution environment id. Missing JDKs are skipped.
local function runtimes()
    local out = {}
    for _, r in ipairs({
        { 'JavaSE-21',  '/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home' },
        { 'JavaSE-17',  '/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home' },
        { 'JavaSE-1.8', '~/Library/Java/JavaVirtualMachines/corretto-1.8*/Contents/Home' },
    }) do
        local path = jdk_home(r[2])
        if path then out[#out + 1] = { name = r[1], path = path } end
    end
    return out
end

local function bundles()
    local out = {}

    local debug_jar = mason .. '/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'
    if vim.uv.fs_stat(debug_jar) then
        out[#out + 1] = debug_jar
    end

    -- Shipped in java-test but not loadable as bundles.
    local not_a_bundle = {
        ['com.microsoft.java.test.runner-jar-with-dependencies.jar'] = true,
        ['jacocoagent.jar'] = true,
    }
    -- Mason links some jars under two names; jdtls fails on a duplicate bundle.
    local seen = {}
    for _, jar in ipairs(vim.fn.glob(mason .. '/share/java-test/*.jar', true, true)) do
        local real = vim.uv.fs_realpath(jar) or jar
        if not seen[real] and not not_a_bundle[vim.fn.fnamemodify(jar, ':t')] then
            seen[real] = true
            out[#out + 1] = real
        end
    end
    return out
end

-- Name is relative to the current package: `Foo` or `sub.pkg.Foo`.
local function new_class()
    local dir = vim.fn.expand('%:p:h')
    local pkg
    for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 50, false)) do
        pkg = line:match('^%s*package%s+([%w_.]+)%s*;')
        if pkg then break end
    end

    vim.ui.input({ prompt = 'New class: ' }, function(input)
        if not input or input == '' then return end
        local parts = vim.split(input, '.', { plain = true })
        local name = table.remove(parts)
        if #parts > 0 then
            dir = dir .. '/' .. table.concat(parts, '/')
            pkg = pkg and (pkg .. '.' .. table.concat(parts, '.')) or table.concat(parts, '.')
        end

        local path = dir .. '/' .. name .. '.java'
        if vim.uv.fs_stat(path) then
            return vim.notify(path .. ' already exists', vim.log.levels.WARN)
        end
        vim.fn.mkdir(dir, 'p')
        local lines = pkg and { 'package ' .. pkg .. ';', '' } or {}
        vim.list_extend(lines, { 'public class ' .. name .. ' {', '', '}' })
        vim.fn.writefile(lines, path)
        vim.cmd.edit(vim.fn.fnameescape(path))
        vim.api.nvim_win_set_cursor(0, { #lines - 1, 0 })
    end)
end

-- jdtls adds the detected main classes next to this one.
local ATTACH = { type = 'java', request = 'attach', name = 'Attach to localhost:5005', hostName = '127.0.0.1', port = 5005 }

local cache

local function attach(buf)
    -- Nested lists rank the markers: a wrapper or the repo beats the nearest build
    -- file, so a multi-module project gets one jdtls, not one per module.
    local root = vim.fs.root(buf, {
        { 'mvnw', 'gradlew' },
        { '.git' },
        { 'pom.xml', 'build.gradle', 'build.gradle.kts', 'settings.gradle', 'settings.gradle.kts' },
    })
    if not root then return end
    if not vim.uv.fs_stat(JDK21 .. '/bin/java') then
        return vim.notify('jdtls: no Java 21 at ' .. JDK21, vim.log.levels.WARN)
    end

    cache = cache or { bundles = bundles(), runtimes = runtimes() }
    local jdtls = require('jdtls')
    -- Signs and the dap UI listeners, before jdtls starts a session.
    local dap = require('util.debug').dap()
    dap.configurations.java = dap.configurations.java or {}
    if not vim.tbl_contains(dap.configurations.java, ATTACH) then
        table.insert(dap.configurations.java, ATTACH)
    end

    jdtls.start_or_attach({
        cmd = {
            mason .. '/bin/jdtls',
            '--java-executable', JDK21 .. '/bin/java',
            '--jvm-arg=-javaagent:' .. mason .. '/share/jdtls/lombok.jar',
            -- Full path, so two projects with the same folder name keep separate indexes.
            '-data', vim.fn.stdpath('data') .. '/jdtls-workspace/' .. root:gsub('^/', ''):gsub('/', '%%'),
        },
        root_dir = root,
        on_attach = function(_, buf)
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
            vim.lsp.codelens.enable(true, { bufnr = buf })
        end,
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        init_options = { bundles = cache.bundles },
        settings = {
            java = {
                configuration = {
                    runtimes = cache.runtimes,
                    updateBuildConfiguration = 'interactive',
                },
                signatureHelp = { enabled = true },
                sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
                codeGeneration = { useBlocks = true },
                contentProvider = { preferred = 'fernflower' },
                eclipse = { downloadSources = true },
                maven = { downloadSources = true },
                implementationsCodeLens = { enabled = true },
                referencesCodeLens = { enabled = true },
                inlayHints = { parameterNames = { enabled = 'all' } },
                completion = {
                    favoriteStaticMembers = {
                        'org.junit.jupiter.api.Assertions.*',
                        'org.junit.jupiter.api.Assumptions.*',
                        'org.mockito.Mockito.*',
                        'org.mockito.ArgumentMatchers.*',
                        'java.util.Objects.requireNonNull',
                    },
                },
            },
        },
    }, {
        dap = { hotcodereplace = 'auto' },
    })

    -- Generate getters/setters/ctor/toString live in <leader>ca.
    local with_ui = require('util.debug').with_ui
    local function map(mode, key, fn, desc)
        vim.keymap.set(mode, key, fn, { buffer = buf, silent = true, desc = 'Java: ' .. desc })
    end

    map('n', '<leader>jn', new_class, 'new class')
    map('n', '<leader>jo', jdtls.organize_imports, 'organize imports')
    map('n', '<leader>jv', jdtls.extract_variable, 'extract variable')
    map('x', '<leader>jv', function() jdtls.extract_variable(true) end, 'extract variable')
    map('n', '<leader>jc', jdtls.extract_constant, 'extract constant')
    map('x', '<leader>jc', function() jdtls.extract_constant(true) end, 'extract constant')
    map('x', '<leader>jm', function() jdtls.extract_method(true) end, 'extract method')
    map('n', '<leader>jt', with_ui(jdtls.test_nearest_method, 'nearest test'), 'run test under cursor')
    map('n', '<leader>jT', with_ui(jdtls.test_class, 'test class'), 'run test class')
    map('n', '<leader>jg', function() require('jdtls.tests').generate() end, 'generate test class')
    map('n', '<leader>js', function() require('jdtls.tests').goto_subjects() end, 'jump between test and subject')
    map('n', '<leader>ju', '<cmd>JdtUpdateConfig<CR>', 'reload pom.xml / build.gradle')
    map('n', '<leader>jb', '<cmd>JdtBytecode<CR>', 'show bytecode (javap)')

    local mvn_root = vim.fs.root(buf, { 'mvnw' }) or vim.fs.root(buf, { 'pom.xml' })
    if mvn_root then
        require('util.palette').add({ cat = 'Maven', name = 'run tests', buf = buf, run = function()
            vim.cmd('botright 15new')
            local mvn = vim.uv.fs_stat(mvn_root .. '/mvnw') and './mvnw' or 'mvn'
            vim.fn.jobstart({ mvn, '-q', 'test' }, { term = true, cwd = mvn_root })
        end })
    end
end

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('user.java', { clear = true }),
    pattern = 'java',
    callback = function(ev) attach(ev.buf) end,
})
