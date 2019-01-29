local _, playerClass = UnitClass("player")
if playerClass ~= "ROGUE" and playerClass ~= "WARRIOR" and playerClass ~= "HUNTER" and playerClass ~= "DRUID" and playerClass ~= "PALADIN" and playerClass ~= "SHAMAN" then return end
local playerHybrid = (playerClass == "DRUID") or (playerClass == "PALADIN") or (playerClass == "SHAMAN")

--Libraries
DrDamage = DrDamage or AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0", "AceDB-2.0", "AceHook-2.1", "FuBarPlugin-2.0")
local L = AceLibrary("AceLocale-2.2"):new("DrDamage")
local GT = LibStub:GetLibrary("LibGratuity-3.0")
local BI
if GetLocale() ~= "enUS" then 
	BI = LibStub:GetLibrary("LibBabble-Inventory-3.0"):GetLookupTable()
else
	BI = {}
	setmetatable(BI,{ __index = function(t,k) return k end })
end
local DrDamage = DrDamage

--General
local settings
local type = type
local next = next
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local math_abs = math.abs
local math_floor = math.floor
local math_ceil = math.ceil
local math_min = math.min
local math_max = math.max
local math_modf = math.modf
local string_match = string.match
local string_gsub = string.gsub
local select = select

--Module
local GetSpellInfo = GetSpellInfo
local GetPlayerBuffName = GetPlayerBuffName
local GetCritChance = GetCritChance
local GetRangedCritChance = GetRangedCritChance
local GetCombatRatingBonus = GetCombatRatingBonus
local GetItemInfo = GetItemInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetInventorySlotInfo = GetInventorySlotInfo
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local GetComboPoints = GetComboPoints
local GetShieldBlock = GetShieldBlock
local GetShapeshiftForm = GetShapeshiftForm
local UnitRangedDamage = UnitRangedDamage
local UnitRangedAttack = UnitRangedAttack
local UnitDamage = UnitDamage
local UnitAttackSpeed = UnitAttackSpeed
local UnitAttackPower = UnitAttackPower
local UnitAttackBothHands = UnitAttackBothHands
local UnitRangedAttackPower = UnitRangedAttackPower
local UnitExists = UnitExists
local UnitPowerType = UnitPowerType
local UnitIsUnit = UnitIsUnit
local UnitIsPlayer = UnitIsPlayer
local UnitDebuff = UnitDebuff
local UnitBuff = UnitBuff
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitMana = UnitMana
local OffhandHasWeapon = OffhandHasWeapon
local IsEquippedItem = IsEquippedItem

--Module variables
local spellInfo, talentInfo, talents
local PlayerAura, TargetAura, Consumables
local Calculation, SetBonuses

local function DrD_ClearTable(table)
	for k in pairs(table) do
		table[k] = nil
	end
end

local function DrD_Round(x, y)
	return math_floor( x * 10 ^ y + 0.5 ) / 10 ^ y
end

local function DrD_MatchData( data, ... )
	if not data or not ... then
		return false
	end

	if type( data ) == "table" then
		for _, dataName in ipairs( data ) do
			for i = 1, select('#', ...) do
				if dataName == select(i, ...) then
					return true
				end
			end
		end
	else	
		for i = 1, select('#', ...) do
			if data == select(i, ...) then
				return true
			end
		end
	end
	
	return false
end

local function DrD_Set( n, setOnly )
	return function(v) 
		settings[n] = v
		if not setOnly and not DrDamage:IsEventScheduled("DrD_FullUpdate") then
			DrDamage:ScheduleEvent("DrD_FullUpdate", DrDamage.UpdateAB, 1.0, DrDamage)
		end
	end
end

if not playerHybrid then
	DrDamage.defaults = {}
end

DrDamage.defaults.HitCalc_M = false
DrDamage.defaults.HitTarget_M = false
DrDamage.defaults.TargetLevel_M = 3
DrDamage.defaults.DisplayType_M = "AvgTotal"
DrDamage.defaults.Coeffs_M = true
DrDamage.defaults.DispCrit_M = true
DrDamage.defaults.DispHit_M = true
DrDamage.defaults.AvgHit_M = true
DrDamage.defaults.AvgCrit_M = true
DrDamage.defaults.Ticks_M = true
DrDamage.defaults.Total_M = true
DrDamage.defaults.Extra_M = true
DrDamage.defaults.Next_M = true
DrDamage.defaults.DPS_M = true
DrDamage.defaults.DPM_M = true
DrDamage.defaults.Mitigation_M = 0
DrDamage.defaults.ComboPoints_M = 0
DrDamage.defaults.Resilience_M = 0
		
function DrDamage:Melee_OnEnable()
	if self.Melee_Options then
		self:Melee_Options()
		self.Melee_Options = nil
	end
	if self.Melee_Data then
		self:Melee_Data()
		self.Melee_Data = nil
	end
	self:RegisterEvent("PLAYER_COMBO_POINTS")
	if playerClass == "WARRIOR" then
		self:RegisterBucketEvent("UNIT_RAGE",1)
	end
	if playerClass == "DRUID" then
		self:RegisterBucketEvent("UNIT_ENERGY",1)
	end
	
	spellInfo = self.spellInfo
	talentInfo = self.talentInfo
	talents = self.talents
	PlayerAura = self.PlayerAura
	TargetAura = self.TargetAura
	Consumables = self.Consumables
	Calculation = self.Calculation
	SetBonuses = self.SetBonuses
end

function DrDamage:Melee_OnProfileEnable()
	settings = self.db.profile
end

function DrDamage:Melee_Options()
	local table
	
	if playerHybrid then
		self.options.args.Melee = { type = "group", desc = "Melee Options", name = "Melee", order = 3, args = {} }
		table = self.options.args.Melee.args	
	else
		table = self.options.args
	end
	
	table.Calculation = {
		type = "group", desc = L["Calculation options"], name = L["Calculation"],
		args = {			
			HitCalc = {			
				type = 'toggle',
				name = L["+Hit calculation"],
				desc = L["Toggles +hit calculation effects into averages on/off"],
				order = 65,
				get = function() return settings["HitCalc_M"] end,
				set = DrD_Set("HitCalc_M"),
			},
			HitTarget = {			
				type = 'toggle',
				name = L["Hit calculation by current target"],
				desc = L["Toggles +hit calculation by target level and type. If nothing is targeted, the manually set level is used."],
				order = 66,
				get = function() return settings["HitTarget_M"] end,
				set = DrD_Set("HitTarget_M"),
			},
			TargetLevel = {
				type = 'range',
				name = L["Manual target level setting"],
				desc = L["Manual set of target level compared to your level. Make sure 'HitTarget' is turned off to use this."],
				min = -10,
				max = 10,
				step = 1,
				order = 67,
				get = function() return settings["TargetLevel_M"] end,
				set = DrD_Set("TargetLevel_M"),
			},
			Mitigation = {
				type = 'range',
				name = L["Enemy mitigation"],
				desc = L["Allows you to manually set a rough estimate of enemy mitigation into all applicable calculations."],
				min = 0,
				max = 100,
				step = 0.1,
				order = 80,
				get = function() return settings["Mitigation_M"] end,
				set = DrD_Set("Mitigation_M"),
			},
			ComboPoints = {
				type = 'range',
				name = L["Set amount of combo points"],
				desc = L["Manually set the amount of calculated combo points. When 0 is selected, the calculation is based on the current amount."],
				min = 0,
				max = 5,
				step = 1,
				order = 85,
				get = function() return settings["ComboPoints_M"] end,
				set = DrD_Set("ComboPoints_M"),
			},
			Resilience = {
				type = 'range',
				name = L["Target resilience"],
				min = 0,
				max = 1000,
				step = 1,
				desc = L["Input your target's resilience."],
				order = 90,
				get = function() return settings["Resilience_M"] end,
				set = DrD_Set("Resilience_M"),	
			},			
		},
	}
	table.ActionBar = {
		type = "group", desc = L["Options for the actionbar"], name = L["ActionBar"],
		args = {
			DisplayType = {
				type = "text",
				name = L["Display"],
				desc = L["Choose what to display on the actionbar"],
				validate =  { 
					["AvgTotal"] = L["AvgTotal"], 
					["Avg"] = L["Avg"], 
					["Min"] = L["Min"], 
					["Max"] = L["Max"], 
					["AvgCrit"] = L["AvgCrit"], 
					["MinCrit"] = L["MinCrit"], 
					["MaxCrit"] = L["MaxCrit"], 
					["DPM"] = L["DPM"], 
					["PowerCost"] = L["PowerCost"],
				},
				get =  function() return settings["DisplayType_M"] end,
				set =  DrD_Set("DisplayType_M"),
				order = 70,
			},
		},
	}
	table.Tooltip = {
		type = "group", desc = L["Options for the tooltips"], name = L["Tooltip"],
		args = {					
			Coeffs = {
				type = 'toggle',
				name = L["Show coefficients"],
				desc = L["Toggles displaying of calculation data"],
				order = 53,
				get = function() return settings["Coeffs_M"] end,
				set = DrD_Set("Coeffs_M", true),
			},				
			DispCrit = {
				type = 'toggle',
				name = L["Show crit %"],
				desc = L["Toggles displaying of crit %"],
				order = 54,
				get = function() return settings["DispCrit_M"] end,
				set = DrD_Set("DispCrit_M", true),
			},
			DispHit = {
				type = 'toggle',
				name = L["Show hit %"],
				desc = L["Toggles displaying of hit %."],
				order = 56,
				get = function() return settings["DispHit_M"] end,
				set = DrD_Set("DispHit_M", true),
			},				
			AvgHit = {
				type = 'toggle',
				name = L["Show avg + hit range"],
				desc = L["Toggles displaying of avg hit"],
				order = 58,
				get = function() return settings["AvgHit_M"] end,
				set = DrD_Set("AvgHit_M", true),
			},
			AvgCrit = {
				type = 'toggle',
				name = L["Show avg crit + crit range"],
				desc = L["Toggles displaying of avg crit"],
				order = 60,
				get = function() return settings["AvgCrit_M"] end,
				set = DrD_Set("AvgCrit_M", true),
			},
			Ticks = {
				type = 'toggle',
				name = L["Show per tick/hit"],
				desc = L["Toggles displaying of per hit/tick values"],
				order = 62,
				get = function() return settings["Ticks_M"] end,
				set = DrD_Set("Ticks_M", true),
			},
			Total = {
				type = 'toggle',
				name = L["Show avg total dmg/heal"],
				desc = L["Toggles displaying of average in total values"],
				order = 64,
				get = function() return settings["Total_M"] end,
				set = DrD_Set("Total_M", true),
			},				
			Extra = {
				type = 'toggle',
				name = L["Show extra damage info (Windfury, Dual Attack)"],
				desc = L["Toggles displaying of extra info"],
				order = 66,
				get = function() return settings["Extra_M"] end,
				set = DrD_Set("Extra_M", true),
			},
			Next = {
				type = 'toggle',
				name = L["Show next values (crit/hit/AP/dmg)"],
				desc = L["Toggles displaying of +1% crit, +1% hit, +100 AP values"],
				order = 68,
				get = function() return settings["Next_M"] end,
				set = DrD_Set("Next_M", true),
			},
			DPS = {
				type = 'toggle',
				name = L["Show DPS"],
				desc = L["Toggles displaying of DPS where available"],
				order = 70,
				get = function() return settings["DPS_M"] end,
				set = DrD_Set("DPS_M", true),
			},
			DPM = {
				type = 'toggle',
				name = L["Show damage per power"],
				desc = L["Toggles displaying of DPM/DPR/DPE"],
				order = 72,
				get = function() return settings["DPM_M"] end,
				set = DrD_Set("DPM_M", true),
			},
		},
	}
end

function DrDamage:Melee_Data()
	self.spellInfo[GetSpellInfo(6603)] = {
		["Name"] = "Attack",
		[0] = { AutoAttack = true, Melee = true, WeaponDamage = 1, NoNormalization = true },
		["None"] = { 0 },
	}
	local wf = GetSpellInfo(32910)
	local wft = GetSpellInfo(8516)
	self.Calculation["Attack"] = function( calculation, _, BuffTalentRanks )
		local name, rank = self:GetWeaponBuff()
		if name == wf then
			local AP = rank and select(rank, 103, 221, 315, 433, 475) --46, 119, 249, 333, 445
			if AP then
				calculation.WindfuryBonus = AP 
				calculation.WindfuryAttacks = 2 * (BuffTalentRanks["Elemental Weapons"] and select(BuffTalentRanks["Elemental Weapons"], 1.13, 1.27, 1.4) or 1)
			end
		elseif name == wft then
			local AP = rank and select(rank, 103, 221, 315, 433, 475)
			if AP then
				calculation.WindfuryBonus = AP * (1 + (BuffTalentRanks["Improved Weapon Totems"] and BuffTalentRanks["Improved Weapon Totems"] * 0.15 or 0))
				calculation.WindfuryAttacks = 1				
			end
		end
		if OffhandHasWeapon() then
			local name, rank = self:GetWeaponBuff(true)
			if name == wf then
				local AP = rank and select(rank, 103, 221, 315, 433, 475) --46, 119, 249, 333, 445
				if AP then
					calculation.WindfuryBonus_O = AP 
					calculation.WindfuryAttacks_O = 2 * (BuffTalentRanks["Elemental Weapons"] and select(BuffTalentRanks["Elemental Weapons"], 1.13, 1.27, 1.4) or 1)
				end
			elseif name == wft then
				local AP = rank and select(rank, 122, 221, 315, 433, 475)
				if AP then
					calculation.WindfuryBonus_O = AP * (1 + (BuffTalentRanks["Improved Weapon Totems"] and BuffTalentRanks["Improved Weapon Totems"] * 0.15 or 0))
					calculation.WindfuryAttacks_O = 1
				end
			end			
		end
	end
end

local lastRage = 0
local execute = GetSpellInfo(5308)
function DrDamage:UNIT_RAGE( units )
	for unit in pairs(units) do
		if UnitIsUnit(unit, "player") then
			if math_abs(UnitMana("player") - lastRage) >= 10 then
				lastRage = UnitMana("player")
				self:UpdateAB(execute)
			end
			return
		end
	end
end

local lastEnergy = 0
local fbite = GetSpellInfo(22568)
function DrDamage:UNIT_ENERGY( units )
	for unit in pairs(units) do
		if UnitIsUnit(unit, "player") then
			if UnitPowerType("player") == 3 and (math_abs(UnitMana("player") - lastEnergy) >= 20 or UnitMana("player") == 100 and lastEnergy ~= 100) then
				lastEnergy = UnitMana("player")
				self:UpdateAB(fbite)
			end
			return
		end
	end
end

local oldValues = 0
function DrDamage:Melee_CheckBaseStats()
	local newValues = 
	GetCombatRatingBonus(6)
	+ GetCombatRatingBonus(7)
	+ GetCombatRatingBonus(18)
	+ GetCombatRatingBonus(19)	
	+ self:GetAP() 
	+ self:GetRAP() 
	+ GetCritChance()
	+ GetRangedCritChance()
	+ UnitDamage("player")
	+ select(3,UnitDamage("player"))
	+ UnitRangedDamage("player")
	+ select(2,UnitRangedDamage("player"))
	+ GetShieldBlock()

	if newValues ~= oldValues then
		oldValues = newValues
		return true
	end

	return false	
end

local mhSpeed, ohSpeed, rgSpeed, rgMin, rgMax
function DrDamage:Melee_InventoryChanged()
	if self:Melee_CheckBaseStats() then
		self:RefreshWeaponType()
	
		mhSpeed, ohSpeed = UnitAttackSpeed("player")
		rgSpeed = UnitRangedDamage("player")
		rgMin, rgMax = 0, 0

		if GT:SetInventoryItem("player", GetInventorySlotInfo("MainHandSlot")) then 
			for i = 3, GT:NumLines() do
				local line = GT:GetLine(i,true)
				line = line and string_match(line,"%d.%d+")
				if line then
					mhSpeed = tonumber((string_gsub(line,",","%.")))
					break
				end
			end
		end
		if GT:SetInventoryItem("player", GetInventorySlotInfo("SecondaryHandSlot" )) then
			for i = 3, GT:NumLines() do
				local line = GT:GetLine(i,true)
				line = line and string_match(line,"%d.%d+")
				if line then
					ohSpeed = tonumber((string_gsub(line,",","%.")))
					break					
				end
			end
		end
		if GT:SetInventoryItem("player", GetInventorySlotInfo("RangedSlot")) then
			for i = 3, GT:NumLines() do
				local line = GT:GetLine(i,true)
				line = line and string_match(line,"%d.%d+")			
				if line then
					rgSpeed = tonumber((string_gsub(line,",","%.")))
					rgMin, rgMax = string_match(GT:GetLine(i), "(%d+)[^%d]+(%d+)")
					rgMin = (rgMin or 0)
					rgMax = (rgMax or 0)
					break
				end
			end
		end
		return true	
	end
	return (playerHybrid and self:CheckRelicSlot())
end

function DrDamage:GetAP()
	local baseAP, posBuff, negBuff = UnitAttackPower("player")
	return baseAP + posBuff + negBuff
end

function DrDamage:GetRAP()
	local baseAP, posBuff, negBuff = UnitRangedAttackPower("player")
	return baseAP + posBuff + negBuff	
end

local mhType, ohType, rgType
function DrDamage:GetWeaponType()
	return mhType, ohType, rgType
end

function DrDamage:RefreshWeaponType()
	mhType, ohType, rgType = "None", "None", "None"
	local mh = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"))
	if mh then mhType = select(7,GetItemInfo(mh)) or "None" end
	local oh = GetInventoryItemLink("player", GetInventorySlotInfo("SecondaryHandSlot"))
	if oh then ohType = select(7,GetItemInfo(oh)) or "None" end
	local rg = GetInventoryItemLink("player", GetInventorySlotInfo("RangedSlot"))
	if rg then rgType = select(7,GetItemInfo(rg)) or "None" end
end

function DrDamage:GetRangedBase()
	return rgMin, rgMax
end

function DrDamage:GetWeaponSpeed()
	return mhSpeed, ohSpeed, rgSpeed
end

local normalizationTable = {
	[BI["Daggers"]] = 1.7,
	[BI["One-Handed Axes"]] = 2.4,
	[BI["One-Handed Maces"]] = 2.4,
	[BI["One-Handed Swords"]] = 2.4,
	[BI["Fist Weapons"]] = 2.4,	
	[BI["Two-Handed Axes"]] = 3.3,
	[BI["Two-Handed Maces"]] = 3.3,
	[BI["Two-Handed Swords"]] = 3.3,	
	[BI["Polearms"]] = 3.3,
	[BI["Staves"]] = 3.3,
	[BI["Fishing Poles"]] = 3.3,
	["None"] = 2,
}
function DrDamage:GetNormM() 
	return normalizationTable[mhType] or 2.4, normalizationTable[ohType] or 2.4
end

function DrDamage:WeaponDamage(calculation, wspd)
	local min, max, omin, omax, mod
	local spd, normM, normM_O
	local mh, oh = self:GetNormM()
	local AP = calculation.AP
	local baseAP
	
	if calculation.ranged then
		_, min, max, _, _, mod = UnitRangedDamage("player")
		spd = rgSpeed
		normM = wspd and spd or 2.8
		baseAP = self:GetRAP()
	else
		min, max, omin, omax, _, _, mod = UnitDamage("player")
		baseAP = self:GetAP()
		
		if calculation.requiresForm then
			if calculation.requiresForm == 1 then
				spd = 2.5
				normM = 2.5
			elseif calculation.requiresForm == 3 then
				spd = 1
				normM = 1
			end
		else
			spd = mhSpeed
			normM = wspd and mhSpeed or mh
			normM_O = wspd and ohSpeed or oh
		end
	end
	
	local bonus, obonus
	bonus = normM / 14
	mod = calculation.wDmgM * mod
	
	min = min/(mod) - (baseAP / 14) * spd + bonus * AP
	max = max/(mod) - (baseAP / 14) * spd + bonus * AP
	
	if OffhandHasWeapon() and omin and omax and ohSpeed then
		obonus = normM_O / 14
		omin = omin/(calculation.offHdmgM * mod) - (baseAP / 14) * ohSpeed + obonus * AP
		omax = omax/(calculation.offHdmgM * mod) - (baseAP / 14) * ohSpeed + obonus * AP
	end
	
	return min, max, omin, omax, bonus, obonus
end

function DrDamage:GetRageGain( avg, calculation )
    	local level = UnitLevel("player")
    	if level >= 60 then
		local avgFactor = 3.5 + 3.5 * (calculation.critPerc/100)
		local conversion = 230.6 + (level-60) * ((274.6-230.6)/10)
		local rage = (avg / conversion * 7.5 + (mhSpeed * avgFactor))/2
		return rage
	else
		return 0
	end
end

--Static hit calculation tables
local weaponSkill = { 
	[0] = 0, 
	[1] = 0.1, 
	[2] = 0.2, 
	[3] = 0.3, 
	[4] = 0.4,
	[5] = 0.5,
	[6] = 0.6,
	[7] = 0.7,
	[8] = 0.8,
	[9] = 0.9,
	[10] = 1.0,
	[11] = 2.4,
	[12] = 2.8,
	[13] = 3.2,
	[14] = 3.6,
	[15] = 4.0,
}
	
local function DrD_GetMeleeHit(ranged)
	local lvlDiff, playerLevel, targetLevel = DrDamage:GetLevels()
	local skill, skillO
	local hit = 95
	local hitO = 76
	
	if not settings.HitTarget_M or not UnitExists("target") then
		targetLevel = playerLevel + settings.TargetLevel_M
	end	
	
	if ranged then
		hit = hit + GetCombatRatingBonus(7)
		local rskill, rbonus = UnitRangedAttack("player")
		skill = targetLevel * 5 - (rskill + rbonus)
	else
		hit = hit + GetCombatRatingBonus(6)
		hitO = hitO + GetCombatRatingBonus(6)
		if playerClass == "DRUID" and GetShapeshiftForm() > 0 or settings.HitTarget_M and UnitIsPlayer("target") then
			skill = targetLevel * 5 - (playerLevel * 5)
			skillO = skill
		else
			local mskill, mbonus, oskill, obonus = UnitAttackBothHands("player")
			if mhType == "None" then
				skill = targetLevel * 5 - playerLevel * 5
			else
				skill = targetLevel * 5 - (mskill + mbonus)
			end
			if ohType == "None" then
				skillO = targetLevel * 5 - (playerLevel * 5)
			else
				skillO = targetLevel * 5 - (oskill + obonus)
			end
		end
	end

	if skill > 0 then
		if skill <= 15 then
			hit = hit - weaponSkill[skill] 
		else
			hit = hit - 4 - (skill - 15) * 0.4
		end
	end
	if skillO and skillO > 0 then
		if skillO <= 15 then
			hitO = hitO - weaponSkill[skillO]
		else
			hitO = hitO - 4 - (skillO - 15) * 0.4
		end
	end
	

	return hit, hit - 19, hitO
end

--Static tables
local powerTypes = { [0] = "Mana", [1] = "Rage", [2] = "Focus", [3] = "Energy", [4] = "Happiness" }

--Temporary tables
local calculation = {}
local ActiveAuras = {}
local BuffTalentRanks = {}
local CalculationResults = {}

--Local functions
local DrD_DmgCalc, DrD_BuffCalc

function DrDamage:MeleeCalc( name, rank, tooltip )
	if not spellInfo or not name then return end
	if not rank then
		_, rank = GetSpellInfo(name)
	elseif tonumber(rank) and GetSpellInfo(name) then
		rank = string_gsub(select(2,GetSpellInfo(name)),"%d+", rank)		
	end
	
	local action = spellInfo[name][(rank and tonumber(string_match(rank,"%d+"))) or "None"]
	local baseAction = spellInfo[name][0]
	local actionName = spellInfo[name]["Name"]	
	
	if not action then return end

	calculation.offHdmgM = 0.5
	calculation.bDmgM = 1
	calculation.wDmgM = 1
	calculation.eDuration = action.eDuration or baseAction.eDuration or 0
	calculation.WeaponDamage = action.WeaponDamage or baseAction.WeaponDamage
	calculation.actionCost = select(4,GetSpellInfo(name,rank)) or 0
	calculation.critM = 1
	calculation.cooldown = baseAction.Cooldown or 0
	calculation.castTime = action.castTime or baseAction.castTime
	calculation.baseBonus = 0
	calculation.dmgBonus = 0
	calculation.extraDamBonus = 0
	calculation.requiresForm = baseAction.RequiresForm
	calculation.spellDmg = 0
	calculation.dmgM_AddTalent = 0
	calculation.hitPerc = 0
	calculation.name = name
	calculation.actionName = actionName
	calculation.Hits = baseAction.Hits
	calculation.freeCrit = 0
	
	--Reset variables
	calculation.zero = false
	calculation.WindfuryBonus = nil
	calculation.WindfuryAttacks = nil
	calculation.WindfuryBonus_O = nil
	calculation.WindfuryAttacks_O = nil
	--
	
	if settings.ComboPoints_M == 0 then
		calculation.Melee_ComboPoints = GetComboPoints()
	else
		calculation.Melee_ComboPoints = settings.ComboPoints_M
	end
	
	if not calculation.castTime then
		if baseAction.NextMelee then
			calculation.castTime = mhSpeed
		elseif playerClass == "ROGUE" or playerClass == "DRUID" and GetShapeshiftForm() == 3 then
			calculation.castTime = 1
		else
			calculation.castTime = 1.5
		end
	end
	
	if baseAction.Energy then
		calculation.powerType = 3
	elseif baseAction.Rage then
		calculation.powerType = 1
	else
		calculation.powerType = 0
	end
	
	if type( baseAction.School ) == "table" then
		calculation.actionSchool = baseAction.School[1]
		calculation.actionType = baseAction.School[2]
	else
		calculation.actionSchool = baseAction.School or "Physical"
		calculation.actionType = nil
	end
	if calculation.actionSchool == "Ranged" then
		calculation.ranged = true
		calculation.AP = self:GetRAP()
		calculation.critPerc = GetRangedCritChance()
		calculation.haste = GetCombatRatingBonus(18)
		calculation.dmgM = select(6,UnitRangedDamage("player"))
		if baseAction.AutoShot then
			calculation.castTime = UnitRangedDamage("player")
		end
	else
		calculation.ranged = false
		calculation.AP = self:GetAP()
		calculation.critPerc = GetCritChance()
		calculation.haste = GetCombatRatingBonus(19)
		calculation.dmgM = select(7,UnitDamage("player"))
	end
	if baseAction.SpellCrit then
		calculation.critPerc = GetSpellCritChance(1)
		calculation.critM = 0.5
	end
	if baseAction.DualAttack and OffhandHasWeapon() then
		calculation.bDmgM = calculation.bDmgM * 2
	end	
	
	if calculation.haste == 0 then calculation.haste = 1 end
	calculation.hitMain, calculation.hitDW, calculation.hitDWO = DrD_GetMeleeHit(calculation.ranged)
	
	calculation.minDam = action[1]
	calculation.maxDam = (action[2] or action[1])
	
	--RELICS
	if self.RelicSlot and self.RelicSlot[actionName] then
		local data = self.RelicSlot[actionName]
		local count = #data
		if count then
			for i = 1, count - 1, 2 do
				if data[i] and data[i+1] then
					if IsEquippedItem(data[i]) then
						local modType = data["ModType"..((i+1)/2)]
						if not modType then
							calculation.minDam = calculation.minDam + data[i+1]
							calculation.maxDam = calculation.maxDam + data[i+1]
						end
					end
				end
			end
		end
	end	
	
	--TALENTS	
	for talentName, talentRank in pairs(talents) do						
		local talentTable = talentInfo[talentName]
		
		for i = 1, #talentTable do
			local talent = talentTable[i]	

			if not talent.Caster and not (baseAction.AutoAttack and talent.Specials) then 
				if DrD_MatchData(talent.Spells, actionName, calculation.actionType) or DrD_MatchData(talent.Spells, "All", calculation.actionSchool) then			
					local modType = talent.ModType
					local talentValue = (type(talent.Effect) == "table") and talent.Effect[talentRank] or talent.Effect * talentRank
					
					if not modType then
						if talent.Add then
							calculation.dmgM_AddTalent = calculation.dmgM_AddTalent + talentValue
						else	
							calculation.dmgM = calculation.dmgM * (1 + talentValue)
						end	
					elseif calculation[modType] then
						if talent.Multiply then
							calculation[modType] = calculation[modType] * (1 + talentValue)
						else
							calculation[modType] = calculation[modType] + talentValue
						end
					elseif DrDamage.Calculation[modType] then
						DrDamage.Calculation[modType](calculation, talentValue, baseAction)
					elseif modType == "Amount" then
						BuffTalentRanks[talent.Value] = talentValue
					end				
				end
			end
		end
	end
	
	calculation.dmgM = calculation.dmgM + calculation.dmgM_AddTalent
	
	--CRIT MODIFIER CALCULATION (NEEDS TO BE DONE AFTER TALENTS)
	if (calculation.actionSchool == "Physical" or calculation.actionSchool == "Ranged") and not baseAction.SpellCrit then
		calculation.critM = calculation.critM + (2 * self.Melee_critMBonus) * calculation.critM
	end
	
	--BUFF/DEBUFF CALCULATION
	if next(settings["PlayerAura"]) then
		for buffName in pairs(settings["PlayerAura"]) do
			if PlayerAura[buffName] then
				DrD_BuffCalc( PlayerAura[buffName], calculation, baseAction, buffName, nil, nil, nil, PlayerAura[buffName].Ranks, true )
			end
		end
	end
	if next(settings["TargetAura"]) then
		for buffName in pairs(settings["TargetAura"]) do
			if TargetAura[buffName] then
				DrD_BuffCalc( TargetAura[buffName], calculation, baseAction, buffName, nil, nil, nil, TargetAura[buffName].Ranks, true )
			end
		end
	end
	for index=1,40 do
		local buffName, rank, texture, apps = UnitBuff("player",index)
		if buffName then
			if PlayerAura[buffName] and not PlayerAura[buffName].Caster and not settings["PlayerAura"][buffName] then
				DrD_BuffCalc( PlayerAura[buffName], calculation, baseAction, buffName, index, apps, texture, rank )
			end
		else break end
	end
	for index=1,40 do
		local buffName, rank, texture, apps = UnitDebuff("player",index)
		if buffName then
			if PlayerAura[buffName] and not PlayerAura[buffName].Caster and not settings["PlayerAura"][buffName] then
				DrD_BuffCalc( PlayerAura[buffName], calculation, baseAction, buffName, index, apps, texture, rank )
			end
		else break end
	end
	for index=1,40 do
		local buffName, rank, texture, apps = UnitDebuff("target",index)
		if buffName then
			if TargetAura[buffName] and not TargetAura[buffName].Caster and not settings["TargetAura"][buffName] then		
				DrD_BuffCalc( TargetAura[buffName], calculation, baseAction, buffName, index, apps, texture, rank )
			end
		else break end
	end
	--Add manual selected consumables if not active
	if next(settings["Consumables"]) then
		for buffName in pairs(settings["Consumables"]) do
			if Consumables[buffName] then
				DrD_BuffCalc( Consumables[buffName], calculation, baseAction, buffName, nil, nil, nil, nil, true )
			end
		end
	end		
	
	--ADD CLASS SPECIFIC MODS
	if SetBonuses[playerClass] then
		SetBonuses[playerClass]( calculation, ActiveAuras )
	end		
	if Calculation[playerClass] then
		Calculation[playerClass]( calculation, ActiveAuras, BuffTalentRanks )
	end
	if SetBonuses[actionName] then
		SetBonuses[actionName]( calculation, ActiveAuras )
	end
	if Calculation[actionName] then
		Calculation[actionName]( calculation, ActiveAuras, BuffTalentRanks, action )
	end
	
	--ADD UP HIT PERCENTAGES FROM CLASS MODULES
	calculation.hitPerc, calculation.hitDW, calculation.hitDWO = calculation.hitMain + calculation.hitPerc, calculation.hitDW + calculation.hitPerc, calculation.hitDWO + calculation.hitPerc

	--MITIGATION AND RESILIENCE CALCULATIONS
	calculation.dmgM = calculation.dmgM * calculation.wDmgM
	calculation.dmgM_Extra = calculation.dmgM
	calculation.dmgM_Display = calculation.dmgM
	
	if settings.Mitigation_M > 0 and (calculation.actionSchool == "Physical" or calculation.actionSchool == "Ranged") and not calculation.actionType and not baseAction.eDuration then
		calculation.dmgM = calculation.dmgM * (100 - settings.Mitigation_M) / 100
	end
	if settings.Resilience_M > 0 then
		calculation.critPerc = math_max(0, calculation.critPerc - settings.Resilience_M / 39.4)
		calculation.critM = calculation.critM * ( 1 - math_min(0.5, 0.04 * settings.Resilience_M / 39.4 ))
		
		if baseAction.E_eDuration then
			calculation.dmgM_Extra = calculation.dmgM_Extra * ( 1 - math_min(1,0.01 * settings.Resilience_M / 39.4))
		end
		if baseAction.eDuration then
			calculation.dmgM = calculation.dmgM * ( 1 - math_min(1,0.01 * settings.Resilience_M / 39.4))
		end
	end	
	
	--AND NOW CALCULATE
	local avgTotal, text = DrD_DmgCalc( baseAction, action, false, false, tooltip )
	
	if tooltip then
		if not baseAction.NoCrits then
			calculation.critPerc = calculation.critPerc + 1
			CalculationResults.NextCrit = DrD_Round( DrD_DmgCalc( baseAction, action, true ) - avgTotal, 2 )
			calculation.critPerc = calculation.critPerc - 1	
		end
		if baseAction.APBonus or baseAction.WeaponDamage or baseAction.APGain then
			calculation.AP = calculation.AP + 100
			CalculationResults.NextAP = DrD_Round( DrD_DmgCalc( baseAction, action, true ) - avgTotal, 2 )
			calculation.AP = calculation.AP - 100
		end
		if baseAction.SpellDmgBonus then
			calculation.spellDmg = calculation.spellDmg + 10
			CalculationResults.NextSpellDmg = DrD_Round( DrD_DmgCalc( baseAction, action, true ) - avgTotal, 2 )
			calculation.spellDmg = calculation.spellDmg - 10
		end
		if not baseAction.Unresistable then
			local temp

			if settings.HitCalc_M then
				temp = avgTotal
			else
				temp = DrD_DmgCalc( baseAction, action, true, true )
			end

			calculation.hitPerc = calculation.hitPerc + 1
			calculation.hitDW = calculation.hitDW + 1
			calculation.hitDWO = calculation.hitDWO +1
			CalculationResults.NextHit = DrD_Round( DrD_DmgCalc( baseAction, action, true, true ) - temp, 2 )
		end			
	end	
	
	DrD_ClearTable( BuffTalentRanks )
	DrD_ClearTable( ActiveAuras )
	
	return text, CalculationResults
end

DrD_DmgCalc = function( baseAction, action, nextCalc, hitCalc, tooltip )

	if DrDamage.DmgCalculation[calculation.actionName] then
		DrDamage.DmgCalculation[calculation.actionName]( calculation, ActiveAuras, BuffTalentRanks, action )
	end

	--Calculation
	local minDam = calculation.minDam * calculation.bDmgM
	local maxDam = calculation.maxDam * calculation.bDmgM
	local minDam_O, maxDam_O
	local minCrit, maxCrit
	local minCrit_O, maxCrit_O	
	local avgHit, avgHit_O
	local avgCrit,avgCrit_O
	local avgTotal
	local avgTotal_O = 0
	local eDuration = calculation.eDuration
	local hitPerc, hitPercDW, hitPercDWO = math_max(0,math_min(100,calculation.hitPerc)), math_max(0,math_min(100,calculation.hitDW)), math_max(0,math_min(100,calculation.hitDWO))
	local hits = calculation.Hits
	local perHit
	local APmod, APoh = 0
	local spd, ospd = UnitAttackSpeed("player")
	calculation.trueDPS = 0
	
	if calculation.WeaponDamage then
		local min, max
		min, max, minDam_O, maxDam_O, APmod, APoh = DrDamage:WeaponDamage(calculation, baseAction.NoNormalization)
		minDam = minDam + (min + calculation.baseBonus) * calculation.WeaponDamage
		maxDam = maxDam + (max + calculation.baseBonus) * calculation.WeaponDamage
	end
	if OffhandHasWeapon() then
		if baseAction.AutoAttack or baseAction.DualAttack then
			minDam_O = (minDam_O + calculation.baseBonus) * calculation.WeaponDamage * calculation.offHdmgM
			maxDam_O = (maxDam_O + calculation.baseBonus) * calculation.WeaponDamage * calculation.offHdmgM
			APmod = APmod + (APoh or 0)
		elseif baseAction.OffhandAttack then
			minDam = (minDam_O + calculation.baseBonus) * calculation.WeaponDamage * calculation.offHdmgM
			maxDam = (maxDam_O + calculation.baseBonus) * calculation.WeaponDamage * calculation.offHdmgM
			minDam_O = nil
			maxDam_O = nil
			APmod = (APoh or 0)
		end
		if baseAction.OffhandBonus then
			minDam_O = minDam_O + calculation.minDam * calculation.bDmgM
			maxDam_O = maxDam_O + calculation.maxDam * calculation.bDmgM
		end
	end
	
	if baseAction.ComboPoints then
		local cp = calculation.Melee_ComboPoints
		
		if cp > 0 then
			if action.PerCombo then
				minDam = minDam + action.PerCombo * ( cp - 1 )
				maxDam = maxDam + action.PerCombo * ( cp - 1 )
			end
			if baseAction.ExtraPerCombo then
				minDam = minDam + action.Extra * baseAction.ExtraPerCombo[cp]
				maxDam = maxDam + action.Extra * baseAction.ExtraPerCombo[cp]
			end
			if baseAction.APBonus then
				if type( baseAction.APBonus ) == "table" then
					minDam = minDam + baseAction.APBonus[cp] * calculation.AP
					maxDam = maxDam + baseAction.APBonus[cp] * calculation.AP
					APmod = APmod + baseAction.APBonus[cp]
				else
					minDam = minDam + baseAction.APBonus * cp * calculation.AP
					maxDam = maxDam + baseAction.APBonus * cp * calculation.AP
					APmod = APmod + baseAction.APBonus * cp
				end
			end
			if baseAction.DurationPerCombo then
				eDuration = calculation.eDuration + baseAction.DurationPerCombo * cp
			end
		else
			calculation.zero = true
		end
	else
		if baseAction.APBonus then
			minDam = minDam + baseAction.APBonus * calculation.AP
			maxDam = maxDam + baseAction.APBonus * calculation.AP
			APmod = APmod + baseAction.APBonus
		end
	end
	
	if action.PowerBonus and calculation.powerType == UnitPowerType("player") then
		minDam = minDam + math_max(0, (UnitMana("player") - calculation.actionCost) * action.PowerBonus)
		maxDam = maxDam + math_max(0, (UnitMana("player") - calculation.actionCost) * action.PowerBonus)
		calculation.actionCost = math_max( UnitMana("player"), calculation.actionCost )
	end
	
	minDam = calculation.dmgM * minDam + (baseAction.eDuration and 0 or calculation.dmgBonus)
	maxDam = calculation.dmgM * maxDam + (baseAction.eDuration and 0 or calculation.dmgBonus)
	
	if baseAction.Weapon and BI[baseAction.Weapon] ~= mhType
	or baseAction.Offhand and BI[baseAction.Offhand] ~= ohType
	or calculation.actionSchool == "Ranged" and rgType == "None"
	or calculation.actionSchool == "Physical" and mhType == "None" and not baseAction.AutoAttack and not baseAction.NoWeapon and not baseAction.requiresForm
	or calculation.zero then
		minDam = 0
		maxDam = 0
	end
	
	avgHit = ((minDam + maxDam) / 2)
	
	if calculation.critPerc > 100 then
		calculation.critPerc = 100
	end	
	
	local critBonus = 0
	local critBonus_O = 0
	
	if not baseAction.NoCrits then
		minCrit = minDam + minDam * calculation.critM
		maxCrit = maxDam + maxDam * calculation.critM
		avgCrit = (minCrit + maxCrit) / 2
		critBonus = (calculation.critPerc / 100) * avgHit * calculation.critM
		avgTotal = avgHit + critBonus
	else
		avgTotal = avgHit
	end
	
	if (baseAction.DualAttack or baseAction.AutoAttack) and OffhandHasWeapon() then
		if baseAction.AutoAttack then
			hitPerc = hitPercDW
		end
		
		minDam_O = calculation.dmgM * minDam_O
		maxDam_O = calculation.dmgM * maxDam_O		

		avgHit_O = (minDam_O + maxDam_O)/2
		minCrit_O = minDam_O + minDam_O * calculation.critM
		maxCrit_O = maxDam_O + maxDam_O * calculation.critM
		avgCrit_O = (minCrit_O + maxCrit_O) / 2
		critBonus_O = (calculation.critPerc / 100) * avgHit_O * calculation.critM
		avgTotal_O = avgHit_O + critBonus_O
	end
	
	local extraDam
	local extraDPS = 0
	
	if baseAction.ExtraDamage then
		extraDam = (action.Extra + baseAction.ExtraDamage * calculation.AP) * calculation.dmgM_Extra + calculation.extraDamBonus	
		avgTotal = avgTotal + extraDam
		extraDPS = extraDam / (baseAction.E_eDuration or baseAction.castTime)
		APmod = APmod + baseAction.ExtraDamage
	end
	
	if hits then perHit = avgTotal end
	
	local baseAttack, avgTotalMod
	if baseAction.NextMelee then
		local min, max = DrDamage:WeaponDamage(calculation, true)
		baseAttack = calculation.dmgM * 0.5 * (min + max + 2 * calculation.baseBonus)
		avgTotalMod = avgTotal - critBonus - baseAttack
		critBonus = avgTotalMod * (calculation.critPerc / 100) * calculation.critM + baseAttack * (math_max(0,calculation.critPerc - GetCritChance()) / 100) * calculation.critM
		avgTotalMod = avgTotalMod + critBonus
	end
	
	if hits then
		avgTotal = avgTotal + (hits - 1) * perHit
		if baseAction.DualAttack then
			avgTotal_O = avgTotal_O + (hits - 1) * avgTotal_O
		end
		if avgTotalMod then
			avgTotalMod = avgTotalMod + (hits - 1) * perHit
		end
	end

	if not baseAction.Unresistable then
		if settings.HitCalc_M or hitCalc then
			if baseAction.AutoAttack or baseAction.AutoShot then
				avgTotal = (avgTotal - critBonus) * (hitPerc / 100) + critBonus
			else
				avgTotal = avgTotal * (hitPerc / 100)
				avgTotalMod = avgTotalMod and (avgTotalMod * (hitPerc / 100) + (OffhandHasWeapon() and baseAttack * (math_max(0, hitPerc - hitPercDW)/100) or 0))
			end
			if OffhandHasWeapon() then
				if baseAction.AutoAttack then
					avgTotal_O = ( avgTotal_O - critBonus_O ) * (hitPercDWO / 100) + critBonus_O
				elseif baseAction.DualAttack then
					avgTotal_O = avgTotal_O * (hitPerc / 100)
				end
			end
		end
	end
	
	local avgCombined = (avgTotalMod or avgTotal) + avgTotal_O
	local DPS, DPSCD, avgWf, avgWf_O, avgTotalWf, avgTotalWf_O

	if baseAction.AutoShot then
		DPS = avgTotal / math_max(0.5, (UnitRangedDamage("player")))
	elseif baseAction.AutoAttack or baseAction.WeaponDPS then
		if hits then DPS = (avgTotal / hits) / spd 
		else DPS = avgTotal / spd end
		
		if ospd then
			DPS = DPS + avgTotal_O / ospd
		end
	elseif baseAction.DPSrg then
		DPS = avgTotal / (UnitRangedDamage("player"))
	else
		if eDuration > 0 then
			DPS = avgCombined / eDuration + extraDPS
		end
		if calculation.cooldown > 0 then
			if baseAction.NextMelee then
				DPSCD = DrD_Round(avgCombined / (calculation.cooldown + spd * select(2,math_modf(calculation.cooldown / spd))), 1)
			else	
				DPSCD = DrD_Round(avgCombined / calculation.cooldown,1)
			end
		end
		if baseAction.SpamDPS then
			DPS = avgCombined / baseAction.SpamDPS
		end
	end
	
	if baseAction.AutoAttack then
		if calculation.WindfuryBonus then
			local min, max = DrDamage:WeaponDamage(calculation, true)
			avgWf = calculation.dmgM * calculation.WindfuryAttacks * ((min+max)/2 + calculation.WindfuryBonus/14)

			avgTotalWf = (hitPerc / 100) * (avgWf + avgWf * calculation.critM * calculation.critPerc/100)
			avgCombined = avgCombined + avgTotalWf
		end
		if calculation.WindfuryBonus_O then
			local _, _, min, max = DrDamage:WeaponDamage(calculation, true)
			avgWf_O = calculation.dmgM * calculation.WindfuryAttacks_O * calculation.offHdmgM * ((min+max)/2 + calculation.WindfuryBonus_O/14)

			avgTotalWf_O = (hitPerc / 100) * (avgWf_O + avgWf_O * calculation.critM * calculation.critPerc/100)
			avgCombined = avgCombined + avgTotalWf_O	
		end
		--model 3s cd effects later more accurately?
		if avgTotalWf or avgTotalWf_O then
			local pcm, pco
			local spd, ospd = UnitAttackSpeed("player")

			if calculation.WindfuryAttacks and calculation.WindfuryAttacks >= 2 then
				pcm = 0.2 - math_min(0.1,math_max(0,(3-spd) * 0.064))
			end
			if calculation.WindfuryAttacks_O and calculation.WindfuryAttacks_O >= 2 and ospd then
				pco = 0.2 - math_min(0.1,math_max(0,(3-ospd) * 0.064))
			end
			if pcm and pco then
				local mlt = 1 - pcm * pco * math_min(1,3/spd) * math_min(1,3/ospd)
				pcm = mlt * pcm
				pco = mlt * pco
			end
			pcm = pcm or 0.2
			pco = pco or 0.2
			if avgTotalWf then
				calculation.trueDPS = calculation.trueDPS + (avgTotalWf * math_min(20,(60/spd) * (hitPerc / 100) * pcm))/60
			end
			if avgTotalWf_O then
				calculation.trueDPS = calculation.trueDPS + (avgTotalWf_O * math_min(20,(60/ospd) * (hitPercDWO / 100) * pco))/60
			end
		end
	end
	
	if DrDamage.FinalCalculation[calculation.actionName] then
		DrDamage.FinalCalculation[calculation.actionName]( calculation, BuffTalentRanks )
	end
	
	--temp
	if DPS then
		DPS = DPS + calculation.trueDPS
	end

	if not nextCalc then
		DrD_ClearTable( CalculationResults )
	
		CalculationResults.Avg = 	math_floor(avgHit + 0.5)
		CalculationResults.AvgTotal = 	math_floor(((avgTotalMod and (avgTotal + avgTotal_O)) or avgCombined) + 0.5)
		CalculationResults.Min = 	math_floor(minDam)
		CalculationResults.Max = 	math_ceil(maxDam)

		if not baseAction.NoCrits then
			CalculationResults.AvgCrit = 	math_floor(avgCrit + 0.5)
			CalculationResults.MinCrit = 	math_floor(minCrit)
			CalculationResults.MaxCrit = 	math_ceil(maxCrit)
		else
			CalculationResults.AvgCrit = 	CalculationResults.Avg
			CalculationResults.MinCrit = 	CalculationResults.Min
			CalculationResults.MaxCrit = 	CalculationResults.Max		
		end

		if (tooltip or settings.DisplayType_M == "DPM" or settings.DisplayType_M == "PowerCost") and not baseAction.AutoShot and not baseAction.AutoAttack then
			CalculationResults.PowerType = calculation.powerType
			CalculationResults.PowerCost = 0
			
			if baseAttack and calculation.powerType == 1 then
				calculation.actionCost = calculation.actionCost + DrDamage:GetRageGain(baseAttack, calculation)
			end
			if calculation.freeCrit > 0 then
				calculation.actionCost = calculation.actionCost - calculation.actionCost * calculation.freeCrit * (calculation.critPerc / 100) * (hitPerc / 100)
			end
			if calculation.actionCost <= 0 then
				CalculationResults.DPM = "\226\136\158"
			else
				CalculationResults.DPM = DrD_Round(avgCombined / calculation.actionCost, 1)
				CalculationResults.PowerCost = math_floor(calculation.actionCost + 0.5)
			end
		end
		if tooltip then
			CalculationResults.Hit = 	DrD_Round(hitPerc, 2)
			CalculationResults.Crit = 	not baseAction.NoCrits and DrD_Round(calculation.critPerc, 2)
			CalculationResults.AP = 	calculation.AP		
			CalculationResults.Ranged =	calculation.ranged
			CalculationResults.DmgM = 	DrD_Round(calculation.dmgM_Display, 2)
			CalculationResults.APM = 	DrD_Round(APmod, 3)
			
			if DPS then
				CalculationResults.DPS = DrD_Round(DPS,1)
			end
			if DPSCD then
				CalculationResults.DPSCD = DPSCD
			end
			if avgHit_O then
				CalculationResults.AvgTotalM =	math_floor(avgTotal + 0.5)
				CalculationResults.AvgO = 	math_floor(avgHit_O + 0.5)
				CalculationResults.MinO = 	math_floor(minDam_O)
				CalculationResults.MaxO = 	math_ceil(maxDam_O)
				CalculationResults.HitO =	baseAction.AutoAttack and DrD_Round(hitPercDWO, 2) or DrD_Round(hitPerc, 2)
				CalculationResults.MinCritO = 	math_floor(minCrit_O)
				CalculationResults.MaxCritO = 	math_ceil(maxCrit_O)
				CalculationResults.AvgCritO = 	math_floor(avgCrit_O + 0.5)
				CalculationResults.AvgTotalO =  math_floor(avgTotal_O + 0.5)
			end
			if extraDam then
				CalculationResults.Extra = 	math_floor(extraDam + 0.5)
			end
			if avgWf then
				CalculationResults.WindfuryAvg = math_floor(avgWf + 0.5)
				CalculationResults.WindfuryAvgTotal = math_floor(avgTotalWf + 0.5)		
			end
			if avgWf_O then
				CalculationResults.WindfuryAvgO = math_floor(avgWf_O + 0.5)
				CalculationResults.WindfuryAvgTotalO = math_floor(avgTotalWf_O + 0.5)
			end
			if calculation.spellDmg > 0 then CalculationResults.SpellDmg = calculation.spellDmg end
			if perHit then
				CalculationResults.Hits = 	hits
				CalculationResults.PerHit =	DrD_Round(perHit, 1)
			end
		end
	end
	
	return avgCombined, CalculationResults[settings.DisplayType_M]
end

DrD_BuffCalc = function( data, calculation, baseAction, buffName, index, apps, texture, rank, manual )
	if DrD_MatchData( data.School, calculation.actionSchool )
	or not data.School and not data.Spell
	or DrD_MatchData( data.School, calculation.actionType )
	or DrD_MatchData( data.Spell, calculation.name ) then
		local modType = data.ModType
		if modType == "Update" then return end
		if modType == "Special" and Calculation[buffName] then
			Calculation[buffName]( calculation, ActiveAuras, BuffTalentRanks, index, apps, texture, rank )
		else	
			if data.ActiveAura then
				if not data.SelfCast or data.SelfCast and (index and select(7,UnitDebuff("target",index)) or not index) then
					if apps and apps > 0 then
						ActiveAuras[data.ActiveAura] = apps
					else
						ActiveAuras[data.ActiveAura] = ( ActiveAuras[data.ActiveAura] or 0 ) + 1
					end
				end
				if modType == "ActiveAura" then return end
			end

			if manual and data.Mods then
				if not GetPlayerBuffName(buffName) and (not data.Alt or data.Alt and not GetPlayerBuffName(data.Alt)) then
					for k, v in pairs(data.Mods) do
						if calculation[k] then
							calculation[k] = calculation[k] + v
						end
					end
				end
			end
			if not data.Value then return end

			if data.Ranks then
				rank = rank and tonumber(string_match(rank,"%d+")) or data.Ranks
				local value = (type(data.Value) == "table") and data.Value[rank] or data.Value * rank
				if not modType then
					calculation.dmgM = calculation.dmgM * ( 1 + value )
				elseif calculation[modType] then
					calculation[modType] = calculation[modType] + value
				end
			elseif data.Apps then
				apps = apps or data.Apps
				if calculation[modType] then
					calculation[modType] = calculation[modType] + apps * data.Value
				elseif not modType then
					calculation.dmgM = calculation.dmgM * ( 1 + apps * data.Value )		
				end				
			elseif calculation[modType] then
				calculation[modType] = calculation[modType] + data.Value
			elseif not modType then
				calculation.dmgM = calculation.dmgM * ( 1 + data.Value )
			end
		end
	end
end

function DrDamage:MeleeTooltip( frame, name, rank )
	self:MeleeCalc(name, rank, true)
	
	local baseSpell = spellInfo[name][0]
	if type(baseSpell) == "function" then name, baseSpell = baseSpell() end
	
	frame:AddLine(" ")
	
	local r, g, b = 1, 0.82745098, 0
	
	if DrD_MatchData( baseSpell.School, "Judgement" ) or name ~= frame:GetSpell() then
		frame:AddLine( name, r, g, b )
		frame:AddLine(" ")
	end	

	if not settings.DefaultColor then
		r, g, b = 0, 0.7, 0
	end

	if settings.Coeffs_M then
		frame:AddDoubleLine(L["Coeffs:"], CalculationResults.DmgM .. "/" .. CalculationResults.APM .. "/" .. CalculationResults.AP .. (CalculationResults.SpellDmg and ("/" .. CalculationResults.SpellDmg) or ""), 1, 1, 1, r, g, b  )
	
		if settings.Mitigation_M > 0 then
			frame:AddDoubleLine(L["Enemy mitigation"] .. ":", DrD_Round(settings.Mitigation_M,1) .. "%", 1, 1, 1, r, g, b )
		end	
	end

	if settings.DispCrit_M and CalculationResults.Crit then
		frame:AddDoubleLine(L["Crit"] .. ":", CalculationResults.Crit .. "%", 1, 1, 1, r, g, b )
	end

	if settings.DispHit_M and not baseSpell.Unresistable then
		frame:AddDoubleLine(L["Hit"] .. ":", CalculationResults.Hit .. "%", 1, 1, 1, r, g, b )
		if CalculationResults.HitO then
			frame:AddDoubleLine("Off-Hand " .. L["Hit"] .. ":", CalculationResults.HitO .. "%", 1, 1, 1, r, g, b )
		end
	end  				

	if not settings.DefaultColor then
		r, g, b = 0.8, 0.8, 0.9
	end
	
	if settings.AvgHit_M or settings.AvgCrit_M then
		if CalculationResults.AvgO then
			frame:AddLine("Main Hand:")
		end
	end
	if settings.AvgHit_M then
		frame:AddDoubleLine(L["Avg:"], CalculationResults.Avg .. " (".. CalculationResults.Min .."-".. CalculationResults.Max ..")", 1, 1, 1, r, g, b )
	end
	if settings.AvgCrit_M and not baseSpell.NoCrits and CalculationResults.AvgCrit then
		frame:AddDoubleLine(L["Avg Crit:"], CalculationResults.AvgCrit .. " (".. CalculationResults.MinCrit .."-".. CalculationResults.MaxCrit ..")", 1, 1, 1, r, g, b )
	end
	
	if settings.Extra_M then
		if CalculationResults.Extra then
			frame:AddDoubleLine("Additional:", CalculationResults.Extra, 1, 1, 1, r, g, b)
		end
		if CalculationResults.WindfuryAvg then
			frame:AddDoubleLine("Windfury Avg/Total:", CalculationResults.WindfuryAvg .. "/" .. CalculationResults.WindfuryAvgTotal, 1, 1, 1, r, g, b)
		end
	end
	
	if CalculationResults.Hits and CalculationResults.PerHit and settings.Ticks_M then
		frame:AddDoubleLine(L["Hits:"], CalculationResults.Hits .. "x ~" .. CalculationResults.PerHit .. ((baseSpell.PPM and (" (" .. baseSpell.PPM .. " PPM)")) or ""), 1, 1, 1, r, g, b ) 
	end
	
	if settings.Total_M and CalculationResults.AvgTotal then
		frame:AddDoubleLine(L["Avg Total:"], (CalculationResults.AvgTotalM or CalculationResults.AvgTotal), 1, 1, 1, r, g, b)
	end	
	
	if CalculationResults.AvgO and (settings.AvgHit_M or settings.AvgCrit_M) then
		frame:AddLine("Off Hand:")
	end	
	
	if baseSpell.DualAttack and settings.Extra_M or baseSpell.AutoAttack then
		if CalculationResults.AvgO then
			if settings.AvgHit_M then
				frame:AddDoubleLine(L["Avg:"], CalculationResults.AvgO .. " (".. CalculationResults.MinO .."-".. CalculationResults.MaxO ..")", 1, 1, 1, r, g, b )
			end
			if settings.AvgCrit_M and CalculationResults.AvgCritO then
				frame:AddDoubleLine(L["Avg Crit:"], CalculationResults.AvgCritO .. " (".. CalculationResults.MinCritO .."-".. CalculationResults.MaxCritO ..")", 1, 1, 1, r, g, b )
			end
			if settings.Total_M and CalculationResults.AvgTotalO then -- and CalculationResults.AvgTotalO > CalculationResults.AvgO then
				frame:AddDoubleLine(L["Avg Total:"], CalculationResults.AvgTotalO, 1, 1, 1, r, g, b  )
			end
			if settings.Extra_M and CalculationResults.WindfuryAvgO then
				frame:AddDoubleLine("Windfury Avg/Total:", CalculationResults.WindfuryAvgO .. "/" .. CalculationResults.WindfuryAvgTotalO, 1, 1, 1, r, g, b)
			end			
		end
	end	
	
	if settings.Total_M and CalculationResults.AvgTotalO then
		frame:AddLine("-")
		frame:AddDoubleLine("Combined Total:", CalculationResults.AvgTotal, 1, 1, 1, r, g, b  )
	end
	

	if not settings.DefaultColor then
		r, g, b = 0.3, 0.6, 0.5
	end
	
	local bType
	if CalculationResults.Ranged then
		bType = "RAP"
	else
		bType = "AP"
	end
	
	if not baseSpell.NoNext and settings.Next_M then
		local critA, hitA, apA, sdA
		
		if CalculationResults.NextAP then
			frame:AddDoubleLine("+100 " .. bType .. ":", ((CalculationResults.NextAP > 0) and "+" or "") .. CalculationResults.NextAP, 1, 1, 1, r, g, b )
			if CalculationResults.NextAP > 0.15 then
				apA = DrD_Round(CalculationResults.AvgTotal/ CalculationResults.NextAP, 1)
			end
		end
		if CalculationResults.NextSpellDmg then
			frame:AddDoubleLine("+10 Spell Dmg:", "+" .. CalculationResults.NextSpellDmg, 1, 1, 1, r, g, b )
			if CalculationResults.NextSpellDmg > 0.15 then
				sdA = DrD_Round(CalculationResults.AvgTotal * 0.1 / CalculationResults.NextSpellDmg, 1)
			end
		end		
		if CalculationResults.NextCrit then
			frame:AddDoubleLine("+1% " .. L["Crit"] .. " (" .. self:GetRating("Crit") .. "):", "+" .. CalculationResults.NextCrit, 1, 1, 1, r, g, b )
			if CalculationResults.NextCrit > 0.15 then
				critA = DrD_Round(CalculationResults.AvgTotal * 0.01 / CalculationResults.NextCrit * self:GetRating("Crit", nil, true ), 1 )
			end
		end
		if CalculationResults.NextHit then
			frame:AddDoubleLine("+1% " .. L["Hit"] .. " (" .. self:GetRating("MeleeHit") .. "):", ((CalculationResults.NextHit > 0) and "+" or "") .. CalculationResults.NextHit, 1, 1, 1, r, g, b )
			if CalculationResults.NextHit > 0.15 then
				hitA = DrD_Round(CalculationResults.AvgTotal * 0.01 / CalculationResults.NextHit * self:GetRating("MeleeHit", nil, true), 1 )
			end  										
		end
		
		if critA or hitA or apA or sdA then
			frame:AddDoubleLine("+1% Total (" .. ((critA and (L["Cr"] .. ((hitA or apA) and "/" or ""))) or "") .. ((hitA and (L["Ht"] .. (apA and "/" or ""))) or "") .. (apA and bType or "") .. ((sdA and "/+dmg") or "") .. "):", ((critA and (critA .. ((hitA or apA) and "/" or ""))) or "") .. ((hitA and (hitA .. (apA and "/" or ""))) or "") .. (apA or "") .. (sdA and ("/" .. sdA) or ""), 1, 1, 1, r, g, b )
		end
	end

	if not settings.DefaultColor then
		r, g, b = 0.8, 0.1, 0.1
	end
	
	if not baseSpell.NoDPS and settings.DPS_M then
		if CalculationResults.DPS then
			frame:AddDoubleLine( "DPS" .. ((baseSpell.DPSrg and " (1/wspd):") or ":"), CalculationResults.DPS, 1, 1, 1, r, g, b )
		end
		if CalculationResults.DPSCD then
			frame:AddDoubleLine( "DPS(CD):", CalculationResults.DPSCD, 1, 1, 1, r, g, b )
		end
	end

	if CalculationResults.DPM and not baseSpell.NoDPM and settings.DPM_M then
		frame:AddDoubleLine( "Dmg/" .. powerTypes[CalculationResults.PowerType], CalculationResults.DPM, 1, 1, 1, r, g, b )
	end

	frame:Show()
end