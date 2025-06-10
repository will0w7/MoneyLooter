---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.ruRU = function()
  local L = {}
  L["START"] = "Старт"
  L["CONTINUE"] = "Продолжить"
  L["PAUSE"] = "Пауза"
  L["RESET"] = "Сбросить"
  L["TIME_LABEL"] = "Время:"
  L["GOLD_LABEL"] = "Золото:"
  L["ITEMS_LABEL"] = "Предметы:"
  L["GPH_LABEL"] = "GPH:"
  L["PRICIEST_LABEL"] = "Самое дорогое:"
  L["USAGE"] = [[====== |cFFd8de35Информация об использовании MoneyLooter|r ======
  |cFF36e8e6/ml|r: Toggle Show/Hide
  |cFF36e8e6/ml|r |cFFf1f488help|r: Показать помощь
  |cFF36e8e6/ml|r |cFFf1f488show|r: Показать MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488hide|r: Скрыть MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488info|r: Показывает информацию об аддоне.
  |cFF36e8e6/ml|r |cFFf1f488custom 'пользовательская строка TSM'|r: Устанавливает пользовательскую строку TSM для использования в расчете цены. Если пусто, возвращает пользовательскую строку TSM, которая в данный момент используется.
    Примеры: /ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice 'значение'|r: Устанавливает минимальный порог цены для данного качества.
            mpricex: Все доступные качества.
            mprice1: Качество 1 - Обычное - Белый
            mprice2: Качество 2 - Необычное - Зеленый
            mprice3: Качество 3 - Редкое - Синий
            mprice4: Качество 4 - Эпическое - Фиолетовый
      Остальные качества будут использовать цену поставщика, если она у них есть.
    Примеры: /ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      Формат цены для mprice — это число, за которым следует g(золото), s(серебро) или c(медная). Если указать только число, по умолчанию будет использоваться золото.
  |cFF36e8e6Версия аддона:|r ]]
  L["WELCOME"] = "Добро пожаловать в |cFFd8de35Money Looter|r! Используйте |cFF36e8e6/ml|r |cFFf1f488help|r для настроек аддона."
  L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: Показать снова |cFFd8de35MoneyLooter|r"
  L["INFO"] = "|cFFd8de35MoneyLooter|r - лёгкий и быстрый аддон для отслеживания добычи, созданный Will0w7."
  L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM недоступен."
  L["TSM_CUSTOM_STRING_NOT_VALID"] =
  "|cFFd8de35Money Looter:|r Следующая пользовательская строка TSM недействительна и не была установлена: "
  L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r Следующая пользовательская строка TSM действительна и была установлена: "
  L["TSM_CUSTOM_STRING"] = "|cFFd8de35Money Looter:|r Использование следующей пользовательской строки TSM: "
  L["NEW_DB_VERSION"] = "|cFFd8de35Money Looter:|r Обнаружена новая версия базы данных, обновление..."
  L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r База данных успешно обновлена!"
  L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r Следующая минимальная цена недействительна: "
  L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r Следующая минимальная цена действительна и была установлена: "
  L["MPRICE_QUALITY_1"] = "Обычное"
  L["MPRICE_QUALITY_2"] = "Необычное"
  L["MPRICE_QUALITY_3"] = "Редкое"
  L["MPRICE_QUALITY_4"] = "Эпическое"
  L["MPRICE_QUALITY_99"] = "Все качества"
  L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r Нераспознанная монета, проверьте ввод."
  L["MPRICE_COIN_G"] = "Золото"
  L["MPRICE_COIN_S"] = "Серебро"
  L["MPRICE_COIN_C"] = "Медная"
  L["FORCE_VENDOR_PRICE_ENABLED"] = "|cFFd8de35Money Looter:|r Принудительное включение цены продавца. Использование только цены продажи продавца."
  L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r Принудительное отключение цены продавца."
  return L
end
