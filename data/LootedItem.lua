---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_LootedItem
local LootedItem = {}
MoneyLooter.LootedItem = LootedItem

function LootedItem.new(id, itemLink, value, quantity)
    local self = {}
    self.id = id
    self.name = itemLink
    self.value = value
    self.amount = quantity

    return self
end
