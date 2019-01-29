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
-- VERSION FRANCAISE DES FONCTIONS --
------------------------------------------------

if ( GetLocale() == "frFR" ) then

-- Table des sorts du démoniste
Necrosis.Spell = {
	[1] = {Name = "Invocation d'un palefroi corrompu",			Length = 0,	Type = 0},
	[2] = {Name = "Invocation d'un destrier de l'effroi",			Length = 0,	Type = 0},
	[3] = {Name = "Invocation d'un diablotin",				Length = 0,	Type = 0},
	[4] = {Name = "Invocation d'un marcheur du Vide",			Length = 0,	Type = 0},
	[5] = {Name = "Invocation d'une succube",				Length = 0,	Type = 0},
	[6] = {Name = "Invocation d'un chasseur corrompu",			Length = 0,	Type = 0},
	[7] = {Name = "Invocation d'un gangregarde",				Length = 0,	Type = 0},
	[8] = {Name = "Inferno",						Length = 3600,	Type = 3},
	[9] = {Name = "Bannir",							Length = 30,	Type = 2},
	[10] = {Name = "Asservir d\195\169mon",					Length = 300,	Type = 2},
	[11] = {Name = "R\195\169surrection de Pierre d'\195\162me",		Length = 1800,	Type = 1},
	[12] = {Name = "Immolation",						Length = 15,	Type = 6},
	[13] = {Name = "Peur",							Length = 15,	Type = 6},
	[14] = {Name = "Corruption",						Length = 18,	Type = 5},
	[15] = {Name = "Domination corrompue",					Length = 900,	Type = 3},
	[16] = {Name = "Mal\195\169diction funeste",				Length = 60,	Type = 3},
	[17] = {Name = "Furie de l'ombre",					Length = 20,	Type = 3},
	[18] = {Name = "Feu de l'\195\162me",					Length = 60,	Type = 3},
	[19] = {Name = "Voile mortel",						Length = 120,	Type = 3},
	[20] = {Name = "Br\195\187lure de l'ombre",				Length = 15,	Type = 3},
	[21] = {Name = "Conflagration",						Length = 10,	Type = 3},
	[22] = {Name = "Mal\195\169diction d'agonie",				Length = 24,	Type = 4},
	[23] = {Name = "Mal\195\169diction de faiblesse",			Length = 120,	Type = 4},
	[24] = {Name = "Mal\195\169diction de t\195\169m\195\169rit\195\169",	Length = 120,	Type = 4},
	[25] = {Name = "Mal\195\169diction des langages",			Length = 30,	Type = 4},
	[26] = {Name = "Mal\195\169diction des \195\169l\195\169ments",		Length = 300,	Type = 4},
	[27] = {Name = "Mal\195\169diction de l'ombre",				Length = 300,	Type = 4},
	[28] = {Name = "Siphon de vie",						Length = 30,	Type = 6},
	[29] = {Name = "Hurlement de terreur",					Length = 40,	Type = 3},
	[30] = {Name = "Rituel de mal\195\169diction",				Length = 3600,	Type = 0},
	[31] = {Name = "Armure d\195\169moniaque",				Length = 0,	Type = 0},
	[32] = {Name = "Respiration interminable",				Length = 0,	Type = 0},
	[33] = {Name = "D\195\169tection de l'invisibilit\195\169",		Length = 0,	Type = 0},
	[34] = {Name = "Oeil de Kilrogg",					Length = 0,	Type = 0},
	[35] = {Name = "Asservir d\195\169mon",					Length = 0,	Type = 0},
	[36] = {Name = "Peau de d\195\169mon",					Length = 0,	Type = 0},
	[37] = {Name = "Rituel d'invocation",					Length = 0,	Type = 0},
	[38] = {Name = "Lien spirituel",					Length = 0,	Type = 0},
	[39] = {Name = "D\195\169tection des d\195\169mons",			Length = 0,	Type = 0},
	[40] = {Name = "Mal\195\169diction de fatigue",				Length = 12,	Type = 4},
	[41] = {Name = "Connexion",						Length = 0,	Type = 0},
	[42] = {Name = "Mal\195\169diction amplifi\195\169e",			Length = 180,	Type = 3},
	[43] = {Name = "Gardien de l'ombre",					Length = 30,	Type = 3},
	[44] = {Name = "Sacrifice d\195\169moniaque",				Length = 0,	Type = 0},
	[45] = {Name = "Trait de l'ombre",					Length = 0,	Type = 0},
	[46] = {Name = "Affliction instable",					Length = 18,	Type = 6},
	[47] = {Name = "Gangrarmure",						Length = 0,	Type = 0},
	[48] = {Name = "Graine de Corruption",					Length = 18,	Type = 5},
	[49] = {Name = "Brise-\195\162me",					Length = 300,	Type = 3},
	[50] = {Name = "Rituel des \195\162mes",				Length = 300,	Type = 3},
	[51] = {Name = "Cr\195\169ation de pierre d'\195\162me",		Length = 0,	Type = 0},
	[52] = {Name = "Cr\195\169ation de Pierre de soins",			Length = 0,	Type = 0},
	[53] = {Name = "Cr\195\169ation de pierre de sort",			Length = 0,	Type = 0},
	[54] = {Name = "Cr\195\169ation de Pierre de feu",			Length = 0,	Type = 0},
	[55] = {Name = "Pacte noir",						Length = 0,	Type = 0},
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
	["Undead"] ="Mort-vivant",
	["Demon"] = "D\195\169mon",
	["Elemental"] = "El\195\169mentaire"
}

-- Traduction du nom des procs utilisés par Necrosis
Necrosis.Translation.Proc = {
	["Backlash"] = "Contrecoup",
	["ShadowTrance"] = "Transe de l'ombre"
}

-- Traduction des noms des démons invocables
Necrosis.Translation.DemonName = {
	[1] = "Diablotin",
	[2] = "Marcheur du Vide",
	[3] = "Succube",
	[4] = "Chasseur corrompu",
	[5] = "Gangregarde",
	[6] = "Infernal",
	[7] = "Garde funeste"
}

-- Traduction du nom des objets utilisés par Necrosis
Necrosis.Translation.Item = {
	["Soulshard"] = "Fragment d'\195\162me",
	["Soulstone"] = "Pierre d'\195\162me",
	["Healthstone"] = "Pierre de soins",
	["Spellstone"] = "Pierre de sort",
	["Firestone"] = "Pierre de feu",
	["Wand"] = "Baguette",
	["Soulbound"] = "Li\195\169",
	["InfernalStone"] = "Pierre infernale",
	["DemoniacStone"] = "Figurine d\195\169moniaque",
	["Hearthstone"] = "Pierre de foyer",
	["SoulPouch"] = {"Bourse d'\195\162me", "Sac en gangr\195\169toffe", "Sac en gangr\195\169toffe du Magma"}
}

-- Traductions diverses
Necrosis.Translation.Misc = {
	["Cooldown"] = "Temps",
	["Rank"] = "Rang",
	["Create"] = "Cr\195\169ation"
}

-- Gestion de la détection des cibles protégées contre la peur
Necrosis.AntiFear = {
	-- Buffs donnant une immunité temporaire au Fear
	["Buff"] = {
		"Gardien de peur",					-- Capacité raciale des prêtres nains
		"Volont\195\169 des r\195\169prouv\195\169",		-- Capacité raciale réprouvée
		"Sans peur",						-- Trinket
		"Furie Berzerker",					-- Talent Guerrier (Branche Fury)
		"T\195\169m\195\169rit\195\169",			-- Talent Guerrier (Branche Fury)
		"Souhait mortel",					-- Talent Guerrier (Branche Fury)
		"Courroux bestial",					-- Talent Chasseur (Branche Beast)
		"Carapace de glace",					-- Talent Mage (Branche Ice)
		"Protection divine",					-- Buff sacré Paladin
		"Bouclier divin",					-- Buff sacré Paladin
		"Totem de s\195\169isme",				-- Totem
		"Abolir la magie"					-- Sort de Majordomo (PnJ)
	},
	-- Debuffs donnant une immunité temporaire au Fear
	["Debuff"] = {
		"Mal\195\169diction de t\195\169m\195\169rit\195\169"	-- Malédiction de démoniste
	}
}

end
