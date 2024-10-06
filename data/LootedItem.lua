---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_LootedItem
local LootedItem = {}
MoneyLooter.LootedItem = LootedItem

---@param id integer
---@param itemLink string
---@param value integer
---@param quantity integer
---@param isSummary boolean?
function LootedItem.new(id, itemLink, value, quantity, isSummary)
    local self = {}
    self.id = id
    self.itemLink = itemLink
    self.value = value
    self.quantity = quantity
    self.isSummary = isSummary or false

    return self
end
