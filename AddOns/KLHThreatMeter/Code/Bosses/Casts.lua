
-- module setup
local me = { name = "bmcasts"}
local mod = thismod
mod[me.name] = me

--[[
BossMod\Casts

This is part of the BossMod package. A bossmod can optionally define a "casts" section, which describes non-targetting spells that usually signal threat wipes.

As described in BossMod\Schema.lua, a cast item has these properties:

	spellid		integer, WoW spell id
	event			string, optional. Event name that causes it. Must be a member of the "castevents" enum defined in the boss mod schema module. The default value is SPELL_CAST_SUCCESS.

When a cast is detected, it causes a threat wipe against the moss mod's mob id (not necessarily the caster). Therefore be sure to use spells that are unique to the particular encounter (as they almost always will be).
]]

--[[
-- this is full trace enabled
me.mytraces = 
{
	default = "info",
}
]]

me.data = { } --[[
{
	<spellid> = 
	{
		modulename = (string),
		bossmodname = (string)
		idstring = (string; identifier of this attack in its bossmod definition table)
		eventname = (string, triggering event)
	}
]]

-------------------------------------------------------------------------------
--				Loading Boss Mod Data
-------------------------------------------------------------------------------

--[[
mod.bmcasts.loaddata(modulename, bossmodname, data)

Loads the casts section of a boss mod.
]]
me.loaddata = function(modulename, bossmodname, data)
	
	-- split the items off one a time to isolate faults
	for idstring, item in pairs(data) do
		
		me.loaditem(modulename, bossmodname, idstring, item)
		
	end
	
end

--[[
me.loaditem(modulename, bossmodname, idstring, item)

Loads a single cast item. The <item> table has the .spellid property, and possibly .event.
]]
me.loaditem = function(modulename, bossmodname, idstring, item)
	
	-- check that the spellid is unique
	local existing = me.data[item.spellid]
	
	-- reject duplicate definition
	if existing then
		
		if mod.trace.check("warning", me, "duplicate") then
			mod.trace.printf("Duplicate cast definition '%s.%s.%s'. A cast with that spell id is already defined as '%s.%s.%s'. The new entry will be ignored.", modulename, bossmodname, idstring, existing.modulename, existing.bossmodname, existing.idstring)
		end
		
		return
	end
	
	-- create
	me.data[item.spellid] = 
	{
		modulename = modulename,
		bossmodname = bossmodname,
		idstring = idstring,
		eventname = item.event or "SPELL_CAST_SUCCESS" -- default value
	}
	
end


-------------------------------------------------------------------------------
--				Processing Combat Log Entries
-------------------------------------------------------------------------------

me.filterany = { }

me.mycombatevents = 
{
	SPELL_CAST_SUCCESS = me.filterany,
	SPELL_AURA_APPLIED = me.filterany,
	SPELL_AURA_REMOVED = me.filterany,
}

me.oncombatevent = function(...)
	
	-- only care about spell details - filter already done
	local eventname, sourceguid, sourcename = select(2, ...)
	local spellid, spellname, school = select(9, ...)
	
	-- 1) match on spellid
	if me.data[spellid] == nil then
		return
	end
	
	-- trace
	if mod.trace.check("info", me, "trigger") then
		mod.trace.printf("The cast '%s' is triggering on the event '%s'. Caster = '%s'.", spellname, eventname, sourcename)
	end
	
	-- check for correct cast type
	local spelldata = me.data[spellid]
	
	if eventname ~= spelldata.eventname then
		
		-- trace and ignore
		if mod.trace.check("info", me, "wrongevent") then
			mod.trace.printf("The boss mod cast '%s.%s.%s' doesn't accept '%s' events, so this one is ignored.", spelldata.modulename, spelldata.bossmodname, spelldata.idstring, eventname)
		end
	
		return
	end
	
	-- activate
	if mod.trace.check("info", me, "activate") then
		mod.trace.printf("The cast '%s.%s.%s' from '%s' causes a threat wipe on the boss.", spelldata.modulename, spelldata.bossmodname, spelldata.idstring, sourcename)
	end
	
	mod.bossmod.resetmobidunknowninstance(spelldata.modulename, spelldata.bossmodname)
	
end
	