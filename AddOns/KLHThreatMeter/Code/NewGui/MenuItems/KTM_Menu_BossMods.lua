
local me = { name = "menuboss"}
local mod = thismod
mod[me.name] = me

me.onload = function()
	
	-- main frame
	me.deferredmainframe = mod.defer.createnew(me.createmainframe)
	mod.helpmenu.registersection("bossmod", nil, mod.string.get("menu", "bossmod", "description"), me.deferredmainframe)
	
	-- built-in frame
	me.deferredbuiltinframe = mod.defer.createnew(me.createbuiltinframe)
	mod.helpmenu.registersection("bossmod-builtin", "bossmod", mod.string.get("menu", "bossmod", "builtin", "description"), me.deferredbuiltinframe)
	
	-- user made frame
	me.deferredusermadeframe = mod.defer.createnew(me.createusermadeframe)
	mod.helpmenu.registersection("bossmod-usermade", "bossmod", mod.string.get("menu", "bossmod", "usermade", "description"), me.deferredusermadeframe)
		
end

me.createmainframe = function()
	
	local frame, element, offset
	offset = mod.helpmenu.textinset
	
	-- create the top frame
	frame = mod.gui.createframe(mod.frame, mod.helpmenu.defaultwidth, 300, mod.helpmenu.background.frame, "HIGH")
	me.mainframe = frame
	
--------------------------------------------------------------------------------
--	Main Text
--------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.label = element
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	element:SetNonSpaceWrap(true)
	element:SetJustifyH("LEFT")
	element:SetJustifyV("TOP")
	
	element:SetText(mod.string.get("menu", "bossmod", "text"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	offset = offset + element:GetHeight()
	
--------------------------------------------------------------------------------

	-- Now size the frame to the string
	frame:SetHeight(mod.helpmenu.textinset + offset)
	
	return frame
		
end

me.builtinlist = 
{
	-- framelist properties
	itemwidth = 125,
	itemheight = 40,
	scrollbarwidth = 25,
	height = 400,
	
	count = function()
		return #mod.bossmod.mods
	end,
	
	newframe = function(parent)
		
		local frame = mod.gui.createframe(parent, me.builtinlist.itemwidth, me.builtinlist.itemheight, mod.helpmenu.background.frame)
		frame.text = mod.gui.createfontstring(frame, 16, true)
		frame.text:SetPoint("TOPLEFT", mod.gui.border, -mod.gui.border)
		frame.text:SetJustifyH("LEFT")
		frame.text:SetWidth(me.builtinlist.itemwidth)
		
		return frame
	end,

	drawitem = function(frame, index)
	
		local item = mod.bossmod.mods[index]
		
		frame.text:SetText(item.bossname or ("? " .. item.bossid))
		
	end,

	clickitem = function(index)
		
		a, b = mod.serial.tabletostring(mod.bossmod.mods[index])
	
		if a then
			me.builtinframe.text2:SetText(b)
		else
			me.builtinframe.text2:SetText("There was an error serialising the boss mod.")
		end
	
	end
	
}	

--[[
me.createbuiltinframe()

Constructor for the "Built in Boss Mods" frame. Lots of boring stuff.
]]
me.createbuiltinframe = function()
	
	local frame = mod.gui.createframe(mod.frame, 600, 300, mod.helpmenu.background.frame, "HIGH")
	me.builtinframe = frame
	
	local offset = mod.helpmenu.textinset
	local element
	
	frame.setup = me.framesetup
	
------------------------------------------------------------------------------------
-- Text 1 (intro)
------------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text1 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetJustifyH("LEFT")
	
	element:SetText(mod.string.get("menu", "bossmod", "builtin", "text1"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()

------------------------------------------------------------------------------------
-- Scroll Frame (boss mods)
------------------------------------------------------------------------------------
	
	-- section gap
	offset = offset + 10
	
	element = mod.framelist.createnew(frame, me.builtinlist.height, 25, 75, mod.gui.invisedge, me.builtinlist.newframe, me.builtinlist.count, me.builtinlist.drawitem, me.builtinlist.clickitem)
	
	frame.scroll = element
	
	-- anchor
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
------------------------------------------------------------------------------------
-- Text 2 (boss mod description) - note this is level with the scroll frame
------------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text2 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset + mod.helpmenu.textinset + me.builtinlist.itemwidth + me.builtinlist.scrollbarwidth, -offset)
	element:SetJustifyH("LEFT")
	
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset - (mod.helpmenu.textinset + me.builtinlist.itemwidth + me.builtinlist.scrollbarwidth))
	
	-- incremement offset + add to frame
	offset = offset + me.builtinlist.height
	
------------------------------------------------------------------------------------	
	-- Now size the frame to the string
	frame:SetHeight(mod.helpmenu.textinset + offset)
		
	return frame
	
end

--[[
------------------------------------------------------------------------------------
				"User Made" Section
------------------------------------------------------------------------------------
]]

me.usermadelist = 
{
	-- framelist properties
	itemwidth = 125,
	itemheight = 40,
	scrollbarwidth = 25,
	height = 250,
	
	count = function()
		return #mod.bossuser.mods
	end,
	
	newframe = function(parent)
		
		local frame = mod.gui.createframe(parent, me.usermadelist.itemwidth, me.usermadelist.itemheight, mod.helpmenu.background.frame)
		frame.text = mod.gui.createfontstring(frame, 16, true)
		frame.text:SetPoint("TOPLEFT", mod.gui.border, -mod.gui.border)
		frame.text:SetJustifyH("LEFT")
		frame.text:SetWidth(me.usermadelist.itemwidth)
		
		return frame
	end,

	drawitem = function(frame, index)
	
		local item = mod.bossuser.mods[index]
		
		frame.text:SetText(item.bossname or ("? " .. item.bossid))
		
	end,

	clickitem = function(index)
		
		a, b = mod.serial.tabletostring(mod.bossuser.mods[index])
	
		if a then
			me.usermade.text2:SetText(b)
		else
			me.usermade.text2:SetText("There was an error serialising the boss mod.")
		end
	
	end
	
}	

--[[
me.createusermadeframe()

Constructor for the "User Made Boss Mods" frame. Lots of boring stuff.
]]
me.createusermadeframe = function()
	
	local frame = mod.gui.createframe(mod.frame, 600, 300, mod.helpmenu.background.frame, "HIGH")
	me.usermadeframe = frame
	
	local offset = mod.helpmenu.textinset
	local element
	
	frame.setup = me.framesetup
	
------------------------------------------------------------------------------------
-- Text 1 (intro)
------------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text1 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetJustifyH("LEFT")
	
	element:SetText(mod.string.get("menu", "bossmod", "usermade", "text1"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset + add to frame
	offset = offset + element:GetHeight()

------------------------------------------------------------------------------------
-- Scroll Frame (boss mods)
------------------------------------------------------------------------------------
	
	-- section gap
	offset = offset + 10
	
	element = mod.framelist.createnew(frame, me.usermadelist.height, 25, 75, mod.gui.invisedge, me.usermadelist.newframe, me.usermadelist.count, me.usermadelist.drawitem, me.usermadelist.clickitem)
	
	frame.scroll = element
	
	-- anchor
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
------------------------------------------------------------------------------------
-- Text 2 (boss mod description) - note this is level with the scroll frame
------------------------------------------------------------------------------------

	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	frame.text2 = element

	element:SetPoint("TOPLEFT", mod.helpmenu.textinset + mod.helpmenu.textinset + me.usermadelist.itemwidth + me.usermadelist.scrollbarwidth, -offset)
	element:SetJustifyH("LEFT")
	
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset - (mod.helpmenu.textinset + me.usermadelist.itemwidth + me.usermadelist.scrollbarwidth))
	
	-- incremement offset + add to frame
	offset = offset + me.usermadelist.height

------------------------------------------------------------------------------------
-- Buttons Buttons Buttons
------------------------------------------------------------------------------------
	
	-- new section
	offset = offset + 10
		
	frame.button = { }
	
	-- 1) Top left = New
	element = mod.gui.createbutton(frame, 180, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	element.id = "new"
	frame.button[element.id] = element
	
	element:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -offset)
	element:SetScript("OnClick", me.usermadebuttonclick)
	element:SetText(mod.string.get("generic", "new"))
	
	-- 2) Top middle = Edit
	element = mod.gui.createbutton(frame, 180, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	element.id = "edit"
	frame.button[element.id] = element
	
	element:SetPoint("TOPLEFT", frame, "TOPLEFT", 15 * 2 + 180, -offset)
	element:SetScript("OnClick", me.usermadebuttonclick)
	element:SetText(mod.string.get("generic", "edit"))
	
	-- 3) Top right = Delete
	element = mod.gui.createbutton(frame, 180, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	element.id = "delete"
	frame.button[element.id] = element
	
	element:SetPoint("TOPLEFT", frame, "TOPLEFT", 15 * 3 + 180 * 2, -offset)
	element:SetScript("OnClick", me.usermadebuttonclick)
	element:SetText(mod.string.get("generic", "delete"))	
	
	-- section gap
	offset = offset + element:GetHeight() + 10
	
	-- 4) Bottom left = Import
	element = mod.gui.createbutton(frame, 180, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	element.id = "import"
	frame.button[element.id] = element
	
	element:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -offset)
	element:SetScript("OnClick", me.usermadebuttonclick)
	element:SetText(mod.string.get("menu", "bossmod", "usermade", "button", element.id))
	
	-- 5) Bottom middle = Export
	element = mod.gui.createbutton(frame, 180, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	element.id = "export"
	frame.button[element.id] = element
	
	element:SetPoint("TOPLEFT", frame, "TOPLEFT", 15 * 2 + 180, -offset)
	element:SetScript("OnClick", me.usermadebuttonclick)
	element:SetText(mod.string.get("menu", "bossmod", "usermade", "button", element.id))
	
	-- 6) Bottom right = Delete
	element = mod.gui.createbutton(frame, 180, 30, mod.helpmenu.background.button, mod.helpmenu.fontsize)
	element.id = "broadcast"
	frame.button[element.id] = element
	
	element:SetPoint("TOPLEFT", frame, "TOPLEFT", 15 * 3 + 180 * 2, -offset)
	element:SetScript("OnClick", me.usermadebuttonclick)
	element:SetText(mod.string.get("menu", "bossmod", "usermade", "button", element.id))	
	
	-- increment offset
	offset = offset + element:GetHeight()
	
------------------------------------------------------------------------------------	
	-- Now size the frame to the string
	frame:SetHeight(mod.helpmenu.textinset + offset)
		
	return frame
	
end

me.usermadebuttonclick = function(this)
	
	local buttonid = this.id
	
	mod.print("pressed " .. buttonid)
	
	if buttonid == "new" then
		
		-- mod.editboss. ???
	end
		
	
end