
-- module setup
local me = { name = "typebootstrap"}
local mod = thismod
mod[me.name] = me

--[[
TypeBootstrap.lua

This is part of the Validation block. It contains pre-loaded data to validate the base types. This data can't be validated until it is already loaded, so it is written manually and assumed correct. We can optionally verify it at runtime by having it validate itself.

See TypeSchema.lua for more details of how it fits in.
]]

-- This is used in the type definition "string_type" in <me.data> below.
me.myenums = 
{
	basetypes = { "bool", "number", "string", "literal", "list", "class", "lookup" }
}

me.data = 
{
	--[[
	------------------------------------------------------------------------------
					Section 1: String base type
	------------------------------------------------------------------------------
	]]
	string = 
	{
		type = "class",
		schema = 
		{
			type = "literal_string",
			nullable = "literal_true",
			minlength = "number_natural",
			maxlength = "number_natural",
			format = "string_nullable",
			enum = "string_any",
		}
		-- junkok = nil
	},

	literal_string = 
	{
		type = "literal",
		value = "string",
	},
	
	literal_true = 
	{
		type = "literal",
		nullable = true,
		value = true,
	},
	
	number_natural = 
	{
		type = "number",
		nullable = true,
		min = 0,
		integer = true,
	},
	
	string_nullable = 
	{
		type = "string",
		nullable = true,
	},
	
	string_any = 
	{
		type = "string",
	},
	
	--[[
	------------------------------------------------------------------------------
					Section 2: Literal Base Type
	------------------------------------------------------------------------------
	]]
	literal = 
	{
		type = "class",
		schema = 
		{
			type = "literal_literal",
			nullable = "literal_true",
			value = "literal_any",
		}
	},
	
	literal_literal = 
	{
		type = "literal",
		value = "literal",
	},
	
	literal_any = 
	{
		type = "literal",
		nullable = true,
	},
	
	--[[
	------------------------------------------------------------------------------
					Section 3: Number base type
	------------------------------------------------------------------------------
	]]
	number = 
	{
		type = "class",
		schema = 
		{
			type = "literal_number",
			nullable = "literal_true",
			integer = "literal_true",
			min = "number_anynull",
			max = "number_anynull",
		}
	},
	
	literal_number = 
	{
		type = "literal",
		value = "number",
	},
	
	number_anynull = 
	{
		type = "number",
		nullable = true,
	},
	
	--[[
	------------------------------------------------------------------------------
					Section 4: List base type
	------------------------------------------------------------------------------
	]]
	list = 
	{
		type = "class",
		schema = 
		{
			type = "literal_list",
			nullable = "literal_true",
			emptyok = "literal_true",
			valuetype = "string_any",
		},
	},
	
	literal_list = 
	{
		type = "literal",
		value = "list",
	},
	
	--[[
	------------------------------------------------------------------------------
					Section 5: Lookup base type
	------------------------------------------------------------------------------
	]]
	lookup = 
	{
		type = "class",
		schema = 
		{
			type = "literal_lookup",
			nullable = "literal_true",
			emptyok = "literal_true",
			valuetype = "string_any",
			keytype = "string_any",
		},
	},
	
	literal_lookup = 
	{
		type = "literal",
		value = "lookup",
	},
	
	--[[
	------------------------------------------------------------------------------
					Section 6: Class base type
	------------------------------------------------------------------------------
	]]
	class = 
	{
		type = "class",
		schema = 
		{
			type = "literal_class",
			nullable = "literal_true",
			junkok = "literal_true",
			schema = "lookup_stringpairs",
		}
	},
	
	literal_class = 
	{
		type = "literal",
		value = "class",
	},
	
	lookup_stringpairs = 
	{
		type = "lookup",
		emptyok = true,
		keytype = "string_any",
		valuetype = "string_any",
	},
	
	--[[
	------------------------------------------------------------------------------
					Section 7: Schema
	------------------------------------------------------------------------------
	]]
	lookup_schema = 
	{
		type = "lookup",
		emptyok = true,
		keytype = "string_any",
		valuetype = "class_type",
	},
	
	class_type = 
	{
		type = "class",
		junkok = true,		-- this is for the specialisations
		schema = 
		{
			type = "string_type",
		}
	},
	
	string_type = 
	{
		type = "string",
		enum = "basetypes",	-- TODO: define <basetypes> in appropriate place
	}
	
}
	