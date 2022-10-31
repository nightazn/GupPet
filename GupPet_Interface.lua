--[[ 	GupPet by Gup 	]]--

-- TEMP VARS
GUPPET_INTERFACE_LOCATIONFRAME 	= { Total = 0}
GUPPET_INTERFACE_MAINFRAME 		= { Init = 0 , Ground = { Temp = 0} , Fly = {Temp = 0} , Multi = {Temp = 0} , Aquatic = {Temp = 0} , Companion = {Temp = 0} }
GUPPET_INTERFACE_OPTIONFRAME 	= { }
GUPPET_INTERFACE_SAVEHIGHLIGHT 	= {}
GUPPET_INTERFACE_INGAMEBUTTONS 	= { Init = 0}
GUPPET_INTERFACE_SAVESHOW = {}

StaticPopupDialogs["GupPet_Interface_Remove"] = {
  text = GUPPET_L["INTERFACE_REMOVE"][1] ,
  button1 = GUPPET_L["INTERFACE_REMOVE"][2],
  button2 = GUPPET_L["INTERFACE_REMOVE"][3],
  OnAccept = function()
        GupPet_Location( "Remove" , GupPet_Interface_GetLocationSelected() )
		GupPet_Interface_UpdateLocationFrame()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true
}

StaticPopupDialogs["GupPet_Interface_ChangeMode"] = {
  text = GUPPET_L["INTERFACE_CHANGEMODE"][1] ,
  button1 = GUPPET_L["INTERFACE_CHANGEMODE"][2],
  button2 = GUPPET_L["INTERFACE_CHANGEMODE"][3],
  OnAccept = function()

		if GUPPET_OPTIONS.Mode == "Expert" then
			GUPPET_OPTIONS.Mode = "_Expert"
		else
			GUPPET_OPTIONS.Mode = "Expert"
		end
		ReloadUI()
  end,
  OnCancel = function()
 		GUPPET_INTERFACE_OPTIONFRAME.ExpertMode:SetChecked(  GUPPET_OPTIONS.Mode == "Expert" )
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true
}


function GupPet_Interface_Show( Type , Option , frame )

	if Option == "Add" then
		if GUPPET_INTERFACE_SAVESHOW[Type] == nil then GUPPET_INTERFACE_SAVESHOW[Type] = {} ; end

		tinsert( GUPPET_INTERFACE_SAVESHOW[Type] , frame:GetName() )
	else
		local ShowFrame = frame:GetName()

		for i , SavedFrame  in  ipairs(GUPPET_INTERFACE_SAVESHOW[Type])  do

			if SavedFrame == ShowFrame then
				_G[ SavedFrame]:Show()
			else
				_G[ SavedFrame]:Hide()
			end
		end
	end
end

function GupPet_Interface_SetSelected( Button , Type )

	if not( GUPPET_INTERFACE_SAVEHIGHLIGHT[Type] == nil) then
		_G[ GUPPET_INTERFACE_SAVEHIGHLIGHT[Type]]:UnlockHighlight()
	end

	Button:LockHighlight()
	GUPPET_INTERFACE_SAVEHIGHLIGHT[Type] = Button:GetName()
end

local function GupPet_Interface_GetSelected( Type )

	return GUPPET_INTERFACE_SAVEHIGHLIGHT[Type]

end

function GupPet_Interface_MakeButtons()

	local Optionframe = CreateFrame("Frame", "GupPetPanel" , nil, BackdropTemplateMixin and "BackdropTemplate" )
	Optionframe.name = "GupPet"

	local Optionframe_Button = CreateFrame(
			"Button", "GupPet_OptionButton", Optionframe ,
			"GupPet_ButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	Optionframe_Button:SetScript("OnClick", function ()  ShowUIPanel(GupPet_InterfaceOptionsFrame); end)
	Optionframe_Button:SetWidth(200)
	Optionframe_Button:SetHeight(30)
	Optionframe_Button:SetPoint("CENTER", 0, 0)
	Optionframe_Button:SetText( "GupPet" )

	InterfaceOptions_AddCategory(Optionframe)
end

function GupPet_Interface_Option()

	-- AutoCompanion
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame = CreateFrame(
			"FRAME", "GupPet_AutoCompanionFrame", GupPet_InterfaceOptionsFrameOptions ,
			"GupPet_FieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame:SetWidth(220)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame:SetHeight(280)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame:SetPoint("TOPLEFT", 260 , -30)
	_G["GupPet_AutoCompanionFrame" .. "SubTitle"]:SetText("|cFFFC830E".. GUPPET_L["AUTOCALLCOMPANION"] )

	-- Replaced OptionsSmallCheckButtonTemplate
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion = CreateFrame(
			"CheckButton", "GupPet_AutoCompanion"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame,
			"OptionsBaseCheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion:SetPoint("TOPLEFT", 10, -10 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion:SetScript("OnClick", function (self, button, down) GUPPET_OPTIONS.AutoCompanion.Enabled=self:GetChecked(); GupPet_AutoCompanionSetEnable()    end)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion:SetChecked(  GUPPET_OPTIONS.AutoCompanion.Enabled )
	_G["GupPet_AutoCompanion" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_ENABLE"][1]  )
	--
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_City = CreateFrame(
			"CheckButton", "GupPet_AutoCompanionCity"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame,
			"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_City:SetPoint("TOPLEFT", 20, -32 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_City:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS.AutoCompanion.City = self:GetChecked();     end)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_City:SetChecked(  GUPPET_OPTIONS.AutoCompanion.City )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_City:SetHitRectInsets( 0 , -50, 0 , 0)
	_G["GupPet_AutoCompanionCity" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_CITY"][1]  )
	--
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Outside = CreateFrame(
		"CheckButton", "GupPet_AutoCompanionOutside"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Outside:SetPoint("TOPLEFT", 20, -47 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Outside:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS.AutoCompanion.Outside = self:GetChecked();    end)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Outside:SetChecked(  GUPPET_OPTIONS.AutoCompanion.Outside )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Outside:SetHitRectInsets( 0 , -50, 0 , 0)
	_G["GupPet_AutoCompanionOutside" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_OUTSIDE"][1]  )
	--
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Arena = CreateFrame(
		"CheckButton", "GupPet_AutoCompanionArena"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Arena:SetPoint("TOPLEFT", 20, -62 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Arena:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS.AutoCompanion.Arena = self:GetChecked();     end)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Arena:SetChecked(  GUPPET_OPTIONS.AutoCompanion.Arena )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Arena:SetHitRectInsets( 0 , -50, 0 , 0)
	_G["GupPet_AutoCompanionArena" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_ARENA"][1]  )
	--
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Party = CreateFrame(
		"CheckButton", "GupPet_AutoCompanionParty"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Party:SetPoint("TOPLEFT", 20, -77 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Party:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS.AutoCompanion.Party = self:GetChecked();     end)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Party:SetChecked(  GUPPET_OPTIONS.AutoCompanion.Party )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Party:SetHitRectInsets( 0 , -50, 0 , 0)
	_G["GupPet_AutoCompanionParty" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_PARTY"][1]  )
	--
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Raid = CreateFrame(
		"CheckButton", "GupPet_AutoCompanionRaid"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Raid:SetPoint("TOPLEFT", 20, -92 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Raid:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS.AutoCompanion.Raid = self:GetChecked();     end)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Raid:SetChecked(  GUPPET_OPTIONS.AutoCompanion.Raid )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_Raid:SetHitRectInsets( 0 , -50, 0 , 0)
	_G["GupPet_AutoCompanionRaid" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_RAID"][1]  )

	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_BattleGround = CreateFrame(
		"CheckButton", "GupPet_AutoCompanionBattleGround"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_BattleGround:SetPoint("TOPLEFT", 20, -107 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_BattleGround:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS.AutoCompanion.BattleGround = self:GetChecked();    end)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_BattleGround:SetChecked(  GUPPET_OPTIONS.AutoCompanion.BattleGround )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCompanion_BattleGround:SetHitRectInsets( 0 , -90, 0 , 0)
	_G["GupPet_AutoCompanionBattleGround" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_BATTLEGROUND"][1]  )
	--
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay = CreateFrame(
		'Slider', "GupPet_AutoCallDelay", GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame ,
		'OptionsSliderTemplate', BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay:SetPoint('TOP', 0, -140)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay:SetOrientation('HORIZONTAL')
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay:SetWidth(140)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay:SetHeight(17)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay:SetMinMaxValues(2 , 10 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay:SetValueStep(0.1)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay:SetObeyStepOnDrag(true)
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay:SetValue( GUPPET_OPTIONS.AutoCompanion.Delay )
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay:SetScript("OnValueChanged", function (self)  GUPPET_OPTIONS.AutoCompanion.Delay = self:GetValue() ;       end)
	_G["GupPet_AutoCallDelay" .. "Text"]:SetText(GUPPET_L["AUTOCALLCOMPANION_DELAY"][1])
	_G["GupPet_AutoCallDelay" .. "Low"]:SetText( "2")
	_G["GupPet_AutoCallDelay" .. "High"]:SetText("10")
	GUPPET_INTERFACE_OPTIONFRAME.AutoCallDelay.tooltipText = GUPPET_L["AUTOCALLCOMPANION_DELAY"][2]

	-- Replaced OptionsSmallCheckButtonTemplate
	GUPPET_INTERFACE_OPTIONFRAME.DismissMounted = CreateFrame(
		"CheckButton", "GupPet_DismissMounted"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame,
		"OptionsBaseCheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.DismissMounted:SetPoint("TOPLEFT", 10, -170 )
	GUPPET_INTERFACE_OPTIONFRAME.DismissMounted:SetScript("OnClick", function (self, button, down) GUPPET_OPTIONS.AutoCompanion.DismissMounted=self:GetChecked();     end)
	GUPPET_INTERFACE_OPTIONFRAME.DismissMounted:SetChecked(  GUPPET_OPTIONS.AutoCompanion.DismissMounted )
	_G["GupPet_DismissMounted" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_AUTODISMISSMOUNTED"][1]  )
	--
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay = CreateFrame(
		'Slider', "GupPet_AutoResummonDelay", GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame ,
		'GupPet_OptionsSliderTemplate', BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay:SetPoint('TOP', 0, -205)
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay:SetOrientation('HORIZONTAL')
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay:SetWidth(140)
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay:SetHeight(17)
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay:SetMinMaxValues(0 , 600 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay:SetValueStep(10)
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay:SetObeyStepOnDrag(true)
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay:SetValue( GUPPET_OPTIONS.AutoCompanion.Resummon )
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay:SetScript("OnValueChanged", function (self) GUPPET_AUTOCOMPANION.ResummonFrame:Hide(); GUPPET_OPTIONS.AutoCompanion.Resummon = self:GetValue() ;  GupPet_AutoCompanionResumonSetEnable(); _G["GupPet_AutoResummonDelay" .. "Current"]:SetText(GUPPET_OPTIONS.AutoCompanion.Resummon) ;    end)
	_G["GupPet_AutoResummonDelay" .. "Text"]:SetText(GUPPET_L["AUTOCALLCOMPANION_RESUMMON"][1])
	_G["GupPet_AutoResummonDelay" .. "Low"]:SetText( "0")
	_G["GupPet_AutoResummonDelay" .. "High"]:SetText("600")
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonDelay.tooltipText = GUPPET_L["AUTOCALLCOMPANION_RESUMMON"][2]
	_G["GupPet_AutoResummonDelay" .. "Current"]:SetText(GUPPET_OPTIONS.AutoCompanion.Resummon)
	--
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonCityOnly = CreateFrame("CheckButton", "GupPet_AutoResummonCityOnly"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame, "GupPet_CheckButtonTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonCityOnly:SetPoint("TOPLEFT", 20, -233 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonCityOnly:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS.AutoCompanion.ResummonEveryWhere = not(self:GetChecked());    end)
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonCityOnly:SetChecked(  not(GUPPET_OPTIONS.AutoCompanion.ResummonEveryWhere) )
	GUPPET_INTERFACE_OPTIONFRAME.AutoResummonCityOnly:SetHitRectInsets( 0 , -90, 0 , 0)
	_G["GupPet_AutoResummonCityOnly" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_RESUMMONCITYONLY"][1] )

	-- Replaced OptionsSmallCheckButtonTemplate
	GUPPET_INTERFACE_OPTIONFRAME.PetOfTheDay = CreateFrame(
		"CheckButton", "GupPet_PetOfTheDay"  , GUPPET_INTERFACE_OPTIONFRAME.AutoCallCompanionFrame,
		"OptionsBaseCheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.PetOfTheDay:SetPoint("TOPLEFT", 10, -250 )
	GUPPET_INTERFACE_OPTIONFRAME.PetOfTheDay:SetScript("OnClick", function (self, button, down) GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.Enabled=self:GetChecked();     end)
	GUPPET_INTERFACE_OPTIONFRAME.PetOfTheDay:SetChecked(  GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.Enabled )
	_G["GupPet_PetOfTheDay" .. "Text"]:SetText( GUPPET_L["AUTOCALLCOMPANION_PETOFTHEDAY"][1]  )
	GUPPET_INTERFACE_OPTIONFRAME.PetOfTheDay.tooltipText = GUPPET_L["AUTOCALLCOMPANION_PETOFTHEDAY"][2]


	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	--Buttons

	GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame = CreateFrame(
		"FRAME", "GupPet_IngameButtonFrame", GupPet_InterfaceOptionsFrameOptions ,
		"GupPet_FieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame:SetWidth(240)
	GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame:SetHeight(165)
	GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame:SetPoint("TOPLEFT", 10 , -30)
	_G["GupPet_IngameButtonFrame" .. "SubTitle"]:SetText("|cFFFC830E".. GUPPET_L["INGAMEBUTTONS"][1] )

	-- Replaced OptionsSmallCheckButtonTemplate
	GUPPET_INTERFACE_OPTIONFRAME.UIShow = CreateFrame(
		"CheckButton", "GupPet_IngameButtonShow"  , GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame,
		"OptionsBaseCheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.UIShow:SetPoint("TOPLEFT", 10, -10 )
	GUPPET_INTERFACE_OPTIONFRAME.UIShow:SetScript("OnClick", function (self, button, down)  GUPPET_OPTIONS["IngameButton"]["Show"]=self:GetChecked();  GupPet_Interface_IngameButtons();   end)
	GUPPET_INTERFACE_OPTIONFRAME.UIShow:SetChecked(  GUPPET_OPTIONS["IngameButton"]["Show"] )
	_G["GupPet_IngameButtonShow" .. "Text"]:SetText( GUPPET_L["SHOW"][1]  )

	GUPPET_INTERFACE_OPTIONFRAME.Icon = CreateFrame(
		"Button", "GupPet_Icons", GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame ,
		"GupPet_ButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.Icon:SetScript("OnClick", function ()  if GupPet_IconPopupFrame:IsShown() then GupPet_IconPopupFrame:Hide() else GupPet_IconPopupFrame:Show() end end)
	GUPPET_INTERFACE_OPTIONFRAME.Icon:SetWidth(75)
	GUPPET_INTERFACE_OPTIONFRAME.Icon:SetHeight(15)
	GUPPET_INTERFACE_OPTIONFRAME.Icon:SetPoint("TOPRIGHT",-10, -15)
	GUPPET_INTERFACE_OPTIONFRAME.Icon:SetText( GUPPET_L["ICON"][1] )
	GUPPET_INTERFACE_OPTIONFRAME.Icon.tooltipText = GUPPET_L["ICON"][2]
	GUPPET_INTERFACE_OPTIONFRAME.Icon:SetNormalFontObject( GupPet_FontText)
	GUPPET_INTERFACE_OPTIONFRAME.Icon:SetHighlightFontObject( GupPet_FontText)

	GUPPET_INTERFACE_OPTIONFRAME.UIDrag = CreateFrame(
		"CheckButton", "GupPet_IngameButtonDrag"  , GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.UIDrag:SetPoint("TOPLEFT", 20, -32 )
	GUPPET_INTERFACE_OPTIONFRAME.UIDrag:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["IngameButton"]["Lock"] = self:GetChecked() ;   if self:GetChecked() then GupPet_Interface_DragIngameButtons( "Hide" ) else GupPet_Interface_DragIngameButtons( "Show" ) end   ;  end)
	GUPPET_INTERFACE_OPTIONFRAME.UIDrag:SetChecked(  GUPPET_OPTIONS["IngameButton"]["Lock"] )
	GUPPET_INTERFACE_OPTIONFRAME.UIDrag:SetHitRectInsets( 0 , -50, 0 , 0)
	_G["GupPet_IngameButtonDrag" .. "Text"]:SetText( GUPPET_L["LOCKED"][1]  )

	GUPPET_INTERFACE_OPTIONFRAME.Restore = CreateFrame(
		"Button", "GupPet_Restore", GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame ,
		"GupPet_ButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.Restore:SetScript("OnClick", function ()  GupPet_Interface_DragIngameButtons( "Reset" ); end)
	GUPPET_INTERFACE_OPTIONFRAME.Restore:SetWidth(75)
	GUPPET_INTERFACE_OPTIONFRAME.Restore:SetHeight(15)
	GUPPET_INTERFACE_OPTIONFRAME.Restore:SetPoint("TOPRIGHT",-10, -32)
	GUPPET_INTERFACE_OPTIONFRAME.Restore:SetText( GUPPET_L["RESTORE"][1] )
	GUPPET_INTERFACE_OPTIONFRAME.Restore.tooltipText = GUPPET_L["RESTORE"][2]
	GUPPET_INTERFACE_OPTIONFRAME.Restore:SetNormalFontObject( GupPet_FontText)
	GUPPET_INTERFACE_OPTIONFRAME.Restore:SetHighlightFontObject( GupPet_FontText)


	GUPPET_INTERFACE_OPTIONFRAME.ButtonMode = CreateFrame(
		"CheckButton", "GupPet_ButtonMode"  , GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.ButtonMode:SetPoint("TOPLEFT", 20, -47 )
	GUPPET_INTERFACE_OPTIONFRAME.ButtonMode:SetScript("OnClick", function (self, button, down)  if self:GetChecked() then GUPPET_OPTIONS.IngameButton.MountButton = "Auto"   else GUPPET_OPTIONS.IngameButton.MountButton = "Hand"  end ; GupPet_Interface_IngameButtons(); end)
	GUPPET_INTERFACE_OPTIONFRAME.ButtonMode:SetChecked(  GUPPET_OPTIONS.IngameButton.MountButton == "Auto" )
	_G["GupPet_ButtonMode" .. "Text"]:SetText( GUPPET_L["BUTTONMODE"][1]  )
	GUPPET_INTERFACE_OPTIONFRAME.ButtonMode.tooltipText = GUPPET_L["BUTTONMODE"][2]

	GUPPET_INTERFACE_OPTIONFRAME.CompanionButtonShow = CreateFrame(
		"CheckButton", "GupPet_CompanionButtonShow"  , GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.CompanionButtonShow:SetPoint("TOPLEFT", 20, -62 )
	GUPPET_INTERFACE_OPTIONFRAME.CompanionButtonShow:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS.IngameButton.CompanionButton = self:GetChecked() ;  GupPet_Interface_IngameButtons();  end)
	GUPPET_INTERFACE_OPTIONFRAME.CompanionButtonShow:SetChecked( GUPPET_OPTIONS["IngameButton"]["CompanionButton"] )
	_G["GupPet_CompanionButtonShow" .. "Text"]:SetText( GUPPET_L["COMPANIONBUTTONSHOW"][1]  )

	GUPPET_INTERFACE_OPTIONFRAME.ButtonAlignment = CreateFrame(
		"CheckButton", "GupPet_ButtonAlignment"  , GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.ButtonAlignment:SetPoint("TOPLEFT", 20, -77 )
	GUPPET_INTERFACE_OPTIONFRAME.ButtonAlignment:SetScript("OnClick", function (self, button, down)  if self:GetChecked() then GUPPET_OPTIONS.IngameButton.Alignment = "Vertical"   else GUPPET_OPTIONS.IngameButton.Alignment = "Horizontal"  end ; GupPet_Interface_IngameButtons(); end)
	GUPPET_INTERFACE_OPTIONFRAME.ButtonAlignment:SetChecked(  GUPPET_OPTIONS.IngameButton.Alignment == "Vertical")
	_G["GupPet_ButtonAlignment" .. "Text"]:SetText( GUPPET_L["BUTTONALIGNMENT"][1]  )
	GUPPET_INTERFACE_OPTIONFRAME.ButtonAlignment.tooltipText = GUPPET_L["BUTTONALIGNMENT"][2]

	GUPPET_INTERFACE_OPTIONFRAME.ButtonHideKeyBind = CreateFrame(
		"CheckButton", "GupPet_ButtonHideKeyBind"  , GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame,
		"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.ButtonHideKeyBind:SetPoint("TOPLEFT", 20, -92 )
	GUPPET_INTERFACE_OPTIONFRAME.ButtonHideKeyBind:SetScript("OnClick", function (self, button, down)  if self:GetChecked() then GUPPET_OPTIONS.IngameButton.ButtonHideKeyBind = true; else GUPPET_OPTIONS.IngameButton.ButtonHideKeyBind = nil;  end  GupPet_OnEvent(self, "UPDATE_BINDINGS");  end)
	GUPPET_INTERFACE_OPTIONFRAME.ButtonHideKeyBind:SetChecked(  GUPPET_OPTIONS.IngameButton.ButtonHideKeyBind )
	_G["GupPet_ButtonHideKeyBind" .. "Text"]:SetText( GUPPET_L["HIDEKEYBINDTEXT"][1]  )
	GUPPET_INTERFACE_OPTIONFRAME.ButtonHideKeyBind.tooltipText = GUPPET_L["HIDEKEYBINDTEXT"][2]


	GUPPET_INTERFACE_OPTIONFRAME.Scale = CreateFrame(
		'Slider', "GupPet_Scale", GUPPET_INTERFACE_OPTIONFRAME.IngameButtonFrame ,
		'OptionsSliderTemplate', BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.Scale:SetPoint('TOP', 0, -130)
	GUPPET_INTERFACE_OPTIONFRAME.Scale:SetOrientation('HORIZONTAL')
	GUPPET_INTERFACE_OPTIONFRAME.Scale:SetWidth(160)
	GUPPET_INTERFACE_OPTIONFRAME.Scale:SetHeight(17)
	GUPPET_INTERFACE_OPTIONFRAME.Scale:SetMinMaxValues(0.2 , 2.5 )
	GUPPET_INTERFACE_OPTIONFRAME.Scale:SetValueStep(0.05)
	GUPPET_INTERFACE_OPTIONFRAME.Scale:SetObeyStepOnDrag(true)
	GUPPET_INTERFACE_OPTIONFRAME.Scale:SetValue( GUPPET_OPTIONS["IngameButton"]["Scale"] )
	GUPPET_INTERFACE_OPTIONFRAME.Scale:SetScript("OnValueChanged", function (self)   GUPPET_OPTIONS["IngameButton"]["Scale"] = self:GetValue() ;  GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetScale( GUPPET_OPTIONS.IngameButton.Scale );      end)
	_G["GupPet_Scale" .. "Text"]:SetText(GUPPET_L["SCALE"][1])
	_G["GupPet_Scale" .. "Low"]:SetText(GUPPET_L["SCALE"][2])
	_G["GupPet_Scale" .. "High"]:SetText(GUPPET_L["SCALE"][3])

	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- Extra
	GUPPET_INTERFACE_OPTIONFRAME.ExtraFrame = CreateFrame(
		"FRAME", "GupPet_ExtraFrame", GupPet_InterfaceOptionsFrameOptions ,
		"GupPet_FieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.ExtraFrame:SetWidth(180)
	GUPPET_INTERFACE_OPTIONFRAME.ExtraFrame:SetHeight(100)
	GUPPET_INTERFACE_OPTIONFRAME.ExtraFrame:SetPoint("TOPRIGHT", -10 , -30)
	_G["GupPet_ExtraFrame" .. "SubTitle"]:SetText("|cFFFC830E".. GUPPET_L["EXTRA"][1])


	-- Replaced OptionsSmallCheckButtonTemplate
	GUPPET_INTERFACE_OPTIONFRAME.AutoDismount = CreateFrame(
		"CheckButton", "GupPet_AutoDismount"  , GUPPET_INTERFACE_OPTIONFRAME.ExtraFrame,
		"OptionsBaseCheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.AutoDismount:SetPoint("TOPLEFT", 10, -10 )
	GUPPET_INTERFACE_OPTIONFRAME.AutoDismount:SetScript("OnClick", function (self, button, down)    GupPet_AutoDismount(  self:GetChecked() )  end)
	GUPPET_INTERFACE_OPTIONFRAME.AutoDismount:SetChecked(  GUPPET_OPTIONS["AutoDismount"] )
	_G["GupPet_AutoDismount" .. "Text"]:SetText( GUPPET_L["AUTODISMOUNT"][1]  )
	GUPPET_INTERFACE_OPTIONFRAME.AutoDismount.tooltipText = GUPPET_L["AUTODISMOUNT"][2]

	-- Replaced OptionsSmallCheckButtonTemplate
	GUPPET_INTERFACE_OPTIONFRAME.ExpertMode = CreateFrame(
		"CheckButton", "GupPet_ExpertMode"  , GUPPET_INTERFACE_OPTIONFRAME.ExtraFrame,
		"OptionsBaseCheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.ExpertMode:SetPoint("TOPLEFT", 10, -30 )
	GUPPET_INTERFACE_OPTIONFRAME.ExpertMode:SetScript("OnClick", function (self, button, down)  StaticPopup_Show ("GupPet_Interface_ChangeMode");   end)
	GUPPET_INTERFACE_OPTIONFRAME.ExpertMode:SetChecked(  GUPPET_OPTIONS.Mode == "Expert" )
	_G["GupPet_ExpertMode" .. "Text"]:SetText( GUPPET_L["EXPERTMODE"][1]  )
	GUPPET_INTERFACE_OPTIONFRAME.ExpertMode.tooltipText = GUPPET_L["EXPERTMODE"][2]

	-- Replaced OptionsSmallCheckButtonTemplate
	GUPPET_INTERFACE_OPTIONFRAME.NewLearnedOn = CreateFrame(
		"CheckButton", "GupPet_NewLearnedOn", GUPPET_INTERFACE_OPTIONFRAME.ExtraFrame,
		"OptionsBaseCheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.NewLearnedOn:SetPoint("TOPLEFT", 10, -60 )
	GUPPET_INTERFACE_OPTIONFRAME.NewLearnedOn:SetScript("OnClick", function(self, button, down) GUPPET_OPTIONS["NewLearnedOn"] = self:GetChecked() end)
	GUPPET_INTERFACE_OPTIONFRAME.NewLearnedOn:SetChecked(  GUPPET_OPTIONS["NewLearnedOn"] )
	_G["GupPet_NewLearnedOn" .. "Text"]:SetText( GUPPET_L["NEWLEARNEDON"] )

	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- PREVIEW FRAME

	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrame = CreateFrame(
		"FRAME", "GupPet_PreviewFrame", GupPet_InterfaceOptionsFrameOptions ,
		"GupPet_FieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrame:SetWidth(200)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrame:SetHeight(95)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrame:SetPoint("TOPLEFT", 10 , -220)
	_G["GupPet_PreviewFrame" .. "SubTitle"]:SetText("|cFFFC830E".. GUPPET_L["PREVIEWFRAME"][1])

	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed = CreateFrame(
			'Slider', "GupPet_PreviewFrameSpeed", GUPPET_INTERFACE_OPTIONFRAME.PreviewFrame ,
			'GupPet_OptionsSliderTemplate', BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed:SetPoint('TOP', 0, -20)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed:SetOrientation('HORIZONTAL')
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed:SetWidth(160)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed:SetHeight(17)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed:SetMinMaxValues( -1 , 1 )
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed:SetValueStep(0.5)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed:SetObeyStepOnDrag(true)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed:SetValue( GUPPET_OPTIONS.PreviewFrameSpeed )
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameSpeed:SetScript("OnValueChanged", function (self)   GUPPET_OPTIONS.PreviewFrameSpeed = self:GetValue() ;  _G["GupPet_PreviewFrameSpeed" .. "Current"]:SetText( GUPPET_OPTIONS.PreviewFrameSpeed ) ;      end)
	_G["GupPet_PreviewFrameSpeed" .. "Text"]:SetText(GUPPET_L["PREVIEWFRAMESPEED"][1])
	_G["GupPet_PreviewFrameSpeed" .. "Low"]:SetText(GUPPET_L["PREVIEWFRAMESPEED"][2])
	_G["GupPet_PreviewFrameSpeed" .. "High"]:SetText(GUPPET_L["PREVIEWFRAMESPEED"][3])
	_G["GupPet_PreviewFrameSpeed" .. "Current"]:SetText( GUPPET_OPTIONS.PreviewFrameSpeed )

	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos = CreateFrame(
			'Slider', "GupPet_PreviewFrameStartPos", GUPPET_INTERFACE_OPTIONFRAME.PreviewFrame ,
			'OptionsSliderTemplate', BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos:SetPoint('TOP', 0, -63)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos:SetOrientation('HORIZONTAL')
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos:SetWidth(160)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos:SetHeight(17)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos:SetMinMaxValues( -3.14 , 3.14 )
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos:SetValueStep( 0.1 )
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos:SetObeyStepOnDrag(true)
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos:SetValue( GUPPET_OPTIONS.PreviewFrameStartPos )
	GUPPET_INTERFACE_OPTIONFRAME.PreviewFrameStartPos:SetScript("OnValueChanged", function (self)   GUPPET_OPTIONS.PreviewFrameStartPos = self:GetValue() ;       end)
	_G["GupPet_PreviewFrameStartPos" .. "Text"]:SetText(GUPPET_L["PREVIEWFRAMESTARTPOS"][1])
	_G["GupPet_PreviewFrameStartPos" .. "Low"]:SetText(GUPPET_L["PREVIEWFRAMESTARTPOS"][2])
	_G["GupPet_PreviewFrameStartPos" .. "High"]:SetText(GUPPET_L["PREVIEWFRAMESTARTPOS"][3])

	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- MINIMAPBUTTON

	GUPPET_INTERFACE_OPTIONFRAME.MinimapButton = CreateFrame(
			"FRAME", "GupPet_MinimapButton", GupPet_InterfaceOptionsFrameOptions , "GupPet_FieldTemplate",
			BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.MinimapButton:SetWidth(210)
	GUPPET_INTERFACE_OPTIONFRAME.MinimapButton:SetHeight(43)
	GUPPET_INTERFACE_OPTIONFRAME.MinimapButton:SetPoint("BOTTOMLEFT", 10 , 10)
	_G["GupPet_MinimapButton" .. "SubTitle"]:SetText("|cFFFC830E".. GUPPET_L["MINIMAPBUTTONFRAME"][1])

	-- Replaced OptionsSmallCheckButtonTemplate
	GUPPET_INTERFACE_OPTIONFRAME.MinimapButtonShow = CreateFrame(
			"CheckButton", "GupPet_MinimapButtonShow"  , GUPPET_INTERFACE_OPTIONFRAME.MinimapButton,
			"OptionsBaseCheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.MinimapButtonShow:SetPoint("TOPLEFT", 10, -10 )
	GUPPET_INTERFACE_OPTIONFRAME.MinimapButtonShow:SetScript("OnClick", function (self, button, down)  GUPPET_OPTIONS["MinimapButton"]["Show"]=self:GetChecked();  GupPet_Interface_MinimapButton_Init();   end)
	GUPPET_INTERFACE_OPTIONFRAME.MinimapButtonShow:SetChecked(  GUPPET_OPTIONS["MinimapButton"]["Show"] )
	_G["GupPet_MinimapButtonShow" .. "Text"]:SetText( GUPPET_L["SHOW"][1]  )

	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- CLASS
	if GUPPET_TEMPCLASSDATA.Type == "DRUID" or GUPPET_TEMPCLASSDATA.Type == "SHAMAN" or GUPPET_TEMPCLASSDATA.Type == "MAGE" or GUPPET_TEMPCLASSDATA.Type == "DEATHKNIGHT" or GUPPET_TEMPCLASSDATA.Type == "PRIEST" or GUPPET_TEMPCLASSDATA.Type == "HUNTER" then

		GUPPET_INTERFACE_OPTIONFRAME.ClassFrame = CreateFrame(
				"FRAME", "GupPet_ClassFrame", GupPet_InterfaceOptionsFrameOptions ,
				"GupPet_FieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
		GUPPET_INTERFACE_OPTIONFRAME.ClassFrame:SetWidth(210)
		GUPPET_INTERFACE_OPTIONFRAME.ClassFrame:SetHeight(40)
		GUPPET_INTERFACE_OPTIONFRAME.ClassFrame:SetPoint("BOTTOMRIGHT", -10 , 10)
		_G["GupPet_ClassFrame" .. "SubTitle"]:SetText("|cFFFC830E".. GUPPET_L["CLASS"][1])

		if GUPPET_TEMPCLASSDATA.Type == "DRUID" then
			-- Enable / Disable --> Travel / SlowFly / FastFly / Aquatic
			GUPPET_INTERFACE_OPTIONFRAME.ClassFrame:SetWidth(230)
			GUPPET_INTERFACE_OPTIONFRAME.ClassFrame:SetHeight(95)

			GUPPET_INTERFACE_OPTIONFRAME.Inconsistent = CreateFrame(
					"CheckButton", "GupPet_Inconsistent"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.Inconsistent:SetPoint("TOPLEFT", 10, -10 )
			GUPPET_INTERFACE_OPTIONFRAME.Inconsistent:SetChecked( GUPPET_OPTIONS["Class"]["Inconsistent"]  )
			GUPPET_INTERFACE_OPTIONFRAME.Inconsistent:SetScript("OnClick", function (self, button, down) GUPPET_OPTIONS["Class"]["Inconsistent"]=self:GetChecked();  end)
			_G["GupPet_Inconsistent" .. "Text"]:SetText( GUPPET_L["DRUID_Inconsistent"])

			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Fly = CreateFrame(
					"CheckButton", "GupPet_DRUID_Fly"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Fly:SetPoint("TOPLEFT", 10, -25 )
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Fly:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["FlyForm"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Fly:SetChecked(  GUPPET_OPTIONS["Class"]["FlyForm"]  )
			_G["GupPet_DRUID_Fly" .. "Text"]:SetText( GUPPET_L["DRUID_Fly"][1]  )

			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Aquatic = CreateFrame(
					"CheckButton", "GupPet_DRUID_Aquatic"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Aquatic:SetPoint("TOPLEFT", 10, -40 )
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Aquatic:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["AquaticForm"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Aquatic:SetChecked(  GUPPET_OPTIONS["Class"]["AquaticForm"]  )
			_G["GupPet_DRUID_Aquatic" .. "Text"]:SetText( GUPPET_L["DRUID_Aquatic"][1]  )

			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Travel = CreateFrame(
					"CheckButton", "GupPet_DRUID_Travel"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Travel:SetPoint("TOPLEFT", 10, -55 )
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Travel:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["TravelOnFormWalking"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Travel:SetChecked(  GUPPET_OPTIONS["Class"]["TravelOnFormWalking"]  )
			_G["GupPet_DRUID_Travel" .. "Text"]:SetText( GUPPET_L["DRUID_Travel"][1]  )

			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Cat = CreateFrame(
					"CheckButton", "GupPet_DRUID_Cat"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Cat:SetPoint("TOPLEFT", 10, -70 )
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Cat:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["CatOnIndoors"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.DRUID_Cat:SetChecked(  GUPPET_OPTIONS["Class"]["CatOnIndoors"]  )
			_G["GupPet_DRUID_Cat" .. "Text"]:SetText( GUPPET_L["DRUID_Cat"][1]  )

		elseif GUPPET_TEMPCLASSDATA.Type == "SHAMAN" then
			-- Enable / Disable --> Ghost enable on Moving
			GUPPET_INTERFACE_OPTIONFRAME.ClassFrame:SetHeight(60)

			GUPPET_INTERFACE_OPTIONFRAME.SHAMAN_Ghost = CreateFrame(
					"CheckButton", "GupPet_SHAMAN_Ghost"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.SHAMAN_Ghost:SetPoint("TOPLEFT", 10, -10 )
			GUPPET_INTERFACE_OPTIONFRAME.SHAMAN_Ghost:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["GhostWolfOnWalking"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.SHAMAN_Ghost:SetChecked(  GUPPET_OPTIONS["Class"]["GhostWolfOnWalking"]  )
			_G["GupPet_SHAMAN_Ghost" .. "Text"]:SetText( GUPPET_L["SHAMAN_Ghost"][1]  )

			-- WaterWalking
			GUPPET_INTERFACE_OPTIONFRAME.SHAMAN_WaterWalking = CreateFrame(
					"CheckButton", "GupPet_SHAMAN_WaterWalking"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.SHAMAN_WaterWalking:SetPoint("TOPLEFT", 10, -25 )
			GUPPET_INTERFACE_OPTIONFRAME.SHAMAN_WaterWalking:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["UseWaterWalking"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.SHAMAN_WaterWalking:SetChecked(  GUPPET_OPTIONS["Class"]["UseWaterWalking"]  )
			_G["GupPet_SHAMAN_WaterWalking" .. "Text"]:SetText( GUPPET_L["SHAMAN_WaterWalking"][1]  )


		elseif GUPPET_TEMPCLASSDATA.Type == "MAGE" then
			-- Enable / Disable --> Slowfall on falling

			GUPPET_INTERFACE_OPTIONFRAME.MAGE_SlowFall = CreateFrame(
					"CheckButton", "GupPet_MAGE_SlowFall"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.MAGE_SlowFall:SetPoint("TOPLEFT", 10, -10 )
			GUPPET_INTERFACE_OPTIONFRAME.MAGE_SlowFall:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["SlowFallOnFalling"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.MAGE_SlowFall:SetChecked(  GUPPET_OPTIONS["Class"]["SlowFallOnFalling"]  )
			_G["GupPet_MAGE_SlowFall" .. "Text"]:SetText( GUPPET_L["MAGE_SlowFall"][1]  )

		elseif GUPPET_TEMPCLASSDATA.Type == "PRIEST" then
			-- Enable / Disable --> Levitate on falling

			GUPPET_INTERFACE_OPTIONFRAME.PRIEST_Levitate = CreateFrame(
					"CheckButton", "GupPet_PRIEST_Levitate"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.PRIEST_Levitate:SetPoint("TOPLEFT", 10, -10 )
			GUPPET_INTERFACE_OPTIONFRAME.PRIEST_Levitate:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["LevitateOnFalling"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.PRIEST_Levitate:SetChecked(  GUPPET_OPTIONS["Class"]["LevitateOnFalling"]  )
			_G["GupPet_PRIEST_Levitate" .. "Text"]:SetText( GUPPET_L["PRIEST_Levitate"][1]  )

		elseif GUPPET_TEMPCLASSDATA.Type == "DEATHKNIGHT" then

			GUPPET_INTERFACE_OPTIONFRAME.DEATHKNIGHT_PathOfFrost = CreateFrame(
					"CheckButton", "GupPet_DEATHKNIGHT_PathOfFrost"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.DEATHKNIGHT_PathOfFrost:SetPoint("TOPLEFT", 10, -10 )
			GUPPET_INTERFACE_OPTIONFRAME.DEATHKNIGHT_PathOfFrost:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["UsePathOfFrost"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.DEATHKNIGHT_PathOfFrost:SetChecked(  GUPPET_OPTIONS["Class"]["UsePathOfFrost"]  )
			_G["GupPet_DEATHKNIGHT_PathOfFrost" .. "Text"]:SetText( GUPPET_L["DEATHKNIGHT_PathOfFrost"][1]  )

		elseif GUPPET_TEMPCLASSDATA.Type == "HUNTER" then
			-- Enable / Disable --> Cheetah enable on Moving

			GUPPET_INTERFACE_OPTIONFRAME.HUNTER_Cheetah = CreateFrame(
					"CheckButton", "GupPet_HUNTER_Cheetah"  , GUPPET_INTERFACE_OPTIONFRAME.ClassFrame ,
					"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_OPTIONFRAME.HUNTER_Cheetah:SetPoint("TOPLEFT", 10, -10 )
			GUPPET_INTERFACE_OPTIONFRAME.HUNTER_Cheetah:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["CheetahOnWalking"] = self:GetChecked()  end)
			GUPPET_INTERFACE_OPTIONFRAME.HUNTER_Cheetah:SetChecked(  GUPPET_OPTIONS["Class"]["CheetahOnWalking"]  )
			_G["GupPet_HUNTER_Cheetah" .. "Text"]:SetText( GUPPET_L["HUNTER_Cheetah"][1]  )

		end
	end


	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- RACE
	if GUPPET_TEMPRACEDATA.Type == "Worgen" then

		GUPPET_INTERFACE_OPTIONFRAME.RaceFrame = CreateFrame(
				"FRAME", "GupPet_RaceFrame", GupPet_InterfaceOptionsFrameOptions ,
				"GupPet_FieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
		GUPPET_INTERFACE_OPTIONFRAME.RaceFrame:SetWidth(180)
		GUPPET_INTERFACE_OPTIONFRAME.RaceFrame:SetHeight(60)
		GUPPET_INTERFACE_OPTIONFRAME.RaceFrame:SetPoint( "RIGHT", -10, 0)

		GUPPET_INTERFACE_OPTIONFRAME.Worgen_RunningWild = CreateFrame(
				"CheckButton", "GupPet_Worgen_RunningWild"  , GUPPET_INTERFACE_OPTIONFRAME.RaceFrame ,
				"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
		GUPPET_INTERFACE_OPTIONFRAME.Worgen_RunningWild:SetPoint("TOPLEFT", 10, -10 )
		GUPPET_INTERFACE_OPTIONFRAME.Worgen_RunningWild:SetScript("OnClick", function (self, button, down)   GUPPET_OPTIONS["Class"]["RunningWild"] = self:GetChecked()  end)
		GUPPET_INTERFACE_OPTIONFRAME.Worgen_RunningWild:SetChecked(  GUPPET_OPTIONS["Class"]["RunningWild"]  )
		_G["GupPet_Worgen_RunningWild" .. "Text"]:SetText( GUPPET_L["Worgen_RunningWild"][1]  )

	end

	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- HELPFRAME
	GUPPET_INTERFACE_OPTIONFRAME.SlashFrame = CreateFrame(
			"FRAME", "GupPet_SlashFrame", GupPet_InterfaceOptionsFrameHelp ,
			"GupPet_FieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
	GUPPET_INTERFACE_OPTIONFRAME.SlashFrame:SetWidth(660)
	GUPPET_INTERFACE_OPTIONFRAME.SlashFrame:SetHeight(160)
	GUPPET_INTERFACE_OPTIONFRAME.SlashFrame:SetPoint("BOTTOMLEFT", 10 , 10)
	_G["GupPet_SlashFrame" .. "SubTitle"]:SetText("|cFFFC830E".. GUPPET_L["SLASHCOMMANDS"][1])

	GUPPET_INTERFACE_OPTIONFRAME.SlashCommands = CreateFrame(
			"SimpleHTML", "GupPet_Slash" , GUPPET_INTERFACE_OPTIONFRAME.SlashFrame, BackdropTemplateMixin and "BackdropTemplate" )
	GUPPET_INTERFACE_OPTIONFRAME.SlashCommands:SetWidth(640)
	GUPPET_INTERFACE_OPTIONFRAME.SlashCommands:SetHeight(50)
	GUPPET_INTERFACE_OPTIONFRAME.SlashCommands:SetPoint("TOPLEFT", 10 , -10)
	GUPPET_INTERFACE_OPTIONFRAME.SlashCommands:SetText("<html><body><p>"..
														GUPPET_S["SLASH"].."<br /><br />"..

														"'"..GUPPET_S["MULTIGROUNDMOUNT"][1] 	.."'"..	GUPPET_S["USE"]	.."'".. GUPPET_S["MULTIGROUNDMOUNT"][2] .."' ".. GUPPET_S["MULTIGROUNDMOUNT"][3] .."<br />"..
														"'"..GUPPET_S["AQUATICMOUNT"][1] 		.."'"..	GUPPET_S["USE"]	.."'".. GUPPET_S["AQUATICMOUNT"][2] 	.."' ".. GUPPET_S["AQUATICMOUNT"][3] .."<br />"..
														"'"..GUPPET_S["AUTOMOUNT"][1] 		.."'"..	GUPPET_S["USE"]	.."'".. GUPPET_S["AUTOMOUNT"][2] 			.."' ".. GUPPET_S["AUTOMOUNT"][3] .."<br />"..
														"'"..GUPPET_S["AUTOGROUNDMOUNT"][1] 	.."'"..	GUPPET_S["USE"]	.."'".. GUPPET_S["AUTOGROUNDMOUNT"][2] 	.."' ".. GUPPET_S["AUTOGROUNDMOUNT"][3] .."<br />"..
														"'"..GUPPET_S["AUTOFLYMOUNT"][1] 		.."'"..	GUPPET_S["USE"]	.."'".. GUPPET_S["AUTOFLYMOUNT"][2] 	.."' ".. GUPPET_S["AUTOFLYMOUNT"][3] .."<br />"..
														"'"..GUPPET_S["CALLCOMPANION"][1] 	.."'"..	GUPPET_S["USE"]	.."'".. GUPPET_S["CALLCOMPANION"][2] 		.."' ".. GUPPET_S["CALLCOMPANION"][3] .."<br />"..
														"'"..GUPPET_S["OPTIONMENU"][1] 		.."'"..	GUPPET_S["USE"]	.."'".. GUPPET_S["OPTIONMENU"][2] 		.."' ".. GUPPET_S["OPTIONMENU"][3] .."<br />"..

														" </p></body></html>"    )
--TODO:Fix	GUPPET_INTERFACE_OPTIONFRAME.SlashCommands:SetFontObject(GupPet_FontText)
end

local function GupPet_Interface_SortLocations (t)

	local a = {}

	for n , v in pairs(t) do

		q = { n = n , v = v }

		table.insert(a,q)
	end

	table.sort(a,function(a,b)

		if b then
			if a["v"] == b["v"] then return a["n"]<b["n"] end
			return a["v"] < b["v"]
		end

		return nil
	end
	)

	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i]["n"], a[i]["v"]
		end
	end

	return iter
end

local function GupPet_Interface_ScrollFrame_Update(frame, numItems, numToDisplay, valueStep , FrameWidth  )

	local frameName = frame:GetName()
	local scrollBar = _G[ frameName.."ScrollBar"]
	local scrollChildFrame = _G[ frameName.."ScrollChildFrame"]
	local scrollUpButton = _G[ frameName.."ScrollBarScrollUpButton"]
	local scrollDownButton = _G[ frameName.."ScrollBarScrollDownButton"]
	local scrollFrameHeight = 0
	local scrollChildHeight = 0

	if ( numItems > 0 ) then
		scrollFrameHeight = (numItems - numToDisplay) * valueStep
		scrollChildHeight = numItems * valueStep
		if ( scrollFrameHeight < 0 ) then
			scrollFrameHeight = 0
		end
		scrollChildFrame:Show()
	else
		scrollChildFrame:Hide()
	end

	scrollBar:SetMinMaxValues(0, scrollFrameHeight)
	scrollBar:SetValueStep(valueStep)
	scrollChildFrame:SetHeight(scrollChildHeight)

	if ( numItems > numToDisplay ) then
		scrollBar:Show()
		frame:SetWidth(FrameWidth-22)
	else
		frame:SetWidth(FrameWidth)
		scrollBar:Hide()
	end

	-- Arrow button handling
	if ( scrollBar:GetValue() == 0 ) then
		scrollUpButton:Disable()
	else
		scrollUpButton:Enable()
	end

	if ((scrollBar:GetValue() - scrollFrameHeight) == 0) then
		scrollDownButton:Disable()
	else
		scrollDownButton:Enable()
	end

end

function GupPet_Interface_UpdateLocationFrame()

	local i = 0
	local ShowedLocation = ""

	for SavedLocation , ZoneType in GupPet_Interface_SortLocations(GUPPET_SAVEDLOCATIONS) do
		i = i+1

		if i > GUPPET_INTERFACE_LOCATIONFRAME.Total then
			GUPPET_INTERFACE_LOCATIONFRAME[ i ] = CreateFrame(
					"Button", "GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i  ,
					GupPet_InterfaceOptionsFrameMountsCompanionsLocationsData ,
					"GupPet_OptionsListButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			GUPPET_INTERFACE_LOCATIONFRAME[ i ]:SetPoint("TOPLEFT", 0, 15 - (i*20))
		end

		if SavedLocation == GUPPET_C["M_GLOBALWORLD"] then ShowedLocation = GUPPET_C["GLOBALWORLD"]
		elseif SavedLocation == GUPPET_C["M_CITIES"]	  then ShowedLocation = GUPPET_C["CITIES"]
		elseif SavedLocation == GUPPET_C["M_INSTANCES"]   then ShowedLocation = GUPPET_C["INSTANCES"]
		elseif SavedLocation == GUPPET_C["M_ARENAS"] 	  then ShowedLocation = GUPPET_C["ARENAS"]
		elseif SavedLocation == GUPPET_C["M_BATTLEGROUNDS"] then ShowedLocation = GUPPET_C["BATTLEGROUNDS"]
		else	ShowedLocation = SavedLocation
		end


		_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i]:Show()
		_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i.."Text"]:SetText( ShowedLocation )
		_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i].Location = SavedLocation

		if  ZoneType <= 9 then
			_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i.."Text"]:SetTextColor(1,1,1)
		elseif  ZoneType <= 19 then
			_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i.."Text"]:SetTextColor(0,0.5,0)
		elseif  ZoneType <= 29 then
			_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i.."Text"]:SetTextColor(1,1,0)
		elseif  ZoneType <= 39 then
			_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i.."Text"]:SetTextColor(1,0,0)
		else
			_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i.."Text"]:SetTextColor(0,0.5,1)
		end

		if ZoneType == 0 or ZoneType == 10 or ZoneType == 20 or ZoneType == 30 or ZoneType == 40 then
			_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i.."Text"]:SetPoint("LEFT", 5, 0)
		else
			_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..i.."Text"]:SetPoint("LEFT", 20, 0)
		end
	end

	-- Hide unneedid buttons
	for q = 1 ,GUPPET_INTERFACE_LOCATIONFRAME.Total-i do
		local z = q + i
		_G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations"..z]:Hide()
	end

	GupPet_Interface_ScrollFrame_Update( _G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations" .. "Container"] , i ,20 ,20 , 190-10)

	-- Set First Active After some changes..
	GupPet_Interface_SetLocationSelected( _G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations1"] )
	GupPet_Interface_UpdateMountFrame( _G["GupPet_InterfaceOptionsFrameMountsCompanionsLocations1"].Location )

	-- Update the number of created buttons ( If more are created save that )
	if GUPPET_INTERFACE_LOCATIONFRAME.Total < i then
		GUPPET_INTERFACE_LOCATIONFRAME.Total =  i
	end

end

function GupPet_Interface_GetLocationSelected()
	return _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location
end

function GupPet_Interface_RemoveLocationSelected()

	if not( GUPPET_INTERFACE_LOCATIONFRAME.Selected == nil) then
		_G[GUPPET_INTERFACE_LOCATIONFRAME.Selected]:UnlockHighlight()
	end
end

function GupPet_Interface_SetLocationSelected( button )
	if not( GUPPET_INTERFACE_LOCATIONFRAME.Selected == nil) then
		_G[GUPPET_INTERFACE_LOCATIONFRAME.Selected]:UnlockHighlight()
	end
	button:LockHighlight()
	GUPPET_INTERFACE_LOCATIONFRAME.Selected = button:GetName()
end

local function GupPet_GetDisplayID(MountType,i)
	local displayID = GUPPET_SAVEDDATA[MountType][ i ]["displayID"]
	if not displayID then
		local allCreatureDisplays = C_MountJournal.GetMountAllCreatureDisplayInfoByID(GUPPET_SAVEDDATA[MountType][ i ]["Slot"]);
		if allCreatureDisplays and #allCreatureDisplays > 0 then
			return allCreatureDisplays[math.random(1, #allCreatureDisplays)].creatureDisplayID;
		end
	end
	return displayID
end

local function GupPet_Interface_UpdateLocalDuelFrame( Data ,  MountType )

  local t_i = 0

	for i = 1 , math.ceil(GUPPET_SAVEDDATA[ MountType ]["Total"]/2) do

		if GUPPET_OPTIONS.Mode == "Expert" then
			if ( Data.Temp- math.ceil(GUPPET_SAVEDDATA[ MountType ]["Total"]/2) < i ) then

				Data[i] = CreateFrame(
						'Slider', MountType..i , _G[ MountType .. "Data"] ,
						'GupPet_SliderTemplate', BackdropTemplateMixin and "BackdropTemplate")

				Data[i]:SetMinMaxValues(0 , 10)
				Data[i]:SetValueStep(1)
				Data[i]:SetObeyStepOnDrag(true)
			end

			_G[MountType..i]:SetValue( GUPPET_SAVEDDATA[MountType][ i ]["Weight"][ _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ] )
			_G[MountType..i]:SetScript("OnValueChanged", function (self)   GupPet_SetWeight( MountType , i , self:GetValue() , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ;       end)

		else
			if ( Data.Temp- math.ceil(GUPPET_SAVEDDATA[ MountType ]["Total"]/2) < i ) then

				Data[i] = CreateFrame(
						"CheckButton", MountType..i , _G[ MountType .. "Data"] ,
						"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			end
			_G[MountType..i]:SetChecked(GUPPET_SAVEDDATA[MountType][ i ]["Weight"][ _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ] > 0)
			_G[MountType..i]:SetScript("OnClick", function (self)
					if ( IsModifiedClick() ) then

						self:SetChecked( not self:GetChecked() )

						if ( IsModifiedClick("CHATLINK") ) then
							if ( MacroFrame and MacroFrame:IsShown() ) then
								local spellName = GetSpellInfo( GUPPET_SAVEDDATA[MountType][ i ]["Id"] )
								ChatEdit_InsertLink(spellName)
							else
								local spellLink = GetSpellLink( GUPPET_SAVEDDATA[MountType][ i ]["Id"] )
								ChatEdit_InsertLink(spellLink)
							end
						end
					else
						local tempWeight = self:GetChecked() and 1 or 0
						GupPet_SetWeight( MountType , i , tempWeight , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )
					end
				end)

		end

		_G[MountType..i ]:SetPoint('TOPLEFT', 10, 15-(i*15))
		_G[MountType..i .. "Text"]:SetText( GUPPET_SAVEDDATA[MountType][ i ]["Name"]  )
		_G[MountType..i ]:SetScript("OnEnter", function(self, button, down)	GupPet_PreviewModel:SetDisplayInfo(GupPet_GetDisplayID(MountType,i));	GupPet_Preview:Show() end)
		_G[MountType..i ]:SetScript("OnLeave", function() GupPet_Preview:Hide()	end)
		_G[MountType..i ]:Show()

		t_i = i
	end

	Data.Temp =  t_i
	Data.Max = Data.Max and max(Data.Max,Data.Temp)

	for i = 1 , GUPPET_SAVEDDATA[ MountType ]["Total"]- math.ceil(GUPPET_SAVEDDATA[ MountType ]["Total"]/2) do

		local ii = i + math.ceil(GUPPET_SAVEDDATA[ MountType ]["Total"]/2)

		if GUPPET_OPTIONS.Mode == "Expert" then
			if ( Data.Temp < ii ) then

				Data[ii] = CreateFrame(
						'Slider', MountType..ii , _G[ MountType .. "Data"] ,
						'GupPet_SliderTemplate', BackdropTemplateMixin and "BackdropTemplate")
				Data[ii]:SetMinMaxValues(0 , 10)
				Data[ii]:SetValueStep( 1)
				Data[ii]:SetObeyStepOnDrag(true)
			end

			_G[MountType..ii ]:SetValue( GUPPET_SAVEDDATA[MountType][ ii ]["Weight"][ _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ] )
			_G[MountType..ii ]:SetScript("OnValueChanged", function (self)   GupPet_SetWeight( MountType , ii , self:GetValue() , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ;       end)


		else
			if ( Data.Temp < ii ) then

				Data[ii] = CreateFrame(
						"CheckButton", MountType..ii , _G[ MountType .. "Data"] ,
						"GupPet_CheckButtonTemplate", BackdropTemplateMixin and "BackdropTemplate")
			end
			_G[MountType..ii]:SetChecked(GUPPET_SAVEDDATA[MountType][ ii ]["Weight"][ _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ]  > 0)
			_G[MountType..ii]:SetScript("OnClick", function (self)

					if ( IsModifiedClick() ) then

						self:SetChecked( not self:GetChecked() )

						if ( IsModifiedClick("CHATLINK") ) then
							if ( MacroFrame and MacroFrame:IsShown() ) then
								local spellName = GetSpellInfo( GUPPET_SAVEDDATA[MountType][ ii ]["Id"] )
								ChatEdit_InsertLink(spellName)
							else
								local spellLink = GetSpellLink( GUPPET_SAVEDDATA[MountType][ ii ]["Id"] )
								ChatEdit_InsertLink(spellLink)
							end
						end
					else
						local tempWeight = self:GetChecked() and 1 or 0
						GupPet_SetWeight( MountType , ii , tempWeight , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )
					end
			end)

		end

		_G[MountType..ii]:SetPoint('TOPLEFT', 236, 15-(i*15))
		_G[MountType..ii .. "Text"]:SetText( GUPPET_SAVEDDATA[MountType][ ii ]["Name"]  )
		_G[MountType..ii ]:SetScript("OnEnter", function(self, button, down)	GupPet_PreviewModel:SetDisplayInfo(GupPet_GetDisplayID(MountType,ii));	GupPet_Preview:Show() end)
		_G[MountType..ii ]:SetScript("OnLeave", function() GupPet_Preview:Hide()	end)
		_G[MountType..ii ]:Show()

		t_i = ii
	end

	Data.Temp =  t_i
	Data.Max = Data.Max and max(Data.Max,Data.Temp)

	if Data.Max and Data.Max > Data.Temp then --number of pets can decrease because of caging
		for i = Data.Temp + 1, Data.Max do
			_G[MountType..i]:Hide()
		end
	end

	return Data

end

function GupPet_Interface_UpdateMountFrame( Location )


	if GUPPET_INTERFACE_MAINFRAME.Init == 0 then
		GUPPET_INTERFACE_MAINFRAME.Init = 1

		-- Aquatic
		GUPPET_INTERFACE_MAINFRAME.Aquatic.Frame = CreateFrame(
				"FRAME", "Aquatic", GupPet_InterfaceOptionsFrameMountsCompanionsMainAquatic ,
				"GupPet_DataFieldTemplate", "BackdropTemplate")
 		GUPPET_INTERFACE_MAINFRAME.Aquatic.Frame:SetWidth(450); --190
		GUPPET_INTERFACE_MAINFRAME.Aquatic.Frame:SetHeight(360)
		GUPPET_INTERFACE_MAINFRAME.Aquatic.Frame:SetPoint("TOPLEFT", 0 , -30)

		_G["Aquatic" .. "SubTitle"]:SetText("|cFFFC830E ".. GUPPET_L["AQUATICMOUNT"][1]   )
		_G["Aquatic" .. "Container"]:SetWidth(418)
		_G["Aquatic" .. "Container"]:SetHeight(350)
		_G["Aquatic" .. "Enable" ]:SetScript("OnClick", function () GupPet_SetWeight( "Aquatic" , 0 , 1001 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)
		_G["Aquatic" .. "Disable"]:SetScript("OnClick", function () GupPet_SetWeight( "Aquatic" , 0 , 1000 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)

		-- GROUND
		GUPPET_INTERFACE_MAINFRAME.Ground.Frame = CreateFrame(
				"FRAME", "Ground", GupPet_InterfaceOptionsFrameMountsCompanionsMainGround ,
				"GupPet_DataFieldTemplate", "BackdropTemplate")
 		GUPPET_INTERFACE_MAINFRAME.Ground.Frame:SetWidth(450); --190
		GUPPET_INTERFACE_MAINFRAME.Ground.Frame:SetHeight(255);	--360  105
		GUPPET_INTERFACE_MAINFRAME.Ground.Frame:SetPoint("TOPLEFT", 0 , -30)

		_G["Ground" .. "SubTitle"]:SetText("")
		_G["Ground" .. "Container"]:SetWidth(418)
		_G["Ground" .. "Container"]:SetHeight(245); --350
		_G["Ground" .. "Enable" ]:SetScript("OnClick", function () GupPet_SetWeight( "Ground" , 0 , 1001 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)
		_G["Ground" .. "Disable"]:SetScript("OnClick", function () GupPet_SetWeight( "Ground" , 0 , 1000 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)

		--Multi
		GUPPET_INTERFACE_MAINFRAME.Multi.Frame = CreateFrame(
				"FRAME", "Multi", GupPet_InterfaceOptionsFrameMountsCompanionsMainGround ,
				"GupPet_DataFieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
 		GUPPET_INTERFACE_MAINFRAME.Multi.Frame:SetWidth(450); --190
		GUPPET_INTERFACE_MAINFRAME.Multi.Frame:SetHeight(105-30);	--360  105
		GUPPET_INTERFACE_MAINFRAME.Multi.Frame:SetPoint("TOPLEFT", 0 , -30-255-30)

		_G["Multi" .. "SubTitle"]:SetText(GUPPET_L["MULTIDMOUNT"][1])
		_G["Multi" .. "Container"]:SetWidth(418)
		_G["Multi" .. "Container"]:SetHeight(95-30); --350
		_G["Multi" .. "Enable" ]:SetScript("OnClick", function () GupPet_SetWeight( "Multi" , 0 , 1001 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)
		_G["Multi" .. "Disable"]:SetScript("OnClick", function () GupPet_SetWeight( "Multi" , 0 , 1000 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)

		--FLY
		GUPPET_INTERFACE_MAINFRAME.Fly.Frame = CreateFrame(
				"FRAME", "Fly", GupPet_InterfaceOptionsFrameMountsCompanionsMainFly ,
				"GupPet_DataFieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
 		GUPPET_INTERFACE_MAINFRAME.Fly.Frame:SetWidth(450); --190
		GUPPET_INTERFACE_MAINFRAME.Fly.Frame:SetHeight(360)
		GUPPET_INTERFACE_MAINFRAME.Fly.Frame:SetPoint("TOPLEFT", 0 , -30)

		_G["Fly" .. "SubTitle"]:SetText("")
		_G["Fly" .. "Container"]:SetWidth(418)
		_G["Fly" .. "Container"]:SetHeight(350)
		_G["Fly" .. "Enable" ]:SetScript("OnClick", function () GupPet_SetWeight( "Fly" , 0 , 1001 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)
		_G["Fly" .. "Disable"]:SetScript("OnClick", function () GupPet_SetWeight( "Fly" , 0 , 1000 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)


		-- Companion
		GUPPET_INTERFACE_MAINFRAME.Companion.Frame = CreateFrame(
				"FRAME", "Companion", GupPet_InterfaceOptionsFrameMountsCompanionsMainCompanion ,
				"GupPet_DataFieldTemplate", BackdropTemplateMixin and "BackdropTemplate")
 		GUPPET_INTERFACE_MAINFRAME.Companion.Frame:SetWidth(450); --190
		GUPPET_INTERFACE_MAINFRAME.Companion.Frame:SetHeight(360)
		GUPPET_INTERFACE_MAINFRAME.Companion.Frame:SetPoint("TOPLEFT", 0 , -30)

		_G["Companion" .. "SubTitle"]:SetText("|cFFFC830E ".. GUPPET_L["COMPANION"][1] .." ".. GUPPET_L["COMPANION"][2])
		_G["Companion" .. "Container"]:SetWidth(418)
		_G["Companion" .. "Container"]:SetHeight(350)
		_G["Companion" .. "Enable"]:SetScript("OnClick", function () GupPet_SetWeight( "Companion" , 0 , 1001 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)
		_G["Companion" .. "Disable"]:SetScript("OnClick", function () GupPet_SetWeight( "Companion" , 0 , 1000 , _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location ) ; GupPet_Interface_UpdateMountFrame( _G[GUPPET_INTERFACE_LOCATIONFRAME.Selected].Location )  end)

	end

	---------------------------------------------------
	GUPPET_INTERFACE_MAINFRAME.Aquatic = GupPet_Interface_UpdateLocalDuelFrame( GUPPET_INTERFACE_MAINFRAME.Aquatic ,  "Aquatic" )
	GupPet_Interface_ScrollFrame_Update( _G["Aquatic" .. "Container"] , math.ceil(GUPPET_INTERFACE_MAINFRAME.Aquatic.Temp/2) ,23 ,15 , 440)
	---------------------------------------------------
	GUPPET_INTERFACE_MAINFRAME.Ground = GupPet_Interface_UpdateLocalDuelFrame( GUPPET_INTERFACE_MAINFRAME.Ground ,  "Ground" )
	GupPet_Interface_ScrollFrame_Update( _G["Ground" .. "Container"] , math.ceil(GUPPET_INTERFACE_MAINFRAME.Ground.Temp/2) ,23-7 ,15 , 440)
	---------------------------------------------------

	---------------------------------------------------
	GUPPET_INTERFACE_MAINFRAME.Multi = GupPet_Interface_UpdateLocalDuelFrame( GUPPET_INTERFACE_MAINFRAME.Multi ,  "Multi" )
	GupPet_Interface_ScrollFrame_Update( _G["Multi" .. "Container"] , math.ceil(GUPPET_INTERFACE_MAINFRAME.Multi.Temp/2) ,4 ,15 , 440)
	---------------------------------------------------
	GUPPET_INTERFACE_MAINFRAME.Fly = GupPet_Interface_UpdateLocalDuelFrame( GUPPET_INTERFACE_MAINFRAME.Fly ,  "Fly" )
	GupPet_Interface_ScrollFrame_Update( _G["Fly" .. "Container"] , math.ceil(GUPPET_INTERFACE_MAINFRAME.Fly.Temp/2) ,23 ,15 , 440)
	---------------------------------------------------

	---------------------------------------------------

	GUPPET_INTERFACE_MAINFRAME.Companion = GupPet_Interface_UpdateLocalDuelFrame( GUPPET_INTERFACE_MAINFRAME.Companion ,  "Companion" )
	GupPet_Interface_ScrollFrame_Update( _G["Companion" .. "Container"] , math.ceil(GUPPET_INTERFACE_MAINFRAME.Companion.Temp/2) ,23 ,15 , 440)
end

function GupPet_IconPopupFrame_Update(self)

	local icons = GetMacroItemIcons(GetMacroIcons())
	local numIcons = #icons

	local PopupOffset = FauxScrollFrame_GetOffset(GupPet_IconPopupScrollFrame)

	local texture
	for i=1, 20 do
		local PopupButton = _G["GupPet_IconPopupButton"..i]
		local PopupIcon = _G["GupPet_IconPopupButton"..i.."Icon"]
		local index = (PopupOffset * 5) + i
--		texture = "Interface\\Icons\\" .. icons[index]
		texture = icons[index]
		if ( index <= numIcons ) then
			if(type(texture) == "number") then
				PopupIcon:SetTexture(texture)
			else
				PopupIcon:SetTexture("INTERFACE\\ICONS\\"..texture)
			end
			PopupButton.MyTexture = PopupIcon:GetTexture()
			PopupButton:Show()
		else
			PopupIcon:SetTexture("")
			PopupButton:Hide()
		end

		if (GupPet_IconPopupFrame.selectedIconTexture ==  PopupIcon:GetTexture() ) then
			PopupButton:SetChecked(true)
		else
			PopupButton:SetChecked(false)
		end
	end

	FauxScrollFrame_Update(GupPet_IconPopupScrollFrame, ceil(numIcons / 5) , 4, 36 )
end

local function GupPet_IconPopupButton_SelectTexture(selectedIconTexture)
	GupPet_IconPopupFrame.selectedIconTexture = selectedIconTexture

	if GupPet_Interface_GetSelected( "IconTabs" ) == "GupPet_IconPopupFrameTab1" then
		GUPPET_OPTIONS.IngameButton.Icons.Ground =  GupPet_IconPopupFrame.selectedIconTexture
	elseif GupPet_Interface_GetSelected( "IconTabs" ) == "GupPet_IconPopupFrameTab2" then
		GUPPET_OPTIONS.IngameButton.Icons.Fly =  GupPet_IconPopupFrame.selectedIconTexture
	elseif GupPet_Interface_GetSelected( "IconTabs" ) == "GupPet_IconPopupFrameTab3" then
		GUPPET_OPTIONS.IngameButton.Icons.Auto =  GupPet_IconPopupFrame.selectedIconTexture
	elseif GupPet_Interface_GetSelected( "IconTabs" ) == "GupPet_IconPopupFrameTab4" then
		GUPPET_OPTIONS.IngameButton.Icons.Companion =  GupPet_IconPopupFrame.selectedIconTexture
	end

	GupPet_Interface_IngameButtons_UpdateIcons()
end

function GupPet_IconPopupButton_OnClick(self, button)
	GupPet_IconPopupButton_SelectTexture(self.MyTexture)
	GupPet_IconPopupFrame_Update()
end

function GupPet_IconPopupFrame_TabClick()

	if GupPet_Interface_GetSelected( "IconTabs" ) == "GupPet_IconPopupFrameTab1" then
		GupPet_IconPopupFrame.selectedIconTexture  = GUPPET_OPTIONS.IngameButton.Icons.Ground
	elseif GupPet_Interface_GetSelected( "IconTabs" ) == "GupPet_IconPopupFrameTab2" then
		GupPet_IconPopupFrame.selectedIconTexture  = GUPPET_OPTIONS.IngameButton.Icons.Fly
	elseif GupPet_Interface_GetSelected( "IconTabs" ) == "GupPet_IconPopupFrameTab3" then
		GupPet_IconPopupFrame.selectedIconTexture  = GUPPET_OPTIONS.IngameButton.Icons.Auto
	elseif GupPet_Interface_GetSelected( "IconTabs" ) == "GupPet_IconPopupFrameTab4" then
		GupPet_IconPopupFrame.selectedIconTexture  = GUPPET_OPTIONS.IngameButton.Icons.Companion
	end

	GupPet_IconPopupFrame_Update()
end

function GupPet_IconPopupFrame_RestoreEdit()

	GUPPET_OPTIONS.IngameButton.Icons = { 	Ground = "Interface\\Icons\\Ability_Mount_Mammoth_Black" ,
											Fly = "Interface\\Icons\\Ability_Mount_Drake_Bronze" ,
											Auto = "Interface\\Icons\\Ability_Mount_Drake_Azure" ,
											Companion = "Interface\\Icons\\INV_Box_PetCarrier_01" }
	GupPet_Interface_IngameButtons_UpdateIcons()
	GupPet_IconPopupFrame_Update()
end

local function GupPet_Interface_MinimapButton_UpdatePosition()

	_G["GupPet_MinimapButton"]:SetPoint("TOPLEFT","Minimap","TOPLEFT",54 - (GUPPET_OPTIONS.MinimapButton.Radius * cos(GUPPET_OPTIONS.MinimapButton.Position)),(GUPPET_OPTIONS.MinimapButton.Radius * sin(GUPPET_OPTIONS.MinimapButton.Position)) - 55	)

end

function GupPet_Interface_MinimapButton_Init()

	if GUPPET_OPTIONS.MinimapButton.Show then
		_G["GupPet_MinimapButton"]:Show()
	else
		_G["GupPet_MinimapButton"]:Hide()
	end

	GupPet_Interface_MinimapButton_UpdatePosition()
end


----------------------------------------------------------------------------------------------------------------
--[[	GupPet_Interface_MinimapButton_OnDrag																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_Interface_MinimapButton_OnDrag()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70
	ypos = ypos/UIParent:GetScale()-ymin-70

	local v = math.deg(math.atan2(ypos, xpos))
	if v < 0 then
		v = v + 360
	end
	GUPPET_OPTIONS.MinimapButton.Position = v

	GupPet_Interface_MinimapButton_UpdatePosition()

end
