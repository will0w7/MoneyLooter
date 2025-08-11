---@class MoneyLooter
local MoneyLooter = select(2, ...)
local Constants = MoneyLooter.Constants
local Utils = MoneyLooter.Utils

---@class ML_UI
---@field MLMainFrame table|Frame
local UI = {}
MoneyLooter.UI = UI

local CreateFrame = CreateFrame
local tostring, date = tostring, date

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

function ML_ItemScrollMixin:Init()
    local elementData = self:GetElementData()
    self:SetRightText(elementData.value * elementData.quantity)
    self:SetLeftText(elementData.id, elementData.quantity, elementData.itemLink)
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
    self.LeftLabel:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(("%d-x %s%s"):format(quantity,
        CreateTextureFromItemID(id), itemLink)))
end

---@param value number
function ML_ItemScrollMixin:SetRightText(value)
    self.RightLabel:SetText(Utils.GetCoinTextString(value))
end

function ML_ItemScrollMixin:TrimDataProvider()
    local dataProvider = self:GetParent():GetParent().DataProvider
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

---@param parent Frame
---@return table|Frame
local function CreateTitleBar(parent)
    local titleBar = CreateFrame("Frame", nil, parent, "ML_TitleBar")
    titleBar:SetPoint("TOPLEFT")
    titleBar:SetPoint("TOPRIGHT")
    titleBar.Label:SetText(Constants.Strings.TITLE)
    return titleBar
end

---@param parent Frame
---@return table|Button
local function CreateCloseButton(parent)
    return CreateFrame("Button", nil, parent, "ML_CloseButton")
end

---@param parent Frame
---@return table|CheckButton
local function CreateMinimizeCheckButton(parent)
    local checkButton = CreateFrame("CheckButton", nil, parent, "ML_CheckButton")
    checkButton:SetChecked(true)
    return checkButton
end

---@param parent Frame
---@return table|Button
local function CreateStartButton(parent)
    local button = CreateFrame("Button", nil, parent, "ML_Button")
    button:SetPoint("BOTTOMLEFT", 5, 5)
    button:SetSize(65, 20)
    button:SetText(_G.MONEYLOOTER_L_START)
    return button
end

---@param parent Frame
---@return table|Button
local function CreateResetButton(parent)
    local button = CreateFrame("Button", nil, parent, "ML_Button")
    button:SetPoint("BOTTOMRIGHT", -18, 5)
    button:SetSize(65, 20)
    button:SetText(_G.MONEYLOOTER_L_RESET)
    return button
end

---@param parent Frame
---@return table|FontString
local function CreateStatisticLabels(parent)
    local labels = {}
    local yOffset = -40
    local yStep = -20

    local function createLabelPair(labelText, initialValue, y)
        local label = parent:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
        label:SetPoint("TOPLEFT", 5, y)
        label:SetText(labelText)

        local value = parent:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
        value:SetPoint("TOPRIGHT", -8, y)
        value:SetJustifyH("RIGHT")
        if initialValue then value:SetText(initialValue) end

        return label, value
    end

    labels.TimeLabel, labels.Time = createLabelPair(_G.MONEYLOOTER_L_TIME_LABEL, tostring(date("!%X", 0)), yOffset)
    yOffset = yOffset + yStep
    labels.RawGoldLabel, labels.RawGold = createLabelPair(_G.MONEYLOOTER_L_GOLD_LABEL, nil, yOffset)
    yOffset = yOffset + yStep
    labels.ItemsGoldLabel, labels.ItemsGold = createLabelPair(_G.MONEYLOOTER_L_ITEMS_LABEL, nil, yOffset)
    yOffset = yOffset + yStep
    labels.GPHLabel, labels.GPH = createLabelPair(_G.MONEYLOOTER_L_GPH_LABEL, nil, yOffset)
    yOffset = yOffset + yStep
    labels.PriciestLabel, labels.Priciest = createLabelPair(_G.MONEYLOOTER_L_PRICIEST_LABEL, nil, yOffset)

    return labels
end

---@param parent Frame
---@return table|Frame
local function CreateLootScrollBox(parent)
    local scrollBox = CreateFrame("Frame", nil, parent, "ML_WowScrollBoxList")
    scrollBox:SetResizable(true)

    scrollBox.ScrollBar = CreateFrame("EventFrame", nil, scrollBox, "MinimalScrollBar")
    scrollBox.DataProvider = CreateDataProvider()
    scrollBox.ScrollView = CreateScrollBoxListLinearView()
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

---@param parent Frame
---@return table|Button
local function CreateResizeGrip(parent)
    local grip = CreateFrame("Button", nil, parent)
    grip:SetPoint("BOTTOMRIGHT", 0, 0)
    grip:SetSize(16, 16)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")

    grip:SetScript("OnMouseDown", function(self)
        self:GetParent():StartSizing("BOTTOMRIGHT")
    end)
    grip:SetScript("OnMouseUp", function(self)
        self:GetParent():StopMovingOrSizing()
    end)
    return grip
end

---@return table|Frame
function UI:CreateMainFrame()
    local mainFrame = CreateFrame("Frame", "MONEYLOOTER_MAIN_FRAME", UIParent, "ML_MainFrame")
    mainFrame:SetPoint("CENTER")
    mainFrame:EnableMouse(true)
    mainFrame:SetMovable(true)
    mainFrame:RegisterForDrag("LeftButton")

    mainFrame:SetResizable(true)

    mainFrame.TitleBar = CreateTitleBar(mainFrame)
    mainFrame.CloseButton = CreateCloseButton(mainFrame)
    mainFrame.MinimizeCheck = CreateMinimizeCheckButton(mainFrame)
    mainFrame.StartButton = CreateStartButton(mainFrame)
    mainFrame.ResetButton = CreateResetButton(mainFrame)

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

    local initialWidth, initialHeight = mainFrame:GetSize()
    mainFrame:UpdateLayout(initialWidth, initialHeight)

    return mainFrame
end

UI.MLMainFrame = UI:CreateMainFrame()
