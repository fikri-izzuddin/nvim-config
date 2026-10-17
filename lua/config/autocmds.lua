local group = vim.api.nvim_create_augroup("config", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
    group = group,
    desc = "Highlight yanked text",
    callback = function()
        vim.hl.on_yank()
    end,
})

autocmd("BufReadPost", {
    group = group,
    desc = "Restore the last cursor position",
    callback = function(ev)
        local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

autocmd("VimResized", {
    group = group,
    desc = "Equalize splits in every tab after resize",
    callback = function()
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            vim.api.nvim_win_call(vim.api.nvim_tabpage_get_win(tab), function()
                vim.cmd.wincmd("=")
            end)
        end
    end,
})
