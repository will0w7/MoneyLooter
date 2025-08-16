---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_DataProviderMixin
local DataProviderMixin = {}
Mixin(DataProviderMixin, CallbackRegistryMixin)

DataProviderMixin:GenerateCallbackEvents(
    {
        "OnSizeChanged",
        "OnInsert",
        "OnRemove"
    }
);

---@class ML_DataProvider
local DataProvider = {}
DataProvider.__index = DataProvider
MoneyLooter.DataProvider = DataProvider

local tinsert = table.insert

local Event = DataProviderMixin.Event
local OnInsert = Event.OnInsert
local OnSizeChanged = Event.OnSizeChanged

function DataProviderMixin:Enumerate(indexBegin, indexEnd)
    return CreateTableEnumerator(self.collection, indexBegin, indexEnd);
end

function DataProviderMixin:InsertInternal(elementData, insertIndex)
    local col = self.collection
    if not insertIndex then
        col[#col + 1] = elementData
        insertIndex = #col
    else
        tinsert(col, insertIndex, elementData)
    end

    self:TriggerEvent(OnInsert, insertIndex, elementData, false)
end

function DataProviderMixin:BulkInsert(...)
    local args = { ... }
    if #args == 0 then return end

    local col = self.collection
    for _, v in ipairs(args) do
        col[#col + 1] = v
    end

    self:TriggerEvent(OnInsert, #col, col, false)
    self:TriggerEvent(OnSizeChanged, false)
end

function DataProviderMixin:SingleInsert(item)
    local col = self.collection
    col[#col + 1] = item
    self:TriggerEvent(OnInsert, #col, item, false)
    self:TriggerEvent(OnSizeChanged, false)
end

function DataProviderMixin:Insert(...)
    return self:BulkInsert(...)
end

function DataProviderMixin:GetSize()
    return #self.collection
end

function DataProviderMixin:RemoveIndexRange(indexBegin, indexEnd)
    local size = self:GetSize()
    if size == 0 then return end

    indexBegin = math.max(1, indexBegin or 1)
    indexEnd   = math.min(size, indexEnd or size)

    if indexBegin > indexEnd then return end

    local keepCount = size - (indexEnd - indexBegin + 1)
    if keepCount <= 0 then
        self.collection = {}
        return
    end

    local src = indexEnd + 1
    for i = indexBegin, keepCount do
        self.collection[i] = self.collection[src]
        src = src + 1
    end

    for i = keepCount + 1, size do
        self.collection[i] = nil
    end
end

function DataProviderMixin:Flush()
    local oldCollection = self.collection
    self.collection = {}

    if #oldCollection == 0 then return end

    local trigger  = self.TriggerEvent
    local evRemove = Event.OnRemove

    for i, elementData in ipairs(oldCollection) do
        trigger(self, evRemove, elementData, i)
    end

    self:TriggerEvent(Event.OnSizeChanged, false)
end

function DataProviderMixin:Init(tbl)
    CallbackRegistryMixin.OnLoad(self)
    self.collection = {}

    if tbl then
        for _, elementData in ipairs(tbl) do
            self:InsertInternal(elementData)
        end
    end
end

function DataProvider.CreateDataProvider(tbl)
    local provider = CreateFromMixins(DataProviderMixin)
    provider:Init(tbl)
    return provider
end
