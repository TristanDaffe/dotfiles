-- protols resolves imports against include_paths only; imports here are flat
-- (`import "installation_common.proto"`), so the proto dir itself must be one.
local function include_paths(root)
    local paths, seen = {}, {}
    local function add(d)
        if d and not seen[d] and vim.fn.isdirectory(d) == 1 then
            seen[d] = true
            paths[#paths + 1] = d
        end
    end
    local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    while dir and dir ~= '/' do
        local base = vim.fs.basename(dir)
        if base == 'protobuf' or base == 'proto' or base == 'protos' then
            add(dir)
            for name, t in vim.fs.dir(dir) do
                if t == 'directory' then add(dir .. '/' .. name) end
            end
            break
        end
        if dir == root then break end
        dir = vim.fs.dirname(dir)
    end
    add(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
    add('/opt/homebrew/include')
    return paths
end

return {
    cmd = function(dispatchers, config)
        local args = { 'protols' }
        local paths = include_paths(config.root_dir)
        if #paths > 0 then
            vim.list_extend(args, { '--include-paths', table.concat(paths, ',') })
        end
        return vim.lsp.rpc.start(args, dispatchers)
    end,
}
