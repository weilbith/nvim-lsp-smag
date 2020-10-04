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

local function client_response_is_error(client_response)
    return client_response["error"] ~= nil
end

local function merge_all_client_responses(response)
    if response == nil then
        return {}
    end

    local results = {}

    for _, client_response in ipairs(response) do
        if not client_response_is_error(client_response) then
            list_utils.extend(results, client_response.result)
        end
        -- TODO: Notify client errors?
    end

    return results
end

local function provider_is_available(provider_name)
    -- TODO: Evaluate how to interact with multiple clients.
    local first_client = lsp.buf_get_clients()[1]
    local capability = lsp_server_capabilities[provider_name]

    if first_client == nil then
        return false
    else
        return first_client.resolved_capabilities[capability]
    end
end

local function get_locations_from_server(method)
    local buffer_number = api.nvim_get_current_buf()
    local parameter = lsp.util.make_position_params()
    local response = lsp.buf_request_sync(buffer_number, method, parameter)
    return merge_all_client_responses(response)
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
    if not provider_is_available(provider_name) then
        return {}
    else
        local lsp_method = lsp_methods[provider_name]
        local tag_kind = tag_kinds[provider_name]
        local locations = get_locations_from_server(lsp_method)
        return convert_locations_to_tags(locations, tag_kind)
    end
end

return {
    get_tags_of_provider = get_tags_of_provider
}
