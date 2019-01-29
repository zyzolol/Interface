
-- module setup
local me = { name = "menumythreat"}
local mod = thismod
mod[me.name] = me

--[[
Menu\MyThreat.lua

The old "personal" threat table. We make a table listing all your special abilities and their contribution to your threat. It is sorted by total threat.

We use the TableFrame class to make our table.
]]


--[[
me.sorteddata =
{
	[1] = <name>,
	[2] = <name>,
	...
	
	count = 1,
}
]]
me.sorteddata = { }

me.resortdata = function()
	
	local count = 0
	
	for key, value in pairs(mod.table.mydata) do
		
		-- only add non-zero entries or "total"
		if key == mod.string.get("threatsource", "total") or value.threat ~= 0 then
			
			me.addrow(key, value.threat, count)
			count = count + 1
		end
	end
	
	me.sorteddata.count = count
	
	return me.sorteddata, count
	
end

--[[
name = name of the ability (localised)
threat = threat (number)
count = number of valid items in me.sorteddata so far
]]
me.addrow = function(name, threat, count)
	
	for x = 1, count do
		
		-- if we are more than their value, keep going
		if threat > mod.table.mydata[me.sorteddata[x]].threat then
			
		else
			-- shuffle the rest down
			for y = count, x, -1 do
				me.sorteddata[y + 1] = me.sorteddata[y]
			end
			
			-- insert our value
			me.sorteddata[x] = name
			return
		end
	end
	
	me.sorteddata[count + 1] = name
	
end

me.evaluator = function(dataset, columnid, rownumber)
	
	if columnid == "threat" then
		return mod.table.mydata[me.sorteddata[rownumber]].threat
	
	elseif columnid == "name" then
		return me.sorteddata[rownumber]
		
	elseif columnid == "damage" then
		return mod.table.mydata[me.sorteddata[rownumber]].damage	
	
	elseif columnid == "hits" then
		return mod.table.mydata[me.sorteddata[rownumber]].hits
		
	elseif columnid == "percent" then
		
		local maxthreat = math.max(1, mod.table.mydata[me.sorteddata[me.sorteddata.count]].threat)
		
		return 100 * mod.table.mydata[me.sorteddata[rownumber]].threat / maxthreat
	end
	
end

me.onload = function()
	
	-- add frame to the sections list
	me.deferredmainframe = mod.defer.createnew(me.createmainframe)
	mod.helpmenu.registersection("mythreat", nil, mod.string.get("menu", "mythreat", "description"), me.deferredmainframe)
				
end

--[[
me.setupcolumns()

Creates the description of our table. It requires the localisation table, so has to be done at OnLoad. The description is used by the TableFrame class.
]]
me.setupcolumns = function()
	
	me.columns = 
	{
		{
			name = "name",
			text = mod.string.get("gui", "self", "head", "name"),
			width = 120,
			justifyh = "LEFT",
			visible = true,
		},
		{
			name = "hits", 
			text = mod.string.get("gui", "self", "head", "hits"),
			width = 60,
			justifyh = "RIGHT",
			visible = true,
		},
		{
			name = "damage",
			text = mod.string.get("gui", "self", "head", "dam"),
			width = 70,
			justifyh = "RIGHT",
			visible = true,
		},
		{
			name = "threat",
			text = mod.string.get("gui", "self", "head", "threat"),
			width = 70,
			justifyh = "RIGHT",
			visible = true,
		},
		{
			name = "percent",
			text = mod.string.get("gui", "self", "head", "pc"),
			width = 60,
			justifyh = "RIGHT",
			visible = true,
		},
	}
	
end

me.setupmainframe = function()
	
	local oldheight = me.mytable:GetHeight()
	me.mytable:redraw()
	
	local change = me.mytable:GetHeight() - oldheight
	
	me.mainframe:SetHeight(me.mainframe:GetHeight() + change)
	
end

me.createmainframe = function()
	
	-- preliminary: create the columns table
	me.setupcolumns()
	
	local frame, element, offset
	offset = mod.helpmenu.textinset
	
	-- create the top frame
	frame = mod.gui.createframe(mod.frame, mod.helpmenu.defaultwidth, 300, mod.helpmenu.background.frame, "HIGH")
	me.mainframe = frame
	
	-- setup method
	frame.setup = me.setupmainframe

--------------------------------------------------------------------------------
-- 	"Reset" Button, and "Update" Button
--------------------------------------------------------------------------------
	
	element = mod.gui.createbutton(frame, 180, 30, mod.helpmenu.background.button, 15)
	frame.reset = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetText(mod.string.get("menu", "mythreat", "reset"))
	
	element:SetScript("OnClick", 
		function()
			mod.table.resetmytable()
			me.setupmainframe()
		end
	)
	
	element = mod.gui.createbutton(frame, 180, 30, mod.helpmenu.background.button, 15)
	frame.update = element
	
	element:SetPoint("TOPLEFT", frame.reset, "TOPRIGHT", mod.helpmenu.textinset, 0)
	element:SetText(mod.string.get("menu", "mythreat", "update"))
	
	element:SetScript("OnClick", 
		function()
			me.setupmainframe()
		end
	)

	offset = offset + element:GetHeight()
	
	
--------------------------------------------------------------------------------
-- 	TableFrame
--------------------------------------------------------------------------------

	offset = offset + 10

	-- add the new window 
	element = mod.tableframe.createtable(me.columns, 15, 14, mod.gui.backdropcolour, frame, me.resortdata, me.evaluator)
	me.mytable = element
	
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	offset = offset + element:GetHeight()
	
--------------------------------------------------------------------------------
	
	frame:SetWidth(me.mytable:GetWidth() + 2 * mod.helpmenu.textinset)
	
	-- Now size the frame to the string
	frame:SetHeight(mod.helpmenu.textinset + offset)
		
	return frame
	
end