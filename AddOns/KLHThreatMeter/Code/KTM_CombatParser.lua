
local me = { name = "combatparser"}
local mod = thismod
mod[me.name] = me

--[[
CombatParser.lua

This module is the bridge between Regex.lua and Combat.lua. Given a combat log event, it feeds it to the parser.
If successful, the parser will return a set of arguments, and an identifier that describes the combat log line, such as "whiteattackhit".

CombatParser then works out what to do with the arguments. That is, it massages them into a format for Combat.lua's methods.

]]

me.myevents = { "COMBAT_LOG_EVENT_UNFILTERED" }

-- shared for onevent handling functions
local timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags

me.onevent = function()
	
	timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags = arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8
	
	-- only get events from self when not mind controled
	if bit.band(sourceflags, COMBATLOG_FILTER_ME) ~= COMBATLOG_FILTER_ME then
		return
	end
	
	-- look for a handler
	local handler = me.eventhandlers[eventname]
	
	if handler == nil then
		return
	end
	
	-- run handler to proceed
	handler(arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19)
	
end

me.flagisfriend = function(flag)
	
	return bit.band(flag, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER
		or  bit.band(flag, COMBATLOG_OBJECT_REACTION_FRIENDLY) == COMBATLOG_OBJECT_REACTION_FRIENDLY
	
end

--[[
Each key is a possible value of the <event> arg from COMBAT_LOG_EVENT_UNFILTERED. 
]]
me.eventhandlers = 
{
	SWING_DAMAGE = function(amount, school, resisted, blocked, absorbed, critical)
		
		-- target must be non-friendly and NPC controlled
		if me.flagisfriend(destflags) then return end
				
		mod.combat.specialattack("whitedamage", destguid, amount, critical, school, false)	
					
	end,
	
	RANGE_DAMAGE = function(spellid, spellname, spellschool, amount, school, resisted, blocked, absorbed, critical)
		
		-- target must be non-friendly and NPC controlled
		if me.flagisfriend(destflags) then return end
		
		-- try for spellid
		local ktmspellid = mod.string.unlocalise("spell", spellname)
		
		if ktmspellid then
			mod.combat.specialattack(ktmspellid, destguid, amount, critical, school, false)
		else
			mod.combat.normalattack(spellname, nil, amount, false, destguid, critical, school)
		end
		
	end,
	
	-- direct copy of RANGE_DAMAGE
	SPELL_DAMAGE = function(spellid, spellname, spellschool, amount, school, resisted, blocked, absorbed, critical)
		
		-- target must be non-friendly and NPC controlled
		if me.flagisfriend(destflags) then return end
		
		-- try for spellid
		local ktmspellid = mod.string.unlocalise("spell", spellname)
				
		if ktmspellid and mod.data.spells[ktmspellid] then
			mod.combat.specialattack(ktmspellid, destguid, amount, critical, school, false)
		else
			mod.combat.normalattack(spellname, ktmspellid, amount, false, destguid, critical, school)
		end
		
	end,
	
	SPELL_HEAL = function(spellid, spellname, spellschool, amount, critical)
		 
		-- target must be friendly to gain threat
		if not me.flagisfriend(destflags) then return end
		
		-- try for spellid
		local ktmspellid = mod.string.unlocalise("spell", spellname)
		
		mod.combat.possibleoverheal(ktmspellid, amount, destname)
	end,
	
	SPELL_ENERGIZE = function(spellid, spellname, spellschool, amount, powertype)
		
		-- try for spellid
		local ktmspellid = mod.string.unlocalise("spell", spellname)
		
		mod.combat.powergain(amount, powertype, ktmspellid)
	end,
	
	-- same as spell damage but dot = true
	SPELL_PERIODIC_DAMAGE = function(spellid, spellname, spellschool, amount, school, resisted, blocked, absorbed, critical)
		
		-- target must be non-friendly and NPC controlled
		if me.flagisfriend(destflags) then return end
		
		-- try for spellid
		local ktmspellid = mod.string.unlocalise("spell", spellname)
		
		if ktmspellid and mod.data.spells[ktmspellid] then
			mod.combat.specialattack(ktmspellid, destguid, amount, critical, school, true)
		else
			mod.combat.normalattack(spellname, ktmspellid, amount, true, destguid, critical, school)
		end
		
	end,
	
	-- same as heal
	SPELL_PERIODIC_HEAL = function(spellid, spellname, spellschool, amount, critical)
		 
		-- target must be friendly to gain threat
		if not me.flagisfriend(destflags) then return end
		
		-- try for spellid
		local ktmspellid = mod.string.unlocalise("spell", spellname)
		
		mod.combat.possibleoverheal(ktmspellid, amount, destname)
	end,
	
	-- same as spell energise
	SPELL_PERIODIC_ENERGIZE = function(spellid, spellname, spellschool, amount, powertype)
		
		-- try for spellid
		local ktmspellid = mod.string.unlocalise("spell", spellname)
		
		mod.combat.powergain(amount, powertype, ktmspellid, destname)
	end,
	
	SPELL_PERIODIC_DRAIN = function(spellid, spellname, spellschool, amount, powertype, extraamount)
		-- leave it for now. this appears to be power drain.
	end,
	
	-- copy of spell damage
	DAMAGE_SHIELD = function(spellid, spellname, spellschool, amount, school, resisted, blocked, absorbed, critical)
		
		-- target must be non-friendly and NPC controlled
		if me.flagisfriend(destflags) then return end
		
		-- try for spellid
		local ktmspellid = mod.string.unlocalise("spell", spellname)
		
		if ktmspellid and mod.data.spells[ktmspellid] then
			mod.combat.specialattack(ktmspellid, destguid, amount, critical, school, false)
		else
			mod.combat.normalattack(spellname, ktmspellid, amount, false, destguid, critical, school)
		end
		
	end,
	
	-- old style "You cast %s[ on %s]."
	SPELL_CAST_SUCCESS = function(spellid, spellname, spellschool)
		
		-- this is for feint, taunt/growl/righteous defense, soul shatter, but don't do shield slam
		local ktmspellid = mod.string.unlocalise("spell", spellname)
		
		-- todo: revise this code. Now taunt is separate, ktmspellid may not be needed.
		
		-- ignore shield slam "proc" - damage comes in SPELL_DAMAGE
		if spellid == 26889 or spellid == 1857 or spellid == 1856 then
			mod.mythreat.clearall()
		
		elseif ktmspellid == "soulshatter" or spellid == 32835 or spellid == 29858 then
			
			if destname then
				mod.mythreat.multiplytarget(destguid, 0.5)
			end
		
		elseif mod.data.spells[ktmspellid] and mod.data.spells[ktmspellid].castonly then
			mod.combat.specialattack(ktmspellid, destguid, 0, false, 0, false)
		end
		
	end,
	
	SPELL_MISSED = function(spellid, spellname, spellschool)
		
		local ktmspellid = mod.string.unlocalise("spell", spellname)
		
		if mod.data.spells[ktmspellid] and mod.data.spells[ktmspellid].castonly then
			mod.combat.specialattack(ktmspellid, destguid, 0, false, 0, false, true)	-- end arg = true for retraction
		end
		
	end,
	
}



