
-- Add the module to the tree
local me = { name = "regex"}
local mod = thismod
mod[me.name] = me

--[[
Regex.lua

The regex module is the source of all the parsers for the mod. By identifying the format strings used to create the messages we want to parse, we can create a locale independent parser for them at runtime. The main task is converting the print format string to a regex string.

Now, each module will want to check different events for different messages. We want to prevent an overlap of resources - we don't want to parse the same string twice if two different modules want to parse it. Therefore each module defines the collection of strings they are interested in, e.g.

	me.myparsers = 
	{
		{"powergain", "POWERGAINSELFSELF", "CHAT_MSG_SPELL_SELF_BUFF"},
		{"healonself", "HEALEDCRITSELFSELF", "CHAT_MSG_SPELL_SELF_BUFF"},
		{"healonself", "HEALEDSELFSELF", "CHAT_MSG_SPELL_SELF_BUFF"},
	}
	
Each item in <me.myparsers> is off the form { <identifier>, <format string>, <event> }. Then define a callback function like this:

	me.onparse = function(identifier, ...)
		<stuff>
	end
	
The arguments after <identifier> to <me.onparse> will be the arguments to the original string.format command. e.g. "Mortal Strike", "Mottled Boar", 352 if the combat log line was "Your Mortal Strike hits Mottled Boar for 352."

------------------------------------------------------------------------------------------------------

Here's an example of the conversion from format string to parse string:

(English) "Your %s hits %s for %d." -> {"Your (.+) hits (.+) for (%d+)%.", {1, 2, 3}}
(French)  "Le %$3s de %$2s vous fait gagner %$1d points de vie." -> {"Le (.+) de (.+) vous fait gagner (%d+) points de vie%.", {3, 2, 1}}

First a bit of background. We want to be able to read the combat log on all clients, whether the language is english or french or chinese or otherwise. Furthermore, we don't want to rely on localisers working out the parser strings manually, because there is a likelihood of human error, and it would take too long to get a new string added.

Fortunately, we have all the information we need (at runtime, at least). For instance, in the example above, the value of the format string is given in the variable SPELLLOGSELFOTHER. If you open the GlobalStrings.lua (may need the WoW interface extractor to see it), on english clients you will see
...
SPELLLOGSELFOTHER = "Your %s hits %s for %d."
...
and on french clients you will see
...
SPELLLOGSELFOTHER = "Le %$3s de %$2s vous fait gagner %$1d points de vie."
...
When the WoW client is printing to the combat log, it will run a command like
ChatFrame2:AddMessage(string.format(SPELLLOGSELFOTHER, "Mortal Strike", "Mottled Boar", 352))

So, at Runtime (that is, when the addon loads, but not when i am writing it - i only have the english values) the mod has access to all the printing string format variables, like SPELLLOGSELFOTHER. We have a list of all the important ones, for all the abilities that the mod needs, so we want to make a big parser to scan them all at runtime. So the first thing we do when the addon loads is create all these parsers, then use them for all our combat log parsing.

------------------------------------------------------------------------------------------------------

Structures:

1) OneLineParser. Handles the parsing of a single Format String.

	local onelineparser = 
	{
		formatstring = 		"You hit %s for %s."
		regexstring = 			"You hit (.+) for (.+)%."
		numarguments = 		2
		ordering = 				{1, 2}
		types = 					{"string", "number"}
		globalstring = 		"COMBATSELFOTHER"
	}
	
	Note that the values of <argtypes> matches the canonical ordering (1, 2, 3, ...), not the localised ordering as in <ordering>.


2) EventParser. Handles the parsing of all Format Strings coming from one event.

	local eventparser = List(Of OneLineParser)
	
	i.e. eventparser = { <OneLineParser1>, <OneLineParser2>, <OneLineParser3>, ... }
	
	The ordering is such that the most specific OneLineParser has the smallest index.


3) GlobalParser:

	local globalparser = Table(Of <string EventName>, EventParser)
	
	i.e. globalparser = 
	{
		CHAT_MSG_SPELL_SELF_BUFF = <EventParser1>,
		CHAT_MSG_SPELL_SELF_DAMAGE = <EventParser2>,
	}
]]

me.globalparser = { }

-- me.parserregister[event][formatstring][module] = identifier
me.parserregister = { }


--[[
----------------------------------------------------------------------------------------------
			Startup: Handling Requests by Modules for Parsers
----------------------------------------------------------------------------------------------
]]

--[[
me.onmoduleload(module) is a special function called by Loader.lua when the addon starts.

It is called once for each module in the addon (sent as an argument).
We search for modules that are registering for parser events; they have a table <myparsers> and a function <onparse>. 
]]
me.onmoduleload = function(module)
	
	-- check for .myparsers / onparse mismatch
	if module.myparsers and not module.onparse then
		if mod.trace.check("warning", me, "events") then
			mod.trace.printf("The module |cffffff00%s|r has a |cffffff00.myparsers|r list but no |cffffff00.onparse|r function.", module.name)
		end
		
	elseif module.onparse and not module.myparsers then
		if mod.trace.check("warning", me, "events") then
			mod.trace.printf("The module |cffffff00%s|r has a |cffffff00.onparse|r function but no |cffffff00.myparsers|r list.", module.name)
		end
	
	-- normal modules: if they have both
	elseif module.myparsers then
		
		for _, data in pairs(module.myparsers) do
			me.registerparser(module.name, unpack(data))
		end
	end

end

--[[
me.registerparser(module, identifier, globalstring, event)

Called by Core.lua when a module requests a parser for the given globalstring and event. We add the identifier and module to the parser register, and augment the global parser if this globalstring is a new one.

<module>			string; name of the module,
<identifier>	string; description of the action in the formatstring, e.g. "myhealonother",
<globalstring>	string; name of a global string, e.g. "AURAGAINSELFOTHER",
<event>			string; an event, e.g. "CHAT_MSG_SPELL_SELF_BUFF".
]]
me.registerparser = function(module, identifier, globalstring, event)
	
	-- add the identifier to the parserregister
	if me.parserregister[event] == nil then
		me.parserregister[event] = { }
	end
	
	if me.parserregister[event][globalstring] == nil then
		me.parserregister[event][globalstring] = { }
	end
	
	me.parserregister[event][globalstring][module] = identifier
	
	-- has this event / globalstring combo already been made? If so we're done
	if me.globalparser[event] then
		
		for _, onelineparser in pairs(me.globalparser[event]) do
			if onelineparser.globalstring == globalstring then
				
				-- already made this parser
				return
			end
		end
	
	else
		-- make the EventParser table since it doesn't exist
		me.globalparser[event] = { }
		
		-- register for the event with Events.lua
		mod.event.lateaddevent(me, event)
	end
	
	-- now we have to create a OneLineParser for this combo
	local onelineparser = me.createonelineparser(globalstring)
	
	-- now add it the the eventparser
	me.insertonelineparser(me.globalparser[event], onelineparser)
	
end

--[[
----------------------------------------------------------------------------------------------
			RunTime: Parsing Events and Notifying Modules
----------------------------------------------------------------------------------------------
]]

me.myevents = { } -- populated by <me.registerparser> during the loadup process

me.lastmatch = { }
me.lastmatchordered = { }

me.onevent = function()
	
	-- get the EventParser for this event
	local eventparser = me.globalparser[event]
	
	local x, onelineparser, y
	
	-- look through all the OneLineParsers of this EventParser, in order
	for x, onelineparser in ipairs(eventparser) do
		
		if me.checkformatch(string.find(arg1, onelineparser.regexstring)) then
			
			-- we have a match!
			-- now reorder the arguments to 1,2,3 order
			for y = 1, onelineparser.numarguments do
				me.lastmatchordered[onelineparser.ordering[y]] = me.lastmatch[y]
			end
			
			-- offload to modules
			me.broadcastparse(event, onelineparser.globalstring, unpack(me.lastmatchordered, 1, onelineparser.numarguments))
						
			break
		end
	end
	
end

me.nextonparse = { }

--[[
me.broadcastparse(event, globalstring, ...)

Calls the <.onparse> handler of all interested modules. See <me.onevent> just above.

Reports an error to the error log if something goes wrong.
]]
me.broadcastparse = function(event, globalstring, ...)

	local success, message

	for module, identifier in pairs(me.parserregister[event][globalstring]) do

		success, message = mod.error.protectedcall(module, "onparse", mod[module].onparse, identifier, ...)
		
		if success == false then
			mod.error.reporterror(identifier .. " (" .. globalstring .. ")", ...)
		end
		
	end

end

--[[
me.checkformatch(string.find(arg1, onelineparser.regexstring))

Checks whether <arg1> matches the OneLineParser. If it does, then string.find will send an unknown number of arguments, two for the start and end, then <onelineparser.numarguments> for the matches. We put all the matchest into the <me.lastmatch> list.

Returns: boolean; whether it matched.
]]
me.checkformatch = function(...)
	
	if select(1, ...) == nil then
		return false
	end
			
	-- ignore the first two args, which specify the start and end positions of the match
	for x = 3, select("#", ...) do
		me.lastmatch[x - 2] = select(x, ...)
		me.lastmatchordered[x - 2] = select(x, ...) -- this is just to make sure he becomes an array. i think.
	end
	
	return true
end

--[[
----------------------------------------------------------------------------------------------
					Startup: Creating a OneLineParser
----------------------------------------------------------------------------------------------

All the jazz is done in the string.gsub command that uses <me.gsubreplacement> as the replacement function. Since <me.gsubreplacement> fills in some of the details of the OneLineParser structure, we have to make a reference to it outside the <me.createonelineparser> function. 
]]

me.lastonelineparser = nil -- set by <me.createonelineparser>, used by <me.gsubreplacement>

--[[
me.createonelineparser(globalstring)
	Returns a OneLineParser structure from a print formatting string.
	
<globalstring>		string; name of a GlobalString, e.g. "COMBATSELFOTHER"
]]
me.createonelineparser = function(globalstring)

	-- initial values for the OneLineParser
	me.lastonelineparser = 
	{
		globalstring = globalstring,
		formatstring = getglobal(globalstring),
		numarguments = 0,
		ordering = { },
		types = { },
	}

	--[[
	gsub replaces all occurences of the first string with the second string.
	[%.%(%)] means all occurences of . or ( or )
	%%%1 means replace these with a % and then itself.
	We're replacing them now so they don't interfere with the next bit.
	]]
	local regexstring = string.gsub(me.lastonelineparser.formatstring, "([%.%(%)])", "%%%1")
	
	-- string.gsub will search the string regexstring, identify captures of the form "(%%(%d?)$?([sd]))", then replace them with the value me.gsubreplacement(<captures>). See me.gsubreplacement comments for more details.
	regexstring = string.gsub(regexstring, "(%%(%d?)$?([sd]))", me.gsubreplacement)
	
	-- Adding a ^ character to the search string means that the string.find() is only allowed to match the test string starting at the first character.
	me.lastonelineparser.regexstring = "^" .. regexstring
	
	return me.lastonelineparser
	
end

--[[
The round brackets in the format string "(%%(%d?)$?([sd]))" denote captures. They will be sent to the 
replacement function as arguments. Their order is the order of the open brackets. So the first argument is the entire string, e.g. "%3$s" or "%s", the second argument is the index, if supplied, e.g. "3" or nil, and the third argument is "s" or "d", i.e. whether the print format is a string or an integer.
]]
me.gsubreplacement = function(totalstring, index, formattype)

	me.lastonelineparser.numarguments = me.lastonelineparser.numarguments + 1
	
	-- set the index for strings that don't supply them by default (when ordering is 1, 2, 3, ...)
	index = tonumber(index)
	
	if index == nil then
		index = me.lastonelineparser.numarguments
	end
	
	table.insert(me.lastonelineparser.ordering, index)

	-- the return value is the actual replacement
	if formattype == "d" then
		me.lastonelineparser.types[index] = "number"
		return "(%d+)"
	else
		me.lastonelineparser.types[index] = "string"
		return "(.+)"
	end
	
end

--[[
--------------------------------------------------------------------------------------
			Startup: Adding a OneLineParser to an EventParser Structure
--------------------------------------------------------------------------------------
]]

--[[
me.insertonelineparser(eventparser, onelineparser)

Inserts a OneLineParser struct into an EventParser Struct. We want the most specific OneLineParsers at the front of the EventParser list, so they don't get blocked by less general ones.
]]
me.insertonelineparser = function(eventparser, onelineparser)
	
	local length, x = table.getn(eventparser)
	
	if length == 0 then
		table.insert(eventparser, onelineparser)
	
	else
	
		for x = 1, length do
			-- keep going until you are smaller than one of them 
			
			if me.compareonelineparsers(eventparser[x], onelineparser) == 1 then
				
				-- our string is definitely higher
				table.insert(eventparser, x, onelineparser)
				break
				
			elseif x == length then
				-- add it after the end
				table.insert(eventparser, onelineparser)	
			end
		end	
	end
end

--[[
me.compareonelineparsers(parser1, parser2)

Given two regex strings, we want to know in which order to check them. e.g.
(1) "You gain (%d+) health from (.+)%." vs
(2) "You gain (%d+) (.+) from (.+)%."
In this case we should check for (1) first, then (2). To be more specific,
	1) If one pattern goes to a capture and another goes to text, do the text one first.
	2) If both of them go to different texts, put the guy with the most captures first. Otherwise, the longest guy.
	3) If both go to captures of different types, then don't worry.
	
return values:
-1: parser1 first
+1: parser2 first

Where possible, prefer to return -1.
]]
me.compareonelineparsers = function(parser1, parser2)

	local regex1, regex2 = parser1.regexstring, parser2.regexstring
	local start1, start2 = 1, 1
	local token1, token2
		
	while true do
	
		token1 = me.getnexttoken(regex1, start1)
		token2 = me.getnexttoken(regex2, start2)

		-- check for end of strings
		if token2 == nil then
			return -1
		elseif token1 == nil then
			return 1
		end
		
		-- check for equal (so far)
		if token1 == token2 then
			start1 = start1 + string.len(token1)
			start2 = start2 + string.len(token2)
		else
			break
		end
		
	end
	
	-- to get there, they have arrived at different tokens, therefore they must be orderable
		
	if string.len(token1) > 2 then
		-- regex1 is at a capture
			
		if string.len(token2) > 2 then
			-- regex2 is at a capture
	
			-- they are different, so one is a number, one a string, so who cares
			return -1
		
		else
		
			-- prefer the non-capture first
			return 1
		end
		
	else
		-- regex1 is not at a capture
		
		if string.len(token2) > 2 then
			-- regex2 at a capture
			return -1
			
		else
			
			-- both regex1 and regex2 are not at captures. So they match entirely up to here, but not at start1, which equals start2. 
			if string.find(string.sub(regex2, start2), string.sub(regex1, start1)) then
				return 1
				
			else
				return -1
			end
			
		end
	end
		
end

--[[
me.getnexttoken(regex, start)
Returns the next regex token in a string.
<regex> is the regex string, e.g. "hello (.+)%." .
<start> is the 1-based index of the string to start from.
Tokens are captures, e.g. "(.+)" or "(%d+)", or escaped characters, e.g. "%." or "%(", or normal letters, e.g. "a", ",".
]]
me.getnexttoken = function(regex, start)

	if start > string.len(regex) then
		return nil
	end
	
	local char = string.sub(regex, start, start)
	
	if char == "%" then
		return string.sub(regex, start, start + 1)
		
	elseif char == "(" then
		char = string.sub(regex, start + 1, start + 1)
		
		if char == "%" then
			return string.sub(regex, start, start + 4)
			
		else
			return string.sub(regex, start, start + 3)
		end
	
	else
		return char
	end

end

--[[
------------------------------------------------------------------------------
			Runtime: Protecting Parsers from Format String Changes
------------------------------------------------------------------------------

There are some unscrupulous mods that change the combat log format strings. Initially HEALEDSELFSELF is "Your %s heals you for %d." Now suppose some mod changes it to (for the sake of example) "You heal yourself for %d with %s." Our parsers will still think HEALEDSELFSELF has the original value. Therefore it will fail to parse all the heal messages, and it will generally be a disaster. 

This section keeps a list of all our parsers and all the format strings they use, like HEALEDSELFSELF. Then it checks for the format string being changed, and if so it will recreate all the parsers.
]]

me.myonupdates = 
{
	updateglobalparser = 1.0,
}

--[[
me.updateglobalparser()

This method is called by Core.lua at most every 1.0 seconds. It checks whether the format strings we use have been tampered, and if so rebuilds the global parser.
]]
me.updateglobalparser = function()
	
	-- Iterate over all OneLineParsers
	for event, eventparser in pairs(me.globalparser) do
		for x, onelineparser in pairs(eventparser) do
			if getglobal(onelineparser.globalstring) ~= onelineparser.formatstring then
				
				-- print warning
				if mod.trace.check("warning", me, "stringguard") then
					mod.trace.printf("The format string |cffffff00%s|r has been changed from '|cffffff00%s|r' to '|cffffff00%s|r'!", onelineparser.globalstring, onelineparser.formatstring, getglobal(onelineparser.globalstring))
				end
				
				-- rebuild
				me.rebuildglobalparser()
				return
			end
		end
	end
end

--[[
me.rebuildglobalparser()

Recreates the global parser when the format strings become invalidated.
]]
me.rebuildglobalparser = function()
	
	me.globalparser = { }
	
	local event, data
	
	for event, data in pairs(me.parserregister) do
		for formatstring, data2 in pairs(data) do
			for module, identifier in pairs(data2) do
				
				me.registerparser(module, identifier, formatstring, event)
				
				-- only need to do 1
				break
			end
		end
	end
					
end