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

---@param capacity integer
---@return ML_CircularBuffer
function CircularBuffer_New(self, capacity)
    if self == nil or not self.buffer then
        self = {}
    end
    table.wipe(self)
    self.buffer = {}
    self.capacity = capacity
    self.head = 1
    self.tail = 1
    self.size = 0

    return self
end

---@param self ML_CircularBuffer
---@return integer
function CircularBuffer_GetSize(self)
    return self.size
end

---@param self ML_CircularBuffer
---@param value ML_LootedItem
function CircularBuffer_Push(self, value)
    self.buffer[self.head] = value
    self.head = (self.head % self.capacity) + 1
    if self.size < self.capacity then
        self.size = self.size + 1
    else
        self.tail = (self.tail % self.capacity) + 1
    end
end

---@param self ML_CircularBuffer
---@param func function
function CircularBuffer_Iterate(self, func)
    local i = self.tail
    for _ = 1, self.size do
        func(self.buffer[i])
        i = (i % self.capacity) + 1
    end
end
