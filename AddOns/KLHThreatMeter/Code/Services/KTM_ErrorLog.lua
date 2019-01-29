
local me = { name = "error"}
local mod = thismod
mod[me.name] = me

--[[
ErrorLog.lua

The idea is to handle manageable errors inside the mod, and not have them propogated to big red error boxes. Therefore if one module has an error onupdate, the user won't be spammed by an error box, and the rest of the mod will still function.

The errors we can handle are anything that occurs inside normal module's <onevent>, <onupdate>, <onparse> and <onnetmessage> handlers, which is pretty much everything. Errors from command line handlers, in Core.lua or in this file, or from clicking buttons or other form elements aren't handled.

Since we are suppressing the normal error handler, we need to inform the user that something has happened. We have our own message box-like frame, and it will pop up on the first error. After that it won't pop up for an error of the same type. If another different error occurs, it will pop up again, but never after that.
]]

-- Called by Core.lua at startup
me.onload = function()
	
	me.createerrorframe()
		
end

--[[
me.data = { <error1>, <error2>, ... }

<error> = 
{
	module = string, name of a module
	process = "onupdate" or "onevent" or "onparse" or "onnetmessage"
	extradata = (string) printout of args, event, onparse arguments etc
	stacktrace = (string), output of debugstack()
	message = (string) original error message, i.e. contents of normal error box (i think).
	time = (string) output of date() at time of first occurrence.
}
]]
me.data = { }

-- <me.knownerrors> is a table of <.message> properties of <error>s. If we've seen a message <x> before, then me.knownerrors[x] == true.
me.knownerrors = { }

-- constructor for the window
me.createerrorframe = function()
	
	me.frame = mod.gui.createframe(mod.frame, 400, 150, mod.gui.backdropcolor)
	me.frame:SetPoint("CENTER", UIParent, "CENTER")
	me.frame:Hide()
	
	local offset = mod.helpmenu.textinset
	
	-- Top line
	local element = mod.gui.createfontstring(me.frame, 18, true)
	me.frame.header = element
	
	element:SetJustifyH("LEFT")
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetWidth(me.frame:GetWidth() - 2 * mod.helpmenu.textinset)
	element:SetText(string.format(mod.string.get("errorbox", "header"), mod.global.addonname))
	
	element:SetTextColor(1.0, 0.5, 0.5)
	
	offset = offset + element:GetHeight()
	
	-- Details
	offset = offset + 10
	
	element = mod.gui.createfontstring(me.frame, 15, true)
	me.frame.text = element
	
	element:SetJustifyH("LEFT")
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetWidth(me.frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- up to here
	element:SetText(mod.string.get("errorbox", "header"), mod.global.name)
	
	offset = offset + element:GetHeight()
	
	-- Close Button
	offset = offset + 10
	
	element = mod.gui.createbutton(me.frame, 150, 40, mod.helpmenu.background.button, 15)
	me.frame.button = element
	
	element:SetPoint("BOTTOMLEFT", mod.helpmenu.textinset, mod.helpmenu.textinset)
	element:SetText(mod.string.get("raidtable", "tooltip", "close"))
	
	offset = offset + element:GetHeight()
	
	-- click event
	element:SetScript("OnClick", 
		function()
			me.frame:Hide()
		end
	)
	
	-- finalise
	me.frame:SetHeight(mod.helpmenu.textinset * 2 + offset)
	
end

--[[
me.extradataproviders

This is a collection of functions that gather important extra data for an error log. The extra data depends on the process where the error occurred. If it was an OnEvent handler, we want to know what <event> was, as well as <arg1>, etc if they are defined.

The keys in the table are the values of <error.process>, and the values are functions that take an unknown number of arguments. They will be passed any extra arguments sent to the <me.reporterror> function after the normal ones.
]]
me.extradataproviders = 
{
	-- OnEvent: extra data is the event and non-nil arg1, arg2, etc
	onevent = function(...)
		
		local extradata = event .. " { "
		local data
		
		for x = 1, 19 do
			data = getglobal("arg" .. x)
			
			if data then
				extradata = extradata  .. data .. ", "
			else
				break
			end
		end
		
		extradata = extradata .. "}"
		
		return extradata
	end,
	
	-- OnParse: extra data is the identifier and any arguments, also arg1
	onparse = function(...)
		
		local extradata = select(1, ...) .. " - { "
		local data
		
		for x = 2, select("#", ...) do
			data = select(x, ...)
			
			extradata = extradata .. tostring(data) .. ", "
		end
		
		extradata = extradata .. "} - " .. tostring(arg1)
		
		return extradata
	end,
	
	-- OnNetMessage: extra data is the command and any data (NOT Author)
	onnetmessage = function(...)
		
		local extradata = select(1, ...)
		
		local data = select(2, ...)
		
		if data then
			extradata = extradata .. " - " .. data
		end
		
		return extradata
		
	end
}

me.module = ""			-- last <module> to <me.protectedcall>
me.process = ""		-- last <process> to <me.protectedcall>
me.method = nil		-- last <method> to <me.protectedcalled>
me.arguments = { }	-- last ... to <me.protectedcall>

me.stacktrace = ""	-- last stacktrace of a new error
me.message = ""		-- last unique error message
me.newerror = false	-- whether the last <me.protectedcall> resulted in a new error

--[[
mod.error.protectedcall(module, process, method, [ arg1, arg2, ... ])

Calls a function wrapped in a private error handler, which will report errors to the error log.

<module>		string; name of the calling module
<process>	string; action that is occuring, e.g. "onparse", "onupdate", "onevent"
<method>		function; the actual function to call. May be <mod[module][process]>, but doesn't have to.
...			any; optional arguments that will be passed to <method>

Returns: 	<success>, [ <value1>, <value2>, ... ]
<success>	this is the return value of the inbuilt <pcall> function. If it is true, there was no error.
<value1>, etc are the return value of the function <method>.
]]
me.protectedcall = function(module, process, method, ...)
	
	-- load variables
	me.module = module
	me.process = process
	me.method = method
	me.newerror = false
	
	-- load arguments
	me.arguments.length = select("#", ...)
	
	for x = 1, me.arguments.length do
		me.arguments[x] = select(x, ...)
	end
	
	-- this is to stop the tail call eating up the stack
	do
		
		-- run
		return xpcall(me.argumentloader, me.errorhandler)
	
	end
	
	return
end

--[[
me.argumentloader is a wrapper to <xpcall> to support arguments to the function <me.method>. 
]]
me.argumentloader = function()
	
	-- this is to stop the tail call eating up the stack
	do
	
		return me.method(unpack(me.arguments, 1, me.arguments.length))
	
	end
	
	return
end

--[[
me.errorhandler will be called by <xpcall> when an error occurs inside <me.argumentloader>

<message>	string; original error message, e.g. "SomeFile.lua - Attempt to call nil value." or whatever.
]]
me.errorhandler = function(message)
	
	-- note last error message
	me.message = message
	
	-- don't do anything if we've seen this error before
	if me.knownerrors[message] then
		return
	end
	
	-- otherwise, record the stack trace and other notes
	me.stacktrace = debugstack()
	me.deepstack = me.stacktrace
	
	-- trim the stacktrace a bit
	local x = string.find(me.stacktrace, "xpcall")
	if x then
		me.stacktrace = string.sub(me.stacktrace, 1, x)
	end
	
	me.knownerrors[message] = true
	
	-- signal that this is a new error
	me.newerror = true
	
end

--[[
mod.error.reporterror(...)

Sends extra data to the error log after <me.protectedcall> has caused an error.

...		extra data identifying arguments to <process> or other important notes 
]]
me.reporterror = function(...)
		
	-- ignore duplicate errors
	if me.newerror == false then
		return
	end
	
	-- look for extra data
	local extradata
	
	if me.extradataproviders[me.process] then
		extradata = me.extradataproviders[me.process](...)
	end
	
	-- add it to data
	local newerror = 
	{
		module = me.module,
		process = me.process,
		extradata = extradata,
		message = me.message,
		stacktrace = me.stacktrace,
		deepstack = me.deepstack
	}
	
	table.insert(me.data, newerror)
	
	-- KLHAssembler interop
	if klhas then 
		klhas.debugger.notify(mod.global.addonname, me.deepstack, me.message, mod)
	end
	
	if #me.data == 1 then
		me.reportfirsterror()
	
	elseif #me.data == 2 then
		me.reportseconderror()
	end
		
end

--[[
me.reportfirsterror()

Brings up a dialogue saying that an error happened, and to check the error log.
]]
me.reportfirsterror = function()
	
	local thiserror = me.data[#me.data]
	
	local startheight = me.frame.text:GetHeight()
	
	me.frame.text:SetText(string.format(mod.string.get("errorbox", "body"), "|cffffff00" .. thiserror.module .. "." .. thiserror.process .. "|r") .. mod.string.get("errorbox", "first"))
	
	local heightchange = me.frame.text:GetHeight() - startheight
	
	me.frame:SetHeight(me.frame:GetHeight() + heightchange)
	me.frame:Show()
	
end

--[[
me.reportseconderror()

Brings up a dialogue saying that another new error has occurred, and that no more error messages will appear.
]]
me.reportseconderror = function()
	
	local thiserror = me.data[#me.data]
	
	local startheight = me.frame.text:GetHeight()
	
	me.frame.text:SetText(string.format(mod.string.get("errorbox", "body"), "|cffffff00" .. thiserror.module .. "." .. thiserror.process .. "|r") .. mod.string.get("errorbox", "second"))
	
	local heightchange = me.frame.text:GetHeight() - startheight
	
	me.frame:SetHeight(me.frame:GetHeight() + heightchange)
	me.frame:Show()
	
end