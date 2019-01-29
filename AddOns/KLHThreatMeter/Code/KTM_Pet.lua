
local me = { name = "pet"}
local mod = thismod
mod[me.name] = me

--[[
Pet.lua

Adds Hunter and Warlock pets to the raid threat list.

Credit to Ghost for doing most of the work for me, also BlackArrow0203 and Namsar.
]]

--[[
----------------------------------------------------------------------------
					Special Methods from Framework\Core.lua
----------------------------------------------------------------------------
]]

-- Register polled methods. e.g. <me.redospellranks> will be called every 1 second.
me.myonupdates = 
{
	updatespellranks = 1.0,
	updateincombat = 1.0,
	updatethreat = 0.5,
}

-- Parser for pet abilities. See Framework\Regex.lua for more details.
me.myparsers =
{
	-- Warlock Pet Taunt Spell
	{"spell", "SPELLCASTGOOTHERTARGETTED", "CHAT_MSG_SPELL_PET_DAMAGE"}, -- "%s casts %s on %s."
	-- Hunter Pet Taunt Spell
	{"spell", "SIMPLECASTOTHEROTHER", "CHAT_MSG_SPELL_PET_DAMAGE"}, -- "%s casts %s on %s."

	{"whitedamage", "COMBATHITCRITOTHEROTHER", "CHAT_MSG_COMBAT_PET_HITS"}, -- "%s crits %s for %d."
	{"whitedamage", "COMBATHITOTHEROTHER", "CHAT_MSG_COMBAT_PET_HITS"}, -- "%s hits %s for %d."

	-- Warlock Pet Damage Spell
	{"magicdamage", "SPELLLOGCRITSCHOOLOTHEROTHER", "CHAT_MSG_SPELL_PET_DAMAGE"},	-- "%s's %s crits %s for %d %s damage."
	{"magicdamage", "SPELLLOGSCHOOLOTHEROTHER", "CHAT_MSG_SPELL_PET_DAMAGE"}, -- "%s's %s hits %s for %d %s damage."
	
	-- Hunter Pet Damage Spell
	{"physicaldamage", "SPELLLOGCRITOTHEROTHER", "CHAT_MSG_SPELL_PET_DAMAGE"}, -- "%s's %s crits %s for %d."
	{"physicaldamage", "SPELLLOGOTHEROTHER", "CHAT_MSG_SPELL_PET_DAMAGE"}, -- "%s's %s hits %s for %d."
}

me.onparse = function(identifier, ...)
		
	-- no special modifiers on autoattacks
	if identifier == "whitedamage" then
		me.reportattack(select(3, ...), select(3, ...))
		
	-- all known specials that cause damage have normal threat too
	elseif (identifier == "physicaldamage") or (identifier == "magicdamage") then
		me.reportattack(select(4, ...), select(4, ...))
	
	-- spells include tauntlike abilities like growl.
	elseif identifier == "spell" then
		
		-- this unlocalises the abilitiy, e.g. "Heroic Strike" --> "heroicstrike"
		local abilityid = mod.string.unlocalise("spell", select(2, ...))
		
		-- all known abilities are described in <me.data>
		if me.data[abilityid] then
			me.reportspell(abilityid)
		end
	end
	
end

--[[
----------------------------------------------------------------------------
					Determining the Spell Ranks Available
----------------------------------------------------------------------------
]]

me.spellranks = { }

--[[
me.updatespellranks()
	Finds the rank of your pet's special spells, putting the values in <me.spellranks>.
	This method is called periodically by Core.lua. Most pets only have about 5 abilities, so we can afford to call it fairly often without taking a processor hit.
	The method is essentially the same as <mod.my.updatespellranks>.
]]
me.updatespellranks = function()
	
	local index = 0
	local name, rankstring, rank, spellid
	local rankpattern = mod.string.get("misc", "spellrank") -- e.g. "Rank %d" in english.
		
	while true do
		index = index + 1
		name, rankstring = GetSpellName(index, "pet")
		
		if name == nil then
			break
		end
		
		-- get the internal spell ID
		spellid = mod.string.unlocalise("spell", name)

		if spellid and me.data[spellid] then
			rank = 0
			
			_, _, rank = string.find(rankstring, rankpattern)
			
			if rank then
				me.spellranks[spellid] = tonumber(rank)
			end
		end
	end
	
	-- also add intimidation manually (it's a player ability, not a pet ability)
	me.spellranks.intimidation = 1
	
end

--[[
----------------------------------------------------------------------------
						Pet Spell Database
----------------------------------------------------------------------------
]]

-- The data is arranged by ranks. The first value is for rank1, the second for rank 2, etc.
me.data = 
{
	torment = { 45, 75, 125, 215, 300, 395, 632, },
	suffering = { 150, 300, 450, 600, 645, 885, },
	growl = { 50, 65, 110, 170, 240, 320, 415, 664, },
	intimidation = { 580, },
	cower = { -30, -55, -85, -125, -175, -225, -360, },
	soothingkiss = { -45, -75, -127, -165, -275, },
	anguish = { 300, 395, 632 },
}

-- These are the levels at which you learn a new spell
me.scalinginfo = 
{
	growl = 
	{
		levels = {1, 10, 20, 30, 40, 50, 60, 70},
		minapconstant = -1235.6,
		minapgradient = 28.14,
		threatperap = 5.7,
	},
	
	torment = 
	{
		levels = {10, 20, 30, 40, 50, 60, 70},
		minapconstant = 123,
		minapgradient = 0,
		threatperap = 0.385,
	},
	
	suffering = 
	{
		levels = {24, 36, 48, 60, 63, 69},
		minapconstant = 124,
		minapgradient = 0,
		threatperap = 0.547,
	},
	
	anguish = 
	{
		levels = {50, 60, 69},
		minapconstant = 109,
		minapgradient = 0,
		threatperap = 0.698,
	},
}

--[[
----------------------------------------------------------------------------
						Handling New Damage and Threat
----------------------------------------------------------------------------
]]

--[[
me.reportspell(abilityid)
Handles a pet spell event. <abilitiyid> will be one of the keys in <me.data>. We find the correct rank of the spell, then apply any talents that may affect it. 
]]
me.reportspell = function(abilityid)
	
	-- this is the basic evaluation formula
	local data = me.data[abilityid]
	local rank = me.spellranks[abilityid]
	local value = data[rank]
	
	-- here are overrides when we known the exact formula
	if me.scalinginfo[abilityid] then
		value = me.getscalingspellthreat(abilityid)
	end
			
	-- improved voidwalker talent
	if abilityid == "suffering" or abilityid == "torment" then
		value = value * mod.my.mods.warlock.voidwalker
	
	-- improved succubus talent
	elseif abilityid == "soothingkiss" then
		value = value * mod.my.mods.warlock.succubus
	end 
	
	me.reportattack(value, 0)

end

--[[
me.getscalingspellthreat(spellid)
	
Gets the threat value of a pet spell when we know extra information about how the spell scales with pet AP.

This should only be called when <me.scalinginfo[spellid]> is filled in.
]]
me.getscalingspellthreat = function(spellid)
	
	local data = me.scalinginfo[spellid]
	
	-- start with base threat
	local level = UnitLevel("pet")
	local threat = me.getspellbasethreat(level, me.data[spellid], data.levels)
	
	-- add AP scaling
	local petap1, petap2 = UnitAttackPower("pet")
	local petap = petap1 + petap2
	
	if level > 59 then
		
		local minap = data.minapconstant + level * data.minapgradient
		
		if petap > minap then
			threat = threat + (petap - minap) * data.threatperap
		end
	end
	
	return threat
	
end

--[[
me.getspellbasethreat(petlevel, threatranks, levelranks)

Gets the level-based portion of the threat from a pet's spell. It is assumed that as your level your pet up, the base threat of his rank N spells naturally increase towards the value of the N + 1 -th rank when he is just below the level at which he learns the new rank.

<petlevel>		integer; the Pet's current level.
<threatranks>	list of integers; an entry in <me.data> corresponding to the the spell cast
<levelranks>	list of integers; an entry in <me.levelinfo> corresponding to the the spell cast
]]
me.getspellbasethreat = function(petlevel, threatranks, levelranks)

	-- base cases: low level or high level
	if petlevel <= levelranks[1] then
		return threatranks[1]
	
	elseif petlevel >=  levelranks[#levelranks] then
		return threatranks[#levelranks]
	end
	
	-- mixed cases: find the two levels we are in between
	local lowindex, highindex
	
	for x = 2, #levelranks do
		if petlevel < levelranks[x] then
			highindex = x
			lowindex = x - 1
			break
		end
	end
	
	-- now we have "levelranks[lowindex] < petlevel < levelranks[highindex]"
	local scalefactor = (petlevel - levelranks[lowindex]) / (levelranks[highindex] - levelranks[lowindex])
	
	-- scalefactor is between 0 and 1. 0 when your pet is lower level, 1 when it is higher.
	return threatranks[highindex] * scalefactor + threatranks[lowindex] * (1 - scalefactor)
	
end

-- This is our pet's threat
me.petthreat = 0

--[[
me.reportattack(threat, damage)
Handles a pet damage event. This could be called by <me.reportspell>, or directly from the OnEvent handler from a simple event like an autoattack.
<threat>	number; the threat caused
<damage>	integer; the damage done.
]]
me.reportattack = function(threat, damage)
	
	local petname = UnitName("pet")
	
	-- Sometimes we get pet events from totems and shit that aren't really pets. So filter them out:
	if petname == nil then
		return
	end
	
	-- add
	me.petthreat = me.petthreat + threat
		
	-- set personal
	if mod.table.mydata[petname] == nil then
		mod.table.mydata[petname] = mod.table.newdatastruct()
	end
	
	mod.table.mydata[petname].threat = me.petthreat
	mod.table.mydata[petname].hits = mod.table.mydata[petname].hits + 1
	mod.table.mydata[petname].damage = mod.table.mydata[petname].damage + damage
	
end

--[[
----------------------------------------------------------------------------
					Monitoring the In Combat Status of the Pet
----------------------------------------------------------------------------

Basically when the pet goes out of combat we want him to rezero his threat.
]]

me.petincombat = false

--[[
me.updateincombat()
Remove the pet's threat when it goes out of combat.
This method is called periodically from Core.lua
]]
me.updateincombat = function()
	
	if (UnitExists("pet") == nil) or (UnitName("pet") == nil) then
		me.petincombat = false
		me.petthreat = 0
		return
	end
	
	local combatnow = UnitAffectingCombat("pet") or UnitAffectingCombat("player")
	
	if combatnow == nil then
		me.petthreat = 0	
	end
	
	me.petincombat = (combatnow ~= nil)
	
end

-- called every 0.5 seconds
me.updatethreat = function()
	
	if UnitName("pet") == nil then
		return
	end
	
	mod.netin.messagein(UnitName("pet"), "t " .. me.petthreat, 1)
	
end