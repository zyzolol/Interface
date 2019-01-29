
local me = { name = "soulshatter"}
local mod = thismod
mod[me.name] = me

--[[
Soulshatter.lua

events, as they occur in order:

<order>, <spellid>, <target>, <event>
1) 29858, no targets, spell_cast_success
	(small delay)
2) 29858, <target x>, spell_resist

]]

-- constants:
me.spellid = 29858		-- spellid of soulshatter (this is the one we want)
me.resistwait = 1.0		-- max time between cast and resists
me.multiplyfactor = 0.5	-- threat multiplication from soulshatter

-- variables
me.resists = { }			-- key = mob guid, value = any non-nil
me.casttime = 0			-- gettime of last spell_success
me.isactive = false		-- cast is happening

	-- uncomment for debug
	me.mytraces = 
	{
		default = "info",
	}

--[[
------------------------------------------------------------------------
			Services from CombatEvents.lua
------------------------------------------------------------------------
]]

me.filters = 
{
	fromme =  
	{
		source = { affiliation = "mine", objecttype = "player", control = "player" },
	},
}

me.mycombatevents = 
{
	SPELL_MISSED = me.filters.fromme,
	SPELL_CAST_SUCCESS = me.filters.fromme,
}

me.oncombatevent = function(...)
	
	local timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags, spellid = select(1, ...)
	
	-- match spellid
	if spellid ~= me.spellid then
		return
	end
	
	-- debug
	if mod.trace.check("info", me, "anyevent") then
		mod.trace.printf("Got a soulshatter from me. event = %s, dest = %s.", eventname, tostring(destname))
	end
	
	-- start cast
	if eventname == "SPELL_CAST_SUCCESS" then
		
		-- debug
		if mod.trace.check("info", me, "start") then
			mod.trace.printf("Starting soulshatter.")
		end
		
		-- set state
		me.isactive = true
		me.casttime = GetTime()
	
	elseif eventname == "SPELL_MISSED" then
		
		-- check for active state
		if me.isactive == false then
			
			-- error and exit
			if mod.trace.check("info", me, "badmiss") then
				mod.trace.printf("Unexpected soulshatter miss with it was not active.")
			end
			
			return
		end
		
		-- normal case: add to resist data
		me.resists[destguid] = nil
	
	end
	
end

--[[
------------------------------------------------------------------------
			Services from Updates.lua
------------------------------------------------------------------------
]]

me.myonupdates = 
{	
	updatetimeout = 1.0
}

me.updatetimeout = function()
	
	-- ignore unless cast is active
	if me.isactive == false then
		return
	end
	
	-- wait for timeout
	if GetTime() < me.casttime + me.resistwait then
		return
	end
	
	-- cast on any remaining targets
	-- TODO: think of a less coupled solution
	for mobguid, data in pairs(mod.mythreat.datalookup) do
		
		-- target must not have resisted
		if not me.resists[mobguid] then
			
			mod.mythreat.multiplytarget(mobguid, me.multiplyfactor)
		end
	end
	
	-- clean up resist table
	for key, value in pairs(me.resists) do
		me.resists[key] = nil
	end
	
	-- set state
	me.isactive = false
	
end