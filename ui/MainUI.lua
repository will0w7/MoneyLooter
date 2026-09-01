---@class MoneyLooter
local MoneyLooter = select(2, ...)
---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_Utils
local Utils = MoneyLooter.Utils
---@class ML_DataProvider
local DataProvider = MoneyLooter.DataProvider
---@class ML_Data
local Data = MoneyLooter.Data
---@class ML_CBFunctions
local CBFunctions = MoneyLooter.CBFunctions
---@class ML_SMFunctions
local SMFunctions = MoneyLooter.SMFunctions
---@class ML_Profiler
local Profiler = MoneyLooter.Profiler

---@class ML_UI
local UI = {}
MoneyLooter.UI = UI

------------------------------------------------------------------------------
local CreateFrame = CreateFrame
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local GetMoney = GetMoney
------------------------------------------------------------------------------
local tostring, date, print, tonumber = tostring, date, print, tonumber
local strlenutf8, ipairs, unpack = strlenutf8, ipairs, unpack
------------------------------------------------------------------------------

---@param itemId number
---@return string
local function CreateTextureFromItemID(itemId)
    return ("|T%s:0|t"):format(tostring(C_Item.GetItemIconByID(itemId)))
end

---@class ML_ItemScrollMixin
ML_ItemScrollMixin = {}

function ML_ItemScrollMixin:OnClick()
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    local elementData = self:GetElementData()
    SetItemRef(elementData.itemLink, elementData.itemLink)
    GameTooltip:Show()
end

function ML_ItemScrollMixin:OnRemoveClick()
    local elementData = self:GetElementData()
    if not elementData then return end
    if not Data.IsSummaryMode() and elementData.entryId == nil then return end

    local confirmText = ""
    if Data.IsSummaryMode() then
        confirmText = string.format(_G.MONEYLOOTER_L_REMOVE_CONFIRM,
            "|cffff0000" .. _G.MONEYLOOTER_L_ALL .. "|r " .. elementData.itemLink)
    else
        confirmText = string.format(_G.MONEYLOOTER_L_REMOVE_CONFIRM, elementData.itemLink)
    end

    StaticPopupDialogs["MONEYLOOTER_REMOVE_ITEM"] = {
        text = confirmText,
        button1 = _G.YES,
        button2 = _G.NO,
        OnAccept = function()
            if Data.IsSummaryMode() then
                self:RemoveItemsFromSession(elementData)
            else
                self:RemoveItemFromSession(elementData)
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("MONEYLOOTER_REMOVE_ITEM")
end

function ML_ItemScrollMixin:RemoveItemsFromSession(elementData)
    if not elementData then return end
    Data.RemoveAllLootedItemsByID(elementData)
end

function ML_ItemScrollMixin:RemoveItemFromSession(elementData)
    if not elementData then return end
    Data.RemoveLootedItem(elementData)
end

function ML_ItemScrollMixin:Init()
    ---@class ML_Item
    local elementData = self:GetElementData()
    self:SetRightText(elementData.value * elementData.quantity)
    self:SetLeftText(elementData.id, elementData.quantity, elementData.itemLink)
    self.RemoveButton:SetShown(Data.IsSummaryMode() or elementData.entryId ~= nil)
    self:TrimDataProvider()
end

---@param alternate boolean
function ML_ItemScrollMixin:SetAlternateOverlayShown(alternate)
    self.Alternate:SetShown(alternate)
end

---@param id number
---@param quantity number
---@param itemLink string
function ML_ItemScrollMixin:SetLeftText(id, quantity, itemLink)
    self.LeftLabel:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(("%dx %s%s"):format(quantity,
        CreateTextureFromItemID(id), itemLink)))
end

---@param value number
function ML_ItemScrollMixin:SetRightText(value)
    self.RightLabel:SetText(Utils.GetCoinTextString(value))
end

function ML_ItemScrollMixin:TrimDataProvider()
    local dataProvider = self:GetParent().DataProvider
    if not dataProvider then return end

    local maxCapacity = MoneyLooter.Data.CBCapacity
    local dataProviderSize = dataProvider:GetSize()

    if dataProviderSize > maxCapacity then
        local extra = math.floor(maxCapacity * 0.25)
        local overflow = dataProviderSize - maxCapacity
        dataProvider:RemoveIndexRange(1, overflow + extra)
    end
end

---@class ML_ButtonMixin
ML_ButtonMixin = {}

---@param val string
function ML_ButtonMixin:SetText(val)
    self.Label:SetText(val)
end

---@param seconds number
---@return string
local function FormatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60

    return string.format("%02d:%02d:%02d", h, m, s)
end

---@param time integer
---@param rawGold integer
---@param itemsGold integer
---@param gph integer
---@param priciest integer
local function UpdateAllTexts(time, rawGold, itemsGold, gph, priciest)
    Data.SetOldMoney(GetMoney())
    UI.MLMainFrame.StartButton:SetText(Data.GetCurrentStartText())
    UI.MLMainFrame.TimeFS:SetText(tostring(FormatTime(time)))
    UI.MLMainFrame.RawGoldFS:SetText(Utils.GetCoinTextString(rawGold))
    UI.MLMainFrame.ItemsGoldFS:SetText(Utils.GetCoinTextString(itemsGold))
    UI.MLMainFrame.GPHFS:SetText(Utils.GetCoinTextString(gph))
    UI.MLMainFrame.PriciestFS:SetText(Utils.GetCoinTextString(priciest))
end

local function UpdateTexts()
    UI.MLMainFrame.TimeFS:SetText(tostring(FormatTime(Data.AddOneToTimer())))
    UI.MLMainFrame.GPHFS:SetText(Utils.GetCoinTextString(Data.CalcGPH()))
end

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

local function RebuildSummary()
    Profiler.Start("RebuildSummary")
    Data.ResetSummary()
    CBFunctions.Iterate(Data.GetListLootedItems(), Data.InsertSummaryItem)
    Profiler.Stop("RebuildSummary")
end

local function PopulateSummary()
    RebuildSummary()
    Profiler.Start("PopulateSummary")
    UI.MLMainFrame.ScrollBoxLoot.DataProvider:Flush()
    local topItems = SMFunctions.GetTopItems(Data.GetSummary())
    Profiler.Start("PopulateSummary.BulkInsert")
    UI.MLMainFrame.ScrollBoxLoot.DataProvider:BulkInsert(unpack(topItems))
    Profiler.Stop("PopulateSummary.BulkInsert")
    Profiler.Stop("PopulateSummary")
end

local function PopulateLoot()
    Profiler.Start("PopulateLoot")
    Data.InitListLootedItems()
    UI.MLMainFrame.ScrollBoxLoot.DataProvider:Flush()
    if Data.GetListLootedItemsCount() > 0 then
        local lootedItems = CBFunctions.ToTable(Data.GetListLootedItems())
        Profiler.Start("PopulateLoot.BulkInsert")
        UI.MLMainFrame.ScrollBoxLoot.DataProvider:BulkInsert(unpack(lootedItems))
        Profiler.Stop("PopulateLoot.BulkInsert")
    end
    UI.MLMainFrame.ScrollBoxLoot:ScrollToEnd()
    Profiler.Stop("PopulateLoot")
end

local MoneyLooterLootEvents = CreateFrame("Frame")

---@type FunctionContainer
local timer

local EVENTS = {
    Constants.Events.ChatMsgMoney,
    Constants.Events.ChatMsgLoot,
    Constants.Events.QuestTurnedIn,
    Constants.Events.PInteractionManagerShow,
    Constants.Events.PInteractionManagerHide,
    Constants.Events.ChatMsgSystem,
}

local function RegisterStartEvents()
    for _, ev in ipairs(EVENTS) do
        MoneyLooterLootEvents:RegisterEvent(ev)
    end
    MoneyLooterLootEvents:SetScript("OnEvent", MoneyLooter.Core.OnEvent)

    timer = C_Timer.NewTicker(1, UpdateTexts)
end

local function UnregisterStartEvents()
    MoneyLooterLootEvents:UnregisterAllEvents()
    MoneyLooterLootEvents:SetScript("OnEvent", nil)

    if not timer:IsCancelled() then timer:Cancel() end
end

local function PopulateData()
    Constants.Strings.ADDON_VERSION = GetAddOnMetadata(Constants.Strings.ADDON_NAME, "Version")
    MoneyLooter.Config.ApplyScale()

    UpdateAllTexts(Data.GetTimer(), Data.GetRawMoney(), Data.GetItemsMoney(), Data.CalcGPH(), Data.GetPriciest())

    SetScrollVisible(Data.IsScrollLootFrameVisible())
    SetMainVisible(Data.IsVisible())

    if Data.IsRunning() then RegisterStartEvents() end
end

function UI.UpdateRawMoney()
    UI.MLMainFrame.RawGoldFS:SetText(Utils.GetCoinTextString(Data.GetRawMoney()))
end

---@param item ML_Item
function UI.UpdateLoot(item)
    if not Data.IsSummaryMode() then
        Profiler.Start("UpdateLoot.SingleInsert")
        UI.MLMainFrame.ScrollBoxLoot.DataProvider:SingleInsert(item)
        Profiler.Stop("UpdateLoot.SingleInsert")
        UI.MLMainFrame.ScrollBoxLoot:ScrollToEnd()
    else
        PopulateSummary()
    end
    UI.MLMainFrame.PriciestFS:SetText(Utils.GetCoinTextString(Data.GetPriciest()))
    UI.MLMainFrame.ItemsGoldFS:SetText(Utils.GetCoinTextString(Data.GetItemsMoney()))
end

---@param parent ML_MainFrame
---@return table|Frame
local function CreateTitleBar(parent)
    local titleBar = CreateFrame("Frame", nil, parent, "ML_TitleBar")
    titleBar:SetPoint("TOPLEFT")
    titleBar:SetPoint("TOPRIGHT")
    titleBar.Label:SetText(Constants.Strings.TITLE)
    return titleBar
end

---@param parent ML_MainFrame
---@return table|Button
local function CreateCloseButton(parent)
    local btn = CreateFrame("Button", nil, parent, "ML_CloseButton")
    btn:SetSize(20, 20)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, -5)

    btn:SetScript(Constants.Events.OnClick, function()
        SetMainVisible(false)
        print(_G.MONEYLOOTER_L_CLOSE)
    end)

    return btn
end

---@param parent ML_MainFrame
---@return table|CheckButton
local function CreateMinimizeCheckButton(parent)
    local checkButton = CreateFrame("CheckButton", nil, parent, "ML_CheckButton")
    checkButton:SetChecked(true)

    checkButton:SetScript(Constants.Events.OnClick, function(_, button)
        if button == Constants.Inputs.LeftButton then
            SetScrollVisible(not Data.IsScrollLootFrameVisible())
        elseif button == Constants.Inputs.RightButton then
            local mode = not Data.IsSummaryMode()
            Data.SetSummaryMode(mode)
            if mode then
                PopulateSummary()
            else
                PopulateLoot()
            end
        end
        checkButton:SetChecked(Data.IsScrollLootFrameVisible())
    end)

    return checkButton
end

---@param parent ML_MainFrame
---@return table|Button
local function CreateStartButton(parent)
    local button = CreateFrame("Button", nil, parent, "ML_Button")
    button:SetPoint("BOTTOMLEFT", 5, 5)
    button:SetSize(65, 20)
    button:SetText(_G.MONEYLOOTER_L_START)

    button:SetScript(Constants.Events.OnClick, function()
        if Data.IsRunning() then
            Data.SetRunning(false)
            button:SetText(Data.SetCurrentStartText(_G.MONEYLOOTER_L_CONTINUE))
            UnregisterStartEvents()
        else
            Data.SetRunning(true)
            Data.SetOldMoney(GetMoney())
            button:SetText(Data.SetCurrentStartText(_G.MONEYLOOTER_L_PAUSE))
            RegisterStartEvents()
        end
    end)

    return button
end

---@param parent ML_MainFrame
---@return table|Button
local function CreateResetButton(parent)
    local button = CreateFrame("Button", nil, parent, "ML_Button")
    button:SetPoint("BOTTOMRIGHT", -32, 5)
    button:SetSize(60, 20)
    button:SetText(_G.MONEYLOOTER_L_RESET)

    button:SetScript(Constants.Events.OnClick, function()
        if Data.IsRunning() then UnregisterStartEvents() end

        local forceVendor = Data.GetForceVendorPrice()
        local disenchant = Data.GetUseDisenchantValue()
        local scrollVisible = Data.IsScrollLootFrameVisible()
        Data.ResetMoneyLooterDB()
        UpdateAllTexts(0, 0, 0, 0, 0)
        UI.MLMainFrame.ScrollBoxLoot.DataProvider:Flush()
        Data.SetScrollLootFrameVisible(scrollVisible)
        Data.SetForceVendorPrice(forceVendor)
        Data.SetUseDisenchantValue(disenchant)
    end)

    return button
end

---@param parent ML_MainFrame
---@return table|Button
local function CreateConfigButton(parent)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(20, 20)
    btn:SetPoint("BOTTOMRIGHT", -10, 5)

    btn:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
    btn:GetNormalTexture():SetDesaturated(true)

    btn:SetHighlightTexture("Interface\\Buttons\\UI-OptionsButton")
    btn:GetHighlightTexture():SetDesaturated(true)
    btn:GetHighlightTexture():SetVertexColor(1.4, 1.4, 1.4, 1)

    btn:SetPushedTexture("Interface\\Buttons\\UI-OptionsButton")
    btn:GetPushedTexture():SetDesaturated(true)
    btn:GetPushedTexture():SetVertexColor(0.6, 0.6, 0.6, 1)

    btn:SetScript(Constants.Events.OnClick, function()
        MoneyLooter.Config.Toggle()
    end)

    return btn
end

---@param parent ML_MainFrame
---@return table
local function CreateStatisticLabels(parent)
    ---@param stat table
    ---@return FontString, FontString
    local function createLabelPair(stat)
        local label = parent:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
        label:SetPoint("TOPLEFT", 5, stat[3])
        label:SetText(stat[1])

        local value = parent:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
        value:SetPoint("TOPRIGHT", -8, stat[3])
        value:SetJustifyH("RIGHT")
        if stat[2] then value:SetText(stat[2]) end

        return label, value
    end

    local yOffset = -40
    local yStep = -20
    local stats = {
        { _G.MONEYLOOTER_L_TIME_LABEL,     tostring(date("!%X", 0)), yOffset },
        { _G.MONEYLOOTER_L_GOLD_LABEL,     nil,                      yOffset + yStep },
        { _G.MONEYLOOTER_L_ITEMS_LABEL,    nil,                      yOffset + yStep * 2 },
        { _G.MONEYLOOTER_L_GPH_LABEL,      nil,                      yOffset + yStep * 3 },
        { _G.MONEYLOOTER_L_PRICIEST_LABEL, nil,                      yOffset + yStep * 4 }
    }

    local labels = {}
    labels.TimeLabel, labels.Time = createLabelPair(stats[1])
    labels.RawGoldLabel, labels.RawGold = createLabelPair(stats[2])
    labels.ItemsGoldLabel, labels.ItemsGold = createLabelPair(stats[3])
    labels.GPHLabel, labels.GPH = createLabelPair(stats[4])
    labels.PriciestLabel, labels.Priciest = createLabelPair(stats[5])

    labels.Priciest:SetScript(Constants.Events.OnEnter, function()
        local priciestLink = Data.GetPriciestLink()
        if priciestLink == nil or priciestLink == "" then return end
        GameTooltip:SetOwner(labels.Priciest, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:SetHyperlink(priciestLink)
        GameTooltip:Show()
    end)
    labels.Priciest:SetScript(Constants.Events.OnLeave, function()
        GameTooltip:Hide()
    end)

    return labels
end

---@param parent ML_MainFrame
---@return table|Frame
local function CreateLootScrollBox(parent)
    local scrollBox = CreateFrame("Frame", nil, parent, "ML_WowScrollBoxList")
    scrollBox:SetResizable(true)

    scrollBox.ScrollBar = CreateFrame("EventFrame", nil, scrollBox, "MinimalScrollBar")
    scrollBox.ElementFactory = function(factory)
        factory("ML_ItemScroll", function(button, elementData)
            button:Init(elementData)
        end)
    end
    -- scrollBox.ElementFactory = {}
    scrollBox.DataProvider = DataProvider.CreateDataProvider()
    scrollBox.ScrollView = CreateScrollBoxListLinearView()
    scrollBox.ScrollView:SetElementFactory(scrollBox.ElementFactory)
    scrollBox.ScrollView:SetDataProvider(scrollBox.DataProvider)

    ---@param frame Frame
    ---@param alternate boolean
    local function ApplyAlternateState(frame, alternate)
        frame:SetAlternateOverlayShown(alternate)
    end

    ---@param button Button
    local function Initializer(button)
        button:Init()
    end

    ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBox.ScrollBar, scrollBox.ScrollView)
    ScrollUtil.RegisterAlternateRowBehavior(scrollBox, ApplyAlternateState)
    scrollBox.ScrollView:SetElementInitializer("ML_ItemScroll", Initializer)

    return scrollBox
end

---@param parent ML_MainFrame
---@return table|Button
local function CreateResizeGrip(parent)
    local grip = CreateFrame("Button", nil, parent)
    grip:SetPoint("BOTTOMRIGHT", 0, 0)
    grip:SetSize(16, 16)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")

    grip:SetScript(Constants.Events.OnMouseDown, function(self)
        self:GetParent():StartSizing("BOTTOMRIGHT")
    end)
    grip:SetScript(Constants.Events.OnMouseUp, function(self)
        self:GetParent():StopMovingOrSizing()
    end)
    return grip
end

---@return table|Frame|ML_MainFrame
local function CreateMainFrame()
    local mainFrame = CreateFrame("Frame", "MONEYLOOTER_MAIN_FRAME", UIParent, "ML_MainFrame")
    mainFrame:SetPoint("CENTER")
    mainFrame:EnableMouse(true)
    mainFrame:SetMovable(true)
    mainFrame:RegisterForDrag(Constants.Inputs.LeftButton)

    mainFrame:SetResizable(true)

    mainFrame.TitleBar = CreateTitleBar(mainFrame)
    mainFrame.CloseButton = CreateCloseButton(mainFrame)
    mainFrame.MinimizeCheck = CreateMinimizeCheckButton(mainFrame)
    mainFrame.StartButton = CreateStartButton(mainFrame)
    mainFrame.ResetButton = CreateResetButton(mainFrame)
    mainFrame.ConfigButton = CreateConfigButton(mainFrame)

    local stats = CreateStatisticLabels(mainFrame)
    mainFrame.TimeLabelFS = stats.TimeLabel
    mainFrame.TimeFS = stats.Time
    mainFrame.RawGoldLabelFS = stats.RawGoldLabel
    mainFrame.RawGoldFS = stats.RawGold
    mainFrame.ItemsGoldLabelFS = stats.ItemsGoldLabel
    mainFrame.ItemsGoldFS = stats.ItemsGold
    mainFrame.GPHLabelFS = stats.GPHLabel
    mainFrame.GPHFS = stats.GPH
    mainFrame.PriciestLabelFS = stats.PriciestLabel
    mainFrame.PriciestFS = stats.Priciest

    mainFrame.ScrollBoxLoot = CreateLootScrollBox(mainFrame)
    mainFrame.ScrollLootBar = mainFrame.ScrollBoxLoot.ScrollBar

    mainFrame.ResizeGrip = CreateResizeGrip(mainFrame)

    function mainFrame:UpdateLayout(width, height)
        local MIN_WIDTH, MIN_HEIGHT = 170, 170
        local MAX_WIDTH, MAX_HEIGHT = 300, 400

        if width < MIN_WIDTH then
            width = MIN_WIDTH
        end
        if width > MAX_WIDTH then
            width = MAX_WIDTH
        end
        if height < MIN_HEIGHT then
            height = MIN_HEIGHT
        end
        if height > MAX_HEIGHT then
            height = MAX_HEIGHT
        end

        self.TitleBar:SetWidth(width)

        self.ScrollBoxLoot:ClearAllPoints()
        self.ScrollBoxLoot:SetPoint("TOPLEFT", width, 0)

        self.ScrollBoxLoot:SetSize(width * 1.5, height)
        self:SetSize(width, height)
    end

    mainFrame:SetScript("OnSizeChanged", function(frame, width, height)
        frame:UpdateLayout(width, height)
    end)

    mainFrame:SetScript(Constants.Events.OnDragStart, mainFrame.StartMoving)
    mainFrame:SetScript(Constants.Events.OnDragStop, mainFrame.StopMovingOrSizing)
    mainFrame:SetScript(Constants.Events.OnHide, mainFrame.StopMovingOrSizing)

    local initialWidth, initialHeight = mainFrame:GetSize()
    mainFrame:UpdateLayout(initialWidth, initialHeight)

    return mainFrame
end

---@class ML_MainFrame : Frame
UI.MLMainFrame = CreateMainFrame()

Data.RegisterCallback("ML_OnItemRemoved", function()
    UpdateAllTexts(Data.GetTimer(), Data.GetRawMoney(), Data.GetItemsMoney(), Data.CalcGPH(), Data.GetPriciest())

    if not Data.IsSummaryMode() then
        PopulateLoot()
    else
        PopulateSummary()
    end
end)

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

local function ParseTime(msg)
    local _, time = string.split(" ", msg, 2)
    if time == nil or strlenutf8(time) < 1 then
        print(_G.MONEYLOOTER_L_TIME_ERROR)
        return 0
    end
    local hours = nil
    local minutes = nil
    local seconds = nil
    if string.find(time, "h") then
        hours, time = string.split("h", time, 2)
    end
    if string.find(time, "m") then
        minutes, time = string.split("m", time, 2)
    end
    if string.find(time, "s") then
        seconds = string.split("s", time, 2)
    end
    local total = tonumber(0)
    if seconds ~= nil then
        total = total + tonumber(seconds)
    end
    if minutes ~= nil then
        total = total + (tonumber(minutes) * 60)
    end
    if hours ~= nil then
        total = total + (tonumber(hours) * 60 * 60)
    end
    return total
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
    elseif string.sub(msg, 1, 10) == "disenchant" then
        local enable = not Data.GetUseDisenchantValue()
        Data.SetUseDisenchantValue(enable)
        if enable then
            print(_G.MONEYLOOTER_L_USE_DISENCHANT_VALUE_ENABLED)
        else
            print(_G.MONEYLOOTER_L_USE_DISENCHANT_VALUE_DISABLED)
        end
    elseif string.sub(msg, 1, 7) == "addtime" then
        local time = ParseTime(msg)
        if time > 0 then
            Data.AddXToTimer(time)
        end
    elseif string.sub(msg, 1, 7) == "subtime" then
        local time = ParseTime(msg)
        if time > 0 then
            Data.SubXFromTimer(time)
        end
    elseif msg == "profiler" then
        Profiler.ToggleProfiler()
    else
        print(_G.MONEYLOOTER_L_USAGE .. Constants.Strings.ADDON_VERSION)
    end
end
SlashCmdList["MONEYLOOTER"] = slash

local watcher = CreateFrame("Frame")

local addonLoaded = false
local function WatcherOnEvent(_, event, arg1)
    if event == Constants.Events.AddonLoaded and arg1 == Constants.Strings.ADDON_NAME then
        addonLoaded = true
        watcher:UnregisterEvent(Constants.Events.AddonLoaded)
    elseif event == Constants.Events.PlayerEnteringWorld and addonLoaded then
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
