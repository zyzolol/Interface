
local me = { name = "datasource"}
local mod = thismod
mod[me.name] = me

--[[
DataSource.lua

This provides a dataset for the GUI.

dataset = { {data}, {data}, ... }, sorted by .threat descending
<data> = 
{
	.name = (player name)
	.threat = (value)
	.tps = (value)
	.percent = (value) -- of max, or aggro target
}
]]

--[[
<mobguid>, <dataset> = mod.datasource.getdefaultdataset()

Gets a dataset for the targetted mob, or targettarget, etc if one exists.

Returns nil if we can't find one.
In fact, you must check both returns are non-nil for OK.

e.g.
/dump klhtm.datasource.getdefaultdataset()
]]
me.getdefaultdataset = function()
	
	-- wrath handler
	if UnitDetailedThreatSituation then
		return me.getwrathdataset()
	end
	
	local mobguid = mod.moblist.gettargettedguid()
	
	if mobguid == nil then
		return
	end
	
	return mobguid, me.getdatasetfortarget(mobguid)
	
end

me.wrathtest = function()
	
	UnitDetailedThreatSituation = function()
		return _, _, _, _, 123
	end
	
end

--[[
TODO: return UnitGUID(unitid) + dataset
]]
me.getwrathdataset = function()
	
	-- 1) get the source mob
	local unitid = mod.moblist.getactiveunitid()
	
	if unitid == nil then
		return
	end
	
	local mobguid = UnitGUID(unitid)
	
	local dataset = mod.garbage.gettable()
	
	dataset.mobguid = mobguid
	dataset.mobname = UnitName(unitid)
	dataset.threat = mod.garbage.gettable()
	
	me.wrathpopulatetable(dataset.threat, unitid)

	-- sort
	me.sorttable(dataset.threat, count)
	
	-- try to get the aggro target for the mob
	local aggrodata = mod.moblist.mobaggro[mobguid]
	local maxvalue = dataset.threat[1].threat
		
	-- now define percent values
	maxvalue = math.max(1, maxvalue)
	
	for index, datarow in pairs(dataset.threat) do
		datarow.percent = math.floor(0.5 + 100 * datarow.threat / maxvalue)
	end
	
	-- return
	return mobguid, dataset

end

me.wrathpopulatetable = function(threatlist, mobunitid)
	
	local count = 0
	
	-- populate with self / party / raid
	
	if GetNumRaidMembers() > 0 then
		
		for x = 1, 40 do
			
			if UnitExists("raid" .. x) then
				
				count = count + 1
				me.wrathaddrow(threatlist, mobunitid, "raid" .. x, count)
			end
		end
		
	else
		
		-- add player
		count = count + 1
		me.wrathaddrow(threatlist, mobunitid, "player", count)
		
		-- add party
		if GetNumPartyMembers() > 1 then
			
			for x = 1, 4 do
				if UnitExists("party" .. x) then
					count = count + 1
					me.wrathaddrow(threatlist, mobunitid, "party" .. x, count)
				end
			end
		end
	end
				
end

me.wrathaddrow = function(threatlist, mobunitid, unitid, count)

	-- insert new row
	local datarow = mod.garbage.gettable()
	threatlist[count] = datarow
	
	-- populate row
	datarow.playername = UnitName(unitid)
	datarow.threat = select(5, UnitDetailedThreatSituation(unitid, mobunitid))
	datarow.tps = 0
	datarow.class = mod.raidlist.getclassforplayer(UnitName(unitid))

end

--[[
<dataset> = me.getdatasetfortarget(mobguid)

Creates a dataset for the given target.

dataset = 
{
	mobguid = (mobguid)
	mobname = (mob name)
	threat =  { (sorted list of <playerdata> }
}
<playerdata> = 
{
	playername = 
	threat = 
	tps = 
}

Returns nil if noone has data for the mob.
]]
me.getdatasetfortarget = function(mobguid)
	
	-- Try to find mob
	local miniguid = string.sub(mobguid, -12, -1)
	local mobdata = mod.threatlist.data[miniguid]
	
	-- No data for the mob: return nil.
	if mobdata == nil then
		return nil
	end

	-- Prepare output
	local dataset = mod.garbage.gettable() -- { }
	dataset.mobguid = mobguid
	
	-- try to find name
	local mobname = mod.moblist.findmobnamefromguid(mobguid)
	
	if mobname then
		dataset.mobname = mobname
	
	-- otherwise use guid string
	else
		dataset.mobname = string.format("%s-%s", string.sub(mobguid, -12, -7), string.sub(mobguid, -6, -1))
	end
	
	dataset.threat = mod.garbage.gettable() -- { }
	local datarow
	local count = 0
	
	-- get all threat data
	for playername, playerdata in pairs(mobdata) do
		
		-- insert new row
		datarow = mod.garbage.gettable()
		count = count + 1
		dataset.threat[count] = datarow
		
		-- populate row
		datarow.playername = playername
		datarow.threat = math.floor(0.5 + playerdata.threat)
		datarow.tps = mod.threatlist.calculatetps(miniguid, playername)
		datarow.class = mod.raidlist.getclassforplayer(playername)
	end
	
	-- sort. Temporarily using custom sort
	--table.sort(dataset.threat, me.datasetsortfunc)
	me.sorttable(dataset.threat, count)
	
	-- try to get the aggro target for the mob
	local aggrodata = mod.moblist.mobaggro[mobguid]
	local maxvalue
	
	if aggrodata and GetTime() < aggrodata.timestamp + 5.0 and mobdata[aggrodata.playername] then
		
		-- found a likely value from aggro data. use it
		maxvalue = mobdata[aggrodata.playername].threat
	
	else
		maxvalue = dataset.threat[1].threat
	end
	
	-- now define percent values
	maxvalue = math.max(1, maxvalue)
	
	for index, datarow in pairs(dataset.threat) do
		datarow.percent = math.floor(0.5 + 100 * datarow.threat / maxvalue)
	end
	
	-- done!
	return dataset
	
end

--[[
Comparer for <datarow>s, biggest first.
]]
me.datasetsortfunc = function(datarow1, datarow2)
	
	-- for reasons not understood, args could sometimes be null. Makes no sense at all reviewing the code, but w/e.
	return (datarow2 == nil) or (datarow1 and datarow1.threat >= datarow2.threat)
	
end

--[[
Implementing custom sorting. While i can't say for sure, i'm guessing that the lua implementation is using quicksort, and it's getting confused by recycled tables, so it's basically sucking.

This is going to be O(n^2) instead, but n is small enough to make no difference.
]]
me.sorttable = function(dataset, count)
	
	for placeindex = 2, count do
		
		local placerow = dataset[placeindex]
		
		-- 1 to (<placeindex> -1) is already sorted. float up row at <placerow>
		
		for checkindex = placeindex -1, 1, -1 do
			
			local checkrow = dataset[checkindex]
			
			if placerow.threat > checkrow.threat then
				
				-- shift placerow up one and keep going
				dataset[checkindex + 1] = checkrow
				
				-- exit condition: up the top
				if checkindex == 1 then
					
					-- put it in
					dataset[1] = placerow
				end
				
			else
				-- put it down in current spot and stop
				dataset[checkindex + 1] = placerow
				break
			end
			
		end
		
	end
	
end
