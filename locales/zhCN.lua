---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.zhCN = function()
  local L = {}
  L["START"] = "开始"
  L["CONTINUE"] = "继续"
  L["PAUSE"] = "暂停"
  L["RESET"] = "重置"
  L["TIME_LABEL"] = "时间:"
  L["GOLD_LABEL"] = "金币:"
  L["ITEMS_LABEL"] = "物品:"
  L["GPH_LABEL"] = "每小时金币:"
  L["PRICIEST_LABEL"] = "最贵:"
  L["USAGE"] = [[====== |cFFd8de35MoneyLooter 使用信息|r ======
  |cFF36e8e6/ml|r: 切换显示/隐藏
  |cFF36e8e6/ml|r |cFFf1f488help|r: 显示帮助
  |cFF36e8e6/ml|r |cFFf1f488show|r: 显示 MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488hide|r: 隐藏 MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488info|r: 查看插件信息。
  |cFF36e8e6/ml|r |cFFf1f488custom '自定义 TSM 字符串'|r: 设置用于价格计算的自定义 TSM 字符串。若为空，则返回当前使用的字符串。
    示例：/ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice '值'|r: 为某个品质设置最低价格阈值。
            mpricex: 所有可用品质。
            mprice1: 品质 1 - 普通 - 白色
            mprice2: 品质 2 - 稀少 - 绿色
            mprice3: 品质 3 - 稀有 - 蓝色
            mprice4: 品质 4 - 史诗 - 紫色
      剩余品质将使用商人价格（若存在）。
    示例：/ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      mprice 的价格格式为数字后跟 g(金)、s(银) 或 c 铜)。若仅指定数字，则默认使用金。
  |cFF36e8e6插件版本:|r ]]
  L["WELCOME"] = "欢迎来到 |cFFd8de35Money Looter|r!请使用 |cFF36e8e6/ml|r |cFFf1f488help|r 查看插件选项。"
  L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: 再次显示 |cFFd8de35MoneyLooter|r"
  L["INFO"] = "|cFFd8de35Money Looter|r 是一款轻量且快速的战利品追踪插件，由 Will0w7 创建。"
  L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM 不可用。"
  L["TSM_CUSTOM_STRING_NOT_VALID"] = "|cFFd8de35Money Looter:|r 以下 TSM 字符串无效且未设置： "
  L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r 以下 TSM 字符串有效并已设置： "
  L["TSM_CUSTOM_STRING"] = "|cFFd8de35Money Looter:|r 使用以下 TSM 字符串： "
  L["NEW_DB_VERSION"] = "|cFFd8de35Money Looter:|r 检测到数据库新版本，正在更新…"
  L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r 数据库已成功更新!"
  L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r 以下最低价格无效： "
  L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r 以下最低价格有效并已设置："
  L["MPRICE_QUALITY_1"] = "普通"
  L["MPRICE_QUALITY_2"] = "稀少"
  L["MPRICE_QUALITY_3"] = "稀有"
  L["MPRICE_QUALITY_4"] = "史诗"
  L["MPRICE_QUALITY_99"] = "所有品质"
  L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r 未识别的货币，请检查输入。"
  L["MPRICE_COIN_G"] = "金币"
  L["MPRICE_COIN_S"] = "银币"
  L["MPRICE_COIN_C"] = "铜币"
  L["FORCE_VENDOR_PRICE_ENABLED"] = "|cFFd8de35Money Looter:|r 强制使用商人价格已开启。仅使用商人出售价格。"
  L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r 强制使用商人价格已关闭。"
  return L
end
