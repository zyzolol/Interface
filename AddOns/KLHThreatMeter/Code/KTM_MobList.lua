
local me = { name = "moblist"}
local mod = thismod
mod[me.name] = me

--[[
MobList.lua

This keeps tracks of various lists of mob GUIDs. We often want to look up

* Mob name vs Mob GUID
* Partial Guid (last 12) vs full GUID
* Death list - mobs who are dead!

* Mobs with flags like raid symbols, also target flag.

Other stuff we have to deal with:

* Clear everything after combat ends
* Keep a log of mob auto attack vs player, to work out who has aggro on what.
]]

--[[
----------------------------------------------------------------------------------------
						Private Variables
----------------------------------------------------------------------------------------
--]]

me.mobaggro = { } --[[
{
	mobguid = { playername = , timestamp = }
]]

me.combatlogobjects = 
{
	target = { },		-- each item is {mobguid = , timestamp = }
	focus = { },
	raidicon = { {}, {}, {}, {}, {}, {}, {}, {},  }
}

me.mobtypeidtoname = { } -- key = 6-length hex string (mob type id part), value = name.

me.nametoguid = { } --[[
{
	name_i = 
	{
		guid_i = timestamp,
		...
	}
	...
}
]]

--[[
----------------------------------------------------------------------------------------
						Public Interface
----------------------------------------------------------------------------------------
--]]

--[[
<string> = mod.moblist.findfullguidfrompartial(partialguid)

Converts a partial GUID to a full. By default add 0xF130
]]
me.findfullguidfrompartial = function(partialguid)
	
	-- TODO: improve
	return "0xF130" .. partialguid
	
end

--[[
[nil] <string> = mod.moblist.findmobnamefromguid(mobguid)

Tries to find the name of a mob from its guid. Returns nil on failure.
]]
me.findmobnamefromguid = function(mobguid)
	
	local mobtypeid = string.format(mobguid, -12, -7)
	return me.mobtypeidtoname[mobtypeid]
	
end

--[[
nil | guid = mod.moblist.findguidforspelltarget(targetname)
Given: name of a mob we are targetting with a spell.

find: the GUID. gfg fucking impossible.

Try for only 1 guid in scope with that name - then OK
otherwise check for one matching target, or focus
otherwise ??? return nil for giveup.
]]
me.findguidforspelltarget = function(targetname)
	
	local mobdata = me.nametoguid[targetname]
	
	if mobdata == nil then
		-- return: none of the other tables will have the value either
		return nil
	end
	
	-- try for unique entry
	local hits = 0
	local finalguid, mobguid, timestamp
	local timenow = GetTime()
	
	for mobguid, timestamp in pairs(mobdata) do
		
		if timenow < timestamp + 5 then
			hits = hits + 1
			finalguid = mobguid
		end
	end
	
	if hits == 1 then
		return finalguid
	end
	
	-- otherwise: check for target match
	objectdata = me.combatlogobjects.target

	if objectdata.timestamp and timenow < objectdata.timestamp + 5 then
		return objectdata.mobguid
	end
		
	-- otherwise: check for focus match
	objectdata = me.combatlogobjects.focus
	
	if objectdata.timestamp and timenow < objectdata.timestamp + 5 then
		return objectdata.mobguid
	end
	
	-- assume it is target i guess?
	return me.gettargettedguid()
	
end

--[[
guid = mod.moblist.gettargettedguid()

This method identifies the current target with a GUID. If player is targetting a player, it will try with targettarget, and keep adding target until a bailout or hostile is found.
]]
me.gettargettedguid = function()
	
	-- try to find an applicable unit id
	local unitid = me.getactiveunitid()
	
	if unitid == nil then
		return
	end
	
	return UnitGUID(unitid)
	
end

--[[
TODO

returns unitid, nil for giveup
]]
me.getactiveunitid = function()
	
	local unitid = ""
	
	for x = 1, 4 do
		unitid = unitid .. "target"
	
		if not UnitExists(unitid) then
			return
		end
	
		-- is target applicable?
		if not UnitIsFriend("player", unitid) then
			return unitid
		end
	end
	
end


--[[
----------------------------------------------------------------------------------------
						Check for Combat Exits
----------------------------------------------------------------------------------------
--]]

me.incombat = nil

me.myonupdates = 
{
	checkincombat = 0.0,
}

--[[
When we exit combat, notify <mythreat> module to remove all entries from our threat list.
]]
me.checkincombat = function()
	
	-- get current value and convert to boolean
	local nowincombat = (UnitAffectingCombat("player") ~= nil)
	
	-- check for change to false
	if me.incombat ~= nowincombat then
		
		-- change has been made
		me.incombat = nowincombat
		
		-- change was combat end
		if nowincombat == false then
		
			-- send reset all event to my threat
			me.incombat = false
						
			mod.mythreat.endcombat()
			
			me.maintainlists()
		end
	end
	
end


----------------------------------------------------------------------------------------
--						Maintain Lists
----------------------------------------------------------------------------------------

--[[
me.maintainlists()

Called when we exit combat. Clears out of date values from our various lists.
]]
me.maintainlists = function()
	
	-- recycle ALL mob aggro
	for mobguid, mobdata in pairs(me.mobaggro) do
		
		me.mobaggro[mobguid] = nil
		mod.garbage.recycle(mobdata)
		
	end
	
	-- old name lookup
	local oldtime = GetTime() - 60
	
	for mobname, mobdata in pairs(me.nametoguid) do
		
		-- flag to see if the entire <mobdata> table is cleared
		isempty = true
		
		for mobguid, timestamp in pairs(mobdata) do
			
			-- old: clear
			if timestamp < oldtime then
				
				mobdata[mobguid] = nil
			
			-- recent: mark this mob as "don't remove"
			else
				isempty = false
			end
		end
		
		-- all empty: recycle table
		if isempty then
			me.nametoguid[mobname] = nil
			mod.garbage.recycle(mobdata)
		end
	end
	
end


--[[
----------------------------------------------------------------------------------------
						Check Combat log for Various Lookups
----------------------------------------------------------------------------------------
--]]

me.myevents = { "COMBAT_LOG_EVENT_UNFILTERED" }

-- shared for onevent handling functions
local timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags

me.onevent = function()
	
	timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags = arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8
	
	me.checkformobdeath()
	
	-- add to name lookup
	me.populatenamelookup(sourceguid, sourcename, sourceflags)
	me.populatenamelookup(destguid, destname, destflags)
	
	me.checkmobaggro()
end

--[[
Checks the current event for a mob's death.
]]
me.checkformobdeath = function()
	
	if eventname == "UNIT_DIED" then
		-- TODO: filter it on something
		
		-- basic filter: non-players
		if string.sub(destguid, -16, -15) ~= "00" then
				
			-- destination is populated for DEATH event
			mod.mythreat.mobdeath(destguid)
			
		end
	end
	
end

--[[
me.populatenamelookup(mobguid, mobname, flags)

Check for mobs
]]
me.populatenamelookup = function(mobguid, mobname, flags)
	
	-- not all events have 2 units
	if mobname == nil then
		return
	end
	
	-- find
	local mobnamedata = me.nametoguid[mobname]
	local timenow = GetTime()
	
	-- add if not exists
	if mobnamedata == nil then
		mobnamedata = mod.garbage.gettable()
		me.nametoguid[mobname] = mobnamedata
	end
	
	-- update this entry
	mobnamedata[mobguid] = timenow
	
	-- also add to name lookup
	local mobtypeid = string.format(mobguid, -12, -7)
	me.mobtypeidtoname[mobtypeid] = mobname
	
	me.checkflags(mobguid, flags)
	
end

me.flagsofinterest = 267583488 -- 0xFF30000 -- Thanks for not loading before me, combat log!
-- = bit.bor(COMBATLOG_OBJECT_TARGET, COMBATLOG_OBJECT_FOCUS, COMBATLOG_OBJECT_RAIDTARGET1, COMBATLOG_OBJECT_RAIDTARGET2, COMBATLOG_OBJECT_RAIDTARGET3, COMBATLOG_OBJECT_RAIDTARGET4, COMBATLOG_OBJECT_RAIDTARGET5, COMBATLOG_OBJECT_RAIDTARGET6, COMBATLOG_OBJECT_RAIDTARGET7, COMBATLOG_OBJECT_RAIDTARGET8)

--[[
me.checkflags(mobguid, flags)

Checks mob for target or raid symbol flags
]]
me.checkflags = function(mobguid, flags)
	
	-- check for having any important flags at all
	if bit.band(flags, me.flagsofinterest) == 0 then
		return
	end
	
	local timenow = GetTime()
	
	-- check for target
	if bit.band(flags, COMBATLOG_OBJECT_TARGET) == COMBATLOG_OBJECT_TARGET then
		me.combatlogobjects.target.mobguid = mobguid
		me.combatlogobjects.target.timestamp = timenow
	end
	
	-- check for focus
	if bit.band(flags, COMBATLOG_OBJECT_FOCUS) == COMBATLOG_OBJECT_FOCUS then
		me.combatlogobjects.focus.mobguid = mobguid
		me.combatlogobjects.focus.timestamp = timenow
	end
	
	-- any raid symbols
	for x = 1, 8 do
		
		local flagneeded = bit.lshift(COMBATLOG_OBJECT_RAIDTARGET1, (x - 1))
		
		if bit.band(flags, flagneeded) == flagneeded then
				
			local dataset = me.combatlogobjects.raidicon[x]
			
			dataset.mobguid = mobguid
			dataset.timestamp = timenow
			
			-- we can exit now cause one unit can't have more than one raid target
			return
			
		end
	end
	
end

--[[
-- TODO
returns: guid of mob, player name, timestamp.
]]
me.checkmobaggro = function()
	
	-- event = melee swings
	if eventname ~= "SWING_DAMAGE" and eventname ~= "SWING_MISSED" then
		return
	end
	
	-- need source == mob
	if bit.band(sourceflags, COMBATLOG_OBJECT_CONTROL_NPC) == COMBATLOG_OBJECT_CONTROL_NPC 
	and bit.band(destflags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER 
	then
		
		-- create data if needed
		if me.mobaggro[sourceguid] == nil then
			me.mobaggro[sourceguid] = mod.garbage.gettable() -- { }
		end
		
		-- record
		me.mobaggro[sourceguid].timestamp = GetTime()
		me.mobaggro[sourceguid].playername = destname
		
	end
end
