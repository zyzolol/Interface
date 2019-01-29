
-- module setup
local me = { name = "bossmod"}
local mod = thismod
mod[me.name] = me

--[[
KTM_BossMod.lua

Friendly bossmod manager. See KTM_BossModImplementation.lua for the actual bossmod data.

This module is divided into sections:

1) Member Variables - definitions of all our data tables, explaining their schemas.
2) Loader services - how we load boss mods.
3) Event Services - running boss mods in response to speech
4) Regex Services - running boss mods in response to spells.
5) Shared Functions - helper functions when boss mods run.
]]

-- This is full debug enabled. Comment out to stop

--[[
me.mytraces = 
{
	default = "info",
}
--]]


--[[
----------------------------------------------------------------------------------------------
								Member Variables
----------------------------------------------------------------------------------------------
]]

me.mods = { }	--[[
me.mods = { <mod_1>, <mod_2>, <mod_3> }

<mod_i> = 
{
	module = <string>,			-- name of the KTM module where the boss mod is written / stored
	bossid = <string>,			-- key of the boss mod in its storage table
	bossname = <string>, 		-- localised boss name. May be nil if the actual name isn't needed
	spells = 
	{
		<id> = {<spelldata>}
	},
	speech = 
	{
		<id> = {<speechdata>}
	}
}

<spelldata> = 
{
	localtext, bossmod, id [, source, reset, setmt, multiplier, customhandler, event, hitsonly]
}

<speechdata> = 
{
	localtext, bossmod, id [, source, reset, setmt, customhandler]
}
]]

me.speech = 
{
	named = { },
	anon = { },
} 
--[[
me.speech = 
{
	named = 
	{
		sourcename1 = 
		{
			<speechdata1>, <speechdata2>
		}
		sourcename2 = { ... }
	},
	anon = 
	{
		<speechdata3>, <speechdata4>, ...
	}
}
]]
me.spells = {}
me.debuffs = { }
--[[
me.spells = 
{
	spellname1 = 
	{
		sourcename1 = <spelldata>
	}
}
me.debuffs = 
{
	spellname1 = <spelldata>
	...
}]]

me.speechresult = 
{
	source = "",		-- mob / speaker
	rawtext = "",		-- arg2
	message = "",		-- format(arg2, arg1)
	handler = nil, 	-- a <speechdata> entry
	ishandled = false -- whether this event has been handled yet
}

me.spellresult = 
{
	source = "",		-- mob, or nil for debuff
	event = "",			-- "debuff", "buff", "buffend", "spell", "cast"
	spell = "",			-- name of the spell
	ismiss = false,	-- whether it was dodged / resisted etc
	target = "",		-- name of player targetted
	handler = nil,		-- a <spelldata> entry
	ishandled = false -- whether any mod has picked the event up yet
}

me.activedebuffs = { } --[[
me.activedebuffs = 
{
	buffname1 = multiplier1,
	...
} ]]

me.myinternalevents = 
{
	my = { "redoglobalthreat" }
}
		
me.oninternalevent = function(source, message, ...)
		
	if source == "my" and message == "redoglobalthreat" then
		
		local callback = select(1, ...)
		
		for buffname, multiplier in pairs(me.activedebuffs) do
			callback(multiplier - 1.0, buffname)
		end
		
	end
	
end

me.myonupdates = 
{
	updatedebuffs = 1,
}

--[[
This is O(m * n), m = # of debuffs, n = # of debuffs we are tracking
]]
me.updatedebuffs = function()
	
	local isactive, nextbuff
	
	for buffname, _ in pairs(me.activedebuffs) do
		
		isactive = false
		
		for x = 1, 40 do
			name = UnitDebuff("player", x)
			
			if name == buffname then
				isactive = true
				break
			
			elseif name == nil then
				break
			end
		end
		
		if isactive == false then
			me.activedebuffs[buffname] = nil
		end
	end
	
end

--[[
----------------------------------------------------------------------------------------------
								Loader Services
----------------------------------------------------------------------------------------------
]]

me.onload = function()
	
	me.resetrelay = mod.relay.createnew("shazzrahgate", me.resettrigger, 5.0, 1.5)
	
end

--[[
me.onmoduleload(module) is a special function called by Loader.lua when the addon starts.

It is called once for each module in the addon (sent as an argument).
We search for modules that are registering for parser events; they have a table <myparsers> and a function <onparse>. 
]]
me.onmoduleload = function(module)

	-- check for a <mybossmods> table
	if type(module.mybossmods) ~= "table" then
		return
	end

	-- number of boss mods before this module
	local startcount = #me.mods

	for bossid, data in pairs(module.mybossmods) do
		
		me.loadbossmod(module, bossid, data)
		
	end

	-- number of boss mods this module contributed
	local modsloaded = #me.mods - startcount

	-- debug
	if mod.trace.check("info", me, "onmoduleload") then
		mod.trace.printf("Loaded %s boss mods from the <%s> module.", modsloaded, module.name)
	end
	
end

--[[
me.loadbossmod(module, bossid, data)

Processes a boss mod definition. This involves a bit of sorting, a few error conditions, then passing the work off to <me.addspell> or <me.addspeech>.

<module>		pointer to a module
<bossid>		key in <module.mybossmods>
<data>		corresponding value in <module.mybossmods>
]]
me.loadbossmod = function(module, bossid, data)
	
	local result = 
	{
		module = module.name,
		bossid = bossid
	}
	
	-- determine boss name
	result.bossname = mod.string.tryget("boss", "name", bossid)
	
	-- if the boss name is nil, anonymous spells aren't allowed. Anonymous speech is OK.
	
	for key, value in pairs(data) do
		
		-- if the data is a string, number or boolean, copy it over. User metadata.
		if type(value) == "number" or type(value) == "boolean" or type(value) == "string" then
			result[key] = value
		
		-- if the type is weird, ignore and warn
		elseif type(value) ~= "table" then
			
			if mod.trace.check("warning", me, "loadbadtype") then
				mod.trace.printf("Ignoring the key %s in the definition of %s.%s because the data is type %s.", key, module.name, bossid, type(value))
			end
		
		-- normal case: type = "table", representing a spell or speech
		else
			
			-- identify the spell or speech from the key
			local spellname = mod.string.tryget("boss", "spell", key)
			
			if spellname then
				me.addspell(result, key, spellname, value)

			-- look for a speech instead
			else
				local text = mod.string.tryget("boss", "speech", key) 
				
				-- try using just <key> as a speech key
				if text then
					me.addspeech(result, key, text, value)
					
				-- finally try <bossid> + <key> as the speech key
				else
					text = mod.string.tryget("boss", "speech", bossid .. key)
					
					if text then
						me.addspeech(result, bossid .. key, text, value)
					
					-- nothing found for this key
					else
						
						-- ignore and warn
						if mod.trace.check("warning", me, "loadbadkey") then
							mod.trace.printf("Could not identify the key '%s' as a spell or speech in the definition of %s.%s.", key, module.name, bossid)
						end
					end
				end
			end
		end
	end
	
	-- check it for non-nil-ness. This could occur if all its properties had errors
	if result.spells == nil and result.speech == nil then
		
		-- warn and abort
		if mod.trace.check("warning", me, "loadfail") then
			mod.trace.printf("Could not load the mod %s.%s because all its speech and spells had errors.", module.name, bossid)
		end
		
		return
	end
	
	-- finally add the mod to our collection
	me.addverifiedbossmod(result)
		
end


--[[
me.addspell(bossmod, id, value, data)

Processes a spell definition from a boss mod.

<bossmod> 	table; the boss mod being created
<id>			string; spell id: a key in "boss"-"spell. It is unique for the bossmod.
<value>		string; localised spell name.
<data>		table; data describing the spell.
]]
me.addspell = function(bossmod, id, value, data)
	
	-- check that the spell has a known source.
	local result = { }
	
	if type(data.source) == "string" then
		
		local source = mod.string.tryget("boss", "name", data.source)
		
		if source == nil then
			
			-- warn and abort
			if mod.trace.check("warning", me, "badsourceid") then
				mod.trace.printf("Could not create the spell %s.%s.%s because its <source> property '%s' could not be identified.", bossmod.module, bossmod.bossid, id, data.source)
			end
			
			return
		
		else
			result.source = source
		end
	
	-- if the spell has no special source defined.
	elseif (bossmod.bossname == nil) then
		
		-- spell has no source and boss name is unknown too. 
		if data.event ~= "debuff" then
		
			-- error: no source for a non-debuff spell
			if mod.trace.check("warning", me, "nosource") then
				mod.trace.printf("Could not create the spell %s.%s.%s because the caster's name cannot be determined. This could be caused by a localisation error (the boss' name could not be determined from the id '%s'). Alternatively if the spell is a debuff, set its <event> property to 'debuff' to fix this.", bossmod.module, bossmod.bossid, id, bossmod.bossid)
			end
			
			return
		end
	
	-- no source given, but the boss' name is known, so use it.
	else
		result.source = bossmod.bossname
	end
	
	-- to get here, no problems with the source. Check the spell name is defined
	local spellname = mod.string.tryget("boss", "spell", id)
	
	if spellname == nil then
		
		-- no spell name found. warn and abort
		if mod.trace.check("warning", me, "badspellid") then
			mod.trace.printf("Could not create the spell %s.%s.%s because the its name could not be identified from the id '%s'.", bossmod.module, bossmod.bossid, id, id)
		end
	
		return
	end
	
	-- all clear. Copy over other data
	result.localtext = value
	result.event = data.event
	result.multiplier = data.multiplier
	result.hitsonly = data.hitsonly
	
	if data.reset then
		result.reset = true
	end
	if data.setmt then
		result.setmt = true
	end
	
	-- TODO: check type. String finally? Create and stuff too.
	result.customhandler = data.customhandler
	
	-- add reference to parent
	result.bossmod = bossmod
	result.id = id
	
	-- now finally add the thing
	if bossmod.spells == nil then
		bossmod.spells = { }
	end
	
	bossmod.spells[id] = result
	
end

--[[
me.addspeech(bossmod, id, value, data)

Processes a speech definition from a boss mod.

<bossmod> 	table; the boss mod being created
<id>			string; spell id: a key in "boss"-"spell. It is unique for the bossmod.
<value>		string; localised spell name.
<data>		table; data describing the spell.
]]
me.addspeech = function(bossmod, id, value, data)
	
	-- identify the source of the speech. If source=<id> is given, that is the source. Otherwise it is the boss. If the boss is not defined it is anonymous.
	local result = { }
	
	if type(data.source) == "string" then
		
		local source = mod.string.tryget("boss", "name", data.source)
		
		if source == nil then
			
			-- warn and abort
			if mod.trace.check("warning", me, "badsourceid") then
				mod.trace.printf("Could not create the speech %s.%s.%s because its <source> property '%s' could not be identified.", bossmod.module, bossmod.bossid, id, data.source)
			end
			
			return
		
		else
			result.source = source
		end
	
	else
		result.source = bossmod.bossname
	end
	
	-- copy over properties
	result.localtext = value
	
	if data.reset then
		result.reset = true
	end
	if data.setmt then
		result.setmt = true
	end
	
	-- TODO: check type. String finally? Create and stuff too.
	result.customhandler = data.customhandler
	
	-- add reference to parent
	result.bossmod = bossmod
	result.id = id
	
	-- now finally add the thing
	if bossmod.speech == nil then
		bossmod.speech = { }
	end
	
	bossmod.speech[id] = result
	
end

--[[
me.addverifiedbossmod = function(bossmod)
	
After it has been correctly parsed, need to actually add its events to handlers and such.

OK, what does this involve? For speech, we should sort them by speaker for quick identification. 
]]
me.addverifiedbossmod = function(bossmod)

	-- Add speech
	if bossmod.speech then
		for id, data in pairs(bossmod.speech) do
			
			if data.source then
				
				-- one-off creation
				if me.speech.named[data.source] == nil then
					me.speech.named[data.source] = { }
				end
			
				table.insert(me.speech.named[data.source], data)
			
			else
				table.insert(me.speech.anon, data)
			end
		end
	end
	
	-- Add spells
	if bossmod.spells then
		for id, data in pairs(bossmod.spells) do
			
			if data.source then
				
				-- one-off creation
				if me.spells[data.localtext] == nil then
					me.spells[data.localtext] = { }
				end
			
				-- check for overlap
				if me.spells[data.localtext][data.source] then
					-- warn and overwrite
					if mod.trace.check("warning", me, "duplicatespell") then
						
						local oldspell = me.spells[data.localtext][data.source]
						mod.trace.printf("The spell '%s' from '%s' is multiply defined. The definition %s.%s.%s will overwrite the previous version %s.%s.%s", data.localtext, data.source, data.bossmod.module, data.bossmod.bossid, id, oldspell.bossmod.module, oldspell.bossmod.bossid, oldspell.id)
					end
				end
					
				me.spells[data.localtext][data.source] = data
			
			else
				-- check for overlap
				if me.debuffs[data.localtext] then
					
					-- warn and overwrite
					if mod.trace.check("warning", me, "duplicatespell") then
						
						local oldspell = me.debuffs[data.localtext]
						mod.trace.printf("The debuff '%s' is multiply defined. The definition %s.%s.%s will overwrite the previous version %s.%s.%s.", data.localtext, data.bossmod.module, data.bossmod.bossid, id, oldspell.bossmod.module, oldspell.bossmod.bossid, oldspell.id)
					end
				end
				
				me.debuffs[data.localtext] = data
			end
			
		end
	end
	
	-- finally add this module to our list of modules
	table.insert(me.mods, bossmod)

end

--[[
------------------------------------------------------------------------------------------
                        Event Services
------------------------------------------------------------------------------------------
]]

me.myevents = { "CHAT_MSG_MONSTER_EMOTE", "CHAT_MSG_MONSTER_YELL", "CHAT_MSG_RAID_BOSS_EMOTE" }
-- "CHAT_MSG_MONSTER_EMOTE" : arg1 = message with %s, arg2 = boss name.
-- CHAT_MSG_MONSTER_YELL: arg1 = message, arg2 = boss name.
-- CHAT_MSG_RAID_BOSS_EMOTE: arg1 = message, arg2 = boss.

me.onevent = function()

	-- update me.speechresult
	me.speechresult.source = arg2
	me.speechresult.rawtext = arg1
	me.speechresult.message = string.format(arg1, arg2)
	me.speechresult.ishandled = false
		
	-- check named sources for a match
	for sourcename, speechset in pairs(me.speech.named) do
		
		-- does the mob name match the event?
		if sourcename == me.speechresult.source then
			
			-- search each speech for this source
			for index, speechdata in pairs(speechset) do
				
				me.checkforspeechmatch(speechdata)
			end
			
			-- since this source name matches, no other source name will. However we still permit anonymous mods to look.
			break
		end
	end

	-- check anonymous sources for a match
	for index, speechdata in pairs(me.speech.anon) do
		
		me.checkforspeechmatch(speechdata)
	end			

end

--[[
me.checkforspeechmatch(speechdata)

Checks whether the boss mod speech data <speechdata> is a match for <me.speechresult>, and activates it if it does.
]]
me.checkforspeechmatch = function(speechdata)
	
	-- does the speech data match the event?
	if string.find(me.speechresult.message, speechdata.localtext) then
		
		-- warn if it's already been matched
		if me.speechresult.ishandled then
			if mod.trace.check("warning", me, "multispeech") then
				mod.trace.printf("Multiple boss mods are handling the event { %s, %s, %s }. The last mod was %s.%s.%s; this one is %s.%s.%s", event, arg1, arg2, me.speechresult.bossmod.module, me.speechresult.bossmod.bossid, me.speechresult.id, speechdata.bossmod.module, speechdata.bossmod.bossid, speechdata.id)
			end
		end
		
		-- set as matched
		me.speechresult.ishandled = true
		me.speechresult.handler = speechdata
		
		-- run the bossmod
		me.runbossmodspeech()
	end
	
end

--[[
me.runbossmodspeech()

This is basically a continuation of <me.onevent> to stop it getting too big.
When the method runs, all the data we need has been put into the <me.speechresult> table.
]]
me.runbossmodspeech = function()
	
	local handler = me.speechresult.handler
	
	if mod.trace.check("info", me, "speechproc") then
		mod.trace.printf("Running the boss mod speech %s.%s.%s on the event { %s, %s, %s }.", handler.bossmod.module, handler.bossmod.bossid, handler.id, event, arg1, arg2)
	end
	
	-- check for MT set
	if handler.setmt then

		-- set target to boss name unless he's anon
		local mtname = handler.bossmod.bossname or me.speechresult.source

		if mod.trace.check("info", me, "mtset") then
			mod.trace.printf("Setting the master target to %s.", mtname)
		end
		
		mod.target.localsetmt(mtname)
	end
	
	-- check for threat reset
	if handler.reset then
		me.raidreset(handler)
	end
	
	-- check for custom handler
	if handler.customhandler then
		handler.customhandler(handler)
	end
	
end
	

--[[
------------------------------------------------------------------------------------------
                        Combat Events
------------------------------------------------------------------------------------------
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
	SPELL_MISSED = me.filters.fromme,
}

me.oncombatevent = function(...)
	
	local timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags, spellid = select(1, ...)
	
end

me.myparsers = 
{
	------------------------------------------------------------------------------------------------
	--			Section 1: Hits and Misses vs Self
	------------------------------------------------------------------------------------------------
	{"hit", "SPELLLOGABSORBOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"}, -- You absorb %s's %s.
	{"hit", "SPELLLOGOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"}, 		-- %s's %s hits you for %d.
	{"hit", "SPELLLOGCRITOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"},	-- %s's %s crits you for %d.
	{"hit", "SPELLLOGSCHOOLOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"}, -- %s's %s hits you for %d %s damage.
	{"hit", "SPELLLOGCRITSCHOOLOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"}, -- %s's %s crits you for %d %s damage.
	{"hit", "SPELLBLOCKEDOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"}, 	-- %s's %s was blocked."
	
	{"miss", "SPELLDODGEDOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"},	-- "%s's %s was dodged."
	{"miss", "SPELLPARRIEDOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"},	-- "%s's %s was parried."
	{"miss", "SPELLMISSOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"},		-- "%s's %s misses you."
	{"miss", "SPELLRESISTOTHERSELF", "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"}, -- "%s's %s was resisted."

	------------------------------------------------------------------------------------------------
	--			Section 2: Hits and Misses vs Raid
	------------------------------------------------------------------------------------------------
	{"missraid", "SPELLBLOCKEDOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- %s's %s was blocked by %s."
	{"missraid", "SPELLDODGEDOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- %s's %s was dodged by %s."
	{"missraid", "SPELLMISSOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- %s's %s misses %s."
	{"missraid", "SPELLPARRIEDOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- %s's %s was parried by %s."
	{"missraid", "SPELLRESISTOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- %s's %s was resisted by %s."
	
	{"hitraid", "SPELLLOGABSORBOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- %s's %s was absorbed by %s."
	{"hitraid", "SPELLLOGCRITOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- %s's %s crits %s for %s."
	{"hitraid", "SPELLLOGCRITSCHOOLOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- %s's %s crits %s for %d %s damage."
	{"hitraid", "SPELLLOGOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- "%s's %s hits %s for %d."
	{"hitraid", "SPELLLOGSCHOOLOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"}, -- %s's %s hits %s for %d %s damage.

	------------------------------------------------------------------------------------------------
	--			Section 3: Hits and Misses vs Party
	------------------------------------------------------------------------------------------------
	{"missraid", "SPELLBLOCKEDOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- %s's %s was blocked by %s."
	{"missraid", "SPELLDODGEDOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- %s's %s was dodged by %s."
	{"missraid", "SPELLMISSOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- %s's %s misses %s."
	{"missraid", "SPELLPARRIEDOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- %s's %s was parried by %s."
	{"missraid", "SPELLRESISTOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- %s's %s was resisted by %s."
	
	{"hitraid", "SPELLLOGABSORBOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- %s's %s was absorbed by %s."
	{"hitraid", "SPELLLOGCRITOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- %s's %s crits %s for %s."
	{"hitraid", "SPELLLOGCRITSCHOOLOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- %s's %s crits %s for %d %s damage."
	{"hitraid", "SPELLLOGOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- "%s's %s hits %s for %d."
	{"hitraid", "SPELLLOGSCHOOLOTHEROTHER", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"}, -- %s's %s hits %s for %d %s damage.
	
	------------------------------------------------------------------------------------------------
	--			Section 4: Misc
	------------------------------------------------------------------------------------------------
	{"debuffstart", "AURAADDEDSELFHARMFUL", "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"}, -- "You are afflicated by %s."
	{"debufftick", "AURAAPPLICATIONADDEDSELFHARMFUL", "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"}, -- "You are afflicted by %s (%d)."
	{"mobspellcast", "SPELLCASTGOOTHER", "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"},		-- "%s casts %s."
	{"mobbuffgain", "AURAADDEDOTHERHELPFUL", "CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS"}, 	-- "%s gains %s."
	{"mobbuffend", "AURAREMOVEDOTHER", "CHAT_MSG_SPELL_AURA_GONE_OTHER" }, -- %s fades from %s.
}

me.onparse = function(identifier, ...)

    -- 1) reset spell event
	me.spellresult.source = ""
	me.spellresult.target = ""
	me.spellresult.ishandled = false
	me.spellresult.ismiss = false
	
	-- Section 1 of MyParsers: hits and misses on self.
	if identifier == "hit" or identifier == "miss" then

		me.spellresult.source = select(1, ...)
		me.spellresult.spell = select(2, ...)
		me.spellresult.event = "spell"
		me.spellresult.target = UnitName("player")
		
		if identifier == "miss" then
			me.spellresult.ismiss = true
		end

	-- Section 2 of MyParsers: hits and misses on raid
	elseif identifier == "hitraid" or identifier == "missraid" then

		me.spellresult.source = select(1, ...)
		me.spellresult.spell = select(2, ...)
		me.spellresult.event = "spell"
		me.spellresult.target = select(3, ...)
		
		if identifier == "missraid" then
			me.spellresult.ismiss = true
		end
		
	elseif identifier == "debuffstart" or identifier == "debufftick" then
		me.spellresult.spell = select(1, ...)
		me.spellresult.event = "debuff"
		me.spellresult.target = UnitName("player")
		
	elseif identifier == "mobspellcast" then
		me.spellresult.event = "cast"
		me.spellresult.source = select(1, ...)
		me.spellresult.spell = select(2, ...)
		
	elseif identifier == "mobbuffgain" then
		me.spellresult.event = "buff"
		me.spellresult.source = select(1, ...)
		me.spellresult.spell = select(2, ...)
		
	elseif identifier == "mobbuffend" then
		me.spellresult.event = "buffend"
		me.spellresult.spell = select(2, ...)
		me.spellresult.source = select(1, ...)
	end
	
	-- 2) Now look for registered spells
	if me.spells[me.spellresult.spell] then
		
		for spellname, spelldata in pairs(me.spells[me.spellresult.spell]) do
			me.checkforspellmatch(spelldata)
		end
		
	end
	
	-- 3) also check for debuffs if applicable
	if me.spellresult.event == "debuff" and me.debuffs[me.spellresult.spell] then
		me.checkforspellmatch(me.debuffs[me.spellresult.spell])
	end
	
end

--[[
me.checkforspellmatch(spelldata)

To get here, the spell in the event matches the spell in the boss mod data <spelldata>.
We want to check for other matches like <event> and <source> properties

	<spelldata> is part of a boss mod that defines a spell
	<me.spellresult> 
]]
me.checkforspellmatch = function(spelldata)

	-- check for spell name match
	if spelldata.event and me.spellresult.event ~= spelldata.event then
		return
	end
	
	-- check for source name match (ignore name for debuff since it has no caster)
	if me.spellresult.event ~= "debuff" and spelldata.source ~= me.spellresult.source then
		return
	end
	
	-- check for it already having been handled
	if me.spellresult.ishandled then
		if mod.trace.check("warning", me, "multispell") then
			mod.trace.printf("Multiple boss mods are handling the event { %s, %s}. The last mod was %s.%s.%s; this one is %s.%s.%s", event, arg1, me.spellresult.bossmod.module, me.spellresult.bossmod.bossid, me.spellresult.id, spelldata.bossmod.module, spelldata.bossmod.bossid, spelldata.id)
		end
	end
	
	-- set as matched
	me.spellresult.ishandled = true
	me.spellresult.handler = spelldata
	
	-- run the bossmod
	me.runbossmodspell()
end

--[[
Called when a spell procs a boss mod.
]]
me.runbossmodspell = function()
	
	local handler = me.spellresult.handler
	
	-- debug
	if mod.trace.check("info", me, "spellproc") then
		mod.trace.printf("Running the boss mod spell %s.%s.%s on the event { %s, %s }.", handler.bossmod.module, handler.bossmod.bossid, handler.id, event, arg1)
	end
	
	-- check for threat reset
	if handler.reset then
		me.raidreset(spelldata)
	end
	
	-- check for debuff gain or something
	if me.spellresult.event == "debuff" then
		me.activedebuffs[handler.localtext] = handler.multiplier
		
		-- trace
		if mod.trace.check("info", me, "debuff") then
			mod.trace.printf("The debuff %s is active at %s multiplier from %s.%s.%s.", handler.localtext, handler.multiplier, handler.bossmod.module, handler.bossmod.bossid, handler.id)
		end
	end
	
	-- check for non-debuff multiplier
	if me.spellresult.target == UnitName("player") and me.spellresult.event == "spell" and handler.multiplier then
		
		-- check miss
		if me.spellresult.ismiss and handler.hitsonly then
			
			-- no effect
			if mod.trace.check("info", me, "hitsonly") then
				mod.trace.printf("The spell %s does not proc because it missed.", handler.localtext)
			end
			
		else
			-- multiply threat by multiplier
			local newthreat = handler.multiplier * mod.table.getraidthreat()
			local threatchange = newthreat - mod.table.getraidthreat()
			
			-- trace
			if mod.trace.check("info", me, "spellmulti") then
				mod.trace.printf("The spell %s procs at %s multiplier from %s.%s.%s.", handler.localtext, handler.multiplier, handler.bossmod.module, handler.bossmod.bossid, handler.id)
			end
			
			-- for now pipe it to combat cause i can't be bothered
			mod.combat.lognormalevent(handler.localtext, 1, 0, threatchange)
		end
	end
		
	-- check for custom handler
	if handler.customhandler then
		handler.customhandler(handler)
	end
	
end

--[[
------------------------------------------------------------------------------------------
                        Threat Wipe + Communication
------------------------------------------------------------------------------------------
]]

me.resettrigger = function()
	
	mod.mythreat.clearall()
	mod.pet.petthreat = 0
	
end

--[[
me.raidreset(handler)

Broadcasts a raid threat reset recommendation. Won't do anything if a similar command has been received recently.

This might be a spell handler OR a speech handler!
]]
me.raidreset = function(handler)
	
	if mod.trace.check("info", me, "resetrequest") then
		mod.trace.printf("requesting a threat wipe from %s.%s.%s.", handler.bossmod.module, handler.bossmod.bossid, handler.id)
	end
	
	me.resetrelay:fireevent()
		
end