vim.opt_local.colorcolumn = "+1"

-- Rewrap the body on :w. Leaves the subject, comments, the diff from
-- `commit -v`, trailers (Co-Authored-By: ...) and indented code alone.
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function(ev)
        local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
        if #lines[1] > 50 then
            vim.notify(("Subject is %d characters (aim for 50)"):format(#lines[1]), vim.log.levels.WARN)
        end

        -- Body runs from line 3 to the first comment line
        local last = #lines
        for i = 3, #lines do
            if lines[i]:match("^#") then
                last = i - 1
                break
            end
        end

        -- Collect paragraphs, then format bottom-up so earlier ranges stay valid
        local paras, start = {}, nil
        for i = 3, last + 1 do
            local blank = i > last or lines[i]:match("^%s*$")
            if not blank and not start then
                start = i
            elseif blank and start then
                table.insert(paras, { start, i - 1 })
                start = nil
            end
        end

        local view = vim.fn.winsaveview()
        for p = #paras, 1, -1 do
            local s, e = paras[p][1], paras[p][2]
            local skip = false
            for i = s, e do
                local l = lines[i]
                if l:match("^[%w-]+: ") or l:match("^    ") or l:match("^\t") then
                    skip = true
                    break
                end
            end
            if not skip then
                vim.cmd(("silent keepjumps normal! %dGgq%dG"):format(s, e))
            end
        end
        vim.fn.winrestview(view)
    end,
})
