---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Debug
local Debug = {}
MoneyLooter.Debug = Debug

Debug.enabled = false

------------------------------------------------------------------------------
local print, tostring, type, pairs = print, tostring, type, pairs
local t_insert, t_concat = table.insert, table.concat
------------------------------------------------------------------------------
local PREFIX = "|cff00ff00$> [MLDebug]|r"
local INFO_PREFIX = "|cff00ffff$> [MLInfo]|r"
local WARN_PREFIX = "|cffffff00$> [MLWarn]|r"
local ERROR_PREFIX = "|cffff0000$> [MLError]|r"
------------------------------------------------------------------------------

---@param ... any
function Debug.Print(...)
    if not Debug.enabled then return end
    print(PREFIX, ...)
end

---@param ... any
function Debug.Info(...)
    if not Debug.enabled then return end
    print(INFO_PREFIX, ...)
end

---@param ... any
function Debug.Warn(...)
    if not Debug.enabled then return end
    print(WARN_PREFIX, ...)
end

--- prints an error regardless of debug mode
---@param ... any
function Debug.Error(...)
    print(ERROR_PREFIX, ...)
end

--- recursively formats a value into a readable string
---@param value any
---@param indent string
---@param seen table
---@return string
local function DumpValue(value, indent, seen)
    local valueType = type(value)
    if valueType ~= "table" then
        return indent .. tostring(value)
    end
    if seen[value] then
        return indent .. "<recursive>"
    end
    seen[value] = true
    local lines = { indent .. "{" }
    local innerIndent = indent .. "  "
    for k, v in pairs(value) do
        t_insert(lines, innerIndent .. tostring(k) .. " = " ..
            DumpValue(v, innerIndent, seen))
    end
    t_insert(lines, indent .. "}")
    seen[value] = nil
    return t_concat(lines, "\n")
end

---@param value any
function Debug.Dump(value)
    if not Debug.enabled then return end
    print(PREFIX, DumpValue(value, "", {}))
end

--- toggles debug mode, also enables the profiler
function Debug.ToggleDebug()
    Debug.enabled = not Debug.enabled
    if MoneyLooter.Profiler then
        MoneyLooter.Profiler.SetEnabled(Debug.enabled)
    end
    print(PREFIX, "Enabled: ", tostring(Debug.enabled))
end
