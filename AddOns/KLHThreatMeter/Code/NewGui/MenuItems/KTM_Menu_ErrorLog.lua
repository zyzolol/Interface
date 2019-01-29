
local me = { name = "menuerror"}
local mod = thismod
mod[me.name] = me

--[[
Menu_ErrorLog.lua

This is a section in the help menu called "Error Log". The addon attempts to catch most Lua errors and handle them internally instead of using the default ui error handler (ugly box with red writing). They are managed in ErrorLog.lua, but displayed by this class. 

The menu section describes the error logging process, shows the details of any errors, and has a copy text box so users can send informative details as bug reports.
]]

-- This is called by Core.lua at loadup. Calls the GUI constructor.
me.onload = function()
	
	-- add frame to the sections list
	me.deferredframe = mod.defer.createnew(me.createhelpmenusection)
	mod.helpmenu.registersection("errorlog", nil, mod.string.get("menu", "errorlog", "description"), me.deferredframe )
		
end

--[[
me.currenterrortostring()

Gives lots of details about the current error. Just for logs to me, so no localisation.
]]
me.currenterrortostring = function()
	
	local errordata = mod.error.data[me.currenterror]
	
	local text = "Version = " .. mod.global.release .. "." .. mod.global.revision
	
	text = text .. "\r\nLocalisation = " .. GetLocale()
	
	local _, class = UnitClass("player")
	
	text = text .. "\r\nClass = " .. string.lower(tostring(class))
	
	text = text .. "\r\nModule = " .. errordata.module
	
	text = text .. "\r\nProcess = " .. errordata.process
	
	text = text .. "\r\nExtraData = " .. tostring(errordata.extradata)
	
	text = text .. "\r\nMessage = " .. errordata.message
	
	text = text .. "\r\nStackTrace = " .. errordata.stacktrace
	
	return text
end

-- this is an index in mod.error.data, pointing to the error we are now displaying.
me.currenterror = 0

--[[
me.showerror(offset)

Called when the user clicks the "Show Next Error" or "Show Previous Error" buttons.
<offset> is -1 for previous, +1 for next.
]]
me.showerror = function(offset)
	
	local newindex = me.currenterror + offset
	
	-- ignore if there is no previous or next error
	if mod.error.data[newindex] == nil then
		return
	end
	
	me.currenterror = newindex
	
	me.showcurrenterror()
	
end

--[[
me.showcurrenterror()

Updates our form, displaying the contents of the currently selected error.  The main difficulty is working out how big the form will be after changing the error report. We just track the change in text3's height, and apply that to the frame after.
]]
me.showcurrenterror = function()
	
	-- text2 is "Now showing error %d of %d".
	me.frame.text2:SetText(string.format(mod.string.get("menu", "errorlog", "text2"), me.currenterror, #mod.error.data))
	
	local oldheight = me.frame.text3:GetHeight()
	
	local errordata = mod.error.data[me.currenterror]
	
	-- module
	local text = string.format(mod.string.get("menu", "errorlog", "format", "module"), errordata.module)
	
	-- process
	text = text .. "\n" .. string.format(mod.string.get("menu", "errorlog", "format", "process"), errordata.process)
	
	-- extra data
	text = text .. "\n" .. string.format(mod.string.get("menu", "errorlog", "format", "extradata"), tostring(errordata.extradata))
	
	-- error message
	text = text .. "\n" .. string.format(mod.string.get("menu", "errorlog", "format", "message"), errordata.message)
	
	-- write
	me.frame.text3:SetText(text)
	
	-- resize frame
	local heightdelta = me.frame.text3:GetHeight() - oldheight
	me.frame:SetHeight(me.frame:GetHeight() + heightdelta)
	
end

--[[
me.framesetup()

This method is called just before the frame is shown in the help menu (this is a feature from HelpMenu.lua). It works because me.framesetup == me.frame.setup .
]]
me.framesetup = function()
	
	-- if we are showing error 0 and a higher one exists, show it!
	if me.currenterror == 0 and #mod.error.data > 0 then
		me.showerror(1)
	end
	
	-- might need to update text2 as well ("showing error blah ...")
	me.frame.text2:SetText(string.format(mod.string.get("menu", "errorlog", "text2"), me.currenterror, #mod.error.data))
	
end

--[[
me.createhelpmenusection()

Constructor for our frame. Lots of boring stuff.
]]
me.createhelpmenusection = function()
	
	local frame = mod.gui.createframe(mod.frame, mod.helpmenu.defaultwidth, 300, mod.helpmenu.background.frame, "HIGH")
	me.frame = frame
	
	local offset = mod.helpmenu.textinset
	local element
	
	frame.setup = me.framesetup
	
------------------------------------------------------------------------------------
-- Text 1 (intro)
------------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text1 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetJustifyH("LEFT")
	
	element:SetText(string.format(mod.string.get("menu", "errorlog", "text1"), mod.global.webpage))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()


--------------------------------------------------------------------------------
--	"Copy To Clipboard" Button
--------------------------------------------------------------------------------

	offset = offset + 10
	
	element = mod.gui.createbutton(frame, 250, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	frame.button1 = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetText(mod.string.get("menu", "errorlog", "button1"))
	
	element:SetScript("OnClick", 
		function()
			mod.gui.showcopybox(mod.global.webpage)
		end
	)

	offset = offset + element:GetHeight()

	-- section gap
	offset = offset + 20

------------------------------------------------------------------------------------
-- Text 2 
------------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text2 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetJustifyH("LEFT")
	
	element:SetText(string.format(mod.string.get("menu", "errorlog", "text2"), 0, 0))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()


--------------------------------------------------------------------------------
--	"Previous" and "Next" buttons
--------------------------------------------------------------------------------

	offset = offset + 10

	-- previous button
	element = mod.gui.createbutton(frame, 200, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	frame.button2 = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetText(mod.string.get("menu", "errorlog", "button2"))
	
	element:SetScript("OnClick", 
		function()
			me.showerror(-1)
		end
	)

	-- next button
	element = mod.gui.createbutton(frame, 200, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	frame.button3 = element
	
	element:SetPoint("TOPRIGHT", -mod.helpmenu.textinset, -offset)
	element:SetText(mod.string.get("menu", "errorlog", "button3"))
	
	element:SetScript("OnClick", 
		function()
			me.showerror(1)
		end
	)

	offset = offset + element:GetHeight()

------------------------------------------------------------------------------------
-- Text 3 (description) 
------------------------------------------------------------------------------------
	
	offset = offset + 10

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text3 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetJustifyH("LEFT")
	
	element:SetText(" ")
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()

--------------------------------------------------------------------------------
--	"Copy To Clipboard" Button
--------------------------------------------------------------------------------

	offset = offset + 10
	
	element = mod.gui.createbutton(frame, 250, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	frame.button4 = element
	
	element:SetPoint("BOTTOMLEFT", mod.helpmenu.textinset, mod.helpmenu.textinset)
	element:SetText(mod.string.get("menu", "errorlog", "button4"))
	
	element:SetScript("OnClick", 
		function()
			if me.currenterror > 0 then
				mod.gui.showcopybox(me.currenterrortostring())
			end
		end
	)

	offset = offset + element:GetHeight()

------------------------------------------------------------------------------------	
	-- Now size the frame to the string
	frame:SetHeight(mod.helpmenu.textinset + offset)
		
	return frame
	
end
