
-- module setup
local me = { name = "trace"}
local mod = thismod
mod[me.name] = me

--[[ 
Trace.lua. (2 Apr 07)

		This module provides the trace printing service, that is, a printout that assists with debugging, which you might not want most users to see. The module provides methods to determine which debug prints should be displayed based on the visibility settings.
		
		Since it is often computationally expensive to format a string for printing, it is desirable to have a method to query the trace module before the printout is computed. A debug print that never actually prints anything but that is constantly calculating the string to print can cause an unneccesary slowdown.
		Here is as example of using the trace module:
		
	if mod.trace.check("warning", me, "talents") then 
		mod.trace.print(string.format(<long stuff here>))
	end
		
		The <trace.check()> method returns <true> if the message should be printed with the current settings, and the <trace.print> method prints the message, as well as a header saying where the message came from (module and section).
		
		The 3 arguments to <trace.check> are <messagetype>, <module> and <section>. <messagetype> must be one of "error", "warning" or "info", and defines the importance of the message. "error" is the most important, so it is most likely to be printed out. <module> is a reference to the module that called <trace.check>. In internal code it will always be the value <me>. <section> is a string giving a vague description of where the error occurred. In the above example, it had something to do with "talents". 
		
		To determine whether a trace message should be printed, we first check the table <mod.global.trace>, which lists the default trace status. If (mod.global.trace.warning == true), then by default all "warning" messages will be printed. Then we check whether the module that called <trace.check> has any overriding settings.
		
		To make a trace setting override for a module, define a table <mytraces> in that module like this:
		
	me.mytraces = 
	{
		default = "warning",
		talents = "info",
	}
	
		The "default" key sets the default value for your module. Any other keys specify the 3rd argumeny to (trace.check) and its trace value. In this example, for that file everything with a level of "warning" or "error" would print due to the first line, and "info" messages about talents would also print, due to the second line.
]]

--[[
------------------------------------------------------------------------------------------
			Startup: Service Initialisation by \Framework\Loader.lua
------------------------------------------------------------------------------------------
]]

--[[
me.onmoduleload(module) is called by Loader.lua when the addon starts. It is called once for each module in the addon. The module is sent as an argument (the whole table).

We check the module for a subtable <mytraces>, and if it exists we implement the trace printing overrides as specified.
]]
me.onmoduleload = function(module)
	
	-- check whether this module has a <mytraces> table
	if type(module.mytraces) ~= "table" then
		return
	end
	
	local section, messagetype
	
	-- This module has <mytraces>. Process them
	for section, messagetype in pairs(module.mytraces) do
		
		if section == "default" then
			me.setprintstatus(module.name, nil, messagetype, true)
		else					
			me.setprintstatus(module.name, section, messagetype, true)
		end
	end
	
end

--[[ 
<me.override> keeps track of all modules that have overrided the default trace settings.

Suppose the following method calls were made:
	me.setprintstatus("boss", nil, "warning", true)
	me.setprintstatus("boss", "event", "info", true)
	
Then me.override would look like
me.override = 
{
	boss = 
	{
		warning = true
		error = true
		sections = 
		{
			event = 
			{
				info = true
				warning = true
				error = true
			}
		}
	}
}

See <me.setprintstatus> for more information
]]
me.override = {  }

--[[ 
me.setprintstatus(modulename, sectionname, messagetype, value)

Overrides the default print option for a specific trace print.

<modulename> 	string; name of the module overriding the trace settings.
<sectionname> 	string; same as <sectionname> to <me.check>, see comments below.
<messagetype> 	string; "info" or "warning" or "error".
<value> 			boolean; true to enable the print, false to disable it.

<sectionname> is an optional parameter. If it is <nil>, the override will apply to the whole module, i.e. any <sectionname>. For 
<messagetype> will automatically cascade. "error" is assumed to be more important than "warning", which is more important than "info". So if you turn "warning" off, it will turn "info off as well"; if you turn "info" on, "warning" and "error" will be turned on too.
]]
me.setprintstatus = function(modulename, sectionname, messagetype, value)

	-- check module exists
	if me.override[modulename] == nil then
		me.override[modulename] = { }
	end
	
	local printdata = me.override[modulename]
	
	-- is this for the whole module, or more specific?
	if sectionname then
		
		-- check whether any sections have been defined for this module
		if printdata.sections == nil then
			printdata.sections = { }
		end
		
		printdata = printdata.sections
		
		-- check whether this section has been defined in the sections list
		if printdata[sectionname] == nil then
			printdata[sectionname] = { }
		end
		
		printdata = printdata[sectionname]
	end
	
	-- set
	printdata[messagetype] = value
	
	-- cascade
	if value == true then
		if messagetype == "info" then
			printdata.warning = true
			messagetype = "warning"
		end
		
		if messagetype == "warning" then
			printdata.error = true
		end
	
	elseif value == false then
		if messagetype == "error" then
			printdata.warning = false
			messagetype = "warning"
		end
		
		if messagetype == "warning" then
			printdata.info = false
		end
	end

end

--[[ 
mod.trace.check(messagetype, module, sectionname)
Checks whether a debug print with the given properties should be printed.
Return: non-nil iff the message should be printed.
<messagetype> must be one of "error", "warning" or "info"
<module> should always be <me> in the calling context; i.e. a table with <.name> property.
<sectionname> is a description of the feature in <module> that the message concerns.
]]
me.check = function(messagetype, module, sectionname)
	
	-- start with default print value
	local value = mod.global.trace[messagetype]
	me.printargs.overridelevel = "default"
	
	-- convert module reference to name
	local modulename = module.name or "???"
	
	-- are there any overrides for that module?
	local printdata = me.override[modulename]
	
	if printdata then
		if printdata[messagetype] then
			value = printdata[messagetype]
			me.printargs.overridelevel = "module"
		end
		
		-- are there overrides for this section of the module?		
		if printdata.sections and printdata.sections[sectionname] and (printdata.sections[sectionname][messagetype] ~= nil) then
			value = printdata.sections[sectionname][messagetype]
			me.printargs.overridelevel = "section"
		end
	end
	
	-- pre-return: load arguments for me.printtrace
	me.printargs.modulename = modulename
	me.printargs.sectionname = sectionname
	me.printargs.messagetype = messagetype
	
	-- return: nil or non-nil
	if value == true then
		return true
	end
	
end

-- This stores the options supplied to <me.checktrace>, which will slightly affect the printout.
me.printargs = 
{
	messagetype = "",
	modulename = "",
	sectionname = "",
	overridelevel = "",
}


--[[
This is a synonym for me.print(mod.format())
]]
me.printf = function(message, ...)
	
	me.print(mod.format(message, ...))
	
end

--[[
mod.trace.print(message)
Prints a message that has been OK'd by <me.check>.
]]
me.print = function(message)

	-- setup the colour. Error = red, warning = yellow, info = blue. Lightish colours.
	local header = ""
	
	if me.printargs.messagetype == "info" then
		header = "|cff8888ff"
	
	elseif me.printargs.messagetype == "warning" then
		header = "|cffffff44"
	
	elseif me.printargs.messagetype == "error" then
		header = "|cffff8888"
	end
	
	--	convert |r in the message to the header colouring
	message = string.gsub(message, "|r", header)
	
	-- add the header
	message = string.format("%s<%s.%s> %s", header, me.printargs.modulename, me.printargs.sectionname, message)
		
	-- print!
	mod.print(message)
	
end