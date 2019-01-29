
-- module setup
local me = { name = "bmdebuffs"}
local mod = thismod
mod[me.name] = me

--[[
BossMod\Debuffs

This is part of the BossMod package.
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
		idstring = (string; key of the object in its definition table)
		multiplier = (value)
	}
} ]]

me.activedebuffs = { } --[[
{
	<spellid> = (buff name),
} ]]

-------------------------------------------------------------------------------
--				Loading Boss Mod Debuff Data
-------------------------------------------------------------------------------

--[[
mod.bmdebuffs.loaddebuffdata(modulename, bossmodname, debuffdata)

Loads the debuffs section of a boss mod.
]]
me.loaddebuffdata = function(modulename, bossmodname, debuffdata)
	
	-- split the items off one a time to isolate faults
	for idstring, debuffitem in pairs(debuffdata) do
		
		me.loaddebuffitem(modulename, bossmodname, idstring, debuffitem)
		
	end
	
end

--[[
me.loaddebuffitem(modulename, bossmodname, idstring, debuffitem)

Loads a single debuff item. The <debuffitem> table has .multiplier and .spellid properties.
]]
me.loaddebuffitem = function(modulename, bossmodname, idstring, debuffitem)
	
	-- check that the spellid is unique
	local existing = me.data[debuffitem.spellid]
	
	-- reject duplicate definition
	if existing then
		
		if mod.trace.check("warning", me, "duplicate") then
			mod.trace.printf("Duplicate debuff definition '%s.%s.%s'. A debuff with that spell id is already defined as '%s.%s.%s'. The new entry will be ignored.", modulename, bossmodname, idstring, existing.modulename, existing.bossmodname, existing.idstring)
		end
		
		return
	end
	
	-- create
	me.data[debuffitem.spellid] = 
	{
		modulename = modulename,
		bossmodname = bossmodname,
		idstring = idstring,
		multiplier = debuffitem.multiplier,
	}
	
end

-------------------------------------------------------------------------------
--				Processing Combat Log Entries
-------------------------------------------------------------------------------

me.filteronself = { dest = { objecttype = "player", affiliation = "mine" } }

me.mycombatevents = 
{
	SPELL_AURA_APPLIED = me.filteronself,
	SPELL_AURA_REMOVED = me.filteronself,
}

me.oncombatevent = function(...)
	
	-- only care about spell details - filter already done
	local eventname = select(2, ...)
	local spellid, spellname, school, auratype = select(9, ...)
		
	-- ignore buffs
	if auratype ~= "DEBUFF" then
		return
	end
		
	-- check spellid is special
	if me.data[spellid] == nil then
		return
	end
		
	-- activate or deactivate
	if eventname == "SPELL_AURA_APPLIED" then
		me.activedebuffs[spellid] = spellname
	
	else
		me.activedebuffs[spellid] = nil
	end
	
	-- trace
	if mod.trace.check("info", me, "change") then
		mod.trace.printf("The '%s' debuff had a state change from the '%s' event.", spellname, eventname)
	end
	
end


-------------------------------------------------------------------------------
--				Maintaining Active Debuffs
-------------------------------------------------------------------------------

me.myonupdates = 
{
	verifydebuffs = 1.0,
}

me.uidebuffs = { }

--[[
Polled function to manually check that debuffs from combat log match UI listing
]]
me.verifydebuffs = function()
	
	local debuffcount = 0
	local debuffname
	
	-- 1) populate me.uidebuffs table
	for x = 1, 40 do
		debuffname = UnitDebuff("player", x)
		
		if x == nil then
			break
		end
		
		me.uidebuffs[x] = debuffname
		debuffcount = x
	end
	
	-- 2) find existing in activedebuffs, not in uidebuffs
	for spellid, spellname in pairs(me.activedebuffs) do
		
		local found = false
		
		for x = 1, debuffcount do
			
			if me.uidebuffs[x] == spellname then
				found = true
				break
			end
		end
		
		if found == false then
			
			-- warn
			local data = me.data[spellid]
			
			if mod.trace.check("warning", me, "missing") then
				mod.trace.printf("The debuff '%s.%s.%s' faded without being detected properly.", data.modulename, data.bossmodname, data.idstring)
			end
			
			-- remove
			me.activedebuffs[spellid] = nil
		end
	end
end

-------------------------------------------------------------------------------
--				Activating Threat Multipliers
-------------------------------------------------------------------------------

me.myinternalevents = 
{
	my = { "redoglobalthreat" }
}
		
me.oninternalevent = function(source, message, ...)
		
	if source == "my" and message == "redoglobalthreat" then
		
		local callback = select(1, ...)
		
		for spellid, buffname in pairs(me.activedebuffs) do
			callback(me.data[spellid].multiplier - 1.0, buffname)
		end
				
	end
	
end