
-- module setup
local me = { name = "bmspeech"}
local mod = thismod
mod[me.name] = me

--[[
This module handles a set of speech elements. Each element has:

	1) Message. The string to search for, in either yell or emote or say or whatever. This is localised.
	2) The source of the message. In some cases this is not specified. Other times there is a localisation for it.
	3) A locator of the boss mod element containing the above information.
	
One problem is how to process all the entries for which the source hasn't been specified. The reason this would occur is that it requires an additional entry in the localisation file, which isn't rellly necessary. A quote like "I have not come this far to be stopped!", being realistic, won't occur from more than one boss. The problem is that for every message we receive, we might have 50 search strings with unknown source that we will have to check it against.

The fact is, there just aren't that many yells or emotes coming compared to normal events. In a raiding environment, we can expect at least 500 events for every monster message generated, so our search list pales in comparison. Furthermore, there are only 13 speech events for TBC boss mods, so it will be at least a couple more expansions before we run into trouble.

Timetrial scanning a test string vs 50 search strings took on average 0.05ms. That's an average rate of 0.01ms per second, or 0.001% processor usage. No sweat.
]]

-- Here is our main data set.
me.data = { } --[[
{
	<search string> = 
	{
		module = (name of the declaring module),
		bossmod = (bossmod ID in <module>)
		name = (identifier of this speech element in <bossmod>)
	},
	...
} ]]

--[[
-- debugs enabled
me.mytraces = 
{
	default = "info"
}
]]

-------------------------------------------------------------------------------
--				Loading Boss Mod Speech Data
-------------------------------------------------------------------------------

--[[
mod.bmspeech.loadspeechdata(modulename, bossmodname, speechset)

Called by BossMod.lua to pass off a speech element to us.

<modulename>	string; name of the declaring module.
<bossmodname>	string; id of the bossmod
<speechset>		table of string-x pairs; we only care about the keys really.
]]
me.loadspeechdata = function(modulename, bossmodname, speechset)
	
	for speechkey, speechdata in pairs(speechset) do
		
		me.loadspeechitem(modulename, bossmodname, speechkey, speechdata) 
	
	end
	
end

--[[
me.loadspeechitem(modulename, bossmodname, speechkey, speechdata)

Loads an individual speech entry. We split them up in this way so that one failure doesn't cause all speech entries to fail.
]]
me.loadspeechitem = function(modulename, bossmodname, speechkey, speechdata)
	
	-- 1) need message to exist
	local message = mod.string.tryget("boss", "speech", bossmodname .. speechkey)
	
	if message == nil then
		
		-- warn and exit
		if mod.trace.check("warning", me, "nolocal") then
			mod.trace.printf("Can't use the bossmod item '%s.%s.speech.%s' because there is no localised string for the message '%s'.", modulename, bossmodname, speechkey, bossmodname .. speechkey)
		end
			
		return
	end
	
	-- 2) check for existing boss mod on the message
	local existing = me.data[message]
	
	if existing then
		
		-- warn and exit
		if mod.trace.check("warning", me, "duplicatespeech") then
			mod.trace.printf("Can't use the bossmod item '%s.%s.speech.%s' because the message '%s' from the boss '%s' is already handled by the bossmod item '%s.%s.speech.%s'.", modulename, bossmodname, speechkey, message, source, existing.module, existing.bossmod, existing.name)
		end
		
		return
	end
	
	-- 3) add a new item to our data set
	me.data[message] = 
	{
		module = modulename,
		bossmod = bossmodname,
		name = speechkey,
	}
	
end

-------------------------------------------------------------------------------
--				Processing Speech Events
-------------------------------------------------------------------------------

me.myevents = { "CHAT_MSG_MONSTER_EMOTE", "CHAT_MSG_MONSTER_YELL", "CHAT_MSG_RAID_BOSS_EMOTE" }
--[[
		Event									arg1						arg2
"CHAT_MSG_MONSTER_EMOTE"		message with %s			boss name
"CHAT_MSG_MONSTER_YELL"				message					boss name
"CHAT_MSG_RAID_BOSS_EMOTE"			message					boss name
]]

--[[
Entry point from Events service. As shown above, arg1 is message, arg2 is boss name.
]]
me.onevent = function(eventname, message, bossname)
	
	local multiplehits = false
	
	-- 1) Look for a match for <message>
	for searchstring, locator in pairs(me.data) do
		
		if string.find(message, searchstring) then
			
			-- 2) got a match. warn if there are multiple handlers
			if multiplehits then
				
				if mod.trace.check("warning", me, "multiple") then
					mod.trace.printf("Multiple boss mod speech events are triggering from '%s'.", message)
				end
				
			else
				multiplehits = true	-- next handler will be multiple, if there is one
			end
			
			-- 3) trigger the event in the boss mod
			me.executespeech(locator)
		end
	end
			
end

--[[
me.executespeech(locator)

Called when a speech event is identified and the boss mod event is to be executed.
<locator> is one of the values in <me.data>; a table which identifies the boss mod and speech entry.
]]
me.executespeech = function(locator)

	-- debug notice
	if mod.trace.check("info", me, "execute") then
		mod.trace.printf("Executing the speech event '%s.%s.speech.%s'.", locator.module, locator.bossmod, locator.name)
	end
	
	mod.bossmod.resetmobidunknowninstance(locator.module, locator.bossmod)

end