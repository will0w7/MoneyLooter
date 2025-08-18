---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.itIT = function()
  local L = {}
  L["START"] = "Avvia"
  L["CONTINUE"] = "Continua"
  L["PAUSE"] = "Pausa"
  L["RESET"] = "Ripristina"
  L["TIME_LABEL"] = "Tempo:"
  L["GOLD_LABEL"] = "Oro:"
  L["ITEMS_LABEL"] = "Oggetti:"
  L["GPH_LABEL"] = "GPH:"
  L["PRICIEST_LABEL"] = "Più costoso:"
  L["USAGE"] = [[====== |cFFd8de35Informazioni sull'utilizzo di MoneyLooter|r ======
  |cFF36e8e6/ml|r: Attiva/Disattiva visualizzazione
  |cFF36e8e6/ml|r |cFFf1f488help|r: Mostra l'aiuto
  |cFF36e8e6/ml|r |cFFf1f488show|r: Mostra MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488hide|r: Nascondi MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488info|r: Mostra informazioni sull'addon.
  |cFF36e8e6/ml|r |cFFf1f488custom 'stringa TSM personalizzata'|r: Imposta la stringa TSM da usare per il calcolo del prezzo. Se vuota, restituisce la stringa TSM attuale.
    Esempi: /ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice 'valore'|r: Imposta il valore minimo di prezzo per una qualità.
            mpricex: Tutte le qualita disponibili.
            mprice1: Qualità 1 - Normale - Bianco
            mprice2: Qualità 2 - Poco comune - Verde
            mprice3: Qualità 3 - Raro - Blu
            mprice4: Qualità 4 - Epico - Viola
      Le restanti qualita utilizzeranno il prezzo del venditore, se presente.
    Esempi: /ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      Il formato di prezzo per mprice è un numero seguito da g (oro), s (argento) o c (rame). Se si indica solo il numero, viene usato oro per impostazione predefinita.
  |cFF36e8e6Versione dell'addon:|r ]]
  L["WELCOME"] =
  "Benvenuto in |cFFd8de35Money Looter|r! Usa |cFF36e8e6/ml|r |cFFf1f488help|r per le opzioni dell'addon."
  L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: Mostra di nuovo |cFFd8de35MoneyLooter|r"
  L["INFO"] =
  "|cFFd8de35Money Looter|r è un addon leggero e veloce per il tracciamento del bottino, creato da Will0w7."
  L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM non disponibile."
  L["TSM_CUSTOM_STRING_NOT_VALID"] =
  "|cFFd8de35Money Looter:|r La stringa TSM indicata non è valida e non è stata impostata: "
  L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r La stringa TSM indicata è valida ed è stata impostata: "
  L["TSM_CUSTOM_STRING"] = "|cFFd8de35Money Looter:|r Uso della stringa TSM seguente: "
  L["NEW_DB_VERSION"] =
  "|cFFd8de35Money Looter:|r È stata rilevata una nuova versione del database, aggiornamento in corso…"
  L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r Il database è stato aggiornato con successo!"
  L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r Il valore minimo di prezzo indicato non è valido: "
  L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r Il nuovo valore minimo di prezzo è valido ed è stato impostato:"
  L["MPRICE_QUALITY_1"] = "Normale"
  L["MPRICE_QUALITY_2"] = "Poco comune"
  L["MPRICE_QUALITY_3"] = "Raro"
  L["MPRICE_QUALITY_4"] = "Epico"
  L["MPRICE_QUALITY_99"] = "Tutte le qualita"
  L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r Moneta non riconosciuta, controlla l'input."
  L["MPRICE_COIN_G"] = "Oro"
  L["MPRICE_COIN_S"] = "Argento"
  L["MPRICE_COIN_C"] = "Rame"
  L["FORCE_VENDOR_PRICE_ENABLED"] =
  "|cFFd8de35Money Looter:|r Prezzo venditore forzato attivato. Vengono usati solo i prezzi di vendita del venditore."
  L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r Prezzo venditore forzato disattivato."
  return L
end
