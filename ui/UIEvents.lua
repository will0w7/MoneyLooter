---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_UI
local UI = MoneyLooter.UI
---@class ML_Utils
local Utils = MoneyLooter.Utils
---@class ML_Data
local Data = MoneyLooter.Data
---@class ML_CBFunctions
local CBFunctions = MoneyLooter.CBFunctions
---@class ML_Core
local Core = MoneyLooter.Core
---@class ML_SMFunctions
local SMFunctions = MoneyLooter.SMFunctions

----------------------------------------------------------------------------------------
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local GetMoney, CreateFrame = GetMoney, CreateFrame
----------------------------------------------------------------------------------------
local date, tostring = date, tostring
local strlenutf8, print, tonumber, ipairs = strlenutf8, print, tonumber, ipairs
----------------------------------------------------------------------------------------

---@param visible boolean
local function SetMainVisible(visible)
    Data.SetVisible(visible)
    if visible then
        UI.MLMainFrame:Show()
    else
        UI.MLMainFrame:Hide()
    end
end

---@param visible boolean
local function SetScrollVisible(visible)
    Data.SetScrollLootFrameVisible(visible)
    UI.MLMainFrame.MinimizeCheck:SetChecked(visible)
    if visible then
        UI.MLMainFrame.ScrollBoxLoot:Show()
    else
        UI.MLMainFrame.ScrollBoxLoot:Hide()
    end
end

local function PopulateData()
    Constants.Strings.ADDON_VERSION = GetAddOnMetadata(Constants.Strings.ADDON_NAME, "Version")

    UpdateAllTexts(Data.GetTimer(), Data.GetRawMoney(), Data.GetItemsMoney(), Data.CalcGPH(), Data.GetPriciest())

    SetScrollVisible(Data.IsScrollLootFrameVisible())
    SetMainVisible(Data.IsVisible())

    if Data.IsRunning() then RegisterStartEvents() end
end

local function PopulateLoot()
    Data.InitListLootedItems()
    UI.MLMainFrame.ScrollBoxLoot.DataProvider:Flush()
    if Data.GetListLootedItemsCount() > 0 then
        local lootedItems = Data.GetListLootedItems()
        CBFunctions.Iterate(lootedItems, function(lootedItem)
            UI.MLMainFrame.ScrollBoxLoot.DataProvider:Insert(lootedItem)
        end)
    end
    UI.MLMainFrame.ScrollBoxLoot:ScrollToEnd()
end

local function PopulateSummary()
    UI.MLMainFrame.ScrollBoxLoot.DataProvider:Flush()
    local topItems = SMFunctions.GetTopItems(Data.GetSummary())
    for _, lootedItem in ipairs(topItems) do
        UI.MLMainFrame.ScrollBoxLoot.DataProvider:Insert(lootedItem)
    end
end

-----------------------------------------------------------------------------------------------
function UpdateRawMoney()
    UI.MLMainFrame.RawGoldFS:SetText(Utils.GetCoinTextString(Data.GetRawMoney()))
end

---@param time integer
---@param rawGold integer
---@param itemsGold integer
---@param gph integer
---@param priciest integer
function UpdateAllTexts(time, rawGold, itemsGold, gph, priciest)
    Data.SetOldMoney(GetMoney())
    UI.MLMainFrame.StartButton:SetText(Data.GetCurrentStartText())
    UI.MLMainFrame.TimeFS:SetText(tostring(date("!%X", time)))
    UI.MLMainFrame.RawGoldFS:SetText(Utils.GetCoinTextString(rawGold))
    UI.MLMainFrame.ItemsGoldFS:SetText(Utils.GetCoinTextString(itemsGold))
    UI.MLMainFrame.GPHFS:SetText(Utils.GetCoinTextString(gph))
    UI.MLMainFrame.PriciestFS:SetText(Utils.GetCoinTextString(priciest))
end

local function UpdateTexts()
    UI.MLMainFrame.TimeFS:SetText(tostring(date("!%X", Data.AddOneToTimer())))
    UI.MLMainFrame.GPHFS:SetText(Utils.GetCoinTextString(Data.CalcGPH()))
end

function UpdateLoot()
    if not Data.IsSummaryMode() then
        for _, lootedItem in ipairs(Data.GetLootedItems()) do
            UI.MLMainFrame.ScrollBoxLoot.DataProvider:Insert(lootedItem)
        end
        UI.MLMainFrame.ScrollBoxLoot:ScrollToEnd()
        UI.MLMainFrame.PriciestFS:SetText(Utils.GetCoinTextString(Data.GetPriciest()))
        UI.MLMainFrame.ItemsGoldFS:SetText(Utils.GetCoinTextString(Data.GetItemsMoney()))
        Data.ResetLootedItems()
    else
        PopulateSummary()
    end
end

-----------------------------------------------------------------------------------------------
UI.MLMainFrame.StartButton:SetScript(Constants.Events.OnClick, function()
    if Data.IsRunning() then
        Data.SetRunning(false)
        UI.MLMainFrame.StartButton:SetText(Data.SetCurrentStartText(_G.MONEYLOOTER_L_CONTINUE))
        UnregisterStartEvents()
    else
        Data.SetRunning(true)
        Data.SetOldMoney(GetMoney())
        UI.MLMainFrame.StartButton:SetText(Data.SetCurrentStartText(_G.MONEYLOOTER_L_PAUSE))
        RegisterStartEvents()
    end
end)

UI.MLMainFrame.CloseButton:SetScript(Constants.Events.OnClick, function()
    SetMainVisible(false)
    print(_G.MONEYLOOTER_L_CLOSE)
end)

UI.MLMainFrame.ResetButton:SetScript(Constants.Events.OnClick, function()
    if Data.IsRunning() then UnregisterStartEvents() end

    local forceVendor = Data.GetForceVendorPrice()
    local scrollVisible = Data.IsScrollLootFrameVisible()
    Data.ResetMoneyLooterDB()
    UpdateAllTexts(0, 0, 0, 0, 0)
    UI.MLMainFrame.ScrollBoxLoot.DataProvider:Flush()
    Data.SetScrollLootFrameVisible(scrollVisible)
    Data.SetForceVendorPrice(forceVendor)
end)

UI.MLMainFrame.MinimizeCheck:SetScript(Constants.Events.OnClick, function(_, button)
    if button == "LeftButton" then
        SetScrollVisible(not Data.IsScrollLootFrameVisible())
    elseif button == "RightButton" then
        local mode = not Data.IsSummaryMode()
        Data.SetSummaryMode(mode)
        if mode then
            PopulateSummary()
        else
            UpdateLoot()
            PopulateLoot()
        end
    end
    UI.MLMainFrame.MinimizeCheck:SetChecked(Data.IsScrollLootFrameVisible())
end)

UI.MLMainFrame.PriciestFS:SetScript(Constants.Events.OnEnter, function()
    local priciestLink = Data.GetPriciestLink()
    if priciestLink == nil or priciestLink == "" then return end
    GameTooltip:SetOwner(UI.MLMainFrame.PriciestFS, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:SetHyperlink(priciestLink)
    GameTooltip:Show()
end)

UI.MLMainFrame.PriciestFS:SetScript(Constants.Events.OnLeave, function()
    GameTooltip:Hide()
end)

-----------------------------------------------------------------------------------------------
local MoneyLooterLootEvents = CreateFrame("Frame")

---@type FunctionContainer
local timer

function RegisterStartEvents()
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.ChatMsgMoney)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.ChatMsgLoot)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.QuestTurnedIn)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.PInteractionManagerShow)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.PInteractionManagerHide)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.ChatMsgSystem)
    MoneyLooterLootEvents:SetScript(Constants.Events.OnEvent, Core.LootEventHandler)

    timer = C_Timer.NewTicker(1, UpdateTexts)
end

function UnregisterStartEvents()
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.ChatMsgMoney)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.ChatMsgLoot)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.QuestTurnedIn)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.PInteractionManagerShow)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.PInteractionManagerHide)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.ChatMsgSystem)
    MoneyLooterLootEvents:SetScript(Constants.Events.OnEvent, nil)

    if not timer:IsCancelled() then timer:Cancel() end
end

UI.MLMainFrame:SetScript(Constants.Events.OnDragStart, UI.MLMainFrame.StartMoving)
UI.MLMainFrame:SetScript(Constants.Events.OnDragStop, UI.MLMainFrame.StopMovingOrSizing)
UI.MLMainFrame:SetScript(Constants.Events.OnHide, UI.MLMainFrame.StopMovingOrSizing)
-----------------------------------------------------------------------------------------------

SLASH_MONEYLOOTER1 = "/ml"
SLASH_MONEYLOOTER2 = "/moneylooter"

local function ParseCustomString(msg)
    local _, tsmString = string.split(" ", msg, 2)
    if tsmString == nil or tsmString == "" then
        print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING .. "|cFF36e8e6" .. Data.GetCurrentTSMString() .. "|r")
        return
    end
    Data.SetTSMString(tsmString)
end

local function ParseMinPrice(msg)
    local mprice, value, coin = string.split(" ", msg, 3)
    if strlenutf8(mprice) < 7 then
        print(_G.MONEYLOOTER_L_MPRICE_ERROR)
        return
    end
    local mprices = {
        [1] = function(val)
            Data.SetMinPrice1(val)
        end,
        [2] = function(val)
            Data.SetMinPrice2(val)
        end,
        [3] = function(val)
            Data.SetMinPrice3(val)
        end,
        [4] = function(val)
            Data.SetMinPrice4(val)
        end,
        [99] = function(val)
            Data.SetAllMinPrices(val)
        end
    }
    local coinValue
    if coin == nil or coin == "g" then
        coinValue = 10000
        coin = "G"
    elseif coin == "s" then
        coinValue = 100
        coin = "S"
    elseif coin == "c" then
        coinValue = 1
        coin = "C"
    else
        print(_G.MONEYLOOTER_L_MPRICE_UNRECOGNIZED_COIN)
        return
    end
    local type = string.sub(mprice, 7, 8)
    local qual
    if type == "x" then
        qual = 99
    else
        qual = tonumber(type)
    end
    mprices[qual](value * coinValue)
    print(string.format("%s |cFF36e8e6%s %s|r - %s [%s]", _G.MONEYLOOTER_L_MPRICE_VALID, tostring(value),
        _G["MONEYLOOTER_L_MPRICE_COIN_" .. coin], _G["MONEYLOOTER_L_MPRICE_QUALITY_" .. tostring(qual)],
        tostring(qual)))
end

local function slash(msg, _)
    local mainVisible = Data.IsVisible()
    if msg == "show" or (msg == "" and not mainVisible) then
        SetMainVisible(true)
    elseif msg == "hide" or (msg == "" and mainVisible) then
        SetMainVisible(false)
    elseif msg == "info" then
        print(_G.MONEYLOOTER_L_INFO)
    elseif msg == "forcevendorprice" then
        local state = Data.ToggleForceVendorPrice()
        if state then
            print(_G.MONEYLOOTER_L_FORCE_VENDOR_PRICE_ENABLED)
        else
            print(_G.MONEYLOOTER_L_FORCE_VENDOR_PRICE_DISABLED)
        end
    elseif string.sub(msg, 1, 6) == "custom" then
        ParseCustomString(msg)
    elseif string.sub(msg, 1, 6) == "mprice" then
        ParseMinPrice(msg)
    else
        print(_G.MONEYLOOTER_L_USAGE .. Constants.Strings.ADDON_VERSION)
    end
end
SlashCmdList["MONEYLOOTER"] = slash

-----------------------------------------------------------------------------------------------

local watcher = CreateFrame("Frame")

MoneyLooter.addonLoaded = false
function WatcherOnEvent(_, event, arg1)
    if event == Constants.Events.AddonLoaded and arg1 == Constants.Strings.ADDON_NAME then
        MoneyLooter.addonLoaded = true
        watcher:UnregisterEvent(Constants.Events.AddonLoaded)
    elseif event == Constants.Events.PlayerEnteringWorld and MoneyLooter.addonLoaded then
        Data.UpdateMLDB()
        Data.UpdateMLXDB()
        PopulateData()
        PopulateLoot()
        watcher:UnregisterEvent(Constants.Events.PlayerEnteringWorld)
    end
end

watcher:RegisterEvent(Constants.Events.AddonLoaded)
watcher:RegisterEvent(Constants.Events.PlayerEnteringWorld)
watcher:SetScript(Constants.Events.OnEvent, WatcherOnEvent)
