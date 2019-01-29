if select(2, UnitClass("player")) ~= "PRIEST" then return end
local GetSpellInfo = GetSpellInfo

--No baseincrease: Mind Flay, starshards, circle of healing, devouring plague, vampiric touch, SW: D, SW: P

function DrDamage:PlayerData()

	--Set bonuses
	
	--Sets
	self.SetBonuses["Hallowed Raiment"] = { 27536, 27775, 27875, 28230, 28413 }
	self.SetBonuses["Incarnate Regalia"] = { 29056, 29057, 29058, 29059, 29060 }
	self.SetBonuses["Incarnate Raiment"] = { 29049, 29050, 29053, 29054, 29055 }
	self.SetBonuses["Avatar Raiment"] = { 30150, 30151, 30152, 30153, 30154 }
	self.SetBonuses["Absolution Regalia"] = { 31061, 31064, 31065, 31067, 31070, 34434, 34528, 34563 }
	self.SetBonuses["Vestments of Absolution"] = { 31060, 31063, 31066, 31068, 31069, 34435, 34527, 34562 }
	
	--Effects
	self.SetBonuses["Prayer of Mending"] = function( calculation )
		if self:GetSetAmount( "Hallowed Raiment" ) >= 4 then
			calculation.finalMod = calculation.finalMod + 100
		end	
	end
	self.SetBonuses["Smite"] = function( calculation )
		if self:GetSetAmount( "Incarnate Regalia" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.05
		end
	end
	self.SetBonuses["Mind Flay"] = self.SetBonuses["Smite"]
	--[[self.SetBonuses["Prayer of Healing"] = function( calculation )
		if DrDamage:GetSetAmount( "Incarnate Raiment" ) >= 2 then
			2: Your Prayer of Healing spell now also causes an additional 150 healing over 9 seconds.
		end	
	end--]]
	self.SetBonuses["Renew"] = function( calculation )
		if self:GetSetAmount( "Avatar Raiment" ) >= 4 then
			calculation.eDuration = calculation.eDuration + 3
		end	
	end
	self.SetBonuses["Shadow Word: Pain"] = function( calculation )
		if self:GetSetAmount( "Absolution Regalia" ) >= 2 then
			calculation.eDuration = calculation.eDuration + 3
		end	
	end
	self.SetBonuses["Mind Blast"] = function( calculation )
		if self:GetSetAmount( "Absolution Regalia" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.1
		end	
	end
	self.SetBonuses["Greater Heal"] = function( calculation )
		if self:GetSetAmount( "Vestments of Absolution" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.05
		end	
	end	
	
	--Auras
	--Shadowform
	--Flexibility
	--Judgement of the Crusader
	self.PlayerAura[GetSpellInfo(15473)] = { School = "Shadow", Value = 0.15 }
	self.PlayerAura[GetSpellInfo(37565)] = { ModType = "Update", Spell = GetSpellInfo(2060) }
	self.TargetAura[GetSpellInfo(21183)] = { School = "Holy", ModType = "spellDmg", Ranks = 7, Value = { 20, 30, 50, 80, 110, 140, 190 }, }

	self.spellInfo = { 
		[GetSpellInfo(15407)] = {
					["Name"] = "Mind Flay",
					[0] = { School = "Shadow", castTime=3, sFactor = 0.665, sTicks = 1, },
					[1] = { 75, 75, spellLevel = 20, },
					[2] = { 126, 126, spellLevel = 28, },
					[3] = { 186, 186, spellLevel = 36, },
					[4] = { 261, 261, spellLevel = 44, },
					[5] = { 330, 330, spellLevel = 52, },
					[6] = { 426, 426, spellLevel = 60, },
					[7] = { 528, 528, spellLevel = 68, },
		},		
		[GetSpellInfo(2944)] = {
					["Name"] = "Devouring Plague",
					[0] = { School = "Shadow", eDot = true, eDuration = 24, sFactor = 0.5, Cooldown = 180, sTicks = 3, },
					[1] = { 152, 152, spellLevel = 20, },
					[2] = { 272, 272, spellLevel = 28, },
					[3] = { 400, 400, spellLevel = 36, },
					[4] = { 544, 544, spellLevel = 44, },
					[5] = { 712, 712, spellLevel = 52, },
					[6] = { 904, 904, spellLevel = 60, },
					[7] = { 1216, 1216, spellLevel = 68, },
		},
		[GetSpellInfo(589)] = {
					["Name"] = "Shadow Word: Pain",
					[0] = { School = "Shadow", eDot = true, eDuration = 18, bonusFactor = 1.2 * 0.915, sTicks = 3, NoDownRank = true },
					[1] = { 30, 30, spellLevel = 4, },
					[2] = { 66, 66, spellLevel = 10, },
					[3] = { 132, 132, spellLevel = 18, },
					[4] = { 234, 234, spellLevel = 26, },
					[5] = { 366, 366, spellLevel = 34, },
					[6] = { 510, 510, spellLevel = 42, },	
					[7] = { 672, 672, spellLevel = 50, },
					[8] = { 852, 852, spellLevel = 58, },
					[9] = { 1002, 1002, spellLevel = 65, },
					[10] = { 1236, 1236, spellLevel = 70, },
		},
		[GetSpellInfo(34914)] = {
					["Name"] = "Vampiric Touch",
					[0] = { School = "Shadow", eDot = true, eDuration = 15, sTicks = 3, },
					[1] = { 450, 450, spellLevel = 50, },
					[2] = { 600, 600, spellLevel = 60, },	
					[3] = { 650, 650, spellLevel = 70, },	
		},		
		[GetSpellInfo(32379)] = {
					["Name"] = "Shadow Word: Death",
					[0] = { School = "Shadow", canCrit = true, Cooldown = 12, },
					[1] = { 450, 522, spellLevel = 62, },
					[2] = { 572, 664, spellLevel = 70, },				
		},		
		[GetSpellInfo(8092)] = {
					["Name"] = "Mind Blast",
					[0] = { School = "Shadow", canCrit = true, Cooldown = 8, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 39, 43, 3, 3, spellLevel = 10, },
					[2] = { 72, 78, 4, 5, spellLevel = 16, },
					[3] = { 112, 120, 5, 6, spellLevel = 22, },
					[4] = { 167, 177, 7, 7, spellLevel = 28, },
					[5] = { 217, 231, 8, 8, spellLevel = 34, },
					[6] = { 279, 297, 9, 10, spellLevel = 40, },
					[7] = { 346, 366, 10, 11, spellLevel = 46, },
					[8] = { 425, 449, 12, 12, spellLevel = 52, },
					[9] = { 503, 531, 13, 13, spellLevel = 58, },
					[10] = { 557, 587, 14, 15, spellLevel = 63, },
					[11] = { 708, 748, 3, 4, spellLevel = 69, },
		},
		[GetSpellInfo(17)] = {
					["Name"] = "Power Word: Shield",
					[0] = { School = "Holy", Healing = true, bonusFactor = 0.3, Cooldown = 4, NoDPS = true, NoDebuffs = true, NoDoom = true, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 44, 44, 4, 4, spellLevel = 6, },
					[2] = { 88, 88, 6, 6, spellLevel = 12, },
					[3] = { 158, 158, 8, 8, spellLevel = 18, },
					[4] = { 234, 234, 10, 10, spellLevel = 24, },
					[5] = { 301, 301, 11, 11, spellLevel = 30, },
					[6] = { 381, 381, 13, 13, spellLevel = 36, },
					[7] = { 484, 484, 15, 15, spellLevel = 42, },
					[8] = { 605, 605, 17, 17, spellLevel = 48, },
					[9] = { 763, 763, 19, 19, spellLevel = 54, },
					[10] = { 942, 942, 21, 21, spellLevel = 60, },
					[11] = { 1125, 1125, 18, 18, spellLevel = 65, },
					[12] = { 1265, 1265, 0, 0, spellLevel = 70, },
		},
		[GetSpellInfo(2054)] = {
					["Name"] = "Heal",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 3, CastMod = 0.1, BaseIncrease = true,  LevelIncrease = 5 },
					[1] = { 295, 341, 12, 12, spellLevel = 16, },
					[2] = { 429, 491, 16, 16, spellLevel = 22, },
					[3] = { 566, 642, 20, 20, spellLevel = 28, },
					[4] = { 712, 804, 22, 23, spellLevel = 34, },
		},
		[GetSpellInfo(2050)] = {
					["Name"] = "Lesser Heal",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 2.5, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 46, 56, 1, 2, spellLevel = 1, castTime = 1.5, },
					[2] = { 71, 85, 5, 6, spellLevel = 4, castTime = 2, },
					[3] = { 135, 157, 8, 8, spellLevel = 10, },			
		},			
		[GetSpellInfo(2060)] = {
					["Name"] = "Greater Heal",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 3, CastMod = 0.1, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 899, 1013, 25, 26, spellLevel = 40, },
					[2] = { 1149, 1289, 29, 29, spellLevel = 46, },
					[3] = { 1437, 1609, 33, 33, spellLevel = 52, },
					[4] = { 1798, 2006, 37, 38, spellLevel = 58, },
					[5] = { 1966, 2194, 40, 41, spellLevel = 60, },
					[6] = { 2074, 2410, 33, 34, spellLevel = 63, },
					[7] = { 2396, 2784, 18, 19, spellLevel = 68, },				
		},
		[GetSpellInfo(596)] = {
					["Name"] = "Prayer of Healing",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 3, Healing = true, sFactor = 1/3 * 1.5, BaseIncrease = true, LevelIncrease = 9 },
					[1] = { 301, 321, 11, 12, spellLevel = 30, },
					[2] = { 444, 472, 14, 15, spellLevel = 40, },
					[3] = { 657, 695, 15, 18, spellLevel = 50, },
					[4] = { 939, 991, 14, 15, spellLevel = 60, },
					[5] = { 997, 1053, 22, 23, spellLevel = 60, },
					[6] = { 1246, 1316, 5, 6, spellLevel = 68, },
		},
		[GetSpellInfo(34861)] = {
					["Name"] = "Circle of Healing",
					[0] = { School = { "Holy", "Healing" }, sFactor = 1/3 * 1.5, },
					[1] = { 246, 270, spellLevel = 50, },
					[2] = { 288, 318, spellLevel = 56, },
					[3] = { 327, 361, spellLevel = 60, },
					[4] = { 370, 408, spellLevel = 65, },
					[5] = { 409, 451, spellLevel = 70, },
		},		
		[GetSpellInfo(2061)] = {
					["Name"] = "Flash Heal",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, BaseIncrease = true,  LevelIncrease = 5 },
					[1] = { 193, 237, 9, 10, spellLevel = 20, },
					[2] = { 258, 314, 11, 11, spellLevel = 26, },
					[3] = { 327, 393, 12, 13, spellLevel = 32, },
					[4] = { 400, 478, 14, 14, spellLevel = 38, },
					[5] = { 518, 616, 16, 17, spellLevel = 44, },
					[6] = { 644, 764, 18, 19, spellLevel = 52, },
					[7] = { 812, 958, 21, 21, spellLevel = 58, },
					[8] = { 913, 1059, 18, 19, spellLevel = 61, },
					[9] = { 1101, 1279, 15, 16, spellLevel = 67, },
		},
		[GetSpellInfo(13908)] = {
					--TODO: Get REAL baseincrease ranks 7-8
					["Name"] = "Desperate Prayer",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, NoDoom = true, BaseIncrease = true, LevelIncrease = 7 },
					[1] = { 134, 170, 14, 15, spellLevel = 10, },
					[2] = { 263, 325, 20, 21, spellLevel = 18, },
					[3] = { 447, 543, 27, 27, spellLevel = 26, },
					[4] = { 588, 708, 31, 32, spellLevel = 34, },
					[5] = { 834, 994, 38, 39, spellLevel = 42, },
					[6] = { 1101, 1305, 44, 45, spellLevel = 50, },
					[7] = { 1324, 1562, 50, 51, spellLevel = 58, },
					[8] = { 1601, 1887, 45, 46, spellLevel = 66, },
		},		
		[GetSpellInfo(139)] = {
					["Name"] = "Renew",
					[0] = { School = { "Holy", "Healing" }, eDot = true, eDuration = 15, sTicks = 3, },
					[1] = { 45, 45, spellLevel = 8, },
					[2] = { 100, 100, spellLevel = 14, },
					[3] = { 175, 175, spellLevel = 20, },
					[4] = { 245, 245, spellLevel = 26, },
					[5] = { 315, 315, spellLevel = 32, },
					[6] = { 400, 400, spellLevel = 38, },
					[7] = { 510, 510, spellLevel = 44, },
					[8] = { 650, 650, spellLevel = 50, },
					[9] = { 810, 810, spellLevel = 56, },
					[10] = { 970, 970, spellLevel = 60, },
					[11] = { 1010, 1010, spellLevel = 65, },
					[12] = { 1110, 1110, spellLevel = 70, },
		},
		[GetSpellInfo(32546)] = {
					["Name"] = "Binding Heal",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, BaseIncrease = true, --[[sHits = 2--]] },
					[1] = { 1042, 1338, 11, 12, spellLevel = 64, },
		},
		[GetSpellInfo(33076)] = {
					["Name"] = "Prayer of Mending",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, Cooldown = 10, sHits = 5, sFactor = 5, NoDPS = true },
					[1] = { 800, 800, spellLevel = 68, },
		},			
		[GetSpellInfo(585)] = {
					["Name"] = "Smite",
					[0] = { School = "Holy", canCrit = true, castTime=2.5, CastMod = 0.1, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 13, 17, 2, 3, spellLevel = 1, castTime = 1.5, },
					[2] = { 25, 31, 3, 3,  spellLevel = 6, castTime = 2.0, },
					[3] = { 54, 62, 4, 5, spellLevel = 14, },
					[4] = { 91, 105, 6, 7, spellLevel = 22, },
					[5] = { 150, 170, 8, 8, spellLevel = 30, },
					[6] = { 212, 240, 10, 10, spellLevel = 38, },
					[7] = { 287, 323, 12, 12, spellLevel = 46, },
					[8] = { 371, 415, 13, 14, spellLevel = 54, },
					[9] = { 405, 453, 17, 17, spellLevel = 61, },
					[10] = { 545, 611, 4, 5, spellLevel = 69, },					
		},
		[GetSpellInfo(14914)] = {
					["Name"] = "Holy Fire",
					[0] = { School = "Holy", canCrit = true, castTime=3.5, eDuration = 10, sTicks = 2, CastMod = 0.1, hybridFactor = 0.8571, hybridDotFactor = 1.7495, BaseIncrease = true,  LevelIncrease = 6 },
					[1] = { 78, 98, 6, 6, hybridDotDmg= 30, spellLevel = 20, },
					[2] = { 96, 120, 10, 11, hybridDotDmg= 40, spellLevel = 24, },
					[3] = { 132, 166, 12, 12, hybridDotDmg= 55, spellLevel = 30, },
					[4] = { 165, 209, 13, 14, hybridDotDmg= 65, spellLevel = 36, },
					[5] = { 204, 258, 15, 15, hybridDotDmg= 85, spellLevel = 42, },
					[6] = { 254, 322, 17, 18, hybridDotDmg= 100, spellLevel = 48, },
					[7] = { 304, 386, 19, 20, hybridDotDmg= 125, spellLevel = 54, },
					[8] = { 355, 449, 20, 21, hybridDotDmg= 145, spellLevel = 60, },
					[9] = { 412, 522, 14, 15, hybridDotDmg= 165, spellLevel = 66, },					
		},
		[GetSpellInfo(15237)] = {
					["Name"] = "Holy Nova",
					[0] = { School = "Holy", canCrit = true, bonusFactor = 0.163, BaseIncrease = true, LevelIncrease = 7 },
					[1] = { 28, 32, 1, 2, spellLevel = 20, },
					[2] = { 50, 58, 2, 3, spellLevel = 28, },
					[3] = { 76, 88, 3, 4, spellLevel = 36, },
					[4] = { 106, 123, 4, 4, spellLevel = 44, },
					[5] = { 140, 163, 6, 5, spellLevel = 52, },
					[6] = { 181, 210, 7, 7, spellLevel = 60, },
					[7] = { 242, 280, 2, 3, spellLevel = 68, },
			["Secondary"] = {
					["Name"] = "Holy Nova",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, bonusFactor = 0.163, BaseIncrease = true, LevelIncrease = 7 },
					[1] = { 52, 60, 2, 3, spellLevel = 20, },
					[2] = { 86, 98, 3, 3, spellLevel = 28, },
					[3] = { 121, 139, 3, 4, spellLevel = 36, },
					[4] = { 161, 188, 4, 4, spellLevel = 44, },
					[5] = { 235, 272, 4, 4, spellLevel = 52, },
					[6] = { 302, 350, 5, 6, spellLevel = 60, },
					[7] = { 384, 446, 2, 2, spellLevel = 68, },
			}
		},
		[GetSpellInfo(10797)] = {
					["Name"] = "Starshards",
					[0] = { School = "Arcane", eDuration = 15, eDot = true, sTicks = 3 },
					[1] = { 60, 60, spellLevel = 10, },
					[2] = { 115, 115, spellLevel = 18, },
					[3] = { 200, 200, spellLevel = 26, },
					[4] = { 290, 290, spellLevel = 34, },
					[5] = { 395, 395, spellLevel = 42, },
					[6] = { 525, 525, spellLevel = 50, },
					[7] = { 650, 650, spellLevel = 58, },
					[8] = { 785, 785, spellLevel = 66, },
		},
		[GetSpellInfo(28880)] = {
					["Name"] = "Gift of the Naaru",
					[0] = { School = { "Holy", "Healing" }, Cooldown = 180, eDot = true, eDuration = 15, sTicks = 3, bonusFactor = 1, BaseIncrease = true, NoLowLevelPenalty = true, NoDownRank = true, NoSchoolTalents = true, },
					["None"] = { 50, 50, 1035, 1035, spellLevel = 1, },
		},
		[GetSpellInfo(724)] = {
					["Name"] = "Lightwell",
					[0] = { School = "Holy", Healing = true, bonusFactor = 1, eDot = true, eDuration = 6, sTicks = 2, Stacks = 5 },
					[1] = { 801, 801, spellLevel = 40, },
					[2] = { 1164, 1164, spellLevel = 50, },
					[3] = { 1599, 1599, spellLevel = 60, },
					[4] = { 2361, 2361, spellLevel = 70, },					
		},
		--Base increase?
		[GetSpellInfo(44041)] = {
					["Name"] = "Chastise",
					[0] = { School = "Holy", canCrit = true, bonusFactor = 0.14217, Cooldown = 30, NoDownRank = true, },
					[1] = { 47, 53, spellLevel = 20, },
					[2] = { 93, 107, spellLevel = 30, },
					[3] = { 139, 161, spellLevel = 40, },
					[4] = { 209, 241, spellLevel = 50, },
					[5] = { 278, 322, spellLevel = 60, },
					[6] = { 370, 430, spellLevel = 70, },				
		},		
	}
	self.talentInfo = { 
		--SHADOW:
		--Shadow Focus
		--Darkness
		--Improved Shadow Word: Pain
		--Shadow Power
		--Improved Mind Blast
		[GetSpellInfo(15260)] = { 	[1] = { Effect = 2, Spells = "Shadow", ModType = "hitPerc" }, },
		[GetSpellInfo(15259)] = { 	[1] = { Effect = 0.02, Spells = "Shadow" }, },
		[GetSpellInfo(15275)] = { 	[1] = { Effect = 3, Spells = "Shadow Word: Pain", ModType = "eDuration", }, },
		[GetSpellInfo(33221)] = { 	[1] = { Effect = 3, Spells = { "Mind Blast", "Shadow Word: Death" }, ModType = "critPerc", }, },
		[GetSpellInfo(15273)] = { 	[1] = { Effect = -0.5, Spells = "Mind Blast", ModType = "cooldown" }, },
		--HOLY:
		--Improved Renew
		--Searing Light
		--Spiritual Healing
		--Empowered Healing
		[GetSpellInfo(14908)] = { 	[1] = { Effect = 0.05, Spells = "Renew", }, },
		[GetSpellInfo(14909)] = { 	[1] = { Effect = 0.05, Spells = { "Smite", "Holy Fire" }, }, },
		[GetSpellInfo(14898)] = {	[1] = { Effect = 0.02, Spells = "Healing", }, },
		[GetSpellInfo(33158)] = { 	[1] = { Effect = 0.04, Spells = "Greater Heal", ModType = "SpellDamage", },
						[2] = { Effect = 0.02, Spells = { "Flash Heal", "Binding Heal" }, ModType = "SpellDamage", },
		},
		--DISCIPLINE:
		--Improved Power Word: Shield
		--Force of Will
		[GetSpellInfo(14748)] = { 	[1] = { Effect = 0.05, Spells = "Power Word: Shield", }, },
		[GetSpellInfo(18544)] = { 	[1] = { Effect = 1, Spells = { "Smite", "Holy Fire", "Mind Blast", "Shadow Word: Death", }, ModType = "critPerc", }, 
						[2] = { Effect =  0.01, Spells = { "Smite", "Holy Fire", "Starshards", "Shadow", }, },
		},					
	}
end