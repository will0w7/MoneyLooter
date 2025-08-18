---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.ptBR = function()
  local L = {}
  L["START"] = "Iniciar"
  L["CONTINUE"] = "Continuar"
  L["PAUSE"] = "Pausar"
  L["RESET"] = "Reiniciar"
  L["TIME_LABEL"] = "Tempo:"
  L["GOLD_LABEL"] = "Ouro:"
  L["ITEMS_LABEL"] = "Itens:"
  L["GPH_LABEL"] = "GPH:"
  L["PRICIEST_LABEL"] = "Mais caro:"
  L["USAGE"] = [[====== |cFFd8de35Informações de uso do MoneyLooter|r ======
  |cFF36e8e6/ml|r: Ativar/Desativar exibição
  |cFF36e8e6/ml|r |cFFf1f488help|r: Mostrar ajuda
  |cFF36e8e6/ml|r |cFFf1f488show|r: Exibir MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488hide|r: Ocultar MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488info|r: Mostrar informações sobre o addon.
  |cFF36e8e6/ml|r |cFFf1f488custom 'stringa TSM personalizada'|r: Define a string TSM usada para calcular preços. Se vazia, retorna a string atual.
    Exemplos: /ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice 'valor'|r: Define o preço mínimo de qualidade.
            mpricex: Todas as qualidades disponíveis.
            mprice1: Qualidade 1 - Normal - Branco
            mprice2: Qualidade 2 - Pouco comum - Verde
            mprice3: Qualidade 3 - Raro - Azul
            mprice4: Qualidade 4 - Épico - Roxo
      As demais qualidades usarão o preço do vendedor, se houver.
    Exemplos: /ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      O formato de preço para mprice é um número seguido por g (ouro), s (prata) ou c (cobre). Se apenas o número for informado, será usado ouro por padrão.
  |cFF36e8e6Versão do addon:|r ]]
  L["WELCOME"] = "Bem-vindo ao |cFFd8de35Money Looter|r! Use |cFF36e8e6/ml|r |cFFf1f488help|r para opções de addon."
  L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: Mostrar novamente |cFFd8de35MoneyLooter|r"
  L["INFO"] = "|cFFd8de35Money Looter|r é um addon leve e rápido para rastrear loot, criado por Will0w7."
  L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM não está disponível."
  L["TSM_CUSTOM_STRING_NOT_VALID"] =
  "|cFFd8de35Money Looter:|r A string de TSM indicada é inválida e não foi configurada: "
  L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r A string de TSM indicada é válida e foi configurada: "
  L["TSM_CUSTOM_STRING"] = "|cFFd8de35Money Looter:|r Usando a seguinte string de TSM: "
  L["NEW_DB_VERSION"] = "|cFFd8de35Money Looter:|r Foi detectada uma nova versão do banco de dados, atualizando..."
  L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r O banco de dados foi atualizado com sucesso!"
  L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r O próximo preço mínimo é inválido: "
  L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r O próximo preço mínimo é válido e foi configurado:"
  L["MPRICE_QUALITY_1"] = "Normal"
  L["MPRICE_QUALITY_2"] = "Pouco comum"
  L["MPRICE_QUALITY_3"] = "Raro"
  L["MPRICE_QUALITY_4"] = "Épico"
  L["MPRICE_QUALITY_99"] = "Todas as qualidades"
  L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r Moeda não reconhecida, verifique a entrada."
  L["MPRICE_COIN_G"] = "Ouro"
  L["MPRICE_COIN_S"] = "Prata"
  L["MPRICE_COIN_C"] = "Cobre"
  L["FORCE_VENDOR_PRICE_ENABLED"] =
  "|cFFd8de35Money Looter:|r Preço do vendedor forçado ativado. Apenas preços de venda serão usados."
  L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r Preço do vendedor forçado desativado."
  return L
end
