-- Author      : Will0w7
-- MoneyLooterConsts --

ML_STRINGS = {
    ML_ADDON_NAME = "MoneyLooter",
    ML_ADDON_VERSION = "",
    ML_TITLE = "|cFFd8de35MoneyLooter!|r",
    ML_FONT = "Fonts\\FRIZQT__.TTF",
    ML_TSM_STRING = "dbmarket"
}

ML_EVENTS = {
    OnEvent = "OnEvent",
    -------------------------------------
    OnDragStart = "OnDragStart",
    OnDragStop = "OnDragStop",
    OnHide = "OnHide",
    OnLoad = "OnLoad",
    OnEnter = "OnEnter",
    OnLeave = "OnLeave",
    OnLoop = "OnLoop",
    OnHyperLinkClick = "OnHyperlinkClick",
    OnHyperLinkEnter = "OnHyperlinkEnter",
    OnHyperLinkLeave = "OnHyperlinkLeave",
    OnClick = "OnClick",
    --------------------------------------
    ChatMsgMoney = "CHAT_MSG_MONEY",
    ChatMsgLoot = "CHAT_MSG_LOOT",
    MerchantUpdate = "MERCHANT_UPDATE",
    QuestTurnedIn = "QUEST_TURNED_IN",
    QuestLootReceived = "QUEST_LOOT_RECEIVED",
    AddonLoaded = "ADDON_LOADED",
}
-- Loot global patterns for self
-- string.match returns itemLink, quantity || itemLink
LOOT_PATTERNS_SELF = {
    LOOT_ITEM_SELF:gsub("%%s", "(.+)"),                                      -- 1
    LOOT_ITEM_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"),       -- 2
    LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)"),                               -- 1
    LOOT_ITEM_PUSHED_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)") -- 2
}

-- Loot global patterns for others
-- string.match returns playerName, itemLink, quantity || playerName, itemLink
LOOT_PATTERNS = {
    LOOT_ITEM:gsub("%%s", "(.+)"),                                      -- 2
    LOOT_ITEM_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"),       -- 3
    LOOT_ITEM_PUSHED:gsub("%%s", "(.+)"),                               -- 2
    LOOT_ITEM_PUSHED_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)") -- 3
}
