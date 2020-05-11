local vim = vim
local api = vim.api
local lsp = vim.lsp
local tag_formatting = require "lsp_smag.tags.formatting"
local list_utils = require "lsp_smag.utils.lists"
local lsp_methods = require "lsp_smag.lsp.methods"
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

local function get_locations_from_server(method)
    local buffer_number = api.nvim_get_current_buf()
    local parameter = lsp.util.make_position_params()
    -- TODO: verify that server provides capability
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
    local lsp_method = lsp_methods[provider_name]
    local tag_kind = tag_kinds[provider_name]
    local locations = get_locations_from_server(lsp_method)
    return convert_locations_to_tags(locations, tag_kind)
end

return {
    get_tags_of_provider = get_tags_of_provider
}
