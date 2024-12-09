---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.enUS = function()
  local L = {}
  L["START"] = "Start"
  L["CONTINUE"] = "Continue"
  L["PAUSE"] = "Pause"
  L["RESET"] = "Reset"
  L["TIME_LABEL"] = "Time:"
  L["GOLD_LABEL"] = "Gold:"
  L["ITEMS_LABEL"] = "Items:"
  L["GPH_LABEL"] = "GPH:"
  L["PRICIEST_LABEL"] = "Priciest:"
  L["USAGE"] = [[====== |cFFd8de35MoneyLooter Usage Info|r ======
  |cFF36e8e6/ml|r: Toggle Show/Hide
  |cFF36e8e6/ml|r |cFFf1f488help|r: Show the help
  |cFF36e8e6/ml|r |cFFf1f488show|r: Show MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488hide|r: Hide MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488info|r: Shows info about the addon.
  |cFF36e8e6/ml|r |cFFf1f488custom 'custom TSM string'|r: Sets a custom TSM string to be used in the price calculation. If empty, returns the custom TSM string it's currently using.
    Examples: /ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice 'value'|r: Sets the minimum price threshold for a given quality.
            mpricex: All available qualities.
            mprice1: Quality 1 - Common - White
            mprice2: Quality 2 - Uncommon - Green
            mprice3: Quality 3 - Rare - Blue
            mprice4: Quality 4 - Epic - Purple
      The rest of the qualities will use the vendor price, if they have it.
    Examples: /ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      The price format for mprice is a number followed by g(old), s(ilver) or c(opper). If you only specify the number, gold will be used by default.
  |cFF36e8e6Addon version:|r ]]
  L["WELCOME"] = "Welcome to |cFFd8de35Money Looter|r! Use |cFF36e8e6/ml|r |cFFf1f488help|r for addon options."
  L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: Show again |cFFd8de35MoneyLooter|r"
  L["INFO"] = "|cFFd8de35MoneyLooter|r lightweight and fast loot tracker addon created by Will0w7."
  L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM is not available."
  L["TSM_CUSTOM_STRING_NOT_VALID"] =
  "|cFFd8de35Money Looter:|r The next TSM custom string is not valid and was not set: "
  L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r The next TSM custom string is valid and was set: "
  L["TSM_CUSTOM_STRING"] = "|cFFd8de35Money Looter:|r Using the next TSM custom string: "
  L["NEW_DB_VERSION"] = "|cFFd8de35Money Looter:|r A new version of the database has been detected, updating..."
  L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r The database has been updated successfully!"
  L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r The next minimum price is invalid: "
  L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r The next minimum price is valid and was set:"
  L["MPRICE_QUALITY_1"] = "Common"
  L["MPRICE_QUALITY_2"] = "Uncommon"
  L["MPRICE_QUALITY_3"] = "Rare"
  L["MPRICE_QUALITY_4"] = "Epic"
  L["MPRICE_QUALITY_99"] = "All qualities"
  L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r Unrecognized coin, check input."
  L["MPRICE_COIN_G"] = "Gold"
  L["MPRICE_COIN_S"] = "Silver"
  L["MPRICE_COIN_C"] = "Copper"
  L["FORCE_VENDOR_PRICE_ENABLED"] = "|cFFd8de35Money Looter:|r Force vendor price enabled. Using only vendor sell price."
  L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r Force vendor price disabled."
  return L
end
