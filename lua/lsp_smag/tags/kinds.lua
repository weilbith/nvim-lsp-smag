local lsp_provider_names = require "lsp_smag.lsp.provider_names"

local tag_kinds = {}
tag_kinds[lsp_provider_names.definition] = "Definition"
tag_kinds[lsp_provider_names.declaration] = "Declaration"
tag_kinds[lsp_provider_names.implementation] = "Implementation"
tag_kinds[lsp_provider_names.typeDefinition] = "Type Definition"

return tag_kinds
