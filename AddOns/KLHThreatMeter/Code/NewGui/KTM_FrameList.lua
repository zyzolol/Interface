
-- module setup
local me = { name = "framelist"}
local mod = thismod
mod[me.name] = me

--[[
FrameList.lua 			

27 Jun 2007: Changing the list to fixed-height items, so there's no overshoot at the bottom.

Introduction		16 June 2007
--------------------------------------------------------------------

This control is a list of frames with a scrollbar to nagivate over them. It is useful for displaying complex data that is stored as a list (table with integer indices).

The implementation is highly abstracted. The FrameList itself has no access to the underlying data. Instead you provide callback functions that are run when a new frame needs to be created or drawn.

The FrameList only creates as many frames as will fit in the control and reuses them, so it is suitable for displaying lists with lots of data.

Call myframelist:redraw() when the underlying data set changes.

See the Constructor section for more details on the callbacks.


Schema / Data Layout
--------------------------------------------------------------------

this = <frame>
{
	scrollbar = <scrollbar>, (see ScrollBar.lua)
	
	framepool = { <frame_1>, <frame_2>, ... },
	
	selectedindex = <integer>,
}

<frame_i> has a property <.dataindex> set to the index in the underlying data it corresponds to.


Constructor
--------------------------------------------------------------------

	myframelist = mod.framelist.createnew(parent, height, scrollbarwidth, scrollboxheight, framecompression, newframecallback, countcallback, drawitemcallback, clickitemcallback)

<parent> is frame that contains the framelist.

<height> is the initial height of the control, in screen units (~ pixels). The height can be changed later by 
	
	myframelist:setheight(value)

<scrollbarwidth> is the side length in screen units of the scroll bar boxes, and width of the scroll bar itself.

<scrollboxheight> is the height of the box you can drag to scroll the bar. 

<framecompression> is used to pack the frames more closely. Most frames have a few pixels on the edges that are invisible, causing odd gaps in the table, specifying a value for this will cancel it out. Recommended value is <mod.gui.invisedge> (2.5)

<newframecallback> creates a blank frame with any child elements defined on it. The format is
	
	newframecallback = function(framelist)
		return <frame>		
	end
	
<countcallback> returns the number of items in the data set. The format is

	countcallback = function(framelist)
		return <integer>
	end
	
<drawitemcallback> renders an item in the scrollframe. The format is

	drawitemcallback = function(frame, index)
		(draw the data at <index> in the array onto <frame>)
	end
	
<frame> is e.g. a return value from <newframecallback>, but it might be reused as well. 
<index> is the index of the item in the data set.

--OPTIONAL--
<clickitemcallback> is called when the user clicks an item in the list. The format is

	clickitemcallback = function(index, framelist)
		(the user has clicked <index>)
	end

See <me.test> below for a quick example.
]]

me.test = function()
	
	me.dataset = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j"}
	
	me.newframe = function(parent)
		
		local frame = mod.gui.createframe(parent, 200, 40, mod.helpmenu.background.frame)
		frame.text = mod.gui.createfontstring(frame, 18, true)
		frame.text:SetPoint("TOPLEFT", mod.gui.border, -mod.gui.border)
		
		return frame
	end
	
	me.count = function()
		
		return table.getn(me.dataset)
		
	end
	
	me.drawitem = function(frame, index)
		
		frame.text:SetText(me.dataset[index])
		
	end
	
	me.x = me.createnew(mod.frame, 150, 30, 50, mod.gui.invisedge, me.newframe, me.count, me.drawitem)
	
	me.x:SetPoint("BOTTOMLEFT", UIParent, 500, 500)
	
end

--[[
mod.framelist.createnew(parent, height, scrollbarwidth, scrollbarheight, framecompression, newframecallback, countcallback, drawitemcallback, clickitemcallback)

For details, see the comments at the top of the file.

Returns: a scroll frame instance.
]]
me.createnew = function(parent, height, scrollbarwidth, scrollbarheight, framecompression, newframecallback, countcallback, drawitemcallback, clickitemcallback)
	
	-- base frame / anchor point
	local this = mod.gui.rawcreateframe("Frame", nil, parent)
	this:SetWidth(1)
	this:SetHeight(1)
	
	-- load arguments into ourself
	this.height = height
	this.newframe = newframecallback
	this.count = countcallback
	this.drawitem = drawitemcallback
	this.scrollbarwidth = scrollbarwidth
	this.scrollbarheight = scrollbarheight
	this.framecompression = framecompression
	this.clickitem = clickitemcallback

	-- other data
	this.framepool = { }

	-- fill in instance methods
	this.redraw = me.redraw
	this.addnewframe = me.addnewframe
	
	-- create GUI components
	this.scrollbar = mod.scrollbar.createnew(this, this.height, this.scrollbarwidth, this.scrollbarheight, me.scrollbar_getscrollunit, me.scrollbar_onscroll)
	this.scrollbar:SetPoint("TOPLEFT", this, "TOPLEFT", 0, 0)
	
	-- work out the number of items we can fit. First see how big a frame is
	this:addnewframe()
	local newframe = this.framepool[1]
	
	-- now crunch numbers
	this.frameheight = newframe:GetHeight() - 2 * this.framecompression
	this.maxvisible = math.floor(this.height / this.frameheight)
	
	-- initial draw
	this:redraw()
	
	return this
	
end

--[[
framelist:addnewframe()

Internal function. Called when we need to generate a new frame for this frame list
]]
me.addnewframe = function(this)
	
	local newframe = this:newframe()
	table.insert(this.framepool, newframe)
	
	-- add stuff to make the frame clickable
	newframe:EnableMouse(1)
	newframe:SetScript("OnMouseDown", me.itemclickhandler)
	
	newframe:EnableMouseWheel(1)
	newframe:SetScript("OnMouseWheel", me.mousewheelhandler)
	
	newframe:SetScript("OnEnter", me.onitementerhandler)
	newframe:SetScript("OnLeave", me.onitemleavehandler)
	
end

--[[
---------------------------------------------------------------------------------------
			Interop with Scrollbar control
---------------------------------------------------------------------------------------
]]

me.scrollbar_getscrollunit = function(scrollbar)
	
	local this = scrollbar:GetParent()
	
	local count = math.max(1, this:count() - this.maxvisible + 1)
	return 1 / count
	
end

me.scrollbar_onscroll = function(scrollbar, position)
	
	local this = scrollbar:GetParent()
	this:redraw()
	
end

--[[
---------------------------------------------------------------------------------------
			Redrawing - from scroll events or on user request
---------------------------------------------------------------------------------------
]]

--[[
scrollframe:redraw()

Renders the items in the list of the scrollframe.

--> fix visibility issues
]]
me.redraw = function(this)
	
	-- get the top item
	local count = this:count()
	
	-- if count = 0, then nothing doing imo. well, there could be problems if count is decreasing
	if count == 0 then
		return
	end
	
	local topindex
	
	if count <= this.maxvisible then
		topindex = 1
	else
		topindex = math.floor(0.01 + this.scrollbar.position * (count - this.maxvisible + 1)) + 1
		
		if topindex > count - this.maxvisible + 1 then
			topindex = count - this.maxvisible + 1
		end
	
	end
	
	local frameindex = 0
	local dataindex, frame
	local framestodraw = math.min(count, this.maxvisible)
		
	for dataindex = topindex, topindex + framestodraw - 1 do
		
		-- 1) draw next index
		frameindex = frameindex + 1 				-- starts at 1
		dataindex = topindex + frameindex - 1	-- starts at topindex
		
		-- a) get a frame. Check framepool or make a new one
		if this.framepool[frameindex] == nil then
			this:addnewframe()
		end
		
		-- tell frame its identity
		frame = this.framepool[frameindex]
		frame.dataindex = dataindex
		
		-- b) anchor the frame
		frame:SetPoint("TOPLEFT", - this.framecompression + this.scrollbarwidth, (1 - frameindex) * (frame:GetHeight() - 2 * this.framecompression) + this.framecompression)
		
		-- c) draw
		this.drawitem(frame, dataindex)
		
		-- set background border colour
		if frame.dataindex == this.selectedindex then
			frame:SetBackdropBorderColor(unpack(mod.skin.border.selected))
		else
			frame:SetBackdropBorderColor(unpack(mod.skin.border.normal)) 
		end
		
	end
	
	-- hide any frames below the last one
	for x = frameindex + 1, #this.framepool do
		this.framepool[x]:Hide()
	end
	
end

--[[
---------------------------------------------------------------------------------------
					User Input Events
---------------------------------------------------------------------------------------
]]

--[[
This is the OnMouseDown handler for items in the framelist.
]]
me.itemclickhandler = function(item)
	
	local this = item:GetParent()
	
	if this.clickitem == nil then
		return
	end
	
	for x = 1, #this.framepool do
		if item == this.framepool[x] then
	
			-- unselect previously selected index
			for index, frame in pairs(this.framepool) do
				if frame.dataindex == this.selectedindex then
					frame:SetBackdropBorderColor(unpack(mod.skin.border.normal))
				end
			end
	
			-- indicate this item is selected
			this.selectedindex = item.dataindex
			item:SetBackdropBorderColor(unpack(mod.skin.border.selected)) 
			
			-- run click callback
			this.clickitem(item.dataindex, this)
			return
		end
	end
	
end

me.mousewheelhandler = function(item, value)
	
	local this = item:GetParent()
	
	this.scrollbar:scroll(-value)
	
end

me.onitementerhandler = function(item)
	
	-- ignore for selected index
	if item.dataindex == item:GetParent().selectedindex then
		return
	end
	
	-- set selected 
	item:SetBackdropBorderColor(unpack(mod.skin.border.mouseover))
	
end

me.onitemleavehandler = function(item)
	
	-- ignore for selected index
	if item.dataindex == item:GetParent().selectedindex then
		return
	end
	
	-- set selected 
	item:SetBackdropBorderColor(unpack(mod.skin.border.normal))
	
end