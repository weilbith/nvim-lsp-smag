local vim = vim
local api = vim.api
local lsp = vim.lsp
local tag_formatting = require "lsp_smag.tags.formatting"
local list_utils = require "lsp_smag.utils.lists"
local lsp_methods = require "lsp_smag.lsp.methods"
local lsp_server_capabilities = require "lsp_smag.lsp.server_capabilities"
local tag_kinds = require "lsp_smag.tags.kinds"

local function get_word_under_cursor()
    return api.nvim_call_function("expand", {"<cword>"})
end

local function get_locations_from_client(client, method, parameter, buffer_number)
    if not client.supports_method(method) then
        return {}
    end

    local response = client.request_sync(method, parameter, nil, buffer_number)

    if response ~= nil and response.result ~= nil then
      return response.result
    else
      return {}
    end
end

local function get_locations_from_all_clients(method)
    local buffer_number = api.nvim_get_current_buf()
    local parameter = lsp.util.make_position_params()
    local buffer_clients = lsp.buf_get_clients(buffer_number)
    local all_locations = {}

    for _, client in ipairs(buffer_clients) do
        local locations = get_locations_from_client(client, method, parameter, buffer_number)
        list_utils.extend(all_locations, locations)
    end

    return all_locations
end

local function convert_locations_to_tags(locations, tag_kind)
    local tags = {}
    local tag_name = get_word_under_cursor()

    for _, location in ipairs(locations) do
        table.insert(tags, tag_formatting.lsp_location_to_tag(tag_name, tag_kind, location))
    end

    return tags
end

local function get_tags_of_provider(provider_name)
    local lsp_method = lsp_methods[provider_name]
    local tag_kind = tag_kinds[provider_name]
    local locations = get_locations_from_all_clients(lsp_method)
    return convert_locations_to_tags(locations, tag_kind)
end

return {
    get_tags_of_provider = get_tags_of_provider
}
