-- Author      : Will0w7
-- MoneyLooterLocalesMain --

-- Based on Auctionator implementation, thanks <3
local currentLocale = {}
if MONEYLOOTER_LOCALES[GetLocale()] then
    currentLocale = MONEYLOOTER_LOCALES[GetLocale()]()
else
    currentLocale = MONEYLOOTER_LOCALES["enUS"]()
end

for key, value in pairs(currentLocale) do
    _G["MONEYLOOTER_L_" .. key] = value
end
