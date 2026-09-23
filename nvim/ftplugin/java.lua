-- Nested lists rank the markers: a wrapper or the repo beats the nearest build
-- file, so a multi-module project gets one jdtls, not one per module.
local root = vim.fs.root(0, {
    { 'mvnw', 'gradlew' },
    { '.git' },
    { 'pom.xml', 'build.gradle', 'build.gradle.kts', 'settings.gradle', 'settings.gradle.kts' },
})
if not root then return end

local jdtls = require('jdtls')
local mason = vim.fn.stdpath('data') .. '/mason'
-- jdtls requires Java 21+ to run, independent of what a project targets.
local JDK21 = '/opt/homebrew/opt/openjdk@21'

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
    init_options = { bundles = bundles() },
    settings = {
        java = {
            -- `name` must be a valid execution environment id.
            configuration = {
                runtimes = {
                    { name = 'JavaSE-21',  path = JDK21 .. '/libexec/openjdk.jdk/Contents/Home' },
                    { name = 'JavaSE-17',  path = '/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home' },
                    { name = 'JavaSE-1.8', path = vim.fn.expand('~/Library/Java/JavaVirtualMachines/corretto-1.8.0_482/Contents/Home') },
                },
                updateBuildConfiguration = 'interactive',
            },
            signatureHelp = { enabled = true },
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
local with_repl = require('core.debug').with_repl
local function map(mode, key, fn, desc)
    vim.keymap.set(mode, key, fn, { buffer = 0, silent = true, desc = 'Java: ' .. desc })
end

map('n', '<leader>jo', jdtls.organize_imports, 'organize imports')
map('n', '<leader>jv', jdtls.extract_variable, 'extract variable')
map('x', '<leader>jv', function() jdtls.extract_variable(true) end, 'extract variable')
map('n', '<leader>jc', jdtls.extract_constant, 'extract constant')
map('x', '<leader>jc', function() jdtls.extract_constant(true) end, 'extract constant')
map('x', '<leader>jm', function() jdtls.extract_method(true) end, 'extract method')
map('n', '<leader>jt', with_repl(jdtls.test_nearest_method, 'nearest test'), 'run test under cursor')
map('n', '<leader>jT', with_repl(jdtls.test_class, 'test class'), 'run test class')
map('n', '<leader>jg', function() require('jdtls.tests').generate() end, 'generate test class')
map('n', '<leader>js', function() require('jdtls.tests').goto_subjects() end, 'jump between test and subject')
map('n', '<leader>ju', '<cmd>JdtUpdateConfig<CR>', 'reload pom.xml / build.gradle')
map('n', '<leader>jb', '<cmd>JdtBytecode<CR>', 'show bytecode (javap)')

local mvn_root = vim.fs.root(0, { 'mvnw' }) or vim.fs.root(0, { 'pom.xml' })
if mvn_root then
    require('core.palette').add({ cat = 'Maven', name = 'run tests', buf = 0, run = function()
        vim.cmd('botright 15new')
        vim.fn.jobstart({ 'mvn', '-q', 'test' }, { term = true, cwd = mvn_root })
    end })
end
