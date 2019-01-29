if select(2, UnitClass("player")) ~= "PALADIN" then return end
local GetPlayerBuffName = GetPlayerBuffName
local BR
local GetSpellInfo = GetSpellInfo
local IsEquippedItem = IsEquippedItem
local UnitCreatureType = UnitCreatureType
local UnitAttackSpeed = UnitAttackSpeed
local math_floor = math.floor
local string_match = string.match
local tonumber = tonumber
local select = select

--No base increase: Avenger's Shield, Holy Shield, Consecration, Holy Shock

function DrDamage:PlayerData()
	--Special calculation
	self.Calculation["Two-Handed Weapon Specialization"] = function( calculation, value )
		if self:GetNormM() == 3.3 then
			if calculation.wDmgM then
				calculation.wDmgM = calculation.wDmgM * (1 + value)
			else
				calculation.dmgM = calculation.dmgM * (1 + value)
			end
		end
	end	
	
	--General
	self.Calculation["PALADIN"] = function( calculation, ActiveAuras, BuffTalentRanks )
		if ActiveAuras["JotC"] then
			if IsEquippedItem( 23203 ) then						--Libram of Fervor
				ActiveAuras["JotC"] = ActiveAuras["JotC"] + 33
			elseif IsEquippedItem( 27983 ) or IsEquippedItem( 27949 ) then		--Libram of Zeal
				ActiveAuras["JotC"] = ActiveAuras["JotC"] + 48					
			end
			
			--Merciless Gladiator's Scaled Gauntlets
			if IsEquippedItem( 27880 ) or IsEquippedItem( 32040 ) then
				ActiveAuras["JotC"] = ActiveAuras["JotC"] + 20
			end
			
			if self:GetSetAmount( "Justicar Battlegear" ) >= 2 then
				ActiveAuras["JotC"] = ActiveAuras["JotC"] * 1.15
			end			

			if BuffTalentRanks["Improved Seal of the Crusader"] then
				calculation.critPerc = calculation.critPerc + BuffTalentRanks["Improved Seal of the Crusader"]
			end
			
			calculation.spellDmg = calculation.spellDmg + ActiveAuras["JotC"]		
		end
	end	
	self.Calculation["Crusade"] = function( calculation, talentValue )
		if not calculation.healingSpell then
			local targetType = UnitCreatureType("target")
			
			if BR and targetType and BR:HasReverseTranslation( targetType ) then
				targetType = BR:GetReverseTranslation( targetType )
			end	
			
			if targetType == "Undead"
			or targetType == "Demon"
			or targetType == "Humanoid"
			or targetType == "Elemental" then
				calculation.dmgM = calculation.dmgM * ( 1 + talentValue )
			end
		end
	end
	
	--Spell specific
	self.Calculation["Improved Holy Shield"] = function( calculation, talentValue )
		calculation.sHits = calculation.sHits + talentValue * 2
		calculation.spellDmgM = calculation.spellDmgM + talentValue * 0.1
		calculation.dmgM = calculation.dmgM * ( 1 + talentValue * 0.1 )
	end	
	self.Calculation["Holy Light"] = function( calculation, ActiveAuras )
		if ActiveAuras["BoL"] and IsEquippedItem( 28592 ) then --Libram of Souls Redeemed
			calculation.finalMod = calculation.finalMod + 120
		end
	end
	self.Calculation["Flash of Light"] = function( calculation, ActiveAuras )
		if ActiveAuras["BoL"] and IsEquippedItem( 28592 ) then --Libram of Souls Redeemed
			calculation.finalMod = calculation.finalMod + 60
		end
		--Gladiator's Flash of Light Bonus
		if self:GetSetAmount( "Gladiator's Gloves" ) >= 1 then
			calculation.critPerc = calculation.critPerc + 2
		end
	end
	self.Calculation["Crusader Strike"] = function( calculation )
		--Vengeful Gladiator's Scaled Gauntlets
		if IsEquippedItem( 33750 ) then
			calculation.dmgM = calculation.dmgM * 1.05
		end
	end	
	
	--Relic slot items
	self.RelicSlot["Consecration"] = { 27917, 47 }				--Libram of the Eternal Rest
	self.RelicSlot["Crusader Strike"] = { 31033, 36, }			--Libram of Righteous Power
	self.RelicSlot["Flash of Light"] = { 23006, 83, 25644, 79, 23201, 53, }	--Libram of Light, Blessed Book of Nagrand, Libram of Divinity	
	self.RelicSlot["Holy Light"] = { 28296, 87, }				--Libram of the Lightbringer
	self.RelicSlot["Judgement of Righteousness"] = { 33504, 94 }		--Libram of Divine Purpose
	self.RelicSlot["Exorcism"] = { 28065, 120 }				--Libram of Wracking
	self.RelicSlot["Holy Wrath"] = { 28065, 120 }				--Libram of Wracking
	
	--Set bonuses
	
	--Sets
	--Flash of Light
	self.SetBonuses["Gladiator's Gloves"] = { 27703, 31614, 31993, 32021, 33696, 33723 }
	self.SetBonuses["Gladiator's Redemption"] = { 31613, 31614, 31616, 31618, 31619, 32020, 32021, 32022, 32023, 32024, 33722, 33723, 33724, 33725, 33726 }
	self.SetBonuses["Justicar Armor"] = { 29066, 29067, 29068, 29069, 29070 }
	self.SetBonuses["Justicar Battlegear"] = { 29071, 29072, 29073, 29074, 29075 }
	self.SetBonuses["Lightbringer Armor"] = { 30985, 30987, 30991, 30995, 30998, 34433, 34488, 34560 }
	self.SetBonuses["Lightbringer Battlegear"] = { 30982, 30989, 30990, 30993, 30997, 34431, 34485, 34561 }
	self.SetBonuses["Lightbringer Raiment"] = { 30983, 30988, 30992, 30994, 30996, 34432, 34487, 34559 }
	
	--Effects
	self.SetBonuses["Seal of Blood"] = function( calculation )
		if self:GetSetAmount( "Justicar Armor" ) >= 2 then
			calculation.dmgM = calculation.dmgM * 1.1
		end	
	end
	self.SetBonuses["Seal of Vengeance"] = self.SetBonuses["Seal of Blood"]
	self.SetBonuses["Holy Shield"] = function( calculation )
		if self:GetSetAmount( "Justicar Armor" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.15
		end
	end
	self.SetBonuses["Holy Light"] = function( calculation )
		if self:GetSetAmount( "Lightbringer Raiment" ) >= 2 then
			calculation.critPerc = calculation.critPerc + 5
		end		
	end
	self.SetBonuses["Flash of Light"] = function( calculation )
		if self:GetSetAmount( "Lightbringer Raiment" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.05
		end		
	end	
	self.SetBonuses["Judgement of Command"] = function( calculation )
		if self:GetSetAmount( "Justicar Battlegear" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.1
		end
	end
	self.SetBonuses["Consecration"] = function( calculation )
		if self:GetSetAmount( "Lightbringer Armor" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.1
		end	
	end
	self.SetBonuses["Hammer of Wrath"] = function( calculation )
		if self:GetSetAmount( "Lightbringer Battlegear" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.1
		end	
	end
	self.SetBonuses["Holy Wrath"] = function( calculation )
		if calculation.healingSpell and self:GetSetAmount( "Gladiator's Redemption" ) >= 4 then
			calculation.dmgM = calculation.dmgM * 1.3
		end
	end
	
	--Seals and judgements
	self.Calculation["Seal of Blood"] = function( calculation, _, _, spell )
		local _, data = self:CasterCalc( "Judgement of Command", spell.Rank, true )
		local cspd = UnitAttackSpeed("player")
		calculation.dmgM = data.DmgM
		calculation.Hits = math_floor(30/cspd)
	end
	
	self.DmgCalculation["SoR Data"] = { 6, 5, 7, 10, 12, 13, 16, 15, 9 }
	self.DmgCalculation["SoR Data2"] = { 1, 10, 18, 26, 34, 42, 50, 58, 66 }
	self.DmgCalculation["Seal of Righteousness"] = function( calculation, _, _, spell )
		local spd = self:GetWeaponSpeed()
		local cspd = UnitAttackSpeed("player")
		local min, max = self:WeaponDamage(calculation, true)
		local _, data = self:CasterCalc( "Judgement of Righteousness", spell.Rank, true )
		
		--grr
		local rank = spell.Rank
		local bonus = self.DmgCalculation["SoR Data"][rank]
		local playerLevel = UnitLevel("player")
		
		if playerLevel < (self.DmgCalculation["SoR Data2"][rank] + 7) then
			bonus = ( bonus / 7 ) * (playerLevel - self.DmgCalculation["SoR Data2"][rank])
		end	
		
		local hS, hM, hA
		if self:GetNormM() == 3.3 then 
			hS = 0.108 * spd
			hM = 0.012
			hA = 1
		else
			hS = 0.092 * spd
			hM = 0.0085
			hA = -1
			bonus = bonus / 2
		end
		hS = hS * data.LvF
		calculation.minDam = hM * spd * spell.Multiplier + 0.015 * (min+max) + hS * (data.SpellDmg + calculation.spellDmg) + hA + bonus
		calculation.maxDam = calculation.minDam
		calculation.spellDmg = data.SpellDmg
		calculation.dmgM = data.DmgM
		calculation.Hits = math_floor(30/cspd)
		--calculation.hitPerc = data.HitRate
		
		if self:GetSetAmount( "Justicar Armor" ) >= 2 then
			calculation.dmgM = calculation.dmgM * 1.1
		end
	end
	self.DmgCalculation["Seal of Command"] = function( calculation, _, _, spell )
		local _, data = self:CasterCalc( "Judgement of Command", spell.Rank, true )
		local bonus = 0.29 * (data.SpellDmg - GetSpellBonusDamage(1)) + 0.2 * GetSpellBonusDamage(1)
		calculation.minDam = bonus + 0.29 * calculation.spellDmg
		calculation.maxDam = bonus + 0.29 * calculation.spellDmg
		calculation.spellDmg = bonus
		calculation.dmgM = data.DmgM
	end
	self.Calculation["Judgement of Vengeance"] = function( calculation, ActiveAuras )
		if ActiveAuras["Holy Vengeance"] then
			calculation.bDmgM = calculation.bDmgM + ( ActiveAuras["Holy Vengeance"] - 1 )
		end
	end		
	
	--AURA
	--Seal of Righteousness
	--Seal of Command
	--Seal of Blood
	--Seal of Vengeance
	--Light's Grace
	--Sanctity Aura
	--Divine Favor
	--Seal of the Crusader
	self.PlayerAura[GetSpellInfo(21084)] = { ModType = "Update" }
	self.PlayerAura[GetSpellInfo(20375)] = { ModType = "Update" }
	self.PlayerAura[GetSpellInfo(31892)] = { ModType = "Update" }
	self.PlayerAura[GetSpellInfo(31801)] = { ModType = "Update" }
	self.PlayerAura[GetSpellInfo(31834)] = { ModType = "Update", Spell = GetSpellInfo(635) }
	self.PlayerAura[GetSpellInfo(20218)] = { School = "Holy", Value = 0.1 }
	self.PlayerAura[GetSpellInfo(20216)] = { Spell = { GetSpellInfo(19750), GetSpellInfo(635), GetSpellInfo(20473), }, ModType = "critPerc", Value = 100, }
	self.PlayerAura[GetSpellInfo(27158)] = { Spell = GetSpellInfo(35395), Value = 0.4 }
	
	--Blessing of Light
	--Greater Blessing of Light
	--Holy Vengeance
	--Judgement of the Crusader
	self.TargetAura[GetSpellInfo(31803)] = { ModType = "ActiveAura", Spell = 20271, ActiveAura = "Holy Vengeance" }
	self.TargetAura[GetSpellInfo(21183)] = { ModType = "Special", School = { "Holy", "Physical" }, }
	self.TargetAura[GetSpellInfo(19977)] = { ModType = "Special", Spell = { GetSpellInfo(19750), GetSpellInfo(635) }, }
	self.TargetAura[GetSpellInfo(25890)] = { ModType = "Special", Spell = { GetSpellInfo(19750), GetSpellInfo(635) }, }	
	
	self.Calculation[GetSpellInfo(21183)] = function( calculation, ActiveAuras, _, _, _, _, rank )
		rank = rank and tonumber(string_match(rank,"%d+")) or 7
		ActiveAuras["JotC"] = select(rank, 23, 35, 58, 92, 127, 161, 219)
	end
	self.Calculation[GetSpellInfo(19977)] = function( calculation, ActiveAuras, _, _, _, _, rank )
		ActiveAuras["BoL"] = true
		rank = rank and tonumber(string_match(rank,"%d+")) or 4
		if calculation.spellName == "Flash of Light" then
			calculation.finalMod = calculation.finalMod + select(rank, 60, 85, 115, 185) * calculation.lowRankFactor * calculation.lowLevelFactor * calculation.dmgM
		elseif calculation.spellName == "Holy Light" then
			calculation.finalMod = calculation.finalMod + select(rank, 210, 300, 400, 580) * calculation.lowRankFactor * calculation.lowLevelFactor * calculation.dmgM
		end
	end
	self.Calculation[GetSpellInfo(25890)] = function( calculation, ActiveAuras, _, _, _, _, rank )
		ActiveAuras["BoL"] = true
		rank = rank and tonumber(string_match(rank,"%d+")) or 2
		if calculation.spellName == "Flash of Light" then
			calculation.finalMod = calculation.finalMod + select(rank, 115, 185) * calculation.lowRankFactor * calculation.lowLevelFactor * calculation.dmgM
		elseif calculation.spellName == "Holy Light" then
			calculation.finalMod = calculation.finalMod + select(rank, 400, 580) * calculation.lowRankFactor * calculation.lowLevelFactor * calculation.dmgM
		end
	end
	
	self.spellInfo = {
		[GetSpellInfo(31935)] = { 
					["Name"] = "Avenger's Shield",
					[0] = { School = { "Holy", "Physical" }, canCrit = true, castTime = 1, sFactor = 1/2, chainFactor = 1, Cooldown = 30, },
					[1] = { 270, 330, spellLevel = 50, },
					[2] = { 370, 452, spellLevel = 60, }, 
					[3] = { 494, 602, spellLevel = 70, }, 
		},
		[GetSpellInfo(2812)] = { 
					["Name"] = "Holy Wrath",
					[0] = { School = "Holy", canCrit = true, castTime = 2, sFactor = 1/2, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 362, 428, 6, 7, spellLevel = 50, },
					[2] = { 490, 576, 7, 8, spellLevel = 60, },
					[3] = { 635, 745, 2, 3, spellLevel = 69, },
		},
		[GetSpellInfo(20925)] = { 
					["Name"] = "Holy Shield",
					[0] = { School = "Holy", bonusFactor = 0.20, NoDPS = true, NoDoom = true, sHits = 4, },
					[1] = { 59, 59, spellLevel = 40, },
					[2] = { 86, 86, spellLevel = 50, },
					[3] = { 117, 117, spellLevel = 60, },
					[4] = { 155, 155, spellLevel = 70, },
		},
		[GetSpellInfo(635)] = { 
					["Name"] = "Holy Light",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 2.5, BaseIncrease = true, LevelIncrease = 5 }, --4?
					[1] = { 39, 47, 3, 4, spellLevel = 1, },
					[2] = { 76, 90, 5, 6, spellLevel = 6, },
					[3] = { 159, 187, 8, 9, spellLevel = 14, },
					[4] = { 310, 356, 12, 12, spellLevel = 22, },
					[5] = { 491, 553, 15, 16, spellLevel = 30, },
					[6] = { 698, 780, 19, 19, spellLevel = 38, },
					[7] = { 945, 1053, 23, 23, spellLevel = 46, },
					[8] = { 1246, 1388, 26, 26, spellLevel = 54, },
					[9] = { 1590, 1770, 29, 29, spellLevel = 60, },
					[10] = { 1741, 1939, 32, 32, spellLevel = 62, },
					[11] = { 2196, 2446, 0, 0, spellLevel = 70, },
		},	
		[GetSpellInfo(24275)] = {
					["Name"] = "Hammer of Wrath",
					[0] = { School = { "Holy", "Physical" }, canCrit = true, Cooldown = 6, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 304, 336, 12, 12, spellLevel = 44, },
					[2] = { 399, 441, 13, 14, spellLevel = 52, },
					[3] = { 504, 556, 15, 16, spellLevel = 60, },
					[4] = { 665, 735, 7, 7, spellLevel = 68, }, --Check increase
		},
		[GetSpellInfo(879)] = {
					["Name"] = "Exorcism",
					[0] = { School = "Holy", canCrit = true, Cooldown = 15, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 84, 96, 6, 6, spellLevel = 20, },
					[2] = { 152, 172, 8, 8, spellLevel = 28, },
					[3] = { 217, 245, 10, 10, spellLevel = 36, },
					[4] = { 304, 342, 12, 12, spellLevel = 44, },
					[5] = { 393, 439, 14, 14, spellLevel = 52, },
					[6] = { 505, 563, 16, 16, spellLevel = 60, },
					[7] = { 619, 691, 7, 7, spellLevel = 68, },
		},
		[GetSpellInfo(26573)] = {
					["Name"] = "Consecration",
					[0] = { School = "Holy", castTime = 8, sFactor = 1/2.4, sTicks = 1, },
					[1] = { 64, 64, spellLevel = 20, },
					[2] = { 120, 120, spellLevel = 30, },
					[3] = { 192, 192, spellLevel = 40, },
					[4] = { 280, 280, spellLevel = 50, },
					[5] = { 384, 384, spellLevel = 60, },
					[6] = { 512, 512, spellLevel = 70, },
		},
		[GetSpellInfo(19750)] = { 
					["Name"] = "Flash of Light",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, castTime = 1.5, BaseIncrease = true, LevelIncrease = 5 },
					[1] = { 62, 72, 5, 5, spellLevel = 20, },
					[2] = { 96, 110, 6, 7, spellLevel = 26, },
					[3] = { 145, 163, 8, 9, spellLevel = 34, },
					[4] = { 197, 221, 9, 10, spellLevel = 42, },
					[5] = { 267, 299, 11, 11, spellLevel = 50, },
					[6] = { 343, 383, 13, 13, spellLevel = 58, },
					[7] = { 448, 502, 10, 11, spellLevel = 66, },
		},
		[GetSpellInfo(20473)] = { 
					["Name"] = "Holy Shock",
					[0] = { School = { "Holy", "Healing" }, canCrit = true, Cooldown = 15, },
					[1] = { 351, 379, spellLevel = 40, },
					[2] = { 480, 518, spellLevel = 48, },
					[3] = { 628, 680, spellLevel = 56, },
					[4] = { 777, 841, spellLevel = 64, },
					[5] = { 913, 987, spellLevel = 70, },
			["Secondary"] = { 
					["Name"] = "Holy Shock",
					[0] = { School = "Holy", canCrit = true, Cooldown = 15, },
					[1] = { 277, 299, spellLevel = 40, },
					[2] = { 379, 409, spellLevel = 48, },
					[3] = { 496, 536, spellLevel = 56, },
					[4] = { 614, 664, spellLevel = 64, },
					[5] = { 721, 779, spellLevel = 70, },
			},
		},
		[GetSpellInfo(35395)] = { 
					["Name"] = "Crusader Strike",
					[0] = { School = "Physical", Melee = true, WeaponDamage = 1.1, Cooldown = 6, },
					["None"] = { 0, 0, },
					[1] = { 0, 0, },
		},		
		[GetSpellInfo(21084)] = {
					["Name"] = "Seal of Righteousness",
					[0] = { School = "Holy", Melee = true, SpellDmgBonus = true, NoCrits = true, WeaponDPS = true, APGain = true, NoWeapon = true },
					[1] = { 0, Multiplier = 133.488, Rank = 1 },
					[2] = { 0, Multiplier = 266.976, Rank = 2 },
					[3] = { 0, Multiplier = 435.072, Rank = 3 },
					[4] = { 0, Multiplier = 668.676, Rank = 4 },
					[5] = { 0, Multiplier = 970.260, Rank = 5 },
					[6] = { 0, Multiplier = 1337.35, Rank = 6 },
					[7] = { 0, Multiplier = 1739.05, Rank = 7 },
					[8] = { 0, Multiplier = 2207.50, Rank = 8 },
					[9] = { 0, Multiplier = 2610.43, Rank = 9 },
		},
		[GetSpellInfo(20375)] = {
					["Name"] = "Seal of Command",
					[0] = { School = "Physical", Melee = true, SpellDmgBonus = true, WeaponDamage = 0.7, Hits = 3.5, eDuration = 30, PPM = 7, NoNormalization = true, NoWeapon = true },
					[1] = { 0, Rank = 1 },
					[2] = { 0, Rank = 2 },
					[3] = { 0, Rank = 3 },
					[4] = { 0, Rank = 4 },
					[5] = { 0, Rank = 5 },
					[6] = { 0, Rank = 6 },
		},
		[GetSpellInfo(31801)] = {
					["Name"] = "Seal of Vengeance",
					[0] = { School = "Holy", castTime = 30, extraDotFactor = 0.17, Stacks = 10, StacksDuration = 30, NoDoom = true, PPM = 20 },
					[1] = { 0, 0, extraDotDmg = 120, spellLevel = 64, },
		},
		[GetSpellInfo(31892)] = { 
					["Name"] = "Seal of Blood",
					[0] = { School = "Holy", Melee = true, WeaponDamage = 0.35, WeaponDPS = true, NoWeapon = true },
					[1] = { 0, Rank = 5 },
		},
		["Judgements"] = { [GetSpellInfo(21084)] = "Judgement of Righteousness", [GetSpellInfo(20375)] = "Judgement of Command", [GetSpellInfo(31801)] = "Judgement of Vengeance", [GetSpellInfo(31892)] = "Judgement of Blood" },
		[GetSpellInfo(20271)] = { 
					["Name"] = "Judgement",
					[0] = function()
						for k, v in pairs(DrDamage.spellInfo["Judgements"]) do
							local active, rank = GetPlayerBuffName(k)
							if active then
								return DrDamage.spellInfo[v][0], DrDamage.spellInfo[v][tonumber(string_match(rank,"%d+"))], v
							end
						end
					end
		
		},		
		["Judgement of Righteousness"] = {
					["Name"] = "Judgement of Righteousness",
					[0] = { School = { "Holy", "Judgement" }, Cooldown = 10, bonusFactor = 0.73, canCrit = true, NoDoom = true, BaseIncrease = true, LevelIncrease = 6 },
					[1] = { 15, 15, 10, 11, spellLevel = 1,  },
					[2] = { 25, 27, 11, 12, spellLevel = 10, },
					[3] = { 39, 43, 14, 15, spellLevel = 18, },
					[4] = { 57, 63, 16, 17, spellLevel = 26, },
					[5] = { 78, 86, 18, 19, spellLevel = 34, },
					[6] = { 102, 112, 22, 23, spellLevel = 42, },	
					[7] = { 131, 143, 24, 25, spellLevel = 50, },
					[8] = { 162, 178, 24, 25, spellLevel = 58, },
					[9] = { 208, 228, 17, 18, spellLevel = 66, }, 
		},
		["Judgement of Command"] = {
					["Name"] = "Judgement of Command",
					[0] = { School = { "Holy", "Judgement", "Physical" }, Cooldown = 10, canCrit = true, NoDoom = true, BaseIncrease = true, LevelIncrease = 7 },
					[1] = { 46, 50, 22, 23, spellLevel = 20, },
					[2] = { 73, 80, 24, 25, spellLevel = 30, },
					[3] = { 102, 112, 22, 23, spellLevel = 40, },
					[4] = { 130, 143, 24, 25, spellLevel = 50, },
					[5] = { 169, 186, 24, 25, spellLevel = 60, },
					[6] = { 228, 252, 0, 0, spellLevel = 70, },
		},
		["Judgement of Vengeance"] = {
					["Name"] = "Judgement of Vengeance",
					[0] = { School = { "Holy", "Judgement" }, Cooldown = 10, canCrit = true, NoDoom = true, },
					[1] = { 120, 120, spellLevel = 64, },			
		},
		["Judgement of Blood"] = {
					["Name"] = "Judgement of Blood",
					[0] = { School = { "Holy", "Judgement", "Physical" }, Cooldown = 10, canCrit = true, NoDoom = true, BaseIncrease = true, },
					[1] = { 295, 325, 36, 37, spellLevel = 64, },			
		},
		[GetSpellInfo(28880)] = {
					["Name"] = "Gift of the Naaru",
					[0] = { School = { "Holy", "Healing" }, Cooldown = 180, eDot = true, eDuration = 15, sTicks = 3, bonusFactor = 1, BaseIncrease = true, NoLowLevelPenalty = true, NoDownRank = true, NoSchoolTalents = true, },
					["None"] = { 50, 50, 1035, 1035, spellLevel = 1, },
		},
	}
	self.talentInfo = { 
		--Holy:
		--Improved Seal of Righteousness
		--Healing Light
		--Sanctified Light
		--Illumination
		--Purifying Power
		[GetSpellInfo(20224)] = { 	[1] = { Effect = 0.03, Spells = { "Seal of Righteousness", "Judgement of Righteousness" }, }, },
		[GetSpellInfo(20237)] = { 	[1] = { Effect = 0.04, Spells = { "Holy Light", "Flash of Light", }, }, },
		[GetSpellInfo(20359)] = { 	[1] = { Effect = 2, Spells = "Holy Light", ModType = "critPerc" }, },
		[GetSpellInfo(20210)] = { 	[1] = { Effect = 0.12, Spells = "Healing", ModType = "freeCrit" }, },
		[GetSpellInfo(31825)] = {	[1] = { Effect = 10, Spells = { "Holy Wrath", "Exorcism", }, ModType = "critPerc" }, },
		--Retribution:
		--Crusade
		--Improved Seal of the Crusader
		--Fanaticism
		--Improved Holy Shield
		--Two-Handed Weapon Specialization
		[GetSpellInfo(31866)] = { 	[1] = { Effect = 0.01, Spells = "All", ModType = "Crusade" }, },
		[GetSpellInfo(20335)] = { 	[1] = { Effect = 1, Spells = "All", ModType = "Amount", Value = "Improved Seal of the Crusader" }, },
		[GetSpellInfo(31879)] = { 	[1] = { Effect = 3, Spells = "Judgement", ModType = "critPerc" }, },
		[GetSpellInfo(41021)] = { 	[1] = { Effect = 1, Spells = "Holy Shield", ModType = "Improved Holy Shield" }, },
		[GetSpellInfo(20111)] = { 	[1] = { Effect = 0.02, Melee = true, Spells = "Physical", ModType = "Two-Handed Weapon Specialization" }, },
		
		--Melee module
		--Precision
		--Sanctified Judgement
		--Improved Judgement
		[GetSpellInfo(20189)] = {	[1] = { Effect = 1, Spells = "All", ModType = "hitPerc" }, },
		[GetSpellInfo(31876)] = { 	[1] = { Effect = -0.264, Spells = "Judgement", ModType = "manaCostM" }, },
		[GetSpellInfo(25956)] = { 	[1] = { Effect = -1, Spells = "Judgement", ModType = "cooldown" }, },
	}
end