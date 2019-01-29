
--[[
LoadFirst.lua

This file essentially sets up the mod. All the variables in the mod are contained in one global variable (as subtables of a table). It is important that the global variable <thismod> is defined. All the other modules use that to determine the name of the mod's table, which they have to add themself to.
]]

local namespace = "klhtm" -- Change this ONE string to completely clone the mod!! (almost!)

-- OK, the next line is pretty terrible, but it does look cool. Imagine <namespace> is the value "mymod". Then this line will create the global variable <mymod> with a table. Then it adds the value "mymod" to the table under the key "namespace". So then (mymod.namespace == "mymod").
setglobal(namespace, { namespace = namespace})

-- <thismod> is a copy of <mymod> that other module can use in an addon-independent way. The variable <thismod> is only required until all the files in the addon have been read.
thismod = getglobal(namespace)