
local me = { name = "taunt"}
local mod = thismod
mod[me.name] = me

--[[
Taunt.lua

Handles the Taunt class of spells: Warrior's Taunt, Druid's Growl, Paladin's Righteous Defense.

To debug this module, uncomment this code:

me.mytraces = 
{
	default = "info",
}

--]]

me.filter = 
{
	source = { affiliation = "mine", objecttype = "player", control = "player" },
}

me.mycombatevents = 
{
	SPELL_MISSED = me.filter,
	SPELL_CAST_SUCCESS = me.filter,
}

me.tauntspells = 
{
	[355] = "taunt",
	[31790] = "righteous defense on mob",	-- 31789 is RD on player
	[6795] = "growl",
}

-- This stores pending Taunts we are waiting to confirm
me.pending = { } --[[
{
	[mobguid] = { casttime = (x), threatgain = (x) }
}
]]

me.oncombatevent = function(timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags, spellid)

	-- check spellid is taunt
	if me.tauntspells[spellid] == nil then
		return
	end
	
	if eventname == "SPELL_MISSED" then
		
		-- debug
		if mod.trace.check("info", me, "miss") then
			mod.trace.printf("Taunt on '%s' missed. Aborting.", destname) 
		end
		
		-- kill
		if me.pending[destguid] then
			me.pending[destguid] = nil
		end
	
	elseif eventname == "SPELL_CAST_SUCCESS" then
	
		-- calculate threat we will gain
		local threat = me.gettauntthreatgain(destguid)
		
		if threat <= 0 then
			
			-- no threat gain. log and exit
			if mod.trace.check("info", me, "nothreat") then
				mod.trace.printf("Taunted '%s' but there is no possible threat gain - ignoring.", destname)
			end
			
			return
		end
	
		-- store this up for later
		local newdata = mod.garbage.gettable()
		
		newdata.casttime = GetTime()
		newdata.threatgain = threat
	
		me.pending[destguid] = newdata
	
		if mod.trace.check("info", me, "pending") then
			mod.trace.printf("Taunt threat of '%s' pending on '%s'.", threat, destname)
		end

	end

end

me.myonupdates = 
{
	checkpendingtaunts = 0.1	
}

me.checkpendingtaunts = function()
	
	local timenow = GetTime()
	
	for key, value in pairs(me.pending) do
		
		if timenow > value.casttime + 1 then
			
			-- confirm taunt!
			
			-- log	
			if mod.trace.check("info", me, "confirmed") then
				mod.trace.printf("Confirmed taunt on '%s' for +'%s' threat.", key, value.threatgain)
			end
			
			-- execute
			mod.mythreat.addtarget(key, value.threatgain)
		
			-- recycle table
			me.pending[key] = nil
			mod.garbage.recycle(value)
		end
	end
	
end

-- TODO: returns amount of threat we would gain if we taunted the given mob now.
-- or, 0  / negative for nah.
me.gettauntthreatgain = function(mobguid)
	
	-- get predicted new threat
	local newthreat = me.getnewthreat(mobguid)
	
	if newthreat == nil then
		return 0
	end
	
	-- get current threat
	local currentdata = mod.mythreat.datalookup[mobguid]
	
	if currentdata then
		return newthreat - currentdata.threat
	else
		return 0
	end
	
end

--[[
mod.taunt.taunt(mobguid)

Called by CombatParser.lua when one of the taunt abilities are fired. These are "Taunt" or "Growl" (bear) or "Righteous Defense". The corresponding values of <spellid> are "taunt", "growl", "righteousdefense".
<target> is the name of the mob that was taunted.
]]
me.getnewthreat = function(mobguid)
	
	local miniguid = string.sub(mobguid, -12, -1)
	
	-- get known threat for this mob
	local mobdata = mod.threatlist.data[miniguid]
	
	-- give up if we can't find it
	if mobdata == nil then
		
		-- log and exit
		if mod.trace.check("info", me, "unknownmob") then
			mod.trace.printf("Can't find any threat data for taunt on %s.", mobguid)
		end
		
		return
	end	
		
	-- check for mobaggro
	local mobaggrodata = mod.moblist.mobaggro[mobguid]
	
	if mobaggrodata then
		
		if GetTime() > mobaggrodata.timestamp + 5.0 then
			
			-- DEBUG
			if mod.trace.check("info", me, "oldaggro") then
				mod.trace.printf("Taunt on %s: mob is known to have aggro on %s, but the data is %s seconds out of date, so discarded.", mobguid, mobaggrodata.playername, GetTime() - mobaggrodata.timestamp)
			end
			
		else
			
			-- try to get threat for known aggro target
			local playerdata = mobdata[mobaggrodata.playername]
			
			if playerdata then
				
				-- got a result
				if mod.trace.check("info", me, "taunt") then
					mod.trace.printf("Taunting to %s threat on mob %s, aggro %s.", playerdata.threat, mobguid, mobaggrodata.playername)
				end
				
				return playerdata.threat
			
			else
				-- can't find data for known aggro holder
			
				-- log and fall through
				if mod.trace.check("info", me, "unknownplayer") then
					mod.trace.printf("Taunt on %s: threat is unknown because we have no value for player %s.", mobguid, mobaggrodata.playername)
				end
			
			end
			
		end
	end		
		
	-- to get here, mob aggro data was no help. Go for #1 threat. TODO: improve though.
	local maxthreat
	local maxplayer
	
	-- find #1 threat
	for playername, playerdata in pairs(mobdata) do
		
		if maxthreat == nil or playerdata.threat > maxthreat then
			
			maxthreat = playerdata.threat
			maxplayer = playername
		end
	end
	
	-- debug
	if mod.trace.check("info", me, "guessmax") then
		mod.trace.printf("Taunt on %s: choosing #1 threat holder, %s, for %s threat.", mobguid, maxplayer, maxthreat)
	end
	
	return maxthreat
	
end


