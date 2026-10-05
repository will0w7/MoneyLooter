---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_Core
local Core = MoneyLooter.Core
---@class ML_Utils
local Utils = MoneyLooter.Utils

------------------------------------------------------------------------------
local CreateFrame = CreateFrame
local string_format = string.format
local math_min = math.min
local GetMoney = GetMoney
------------------------------------------------------------------------------
local C_Container = C_Container
local UseContainerItem = C_Container and C_Container.UseContainerItem
local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo
------------------------------------------------------------------------------

---@class ML_Vendor
local Vendor = {}
MoneyLooter.Vendor = Vendor

local SellsPerClick = 12
local SellDelay = 0.1
local SellTimeout = 0.5

local button
local isMerchantOpen = false
local sellQueue = {}
local sellCursor = 1

local batchActive = false
local batchTarget = 0
local batchSold = 0
local moneyBeforeAttempt = 0
local attemptTimer = nil
local nextTimer = nil
local sellThisBatch = 0

---@param bag integer
---@param slot integer
---@return integer stackCount
---@return boolean|nil noValue
---@return boolean|nil locked
---@return boolean|nil lootable
local function GetContainerItemDetails(bag, slot)
    local info = GetContainerItemInfo(bag, slot)
    if info then
        return info.stackCount or 1, info.hasNoValue, info.isLocked, info.hasLoot
    end
    return 1, false, false, false
end

---@param action integer
---@return boolean
local function IsSellAction(action)
    return (action == Constants.ItemAction.Sell or action == Constants.ItemAction.SellJewellery or action == Constants.ItemAction.ForceSell)
end

---@return table items
---@return integer totalValue
local function CollectSellableItems()
    local items = {}
    local totalValue = 0

    for bag = 0, NUM_BAG_SLOTS do
        local numSlots = GetContainerNumSlots(bag)
        if not numSlots or numSlots <= 0 then return {}, 0 end

        for slot = 1, numSlots do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink then
                local stackCount, noValue, locked, lootable = GetContainerItemDetails(bag, slot)
                if not noValue and not locked and not lootable then
                    local sellPrice, action = Core.CalculatePrice(itemLink)
                    if IsSellAction(action) and sellPrice and sellPrice > 0 then
                        local value = sellPrice * stackCount
                        items[#items + 1] = { bag = bag, slot = slot, value = value }
                        totalValue = totalValue + value
                    end
                end
            end
        end
    end

    return items, totalValue
end

---@return integer
local function GetRemaining()
    return #sellQueue - sellCursor + 1
end

local function UpdateButtonText()
    if not button then return end
    local remaining = GetRemaining()
    local perClick = math_min(SellsPerClick, remaining)
    if not batchActive then
        button:Enable()
        button:SetText(string_format(_G.MONEYLOOTER_L_SELL_BUTTON, perClick, remaining))
        sellThisBatch = 0
    else
        if sellThisBatch == 0 then sellThisBatch = perClick end
        button:Disable()
        button:SetText(string_format(_G.MONEYLOOTER_L_SELL_BUTTON_SELLING, batchSold, sellThisBatch))
    end
end

local function FinalizeBatch()
    if attemptTimer then
        attemptTimer:Cancel()
        attemptTimer = nil
    end
    if nextTimer then
        nextTimer:Cancel()
        nextTimer = nil
    end

    batchActive = false
    batchTarget = 0
    batchSold = 0
    UpdateButtonText()
end

local function ScheduleNextAttempt()
    nextTimer = C_Timer.After(SellDelay, function()
        nextTimer = nil
        AttemptNextItem()
    end)
end

function AttemptNextItem()
    if not isMerchantOpen then
        FinalizeBatch()
        return
    end
    if batchSold >= batchTarget then
        FinalizeBatch()
        return
    end

    if GetRemaining() <= 0 then
        local items = CollectSellableItems()
        if #items > 0 then
            sellQueue = items
            sellCursor = 1
        else
            FinalizeBatch()
            return
        end
    end

    local item = sellQueue[sellCursor]
    moneyBeforeAttempt = GetMoney()
    UseContainerItem(item.bag, item.slot)

    attemptTimer = C_Timer.NewTimer(SellTimeout, function()
        attemptTimer = nil
        sellCursor = sellCursor + 1
        ScheduleNextAttempt()
    end)
end

local function OnPlayerMoney()
    if not batchActive or attemptTimer == nil then return end

    local delta = GetMoney() - moneyBeforeAttempt
    if delta <= 0 then
        moneyBeforeAttempt = GetMoney()
        return
    end

    attemptTimer:Cancel()
    attemptTimer = nil
    batchSold = batchSold + 1
    sellCursor = sellCursor + 1
    UpdateButtonText()

    if batchSold >= batchTarget then
        FinalizeBatch()
    else
        ScheduleNextAttempt()
    end
end

local function OnSellClick()
    if not isMerchantOpen then return end
    if batchActive then return end

    local items = CollectSellableItems()
    sellQueue = items
    sellCursor = 1

    if GetRemaining() <= 0 then
        if #items > 0 then
            sellQueue = items
            sellCursor = 1
        else
            return
        end
    end

    batchActive = true
    batchTarget = math_min(SellsPerClick, GetRemaining())
    batchSold = 0
    AttemptNextItem()
end

---@return Button|table
local function CreateSellButton()
    local parent = _G.MerchantFrame or UIParent
    local btn = CreateFrame("Button", nil, parent, "ML_Button")
    btn:SetSize(130, 20)

    local dropdown = _G.MerchantFrameFilterDropDown
        or (_G.MerchantFrame and _G.MerchantFrame.FilterDropDown)
    if dropdown then
        btn:SetPoint("TOPRIGHT", dropdown, "TOPLEFT", -4, 2)
    else
        btn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -170, -32)
    end

    btn:SetScript(Constants.Events.OnClick, OnSellClick)
    btn:SetScript(Constants.Events.OnEnter, function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(_G.MONEYLOOTER_L_SELL_BUTTON_TOOLTIP, 1, 1, 1)
        GameTooltip:Show()
    end)
    btn:SetScript(Constants.Events.OnLeave, function()
        GameTooltip:Hide()
    end)

    return btn
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("MERCHANT_SHOW")
eventFrame:RegisterEvent("MERCHANT_CLOSED")
eventFrame:RegisterEvent("PLAYER_MONEY")
eventFrame:SetScript("OnEvent", function(_, event)
    if event == "MERCHANT_SHOW" then
        isMerchantOpen = true
        if not button then
            button = CreateSellButton()
        end
        button:Show()

        eventFrame:RegisterEvent("BAG_UPDATE")

        local items, totalValue = CollectSellableItems()
        sellQueue = items
        sellCursor = 1
        UpdateButtonText()
        if #items > 0 then
            print(string_format(_G.MONEYLOOTER_L_SELL_OPEN, #items, Utils.GetCoinTextString(totalValue)))
        end
    elseif event == "MERCHANT_CLOSED" then
        isMerchantOpen = false
        FinalizeBatch()
        if button then
            button:Hide()
        end

        eventFrame:UnregisterEvent("BAG_UPDATE")
    elseif event == "PLAYER_MONEY" then
        OnPlayerMoney()
    elseif event == "BAG_UPDATE" then
        if not batchActive then
            sellQueue = CollectSellableItems()
            sellCursor = 1
            UpdateButtonText()
        end
    end
end)
