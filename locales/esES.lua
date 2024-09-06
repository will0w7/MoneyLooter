-- Author      : Will0w7
-- esES --

MONEYLOOTER_LOCALES.esES = function()
  L = {}
  L["START"] = "Comenzar"
  L["CONTINUE"] = "Continuar"
  L["PAUSE"] = "Pausar"
  L["RESET"] = "Reset"
  L["TIME_LABEL"] = "Tiempo:"
  L["GOLD_LABEL"] = "Oro:"
  L["ITEMS_LABEL"] = "Objetos:"
  L["GPH_LABEL"] = "OPH:"
  L["PRICIEST_LABEL"] = "Más valor:"
  ---------------------------------------------------------------------------------------------------------
  L["USAGE"] = [[====== |cFFd8de35Información de uso de Money Looter|r ======
  |cFF36e8e6/ml|r: Alterna entre mostrar y ocultar
  |cFF36e8e6/ml|r |cFFf1f488help|r: Muestra la ayuda
  |cFF36e8e6/ml|r |cFFf1f488show|r: Muestra MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488hide|r: Oculta MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488info|r: Muestra información sobre el addon
  |cFF36e8e6/ml|r |cFFf1f488custom "Custom TSM String"|r: Sets a custom TSM string to be used in the price calc.
    Example: /ml custom dbmarket
  |cFF36e8e6Versión del addon:|r ]]
  L["WELCOME"] =
  "Bienvenido a |cFFd8de35Money Looter|r! Usa |cFF36e8e6/ml|r |cFFf1f488help|r para ver las opciones del addon."
  L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: Vuelve a mostrar |cFFd8de35MoneyLooter|r"
  L["INFO"] = "|cFFd8de35MoneyLooter|r addon ligero y rápido creado por Will0w7."
  ----------------------------------------------------------------------------------------------------------
  L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM is not available"
  L["TSM_CUSTOM_STRING_NOT_VALID"] =
  "|cFFd8de35Money Looter:|r The next TSM custom string is not valid and was not set: "
  L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r The next TSM custom string is valid and was set: "
  L["NEW_DB_VERSION"] = "|cFFd8de35Money Looter:|r A new version of the database has been detected, updating..."
  L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r The database has been updated successfully!"
  L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r The next minimum price is invalid: "
  L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r The next minimum price is valid and was set:"
  L["MPRICE_QUALITY_1"] = "Común"
  L["MPRICE_QUALITY_2"] = "Poco común"
  L["MPRICE_QUALITY_3"] = "Raro"
  L["MPRICE_QUALITY_4"] = "Épico"
  L["MPRICE_COIN_G"] = "Oro"
  L["MPRICE_COIN_S"] = "Plata"
  L["MPRICE_COIN_C"] = "Cobre"
  return L
end
