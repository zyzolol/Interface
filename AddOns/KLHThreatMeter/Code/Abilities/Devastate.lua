
-- module setup
local me = { name = "devastate"}
local mod = thismod
mod[me.name] = me

--[[
Devastate for 0-4 sun.
]]

--[[
me.mytraces = 
{
	default = "info",
}
]]

me.filters = 
{
	fromme = 
	{
		source = { affiliation = "mine", objecttype = "player", control = "player" },
	},
	none = { },
}

me.mycombatevents = 
{
	SPELL_AURA_APPLIED_DOSE = me.filters.none,
	SPELL_AURA_APPLIED = me.filters.none,
	SPELL_DAMAGE = me.filters.fromme,
}

me.devastate = 
{
	[20243] = true,
	[30016] = true,
	[30022] = true,
}

me.sunder = 
{
	[7386] = true,
	[7405] = true,
	[8380] = true,
	[11596] = true,
	[11597] = true,
	[25225] = true,
}

me.pending = { } -- key = mob guid, value = time

-- cleanup
me.myonupdates =
{
	checkpending = 1.0,
}

-- timeout old pendings
me.checkpending = function()
	
	local timenow = GetTime()
	
	for key, value in pairs(me.pending) do
		
		if timenow > value + 1 then
			me.pending[key] = nil
		end
	end
end


me.oncombatevent = function(timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags, spellid)
	
	if eventname == "SPELL_DAMAGE" then
		
		-- check spell = devastate
		if me.devastate[spellid] == nil then
			return
		end
		
		me.pending[destguid] = GetTime();
		
	elseif eventname == "SPELL_AURA_APPLIED_DOSE" or eventname == "SPELL_AURA_APPLIED" then
		
		-- check spell = sunder
		if me.sunder[spellid] == nil then
			return
		end
		
		-- check valid pending
		if me.pending[destguid] and GetTime() < me.pending[destguid] + 1 then
			
			-- add sunder!
			
			-- log
			if mod.trace.check("info", me, "sunder") then
				mod.trace.printf("Adding a sunder threat vs '%s'", destname)
			end
			
			-- add
			mod.combat.specialattack("sunder", destguid, 0, false, 1, false)
			
			-- prevent multiple
			me.pending[destguid] = nil
		end
	end
	
end