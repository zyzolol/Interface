
-- module setup
local me = { name = "menucustomhandler"}
local mod = thismod
mod[me.name] = me

me.width = 700
me.editboxheight = 300
me.majorfontsize = 16
me.minorfontsize = 12

me.onload = function()
	
	me.createframe()	
	
	-- show
	--me.frame:SetPoint("CENTER", UIParent, 0, 0)
	
end

me.createframe = function()
	
	local frame, element, offset
	
	frame = mod.gui.createframe(mod.frame, me.width, 500, mod.helpmenu.background.frame, "HIGH")
	me.frame = frame
	offset = mod.helpmenu.textinset
	
------------------------------------------------------------------------------------
-- Textbox 1 - Heading
------------------------------------------------------------------------------------	
	
	-- define
	element = mod.gui.createfontstring(frame, me.majorfontsize)
	me.frame.textheading = element
	
	-- value
	element:SetJustifyH("LEFT")
	element:SetText(mod.string.get("wizard", "customhandler", "heading"))
	
	-- layout
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetWidth(frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- incremement offset
	offset = offset + element:GetHeight()

	-- new section
	offset = offset + mod.helpmenu.textinset

------------------------------------------------------------------------------------
-- Textbox - Description
------------------------------------------------------------------------------------
	
	-- define
	element = mod.gui.createfontstring(frame, me.minorfontsize)
	me.frame.textdescription = element
	
	-- value
	element:SetJustifyH("LEFT")
	element:SetText(mod.string.get("wizard", "customhandler", "description"))
	
	-- layout
	element:SetPoint("TOPLEFT", mod.helpmenu.textinset, -offset)
	element:SetWidth((me.width  - 2 * mod.helpmenu.textinset) / 2)
	
	-- don't increment offset - same level

------------------------------------------------------------------------------------
-- Text box
------------------------------------------------------------------------------------	
	
	frame = mod.textbox.createnew(me.frame, (me.width - 2 * mod.helpmenu.textinset) / 2, me.editboxheight, mod.helpmenu.background.frame, mod.helpmenu.fontsize, 25, 75)
	me.textbox = frame
	
	frame:SetPoint("TOPRIGHT", -mod.helpmenu.textinset, -offset)
		
	-- increment offset
	offset = offset + element:GetHeight()
	
	-- section gap
	offset = offset + mod.helpmenu.textinset
					
end