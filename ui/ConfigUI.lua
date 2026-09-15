---@class MoneyLooter
local MoneyLooter = select(2, ...)
---@class ML_UI
local UI = MoneyLooter.UI
---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_Data
local Data = MoneyLooter.Data
---@class ML_Utils
local Utils = MoneyLooter.Utils

------------------------------------------------------------------------------
local CreateFrame = CreateFrame
local MoneyInputFrame_GetCopper = MoneyInputFrame_GetCopper
local MoneyInputFrame_SetCopper = MoneyInputFrame_SetCopper
local strupper = string.upper
------------------------------------------------------------------------------
local SECTION_TITLE_COLOR = { 1, 0.82, 0 }
------------------------------------------------------------------------------

---@class ML_Config
local Config = {}
MoneyLooter.Config = Config

---@param parent ML_ConfigFrame
---@return table|Frame
local function CreateTitleBar(parent)
    local titleBar = CreateFrame("Frame", nil, parent, "ML_TitleBar")
    titleBar:SetPoint("TOPLEFT")
    titleBar:SetPoint("TOPRIGHT")
    titleBar.Label:SetText(_G.MONEYLOOTER_L_CONFIG_TITLE)
    return titleBar
end

---@param parent ML_ConfigFrame
---@return table|Button
local function CreateCloseButton(parent)
    local btn = CreateFrame("Button", nil, parent, "ML_CloseButton")
    btn:SetSize(20, 20)
    btn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -5, -5)
    return btn
end

---@param parent ML_ConfigFrame
---@param yOffset number
---@param text string
---@return FontString
local function CreateLabel(parent, yOffset, text)
    local label = parent:CreateFontString(nil, "OVERLAY", Constants.Strings.Font)
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    label:SetText(text)
    return label
end

---@param parent ML_ConfigFrame
---@param yOffset number
---@param text string
---@return FontString
local function CreateSectionTitle(parent, yOffset, text)
    local label = parent:CreateFontString(nil, "OVERLAY", Constants.Strings.Font)
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    label:SetText(strupper(text))
    label:SetTextColor(SECTION_TITLE_COLOR[1], SECTION_TITLE_COLOR[2], SECTION_TITLE_COLOR[3])
    return label
end

---@param parent ML_ConfigFrame
---@param yOffset number
---@param text string
---@return table|CheckButton
local function CreateCheckboxRow(parent, yOffset, text)
    local check = CreateFrame("CheckButton", nil, parent, "ML_CheckButton")
    check:ClearAllPoints()
    check:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)

    local label = parent:CreateFontString(nil, "OVERLAY", Constants.Strings.Font)
    label:SetPoint("LEFT", check, "RIGHT", 8, 0)
    label:SetText(text)
    check.Label = label

    return check
end

---@param parent ML_ConfigFrame
---@param yOffset number
---@param xOffset number
---@param text string
---@return table|Button
local function CreateTextButton(parent, yOffset, xOffset, text)
    local btn = CreateFrame("Button", nil, parent, "ML_Button")
    btn:SetSize(110, 20)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, yOffset)
    btn:SetText(text)
    return btn
end

---@param parent ML_ConfigFrame
---@param yOffset number
---@param titleText string
---@param defaultString string
---@return table
local function CreateTSMStringGroup(parent, yOffset, titleText, defaultString)
    local group = {}

    CreateSectionTitle(parent, yOffset, titleText)

    group.EditBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    group.EditBox:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, yOffset - 18)
    group.EditBox:SetSize(284, 20)
    group.EditBox:SetAutoFocus(false)

    group.ValidateButton = CreateTextButton(parent, yOffset - 46, 14, _G.MONEYLOOTER_L_CONFIG_VALIDATE)
    group.ResetButton = CreateTextButton(parent, yOffset - 46, 130, _G.MONEYLOOTER_L_CONFIG_RESET)
    group.Status = CreateLabel(parent, yOffset - 74, "")
    group.DefaultString = defaultString

    return group
end

---@return table|Frame|ML_ConfigFrame
local function CreateConfigFrame()
    local frame = CreateFrame("Frame", "MONEYLOOTER_CONFIG_FRAME", UIParent, "ML_ConfigFrame")
    frame:SetPoint("CENTER")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag(Constants.Inputs.LeftButton)
    frame:Hide()

    -- close on ESC
    table.insert(UISpecialFrames, "MONEYLOOTER_CONFIG_FRAME")

    frame.TitleBar = CreateTitleBar(frame)
    frame.CloseButton = CreateCloseButton(frame)

    -- UI scale
    CreateSectionTitle(frame, -44, _G.MONEYLOOTER_L_CONFIG_UI_SCALE)
    frame.ScaleMinusButton = CreateFrame("Button", nil, frame, "ML_Button")
    frame.ScaleMinusButton:SetSize(24, 20)
    frame.ScaleMinusButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 110, -40)
    frame.ScaleMinusButton:SetText("-")

    frame.ScaleValue = frame:CreateFontString(nil, "OVERLAY", Constants.Strings.Font)
    frame.ScaleValue:SetSize(44, 20)
    frame.ScaleValue:SetJustifyH("CENTER")
    frame.ScaleValue:SetPoint("LEFT", frame.ScaleMinusButton, "RIGHT", 6, 0)

    frame.ScalePlusButton = CreateFrame("Button", nil, frame, "ML_Button")
    frame.ScalePlusButton:SetSize(24, 20)
    frame.ScalePlusButton:SetPoint("LEFT", frame.ScaleValue, "RIGHT", 6, 0)
    frame.ScalePlusButton:SetText("+")

    -- Toggles
    frame.ForceVendorCheck = CreateCheckboxRow(frame, -70, _G.MONEYLOOTER_L_CONFIG_FORCE_VENDOR_PRICE)
    frame.UseDisenchantCheck = CreateCheckboxRow(frame, -96, _G.MONEYLOOTER_L_CONFIG_USE_DISENCHANT_VALUE)

    -- Price source
    CreateSectionTitle(frame, -122, _G.MONEYLOOTER_L_CONFIG_PRICE_SOURCE)

    local currentPriceSource = Constants.PriceSources.TradeSkillMaster
    frame.PriceSourceDropdown = CreateFrame("Frame", "MONEYLOOTER_CONFIG_PRICE_SOURCE_DROPDOWN", frame,
        "UIDropDownMenuTemplate")
    frame.PriceSourceDropdown:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, -140)
    UIDropDownMenu_SetWidth(frame.PriceSourceDropdown, 120)
    UIDropDownMenu_Initialize(frame.PriceSourceDropdown, function()
        for _, source in ipairs(Constants.PriceSourcesOrder) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = source
            info.value = source
            info.func = function()
                currentPriceSource = source
                UIDropDownMenu_SetText(frame.PriceSourceDropdown, source)
            end
            info.checked = (source == currentPriceSource)
            UIDropDownMenu_AddButton(info)
        end
    end)

    -- TSM custom strings
    local tsmGroup = CreateTSMStringGroup(frame, -176, _G.MONEYLOOTER_L_CONFIG_TSM_STRING,
        Constants.Strings.TSMString)
    local tsmDisenchantGroup = CreateTSMStringGroup(frame, -262, _G.MONEYLOOTER_L_CONFIG_TSM_DISENCHANT_STRING,
        Constants.Strings.TSMDisenchantString)

    -- Minimum prices
    CreateSectionTitle(frame, -348, _G.MONEYLOOTER_L_CONFIG_MIN_PRICES)

    frame.MinPriceFrames = {}
    frame.ForceDisenchantChecks = {}
    local minQuality = Constants.ItemQualities.Min
    for quality = minQuality, Constants.ItemQualities.Max do
        local yOffset = -376 - (quality - minQuality) * 50
        local qualityLabel = CreateLabel(frame, yOffset - 4, Utils.GetQualityName(quality))
        local r, g, b = Utils.GetQualityColor(quality)
        qualityLabel:SetTextColor(r, g, b)

        local moneyInput = CreateFrame("Frame", "MONEYLOOTER_CONFIG_MINPRICE" .. quality, frame,
            "MoneyInputFrameTemplate")
        moneyInput:SetPoint("TOPLEFT", frame, "TOPLEFT", 120, yOffset)
        frame.MinPriceFrames[quality] = moneyInput

        if quality >= 2 and quality <= 4 then
            frame.ForceDisenchantChecks[quality] = CreateCheckboxRow(frame, yOffset - 22,
                _G.MONEYLOOTER_L_CONFIG_FORCE_USE_DISENCHANT_VALUE)
            frame.ForceDisenchantChecks[quality].Label:SetTextColor(r, g, b)
        end
    end

    -- Save button
    frame.SaveButton = CreateFrame("Button", nil, frame, "ML_Button")
    frame.SaveButton:SetSize(300, 22)
    frame.SaveButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 14)
    frame.SaveButton:SetText(_G.MONEYLOOTER_L_CONFIG_SAVE)

    frame.SaveStatus = CreateLabel(frame, 0, "")
    frame.SaveStatus:ClearAllPoints()
    frame.SaveStatus:SetPoint("BOTTOM", frame.SaveButton, "TOP", 0, 6)

    local function RefreshTSMGroup(group, getter)
        if TSM_API == nil then
            group.EditBox:SetEnabled(false)
            group.EditBox:SetTextColor(0.5, 0.5, 0.5)
            group.ValidateButton:Disable()
            group.ValidateButton.Label:SetTextColor(0.5, 0.5, 0.5)
            group.ResetButton:Disable()
            group.ResetButton.Label:SetTextColor(0.5, 0.5, 0.5)
            group.Status:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_NOT_AVAILABLE)
            group.Status:SetTextColor(1, 0.3, 0.3)
        else
            group.EditBox:SetEnabled(true)
            group.EditBox:SetTextColor(1, 1, 1)
            group.ValidateButton:Enable()
            group.ValidateButton.Label:SetTextColor(1, 1, 1)
            group.ResetButton:Enable()
            group.ResetButton.Label:SetTextColor(1, 1, 1)
            group.Status:SetText("")
        end
        group.EditBox:SetText(getter())
    end

    local currentScale = 1

    local function RefreshScale()
        frame.ScaleValue:SetText(string.format("%.1f", currentScale))
    end

    local function ChangeScale(delta)
        currentScale = currentScale + delta
        currentScale = math.floor(currentScale * 10 + 0.5) / 10
        if currentScale < Constants.UIScale.Min then
            currentScale = Constants.UIScale.Min
        elseif currentScale > Constants.UIScale.Max then
            currentScale = Constants.UIScale.Max
        end
        RefreshScale()
    end

    local realUseDisenchant = false

    local function HasAnyForceDisenchant()
        for i = 2, 4 do
            if frame.ForceDisenchantChecks[i]:GetChecked() then
                return true
            end
        end
        return false
    end

    local function RefreshDisenchant()
        if HasAnyForceDisenchant() then
            frame.UseDisenchantCheck:SetChecked(true)
            frame.UseDisenchantCheck:Disable()
            frame.UseDisenchantCheck.Label:SetTextColor(0.5, 0.5, 0.5)
        else
            frame.UseDisenchantCheck:Enable()
            frame.UseDisenchantCheck.Label:SetTextColor(1, 1, 1)
            frame.UseDisenchantCheck:SetChecked(realUseDisenchant)
        end
    end

    local function Populate()
        frame.ForceVendorCheck:SetChecked(Data.GetForceVendorPrice())
        realUseDisenchant = Data.GetUseDisenchantValue()
        currentPriceSource = Data.GetPriceSource()
        UIDropDownMenu_SetText(frame.PriceSourceDropdown, currentPriceSource)
        for i = 2, 4 do
            frame.ForceDisenchantChecks[i]:SetChecked(Data.GetForceUseDisenchantValueIndex(i))
        end
        for quality = Constants.ItemQualities.Min, Constants.ItemQualities.Max do
            MoneyInputFrame_SetCopper(frame.MinPriceFrames[quality], Data.GetMinPrice(quality))
        end
        RefreshTSMGroup(tsmGroup, Data.GetCurrentTSMString)
        RefreshTSMGroup(tsmDisenchantGroup, Data.GetCurrentTSMDisenchantString)
        currentScale = Data.GetUIScale()
        RefreshScale()
        RefreshDisenchant()
    end

    ---@param group table
    ---@return string|nil
    local function ValidateTSMGroup(group)
        local text = group.EditBox:GetText() or ""
        text = text:gsub("^%s+", ""):gsub("%s+$", "")

        if TSM_API == nil then
            group.Status:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_NOT_AVAILABLE)
            group.Status:SetTextColor(1, 0.3, 0.3)
            return nil
        end
        if text == "" then
            group.Status:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_EMPTY)
            group.Status:SetTextColor(1, 0.7, 0.3)
            return nil
        end
        if TSM_API.IsCustomPriceValid(text) then
            group.Status:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_VALID)
            group.Status:SetTextColor(0.3, 1, 0.3)
            return text
        end

        group.Status:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_INVALID)
        group.Status:SetTextColor(1, 0.3, 0.3)
        return nil
    end

    local function Save()
        if TSM_API ~= nil then
            local tsmString = ValidateTSMGroup(tsmGroup)
            if tsmString == nil then
                tsmGroup.Status:SetText(_G.MONEYLOOTER_L_CONFIG_SAVE_ERROR_TSM)
                tsmGroup.Status:SetTextColor(1, 0.3, 0.3)
                return
            end
            Data.SetTSMString(tsmString)

            local tsmDisenchantString = ValidateTSMGroup(tsmDisenchantGroup)
            if tsmDisenchantString == nil then
                tsmDisenchantGroup.Status:SetText(_G.MONEYLOOTER_L_CONFIG_SAVE_ERROR_TSM)
                tsmDisenchantGroup.Status:SetTextColor(1, 0.3, 0.3)
                return
            end
            Data.SetTSMDisenchantString(tsmDisenchantString)
        end

        Data.SetForceVendorPrice(frame.ForceVendorCheck:GetChecked())
        Data.SetUseDisenchantValue(frame.UseDisenchantCheck:GetChecked())
        Data.SetPriceSource(currentPriceSource)
        for i = 2, 4 do
            Data.SetForceUseDisenchantValueIndex(frame.ForceDisenchantChecks[i]:GetChecked(), i)
        end
        for quality = Constants.ItemQualities.Min, Constants.ItemQualities.Max do
            Data.SetMinPrice(quality, MoneyInputFrame_GetCopper(frame.MinPriceFrames[quality]))
        end
        Data.SetUIScale(currentScale)
        Config.ApplyScale()
        MoneyLooter.Core.ClearPriceCache()

        frame.SaveStatus:SetText(_G.MONEYLOOTER_L_CONFIG_SAVED)
        frame.SaveStatus:SetTextColor(0.3, 1, 0.3)
    end

    local function WireTSMGroup(group)
        group.ValidateButton:SetScript(Constants.Events.OnClick, function()
            ValidateTSMGroup(group)
        end)
        group.ResetButton:SetScript(Constants.Events.OnClick, function()
            group.EditBox:SetText(group.DefaultString)
            group.Status:SetText("")
        end)
    end

    frame:SetScript(Constants.Events.OnShow, Populate)
    WireTSMGroup(tsmGroup)
    WireTSMGroup(tsmDisenchantGroup)
    frame.SaveButton:SetScript(Constants.Events.OnClick, Save)
    frame.ScaleMinusButton:SetScript(Constants.Events.OnClick, function()
        ChangeScale(-Constants.UIScale.Step)
    end)
    frame.ScalePlusButton:SetScript(Constants.Events.OnClick, function()
        ChangeScale(Constants.UIScale.Step)
    end)
    frame.UseDisenchantCheck:SetScript(Constants.Events.OnClick, function()
        realUseDisenchant = frame.UseDisenchantCheck:GetChecked()
    end)
    for i = 2, 4 do
        frame.ForceDisenchantChecks[i]:SetScript(Constants.Events.OnClick, RefreshDisenchant)
    end

    frame:SetScript(Constants.Events.OnDragStart, frame.StartMoving)
    frame:SetScript(Constants.Events.OnDragStop, frame.StopMovingOrSizing)
    frame:SetScript(Constants.Events.OnHide, frame.StopMovingOrSizing)

    frame.CloseButton:SetScript(Constants.Events.OnClick, function()
        frame.SaveStatus:SetText("")
        frame.SaveStatus:SetTextColor(1, 1, 1)
        frame:Hide()
    end)

    return frame
end

---@class ML_ConfigFrame : Frame
UI.MLConfigFrame = CreateConfigFrame()

function Config.ApplyScale()
    local scale = Data.GetUIScale()
    UI.MLMainFrame:SetScale(scale)
    UI.MLConfigFrame:SetScale(scale)
end

function Config.Show()
    UI.MLConfigFrame:Show()
end

function Config.Hide()
    UI.MLConfigFrame:Hide()
end

function Config.Toggle()
    if UI.MLConfigFrame:IsShown() then
        Config.Hide()
    else
        Config.Show()
    end
    UI.MLConfigFrame.SaveStatus:SetText("")
    UI.MLConfigFrame.SaveStatus:SetTextColor(1, 1, 1)
end
