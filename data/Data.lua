---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Utils
local Utils = MoneyLooter.Utils
---@class ML_Constants
local Constants = MoneyLooter.Constants
---@class ML_CircularBuffer
local CircularBuffer = MoneyLooter.CircularBuffer
---@class ML_CBFunctions
local CBFunctions = MoneyLooter.CBFunctions
---@class ML_Summary
local Summary = MoneyLooter.Summary
---@class ML_SMFunctions
local SMFunctions = MoneyLooter.SMFunctions

---@class ML_Data
local Data = {}
MoneyLooter.Data = Data

local CBCapacity = 100
Data.CBCapacity = CBCapacity

Data.DB = {}

---@class ML_DB
---@field CurrentStartText string
Data.DB.prototype = {
    Visible = true,
    ScrollLootFrameVisible = true,
    ----------------------------------------------
    Running = false,
    ----------------------------------------------
    OldMoney = 0,
    RawMoney = 0,
    ItemsMoney = 0,
    TotalMoney = 0,
    EMA_GPH = 0,
    Priciest = 0,
    PriciestLink = "",
    ListLootedItems = CircularBuffer,
    Summary = Summary,
    ----------------------------------------------
    Timer = 0,
    ----------------------------------------------
    CurrentStartText = _G.MONEYLOOTER_L_START,
    ----------------------------------------------
    ForceVendorPrice = false
}

Data.DB.mt = {}

Data.DB.mt.__index = function(_, key)
    return Data.DB.prototype[key]
end

local function initialize_db()
    if not MoneyLooterDB then
        ---@class ML_DB
        MoneyLooterDB = {}
    end
    if getmetatable(MoneyLooterDB) then
        setmetatable(MoneyLooterDB, nil)
    end
    setmetatable(MoneyLooterDB, Data.DB.mt)
end

Data.XDB = {}

---@class ML_CrossDB
Data.XDB.prototype = {
    CurrentTSMString = "dbmarket",
    ------------------------------
    MinPrice1 = 0,
    MinPrice2 = 0,
    MinPrice3 = 0,
    MinPrice4 = 0,
}

Data.XDB.mt = {}

Data.XDB.mt.__index = function(_, key)
    return Data.XDB.prototype[key]
end

local function initialize_xdb()
    if not MoneyLooterXDB then
        MoneyLooterXDB = {}
    end
    if getmetatable(MoneyLooterXDB) then
        setmetatable(MoneyLooterXDB, nil)
    end
    setmetatable(MoneyLooterXDB, Data.XDB.mt)
end

---@class ML_TempData
local MoneyLooterTempData = {
    InteractionPaused = false,
    SummaryMode = false
}

---@return boolean
function Data.IsVisible()
    return MoneyLooterDB.Visible
end

---@param visible boolean
function Data.SetVisible(visible)
    if visible ~= nil then
        MoneyLooterDB.Visible = visible
    end
end

---@return boolean
function Data.IsRunning()
    return MoneyLooterDB.Running
end

---@param running boolean
function Data.SetRunning(running)
    if running ~= nil then
        MoneyLooterDB.Running = running
    end
end

---@return integer
function Data.GetRawMoney()
    return MoneyLooterDB.RawMoney
end

---@param money integer
function Data.AddRawMoney(money)
    if money ~= nil then
        MoneyLooterDB.RawMoney = MoneyLooterDB.RawMoney + money
    end
end

---@return integer
function Data.GetItemsMoney()
    return MoneyLooterDB.ItemsMoney
end

---@param money integer
function Data.AddItemsMoney(money)
    if money ~= nil then
        MoneyLooterDB.ItemsMoney = MoneyLooterDB.ItemsMoney + money
    end
end

---@param money integer
function Data.AddTotalMoney(money)
    if money ~= nil then
        MoneyLooterDB.TotalMoney = MoneyLooterDB.TotalMoney + money
    end
end

---@return integer
function Data.GetPriciest()
    return MoneyLooterDB.Priciest
end

---@param itemLink string
---@param money integer
function Data.SetPriciest(money, itemLink)
    if money ~= nil and money > MoneyLooterDB.Priciest then
        MoneyLooterDB.Priciest = money
        MoneyLooterDB.PriciestLink = itemLink
    end
end

---@return string
function Data.GetPriciestLink()
    return MoneyLooterDB.PriciestLink
end

function Data.InitListLootedItems()
    if MoneyLooterDB.ListLootedItems == nil or MoneyLooterDB.ListLootedItems.buffer == nil then
        MoneyLooterDB.ListLootedItems = CBFunctions.New(MoneyLooterDB.ListLootedItems, Data.CBCapacity)
    end
end

---@return ML_CircularBuffer
function Data.GetListLootedItems()
    return MoneyLooterDB.ListLootedItems
end

---@param lootedItem ML_Item
function Data.InsertLootedItem(lootedItem)
    if lootedItem == nil then return end
    CBFunctions.Push(MoneyLooterDB.ListLootedItems, lootedItem)
end

---@return integer
function Data.GetListLootedItemsCount()
    return CBFunctions.GetSize(MoneyLooterDB.ListLootedItems)
end

---@return integer
function Data.GetOldMoney()
    return MoneyLooterDB.OldMoney
end

---@param money integer
function Data.SetOldMoney(money)
    if money ~= nil then
        MoneyLooterDB.OldMoney = money
    end
end

---@return integer
function Data.GetTimer()
    return MoneyLooterDB.Timer
end

---@return integer
function Data.AddOneToTimer()
    MoneyLooterDB.Timer = MoneyLooterDB.Timer + 1
    return MoneyLooterDB.Timer
end

---@return string
function Data.GetCurrentStartText()
    return MoneyLooterDB.CurrentStartText
end

---@param text string
---@return string
function Data.SetCurrentStartText(text)
    if text ~= nil then
        MoneyLooterDB.CurrentStartText = text
    end
    return MoneyLooterDB.CurrentStartText
end

---@return integer
function Data.GetMinPrice1()
    return MoneyLooterXDB.MinPrice1
end

---@param money integer
function Data.SetMinPrice1(money)
    MoneyLooterXDB.MinPrice1 = money
end

---@return integer
function Data.GetMinPrice2()
    return MoneyLooterXDB.MinPrice2
end

---@param money integer
function Data.SetMinPrice2(money)
    MoneyLooterXDB.MinPrice2 = money
end

---@return integer
function Data.GetMinPrice3()
    return MoneyLooterXDB.MinPrice3
end

---@param money integer
function Data.SetMinPrice3(money)
    MoneyLooterXDB.MinPrice3 = money
end

---@return integer
function Data.GetMinPrice4()
    return MoneyLooterXDB.MinPrice4
end

---@param money integer
function Data.SetMinPrice4(money)
    MoneyLooterXDB.MinPrice4 = money
end

---@param money integer
function Data.SetAllMinPrices(money)
    MoneyLooterXDB.MinPrice1 = money
    MoneyLooterXDB.MinPrice2 = money
    MoneyLooterXDB.MinPrice3 = money
    MoneyLooterXDB.MinPrice4 = money
end

---@return string
function Data.GetCurrentTSMString()
    return MoneyLooterXDB.CurrentTSMString
end

---@param tsmString string
function Data.SetTSMString(tsmString)
    local TSM_API = TSM_API
    if TSM_API == nil then
        print(_G.MONEYLOOTER_L_TSM_NOT_AVAILABLE)
        return
    end
    if not TSM_API.IsCustomPriceValid(tsmString) then
        print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING_NOT_VALID .. "|cFF36e8e6" .. tsmString .. "|r")
        return
    end
    MoneyLooterXDB.CurrentTSMString = tsmString
    print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING_VALID .. "|cFF36e8e6" .. tsmString .. "|r")
end

---@return boolean
function Data.IsScrollLootFrameVisible()
    return MoneyLooterDB.ScrollLootFrameVisible
end

---@param visible boolean
function Data.SetScrollLootFrameVisible(visible)
    if visible ~= nil then
        MoneyLooterDB.ScrollLootFrameVisible = visible
    end
end

--- Calculates GPH using an EMA (Exponential Moving Average) with an adaptive alpha.
--- Alpha ramps up from 0 to 0.1 over the first 30s to prevent early spikes.
---@return integer
function Data.CalcGPH()
    local total = MoneyLooterDB.TotalMoney
    local timer = MoneyLooterDB.Timer

    local base_alpha = 0.1
    local warmup_seconds = 30
    local alpha = base_alpha * math.min(1, timer / warmup_seconds)

    local current_rate = 0
    if total > 0 and timer > 0 then
        current_rate = (total / timer) * 3600
    end

    if not MoneyLooterDB.EMA_GPH then
        MoneyLooterDB.EMA_GPH = 0
    end

    MoneyLooterDB.EMA_GPH = alpha * current_rate + (1 - alpha) * MoneyLooterDB.EMA_GPH
    return math.floor(MoneyLooterDB.EMA_GPH)
end

function Data.ResetMoneyLooterDB()
    if MoneyLooterDB == nil then
        MoneyLooterDB = {}
    else
        table.wipe(MoneyLooterDB)
    end
    initialize_db()
    MoneyLooterDB.ListLootedItems = CBFunctions.New(MoneyLooterDB.ListLootedItems, Data.CBCapacity)
end

function Data.UpdateMLDB()
    initialize_db()
end

function Data.UpdateMLXDB()
    initialize_xdb()
end

---@return boolean
function Data.IsInteractionPaused()
    return MoneyLooterTempData.InteractionPaused
end

---@param paused boolean
function Data.SetInteractionPaused(paused)
    if paused == nil then return end
    MoneyLooterTempData.InteractionPaused = paused
end

function Data.IsSummaryMode()
    return MoneyLooterTempData.SummaryMode
end

function Data.SetSummaryMode(summaryMode)
    if summaryMode == nil then return end
    MoneyLooterTempData.SummaryMode = summaryMode
end

---@param lootedItem ML_Item
function Data.InsertSummaryItem(lootedItem)
    if MoneyLooterDB.Summary == nil then MoneyLooterDB.Summary = {} end
    if lootedItem == nil then return end
    MoneyLooterDB.Summary = SMFunctions.InsertLootedItem(MoneyLooterDB.Summary, lootedItem)
end

function Data.GetSummary()
    if MoneyLooterDB.Summary == nil then
        MoneyLooterDB.Summary = {}
    end
    return MoneyLooterDB.Summary
end

---@return boolean State_ForceVendorPrice
function Data.ToggleForceVendorPrice()
    MoneyLooterDB.ForceVendorPrice = not MoneyLooterDB.ForceVendorPrice
    return MoneyLooterDB.ForceVendorPrice
end

---@return boolean ForceVendorPrice
function Data.GetForceVendorPrice()
    return MoneyLooterDB.ForceVendorPrice
end

---@param force boolean
function Data.SetForceVendorPrice(force)
    MoneyLooterDB.ForceVendorPrice = force
end
