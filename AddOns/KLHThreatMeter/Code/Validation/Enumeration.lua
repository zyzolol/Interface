
-- module setup
local me = { name = "enum"}
local mod = thismod
mod[me.name] = me

--[[
Enumeration Module.

An Enumeration is a fixed set of values, usually strings. It's often useful to restrict input to a set of valid options. E.g. suppose you have a method to create a font, and you want to allow the options "big", "medium" or "small" only. 

me.myenums = 
{
	fontsizes = { "big", "medium", "small" }
}

A new requirement is that enum type names (e.g. "fontsizes") are unique accross the addon. This is because it's too hard to resolve multiple enums with the same name, or even identifying any enum. A duplicate definition will cause a warning and the 2nd definition to be ignored.

This module is tighly bound to the Type Schema module. Type Schemas may refer to enumerations, and enumeration definitions can be handled by a type schema validator. Because Type Schemas are a lot more complicated and this circular dependency exists, we have to load Enums first, and manually.
]]

--[[
-----------------------------------------------------------------------------
				Private Variables
-----------------------------------------------------------------------------
]]
me.data = { } --[[
{
	<name> = <enumdata>,
	...
}
<enumdata> = 
{
	modulename = (string; name of defining module)
	lookup = (table; key = an element of the enum, value = any non-nil)
} ]]

me.validation = {} -- method argument validators described later. See Validation.lua



--[[
-----------------------------------------------------------------------------
				Service Interaction
-----------------------------------------------------------------------------
]]

--[[
Loader Service. This is called just after this module loads, one for each module in the addon.

This is how we construct the enums: effectively scanning all modules for <me.myenums> definitions.
]]
me.onmoduleload = function(module)
	
	-- does module have enums?
	if type(module.myenums) == "nil" then
		return
	end
	
	me.parseenumsdefinition(module.name, module.myenums)
	
end


--[[
-----------------------------------------------------------------------------
				Public Methods
-----------------------------------------------------------------------------
]]

me.getowningmodule = function(enumname)
	
	if enumname and me.data[enumname] then
		return me.data[enumname].modulename
	end
	
end

-- Validation for <me.isdefined>
me.validation.isdefined = 
{
	{ type = "string" },
}

--[[
bool = mod.enum.isdefined(enumname)

retuns true if there is an enum defined matching the given name.
]]
me.isdefined = function(enumname)
	
	return me.data[enumname]
	
end

me.validation.contains = 
{
	{ type = "string" },
	{ }, -- i.e non-nullable
}

--[[
bool = mod.enum.contains(enumname, value)

Return true if <value> is in the enum specified by <enumname> and <modulename>
]]
me.contains = function(enumname, value)
	
	local enumdata = me.data[enumname]
	
	return enumdata and enumdata.lookup[value]
	
end

me.validation.valuesettostring = 
{
	{ type = "string" },
}

--[[
string = mod.enum.valuesettostring(enumname)

Prints out the set of possible values as a string.
]]
me.valuesettostring = function(enumname)
	
	local enumdata = me.data[enumname]
	
	-- error handler for bad enum specification
	if enumdata == nil then
		return mod.format("{ Error: no enumeration named %s! }", tostring(enumname))
	end
		
	local result = "{ "
	
	for key, value in pairs(enumdata.lookup) do
		result = result .. tostring(key) .. ", "
	end

	result = result .. "}"
	return result
	
end

--[[
-----------------------------------------------------------------------------
				Internal Methods
-----------------------------------------------------------------------------
]]

--[[
Part 1 of module parsing. We have identified the <me.myenums> value in the parameter <data>.

Check that the data is a table type. If so process all enums definitions in the table.

<data> = 
{
	name1 = <enum>,
	name2 = <enum>,
	...
}
<enum> = { "value1", "value2", ... }  (values don't HAVE to be strings, but we will assume without checking they are. It could feasibly work if they aren't but... just don't!
]]
me.parseenumsdefinition = function(modulename, data)
	
	-- warn if type is not table
	if type(data) ~= "table" then
		
		-- warn and exit
		if mod.trace.check("warning", me, "nottable") then
			mod.trace.printf("The type of table 'me.myenums' in module '%s' is '%s', not 'table'.", modulename, type(data))
			return
		end
	end
	
	-- process each enum identity
	for enumname, values in pairs(data) do
		me.parsesingleenum(modulename, enumname, values)
	end
	
end

--[[
Part 2 of Enum definition parsing.

<enumname> is the key in the enums list: msut be unique throughout the mod.
<values> must be a list of values (ipairs only).

<values> won't be strongly validated.
]]
me.parsesingleenum = function(modulename, enumname, values)
	
	-- 1) check name is unique
	if me.data[enumname] then
		
		-- not unique: warn and exit
		if mod.trace.check("warning", me, "duplicatename") then
			mod.trace.printf("An enum type named '%s' has already been defined in the module '%s'. The definition in module '%s' will be ignored.", enumname, me.data[enumname].modulename, modulename)
		end
		
		return
	end
	
	-- 2) check values = table.
	if type(values) ~= "table" then
		
		-- warn and ignore
		if mod.trace.check("warning", me, "badenum") then
			mod.trace.printf("The enum '%s' in the module '%s' is not a list of data", enumname, modulename)
		end
	
		return
	end
	
	-- 3) create new enum (no validation on ipairs here)
	enum = { }
	
	enum.modulename = modulename
	enum.lookup = { }
	
	for key, value in ipairs(values) do
		enum.lookup[value] = true
	end
	
	-- 4) add
	me.data[enumname] = enum
	
end