local lsp_provider_names = require "lsp_smag.lsp.provider_names"

local lsp_methods = {}
lsp_methods[lsp_provider_names.definition] = "textDocument/definition"
lsp_methods[lsp_provider_names.declaration] = "textDocument/declaration"
lsp_methods[lsp_provider_names.implementation] = "textDocument/implementation"
lsp_methods[lsp_provider_names.typeDefinition] = "textDocument/typeDefinition"

return lsp_methods
