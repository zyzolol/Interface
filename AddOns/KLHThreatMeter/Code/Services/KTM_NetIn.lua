
local me = { name = "netin"}
local mod = thismod
mod[me.name] = me

-- This is full debug enabled. Comment out to stop
me.mytraces = 
{
	default = "info",
}

--[[
Network.lua

18 Jun 07.

The Network module is being upgraded to cover sending and receiving, and in particular bulk messages. That is, messages that are too long to fit into one SendAddonMessage() call. Since it is largely separate from the original content, see the rest of the notes below at the start of the Bulk Mail section.


4 Feb 07.

The NetIn module mediates incoming network messages. Every addon message will start with one word (block of letters only, no spaces or punctuation) that describes what kind of message it is (the "command"). Then there is optionally one space, then arbitrary text (the "data").

Another module can register to be notified of a particular message by defining a <me.mynetmessages> list like so:

	me.mynetmessages = { "t", "clear", "bossevent" }
	
Then define a function <me.onnetmessage> like so:

	me.onnetmessage = function(author, command, data)
		...
	end

<author> will be the name of the person who send the message. <messagetype> will be one of the values in <me.mynetmessages>. <data> will be the rest of the string after the first space, possibly nil.

The <me.onnetmessage> function can optionally return a value describing any error that occured processing the message. A <nil> return value will be assumed to be a successful message. Recommended values for errors are "permission", if someone sends a message that requires them to be the raid leader or assistant but aren't, and "invalid", if a syntax error occurs, but you're welcome to return other or more detailed values. The NetIn module will keep track of the number of error messages and who they come from.

]]

--[[
Key = message type (string), value = list of strings, module names. e.g.

me.messageregister = 
{
	clear = { "combat", "boss", },		-- boss and combat modules register for "clear" messages
	bossevent = { "boss" },
}	
]]
me.messageregister = { }


--[[
me.onmoduleload() is a special Function called by Loader.lua when the addon starts up.

If the module has a <mynetmessages> table and an <onnetmessage> function, load them up.
]]
me.onmoduleload = function(module)
	
	-- check for .mynetmessages / onnetmessage mismatch
	if module.mynetmessages and not module.onnetmessage then
		if mod.trace.check("warning", me, "events") then
			mod.trace.printf("The module |cffffff00%s|r has a |cffffff00.mynetmessages|r list but no |cffffff00.onnetmessage|r function.", module.name)
		end
		
	elseif module.onnetmessage and not module.mynetmessages then
		if mod.trace.check("warning", me, "events") then
			mod.trace.printf("The module |cffffff00%s|r has a |cffffff00.onnetmessage|r function but no |cffffff00.mynetmessages|r list.", module.name)
		end
	
	-- normal modules: if they have both
	elseif module.onnetmessage then
		
		for _, messagetype in pairs(module.mynetmessages) do
			me.registermessagetype(module.name, messagetype)
		end
	end
	
end

--[[
mod.netin.registermessagetype(module, messagetype)

This is called by Core.lua in the last phase of loadup, after modules have loaded. This tells us all the net messages that each module wants to be told about.

<module>			string; name of the module, e.g. "combat",
<messagetype>	string; the message type, e.g. "bossevent".
]]
me.registermessagetype = function(module, messagetype)
	
	if me.messageregister[messagetype] == nil then
		me.messageregister[messagetype] = { }
	end
	
	table.insert(me.messageregister[messagetype], module)
	
end

-- Event service (see Events.lua)
me.myevents = {"CHAT_MSG_ADDON" }

-- Special onevent function from Events.lua
me.onevent = function()

	-- check the message comes from this addon, and comes from the party or raid
	if (arg1 ~= mod.global.addonmessageprefix) or ((arg3 ~= "PARTY") and (arg3 ~= "RAID")) then
		return 
	end
	
	-- ok
	me.messagein(arg4, arg2, 1)
		
end

--[[ 
me.messagein(author, message, startindex)

Processes a message from the addon message channel. This is usually called from <me.onevent>. However, when we are not in a party or raid, we can't send Addon Messages, therefore we pretend one has come in by calling this method directly.

<author> is the name of the player who sent the message.
<message> is the original string sent.
<startindex> is the 1-based string index where the message starts.
]] 
me.messagein = function(author, message, startindex)
		
	local command, data
	
	--[[
	get the command (first word) and the data (rest)
	
		"(%a+)"	one or more letters in a row
		" ?"		zero or 1 spaces
		"(.*)"	zero or more of any character
	]]
	_, _, command, data = string.find(message, "^(%w+) ?(.*)", startindex)
	
	-- check that the command is valid
	if (command == nil) or (me.messageregister[command] == nil) then
				
		-- log as unknown
		me.logmessage("unknowncommand", author, command, message)
		return
	end
	
	local module, result, output, success
	
	-- send the command to all the interested modules. <result> starts as <nil> indicating success. If the result value of one of the <onnetmessage> handlers is nil, result will become non-nil.
	for _, module in pairs(me.messageregister[command]) do
		
		success, output = mod.error.protectedcall(module, "onnetmessage", mod[module].onnetmessage, author, command, data)
		
		if success == false then
			mod.error.reporterror(command, data)
			
		else
			result = result or output
		end
		
	end
	
	-- log error / success
	me.logmessage(result, author, command, message)
		
end

--[[
me.logmessage(result, author, command, message)

Makes a note of the success or failure in parsing an incoming network message. 

<result>		string; what happened. <nil> for success, otherwise e.g. "unknowncommand", "syntax", etc,
<author>		string; name of the person who send the message,
<command>	string; addon command sent, possibly nil
<message>	string; the complete original message
]]
me.logmessage = function(result, author, command, message)

	-- Well... this kinda needs some work, hey!

	-- DEBUG
	if result then
		-- TODO: uncomment
		 --mod.printf("net error; result = %s, author = %s, message = %s.", result, author, message)
	end

end

--[[
-------------------------------------------------------------------------------------------------------
										Bulk Messages
-------------------------------------------------------------------------------------------------------

We would like to be able to send network messages of arbitrary length, however the wow API supports at most 255 characters including headers. Therefore we need a way to split long messages into several chunks and reassemble them upon receipt. To do this, we act like just another module registering for a command called "bulk". 

The format of a bulk command is "bulk <index> <length> <data>".
	<length> is the total number of packets required for the current bulk message
	<index> is the packet number. It will start at 1, and go up to <length> for the last message
	<data> is the next chunk of the data; as much as we can fit in.
	
Now, <data> itself will be just another network message. In this way as soon as we complete the bulk message we send it to the normal message handler and noone is the wiser.
]]

me.bulkdatatimeout = 2.0	-- we require bulk message packets to be sent at most this long apart otherwise we terminate the connection.

me.bulkinbox = { } --[[
me.bulkinbox = 
{
	[playername1] = <bulkdata1>,
	...
}

<bulkdata> = 
{
	length = 5,						-- total number of packets in this message
	lastindex = 2,					-- number of the last packet receivec
	timeout = GetTime() + me.bulkdatatimeout,	-- when the next packet should arrive before otherwise we stop listening
	data = "blah blah blah"		-- current message data accumulated
	isactive = true				-- whether this data is in use, or just recycled
}]]

me.mynetmessages = { "bulk" }		-- this registers us for the "bulk" command.

me.onnetmessage = function(author, command, data)

	-- first we need to split it down to parts. The pattern we want is "<index> <length> <data>" (see comments above).
	local index, total, content = string.match(data, "(%d+) (%d+) (.+)")

	-- convert to numbers
	index = tonumber(index)
	total = tonumber(total)

	-- check for match and valid numbers
	if index == nil or total == nil then
		return "invalid"
	end

	-- basic format is right here. get relevant dataset
	if me.bulkinbox[author] == nil then
		me.bulkinbox[author] = { }
	end

	local bulkdata = me.bulkinbox[author]

	-- either starting a new bulk or continuing an existing one
	if bulkdata.isactive then

		-- now check for mismatch with current bulk message
		if index ~= bulkdata.lastindex + 1 then

			if mod.trace.check("warning", me, "bulk") then
				mod.trace.printf("Bulk message from %s came out of order; expected % of %s packets but got %s. Length was %s, data was %s.", bulkdata.lastindex + 1, bulkdata.length, index, total, content)
			end

			return "syntax"
		end

		-- append
		bulkdata.lastindex = index
		bulkdata.data = bulkdata.data .. content
		bulkdata.timeout = GetTime() + me.bulkdatatimeout

		-- finish?
		if bulkdata.lastindex == bulkdata.length then
			
			if mod.trace.check("info", me, "bulk") then
				mod.trace.printf("completing a %s-piece bulk message from %s. Full message: %s", bulkdata.length, author, bulkdata.data)
			end

			bulkdata.isactive = false
			me.messagein(author, bulkdata.data, 1)

		end			

	else	-- This is the first packet in a bulk message
	
		-- check for proper start index (1)
		if index ~= 1 then
			
			if mod.trace.check("warning", me, "bulk") then
				mod.trace.printf("New Bulk message from %s started at index %s instead of 1, length was %s, data is %s.", index, length, content)
			end
	
			return "syntax"

		end

		-- start new
		bulkdata.isactive = true
		bulkdata.lastindex = 1
		bulkdata.length = total
		bulkdata.data = content
		bulkdata.timeout = GetTime() + me.bulkdatatimeout

	end

end

--[[
For bulk mail we require two polls.
	First we check the inbox for bulk messages where the author has stopped transmitting without completing. These need to be cleaned up to prevent a communication breakdown between the author.
	Secondly we check the outbox for queued message packets. We can't send them all at once or we'll probably get disconnected. We send them at a conservative rate to prevent problems with other addons.
]]

me.myonupdates =
{
	checkbulkinbox = 0.5,
	checkbulkoutbox = 0.5,
}

--[[
Polled method (0.5s). Check for incoming bulk messages that have timed out and kill them cleanly.
]]
me.checkbulkinbox = function()

	local timenow = GetTime()

	for user, bulkdata in pairs(me.bulkinbox) do
		if bulkdata.isactive and timenow > bulkdata.timeout then

			bulkdata.isactive = false
			
			if mod.trace.check("warning", me, "bulk") then
				mod.trace.printf("Bulk message from %s timed out after %s of %s packets. Data so far was: %s", user, bulkdata.lastindex, bulkdata.length, bulkdata.data)
			end

		end
	end

end

me.bulkoutbox = { } -- list of strings (FILO)

me.checkbulkoutbox = function()

	if #me.bulkoutbox > 0 then

		local lastmessage = me.bulkoutbox[#me.bulkoutbox]

		-- debug
		if mod.trace.check("info", me, "bulk") then
			mod.trace.printf("Sending this bulk message: %s.", lastmessage)
		end
		
		-- send
		mod.net.sendmessage(lastmessage)

		table.remove(me.bulkoutbox)
	end
		
end

--[[
This is a special method to send a bulk message. If it can fit in 1 message let it.

Note how we insert new messages to the front of the list, but take the item at the back of the list to send. This means the queue is FIFO - first in first out. This ensures that 2 bulk messages are sent in the order they are generated, and don't interfere with one another.
]]
me.sendbulkmessage = function(message)
	
	-- easy case: solo = no message
	if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then

		-- Send directly to our input handler
		mod.netin.messagein(UnitName("player"), message, 1)
		return
	end
	
	-- how much can we fit in one message. 255 - "PARTY" - prefix - 1 - "bulk xxx xxx " = 13
	local maxlength = 236 - string.len(mod.global.addonmessageprefix)
	
	if string.len(message) < maxlength then
		-- normal message
		mod.net.sendmessage(message)
	
	else
		
		local parts = math.ceil(string.len(message) / maxlength)
		
		for x = 1, parts do
			
			table.insert(me.bulkoutbox, 1,  string.format("bulk %s %s %s", x, parts, string.sub(message, (x - 1) * maxlength, x * maxlength - 1)))
		end
		
	end
	
end

