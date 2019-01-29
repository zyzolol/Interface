local _, playerClass = UnitClass("player")
if playerClass ~= "DRUID" and playerClass ~="MAGE" and playerClass ~="PALADIN" and playerClass ~="PRIEST" and playerClass ~="SHAMAN" and playerClass ~="WARLOCK" then return end
local playerHealer = (playerClass == "PRIEST") or (playerClass == "SHAMAN") or (playerClass == "PALADIN") or (playerClass == "DRUID")
local playerHybrid = (playerClass == "DRUID") or (playerClass == "PALADIN") or (playerClass == "SHAMAN")
local hybridMana = (playerClass == "DRUID")

--Libraries
DrDamage = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0", "AceDB-2.0", "AceHook-2.1", "FuBarPlugin-2.0")
local L = AceLibrary("AceLocale-2.2"):new("DrDamage")
local GT = LibStub:GetLibrary("LibGratuity-3.0")
local DrDamage = DrDamage

--General
local settings
local type = type
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local next = next
local math_abs = math.abs
local math_floor = math.floor
local math_ceil = math.ceil
local math_min = math.min
local math_max = math.max
local string_match = string.match
local string_gsub = string.gsub
local string_find = string.find
local select = select

--Module
local UnitDamage = UnitDamage
local UnitLevel = UnitLevel
local UnitMana = UnitMana
local UnitPowerType = UnitPowerType
local UnitIsPlayer = UnitIsPlayer
local UnitIsFriend = UnitIsFriend
local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists
local UnitStat = UnitStat
local GetSpellInfo = GetSpellInfo
local IsEquippedItem = IsEquippedItem
local IsShiftKeyDown = IsShiftKeyDown
local GetPlayerBuffName = GetPlayerBuffName
local GetSpellBonusDamage = GetSpellBonusDamage
local GetSpellBonusHealing = GetSpellBonusHealing
local GetSpellCritChance = GetSpellCritChance
local GetCritChance = GetCritChance
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local GetManaRegen = GetManaRegen
local GetTalentInfo = GetTalentInfo

--Module variables
local spellInfo, talentInfo, talents
local PlayerAura, TargetAura, Consumables
local Calculation, SetBonuses
local playerMana

local function DrD_ClearTable(table)
	for k in pairs(table) do
		table[k] = nil
	end
end

local function DrD_Round(x, y)
	return math_floor(x * 10 ^ y + 0.5) / 10 ^ y
end

local function DrD_MatchData( data, ... )
	if not data or not ... then
		return false
	end

	if type(data) == "table" then
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

DrDamage.defaults = {
	--Calculation
	HitCalc = false,
	HitTarget = false,
	TargetLevel = 3,
	TargetPlayer = false,
	SpellDamage = 0,
	Healing = 0,
	ShadowDamage = 0,
	FireDamage = 0,
	NatureDamage = 0,
	FrostDamage = 0,
	ArcaneDamage = 0,
	HolyDamage = 0,
	HitRating = 0,
	CritRating = 0,
	HasteRating = 0,
	MP5 = 0,
	Resilience = 0,
	ManualDmg = false,
	ManualPlus = false,
	ManaConsumables = false,
	--Actionbar:
	DisplayType = "AvgTotal",
	CastsLeft = false,
	CastsLeftDmg = false,
	--Tooltip:
	PlusDmg = true,
	Coeffs = true,
	DispCrit = true,
	DispHit = true,
	AvgHit = true,
	AvgCrit = true,
	Ticks = true,
	Total = true,
	Extra = true,
	Next = true,
	DPS = true,
	DPM = true,
	Doom = true,
	Casts = true,
	TwoRoll = false,
	ManaUsage = false,
	--Comparisons
	CompareDmg = true,
	CompareHit = false,
	CompareCrit = false,
	CompareHaste = false,
}

function DrDamage:Caster_Options()
	local table
	
	if playerHybrid then
		self.options.args.Caster = { type = "group", desc = "Caster Options", name = "Caster", order = 2, args = {} }
		table = self.options.args.Caster.args	
	else
		table = self.options.args
	end	
	
	table.ActionBar = {
		type = "group", desc = L["Options for the actionbar"], name = L["ActionBar"],
		args = {
			DisplayType = {
				type = "text",
				name = L["Display"],
				desc = L["Choose what to display on the actionbar"],
				validate =  {
					["Avg"] = L["Avg"],
					["AvgTotal"] = L["AvgTotal"],
					["AvgHit"] = L["AvgHit"],
					["AvgHitTotal"] = L["AvgHitTotal"], 
					["MinHit"] = L["MinHit"], 
					["MaxHit"] = L["MaxHit"], 
					["Max"] = L["Max"], 
					["DPS"] = L["DPS"], 
					["DPSC"] = L["DPSC"], 
					["DPSCD"] = L["DPSCD"], 
					["DPM"] = L["DPM"], 
					["MPS"] = L["MPS"], 
					["ManaCost"] = L["ManaCost"], 
					["TrueManaCost"] = L["TrueManaCost"], 
				},
				get =  function() return settings["DisplayType"] end,
				set =  DrD_Set("DisplayType"),
				order = 70,
			}, 					
			CastsLeftDmg = {
				type = 'toggle',
				name = L["Damage spell casts left"],
				desc = L["Toggles amount of casts left to display on actionbar for damaging spells"],
				order = 100,
				get = function() return settings["CastsLeftDmg"] end,
				set = DrD_Set("CastsLeftDmg"),
			},				
		},
	}
	table.Tooltip = {
		type = "group", desc = L["Options for the tooltips"], name = L["Tooltip"],
		args = {					
			PlusDmg = {
				type = 'toggle',
				name = L["Show efficient +dmg/+healing"],
				desc = L["Toggles displaying of efficient +dmg/+healing"],
				order = 52,
				get = function() return settings["PlusDmg"] end,
				set = DrD_Set("PlusDmg", true),
			},
			Coeffs = {
				type = 'toggle',
				name = L["Show coefficients"],
				desc = L["Toggles displaying of spell calculation data"],
				order = 53,
				get = function() return settings["Coeffs"] end,
				set = DrD_Set("Coeffs", true),
			},				
			DispCrit = {
				type = 'toggle',
				name = L["Show crit %"],
				desc = L["Toggles displaying of crit %"],
				order = 54,
				get = function() return settings["DispCrit"] end,
				set = DrD_Set("DispCrit", true),
			},
			DispHit = {
				type = 'toggle',
				name = L["Show hit %"],
				desc = L["Toggles displaying of hit %."],
				order = 56,
				get = function() return settings["DispHit"] end,
				set = DrD_Set("DispHit", true),
			},				
			AvgHit = {
				type = 'toggle',
				name = L["Show avg + hit range"],
				desc = L["Toggles displaying of avg hit"],
				order = 58,
				get = function() return settings["AvgHit"] end,
				set = DrD_Set("AvgHit", true),
			},
			AvgCrit = {
				type = 'toggle',
				name = L["Show avg crit + crit range"],
				desc = L["Toggles displaying of avg crit"],
				order = 60,
				get = function() return settings["AvgCrit"] end,
				set = DrD_Set("AvgCrit", true),
			},
			Ticks = {
				type = 'toggle',
				name = L["Show per tick/hit"],
				desc = L["Toggles displaying of per hit/tick values"],
				order = 62,
				get = function() return settings["Ticks"] end,
				set = DrD_Set("Ticks", true),
			},
			Total = {
				type = 'toggle',
				name = L["Show avg total dmg/heal"],
				desc = L["Toggles displaying of average in total values"],
				order = 64,
				get = function() return settings["Total"] end,
				set = DrD_Set("Total", true),
			},				
			Extra = {
				type = 'toggle',
				name = L["Show extra dmg/heal (DoT, Ignite, Chained)"],
				desc = L["Toggles displaying of extra info"],
				order = 66,
				get = function() return settings["Extra"] end,
				set = DrD_Set("Extra", true),
			},
			Next = {
				type = 'toggle',
				name = L["Show next values (+1% crit, +10 dmg)"],
				desc = L["Toggles displaying of +1% crit, +10 dmg values"],
				order = 68,
				get = function() return settings["Next"] end,
				set = DrD_Set("Next", true),
			},
			CompareDmg = {
				type = 'toggle',
				name = L["Compare +dmg"],
				desc = L["Toggles comparing +dmg/+heal to other stats."],
				order = 69,
				get = function() return settings["CompareDmg"] end,
				set = DrD_Set("CompareDmg", true),
			},
			CompareCrit = {
				type = 'toggle',
				name = L["Compare crit rating"],
				desc = L["Toggles comparing crit rating to other stats"],
				order = 70,
				get = function() return settings["CompareCrit"] end,
				set = DrD_Set("CompareCrit", true),
			},
			CompareHit = {
				type = 'toggle',
				name = L["Compare hit rating"],
				desc = L["Toggles comparing hit rating to other stats"],
				order = 71,
				get = function() return settings["CompareHit"] end,
				set = DrD_Set("CompareHit", true),
			},			
			CompareHaste = {
				type = 'toggle',
				name = L["Compare haste rating"],
				desc = L["Toggles comparing haste rating to other stats"],
				order = 72,
				get = function() return settings["CompareHaste"] end,
				set = DrD_Set("CompareHaste", true),
			},
			DPS = {
				type = 'toggle',
				name = L["Show DPS/HPS"],
				desc = L["Toggles displaying of DPS/HPS"],
				order = 80,
				get = function() return settings["DPS"] end,
				set = DrD_Set("DPS", true),
			},
			DPM = {
				type = 'toggle',
				name = L["Show DPM/HPM"],
				desc = L["Toggles displaying of DPM/HPM"],
				order = 85,
				get = function() return settings["DPM"] end,
				set = DrD_Set("DPM", true),
			},
			Doom = {
				type = 'toggle',
				name = L["Show Damage/healing until OOM"],
				desc = L["Toggles displaying of damage/healing until OOM"],
				order = 90,
				get = function() return settings["Doom"] end,
				set = DrD_Set("Doom", true),
			},
			Casts = {
				type = 'toggle',
				name = L["Show casts and time until OOM."],
				desc = L["Toggles displaying of casts and time until OOM (regen included)"],
				order = 95,
				get = function() return settings["Casts"] end,
				set = DrD_Set("Casts", true),
			},
			ManaUsage = {
				type = 'toggle',
				name = L["Show additional mana usage information."],
				desc = L["Toggles displaying of true mana cost (if different) and mana per seconds cast"],
				order = 100,
				get = function() return settings["ManaUsage"] end,
				set = DrD_Set("ManaUsage", true),
			},
		},
	}		
	table.Calculation = {
		type = "group", desc = L["Calculation options"], name = L["Calculation"],
		args = {
			ManaConsumables = {
				type = 'toggle',
				name = L["Include mana consumables into calculation"],
				desc = L["Toggles usage of super mana potions (Mages, also mana gems) into casts left with regen calculation."],
				order = 63,
				get = function() return settings["ManaConsumables"] end,
				set = DrD_Set("ManaConsumables"),
			},				
			TwoRoll = {
				type = 'toggle',
				name = L["Toggle usage of two roll hit calculation"],
				desc = L["Toggles two roll hit calculation on. Don't change this unless you know what this does."],
				order = 64,
				get = function() return settings["TwoRoll"] end,
				set = DrD_Set("TwoRoll"),
			},			
			HitCalc = {			
				type = 'toggle',
				name = L["+Hit calculation"],
				desc = L["Toggles +hit calculation effects into averages on/off"],
				order = 65,
				get = function() return settings["HitCalc"] end,
				set = DrD_Set("HitCalc"),
			},
			HitTarget = {			
				type = 'toggle',
				name = L["Hit calculation by current target"],
				desc = L["Toggles +hit calculation by target level and type. If nothing is targeted, the manually set level is used."],
				order = 66,
				get = function() return settings["HitTarget"] end,
				set = DrD_Set("HitTarget"),
			},
			TargetLevel = {
				type = 'range',
				name = L["Manual target level setting"],
				desc = L["Manual set of target level compared to your level. Make sure 'HitTarget' is turned off to use this."],
				min = -10,
				max = 10,
				step = 1,
				order = 67,
				get = function() return settings["TargetLevel"] end,
				set = DrD_Set("TargetLevel"),
			},
			TargetPlayer = {
				type = 'toggle',
				name = L["Manual target is a player."],
				desc = L["Toggles if your manually set target is a player."],
				order = 68,
				get = function() return settings["TargetPlayer"] end,
				set = DrD_Set("TargetPlayer"),
			},				
			ManualDmg = {
				type = 'toggle',
				name = L["Manual variables"],
				desc = L["Allows you to manually set damage/healing properties"],
				order = 71,
				get = function() return settings["ManualDmg"] end,
				set = DrD_Set("ManualDmg"),
			},
			ManualPlus = {
				type = 'toggle',
				name = L["Manual damage adds to detected"],
				desc = L["Allows you to set if manual values should add to detected values"],
				order = 72,
				get = function() return settings["ManualPlus"] end,
				set = DrD_Set("ManualPlus"),
			}, 				
			SpellDamage = {
				type = 'range',
				name = L["Spell Damage"],
				min = -500,
				max = 2000,
				step = 1,
				desc = L["Input your spell damage"],
				order = 80,
				get = function() return settings["SpellDamage"] end,
				set = DrD_Set("SpellDamage"),
			},					
			CritRating = {
				type = 'range',
				name = L["Manual critical rating"],
				min = -400,
				max = 1000,
				step = 1,
				desc = L["Input critical rating you want to use."],
				order = 88,
				get = function() return settings["CritRating"] end,
				set = DrD_Set("CritRating"),					
			},
			HitRating = {
				type = 'range',
				name = L["Manual hit rating"],
				min = -200,
				max = 500,
				step = 1,
				desc = L["Input hit rating you want to use."],
				order = 89,
				get = function() return settings["HitRating"] end,
				set = DrD_Set("HitRating"),	
			},
			HasteRating = {
				type = 'range',
				name = L["Manual haste rating"],
				min = -600,
				max = 1000,
				step = 1,
				desc = L["Input haste rating you want to use."],
				order = 90,
				get = function() return settings["HasteRating"] end,
				set = DrD_Set("HasteRating"),	
			},
			ManaPer5 = {
				type = 'range',
				name = L["Manual MP5"],
				min = -1000,
				max = 1000,
				step = 1,
				desc = L["Input MP5 you want to use."],
				order = 91,
				get = function() return settings["MP5"] end,
				set = DrD_Set("MP5"),	
			},
			Resilience = {
				type = 'range',
				name = L["Target resilience"],
				min = 0,
				max = 1000,
				step = 1,
				desc = L["Input your target's resilience."],
				order = 92,
				get = function() return settings["Resilience"] end,
				set = DrD_Set("Resilience"),	
			},
		},
	}
	local calcTable = table.Calculation.args	
	if playerHealer then
		table.ActionBar.args.CastsLeft = {
			type = 'toggle',
			name = L["Healing casts left"],
			desc = L["Toggles amount of casts left to display on actionbar for heals"],
			order = 105,
			get = function() return settings["CastsLeft"] end,
			set = DrD_Set("CastsLeft"),
		}
		calcTable.Healing = {
			type = 'range',
			name = L["Healing"],
			min = -500,
			max = 2000,
			step = 1,
			desc = L["Input your +healing"],
			order = 79,
			get = function() return settings["Healing"] end,
			set = DrD_Set("Healing"),
		}		
	end
	if playerClass == "MAGE" or playerClass == "WARLOCK" or playerClass == "SHAMAN" then
		calcTable.FireDamage = {
			type = 'range',
			name = L["Fire Damage"],
			min = -500,
			max = 2000,
			step = 1,
			desc = L["Input your fire +damage"],
			order = 81,
			get = function() return settings["FireDamage"] end,
			set = DrD_Set("FireDamage"),
		}
	end
	if playerClass == "PRIEST" or playerClass == "WARLOCK" then
		calcTable.ShadowDamage = {
			type = 'range',
			name = L["Shadow Damage"],
			min = -500,
			max = 2000,
			step = 1,
			desc = L["Input your shadow +damage"],
			order = 82,
			get = function() return settings["ShadowDamage"] end,
			set = DrD_Set("ShadowDamage"),		
		}
	end
	if playerClass == "MAGE" or playerClass == "SHAMAN" then
		calcTable.FrostDamage = {
			type = 'range',
			name = L["Frost Damage"],
			min = -500,
			max = 2000,
			step = 1,
			desc = L["Input your frost +damage"],
			order = 83,
			get = function() return settings["FrostDamage"] end,
			set = DrD_Set("FrostDamage"),		
		}
	end
	if playerClass == "DRUID" or playerClass == "SHAMAN" then
		calcTable.NatureDamage = {
			type = 'range',
			name = L["Nature Damage"],
			min = -500,
			max = 2000,
			step = 1,
			desc = L["Input your nature +damage"],
			order = 84,
			get = function() return settings["NatureDamage"] end,
			set = DrD_Set("NatureDamage"),		
		}
	end
	if playerClass == "DRUID" or playerClass == "MAGE" then
		calcTable.ArcaneDamage = {
			type = 'range',
			name = L["Arcane Damage"],
			min = -500,
			max = 2000,
			step = 1,
			desc = L["Input your arcane +damage"],
			order = 85,
			get = function() return settings["ArcaneDamage"] end,
			set = DrD_Set("ArcaneDamage"),		
		}
	end
	if playerClass == "PALADIN" or playerClass == "PRIEST" then
		calcTable.HolyDamage = {
			type = 'range',
			name = L["Holy Damage"],
			min = -500,
			max = 2000,
			step = 1,
			desc = L["Input your holy +damage"],
			order = 85,
			get = function() return settings["HolyDamage"] end,
			set = DrD_Set("HolyDamage"),		
		}
	end
end

local displayTypeTable = { ["Avg"] = 1, ["AvgTotal"] = 1, ["AvgHit"] = 2, ["AvgHitTotal"] = 2, ["MinHit"] = 3, ["MaxHit"] = 4, ["Max"] = 5, ["DPS"] = 6, ["DPSC"] = 6, ["DPSCD"] = 6, ["DPM"] = 2, ["MPS"] = 2, ["ManaCost"] = 2, ["TrueManaCost"] = 2, }
function DrDamage:Caster_Data()
	if not playerHybrid then 
		self.ClassSpecials[GetSpellInfo(5019)] =  function()
			if not HasWandEquipped() then return "" end
			local speed, lowDmg, hiDmg = UnitRangedDamage("player")
			local avgDmg = (lowDmg + hiDmg) / 2
			local avgTotal = avgDmg * (1 + 0.005 * GetRangedCritChance())
			return math_floor(0.5 + select(displayTypeTable[settings.DisplayType] or 2, avgTotal, avgDmg, lowDmg + 0.5, hiDmg, hiDmg * 1.5, avgTotal / speed))
		end
	end
end

function DrDamage:Caster_OnEnable()
	if self.Caster_Options then
		self:Caster_Options()
		self.Caster_Options = nil
	end
	if self.Caster_Data then
		self:Caster_Data()
		self.Caster_Data = nil
	end
	if settings.ABText then
		self:RegisterBucketEvent("UNIT_MANA", 2)
	end	
	
	playerMana = UnitMana("player")
	if hybridMana then
		self.lastMana = playerMana
	end
	
	if not displayTypeTable[settings.DisplayType] then
		settings.DisplayType = "AvgTotal"
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

function DrDamage:Caster_OnProfileEnable()
	settings = self.db.profile
end

function DrDamage:Caster_InventoryChanged()
	local update = self:CheckRelicSlot()
	if self:Caster_CheckBaseStats() or update then
		return true	
	end
end

local oldValues = 0
function DrDamage:Caster_CheckBaseStats()
	local newValues = 0

	for i = 1, 7 do
		newValues = newValues + GetSpellBonusDamage(i)
		newValues = newValues + GetSpellCritChance(i)
	end

	newValues = newValues + GetSpellBonusHealing() + GetCombatRatingBonus(8) + GetCombatRatingBonus(20) + UnitStat("player",5)

	if newValues ~= oldValues then
		oldValues = newValues
		return true
	end

	return false	
end

function DrDamage:UNIT_MANA( units )
	if not hybridMana and not settings.CastsLeft and not settings.CastsLeftDmg then
		return
	end
	for unit in pairs( units ) do
		if UnitIsUnit(unit, "player") then
			if hybridMana and UnitPowerType("player") == 0 then
				self.lastMana = UnitMana("player")
				if not settings.CastsLeft and not settings.CastsLeftDmg then
					return
				end
			end
			if math_abs( UnitMana( "player" ) - playerMana ) >= ( 20 + UnitLevel( "player" ) * 2 ) then
				playerMana = UnitMana( "player" )
				if not DrDamage:IsEventScheduled("DrD_FullUpdate") then
					self:CancelSpellUpdate()
					self:ScheduleEvent("DrD_FullUpdate", self.UpdateAB, 1, self)
				end
			end
			return
		end
	end
end

--Static hit calculation tables
local hitDataMOB = { [0] = 96, 95, 94, 83, 72, 61, 50, 39, 28, 17, 6 }
local hitDataPlayer = { [0] = 96, 95, 94, 87, 80, 73, 66, 59, 52, 45, 38 }
local hitMod = select(2, UnitRace("player")) == "Draenei" and (playerClass == "MAGE" or playerClass == "PRIEST" or playerClass == "SHAMAN") and 1 or 0
local lastTargetLevel
local lastSpellHit
local lastPlayer

local function DrD_SpellHit()
	local hitPerc = 99
	
	if settings.HitTarget and UnitExists("target") then
		local levelDiff, _, targetLevel = DrDamage:GetLevels()

		if levelDiff >= 0 then
			if UnitIsPlayer("target") then
				hitPerc = hitDataPlayer[levelDiff]
			else
				hitPerc = hitDataMOB[levelDiff]
			end
		end
		lastTargetLevel = targetLevel
	else
		if settings.TargetLevel >= 0 then
			if settings.TargetPlayer then
				hitPerc = hitDataPlayer[math_floor(settings.TargetLevel)]
				lastPlayer = true
			else
				hitPerc = hitDataMOB[math_floor(settings.TargetLevel)]
				lastPlayer = false
			end
		end
		lastTargetLevel = settings.TargetLevel
	end
	
	lastSpellHit = hitPerc + hitMod
	
	return lastSpellHit
end

--Static tables
local schoolTable = { ["Holy"] = 2, ["Fire"] = 3, ["Nature"] = 4, ["Frost"] = 5, ["Shadow"] = 6, ["Arcane"] = 7 }
local debuffMods = { [GetSpellInfo(32385)] = true, [GetSpellInfo(37577)] = true }

--Values you can modify with the modify table (4th arg in DrDamage:CasterCalc)
local modifyTable = { "spellDmg", "dmgM", "critPerc", "hitPerc", "manaRegen", "finalMod", "manaMod", "manaCostM", "castTime" }

--Temporary tables
local calculation = {}
local ActiveAuras = {}
local BuffTalentRanks = {}
local CalculationResults = {}

--Local functions
local DrD_DmgCalc, DrD_BuffCalc

function DrDamage:CasterCalc( name, rank, tooltip, modify )
	if not spellInfo or not name then return end
	if not rank then
		_, rank = GetSpellInfo(name)
	elseif tonumber(rank) and GetSpellInfo(name) then
		rank = string_gsub(select(2,GetSpellInfo(name)),"%d+", rank)
	end

	--Base spell information
	local spell, baseSpell, spellName
	
	if spellInfo[name]["Secondary"] and (settings.SwapCalc and (not tooltip or not IsShiftKeyDown()) or not settings.SwapCalc and tooltip and IsShiftKeyDown()) then
		spell = spellInfo[name]["Secondary"][(rank and tonumber(string_match(rank,"%d+"))) or "None"]
		baseSpell = spellInfo[name]["Secondary"][0]
		spellName = spellInfo[name]["Secondary"]["Name"]
	else
		baseSpell = spellInfo[name][0]
		if type(baseSpell) == "function" then
			baseSpell, spell, spellName = baseSpell()
		else
			spell = spellInfo[name][(rank and tonumber(string_match(rank,"%d+"))) or "None"]
			spellName = spellInfo[name]["Name"]
		end
	end
	
	if not spell then return end
	
	local healingSpell = baseSpell.Healing or DrD_MatchData(baseSpell.School, "Healing")		--Healing spell (boolean)
	
	calculation.healingSpell = healingSpell
	calculation.hitPerc = lastSpellHit								--Hit chance (%)	
	calculation.castTime = spell.castTime or baseSpell.castTime or 1.5				--Cast time
	calculation.eDuration = spell.eDuration or baseSpell.eDuration or 1				--Effect duration
	calculation.sHits = spell.sHits or baseSpell.sHits						--Amount of hits(ticks) of spell
	calculation.critM = 0.5										--Crit multiplier
	calculation.bNukeDmg = 0									--Modifier for spells with a DOT portion
	calculation.bDmgM = 1										--Base damage Modifier
	calculation.dmgM = 1
	calculation.spellDmgM_AddTalent = 0								--Talents: Spell damage multiplier additive	
	calculation.dmgM_AddTalent = 0									--Talents: Damage multiplier additive
	calculation.spellDmgM_AddNoDownrank = 0								--Additive spell damage modifier (not affected by downranking)
	calculation.dotSpellDmgM = (baseSpell.dotFactor or calculation.eDuration / 15)			--Dot portion spelldamage modifier
	calculation.cooldown = baseSpell.Cooldown or 0							--Spell's cooldown
	calculation.finalMod = 0 									--Modifier to final damage +/-
	calculation.finalMod_fM = 0
	calculation.finalMod_sM = 0
	calculation.finalMod_M = 1
	calculation.dotFinalMod = 0									--Modifier to final dot damage +/-
	calculation.minDam = spell[1]									--Spell initial base min damage
	calculation.maxDam = spell[2]									--Spell initial base max damage
	calculation.chainFactor = baseSpell.chainFactor							--Chain effect spells
	_, calculation.manaRegen = GetManaRegen("player")						--Mana regen while casting
	calculation.lowRankFactor = 1
	calculation.lowLevelFactor = 1
	calculation.manaMod = 0
	calculation.manaCostM = 1
	calculation.manaCost = select(4,GetSpellInfo(name,rank)) or 0
	calculation.freeCrit = 0
	calculation.igniteM = 0
	calculation.leechBonus = 1
	calculation.name = name
	calculation.spellName = spellName
	calculation.haste = GetCombatRating(20)
	calculation.NoDebuffs = baseSpell.NoDebuffs
		
	if type(baseSpell.School) == "table" then
		calculation.spellSchool = baseSpell.School[1]
		calculation.spellType = baseSpell.School[2]
	else
		calculation.spellSchool = baseSpell.School
		calculation.spellType = nil
	end
	
	--Calculate +healing/+dmg
	if healingSpell then
		calculation.spellDmg = GetSpellBonusHealing()
	else
		calculation.spellDmg = GetSpellBonusDamage(schoolTable[calculation.spellSchool] or 1)
	end
	
	--Calculate spelldamage modifier
	if baseSpell.bonusFactor then
		calculation.spellDmgM = baseSpell.bonusFactor
	elseif baseSpell.eDot then 
		calculation.spellDmgM = (calculation.eDuration / 15)
	else
		calculation.spellDmgM = (calculation.castTime / 3.5) 
	end
	
	--Calculated modified base spelldamage modifier (Frostbolt's Snare)
	if baseSpell.sFactor_Base then
		calculation.spellDmgM = calculation.spellDmgM * baseSpell.sFactor_Base
	end
	
	--Factor for downranking
	if not baseSpell.NoDownRank then
		local playerLevel = UnitLevel("player")
		local downRankMod = spell.Downrank or baseSpell.Downrank or 0
		local lowRankFactor = (spell.spellLevel + 11 + downRankMod) / playerLevel

		if lowRankFactor < 1 then
			calculation.lowRankFactor = lowRankFactor
		end
	end
	
	--Factor for spells under level 20
	if spell.spellLevel and spell.spellLevel < 20 and not baseSpell.NoLowLevelPenalty then
		local lowLevelFactor = 1 - ((20 - spell.spellLevel) * 0.0375)
		
		if lowLevelFactor < 1 and lowLevelFactor > 0 then
			calculation.lowLevelFactor = lowLevelFactor
		end
	end	
		
	--Calculate base hit chance (only if needed)
	if settings.HitTarget and UnitLevel("target") ~= lastTargetLevel then
		calculation.hitPerc = DrD_SpellHit() 		
	elseif not settings.HitTarget and (settings.TargetLevel ~= lastTargetLevel or lastPlayer ~= settings.TargetPlayer) then
		calculation.hitPerc = DrD_SpellHit()
	end	
	
	--Calculate crit/hit
	if not DrD_MatchData(baseSpell.School, "Physical") then
		calculation.critPerc = GetSpellCritChance(schoolTable[calculation.spellSchool] or 1)
		calculation.hitPerc = calculation.hitPerc + GetCombatRatingBonus(8)
	else
		calculation.critPerc = GetCritChance()
		calculation.critM = 1
		calculation.hitPerc = calculation.hitPerc + GetCombatRatingBonus(6)
	end
		
	--Random item bonuses to base values not supplied by API
	if self.RelicSlot and self.RelicSlot[spellName] then
		local data = self.RelicSlot[spellName]
		local count = #data
		if count then
			for i = 1, count - 1, 2 do
				if data[i] and data[i+1] then
					if IsEquippedItem(data[i]) then
						local modType = data["ModType"..((i+1)/2)]

						if not modType then
							calculation.spellDmg = calculation.spellDmg + data[i+1]
						elseif calculation[modType] then
							calculation[modType] = calculation[modType] + data[i+1]
						elseif modType == "Base" then
							calculation.minDam = calculation.minDam + data[i+1]
							calculation.maxDam = calculation.maxDam + data[i+1]
						end
					end
				end
			end
		end
	end	

	--Manual variables from profile:
	if settings.ManualDmg then
		if settings.ManualPlus then
			if healingSpell then
				calculation.spellDmg = math_max(0, calculation.spellDmg + settings.Healing)
			else
				calculation.spellDmg = math_max(0, calculation.spellDmg + settings.SpellDamage)
			end
			calculation.critPerc = math_max(0, calculation.critPerc + self:GetRating("Crit", settings.CritRating, true))
			calculation.hitPerc = math_max(0, calculation.hitPerc + self:GetRating("Hit", settings.HitRating, true))	
		else
			if healingSpell then
				calculation.spellDmg = settings.Healing
			else
				calculation.spellDmg = settings.SpellDamage
			end
			if not DrD_MatchData(baseSpell.School, "Physical") then
				calculation.critPerc = calculation.critPerc - GetCombatRatingBonus(11) + self:GetRating("Crit", settings.CritRating, true)
				calculation.hitPerc = calculation.hitPerc - GetCombatRatingBonus(8) + self:GetRating("Hit", settings.HitRating, true)
			else
				calculation.critPerc = calculation.critPerc - GetCombatRatingBonus(9) + self:GetRating("Crit", settings.CritRating, true)
				calculation.hitPerc = calculation.hitPerc - GetCombatRatingBonus(6) + self:GetRating("MeleeHit", settings.HitRating, true)
			end			
		end
		
		if healingSpell then
			calculation.spellDmg = math_max(0, calculation.spellDmg + settings.Healing)
		else
			local schoolMod = settings[calculation.spellSchool.."Damage"]
			if schoolMod then calculation.spellDmg = math_max(0, calculation.spellDmg + schoolMod) end		
		end
		
		if settings.MP5 ~= 0 then
			if settings.ManualPlus then
				calculation.manaRegen = math_max(0,calculation.manaRegen + settings.MP5)
			else
				calculation.manaRegen = math_max(0,settings.MP5)
			end
		end
	end
	
	if settings.ManaConsumables then
		calculation.manaRegen = calculation.manaRegen + 20 
	end	
	
	--Adding to spells base damage after levelups:
	if baseSpell.BaseIncrease then
		local playerLevel = UnitLevel("player")
	
		if playerLevel > spell.spellLevel then
			local spellmaxLevel
			if baseSpell.LevelIncrease then
				spellmaxLevel = spell.spellLevel + baseSpell.LevelIncrease
				if spellmaxLevel > 70 then spellmaxLevel = 70 end
			else
				spellmaxLevel = 70
			end
			if playerLevel >= spellmaxLevel then
				calculation.minDam = calculation.minDam + spell[3]
				calculation.maxDam = calculation.maxDam + spell[4]			
			else
				local diff = spellmaxLevel - spell.spellLevel
				
				calculation.minDam = calculation.minDam + (playerLevel - spell.spellLevel) * (spell[3] / diff)
				calculation.maxDam = calculation.maxDam + (playerLevel - spell.spellLevel) * (spell[4] / diff)
			end
		end
		
		calculation.minDam = math_floor(calculation.minDam)
		calculation.maxDam = math_ceil(calculation.maxDam)
	end
	
	--Calculate modified cast time
	local ct = select(7, GetSpellInfo(name,rank))
	if not ct or ct == 0 then
		calculation.castTime = math_max(1, calculation.castTime / ( 1 + GetCombatRatingBonus(20)/100 ))
		calculation.castData = true
	else
		calculation.castTime = ct/1000
		calculation.castData = false
	end
	
	if settings.ManualDmg then
		local base = calculation.castTime * ( 1 + GetCombatRatingBonus(20)/100 )
		calculation.castTime = math_min(base, math_max(1, calculation.castTime / (1 + 0.01 * (settings.HasteRating/self:GetRating("SpellHaste",nil,true)))))
		calculation.haste = calculation.haste + settings.HasteRating
		if not settings.ManualPlus then
			calculation.castTime = base
			calculation.haste = settings.HasteRating
		end		
	end
	
	--Apply talents		
	for talentName, talentRank in pairs(talents) do						
		local talentTable = talentInfo[talentName]
		
		for i = 1, #talentTable do
			local talent = talentTable[i]	

			if not talent.Melee then
				if DrD_MatchData(talent.Spells, spellName, calculation.spellType) or not baseSpell.NoSchoolTalents and DrD_MatchData(talent.Spells, "All", calculation.spellSchool) then		
					local modType = talent.ModType
					local talentValue = (type(talent.Effect) == "table") and talent.Effect[talentRank] or talent.Effect * talentRank
					
					if not modType then
						if talent.Add then
							calculation.dmgM_AddTalent = calculation.dmgM_AddTalent + talentValue
						else
							calculation.dmgM = calculation.dmgM * ( 1 + talentValue )	
						end
					elseif calculation[modType] then
						if talent.Multiply then
							calculation[modType] = calculation[modType] * ( 1 + talentValue )
						else
							calculation[modType] = calculation[modType] + talentValue
						end
					elseif DrDamage.Calculation[modType] then
						DrDamage.Calculation[modType](calculation, talentValue)					
					elseif modType == "Amount" then
						BuffTalentRanks[talent.Value] = talentValue		
					elseif modType == "SpellDamage" then
						if talent.Multiply then
							calculation.spellDmgM = calculation.spellDmgM * ( 1 + talentValue )
						else
							calculation.spellDmgM_AddTalent = calculation.spellDmgM_AddTalent + talentValue
						end
					end
				end
				if talent.Mod then
					local mod = talent.Mod
					if DrD_MatchData(mod[1], spellName, calculation.spellType, calculation.spellSchool, "All") then
						local _, _, _, _, cur = GetTalentInfo(mod[2],mod[3])
						if talentRank - cur ~= 0 then
							calculation[mod[4]] = mod[5](calculation[mod[4]], cur, talentRank)
						end
					end
				end
			end
		end
	end

	--Add up additive components:
	calculation.dmgM = calculation.dmgM + calculation.dmgM_AddTalent
	calculation.spellDmgM = calculation.spellDmgM + calculation.spellDmgM_AddTalent
	--calculation.spellDmgM = calculation.spellDmgM * (calculation.castModDmg or 1)
	
	if not healingSpell and baseSpell.canCrit and not DrD_MatchData( baseSpell.School, "Physical" ) then
		calculation.critM = calculation.critM + (1.5 * self.Caster_critMBonus) * calculation.critM/0.5
	end
	
	--Process modify table
	if self.CasterGlobalModify then
		local modify = self.CasterGlobalModify
		for _, v in ipairs( modifyTable ) do
			local value, set = 0
			if modify[calculation.spellSchool] and modify[calculation.spellSchool][v] then
				value = modify[calculation.spellSchool][v]
				set = modify[calculation.spellSchool].Set
			end
			if modify[calculation.spellType] and modify[calculation.spellType][v] then
				value = modify[calculation.spellSchool].Set and modify[calculation.spellType][v] or (value + modify[calculation.spellType][v])
				set = set or modify[calculation.spellSchool].Set
			end
			if modify[spellName] and modify[spellName][v] then
				value = modify[spellName].Set and modify[spellName][v] or (value + modify[spellName][v])
				set = set or modify[spellName].Set			
			end
			if value then
				calculation[v] = math_max(0, set and value or (calculation[v] + value))
			end
		end
	end
	if modify and type(modify) == "table" then
		for _, v in ipairs( modifyTable ) do
			if modify[v] then
				if modify.Set then
					calculation[v] = math_max(0, modify[v])
				else
					calculation[v] = math_max(0, calculation[v] + modify[v])
				end
			end
		end
	end
	
	--Start calculating Buffs/Debuffs that affects damage not provided by blizzard API.
	if not baseSpell.NoAura then
		calculation.dmgM = calculation.dmgM * (not healingSpell and select(7, UnitDamage("player")) or 1) * (self.casterMod or 1)
		if next(settings["PlayerAura"]) then
			for buffName in pairs(settings["PlayerAura"]) do
				if PlayerAura[buffName] then
					DrD_BuffCalc( PlayerAura[buffName], calculation, baseSpell, buffName, nil, nil, nil, PlayerAura[buffName].Ranks, true )
				end
			end
		end
		if next(settings["TargetAura"]) then
			for buffName in pairs(settings["TargetAura"]) do
				if TargetAura[buffName] then
					DrD_BuffCalc( TargetAura[buffName], calculation, baseSpell, buffName, nil, nil, nil, TargetAura[buffName].Ranks, true )
				end
			end
		end	
		--BUFF/DEBUFF -- DAMAGE/HEALING -- PLAYER
		for index=1,40 do
			local buffName, rank, texture, apps = UnitBuff("player",index)
			if buffName then
				if PlayerAura[buffName] and not settings["PlayerAura"][buffName] then
					DrD_BuffCalc( PlayerAura[buffName], calculation, baseSpell, buffName, index, apps, texture, rank )
				end
			else break end		
		end
		--DEBUFF -- DAMAGE/HEALING -- PLAYER
		for index=1,40 do
			local buffName, rank, texture, apps = UnitDebuff("player",index)
			if buffName then
				if PlayerAura[buffName] and not settings["PlayerAura"][buffName] then
					DrD_BuffCalc( PlayerAura[buffName], calculation, baseSpell, buffName, index, apps, texture, rank )
				end
				if not healingSpell and debuffMods[buffName] and calculation.spellType ~= "Physical" then
					GT:SetUnitDebuff("player", index)
					local _, _, amount = GT:Find("(%d+)%%")
					if amount then calculation.dmgM = calculation.dmgM / (1-tonumber(amount)/100) end
				end				
			else break end			
		end	
		--DEBUFF -- DAMAGE/HEALING -- TARGET
		local debuffTarget = (not healingSpell or UnitIsFriend("player", "target")) and "target" or UnitIsFriend("player", "targettarget") and "targettarget"
		if debuffTarget then
			for index=1,40 do 
				local buffName, rank, texture, apps = UnitDebuff(debuffTarget,index)
				if buffName then
					if TargetAura[buffName] and not settings["TargetAura"][buffName] then
						DrD_BuffCalc( TargetAura[buffName], calculation, baseSpell, buffName, index, apps, texture, rank )
					end
				else break end
			end
		end
		--BUFF - HEALING -- TARGET
		if healingSpell and playerHealer then
			local healingTarget = UnitIsFriend("player", "target") and "target" or UnitIsFriend("player", "targettarget") and "targettarget"
			if healingTarget then
				for index=1,40 do 
					local buffName, rank, texture, apps = UnitBuff(healingTarget,index)
					if buffName then
						if TargetAura[buffName] and not settings["TargetAura"][buffName] then
							DrD_BuffCalc( TargetAura[buffName], calculation, baseSpell, buffName, index, apps, texture, rank )
						end
					else break end
				end
			end
		end		
	end
	
	--Add manual selected consumables if not active
	if next(settings["Consumables"]) then
		for buffName in pairs(settings["Consumables"]) do
			if Consumables[buffName] then
				DrD_BuffCalc( Consumables[buffName], calculation, baseSpell, buffName, nil, nil, nil, nil, true )
			end
		end
	end	

	if SetBonuses[playerClass] then
		SetBonuses[playerClass]( calculation, ActiveAuras )
	end		
	if Calculation[playerClass] then
		Calculation[playerClass]( calculation, ActiveAuras, BuffTalentRanks )
	end
	if SetBonuses[spellName] then
		SetBonuses[spellName]( calculation, ActiveAuras, baseSpell )
	end
	if Calculation[spellName] then
		Calculation[spellName]( calculation, ActiveAuras, BuffTalentRanks, spell )
	end
	
	--Resilience
	if settings.Resilience > 0 and not calculation.healingSpell then
		calculation.critPerc = math_max(0, calculation.critPerc - settings.Resilience / 39.4)
		calculation.critM = calculation.critM * ( 1 - math_min(0.5, 0.04 * settings.Resilience / 39.4 ))
		if baseSpell.eDot then
			calculation.dmgM = calculation.dmgM * ( 1 - math_min(1,0.01 * settings.Resilience / 39.4))
		end
	end	
	
	--Split between bonus to dot and nuke
	if baseSpell.hybridFactor then
		calculation.spellDmgM = calculation.spellDmgM * baseSpell.hybridFactor
	end
	
	--Factor that applies to all ranks of the spell
	if baseSpell.sFactor then
		calculation.spellDmgM = calculation.spellDmgM * baseSpell.sFactor
	end
	
	--Factor that applies to current rank of the spell
	if spell.sFactor then
		calculation.spellDmgM = calculation.spellDmgM * spell.sFactor
	end
	
	--Low rank and low level penalties
	calculation.spellDmgM = calculation.spellDmgM * calculation.lowRankFactor * calculation.lowLevelFactor
	
	--Add additive components with no downranking effect
	calculation.spellDmgM = calculation.spellDmgM + calculation.spellDmgM_AddNoDownrank	
	
	local returnAvgTotal = DrD_DmgCalc( baseSpell, spell, false, false, tooltip )
	
	if tooltip then
		if settings.Next or settings.CompareDmg or settings.CompareCrit or settings.CompareHit or settings.CompareHaste then
			if baseSpell.canCrit then
				calculation.critPerc = calculation.critPerc + 1
				CalculationResults.NextCrit = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - returnAvgTotal, 1 )
				calculation.critPerc = calculation.critPerc - 1	
			end

			calculation.spellDmg = calculation.spellDmg + 10
			CalculationResults.NextTenDmg = DrD_Round( DrD_DmgCalc( baseSpell, spell, true ) - returnAvgTotal, 1 )
			calculation.spellDmg = calculation.spellDmg - 10

			if not healingSpell and not baseSpell.Unresistable then
				local temp = settings.HitCalc and returnAvgTotal or DrD_DmgCalc( baseSpell, spell, true, true )
				calculation.hitPerc = calculation.hitPerc + 1
				CalculationResults.NextHit = DrD_Round( DrD_DmgCalc( baseSpell, spell, true, true ) - temp, 1 )
			end	
		end		
	end
	
	DrD_ClearTable( BuffTalentRanks )
	DrD_ClearTable( ActiveAuras )
	
	local text
	
	if baseSpell.NoDPS and (settings.DisplayType == "DPS" or settings.DisplayType == "DPSC") then
		text = CalculationResults["AvgTotal"]
	else
		text = CalculationResults[settings.DisplayType]
	end
	
	return text, CalculationResults
end

local function DrD_FreeCrits( casts, canCrit, freeCrit, critRate )
	if canCrit and freeCrit > 0 then
		local total = casts
		for i = 1, 5 do
			casts = math_floor(freeCrit * (critRate / 100) * casts)
			if casts == 0 then break end									
			total = total + casts
		end
		return total
	end
	return casts
end

local ManaCalc = { ["DPM"] = true, ["ManaCost"] = true, ["TrueManaCost"] = true, ["MPS"] = true, }

DrD_DmgCalc = function( baseSpell, spell, nextCalc, hitCalc, tooltip )
	--Initialize variables that are calculated
	local dispSpellDmgM = calculation.spellDmgM	--Calculated spelldamage modifier		
	local calcAvgDmgCrit = 0			--Calculated final damage with averaged crit
	local calcDotDmg = 0				--Calculated DOT portion
	local calcAvgDmg				--Calculated final damage without crit
	local calcMinDmg				--Calculated dmg range: min
	local calcMaxDmg				--Calculated dmg range: max
	local calcDPS
	local calcMinCrit				--Calculated crit range: min
	local calcMaxCrit				--Calculated crit range: max
	local igniteDotDmg				--Calculated ignite DOT portion
	local perHit					--Calculated damage per hit
	local ticks
	local extraDmg				
	local extraDPS
	local baseDuration = spell.eDuration or baseSpell.eDuration
	local sTicks = spell.sTicks or baseSpell.sTicks
	
	if calculation.sHits then
		calcMinDmg = calculation.dmgM * ( calculation.bDmgM * calculation.minDam * calculation.sHits + (  calculation.spellDmg * calculation.spellDmgM ) )
		calcMaxDmg = calculation.dmgM * ( calculation.bDmgM * calculation.maxDam * calculation.sHits + (  calculation.spellDmg * calculation.spellDmgM ) )
	elseif spell.hybridDotDmg then
		calcMinDmg = ( calculation.dmgM + calculation.bNukeDmg ) * ( calculation.bDmgM * calculation.minDam + ( calculation.spellDmg * calculation.spellDmgM ) )
		calcMaxDmg = ( calculation.dmgM + calculation.bNukeDmg ) * ( calculation.bDmgM * calculation.maxDam + ( calculation.spellDmg * calculation.spellDmgM ) )
	else
		calcMinDmg = calculation.dmgM * ( calculation.bDmgM * calculation.minDam + ( calculation.spellDmg * calculation.spellDmgM ) )
		calcMaxDmg = calculation.dmgM * ( calculation.bDmgM * calculation.maxDam + ( calculation.spellDmg * calculation.spellDmgM ) )
	end

	if calculation.finalMod ~= 0 then
		calcMinDmg = math_max(0, calcMinDmg + calculation.finalMod)
		calcMaxDmg = math_max(0, calcMaxDmg + calculation.finalMod)	
	end
	
	calcMinDmg = calcMinDmg + calculation.finalMod_sM * calculation.spellDmgM + calculation.finalMod_fM * calculation.dmgM
	calcMaxDmg = calcMaxDmg + calculation.finalMod_sM * calculation.spellDmgM + calculation.finalMod_fM * calculation.dmgM
		
	--This is for Imp SW:P and others with extended duration through talents etc.
	if baseSpell.eDot and baseSpell.eDuration and calculation.eDuration > baseDuration then
		calcMinDmg = calcMinDmg + (calcMinDmg / baseDuration) * (calculation.eDuration - baseDuration)
		calcMaxDmg = calcMaxDmg + (calcMaxDmg / baseDuration) * (calculation.eDuration - baseDuration)
	end		

	calcAvgDmg = (calcMinDmg + calcMaxDmg) / 2

	--Crit calculation:
	local critBonus = 0
	if baseSpell.canCrit then
		calculation.critPerc = math_min(100, calculation.critPerc)
		calcMinCrit = calcMinDmg + calcMinDmg * calculation.critM
		calcMaxCrit = calcMaxDmg + calcMaxDmg * calculation.critM
		critBonus = (calculation.critPerc / 100) * calcAvgDmg * calculation.critM
		calcAvgDmgCrit = calcAvgDmg + critBonus
	else
		calcAvgDmgCrit = calcAvgDmg
		calculation.critPerc = 0
	end		

	--Hybrid spells:
	local hybridDmgM = 0
	if spell.hybridDotDmg then
		local hybridFactor = baseSpell.hybridFactor or 0
		local sFactor = 1 * (baseSpell.sFactor or 1) * (spell.sFactor or 1) * (baseSpell.hybridDotFactor or 1)

		hybridDmgM = calculation.dotSpellDmgM * ( 1 - hybridFactor ) * sFactor * calculation.lowRankFactor * calculation.lowLevelFactor
		calcDotDmg = calculation.dmgM * ( hybridDmgM * calculation.spellDmg + spell.hybridDotDmg )
		dispSpellDmgM = dispSpellDmgM + hybridDmgM
		
		if calculation.eDuration > baseDuration then 
			calcDotDmg = calcDotDmg + ( calcDotDmg / baseDuration ) * ( calculation.eDuration - baseDuration )
		end
	end

	--For spells that can ignite
	if calculation.igniteM > 0 then
		igniteDotDmg = calculation.igniteM * (( calcMinCrit + calcMaxCrit ) / 2 )
		calcAvgDmgCrit = calcAvgDmgCrit + ( calculation.critPerc / 100 ) * igniteDotDmg
	end

	--For spells with extra DOT portion eg. fireball
	if spell.extraDotDmg then
		calcDotDmg = calcDotDmg + calculation.dmgM * spell.extraDotDmg
		if baseSpell.extraDotF then 
			calcDotDmg = calcDotDmg + calculation.dmgM * baseSpell.extraDotF * calculation.lowRankFactor * calculation.lowLevelFactor * calculation.spellDmg
			dispSpellDmgM = dispSpellDmgM + baseSpell.extraDotF * calculation.lowRankFactor * calculation.lowLevelFactor
		end
	end
	
	calcDotDmg = calcDotDmg + calculation.dotFinalMod
	
	if settings.Resilience > 0 and not calculation.healingSpell then
		calcDotDmg = calcDotDmg * (1 - math_min(1,0.01 * settings.Resilience / 39.4))
	end	

	--For chain effects (chain lightning, chain heal)
	local chainEffect
	if calculation.chainFactor then
		chainEffect = calcAvgDmgCrit * (calculation.chainFactor + calculation.chainFactor^2)
		calcAvgDmgCrit = calcAvgDmgCrit + chainEffect
	end
	
	if baseSpell.Stacks then
		if spell.extraDotDmg then
			perHit = calcAvgDmgCrit
			ticks = "~" .. baseSpell.Stacks
			calcAvgDmgCrit = calcAvgDmgCrit + spell.extraDotDmg * (baseSpell.Stacks - 1) * calculation.dmgM
		end
	end
	
	--Special cases:
	if calculation.spellName == "Seed of Corruption" then
		perHit = calcDotDmg / 6
		ticks = math_ceil(1044 / perHit)
		calcDotDmg = 0 --ticks * perHit
		dispSpellDmgM =  dispSpellDmgM - hybridDmgM + (hybridDmgM / 6) * ticks
	end
	
	--Hit calculation:
	local hitPenalty = 0
	local hitPenaltyAvg = 0
	if not calculation.healingSpell and not baseSpell.Unresistable then
		if settings.HitCalc or hitCalc then
			calculation.hitPerc = math_min(99, calculation.hitPerc)
			if settings.TwoRoll then
				hitPenalty = calcAvgDmgCrit * ((calculation.hitPerc / 100) - 1)
				hitPenaltyAvg = (calcAvgDmg + critBonus) * ((calculation.hitPerc / 100) - 1)
			else
				hitPenalty = (calcAvgDmgCrit - critBonus) * ((calculation.hitPerc / 100) - 1)
				hitPenaltyAvg = calcAvgDmg * ((calculation.hitPerc / 100) - 1)
			end
			calcAvgDmgCrit = calcAvgDmgCrit + hitPenalty
			calcAvgDmgCrit = calcAvgDmgCrit - calcDotDmg * (1 - ( calculation.hitPerc / 100))
		end
	end
	
	calcAvgDmgCrit = calcAvgDmgCrit * calculation.finalMod_M
	
	local spamDmg, spamDPS
	if not nextCalc then
		--Make sure cast time is over 1s
		calculation.castTime = math_max(1,DrD_Round(calculation.castTime,3))
		if not perHit then
			if calculation.sHits then
				ticks = calculation.sHits
				perHit = calcAvgDmg / ticks
			elseif sTicks then
				if calculation.castTime > calculation.eDuration then
					ticks = (spell.castTime or baseSpell.castTime or 1.5) / sTicks
				else
					ticks = calculation.eDuration / sTicks
				end
				if spell.hybridDotDmg or spell.extraDotDmg then
					perHit = calcDotDmg / ticks
				else
					perHit = calcAvgDmg / ticks
				end
			end
		end
		if baseSpell.eDot or spell.hybridDotDmg then
			calcDPS = ( calcAvgDmgCrit + calcDotDmg ) / calculation.eDuration
			if baseSpell.DotStacks then
				spamDmg = (calcDotDmg - perHit) * (baseSpell.DotStacks)
				spamDPS = (calcDotDmg / calculation.eDuration) * (baseSpell.DotStacks)
			elseif spell.hybridDotDmg then
				spamDmg = calcAvgDmgCrit + (sTicks and (math_floor(((baseSpell.Cooldown and calculation.cooldown) or calculation.castTime)/sTicks) * perHit) or 0)
				spamDPS = spamDmg / ((baseSpell.Cooldown and calculation.cooldown) or calculation.castTime)
			end
		elseif baseSpell.Stacks then
			calcDPS = calcAvgDmgCrit / baseSpell.StacksDuration
		elseif spell.extraDotDmg then
			calcDPS = calcAvgDmgCrit / calculation.castTime + calcDotDmg / calculation.eDuration
		else
			calcDPS = calcAvgDmgCrit / calculation.castTime
		end
	end

	calcAvgDmgCrit = calcAvgDmgCrit + calcDotDmg
	
	if calculation.spellName == "Seed of Corruption" then
		calcDotDmg = ticks * perHit
	end

	if nextCalc then
		return calcAvgDmgCrit
	else
		DrD_ClearTable( CalculationResults )

		CalculationResults.Healing = 		calculation.healingSpell
		CalculationResults.Avg =		math_floor(calcAvgDmg + hitPenaltyAvg + critBonus + 0.5)
		CalculationResults.AvgTotal =  		math_floor(calcAvgDmgCrit + 0.5)
		CalculationResults.DPS = 		DrD_Round(calcDPS, 1)
		CalculationResults.DPSC = 		DrD_Round(calcAvgDmgCrit / calculation.castTime, 1)
		CalculationResults.DPSCD = 		baseSpell.Cooldown and DrD_Round(calcAvgDmgCrit / calculation.cooldown, 1) or CalculationResults.DPS
		CalculationResults.AvgHit = 		math_floor((calculation.sHits and perHit or calcAvgDmg) + 0.5)
		CalculationResults.MinHit = 		math_floor(calcMinDmg)
		CalculationResults.MaxHit = 		math_ceil(calcMaxDmg)
		CalculationResults.AvgHitTotal = 	math_floor(calculation.sHits and ticks and (calcAvgDmgCrit/ticks) or (calcAvgDmg + calcDotDmg) + 0.5)
		CalculationResults.Max = 		math_ceil(calcDotDmg + (calcMaxCrit or calcMaxDmg) + (igniteDotDmg or 0) + (extraDmg or 0) + (chainEffect or 0))
			
		--Write tooltip data
		if tooltip then
			if baseSpell.canCrit then
				CalculationResults.MinCrit =	math_floor( calcMinCrit )
				CalculationResults.MaxCrit = 	math_ceil( calcMaxCrit )
				CalculationResults.AvgCrit = 	math_floor( ( calcMinCrit + calcMaxCrit ) / 2 + 0.5 )
				CalculationResults.CritRate = 	DrD_Round( calculation.critPerc, 2 )

				--Lightning capacitor
				if not calculation.healingSpell and IsEquippedItem(28785) and not DrD_MatchData(baseSpell.School, "OffensiveTotem", "Physical") then
					extraDmg = (750 + 375 * GetSpellCritChance(schoolTable["Nature"])/100) / (300 / calculation.critPerc)

					if calculation.sHits then
						extraDmg = math_min(1,math_floor((spell.castTime or baseSpell.castTime) / 2.5)) * extraDmg
					elseif (calculation.castTime / 2.5) < 1 then
						extraDmg = 0.8 * extraDmg
					end
					extraDPS = extraDmg / calculation.castTime
				end
			end

			CalculationResults.HitRate = 	DrD_Round( calculation.hitPerc, 2 )
			CalculationResults.DotDmg = 	math_floor( calcDotDmg + 0.5 )
			CalculationResults.SpellDmg = 	math_floor( calculation.spellDmg + 0.5 )
			CalculationResults.SpellDmgM = 	DrD_Round( dispSpellDmgM, 3 )
			CalculationResults.DmgM = 	DrD_Round( calculation.dmgM, 3 )
			CalculationResults.LvF = 	calculation.lowLevelFactor
			CalculationResults.RkF = 	calculation.lowRankFactor
			CalculationResults.Haste = 	math_max(0,calculation.haste)
			--CalculationResults.CastTime = 	calculation.castTime
			--CalculationResults.Cooldown = 	calculation.cooldown
			
			if spamDPS then
				CalculationResults.SpamDPS =	DrD_Round( spamDPS, 1 )
			end			
			if igniteDotDmg then
				CalculationResults.IgniteDmg = 	math_floor( igniteDotDmg + 0.5 )
			end
			if chainEffect then 
				CalculationResults.ChainDmg = 	math_floor( chainEffect + 0.5 ) 
			end
			if extraDPS then
				CalculationResults.ExtraDPS = 	DrD_Round( extraDPS, 1 )
			end
			if perHit and ticks then
				CalculationResults.PerHit = DrD_Round( perHit, 1 )
				CalculationResults.Hits = ticks
			end				
			if baseSpell.Leech and calculation.leechBonus > 1 then
				CalculationResults.AvgLeech = DrD_Round( calcAvgDmg * calculation.leechBonus, 1 )
				if perHit then
					CalculationResults.PerHitHeal =  DrD_Round( perHit * calculation.leechBonus, 1 )
				end
			end
		end
		if tooltip or ManaCalc[settings.DisplayType] then
			local manaCost = calculation.manaCost
			
			if manaCost == 0 then
				CalculationResults.castsBase = "\226\136\158"
				CalculationResults.castsRegen = 0
				CalculationResults.ManaCost = 0
				CalculationResults.TrueManaCost = 0
				CalculationResults.DPM = "\226\136\158"
				CalculationResults.MPS = 0
			else
				CalculationResults.ManaCost = manaCost
				CalculationResults.TrueManaCost = DrD_Round(manaCost * calculation.manaCostM * (1 - ((baseSpell.canCrit and calculation.critPerc or 0)/100) * calculation.freeCrit), 1)
				CalculationResults.DPM = DrD_Round(calcAvgDmgCrit / CalculationResults.TrueManaCost, 1)
				CalculationResults.MPS = DrD_Round(CalculationResults.TrueManaCost / calculation.castTime, 1)
				
				if tooltip then
					local PlayerMana = (UnitPowerType("player") == 0) and UnitMana("player") or DrDamage.lastMana + calculation.manaMod
					CalculationResults.castsBase = DrD_FreeCrits(math_floor(PlayerMana / manaCost), baseSpell.canCrit, calculation.freeCrit, calculation.critPerc)
					CalculationResults.SpamDPM = spamDmg and DrD_Round(spamDmg / CalculationResults.TrueManaCost, 1)
					
					local regen = 0
					local castsRegen = 0
					local castTime = math_max(calculation.cooldown, calculation.castTime)

					if castTime <= 10 and not baseSpell.eDot then
						regen = math_floor(PlayerMana / manaCost) * castTime * calculation.manaRegen
						local newCasts = DrD_FreeCrits(math_floor(regen / manaCost), baseSpell.canCrit, calculation.freeCrit, calculation.critPerc)
						castsRegen = newCasts

						for i = 1, 5 do
							local newRegen = newCasts * castTime * calculation.manaRegen
							newCasts = DrD_FreeCrits(math_floor(newRegen / manaCost), baseSpell.canCrit, calculation.freeCrit, calculation.critPerc)
							regen = regen + newRegen
							castsRegen = castsRegen + newCasts

							if newCasts == 0 then break end
						end

						CalculationResults.SOOM = DrD_Round((CalculationResults.castsBase + castsRegen) * castTime, 1)
					end

					if (CalculationResults.castsBase + castsRegen) > 1000 then
						CalculationResults.castsBase = "\226\136\158"
						CalculationResults.castsRegen = 0
						CalculationResults.DOOM = "\226\136\158"
						CalculationResults.SOOM = nil
					else
						CalculationResults.DOOM = math_floor(CalculationResults.DPM * (PlayerMana + regen) + 0.5)
						CalculationResults.castsRegen = castsRegen
					end
				end
			end
		end
		return calcAvgDmgCrit
	end
end

DrD_BuffCalc = function( data, calculation, baseSpell, buffName, index, apps, texture, rank, manual )
	local school = data.School
	if not calculation.healingSpell and (
		(not school and not data.Spell) or
		DrD_MatchData(school, calculation.spellSchool))
	or DrD_MatchData(data.Spell, calculation.name)
	or DrD_MatchData(school, calculation.spellType)
	or calculation.healingSpell and school == "Healing"
	or school == "All" and calculation.spellType ~= "Physical" then
		local modType = data.ModType
		if modType == "Update" then return end
		if modType == "Special" and Calculation[buffName] then
			Calculation[buffName]( calculation, ActiveAuras, BuffTalentRanks, index, apps, texture, rank )
		else
			if data.ActiveAura then
				if apps and apps > 0 then
					ActiveAuras[data.ActiveAura] = apps
				else
					ActiveAuras[data.ActiveAura] = ( ActiveAuras[data.ActiveAura] or 0 ) + 1
				end
				if modType == "ActiveAura" then return end
			end
			
			--Custom modifiers needed for special cases
			if data.Mods then
				local mod = data.Mods
				if manual then
					if not GetPlayerBuffName(buffName) and (not data.Alt or data.Alt and not GetPlayerBuffName(data.Alt)) and (not data.Oil or data.Oil and DrDamage:GetWeaponBuff() ~= buffName) then
						for k, v in pairs(mod) do
							if calculation[k] then
								if type(v) == "function" then
									calculation[k] = v(calculation[k])
								else
									calculation[k] = calculation[k] + v
								end
							end
						end
					end
				else
					--Add speed increase to cast time from data
					if mod["castTime"] and calculation.castData then
						calculation["castTime"] = mod["castTime"](calculation["castTime"])
					end				
				end
			end
			if not data.Value then return end
			if type(data.Value) == "number" and data.Value < 0 then
				if calculation.NoDebuffs then return 
				elseif school == "Healing" then calculation.NoDebuffs = true end
			end			
			
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
			elseif data.Texture and texture and string_find( texture, data.Texture ) then
				calculation.dmgM = calculation.dmgM * ( 1 + data.Value )
			elseif data.Apps2 then
				apps = apps or data.Apps2
				calculation.dmgM = calculation.dmgM * ( 1 + apps * data.Value2 )
			elseif calculation[modType] then
				calculation[modType] = calculation[modType] + data.Value
			elseif not modType then
				calculation.dmgM = calculation.dmgM * ( 1 + data.Value )
			end
		end
	end
end

function DrDamage:CasterTooltip( frame, name, rank )

	self:CasterCalc(name, rank, true)
	
	local baseSpell, tableSpell
	
	if spellInfo[name]["Secondary"] and ((settings.SwapCalc and not IsShiftKeyDown()) or (IsShiftKeyDown() and not settings.SwapCalc)) then
		baseSpell = spellInfo[name]["Secondary"][0]
		tableSpell = spellInfo[name]["Secondary"][(rank and tonumber(string_match(rank,"%d+"))) or "None"]	
	else
		baseSpell = spellInfo[name][0]
		tableSpell = spellInfo[name][(rank and tonumber(string_match(rank,"%d+"))) or "None"]
		if type(baseSpell) == "function" then baseSpell, tableSpell, name = baseSpell() end
	end	
	
	frame:AddLine(" ")
	
	local r, g, b = 1, 0.82745098, 0
	
	if DrD_MatchData( baseSpell.School, "Judgement" ) or name ~= frame:GetSpell() then
		frame:AddLine( name, r, g, b )
		frame:AddLine(" ")
	end

	if not settings.DefaultColor then
		r, g, b = 0, 0.7, 0
	end

	local healingSpell = CalculationResults.Healing
	local spellType, spellAbbr

	if healingSpell then
		spellType = L["Heal"]
		spellAbbr = L["H"]
	else
		spellType = L["Dmg"]
		spellAbbr = L["D"]
	end

	if settings.PlusDmg then
		frame:AddDoubleLine( "+" .. spellType .. L[" (eff.):"], "+" .. DrD_Round( CalculationResults.SpellDmg * CalculationResults.SpellDmgM * CalculationResults.DmgM, 1 ), 1, 1, 1, r, g, b  )
	end

	if settings.Coeffs then
		frame:AddDoubleLine(L["Coeffs:"], CalculationResults.DmgM .. "/" .. CalculationResults.SpellDmgM .."/" .. CalculationResults.SpellDmg, 1, 1, 1, r, g, b  )
	end

	if settings.DispCrit and CalculationResults.CritRate then
		frame:AddDoubleLine(L["Crit"] .. ":", CalculationResults.CritRate .. "%", 1, 1, 1, r, g, b )
	end

	if settings.DispHit and not baseSpell.Unresistable and not healingSpell then
		frame:AddDoubleLine(L["Hit"] .. ":", CalculationResults.HitRate .. "%", 1, 1, 1, r, g, b )
	end  				

	if not settings.DefaultColor then
		r, g, b = 0.8, 0.8, 0.9
	end

	if settings.AvgHit then
		frame:AddDoubleLine(L["Avg:"], CalculationResults.AvgHit .. " (".. CalculationResults.MinHit .."-".. CalculationResults.MaxHit ..")", 1, 1, 1, r, g, b )

		if baseSpell.Leech and CalculationResults.AvgLeech and CalculationResults.AvgLeech > CalculationResults.AvgHit then
			frame:AddDoubleLine(L["Avg Heal:"], CalculationResults.AvgLeech, 1, 1, 1, r, g, b )
		end
	end

	if settings.AvgCrit and CalculationResults.AvgCrit and not baseSpell.sHits then
		frame:AddDoubleLine(L["Avg Crit:"], CalculationResults.AvgCrit .. " (".. CalculationResults.MinCrit .."-".. CalculationResults.MaxCrit ..")", 1, 1, 1, r, g, b )
	end

	if settings.Ticks and CalculationResults.PerHit then
		if baseSpell.sHits then
			frame:AddDoubleLine(L["Hits:"], CalculationResults.Hits .. "x ~" .. CalculationResults.PerHit, 1, 1, 1, r, g, b )

			if baseSpell.Leech and CalculationResults.PerHitHeal and CalculationResults.PerHitHeal > CalculationResults.PerHit then
				frame:AddDoubleLine(L["Hits Heal:"], CalculationResults.Hits .. "x ~" .. CalculationResults.PerHitHeal, 1, 1, 1, r, g, b )
			end  						
		elseif baseSpell.sTicks then
			frame:AddDoubleLine(L["Ticks:"], CalculationResults.Hits .. "x ~" .. CalculationResults.PerHit, 1, 1, 1, r, g, b )
			
			if baseSpell.DotStacks then
				frame:AddDoubleLine(L["Ticks:"] .. " (x" .. baseSpell.DotStacks .. ")", CalculationResults.Hits .. "x ~" .. (CalculationResults.PerHit * baseSpell.DotStacks), 1, 1, 1, r, g, b )
			end

			if baseSpell.Leech and CalculationResults.PerHitHeal and CalculationResults.PerHitHeal > CalculationResults.PerHit then
				frame:AddDoubleLine(L["Ticks Heal:"], CalculationResults.Hits .. "x ~" .. CalculationResults.PerHitHeal, 1, 1, 1, r, g, b )
			end  						
		end
	end

	if settings.Extra then 
		if CalculationResults.ChainDmg then
			frame:AddDoubleLine(L["Avg Chain:"], CalculationResults.ChainDmg, 1, 1, 1, r, g, b  )
		end

		if CalculationResults.IgniteDmg then
			frame:AddDoubleLine(L["Ignite:"], CalculationResults.IgniteDmg, 1, 1, 1, r, g, b )
		end

		if CalculationResults.DotDmg > 0 then
			frame:AddDoubleLine(L["DoT:"], CalculationResults.DotDmg, 1, 1, 1, r, g, b )
		end
	end  				

	if settings.Total and CalculationResults.AvgTotal ~= CalculationResults.AvgHit then
		frame:AddDoubleLine(L["Avg Total:"], CalculationResults.AvgTotal, 1, 1, 1, r, g, b  )
	end

	if not settings.DefaultColor then
		r, g, b = 0.3, 0.6, 0.5
	end

	if not baseSpell.NoNext and CalculationResults.NextTenDmg then
		local dmgA = (CalculationResults.AvgTotal * 0.1) / CalculationResults.NextTenDmg
		local critA = CalculationResults.NextCrit and (CalculationResults.AvgTotal * 0.01 / CalculationResults.NextCrit * self:GetRating("Crit", nil, true ))
		local hasA = not baseSpell.eDot and not baseSpell.DotStacks and (self:GetRating("SpellHaste",nil,true) + 0.01 * CalculationResults.Haste)
		local rating = CalculationResults.NextHit and (CalculationResults.NextHit > 0.5) and (DrD_MatchData(baseSpell.School, "Physical") and self:GetRating("MeleeHit", nil, true) or self:GetRating("Hit", nil, true))
		local hitA = rating and (CalculationResults.AvgTotal * 0.01 / CalculationResults.NextHit * rating)		

		if settings.Next then
			local dmgA, critA, hasA, hitA = DrD_Round(dmgA, 1), critA and DrD_Round(critA, 1), hasA and DrD_Round(hasA, 1), hitA and DrD_Round(hitA, 1)
			frame:AddDoubleLine("+10 " .. spellType .. ":", "+" .. CalculationResults.NextTenDmg, 1, 1, 1, r, g, b )
			if critA then frame:AddDoubleLine("+1% " .. L["Crit"] .. " (" .. self:GetRating("Crit") .. "):", "+" .. CalculationResults.NextCrit, 1, 1, 1, r, g, b ) end
			if hitA then frame:AddDoubleLine("+1% " ..  L["Hit"] .. " (" .. DrD_Round(rating,2).. "):", "+" .. CalculationResults.NextHit, 1, 1, 1, r, g, b ) end
			frame:AddDoubleLine("+1% " .. spellAbbr .. (tableSpell.hybridDotDmg and L["PSC"] or L["PS"]) .. " (" .. ((critA and (L["Cr"] .. "|")) or "") .. ((hitA and (L["Ht"] .. "|")) or "") .. ((hasA and (L["Ha"] .. "|")) or "") ..spellType .. "):", (critA and (critA .. "/") or "") .. (hitA and (hitA .. "/") or "") .. (hasA and (hasA .. "/") or "") .. dmgA, 1, 1, 1, r, g, b )
		end
		if settings.CompareDmg and (hitA or critA or hasA) then
			local critA = critA and DrD_Round(critA / dmgA, 2)
			local hitA = hitA and DrD_Round(hitA / dmgA, 2)
			local hasA = hasA and DrD_Round(hasA / dmgA, 2)
			frame:AddDoubleLine("+1 " .. spellType .. " (" .. (critA and L["Cr"] or "") .. (hitA and ("|" .. L["Ht"]) or "") .. (hasA and ("|" .. L["Ha"]) or "") .. "):", (critA or "") .. (critA and hitA and "/" or "") .. (hitA or "") .. ((critA or hitA) and hasA and "/" or "") .. (hasA or ""), 1, 1, 1, r, g, b )
		end
		if settings.CompareCrit and critA then
			local dmgA = DrD_Round(dmgA / critA, 2)
			local hitA = hitA and DrD_Round(hitA / critA, 2)
			local hasA = hasA and DrD_Round(hasA / critA, 2)
			frame:AddDoubleLine("+1 " .. L["Cr"] .. " (" .. spellType .. (hitA and ("|" .. L["Ht"]) or "") .. (hasA and ("|" .. L["Ha"]) or "") .. "):", dmgA .. (hitA and ("/" .. hitA) or "") .. (hasA and ("/" .. hasA) or ""), 1, 1, 1, r, g, b )
		end
		if settings.CompareHit and hitA then
			local dmgA = DrD_Round(dmgA / hitA, 2)
			local critA = critA and DrD_Round(critA / hitA, 2)
			local hasA = hasA and DrD_Round(hasA / hitA, 2)
			frame:AddDoubleLine("+1 " .. L["Ht"] .. " (" .. spellType .. (critA and ("|" .. L["Cr"]) or "") .. (hasA and ("|" .. L["Ha"]) or "") .. "):", dmgA .. (critA and ("/" .. critA) or "") .. (hasA and ("/" .. hasA) or ""), 1, 1, 1, r, g, b )
		end
		if settings.CompareHaste and hasA then
			local dmgA = DrD_Round(dmgA / hasA, 2)
			local critA = critA and DrD_Round(critA / hasA, 2)
			local hitA = hitA and DrD_Round(hitA / hasA, 2)
			frame:AddDoubleLine("+1 " .. L["Ha"] .. " (" .. spellType .. (critA and ("|" .. L["Cr"]) or "") .. (hitA and ("|" .. L["Ht"]) or "") .. "):", dmgA .. (critA and ("/" .. critA) or "") .. (hitA and ("/" .. hitA) or ""), 1, 1, 1, r, g, b )
		end
	end

	if not settings.DefaultColor then
		r, g, b = 0.8, 0.1, 0.1
	end

	if settings.DPS and not baseSpell.NoDPS then
		if CalculationResults.DPSC ~= CalculationResults.DPS then
			frame:AddDoubleLine(spellAbbr .. L["PS"] .. "/" .. spellAbbr .. L["PSC"] .. ":", CalculationResults.DPS .. ((CalculationResults.ExtraDPS and ("+" .. CalculationResults.ExtraDPS)) or "") .. "/" .. CalculationResults.DPSC, 1, 1, 1, r, g, b)
		else
			frame:AddDoubleLine(spellAbbr .. L["PS"] .. ":", CalculationResults.DPS .. ((CalculationResults.ExtraDPS and ("+" .. CalculationResults.ExtraDPS)) or "") , 1, 1, 1, r, g, b)
		end
		if CalculationResults.SpamDPS then
			frame:AddDoubleLine(spellAbbr .. L["PS (spam):"], CalculationResults.SpamDPS, 1, 1, 1, r, g, b)
		end
		if CalculationResults.DPSCD and baseSpell.Cooldown then
			frame:AddDoubleLine(spellAbbr .. L["PS (CD):"], CalculationResults.DPSCD, 1, 1, 1, r, g, b)
		end
		
	end

	if settings.DPM and CalculationResults.DPM and not baseSpell.NoDPM then
		frame:AddDoubleLine(spellAbbr .. L["PM:"], CalculationResults.DPM, 1, 1, 1, r, g, b )
		if CalculationResults.SpamDPM and CalculationResults.SpamDPM ~= CalculationResults.DPM then
			frame:AddDoubleLine(spellAbbr .. L["PM (spam):"], CalculationResults.SpamDPM, 1, 1, 1, r, g, b )
		end
	end

	if settings.Doom and CalculationResults.DOOM and not baseSpell.NoDoom then
		frame:AddDoubleLine(spellType .. L[" until OOM:"], CalculationResults.DOOM, 1, 1, 1, r, g, b )
	end

	if settings.Casts and CalculationResults.castsBase then
		frame:AddDoubleLine(((CalculationResults.castsRegen > 0) and L["Casts (rgn):"]) or L["Casts:"], CalculationResults.castsBase .. ((CalculationResults.castsRegen > 0 and ("+" .. CalculationResults.castsRegen)) or "") .. ((CalculationResults.SOOM and (" (" .. CalculationResults.SOOM .. "s)")) or ""), 1, 1, 1, r, g, b )
	end

	if settings.ManaUsage then
		if CalculationResults.TrueManaCost and CalculationResults.TrueManaCost ~= CalculationResults.ManaCost then
			frame:AddDoubleLine(L["True Mana Cost:"], CalculationResults.TrueManaCost, 1, 1, 1, r, g, b)
		end
		if CalculationResults.MPS then
			frame:AddDoubleLine(L["MPS:"], CalculationResults.MPS, 1, 1, 1, r, g, b)
		end
	end
	
	if spellInfo[name]["Secondary"] then
		frame:AddLine(" ")
		frame:AddLine("Hint: Hold Shift for secondary tooltip", 0, 1, 0)
	end
	frame:Show()
end