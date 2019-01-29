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
Name: Prat
Revision: $Revision: 79345 $
Author(s): Sylvaanar (sylvanaar@mindspring.com)
	   Fin (fin@instinct.org)
           Curney (asml8ed@gmail.com)
           Krtek (krtek4@gmail.com)
	   and others (see invidual modules)
Inspired By: idChat2 by Industrial
Website: http://files.wowace.com/Prat/
Documentation: http://www.wowace.com/wiki/Prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Forum: http://www.wowace.com/forums/index.php?topic=6243.0
Discussions: http://groups.google.com/group/wow-prat
SVN: http://svn.wowace.com/wowace/trunk/Prat/
Description: A framework for chat frame modules.
Dependencies: Ace2
]]

LoadAddOn("Prat_ProfileSavedVars")

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

-- Debuging Subsytems
local function DBG_SPLIT(...)   DBG:Debug("SPLIT", ...)   end
local function DBG_RESULT(...)  DBG:Debug("RESULT", ...)  end
local function DBG_PATTERN(...) DBG:Debug("PATTERN", ...) end
local function DBG_OUTPUT(...)  DBG:Debug("OUTPUT", ...)  end
local function DBG_MODULE(...)  DBG:Debug("MODULE",  ...)  end
local function DBG_EXTMSG(...)  DBG:Debug("EXTMSG", ...)  end
local function DBG_LINK(...)    DBG:Debug("LINK", ...) end

local function DUMP_PATTERN(...) DBG:Dump("PATTERN", ...) end
local function DUMP_MODULE(...) DBG:Dump("MODULE", ...) end
local function DUMP_SPLIT(...) DBG:Dump("SPLIT", ...) end
local function DUMP_SPLIT_EX(frame, name, order, ...) DBG:DumpEx("SPLIT", frame, name, order, ...) end
local function DUMP_RESULT(...)  DBG:Dump("RESULT", ...)  end
local function DUMP_RESULT_EX(frame, name, order, ...) DBG:DumpEx("RESULT", frame, name, order, ...) end
local function DUMP_EXTMSG(...) DBG:Dump("EXTMSG", ...) end
local function DUMP_EXTMSG_EX(frame, name, order, ...) DBG:DumpEx("EXTMSG", frame, name, order, ...) end
local function DUMP_OUTPUT(...)  DBG:Dump("OUTPUT", ...)  end
local function DUMP_OUTPUT_EX(frame, name, order, ...) DBG:DumpEx("OUTPUT", frame, name, order, ...) end
local function DUMP_LINK(...)    DBG:Dump("LINK", ...) end

local PratPerf = PerfLib
local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY

local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[LIB.NEWLOCALENAMESPACE](loc, "Prat")

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["Prat"] = true,
    ["A framework for chat frame modules."] = true,
    ["Disabled Modules"] = true,
    ["Enabled Modules"] = true,
    ["toggle"] = true,
    ["Toggle"] = true,
    ["Toggle the module on and off."] = true,
    ["Debugging"] = true,
    ["debug"] = true,
    ["Show debug messages."] = true,
    ["Favorites"] = true,
    ["Module Views"] = true,
    ["Modules By Category"] = true,
    ["Display enabled modules by category. Modules can appear in more than one category."] = true,
    ["Do the actual chat replacement"] = true,
    ["Allows 2.0 modules to make chat replacements. This is required for all modules colored blue."] = true,
    ["Run taint checks"] = true,
    ["Run checks for taint on specific variables"] = true,
    ["Hint: Select 'Favorite' in a module to add it here"] = true,
    ["Favorite"] = true,
    ["Place this module on the favorite's list, and show it on the main menu."] = true,
    ["Updated Modules"] = true,
    ["All Modules"] = true,
    ["No startup spam"] = true,
    ["Hide startup spam"] = true,
    ["AutoLoD"] = true,
    ["Simulate LoD like behaviour. Remember which modules are currently being used, and only load those."] = true,
    ["Reload"] = true,
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79345 $
	$Date: 2007-06-22 20:02:10 +0800 (五, 22 六月 2007) $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["Prat"] = "Prat",
    ["A framework for chat frame modules."] = "聊天窗口增加插件。",
    ["Disabled Modules"] = "禁用模块",
    ["Enabled Modules"] = "启用模块",
    ["toggle"] = "启用",
    ["Toggle"] = "启用",
    ["Toggle the module on and off."] = "切换是否使用此模块",
    ["Debugging"] = "调试",
    ["debug"] = "调试",
    ["Show debug messages."] = "显示调试信息",
    ["Favorites"] = "偏爱",
    ["Module Views"] = "模块浏览",
    ["Modules By Category"] = "依类别",
    ["Display enabled modules by category. Modules can appear in more than one category."] = "按类显示模块,同一个模块会在不同的类别中显示",
    ["Do the actual chat replacement"] = "",
    ["Allows 2.0 modules to make chat replacements. This is required for all modules colored blue."] = "2.0模块来代替默认聊天.显示为蓝色的模块需要启动此项方可生效",
    ["Run taint checks"] = "执行错误检测",
    ["Run checks for taint on specific variables"] = "执行特定的参数错误侦测",
    ["Hint: Select 'Favorite' in a module to add it here"] = "提示: 在一模块中勾选'偏爱'加入此处",
    ["Favorite"] = "喜好",
    ["Place this module on the favorite's list, and show it on the main menu."] = "将此模块加入你偏爱的列单中,并在主选单中显示",
    ["Updated Modules"] = "模块已更新",
    ["All Modules"] = "所有模块",
    ["No startup spam"] = "无启动信息",
    ["Hide startup spam"] = "隐藏启动信息",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["Prat"] = "Prat",
    ["A framework for chat frame modules."] = "대화창 기능에 관한 프레임워크입니다.",
    ["Disabled Modules"] = "사용하지 않는 기능",
    ["Enabled Modules"] = "사용중인 기능",
--    ["toggle"] = true,
    ["Toggle"] = "사용",
    ["Toggle the module on and off."] = "기능 사용 여부를 결정합니다.",
    ["Debugging"] = "디버깅",
--    ["debug"] = true,
    ["Show debug messages."] = "디버그 메세지를 표시합니다.",
    ["Favorites"] = "즐겨찾기",
    ["Module Views"] = "모듈 표시",
    ["Modules By Category"] = "분류별 모듈",
    ["Display enabled modules by category. Modules can appear in more than one category."] = "사용중인 모듈을 분류별로 표시합니다. 각 모듈은 하나 이상의 분류에 나타날 수 있습니다.",
    ["Do the actual chat replacement"] = "강력한 대화 기능을 사용하세요.",
--    ["Allows 2.0 modules to make chat replacements. This is required for all modules colored blue."] = true,
    ["Run taint checks"] = "Taint 검사 실행",
--    ["Run checks for taint on specific variables"] = true,
    ["Hint: Select 'Favorite' in a module to add it here"] = "도움말: 각 모듈의 '즐겨찾기'를 선택하면 여기에 추가됩니다.",
    ["Favorite"] = "즐겨찾기",
    ["Place this module on the favorite's list, and show it on the main menu."] = "이 모듈을 즐겨찾기 목록에 두고 주 메뉴에서 사용하세요.",
    ["Updated Modules"] = "업데이트된 모듈",
    ["All Modules"] = "전체 모듈",
    ["No startup spam"] = "시작시 스팸 숨김",
    ["Hide startup spam"] = "시작시 스팸 메세지를 숨깁니다.",
    ["AutoLoD"] = "자동시작",
    ["Simulate LoD like behaviour. Remember which modules are currently being used, and only load those."] = "Simulate LoD like behaviour. Remember which modules are currently being used, and only load those.",
    ["Reload"] = "재시작",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["Prat"] = "Prat",
    ["A framework for chat frame modules."] = "整合的聊天視窗模組。",
    ["Disabled Modules"] = "已停用模組",
    ["Enabled Modules"] = "已啟用模組",
-- no need to translate    ["toggle"] = true,
    ["Toggle"] = "啟用",
    ["Toggle the module on and off."] = "切換是否使用此模組。",
    ["Debugging"] = "除錯",
-- no need to translate    ["debug"] = true,
    ["Show debug messages."] = "顯示除錯訊息。",
    ["Favorites"] = "常用",
    ["Module Views"] = "模組瀏覽",
    ["Modules By Category"] = "依類別",
    ["Display enabled modules by category. Modules can appear in more than one category."] = "按類別顯示已啟用模組。同一個模組可以在不同的類別中顯示。",
-- no use anymore    ["Do the actual chat replacement"] = true,
-- no use anymore    ["Allows 2.0 modules to make chat replacements. This is required for all modules colored blue."] = true,
-- no use anymore    ["Run taint checks"] = true,
-- no use anymore    ["Run checks for taint on specific variables"] = true,
    ["Hint: Select 'Favorite' in a module to add it here"] = "提示: 在模組中勾選「常用」加入該模組到此處",
    ["Favorite"] = "常用",
    ["Place this module on the favorite's list, and show it on the main menu."] = "將此模組加入你常用的列單中，並在主選單中顯示。",
    ["Updated Modules"] = "已更新模組",
    ["All Modules"] = "所有模組",
    ["No startup spam"] = "無啟動訊息",
    ["Hide startup spam"] = "隱藏啟動訊息",
    ["AutoLoD"] = "自動隨需求載入",
    ["Simulate LoD like behaviour. Remember which modules are currently being used, and only load those."] = "模擬隨需求載入。記住現時使用的模組，並在下次只載入這些模組。",
    ["Reload"] = "重載",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["Prat"] = "Prat",
    ["A framework for chat frame modules."] = "Un entorno para m\195\179dulos de chat.",
    ["Disabled Modules"] = "M\195\179dulos Desactivados",
    ["Enabled Modules"] = "M\195\179dulos Activados",
    ["toggle"] = "activar",
    ["Toggle"] = "Activar",
    ["Toggle the module on and off."] = "Activa y desactiva este m\195\179dulo",
    ["Debugging"] = "Debugging",
    ["debug"] = "debug",
    ["Show debug messages."] = "Mostrar mensajes de debug",
    ["Favorites"] = "Favoritos",
    ["Module Views"] = "Vistas de m\195\179dulo",
    ["Modules By Category"] = "M\195\179dulos por categor\195\173a",
    ["Display enabled modules by category. Modules can appear in more than one category."] = "Muestra los m\195\179dulos activados por categor\195\173as. Los módulos pueden aparecer en m\195\161s de una categor\195\173a",
    ["Do the actual chat replacement"] = "Realizar el reemplazo del chat",
    ["Allows 2.0 modules to make chat replacements. This is required for all modules colored blue."] = "Permite a m\195\179dulos 2.0 realizar reemplazos en el chat. Esto es requerido para todos lo m\195\179dulos de color azul.",
    ["Run taint checks"] = "Iniciar comprobaciones de contaminaci\195\179n",
    ["Run checks for taint on specific variables"] = "Inicia comprobaciones para la contaminaci\195\179n de variables espec\195\173ficas",
    ["Hint: Select 'Favorite' in a module to add it here"] = "Consejo: Elige 'Favorito' en un m\195\179dulo para a\195\177adirlo aqu\195\173",
    ["Favorite"] = "Favorito",
    ["Place this module on the favorite's list, and show it on the main menu."] = "Coloca este m\195\179dulo en la lista de favoritos, y lo muestra en el men\195\186 principal",
    ["Updated Modules"] = "M\195\179dulos Actualizados",
    ["All Modules"] = "Control de Módulos",
    ["No startup spam"] = "Sin spam inicial",
    ["Hide startup spam"] = "Oculta el spam de inicio",
    ["AutoLoD"] = "AutoLoD",
    ["Simulate LoD like behaviour. Remember which modules are currently being used, and only load those."] = "Simula LoD (Leer bajo Demanda). Recuerda que m\195\179dulos est\195\161n siendo utilizados.",
    ["Reload"] = "Recargar",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["Prat"] = "Prat",
    ["A framework for chat frame modules."] = "Ein Grundaddon f\195\188r Chatfenster Module",
    ["Disabled Modules"] = "Deaktivierte Module",
    ["Enabled Modules"] = "Aktivierte Module",
    ["toggle"] = "Aktivieren",
    ["Toggle"] = "Einschalten",
    ["Toggle the module on and off."] = "Schaltet das Modul an und aus.",
    ["Debugging"] = "Pr\195\188fen",
    ["debug"] = "Pr\195\188fe",
    ["Show debug messages."] = "Zeige Pr\195\188fungsnachrichten",
    ["Favorites"] = "Favoriten",
    ["Module Views"] = "Modul Anzeigearten",
    ["Modules By Category"] = "Module nach Kategorien",
    ["Display enabled modules by category. Modules can appear in more than one category."] = "Zeige aktivierte Module nach Kategorie an. Module k\195\182nnen in mehr als nur einer Kategorie erscheinen.",
    ["Do the actual chat replacement"] = "Aktiviere die gegenw\195\164rtigenen Chat\195\164nderrungen",
    ["Allows 2.0 modules to make chat replacements. This is required for all modules colored blue."] = "Erlaubt den 2.0 Modulen ihre Chat Änderungen zu aktivieren. Dies ist Vorraussetzung für alle Blau eingef\195\164rbten Module!",
    ["Run taint checks"] = "F\195\188hre Verf\195\164lschungspr\195\188fungen durch",
    ["Run checks for taint on specific variables"] = "F\195\188hrt Pr\195\188fungen durch ob bestimmte Variablen verf\195\164lscht sind.",
    ["Hint: Select 'Favorite' in a module to add it here"] = "Hinweis: W\195\164hle 'Favorit' in einen Modul um es hier hinzuzuf\195\188gen",
    ["Favorite"] = "Favorit",
    ["Place this module on the favorite's list, and show it on the main menu."] = "F\195\188ge dieses Modul zu der Favoriten Liste hinzu, und zeige es im Hauptmen\195\188 an.",
    ["Updated Modules"] = "Aktualisierte Module",
    ["All Modules"] = "Alle Module",
    ["No startup spam"] = "Kein Spam beim Starten",
    ["Hide startup spam"] = "Versteckt Info Spam im Chat beim Starten von WoW.",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
	["Prat"] = "Prat",
	["A framework for chat frame modules."] = "Une librairie pour les modules de fenêtres de chat.",
	["Disabled Modules"] = "Modules désactivés",
	["Enabled Modules"] = "Modules activés",
	--["toggle"] = true,
	["Toggle"] = "Activer/Désactiver",
	["Toggle the module on and off."] = "Active/désactive le module.",
	["Debugging"] = "Déboguage",
	--["debug"] = true,
	["Show debug messages."] = "Affiche les messages de déboguage.",
	["Favorites"] = "Favoris",
	["Module Views"] = "Liste des modules",
	["Modules By Category"] = "Par catégorie",
	["Display enabled modules by category. Modules can appear in more than one category."] = "Affiche les modules activés par catégorie. Les modules peuvent apparaître dans plus d'une catégorie.",
	["Do the actual chat replacement"] = "Effectuer les remplacements dans les messages",
	["Allows 2.0 modules to make chat replacements. This is required for all modules colored blue."] = "Autoriser les modules 2.0 à remplacer dans les messages. Ceci est requis pour les modules affichés en bleu.",
	["Run taint checks"] = "Vérifier les variables douteuses",
	["Run checks for taint on specific variables"] = "Active des vérifications pour certaines variables douteuses.",
	["Hint: Select 'Favorite' in a module to add it here"] = "Astuce : sélectionnez 'favori' dans un module pour l'ajouter ici",
	["Favorite"] = "Favori",
	["Place this module on the favorite's list, and show it on the main menu."] = "Ajoute ce module à votre liste des favoris et l'affiche dans le menu principal.",
	["Updated Modules"] = "Modules mis à jour",
	["All Modules"] = "Tous les modules",
	["No startup spam"] = "Pas de message au démarrage",
	["Hide startup spam"] = "Masque le texte de démarrage de Prat.",
} end )



local Mixins = {LIB.CONSOLEMENU, 
                LIB.DATASTORE, 
                LIB.EVENTS, 
                LIB.HOOKS, 
                LIB.MODULES}
                 
local ModMixins = {LIB.EVENTS}





if LIB.FIRSTMIXIN then 
	table.insert(Mixins, 1, "Prat")
end

if LIB.DEBUG then 
	table.insert(Mixins, LIB.DEBUG)
	table.insert(ModMixins, LIB.DEBUG)
end

if PRAT_LIBRARY:HasInstance(LIB.DEBUGROUTING) then 
    table.insert(Mixins, LIB.DEBUGROUTING)
    table.insert(ModMixins, LIB.DEBUGROUTING)
end    
                  
local base = PRAT_LIBRARY(LIB.BASE)
Prat = base[LIB.NEW](base, unpack(Mixins))

local Prat = Prat
--(pl.new and pl:new(unpack(Mixins))) or (pl.NewAddon and pl:NewAddon(unpack(Mixins)))


local new, del
do
	local cache = setmetatable({}, {__mode='k'})
	function new()
		local t = next(cache)
		if t then
			cache[t] = nil
			return t
		else
			return {}
		end
	end
	function del(t)
		for k in pairs(t) do
			t[k] = nil
		end
		cache[t] = true
		return nil
	end
end
Prat.new = new
Prat.del = del

Prat.revision = tonumber(string.sub("$Revision: 79345 $", 12, -3))

Prat[LIB.NEWDATABASE](Prat, "PratDB", "PratPerCharDB")

Prat:SetModuleMixins(unpack(ModMixins))

-- Symbolic names for all the events which Prat uses
Prat.Events = {
    MODULE_ENABLED = "Prat_ModuleEnabled",
    MODULE_DISABLED = "Prat_ModuleDisabled",
    DISABLED = "Prat_Disabled",
    ENABLING = "Prat_Starting",
    ENABLED = "Prat_Ready",
    STARTUP = "Prat_Initialized",
    DEBUG_UPDATE = "Prat_DebugModeChanged",
    PRE_OUTBOUND = "Prat_PreOutboundChat",
    OUTBOUND = "Prat_OutboundChat",
    PRE_ADDMESSAGE = "Prat_PreAddMessage",
    POST_ADDMESSAGE = "Prat_PostAddMessage",
    FRAME_MESSAGE = "Prat_FrameMessage",
    SECTIONS_UPDATED = "Prat_ChatSectionsUpdated",
}


-- Part of a system for modules to reports to the core via a callback
-- ENABLED/DISABLED are reported by default - they let the core handle moving the menu
Prat.Notifications = {
    ENABLED = "ENABLED", DISABLED = "DISABLED", UPDATED = "UPDATED"
}

-- Holds the message table when prat is processing
Prat.CurrentMsg = nil

Prat.Colors = {
    BROKEN = "ff8080",
    CONFIRMEDTAINT = "ff2020",
    TAINT =  "ffff20",
    BADINIT = "ffff80",
    BADENABLE = "ffff80",
    PRATEVENTS = "8080ff",
    VERSION2 = "8080ff",
    PROFILING = "80ff80",
    DEBUGGING = "ff8080",
    DEBUGSUBSYS = "ffff80",
    NEEDSCATEGORIES = "ffa0ff",
    HIDDEN = "808080",
    AUTOLOD = "8080ff",
    CATEGORY = "8080ff",
    UPDATED = "60ff60"                 -- This will show which modules were updated since you last ran
}

Prat.VERSION_STRING = L["Prat"].." "..CLR:Colorize(Prat.Colors.VERSION2,"2.0").." ("..CLR:Colorize(Prat.Colors.VERSION2, Prat.revision)..")"

Prat.wowsounds = {
	["TellMessage"] = "TellMessage",
}

Prat.sounds = {
	["TellMessage"] = "TellMessage",
}

local builtinSounds = {
    ["Bell"] = "Interface\\AddOns\\Prat\\sounds\\Bell.mp3",
	["Chime"] = "Interface\\AddOns\\Prat\\Sounds\\Chime.mp3",
	["Heart"] = "Interface\\AddOns\\Prat\\Sounds\\Heart.wav",
	["IM"] = "Interface\\AddOns\\Prat\\Sounds\\IM.mp3",
	["Info"] = "Interface\\AddOns\\Prat\\Sounds\\Info.mp3",
	["Kachink"] = "Interface\\AddOns\\Prat\\Sounds\\Kachink.wav",
	["popup"] = "Interface\\AddOns\\Prat\\Sounds\\Link.wav",
	["Text1"] = "Interface\\AddOns\\Prat\\Sounds\\Text1.wav",
	["Text2"] = "Interface\\AddOns\\Prat\\Sounds\\Text2.wav",
	["Xylo"] = "Interface\\AddOns\\Prat\\Sounds\\Xylo.mp3",
}

local function LoadComponent(name)
    EnableAddOn(name)
    LoadAddOn(name)
end

local media = PRAT_LIBRARY(LIB.MEDIA)
function Prat:RegisterSound(name, path)
    Prat.sounds[name] = path

    media:Register(media.MediaType.SOUND, name, path)
end

function Prat:PlaySound(sound)
	if not sound then return end

	if self.wowsounds[sound] then
		PlaySound(self.wowsounds[sound])
	else
    	local play = self.sounds[sound]
    	if play == nil then
    	    play = media:Fetch(media.MediaType.SOUND, sound)
    	end
    	if play == nil then return end

        PlaySound("GAMEHIGHLIGHTFRIENDLYUNIT") --remove when PlaySoundFile fixed by blizzard
		PlaySoundFile(play)
	end
end

Prat.Frames = {
    ChatFrame1, ChatFrame2, ChatFrame3, ChatFrame4, ChatFrame5, ChatFrame6, ChatFrame7
}

Prat.ExternalFrames = {
}

Prat.HookedFrames = {
    ChatFrame1=true, ChatFrame2=true, ChatFrame3=true, ChatFrame4=true, ChatFrame5=true, ChatFrame6=true, ChatFrame7=true
}

Prat.Favorites = {}

Prat.Modules = {}

Prat.DisabledOptions = {
    order = 322,
    type = 'group',
    name = L["Disabled Modules"],
    desc = L["Disabled Modules"],
    args = {},
    hidden = true,
}

-- Define handler, this has the effect of making Fubar not display its normal options
Prat.Options = {
    name = "Prat",
    desc = L["A framework for chat frame modules."],
    type = "group",
    icon = [[Interface\Addons\Prat\textures\chat-bubble]],
    handler = Prat,
    args = {
        optsep991 = {
            order = 98,
            type = 'header',
            name = L["Favorites"],
        },

        optsep309 = {
            order = 309,
            type = 'header',
        },
        optsep324 = {
            order = 317,
            type = 'header',
            name = L["Module Views"],
        },

--        categorized = {
--            order = 318,
--            type = 'group',
--            name = L["Modules By Category"],
--            desc = L["Display enabled modules by category. Modules can appear in more than one category."],
--            args = {}
--        },

        enabledmods = {
            order = 319,
            type = 'group',
            name = L["Enabled Modules"],
            desc = L["Enabled Modules"],
            args = {}
        },

        togglemods = {
            order = 321,
            type = 'group',
            name = L["All Modules"],
            desc = L["All Modules"],
            args = {},
        },

        optsep341 = {
            order = 340,
            type = 'header',
        },

        autolod = {
            order = 342,
            type = 'toggle',
            name = L["AutoLoD"],
            name_org = L["AutoLoD"],
            desc = L["Simulate LoD like behaviour. Remember which modules are currently being used, and only load those."],
            get = function() return Prat.db.profile.autolod end,
            set = function(v) Prat.db.profile.autolod = AutoLOD:Save(v) end,
            disabled = function() return AutoLOD == nil end,
            hidden = function()
                    local a = Prat.Options.args.autolod
                    local m = AutoLOD and AutoLOD:GetMessage() or ""
                    a.name = a.name_org ..(strlen(m)>0 and (" ("..CLR:Colorize(Prat.Colors.AUTOLOD, m)..")") or "")
                    return AutoLOD == nil
                    end
        },

	hidestartupspam = {
	    order	= 343,
	    type	= 'toggle',
	    name	= L['No startup spam'],
	    name_org	= 'hidestartupspam',
	    desc	= L['Hide startup spam'],
	    get 	= function() return Prat.db.profile.hidestartupspam end,
	    set		= function(v) Prat.db.profile.hidestartupspam = not Prat.db.profile.hidestartupspam end,

	},

        optsep344 = {
            order = 344,
            type = 'header',
            hidden = function() return not Prat.db.profile.debug end,
        },
        debugSubsystem = {
            type = "group",
            order = 345,
            name = "Toggle Subsystem Debugging",
            desc = "Toggle Subsystem Debugging",
            pass = true,
            get  = function(x) return Prat.db.profile.sub_debug[x] end,
            set  = function(x, y)  Prat.db.profile.sub_debug[x] = y  DBG:SetDebug(x, y) end,
            disabled = false,
            hidden = function() return not Prat.db.profile.debug end,
            args = {},

        },
    },
}

Prat.ConsoleOptions = {
    type = 'group',
    name = "Prat",
    icon = [[Interface\Addons\Prat\textures\chat-bubble]],
    handler = Prat,
    desc = L["A framework for chat frame modules."],
    args = {
            enable = Prat.Options.args.togglemods,
            autolod = Prat.Options.args.autolod
    },
}

Prat.WaterfallOptions = {
    type = 'group',
    name = "Prat",
    handler = Prat,
    desc = L["A framework for chat frame modules."],
    args = {
            enable = Prat.Options.args.togglemods,
            autolod = Prat.Options.args.autolod,
            enabledmods = Prat.Options.args.enabledmods
    },
}


--
-- Register the /prat console command
--
Prat[LIB.NEWSLASHCOMMAND](Prat, {"/prat"}, Prat.ConsoleOptions)

function Prat:OnInitialize()
	self[LIB.SETDATABSEDEFAULTS](self, "profile", {
        debug = false,
        dumpSplit = false,
        dumpEventInfo = false,
        dumpSplitPostEvent = false,
        dumpOutputString = false,
        integratedDebugger = false,
        forceDebugModules = false,
		hidestartupspam = true,
        sub_debug = {["*"]=false},
        autolod = false,
        mod_versions = {["*"]=0},
        doReplace = true,
    })

    LoadComponent("Prat_AutoLoD")

    self.title = CLR:Colorize(Prat.Colors.VERSION2, L["Prat"])

    local dopt = Prat.Options.args.debugSubsystem
    local d = self.db.profile.sub_debug
    DBG:SetDebug("PATTERN", d["PATTERN"], dopt)
    DBG:SetDebug("SPLIT",   d["SPLIT"],   dopt)
    DBG:SetDebug("OUTPUT",  d["OUTPUT"],  dopt)
    DBG:SetDebug("MODULE",  d["MODULE"],  dopt)
    DBG:SetDebug("EXTMSG",  d["EXTMSG"],  dopt)
    DBG:SetDebug("RESULT",  d["RESULT"],  dopt)
    DBG:SetDebug("LINK",    d["LINK"],    dopt)

    self.dumping = false

	if LIB.DEBUG then 
	    self:SetDebugging(self.db.profile.debug)
	else
		self.IsDebugging = function() return false end 
		self.SetDebugging = function() end
		self.Debug = function() end
	end

    for k,v in pairs(self.db.profile.sub_debug) do
        DBG:SetDebug(k, v)
    end

    if PratPerf then
       PratPerf:InjectAceOptions(Prat.Options, Prat)
    end

   local o = Prat.Options.args
   for k,v in pairs(o) do
        if o[k].type == "group"
            and type(o[k].disabled) == "nil"
            and type(o[k].handler) == "nil" then

            o[k].disabled = o[k].disabled or "~IsActive"
            o[k].handler = Prat
        end
   end

    -- Register the built in sounds so that all sounds
    -- are registered through the same method
    for k,v in pairs(builtinSounds) do
        self:RegisterSound(k, v)
    end

    self[LIB.REGISTEREVENT](self, Prat.Events.MODULE_ENABLED)
    self[LIB.REGISTEREVENT](self, Prat.Events.MODULE_DISABLED)

    self.Registered = {}

    -- This event says that Prat has initialized and will be starting
    -- up soon (Modules will not see this)
    self[LIB.RAISEEVENT](self, Prat.Events.STARTUP)
    self:BuildCategoryOptionsGroups()

	local cm = PRAT_LIBRARY(LIB.CONSOLEMENU)
    if cm.InjectAceOptionsTable then 
		cm:InjectAceOptionsTable(Prat, Prat.Options)
	end


    -- 2.4 Change
	self.showChatIcons = (GetCVar("showChatIcons") == "1")

    -- { linkid, linkfunc, handler }
    self:RegisterLinkType(  { linkid="rldui", linkfunc=Prat.ReloadUI_Link, handler=Prat }, "Prat")
end

local debugstr = CLR:Colorize(Prat.Colors.DEBUGGING, "DEBUG")
local pratstr = CLR:Colorize(Prat.Colors.VERSION2, "Prat")
Prat.timestart = GetTime()
local timestart = Prat.timestart

function Prat:GetDebugPrefix()
	local output

	if self.dbgcmpt then
    	output = ("(%s: |cff%s%s|r) %s:|cffa0a0a0[%06d]|r"):format( debugstr, Prat.Colors.DEBUGSUBSYS, self.dbgcmpt, pratstr, (GetTime() - timestart))
	else
	    output = ("(%s) %s:|cffa0a0a0[%06d]|r"):format( debugstr, pratstr, (GetTime() - timestart))
    end

    return output
end


--Prat.LoadCallbacks = {}
--function Prat:RegisterLoadCallback(f)
--	self.LoadCallbacks[#self.LoadCallbacks+1] = f
--
--	if self:IsActive() then
--	   self:ScheduleEvent("CallLoadCallbacks", self.CallLoadCallbacks, 0.5, self)
--	end
--end

--function Prat:CallLoadCallbacks()
--	DBG_MODULE("Running load callbacks")
--
--	local num = #self.LoadCallbacks
--	for i = 1, num do
--		self.LoadCallbacks[i]()
--		self.LoadCallbacks[i] = nil
--	end
--end



function Prat:OnEnable(firsttime)
	if not IsAddOnLoaded("FuBar") then
		LoadAddOn("Prat_FuBar")
	end	

    self[LIB.RAISEEVENT](self, Prat.Events.ENABLING)
    
    self:ScheduleEvent("Prat_PostEnable", self.PostEnable, 0.1, self)

    if not self.db.profile.hidestartupspam then
		DEFAULT_CHAT_FRAME:AddMessage("---------- " .. Prat.VERSION_STRING .. " ----------")
    end

    if AutoLOD then
        AutoLOD:Load(self.db.profile.autolod)
    end

	--self:CallLoadCallbacks()
end

function Prat:OnDisable()
	-- Disable all modules
	local name, module = nil, nil
	for name, module in self:IterateModules() do
		self:ToggleModuleActive(module, false)
	end

	self[LIB.RAISEEVENT](self, Prat.Events.DISABLED)
	self:UnregisterAllEvents()
end


function Prat:OnProfileEnable(...)
	local name, module = nil, nil
	for name, module in self:IterateModules() do
	    if not module.moduleHidden then
    	     if self:IsModuleActive(module) then
        		self:ToggleModuleActive(module, false)
        	end
        	self:ToggleModuleActive(module, true)
        end
	end
end

local t = {}
function Prat:PostEnable()
 	-- Enable all modules
	local name, module = nil, nil
	for name, module in self:IterateModules() do
	    if not self:IsModuleActive(module) then
    		self:ToggleModuleActive(module, true)
    	end
	end

    -- Top Level Hook, to supply unique id's 
    -- for each event, and to guard the event flow
	self:RegisterAllEvents("OnEvent")
--	for k,v in pairs(Prat.Frames) do
--		for _,mt in ipairs(v.messageTypeList) do
--			for _,evt in ipairs(ChatTypeGroup[mt]) do
--	    		self[LIB.REGISTEREVENT](self, "OnEvent")
--			end
--		end
--	end


	-- 2.4 Changes
	self:RegisterEvent("CVAR_UPDATE")

    -- Inbound Hooking
    self[LIB.HOOK](self, "ChatFrame_MessageEventHandler", true)

    -- Outbound hooking
    self[LIB.SECUREHOOK](self, "ChatEdit_ParseText")

    -- Display Hooking
    for _,v in pairs(Prat.Frames) do
        self[LIB.HOOK](self, v, "AddMessage", true)
    end

    -- ItemRef Hooking
    self[LIB.HOOK](self, "SetItemRef", true)


    self.dumping = false
    -- This event fires after Prat's hooks are installed
    -- Prat's core wont operate until after this event
    self[LIB.RAISEEVENT](self, Prat.Events.SECTIONS_UPDATED)
    self[LIB.RAISEEVENT](self, Prat.Events.ENABLED)

end

function Prat:CVAR_UPDATE()
	if arg1 == "SHOW_CHAT_ICONS" then
		if ( tonumber(arg2) == 1 ) then
			self.showChatIcons = true;
		else
			self.showChatIcons = false;
		end
	end
end

-- Unique ID given to all CHAT_MSG events
Prat.EVENT_ID = 0

function Prat:OnEvent(...)
    local event = PRAT_LIBRARY(LIB.EVENTS).currentEvent
    
     -- for CHAT_MSG we will wrap the hook chain to provide a unique EVENT_ID
     if type(event) == "string" and event ~= "CHAT_MSG_ADDON" and strsub(event, 1, 8) == "CHAT_MSG" then
         self.EVENT_ID = self.EVENT_ID + 1  
     end
end

-- Unique ID given to all CHAT_MSG events
-- now supported by AceEvent instead of PRAT_LIBRARY("AceEvent-2.0").currentEventUID.

function Prat:GetEventID()
    return Prat.EVENT_ID
--    return PRAT_LIBRARY("AceEvent-2.0").currentEventUID
end



function Prat:IsProfiling()
    return PratPerf and PratPerf:IsProfiling() or false
end

function Prat:BuildCategoryOptionsGroups()
--    local base = Prat.Options.args.categorized.args
--
--    for k,v in pairs(Prat.Categories) do
--        base[k] = { name = v, desc = v, type = "group", args = {},
--        hidden =
--            function()
--                local t = base[k].args
--                local hide = true
--                for k,v in pairs(t) do
--                    hide = false
--                end
--                return hide
--            end
--         }
--    end
end


Prat.SplitMessageOut = {
    MESSAGE = "",
    TYPE = "",
    TARGET = "",
    CHANNEL = "",
    LANGUAGE = "",
}

function Prat:ChatEdit_ParseText(editBox, send)
    local command = editBox:GetText()

-- this is what blizzard does
	local cmd = command:match("^(#%s*[Ss][Hh][Oo][Ww]:*)%s[^%s]") or
	                command:match("^(#%s*[Ss][Hh][Oo][Ww][Tt][Oo][Oo][Ll][Tt][Ii][Pp]:*)%s[^%s]") or
	                command:match("^(/[^%s]+)");

-- Hack from blizzard's code
	if ( cmd and strfind(cmd, "^#") ) then
		-- This is a hack, but the "USE" code below handles bags and slots
		cmd = SLASH_USE1;
	end

    if cmd and IsSecureCmd(cmd) then
        DBG_PATTERN("The command is secure.", cmd)
		return
	end

    local m = Prat.SplitMessageOut
    self.CurrentMsg = m


    m.MESSAGE = command

    m.CTYPE = editBox:GetAttribute("chatType")
    m.TARGET = editBox:GetAttribute("tellTarget")
    m.CHANNEL = editBox:GetAttribute("channelTarget")
    m.LANGUAGE = editBox.language
    m.SEND = send

    if send ~= 1 then
        return
    end

    DUMP_SPLIT("Pre_Process", m)
    Prat:ProcessUserEnteredChat(m)
    DUMP_SPLIT("Post_Process", m)

    editBox:SetAttribute("chatType", m.CTYPE)
    editBox:SetAttribute("tellTarget", m.TARGET)
    editBox:SetAttribute("channelTarget", m.CHANNEL)


    editBox:SetText(m.MESSAGE)
    
    self.CurrentMsg = nil
end


function Prat:ProcessUserEnteredChat(m)
    if (strlen(m.MESSAGE) <= 0) then
    	return
    end

    self[LIB.RAISEEVENT](self, Prat.Events.PRE_OUTBOUND, m)


    -- Remove all the pattern matches ahead of time
    m.MESSAGE = self:MatchPatterns(m.MESSAGE, "OUTBOUND")

    self[LIB.RAISEEVENT](self, Prat.Events.OUTBOUND, m)

   -- Pattern Matches Put Back IN
    m.MESSAGE = self:ReplaceMatches(m.MESSAGE, "OUTBOUND")
end



local tmp_info = {}

Prat.PatternRegistry = {}
Prat.PatternOwners = {}

-- Register a pattern with the pattern matching engine
-- You can supply a priority 1 - 100. Default is 50
-- 1 = highest, 100 = lowest.
-- pattern = { pattern, matchfunc, priority, type}
--
-- Priorities arent used currently, they are to help with
-- collisions later on if there are alot of patterns
--
function Prat:RegisterPattern(pattern, who)
    table.insert(self.PatternRegistry, pattern)
    local idx = #self.PatternRegistry
    pattern.idx = idx

    DUMP_PATTERN("RegisterPattern", who, pattern)

    self.PatternOwners[#self.PatternRegistry] = who

    return idx
end


function Prat:UnregisterAllPatterns(who)
    DBG_PATTERN("UnregisterAllPatterns", who)

    local owner
    for k, owner in pairs(self.PatternOwners) do
        if owner == who then
            self:UnregisterPattern(k)
        end
    end
end

function Prat:GetPattern(idx)
    return self.PatternRegistry[idx]
end

function Prat:UnregisterPattern(idx)
    table.remove(self.PatternRegistry, idx)
end

function Prat:RegisterMatch(text, ptype)
    if type(ptype) == "nil" then
        ptype = "FRAME"
    end

    local token = "@##"..Prat.tokennum.."##@"

    DBG_PATTERN("RegisterMatch", text, token)

    if type(Prat.MatchTable[ptype]) ~= "table" then
        Prat.MatchTable[ptype] = {}
    end

    local mt = Prat.MatchTable[ptype]
    mt[token] = text
    Prat.tokennum = Prat.tokennum + 1
    return token
end

function Prat:MatchPatterns(text, ptype)
    if type(ptype) == "nil" then
        ptype = "FRAME"
    end

    Prat.tokennum = 1

    DBG_PATTERN("MatchPatterns -->", text, Prat.tokennum)

    -- Match and remove strings
    for _, v in ipairs(self.PatternRegistry) do
        if text and ptype == (v.type or "FRAME") then
            if type(v.pattern) == "string" and strlen(v.pattern) > 0 then
                if v.deformat then 
                    text = v.matchfunc(text)
                else
                    text = string.gsub (text, v.pattern, v.matchfunc)
                end
            end
        end
    end

    DBG_PATTERN("MatchPatterns <--", text, Prat.tokennum)

    return text
end

Prat.MatchTable = {}
function Prat:ReplaceMatches(text, ptype)
    if type(ptype) == "nil" then
        ptype = "FRAME"
    end

    -- Substitute them (or something else) back in

    if type(Prat.MatchTable[ptype]) ~= "table" then
        Prat.MatchTable[ptype] = {}
    end
    local mt = Prat.MatchTable[ptype]

    DBG_PATTERN("ReplaceMatches -->", text)
    for k,v in pairs(mt) do
        text = string.gsub(text, k, v)
        mt[k] = nil
    end

    DBG_PATTERN("ReplaceMatches <--", text)

    return text
end







Prat.LinkRegistry = {}
Prat.LinkOwners = {}

-- linktype = { linkid, linkfunc, handler }
function Prat:RegisterLinkType(linktype, who)
    if linktype and linktype.linkid and linktype.linkfunc then
        table.insert(self.LinkRegistry, linktype)

        local idx = #self.LinkRegistry

        DBG_LINK("RegisterLinkType", who, linktype.linkid, idx)

        if idx then
            self.LinkOwners[idx] = who
        end

        return idx
    end
end


function Prat:UnregisterAllLinkTypes(who)
    DBG_LINK("UnregisterAllLinkTypes", who)

    local owner
    for k, owner in pairs(self.LinkOwners) do
        if owner == who then
            self:UnregisterLinkType(k)
        end
    end
end

function Prat:UnregisterLinkType(idx)
    table.remove(self.LinkRegistry, idx)
end


function Prat:GetReloadUILink(Requestor)
    return self:BuildLink("rldui", Requestor or "Prat", L["Reload"], "ffa0a0")
end

function Prat:ReloadUI_Link(link, text, button)
    ReloadUI()
    return false
end

function Prat:SetItemRef(link, ...)
    DUMP_LINK("SetItemRef ", link, ...)
    
    for i,reg_link in ipairs(self.LinkRegistry) do
        if reg_link.linkid == strsub(link, 1, strlen(reg_link.linkid)) then
            if (reg_link.linkfunc(reg_link.handler, link,  ...) == false) then
                DUMP_LINK("SetItemRef ", "Link Handled Internally")
                return false
            end
        end
    end

    self.hooks.SetItemRef(link, ...)
end

Prat.last = {}
Prat.SplitMessageOrg = {}

function Prat:ClearChatSections(message)
    for k,v in pairs(message) do
        message[k] = self.SplitMessageSrc[k] and "" or nil
    end
end

local t = {}
function Prat:BuildChatText(message, index)
    local index = index or self.SplitMessageIdx
    local s = message

    for k in pairs(t) do
        t[k] = nil
    end

    for i,v in ipairs(index) do
        local part = s[v]
        if type(part) == "string" and strlen(part) > 0 then
            table.insert(t, part)
        end
    end

    return table.concat(t, "")
end




local eventMap = {
    CHAT_MSG_CHANNEL = true,
    CHAT_MSG_SAY = true,
    CHAT_MSG_GUILD = true,
    CHAT_MSG_WHISPER = true,
    CHAT_MSG_WHISPER_INFORM = true,
    CHAT_MSG_YELL = true,
    CHAT_MSG_PARTY = true,
    CHAT_MSG_OFFICER = true,
    CHAT_MSG_RAID = true,
    CHAT_MSG_RAID_LEADER = true,
    CHAT_MSG_RAID_WARNING = true,
    CHAT_MSG_BATTLEGROUND = true,
    CHAT_MSG_BATTLEGROUND_LEADER = true,
    CHAT_MSG_SYSTEM = true,
    CHAT_MSG_DND = true,
    CHAT_MSG_AFK = true,
}

function Prat:EnableProcessingForEvent(event, flag)
    if flag == nil or flag == true then 
        eventMap[event] = true
    else
        eventMap[event] = nil
    end
end

function Prat:EventIsProcessed(event)
    return eventMap[event] or false
end

function Prat:ChatFrame_MessageEventHandler(event)
	local this = this

    if not Prat.HookedFrames[this:GetName()] then
        return
    end
	
    local message, info
    local process = eventMap[event]

    local CMEResult
	
	if type(arg1) == "string" and strfind(arg1, "\r") then	 -- Stupid exploit. Protect our users.
		arg1 = gsub(arg1, "\r", " ")
	end

    if self:IsDebugging() then
        self.last = self.last or {}
        self.last.event = event
        for i=1,10 do
            self.last["arg"..i] = getglobal("arg"..i)
        end

        --self:Debug(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        if self.db.profile.dumpEventInfo then
            self:ConsoleDump(this, nil, "Event Args", nil, Prat.last)
        end
    end

	-- Create a message table. This table contains the chat message in a non-concatenated form
    -- so that it can be modified easily without lots of complex gsub's
    message, info = self:SplitChatMessage(this, event)

	-- Handle Default-UI filtering: Since the default UI now provides filtering functions 
	-- similar to the way Prat's pattern registry works, we need to be sure not to call the 
    -- filtering functions twice by calling back into the hook chain - otherwise you could
    -- have side effects of the handler functions being called more than once for a given event.
    -- I don't see any way around this.
	if type(message) == "boolean" and message == true then
		return true	
	end

    if not info then
       return self.hooks["ChatFrame_MessageEventHandler"](event)
    else
        local m = Prat.SplitMessage
        self.CurrentMsg = m

        -- Prat_FrameMessage is fired for every message going to the
        -- chatframe which is displayable (has a chat infotype)
        -- It may not be displayed, in which case no Pre/Post Addmessage
        -- events will fire
        -- Any addons which hook things will operate following this event
        -- but before Prat_PreAddMessage, OUTPUT will contain the chat line
        -- it may be modified by other addons.
        --
        -- Right now, prat will discard the chat line for chat types that
        -- it is handling
        --
        m.OUTPUT  = nil

        m.DONOTPROCESS = nil

        DUMP_OUTPUT_EX(this, "Prat_FrameMessage", nil, nil, m.CAPTUREOUTPUT, m.OUTPUT)

        self[LIB.RAISEEVENT](self, Prat.Events.FRAME_MESSAGE, message, this, event)

        -- A return value of true means that the message was processed
        -- normally this would result in the OnEvent returning
        -- for that chatframe
        m.CAPTUREOUTPUT = true
        CMEResult = self.hooks["ChatFrame_MessageEventHandler"](event)
        m.CAPTUREOUTPUT = false

        DBG_OUTPUT("CMEResult", CMEResult)
        if type(m.OUTPUT) == "string" and not m.DONOTPROCESS then
            local r,g,b,id = self.INFO.r, self.INFO.g, self.INFO.b, self.INFO.id

            -- Remove all the pattern matches ahead of time
            m.MESSAGE = self:MatchPatterns(m.MESSAGE)

            DUMP_OUTPUT("Prat_PreAddMessage", m)
            self[LIB.RAISEEVENT](self, Prat.Events.PRE_ADDMESSAGE, message, this, event, self:BuildChatText(message), r,g,b,id )

            if self:IsDebugging() then
                DUMP_PATTERN(self.MatchTable)

                for k,v in pairs(m) do
                    if v == "" then m[k] = nil end
                end

                DUMP_RESULT_EX(this, "SplitMessage", self.SplitMessageIdx, m)

                self:ValidateMessageTable(m)
            end


            -- Pattern Matches Put Back IN
            m.MESSAGE = self:ReplaceMatches(m.MESSAGE)

            if process then
                -- We are about to send the message
                m.OUTPUT  = self:BuildChatText(message) -- Combine all the chat sections

                -- If process is set we have a split table
                -- If not then we have 1 string for the whole chatline
                DUMP_OUTPUT("AddMessage - build", m)
            else
                if type(m.OUTPUT) == "string" then
                    -- Now we have the chatstring that the client was planning to output
                    -- For now just do it. (Tack on POST too)
                    m.OUTPUT  = (m.PRE or "")..m.OUTPUT..(m.POST or "")

                    DUMP_OUTPUT("AddMessage - pass", m)
                end
			end			

            -- Allow for message blocking during the patern match phase
            if not m.DONOTPROCESS then 
				this:AddMessage(m.OUTPUT, r,g,b,id);
            end
            
            -- We have called addmessage by now, or we have skipped it
			-- regardless, we call postaddmessage. This was changed to allow
            -- for more flexibility in the customfilters module, speficially
            -- it allows for replacements to occur in blocked messages
            DUMP_OUTPUT("Prat_PostAddMessage", m)

            self[LIB.RAISEEVENT](self, Prat.Events.POST_ADDMESSAGE,  m, this, event, m.OUTPUT, r,g,b,id)

        end

        m.CAPTUREOUTPUT = nil
        m.OUTPUT  = nil
        m.INFO = nil

        self.CurrentMessage = nil
    end

    return CMEResult
end


--function Prat:AddMessage(frame, text, r, g, b, id)
Prat.INFO = {r = 1.0, g = 1.0, b = 1.0, id = 0 }

function Prat:AddMessage(frame, text, r, g, b, id, ...)
    local s = Prat.SplitMessage
    if s.OUTPUT == nil and s.CAPTUREOUTPUT and Prat.dumping == false then
        self.INFO.r, self.INFO.g, self.INFO.b, self.INFO.id = r, g, b, id
        s.OUTPUT = text
        s.INFO = Prat.INFO
    else
        Prat.hooks[frame].AddMessage(frame, text, r, g, b, id, ...)
    end
end

function Prat:DumpOutputString(label, m)
    if self.db.profile.dumpOutputString then
        local so = m.OUTPUT
        local sc = m.CAPTUREOUTPUT

        self:ConsoleDump(this, label,  nil, m.CAPTUREOUTPUT, m.OUTPUT)

        if so == nil and sc ~= nil then
        else
            m.OUTPUT = so
            m.CAPTUREOUTPUT = sc
        end
    end
end

-- This is the structure of the chat message once it is split
-- section delimiters are uppercase inside and lower case outside
-- ie.   cC CHANNEL Cc =  [ channame ]
Prat.SplitMessageSrc = {
    PRE = "",

	nN = "",
	CHANLINK = "",
	NN = "",

    cC = "",
        CHANNELNUM = "",
        CC = "",
        CHANNEL = "",
        zZ = "",
            ZONE = "",
        Zz = "",
    Cc = "",

    TYPEPREFIX = "",

	Nn = "",

    fF = "",
        FLAG = "",
    Ff = "",

    pP = "",
        lL = "",  -- link start
        PLAYERLINK= "",
        PLAYERLINKDATA = "",
        LL = "", --  link text start

        PREPLAYER = "",
        PLAYER = "",

        sS = "",
            SERVER = "",
        Ss = "",
        POSTPLAYER = "",

        Ll = "",  -- link text end
    Pp = "",

    TYPEPOSTFIX = "",

    mM = "",
        gG = "",
        LANGUAGE = "",
        Gg = "",
        MESSAGE = "",
    Mm = "",

    POST = "",
}

-- All the separators owned by an info-item
-- this is case insensitive, so "xx" will include "XX", "xX", "Xx", "xx"
-- This can be used to empty the separator nodes when the main info-item
-- is empty or gets emptied
Prat.Separators = {
    ZONE = "zz",
    SERVER = "ss",
    MESSAGE = "mm",
    LANGUAGE = "gg",
    PLAYERLINK = "ll",
    FLAG = "ff",
    CHANNEL = "cc",
    PLAYER = "pp",
}

-- Remove an info-item from the split
function Prat:ClearSplitItem(split, item)
    if item and split and split[item] then
        local seps = Prat.Separators[item]

        split[item] = ""
        if seps then
            for k,v in pairs(split) do
                if strlower(k) == seps then
                    v = ""
                end
            end
        end
    end
end


function Prat:RegisterMessageItem(itemname, aftervar)
	--[[ RegisterMessageItem:

		API to allow other modules to inject new items into the components
		making up a chat message. Primarily intended to help resolve
		conflicts between modules.

		 - itemname  = name of the variable to be injected

		 - aftervar  = the position in the chat message after which the item
		               will be displayed

		Leave aftervar blank to position the item at the beginning of the list.

		If you would like to change the item's position in the chat message,
		call :RegisterMessageItem() again with a different value for aftervar.

		Example:
		--------

		The mod Prat_ExampleMod counts the number of times people
		say the word "Example" and you would like to display the count
		for a player before their name in a chat message. Default chat
		message structure contains:

			... cC CHANNEL Cc .. pP PLAYER Pp ...

		This means that the module should use the following:

			Prat:RegisterMessageItem('NUMEXAMPLES', 'Cc')

		Which would then alter the structure of chat messages to be:

			.. CHANNEL Cc .. NUMEXAMPLES .. pP PLAYER ...

]]

	local pos = 1

	if Prat.SplitMessageSrc[itemname] then
		self:ResetSeparators(itemname)

		local oldpos = self:GetMessageItemIdx(itemname)

		if oldpos ~= 0 then
			table.remove(Prat.SplitMessageIdx, oldpos)
		end
	end

	pos = aftervar and self:GetMessageItemIdx(aftervar) + 1 or pos

	table.insert(Prat.SplitMessageIdx, pos, itemname)
	Prat.SplitMessageSrc[itemname] = ""
end


function Prat:UnregisterMessageItem(itemname)
	self:ResetSeparators(itemname)

	Prat.SplitMessageSrc[itemname]	= nil
	Prat.SplitMessage[itemname]	= nil

  	table.remove(Prat.SplitMessageIdx, self:GetMessageItemIdx(itemname))

	-- Prat.Seperators[itemname]	= nil
end


function Prat:ResetSeparators(itemname)
	if Prat.Separators[itemname] then
		local sepstr = string.lower(Prat.Separators[itemname])

		for i, v in ipairs(Prat.SplitMessageIdx) do
			if v:lower() == sepstr then
				Prat.SplitMessage[v]	= nil
				Prat.SplitMessageSrc[v]	= nil
				table.remove(Prat.SplitMessageIdx, i)
			end
		end
	end
end

function Prat:GetMessageItemIdx(itemname)
	for i, v in ipairs(Prat.SplitMessageIdx) do
		if v == itemname then
			return i
		end
	end

	return 0
end




Prat.SplitMessageIdx = {
    "PRE",
	"nN",
	"CHANLINK",
	"NN",
    "cC",
        "CHANNELNUM",
        "CC",
        "CHANNEL",
-- Zone is not usually included
--      "zZ",
--          "ZONE",
--      "Zz",

    "Cc",
    "TYPEPREFIX",
	"Nn",

    "fF",
        "FLAG",
    "Ff",
    "pP",
        "lL",
            "PLAYERLINK",
            "PLAYERLINKDATA",
        "LL",
        "PREPLAYER",
        "PLAYER",
        "sS",
            "SERVER",
        "Ss",
        "POSTPLAYER",
        "Ll",
    "Pp",
    "TYPEPOSTFIX",
    "mM",
        "gG",
        "LANGUAGE",
        "Gg",
        "MESSAGE",
    "Mm",
    "POST",
}

Prat.SplitMessage = {}




-- Support for segmenting of the chat message to prevent unwanted module interactions
-- The message segments will be available from Prat_PreAddMessage to Prat_PostAddMessage
--
-- Segments are PRE, #C CHANNEL C#, #P PLAYERNAME #S SERVERNAME S# P#, #M MESSAGE M#, POST
--
-- Basic patterns will be used to try and split the chat into those sections
--
-- PRE/POST are for modules to use
--
-- The #'s are also segments, they contain the text surrounding the given element, they
-- should only contain values if the segment eg CHANNEL is not "".
--
-- After Prat_PreAddMessage, the current segments are concatatnated and passed to AddMessage
--
-- Access to the final result string is available during the Prat_PostAddMessage event

-- body = format(TEXT(getglobal("CHAT_"..type.."_GET"))..arg1, pflag..arg2);

local function safestr(s) return s or "" end


function Prat:SplitChatMessage(frame, event)
    self:ClearChatSections(self.SplitMessage)

	if ( strsub((event or ""), 1, 8) == "CHAT_MSG" ) then
        local type = strsub(event, 10)
        local info = ChatTypeInfo[type]

		local filter, newarg1 = false
		local chatFilters = ChatFrame_GetMessageEventFilters and ChatFrame_GetMessageEventFilters(event)
		local arg1 = arg1
        local newarg1

		if chatFilters then
			for _, filterFunc in next, chatFilters do
				filter, newarg1 = filterFunc(arg1)
				arg1 = newarg1 or arg1
				if filter then
					return true
				end
			end
		end

        local s = self.SplitMessage

        s.CHATTYPE = type

        s.MESSAGE = safestr(arg1)

        local chatget = getglobal("CHAT_"..type.."_GET")
        if chatget then
            s.TYPEPREFIX, s.TYPEPOSTFIX = string.match(TEXT(chatget), "(.*)%%s(.*)")
        end

        s.TYPEPOSTFIX = safestr(s.TYPEPOSTFIX)
        s.TYPEPREFIX = safestr(s.TYPEPREFIX)

        local arg2 = safestr(arg2)
        if strlen(arg2) > 0 then

        	if ( strsub(type, 1, 7) == "MONSTER" or type == "RAID_BOSS_EMOTE" ) then
        		-- no link
        	else
               local plr, svr = strsplit("-", arg2)

                s.pP = "["
                s.lL = "|Hplayer:"
                s.PLAYERLINK = arg2
                s.LL = "|h"
                s.PLAYER = plr

                if svr and strlen(svr) > 0 then
                    s.sS = "-"
                    s.SERVER = svr
                end

                if arg11 then
                    s.PLAYERLINKDATA = ":"..safestr(arg11)
                end

                s.Ll = "|h"
                s.Pp = "]"
            end
        end

        local arg6 = safestr(arg6)
        if strlen(arg6) > 0 then
            s.fF = ""

			-- 2.4 Change
			if arg6 == "GM" then 
				s.FLAG = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz.blp:18:12:0:-1|t "
			else
	            s.FLAG = TEXT(getglobal("CHAT_FLAG_"..arg6))
			end

            s.Ff = ""
        end

        local arg3 = safestr(arg3)
        if ( (strlen(arg3) > 0) and (arg3 ~= "Universal") and (arg3 ~= this.defaultLanguage) ) then
            s.gG = "["
            s.LANGUAGE = arg3
            s.Gg = "] "
        else
            s.LANGUAGE_NOSHOW = arg3
        end

        local arg9 = safestr(arg9)
        if strlen(arg9) > 0 then
            local bracket, post_bracket = string.match(s.TYPEPREFIX, "%[(.*)%](.*)")
            bracket = safestr(bracket)
            if strlen(bracket) > 0 then
                s.cC = "["
                s.Cc = "]"
                s.CHANNEL = bracket
                s.TYPEPREFIX = safestr(post_bracket)
            end

            if strlen(safestr(arg8)) > 0 and arg8 > 0 then
                s.CHANNELNUM = tostring(arg8)
                s.CC = ". "
            end

            if arg7 > 0 then
                s.cC = "["
                s.Cc = "] "
                s.CHANNEL, s.zZ, s.ZONE = string.match(arg9, "(.*)(%s%-%s)(.*)")

                if s.CHANNEL == nil then
                    s.CHANNEL = arg9
                end

                s.CHANNEL = safestr(s.CHANNEL)
                s.zZ = safestr(s.zZ)
                s.ZONE = safestr(s.ZONE)
                s.Zz = ""
            else
                if strlen(arg9) > 0 then
                    s.CHANNEL = arg9
                    s.cC = "["
                    s.Cc = "] "
                end
            end
        end

		local _, fontHeight = GetChatWindowInfo(this:GetID());
		
		if ( fontHeight == 0 ) then
			--fontHeight will be 0 if it's still at the default (14)
			fontHeight = 14;
		end

		local arg7 = tonumber(arg7)
 		-- 2.4
		-- Search for icon links and replace them with texture links.
		if arg7 and ( (arg7 < 1) or ( arg7 >= 1 and self.showChatIcons ) ) then
			local term;
			for tag in string.gmatch(arg1, "%b{}") do
				term = strlower(string.gsub(tag, "[{}]", ""));
				if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
					s.MESSAGE  = string.gsub(s.MESSAGE , tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
-- 
-- This would allow for ignoring unknown icon tags
--
--				else
--					s.MESSAGE = string.gsub(s.MESSAGE, tag, "");
				end
			end
		end

        -- Keep an original copy of the split
        self:ClearChatSections(self.SplitMessageOrg)
        for k,v in pairs(s) do
            self.SplitMessageOrg[k] = v
        end

        if type == "SYSTEM" then
            local pl, p, rest = string.match(s.MESSAGE, "|Hplayer:(.-)|h%[(.-)%]|h(.+)")
            if pl and p then
                local plr, svr = strsplit("-", pl)
                s.pP = "["
                s.lL = "|Hplayer:"
                s.PLAYERLINK = pl
                s.LL = "|h"
                s.PLAYER = plr
                s.Ll = "|h"
                s.Pp = "]"
                s.MESSAGE = rest

                if svr and strlen(svr) > 0 then
                    s.sS = "-"
                    s.SERVER = svr
                end

                if arg11 then
                    s.PLAYERLINKDATA = ":"..safestr(arg11)
                end
            end
        end

        if self:IsDebugging() then
            for k,v in pairs(s) do
                if v == "" then s[k] = nil end
            end

            DUMP_SPLIT_EX(this, "SplitMessage", self.SplitMessageIdx, s)

            self:ValidateMessageTable(s)
        else
            self:ValidateMessageTable(s)
        end



        s.ORG = self.SplitMessageOrg

        return self.SplitMessage, info
    end
end

local NULL_INFO = {r = 1.0, g = 1.0, b = 1.0, id = 0 }
function Prat:ValidateMessageTable(message, reporterror)
     -- Ensure the standard stuff isnt nil
    for k,v in pairs(self.SplitMessageSrc) do
        if message[k] then
            message[k] = message[k]
        else
            if reporterror then self:Print("ValidateMessageTable - BAD KEY: ", k) end
            message[k] = ""
        end
    end

    message.INFO = message.INFO or NULL_INFO
end



Prat.ExternalFramePlaceHolder = ChatFrame7

function Prat:RegisterExternalFrame(frame)
    local f = Prat.ExternalFramePlaceHolder -- using frame7 for options right now

    for _,v in ipairs(Prat.ExternalFrames) do
        if v == frame then
           f = f or frame
        end
    end

    if not f then
        table.insert(Prat.ExternalFrames, frame)
        if not frame.GetID then frame.GetID = function() return 7 end end
        f = f or frame
    end
    self:Debug("RegisterFrame", frame:GetName(), f:GetName())

    return f
end

-- api for PratPlugin
function Prat:PluginRenderAsChatString(frame, message, event)
    local frame = (type(frame) == "table" and frame or getglobal(frame))
    local message = message
    local event = event

    if self:IsDebugging() then
        for k,v in pairs(message) do
            if v == "" then message[k] = nil end
        end

       DUMP_EXTMSG_EX(ChatFrame1, "PluginRenderAsChatString", self.SplitMessageIdx, message)
    end
    self:ValidateMessageTable(message)

    -- Keep an original copy of the split
    self:ClearChatSections(self.SplitMessageOrg)
    for k,v in pairs(message) do
        self.SplitMessageOrg[k] = v
    end

    message.ORG = self.SplitMessageOrg


    local r,g,b,id = message.INFO.r, message.INFO.g, message.INFO.b, message.INFO.id
    local mtype = event

    DBG_EXTMSG(frame, mtype)
    local process =  mtype and eventMap[mtype]

    if not process then
        if type(message.OUTPUT) ~= "string" then
            message.Pp, message.pP = "", ""
            message.OUTPUT  = self:BuildChatText(message)
        end
    end

    self[LIB.RAISEEVENT](self, Prat.Events.FRAME_MESSAGE, message, frame, event)

    if (type(message.OUTPUT) == "string" or process) and not message.DONOTPROCESS then

        -- Remove all the pattern matches ahead of time
        message.MESSAGE = self:MatchPatterns(message.MESSAGE, "FRAME")

        self[LIB.RAISEEVENT](self, Prat.Events.PRE_ADDMESSAGE, message, frame, event, self:BuildChatText(message), r,g,b,id)

        -- Pattern Matches Put Back IN
        message.MESSAGE = self:ReplaceMatches(message.MESSAGE, "FRAME")

        if mtype and eventMap[mtype] then
            message.OUTPUT  = self:BuildChatText(message)
        else
            if strlen(message.OUTPUT) > 0 then
                message.OUTPUT  = (message.PRE or "")..message.OUTPUT..(message.POST or "")
            end
        end

        self[LIB.RAISEEVENT](self, Prat.Events.POST_ADDMESSAGE,  message, frame, event, message.OUTPUT, r,g,b,id)

        if message.DONOTPROCESS then         
			message.OUTPUT = ""
        end
        
        message.ORG = nil

        return message.OUTPUT
     else
        return nil
     end
end


-- Do the /dump slash command

function Prat:ConsoleDump(frame, name, order, a1, ...)
-- if Prat:IsDebugging() then
--    local s 
--    local order_tmp
--    if order then
--        order_tmp = util:acquire()
--        for k,v in pairs(order) do order_tmp[k] = v end
--        
--        util:merge_keys(order_tmp, a1)
--
--        s = util:literal_tostring_args_ordered(order_tmp, a1)
--                    
--        util:reclaim(order_tmp)
--    else
--        s = util:literal_tostring_args(a1)
--    end
--    
--    if select("#", ...) > 1 then
--       s = s..", "..(util:literal_tostring_args(...)):join(", ")
--    elseif select("#", ...) > 0 then
--       s = s..", "..util:literal_tostring_args(...)
--    end
--
--    Prat.dumping = true
--    util:print(s, self:GetDebugPrefix(), r, g, b, frame or ChatFrame1)
--    Prat.dumping = false
-- end
end

function Prat:ConsoleDebugDump(...)
--    if Prat:IsDebugging() then
--        Prat.dumping = true
--        Prat:ConsoleDump(nil, nil, nil, ...)
--        Prat.dumping = false
--    end
end

function Prat:OnDebugEnable()
    if self.db then
        self.db.profile.debug = true

        self:Debug("Debug - ON")

     	-- Restore Debugging setting
    	local name, module = nil, nil
    	for name, module in self:IterateModules() do
    	    if module.db then
        	    module:SetDebugging(module.db.profile.debug)
        	end
    	end

        self[LIB.RAISEEVENT](self, Prat.Events.DEBUG_UPDATE)
    end
end

function Prat:OnDebugDisable()
    self.db.profile.debug = false

 	-- Disable Debugging
	local name, module = nil, nil
	for name, module in self:IterateModules() do
	    module:SetDebugging(false)
	end

    self:Debug("Debug - OFF")

    Prat:ScheduleEvent(self.UpdateDebug, 0, self)
end

function Prat:UpdateDebug()
    self[LIB.RAISEEVENT](self, Prat.Events.DEBUG_UPDATE)
end
function Prat:DumpSplit(b)
    self.db.profile.dumpSplit = b
end

local linkbuilder = {
    "|cff", "color", "|H", "linktype", ":", "data", "|h", "[", "text", "]", "|h|r"
}
function Prat:BuildLink(linktype, data, text, color, link_start, link_end)
    linkbuilder[2] = color or "ffffff"
    linkbuilder[4] = linktype
    linkbuilder[6] = data
    linkbuilder[9] = text

    linkbuilder[8] = link_start or "["
    linkbuilder[10] = link_end or "]"

    return table.concat(linkbuilder, "")
end


function CLR:Category(text) return self:Colorize(Prat.Colors.CATEGORY, text) end

function Prat:RegisterModule(name, module)
    local modkey = name
    local ps = Prat.Statuses

    DBG_MODULE("RegisterModule", modkey, name, (module.consoleCmd or name))

    -- Did they request the name? Check who its assigned to
    -- this doesnt do any mapping right now ( it just checks that the functino was called for the module name)
    local name_owner = self.Modules[modkey]

    if name_owner ~= module.name then
        DBG_MODULE("RegisterModule - NAME ERROR", name, name_owner)
    else
        if self.Registered[modkey] then
            DBG_MODULE("RegisterModule - DUPLICATE REGISTRATION ERROR", name)
        else
            self.Registered[modkey] = true
        end
    end

    --
    -- Set up DB
    --
    local revision = type(module.revision) == "number" and module.revision or -1
    if (self.revision or 0) < revision then
        self.revision = revision
    end

    if module.db then
        DBG_MODULE("RegisterModule - DUPLICATE DB REGISTRATION", modkey)		
        module[LIB.SETDATABSEDEFAULTS](module, "profile", module.defaultDB or {})
    else
        module.db = self[LIB.GETDATABASE](self, modkey)
        self[LIB.SETDATABSEDEFAULTS](self, modkey, "profile", module.defaultDB or {})
    end
end

function Prat:RegisterModuleOptions(name, module)
    local modkey = name

    DBG_MODULE("RegisterModuleOptions", modkey, name, (module.consoleCmd or name))

    --
    -- DB is ready so, now lets get the options table
    --
    local opts = module:GetModuleOptions() --or module.moduleOptions
    local auto = module:GetModuleAutoOptions() --or module.toggleOptions

    -- Get the module's localized strings
	local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
	local mL = loc[LIB.NEWLOCALENAMESPACE](loc, modkey)

    -- Assure the the module options root is correct
    opts = opts or {}

    -- Now make sure the module has a reference to it
    module.moduleOptions = module.moduleOptions or opts

    -- This is plain stupid they should not put up errors dammit
    opts.name = opts.name or module.moduleName or name or module.name
    opts.desc = opts.desc or module.moduleDesc or module.name
    opts.type = opts.type or "group"
    opts.args = opts.args or {}
    opts.disabled = opts.disabled

    -- Create any options templates
    if auto then
        self:BuildAutoOptions(name, module, mL, opts, auto)
    end

    -- Add options that go into every module
    self:InjectModuleCommonOptions(opts, module)

    -- Now add it to Prat's Disabled options table
    local D = Prat.DisabledOptions.args
    local conKey = module.consoleName or modkey
    if not module.moduleHidden then
        local T = Prat.Options.args.togglemods.args

        D[modkey] = opts
        T[conKey] = {}
        local stub = T[conKey]
        local toggle = opts.args[L["toggle"]]

        stub.type = toggle.type
        stub.desc = opts.desc
        stub.name = opts.name
        stub.get = toggle.get
        stub.set = toggle.set
    end

    -- Also add it to the console options table
    local conopts = Prat.ConsoleOptions.args

    conopts[conKey] = opts

    local o = D[modkey]
    -- Make sure we have a copy of the modules name
    if o then
        o.name_org = o.name_org or o.name
    end

end





function Prat:ModuleNotify(notification, module)
    local n = Prat.Notifications

--    local  LOG= function(...) DBG:Debug("MODULE", "ModuleNotify", ...) end

    DBG_MODULE("ModuleNotify", notification, module, module.status)

    local o = module.moduleOptions

    if notification == n.ENABLED then
        if not module.enableCheck then
--            if module.status == nil then module.status = "BADENABLE" end
        end
        module.enableCalled = true
        self[LIB.RAISEEVENT](self, Prat.Events.MODULE_ENABLED, module)
    elseif notification == n.DISABLED then
        module.enableCalled = false
        self[LIB.RAISEEVENT](self, Prat.Events.MODULE_DISABLED, module)
    elseif notification == n.UPDATED then
        self:UpdateMetaMenus(module, module.name, module.moduleOptions, true)
    end
end




function Prat:InjectModuleCommonOptions(opts, module)
    local m = module

    if  opts.hidden == nil  and  m.moduleHidden then
        opts.hidden = function() return not(Prat:IsDebugging()) and  m.moduleHidden end
    end

    if m then
        opts.handler = opts.handler or m
    end

    if opts.type == "group" then
        opts.isChecked = function() return m.db.profile.on  end
        opts.onClick = function() local v = (not m.db.profile.on) m.db.profile.on = v m.core:ToggleModuleActive(m, v) end
    end

    opts.args[L["toggle"]] = {
        type = "toggle",
        name = L["Toggle"],
        desc = L["Toggle the module on and off."],
        order = 405,
        get = function() return m.db.profile.on  end,
        set = function(v) m.db.profile.on = v m.core:ToggleModuleActive(m, v) end,
        hidden = m.moduleHidden,
    }

    opts.args["favorite"] = {
        type = "toggle",
        name = L["Favorite"],
        desc = L["Place this module on the favorite's list, and show it on the main menu."],
        order = 404,
        get = function() return m.db.profile.favorite  end,
        set = function(v) m.db.profile.favorite = v m.core:ModuleNotify(Prat.Notifications.UPDATED, m) end,
        disabled = function() return not Prat:IsModuleActive(module) end,
        hidden = m.moduleHidden,
    }


    opts.args[L["debug"]] = {
        type = "toggle",
        name = L["Debugging"],
        desc = L["Show debug messages."],
        order = 402,
        get = function() return m:IsDebugging() end,
        set = function(v) m:SetDebugging(v) end,
        hidden = function() return  not Prat:IsDebugging() end,
        disabled = function() return not Prat:IsModuleActive(module) end
    }

    if PratPerf then
        PratPerf:InjectModuleAceOptions(opts, m, Prat)
    end

    local n = 0
    for k,v in pairs(opts.args) do
        local d = v.disabled
        v.disabled = function() return (not Prat:IsModuleActive(module)) or (type(d) == "function" and d()) end
        n = n + 1
    end

    if n > 4 and not m.moduleHidden then
        opts.args.headerCOspacer = {
        type = "header",
        order = 400,
        }
    end
end



-- Build an options table from the module defaults
-- empty tables are assumed to be per-chatframe options
-- and are filled with toggles for each chatframe, and
-- the individual/all option is added automatically

--
--
-- This got complicated. Its meant to be a simple way to have
-- your menus created, by defining values in the toggleOptions table
-- Each entry in the table is examined by name and type to match
-- a template menu pattarn and add it to the options menu
--
--  _sep = order
--  _options = { opt1 = "opt1" ... }
--  _pass = { sub_toggleOptions }
--  _handler , will make per-frame options that call a handler
--            func eg foo_handler  calls foo(idx, val)
--
--  name = type(number) -> toggle w/ order
--  name = type(boolean) -> toggle
--
--  name = {} empty table per-frame toggles
--
--  most of them set name and desc to foo_name, foo_desc and use that
--  to get the localized string. some also use foo_perframename foo_perframedesc
--
--  concept and nameing borrowed copied from bigwigs ora2
--
function Prat:BuildAutoOptions(name, module, moduleLocals, opts, togopts)
    local mL = moduleLocals
    local m = module
    local n = 0
    for k,v in pairs(togopts) do
        n = n + 1
        local val = v

        local optname, opttype = strsplit("_", k)

        if opttype then
            if opttype == "sep" then
                local ord = n
                if type(val) == "number" then
                    ord = val
                end

            	opts.args[optname..ord]  = {
    				order = ord,
    				type = 'header',
    			}
            elseif opttype == "options" then
                opts.args[optname] = {
                    name = mL[optname.."_name"],
                    desc = mL[optname.."_desc"],
                    type = "text",
                    get = function() return m.db.profile[optname] end,
                    set = function(v) m.db.profile[optname] = v end,
                    validate = {},
                }

                for k2,v2 in pairs(val) do
                    opts.args[optname].validate[k2]=v2
                end
            elseif opttype == "pass" then -- Use a passing group, options are tables with thier remaining args
                 opts.args[optname] = {
                    type = "group",
                    order = n,
                    name = mL[optname.."_name"],
                    desc = mL[optname.."_desc"],
                    args = {},
                }
                local sub_opts = opts.args[optname]
                m:InjectModulePassOptions(sub_opts) -- Use passing group (ModuleGetOption/ModuleSetOption)

                self:BuildAutoOptions(name, module, moduleLocals, sub_opts, val)
            elseif opttype == "handler" then -- This could also just be a passing group but w/e
                opts.args[optname] = {
                    type = "group",
                    order = n,
                    name = mL[optname.."_name"],
                    desc = mL[optname.."_desc"],
                    args = {},
                }


                local sub_opts = opts.args[optname].args
               for i,f in ipairs(Prat.Frames) do
                local frame = f:GetName()
                sub_opts[frame] = {
                    name = string.format(mL[optname.."_perframename"], i),
                    desc = string.format(mL[optname.."_perframedesc"], i),
                    type = "toggle",
                    get = function() return m.db.profile[optname][i] end,
                    set = function(x) m.db.profile[optname][i] = x; m[optname](m, i, x) end
                }
              end

            end
        elseif type(val) ~= "table" then
            local ord = n
            if type(val) == "number" then
                ord = val
            end
            opts.args[k] = {
                type = "toggle",
                order = ord,
                name = mL[k.."_name"],
                desc = mL[k.."_desc"],
                get = function() return m.db.profile[k] end,
                set = function(x) m.db.profile[k] = x end,
            }
        elseif #val ~= 0 or val.type then -- Fill in missing fields
            if val.type then
                opts.args[k] = val
                val.order = val.order or n
                val.name = mL[k.."_name"]
                val.desc = mL[k.."_desc"]
                if not opts.pass then
                    val.get = val.get or function() return m.db.profile[k] end
                    val.set = val.set or function(x) m.db.profile[k] = x end
                    val.exec = (val.type == "exec") and (val.exec or k)
                end
           else
                opts.args[k] = {
                    type = "group",
                    order = n,
                    name = mL[k.."_name"],
                    desc = mL[k.."_desc"],
                    args = {},
                }

                self:BuildAutoToggleOptions(name, module, moduleLocals, opts.args[v].args, val)
            end
        else
            opts.args[k] = {
                type = "group",
                order = n,
                name = mL[k.."_name"],
                desc = mL[k.."_desc"],
                args = {},
            }
            local sub_opts = opts.args[k].args
            for i,frame in ipairs(Prat.Frames) do
               sub_opts["chat"..i] = {
                    name = string.format(mL[k.."_perframename"], i),
                    desc = string.format(mL[k.."_perframedesc"], i),
                    type = "toggle",
                    get = function() return m.db.profile[k][i] end,
                    set = function(x) m.db.profile[k][i] = x;  end
                }
            end
        end
    end
end





local favhint = {
        order = 99,
        type = 'header',
        name = CLR:Colorize(VERSION2, L["Hint: Select 'Favorite' in a module to add it here"]),
    }


function Prat:Prat_ModuleEnabled(mod)
    local k = mod.name
    local v = Prat.DisabledOptions.args[k]


--    self:Debug("Prat_ModuleEnabled - "..mod.name)

    Prat.Options.args.enabledmods.args[k] = v or Prat.Options.args.enabledmods.args[k]
--    Prat.DisabledOptions.args[k] = nil

    self:UpdateMetaMenus(mod, k, v, true)
end

function Prat:UpdateMetaMenus(mod, key, opts, show)
    local favs = Prat.Options.args

    if mod.db.profile.favorite then
        Prat.Favorites[key] = show and opts or nil
        favs[key] = show and opts or nil
    else
        Prat.Favorites[key] = nil
        if favs[key] then favs[key] = nil end
    end

    favs.favhint = favhint
    for _, v in pairs(Prat.Favorites) do
       favs.favhint = nil
    end

--    if mod.Categories then
--        local base = Prat.Options.args.categorized.args
--        local has = false
--        for k,v in pairs(base) do
--            v.args[key] = nil
--            if show then
--                for _,cat in ipairs(mod.Categories) do
--                    if v.name == cat then
--                        v.args[key] = show and opts or nil
--                    end
--                end
--            end
--        end
--    end
end

function Prat:Prat_ModuleDisabled(mod)
 --   local k = mod.name

--    local O = Prat.Options.args

--    local C = O.categorized.args
--    local D = O.disabledmods.args
--    local D = Prat.DisabledOptions.args
--    local E = O.enabledmods.args

--    local v = E[k] --Prat.Options.args[k]

--    self:Debug("Prat_ModuleDisabled - "..mod.name)

--    if mod.Categories then
 --       local base = C
--        local modkey, opts = k,v
--        for k,v in pairs(base) do
--            for _,cat in ipairs(mod.Categories) do
--                if v.name == cat then
--                    v.args[modkey] = nil
--                end
--            end
--        end
--    end

    -- Hide disabled favorites
--    if mod.db.profile.favorite then
--        O[k] = nil
--    end


 --   D[k] = v or D[k]

--    E[k] = nil

--    self:UpdateMetaMenus(mod, k, v, false)
end



-- This function will return a module name which
-- Prat likes. All modules need to get their names
-- by calling this function. Its done so we can
-- can control naming of all modules
function Prat:RequestModuleName(name)
    local prat_name = name -- TODO: Add any special prefixes here

    -- Name in use
    if Prat.Modules[name] then
        return nil
    end

    Prat.Modules[name] = prat_name -- Create a lookup table for the common name
    return prat_name
end

--
--
-- Module Prototype
--
--
Prat.modulePrototype.core = Prat
Prat.modulePrototype.revision = 1
Prat.modulePrototype.moduleOptions = nil        -- Options table for the module
Prat.modulePrototype.consoleCmd = nil           -- Set to override the console command (default = module name)
Prat.modulePrototype.toggleOptions = nil        -- Set to a table of strings to create auto-toggle options
Prat.modulePrototype.modHidden = nil            -- If true this module is hidden unless debug mode is on
Prat.modulePrototype.status = nil

Prat.modulePrototype.modulePatterns = nil

function Prat.modulePrototype:new(...) return new(...) end
function Prat.modulePrototype:del(t) return del(t) end

--
-- Modules can override these
--
function Prat.modulePrototype:GetModuleOptions()
    return self.moduleOptions
end
function Prat.modulePrototype:GetModuleAutoOptions()
    return self.toggleOptions
end
function Prat.modulePrototype:GetModulePatterns()
    return self.modulePatterns
end

function Prat.modulePrototype:OnModuleInit()
end
function Prat.modulePrototype:OnModuleEnable(first)
end
function Prat.modulePrototype:OnModuleDisable()
end
function Prat.modulePrototype:OnModuleDebugEnable()
end
function Prat.modulePrototype:OnModuleDebugDisable()
end
function Prat.modulePrototype:OnModuleGetOption(name)
end
function Prat.modulePrototype:OnModuleSetOption(name, value)
end
function Prat.modulePrototype:OnModuleCallMethod(name, ...)
end
function Prat.modulePrototype:OnModuleOnUpdateHook(this, elapsed)
end

Prat.modulePrototype.OnUpdateInterval = 1.0
Prat.modulePrototype.lastupdate = 0
function Prat.modulePrototype:ModuleOnUpdateHook(elapsed)
  if not this:IsVisible() and not this:IsShown() then return end
  self.lastupdate = self.lastupdate + elapsed

  while (self.lastupdate > self.OnUpdateInterval) do
    self:OnModuleOnUpdateHook(this, elapsed)
    self.lastupdate = self.lastupdate - self.OnUpdateInterval;
  end
end


function Prat.modulePrototype:InjectModulePassOptions(opts)
    opts.pass = true
    opts.get = function(...) return  self:ModuleGetOption(...) end
    opts.set = function(...) return  self:ModuleSetOption(...) end
    opts.exec = function(...) return  self:ModuleCallMethod(...) end
end




function Prat.modulePrototype:ModuleSetOption(name, value)
    self:Debug("ModuleSetOption", name, value)
    if self.db then
        self.db.profile[name] = value
    end

    self:OnModuleSetOption(name, value)
end
function Prat.modulePrototype:ModuleGetOption(name)
    local val = self.db and self.db.profile[name]
    self:Debug("ModuleGetOption", name, val)

    val = self:OnModuleGetOption(name) or val
    return val
end
function Prat.modulePrototype:ModuleCallMethod(name, ...)
    self:Debug("ModuleCallMethod", name, ...)

    self:OnModuleCallMethod(name, ...)
end

-- A 'protected' debug call that will not capture
-- Meant for use during the Prat_FrameMessage event
function Prat.modulePrototype:FMDebug(...)
    self:Debug(...)
end

Prat.modulePrototype.debugstr = debugstr
Prat.modulePrototype.pratstr = pratstr

function Prat.modulePrototype:GetDebugPrefix()
    return ("(%s) %s <|cffc0c0ff%s|r>:|cffa0a0a0[%06d]|r"):format( self.debugstr, self.pratstr, tostring(self), (GetTime() - self.core.timestart))
end


function Prat.modulePrototype:Debug(...)
    self.core.dumping = true
    if AceDebug then 
 		AceDebug.CustomDebug(self, nil, nil, nil, nil, nil, ...)
	end
    self.core.dumping = false
end

--
-- Modules Must Not Override these
--
Prat.modulePrototype.initCheck = false
Prat.modulePrototype.enableCheck = false

function Prat.modulePrototype:OnInitialize()
    self.initCheck = true

    self.GetDebugPrefix = Prat.modulePrototype.GetDebugPrefix

    if self.core.db.profile.forceDebugModules then
        self:SetDebugging(true)
    end

    self:Debug("OnInitialize()")

    -- Register the module
    self.core:RegisterModule(self.pratModuleName or self.name, self)

	if LIB.DEBUG then 
	    if not self.core.db.profile.forceDebugModules then
	       self:SetDebugging(self.core:IsDebugging() and self.db.profile.debug or false)
	    end
	else
		self.SetDebugging = function() end
		self.IsDebugging = function() return false end
	end


    local on = self.moduleHidden or self.db.profile.on
    self.db.profile.on = on

    if self.modHidden then
        --self.status = "HIDDEN"
    end
end

function Prat.modulePrototype:OnEnable(first)
    self.enableCheck = true
    self:Debug("OnEnable()")

    if first then 
        self.core:RegisterModuleOptions(self.pratModuleName or self.moduleName, self)
        self:OnModuleInit()
    end

    if not self.core:IsActive() then
        DBG_MODULE("Prat not active")
        self.core:ToggleModuleActive(self, false)
        return
    end

    if not self.db.profile.on then
        DBG_MODULE("Module should not be active", self.name)
        self.core:ToggleModuleActive(self, false)
        return
    end




    self:OnModuleEnable(first)

    local  p = self:GetModulePatterns()

    if type(p) == "table" then
        for _,v in pairs(p) do
            self.core:RegisterPattern(v, self.name)
        end
    end

    self.core:ModuleNotify(Prat.Notifications.ENABLED, self)
end
function Prat.modulePrototype:OnDisable()
    self:Debug("OnDisable()")

    if not self.enableCalled then
        DBG_MODULE("Module never enabled. Not calling OnModuleDisable")
        return
    end

    self.core:UnregisterAllPatterns(self.name)

    self:OnModuleDisable()

    self.core:ModuleNotify(Prat.Notifications.DISABLED, self)
    self.enableCheck = false
end
function Prat.modulePrototype:OnDebugEnable()
    if self.db then
        self.db.profile.debug = true
    end
    self:Debug("Debug - ON")
    self:OnModuleDebugEnable()
end
function Prat.modulePrototype:OnDebugDisable()
    -- if the debug setting is changed to false by
    -- prat when the core's debug is disabled then
    -- dont save the setting
    if self.core.db.profile.debug then
        self:OnModuleDebugDisable()
        if self.db then
            self.db.profile.debug = false
        end
        self:Debug("Debug - OFF")
    end
end

--[[
# vim:ts=4:sw=4
]]
