local M = {}

local function has_prettier_config(bufnr)
    print("checking buffer", bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)

    vim.print(filename)

    return false

    -- local root = vim.fn.getcwd()
    --
    -- local prettier_configs = {
    --     ".prettierrc",
    --     ".prettierrc.json",
    --     ".prettierrc.yml",
    --     ".prettierrc.yaml",
    --     ".prettierrc.js",
    --     ".prettierrc.cjs",
    --     ".prettierrc.mjs",
    --     "prettier.config.js",
    --     "prettier.config.cjs",
    --     "prettier.config.mjs",
    --     "prettier.config.ts",
    -- }
    --
    -- for _, file in ipairs(prettier_configs) do
    --     local path = root .. "/" .. file
    --
    --     if vim.uv.fs_stat(path) then
    --         vim.print("Found:", path)
    --         return true
    --     end
    -- end
    --
    -- vim.print("No Prettier config found")
    -- return false
end

function M.json(bufnr)
    print("json()", bufnr)

    if has_prettier_config(bufnr) then
        return { "prettier", lsp_format = "never" }
    end

    return { "oxfmt", lsp_format = "never" }
end

function M.jsonc(bufnr)
    return M.json(bufnr)
end

-- function M.json()
--     if has_prettier_config() then
--         return { "prettier", lsp_format = "never" }
--     end
--
--     return { "oxfmt", lsp_format = "never" }
-- end
--
-- function M.jsonc()
--     return M.json()
-- end
--
-- function M.css()
--     return { "prettier", lsp_format = "never" }
-- end

return M
