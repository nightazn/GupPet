--[[ 	GupPet by Gup 	]]--

-- TEMP VARS
GUPPET_INTERFACE_INGAMEBUTTONS 	= { Init = 0}


function GupPet_Interface_BuildMacro( self, option )

	-- To avoid errors
	if InCombatLockdown() then return end

	self:SetAttribute("ctrl-macrotext1"		, "/script GupPet_AutoMultiGround()" )

	--------------------------------------------------------
	--[[	MAGE 										]]--
	--------------------------------------------------------
	if GUPPET_TEMPCLASSDATA.Type == "MAGE" and option ~= "FLY" and GUPPET_TEMPCLASSDATA["SlowFall"]["Usable"] then
		local NitroBoost = GetSpellInfo(54861)
		self:SetAttribute("alt-macrotext1", "/cancelaura "..NitroBoost.."\n/use "..GUPPET_TEMPCLASSDATA["SlowFall"]["Name"] )

		if GUPPET_OPTIONS["Class"]["SlowFallOnFalling"] and IsFalling() and not (IsMounted() or UnitInVehicle("player")) then
			self:SetAttribute("macrotext"		, "/cancelaura "..NitroBoost.."\n/use "..GUPPET_TEMPCLASSDATA["SlowFall"]["Name"] )
			return
		end
	end

	--------------------------------------------------------
	--[[	PRIEST 										]]--
	--------------------------------------------------------
	if GUPPET_TEMPCLASSDATA.Type == "PRIEST" and option ~= "FLY" and GUPPET_TEMPCLASSDATA["Levitate"]["Usable"] then

		self:SetAttribute("alt-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Levitate"]["Name"] )

		if GUPPET_OPTIONS["Class"]["LevitateOnFalling"] and IsFalling() and not (IsMounted() or UnitInVehicle("player")) then
			self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Levitate"]["Name"] )
			return
		end
	end

	--------------------------------------------------------
	--[[	HUNTER										]]--
	--------------------------------------------------------
	if GUPPET_TEMPCLASSDATA.Type == "HUNTER" and  option ~= "FLY" and GUPPET_TEMPCLASSDATA["Cheetah"]["Usable"] then

		self:SetAttribute("alt-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Cheetah"]["Name"] )

		--Cheetah on moving
		if GUPPET_OPTIONS["Class"]["CheetahOnWalking"] and  GetUnitSpeed("player") > 0 and not(IsMounted() or UnitInVehicle("player")) then
			self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Cheetah"]["Name"] )
			self:SetAttribute("shift-macrotext1", "/script GupPet_AutoGround()" )
			return
		end
		-- if you dont have any mounts
		if GUPPET_SAVEDDATA.Ground.Total == 0 then

			self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Cheetah"]["Name"])
			self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Cheetah"]["Name"])
			self:SetAttribute("alt-macrotext1"	, "/use "..GUPPET_TEMPCLASSDATA["Cheetah"]["Name"])

			return
		end
	end

	--------------------------------------------------------
	--[[	DRUID 										]]--
	--------------------------------------------------------
	if GUPPET_TEMPCLASSDATA.Type == "DRUID"   then
		local MOONKIN_FORM = MOONKIN_FORM

		if GetShapeshiftFormID() == MOONKIN_FORM then
			self:SetAttribute("ctrl-macrotext1"		, "/script GupPet_AutoMultiGround()" )
		else
			self:SetAttribute("ctrl-macrotext1"		, "/cancelform\n/script GupPet_AutoMultiGround()" )
		end
		--
		if GUPPET_TEMPCLASSDATA["Travel"]["Usable"] then
			self:SetAttribute("alt-macrotext1", "/cancelform\n/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
		end

		-- If mounted or inVehicle .. Leave and kill the rest of the event
		if GupPet_Exit()  then
			self:SetAttribute("macrotext"		  , "")
			self:SetAttribute("shift-macrotext1"  , "")
			return
		end

		-- If you are in a form kill the form only.
		if GetShapeshiftForm() and not GUPPET_OPTIONS.Class.Inconsistent  then
			self:SetAttribute("macrotext"		, "/cancelform")
			self:SetAttribute("shift-macrotext1", "/cancelform")
			self:SetAttribute("alt-macrotext1"	, "/cancelform")
			return
		end

		-- if you dont have any groundmounts
		if GUPPET_SAVEDDATA.Ground.Total == 0 then
			if GUPPET_TEMPCLASSDATA["Travel"]["Usable"] then
				self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
				self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
			end
			return
		end


		if option == "FLY" then

			if (GUPPET_OPTIONS["Class"]["FlyForm"] or IsFalling() ) and GupPet_CanFly() and GUPPET_TEMPCLASSDATA["Travel"]["Usable"] then
				self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
				self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
			elseif (GetShapeshiftFormID() == MOONKIN_FORM) then
				self:SetAttribute("macrotext"		, "/script GupPet_AutoFly()" )
				self:SetAttribute("shift-macrotext1", "/script GupPet_AutoFly()" )
			else
				self:SetAttribute("macrotext"		, "/cancelform\n/script GupPet_AutoFly()" )
				self:SetAttribute("shift-macrotext1", "/cancelform\n/script GupPet_AutoFly()" )
			end
			return

		elseif option == "GROUND" then

			if IsSwimming() and GUPPET_TEMPCLASSDATA["Travel"]["Usable"] and GUPPET_OPTIONS["Class"]["AquaticForm"] then
				self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
				self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )

			elseif GetUnitSpeed("player") > 0 and GUPPET_TEMPCLASSDATA["Travel"]["Usable"] and GUPPET_OPTIONS["Class"]["TravelOnFormWalking"] and IsOutdoors()  then
				self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
				self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )

			elseif GUPPET_TEMPCLASSDATA["Cat"]["Usable"] and GUPPET_OPTIONS["Class"]["CatOnIndoors"] and IsIndoors() then
				self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Cat"]["Name"] )
				self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Cat"]["Name"] )

			elseif GUPPET_TEMPRACEDATA.Type == "Worgen" and GUPPET_TEMPRACEDATA["RunningWild"]["Usable"] and GUPPET_OPTIONS["Class"]["RunningWild"] then
				self:SetAttribute("macrotext"		, "/cancelform\n/use "..GUPPET_TEMPRACEDATA["RunningWild"]["Name"] )
				self:SetAttribute("shift-macrotext1", "/cancelform\n/use "..GUPPET_TEMPRACEDATA["RunningWild"]["Name"] )
			elseif (GetShapeshiftFormID() == MOONKIN_FORM) then
				self:SetAttribute("macrotext"		, "/script GupPet_AutoGround()" )
				self:SetAttribute("shift-macrotext1", "/script GupPet_AutoGround()" )
			else
				self:SetAttribute("macrotext"		, "/cancelform\n/script GupPet_AutoGround()" )
				self:SetAttribute("shift-macrotext1", "/cancelform\n/script GupPet_AutoGround()" )
			end

			return

		else

			if GetUnitSpeed("player") > 0 and GUPPET_TEMPCLASSDATA["Travel"]["Usable"]  and GUPPET_OPTIONS["Class"]["TravelOnFormWalking"] then
				self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
			elseif (GetShapeshiftFormID() == MOONKIN_FORM) then
				self:SetAttribute("shift-macrotext1", "/script GupPet_AutoGround()" )
			else
				self:SetAttribute("shift-macrotext1", "/cancelform\n/script GupPet_AutoGround()" )

			end

			if GUPPET_TEMPRACEDATA.Type == "Worgen" and GUPPET_TEMPRACEDATA["RunningWild"]["Usable"] and GUPPET_OPTIONS["Class"]["RunningWild"] then

				self:SetAttribute("shift-macrotext1", "/cancelform\n/use "..GUPPET_TEMPRACEDATA["RunningWild"]["Name"] )
			else
				self:SetAttribute("shift-macrotext1", "/cancelform\n/script GupPet_AutoGround()" )
			end

			if GupPet_CanFly() and IsOutdoors() then

				if (GUPPET_OPTIONS["Class"]["FlyForm"] or IsFalling() ) and GUPPET_TEMPCLASSDATA["Travel"]["Usable"] then
					self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
				elseif (GetShapeshiftFormID() == MOONKIN_FORM) then
					self:SetAttribute("macrotext"		, "/script GupPet_AutoMounten()" )
				else
					self:SetAttribute("macrotext"		, "/cancelform\n/script GupPet_AutoMounten()" )
				end
				return

			elseif IsSwimming() and GUPPET_TEMPCLASSDATA["Travel"]["Usable"] and GUPPET_OPTIONS["Class"]["AquaticForm"] then

				self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )
				self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )

			elseif GetUnitSpeed("player") > 0 and GUPPET_TEMPCLASSDATA["Travel"]["Usable"] and GUPPET_OPTIONS["Class"]["TravelOnFormWalking"] and IsOutdoors() then

				self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] )

			elseif GUPPET_TEMPCLASSDATA["Cat"]["Usable"] and GUPPET_OPTIONS["Class"]["CatOnIndoors"] and IsIndoors() then

				self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Cat"]["Name"] )

			elseif GUPPET_TEMPRACEDATA.Type == "Worgen" and GUPPET_TEMPRACEDATA["RunningWild"]["Usable"] and GUPPET_OPTIONS["Class"]["RunningWild"] then

				self:SetAttribute("macrotext", "/cancelform\n/use "..GUPPET_TEMPRACEDATA["RunningWild"]["Name"] )
			elseif (GetShapeshiftFormID() == MOONKIN_FORM) then
				self:SetAttribute("macrotext"		, "/script GupPet_AutoGround()" )
			else
				self:SetAttribute("macrotext"		, "/cancelform\n/script GupPet_AutoGround()" )

			end


			return


		end

	end

	--------------------------------------------------------
	--[[	SHAMAN 										]]--
	--------------------------------------------------------
	if GUPPET_TEMPCLASSDATA.Type == "SHAMAN" and  option ~= "FLY" then

		if GUPPET_TEMPCLASSDATA["Ghost"]["Usable"] then
			self:SetAttribute("alt-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Ghost"]["Name"] )
		end

		-- If mounted or inVehicle .. Leave and kill the rest of the event
		if GupPet_Exit()  then
			self:SetAttribute("macrotext"		  , "")
			self:SetAttribute("shift-macrotext1"  , "")
			return
		end

		-- If you are in a form kill the form only.
		if GetShapeshiftForm() > 0 then
			self:SetAttribute("macrotext"		, "/cancelform")
			self:SetAttribute("shift-macrotext1", "/cancelform")
			self:SetAttribute("alt-macrotext1"	, "/cancelform")
			return
		end

		-- If you are swimming cast the WaterWalking
		if GUPPET_TEMPCLASSDATA["WaterWalking"]["Usable"] and  IsSwimming() and GetUnitSpeed("player") > 0 and  GUPPET_OPTIONS["Class"]["UseWaterWalking"]  then
			self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["WaterWalking"]["Name"] )
			self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["WaterWalking"]["Name"] )
			return
		end

		-- Put Ghostwolf on the button if you are moving etc
		if GUPPET_TEMPCLASSDATA["Ghost"]["Usable"] and  GetUnitSpeed("player") > 0  and  GUPPET_OPTIONS["Class"]["GhostWolfOnWalking"]  then

			self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Ghost"]["Name"] )
			self:SetAttribute("shift-macrotext1", "/script GupPet_AutoGround()" )
			return
		end

		-- if you dont have any groundmounts
		if GUPPET_SAVEDDATA.Ground.Total == 0 and GUPPET_TEMPCLASSDATA["Ghost"]["Usable"] then
			self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["Ghost"]["Name"] )
			self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["Ghost"]["Name"] )
			return
		end
	end

	--------------------------------------------------------
	--[[	DEATHKNIGHT									]]--
	--------------------------------------------------------
	if GUPPET_TEMPCLASSDATA.Type == "DEATHKNIGHT" then

		-- If you are swimming cast the PathOfFrost
		if GUPPET_TEMPCLASSDATA["PathOfFrost"]["Usable"] and  IsSwimming() and GetUnitSpeed("player") > 0 and  GUPPET_OPTIONS["Class"]["UsePathOfFrost"]  then
			self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPCLASSDATA["PathOfFrost"]["Name"] )
			self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPCLASSDATA["PathOfFrost"]["Name"] )
			return
		end

	end

	--------------------------------------------------------
	--[[	WORGEN									]]--
	--------------------------------------------------------
	if GUPPET_TEMPRACEDATA.Type == "Worgen" and not(GUPPET_TEMPCLASSDATA.Type == "DRUID") then
	--and GUPPET_TEMPRACEDATA["RunningWild"]["Usable"] and GUPPET_OPTIONS["Class"]["RunningWild"] and not(GupPet_CanFly()) and IsOutdoors() then

		if GupPet_Exit()  then
			self:SetAttribute("macrotext"		  , "")
			self:SetAttribute("shift-macrotext1"  , "")
			return
		end

		if option == "FLY" then
			self:SetAttribute("macrotext"		, "/script GupPet_AutoFly()" )
			self:SetAttribute("shift-macrotext1", "/script GupPet_AutoFly()" )
			self:SetAttribute("alt-macrotext1"	, "/script GupPet_AutoFly()" )
			return
		elseif option == "GROUND" then
			if GUPPET_TEMPRACEDATA["RunningWild"]["Usable"] and GUPPET_OPTIONS["Class"]["RunningWild"] then
				self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPRACEDATA["RunningWild"]["Name"] )
				self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPRACEDATA["RunningWild"]["Name"] )
			else
				self:SetAttribute("macrotext"		, "/script GupPet_AutoGround()" )
				self:SetAttribute("shift-macrotext1", "/script GupPet_AutoGround()" )
			end
			return
		else
			if GUPPET_TEMPRACEDATA["RunningWild"]["Usable"] and GUPPET_OPTIONS["Class"]["RunningWild"] then
				self:SetAttribute("shift-macrotext1", "/use "..GUPPET_TEMPRACEDATA["RunningWild"]["Name"] )
			else
				self:SetAttribute("shift-macrotext1", "/script GupPet_AutoGround()" )
			end

			if GupPet_CanFly() and IsOutdoors() then
				self:SetAttribute("macrotext"		, "/script GupPet_AutoFly()" )
				return
			else
				if GUPPET_TEMPRACEDATA["RunningWild"]["Usable"] and GUPPET_OPTIONS["Class"]["RunningWild"] then
					self:SetAttribute("macrotext"		, "/use "..GUPPET_TEMPRACEDATA["RunningWild"]["Name"] )
				else
					self:SetAttribute("macrotext", "/script GupPet_AutoGround()" )
				end
				return
			end
		end

	end

	--------------------------------------------------------
	--[[	REST 										]]--
	--------------------------------------------------------
	if option == "GROUND" then
		self:SetAttribute("macrotext"		, "/script GupPet_AutoGround()" )
		self:SetAttribute("shift-macrotext1", "/script GupPet_AutoGround()" )
	elseif option == "FLY" then
		self:SetAttribute("macrotext"		, "/script GupPet_AutoFly()" )
		self:SetAttribute("shift-macrotext1", "/script GupPet_AutoFly()" )
		self:SetAttribute("alt-macrotext1"	, "/script GupPet_AutoFly()" )
	else
		self:SetAttribute("macrotext"		, "/script GupPet_AutoMounten()" )
		self:SetAttribute("shift-macrotext1", "/script GupPet_AutoGround()" )
	end

	--	If your not a druid / mage / hunter / shaman / priest kill calling of this function
	if not (GUPPET_TEMPCLASSDATA.Type == "MAGE" or GUPPET_TEMPCLASSDATA.Type == "SHAMAN" or GUPPET_TEMPCLASSDATA.Type == "DRUID" or GUPPET_TEMPCLASSDATA.Type == "HUNTER" or GUPPET_TEMPCLASSDATA.Type == "DEATHKNIGHT" or GUPPET_TEMPCLASSDATA.Type == "PRIEST" or GUPPET_TEMPRACEDATA.Type == "Worgen") then

		self:SetScript("PreClick", function (self, button, down)  end)
	end

end


function GupPet_Interface_DragIngameButtons( option )

	local temp

	if option == "Reset" then

		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:ClearAllPoints()
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetPoint("CENTER",0, 0)
		temp, temp, GUPPET_OPTIONS.IngameButton.RelativePoint, GUPPET_OPTIONS.IngameButton.xOffset, GUPPET_OPTIONS.IngameButton.yOffset = GUPPET_INTERFACE_INGAMEBUTTONS.Frame:GetPoint()

	elseif option == "Show" then

	_G["GupPet_IngameFrameTemplate".."MoveTopLeft" ]:Show()
	_G["GupPet_IngameFrameTemplate".."MoveTopRight"  ]:Show()
	_G["GupPet_IngameFrameTemplate".."MoveBottomLeft"  ]:Show()
	_G["GupPet_IngameFrameTemplate".."MoveBottomRight"  ]:Show()

	elseif option == "Hide" then

	_G["GupPet_IngameFrameTemplate".."MoveTopLeft"  ]:Hide()
	_G["GupPet_IngameFrameTemplate".."MoveTopRight"  ]:Hide()
	_G["GupPet_IngameFrameTemplate".."MoveBottomLeft"  ]:Hide()
	_G["GupPet_IngameFrameTemplate".."MoveBottomRight"  ]:Hide()

	elseif option == "Start" then
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetMovable( true )
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:StartMoving()
	else

		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:StopMovingOrSizing()
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetMovable( false )

		temp, temp, GUPPET_OPTIONS.IngameButton.RelativePoint, GUPPET_OPTIONS.IngameButton.xOffset, GUPPET_OPTIONS.IngameButton.yOffset = GUPPET_INTERFACE_INGAMEBUTTONS.Frame:GetPoint()
	end

end

function GupPet_Interface_UpdateHotkeysIngameButtons (self , actie )

	local hotkey = _G[self:GetName().."HotKey"]
    local key = GetBindingKey( actie )

	local text = GetBindingText(key, "KEY_", 1)
    if ( text == "" ) then
        hotkey:SetText(RANGE_INDICATOR)
        hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -2)
        hotkey:Hide()
    else
		if not( GUPPET_OPTIONS.IngameButton.ButtonHideKeyBind ) then
			hotkey:SetText(text)
			hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", -2, -2)
			hotkey:Show()
		else
			hotkey:Hide()
		end
    end
end

function GupPet_Interface_IngameButtons()
	if GUPPET_INTERFACE_INGAMEBUTTONS.Init == 0  then

		GUPPET_INTERFACE_INGAMEBUTTONS.Frame = CreateFrame("FRAME", "GupPet_IngameFrameTemplate", UIParent , "GupPet_IngameFrameTemplate" )
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetWidth(32)
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetHeight(32)
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetClampedToScreen( true )

		GUPPET_INTERFACE_INGAMEBUTTONS.Init = 1
	end

	GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetPoint( GUPPET_OPTIONS.IngameButton.RelativePoint , GUPPET_OPTIONS.IngameButton.xOffset , GUPPET_OPTIONS.IngameButton.yOffset )
	GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetScale( GUPPET_OPTIONS.IngameButton.Scale )

	local buttonNr = 0

	_G["GupPet_IngameFrameTemplateAuto"]:Hide()
	_G["GupPet_IngameFrameTemplateGround"]:Hide()
	_G["GupPet_IngameFrameTemplateFly"]:Hide()
	_G["GupPet_IngameFrameTemplateCompanion"]:Hide()


	if GUPPET_OPTIONS.IngameButton.MountButton == "Auto" and ( GUPPET_SAVEDDATA[ "Fly" ]["Total"] > 0  or (GUPPET_TEMPCLASSDATA.Type == "DRUID" and GUPPET_TEMPCLASSDATA["Travel"]["Usable"]) ) then

			buttonNr = buttonNr + 1
			_G["GupPet_IngameFrameTemplateAuto"]:Show()
	else
		if GUPPET_SAVEDDATA[ "Ground" ]["Total"] > 0
			or (GUPPET_TEMPCLASSDATA.Type == "DRUID" and GUPPET_TEMPCLASSDATA["Travel"]["Usable"] )
			or (GUPPET_TEMPCLASSDATA.Type == "SHAMAN" and GUPPET_TEMPCLASSDATA["Ghost"]["Usable"] )
			then

			buttonNr = buttonNr + 2
			_G["GupPet_IngameFrameTemplateGround"]:Show()
		end

		if GUPPET_SAVEDDATA[ "Fly" ]["Total"] > 0
			or (GUPPET_TEMPCLASSDATA.Type == "DRUID" and GUPPET_TEMPCLASSDATA["Travel"]["Usable"] )
			then

			buttonNr = buttonNr + 4
			_G["GupPet_IngameFrameTemplateFly"]:Show()
		end
	end

	if GUPPET_OPTIONS.IngameButton.CompanionButton then

		buttonNr = buttonNr + 8
		_G["GupPet_IngameFrameTemplateCompanion"]:Show()
	end


	GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetHeight(32)

	if buttonNr == 1 then -- Auto

		_G["GupPet_IngameFrameTemplateAuto"]:SetPoint("CENTER",0,0)
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetWidth(32)

	elseif buttonNr == 2 then -- Ground

		_G["GupPet_IngameFrameTemplateGround"]:SetPoint("CENTER",0,0)
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetWidth(32)

	elseif buttonNr == 6 then	-- Ground + Fly

		_G["GupPet_IngameFrameTemplateGround"]:SetPoint("CENTER",-17.5,0)
		_G["GupPet_IngameFrameTemplateFly"]:SetPoint("CENTER",17.5,0)
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetWidth(67)

	elseif buttonNr == 8 then -- Companion

		_G["GupPet_IngameFrameTemplateCompanion"]:SetPoint("CENTER",0,0)
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetWidth(32)

	elseif buttonNr == 9 then -- Auto + Companion

		_G["GupPet_IngameFrameTemplateAuto"]:SetPoint("CENTER",-17.5,0)
		_G["GupPet_IngameFrameTemplateCompanion"]:SetPoint("CENTER",17.5,0)
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetWidth(67)

	elseif buttonNr == 10 then -- grond + Companion

		_G["GupPet_IngameFrameTemplateGround"]:SetPoint("CENTER",-17.5,0)
		_G["GupPet_IngameFrameTemplateCompanion"]:SetPoint("CENTER",17.5,0)
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetWidth(67)

	elseif buttonNr == 14 then

		_G["GupPet_IngameFrameTemplateGround"]:SetPoint("CENTER",-35,0)
		_G["GupPet_IngameFrameTemplateFly"]:SetPoint("CENTER",0,0)
		_G["GupPet_IngameFrameTemplateCompanion"]:SetPoint("CENTER",35,0)
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetWidth(102)
	end


	if GUPPET_OPTIONS.IngameButton.Alignment == "Vertical" then

		local xOfs , yOfs

		local _, _, _, xOfs, yOfs = _G["GupPet_IngameFrameTemplateGround"]:GetPoint()
		if xOfs and yOfs then
		_G["GupPet_IngameFrameTemplateGround"]:SetPoint("CENTER",yOfs,-xOfs)
		end

		local _, _, _, xOfs, yOfs = _G["GupPet_IngameFrameTemplateFly"]:GetPoint()
		if xOfs and yOfs then
		_G["GupPet_IngameFrameTemplateFly"]:SetPoint("CENTER",yOfs,-xOfs)
		end

		local _, _, _, xOfs, yOfs = _G["GupPet_IngameFrameTemplateAuto"]:GetPoint()
		if xOfs and yOfs then
		_G["GupPet_IngameFrameTemplateAuto"]:SetPoint("CENTER",yOfs,-xOfs)
		end

		local _, _, _, xOfs, yOfs = _G["GupPet_IngameFrameTemplateCompanion"]:GetPoint()
		if xOfs and yOfs then
			_G["GupPet_IngameFrameTemplateCompanion"]:SetPoint("CENTER",yOfs,-xOfs)
		end


		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetHeight( GUPPET_INTERFACE_INGAMEBUTTONS.Frame:GetWidth() )
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:SetWidth(32)
	end



	if GUPPET_OPTIONS["IngameButton"]["Show"] then
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:Show()
		RegisterStateDriver( GUPPET_INTERFACE_INGAMEBUTTONS.Frame , "visibility", "[petbattle][vehicleui] hide; show")
	else
		GUPPET_INTERFACE_INGAMEBUTTONS.Frame:Hide()
		GUPPET_OPTIONS["IngameButton"]["Show"] = false
		RegisterStateDriver( GUPPET_INTERFACE_INGAMEBUTTONS.Frame , "visibility", "hide")
	end

	if GUPPET_OPTIONS["IngameButton"]["Lock"] then
		GupPet_Interface_DragIngameButtons( "Hide" )
	else
		GupPet_Interface_DragIngameButtons( "Show" )
	end

	GupPet_Interface_UpdateHotkeysIngameButtons( _G["GupPet_IngameFrameTemplateAuto"]		, "GUPPET_AUTO" )
	GupPet_Interface_UpdateHotkeysIngameButtons( _G["GupPet_IngameFrameTemplateGround"] 		, "GUPPET_AUTOGROUND" )
	GupPet_Interface_UpdateHotkeysIngameButtons( _G["GupPet_IngameFrameTemplateFly"] 		, "GUPPET_AUTOFLY" )
	GupPet_Interface_UpdateHotkeysIngameButtons( _G["GupPet_IngameFrameTemplateCompanion"] 	, "GUPPET_CALLCOMPANION" )


end

function GupPet_Interface_IngameButtons_UpdateIcons()

 	_G["GupPet_IngameFrameTemplateAutoIcon"]:SetTexture( GUPPET_OPTIONS.IngameButton.Icons.Auto )
	_G["GupPet_IngameFrameTemplateGroundIcon"]:SetTexture( GUPPET_OPTIONS.IngameButton.Icons.Ground )
	_G["GupPet_IngameFrameTemplateFlyIcon"]:SetTexture( GUPPET_OPTIONS.IngameButton.Icons.Fly)
	_G["GupPet_IngameFrameTemplateCompanionIcon"]:SetTexture( GUPPET_OPTIONS.IngameButton.Icons.Companion)

end

function GupPet_Interface_AddMasque()
	local Masque = LibStub("Masque", true)
	if Masque then
		Masque:Group("GupPet"):AddButton(GupPet_IngameFrameTemplateAuto)
		Masque:Group("GupPet"):AddButton(GupPet_IngameFrameTemplateGround)
		Masque:Group("GupPet"):AddButton(GupPet_IngameFrameTemplateFly)
		Masque:Group("GupPet"):AddButton(GupPet_IngameFrameTemplateCompanion)
	end
end
