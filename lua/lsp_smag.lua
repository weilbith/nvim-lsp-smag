local vim = vim
local list_utils = require "lsp_smag.utils.lists"
local tag_sorting = require "lsp_smag.tags.sorting"
local lsp_provider = require "lsp_smag.lsp.provider"
local lsp_provider_names = require "lsp_smag.lsp.provider_names"

lsp_smag = {}

local function user_tries_to_complete_tag(flags)
    if string.find(flags, "i") then
        return true
    else
        return false
    end
end

local function query_provider(provider_entry)
    local provider_name = lsp_provider_names[provider_entry]

    if provider_name ~= nil then
        return lsp_provider.get_tags_of_provider(provider_name)
    else
        print("Unsupported provider: " .. provider_entry)
        return {}
    end
end

function lsp_smag.tagfunc(_, flags, _)
    if user_tries_to_complete_tag(flags) then
        return nil
    end

    local enabled_providers =
        vim.g.lsp_smag_enabled_providers or {"definition", "declaration", "implementation", "typeDefinition"}
    local tags = {}

    for _, provider_entry in ipairs(enabled_providers) do
        local tags_by_provider = query_provider(provider_entry)
        list_utils.extend(tags, tags_by_provider)
    end

    tag_sorting.sort_tags_by_kind(tags)
    return tags
end
