
-- module setup
local me = { name = "relay"}
local mod = thismod
mod[me.name] = me

--[[
RelayEvent.lua
------------------------------------------------------------------------------------------------

[1] A Relay Event is an important event that should be broadcast to all members of the raid group (who are using the addon). An example is when a Boss resets his threat list - everyone should be notified to zero their own threat. The reason to broadcast the event is that:
	a) Some players might not have an updated version with this particular boss programmed (but they can still respond to the generic reset event)
	b) Some players might not have detected the reset event, due to being out of combat log range.
	
[2] As a consequence of this system, we are allowing other users to greatly affect our state (e.g. resetting our threat) without being able to verify the event. Therefore to make the system robust, we will require two relays of the same event before we accept the event as having occurred. The relays have to come from different users, and be within a specified time interval.

[3] On the other hand, if we ourselves detect an event, we want to trigger it immediately, without waiting for another user to verify the event (who might not exist at all).

[4] Another consideration is the minimise network traffic. If 40 people in a raid group detect an event, we don't need them all to be yelling it to each other. Therefore we will wait a short random amount of time before relaying an event, and if it has already been verified while we waited, we don't need to send it.

[5] We associate with each event a cooldown, which works like its namesake. If the event has been activated in the last <x> seconds, we ignore further broadcasts of it. Each event also has a timeout, which is the maximum allowed time between the initial relay by one user and a confirmation relay from another user. If no confirmation relay is given in the timeout period, the original message is ignored.

------------------------------------------------------------------------------------------------

[6] Each RelayEvent has these properties:

1) A function that is executed when the event fires (e.g. the "clear my threat" function in the above example).
2) Optionally, an argument associated with the function in (1), i.e. a value that will be passed to it. For example, when the event is "set the master target", the argument would be the name of the boss to set.
3) A value for the Cooldown parameter, described above. 5 seconds is usual.
4) A value for the Timeout parameter, described above. This will depend on how long we might randomly wait before relaying the event. If we might wait for up to 3 seconds before sending a particular event, the Timeout should be at least 3 seconds. (In practice == 3 seconds is fine). 
5) Maximum relay delay, as mentioned in (4). Some events can afford to be delayed (e.g. boss death notification, since the fight is probably over by then), while other events are urgent (e.g. threat reset; you don't want other users resetting their threat last and therefore underestimating their threat)
6) A String identifier, in order to reference it in code. 

------------------------------------------------------------------------------------------------

[7] Here is the algorithm to determine how long to wait before relaying an event, as described in [6.4], [6.5]. The basic idea is: if many other users have an equal or higher version of the addon, we know they will broadcast the event, so we pick a random time with a large range. However if most users have a lower version of the addon, they might not have the event programmed, so we will wait a shorter random time.

[8] We determine, from outside sources, a) how many people are using the same version as us; b) how many people are using a higher version. We also have a maximum wait time, which is determined by the specific event. 

[9] The lower bound of the random time is 5% of the maximum time for each person with a higher version, to a maximum of 50%. e.g. If the Max time is 2.0 seconds and there are 3 people with higher versions, the lower bound is 300ms.

[10] The upper bound is 10% of the maximum time for each person with an equal or higher version, to a maximum of 100%. Then we just pick a number in between them and go with it.

------------------------------------------------------------------------------------------------

[11] Usage:

1) Constructor:

trigger = function(value)
	...
end

myrelay = mod.relay.createnew(name, trigger, cooldown, maxdelay)


2) Fire:

myrelay:fireevent(value)

]]

--[[
-- debug enabled
me.mytraces = 
{
	default = "info"
}
]]

me.instances = { } 			-- Table of RelayEvent instances, keyed by their <name> property.
me.netcommand = "event"		-- This is the network message we use to communicate

--[[
myrelay = mod.relay.createnew(name, trigger, cooldown, maxdelay)

RelayEvent Constructor: creates a new instance of a Relay Event.

<name>		string; identifier as in [6.6].
<trigger>	function; the code that runs when the event is confirmed as in [6.1].
<cooldown>	number; described in [5].
<maxdelay>	number; descibed in [6.5].
]]
me.createnew = function(name, trigger, cooldown, maxdelay)
	
	-- name has to be unique because we require it to identify instances
	if me.instances[name] then
		
		-- warn
		if mod.trace.check("warning", me, "duplicatename") then
			mod.trace.printf("A RelayEvent called %s cannot be created because one already exists with that name.", name)
		end
		
		-- disallow
		return 
	end
	
	local myrelay = 
	{
		-- constants
		name = name,
		trigger = trigger,
		cooldown = cooldown,
		maxdelay = maxdelay,
		timeout = maxdelay,
		
		-- variables
		isactive = false,
		lastauthor = "",
		lasttime = 0,
		lastvalue = "",
		
		-- methods
		fireevent = me.fireevent,
		isoncooldown = me.isoncooldown,
		execute = me.execute,
	}
	
	me.instances[name] = myrelay
	return myrelay
		
end

--[[
myrelay:fireevent(value)

Call this function when you detect the event has occurred. The trigger function will be activated, and a relay will be scheduled.

<value> is an optional argument to associate with the event.
]]
me.fireevent = function(myrelay, value)
	
	-- debug
	if mod.trace.check("info", me, "fireevent") then
		mod.trace.printf("The RelayEvent %s is being activated locally with value %s.", myrelay.name, tostring(value))
	end
	
	-- don't broadcast if it is on cooldown
	if myrelay:isoncooldown() then
		
		-- debug
		if mod.trace.check("info", me, "cooldown") then
			mod.trace.printf("The RelayEvent %s will not be fired because it is is on cooldown.")
		end
		
		-- ignore
		return
	end
		
	-- schedule broadcast (refer to [7] - [10]).
	local minvalue = myrelay.maxdelay * 0.05 * math.min(10, mod.verinfo.numhigher)
	local maxvalue = myrelay.maxdelay * 0.10 * math.min(10, mod.verinfo.numhigher + mod.verinfo.numequal)
	
	local waittime = minvalue + math.random() * (maxvalue - minvalue)
	
	mod.schedule.schedule(myrelay.name, waittime, me.onrelayscheduled, myrelay.name, value)
	
	-- debug
	if mod.trace.check("info", me, "schedule") then
		mod.trace.printf("The event %s will be relayed in %s seconds (between %s and %s).", myrelay.name, waittime, minvalue, maxvalue)
	end
		
end

--[[
bool = myrelay:isoncooldown()

Returns true if the RelayEvent is on cooldown. That is, it has procced recently. Note that if the RelayEvent is active, it can't be on cooldown.
]]
me.isoncooldown = function(myrelay)
	
	return (myrelay.isactive == false) and (GetTime() < myrelay.lasttime + myrelay.cooldown)
	
end

--[[
This is called by the <schedule> module when it is time to relay an event we had scheduled. 

<relayname> is the identifier of the RelayEvent instance.
<value> is whatever value was associated with it, possibly nil.
]]
me.onrelayscheduled = function(relayname, value)
	
	-- debug
	if mod.trace.check("info", me, "schedule") then
		mod.trace.printf("The scheduled relay of the %s event is activating.", relayname)
	end
	
	local myrelay = me.instances[relayname]
	
	-- abort if it is on cooldown
	if myrelay:isoncooldown() then
		
		-- debug
		if mod.trace.check("info", me, "cooldown") then
			mod.trace.printf("The event %s will not be relayed because it is is on cooldown.", myrelay.name)
		end
		
		-- ignore
		return
	end
	
	-- construct message
	local message = me.netcommand .. " " .. myrelay.name
	
	if value then
		message = message .. " " .. value
	end 
	
	-- send
	mod.net.sendmessage(message)
	
	-- debug
	if mod.trace.check("info", me, "relay") then
		mod.trace.printf("Relaying the event %s with value %s. Message = %s.", myrelay.name, tostring(value), message)
	end
		
end

--[[
--------------------------------------------------------------------------------------
							NetIn Service
--------------------------------------------------------------------------------------
]]

me.mynetmessages = { me.netcommand }

me.onnetmessage = function(author, command, data)
	
	-- parse relay name and value
	local relayname, value = string.match(data, "([a-zA-Z]+) ?(.*)")
	
	if relayname == nil then
		return "invalid"
	end
	
	-- value is optional
	if value == "" then
		value = nil
	end
	
	-- check for valid relay name
	if me.instances[relayname] == nil then
		
		-- debug
		if mod.trace.check("info", me, "badrelayname") then
			mod.trace.printf("The relayevent %s given by %s is not recognised.", relayname, author)
		end
		
		-- ignore
		return
	end
	
	-- process
	me.onrelayreceived(relayname, value, author)
	
end

--[[
This is called when we receive a relay from a user (possibly ourself). 

<relayname> string; identifier of the relayevent,
<value>		string; extra data, possibly nil.	
]]
me.onrelayreceived = function(relayname, value, author)
	
	local myrelay = me.instances[relayname]
	
	-- check for cooldown
	if myrelay:isoncooldown() then
		
		-- debug
		if mod.trace.check("info", me, "cooldown") then
			mod.trace.printf("The relay of %s will be ignored because it is on cooldown.", relayname)
		end
	
		-- ignore
		return
	end
	
	-- There are two distinct cases; one where the event is active (i.e. it has been sent recently and is awaiting confirmation), and one where it is inactive.
	local timenow = GetTime()
	
	-- 1) RelayEvent is inactive
	if myrelay.isactive == false then
		
		-- enable
		myrelay.isactive = true
		myrelay.lastauthor = author
		myrelay.lastvalue = value
		myrelay.lasttime = timenow
		
		-- debug
		if mod.trace.check("info", me, "activate") then
			mod.trace.printf("The relayevent %s is activated by %s with the value %s.", myrelay.name, author, tostring(value))
		end
		
		-- events relayed from ourself don't require confirmation
		if author == UnitName("player") then
			myrelay:execute(author)
		end
		
	-- 2) RelayEvent is active (awaiting confirmation)
	else
		
		-- ignore messages from the same player as the original
		if author == myrelay.lastauthor then
			return
		end
		
		-- check for value mismatch
		if value ~= myrelay.lastvalue then
			
			if mod.trace.check("info", me, "valuemismatch") then
				mod.trace.printf("The relayevent %s was given the value %s by %s, but %s gave the value %s.", myrelay.name, tostring(myrelay.lastvalue), author, tostring(value))
			end
			
			-- overwrite value and player
			myrelay.lastvalue = value
			myrelay.lasttime = timenow
			myrelay.lastauthor = author
		
		-- value matches. This is a confirmation
		else
			myrelay:execute(author)
		end
	end
	
end

--[[
myrelay:execute(confirmer)

This is called internally when an event is confirmed. Runs trigger, resets relay, debugs.
]]
me.execute = function(myrelay, confirmer)
	
	if mod.trace.check("info", me, "execute") then
		mod.trace.printf("The relayevent %s is executing with value %s. It was activated by %s and confirmed by %s.", myrelay.name, tostring(myrelay.lastvalue), myrelay.lastauthor, confirmer)
	end
	
	-- reset
	myrelay.isactive = false
	myrelay.lasttime = GetTime()
	
	-- run
	myrelay.trigger(myrelay.lastvalue)
		
end