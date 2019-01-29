
-- module setup
local me = { name = "serial"}
local mod = thismod
mod[me.name] = me

--[[
Serialise.lua

This module performs serialisation of tables. Serialisation means turning a piece of data into a string that can be saved, kept in storage, and reloaded from the string to the original data later on. Serialisation is necessary to send objects to a remote user.

The module is not capable of serialising all tables. Specifically,
	
	1) Table keys must be either numbers or strings
	2) Table values cannot be compiled functions,  i.e. functions defined in addons at design time.
	
The following are possible values:

	1) Recursively defined tables
	2)	Functions created at runtime, i.e. using loadstring

This file is divided into the following sections:

	1) Reading a Table from a string
	2) Converting a Table to a String
	3) Correctness Testing
]]

--[[
------------------------------------------------------------------------------------------
				Section 1: Reading a Table from a String
------------------------------------------------------------------------------------------
]]

--[[
success, value = mod.serial.gettablefromstring(text)

Attempts to load a table from a string. The string <text> contains uncompiled lua code that defines the table. We execute the code in a limited environment and catch any errors.

Return values:
	<success>	boolean; whether the operation worked.
	<value>		if <success> = true, the table. If <success> = false, a string with the error message.
]]
me.gettablefromstring = function(text)
	
	local success, value = pcall(me.trydeclaretable, text)
	
	if success == false then
		return false, value
	
	elseif type(value) == "table" then
		return true, value
		
	else
		return false, "Data is in the wrong type: " .. type(value)
	end
		
end

--[[
value = me.trydeclaretable(text)

Compiles the lua code in <text> and runs it. If <text> is not valid lua code, the method throws an error. Otherwise the compiled function is sent to <me.trydeclaretable2> for evaluation, and the return value of that function is returned.

<text>	string; lua code to be evaluated.

Returns: a table defined by <text>. May be nil or not a table if <text> is not correct.
Throws: error if <text> is not valid lua code.
]]
me.trydeclaretable = function(text)

	local func, message = loadstring(text)
	
	if func == nil then
		error("Loadstring: " .. message)
	end
	
	setfenv(me.trydeclaretable2, getfenv(0))
	
	return me.trydeclaretable2(func)
	
end

--[[
me.trydeclaretable2(func)

Evaluates the function <func> in a secure environment and returns the value <data> that it should assign. This method is called by <me.trydeclaretable>. We set the function environment of <func> to an empty table to prevent malicious code damaging the system. 

If the code is legitimate, it will assign a value to <data>, and we will return that value. We don't check the type of <data> to make sure it is a table, that's done above.
]]
me.trydeclaretable2 = function(func)

	-- restrict permissions for <me.trydeclaretable>
	local zeroenvironment = { }
	setfenv(func, zeroenvironment)
	
	func()
	
	return zeroenvironment.data
	
end

--[[
------------------------------------------------------------------------------------------
				Section 2: Converting a Table to a String
------------------------------------------------------------------------------------------
]]

--[[
success, value = mod.serial.tabletostring(data)

Serialises a table. That is, converts it to a string that can be converted back to the original table. The method is called recursively on all the elements in the table.

See <me.tabletostringinternal> for the implementation details.

Arguments:
<data>  table; or any primitive type.

Return:
<success>   boolean; true if it worked, false otherwise
<value>     string; serialisation. Might not be complete if there were errors on the way.
]]
me.tabletostring = function(data)
	
	me.valuelookup = {[data] = "data"}
	me.recursions = { }
	
	local success, value = me.tabletostringinternal(data, me.valuelookup, me.recursions, 1)
	
	if not success then
		return success, value
	end
	
	for index, line in pairs(me.recursions) do
		value = value .. "\n" .. line
	end
	
	return true, "data = " .. value

end

--[[
success, value = me.tabletostringinternal(data, valuelookup, recursions)

Converts a table to a set of lua code that defines the table. 

For a simple table like { 3 = true } it will return simply "data = {3 = true}". The main problem is when the table is recursively defined. Consider 
	
	data = { }
	data.x = data

The key "x" in <data> points to <data> itself. If we keep recursing like a moron, we'll output { { { { { { ..... } } } } } to infinity. We need to generate code just like the example declaration instead!

To make this work, we create two tables <valuelookup> and <recursions>. In fact, they are created with startup values for us by <me.tabletostring>. <recursions> is a table of strings that represent all the statements we need to make after declaring the table to add the recursively defined elements in. 

<valuelookup> is table that gives a pointer to each internal table. Suppose we have a table

	data = 
	{
		a = 
		{
			b = true,
			c = <data>,
		},
	}
			
In other words, data.a.c = data. Now, the keys in <valuelookup> are every subvalue in <data> that has type "table". So in the example, the keys are <data>, <a> and <c>. The keys are the tables themselves, not the strings "a", "data", "c" for example. The values of <valuelookup> are strings that index them. An example describes it best. In the current example it would be

	valuelookup = 
	{
		[<data>] = "data",
		[<a>] = "data.a",
		[<c>] = "data.a.c",
	}

I'm not going to explain the rest cause it's taking too long, but you get the idea.
]]
me.tabletostringinternal = function(data, valuelookup, recursions)

	if type(data) == "boolean" then
		return true, tostring(data)
	
	elseif type(data) == "number" then
		return true, tostring(data)
	
	elseif type(data) == "string" then
		return true, "\"" .. string.gsub(data, "\"", "\\\"") .. "\""
		
   elseif type(data) == "table" then
        
		if valuelookup[data] == nil then
			error("no valuelookup for data at depth = " .. depth)
		end
		
      local result = "{"
      local keypart, valuepart
      local success = true
        
      for key, value in pairs(data) do
                    
         -- get key
         success, keypart = me.keytostring(key)
         
         if not success then
             break
         end
			           		
			-- inline function
			if type(value) == "function" then
				
				table.insert(recursions, me.getdescription(valuelookup[data], key) .. " = " .. me.tryserialisefunction(data))
			
			-- recursive table
			elseif type(value) == "table" and valuelookup[value] then
				
				table.insert(recursions, me.getdescription(valuelookup[data], key) .. " = " .. valuelookup[value])

			-- normal value
			else
				
				-- add this to the value lookup if it is a table
				if type(value) == "table" then
					valuelookup[value] = me.getdescription(valuelookup[data], key)
				end
				
				-- recurse
				success, valuepart = me.tabletostringinternal(value, valuelookup, recursions)
								
				if not success then
					errtab = value
					error("success failure!!!")
					break
				end
				
				result = result .. "\n" .. keypart .. valuepart .. "," 
			end
     	end
     
     	return success, result .. "}"
        
   else
      return false, ""
   end

    -- debug
    mod.print("could not serialise table due to bad type")

end

--[[
me.tryserialisefunction(data)

Attempts to turn a function into a string. This won't work if

1) The function was defined at design time. i.e. in addon code like this.
2) The function is a blizzard function not defined in Interface\FrameXML\, which is most of the WoW API.

In other words, it only works on functions that have been created by loadstring.

If it fails, it will return a string instead.
]]
me.tryserialisefunction = function(data)
	
	-- If it is a blizzard internal function, dump will generate a lua error.
	local success, functiontext = pcall(string.dump, data)	
	
	-- 1) blizzard / internal lua function. Return function name if possible
	if not success then
		
		for key, value in pairs(getfenv(0)) do
			if value == data then
				return "\"Unable to serialise global function '" .. key .. "'\""
			end
		end
		
		return "\"Unable to serialise unknown global function\""
	end
	
	-- Now try to recompile it. This will tell if it is addon code or not
	if pcall(loadstring, value) then
		
		-- recompilation worked; it is an inline function
		return functiontext
		
	else
		-- <functiontext> is just a pointer to a .lua file. Return the name of the file
		local match = string.match(functiontext, "@(.+%.lua)")
		
		if match then	-- the gsub bit is to allow the string to wrap better
			return "\"Unable to serialise addon function in " .. string.gsub(match, "\\", "\\ ") .. "\""
		else
			return "\"Unable to serialise unknown addon function\""
		end
	end
	
end

--[[ 
me.getdescription(parentdescription, key)

<parentdescription> is a reference to a subtable, like "data.a[\"test test\"][2].c"
<key> is a key in that subtable.

Return Value is a reference to the subtable + key
]]
me.getdescription = function(parentdescription, key)
	
	if type(key) == "number" then
		return parentdescription .. "[" .. key .. "]"
		
	elseif type(key) == "string" then
		
		-- check for quick key
		if string.find(key, "^%w+$") then
			return parentdescription ..  "." .. key 
			
		else
			return parentdescription ..  "[\"" .. string.gsub(key, "\"", "\\\"") 
		end
	
	else
		error("can't render " .. tostring(key) .. " as a key")
	end
	
end

--[[
success, value = me.keytostring(key)

serialises a table key. Only numbers or strings allowed. We just add the square brackets and put quotes around strings.

Returns:
<success>   boolean, whether it worked
<value>     the result as a string, or the error message.
]]
me.keytostring = function(key)

    if type(key) == "number" then
        return true, "[" .. key .. "] = "
        
    elseif type(key) == "string" then
    
        -- attempt to make a short key
        if string.match(key, "^%w+$") then
            return true, key .. " = "
        end
        
        return true, "[\"" .. string.gsub(key, "\"", "\\\"") .. "\"] = "
        
    else
        return false, "could not serialise this key: " .. tostring(key)
    end

end


--[[
------------------------------------------------------------------------------------------
					Section 3: Correctness Testing
------------------------------------------------------------------------------------------
]]

--[[
/dump mod.serial.test()

Test case for serialisation correctness.
]]
me.test = function()

    local data = 
    {
        { bob = 11, bil = 12},
        
        dob = true,
        [11] = "same"
    }
    
    local success, value = me.tabletostring(data)
    
    if not success then
        mod.print("table to string didn't work! returning in, success, value")
        return data, success, value
    end

    -- now try to unserialise
    local success, value2 = me.gettablefromstring(value)
    
    if not success then
        mod.print("string to table didn't work! returning in, value, success2, value2")
        return data, value, success, value2
    end
    
    mod.print("serialisation appeared to have worked! returning in, middle, out")
    return data, value, value2
    
end


me.test2 = function()
	
	a, b =  klhtm.serial.tabletostring(klhtm.bossmod.mods); b = string.gsub(b, "=", " = ");  

	c = "data = " .. b;
	d = loadstring(c); d();
	
	-- good print of c
	local hits = math.ceil(string.len(c) / 100)
	
	for x = 1, hits do
		mod.print(string.sub(c, x * 100 - 99, x * 100))
	end
		
end

me.test3 = function()
	
	a = 
	{
		["weird \"string\""] = 
		{
			quickstring = true,
			[543.23] = "text"
		},
		func = function() end,
	}
	
	a.b = a
			
	success, c = me.tabletostring(a)
	
	if not success then
		mod.print("Round 1 failed. Table saved to <c>")
		return
	end
	
	mod.print("round 1 OK. dump of table:")
	mod.print(c)
	
	success, d = me.gettablefromstring(c)
	
	if type(d) ~= "table" then
		mod.print("Round 2 failed. error = " .. tostring(d))
		return
	end
	
	mod.print("round 2 OK. Table is <d>")
	success, c = me.tabletostring(d)
	
	mod.print("repacked:")
	mod.print(c)
	
end

--[[
------------------------------------------------------------------------------------------
					Section 4: Unused
------------------------------------------------------------------------------------------
]]

me.defineenvironment = function()
	
	me.environment = { }
	
	for key, value in pairs(getfenv(0)) do
		if string.find(key, "^[A-Z]") and type(value) == "function" and issecurevariable(getfenv(0), key) then
			me.environment[key] = value
		end
	end
	
end

--[[
success, value = me.stringtotable(data)

Unserialises a table. That is, converts the string representation of a table to a copy of the original table. Only designed to work on tables serialised by the above method. i.e. it is only checking for a very specific kind of syntax, so this can't be used as a general parser!

Returns either:
    1) true, <table>, <length>
OR  2) false, <table>, <error message>
]]
me.gettablefromstringold = function(data)

    -- take out tables
    local remain = string.match(data, "^{(.+)}")
        
    if remain == nil then
        return false, {}, "Could not parse table from: " .. data
    end
    
    local length = string.len(remain) + 2
    
    -- instantiate
    local result = { }
    local key, success
    
    -- get items in table
    while string.len(remain) > 0 do
        
        -- get key
        success, key, remainout = me.gettablekey(remain)
        
        if not success then
            return false, result, key
        else
            remain = remainout
        end
        
        -- get value
        success, value, remainout = me.gettablevalue(remain)
        
        if not success then
            return false, result, value
        else
            remain = remainout
        end
        
        -- success
        result[key] = value
    end
    
    return true, result, length
end

-- returns: 
-- returns:
--[[
me.gettablekey(data)

Converts the string representation of a table key to the value itself. Example inputs would be "[23]=<stuff>" or "[\"spelltype\"]=<stuff>". In the second example the key is a string.

Possible Return values:
1) false, error string
2)  true, key value, remain (remain is anything after = sign)
]]
me.gettablekey = function(data)

    local key, remain
    
    -- try for number:
    key, remain = string.match(data, "^%[(%d+)%]=(.+)$")
    
    if key then
       return true, tonumber(key), remain
    end
    
    -- try for shortcut string:
    key, remain = string.match(data, "^(%w+)=(.+)$")
    
    if key then
        return true, key, remain
    end
    
    -- try for  string:
    key, remain = string.match(data, "^%[\"([^\"]+)\"%]=(.+)$")
    
    if key then
       return true, key, remain
    end
    
    -- error
    return false, "Could not parse key from: " .. data
            
end

--[[
me.gettablevalue = function(data)

Converts the string representation of the value from a key-value pair of a table back to the value itself.

Returns:
success, value, remain

<remain> is the remaining string
]]
me.gettablevalue = function(data)

    -- 1) boolean true
    if string.sub(data, 1, 5) == "true," then
        return true, true, string.sub(data, 6)
    end
    
    -- 2) boolean false
    if string.sub(data, 1, 6) == "false," then
        return true, false, string.sub(data, 7)
    end
    
    -- 3) number
    local number = string.match(data, "^(%-?%d%d*%.?%d*),")
    
    if number and tonumber(number) then
        return true, tonumber(number), string.sub(data, string.len(number) + 2)
    end
    
    -- 4) string
    local str = string.match(data, "^\"([^\"]*)\",")
        
    if str then
        return true, str, string.sub(data, string.len(str) + 4)
    end
    
    -- 5) table
    local success, table, length = me.gettablefromstring(data)
    
    if success and string.sub(data, length + 1, length + 1) == "," then
        return true, table, string.sub(data, length + 2)
    end
    
    if success then
        mod.print("table was a success but remain does not start with a comma: " .. string.sub(data, length + 1))
    end
    
    mod.print("gettablevalue returning false on: " .. data)
    return false, "could not parse value from " .. data

end
