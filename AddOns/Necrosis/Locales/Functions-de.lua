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
-- GERMAN  VERSION FUNCTIONS --
------------------------------------------------

if ( GetLocale() == "deDE" ) then

-- Table des sorts du démoniste
Necrosis.Spell = {
	[1] = {Name = "Teufelsross beschw\195\182ren",		Length = 0,	Type = 0},
	[2] = {Name = "Schreckensross herbeirufen",		Length = 0,	Type = 0},
	[3] = {Name = "Wichtel beschw\195\182ren",		Length = 0,	Type = 0},
	[4] = {Name = "Leerwandler beschw\195\182ren",		Length = 0,	Type = 0},
	[5] = {Name = "Sukkubus beschw\195\182ren",		Length = 0,	Type = 0},
	[6] = {Name = "Teufelsj\195\164ger beschw\195\182ren",	Length = 0,	Type = 0},
	[7] = {Name = "Teufelswache beschw\195\182ren",		Length = 0,	Type = 0},
	[8] = {Name = "Inferno",				Length = 3600,	Type = 3},
	[9] = {Name = "Verbannen",				Length = 30,	Type = 2},
	[10] = {Name = "D\195\164monensklave",			Length = 300,	Type = 2},
	[11] = {Name = "Seelensteinauferstehung",		Length = 1800,	Type = 1},
	[12] = {Name = "Feuerbrand",				Length = 15,	Type = 6},
	[13] = {Name = "Furcht",				Length = 15,	Type = 6},
	[14] = {Name = "Verderbnis",				Length = 17,	Type = 5},
	[15] = {Name = "Teufelsbeherrschung",			Length = 900,	Type = 3},
	[16] = {Name = "Fluch der Verdammnis",			Length = 60,	Type = 3},
	[17] = {Name = "Schattenfurie",				Length = 20,	Type = 3},
	[18] = {Name = "Seelenfeuer",				Length = 60,	Type = 3},
	[19] = {Name = "Todesmantel",				Length = 120,	Type = 3},
	[20] = {Name = "Schattenbrand",				Length = 15,	Type = 3},
	[21] = {Name = "Feuersbrunst",				Length = 10,	Type = 3},
	[22] = {Name = "Fluch der Pein",			Length = 24,	Type = 4},
	[23] = {Name = "Fluch der Schw\195\164che",		Length = 120,	Type = 4},
	[24] = {Name = "Fluch der Tollk\195\188hnheit",		Length = 120,	Type = 4},
	[25] = {Name = "Fluch der Sprachen",			Length = 30,	Type = 4},
	[26] = {Name = "Fluch der Elemente",			Length = 300,	Type = 4},
	[27] = {Name = "Fluch der Schatten",			Length = 300,	Type = 4},
	[28] = {Name = "Lebensentzug",				Length = 30,	Type = 6},
	[29] = {Name = "Schreckengeh\195\164ul",		Length = 40,	Type = 3},
	[30] = {Name = "Ritual der Verdammnis",			Length = 3600,	Type = 0},
	[31] = {Name = "D\195\164monenr\195\188stung",		Length = 0,	Type = 0},
	[32] = {Name = "Unendlicher Atem",			Length = 0,	Type = 0},
	[33] = {Name = "Unsichtbarkeit entdecken",		Length = 0,	Type = 0},
	[34] = {Name = "Auge von Kilrogg",			Length = 0,	Type = 0},
	[35] = {Name = "D\195\164monensklave",			Length = 0,	Type = 0},
	[36] = {Name = "D\195\164monenhaut",			Length = 0,	Type = 0},
	[37] = {Name = "Ritual der Beschw\195\182rung",		Length = 0,	Type = 0},
	[38] = {Name = "Seelenverbindung",			Length = 0,	Type = 0},
	[39] = {Name = "D\195\164monen sp\195\188ren",		Length = 0,	Type = 0},
	[40] = {Name = "Fluch der Ersch\195\182pfung",		Length = 12,	Type = 4},
	[41] = {Name = "Aderlass",				Length = 0,	Type = 0},
	[42] = {Name = "Fluch verst\195\164rken",		Length = 180,	Type = 3},
	[43] = {Name = "Schattenzauberschutz",			Length = 30,	Type = 3},
	[44] = {Name = "D\195\164monische Opferung",		Length = 0,	Type = 0},
	[45] = {Name = "Schattenblitz",				Length = 0,	Type = 0},
	[46] = {Name = "Instabiles Gebrechen",			Length = 18,	Type = 6},
	[47] = {Name = "Teufelsr\195\188stung",			Length = 0,	Type = 0},
	[48] = {Name = "Saat der Verderbnis",			Length = 18,	Type = 5},
	[49] = {Name = "Seele brechen",				Length = 300,	Type = 3},
	[50] = {Name = "Ritual der Seelen",			Length = 300,	Type = 3},
	[51] = {Name = "Seelenstein herstellen",		Length = 0,	Type = 0},
	[52] = {Name = "Gesundheitsstein herstellen",		Length = 0,	Type = 0},
	[53] = {Name = "Zauberstein herstellen",		Length = 0,	Type = 0},
	[54] = {Name = "Feuerstein herstellen",			Length = 0,	Type = 0},
	[55] = {Name = "Dunkler Pakt",				Length = 0,	Type = 0},
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
	["Undead"] = "Untoter",
	["Demon"] = "D\195\164mon",
	["Elemental"] = "Elementar",
}

-- Traduction du nom des procs utilisés par Necrosis
Necrosis.Translation.Proc = {
	["Backlash"] = "Heimzahlen",
	["ShadowTrance"] = "Schattentrance"
}

-- Traduction des noms des démons invocables
Necrosis.Translation.DemonName = {
	[1] = "Wichtel",
	[2] = "Leerwandler",
	[3] = "Sukkubus",
	[4] = "Teufelsj\195\164ger",
	[5] = "Teufelswache",
	[6] = "H\195\182llenbestie",
	[7] = "Verdammniswache"
}

-- Traduction du nom des objets utilisés par Necrosis
Necrosis.Translation.Item = {
	["Soulshard"] = "Seelensplitter",
	["Soulstone"] = "Seelenstein",
	["Healthstone"] = "Gesundheitsstein",
	["Spellstone"] = "Zauberstein",
	["Firestone"] = "Feuerstein",
	["Ranged"] = "Zauberstab",
	["Soulbound"] = "Soulbound",
	["InfernalStone"] = "H\195\182llenstein",
	["DemoniacStone"] = "D\195\164monenstatuette",
	["Hearthstone"] = "Ruhestein",
	["SoulPouch"] = {"Seelenbeutel", "Teufelsstofftasche", "Kernteufelsstofftasche"}
}

-- Traductions diverses
Necrosis.Translation.Misc = {
	["Cooldown"] = "Cooldown",
	["Rank"] = "Rang",
	["Create"] = "herstellen"
}

-- Gestion de la détection des cibles protégées contre la peur
Necrosis.AntiFear = {
	-- Buffs donnant une immunité temporaire au Fear
	["Buff"] = {
		"Furchtzauberschutz",		-- Dwarf priest racial trait
		"Wille der Verlassenen",	-- Forsaken racial trait
		"Furchtlos",			-- Trinket
		"Berserkerwut",			-- Warrior Fury talent
		"Tollk\195\188hnheit",		-- Warrior Fury talent
		"Todeswunsch",			-- Warrior Fury talent
		"Zorn des Wildtieres",		-- Hunter Beast Mastery talent (pet only)
		"Eisblock",			-- Mage Ice talent
		"G\195\182ttlicher Schutz",	-- Paladin Holy buff
		"Gottesschild",			-- Paladin Holy buff
		"Totem des Erdsto\195\159es",	-- Shaman totem
		"Abolish Magic"			-- Majordomo (NPC) spell
	},
	-- Debuffs donnant une immunité temporaire au Fear
	["Debuff"] = {
		"Fluch der Tollk\195\188hnheit"	-- Warlock curse
	}
}

end
