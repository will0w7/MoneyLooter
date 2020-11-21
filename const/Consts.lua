local VISIBLE = true

local RECORD_LOOT = false
local UPDATE = false
local IS_RUNNING = false

local MIN_PRICE = 10000000  -- (MIN_PRICE * 10000) // GOLD * 10000

local RAW_MONEY = 0
local ITEMS_MONEY = 0
local TOTAL_MONEY = 0
local LOOTED_ITEMS = {}

-- VISIBLE
function GET_VISIBLE()
    return VISIBLE
end

function SET_VISIBLE(val)
    VISIBLE = true
    if val ~= nil then
        VISIBLE = val
    end
end

-- RECORD_LOOT
function GET_RECORD_LOOT()
    return RECORD_LOOT
end

function SET_RECORD_LOOT(val)
    RECORD_LOOT = false
    if val ~= nil then
        RECORD_LOOT = val
    end
end

-- UPDATE
function GET_UPDATE()
    return UPDATE
end

function SET_UPDATE(val)
    UPDATE = false
    if val ~= nil then
        UPDATE = val
    end
end

-- IS_RUNNING
function GET_IS_RUNNING()
    return IS_RUNNING
end

function SET_IS_RUNNING(val)
    IS_RUNNING = false
    if val ~= nil then
        IS_RUNNING = val
    end
end

-- MIN_PRICE
function GET_MIN_PRICE()
    return MIN_PRICE
end

function SET_MIN_PRICE(val)
    MIN_PRICE = 0
    if val ~= nil then
        MIN_PRICE = (val * 10000)
    end
end

-- RAW_MONEY
function GET_RAW_MONEY()
    return RAW_MONEY
end

function SET_RAW_MONEY(val)
    RAW_MONEY = 0
    if val ~= nil then
        RAW_MONEY = val
    end
end

function RAW_MONEY_ADD(val)
    if val ~= nil then
        RAW_MONEY = RAW_MONEY + val
    else
        return false
    end
end

-- ITEMS_MONEY
function GET_ITEMS_MONEY()
    return ITEMS_MONEY
end

function SET_ITEMS_MONEY(val)
    ITEMS_MONEY = 0
    if val ~= nil then
        ITEMS_MONEY = val
    end
end

function ITEMS_MONEY_ADD(val)
    if val ~= nil then
        ITEMS_MONEY = ITEMS_MONEY + val
    else
        return false
    end
end

-- TOTAL_MONEY
function GET_TOTAL_MONEY()
    return TOTAL_MONEY
end

function SET_TOTAL_MONEY(val)
    TOTAL_MONEY = 0
    if val ~= nil then
        TOTAL_MONEY = val
    end
end

function TOTAL_MONEY_ADD(val)
    if val ~= nil then
        TOTAL_MONEY = TOTAL_MONEY + val
    else
        return false
    end
end

-- LOOTED_ITEMS
function GET_LOOTED_ITEMS()
    return LOOTED_ITEMS
end

function SET_LOOTED_ITEMS(val)
    LOOTED_ITEMS = {}
    if val ~= nil then
        LOOTED_ITEMS = val
    end
end

function LOOTED_ITEMS_INSERT(val)
    if val ~= nil then
        table.insert(LOOTED_ITEMS, val)
    else
        return false
    end
end
    