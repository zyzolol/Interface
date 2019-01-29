if select(2, UnitClass("player")) ~= "WARLOCK" then return end
local GT = LibStub:GetLibrary("LibGratuity-3.0")
local GetSpellInfo = GetSpellInfo
local GetPlayerBuffName = GetPlayerBuffName

--Downranking exceptions: Death Coil, Siphon life, Searing Pain, Hellfire
--Untested assumed normal: UA, Conflagrate, Shadowfury
--No downranking: Lifetap, Drain soul, CoA

function DrDamage:PlayerData()

	--Spell specific
	self.Calculation["Drain Life"] = function( calculation, ActiveAuras, BuffTalentRanks )
		if ActiveAuras["Soul Siphon"] and BuffTalentRanks["Soul Siphon"] then
			local SSBonus = 0
			if BuffTalentRanks["Soul Siphon"] == 1 then
				SSBonus = ActiveAuras["Soul Siphon"] * 0.02
				if SSBonus > 0.24 then SSBonus = 0.24 end
			elseif BuffTalentRanks["Soul Siphon"] == 2 then
				SSBonus = ActiveAuras["Soul Siphon"] * 0.04
				if SSBonus > 0.60 then SSBonus = 0.60 end
			end
			calculation.dmgM = calculation.dmgM * ( 1 + SSBonus )	
		end
	end
	self.Calculation["Incinerate"] = function( calculation, ActiveAuras, _, spell )
		if ActiveAuras["Immolate"] then
			calculation.minDam = calculation.minDam + spell.incinerateMin
			calculation.maxDam = calculation.maxDam + spell.incinerateMax
		end
	end
	
	--Set bonuses
	--Sets
	self.SetBonuses["Oblivion Raiment"] = { 27537, 27778, 27948, 28232, 28415 }
	self.SetBonuses["Voidheart Raiment"] = { 28963, 28964, 28966, 28967, 28968 }
	self.SetBonuses["Corruptor Raiment"] = { 30211, 30212, 30213, 30214, 30215 }
	self.SetBonuses["Plagueheart Raiment"] = { 22504, 22505, 22506, 22507, 22508, 22509, 22510, 22511, 23063 }
	self.SetBonuses["Malefic Raiment"] = { 31050, 31051, 31052, 31053, 31054, 34436, 34541, 34564 }
	
	--Effects
	self.SetBonuses["Seed of Corruption"] = function( calculation )
		if self:GetSetAmount( "Oblivion Raiment" ) >= 4 then
			calculation.finalMod = calculation.finalMod + 180
		end
	end	
	self.SetBonuses["Corruption"] = function( calculation )
		if self:GetSetAmount( "Voidheart Raiment" ) >= 4 then			
			calculation.eDuration = calculation.eDuration + 3
		end
		if self:GetSetAmount( "Plagueheart Raiment" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.12
		end		
	end
	self.SetBonuses["Immolate"] = function( calculation )
		if self:GetSetAmount( "Voidheart Raiment" ) >= 4 then			
			calculation.eDuration = calculation.eDuration + 3
		end
	end
	self.SetBonuses["Shadow Bolt"] = function( calculation )
		if self:GetSetAmount( "Malefic Raiment" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.06
		end		
	end
	self.SetBonuses["Incinerate"] = function( calculation )
		if self:GetSetAmount( "Malefic Raiment" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.06
		end		
	end

	--AURA
	--Fel Armor
	--Touch of Shadow
	--Burning Wish
	--Amplify Curse
	self.PlayerAura[GetSpellInfo(28176)] = { ModType = "Special" }	
	self.PlayerAura[GetSpellInfo(18791)] = { School = "Shadow", ModType = "Special" }
	self.PlayerAura[GetSpellInfo(18789)] = { School = "Fire", Value = 0.15 }
	self.PlayerAura[GetSpellInfo(18288)] = { Value = 0.5, ModType = "bDmgM", Spell = { GetSpellInfo(980), GetSpellInfo(603) }, }
	--Immolate
	self.TargetAura[GetSpellInfo(348)] = { Spell = GetSpellInfo(29722), ModType = "ActiveAura", ActiveAura = "Immolate", }
	--Corruption
	--Death Coil
	--Curse of Agony
	--Curse of Doom
	--Curse of Recklessness
	--Curse of Weakness
	--Curse of Tongues
	--Curse of Exhaustion
	--Fear
	--Drain Soul
	--Drain Mana
	--Siphon Life
	--Unstable Affliction
	--Seed of Corruption
	--Shadow Embrace
	--Howl of Terror
	self.TargetAura[GetSpellInfo(172)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(6789)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(980)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(603)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(704)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(702)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(1714)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(18223)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(5782)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(1120)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(5138)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(18265)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(30108)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(27243)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(32385)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	self.TargetAura[GetSpellInfo(5484)] = 	{ ActiveAura = "Soul Siphon", Spell = GetSpellInfo(689), ModType = "ActiveAura" }
	
	local felarmor = GetSpellInfo(28176)
	self.Calculation[GetSpellInfo(28176)] = function( calculation, _, BuffTalentRanks )
		calculation.leechBonus = calculation.leechBonus  * (1.2 + 0.02 * (BuffTalentRanks["Demonic Aegis"] or 0))
		if not GetPlayerBuffName(felarmor) then
			calculation.spellDmg = calculation.spellDmg + 100 * (1 + 0.1 * (BuffTalentRanks["Demonic Aegis"] or 0))
		end
	end
	self.Calculation[GetSpellInfo(18791)] = function( calculation, _, _, index )
		local _, amount
		if index then
			GT:SetUnitBuff( "player", index )
			_, _, amount = GT:Find("(%d+)%%")
		end
		if amount and tonumber(amount) == 10 then
			calculation.dmgM = calculation.dmgM * 1.1
		else
			calculation.dmgM = calculation.dmgM * 1.15
		end
	end

	self.spellInfo = {
		[GetSpellInfo(172)] = {
					["Name"] = "Corruption",
					[0] = { School = { "Shadow", "Affliction", }, bonusFactor = 0.93, castTime = 2, eDot = true, eDuration = 18, sTicks = 3, CastMod = 0.1, },
					[1] = { 40, 40, spellLevel = 4, eDuration = 12, Downrank = -1, },
					[2] = { 90, 90, spellLevel = 14, eDuration = 15, },
					[3] = { 222, 222, spellLevel = 24, },
					[4] = { 324, 324, spellLevel = 34, },
					[5] = { 486, 486, spellLevel = 44, }, 
					[6] = { 666, 666, spellLevel = 54, },
					[7] = { 822, 822, spellLevel = 60, },
					[8] = { 906, 906, spellLevel = 65, },
		},
		[GetSpellInfo(686)] = {
					["Name"] = "Shadow Bolt",
					[0] = { School = { "Shadow", "Destruction" }, castTime = 3, canCrit = true, CastMod = 0.1, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 12, 16, 1, 2, spellLevel = 1, castTime = 1.7, Downrank = -1, },
					[2] = { 23, 29, 3, 4, spellLevel = 6, castTime = 2.2, },
					[3] = { 48, 56, 4, 5, spellLevel = 12, castTime = 2.8, },
					[4] = { 86, 98, 6, 6, spellLevel = 20, },
					[5] = { 142, 162, 8, 8, spellLevel = 28, },
					[6] = { 204, 230, 9, 10, spellLevel = 36, },
					[7] = { 281, 315, 11, 12, spellLevel = 44, },
					[8] = { 360, 402, 13, 13, spellLevel = 52, }, 
					[9] = { 455, 507, 15, 15, spellLevel = 60, },
					[10] ={ 482, 538, 15, 16, spellLevel = 60, },
					[11] ={ 541, 603, 3, 4, spellLevel = 69, },
		},
		[GetSpellInfo(1454)] = {
					["Name"] = "Life Tap",
					[0] = { School = { "Shadow", "Affliction", }, bonusFactor = 0.8, NoSchoolTalents= true, NoDPS = true, NoTooltip = true, NoAura = true, Unresistable = true, BaseIncrease = true, NoDownRank = true, LevelIncrease = 10 },
					[1] = { 20, 20, 10, 10, spellLevel = 6, },
					[2] = { 65, 65, 10, 10, spellLevel = 16, },
					[3] = { 130, 130, 10, 10, spellLevel = 26, },
					[4] = { 210, 210, 10, 10, spellLevel = 36, },
					[5] = { 300, 300, 10, 10, spellLevel = 46, },
					[6] = { 420, 420, 10, 10, spellLevel = 56, },
					[7] = { 580, 580, 2, 2, spellLevel = 66, },
		},
		[GetSpellInfo(6229)] = {
					["Name"] = "Shadow Ward",
					[0] = { School = "Shadow", bonusFactor = 0.30, NoSchoolTalents= true, NoDPS = true, NoTooltip = true, NoAura = true, Unresistable = true, NoDownRank = true },
					[1] = { 290, 290, spellLevel = 32, },
					[2] = { 470, 470, spellLevel = 42, },
					[3] = { 675, 675, spellLevel = 52, },
					[4] = { 875, 875, spellLevel = 60, },
		},		
		[GetSpellInfo(18220)] = {
					["Name"] = "Dark Pact",
					[0] = { School = { "Shadow", "Affliction", }, bonusFactor = 0.96, NoSchoolTalents= true, NoDPS = true, NoTooltip = true, NoAura = true, Unresistable = true, NoDownRank = true, },
					[1] = { 305, 305, spellLevel = 40, },
					[2] = { 440, 440, spellLevel = 50, },
					[3] = { 545, 545, spellLevel = 60, },
					[4] = { 700, 700, spellLevel = 70, },
		},			
		[GetSpellInfo(980)] = {
					["Name"] = "Curse of Agony",
					[0] = { School = { "Shadow", "Affliction", }, bonusFactor = 1.20, eDot = true, eDuration = 24, NoDownRank = true, },
					[1] = { 84, 84, spellLevel = 8,  },
					[2] = { 180, 180, spellLevel = 18, },
					[3] = { 324, 324, spellLevel = 28, }, 
					[4] = { 504, 504, spellLevel = 38, }, 
					[5] = { 780, 780, spellLevel = 48, }, 
					[6] = { 1044, 1044, spellLevel = 58, },
					[7] = { 1356, 1356, spellLevel = 67, }, 
		},
		[GetSpellInfo(603)] = {
					["Name"] = "Curse of Doom",
					[0] = { School = { "Shadow", "Affliction", }, sFactor = 0.5, NoSchoolTalents = true, eDot = true, eDuration = 60, },
					[1] = { 3200, 3200, spellLevel = 60, },
					[2] = { 4200, 4200, spellLevel = 70, },
		},
		[GetSpellInfo(6789)] = {
					["Name"] = "Death Coil",
					[0] = { School = { "Shadow", "Affliction", }, sFactor = 0.5, Cooldown = 120, Leech = true, NoDoom = true, BaseIncrease = true, LevelIncrease = 7, Downrank = 1 },
					[1] = { 244, 244, 13, 13, spellLevel = 42, },
					[2] = { 319, 319, 15, 15, spellLevel = 50, }, 
					[3] = { 400, 400, 18, 18, spellLevel = 58, },
					[4] = { 519, 519, 6, 7, spellLevel = 68, },
					--Note: Downrank: +1 -> exception
					--Check LevelIncrease
		},
		[GetSpellInfo(689)] = {
					["Name"] = "Drain Life",
					[0] = { School = { "Shadow", "Affliction", }, castTime=5, Leech = true, sHits = 5, sFactor = 0.5, },
					[1] = { 10, 10, spellLevel = 14, },
					[2] = { 17, 17, spellLevel = 22, },
					[3] = { 29, 29, spellLevel = 30, },
					[4] = { 41, 41, spellLevel = 38, },
					[5] = { 55, 55, spellLevel = 46, },
					[6] = { 71, 71, spellLevel = 54, },
					[7] = { 87, 87, spellLevel = 62, },
					[8] = { 108, 108, spellLevel = 69, },
		},
		[GetSpellInfo(1120)] = {
					["Name"] = "Drain Soul",
					[0] = { School = { "Shadow", "Affliction", }, castTime=15, sFactor = 0.5, sTicks = 3, NoDownRank = true, },
					[1] = { 55, 55, spellLevel = 10, },
					[2] = { 155, 155, spellLevel = 24, },
					[3] = { 295, 295, spellLevel = 38, },
					[4] = { 455, 455, spellLevel = 52, },
					[5] = { 620, 620, spellLevel = 67, }, 
		},
		[GetSpellInfo(18265)] = {
					["Name"] = "Siphon Life",
					[0] = { School = { "Shadow", "Affliction", }, sHits = 10, Leech = true, eDot = true, eDuration = 30, sFactor = 0.5, Downrank = 5 },
					[1] = { 15, 15, spellLevel = 30, Downrank = 3 },
					[2] = { 22, 22, spellLevel = 38, },
					[3] = { 33, 33, spellLevel = 48, },
					[4] = { 45, 45, spellLevel = 58, },
					[5] = { 52, 52, spellLevel = 63, },
					[6] = { 63, 63, spellLevel = 70, },
					--Note: Downranking +3/5, why?
		},
		[GetSpellInfo(5676)] = {
					["Name"] = "Searing Pain",
					[0] = { School = { "Fire", "Destruction" }, canCrit = true, BaseIncrease = true, LevelIncrease = 7, Downrank = 1 },
					[1] = { 34, 42, 4, 5, spellLevel = 18, },
					[2] = { 59, 71, 6, 6, spellLevel = 26, },
					[3] = { 86, 104, 7, 8, spellLevel = 34, },
					[4] = { 122, 146, 9, 9, spellLevel = 42, },
					[5] = { 158, 188, 10, 10, spellLevel = 50, },
					[6] = { 204, 240, 12, 12, spellLevel = 58, },
					[7] = { 243, 287, 9, 10, spellLevel = 65, },
					[8] = { 270, 320, 0, 0, spellLevel = 70, },
					--Note: Downranking +1 -> exception
					--Check LevelIncrease
		},
		[GetSpellInfo(6353)] = {
					["Name"] = "Soul Fire",
					[0] = { School = { "Fire", "Destruction" }, bonusFactor = 1.15, castTime=6, canCrit = true, CastMod = 0.4, BaseIncrease = true, Cooldown = 60,  LevelIncrease = 7 },
					[1] = { 623, 783, 17, 18, spellLevel = 48, },
					[2] = { 703, 881, 18, 19, spellLevel = 56, },
					[3] = { 839, 1051, 14, 14, spellLevel = 64, },
					[4] = { 1003, 1257, 0, 0, spellLevel = 70, },
					--Check LevelIncrease
		},
		[GetSpellInfo(17877)] = {
					["Name"] = "Shadowburn",
					[0] = { School = { "Shadow", "Destruction" }, Cooldown = 15, canCrit = true, BaseIncrease = true,  LevelIncrease = 7 },
					[1] = { 87, 99, 4, 6, spellLevel = 20, },
					[2] = { 115, 131, 8, 9, spellLevel = 24, },
					[3] = { 186, 210, 10, 11, spellLevel = 32, },
					[4] = { 261, 293, 13, 14, spellLevel = 40, },
					[5] = { 350, 392, 15, 16, spellLevel = 48, },
					[6] = { 450, 502, 17, 19, spellLevel = 56, },
					[7] = { 518, 578, 20, 21, spellLevel = 63, },
					[8] = { 597, 665, 0, 0, spellLevel = 70, },
					--Check LevelIncrease
		},
		[GetSpellInfo(348)] = {
					["Name"] = "Immolate",
					[0] = { School = { "Fire", "Destruction" }, canCrit = true, castTime=2, CastMod = 0.1, hybridFactor = 0.349, eDuration = 15, sTicks = 3, BaseIncrease = true,  LevelIncrease = 5 },
					[1] = { 8, 8, 2, 2, hybridDotDmg = 20, spellLevel = 1, Downrank = -1 },
					[2] = {	19, 19, 4, 4, hybridDotDmg = 40, spellLevel = 10, }, 	 
					[3] = { 45, 45, 7, 7, hybridDotDmg = 90, spellLevel = 20, },	 
					[4] = { 90, 90, 10, 10, hybridDotDmg = 165, spellLevel = 30, }, 
					[5] = { 134, 134, 13, 13, hybridDotDmg = 255, spellLevel = 40, },
					[6] = { 192, 192, 16, 16, hybridDotDmg = 365, spellLevel = 50, }, 
					[7] = { 258, 258, 19, 19, hybridDotDmg = 485, spellLevel = 60, },
					[8] = { 279, 279, 19, 20, hybridDotDmg = 510, spellLevel = 60, },
					[9] = { 327, 327, 4, 5, hybridDotDmg = 615, spellLevel = 69, },
		},
		[GetSpellInfo(1949)] = {
					["Name"] = "Hellfire",
					[0] = { School = "Fire", castTime=15, sHits = 15, sFactor = 1/2, BaseIncrease = true, LevelIncrease = 11, Downrank = 5, },
					[1] = { 83, 83, 4, 4, spellLevel = 30, },
					[2] = { 139, 139, 5, 5, spellLevel = 42, },
					[3] = { 208, 208, 7, 7, spellLevel = 54, },
					[4] = { 306, 306, 1, 2, spellLevel = 68, },
					--Note: Downrank +5 -> exception
		},
		[GetSpellInfo(5740)] = {
					["Name"] = "Rain of Fire",
					[0] = { School = "Fire", castTime=8, bonusFactor = 1.1458, sTicks = 2, BaseIncrease = true, LevelIncrease = 11, },
					[1] = { 168, 168, 4, 8, spellLevel = 20, },
					[2] = { 384, 384, 8, 8, spellLevel = 34, },
					[3] = { 620, 620, 8, 12, spellLevel = 46, },
					[4] = { 904, 904, 12, 12, spellLevel = 58, },
					[5] = { 1212, 1212, 0, 4, spellLevel = 69, },
					--Check LevelIncrease
		},
		[GetSpellInfo(30108)] = {
					["Name"] = "Unstable Affliction",
					[0] = { School = { "Shadow", "Affliction", }, eDot = true, eDuration = 18, sTicks = 3, },
					[1] = { 660, 660, spellLevel = 50, },
					[2] = { 840, 840, spellLevel = 60, },
					[3] = { 1050, 1050, spellLevel = 70, },
		},
		[GetSpellInfo(17962)] = { 
					["Name"] = "Conflagrate",
					[0] = { School = { "Fire", "Destruction" }, canCrit = true, BaseIncrease = true, LevelIncrease = 5, },
					[1] = { 240, 306, 9, 10, spellLevel = 40, },
					[2] = { 316, 396, 10, 11, spellLevel = 48, },
					[3] = { 383, 479, 12, 12, spellLevel = 54, },
					[4] = { 447, 557, 8, 9, spellLevel = 60, },
					[5] = { 512, 638, 9, 10, spellLevel = 65, },
					[6] = { 579, 721, 0, 0, spellLevel = 70, },
		},
		[GetSpellInfo(27243)] = { 
					["Name"] = "Seed of Corruption",
					[0] = { School = { "Shadow", "Affliction", }, canCrit = true, sFactor = 1/2, eDuration = 18, hybridDotFactor = 2 * 1.25, sTicks = 3, },
					[1] = { 1110, 1290, hybridDotDmg=1044, spellLevel = 70, },
		},
		[GetSpellInfo(30283)] = { 
					["Name"] = "Shadowfury",
					[0] = { School = { "Shadow", "Destruction" }, canCrit = true, sFactor = 1/2 * 0.90, Cooldown = 20, BaseIncrease = true,  LevelIncrease = 9, },
					[1] = { 343, 407, 14, 15, spellLevel = 50, },
					[2] = { 459, 547, 17, 18, spellLevel = 60, },
					[3] = { 612, 728, 0, 0, spellLevel = 70, },
		},
		[GetSpellInfo(32231)] = { 
					["Name"] = "Incinerate",
					[0] = { School = { "Fire", "Destruction" }, canCrit = true, castTime = 2.5, BaseIncrease = true, LevelIncrease = 5, },
					[1] = { 403, 467, 13, 13, incinerateMin = 100, incinerateMax = 116, spellLevel = 64, },
					[2] = { 444, 514, 0, 0, incinerateMin = 111, incinerateMax = 128, spellLevel = 70, },
		},			
	}
	self.talentInfo = {
		--Affliction:
		--Shadow Mastery
		--Suppression
		--Soul Siphon
		--Improved Life Tap
		--Improved Curse of Agony
		--Empowered Corruption
		--Contagion
		[GetSpellInfo(18271)] = { 	[1] = { Effect = 0.02, Spells = "Shadow" }, },			
		[GetSpellInfo(18174)] = { 	[1] = { Effect = 2, Spells = "Affliction", ModType = "hitPerc", }, },
		[GetSpellInfo(17804)] = { 	[1] = { Effect = 1, Spells = "Drain Life", ModType = "Amount", Value = "Soul Siphon" }, },
		[GetSpellInfo(18182)] = { 	[1] = { Effect = 0.10, Spells = "Life Tap", }, },		
		[GetSpellInfo(18827)] = { 	[1] = { Effect = 0.05, Spells = "Curse of Agony", Add = true, }, },
		[GetSpellInfo(32381)] = { 	[1] = { Effect = 0.12, Spells = "Corruption", ModType = "SpellDamage", }, },
		[GetSpellInfo(30060)] = { 	[1] = { Effect = 0.01, Spells = { "Curse of Agony", "Corruption", "Seed of Corruption" }, Add = true, }, },
		--Demonology:
		--Demonic Aegis
		[GetSpellInfo(30143)] = { 	[1] = { Effect = 1, Spells = "All", ModType = "Amount", Value = "Demonic Aegis" }, },
		--Destruction:
		--Emberstorm
		--Improved Immolate
		--Shadow and Flame
		--Devastation
		--Improved Searing Pain
		--Ruin
		[GetSpellInfo(17954)] = { 	[1] = { Effect = 0.02, Spells = "Fire", Mod = { "Incinerate", 3, 16, "castTime", function(v,c,t) return (v*(1+0.02*c))/(1+0.02*t) end }, }, },
		[GetSpellInfo(17815)] = { 	[1] = { Effect = 0.05, Spells = "Immolate", ModType = "bNukeDmg" }, },
		[GetSpellInfo(30288)] = { 	[1] = { Effect = 0.04, Spells = { "Shadow Bolt", "Incinerate" }, ModType = "SpellDamage", }, },
		[GetSpellInfo(18130)] = { 	[1] = { Effect = 1, Spells = "Destruction", ModType = "critPerc", }, },
		[GetSpellInfo(17927)] = { 	[1] = { Effect = { 4, 7, 10, }, Spells = "Searing Pain", ModType = "critPerc", }, },
		[GetSpellInfo(17959)] = { 	[1] = { Effect = 0.5, Spells = "Destruction", ModType = "critM", }, },
	}
end