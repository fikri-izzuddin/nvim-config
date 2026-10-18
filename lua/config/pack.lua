local M = {}

---@param repo string "owner/name"
---@return string
function M.gh(repo)
    return "https://github.com/" .. repo
end

-- Build steps after install or update
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
        -- catppuccin's cache doesn't notice new plugins. Removing its hash
        -- file makes the next setup() rebuild with the new integration.
        if kind == "install" then
            os.remove(vim.fn.stdpath("cache") .. "/catppuccin/cached")
        end
    end,
})

--- Run now, during startup. Exists so every plugin file reads the same way.
---@param fn fun()
function M.now(fn)
    fn()
end

--- Run once the first screen is drawn.
---@param fn fun()
function M.later(fn)
    if vim.v.vim_did_enter == 1 then
        return vim.schedule(fn)
    end
    vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
            vim.schedule(fn)
        end,
    })
end

--- Run the first time any of the events fires.
---@param events string|string[]
---@param fn fun(args: vim.api.keyset.create_autocmd.callback_args)
function M.on_event(events, fn)
    vim.api.nvim_create_autocmd(events, { once = true, callback = fn })
end

---@param spec string|vim.pack.Spec
---@return string
local function plugin_name(spec)
    if type(spec) == "table" and spec.name then
        return spec.name
    end
    local src = type(spec) == "table" and spec.src or spec
    local name = src:match("[^/]+$"):gsub("%.git$", "")
    return name
end

--- Install now, load on the first press of any key in `keys`.
---@param specs (string|vim.pack.Spec)[]
---@param keys { [1]: string|string[], [2]: string, desc: string }[]
---@param setup fun() defines the real keymaps
function M.on_key(specs, keys, setup)
    vim.pack.add(specs, { load = false })
    for _, key in ipairs(keys) do
        vim.keymap.set(key[1], key[2], function()
            for _, k in ipairs(keys) do
                pcall(vim.keymap.del, k[1], k[2]) -- remove every stub
            end
            for _, spec in ipairs(specs) do
                vim.cmd.packadd(plugin_name(spec))
            end
            setup() -- defines the real keymaps
            vim.api.nvim_feedkeys(vim.keycode(key[2]), "m", false) -- replay the press
        end, { desc = key.desc })
    end
end

return M
