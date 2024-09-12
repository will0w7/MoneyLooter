---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_CircularBuffer
---@field buffer table
---@field capacity integer
---@field head integer
---@field tail integer
---@field size integer
local CircularBuffer = {}
MoneyLooter.CircularBuffer = CircularBuffer

---@class ML_CBFunctions
local CBFunctions = {}
MoneyLooter.CBFunctions = CBFunctions

---@param capacity integer
---@return ML_CircularBuffer
function CBFunctions.New(buffer, capacity)
    if buffer == nil or not buffer.buffer then
        buffer = {}
    else
        table.wipe(buffer)
    end
    buffer.buffer = {}
    buffer.capacity = capacity
    buffer.head = 1
    buffer.tail = 1
    buffer.size = 0

    return buffer
end

---@param buffer ML_CircularBuffer
---@return integer
function CBFunctions.GetSize(buffer)
    return buffer.size
end

---@param buffer ML_CircularBuffer
---@param value ML_LootedItem
function CBFunctions.Push(buffer, value)
    buffer.buffer[buffer.head] = value
    buffer.head = (buffer.head % buffer.capacity) + 1
    if buffer.size < buffer.capacity then
        buffer.size = buffer.size + 1
    else
        buffer.tail = (buffer.tail % buffer.capacity) + 1
    end
end

---@param buffer ML_CircularBuffer
---@param func function
function CBFunctions.Iterate(buffer, func)
    local i = buffer.tail
    for _ = 1, buffer.size do
        func(buffer.buffer[i])
        i = (i % buffer.capacity) + 1
    end
end
