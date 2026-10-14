---@class MoneyLooter
---@field isRetail boolean
---@field isForever boolean
---@field isClassic boolean
---@field isTBC boolean
---@field isWrath boolean
---@field isCata boolean
---@field isMists boolean
local MoneyLooter = select(2, ...)

MoneyLooter.isRetail = false
MoneyLooter.isClassic = false
MoneyLooter.isCata = false
MoneyLooter.isWrath = false
MoneyLooter.isTBC = false
MoneyLooter.isMists = false
MoneyLooter.isForever = false

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
else -- FIXME
    MoneyLooter.isForever = true
end

local Debug = MoneyLooter.Debug
-- Debug.ToggleDebug()

Debug.Info("isRetail " .. tostring(MoneyLooter.isRetail))
Debug.Info("isClassic " .. tostring(MoneyLooter.isClassic))
Debug.Info("isCata " .. tostring(MoneyLooter.isCata))
Debug.Info("isWrath " .. tostring(MoneyLooter.isWrath))
Debug.Info("isTBC " .. tostring(MoneyLooter.isTBC))
Debug.Info("isMists " .. tostring(MoneyLooter.isMists))
Debug.Info("isForever " .. tostring(MoneyLooter.isForever))
