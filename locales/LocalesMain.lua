---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

-- Based on Auctionator implementation, thanks <3
local currentLocale = {}
if Locales[GetLocale()] then
    currentLocale = Locales[GetLocale()]()
else
    currentLocale = Locales["enUS"]()
end

for key, value in pairs(currentLocale) do
    _G["MONEYLOOTER_L_" .. key] = value
end
