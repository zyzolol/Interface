
-- module setup
local me = { name = "special"}
local mod = thismod
mod[me.name] = me

--[[
2008/02/17: it's all gone to hell.

SpecialAbility.lua (2007 / 04 / 29)

This module detects abilities that don't cause damage but still cause significant threat. Since they don't cause damage, they often aren't detectable from combat log events alone. Examples are Sunder Armor, Faerie Fire, Counterspell, + random debuff applications like warlock curses. The types of abilities can be divided into physical ones, which can be parried, dodged, etc, and spells, which can be resisted.


--------------------------------------------------------
		World of Warcraft Implementation
--------------------------------------------------------

When we attempt to cast a spell, a UNIT_SPELLCAST_SENT event is raised; the spell name is arg2 and the  name of the target is arg4. When the spell actually fires (no out of range or similar errors), a UNIT_SPELLCAST_SUCCEEDED event is raised; the spell name is arg2.

When an ability is parried, dodged, misses, or the target is immune, we receive a CHAT_MSG_SPELL_SELF_DAMAGE event with format strings SPELLPARRIEDSELFOTHER, SPELLDODGEDSELFOTHER, SPELLMISSEDSELFOTHER, and IMMUNESPELLSELFOTHER respectively. For spells, there is also SPELLRESISTSELFOTHER and SPELLIMMUNESELFOTHER, for resists and the mob being immune to a mechanic (e.g. silence immune boss).


---------------------------------------------------------
		KTM Implementation
---------------------------------------------------------

We keep a list of all the spells and abilities tracked in this module in <me.spells>. The list <me.namelookup> converts a localised name such as "Sunder Armor" to its index in <me.spells>, 1 in this case.

When we receive UNIT_SPELLCAST_SENT event matching the spell we record the target in <me.spells[i].target>. When we receive a UNIT_SPELLCAST_SUCCESSFUL event matching the spell we generate a standard attack in the <combat> module. If we detect a miss / parry / etc, we generate an attack in the <combat> module with -1 hits to deduct the threat.

Currently we are working out the threat of the ability ourselves, because Combat.lua doesn't have a good mechanism to subtract threat, which we need to do. We run the risk of not taking into account special class or set threat bonuses, but for the current abilities there are no problems.


--------------------------------------------------------
		Interaction With Other Modules
--------------------------------------------------------

- We use the method <mod.combat.lognormalevent> to add or subtract threat from our abilities. 
- For each ability in <me.spells>, there must be a key in <mod.data.spells> matching the <id> value.

- The module requires these localisation keys to work perfectly (english examples)
"spell" - "sunder"		=	"Sunder Armor"
"spell" - "faeriefire"	=	"Faerie Fire (Feral)"


--------------------------------------------------------
				Debugging
--------------------------------------------------------

To enable all debugging of this module, uncomment these lines:

	me.mytraces = 
	{
		default = "info",
	}

The following trace prints exist:

"send"	-	UNIT_SPELLCAST_SENT
"fail"	-	parry / dodge / resist etc
"cast"	-	UNIT_SPELLCAST_SUCCEEDED
"threat"	-	change in threat

For example, to show only "send" traces, uncomment these lines:

	me.mytraces = 
	{
		send = "info",
	}
]]

--[[
------------------------------------------------------------------------
					Member Variables
------------------------------------------------------------------------
]]

--[[
At runtime, each subtable becomes e.g.
{
	id = "sunder", 			-- localisation key
	type = "physical",		-- either "physical" or "spell"
	name = "Sunder Armor"	-- localised name
	mobguid = "0xf13..."		-- name of the last targetted mob, that's GUID
	timesent = (timestamp)
}
]]
me.spells = 
{
	
	--{
	--	id = "sunder",
	--	type = "physical",
	--}, 
	--{
	--	id = "faeriefire",
	--	type = "spell",
	--},
}

me.namelookup = { } --[[ Here's an example using the enUS localisation. The key is the localised string. The value is the index in <me.spell> that refers to the same spell.

me.namelookup = 
{
	["Sunder Armor"] = 1,
	["Faerie Fire"] = 2,
}
]]

--[[
-----------------------------------------------------------------------------
					Services from Loader.lua
-----------------------------------------------------------------------------
]]

--[[
When the module loads, we check that all the defined spells have a localisation string. If there is no value for the current locale, that spell won't be loaded or checked for.
]]
me.onload = function()
	
	local spellname
	
	-- check for localisation values
	for index, value in ipairs(me.spells) do
		spellname = mod.string.tryget("spell", value.id)
		
		if spellname then
			me.namelookup[spellname] = index
			
			value.name = spellname
			value.target = ""
		end
	end
	
end

--[[
---------------------------------------------------------------------------
					Services from Regex.lua
---------------------------------------------------------------------------
]]

me.oncombatlogevent = function()
	
	timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags = arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, spellid, spellname

	-- event = spell misses
	if eventname ~= "SPELL_MISSED" then
		return
	end
	
	-- source = me
	flagsneeded = bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_AFFILIATION_MINE)
	
	if (bit.band(sourceflags, flagsneeded) ~= flagsneeded) then
		return
	end
	
	-- Check for the spell being in our database
	local spellindex = me.namelookup[spellname]
	
	if spellindex == nil then
		return
	end
	
	-- debug
	if mod.trace.check("info", me, "fail") then
		mod.trace.printf("%s failed on %s, result was %s.", spell, target, identifier)
	end
	
	-- only retract if we successfully got a guid
	local spelldata = me.spells[spellindex]
	
	if spelldata.timesent == nil or GetTime() > spelldata.timesent + 1.5 then
		return
	end
	
	-- retract
	me.addspellthreat(spellindex, -1)
	
end

--[[
-----------------------------------------------------------------------------
				Services from Events.lua
-----------------------------------------------------------------------------
]]

me.myevents = { "UNIT_SPELLCAST_SUCCEEDED", "UNIT_SPELLCAST_SENT", "COMBAT_LOG_EVENT_UNFILTERED" }

me.onevent = function()

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		me.oncombatlogevent()
		return
	end

	-- check for spell match (arg2 for both events)
	local spellindex = me.namelookup[arg2]
	
	if spellindex == nil then
		return
	end

	local spelldata = me.spells[spellindex]

	if event == "UNIT_SPELLCAST_SENT" then
		
		local mobguid = mod.moblist.findguidforspelltarget(arg4)
		
		if mobguid == nil then
			-- debug
			mod.printf("Couldn't find a GUID for spell target %s.", arg4)
			return
		end
				
		spelldata.mobguid = mobguid
		spelldata.target = arg4
		spelldata.timesent = GetTime()
		
		-- debug
		if mod.trace.check("info", me, "send") then
			mod.trace.printf("sending %s against %s.", arg2, arg4)
		end
	
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		
		-- debug
		if mod.trace.check("info", me, "cast") then
			mod.trace.printf("%s has successfully cast.", spelldata.name)
		end
		
		-- submit, but only if we could find the guid
		if spelldata.timesent == nil or GetTime() > spelldata.timesent + 1.0 then
			return
		end
		
		me.addspellthreat(spellindex, 1)
	end

end	

----------------------------------------------------------------

--[[
me.addspellthreat(spellindex, count)

Calculates the threat from an attack, and adds it to our threat.

<spellindex>	integer; index of <me.spells> matching the spell used.
<count>			integer; 1 for a cast, -1 for a retraction.
]]
me.addspellthreat = function(spellindex, count)
	
	local spelldata = me.spells[spellindex]
	
	-- 2) total threat
	local threat = mod.my.ability(spelldata.id, "threat") * mod.my.globalthreat.value * count
	
	if mod.trace.check("info", me, "threat") then
		mod.trace.printf("Adding %d threat from %s.", threat, spelldata.name)
	end
	
	-- 3) submit
	mod.combat.reportattack(spelldata.mobguid, threat)
	
end