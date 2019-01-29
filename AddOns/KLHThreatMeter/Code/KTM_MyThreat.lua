
local me = { name = "mythreat"}
local mod = thismod
mod[me.name] = me

--[[
MyThreat.lua

This module tracks the player's threat vs all applicable targets.

Output Module Usage:

	mod.netout.sendthreat(data)
	
	data = { {mobdata}, {mobdata}, ... }
	mobdata = { mob = <partial guid>, value = <threat vs that mob> }		
]]

--[[
----------------------------------------------------------------------------------------
						Private Variables
----------------------------------------------------------------------------------------
--]]

me.datalookup = { } --[[
{
	<guid_A> = <mobdata_A>,
	<guid_B> = <mobdata_B>,
	...
}

<mobdata> = 
{
	mob = (guid; same as key in <me.datalookup>
	threat = (number; current threat vs mob)
	changetime = (timestamp; last GetTime() when the value was changed)
[nil]	sendtime = (timestamp; last GetTime() when this value was sent to raid)
[nil] sendvalue = (number; last value sent)
}
]]

me.datasorted = { } --[[
(list of <mobdata>, sorted by threat; top highest).
]]

--[[
----------------------------------------------------------------------------------------
						Internal Methods
----------------------------------------------------------------------------------------
--]]

me.raidsendinterval = 1.0	-- (minimum) time in seconds between threat notifications to raid
me.purgedatainterval = 5.0	-- (minimum) time in seconds between checking for out of data / unused data
me.dataexpiretime = 10.0	-- (minimum) time for cleared data to expire - be removed from our sets.

me.myonupdates = 
{
	updatethreattoraid = me.raidsendinterval,
	updateunuseddata = me.purgedatainterval
}

--[[
----------------------------------------------------------------------------------------
							Public Interface
----------------------------------------------------------------------------------------
--]]

----------------------------------------------------------------------------------------
--							Remove from List
----------------------------------------------------------------------------------------

--[[
mod.mythreat.endcombat()

Called when the player leaves combat. Not only is threat reset to zero for all mobs, but they should be taken off our threat list too. We should also notify other players (for healing calculations).
]]
me.endcombat = function()
		
	if me.removeallmobdata() > 0 then
				
		-- if we had any data, notify raid
		mod.net.sendmessage("endcombat") -- this message is received by the ThreatList module.
		
	end
	
end

--[[
mod.mythreat.mobdeath(mobguid)

Report that a mob has died. It will be removed from the threat list.
]]
me.mobdeath = function(mobguid)
	
	-- mob might not exist in our list. Remove it if it does.
	local mobdata = me.datalookup[mobguid]
	
	if mobdata then
				
		me.removemobdata(mobdata)
	end
	
end

----------------------------------------------------------------------------------------
--							Threat Clears
----------------------------------------------------------------------------------------

--[[
mod.mythreat.clearall()

Clears player's threat against all targets.

This comes from leaving combat and vanish.
]]
me.clearall = function()
		
	me.multiplyall(0)
	
end

--[[
mod.mythreat.cleartarget(targetguid)

Clears player's threat against a given target.

This comes from scripted boss events like phase transitions.
]]
me.cleartarget = function(targetguid)
	
	me.multiplytarget(targetguid, 0)
	
end

----------------------------------------------------------------------------------------
--							Threat Multipliers
----------------------------------------------------------------------------------------

--[[
mod.mythreat.multiplyall(value)

Multiplies player's threat on all targets by a given value.

This applies to spells like soul shatter and pain suppression.
]]
me.multiplyall = function(value)

	for modguid, mobdata in pairs(me.datalookup) do
		
		me.setmobdatathreat(mobdata, mobdata.threat * value)
		
	end
	
end

--[[
mod.mythreat.multiplytarget(targetguid, value)

Multilplies player's threat on a given target by a given value.

This applies to spells like knock away.
]]
me.multiplytarget = function(targetguid, value)
	
	local mobdata = me.datalookup[targetguid]
	
	-- GUID might not be known
	if mobdata == nil then
		return
	end
	
	me.setmobdatathreat(mobdata, mobdata.threat * value)
	
end

----------------------------------------------------------------------------------------
--							Normal Threat Addition
----------------------------------------------------------------------------------------

me.validation = { }

me.validation.addtarget = { { type = "string" }, { type = "number" } }

--[[
mod.mythreat.addtarget(targetguid, value)

Adds the specified threat value to the given target.

This is for normal attacks.
]]
me.addtarget = function(targetguid, value)
		
	local mobdata = me.datalookup[targetguid]
	
	-- GUID might not be known
	if mobdata == nil then
		
		-- create a new entry
		mobdata = me.createdataformob(targetguid)
		
	end
	
	me.setmobdatathreat(mobdata, mobdata.threat + value)
	
end


--[[
----------------------------------------------------------------------------------------
						Internal Methods
----------------------------------------------------------------------------------------
--]]

--[[
me.setmobdatathreat = function(<mobdata>, <value>)
	
Internal Method to change threat.
	
]]
me.setmobdatathreat = function(mobdata, value)
	
	mobdata.threat = value
	mobdata.changetime = GetTime()
	
end

--[[
Polled method, interval defined in the top of the module.

Removes any data that is probably no longer applicable: zeroed and no change for a while

Also data = old but player = out of combat.
]]
me.updateunuseddata = function()
	
	local timenow = GetTime()
	
	for mobguid, mobdata in pairs(me.datalookup) do
		
		-- normal expired data: 0 threat and been that way for a while
		if mobdata.threat == 0 and mobdata.sendvalue == 0 and timenow > mobdata.changetime + me.dataexpiretime then
			me.removemobdata(mobdata)
		
		elseif timenow > mobdata.changetime + me.dataexpiretime and (not UnitAffectingCombat("player")) then
			me.removemobdata(mobdata)
		
		-- emergency case: data has probably failed to clear
		elseif timenow > mobdata.changetime + 600 then
			
			me.removemobdata(mobdata)
			
		end
	end
	
end

--[[
me.removemobdata(mobdata)

Stop tracking the given <mobdata>. Called when the data expires (zeroed and old).
]]
me.removemobdata = function(mobdata)
		
	-- remove from sorted set, by swapping with the last item, then deleting this one
	-- NOTE: this will violate the sorted constraint, but it is always regenerated before sending.
	
	-- 1) swap
	me.datasorted[mobdata.order] = me.datasorted[#me.datasorted]
	
	-- 3) set the .order property of the one moved from the back correct. It's required to locate it!	
	me.datasorted[mobdata.order].order = mobdata.order
	
	-- 2) remove
	me.datasorted[#me.datasorted] = nil
		
	-- remove from data lookup
	me.datalookup[mobdata.mob] = nil
	
	-- recycle
	mod.garbage.recycle(mobdata)
	
end

--[[
<number> = me.removeallmobdata()

Resets the state of the threat list.

Returns: number of entries removed.
]]
me.removeallmobdata = function()
		
	local numremoved = 0
	
	-- empty <datasorted> view
	for key, value in pairs(me.datasorted) do
		
		me.datasorted[key] = nil
		numremoved = numremoved + 1
	end
	
	-- empty <datalookup> view, and recycle
	for key, value in pairs(me.datalookup) do
		
		me.datalookup[key] = nil
		
		mod.garbage.recycle(value)
	end
	
	return numremoved
	
end

--[[
<mobdata> = me.createdataformob(guid)

Creates a new <mobdata> entry for a given GUID, and adds its to the lookup and sorted set.
Used when a threat addition is called and there is no matching <mobdata> entry.
]]
me.createdataformob = function(guid)
	
	local mobdata = mod.garbage.gettable() -- { }
		
	-- now populate table
	mobdata.threat = 0
	mobdata.mob = guid
	mobdata.changetime = GetTime()
	
	-- now add to our data sources
	table.insert(me.datasorted, mobdata)
	mobdata.order = #me.datasorted
	
	me.datalookup[guid] = mobdata
	
	return mobdata
	
end


--[[
----------------------------------------------------------------------------------------
						MyThreat.Send Submodule
----------------------------------------------------------------------------------------
--]]

--[[
Sending our Threat to Network Output.

With multiple targets, there's potentially an excess of information for us to send to other clients. We employ a few measures to limit the amount of threat information we send out.

The basic principles are:

	-	Limit max targets we broadcast threat against
	-	On a list sorted by threat, broadcast values down the bottom less frequently
	-	If a value hasn't changed appreciably, don't broadcast it

The format of our output data is:

mod.net.sendthreat(data, maxindex)

	<data> 	= { <mobdata>, <mobdata>, ... }
	<mobdata>= 
	{ 
		mob = (string; reduced length GUID for target),
		threat = (number; threat value, possibly non-integral, possibly negative)	
	}
	
	<maxindex> = (integer; maximum index of the array <data> to use. Don't use data after <maxindex>! <maxindex> is guaranteed to be within the bounds of the array.
]]

--[[
This is a polled function defined above, and the entry point for the "Send" submodule.
]]
me.updatethreattoraid = function()
	
	me.send.run()
	
end

me.send = { }

do		-- This code is the "Send" submodule

-- This is for the submodule. <up> now points to the <me> in the main module.
local up = me
local me = up.send
	
-- constants:
me.maxtargets = 10		-- maximum number of targets we will notify about
me.maxsenddelay = 5.0	-- maximum delay between sends for any mob

-- variables:
me.output = { }

--[[
Does all the work to create a new output set.
]]
me.run = function()
	
	-- 1) resort current data set. It's assumed that the main module will keep <me.datasorted> up to date.
	table.sort(up.datasorted, me.sortfunc)
	
	-- keep <mobdata.order> synchronised with its index
	for index, mobdata in ipairs(up.datasorted) do
		mobdata.order = index
	end
	
	-- timestamp marker
	local timenow = GetTime()
	
	-- number of entries in <me.output> bing used
	local outputcount = 0	
	
	-- 2) work out which values apply for a new send
	for index, mobdata in ipairs(up.datasorted) do
		
		if me.issignificantchange(mobdata, index, timenow) then
			
			-- mark this entry as sent
			mobdata.sendtime = timenow
			mobdata.sendvalue = mobdata.threat
		
			-- add it to output
			outputcount = outputcount + 1
			me.output[outputcount] = mobdata
			
			-- exit condition
			if outputcount >= me.maxtargets then
				break
			end
		end
	end
	
	-- 3) Pass to <net> module for network transfer
	mod.netthreat.sendthreat(me.output, outputcount)
	
end
	
--[[
Comparer callback function used to sort the threat data.
]]
me.sortfunc = function(left, right)
	
	return left.threat > right.threat
	
end
	
--[[
<bool> = me.issignificantchange(mobdata, index, timenow)

Returns true if the data in <mobdata> has changed enough to require being resent. 

<mobdata> is an entry in <up.datasorted>.
<index> is the sorted position of this entry. 1 = highest, 999 = really low
<timenow> is the current timestamp.
]]
me.issignificantchange = function(mobdata, index, timenow)
	
	-- always send if no previous value send
	if mobdata.sendvalue == nil then
		return true
	end
	
	-- always send if the idle timeout has expired
	if timenow > mobdata.sendtime + me.maxsenddelay then
		return true
	end
	
	-- otherwise, send depending on how much your threat has changed, c.f. mob's index
	local minchange = 0.01 * (index - 1)^1.5
	--[[ 	Index		MinChange
			1			 0%
			2			 1%
			3			 3%	
			6			15%
			10			31%
	]]
	
	-- push threat out of the small value range
	local previousvalue = mobdata.sendvalue
	if math.abs(previousvalue) < 1 then 
		previousvalue = 1
	end
	
	--[[
	mobdata.threat / previousvalue		ratio of current to old value. If new = 150, old = 100, ratio = 1.5
	math.abs(1 - x)	difference from 1. In the above example, the difference is 0.5, or 50% away from 1.
	> minchange			has to be larger than the <minchange> percentages given above.
	]]
	if math.abs(1 - (mobdata.threat / previousvalue)) > minchange then
		return true
	end
		
end
	
end	-- end of "Send" subomdule

