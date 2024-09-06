-- Author      : Will0w7
-- MoneyLooterCore --

------------------------------------------------------------------------------
local TSM_API = TSM_API
local AUCTIONATOR_API = Auctionator and Auctionator.API and Auctionator.API.v1
------------------------------------------------------------------------------
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetMoney = GetMoney
local GetUnitName = GetUnitName
local strsplit = strsplit
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
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(ML_STRINGS.ML_ADDON_NAME, itemLink)
        if value ~= nil and (value >= GetMinPrice1() or isCraftingReagent) then return value end
        return 0
    end,
    [2] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(ML_STRINGS.ML_ADDON_NAME, itemLink)
        if value ~= nil and (value >= GetMinPrice2() or isCraftingReagent) then return value end
        return 0
    end,
    [3] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(ML_STRINGS.ML_ADDON_NAME, itemLink)
        if value ~= nil and (value >= GetMinPrice3() or isCraftingReagent) then return value end
        return 0
    end,
    [4] = function(isCraftingReagent, itemLink, _)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(ML_STRINGS.ML_ADDON_NAME, itemLink)
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

function LootEventHandler(self, event, ...)
    if event == ML_EVENTS.MerchantUpdate then
        SetOldMoney(GetMoney())
    elseif event == ML_EVENTS.ChatMsgMoney then
        local newmoney = GetMoney()
        local change = (newmoney - GetOldMoney())
        AddRawGold(change)
        AddTotalMoney(change)
        SetOldMoney(newmoney)
    elseif event == ML_EVENTS.ChatMsgLoot then
        local lootstring, _, _, _, p2 = ...
        if lootstring == nil then return end

        local p0, _ = GetUnitName("player")
        local p1, _ = strsplit('-', p2, 2)
        if p0 ~= p1 then return end

        local itemLink = string.match(lootstring, "|%x+|Hitem:.-|h.-|h|r")
        if itemLink == nil then return end

        local itemString = string.match(itemLink, "item[%-?%d:]+")
        local itemName, _, quality, _, _, _, _, _, _, _, sellPrice, _, _, _, _, _, isCraftingReagent =
            GetItemInfo(itemString)

        local amount = string.match(lootstring, "x(%d+)%p") or 1
        if amount == nil then amount = 1 end
        if (string.len(itemName) > 30) then itemName = string.sub(itemName, 1, 30) .. "..." end

        local price = 0
        price = CalculatePriceTSM(quality, sellPrice, itemLink, isCraftingReagent)
        if price == 0 then
            price = CalculatePriceAuc(quality, sellPrice, itemLink, isCraftingReagent)
        end
        if price == 0 then
            price = sellPrice or 0
        end
        price = price * amount
        AddItemsMoney(price)
        local itemID = GetItemInfoFromHyperlink(itemLink)
        local i = LootedItem.new(itemID, itemLink, price, amount)
        InsertLootedItem(i)
        SetPriciest(price, itemID)
        AddTotalMoney(price)
        MoneyLooterUpdateLoot()
    end
end
