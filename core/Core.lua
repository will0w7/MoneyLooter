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
local GetMoney, GetUnitName = GetMoney, GetUnitName
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

local GetTSMPrice = {
    [0] = function(_, _)
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param tsmItemString string
    [1] = function(isCraftingReagent, tsmItemString)
        local value = TSM_API.GetCustomPriceValue(Data.GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= Data.GetMinPrice1() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param tsmItemString string
    [2] = function(isCraftingReagent, tsmItemString)
        local value = TSM_API.GetCustomPriceValue(Data.GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= Data.GetMinPrice2() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param tsmItemString string
    [3] = function(isCraftingReagent, tsmItemString)
        local value = TSM_API.GetCustomPriceValue(Data.GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= Data.GetMinPrice3() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param tsmItemString string
    [4] = function(isCraftingReagent, tsmItemString)
        local value = TSM_API.GetCustomPriceValue(Data.GetCurrentTSMString(), tsmItemString)
        if value ~= nil and (value >= Data.GetMinPrice4() or isCraftingReagent) then return value end
        return 0
    end,
    [-1] = function(_, _)
        return 0
    end
}

local GetAucPrice = {
    [0] = function(_, _)
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [1] = function(isCraftingReagent, itemLink)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= Data.GetMinPrice1() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [2] = function(isCraftingReagent, itemLink)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= Data.GetMinPrice2() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [3] = function(isCraftingReagent, itemLink)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= Data.GetMinPrice3() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [4] = function(isCraftingReagent, itemLink)
        local value = AUCTIONATOR_API.GetAuctionPriceByItemLink(Constants.Strings.ADDON_NAME, itemLink)
        if value ~= nil and (value >= Data.GetMinPrice4() or isCraftingReagent) then return value end
        return 0
    end,
    [-1] = function(_, _)
        return 0
    end
}

local GetNeerPrice = {
    [0] = function(_, _)
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [1] = function(isCraftingReagent, itemLink)
        local itemKey = AUCTIONEER_API:ItemKeyFromLink(itemLink)
        local stats = AUCTIONEER_API:Statistics(itemKey)
        local overTime = stats["Stats:OverTime"]
        local value = 0
        if overTime ~= nil then value = overTime:Best() end
        if value ~= nil and (value >= Data.GetMinPrice1() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [2] = function(isCraftingReagent, itemLink)
        local itemKey = AUCTIONEER_API:ItemKeyFromLink(itemLink)
        local stats = AUCTIONEER_API:Statistics(itemKey)
        local overTime = stats["Stats:OverTime"]
        local value = 0
        if overTime ~= nil then value = overTime:Best() end
        if value ~= nil and (value >= Data.GetMinPrice2() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [3] = function(isCraftingReagent, itemLink)
        local itemKey = AUCTIONEER_API:ItemKeyFromLink(itemLink)
        local stats = AUCTIONEER_API:Statistics(itemKey)
        local overTime = stats["Stats:OverTime"]
        local value = 0
        if overTime ~= nil then value = overTime:Best() end
        if value ~= nil and (value >= Data.GetMinPrice3() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [4] = function(isCraftingReagent, itemLink)
        local itemKey = AUCTIONEER_API:ItemKeyFromLink(itemLink)
        local stats = AUCTIONEER_API:Statistics(itemKey)
        local overTime = stats["Stats:OverTime"]
        local value = 0
        if overTime ~= nil then value = overTime:Best() end
        if value ~= nil and (value >= Data.GetMinPrice4() or isCraftingReagent) then return value end
        return 0
    end,
    [-1] = function(_, _)
        return 0
    end
}

local GetOEPrice = {
    [0] = function(_, _)
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [1] = function(isCraftingReagent, itemLink)
        local value = {}
        OEMarketInfo(itemLink, value)
        if value ~= nil and value.region ~= nil and (value.region >= Data.GetMinPrice1() or isCraftingReagent) then
            return value.region
        end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [2] = function(isCraftingReagent, itemLink)
        local value = {}
        OEMarketInfo(itemLink, value)
        if value ~= nil and value.region ~= nil and (value.region >= Data.GetMinPrice2() or isCraftingReagent) then
            return value.region
        end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [3] = function(isCraftingReagent, itemLink)
        local value = {}
        OEMarketInfo(itemLink, value)
        if value ~= nil and value.region ~= nil and (value.region >= Data.GetMinPrice3() or isCraftingReagent) then
            return value.region
        end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [4] = function(isCraftingReagent, itemLink)
        local value = {}
        OEMarketInfo(itemLink, value)
        if value ~= nil and value.region ~= nil and (value.region >= Data.GetMinPrice4() or isCraftingReagent) then
            return value.region
        end
        return 0
    end,
    [-1] = function(_, _)
        return 0
    end
}

local GetREPrice = {
    [0] = function(_, _)
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [1] = function(isCraftingReagent, itemLink)
        local value = RECrystallize_PriceCheck(itemLink)
        if value ~= nil and (value >= Data.GetMinPrice1() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [2] = function(isCraftingReagent, itemLink)
        local value = RECrystallize_PriceCheck(itemLink)
        if value ~= nil and (value >= Data.GetMinPrice2() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [3] = function(isCraftingReagent, itemLink)
        local value = RECrystallize_PriceCheck(itemLink)
        if value ~= nil and (value >= Data.GetMinPrice3() or isCraftingReagent) then return value end
        return 0
    end,
    ---@param isCraftingReagent boolean
    ---@param itemLink string
    [4] = function(isCraftingReagent, itemLink)
        local value = RECrystallize_PriceCheck(itemLink)
        if value ~= nil and (value >= Data.GetMinPrice4() or isCraftingReagent) then return value end
        return 0
    end,
    [-1] = function(_, _)
        return 0
    end
}

---@param quality integer
---@param itemLink string
---@param isCraftingReagent boolean
local function CalculatePriceTSM(quality, itemLink, isCraftingReagent)
    if TSM_API == nil then return 0 end

    local tsmItemString = TSM_API.ToItemString(itemLink)
    if tsmItemString == nil then return 0 end

    local price
    if GetTSMPrice[quality] then
        price = GetTSMPrice[quality](isCraftingReagent, tsmItemString)
    else
        price = GetTSMPrice[-1](isCraftingReagent, tsmItemString)
    end
    return price
end

---@param quality integer
---@param itemLink string
---@param isCraftingReagent boolean
local function CalculatePriceAuc(quality, itemLink, isCraftingReagent)
    if AUCTIONATOR_API == nil then return 0 end

    local price
    if GetAucPrice[quality] then
        price = GetAucPrice[quality](isCraftingReagent, itemLink)
    else
        price = GetAucPrice[-1](isCraftingReagent, itemLink)
    end
    return price
end

---@param quality integer
---@param itemLink string
---@param isCraftingReagent boolean
local function CalculatePriceNeer(quality, itemLink, isCraftingReagent)
    if AUCTIONEER_API == nil then return 0 end

    local price
    if GetNeerPrice[quality] then
        price = GetNeerPrice[quality](isCraftingReagent, itemLink)
    else
        price = GetNeerPrice[-1](isCraftingReagent, itemLink)
    end
    return price
end

---@param quality integer
---@param itemLink string
---@param isCraftingReagent boolean
local function CalculatePriceOE(quality, itemLink, isCraftingReagent)
    if OEMarketInfo == nil then return 0 end

    local price
    if GetOEPrice[quality] then
        price = GetOEPrice[quality](isCraftingReagent, itemLink)
    else
        price = GetOEPrice[-1](isCraftingReagent, itemLink)
    end
    return price
end

---@param quality integer
---@param itemLink string
---@param isCraftingReagent boolean
local function CalculatePriceRE(quality, itemLink, isCraftingReagent)
    if RECrystallize_PriceCheck == nil then return 0 end

    local price
    if GetREPrice[quality] then
        price = GetREPrice[quality](isCraftingReagent, itemLink)
    else
        price = GetREPrice[-1](isCraftingReagent, itemLink)
    end
    return price
end

local priceSources = {
    { cond = TSM_API,                                                  fn = CalculatePriceTSM,  name = "CalculatePriceTSM" },
    { cond = AUCTIONATOR_API,                                          fn = CalculatePriceAuc,  name = "CalculatePriceAuc" },
    { cond = AUCTIONEER_API,                                           fn = CalculatePriceNeer, name = "CalculatePriceNeer" },
    { cond = MoneyLooter.isRetail and OEMarketInfo ~= nil,             fn = CalculatePriceOE,   name = "CalculatePriceOE" },
    { cond = MoneyLooter.isRetail and RECrystallize_PriceCheck ~= nil, fn = CalculatePriceRE,   name = "CalculatePriceRE" },
}
local priceSourcesLength = #priceSources

---@param itemLink string
local function CalculatePrice(itemLink)
    if itemLink == nil then return end

    local cached = GetCachedPrice(itemLink)
    if cached then return cached end

    local itemString = str_match(itemLink, "item[%-?%d:]+")
    local quality, sellPrice, isCraftingReagent = Profiler.Measure("GetCachedItemInfo", GetCachedItemInfo, itemString)
    if Data.GetForceVendorPrice() then return sellPrice or 0 end

    local price = 0
    for i = 1, priceSourcesLength do
        local src = priceSources[i]
        if src.cond then
            local p = Profiler.Measure(src.name, src.fn, quality, itemLink, isCraftingReagent)
            if p ~= 0 then
                price = p
                break
            end
        end
    end
    if price == 0 and sellPrice > 0 then price = sellPrice end
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

---@param event WowEvent
function Core.LootEventHandler(_, event, ...)
    if event == Constants.Events.ChatMsgLoot then
        if Data.IsInteractionPaused() then return end
        Profiler.Start("LEH." .. event)

        local lootString, _, _, _, playerName2 = ...
        if lootString == nil then return end

        if GetLinkAndQuantityCraft(lootString) then return end

        local playerNameFromPN2, _ = strsplit("-", playerName2, 2)
        if playerName ~= playerNameFromPN2 then return end

        local itemLink, quantity = GetLinkAndQuantityLoot(lootString)
        if itemLink == nil then return end

        local price = Profiler.Measure("CalculatePrice", CalculatePrice, itemLink)
        if price == nil then return end

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
        Profiler.Stop("LEH." .. event)
    elseif event == Constants.Events.ChatMsgMoney or event == Constants.Events.QuestTurnedIn then
        Profiler.Start("LEH." .. event)
        -- here we dont stop interaction, if we turn in a quest with a profession
        -- window opened, we want to register the money change
        local newMoney = GetMoney()
        local change = (newMoney - Data.GetOldMoney())
        Data.AddRawMoney(change)
        Data.AddTotalMoney(change)
        Data.SetOldMoney(newMoney)
        UpdateRawMoney()
        Profiler.Stop("LEH." .. event)
    elseif event == Constants.Events.ChatMsgSystem then
        Profiler.Start("LEH." .. event)
        local receivedString = ...
        if not ReceivedMoney(receivedString) then return end
        local newMoney = GetMoney()
        local change = (newMoney - Data.GetOldMoney())
        Data.AddRawMoney(change)
        Data.AddTotalMoney(change)
        Data.SetOldMoney(newMoney)
        UpdateRawMoney()
        Profiler.Stop("LEH." .. event)
    elseif event == Constants.Events.PInteractionManagerShow then
        Profiler.Start("LEH." .. event)
        local interaction = ...
        if Constants.RelevantInteractions[interaction] then
            Data.SetInteractionPaused(true)
        end
        Profiler.Stop("LEH." .. event)
    elseif event == Constants.Events.PInteractionManagerHide then
        Profiler.Start("LEH." .. event)
        local interaction = ...
        if Constants.RelevantInteractions[interaction] then
            Data.SetInteractionPaused(false)
            Data.SetOldMoney(GetMoney())
        end
        Profiler.Stop("LEH." .. event)
    end
end
