local vim = vim
local api = vim.api
local string_utils = require "lsp_smag.utils.strings"
local list_utils = require "lsp_smag.utils.lists"
local lsp_provider_names = require "lsp_smag.lsp.provider_names"
local lsp_tag_kinds = require "lsp_smag.tags.kinds"

local function get_tag_kind_priority_order()
    local order_as_provider_entries = api.nvim_get_var("lsp_smag_tag_kind_priority_order")
    local order_as_tag_kinds = {}

    for _, provider_entry in ipairs(order_as_provider_entries) do
        local provider_name = lsp_provider_names[provider_entry]
        local tag_kind = lsp_tag_kinds[provider_name]
        table.insert(order_as_tag_kinds, tag_kind)
    end

    return list_utils.reverse(order_as_tag_kinds)
end

local function compare_tags(tag_a, tag_b)
    local kind_a = string_utils.strip(tag_a.kind)
    local kind_b = string_utils.strip(tag_b.kind)
    local priority_order = get_tag_kind_priority_order()
    local priority_a = list_utils.index_of(priority_order, kind_a)
    local priority_b = list_utils.index_of(priority_order, kind_b)
    return priority_a > priority_b
end

local function sort_tags_by_kind(tags)
    return table.sort(tags, compare_tags)
end

return {
    sort_tags_by_kind = sort_tags_by_kind
}
