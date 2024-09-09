---@class MoneyLooter
local MoneyLooter = select(2, ...)

local Constants = MoneyLooter.Constants

local UI = MoneyLooter.UI

----------------------------------------------------------------------------------------
local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata or GetAddOnMetadata
----------------------------------------------------------------------------------------
local date, tostring = date, tostring
----------------------------------------------------------------------------------------

function CreateTextureFromItemID(itemId)
    return ("|T" .. tostring(C_Item.GetItemIconByID(itemId)) .. ":0|t")
end

function SetMainVisible(val)
    SetVisible(val)
    if val then
        UI.MoneyLooterMainUIFrame:Show()
    else
        UI.MoneyLooterMainUIFrame:Hide()
    end
end

function SetScrollVisible(val)
    SetScrollLootFrameVisible(val)
    if val then
        UI.MoneyLooterScrollLootFrame:Show()
    else
        UI.MoneyLooterScrollLootFrame:Hide()
    end
end

function PopulateData()
    Constants.Strings.ADDON_VERSION = GetAddOnMetadata(Constants.Strings.ADDON_NAME, "Version")
    UI.MoneyLooterStartButton:SetText(GetCurrentStartStopText())
    UI.MoneyLooterTimeFS:SetText(tostring(date("!%X", GetTimer())))
    UI.MoneyLooterRawGoldFS:SetText(GetCoinTextureString(GetRawGold()))
    UI.MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(GetItemsMoney()))
    UI.MoneyLooterGPHFS:SetText(GetCoinTextureString(CalcGPH()))
    UI.MoneyLooterPriciestFS:SetText(GetCoinTextureString(GetPriciest()))

    
    if IsScrollLootFrameVisible() then
        SetScrollLootFrameVisible(true)
        UI.MoneyLooterMinimizeCheck:SetChecked(true)
        UI.MoneyLooterScrollLootFrame:Show()
    else
        SetScrollLootFrameVisible(false)
        UI.MoneyLooterMinimizeCheck:SetChecked(false)
        UI.MoneyLooterScrollLootFrame:Hide()
    end

    SetMainVisible(IsVisible())
    if IsRunning() then RegisterStartEvents() end
end

function PopulateLoot()
    InitListLootedItems()
    if GetListLootedItemsCount() > 0 then
        local lootedItems = GetListLootedItems()
        CircularBuffer_Iterate(lootedItems, function(lootedItem)
            UI.MoneyLooterScrollLootFrame:AddMessage(lootedItem.amount ..
                "x" ..
                CreateTextureFromItemID(lootedItem.id) ..
                lootedItem.name .. " " .. GetCoinTextureString(lootedItem.value, 12))
        end)
    end
end

function UpdateRawGold()
    UI.MoneyLooterRawGoldFS:SetText(GetCoinTextureString(GetRawGold()))
end

function MoneyLooterUpdateTexts()
    AddOneToTimer()
    UI.MoneyLooterTimeFS:SetText(SetCurrentTimeText(tostring(date("!%X", GetTimer()))))
    UI.MoneyLooterGPHFS:SetText(GetCoinTextureString(CalcGPH()))
end

function MoneyLooterUpdateLoot()
    local lootedItems = GetLootedItems()
    for i = 1, #lootedItems do
        local lootedItem = lootedItems[i]
        UI.MoneyLooterScrollLootFrame:AddMessage(lootedItem.amount ..
            "x" ..
            CreateTextureFromItemID(lootedItem.id) ..
            lootedItem.name .. " " .. GetCoinTextureString(lootedItem.value, 12))
    end
    UI.MoneyLooterPriciestFS:SetText(GetCoinTextureString(GetPriciest()))
    UI.MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(GetItemsMoney()))
    SetLootedItems({})
end

UI.MoneyLooterStartButton:SetScript(Constants.Events.OnClick, function()
    if IsRunning() then
        SetRunning(false)
        UI.MoneyLooterStartButton:SetText(SetCurrentStartStopText(_G.MONEYLOOTER_L_CONTINUE))
        UnregisterStartEvents()
    else
        SetRunning(true)
        SetOldMoney(GetMoney())
        UI.MoneyLooterStartButton:SetText(SetCurrentStartStopText(_G.MONEYLOOTER_L_PAUSE))
        RegisterStartEvents()
    end
end)

UI.MoneyLooterCloseButton:SetScript(Constants.Events.OnClick, function()
    SetVisible(false)
    print(_G.MONEYLOOTER_L_CLOSE);
end)

UI.MoneyLooterMinimizeCheck:SetScript(Constants.Events.OnClick, function()
    if IsScrollLootFrameVisible() then
        SetScrollLootFrameVisible(false)
        UI.MoneyLooterScrollLootFrame:Hide()
    else
        SetScrollLootFrameVisible(true)
        UI.MoneyLooterScrollLootFrame:Show()
    end
end)

UI.MoneyLooterPriciestFS:SetScript(Constants.Events.OnEnter, function()
    if GetPriciestID() == nil then return end
    GameTooltip:SetOwner(UI.MoneyLooterPriciestFS, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:SetItemByID(GetPriciestID())
    GameTooltip:Show()
end)

UI.MoneyLooterPriciestFS:SetScript(Constants.Events.OnLeave, function()
    GameTooltip:Hide()
end)

-----------------------------------------------------------------------------------------------
local MoneyLooterLootEvents = CreateFrame("Frame")

local MoneyLooterTextEvents = UI.MoneyLooterMainUIFrame:CreateAnimationGroup()
local MoneyLooterTextEventsTimer = MoneyLooterTextEvents:CreateAnimation()
MoneyLooterTextEventsTimer:SetDuration(1)
MoneyLooterTextEvents:SetLooping("REPEAT")

function RegisterStartEvents()
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.ChatMsgMoney)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.ChatMsgLoot)
    MoneyLooterLootEvents:RegisterEvent(Constants.Events.MerchantUpdate)
    if not MoneyLooter.isClassic or not MoneyLooter.isTBC then
        MoneyLooterLootEvents:RegisterEvent(Constants.Events.QuestLootReceived)
    end
    MoneyLooterLootEvents:SetScript(Constants.Events.OnEvent, LootEventHandler)

    MoneyLooterTextEvents:Play()
    MoneyLooterTextEvents:SetScript(Constants.Events.OnLoop, MoneyLooterUpdateTexts)
end

function UnregisterStartEvents()
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.ChatMsgMoney)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.ChatMsgLoot)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.MerchantUpdate)
    MoneyLooterLootEvents:UnregisterEvent(Constants.Events.QuestTurnedIn)
    if not MoneyLooter.isClassic or not MoneyLooter.isTBC then
        MoneyLooterLootEvents:UnregisterEvent(Constants.Events.QuestLootReceived)
    end
    MoneyLooterLootEvents:SetScript(Constants.Events.OnEvent, nil)

    MoneyLooterTextEvents:Stop()
    MoneyLooterTextEvents:SetScript(Constants.Events.OnLoop, nil)
end

UI.MoneyLooterMainUIFrame:SetScript(Constants.Events.OnDragStart, UI.MoneyLooterMainUIFrame.StartMoving)
UI.MoneyLooterMainUIFrame:SetScript(Constants.Events.OnDragStop, UI.MoneyLooterMainUIFrame.StopMovingOrSizing)
UI.MoneyLooterMainUIFrame:SetScript(Constants.Events.OnHide, UI.MoneyLooterMainUIFrame.StopMovingOrSizing)

UI.MoneyLooterScrollLootFrame:SetScript(Constants.Events.OnHyperLinkClick, function(_, link, text)
    SetItemRef(link, text);
end)
UI.MoneyLooterScrollLootFrame:SetScript(Constants.Events.OnHyperLinkEnter, OnHyperlinkEnter)
UI.MoneyLooterScrollLootFrame:SetScript(Constants.Events.OnHyperLinkLeave, OnHyperlinkLeave)

UI.MoneyLooterResetButton:SetScript(Constants.Events.OnClick, function()
    if IsRunning() then
        UnregisterStartEvents()
        MoneyLooterLootEvents:SetScript(Constants.Events.OnEvent, nil)
        MoneyLooterTextEvents:SetScript(Constants.Events.OnLoop, nil)
    end
    local minimizeButtonState = IsScrollLootFrameVisible()
    ResetMoneyLooterDB()
    UI.MoneyLooterStartButton:SetText(GetCurrentStartStopText())
    UI.MoneyLooterTimeFS:SetText(SetCurrentTimeText(tostring(date("!%X", 0))))
    UI.MoneyLooterRawGoldFS:SetText(GetCoinTextureString(0))
    UI.MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(0))
    UI.MoneyLooterGPHFS:SetText(GetCoinTextureString(0))
    UI.MoneyLooterPriciestFS:SetText(GetCoinTextureString(0))
    SetOldMoney(GetMoney())
    UI.MoneyLooterScrollLootFrame:Clear()
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

function WatcherOnEvent(self, event, arg1)
    if event == Constants.Events.AddonLoaded and arg1 == Constants.Strings.ADDON_NAME then
        -- print(_G.MONEYLOOTER_L_WELCOME)
        UpdateMLDB()
        UpdateMLXDB()
        PopulateData()
        PopulateLoot()
        watcher:UnregisterEvent(Constants.Events.AddonLoaded)
    end
end

watcher:SetScript(Constants.Events.OnEvent, WatcherOnEvent)
