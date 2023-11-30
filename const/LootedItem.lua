-- Clase para almacenar los datos de los items
LootedItem = {}
local LootedItem_metatab = {}
function LootedItem.new(name, value, amount, texture)
    local info = {}
    info.name = name
    info.value = value
    info.amount = amount
    info.texture = texture
    setmetatable(info, LootedItem_metatab)
    return info
end

function LootedItem.getName(which)
    return which.name
end

function LootedItem.getValue(which)
    return which.value
end

function LootedItem.getAmount(which)
    return which.amount
end

function LootedItem.getTexture(which)
    return which.texture
end

LootedItem_metatab.__index = LootedItem
