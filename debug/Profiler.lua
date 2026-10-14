---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Profiler
local Profiler = {}
MoneyLooter.Profiler = Profiler

Profiler.enabled = false

local GetTimePreciseSec = GetTimePreciseSec
local startTimes = {}
local depth = 0

---@param label string
function Profiler.Start(label)
    if not Profiler.enabled then return end
    depth = depth + 1
    startTimes[label] = GetTimePreciseSec()
end

---@param label string
function Profiler.Stop(label)
    if not Profiler.enabled then return end
    local t0 = startTimes[label]
    if not t0 then
        print("|cffffff00$> [MLProfiler]|r 'Start' not found for ", label)
        return
    end
    local elapsedSec = GetTimePreciseSec() - t0
    depth = depth - 1
    if depth < 0 then depth = 0 end
    print(string.format("|cffffff00$> [MLProfiler]|r (%d) %s: %.4f ms", depth, label, elapsedSec * 1000))
    startTimes[label] = nil
end

---@param label string
---@param func function
function Profiler.Measure(label, func, ...)
    if not Profiler.enabled then
        return func(...)
    end
    Profiler.Start(label)
    local res = { func(...) }
    Profiler.Stop(label)
    return unpack(res)
end

---@param enabled boolean
function Profiler.SetEnabled(enabled)
    Profiler.enabled = enabled
    depth = 0
    table.wipe(startTimes)
end
