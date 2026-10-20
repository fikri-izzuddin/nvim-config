return {
    before_init = function(_, config)
        local root = config.root_dir
        local python = root and vim.fs.joinpath(root, ".venv", "bin", "python")
        if python and vim.uv.fs_stat(python) then
            config.settings.python = vim.tbl_extend("force", config.settings.python or {}, {
                pythonPath = python,
            })
        end
    end,
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "standard",
                inlayHints = { variableTypes = true, callArgumentNames = true },
            },
        },
    },
}
