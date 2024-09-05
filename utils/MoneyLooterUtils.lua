-- Author      : Will0w7
-- MoneyLooterUtils --

-- https://gist.github.com/tylerneylon/81333721109155b2d244
function table.shallow_copy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[table.shallow_copy(k)] = table.shallow_copy(v) end
    return res
end

-- https://gist.github.com/tylerneylon/81333721109155b2d244
function table.deep_copy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[table.deep_copy(k)] = table.deep_copy(v) end
    return res
end

-- https://gist.github.com/tylerneylon/81333721109155b2d244
function table.deep_copy_meta(obj)
    if type(obj) ~= 'table' then return obj end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do res[table.deep_copy_meta(k)] = table.deep_copy_meta(v) end
    return res
end

function CreateTextureFromItemID(itemId)
    return ("|T%s:0|t"):format(tostring(C_Item.GetItemIconByID(itemId)));
end