function SoundAlerter:GetSpellList ()
	return {
		auraApplied = {					-- aura applied [spellid] = ".mp3 file name",
			--Races
			--[58984] = "Shadowmeld", different in TBC
			[26297] = "Berserking",
			[20594] = "stoneform",
			[20572] = "BloodFury",
			[33697] = "BloodFury", 
			[33702] = "BloodFury",
			[7744] = "willoftheforsaken",
			[28880] = "giftofthenaaru",
			--Druid
			[29166] = "innervate",
			[22812] = "barkskin",
			[17116] = "NaturesSwiftness", 
			[27009] = "NaturesGrasp",
			[26999] = "frenziedRegeneration", 
			[1850] = "Dash",
			--Paladin
			[10278] = "handOfProtection",
			[1044] = "handOfFreedom",
			[1020] = "divineShield",
			[27148] = "Sacrifice",
			[5573] = "divineprotection", -- fix ogg
			[31884] = "AvengingWrath",
			--Rogue
			[11305] = "sprint",
			[31224] = "cloakOfShadows",
			[13750] = "adrenalineRush",
			[26669] = "evasion", 
			--Warrior
			--[1719] = "Recklessness",
			--[871] = "shieldWall", --works
			--[20230] = "Retaliation", --works
			[12975] = "LastStand",	
			[23920] = "SpellReflection",
			[12328] = "sweepingStrikes",
			[12292] = "deathWish",
			--Priest
			[33206] = "painSuppression",
			[10060] = "powerInfusion",
			[6346] = "fearWard",
			--Shaman
			[30823] = "shamanisticRage",
			[974] = "earthShield",
			[16190] = "manaTide",
			[16188] = "NaturesSwiftness2",
			[2825] = "Bloodlust",
			[32182] = "Heroism",
			--Mage
			[45438] = "iceBlock",
			[12042] = "arcanePower",
			[12472] = "icyveins",
			[12043] = "PresenceOfMind",
			[28682] = "combustion",
			--Hunter
			[34471] = "theBeastWithin",
			[19263] = "deterrence",	
			--Warlock
			[17941] = "shadowtrance", --need ogg
			[18708] = "Feldom", --fix ogg
		},
		auraRemoved = {
			--Warrior
			[12292] = "deathWishdown",
			[12975] = "laststanddown", -- no sound
			[23920] = "spellreflectdown",
			--Paladin
			[498] = "DivineProtectionDown", 
			[10278] = "protectionDown",
			[1020] = "bubbleDown",
			--Rogue
			[31224] = "cloakDown",
			[26669] = "evasionDown", --works 
			--Priest
			[33206] = "PSDown", --works
			--Mage
			[45438] = "iceBlockDown",
			--Hunter
			[19263] = "Deterrencedown",
			[34471] = "beastwithindown",
		},
		castStart = {
			--general
			[25213] = "bigHeal", -- Greater Heal Rank 7
			[27136] = "bigHeal", -- Holy Light Rank 11
			[25396] = "bigHeal", -- Healing Wave Rank 12
			[2008] = "resurrection", -- Shaman rezz rank 1
			[25590] = "resurrection", -- Shaman rezz rank 1
			[7328] = "resurrection", -- Pala rezz rank 1
			[20773] = "resurrection", -- Pala rezz rank 5
			[2006] = "resurrection", -- Priest rezz rank 1
			[25435] = "resurrection", -- Priest rezz rank 6
			--druid
			[18658] = "hibernate", -- Hibernate Rank 3
			[2637] = "hibernate", -- Hibernate Rank 1
			[33786] = "cyclone",  --works
			[2912] = "starfire",
			--paladin
			[10326] = "turnEvil", --unimplemented
			--rogue
			--warrior
			--priest		
			[8129] = "manaBurn", -- Rank 1
			[25380] = "manaBurn", -- Rank 7
			[10912] = "mindControl",
			--shaman
			-- add manatide
			[2825] = "bloodlust",
			[32182] = "heroism",
			[16190] = "manaTide",
			--mage
			[118] = "polymorph", -- rank 1 polymorph
			[12826] = "polymorph", -- rank 4 polymorph
			[28272] = "polymorph", -- polymorph pig
			[28271] = "polymorph", -- polymorph turtle
			--Hunter
			[982] = "revivePet", 
			[1513] = "scareBeast", -- rank 1
			[14327] = "scareBeast", -- rank 3
			[27065] = "aimedshot", -- rank 7
			--Warlock
			[5782] = "fear", -- rank 1
			[6215] = "fear", -- rank 3
			[5484] = "fear2", -- Howl of Terror rank 1
			[17928] = "fear2", --Howl of Terror rank 2
			[710] = "banish", -- rank 1
			[18647] = "banish", -- rank 2
			[688] = "summonpet", --works
			[691] = "summonpet", --works
			[712] =  "summonpet", --works
			[697] = "summonpet", --works
			[30146] = "summonpet", --felguard, works
		},
		castSuccess = { --Used for abilities that affect the player
			[26297] = "berserking", --works
			[20594] = "stoneform",
			[20572] = "BloodFury", --works
			[33697] = "BloodFury", --works
			[33702] = "BloodFury", --works
			[7744] = "willoftheforsaken",
			[28880] = "giftofthenaaru",
			[42292] = "trinket",
			--mage
			[12051] = "evocation",
			[11958] = "coldSnap",
			[2139] = "counterspell",
			[66] = "Invisibility",
			--hunter
			[23989] = "readiness", 
			[19386] = "wyvernSting", 
			[34490] = "silencingshot",
			[14311] = "freezingtrap", --double check
			[1499] = "freezingtrap", --double check
			[14310] = "freezingtrap", --double check
			[32419] = "freezingtrap", --freezing trap effect
			[13810] = "frosttrap", --frost trap
			[13809] = "frosttrap", --frost trap aura
			--warlock
			[17928] = "fear2", --Howl of Terror
			[19647] = "spellLock",
			--[6789] = "deathcoil",-- old
			[27223] = "deathcoil",-- works
			[6358] = "Seduction",
			--paladin
			[20066] = "repentance", --works
			[10308] = "hammerofjustice", --works
			--[31884] = "AvengingWrath", --works
			--rogue
			[11297] = "sap", --works
			[6770] = "sap",
			[2094] = "blind", --works
			[1766] = "kick", --works
			[14185] = "preparation", --works
			[26889] = "vanish", --works
			[13877] = "bladeflurry", --works
			[1787] = "stealth",	--works
			--shaman
			[2825] = "bloodlust",
			[32182] = "heroism",
			[8143] = "TremorTotem", --works
			[8177] = "Grounding", --works
			--warrior
			[2457] = "battlestance",
			[71] = "defensestance",
			[2458] = "berserkerstance",
			[676] = "disarm", --works
			[5246] = "fear3", --intimidating shout, works
			[6552] = "pummel", --works
			[6554] = "pummel", -- r2
			[72] = "shieldBash", --works rank 1
			[29704] = "shieldBash", --works rank 4
			--priest
			[10890] = "fear4", -- Psychic Scream
			[34433] = "shadowFiend", -- works
			[25437] = "desperatePrayer", --works
			[15487] = "silence",
		},
		enemyDebuffs = {
			[2094] = "Enemyblinded", --works
			[11297] = "Enemysapped", --works
			[6770] = "Enemysapped",
			[118] = "EnemyPollied", -- rank 1 polymorph
			[12826] = "EnemyPollied", -- rank 4 polymorph
			[28272] = "EnemyPollied", -- polymorph pig
			[28271] = "EnemyPollied", -- polymorph turtle
			[33786] = "EnemyCycloned",--menu
			[5782] = "enemyfeared", 
			[6215] = "enemyfeared", 
			[17928] = "enemyfeared",
			
		},
		enemyDebuffdown = {
			[2094] = "BlindDown", --works
			[11297] = "sapdown", --works
			[6770] = "sapdown",
			[118] = "polydown",
			[12826] = "polydown",
			[28272] = "polydown", -- polymorph pig
			[28271] = "polydown",
			[33786] = "CycloneDown", --menu
			[5782] = "feardown",
			[6215] = "feardown",
			[17928] = "feardown",
		},
		interruptFriend = {
			[2139] = "friendcountered",
			--[50613] = "friendcountered",
			[1766] = "friendcountered",
			--[57994] = "friendcountered",
			[72] = "friendcountered",
			--[47528] = "friendcountered",
		},
		friendCCcast = {
			[33786] = "cyclonefriend",
			[118] = "polyfriend", -- rank 1 polymorph
			[12826] = "polyfriend", -- rank 4 polymorph
			[28272] = "polyfriend", -- polymorph pig
			[28271] = "polyfriend", -- polymorph turtle
			[5782] = "fearfriend",
			[6215] = "fearfriend",
			[17928] = "fearfriend",
		},
		friendCCSuccess = {
			[14309] = "friendfrozen",
			[2094] = "BlindFriend",
			[5246] = "friendfeared", --intimidating shout
			[33786] = "friendcycloned",
			[10308] = "friendstunned",
			[2139] = "friendcountered",
			[118] = "friendpollied",
			[12826] = "friendpollied",
			[28272] = "friendpollied", -- polymorph pig
			[28271] = "friendpollied", -- polymorph turtle
			[6215] = "friendfeared",
			[10890] = "friendfeared",
			[17928] = "friendfeared",
			[853] = "friendstunned",
			[5782] = "friendfeared",
			[11297] = "friendsapped",
			[6770] = "friendsapped",
		},
		friendCCenemy = {
			[2094] = "EnemyBlinded",
			[11297] = "EnemySapped",
			[6770] = "EnemySapped",
			[12826] = "Enemypollied",
			[118] = "Enemypollied",
			[28272] = "EnemyPollied", -- polymorph pig
			[28271] = "EnemyPollied", -- polymorph turtle
			[33786] = "EnemyCycloned",
			[5782] = "enemyfeared",
			[6215] = "enemyfeared",
			[17928] = "enemyfeared",
		},
		friendCCenemyDown = {
			[2094] = "BlindDown",
			[11297] = "sapdown",
			[6770] = "sapdown",
			[12826] = "polydown",
			[118] = "polydown",
			[28272] = "polydown", -- polymorph pig
			[28271] = "polydown", -- polymorph turtle
			[33786] = "CycloneDown",
			[5782] = "feardown",
			[6215] = "feardown",
			[17928] = "feardown",
		},
	}
end
--args = listOptions({58984,26297,20594,20572,7744,28880},"auraApplied"),


--PlaySoundFile(""..sadb.sapath..list[spellID]..".mp3");