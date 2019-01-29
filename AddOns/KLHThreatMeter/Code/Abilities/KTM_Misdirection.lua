
local me = { name = "misdirection"}
local mod = thismod
mod[me.name] = me

--[[
Misdirection.lua

Handles the Hunter spell Misdirection.

]]


--[[
------------------------------------------------------------------------
				Member Variables
------------------------------------------------------------------------
]]

me.target = nil			-- who we targeted, if we cast it
me.isactive = false
me.starttime = 0.0		-- when we gained the buff
me.iscaster = false		-- whether we cast the misdirection (true) or received it (false)
	
-- constants
me.duration = 30.0		-- maximum buff duration

--[[
------------------------------------------------------------------------
			Services from Updates.lua
------------------------------------------------------------------------
]]

me.myonupdates = 
{	
	updatemisdirection = 1.0
}

me.updatemisdirection = function()
	
	-- safety timeout when duration expires
	if me.isactive and (GetTime() > me.starttime + me.duration) then
		me.isactive = false
		
		-- debug
		if mod.trace.check("info", me, "timeout") then
			mod.trace.print("MD buff timed out.")
		end
	end
	
end

--[[
------------------------------------------------------------------------
			Services from CombatEvents.lua
------------------------------------------------------------------------
]]

--[[
MD event filter. Source is always object.none. Dest is always me (that we care about)
]]
me.filters = 
{
	onme =  
	{ 
		dest = { objecttype = "player", affiliation = "mine" } 
	},

	fromme =  
	{
		source = { affiliation = "mine", objecttype = "player", control = "player" },
	},
}

me.mycombatevents = 
{
	SPELL_AURA_APPLIED = me.filters.onme,
	SPELL_AURA_REMOVED = me.filters.onme,
	SPELL_CAST_SUCCESS = me.filters.fromme,
}

me.mdsendingid = 34477
me.mdreceivingid = 35079

me.oncombatevent = function(...)
	
	local timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags, spellid = select(1, ...)
		
	-- cast OK: get target
	if eventname == "SPELL_CAST_SUCCESS" then
		
		if spellid == me.mdsendingid then
			
			-- debug
			if mod.trace.check("info", me, "cast") then
				mod.trace.printf("MD cast, on %s.", destname)
			end
			
			-- set target
			me.target = destname
		end
		
		return
	end
	
	-- filter: spell == misdirection
	if spellid ~= me.mdsendingid and spellid ~= me.mdreceivingid then
		return
	end
	
	-- debug
	if mod.trace.check("info", me, "buff") then
		mod.trace.printf("MD Buff, event = '%s', ID = '%s'.", eventname, spellid)
	end
	
	if eventname == "SPELL_AURA_REMOVED" then
		me.isactive = false
		return
	end
	
	if eventname == "SPELL_AURA_APPLIED" then
		me.isactive = true
		me.iscaster = (spellid == me.mdsendingid)
		me.starttime = GetTime()
	end
	
end

--[[
------------------------------------------------------------------------
			Public Interface
------------------------------------------------------------------------
]]

--[[
<bool> = mod.misdirection.interrupt(mobguid, threat)

Returns true if misdirection takes the threat of the attack
]]
me.interrupt = function(mobguid, threat)
	
	if me.isactive and me.iscaster and threat > 0 then
		
		me.sendmisdirect(mobguid, threat)
		return true
		
	end		
	
end

--[[
me.sendmisdirect(mobguid, threat)

Sends a network message describing misdirected threat.
]]
me.sendmisdirect = function(mobguid, threat)
	
	-- sanitise
	threat = math.floor(threat)
	
	-- check for no target
	if me.target == nil then
		
		-- warn and exit
		if mod.trace.check("warning", me, "notarget") then
			mod.trace.print("No target known for misdirect but it is active and sending.")
		end
		
		return
	end
	
	local message = string.format("md %s %s %s", me.target, mobguid, threat)
	mod.net.sendmessage(message)
	
	-- debug
	if mod.trace.check("info", me, "send") then
		mod.trace.printf("Sending this message: %s.", message) 
	end
	
end

--[[
------------------------------------------------------------------------
			Services from NetIn.lua
------------------------------------------------------------------------
]]

me.mynetmessages = { "md" }

me.onnetmessage = function(author, command, data)
	
	-- safety check of command
	if command ~= "md" then
		return
	end
		
	-- try to parse message
	local _, _, player, mobguid, value = string.find(data, "(%S+) (%S+) (%d+)")
	
	value = tonumber(value)
	
	-- exit on fail
	if value == nil then
		
		-- warn and exit
		if mod.trace.check("warning", me, "badnetin") then
			mod.trace.printf("This MD message from '%s' did not parse: %s.", author, data)
		end
		
		return "invalid"
	end
	
	-- only care about messages to me
	if player ~= UnitName("player") then
		return
	end
		
	-- ignore if buff not active
	if me.isactive == false then
		
		-- warn and exit
		if mod.trace.check("warning", me, "badnetin") then
			mod.trace.printf("Got an MD message from '%s' for '%s' threat on '%s', but the buff is not active.", author, value, mobguid)
		end
		
		return
	end
		
	-- apply threat	
	mod.mythreat.addtarget(mobguid, value)
		
end