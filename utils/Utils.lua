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

---@param quality integer
---@return string
function Utils.GetQualityName(quality)
    return _G["MONEYLOOTER_L_MPRICE_QUALITY_" .. quality]
        or _G["ITEM_QUALITY" .. quality .. "_DESC"]
        or tostring(quality)
end

---@param quality integer
---@return number r
---@return number g
---@return number b
function Utils.GetQualityColor(quality)
    local C_GetItemQualityColor = C_Item and C_Item.GetItemQualityColor
    local getItemQualityColor = C_GetItemQualityColor or _G.GetItemQualityColor
    if getItemQualityColor then
        local r, g, b = getItemQualityColor(quality)
        if r ~= nil then
            return r, g, b
        end
    end
    return 1, 1, 1
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
