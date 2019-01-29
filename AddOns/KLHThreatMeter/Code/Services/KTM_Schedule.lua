
-- module setup
local me = { name = "schedule"}
local mod = thismod
mod[me.name] = me

--[[
Schedule.lua

This is a simple module to schedule a function call to occur in the future.
]]

me.list = { } --[[
me.list = 
{	
	name1 = 
	{
		enabled = true / false,
		method = <function>,
		time = (GetTime() + interval),
		args = { <arg1>, <arg2>, ... },
		arglength = <integer>,
	},
	name2 = { ... }
}
]]

--[[
/script <mod>.schedule.test()

Prints out a message in a few seconds.
]]
me.test = function()
	
	me.schedule("test", 3, mod.print, "test successful!")
	
end

--[[
mod.schedule.schedule(name, timeout, method, [, arg1, arg2, ...])

Schedules the function <method> to be called with parameters <arg1, arg2, ...> in <interval> seconds. <name> identifies the operation.
]]
me.schedule = function(name, timeout, method, ...)
	
	local runtime = GetTime() + timeout
	
	if me.list[name] == nil then
		me.list[name] = {	args = { }	}
		
	-- ignore a later rescheduling
	elseif (me.list[name].enabled == true) and (me.list[name].time < runtime) then
		return
	end
	
	me.list[name].enabled = true
	me.list[name].method = method
	me.list[name].time = runtime
	me.list[name].arglength = select("#", ...)
	
	for x = 1, select("#", ...) do
		me.list[name].args[x] = select(x, ...)
	end
end

me.myonupdates = 
{
	checklist = 0.1,
}

me.checklist = function()
	
	local timenow = GetTime()
	
	for name, value in pairs(me.list) do
		
		if value.enabled and value.time < timenow then
			
			value.enabled = false
			value.method(unpack(value.args, 1, value.arglength))
		end
	end
	
end