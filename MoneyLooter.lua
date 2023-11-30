-- Author      : Will0w7
-- Core --

-- local TSM_API = TSM_API
local AUCTIONATOR_API = Auctionator.API.v1

local oldmoney = GetMoney()
local amount = 0

-- Controla el evento de lootear dinero
local function OnMoneyLoot(self, event, ...)
    if event == "CHAT_MSG_MONEY" and GET_RECORD_LOOT() == true then
        local newmoney = GetMoney()
        local change = (newmoney - oldmoney)
        RAW_MONEY_ADD(change)
        TOTAL_MONEY_ADD(change)
        oldmoney = GetMoney()
    end
end

local function OnItemLoot(self, event, ...)
    if event == "CHAT_MSG_LOOT" and GET_RECORD_LOOT() == true then
        local p0 = ""
        local p1 = ""
        local lootstring, _, _, _, p2 = ...
        if lootstring == nil then return false end
        local itemLink = string.match(lootstring, "|%x+|Hitem:.-|h.-|h|r")
        if itemLink == nil then return false end
        -- local tsmItemString = TSM_API.ToItemString(itemLink)
        local itemString = string.match(itemLink, "item[%-?%d:]+")
        -- texture -> añadir icono al chat
        local itemName, _, quality, _, _, itemType, _, _, _, texture, sellPrice, _, _, _, _, _, isCraftingReagent =
            GetItemInfo(itemString)
        amount = string.match(lootstring, "x(%d+)%p") or 1
        if amount == nil then amount = 1 end

        p0, _ = GetUnitName("player")
        p1, _ = strsplit('-', p2, 2)
        if (string.len(itemName) > 30) then
            itemName = string.sub(itemName, 1, 30) .. "..."
        end
        -- itemName = "|c"..hex..itemName.."|r"
        local price = 0
        if p0 == p1 then
            -- if tsmItemString ~= nil then
            if quality < 1 then
                price = sellPrice
            elseif quality >= 1 then
                -- if TSM_API ~= nil then
                if AUCTIONATOR_API ~= nil then
                    local auc = AUCTIONATOR_API.GetAuctionPriceByItemLink("MoneyLooter", itemLink)
                    -- local tsm = TSM_API.GetCustomPriceValue("DBMarket", tsmItemString)
                    price = sellPrice
                    if auc ~= nil then --and (isCraftingReagent or itemType == "Trade Goods") then
                        price = auc
                    end
                end
                -- elseif quality > 1 then
                --     -- if TSM_API ~= nil then
                --     if AUCTIONATOR_API ~= nil then
                --         -- local tsm = TSM_API.GetCustomPriceValue("DBMarket", tsmItemString)
                --         local auc = AUCTIONATOR_API.GetAuctionPriceByItemLink("MoneyLooter", itemLink)
                --         if auc == nil then
                --             price = sellPrice
                --         else
                --             if isCraftingReagent or itemType == "Trade Goods" then
                --                 price = auc
                --             elseif price < GET_MIN_PRICE() and sellPrice * 1.25 < auc then
                --                 price = sellPrice
                --             else
                --                 price = auc
                --             end
                --         end
                --     end
            end
            price = (price * amount)
            ITEMS_MONEY_ADD(price)
            local i = LootedItem.new(itemLink, price, amount, texture)
            -- table.insert(lootedItems, i)
            LOOTED_ITEMS_INSERT(i)
            SET_UPDATE(true)
            -- TOTAL_MONEY = TOTAL_MONEY + price
            TOTAL_MONEY_ADD(price)
        end
    end
end

function OnSellAction(self, event, ...)
    if event == "MERCHANT_UPDATE" and GET_RECORD_LOOT() == true then
        oldmoney = GetMoney()
    end
end

local moneyLoot = CreateFrame("Frame")
moneyLoot:RegisterEvent("CHAT_MSG_MONEY")
moneyLoot:SetScript("OnEvent", OnMoneyLoot)

local itemLoot = CreateFrame("Frame")
itemLoot:RegisterEvent("CHAT_MSG_LOOT")
itemLoot:SetScript("OnEvent", OnItemLoot)

local sellAction = CreateFrame("Frame")
sellAction:RegisterEvent("PLAYER_MONEY")
sellAction:RegisterEvent("MERCHANT_UPDATE")
sellAction:SetScript("OnEvent", OnSellAction)

function SetOldMoney(val)
    oldmoney = val
end
