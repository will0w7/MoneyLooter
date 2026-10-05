---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@type string
local addonName = select(1, ...)

---@class ML_Constants
---@field PatternsSelf table
---@field PatternsCraft table
---@field PatternsReceived table
---@field RelevantInteractions table
local Constants = {}
MoneyLooter.Constants = Constants

---@class ML_Constants_Strings
Constants.Strings = {
    AddonName = addonName,
    AddonVersion = "",
    Title = "MoneyLooter",
    Font = "GameFontHighlight",
    TSMString = "dbmarket",
    TSMDisenchantString = "destroy"
}

---@class ML_Constants_Events
Constants.Events = {
    OnEvent = "OnEvent",
    -------------------------------------
    OnDragStart = "OnDragStart",
    OnDragStop = "OnDragStop",
    OnHide = "OnHide",
    OnShow = "OnShow",
    OnLoad = "OnLoad",
    OnEnter = "OnEnter",
    OnLeave = "OnLeave",
    OnLoop = "OnLoop",
    OnClick = "OnClick",
    OnMouseDown = "OnMouseDown",
    OnMouseUp = "OnMouseUp",
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

---@class ML_Constants_Inputs
Constants.Inputs = {
    LeftButton = "LeftButton",
    RightButton = "RightButton"
}

---@class ML_Constants_UIScale
Constants.UIScale = {
    Min = 0.5,
    Max = 2,
    Step = 0.1
}

---@class ML_Constants_ItemQualities
Constants.ItemQuality = {
    Poor = 0,
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Epic = 4,
    Min = 0,               -- poor
    Max = 4,               -- epic
    DisenchantableMin = 2, -- uncommon
    DisenchantableMax = 4  -- epic
}

---@class ML_Constants_DoNotDisenchant
Constants.NotDisenchantable = {
    BodyType = Enum.InventoryType.IndexBodyType,    -- shirts
    TabardType = Enum.InventoryType.IndexTabardType -- tabards
}

---@class ML_Constants_ItemClass
Constants.ItemClass = {
    Weapon = Enum.ItemClass.Weapon,
    Armor = Enum.ItemClass.Armor,
    Reagent = Enum.ItemClass.Reagent,
    Quest = Enum.ItemClass.Questitem,
    Tradegoods = Enum.ItemClass.Tradegoods,
    Recipe = Enum.ItemClass.Recipe,
    Miscellaneous = Enum.ItemClass.Miscellaneous,
    Key = Enum.ItemClass.Key,
    Consumable = Enum.ItemClass.Consumable,
    Container = Enum.ItemClass.Container
}

---@class ML_Constants_ItemSubclass
Constants.ItemSubclass = {
    Junk = Enum.ItemMiscellaneousSubclass.Junk, -- a lot of stuff and lockboxes
    Generic = Enum.ItemArmorSubclass.Generic    -- spellstones, firestones, trinkets, rings and necks
}

if MoneyLooter.isRetail then
    Constants.ItemClass.Profession = Enum.ItemClass.Profession
end

---@class ML_Constants_PriceSources
Constants.PriceSources = {
    TradeSkillMaster = "TradeSkillMaster",
    Auctionator = "Auctionator",
    Auctioneer = "Auctioneer",
    OribosExchange = "Oribos Exchange",
    RECrystallize = "RECrystallize"
}

---@class ML_Constants_PriceSourcesOrder
Constants.PriceSourcesOrder = {
    Constants.PriceSources.TradeSkillMaster,
    Constants.PriceSources.Auctionator,
    Constants.PriceSources.Auctioneer,
    Constants.PriceSources.OribosExchange,
    Constants.PriceSources.RECrystallize
}

---@class ML_Constants_ItemAction
Constants.ItemAction = {
    Sell = 1,
    Auction = 2,
    Disenchant = 3,
    CanBeOpened = 4,
    Invalid = 5,
    Scan = 6,
    AuctionUnique = 7,
    SellJewellery = 8,
    ForceSell = 9
}

---@class ML_Constants_ActionIcons
Constants.ActionIcons = {
    [Constants.ItemAction.Sell] = "Interface\\Icons\\inv_misc_coin_02",
    [Constants.ItemAction.Auction] = "Interface\\Icons\\inv_hammer_15",
    [Constants.ItemAction.Disenchant] = "Interface\\Icons\\inv_enchant_disenchant",
    [Constants.ItemAction.CanBeOpened] = "Interface\\Icons\\inv_misc_lockboxghostiron",
    [Constants.ItemAction.Scan] = "Interface\\Icons\\inv_misc_questionmark",
    [Constants.ItemAction.Invalid] = "Interface\\Icons\\inv_misc_questionmark",
    [Constants.ItemAction.AuctionUnique] = "Interface\\Icons\\inv_hammer_05",
    [Constants.ItemAction.SellJewellery] = "Interface\\Icons\\inv_misc_coin_04",
    [Constants.ItemAction.ForceSell] = "Interface\\Icons\\inv_misc_coin_03"
}

---@class ML_Constants_BindType
Constants.BindType = {
    OnAcquire = Enum.ItemBind.OnAcquire,
    ToWoWAccount = Enum.ItemBind.ToWoWAccount,
    ToBnetAccount = Enum.ItemBind.ToBnetAccount,
    ToBnetAccountUntilEquipped = Enum.ItemBind.ToBnetAccountUntilEquipped
}

-- Loot global patterns for self
-- string.match returns itemLink, quantity || itemLink
Constants.PatternsSelf = {
    [1] = LOOT_ITEM_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"),        -- 2
    [2] = LOOT_ITEM_PUSHED_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"), -- 2
    [3] = LOOT_ITEM_SELF:gsub("%%s", "(.+)"),                                       -- 1
    [4] = LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)")                                 -- 1
}

-- Crafted global patterns for self
-- string.match returns itemLink, quantity || itemLink
Constants.PatternsCraft = {
    [1] = LOOT_ITEM_CREATED_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"), -- 2
    [2] = LOOT_ITEM_CREATED_SELF:gsub("%%s", "(.+)")                                 -- 1
}

Constants.PatternsReceived = {
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
