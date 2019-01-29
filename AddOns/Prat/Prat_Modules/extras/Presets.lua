---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2007  Prat Development Team
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to:
--
-- Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor,
-- Boston, MA  02110-1301, USA.
--
--
-------------------------------------------------------------------------------


--[[
Name: Prat_Presets
Revision: $Revision: 79185 $
Your Name (sylvanaar@mindspring.com)
Author(s):  ( sylvanaar )
Website: http://files.wowace.com/Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#Presets
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: Preset Prat configurations to help get you started (default=off).
Dependencies: Prat
]]


--[[
2007-07-08 fin
--------------
To add your own Preset, check through this file for places marked like this:

-- !! command

These are comments describing what you have to do to add your own preset.
--------------
[17:15:30] [Freenode] [<- sylvanaar] you copy in your sv's, make a function called YourCharName[!!], add a call to it in the build options, and add 2 translations up top
[17:17:02] [Freenode] [<- sylvanaar] just remember to change the variable name of your options, and use that name in your function
[17:21:53] [Freenode] [-> sylvanaar] great, thanks
[17:22:23] [Freenode] [-> sylvanaar] I'm adding those two lines of IRC to the comments in extras/Presets.lua :)

-- !! change YourCharName to your character name
]]


-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratPresets")

if PRAT_MODULE == nil then return end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
	["Presets"] = true,
	["Preset Prat configurations to help get you started"] = true,
	["AllOff_name"] = "All Modules Off",
	["AllOff_desc"] = "Turn everything off so you can just turn on what you want.",
	["BasicTimeStamps_name"] = "Basic Time Stamps",
	["BasicTimeStamps_desc"] = "Enable very basic time stamps in a grey color.",
	["ChannelNameRemove_name"] = "Remove Chat Prefixes",
	["ChannelNameRemove_desc"] = "Removes Guild, Say, Party Prefixes",
	["Sylvaan_name"] = "Sylvaan's Basic Setup",
	["Sylvaan_desc"] = "Enables many of the options that Sylvaan uses",
	["Erestor_name"] = "Erestor's Basic Setup",
	["Erestor_desc"] = "Enables many of the options that Erestor uses",
	["Fin_name"] = "Fin's preset",
	["Fin_desc"] = "Enables the modules that Fin uses",
	["Maziel_name"] = "Maziel's Super Simple Setup",
	["Maziel_desc"] = "Only the bare essentials",

	-- !! copy the following two lines, replacing "YourCharName" with your
	-- !! character's name, when adding your own preset:
	--["YourCharName_name"] = "YourCharName's preset"
	--["YourCharName_desc"] = "YourCharName's preset"
	} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
	["Presets"] = "Voreinstellungen",
	["Preset Prat configurations to help get you started"] = "Prat Konfigurations Voreinstellungen um dir zu helfen neu anzufangen mit Prat",
	["AllOff_name"] = "Alle Modules Aus",
	["AllOff_desc"] = "Schaltet alles aus so das du ausw\195\164hlen kannst was du brauchst.",
	["BasicTimeStamps_name"] = "Einfache Uhrzeitanzeige",
	["BasicTimeStamps_desc"] = "Aktiviert eine einfache Uhrzeitanzeige in grauer Farbe.",
	["ChannelNameRemove_name"] = "Entferne Chat Präfixe",
	["ChannelNameRemove_desc"] = "Entfernt die Gilde, Sagen, Gruppe Präfixe.",
	["Sylvaan_name"] = "Sylvaan's Grund-Setup",
	["Sylvaan_desc"] = "Aktiviert viele der Optionen die Sylvaan benutzt.",
	["Erestor_name"] = "Erestor's Grund-Setup",
	["Erestor_desc"] = "Aktiviert viele der Optionen die Erestor benutzt.",
	} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
	["Presets"] = "프리셋",
	["Preset Prat configurations to help get you started"] = "시작을 돕기 위한 미리 정의된 Prat 환경입니다.",
	["AllOff_name"] = "모든 모듈 끄기",
	["AllOff_desc"] = "당신이 원하는 모듈만 켤 수 있도록 모든 모듈을 끕니다.",
	["BasicTimeStamps_name"] = "기본 타임 스탬프",
	["BasicTimeStamps_desc"] = "회색으로 표시되는 기본 타임스탬프를 사용합니다.",
	["ChannelNameRemove_name"] = "기본 채널명 제거",
	["ChannelNameRemove_desc"] = "길드,일반,파티 채널명 제거",
	["Sylvaan_name"] = "Sylvaan의 기본 설정",
	["Sylvaan_desc"] = "Sylvaan이 사용하는 다양한 설정을 적용합니다.",
	["Erestor_name"] = "Erestor의 기본 설정",
	["Erestor_desc"] = "Erestor가 사용하는 다양한 설정을 적용합니다.",
	["Fin_name"] = "Fin의 기본 설정",
	["Fin_desc"] = "Fin이 사용하는 다양한 설정을 적용합니다.",

	} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
	["Presets"] = "Preajustes",
	["Preset Prat configurations to help get you started"] = "Ajustes preestablecidos para ayudarte a empezar a usar Prat",
	["AllOff_name"] = "Todos los módulos desactivados",
	["AllOff_desc"] = "Desactiva todo para que seas tú quien activa los módulos que quiere.",
	["BasicTimeStamps_name"] = "Horas básicas",
	["BasicTimeStamps_desc"] = "Activa la visualización de la hora en color gris.",
	["ChannelNameRemove_name"] = "Quitar prefijos de chat",
	["ChannelNameRemove_desc"] = "Quita los prefijos de Hermandad, Decir y Grupo",
	} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
	["Presets"] = "預先設定",
	["Preset Prat configurations to help get you started"] = "將 Prat 做預先設定以幫助你開始使用",
	["AllOff_name"] = "關閉所有模組",
	["AllOff_desc"] = "將所有模組都關閉使你可以只開啟想要的",
	["BasicTimeStamps_name"] = "基本時間標籤",
	["BasicTimeStamps_desc"] = "開啟非常基本的灰色時間標籤",
	["ChannelNameRemove_name"] = "移除對話頻道字首",
	["ChannelNameRemove_desc"] = "移除公會、說、隊伍頻道字首",
	["Sylvaan_name"] = "Sylvaan 的基本設定",
	["Sylvaan_desc"] = "啟用 Sylvaan 使用的模組",
	["Erestor_name"] = "Erestor 的基本設定",
	["Erestor_desc"] = "啟用 Erestor 使用的模組",
	["Fin_name"] = "Fin 的基本設定",
	["Fin_desc"] = "啟用 Fin 使用的模組",
	["Maziel_name"] = "Maziel 的簡單設定",
	["Maziel_desc"] = "啟用 Maziel 使用的模組",
	} end)

--Chinese Translation: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com	
L[LIB.NEWLOCALE](L, "zhCN", function() return {
	["Presets"] = "预先设置",
	["Preset Prat configurations to help get you started"] = "从 Prat 预先设置来帮助你开始使用",
	["AllOff_name"] = "关闭所有模块",
	["AllOff_desc"] = "关闭所有模块, 你现在可以开启你所需的功能模块",
	["BasicTimeStamps_name"] = "基本时间标记",
	["BasicTimeStamps_desc"] = "启用以灰色显示的时间标记.",
	["ChannelNameRemove_name"] = "移除对话预先设置",
	["ChannelNameRemove_desc"] = "移除公会、聊天及队伍频道的预先设置",
	["Sylvaan_name"] = "Sylvaan 的个性设置",
	["Sylvaan_desc"] = "启用 Sylvaan 的个性设置",
	["Erestor_name"] = "Erestor 的个性设置",
	["Erestor_desc"] = "启用 Erestor 的个性设置",
	["Fin_name"] = "Fin 的个性设置",
	["Fin_desc"] = "启用 Fin 的个性设置",
	
	} end)	



-- create Prat module
Prat_Presets = Prat:NewModule(PRAT_MODULE)
local Prat_Presets = Prat_Presets
Prat_Presets.pratModuleName = PRAT_MODULE
Prat_Presets.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_Presets.moduleName		= L["Presets"]
Prat_Presets.consoleName	= string.lower(Prat_Presets.moduleName)
Prat_Presets.guiName		= CLR:Colorize("00ff00", Prat_Presets.moduleName)
Prat_Presets.moduleHidden	= true

-- init moduleOoptions (populated by the other various options tables below)
Prat_Presets.moduleOptions = {}

-- debuggery
local function DUMP_MODULE(...) DBG:Dump("MODULE", ...) end

local function WrapForLoD(fx)
    local SetAL = Prat.Options.args.autolod.set

    if AutoLOD then
        SetAL(false)
    end

    Prat:ResetDB("profile")

    Prat_Presets[fx](Prat_Presets)

    if AutoLOD then
        SetAL(true)
    end
end


local function PresetOpt(t, n)
    local wf = n.."_w"
    local n=n
    t[string.lower(n)] = {
        name=L[n.."_name"],
        desc = L[n.."_desc"],
        type="execute",
        handler = Prat_Presets,
        func=wf
        }

    Prat_Presets[wf] = function() WrapForLoD(n) end
end



-- default values for any settings that need them
Prat_Presets.defaultDB = {
	on	= false,
	}


--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

function Prat_Presets:GetModuleOptions()
	self.moduleOptions = {
		type	= "group",
		name	= self.moduleName,
		guiName = self.guiName,
		desc	= L["Preset Prat configurations to help get you started"],
		order	= 349,
		hidden 	= false,
		args	= { },
		}

	local t = self.moduleOptions.args

	PresetOpt(t, "AllOff")
	PresetOpt(t, "Sylvaan")
	PresetOpt(t, "Erestor")
	PresetOpt(t, 'Fin')
	PresetOpt(t, 'Maziel')
	

	-- !! add your Preset options here - and make a corresponding
	-- !! function below
	--PresetOpt(t, 'YourCharName')


	Prat.Options.args.optsep342 = {
		order	= 348,
		type	= 'header',
		}


	Prat.Options.args.presets = self.moduleOptions

	return self.moduleOptions
end





--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--


function Prat_Presets:AllOff()
	for n,m in Prat:IterateModules() do
	    if not m.moduleHidden then
    		m.db.profile.on = false
        else
            m.db.profile.on = true
        end

        Prat:ToggleModuleActive(m, m.db.profile.on)
	end
end




local DB = {
	["namespaces"] = {
		["PratChatLangButton"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratChatLink"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["CustomFilters"] = {
			["profiles"] = {
				["Default"] = {
					["inbound"] = {
						["On"] = {
							["replacewith"] = "ONLINE",
							["hilight"] = true,
							["searchfor"] = "has come online.",
							["hilight_color"] = {
								["b"] = 1,
								["g"] = 0.6470588235294118,
								["r"] = 0.2470588235294118,
							},
						},
						["Off"] = {
							["searchfor"] = "has gone offline.",
							["hilight"] = true,
							["replacewith"] = "OFFLINE",
							["hilight_color"] = {
								["b"] = 0.4980392156862745,
								["g"] = 0.5019607843137255,
								["r"] = 0.4862745098039216,
							},
						},
					},
					["debug"] = false,
					["addpattern"] = "TEST",
					["favorite"] = true,
					["on"] = true,
				},
			},
		},
		["PratChannelColorMemory"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratChannelNames"] = {
			["profiles"] = {
				["Default"] = {
					["shortnames"] = {
						["raidwarning"] = "",
						["channel3"] = "",
						["whisper"] = "",
						["raid"] = "",
						["channel7"] = "",
						["guild"] = "",
						["raidleader"] = "",
						["officer"] = "",
						["party"] = "",
						["channel5"] = "",
						["say"] = "",
						["channel4"] = "",
						["battlegroundleader"] = "",
						["yell"] = "",
						["channel6"] = "",
						["whisperincome"] = "",
						["channel2"] = "",
						["channel1"] = "",
						["battleground"] = "",
					},
					["debug"] = false,
					["replace"] = {
						["channel3"] = false,
					},
					["favorite"] = true,
				},
			},
		},
		["PratChannelSeparator"] = {
			["profiles"] = {
				["Default"] = {
					["BATTLEGROUND"] = {
						[3] = false,
					},
					["RAID"] = {
						[3] = false,
					},
					["debug"] = false,
				},
			},
		},
		["PratChannelSticky"] = {
			["profiles"] = {
				["Default"] = {
					["stickychan"] = true,
					["debug"] = false,
					["smartgroup"] = true,
					["whisper_inform"] = true,
				},
			},
		},
		["PratChatTabs"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratChannelReordering"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["Clear"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratScroll"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratFading"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratPresets"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
					["debug"] = false,
				},
			},
		},
		["PratSounds"] = {
			["profiles"] = {
				["Default"] = {
					["incoming"] = {
						["WHISPER"] = "Bell",
					},
					["debug"] = false,
					["favorite"] = true,
					["on"] = true,
				},
			},
		},
		["PratKeyBindings"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
					["debug"] = false,
				},
			},
		},
		["PratHistory"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = false,
					["debug"] = false,
				},
			},
		},
		["PratServerNames"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["randomclr"] = true,
					["favorite"] = true,
				},
			},
		},
		["PratChatButtons"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratSubstitutions"] = {
			["profiles"] = {
				["Default"] = {
					["favorite"] = true,
					["on"] = true,
					["debug"] = false,
				},
			},
		},
		["minimap"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
					["debug"] = false,
				},
			},
		},
		["PratAltNames"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = true,
				},
			},
		},
		["PratTimestamps"] = {
			["profiles"] = {
				["Default"] = {
					["prepend"] = false,
					["color"] = {
						["r"] = 0.6,
						["g"] = 0.6,
						["b"] = 0.6,
					},
					["formatall"] = "[%X]",
					["format"] = {
						"[%X]", -- [1]
						"[%X]", -- [2]
						"[%X]", -- [3]
						"[%X]", -- [4]
						"[%X]", -- [5]
						"[%X]", -- [6]
						"[%X]", -- [7]
					},
					["debug"] = false,
				},
			},
		},
		["PratFontSize"] = {
			["profiles"] = {
				["Default"] = {
					["sizeall"] = 21,
					["debug"] = false,
					["favorite"] = true,
					["size"] = {
						19, -- [1]
						7, -- [2]
					},
				},
			},
		},
		["PratCopyChat"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["showbutton"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
						true, -- [4]
						true, -- [5]
						true, -- [6]
						true, -- [7]
					},
				},
			},
		},
		["FixBlizzardChannelUnhiding"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PlayerNames"] = {
			["profiles"] = {
				["Default"] = {
					["color"] = {
						["b"] = 0.5294117647058824,
						["g"] = 0.5294117647058824,
						["r"] = 0.5294117647058824,
					},
					["keep"] = false,
					["bracketscommoncolor"] = true,
					["debug"] = false,
					["brackets"] = "Square",
					["altinvite"] = true,
					["subgroup"] = false,
					["linkinvite"] = true,
					["favorite"] = true,
					["bracketscolor"] = {
						["b"] = 0.7529411764705882,
						["g"] = 0.7529411764705882,
						["r"] = 0.7529411764705882,
					},
				},
			},
		},
		["Alias"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratFiltering"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["favorite"] = true,
					["on"] = true,
				},
			},
		},
		["telltarget"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratClear"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratTellTarget"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratChatFrames"] = {
			["profiles"] = {
				["Default"] = {
					["initialized"] = true,
					["debug"] = false,
					["favorite"] = false,
				},
			},
		},
		["PratPopupMessage"] = {
			["profiles"] = {
				["Default"] = {
					["framealpha"] = 0.5,
					["show"] = {
						[1] = true,
					},
					["favorite"] = true,
					["debug"] = true,
				},
			},
		},
		["PratEditbox"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratChatLog"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratUrlCopy"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["color"] = {
						["g"] = 0.5686274509803921,
						["r"] = 0.2588235294117647,
					},
				},
			},
		},
	},
}

-- !! add a copy of your stripped down SVs
local DBERESTOR = {
	["namespaces"] = {
		["PratChatLink"] = {
			["profiles"] = {
				["Default"] = {
					["cm"] = true,
					["on"] = true,
					["favorite"] = true,
				},
			},
		},
		["PratChannelColorMemory"] = {
			["profiles"] = {
				["Default"] = {
					["colors"] = {
						["General"] = {
							["b"] = 0.7529411764705882,
							["g"] = 0.7529411764705882,
							["r"] = 1,
						},
						["Trade"] = {
							["b"] = 0.7529411764705882,
							["g"] = 0.7529411764705882,
							["r"] = 1,
						},
					},
				},
			},
		},
		["PratChannelNames"] = {
			["profiles"] = {
				["Default"] = {
					["shortnames"] = {
						["guild"] = "[Guild]",
						["party"] = "[Party]",
						["whisper"] = "[To]",
						["officer"] = "[Officer]",
						["raidleader"] = "[RaidL]",
						["raid"] = "[Raid]",
						["say"] = "[Say]",
						["whisperincome"] = "[From]",
						["channel2"] = "[Trade]",
						["yell"] = "[Yell]",
						["battlegroundleader"] = "[BgL]",
						["channel1"] = "[General]",
						["battleground"] = "[Bg]",
					},
					["favorite"] = true,
				},
			},
		},
		["PratChannelSeparator"] = {
			["profiles"] = {
				["Default"] = {
					["OFFICER"] = {
						true, -- [1]
					},
				},
			},
		},
		["PratChannelSticky"] = {
			["profiles"] = {
				["Default"] = {
					["raid_warning"] = false,
				},
			},
		},
		["PratScroll"] = {
			["profiles"] = {
				["Default"] = {
					["favorite"] = true,
				},
			},
		},
		["PratPresets"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
				},
			},
		},
		["PratSounds"] = {
			["profiles"] = {
				["Default"] = {
					["incoming"] = {
						["RAID"] = "None",
						["GUILD"] = "None",
						["PARTY"] = "None",
						["WHISPER"] = "TellMessage",
					},
					["on"] = true,
				},
			},
		},
		["PratKeyBindings"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
				},
			},
		},
		["minimap"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
				},
			},
		},
		["PratTimestamps"] = {
			["profiles"] = {
				["Default"] = {
					["formatall"] = "[%X]",
					["format"] = {
						"[%X]", -- [1]
						"[%X]", -- [2]
						"[%X]", -- [3]
						"[%X]", -- [4]
						"[%X]", -- [5]
						"[%X]", -- [6]
						"[%X]", -- [7]
					},
					["favorite"] = true,
				},
			},
		},
		["PratPopupMessage"] = {
			["profiles"] = {
				["Default"] = {
					["nickname"] = {
						"Erestor", -- [1]
					},
					["showall"] = true,
					["show"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
						true, -- [4]
						true, -- [5]
						true, -- [6]
						true, -- [7]
					},
					["favorite"] = true,
				},
			},
		},
		["PratChatButtons"] = {
			["profiles"] = {
				["Default"] = {
					["chatmenu"] = true,
					["chatbutton"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
					},
				},
			},
		},
		["PlayerNames"] = {
			["profiles"] = {
				["Default"] = {
					["keeplots"] = true,
					["level"] = false,
					["linkinvite"] = true,
					["brackets"] = "Square",
				},
			},
		},
		["PratCopyChat"] = {
			["profiles"] = {
				["Default"] = {
					["favorite"] = true,
					["showbutton"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
					},
				},
			},
		},
		["PratChatFrames"] = {
			["profiles"] = {
				["Default"] = {
					["initialized"] = true,
					["favorite"] = true,
				},
			},
		},
		["PratUrlCopy"] = {
			["profiles"] = {
				["Default"] = {
					["favorite"] = true,
				},
			},
		},
		["PratEditbox"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = false,
					["position"] = "BOTTOM",
				},
			},
		},
	},
	["disabledModules"] = {
		["Default"] = {
			["PratChatLangButton"] = true,
			["CustomFilters"] = true,
			["Alias"] = true,
			["PratChannelReordering"] = true,
			["PratEditbox"] = true,
			["PratSubstitutions"] = true,
			["PratAltNames"] = true,
			["PratAddonMsgs"] = true,
			["PratFiltering"] = true,
			["PratChatTabs"] = true,
			["PratChatLog"] = true,
			["PratClear"] = true,
		},
	},
	["profiles"] = {
		["Default"] = {
			["autolod"] = true,
		},
	},
}


local DBMAZIEL = {
   ["namespaces"] = {
      ["PratChatFrames"] = {
         ["profiles"] = {
            ["Default"] = {
               ["initialized"] = true,
            },
         },
      },
      ["PratChannelColorMemory"] = {
         ["profiles"] = {
            ["Default"] = {
               ["colors"] = {
                  ["LocalDefense"] = {
                     ["r"] = 1,
                     ["g"] = 0.7529411764705882,
                     ["b"] = 0.7529411764705882,
                  },
                  ["General"] = {
                     ["r"] = 1,
                     ["g"] = 0.7529411764705882,
                     ["b"] = 0.7529411764705882,
                  },
               },
            },
         },
      },
      ["PratChannelSeparator"] = {
         ["profiles"] = {
            ["Default"] = {
               ["OFFICER"] = {
                  true, -- [1]
                  false, -- [2]
                  false, -- [3]
                  false, -- [4]
                  false, -- [5]
                  false, -- [6]
                  false, -- [7]
               },
               ["RAID"] = {
                  true, -- [1]
                  false, -- [2]
                  false, -- [3]
                  false, -- [4]
                  false, -- [5]
                  false, -- [6]
                  false, -- [7]
               },
               ["BATTLEGROUND"] = {
                  true, -- [1]
                  false, -- [2]
                  false, -- [3]
                  false, -- [4]
                  false, -- [5]
                  false, -- [6]
                  false, -- [7]
               },
            },
         },
      },
      ["PlayerNames"] = {
			["profiles"] = {
				["Default"] = {
					["brackets"] = "Square",				
				},
			},
      },
   },
   ["disabledModules"] = {
      ["Default"] = {
         ["PratChatLangButton"] = true,
         ["PratChatLink"] = true,
         ["PratChatTabs"] = true,
         ["PratChannelReordering"] = true,
      },
   },
}


DBFIN = {
	["namespaces"] = {
		["PratChatLangButton"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
					["debug"] = false,
				},
			},
		},
		["PratChatLink"] = {
			["profiles"] = {
				["Default"] = {
					["clink"] = false,
					["debug"] = false,
					["favorite"] = false,
					["on"] = true,
				},
			},
		},
		["CustomFilters"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
				},
			},
		},
		["ChannelNames"] = {
			["profiles"] = {
				["Default"] = {
					["shortnames"] = {
						["channel2"] = "[2-T]",
						["battlegroundleader"] = "[BG-L]",
						["whisperincome"] = "[<<--]",
						["whisper"] = "[-->>]",
						["channel9"] = "[9-Az]",
						["channel8"] = "[8-H]",
						["channel1"] = "[1-G]",
						["battleground"] = "[BG]",
					},
					["chanSave"] = {
						["raidleader"] = "[Raid Leader] %s: ",
						["raidwarning"] = "[Raid Warning] %s: ",
						["battleground"] = "[Battleground] %s: ",
						["yell"] = "%s yells: ",
						["guild"] = "[Guild] %s: ",
						["battlegroundleader"] = "[Battleground Leader] %s: ",
						["whisperincome"] = "%s whispers: ",
						["say"] = "%s says: ",
						["whisper"] = "To %s: ",
						["raid"] = "[Raid] %s: ",
						["party"] = "[Party] %s: ",
						["officer"] = "[Officer] %s: ",
					},
					["colon"] = false,
				},
			},
		},
		["PratChannelColorMemory"] = {
			["profiles"] = {
				["Default"] = {
					["colors"] = {
						["General"] = {
							["r"] = 0,
							["g"] = 1,
							["b"] = 0.9882352941176471,
						},
						["WorldDefense"] = {
							["b"] = 0.7529411764705882,
							["g"] = 0.7529411764705882,
							["r"] = 1,
						},
						["Hubris"] = {
							["b"] = 0.6392156862745098,
							["g"] = 0.8470588235294118,
							["r"] = 1,
						},
						["Azura"] = {
							["r"] = 1,
							["g"] = 0.8470588235294118,
							["b"] = 0.6392156862745098,
						},
						["GuildRecruitment"] = {
							["b"] = 0.9019607843137255,
							["g"] = 0,
							["r"] = 1,
						},
						["Trade"] = {
							["r"] = 0.8588235294117647,
							["g"] = 1,
							["b"] = 0,
						},
						["LocalDefense"] = {
							["r"] = 1,
							["g"] = 0.7529411764705882,
							["b"] = 0.7529411764705882,
						},
						["LookingForGroup"] = {
							["r"] = 1,
							["g"] = 0.7568627450980392,
							["b"] = 0.6078431372549019,
						},
					},
					["debug"] = false,
					["favorite"] = false,
				},
			},
		},
		["PratChannelNames"] = {
			["profiles"] = {
				["Default"] = {
					["shortnames"] = {
						["channel3"] = "[3:LFG]",
						["channel2"] = "[2:T]",
						["whisperincome"] = "-->",
						["channel9"] = "[9:Hubris]",
						["channel4"] = "[LFG]",
						["whisper"] = "<--",
						["channel1"] = "[1:G]",
					},
					["debug"] = false,
					["replace"] = {
						["channel7"] = false,
						["channel5"] = false,
						["channel6"] = false,
					},
					["favorite"] = true,
				},
			},
		},
		["PratChannelSeparator"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["BATTLEGROUND"] = {
						false, -- [1]
						false, -- [2]
						false, -- [3]
						[5] = false,
						[6] = false,
					},
					["OFFICER"] = {
						nil, -- [1]
						nil, -- [2]
						true, -- [3]
						true, -- [4]
						[7] = true,
					},
					["favorite"] = false,
					["RAID"] = {
						false, -- [1]
						false, -- [2]
						false, -- [3]
						[5] = false,
						[6] = false,
					},
				},
			},
		},
		["PratChannelSticky"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["emote"] = false,
					["yell"] = false,
					["whisper"] = false,
				},
			},
		},
		["StickyChannels"] = {
			["profiles"] = {
				["Default"] = {
					["emote"] = false,
					["whisper"] = false,
				},
			},
		},
		["PratUrlCopy"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["color"] = {
						["g"] = 0.5254901960784314,
						["r"] = 0.1294117647058823,
					},
					["favorite"] = false,
				},
			},
		},
		["PratChannelReordering"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
					["debug"] = false,
					["favorite"] = true,
				},
			},
		},
		["Clear"] = {
			["profiles"] = {
				["Default"] = {
					["favorite"] = false,
					["debug"] = false,
					["on"] = true,
				},
			},
		},
		["PratScroll"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["ctrlscrollspeed"] = 9,
					["normscrollspeed"] = 5,
					["lowdowndelay"] = 30,
					["favorite"] = true,
				},
			},
		},
		["Buttons"] = {
			["profiles"] = {
				["Default"] = {
					["showonframe"] = true,
					["showreminder"] = true,
					["reminder"] = true,
				},
			},
		},
		["PratEditbox"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["undocked"] = {
						["yoff"] = -957.8662719726563,
						["xoff"] = -5.682243824005127,
						["point"] = "TOPLEFT",
						["relativePoint"] = "TOPLEFT",
					},
					["alpha"] = 0.6000000000000001,
					["width"] = 583,
					["clickable"] = true,
					["hideborder"] = true,
					["position"] = "UNDOCKED",
					["favorite"] = true,
					["autohide"] = false,
				},
			},
		},
		["PratFading"] = {
			["profiles"] = {
				["Default"] = {
					["duration"] = 1,
					["debug"] = false,
				},
			},
		},
		["Timestamps"] = {
			["profiles"] = {
				["Default"] = {
					["color"] = {
						["b"] = 0.9254901960784314,
						["r"] = 0.6980392156862745,
					},
					["showmode"] = "INDIVIDUAL",
				},
			},
		},
		["UrlCopy"] = {
			["profiles"] = {
				["Default"] = {
					["color"] = {
						["g"] = 0.6784313725490196,
						["r"] = 0.4862745098039216,
					},
				},
			},
		},
		["Alias"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = true,
					["favorite"] = true,
					["aliases"] = {
						["replyspam"] = "reply sure, nothing much to say really, just reporting a spammer :)",
						["msg"] = "t",
						["i"] = "ludwig",
						["examplehello"] = "say hello there!",
						["rs"] = "readyspells",
						["tr"] = "postman track",
						["wp"] = "waypoint",
						["move"] = "moveit move",
						["t"] = "whisper",
						["tt"] = "t %tn",
						["qc"] = "qfind comments",
						["rs2"] = "replyspam2",
						["tab5show"] = "prat chattabs individual chat5 always visible",
						["fr"] = "freerefills",
						["wiw"] = "alt",
						["tab5hide"] = "prat chattabs individual chat5 hidden",
						["cf"] = "clearfont2d",
						["pt"] = "postman track",
						["replyspam2"] = "reply thanks, nice to hear! cya - stay shiny. :)",
						["track"] = "postman track",
						["tab4show"] = "prat chattabs individual chat4 always visible",
						["n"] = "qnote %pos %tn",
						["la"] = "listaliases",
						["tab4hide"] = "prat chattabs individual chat4 hidden",
						["craftinfo"] = "reply whisper \"!craft <term>\" to search the craftable items for my professions (eg: \"/w %p !craft mana pot\" and I will reply with a list of mana potions I can use and their required components)",
						["tabs"] = "prat chattabs individual",
						["mo"] = "moveit move",
						["tb"] = "tipbuddy",
						["tc"] = "targetcheck",
						["qf"] = "qfind title",
						["xcalc"] = "calc",
					},
				},
			},
		},
		["History"] = {
			["profiles"] = {
				["Default"] = {
					["chatlines"] = {
						1000, -- [1]
						1000, -- [2]
						1000, -- [3]
						1000, -- [4]
						1000, -- [5]
						1000, -- [6]
						1000, -- [7]
					},
				},
			},
		},
		["PratWho"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = false,
					["debug"] = false,
				},
			},
		},
		["PratPresets"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
					["debug"] = false,
				},
			},
		},
		["ChatTabs"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
					["notactivealpha"] = 0.7000000000000001,
				},
			},
		},
		["PratChannelRenumbering"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = false,
					["sortonload"] = false,
				},
			},
		},
		["EventNames"] = {
			["profiles"] = {
				["Default"] = {
					["show"] = {
						[5] = true,
					},
				},
			},
		},
		["ChannelSticky"] = {
			["profiles"] = {
				["Default"] = {
					["whisper"] = false,
					["emote"] = false,
				},
			},
		},
		["PratSounds"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
		["PratKeyBindings"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = true,
				},
			},
		},
		["PratPopupMessage"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = false,
					["debug"] = false,
				},
			},
		},
		["PratServerNames"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = false,
				},
			},
		},
		["PopupMessage"] = {
			["profiles"] = {
				["Default"] = {
					["nickname"] = {
						"Phin", -- [1]
						"Finja", -- [2]
						"Herbey", -- [3]
						"Bitts", -- [4]
					},
					["showall"] = true,
					["on"] = false,
					["show"] = {
						nil, -- [1]
						true, -- [2]
						true, -- [3]
						true, -- [4]
						true, -- [5]
						true, -- [6]
						true, -- [7]
					},
				},
			},
		},
		["PratHistory"] = {
			["profiles"] = {
				["Default"] = {
					["cmdhistory"] = {
					},
					["debug"] = false,
					["saveHistory"] = true,
					["chatlines"] = {
						1000, -- [1]
						1000, -- [2]
						1000, -- [3]
						1000, -- [4]
						1000, -- [5]
						1000, -- [6]
						1000, -- [7]
					},
					["maxlines"] = 1000,
				},
			},
		},
		["PratSubstitutions"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
					["debug"] = false,
					["favorite"] = true,
				},
			},
		},
		["minimap"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = true,
				},
			},
		},
		["PratAltNames"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["pncol"] = false,
					["on"] = true,
					["tooltip_showmain"] = true,
					["tooltip_showalts"] = true,
					["quiet"] = true,
					["alts"] = {
					},
					["favorite"] = true,
					["colour"] = {
						["b"] = 0.3529411764705882,
						["g"] = 0.7333333333333333,
						["r"] = 1,
					},
				},
			},
		},
		["ChannelColorMemory"] = {
			["profiles"] = {
				["Default"] = {
					["colors"] = {
						["GuildRecruitment"] = {
							["b"] = 0.5529412091709673,
							["g"] = 0,
							["r"] = 1.000000059138984,
						},
						["General"] = {
							["r"] = 0,
							["g"] = 0.7843137718737125,
							["b"] = 1.000000059138984,
						},
						["Trade"] = {
							["r"] = 1.000000059138984,
							["g"] = 0.9529412328265607,
							["b"] = 0,
						},
					},
				},
			},
		},
		["AltNames"] = {
			["profiles"] = {
			},
		},
		["telltarget"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = false,
					["debug"] = false,
				},
			},
		},
		["PratTimestamps"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["color"] = {
						["g"] = 0.9294117647058824,
						["r"] = 0,
					},
					["formatall"] = "[%X]",
					["show"] = {
						[5] = false,
					},
					["format"] = {
						"[%X]", -- [1]
						"[%X]", -- [2]
						"[%X]", -- [3]
						"[%X]", -- [4]
						"[%X]", -- [5]
						"[%X]", -- [6]
						"[%X]", -- [7]
					},
					["favorite"] = true,
				},
			},
		},
		["PratFontSize"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["rememberfont"] = true,
					["font"] = "Calibri v1.0",
					["autorestore"] = true,
					["linespacing"] = 1,
					["favorite"] = true,
					["size"] = {
						11, -- [1]
					},
				},
			},
		},
		["PratFiltering"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = true,
				},
			},
		},
		["PratEventNames"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = false,
				},
			},
		},
		["Scrolling"] = {
			["profiles"] = {
				["Default"] = {
					["normscrollspeed"] = 6,
					["ctrlscrollspeed"] = 6,
				},
			},
		},
		["PratJustify"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["favorite"] = false,
					["on"] = false,
				},
			},
		},
		["FixBlizzardChannelUnhiding"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["favorite"] = true,
				},
			},
		},
		["PratChatFrames"] = {
			["profiles"] = {
				["Default"] = {
					["initialized"] = true,
					["minchatwidth"] = 35,
					["debug"] = false,
					["maxchatheight"] = 853,
					["maxchatwidth"] = 1024,
					["favorite"] = true,
				},
			},
		},
		["PratCopyChat"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["favorite"] = true,
					["showbutton"] = {
						true, -- [1]
						true, -- [2]
						true, -- [3]
						true, -- [4]
					},
				},
			},
		},
		["PratAddonMsgs"] = {
			["profiles"] = {
				["Default"] = {
					["on"] = true,
					["debug"] = false,
				},
			},
		},
		["PratChatTabs"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = true,
					["cf"] = {
						nil, -- [1]
						"HIDDEN", -- [2]
					},
					["mode"] = "INDIVIDUAL",
					["favorite"] = true,
					["notactivealpha"] = 0.4,
				},
			},
		},
		["PratClear"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["on"] = true,
				},
			},
		},
		["PratChatButtons"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["reminder"] = true,
					["favorite"] = false,
				},
			},
		},
		["Who"] = {
			["profiles"] = {
				["Default"] = {
					["leave"] = true,
					["join"] = true,
					["gui"] = false,
				},
			},
		},
		["ChatFrames"] = {
			["profiles"] = {
				["Default"] = {
					["initialized"] = true,
					["defaultmaxchatheight"] = 399.9999940395356,
					["defaultminchatheight"] = 74.99999888241293,
					["defaultmaxchatwidth"] = 607.9999833106997,
					["defaultminchatwidth"] = 295.9999994039536,
				},
			},
		},
		["PratChatLog"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
					["combat"] = true,
					["on"] = true,
					["chat"] = true,
				},
			},
		},
		["PratTalented"] = {
			["profiles"] = {
				["Default"] = {
					["debug"] = false,
				},
			},
		},
	},
	["disabledModules"] = {
		["Default"] = {
			["PratSounds"] = true,
			["PratJustify"] = true,
			["PratPopupMessage"] = true,
			["PratServerNames"] = true,
			["PopupMessage"] = true,
			["chatlink"] = true,
			["clear"] = true,
			["telltarget"] = true,
			["AddonMsgs"] = true,
			["PratWho"] = true,
			["channelrenumbering"] = true,
			["PlayerNames"] = true,
			["PratChannelRenumbering"] = true,
			["PratEventNames"] = true,
			["FixBlizzardChannelUnhiding"] = true,
		},
	},
	["currentProfile"] = {
	},
	["profiles"] = {
		["Default"] = {
			["hidestartupspam"] = false,
		},
	},
}


function Prat_Presets:Sylvaan()
	for n,m in Prat:IterateModules() do
	    if not m.moduleHidden then
            local srcprof = DB.namespaces[n] and DB.namespaces[n].profiles.Default
            util:tableMerge(srcprof, m.db.profile, true)
        else
            m.db.profile.on = true
        end

        Prat:ToggleModuleActive(m, m.db.profile.on)
	end
end


function Prat_Presets:Maziel()
	for n,m in Prat:IterateModules() do
	    if not m.moduleHidden then
            local srcprof = DBMAZIEL.namespaces[n] and DBMAZIEL.namespaces[n].profiles.Default
            util:tableMerge(srcprof, m.db.profile, true)
        else
            m.db.profile.on = true
        end

        Prat:ToggleModuleActive(m, m.db.profile.on)
	end
end


 


function Prat_Presets:Erestor()
	for n,m in Prat:IterateModules() do
	    if not m.moduleHidden then
            local srcprof = DBERESTOR.namespaces[n] and DBERESTOR.namespaces[n].profiles.Default
            util:tableMerge(srcprof, m.db.profile, true)
        else
            m.db.profile.on = true
        end

        Prat:ToggleModuleActive(m, m.db.profile.on)
	end
end

function Prat_Presets:Fin()
	for n, m in Prat:IterateModules() do
		if not m.moduleHidden then
		local srcprof = DBFIN.namespaces[n] and DBFIN.namespaces[n].profiles.Default
		util:tableMerge(srcprof, m.db.profile, true)
	else
		m.db.profile.on = true
	end

	Prat:ToggleModuleActive(m, m.db.profile.on)

	end
end

--[[ !! copy and update the following
    local dest = Prat.db.namespaces
    local src  = DB.namespaces
    for k,v in pairs(src) do
        Prat:Print(k)
        local srcprof = v.profiles.Default

        local m = Prat:IsModule(k) and Prat:GetModule(k)

        if m and not m.moduleHidden then
            Prat:ToggleModuleActive(m, false)
            m.db.profile = srcprof
            Prat:ToggleModuleActive(m, true)
        end
    end
end
--]]
