
-- module setup
local me = { name = "garbage"}
local mod = thismod
mod[me.name] = me

--[[
Simple garbage reclamation module. No mechanism is provided for releasing old garbage to the real garbage collector.
]]

--[[
------------------------------------------------------------------------------------------------
								Private Variables
------------------------------------------------------------------------------------------------
]]

-- saved variables
me.save = 
{
	enabled = true,
}

-- storage
me.data = { }
me.lookup = { }

-- statistics
me.recyclecount = 0	-- how many tables have been recycled
me.createcount = 0	-- how many tables we have created
me.reusedcount = 0	-- how many table creations we have prevented by reusing old tables
me.overflowcount = 0	-- how many tables we didn't recycle cause queue was too long

-- constants
me.overflowlimit = 1000	-- max # tables in the thingy before overflow

--[[
------------------------------------------------------------------------------------------------
								Public Interface
------------------------------------------------------------------------------------------------
]]

--[[
mod.garbage.recycle(data)

Reclaim the table <data>. Nested tables will be reclaimed automatically. All fields will be nulled.
]]
me.recycle = function(data)
	
	-- ignore if module is disabled
	if not me.save.enabled then
		return
	end
	
	-- update statistics
	me.recyclecount = me.recyclecount + 1
	
	-- clear all entries
	for key, value in pairs(data) do
		
		-- CAREFUL! Have to prevent infinite loop on circular tables, so break link first
		data[key] = nil
		
		-- reclaim nested tables
		if type(value) == "table" then
			
			me.recycle(value)
		end
	end
	
	-- above code is incorrect. If a table contains two copies of a child table, they will both get added.
	if me.lookup[data] == nil then
		
		-- check for overflow
		if #me.data >= me.overflowlimit then
			me.recyclecount = me.recyclecount - 1
			me.overflowcount = me.overflowcount + 1
			return
		end
		
		me.lookup[data] = true
		table.insert(me.data, data)
	end
		
end

--[[
<table> = mod.garbage.gettable()

Makes a new table, sourcing from the garbage collection if possible.

Always returns an empty table.
]]
me.gettable = function()
	
	local value = me.gettableinternal()
	
	for key, value in pairs(value) do
		
		-- this is an error
		mod.printf("Error in Garbage.Gettable! Key = %s, value = %s.", tostring(key), tostring(value))
	end
	
	return value
	
end

me.gettableinternal = function()
		
	-- ignore if module is disabled
	if not me.save.enabled then
		return { }
	end
		
	local output
	local datalength = #me.data

	-- check for available entry
	if datalength > 0 then
		
		-- grab end of stack
		output = me.data[datalength]
		me.data[datalength] = nil
		me.lookup[output] = nil
		
		-- update statistics
		me.reusedcount = me.reusedcount + 1
		
		-- done
		return output
	
	else -- make a new table
		
		-- update statistics
		me.createcount = me.createcount + 1
		
		return { }
	end
end
