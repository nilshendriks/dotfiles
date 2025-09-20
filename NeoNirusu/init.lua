vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local orig_preview = vim.lsp.util.open_floating_preview

vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    local function strip_base64_images(item)
        local lines = {}
        if type(item) == "string" then
            -- split string into lines first
            lines = vim.split(item, "\n")
        elseif type(item) == "table" and item.value then
            lines = vim.split(item.value, "\n")
        else
            return {}
        end

        -- remove just the base64 images, keep rest of line
        for i, line in ipairs(lines) do
            lines[i] = line:gsub("!%[.-%]%(%s*data:image.-%)", "")
        end
        return lines
    end

    -- Helper to clean escaped Markdown punctuation
    local function clean_lines(lines)
        for i, line in ipairs(lines) do
            line = line:gsub("\\([%-_%*%[%]()%.])", "%1") -- unescape - _ * [ ] ( )
            line = line:gsub("^%s+", ""):gsub("%s+$", "") -- trim whitespace
            lines[i] = line
        end
        return lines
    end

    -- Normalize contents
    if type(contents) == "table" then
        local filtered = {}
        for _, item in ipairs(contents) do
            local lines = strip_base64_images(item)
            -- vim.list_extend(filtered, strip_base64_images(item))
            vim.list_extend(filtered, clean_lines(lines))
        end
        contents = filtered
    else
        -- contents = strip_base64_images(contents)
        contents = clean_lines(strip_base64_images(contents))
    end

    ---@type table<string, any>
    opts = opts or {}
    opts.border = opts.border or "rounded"
    opts.winhighlight = "Normal:Normal,FloatBorder:FloatBorder"

    -- maximum width relative to current window
    local max_win_width = math.floor(vim.o.columns * 0.6) -- 60% of current Neovim window
    opts.max_width = opts.max_width or max_win_width

    local bufnr, winid = orig_preview(contents, syntax, opts, ...)

    local win_opts = {
        number = false,
        relativenumber = false,
        cursorline = false,
        foldenable = false,
    }

    for k, v in pairs(win_opts) do
        vim.wo[winid][k] = v
    end

    return bufnr, winid
end
-- bootstrap lazy.nvim if not installed
require("config.lazy")

-- general vim options
require("config.options")

-- add filetypes (mdx)
require("config.filetype")

-- keymaps
require("config.keymaps")

-- autocmds
require("config.autocmds")
