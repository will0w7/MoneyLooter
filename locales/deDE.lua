---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.deDE = function()
    local L = {}
    L["START"] = "Starten"
    L["CONTINUE"] = "Fortsetzen"
    L["PAUSE"] = "Pause"
    L["RESET"] = "Zurücksetzen"
    L["TIME_LABEL"] = "Zeit:"
    L["GOLD_LABEL"] = "Gold:"
    L["ITEMS_LABEL"] = "Items:"
    L["GPH_LABEL"] = "GPH:"
    L["PRICIEST_LABEL"] = "Teuerster:"
    L["USAGE"] = [[====== |cFFd8de35MoneyLooter Nutzungsinfo|r ======
  |cFF36e8e6/ml|r: Anzeigen/Ausblenden umschalten
  |cFF36e8e6/ml|r |cFFf1f488help|r: Hilfe anzeigen
  |cFF36e8e6/ml|r |cFFf1f488show|r: MoneyLooter anzeigen
  |cFF36e8e6/ml|r |cFFf1f488hide|r: MoneyLooter ausblenden
  |cFF36e8e6/ml|r |cFFf1f488info|r: Infos über das Addon zeigen.
  |cFF36e8e6/ml|r |cFFf1f488custom 'eigene TSM-Zeichenkette'|r: Legt die eigene TSM-Zeichenkette fest, die für die Preisberechnung verwendet wird. Falls leer, wird die aktuelle Zeichenkette angezeigt.
    Beispiele: /ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice 'wert'|r: Legt den Mindestpreis für eine Qualität fest.
            mpricex: Alle Qualitätsstufen.
            mprice1: Qualität 1 - Normal - Weiß
            mprice2: Qualität 2 - Ungewöhnlich - Grün
            mprice3: Qualität 3 - Selten - Blau
            mprice4: Qualität 4 - Episch - Lila
      Die restlichen Qualitäten nutzen den Händlerpreis, falls vorhanden.
    Beispiele: /ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      Das Preisformat für mprice ist eine Zahl gefolgt von g (Gold), s (Silber) oder c (Kupfer). Wird nur die Zahl angegeben, gilt Gold als Standard.
  |cFF36e8e6Addon Version:|r ]]
    L["WELCOME"] =
    "Willkommen bei |cFFd8de35Money Looter|r! Benutze |cFF36e8e6/ml|r |cFFf1f488help|r für Addon-Optionen."
    L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: Noch einmal anzeigen |cFFd8de35MoneyLooter|r"
    L["INFO"] =
    "|cFFd8de35Money Looter|r ist ein leichtgewichtiges und schnelles Loot-Tracker-Addon, erstellt von Will0w7."
    L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM ist nicht verfügbar."
    L["TSM_CUSTOM_STRING_NOT_VALID"] =
    "|cFFd8de35Money Looter:|r Die angegebene TSM-Zeichenkette ist ungültig und wurde nicht gesetzt: "
    L["TSM_CUSTOM_STRING_VALID"] =
    "|cFFd8de35Money Looter:|r Die angegebene TSM-Zeichenkette ist gültig und wurde gesetzt: "
    L["TSM_CUSTOM_STRING"] = "|cFFd8de35Money Looter:|r Verwende die folgende TSM-Zeichenkette: "
    L["NEW_DB_VERSION"] = "|cFFd8de35Money Looter:|r Es wurde eine neue Datenbankversion erkannt, aktualisiere…"
    L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r Die Datenbank wurde erfolgreich aktualisiert!"
    L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r Der angegebene Mindestpreis ist ungültig: "
    L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r Der neue Mindestpreis ist gültig und wurde gesetzt:"
    L["MPRICE_QUALITY_1"] = "Normal"
    L["MPRICE_QUALITY_2"] = "Ungewöhnlich"
    L["MPRICE_QUALITY_3"] = "Selten"
    L["MPRICE_QUALITY_4"] = "Episch"
    L["MPRICE_QUALITY_99"] = "Alle Qualitäten"
    L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r Unbekannte Währung, bitte prüfen."
    L["MPRICE_COIN_G"] = "Gold"
    L["MPRICE_COIN_S"] = "Silber"
    L["MPRICE_COIN_C"] = "Kupfer"
    L["FORCE_VENDOR_PRICE_ENABLED"] =
    "|cFFd8de35Money Looter:|r Händlerpreis zwingend aktiviert. Nur Händlerverkaufspreise werden benutzt."
    L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r Händlerpreis zwingend deaktiviert."
    L["TIME_ERROR"] =
    "|cFFd8de35Money Looter:|r Das Format ist falsch, es muss sein: 00h00m00s oder eine beliebige Zeitkombination (5m30s)"
    return L
end
