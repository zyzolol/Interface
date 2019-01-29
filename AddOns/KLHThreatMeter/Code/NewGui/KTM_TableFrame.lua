
-- module setup
local me = { name = "tableframe"}
local mod = thismod
mod[me.name] = me

--[[
TableFrame.lua

A class for creating generic tables. When creating a table, you describe the layout of the table, and provide an implentation of a couple of interfaces, and the table does the rest. 

------------------------------------------------------------------------------------
					Creating a TableFrame Instance
------------------------------------------------------------------------------------
	
	mytable = mod.tableframe.createtable(definition, rowspacing, fontsize, backdropcolours, parentframe, datafunction, evalfunction)

<definitions> is a table that describes what columns are in the table. Here's an example:

definitions = 
{
	[1] = 
	{
		name = "ability",
		text = "Ability",
		width = 100,
		justifyh = "LEFT",
		visible = true,
	},
	[2] = 
	{
		name = "threat",
		text = "Threat",
		width = 40,
		justifyh = "RIGHT",
		visible = false,
	},
}

First, <definitions> is an array. Each value in the array describes one column, and the order in the array matches the order in the table, from left to right. In this example the "ability" column is on the left and the "threat" column is on the right.

<name> is an identifier for the column. We'll use it later.
<text> is the actual text displayed at the top of the column.
<width> is the width of the column, in pixels.
<justifyh> is the horizontal justification of the text in the column. Possible values are "LEFT", "CENTER", "RIGHT". Usually you would put "LEFT" for strings and "RIGHT" for numbers.
<visible> is whether or not that column is to be shown (can be changed later).

Now, returning to the constructor:
	
	mytable = mod.tableframe.createtable(definition, rowspacing, fontsize, backdropcolours, parentframe, datafunction, evalfunction)

<rowspacing> is the height of each row, in pixels.
<fontsize> is the size of the font used in all the text. <fontsize> = <rowspacing> - 1 seems to work well.
<backdropcolours> is a table with properties "red", "green", "blue", "alpha" whose values are between 0 and 1. If you're not sure, you could use <mod.helpmenu.background>
<parentframe> is a reference to a Frame. If in doubt, <mod.frame> is good.

<datafunction> is called just before the table is redrawn. It should implement this interface:

	dataset, count = datafunction()
		
<dataset> is a reference to your internal dataset. You might not need this an can return nil.
<count> is the number of rows to draw in the table.

<evalfunction> is called when the table is being redrawn. It is used to determine the actual values in the table. It should implement this interface:

	value = evalfunction(dataset, columnid, rownumber)

<value> is the text or number that will be written to the table
<dataset> is the first return value of <datafunction>. Might not be needed if you have a static reference to your data set.
<columnid> is the <.name> property of a column, as in <definition>.
<rownumber> is a number between 1 and <count>, the second return value of <datafunction>.

------------------------------------------------------------------------------------
					Redrawing and Adjusting Layout
------------------------------------------------------------------------------------

So, all that gets you a frame, <mytable>, which does table stuff. You can adjust the layout of the table by changing the <definition> table and then calling 
	
	mytable:redolayout()

This can't be used to add in new columns, but you can hide them, and adjust the width, and probably orderings too.

To update the table, call

	mytable:redraw()

]]

--[[
mod.tableframe.createtable(definition, rowspacing, fontsize, backdropcolours, parentframe, datafunction, evalfunction)

Creates a new TableFrame instance. 
For detailed comments, check the notes at the top of the file.
]]
me.createtable = function(definition, rowspacing, fontsize, backdropcolours, parentframe, datafunction, evalfunction)
	
	-- 100's are just dummy values to get things started
	local this = mod.gui.createframe(parentframe, 100, 100, backdropcolours)
	
	this.columns = { }	-- this is key / value, key = name of the column, value = column structure
	this.definition = definition
	this.rowspacing = rowspacing
	this.fontsize = fontsize
	
	this.datafunction = datafunction
	this.evalfunction = evalfunction
	
	-- methods
	this.redraw = me.redraw
	this.redolayout = me.redolayout
	
	local x, value, column
	
	for x, value in ipairs(this.definition) do
		this.columns[value.name] = me.createcolumn(value.name, value.text, value.width, this, value.justifyh)
	end
	
	this:redolayout()
	this:SetHeight(mod.gui.border * 2 + this.rowspacing)
	
	return this
end

--[[
me.createcolumn(name, width, spacing, parent, justifyh)
	This is the constructor for the TableColumn object.

<name>		string; identifier of the column. 
<text>		string; localised text at the top of the column.
<width>		number; width of the column.
<table>		frame; the TableFrame instance that this column is part of. 
<justifyh>	string; "CENTER" or "LEFT" or "RIGHT"; the horizontal justification.

Returns: 	TableColumn instance.
]]
me.createcolumn = function(name, text, width, table, justifyh)
	
	local this = 
	{
		["name"] = name,
		["width"] = width,
		["justifyh"] = justifyh,
		["table"] = table,

		-- this is the set of all the rows in this column
		entry = { },
		
		-- add methods:
		setcolumnentry = me.setcolumnentry,
		hidebelow = me.hidebelow,
	}
	
	this.gui = mod.gui.rawcreateframe("Frame", nil, table)
	this.gui:SetWidth(width)
	this.gui:SetHeight(table.rowspacing)
	
	this.gui.heading = mod.gui.createfontstring(this.gui, this.table.fontsize, true)
	this.gui.heading:SetTextColor(1.0, 1.0, 0)
	this.gui.heading:SetText(text)
	this.gui.heading:SetPoint("TOPLEFT", this.gui, "TOPLEFT")
	this.gui.heading:SetWidth(width)
	this.gui.heading:SetJustifyH(justifyh)
	
	return this
end

--[[
tablecolumn:hidebelow(lastrow)
	Hides all the rows below index <lastrow> in the TableColumn. They might not exist.
]]
me.hidebelow = function(this, lastrow)
	
	for x = lastrow + 1, #this.entry do
		this.entry[x]:Hide()
	end
	
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
			newentry = mod.gui.createfontstring(this.gui, this.table.fontsize, true, "OUTLINE")
			newentry:SetShadowColor(0, 0, 0, 0.3)
			newentry:SetPoint("TOPLEFT", this.gui, "TOPLEFT", 0, 1 - x * this.table.rowspacing)
			newentry:SetWidth(this.width)
			newentry:SetJustifyH(this.justifyh)
			newentry:SetTextColor(1.0, 1.0, 1.0)
			
			this.entry[x] = newentry
		end
	end
	
	-- set
	this.entry[row]:SetText(value)
	this.entry[row]:Show()
end

--[[
mytable:redolayout()

Recalculates the layout of the table, e.g. column spacing and visibility.
]]
me.redolayout = function(this)
	
	local offset = mod.gui.border
	
	local x, value
	
	for x, value in ipairs(this.definition) do
		
		if value.visible == true then
			this.columns[value.name].gui:Show()
			this.columns[value.name].gui:SetPoint("TOPLEFT", this, "TOPLEFT", offset, -mod.gui.border)
			offset = offset + value.width
		else
			this.columns[value.name].gui:Hide()
		end
	end
	
	-- width of the combined frame
	this:SetWidth(offset + mod.gui.border)
	
	-- signal we need to redraw
	this:redraw()
end

--[[
mytablframe:redraw()

Updates the values in the table. See the comments at the top of the file for more details.
]]
me.redraw = function(this)
		
	local dataset, numrows = this.datafunction()
	local x, y, column, value
	
	for x = 1, numrows do
		for y, column in ipairs(this.definition) do
			value = this.evalfunction(dataset, column.name, x)
				
			if type(value) == "number" then
				value = mod.raidtable.abbreviateinteger(value)
			end
			
			this.columns[column.name]:setcolumnentry(x, value)
		end
	end
	
	-- we need to hide all the rows below the last one, if they are still shown
	for y, column in ipairs(this.definition) do
		this.columns[column.name]:hidebelow(numrows)
	end
	
	-- resize
	this:SetHeight(mod.gui.border * 2 + (numrows + 1) * this.rowspacing)
	
end