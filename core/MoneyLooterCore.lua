-- Author      : Will0w7
-- MoneyLooter --

-----------------------------------------------------
local TSM_API = TSM_API
local AUCTIONATOR_API = Auctionator.API.v1
-----------------------------------------------------
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
-----------------------------------------------------

local function OnMoneyLoot(self, event, ...)
    if event == ML_EVENTS.ChatMsgMoney and GetRecordLoot() == true then
        local newmoney = GetMoney()
        local change = (newmoney - GetOldMoney())
        AddRawMoney(change)
        AddTotalMoney(change)
        SetOldMoney(GetMoney())
    end
end

local function OnItemLoot(self, event, ...)
    if event == ML_EVENTS.ChatMsgLoot and GetRecordLoot() then
        local lootstring, _, _, _, p2 = ...
        local p0, _ = GetUnitName("player")
        local p1, _ = strsplit('-', p2, 2)

        if p0 ~= p1 then return end
        if lootstring == nil then return false end

        local itemLink = string.match(lootstring, "|%x+|Hitem:.-|h.-|h|r")
        if itemLink == nil then return false end

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
        SetUpdate(true)
        AddTotalMoney(price)
    end
end

function CalculatePriceTSM(quality, sellPrice, itemLink, isCraftingReagent)
    if TSM_API == nil then return 0 end
    local tsmItemString = TSM_API.ToItemString(itemLink)
    if tsmItemString == nil then return 0 end

    local price = 0
    local switch = {
        [0] = function()
            return sellPrice
        end,
        [1] = function()
            local tsm = TSM_API.GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
            if tsm ~= nil and (tsm >= GetMinPrice1() or isCraftingReagent) then price = tsm end
            return price
        end,
        [2] = function()
            local tsm = TSM_API.GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
            if tsm ~= nil and (tsm >= GetMinPrice2() or isCraftingReagent) then price = tsm end
            return price
        end,
        [3] = function()
            local tsm = TSM_API.GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
            if tsm ~= nil and (tsm >= GetMinPrice3() or isCraftingReagent) then price = tsm end
            return price
        end,
        [4] = function()
            local tsm = TSM_API.GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
            if tsm ~= nil and (tsm >= GetMinPrice4() or isCraftingReagent) then price = tsm end
            return price
        end,
        [-1] = function()
            return sellPrice or 0
        end
    }

    if switch[quality] then price = switch[quality]() else price = switch[-1]() end
    return price
end

function CalculatePriceAuc(quality, sellPrice, itemLink, isCraftingReagent)
    if AUCTIONATOR_API == nil then return 0 end

    local price = 0
    local switch = {
        [0] = function()
            return sellPrice
        end,
        [1] = function()
            local auc = AUCTIONATOR_API.GetAuctionPriceByItemLink(ML_STRINGS.ML_ADDON_NAME, itemLink)
            if auc ~= nil and (auc >= GetMinPrice1() or isCraftingReagent) then price = auc end
            return price
        end,
        [2] = function()
            local auc = AUCTIONATOR_API.GetAuctionPriceByItemLink(ML_STRINGS.ML_ADDON_NAME, itemLink)
            if auc ~= nil and (auc >= GetMinPrice2() or isCraftingReagent) then price = auc end
            return price
        end,
        [3] = function()
            local auc = AUCTIONATOR_API.GetAuctionPriceByItemLink(ML_STRINGS.ML_ADDON_NAME, itemLink)
            if auc ~= nil and (auc >= GetMinPrice3() or isCraftingReagent) then price = auc end
            return price
        end,
        [4] = function()
            local auc = AUCTIONATOR_API.GetAuctionPriceByItemLink(ML_STRINGS.ML_ADDON_NAME, itemLink)
            if auc ~= nil and (auc >= GetMinPrice4() or isCraftingReagent) then price = auc end
            return price
        end,
        [-1] = function()
            return sellPrice or 0
        end
    }

    if switch[quality] then price = switch[quality]() else price = switch[-1]() end
    return price
end

function OnSellAction(self, event, ...)
    if event == ML_EVENTS.MerchantUpdate and GetRecordLoot() == true then
        SetOldMoney(GetMoney())
    end
end

local moneyLoot = CreateFrame("Frame")
moneyLoot:RegisterEvent(ML_EVENTS.ChatMsgMoney)
moneyLoot:SetScript(ML_EVENTS.OnEvent, OnMoneyLoot)

local itemLoot = CreateFrame("Frame")
itemLoot:RegisterEvent(ML_EVENTS.ChatMsgLoot)
itemLoot:SetScript(ML_EVENTS.OnEvent, OnItemLoot)

local sellAction = CreateFrame("Frame")
sellAction:RegisterEvent(ML_EVENTS.PlayerMoney)
sellAction:RegisterEvent(ML_EVENTS.MerchantUpdate)
sellAction:SetScript(ML_EVENTS.OnEvent, OnSellAction)
