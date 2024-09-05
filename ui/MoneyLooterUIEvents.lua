-- Author      : Will0w7
-- UIEvents --

----------------------------------------------------------------------------------
GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
----------------------------------------------------------------------------------

ML_UPDATE_STARTSTOP = CreateFrame("Frame")
ML_UPDATE_LOOT = CreateFrame("Frame")
ML_UPDATE_GPH = CreateFrame("Frame")

function PopulateData()
    MoneyLooterStartButton:SetText(GetCurrentStartStopText())
    MoneyLooterResetButton:SetText(_G.MONEYLOOTER_L_RESET)
    MoneyLooterTimeFS:SetText(date("!%X", GetTimer()))
    MoneyLooterRawGoldFS:SetText(GetCoinTextureString(GetRawMoney()))
    MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(GetItemsMoney()))
    MoneyLooterGPHFS:SetText(GetCoinTextureString(CalcGPH()))
    MoneyLooterPriciestFS:SetText(GetCoinTextureString(GetPriciest()))
    SetVisible(GetVisible())
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

function MLStartStopOnUpdate(self, elapsed)
    AddTimeSinceLastUpdate(elapsed)
    if GetTimeSinceLastUpdate() > 1.0 then
        if GetIsRunning() then
            MoneyLooterTimeFS:SetText(SetCurrentTimeText(date("!%X", GetTimer())))
            AddOneToTimer()
        end
        SetTimeSinceLastUpdate(0)
    end
    if GetIsRunning() then
        MoneyLooterRawGoldFS:SetText(GetCoinTextureString(GetRawMoney()))
        MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(GetItemsMoney()))
    end
end

function MLLootOnUpdate(self, elapsed)
    if GetIsRunning() and GetUpdate() then
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

function MLGPHOnUpdate(self, elapsed)
    AddTimeSinceLastUpdateGPH(elapsed)
    if GetTimeSinceLastUpdateGPH() > 2.0 then
        if GetIsRunning() then
            MoneyLooterGPHFS:SetText(GetCoinTextureString(CalcGPH()))
        end
        SetTimeSinceLastUpdateGPH(0)
    end
end

MoneyLooterResetButton:SetScript(ML_EVENTS.OnClick, function()
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

MoneyLooterStartButton:SetScript(ML_EVENTS.OnClick, function()
    if GetIsRunning() then
        SetIsRunning(false)
        MoneyLooterStartButton:SetText(SetCurrentStartStopText(_G.MONEYLOOTER_L_CONTINUE))
        SetRecordLoot(false)
    else
        SetIsRunning(true)
        SetOldMoney(GetMoney())
        MoneyLooterStartButton:SetText(SetCurrentStartStopText(_G.MONEYLOOTER_L_PAUSE))
        SetRecordLoot(true)
    end
end)

MoneyLooterCloseButton:SetScript(ML_EVENTS.OnClick, function()
    SetVisible(false)
    print(_G.MONEYLOOTER_L_CLOSE);
end)

ML_UPDATE_STARTSTOP:SetScript(ML_EVENTS.OnLoad, function()
    SetTimeSinceLastUpdate(0)
    SetTimeSinceLastUpdateGPH(0)
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

MoneyLooterMainUIFrame:SetScript(ML_EVENTS.OnDragStart, MoneyLooterMainUIFrame.StartMoving)
MoneyLooterMainUIFrame:SetScript(ML_EVENTS.OnDragStop, MoneyLooterMainUIFrame.StopMovingOrSizing)
MoneyLooterMainUIFrame:SetScript(ML_EVENTS.OnHide, MoneyLooterMainUIFrame.StopMovingOrSizing)
ML_UPDATE_LOOT:SetScript(ML_EVENTS.OnUpdate, MLLootOnUpdate)
ML_UPDATE_STARTSTOP:SetScript(ML_EVENTS.OnUpdate, MLStartStopOnUpdate)
ML_UPDATE_GPH:SetScript(ML_EVENTS.OnUpdate, MLGPHOnUpdate)

MoneyLooterScrollLootFrame:SetScript(ML_EVENTS.OnHyperLinkClick, function(_, link, text)
    SetItemRef(link, text);
end)
MoneyLooterScrollLootFrame:SetScript(ML_EVENTS.OnHyperLinkEnter, OnHyperlinkEnter)
MoneyLooterScrollLootFrame:SetScript(ML_EVENTS.OnHyperLinkLeave, OnHyperlinkLeave)

SLASH_MONEYLOOTER1 = "/ml"
SLASH_MONEYLOOTER2 = "/moneylooter"

local function slash(msg, _)
    if msg == "show" or (msg == "" and not MoneyLooterMainUIFrame:IsVisible()) then
        SetVisible(true)
    elseif msg == "hide" or (msg == "" and MoneyLooterMainUIFrame:IsVisible()) then
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

local watcher = CreateFrame("Frame")
watcher:RegisterEvent(ML_EVENTS.AddonLoaded)
watcher:RegisterEvent(ML_EVENTS.VariablesLoaded)
watcher:RegisterEvent(ML_EVENTS.PlayerLogout)

function WatcherOnEvent(self, event, arg1)
    if event == ML_EVENTS.AddonLoaded and arg1 == ML_STRINGS.ML_ADDON_NAME then
        PopulateData()
        PopulateLoot()
        print(_G.MONEYLOOTER_L_WELCOME)
    end
end

watcher:SetScript(ML_EVENTS.OnEvent, WatcherOnEvent)
