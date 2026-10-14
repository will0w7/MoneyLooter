---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Appearance
---@field isAvailable boolean
local Appearance = {}
MoneyLooter.Appearance = Appearance

local C_TransmogCollection = C_TransmogCollection
local C_Item = C_Item
local isDressable = C_Item and C_Item.IsDressableItemByID

Appearance.isAvailable = C_TransmogCollection ~= nil

local sourceIDCache = {}
local visualSourcesCache = {}

function Appearance.ClearCache()
    table.wipe(sourceIDCache)
    table.wipe(visualSourcesCache)
end

---@param itemInfo string|integer
---@return integer|nil
function Appearance.GetSourceID(itemInfo)
    if not Appearance.isAvailable or not itemInfo then return nil end

    local cached = sourceIDCache[itemInfo]
    if cached then return cached end

    if isDressable and not isDressable(itemInfo) then return nil end

    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemInfo))
    if sourceID then sourceIDCache[itemInfo] = sourceID end

    return sourceID
end

---@param sourceID integer
---@return integer|nil
function Appearance.GetVisualID(sourceID)
    if not Appearance.isAvailable or not sourceID then return nil end
    local info = C_TransmogCollection.GetSourceInfo(sourceID)
    return info and info.visualID
end

---@param group table
---@return boolean
local function IsGroupUnobtainable(group)
    while group do
        if group.u then return true end
        group = group.parent
    end
    return false
end

---@param att table
---@param sourceID integer
---@return boolean|nil
local function IsSourceObtainable(att, sourceID)
    local groups = att.SearchForObject("sourceID", sourceID, "field", true)
    if not groups or #groups == 0 then return nil end

    for _, group in ipairs(groups) do
        if not IsGroupUnobtainable(group) then
            return true
        end
    end
    return false
end

---@param itemInfo string|integer
---@return boolean|nil
---@return integer|nil
---@return integer|nil
---@return integer|nil
function Appearance.IsUniqueAppearance(itemInfo)
    if not MoneyLooter.isRetail and not MoneyLooter.isForever then return false end

    local sourceID = Appearance.GetSourceID(itemInfo)
    if not sourceID then return nil, nil, nil, nil end

    local visualID = Appearance.GetVisualID(sourceID)
    if not visualID then return nil, nil, sourceID, nil end

    local allSources = C_TransmogCollection.GetAllAppearanceSources(visualID)
    if not allSources or #allSources == 0 then return nil, nil, sourceID, visualID end

    local att = AllTheThings or ATTC
    if att and att.SearchForObject then
        local obtainable = 0
        for _, sid in ipairs(allSources) do
            if IsSourceObtainable(att, sid) then
                obtainable = obtainable + 1
            end
        end
        return obtainable == 1, obtainable, sourceID, visualID
    end

    -- fallback, count all appareances
    local count = #allSources
    return count == 1, count, sourceID, visualID
end
