---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@type string
local addonName = select(1, ...)

---@class ML_Constants
---@field PATTERNS_SELF table
---@field PATTERNS_CRAFT table
---@field PATTERNS_RECEIVED table
---@field RelevantInteractions table
local Constants = {}
MoneyLooter.Constants = Constants

---@class ML_Constants_Strings
Constants.Strings = {
    ADDON_NAME = addonName,
    ADDON_VERSION = "",
    TITLE = "MoneyLooter",
    FONT = "GameFontHighlight",
    TSM_STRING = "dbmarket"
}

---@class ML_Constants_Events
Constants.Events = {
    OnEvent = "OnEvent",
    -------------------------------------
    OnDragStart = "OnDragStart",
    OnDragStop = "OnDragStop",
    OnHide = "OnHide",
    OnLoad = "OnLoad",
    OnEnter = "OnEnter",
    OnLeave = "OnLeave",
    OnLoop = "OnLoop",
    OnClick = "OnClick",
    --------------------------------------
    ChatMsgMoney = "CHAT_MSG_MONEY",
    ChatMsgLoot = "CHAT_MSG_LOOT",
    QuestTurnedIn = "QUEST_TURNED_IN",
    AddonLoaded = "ADDON_LOADED",
    PlayerEnteringWorld = "PLAYER_ENTERING_WORLD",
    --------------------------------------
    PInteractionManagerShow = "PLAYER_INTERACTION_MANAGER_FRAME_SHOW",
    PInteractionManagerHide = "PLAYER_INTERACTION_MANAGER_FRAME_HIDE",
    --------------------------------------
    ChatMsgSystem = "CHAT_MSG_SYSTEM"
}

-- Loot global patterns for self
-- string.match returns itemLink, quantity || itemLink
Constants.PATTERNS_SELF = {
    [1] = LOOT_ITEM_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"),        -- 2
    [2] = LOOT_ITEM_PUSHED_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"), -- 2
    [3] = LOOT_ITEM_SELF:gsub("%%s", "(.+)"),                                       -- 1
    [4] = LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)")                                 -- 1
}

-- Crafted global patterns for self
-- string.match returns itemLink, quantity || itemLink
Constants.PATTERNS_CRAFT = {
    [1] = LOOT_ITEM_CREATED_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"), -- 2
    [2] = LOOT_ITEM_CREATED_SELF:gsub("%%s", "(.+)")                                 -- 1
}

Constants.PATTERNS_RECEIVED = {
    [1] = ERR_QUEST_REWARD_MONEY_S:gsub("%%s", "(.+)")
}

Constants.RelevantInteractions = {
    [Enum.PlayerInteractionType.MailInfo] = true,
    [Enum.PlayerInteractionType.Merchant] = true,
    [Enum.PlayerInteractionType.Banker] = true,
    [Enum.PlayerInteractionType.GuildBanker] = true,
    [Enum.PlayerInteractionType.BlackMarketAuctioneer] = true,
    [Enum.PlayerInteractionType.VoidStorageBanker] = true,
    [Enum.PlayerInteractionType.Auctioneer] = true,
    [Enum.PlayerInteractionType.Transmogrifier] = true
}

if MoneyLooter.isRetail then
    Constants.RelevantInteractions[Enum.PlayerInteractionType.AccountBanker] = true
    Constants.RelevantInteractions[Enum.PlayerInteractionType.CharacterBanker] = true
end
