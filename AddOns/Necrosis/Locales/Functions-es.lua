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
-- SPANISH  VERSION FUNCTIONS --
------------------------------------------------

if ( GetLocale() == "esES" ) then

-- Table des sorts du démoniste
Necrosis.Spell = {
	[1] = {Name = "Invocar a corcel vil",				Length = 0,	Type = 0},
	[2] = {Name = "Invocar a corcel nefasto",			Length = 0,	Type = 0},
	[3] = {Name = "Invocar a diablillo",				Length = 0,	Type = 0},
	[4] = {Name = "Invocar a abisario",				Length = 0,	Type = 0},
	[5] = {Name = "Invocar a s\195\186cubo",			Length = 0,	Type = 0},
	[6] = {Name = "Invocar a man\195\161fago",			Length = 0,	Type = 0},
	[7] = {Name = "Invocar a guardia maldito",			Length = 0,	Type = 0},
	[8] = {Name = "Inferno",					Length = 3600,	Type = 3},
	[9] = {Name = "Desterrar",					Length = 30,	Type = 2},
	[10] = {Name = "Esclavizar demonio",				Length = 300,	Type = 2},
	[11] = {Name = "Resurrecci\195\179n con piedra de alma",	Length = 1800,	Type = 1},
	[12] = {Name = "Inmolar",					Length = 15,	Type = 6},
	[13] = {Name = "Miedo",						Length = 15,	Type = 6},
	[14] = {Name = "Corrupci\195\179n",				Length = 17,	Type = 5},
	[15] = {Name = "Dominio vil",					Length = 900,	Type = 3},
	[16] = {Name = "Maldición del Apocalipsis",			Length = 60,	Type = 3},
	[17] = {Name = "Furia de las Sombras",				Length = 20,	Type = 3},
	[18] = {Name = "Fuego de alma",					Length = 60,	Type = 3},
	[19] = {Name = "Espiral de la muerte",				Length = 120,	Type = 3},
	[20] = {Name = "Quemadura de las Sombras",			Length = 15,	Type = 3},
	[21] = {Name = "Conflagrar",					Length = 10,	Type = 3},
	[22] = {Name = "Maldici\195\179n de agon\195\173a",		Length = 24,	Type = 4},
	[23] = {Name = "Maldici\195\179n de debilidads",		Length = 120,	Type = 4},
	[24] = {Name = "Maldici\195\179n de temeridad",			Length = 120,	Type = 4},
	[25] = {Name = "Maldici\195\179n de las lenguas",		Length = 30,	Type = 4},
	[26] = {Name = "Maldici\195\179n de los Elementos",		Length = 300,	Type = 4},
	[27] = {Name = "Maldici\195\179n de las Sombras",		Length = 300,	Type = 4},
	[28] = {Name = "Drenar Vida",					Length = 30,	Type = 6},
	[29] = {Name = "Aullido de terror",				Length = 40,	Type = 3},
	[30] = {Name = "Ritual de condena",				Length = 3600,	Type = 0},
	[31] = {Name = "Armadura demon\195\173aca",			Length = 0,	Type = 0},
	[32] = {Name = "Aliento inagotable",				Length = 0,	Type = 0},
	[33] = {Name = "Detectar invisibilidad",			Length = 0,	Type = 0},
	[34] = {Name = "Ojo de Kilrogg",				Length = 0,	Type = 0},
	[35] = {Name = "Esclavizar demonio",				Length = 0,	Type = 0},
	[36] = {Name = "Piel de demonio",				Length = 0,	Type = 0},
	[37] = {Name = "Ritual de invocaci\195\179n",			Length = 0,	Type = 0},
	[38] = {Name = "Enlace de alma",				Length = 0,	Type = 0},
	[39] = {Name = "Captar demonios",				Length = 0,	Type = 0},
	[40] = {Name = "Maldici\195\179n de agotamiento",		Length = 12,	Type = 4},
	[41] = {Name = "Transfusi\195\179n de vida",			Length = 0,	Type = 0},
	[42] = {Name = "Amplificar maldici\195\179n",			Length = 180,	Type = 3},
	[43] = {Name = "Resguardo contra las Sombras",			Length = 30,	Type = 3},
	[44] = {Name = "Sacrificio demon\195\173aco",			Length = 0,	Type = 0},
	[45] = {Name = "Descarga de las Sombras",			Length = 0,	Type = 0},
	[46] = {Name = "Aflicci\195\179n inestable",			Length = 18,	Type = 6},
	[47] = {Name = "Armadura vil",					Length = 0,	Type = 0},
	[48] = {Name = "Semilla de corrupci\195\179n",			Length = 18,	Type = 5},
	[49] = {Name = "Despedazar alma",				Length = 300,	Type = 3},
	[50] = {Name = "Ritual de almas",				Length = 300,	Type = 3},
	[51] = {Name = "Crear piedra de alma",				Length = 0,	Type = 0},
	[52] = {Name = "Crear piedra de salud",				Length = 0,	Type = 0},
	[53] = {Name = "Crear piedra de hechizo",			Length = 0,	Type = 0},
	[54] = {Name = "Crear piedra de fuego",				Length = 0,	Type = 0},
	[55] = {Name = "Pacto oscuro",					Length = 0,	Type = 0},
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

Necrosis.Unit = {
	["Undead"] = "No-muerto",
	["Demon"] = "Demonio",
	["Elemental"] = "Elemental",
}

-- Traduction du nom des procs utilisés par Necrosis
Necrosis.Translation.Proc = {
	["Backlash"] = "Contragolpe",
	["ShadowTrance"] = "Trance de las Sombras"
}

-- Traduction des noms des démons invocables
Necrosis.Translation.DemonName = {
	[1] = "Diablillo",
	[2] = "Abisario",
	[3] = "S\195\186cubo",
	[4] = "Man\195\161fago",
	[5] = "Guardia maldito",
	[6] = "Inferno",
	[7] = "Guardia apocal\195\173ptico"
}

-- Traduction du nom des objets utilisés par Necrosis
Necrosis.Translation.Item = {
	["Soulshard"] = "Fragmento de Alma",
	["Soulstone"] = "Piedra de alma",
	["Healthstone"] = "Piedra de salud",
	["Spellstone"] = "Piedra de hechizo",
	["Firestone"] = "Piedra de fuego",
	["Ranged"] = "Varita",
	["Soulbound"] = "Se liga al equiparlo",
	["InfernalStone"] = "Piedra infernal",
	["DemoniacStone"] = "Figura demon\195\173aca",
	["Hearthstone"] = "Piedra de hogar",
	["SoulPouch"] = {"Faltriquera de almas", "Bolsa de tela vil", "Bolsa de tela vil del N\195\186cleo"}
}

-- Traductions diverses
Necrosis.Translation.Misc = {
	["Cooldown"] = "Tiempo de reutilizaci\195\179n restante",
	["Rank"] = "Rango",
	["Create"] = "Crear"
}

-- Gestion de la détection des cibles protégées contre la peur
Necrosis.AntiFear = {
	-- Bufos que dan inmunidad temporal a los efectos de miedo
	["Buff"] = {
		"Custodia de miedo",		-- Dwarf priest racial trait
		"Voluntad de los Renegados.",	-- Forsaken racial trait
		"Audacia",			-- Trinket
		"Ira rabiosa",			-- Warrior Fury talent
		"Temeridad",			-- Warrior Fury talent
		"Deseo de la muerte",		-- Warrior Fury talent
		"C\195\179lera de las bestias",	-- Hunter Beast Mastery talent (pet only)
		"Bloqueo de hielo",		-- Mage Ice talent
		"Protecci\195\179n divina",	-- Paladin Holy buff
		"Escudo divino",		-- Paladin Holy buff
		"T\195\179tem de tremor",	-- Shaman totem
		"Suprimir magia"		-- Majordomo (NPC) spell
	},
	-- Debufos y maldiciones que dan inmunidad temporal a los efectos de miedo
	["Debuff"] = {
		"Maldici\195\179n de Temeridad"	-- Warlock curse
	}
}

end
