---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.zhTW = function()
    local L = {}
    L["START"] = "開始"
    L["CONTINUE"] = "繼續"
    L["PAUSE"] = "暫停"
    L["RESET"] = "重置"
    L["TIME_LABEL"] = "時間:"
    L["GOLD_LABEL"] = "金幣:"
    L["ITEMS_LABEL"] = "物品:"
    L["GPH_LABEL"] = "每小時金幣:"
    L["PRICIEST_LABEL"] = "最貴:"
    L["USAGE"] = [[====== |cFFd8de35MoneyLooter 使用資訊|r ======
  |cFF36e8e6/ml|r: 切換顯示/隱藏
  |cFF36e8e6/ml|r |cFFf1f488help|r: 顯示幫助
  |cFF36e8e6/ml|r |cFFf1f488show|r: 顯示 MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488hide|r: 隱藏 MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488info|r: 查看插件資訊。
  |cFF36e8e6/ml|r |cFFf1f488custom '自訂 TSM 字串'|r: 設定用於價格計算的自訂 TSM 字串。若留空，將返回目前使用中的字串。
    範例：/ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice '值'|r: 為某品質設定最低價格門檻。
            mpricex: 所有可用品質。
            mprice1: 品質 1 - 普通 - 白色
            mprice2: 品質 2 - 稀少 - 綠色
            mprice3: 品質 3 - 稀有 - 藍色
            mprice4: 品質 4 - 史詩 - 紫色
      剩餘品質將使用商人價格（若存在）。
    範例：/ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      mprice 的價格格式為數字後跟 g(金)、s(銀) 或 c 銅)。若僅指定數字，預設使用金。
  |cFF36e8e6插件版本:|r ]]
    L["WELCOME"] = "歡迎來到 |cFFd8de35Money Looter|r!請使用 |cFF36e8e6/ml|r |cFFf1f488help|r 查看插件選項。"
    L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: 再次顯示 |cFFd8de35MoneyLooter|r"
    L["INFO"] = "|cFFd8de35Money Looter|r 是一款輕量且快速的戰利品追蹤插件，由 Will0w7 建立。"
    L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM 不可用。"
    L["TSM_CUSTOM_STRING_NOT_VALID"] = "|cFFd8de35Money Looter:|r 以下 TSM 字串無效且未設定： "
    L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r 以下 TSM 字串有效並已設定： "
    L["TSM_CUSTOM_STRING"] = "|cFFd8de35Money Looter:|r 使用以下 TSM 字串： "
    L["NEW_DB_VERSION"] = "|cFFd8de35Money Looter:|r 檢測到資料庫新版本，正在更新…"
    L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r 資料庫已成功更新！"
    L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r 以下最低價格無效： "
    L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r 以下最低價格有效並已設定："
    L["MPRICE_QUALITY_1"] = "普通"
    L["MPRICE_QUALITY_2"] = "稀少"
    L["MPRICE_QUALITY_3"] = "稀有"
    L["MPRICE_QUALITY_4"] = "史詩"
    L["MPRICE_QUALITY_99"] = "所有品質"
    L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r 未辨識的貨幣，請檢查輸入。"
    L["MPRICE_COIN_G"] = "金幣"
    L["MPRICE_COIN_S"] = "銀幣"
    L["MPRICE_COIN_C"] = "銅幣"
    L["FORCE_VENDOR_PRICE_ENABLED"] = "|cFFd8de35Money Looter:|r 強制使用商人價格已開啟。僅使用商人出售價格。"
    L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r 強制使用商人價格已關閉。"
    L["TIME_ERROR"] =
    "|cFFd8de35Money Looter:|r 時間格式錯誤，必須為: 00h00m00s 或任意時間組合(5m30s)"
    return L
end
