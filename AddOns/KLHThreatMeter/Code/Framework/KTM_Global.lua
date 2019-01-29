
-- this isn't a module per se, just a list of constants that name the mod. We bundle them together so that the rest of the code has no explicit references to its own name, making it easy to copy the bits we like for other mods!

-- module setup
local me = { name = "global"}
local mod = thismod
mod[me.name] = me

	me.slash = 
	{
		short = "/ktm",
		medium = "/klhtm",
		long = "/klhthreatmeter",
	}
	
	me.addonname = "KLHThreatMeter"
	me.abbreviation = "KTM"
	me.addonmessageprefix = "KLHTM"
	me.printheader = "|cff88ffffKTM |r"

	-- this gives the name of the variable. Make sure it matches the "## SavedVariables: " line in the .toc.
	me.savedvariables = "klhtmsavedvariables"
	
	me.webpage = "http://www.curse.com/downloads/details/4204/"
	
	me.trace = 
	{
		info = false,		
		warning = false,
		error = true,
	}
	
	-- Mod Version
	me.release = 22
	me.revision = 1
	me.build = 264

	--[[
	Release	First Build
		1	  	  1
		2	 	  7
		3	 	 12
		4	 	 31
		5	 	 33
		6	 	 45
		7	 	 55
		8	 	 74
		9	 	 81
		10		 90
		11		104
		12		117
		13		125
		14		142
		15		157
		16		179
		17		193
		18		213
		19		226
		20		244
		21		249
		22		264
	]]


--[[
klhtm.emergencystop()
Stops all processing of events and onupdates. Just in case! This is unlocalised and raw to make sure it works even if there are errors elsewhere in the program.
]]
mod.emergencystop = function()
	
	mod.isenabled = false
	
	ChatFrame1:AddMessage("KLHThreatMeter emergency stop! |cffffff00/ktm|r e to resume.")
	
end

--[[ 
mod.print(message, [chatframeindex, noheader])

Prints out <message> to chat.
To print to ChatFrame3, set <chatframeindex> to 3, etc.
Adds a header identifying the mod to the message, unless <noheader> is non-nil.
]]
mod.print = function(message, noheader, chatframeindex)

	-- Get a Frame to write to
	local chatframe

	if chatframeindex == nil then
		chatframe = DEFAULT_CHAT_FRAME
		
	else
		chatframe = getglobal("ChatFrame" .. chatframeindex)
		
		if chatframe == nil then
			chatframe = DEFAULT_CHAT_FRAME
		end
	end

	-- touch up message
	message = message or "<nil>"
		
	if noheader == nil then
		message = me.printheader .. message 
	end
	
	-- write
	chatframe:AddMessage(message)

end

--[[
This is a protection wrapper on the string.format method, that will print out a rough version of the string if it is not formatted correctly.
]]
mod.format = function(message, ...)
	
	local success, result = pcall(string.format, message, ...)
	
	if success then
		return result
	end
	
	local result = "|cffff0000String.Format Failed! |rMessage = |cff00ffff" .. tostring(message) 
	
	for x = 1, select("#", ...) do
		result = result .. " |rarg" .. x .. " = " .. "|cff00ffff" .. tostring(select(x, ...))
	end
	
	return result
		
end

--[[
This is a synonym for mod.print(mod.format(message, ...)); recommended instead of mod.print(string.format(message, ...))
]]
mod.printf = function(message, ...)
	
	mod.print(mod.format(message, ...))
	
end