-- Author      : Will0w7
-- MoneyLooterModernUI --

local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString

local MinPanelWidth = 420
local MinPanelHeight = 180
local DefaultPanelWidth = 600
local DefaultPanelHeight = 400
local MaxLootedItems = 200

local function ApplyAlternateState(frame, alternate)
    frame:SetAlternateOverlayShown(alternate)
end

MoneyLooterButtonBehaviorMixin = {}

function MoneyLooterButtonBehaviorMixin:OnEnter()
    self.MouseoverOverlay:Show()
end

function MoneyLooterButtonBehaviorMixin:OnLeave()
    self.MouseoverOverlay:Hide()
end

function MoneyLooterButtonBehaviorMixin:SetAlternateOverlayShown(alternate)
    self.Alternate:SetShown(alternate)
end

MoneyLooterScrollBoxButtonMixin = {}

function MoneyLooterScrollBoxButtonMixin:Flash()
    self.FlashOverlay.Anim:Play()
end

MoneyLooterPanelMixin = CreateFromMixins(ToolWindowOwnerMixin)

function MoneyLooterPanelMixin:OnLoad()
    print("OnLoad")
    ButtonFrameTemplate_HidePortrait(self)

    -- Data providers
    self.logDataProvider = CreateDataProvider()

    self:InitializeSubtitleBar()
    self:InitializeLog()
    self:InitializeOptions()

    -- Register events

    --

    self.TitleBar:Init(self)
    self.ResizeButton:Init(self, MinPanelWidth, MinPanelHeight)
    self:SetTitle(ML_STRINGS.TITLE);

    self:UpdateStartButton()
end

function MoneyLooterPanelMixin:OnShow()
    print("OnShow")
    self:MoveToNewWindow(ML_STRINGS.TITLE, DefaultPanelWidth, DefaultPanelHeight, MinPanelWidth, MinPanelHeight)

    self.Log.LootedItems.ScrollBox:ScrollToEnd()
end

function MoneyLooterPanelMixin:OnHide()
    print("OnHide")
end

function MoneyLooterPanelMixin:OnEvent()
    print("OnEvent")
end

function MoneyLooterPanelMixin:OnCloseClick()
    PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE);
    self:Hide();
    self.window:Close();
end

function MoneyLooterPanelMixin:InitializeSubtitleBar()
    self.SubtitleBar.MoneyLooterStart.Label:SetText(_G.MONEYLOOTER_L_START)
    self.SubtitleBar.MoneyLooterStart:SetScript(ML_EVENTS.OnClick, function()
        print("Start click")
    end)

    self.SubtitleBar.MoneyLooterReset.Label:SetText(_G.MONEYLOOTER_L_RESET)
    self.SubtitleBar.MoneyLooterReset:SetScript(ML_EVENTS.OnClick, function()
        print("Reset click")
    end)
end

function MoneyLooterPanelMixin:InitializeLog()
    self.Log.Bar.Label:SetText(_G.MONEYLOOTER_L_LOG_BAR)
    self.Log.Bar.MoneyLooterInstance.Label:SetText(_G.MONEYLOOTER_L_RESET_INSTANCE)
    self.Log.Bar.MoneyLooterInstance:SetScript(ML_EVENTS.OnClick, function()
        print("Instance click")
        ResetInstances()
        self:LogMessage("Reset instances")
        self:LogLine({
            id = 80921,
            link = "|cff0070dd|Hitem:80921:4721:::::::36:103::1:::::::|h[Saboteur's Stabilizing Bracers]|h|r",
            value = 1234567,
            quantity = 1
        })
    end)
    ScrollUtil.RegisterAlternateRowBehavior(self.Log.LootedItems.ScrollBox, ApplyAlternateState)

    do
        local view = CreateScrollBoxListLinearView()
        view:SetElementFactory(function(factory, elementData)
            if elementData.link then
                factory("MoneyLooterLogItemButtonTemplate", function(button, data)
                    button:Init(data)

                    button:SetScript("OnClick", function(button, buttonName, down)
                        if buttonName == "LeftButton" then
                            print(tostring(elementData))
                            print(tostring(data))
                        end
                    end)
                end)
            elseif elementData.message then
                factory("MoneyLooterLogMessageButtonTemplate", function(button, data)
                    button:Init(data);

                    button:SetScript("OnClick", function(button, buttonName)
                        print(tostring(elementData))
                        print(tostring(data))
                    end)
                end)
            end
        end)

        local pad = 2
        local spacing = 2
        view:SetPadding(pad, pad, pad, pad, spacing)

        ScrollUtil.InitScrollBoxListWithScrollBar(self.Log.LootedItems.ScrollBox, self.Log.LootedItems.ScrollBar, view)
        self.Log.LootedItems.ScrollBox:SetDataProvider(self.logDataProvider)
    end
end

function MoneyLooterPanelMixin:InitializeOptions()
    self.SubtitleBar.OptionsDropdown:SetText(_G.MONEYLOOTER_L_OPTIONS)
    self.SubtitleBar.OptionsDropdown:SetupMenu(function(dropdown, rootDescription)
        rootDescription:SetTag("MENU_MONEY_LOOTER_OPTIONS")

        rootDescription:CreateButton("Test Button", function()
            print("Test options click button")
        end)

        rootDescription:CreateDivider()

        do
            function IsSelected()
                -- self:FooFunction()
            end

            function SetSelected()
                -- self:BarFunction(not self:FooFunction())
            end

            rootDescription:CreateCheckbox("Test checkbox", IsSelected, SetSelected)
        end
    end)
end

function MoneyLooterPanelMixin:UpdateStartButton()
end

function MoneyLooterPanelMixin:UpdateLogScrollBoxes(func)
    self.Log.LootedItems.ScrollBox:ForEachFrame(func)
end

function MoneyLooterPanelMixin:LogMessage(message)
    self:LogLine({ message = message });
end

function MoneyLooterPanelMixin:TrimDataProvider(dataProvider)
    local dataProviderSize = dataProvider:GetSize();
    if dataProviderSize > MaxLootedItems then
        local extra = 100;
        local overflow = dataProviderSize - MaxLootedItems;
        dataProvider:RemoveIndexRange(1, overflow + extra);
    end
end

function MoneyLooterPanelMixin:LogLine(elementData)
    local preInsertAtScrollEnd = self.Log.LootedItems.ScrollBox:IsAtEnd();
    local preInsertScrollable = self.Log.LootedItems.ScrollBox:HasScrollableExtent();

    self.logDataProvider:Insert(elementData);
    self:TrimDataProvider(self.logDataProvider);

    if not IsAltKeyDown() and (preInsertAtScrollEnd or (not preInsertScrollable and self.Log.LootedItems.ScrollBox:HasScrollableExtent())) then
        self.Log.LootedItems.ScrollBox:ScrollToEnd();
    end
end

-- Logs items
MoneyLooterLogItemButtonMixin = {}

function MoneyLooterLogItemButtonMixin:Init(elementData)
    local quantity = GRAY_FONT_COLOR:WrapTextInColorCode(elementData.quantity)
    elementData.lineWithoutArguments = string.format("%sx %s", quantity, elementData.link)

    self:SetLeftText(elementData)
    self:SetRightText(elementData)
end

function MoneyLooterLogItemButtonMixin:SetLeftText(elementData)
    self.LeftLabel:SetText(elementData.lineWithoutArguments)
end

function MoneyLooterLogItemButtonMixin:SetRightText(elementData)
    self.RightLabel:SetText(GetCoinTextureString(elementData.value))
end

function MoneyLooterLogItemButtonMixin:OnEnter()
    -- MoneyLooterButtonBehaviorMixin.OnEnter(self);

    -- MoneyLooterTooltip:SetOwner(self, "ANCHOR_RIGHT");
    local elementData = self:GetElementData()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetItemByID(elementData.id)
    GameTooltip:Show()
    
end

function MoneyLooterLogItemButtonMixin:OnLeave()
    -- MoneyLooterButtonBehaviorMixin.OnLeave(self)

    -- MoneyLooterTooltip:Hide();
    GameTooltip:Hide()
end

-- Logs simple messages
MoneyLooterLogMessageButtonMixin = {}

function MoneyLooterLogMessageButtonMixin:Init(elementData)
    local message = ORANGE_FONT_COLOR:WrapTextInColorCode(string.format("--- %s ---", elementData.message))
    elementData.lineWithoutArguments = message

    self:SetLeftText(elementData);
end

function MoneyLooterLogMessageButtonMixin:SetLeftText(elementData)
    self.LeftLabel:SetText(elementData.lineWithoutArguments);
end

function MoneyLooterLogMessageButtonMixin:OnShowArgumentsChanged(elementData, showArguments)
    self:SetLeftText(elementData);
end
