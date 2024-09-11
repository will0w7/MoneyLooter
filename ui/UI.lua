---@class MoneyLooter
local MoneyLooter = select(2, ...)

local Constants = MoneyLooter.Constants

---@class ML_UI
local UI = {}
MoneyLooter.UI = UI

local Utils = MoneyLooter.Utils

----------------------------------------------------------------------------------------
local CreateFrame = CreateFrame
local tostring, date = tostring, date
----------------------------------------------------------------------------------------
local function CreateTextureFromItemID(itemId)
    return ("|T" .. tostring(C_Item.GetItemIconByID(itemId)) .. ":0|t")
end

ML_ItemScrollMixin = {}

function ML_ItemScrollMixin:OnClick()
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    local elementData = self:GetElementData()
    SetItemRef(elementData.itemLink, elementData.itemLink)
    GameTooltip:Show()
end

function ML_ItemScrollMixin:Init()
    local elementData = self:GetElementData()
    self:SetLeftText(elementData.id, elementData.quantity, elementData.itemLink)
    self:SetRightText(elementData.value)
    self:TrimDataProvider(UI.MLMainFrame.ScrollBoxLoot.DataProvider)
end

function ML_ItemScrollMixin:SetAlternateOverlayShown(alternate)
    self.Alternate:SetShown(alternate);
end

function ML_ItemScrollMixin:SetLeftText(id, quantity, itemLink)
    self.LeftLabel:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(quantity ..
        "x " .. CreateTextureFromItemID(id) .. itemLink))
end

function ML_ItemScrollMixin:SetRightText(value)
    self.RightLabel:SetText(Utils.GetCoinTextString(value))
end

function ML_ItemScrollMixin:TrimDataProvider(dataProvider)
    local maxCapacity = MoneyLooter.BufferCapacity
    local dataProviderSize = dataProvider:GetSize()
    if dataProviderSize > maxCapacity then
        local extra = math.floor(maxCapacity * .5)
        local overflow = dataProviderSize - maxCapacity
        dataProvider:RemoveIndexRange(1, overflow + extra)
    end
end

-------------------------------------------------------------------------------------
ML_ButtonMixin = {}

function ML_ButtonMixin:SetText(val)
    self.Label:SetText(val)
end

-------------------------------------------------------------------------------------
UI.MLMainFrame = CreateFrame("Frame", "MONEYLOOTER_MAIN_FRAME", UIParent, "ML_MainFrame")
UI.MLMainFrame:SetPoint("CENTER")
UI.MLMainFrame:EnableMouse(true)
UI.MLMainFrame:SetMovable(true)
UI.MLMainFrame:RegisterForDrag("LeftButton")

UI.MLMainFrame.TitleBar = CreateFrame("Frame", nil, UI.MLMainFrame, "ML_TitleBar")
UI.MLMainFrame.TitleBar:SetPoint("TOPLEFT", UI.MLMainFrame, "TOPLEFT")
UI.MLMainFrame.TitleBar:SetPoint("TOPRIGHT", UI.MLMainFrame, "TOPRIGHT")
UI.MLMainFrame.TitleBar.Label:SetText(Constants.Strings.TITLE)

UI.MLMainFrame.CloseButton = CreateFrame("Button", nil, UI.MLMainFrame, "ML_CloseButton")

UI.MLMainFrame.MinimizeCheck = CreateFrame("CheckButton", nil, UI.MLMainFrame, "ML_CheckButton")
UI.MLMainFrame.MinimizeCheck:SetChecked(true)

UI.MLMainFrame.StartButton = CreateFrame("Button", nil, UI.MLMainFrame, "ML_Button")
UI.MLMainFrame.StartButton:SetPoint("BOTTOMLEFT", UI.MLMainFrame, 5, 5)
UI.MLMainFrame.StartButton:SetText(_G.MONEYLOOTER_L_START)

UI.MLMainFrame.ResetButton = CreateFrame("Button", nil, UI.MLMainFrame, "ML_Button")
UI.MLMainFrame.ResetButton:SetPoint("BOTTOMRIGHT", UI.MLMainFrame, -5, 5)
UI.MLMainFrame.ResetButton:SetSize(65, 20)
UI.MLMainFrame.ResetButton:SetText(_G.MONEYLOOTER_L_RESET)

UI.MLMainFrame.TimeLabelFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.TimeLabelFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.TimeLabelFS:SetJustifyH("CENTER")
UI.MLMainFrame.TimeLabelFS:SetPoint("TOPLEFT", UI.MLMainFrame, 5, -40)
UI.MLMainFrame.TimeLabelFS:SetText(_G.MONEYLOOTER_L_TIME_LABEL)

UI.MLMainFrame.TimeFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.TimeFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.TimeFS:SetJustifyH("CENTER")
UI.MLMainFrame.TimeFS:SetPoint("TOPRIGHT", UI.MLMainFrame, -8, -40)
UI.MLMainFrame.TimeFS:SetText(tostring(date("!%X", 0)))

UI.MLMainFrame.RawGoldLabelFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.RawGoldLabelFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.RawGoldLabelFS:SetJustifyH("CENTER")
UI.MLMainFrame.RawGoldLabelFS:SetPoint("TOPLEFT", UI.MLMainFrame, 5, -60)
UI.MLMainFrame.RawGoldLabelFS:SetText(_G.MONEYLOOTER_L_GOLD_LABEL)

UI.MLMainFrame.RawGoldFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.RawGoldFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.RawGoldFS:SetJustifyH("CENTER")
UI.MLMainFrame.RawGoldFS:SetPoint("TOPRIGHT", UI.MLMainFrame, -8, -60)

UI.MLMainFrame.ItemsGoldLabelFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.ItemsGoldLabelFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.ItemsGoldLabelFS:SetJustifyH("CENTER")
UI.MLMainFrame.ItemsGoldLabelFS:SetPoint("TOPLEFT", UI.MLMainFrame, 5, -80)
UI.MLMainFrame.ItemsGoldLabelFS:SetText(_G.MONEYLOOTER_L_ITEMS_LABEL)

UI.MLMainFrame.ItemsGoldFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.ItemsGoldFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.ItemsGoldFS:SetJustifyH("CENTER")
UI.MLMainFrame.ItemsGoldFS:SetPoint("TOPRIGHT", UI.MLMainFrame, -8, -80)

UI.MLMainFrame.GPHLabelFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.GPHLabelFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.GPHLabelFS:SetJustifyH("CENTER")
UI.MLMainFrame.GPHLabelFS:SetPoint("TOPLEFT", UI.MLMainFrame, 5, -100)
UI.MLMainFrame.GPHLabelFS:SetText(_G.MONEYLOOTER_L_GPH_LABEL)

UI.MLMainFrame.GPHFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.GPHFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.GPHFS:SetJustifyH("CENTER")
UI.MLMainFrame.GPHFS:SetPoint("TOPRIGHT", UI.MLMainFrame, -8, -100)

UI.MLMainFrame.PriciestLabelFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.PriciestLabelFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.PriciestLabelFS:SetJustifyH("CENTER")
UI.MLMainFrame.PriciestLabelFS:SetPoint("TOPLEFT", UI.MLMainFrame, 5, -120)
UI.MLMainFrame.PriciestLabelFS:SetText(_G.MONEYLOOTER_L_PRICIEST_LABEL)

UI.MLMainFrame.PriciestFS = UI.MLMainFrame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
UI.MLMainFrame.PriciestFS:SetJustifyV("MIDDLE")
UI.MLMainFrame.PriciestFS:SetJustifyH("CENTER")
UI.MLMainFrame.PriciestFS:SetPoint("TOPRIGHT", UI.MLMainFrame, -8, -120)

UI.MLMainFrame.ScrollBoxLoot = CreateFrame("Frame", nil, UI.MLMainFrame,
    "ML_WowScrollBoxList")

UI.MLMainFrame.ScrollBoxLoot:SetSize(340, 180)
UI.MLMainFrame.ScrollBoxLoot:SetPoint("RIGHT", 340, 0)
UI.MLMainFrame.ScrollBoxLoot.texture = UI.MLMainFrame.ScrollBoxLoot:CreateTexture(nil, "BACKGROUND")
UI.MLMainFrame.ScrollBoxLoot.texture:SetColorTexture(.1, .1, .1, 1)

UI.MLMainFrame.ScrollLootBar = CreateFrame("EventFrame", nil, UI.MLMainFrame.ScrollBoxLoot, "MinimalScrollBar")

UI.MLMainFrame.ScrollBoxLoot.DataProvider = CreateDataProvider()
UI.MLMainFrame.ScrollBoxLoot.ScrollView = CreateScrollBoxListLinearView()
UI.MLMainFrame.ScrollBoxLoot.ScrollView:SetDataProvider(UI.MLMainFrame.ScrollBoxLoot.DataProvider)

---@param frame Frame
---@param alternate boolean
local function ApplyAlternateState(frame, alternate)
    frame:SetAlternateOverlayShown(alternate)
end

ScrollUtil.InitScrollBoxListWithScrollBar(UI.MLMainFrame.ScrollBoxLoot, UI.MLMainFrame.ScrollLootBar,
    UI.MLMainFrame.ScrollBoxLoot.ScrollView)
ScrollUtil.RegisterAlternateRowBehavior(UI.MLMainFrame.ScrollBoxLoot, ApplyAlternateState)

---@param button Button
local function Initializer(button)
    button:Init()
end

UI.MLMainFrame.ScrollBoxLoot.ScrollView:SetElementInitializer("ML_ItemScroll", Initializer)
