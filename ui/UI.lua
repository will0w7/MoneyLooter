---@class MoneyLooter
local MoneyLooter = select(2, ...)

local Constants = MoneyLooter.Constants

---@class ML_UI
local UI = {}
MoneyLooter.UI = UI

----------------------------------------------------------------------------------------
local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
----------------------------------------------------------------------------------------

UI.MoneyLooterMainUIFrame = CreateFrame("Frame", Constants.Strings.ADDON_NAME, UIParent,
    BackdropTemplateMixin and "BackdropTemplate")
UI.MoneyLooterMainUIFrame:SetSize(200, 170)
UI.MoneyLooterMainUIFrame:SetPoint("CENTER")
UI.MoneyLooterMainUIFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tileSize = 7,
    edgeSize = 8,
    insets = { left = 1, right = 1, top = 1, bottom = 1, },
})
UI.MoneyLooterMainUIFrame:SetBackdropColor(0, 0, 0, .5)
UI.MoneyLooterMainUIFrame:SetBackdropBorderColor(0, 0, 0)

UI.MoneyLooterMainUIFrame:EnableMouse(true)
UI.MoneyLooterMainUIFrame:SetMovable(true)
UI.MoneyLooterMainUIFrame:RegisterForDrag("LeftButton")

UI.MoneyLooterCloseButton = CreateFrame("Button", "Close", UI.MoneyLooterMainUIFrame, "UIPanelCloseButton")
if MoneyLooter.isRetail then
    UI.MoneyLooterCloseButton:SetPoint("TOPLEFT", UI.MoneyLooterMainUIFrame, "TOPLEFT", 2, -2)
else
    UI.MoneyLooterCloseButton:SetPoint("TOPLEFT", UI.MoneyLooterMainUIFrame, "TOPLEFT", -2, 2)
end

UI.MoneyLooterMinimizeCheck = CreateFrame("CheckButton", "Minimize", UI.MoneyLooterMainUIFrame, "UICheckButtonTemplate")
UI.MoneyLooterMinimizeCheck:SetPoint("TOPRIGHT", UI.MoneyLooterMainUIFrame, "TOPRIGHT")
UI.MoneyLooterMinimizeCheck:SetSize(28, 28)
UI.MoneyLooterMinimizeCheck:SetChecked(true)

UI.MoneyLooterStartButton = CreateFrame("Button", "Start", UI.MoneyLooterMainUIFrame, "UIPanelButtonTemplate")
UI.MoneyLooterStartButton:SetPoint("BOTTOMLEFT", UI.MoneyLooterMainUIFrame, 5, 5)
UI.MoneyLooterStartButton:SetSize(100, 20)
UI.MoneyLooterStartButton:SetText(_G.MONEYLOOTER_L_START)

UI.MoneyLooterResetButton = CreateFrame("Button", "Reset", UI.MoneyLooterMainUIFrame, "UIPanelButtonTemplate")
UI.MoneyLooterResetButton:SetPoint("BOTTOMRIGHT", UI.MoneyLooterMainUIFrame, -5, 5)
UI.MoneyLooterResetButton:SetSize(50, 20)
UI.MoneyLooterResetButton:SetText(_G.MONEYLOOTER_L_RESET)

UI.MoneyLooterTitleFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
UI.MoneyLooterTitleFS:SetJustifyV("MIDDLE")
UI.MoneyLooterTitleFS:SetJustifyH("CENTER")
UI.MoneyLooterTitleFS:SetPoint("TOP", UI.MoneyLooterMainUIFrame, -3, -8)
UI.MoneyLooterTitleFS:SetFont(Constants.Strings.FONT, 17, "")
UI.MoneyLooterTitleFS:SetText(Constants.Strings.TITLE)

UI.MoneyLooterTimeLabelFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterTimeLabelFS:SetJustifyV("MIDDLE")
UI.MoneyLooterTimeLabelFS:SetJustifyH("CENTER")
UI.MoneyLooterTimeLabelFS:SetPoint("TOPLEFT", UI.MoneyLooterMainUIFrame, 5, -40)
UI.MoneyLooterTimeLabelFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterTimeLabelFS:SetText(_G.MONEYLOOTER_L_TIME_LABEL)

UI.MoneyLooterTimeFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterTimeFS:SetJustifyV("MIDDLE")
UI.MoneyLooterTimeFS:SetJustifyH("CENTER")
UI.MoneyLooterTimeFS:SetPoint("TOPRIGHT", UI.MoneyLooterMainUIFrame, -8, -40)
UI.MoneyLooterTimeFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterTimeFS:SetText(tostring(date("!%X", 0)))

UI.MoneyLooterRawGoldLabelFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterRawGoldLabelFS:SetJustifyV("MIDDLE")
UI.MoneyLooterRawGoldLabelFS:SetJustifyH("CENTER")
UI.MoneyLooterRawGoldLabelFS:SetPoint("TOPLEFT", UI.MoneyLooterMainUIFrame, 5, -60)
UI.MoneyLooterRawGoldLabelFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterRawGoldLabelFS:SetText(_G.MONEYLOOTER_L_GOLD_LABEL)

UI.MoneyLooterRawGoldFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterRawGoldFS:SetJustifyV("MIDDLE")
UI.MoneyLooterRawGoldFS:SetJustifyH("CENTER")
UI.MoneyLooterRawGoldFS:SetPoint("TOPRIGHT", UI.MoneyLooterMainUIFrame, -8, -60)
UI.MoneyLooterRawGoldFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterRawGoldFS:SetText(GetCoinTextureString(0))

UI.MoneyLooterItemsGoldLabelFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterItemsGoldLabelFS:SetJustifyV("MIDDLE")
UI.MoneyLooterItemsGoldLabelFS:SetJustifyH("CENTER")
UI.MoneyLooterItemsGoldLabelFS:SetPoint("TOPLEFT", UI.MoneyLooterMainUIFrame, 5, -80)
UI.MoneyLooterItemsGoldLabelFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterItemsGoldLabelFS:SetText(_G.MONEYLOOTER_L_ITEMS_LABEL)

UI.MoneyLooterItemsGoldFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterItemsGoldFS:SetJustifyV("MIDDLE")
UI.MoneyLooterItemsGoldFS:SetJustifyH("CENTER")
UI.MoneyLooterItemsGoldFS:SetPoint("TOPRIGHT", UI.MoneyLooterMainUIFrame, -8, -80)
UI.MoneyLooterItemsGoldFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(0))

UI.MoneyLooterGPHLabelFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterGPHLabelFS:SetJustifyV("MIDDLE")
UI.MoneyLooterGPHLabelFS:SetJustifyH("CENTER")
UI.MoneyLooterGPHLabelFS:SetPoint("TOPLEFT", UI.MoneyLooterMainUIFrame, 5, -100)
UI.MoneyLooterGPHLabelFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterGPHLabelFS:SetText(_G.MONEYLOOTER_L_GPH_LABEL)

UI.MoneyLooterGPHFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterGPHFS:SetJustifyV("MIDDLE")
UI.MoneyLooterGPHFS:SetJustifyH("CENTER")
UI.MoneyLooterGPHFS:SetPoint("TOPRIGHT", UI.MoneyLooterMainUIFrame, -8, -100)
UI.MoneyLooterGPHFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterGPHFS:SetText(GetCoinTextureString(0))

UI.MoneyLooterPriciestLabelFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterPriciestLabelFS:SetJustifyV("MIDDLE")
UI.MoneyLooterPriciestLabelFS:SetJustifyH("CENTER")
UI.MoneyLooterPriciestLabelFS:SetPoint("TOPLEFT", UI.MoneyLooterMainUIFrame, 5, -120)
UI.MoneyLooterPriciestLabelFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterPriciestLabelFS:SetText(_G.MONEYLOOTER_L_PRICIEST_LABEL)

UI.MoneyLooterPriciestFS = UI.MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
UI.MoneyLooterPriciestFS:SetJustifyV("MIDDLE")
UI.MoneyLooterPriciestFS:SetJustifyH("CENTER")
UI.MoneyLooterPriciestFS:SetPoint("TOPRIGHT", UI.MoneyLooterMainUIFrame, -8, -120)
UI.MoneyLooterPriciestFS:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterPriciestFS:SetText(GetCoinTextureString(0))

UI.MoneyLooterScrollLootFrame = CreateFrame("ScrollingMessageFrame", "LootedItems", UI.MoneyLooterMainUIFrame,
    BackdropTemplateMixin and "BackdropTemplate")
UI.MoneyLooterScrollLootFrame:CreateFontString(nil, nil, "GameFontNormal")
UI.MoneyLooterScrollLootFrame:SetSize(340, 170)
UI.MoneyLooterScrollLootFrame:SetPoint("RIGHT", 340, 0)
UI.MoneyLooterScrollLootFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tileSize = 7,
    edgeSize = 8,
    insets = { left = 1, right = 1, top = 1, bottom = 1, },
})
UI.MoneyLooterScrollLootFrame:SetBackdropColor(0, 0, 0, .5)
UI.MoneyLooterScrollLootFrame:SetBackdropBorderColor(0, 0, 0)
UI.MoneyLooterScrollLootFrame:SetMaxLines(14)
UI.MoneyLooterScrollLootFrame:SetFading(false)
UI.MoneyLooterScrollLootFrame:SetIndentedWordWrap(true)
UI.MoneyLooterScrollLootFrame:SetFont(Constants.Strings.FONT, 12, "")
UI.MoneyLooterScrollLootFrame:SetJustifyH("LEFT")
UI.MoneyLooterScrollLootFrame:EnableMouse(true)
UI.MoneyLooterScrollLootFrame:SetHyperlinksEnabled(true)
