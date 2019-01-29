if select(2, UnitClass("player")) ~= "WARRIOR" then return end
local GetSpellInfo = GetSpellInfo
local GetShieldBlock = GetShieldBlock
local UnitStat = UnitStat

function DrDamage:PlayerData()

	--Special calculation
	self.Calculation["One-Handed Weapon Specialization"] = function( calculation, value, baseAction )
		if (self:GetNormM() == 2.4 or self:GetNormM() == 1.7) and not baseAction.SpellCrit then
			calculation.wDmgM = calculation.wDmgM * (1 + value)
		end
	end	
	self.Calculation["Two-Handed Weapon Specialization"] = function( calculation, value, baseAction )
		if self:GetNormM() == 3.3 and not baseAction.SpellCrit then
			calculation.wDmgM = calculation.wDmgM * (1 + value)
		end
	end
	
	--General
	self.Calculation["WARRIOR"] = function( calculation, ActiveAuras, BuffTalentRanks )
		if BuffTalentRanks["Blood Frenzy"] and (ActiveAuras["Rend"] or ActiveAuras["Deep Wound"]) then
			calculation.dmgM = calculation.dmgM * ( 1 + BuffTalentRanks["Blood Frenzy"] ) 
		end
	end
	
	--Action specific
	self.Calculation["Thunder Clap"] = function( calculation, _, BuffTalentRanks )
		calculation.critM = 0.5 * (1 + (BuffTalentRanks["Impale"] or 0)) 
	end	
	self.Calculation["Heroic Strike"] = function( calculation, ActiveAuras, _, spell )
		if ActiveAuras["Dazed"] and spell.Daze then
			calculation.minDam = calculation.minDam + spell.Daze
			calculation.maxDam = calculation.maxDam + spell.Daze
		end
	end
	self.Calculation["Shield Slam"] = function( calculation )
		local bv = (GetShieldBlock() - UnitStat("player",1) * 0.05)
		calculation.minDam = calculation.minDam + bv 
		calculation.maxDam = calculation.maxDam + bv
	end
	
	--Set bonuses
	self.SetBonuses["Onslaught Armor"] = { 30970, 30974, 30976, 30978, 30980, 34442, 34547, 34568 }
	self.SetBonuses["Onslaught Battlegear"] = { 30969, 30972, 30975, 30977, 30979, 34441, 34546, 34569 }
	
	self.SetBonuses["Mortal Strike"] = function( calculation )
		if self:GetSetAmount("Onslaught Battlegear") >= 4 then
			calculation.dmgM = calculation.dmgM * 1.05
		end		
	end
	self.SetBonuses["Bloodthirst"] = self.SetBonuses["Mortal Strike"]
	self.SetBonuses["Shield Slam"] = function( calculation )
		if self:GetSetAmount("Onslaught Armor") >= 4 then
			calculation.dmgM = calculation.dmgM * 1.1
		end
	end

	--Auras
	--Revenge
	--Rend
	--Deep Wound
	--Dazed
	self.PlayerAura[GetSpellInfo(37517)] = { Value = 0.1 }
	self.TargetAura[GetSpellInfo(772)] = { ModType = "ActiveAura", ActiveAura = "Rend", SelfCast = true }
	self.TargetAura[GetSpellInfo(12721)] = { ModType = "ActiveAura", ActiveAura = "Deep Wound", SelfCast = true }
	self.TargetAura[GetSpellInfo(1604)] = { ModType = "ActiveAura", Spell = GetSpellInfo(78), ActiveAura = "Dazed" }

	self.spellInfo = {
		[GetSpellInfo(78)] = {
			["Name"] = "Heroic Strike",
			[0] = { Rage = 15, WeaponDamage = 1, NextMelee = true },
			[1] = { 11, },
			[2] = { 21, },
			[3] = { 32, },
			[4] = { 44, },
			[5] = { 58, },
			[6] = { 80, },
			[7] = { 111, },
			[8] = { 138, },
			[9] = { 157, },
			[10] = { 176, Daze = 61.6 },
			[11] = { 208, Daze = 72.8 },
		},
		[GetSpellInfo(772)] = {
			["Name"] = "Rend",
			[0] = { Rage = 15, WeaponDamage = 0.05201, NoCrits = true, eDuration = 21, NoNormalization = true },
			[1] = { 15, WeaponDamage = 0.02229, eDuration = 9, },
			[2] = { 28, WeaponDamage = 0.02972, eDuration = 12, },
			[3] = { 45, WeaponDamage = 0.03715, eDuration = 15, },
			[4] = { 66, WeaponDamage = 0.04458, eDuration = 18, },
			[5] = { 98,  },
			[6] = { 126, },
			[7] = { 147, },
			[8] = { 182, },
		},
		[GetSpellInfo(1715)] = {
			["Name"] = "Hamstring",
			[0] = { Rage = 10 },
			[1] = { 5 },
			[2] = { 18 },
			[3] = { 45 },
			[4] = { 63 },		
		},
		[GetSpellInfo(7384)] = {
			["Name"] = "Overpower",
			[0] = { Rage = 5, WeaponDamage = 1 },
			[1] = { 5 },
			[2] = { 15 },
			[3] = { 25 },
			[4] = { 35 },

		},
		[GetSpellInfo(72)] = {
			["Name"] = "Shield Bash",
			[0] = { Rage = 10, Offhand = "Shields" },
			[1] = { 6 },
			[2] = { 18 },
			[3] = { 45 },
			[4] = { 63 },

		},
		[GetSpellInfo(6572)] = {
			["Name"] = "Revenge",
			[0] = { Rage = 5, Cooldown = 5, },
			[1] = { 50, 60 },
			[2] = { 77, 93 },
			[3] = { 107, 129 },
			[4] = { 180, 220 },
			[5] = { 270, 330 },
			[6] = { 342, 418, },
			[7] = { 360, 440, },
			[8] = { 414, 506, },
		},
		[GetSpellInfo(694)] = {
			["Name"] = "Mocking Blow",
			[0] = { Rage = 10 },
			[1] = { 22 },
			[2] = { 31 },
			[3] = { 46 },
			[4] = { 71 },
			[5] = { 93 },
			[6] = { 114 },
		},
		[GetSpellInfo(6343)] = {
			["Name"] = "Thunder Clap",
			[0] = { Rage = 20, NoWeapon = true, SpellCrit = true },
			[1] = { 10 },
			[2] = { 23 },
			[3] = { 37 },
			[4] = { 55 },
			[5] = { 82 },
			[6] = { 103 },
			[7] = { 123 },
		},
		[GetSpellInfo(845)] = {
			["Name"] = "Cleave",
			[0] = { Rage = 20, WeaponDamage = 1, Hits = 2, NextMelee = true },
			[1] = { 5 },
			[2] = { 10 },
			[3] = { 18 },
			[4] = { 32 },
			[5] = { 50 },
			[6] = { 70 },
		},
		[GetSpellInfo(5308)] = {
			["Name"] = "Execute",
			[0] = { Rage = 15, },
			[1] = { 125, PowerBonus = 3 },
			[2] = { 200, PowerBonus = 6 },
			[3] = { 325, PowerBonus = 9 },
			[4] = { 450, PowerBonus = 12 },
			[5] = { 600, PowerBonus = 15 },
			[6] = { 750, PowerBonus = 18 },
			[7] = { 925, PowerBonus = 21 },
		},
		[GetSpellInfo(20252)] = {
			["Name"] = "Intercept",
			[0] = { Rage = 10, Cooldown = 30, NoWeapon = true },
			[1] = { 25 },
			[2] = { 45 },
			[3] = { 65 },
			[4] = { 85 },
			[5] = { 105 },
		},
		[GetSpellInfo(1464)] = {
			["Name"] = "Slam",
			[0] = { Rage = 15, WeaponDamage = 1, SpamDPS = 1.5, NoNormalization = true },
			[1] = { 32 },
			[2] = { 43 },
			[3] = { 68 },
			[4] = { 87 },
			[5] = { 105 },
			[6] = { 140 },
		},
		[GetSpellInfo(6552)] = {
			["Name"] = "Pummel",
			[0] = { Rage = 10, NoWeapon = true },
			[1] = { 20 },
			[2] = { 50 },
		},
		[GetSpellInfo(23881)] = {
			["Name"] = "Bloodthirst",
			[0] = { Rage = 30, APBonus = 45/100, NoWeapon = true },
			[1] = { 0 },
			[2] = { 0 },
			[3] = { 0 },
			[4] = { 0 },
			[5] = { 0 },
			[6] = { 0 },
		},
		[GetSpellInfo(12294)] = {
			["Name"] = "Mortal Strike",
			[0] = { Rage = 30, WeaponDamage = 1, Cooldown = 6 },
			[1] = { 85 },
			[2] = { 110 },
			[3] = { 135 },
			[4] = { 160 },
			[5] = { 185 },
			[6] = { 210 },

		},
		[GetSpellInfo(23922)] = {
			["Name"] = "Shield Slam",
			[0] = { Rage = 20, Offhand = "Shields" },
			[1] = { 225, 235, },
			[2] = { 264, 276, },
			[3] = { 303, 317, },
			[4] = { 342, 358, },
			[5] = { 381, 399, },
			[6] = { 420, 440, },
		},
		[GetSpellInfo(20243)] = {
			["Name"] = "Devastate",
			[0] = { Rage = 15, WeaponDamage = 0.5, },
			[1] = { 15 },
			[2] = { 25 },
			[3] = { 35 },
		},
		[GetSpellInfo(34428)] = {
			["Name"] = "Victory Rush",
			[0] = { Rage = 0, APBonus = 45/100, NoWeapon = true },
			[1] = { 0 },
		},
		[GetSpellInfo(1680)] = {
			["Name"] = "Whirlwind",
			[0] = { Rage = 25, WeaponDamage = 1, DualAttack = true, Cooldown = 10, Hits = 4 },
			["None"] = { 0 },
		},
	}
	self.talentInfo = {
		--Arms
		--Improved Rend
		--Improved Thunder Clap
		--Improved Overpower
		--Impale
		--Two-Handed Weapon Specialization
		--Improved Intercept
		--Blood Frenzy
		--Improved Mortal Strike
		[GetSpellInfo(12286)] = {	[1] = { Effect = 0.25, Spells = "Rend" }, },
		[GetSpellInfo(12287)] = {	[1] = { Effect = { 0.3, 0.7, 1.0 }, Spells = "Thunder Clap" },},
		[GetSpellInfo(12290)] = {	[1] = { Effect = 25, Spells = "Overpower", ModType = "critPerc" }, },
		[GetSpellInfo(16493)] = {	[1] = { Effect = 0.1, Spells = "All", ModType = "critM", Specials = true, }, 
						[2] = { Effect = 0.05, Spells = "Thunder Clap", ModType = "Amount", Value = "Impale" }, },
		[GetSpellInfo(12163)] = {	[1] = { Effect = 0.01, Spells = "All", ModType = "Two-Handed Weapon Specialization" }, },				
		[GetSpellInfo(29888)] = {	[1] = { Effect = -5, Spells = "Intercept", ModType = "cooldown" }, },
		[GetSpellInfo(29836)] = {	[1] = { Effect = 0.02, Spells = "All", ModType = "Amount", Value = "Blood Frenzy"  }, },
		[GetSpellInfo(35446)] = {	[1] = { Effect = 0.01, Spells = "Mortal Strike", }, 
						[2] = { Effect = -0.2, Spells = "Mortal Strike", ModType = "cooldown" }, },
		--Fury
		--Improved Cleave
		--Dual Wield Specialization
		--Precision
		--Improved Whirlwind
		[GetSpellInfo(12329)] = {	[1] = { Effect = 0.4, Spells = "Cleave", ModType = "bDmgM", Multiply = true }, },
		[GetSpellInfo(23584)] = {	[1] = { Effect = 0.05, Spells = "All", ModType = "offHdmgM", Multiply = true  }, NoManual = true },
		[GetSpellInfo(29590)] = {	[1] = { Effect = 1, Spells = "All", ModType = "hitPerc" }, },
		[GetSpellInfo(29721)] = {	[1] = { Effect = -1, Spells = "Whirlwind", ModType = "cooldown" }, },
		
		--Protection
		--One-Handed Weapon Specialization
		[GetSpellInfo(16538)] = {	[1] = { Effect = 0.02, Spells = "All", ModType = "One-Handed Weapon Specialization" }, },
	}
end