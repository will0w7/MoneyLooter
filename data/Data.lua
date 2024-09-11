---@class MoneyLooter
local MoneyLooter = select(2, ...)

local Constants = MoneyLooter.Constants
local CircularBuffer = MoneyLooter.CircularBuffer

local BufferCapacity = 20

---@class ML_DefaultDB
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
    LootedItems = {},
    ListLootedItems = CircularBuffer,
    OldMoney = 0,
    ----------------------------------------------
    Timer = 0,
    ----------------------------------------------
    CurrentStartText = _G.MONEYLOOTER_L_START,
    CurrentTimeText = tostring(date("!%X", 0)),
    ----------------------------------------------
    DBVersion = 1725868670195
}

---@class ML_DB
---@field ListLootedItems ML_CircularBuffer
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

function IsVisible()
    return MoneyLooterDB.Visible
end

function SetVisible(val)
    if val ~= nil then
        MoneyLooterDB.Visible = val
    end
end

function IsRunning()
    return MoneyLooterDB.Running
end

function SetRunning(val)
    if val ~= nil then
        MoneyLooterDB.Running = val
    end
end

function GetRawGold()
    return MoneyLooterDB.RawGold or 0
end

function SetRawGold(val)
    MoneyLooterDB.RawGold = 0
    if val ~= nil then
        MoneyLooterDB.RawGold = val
    end
end

function AddRawGold(val)
    if val ~= nil then
        MoneyLooterDB.RawGold = MoneyLooterDB.RawGold + val
    else
        return false
    end
end

function GetItemsMoney()
    return MoneyLooterDB.ItemsMoney or 0
end

function SetItemsMoney(val)
    MoneyLooterDB.ItemsMoney = 0
    if val ~= nil then
        MoneyLooterDB.ItemsMoney = val
    end
end

function AddItemsMoney(val)
    if val ~= nil then
        MoneyLooterDB.ItemsMoney = MoneyLooterDB.ItemsMoney + val
    end
end

function GetTotalMoney()
    return MoneyLooterDB.TotalMoney or 0
end

function AddTotalMoney(val)
    if val ~= nil then
        MoneyLooterDB.TotalMoney = MoneyLooterDB.TotalMoney + val
    end
end

function GetPriciest()
    return MoneyLooterDB.Priciest or 0
end

function SetPriciest(val, id)
    if val ~= nil and val > (MoneyLooterDB.Priciest or 0) then
        MoneyLooterDB.Priciest = val
        MoneyLooterDB.PriciestID = id
    end
end

function GetPriciestID()
    return MoneyLooterDB.PriciestID or 0
end

function GetLootedItems()
    return MoneyLooterDB.LootedItems or {}
end

function SetLootedItems(val)
    if val ~= nil then
        MoneyLooterDB.LootedItems = val
    end
end

function InitListLootedItems()
    if MoneyLooterDB.ListLootedItems == nil or MoneyLooterDB.ListLootedItems.buffer == nil then
        MoneyLooterDB.ListLootedItems = CircularBuffer_New(MoneyLooterDB.ListLootedItems, BufferCapacity)
    end
end

function GetListLootedItems()
    return MoneyLooterDB.ListLootedItems
end

function AddListLootedItems(val)
    CircularBuffer_Push(MoneyLooterDB.ListLootedItems, val)
end

function InsertLootedItem(val)
    if MoneyLooterDB.LootedItems == nil then MoneyLooterDB.LootedItems = {} end
    if val ~= nil then
        table.insert(MoneyLooterDB.LootedItems, val)
        AddListLootedItems(val)
    end
end

function GetListLootedItemsCount()
    return CircularBuffer_GetSize(MoneyLooterDB.ListLootedItems)
end

function GetOldMoney()
    return MoneyLooterDB.OldMoney or 0
end

function SetOldMoney(val)
    if val ~= nil then
        MoneyLooterDB.OldMoney = val
    end
end

function GetTimer()
    return MoneyLooterDB.Timer or 0
end

function AddOneToTimer()
    MoneyLooterDB.Timer = (MoneyLooterDB.Timer or 0) + 1
end

function SetTimer(val)
    if val ~= nil then
        MoneyLooterDB.Timer = val
    end
end

function GetCurrentStartStopText()
    return MoneyLooterDB.CurrentStartStopText or _G.MONEYLOOTER_L_START
end

function SetCurrentStartStopText(val)
    if val ~= nil then
        MoneyLooterDB.CurrentStartStopText = val
    end
    return MoneyLooterDB.CurrentStartStopText or _G.MONEYLOOTER_L_START
end

function GetCurrentTimeText()
    return MoneyLooterDB.CurrentTimeText or tostring(date("!%X", 0))
end

function GetMinPrice1()
    return MoneyLooterXDB.MinPrice1 or 0
end

function SetMinPrice1(val)
    MoneyLooterXDB.MinPrice1 = val
end

function GetMinPrice2()
    return MoneyLooterXDB.MinPrice2 or 0
end

function SetMinPrice2(val)
    MoneyLooterXDB.MinPrice2 = val
end

function GetMinPrice3()
    return MoneyLooterXDB.MinPrice3 or 0
end

function SetMinPrice3(val)
    MoneyLooterXDB.MinPrice3 = val
end

function GetMinPrice4()
    return MoneyLooterXDB.MinPrice4 or 0
end

function SetMinPrice4(val)
    MoneyLooterXDB.MinPrice4 = val
end

function SetAllMinPrices(val)
    MoneyLooterXDB.MinPrice1 = val
    MoneyLooterXDB.MinPrice2 = val
    MoneyLooterXDB.MinPrice3 = val
    MoneyLooterXDB.MinPrice4 = val
end

function GetCurrentTSMString()
    return MoneyLooterXDB.CurrentTSMString or Constants.Strings.TSM_STRING
end

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

function IsScrollLootFrameVisible()
    return MoneyLooterDB.ScrollLootFrameVisible
end

function SetScrollLootFrameVisible(val)
    if val ~= nil then
        MoneyLooterDB.ScrollLootFrameVisible = val
    end
end

function SetCurrentTimeText(val)
    if val ~= nil then
        MoneyLooterDB.CurrentTimeText = val
    end
    return MoneyLooterDB.CurrentTimeText or tostring(date("!%X", 0))
end

function CalcGPH()
    local perhour = 0
    local total = GetTotalMoney()
    if total > 0 and GetTimer() > 0 then
        perhour = (total / MoneyLooterDB.Timer) * 3600
    end
    return perhour
end

function ResetMoneyLooterDB()
    MoneyLooterDB = table.wipe(MoneyLooterDB)
    MoneyLooterDB = table.deep_copy_meta(DefaultMoneyLooterDB)
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
