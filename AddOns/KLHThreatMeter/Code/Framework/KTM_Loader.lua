
-- module setup
local me = { name = "loader"}
local mod = thismod
mod[me.name] = me

--[[
Framework\Loader.lua. (2 Apr 07)

This module loads the addon, by calling the <.onload> method of all subtables of <mod>, where that method exists.

The table <me.priorityload> is a list of special modules that have to be loaded before the rest of the addon. They will be loaded in the order they appear in the <me.priorityload> table.
]]

me.isloaded = false -- true when .onload and .onloadcomplete has been called for all modules
me.isenabled = true -- iif false, onupdate and onevent will not be called

me.priorityload = {"trace", "save", "event", "enum", "typeschema", "validation"} -- there is a strict ordering here!

--[[
e.g. me.loadedmodules = 
{
	combat = true,			-- <mod.combat.onload> has been run if it exists
	data = true,
								-- haven't loaded "regex" module yet.
}
]]
me.loadedmodules = { }


--[[
me.onevent() is called the first time <me.frame>, which is defined at the bottom of this file, receives the "ADDON_LOADED" event. 

It tries to call <me.frameonload> and raises an error if it fails. The framework makes no attempt to continue from an error in the onload sequence, because it is too likely that an error would propogate messily.
]]
me.frameonevent = function()
 
	-- you only get one chance to load (otherwise too many things would break)
	me.frame:UnregisterEvent("ADDON_LOADED")
	
	-- This is a pretty bare bones error handler, but since we can't guarantee that other modules have loaded (such as the error log service), this is all we can do.
	local success, message = pcall(me.frameonload)
		
	if not success then
		mod.print("|cffff0000The mod failed to load properly!")
		mod.print(message)
		_ERRORMESSAGE(message)
	end
	
end

--[[
me.frameonload() is called by <me.frameonevent> when the addon starts.
]]
me.frameonload = function()
	
	-- load priority modules
	for index, key in pairs(me.priorityload) do
		if type(mod[key]) == "table" then
			me.loadmodule(mod[key])
		end
	end
		
	-- load normal modules. Make sure not to load the modules in <me.priorityload> twice!
	for key, subtable in pairs(mod) do
		if type(subtable) == "table" and me.loadedmodules[key] == nil then
			me.loadmodule(subtable)
		end
	end
	
	-- onloadcomplete
	for key, subtable in pairs(mod) do
		if type(subtable) == "table" and subtable.onloadcomplete then
			subtable.onloadcomplete()
		end
	end
	
	me.isloaded = true -- OnEvent and OnUpdate allowed now
		
	-- Print load message
	mod.print(string.format(mod.string.get("print", "main", "startupmessage"), mod.global.release, mod.global.revision), true, nil)
		
end

--[[
me.loadmodule(module)

Loads a module when the addon starts up. If the module has an <onload> method, it will be run. If the module is a service with an <onmoduleload> method, that method will be run once for each module in the addon. 
]]
me.loadmodule = function(module)
	
	-- run onload if it exists
	if module.onload then
		module.onload()
	end
	
	-- run service loader if it exists
	if module.onmoduleload then
		
		-- get all the subtables of the mod
		for key, value in pairs(mod) do
			if type(value) == "table" then
				
				-- run the service's loader on each subtable
				module.onmoduleload(value)
			end
		end
	end
	
	-- this module is now loaded
	me.loadedmodules[module.name] = true
	
end

--[[
------------------------------------------------------------------------------------------------
				Addon Interop: adding a foreign module after loadup
------------------------------------------------------------------------------------------------
]]

--[[
<mod>.loader.lateloadmodule(module)

Allows other addons to add a module to the addon, to receive services from this addon.

<module> must be a table with a <.name> property that does not match the name of an existing module.

Returns: <success>, <message>
<success>	boolean; true if the module was loaded, false otherwise.
<message>	if <success> is false, a string describing the error.
]]
me.lateloadmodule = function(module)
	
	local errormessage = me.lateloadmoduleinternal(module)
	
	if errormessage then
		
		if mod.trace.check("warning", me, "lateload") then
			mod.trace.print(errormessage)
		end
		
		return false, errormessage
	end
	
	if mod.trace.check("warning", me, "lateload") then
		mod.trace.print("successfully loaded the external module " .. module.name)
	end

	return true
	
end

--[[
me.lateloadmoduleinternal(module)

Worker function for <me.lateloadmodule>. That method just handles error printing and return values. This method returns <nil> if there was no error, or a string with the error message.
]]
me.lateloadmoduleinternal = function(module)
	
	if me.isloaded ~= true then
		mod.print("me.isloaded is " .. tostring(me.isloaded))
		return "the loader has not loaded yet"
	end
	
	if type(module) ~= "table" then
		return "<module> is not a table"
	end
	
	if type(module.name) ~= "string" then
		return "<module.name> is not a string"
	end
	
	if me.loadedmodules[module.name] then
		return "a module with that name already exists"
	end
	
	-- add the module i guess
	mod[module.name] = module
	
	-- run onload
	if type(module.onload) == "function" then
		module.onload()
	end
	
	-- show this module to all services
	local key, value, service
	
	for key, _ in pairs(me.loadedmodules) do
		service = mod[key]
		
		if service.onmoduleload then
			service.onmoduleload(module)
		end
	end
	
	-- if this module is a service, show other modules to it
	if module.onmoduleload then
		
		-- get all the subtables of the mod
		for key, value in pairs(mod) do
			if type(value) == "table" then
				
				-- run the service's loader on each subtable
				module.onmoduleload(value)
			end
		end
	end
	
	me.loadedmodules[module.name] = true
	
end


--[[
------------------------------------------------------------------------------------------------
				Bootstrap - creating the frame that will call <me.onevent>
------------------------------------------------------------------------------------------------
]]

-- frame stuff
me.frame = CreateFrame("Frame", string.upper(mod.namespace) .. "_Frame", UIParent)

-- KLHAS Interop
if klhas and klhas.destructor.ishostedassembly(mod) then
	klhas.destructor.notifyframe(mod, me.frame)
end

me.frame:Show()
me.frame:SetScript("OnEvent", me.frameonevent)

-- capture the ADDON_LOADED event for our mod and call me.onload()
me.frame:RegisterEvent("ADDON_LOADED")