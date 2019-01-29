
local me = { name = "console"}
local mod = thismod
mod[me.name] = me

--[[
Console.lua

This module manages console commands. It allows other modules to easily define commands.

----------------------------------------------------------------------------------------------
							Defining a Console Command
----------------------------------------------------------------------------------------------

In another module, put e.g.

me.myconsole = 
{
	stop = function() [...] end,
	start = "startnewprocess",
}

"start" and "stop" are the actual commands, so the user can activate them with "/mod start" or "/mod stop", assuming the slash command for your addon is "/mod".

If the value in the key-value pair in <me.myconsole> is a function, like the stop command in the example, that function is run. If it is a string, the function in that module with the same name is run, e.g. <me.startnewprocess> for the "start" command of the above example. This is because <me.startnewprocess> might not be defined when <me.myconsole> is read (if it is declared later on in the file).

The value of the function <startnewprocess> is only determined once, when the console is built, which could happen before <me.onload>, so it should only refer to static methods defined at file load time.


Additionally you can make command trees, e.g.

me.myconsole = 
{
	data = 
	{
		clear = "clearalldata",
		add = "adddatapoint",
	},
	debug = function() [...] end,
}

This defines the commands "/mod debug", "/mod data clear" and "/mod data add".

Any values after the definition are sent as arguments to the function. So if the user runs the command "/mod data add size 20", the console module would call <me.adddatapoint("size", "20")>.


----------------------------------------------------------------------------------------------
							Console User Help + Localisation
----------------------------------------------------------------------------------------------

Each command can be given a description that will be printed when the console is giving the user help. Put the values in your localisation file in the "console.help" section, so in "enUS.lua" it would be e.g.

console = 
{
	[other stuff],
	
	help = 
	{
		data = 
		{
			["#help"] = "Commands to change the data set.",
			clear = "Clears the data set.",
			add = "Adds a new point to the data set.",
		},
		debug = "Prints out debug information.",
	}
}

Here the special key "#help" indicates it is the help message for the parent table, which is the "data" command family.

The console class gives the user help when they type in an invalid command. Examples would be commands that don't exist, like "/mod start", or incomplete commands, like "/mod data". If the user types "/mod start", the console might print:

	There is no command '/mod start'
	/mod data - Commands to change the data set.
	/mod debug - Prints out debug information.

----------------------------------------------------------------------------------------------
						Automatic Command Abbreviation
----------------------------------------------------------------------------------------------

The console class allows the user to abbreviate commands as much as possible as long as they are still recognisable. For example, it would recognise "/mod data c" as "/mod data create", since the "create" command is the only one that begins with "c" in that family. Likewise "/mod data cr" or "/mod data cre" etc.

The "debug" and "data" commands both start with d, so the minimal command would be "/mod de" and "mod da". If the user typed on "/mod d", the console would print out a list of possible commands they meant.

Additionally, when printing out a list of commands, the console will highlight the minimal abbreviation, so for example in printing out "/mod data", the 'da' substring would be in blue, and the 'ta' would be in the normal colour.


----------------------------------------------------------------------------------------------
						Details on Loadup
----------------------------------------------------------------------------------------------

1) OnLoad - we register the addon's slash commands.
2) OnModuleLoad(module) - we add the module's commands.
3) OnLoadComplete - we colourise and add help info to commands.

Initially the .commandstring keys won't have abbreviation colouring added, this will be done after. They will still be defined though, this is needed for debugging errors.

The .help stuff isn't added till the table is all built too.
]]

me.commands = { }
--[[
me.commands =
{
	test = 
	{
		commandstring = "/mod |cffffff00t|rest",
		help = "Commands to Test stuff",
		module = "data",
		subcommands = 
		{
			gear = 
			{
				help = "test your gear",
				commandstring = "/mod |cffffff00t|rest |cffffff00t|rear",
				method = <function>,
				module = "data",
			},
		},
	}
}

i.e. every table has .commandstring and .help and a .module (first module to define it), then either .subcommands or .method. 
]]


--[[
----------------------------------------------------------------------------------------------
								Startup Methods
----------------------------------------------------------------------------------------------
]]

-- From Core.lua after OnLoad.
me.onload = function()

	-- put a .commandstring property in the command table root
	me.commands.commandstring = "|cffffff00" .. mod.global.slash.short

	--[[
	This is an overly fancy bit of code to register slash commands. The set of slash commands for the addon is defined in <mod.global.slash>, and is a table of key-value pairs; we are interested in the values. We iterate over this array and define new variables for each value. If the mod was called "Bob", we would create the variable "SLASH_Bob1" for the first slash command, etc.
	]]
	local numslash = 0
	
	for key, value in pairs(mod.global.slash) do
		numslash = numslash + 1
		setglobal(string.format("SLASH_%s%d", mod.global.addonname, numslash), value)
	end
		
	SlashCmdList[mod.global.addonname] = me.onconsolecommand
	
end

me.onmoduleload = function(module)

	-- get modules
	if type(module.myconsole) == "table" then
		me.mergecommands(module.name, me.commands, module.myconsole)
	end
	
end

--[[
me.onloadcomplete() - called by Loader.lua after all modules have loaded. This won't give rock solid support for adding console commands at runtime, since new commands won't get colourised or have help data added.
]]
me.onloadcomplete = function()
	
	-- now colourise the commands 
	me.colourisecommands(me.commands)
	
	-- now add help information
	me.addhelpdata(me.commands)
	
end

--[[
me.mergecommands(module, data, moduledata)

Adds all the commands defined in <module> to the global list. This will be called recursively for each subtable.

<module>		string; name of the module.
<data>		table; some subtable of <me.commands>, possibly the entire table.
<moduledata>table; the corresponding subtable of the <me.myconsole> defined in <module>.
]]
me.mergecommands = function(module, data, moduledata)
	
	local failed
	
	for key, value in pairs(moduledata) do
		
		failed = false
		
		-- first check the key is OK
		if data.subcommands and data.subcommands[key] then
			
			-- this key is already defined in moduledata. OK as long as both references are not leaf nodes.
			if data.subcommands[key].method then
				
				-- error! overdefining a current command.
				failed = true
				
				if mod.trace.check("warning", me, "setup") then
					mod.trace.printf("The command %s|r is being multiply defined. It is a leaf in |cffffff00%s|r, but defined in |cffffff00%s|r too; the latter will be rejected.", data.subcommands[key].commandstring, data.subcommands[key].module, module)
				end
			
			-- The original definition is a branch; this will be ok as long as the new definition is a branch too
			elseif type(value) ~= "table" then
				
				-- error! overdefining a branch with a leaf.
				failed = true
				
				if mod.trace.check("warning", me, "setup") then
					mod.trace.printf("The command %s|r is being multiply defined. It is a branch in |cffffff00%s|r, but defined in |cffffff00%s|r too; the latter will be rejected.", data.subcommands[key].commandstring, data.subcommands[key].module, module)
				end
				
			-- else: no conflict
			end
			
		-- This key hasn't been defined before. Add it
		else

			if data.subcommands == nil then
				data.subcommands = { }
			end

			data.subcommands[key] = 
			{
				commandstring = data.commandstring .. " " .. key,
				module = module,
			}
			
			-- add value for leaf nodes
			if type(value) == "string" then
				
				-- check it exists
				if type(mod[module][value]) ~= "function" then
					
					if mod.trace.check("warning", me, "setup") then
						mod.trace.printf("The function |cffffff00%s|r referenced by %s|r in |cffffff00%s|r does not exist.", key, data.subcommands[key].commandstring, module)
					end
					
				-- checks out. Add
				else
					data.subcommands[key].method = mod[module][value]
				end
				
			elseif type(value) == "function" then
				data.subcommands[key].method = value
			end
		end
		
		-- If this value was a table, we have to add it recursively
		if type(value) == "table" then
			me.mergecommands(module, data.subcommands[key], value)
		end
		
	end
	
end

--[[
me.colourisecommands(data)

Regenerates the <.commandstring> properties of <me.commands> and subtables, including abbreviation highlights. The method is called recursively on all child tables.

To work it out, we pick a subcommand. Then we check all other subcommands, and find the minimal substring match over all of them.
]]
me.colourisecommands = function(data)
	
	-- abort if there are no subcommands
	if data.subcommands == nil then
		return
	end
	
	local length, maxlength
	
	for key1, value1 in pairs(data.subcommands) do
		length = 1
		maxlength = string.len(key1)
		
		for key2, value2 in pairs(data.subcommands) do
			
			-- choose only distinct keys
			if key2 ~= key1 then
				
				for x = length, maxlength - 1 do
					if string.sub(key1, 1, x) == string.sub(key2, 1, x) then
						length = x + 1
					else
						break
					end
				end
			end
		end
		
		value1.commandstring = data.commandstring .. " |cff33ff88" .. string.sub(key1, 1, length) .. "|cffffff00" .. string.sub(key1, length + 1)
		
		-- recurse
		me.colourisecommands(value1)
	end
	
end

me.helpdataargs = { "console", "help", length = 2 }

--[[
me.addhelpdata(data)

Adds the <.help> properties to <me.commands> and subtables. This is somewhat tricky because the help text is localised, so it's stored inside <mod.string.data>. The format for commands and localisation is similar: the command "/mod x y z" would have help text <mod.string.get("console", "help", "x", "y", "z")>.

To generalise this process, we keep a list of the args to <mod.string.get> in the list <me.helpdataargs>. Then we unpack() them and send them to <mod.string.get> to get the right value.

When the command is not a leaf, i.e. "/mod x y" in the above example, add the special key "#help" at the end. So the help text for "/mod x y" is <mod.string.get("console", "help", "x", "y", "#help")>.
]]
me.addhelpdata = function(data)
	
	-- check for no subtables
	if data.subcommands == nil then
		return
	end
	
	local text 
	
	for key, value in pairs(data.subcommands) do
		
		-- tunnel down
		me.helpdataargs.length = me.helpdataargs.length + 1
		me.helpdataargs[me.helpdataargs.length] = key
		
		-- recurse
		me.addhelpdata(value)
		
		-- get text for this value
		if value.subcommands then

			me.helpdataargs[me.helpdataargs.length + 1] = "#help"
			text = mod.string.get(unpack(me.helpdataargs, 1, me.helpdataargs.length + 1))

		else
			text = mod.string.get(unpack(me.helpdataargs, 1, me.helpdataargs.length))		
		end
		
		value.help = text or "???"

		-- tunnel up
		me.helpdataargs.length = me.helpdataargs.length - 1
	end
	
end

--[[
----------------------------------------------------------------------------------------------
						Runtime: Processing a Console Command
----------------------------------------------------------------------------------------------
]]

--[[
me.onconsolecommand(message) - called when the user types a / command for our mod. The slash commands are defined in Global.lua.

We start with a string <message>, which is the bit after "/mod". We iteratively take out the next word (string with no spaces), which is put in the variable <nextarg>, while the rest of the string is put in <remain>.
]]
me.onconsolecommand = function(message)
	
	local remain, nextarg = message
	local commandsubtable = me.commands
	
	while remain do
		
		-- finish child node
		if commandsubtable.method then
			mod.printf(mod.string.get("console", "run"), commandsubtable.commandstring .. "|cffffffff " .. remain)
			commandsubtable.method(remain)
			return
		end
		
		-- otherwise: get next argument
		nextarg, remain = me.getnextarg(remain)
						
		-- 1) Check for command complete
		if nextarg == "" then
			
			-- print children
			me.printchildren(commandsubtable)
			return
			
		else
			-- check next arg vs children
			local matchlist = me.getchildmatches(commandsubtable, nextarg)
			
			if #matchlist == 0 then
				
				-- print error and children
				mod.printf(mod.string.get("console", "nocommand"), commandsubtable.commandstring .. " " .. nextarg)
				me.printchildren(commandsubtable)
				return
				
			elseif #matchlist > 1 then		
				
				-- print error and matchlist
				mod.print(mod.string.get("console", "ambiguous"))
				
				for key, value in pairs(matchlist) do
					mod.print(value.commandstring)
				end
				
				return
				
			else 
				-- <nextarg> is a valid child of the current node
				commandsubtable = matchlist[1]
				
				-- if this is just a method, run it
				if commandsubtable.method then

					mod.printf(mod.string.get("console", "run"), commandsubtable.commandstring .. "|cffffffff " .. (remain or ""))
					commandsubtable.method(remain)
					
					return

				elseif remain == nil then
					me.printchildren(commandsubtable)
			
				end
				
				-- otherwise, do another while loop
			end
			
		end
	end
	
end

--[[
This is a ' ' (space) iterator on the message string.

Returns: <nextarg, remain>
]]
me.getnextarg = function(remain)
	
	local start = string.find(remain, " ")
	
	if start == nil then
		return remain, nil
	
	else
		return string.sub(remain, 1, start - 1), string.sub(remain, start + 1)
	end
	
end

--[[
me.printchildren(commandtable)

Prints out all the child commands of this command.
]]
me.printchildren = function(commandtable)
	
	for key, value in pairs(commandtable.subcommands) do
		mod.print(value.commandstring .. "|r - " .. value.help)
	end
	
end

--[[
me.getchildmatches(commandtable, nextarg)

<commandtable> is a subtable of <me.commands>, representing a branch in the command tree. 
<nextarg> is a string, which we hope matches a child of <commandtable>.

Returns: a list of matches (candidate <commandtable> values), possible with 0 or 1 or more items.
]]
me.getchildmatches = function(commandtable, nextarg)

	local matchlist = { }

	for key, value in pairs(commandtable.subcommands) do
		
		-- "^" means only accept matches from the start
		if string.find(key, "^" .. nextarg) then
			table.insert(matchlist, value)
		end
	end
	
	return matchlist
	
end
