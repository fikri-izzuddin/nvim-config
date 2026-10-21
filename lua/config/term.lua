local M = {}
local terms = {}

---@param name string
---@param cmd? string defaults to your shell
function M.toggle(name, cmd)
    local t = terms[name] or {}
    terms[name] = t

    if t.win and vim.api.nvim_win_is_valid(t.win) then
        vim.api.nvim_win_hide(t.win)
        t.win = nil
        return
    end

    if not (t.buf and vim.api.nvim_buf_is_valid(t.buf)) then
        t.buf = vim.api.nvim_create_buf(false, true)
    end

    local w, h = math.floor(vim.o.columns * 0.9), math.floor(vim.o.lines * 0.85)
    t.win = vim.api.nvim_open_win(t.buf, true, {
        relative = "editor",
        width = w,
        height = h,
        row = math.floor((vim.o.lines - h) / 2),
        col = math.floor((vim.o.columns - w) / 2),
    })

    if vim.bo[t.buf].buftype ~= "terminal" then
        vim.fn.jobstart(cmd or vim.o.shell, {
            term = true,
            on_exit = function()
                if t.win and vim.api.nvim_win_is_valid(t.win) then
                    vim.api.nvim_win_close(t.win, true)
                end

                if t.buf and vim.api.nvim_buf_is_valid(t.buf) then
                    vim.api.nvim_buf_delete(t.buf, { force = true })
                end

                t.win, t.buf = nil, nil
            end,
        })
    end

    vim.cmd.startinsert()
end

return M
