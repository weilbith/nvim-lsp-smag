local vim = vim
local lsp = vim.lsp
local api = vim.api

local M = {}

local function get_path(uri)
    local absolute_path = vim.uri_to_fname(uri)
    local working_directory = api.nvim_call_function("getcwd", {}) .. "/"
    -- The string.gsub/find functions do not work with the slashes in the path.
    local maybe_relative_path = api.nvim_call_function("substitute", {absolute_path, working_directory, "", ""})
    return maybe_relative_path
end

local function read_line(uri, line_index)
    local file_path = vim.uri_to_fname(uri)
    local lines = api.nvim_call_function("readfile", {file_path, "", line_index})
    return lines[line_index]
end

local function line_byte_from_position(uri, position)
    local col = position.character
    if col > 0 then
        local line = position.line
        local lines
        local bufnr = vim.uri_to_bufnr(uri)
        if api.nvim_buf_is_loaded(bufnr) then
            lines = api.nvim_buf_get_lines(bufnr, line, line + 1, false)
        else
            local file_path = vim.uri_to_fname(uri)
            lines = api.nvim_call_function("readfile", {file_path, "", line + 1})
            lines = {lines[line + 1]}
        end

        if #lines > 0 then
            local ok, result = pcall(vim.str_byteindex, lines[1], col)

            if ok then
                return result
            end
        end
    end
    return col
end

function M.lsp_location_to_tag(name, kind, lsp_location)
    local uri = lsp_location.uri or lsp_location.targetUri
    local range = lsp_location.range or lsp_location.targetRange
    local line = range.start.line + 1
    local col = line_byte_from_position(uri, range.start)

    return {
        name = name,
        cmd = '/\\%' .. tostring(line) .. 'l\\%' .. tostring(col+1) .. 'c/',
        kind = kind .. " ", -- add a gap to the tag name
        filename = get_path(uri),
        user_data = read_line(uri, line)
    }
end

return M
