
-- module setup
local me = { name = "menuhome"}
local mod = thismod
mod[me.name] = me

--[[
Menu\Home.lua

This is the section you see when the menu is first shown. It gives a brief explanation of what's going on. It is also the root node of the menu tree, so has special properties. The name must be "top", which can't be used by other sections.
]]

me.onload = function()

	me.deferredframe = mod.defer.createnew(me.createframe)
		
	-- add frame to the sections list
	mod.helpmenu.registersection("top", nil, mod.string.get("menu", "top", "description"), me.deferredframe)
	
end

-- returns: created frame
me.createframe = function()
	
	-- create the top frame
	me.frame = mod.gui.createframe(mod.frame, mod.helpmenu.defaultwidth, 300, mod.helpmenu.background.frame, "HIGH")
	
	local label = mod.gui.createfontstring(me.frame, mod.helpmenu.fontsize)
	label:SetPoint("TOPLEFT", mod.helpmenu.textinset, -mod.helpmenu.textinset)
	
	label:SetNonSpaceWrap(true)
	label:SetJustifyH("LEFT")
	label:SetJustifyV("TOP")
	
	label:SetText(string.format(mod.string.get("menu", "top", "text"), mod.global.addonname, mod.global.release, mod.global.revision))
	
	label:SetWidth(me.frame:GetWidth() - 2 * mod.helpmenu.textinset)
	
	-- add to frame
	me.frame.label = label
	
	-- Now size the frame to the string
	me.frame:SetHeight(mod.helpmenu.textinset * 2 + label:GetHeight() + 2 * mod.gui.border)
	
	return me.frame
	
end