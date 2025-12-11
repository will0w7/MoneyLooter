---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.esMX = function()
    local L = {}
    L["START"] = "Comenzar"
    L["CONTINUE"] = "Continuar"
    L["PAUSE"] = "Pausar"
    L["RESET"] = "Reiniciar"
    L["TIME_LABEL"] = "Tiempo:"
    L["GOLD_LABEL"] = "Oro:"
    L["ITEMS_LABEL"] = "Objetos:"
    L["GPH_LABEL"] = "GPH:"
    L["PRICIEST_LABEL"] = "Más valioso:"
    L["USAGE"] = [[====== |cFFd8de35Información de uso de MoneyLooter|r ======
  |cFF36e8e6/ml|r: Alterna entre mostrar y ocultar
  |cFF36e8e6/ml|r |cFFf1f488help|r: Muestra la ayuda
  |cFF36e8e6/ml|r |cFFf1f488show|r: Muestra MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488hide|r: Oculta MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488info|r: Muestra información sobre el addon
  |cFF36e8e6/ml|r |cFFf1f488custom 'custom TSM string'|r: Establece una cadena TSM custom que será usada para calcular el precio. Si está vacía, se devuelve la cadena que está siendo usada.
    Ejemplos: /ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice 'value'|r: Sets the minimum price threshold for a given quality.
            mpricex: All available qualities.
            mprice1: Quality 1 - Común - Blanco
            mprice2: Quality 2 - Poco común - Verde
            mprice3: Quality 3 - Raro - Azul
            mprice4: Quality 4 - Épico - Morado
      El resto de calidades usarán el precio de vendedor, si lo tienen.
    Ejemplos: /ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      El formato de precio para mprice es un número seguido de g(old), s(ilver) o c(opper) (oro, plata y cobre respectivamente). Si solo indicas un número, se usará oro por defecto.
  |cFF36e8e6Versión del addon:|r ]]
    L["WELCOME"] =
    "Bienvenido a |cFFd8de35Money Looter|r! Usa |cFF36e8e6/ml|r |cFFf1f488help|r para ver las opciones del addon."
    L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: Vuelve a mostrar |cFFd8de35MoneyLooter|r"
    L["INFO"] = "|cFFd8de35MoneyLooter|r addon ligero y rápido para rastrear el botín creado por Will0w7."
    L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM no está disponible."
    L["TSM_CUSTOM_STRING_NOT_VALID"] =
    "|cFFd8de35Money Looter:|r La siguiente cadena de TSM no es válida y no fue configurada: "
    L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r La siguiente cadena de TSM es válida y fue configurada: "
    L["NEW_DB_VERSION"] =
    "|cFFd8de35Money Looter:|r Se ha detectado una nueva versión de la base de datos, actualizando..."
    L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r La base de datos se ha actualizado correctamente!"
    L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r El siguiente precio mínimo es inválido: "
    L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r El siguiente precio mínimo es válido y fue configurado:"
    L["MPRICE_QUALITY_1"] = "Común"
    L["MPRICE_QUALITY_2"] = "Poco común"
    L["MPRICE_QUALITY_3"] = "Raro"
    L["MPRICE_QUALITY_4"] = "Épico"
    L["MPRICE_QUALITY_99"] = "Todas las calidades"
    L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r Moneda no reconocida, comprueba la entrada."
    L["MPRICE_COIN_G"] = "Oro"
    L["MPRICE_COIN_S"] = "Plata"
    L["MPRICE_COIN_C"] = "Cobre"
    L["FORCE_VENDOR_PRICE_ENABLED"] =
    "|cFFd8de35Money Looter:|r Forzar precio de venta de mercader habilitado. Se usarán solo los precios de venta del mercader."
    L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r Forzar precio de venta de mercader deshabilitado."
    L["TIME_ERROR"] =
    "|cFFd8de35Money Looter:|r El formato es incorrecto, debe ser: 00h00m00s o cualquier combinación de tiempo (5m30s)"
    return L
end
