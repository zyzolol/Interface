
-- module setup
local me = { name = "raidtable"}
local mod = thismod
mod[me.name] = me

--[[
Gui\RaidTable.lua

This class draws the threat table for the raid.
]]

--[[
---------------------------------------------------------------------------------------------
			Slash Commands: Simple Table Operations
---------------------------------------------------------------------------------------------
]]

me.myconsole = 
{
	gui = 
	{
		show = function()
			me.setvisible(true)
		end,
		
		hide = function()
			me.setvisible(false)
		end,
		
		reset = "resetposition",
	}
}		

--[[
-- compatability with old methods
]]
me.setvisible = function(value)
	
	if value then
		me.instances[1].gui:Show()
	else
		me.instances[1].gui:Hide()
	end
	
end

me.resetposition = function()
	
	me.instances[1].gui.header:ClearAllPoints()
	me.instances[1].gui.header:SetPoint("TOPLEFT", nil, "TOPLEFT", 500 / me.save[1].scale, -400 / me.save[1].scale)
	
        me.save[1].position.anchor = "TOPLEFT"
	me.save[1].position.x = 500
	me.save[1].position.y = -400
	
end

---------------------------------------------------------------------------------------------


me.updateview = function()
	
	if me.isloaded then
		me.needsdraw = true
		me.updatedraw()
	end
	
end 

me.myonupdates = 
{
	updatedraw = 0.25,
	updateautohide = 0.1,
}

me.needsdraw = true
me.lastdraw = 0

me.updatedraw = function()
	
	-- TODO: fix. Determine when to refresh and stuff.
	me.instances[1]:rendertable2(mod.datasource)
	
	-- TODO: allow
	do return end
	
	if me.needsdraw == true and (GetTime() > me.lastdraw + 0.2) then
		me.instances[1]:rendertable(mod.table.raiddata, mod.table.tpsdata, mod.table.raidclasses, mod.tank.determinemaintank())
		me.needsdraw = false
		me.lastdraw = GetTime()
	end
	
end

--[[
---------------------------------------------------------------------------------------------
		Autohide Feature: Show / Hide the window when you join / leave a raid
---------------------------------------------------------------------------------------------
]]

me.grouptype = "unknown" -- or "party", "raid", "none"

-- poll time: 0.1s. Minimal amount of work.
me.updateautohide = function()
		
	if GetNumRaidMembers() > 0 then
		
		-- we're in a raid
		if me.grouptype ~= "raid" then
			me.grouptype = "raid"
			
			if me.save.autohide.joinraid then
				me.setvisible(true)
			end
		end
	
	elseif GetNumPartyMembers() > 0 then
		
		-- we're in a party
		if me.grouptype ~= "party" then
			me.grouptype = "party"
			
			if me.save.autohide.joinparty then
				me.setvisible(true)
			end
		end
		
	else
		-- we're not in a group
		if me.grouptype ~= "none" then
			me.grouptype = "none"
			
			if me.save.autohide.leavegroup then
				me.setvisible(false)
			end
		end
	end
	
end


--[[
------------------------------------------------------------------------
						Shared Data
------------------------------------------------------------------------
]]

me.numframes = 1

me.save = 
{
	-- Here are options for all frames
	scale = 1.0,				-- to change the size of just the raid window
	resize = true,				-- whether the table should compress when there are few people in it
	aggrogain = true,			-- show when you will pull aggro from the tank
	tankregain = false,		-- if dps stay below this value, tank will regain aggro after a fear
	columns =
	{
		threat = true,			-- draw "threat" column
		persecond = true,		-- draw "threat per second" column
		percent = true,		-- draw "threat %" column
	},
	autohide = 
	{
		leavegroup = false,
		joinparty = false,
		joinraid = false,
	},
	override_lockwindow = 232,
	lockwindow = false,		-- prevent dragging
	
	[1] = 
	{
		anchor = "topleft",
		alpha = 1.0,
		scale = 1.0,
		colour = { r = 0.4, g = 0.4, b = 1.0 },	-- washed out light blue
		textmajorcolour = { r = 1.0, g = 1.0, b = 0.0 }, -- yellow
		textminorcolour = { r = 1.0, g = 1.0, b = 1.0 }, -- white
		position = 
		{
                        anchor = "topleft",
			x = 340,
			y = -340,
		},
		length = 10,
		class = 
		{
			warrior = true, warlock = true, mage = true, druid = true, rogue = true, hunter = true, priest = true, paladin = true, shaman = true,
		},
	},
	[2] = 
	{
		anchor = "topright",
		alpha = 1.0,
		scale = 1.0,
		colour = { r = 0.4, g = 1.0, b = 0.4 },	-- washed out green
		textmajorcolour = { r = 1.0, g = 1.0, b = 0.0 }, -- yellow
		textminorcolour = { r = 1.0, g = 1.0, b = 1.0 }, -- white
		length = 10,
		position = 
		{
                        anchor = "topleft",
			x = 500,
			y = -340,
		},
		class = 
		{
			warrior = true, warlock = true, mage = true, druid = true, rogue = true, hunter = true, priest = true, paladin = true, shaman = true,
		},
	},
	[3] = 
	{
		anchor = "bottomleft",
		alpha = 1.0,
		scale = 1.0,
		colour = { r = 1.0, g = 0.4, b = 0.4 },	-- washed out red
		textmajorcolour = { r = 1.0, g = 1.0, b = 0.0 }, -- yellow
		textminorcolour = { r = 1.0, g = 1.0, b = 1.0 }, -- white
		length = 10,
		position = 
		{
                        anchor = "topleft",
			x = 340,
			y = -370,
		},
		class = 
		{
			warrior = true, warlock = true, mage = true, druid = true, rogue = true, hunter = true, priest = true, paladin = true, shaman = true,
		},
	},
	[4] = 
	{
		anchor = "bottomright",
		alpha = 1.0,
		scale = 1.0,
		colour = { r = 0.8, g = 0.8, b = 0.8 },	-- silver grey
		textmajorcolour = { r = 1.0, g = 1.0, b = 0.0 }, -- yellow
		textminorcolour = { r = 1.0, g = 1.0, b = 1.0 }, -- white
		length = 10,
		position = 
		{
                        anchor = "topleft",
			x = 500,
			y = -370,
		},
		class = 
		{
			warrior = true, warlock = true, mage = true, druid = true, rogue = true, hunter = true, priest = true, paladin = true, shaman = true,
		},
	},
}	

-- Special OnLoad method called by Core.lua
me.onload = function()
		
	local x, item, anchor
		
	for x = 1, me.numframes do
		
		-- create
		item = me.createinstance()
		
		-- apply saved colour scheme
		item:setcolour(me.save[x].colour.r, me.save[x].colour.g, me.save[x].colour.b)
		item:setminortextcolour(me.save[x].textminorcolour.r, me.save[x].textminorcolour.g, me.save[x].textminorcolour.b)
		item:setmajortextcolour(me.save[x].textmajorcolour.r, me.save[x].textmajorcolour.g, me.save[x].textmajorcolour.b)	
		item.gui:SetAlpha(me.save[x].alpha)
		
		-- apply saved scale
		item.gui:SetScale(me.save[x].scale)
		
		-- apply saved position
		item.gui.header:ClearAllPoints()
		item.gui.header:SetPoint(me.save[x].position.anchor, nil, me.save[x].position.anchor, me.save[x].position.x , me.save[x].position.y)
				
	end
	
	me.isloaded = true
end

--[[
------------------------------------------------------------------------
					Instance Setup
------------------------------------------------------------------------

The structure is

this = 
{
	gui = [Frame]
	{
		header = [Frame]
		{
			(components of header)
		}
	},
	
	id = (number),
	
	(some instance methods here)
	
	lastupdate = (time),

]]

me.instances = { }  -- numbered list

me.createinstance = function()
	
	local id = 1 + table.getn(me.instances)
	
	local this = 
	{
		["id"] = id,
		lastupdate = 0,
		table = { length = 0, },
				
		-- methods
		creategui = me.creategui,
		setcolour = me.setcolour,
		maximise = me.maximise,
		minimise = me.minimise,
		
		drawtext = me.drawtext,
		inserttolist = me.inserttolist,
		rendertable = me.rendertable,
		rendertable2 = me.rendertable2,
		reanchortable = me.reanchortable,
		redosubtablelayout = me.redosubtablelayout,
		drawbars = me.drawbars,
		
		setminortextcolour = me.setminortextcolour,
		setmajortextcolour = me.setmajortextcolour,
	}
	
	table.insert(me.instances, this)
	
	this:creategui()
		
	return this
	
end

--[[
------------------------------------------------------------------------
						Instance Methods
------------------------------------------------------------------------
]]


me.creategui = function(this)

	-- wrapper frame
	this.gui = mod.gui.rawcreateframe("Frame", nil, mod.loader.frame)
	this.gui:SetWidth(1)
	this.gui:SetHeight(1)
	this.gui:SetPoint("CENTER", UIParent)
	
	------------------------------------------------------------------------
	-- 				header
	------------------------------------------------------------------------
	
	this.gui.header = mod.gui.createframe(this.gui, 160, 36, mod.gui.backdropcolor)
	this.gui.header:SetPoint("CENTER", this.gui)
	
	-- identifier string
	this.gui.header.identifier = mod.gui.createframe(this.gui.header, 20, 20)	
	this.gui.header.identifier.text = mod.gui.createfontstring(this.gui.header.identifier, 14, true)
	this.gui.header.identifier.text:SetPoint("CENTER", -1, 0)
	this.gui.header.identifier.text:SetText(this.id)
	this.gui.header.identifier:SetPoint("BOTTOMLEFT", 2, 2)
	
	-- master target string
	this.gui.header.target = mod.gui.createfontstring(this.gui.header, 12, true)
	this.gui.header.target:SetJustifyH("LEFT")
	this.gui.header.target:SetPoint("TOPLEFT", 4, -3)
	this.gui.header.target:SetPoint("TOPRIGHT", -3, -3)
	
	-- position string
	this.gui.header.position = mod.gui.createfontstring(this.gui.header, 12, true)
	this.gui.header.position:SetJustifyH("LEFT")
	this.gui.header.position:SetPoint("LEFT", this.gui.header.identifier, "RIGHT", -2, 0)
	
	-- close button
	this.gui.header.close = mod.gui.createframe(this.gui.header, 20, 20)
	this.gui.header.close.button = mod.gui.createbutton(this.gui.header.close, 12, 12, true)
	this.gui.header.close.button:SetPoint("CENTER", this.gui.header.close)
	this.gui.header.close:SetPoint("BOTTOMRIGHT", this.gui.header, "BOTTOMRIGHT", -3, 2)

	this.gui.header.close.button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	this.gui.header.close.button:GetNormalTexture():SetTexCoord(0.25, 0.70, 0.25, 0.75)
	this.gui.header.close.button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	this.gui.header.close.button:GetPushedTexture():SetTexCoord(0.25, 0.70, 0.25, 0.75)
	this.gui.header.close.button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	this.gui.header.close.button:GetHighlightTexture():SetBlendMode("ADD")
	this.gui.header.close.button:GetHighlightTexture():SetTexCoord(0, 1.0, -0.1, 1.1)
	
	-- event handlers
	me.createframeeventhandler("OnClick", this.id, this.gui.header.close.button, "close")
	me.createframeeventhandler("OnEnter", this.id, this.gui.header.close.button, "close")
	me.createframeeventhandler("OnLeave", this.id, this.gui.header.close.button, "close")
	
	-- minimise button
	this.gui.header.minimise = mod.gui.createframe(this.gui.header, 20, 20)
	this.gui.header.minimise.button = mod.gui.createbutton(this.gui.header.minimise, 12, 12, true)
	this.gui.header.minimise.button:SetPoint("CENTER", this.gui.header.minimise)
	this.gui.header.minimise:SetPoint("RIGHT", this.gui.header.close, "LEFT", 3, 0)
	
	-- textures
	this.gui.header.minimise.button:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP")
	this.gui.header.minimise.button:GetNormalTexture():SetTexCoord(0.2, 0.8, 0.25, 0.8)
	this.gui.header.minimise.button:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN")
	this.gui.header.minimise.button:GetPushedTexture():SetTexCoord(0.2, 0.8, 0.25, 0.8)
	this.gui.header.minimise.button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	this.gui.header.minimise.button:GetHighlightTexture():SetBlendMode("ADD")
	this.gui.header.minimise.button:GetHighlightTexture():SetTexCoord(0, 1.0, -0.1, 1.1)
	
	-- event handlers
	me.createframeeventhandler("OnClick", this.id, this.gui.header.minimise.button, "minimise")
	me.createframeeventhandler("OnEnter", this.id, this.gui.header.minimise.button, "minimise")
	me.createframeeventhandler("OnLeave", this.id, this.gui.header.minimise.button, "minimise")
	
	-- options button
	this.gui.header.options = mod.gui.createframe(this.gui.header, 20, 20)
	this.gui.header.options.button = mod.gui.createbutton(this.gui.header.options, 12, 12, true)
	this.gui.header.options.button:SetPoint("CENTER", this.gui.header.options)
	this.gui.header.options:SetPoint("RIGHT", this.gui.header.minimise, "LEFT", 3, 0)
	
	-- textures
	this.gui.header.options.button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-Chat-Up")
	this.gui.header.options.button:GetNormalTexture():SetTexCoord(0.2, 0.8, 0.2, 0.8)
	this.gui.header.options.button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-Chat-Down")
	this.gui.header.options.button:GetPushedTexture():SetTexCoord(0.2, 0.8, 0.2, 0.8)
	this.gui.header.options.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	this.gui.header.options.button:GetHighlightTexture():SetBlendMode("ADD")
	this.gui.header.options.button:GetHighlightTexture():SetTexCoord(0.2, 0.8, 0.2, 0.8)
	
	-- event handlers
	me.createframeeventhandler("OnClick", this.id, this.gui.header.options.button, "options")
	me.createframeeventhandler("OnEnter", this.id, this.gui.header.options.button, "options")
	me.createframeeventhandler("OnLeave", this.id, this.gui.header.options.button, "options")
	
	-- mastertarget button
	this.gui.header.setmt = mod.gui.createframe(this.gui.header, 20, 20)
	this.gui.header.setmt.button = mod.gui.createbutton(this.gui.header.setmt, 12, 12, true)
	this.gui.header.setmt.button:SetPoint("CENTER", this.gui.header.setmt)
	this.gui.header.setmt:SetPoint("RIGHT", this.gui.header.options, "LEFT", 3, 0)
	
	-- textures
	this.gui.header.setmt.button:SetNormalTexture("Interface\\Icons\\Ability_Hunter_SniperShot")
	this.gui.header.setmt.button:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	this.gui.header.setmt.button:SetPushedTexture("Interface\\Icons\\Ability_Hunter_SniperShot")
	this.gui.header.setmt.button:GetPushedTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	this.gui.header.setmt.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	this.gui.header.setmt.button:GetHighlightTexture():SetBlendMode("ADD")
	this.gui.header.setmt.button:GetHighlightTexture():SetTexCoord(0.2, 0.8, 0.2, 0.8)
	
	-- event handlers
	me.createframeeventhandler("OnClick", this.id, this.gui.header.setmt.button, "setmt")
	me.createframeeventhandler("OnEnter", this.id, this.gui.header.setmt.button, "setmt")
	me.createframeeventhandler("OnLeave", this.id, this.gui.header.setmt.button, "setmt")
	
	-- enable dragging of header
	this.gui.header:SetMovable("true")
	this.gui.header:RegisterForDrag("LeftButton")
	this.gui.header:EnableMouse()
	me.createframeeventhandler("OnDragStart", this.id, this.gui.header, "header")
	me.createframeeventhandler("OnDragStop", this.id, this.gui.header, "header")
	
	------------------------------------------------------------------------
	-- 				table
	------------------------------------------------------------------------
	
	this.gui.table = mod.gui.createframe(this.gui, 160, 36, mod.gui.backdropcolor)
	this:reanchortable()
	
	-- create some columns
 	this.gui.table.name = me.createcolumn(this, mod.string.get("raidtable", "column", "name"), me.columns.name, me.rowspacing, this.gui.table, "LEFT")
	this.gui.table.threat = me.createcolumn(this, mod.string.get("raidtable", "column", "threat"), me.columns.threat, me.rowspacing, this.gui.table, "RIGHT")
	this.gui.table.percent = me.createcolumn(this, mod.string.get("raidtable", "column", "percent"), me.columns.percent, me.rowspacing, this.gui.table, "RIGHT")
	this.gui.table.persecond = me.createcolumn(this, mod.string.get("raidtable", "column", "persecond"), me.columns.persecond, me.rowspacing, this.gui.table, "RIGHT")

	-- bars (don't create them yet)
	this.gui.table.bars = { }

	-- redo table width and height
	this:redosubtablelayout()
	this.gui.table:SetHeight(mod.gui.border * 2 + me.rowspacing)
	
end

--[[
myraidtable:setcolour(red, green, blue)
	Changes the colour scheme of the window. We change the colour of all the backdrop borders.
]]
me.setcolour = function(this, red, green, blue)
	
	this.gui.header:SetBackdropBorderColor(red, green, blue)
	
	me.setframeborder(this.gui.header.identifier, red, green, blue)
	me.setframeborder(this.gui.header.close, red, green, blue)
	me.setframeborder(this.gui.header.options, red, green, blue)
	me.setframeborder(this.gui.header.minimise, red, green, blue)
	me.setframeborder(this.gui.header.setmt, red, green, blue)
	
	this.gui.table:SetBackdropBorderColor(red, green, blue)
end

me.setframeborder = function(frame, red, green, blue)
	
	frame:SetBackdropBorderColor(red, green, blue)
	frame:SetBackdropColor(red, green, blue)
	
end

me.setmajortextcolour = function(this, red, green, blue)
	
	this.gui.header.position:SetTextColor(red, green, blue)
	
	for name, _ in pairs(me.columns) do
		this.gui.table[name].gui.heading:SetTextColor(red, green, blue)
	end
	
end

me.setminortextcolour = function(this, red, green, blue)
	
	this.gui.header.identifier.text:SetTextColor(red, green, blue)
	this.gui.header.target:SetTextColor(red, green, blue)
	
	for name, _ in pairs(me.columns) do
		
		for _, label in pairs(this.gui.table[name].entry) do
			label:SetTextColor(red, green, blue)
		end
	end
	
end

-- call this if you change the visibility of one of the columns
me.redosubtablelayout = function(this)
	
	local offset = mod.gui.border
	
	-- name column is always shown
	this.gui.table.name.gui:SetPoint("TOPLEFT", this.gui.table, "TOPLEFT", offset, -mod.gui.border)
	offset = offset + me.columns.name
	
	-- threat column
	if me.save.columns.threat == true then
		this.gui.table.threat.gui:Show()
		this.gui.table.threat.gui:SetPoint("TOPLEFT", this.gui.table, "TOPLEFT", offset, -mod.gui.border)
		offset = offset + me.columns.threat
	else
		this.gui.table.threat.gui:Hide()
	end
	
	-- percent column
	if me.save.columns.percent == true then
		this.gui.table.percent.gui:Show()
		this.gui.table.percent.gui:SetPoint("TOPLEFT", this.gui.table, "TOPLEFT", offset, -mod.gui.border)
		offset = offset + me.columns.percent
	else
		this.gui.table.percent.gui:Hide()
	end
	
	-- persecond column
	if me.save.columns.persecond == true then
		this.gui.table.persecond.gui:Show()
		this.gui.table.persecond.gui:SetPoint("TOPLEFT", this.gui.table, "TOPLEFT", offset, -mod.gui.border)
		offset = offset + me.columns.persecond
	else
		this.gui.table.persecond.gui:Hide()
	end
	
	-- width of the combined frame
	this.gui.table:SetWidth(offset + mod.gui.border)
	
	-- redraw bars
	-- TODO: fix this - making bug. we don't have any data anymore so we can't call it!
	--this:drawbars()	
	
	-- signal we need to redraw
	me.updateview()
end

-- call this if you change the anchor point of the frame
me.reanchortable = function(this)
	
	this.gui.table:ClearAllPoints()
	
	if me.save[this.id].anchor == "topleft" then
		this.gui.table:SetPoint("TOPLEFT", this.gui.header, "BOTTOMLEFT", 0, mod.gui.border)
	
	elseif me.save[this.id].anchor == "topright" then
		this.gui.table:SetPoint("TOPRIGHT", this.gui.header, "BOTTOMRIGHT", 0, mod.gui.border)
		
	elseif me.save[this.id].anchor == "bottomleft" then
		this.gui.table:SetPoint("BOTTOMLEFT", this.gui.header, "TOPLEFT", 0, - mod.gui.border)
		
	elseif me.save[this.id].anchor == "bottomright" then
		this.gui.table:SetPoint("BOTTOMRIGHT", this.gui.header, "TOPRIGHT", 0, - mod.gui.border)
	end
	
	-- signal we need to redraw
	me.updateview()
	
end

--[[
------------------------------------------------------------------------------------------
									TableColumn Class
------------------------------------------------------------------------------------------

This handles the widgets for the text entries in the table. Instead of storing entries in rows, we store them in columns. The size of a column is increased dynamically at runtime as more entries are required. A finished TableColumn instance might look like

{
	name = "percent",
	width = 40,
	spacing = 13,
	justifyh = "RIGHT",
	raidtable = (RaidTable instance),

	gui = (Frame)
	{
		heading = (FontString)
	},
	
	entry = (array of FontStrings)
	{
		[1] = (FontString),
		[2] = (FontString),
		...
	}
]]

-- These are the widths of the columns, in screen units (almost pixels)
me.columns = 
{
	name = 90,
	threat = 45,
	percent = 42,
	persecond = 40,
}

-- This is the height of each row
me.rowspacing = 13

--[[
me.createcolumn(raidtable, name, width, spacing, parent, justifyh)
	This is the constructor for the TableColumn class. It returns a table with functions and variables.

<raidtable>	raidtable; the instance to which this column belongs	
<name>		string; name of the column. Should match one of the keys in <me.columns>
<width>		number; width of the column. Usually = <me.columns[<name>]>
<spacing>	number; height of the entries in a column. Usually <me.rowspacing>.
<parent>		frame; container of a bunch of columns. Usually = <x.gui.table> for some RaidTable <x>.
<justifyh>	string; "CENTER" or "LEFT" or "RIGHT"; the horizontal justification.
]]
me.createcolumn = function(raidtable, name, width, spacing, parent, justifyh)
	
	local this = 
	{
		["name"] = name,
		["width"] = width,
		["spacing"] = spacing,
		["justifyh"] = justifyh,
		["raidtable"] = raidtable,

		entry = { },
		
		-- add methods:
		setcolumnentry = me.setcolumnentry,
	}
	
	this.gui = mod.gui.rawcreateframe("Frame", nil, parent)
	this.gui:SetWidth(width)
	this.gui:SetHeight(spacing)
	
	this.gui.heading = mod.gui.createfontstring(this.gui, 12, true)
	this.gui.heading:SetTextColor(1.0, 1.0, 0)
	this.gui.heading:SetText(name)
	this.gui.heading:SetPoint("TOPLEFT", this.gui, "TOPLEFT")
	this.gui.heading:SetWidth(width)
	this.gui.heading:SetJustifyH(justifyh)
	
	return this
end

--[[
tablecolumn:setcolumnentry(row, value)
	Use this method to set the text of one of the entries in a column. Since the column generates new entries at runtime, it is not guaranteed that entry <row> will exist. If not this method will create it. Also it will :Show the FontString that is changed.
	
<row>		integer; index of the row to be changed
<value>	string; text to show in the entry.
]]
me.setcolumnentry = function(this, row, value)
	
	-- does entry <row> exist?
	if row > #this.entry then
		
		local newentry
		
		-- create all the missing entries
		for x = #this.entry + 1, row do
			newentry = mod.gui.createfontstring(this.gui, 12, true, "OUTLINE")
			newentry:SetShadowColor(0, 0, 0, 0.3)
			
			if this.justifyh == "RIGHT" then
				newentry:SetPoint("TOPRIGHT", this.gui, "TOPLEFT", this.width, 1 - x * this.spacing)
			else
				newentry:SetPoint("TOPLEFT", this.gui, "TOPLEFT", 0, 1 - x * this.spacing)
			end
			
			-- newentry:SetWidth(this.width)
			newentry:SetJustifyH(this.justifyh)
			newentry:SetTextColor(me.save[this.raidtable.id].textminorcolour.r, me.save[this.raidtable.id].textminorcolour.g, me.save[this.raidtable.id].textminorcolour.b)
			
			this.entry[x] = newentry
		end
	end
	
	-- set
	this.entry[row]:SetText(value)
	this.entry[row]:Show()
end

--[[
------------------------------------------------------------------------------------------
							Event Handlers For RaidTable Widgets
------------------------------------------------------------------------------------------

The basic idea is to funnel all widget events from all RaidTable instances into one method, <me.frameevent>, in a convenient manner. The information we have to provide is
1) What instance of RaidTable the event came from
2) Which widget fired the event
3) What the event was.

To do this, call the <me.createframeeventhandler> method. The main difficulty is that the Event is raised in the global namespace, so that the local <me> reference isn't visible - we don't know how to access it from the global namespace. We use the loadstring to make a custom piece of code for each event that will call <me.frameevent> from the global namespace with the right arguments.
]]

--[[
me.createframeeventhandler(script, tableid, frame, framename)
Extension of the SetScript method for a RaidTable frame. The event will be sent to the <me.frameevent> method.

<script> 	string; the first argument to SetScript, e.g. "OnLeave", "OnClick" etc
<tableid> 	integer; the id of the RaidTable that the frame belongs to, it should be <this.id> in the calling scope
<frame> 		frame; the operand of SetScript, a widget in the RaidTable
<framename> string; the name of the widget e.g. "close" for the close button
]]
me.createframeeventhandler = function(script, tableid, frame, framename)
	
	-- TODO: this is fucking retarded. lern 2 upvalue lol.
	
	-- methodtext might come out as e.g. 'klhtm.raidtable.frameevent(1, "close", "OnClick")'
	local methodtext = string.format("%s.%s.frameevent(%s, \"%s\", \"%s\")", mod.namespace, me.name, tableid, framename, script)
	
	local method = loadstring(methodtext)
		
	frame:SetScript(script, method)
	
end

--[[
me.frameevent(index, name, script)
This is our handler for frame events.

<index> identifies which RaidTable instance generated the event (namely, <me.instances[index]>)
<name> is the name of the Frame that fired
<script> is the event handler, e.g. "OnClick", "OnEnter"
]]
me.frameevent = function(index, name, script)
	
	if script == "OnEnter" then
		
		-- make a tooltip
		local header, body
		
		header = mod.string.tryget("raidtable", "tooltip", name)
		
		if header == nil then
			header = name
			body = "???"
			
		else
			body = mod.string.get("raidtable", "tooltip", name .. "text")
		end
		
		mod.gui.tooltip(this, header, body)
	
	elseif script == "OnLeave" then
		GameTooltip:Hide()
		
	elseif script == "OnClick" then
		
		if name == "options" then
			mod.helpmenu.showsection("raidtable")
			
		elseif name == "close" then
			me.instances[index].gui:Hide()
			
		elseif name == "minimise" then
			
			if me.instances[index].gui.table:IsVisible() then
				me.instances[index].gui.table:Hide()
			else
				me.instances[index].gui.table:Show()
			end
			
		elseif name == "setmt" then
			mod.target.sendmastertarget()
		end
		
	elseif script == "OnDragStart" then
		
		-- prevent drag if the user has disabled it
		if me.save.lockwindow == false then
			
			this:StartMoving()
		end
		
	elseif script == "OnDragStop" then
		
		-- prevent drag if the user has disabled it
		if me.save.lockwindow == false then
			
			this:StopMovingOrSizing()
		
			local anchor, _, _, x, y = this:GetPoint(1)
			
			me.save[index].position.anchor = anchor
			me.save[index].position.x = x
			me.save[index].position.y = y
		end
	end
	
end

--[[
------------------------------------------------------------------------------------------------
									Rendering a Raid Threat Table
------------------------------------------------------------------------------------------------
]]

--[[
raidtable:rendertable2(dataprovider)

TODO: split and comment.

e.g. 
	me.instances[1]:rendertable2(mod.datasource)
]]
me.rendertable2 = function(this, dataprovider)
	
	-- set name (TODO: should be OR threat position / offset)
	local text = mod.global.abbreviation .. " " .. mod.global.release .. "." .. mod.global.revision
	this.gui.header.position:SetText(text)
	
	-- Try to get a data set
	local mobguid, dataset = dataprovider.getdefaultdataset()
	
	-- If provider can't make one, bail out
	if dataset == nil then
		me.cleartable(this)
		return
	end
	
	-- render target name
	if mobguid then
		this.gui.header.target:SetText(dataset.mobname)
		this.gui.header:SetHeight(36)
	end
	
	-- find how many rows pass the filter, also whether we pass it
	local selfdatarowindex	-- index pointing to our own data (used a bit below)
	local validrows = mod.garbage.gettable() -- { }: list of indexes
	local selfname = UnitName("player")
		
	for index, datarow in ipairs(dataset.threat) do
		
		-- threat must be > 0 to be valid
		if datarow.threat > 0 then
		
			-- do not check self data against class filters
			if datarow.playername == selfname then
				
				selfdatarowindex = index
				table.insert(validrows, index)
				
			-- check class filters
			elseif me.save[this.id].class[datarow.class] ~= false then
				
				table.insert(validrows, index)
			end
			
		end
	end
	
	-- get rendered length
	local numrowsdrawn = math.min(#validrows, me.save[this.id].length)
	
	-- insert player down bottom if player exists but it is below the last drawn row
	if selfdatarowindex and validrows[numrowsdrawn] < selfdatarowindex then
		
		local selfdata = dataset.threat[selfdatarowindex]
		local enddata = dataset.threat[numrowsdrawn]
		
		enddata.playername = selfdata.playername
		enddata.threat = selfdata.threat
		enddata.tps = selfdata.tps
	end
	
	-- extract the drawn rows to new table
	local drawndata = mod.garbage.gettable()
	
	for x = 1, numrowsdrawn do
		table.insert(drawndata, dataset.threat[validrows[x]])
	end
	
	me.draw(this, drawndata)
	
	-- recycle
	mod.garbage.recycle(validrows)
	mod.garbage.recycle(drawndata)
	mod.garbage.recycle(dataset)
	
end

--[[
render method has prepped a data set direct for drawing. do eet!
]]
me.draw = function(this, drawndata)
	
	local x, datarow
	
	for x = 1, #drawndata do
		
		datarow = drawndata[x]
		
		this.gui.table.name:setcolumnentry(x, datarow.playername)
		this.gui.table.threat:setcolumnentry(x, me.abbreviateinteger(datarow.threat))
		this.gui.table.percent:setcolumnentry(x, me.abbreviateinteger(datarow.percent))
		this.gui.table.persecond:setcolumnentry(x, me.abbreviateinteger(datarow.tps))
	
	end
		
	-- hide unneeded texts
	local column
	
	for key, _ in pairs(me.columns) do
		column = this.gui.table[key]
		
		for x = #drawndata + 1, #column.entry do
			column.entry[x]:Hide()
		end
	end
	
	-- now cleaning up
	-- 1) recalculate height of table
	-- 2) make lower rows invisible if applicable
	
	local rowsvisible = #drawndata + 1 -- the +1 is for the column headers
	
	if me.save.resize == false then
		rowsvisible = 1 + me.save[this.id].length
	end
	
	this.gui.table:SetHeight(mod.gui.border * 2 + rowsvisible * me.rowspacing)
		
	-- bars
	me.drawbars(this, drawndata)
		
end

--[[
raidtable:drawbars()
	This draws the bars in the background of the table that represent the relative threat of players. The person with the highest threat will have a full bar, stretching from the left edge to the right one. Other players' bars will start from the left but not be as long. The width of your bar is proportional to your threat.
]]
me.drawbars = function(this, drawndata)
	
	local red, green, blue, maxwidth, datarow
		
	for x = 1, #drawndata do
		
		datarow = drawndata[x]
		
		-- 1) create the bar if it doesn't exist
		if this.gui.table.bars[x] == nil then
			this.gui.table.bars[x] = this.gui.table:CreateTexture()
			this.gui.table.bars[x]:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
			this.gui.table.bars[x]:SetPoint("TOPLEFT", this.gui.table, "TOPLEFT", 1 + mod.gui.border, 1 - mod.gui.border -x * me.rowspacing)
			this.gui.table.bars[x]:SetHeight(me.rowspacing)
		end
		
		-- 2) set the colour
		if datarow.playername == UnitName("player") then
			red = 1
			green = 0
			blue = 0
			
		elseif datarow.class and RAID_CLASS_COLORS[string.upper(datarow.class)] then
			red = RAID_CLASS_COLORS[string.upper(datarow.class)].r
			green = RAID_CLASS_COLORS[string.upper(datarow.class)].g
			blue = RAID_CLASS_COLORS[string.upper(datarow.class)].b
		
		elseif datarow.class == "aggro" then
			red = 0
			green = 0
			blue = 1
		
		else -- this is like "unknown". NOTE: this includes "pet"!
			red = 0.5
			green = 0.5
			blue = 0.5
		end
		
		this.gui.table.bars[x]:SetVertexColor(red, green, blue)
		this.gui.table.bars[x]:Show()
		
		-- 3) set width
		-- for now, just go 100%
		maxwidth = this.gui.table:GetWidth() - 2 * mod.gui.border - 2
		this.gui.table.bars[x]:SetWidth(maxwidth * datarow.threat / drawndata[1].threat)
		
	end
	
	-- hide unneeded bars
	for x = #drawndata + 1, #this.gui.table.bars do
		this.gui.table.bars[x]:Hide()
	end

end

--[[
TODO
call if table is empty
]]
me.cleartable = function(this)
	
	this.gui.header.target:SetText("")
	this.gui.header:SetHeight(24)
	
	-- hide unneeded texts
	local column
	local numrowsdrawn = 0
	
	for key, _ in pairs(me.columns) do
		column = this.gui.table[key]
		
		for x = numrowsdrawn + 1, #column.entry do
			column.entry[x]:Hide()
		end
	end
	
	local rowsvisible = 0 + 1 -- the +1 is for the column headers
	
	if me.save.resize == false then
		rowsvisible = 1 + me.save[this.id].length
	end
	
	-- hide unneeded bars
	for x = 1, #this.gui.table.bars do
		this.gui.table.bars[x]:Hide()
	end
	
	this.gui.table:SetHeight(mod.gui.border * 2 + rowsvisible * me.rowspacing)
	
end


--[[
me.getthreattextcolour(ratio)

Gives a colour description string for the <position> fontstring on the header. <ratio> is the ratio of the tank's threat to the #2 threat, i.e. between 0 and 1. The basic idea is if the tank has heaps of threat, the colour is green, if the dps are close, it's yellow, and if they are really close, it's red.

An example of a return value is "|cffff0000" (red).
]]
me.getthreattextcolour = function(ratio)
	
	-- the first step is to get values for green and red, from 0 to 255.
	local red, green
	
	if ratio < 0.5 then
		green = 255
		red = 0
		
	elseif ratio < 0.75 then
		green = 255
		red = 255 * (ratio - 0.5) / 0.25
		
	else
		red = 255
		green = 255 * (1.0 - ratio) / 0.25
	end
	
	--[[ %02x:
	%x = print number as hexadecimal
	0  = pad with zeroes if it is small
	2  = number of digits desired (rest = pad)
	]]
	return string.format("|cff%02x%02x00", red, green)
		
end



--[[
me.abbreviateinteger(value)
Abbreviates a large integer, giving at least 3 digit accuracy. Actually, it works for floats too (rounds first). It will handle values below 1 billion gracefully.
]]
me.abbreviateinteger = function(value)
	
	-- nil --> 0
	value = value or 0
	
	-- round to integer
	value = math.floor(0.5 + value)
	
	local output = ""
	
	if value < 0 then
		output = "-"
		value = -value
	end
	
	-- 1 to 10k - 1 ("1" to "9999")
	if value < 10000 then
		output = output .. value
		
	-- 10k to 100k - 1 ("10.0k" to "99.9k")
	elseif value < 100000 then
		output = output .. math.floor(value / 100) / 10
		
		if math.fmod(output, 1) == 0 then
			output = output .. ".0"
		end
		
		output = output .. "k"
	
	-- 100k to 10M - 1 ("100k" to "9999k")
	elseif value < 10000000 then
		output = output .. math.floor(value / 1000) .. "k";
		
	-- 10M to 100M - 1 ("10.0M" to "99.9M")
	elseif value < 100000000 then
		output = output .. math.floor(value / 100000) / 10
		
		if math.fmod(output, 1) == 0 then
			output = output .. ".0"
		end
		
		output = output .. "M"
	
	-- 100M +
	else
		output = output .. math.floor(value / 1000000) .. "M";
	end
	
	return output
end

