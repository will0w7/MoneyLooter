---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Profiler
local Profiler = {}
MoneyLooter.Profiler = Profiler

Profiler.enabled = false

local GetTimePreciseSec = GetTimePreciseSec
local startTimes = {}

---@param label string id
function Profiler.RealStart(label)
    if not Profiler.enabled then return end
    startTimes[label] = GetTimePreciseSec()
end

---@param label string id
function Profiler.RealStop(label)
    if not Profiler.enabled then return end
    local t0 = startTimes[label]
    if not t0 then
        print("|cffff0000[Profiler] 'Start' not found for ", label, "|r")
        return
    end
    local elapsedSec = GetTimePreciseSec() - t0
    print(string.format("$> [Profiler] %s: %.4f ms", label, elapsedSec * 1000))
    startTimes[label] = nil
end

---@param label string id
---@param func function
function Profiler.RealMeasure(label, func, ...)
    Profiler.Start(label)
    local res = { func(...) }
    Profiler.Stop(label)
    return unpack(res)
end

local function noop() end
local function noopMeasure(_, func, ...) return func(...) end

local function setProfilerEnabled(enabled)
    Profiler.enabled = enabled
    Profiler.Start   = enabled and Profiler.RealStart or noop
    Profiler.Stop    = enabled and Profiler.RealStop or noop
    Profiler.Measure = enabled and Profiler.RealMeasure or noopMeasure
end

function Profiler.ToggleProfiler()
    setProfilerEnabled(not Profiler.enabled)
    print("|cffff0000$> [Profiler] Enabled: ", Profiler.enabled, "|r")
end

setProfilerEnabled(false)
