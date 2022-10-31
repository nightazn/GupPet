local function GupP_Mount_CanFlyThisContinent()

	-- To avoid errors
	if InCombatLockdown() then return false end

	local continent = MapUtil.GetMapParentInfo(C_Map.GetBestMapForUnit("player"), Enum.UIMapType.Continent).mapID

	-- Added for Zerith Mortis - thanks to curse user houseofmabel
	if continent == 2374 then 	-- Zerith Mortis zone
		if not IsSpellKnown(366736) then -- Zerith Mortis flying
			return false
		end
	elseif continent == 875 or continent == 876 then -- BfA - thanks to user yuret2003 for the spellID
		 if not IsSpellKnown(278833) then
			return false
		 end
	elseif continent == 619 then -- Broken Isles
		if not IsSpellKnown(233368) then	-- Broken Isles Pathfinder
			return false
		end

	-- Looks like (a) this is not needed anymore and (b) it doesn't work anyway.
	-- Basically if you can fly anywhere, you can fly in Draenor too.

	--elseif continent == 572 then -- Draenor
	--	if not IsSpellKnown(191645) then	-- Draenor Pathfinder
	--		return false
	--	end
	elseif continent == 12 -- Kalimdor
		or continent == 13 -- Eastern Kingdom
		or continent == 101 -- Outland
		or continent == 424 -- Pandaria
		or continent == 113 -- Northrend
		or continent == 948 then -- Maelstrom (Deepholm)

		if not select(13,GetAchievementInfo(890)) then	-- Expert Riding
			return false
		end
	else
		return true
	end
end

function GupPet_CanFly()

	-- Changes added by grimmtooth@gmail.com to accommodate warfront 20-man scenarios and other
	-- misfit toys such as island expeditions
	-- Crude but effective.

	local mapID = C_Map.GetBestMapForUnit("player")
	-- Uncomment this to get a debug of the zone you're in, handy for when they add
	-- new zones to the mix.
    --print(format("Map ID = [%d]", mapID))

	-- list of zones that don't return proper 'can fly' values so we have to override by brute force
	local oddZones = {
		649,	-- Legion - Helheim
		695,	-- Legion - Skyhold
		726,	-- Legion - Shaman Maelstrom

		1203, 	-- BfA - Darkshore warfront
		1044,	-- BfA - Arathi warfront
		1355,	-- BfA - Nazjatar

		-- Island Expeditions - thanks to 'milotic03' @Curse
		1036,	-- Dread Chain
		1336,	-- Havenswood
		1337, 	-- Jorundall
		1035, 	-- Molten Cray
		1033, 	-- Rotting Mire
		981, 	-- Un'gol Ruins
		1032, 	-- Skittering Hollow
		1034, 	-- Verdant Wilds
		1037,  	-- Whispering Reef
		1502,  	-- Snowblossom Village

		-- N'zoth Assaults
		1570,	-- The Summer Terrace (Pandaria)
	}

	if tContains(oddZones, mapID) then
		if mapID == 1355 and IsSpellKnown(278833) then -- BfA - thanks to user yuret2003 for the spellID
			return true
		else
			return false
		end
	end

	-- end local changes by grimmtooth

	if  not(IsFlyableArea()) then
		return false
	else

		if  GupP_Mount_CanFlyThisContinent() == false  then
			return false
		end

		-- Check for active World PVP
		for i=1, GetNumWorldPVPAreas() do
			local _, localizedName, isActive = GetWorldPVPAreaInfo(i)
			if localizedName == GetZoneText() and isActive then
				return false
			end
		end

		return true
	end
end

function GupPet_Exit()

	if IsMounted() then

		Dismount()
		return true

	elseif UnitInVehicle("player")  then

		VehicleExit()
		return true
	else
		return false
	end
end

function GupPet_AutoMultiGround()

	if GupPet_PreMounten( "Multi" ) then return end -- If you can mount return

end

function GupPet_AutoMounten()

	if GupPet_Exit() then return end	-- If you exit something return

	if GupPet_CanFly() then
		if GupPet_AutoFly() then return end -- If you can fly return
	end

	if GupPet_AutoGround() then return end -- If you can mount return

end

function GupPet_AutoGround()
	if GupPet_Exit() then return end ;	-- If you exit something return
	if IsSwimming() then
		if GupPet_PreMounten( "Aquatic" ) then
			return
		end
	end -- If you can swim then swim ;p

	if GupPet_PreMounten( "Ground" ) then
		return true end

	return false
end

function GupPet_AutoFly()
	if GupPet_Exit() then
		return
	end ;	-- If you exit something return

	if GupPet_PreMounten( "Fly" ) then
		return true
	end

	return false
end

function GupPet_AutoDismount( dismount ) --what it do?
	if dismount then
		GupPetFrame:RegisterEvent("UI_ERROR_MESSAGE")
		GUPPET_OPTIONS["AutoDismount"] = true
	else
		GupPetFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		GUPPET_OPTIONS["AutoDismount"] = false
	end
end

local function GupPet_Mounten( MountType , Location   )
	if C_MountJournal.GetNumMounts() == 0  then
		return
	end

	--Delay pet summoning so if you got a small amount off lag you wont get kicked off your mount again
	if GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed then
		GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed = -3
	end

	-- Summon Chauffeur for lowlvl chars without riding skill
	local apprenticeRiding = select(13,GetAchievementInfo(891))
	local hasChauffeur = select(4,GetAchievementInfo(9909)) -- Collect 35 Heirlooms
	if not apprenticeRiding and hasChauffeur then
		local playerfaction = UnitFactionGroup("player")

		for i, mountID in ipairs(C_MountJournal.GetMountIDs()) do
			local _, spellID = C_MountJournal.GetMountInfoByID(mountID)
			if spellID then
				if spellID == 179244 and  playerfaction == "Horde" then
					C_MountJournal.SummonByID(mountID)
					return
				end
				if spellID == 179245 and playerfaction == "Alliance" then
					C_MountJournal.SummonByID(mountID)
					return
				end
			end
		end
	end
	--|

	local MountSlots = {}
	local Total = 0

	for i = 1 , GUPPET_SAVEDDATA[ MountType ]["Total"] do

		if GUPPET_SAVEDDATA[ MountType ][i]["Weight"][ Location ] > 0 then

			for q = 1 , GUPPET_SAVEDDATA[ MountType ][i]["Weight"][ Location ] do

				Total = Total + 1
				MountSlots[Total] = GUPPET_SAVEDDATA[ MountType ][i]["Id"]
			end
		end
	end

	if Total > 0 then

		local randomMount =  math.random(Total)

		for i, mountID in ipairs(C_MountJournal.GetMountIDs()) do
            local _, spellID = C_MountJournal.GetMountInfoByID(mountID)
			if spellID then
				if MountSlots[randomMount] == spellID then
					C_MountJournal.SummonByID(mountID)
					return
				end
			end
		end
	end
end

function GupPet_PreMounten( MountType )

	local Location = GetRealZoneText()

	-- First check if you got something enabled for this Location
	if GUPPET_SAVEDLOCATIONS[ Location ] then

		if GUPPET_SAVEDDATA[MountType]["TotalWeight"][ Location ] > 0 then
			GupPet_Mounten( MountType , Location )
			return true
		end
	end

	local _, instanceType = IsInInstance()

	if ( IsResting() ) then
		Location = GUPPET_C["M_CITIES"]
	elseif ( instanceType == "pvp" ) then
		Location = GUPPET_C["M_BATTLEGROUNDS"]
	elseif ( instanceType == "arena" ) then
		Location = GUPPET_C["M_ARENAS"]
	elseif ( instanceType == "party" or instanceType == "raid" ) then
		Location = GUPPET_C["M_INSTANCES"]
	else
		Location = GUPPET_C["M_GLOBALWORLD"]
	end

	if GUPPET_SAVEDDATA[MountType]["TotalWeight"][ Location ] > 0 then
		GupPet_Mounten( MountType , Location )
		return true
	end

	if GUPPET_SAVEDDATA[MountType]["TotalWeight"][ GUPPET_C["M_GLOBALWORLD"] ] > 0 then
		GupPet_Mounten( MountType , GUPPET_C["M_GLOBALWORLD"] )
		return true
	end

	return false
end
