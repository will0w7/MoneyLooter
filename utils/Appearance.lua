---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Appearance
---@field isAvailable boolean
local Appearance = {}
MoneyLooter.Appearance = Appearance

local C_TransmogCollection = _G.C_TransmogCollection
local C_Item = _G.C_Item

Appearance.isAvailable = C_TransmogCollection ~= nil

local sourceIDCache = {}
local visualSourcesCache = {}

function Appearance.ClearCache()
    table.wipe(sourceIDCache)
    table.wipe(visualSourcesCache)
end

---@param itemInfo string|integer
---@return integer|nil sourceID
function Appearance.GetSourceID(itemInfo)
    if not Appearance.isAvailable or not itemInfo then return nil end

    local cached = sourceIDCache[itemInfo]
    if cached then return cached end

    local isDressable = C_Item and C_Item.IsDressableItemByID
    if isDressable and not isDressable(itemInfo) then return nil end

    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemInfo))
    if sourceID then sourceIDCache[itemInfo] = sourceID end

    return sourceID
end

---@param sourceID integer
---@return table|nil sourceInfo
function Appearance.GetSourceInfo(sourceID)
    if not Appearance.isAvailable or not sourceID then return nil end
    return C_TransmogCollection.GetSourceInfo(sourceID)
end

---@param sourceID integer
---@return integer|nil visualID
function Appearance.GetVisualID(sourceID)
    local info = Appearance.GetSourceInfo(sourceID)
    return info and info.visualID
end

---@param visualID integer
---@return integer[]|nil sources
function Appearance.GetAppearanceSourcesByVisualID(visualID)
    if not Appearance.isAvailable or not visualID then return nil end

    local cached = visualSourcesCache[visualID]
    if cached then return cached end

    local sources = C_TransmogCollection.GetAllAppearanceSources(visualID)
    if sources and #sources > 0 then visualSourcesCache[visualID] = sources end

    return sources
end

---@param sourceID integer
---@return integer[]|nil sources
---@return integer|nil visualID
function Appearance.GetSourcesForSourceID(sourceID)
    local visualID = Appearance.GetVisualID(sourceID)
    if not visualID then return nil, nil end
    return Appearance.GetAppearanceSourcesByVisualID(visualID), visualID
end

---@param itemInfo string|integer
---@return integer[]|nil sources
---@return integer|nil sourceID
---@return integer|nil visualID
function Appearance.GetSourcesForItem(itemInfo)
    local sourceID = Appearance.GetSourceID(itemInfo)
    if not sourceID then return nil, nil, nil end

    local sources, visualID = Appearance.GetSourcesForSourceID(sourceID)
    return sources, sourceID, visualID
end

---@param itemInfo string|integer
---@return boolean|nil isUnique
---@return integer|nil sourceCount
---@return integer|nil sourceID
---@return integer|nil visualID
function Appearance.IsUniqueAppearance(itemInfo)
    local sources, sourceID, visualID = Appearance.GetSourcesForItem(itemInfo)
    if not sources then return nil, nil, sourceID, visualID end

    local count = #sources
    return count == 1, count, sourceID, visualID
end

---@param sourceID integer
---@return boolean|nil isUnique
---@return integer|nil sourceCount
---@return integer|nil visualID
function Appearance.IsUniqueSourceID(sourceID)
    local sources, visualID = Appearance.GetSourcesForSourceID(sourceID)
    if not sources then return nil, nil, visualID end

    local count = #sources
    return count == 1, count, visualID
end

---@return table|nil att
function Appearance.GetATT()
    return _G.AllTheThings or _G.ATTC
end

---@return boolean
function Appearance.IsATTLoaded()
    return Appearance.GetATT() ~= nil
end

---@param field string
---@param id string|integer
---@return table|nil group
function Appearance.GetATTGroup(field, id)
    local att = Appearance.GetATT()
    if not (att and att.SearchForObject) then return nil end
    return att.SearchForObject(field, id, "field")
end

---@param field string
---@param id string|integer
---@return table[]|nil groups
function Appearance.GetATTGroups(field, id)
    local att = Appearance.GetATT()
    if not (att and att.SearchForObject) then return nil end
    return att.SearchForObject(field, id, "field", true)
end

---@param link string
---@return table[]|nil groups
function Appearance.GetATTByLink(link)
    local att = Appearance.GetATT()
    if not (att and att.SearchForLink) then return nil end
    return att.SearchForLink(link)
end

---@param sourceID integer
---@return integer|nil attKnownCount
---@return integer[]|nil sources
---@return integer|nil visualID
function Appearance.CountATTSourcesForAppearance(sourceID)
    local att = Appearance.GetATT()
    if not (att and att.SearchForObject) then return nil end

    local sources, visualID = Appearance.GetSourcesForSourceID(sourceID)
    if not sources then return nil, nil, visualID end

    local known = 0
    for _, sid in ipairs(sources) do
        if att.SearchForObject("sourceID", sid, "field") then
            known = known + 1
        end
    end

    return known, sources, visualID
end
