return {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false -- K comes from type checker
    end,
}
