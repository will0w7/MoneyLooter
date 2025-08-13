---@class MoneyLooter
local MoneyLooter = select(2, ...)
---@class ML_LootedItem
local LootedItem = MoneyLooter.LootedItem

---@class ML_Summary
local Summary = {}
MoneyLooter.Summary = Summary

---@class ML_SMFunctions
local SMFunctions = {}
MoneyLooter.SMFunctions = SMFunctions

---------------------------------------------------------
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local pairs = pairs
---------------------------------------------------------

---@param summary table
---@param itemLink string
---@param quantity integer
---@param value integer
function SMFunctions.Insert(summary, itemLink, quantity, value)
    if summary[itemLink] == nil then
        summary[itemLink] = { [1] = quantity, [2] = value }
        return
    end
    summary[itemLink][1] = summary[itemLink][1] + quantity
    summary[itemLink][2] = value
    return summary
end

---@param summary table
---@param lootedItem ML_LootedItem
function SMFunctions.InsertLootedItem(summary, lootedItem)
    return SMFunctions.Insert(summary, lootedItem.itemLink, lootedItem.quantity, lootedItem.value)
end

---@param summary table
---@return table
function SMFunctions.GetTopItems(summary)
    local topItems = {}
    for itemLink, item in pairs(summary) do
        local itemID = GetItemInfoFromHyperlink(itemLink)
        local quantity = item[1]
        local value = item[2]
        local lootedItem = LootedItem.new(itemID, itemLink, value, quantity)
        table.insert(topItems, lootedItem)
    end
    table.sort(topItems, function(a, b)
        return a.value * a.quantity > b.value * b.quantity
    end)

    return topItems
end
