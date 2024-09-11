---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_LootedItem
local LootedItem = {}
MoneyLooter.LootedItem = LootedItem

function LootedItem.new(id, itemLink, value, quantity)
    local self = {}
    self.id = id
    self.itemLink = itemLink
    self.value = value
    self.quantity = quantity

    return self
end
