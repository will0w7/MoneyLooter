---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Utils
local Utils = {}

-- https://gist.github.com/tylerneylon/81333721109155b2d244
---@param obj table
---@return table
function Utils.DeepCopyMeta(obj)
    if type(obj) ~= 'table' then return obj end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do res[Utils.DeepCopyMeta(k)] = Utils.DeepCopyMeta(v) end
    return res
end

---@param val integer
---@return string
function Utils.GetCoinTextString(val)
    if val == nil or val == 0 then return "00|cFFC07A50c|r" end
    local gold = math.floor(val / 10000)
    local silver = math.floor(val % 10000 / 100)
    local copper = math.floor(val % 100)

    local fString = ""
    if gold > 0 then fString = fString .. gold .. "|cFFD9BE4Cg|r" end
    if gold > 0 or silver > 0 then fString = fString .. string.format("%02u|cFFB3B4BAs|r", silver) end
    fString = fString .. string.format("%02u|cFFC07A50c|r", copper)
    return fString
end

MoneyLooter.Utils = Utils
