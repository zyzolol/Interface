
-- module setup
local me = { name = "gui"}
local mod = thismod
mod[me.name] = me

--[[
Gui.lua

Factory for standard GUI Widgets

Usage:

mod.gui.tooltip(frame, topic, text)

mod.gui.showcopybox(text)

mod.gui.rawcreateframe(frametype, framename, parent, template)

mod.gui.createframe(parent, width, height, background, strata)

]]

--[[
------------------------------------------------------------------------
						Standard Constants
------------------------------------------------------------------------
]]

me.border = 4		-- This is the experimentally determined width of the borders created by me.framebackdrop
me.invisedge = 2.5	-- hack.

-- This is a standard frame border
me.framebackdrop = 
{
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
	tile = false,
	tileSize = 32,
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

-- this is a standard button border (
me.buttonbackdrop = 
{
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = false,
	tileSize = 32,
	edgeSize = 12,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

me.backdropcolor = 
{
	red = 0.2,
	green = 0.2,
	blue = 0.2,
	alpha = 1.0,
}

--[[
---------------------------------------------------------------------------
							Tooltip
---------------------------------------------------------------------------

Call mod.gui.tooltip() in your <OnEnter> handler, and in your <OnLeave> handler just have the code

	GameTooltip:Hide()
]]

--[[
mod.gui.tooltip(frame, topic, text)
	Creates a simple tooltip next to a frame.
<frame>	The frame to anchor to, or <this> if none is specified
<topic>	The first line of the tooltip
<text>	The rest of the tooltip
]]
me.tooltip = function(frame, topic, text)
	
	-- default <frame> is the object that raised the last event (probably <OnEnter>)
	if frame == nil then
		frame = this
	end
	
	-- The top line is the default game colour (yellow gold). The optional text is white.
	GameTooltip:SetOwner(frame, "ANCHOR_BOTTOM")
	GameTooltip:SetText(topic, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
	
	-- text is optional
	if text then
		GameTooltip:AddLine(text, 1, 1, 1, 1)
	end
	
	GameTooltip:Show()

end

--[[
---------------------------------------------------------------------------
							CopyBox
---------------------------------------------------------------------------

CopyBox is a dialogue with a text box with highlighted text, that prompts the user to copy the text to the windows Clipboard with Ctrl + C. It is useful for transfering information outside WoW.

The CopyBox frame is created the first time it is needed, it is the value <me.copybox>.

The frame uses the localised string <mod.string.get("copybox")>.
]]

--[[
mod.gui.showcopybox(text)

Shows a window with a textbox, telling the person to copy the text w/ ctrl + c.
]]
me.showcopybox = function(text)
	
	-- create the copy box when needed
	if me.copybox == nil then
		me.createcopybox()
	end
		
	me.copybox.text:SetText(text)
	me.copybox.text:HighlightText()
	me.copybox:Show()
	
end

--[[
me.createcopybox()

Since it might not ever be required, we only create it when it's first needed.
]]
me.createcopybox = function()
	
	local frame, element, offset
	
	frame = me.createframe(mod.frame, 400, 100, mod.helpmenu.background.frame, "DIALOG") 
	me.copybox = frame
	
	-- max out alpha
	frame:SetAlpha(1.0)
	
	frame:SetPoint("CENTER", UIParent, "CENTER")
	offset = mod.helpmenu.textinset
	
------------------------------------------------------------------------
-- Label
------------------------------------------------------------------------
	
	element = me.createfontstring(frame, 15)
	frame.label = element
	
	element:SetJustifyH("LEFT")
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetText(mod.string.get("copybox"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	offset = offset + element:GetHeight()
		
------------------------------------------------------------------------
-- TextBox
------------------------------------------------------------------------

	element = me.rawcreateframe("EditBox", nil, frame, "InputBoxTemplate")
	frame.text = element
	
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	element:SetHeight(50)
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:Show()
	
	offset = offset + element:GetHeight()
	
	element:SetScript("OnEscapePressed", 
		function()
			me.copybox:Hide()
		end
	)
	
------------------------------------------------------------------------
-- Button
------------------------------------------------------------------------

	element = me.createbutton(frame, 200, 40, mod.helpmenu.background.box, 15)
	frame.button = element
	
	element:SetText(mod.string.get("raidtable", "tooltip", "close"))
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	offset = offset + element:GetHeight()
	
	element:SetScript("OnClick", 
		function()
			me.copybox:Hide()
		end
	)

------------------------------------------------------------------------
-- finalise frame
------------------------------------------------------------------------
	frame:SetHeight(offset + mod.helpmenu.textinset)
	
end

--[[
------------------------------------------------------------------------
						Frame
------------------------------------------------------------------------
]]

--[[
Use this method throughout the mod in place of CreateFrame for KLHAssembler interop.
]]
mod.gui.rawcreateframe = function(frametype, framename, parent, template)
	
	local frame = CreateFrame(frametype, framename, parent, template)
	
	if klhas and klhas.destructor.ishostedassembly(mod) then
		klhas.destructor.notifyframe(mod, frame)
	end
	
	return frame
end

--[[
mod.gui.createframe(parent, width, height, background, strata)
	Creates a standard frame with a white border

<parent>		frame; if supplied, will set this to be the new frame's parent. Otherwise uses UIParent
<width>		number; the width of the frame, in pixels
<height>		number; the height of the frame, in pixels
<background> [optional]	table; with values .red, .green, .blue, .alpha between 0 and 1.
<strata>		[optional] string; a frame stratum, e.g. "HIGH", "LOW", "TOOLTIP" (default "MEDIUM")

Returns: a Frame object.
]]
me.createframe = function(parent, width, height, background, strata)
	
	if parent == nil then
		parent = UIParent
	end

	local frame = me.rawcreateframe("Frame", nil, parent)
	
	-- size
	frame:SetWidth(width)
	frame:SetHeight(height)	
	
	-- backdrop
	frame:SetBackdrop(me.framebackdrop)
	frame:SetBackdropBorderColor(1.0, 1.0, 1.0, 1.0) 
	
	-- optional background
	if background then
		frame:SetBackdropColor(background.red, background.green, background.blue, background.alpha)
	else
		frame:SetBackdropColor(0, 0, 0, 0)
	end
	
	-- optional strata
	if strata then 
		frame:SetFrameStrata(strata)
	end
	
	return frame
	
end

--[[
------------------------------------------------------------------------
						Button
------------------------------------------------------------------------
]]

--[[
me.createbutton(parent, width, height, backdrop, fontsize)

Creates a standard button.

<parent>		frame; the frame that the button belongs to.
<width>		number; the width of the button
<height>		number; the height of the button
<backdrop>	[optional] table; argument to SetBackdrop. Use <me.buttonbackdrop>.
<fontsize>	[optional] number; pitch of the font for the button text.
]]
me.createbutton = function(parent, width, height, backdrop, fontsize)
	
	-- need non-nil parent
	local button = me.rawcreateframe("Button", nil, parent)
	
	-- size
	button:SetWidth(width)	
	button:SetHeight(height)
	
	-- backdrop
	if backdrop then
		button:SetBackdrop(me.buttonbackdrop)
		button:SetBackdropBorderColor(1, 1, 1, 1)
		
		if type(backdrop) == "table" then
			button:SetBackdropColor(backdrop.red, backdrop.green, backdrop.blue)
		end
	end
		
	-- font
	if fontsize then
		button:SetFont(me.fontfile, fontsize)
	end
		
	button:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	
	-- add a shadow
	button:SetText("")
	
	temp = button:GetFontString()
	if temp then
		temp:SetShadowColor(0, 0, 0)
		temp:SetShadowOffset(1, -1)
	end
	
	return button
	
end

--[[
mod.gui.createclosebutton(parent, size, callback)
	
Remember to set the 
]]
me.createclosebutton = function(parent, size, callback)

	local button = me.rawcreateframe("Button", nil, parent)
	
	-- size
	button:SetHeight(size)
	button:SetWidth(size)
	
	button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	button:GetNormalTexture():SetTexCoord(0.175, 0.825, 0.175, 0.825)
	
	button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	button:GetPushedTexture():SetTexCoord(0.175, 0.825, 0.175, 0.825)
	
	button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	button:GetHighlightTexture():SetBlendMode("ADD")
	
	-- click handlers:
	button:SetScript("OnMouseDown", callback)

	return button

end

--[[
------------------------------------------------------------------------
						CheckBox
------------------------------------------------------------------------
]]

--[[
me.createcheckbox(parent, width, height, fontsize)

Creates a standard checkbox.

<parent>		frame; the frame that the button belongs to.
<width>		number; the width of the button
<height>		number; the height of the button
<fontsize>	number; pitch of the font for the button text.
]]
me.createcheckbox = function(parent, width, height, fontsize)
	
	if parent == nil then
		parent = UIParent
	end
	
	local button = me.rawcreateframe("CheckButton", nil, parent)
	
	-- size
	button:SetWidth(width)	
	button:SetHeight(height)
	
	-- textures
	button:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	button:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	button:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	
	-- text
	button.text = me.createfontstring(button, fontsize)
	button.text:SetPoint("LEFT", button, "RIGHT", -2, 0)
	button.text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	
	return button
	
end

--[[
-----------------------------------------------------------------------------
							FontString
-----------------------------------------------------------------------------
]]

-- This is e.g. "Fonts\\FRIZQT__.TFF" for en/us
me.fontfile = GameFontNormal:GetFont()

--[[
mod.gui.createfontstring(parentframe, fontsize, useshadow, flags)

Creates a standard Label.
	
<parentframe>	Frame; the owner of the label
<fontsize>		number; the pitch of the font
<useshadow>		[any non-nil]; gives the text a black shadow. Good to make it more readable, especially when the background is light.
<flags>			?; flags argumeny to SetFont()

Returns:			FontString; a reference to the created fontstring
]]
me.createfontstring = function(parentframe, fontsize, useshadow, flags)
	
	local fontstring = parentframe:CreateFontString()
	fontstring:SetFont(me.fontfile, fontsize, flags)
	
	if useshadow then
		fontstring:SetShadowColor(0, 0, 0)
		fontstring:SetShadowOffset(1, -1)
	end
	
	return fontstring
	
end

--[[
me.createsimpleinputbox(parent, fontsize, width)

Returns a single-line EditBox control.
]]
me.createsimpleinputbox = function(parent, fontsize, width)
	
	local element = me.rawcreateframe("EditBox", nil, parent, "InputBoxTemplate")
	
	element:SetWidth(width)
	element:SetHeight(fontsize + me.border)
	
	element:SetAutoFocus(false)
		
	element:SetScript("OnEscapePressed", 
		function(this)
			this:ClearFocus()
		end
	)

	return element
end

--[[
----------------------------------------------------------------------------
							Slider
----------------------------------------------------------------------------

This is basically a clone of OptionsSliderTemplate from (an old) OptionsFrame.xml, because the CreateFrame isn't working well when inheriting from a virtual template, since it requires a valid part of the global namespace, which we don't want to use.
]]

me.sliderbackdrop = 
{
	bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
	edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
	tile = true,
	tileSize = 8,
	edgeSize = 8,
	insets = { left = 3, right = 3, top = 6, bottom = 6 },
}

--[[
mod.gui.createslider(parent, width, height, fontsize)
	Creates a generic Slider frame.
	
<parent>		Frame; window that owns the slider
<width>		number; width of the slider in screen units (~ pixels)
<height>		number; height of the slider in screen units (~ pixels)
<fontsize>	number; pitch of the labels for the slider

Return:		Slider; reference to the created object
]]
me.createslider = function(parent, width, height, fontsize)
	
	local slider = me.rawcreateframe("Slider", nil, parent)
	
	-- size
	slider:SetWidth(width)
	slider:SetHeight(height)
	
	-- backdrop
	slider:SetBackdrop(me.sliderbackdrop)

	-- the thumb of the slider
	slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	
	-- orientation
	slider:SetOrientation("HORIZONTAL")
	
	-- labels
	slider.low = me.createfontstring(slider, fontsize)
	slider.low:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 2, 3)
	
	slider.high = me.createfontstring(slider, fontsize)
	slider.high:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", -2, 3)
	slider.high:SetWidth(slider:GetWidth())
	slider.high:SetJustifyH("RIGHT")
	
	slider.text = me.createfontstring(slider, fontsize)
	slider.text:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 2, 0)
	slider.text:SetTextColor(1.0, 1.0, 0)
	
	slider.value = me.createfontstring(slider, fontsize)
	slider.value:SetPoint("BOTTOMRIGHT", slider, "TOPRIGHT", -2, 0)
	slider.value:SetJustifyH("RIGHT")
	slider.value:SetWidth(slider:GetWidth())
	slider.value:SetTextColor(0.0, 1.0, 0)
	
	-- function to get the actual height
	slider.realheight = function()
		return slider.high:GetHeight() * 2 + slider:GetHeight()
	end
	
	return slider
	
end
