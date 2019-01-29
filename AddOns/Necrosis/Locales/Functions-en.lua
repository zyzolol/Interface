--[[
    Necrosis LdC
    Copyright (C) 2005-2006  Lom Enfroy

    This file is part of Necrosis LdC.

    Necrosis LdC is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Necrosis LdC is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Necrosis LdC; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--]]

------------------------------------------------------------------------------------------------------
-- Necrosis LdC
-- Originally by Lomig, Liadora et Nyx (Kael'Thas et Elune) [2005-2007]
-- Now updated by Tarcalion (Nagrand US/Oceanic) [2008-...]
--
-- Skins and French voices: Eliah, Ner'zhul
--
-- German Version by Geschan
-- Spanish Version by DosS (Zul’jin)
--
-- Version $LastChangedDate: 2008-03-30 15:05:46 +1000 $
------------------------------------------------------------------------------------------------------

------------------------------------------------
-- ENGLISH  VERSION FUNCTIONS --
------------------------------------------------

if ( GetLocale() == "enUS" ) or ( GetLocale() == "enGB" ) then

-- Table des sorts du démoniste
Necrosis.Spell = {
	[1] = {Name = "Summon Felsteed",		Length = 0,	Type = 0},
	[2] = {Name = "Summon Dreadsteed",		Length = 0,	Type = 0},
	[3] = {Name = "Summon Imp",			Length = 0,	Type = 0},
	[4] = {Name = "Summon Voidwalker",		Length = 0,	Type = 0},
	[5] = {Name = "Summon Succubus",		Length = 0,	Type = 0},
	[6] = {Name = "Summon Felhunter",		Length = 0,	Type = 0},
	[7] = {Name = "Summon Felguard",		Length = 0,	Type = 0},
	[8] = {Name = "Inferno",			Length = 3600,	Type = 3},
	[9] = {Name = "Banish",				Length = 30,	Type = 2},
	[10] = {Name = "Enslave Demon",			Length = 300,	Type = 2},
	[11] = {Name = "Soulstone Resurrection",	Length = 1800,	Type = 1},
	[12] = {Name = "Immolate",			Length = 15,	Type = 6},
	[13] = {Name = "Fear",				Length = 15,	Type = 6},
	[14] = {Name = "Corruption",			Length = 18,	Type = 5},
	[15] = {Name = "Fel Domination",		Length = 900,	Type = 3},
	[16] = {Name = "Curse of Doom",			Length = 60,	Type = 3},
	[17] = {Name = "Shadowfury",			Length = 20,	Type = 3},
	[18] = {Name = "Soul Fire",			Length = 60,	Type = 3},
	[19] = {Name = "Death Coil",			Length = 120,	Type = 3},
	[20] = {Name = "Shadowburn",			Length = 15,	Type = 3},
	[21] = {Name = "Conflagrate",			Length = 10,	Type = 3},
	[22] = {Name = "Curse of Agony",		Length = 24,	Type = 4},
	[23] = {Name = "Curse of Weakness",		Length = 120,	Type = 4},
	[24] = {Name = "Curse of Recklessness",		Length = 120,	Type = 4},
	[25] = {Name = "Curse of Tongues",		Length = 30,	Type = 4},
	[26] = {Name = "Curse of the Elements",		Length = 300,	Type = 4},
	[27] = {Name = "Curse of Shadow",		Length = 300,	Type = 4},
	[28] = {Name = "Siphon Life",			Length = 30,	Type = 6},
	[29] = {Name = "Howl of Terror",		Length = 40,	Type = 3},
	[30] = {Name = "Ritual of Doom",		Length = 3600,	Type = 0},
	[31] = {Name = "Demon Armor",			Length = 0,	Type = 0},
	[32] = {Name = "Unending Breath",		Length = 0,	Type = 0},
	[33] = {Name = "Detect Invisibility",		Length = 0,	Type = 0},
	[34] = {Name = "Eye of Kilrogg",		Length = 0,	Type = 0},
	[35] = {Name = "Enslave Demon",			Length = 0,	Type = 0},
	[36] = {Name = "Demon Skin",			Length = 0,	Type = 0},
	[37] = {Name = "Ritual of Summoning",		Length = 0,	Type = 0},
	[38] = {Name = "Soul Link",			Length = 0,	Type = 0},
	[39] = {Name = "Sense Demons",			Length = 0,	Type = 0},
	[40] = {Name = "Curse of Exhaustion",		Length = 12,	Type = 4},
	[41] = {Name = "Life Tap",			Length = 0,	Type = 0},
	[42] = {Name = "Amplify Curse",			Length = 180,	Type = 3},
	[43] = {Name = "Shadow Ward",			Length = 30,	Type = 3},
	[44] = {Name = "Demonic Sacrifice",		Length = 0,	Type = 0},
	[45] = {Name = "Shadow Bolt",			Length = 0,	Type = 0},
	[46] = {Name = "Unstable Affliction",		Length = 18,	Type = 6},
	[47] = {Name = "Fel Armor",			Length = 0,	Type = 0},
	[48] = {Name = "Seed of Corruption",		Length = 18,	Type = 5},
	[49] = {Name = "Soulshatter",			Length = 300,	Type = 3},
	[50] = {Name = "Ritual of Souls",		Length = 300,	Type = 3},
	[51] = {Name = "Create Soulstone",		Length = 0,	Type = 0},
	[52] = {Name = "Create Healthstone",		Length = 0,	Type = 0},
	[53] = {Name = "Create Spellstone",		Length = 0,	Type = 0},
	[54] = {Name = "Create Firestone",		Length = 0,	Type = 0},
	[55] = {Name = "Dark Pact",			Length = 0,	Type = 0},
}
-- Type 0 = Pas de Timer
-- Type 1 = Timer permanent principal
-- Type 2 = Timer permanent
-- Type 3 = Timer de cooldown
-- Type 4 = Timer de malédiction
-- Type 5 = Timer de corruption
-- Type 6 = Timer de combat

for i in ipairs(Necrosis.Spell) do
	Necrosis.Spell[i].Rank = " "
end

-- Types d'unité des PnJ utilisés par Necrosis
Necrosis.Unit = {
	["Undead"] = "Undead",
	["Demon"] = "Demon",
	["Elemental"] = "Elemental"
}

-- Traduction du nom des procs utilisés par Necrosis
Necrosis.Translation.Proc = {
	["Backlash"] = "Backlash",
	["ShadowTrance"] = "Shadow Trance"
}

-- Traduction des noms des démons invocables
Necrosis.Translation.DemonName = {
	[1] = "Imp",
	[2] = "Voidwalker",
	[3] = "Succubus",
	[4] = "Felhunter",
	[5] = "Felguard",
	[6] = "Inferno",
	[7] = "Doomguard"
}

-- Traduction du nom des objets utilisés par Necrosis
Necrosis.Translation.Item = {
	["Soulshard"] = "Soul Shard",
	["Soulstone"] = "Soulstone",
	["Healthstone"] = "Healthstone",
	["Spellstone"] = "Spellstone",
	["Firestone"] = "Firestone",
	["Ranged"] = "Wand",
	["Soulbound"] = "Soulbound",
	["InfernalStone"] = "Infernal Stone",
	["DemoniacStone"] = "Demonic Figurine",
	["Hearthstone"] = "Hearthstone",
	["SoulPouch"] = {"Soul Pouch", "Felcloth Bag", "Core Felcloth Bag"}
}

-- Traductions diverses
Necrosis.Translation.Misc = {
	["Cooldown"] = "Cooldown",
	["Rank"] = "Rank",
	["Create"] = "Create"
}

-- Gestion de la détection des cibles protégées contre la peur
Necrosis.AntiFear = {
	-- Buffs giving temporary immunity to fear effects
	["Buff"] = {
		"Fear Ward",		-- Dwarf priest racial trait
		"Will of the Forsaken",	-- Forsaken racial trait
		"Fearless",		-- Trinket
		"Berzerker Rage",	-- Warrior Fury talent
		"Recklessness",		-- Warrior Fury talent
		"Death Wish",		-- Warrior Fury talent
		"Bestial Wrath",	-- Hunter Beast Mastery talent
		"Ice Block",		-- Mage Ice talent
		"Divine Protection",	-- Paladin Holy buff
		"Divine Shield",	-- Paladin Holy buff
		"Tremor Totem",		-- Shaman totem
		"Abolish Magic"		-- Majordomo (NPC) spell
	},
	-- Debuffs and curses giving temporary immunity to fear effects
	["Debuff"] = {
		"Curse of Recklessness"	-- Warlock curse
	}
}

end
