
-- module setup
local me = { name = "bmimplementation"}
local mod = thismod
mod[me.name] = me

--[[
note: every <speech> and <casts> entry does a reset on <bossmod.mobid>
<attacks> entries will work for all mobs who cast that attack. Similarly <debuffs> aren't really associated with the particular boss.
]]

me.mybossmods = 
{
	-- Karazhan
	attumen = 
	{
		mobid = 15550,
		speech = 
		{
			mount = { }
		},
		casts = 
		{
			mount = { spellid = 29770 }
		},
	},
	
	nightbane = 
	{
		mobid = 17225,
		speech = 
		{
			land1 = { },
			land2 = { },
		},
	},
	
	-- Outdoor / Misc
	doomwalker = 
	{
		mobid = 17711,
		casts = 
		{
			overrun = { spellid = 32636 }, -- todo: check. may gain as buff or not be recorded. 32637 for spell he casts on others.
		}
	},
	
	-- Serpentshrine
	hydross = 
	{
		mobid = 21216,
		speech = 
		{
			swap1 = { },
			swap2 = { },
		},
	},
	
	leotheras = 
	{
		mobid = 21215,
		speech = 
		{
			swap = { },
		},
		casts = 
		{
			whirlwind = 
			{ 
				spellid = 37640, 
				event = "SPELL_AURA_REMOVED",
			},
		},
	},
	
	-- Tempest Keep
	voidreaver = 
	{
		mobid = 19516,
		attacks = 
		{
			knockaway = 
			{
				spellid = 25778,
				multiplier = 0.75,
				hitsonly = true,
			}
		}
	},
		
	kaelthas = 
	{
		mobid = 19622,
		speech = 
		{
			phase3 = { },
			phase4 = { },
			phase4b = { },
		}
	},
	
	bloodboil = 
	{
		mobid = 22948,
		debuffs = 
		{
			insignificance = 
			{
				spellid = 40618,
				multiplier = 0,
			},
			-- todo: make this a full reset, not just debuff multiplier. 
			felrage = 
			{
				spellid = 40604,
				multiplier = 0,
			},
		},
		attacks = 
		{
			-- not 100% sure what's going on here. Possibly one is cast after a natural aggro transition, and one is cast periodically.
			eject1 = 
			{
				spellid = 40486,
				multiplier = 0.75,
			},
			eject2 = 
			{
				spellid = 40597,
				multiplier = 0.75,
			},
		}
	},
	
	supremus = 
	{
		mobid = 22898,
		speech = 
		{
			phase1 = { },
		},
	},
	
	reliquary = 
	{
		mobid = 23420,
		debuffs = 
		{
			-- can't tell which one it is
			seethe1 = 
			{
				spellid = 41520,
				multiplier = 3.0,
			},
			seethe2 = 
			{
				spellid = 41364,
				multiplier = 3.0,
			}
		}
	},
	
	illidan = 
	{
		mobid = 22917,
		casts = 
		{
			summonblade = 
			{
				spellid = 39855,
			},
		},
		speech = 
		{
			phase3 = { },
			phase4 = { },
			phase5 = { },
		}
	}
}