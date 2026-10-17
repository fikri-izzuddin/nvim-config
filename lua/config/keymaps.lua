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
