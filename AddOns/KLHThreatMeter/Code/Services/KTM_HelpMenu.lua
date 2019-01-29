
-- module setup
local me = { name = "helpmenu"}
local mod = thismod
mod[me.name] = me

--[[
HelpMenu.lua

This module is the core component of the mod's Main Menu, the window when you customise the mod's behaviour. There are many separate sections to the menu, and this module helps organise them in a heirarchical manner. 

Imagine a tree structure, where the top node represents the entire Menu. Each node has a section where the user can do something, and it may also have a series of child sections that deal with more specific issues. On the screen, the Menu module will create a list of each section's children on the left, and in the centre ths sections' Frame is displayed. 
]]

--[[
-- debug enabled
me.mytraces = 
{
	default = "info",
}
]]

bil = function()
	a = 1
	a = a + 1
end

-- Console Commands
me.myconsole = 
{
	help = "show",
}

-- These are common layout properties that all frames should use.
me.fontsize = 15
me.textinset = 15	-- This is the inset between the edge of the frame and where the text block starts.
me.defaultwidth = 500

me.background = 
{
	box = -- blue
	{
		red = 0.2,
		green = 0.2,
		blue = 0.6,
		alpha = 1.0,
	},
	frame = -- green
	{
		red = 0.2,
		green = 0.6,
		blue = 0.2,
		alpha = 1.0,
	},
	button = -- red
	{
		red = 0.6,
		green = 0.2,
		blue = 0.2,
		alpha = 1.0,
	},		
}

-- Special OnLoad method called from Core.lua.
me.onload = function()
	
	-- this is the "Home / Parent / Up" button on the top left of the bar.
	me.button.parent = me.createsidebarbutton(0)
	
	-- this is the current section
	me.button.current = me.createsidebarbutton(-1)
	
	-- add a "close" button to the current topic box
	local button = mod.gui.rawcreateframe("Button", nil, me.button.current)
	
	-- size
	button:SetHeight(25)
	button:SetWidth(25)
	
	button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	button:GetNormalTexture():SetTexCoord(0.175, 0.825, 0.175, 0.825)
	
	button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	button:GetPushedTexture():SetTexCoord(0.175, 0.825, 0.175, 0.825)
	
	button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	button:GetHighlightTexture():SetBlendMode("ADD")
	
	-- location (bottom right)
	button:SetPoint("TOPRIGHT", me.button.current, -mod.gui.border, -mod.gui.border)
	
	-- click handlers:
	button:SetScript("OnMouseDown", mod.helpmenu.hide)
	
	-- add to frame
	me.button.current.close = button
	
end

--[[
-----------------------------------------------------------------------------
				(OnLoad) Adding Sections to the Help Menu
-----------------------------------------------------------------------------
]]

--[[
<me.sections> keeps track of all the sections and their heirarchy. Each section is indexed by an integer, which is just by the order the section was added, and a string, which is the section's name. 

The Integer key makes the ordering of child sections deterministic, while the string key makes it easy to find a section. e.g.

<me.sections> = 
{
	[1] = <section1>,
	[2] = <section2>,
	
	[section1name] = <section1>,
	[section2name] = <section2>,
}

a section is a table with these properties

.id				string; identifier of the section. Try to keep it unique. e.g. "raidtable-layout"
.title			string; title of the section, e.g. "Colours and Layout". Brief!
.parentid		string; identifier of the parent section
.frame			Frame; what to show when the section is active. Optionally, the Frame can have a .setup() method, that will be run every time just before it is shown.
.children		array of <section> objects.
]]
me.sections = { }

--[[
mod.menu.registersection(id, parentid, title, frame)
	Adds a topic to the list of topics. This method is called from the <me.onload()> method of this and other modules. All the topic will be dumped into <me.sections>. They are only ordered in <me.onloadcomplete()>. Optionally, the Frame can have a .setup() method, that will be run immediately before it is shown.

<id>			string; identifier of this section
<parentid>	string; the <id> property of this topic's parent, or <nil> if this is a top level section.
<title> 		string; localised brief description of the topic
<frame>		Frame; the window that has this topic's content

Returns:		non-nil if it worked.
]]
me.registersection = function(id, parentid, title, frame)
	
	-- warn if this is an overwrite
	if me.sections[id] then
		if mod.trace.check("warning", me, "setup") then
			mod.trace.printf("A section named |cffffff00%s|r already exists (the new section won't be added).", id)
			
			-- don't allow overwrites
			return
		end
	end
	
	-- default parent is top
	if parentid == nil then
		parentid = "top"
	end

	-- create the new section
	local newsection = 
	{
		id = id,
		parentid = parentid,
		title = title,
		frame = frame,
		children = { },
	}

	-- add the new section
	me.sections[#me.sections + 1] = newsection
	me.sections[id] = newsection
	
	return true
	
end

--[[
Special OnLoadComplete() method called from Core.lua.
	The sections in <me.sections> are connected - a node <x> is added to the <.children> set of it's parent node.
]]
me.onloadcomplete = function()

	local parentname, parentnode

	for x, data in ipairs(me.sections) do
		
		me.linksection(data)
		
	end
	
end

--[[
me.linksection(data)

Adds a section to the children list of its parent.

data	a <section> object.
]]
me.linksection = function(data)
		
	-- check for parent not existing
	if me.sections[data.parentid] == nil then
		if mod.trace.check("warning", me, "setup") then
			mod.trace.printf("No section has the name |cffffff00%s|r referenced by the section |cffffff00%s|r.", tostring(data.parentid), tostring(data.id))
		end
		
	else -- link it
			
		-- don't make root node a child of itself (because it is already its own parent)
		if data.id ~= "top" then
			parentnode = me.sections[data.parentid]
			table.insert(parentnode.children, data)
		end
	end
	
end

--[[
<namespace>.menu.lateregistersection(id, parentid, title, frame)

	This allows other addons to add a help topic at runtime, i.e. after the mod has loaded.

<id>			string; identifier of this section
<parentid>	string; the <id> property of this topic's parent, or <nil> if this is a top level section.
<title> 		string; localised brief description of the topic. Keep it short so it can fit in a box!
<frame>		Frame; the window that has this topic's content.

Returns: non-nil if it worked.
]]
me.lateregistersection = function(id, parentid, title, frame)
	
	if me.registersection(id, parentid, title, frame) then
		
		-- link it to its parents
		me.linksection(me.sections[id])
	end
	
end

--[[
-----------------------------------------------------------------------------
				(RunTime) Changing the Section Being Displayed
-----------------------------------------------------------------------------
]]

--[[
mod.menu.show()
	Shows the Menu window. It will start at the Home page.
]]
me.show = function()
	
	me.showsection("top")
	
end

--[[
mod.menu.hide()
	Closes the Menu window. All we do is close every frame that might be shown
]]
me.hide = function()
	
	if me.currentsection then
		me.currentsection.frame:Hide()
		
		for x = 1, table.getn(me.button) do
			me.button[x]:Hide()
		end
		
		me.button.parent:Hide()
		me.button.current:Hide()
	end
	
end

--[[
me.showsection(sectionname)
	Shows the specified topic in the menu window. Updates the menu bar buttons to point to the child nodes of the specified topic.
	
<sectionname>	string; the name of the section to be displayed. 
]]
me.showsection = function(sectionname)
	
	-- hide old section if there is one
	if me.currentsection then
		me.currentsection.frame:Hide()
	end
	
	-- get and set the new section
	local section = me.sections[sectionname]
	me.currentsection = section
	
	-- create deferred frame:
	if section.frame.isdeferred then
		
		if mod.trace.check("info", me, "defer") then
			mod.trace.printf("Creating a deferred frame for the %s section.", section.title)
		end
		
		section.frame = section.frame.createdeferredframe()
	end
	
	-- show and potision frame
	if section.frame.setup then
		section.frame.setup()
	end
	
	section.frame:Show()
	section.frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", GetScreenWidth() * 0.25, GetScreenHeight() * 0.85)
	
	-- Sidebar buttons
	
	-- parent bar. Show / anchor only needs to be done once, but it won't hurt. The text for this one is in yellow to differentiate it from the child links
	me.button.parent:Show()
	me.button.parent:SetPoint("TOPRIGHT", section.frame, "TOPLEFT", mod.gui.border, 0)
	me.button.parent.label:SetText("|cffffff00" .. me.sections[section.parentid].title)
	
	-- current bar
	me.button.current:Show()
	me.button.current:SetPoint("BOTTOM", section.frame, "TOP", 0, - mod.gui.border)
	me.button.current.label:SetText(section.title)
	
	-- hide old ones
	for x = 1, #me.button do
		me.getsidebarbutton(x):Hide()
	end
	
	-- show new ones. There's a 20 pixel gap between the child buttons and the parent button.
	for x = 1, #section.children do
		childsection = section.children[x]
		
		me.getsidebarbutton(x).label:SetText(childsection.title)
		me.getsidebarbutton(x):SetPoint("TOPRIGHT", section.frame, "TOPLEFT", mod.gui.border, -20 + x * (mod.gui.border - me.button.height))
		me.getsidebarbutton(x):Show()
	end
	
end

--[[
-----------------------------------------------------------------------------
					Managing the Navigation Boxes
-----------------------------------------------------------------------------
]]

--[[
me.button holds the set of buttons we have created in numerical indices, and assorted properties as keys.
]]
me.button = 
{
	width = 200,
	height = 50,
}

--[[
me.getsidebarbutton(index)
	Gets the nth button on the menu sidebar. Creates it if it doesn't exist already.

<index>	integer; 1-based index.

Return: Frame; one of the items in <me.button>
]]
me.getsidebarbutton = function(index)

	if me.button[index] == nil then
		me.button[index] = me.createsidebarbutton(index)
	end
	
	return me.button[index]
	
end

--[[
me.createsidebarbutton(index)
	Creates a new side bar button. The button has will respond to mouse clicks my calling <me.menubuttonclick> with its index.
	
<index>	integer; 1-based index identifying the button

Return:	a Frame
]]
me.createsidebarbutton = function(index)
	
	local frame = mod.gui.createframe(nil, me.button.width, me.button.height, me.background.box, "HIGH")
		
	-- label
	local label = mod.gui.createfontstring(frame, 15, true)
	label:SetAllPoints()
	
	-- click handler
	local callback = 
		function()
			me.menubuttonclick(index)
		end
		
	frame:SetScript("OnMouseDown", callback)
	
	-- attack label to frame
	frame.label = label
	
	-- make clickable
	frame:EnableMouse(true)
	
	-- hide by default
	frame:Hide()
	
	-- return
	return frame
	
end

--[[
me.menubuttonclick(index)
Handles a mouseevent on the side bar.

<index>	integer; identifies the button that was pressed. 0 for the parent button up the top; 1, 2, 3 etc for child buttons.
]]
me.menubuttonclick = function(index)

	if index == 0 then
		-- show parent frame
		me.showsection(me.currentsection.parentid)
		
	elseif index == -1 then
		-- ignore clicks on current frame
		
	else
		-- show child frame
		me.showsection(me.currentsection.children[index].id)
	end
	
end
