-- Author      : Will0w7
-- MoneyLooterUIEvents --

----------------------------------------------------------------------------------
GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
----------------------------------------------------------------------------------

function PopulateData()
    MoneyLooterStartButton:SetText(GetCurrentStartStopText())
    MoneyLooterTimeFS:SetText(tostring(date("!%X", GetTimer())))
    MoneyLooterRawGoldFS:SetText(GetCoinTextureString(GetRawGold()))
    MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(GetItemsMoney()))
    MoneyLooterGPHFS:SetText(GetCoinTextureString(CalcGPH()))
    MoneyLooterPriciestFS:SetText(GetCoinTextureString(GetPriciest()))
    if IsScrollLootFrameVisible() then
        SetScrollLootFrameVisible(true)
        MoneyLooterMinimizeCheck:SetChecked(true)
    else
        SetScrollLootFrameVisible(false)
        MoneyLooterMinimizeCheck:SetChecked(false)
    end
    SetVisible(IsVisible())
    if IsRunning() then RegisterStartEvents() end
end

function PopulateLoot()
    if GetListLootedItemsCount() > 0 then
        local lootedItems = GetListLootedItems()
        for i = 1, #lootedItems do
            local lootedItem = lootedItems[i]
            MoneyLooterScrollLootFrame:AddMessage(lootedItem.amount ..
                "x" ..
                CreateTextureFromItemID(lootedItem.id) ..
                lootedItem.name .. " " .. GetCoinTextureString(lootedItem.value, 12))
        end
    end
end

function MoneyLooterUpdateTexts(self, _)
    AddOneToTimer()
    MoneyLooterTimeFS:SetText(SetCurrentTimeText(tostring(date("!%X", GetTimer()))))
    MoneyLooterRawGoldFS:SetText(GetCoinTextureString(GetRawGold()))
    MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(GetItemsMoney()))
    SetTimeSinceLastUpdate(0)
    MoneyLooterGPHFS:SetText(GetCoinTextureString(CalcGPH()))
    SetTimeSinceLastUpdateGPH(0)
end

function MoneyLooterUpdateLoot(self, _)
    local lootedItems = GetLootedItems()
    for i = 1, #lootedItems do
        local lootedItem = lootedItems[i]
        MoneyLooterScrollLootFrame:AddMessage(lootedItem.amount ..
            "x" ..
            CreateTextureFromItemID(lootedItem.id) ..
            lootedItem.name .. " " .. GetCoinTextureString(lootedItem.value, 12))
    end
    MoneyLooterPriciestFS:SetText(GetCoinTextureString(GetPriciest()))
    SetLootedItems({})
end

MoneyLooterStartButton:SetScript(ML_EVENTS.OnClick, function()
    if IsRunning() then
        SetRunning(false)
        MoneyLooterStartButton:SetText(SetCurrentStartStopText(_G.MONEYLOOTER_L_CONTINUE))
        UnregisterStartEvents()
    else
        SetRunning(true)
        SetOldMoney(GetMoney())
        MoneyLooterStartButton:SetText(SetCurrentStartStopText(_G.MONEYLOOTER_L_PAUSE))
        RegisterStartEvents()
    end
end)

MoneyLooterCloseButton:SetScript(ML_EVENTS.OnClick, function()
    SetVisible(false)
    print(_G.MONEYLOOTER_L_CLOSE);
end)

MoneyLooterMinimizeCheck:SetScript(ML_EVENTS.OnClick, function()
    if IsScrollLootFrameVisible() then
        SetScrollLootFrameVisible(false)
    else
        SetScrollLootFrameVisible(true)
    end
end)

MoneyLooterPriciestFS:SetScript(ML_EVENTS.OnEnter, function()
    if GetPriciestID() == nil then return end
    GameTooltip:SetOwner(MoneyLooterPriciestFS, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:SetItemByID(GetPriciestID())
    GameTooltip:Show()
end)

MoneyLooterPriciestFS:SetScript(ML_EVENTS.OnLeave, function()
    GameTooltip:Hide()
end)

-----------------------------------------------------------------------------------------------
local MoneyLooterLootEvents = CreateFrame("Frame")

local MoneyLooterTextEvents = MoneyLooterMainUIFrame:CreateAnimationGroup()
local MoneyLooterTextEventsTimer = MoneyLooterTextEvents:CreateAnimation()
MoneyLooterTextEventsTimer:SetDuration(1)
MoneyLooterTextEvents:SetLooping("REPEAT")

function RegisterStartEvents()
    MoneyLooterLootEvents:RegisterEvent(ML_EVENTS.ChatMsgMoney)
    MoneyLooterLootEvents:RegisterEvent(ML_EVENTS.ChatMsgLoot)
    MoneyLooterLootEvents:RegisterEvent(ML_EVENTS.MerchantUpdate)
    MoneyLooterLootEvents:SetScript(ML_EVENTS.OnEvent, LootEventHandler)

    MoneyLooterTextEvents:Play()
    MoneyLooterTextEvents:SetScript(ML_EVENTS.OnLoop, MoneyLooterUpdateTexts)
end

function UnregisterStartEvents()
    MoneyLooterLootEvents:UnregisterEvent(ML_EVENTS.ChatMsgMoney)
    MoneyLooterLootEvents:UnregisterEvent(ML_EVENTS.ChatMsgLoot)
    MoneyLooterLootEvents:UnregisterEvent(ML_EVENTS.MerchantUpdate)
    MoneyLooterLootEvents:SetScript(ML_EVENTS.OnEvent, nil)

    MoneyLooterTextEvents:Stop()
    MoneyLooterTextEvents:SetScript(ML_EVENTS.OnLoop, nil)
end

MoneyLooterMainUIFrame:SetScript(ML_EVENTS.OnDragStart, MoneyLooterMainUIFrame.StartMoving)
MoneyLooterMainUIFrame:SetScript(ML_EVENTS.OnDragStop, MoneyLooterMainUIFrame.StopMovingOrSizing)
MoneyLooterMainUIFrame:SetScript(ML_EVENTS.OnHide, MoneyLooterMainUIFrame.StopMovingOrSizing)

MoneyLooterScrollLootFrame:SetScript(ML_EVENTS.OnHyperLinkClick, function(_, link, text)
    SetItemRef(link, text);
end)
MoneyLooterScrollLootFrame:SetScript(ML_EVENTS.OnHyperLinkEnter, OnHyperlinkEnter)
MoneyLooterScrollLootFrame:SetScript(ML_EVENTS.OnHyperLinkLeave, OnHyperlinkLeave)

MoneyLooterResetButton:SetScript(ML_EVENTS.OnClick, function()
    if IsRunning() then
        UnregisterStartEvents()
        MoneyLooterLootEvents:SetScript(ML_EVENTS.OnEvent, nil)
        MoneyLooterTextEvents:SetScript(ML_EVENTS.OnLoop, nil)
    end
    local minimizeButtonState = IsScrollLootFrameVisible()
    ResetMoneyLooterDB()
    MoneyLooterStartButton:SetText(GetCurrentStartStopText())
    MoneyLooterTimeFS:SetText(SetCurrentTimeText(tostring(date("!%X", 0))))
    MoneyLooterRawGoldFS:SetText(GetCoinTextureString(0))
    MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(0))
    MoneyLooterGPHFS:SetText(GetCoinTextureString(0))
    MoneyLooterPriciestFS:SetText(GetCoinTextureString(0))
    SetOldMoney(GetMoney())
    MoneyLooterScrollLootFrame:Clear()
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
        local tsmString = strsub(msg, 8)
        if tsmString == nil or tsmString == "" then
            print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING .. "|cFF36e8e6" .. GetCurrentTSMString() .. "|r")
            return
        end
        SetTSMString(tsmString)
    elseif strsub(msg, 1, 6) == "mprice" then
        ParseMinPrice(msg)
    else
        print(_G.MONEYLOOTER_L_USAGE .. ML_STRINGS.ML_ADDON_VERSION)
    end
end
SlashCmdList["MONEYLOOTER"] = slash

function ParseMinPrice(input)
    local mprice, value, coin = strsplit(" ", input, 3)
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
        end
    }
    local coinValue
    if coin == nil or coin == "g" then
        coinValue = 10000
        coin = "G"
    elseif coin == "s" then
        coinValue = 100
        coin = "S"
    else
        coinValue = 1
        coin = "C"
    end
    local qual = tonumber(strsub(mprice, 7, 8))
    mprices[qual](value * coinValue)
    local formatted = string.format("%s %s %s %s [%s]", _G.MONEYLOOTER_L_MPRICE_VALID, tostring(value),
        _G["MONEYLOOTER_L_MPRICE_COIN_" .. coin], _G["MONEYLOOTER_L_MPRICE_QUALITY_" .. tostring(qual)],
        tostring(qual))
    print(formatted)
end

-----------------------------------------------------------------------------------------------

local watcher = CreateFrame("Frame")
watcher:RegisterEvent(ML_EVENTS.AddonLoaded)

function WatcherOnEvent(self, event, arg1)
    if event == ML_EVENTS.AddonLoaded and arg1 == ML_STRINGS.ML_ADDON_NAME then
        print(_G.MONEYLOOTER_L_WELCOME)
        UpdateMLDB()
        UpdateMLXDB()
        PopulateData()
        PopulateLoot()
        watcher:UnregisterEvent(ML_EVENTS.AddonLoaded)
    end
end

watcher:SetScript(ML_EVENTS.OnEvent, WatcherOnEvent)
