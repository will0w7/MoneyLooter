-- Author      : Will0w7
-- Data --

LootedItem = {}
local LootedItem_metatab = {}
function LootedItem.new(id, name, value, amount)
    local info = {}
    info.id = id
    info.name = name
    info.value = value
    info.amount = amount
    setmetatable(info, LootedItem_metatab)
    return info
end

LootedItem_metatab.__index = LootedItem
