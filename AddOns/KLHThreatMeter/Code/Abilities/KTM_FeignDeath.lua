
local me = { name = "feigndeath"}
local mod = thismod
mod[me.name] = me

--[[
FeignDeath.lua

Handles the Hunter spell Feign Death.

----------------------------------------------------
		World of Warcraft Implementation
----------------------------------------------------

Feign Death is a channeling spell with a 6 minute duration. While it is active you gain a buff "Feign Death". When it is cast, it will instantly reduce your threat to all mobs, with a chance to be resisted. 
If it is resisted, you will still gain the "Feign Death" buff, but your threat will not be reduced. Additionally, the event UI_ERROR_MESSAGE is raised with argument ERR_FEIGN_DEATH_RESISTED. Fortunately the UI_ERROR_MESSAGE event will always come before the "Feign Death" buff.

The function IsFeignDeath returns non-nil if the player is feigning. In patch 2.1 this will become UnitIsFeignDeath("player").

----------------------------------------------------
			KTM Implementation
----------------------------------------------------

We poll the player's feign death state using IsFeignDeath or UnitIsFeignDeath, whichever is defined. The current value is kept in <me.isactive>. 

We record feign death resist events and store the time of the event in <me.lastresisttime>. 

If the <isactive> state changes to <true>, we check for a recent resist. If one exists, no wipe, otherwise wipe threat.

----------------------------------------------------
			Interaction with other modules
----------------------------------------------------

The <feigndeath> module uses services from the <event> module. To change your threat it calls <mod.table.resetraidthreat>

There are a few debug printouts that use the <trace> module.
]]

	--[[
	-- uncomment for debug
	me.mytraces = 
	{
		default = "info",
	}
	--]]

--[[
-----------------------------------------------------------------------
  				Member Variables
-----------------------------------------------------------------------
]]

me.lastresisttime = 0 	-- return value of GetTime()
me.isactive = false		-- whether feign death buff is active

--[[
------------------------------------------------------------------------
  				Services from Events.lua
------------------------------------------------------------------------
]]

me.myevents = { "UI_ERROR_MESSAGE", }

me.onevent = function()

	-- 1) Check for Feign Death resisted
	if event == "UI_ERROR_MESSAGE" then
		
		if arg1 == ERR_FEIGN_DEATH_RESISTED then
			
			me.lastresisttime = GetTime()
				
			if mod.trace.check("info", me, "feigndeath") then
				mod.trace.printf("Feign Death Resist message intercepted. Timer set to %s.", me.lastresisttime)
			end
			
		end
		
		return
	end

end

me.myonupdates = 
{
	updatefeigndeath = 0.5,	
}

me.updatefeigndeath = function()

	-- only applicable for hunters
	if mod.my.class ~= "hunter" then
		return
	end
		
	-- get the current Feign Death state. At the time of writing, the IsFeignDeath command is due to be replaced by UnitIsFeignDeath in the coming patch.
	local statenow = UnitIsFeignDeath("player")
	
	-- check for buff if function fails (due to noob blizzard)
	if not statenow then
		
		local feigndeath = mod.string.tryget("spell", "feigndeath")
		local buffname
		
		if feigndeath then
		
			for x = 1, 40 do
				
				buffname = UnitBuff("player", x)
				
				if buffname == nil then
					break
					
				elseif buffname == feigndeath then
					statenow = true
					break
				end
			end
		end
	end
				
	-- convert to true / false
	statenow = ((statenow ~= nil) and (statenow ~= false) and (statenow ~= 0))
	
	-- ignore on no change
	if statenow == me.isactive then
		return
	else
		
		if mod.trace.check("info", me, "feigndeath") then
			mod.trace.printf("FD state has changed to %s.", tostring(statenow))
		end
		
		me.isactive = statenow
	end
	
	-- check for resist or successful feign
	if me.isactive == true then
	
		if math.abs(me.lastresisttime - GetTime()) < 1.0 then
			
			-- debug and no threat wipe
			if mod.trace.check("info", me, "feigndeath") then
				mod.trace.print("Feign Death was resisted! No clear will occur")
			end
				
		else 
			
			-- debug 
			if mod.trace.check("info", me, "feigndeath") then
				mod.trace.print("No resist. Wiping threat now.")
			end
			
			-- not resisted. wipe threat
			mod.mythreat.clearall()
		end
	end
	
end
