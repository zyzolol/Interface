
-- module setup
local me = { name = "typeschema"}
local mod = thismod
mod[me.name] = me

--[[
TypeSchema.lua

This module provides a method to describe a custom data type. With a suitable definition and validation, it is possible to strongly type your data structures and verify method parameters.

These types are built-in, with properties as follows: (optional properties are in [brackets])

Boolean:
{
	type = "bool",
	[nullable] = (always the literal <true>),		-- whether the value can be <nil>
}

Number:
{
	type = "number",
	[nullable] = <true>,
	[min] = (number; the minimum value, inclusive)
	[max] = (number; the maximum value, inclusive)
	[integer] = <true>									-- must be whole number
}

String:
{
	type = "string",
	[nullable] = <true>,
	[minlength] = (number; the minimum length),
	[maxlength] = (number; the maximum length),
	[format] = (string; a string format that the value must satisfy. Ex: "%w+" = alphanumeric only
	[enum] = (string; name of an enum instance. See Enumeration.lua
}

Literal:				-- This describes a value of unknown or any type
{
	type = "literal",
	[nullable] = <true>,
	[value] = (<anything>, specifies the exact value), 
}

List: (array)
{
	type = "list",
	valuetype = (string; the name of a concrete type)
	[nullable] = <true>,
	[emptyok] = <true>,		-- states that the list is allowed to be empty. The default is nil / false
}

Lookup: (hashmap / associative array)
{
	type = "lookup",
	keytype = (string; the name of a concrete type),
	valuetype = (string; the name of a concrete type),
	[nullable] = <true>,
	[emptyok] = <true>,
}

Class: (table with known keys)
{
	type = "class",
	[nullable] = <true>,
	schema = (lookup of string, string. values = string: the name of a concrete type; emptyok = true for schema),
	[junkok] = <true>, 	-- specifies that keys not mentioned in the schema are allowed (default nil = false)
}

Here is an example type spec

me.mytypes = 
{
	mobaggro = 
	{
		type = "lookup",
		emptyok = true,
		keytype = "mobguid",
		valuetype = "playerdata",
	},
	
	mobguid = 
	{ 
		type = "string"
		minlength = 18,
		maxlength = 18,
		format = "0x%x+",    -- i.e. "0x" then 16 hex chars, but length is only described above.
	},
	
	playerdata = 
	{
		type = "class",
		schema = 
		{
			playername = "playername",
			timestamp = "simplenumber",
		}
	}
	
	playername = { type = "string", minlength = 2, format = "%a+" },
	
	simplenumber = { type = "number" }
}

--------------------------------------------------------------------------------

The above type <mobaggro> corresponds to this 'pseudocode' definition:

	mobaggro = 
	{
		mobguid_A = <playerdata>
		mobguid_B = <playerdata>
		...
	}
	
	<playerdata> = 
	{ 
		playername = (string), 
		timestamp = (number) 
	},

--------------------------------------------------------------------------------

The TypeSchema module has the responsibility of parsing all the <me.mytypes> definitions in other modules and create the types appropriately.

Types are associated with the module that defines them. To reference a type, you must provide a module reference as well as the name of the type. Usually the module will be <me>, the current module.

We have a main data source that stores everything, which looks like this:

me.data = 
{
	<modulename1> = <moduledata>,
	<modulename2> = <moduledata>,
	...
}
<moduledata> = 
{
	<typename1> = <type definition>,
	<typename2> = <type definition>,
	...
}

--------------------------------------------------------------------------------

The main challenge of the TypeSchema service is to load other module's type definitions using its own type definition. i.e. we have created a schema to describe / parse / accept the <me.types> definitions in other modules. We want to use this type definition to parse those module's type definitions as they are loaded. The problem is that our type needs to load first, but it would need itself to be loaded in order to load itself!

The solution is stored in TypeBootStrap.lua. We basically cheat by providing a ready-made type definition. We don't try to parse or verify it, we load it directly into memory as if we had loaded it normally. This allows use to use it to load other modules and stuff.
]]

me.data = { }

--[[
me.mytraces = 
{
	default = "info",
}
]]

--[[
--------------------------------------------------------------------------------
					Loading Process
--------------------------------------------------------------------------------
]]

--[[
This is called by the loader service at the start of the loading process. 

We load the bootstrap data and pretend it comes from our own module.
]]
me.onload = function()
	
	me.data[me.name] = mod.typebootstrap.data -- that's it!
	
end

--[[
This is called by the loader service, once for each other module in the addon. We check for a <me.mytypes> definition, and try to load it.
]]
me.onmoduleload = function(module)
		
	-- ignore if the module does not have a schema
	if module.mytypes == nil then
		return
	end
	
	-- try validate
	local errormessage = mod.typevalidation.validate(me, "lookup_schema", module.mytypes)
	
	if errormessage then
		-- warn and exit
		if mod.trace.check("warning", me, "badschema") then
			mod.trace.printf("The schema in the module '%s' is invalid. The error returned was:\n '%s'", module.name, errormessage)
		end
	
		return
	end
	
	-- success: add
	me.data[module.name] = module.mytypes
	
	-- debug
	if mod.trace.check("info", me, "schemaload") then
		mod.trace.printf("Successfully loaded the schema for the '%s' module.", module.name)
	end
	
end

--[[
This will be called by the Loader service, at the end of the load sequence. We want to verify that the bootstrap data satisfies itself. If we don't there's nothing we can do, but it's a good verification to attempt.
]]
me.onloadcomplete = function()
	
	--[[
	1) validate bootstrap data against itself.
	2) print warning if we got an error.
	]]
	local errormessage = mod.typevalidation.validate(me, "lookup_schema", me.data[me.name])
	
	if errormessage then
		
		-- warn and exit
		if mod.trace.check("warning", me, "bootstrap") then
			mod.trace.printf("The bootstrap data could not be self-validated. The error returned was:\n '%s'", errormessage)
		end
		
	else
		-- success! debug print
		if mod.trace.check("info", me, "bootstrap") then
			mod.trace.printf("TypeSchema bootstrap verified!")
		end
	end
	
end

--[[
--------------------------------------------------------------------------------
					Public Methods
--------------------------------------------------------------------------------
]]

--[[
[nil] <typeinfo> = mod.typeschema.gettypeinfo(modulename, typename)

This returns a type object, given its identification (module and type names).
This method should only be called by TypeValidation.lua to perform a requested validation.
Note that the method fails silently if the name lookup fails

<typeinfo>		(table; a type structure) the type info returned, or nil if there is no match for the name.
<modulename>	(string) name of the module that defines the type
<typename>		(string) name of the type; the key in the <me.mytypes> table of the module that defined it.

Indeed, we normally expect that 
	mod[modulename].mytypes[typename] == <typeinfo> == <me.data[modulename][typename]
	
]]
me.gettypeinfo = function(modulename, typename)
	
	-- try get module
	local moduledata = me.data[modulename]
	if moduledata == nil then
		return
	end
	
	-- try get type
	return moduledata[typename]
	
end