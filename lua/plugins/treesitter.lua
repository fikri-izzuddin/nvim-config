local pack = require("config.pack")
local gh = pack.gh

vim.pack.add({
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
    { src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
    gh("nvim-treesitter/nvim-treesitter-context"),
})

local parsers = {
    "python",
    "lua",
    "luadoc",
    "luap",
    "vim",
    "vimdoc",
    "query",
    "toml",
    "yaml",
    "json",
    "markdown",
    "markdown_inline",
    "bash",
    "regex",
    "dockerfile",
}
require("nvim-treesitter").install(parsers) -- async, and a no-op once installed

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
    callback = function(ev)
        if not pcall(vim.treesitter.start, ev.buf) then
            return -- no parser for this filetype
        end
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang and vim.treesitter.query.get(lang, "indents") then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

pack.later(function()
    require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
    local move = require("nvim-treesitter-textobjects.move")
    local function jump(lhs, fn, query, desc)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
            if vim.wo.diff and lhs:find("c") then
                return vim.cmd.normal({ vim.v.count1 .. lhs, bang = true }) -- built-in next/prev change
            end
            if not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
                return -- no parser, so no functions or classes to jump to
            end
            move[fn](query, "textobjects")
        end, { desc = desc })
    end
    jump("]f", "goto_next_start", "@function.outer", "Next function")
    jump("[f", "goto_previous_start", "@function.outer", "Previous function")
    jump("]c", "goto_next_start", "@class.outer", "Next class")
    jump("[c", "goto_previous_start", "@class.outer", "Previous class")

    require("treesitter-context").setup({ max_lines = 3 })
end)
