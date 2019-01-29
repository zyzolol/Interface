
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

The "fontsizes" enum is marked as belonging to your module. Enum names don't have to be unique accross modules because they can usually be resolved by prioritising the locally defined enum version.
]]

--[[
-----------------------------------------------------------------------------
				Service Interaction
-----------------------------------------------------------------------------
]]

--[[
Loader Service. This is called just after this module loads, one for each module in the addon.
]]
me.onmoduleload = function(module)
	
	-- does module have enums?
	if type(module.myenums) == "nil" then
		return
	end
	
	-- process each enum identity
	for key, value in pairs(module.myenums) do
		me.addenum(module.name, key, value)
	end
	
end

--[[
-----------------------------------------------------------------------------
				Private Variables
-----------------------------------------------------------------------------
]]
me.instances = { } -- key = (enum instance), value = (non-nil)

me.validation = {} -- method argument validators described later. See Validation.lua

--[[
-----------------------------------------------------------------------------
				Public Methods
-----------------------------------------------------------------------------
]]

-- Validation for <me.isdefined>
me.validation.isdefined = 
{
	{ type = "string" },
	{ type = "table", schema = 
		{ 
			name = { type = "string" } 
		} 
	},
}

--[[
bool = mod.enum.isdefined(enumname, module)

retuns true if there is an enum defined matching the given name.
]]
me.isdefined = function(enumname, module)
	
	return me.instances[enumname] and me.instances[enumname][module.name]
	
end

me.validation.contains = 
{
	{ type = "string" },
	{ type = "table", schema = 
		{ 
			name = { type = "string" } 
		} 
	},
	{ }, -- i.e non-nullable
}

--[[
bool = mod.enum.contains(enumname, module, value)

Return true if <value> is in the enum specified by <enumname> and <modulename>
]]
me.contains = function(enumname, module, value)
	
	local modulename = module.name
	
	-- check enum name
	local enumset = me.instances[enumname]
	
	if enumset == nil then 
		-- TODO: emit warning
		return
	end
	
	-- check module name
	local moduleset = enumset[modulename]
	
	if moduleset == nil then
		-- TODO: emit warning
		return
	end
	
	-- check value
	return moduleset[value] ~= nil
	
end

me.validation.valuesettostring = 
{
	{ type = "string" },
	{ type = "table", schema = 
		{ 
			name = { type = "string" } 
		} 
	}
}

--[[
string = mod.enum.valuesettostring(enumname, module)

Prints out the set of possible values as a string.
]]
me.valuesettostring = function(enumname, module)
	
	local modulename = module.name
	local enumset = me.instances[enumname]
	
	-- error handler for bad enum specification
	if enumset == nil then
		return mod.format("{ Error: no enumeration named %s! }", tostring(enumname))
	end
		
	local moduleset = enumset[modulename]
	
	-- error handler for bad enum specification
	if moduleset == nil then
		return mod.format("{ Error: no enumeration named %s is defined in the module %s }", tostring(enumname), tostring(modulename))
	end
	
	local result = "{ "
	
	for key, value in pairs(moduleset) do
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
Called when we are processing an Enum declaration in another module.
]]
me.addenum = function(modulename, enumname, values)
	
	local enum = { }
	
	for index, value in ipairs(values) do
		enum[value] = value
	end
	
	-- now add to instance list
	if me.instances[enumname] == nil then
		me.instances[enumname] = { }
	end
	
	me.instances[enumname][modulename] = enum
end