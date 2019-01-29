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
-- Chinese Traditional VERSION FUNCTIONS      --
--  2007/01/02
--  艾娜羅沙@奧妮克希亞
------------------------------------------------

if ( GetLocale() == "zhTW" ) then

-- Table des sorts du démoniste
Necrosis.Spell = {
	[1] = {Name = "召喚地獄戰馬",	Length = 0,	Type = 0},
	[2] = {Name = "召喚恐懼戰馬",	Length = 0,	Type = 0},
	[3] = {Name = "召喚小鬼",		Length = 0,	Type = 0},
	[4] = {Name = "召喚虛空行者",	Length = 0,	Type = 0},
	[5] = {Name = "召喚魅魔",		Length = 0,	Type = 0},
	[6] = {Name = "召喚地獄獵犬",	Length = 0,	Type = 0},
	[7] = {Name = "召喚地獄守衛",	Length = 0,	Type = 0},
	[8] = {Name = "地獄火",		Length = 3600,	Type = 3},
	[9] = {Name = "放逐術",		Length = 30,	Type = 2},
	[10] = {Name = "奴役惡魔",	Length = 300,	Type = 2},
	[11] = {Name = "靈魂石復活",	Length = 1800,	Type = 1},
	[12] = {Name = "獻祭",		Length = 15,	Type = 5},
	[13] = {Name = "恐懼術",		Length = 15,	Type = 5},
	[14] = {Name = "腐蝕術",		Length = 18,	Type = 5},
	[15] = {Name = "惡魔支配",	Length = 900,	Type = 3},
	[16] = {Name = "厄運詛咒",	Length = 60,	Type = 3},
	[17] = {Name = "犧牲",		Length = 30,	Type = 3},
	[18] = {Name = "靈魂之火",	Length = 60,	Type = 3},
	[19] = {Name = "死亡纏繞",	Length = 120,	Type = 3},
	[20] = {Name = "暗影灼燒",	Length = 15,	Type = 3},
	[21] = {Name = "燃燒",		Length = 10,	Type = 3},
	[22] = {Name = "痛苦詛咒",	Length = 24,	Type = 4},
	[23] = {Name = "虛弱詛咒",	Length = 120,	Type = 4},
	[24] = {Name = "魯莽詛咒",	Length = 120,	Type = 4},
	[25] = {Name = "語言詛咒",	Length = 30,	Type = 4},
	[26] = {Name = "元素詛咒",	Length = 300,	Type = 4},
	[27] = {Name = "暗影詛咒",	Length = 300,	Type = 4},
	[28] = {Name = "生命虹吸",	Length = 30,	Type = 5},
	[29] = {Name = "恐懼嚎叫",	Length = 40,	Type = 3},
	[30] = {Name = "末日儀式",	Length = 3600,	Type = 0},
	[31] = {Name = "魔甲術",		Length = 0,	Type = 0},
	[32] = {Name = "魔息術",		Length = 0,	Type = 0},
	[33] = {Name = "隱形",		Length = 0,	Type = 0},
	[34] = {Name = "基爾羅格之眼",	Length = 0,	Type = 0},
	[35] = {Name = "奴役惡魔",	Length = 0,	Type = 0},
	[36] = {Name = "惡魔皮膚",	Length = 0,	Type = 0},
	[37] = {Name = "召喚儀式",	Length = 0,	Type = 0},
	[38] = {Name = "靈魂鏈結",	Length = 0,	Type = 0},
	[39] = {Name = "感知惡魔",	Length = 0,	Type = 0},
	[40] = {Name = "疲勞詛咒",	Length = 12,	Type = 4},
	[41] = {Name = "生命分流",	Length = 0,	Type = 0},
	[42] = {Name = "詛咒增幅",	Length = 180,	Type = 3},
	[43] = {Name = "防護暗影結界",	Length = 30,	Type = 3},
	[44] = {Name = "惡魔犧牲",	Length = 0,	Type = 0},
	[45] = {Name = "暗影箭",		Length = 0,	Type = 0},
	[46] = {Name = "痛苦動盪",	Length = 18,	Type = 6},
	[47] = {Name = "獄甲術",		Length = 0,	Type = 0},
	[48] = {Name = "腐蝕種子",	Length = 18,	Type = 5},
	[49] = {Name = "靈魂",		Length = 300,	Type = 3},
	[50] = {Name = "靈魂典禮",	Length = 300,	Type = 3},
	[51] = {Name = "靈魂石",		Length = 0,	Type = 0},
	[52] = {Name = "治療石",		Length = 0,	Type = 0},
	[53] = {Name = "法術石",		Length = 0,	Type = 0},
	[54] = {Name = "火焰石",		Length = 0,	Type = 0},
	[55] = {Name = "Dark Pact",	Length = 0,	Type = 0},
}
-- Type 0 = Pas de Timer
-- Type 1 = Timer permanent principal
-- Type 2 = Timer permanent
-- Type 3 = Timer de cooldown
-- Type 4 = Timer de mal嶮iction
-- Type 5 = Timer de corruption
-- Type 6 = Timer de combat

for i in ipairs(Necrosis.Spell) do
	Necrosis.Spell[i].Rank = " "
end

-- Types d'unité des PnJ utilisés par Necrosis
Necrosis.Unit = {
	["Undead"] = "不死族",
	["Demon"] = "惡魔",
	["Elemental"] = "元素"
}

-- Traduction du nom des procs utilisés par Necrosis
Necrosis.Translation.Proc = {
	["Backlash"] = "反衝",
	["ShadowTrance"] = "暗影冥思"
}

-- Traduction des noms des démons invocables
Necrosis.Translation.DemonName = {
	[1] = "小鬼",
	[2] = "虛空行者",
	[3] = "魅魔",
	[4] = "地獄獵犬",
	[5] = "地獄火",
	[6] = "末日守衛",
	[7] = "厄運守衛"
}

-- Traduction du nom des objets utilisés par Necrosis
Necrosis.Translation.Item = {
	["Soulshard"] = "靈魂碎片",
	["Soulstone"] = "靈魂石",
	["Healthstone"] = "治療石",
	["Spellstone"] = "法術石",
	["Firestone"] = "火焰石",
	["Ranged"] = "魔杖",
	["Soulbound"] = "舍取后绑定",
	["InfernalStone"] = "地獄火石",
	["DemoniacStone"] = "惡魔雕像",
	["Hearthstone"] = "爐石",
	["SoulPouch"] = {"靈魂袋", "惡魔布包", "熔火惡魔布包"}
}

-- Traductions diverses
Necrosis.Translation.Misc = {
	["Cooldown"] = "冷卻時間",
	["Rank"] = "等級",
	["Create"] = ""
}

-- Gestion de la détection des cibles protégées contre la peur
Necrosis.AntiFear = {
	-- Buffs donnant une immunité temporaire au Fear
	["Buff"] = {
		"恐懼防護結界",	-- Dwarf priest racial trait
		"不死族意志",	-- Forsaken racial trait
		"反恐懼",	-- Trinket
		"狂怒",		-- Warrior Fury talent
		"魯莽",		-- Warrior Fury talent
		"死亡之願",	-- Warrior Fury talent
		"狂野怒火",	-- Hunter Beast Mastery talent
		"寒冰屏障",	-- Mage Ice talent
		"聖佑術",	-- Paladin Holy buff
		"聖盾術",	-- Paladin Holy buff
		"戰慄圖騰",	-- Shaman totem
		"廢除魔法"	-- Majordomo (NPC) spell
	},
	-- Debuffs donnant une immunité temporaire au Fear
	["Debuff"] = {
		"魯莽詛咒"	-- Warlock curse
	}
}

end
