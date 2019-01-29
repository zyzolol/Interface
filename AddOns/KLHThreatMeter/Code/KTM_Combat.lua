
local me = { name = "combat"}
local mod = thismod
mod[me.name] = me

--[[
KTM_Combat.lua

The combat module receives parsed combat log events, adds a few set bonuses, and calls methods from My.lua to work out the actual threat values.
]]

--[[
------------------------------------------------------------------------------------------------
								Internal Methods
------------------------------------------------------------------------------------------------
]]

------------------------------------------------------------------------------------------------
--								Central Threat Reporter
------------------------------------------------------------------------------------------------

--[[
me.reportattack(targetguid, value)

Internal method called when the final threat value has been calculated. Sends the result off to the next module in the processing chain, with interrupt for misdirection.
]]
me.reportattack = function(targetguid, value)
	
	-- Ignore threat if misdirecting
	if mod.misdirection.interrupt(targetguid, value) then
		return
	end
			
	-- post to <MyThreat> module
	mod.mythreat.addtarget(targetguid, value)
	
end

--[[
me.reportheal(targetname, value)

Called when the final threat value for a heal has been calculated.

When you heal a target, his threat list is added to your own, then the threat is divided amongst your expanded threat list.
]]
me.reportheal = function(targetname, value)
	
	-- gather the list of targets = union(my targets, targets targets)
	-- TODO: investigate the effect of this vs dead mobs, possibly resurrect them? maybe ignore 0 threat.
	
	local targetlist = mod.garbage.gettable()
	local numtargets = 0
	
	-- add all my targets
	for mobguid, mobdata in pairs(mod.mythreat.datalookup) do
		
		if mobdata.threat > 0 then
			targetlist[mobguid] = true
			numtargets = numtargets + 1
		end
	end
	
	-- add target's targets
	if targetname ~= UnitName("player") then
		
		local playerdata, partialmobguid
		
		for partialmobguid, mobdata in pairs(mod.threatlist.data) do
			
			-- convert partial to full
			mobguid = mod.moblist.findfullguidfrompartial(partialmobguid)
			playerdata = mobdata[targetname]
			
			if playerdata and playerdata.threat > 0 and targetlist[mobguid] == nil then
				targetlist[mobguid] = true
				numtargets = numtargets + 1
			end
		end
	end
	
	if numtarget == 0 then
		-- TODO: improve this case (e.g. get taggro targets from mob aggro)
		return
	end
			
	local threatsplit = value / numtargets
	
	for mobguid, _ in pairs(targetlist) do
		
		mod.mythreat.addtarget(mobguid, threatsplit)
		
	end
	
	-- recycle
	mod.garbage.recycle(targetlist)
	
end

--[[
me.reportpowergain(value)

Called when the final threat value for a power gain has been calculated.

Power gain threat is divided amongst all targets on your threat list.

TODO: fix powergain from others (e.g. VT)
]]
me.reportpowergain = function(value)
	
	local targetlist = mod.garbage.gettable()
	local numtargets = 0
	
	-- add all my targets
	for mobguid, mobdata in pairs(mod.mythreat.datalookup) do
		
		if mobdata.threat > 0 then
			targetlist[mobguid] = true
			numtargets = numtargets + 1
		end
	end
	
	if numtargets == 0 then
		return
	end
	
	local threatsplit = value / numtargets
	
	for mobguid, _ in pairs(targetlist) do
		
		mod.mythreat.addtarget(mobguid, threatsplit)
		
	end
	
	-- recycle
	mod.garbage.recycle(targetlist)
	
end

------------------------------------------------------------------------------------------------
--								Spell School Flag Helpers
------------------------------------------------------------------------------------------------


me.magicflags = bit.bor(SCHOOL_MASK_HOLY, SCHOOL_MASK_FIRE, SCHOOL_MASK_NATURE, SCHOOL_MASK_FROST, SCHOOL_MASK_SHADOW, SCHOOL_MASK_ARCANE)

--[[
<bool> = me.schoolhasmagic(schoolflags)

Returns true if the given spellschool flags contain magic bits.
]]
me.schoolhasmagic = function(schoolflags)
	
	return bit.band(schoolflags, me.magicflags) > 0
	
end

--[[
<bool> = me.schoolhasflag(schoolflags, flag)

Returns true if the given spell school includes a given flag.
]]
me.schoolhasflag = function(schoolflags, flag)
	
	return bit.band(schoolflags, flag) == flag
	
end

--[[
------------------------------------------------------------------------------------------------
								Public Interface
------------------------------------------------------------------------------------------------
]]

--[[
mod.combat.specialattack(abilityid, targetguid, damage, iscrit, schoolflags, isdot)

Called for spells with known threat modifiers.

<abilityid>		string; internal identifier for the spell (c.f. localisation key)
<targetguid>	string; identifier of the target of the ability
<damage>			number; amount of damage done
<iscrit>			bool; true if the attack critted.
<spellschool>	flags; from the SCHOOL_MASK_XYZ types
<isdot>			bool; true if the damage was from a periodic source
]]
me.specialattack = function(abilityid, targetguid, damage, iscrit, schoolflags, isdot, isretract)
	
	-- get the player's global threat modifiers (defensive stance, blessing of salvation, etc)
	local threatmodifier = mod.my.globalthreat.value
	local threat
	
	-- Now, most attacks can be handled gracefully by the table. However, for abilities that modify your autoattack, we would prefer to decouple the ability from the autoattack, so we have to handle these cases individually.
	
	if abilityid == "whitedamage" then
			
		-- normal behaviour
		threat = damage * threatmodifier
		
		-- shaman spiritual weapons
		if mod.my.class == "shaman" then
			threat = threat * mod.my.mods.shaman.meleethreat
		end
	
	-- Special case: lacerate. 
	elseif abilityid == "lacerate" then
	
		if isdot then
			threat = damage * mod.my.ability("lacerate", "multiplier") * threatmodifier
		else
			threat = (damage * mod.my.ability("lacerate", "multiplier") + mod.my.ability("lacerate", "threat")) * threatmodifier
		end
	
	-- Default Case: all other abilities
	else
		
		local multiplier = mod.my.ability(abilityid, "multiplier")
		
		-- 2) Check for multiplier
		if multiplier then
			threat = damage * multiplier
			
		else
			threat = damage + mod.my.ability(abilityid, "threat")
		end
		
		-- 3) Multiply by global modifiers
		threat = threat * threatmodifier
	
	end
	
	-- Paladin righteous fury (can affect holy shield)
	if mod.my.class == "paladin" then
		
		-- righteous fury
		if me.schoolhasflag(schoolflags, SCHOOL_MASK_HOLY) then
			threat = threat * mod.my.mods.paladin.righteousfury
		end
		
	elseif mod.my.class == "warlock" then
		
		if mod.data.spellmatchesset("Warlock Destruction", abilityid, nil) == true then
			
			-- warlock Nemesis 8/8 (can affect searing pain)
			if mod.my.mods.warlock.nemesis == true then
				threat = threat * 0.8
			end
			
			threat = threat * mod.my.mods.warlock.destructionthreat
		
		elseif mod.data.spellmatchesset("Warlock Affliction", abilityid, nil) == true then
			threat = threat * mod.my.mods.warlock.afflictionthreat
		end
		
		-- plagueheart bonuses
		if mod.my.mods.warlock.plagueheart == true then
			
			-- 1) 25% less for crits
			if iscrit == true then
				threat = threat * 0.75
			
			-- 2) 25% less for some dots
			elseif mod.data.spellmatchesset("Plagueheart 6 Bonus", abilityid, nil) == true then
				threat = threat * 0.75
			end
		end
	
	elseif mod.my.class == "shaman" then
		
		if me.schoolhasmagic(schoolflags) then
			threat = threat * mod.my.mods.shaman.spelldamagethreat
		end

	elseif mod.my.class == "druid" then
		
		if me.schoolhasmagic(schoolflags) then
			threat = threat * mod.my.mods.druid.subtlety
		end		
	end
	
	-- retraction
	if isretract then
		me.reportattack(targetguid, -threat)
	else
		-- report
		me.reportattack(targetguid, threat)
	end
	
end

--[[
mod.combat.specialattack(spellname, spellid, damage, isdot, targetguid, iscrit, schoolflags)

Called for spells with no known threat modifiers.

<abilityid>		string; internal identifier for the spell (c.f. localisation key)
<targetguid>	string; identifier of the target of the ability
<damage>			number; amount of damage done
<iscrit>			bool; true if the attack critted.
<spellschool>	flags; from the SCHOOL_MASK_XYZ types
<isdot>			bool; true if the damage was from a periodic source
]]
me.normalattack = function(spellname, spellid, damage, isdot, targetguid, iscrit, schoolflags)
	
	-- threatmodifier includes global things, like defensive stance, tranquil air totem, rogue passive modifier, etc.
	local threatmodifier = mod.my.globalthreat.value
	
	-- Special threat mod: priest silent resolve (non-shadow spells only)
	if mod.my.class == "priest" and me.schoolhasmagic(schoolflags) and not me.schoolhasflag(schoolflags, SCHOOL_MASK_SHADOW) then
		threatmodifier = threatmodifier * (1.0 +  mod.my.mods.priest.silentresolve)
	end
		
	-- Special threat modifiers for mages
	if mod.my.class == "mage" then
		
		if me.schoolhasflag(schoolflags, SCHOOL_MASK_ARCANE) then
			threatmodifier = threatmodifier * (1.0 + mod.my.mods.mage.arcanethreat)
		
		elseif me.schoolhasflag(schoolflags, SCHOOL_MASK_FROST) then
			threatmodifier = threatmodifier * (1.0 + mod.my.mods.mage.frostthreat)
		
		elseif me.schoolhasflag(schoolflags, SCHOOL_MASK_FIRE)  then
			threatmodifier = threatmodifier * (1.0 + mod.my.mods.mage.firethreat)
		end
	end

	local threat = damage * threatmodifier
	
	-- Now apply class-specific filters
	
	-- warlock
	if mod.my.class == "warlock" then
			
		if mod.data.spellmatchesset("Warlock Destruction", spellid, spellname) == true then
			
			-- warlock Nemesis 8/8 (can affect searing pain)
			if mod.my.mods.warlock.nemesis == true then
				threat = threat * 0.8
			end
			
			threat = threat * mod.my.mods.warlock.destructionthreat
		
		elseif mod.data.spellmatchesset("Warlock Affliction", spellid, spellname) == true then
			threat = threat * mod.my.mods.warlock.afflictionthreat
		end
		
		-- plagueheart bonuses
		if mod.my.mods.warlock.plagueheart == true then
			
			-- 1) 25% less for crits
			if iscrit == true then
				threat = threat * 0.75
			
			-- 2) 25% less for some dots
			elseif mod.data.spellmatchesset("Plagueheart 6 Bonus", spellid, spellname) == true then
				threat = threat * 0.75
			end
		end
	
	-- Priest
	elseif mod.my.class == "priest" then
			
		-- shadow affinity
		if me.schoolhasflag(schoolflags, SCHOOL_MASK_SHADOW) then
			threat = threat * mod.my.mods.priest.shadowaffinity
		end
		
		-- holy nova: no threat
		if spellid == "holynova" then
			threat = 0
		end
		
	-- Mage
	elseif mod.my.class == "mage" then
			
		-- netherwind
		if mod.my.mods.mage.netherwind == true then
			
			if (spellid == "frostbolt") or (spellid == "scorch") or (spellid == "fireball") then
				-- note that this won't trigger off the dot part of fireball, because then spellid will be "dot"
				threat = math.max(0, (threat - 100))
				
			elseif spellid == "arcanemissiles" then
				threat = math.max(0, (threat - 20))
			end
		end
		
		-- frostfire 8 piece proc
		if mod.my.states.notthere.value == true then
			threat = 0
			mod.my.setstate("notthere", false)
		end
		
	-- Rogue
	elseif mod.my.class == "rogue" then
		
		-- bonescythe 6/8
		if mod.my.mods.rogue.bonescythe == true then
			if (spellid == "sinisterstrike") or (spellid == "backstab") or (spellid == "eviscerate") or (spellid == "hemorrhage") then
				threat = threat * 0.92
			end
		end
		
	-- Paladin
	elseif mod.my.class == "paladin" then
		
		-- righteous fury
		if me.schoolhasflag(schoolflags, SCHOOL_MASK_HOLY) then
			threat = threat * mod.my.mods.paladin.righteousfury
		end
	
	-- Shaman
	elseif mod.my.class == "shaman" then
		
		-- spirit weapons: any non-spell damage counts.
		if not me.schoolhasmagic(schoolflags)
 then
			threat = threat * mod.my.mods.shaman.meleethreat
			
		else
			
			threat = threat * mod.my.mods.shaman.spelldamagethreat
		end
	
	elseif mod.my.class == "druid" then
		
		if me.schoolhasmagic(schoolflags) then
			threat = threat * mod.my.mods.druid.subtlety
		end	
	
	end

	-- report
	me.reportattack(targetguid, threat)
	
end

--[[
mod.combat.possibleoverheal(ktmspellid, amount, targetname)

Works out the threat from a heal, taking off estimated overheal.

<ktmspellid>	string, possibly null; internal identifier of the spell. 
<amount>			number; raw heal value
<targetname>	string; name of the target of the heal
]]
me.possibleoverheal = function(ktmspellid, amount, targetname)
	
	-- we can check the target's health, which will be the health before the heal. Then we work out what the 
	-- heal did, and we can calculate overheal.
	
	local unit = mod.unit.findunitidfromname(targetname)
	
	if unit == nil then
		if mod.trace.check("info", me, "healtarget") then
			mod.trace.printf("Could not find a UnitID for the name %s.", targetname)
		end
		-- (and assume there was no overheal)
	else
		local hpvoid = UnitHealthMax(unit) - UnitHealth(unit)
		amount = math.min(amount, hpvoid)
	end
	
	amount = math.max(0, amount)	-- some blizzard bug reporting bad hp levels for a while
				
	local threatmod = mod.my.globalthreat.value
	
	-- Special threat mod: priest silent resolve (spells only)
	if mod.my.class == "priest" then
		threatmod = threatmod * (1 + mod.my.mods.priest.silentresolve)
	end 
	
	local threat = amount * threatmod * mod.data.threatconstants.healing
	
	-- class-based healing multipliers
	if mod.my.class == "paladin" then
		
		threat = threat * mod.my.mods.paladin.healing
		threat = threat * mod.my.mods.paladin.righteousfury
		
	elseif mod.my.class == "druid" then
		
		threat = threat * mod.my.mods.druid.subtlety
		
		if ktmspellid == "tranquility" then
			threat = threat * mod.my.mods.druid.tranquilitythreat
		end
		
	elseif mod.my.class == "shaman" then
		
		threat = threat * mod.my.mods.shaman.healing
		threat = threat * mod.my.mods.shaman.spelldamagethreat
		
	end 
	
	-- Special: healing abilities which don't cause threat
	if ktmspellid == "holynova" then
		threat = 0
	elseif ktmspellid == "siphonlife" then
		threat = 0
	elseif ktmspellid == "drainlife" then
		threat = 0
	elseif ktmspellid == "deathcoil" then
		threat = 0
	end
	
	-- report
	me.reportheal(targetname, threat)
	
end

--[[
mod.combat.powergain(amount, powertype, spellid, targetname)

Calculates the threat from gaining energy / mana / rage.
<amount> is the amount of power gained.
<powertype> is from the SPELL_POWER_XYZ series
<spellid> is the spell or effect that caused the power gain.
<targetname> is the name of the person who gained it. Usually player, but not always.
]]
me.powergain = function(amount, powertype, spellid, targetname)
	
	-- todo: source mana stats from <targetname> instead.
	
	-- 1) Prevent "overheal" for power gain
	local maxgain = UnitManaMax("player") - UnitMana("player")
	local threat
	
	amount = math.min(maxgain, amount)
	
	if powertype == SPELL_POWER_RAGE then
		threat = amount * mod.data.threatconstants.ragegain
		
	elseif powertype == SPELL_POWER_ENERGY then
		threat = amount * mod.data.threatconstants.energygain
		
	elseif powertype == SPELL_POWER_MANA then
		threat = amount * mod.data.threatconstants.managain 
		
	else
		return
	end
	
	-- Special: abilities which don't cause threat
	if spellid == "lifetap" then
		threat = 0
	end
		
	-- report
	me.reportpowergain(threat)
		
end