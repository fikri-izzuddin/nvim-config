local pack = require("config.pack")
local gh = pack.gh

pack.on_event({ "InsertEnter", "CmdlineEnter" }, function()
    vim.pack.add({
        { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
        gh("rafamadriz/friendly-snippets"),
    })
    require("blink.cmp").setup({
        keymap = {
            preset = "default",
            ["<TAB>"] = { "select_and_accept", "snippet_forward", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
        },
        signature = { enabled = true },
        completion = {
            keyword = { range = "full" },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false,
                },
            },
            ghost_text = {
                enabled = true,
                show_without_selection = true,
            },
            documentation = { auto_show = true },
        },
        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
                lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
            },
        },
        cmdline = { enabled = true },
    })
end)
