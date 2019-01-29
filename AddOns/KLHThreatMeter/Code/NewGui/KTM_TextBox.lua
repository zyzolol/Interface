
-- module setup
local me = { name = "textbox"}
local mod = thismod
mod[me.name] = me

--[[
Textbox.lua

Introduction
--------------------------------------------------------------------

This is an implementation of a Multiline (user input) Textbox with a scrollbar. Pretty simple concept, but the default UI's implementation is horrible. The textbox has a vertical scrollbar on the right. You can scroll the text with the mousewheel, dragging the scroll box, or clicking the scroll arrows.

The editbox won't grab focus automatically. But the only way to remove its focus is to click escape on it. This is the same as e.g. when you are editing a macro. 


Schema / Data Layout
--------------------------------------------------------------------

this = <Frame>
{
	scrollbar = <scrollbar> (see ScrollBar.lua)

	scrollframe = <ScrollFrame>
	editbox = <EditBox>
	
	
Constructor
--------------------------------------------------------------------

textbox = mod.textbox.createnew(parentframe,  width, height, backgroundcolourscheme, fontsize, scrollbarwidth, scrollbarheight)

--> <parentframe> is the container of the textbox.

--> <width> and <height> are the dimensions of the textbox.

--> <backgroundcolourscheme> is a table with .red, .green and .blue values

--> <fontsize> is the pitch of the font used in the text box

--> <scrollbarwidth> is the side length of the scroll bar arrows and it's width

--> <scrollbarheight> is the height of the box in the scroll bar that you drag.

]]

--[[
value = mod.textbox.createnew(parentframe,  width, height, backgroundcolourscheme, fontsize, scrollbarwidth, scrollbarheight)

See the comments above for more details.
]]
me.createnew = function(parentframe, width, height, backgroundcolourscheme, fontsize, scrollbarwidth, scrollbarheight)
	
	local textbox, scrollframe, editbox, scrollbox
	
	-- create wrapper frame
	textbox = mod.gui.createframe(parentframe, width, height, backgroundcolourscheme)

	-- store fontsize
	textbox.fontsize = fontsize
	
	-- create scrollbar
	textbox.scrollbar = mod.scrollbar.createnew(textbox, height - 2 * mod.gui.border, scrollbarwidth, scrollbarheight, me.scrollbar_getscrollunit, me.scrollbar_onscroll)
	textbox.scrollbar:SetPoint("TOPRIGHT", textbox, "TOPRIGHT", -mod.gui.border, -mod.gui.border)
			
	-- now create a scrollframe inside frame
	
	-- 1) define
	scrollframe = mod.gui.rawcreateframe("ScrollFrame", nil, textbox)
	textbox.scrollframe = scrollframe
	
	-- 2) size
	scrollframe:SetHeight(textbox:GetHeight() + mod.gui.border - 2 * mod.helpmenu.textinset)
	scrollframe:SetWidth(textbox:GetWidth() - mod.helpmenu.textinset - scrollbarwidth)
	
	-- 3) location
	scrollframe:SetPoint("TOPLEFT", mod.helpmenu.textinset - mod.gui.border, mod.gui.border - mod.helpmenu.textinset)
	
	-- now create an edit box inside the scrollframe
	
	-- 1) define
	editbox = mod.gui.rawcreateframe("EditBox", nil, scrollframe, "KLH_ScrollingEditBox")
	textbox.editbox = editbox
	
	editbox:SetWidth(scrollframe:GetWidth())
	editbox:SetMultiLine(true)
	editbox:SetAutoFocus(false)
	
	-- font size
	local fontname = GameFontNormal:GetFont()
	editbox:SetFont(fontname, textbox.fontsize)
	
	-- debug
	for x = 1, 10 do
		editbox:SetText(editbox:GetText() .. string.rep(tostring(x), 100) .. "\n")
	end
	
	-- make his text stick out a bit
	editbox:SetShadowColor(0, 0, 0)
	editbox:SetShadowOffset(1, -1)

	editbox:SetScript("OnEscapePressed", function(this) 
		this:ClearFocus()
	end)

	scrollframe:SetScrollChild(editbox)
	scrollframe:EnableMouseWheel(true)
	scrollframe:SetScript("OnMouseWheel", me.mousewheel)
	
	return textbox
	
end

-- "this" should point to the scrollframe
me.mousewheel = function(scrollframe)
		
	scrollframe:UpdateScrollChildRect()
	scrollframe:GetParent().scrollbar:scroll( 3 * -arg1)
		
end


--[[
---------------------------------------------------------------------------------------
			Interop with Scrollbar control
---------------------------------------------------------------------------------------
]]

me.scrollbar_getscrollunit = function(scrollbar)
	
	-- we want to scroll down 3 lines.
	local this = scrollbar:GetParent()
	
	this.scrollframe:UpdateScrollChildRect()
	local maxrange = this.scrollframe:GetVerticalScrollRange()
	
	if this.fontsize > maxrange then
		return 0
	else
		return this.fontsize / maxrange
	end
		
end

me.scrollbar_onscroll = function(scrollbar, position)
		
	local this = scrollbar:GetParent()
	local scrollframe = this.scrollframe
	
	scrollframe:UpdateScrollChildRect() 
	scrollframe:SetVerticalScroll(position * scrollframe:GetVerticalScrollRange())
	
end