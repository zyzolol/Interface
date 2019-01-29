
-- module setup
local me = { name = "editboss"}
local mod = thismod
mod[me.name] = me

me.createframe = function()
	
	local frame, element
	local offset = mod.gui.border
	
	-- 1) frame
	frame = mod.gui.createframe(mod.frame, 600, 300, mod.helpmenu.background.frame, "HIGH")
	frame:SetPoint("CENTER", UIParent, 0, 0)
	
	me.frame = frame
	frame:Hide()
	
	
	-- 2) Header - Label
	element = mod.gui.createfontstring(frame, 18)
	me.textheader = element
	
	element:SetPoint("TOP", frame, "TOP", 0, -offset)
	element:SetText(mod.string.get("wizard", "editboss", "header"))
	
	-- don't do offset yet
		
	
	-- 3) Close Button
	element = mod.gui.createclosebutton(frame, 25, me.oncloseclicked)
	me.buttonclose = element
	
	element:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -mod.gui.border, -mod.gui.border)
	
	-- combined offset
	offset = offset + math.max(element:GetHeight(), me.textheader:GetHeight())
	
	-- section gap
	offset = offset + 10
	
	
	-- 4) Description text
	element = mod.gui.createfontstring(frame, mod.helpmenu.fontsize)
	me.textdescription = element
	
	element:SetPoint("TOPLEFT", frame, mod.helpmenu.textinset, -offset)
	element:SetJustifyH("LEFT")
	element:SetText(mod.string.get("wizard", "editboss", "description"))
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	offset = offset + element:GetHeight()
	
	-- something's wrong with the height here not really sure
	offset = offset + 20
	
	
	-- 5) Name text box
	element = mod.gui.createsimpleinputbox(frame, mod.helpmenu.fontsize, 250)
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	
	-- don't set offset yet
	
	
	-- 6) Boss Name List
	
	
	-- finalise
	frame:SetHeight(mod.helpmenu.textinset + offset)
	
end

me.oncloseclicked = function()
	
	mod.print("Clicked close button")
	
end