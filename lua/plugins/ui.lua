local pack = require("config.pack")
local gh = pack.gh

pack.now(function()
    vim.g.barbar_auto_setup = false
    vim.pack.add({
        { src = gh("catppuccin/nvim"), name = "catppuccin-nvim" },
        gh("nvim-tree/nvim-web-devicons"),
        gh("nvim-lualine/lualine.nvim"),
        gh("romgrk/barbar.nvim"),
    })

    require("catppuccin").setup({
        flavour = "auto",
        background = { light = "latte", dark = "mocha" },
    })
    vim.cmd.colorscheme("catppuccin-nvim")

    require("barbar").setup({
        animation = false,
        icons = {
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = true },
                [vim.diagnostic.severity.WARN] = { enabled = true },
            },
        },
    })

    local map = vim.keymap.set
    map("n", "<S-h>", "<CMD>BufferPrevious<CR>", { desc = "Previous buffer" })
    map("n", "<S-l>", "<CMD>BufferNext<CR>", { desc = "Next buffer" })
    map("n", "[b", "<CMD>BufferPrevious<CR>", { desc = "Previous buffer" })
    map("n", "]b", "<CMD>BufferNext<CR>", { desc = "Next buffer" })
    map("n", "[B", "<CMD>BufferMovePrevious<CR>", { desc = "Move buffer to the left" })
    map("n", "]B", "<CMD>BufferMoveNext<CR>", { desc = "Move buffer to the right" })
    map("n", "<LEADER>bx", "<CMD>BufferClose<CR>", { desc = "Close current buffer" })
    map("n", "<LEADER>bq", "<CMD>BufferClose!<CR>", { desc = "Close current buffer (discard changes)" })
    map("n", "<LEADER>bp", "<CMD>BufferPick<CR>", { desc = "Pick a buffer" })
    map("n", "<LEADER>bP", "<CMD>BufferPin<CR>", { desc = "Pin a buffer" })
    map("n", "<LEADER>bQ", "<CMD>BufferCloseAllButCurrentOrPinned<CR>", { desc = "Close other buffers" })
    -- map("n", "<LEADER>br", "<CMD>BufferCloseBuffersRight<CR>", { desc = "Close buffers to the right" })
    -- map("n", "<LEADER>bl", "<CMD>BufferCloseBuffersLeft<CR>", { desc = "Close buffers to the left" })
    map("n", "<LEADER>0", "<CMD>BufferLast<CR>", { desc = "Go to the last buffer" })
    for i = 1, 9 do
        map("n", "<LEADER>" .. i, "<CMD>BufferGoto " .. i .. "<CR>", { desc = "Go to buffer " .. i })
    end

    require("lualine").setup({
        options = { theme = "auto", globalstatus = true },
        sections = {
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { { "filename", path = 1 } },
            lualine_x = {
                function()
                    return vim.ui.progress_status() or ""
                end,
                function()
                    return vim.bo.filetype == "python" and (vim.g.py_lsp or "") or ""
                end,
                function()
                    local venv = vim.env.VIRTUAL_ENV
                    return venv and vim.fn.fnamemodify(venv, ":h:t") or ""
                end,
            },
        },
    })
    vim.api.nvim_create_autocmd("Progress", { command = "redrawstatus" })
end)

pack.later(function()
    vim.pack.add({ gh("nvim-mini/mini.nvim") })
    local clue = require("mini.clue")
    clue.setup({
        triggers = {
            { mode = { "n", "x" }, keys = "<LEADER>" },
            { mode = { "n", "x" }, keys = "g" },
            { mode = "n", keys = "[" },
            { mode = "n", keys = "]" },
            { mode = { "n", "x" }, keys = "z" },
            { mode = { "n", "x" }, keys = '"' },
            { mode = { "n", "x" }, keys = "'" },
            { mode = "n", keys = "<C-w>" },
        },
        clues = {
            { mode = "n", keys = "<LEADER>b", desc = "+Buffers" },
            { mode = "n", keys = "<LEADER>c", desc = "+Code" },
            { mode = "n", keys = "<LEADER>d", desc = "+Debug" },
            { mode = "n", keys = "<LEADER>f", desc = "+Find" },
            { mode = "n", keys = "<LEADER>g", desc = "+Git" },
            { mode = "n", keys = "<LEADER>h", desc = "+Hunks" },
            { mode = "n", keys = "<LEADER>p", desc = "+Plugins" },
            { mode = "n", keys = "<LEADER>s", desc = "+Search" },
            { mode = "n", keys = "<LEADER>u", desc = "+UI" },
            { mode = "n", keys = "<LEADER>x", desc = "+Lists" },
            { mode = "n", keys = "<LEADER>q", desc = "+Quit" },
            clue.gen_clues.g(),
            clue.gen_clues.marks(),
            clue.gen_clues.registers(),
            clue.gen_clues.windows(),
            clue.gen_clues.z(),
        },
        window = {
            delay = 0,
            config = { width = "auto" },
        },
    })
end)
