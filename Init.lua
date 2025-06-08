---@class MoneyLooter
---@field isRetail boolean
---@field isClassic boolean
---@field isCata boolean
---@field isWrath boolean
---@field isTBC boolean
---@field isMists boolean
local MoneyLooter = select(2, ...)

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
    MoneyLooter.isRetail = true
elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    MoneyLooter.isClassic = true
elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
    MoneyLooter.isCata = true
elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
    MoneyLooter.isWrath = true
elseif WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
    MoneyLooter.isTBC = true
elseif WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
    MoneyLooter.isMists = true
end
