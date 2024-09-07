local _, ml_table = ...
if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
    ml_table.isRetail = true
elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    ml_table.isClassic = true
elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
    ml_table.isCata = true
elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
    ml_table.isWrath = true
elseif WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
    ml_table.isTBC = true
end