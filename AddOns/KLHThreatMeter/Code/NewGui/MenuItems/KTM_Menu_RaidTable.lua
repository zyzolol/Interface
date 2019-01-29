
-- module setup
local me = { name = "menuraidtable"}
local mod = thismod
mod[me.name] = me

--[[
Menu\Menu_RaidTable.lua

A first level section in the help menu for configuring the raid table. Currently we have these subtopics:
	Colour Scheme (colour of frames and fonts)
	Layout (position and movement of the frame)
	Rows and Columns (class filters and columns)
	
The HelpMenu heirarchy looks like this:

top
	raidtable
		raidtable-colour
		raidtable-layout
		raidtable-filter
		raidtable-misc
]]

-- Create all the frames and add them to the help menu
me.onload = function()

	-- raidtable
	me.deferredmainframe = mod.defer.createnew(me.createmainframe)
	mod.helpmenu.registersection("raidtable", nil, mod.string.get("menu", "raidtable", "description"), me.deferredmainframe)

	-- raidtable-colour
	me.deferredcolourframe = mod.defer.createnew(me.createcolourframe)
	mod.helpmenu.registersection("raidtable-colour", "raidtable", mod.string.get("menu", "raidtable", "colour", "description"), me.deferredcolourframe)
	
	-- raidtable-layout
	me.deferredlayoutframe = mod.defer.createnew(me.createlayoutframe)
	mod.helpmenu.registersection("raidtable-layout", "raidtable", mod.string.get("menu", "raidtable", "layout", "description"), me.deferredlayoutframe)
	
	-- raidtable-filter
	me.deferredfilterframe = mod.defer.createnew(me.createfilterframe)
	mod.helpmenu.registersection("raidtable-filter", "raidtable", mod.string.get("menu", "raidtable", "filter", "description"), me.deferredfilterframe)

	-- raidtable-misc
	me.deferredmiscframe = mod.defer.createnew(me.createmiscframe)
	mod.helpmenu.registersection("raidtable-misc", "raidtable", mod.string.get("menu", "raidtable", "misc", "description"), me.deferredmiscframe)
		
end

-- If you want to copy / paste, start from the Layout frame bit. It has better variables
me.createmainframe = function()
	
	local frame, element, offset
	offset = mod.helpmenu.textinset
	
	-- create the top frame
	frame = mod.gui.createframe(mod.frame, mod.helpmenu.defaultwidth, 300, mod.helpmenu.background.frame, "HIGH")
	me.mainframe = frame
	
	-- textbox
	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.label = element
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "raidtable", "text"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	offset = offset + element:GetHeight()

--------------------------------------------------------------------------------
--	"Show RaidTable" Button
--------------------------------------------------------------------------------

	offset = offset + 20
	
	element = mod.gui.createbutton(frame, 200, 40, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	frame.button = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetText(mod.string.get("menu", "raidtable", "button"))
	
	element:SetScript("OnClick", 
		function()
			mod.raidtable.instances[1].gui:Show()
		end
	)

	offset = offset + element:GetHeight()
	
--------------------------------------------------------------------------------
		
	-- Now size the frame to the string
	frame:SetHeight(mod.helpmenu.textinset + offset)
	
	return me.mainframe
	
end

--[[
----------------------------------------------------------------------------------------------
							Topic: Colour Scheme
----------------------------------------------------------------------------------------------
]]

me.colourframesetup = function()
	
	-- setup slider value
	me.colourframe.slider:SetValue(mod.raidtable.save[1].alpha * 100)
	
end

-- this is the "Colour Scheme" entry
me.createcolourframe = function()
	
	me.colourframe = mod.gui.createframe(mod.frame, mod.helpmenu.defaultwidth, 300, mod.helpmenu.background.frame, "MEDIUM")
	me.colourframe.setup = me.colourframesetup
	
	local offset = mod.helpmenu.textinset
	
------------------------------------------------------------------------------------
-- Text 1 (Border Colour)
------------------------------------------------------------------------------------

	local text1 = mod.gui.createfontstring(me.colourframe, mod.helpmenu.fontsize)
	text1:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	text1:SetNonSpaceWrap(true)
	text1:SetJustifyH("LEFT")
	text1:SetJustifyV("TOP")
	
	text1:SetText(mod.string.get("menu", "raidtable", "colour", "text1"))
	text1:SetWidth(me.colourframe:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + text1:GetHeight()
	me.colourframe.text1 = text1

------------------------------------------------------------------------------------
-- Button 1 (Border Colour)
------------------------------------------------------------------------------------

	offset = offset + 5
	
	local button1 = mod.gui.createbutton(me.colourframe, 200, 40, mod.helpmenu.background.button, mod.helpmenu.fontsize)

	button1:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	button1:SetText(mod.string.get("menu", "raidtable", "colour", "button1"))
	
	button1:SetScript("OnClick", me.colourframebutton1click)
	
	-- increment offset + add to frame
	offset = offset + button1:GetHeight()
	me.colourframe.button1 = button1
	
	
------------------------------------------------------------------------------------
-- Text 2 (Major Text Colour)
------------------------------------------------------------------------------------

	offset = offset + 20
	
	local text2 = mod.gui.createfontstring(me.colourframe, mod.helpmenu.fontsize)
	text2:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	text2:SetNonSpaceWrap(true)
	text2:SetJustifyH("LEFT")
	text2:SetJustifyV("TOP")
	
	text2:SetText(mod.string.get("menu", "raidtable", "colour", "text2"))
	text2:SetWidth(me.colourframe:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + text2:GetHeight()
	me.colourframe.text2 = text2

------------------------------------------------------------------------------------
-- Button 2 (Major Text Colour)
------------------------------------------------------------------------------------

	offset = offset + 5
	
	local button2 = mod.gui.createbutton(me.colourframe, 200, 40, mod.helpmenu.background.button, mod.helpmenu.fontsize)

	button2:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	button2:SetText(mod.string.get("menu", "raidtable", "colour", "button2"))
	
	button2:SetScript("OnClick", me.colourframebutton2click)
	
	-- increment offset + add to frame
	offset = offset + button2:GetHeight()
	me.colourframe.button2 = button2

------------------------------------------------------------------------------------
-- Text 3 (Minor Text Colour)
------------------------------------------------------------------------------------

	offset = offset + 20
	
	local text3 = mod.gui.createfontstring(me.colourframe, mod.helpmenu.fontsize)
	text3:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	text3:SetNonSpaceWrap(true)
	text3:SetJustifyH("LEFT")
	text3:SetJustifyV("TOP")
	
	text3:SetText(mod.string.get("menu", "raidtable", "colour", "text3"))
	text3:SetWidth(me.colourframe:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + text3:GetHeight()
	me.colourframe.text3 = text3

------------------------------------------------------------------------------------
-- Button 3 (Minor Text Colour)
------------------------------------------------------------------------------------

	offset = offset + 5
	
	local button3 = mod.gui.createbutton(me.colourframe, 200, 40, mod.helpmenu.background.button, mod.helpmenu.fontsize)

	button3:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	button3:SetText(mod.string.get("menu", "raidtable", "colour", "button3"))
	
	button3:SetScript("OnClick", me.colourframebutton3click)
	
	-- increment offset + add to frame
	offset = offset + button3:GetHeight()
	me.colourframe.button3 = button3

------------------------------------------------------------------------------------
-- Text 4 (Transparency)
------------------------------------------------------------------------------------
	offset = offset + 20
	
	local text4 = mod.gui.createfontstring(me.colourframe, mod.helpmenu.fontsize)
	text4:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	text4:SetNonSpaceWrap(true)
	text4:SetJustifyH("LEFT")
	text4:SetJustifyV("TOP")
	
	text4:SetText(mod.string.get("menu", "raidtable", "colour", "text4"))
	text4:SetWidth(me.colourframe:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + text4:GetHeight()
	me.colourframe.text4 = text4

------------------------------------------------------------------------------------
-- Slider (Transparency)
------------------------------------------------------------------------------------
	offset = offset + 10
	
	local frame = me.colourframe
	local	element = mod.gui.createslider(frame, 200, 20, mod.helpmenu.fontsize)
	frame.slider = element
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset - 10) -- slider is extra big so needs an extra 20 pixels. 
	
	element:SetMinMaxValues(10, 100)
	element:SetValueStep(5)
	element.name = "rows"
	
	element.text:SetText(mod.string.get("menu", "raidtable", "colour", "slider"))
	element.low:SetText("10")
	element.high:SetText("100")
	element.value:SetText(element:GetValue())
	
	element:SetScript("OnValueChanged", 
		function()
			this.value:SetText(this:GetValue())
			mod.raidtable.save[1].alpha = this:GetValue() / 100
			mod.raidtable.instances[1].gui:SetAlpha(mod.raidtable.save[1].alpha)
		end
	)

	-- for the slider we need a setup method:
	-- (see me.colourframesetup() above)
		
	offset = offset + element.realheight()

------------------------------------------------------------------------------------
-- finalise the frame:
	
	-- Now size the frame to the stringg
	me.colourframe:SetHeight(mod.helpmenu.textinset + offset)
		
	return me.colourframe
	
end

-- These are the Click Handlers for the 3 buttons.
me.colourframebutton1click = function()
	
	me.startcolourpick(mod.raidtable.save[1].colour, mod.raidtable.instances[1], mod.raidtable.setcolour)
	
end

me.colourframebutton2click = function()
	
	me.startcolourpick(mod.raidtable.save[1].textmajorcolour, mod.raidtable.instances[1], mod.raidtable.setmajortextcolour)
	
end

me.colourframebutton3click = function()
	
	me.startcolourpick(mod.raidtable.save[1].textminorcolour, mod.raidtable.instances[1], mod.raidtable.setminortextcolour)
	
end

--[[
------------------------------------------------------------------------------------------
						Wrapper for the ColorPicker Object
------------------------------------------------------------------------------------------

Call me.startcolourpick(colourdata, object, updatefunction). We'll do the rest.

]]

-- Data used by colour picking methods below
me.colour = 
{
	original =  
	{
		r = 1,
		g = 1,
		b = 1,
	},
	
	data = nil,
	object = nil,
	updatefunction = nil,
}

--[[
me.startcolourpick(colourdata, object, updatefunction)
	Opens the ColorPickerFrame and puts the user's choice into the specified data set.
<colourdata> 	table; with keys .r, .g, .b values between 0 and 1.
<object>			table; first argument to <updatefunction>
<updatefunction>	function; called every time the user picks a new colour, usually to redraw the object with the new colour.
]]
me.startcolourpick = function(colourdata, object, updatefunction)
	
	me.colour.data = colourdata
	me.colour.object = object
	me.colour.updatefunction = updatefunction
	
	-- value copy
	me.colour.original.r = colourdata.r
	me.colour.original.g = colourdata.g
	me.colour.original.b = colourdata.b
	
	ColorPickerFrame:Show()
	ColorPickerFrame:SetColorRGB(colourdata.r, colourdata.g, colourdata.b)
	
	ColorPickerFrame.func = me.colourpickfunction
	ColorPickerFrame.cancelFunc = me.colourpickabortfunction
		
end

--[[
This is a callback from whenever the user clicks on the ColorPicker palette or clicks the OK button.
]]
me.colourpickfunction = function()
	
	local r, g, b = ColorPickerFrame:GetColorRGB()
	
	me.colour.data.r = r
	me.colour.data.g = g
	me.colour.data.b = b
	
	me.colour.updatefunction(me.colour.object, me.colour.data.r, me.colour.data.g, me.colour.data.b)
	
end

--[[
This is a callback from whenever the user presses Escape or clicks the cancel button.
]]
me.colourpickabortfunction = function()
	
	me.colour.data.r = me.colour.original.r
	me.colour.data.g = me.colour.original.g
	me.colour.data.b = me.colour.original.b
	
	me.colour.updatefunction(me.colour.object, me.colour.data.r, me.colour.data.g, me.colour.data.b)
	
end

--[[
----------------------------------------------------------------------------------------------
							Topic: Layout
----------------------------------------------------------------------------------------------
]]

-- This will be whenever the frame is shown. We use it to make sure the option specifiers are set to their current values
me.layoutframesetup = function()
	
	-- setup slider value
	me.layoutframe.slider:SetValue(mod.raidtable.save[1].length)
	
	-- setup checkbox value
	me.layoutframe.checkbox:SetChecked(mod.raidtable.save.resize)
	
	-- setup slider2 value
	me.layoutframe.slider2:SetValue(math.floor(100 * (mod.raidtable.save[1].scale^2)))
	
end

me.createlayoutframe = function()
	
	me.layoutframe = mod.gui.createframe(mod.frame, mod.helpmenu.defaultwidth, 300, mod.helpmenu.background.frame, "HIGH")
	
	local frame = me.layoutframe
	local offset = mod.helpmenu.textinset
	local element
	
	frame.setup = me.layoutframesetup
	
------------------------------------------------------------------------------------
-- Text 1 (Anchor point)
------------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text1 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "raidtable", "layout", "text1"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()

------------------------------------------------------------------------------------
-- Buttons (Anchor points)
------------------------------------------------------------------------------------

-- BUTTON 1: "TOPLEFT"

	offset = offset + 25
	
	element = mod.gui.createbutton(frame, 150, 40, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	frame.button1 = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetText(mod.string.get("menu", "raidtable", "layout", "button1"))
	
	element:SetScript("OnClick", me.layoutframebutton1click)
	
	-- (no offset here - same row)
	
-- BUTTON 2: "TOPRIGHT"

	element = mod.gui.createbutton(frame, 150, 40, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	frame.button2 = element
	
	element:SetPoint("TOPRIGHT", -mod.helpmenu.textinset, -offset)
	element:SetText(mod.string.get("menu", "raidtable", "layout", "button2"))
	
	element:SetScript("OnClick", me.layoutframebutton2click)
	
	-- increment offset
	offset = offset + element:GetHeight()	

-- BUTTON 3: "BOTTOMLEFT"

	offset = offset + 10
	
	element = mod.gui.createbutton(frame, 150, 40, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	frame.button3 = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetText(mod.string.get("menu", "raidtable", "layout", "button3"))
	
	element:SetScript("OnClick", me.layoutframebutton3click)
	
	-- (no offset here - same row)
	
-- BUTTON 4: "BOTTOMRIGHT"

	element = mod.gui.createbutton(frame, 150, 40, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	frame.button4 = element
	
	element:SetPoint("TOPRIGHT", -mod.helpmenu.textinset, -offset)
	element:SetText(mod.string.get("menu", "raidtable", "layout", "button4"))
	
	element:SetScript("OnClick", me.layoutframebutton4click)
	
	-- increment offset
	offset = offset + element:GetHeight()


------------------------------------------------------------------------------------
-- Text 2: maximum rows
------------------------------------------------------------------------------------

	offset = offset + 30
	
	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text2 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "raidtable", "layout", "text2"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()
	
------------------------------------------------------------------------------------
-- Slider: maximum rows
------------------------------------------------------------------------------------

	offset = offset + 10

	element = mod.gui.createslider(frame, 200, 20, mod.helpmenu.fontsize)
	frame.slider = element
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset - 10) -- slider is extra big so needs an extra 20 pixels. 
	
	element:SetMinMaxValues(1, 40)
	element:SetValueStep(1)
	element.name = "rows"
	
	element.text:SetText(mod.string.get("menu", "raidtable", "layout", "slider"))
	element.low:SetText("1")
	element.high:SetText("40")
	element.value:SetText(element:GetValue())
	
	element:SetScript("OnValueChanged", 
		function()
			this.value:SetText(this:GetValue())
			mod.raidtable.save[1].length = this:GetValue()
			mod.raidtable.updateview()
		end
	)

	-- for the slider we need a setup method:
	-- (see me.layoutframesetup() above)
		
	offset = offset + element.realheight()

------------------------------------------------------------------------------------
-- Text 3: fixed frame size
------------------------------------------------------------------------------------

	offset = offset + 25
	
	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text3 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "raidtable", "layout", "text3"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()

------------------------------------------------------------------------------------
-- Checkbox: Fixed Frame Size
------------------------------------------------------------------------------------
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.checkbox = element
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset) 
		
	element.text:SetText(mod.string.get("menu", "raidtable", "layout", "checkbox"))

	-- add an OnClicked handler. does it give the value preclick or postclick?!
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.resize = (me.layoutframe.checkbox:GetChecked() == 1)
			mod.raidtable.updateview()
		end
	)
	
	offset = offset + 30

------------------------------------------------------------------------------------
-- Text 4: scale
------------------------------------------------------------------------------------

	offset = offset + 10
	
	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text4 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "raidtable", "layout", "text4"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()
	
------------------------------------------------------------------------------------
-- Slider: scale
------------------------------------------------------------------------------------

	offset = offset + 10

	element = mod.gui.createslider(frame, 200, 20, mod.helpmenu.fontsize)
	frame.slider2 = element
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset - 10) -- slider is extra big so needs an extra 20 pixels. 
	
	element:SetMinMaxValues(40, 130)
	element:SetValueStep(5)
	element.name = "rows"
	
	element.text:SetText(mod.string.get("menu", "raidtable", "layout", "slider2"))
	element.low:SetText("40%")
	element.high:SetText("130%")
	element.value:SetText(element:GetValue())
	
	element:SetScript("OnValueChanged", 
		function()
			this.value:SetText(this:GetValue())
			
			local value = this:GetValue()
			local realvalue = math.sqrt(value / 100)
			local oldscale = mod.raidtable.save[1].scale
			
			mod.raidtable.instances[1].gui:SetScale(realvalue)
			mod.raidtable.save[1].scale = realvalue
			
			if oldscale ~= realvalue then
				mod.raidtable.instances[1].gui.header:ClearAllPoints()
				mod.raidtable.instances[1].gui.header:SetPoint(mod.raidtable.save[1].position.anchor, nil, mod.raidtable.save[1].position.anchor, mod.raidtable.save[1].position.x * oldscale / realvalue, mod.raidtable.save[1].position.y * oldscale / realvalue)
				
				mod.raidtable.save[1].position.x = mod.raidtable.save[1].position.x * oldscale / realvalue
				mod.raidtable.save[1].position.y = mod.raidtable.save[1].position.y * oldscale / realvalue
			end
		end
	)

	-- for the slider we need a setup method:
	-- (see me.layoutframesetup() above)
		
	offset = offset + element.realheight()

------------------------------------------------------------------------------------
-- finalise the frame:
	
	-- Now size the frame to the stringg
	frame:SetHeight(mod.helpmenu.textinset + offset)
		
	return frame
	
end

-- These are the button click handlers for the layout buttons
me.layoutframebutton1click = function()
	
	mod.raidtable.save[1].anchor = "topleft"
	mod.raidtable.instances[1]:reanchortable()
	
end

me.layoutframebutton2click = function()
	
	mod.raidtable.save[1].anchor = "topright"
	mod.raidtable.instances[1]:reanchortable()
	
end

me.layoutframebutton3click = function()
	
	mod.raidtable.save[1].anchor = "bottomleft"
	mod.raidtable.instances[1]:reanchortable()
	
end

me.layoutframebutton4click = function()
	
	mod.raidtable.save[1].anchor = "bottomright"
	mod.raidtable.instances[1]:reanchortable()
	
end

--[[
------------------------------------------------------------------------------------------------
							Filter Frame: Rows and Columns
------------------------------------------------------------------------------------------------
]]

me.filterframesetup = function()
	
	-- initialise class checkboxes
	for class, _ in pairs(mod.string.data.enUS.class) do
		me.filterframe.checkbox[class]:SetChecked(mod.raidtable.save[1].class[class])
	end
	
	-- initialise row checkboxes
	me.filterframe.threat:SetChecked(mod.raidtable.save.columns.threat)
	me.filterframe.percent:SetChecked(mod.raidtable.save.columns.percent)
	me.filterframe.persecond:SetChecked(mod.raidtable.save.columns.persecond)
	
	-- aggrobar checkboxes
	me.filterframe.aggrogain:SetChecked(mod.raidtable.save.aggrogain)
	me.filterframe.tankregain:SetChecked(mod.raidtable.save.tankregain)
	
end

me.createfilterframe = function()
	
	me.filterframe = mod.gui.createframe(mod.frame, mod.helpmenu.defaultwidth, 300, mod.helpmenu.background.frame, "HIGH")
	
	local frame = me.filterframe
	local offset = mod.helpmenu.textinset
	local element
	
	frame.setup = me.filterframesetup
	
------------------------------------------------------------------------------------
-- Text 1 (classes)
------------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text1 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "raidtable", "filter", "text1"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()

------------------------------------------------------------------------------------
-- 9 Checkboxes, one for each class. 2 per row.
------------------------------------------------------------------------------------

	local colour
	local x = 0
	frame.checkbox = { }
	
	for class, _ in pairs(mod.string.data.enUS.class) do
		x = x + 1

		element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
		frame.checkbox[class] = element
		element.class = class
		
		if x == 2 * math.floor(x / 2) then
			element:SetPoint("TOPLEFT", mod.helpmenu.textinset + 200, -offset)
		else
			element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset) 
		end
		
		element.text:SetText(mod.string.get("class", class))
		
		-- colour
		colour = RAID_CLASS_COLORS[string.upper(class)]
		element.text:SetTextColor(colour.r, colour.g, colour.b)
		
		-- add an OnClicked handler. does it give the value preclick or postclick?!
		element:SetScript("OnClick", 
			function() 
				mod.raidtable.save[1].class[this.class] = (me.filterframe.checkbox[this.class]:GetChecked() == 1) 
			end
		)
	
		if x == 2 * math.floor(x / 2) then
			offset = offset + 30
		end
	end
	
	-- 9 classes so need an extra one at the end
	offset = offset + 30

------------------------------------------------------------------------------------
-- Text 2 (columns)
------------------------------------------------------------------------------------

	-- section break
	offset = offset + 20

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text2 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "raidtable", "filter", "text2"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()
	
------------------------------------------------------------------------------------
-- Checkboxes for threat, percent, per second
------------------------------------------------------------------------------------
	
-- threat checkbox
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.threat = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element.text:SetText(mod.string.get("menu", "raidtable", "filter", "threat"))
	
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.columns.threat = (me.filterframe.threat:GetChecked() == 1)
			mod.raidtable.instances[1]:redosubtablelayout()
		end
	)
	
	offset = offset + 30
	
-- percent checkbox
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.percent = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element.text:SetText(string.format(mod.string.get("menu", "raidtable", "filter", "percent"), mod.string.get("raidtable", "column", "percent")))
	
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.columns.percent = (me.filterframe.percent:GetChecked() == 1)
			mod.raidtable.instances[1]:redosubtablelayout()
		end
	)
	
	offset = offset + 30
	
-- persecond checkbox
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.persecond = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element.text:SetText(string.format(mod.string.get("menu", "raidtable", "filter", "persecond"), mod.string.get("raidtable", "column", "persecond")))
	
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.columns.persecond = (me.filterframe.persecond:GetChecked() == 1) 
			mod.raidtable.instances[1]:redosubtablelayout()
		end
	)
	
	offset = offset + 30	


------------------------------------------------------------------------------------
-- Checkboxes for aggro gain
------------------------------------------------------------------------------------
	
	-- section break
	offset = offset + 20

-- text explaining stuff
	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text3 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetJustifyH("LEFT")
	
	element:SetText(string.format(mod.string.get("menu", "raidtable", "filter", "text3"), mod.string.get("misc", "aggrogain"), mod.string.get("misc", "tankregain")))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()
			
-- aggro gain checkbox
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.aggrogain = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element.text:SetText(string.format(mod.string.get("menu", "raidtable", "filter", "aggrogain"), mod.string.get("misc", "aggrogain")))
	
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.aggrogain = (me.filterframe.aggrogain:GetChecked() == 1)
		end
	)
	
	offset = offset + 30

-- tank regain checkbox
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.tankregain = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element.text:SetText(string.format(mod.string.get("menu", "raidtable", "filter", "tankregain"), mod.string.get("misc", "tankregain")))
	
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.tankregain = (me.filterframe.tankregain:GetChecked() == 1)
		end
	)
	
	offset = offset + 30


------------------------------------------------------------------------------------	
	-- Now size the frame to the string
	frame:SetHeight(mod.helpmenu.textinset + offset)
		
	return frame
	
end 

--[[
------------------------------------------------------------------------------------------------
							Miscenalleous Frame: Dragging, Locking
------------------------------------------------------------------------------------------------
]]

me.miscframesetup = function()
		
	-- initialise autohide checkboxes
	me.miscframe.leavegroup:SetChecked(mod.raidtable.save.autohide.leavegroup)
	me.miscframe.joinparty:SetChecked(mod.raidtable.save.autohide.joinparty)
	me.miscframe.joinraid:SetChecked(mod.raidtable.save.autohide.joinraid)
	
	-- initialise lockwindow checkbox
	me.miscframe.lockwindow:SetChecked(mod.raidtable.save.lockwindow)
	
end

me.createmiscframe = function()
	
	me.miscframe = mod.gui.createframe(mod.frame, mod.helpmenu.defaultwidth, 300, mod.helpmenu.background.frame, "HIGH")
	
	local frame = me.miscframe
	local offset = mod.helpmenu.textinset
	local element
	
	frame.setup = me.miscframesetup
	
------------------------------------------------------------------------------------
-- Text 1 (autohide)
------------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text1 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "raidtable", "misc", "text1"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()

------------------------------------------------------------------------------------
-- 3 Checkboxes, for different options
------------------------------------------------------------------------------------

	-- 1) Hide on leaving a group
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.leavegroup = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset) 
	element.text:SetText(mod.string.get("menu", "raidtable", "misc", "leavegroup"))
		
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.autohide.leavegroup = (me.miscframe.leavegroup:GetChecked() == 1) 
		end
	)

	offset = offset + 30
	
	-- 2) Show on joining a party
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.joinparty = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset) 
	element.text:SetText(mod.string.get("menu", "raidtable", "misc", "joinparty"))
		
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.autohide.joinparty = (me.miscframe.joinparty:GetChecked() == 1) 
		end
	)

	offset = offset + 30

	-- 3) Show on joining a raid
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.joinraid = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset) 
	element.text:SetText(mod.string.get("menu", "raidtable", "misc", "joinraid"))
		
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.autohide.joinraid = (me.miscframe.joinraid:GetChecked() == 1) 
		end
	)

	offset = offset + 30

------------------------------------------------------------------------------------
-- Text 2 - Lock window
------------------------------------------------------------------------------------

	-- section break
	offset = offset + 20

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text2 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "raidtable", "misc", "text2"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()
	
------------------------------------------------------------------------------------
-- Checkbox for lockwindow
------------------------------------------------------------------------------------
	
	element = mod.gui.createcheckbox(frame, 30, 30, mod.helpmenu.fontsize)
	frame.lockwindow = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element.text:SetText(mod.string.get("menu", "raidtable", "misc", "lockwindow"))
	
	element:SetScript("OnClick", 
		function() 
			mod.raidtable.save.lockwindow = (me.miscframe.lockwindow:GetChecked() == 1)
		end
	)
	
	offset = offset + 30

------------------------------------------------------------------------------------	
	-- Now size the frame to the string
	frame:SetHeight(mod.helpmenu.textinset + offset)
		
	return frame
	
end 