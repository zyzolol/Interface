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
Name: PratChannelColorMemory
Revision: $Revision: 79894 $
Author(s): Sylvanaar (sylvanaar@mindspring.com)
Inspired by: ConsisTint By Karl Isenberg (AnduinLothar)
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#ChannelColorMemory
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: Module for Prat that remembers the colors of channels by channel name (default=on).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratChannelColorMemory")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["ChannelColorMemory"] = true,
    ["Remembers the colors of each channel name."] = true,
    ["(%w+)%s?(.*)"] = true,
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["ChannelColorMemory"] = "Mémorisation des couleurs des canaux",
    ["Remembers the colors of each channel name."] = "M\195\169moriser les couleurs de chaque canal.",
    ["(%w+)%s?(.*)"] = "(%w+)%s?(.*)",
} end)
--Chinese Translation: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["ChannelColorMemory"] = "频道颜色储存",
    ["Remembers the colors of each channel name."] = "还原频道名称的颜色设置",
     ["(%w+)%s?(.*)"] = "(.+)%s?(.*)",
 } end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["ChannelColorMemory"] = "채널색상기억",
    ["Remembers the colors of each channel name."] = "각 채널명의 색상을 기억합니다.",
    ["(%w+)%s?(.*)"] = "(.+)%s?(.*)",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["ChannelColorMemory"] = "頻道顏色記憶",
    ["Remembers the colors of each channel name."] = "記住每個頻道的顏色設定。",
    ["(%w+)%s?(.*)"] = "(.+)%s?(.*)",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["ChannelColorMemory"] = "Memoria de Color de Canal",
    ["Remembers the colors of each channel name."] = "Recuerda los colores de los canales por nombre de canal.",
    ["(%w+)%s?(.*)"] = "(%w+)%s?(.*)",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["ChannelColorMemory"] = "Kanal Farben Merken",
    ["Remembers the colors of each channel name."] = "Merkt sich die Farben von jedem Kanal Namen.",
    ["(%w+)%s?(.*)"] = "(%w+)%s?(.*)",
} end)

L[LIB.NEWLOCALE](L, "ruRU", function() return {
    ["ChannelColorMemory"] = "Помнить цвета каналов",
    ["Remembers the colors of each channel name."] = "Помнить цвета каждого названия канала.",
    ["(%w+)%s?(.*)"] = "([^:]+)%s?(.*)",
} end)

-- create prat module
Prat_ChannelColorMemory = Prat:NewModule(PRAT_MODULE)
local Prat_ChannelColorMemory = Prat_ChannelColorMemory
Prat_ChannelColorMemory.pratModuleName = PRAT_MODULE
Prat_ChannelColorMemory.revision = tonumber(string.sub("$Revision: 79894 $", 12, -3))

-- define key module values
Prat_ChannelColorMemory.moduleName = L["ChannelColorMemory"]
Prat_ChannelColorMemory.moduleDesc = L["Remembers the colors of each channel name."]
Prat_ChannelColorMemory.consoleName = "chancolormemory"
Prat_ChannelColorMemory.guiName = L["ChannelColorMemory"]


-- define the default db values
Prat_ChannelColorMemory.defaultDB = {
    on = true,
    colors = {},
}

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_ChannelColorMemory.moduleOptions = {}

-- build the options menu using prat templates
Prat_ChannelColorMemory.toggleOptions = {}

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

-- things to do when the module is enabled
function Prat_ChannelColorMemory:OnModuleEnable()
    -- register events
    self[LIB.REGISTEREVENT](self, "UPDATE_CHAT_COLOR")
    self[LIB.REGISTEREVENT](self, "CHAT_MSG_CHANNEL_NOTICE")
end

--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--

function Prat_ChannelColorMemory:UPDATE_CHAT_COLOR(ChatType, cr,cg,cb)
    if (ChatType) then
        local number = string.gmatch(arg1, "CHANNEL(%d+)")()
        if ( number ) then
            local _, name = GetChannelName(number);
            if ( name ) then
                local name, zoneSuffix = string.gmatch(name, L["(%w+)%s?(.*)"])();
                local color = self.db.profile.colors[name];
                if (not color) then
                    self.db.profile.colors[name] = {r=cr, g=cg, b=cb};
                else
                    color.r=cr
                    color.g=cg
                    color.b=cb
                end
            end
        end
    end
end

function Prat_ChannelColorMemory:CHAT_MSG_CHANNEL_NOTICE(NoticeType,a2,a3,LongName,a5,a6,a7,number, cname)
    if (not strfind(LongName, "%d+%. .*")) then
        return;
    elseif (arg1 == "YOU_JOINED") then
        local name, zoneSuffix = string.gmatch(cname, L["(%w+)%s?(.*)"])();
        local color = self.db.profile.colors[name];
        if (color) then
            ChangeChatColor("CHANNEL"..number, color.r, color.g, color.b);
        else
            color = ChatTypeInfo["CHANNEL"..number];
            self.db.profile.colors[name] = {r=color.r, g=color.g, b=color.b};
        end
    end
end
