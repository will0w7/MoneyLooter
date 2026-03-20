---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_LootedItem
local LootedItem = {}
MoneyLooter.LootedItem = LootedItem

---@param entryId integer|nil
---@param id integer
---@param itemLink string
---@param value integer
---@param quantity integer
---@return ML_Item
function LootedItem.new(entryId, id, itemLink, value, quantity)
    local self = {}
    self.entryId = entryId
    self.id = id
    self.itemLink = itemLink
    self.value = value
    self.quantity = quantity

    return self
end

---@class ML_Item
---@field entryId integer|nil
---@field id integer
---@field itemLink string
---@field value integer
---@field quantity integer
