local L = AceLibrary("AceLocale-2.2"):new("DrDamage")

DrDamage.PlayerAura = {}
DrDamage.TargetAura = {}
DrDamage.Consumables = {}

local function DrD_LoadAuras()
	local playerClass = select(2,UnitClass("player"))
	local playerHealer = (playerClass == "PRIEST") or (playerClass == "SHAMAN") or (playerClass == "PALADIN") or (playerClass == "DRUID")
	local playerCaster = (playerClass == "MAGE") or (playerClass == "PRIEST") or (playerClass == "WARLOCK")
	local playerMelee = (playerClass == "ROGUE") or (playerClass == "WARRIOR") or (playerClass == "HUNTER")
	local playerHybrid = (playerClass == "DRUID") or (playerClass == "PALADIN") or (playerClass == "SHAMAN")	
	local Aura = DrDamage.PlayerAura
	local GetSpellInfo = GetSpellInfo
	local arcane, fire, frost, nature, shadow, holy
	
	if playerCaster or playerHybrid then
		arcane = (playerClass == "PRIEST") or (playerClass == "DRUID") or (playerClass == "MAGE")
		fire = (playerClass == "SHAMAN") or (playerClass == "WARLOCK") or (playerClass == "MAGE")
		frost = (playerClass == "SHAMAN") or (playerClass == "MAGE")
		nature = (playerClass == "SHAMAN") or (playerClass == "DRUID")
		shadow = (playerClass == "PRIEST") or (playerClass == "WARLOCK")
		holy = (playerClass == "PRIEST") or (playerClass == "PALADIN")
	end
	
	--Bloodlust
	--Heroism
	--Inspiring Presence
	--Aura of the Crusader (Darkmoon Card: Crusade)
	Aura[GetSpellInfo(2825)] = { School = "All", Mods = { ["castTime"] = function(v) return v/1.3 end } }
	Aura[GetSpellInfo(32182)] = Aura[GetSpellInfo(2825)]
	Aura[GetSpellInfo(28878)] = { Value = 1, ModType = "hitPerc", }
	Aura[GetSpellInfo(39438)] = { Mods = { ["spellDmg"] = 80, ["AP"] = 120 } }
	
	--Totem of Wrath
	--Wrath of Air
	--Vibrant Blood
	--Bloodgem Infusion
	--Power Infusion
	--Moonkin Aura
	--Icy Veins
	if playerCaster or playerHybrid then
		Aura[GetSpellInfo(30706)] = { Caster = true, School = "All", Value = 3, ModType = "hitPerc", Mods = { ["critPerc"] = 3 } }
		Aura[GetSpellInfo(3738)] = { Caster = true, School = "All", Mods = { ["spellDmg"] = 101 } }
		Aura[GetSpellInfo(35329)] = { Caster = true, Value = 0.1 }
		Aura[GetSpellInfo(34379)] = { Caster = true, School = "All", Value = 0.05, }
		Aura[GetSpellInfo(10060)] = { Caster = true, School = "All", Mods = { ["castTime"] = function(v) return v/1.2 end } }
		Aura[GetSpellInfo(24907)] = { Caster = true, School = "All", Mods = { ["critPerc"] = 5 } }
		if playerClass == "MAGE" then
			Aura[GetSpellInfo(12472)] = { Mods = { ["castTime"] = function(v) return v/1.2 end } }
		end		
	end
	
	--A'dal's Song of Battle	
	--Vile Slime
	--Debilitating Spray
	--Vile Sludge
	--Nether Portal - Serenity
	if playerHealer then
		Aura[GetSpellInfo(39953)] = { School = "Healing", Value = 0.05, }
		Aura[GetSpellInfo(40099)] = { School = "Healing", Value = -0.5 }
		Aura[GetSpellInfo(40079)] = { School = "Healing", Value = -0.5 }
		Aura[GetSpellInfo(38246)] = { School = "Healing", Value = -0.5 }	
		Aura[GetSpellInfo(30422)] = { School = "Healing", Value = 0.05, Apps = 10 }
	end
	
	--Target debuffs
	Aura = DrDamage.TargetAura
	
	if playerCaster or playerHybrid then
		--School
		--Curse of the Elements
		--Shadow Vulnerability
		--Fire Vulnerability
		--Winter's Chill
		if shadow or arcane or fire or frost then 
			Aura[GetSpellInfo(1490)] = { School = { "Shadow", "Arcane", "Fire", "Frost" }, Value = 0.1, ActiveAura = "Soul Siphon", }
		end
		if shadow then
			Aura[GetSpellInfo(15258)] = { School = "Shadow", Texture = "Spell_Shadow_ShadowBolt", Value = 0.2, Apps2 = 5, Value2 = 0.02, ModType = "Texture", }
			Aura[GetSpellInfo(17793)] = { School = "Shadow", Value = 0.2, }
			Aura[(GetSpellInfo(17793) .. " (50%)")] = { School = "Shadow", Value = 0.1, }
			Aura[(GetSpellInfo(17793) .. " (75%)")] = { School = "Shadow", Value = 0.15, }
		end
		if fire then
			Aura[GetSpellInfo(22959)] = { School = "Fire", Apps = 5, Value = 0.03, }
		end
		if frost then
			Aura[GetSpellInfo(28595)] = { School = "Frost", Apps = 5, Value = 2, ModType = "critPerc", }
		end
		--General
		--Spell Vulnerability
		--Mistery
		--Magic Disruption
		Aura[GetSpellInfo(23605)] = { Value = 0.15, Caster = true }
		Aura[GetSpellInfo(33195)] = { Value = 0.01, Ranks = 5, Caster = true }
		Aura[GetSpellInfo(36478)] = { Value = 0.05, Apps = 5, Caster = true }
		
	end
	if playerHealer then
		--Amplify Magic
		--Quick Recovery
		--Fel Armor
		--Curse of the Bleeding Hollow
		--Wound Poison
		--Blood Fury
		--Mortal Strike
		--Hex of Weakness
		--Veil of Shadow
		--Nether Portal - Dominance
		Aura[GetSpellInfo(1008)] = { School = "Healing", ModType = "spellDmg", Ranks = 6, Value = { 30, 60, 100, 150, 180, 240 }, }
		Aura[GetSpellInfo(31245)] = { School = "Healing", Ranks = 2, Value = 0.1 }
		Aura[GetSpellInfo(28176)] = { School = "Healing", Value = 0.2, }
		Aura[GetSpellInfo(34073)] = { School = "Healing", Value = -0.15 }
		Aura[GetSpellInfo(43461)] = { School = "Healing", Apps = 5, Value = -0.1, }
		Aura[GetSpellInfo(33697)] = { School = "Healing", Value = -0.5, }
		Aura[GetSpellInfo(12294)] = { School = "Healing", Value = -0.5, }
		Aura[GetSpellInfo(9035)] = { School = "Healing", Value = -0.2, }
		Aura[GetSpellInfo(17820)] = { School = "Healing", Value = -0.75, }
		Aura[GetSpellInfo(30423)] = { School = "Healing", Value = -0.01, Apps = 10 }
	end
	if playerMelee or playerHybrid then
		--Shadowform
		--Holyform
		--Armor Disruption
		--Hemorrhage
		--Stormstrike
		Aura[GetSpellInfo(15473)] = { School = { "Ranged", "Physical" }, Value = -0.1 }
		Aura[GetSpellInfo(46565)] = { School = { "Ranged", "Physical" }, Value = -0.2 }
		Aura[GetSpellInfo(36482)] = { School = {"Ranged", "Physical" }, Value = 0.05, Apps = 5 }
		Aura[GetSpellInfo(16511)] = { School = { "Ranged", "Physical" }, Value = { 13, 21, 29, 42 }, Ranks = 4, ModType = "dmgBonus" }
		if nature or playerClass == "ROGUE" or playerClass == "HUNTER" then
			Aura[GetSpellInfo(17364)] = { School = "Nature", Value = 0.2, }
		end
	end
	
	local Consumables = DrDamage.Consumables
	if arcane or holy or nature then
		Consumables[GetItemInfo(22861) or "Flask of Blinding Light"] = { School = { "Arcane", "Holy", "Nature" }, Mods = { ["spellDmg"] = 80 }, Alt = GetSpellInfo(46839) }
	end
	if shadow or fire or frost then
		Consumables[GetItemInfo(22866) or "Flask of Pure Death"] = { School = { "Shadow", "Fire", "Frost" }, Mods = { ["spellDmg"] = 80 }, Alt = GetSpellInfo(46837) }
	end
	if shadow then
		Consumables[GetItemInfo(22835) or "Elixir of Major Shadow Power"] = { School = "Shadow", Mods = { ["spellDmg"] = 55 }, Alt = GetSpellInfo(28503) }
	end
	if fire then
		Consumables[GetItemInfo(22833) or "Elixir of Major Firepower"] = { School = "Fire", Mods = { ["spellDmg"] = 55 }, Alt = GetSpellInfo(28501) }
	end
	if frost then
		Consumables[GetItemInfo(22827) or "Elixir of Major Frost Power"] = { School = "Frost", Mods = { ["spellDmg"] = 55 }, Alt = GetSpellInfo(28493) }
	end
	if playerHealer then
		Consumables[GetItemInfo(22825) or "Elixir of Healing Power"] = { School = "Healing", Mods = { ["spellDmg"] = 50 }, Alt = GetSpellInfo(28491) }
		Consumables[GetItemInfo(20748) or "Brilliant Mana Oil"] = { School = "Healing", Mods = { ["manaRegen"] = 2.4, ["spellDmg"] = 25 }, Oil = true }
		Consumables[GetItemInfo(22521) or "Superior Mana Oil"] = { School = "All", Mods = { ["manaRegen"] = 2.8 }, Oil = true }
		
		Consumables[L["+44 Healing Food"]] = { School = "Healing", Mods = { ["spellDmg"] = 44 }, Alt = GetSpellInfo(33263) }
	end
	if playerCaster or playerHybrid or playerHealer then
		--Adept's Elixir
		Consumables[GetSpellInfo(33721)] = { School = "All", Mods = { ["spellDmg"] = 24, ["critPerc"] = 1.08696 } }
		Consumables[GetItemInfo(13512) or "Flask of Supreme Power"] = { Mods = { ["spellDmg"] = 70 }, Alt = GetSpellInfo(32900) }
		Consumables[GetItemInfo(22522) or "Superior Wizard Oil"] = { School = "All", Mods = { ["spellDmg"] = 42 }, Oil = true }
		Consumables[GetItemInfo(20749) or "Brilliant Wizard Oil"] = { School = "All", Mods = { ["spellDmg"] = 36, ["critPerc"] = 0.634 }, Oil = true }
		Consumables[GetItemInfo(22853) or "Flask of Mighty Restoration"] = { School = "All", Mods = { ["manaRegen"] = 5 }, Alt = GetSpellInfo(41610) }
		Consumables[GetItemInfo(22840) or "Elixir of Major Mageblood"] = { School = "All", Mods = { ["manaRegen"] = 3.2 }, Alt = GetSpellInfo(28509) }
		
		Consumables[L["+23 Damage Food"]] = { Mods = { ["spellDmg"] = 23, }, Alt = GetSpellInfo(33263) }
		Consumables[L["+20 Spell Critical Strike Food"]] = { School = "All", Mods = { ["critPerc"] = 0.9058 }, Alt = GetSpellInfo(33263) }
	end
	if playerMelee or playerHybrid then
		Consumables[GetItemInfo(22854) or "Flask of Relentless Assault"] = { School = { "Ranged", "Physical" }, Mods = { ["AP"] = 120 }, Alt = GetSpellInfo(41608) }
		--Elixir of Demonslaying
		Consumables[GetSpellInfo(11406)] = { School = { "Physical", "Ranged" }, Mods = { ["AP"] = 265 }, }
		
		Consumables[L["+40 AP Food"]] = { School = { "Ranged", "Physical" }, Mods = { ["AP"] = 40 }, Alt = GetSpellInfo(33263) }
		Consumables[L["+20 Hit Rating Food"]] = { School = { "Ranged", "Physical" }, Mods = { ["hitPerc"] = 1.269 }, Alt = GetSpellInfo(33263) }
	end
end

DrD_LoadAuras()
DrD_LoadAuras = nil