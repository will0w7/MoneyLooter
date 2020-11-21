-- Author      : Will0w7
-- Core --
-- ML_FONT = "Fonts\\FRIZQT__.TTF"
local RECORD_LOOT = false
local MIN_PRICE = 10000000 -- (MIN_PRICE * 1000)
local oldmoney = GetMoney()
local lootedMoney = 0
local moneyFromItems = 0
-- local hex = ""
local lootedItems = {}
local UPDATE = false
local amount = 0
local TOTAL_MONEY = 0

local function OnMoneyLoot(self, event, ...)
    if event == "CHAT_MSG_MONEY" and RECORD_LOOT == true then
        local newmoney = GetMoney()
        local change = (newmoney - oldmoney)
        lootedMoney = lootedMoney + change
        TOTAL_MONEY = TOTAL_MONEY + change
        oldmoney = GetMoney()
    end
end

local function OnItemLoot(self, event, ...)
    if event == "CHAT_MSG_LOOT" and RECORD_LOOT == true then
        local p0 = ""
        local p1 = ""
        local lootstring, _, _, _, p2 = ...
        if lootstring == nil then return false end
        local itemLink = string.match(lootstring, "|%x+|Hitem:.-|h.-|h|r")
        if itemLink == nil then return false end
        local tsmItemString = TSM_API.ToItemString(itemLink)
        local itemString = string.match(itemLink, "item[%-?%d:]+")
        local itemName, _, quality, _, _, _, _, _, _, texture, sellPrice, _, _, _, _, _, isCraftingReagent = GetItemInfo(itemString)
        amount = string.match(lootstring, "x(%d+)%p") or 1
        if amount == nil then amount = 1 end
        -- _,_,_,hex = GetItemQualityColor(quality)
        p0,_ = GetUnitName("player")
        p1,_ = strsplit ('-', p2, 2)
        if (string.len(itemName) >30) then
            itemName = string.sub (itemName,1,30).."..."
        end
        -- itemName = "|c"..hex..itemName.."|r"
        local price = 0
        if p0 == p1 then
            if tsmItemString ~= nil then
                if quality > 1 then
                    if TSM_API ~= nil then
                        local tsm = TSM_API.GetCustomPriceValue("DBMarket", tsmItemString)
                        if tsm == nil then
                            price = sellPrice
                        else
                            if isCraftingReagent then
                                price = tsm
                            elseif price < MIN_PRICE then
                                price = sellPrice
                            else
                                price = tsm
                            end
                        end
                    end
                end
                if quality < 2 then
                    if TSM_API ~= nil then
                        local tsm = TSM_API.GetCustomPriceValue("DBMarket", tsmItemString)
                        price = sellPrice
                        if tsm ~= nil and isCraftingReagent then
                            price = tsm
                        end
                    end
                end
            end
                price = (price * amount)
                moneyFromItems = moneyFromItems + price
                local i = LootedItem.new(itemLink, price, amount)
                table.insert(lootedItems, i)
                UPDATE = true
                TOTAL_MONEY = TOTAL_MONEY + price
            end
        end
end

local moneyLoot = CreateFrame("Frame")
moneyLoot:RegisterEvent("CHAT_MSG_MONEY")
moneyLoot:SetScript("OnEvent", OnMoneyLoot)

local itemLoot = CreateFrame("Frame")
itemLoot:RegisterEvent("CHAT_MSG_LOOT")
itemLoot:SetScript("OnEvent", OnItemLoot)

-- Getters y setters
function GetLootedMoney()
    return lootedMoney
end

function GetMoneyFromItems()
    return moneyFromItems
end

function SET_RECORD_LOOT(status)
    RECORD_LOOT = status
end

function SetLootedMoney(val)
    lootedMoney = val
end

function SetMoneyFromItems(val)
    moneyFromItems = val
end

function SetOldMoney(val)
    oldmoney = val
end

function GetLootedItems()
    return lootedItems
end

function SetLootedItems(val)
    lootedItems = val
end

function GetUPDATE()
    return UPDATE
end

function SetUPDATE(val)
    UPDATE = val
end

function SetTOTAL_MONEY(val)
    TOTAL_MONEY = val
end

function GetTOTAL_MONEY()
    return TOTAL_MONEY
end