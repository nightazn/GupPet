local table_sort = table.sort

local LibPetJournal = LibStub("LibPetJournal-2.0")
LibPetJournal:RegisterCallback("PetListUpdated", function() GupPet_UpdateCompanionDataList();GupPet_Interface_UpdateLocationFrame() end)

local function GupPet_CallCompanion( Location )

	GupPet_Debug( Location )

	local CompanionSlots = {}
	local Total = 0
	local HasSummoned = false

	for i = 1 , GUPPET_SAVEDDATA[ "Companion" ]["Total"] do
		local IsSummoned = C_PetJournal.GetSummonedPetGUID() == GUPPET_SAVEDDATA[ "Companion" ][i]["Id"]
		if not(IsSummoned) then
			if GUPPET_SAVEDDATA[ "Companion" ][i]["Weight"][ Location ] > 0 then
				for q = 1 , GUPPET_SAVEDDATA[ "Companion" ][i]["Weight"][ Location ] do
					Total = Total + 1
					CompanionSlots[Total] = GUPPET_SAVEDDATA[ "Companion" ][i]["Id"]
				end
			end
		else
			HasSummoned = true
		end
	end

	if Total > 0 then

		local randomMount =  math.random( Total  )

		C_PetJournal.SummonPetByGUID(CompanionSlots[randomMount])

		-- Save the new pet ID
		GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.PetId = CompanionSlots[randomMount]

	elseif HasSummoned then
		GupPet_Text( GUPPET_T["CANTCALLCOMPANIONONEINTHETABLE"] )
	end
end

function GupPet_PreCallCompanion()

	local Location = GetRealZoneText()

	-- First check if you got something enabled for this Location
	if GUPPET_SAVEDLOCATIONS[ Location ] then

		if GUPPET_SAVEDDATA["Companion"]["TotalWeight"][ Location ] > 0 then
			GupPet_CallCompanion( Location )
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

	if GUPPET_SAVEDDATA["Companion"]["TotalWeight"][ Location ] > 0 then
		GupPet_CallCompanion( Location )
		return true
	end

	if GUPPET_SAVEDDATA["Companion"]["TotalWeight"][ GUPPET_C["M_GLOBALWORLD"] ] > 0 then
		GupPet_CallCompanion( GUPPET_C["M_GLOBALWORLD"] )
		return true
	end

	GupPet_Text( GUPPET_T["CANTCALLCOMPANION"] )
	return false
end

function GupPet_UpdateCompanionDataList()
	local	GUPPET_SAVEDDATA_TEMP = { Companion = { Total=0}  }
	for i, petID in LibPetJournal:IteratePetIDs() do
		local _, customName, _, _, _, displayID, _, name = C_PetJournal.GetPetInfoByPetID(petID)
		if name then
			GUPPET_SAVEDDATA_TEMP["Companion"]["Total"] = GUPPET_SAVEDDATA_TEMP["Companion"]["Total"] + 1
			if customName then
				name = customName.." ("..name..")"
			end
			GUPPET_SAVEDDATA_TEMP["Companion"][ GUPPET_SAVEDDATA_TEMP["Companion"]["Total"] ] = { Name = name, Id = petID, displayID = displayID, Weight = GupPet_CheckWeightData( "Companion" , petID ) }
		end
    end

	GUPPET_SAVEDDATA["Companion"] = GUPPET_SAVEDDATA_TEMP["Companion"]
	table_sort(GUPPET_SAVEDDATA["Companion"], function(a,b) return a.Name < b.Name end)
	GUPPET_SAVEDDATA["Companion"]["TotalWeight"] = GupPet_CheckWeightDataTotal( "Companion" )
end
