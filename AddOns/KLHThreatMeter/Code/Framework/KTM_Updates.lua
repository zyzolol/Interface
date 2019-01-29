
-- module setup
local me = { name = "update"}
local mod = thismod
mod[me.name] = me

--[[
Updates.lua

This module provides an <onupdate> service to the rest of the addon.

1) OnUpdate service.

Implement a method called "onupdate" in your module and it will get called on every OnUpdate trigger. 

Alternatively, if you have a number of different methods that you want called periodically with different, specific periods, implement a table "myonupdates" as in this example

		me.myonupdates = 
		{
			updatescores = 0.0,
			updatenames = 0.5,
		}
		
		me.updatescores = function()
			(...)
		end
		
		me.updatenames = function()
			(...)
		end
		
The keys of the table must match functions in your module. The values are the minimum number of seconds allowed between subsequent method calls. 


]]

--[[
------------------------------------------------------------------------------------------
			Data Structures to remember OnUpdate subscriptions
------------------------------------------------------------------------------------------
]]

--[[
<me.onupdates> records which modules want onupdates. This is only for modules that have a <myonupdates> table - modules with <onupdate> we will just rescan for when an updates comes through. 

Suppose there is a method <mod.combat.updatedamage()> that should be called at most every 0.4 seconds, and a method <mod.combat.updatehealth()> that should be called every OnUpdate. Then e.g.

me.onupdates = 
{
	combat = 
	{
		updatedamage = 
		{
			lastupdate = 1234.203, 	-- value of GetTime()
			interval = 0.4,
		},
		updatehealth = 
		{
			lastupdate = 1235.120,	
			interval = 0.0,			-- 0.0 sec is minimum time between updates
		}
	}
}
]]
me.onupdates = { }

--[[
------------------------------------------------------------------------------------------
				Startup: Loading the Updates Module
------------------------------------------------------------------------------------------

Loader.lua provides runs our startup functions. First <me.onload> is called, which creates our frame. Then <me.onmoduleload> is called with other modules as arguments, which will register all the necessary events on our frame. Then <me.onloadcomplete> is called, which creates the OnUpdate script handler on our frame.
]]

--[[
me.onload() - special function called by Loader.lua

Creates the frame we will generate Events and OnUpdates with.
]]
me.onload = function()
	
	-- Create a frame to receive events and onupdates
	me.frame = mod.gui.rawcreateframe("Frame", nil, nil)
	me.frame:Show()

end

--[[
me.onmoduleload() is a special function called by Core.lua when the addon starts up. It will be called once for each other module in the addon. We check whether they wish to receive events or onupdates, and implement them.
]]
me.onmoduleload = function(module)

	-- 2) Check for timed OnUpdates subscription
	if module.myonupdates then
		
		me.onupdates[module.name] = { }
		
		for method, interval in pairs(module.myonupdates) do
			
			if type(module[method]) ~= "function" then
				
				-- the module has not defined the method it promised
				if mod.trace.check("error", me, "onupdates") then
					mod.trace.printf("The function |cffffff00%s|r in the onupdate list of the module |cffffff00%s|r is not defined.", method, module.name)
				end
				
			else
				me.onupdates[module.name][method] = 
				{
					lastupdate = 0,
					interval = interval,
				}
			end
		end
	end
	
end

--[[
me.onloadcomplete() is a special function called by Loader.lua after every module has loaded. This ensures that modules don't receive events until they have loaded.
]]
me.onloadcomplete = function()

	-- set handlers
	me.frame:SetScript("OnUpdate", me.frameonupdate)
	
end

--[[
me.frameonupdate() is the OnUpdate handler of <me.frame>.

We pass the onupdate to all modules that have registered for it.
]]
me.frameonupdate = function()
	
	-- don't send events unless the mod is enabled and loaded
	if mod.loader.isloaded == false or mod.isenabled == false then
		return
	end
	
	local key, subtable, module, moduledata, functiondata
	
	-- call all onupdates
	for key, subtable in pairs(mod) do
		if type(subtable) == "table" and type(subtable.onupdate) == "function" then
			
			-- INSERT
			
			local result, message = mod.error.protectedcall(subtable.name, "onupdate", subtable.onupdate)
			if result == false then
				mod.error.reporterror()
			end
			
			-- COMMENT
			--mod.diag.logmethodcall(key, "onupdate")
		end
	end
	
	-- call all timed update methods
	local timenow = GetTime()
	
	for module, moduledata in pairs(me.onupdates) do
		 
		for functionname, functiondata in pairs(moduledata) do
			if timenow > functiondata.lastupdate + functiondata.interval then
				
				-- INSERT
				----[[
				local result, message = mod.error.protectedcall(module, "onupdate", mod[module][functionname])
				if result == false then
					mod.error.reporterror()
				end
				--]]
				-- COMMENT
				--mod.diag.logmethodcall(module, "onupdate", mod[module][functionname])
				functiondata.lastupdate = timenow
			end
		end
	end
	
end