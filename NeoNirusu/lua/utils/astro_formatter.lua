local M = {}

function M.format_astro(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local in_block = false
    local block_tag = nil
    local start_line = nil

    for i, line in ipairs(lines) do
        if line:match("<script>") or line:match("<style>") then
            in_block = true
            block_tag = line:match("<(script)>") or line:match("<(style)>")
            start_line = i + 1
        elseif in_block and line:match("</" .. block_tag .. ">") then
            local end_line = i - 1
            if end_line >= start_line then
                local cur_win = vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_buf(bufnr)

                -- temporarily set shiftwidth=2 for this block
                vim.cmd("let save_sw=&shiftwidth | setlocal shiftwidth=2")
                vim.cmd(string.format("%d,%dnormal! ==", start_line, end_line))
                vim.cmd("let &shiftwidth=save_sw")

                vim.api.nvim_set_current_win(cur_win)
            end
            in_block = false
            block_tag = nil
            start_line = nil
        end
    end
end

return M
