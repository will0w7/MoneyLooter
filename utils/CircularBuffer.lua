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
    if not buffer or not itemToRemove or buffer.size == 0 then return false end

    local read_i = buffer.tail
    local found_step = 0

    for step = 1, buffer.size do
        local item = buffer.buffer[read_i]
        if item and item.entryId ~= nil and item.entryId == itemToRemove.entryId then
            found_step = step
            break
        end
        read_i = (read_i % buffer.capacity) + 1
    end

    if found_step == 0 then return false end

    local write_i = read_i
    read_i = (read_i % buffer.capacity) + 1

    for _ = found_step + 1, buffer.size do
        buffer.buffer[write_i] = buffer.buffer[read_i]
        write_i = (write_i % buffer.capacity) + 1
        read_i = (read_i % buffer.capacity) + 1
    end

    buffer.buffer[write_i] = nil
    buffer.size = buffer.size - 1
    buffer.head = write_i

    return true
end

---@param buffer ML_CircularBuffer
---@param itemID number
function CBFunctions.RemoveAllItemsByID(buffer, itemID)
    if not buffer or itemID == nil or buffer.size == 0 then return false end

    local removed = false
    local read_i = buffer.tail
    local write_i = buffer.tail
    local newSize = 0

    for _ = 1, buffer.size do
        local item = buffer.buffer[read_i]

        if item and item.id == itemID then
            removed = true
        else
            if read_i ~= write_i then
                buffer.buffer[write_i] = item
            end
            write_i = (write_i % buffer.capacity) + 1
            newSize = newSize + 1
        end

        read_i = (read_i % buffer.capacity) + 1
    end

    if removed then
        local itemsRemoved = buffer.size - newSize
        local cleanup_i = write_i

        for _ = 1, itemsRemoved do
            buffer.buffer[cleanup_i] = nil
            cleanup_i = (cleanup_i % buffer.capacity) + 1
        end

        buffer.size = newSize
        buffer.head = write_i
    end

    return removed
end
