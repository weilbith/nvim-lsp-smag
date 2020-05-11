local M = {}

function M.extend(list_a, list_b)
    for _, entry in ipairs(list_b) do
        table.insert(list_a, entry)
    end

    return list_a
end

function M.index_of(list, target)
    for index, entry in ipairs(list) do
        if entry == target then
            return index
        end
    end

    return 0
end

function M.reverse(list)
    local reversed_list = {}

    for index, entry in ipairs(list) do
        reversed_list[#list + 1 - index] = entry
    end

    return reversed_list
end

return M
