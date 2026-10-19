local pack = require("config.pack")
local gh = pack.gh

pack.on_event("InsertEnter", function()
    vim.pack.add({ gh("windwp/nvim-autopairs") })
    require("nvim-autopairs").setup({ check_ts = true })
end)

pack.later(function()
    vim.pack.add({ gh("kylechui/nvim-surround"), gh("saghen/blink.indent"), gh("nvim-mini/mini.nvim") })
    require("nvim-surround").setup({})
    require("blink.indent").setup({})

    local hi = require("mini.hipatterns")
    local function word(w, group)
        return { pattern = "%f[%w]()" .. w .. "()%f[%W]", group = group }
    end
    hi.setup({
        highlighters = {
            fixme = word("FIXME", "MiniHipatternsFixme"),
            hack = word("HACK", "MiniHipatternsHack"),
            todo = word("TODO", "MiniHipatternsTodo"),
            note = word("NOTE", "MiniHipatternsNote"),
            hex_color = hi.gen_highlighter.hex_color(),
        },
    })
end)
