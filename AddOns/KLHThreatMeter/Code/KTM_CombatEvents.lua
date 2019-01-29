
-- module setup
local me = { name = "combatevent"}
local mod = thismod
mod[me.name] = me

--[[
CombatEvents.lua

This module does standard event filtering for other modules.

	me.mycombatevents = 
	{
		SPELL_HEAL = true,
		SWING_DAMAGE = { source = <flag>, target = <flag> }
	}
	
	<flag> = { affiliation = { "mine", }, objecttype = { "player", }, control = { "player" } } 
	
	me.oncombatevent = function(id, ...)
		
	See me.flags below.
]]

me.data = { } --[[
{
	<eventname> = 
	{
		<modulename> = 
		{
			dest = (flag),		-- possibly 0 (= match all)
			source = (flag),
		}
	}
]]

me.myevents = { "COMBAT_LOG_EVENT_UNFILTERED" }

me.onevent = function(...)
	
	local timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags = select(2, ...)
	
	-- get all handling modules
	local eventdata = me.data[eventname]
	
	-- exit if none
	if eventdata == nil then
		return
	end
	
	-- loop through all modules
	for modulename, flagdata in pairs(eventdata) do
		
		-- DEBUG
		--mod.printf("Checking module = %s, sourceflags = %s, destflags = %s; filtersource = %s, filterdest = %s.", modulename, sourceflags, destflags, flagdata.source, flagdata.dest)
		
		if (bit.band(sourceflags, flagdata.source) == flagdata.source) and (bit.band(destflags, flagdata.dest) == flagdata.dest) then
						
			-- TODO: wrap in a pcall, because an error here will deny other modules of receiving this combat event.
			mod[modulename].oncombatevent(select(2, ...))
		end
		
	end
	
end

--[[
----------------------------------------------------------------------------------------------
				Startup: Loading Event Requests
----------------------------------------------------------------------------------------------
]]

--[[
me.onmoduleload(module) is a special function called by Loader.lua when the addon starts.

It is called once for each module in the addon (sent as an argument).
]]
me.onmoduleload = function(module)
	
	-- check for .myparsers / onparse mismatch
	if module.mycombatevents and not module.oncombatevent then
		if mod.trace.check("warning", me, "events") then
			mod.trace.printf("The module |cffffff00%s|r has a |cffffff00.mycombatevents|r list but no |cffffff00.oncombatevent|r function.", module.name)
		end
		
	elseif module.oncombatevent and not module.mycombatevents then
		if mod.trace.check("warning", me, "events") then
			mod.trace.printf("The module |cffffff00%s|r has a |cffffff00.oncombatevent|r function but no |cffffff00.mycombatevents|r list.", module.name)
		end
	
	-- normal modules: if they have both
	elseif module.mycombatevents then
		
		for eventname, filters in pairs(module.mycombatevents) do
			
			me.registerevent(module.name, eventname, filters)
			
		end
	end

end

--[[
me.registerparser(modulename, eventname, filters)

filters is EITHER the value <true>, or a table with <source> or <dest> keys.

]]
me.registerevent = function(modulename, eventname, filters)
	
	local sourcevalue = 0
	local destvalue = 0
	
	-- simple filter: <true> value
	if filters == true then
		-- keep defaults
		
	-- invalid filter value
	elseif type(filters) ~= "table" then
		
		if mod.trace.check("warning", me, "filters") then
			mod.trace.printf("Error loading module '%s', event '%s': the value is not a table or the value 'true'.", modulename, eventname)
		end
		
		return
	
	-- table filter
	else
		
		-- source
		if filters.source then
			sourcevalue = me.parseflags(filters.source)
		
			if type(sourcevalue) == "string" then
				
				if mod.trace.check("warning", me, "filters") then
					mod.trace.printf("Error in module '%s', event '%s': %s", modulename, eventname, sourcevalue)
				end
				
				return
			end
		end
		
		-- dest
		if filters.dest then
			
			destvalue = me.parseflags(filters.dest)
			
			if type(destvalue) ~= "number" then
				
				if mod.trace.check("warning", me, "filters") then
					mod.trace.printf("Error in module '%s', event '%s': %s", modulename, eventname, destvalue)
				end
			
				return
			end
		end
		
		-- add to data

		-- get event
		local eventdata = me.data[eventname]
		
		if eventdata == nil then
			eventdata = mod.garbage.gettable() -- {}
			me.data[eventname] = eventdata
		end
		
		-- get module
		local moduledata = eventdata[modulename]
		
		if moduledata == nil then
			moduledata = mod.garbage.gettable() -- {}
			eventdata[modulename] = moduledata
		end
		
		-- fill source and value
		moduledata.source = sourcevalue
		moduledata.dest = destvalue
		
	end
	
end


--[[
----------------------------------------------------------------------------------------------
						Flags
----------------------------------------------------------------------------------------------

Sample flag combos

me = { affiliation = { "mine", }, objecttype = { "player", }, control = { "player" } }

]]

--[[
<number> OR <error string> = me.parseflags(filters)

Determines the number from a flag description table.
Returns <string> = message if there is a parser error.
Returns <number> = flag value normally.
]]
me.parseflags = function(filters)
	
	local value = 0
	
	for section, flagname in pairs(filters) do
			
		-- check for invalid section name
		if me.flags[section] == nil then
			
			return mod.format("There is no flag section '%s'. The allowed values are %s.", tostring(section), me.keysettostring(me.flags))
		end
		
		-- section is valid. Check value (?)
		
		--for index, flagname in pairs(valueset) do
			
			-- check for invalid flag name
			if me.flags[section][flagname] == nil then
				
				return mod.format("There is no flag '%s' in the section '%s'. The allowed values are %s.", tostring(flagname), section, me.keysettostring(me.flags[section]))
				
			end
			
			-- OR in this flag value
			value = value + me.flags[section][flagname]
		--end
	end
	
	return value
			
end

--[[
<string> = me.keysettostring(keyset)
	
Returns a human-readable listing of the keys in a table.
]]
me.keysettostring = function(keyset)
	
	local message = "{ "
	
	for key, value in pairs(keyset) do
		
		message = message .. key .. ", "
		
	end
	
	return message .. "}"
	
end

--[[
We have to define them here because the definitions like COMBATLOG_OBJECT_MAINTANK in Bliz_CombatLog.lua won't turn up until after our mod has loaded (GG).
]]
me.flags = 
{
	affiliation = 
	{
		mine = 1,
		party = 2,
		raid = 4,
		outsider = 8,
	},
	
	reaction = 
	{
		friendly = 16,
		neutral = 32,
		hostile = 64,
	},
	
	control = 
	{
		player = 256,
		npc = 512,
	},
	
	objecttype = 
	{
		player = 1024,
		npc = 2048,
		pet = 4096,
		guardian = 8192,
		object = 16384,
	},
	
	object = 
	{
		target = 65536,
		focus = 131072,
		maintank = 262144,
		mainassist = 524288,
		raidtarget1 = 1048576,
		raidtarget2 = 2097152,
		raidtarget3 = 4194304,
		raidtarget4 = 8388608,
		raidtarget5 = 16777216,
		raidtarget6 = 33554432,
		raidtarget7 = 67108864,
		raidtarget8 = 134217728,
		none = 2147483648,
	},
}
