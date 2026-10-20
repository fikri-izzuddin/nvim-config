local pack = require("config.pack")
local gh = pack.gh

vim.pack.add({
    gh("neovim/nvim-lspconfig"),
    gh("folke/lazydev.nvim"),
})
require("lazydev").setup({})

vim.g.py_lsp = vim.g.py_lsp or "basedpyright"
vim.lsp.enable({ vim.g.py_lsp, "ruff", "lua_ls" })

vim.diagnostic.config({
    virtual_lines = { current_line = true },
    severity_sort = true,
    float = { source = true },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
        },
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        local function map(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = ev.buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("<LEADER>cr", vim.lsp.buf.rename, "Rename")
        map("<LEADER>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
        map("<LEADER>cd", vim.diagnostic.open_float, "Line diagnostic")
        map("<LEADER>uh", function()
            local on = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
            vim.lsp.inlay_hint.enable(not on, { bufnr = ev.buf })
        end, "Toggle inlay hints")

        -- Built-in replacement for vim-illuminate. Highlight the symbol under
        -- the cursor after updatetime (250 ms), clear it when the cursor moves.
        if client:supports_method("textDocument/documentHighlight", ev.buf) then
            local hl = vim.api.nvim_create_augroup("lsp_highlight_" .. ev.buf, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = hl,
                buffer = ev.buf,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = hl,
                buffer = ev.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- Remove the highlight autocmds when the last server that supports it detaches
vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("lsp_detach", { clear = true }),
    callback = function(ev)
        local others = vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/documentHighlight" })
        others = vim.tbl_filter(function(c)
            return c.id ~= ev.data.client_id
        end, others)
        if #others == 0 then
            vim.lsp.util.buf_clear_references(ev.buf)
            pcall(vim.api.nvim_del_augroup_by_name, "lsp_highlight_" .. ev.buf)
        end
    end,
})

local py_lsps = { "basedpyright", "ty" }

vim.api.nvim_create_user_command("PyLsp", function(args)
    local old, new = vim.g.py_lsp, args.args
    if not vim.list_contains(py_lsps, new) then
        return vim.notify("Unknown type checker: " .. new, vim.log.levels.ERROR)
    end
    if new == old then
        return
    end
    vim.lsp.enable(old, false)
    vim.lsp.enable(new)
    vim.g.py_lsp = new
    vim.notify("Python type checker: " .. new)
end, {
    nargs = 1,
    complete = function()
        return py_lsps
    end,
})

vim.keymap.set("n", "<LEADER>cp", function()
    vim.cmd.PyLsp(vim.g.py_lsp == "ty" and "basedpyright" or "ty")
end, { desc = "Switch Python type checker" })
