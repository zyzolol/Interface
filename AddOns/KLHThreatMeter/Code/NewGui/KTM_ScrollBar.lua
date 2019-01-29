
-- module setup
local me = { name = "scrollbar"}
local mod = thismod
mod[me.name] = me

--[[
Scrollbar.lua		16 Jun 2007

This is a generic Scrollbar component.


Constructor
--------------------------------------------------------------

myscrollbar = mod.scrollbar.createnew(parentframe, height, width, barheight, getscrollunit, onscroll)

--> parentframe is the frame that owns the scrollbar
	
--> height and width are the dimensions of the scrollbar
	
--> barheight is the height of the scrolling box that you drag
	
--> getscrollunit is a callback function that says how much to scroll with each click of the arrow. The format is
	
		getscrollunit = function(scrollbar)
			(return a number between 0 and 1)
		end
		
		This will obviously depend on how many items you have in whatever is scrolling. Also it should be between 0 (small scroll) and 1 (big scroll). A normal value would be (1 / n) where there are n items in your scrolling area. Then each click of the arrow would scroll 1 items worth.

--> onscroll is a callback function to report when the scrollbar changes position. The format is

		onscroll = function(scrollbar, position)
			(the scroll bar is now at <position>)
		end
		
		Position is between 0 (up the top) and 1 (down the bottom)

For a simple example, see the function <me.test> below.


Schema / Data Layout
--------------------------------------------------------------

this = <frame>
{
	position = <number>	-- between 0 and 1. 0 = bar up the top, 1 = bar down the bottom.
	
	barheight = <number>,
	sidelength = <number>,
	
	toparrow = <frame>
	{
		button = <button>
	},
	bottomarrow = <frame>
	{
		button = <button>
	},
	scrollbox = <frame>
}
]]

--[[
/script klhtm.scrollbar.test()
]]
me.test = function()
	
	me.getscrollunit = function(this) return 0.1 end
	
	me.onscroll = function(this, position) mod.print("scrolling to " .. position) end
	
	me.frame = mod.gui.createframe(nil, 500, 500, mod.helpmenu.background.frame)
	me.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	
	me.scrollbar = me.createnew(me.frame, 300, 35, 50, me.getscrollunit, me.onscroll)
	me.scrollbar:SetPoint("RIGHT", me.frame, "LEFT", 0, 0)
	
end

--[[
parentframe: owner of the scrollbar control.
height: actual height as seen by user.
width: actual width as seen by user.
scrollbarheight: the height of the little bar.
getscrollunit = function() return <number> end -- how much the position should change in 1 click.
onscroll = function(newposition) ... -- callback for scrolls
]]
me.createnew = function(parentframe, height, width, barheight, getscrollunit, onscroll)
	
	-- base frame / anchor point
	local this = mod.gui.rawcreateframe("Frame", nil, parentframe)
	
	this:SetWidth(width)
	this:SetHeight(height)
	
	-- load other parameters
	this.barheight = barheight
	this.getscrollunit = getscrollunit
	this.onscroll = onscroll
	this.position = 0 
	
	-- fill in instance methods
	this.createcomponents = me.createcomponents
	this.scroll = me.scroll
	this.updateposition = me.updateposition
	this.redraw = me.redraw
	
	-- create GUI components
	this:createcomponents()
		
	return this
		
end

--[[
Constructs the GUI
]]
me.createcomponents = function(this)
	
	this.sidelength = this:GetWidth() + 2 * mod.gui.invisedge
	local arrow
	
	-- 1) Top Arrow; the scroll up arrow.
	arrow = mod.gui.createframe(this, this.sidelength, this.sidelength)
	this.toparrow = arrow
	
	arrow:SetPoint("TOP", 0, mod.gui.invisedge)
	
	arrow.button = mod.gui.rawcreateframe("Button", nil, arrow)
	arrow.button:SetPoint("BOTTOMLEFT", mod.gui.border, mod.gui.border)
	arrow.button:SetPoint("TOPRIGHT", -mod.gui.border, -mod.gui.border)
	
	arrow.button:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
	arrow.button:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
	arrow.button:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled")
	arrow.button:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight")
	
	arrow.button:GetNormalTexture():SetTexCoord(0.25, 0.75, 0.25, 0.70)
	arrow.button:GetPushedTexture():SetTexCoord(0.25, 0.75, 0.25, 0.70)
	arrow.button:GetDisabledTexture():SetTexCoord(0.25, 0.75, 0.25, 0.70)
	arrow.button:GetHighlightTexture():SetTexCoord(0.25, 0.75, 0.25, 0.70)
	
	arrow.button:SetScript("OnClick", me.toparrow_onclick)
	
	-- 2) Bottom Arrow; the scroll down arrow.
	arrow = mod.gui.createframe(this, this.sidelength, this.sidelength)
	this.bottomarrow = arrow
	
	arrow:SetPoint("BOTTOM", 0, -mod.gui.invisedge)
	
	arrow.button = mod.gui.rawcreateframe("Button", nil, arrow)
	arrow.button:SetPoint("BOTTOMLEFT", mod.gui.border, mod.gui.border)
	arrow.button:SetPoint("TOPRIGHT", -mod.gui.border, -mod.gui.border)
	
	arrow.button:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
	arrow.button:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
	arrow.button:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
	arrow.button:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight")
	
	arrow.button:GetNormalTexture():SetTexCoord(0.25, 0.75, 0.25, 0.70)
	arrow.button:GetPushedTexture():SetTexCoord(0.25, 0.75, 0.25, 0.70)
	arrow.button:GetDisabledTexture():SetTexCoord(0.25, 0.75, 0.25, 0.70)
	arrow.button:GetHighlightTexture():SetTexCoord(0.25, 0.75, 0.25, 0.70)
	
	arrow.button:SetScript("OnClick", me.bottomarrow_onclick)
	
	-- 3) Floating Box
	this.scrollbox = mod.gui.createframe(this, this.sidelength, this.barheight + 2 * mod.gui.invisedge, mod.helpmenu.background.box)
	this.scrollbox:SetPoint("TOP", 0, mod.gui.invisedge - this:GetWidth())
	
	this.scrollbox:SetMovable(true)
	this.scrollbox:RegisterForDrag("LeftButton")
	this.scrollbox:EnableMouse()
	
	-- Dragging Events
	this.scrollbox:SetScript("OnDragStart", me.scrollbox_ondragstart)
	this.scrollbox:SetScript("OnDragStop", me.scrollbox_ondragstop)
	this.scrollbox:SetScript("OnUpdate", me.scrollbox_onupdate)
	
end

--[[
---------------------------------------------------------------------------------------
			Scroll Bar Event Handlers - Clicking Scroll Buttons
---------------------------------------------------------------------------------------
]]

-- This is the "OnClick" event for the ScrollUp arrow.
me.toparrow_onclick = function(this)
	
	-- this:GetParent() is the frame that holds the arrow. Another GetParent() is the scrollbar itself
	local scrollbar = this:GetParent():GetParent()
	
	scrollbar:scroll(-1)
	
end

-- This is the "OnClick" event for the ScrollDown arrow.
me.bottomarrow_onclick = function(this)
	
	-- this:GetParent() is the frame that holds the arrow. Another GetParent() is the scrollbar itself
	local scrollbar = this:GetParent():GetParent()
	
	scrollbar:scroll(1)
	
end

--[[
scrollframe:scroll(direction)

Called when the user clicks one of scrollbar scroll arrows. Sort it out.

<direction> is -1 for up, 1 for down.
]]
me.scroll = function(this, direction)
	
	local scrollchange = this:getscrollunit() * direction
		
	-- increment position
	this.position = this.position + scrollchange

	-- bound
	this.position = math.max(0, math.min(1, this.position))
	
	local effectiveheight = this:GetHeight() - 2 * this:GetWidth() - this.barheight
	
	-- update the scrollbox' position
	local offset = this.position * effectiveheight
	
	this.scrollbox:ClearAllPoints()
	this.scrollbox:SetPoint("TOP", 0, mod.gui.invisedge - this:GetWidth() - offset)
	
	this:onscroll(this.position)
end

--[[
------------------------------------------------------------------------------------
	Scroll Bar Event Handlers - Free Scrolling by Dragging the Bar 
------------------------------------------------------------------------------------
]]

-- This is the "OnDragStart" event for the <scrollframe.scrollbox> frame
me.scrollbox_ondragstart = function(this)
	
	this:StartMoving()
	this.ismoving = true
	
end

-- This is the "OnDragStop" event for the <scrollframe.scrollbox> frame
me.scrollbox_ondragstop = function(this)
	
	this:StopMovingOrSizing()
	this.ismoving = nil
	
end

-- This is the "OnUpdate" event for the <scrollframe.scrollbox> frame
me.scrollbox_onupdate = function(this)
	
	local scrollbar = this:GetParent()
		
	if this.ismoving == true then
		-- realign him and bound him

		-- 1) set x right
		if this:GetLeft() ~= scrollbar:GetLeft() then
			this:ClearAllPoints()
			this:SetPoint("TOPLEFT", scrollbar, "TOPLEFT", -mod.gui.invisedge, this:GetTop() - scrollbar:GetTop())
		end
		
		-- 2) prevent upper bound overshoot
		if this:GetTop() > scrollbar:GetTop() + 3 * mod.gui.invisedge - this:GetWidth() then
			this:ClearAllPoints()
			this:SetPoint("TOP", scrollbar, "TOP", 0, 3 * mod.gui.invisedge - this:GetWidth())
		
		-- 3) prevent lower bound overshoot
		elseif this:GetTop() < scrollbar:GetTop() - scrollbar:GetHeight() + scrollbar:GetWidth() + mod.gui.invisedge + scrollbar.barheight then
						
			this:ClearAllPoints()
			this:SetPoint("TOP", scrollbar, "TOP", 0, - scrollbar:GetHeight() + scrollbar:GetWidth() + mod.gui.invisedge + scrollbar.barheight)
			
		end
		
		-- 4) now evaluate its position (fraction from 0 to 1)
		local maxtop = scrollbar:GetTop() + mod.gui.invisedge - this:GetWidth()
		local mintop = scrollbar:GetTop() - scrollbar:GetHeight() + scrollbar:GetWidth() + mod.gui.invisedge + scrollbar.barheight
		local current = this:GetTop()
		
		local position = (maxtop - current) / (maxtop - mintop)
		
		-- bound to (0, 1) (might get slight overruns)
		scrollbar.position = math.max(0, math.min(1, position))
		scrollbar:onscroll(scrollbar.position)
	end	
	
end