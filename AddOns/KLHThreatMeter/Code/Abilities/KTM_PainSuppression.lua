
local me = { name = "painsuppression"}
local mod = thismod
mod[me.name] = me

me.filters = 
{
	onme =  
	{ 
		dest = { objecttype = "player", affiliation = "mine" } 
	},
}

me.mycombatevents = 
{
	SPELL_AURA_APPLIED = me.filters.onme,
}

me.spellid = 33206

me.oncombatevent = function(...)
	
	local timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags, spellid = select(1, ...)
	
	if eventname == "SPELL_AURA_APPLIED" then
				
		if spellid == me.spellid then
			
			mod.mythreat.multiplyall(0.95)
			
		end
	end

end

	