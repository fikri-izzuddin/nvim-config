local pack = require("config.pack")
local gh = pack.gh

pack.later(function()
    vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
    local gs = require("gitsigns")
    gs.setup({
        on_attach = function(buf)
            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
            end

            map("n", "]h", function()
                gs.nav_hunk("next")
            end, "Next hunk")

            map("n", "[h", function()
                gs.nav_hunk("prev")
            end, "Previous hunk")

            map("n", "<LEADER>hs", gs.stage_hunk, "Stage hunk")
            map("n", "<LEADER>hr", gs.reset_hunk, "Reset hunk")
            map("n", "<LEADER>hp", gs.preview_hunk, "Preview hunk")
            map("n", "<LEADER>hb", function()
                gs.blame_line({ full = true })
            end, "Blame line")
            map("n", "<LEADER>ub", gs.toggle_current_line_blame, "Toggle inline blame")
            map({ "o", "x" }, "ih", gs.select_hunk, "Hunk")
        end,
    })
end)

pack.on_key({ gh("esmuellert/codediff.nvim") }, {
    { "n", "<LEADER>gd", desc = "Side-by-side diff" },
}, function()
    require("codediff").setup({})
    vim.keymap.set("n", "<LEADER>gd", "<CMD>CodeDiff<CR>", { desc = "Side-by-side diff" })
end)

vim.keymap.set("n", "<LEADER>gg", function()
    require("config.term").toggle("lazygit", "lazygit")
end, { desc = "lazygit" })
