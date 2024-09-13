---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_UI
local UI = MoneyLooter.UI
---@class ML_Utils
local Utils = MoneyLooter.Utils
---@class ML_Data
local Data = MoneyLooter.Data
---@class ML_CBFunctions
local CBFunctions = MoneyLooter.CBFunctions
---@class ML_Core
local Core = MoneyLooter.Core
---@class ML_Options
local Options = MoneyLooter.Options

----------------------------------------------------------------------------------------
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local GetMoney, CreateFrame = GetMoney, CreateFrame
----------------------------------------------------------------------------------------
local date, tostring = date, tostring
local strlenutf8, print, tonumber, ipairs = strlenutf8, print, tonumber, ipairs
----------------------------------------------------------------------------------------

Options.MLOptionsFrame:SetScript(Constants.Events.OnDragStart, Options.MLOptionsFrame.StartMoving)
Options.MLOptionsFrame:SetScript(Constants.Events.OnDragStop, Options.MLOptionsFrame.StopMovingOrSizing)
Options.MLOptionsFrame:SetScript(Constants.Events.OnHide, Options.MLOptionsFrame.StopMovingOrSizing)

Options.MLOptionsFrame.CloseButton:SetScript(Constants.Events.OnClick, function ()
    Options.MLOptionsFrame:Hide()
end)