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
-- Chinese Simplified VERSION FUNCTIONS--
--  2006/01/02
--  艾娜羅沙@奧妮克希亞/TW
------------------------------------------------

if ( GetLocale() == "zhCN" ) then

-- Table des sorts du démoniste
Necrosis.Spell = {
	[1] = {Name = "召唤地狱战马",	Length = 0,	Type = 0,	TexturePrefix = nil},
	[2] = {Name = "召唤恐惧战马",	Length = 0,	Type = 0,	TexturePrefix = nil},
	[3] = {Name = "召唤小鬼",		Length = 0,	Type = 0,	TexturePrefix = "Imp"},
	[4] = {Name = "召唤虚空行者",	Length = 0,	Type = 0,	TexturePrefix = "Voidwalker"},
	[5] = {Name = "召唤魅魔",		Length = 0,	Type = 0,	TexturePrefix = "Succubus"},
	[6] = {Name = "召唤地狱猎犬",	Length = 0,	Type = 0,	TexturePrefix = "Felhunter"},
	[7] = {Name = "暗影箭",		Length = 0,	Type = 0,	TexturePrefix = nil},
	[8] = {Name = "地狱火",		Length = 3600,	Type = 3,	TexturePrefix = "Infernal"},
	[9] = {Name = "放逐术",		Length = 30,	Type = 2,	TexturePrefix = "Banish"},
	[10] = {Name = "奴役恶魔",	Length = 300,	Type = 2,	TexturePrefix = nil},
	[11] = {Name = "灵魂石复活",	Length = 1800,	Type = 1,	TexturePrefix = nil},
	[12] = {Name = "献祭",		Length = 15,	Type = 5,	TexturePrefix = nil},
	[13] = {Name = "恐惧术",		Length = 15,	Type = 5,	TexturePrefix = nil},
	[14] = {Name = "腐蚀术",		Length = 17,	Type = 5,	TexturePrefix = nil},
	[15] = {Name = "恶魔支配",	Length = 900,	Type = 3,	TexturePrefix = "Domination"},
	[16] = {Name = "厄运诅咒",	Length = 60,	Type = 3,	TexturePrefix = "Doom"},
	[17] = {Name = "牺牲",		Length = 30,	Type = 3,	TexturePrefix = nil},
	[18] = {Name = "灵魂之火",	Length = 60,	Type = 3,	TexturePrefix = nil},
	[19] = {Name = "死亡缠绕",	Length = 120,	Type = 3,	TexturePrefix = nil},
	[20] = {Name = "暗影灼烧",	Length = 15,	Type = 3,	TexturePrefix = nil},
	[21] = {Name = "燃烧",		Length = 10,	Type = 3,	TexturePrefix = nil},
	[22] = {Name = "痛苦诅咒",	Length = 24,	Type = 4,	TexturePrefix = "Agony"},
	[23] = {Name = "虚弱诅咒",	Length = 120,	Type = 4,	TexturePrefix = "Weakness"},
	[24] = {Name = "鲁莽诅咒",	Length = 120,	Type = 4,	TexturePrefix = "Reckless"},
	[25] = {Name = "语言诅咒",	Length = 30,	Type = 4,	TexturePrefix = "Tongues"},
	[26] = {Name = "元素诅咒",	Length = 300,	Type = 4,	TexturePrefix = "Elements"},
	[27] = {Name = "暗影诅咒",	Length = 300,	Type = 4,	TexturePrefix = "Shadow"},
	[28] = {Name = "生命虹吸",	Length = 30,	Type = 5,	TexturePrefix = nil},
	[29] = {Name = "恐惧嚎叫",	Length = 40,	Type = 3,	TexturePrefix = nil},
	[30] = {Name = "末日仪式",	Length = 3600,	Type = 0,	TexturePrefix = "Doomguard"},
	[31] = {Name = "魔甲术",		Length = 0,	Type = 0,	TexturePrefix = "ArmureDemo"},
	[32] = {Name = "魔息术",		Length = 0,	Type = 0,	TexturePrefix = "Aqua"},
	[33] = {Name = "隐形",		Length = 0,	Type = 0,	TexturePrefix = "Invisible"},
	[34] = {Name = "基尔罗格之眼",	Length = 0,	Type = 0,	TexturePrefix = "Kilrogg"},
	[35] = {Name = "奴役恶魔",	Length = 0,	Type = 0,	TexturePrefix = "Enslave"},
	[36] = {Name = "恶魔皮肤",	Length = 0,	Type = 0,	TexturePrefix = nil},
	[37] = {Name = "召唤仪式",	Length = 0,	Type = 0,	TexturePrefix = nil},
	[38] = {Name = "灵魂链接",	Length = 0,	Type = 0,	TexturePrefix = "Lien"},
	[39] = {Name = "感知恶魔",	Length = 0,	Type = 0,	TexturePrefix = "Radar"},
	[40] = {Name = "疲劳诅咒",	Length = 12,	Type = 4,	TexturePrefix = "Exhaust"},
	[41] = {Name = "生命分流",	Length = 0,	Type = 0,	TexturePrefix = nil},
	[42] = {Name = "诅咒增幅",	Length = 180,	Type = 3,	TexturePrefix = "Amplify"},
	[43] = {Name = "防护暗影结界",	Length = 30,	Type = 3,	TexturePrefix = "ShadowWard"},
	[44] = {Name = "恶魔牺牲",	Length = 0,	Type = 0,	TexturePrefix = "Sacrifice"},
	[45] = {Name = "暗影箭",		Length = 0,	Type = 0,	TexturePrefix = nil},
	[46] = {Name = "痛苦动荡",	Length = 18,	Type = 6,	TexturePrefix = nil},
	[47] = {Name = "狱甲术",		Length = 0,	Type = 0,	TexturePrefix = nil},
	[48] = {Name = "腐蚀种子",	Length = 18,	Type = 5,	TexturePrefix = nil},
	[49] = {Name = "灵魂",		Length = 300,	Type = 3,	TexturePrefix = nil},
	[50] = {Name = "灵魂典礼",	Length = 300,	Type = 3,	TexturePrefix = nil},
	[51] = {Name = "灵魂石",		Length = 0,	Type = 0,	TexturePrefix = nil},
	[52] = {Name = "治疗石",		Length = 0,	Type = 0,	TexturePrefix = nil},
	[53] = {Name = "法术石",		Length = 0,	Type = 0,	TexturePrefix = nil},
	[54] = {Name = "火焰石",		Length = 0,	Type = 0,	TexturePrefix = nil},
	[55] = {Name = "Dark Pact",	Length = 0,	Type = 0,	TexturePrefix = nil},
}
-- Type 0 = No Timer
-- Type 1 = Main permanent Timer
-- Type 2 = Permanent Timer
-- Type 3 = Timer of cooldown
-- Type 4 = Timer of maldiction
-- Type 5 = Timer of fight
-- Type 6 = Timer of combat

for i in ipairs(Necrosis.Spell) do
	Necrosis.Spell[i].Rank = " "
end

-- Types d'unité des PnJ utilisés par Necrosis
Necrosis.Unit = {
	["Undead"] = "亡灵",
	["Demon"] = "恶魔",
	["Elemental"] = "元素"
}

-- Traduction du nom des procs utilisés par Necrosis
Necrosis.Translation.Proc = {
	["Backlash"] = "反冲",
	["ShadowTrance"] = "暗影冥思"
}

-- Traduction des noms des démons invocables
Necrosis.Translation.DemonName = {
	[1] = "小鬼",
	[2] = "虚空行者",
	[3] = "魅魔",
	[4] = "地狱猎犬",
	[5] = "地狱火",
	[6] = "末日守卫",
	[7] = "厄运守卫"
}

-- Traduction du nom des objets utilisés par Necrosis
Necrosis.Translation.Item = {
	["Soulshard"] = "灵魂碎片",
	["Soulstone"] = "灵魂石",
	["Healthstone"] = "治疗石",
	["Spellstone"] = "法术石",
	["Firestone"] = "火焰石",
	["Offhand"] = "装备在副手",
	["Twohand"] = "双手",
	["InfernalStone"] = "地狱火石",
	["DemoniacStone"] = "恶魔雕像",
	["Hearthstone"] = "炉石",
	["SoulPouch"] = {"灵魂袋", "恶魔布包", "熔火恶魔布包"}
}

-- Traductions diverses
Necrosis.Translation.Misc = {
	["Cooldown"] = "冷却时间",
	["Rank"] = "等级",
	["Create"] = ""
}

-- Gestion de la détection des cibles protégées contre la peur
Necrosis.AntiFear = {
	-- Buffs giving temporary immunity to fear effects
	["Buff"] = {
		"恐惧防护结界",	-- Dwarf priest racial trait
		"亡灵意志",	-- Forsaken racial trait
		"反恐惧",	-- Trinket
		"狂怒",		-- Warrior Fury talent
		"鲁莽",		-- Warrior Fury talent
		"死亡之愿",	-- Warrior Fury talent
		"狂野怒火",	-- Hunter Beast Mastery talent (pet only)
		"寒冰屏障",	-- Mage Ice talent
		"圣佑术",	-- Paladin Holy buff
		"圣盾术",	-- Paladin Holy buff
		"战栗图腾",	-- Shaman totem
		"废除魔法"	-- Majordomo (NPC) spell
	},
	-- Debuffs and curses giving temporary immunity to fear effects
	["Debuff"] = {
		"鲁莽诅咒"	-- Warlock curse
	}
}

end
