-- Author      : Will0w7
-- MoneyLooterUI --

----------------------------------------------------------------------------------
-- MoneyLooterEvents = MoneyLooterEvents
-- MoneyLooterStrings = MoneyLooterStrings
----------------------------------------------------------------------------------
-- GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
-- CreateFrame = CreateFrame
----------------------------------------------------------------------------------

MoneyLooterMainUIFrame = CreateFrame("Frame", ML_STRINGS.ML_ADDON_NAME, UIParent,
    BackdropTemplateMixin and "BackdropTemplate")
MoneyLooterMainUIFrame:SetSize(200, 170)
MoneyLooterMainUIFrame:SetPoint("CENTER")
MoneyLooterMainUIFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tileSize = 7,
    edgeSize = 8,
    insets = { left = 1, right = 1, top = 1, bottom = 1, },
})
MoneyLooterMainUIFrame:SetBackdropColor(0, 0, 0, .5)
MoneyLooterMainUIFrame:SetBackdropBorderColor(0, 0, 0)

MoneyLooterMainUIFrame:EnableMouse(true)
MoneyLooterMainUIFrame:SetMovable(true)
MoneyLooterMainUIFrame:RegisterForDrag("LeftButton")

MoneyLooterCloseButton = CreateFrame("Button", "Close", MoneyLooterMainUIFrame, "UIPanelCloseButton")
MoneyLooterCloseButton:SetPoint("TOPRIGHT", MoneyLooterMainUIFrame, "TOPRIGHT")

MoneyLooterStartButton = CreateFrame("Button", "Start", MoneyLooterMainUIFrame, "UIPanelButtonTemplate")
MoneyLooterStartButton:SetPoint("BOTTOMLEFT", MoneyLooterMainUIFrame, 5, 5)
MoneyLooterStartButton:SetSize(100, 20)
MoneyLooterStartButton:SetText(GetCurrentStartStopText())

MoneyLooterResetButton = CreateFrame("Button", "Reset", MoneyLooterMainUIFrame, "UIPanelButtonTemplate")
MoneyLooterResetButton:SetPoint("BOTTOMRIGHT", MoneyLooterMainUIFrame, -5, 5)
MoneyLooterResetButton:SetSize(50, 20)
MoneyLooterResetButton:SetText(_G.MONEYLOOTER_L_RESET)

MoneyLooterTitleFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
MoneyLooterTitleFS:SetJustifyV("MIDDLE")
MoneyLooterTitleFS:SetJustifyH("CENTER")
MoneyLooterTitleFS:SetPoint("TOP", MoneyLooterMainUIFrame, -3, -8)
MoneyLooterTitleFS:SetFont(ML_STRINGS.ML_FONT, 17, "")
MoneyLooterTitleFS:SetText(ML_STRINGS.TITLE)

local MoneyLooterTimeLabelFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterTimeLabelFS:SetJustifyV("MIDDLE")
MoneyLooterTimeLabelFS:SetJustifyH("CENTER")
MoneyLooterTimeLabelFS:SetPoint("TOPLEFT", MoneyLooterMainUIFrame, 5, -40)
MoneyLooterTimeLabelFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterTimeLabelFS:SetText(_G.MONEYLOOTER_L_TIME_LABEL)

MoneyLooterTimeFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterTimeFS:SetJustifyV("MIDDLE")
MoneyLooterTimeFS:SetJustifyH("CENTER")
MoneyLooterTimeFS:SetPoint("TOPRIGHT", MoneyLooterMainUIFrame, -8, -40)
MoneyLooterTimeFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterTimeFS:SetText(date("!%X", GetTimer()))

local MoneyLooterRawGoldLabelFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterRawGoldLabelFS:SetJustifyV("MIDDLE")
MoneyLooterRawGoldLabelFS:SetJustifyH("CENTER")
MoneyLooterRawGoldLabelFS:SetPoint("TOPLEFT", MoneyLooterMainUIFrame, 5, -60)
MoneyLooterRawGoldLabelFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterRawGoldLabelFS:SetText(_G.MONEYLOOTER_L_GOLD_LABEL)

MoneyLooterRawGoldFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterRawGoldFS:SetJustifyV("MIDDLE")
MoneyLooterRawGoldFS:SetJustifyH("CENTER")
MoneyLooterRawGoldFS:SetPoint("TOPRIGHT", MoneyLooterMainUIFrame, -8, -60)
MoneyLooterRawGoldFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterRawGoldFS:SetText(GetCoinTextureString(GetRawMoney()))

local MoneyLooterItemsGoldLabelFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterItemsGoldLabelFS:SetJustifyV("MIDDLE")
MoneyLooterItemsGoldLabelFS:SetJustifyH("CENTER")
MoneyLooterItemsGoldLabelFS:SetPoint("TOPLEFT", MoneyLooterMainUIFrame, 5, -80)
MoneyLooterItemsGoldLabelFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterItemsGoldLabelFS:SetText(_G.MONEYLOOTER_L_ITEMS_LABEL)

MoneyLooterItemsGoldFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterItemsGoldFS:SetJustifyV("MIDDLE")
MoneyLooterItemsGoldFS:SetJustifyH("CENTER")
MoneyLooterItemsGoldFS:SetPoint("TOPRIGHT", MoneyLooterMainUIFrame, -8, -80)
MoneyLooterItemsGoldFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterItemsGoldFS:SetText(GetCoinTextureString(GetItemsMoney()))

local MoneyLooterGPHLabelFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterGPHLabelFS:SetJustifyV("MIDDLE")
MoneyLooterGPHLabelFS:SetJustifyH("CENTER")
MoneyLooterGPHLabelFS:SetPoint("TOPLEFT", MoneyLooterMainUIFrame, 5, -100)
MoneyLooterGPHLabelFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterGPHLabelFS:SetText(_G.MONEYLOOTER_L_GPH_LABEL)

MoneyLooterGPHFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterGPHFS:SetJustifyV("MIDDLE")
MoneyLooterGPHFS:SetJustifyH("CENTER")
MoneyLooterGPHFS:SetPoint("TOPRIGHT", MoneyLooterMainUIFrame, -8, -100)
MoneyLooterGPHFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterGPHFS:SetText(GetCoinTextureString(CalcGPH()))

local MoneyLooterPriciestLabelFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterPriciestLabelFS:SetJustifyV("MIDDLE")
MoneyLooterPriciestLabelFS:SetJustifyH("CENTER")
MoneyLooterPriciestLabelFS:SetPoint("TOPLEFT", MoneyLooterMainUIFrame, 5, -120)
MoneyLooterPriciestLabelFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterPriciestLabelFS:SetText(_G.MONEYLOOTER_L_PRICIEST_LABEL)

MoneyLooterPriciestFS = MoneyLooterMainUIFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MoneyLooterPriciestFS:SetJustifyV("MIDDLE")
MoneyLooterPriciestFS:SetJustifyH("CENTER")
MoneyLooterPriciestFS:SetPoint("TOPRIGHT", MoneyLooterMainUIFrame, -8, -120)
MoneyLooterPriciestFS:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterPriciestFS:SetText(GetCoinTextureString(GetPriciest()))

MoneyLooterScrollLootFrame = CreateFrame("ScrollingMessageFrame", "LootedItems", MoneyLooterMainUIFrame,
    BackdropTemplateMixin and "BackdropTemplate")
MoneyLooterScrollLootFrame:CreateFontString(nil, nil, "GameFontNormal")
MoneyLooterScrollLootFrame:SetSize(340, 170)
MoneyLooterScrollLootFrame:SetPoint("RIGHT", 340, 0)
MoneyLooterScrollLootFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tileSize = 7,
    edgeSize = 8,
    insets = { left = 1, right = 1, top = 1, bottom = 1, },
})
MoneyLooterScrollLootFrame:SetBackdropColor(0, 0, 0, .5)
MoneyLooterScrollLootFrame:SetBackdropBorderColor(0, 0, 0)
MoneyLooterScrollLootFrame:SetMaxLines(14)
MoneyLooterScrollLootFrame:SetFading(false)
MoneyLooterScrollLootFrame:SetIndentedWordWrap(true)
MoneyLooterScrollLootFrame:SetFont(ML_STRINGS.ML_FONT, 12, "")
MoneyLooterScrollLootFrame:SetJustifyH("LEFT")
MoneyLooterScrollLootFrame:EnableMouse(true)
MoneyLooterScrollLootFrame:SetHyperlinksEnabled(true)
