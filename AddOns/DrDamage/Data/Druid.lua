if select(2, UnitClass("player")) ~= "DRUID" then return end
local GetSpellInfo = GetSpellInfo
local IsEquippedItem = IsEquippedItem
local UnitStat = UnitStat

--No base increase on: Insect Swarm, Rejuvenation, Entangling Roots, Lifebloom

function DrDamage:PlayerData()

	--Special calculation
	
	--General
	local tol = GetSpellInfo(34123)
	self.Calculation["DRUID"] = function( calculation, ActiveAuras, BuffTalentRanks )
		if calculation.healingSpell then
			if ActiveAuras["Tree of Life"] or not UnitExists("target") and GetPlayerBuffName(tol) then
				calculation.spellDmg = calculation.spellDmg + 0.25 * select(2,UnitStat("player",5)) + (IsEquippedItem(32387) and 44 or 0) --Idol of the Raven Goddess
			end
		else
			if BuffTalentRanks["Naturalist"] then
				calculation.dmgM = calculation.dmgM / ( 1 + BuffTalentRanks["Naturalist"] )
			end
		end
	end
	
	--Set bonuses
	
	--Sets
	self.SetBonuses["Nordrassil Harness"] = { 30222, 30223, 30228, 30229, 30230 }
	self.SetBonuses["Nordrassil Raiment"] = { 30216, 30217, 30219, 30220, 30221 }
	self.SetBonuses["Nordrassil Regalia"] = { 30231, 30232, 30233, 30234, 30235 }
	
	self.SetBonuses["Thunderheart Harness"] = { 31034, 31039, 31042, 31044, 31048, 34444, 34556, 34573 }
	self.SetBonuses["Thunderheart Raiment"] = { 31032, 31037, 31041, 31045, 31047, 34445, 34554, 34571 }
	self.SetBonuses["Thunderheart Regalia"] = { 31035, 31040, 31043, 31046, 31049, 34446, 34555, 34572 }
	
	--Effects
	self.SetBonuses["Regrowth"] = function( calculation )
		if self:GetSetAmount( "Nordrassil Raiment" ) >= 2 then
			calculation.eDuration = calculation.eDuration + 6
		end
	end
	self.SetBonuses["Lifebloom"] = function( calculation, _, spell )
		if self:GetSetAmount( "Nordrassil Raiment" ) >= 4 then
			calculation.finalMod = calculation.finalMod + 150
		end
		if IsEquippedItem(27886) then --Idol of the Emerald Queen, +88 to HOT portion
			calculation.dotFinalMod = calculation.dotFinalMod + 88 * spell.dotFactor
		elseif IsEquippedItem(28355) then --Gladiator's Idol of Tenacity
			calculation.finalMod = calculation.finalMod + 87
		elseif IsEquippedItem(33076) then --Merciless Gladiator's Idol of Tenacity
			calculation.finalMod = calculation.finalMod + 105
		elseif IsEquippedItem(33841) then --Vengeful Gladiator's Idol of Tenacity
			calculation.finalMod = calculation.finalMod + 116
		end
	end
	self.SetBonuses["Starfire"] = function( calculation, ActiveAuras )
		if self:GetSetAmount( "Nordrassil Regalia" ) >= 4 then
			if ActiveAuras["Moonfire"] or ActiveAuras["Insect Swarm"] then
				calculation.dmgM = calculation.dmgM * 1.1
			end
		end
		if self:GetSetAmount( "Thunderheart Regalia" ) >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
	end
	self.SetBonuses["Moonfire"] = function( calculation )
		if self:GetSetAmount( "Thunderheart Regalia" ) >= 2 then
			calculation.eDuration = calculation.eDuration + 3
		end
	end	
	self.SetBonuses["Shred"] = function( calculation )
		if self:GetSetAmount("Nordrassil Harness") >= 4 then
			calculation.minDam = calculation.minDam + 75
			calculation.maxDam = calculation.maxDam + 75
		end
	end
	self.SetBonuses["Lacerate"] = function( calculation )
		if self:GetSetAmount("Nordrassil Harness") >= 4 then
			calculation.extraDamBonus = calculation.extraDamBonus + 15
		end
		if IsEquippedItem(27744) then --Idol of Ursoc
			calculation.extraDamBonus = calculation.extraDamBonus + 8
			calculation.minDam = calculation.minDam + 8
			calculation.maxDam = calculation.maxDam + 8
		end
	end
	self.SetBonuses["Rip"] = function( calculation )
		if self:GetSetAmount("Thunderheart Harness") >= 4 then
			calculation.dmgM = calculation.dmgM * 1.15
		end
		if IsEquippedItem(28372) then --Idol of Feral Shadows
			local cp = calculation.Melee_ComboPoints
			calculation.minDam = calculation.minDam + 7 * cp
			calculation.maxDam = calculation.maxDam + 7 * cp
		end
	end
	self.SetBonuses["Ferocious Bite"] = self.SetBonuses["Rip"]
	self.SetBonuses["Swipe"] = self.SetBonuses["Rip"]
	self.SetBonuses["Healing Touch"] = function( calculation )
		if self:GetSetAmount("Thunderheart Raiment") >= 4 then
			calculation.dmgM = calculation.dmgM * 1.05
		end		
	end

	
	--Relic slot items:
	self.RelicSlot["Rejuvenation"] = { 25643, 86, 22398, 50, ModType1 = "finalMod_sM", ModType2 = "finalMod_sM" }	--Harold's Rejuvenating Broach, Idol of Rejuvenation
	self.RelicSlot["Healing Touch"] = { 28568, 136, 22399, 100, ModType1 = "finalMod_fM", ModType2 = "finalMod_fM" }--Idol of the Avian Heart, Idol of Health
	self.RelicSlot["Wrath"] = { 31025, 25 }										--Idol of the Avenger		
	self.RelicSlot["Moonfire"] = { 23197, 33, ModType1 = "finalMod_sM" }						--Idol of the Moon
	self.RelicSlot["Starfire"] = { 27518, 55, ModType1 = "finalMod_sM" }						--Ivory Idol of the Moongoddess
	
	self.RelicSlot["Shred"] = { 29390, 88, } --Everbloom idol
	self.RelicSlot["Mangle (Cat)"] = { 28064, 24, } --Idol of the Wild
	self.RelicSlot["Mangle (Bear)"] = { 28064, 51.75, } --Idol of the Wild
	self.RelicSlot["Maul"] = { 23198, 50 } --Idol of Brutality
	self.RelicSlot["Swipe"] = { 23198, 10 } --Idol of Brutality
	self.RelicSlot["Rake"] = { 22397, 20, 27989, 30 } --Idol of Ferocity, Idol of Savagery
	self.RelicSlot["Claw"] = { 22397, 20, 27989, 30 } --Idol of Ferocity, Idol of Savagery
	
	--AURA
	--Nature's Grace
	--Moonfire
	--Insect Swarm
	--Mangle (Bear)
	--Mangle (Cat)
	self.PlayerAura[GetSpellInfo(16880)] = { ModType = "Update" }
	self.TargetAura[GetSpellInfo(34123)] = { School = "Healing", ModType = "ActiveAura", ActiveAura = "Tree of Life", }
	self.TargetAura[GetSpellInfo(8921)] = { Spell = GetSpellInfo(2912), ModType = "ActiveAura", ActiveAura = "Moonfire", }
	self.TargetAura[GetSpellInfo(5570)] = { Spell = GetSpellInfo(2912), ModType = "ActiveAura", ActiveAura = "Insect Swarm", }
	self.TargetAura[GetSpellInfo(33878)] = { Spell = { GetSpellInfo(9005), GetSpellInfo(1079), GetSpellInfo(33745), GetSpellInfo(5221), GetSpellInfo(1822) }, Value = 0.3 }
	self.TargetAura[GetSpellInfo(33876)] = self.TargetAura[GetSpellInfo(33878)]

	self.spellInfo = {
		[GetSpellInfo(5176)] = {
					["Name"] = "Wrath",
					[0] = { School = "Nature", canCrit = true, castTime = 2, CastMod = 0.1, BaseIncrease = true, LevelIncrease = 7 },
					[1] = { 12, 14, 1, 2, spellLevel = 1, castTime = 1.5, },
					[2] = { 25, 29, 3, 4, spellLevel = 6, castTime = 1.7, },
					[3] = { 44, 52, 4, 5, spellLevel = 14, },
					[4] = { 63, 73, 6, 6, spellLevel = 22, },
					[5] = { 101, 115, 7, 8, spellLevel = 30, },
					[6] = { 139, 157, 9, 10, spellLevel = 38, },
					[7] = { 188, 210, 10, 11, spellLevel = 46, },
					[8] = { 236, 264, 12, 13, spellLevel = 54, },
					[9] = { 278, 312, 14, 15, spellLevel = 61, },
					[10] = { 381, 429, 2, 3, spellLevel = 69, },
		},
		[GetSpellInfo(27012)] = {
					["Name"] = "Hurricane",
					[0] = { School = "Nature", castTime = 10, sHits = 10, bonusFactor = 1.28962, BaseIncrease = true, LevelIncrease = 9 },
					[1] = { 70, 70, 1, 2, spellLevel = 40, },
					[2] = { 100, 100, 1, 2, spellLevel = 50, },
					[3] = { 134, 134, 1, 2, spellLevel = 60, },
					[4] = { 206, 206, 0, 0, spellLevel = 70, },
		},
		[GetSpellInfo(5570)] = {
					["Name"] = "Insect Swarm",
					[0] = { School = "Nature", sFactor = 0.95, eDot = true, eDuration = 12, sTicks = 2, },
					[1] = { 108, 108, spellLevel = 20 },
					[2] = { 192, 192, spellLevel = 30 },
					[3] = { 300, 300, spellLevel = 40 },
					[4] = { 432, 432, spellLevel = 50 },
					[5] = { 594, 594, spellLevel = 60 },
					[6] = { 792, 792, spellLevel = 70 },
		},		
		[GetSpellInfo(8921)] = {
					["Name"] = "Moonfire",
					[0] = { School = "Arcane", canCrit = true, eDuration = 12, sTicks = 3, hybridFactor = 0.348, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 7, 9, 2, 3, hybridDotDmg = 12, spellLevel = 4, },
					[2] = { 13, 17, 4, 4, hybridDotDmg = 32, spellLevel = 10 },
					[3] = { 25, 31, 5, 6, hybridDotDmg = 52, spellLevel = 16, },
					[4] = { 40, 48, 7, 7, hybridDotDmg = 80, spellLevel = 22, },
					[5] = { 61, 73, 9, 9, hybridDotDmg = 124, spellLevel = 28, },
					[6] = { 81, 97, 10, 11, hybridDotDmg = 164, spellLevel = 34, },
					[7] = { 105, 125, 12, 12, hybridDotDmg = 212, spellLevel = 40, },
					[8] = { 130, 154, 13, 14, hybridDotDmg = 264, spellLevel = 46, },
					[9] = { 157, 185, 15, 15, hybridDotDmg = 320, spellLevel = 52, },
					[10] = { 189, 221, 16, 17, hybridDotDmg = 384, spellLevel = 58, },
					[11] = { 220, 258, 18, 18, hybridDotDmg = 444, spellLevel = 63, },
					[12] = { 305, 357, 0, 0, hybridDotDmg = 600, spellLevel = 70, },
		},
		[GetSpellInfo(2912)] = {
					["Name"] = "Starfire",
					[0] = { School = "Arcane", canCrit = true, castTime = 3.5, CastMod = 0.1, BaseIncrease = true, LevelIncrease = 7 },
					[1] = { 89, 109, 6, 6, spellLevel = 20, },
					[2] = { 137, 167, 9, 10, spellLevel = 26, },
					[3] = { 201, 241, 11, 12, spellLevel = 34, },
					[4] = { 280, 334, 13, 14, spellLevel = 42, },
					[5] = { 362, 428, 16, 17, spellLevel = 50, },
					[6] = { 445, 525, 18, 18, spellLevel = 58, },
					[7] = { 496, 584, 18, 19, spellLevel = 60, },
					[8] = { 540, 636, 10, 11, spellLevel = 67, },
		},
		[GetSpellInfo(339)] = {
					["Name"] = "Entangling Roots",
					[0] = { School = "Nature", eDot = true, eDuration = 27, sFactor = 0.5, sTicks = 3, },
					[1] = { 20, 20, spellLevel = 8, eDuration = 12, },
					[2] = { 50, 50, spellLevel = 18, eDuration = 15, },
					[3] = { 90, 90, spellLevel = 28, eDuration = 18, },
					[4] = { 140, 140, spellLevel = 38, eDuration = 21, },
					[5] = { 200, 200, spellLevel = 48, eDuration = 24, },
					[6] = { 270, 270, spellLevel = 58, },
					[7] = { 351, 351, spellLevel = 68, },
		},
		[GetSpellInfo(5185)] = {
					["Name"] = "Healing Touch",
					[0] = { School = { "Nature", "Healing", }, canCrit = true, castTime = 3.5,CastMod = 0.1, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 37, 51, 3, 4, spellLevel = 1, castTime = 1.5, },
					[2] = { 88, 112, 6, 7, spellLevel = 8, castTime = 2, },
					[3] = { 195, 243, 9, 10, spellLevel = 14, castTime = 2.5, },
					[4] = { 363, 446, 13, 13, spellLevel = 20, castTime = 3, },
					[5] = { 572, 694, 17, 18, spellLevel = 26, },
					[6] = { 742, 894, 20, 20, spellLevel = 32, },
					[7] = { 936, 1120, 22, 23, spellLevel = 38, },					
					[8] = { 1199, 1427, 26, 26, spellLevel = 44, },
					[9] = { 1516, 1796, 29, 30, spellLevel = 50, },
					[10] = { 1890, 2230, 33, 33, spellLevel = 56, },
					[11] = { 2267, 2677, 36, 37, spellLevel = 60, },
					[12] = { 2364, 2790, 37, 37, spellLevel = 62, },
					[13] = { 2707, 3197, 8, 9, spellLevel = 69, },
		},
		[GetSpellInfo(774)] = {
					["Name"] = "Rejuvenation",
					[0] = { School = { "Nature", "Healing", }, eDot = true, eDuration = 12, sTicks = 3, },
					[1] = { 32, 32, spellLevel = 4, },
					[2] = { 56, 56, spellLevel = 10, },
					[3] = { 116, 116, spellLevel = 16, },
					[4] = { 180, 180, spellLevel = 22, },
					[5] = { 244, 244, spellLevel = 28, },
					[6] = { 304, 304, spellLevel = 34, },
					[7] = { 388, 388, spellLevel = 40, },
					[8] = { 488, 488, spellLevel = 46, },
					[9] = { 608, 608, spellLevel = 52, },
					[10] = { 756, 756, spellLevel = 58, },
					[11] = { 888, 888, spellLevel = 60, },
					[12] = { 932, 932, spellLevel = 63, },
					[13] = { 1060, 1060, spellLevel = 69, },
		},
		[GetSpellInfo(8936)] = {
					["Name"] = "Regrowth",
					[0] = { School = { "Nature", "Healing", }, canCrit = true, castTime = 2, hybridFactor = 0.499, eDuration = 21, sTicks = 3, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 84, 98, 9, 9, hybridDotDmg = 98, spellLevel = 12, },
					[2] = { 164, 188, 12, 13, hybridDotDmg = 175, spellLevel = 18, },
					[3] = { 240, 274, 15, 16, hybridDotDmg = 259, spellLevel = 24, },
					[4] = { 318, 360, 18, 18, hybridDotDmg = 343, spellLevel = 30, },
					[5] = { 405, 457, 20, 21, hybridDotDmg = 427, spellLevel = 36, },
					[6] = { 511, 575, 23, 24, hybridDotDmg = 546, spellLevel = 42, },
					[7] = { 646, 724, 26, 27, hybridDotDmg = 686, spellLevel = 48, },
					[8] = { 809, 905, 30, 30, hybridDotDmg = 861, spellLevel = 54, },
					[9] = { 1003, 1119, 34, 34, hybridDotDmg = 1064, spellLevel = 60, },
					[10] = { 1215, 1355, 38, 39, hybridDotDmg = 1274, spellLevel = 65, },
		},
		[GetSpellInfo(740)] = {
					["Name"] = "Tranquility",
					[0] = { School = { "Nature", "Healing", }, castTime = 8, Cooldown = 600, sFactor = 1/3, sHits = 4, BaseIncrease = true, LevelIncrease = 9 },
					[1] = { 351, 351, 13, 14, spellLevel = 30, },
					[2] = { 515, 515, 15, 16, spellLevel = 40, },
					[3] = { 765, 765, 20, 21, spellLevel = 50, },
					[4] = { 1097, 1097, 22, 23, spellLevel = 60, },
					[5] = { 1518, 1518, 0, 0,  spellLevel = 70, },
		},
		[GetSpellInfo(33763)] = {
					["Name"] = "Lifebloom",
					[0] = { School = { "Nature", "Healing" }, canCrit = true, eDuration = 7, sTicks = 1, bonusFactor = 1.5/3.5 * 0.8, dotFactor = 0.51983, DotStacks = 3 },
					[1] = { 600, 600, hybridDotDmg = 273, spellLevel = 64, },					
		},
		--Feral
		[GetSpellInfo(6807)] = {
					["Name"] = "Maul",
					[0] = { Rage = 15, Melee = true, WeaponDamage = 1, RequiresForm = 1, NextMelee = true },
					[1] = { 18 },
					[2] = { 27 },
					[3] = { 37 },
					[4] = { 49 },
					[5] = { 71 },
					[6] = { 101 },
					[7] = { 128 },
					[8] = { 176 },
		},
		[GetSpellInfo(779)] = { 	
					["Name"] = "Swipe",
					[0] = { Rage = 20, Melee = true, RequiresForm = 1, APBonus = 0.07 },
					[1] = { 10 },
					[2] = { 14 },
					[3] = { 21 },
					[4] = { 41 },
					[5] = { 60 },
					[6] = { 84 },
		},
		[GetSpellInfo(1082)] = {
					["Name"] = "Claw",
					[0] = { Energy = 45, WeaponDamage = 1, Melee = true, RequiresForm = 3 },
					[1] = { 27 },
					[2] = { 39 },
					[3] = { 57 },
					[4] = { 88 },
					[5] = { 115 },
					[6] = { 190 },
		},
		[GetSpellInfo(1079)] = {
					["Name"] = "Rip",
					[0] = { Energy = 30, NoCrits = true, ComboPoints = true, Melee = true, RequiresForm = 3, eDuration = 12, APBonus = { 0.24 * 0.25, 0.24 * 0.5, 0.24 * 0.75, 0.24, 0.24 } },
					[1] = { 42, PerCombo = 24 },
					[2] = { 66, PerCombo = 32 },
					[3] = { 90, PerCombo = 54 },
					[4] = { 138, PerCombo = 84, },
					[5] = { 192, PerCombo = 120, },
					[6] = { 270, PerCombo = 168, },
					[7] = { 300, PerCombo = 198, },
		},
		[GetSpellInfo(5221)] = {
					["Name"] = "Shred",
					[0] = { Energy = 60, WeaponDamage = 2.25, Melee = true, RequiresForm = 3 },
					[1] = { 54 },
					[2] = { 72 },
					[3] = { 99 },
					[4] = { 144 },
					[5] = { 180 },
					[6] = { 236 },
					[7] = { 405 },
		},
		[GetSpellInfo(1822)] = {
					["Name"] = "Rake",
					[0] = { School = { "Physical", "Bleed" }, Energy = 40, APBonus = 0.01, ExtraDamage = 0.06, E_eDuration = 9, Melee = true, RequiresForm = 3 },
					[1] = { 17, Extra = 30 },
					[2] = { 26, Extra = 45 },
					[3] = { 40, Extra = 60 },
					[4] = { 55, Extra = 75 },
					[5] = { 78, Extra = 108 },
		},
		[GetSpellInfo(22568)] = {
					["Name"] = "Ferocious Bite",
					[0] = { Energy = 35, ComboPoints = true, APBonus = 0.03, Melee = true, RequiresForm = 3 },
					[1] = { 50, 66, PerCombo = 46, PowerBonus = 1 },
					[2] = { 79, 103, PerCombo = 59, PowerBonus = 1.5 },
					[3] = { 122, 162, PerCombo = 92, PowerBonus = 2 },
					[4] = { 173, 223, PerCombo = 128, PowerBonus = 2.5 },
					[5] = { 199, 259, PerCombo = 147, PowerBonus = 2.7 },
					[6] = { 259, 292, PerCombo = 169, PowerBonus = 4.1 },
		},
		[GetSpellInfo(6785)] = {
					["Name"] = "Ravage",
					[0] = { Energy = 60, WeaponDamage = 3.85, Melee = true, RequiresForm = 3 },
					[1] = { 147 },
					[2] = { 217 },
					[3] = { 273 },
					[4] = { 343 },
					[5] = { 514 },
		},
		[GetSpellInfo(9005)] = {
					["Name"] = "Pounce",
					[0] = { Energy = 50, NoCrits = true, APBonus = 0.18, Melee = true, RequiresForm = 3, eDuration = 18 },
					[1] = { 270 },
					[2] = { 330 },
					[3] = { 450 },
					[4] = { 600 },
		},
		[GetSpellInfo(33878)] = {
					["Name"] = "Mangle (Bear)",
					[0] = { Rage = 20, WeaponDamage = 1.15, Melee = true, RequiresForm = 1, Cooldown = 6 },
					[1] = { 86.25 },
					[2] = { 120.75 },
					[3] = { 155.25 },
		},
		[GetSpellInfo(33876)] = {
					["Name"] = "Mangle (Cat)",
					[0] = { Energy = 45, WeaponDamage = 1.60, Melee = true, RequiresForm = 3, },
					[1] = { 158.4 },
					[2] = { 204.8 },
					[3] = { 264 },
		},
		[GetSpellInfo(22570)] = {
					["Name"] = "Maim",
					[0] = { Energy = 35, WeaponDamage = 1, ComboPoints = true, Melee = true, RequiresForm = 3, Cooldown = 10 },
					[1] = { 129, PerCombo = 84 },
		},
		[GetSpellInfo(33745)] = {
					["Name"] = "Lacerate",
					[0] = { School = { "Physical", "Bleed" }, Rage = 15, Melee = true, ExtraDamage = 0.05, E_eDuration = 15 },
					[1] = { 31, Extra = 155 },
		},		
	}
	self.talentInfo = {
		--Balance
		--Focused Starlight
		--Improved Moonfire
		--Brambles
		--Vengeance
		--Moonfury
		--Balance of Power
		--Wrath of Cenarius
		[GetSpellInfo(35363)] = { 	[1] = { Effect = 2, Spells = { "Wrath", "Starfire" }, ModType = "critPerc", }, },
		[GetSpellInfo(16821)] = { 	[1] = { Effect = 5, Spells = "Moonfire", ModType = "critPerc", }, 
						[2] = { Effect = 0.05, Spells = "Moonfire", }, },
		[GetSpellInfo(16836)] = {       [1] = { Effect = 0.25, Spells = { "Entangling Roots" }, }, },				
		[GetSpellInfo(16909)] = { 	[1] = { Effect = 0.1, Spells = { "Starfire", "Moonfire", "Wrath" }, ModType = "critM", }, },
		[GetSpellInfo(16896)] = { 	[1] = { Effect = 0.02, Spells = { "Starfire", "Moonfire", "Wrath" }, }, },
		[GetSpellInfo(33592)] = { 	[1] = { Effect = 2, Spells = "All", Caster = true, ModType = "hitPerc" }, },
		[GetSpellInfo(33603)] = { 	[1] = { Effect = 0.04, Spells = "Starfire", ModType = "SpellDamage", },
						[2] = { Effect = 0.02, Spells = "Wrath", ModType = "SpellDamage", }, },
		--Restoration
		--Naturalist
		--Gift of Nature
		--Improved Rejuvenation
		--Improved Regrowth
		--Empowered Touch
		--Empowered Rejuvenation
		[GetSpellInfo(17069)] = { 	[1] = { Effect = 0.02, Spells = "All", Caster = true, ModType = "Amount", Value = "Naturalist" }, },
		[GetSpellInfo(17104)] = { 	[1] = { Effect = 0.02, Spells = "Healing", Add = true, }, },
		[GetSpellInfo(17111)] = { 	[1] = { Effect = 0.05, Spells = "Rejuvenation", Add = true, }, },
		[GetSpellInfo(17074)] = { 	[1] = { Effect = 10, Spells = "Regrowth", ModType = "critPerc" }, },
		[GetSpellInfo(33879)] = { 	[1] = { Effect = 0.1, Spells = "Healing Touch", ModType = "SpellDamage", }, },
		[GetSpellInfo(33886)] = { 	[1] = { Effect = 0.04, Spells = { "Rejuvenation", "Regrowth", "Lifebloom" }, ModType = "SpellDamage", Multiply = true, }, 
						[2] = { Effect = 0.04, Spells = { "Regrowth", "Lifebloom", }, ModType = "dotSpellDmgM", Multiply = true, }, },
		--Feral
		--Feral Aggression
		--Savage Fury
		--Predatory Instincts
		[GetSpellInfo(16858)] = { 	[1] = { Effect = 0.03, Spells = "Ferocious Bite", }, },
		[GetSpellInfo(16998)] = { 	[1] = { Effect = 0.1, Spells = { "Claw", "Rake", "Mangle (Cat)" }, }, },
		[GetSpellInfo(33859)] = { 	[1] = { Effect = 0.04, Spells = "All", Melee = true, ModType = "critM" }, },
	}
end