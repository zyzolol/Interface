
-- module setup
local me = { name = "defer"}
local mod = thismod
mod[me.name] = me

--[[
DeferredFrame.lua

This only works with HelpMenu frames.
]]

me.createnew = function(constructor)
	
	local deferredframe = 
	{
		isdeferred = true,
		createdeferredframe = constructor,
	}
	
	return deferredframe
	
end