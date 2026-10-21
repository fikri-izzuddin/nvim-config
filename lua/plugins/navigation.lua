local pack = require("config.pack")
local gh = pack.gh
local map = vim.keymap.set

pack.now(function()
    vim.pack.add({ gh("mrjones2014/smart-splits.nvim") })
    local ss = require("smart-splits")

    map("n", "<C-h>", ss.move_cursor_left, { desc = "Window left" })
    map("n", "<C-l>", ss.move_cursor_right, { desc = "Window right" })
    map("n", "<C-k>", ss.move_cursor_up, { desc = "Window up" })
    map("n", "<C-j>", ss.move_cursor_down, { desc = "Window down" })

    map("n", "<A-h>", ss.resize_left, { desc = "Resize left" })
    map("n", "<A-l>", ss.resize_right, { desc = "Resize right" })
    map("n", "<A-k>", ss.resize_up, { desc = "Resize up" })
    map("n", "<A-j>", ss.resize_down, { desc = "Resize down" })
end)

pack.later(function()
    vim.pack.add({
        gh("ibhagwan/fzf-lua"),
        gh("nvim-tree/nvim-tree.lua"),
    })

    local fzf = require("fzf-lua")
    fzf.setup({ "default-title" })
    fzf.register_ui_select()

    map("n", "<LEADER>ff", fzf.files, { desc = "Find file" })
    map("n", "<LEADER>/", fzf.live_grep, { desc = "Grep project" })
    map("n", "<LEADER>fw", fzf.grep_cword, { desc = "Grep word" })
    map("n", "<LEADER>fb", fzf.buffers, { desc = "Buffers" })
    map("n", "<LEADER>fr", fzf.oldfiles, { desc = "Recent files" })
    map("n", "<LEADER>fc", fzf.commands, { desc = "Commands" })
    map("n", "<LEADER>fk", fzf.keymaps, { desc = "Keymaps" })
    map("n", "<LEADER>fh", fzf.helptags, { desc = "Help" })
    map("n", "<LEADER>f.", fzf.resume, { desc = "Resume picker" })

    map("n", "<LEADER>cs", fzf.lsp_document_symbols, { desc = "Document symbols" })
    map("n", "<LEADER>cS", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })
    map("n", "<LEADER>xd", fzf.diagnostics_document, { desc = "File diagnostics" })
    map("n", "<LEADER>xD", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })

    map("n", "<LEADER>xt", function()
        fzf.grep({ search = "TODO|FIXME|HACK", no_esc = true })
    end, { desc = "Fix TODOs" })

    map("n", "<LEADER>gc", fzf.git_commits, { desc = "Git commits" })
    map("n", "<LEADER>gs", fzf.git_status, { desc = "Git status" })

    map("n", "grr", fzf.lsp_references, { desc = "References" })
    map("n", "gri", fzf.lsp_implementations, { desc = "Implementations" })
    map("n", "gO", fzf.lsp_document_symbols, { desc = "Document symbols" })

    require("nvim-tree").setup({
        update_focused_file = { enable = true },
        diagnostics = { enable = true },
        git = { enable = true },
        renderer = { group_empty = true },
    })

    map("n", "<LEADER>e", "<CMD>NvimTreeToggle<CR>", { desc = "Explorer" })
    map("n", "<LEADER>E", "<CMD>NvimTreeFindFile<CR>", { desc = "Reveal file" })
end)

pack.on_key({ gh("MagicDuck/grug-far.nvim") }, {
    { "n", "<LEADER>sr", desc = "Replace in project" },
    { "n", "<LEADER>sf", desc = "Replace in file" },
}, function()
    local grug = require("grug-far")
    grug.setup({})

    map("n", "<LEADER>sr", function()
        grug.open()
    end, { desc = "Replace in project" })

    map("n", "<LEADER>sf", function()
        grug.open({ prefills = { paths = vim.fn.expand("%") } })
    end, { desc = "Replace in file" })
end)

map({ "n", "t" }, "<C-/>", function()
    require("config.term").toggle("shell")
end, { desc = "Toggle terminal" })
