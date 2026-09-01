---@class MoneyLooter
local MoneyLooter = select(2, ...)
---@class ML_UI
local UI = MoneyLooter.UI
---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_Data
local Data = MoneyLooter.Data

------------------------------------------------------------------------------
local CreateFrame = CreateFrame
local MoneyInputFrame_GetCopper = MoneyInputFrame_GetCopper
local MoneyInputFrame_SetCopper = MoneyInputFrame_SetCopper
------------------------------------------------------------------------------

---@class ML_Config
local Config = {}
MoneyLooter.Config = Config

local MinPriceGetters = {
    Data.GetMinPrice1,
    Data.GetMinPrice2,
    Data.GetMinPrice3,
    Data.GetMinPrice4,
}
local MinPriceGettersLenght = #MinPriceGetters

local MinPriceSetters = {
    Data.SetMinPrice1,
    Data.SetMinPrice2,
    Data.SetMinPrice3,
    Data.SetMinPrice4,
}
local MinPriceSettersLenght = #MinPriceSetters

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
    local label = parent:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    label:SetText(text)
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

    local label = parent:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
    label:SetPoint("LEFT", check, "RIGHT", 8, 0)
    label:SetText(text)

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

---@return table|Frame|ML_ConfigFrame
local function CreateConfigFrame()
    local frame = CreateFrame("Frame", "MONEYLOOTER_CONFIG_FRAME", UIParent, "ML_ConfigFrame")
    frame:SetPoint("CENTER")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag(Constants.Inputs.LeftButton)
    frame:Hide()

    frame.TitleBar = CreateTitleBar(frame)
    frame.CloseButton = CreateCloseButton(frame)

    -- UI scale
    CreateLabel(frame, -40, _G.MONEYLOOTER_L_CONFIG_UI_SCALE)
    frame.ScaleMinusButton = CreateFrame("Button", nil, frame, "ML_Button")
    frame.ScaleMinusButton:SetSize(24, 20)
    frame.ScaleMinusButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 110, -40)
    frame.ScaleMinusButton:SetText("-")

    frame.ScaleValue = frame:CreateFontString(nil, "OVERLAY", Constants.Strings.FONT)
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

    -- TSM custom string
    CreateLabel(frame, -128, _G.MONEYLOOTER_L_CONFIG_TSM_STRING)
    frame.TSMEditBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    frame.TSMEditBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -150)
    frame.TSMEditBox:SetSize(250, 20)
    frame.TSMEditBox:SetAutoFocus(false)

    frame.TSMValidateButton = CreateTextButton(frame, -178, 14, _G.MONEYLOOTER_L_CONFIG_VALIDATE)
    frame.TSMResetButton = CreateTextButton(frame, -178, 130, _G.MONEYLOOTER_L_CONFIG_RESET)
    frame.TSMStatus = CreateLabel(frame, -206, "")

    -- Minimum prices
    CreateLabel(frame, -244, _G.MONEYLOOTER_L_CONFIG_MIN_PRICES)

    frame.MinPriceFrames = {}
    for i = 1, 4 do
        local yOffset = -266 - (i - 1) * 28
        CreateLabel(frame, yOffset, _G["MONEYLOOTER_L_MPRICE_QUALITY_" .. i])
        local moneyInput = CreateFrame("Frame", "MONEYLOOTER_CONFIG_MINPRICE" .. i, frame,
            "MoneyInputFrameTemplate")
        moneyInput:SetPoint("TOPLEFT", frame, "TOPLEFT", 160, yOffset)
        frame.MinPriceFrames[i] = moneyInput
    end

    -- Save button
    frame.SaveStatus = CreateLabel(frame, -405, "")
    frame.SaveButton = CreateFrame("Button", nil, frame, "ML_Button")
    frame.SaveButton:SetSize(352, 22)
    frame.SaveButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 14)
    frame.SaveButton:SetText(_G.MONEYLOOTER_L_CONFIG_SAVE)

    local function RefreshTSMFields()
        if TSM_API == nil then
            frame.TSMEditBox:SetEnabled(false)
            frame.TSMEditBox:SetTextColor(0.5, 0.5, 0.5)
            frame.TSMValidateButton:Disable()
            frame.TSMValidateButton.Label:SetTextColor(0.5, 0.5, 0.5)
            frame.TSMResetButton:Disable()
            frame.TSMResetButton.Label:SetTextColor(0.5, 0.5, 0.5)
            frame.TSMStatus:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_NOT_AVAILABLE)
            frame.TSMStatus:SetTextColor(1, 0.3, 0.3)
        else
            frame.TSMEditBox:SetEnabled(true)
            frame.TSMEditBox:SetTextColor(1, 1, 1)
            frame.TSMValidateButton:Enable()
            frame.TSMValidateButton.Label:SetTextColor(1, 1, 1)
            frame.TSMResetButton:Enable()
            frame.TSMResetButton.Label:SetTextColor(1, 1, 1)
            frame.TSMStatus:SetText("")
        end
        frame.TSMEditBox:SetText(Data.GetCurrentTSMString())
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

    local function Populate()
        frame.ForceVendorCheck:SetChecked(Data.GetForceVendorPrice())
        frame.UseDisenchantCheck:SetChecked(Data.GetUseDisenchantValue())
        for i = 1, MinPriceGettersLenght do
            MoneyInputFrame_SetCopper(frame.MinPriceFrames[i], MinPriceGetters[i]())
        end
        RefreshTSMFields()
        currentScale = Data.GetUIScale()
        RefreshScale()
    end

    ---@return string|nil
    local function ValidateTSM()
        local text = frame.TSMEditBox:GetText() or ""
        text = text:gsub("^%s+", ""):gsub("%s+$", "")

        if TSM_API == nil then
            frame.TSMStatus:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_NOT_AVAILABLE)
            frame.TSMStatus:SetTextColor(1, 0.3, 0.3)
            return nil
        end
        if text == "" then
            frame.TSMStatus:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_EMPTY)
            frame.TSMStatus:SetTextColor(1, 0.7, 0.3)
            return nil
        end
        if TSM_API.IsCustomPriceValid(text) then
            frame.TSMStatus:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_VALID)
            frame.TSMStatus:SetTextColor(0.3, 1, 0.3)
            return text
        end

        frame.TSMStatus:SetText(_G.MONEYLOOTER_L_CONFIG_TSM_INVALID)
        frame.TSMStatus:SetTextColor(1, 0.3, 0.3)
        return nil
    end

    local function Save()
        if TSM_API ~= nil then
            local tsmString = ValidateTSM()
            if tsmString == nil then
                frame.TSMStatus:SetText(_G.MONEYLOOTER_L_CONFIG_SAVE_ERROR_TSM)
                frame.TSMStatus:SetTextColor(1, 0.3, 0.3)
                return
            end
            Data.SetTSMString(tsmString)
        end

        Data.SetForceVendorPrice(frame.ForceVendorCheck:GetChecked())
        Data.SetUseDisenchantValue(frame.UseDisenchantCheck:GetChecked())
        for i = 1, MinPriceSettersLenght do
            MinPriceSetters[i](MoneyInputFrame_GetCopper(frame.MinPriceFrames[i]))
        end
        Data.SetUIScale(currentScale)
        Config.ApplyScale()

        frame.SaveStatus:SetText(_G.MONEYLOOTER_L_CONFIG_SAVED)
        frame.SaveStatus:SetTextColor(0.3, 1, 0.3)
    end

    frame:SetScript(Constants.Events.OnShow, Populate)
    frame.TSMValidateButton:SetScript(Constants.Events.OnClick, ValidateTSM)
    frame.TSMResetButton:SetScript(Constants.Events.OnClick, function()
        frame.TSMEditBox:SetText(Constants.Strings.TSM_STRING)
        frame.TSMStatus:SetText("")
    end)
    frame.SaveButton:SetScript(Constants.Events.OnClick, Save)
    frame.ScaleMinusButton:SetScript(Constants.Events.OnClick, function()
        ChangeScale(-Constants.UIScale.Step)
    end)
    frame.ScalePlusButton:SetScript(Constants.Events.OnClick, function()
        ChangeScale(Constants.UIScale.Step)
    end)

    frame:SetScript(Constants.Events.OnDragStart, frame.StartMoving)
    frame:SetScript(Constants.Events.OnDragStop, frame.StopMovingOrSizing)
    frame:SetScript(Constants.Events.OnHide, frame.StopMovingOrSizing)

    frame.CloseButton:SetScript(Constants.Events.OnClick, function()
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
end
