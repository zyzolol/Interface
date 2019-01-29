
local me = { name = "table"}
local mod = thismod
mod[me.name] = me

--[[
---------------------------------------------------------------------------------------------
				Tables Module 
---------------------------------------------------------------------------------------------
]]

-- console
me.myconsole = 
{
	resetraid = "sendraidreset",
}

--[[
This is activated by the slash command "/mod resetraid"
]]
me.sendraidreset = function()
	
	if mod.net.checkpermission() then
		mod.net.sendmessage("clear")
	end
	
end

me.mynetmessages = { "clear", }

me.onnetmessage = function(author, command, data)
	
	if command == "clear" then
		
		-- check the author has permission
		if mod.unit.isplayerofficer(author) == nil then
			return "permission"
		end
		
		mod.printf(mod.string.get("print", "network", "threatreset"), author)
		
		mod.mythreat.removeallmobdata()
		
		-- TODO: reset threat list maybe?
		
	end
	
end
