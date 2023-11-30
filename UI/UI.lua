-- Author      : Will0w7
-- Interface --

-- Hay que mover y cambiar las variables
ML_FONT = "Fonts\\FRIZQT__.TTF"
SLASH_ML1 = "/ml"

-- IsRunning = false
TimeOnStart = 0
Timer = 0
TimeSinceLastUpdate = 0
TimeSinceLastUpdateGPH = 0

-- Se crea el frame principal
local ML_UI = CreateFrame("Frame", "MoneyLooter", UIParent, BackdropTemplateMixin and "BackdropTemplate")
ML_UI:SetSize(170, 170)
ML_UI:SetPoint("CENTER")
-- Mixin(ML_UI, BackdropTemplateMixin)
ML_UI:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tileSize = 7,
    edgeSize = 8,
    insets = { left = 1, right = 1, top = 1, bottom = 1, },
})
ML_UI:SetBackdropColor(0, 0, 0, .5)
ML_UI:SetBackdropBorderColor(0, 0, 0)

-- Controla que se pueda mover el frame
ML_UI:EnableMouse(true)
ML_UI:SetMovable(true)
ML_UI:RegisterForDrag("LeftButton")

-- Boton de cerrar el frame
local close = CreateFrame("Button", "Close", ML_UI, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", ML_UI, "TOPRIGHT")

-- Boton de start/stop
local startstop = CreateFrame("Button", "Start/Stop", ML_UI, "UIPanelButtonTemplate")
startstop:SetPoint("BOTTOMLEFT", ML_UI, 5, 5)
startstop:SetSize(100, 20)
startstop:SetText("Start")
-- startstop:SetFont(ML_FONT, 12)
-- startstop.tooltipText = "Arranca y para la herramienta"

-- Boton de reset
local reset = CreateFrame("Button", "Reset", ML_UI, "UIPanelButtonTemplate")
reset:SetPoint("BOTTOMRIGHT", ML_UI, -5, 5)
reset:SetSize(50, 20)
reset:SetText("Reset")
-- reset:SetFont(ML_FONT, 12)
-- reset.tooltipText = "Resetea todos los datos"

-- Textos de la interfaz
local ml = ML_UI:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
ml:SetJustifyV("CENTER")
ml:SetJustifyH("CENTER")
ml:SetText("|cFFFF0000MoneyLooter!")
ml:SetPoint("TOP", ML_UI, -3, -8)
ml:SetFont(ML_FONT, 17, "")

local t = ML_UI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
t:SetJustifyV("CENTER")
t:SetJustifyH("CENTER")
t:SetText("Time:")
t:SetPoint("TOPLEFT", ML_UI, 5, -40)
t:SetFont(ML_FONT, 12, "")

local time = ML_UI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
time:SetJustifyV("CENTER")
time:SetJustifyH("CENTER")
time:SetText("00:00:00")
time:SetPoint("TOPRIGHT", ML_UI, -8, -40)
time:SetFont(ML_FONT, 12, "")

local g = ML_UI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
g:SetJustifyV("CENTER")
g:SetJustifyH("CENTER")
g:SetText("Gold:")
g:SetPoint("TOPLEFT", ML_UI, 5, -60)
g:SetFont(ML_FONT, 12, "")

local gold = ML_UI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
gold:SetJustifyV("CENTER")
gold:SetJustifyH("CENTER")
gold:SetText(GetCoinTextureString(0))
gold:SetPoint("TOPRIGHT", ML_UI, -8, -60)
gold:SetFont(ML_FONT, 12, "")

local i = ML_UI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
i:SetJustifyV("CENTER")
i:SetJustifyH("CENTER")
i:SetText("Items:")
i:SetPoint("TOPLEFT", ML_UI, 5, -80)
i:SetFont(ML_FONT, 12, "")

local item = ML_UI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
item:SetJustifyV("CENTER")
item:SetJustifyH("CENTER")
item:SetText(GetCoinTextureString(0))
item:SetPoint("TOPRIGHT", ML_UI, -8, -80)
item:SetFont(ML_FONT, 12, "")

local gph = ML_UI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
gph:SetJustifyV("CENTER")
gph:SetJustifyH("CENTER")
gph:SetText("GPH:")
gph:SetPoint("TOPLEFT", ML_UI, 5, -100)
gph:SetFont(ML_FONT, 12, "")

local GPH = ML_UI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
GPH:SetJustifyV("CENTER")
GPH:SetJustifyH("CENTER")
GPH:SetText(GetCoinTextureString(0))
GPH:SetPoint("TOPRIGHT", ML_UI, -8, -100)
GPH:SetFont(ML_FONT, 12, "")


-- Se crea el frame del loot
local loot = CreateFrame("ScrollingMessageFrame", "LootedItems", ML_UI, BackdropTemplateMixin and "BackdropTemplate")
-- loot:CreateFontString(nil, "OVERLAY", "GameFontNormal")
loot:CreateFontString(nil, nil, "GameFontNormal")
loot:SetSize(380, 170)
loot:SetPoint("RIGHT", 380, 0)
-- Mixin(loot, BackdropTemplateMixin)
loot:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tileSize = 7,
    edgeSize = 8,
    insets = { left = 1, right = 1, top = 1, bottom = 1, },
})
loot:SetBackdropColor(0, 0, 0, .5)
loot:SetBackdropBorderColor(0, 0, 0)
loot:SetMaxLines(14)
loot:SetFading(false)
loot:SetIndentedWordWrap(true)
-- loot:SetFontObject(ChatFontNormal) "Fonts\\FRIZQT__.TTF"
loot:SetFont(ML_FONT, 12, "")
-- loot:SetFont('Fonts\\FRIZQT__.TTF', 12)
loot:SetJustifyH("LEFT")
loot:EnableMouse(true)
loot:SetHyperlinksEnabled(true)
----------loot:SetInsertMode(SCROLLING_MESSAGE_FRAME_INSERT_MODE_BOTTOM)

-- Frames que controlan la actualizacion
ML_UPDATE_STARTSTOP = CreateFrame("Frame")
ML_UPDATE_LOOT = CreateFrame("Frame")
ML_UPDATE_GPH = CreateFrame("Frame")


-- Controla la actualizacion de los datos
function ML_UPDATE_STARTSTOP_OnUpdate(self, elapsed)
    TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
    if TimeSinceLastUpdate > 1.0 then
        if GET_IS_RUNNING() then
            time:SetText(date("!%X", Timer))
            Timer = Timer + 1
        end
        TimeSinceLastUpdate = 0
    end
    if GET_IS_RUNNING() then
        gold:SetText(GetCoinTextureString(GET_RAW_MONEY()))
        item:SetText(GetCoinTextureString(GET_ITEMS_MONEY()))
    end
end

-- Controla la actualizacion de loot de objetos
function ML_UPDATE_LOOT_OnUpdate(self, elapsed)
    if GET_IS_RUNNING() and GET_UPDATE() then
        local looted = GET_LOOTED_ITEMS()
        for n, v in ipairs(looted) do
            loot:AddMessage(v.amount .. "x" .. v.name .. " " .. GetCoinTextureString(v.value, 12))
        end
        SET_LOOTED_ITEMS({})
        SET_UPDATE(false)
    end
end

function ML_UPDATE_GPH_OnUpdate(self, elapsed)
    TimeSinceLastUpdateGPH = TimeSinceLastUpdateGPH + elapsed
    if TimeSinceLastUpdateGPH > 2.0 then
        if GET_IS_RUNNING() then
            local money = GET_TOTAL_MONEY()
            local perhour = 0
            if money > 0 then
                perhour = (money / Timer) * 3600
            end
            GPH:SetText(GetCoinTextureString(perhour))
        end
        TimeSinceLastUpdateGPH = 0
    end
end

-- Comandos de chat
local function slash(msg, editbox)
    if msg == "show" then
        ML_UI:Show()
    elseif msg == "hide" then
        ML_UI:Hide()
    else
        print("USAGE\n/ml help - Show the help\n/ml show - Show MoneyLooter\n/ml hide - Hide MoneyLooter")
    end
end
SlashCmdList["ML"] = slash


-- Registrar eventos
reset:SetScript("OnClick", function()
    TimeSinceLastUpdate = 0
    TimeSinceLastUpdateGPH = 0
    Timer = 0
    -- IsRunning = false
    SET_IS_RUNNING(false)
    -- SetLootedMoney(0)
    SET_RAW_MONEY(0)
    -- SetMoneyFromItems(0)
    SET_ITEMS_MONEY(0)
    startstop:SetText("Start")
    time:SetText("00:00:00")
    gold:SetText(GetCoinTextureString(0))
    item:SetText(GetCoinTextureString(0))
    GPH:SetText(GetCoinTextureString(0))
    SET_RECORD_LOOT(false)
    SetOldMoney(GetMoney())
    -- SetLootedItems({})
    SET_LOOTED_ITEMS({})
    -- SetTOTAL_MONEY(0)
    SET_TOTAL_MONEY(0)
    loot:Clear()
end)

startstop:SetScript("OnClick", function()
    if GET_IS_RUNNING() then
        SET_IS_RUNNING(false)
        startstop:SetText("Start")
        SET_RECORD_LOOT(false)
    else
        SET_IS_RUNNING(true)
        SetOldMoney(GetMoney())
        startstop:SetText("Stop")
        SET_RECORD_LOOT(true)
    end
end)

close:SetScript("OnClick", function()
    ML_UI:Hide(); print("/ml show to show MoneyLooter");
end)

ML_UPDATE_STARTSTOP:SetScript("OnLoad", function()
    TimeSinceLastUpdate = 0
    TimeSinceLastUpdateGPH = 0
end)

ML_UI:SetScript("OnDragStart", ML_UI.StartMoving)
ML_UI:SetScript("OnDragStop", ML_UI.StopMovingOrSizing)
ML_UI:SetScript("OnHide", ML_UI.StopMovingOrSizing)
ML_UPDATE_LOOT:SetScript("OnUpdate", ML_UPDATE_LOOT_OnUpdate)
ML_UPDATE_STARTSTOP:SetScript("OnUpdate", ML_UPDATE_STARTSTOP_OnUpdate)
ML_UPDATE_GPH:SetScript("OnUpdate", ML_UPDATE_GPH_OnUpdate)

loot:SetScript("OnHyperlinkClick", function(ML_UI, link, text)
    SetItemRef(link, text);
end)
loot:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
loot:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)

-- Oculto por defecto
ML_UI:Hide()
