if select(2, UnitClass("player")) ~= "HUNTER" then return end
local GetSpellInfo = GetSpellInfo
local UnitCreatureType = UnitCreatureType
local IsEquippedItem = IsEquippedItem
local BR

function DrDamage:PlayerData()

	--General
	self.Calculation["HUNTER"] = function( calculation, ActiveAuras, BuffTalentRanks )
		if BuffTalentRanks["Rapid Killing"] and ActiveAuras["Rapid Killing"] then
			calculation.dmgM = calculation.dmgM * (1 + BuffTalentRanks["Rapid Killing"])
		end
	end
	self.Calculation["Monster Slaying"] = function( calculation, talentValue )
		local targetType = UnitCreatureType("target")
		
		if BR and targetType and BR:HasReverseTranslation( targetType ) then
			targetType = BR:GetReverseTranslation( targetType )
		end	
		
		if targetType == "Beast"
		or targetType == "Giant"
		or targetType == "Dragonkin" then
			calculation.dmgM = calculation.dmgM * (1 + talentValue)
			calculation.critM = calculation.critM * (1 + talentValue)
		end
	end
	self.Calculation["Humanoid Slaying"] = function( calculation, talentValue )
		local targetType = UnitCreatureType("target")
		
		if BR and targetType and BR:HasReverseTranslation( targetType ) then
			targetType = BR:GetReverseTranslation( targetType )
		end	
		
		if targetType == "Humanoid" then
			calculation.dmgM = calculation.dmgM * (1 + talentValue)
			calculation.critM = calculation.critM * (1 + talentValue)
		end
	end
	
	--Spell specific
	self.Calculation["Steady Shot"] = function( calculation, ActiveAuras, _, spell )
		local min, max = DrDamage:GetRangedBase()
		local spd = select(3,DrDamage:GetWeaponSpeed())
		if spd then
			calculation.minDam = calculation.minDam + min/spd * 2.8
			calculation.maxDam = calculation.maxDam + max/spd * 2.8
		end
		if ActiveAuras["Dazed"] then
			if spell.Daze then
				calculation.minDam = calculation.minDam + spell.Daze
				calculation.maxDam = calculation.maxDam + spell.Daze
			end
		end
	end
	self.Calculation["Aimed Shot"] = function( calculation )
		local spd = select(3,DrDamage:GetWeaponSpeed())
		if spd then
			calculation.cooldown = calculation.cooldown + spd
		end
	end
	self.Calculation["Multi-Shot"] = function( calculation )
		--Gladiator's Chain Gauntlets
		if IsEquippedItem( 28335 ) or IsEquippedItem( 31961 ) or IsEquippedItem( 33665 ) then
			calculation.dmgM = calculation.dmgM * 1.05
		end
	end
	
	--Set Bonuses
	self.SetBonuses["Rift Stalker Armor"] = { 30139, 30140, 30141, 30142, 30143 }
	self.SetBonuses["Gronnstalker's Armor"] = { 31001, 31003, 31004, 31005, 31006, 34443, 34549, 34570 }
	
	self.SetBonuses["Steady Shot"] = function( calculation )
		if self:GetSetAmount("Rift Stalker Armor") >= 4 then
			calculation.critPerc = calculation.critPerc + 5
		end
		if self:GetSetAmount( "Gronnstalker's Armor" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.1
		end		
	end
	
	--AURA
	--Rapid Killing
	--Dazed
	--Hunter's Mark
	self.PlayerAura[GetSpellInfo(35098)] = { ModType = "ActiveAura", ActiveAura = "Rapid Killing" }
	self.TargetAura[GetSpellInfo(1604)] = { ModType = "ActiveAura", Spell = GetSpellInfo(34120), ActiveAura = "Dazed" }
	self.TargetAura[GetSpellInfo(1130)] = { Value = { 20, 45, 75, 110 }, ModType = "Special" }
	
	local hmark = GetSpellInfo(1130)
	self.Calculation[hmark] = function( calculation, _, BuffTalentRanks, _, _, _, rank )
		rank = rank and tonumber(string.match(rank,"%d+")) or 4
		if calculation.actionSchool == "Ranged" then
			calculation.AP = calculation.AP + self.TargetAura[hmark].Value[rank]
		elseif BuffTalentRanks["Improved Hunter's Mark"] and calculation.actionSchool == "Physical" then
			calculation.AP = calculation.AP + self.TargetAura[hmark].Value[rank] * BuffTalentRanks["Improved Hunter's Mark"]
		end
	end	
	
	self.spellInfo = {
		[GetSpellInfo(75)] = {
			["Name"] = "Auto Shot",
			[0] = { School = "Ranged", WeaponDamage = 1, NoNormalization = true, AutoShot = true },
			["None"] = { 0 },
			[1] = { 0 },
		},
		[GetSpellInfo(3044)] = {
			["Name"] = "Arcane Shot",
			[0] = { School = { "Ranged", "Arcane" }, Cooldown = 6, APBonus = 0.15 },
			[1] = { 15 },
			[2] = { 23 },
			[3] = { 36 },
			[4] = { 65 },
			[5] = { 91 },
			[6] = { 125 },
			[7] = { 158 },
			[8] = { 200 },
			[9] = { 273 },
		},
		[GetSpellInfo(19434)] = {
			["Name"] = "Aimed Shot",
			[0] = { School = "Ranged", WeaponDamage = 1, Cooldown = 6 },
			[1] = { 70 },
			[2] = { 125 },
			[3] = { 200 },
			[4] = { 330 },
			[5] = { 460 },
			[6] = { 600 },
			[7] = { 870 },
		},
		[GetSpellInfo(2643)] = {
			["Name"] = "Multi-Shot",
			[0] = { School = "Ranged", WeaponDamage = 1, Cooldown = 10 },
			[1] = { 0 },
			[2] = { 40 },
			[3] = { 80 },
			[4] = { 120 },
			[5] = { 150 },
			[6] = { 205 },
		},
		[GetSpellInfo(19503)] = {
			["Name"] = "Scatter Shot",
			[0] = { School = "Ranged", WeaponDamage = 0.5, Cooldown = 30 },
			["None"] = { 0 },
			[1] = { 0 },
		},
		[GetSpellInfo(34490)] = {
			["Name"] = "Silencing Shot",
			[0] = { School = "Ranged", WeaponDamage = 0.5, Cooldown = 20 },
			["None"] = { 0 },
			[1] = { 0 },
		},
		[GetSpellInfo(34120)] = {
			["Name"] = "Steady Shot",
			[0] = { School = "Ranged", APBonus = 0.2, DPSrg = true },
			[1] = { 150, Daze = 175  },
		},
		[GetSpellInfo(1978)] = {
			["Name"] = "Serpent Sting",
			[0] = { School = { "Ranged", "Nature" }, APBonus = 0.1, NoCrits = true, eDuration = 15, Ticks = 3 },
			[1] = { 20 },
			[2] = { 40 },
			[3] = { 80 },
			[4] = { 140 },
			[5] = { 210 },
			[6] = { 290 },
			[7] = { 385 },
			[8] = { 490 },
			[9] = { 555 },
			[10] = { 660 },
		},
		[GetSpellInfo(13795)] = {
			["Name"] = "Immolation Trap",
			[0] = { School = { "Ranged", "Fire" }, Unresistable = true, APBonus = 0.1, NoCrits = true, eDuration = 15, Ticks = 3, Cooldown = 30, NoWeapon = true },
			[1] = { 105 },
			[2] = { 215 },
			[3] = { 340 },
			[4] = { 510 },
			[5] = { 690 },
			[6] = { 985 },
		},
		[GetSpellInfo(13813)] = {
			["Name"] = "Explosive Trap",
			[0] = { School = { "Ranged", "Fire" }, Unresistable = true, APBonus = 0.1, ExtraDamage = 0, E_eDuration = 20, NoCrits = true, Cooldown = 30, NoWeapon = true },
			[1] = { 100, 130, Extra = 150 },
			[2] = { 139, 187, Extra = 240 },
			[3] = { 201, 257, Extra = 330 },
			[4] = { 263, 337, Extra = 450 },
		},		
		[GetSpellInfo(19386)] = {
			["Name"] = "Wyvern Sting",
			[0] = { School = { "Ranged", "Nature" }, NoCrits = true, eDuration = 12 },
			[1] = { 300 },
			[2] = { 420 },
			[3] = { 600 },
			[4] = { 942 },
		},
		[GetSpellInfo(2973)] = {
			["Name"] = "Raptor Strike",
			[0] = { WeaponDamage = 1, Cooldown = 6, NextMelee = true, NoNormalization = true },
			[1] = { 5 },
			[2] = { 11 },
			[3] = { 21 },
			[4] = { 34 },
			[5] = { 50 },
			[6] = { 80 },
			[7] = { 110 },
			[8] = { 140 },
			[9] = { 170 },
		},
		[GetSpellInfo(2974)] = {
			["Name"] = "Wing Clip",
			[1] = { 5 },
			[2] = { 25 },
			[3] = { 50 },
		},
		[GetSpellInfo(1495)] = {
			["Name"] = "Mongoose Bite",
			[0] = { Cooldown = 5, APBonus = 0.2, NoWeapon = true },
			[1] = { 25 },
			[2] = { 45 },
			[3] = { 75 },
			[4] = { 115 },
			[5] = { 150 },
		},
		[GetSpellInfo(19306)] = {
			["Name"] = "Counterattack",
			[0] = { Cooldown = 5, NoWeapon = true },
			[1] = { 40 },
			[2] = { 70 },
			[3] = { 110 },
			[4] = { 165 },
		},
	}
	self.talentInfo = {
		--Marksmanship:
		--Improved Hunter's Mark
		--Improved Arcane Shot
		--Rapid Killing
		--Improved Stings
		--Mortal Shots
		--Barrage
		--Ranged Weapon Specialization
		--Improved Barrage
		[GetSpellInfo(19421)] = {	[1] = { Effect = 0.2, Spells = "Physical", ModType = "Amount", Value = "Improved Hunter's Mark" }, },
		[GetSpellInfo(19454)] = {	[1] = { Effect = -0.2, Spells = "Arcane Shot", ModType = "cooldown" }, },
		[GetSpellInfo(34948)] = {	[1] = { Effect = 0.1, Spells = { "Aimed Shot", "Arcane Shot", "Auto Shot" }, ModType = "Amount", Value = "Rapid Killing"  }, },
		[GetSpellInfo(19464)] = {	[1] = { Effect = 0.06, Spells = { "Serpent Sting", "Wyvern Sting" } }, },
		[GetSpellInfo(19485)] = {	[1] = { Effect = 0.06, Spells = "Ranged", ModType = "critM" }, },
		[GetSpellInfo(19461)] = {	[1] = { Effect = 0.04, Spells = { "Multi-Shot", "Volley" }, }, },
		[GetSpellInfo(19507)] = {	[1] = { Effect = 0.01, Spells = "Ranged" }, },
		[GetSpellInfo(35104)] = {	[1] = { Effect = 4, Spells = "Multi-Shot", ModType = "critPerc" }, },
		--Survival:
		--Monster Slaying
		--Humanoid Slaying
		--Savage Strikes
		--Surefooted
		--Clever Traps
		--Resourcefulness
		--Thrill of the Hunt
		--Expose Weakness
		[GetSpellInfo(24293)] = {	[1] = { Effect = 0.01, Spells = "All", ModType = "Monster Slaying" }, },
		[GetSpellInfo(19151)] = {	[1] = { Effect = 0.01, Spells = "All", ModType = "Humanoid Slaying" }, },
		[GetSpellInfo(19159)] = {	[1] = { Effect = 10, Spells = { "Raptor Strike", "Mongoose Bite" }, ModType = "critPerc" }, },
		[GetSpellInfo(19290)] = {	[1] = { Effect = 1, Spells = "All", ModType = "hitPerc" }, }, 
		[GetSpellInfo(19239)] = {	[1] = { Effect = 0.15, Spells = { "Explosive Trap", "Immolation Trap" }, }, },
		[GetSpellInfo(34491)] = {	[1] = { Effect = -2, Spells = { "Explosive Trap", "Immolation Trap" }, ModType = "cooldown" }, },
		[GetSpellInfo(34497)] = {	[1] = { Effect = { 0.132, 0.264, 0.4 }, ModType = "freeCrit" }, },
	--	[GetSpellInfo(34500)] = {	[1] = {  }, },
	}
end