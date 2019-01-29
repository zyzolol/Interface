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
Name: PratFading
Revision: $Revision: 79185 $
Author(s): Curney (asml8ed@gmail.com)
           Krtek (krtek4@gmail.com)
Inspired by: idChat2_DisableFade by Industrial
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#Fading
SVN: http://svn.wowace.com/wowace/trunk/Prat/
Description: Module for Prat that adds text fading options for chat windows (default=off).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratFading")

if PRAT_MODULE == nil then
    return
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["Fading"] = true,
    ["Chat window text fading options."] = true,
    ["Enable Fading"] = true,
    ["Toggle enabling text fading for each chat window."] = true,
    ["Enable ChatFrame%d Fading"] = true,
    ["Toggle text fading on and off."] = true,
    ["Set Fading Delay"] = true,
    ["Set time to wait before before fading text of chat windows."] = true,
} end)

L[LIB.NEWLOCALE](L, "zhCN", function() return {
	["Fading"] = "淡出",
	["Chat window text fading options."] = "聊天窗口文本淡入淡出选项.",
    ["Enable ChatFrame%d Fading"] = "聊天窗口 %d 淡出",
    ["Toggle text fading on and off."] = "切换聊天窗口 %d 文本淡出.",
    ["Set Fading Delay"] = "淡出延迟",
    ["Set time to wait before before fading text of chat windows."] = "设置聊天窗口文本淡出延迟.",
 } end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["Fading"] = "文字淡出",
    ["Chat window text fading options."] = "聊天視窗文字淡出選項。",
    ["Enable Fading"] = "啟用文字淡出",
    ["Toggle enabling text fading for each chat window."] = "切換是否在各個聊天視窗啟用文字淡出。",
    ["Enable ChatFrame%d Fading"] = "聊天視窗%d啟用文字淡出",
    ["Toggle text fading on and off."] = "切換是否啟用文字淡出。",
    ["Set Fading Delay"] = "淡出時間",
    ["Set time to wait before before fading text of chat windows."] = "設定聊天視窗文字淡出前的等待時間。",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["Fading"] = "Disparition du texte",
    ["Chat window text fading options."] = "Configure les options de disparition du texte.",
    ["Enable ChatFrame%d Fading"] = "Fen\195\170tre %d",
    ["Toggle text fading on and off."] = "Active/d\195\169sactive la disparition du texte pour la fen\195\170tre %d.",
    ["Set Fading Delay"] = "Ajustement du d\195\169lai de disparition",
    ["Set time to wait before before fading text of chat windows."] = "R\195\168gle le temps au bout duquel le texte disparait de la fen\195\170tre de chat.",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["Fading"] = "숨김",
    ["Chat window text fading options."] = "대화글 숨김 설정입니다.",
    ["Enable Fading"] = "숨김 사용",
    ["Toggle enabling text fading for each chat window."] = "각 대화창에 대한 글자 숨김 사용을 전환합니다.",
    ["Enable ChatFrame%d Fading"] = "%d 대화창 숨김 사용",
    ["Toggle text fading on and off."] = "글자 숨김 켜고 끄기를 전환합니다.",
    ["Set Fading Delay"] = "숨김 지연시간 설정",
    ["Set time to wait before before fading text of chat windows."] = "대화글 숨김까지의 지연시간을 설정합니다.",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["Fading"] = "Desvanecimiento",
    ["Chat window text fading options."] = "Opciones de desvanecimiento de texto de la ventana de chat",
    ["Enable ChatFrame%d Fading"] = "Desvanecimiento en Chat %d",
    ["Toggle text fading on and off."] = "Determina si se activa o desactiva el desvanecimiento en la ventana de chat %d",
    ["Set Fading Delay"] = "Retraso del Desvanecimiento",
    ["Set time to wait before before fading text of chat windows."] = "Establece el tiempo a esperar antes de que se desvanezca el texto de las ventanas de chat",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
	["Fading"] = "Ausblenden",
	["Chat window text fading options."] = "Chatfenster Text Ausblenden Optionen.",
	["Enable ChatFrame%d Fading"] = "Chat %d Ausblenden",
	["Toggle text fading on and off."] = "Schaltet das Text ausblenden an und aus f\195\188r das Chatfenster %d.",
	["Set Fading Delay"] = "Text Ausblenden Verz\195\182gerrung einstellen",
	["Set time to wait before before fading text of chat windows."] = "Stellt die Dauer ein bis der Chat in den Chatfenstern ausgeblendet wird.",
} end)



-- create prat module
Prat_Fading = Prat:NewModule(PRAT_MODULE)
local Prat_Fading = Prat_Fading
Prat_Fading.pratModuleName = PRAT_MODULE
Prat_Fading.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_Fading.moduleName = L["Fading"]
Prat_Fading.moduleDesc = L["Chat window text fading options."]
Prat_Fading.consoleName = "fading"
Prat_Fading.guiName = L["Fading"]

-- define the default db values
Prat_Fading.defaultDB = {
    on = true,
    textfade = {false, false, false, false, false, false, false},
    duration = 5
}

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_Fading.moduleOptions = {}

-- build the options menu using prat templates
Prat_Fading.toggleOptions = {}

-- add module options not covered by templates
function Prat_Fading:GetModuleOptions()
    self.moduleOptions = {
        name = L["Fading"],
        desc = L["Chat window text fading options."],
        type = "group",
        args = {
            textfade = {
                name = L["Enable Fading"],
                desc = L["Toggle enabling text fading for each chat window."],
                type = "group",
                order = 110,
                args = {
                    chat1 = {
                        name = string.format(L["Enable ChatFrame%d Fading"], 1),
                        desc = string.format(L["Toggle text fading on and off."], 1),
                        type = "toggle",
                        get = function() return self.db.profile.textfade[1] end,
                        set = function(v) self.db.profile.textfade[1] = v; self:Fade(1,v) end
                    },
                    chat2 = {
                        name = string.format(L["Enable ChatFrame%d Fading"], 2),
                        desc = string.format(L["Toggle text fading on and off."], 1),
                        type = "toggle",
                        get = function() return self.db.profile.textfade[2] end,
                        set = function(v) self.db.profile.textfade[2] = v; self:Fade(2,v) end
                    },
                    chat3 = {
                        name = string.format(L["Enable ChatFrame%d Fading"], 3),
                        desc = string.format(L["Toggle text fading on and off."], 1),
                        type = "toggle",
                        get = function() return self.db.profile.textfade[3] end,
                        set = function(v) self.db.profile.textfade[3] = v; self:Fade(3,v) end
                    },
                    chat4 = {
                        name = string.format(L["Enable ChatFrame%d Fading"], 4),
                        desc = string.format(L["Toggle text fading on and off."], 1),
                        type = "toggle",
                        get = function() return self.db.profile.textfade[4] end,
                        set = function(v) self.db.profile.textfade[4] = v; self:Fade(4,v) end
                    },
                    chat5 = {
                        name = string.format(L["Enable ChatFrame%d Fading"], 5),
                        desc = string.format(L["Toggle text fading on and off."], 1),
                        type = "toggle",
                        get = function() return self.db.profile.textfade[5] end,
                        set = function(v) self.db.profile.textfade[5] = v; self:Fade(5,v) end
                    },
                    chat6 = {
                        name = string.format(L["Enable ChatFrame%d Fading"], 6),
                        desc = string.format(L["Toggle text fading on and off."], 1),
                        type = "toggle",
                        get = function() return self.db.profile.textfade[6] end,
                        set = function(v) self.db.profile.textfade[6] = v; self:Fade(6,v) end
                    },
                    chat7 = {
                        name = string.format(L["Enable ChatFrame%d Fading"], 7),
                        desc = string.format(L["Toggle text fading on and off."], 1),
                        type = "toggle",
                        get = function() return self.db.profile.textfade[7] end,
                        set = function(v) self.db.profile.textfade[7] = v; self:Fade(7,v) end
                    }
                }
            },
            delay = {
                name = L["Set Fading Delay"],
                desc = L["Set time to wait before before fading text of chat windows."],
                type = "range",
                order = 190,
                get = function() return self.db.profile.duration end,
                set = function(v) self.db.profile.duration = v end,
                min = 1,
                max = 60,
                step = 1
            },
        }
    }
   	return self.moduleOptions
end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

-- things to do when the module is enabled
function Prat_Fading:OnModuleEnable()
    for i=1,NUM_CHAT_WINDOWS do
        self:Fade(i,self.db.profile.textfade[i])
    end
end

-- things to do when the module is disabled
function Prat_Fading:OnModuleDisable()
    for i=1,7 do
        self:Fade(i,true)
    end
end

--[[------------------------------------------------
	Core Functions
------------------------------------------------]]--

-- enable/disable fading
function Prat_Fading:Fade(id,textfade)
    local cf = getglobal("ChatFrame"..id)
    if textfade then
        cf:SetFading(1)
        -- cf:SetTimeVisible(self.db.profile.duration)
    else
        cf:SetFading(nil)
    end
end
