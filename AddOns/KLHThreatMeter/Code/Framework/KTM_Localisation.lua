
local me = { name = "string"}
local mod = thismod
mod[me.name] = me

--[[
Localisation.lua

The structure for localisation is probably a bit different to most mods. There is no long list of constants called KLHTM_COMBAT_RAZORGORE_PHASE2 or similar, because it looks silly, and is hard to debug, not to mention type.

All the strings are stored in multi-layered table with related strings. The names of spells are in one subtable, the names of talents in another. Some tables contain subtables. 

The highest level of the tree is keyed by your localisation - "enUS" or "frFR" etc (these are the return values of GetLocale()). A small subset of the tree is

me.data = 
{
	["enUS"] = 
	{
		["spell"] = 
		{
			["cower"] = "Cower",
		}
	},
	["frFR"] = 
	{
		["spell"] = 
		{
			["cower"] = "D\195\169robade",
		},
	},
}
	
To get the localised name of the spell Cower, call the function 
	mod.string.get("spell", "cower") 

The table mod.string.data is an empty table defined below; each localisation file adds their own subtable.
]]

--[[
me.fixedGlobalString()

This is a Korean-only hack of the global strings to make the parser work.
]]
me.fixedGlobalString = function()
  if GetLocale() == "koKR" then
    setglobal("PERIODICAURAHEALSELFOTHER", "%1$s|1이;가; 당신의 %3$s|1으로;로; 인해 생명력이 %2$d만큼 회복되었습니다.");
    setglobal("PERIODICAURADAMAGESELFOTHER", "%1$s|1이;가; 당신에 의한 %4$s|1으로;로; %2$d의 %3$s 피해를 입었습니다.");
  end
end

-- Special onload method called from Core.lua
me.onload = function()
	
	me.fixedGlobalString()
	
	me.createreverselookup(me.data[me.mylocale], me.reverselookup, mod.namespace .. ".string.data." .. me.mylocale )
	
	-- set up key binding variables
	if me.data.enUS.binding then
		
		setglobal(string.format("BINDING_HEADER_%s", mod.global.name), mod.global.name)
		
		for key, _ in pairs(me.data.enUS.binding) do
			setglobal(string.format("BINDING_NAME_%s_%s", mod.global.name, key), me.get("binding", key))
		end
	end
	
end

-- console commands
me.myconsole = 
{
	test = 
	{
		locale = "testlocalisation",
	}
}

--[[
------------------------------------------------------------------------------
			Reverse Lookup - Infering an ID from a parsed string
------------------------------------------------------------------------------
]]

--[[
	Often we could like to unlocalise the name of a spell or mob. It is much easier to work with an internal representation such as "sunder" than the value mod.string.get("spell", "sunder") all the time.
	The table me.reverselookup is where we will store the unlocalisation. Before run time, it will just list all the parts of the localisation tree that we want to unlocalise. e.g. "spell = true", indicates that we want to "spell" section to have a reverse lookup.
	To get a lookup for deeper parts of the localisation tree, just duplicate the tree until you reach the set you want.
]]
me.reverselookup = 
{
	spell = true,
	boss = 
	{
		name = true,
		spell = true,
	},
}

--[[
me.createreverselookup(localtree, reversetree, parentkey)
	Fills in the lookup tree (initially me.reverselookup) with a key-value list, where the key is the localised string and the value is the internal identifier.
	The method is recursive, if it encounters a subtable it will call itself on that table.
]]
me.createreverselookup = function(localtree, reversetree, parentkey)

	local key, value, localtable, reversetable, key2, value2
	
	for key, value in pairs(reversetree) do
		
		-- check that your localisation has <key> defined
		localtable = localtree[key]
		
		if localtable == nil then
			if mod.trace.check("warning", me, "lookup") then
				mod.trace.printf("Can't complete the localisation reverse lookup because the strings for |cffffff00%s.%s|r haven't been localised!", parentkey, key)
			end
		elseif type(value) == "table" then
			me.createreverselookup(localtree[key], value, parentkey .. "." .. key)
			
		else
			reversetable = { }
			localtable = localtree[key]
			
			for key2, value2 in pairs(localtable) do
				reversetable[value2] = key2
			end
			
			reversetree[key] = reversetable
		end
	end
	
end

--[[
mod.string.unlocalise(...)
	Gets the internal name for a spell or mob that has a localisation string. e.g. converts "Sunder Armor" to "sunder", but works on any locale (where "sunder" has been defined).
	The first few keys are entries in the me.reverselookup table, which specify which part of the localisation tree the lookup will work on, i.e. are you looking for a spell, or a boss' name, etc. The last key is the value you have parsed from a combat log.
Returns: the internal identifier, if it exists, otherwise nil.

Example:

	unknown_ability = "Sunder Armor"
	abilityid = mod.string.unlocalise("spell", unknown_ability)
	-- now abilitiyid is the value "sunder"
]]
me.unlocalise = function(...)

	local x
	local subtable = me.reverselookup
	local nextkey
	
	for x = 1, select("#", ...) do
		nextkey = select(x, ...)
		
		if subtable[nextkey] == nil then
			
			--[[
			if <nextkey> is the last argument in ..., it just means that <nextkey> is not a recognised string that has been localised. However if "subtable[nextkey] == nil" before the last key in ..., then either the reverse localisation tree is incomplete, or the value in the ... were misspelled or wrong. In the latter case a warning is generated.
			]]
			
			if x < select("#", ...) then
				
				if mod.trace.check("warning", me, "lookup") then
					mod.trace.printf("Localisation reverse lookup error. No subtable for |cffffff00%s|r in the keyset |cffffff00%s|r.", nextkey, me.keysettostring(...))
				end
			end
			
			return nil
		
		else
			subtable = subtable[nextkey]
			
			if type(subtable) ~= "table" then
				-- we've come to the end of the keyset and found a match, yay
				return subtable
			end
		end	
	end
	
end

--[[
------------------------------------------------------------------------------
			Normal Lookup - Finding the localised value of a string
------------------------------------------------------------------------------
]]

me.data = {}
me.mylocale = GetLocale()

-- we want enGB to use the enUS names for spells and mobs. We don't want enGB to just default to enUS, because some features would be disabled if the mod thought it was defaulting.
if me.mylocale == "enGB" then
	me.mylocale = "enUS"
end

--[[
The difference between <tryget> and <get> is that <tryget> will return <nil> if the value is missing in your localisation, while <get> will make up a value, e.g. the English one, or a literal representation of the ... parameters.
]]
me.tryget = function(...)
	
	return me.getinternal(me.mylocale, ...)
	
end

--[[
mod.string.get([key1, key2, key3, ...])
	Gives the localisation string specified by the set of keys. Localisation strings are grouped into related categories in a heirarchial manner. <key1> is the highest, most general level, e.g. "print", <key2> is more specific, e.g. "network", and the other keys are more specific still, e.g. "newmttargetnil". So the method call mod.string.get("print", "network", "newmttargetnil") is a message whose english value is "Could not confirm the master target %s, because %s has no target.".
	Refer to \Localisation\_enUS.lua for a list of all keys.
	If there is no localised version available, the mod will return the English version instead. 
]]
me.get = function(...)
	
	-- Try to find a localised version
	local stringvalue = me.getinternal(me.mylocale, ...)
	
	if stringvalue == nil then
		
		-- No value was found. It's likely that your localisation has not been completely updated.
		-- This is probably a non-essential string, so the English version will do
		
		stringvalue = me.getinternal("enUS", ...)
			
		if stringvalue == nil then
			-- No string in the english version either. The keys must have been wrong.

			if mod.trace.check("error", me, "getstring") then
				mod.trace.printf("The localisation identifier |cffffff00%s|r does not exist.", me.keysettostring(...))
				
				-- debug
				mod.print(debugstack())
			end
			
			-- we don't know what to return, so we'll just return a concatenation of the input
			return me.keysettostring(...)
		
		else
			
			-- Found the english version. Use it this time, but note the missing key.
			if mod.trace.check("info", me, "get") then
				mod.trace.printf("The |cffffff00%s|r locale has no value for the key |cffffff00%s|r.", me.mylocale, me.keysettostring(...))
			end
			
			return stringvalue
		end
	end
		
	return stringvalue
	
end

--[[
me.getinternal(locale, [key1, key2, key3, ...])
	Fetches a localisation string. Returns nil if there is no match.
<locale> is e.g. "enUS", "frFR", a return value of GetLocale().
]]
me.getinternal = function(locale, ...)

	local value = me.data[locale]
	local key, x
	
	-- Recall the format of me.stringkeys is e.g. { "print", "data", "talent" }
	
	-- The length of the array me.stringkeys is unknown. The for loop will keep going until it comes to <nil>.
	for x = 1, select("#", ...) do
		key = select(x, ...)
		
		-- "value" was obtained in the last loop. Since we are looping again, there must be another key
		-- inside, so value has to be a table object
		
		if value == nil then
			return nil
		end
		
		if type(value) ~= "table" then
			return nil
		end
		
		value = value[key]
	end
	
	return value
	
end

--[[
Prints out the keys that were requested for a localisation string. Used only when there is an error.
e.g. { "combat", "attack", "kill" } --> "combat.attack.kill"
]]
me.keysettostring = function(...)
	
	local message = ""
	local x, key

	for x = 1, select("#", ...) do
		key = select(x, ...)
		
		if x > 1 then
			message = message .. "."
		end
		
		message = message .. key
	end
		
	return message
	
end

--[[
mod.string.testlocalisation(locale)
Checks your localisation for missing values (compared to enUS)
locale is "enUS" or "deDE", etc.
]]
me.testlocalisation = function(locale)

	-- default = check your own locale
	if locale == nil then
		locale = me.mylocale
	end
	
	if me.data[locale] == nil then
		mod.printf("Sorry, there's no localisation at all for the |cffffff00%s|r locale.", locale)
		return
	end
	
	me.testlocalisationbranch(me.data["enUS"], me.data[locale], "")

end

-- return value = number of errors
-- linkstring = current table identifier, e.g. "print.combat."
me.testlocalisationbranch = function(english, mine, linkstring)

	local key
	local value
	local errors = 0
	
	-- check for missing values in our locale
	for key, value in pairs(english) do
		
		if mine[key] == nil then
			if type(value) == "table" then
				mod.printf("Missing the set of keys |cffffff00%s%s|r.", linkstring, key)
				errors = errors + 1
			else
				mod.printf("Missing the key |cffffff00%s%s|r. The english value is |cff3333ff%s|r", linkstring, key, value)
				errors = errors + 1
			end
			
		else
			-- recurse to subtables
			if type(value) == "table" then
				errors = errors + me.testlocalisationbranch(value, mine[key], linkstring .. key .. ".")
			end
		end
	end
	
	-- check for unused values (in the english)
	for key, value in pairs(mine) do
		
		if english[key] == nil then
			if type(value) == "table" then
				mod.printf("The set of keys |cffffff00%s%s|r does not exist in the english version, so is probably no longer used.", linkstring, key)
				errors = errors + 1
			else
				mod.printf("The key |cffffff00%s%s|r does not exist in the english version, so is probably no longer used. The current value is |cff3333ff%s|r", linkstring, key, value)
				errors = errors + 1
			end
		end
	end
	
	-- print out total errors (base case only)
	if linkstring == "" then
		mod.printf("Found |cffffff00%d|r errors in total.", errors)
	end
	
	return errors
end