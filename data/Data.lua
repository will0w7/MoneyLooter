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
    OldMoney = 0,
    RawMoney = 0,
    ItemsMoney = 0,
    TotalMoney = 0,
    Priciest = 0,
    PriciestID = 0,
    ListLootedItems = CircularBuffer,
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

---@param visible boolean
function SetVisible(visible)
    if visible ~= nil then
        MoneyLooterDB.Visible = visible
    end
end

---@return boolean
function IsRunning()
    return MoneyLooterDB.Running
end

---@param running boolean
function SetRunning(running)
    if running ~= nil then
        MoneyLooterDB.Running = running
    end
end

---@return integer
function GetRawMoney()
    return MoneyLooterDB.RawMoney or 0
end

---@param money integer
function AddRawMoney(money)
    if money ~= nil then
        MoneyLooterDB.RawMoney = MoneyLooterDB.RawMoney + money
    end
end

---@return integer
function GetItemsMoney()
    return MoneyLooterDB.ItemsMoney or 0
end

---@param money integer
function AddItemsMoney(money)
    if money ~= nil then
        MoneyLooterDB.ItemsMoney = MoneyLooterDB.ItemsMoney + money
    end
end

---@param money integer
function AddTotalMoney(money)
    if money ~= nil then
        MoneyLooterDB.TotalMoney = MoneyLooterDB.TotalMoney + money
    end
end

---@return integer
function GetPriciest()
    return MoneyLooterDB.Priciest or 0
end

---@param id integer
---@param money integer
function SetPriciest(money, id)
    if money ~= nil and money > (MoneyLooterDB.Priciest or 0) then
        MoneyLooterDB.Priciest = money
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
    if MoneyLooterTempData.LootedItems == nil then
        MoneyLooterTempData.LootedItems = {}
    else
        table.wipe(MoneyLooterTempData.LootedItems)
    end
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

---@param lootedItem ML_LootedItem
function InsertLootedItem(lootedItem)
    if MoneyLooterTempData.LootedItems == nil then MoneyLooterTempData.LootedItems = {} end
    if lootedItem ~= nil then
        table.insert(MoneyLooterTempData.LootedItems, lootedItem)
        CircularBuffer_Push(MoneyLooterDB.ListLootedItems, lootedItem)
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

---@param money integer
function SetOldMoney(money)
    if money ~= nil then
        MoneyLooterDB.OldMoney = money
    end
end

---@return integer
function GetTimer()
    return MoneyLooterDB.Timer or 0
end

---@return integer
function AddOneToTimer()
    MoneyLooterDB.Timer = (MoneyLooterDB.Timer or 0) + 1
    return MoneyLooterDB.Timer
end

---@return string
function GetCurrentStartText()
    return MoneyLooterDB.CurrentStartText or _G.MONEYLOOTER_L_START
end

---@param text string
---@return string
function SetCurrentStartText(text)
    if text ~= nil then
        MoneyLooterDB.CurrentStartText = text
    end
    return MoneyLooterDB.CurrentStartText or _G.MONEYLOOTER_L_START
end

---@return integer
function GetMinPrice1()
    return MoneyLooterXDB.MinPrice1 or 0
end

---@param money integer
function SetMinPrice1(money)
    MoneyLooterXDB.MinPrice1 = money
end

---@return integer
function GetMinPrice2()
    return MoneyLooterXDB.MinPrice2 or 0
end

---@param money integer
function SetMinPrice2(money)
    MoneyLooterXDB.MinPrice2 = money
end

---@return integer
function GetMinPrice3()
    return MoneyLooterXDB.MinPrice3 or 0
end

---@param money integer
function SetMinPrice3(money)
    MoneyLooterXDB.MinPrice3 = money
end

---@return integer
function GetMinPrice4()
    return MoneyLooterXDB.MinPrice4 or 0
end

---@param money integer
function SetMinPrice4(money)
    MoneyLooterXDB.MinPrice4 = money
end

---@param money integer
function SetAllMinPrices(money)
    MoneyLooterXDB.MinPrice1 = money
    MoneyLooterXDB.MinPrice2 = money
    MoneyLooterXDB.MinPrice3 = money
    MoneyLooterXDB.MinPrice4 = money
end

---@return string
function GetCurrentTSMString()
    return MoneyLooterXDB.CurrentTSMString or Constants.Strings.TSM_STRING
end

---@param tsmString string
function SetTSMString(tsmString)
    local TSM_API = TSM_API
    if TSM_API == nil then
        print(_G.MONEYLOOTER_L_TSM_NOT_AVAILABLE)
        return
    end
    if not TSM_API.IsCustomPriceValid(tsmString) then
        print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING_NOT_VALID .. tsmString)
        return
    end
    MoneyLooterXDB.CurrentTSMString = tsmString
    print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING_VALID .. tsmString)
end

---@return boolean
function IsScrollLootFrameVisible()
    return MoneyLooterDB.ScrollLootFrameVisible
end

---@param visible boolean
function SetScrollLootFrameVisible(visible)
    if visible ~= nil then
        MoneyLooterDB.ScrollLootFrameVisible = visible
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
    else
        table.wipe(MoneyLooterDB)
    end
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

---@param paused boolean
function SetInteractionPaused(paused)
    if paused ~= nil then
        MoneyLooterTempData.InteractionPaused = paused
    end
end
