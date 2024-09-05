-- Author      : Will0w7
-- MoneyLooterUIEvents --

----------------------------------------------------------------------------------
GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
----------------------------------------------------------------------------------

function PopulateData()
    MoneyLooterStartButton:SetText(GetCurrentStartStopText())
    MoneyLooterTimeFS:SetText(date("!%X", GetTimer()))
    MoneyLooterRawGoldFS:SetText(GetCoinTextureString(GetRawGold()))
    MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(GetItemsMoney()))
    MoneyLooterGPHFS:SetText(GetCoinTextureString(CalcGPH()))
    MoneyLooterPriciestFS:SetText(GetCoinTextureString(GetPriciest()))
    SetVisible(IsVisible())
    if IsRunning() then RegisterStartEvents() end
end

function PopulateLoot()
    if GetListLootedItemsCount() > 0 then
        local lootedItems = GetListLootedItems()
        for _, lootedItem in ipairs(lootedItems) do
            MoneyLooterScrollLootFrame:AddMessage(lootedItem.amount ..
                "x" ..
                CreateTextureFromItemID(lootedItem.id) ..
                lootedItem.name .. " " .. GetCoinTextureString(lootedItem.value, 12))
        end
    end
end

function MoneyLooterUpdateTexts(self, elapsed)
    if AddTimeSinceLastUpdate(elapsed) > 1.0 and IsRunning() then
        AddOneToTimer()
        MoneyLooterTimeFS:SetText(SetCurrentTimeText(date("!%X", GetTimer())))
        MoneyLooterRawGoldFS:SetText(GetCoinTextureString(GetRawGold()))
        MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(GetItemsMoney()))
        SetTimeSinceLastUpdate(0)
        MoneyLooterGPHFS:SetText(GetCoinTextureString(CalcGPH()))
        SetTimeSinceLastUpdateGPH(0)
    end
end

function MoneyLooterUpdateLoot(self, elapsed)
    if GetUpdate() and IsRunning() then
        local lootedItems = GetLootedItems()
        for _, lootedItem in ipairs(lootedItems) do
            MoneyLooterScrollLootFrame:AddMessage(lootedItem.amount ..
                "x" ..
                CreateTextureFromItemID(lootedItem.id) ..
                lootedItem.name .. " " .. GetCoinTextureString(lootedItem.value, 12))
        end
        MoneyLooterPriciestFS:SetText(GetCoinTextureString(GetPriciest()))
        SetLootedItems({})
        SetUpdate(false)
    end
end

MoneyLooterStartButton:SetScript(ML_EVENTS.OnClick, function()
    if IsRunning() then
        SetRunning(false)
        MoneyLooterStartButton:SetText(SetCurrentStartStopText(_G.MONEYLOOTER_L_CONTINUE))
        SetRecordLoot(false)
        UnregisterStartEvents()
    else
        SetRunning(true)
        SetOldMoney(GetMoney())
        MoneyLooterStartButton:SetText(SetCurrentStartStopText(_G.MONEYLOOTER_L_PAUSE))
        RegisterStartEvents()
        SetRecordLoot(true)
    end
end)

MoneyLooterCloseButton:SetScript(ML_EVENTS.OnClick, function()
    SetVisible(false)
    print(_G.MONEYLOOTER_L_CLOSE);
end)

MoneyLooterMinimizeCheck:SetScript(ML_EVENTS.OnClick, function()
    print("UIEvents isVisible: " .. tostring(IsScrollLootFrameVisible()))
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
local MoneyLooterLootItemsEventsFrame = CreateFrame("Frame")
local MoneyLooterTextEventsFrame = CreateFrame("Frame")

function RegisterStartEvents()
    MoneyLooterLootEventsFrame:RegisterEvent(ML_EVENTS.ChatMsgMoney)
    MoneyLooterLootEventsFrame:RegisterEvent(ML_EVENTS.ChatMsgLoot)
    MoneyLooterLootEventsFrame:RegisterEvent(ML_EVENTS.MerchantUpdate)

    MoneyLooterLootItemsEventsFrame:SetScript(ML_EVENTS.OnUpdate, MoneyLooterUpdateLoot)
    MoneyLooterTextEventsFrame:SetScript(ML_EVENTS.OnUpdate, MoneyLooterUpdateTexts)
end

function UnregisterStartEvents()
    MoneyLooterLootEventsFrame:UnregisterEvent(ML_EVENTS.ChatMsgMoney)
    MoneyLooterLootEventsFrame:UnregisterEvent(ML_EVENTS.ChatMsgLoot)
    MoneyLooterLootEventsFrame:UnregisterEvent(ML_EVENTS.MerchantUpdate)

    MoneyLooterLootItemsEventsFrame:SetScript(ML_EVENTS.OnUpdate, nil)
    MoneyLooterTextEventsFrame:SetScript(ML_EVENTS.OnUpdate, nil)
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
        MoneyLooterLootItemsEventsFrame:SetScript(ML_EVENTS.OnUpdate, nil)
        MoneyLooterTextEventsFrame:SetScript(ML_EVENTS.OnUpdate, nil)
    end
    ResetMoneyLooterDB()
    MoneyLooterStartButton:SetText(GetCurrentStartStopText())
    MoneyLooterTimeFS:SetText(SetCurrentTimeText(date("!%X", 0)))
    MoneyLooterRawGoldFS:SetText(GetCoinTextureString(0))
    MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(0))
    MoneyLooterGPHFS:SetText(GetCoinTextureString(0))
    MoneyLooterPriciestFS:SetText(GetCoinTextureString(0))
    SetOldMoney(GetMoney())
    MoneyLooterScrollLootFrame:Clear()
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
        SetTSMString(tsmString)
    else
        print(_G.MONEYLOOTER_L_USAGE .. ML_STRINGS.ML_ADDON_VERSION)
    end
end
SlashCmdList["MONEYLOOTER"] = slash

-----------------------------------------------------------------------------------------------

local watcher = CreateFrame("Frame")
watcher:RegisterEvent(ML_EVENTS.AddonLoaded)

function WatcherOnEvent(self, event, arg1)
    if event == ML_EVENTS.AddonLoaded and arg1 == ML_STRINGS.ML_ADDON_NAME then
        print(_G.MONEYLOOTER_L_WELCOME)
        UpdateMLDB()
        PopulateData()
        PopulateLoot()
        watcher:UnregisterEvent(ML_EVENTS.AddonLoaded)
    end
end

watcher:SetScript(ML_EVENTS.OnEvent, WatcherOnEvent)