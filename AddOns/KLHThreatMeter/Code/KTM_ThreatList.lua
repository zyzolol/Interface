
local me = { name = "threatlist"}
local mod = thismod
mod[me.name] = me

--[[
ThreatList.lua

This module records the known threat values of everyone in the raid, against all their targets, and the respective TPS scores.

In this module, we use thingy partial guids.

Stuff we might want to know:
	1) threat per mob
	2) tps per mob
	3) ??
	
]]

--[[
------------------------------------------------------------------------------------------------
								Private Variables
------------------------------------------------------------------------------------------------
]]

me.data = { } --[[
{
	<mob_A> = <mobdata_A>,
	<mob_B> = <mobdata_B>,
	...
}

<mob> = GUID key.
<mobdata> = 
{
	<player_A> = <playerdata_A>,
	<player_B> = <playerdata_B>,
	...
}

<player> = Player Name
<playerdata> = 
{
	history = { <historydata>, <historydata>, ... }
	historycount = (number; highest index in <history> that is used)
	
	threat = (number)
}

<historydata> = 
{
	time = (timestamp),
	threat = (number),
}
]]

--[[
------------------------------------------------------------------------------------------------
								Public Interface
------------------------------------------------------------------------------------------------
]]

--[[
mod.threatlist.setthreat(mobguid, playername, value)

Sets the threat of the given player on the given mob.

<mobguid>	string; mob identifier.
<playername>string; player identifier - name.
<value>		number; threat value.
]]
me.setthreat = function(mobguid, playername, value)
		
	-- find the mob's data set
	local mobdata = me.data[mobguid]

	-- if mobdata doesn't currently exist, create and add it
	if mobdata == nil then
		mobdata = me.addnewmobdata(mobguid)
	end
	
	-- find the player's data set
	local playerdata = mobdata[playername]
	
	-- if playerdata doesn't exist, create and add
	if playerdata == nil then
		playerdata = me.addnewplayerdata(mobdata, playername)
	end
	
	-- set threat value
	playerdata.threat = value
	
	-- maintain playerdata.history
	playerdata.historycount = playerdata.historycount + 1
	
	-- get history entry
	local history = playerdata.history[playerdata.historycount]
	
	-- create if required (never disposed so don't look for garbage)
	if history == nil then
		history = { }
		table.insert(playerdata.history, history)
	end
	
	-- set values for entry
	history.threat = value
	history.time = GetTime()
	
end

-- a few constants for the TPS calculation algorithm
me.mintpsduration = 3.0			-- interval for tps calculation must be at least this long
me.maxtpsduration = 12.0		-- data older than this should be discarded. But consider that it won't get removed immediately, only on some other slowly polling function
me.tpsreset = 5.0					-- after this long with no data, reset to 0		

--[[
tps = mod.threatlist.calculatetps(mobguid, playername)

Calculate TPS value for a given player on a given mob. This will presumably be called by the user interface somewhere. The method won't perform any maintenance on the history.
]]
me.calculatetps = function(mobguid, playername)
	
	local playerdata = me.data[mobguid][playername]
	
	-- need more than 1 point to make a gradient
	if playerdata.historycount < 2 then
		return 0
	end
	
	-- get the entry at the "end" - most recent, highest time value
	local mostrecententry = playerdata.history[playerdata.historycount]
	
	-- last data point must be (reasonably) recent
	if GetTime() > mostrecententry.time + me.tpsreset then
		return 0
	end

	-- get the entry at the "start" - least recent, lowest time value
	local leastrecententry = playerdata.history[1]

	-- total history interval too small (too inaccurate / spiky value)
	if mostrecententry.time < leastrecententry.time + me.mintpsduration then
		return 0
	end
	
	-- Valid range: return gradient calculated from first entry and last entry
	return (mostrecententry.threat - leastrecententry.threat) / (mostrecententry.time - leastrecententry.time)

end

--[[
------------------------------------------------------------------------------------------------
								Network Messages
------------------------------------------------------------------------------------------------
]]

me.mynetmessages = { "endcombat" }

me.onnetmessage = function(author, command, data)
	
	me.removeplayer(author)

	-- TODO: investigate. is this ok?
	
end

--[[
------------------------------------------------------------------------------------------------
								Internal Methods
------------------------------------------------------------------------------------------------
]]

me.minmaintainanceinterval = 5.0	-- minimum time in seconds between <maintaindata> calls.
me.dataexpirytimeout = 10.0		-- time in seconds with no updates before data is deleted

me.myonupdates = 
{
	maintaindata = me.minmaintainanceinterval,
}

--[[
This is a polled method, interval defined above.

We look for threat data that is "out of date" - player has not updated the value for a while. We delete any such entries.

Also in the threat history table, delete all the events that are out of date.
]]
me.maintaindata = function()
	
	local mobguid, mobdata, playername, playerdata, isempty
	
	for mobguid, mobdata in pairs(me.data) do
		
		isempty = true -- records whether all player entries in this table have been removed
		
		for playername, playerdata in pairs(mobdata) do
			
			if me.maintainplayerdata(playerdata) then
				
				-- this player data is old: remove it
				mobdata[playername] = nil
				mod.garbage.recycle(playerdata)
				
			else
				-- mark the mobdata entry as NOT out of date
				isempty = false
			end
		end
		
		-- is <mobdata> all empty now?
		if isempty then
						
			-- recycle it too
			me.data[mobguid] = nil
			mod.garbage.recycle(mobdata)
			
		end
		
	end
	
end

--[[
<bool> = me.maintainplayerdata(playerdata)

Checks a <playerdata> entry for stale / obsolete data - hasn't been updated for a while. Deletes any out of data history entries.

Returns true if there is no data left after the cleanup
]]
me.maintainplayerdata = function(playerdata)
	
	local olddatacount = 0 -- how many history entries are out of data
	local x, historyentry
	local timenow = GetTime()
	
	-- Search through the history data, from oldest to newest, for out of data entries
	for x = 1, playerdata.historycount do
		
		historyentry = playerdata.history[x]
		
		if timenow > historyentry.time + me.dataexpirytimeout then
		
			-- all entries up to <x> are out of date
			olddatacount = x
		
		else
			-- this entry is current, so all further entries will be as well
			break
		end
	end
		
	-- is table completely out of date?
	if olddatacount == playerdata.historycount then
		
		-- drop the <playerdata>
		return true
	end
	
	-- tidy up by compacting table
	playerdata.historycount = playerdata.historycount - olddatacount

	-- move all entries down 
	for x = 1, playerdata.historycount do
		playerdata.history[x].threat = playerdata.history[x + olddatacount].threat
		playerdata.history[x].time = playerdata.history[x + olddatacount].time
	end
	
	-- report that table still has current data
	return false
	
end


------------------------------------------------------------------------------------------------
--								<me.data> Table Helpers
------------------------------------------------------------------------------------------------

--[[
<mobdata> = me.addnewmobdata(mobguid)

Creates a new <mobdata> object and adds it to the threat table.
]]
me.addnewmobdata = function(mobguid)
	
	local mobdata = mod.garbage.gettable() -- { }
	
	-- add new item to its data set
	me.data[mobguid] = mobdata
	
	return mobdata
	
end

--[[
playerdata = me.addnewplayerdata(mobdata, playername)

Creates a new <playerdata> object and adds it to the mob's data set. 
]]
me.addnewplayerdata = function(mobdata, playername)
	
	local playerdata = mod.garbage.gettable() -- { }
	
	playerdata.history = mod.garbage.gettable() -- { }
	playerdata.historycount = 0
	
	-- add new item to its data set
	mobdata[playername] = playerdata
	
	return playerdata
end

--[[
me.removeplayer(playername)

Completely removes a player from all threat data.
]]
me.removeplayer = function(playername)
	
	local playerdata
		
	for mobguid, mobdata in pairs(me.data) do
		
		-- check for player entry in this mob
		playerdata = mobdata[playername]
		
		if playerdata then
			
			-- player has an entry. remove and recycle
			mobdata[playername] = nil
			mod.garbage.recycle(playerdata)

			-- it's possible that this mob may now be empty. If so we should remove it
			local isempty = true
			
			for playername, playerdata in pairs(mobdata) do 
				
				-- first entry in table means table is nonempty. seriously.
				isempty = false
				break
				
			end
			
			if isempty then
				
				-- delete the mob record as well
				me.data[mobguid] = nil
				mod.garbage.recycle(mobdata)
				
			end
			
		end
		
	end
	
end
