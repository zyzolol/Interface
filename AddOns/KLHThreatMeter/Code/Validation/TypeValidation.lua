
-- module setup
local me = { name = "typevalidation"}
local mod = thismod
mod[me.name] = me

--[[
TypeValidation.lua

This is part of the validation block. It provides methods to validate an object against a type info.

TODO: finish up these comments
]]

--[[
[nil] <string> = mod.typevalidation.validate(modulename, typename, object)

TODO: redo this
This is the entry point for this module. It validates <object> against the type whose name is <typename>.

<string> is an error message, nil if there is no error.
<typename> is the name of the type instance that <object> must satisfy.
<object> is the object to be validated.
]]
me.validate = function(module, typename, object)
	
	-- load the module reference, to identify the enum
	me.currentmodule = module.name
	
	return (me.validateobject(typename, object))	-- wrapping return to prevent tail calls
	
end

--[[
TODO

note the wrapped returns to prevent tail call optimisation (harder to debug)
]]
me.validateobject = function(typename, object)
	
	-- 1) Try to get the type from its name and module
	local typeinfo = mod.typeschema.gettypeinfo(me.currentmodule, typename)
	
	-- 2) error if the type info doesn't exist
	if typeinfo == nil then
		return string.format("There is no type '%s' defined in the '%s' module.", tostring(typename), me.currentmodule)
	end
	
	-- split into separate methods for each possibly base type of <typeinfo> (cause it's complicated!)
	if typeinfo.type == "bool" then
		return (me.validatebool(typeinfo, object))
	
	elseif typeinfo.type == "number" then
		return (me.validatenumber(typeinfo, object))
	
	elseif typeinfo.type == "literal" then
		return (me.validateliteral(typeinfo, object))
		
	elseif typeinfo.type == "string" then
		return (me.validatestring(typeinfo, object))
		
	elseif typeinfo.type == "list" then
		return (me.validatelist(typeinfo, object))
		
	elseif typeinfo.type == "lookup" then
		return (me.validatelookup(typeinfo, object))
		
	elseif typeinfo.type == "class" then
		return (me.validateclass(typeinfo, object))
	
	else
		-- error: unknown type. This shouldn't happen if it has been loaded properly by TypeSchema
		return (mod.format("The base type '%s' is not recognised.", tostring(typeinfo.type)))
	end
	
end

--[[
todo
]]
me.gettypeinfo = function(typename)
	
	return (mod.typeschema.gettypeinfo(me.currentmodule, typename))
	
end

--[[
[nil] <error> = me.validatestring(typeinfo, object)

Validates <object> against a type instance.
Returns nil if validation is successful, otherwise an error message.
]]
me.validatestring = function(typeinfo, object)
	
	-- check nullable property
	if object == nil then
		
		if typeinfo.nullable then
			return	-- null is OK: finish
		else
			return "The value is not allowed to be empty / missing."
		end
	end
	
	-- check type == string
	if type(object) ~= "string" then
		return mod.format("The value's type is '%s', but it must be 'string'.")
	end
	
	-- check minlength and maxlength properties
	local length = string.len(object)
	
	if typeinfo.minlength and length < typeinfo.minlength then
		return mod.format("The length '%s' is lower than the minimum, '%s'.", length, typeinfo.minlength)
	end
	
	if typeinfo.maxlength and length > typeinfo.maxlength then
		return mod.format("The length '%s' is higher than the maximum, '%s'.", length, typeinfo.maxlength)
	end
	
	-- check format property
	if typeinfo.format and not string.find(object, typeinfo.format) then
		return mod.format("The value does not satisfy the format string '%s'.", typeinfo.format)
	end
	
	-- check enum property
	if typeinfo.enum then
		
		if not mod.enum.contains(typeinfo.enum, object) then
			return mod.format("The value is not an element in the '%s'.'%s' enumeration. Allowed values are '%s'.", mod.enum.getowningmodule(typeinfo.enum), typeinfo.enum, mod.enum.valuesettostring(typeinfo.enum))
		end
	end
	
	-- success
	return
	
end

--[[
[nil] <error> = me.validatebool(typeinfo, object)

Validates <object> against a boolean type instance.
Returns nil if validation is successful, otherwise an error message.
]]
me.validatebool = function(typeinfo, object)
	
	-- check nullable property
	if object == nil then
		
		if typeinfo.nullable then
			return	-- null is OK: finish
		else
			return "The value is not allowed to be empty / missing."
		end
	end
	
	-- check type == bool
	if type(object) ~= "bool" then
		return mod.format("The value's type is '%s', but it must be 'bool'.")
	end
	
end

--[[
[nil] <error> = me.validateliteral(typeinfo, object)

Validates <object> against a literal type instance.
Returns nil if validation is successful, otherwise an error message.
]]
me.validateliteral = function(typeinfo, object)
	
	-- check nullable property
	if object == nil then
		
		if typeinfo.nullable then
			return	-- null is OK: finish
		else
			return "The value is not allowed to be empty / missing."
		end
	end
	
	-- check value property
	if typeinfo.value and typeinfo.value ~= object then
		return mod.format("The value must be the literal '%s', not '%s'.", tostring(typeinfo.value), tostring(object))
	end
	
end

--[[
[nil] <error> = me.validatenumber(typeinfo, object)

Validates <object> against a number type instance.
Returns nil if validation is successful, otherwise an error message.
]]
me.validatenumber = function(typeinfo, object)
	
	-- check nullable property
	if object == nil then
		
		if typeinfo.nullable then
			return	-- null is OK: finish
		else
			return "The value is not allowed to be empty / missing."
		end
	end
	
	if typeinfo.min and object < typeinfo.min then
		return mod.format("The value '%s' is below the minimum of '%s'.", object, typeinfo.min)
	end
	
	if typeinfo.max and object > typeinfo.max then
		return mod.format("The value '%s' is above the maximum of '%s'.", object, typeinfo.max)
	end
	
	if typeinfo.integer and math.floor(object) ~= object then
		return mod.format("The value '%s' is not a whole number.", object)
	end
	
end

--[[
[nil] <error> = me.validatelist(typeinfo, object)

Validates <object> against a list type instance.
Returns nil if validation is successful, otherwise an error message.
]]
me.validatelist = function(typeinfo, object)
	
	-- check nullable property
	if object == nil then
		
		if typeinfo.nullable then
			return	-- null is OK: finish
		else
			return "The value is not allowed to be empty / missing."
		end
	end
	
	-- check type
	if type(object) ~= "table" then
		return mod.format("The type of the value must be a table, not '%s'.", type(object))
	end
	
	-- check contents	
	for index, listobject in ipairs(object) do
		
		local errormessage = me.validateobject(typeinfo.valuetype, listobject)
		
		if errormessage then
			return mod.format("Error parsing the item at index '%s' to '%s':\n %s", index, typeinfo.valuetype, errormessage)
		end
	end
	
	-- check emptyok
	local listcount = #object

	if listcount == 0 and not typeinfo.emptyok then
		return "The list cannot be empty.";
	end
	
	-- check for non-list keys and bar
	for key, value in pairs(object) do
		
		if type(key) ~= "number" or key < 1 or key > listcount or math.floor(key) ~= key then
			return mod.format("The key '%s' is not allowed in a list of length '%s'.", tostring(key), listcount)
		end
	end
	
end

--[[
[nil] <error> = me.validatelookup(typeinfo, object)

Validates <object> against a lookup type instance.
Returns nil if validation is successful, otherwise an error message.
]]
me.validatelookup = function(typeinfo, object)

	-- check nullable property
	if object == nil then
		
		if typeinfo.nullable then
			return	-- null is OK: finish
		else
			return "The value is not allowed to be empty / missing."
		end
	end
	
	-- check lua type
	if type(object) ~= "table" then
		return mod.format("The type of a lookup object must be 'table', not '%s'.", type(object))
	end

	-- check contents
	local count = 0

	for keyitem, valueitem in pairs(object) do
		
		count = count + 1
		
		-- check key
		local errormessage = me.validateobject(typeinfo.keytype, keyitem)
		
		if errormessage then
			return mod.format("The key '%s' does not satisfy the '%s' type:\n '%s'", tostring(keyitem), typeinfo.keytype, errormessage)
		end

		-- check value
		errormessage = me.validateobject(typeinfo.valuetype, valueitem)
		
		if errormessage then
			return mod.format("The value '%s' from the key '%s' does not satisfy the '%s' type:\n '%s'", tostring(valueitem), tostring(keyitem), typeinfo.valuetype, errormessage)
		end
		
	end
	
	-- check emptyok
	if count == 0 and not typeinfo.emptyok then
		return "The lookup cannot be empty."
	end
	
end

--[[
[nil] <error> = me.validateclass(typeinfo, object)

Validates <object> against a class type instance.
Returns nil if validation is successful, otherwise an error message.
]]
me.validateclass = function(typeinfo, object)

	-- check nullable property
	if object == nil then
		
		if typeinfo.nullable then
			return	-- null is OK: finish
		else
			return "The value is not allowed to be empty / missing."
		end
	end
	
	-- check lua type
	if type(object) ~= "table" then
		return mod.format("The type of a lookup object must be 'table', not '%s'.", type(object))
	end
	
	local childitem, itemtype, errormessage
	
	-- check contents
	for itemkey, itemtypename in pairs(typeinfo.schema) do
		
		-- get actual value
		childitem = object[itemkey]
		
		-- check
		errormessage = me.validateobject(itemtypename, childitem)
		
		if errormessage then
			return mod.format("The value '%s' from the key '%s' does not satisfy the '%s' type:\n '%s'", tostring(childitem), tostring(itemkey), itemtypename, errormessage)
		end
	end
	
	-- check for junkok
	if not typeinfo.junkok then
		
		for key, value in pairs(object) do
			
			if not typeinfo.schema[key] then
				return mod.format("The key '%s' is not allowed.", key)
			end
		end
	end
		
end

