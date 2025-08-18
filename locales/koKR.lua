---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.koKR = function()
  local L = {}
  L["START"] = "시작"
  L["CONTINUE"] = "계속"
  L["PAUSE"] = "일시정지"
  L["RESET"] = "초기화"
  L["TIME_LABEL"] = "시간:"
  L["GOLD_LABEL"] = "골드:"
  L["ITEMS_LABEL"] = "아이템:"
  L["GPH_LABEL"] = "GPH:"
  L["PRICIEST_LABEL"] = "가장 비싼:"
  L["USAGE"] = [[====== |cFFd8de35MoneyLooter 사용 정보|r ======
  |cFF36e8e6/ml|r: 표시/숨김 전환
  |cFF36e8e6/ml|r |cFFf1f488help|r: 도움말 보기
  |cFF36e8e6/ml|r |cFFf1f488show|r: MoneyLooter 표시
  |cFF36e8e6/ml|r |cFFf1f488hide|r: MoneyLooter 숨김
  |cFF36e8e6/ml|r |cFFf1f488info|r: 애드온 정보 보기.
  |cFF36e8e6/ml|r |cFFf1f488custom '사용자 정의 TSM 문자열'|r: 가격 계산에 사용할 사용자 정의 TSM 문자열을 설정합니다. 비어 있으면 현재 사용 중인 TSM 문자열이 반환됩니다.
    예시: /ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice '값'|r: 품질에 대한 최소 가격 임계값을 설정합니다.
            mpricex: 모든 품질 사용 가능.
            mprice1: 품질 1 - 일반 - 흰색
            mprice2: 품질 2 - 드물음 - 초록색
            mprice3: 품질 3 - 희귀 - 파란색
            mprice4: 품질 4 - 전설 - 보라색
      나머지 품질은 판매자 가격을 사용합니다(있다면).
    예시: /ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      mprice의 가격 형식은 숫자 뒤에 g(골드), s(실버) 또는 c(코퍼)를 붙입니다. 숫자만 지정하면 골드를 기본값으로 사용합니다.
  |cFF36e8e6애드온 버전:|r ]]
  L["WELCOME"] = "MoneyLooter에 오신 것을 환영합니다! |cFF36e8e6/ml|r |cFFf1f488help|r을(를) 사용해 애드온 옵션을 확인하세요."
  L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r: 다시 표시 |cFFd8de35MoneyLooter|r"
  L["INFO"] = "|cFFd8de35Money Looter|r은(는) Will0w7이 만든 가볍고 빠른 전리품 추적 애드온입니다."
  L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM을(를) 사용할 수 없습니다."
  L["TSM_CUSTOM_STRING_NOT_VALID"] = "|cFFd8de35Money Looter:|r 다음 TSM 문자열이 유효하지 않으며 설정되지 않았습니다: "
  L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r 다음 TSM 문자열이 유효하며 설정되었습니다: "
  L["TSM_CUSTOM_STRING"] = "|cFFd8de35Money Looter:|r 다음 TSM 문자열을 사용합니다: "
  L["NEW_DB_VERSION"] = "|cFFd8de35Money Looter:|r 데이터베이스 새 버전이 감지되어 업데이트 중입니다…"
  L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r 데이터베이스가 성공적으로 업데이트되었습니다!"
  L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r 다음 최소 가격이 유효하지 않습니다: "
  L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r 다음 최소 가격이 유효하며 설정되었습니다:"
  L["MPRICE_QUALITY_1"] = "일반"
  L["MPRICE_QUALITY_2"] = "드물음"
  L["MPRICE_QUALITY_3"] = "희귀"
  L["MPRICE_QUALITY_4"] = "전설"
  L["MPRICE_QUALITY_99"] = "모든 품질"
  L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r 인식되지 않은 화폐, 입력을 확인하세요."
  L["MPRICE_COIN_G"] = "골드"
  L["MPRICE_COIN_S"] = "실버"
  L["MPRICE_COIN_C"] = "코퍼"
  L["FORCE_VENDOR_PRICE_ENABLED"] = "|cFFd8de35Money Looter:|r 판매자 가격 강제 활성화. 판매자 판매가격만 사용합니다."
  L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r 판매자 가격 강제 비활성화."
  return L
end
