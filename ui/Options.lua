---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_Utils
local Utils = MoneyLooter.Utils

---@class ML_Options
local Options = {}
MoneyLooter.Options = Options


Options.MLOptionsFrame = CreateFrame("Frame", nil, UIParent, "ML_MainFrame")
Options.MLOptionsFrame:SetPoint("CENTER")
Options.MLOptionsFrame:EnableMouse(true)
Options.MLOptionsFrame:SetMovable(true)
Options.MLOptionsFrame:RegisterForDrag("LeftButton")

Options.MLOptionsFrame:Hide()

Options.MLOptionsFrame.TitleBar = CreateFrame("Frame", nil, Options.MLOptionsFrame, "ML_TitleBar")
Options.MLOptionsFrame.TitleBar:SetPoint("TOPLEFT", Options.MLOptionsFrame, "TOPLEFT")
Options.MLOptionsFrame.TitleBar:SetPoint("TOPRIGHT", Options.MLOptionsFrame, "TOPRIGHT")
Options.MLOptionsFrame.TitleBar.Label:SetText(_G.MONEYLOOTER_L_OPTIONS_TITLE)

Options.MLOptionsFrame.CloseButton = CreateFrame("Button", nil, Options.MLOptionsFrame, "ML_CloseButton")