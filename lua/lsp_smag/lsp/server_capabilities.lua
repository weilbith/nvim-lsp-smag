-- The resolved capabilities of the NeoVim client are awkward. Just use this
-- mapping to be 100% safe when looking them up.

local lsp_server_capabilities = {}
lsp_server_capabilities["definitionProvider"] = "goto_definition"
lsp_server_capabilities["declarationProvider"] = "declaration"
lsp_server_capabilities["implementationProvider"] = "implementation"
lsp_server_capabilities["typeDefinitionProvider"] = "type_definition"

return lsp_server_capabilities
