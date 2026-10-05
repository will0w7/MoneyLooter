---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_LootedItem
local LootedItem = MoneyLooter.LootedItem
---@class ML_Data
local Data = MoneyLooter.Data
---@class ML_Profiler
local Profiler = MoneyLooter.Profiler
---@class ML_Appearance
local Appareance = MoneyLooter.Appearance

---@class ML_Core
local Core = {}
MoneyLooter.Core = Core

------------------------------------------------------------------------------
local TSMApi = TSM_API
local AuctionatorApi = Auctionator and Auctionator.API and Auctionator.API.v1
local AuctioneerApi = Auctioneer
local RECrystallize_PriceCheck = RECrystallize_PriceCheck
local OEMarketInfo = OEMarketInfo
------------------------------------------------------------------------------
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetMoney, GetUnitName, GetTime = GetMoney, GetUnitName, GetTime
local tonumber, strsplit, unpack = tonumber, strsplit, unpack
local str_match = string.match
------------------------------------------------------------------------------
local TSM_ToItemString = TSMApi and TSMApi.ToItemString
local TSM_GetCustomPriceValue = TSMApi and TSMApi.GetCustomPriceValue
local AUCTIONATOR_GetAuctionPriceByItemLink = AuctionatorApi and AuctionatorApi.GetAuctionPriceByItemLink
local AUCTIONATOR_GetDisenchantPriceByItemLink = AuctionatorApi and AuctionatorApi.GetDisenchantPriceByItemLink
------------------------------------------------------------------------------
local Measure = Profiler.Measure
local LootedItemNew = LootedItem.New
------------------------------------------------------------------------------
local IsInteractionPaused = Data.IsInteractionPaused
local NextLootEntryId = Data.NextLootEntryId
local InsertLootedItem = Data.InsertLootedItem
local AddItemsMoney = Data.AddItemsMoney
local AddTotalMoney = Data.AddTotalMoney
local SetPriciest = Data.SetPriciest
local GetForceVendorPrice = Data.GetForceVendorPrice
local GetCurrentTSMString = Data.GetCurrentTSMString
local GetCurrentTSMDisenchantString = Data.GetCurrentTSMDisenchantString
local GetUseDisenchantValue = Data.GetUseDisenchantValue
local GetForceUseDisenchantValueIndex = Data.GetForceUseDisenchantValueIndex
local GetPriceSource = Data.GetPriceSource
local GetMinPrice = Data.GetMinPrice
local IsQualityManaged = Data.IsQualityManaged
local IsLowQAndWorthIt = Data.IsLowQAndWorthIt
local IsDisenchantable = Data.IsDisenchantable
local IsArmorOrWeapon = Data.IsArmorOrWeapon
local IsJewellery = Data.IsJewellery
local GetOldMoney = Data.GetOldMoney
local AddRawMoney = Data.AddRawMoney
local SetOldMoney = Data.SetOldMoney
local SetInteractionPaused = Data.SetInteractionPaused
local UpdateLoot = MoneyLooter.UI.UpdateLoot
local UpdateRawMoney = MoneyLooter.UI.UpdateRawMoney
local GetAlwaysAuctionUniqueAppareances = Data.GetAlwaysAuctionUniqueAppareances
local GetForceVendorJewellery = Data.GetForceVendorJewellery
------------------------------------------------------------------------------
local playerName = GetUnitName("player")
local itemInfoCache = {}
local itemInfoCacheLink = {}
local priceCache = {}
local CacheTTL = 60 * 60
------------------------------------------------------------------------------
local patternsSelf = Constants.PatternsSelf
local patternsCraft = Constants.PatternsCraft
local patternsLength = #patternsSelf
local patternsCraftLength = #patternsCraft
------------------------------------------------------------------------------

---@param itemLink string
---@return integer
---@return integer
local function GetCachedPrice(itemLink)
    local entry = priceCache[itemLink]
    if not entry then return 0, Constants.ItemAction.Scan end

    if entry.expires > GetTime() then
        return entry.price, entry.action
    end

    priceCache[itemLink] = nil
    return 0, Constants.ItemAction.Scan
end

---@param itemLink string
---@param price integer
---@param action integer
local function SetCachedPrice(itemLink, price, action)
    priceCache[itemLink] = {
        price = price,
        action = action,
        expires = GetTime() + CacheTTL,
    }
end

function Core.ClearPriceCache()
    table.wipe(priceCache)
end

---@param itemString string
local function GetCachedItemInfo(itemString)
    local info = itemInfoCache[itemString]
    if not info then
        local _, _, itemQuality, _, _, _, _, _, itemEquipLoc, _, sellPrice, classID, subclassID, _, _, _, _ =
            GetItemInfo(itemString)
        if itemQuality == nil or classID == nil then
            return nil
        end
        info = { itemQuality, sellPrice, classID, itemEquipLoc, subclassID }
        itemInfoCache[itemString] = info
    end
    return unpack(info)
end

---@param itemString string
local function GetCachedItemInfoFromHyperlink(itemString)
    local info = itemInfoCacheLink[itemString]
    if not info then
        info = GetItemInfoFromHyperlink(itemString)
        itemInfoCacheLink[itemString] = info
    end
    return info
end

local priceSources = {
    [Constants.PriceSources.TradeSkillMaster] = {
        getPrice = function(itemLink)
            if not TSMApi then return nil end
            local tsmItemString = TSM_ToItemString(itemLink)
            return TSM_GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
        end,
        getDisenchantPrice = function(itemLink)
            if not TSMApi then return nil end
            local tsmItemString = TSM_ToItemString(itemLink)
            return TSM_GetCustomPriceValue(GetCurrentTSMDisenchantString(), tsmItemString)
        end,
    },
    [Constants.PriceSources.Auctionator] = {
        getPrice = function(itemLink)
            if not AuctionatorApi then return nil end
            return AUCTIONATOR_GetAuctionPriceByItemLink(Constants.Strings.AddonName, itemLink)
        end,
        getDisenchantPrice = function(itemLink)
            if not AuctionatorApi then return nil end
            return AUCTIONATOR_GetDisenchantPriceByItemLink(Constants.Strings.AddonName, itemLink)
        end,
    },
    [Constants.PriceSources.Auctioneer] = {
        getPrice = function(itemLink)
            if not AuctioneerApi then return nil end
            local itemKey = AuctioneerApi:ItemKeyFromLink(itemLink)
            local stats = AuctioneerApi:Statistics(itemKey)
            local overTime = stats and stats["Stats:OverTime"]
            return overTime and overTime:Best()
        end,
        getDisenchantPrice = function()
            return nil
        end,
    },
    [Constants.PriceSources.OribosExchange] = {
        getPrice = function(itemLink)
            if not (MoneyLooter.isRetail and OEMarketInfo) then return nil end
            local info = {}
            OEMarketInfo(itemLink, info)
            return info.region
        end,
        getDisenchantPrice = function()
            return nil
        end,
    },
    [Constants.PriceSources.RECrystallize] = {
        getPrice = function(itemLink)
            if not (MoneyLooter.isRetail and RECrystallize_PriceCheck) then return nil end
            return RECrystallize_PriceCheck(itemLink)
        end,
        getDisenchantPrice = function()
            return nil
        end,
    },
}

---@param itemLink string
---@return integer price
---@return integer action
function Core.CalculatePrice(itemLink)
    if not itemLink then return 0, Constants.ItemAction.CanBeOpened end

    local cachedPrice, cachedAction = GetCachedPrice(itemLink)
    if cachedAction ~= Constants.ItemAction.Scan then return cachedPrice, cachedAction end

    local itemString = str_match(itemLink, "item[%-%d:]+")
    local quality, sellPrice, classID, equipLoc, subclassID =
        Measure("GetCachedItemInfo", GetCachedItemInfo, itemString)

    -- print("itemLink" .. itemLink)
    -- print("classID" .. classID)
    -- print("subclassID" .. subclassID)

    -- lockboxes are considered junk, so we need to ignore them by name
    -- same with pouchs (like Stuffed Deviate Scale Pouch)
    if classID == Constants.ItemClass.Miscellaneous and subclassID == Constants.ItemSubclass.Junk then
        if itemLink:find("Lockbox") or itemLink:find("Pouch") then
            return 0, Constants.ItemAction.CanBeOpened
        end
    end

    if quality == nil or classID == nil then
        return 0, Constants.ItemAction.Invalid
    end

    local isArmorOrWeapon = IsArmorOrWeapon(classID)
    local ignoreThreshold = not isArmorOrWeapon
    local sellPriceOrZero = sellPrice or 0

    local function cacheAndReturn(price, action)
        local savePrice = price or 0
        SetCachedPrice(itemLink, savePrice, action)
        return savePrice, action
    end

    -- not a valid quality and not reagent, tradegoods or quest item
    if not IsQualityManaged(quality, classID) and not IsLowQAndWorthIt(quality, classID) then
        return cacheAndReturn(sellPriceOrZero, Constants.ItemAction.Sell)
    end

    local source = priceSources[GetPriceSource()] or priceSources[Constants.PriceSources.TradeSkillMaster]

    -- ignore the minimum thresholds
    if ignoreThreshold then
        local price = Measure("CalculatePrice.ExtApi.Reagent", source.getPrice, itemLink)
        if price and price > 0 then
            return cacheAndReturn(price, Constants.ItemAction.Auction)
        end
        return cacheAndReturn(sellPriceOrZero, Constants.ItemAction.Sell)
    end

    -- force vendor price for items following the thresholds
    if GetForceVendorPrice() then
        return cacheAndReturn(sellPriceOrZero, Constants.ItemAction.ForceSell)
    end

    local forceDisenchant = GetForceUseDisenchantValueIndex(quality)
    local useDisenchant = GetUseDisenchantValue()
    local isDisenchantable = IsDisenchantable(quality, classID, equipLoc)
    local alwaysAuctionUniqueAppareances = GetAlwaysAuctionUniqueAppareances()
    local forceVendorJewellery = GetForceVendorJewellery()
    local isJewellery = IsJewellery(subclassID)
    local isUnique = Appareance.IsUniqueAppearance(itemLink)

    -- disenchant it?
    if isDisenchantable and (useDisenchant or forceDisenchant) then
        local disenchantPrice = Measure("CalculatePrice.ExtApi.Disenchant", source.getDisenchantPrice, itemLink)
        if disenchantPrice and disenchantPrice > 0 then
            return cacheAndReturn(disenchantPrice, Constants.ItemAction.Disenchant)
        end
    end

    -- force vendor price for jewellery
    if forceVendorJewellery and isArmorOrWeapon and isJewellery then
        return cacheAndReturn(sellPriceOrZero, Constants.ItemAction.Sell)
    end

    -- get the price from the selected addon
    if not isDisenchantable or not forceDisenchant then
        local price = Measure("CalculatePrice.ExtApi.Normal", source.getPrice, itemLink)
        local icon = Constants.ItemAction.Auction

        if isUnique then
            icon = Constants.ItemAction.AuctionUnique

            if alwaysAuctionUniqueAppareances then
                return cacheAndReturn(price, Constants.ItemAction.AuctionUnique)
            end
        end

        if price and price >= GetMinPrice(quality) then
            return cacheAndReturn(price, icon)
        end
    end

    return cacheAndReturn(sellPriceOrZero, Constants.ItemAction.Sell)
end

---@param lootString string
---@return string|nil
---@return number|nil
local function GetLinkAndQuantityLoot(lootString)
    for i = 1, patternsLength do
        local pattern = patternsSelf[i]
        local item, quantity = str_match(lootString, pattern)
        if item then
            return item, tonumber(quantity) or 1
        end
    end
end

---@param craftString string
---@return string|nil
local function GetLinkAndQuantityCraft(craftString)
    for i = 1, patternsCraftLength do
        local pattern = patternsCraft[i]
        local item = str_match(craftString, pattern)
        if item then return item end
    end
    return nil
end

---@param receivedString string
---@return boolean
local function ReceivedMoney(receivedString)
    local received = str_match(receivedString, Constants.PatternsReceived[1])
    return received ~= nil
end


---@param lootString string
---@param playerName2 string
local function ChatMsgLoot(_, _, lootString, _, _, _, playerName2)
    if IsInteractionPaused() then return end
    if lootString == nil then return end
    if GetLinkAndQuantityCraft(lootString) then return end

    local playerNameFromPN2, _ = strsplit("-", playerName2, 2)
    if playerName ~= playerNameFromPN2 then return end

    local itemLink, quantity = GetLinkAndQuantityLoot(lootString)
    if itemLink == nil or itemLink:find("battlepet:") then return end

    local price, action = Measure("CalculatePrice", Core.CalculatePrice, itemLink)
    if action == Constants.ItemAction.Invalid then return end

    local totalPrice = price * quantity
    local itemID = Measure("GetCachedItemInfoFromHyperlink", GetCachedItemInfoFromHyperlink, itemLink)
    local i = LootedItemNew(NextLootEntryId(), itemID, itemLink, price, quantity, action)
    InsertLootedItem(i)
    AddItemsMoney(totalPrice)
    AddTotalMoney(totalPrice)
    -- only price of individual items, not groups (1xBismuth not 5xBismuth)
    SetPriciest(price, itemLink)
    Measure("UpdateLoot", UpdateLoot, i)
end

local function ChatMsgMoney_QuestTurnedIn()
    -- here we dont stop interaction, if we turn in a quest with a profession
    -- window opened, we want to register the money change
    local newMoney = GetMoney()
    local change = (newMoney - GetOldMoney())
    AddRawMoney(change)
    AddTotalMoney(change)
    SetOldMoney(newMoney)
    UpdateRawMoney()
end

---@param receivedString string
local function ChatMsgSystem(_, _, receivedString)
    if not ReceivedMoney(receivedString) then return end
    local newMoney = GetMoney()
    local change = (newMoney - GetOldMoney())
    AddRawMoney(change)
    AddTotalMoney(change)
    SetOldMoney(newMoney)
    UpdateRawMoney()
end

---@param interaction Enum.PlayerInteractionType
local function PInteractionManagerShow(_, _, interaction)
    if Constants.RelevantInteractions[interaction] then
        SetInteractionPaused(true)
    end
end

---@param interaction Enum.PlayerInteractionType
local function PInteractionManagerHide(_, _, interaction)
    if Constants.RelevantInteractions[interaction] then
        SetInteractionPaused(false)
        SetOldMoney(GetMoney())
    end
end

---@param event WowEvent
function Core.OnEvent(_, event, ...)
    if event == Constants.Events.ChatMsgLoot then
        Measure(event, ChatMsgLoot, nil, event, ...)
    elseif event == Constants.Events.ChatMsgMoney or event == Constants.Events.QuestTurnedIn then
        Measure(event, ChatMsgMoney_QuestTurnedIn)
    elseif event == Constants.Events.ChatMsgSystem then
        Measure(event, ChatMsgSystem, nil, event, ...)
    elseif event == Constants.Events.PInteractionManagerShow then
        Measure(event, PInteractionManagerShow, nil, event, ...)
    elseif event == Constants.Events.PInteractionManagerHide then
        Measure(event, PInteractionManagerHide, nil, event, ...)
    end
end
