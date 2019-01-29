
-- module setup
local me = { name = "verinfo"}
local mod = thismod
mod[me.name] = me

--[[
VersionInfo

This module provides information about versions and locales of other players in the raid.

It is a bit limited currently, because we ignore players who don't share our locale.
]]

--[[
--------------------------------------------------------------------------------------
							Member Variables
--------------------------------------------------------------------------------------
]]

me.players = { } --[[
me.players = 
{
	name1 = <playerdata>,
	name2 = <playerdata>,
	...
}

<playerdata> = 
{
	enabled = true / false,
	version = <integer>,
	revision = <integer>,
	time = <GetTime()>,
}]]

me.numhigher = 0	-- number of players with higher versions than us
me.numequal = 0	-- number of players with our version

--[[
--------------------------------------------------------------------------------------
							OnUpdate Services
--------------------------------------------------------------------------------------
]]

me.myonupdates = 
{
	updateinfo = 60.0,
}

me.updateinfo = function()
	
	-- send my info
	mod.net.sendmessage(string.format("info %s %s %s", mod.string.mylocale, mod.global.release, mod.global.revision))
	
	-- update other people's info. 3 min timeout
	local timeout = GetTime() - 180
	local count = 0
	
	me.numhigher = 0
	me.numequal = 0
	
	for player, data in pairs(me.players) do
		if data.isenabled == true and data.lasttime < timeout then
			data.isenabled = false
		end
		
		if data.isenabled then
			-- collect version info
			if data.version > mod.global.release then
				me.numhigher = me.numhigher + 1
			
			elseif data.version == mod.global.release then
				if data.revision > mod.global.revision then
					me.numhigher = me.numhigher + 1
				
				elseif data.revision == mod.global.revision then
					me.numequal = me.numequal + 1
				end
			end
		end
		
		count = count + 1
	end		
	
	if mod.trace.check("info", me, "info") then
		mod.trace.printf("info check: higher = %s, equal = %s, total = %s.", me.numhigher, me.numequal, count)
	end
	
end

--[[
--------------------------------------------------------------------------------------
							NetIn Services
--------------------------------------------------------------------------------------
]]

me.mynetmessages = { "info", }

me.onnetmessage = function(author, command, data)
	
	if command == "info" then
		
		local locale, version, revision = string.match(data, "([a-zA-Z]+) (%d%d?) (%d+)")
		
		-- check valid syntax
		if revision == nil then
			return "invalid"
		end
		
		-- ignore players running a different locale
		if locale ~= mod.string.mylocale then
			return "locale"
		end
		
		-- cast
		version = tonumber(version)
		revision = tonumber(revision)
		
		-- ignore if we already have their version
		if me.players[author] == nil then
			me.players[author] = { }
		end
		
		me.players[author].isenabled = true
		me.players[author].version = version
		me.players[author].revision = revision
		me.players[author].lasttime = GetTime()
		
	end
	
end