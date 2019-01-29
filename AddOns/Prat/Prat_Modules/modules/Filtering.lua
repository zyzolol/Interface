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
Name: PratFiltering
Revision: $Revision: 79185 $
Author(s): Sylvanaar
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#Filtering
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: A module to provide basic chat filtering. (default=off).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratFiltering")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
	["Filtering"] = true,
	["A module to provide basic chat filtering."] = true,
    ["leavejoin_name"] = "Filter Channel Leave/Join",
    ["leavejoin_desc"] = "Filter out channel leave/join spam",
    ["notices_name"] = "Filter Channel Notices",
    ["notices_desc"] = "Filter out other custom channel notification messages, e.g. moderator changes.",
    ["bgjoin_name"] = "Filter BG Leave/Join",
    ["bgjoin_desc"] = "Filter out channel Battleground leave/join spam",
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79185 $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["Filtering"] = "信息过滤",
    ["A module to provide basic chat filtering."] = "提供基本聊天过滤功能.",
    ["leavejoin_name"] = "过滤频道离开/加入",
    ["leavejoin_desc"] = "过滤离开/加入频道的讯息",
    ["notices_name"] = "过滤频道通知",
    ["notices_desc"] = "过滤其他频道通知讯息, 例如频道修改权限变化.",
    ["bgjoin_name"] = "过滤战场离开/加入",
    ["bgjoin_desc"] = "过滤离开/加入战场频道的讯息",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["Filtering"] = "訊息過濾",
    ["A module to provide basic chat filtering."] = "提供基本過濾功能的模組。",
    ["leavejoin_name"] = "過濾離開/加入頻道",
    ["leavejoin_desc"] = "過濾離開/加入頻道的訊息。",
    ["notices_name"] = "過濾頻道通知",
    ["notices_desc"] = "過濾其他頻道通知訊息，例如頻道修改權變更。",
    ["bgjoin_name"] = "過濾戰場離開/加入",
    ["bgjoin_desc"] = "過濾戰場離開/加入的頻道訊息。",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
	["Filtering"] = "필터링",
	["A module to provide basic chat filtering."] = "기본 대화 필터링을 제공하는 모듈입니다.",
	["leavejoin_name"] = "채널 참가/떠남 필터",
	["leavejoin_desc"] = "채널 참가/떠남 스팸을 제거합니다.",
	["notices_name"] = "채널 알림 필터링",
	["notices_desc"] = "다른 사용자 지정 채널 알림 메세지를 필터링합니다, 예. moderator changes.",
	["bgjoin_name"] = "전장 떠남/참가 필터링",
	["bgjoin_desc"] = "전장 떠남/참가 스팸을 필터링합니다.",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
	["Filtering"] = "Filterrung",
	["A module to provide basic chat filtering."] = "Ein Modul das einen grundlegenden Chatfilter bietet.",
    ["leavejoin_name"] = "Filtere Kanal Verlassen/Betreten",
    ["leavejoin_desc"] = "Rausfiltern von Kanal verlassen/betreten Spam.",
    ["notices_name"] = "Filtere Kanal Benachrichtigungen",
    ["notices_desc"] = "Rausfiltern von vorgegeben Kanal Benachrichtigunsmeldungen, z.B: Moderator änderrungen.",
    ["bgjoin_name"] = "Filtere BG Verlassen/Betreten",
    ["bgjoin_desc"] = "Rausfiltern des Schlachtfeld Verlassen/Betreten Spam.",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
	["Filtering"] = "Filtrado",
	["A module to provide basic chat filtering."] = "Un módulo que permite un filtrado de chat básico",
    ["leavejoin_name"] = "Filtrar Unión/Abandono de canal",
    ["leavejoin_desc"] = "Filtra los mensajes que aparecen cuando alguien se une o abandona un canal",
    ["notices_name"] = "Filtrar Noticias de Canal",
    ["notices_desc"] = "Filtra los mensajes de notificación de los canales, ej: cambios de moderador.",
} end)



-- create prat module
Prat_Filtering = Prat:NewModule(PRAT_MODULE)
local Prat_Filtering = Prat_Filtering
Prat_Filtering.pratModuleName = PRAT_MODULE
Prat_Filtering.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_Filtering.moduleName = L["Filtering"] 	
Prat_Filtering.moduleDesc = L["A module to provide basic chat filtering."] 	
Prat_Filtering.consoleName = string.lower(Prat_Filtering.moduleName)
Prat_Filtering.guiName = Prat_Filtering.moduleName

-- default values for any settings that need them
Prat_Filtering.defaultDB = {
	on	= false,
    leavejoin = true,
    notices = true,
    bgjoin = false,
}

-- init moduleOoptions (which gets populated by the other
-- various options tables below
Prat_Filtering.moduleOptions = {}

-- any boolean options
Prat_Filtering.toggleOptions = {
    leavejoin = 100,
    notices = 110,
    bgjoin = 111,
}

--ERR_BG_PLAYER_JOINED_SS = "|Hplayer:%s|h[%s]|h has joined the battle";
--ERR_BG_PLAYER_LEFT_S = "%s has left the battle"-; 

-- ERR_RAID_MEMBER_ADDED_S = "%s has joined the raid group";
-- ERR_RAID_MEMBER_REMOVED_S = "%s has left the raid group";

--local RAID_JOIN =  string.gsub( ERR_RAID_MEMBER_ADDED_S, "%%s(.*)", "(.+)(%1)")
--local RAID_LEAVE =  string.gsub( ERR_RAID_MEMBER_REMOVED_S, "%%s(.*)", "(.+)(%1)")

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--
local deformat
-- things to do when the module is enabled
function Prat_Filtering:OnModuleEnable()

	-- register events
	self[LIB.REGISTEREVENT](self, "Prat_FrameMessage")
end

-- things to do when the module is disabled
function Prat_Filtering:OnModuleDisable()
	-- unregister events
	self:UnregisterAllEvents()
end

--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--

--
-- Prat Event Implementation
--

function Prat_Filtering:Prat_FrameMessage(message, frame, event)
    if self.db.profile.leavejoin then 
    	if  event == "CHAT_MSG_CHANNEL_JOIN" or event == "CHAT_MSG_CHANNEL_LEAVE"  then
    		message.DONOTPROCESS = true
    	end
    end
    
        	
    if self.db.profile.notices then 
    	if  event == "CHAT_MSG_CHANNEL_NOTICE_USER" or event == "CHAT_MSG_CHANNEL_NOTICE"  then
    		message.DONOTPROCESS = true
    	end
    end
    
    if self.db.profile.bgjoin and event == "CHAT_MSG_SYSTEM" then 
        if MiniMapBattlefieldFrame.status == "active" then
		    deformat = deformat or PRAT_LIBRARY(LIB.PARSING)

            if deformat:Deformat(message.ORG.MESSAGE, ERR_BG_PLAYER_JOINED_SS) then
                self:Debug("bgjoin", message.ORG)
                message.DONOTPROCESS = true
            elseif deformat:Deformat(message.ORG.MESSAGE,  ERR_BG_PLAYER_LEFT_S) then
                message.DONOTPROCESS = true
                self:Debug("bgleave", message.ORG)
            end   
        end
   end        
end