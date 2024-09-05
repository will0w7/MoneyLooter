-- Author      : Will0w7
-- MoneyLooterData --

ML_STRINGS = {
    ML_ADDON_NAME = "MoneyLooter",
    ML_ADDON_VERSION = 0.80,
    ML_TITLE = "|cFFd8de35MoneyLooter!|r",
    ML_FONT = "Fonts\\FRIZQT__.TTF",
    ML_TSM_STRING = "DBMarket"
}

ML_EVENTS = {
    OnEvent = "OnEvent",
    -------------------------------------
    OnDragStart = "OnDragStart",
    OnDragStop = "OnDragStop",
    OnHide = "OnHide",
    OnUpdate = "OnUpdate",
    OnLoad = "OnLoad",
    OnEnter = "OnEnter",
    OnLeave = "OnLeave",
    OnHyperLinkClick = "OnHyperlinkClick",
    OnHyperLinkEnter = "OnHyperlinkEnter",
    OnHyperLinkLeave = "OnHyperlinkLeave",
    OnClick = "OnClick",
    --------------------------------------
    ChatMsgMoney = "CHAT_MSG_MONEY",
    ChatMsgLoot = "CHAT_MSG_LOOT",
    PlayerMoney = "PLAYER_MONEY",
    MerchantUpdate = "MERCHANT_UPDATE",
    AddonLoaded = "ADDON_LOADED",
    VariablesLoaded = "VARIABLES_LOADED",
    PlayerLogout = "PLAYER_LOGOUT"
}

DefaultMoneyLooterDB = {
    Visible = true,
    RecordLoot = false,
    Update = false,
    Running = false,
    RawGold = 0,
    ItemsMoney = 0,
    TotalMoney = 0,
    Priciest = 0,
    PriciestID = nil,
    LootedItems = {},
    ListLootedItems = {},
    ListLootedItemsCount = 0,
    OldMoney = 0,
    ----------------------------------------------
    TimeSinceLastUpdate = 0,
    TimeSinceLastUpdateGPH = 0,
    Timer = 0,
    ----------------------------------------------
    CurrentStartStopText = _G.MONEYLOOTER_L_START,
    CurrentTimeText = date("!%X", 0),
    ----------------------------------------------
    MinPrice1 = 10000 * 1,
    MinPrice2 = 10000 * 1000,
    MinPrice3 = 10000 * 1000,
    MinPrice4 = 10000 * 1000,
    ----------------------------------------------
    CurrentTSMString = "DBMarket"
}

MoneyLooterDB = table.ShallowCopy(DefaultMoneyLooterDB)

function IsVisible()
    return MoneyLooterDB.Visible or true
end

function SetVisible(val)
    if val ~= nil then
        MoneyLooterDB.Visible = val
        if val then
            MoneyLooterMainUIFrame:Show()
        else
            MoneyLooterMainUIFrame:Hide()
        end
    end
end

function GetRecordLoot()
    return MoneyLooterDB.RecordLoot or false
end

function SetRecordLoot(val)
    MoneyLooterDB.RecordLoot = false
    if val ~= nil then
        MoneyLooterDB.RecordLoot = val
    end
end

function GetUpdate()
    return MoneyLooterDB.Update or false
end

function SetUpdate(val)
    MoneyLooterDB.Update = false
    if val ~= nil then
        MoneyLooterDB.Update = val
    end
end

function IsRunning()
    return MoneyLooterDB.Running or false
end

function SetRunning(val)
    MoneyLooterDB.Running = false
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

function SetTotalMoney(val)
    MoneyLooterDB.TotalMoney = 0
    if val ~= nil then
        MoneyLooterDB.TotalMoney = val
    end
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
    MoneyLooterDB.LootedItems = {}
    if val ~= nil then
        MoneyLooterDB.LootedItems = val
    end
end

function GetListLootedItems()
    return MoneyLooterDB.ListLootedItems or {}
end

function AddListLootedItems(val)
    if MoneyLooterDB.ListLootedItems == nil then MoneyLooterDB.ListLootedItems = {} end
    if val ~= nil then
        table.insert(MoneyLooterDB.ListLootedItems, val)
        MoneyLooterDB.ListLootedItemsCount = (MoneyLooterDB.ListLootedItemsCount or 0) + 1
    end
    if MoneyLooterDB.ListLootedItemsCount > 20 then
        table.remove(MoneyLooterDB.ListLootedItems, 1)
        MoneyLooterDB.ListLootedItemsCount = MoneyLooterDB.ListLootedItemsCount - 1
    end
end

function InsertLootedItem(val)
    if MoneyLooterDB.LootedItems == nil then MoneyLooterDB.LootedItems = {} end
    if val ~= nil then
        table.insert(MoneyLooterDB.LootedItems, val)
        AddListLootedItems(val)
    end
end

function GetListLootedItemsCount()
    return MoneyLooterDB.ListLootedItemsCount or 0
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

function GetTimeSinceLastUpdate()
    return MoneyLooterDB.TimeSinceLastUpdate or 0
end

function AddTimeSinceLastUpdate(val)
    local totalTime = (MoneyLooterDB.TimeSinceLastUpdate or 0) + val
    MoneyLooterDB.TimeSinceLastUpdate = totalTime
    return totalTime
end

function SetTimeSinceLastUpdate(val)
    if val ~= nil then
        MoneyLooterDB.TimeSinceLastUpdate = val
    end
end

function GetTimeSinceLastUpdateGPH()
    return MoneyLooterDB.TimeSinceLastUpdateGPH or 0
end

function AddTimeSinceLastUpdateGPH(val)
    local totalTime = (MoneyLooterDB.TimeSinceLastUpdateGPH or 0) + val
    MoneyLooterDB.TimeSinceLastUpdateGPH = totalTime
    return totalTime
end

function SetTimeSinceLastUpdateGPH(val)
    if val ~= nil then
        MoneyLooterDB.TimeSinceLastUpdateGPH = val
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
    return MoneyLooterDB.CurrentTimeText or date("!%X", 0)
end

function GetMinPrice1()
    return MoneyLooterDB.MinPrice1 or 0
end

function GetMinPrice2()
    return MoneyLooterDB.MinPrice2 or 0
end

function GetMinPrice3()
    return MoneyLooterDB.MinPrice3 or 0
end

function GetMinPrice4()
    return MoneyLooterDB.MinPrice4 or 0
end

function GetCurrentTSMString()
    return MoneyLooterDB.CurrentTSMString or ML_STRINGS.ML_TSM_STRING
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
    MoneyLooterDB.CurrentTSMString = val
    print(_G.MONEYLOOTER_L_TSM_CUSTOM_STRING_VALID .. val)
end

function SetCurrentTimeText(val)
    if val ~= nil then
        MoneyLooterDB.CurrentTimeText = val
    end
    return MoneyLooterDB.CurrentTimeText or date("!%X", 0)
end

function CalcGPH()
    local perhour = 0
    if MoneyLooterDB.TotalMoney > 0 and MoneyLooterDB.Timer > 0 then
        perhour = (MoneyLooterDB.TotalMoney / MoneyLooterDB.Timer) * 3600
    end
    return perhour
end

function ResetMoneyLooterDB()
    MoneyLooterDB = table.ShallowCopy(DefaultMoneyLooterDB)
end
