-- Author      : Will0w7
-- Utils --

-- https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
function table.shallow_copy(t)
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = v
    end
    return t2
end
