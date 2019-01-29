if select(2, UnitClass("player")) ~= "ROGUE" then return end
local BR
local GetSpellInfo = GetSpellInfo
local UnitDebuff = UnitDebuff
local UnitCreatureType = UnitCreatureType
local math_min = math.min
local BI
if GetLocale() ~= "enUS" then 
	BI = LibStub:GetLibrary("LibBabble-Inventory-3.0"):GetLookupTable()
else
	BI = {}
	setmetatable(BI,{ __index = function(t,k) return k end })
end

function DrDamage:PlayerData()

	--Special calculation
	self.Calculation["Mace Specialization"] = function( calculation, value )
		if self:GetWeaponType() == BI["One-Handed Maces"] then
			calculation.critM = calculation.critM * (1 + 0.01 * value)
		end
	end
	--General
	self.Calculation["ROGUE"] = function( calculation, ActiveAuras, BuffTalentRanks )
		if BuffTalentRanks["Remorseless Attacks"] and ActiveAuras["Remorseless"] then
			calculation.critPerc = calculation.critPerc + BuffTalentRanks["Remorseless Attacks"]
		end
		if BuffTalentRanks["Improved Kidney Shot"] and ActiveAuras["Kidney Shot"] then
			calculation.dmgM = calculation.dmgM * (1 + BuffTalentRanks["Improved Kidney Shot"])
		end
		if BuffTalentRanks["Find Weakness"] and ActiveAuras["Find Weakness"] then
			calculation.dmgM = calculation.dmgM * (1 + BuffTalentRanks["Find Weakness"])
		end
	end	
	self.Calculation["Murder"] = function( calculation, talentValue )
		local targetType = UnitCreatureType("target")
		
		if BR and targetType and BR:HasReverseTranslation( targetType ) then
			targetType = BR:GetReverseTranslation( targetType )
		end
		
		if targetType == "Humanoid"
		or targetType == "Beast"
		or targetType == "Giant"
		or targetType == "Dragonkin" then
			calculation.dmgM = calculation.dmgM * ( 1 + talentValue )
		end
	end
	
	--Spell specific
	self.Calculation["Mutilate"] = function( calculation, ActiveAuras )
		if ActiveAuras["Deadly Poison"] or ActiveAuras["Poison"] then
			calculation.dmgM = calculation.dmgM * 1.5
		end
	end
	self.Calculation["Envenom"] = function( calculation, ActiveAuras, _, action )
		local cp = calculation.Melee_ComboPoints
		if ActiveAuras["Deadly Poison"] and  cp > 0 then
			local bonus = (self:GetSetAmount("Deathmantle") >= 2) and 40 or 0
			calculation.minDam = calculation.minDam + action.PerCombo * math_min(ActiveAuras["Deadly Poison"], cp) + cp * bonus
			calculation.maxDam = calculation.maxDam + action.PerCombo * math_min(ActiveAuras["Deadly Poison"], cp) + cp * bonus
		else
			calculation.zero = true
		end
	end
	self.Calculation["Ambush"] = function( calculation, ActiveAuras )
		if ActiveAuras["Shadowstep"] then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.Calculation["Garrote"] = self.Calculation["Ambush"]
	self.Calculation["Backstab"] = self.Calculation["Ambush"]
	
	--Set bonuses
	self.SetBonuses["Deathmantle"] = { 30144, 30145, 30146, 30147, 30148, }
	self.SetBonuses["Slayer's Armor"] = { 31026, 31027, 31028, 31029, 31030, 34448, 34558, 34575 }
	
	self.SetBonuses["Eviscerate"] = function( calculation )
		local cp = calculation.Melee_ComboPoints
		if cp > 0 and self:GetSetAmount("Deathmantle") >= 2 then
			calculation.minDam = calculation.minDam + cp * 40
			calculation.maxDam = calculation.maxDam + cp * 40
		end
	end
	self.SetBonuses["Backstab"] = function( calculation )
		if self:GetSetAmount("Slayer's Armor") >= 4 then
			calculation.dmgM = calculation.dmgM * 1.06
		end
	end
	self.SetBonuses["Sinister Strike"] = self.SetBonuses["Backstab"]
	self.SetBonuses["Mutilate"] = self.SetBonuses["Backstab"]
	self.SetBonuses["Hemorrhage"] = self.SetBonuses["Backstab"]
	
	
	--Auras
	local dPoison = { 2818, 2819, 11353, 11354, 25349, 26968, 27187 }
	local allPoisons = { 26688, 3409, 5760, 8692, 11398, 13218 }			
	for _, v in ipairs(dPoison) do
		self.TargetAura[GetSpellInfo(v)] = { ModType = "Special", Spell = { GetSpellInfo(32645), GetSpellInfo(1329) }, }
		self.Calculation[GetSpellInfo(v)] = function( _, ActiveAuras, _, index, apps )
			if not index or select(7,UnitDebuff("target",index)) then
				ActiveAuras["Deadly Poison"] = (ActiveAuras["Deadly Poison"] or 0) + (apps or 5)
			end			
		end
	end
	for _, v in ipairs(allPoisons) do
		self.TargetAura[GetSpellInfo(v)] = { ModType = "Special", Spell = GetSpellInfo(1329) }
		self.Calculation[GetSpellInfo(v)] = function( _, ActiveAuras, _, index )
			if not index or select(7,UnitDebuff("target",index)) then
				ActiveAuras["Poison"] = true
			end
		end
	end
	
	--Remorseless
	--Find Weakness
	--Shadowstep
	--Kidney Shot
	self.PlayerAura[GetSpellInfo(14143)] = { ModType = "ActiveAura", ActiveAura = "Remorseless" }
	self.PlayerAura[GetSpellInfo(31234)] = { ModType = "ActiveAura", ActiveAura = "Find Weakness" }
	self.PlayerAura[GetSpellInfo(36554)] = { ModType = "ActiveAura", ActiveAura = "Shadowstep" }
	self.TargetAura[GetSpellInfo(408)] = { ModType = "ActiveAura", ActiveAura = "Kidney Shot", SelfCast = true }
	
	self.spellInfo = {
		[GetSpellInfo(1752)] = {
			["Name"] = "Sinister Strike",
			[0] = { Energy = 45, WeaponDamage = 1 },
			[1] = { 3 },
			[2] = { 6 },
			[3] = { 10 },
			[4] = { 15 },
			[5] = { 22 },
			[6] = { 33 },
			[7] = { 52 },
			[8] = { 68 },
			[9] = { 80 },
			[10] = { 98 },
		},
		[GetSpellInfo(53)] = {
			["Name"] = "Backstab",
			[0] = { Energy = 60, WeaponDamage = 1.5, Weapon = "Daggers" },
			[1] = { 15 },
			[2] = { 30 },
			[3] = { 48 },
			[4] = { 69 },
			[5] = { 90 },
			[6] = { 135 },
			[7] = { 165 },
			[8] = { 210 },
			[9] = { 225 },
			[10] = { 255 },
		},
		[GetSpellInfo(2098)] = {
			["Name"] = "Eviscerate",
			[0] = { Energy = 35, ComboPoints = true, APBonus = 0.03 },
			[1] = { 6, 10, PerCombo = 5 },
			[2] = { 14, 22, PerCombo = 11 },
			[3] = { 25, 39, PerCombo = 19 },
			[4] = { 41, 61, PerCombo = 31 },
			[5] = { 60, 90, PerCombo = 45 },
			[6] = { 93, 137, PerCombo = 71 },
			[7] = { 144, 212, PerCombo = 110 },
			[8] = { 199, 295, PerCombo = 151 },
			[9] = { 224, 332, PerCombo = 170 },
			[10] = { 245, 365, PerCombo = 185 },
		},
		[GetSpellInfo(8676)] = {
			["Name"] = "Ambush",
			[0] = { Energy = 60, WeaponDamage = 2.75, Weapon = "Daggers" },
			[1] = { 70 },
			[2] = { 100 },
			[3] = { 125 },
			[4] = { 185 },
			[5] = { 230 },
			[6] = { 290 },
			[7] = { 335 },
		},
		[GetSpellInfo(1776)] = {
			["Name"] = "Gouge",
			[0] = { Energy = 45, Cooldown = 10 },
			[1] = { 10 },
			[2] = { 20 },
			[3] = { 32 },
			[4] = { 55 },
			[5] = { 75 },
			[6] = { 105 },
		},
		[GetSpellInfo(1766)] = {
			["Name"] = "Kick",
			[0] = { Energy = 25, Cooldown = 10, NoWeapon = true },
			[1] = { 15 },
			[2] = { 30 },
			[3] = { 45 },
			[4] = { 80 },
			[5] = { 110 },
		},		
		[GetSpellInfo(14278)] = {
			["Name"] = "Ghostly Strike",
			[0] = { Energy = 40, WeaponDamage = 1.25, Cooldown = 20, NoNormalization = true },
			[1] = { 0 },
			["None"] = { 0 },
		},
		[GetSpellInfo(14251)] = {
			["Name"] = "Riposte",
			[0] = { Energy = 10, WeaponDamage = 1.5, NoNormalization = true, NoWeapon = true },
			[1] = { 0 },
			["None"] = { 0 },
		},
		[GetSpellInfo(703)] = {
			["Name"] = "Garrote",
			[0] = { Energy = 50, NoCrits = true, APBonus = 0.18, eDuration = 18, Ticks = 3, NoWeapon = true },
			[1] = { 144 },
			[2] = { 204 },
			[3] = { 282 },
			[4] = { 354 },
			[5] = { 444 },
			[6] = { 552 },
			[7] = { 666 },
			[8] = { 810 },
		},
		[GetSpellInfo(1943)] = {
			["Name"] = "Rupture",
			[0] = { Energy = 25, NoCrits = true, ComboPoints = true, APBonus = { 0.04, 0.10, 0.18, 0.21, 0.24 }, ExtraPerCombo = { 0, 0, 1, 3, 6 }, eDuration = 6, DurationPerCombo = 2 },
			[1] = { 40, PerCombo = 20, Extra = 4 },
			[2] = { 60, PerCombo = 30, Extra = 6 },
			[3] = { 88, PerCombo = 42, Extra = 8 },
			[4] = { 128, PerCombo = 57, Extra = 10 },
			[5] = { 176, PerCombo = 79, Extra = 14 },
			[6] = { 272, PerCombo = 108, Extra = 16 },
			[7] = { 324, PerCombo = 136, Extra = 22 },
		},
		[GetSpellInfo(16511)] = {
			["Name"] = "Hemorrhage",
			[0] = { Energy = 35, WeaponDamage = 1.1 },
			[1] = { 0 },
			[2] = { 0 },
			[3] = { 0 },
			[4] = { 0 },
		},
		[GetSpellInfo(5938)] = {
			["Name"] = "Shiv",
			[0] = { Energy = 20, WeaponDamage = 1, OffhandAttack = true },
			[1] = { 0 },
		},		
		[GetSpellInfo(32645)] = {
			["Name"] = "Envenom",
			[0] = { School = "Nature", Energy = 35, APBonus = 0.03 },
			[1] = { 144, PerCombo = 144 },
			[2] = { 180, PerCombo = 180 },
		},
		[GetSpellInfo(26679)] = {
			["Name"] = "Deadly Throw",
			[0] = { School = "Ranged", WeaponDamage = 1, Energy = 35, ComboPoints = true, APBonus = 0.03 },
			[1] = { 164, 180, PerCombo = 105 },
		},
		[GetSpellInfo(1329)] = {
			["Name"] = "Mutilate",
			[0] = { Energy = 60, WeaponDamage = 1, DualAttack = true, OffhandBonus = true },
			[1] = { 44 },
			[2] = { 63 },
			[3] = { 88 },
			[4] = { 101 },
		},
	}
	self.talentInfo = {
		--Assassination:
		--Remorseless Attacks
		--Find Weakness
		--Puncturing Wounds
		--Improved Eviscerate
		--Lethality
		--Murder
		--Vile Poisons
		--Improved Kidney Shot
		[GetSpellInfo(14144)] = {	[1] = { Effect = 20, Spells = { "Sinister Strike", "Hemorrhage", "Backstab", "Mutilate", "Ambush", "Ghostly Strike" }, ModType = "Amount", Value = "Remorseless Attacks" }, },
		[GetSpellInfo(31233)] = {	[1] = { Effect = 0.02, Spells = "All", ModType = "Amount", Value = "Find Weakness" }, },
		[GetSpellInfo(13733)] = {	[1] = { Effect = 10, Spells = "Backstab", ModType = "critPerc" }, 
						[2] = { Effect = 5, Spells = "Mutilate", ModType = "critPerc" }, },
		[GetSpellInfo(14162)] = {	[1] = { Effect = 0.05, Spells = "Eviscerate" }, },
		[GetSpellInfo(14128)] = {	[1] = { Effect = 0.06, Spells = { "Sinister Strike", "Gouge", "Backstab", "Ghostly Strike", "Mutilate", "Shiv", "Hemorrhage" }, ModType = "critM", Multiply = true }, },
		[GetSpellInfo(14158)] = {	[1] = { Effect = 0.01, Spells = "All", ModType = "Murder" }, },
		[GetSpellInfo(16513)] = {	[1] = { Effect = 0.04, Spells = "Envenom" }, },
		[GetSpellInfo(14174)] = { 	[1] = { Effect = 0.03, Spells = "All", ModType = "Amount", Value = "Improved Kidney Shot" }, },
		--Combat:
		--Aggression
		--Precision
		--Mace Specialization
		--Dual Wield Specialization
		--Surprise Attacks
		[GetSpellInfo(18427)] = {	[1] = { Effect = 0.02, Spells = { "Sinister Strike", "Eviscerate" } }, },
		[GetSpellInfo(13705)] = {	[1] = { Effect = 1, Spells = "All", ModType = "hitPerc" }, },
		[GetSpellInfo(13709)] = {	[1] = { Effect = 1, Spells = "All", ModType = "Mace Specialization" }, },
		[GetSpellInfo(13715)] = { 	[1] = { Effect = 0.1, Spells = { "Attack", "Mutilate" }, ModType = "offHdmgM", Multiply = true }, NoManual = true, },
		[GetSpellInfo(32601)] = {	[1] = { Effect = 0.1, Spells = { "Sinister Strike", "Backstab", "Shiv", "Gouge" } }, },
		--Subtlety:
		--Improved Ambush
		--Opportunity
		--Serrated Blades
		--Sinister Calling
		[GetSpellInfo(14079)] = {	[1] = { Effect = 15, Spells = "Ambush", ModType = "critPerc" }, },
		[GetSpellInfo(14057)] = {	[1] = { Effect = 0.04, Spells = { "Backstab", "Mutilate", "Ambush" } }, },
		[GetSpellInfo(14171)] = {	[1] = { Effect = 0.1, Spells = "Rupture" }, },
		[GetSpellInfo(31216)] = {	[1] = { Effect = 0.01, Spells = { "Backstab", "Hemorrhage" }, Add = true, }, },
	}
end