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

---@param buffer ML_CircularBuffer
---@return table
function CBFunctions.ToTable(buffer)
    local result = {}
    local i = buffer.tail
    for _ = 1, buffer.size do
        result[#result + 1] = buffer.buffer[i]
        i = (i % buffer.capacity) + 1
    end
    return result
end

---@param buffer ML_CircularBuffer
---@param itemToRemove ML_Item
function CBFunctions.RemoveItem(buffer, itemToRemove)
    if not buffer or not itemToRemove or buffer.size == 0 then return end

    local removed = false
    local newBuffer = {}
    local newSize = 0

    local i = buffer.tail
    for _ = 1, buffer.size do
        local item = buffer.buffer[i]
        if item then
            local isSame = item.entryId ~= nil and item.entryId == itemToRemove.entryId

            if isSame and not removed then
                removed = true
            else
                newBuffer[newSize + 1] = item
                newSize = newSize + 1
            end
        end
        i = (i % buffer.capacity) + 1
    end

    for j = 1, newSize do
        buffer.buffer[j] = newBuffer[j]
    end
    for j = newSize + 1, buffer.size do
        buffer.buffer[j] = nil
    end

    buffer.size = newSize
    buffer.head = newSize + 1
    buffer.tail = 1

    return removed
end
