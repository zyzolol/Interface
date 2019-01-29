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
Name: PratTimestamps
Revision: $Revision: 79185 $
Author(s): Curney (asml8ed@gmail.com)
	   Krtek (krtek4@gmail.com)
Inspired by: idChat2_Timestamps by Industrial
Website: http://files.wowace.com/Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#Timestamps
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
SVN: http://svn.wowace.com/wowace/trunk/Prat/
Description: Module for Prat that adds configurable timestamps to chat windows (default=on).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local Prat = Prat

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
local PRAT_MODULE = Prat:RequestModuleName("PratTimestamps")

if PRAT_MODULE == nil then
    return
end
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
	["Timestamps"] = true,
	["Chat window timestamp options."] = true,
	["Set Separately"] = true,
	["Toggle setting options separately for each chat window."] = true,
	["Show Timestamp"] = true,
	["Toggle showing timestamp for each window."] = true,
	["Show ChatFrame%d Timestamp"] = true,
	["Toggle showing timestamp on and off."] = true,
	["show_name"] = "Show Timestamp",
	["show_desc"] = "Toggle showing timestamp on and off for each window.",
	["show_perframename"] = "Show ChatFrame%d Timestamp",
	["show_perframedesc"] = "Toggle showing timestamp on and off.",
	["Format Timestamp"] = true,
	["Set timestamp format (strftime) for each chat window. See here for more details: http://fin.instinct.org/prat/timestamps/"] = true,
	["Format ChatFrame%d Timestamp"] = true,
	["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"] = true,
	["Show All Timestamps"] = true,
	["Toggle showing timestamp for all chat windows."] = true,
	["Format All Timestamps"] = true,
	["Set timestamp format (strftime) for all chat windows. See here for more details: http://fin.instinct.org/prat/timestamps/"] = true,
	["colortimestamp_name"] = "Color Timestamp",
	["colortimestamp_desc"] = "Toggle coloring the timestamp on and off.",
	["Set Timestamp Color"] = true,
	["Sets the color of the timestamp."] = true,
	["localtime_name"] = "Use Local Time",
	["localtime_desc"] = "Toggle using local time on and off.",
	["space_name"] = "Show Space",
	["space_desc"] = "Toggle adding space after timestamp on and off.",
    ["Help"] = true,
    ["How to customize timestamps."] = true,
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79185 $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
	["Timestamps"] = "时间标签",
	["Chat window timestamp options."] = "聊天窗口时间标签选项",
	["Set Separately"] = "独立设置",
	["Toggle setting options separately for each chat window."] = "独立设置各聊天窗口的时间标签选项",
	["Show Timestamp"] = "显示时间标签",
	["Toggle showing timestamp for each window."] = "启用各窗口的时间标签显示",
	["Show ChatFrame%d Timestamp"] = "显示聊天窗口 %d 时间标签",
	["Toggle showing timestamp on and off."] = "切换时间标签显示",
	["show_name"] = "设置",
	["show_desc"] = "显示各窗口的时间标签设置",
	["show_perframename"] = "聊天窗口 %s 时间标签",
	["show_perframedesc"] = "在聊天窗口 %s 显示时间标签",
	["Format Timestamp"] = "时间标签格式",
	["Set timestamp format (strftime) for each chat window. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "设置各窗口的时间标签格式 (strftime 函数格式)。请参考 - http://fin.instinct.org/prat/timestamps/",
	["Format ChatFrame%d Timestamp"] = "聊天窗口 %d 时间标签格式",
	["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"] = "设置聊天窗口 %d 的时间标签格式 (strftime 函数格式)。请参考 - http://fin.instinct.org/prat/timestamps/",
	["Show All Timestamps"] = "全部显示时间标签",
	["Toggle showing timestamp for all chat windows."] = "切换全部聊天窗口的时间标签显示",
	["Format All Timestamps"] = "全部时间标签格式设置",
	["Set timestamp format (strftime) for all chat windows. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "设置所有聊天窗口的时间标签格式 (strftime 函数格式)。请参考 - http://fin.instinct.org/prat/timestamps/",
	["colortimestamp_name"] = "颜色",
	["colortimestamp_desc"] = "时间标签颜色",
	["Set Timestamp Color"] = "颜色设置",
	["Sets the color of the timestamp."] = "设置时间标签的颜色",
	["localtime_name"] = "本地时间",
	["localtime_desc"] = "使用本地时间",
	["space_name"] = "空格",
	["space_desc"] = "在时间标签后显示空格",
	["Help"] = "帮助",
    ["How to customize timestamps."] = "怎样自定义时间标签。",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
	["Timestamps"] = "時間標籤",
	["Chat window timestamp options."] = "聊天視窗時間標籤選項。",
	["Set Separately"] = "個別設定",
	["Toggle setting options separately for each chat window."] = "分別設定各聊天視窗。",
	["Show Timestamp"] = "顯示時間標籤",
	["Toggle showing timestamp for each window."] = "切換是否在各個聊天視窗顯示時間標籤。",
	["Show ChatFrame%d Timestamp"] = "聊天視窗%d顯示時間標籤",
	["Toggle showing timestamp on and off."] = "切換是否顯示時間標籤。",
	["show_name"] = "顯示時間標籤",
	["show_desc"] = "切換是否在各個聊天視窗顯示時間標籤。",
	["show_perframename"] = "聊天視窗%d顯示時間標籤",
	["show_perframedesc"] = "切換是否顯示時間標籤。",
	["Format Timestamp"] = "時間標籤格式",
	["Set timestamp format (strftime) for each chat window. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "設定各個聊天視窗的時間標籤格式 (依 strftime 函式格式)。請參考 - http://fin.instinct.org/prat/timestamps/",
	["Format ChatFrame%d Timestamp"] = "聊天視窗%d時間標籤格式",
	["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"] = "設定時間標籤格式 (依 strftime 函式格式)。請參考 - http://fin.instinct.org/prat/timestamps/",
	["Show All Timestamps"] = "顯示全部時間標籤",
	["Toggle showing timestamp for all chat windows."] = "切換是否在全部的聊天視窗顯示時間標籤。",
	["Format All Timestamps"] = "全部聊天視窗時間標籤格式",
	["Set timestamp format (strftime) for all chat windows. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "設定全部聊天視窗時間標籤格式 (依 strftime 函式格式)。請參考 - http://fin.instinct.org/prat/timestamps/",
	["colortimestamp_name"] = "時間標籤顏色",
	["colortimestamp_desc"] = "切換是否替時間標籤著色。",
	["Set Timestamp Color"] = "顏色設定",
	["Sets the color of the timestamp."] = "設定時間標籤的顏色。",
	["localtime_name"] = "使用本地時間",
	["localtime_desc"] = "切換是否使用本地時間。",
	["space_name"] = "顯示空格",
	["space_desc"] = "切換是否在時間標籤後顯示空格。",
    ["Help"] = "幫助",
    ["How to customize timestamps."] = "怎樣自定時間標籤。",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
	["Timestamps"] = "Affichage de l'heure",
	["Chat window timestamp options."] = "Options pour l'affichage de l'heure devant les messages",
	["Set Separately"] = "Régler séparément",
	["Toggle setting options separately for each chat window."] = "Active/désactive le réglage des options pour chaque fenêtre séparément.",
	["Show Timestamp"] = "Afficher l'heure",
	["Toggle showing timestamp for each window."] = "Affiche/masque l'heure devant chaque message pour chaque fenêtre.",
	["Show ChatFrame%d Timestamp"] = "Fenêtre %d",
	["Toggle showing timestamp on and off."] = "Affiche/masque l'heure devant les messages.",
	["show_name"] = "Afficher",
	["show_desc"] = "Affiche/masque les réglages de l'heure pour chaque fenêtre.",
	["show_perframename"] = "Fenêtre %s ",
	["show_perframedesc"] = "Affiche/masque l'heure devant les messages de la fenêtre %s .",
	["Format Timestamp"] = "Format de l'heure",
	["Set timestamp format (strftime) for each chat window. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "Règle le format de l'heure (strftime) pour chaque fenêtre de discussion. See here for more details: http://fin.instinct.org/prat/timestamps/",
	["Format ChatFrame%d Timestamp"] = "Fenêtre %d",
	["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"] = "Règle le format de l'heure (strftime) pour la fenêtre %d. See here for more details: http://fin.instinct.org/prat/timestamps/",
	["Show All Timestamps"] = "Afficher l'heure partout",
	["Toggle showing timestamp for all chat windows."] = "Afficher l'heure devant les messages de chaque fenêtre",
	["Format All Timestamps"] = "Format de toutes les heures",
	["Set timestamp format (strftime) for all chat windows. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "Règle le format de l'heure (strftime) pour l'ensemble des fenêtres de discussion. See here for more details: http://fin.instinct.org/prat/timestamps/",
	["colortimestamp_name"] = "Coloriser l'heure",
	["colortimestamp_desc"] = "Active/désactive la colorisation de l'heure.",
	["Set Timestamp Color"] = "Couleur",
	["Sets the color of the timestamp."] = "Change la couleur de l'heure.",
	["localtime_name"] = "Utiliser l'heure locale",
	["localtime_desc"] = "Utilise ou non l'heure locale.",
	["space_name"] = "Afficher une espace",
	["space_desc"] = "Affiche/masque l'espace après l'heure..",
	["Help"] = "Aide",
	["How to customize timestamps."] = "La façon de personnaliser l'affichage de l'heure.",
} end)


L[LIB.NEWLOCALE](L, "koKR", function() return {
	["Timestamps"] = "타임스탬프",
	["Chat window timestamp options."] = "대화창 타임스탬프 설정입니다.",
	["Set Separately"] = "구분 설정",
	["Toggle setting options separately for each chat window."] = "각 대화창에 대해 구분 설정을 사용합니다.",
	["Show Timestamp"] = "타임스탬프 표시",
	["Toggle showing timestamp for each window."] = "각 창에 대한 타임스탬프를 표시합니다.",
	["Show ChatFrame%d Timestamp"] = "%d 대화창 타임스탬프 표시",
	["Toggle showing timestamp on and off."] = "타임스탬프 표시를 켜거나 끕니다.",
	["show_name"] = "타임스탬프 표시",
	["show_desc"] = "각 창에 대한 타임스탬프 표시를 켜거나 끕니다.",
	["show_perframename"] = "대화창%d 타임스탬프 표시",
	["show_perframedesc"] = "타임스탬프 표시를 켜거나 끕니다.",
	["Format Timestamp"] = "타임스탬프 형식",
	["Set timestamp format (strftime) for each chat window. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "각 대화창에 대한 타임스탬프 형식을 설정합니다. 보다 자세한 정보 : http://fin.instinct.org/prat/timestamps/",
	["Format ChatFrame%d Timestamp"] = "%d 대화창 타임스탬프 형식",
	["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"] = "타임스탬프의 형식을 설정합니다. 보다 자세한 정보 : http://fin.instinct.org/prat/timestamps/",
	["Show All Timestamps"] = "모든 타임스탬프 표시",
	["Toggle showing timestamp for all chat windows."] = "모든 대화창에 대한 타임스탬프를 표시합니다.",
	["Format All Timestamps"] = "모든 타임스탬프 형식",
	["Set timestamp format (strftime) for all chat windows. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "모든 대화창에 대한 타임스탬프 형식을 설정합니다. 보다 자세한 정보 : http://fin.instinct.org/prat/timestamps/",
	["colortimestamp_name"] = "타임스탬프 색상",
	["colortimestamp_desc"] = "타임스탬프 색상을 켜거나 끕니다.",
	["Set Timestamp Color"] = "타임스탬프 색상 설정",
	["Sets the color of the timestamp."] = "타임스탬프의 색상을 설정합니다.",
	["localtime_name"] = "로컬 시간 사용",
	["localtime_desc"] = "로컬 시간 사용을 켜거나 끕니다.",
	["space_name"] = "공백 표시",
	["space_desc"] = "타임스탬프 뒤에 공백 추가를 켜거나 끕니다.",
	["Help"] = "도움말",
	["How to customize timestamps."] = "사용자 지정 타임스탬프에 대한 사용법입니다.",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
	["Timestamps"] = "Horas",
	["Chat window timestamp options."] = "Opciones de hora para la ventana de chat",
	["Set Separately"] = "Por Separado",
	["Toggle setting options separately for each chat window."] = "Establecer opciones para cada ventana por separado",
	["Show Timestamp"] = "Mostrar Hora",
	["Toggle showing timestamp for each window."] = "Muestra la hora en cada ventana",
	["Show ChatFrame%d Timestamp"] = "Mostrar hora en chat %d",
	["Toggle showing timestamp on and off."] = "Muestra/Oculta la hora.",
	["show_name"] = "Mostrar Hora",
	["show_desc"] = "Muestra/Oculta la hora en cada ventana.",
	["show_perframename"] = "Mostrar hora en %s.",
	["show_perframedesc"] = "Muestra/Oculta la hora en la ventana de %s.",
	["Format Timestamp"] = "Formatear Hora",
	["Set timestamp format (strftime) for all chat windows. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "Establece el formato de hora (strftime) para todas las ventanas de chat. Mirar aqu\195\173 para m\195\161s detalles: http://fin.instinct.org/prat/timestamps/",
	["Format ChatFrame%d Timestamp"] = "Formato de Hora en chat %d",
	["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"] = "Establece el formato de hora (strftime) para la ventana de chat %d. Mirar aqu\195\173 para m\195\161s detalles: http://fin.instinct.org/prat/timestamps/",
	["Show All Timestamps"] = "Mostrar todas las Horas",
	["Toggle showing timestamp for all chat windows."] = "Muestra la hora en todas las ventanas de chat",
	["Format All Timestamps"] = "Formatear todas las Horas",
	["Set timestamp format (strftime) for all chat windows. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "Establece el formato de hora (strftime) para todas las ventanas de chat. Mirar aqu\195\173 para m\195\161s detalles: http://fin.instinct.org/prat/timestamps/",
	["colortimestamp_name"] = "Colorear Hora",
	["colortimestamp_desc"] = "Colorea la Hora",
	["Set Timestamp Color"] = "Color",
	["Sets the color of the timestamp."] = "Cambia el color de la Hora",
	["localtime_name"] = "Usar Hora Local",
	["localtime_desc"] = "Usar Hora Local.",
	["space_name"] = "Mostrar Espacio",
	["space_desc"] = "Muestra un espacio tras la Hora.",
	["Help"] = "Ayuda",
	["How to customize timestamps."] = "Como personalizar la Hora.",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
	["Timestamps"] = "Zeitstempel",
	["Chat window timestamp options."] = "Chatfenster Zeitstempel Optionen",
	["Set Separately"] = "Seperat einstellen",
	["Toggle setting options separately for each chat window."] = "Schaltet die Einstellungsoptionen seperat f\195\188r jedes einzelne Fenster.",
	["Show Timestamp"] = "Zeige Zeitstempel",
	["Toggle showing timestamp for each window."] = "Justiere das Anzeigen der Zeitstempel f\195\188r jedes Fenster.",
	["Show ChatFrame%d Timestamp"] = "Chat %d Zeitstempel Anzeigen",
	["Toggle showing timestamp on and off."] = "Schaltet das Anzeigen des Zeitstempels an und aus.",
	["show_name"] = "Zeige Zeitstempel",
	["show_desc"] = "Schaltet das Anzeigen der Zeitstempel an und aus f\195\188r jedes Fenster.",
	["show_perframename"] = "%s Zeitstempel Anzeigen",
	["show_perframedesc"] = "Schaltet das Anzeigen des Zeitstempels an und aus f\195\188r das %s .",
	["Format Timestamp"] = "Zeitformat Art",
	["Set timestamp format (strftime) for each chat window. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "Stellt das Zeitstempelformat (strfzeit format) f\195\188r jedes Chatfenster ein. Nähere Details unter: http://fin.instinct.org/prat/timestamps/",
	["Format ChatFrame%d Timestamp"] = "Chat %d Zeitstempelformat",
	["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"] = "Stellt das Zeitstempelformat (strfzeit format) f\195\188r das Chatfenster %d ein. Nähere Details unter: http://fin.instinct.org/prat/timestamps/",
	["Show All Timestamps"] = "Zeige Alle Zeitstempel",
	["Toggle showing timestamp for all chat windows."] = "Aktiviert das Anzeigen des Zeitstempels f\195\188r alle Chatfenster.",
	["Format All Timestamps"] = "Formatiere Alle Zeitstempel",
	["Set timestamp format (strftime) for all chat windows. See here for more details: http://fin.instinct.org/prat/timestamps/"] = "Stellt das Zeitstempelformat (strfzeit format) f\195\188r alle Chatfenster ein. Nähere Details unter: http://fin.instinct.org/prat/timestamps/",
	["colortimestamp_name"] = "F\195\164rbe Zeitstempel",
	["colortimestamp_desc"] = "Schaltet das einf\195\164rben des Zeitstempels ein und aus.",
	["Set Timestamp Color"] = "Justiere Zeitstempel Farbe",
	["Sets the color of the timestamp."] = "Justiere die Farbe des Zeitstempels.",
	["localtime_name"] = "Benutze Lokale Zeit",
	["localtime_desc"] = "Schaltet die Benutzung der Lokalen Zeit ein und aus.",
	["space_name"] = "Zeige Leerstelle",
	["space_desc"] = "Aktiviere eine Leerstelle nach dem Zeitstempel.",
    ["Help"] = "Hilfe",
    ["How to customize timestamps."] = "Wie man Zeitstempel personalisiert.",
} end)

local cat = Prat.Categories

Prat_Timestamps = Prat:NewModule(PRAT_MODULE, LIB.HOOKS)
local Prat_Timestamps = Prat_Timestamps
Prat_Timestamps.pratModuleName = PRAT_MODULE
Prat_Timestamps.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

Prat_Timestamps.moduleName = L["Timestamps"]
Prat_Timestamps.consoleName = string.lower(Prat_Timestamps.moduleName)

Prat_Timestamps.formatProvider = "TIMESTAMPS" -- For future use, see PratPlugin-1.0

Prat_Timestamps.defaultDB = {
    on = true,
    show = {true, false, true, true, true, true, true},
    showall = true,
    formatmode = "ALL",
    format = {"%X", "%X", "%X", "%X", "%X", "%X", "%X"},
    formatall = "%X",
    colortimestamp = true,
    color = {
        r = 1,
        g = 1,
        b = 1
    },
    space = true,
    localtime = true,
}

Prat_Timestamps.moduleOptions = {}
Prat_Timestamps.toggleOptions = {
    sep115_sep = 115,
    show_handler = {},
    sep125_sep = 125,
    sep135_sep = 135,
    colortimestamp = 180,
    sep185_sep = 185,
    localtime = 200,
    space = 201,
}

-- Set this to true to use Prat Event Support
--Prat_Timestamps.supportsPratEvents = true

function Prat_Timestamps:GetModuleOptions()
	self.moduleOptions = {
		name = L["Timestamps"],
		desc = L["Chat window timestamp options."],
		type = "group",
		args = {
			separate = {
				name = L["Set Separately"],
				desc = L["Toggle setting options separately for each chat window."],
				type = "toggle",
				order = 90,
				get = function() return self.db.profile.separate end,
				set = function(v) self.db.profile.separate = v end,
			},
			show = {
				name = L["Show Timestamp"],
				desc = L["Toggle showing timestamp for each window."],
				type = "group",
				order = 120,
				args = {
				},
			},
			format = {
				name = L["Format Timestamp"],
				desc = L["Set timestamp format (strftime) for each chat window. See here for more details: http://fin.instinct.org/prat/timestamps/"],
				type = "group",
				order = 121,
				args = {
					chat1 = {
						name = string.format(L["Format ChatFrame%d Timestamp"], 1),
						desc = string.format(L["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"], 1),
						type = "text",
						usage = "<string>",
						get = function() return self.db.profile.format[1] end,
						set = function(v) self.db.profile.format[1] = v end
					},
--					chat2 = {
--						name = string.format(L["Format ChatFrame%d Timestamp"], 2),
--						desc = string.format(L["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"], 2),
--						type = "text",
--						usage = "<string>",
--						get = function() return self.db.profile.format[2] end,
--						set = function(v) self.db.profile.format[2] = v end
--					},
					chat3 = {
						name = string.format(L["Format ChatFrame%d Timestamp"], 3),
						desc = string.format(L["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"], 3),
						type = "text",
						usage = "<string>",
						get = function() return self.db.profile.format[3] end,
						set = function(v) self.db.profile.format[3] = v end
					},
					chat4 = {
						name = string.format(L["Format ChatFrame%d Timestamp"], 4),
						desc = string.format(L["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"], 4),
						type = "text",
						usage = "<string>",
						get = function() return self.db.profile.format[4] end,
						set = function(v) self.db.profile.format[4] = v end
					},
					chat5 = {
						name = string.format(L["Format ChatFrame%d Timestamp"], 5),
						desc = string.format(L["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"], 5),
						type = "text",
						usage = "<string>",
						get = function() return self.db.profile.format[5] end,
						set = function(v) self.db.profile.format[5] = v end
					},
					chat6 = {
						name = string.format(L["Format ChatFrame%d Timestamp"], 6),
						desc = string.format(L["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"], 6),
						type = "text",
						usage = "<string>",
						get = function() return self.db.profile.format[6] end,
						set = function(v) self.db.profile.format[6] = v end
					},
					chat7 = {
						name = string.format(L["Format ChatFrame%d Timestamp"], 7),
						desc = string.format(L["Set format of timestamp (strftime). See here for more details: http://fin.instinct.org/prat/timestamps/"], 7),
						type = "text",
						usage = "<string>",
						get = function() return self.db.profile.format[7] end,
						set = function(v) self.db.profile.format[7] = v end
					},
					help = {
						name	= L["Help"],
						desc	= L["How to customize timestamps."],
						type	= "execute",
						order	= 150,
						func	= function() self:showHelpText() end,
					},
				},
				disabled = function() if not self.db.profile.separate then return true else return false end end,
			},
			showall = {
				name = L["Show All Timestamps"],
				desc = L["Toggle showing timestamp for all chat windows."],
				type = "toggle",
				order = 130,
				get = function() return self.db.profile.showall end,
				set = function(v)
					self.db.profile.showall = v
					for i=1,NUM_CHAT_WINDOWS do
						self.db.profile.show[i] = v
						self:SetFrameStatus(i)
					end
				end,
				disabled = function() if self.db.profile.separate then return true else return false end end,
			},
			formatall = {
				name = L["Format All Timestamps"],
				desc = L["Set timestamp format (strftime) for all chat windows. See here for more details: http://fin.instinct.org/prat/timestamps/"],
				type = "text",
				order = 131,
				usage = "<string>",
				get = function() return self.db.profile.formatall end,
				set = function(v)
					self.db.profile.formatall = v
					for i=1,NUM_CHAT_WINDOWS do
						self.db.profile.format[i] = v
					end
				end,
				disabled = function() if self.db.profile.separate then return true else return false end end,
			},
			setcolor = {
				name = L["Set Timestamp Color"],
				desc = L["Sets the color of the timestamp."],
				type = "color",
				order = 181,
				get = function() return self.db.profile.color.r, self.db.profile.color.g, self.db.profile.color.b end,
				set = function(r, g, b, a) self.db.profile.color.r, self.db.profile.color.g, self.db.profile.color.b = r, g, b end,
				disabled = function() if not self.db.profile.colortimestamp then return true else return false end end,
			},
		},
	}
   	return self.moduleOptions
end

function Prat_Timestamps:OnModuleEnable()
    -- fix menu ordering
    self.moduleOptions.args.show.order = 120
	self.moduleOptions.args.show.disabled = function() if not self.db.profile.separate then return true else return false end end

	if self.db.profile.show == nil then
		self:Debug("DB CORRUPT: show is nil")
		self.db.profile.show = {}
	end

	-- For this module to work, it must hook before Prat
	for i=1,NUM_CHAT_WINDOWS do
		self:Hook(getglobal("ChatFrame"..i), "AddMessage", true)
	end

  	self.secondsDifference = 0
	self.lastMinute = select(2, GetGameTime())
end

--[[------------------------------------------------
	Core Functions
------------------------------------------------]]--
function Prat_Timestamps:AddMessage(frame, text, ...)
	local id = frame:GetID()
	if id ~= 2 and self.db and self.db.profile.show and self.db.profile.show[id] and not Prat.loading then
		text = text and self:InsertTimeStamp(text, id)
	end
	self.hooks[frame].AddMessage(frame, text, ...)
end




function CLR:Timestamp(text)
    local p = Prat_Timestamps.db.profile
    if p.colortimestamp then
        return CLR:Colorize(p.color, text)
    else
        return text
    end
end

function Prat_Timestamps:InsertTimeStamp(text, id)
	if type(text) == "string" then
        local space = self.db.profile.space
        local fmt = self.db.profile.format[id]
        local cf = getglobal("ChatFrame"..id)

        if this and cf:GetJustifyH() == "RIGHT" then
            text = text..(space and " " or "")..CLR:Timestamp(self:GetTime(fmt))
        else
            text = CLR:Timestamp(self:GetTime(fmt))..(space and " " or "")..text
        end
    end

	return text
end

-- Part of the format provider stuff for PratPlugin-1.0
function Prat_Timestamps:Provide(frame)
--    if frame.format_string and frame.space_after then
        local space_after = self.db.profile.space
        local format_string = self.db.profile.format[frame:GetID()]
        return CLR:Timestamp(self:GetTime(format_string))..(space_after and " " or "")
--    end
end



function Prat_Timestamps:GetTime(format)
	if self.db.profile.localtime then
		return date(format)
	else
		local tempDate = date("*t")
		tempDate["hour"], tempDate["min"] = GetGameTime()
		-- taken from FuBar_ClockFu
		if self.lastMinute ~= tempDate["min"] then
			self.lastMinute = select(2, GetGameTime())
			self.secondsDifference = mod(time(), 60)
		end
		tempDate["sec"] = mod(time() - self.secondsDifference, 60)
		return date(format, time(tempDate))
	end
end

-- Useless Code
function Prat_Timestamps:show(id, val)
	if self.db.profile.show == nil then
		self:Debug("DB CORRUPT: show is nil")
		self.db.profile.show = {}
	end
--   We want the hooks positioned relative to prat's hook so prat doesnt see us
--   self:SetFrameStatus(id)
end

-- Dead Code
function Prat_Timestamps:SetFrameStatus(id)


--	if self.db.profile.show[id] then
--		if not self:IsHooked(getglobal("ChatFrame"..id), "AddMessage") then self:Hook(getglobal("ChatFrame"..id), "AddMessage", true) end
--	else
--		if self:IsHooked(getglobal("ChatFrame"..id), "AddMessage") then self:Unhook(getglobal("ChatFrame"..id), "AddMessage") end
--	end
end

function Prat_Timestamps:showHelpText()
	-- should probably stick this in a popup frame; leaving it here for now as it's hopefully useful
	-- also need to update the web page, not sure they're 100% correct
	local helptext = 'Prat_Timestamp allows you to specify the timestamp style for each (or all) chat frames by listing how you want the display, in the format of percentage signs followed by numbers with each letter representing a different value (eg "%H:%M:%S" to display current hour, minute, and second seperated by colons). There are a huge number of potential values available to you, with some of the most common being:\
\
%C\
 - is replaced by (year / 100) as decimal number; single digits are preceded by a zero.\
\
%m\
 - is replaced by the month as a decimal number (01-12).\
\
%I\
 - is replaced by the hour (12-hour clock) as a decimal number (0-12)\
\
%H\
 - is replaced by the hour (24-hour clock) as a decimal number (00-23)\
\
%M\
 - is replaced by the minute as a decimal number (00-59).\
\
%p\
 - is replaced by national representation of either "ante meridiem" or "post meridiem" as appropriate.\
\
%S\
 - is replaced by the second as a decimal number (00-60).\
\
For a comprehensive listing of available timestamp escape characters, please see the following URL:\
\
 - http://groups.google.com/group/wow-prat/web/timestamp-formats'

	if GetLocale() == "koKR" then
	helptext = 'Prat_Timestamp는 각각의 또는 모든 대화창에 대하여 백분률 문자 뒤에 여러 종류의 각각의 값에 대비되는 문자열이 뒤따르는 형식을 이용해 사용자가 원하는 특정한 시간표시 형식을 사용할 수 있습니다, (예 "%H:%M:%S" 는 현재 시간, 분, 초를 콜론마크로 분리해서 표시합니다). 사용 가능한 문자열 형식은 많은 종류가 있지만 일반적으로 사용되는 것은 다음과 같습니다:\
\
%C\
 - 년도 / 100 를 십진수로 표시합니다; 1단위 숫자는 0으로 처리됩니다.\
\
%m\
 - 달을 십진수로 표시합니다(01-12).\
\
%I\
 - 시간을 십진수로 표시합니다. 12시간 단위로 표시됩니다(0-12)\
\
%H\
 - 시간을 십진수로 표시합니다. 24시간 단위로 표시됩니다(00-23)\
\
%M\
 - 분을 십진수로 표시합니다(00-59).\
\
%p\
 - 오전 오후에 대해서 국가별 표현방식에 따라서 표시합니다.\
\
%S\
 - 초 단위를 십진수로 표시합니다(00-60).\
\
사용 가능한 시간표시 형식 문자에 대한 비교 목록은 다음의 URL을 참고하세요:\
\
 - http://groups.google.com/group/wow-prat/web/timestamp-formats'
	 elseif GetLocale() == "zhTW" then
	 	 helptext = "請參考 - http://groups.google.com/group/wow-prat/web/timestamp-formats"
	 end
 	SELECTED_CHAT_FRAME:AddMessage('|cffffe900Prat_Timestamps|r')
 	SELECTED_CHAT_FRAME:AddMessage(helptext)
end
