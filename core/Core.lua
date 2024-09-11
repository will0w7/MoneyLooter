---@class MoneyLooter
local MoneyLooter = select(2, ...)

local Constants = MoneyLooter.Constants

local LootedItem = MoneyLooter.LootedItem

------------------------------------------------------------------------------
local TSM_API = TSM_API
local AUCTIONATOR_API = Auctionator and Auctionator.API and Auctionator.API.v1
------------------------------------------------------------------------------
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetMoney, GetUnitName = GetMoney, GetUnitName
local strsplit, tonumber, ipairs = strsplit, tonumber, ipairs
------------------------------------------------------------------------------

local GetTSMPrice = {
    [0] = function(_, _, sellPrice)
        return sellPrice or 0
    end,
    [1] = function(isCraftingReagent, tsmItemString, _)
        local value = TSM_API.GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= GetMinPrice1() or isCraftingReagent) then return value end
        return 0
    end,
    [2] = function(isCraftingReagent, tsmItemString, _)
        local value = TSM_API.GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= GetMinPrice2() or isCraftingReagent) then return value end
        return 0
    end,
    [3] = function(isCraftingReagent, tsmItemString, _)
        local value = TSM_API.GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= GetMinPrice3() or isCraftingReagent) then return value end
        return 0
    end,
    [4] = function(isCraftingReagent, tsmItemString, _)
        local value = TSM_API.GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= GetMinPrice4() or isCraftingReagent) then return value end
        return 0
    end,
    [-1] = function(_, _, sellPrice)
        return sellPrice or 0
    end
}

local GetAucPrice = {
    [0] = function(_, _, sellPrice)
        return sellPrice
    end,
    [1] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= GetMinPrice1() or isCraftingReagent) then return value end
        return 0
    end,
    [2] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= GetMinPrice2() or isCraftingReagent) then return value end
        return 0
    end,
    [3] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= GetMinPrice3() or isCraftingReagent) then return value end
        return 0
    end,
    [4] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= GetMinPrice4() or isCraftingReagent) then return value end
        return 0
    end,
    [-1] = function(_, _, sellPrice)
        return sellPrice or 0
    end
}

function CalculatePriceTSM(quality, sellPrice, itemLink, isCraftingReagent)
    if TSM_API == nil then return 0 end
    local tsmItemString = TSM_API.ToItemString(itemLink)
    if tsmItemString == nil then return 0 end

    local price = 0
    if GetTSMPrice[quality] then
        price = GetTSMPrice[quality](isCraftingReagent, tsmItemString, sellPrice)
    else
        price = GetTSMPrice[-1](isCraftingReagent, tsmItemString, sellPrice)
    end
    return price
end

function CalculatePriceAuc(quality, sellPrice, itemLink, isCraftingReagent)
    if AUCTIONATOR_API == nil then return 0 end

    local price = 0
    if GetAucPrice[quality] then
        price = GetAucPrice[quality](isCraftingReagent, itemLink, sellPrice)
    else
        price = GetAucPrice[-1](isCraftingReagent, itemLink, sellPrice)
    end
    return price
end

function CalculatePrice(itemLink)
    if itemLink == nil then return end

    local itemString = string.match(itemLink, "item[%-?%d:]+")
    local itemName, _, quality, _, _, _, _, _, _, _, sellPrice, _, _, _, _, _, isCraftingReagent =
        GetItemInfo(itemString)
    local price = 0
    price = CalculatePriceTSM(quality, sellPrice, itemLink, isCraftingReagent)
    if not TSM_API and price == 0 then
        price = CalculatePriceAuc(quality, sellPrice, itemLink, isCraftingReagent)
    end
    if price == 0 then
        price = sellPrice or 0
    end
    return price, itemName
end

function GetLinkAndQuantityLoot(lootString)
    for _, pattern in ipairs(Constants.PATTERNS_SELF) do
        local itemLink, quantity = string.match(lootString, pattern)
        if itemLink then return itemLink, tonumber(quantity) or 1 end
    end
    return nil
end

function GetLinkAndQuantityCraft(craftString)
    for _, pattern in ipairs(Constants.PATTERNS_CRAFT) do
        local itemLink, _ = string.match(craftString, pattern)
        if itemLink then return itemLink end --, tonumber(quantity) or 1 end
    end
    return nil
end

function LootEventHandler(self, event, ...)
    if event == Constants.Events.ChatMsgLoot then
        if IsInteractionPaused() then return end

        local lootString, _, _, _, playerName2 = ...
        if lootString == nil then return end

        if GetLinkAndQuantityCraft(lootString) then return end

        local playerName, _ = GetUnitName("player")
        local playerNameFromPN2, _ = strsplit('-', playerName2, 2)
        if playerName ~= playerNameFromPN2 then return end

        local itemLink, quantity = GetLinkAndQuantityLoot(lootString)
        if itemLink == nil then return end

        local price, itemName = CalculatePrice(itemLink)
        if price == nil then return end

        if (string.len(itemName) > 30) then itemName = string.sub(itemName, 1, 30) .. "..." end

        local totalPrice = price * quantity
        local itemID = GetItemInfoFromHyperlink(itemLink)
        local i = LootedItem.new(itemID, itemLink, totalPrice, quantity)
        InsertLootedItem(i)
        AddItemsMoney(totalPrice)
        AddTotalMoney(totalPrice)
        -- only price of individual items, not groups (1xBismuth not 5xBismuth)
        SetPriciest(price, itemID)
        MoneyLooterUpdateLoot()
    elseif event == Constants.Events.ChatMsgMoney or event == Constants.Events.QuestTurnedIn then
        -- here we dont stop interaction, if we turn in a quest with a profession
        -- window opened, we want to register the money change
        local newMoney = GetMoney()
        local change = (newMoney - GetOldMoney())
        AddRawGold(change)
        AddTotalMoney(change)
        SetOldMoney(newMoney)
        UpdateRawGold()
    elseif event == Constants.Events.PInteractionManagerShow then
        local interaction = ...
        if Constants.RelevantInteractions[interaction] then
            SetInteractionPaused(true)
        end
    elseif event == Constants.Events.PInteractionManagerHide then
        local interaction = ...
        if Constants.RelevantInteractions[interaction] then
            SetInteractionPaused(false)
            SetOldMoney(GetMoney())
        end
    end
end
