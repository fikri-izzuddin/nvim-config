local pack = require("config.pack")

pack.later(function()
    vim.pack.add({ pack.gh("stevearc/conform.nvim") })
    local conform = require("conform")
    conform.setup({
        formatters_by_ft = {
            python = { "ruff_organize_imports", "ruff_format" },
            lua = { "stylua" },
        },
        format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
    })
    vim.keymap.set({ "n", "x" }, "<LEADER>cf", function()
        conform.format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format" })
    vim.keymap.set("n", "<LEADER>co", function()
        conform.format({ formatters = { "ruff_organize_imports" } })
    end, { desc = "Organize imports" })
end)
