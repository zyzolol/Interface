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
Name: PratEventNames
Revision: $Revision: 79185 $
Author(s): Sylvanaar
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#EventNames
SVN: http://svn.wowace.com/wowace/trunk/Prat/
Description: Module for Prat that toggles showing hidden addon messages on and off (default=off).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratEventNames")

if PRAT_MODULE == nil then 
    return 
end

local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["EventNames"] = true,
    ["Chat window event name options."] = true,
    ["show_name"] = "Show Event Names",
    ["show_desc"] = "Toggle showing event names in each window.",
    ["show_perframename"] = "ChatFrame%d EventNamesShow",
    ["show_perframedesc"] = "Toggles showing event names on and off.",
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79185 $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
     ["EventNames"] = "事件名称",
     ["Chat window event name options."] = "聊天窗口事件名称选项。",
     ["show_name"] = "显示事件",
     ["show_desc"] = "切换显示各个窗口的事件名称",
    ["show_perframename"] = "聊天窗口 %s 事件名称显示",
    ["show_perframedesc"] = "切换聊天窗口 %s 事件名称显示",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["EventNames"] = "Noms des \195\169venements",
    ["Chat window event name options."] = "Options d'affichage des \195\169v\195\168nements des fen\195\170tres.",
    ["show_name"] = "Afficher les \195\169v\195\168nements",
    ["show_desc"] = "Activer/d\195\169sactiver l'affichage des noms d'\195\169v\195\168nements pour chaque fen\195\170tre.",
    ["show_perframename"] = "Affichage des \195\169v\195\168nements de la fen\195\170tre %s ",
    ["show_perframedesc"] = "Active/d\195\169sactive l'affichage des \195\169v\195\168nements de la fen\195\170tre %s .",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["EventNames"] = "事件名稱",
    ["Chat window event name options."] = "聊天視窗事件名稱選項。",
    ["show_name"] = "顯示事件名稱",
    ["show_desc"] = "切換是否在各個聊天視窗顯示事件名稱。",
    ["show_perframename"] = "聊天視窗%d顯示事件名稱",
    ["show_perframedesc"] = "切換是否顯示事件名稱。",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["EventNames"] = "이벤트명",
    ["Chat window event name options."] = "대화창 이벤트명 설정입니다.",
    ["show_name"] = "이벤트명 표시",
    ["show_desc"] = "각각의 대화창에 이벤트명을 표시합니다.",
    ["show_perframename"] = "대화창%d 이벤트명 표시",
    ["show_perframedesc"] = "이벤트명을 표시합니다.",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["EventNames"] = "Nombres de Evento",
    ["Chat window event name options."] = "Opciones de nombres de evento",
    ["show_name"] = "Mostrar Eventos",
    ["show_desc"] = "Determina si se muestran los nombres de evento para cada ventana",
    ["show_perframename"] = "Mostrar Nombres de Evento en el %s ",
    ["show_perframedesc"] = "Determina si se muestran los nombres de evento en la ventana %s "
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
	["EventNames"] = "Event Namen",
	["Chat window event name options."] = "Chatfenster Event Namen Optionen.",
	["show_name"] = "Zeige Name",
	["show_desc"] = "Aktiviert das Anzeigen von Event Namen in jedem Fenster.",
	["show_perframename"] = "%s Event Namen Anzeigen",
	["show_perframedesc"] = "Schaltet das Anzeigen von Event Namen an und aus f\195\188r %s ."
} end)

Prat_EventNames = Prat:NewModule(PRAT_MODULE)
local Prat_EventNames = Prat_EventNames
Prat_EventNames.pratModuleName = PRAT_MODULE

Prat_EventNames.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

Prat_EventNames.consoleName = "eventnames"

Prat_EventNames.defaultDB = {
    on = true,
    show = {false, false, false, false, false, false, false},
}

Prat_EventNames.moduleOptions = {}
Prat_EventNames.toggleOptions = { show={} }

local cat = Prat.Categories



function Prat_EventNames:GetModuleOptions()
    self.moduleOptions = {
        name = L["EventNames"],
        desc = L["Chat window event name options."],
        type = "group",
        args = {
        }
    }
   	return self.moduleOptions
end


function Prat_EventNames:OnModuleEnable()
	self[LIB.REGISTEREVENT](self, "Prat_PreAddMessage")
end

--[[------------------------------------------------
	Core Functions
------------------------------------------------]]--

function CLR:EventBrackets(text) return self:Colorize("ffffff", text) end
function CLR:EventName(text, c)  return self:Colorize(c, text) end

--
-- Prat Event Implementation
--

function Prat_EventNames:Prat_PreAddMessage(message, frame, event, t, r, g, b)
	if self.db.profile.show[frame:GetID()] then
		local c = ("%02x%02x%02x"):format((r or 1.0)*192*0.7+63, (g or 1.0)*192*0.7+63, (b or 1.0)*192*0.7+63)
		self:Debug(tostring(event))
		message.POST =  "  "..CLR:EventBrackets("(")..CLR:EventName(tostring(event), c)..CLR:EventBrackets(")")
	end
end