
-- module setup
local mod = thismod
local me = {name = "combobox"}
mod[me.name] = me

--[[
ComboBox.lua		(3 July 2007)

This is a combobox control. A combobox is a drop down list. It has a text field on the left and a button on its right. Clicking on the button will show a drop down list of text fields. Clicking an item in the list will hide the list and show the selected value in the text field.

---------------------------------------------------------------------	
	Data Schema / Layout
---------------------------------------------------------------------

Combobox =  <frame>
{
	width = <integer>,
	height = <integer>,
	
	framelist = <framelist>,
	text = <fontstring>,
	button = <frame>,
	{
		button = <button>,
	},
	
	data = { <data1>, <data2>, <data3>, … },  -- see <data_i> below
	value = <value of selected data>,
	
	onshowcallback = <function>,
	onvaluechangedcallback = <function>,
}

<data_i> = 
{
	text = <string>,
	value = <anything>,
}

---------------------------------------------------------------------
	Constructor
---------------------------------------------------------------------

mycombobox = mod.combobox.createnew(parent, width, height, listheight, fontpitch, onshowcallback, onvaluechangedcallback)

<parent> is the frame that owns this one
<width> is the total width in pixels
<height> is the height of the text field / button, also the width of the button, and the width of the scrollbar for the dropdown list. It's also the height of each entry in the dropdown list.
<listheight> is the height of the dropdown list, in pixels.
<fontpitch> is the size of the font for the main text field and entries in the dropdown list.
<onshowcallback> is an optional callback function. It will be called just before the list is shown (i.e. when the user clicks the button / text). Its signature is

	onshowcallback = function(combobox)
		...
	end

i.e. the combobox instance is sent as an argument.

<onvaluechangedcallback> is an optional callback function. It is called when the user clicks on an item in the list, setting the value of the combobox. Its signature is

	onvaluechangedcallback = function(combobox, value)
		...
	end

---------------------------------------------------------------------
	Usage
---------------------------------------------------------------------

To add an item to the combobox List, call the method

	mycombobox:additem(<text>, <value>)
	
<text> is the string displayed to the user. <value> is the underlying / internal value associated with the text. Note that <additem> won't support multiple copies with the same <value>. <value> is really a "key". But it is the value that is returned to you from combobox:getvalue().

To get the value selected in the combobox, 

	value = mycombobox:getvalue()

When the user clicks the button to show the items, your <onshowcallback> function will be called. This is a good time to repopulate the data in the list with calls to <additem> if you data is growing. 

When the user selects an item in the list, your <onvaluechangedcallback> function will be called, with the new value.

]]

--[[
----------------------------------------------------------------------------------------------
								Testing
----------------------------------------------------------------------------------------------
]]
--[[
This creates a simple combobox in the middle of the screen. Hide it with the command "/script <mod>.combobox.x:Hide()"
]]
me.test = function()
	
	local onshow = function(combobox)
		mod.print("List is being shown!")
	end
	
	local onvalue = function(combobox, value)
		mod.print("Value is set to " .. value)
	end
	
	me.x = me.createnew(UIParent, 200, 25, 200, 15, onshow, onvalue)
	
	me.x:SetPoint("BOTTOMLEFT", UIParent, 500, 500)
	
	me.x:Show()
	
	for y = 1, 15 do
		me.x:additem("item " .. y, y)
	end
	
	me.x:additem("default value", 0, true)
	
	me.x.framelist:redraw()
	
end


--[[
----------------------------------------------------------------------------------------------
							Combobox Constructor
----------------------------------------------------------------------------------------------
]]
--[[
mycombobox = mod.combobox.createnew(parent, width, height, listheight, fontpitch, onshowcallback, onvaluechangedcallback)

See the comments above for more details. The <width> and <height> values are taken to be visible sizes. 
]]
me.createnew = function(parent, width, height, listheight, fontpitch, onshowcallback, onvaluechangedcallback)
	
	local this = mod.gui.createframe(parent, width + 2 * mod.skin.borderinvis, height + 2 * mod.skin.borderinvis, mod.skin.background.box)
	
	-- define public methods:
	this.onshowcallback = onshowcallback
	this.onvaluechangedcallback = onvaluechangedcallback
	this.setselectedvalue = me.setselectedvalue
	
	-- load other args and default data
	this.height = height
	this.data = { }
	this.additem = me.additem
	this.fontpitch = fontpitch
	
	-- create button holder frame
	this.button = mod.gui.createframe(this, this:GetHeight() - mod.skin.borderinvis * 2, this:GetHeight() - mod.skin.borderinvis * 2, mod.skin.background.box)
	
	this.button:SetPoint("RIGHT", this, "RIGHT", -mod.skin.borderinvis, 0)
	
	-- create actual button inside button
	this.button.button = mod.gui.createclosebutton(this.button, height - 3 * mod.skin.borderinvis, me.onbuttonpress)
	this.button.button:SetPoint("CENTER", this.button, "CENTER", 0, 0)
	
	-- create framelist
	this.framelist = mod.framelist.createnew(this, listheight, height - mod.skin.borderinvis, listheight * 0.25, mod.skin.borderinvis, me.framelist_newframecallback, me.framelist_countcallback, me.framelist_drawitemcallback, me.framelist_clickitemcallback)
	
	this.framelist:SetPoint("TOPLEFT", this, "BOTTOMLEFT", mod.skin.borderinvis, mod.skin.borderinvis)
	
	-- create fontstring
	this.text = mod.gui.createfontstring(this, fontpitch)
	this.text:SetPoint("LEFT", this, "LEFT", mod.skin.borderinset, 0)
	
	-- set state to list hidden
	me.hidelist(this)
	
	return this
	
end

--[[
----------------------------------------------------------------------------------------------
							Framelist Callback Handlers
----------------------------------------------------------------------------------------------
]]
-- This is called when a new frame is required by the FrameList control
me.framelist_newframecallback = function(framelist)
	
	local combobox = framelist:GetParent()
		
	local frame = mod.gui.createframe(framelist, combobox:GetWidth() - combobox:GetHeight() + 2 * mod.skin.borderinvis, combobox:GetHeight(), mod.skin.background.window)
	
	-- a combobox is like a dialog
	frame:SetFrameStrata("DIALOG")
	
	frame.text = mod.gui.createfontstring(frame, combobox.fontpitch, true)
	frame.text:SetPoint("TOPLEFT", mod.gui.border, -mod.gui.border)
	
	return frame
	
end

-- This is called when the FrameList wants to know how many items there are
me.framelist_countcallback = function(framelist)
	
	local combobox = framelist:GetParent()
	
	return #combobox.data
	
end

-- This is called when the FrameList needs to redraw an item
me.framelist_drawitemcallback = function(frame, index)
			
	local framelist = frame:GetParent()
	local combobox = framelist:GetParent()
	
	frame.text:SetText(combobox.data[index].text)
	
end

-- This is called when an item in the FrameList is clicked.
me.framelist_clickitemcallback = function(index, framelist)
	
	local combobox = framelist:GetParent()
	
	combobox.text:SetText(combobox.data[index].text)
	
	combobox.value = combobox.data[index].value
	
	-- run callback event
	if combobox.onvaluechangedcallback then
		combobox.onvaluechangedcallback(combobox, combobox.value)
	end
	
	me.hidelist(combobox)
	
end

--[[
----------------------------------------------------------------------------------------------
							Public Methods
----------------------------------------------------------------------------------------------
]]
--[[
mycombobox:additem(text, value, isdefault)

Adds an item to the combobox. <Value> must be unique to separate items. If <value> matches an existing item, the <text> property of that item will be overwritten.

<text>		string; text displayed to the user.
<value>		any type; value that is returned to you.
<isdefault>	nil or non-nil; if non-nil this value will become the selected value
]]
me.additem = function(combobox, text, value, isdefault)
	
	local isoverwrite = false
	
	-- first check for duplicates of value (then overwrite)
	for index, data in pairs(combobox.data) do
		
		if data.value == value then
			data.text = text
			isoverwrite = true
			break
		end
	end
	
	if isoverwrite == false then
		table.insert(combobox.data, {text = text, value = value})
	end
	
	if isdefault then
		combobox.value = value
		combobox.text:SetText(text)
	end
	
end

--[[
value = mycombobox:getvalue()

Returns the current value in the combobox. If there is no value selected, it will return nil.
]]
me.getvalue = function(combobox)
	
	return me.value
	
end

--[[
mycombobox:setselectedvalue(value)

Sets the current value in the combobox. If <value> is nil, it will clear the selected value. If <value> matches any value in the combobox, that value will be selected. This WON'T raise the onvaluechanged event.
]]
me.setselectedvalue = function(combobox, value)
	
	if value == nil then
		combobox.value = nil
		combobox.text:SetText("")
		return
	end
	
	for index, data in pairs(combobox.data) do
		if data.value == value then
			combobox.value = value
			combobox.text:SetText(data.text)
			return
		end
	end
	
end

--[[
----------------------------------------------------------------------------------------------
							Button Click Events
----------------------------------------------------------------------------------------------
]]
-- This is called when the user clicks the button on the right to hide or show the dropdown list.
me.onbuttonpress = function(button)
		
	local combobox = button:GetParent():GetParent()
	
	if combobox.framelist:IsShown() then
		me.hidelist(combobox)
	else
		me.showlist(combobox)
	end
	
end

-- Called when the list is shown: only from the <onbuttonpress> event. Button texture changes from arrow to cross.
me.showlist = function(combobox)
	
	combobox.framelist:Show()
	
	-- set button to cross texture
	local button = combobox.button.button
	
	button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	button:GetNormalTexture():SetTexCoord(0.2, 0.75, 0.2, 0.8)
	
	button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	button:GetPushedTexture():SetTexCoord(0.2, 0.75, 0.2, 0.8)
	
	button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	button:GetHighlightTexture():SetTexCoord(0.175, 0.825, 0.175, 0.825)
	
	if combobox.onshowcallback then
		combobox.onshowcallback(combobox)
	end
end

-- Called when the list is hidden: from <onbuttonpress> or clicking an item. Button texture changes from Cross to Arrow.
me.hidelist = function(combobox)
	
	combobox.framelist:Hide()
	
	-- Set the button texture to the click down button
	local button = combobox.button.button
	
	button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	button:GetNormalTexture():SetTexCoord(0.175, 0.825, 0.175, 0.825)
	
	button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
	button:GetPushedTexture():SetTexCoord(0.175, 0.825, 0.175, 0.825)
	
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	button:GetHighlightTexture():SetTexCoord(0.175, 0.825, 0.175, 0.825)
	
end


