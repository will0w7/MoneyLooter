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

---@class ML_Core
local Core = {}
MoneyLooter.Core = Core

------------------------------------------------------------------------------
local TSM_API = TSM_API
local AUCTIONATOR_API = Auctionator and Auctionator.API and Auctionator.API.v1
local AUCTIONEER_API = Auctioneer
local RECrystallize_PriceCheck = RECrystallize_PriceCheck
local OEMarketInfo = OEMarketInfo
------------------------------------------------------------------------------
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetMoney, GetUnitName, GetTime = GetMoney, GetUnitName, GetTime
local tonumber, strsplit, unpack, ipairs = tonumber, strsplit, unpack, ipairs
local str_match = string.match
------------------------------------------------------------------------------
local TSM_ToItemString = TSM_API and TSM_API.ToItemString
local TSM_GetCustomPriceValue = TSM_API and TSM_API.GetCustomPriceValue
local AUCTIONATOR_GetAuctionPriceByItemLink = AUCTIONATOR_API and AUCTIONATOR_API.GetAuctionPriceByItemLink
local AUCTIONATOR_GetDisenchantPriceByItemLink = AUCTIONATOR_API and AUCTIONATOR_API.GetDisenchantPriceByItemLink
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
local GetUseDisenchantValue = Data.GetUseDisenchantValue
local GetMinPrice1 = Data.GetMinPrice1
local GetMinPrice2 = Data.GetMinPrice2
local GetMinPrice3 = Data.GetMinPrice3
local GetMinPrice4 = Data.GetMinPrice4
local GetOldMoney = Data.GetOldMoney
local AddRawMoney = Data.AddRawMoney
local SetOldMoney = Data.SetOldMoney
local SetInteractionPaused = Data.SetInteractionPaused
local UpdateLoot = MoneyLooter.UI.UpdateLoot
local UpdateRawMoney = MoneyLooter.UI.UpdateRawMoney
------------------------------------------------------------------------------
local playerName = GetUnitName("player")
local itemInfoCache = {}
local itemInfoCacheLink = {}
local priceCache = {}
local CACHE_TTL = 60 * 60
------------------------------------------------------------------------------
local patternsSelf = Constants.PATTERNS_SELF
local patternsCraft = Constants.PATTERNS_CRAFT
local patternsLength = #patternsSelf
local patternsCraftLength = #patternsCraft
------------------------------------------------------------------------------

---@param itemLink string
local function GetCachedPrice(itemLink)
    local entry = priceCache[itemLink]
    if not entry then return nil end

    if entry.expires > GetTime() then
        return entry.price
    end
    priceCache[itemLink] = nil
    return nil
end

---@param itemLink string
---@param price number
local function SetCachedPrice(itemLink, price)
    priceCache[itemLink] = {
        price = price,
        expires = GetTime() + CACHE_TTL,
    }
end

---@param itemString string
local function GetCachedItemInfo(itemString)
    local info = itemInfoCache[itemString]
    if not info then
        local temp = { GetItemInfo(itemString) }
        info = { temp[3], temp[11], temp[17] }
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

---@param quality number
local function GetMinPrice(quality)
    if quality == 1 then
        return GetMinPrice1()
    elseif quality == 2 then
        return GetMinPrice2()
    elseif quality == 3 then
        return GetMinPrice3()
    elseif quality == 4 then
        return GetMinPrice4()
    end
end

local disenchantPriceSources = {
    {
        cond = false and TSM_API,
        fn   = function(itemLink)
            return 0
        end
    },
    {
        cond = AUCTIONATOR_API,
        fn   = function(itemLink)
            local value = AUCTIONATOR_GetDisenchantPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
            return value
        end
    },
    {
        cond = false and AUCTIONEER_API,
        fn   = function(itemLink)
            return 0
        end
    },
    {
        cond = false and MoneyLooter.isRetail and OEMarketInfo,
        fn   = function(itemLink)
            return 0
        end
    },
    {
        cond = false and MoneyLooter.isRetail and RECrystallize_PriceCheck,
        fn   = function(itemLink)
            return 0
        end
    },
}

local priceSources = {
    {
        cond = TSM_API,
        fn   = function(quality, itemLink, isCraftingReagent)
            local tsmItemString = TSM_ToItemString(itemLink)
            local value = TSM_GetCustomPriceValue(GetCurrentTSMString(), tsmItemString)
            if not value then return 0 end
            local min = GetMinPrice(quality)
            return (value >= min or isCraftingReagent) and value or 0
        end
    },
    {
        cond = AUCTIONATOR_API,
        fn   = function(quality, itemLink, isCraftingReagent)
            local value = AUCTIONATOR_GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)

            if GetUseDisenchantValue() then
                local disenchant = AUCTIONATOR_GetDisenchantPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
                if disenchant ~= nil and value ~= nil and disenchant > value then
                    value = disenchant
                end
            end
            if not value then return 0 end
            local min = GetMinPrice(quality)
            return (value >= min or isCraftingReagent) and value or 0
        end
    },
    {
        cond = AUCTIONEER_API,
        fn   = function(quality, itemLink, isCraftingReagent)
            local itemKey  = AUCTIONEER_API:ItemKeyFromLink(itemLink)
            local stats    = AUCTIONEER_API:Statistics(itemKey)
            local overTime = stats["Stats:OverTime"]
            local value    = (overTime and overTime:Best()) or 0
            if not value then return 0 end
            local min = GetMinPrice(quality)
            return (value >= min or isCraftingReagent) and value or 0
        end
    },
    {
        cond = MoneyLooter.isRetail and OEMarketInfo,
        fn   = function(quality, itemLink, isCraftingReagent)
            local info = {}
            OEMarketInfo(itemLink, info)
            if not info.region then return 0 end
            local value = info.region
            local min = GetMinPrice(quality)
            return (value >= min or isCraftingReagent) and value or 0
        end
    },
    {
        cond = MoneyLooter.isRetail and RECrystallize_PriceCheck,
        fn   = function(quality, itemLink, isCraftingReagent)
            local value = RECrystallize_PriceCheck(itemLink)
            if not value then return 0 end
            local min = GetMinPrice(quality)
            return (value >= min or isCraftingReagent) and value or 0
        end
    },
}

---@param itemLink string
local function CalculatePrice(itemLink)
    if not itemLink then return nil end

    local cached = GetCachedPrice(itemLink)
    if cached then return cached end

    local itemString = str_match(itemLink, "item[%-%d:]+")
    local quality, sellPrice, isCraftingReagent =
        Measure("GetCachedItemInfo", GetCachedItemInfo, itemString)

    local sellPriceOrZero = sellPrice or 0

    if GetForceVendorPrice() then
        SetCachedPrice(itemLink, sellPriceOrZero)
        return sellPriceOrZero
    end

    if quality < 1 or quality > 4 then
        SetCachedPrice(itemLink, sellPriceOrZero)
        return sellPriceOrZero
    end

    local price = 0
    local disenchantPrice = nil
    local forceThisQuality = Data.GetForceUseDisenchantValueIndex(quality) and not isCraftingReagent
    if forceThisQuality and quality ~= 1 then
        for _, src in ipairs(disenchantPriceSources) do
            if src.cond then
                disenchantPrice = Measure("CalculatePriceDisenchant.EXT_API", src.fn, itemLink)
                if disenchantPrice ~= nil and disenchantPrice > 0 then break end
            end
        end
    end
    if disenchantPrice ~= nil and disenchantPrice > 0 then price = disenchantPrice end

    if not forceThisQuality or (forceThisQuality and (disenchantPrice == nil or disenchantPrice == 0)) then
        for i, _ in ipairs(priceSources) do
            if priceSources[i].cond then
                price = Measure("CalculatePrice.EXT_API", priceSources[i].fn, quality, itemLink, isCraftingReagent)
                if Data.GetUseDisenchantValue() and disenchantPriceSources[i].cond then
                    local disenchant = Measure("CalculatePriceDisenchant.EXT_API", disenchantPriceSources[i].fn, itemLink)
                    if disenchant ~= nil and disenchant > price then
                        price = disenchant
                    end
                end
                if price > 0 then break end
            end
        end
    end

    if price == 0 and sellPrice > 0 then
        price = sellPrice
    end

    price = price or 0
    SetCachedPrice(itemLink, price)
    return price
end

---@param lootString string
---@return string|nil, number|nil
function GetLinkAndQuantityLoot(lootString)
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
function GetLinkAndQuantityCraft(craftString)
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
    local received = str_match(receivedString, Constants.PATTERNS_RECEIVED[1])
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

    local price = Measure("CalculatePrice", CalculatePrice, itemLink)

    local totalPrice = price * quantity
    local itemID = Measure("GetCachedItemInfoFromHyperlink", GetCachedItemInfoFromHyperlink, itemLink)
    local i = LootedItemNew(NextLootEntryId(), itemID, itemLink, price, quantity)
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
