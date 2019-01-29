
-- module setup
local me = { name = "bmschema"}
local mod = thismod
mod[me.name] = me

--[[
Boss Mod Schema

This file hosts the schema definition for boss mods. Here is an informal description:

<bossmodset> = 
{
	(idstring) = <bossmod>,		
	(idstring) = <bossmod>,
	...
}

<bossmod> = 
{
	mobid = (integer; wow mob id)
	debuffs = <debuffset>,
	attacks = <attackset>,
	speech = <speechset>,
	casts = <castset>,
}
debuffs, attacks, speech, casts are all optional.

<debuffset> = 
{
	(idstring) = <debuff>
	...
}

Similarly <attackset> is list of <attack>, also <speechset> and <castset>.

<debuff> = 
{
	spellid = (integer; wow spell id)
	multiplier = (number; threat multiplier while the debuff is active)
}
<attacks> = 
{
	spellid = (integer; wow spell id)
	hitsonly = (true or nil; whether the effect only works when it doesn't miss (resist etc))
	multiplier = (number; instant multiplier on threat vs casting mob)
}
<casts> = 		(note: these always cause full reset on <bossmod.mobid>)
{
	spellid = (integer; wow spell id)
	[event] = (optional: one of the values in "castevents" enum below)
}
<speech> = 
{
	source = (string; localisation key)		-- optional: defaults to <bossmodset.idstring>
}
]]

me.myenums = 
{
	castevents = { "SPELL_CAST_SUCCESS", "SPELL_AURA_APPLIED", "SPELL_AURA_REMOVED" }
}

me.mytypes = 
{
	lookup_bossmodset = 
	{
		type = "lookup",
		keytype = "string_any",
		valuetype = "class_bossmod",
	},
	
	string_any = 
	{
		type = "string",
	},
	
	class_bossmod = 
	{
		type = "class",
		schema = 
		{
			mobid = "number_wowid",
			debuffs = "lookup_debuffset",
			attacks = "lookup_attackset",
			casts = "lookup_castset",
			speech = "lookup_speechset",
		}
	},
	
	number_wowid = 
	{
		type = "number",
		integer = true,
		min = 1,
	},
	
	lookup_debuffset = 
	{
		type = "lookup",
		keytype = "string_any",
		valuetype = "class_debuff",
		nullable = true,
	},
	
	lookup_attackset = 
	{
		type = "lookup",
		keytype = "string_any",
		valuetype = "class_attack",
		nullable = true,
	},
	
	lookup_castset = 
	{
		type = "lookup",
		keytype = "string_any",
		valuetype = "class_cast",
		nullable = true,
	},
	
	lookup_speechset = 
	{
		type = "lookup",
		keytype = "string_any",
		valuetype = "class_speech",
		nullable = true,
	},
	
	class_debuff = 
	{
		type = "class",
		schema = 
		{
			spellid = "number_wowid",
			multiplier = "number_nonnegative",
		},
	},
	
	number_nonnegative = 
	{
		type = "number",
		min = 0,
	},
	
	class_attack = 
	{
		type = "class",
		schema = 
		{
			spellid = "number_wowid",
			hitsonly = "literal_truenull",
			multiplier = "number_nonnegative",
		}
	},
	
	literal_truenull = 
	{
		type = "literal",
		nullable = true,
		value = true,
	},
	
	class_cast = 
	{
		type = "class",
		schema = 
		{
			spellid = "number_wowid",
			event = "string_event",
		}
	},
	
	string_event = 
	{
		type = "string",
		nullable = true,
		enum = "castevents",
	},
	
	class_speech = 
	{
		type = "class",
		schema = 
		{
			source = "string_anynull",
		}
	},
	
	string_anynull = 
	{
		type = "string",
		nullable = true,
	},
}