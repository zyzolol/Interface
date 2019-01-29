
local me = { name = "netthreat"}
local mod = thismod
mod[me.name] = me

--[[
NetThreat.lua

This module handles threat broadcasts: sending and receiving.
]]

me.activeguidbytes = 6	-- number of bytes we use in the guid.

me.deflateformat = ""

--[[
Called when the module loads. Populates the <me.deflatsformat> table.
]]
me.onload = function()
	
	for x = 1, me.activeguidbytes do
		me.deflateformat = me.deflateformat .. "%02X"
	end
	
end


--[[
------------------------------------------------------------------------------------------
							Public Interface
------------------------------------------------------------------------------------------
]]

me.gsubencode = 
{
	["\254"] = "\254\252",
	["\255"] = "\254\253",
}

me.gsubdecode = 
{
	["\254\252"] = "\254",
	["\254\253"] = "\255",
	["\255"] = "\000",
}

--[[
e.g.
/script klhtm.netthreat.test("0xF13000482C00A0F9", 1654)  -- < 00's hard
/script klhtm.netthreat.test("0xF13000482C1AFE9F", 100)  -- <-- 254/252 hard one
]]
me.test = function(guidstring, threatvalue)
	
	mod.printf("guid = %s, threat = %s.", guidstring, threatvalue)
	
	local buffer = { }
	
	me.encodeguid(buffer, guidstring)
	me.encodeint(buffer, threatvalue, 3)
	
	local initmessage = string.char(unpack(buffer))

	-- undo invalid values
	local message = initmessage:gsub(".", me.gsubencode)
	message = message:gsub("%z", "\255")
	
	-- debug input
	local input = "Init Message: "
	
	for x = 1, string.len(initmessage) do
		input = input .. string.byte(initmessage, x) .. ", "
	end
	
	mod.print(input)
	
	-- dec / enc message
	
	input = "Decode Encode Message: "
	
	--decode = string.gsub(message, ".", me.gsubdecode)
	
	-- new try:
	decode = string.gsub(message, "\255", "\000")
	decode = string.gsub(decode, "\254\252", "\254")
	decode = string.gsub(decode, "\254\253", "\255")	
	
	for x = 1, string.len(decode) do
		input = input .. string.byte(decode, x) .. ", "
	end
	
	mod.print(input)
	
end

me.stringtobytestring = function(message)
	
	local output = ""
	
	for x = 1, string.len(message) do
		output = output .. string.byte(message, x) .. ", "
	end
	
	return output
	
end

--[[
mod.netthreat.sendthreat(data, maxindex)

Broadcasts threat for the given mob-threat pairs.

	<data> 	= { <mobdata>, <mobdata>, ... }
	<mobdata>= 
	{ 
		mob = (string; reduced length GUID for target),
		threat = (number; threat value, possibly non-integral, possibly negative)	
	}
	
	<maxindex> = (integer; maximum index of the array <data> to use. Don't use data after <maxindex>! <maxindex> is guaranteed to be within the bounds of the array.
]]
me.sendthreat = function(data, maxindex)

	-- don't send empty messages
	if maxindex < 1 then
		return
	end

	local buffer = mod.garbage.gettable() -- { }
	local mobdata, threat
	
	for x = 1, maxindex do
		
		mobdata = data[x]
		
		me.encodeguid(buffer, mobdata.mob)
		
		-- sanitise threat value
		threat = math.floor(mobdata.threat)
		
		if threat < 0 then
			threat = 0
		elseif threat > 16777215 then	-- 0xFFFFFF
			threat = 16777215
		end
		
		me.encodeint(buffer, threat, 3)
		
	end

	local message = string.char(unpack(buffer))

	-- undo invalid values
	message = message:gsub(".", me.gsubencode)
	message = message:gsub("%z", "\255")
		
	-- SEND
	mod.net.sendmessage("t2 " .. message)
		
end

--[[
------------------------------------------------------------------------------------------
							Service Interface
------------------------------------------------------------------------------------------
]]

me.mynetmessages = { "t2" }

--[[
Called by <netin> module when we receive a "t2 ..." net message.

<author>		string; name of the player who sent the message
<command>	string; message type. In this case, always the value "t2".
<data>		string; rest of the message contents.
]]
me.onnetmessage = function(author, command, data)

	-- Reverse the encoding (which removes null characters)
	
	-- TODO: improve this. original line wasn't work
	--data = string.gsub(data, ".", me.gsubdecode)
	data = string.gsub(data, "\255", "\000")
	data = string.gsub(data, "\254\252", "\254")
	data = string.gsub(data, "\254\253", "\255")	
	
	
	-- figure out how many mob-threat pairs there are
	local count = string.len(data) / (me.activeguidbytes + 3)
	local mobguid, threat
	local startindex = 0
	
	-- decode one at a time
	for x = 1, count do
		
		mobguid, threat = me.decode(data, startindex)
		startindex = startindex + me.activeguidbytes + 3

		-- report to threat list
		mod.threatlist.setthreat(mobguid, author, threat)
	end
	
end

--[[
------------------------------------------------------------------------------------------
							Decoding
------------------------------------------------------------------------------------------
]]

--[[
mobguid, threat = me.decode(data, startindex)

<data>		string; encoding of GUID and Threat value
<mobguid>	string; guid string - maybe not full, depending
<threat>		number
]]
me.decode = function(data, startindex)
	
	local buffer = mod.garbage.gettable() -- { }
	
	-- convert string to bytes
	for x = 1, me.activeguidbytes + 3 do
		
		table.insert(buffer, string.byte(data, startindex + x))
	end
	
	-- get mobguid
	local mobguid = string.format(me.deflateformat, unpack(buffer, 1, me.activeguidbytes))
	
	-- get threat
	local byte1 = buffer[me.activeguidbytes + 1]
	local byte2 = buffer[me.activeguidbytes + 2]
	local byte3 = buffer[me.activeguidbytes + 3]
	
	-- byte1 is the high bite, then byte2, then byte3.
	local threat = bit.bor(bit.lshift(byte1, 16), bit.lshift(byte2, 8), byte3)

	return mobguid, threat
	
end

--[[
------------------------------------------------------------------------------------------
							Encoding
------------------------------------------------------------------------------------------
]]

--[[
TODO
]]
me.timetest = function()
	
	local guid = "0x38A4B739CDF35AC4"
	local buffer = { }
	local threat = 43289743
	
	local start = debugprofilestop()
	
	me.encodeguid(buffer, guid)
	me.encodeint(buffer, threat, 3)
	
	local message = string.char(unpack(buffer))

	-- undo invalid values
	message = message:gsub(".", me.gsubencode)
	message = message:gsub("%z", "\255")
	
	
	local finish = debugprofilestop()
	
	mod.printf("Took %s ms", finish - start)
	
end

--[[
<string> = me.encodeguid(guid)

giud = 8 bytes:
2 bytes = unused
3 bytes = mobtype
3 bytes = (random / counter)
]]
me.encodeguid = function(buffer, guid)
	
	-- get active bytes - last 12 hex chars
	local miniguid = string.sub(guid, -2 * me.activeguidbytes, - me.activeguidbytes -1)
	
	-- convert to 6 byes worth of int
	local guidnumber = tonumber(miniguid, 16)
	
	-- DEBUG (TODO: remove)
	if guidnumber == nil then
		mod.printf("Error converting miniguid '%s' from guid '%s' to a number!", tostring(miniguid), tostring(guid))
	end
	
	me.encodeint(buffer, guidnumber, me.activeguidbytes / 2)
	
	-- next few bytes:
	miniguid = string.sub(guid, -me.activeguidbytes, -1)
	guidnumber = tonumber(miniguid, 16)
	
	me.encodeint(buffer, guidnumber, me.activeguidbytes / 2)
	
end

--[[
me.encodeint(buffer, value, numbytes)

Encodes the low <numbytes> bytes of the integer <value> into the byte array <buffer>.
]]
me.encodeint = function(buffer, value, numbytes)
	
	local mask, word, byte
	
	for x = numbytes, 1, -1 do
		
		mask = bit.lshift(255, (x - 1) * 8)		
		word = bit.band(mask, value)
		byte = bit.rshift(word, (x - 1) * 8)
				
		table.insert(buffer, byte)
	end
	
end


	