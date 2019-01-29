
-- module setup
local me = { name = "save"}
local mod = thismod
mod[me.name] = me

--[[
Framework\SavedVariables.lua

This module manages your saved variables. Here's how it works:

1) Other modules define a table <me.save> with key-value pairs, key = name of the variable, value = default value. e.g. in module <bob> there might be
	
	me.save = 
	{
		number = 12,
		name = "bil",
	}
	
This means the <bob> module is defining a saved variable <number>, default value 12, and a variable <name>, default value "bil"

2) In the file Framework\Global.lua, the value <savedvariables> gives the name of the table that stores the saved variables for the mod (which matches the ##SavedVariables line of the .toc file). 

3) Before all the other modules are loaded, the SavedVariables module takes a reference to the table where our saved variables are kept. Then it merges the saved values with the default values for each module - so if there is no saved value defined, the default is used. 

4) Lastly we change the <me.save> reference in every other module to  point to a subtable of the actual saved variables table. Continuing the example above, <mod.save.data> might look like
	
	me.data = 
	{
		bob = 
		{
			number = 100,
			name = "bil",
		}
	}
	
if the saved value for "number" was 100, and there was no saved value for "name".

5) Now the <bob> module simply refers to it's own <me.save> table, and any variable changes will be saved. This is because <mod.bob.save> now equals <mod.save.data.bob>.


-------------------------------------------------------------
			Enforcing a Change to a Saved Variable
-------------------------------------------------------------

It might occur that when making a new version, you want to change the default value of a specific saved variable. Normally someone using the old version will keep the old value, because they have the old default value stuck in their saved variables data. To prevent this, you can specify that the default value should override the saved value the first time it is run.

Suppose your data is
me.save = 
{
	x = "bob",
}

Then to force an override of the "x" variable, do

me.save = 	
{
	override_x = 123,
	x = "bil",
}

This will force the x value to "bil" if the saved variables data was saved with version lower than 123. "version" here is the value of <mod.global.build>.

The version of the saved variables is kept in <savedvariables>._version
]]

-- by default traces will print on "waring" level, but "override" traces will print on "info" level. See Trace.lua for more details.
me.mytraces = 
{
	default = "warning",
	override = "info",
}

-- special method called from Loader.lua
me.onload = function()
		
	me.data = getglobal(mod.global.savedvariables)
	
	if me.data == nil then
		
		-- trace print
		if mod.trace.check("warning", me, "load") then
			mod.trace.print("Could not find the saved variables data |cffffff00" .. mod.global.savedvariables)
		end
		
		-- create fresh
		me.data = {  }
		setglobal(mod.global.savedvariables, me.data)
	end
	
	-- determine version
	me.savedversion = tonumber(me.data._version) or 0
	
	-- upgrade
	me.data._version = mod.global.build

end

--[[
me.onmoduleload(module) - called by Loader.lua when the addon starts. 

Called once for each other module in the addon. We check for a <save> table, and merge it with the save variables if it exists.
]]
me.onmoduleload = function(module)
	
	-- only get modules with saved variables
	if type(module.save) == "table" then
		
		-- no saved data for this module?
		if me.data[module.name] == nil then
			me.data[module.name] = module.save
			
		-- otherwise merge
		else
			me.mergetables(me.data[module.name], module.save)
			module.save = me.data[module.name]
		end
		
		-- now remove any override references, they aren't meant to be saved
		me.removeoverrides(module.save)
	end

end

--[[
me.mergetables(saved, default)

Given a set of saved data and the defaults, puts the default value into the saved data if it is missing or of a different type. Works recursively on tables. 

<saved>		table; subtable of the saved variables.
<default>	table; the default values in the <save> table of some module (or a subtable thereof).
]]
me.mergetables = function(saved, default)
	
	local key, value
	
	for key, value in pairs(default) do
		
		-- if default value has a different type, update
		if type(saved[key]) ~= type(value) then
			saved[key] = value
		
		-- if they are tables, recurse
		elseif (type(saved[key]) == "table") and (type(value) == "table") then
			me.mergetables(saved[key], value)
			
		-- if there is an override defined, then update
		elseif default["override_" .. key] and (default["override_" .. key] > me.savedversion) then
			
			-- debug:
			if mod.trace.check("info", me, "override") then 
				
				mod.trace.printf("Overriding key |cffffff00%s|r to the value |cffffff00%s|r since the override version |cffffff00%s|r is higher than the saved version |cffffff00%s|r.", key, tostring(value), default["override_" .. key], me.savedversion)
			end
			
			saved[key] = value
		end
	end
	
end

--[[
me.removeoverrides(data)

<data> is <me.data> or a subtable thereof. Override information isn't meant to be saved so we remove it from the data.
]]
me.removeoverrides = function(data)
	
	for key, value in pairs(data) do
		if type(value) == "table" then
			me.removeoverrides(value)
		
		elseif string.match(key, "^override_") then
			data[key] = nil
		end
	end
	
end