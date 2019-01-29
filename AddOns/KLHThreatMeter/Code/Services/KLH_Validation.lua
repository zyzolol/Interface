
-- module setup
local me = { name = "validation"}
local mod = thismod
mod[me.name] = me

--[[
Validation.lua

This module provides a mechanism to validate arguments to methods of your modules. For each function, you can define a table that describes the types of the parameters, as well as whether they can be null and other restrictions. The Validation module will look for these validation tables, then hook the method they point to, and insert appropriate validation code whenever your method is called.

To activate validation on methods in your module, first define a table <me.validation>:

	me.validation = { }
	
Now suppose you have a method you wish to validate, that is defined like this:

	me.create = function(name, width, ishidden)
		
To add validation code, add an entry in the <me.validation> table with the same name as the method, e.g. "create" in this case. An example might be (full details given later)

	me.validation.create = 
	{
		[1] = 
		{
			name = "name",
			type = "string",
		}
		[2] = 
		{
			name = "width",
			type = "number",
			set = "positive",
		}
		[3] = 
		{
			name = "ishidden",
			type = "bool",
			nullable = true,
		}
	}
	
In this example, all the arguments are labelled with their names (e.g. [name = "ishidden"]); this is optional and used for display purposes when an error is reported. If the argument names are not given, generic values like "arg 1" will be used instead.

In the example, the "name" is a string, the "width" is a positive number, and "ishidden" is a boolean. The line [nullable = true] means that the value can be <null> or left out; if that line is ommited, null values cause an error.

------------------------------------------------------------------------

It is not required to validate every parameter. In the example, the data for the "width" argument could have been ommitted without causing an error. Every validated parameter must have a type.

The following values are allowed for the "type" parameter:

	"string", "number", "table", "bool", "enum"

The first four values have the same meaning as LUA types. For instance a "bool" argument must have the value <true> or <false>. The "enum" type is an enumeration, a restricted set of values. See Enumeration.lua for details.

The following extra parameters are defined for certain types:

	1) The "number" type can optionally have the parameter "set". "set" can be "index" or "positive" (e.g. the parameter "width" in the example).
		"index" means the number must be a positive integer; a valid index in a LUA array.
		"positive" means the number must be positive, but can be fractional.
		
	2) The "table" type can optionally have the parameter "schema", which describes keys that must exist in the table. This is a useful way to verify that an argument is an object of a specific complex type. Basically, the value of the "schema" option should be a table with the right keys. e.g.
	
	[1] = 
	{
		name = "rectangle",
		type = "table",
		schema = { "top", "left", "width", "height" },
	}
	
	In the above example, arg1 is a table which must have the keys "top", "left", etc. You can take this one step further; the values of the keys in the schema tables can be argument descriptions, as if they were in some other method's validation data. e.g.
	
	[1] = 
	{
		name = "rectangle",
		type = "table",
		schema = 
		{
			top = 
			{
				type = "number",
				set = "positive",
			}
			left = { type = "number" },
			width = { type = "number" },
			height = { type = "number" },
			
			colour = 
			{
				type = "table",
				schema = 
				{
					red = { type = "number", },
					green = { type = "number", },
					blue = { type = "number", },
					alpha = 
					{
						type = "number",
						nullable = true,
					}
				}
			}
		}
	}
	
	In this example, the "rectangle" argument has been extended. The "left", "right", "width" and "height" properties must be numbers; the "top" property must be positive too.
	
	Also, a required field "colour" has been added, which defines a subtable inside the "rectangle" argument, which itself has required numeric fields.
	
	3) The "enum" type must have the extra parameter "enumname" that identifies the type of enum. See Enumeration.lua for more details.
				
]]

--[[
------------------------------------------------------------------------------------------------
				Interaction With Other Services
------------------------------------------------------------------------------------------------
]]

--[[
Saved Variables service. Switch to enable or disable. Validation should be disabled for release versions because it has the potential to give false positives.

This is processed first onload (Save module loads before others)
]]
me.save = 
{
	enabled = true
}

--[[
Enumeration Service. Define valid types
]]
me.myenums = 
{
	argtypes = {"number", "string", "bool", "enum", "table"},
	numbersets = {"index", "positive"},
}

--[[
Loader service. This method is called once for each module in the addon. Must be called after <me.onload>.
]]
me.onmoduleload = function(module)
	
	-- ignore if validation is disabled
	-- Actually, we can't do that now, because Validation includes the "default" property.
	--[[
	if me.save.enabled ~= true then
		return
	end
	]]
	
	-- ignore if other module does not have a validation table
	if type(module.validation) ~= "table" then
		return
	end
	
	-- See "parser" submodule defined further down
	me.parser.addmodulevalidator(module, module.validation)
	
end

--[[
------------------------------------------------------------------------------------------------
				Private Variables
------------------------------------------------------------------------------------------------
]]

me.data = { } --[[
Key = Original function that was hooked.
Value = 
{
	modulename = (string: <name> of the module that owns the function)
	methodname = (string: function name as key in its module)
	validation = { ... } (a validation table) 
} ]]

me.currentargs = { } -- copy of the "..." in (me.validate)

--[[
------------------------------------------------------------------------------------------------
				Private Methods
------------------------------------------------------------------------------------------------
]]

--[[
This is the hookproc for all methods that are validated. Look up the validation table in our data, then check and error.

<method>		Pointer to the original function
...			Original arguments

Returns:		pipes return values of method.
]]
me.validate = function(method, ...)
	
	-- validate
	local methoddata = me.data[method]
	
	-- we need to copy args over to a table, so that e.g. we can replace them. Therefore first we clear the existing values in the table
	for x, _ in pairs(me.currentargs) do
		me.currentargs[x] = nil
	end

	-- now load values from ...
	for x = 1, select("#", ...) do
		me.currentargs[x] = select(x, ...)
	end
		
	local isvalid, argerror, errormessage = me.validateparameters(mod[methoddata.modulename], me.currentargs, methoddata.validation)
	
	if not isvalid then
		local source = mod.format("module '%s', method '%s', arg '%s'", methoddata.modulename, methoddata.methodname, argerror)
		me.raiseerror(source, errormessage)
	end
	
	-- all clear: run method, and pipe return values back!
	return method(...)
	
end

--[[
Called when validation fails. Raises an error.

<source> 		description of source, e.g. module, function
<errormessage>	extra identifying data
]]
me.raiseerror = function(source, errormessage)
	
	-- for now, just do a simple error
	local message = mod.format("Validation error in %s: %s.", source, errormessage)
	
	error(message)
	
end

--[[
<bool>, <string>, <string> = me.validateparameters(module, actualargs, validationset)
	
Validates a table of data against its validation table.

Return Values:
<bool>	true if there are no errors
<string>	name of the key or argument that failed (or nil if there is no error)
<string>	error message (or nil if there is no error)
]]
me.validateparameters = function(module, actualargs, validationset)
	
	for argname, argdata in pairs(validationset) do
		
		local errormessage = me.validatearg(module, actualargs, argname, argdata)

		if errormessage then
			return false, argname, errormessage
		end
	end
	
	-- no errors
	return true
	
end

--[[
error = me.validatearg(module, actualargs, argname, argdata)

Validates a specific entry in a validation table, e.g. a single argument.
Returns non-nil on error.

<module>			pointer to the current module (owner of current function)
<actualargs>	all arguments to the function (or, the table being validated)
<argname>		key in <actualargs> that is currently beign validated
<argdata>		validation data for <actualargs>

Returns:
<error>			string; nil for no error, otherwise the message.
]]
me.validatearg = function(module, actualargs, argname, argdata)
	
	local actualvalue = actualargs[argname]
	
	-- 1) Null value: check nullable / default
	if actualvalue == nil then
		
		-- nullable must be allowed
		if not argdata.nullable then
			
			return "The value can't be empty."
		end
		
		-- default
		if argdata.default then
			
			-- set and done
			actualargs[argname] = argdata.default
			return
		end
		
		-- if null is acceptable, don't make any other checks
		return
	end
	
	-- 2) Check Type data
	
	-- a) Number
	if argdata.type == "number" then
		
		if type(actualvalue) ~= "number" then
			return mod.format("The value '%s' is not a number.", tostring(actualvalue))
		end
		
		-- check sets
		if argdata.set == "positive" and actualvalue <= 0 then
			return mod.format("The value '%s' is not a positive number.", actualvalue)
		
		elseif argdata.set == "index" and (actualvalue < 1 or math.floor(actualvalue) ~= actualvalue) then
			return mod.format("The value '%s' is not a positive integer.", actualvalue)
		end
		
		-- OK
		return
	end
		
	-- b) bool
	if argdata.type == "bool" then
		
		-- check lua type
		if type(actualvalue) ~= "bool" then
			return mod.format("The value '%s' is not a bool.", tostring(actualvalue))
		end
		
		-- OK
		return
	end
	
	-- c) string
	if argdata.type == "string" then
		
		-- check lua type
		if type(actualvalue) ~= "string" then
			return mod.format("The value '%s' is not a string.", tostring(actualvalue))
		end
		
		-- OK
		return
	end
	
	-- d) enum
	if argdata.type == "enum" then
		
		-- check value exists in enum
		if not mod.enum.contains(argdata.enumname, module, actualvalue) then
			return mod.format("The value '%s' is not allowed in the '%s.%s' enumeration. Possible values are %s.", tostring(actualvalue), module.name, argdata.enumname, mod.enum.valuesettostring(argdata.enumname, module))
		end
		
		-- OK
		return
	end
	
	-- e) table
	if argdata.type == "table" then
		
		-- check lua type
		if type(actualvalue) ~= "table" then
			return mod.format("The value '%s' is not a table.", actualvalue)
		end		
		
		-- check schema
		if argdata.schema then
			
			local success, keyname, keyerror = me.validateparameters(module, actualvalue, argdata.schema)
			
			if not success then
				return mod.format("Table schema failure on key '%s': %s.", keyname, keyerror)
			end
		end
		
		-- OK
		return
	end
			
end

--[[
------------------------------------------------------------------------------------------------
						Parser SubModule
------------------------------------------------------------------------------------------------

This part is responsible for parsing the validation declarations in other modules. It doesn't interact strongly with the rest of the module, therefore it is contained in its own entity.
]]

-- Submodule definition
me.parser = { }

do
	
local up = me			-- i.e. "up" now points to the validation module, "me" points to the submodule
local me = up.parser

--[[
Here are some local variables common to several methods

me.module			reference to the current module being parsed
me.moduledata		validation table for the module

me.methodname		string, current key in <me.moduledata>
me.methoddata		data for the current method
]]
	
--[[
me.addmodulevalidator(module, validationtable)

Entry Point for the Parser SubModule.

This is called when we have found a module that has a validation table, and are loading it.

<module>				pointer to the module
<validationtable>	table, the module's <me.validation> entry
]]
me.addmodulevalidator = function(module, validationtable)

	-- load arguments
	me.module = module
	me.moduledata = validationtable
	
	-- scan all rows of the table
	for methodname, data in pairs(me.moduledata) do
		
		me.methodname = methodname
		me.methoddata = data
		
		-- check the particular method data
		me.addmethod()
	end
	
end

--[[
me.addmethod()

Called to parse a single key-value entry in a Validation declaration.

Shared variables used:
<me.module>, <me.methodname>, <me.methoddata>
]]
me.addmethod = function()
	
	-- Check method name matches a function in the module
	if type(me.module[me.methodname]) ~= "function" then
			
		-- warn and exit
		if mod.trace.check("warning", up, "badconfig") then
			mod.trace.printf("Bad Validation table in module '%s': the function '%s' is validated but not defined in the module.", me.module.name, me.methodname)
		end
		
		return
	end
	
	-- check method data is a table
	if type(me.methoddata) ~= "table" then
		
		-- warn and exit
		if mod.trace.check("warning", up, "badconfig") then
			mod.trace.printf("Bad Validation table in module '%s', function '%s': the data is a '%s', not a table.", me.module.name, me.methodname, type(me.data))
		end
		
		return
	end
	
	-- This validation table is well enough defined that we can create an entry for it
	me.methodresult = { }
	
	-- now scan each item in the method data
	for index, argdata in pairs(me.methoddata) do
				
		-- do processing on that data
		me.addarg(index, argdata, me.methodresult, mod.format("module '%s', function '%s'", me.module.name, me.methodname), false)
	end
	
	-- Hook method
	
	-- prepare a data entry for this function
	local output = 
	{
		modulename = me.module.name,
		methodname = me.methodname,
		validation = me.methodresult,
	}
	
	-- add a record to parent module's data set
	local originalmethod = me.module[me.methodname]
	up.data[originalmethod] = output
	
	-- execute the hook. Causes a closure with <up> and <originalmethod>	
	me.module[me.methodname] = function(...)
		return up.validate(originalmethod, ...)
	end
	
end

--[[
me.addarg(argindex, argdata, methodresult, source, istableschema)

Called to parse the data for a specific argument in a method data set.
This is also used to parse table schemas of specific arguments, in which case certain rules are a bit different.

<argindex>		positive integer, when method arguments are being parsed, OR any key, if it's a table.
<argdata>		value part of a key-value pair in a method validation table
<methodresult>	validated copy of the method validation table that is being built.
<source>			string identifying where the method / arg / module, or table keys; for user printout
<istableschema>bool; if true, indicates a table schema is being parsed, not method arguments.
]]
me.addarg = function(argindex, argdata, methodresult, source, istableschema)
	
	-- validate arg index as "index" type. Only required for args, not table entries
	if not istableschema then
		if type(argindex) ~= "number" or argindex < 1 or math.floor(argindex) ~= argindex then
		
			-- warn and exit
			if mod.trace.check("warning", up, "badconfig") then
				mod.trace.printf("Bad Validation table in %s: Can't have the key '%s'; argument identifiers must be positive integers.", source, tostring(argindex))
			end
		
			return
		end
	end
	
	-- validate argdata as table
	if type(argdata) ~= "table" then
		
		-- warn and exit
		if mod.trace.check("warning", up, "badconfig") then
			mod.trace.printf("Bad Validation table in %s: The value for argument '%s' is not a table.", source, argindex)
		end
		
		return
	end
	
	-- This validation table is well enough defined that we can create an entry for it
	local argresult = { }
	methodresult[argindex] = argresult
	
	-- define source variable for next method
	local newsource
	
	if istableschema then
		newsource = mod.format("%s[%s]", source, tostring(argindex))
	else
		newsource = mod.format("%s, argument '%s'", source, argindex)
	end
	
	me.processarg(argdata, argresult, newsource, istableschema)	
	
end

--[[
me.processarg(argdata, argresult, source, istableschema)

Continuation of the above method, after the "key" has been validated.

<argdata>		<any>, value of table in which <key> resides
<argresult>		<table>, validated copy of <argdata>. 
<source>			<string>, identifier of the current scope
<istableschema><bool>, true if we are delving down a table argument.
]]
me.processarg = function(argdata, argresult, source, istableschema)
	
	-- Determine "type" property first, as other fields depend on it
	if argdata.type then
		
		-- check it matches the type enum
		if not mod.enum.contains("argtypes", up, argdata.type) then
			
			-- warn and ignore
			if mod.trace.check("warning", up, "badconfig") then
				mod.trace.printf("Bad Validation data in %s: the value of the 'type' property, '%s', does not satisfy the 'argtypes' Enumeration. Allowed values are %s.", source, argdata.type, mod.enum.valuesettostring("argtypes", up))
			end
			
		else
			-- type property is valid
			argresult.type = argdata.type
		end
	end
	
	-- parse all other properties
	for propertyname, propertydata in pairs(argdata) do
		if propertyname ~= "type" then
					
			-- process
			me.addproperty(propertyname, propertydata, argresult, source, istableschema)
		end
	end
	
	-- now verify default value, if it has been defined.
	if argresult.default then
		local errormessage = up.validatearg(me.module, argdata, "default", argdata)
		
		if errormessage then
			
			if mod.trace.check("warning", up, "badconfig") then
				mod.trace.printf("Bad Validation data in %s: the value of the 'default' property, '%s', is not valid: %s.", source, tostring(argresult.default), errormessage)
			end
			
			argresult.default = nil
		end
	end
end

--[[
me.addproperty(propertyname, propertydata, argresult, source, istableschema)

Parses a specific property. Invalid properties will be removed

<propertyname>		string, name of the property in an <argset>
<propertydata>		<any>, value of propertyname table
<argresult>			<table>, output we are working on
<source>				<string>, identifier of overall table
<istableschema>	<bool>, set to true if we are inside a table item.
]]
me.addproperty = function(propertyname, propertydata, argresult, source, istableschema)
	
	-- Name property - only allowed for argument, not table
	if propertyname == "name" and not istableschema then
		
		-- enforce type = string
		if type(propertydata) ~= "string" then
			
			-- warn and ignore
			if mod.trace.check("warning", up, "badconfig") then
				mod.trace.printf("Bad Validation data in %s: The value for the name property must be a 'string', not '%s'.", source, type(propertydata))
			end
			
		else
			-- name is valid. add it
			argresult.name = propertydata
		end
	
	-- Nullable property
	elseif propertyname == "nullable" then
		
		argresult.nullable = true
		
	-- Default property - only allowed for arguments, not table schemas
	elseif propertyname == "default" and not istableschema then
	
		-- Note: we can't validate this until we have loaded all other properties
		argresult.default = propertydata
	
	-- Set property (for "number" types)
	elseif propertyname == "set" then
		
		-- type must be number
		if me.checktypeforproperty("number", propertyname, argresult, source) == false then
			return
		end
			
		-- value must be in numbersets
		if not mod.enum.contains("numbersets", up, propertydata) then
		
			-- warn and ignore
			if mod.trace.check("warning", up, "badconfig") then
				mod.trace.printf("Bad Validation data in module %s: the 'set' property does not satisfy the 'numbersets' Enumeration. Allowed values are %s.", source, mod.enum.valuesettostring("numbersets", up))
			end
			
			return
		end
		
		-- valid
		argresult.set = propertydata
		
	elseif propertyname == "enumname" then
		
		-- type must be enum
		if me.checktypeforproperty("enum", propertyname, argresult, source) == false then
			return
		end
		
		-- check that enum exists in their module
		if not mod.enum.isdefined(propertydata, me.module) then
			
			-- warn and ignore
			if mod.trace.check("warning", up, "badconfig") then
				mod.trace.printf("Bad Validation data in %s: there is no enum '%s' defined in that module.", source, tostring(propertydata))
			end
			
			return
		end
			
		-- enum is valid
		argresult.enumname = propertydata
	
	elseif propertyname == "schema" then
		
		-- type must be table
		if me.checktypeforproperty("table", propertyname, argresult, source) == false then
			return
		end
		
		me.validatetableschema(propertydata, argresult, source)
	
	else
		-- invalid property
		if mod.trace.check("warning", up, "badconfig") then
			mod.trace.printf("Bad Validation data in %s: the property '%s' is not defined.", source, propertyname)
		end
	end
		
end

--[[
me.checktypeforproperty(requiredtype, propertyname, argresult, source)

Called to assert that the <type> property of an argument validation has a specific value. 
For example, the <schema> property is only value when the <type> property has the value "table". 

Returns true if it passes the check.

<requiredtype>		string; value of the required type, e.g. "string".
<propertyname>		string; the propert that only works on that type, e.g. "schema"
<argresult>			table; current validation data for the argument, being parsed
<source>				string; description of current module / function / arg etc, for user printout
]]
me.checktypeforproperty = function(requiredtype, propertyname, argresult, source)
	
	-- type must be number
	if argresult.type ~= requiredtype then
		
		-- warn and ignore
		if mod.trace.check("warning", up, "badconfig") then
			mod.trace.printf("Bad Validation data in %s: The property '%s' is only valid when the type is '%s', not '%s'.", source, propertyname, requiredtype, tostring(argresult.type))
		end
		
		return false
	else
		return true
	end
	
end

--[[
Check that me.propertydata satisfies a table schema

schema = 
{
	<key_i> = {<argschema - but only the right hand side... keys are ANY, not ints. Also, can't have "name" properties.>}
}

<propertydata>	<table>, value of table schema
<argresult> - put .schema into here when validated
<source> description of where we are.

]]
me.validatetableschema = function(propertydata, argresult, source)
	
	argresult.schema = { }
	
	-- populate
	for key, value in pairs(propertydata) do
	
		me.addarg(key, value, argresult.schema, source, true)
	
	end
	
end
	
end -- end of Parser submodule
