local map = vim.keymap.set
-- map("n", "<LEADER>", "<CMD><CR>", { desc = "" })

map("n", "<LEADER>w", "<CMD>write<CR>", { desc = "Save" })
map("n", "<LEADER>qq", "<CMD>quitall<CR>", { desc = "Quit all" })
map("n", "<ESC>", "<CMD>nohlsearch<CR><ESC>", { desc = "Clear search highlight" })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
map("n", "<LEADER>|", "<CMD>vsplit<CR>", { desc = "Split right" })
map("n", "<LEADER>-", "<CMD>split<CR>", { desc = "Split below" })
map("n", "<LEADER>uu", "<CMD>Undotree<CR>", { desc = "Undo tree" })

-- Alt+j/k moves lines in insert and visual mode. Normal mode belongs to smart-splits
map("i", "<A-j>", "<ESC><CMD>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<ESC><CMD>m .-2<CR>==gi", { desc = "Move line up" })
map("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Plugins (<LEADER>p)
map("n", "<LEADER>pu", function()
    vim.pack.update()
end, { desc = "Update plugins" })

map("n", "<LEADER>pc", function()
    vim.pack.update(nil, { offline = true })
end, { desc = "Plugin status" })

map("n", "<LEADER>pl", function()
    vim.ui.select(vim.pack.get(nil, { info = false }), {
        prompt = "Plugins",
        format_item = function(p)
            return ("%s %s %s"):format(p.active and "●" or "○", p.spec.name, p.rev:sub(1, 7))
        end,
    }, function(p)
        if p then
            vim.cmd.edit(p.path)
        end
    end)
end, { desc = "List plugins" })

map("n", "<LEADER>px", function()
    local unused = vim.iter(vim.pack.get(nil, { info = false }))
        :filter(function(p)
            return not p.active
        end)
        :map(function(p)
            return p.spec.name
        end)
        :totable()
    if #unused == 0 then
        return vim.notify("No unused plugins")
    end
    if vim.fn.confirm("Delete " .. table.concat(unused, ", ") .. "?", "&Yes\n&No", 2) == 1 then
        vim.pack.del(unused)
    end
end, { desc = "Delete unused plugins" })
