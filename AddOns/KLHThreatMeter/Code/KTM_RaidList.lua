
local me = { name = "raidlist"}
local mod = thismod
mod[me.name] = me

--[[
RaidList.lua

Provides a cached lookup for { unitid - name - class } tuples for party / raidmembers.

TODO: add support for pets, depending on the object type of the known flags.
]]

--[[
----------------------------------------------------------------------------------------
						Private Variables
----------------------------------------------------------------------------------------
--]]

me.minrefreshinterval = 0.5	-- minimum time in seconds between two updates
me.lastrefreshtime = 0 			-- timestamp of last refresh

me.data = { } --[[
{
	(playername) = <playerdata>
	...
}
<playerdata> = 
{
	unitid = (string; unitid for this guy)
	class = (class name, unlocalised, lower case)
}]]

--[[
----------------------------------------------------------------------------------------
						Public Interface
----------------------------------------------------------------------------------------
--]]

me.getunitidforplayer = function(playername)
	
	-- TODO
	
end

--[[
[nil] <string> = mod.raidlist.getclassforplayer(playername)

Returns the class of the given player, in lower case unlocalised format.
The function will return nil if the player can't be identified.
]]
me.getclassforplayer = function(playername)
	
	local playerdata = me.refreshplayer(playername)
		
	if playerdata then
		return playerdata.class
	end
	
end

--[[
----------------------------------------------------------------------------------------
						Internal Methods
----------------------------------------------------------------------------------------
--]]

--[[
[nil] <playerdata> = me.refreshplayer(playername)

Verifies existing data on (playername), or applies for a fresh data set.

The method returns the relevant <playerdata>, or nil on failure.
]]
me.refreshplayer = function(playername)
	
	-- If dataset is recent, implicitely trust it
	if GetTime() < me.lastrefreshtime + me.minrefreshinterval then
		
		-- possibly false, but low chance of error
		return me.data[playername] -- possibly nil
		
	end
	
	-- data set is old. But if player data exists, attempt to verify it alone first
	local playerdata = me.data[playername]
	
	-- check for existing and valid data
	if playerdata and UnitName(playerdata.unitid) == playername then
		
		return playerdata
	end
	
	-- no record of the player, but data hasn't been refreshed recently, so we can rescan
		
	me.rescangroup()
	
	return me.data[playername]	-- possibly nil
	
end

--[[
me.rescangroup()

Iterates over all units in the party or raid, refreshing data on them. Also clears any existing data.
]]
me.rescangroup = function()
	
	-- update refresh timestamp
	me.lastrefreshtime = GetTime()
	
	-- clear existing
	for playername, playerdata in pairs(me.data) do
		
		me.data[playername] = nil
		mod.garbage.recycle(playerdata)
	end
	
	-- do scan
	local groupid, maxunits
	
	if GetNumRaidMembers() > 0 then
		groupid = "raid"
		maxunits = 40
	
	elseif GetNumPartyMembers() > 0 then
		groupid = "party"
		maxunits = 4
		
	else
		maxunits = 0
	end
	
	local x, unit
	
	for x = 1, maxunits do
		unit = groupid .. x
		
		me.checkunit(unit)
	end
	
	-- also check player for party and solo
	if groupid ~= "raid" then
		me.checkunit("player")
	end
	
end

--[[
me.checkunit(unitid)

Given a Unit ID, looks up the name and class and adds it to <me.data>
]]
me.checkunit = function(unitid)
	
	-- try to get unit name
	local unitname = UnitName(unitid)
	
	-- if none, this unit doesn't exist
	if unitname == nil then
		return
	end
	
	-- get class
	local _, unitclass = UnitClass(unitid)
	
	-- this sometimes returns nil for retarded reasons
	if unitclass == nil then
		unitclass = "unknown"
	end
	
	-- add data
	local playerdata = mod.garbage.gettable() -- { }
	me.data[unitname] = playerdata
	
	playerdata.class = string.lower(unitclass)
	playerdata.unitid = unitid
	
end