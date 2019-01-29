
local me = { name = "net"}
local mod = thismod
mod[me.name] = me

--[[
Net.lua

This module has some random code for a few network functions. Also lots of message sending functions.
]]

-- Special onupdate method from Core.lua
me.onupdate = function()
	
	me.checkversionquery()
	
end

--[[
---------------------------------------------------------------------------------------------
			Slash Commands: Version Management
---------------------------------------------------------------------------------------------
]]

me.myconsole = 
{
	version = 
	{
		notify = "versionnotify",
		query = "versionquery",
	},
	
	disable = "fulldisable",
	enable = "fullenable",
}

--[[
This activates from the slash command "/mod disable". It doesn't really belong here but i can't think where else to put it!
]]
me.fulldisable = function()
		
	if mod.isenabled == false then
		mod.print("The mod is already disabled. Run the 'enable' command to restart it.")
		
	else
		mod.isenabled = false
		mod.print("The mod has been disabled, and won't work until you run the 'enable' command.")
	end
end

--[[
This activates from the slash command "/mod enable". It doesn't really belong here but i can't think where else to put it!
]]
me.fullenable = function()
	
	if mod.isenabled == true then
		mod.print("The mod is already running.")
		
	else
		mod.isenabled = true
		mod.print("The mod has been restarted, and will now receive events / onupdate.")
	end
	
end

--[[
Sends a message to other players in the raid. If they are running an older KTM version, it will ask them to upgrade.
]]
me.versionnotify = function()

	if me.checkpermission() == nil then
		return
	end
	
	me.sendmessage(string.format("version %d.%d", mod.global.release, mod.global.revision))
	mod.print(mod.string.get("print", "network", "upgradenote"))
	
end

--[[
Asks everyone in the raid group to report their version.
]]
me.versionquery = function()
	
	if me.checkpermission() == nil then
		return
	end
	
	-- clear the version table
	local key

	for key, _ in pairs(me.raidversions) do
		table.remove(me.raidversions, key)
	end
	
	-- set the timeout for responses
	me.versionquerytimeout = GetTime() + 2
	
	-- Notify the user
	mod.print(mod.string.get("print", "network", "versionrequest"))
	
	-- send the message
	me.sendmessage("versionquery")
		
end


--[[
---------------------------------------------------------------------------------------------
			Net Module Network Messages: Version Management
---------------------------------------------------------------------------------------------
]]

-- Event service (see Events.lua)
me.myevents = {"CHAT_MSG_ADDON" }

me.spoofers = { }

-- Special onevent function from Events.lua
me.onevent = function()

	-- check the message comes from this addon, and comes from the party or raid
	if (arg1 == "Thr") then
		me.spoofers[arg4] = true
	end
			
end

me.mynetmessages = { "version", "versionquery", "versionresponse" }

me.onnetmessage = function(author, command, data)
	
	-- version - tell people to upgrade if they have old versions
	if command == "version" then
		
		-- check the author has permission
		if mod.unit.isplayerofficer(author) == nil then
			return "permission"
		end
		
		-- next argument should be the version number
		local release, revision
		_, _, release, revision = string.find(data, "(%d+)%.(%d+)")
		
		-- check parse worked
		release = tonumber(release)
		revision = tonumber(revision)
		
		if (release == nil) or (revision == nil) then
			return "invalid"
		end
		
		-- newer versions send their release and revision numbers, in a dot delimited string.			
		if (release < mod.global.release) or (release == mod.global.release and revision < mod.global.revision) then
			-- other guy has an old version. Ignore.
				
		elseif (release == mod.global.release) and (revision == mod.global.revision) then
			-- we have the same version; do nothing
				
		else
			-- we have an older version - upgrade!
			mod.printf(mod.string.get("print", "network", "upgraderequest"), author, release .. "." .. revision, mod.global.release .. "." .. mod.global.revision)
			
		end
	
	-- versionquery - asking everyone to say what version they are using
	elseif command == "versionquery" then
		
		-- check the author has permission
		if mod.unit.isplayerofficer(author) == nil then
			return "permission"
		end		
		
		-- send our version
		mod.net.sendmessage("versionresponse " .. mod.global.release .. "." .. mod.global.revision)
	
	-- versionrespeonse - everyone is stating what version they are using
	elseif command == "versionresponse" then

		-- next argument should be the version number
		local value = tonumber(data)
		
		if value == nil then
			return "invalid"
		end
		
		if me.spoofers[author] and value < 100 then
			return
		end
		
		me.addversionresponse(author, data)	
		
	end
	
end

------------------------------------------------------------------------------------------------

--[[
mod.net.sendmessage(message)
Sends a message to the Addons chat channel.
<message> is a string.
Return: true (compatability).
]]
--! This variable is referenced by these modules: boss, netin, 
me.sendmessage = function(message)
	
	if GetNumRaidMembers() > 0 then
		SendAddonMessage(mod.global.addonmessageprefix, message, "RAID")
	
	elseif GetNumPartyMembers() > 0 then
		SendAddonMessage(mod.global.addonmessageprefix, message, "PARTY")
	
	else
		-- Send directly to our input handler
		mod.netin.messagein(UnitName("player"), message, 1)
	end
	
	return true
	
end


------------------------------------------------------------------------------------------------

---------------------------------
--    Special Raid Commands    --
---------------------------------

--[[ 
me.checkpermission()
Returns: non-nil iff you are allowed to send special commands (raid assistant / party leader, etc)
]]
--! This variable is referenced by these modules: console, 
me.checkpermission = function()

	if mod.unit.isplayerofficer(UnitName("player")) == true then
		return true
		
	else
		mod.print(mod.string.get("print", "network", "raidpermission"))
		return
	end
	
end
	


-- Version Querying Stuff. Key = release number, value = array of names
me.raidversions = { }
me.versionquerytimeout = 0 -- 0 = inactive, > 0 = active. Return value of GetTime()

--! This variable is referenced by these modules: netin, 
me.addversionresponse = function(playername, version)

	local versionstring = tostring(version)
	
	-- ignore unless we are checking versions
	if me.versionquerytimeout > 0 then
	
		if me.raidversions[versionstring] == nil then
			me.raidversions[versionstring] = { }
		end
		
		me.raidversions[versionstring][playername] = true
	end

end


-- When we do "/ktm version query", the rest of the raid has 3 seconds to respond.
me.checkversionquery = function()
	
	if me.versionquerytimeout == 0 then
		return
	end
	
	if GetTime() > me.versionquerytimeout then
		
		-- print it out and stuff
		me.versionquerytimeout = 0
		
		local message
		local key
		local value
		local key2
		local namesfound = { }
		
		for key, value in pairs(me.raidversions) do
			message = string.format(mod.string.get("print", "network", "versionrecent"), key)
			
			for key2, _ in pairs(value) do
				message = message .. key2 .. ", "
				namesfound[key2] = true
			end
			
			message = message .. " }."
			mod.print(message)
			
			table.remove(me.raidversions, key)
		end
		
		-- Now print the people who have out of date versions
		message = mod.string.get("print", "network", "versionold")
		for key, _ in pairs(mod.table.raiddata) do
			if namesfound[key] == nil and mod.unit.isplayeringroup(key) == true then
				namesfound[key] = true
				message = message .. key .. ", "
			end
		end
		
		message = message .. " }."
		mod.print(message)
		
		-- Now print out people who are not talking to us
		message = mod.string.get("print", "network", "versionnone")
		
		for value = 1, 40 do
			key = GetRaidRosterInfo(value)
			if (key ~= nil) and (namesfound[key] == nil) then
				namesfound[key] = true
				message = message .. key .. ", "
			end
		end
		
		message = message .. " }."
		mod.print(message)
		
	end
end
