---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_LootedItem
local LootedItem = MoneyLooter.LootedItem
---@class ML_Data
local Data = MoneyLooter.Data

---@class ML_Core
local Core = {}
MoneyLooter.Core = Core

------------------------------------------------------------------------------
local TSM_API = TSM_API
local AUCTIONATOR_API = Auctionator and Auctionator.API and Auctionator.API.v1
------------------------------------------------------------------------------
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetMoney, GetUnitName = GetMoney, GetUnitName
local tonumber, ipairs = tonumber, ipairs
------------------------------------------------------------------------------

local GetTSMPrice = {
    ---@param sellPrice integer
    [0] = function(_, _, sellPrice)
        return sellPrice or 0
    end,
    ---@param isCraftingReagent boolean
    ---@param tsmItemString string
    [1] = function(isCraftingReagent, tsmItemString, _)
        local value = TSM_API.GetCustomPriceValue(Data.GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= Data.GetMinPrice1() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param tsmItemString string
    [2] = function(isCraftingReagent, tsmItemString, _)
        local value = TSM_API.GetCustomPriceValue(Data.GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= Data.GetMinPrice2() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param tsmItemString string
    [3] = function(isCraftingReagent, tsmItemString, _)
        local value = TSM_API.GetCustomPriceValue(Data.GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= Data.GetMinPrice3() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param tsmItemString string
    [4] = function(isCraftingReagent, tsmItemString, _)
        local value = TSM_API.GetCustomPriceValue(Data.GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= Data.GetMinPrice4() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param sellPrice integer
    [-1] = function(_, _, sellPrice)
        return sellPrice or 0
    end
}

---@
local GetAucPrice = {
    ---@param sellPrice integer
    [0] = function(_, _, sellPrice)
        return sellPrice
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [1] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= Data.GetMinPrice1() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [2] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= Data.GetMinPrice2() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [3] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= Data.GetMinPrice3() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [4] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= Data.GetMinPrice4() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param sellPrice integer
    [-1] = function(_, _, sellPrice)
        return sellPrice or 0
    end
}

---@param quality integer
---@param sellPrice integer
---@param itemLink string
---@param isCraftingReagent boolean
local function CalculatePriceTSM(quality, sellPrice, itemLink, isCraftingReagent)
    if TSM_API == nil then return 0 end
    local tsmItemString = TSM_API.ToItemString(itemLink)
    if tsmItemString == nil then return 0 end

    local price
    if GetTSMPrice[quality] then
        price = GetTSMPrice[quality](isCraftingReagent, tsmItemString, sellPrice)
    else
        price = GetTSMPrice[-1](isCraftingReagent, tsmItemString, sellPrice)
    end
    return price
end

---@param quality integer
---@param sellPrice integer
---@param itemLink string
---@param isCraftingReagent boolean
local function CalculatePriceAuc(quality, sellPrice, itemLink, isCraftingReagent)
    if AUCTIONATOR_API == nil then return 0 end

    local price
    if GetAucPrice[quality] then
        price = GetAucPrice[quality](isCraftingReagent, itemLink, sellPrice)
    else
        price = GetAucPrice[-1](isCraftingReagent, itemLink, sellPrice)
    end
    return price
end

---@param itemLink string
local function CalculatePrice(itemLink)
    if itemLink == nil then return end

    local itemString = string.match(itemLink, "item[%-?%d:]+")
    local _, _, quality, _, _, _, _, _, _, _, sellPrice, _, _, _, _, _, isCraftingReagent =
        GetItemInfo(itemString)
    local price
    price = CalculatePriceTSM(quality, sellPrice, itemLink, isCraftingReagent)
    if not TSM_API and price == 0 then
        price = CalculatePriceAuc(quality, sellPrice, itemLink, isCraftingReagent)
    end
    if price == 0 then
        price = sellPrice or 0
    end
    return price
end

---@param lootString string
local function GetLinkAndQuantityLoot(lootString)
    for _, pattern in ipairs(Constants.PATTERNS_SELF) do
        local itemLink, quantity = string.match(lootString, pattern)
        if itemLink then return itemLink, tonumber(quantity) or 1 end
    end
    return nil
end

---@param craftString string
local function GetLinkAndQuantityCraft(craftString)
    for _, pattern in ipairs(Constants.PATTERNS_CRAFT) do
        local itemLink, _ = string.match(craftString, pattern)
        if itemLink then return itemLink end --, tonumber(quantity) or 1 end
    end
    return nil
end

---@param event WowEvent
function Core.LootEventHandler(_, event, ...)
    if event == Constants.Events.ChatMsgLoot then
        if Data.IsInteractionPaused() then return end

        local lootString, _, _, _, playerName2 = ...
        if lootString == nil then return end

        if GetLinkAndQuantityCraft(lootString) then return end

        local playerName, _ = GetUnitName("player")
        local playerNameFromPN2, _ = string.split('-', playerName2, 2)
        if playerName ~= playerNameFromPN2 then return end

        local itemLink, quantity = GetLinkAndQuantityLoot(lootString)
        if itemLink == nil then return end

        local price = CalculatePrice(itemLink)
        if price == nil then return end

        local totalPrice = price * quantity
        local itemID = GetItemInfoFromHyperlink(itemLink)
        local i = LootedItem.new(itemID, itemLink, totalPrice, quantity)
        Data.InsertLootedItem(i)
        Data.AddItemsMoney(totalPrice)
        Data.AddTotalMoney(totalPrice)
        -- only price of individual items, not groups (1xBismuth not 5xBismuth)
        Data.SetPriciest(price, itemID)
        UpdateLoot()
    elseif event == Constants.Events.ChatMsgMoney or event == Constants.Events.QuestTurnedIn then
        -- here we dont stop interaction, if we turn in a quest with a profession
        -- window opened, we want to register the money change
        local newMoney = GetMoney()
        local change = (newMoney - Data.GetOldMoney())
        Data.AddRawMoney(change)
        Data.AddTotalMoney(change)
        Data.SetOldMoney(newMoney)
        UpdateRawMoney()
    elseif event == Constants.Events.PInteractionManagerShow then
        local interaction = ...
        if Constants.RelevantInteractions[interaction] then
            Data.SetInteractionPaused(true)
        end
    elseif event == Constants.Events.PInteractionManagerHide then
        local interaction = ...
        if Constants.RelevantInteractions[interaction] then
            Data.SetInteractionPaused(false)
            Data.SetOldMoney(GetMoney())
        end
    end
end
