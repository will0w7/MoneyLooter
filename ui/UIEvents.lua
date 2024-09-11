---@class MoneyLooter
local MoneyLooter = select(2, ...)

local Constants = MoneyLooter.Constants
local UI = MoneyLooter.UI
local Utils = MoneyLooter.Utils

----------------------------------------------------------------------------------------
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local GetMoney, CreateFrame = GetMoney, CreateFrame
----------------------------------------------------------------------------------------
local date, tostring, strsplit, strsub = date, tostring, strsplit, strsub
local strlenutf8, print, tonumber = strlenutf8, print, tonumber
----------------------------------------------------------------------------------------

local function SetMainVisible(val)
    SetVisible(val)
    if val then
        UI.MLMainFrame:Show()
    else
        UI.MLMainFrame:Hide()
    end
end

local function SetScrollVisible(val)
    SetScrollLootFrameVisible(val)
    UI.MLMainFrame.MinimizeCheck:SetChecked(val)
    if val then
        UI.MLMainFrame.ScrollBoxLoot:Show()
    else
        UI.MLMainFrame.ScrollBoxLoot:Hide()
    end
end

local function PopulateData()
    Constants.Strings.ADDON_VERSION = GetAddOnMetadata(Constants.Strings.ADDON_NAME, "Version")
    UI.MLMainFrame.StartButton:SetText(GetCurrentStartText())
    UI.MLMainFrame.TimeFS:SetText(tostring(date("!%X", GetTimer())))
    UI.MLMainFrame.RawGoldFS:SetText(Utils.GetCoinTextString(GetRawGold()))
    UI.MLMainFrame.ItemsGoldFS:SetText(Utils.GetCoinTextString(GetItemsMoney()))
    UI.MLMainFrame.GPHFS:SetText(Utils.GetCoinTextString(CalcGPH()))
    UI.MLMainFrame.PriciestFS:SetText(Utils.GetCoinTextString(GetPriciest()))

    SetScrollVisible(IsScrollLootFrameVisible())

    SetMainVisible(IsVisible())
    if IsRunning() then RegisterStartEvents() end
end

local function PopulateLoot()
    InitListLootedItems()
    if GetListLootedItemsCount() > 0 then
        local lootedItems = GetListLootedItems()
        CircularBuffer_Iterate(lootedItems, function(lootedItem)
            UI.MLMainFrame.ScrollBoxLoot.DataProvider:Insert(lootedItem)
        end)
    end
    UI.MLMainFrame.ScrollBoxLoot:ScrollToEnd()
end

-----------------------------------------------------------------------------------------------
function UpdateRawGold()
    UI.MLMainFrame.RawGoldFS:SetText(Utils.GetCoinTextString(GetRawGold()))
end

local function MoneyLooterUpdateTexts()
    AddOneToTimer()
    UI.MLMainFrame.TimeFS:SetText(SetCurrentTimeText(tostring(date("!%X", GetTimer()))))
    UI.MLMainFrame.GPHFS:SetText(Utils.GetCoinTextString(CalcGPH()))
end

function MoneyLooterUpdateLoot()
    local lootedItems = GetLootedItems()
    for i = 1, #lootedItems do
        local lootedItem = lootedItems[i]
        UI.MLMainFrame.ScrollBoxLoot.DataProvider:Insert(lootedItem)
    end
    UI.MLMainFrame.ScrollBoxLoot:ScrollToEnd()
    UI.MLMainFrame.PriciestFS:SetText(Utils.GetCoinTextString(GetPriciest()))
    UI.MLMainFrame.ItemsGoldFS:SetText(Utils.GetCoinTextString(GetItemsMoney()))
    ResetLootedItems()
end

-----------------------------------------------------------------------------------------------
UI.MLMainFrame.StartButton:SetScript(Constants.Events.OnClick, function()
    if IsRunning() then
        SetRunning(false)
        UI.MLMainFrame.StartButton:SetText(SetCurrentStartText(_G.MONEYLOOTER_L_CONTINUE))
        UnregisterStartEvents()
    else
        SetRunning(true)
        SetOldMoney(GetMoney())
        UI.MLMainFrame.StartButton:SetText(SetCurrentStartText(_G.MONEYLOOTER_L_PAUSE))
        RegisterStartEvents()
    end
end)

UI.MLMainFrame.CloseButton:SetScript(Constants.Events.OnClick, function()
    SetVisible(false)
    print(_G.MONEYLOOTER_L_CLOSE)
    UI.MLMainFrame:Hide()
end)

UI.MLMainFrame.MinimizeCheck:SetScript(Constants.Events.OnClick, function()
    if IsScrollLootFrameVisible() then
        SetScrollLootFrameVisible(false)
        UI.MLMainFrame.ScrollBoxLoot:Hide()
    else
        SetScrollLootFrameVisible(true)
        UI.MLMainFrame.ScrollBoxLoot:Show()
    end
end)

UI.MLMainFrame.PriciestFS:SetScript(Constants.Events.OnEnter, function()
    local priciestID = GetPriciestID()
    if priciestID == nil or priciestID == 0 then return end
    GameTooltip:SetOwner(UI.MLMainFrame.PriciestFS, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:SetItemByID(GetPriciestID())
    GameTooltip:Show()
end)

UI.MLMainFrame.PriciestFS:SetScript(Constants.Events.OnLeave, function()
    GameTooltip:Hide()
end)

-----------------------------------------------------------------------------------------------
local MoneyLooterLootEvents = CreateFrame("Frame")

MoneyLooterLootEvents.AnimGroup = MoneyLooterLootEvents:CreateAnimationGroup()
MoneyLooterLootEvents.Timer = MoneyLooterLootEvents.AnimGroup:CreateAnimation()
MoneyLooterLootEvents.Timer:SetDuration(1)
MoneyLooterLootEvents.AnimGroup:SetLooping("REPEAT")

function RegisterStartEvents()
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.ChatMsgMoney)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.ChatMsgLoot)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.QuestTurnedIn)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.TradeSkillClose)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.PInteractionManagerShow)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.PInteractionManagerHide)
    MoneyLooterLootEvents:SetScript(Constants.Events.OnEvent, LootEventHandler)

    MoneyLooterLootEvents.AnimGroup:Play()
    MoneyLooterLootEvents.AnimGroup:SetScript(Constants.Events.OnLoop, MoneyLooterUpdateTexts)
end

function UnregisterStartEvents()
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.ChatMsgMoney)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.ChatMsgLoot)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.QuestTurnedIn)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.TradeSkillClose)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.PInteractionManagerShow)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.PInteractionManagerHide)
    MoneyLooterLootEvents:SetScript(Constants.Events.OnEvent, nil)

    MoneyLooterLootEvents.AnimGroup:Stop()
    MoneyLooterLootEvents.AnimGroup:SetScript(Constants.Events.OnLoop, nil)
end

UI.MLMainFrame:SetScript(Constants.Events.OnDragStart, UI.MLMainFrame.StartMoving)
UI.MLMainFrame:SetScript(Constants.Events.OnDragStop, UI.MLMainFrame.StopMovingOrSizing)
UI.MLMainFrame:SetScript(Constants.Events.OnHide, UI.MLMainFrame.StopMovingOrSizing)

UI.MLMainFrame.ResetButton:SetScript(Constants.Events.OnClick, function()
    if IsRunning() then
        UnregisterStartEvents()
        MoneyLooterLootEvents:SetScript(Constants.Events.OnEvent, nil)
        MoneyLooterLootEvents.AnimGroup:SetScript(Constants.Events.OnLoop, nil)
    end
    local minimizeButtonState = IsScrollLootFrameVisible()
    ResetMoneyLooterDB()
    UI.MLMainFrame.StartButton:SetText(GetCurrentStartText())
    UI.MLMainFrame.TimeFS:SetText(SetCurrentTimeText(tostring(date("!%X", 0))))
    UI.MLMainFrame.RawGoldFS:SetText(Utils.GetCoinTextString(0))
    UI.MLMainFrame.ItemsGoldFS:SetText(Utils.GetCoinTextString(0))
    UI.MLMainFrame.GPHFS:SetText(Utils.GetCoinTextString(0))
    UI.MLMainFrame.PriciestFS:SetText(Utils.GetCoinTextString(0))
    SetOldMoney(GetMoney())
    UI.MLMainFrame.ScrollBoxLoot.DataProvider:Flush()
    SetScrollLootFrameVisible(minimizeButtonState)
end)
-----------------------------------------------------------------------------------------------

SLASH_MONEYLOOTER1 = "/ml"
SLASH_MONEYLOOTER2 = "/moneylooter"

local function slash(msg, _)
    if msg == "show" or (msg == "" and not IsVisible()) then
        SetVisible(true)
    elseif msg == "hide" or (msg == "" and IsVisible()) then
        SetVisible(false)
    elseif msg == "info" then
        print(_G.MONEYLOOTER_L_INFO)
    elseif strsub(msg, 1, 6) == "custom" then
        ParseCustomString(msg)
    elseif strsub(msg, 1, 6) == "mprice" then
        ParseMinPrice(msg)
    else
        print(_G.MONEYLOOTER_L_USAGE .. Constants.Strings.ADDON_VERSION)
    end
end
SlashCmdList["MONEYLOOTER"] = slash

function ParseCustomString(msg)
    local _, tsmString = strsplit(" ", msg, 2)
    if tsmString == nil or tsmString == "" then
        print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING .. "|cFF36e8e6" .. GetCurrentTSMString() .. "|r")
        return
    end
    SetTSMString(tsmString)
end

function ParseMinPrice(msg)
    local mprice, value, coin = strsplit(" ", msg, 3)
    if strlenutf8(mprice) < 7 then
        print(_G.MONEYLOOTER_L_MPRICE_ERROR)
        return
    end
    local mprices = {
        [1] = function(val)
            SetMinPrice1(val)
        end,
        [2] = function(val)
            SetMinPrice2(val)
        end,
        [3] = function(val)
            SetMinPrice3(val)
        end,
        [4] = function(val)
            SetMinPrice4(val)
        end,
        [99] = function(val)
            SetAllMinPrices(val)
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
    local type = strsub(mprice, 7, 8)
    local qual
    if type == "x" then
        qual = 99
    else
        qual = tonumber(type)
    end
    mprices[qual](value * coinValue)
    print(string.format("%s %s %s %s [%s]", _G.MONEYLOOTER_L_MPRICE_VALID, tostring(value),
        _G["MONEYLOOTER_L_MPRICE_COIN_" .. coin], _G["MONEYLOOTER_L_MPRICE_QUALITY_" .. tostring(qual)],
        tostring(qual)))
end

-----------------------------------------------------------------------------------------------

local watcher = CreateFrame("Frame")
watcher:RegisterEvent(Constants.Events.AddonLoaded)

function WatcherOnEvent(_, event, arg1)
    if event == Constants.Events.AddonLoaded and arg1 == Constants.Strings.ADDON_NAME then
        UpdateMLDB()
        UpdateMLXDB()
        PopulateData()
        PopulateLoot()
        watcher:UnregisterEvent(Constants.Events.AddonLoaded)
    end
end

watcher:SetScript(Constants.Events.OnEvent, WatcherOnEvent)
