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
------------------------------------------------------------------------------
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetMoney, GetUnitName, GetTime = GetMoney, GetUnitName, GetTime
local tonumber, strsplit, unpack = tonumber, strsplit, unpack
local str_match = string.match
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

local function GetCachedPrice(itemLink)
    local entry = priceCache[itemLink]
    if not entry then return nil end

    if entry.expires > GetTime() then
        return entry.price
    end
    priceCache[itemLink] = nil
    return nil
end

local function SetCachedPrice(itemLink, price)
    priceCache[itemLink] = {
        price = price,
        expires = GetTime() + CACHE_TTL,
    }
end

local function GetCachedItemInfo(itemString)
    local info = itemInfoCache[itemString]
    if not info then
        local temp = { GetItemInfo(itemString) }
        info = { temp[3], temp[11], temp[17] }
        itemInfoCache[itemString] = info
    end
    return unpack(info)
end

local function GetCachedItemInfoFromHyperlink(itemString)
    local info = itemInfoCacheLink[itemString]
    if not info then
        info = GetItemInfoFromHyperlink(itemString)
        itemInfoCacheLink[itemString] = info
    end
    return info
end

local function getMinPrice(quality)
    if quality == 1 then
        return Data.GetMinPrice1()
    elseif quality == 2 then
        return Data.GetMinPrice2()
    elseif quality == 3 then
        return Data.GetMinPrice3()
    elseif quality == 4 then
        return Data.GetMinPrice4()
    end
end

local priceSources = {
    {
        cond = TSM_API,
        fn   = function(quality, itemLink, isCraftingReagent)
            local tsmItemString = TSM_API.ToItemString(itemLink)
            local value = TSM_API.GetCustomPriceValue(Data.GetCurrentTSMString(), tsmItemString)
            if not value then return 0 end
            local min = getMinPrice(quality)
            return (value >= min or isCraftingReagent) and value or 0
        end
    },
    {
        cond = AUCTIONATOR_API,
        fn   = function(quality, itemLink, isCraftingReagent)
            local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(
                Constants.Strings.ADDON_NAME, itemLink)
            if not value then return 0 end
            local min = getMinPrice(quality)
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
            local min = getMinPrice(quality)
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
            local min = getMinPrice(quality)
            return (value >= min or isCraftingReagent) and value or 0
        end
    },
    {
        cond = MoneyLooter.isRetail and RECrystallize_PriceCheck,
        fn   = function(quality, itemLink, isCraftingReagent)
            local value = RECrystallize_PriceCheck(itemLink)
            if not value then return 0 end
            local min = getMinPrice(quality)
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
        Profiler.Measure("GetCachedItemInfo", GetCachedItemInfo, itemString)

    if Data.GetForceVendorPrice() then
        SetCachedPrice(itemLink, sellPrice or 0)
        return sellPrice or 0
    end

    if quality < 1 or quality > 4 then
        local price = sellPrice and (sellPrice > 0 and sellPrice) or 0
        SetCachedPrice(itemLink, price)
        return price
    end

    local price = 0
    for _, src in ipairs(priceSources) do
        if src.cond then
            price = Profiler.Measure("CalculatePrice.EXT_API", src.fn, quality, itemLink, isCraftingReagent)
            if price > 0 then break end
        end
    end

    if price == 0 and sellPrice > 0 then
        price = sellPrice
    end

    SetCachedPrice(itemLink, price)
    return price or 0
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
    if Data.IsInteractionPaused() then return end
    if lootString == nil then return end
    if GetLinkAndQuantityCraft(lootString) then return end

    local playerNameFromPN2, _ = strsplit("-", playerName2, 2)
    if playerName ~= playerNameFromPN2 then return end

    local itemLink, quantity = GetLinkAndQuantityLoot(lootString)
    if itemLink == nil then return end

    local price = Profiler.Measure("CalculatePrice", CalculatePrice, itemLink)

    local totalPrice = price * quantity
    local itemID = Profiler.Measure("GetCachedItemInfoFromHyperlink", GetCachedItemInfoFromHyperlink, itemLink)
    local i = LootedItem.new(itemID, itemLink, price, quantity)
    Data.InsertLootedItem(i)
    Data.InsertSummaryItem(i)
    Data.AddItemsMoney(totalPrice)
    Data.AddTotalMoney(totalPrice)
    -- only price of individual items, not groups (1xBismuth not 5xBismuth)
    Data.SetPriciest(price, itemLink)
    Profiler.Measure("UpdateLoot", UpdateLoot, i)
end

local function ChatMsgMoney_QuestTurnedIn()
    -- here we dont stop interaction, if we turn in a quest with a profession
    -- window opened, we want to register the money change
    local newMoney = GetMoney()
    local change = (newMoney - Data.GetOldMoney())
    Data.AddRawMoney(change)
    Data.AddTotalMoney(change)
    Data.SetOldMoney(newMoney)
    UpdateRawMoney()
end

---@param receivedString string
local function ChatMsgSystem(_, _, receivedString)
    if not ReceivedMoney(receivedString) then return end
    local newMoney = GetMoney()
    local change = (newMoney - Data.GetOldMoney())
    Data.AddRawMoney(change)
    Data.AddTotalMoney(change)
    Data.SetOldMoney(newMoney)
    UpdateRawMoney()
end

---@param interaction Enum.PlayerInteractionType
local function PInteractionManagerShow(_, _, interaction)
    if Constants.RelevantInteractions[interaction] then
        Data.SetInteractionPaused(true)
    end
end

---@param interaction Enum.PlayerInteractionType
local function PInteractionManagerHide(_, _, interaction)
    if Constants.RelevantInteractions[interaction] then
        Data.SetInteractionPaused(false)
        Data.SetOldMoney(GetMoney())
    end
end

---@param event WowEvent
function Core.OnEvent(_, event, ...)
    if event == Constants.Events.ChatMsgLoot then
        Profiler.Measure(event, ChatMsgLoot, nil, event, ...)
    elseif event == Constants.Events.ChatMsgMoney or event == Constants.Events.QuestTurnedIn then
        Profiler.Measure(event, ChatMsgMoney_QuestTurnedIn)
    elseif event == Constants.Events.ChatMsgSystem then
        Profiler.Measure(event, ChatMsgSystem, nil, event, ...)
    elseif event == Constants.Events.PInteractionManagerShow then
        Profiler.Measure(event, PInteractionManagerShow, nil, event, ...)
    elseif event == Constants.Events.PInteractionManagerHide then
        Profiler.Measure(event, PInteractionManagerHide, nil, event, ...)
    end
end
