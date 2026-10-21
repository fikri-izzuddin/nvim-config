vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("plugins.ui")
require("plugins.editor")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.completion")
require("plugins.format")
require("plugins.navigation")
require("plugins.git")
