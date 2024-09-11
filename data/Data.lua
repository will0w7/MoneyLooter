---@class MoneyLooter
local MoneyLooter = select(2, ...)

local Utils = MoneyLooter.Utils
local Constants = MoneyLooter.Constants
local CircularBuffer = MoneyLooter.CircularBuffer

local BufferCapacity = 100
MoneyLooter.BufferCapacity = BufferCapacity

---@class ML_DB
---@field CurrentStartText string
local DefaultMoneyLooterDB = {
    Visible = true,
    ScrollLootFrameVisible = true,
    ----------------------------------------------
    Running = false,
    ----------------------------------------------
    RawGold = 0,
    ItemsMoney = 0,
    TotalMoney = 0,
    Priciest = 0,
    PriciestID = 0,
    ListLootedItems = CircularBuffer,
    OldMoney = 0,
    ----------------------------------------------
    Timer = 0,
    ----------------------------------------------
    CurrentStartText = _G.MONEYLOOTER_L_START,
    ----------------------------------------------
    DBVersion = 1725972263906
}

---@class ML_DB
MoneyLooterDB = MoneyLooterDB

---@class ML_DefaultXDB
local DefaultMoneyLooterXDB = {
    CurrentTSMString = "dbmarket",
    ------------------------------
    MinPrice1 = 0,
    MinPrice2 = 0,
    MinPrice3 = 0,
    MinPrice4 = 0,
}

---@class ML_TempData
---@field LootedItems table
---@field InteractionPaused boolean
local MoneyLooterTempData = {
    LootedItems = {},
    InteractionPaused = false
}

---@class ML_CrossDB
---@field CurrentTSMString string
---@field MinPrice1 integer
---@field MinPrice2 integer
---@field MinPrice3 integer
---@field MinPrice4 integer
MoneyLooterXDB = MoneyLooterXDB

---@return boolean
function IsVisible()
    return MoneyLooterDB.Visible
end

---@param val boolean
function SetVisible(val)
    if val ~= nil then
        MoneyLooterDB.Visible = val
    end
end

---@return boolean
function IsRunning()
    return MoneyLooterDB.Running
end

---@param val boolean
function SetRunning(val)
    if val ~= nil then
        MoneyLooterDB.Running = val
    end
end

---@return integer
function GetRawGold()
    return MoneyLooterDB.RawGold or 0
end

---@param val integer
function AddRawGold(val)
    if val ~= nil then
        MoneyLooterDB.RawGold = MoneyLooterDB.RawGold + val
    end
end

---@return integer
function GetItemsMoney()
    return MoneyLooterDB.ItemsMoney or 0
end

---@param val integer
function AddItemsMoney(val)
    if val ~= nil then
        MoneyLooterDB.ItemsMoney = MoneyLooterDB.ItemsMoney + val
    end
end

---@param val integer
function AddTotalMoney(val)
    if val ~= nil then
        MoneyLooterDB.TotalMoney = MoneyLooterDB.TotalMoney + val
    end
end

---@return integer
function GetPriciest()
    return MoneyLooterDB.Priciest or 0
end

---@param id integer
---@param val integer
function SetPriciest(val, id)
    if val ~= nil and val > (MoneyLooterDB.Priciest or 0) then
        MoneyLooterDB.Priciest = val
        MoneyLooterDB.PriciestID = id
    end
end

---@return integer
function GetPriciestID()
    return MoneyLooterDB.PriciestID or 0
end

---@return table
function GetLootedItems()
    return MoneyLooterTempData.LootedItems or {}
end

function ResetLootedItems()
    MoneyLooterTempData.LootedItems = {}
end

function InitListLootedItems()
    if MoneyLooterDB.ListLootedItems == nil or MoneyLooterDB.ListLootedItems.buffer == nil then
        MoneyLooterDB.ListLootedItems = CircularBuffer_New(MoneyLooterDB.ListLootedItems, BufferCapacity)
    end
end

---@return ML_CircularBuffer
function GetListLootedItems()
    return MoneyLooterDB.ListLootedItems
end

---@param val ML_LootedItem
function InsertLootedItem(val)
    if MoneyLooterTempData.LootedItems == nil then MoneyLooterTempData.LootedItems = {} end
    if val ~= nil then
        table.insert(MoneyLooterTempData.LootedItems, val)
        CircularBuffer_Push(MoneyLooterDB.ListLootedItems, val)
    end
end

---@return integer
function GetListLootedItemsCount()
    return CircularBuffer_GetSize(MoneyLooterDB.ListLootedItems)
end

---@return integer
function GetOldMoney()
    return MoneyLooterDB.OldMoney or 0
end

---@param val integer
function SetOldMoney(val)
    if val ~= nil then
        MoneyLooterDB.OldMoney = val
    end
end

---@return integer
function GetTimer()
    return MoneyLooterDB.Timer or 0
end

function AddOneToTimer()
    MoneyLooterDB.Timer = (MoneyLooterDB.Timer or 0) + 1
end

---@return string
function GetCurrentStartText()
    return MoneyLooterDB.CurrentStartText or _G.MONEYLOOTER_L_START
end

---@param val string
---@return string
function SetCurrentStartText(val)
    if val ~= nil then
        MoneyLooterDB.CurrentStartText = val
    end
    return MoneyLooterDB.CurrentStartText or _G.MONEYLOOTER_L_START
end

---@return integer
function GetMinPrice1()
    return MoneyLooterXDB.MinPrice1 or 0
end

---@param val integer
function SetMinPrice1(val)
    MoneyLooterXDB.MinPrice1 = val
end

---@return integer
function GetMinPrice2()
    return MoneyLooterXDB.MinPrice2 or 0
end

---@param val integer
function SetMinPrice2(val)
    MoneyLooterXDB.MinPrice2 = val
end

---@return integer
function GetMinPrice3()
    return MoneyLooterXDB.MinPrice3 or 0
end

---@param val integer
function SetMinPrice3(val)
    MoneyLooterXDB.MinPrice3 = val
end

---@return integer
function GetMinPrice4()
    return MoneyLooterXDB.MinPrice4 or 0
end

---@param val integer
function SetMinPrice4(val)
    MoneyLooterXDB.MinPrice4 = val
end

---@param val integer
function SetAllMinPrices(val)
    MoneyLooterXDB.MinPrice1 = val
    MoneyLooterXDB.MinPrice2 = val
    MoneyLooterXDB.MinPrice3 = val
    MoneyLooterXDB.MinPrice4 = val
end

---@return string
function GetCurrentTSMString()
    return MoneyLooterXDB.CurrentTSMString or Constants.Strings.TSM_STRING
end

---@param val string
function SetTSMString(val)
    local TSM_API = TSM_API
    if TSM_API == nil then
        print(_G.MONEYLOOTER_L_TSM_NOT_AVAILABLE)
        return
    end
    if not TSM_API.IsCustomPriceValid(val) then
        print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING_NOT_VALID .. val)
        return
    end
    MoneyLooterXDB.CurrentTSMString = val
    print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING_VALID .. val)
end

---@return boolean
function IsScrollLootFrameVisible()
    return MoneyLooterDB.ScrollLootFrameVisible
end

---@param val boolean
function SetScrollLootFrameVisible(val)
    if val ~= nil then
        MoneyLooterDB.ScrollLootFrameVisible = val
    end
end

---@return integer
function CalcGPH()
    local perhour = 0
    local total = MoneyLooterDB.TotalMoney
    if total > 0 and GetTimer() > 0 then
        perhour = (total / MoneyLooterDB.Timer) * 3600
    end
    return math.floor(perhour)
end

function ResetMoneyLooterDB()
    if MoneyLooterDB == nil then
        MoneyLooterDB = {}
    end
    MoneyLooterDB = table.wipe(MoneyLooterDB)
    MoneyLooterDB = Utils.deep_copy_meta(DefaultMoneyLooterDB)
    MoneyLooterDB.ListLootedItems = CircularBuffer_New(MoneyLooterDB.ListLootedItems, BufferCapacity)
end

function UpdateMLDB()
    if MoneyLooterDB == nil or MoneyLooterDB.DBVersion == nil or MoneyLooterDB.DBVersion < DefaultMoneyLooterDB.DBVersion then
        print(_G.MONEYLOOTER_L_NEW_DB_VERSION)
        ResetMoneyLooterDB()
        print(_G.MONEYLOOTER_L_DB_UPDATED)
    end
end

function UpdateMLXDB()
    if MoneyLooterXDB == nil then
        MoneyLooterXDB = Utils.deep_copy_meta(DefaultMoneyLooterXDB)
    end
end

---@return boolean
function IsInteractionPaused()
    return MoneyLooterTempData.InteractionPaused
end

---@param val boolean
function SetInteractionPaused(val)
    if val ~= nil then
        MoneyLooterTempData.InteractionPaused = val
    end
end
