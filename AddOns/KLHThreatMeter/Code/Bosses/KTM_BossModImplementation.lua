
-- module setup
local me = { name = "bossimp"}
local mod = thismod
mod[me.name] = me

--[[

--> STOP PRESS: Major Brainstorm: Since speech names and spell names are kept different, for KTM internal bossmods we don't need speech / spells sections!

--> debuffs can be anonymous. But you have to say type=debuff.

------------------------------------------------------------
							Speech
------------------------------------------------------------

1) The key in the speech table points to ("boss" - "speech" - <key>), or ("boss" - "speech" - <bossid><key>), whichever one we can find.

2) Inside a speech entry, put setmt = true to set the master target, and put reset=true to reset threat.

3) for MT sets, it will always go to bossname if the boss is defined. If someone hasn't localised the boss name, they won't have localised the speech either, so no problem there. If there is no bossname, it will go to the source.


------------------------------------------------------------
							Spells
------------------------------------------------------------

1) Make sure not to double up for debuffs that cause damage. e.g. is a spell triggers from damage, but you already have a debuff with the same name, then don't proc it.

2) You can specify the exact combat log message type with e.g. event="buffend" / event="spellcast"




Custom Handlers:

You have access to these 3 variables:
1) <me>
2) <mod>
3) <data>

For speech, data has
1) speaker
2) text
3) matches = { <list> }

For spells, data has
1) source
2) target
3) event
4) result
5) number

event = "spell", "cast", "begincast", "debuff", "buff", "buffend"

spell and debuff are against you. others only involve the boss. Except cast which may or may not have a target.


------------------------------------------------------------
							Index
------------------------------------------------------------

1) Bosses before TBC:

	a) Molten Core
		Shazzrah
		Ragnaros
		
	b) Blackwing Lair
		Razorgore
		Nefarian
		Firemaw
		Flamegor
		Ebonroc
		
	c) Zul'gurub
		Thekal
		
	d) Ahn'Qiraj
		Rajaxx
		Ouro
		
	e)	Outdoor / Misc
		Azuregos
		Onyxia
		
	f) Naxxramus
		Noth
		Loatheb
		Horsemen
		Loatheb
		Patchwerk
	

2) The Burning Crusade

	a) Karazhan
	 	Attumen
		Nightbane

	b) Outdoor / Misc
		Magtheridon
		Doomwalker
		
	c) Sperpentshrine
		Hydross
		Leotheras
		Morogrim
		Vashj
		
	d) Tempest Keep
		Void Reaver
		Kael'Thas
		Solarian
	
	e) Black Temple
		Bloodboil
]]

me.mybossmods = 
{
	-- 1) Bosses before TBC:
	
	-- 1a) Molten Core
	shazzrah = 
	{
		shazzrahgate = 
		{
			reset = true,
		}
	},
	
	ragnaros = 
	{
		pull = 
		{
			setmt = true,
		},
		wrathofragnaros = 
		{
			reset = true,
		},
	},
	
	-- 1b) Blackwing Lair
	razorgore = 
	{
		pull = 
		{
			setmt = true,
			reset = true,
		}
	},
	
	nefarian = 
	{
		pull = 
		{
			setmt = true,
			reset = true,
		}
	},
	
	firemaw = 
	{
		wingbuffet = 
		{
			multiplier = 0.5,
		},
	},
	
	flamegor = 
	{
		wingbuffet = 
		{
			multiplier = 0.5,
		},
	},
	
	ebonroc = 
	{
		wingbuffet = 
		{
			multiplier = 0.5,
		},
	},
	
	-- 1c) Zul'Gurub
	thekal = 
	{
		phase2 = 
		{
			setmt = true,
			reset = true,
		}
	},
	
	-- 1d) Ahn'Qiraj
	rajaxx = 
	{
		pull = 
		{
			setmt = true,
			reset = true,
		},
		ignore = 
		{
			customhandler = function(speechresult)
				
				local match = string.match(speechresult.message, speechresult.localtext)
				if match == UnitName("player") then
					local threat = -0.5 * mod.table.getraidthreat()
					mod.combat.lognormalevent(mod.string.get("threatsource", "threatwipe"), 1, 0, threat)
				end
			end
		}
	},
	
	ouro = 
	{
		sandblast = 
		{
			multiplier = 0,
			hitsonly = true,
		}
	},
	
	-- 1e) Outdoor / Misc
	azuregos = 
	{
		port = 
		{
			customhandler = function()
				
				-- 1) Find Azuregos
				local bossfound = false
				
				for x = 1, 40 do
					
					if UnitClassification("raid" .. x .. "target") == "worldboss" then
						if CheckInteractDistance("raid" .. x .. "target", 4) then
							mod.table.resetraidthreat()
						end
						
						bossfound = true
						break
					end	
				end
				
				-- couldn't find anyone targetting Azuregos. Better reset just to be sure.
				if bossfound == false then
					mod.table.resetraidthreat()
				end
				
			end,
		}
	},
	
	onyxia = 
	{
		pull = 
		{
			setmt = true
		},
		fireball = 
		{
			customhandler = function(spellresult)
				-- this will be a TODO until the format of other stuff is decided.
			end
		},
		knockaway = 
		{
			hitsonly = true,
			multiplier = 0.75,
		},
	},

	-- 1e) Naxxramus
	noth = 
	{
		pull1 = 
		{
			setmt = true,
		},
		pull2 = 
		{
			setmt = true,
		},
		pull3 = 
		{
			setmt = true,
		},
		nothblink = 
		{
			reset = true,
		}
	},

	loatheb = 
	{
		fungalbloom = 
		{ 
			multiplier = 0,
			event = "debuff",
		}
	},

	horsemen = 
	{
		mark1 = 
		{
			multiplier = 0.5,
			event = "debuff",
		},
		mark2 = 
		{
			multiplier = 0.5,
			event = "debuff",
		},	
		mark3 = 
		{
			multiplier = 0.5,
			event = "debuff",
		},	
		mark4 = 
		{
			multiplier = 0.5,
			event = "debuff",
		},	
	},

	patchwerk = 
	{
		hatefulstrike = 
		{
			customhandler = function()
				-- TODO depending on format
			end
		}
	},

	-- 2) The Burning Crusade
	
	-- 2a) Karazhan
	attumen = 
	{
		mount =
		{
			setmt = true,
			reset = true,
		}
	},
	
	nightbane = 
	{
		pull = 
		{
			setmt = true,
		},
		land1 = 
		{
			reset = true,
		},
		land2 = 
		{
			reset = true,
		}
	},
	
	-- 2b) Outdoor / Misc
	magtheridon = 
	{
		pull = 
		{
			reset = true,
			setmt = true,
		}
	},
	
	doomwalker = 
	{
		overrun = 
		{
			reset = true,
		}
	},
	
	-- 2c) Serpentshrine
	hydross = 
	{
		pull = 
		{
			setmt = true,
			reset = true,
		},
		swap1 = 
		{
			reset = true,
		},
		swap2 = 
		{
			reset = true,
		},
	},
	
	leotheras = 
	{
		pull = 
		{
			setmt = true,
			reset = true,
		},
		swap = 
		{
			reset = true,
		},
		whirlwind = 
		{
			event = "buffend",
			reset = true,
		}
	},
	
	morogrim = 
	{
		pull = 
		{
			setmt = true,
		}
	},
	
	vashj = 
	{
		pull1 = { setmt = true },
		pull2 = { setmt = true },
		pull3 = { setmt = true },
		pull4 = { setmt = true },
	},
	
	-- 2d) Tempest Keep
	voidreaver = 
	{
		knockaway = 
		{
			multiplier = 0.75,
			hitsonly = true,
		}
	},
	
	kaelthas = 
	{
		phase1a = { reset = true },
		phase1b = { reset = true },
		phase1c = { reset = true },
		phase2 = { reset = true },
		phase3 = { reset = true },
		phase4 = { reset = true, setmt = true},
		phase4b = { reset = true, setmt = true },
	},
	
	solarian = 
	{
		pull = { setmt = true }
	},
	
	-- 2e) Black Temple
	bloodboil = 
	{
		insignifigance = 
		{
			multiplier = 0,
		},
		felrage = 
		{
			multiplier = 0,
		},
		eject = 
		{
			multiplier = 0.75,
			hitsonly = true,
		},
	},
	
	supremus = 
	{
		phase1 = { reset = true },
	},
	
	reliquary = 
	{
		seethe = 
		{
			multiplier = 3.0,
			event = "debuff",
		},
		phase2 = 
		{
			setmt = true,
			reset = true,
		},
		phase3 = 
		{
			setmt = true,
			reset = true,
		},
	},
	
	illidan = 
	{
		phase1 = 
		{
			setmt = true,
		},
		
		-- this is a spell not a yell!
		summonblade = 
		{ 
			reset = true,
			source = "azzinothblade",
		},
		
		-- wtb: first p3...
		
		phase3 = { reset = true },
		phase4 = { reset = true },
		phase5 = { reset = true },
	}
}