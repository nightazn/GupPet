---------------------------------------------------------------------------------------------------------------
--[[	Gup_MountData				 																		]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--[[
	The Mounts are split in speeds/type by there spellid for less cpu power then extract it out of the tooltip.

	--GROUND--		--FLY--		--AQUATIC--		--SPECIAL--
	1 				10 			20 				30

	21 = SeaLegs
	2  = Aq40

]]

Gup_MountData = {
[61465]={[1]=true,[30]=true},--Grand Black War Mammoth
[61467]={[1]=true,[30]=true},--Grand Black War Mammoth
[122708]={[1]=true,[30]=true},--Grand Expedition Yak
[61469]={[1]=true,[30]=true},--Grand Ice Mammoth
[61470]={[1]=true,[30]=true},--Grand Ice Mammoth
[55531]={[1]=true,[30]=true},--Mechano-hog
[60424]={[1]=true,[30]=true},--Mekgineer's Chopper
[61425]={[1]=true,[30]=true},--Traveler's Tundra Mammoth
[61447]={[1]=true,[30]=true},--Traveler's Tundra Mammoth
-- Qiraji
-- [26055]={[1]=true,[2]=true},--Yellow Qiraji Battle Tank
-- [26054]={[1]=true,[2]=true},--Red Qiraji Battle Tank
-- [26056]={[1]=true,[2]=true},--Green Qiraji Battle Tank
-- [25953]={[1]=true,[2]=true},--Blue Qiraji Battle Tank
-- Not listed in Wowhead under mounts --
[60136]={[1]=true,[30]=true},--Grand Caravan Mammoth
[60140]={[1]=true,[30]=true},--Grand Caravan Mammoth
[61466]={[1]=true,[30]=true},--Grand Black War Mammoth
-- FLYING MOUNTS ----------------------------------------------------------
[60025]={[10]=true},--Albino Drake
[96503]={[10]=true},--Amani Dragonhawk
[63844]={[10]=true},--Argent Hippogryph
[139595]={[10]=true},--Armored Bloodwing
[142478]={[10]=true},--Armored Blue Dragonhawk
[61230]={[10]=true},--Armored Blue Wind Rider
[142266]={[10]=true},--Armored Red Dragonhawk
[136400]={[10]=true},--Armored Skyscreamer
[61229]={[10]=true},--Armored Snowy Gryphon
[132117]={[10]=true},--Ashen Pandaren Phoenix
[40192]={[10]=true},--Ashes of Al'ar
[127170]={[10]=true},--Astral Cloud Serpent
[123992]={[10]=true},--Azure Cloud Serpent
[59567]={[10]=true},--Azure Drake
[41514]={[10]=true},--Azure Netherwing Drake
[59650]={[10]=true},--Black Drake
[59976]={[10]=true},--Black Proto-Drake
[107842]={[10]=true},--Blazing Drake
[74856]={[10]=true},--Blazing Hippogryph
[72808]={[10]=true},--Bloodbathed Frostbrood Vanquisher
[61996]={[10]=true},--Blue Dragonhawk
[59568]={[10]=true},--Blue Drake
[59996]={[10]=true},--Blue Proto-Drake
[39803]={[10]=true},--Blue Riding Nether Ray
[32244]={[10]=true},--Blue Wind Rider
[59569]={[10]=true},--Bronze Drake
[58615]={[10]=true},--Brutal Nether Drake
[124550]={[10]=true},--Cataclysmic Gladiator's Twilight Drake
[43927]={[10]=true},--Cenarion War Hippogryph
[139448]={[10]=true},--Clutch of Ji-Kun
[41515]={[10]=true},--Cobalt Netherwing Drake
[97560]={[10]=true},--Corrupted Fire Hawk
[102514]={[10]=true},--Corrupted Hippogryph
[127156]={[10]=true},--Crimson Cloud Serpent
[129552]={[10]=true},--Crimson Pandaren Phoenix
[88990]={[10]=true},--Dark Phoenix <-- Flying Guild Mount
[64927]={[10]=true},--Deadly Gladiator's Frost Wyrm
[126507]={[10]=true},--Depleted-Kyparium Rocket
[88335]={[10]=true},--Drake of the East Wind
[88742]={[10]=true},--Drake of the North Wind
[88744]={[10]=true},--Drake of the South Wind
[88741]={[10]=true},--Drake of the West Wind
[32239]={[10]=true},--Ebon Gryphon
[194464]={[10]=true},--Eclipse Dragonhawk
[175700]={[10]=true},--Emerald Drake
[149801]={[10]=true},--Emerald Hippogryph
[132118]={[10]=true},--Emerald Pandaren Phoenix
[142878]={[10]=true},--Enchanted Fey Dragon
[110039]={[10]=true},--Experiment 12-B
[113120]={[10]=true},--Feldrake
[97501]={[10]=true},--Felfire Hawk
[61451]={[10]=true},--Flying Carpet
[65439]={[10]=true},--Furious Gladiator's Frost Wyrm
[126508]={[10]=true},--Geosynchronous World Spinner
[123993]={[10]=true},--Golden Cloud Serpent
[32235]={[10]=true},--Golden Gryphon
[135416]={[10]=true},--Grand Armored Gryphon
[135418]={[10]=true},--Grand Armored Wyvern
[136163]={[10]=true},--Grand Gryphon
[136164]={[10]=true},--Grand Wyvern
[61294]={[10]=true},--Green Proto-Drake
[39798]={[10]=true},--Green Riding Nether Ray
[32245]={[10]=true},--Green Wind Rider
[148619]={[10]=true},--Grievous Gladiator's Cloud Serpent
[110051]={[10]=true},--Heart of the Aspects
[127169]={[10]=true},--Heavenly Azure Cloud Serpent
[127161]={[10]=true},--Heavenly Crimson Cloud Serpent
[127164]={[10]=true},--Heavenly Golden Cloud Serpent
[127165]={[10]=true},--Heavenly Jade Cloud Serpent
[127158]={[10]=true},--Heavenly Onyx Cloud Serpent
[72807]={[10]=true},--Icebound Frostbrood Vanquisher
[124659]={[10]=true},--Imperial Quilen
[201098]={[10]=true},--Infinite Timereaver
[153489]={[10]=true},--Iron Skyreaver
[63956]={[10]=true},--Ironbound Proto-Drake
[113199]={[10]=true},--Jade Cloud Serpent
[133023]={[10]=true},--Jade Pandaren Kite
[107845]={[10]=true},--Life-Binder's Handmaiden
[139407]={[10]=true},--Malevolent Gladiator's Cloud Serpent
[44744]={[10]=true},--Merciless Nether Drake
[63796]={[10]=true},--Mimiron's Head
[93623]={[10]=true},--Mottled Drake
[121820]={[1]=true,[10]=true,[30]=true},--Obsidian Nightwing
[127154]={[10]=true},--Onyx Cloud Serpent
[41513]={[10]=true},--Onyx Netherwing Drake
[69395]={[10]=true},--Onyxian Drake
[118737]={[10]=true},--Pandaren Kite
[130985]={[10]=true},--Pandaren Kite
[32345]={[10]=true},--Peep the Phoenix Mount
[88718]={[10]=true},--Phosphorescent Stone Drake
[60021]={[10]=true},--Plagued Proto-Drake
[148620]={[10]=true},--Prideful Gladiator's Cloud Serpent
[97493]={[10]=true},--Pureblood Fire Hawk
[41516]={[10]=true},--Purple Netherwing Drake
[39801]={[10]=true},--Purple Riding Nether Ray
[61997]={[10]=true},--Red Dragonhawk
[59570]={[10]=true},--Red Drake
[59961]={[10]=true},--Red Proto-Drake
[39800]={[10]=true},--Red Riding Nether Ray
[67336]={[10]=true},--Relentless Gladiator's Frost Wyrm
[63963]={[10]=true},--Rusted Proto-Drake
[101821]={[10]=true},--Ruthless Gladiator's Twilight Drake
[93326]={[10]=true,[30]= true},--Sandstone Drake
[66087]={[10]=true},--Silver Covenant Hippogryph
[39802]={[10]=true},--Silver Riding Nether Ray
[191633]={[10]=true},--Soaring Skyterror
[171828]={[10]=true},--Solar Spirehawk
[148392]={[10]=true},--Spawn of Galakras
[107516]={[10]=true},--Spectral Gryphon
[107517]={[10]=true},--Spectral Wind Rider
[32240]={[10]=true},--Snowy Gryphon
[147595]={[10]=true},--Stormcrow
[66088]={[10]=true},--Sunreaver Dragonhawk
[32242]={[10]=true},--Swift Blue Gryphon
[32290]={[10]=true},--Swift Green Gryphon
[32295]={[10]=true},--Swift Green Wind Rider
[37015]={[10]=true},--Swift Nether Drake
[32292]={[10]=true},--Swift Purple Gryphon
[32297]={[10]=true},--Swift Purple Wind Rider
[32289]={[10]=true},--Swift Red Gryphon
[32246]={[10]=true},--Swift Red Wind Rider
[32296]={[10]=true},--Swift Yellow Wind Rider
[32243]={[10]=true},--Tawny Wind Rider
[60002]={[10]=true},--Time-Lost Proto-Drake
[129918]={[10]=true},--Thundering August Cloud Serpent
[139442]={[10]=true},--Thundering Cobalt Cloud Serpent
[124408]={[10]=true},--Thundering Jade Cloud Serpent
[148476]={[10]=true},--Thundering Onyx Cloud Serpent
[132036]={[10]=true},--Thundering Ruby Cloud Serpent
[59571]={[10]=true},--Twilight Drake
[107844]={[10]=true},--Twilight Harbinger
[148618]={[10]=true},--Tyrannical Gladiator's Cloud Serpent
[49193]={[10]=true},--Vengeful Nether Drake
[41517]={[10]=true},--Veridian Netherwing Drake
[101282]={[10]=true},--Vicious Gladiator's Twilight Drake
[41518]={[10]=true},--Violet Netherwing Drake
[132119]={[10]=true},--Violet Pandaren Phoenix
[60024]={[10]=true},--Violet Proto-Drake
[88746]={[10]=true},--Vitreous Stone Drake
[88331]={[10]=true},--Volcanic Stone Drake
[71810]={[10]=true},--Wrathful Gladiator's Frost Wyrm
[75973]={[1]=true,[10]=true,[30]= true},--X-53 Touring Rocket
-- AQUATIC MOUNTS ---------------------------------------------------------
[75207]={[20]=true,[21]=true},--Abyssal Seahorse
[30174]={[20]=true},--Riding Turtle
[64731]={[20]=true},--Sea Turtle
[98718]={[20]=true},--Subdued Seahorse
-- Legion 7.0.3 -----------------------------------------------------------
[214791]={[20]=true},--Brinedeep Bottom-Feeder
[227989]={[10]=true},--Cruel  Gladiator's Storm Dragon
[227995]={[10]=true},--Demonic Gladiator's Storm Dragon
[223018]={[20]=true},--Fathom Dweller
[227988]={[10]=true},--Fearless Gladiator's Storm Dragon
[227991]={[10]=true},--Ferocious Gladiator's Storm Dragon
[227994]={[10]=true},--Fierce Gladiator's Storm Dragon
[227986]={[10]=true},--Vindictive Gladiator's Storm Dragon
---------------------------------------------------------------------------
-- 7.1.x
[228919]={[20]=true},--Darkwater Skate
[231428]={[10]=true},--Smoldering Ember Wyrm
-- 7.2 class mounts
[229385]={[1]=true,[10]=true,class="MONK"},--Бань Лу, спутник великого мастера
[229377]={[1]=true,[10]=true,class="PRIEST"},--Верный Свету дозорный верховного жреца
[229388]={[1]=true,[10]=true,class="WARRIOR"},--Кровожадный боевой змей воеводы
[229387]={[1]=true,[10]=true,class="DEATHKNIGHT"},--Нечестивый завоеватель владыки смерти
[229417]={[1]=true,[10]=true,class="DEMONHUNTER"},--Покоренный Скверной крылан истребителя
[229376]={[1]=true,[10]=true,class="MAGE"},--Призматический диск верховного мага
[231442]={[1]=true,[10]=true,class="SHAMAN"},--Яростная буря предсказателя

[229386]={[1]=true,[10]=true,class="HUNTER"},--Верный звероястреб верховного следопыта
[229438]={[1]=true,[10]=true,class="HUNTER"},--Яростный звероястреб верховного следопыта
[229439]={[1]=true,[10]=true,class="HUNTER"},--Лютый звероястреб верховного следопыта

[231434]={[1]=true,[10]=true,class="ROGUE"},--Убийственный предвестник теневого клинка
[231523]={[1]=true,[10]=true,class="ROGUE"},--Смертоносный предвестник теневого клинка
[231524]={[1]=true,[10]=true,class="ROGUE"},--Губительный предвестник теневого клинка
[231525]={[1]=true,[10]=true,class="ROGUE"},--Кровавый предвестник теневого клинка

[231435]={[1]=true,[10]=true,class="PALADIN"},--Золотой скакун верховного лорда
[231587]={[1]=true,[10]=true,class="PALADIN"},--Мстительный скакун верховного лорда
[231588]={[1]=true,[10]=true,class="PALADIN"},--Бдительный скакун верховного лорда
[231589]={[1]=true,[10]=true,class="PALADIN"},--Доблестный скакун верховного лорда

[232412]={[1]=true,[10]=true,class="WARLOCK"},--Хаотический скакун гнева повелителя Пустоты
[238452]={[1]=true,[10]=true,class="WARLOCK"},--Серный скакун гнева повелителя Пустоты
[238454]={[1]=true,[10]=true,class="WARLOCK"},--Проклятый скакун гнева повелителя Пустоты
-- old class mounts
[48778]={[1]=true,class="DEATHKNIGHT"},--Acherus Deathcharger
[54729]={[1]=true,[10]=true,class="DEATHKNIGHT"},--Winged Steed of the Ebon Blade
[66906]={[1]=true,class="PALADIN"},--Argent Charger

[73629]={[1]=true,class="PALADIN"},
[73630]={[1]=true,class="PALADIN"},
[13819]={[1]=true,class="PALADIN"},
[23214]={[1]=true,class="PALADIN"},
[34769]={[1]=true,class="PALADIN"},
[34767]={[1]=true,class="PALADIN"},
[69820]={[1]=true,class="PALADIN"},
[69826]={[1]=true,class="PALADIN"},
[23161]={[1]=true,class="WARLOCK"},
[5784]={[1]=true,class="WARLOCK"},
-- BfA
[264058]={[1]=true,[30]=true},--Mighty Caravan Brutosaur
}




