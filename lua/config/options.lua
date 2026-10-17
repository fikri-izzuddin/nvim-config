vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = "split"
vim.o.confirm = true
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.o.foldlevel = 99
vim.o.foldtext = ""
vim.o.showmode = false
vim.o.laststatus = 3
vim.o.sidescrolloff = 8
vim.o.splitkeep = "screen"
vim.o.virtualedit = "block"
vim.o.shiftround = true
vim.o.jumpoptions = "clean,view"
vim.o.smoothscroll = true
vim.o.list = true
vim.o.spelloptions = "camel"
vim.o.linebreak = true
vim.o.breakindent = true

vim.opt.fillchars = { eob = " " }
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.wildoptions:append("fuzzy")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

vim.cmd.packadd("nohlsearch")
vim.cmd.packadd("nvim.undotree")
