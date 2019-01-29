
-- module setup
local me = { name = "bmattacks"}
local mod = thismod
mod[me.name] = me

--[[
BossMod\Attacks

This is part of the BossMod package. A bossmod can optionally define a set of 'attacks', which are spells which multiply your threat when they hit you. For example, the standard "Knock Away" spell multiplies your threat by 50% when it hits.

As described in BossMod\Schema.lua, each 'attack' has these properties
	spellid		int, the WoW spell id
	multiplier	number, value your threat is multiplied by
	hitsonly		true, optional. If defined, only non-misses count.
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
		multiplier = (value)
		hitsonly = (true / nil), whether only (successful) hits work.
	}
} ]]

-------------------------------------------------------------------------------
--				Loading Boss Mod Data
-------------------------------------------------------------------------------

--[[
mod.bmattacks.loaddata(modulename, bossmodname, data)

Loads the attacks section of a boss mod.
]]
me.loaddata = function(modulename, bossmodname, data)
	
	-- split the items off one a time to isolate faults
	for idstring, item in pairs(data) do
		
		me.loaditem(modulename, bossmodname, idstring, item)
		
	end
	
end

--[[
me.loaditem(modulename, bossmodname, idstring, item)

Loads a single attack item. The <item> table has .multiplier and .spellid properties, and possibly .hitsonly.
]]
me.loaditem = function(modulename, bossmodname, idstring, item)
	
	-- check that the spellid is unique
	local existing = me.data[item.spellid]
	
	-- reject duplicate definition
	if existing then
		
		if mod.trace.check("warning", me, "duplicate") then
			mod.trace.printf("Duplicate attack definition '%s.%s.%s'. An attack with that spell id is already defined as '%s.%s.%s'. The new entry will be ignored.", modulename, bossmodname, idstring, existing.modulename, existing.bossmodname, existing.idstring)
		end
		
		return
	end
	
	-- create
	me.data[item.spellid] = 
	{
		modulename = modulename,
		bossmodname = bossmodname,
		idstring = idstring,
		multiplier = item.multiplier,
		hitsonly = item.hitsonly
	}
	
end

-------------------------------------------------------------------------------
--				Processing Combat Log Entries
-------------------------------------------------------------------------------

me.filteronself = { dest = { objecttype = "player", affiliation = "mine" } }

me.mycombatevents = 
{
	SPELL_MISSED = me.filteronself,
	SPELL_DAMAGE = me.filteronself,
}

me.oncombatevent = function(...)
	
	-- only care about spell details - filter already done
	local eventname, sourceguid, sourcename = select(2, ...)
	local spellid, spellname, school, misstype = select(9, ...)
	
	-- determine whether it was a miss
	-- todo: investigate the last two conditions. It's not clear.
	local ismiss = (eventname == SPELL_MISSED) and misstype ~= "ABSORB" and misstype ~= "BLOCK"
	
	-- check spellid is special
	if me.data[spellid] == nil then
		return
	end
	
	-- debug
	if mod.trace.check("info", me, "trigger") then
		mod.trace.printf("The spell '%s' is triggering on the event '%s'. Is miss = '%s', caster = '%s'.", spellname, eventname, tostring(ismiss), sourcename)
	end
	
	-- this is the boss mod information
	local spelldata = me.data[spellid]
	
	if ismiss and spelldata.hitsonly then
		
		-- trace and ignore
		if mod.trace.check("info", me, "miss") then
			mod.trace.printf("The boss mod attack '%s.%s.%s' does not allow misses, so this event is ignored.", spelldata.modulename, spelldata.bossmodname, spelldata.idstring)
		end
	
		return
	end
	
	-- activate
	if mod.trace.check("info", me, "activate") then
		mod.trace.printf("The attack '%s.%s.%s' from '%s' multiplies threat by '%s'.", spelldata.modulename, spelldata.bossmodname, spelldata.idstring, sourcename, spelldata.multiplier)
	end
	
	if mod.mythreat then
		mod.mythreat.multiplytarget(sourceguid, spelldata.multiplier)
	end
	
end

