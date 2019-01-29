
local me = { name = "invisibility"}
local mod = thismod
mod[me.name] = me

--[[
Invisibility.lua

Handles the mage spell Invisibility. 

----------------------------------------------------
		World of Warcraft Implementation
----------------------------------------------------

Invisibility is an instant cast spell. When it is cast, you gain a buff called "Invisibility", BUT there is no entry in the combat log to signal this. You aren't yet invisible, only "fading...".

For 5 seconds the buff ticks down, and you lose 10% of your current threat each second. If you do or receive a hostile action, the buff fades (again no combat log entry) and you won't become invisible.

If the buff ticks down all they way, you do become invisible, and you gain a different buff, also called "Invisibility". This buff is reported in the combat log under "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS".


----------------------------------------------------
			KTM Implementation
----------------------------------------------------

We detect the spellcast from the UNIT_SPELLCAST_SUCCESSFUL event. Then <me.isactive> is true, and you lose <me.levelpertick> of your threat ever <me.tickinterval> seconds, to a maximum of <me.maxticks> ticks.

While ticking is ative, periodically we check whether the "Invisibility" buff has faded; if so <me.isactive> is set to false and the ticking stops.

If we detect the buff gain "Invisibility" from the combat log, we wipe threat, regardless of the value of <me.isactive>

----------------------------------------------------
			Interaction with other modules
----------------------------------------------------

The <invisibility> module uses services from the <regex> module and the <event> module. To change your threat it calls <mod.combat.lognormalevent> and <mod.table.resetraidthreat>

This module requires the localisation key ("spell", "invisibility") to be current.
]]

--[[
------------------------------------------------------------------------
				Member Variables
------------------------------------------------------------------------
]]

me.isactive = false		-- whether invisibility is currently ticking
me.casttime = 0			-- when SPELLCAST_SUCCESSFUL triggered
me.ticks = 0				-- number of ticks elapsed
	
-- these are constants
me.maxticks = 5			-- ticks until complete invisibility
me.levelpertick = 0.1 	-- fraction of threat reduced
me.tickinterval = 1.0	-- seconds between ticks

-- spell ids
me.fadingspellid = 66
me.donespellid = 32612

--[[
----------------------------------------------------------------------------------
			Services from CombatEvents.lua
----------------------------------------------------------------------------------
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
	SPELL_AURA_REMOVED = me.filters.onme,
	SPELL_CAST_SUCCESS = me.filters.fromme,
}

me.oncombatevent = function(...)
	
	local timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags, spellid = select(1, ...)
	
	if eventname == "SPELL_CAST_SUCCESS" then
				
		if spellid == me.fadingspellid then
			
			-- start ticking
			me.isactive = true
			me.ticks = 0
			me.casttime = GetTime()
						
		elseif spellid == me.donespellid then
			
			me.isactive = false
			mod.mythreat.clearall()
		end
		
	elseif eventname == "SPELL_AURA_REMOVED" then
		
		if spellid == me.fadingspellid then
						
			-- stop ticking
			me.isactive = false
		end
	end
		
end

--[[
----------------------------------------------------------------------------------
				Services from Updates.lua
----------------------------------------------------------------------------------
]]

me.myonupdates = 
{
	updateinvisibility = 0.1,
}

me.updateinvisibility = function()
	
	-- 1) if the buff is not active, nothing to do
	if me.isactive == false then
		return
	end
	
	-- 2) Check whether an action has caused the buff to fall off
    local ticksnow = math.floor((GetTime() - me.casttime) / me.tickinterval)
    
	if GetPlayerBuffName(mod.string.get("spell", "invisibility")) == nil and ticksnow > 0 then 
				
		me.isactive = false
		return
	end
	
	-- 3) Is it time for another tick?
	if ticksnow > me.ticks then
		me.ticks = me.ticks + 1
		
		if me.ticks > me.maxticks then
						
			me.isactive = false
			return
		
		else
			mod.mythreat.multiplyall(1 - me.levelpertick)

		end
	end

end