local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\PaperDollFrame.lua ]]
    function Hook.PaperDollFrame_SetLevel()
        local classLocale, classColor = private.charClass.locale, _G.CUSTOM_CLASS_COLORS[private.charClass.token]

        local level = _G.UnitLevel("player")
        local effectiveLevel = _G.UnitEffectiveLevel("player")

        if ( effectiveLevel ~= level ) then
            level = _G.EFFECTIVE_LEVEL_FORMAT:format(effectiveLevel, level)
        end

        local _, specName = _G.GetSpecializationInfo(_G.GetSpecialization(), nil, nil, nil, _G.UnitSex("player"))
        if specName and specName ~= "" then
            _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL, level, classColor.colorStr, specName, classLocale)
        end

        local showTrialCap = false
        if _G.GameLimitedMode_IsActive() then
            local rLevel = _G.GetRestrictedAccountData()
            if _G.UnitLevel("player") >= rLevel then
                showTrialCap = true
            end
        end
        if showTrialCap then
            _G.CharacterLevelText:SetPoint("CENTER", _G.CharacterFrame.TitleText, "TOP", 0, -36)
        else
            --_G.CharacterTrialLevelErrorText:Show()
            _G.CharacterLevelText:SetPoint("CENTER", _G.CharacterFrame.TitleText, "BOTTOM", 0, -4)
        end
    end
end

do --[[ FrameXML\PaperDollFrame.xml ]]
    function Skin.PaperDollItemSlotButtonTemplate(button)
        Skin.ItemButtonTemplate(button)
        _G[button:GetName().."Frame"]:Hide()
    end
    function Skin.PaperDollItemSlotButtonLeftTemplate(button)
        Skin.PaperDollItemSlotButtonTemplate(button)
    end
    function Skin.PaperDollItemSlotButtonRightTemplate(button)
        Skin.PaperDollItemSlotButtonTemplate(button)
    end
    function Skin.PaperDollItemSlotButtonBottomTemplate(button)
        Skin.PaperDollItemSlotButtonTemplate(button)
    end
    function Skin.PlayerTitleButtonTemplate(button)
        button.BgTop:SetTexture("")
        button.BgBottom:SetTexture("")
        button.BgMiddle:SetTexture("")

        button.SelectedBar:SetColorTexture(1, 1, 0, 0.3)
        button:GetHighlightTexture():SetColorTexture(0, 0, 1, 0.2)
    end
    function Skin.GearSetButtonTemplate(button)
        button.BgTop:SetTexture("")
        button.BgBottom:SetTexture("")
        button.BgMiddle:SetTexture("")

        button.HighlightBar:SetColorTexture(0, 0, 1, 0.3)
        button.SelectedBar:SetColorTexture(1, 1, 0, 0.3)

        Base.CropIcon(button.icon, button)
    end
    function Skin.GearSetPopupButtonTemplate(checkbutton)
        Skin.SimplePopupButtonTemplate(checkbutton)
        Base.CropIcon(_G[checkbutton:GetName().."Icon"], checkbutton)
        Base.CropIcon(checkbutton:GetHighlightTexture())
        Base.CropIcon(checkbutton:GetCheckedTexture())
    end
    function Skin.PaperDollSidebarTabTemplate(button)
        button.TabBg:SetAlpha(0)
        button.Hider:SetTexture("")

        button.Icon:ClearAllPoints()
        button.Icon:SetPoint("TOPLEFT", 1, -1)
        button.Icon:SetPoint("BOTTOMRIGHT", -1, 1)

        button.Highlight:SetTexture("")

        Base.SetBackdrop(button, Color.button)
        Base.SetHighlight(button, "backdrop")
    end
end

function private.FrameXML.PaperDollFrame()
    _G.hooksecurefunc("PaperDollFrame_SetLevel", Hook.PaperDollFrame_SetLevel)

    local classBG = _G.PaperDollFrame:CreateTexture(nil, "BORDER")
    classBG:SetAtlas("dressingroom-background-"..private.charClass.token)
    classBG:SetPoint("TOPLEFT", _G.CharacterFrame)
    classBG:SetPoint("BOTTOMRIGHT", _G.CharacterFrameInset, 4, -4)
    classBG:SetAlpha(0.5)

    _G.PaperDollSidebarTabs:ClearAllPoints()
    _G.PaperDollSidebarTabs:SetPoint("BOTTOM", _G.CharacterFrameInsetRight, "TOP", 0, -3)
    _G.PaperDollSidebarTabs.DecorLeft:Hide()
    _G.PaperDollSidebarTabs.DecorRight:Hide()

    for i = 1, #_G.PAPERDOLL_SIDEBARS do
        local tab = _G["PaperDollSidebarTab"..i]
        Skin.PaperDollSidebarTabTemplate(tab)
    end


    Hook.HybridScrollFrame_CreateButtons(_G.PaperDollTitlesPane, "PlayerTitleButtonTemplate") -- Called here since the original is called OnLoad
    _G.PaperDollTitlesPane:SetPoint("BOTTOMRIGHT", _G.CharacterFrameInsetRight, -4, 4)
    Skin.HybridScrollBarTemplate(_G.PaperDollTitlesPane.scrollBar)
    _G.PaperDollTitlesPane.scrollBar:ClearAllPoints()
    _G.PaperDollTitlesPane.scrollBar:SetPoint("TOPRIGHT", 2, -19)
    _G.PaperDollTitlesPane.scrollBar:SetPoint("BOTTOMRIGHT", 2, 15)


    local PaperDollEquipmentManagerPane = _G.PaperDollEquipmentManagerPane
    Hook.HybridScrollFrame_CreateButtons(PaperDollEquipmentManagerPane, "GearSetButtonTemplate") -- Called here since the original is called OnLoad
    PaperDollEquipmentManagerPane:SetPoint("BOTTOMRIGHT", _G.CharacterFrameInsetRight, -4, 4)

    Skin.UIPanelButtonTemplate(PaperDollEquipmentManagerPane.EquipSet)
    PaperDollEquipmentManagerPane.EquipSet.ButtonBackground:Hide()
    Skin.UIPanelButtonTemplate(PaperDollEquipmentManagerPane.SaveSet)

    Skin.HybridScrollBarTemplate(PaperDollEquipmentManagerPane.scrollBar)
    PaperDollEquipmentManagerPane.scrollBar:ClearAllPoints()
    PaperDollEquipmentManagerPane.scrollBar:SetPoint("TOPRIGHT", 2, -19)
    PaperDollEquipmentManagerPane.scrollBar:SetPoint("BOTTOMRIGHT", 2, 15)


    _G.CharacterModelFrame:SetPoint("TOPLEFT", _G.CharacterFrameInset, 45, -10)
    _G.CharacterModelFrame:SetPoint("BOTTOMRIGHT", _G.CharacterFrameInset, -45, 30)

    _G.CharacterModelFrameBackgroundTopLeft:Hide()
    _G.CharacterModelFrameBackgroundTopRight:Hide()
    _G.CharacterModelFrameBackgroundBotLeft:Hide()
    _G.CharacterModelFrameBackgroundBotRight:Hide()

    _G.CharacterModelFrameBackgroundOverlay:Hide()

    _G.PaperDollInnerBorderTopLeft:Hide()
    _G.PaperDollInnerBorderTopRight:Hide()
    _G.PaperDollInnerBorderBottomLeft:Hide()
    _G.PaperDollInnerBorderBottomRight:Hide()
    _G.PaperDollInnerBorderLeft:Hide()
    _G.PaperDollInnerBorderRight:Hide()
    _G.PaperDollInnerBorderTop:Hide()
    _G.PaperDollInnerBorderBottom:Hide()
    _G.PaperDollInnerBorderBottom2:Hide()


    local EquipmentSlots = {
        "CharacterHeadSlot", "CharacterNeckSlot", "CharacterShoulderSlot", "CharacterBackSlot", "CharacterChestSlot", "CharacterShirtSlot", "CharacterTabardSlot", "CharacterWristSlot",
        "CharacterHandsSlot", "CharacterWaistSlot", "CharacterLegsSlot", "CharacterFeetSlot", "CharacterFinger0Slot", "CharacterFinger1Slot", "CharacterTrinket0Slot", "CharacterTrinket1Slot"
    }
    local WeaponSlots = {
        "CharacterMainHandSlot", "CharacterSecondaryHandSlot"
    }

    local prevSlot
    for i = 1, #EquipmentSlots do
        local button = _G[EquipmentSlots[i]]

        if not private.isPatch then
            button.IsLeftSide = i <= 8
        end

        if i % 8 == 1 then
            if button.IsLeftSide then
                button:SetPoint("TOPLEFT", _G.CharacterFrameInset, 4, -11)
            else
                button:SetPoint("TOPRIGHT", _G.CharacterFrameInset, -4, -11)
            end
        else
            button:SetPoint("TOPLEFT", prevSlot, "BOTTOMLEFT", 0, -6)
        end

        if button.IsLeftSide then
            Skin.PaperDollItemSlotButtonLeftTemplate(button)
        elseif button.IsLeftSide == false then
            Skin.PaperDollItemSlotButtonRightTemplate(button)
        end

        prevSlot = button
    end

    for i = 1, #WeaponSlots do
        local button = _G[WeaponSlots[i]]

        if i == 1 then
            -- main hand
            button:SetPoint("BOTTOMLEFT", 130, 8)
        end

        Skin.PaperDollItemSlotButtonBottomTemplate(button)
        _G.select(11, button:GetRegions()):Hide()
    end


    local GearManagerDialogPopup = _G.GearManagerDialogPopup
    Base.SetBackdrop(GearManagerDialogPopup)
    GearManagerDialogPopup:SetSize(510, 520)
    GearManagerDialogPopup.BG:Hide()
    Hook.BuildIconArray(GearManagerDialogPopup, "GearManagerDialogPopupButton", "GearSetPopupButtonTemplate", _G.NUM_GEARSET_ICONS_PER_ROW, _G.NUM_GEARSET_ICON_ROWS)

    local BorderBox = GearManagerDialogPopup.BorderBox
    for i = 1, 8 do
        select(i, BorderBox:GetRegions()):Hide()
    end

    _G.GearManagerDialogPopupEditBoxLeft:Hide()
    _G.GearManagerDialogPopupEditBoxMiddle:Hide()
    _G.GearManagerDialogPopupEditBoxRight:Hide()
    Base.SetBackdrop(_G.GearManagerDialogPopupEditBox)

    Skin.UIPanelButtonTemplate(_G.GearManagerDialogPopupCancel)
    Skin.UIPanelButtonTemplate(_G.GearManagerDialogPopupOkay)

    Skin.ListScrollFrameTemplate(_G.GearManagerDialogPopupScrollFrame)
    _G.GearManagerDialogPopupScrollFrame:ClearAllPoints()
    _G.GearManagerDialogPopupScrollFrame:SetPoint("TOPLEFT", 22, -81)
    _G.GearManagerDialogPopupScrollFrame:SetPoint("BOTTOMRIGHT", -29, 42)
end
