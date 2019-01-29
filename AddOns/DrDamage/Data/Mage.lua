if select(2, UnitClass("player")) ~= "MAGE" then return end
local GetSpellInfo = GetSpellInfo
local UnitManaMax = UnitManaMax

function DrDamage:PlayerData()

	--Special AB info
	--Evocation
	self.ClassSpecials[GetSpellInfo(12051)] = function()
		if self:GetSetAmount( "Tempest Regalia" ) >= 2 then
			return 0.75 * UnitManaMax("player"), 0.40, 0.8, 1
		else
			return 0.6 * UnitManaMax("player"), 0.40, 0.8, 1
		end
	end
	
	--General
	self.Calculation["MAGE"] = function( calculation )
		if self.db.profile.ManaConsumables then
			calculation.manaRegen = calculation.manaRegen + 20 --Assumes usage of Conjured Mana Emeralds 
		end
	end	
	
	--Spell specific
	self.Calculation["Ice Lance"] = function( calculation, ActiveAuras )
		if ActiveAuras["Frost Nova"] or ActiveAuras["Frostbite"] then
			calculation.spellDmgM = calculation.spellDmgM  * 3
			calculation.bDmgM = calculation.bDmgM  + 2
		end
	end
	
	--Set Bonuses
	--Sets
	self.SetBonuses["Tirisfal Armor"] = { 30196, 30205, 30206, 30207, 30210 }
	self.SetBonuses["Tempest Regalia"] = { 31055, 31056, 31057, 31058, 31059, 34447, 34557, 34574 }
	
	--Effects
	self.SetBonuses["Arcane Blast"] = function( calculation )
		if self:GetSetAmount( "Tirisfal Armor" ) >= 2 then
			calculation.dmgM = calculation.dmgM * 1.2
		end
	end
	self.SetBonuses["Fireball"] = function( calculation )
		if self:GetSetAmount( "Tempest Regalia" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.05
		end	
	end
	self.SetBonuses["Frostbolt"] = self.SetBonuses["Fireball"]
	self.SetBonuses["Arcane Missiles"] = self.SetBonuses["Fireball"]
	
	
	--AURA
	--Arcane Blast
	--Arcane Power
	--Combustion
	--Frost Nova
	--Frostbite
	self.PlayerAura[GetSpellInfo(30451)] = { ModType = "Update", Spell = GetSpellInfo(30451) }	
	self.PlayerAura[GetSpellInfo(12042)] = { Value = 0.3 }
	self.PlayerAura[GetSpellInfo(11129)] = { School = "Fire", Value = 10, Apps = 3, ModType = "critPerc" }	
	self.TargetAura[GetSpellInfo(122)] = { ModType = "Special", }	
	self.TargetAura[GetSpellInfo(12494)] = { ModType = "Special", }
	
	--Frost Nova
	self.Calculation[GetSpellInfo(122)] = function( calculation, ActiveAuras, BuffTalentRanks )
		if not ActiveAuras["Frost Nova"] and not ActiveAuras["Frostbite"] then
			ActiveAuras["Frost Nova"] = true
			if BuffTalentRanks["Shatter"] then
				calculation.critPerc = calculation.critPerc + 10 * BuffTalentRanks["Shatter"]
			end
		end
	end
	--Frostbite
	self.Calculation[GetSpellInfo(12494)] = function( calculation, ActiveAuras, BuffTalentRanks )
		if not ActiveAuras["Frost Nova"] and not ActiveAuras["Frostbite"] then
			ActiveAuras["Frostbite"] = true
			if BuffTalentRanks["Shatter"] then
				calculation.critPerc = calculation.critPerc + 10 * BuffTalentRanks["Shatter"]
			end
		end
	end
	
	self.spellInfo = {
		[GetSpellInfo(11366)] = {
					["Name"] = "Pyroblast",
					[0] = { School = "Fire", castTime = 6, canCrit = true, eDuration=12, sTicks = 3, bonusFactor = 1.15, hybridDotFactor = 0.25, BaseIncrease = true, LevelIncrease = 5, },
					[1] = { 141, 187, 7, 8, hybridDotDmg = 56, spellLevel = 20, },
					[2] = { 180, 236, 13, 14, hybridDotDmg = 72, spellLevel = 24, },
					[3] = { 255, 327, 15, 16, hybridDotDmg = 96, spellLevel = 30, },
					[4] = { 329, 419, 18, 18, hybridDotDmg = 124, spellLevel = 36, },
					[5] = { 407, 515, 20, 21, hybridDotDmg=156, spellLevel = 42, },
					[6] = { 503, 631, 22, 23, hybridDotDmg=188, spellLevel = 48, },
					[7] = { 600, 750, 25, 26, hybridDotDmg=228, spellLevel = 54, },
					[8] = { 708, 898, 27, 28, hybridDotDmg=268, spellLevel = 60, },
					[9] = { 846, 1074, 20, 20, hybridDotDmg=312, spellLevel = 66, },
					[10] = { 939, 1191, 0, 0, hybridDotDmg=356, spellLevel = 70, },
		},
		[GetSpellInfo(133)] = {
					["Name"] = "Fireball",
					[0] = { School = "Fire", canCrit = true, castTime = 3.5, CastMod = 0.1, eDuration=8, sTicks = 2, BaseIncrease = true, LevelIncrease = 3, },
					[1] = { 14, 22, 2, 3, extraDotDmg= 2, spellLevel = 1, castTime = 1.5, eDuration = 4, },
					[2] = { 31, 45, 3, 4, extraDotDmg= 3, spellLevel = 6, castTime = 2, eDuration = 6, },
					[3] = { 53, 73, 4, 4, extraDotDmg= 6, spellLevel = 12, castTime = 2.5, eDuration = 6, },
					[4] = { 84, 116, 5, 6, extraDotDmg= 12, spellLevel = 18, castTime = 3, },
					[5] = { 139, 187, 6, 8, extraDotDmg= 20, spellLevel = 24, },
					[6] = { 199, 265, 8, 9, extraDotDmg= 28, spellLevel = 30, },
					[7] = { 255, 335, 11, 10, extraDotDmg= 32, spellLevel = 36, },
					[8] = { 318, 414, 10, 11, extraDotDmg=40, spellLevel = 42, },
					[9] = { 392, 506, 12, 12, extraDotDmg=52, spellLevel = 48, },
					[10] = { 475, 609, 13, 14, extraDotDmg=60, spellLevel = 54, },
					[11] = { 561, 715, 14, 15, extraDotDmg=72, spellLevel = 60, },
					[12] = { 596, 760, 15, 16, extraDotDmg=76, spellLevel = 60, },
					[13] = { 633, 805, 16, 16, extraDotDmg=84, spellLevel = 66, },
		},
		[GetSpellInfo(2948)] = {
					["Name"] = "Scorch",
					[0] = { School = "Fire", canCrit = true, BaseIncrease = true, LevelIncrease = 5, },
					[1] = { 53, 65, 3, 4, spellLevel = 22, },
					[2] = { 77, 93, 4, 5, spellLevel = 28, },
					[3] = { 100, 120, 5, 6, spellLevel = 34, },
					[4] = { 133, 159, 6, 6, spellLevel = 40, },
					[5] = { 162, 192, 6, 7, spellLevel = 46, },
					[6] = { 200, 239, 7, 8, spellLevel = 52, },
					[7] = { 233, 275, 8, 9, spellLevel = 58, },
					[8] = { 269, 317, 9, 10, spellLevel = 64, },
					[9] = { 305, 361, 0, 0, spellLevel = 70, },
		},
		[GetSpellInfo(2136)] = {
					["Name"] = "Fire Blast",
					[0] = { School = "Fire", canCrit = true, Cooldown = 8, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 24, 32, 3, 3, spellLevel = 6, },
					[2] = { 57, 71, 5, 5, spellLevel = 14, },
					[3] = { 103, 127, 7, 7, spellLevel = 22, },
					[4] = { 168, 202, 9, 9, spellLevel = 30, },
					[5] = { 242, 290, 11, 11, spellLevel = 38, },
					[6] = { 332, 394, 13, 13, spellLevel = 46, },
					[7] = { 431, 509, 15, 15, spellLevel = 54, },
					[8] = { 539, 637, 16, 18, spellLevel = 61, },
					[9] = { 664, 786, 0, 0, spellLevel = 70, },
		},				
		[GetSpellInfo(11113)] = {
					["Name"] = "Blast Wave",
					[0] = { School = "Fire", canCrit = true, sFactor=0.90 * 1/2, Cooldown = 45, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 154, 186, 6, 6, spellLevel = 30, },
					[2] = { 201, 241, 7, 8, spellLevel = 36, },
					[3] = { 277, 329, 8, 9, spellLevel = 44, },
					[4] = { 365, 433, 9, 10, spellLevel = 52, },
					[5] = { 462, 544, 11, 12, spellLevel = 60, },
					[6] = { 533, 627, 10, 11, spellLevel = 65, },
					[7] = { 616, 724, 0, 0, spellLevel = 70, },
		},
		[GetSpellInfo(31661)] = {
					["Name"] = "Dragon's Breath",
					[0] = { School = "Fire", canCrit = true, sFactor= 0.90 * 1/2, Cooldown = 20, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 370, 430, 12, 12, spellLevel = 50, },
					[2] = { 454, 526, 9, 10, spellLevel = 56, },
					[3] = { 574, 666, 10, 11, spellLevel = 64, },
					[4] = { 680, 790, 0, 0, spellLevel = 70, },
		},				
		[GetSpellInfo(2120)] = {
					["Name"] = "Flamestrike",
					[0] = { School = "Fire", castTime = 3, canCrit = true, eDuration = 8, sTicks = 2, sFactor = 1/2, hybridFactor = 417/757, hybridDotFactor = 0.83, BaseIncrease = true, LevelIncrease = 7 },
					[1] = { 52, 68, 3, 3, hybridDotDmg = 48, spellLevel = 16, },
					[2] = { 96, 122, 4, 4, hybridDotDmg = 88, spellLevel = 24, },
					[3] = { 154, 192, 5, 5, hybridDotDmg = 140, spellLevel = 32, },
					[4] = { 220, 272, 6, 7, hybridDotDmg = 192, spellLevel = 40, },
					[5] = { 291, 359, 7, 8, hybridDotDmg = 264, spellLevel = 48, },
					[6] = { 375, 459, 8, 9, hybridDotDmg = 340, spellLevel = 56, },
					[7] = { 471, 575, 9, 10, hybridDotDmg = 424, spellLevel = 64, },
					--Check LevelIncrease
		},				
		[GetSpellInfo(116)] = {
					["Name"] = "Frostbolt",
					[0] = { School = "Frost", castTime = 3, canCrit = true, CastMod = 0.1, sFactor_Base = 0.95, BaseIncrease = true, LevelIncrease = 4, },
					[1] = { 18, 20, 2, 2, spellLevel = 4, castTime = 1.5, },
					[2] = { 31, 35, 2, 3, spellLevel = 8, castTime = 1.8, },
					[3] = { 51, 57, 3, 4, spellLevel = 14, castTime = 2.2, },
					[4] = { 74, 82, 4, 5, spellLevel = 20, castTime = 2.6, },
					[5] = { 126, 138, 6, 6, spellLevel = 26, },
					[6] = { 174, 190, 6, 7, spellLevel = 32, },
					[7] = { 227, 247, 8, 8, spellLevel = 38, },
					[8] = { 292, 316, 9, 10, spellLevel = 44, },
					[9] = { 353, 383, 10, 11, spellLevel = 50, },
					[10] = { 429, 463, 11, 12, spellLevel = 56, },
					[11] = { 515, 555, 12, 13, spellLevel = 60, },
					[12] = { 536, 578, 12, 13, spellLevel = 63, },
					[13] = { 597, 643, 3, 4, spellLevel = 69, }, 
		},
		[GetSpellInfo(10)] = {
					["Name"] = "Blizzard",
					[0] = { School = "Frost", castTime = 8, bonusFactor = 1.14797, BaseIncrease = true, sTicks = 1, LevelIncrease = 7, },
					[1] = { 200, 200, 0, 8, spellLevel = 20, },
					[2] = { 352, 352, 8, 8, spellLevel = 28, },
					[3] = { 520, 520, 8, 8, spellLevel = 36, },
					[4] = { 720, 720, 8, 16, spellLevel = 44, },
					[5] = { 936, 936, 8, 16, spellLevel = 52, },
					[6] = { 1192, 1192, 16, 16, spellLevel = 60, },
					[7] = { 1472, 1472, 0, 8, spellLevel = 68, },
					--Check LevelIncrease
		},
		--Empiric tests suggests: 1.5/3.5 * 1/2 * 0.8
		[GetSpellInfo(120)] = {
					["Name"] = "Cone of Cold",
					[0] = { School = "Frost", canCrit = true, sFactor= 0.80 * 1/2, Cooldown = 10, BaseIncrease = true, LevelIncrease = 9, },
					[1] = { 98, 108, 4, 4, spellLevel = 26, },
					[2] = { 146, 160, 5, 5, spellLevel = 34, },
					[3] = { 203, 223, 6, 6, spellLevel = 42, },
					[4] = { 264, 290, 6, 7, spellLevel = 50, },
					[5] = { 335, 365, 7, 8, spellLevel = 58, },
					[6] = { 410, 448, 8, 9, spellLevel = 66, },
					--Check LevelIncrease
		},
		[GetSpellInfo(122)] = {
					["Name"] = "Frost Nova",
					[0] = { School = "Frost", canCrit = true, sFactor= 0.13 * 1/2, Cooldown = 25, BaseIncrease = true, LevelIncrease = 15, },
					[1] = { 19, 21, 2, 3,  spellLevel = 10, },
					[2] = { 33, 37, 2, 3,  spellLevel = 26, },
					[3] = { 47, 53, 7, 8, spellLevel = 40, },
					[4] = { 71, 79, 2, 3, spellLevel = 54, },
					[5] = { 99, 111, 1, 2, spellLevel = 68, },
					--Check LevelIncrease
		},
		[GetSpellInfo(30455)] = {
					["Name"] = "Ice Lance",
					[0] = { School = "Frost", canCrit = true, sFactor = 1/3, BaseIncrease = true, },
					[1] = { 161, 187, 9, 13, spellLevel = 66, },
		},			
		[GetSpellInfo(11426)] = {
					["Name"] = "Ice Barrier",
					[0] = { School = "Frost", Cooldown = 10, bonusFactor = 0.3, NoSchoolTalents = true, NoDPS = true, NoDoom = true, Unresistable = true, NoAura = true, NoDPM = true, BaseIncrease = true, LevelIncrease = 5, },
					[1] = { 438, 438, 16, 16,  spellLevel = 40, },
					[2] = { 549, 549, 19, 19, spellLevel = 46, },
					[3] = { 678, 678, 21, 21, spellLevel = 52, },
					[4] = { 818, 818, 24, 24, spellLevel = 58, },
					[5] = { 925, 925, 26, 26, spellLevel = 64, },
					[6] = { 1075, 1075, 0, 0, spellLevel = 70, },
					--Check LevelIncrease
		},
		[GetSpellInfo(5143)] = {
					["Name"] = "Arcane Missiles",
					[0] = { School = "Arcane", canCrit = true, castTime = 5, sHits = 5, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 24, 24, 1, 2, spellLevel = 8, castTime = 3, sHits = 3, },
					[2] = { 36, 36, 1, 2, spellLevel = 16, castTime = 4, sHits = 4, },
					[3] = { 56, 56, 2, 2, spellLevel = 24, },
					[4] = { 83, 83, 2, 3, spellLevel = 32, },
					[5] = { 115, 115, 2, 3, spellLevel = 40, },
					[6] = { 151, 151, 3, 4, spellLevel = 48, },
					[7] = { 192, 192, 3, 4, spellLevel = 56, },
					[8] = { 230, 230, 4, 4, spellLevel = 60, },
					[9] = { 240, 240, 3, 4, spellLevel = 63, },
					[10] = { 263, 264, 4, 5, spellLevel = 69, }, --Blizzard tooltip reports wrong basedamage (real is +3,4)
					[11] = { 280, 280, 0, 0, spellLevel = 70, },
		},
		[GetSpellInfo(1449)] = {
					["Name"] = "Arcane Explosion",
					[0] = { School = "Arcane", canCrit = true, sFactor = 1/2, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 32, 36, 2, 2,  spellLevel = 14, },
					[2] = { 57, 63, 3, 3, spellLevel = 22, },
					[3] = { 97, 105, 4, 5, spellLevel = 30, },
					[4] = { 139, 151, 4, 5, spellLevel = 38, },
					[5] = { 186, 202, 5, 6, spellLevel = 46, },
					[6] = { 243, 263, 6, 7, spellLevel = 54, },
					[7] = { 306, 330, 7, 8, spellLevel = 62, },
					[8] = { 377, 407, 0, 0, spellLevel = 70, },
					--Check LevelIncrease
		},
		[GetSpellInfo(30451)] = {
					["Name"] = "Arcane Blast",
					[0] = { School = "Arcane", canCrit = true, castTime = 2.5, BaseIncrease = true, },
					[1] = { 648, 752, 20, 20, spellLevel = 64, },
		},
		[GetSpellInfo(6143)] = {
					["Name"] = "Frost Ward",
					[0] = { School = "Frost", bonusFactor = 0.30, NoSchoolTalents= true, NoDPS = true, NoTooltip = true, NoAura = true, Unresistable = true, },
					[1] = { 165, 165, spellLevel = 22, },
					[2] = { 290, 290, spellLevel = 32, },
					[3] = { 470, 470, spellLevel = 42, },
					[4] = { 675, 675, spellLevel = 52, },
					[5] = { 875, 875, spellLevel = 60, },
					[6] = { 1125, 1125, spellLevel = 70, },
		},
		[GetSpellInfo(543)] = {
					["Name"] = "Fire Ward",
					[0] = { School = "Fire", bonusFactor = 0.30, NoSchoolTalents= true, NoDPS = true, NoTooltip = true, NoAura = true, Unresistable = true, },
					[1] = { 165, 165, spellLevel = 20, },
					[2] = { 290, 290, spellLevel = 30, },
					[3] = { 470, 470, spellLevel = 40, },
					[4] = { 675, 675, spellLevel = 50, },
					[5] = { 875, 875, spellLevel = 60, },
					[6] = { 1125, 1125, spellLevel = 69, },
		},		
		[GetSpellInfo(28880)] = {
					["Name"] = "Gift of the Naaru",
					[0] = { School = { "Holy", "Healing" }, Cooldown = 180, eDot = true, eDuration = 15, sTicks = 3, bonusFactor = 1, BaseIncrease = true, NoLowLevelPenalty = true, NoDownRank = true, },
					["None"] = { 50, 50, 1035, 1035, spellLevel = 1, },
		},
	}
	self.talentInfo = { 
		--ARCANE:
		--Arcane Instability
		--Spell Power
		--Arcane Focus
		--Arcane Impact
		--Empowered Arcane Missiles
		[GetSpellInfo(15058)] = { 	[1] = { Effect = 0.01, Spells = "All", }, },
		[GetSpellInfo(35578)] = { 	[1] = { Effect = 0.125, Spells = "All", ModType = "critM", }, },
		[GetSpellInfo(11222)] = { 	[1] = { Effect = 2, Spells = "Arcane", ModType = "hitPerc", }, },
		[GetSpellInfo(11242)] = {	[1] = { Effect = 2, Spells = { "Arcane Explosion", "Arcane Blast" }, ModType = "critPerc", }, },
		[GetSpellInfo(31579)] = { 	[1] = { Effect = 0.15, Spells = "Arcane Missiles", ModType = "SpellDamage", }, },
		--FIRE:
		--Master of Elements
		--Playing with Fire
		--Ignite
		--Fire Power
		--Empowered Fireball
		--Incineration
		--Improved Flamestrike
		--Improved Fire Blast
		[GetSpellInfo(29074)] = { 	[1] = { Effect = 0.1, Spells = "All", ModType = "freeCrit" }, },
		[GetSpellInfo(31638)] = { 	[1] = { Effect = 0.01, Spells = "All", }, },
		[GetSpellInfo(11119)] = { 	[1] = { Effect = 0.08, Spells = "Fire", ModType = "igniteM", }, },	
		[GetSpellInfo(11124)] = {	[1] = { Effect = 0.02, Spells = "Fire", }, },
		[GetSpellInfo(31656)] = { 	[1] = { Effect = 0.03, Spells = "Fireball", ModType = "SpellDamage", }, },
		[GetSpellInfo(18459)] = { 	[1] = { Effect = 2, Spells = { "Fire Blast", "Scorch", }, ModType = "critPerc", }, },
		[GetSpellInfo(11108)] = { 	[1] = { Effect = 5, Spells = "Flamestrike", ModType = "critPerc", }, },
		[GetSpellInfo(11078)] = { 	[1] = { Effect = -0.5, Spells = "Fire Blast", ModType = "cooldown", }, },
		--FROST:
		--Elemental Precision
		--Ice Shards
		--Shatter
		--Piercing Ice
		--Improved Cone of Cold
		--Empowered Frostbolt
		--Arctic Winds
		[GetSpellInfo(29438)] = { 	[1] = { Effect = 1, Spells = { "Frost", "Fire" }, ModType = "hitPerc" }, 
						[2] = { Effect = 1, Spells = "Frostbolt", ModType = "hitPerc" }, },
		[GetSpellInfo(11207)] = { 	[1] = { Effect = 0.10, Spells = "Frost", ModType = "critM", }, },
		[GetSpellInfo(11170)] = { 	[1] = { Effect = 1, Spells = "All", ModType = "Amount", Value = "Shatter" }, },
		[GetSpellInfo(11151)] = { 	[1] = { Effect = 0.02, Spells = "Frost", }, },
		[GetSpellInfo(11190)] = { 	[1] = { Effect = { 0.15, 0.25, 0.35, }, Spells = "Cone of Cold", }, },
		[GetSpellInfo(31682)] = { 	[1] = { Effect = 0.02, Spells = "Frostbolt", ModType = "SpellDamage", },
						[2] = { Effect = 1, Spells = "Frostbolt", ModType = "critPerc" }, 
		},
		[GetSpellInfo(31674)] = { 	[1] = { Effect = 0.01, Spells = "Frost", }, },
	}
end
