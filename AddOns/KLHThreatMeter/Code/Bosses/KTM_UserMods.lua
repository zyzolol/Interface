
-- module setup
local me = { name = "bossuser"}
local mod = thismod
mod[me.name] = me

me.mods = { } --[[
me.mods = { <mod_1>, <mod_2>, <mod_3> }

<mod_i> = 
{
	author = <string>
	bossname = <string>, 		-- localised boss name. May be nil if the actual name isn't needed
	spells = 
	{
		list of <spelldata>
	},
	speech = 
	{
		list of {<speechdata>}
	}
}

<spelldata> = 
{
	localtext, bossmod, [, source, reset, setmt, multiplier, customhandler, event]
}

<speechdata> = 
{
	localtext, bossmod, [, source, reset, setmt, customhandler]
}
]]

me.newemptymod = function()
	
	return 
	{
		author = UnitName("player") .. "@" .. GetRealmName(),
		bossname = "",
		spells = { },
		speech = { },
	}

end
	
