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
Name: PratAddonMsgs
Revision: $Revision: 79185 $
Author(s): Sylvanaar (sylvanaar@mindspring.com)
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#AddonMsgs
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: Module for Prat that toggles showing hidden addon messages on and off (default=off).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY

-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratAddonMsgs")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings

local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[LIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["AddonMsgs"] = true,
    ["Addon message options."] = true,
    ["show_name"] = "Show Addon Messages",
    ["show_desc"] = "Toggle showing hidden addon messages in each chat window.",
    ["show_perframename"] = "ChatFrame%d AddonMsgsShow",
    ["show_perframedesc"] = "Toggle showing hidden addon messages on and off.",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["AddonMsgs"] = "Addon Nachrichten",
    ["Addon message options."] = "Chatfenster Addon Nachrichten Optionen.",
    ["show_name"] = "Zeige Addon Nachrichten",
    ["show_desc"] = "Schaltet das Anzeigen von verborgenen Addon Nachrichten an und aus f\195\188r jedes Fenster.",
    ["show_perframename"] = "%s Addon Nachricht Anzeigen",
    ["show_perframedesc"] = "Schaltet das Anzeigen von verborgenen Addon Nachrichten ein und aus  f\195\188r %s .",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["AddonMsgs"] = "Messages des Addons",
    ["Addon message options."] = "Options des messages d'addon.",
    ["show_name"] = "Afficher les messages des addons",
    ["show_desc"] = "Active/d\195\169sactive les messages des addons pour chaque fen\195\170tre.",
    ["show_perframename"] = "%s : Afficher les messages des addons",
    ["show_perframedesc"] = "Active/d\195\169sactive les messages des addons dans la fen\195\170tre %s .",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["AddonMsgs"] = "Mensajes de Accesorio",
    ["Addon message options."] = "Opciones de Mensajes de Accesorio",
    ["show_name"] = "Mostrar",
    ["show_desc"] = "Determina si se muestran los mensajes ocultos de accesorio para cada ventana.",
    ["show_perframename"] = "Mostrar Mensajes en %s ",
    ["show_perframedesc"] = "Determina si se muestran los mensajes de accesorio para la ventana de %s ."
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["AddonMsgs"] = "애드온 메세지",
    ["Addon message options."] = "애드온 메세지 설정입니다.",
    ["show_name"] = "애드온 메세지 표시",
    ["show_desc"] = "각각의 대화창에 숨겨진 애드온 메세지를 표시합니다.",
    ["show_perframename"] = "대화창%d 애드온 메세지 표시",
    ["show_perframedesc"] = "숨겨진 애드온 메세지를 표시합니다.",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["AddonMsgs"] = "插件訊息",
    ["Addon message options."] = "插件訊息選項。",
    ["show_name"] = "顯示插件訊息",
    ["show_desc"] = "切換是否在各個聊天視窗顯示插件訊息。",
    ["show_perframename"] = "聊天視窗%d顯示插件訊息",
    ["show_perframedesc"] = "切換是否顯示插件訊息。"
} end)

--Chinese Translation: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["AddonMsgs"] = "插件信息",
    ["Addon message options."] = "插件信息设置",
    ["show_name"] = "显示插件信息",
    ["show_desc"] = "选择是否在每个窗口显示插件信息",
    ["show_perframename"] = "在窗口%s显示插件信息",
     ["show_perframedesc"] = "选择是否在聊天窗口%s显示隐藏的插件信息."
 } end)



-- create prat module
Prat_AddonMsgs = Prat:NewModule(PRAT_MODULE)
local Prat_AddonMsgs = Prat_AddonMsgs
Prat_AddonMsgs.pratModuleName = PRAT_MODULE
Prat_AddonMsgs.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_AddonMsgs.moduleName = L["AddonMsgs"]
Prat_AddonMsgs.moduleDesc = L["Addon message options."]
Prat_AddonMsgs.consoleName = "addonmsgs"
Prat_AddonMsgs.guiName = L["AddonMsgs"]


-- define the default db values
Prat_AddonMsgs.defaultDB = {
    on = false,
    show = {false, false, false, false, false, false, false},
}

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_AddonMsgs.moduleOptions = {}

-- build the options menu using prat templates
Prat_AddonMsgs.toggleOptions = { show={} }

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

-- things to do when the module is enabled
function Prat_AddonMsgs:OnModuleEnable()
    -- register events
    self[LIB.REGISTEREVENT](self, "CHAT_MSG_ADDON")
end

-- things to do when the module is disabled
function Prat_AddonMsgs:OnModuleDisable()
    -- unregister events
    self:UnregisterAllEvents()
end

--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--

-- add a splash of color to text
function CLR:arg1(text) return self:Colorize("ffff40", text) end
function CLR:arg2(text) return self:Colorize("a0a0a0", text) end
function CLR:arg3(text) return self:Colorize("40ff40", text) end
function CLR:arg4(text) return self:Colorize("4040ff", text) end

-- show hidden addon channel messages
function Prat_AddonMsgs:CHAT_MSG_ADDON()
    for i=1,NUM_CHAT_WINDOWS do
        if self.db.profile.show[i] then
            getglobal("ChatFrame"..i):AddMessage("["..CLR:arg1(arg1).."]["..CLR:arg2(arg2).."]["..CLR:arg3(arg3).."]["..CLR:arg4(arg4).."]")
        end
    end
end