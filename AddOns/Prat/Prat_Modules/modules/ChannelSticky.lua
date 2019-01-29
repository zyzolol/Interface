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
Name: PratChannelSticky
Revision: $Revision: 79185 $
Author(s): Curney (asml8ed@gmail.com)
           Krtek (krtek4@gmail.com)
           Sylvanaar (sylvanaar@mindspring.com)
Inspired by: idChat2_StickyChannels by Industrial
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#ChannelSticky
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: Module for Prat that toggles sticky of different chat channel types on and off (default=on).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratChannelSticky")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["ChannelSticky"] = true,
    ["Chat channel sticky options."] = true,
    ["ChatType"] = true,
    ["Per chat type options."] = true,
    ["Channel"] = true,
    ["Sticky %s"] = true,
    ["Toggles sticky on and off for %s."] = true,
    ["smartgroup_name"] = "Smart Groups",
    ["smartgroup_desc"] = "Adds a /gr command which automatically picks the correct type of chat, RAID, PARTY, or BATTLEGROUND",
    ["Sticky Per Chat Frame"] = true,
    ["Toggle remembering the chat type last used per chat frame."] = true,
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["ChannelSticky"] = "Persistance des canaux",
    ["Chat channel sticky options."] = "Options de persistance de canal.",
    ["ChatType"] = "Type de chat",
    ["Per chat type options."] = "Options par type de chat",
    ["Channel"] = "Canal",
    ["Sticky %s"] = "Persistance %s",
    ["Toggles sticky on and off for %s."] = "Active ou d\195\169sactive la persistance pour %s.",
    ["Sticky Per Chat Frame"] = "Persistance par fen\195\170tre de chat",
    ["Toggle remembering the chat type last used per chat frame."] = "Active/d\195\169sactive le type de chat utilis\195\169 la dernière fois pour chaque fen\195\170tre.",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["ChannelSticky"] = "Haftende Kanäle",
    ["Chat channel sticky options."] = "Haftende Chatkanäle Optionen",
    ["ChatType"] = "Chat Typ",
    ["Per chat type options."] = "Nach Chat Typ Optionen",
    ["Channel"] = "Kanal",
    ["Sticky %s"] = "%s Haftend",
    ["Toggles sticky on and off for %s."] = "Schaltet haftend an und aus f\195\188r %s.",
    ["Sticky Per Chat Frame"] = "Haftende Fenster Chat Typen",
    ["Toggle remembering the chat type last used per chat frame."] = "Schaltet das merken des zuletzt genutzten Chat Typen pro Chatfenster ein.",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["ChannelSticky"] = "Canales Pegajosos",
    ["Chat channel sticky options."] = "Opciones para canales pegajosos",
    ["ChatType"] = "Tipo de Chat",
    ["Per chat type options."] = "Opciones por tipo de chat",
    ["Channel"] = "Canal",
    ["Sticky %s"] = "%s Pegajoso",
    ["Toggles sticky on and off for %s."] = "Determina si %s es pegajoso",
    ["Sticky Per Chat Frame"] = "Tipo de Marco de Chat Pegajoso",
    ["Toggle remembering the chat type last used per chat frame."] = "Determina si se recuerda el \195\186ltimo tipo de chat usado por marco de chat",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["ChannelSticky"] = "채널 고정",
    ["Chat channel sticky options."] = "대화 채널 고정 설정입니다.",
    ["ChatType"] = "대화 종류",
    ["Per chat type options."] = "대화 종류에 따른 설정입니다.",
    ["Channel"] = "채널",
    ["Sticky %s"] = "%s 고정",
    ["Toggles sticky on and off for %s."] = "%s에 대한 고정 기능을 사용합니다.",
    ["smartgroup_name"] = "스마트 파티",
    ["smartgroup_desc"] = "대화, 공격대, 파티 혹은 전장 대화를 자동으로 선택하는 /gr 명령어를 추가합니다.",
    ["Sticky Per Chat Frame"] = "대화창별 고정",
    ["Toggle remembering the chat type last used per chat frame."] = "대화창에 따라 마지막에 사용된 대화 종류를 기억합니다.",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["ChannelSticky"] = "頻道固定",
    ["Chat channel sticky options."] = "固定聊天頻道選項。",
-- no use anymore    ["ChatType"] = true,
-- no use anymore    ["Per chat type options."] = true,
    ["Channel"] = "頻道",
    ["Sticky %s"] = "固定%s",
    ["Toggles sticky on and off for %s."] = "切換是否固定%s頻道。",
    ["smartgroup_name"] = "智慧群組",
    ["smartgroup_desc"] = "增加一個 /gr 指令用以自動選擇正確的頻道類型: 團隊，隊伍或戰場。",
    ["Sticky Per Chat Frame"] = "固定每個聊天視窗",
    ["Toggle remembering the chat type last used per chat frame."] = "切換記憶每個聊天視窗最後的頻道類型。",
} end)

--Chinese Translation: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["ChannelSticky"] = "固定频道",
    ["Chat channel sticky options."] = "固定聊天频道选项。",
    ["ChatType"] = "聊天分类",
    ["Per chat type options."] = "聊天类型选项。",
    ["Channel"] = "频道",
    ["Sticky %s"] = "固定%s",
    ["Toggles sticky on and off for %s."] = "切换固定%s频道.",
    ["smartgroup_name"] = "智能团队",
    ["smartgroup_desc"] = "添加 /gr 命令, 自动获取团队/队伍/战场聊天类型",
    ["Sticky Per Chat Frame"] = "固定每个聊天框架",
    ["Toggle remembering the chat type last used per chat frame."] = "切换记忆每个聊天框架最后的聊天分类",
} end)

-- chat channel list
local chatList = {
    "SAY",
    "WHISPER",
    "YELL",
    "PARTY",
    "GUILD",
    "OFFICER",
    "RAID",
    "RAID_WARNING",
    "BATTLEGROUND",
    "CHANNEL",
    "EMOTE",
}



-- create prat module
Prat_ChannelSticky = Prat:NewModule(PRAT_MODULE, LIB.HOOKS)
local Prat_ChannelSticky = Prat_ChannelSticky
Prat_ChannelSticky.pratModuleName = PRAT_MODULE
Prat_ChannelSticky.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_ChannelSticky.moduleName = L["ChannelSticky"]
Prat_ChannelSticky.moduleDesc = L["Chat channel sticky options."]
Prat_ChannelSticky.consoleName = "chansticky"
Prat_ChannelSticky.guiName = L["ChannelSticky"]


-- define the default db values
Prat_ChannelSticky.defaultDB = {
    on = true,
    say = true,
    whisper = true,
    yell = true,
    party = true,
    guild = true,
    officer = true,
    raid = true,
    raid_warning = true,
    battleground = true,
    channel = true,
    emote = true,
    perframe = false,
    smartgroup = false,
}

-- build the options menu using prat templates
Prat_ChannelSticky.toggleOptions = { optsep_sep = 190, smartgroup=195, optsep2_sep=196 }

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_ChannelSticky.moduleOptions = {}

-- add module options not covered by templates
function Prat_ChannelSticky:GetModuleOptions()
    self.moduleOptions = {
        name = L["ChannelSticky"],
        desc = L["Chat channel sticky options."],
        type = "group",
        args = {
            perframe = {
                name = L["Sticky Per Chat Frame"],
                desc = L["Toggle remembering the chat type last used per chat frame."],
                type = "toggle",
                get = function() return self.db.profile.stickychan end,
                set = function(v)
                    self.db.profile.stickychan = v
                    self:StickyFrameChan(v)
                end,
                order = 200,
            },
        }
    }
    self:BuildChannelList()
    return self.moduleOptions
end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

function Prat_ChannelSticky:OnModuleEnable()
    -- build options
    self:BuildChannelList()
    -- register events
    self[LIB.REGISTEREVENT](self, "UPDATE_CHAT_COLOR");
    -- sticky each channel based on db settings
    self:Stickum("SAY",self.db.profile.say)
    self:Stickum("WHISPER",self.db.profile.whisper)
    self:Stickum("YELL",self.db.profile.yell)
    self:Stickum("PARTY",self.db.profile.party)
    self:Stickum("GUILD",self.db.profile.guild)
    self:Stickum("OFFICER",self.db.profile.officer)
    self:Stickum("RAID",self.db.profile.raid)
    self:Stickum("RAID_WARNING",self.db.profile.raid_warning)
    self:Stickum("BATTLEGROUND",self.db.profile.battleground)
    self:Stickum("CHANNEL",self.db.profile.channel)
    self:Stickum("EMOTE",self.db.profile.emote)
    -- sticky per chat frame based on db settings
    self:StickyFrameChan(self.db.profile.stickychan)
    
    self[LIB.REGISTEREVENT](self, "Prat_OutboundChat")
    
    if self.db.profile.smartgroup then 
        self:RegisterSmartGroup()
    end
end

function Prat_ChannelSticky:OnModuleDisable()
    -- dont sticky no mo!
    self:Stickum("SAY",false)
    self:Stickum("WHISPER",false)
    self:Stickum("YELL",false)
    self:Stickum("PARTY",false)
    self:Stickum("GUILD",false)
    self:Stickum("OFFICER",false)
    self:Stickum("RAID",false)
    self:Stickum("RAID_WARNING",false)
    self:Stickum("BATTLEGROUND",false)
    self:Stickum("CHANNEL",false)
    self:Stickum("EMOTE",false)
    -- forget about per chat frame stickying
    self:StickyFrameChan(false)
    -- unregister events
    self:UnregisterAllEvents()
end

--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--

-- rebuild options menu is chat colors change
function Prat_ChannelSticky:UPDATE_CHAT_COLOR()
    self:BuildChannelList()
end

function Prat_ChannelSticky:StickyFrameChan(enabled)
    if not enabled then
        self:UnhookAll()
    else
        self.perframe = {}
        self.perframechannum = {}
        self:Hook("ChatFrame_OpenChat", true)
        self:SecureHook("ChatEdit_OnEscapePressed")
        self:SecureHook("SendChatMessage")
        self:SecureHook("ChatEdit_OnEnterPressed")
    end
end

function Prat_ChannelSticky:ChatFrame_OpenChat(text, chatFrame)
    if ( not chatFrame ) then
        chatFrame = SELECTED_CHAT_FRAME
    end
    
    if chatFrame.editBox == nil then
        return self.hooks["ChatFrame_OpenChat"](text, chatFrame)
    end
    
    local chatFrameN = chatFrame:GetName()
    if self:IsDebugging() then
       self:Debug("ChatFrame_OpenChat() - "..chatFrameN.." -> "..(chatFrame.editBox:GetAttribute("chatType") or "nil"))
    end
    if chatFrame.editBox:GetAttribute("chatType") == "WHISPER" then
    if self:IsDebugging() then
       self:Debug("ChatFrame_OpenChat() - "..(chatFrame.editBox:GetAttribute("chatType") or "nil").." -> "..(chatFrame.editBox:GetAttribute("tellTarget") or "nil"))
    end
    elseif chatFrame.editBox:GetAttribute("chatType") == "GROUPSAY" then
        local t = self:SmartGroupChatType()
    if self:IsDebugging() then
        self:Debug("ChatFrame_OpenChat() - GROUPSAY:"..t)
    end
        chatFrame.editBox:SetAttribute("chatType", t);
        chatFrame.editBox:SetAttribute("origchatType", "GROUPSAY");
    elseif self.perframe[chatFrameN] then
    if self:IsDebugging() then
        self:Debug("ChatFrame_OpenChat() - "..chatFrameN.." was -> "..self.perframe[chatFrameN])
    end
        chatFrame.editBox:SetAttribute("channelTarget", self.perframechannum[chatFrameN]);
        chatFrame.editBox:SetAttribute("chatType", self.perframe[chatFrameN]);
        chatFrame.editBox:SetAttribute("stickyType", self.perframe[chatFrameN]);
    end
    self.hooks["ChatFrame_OpenChat"](text, chatFrame)
end

function Prat_ChannelSticky:SendChatMessage(msg, chatType, language, channel)
    if self:IsDebugging() then
        self:Debug("SendChatMessage() - "..chatType.."["..(channel or "").."] -> "..msg)
    end
    if self.memoNext then
	if self:IsDebugging() then
	    self:Debug("SendChatMessage() - "..self.memoNext.." -> "..chatType.."["..(channel or "").."]")
        end
        self.perframe[self.memoNext] = chatType
        self.perframechannum[self.memoNext] = channel
    end
end

function Prat_ChannelSticky:ChatEdit_OnEscapePressed()
    self:Debug("ChatEdit_OnEscapePressed()")
    self.memoNext = nil
end

function Prat_ChannelSticky:ChatEdit_OnEnterPressed()
    self:Debug("ChatEdit_OnEnterPressed()")
    local chatFrameN = SELECTED_CHAT_FRAME:GetName()
    local chatType = this:GetAttribute("chatType")
    local ochatType = this:GetAttribute("origchatType")
    if ochatType == "GROUPSAY" then
        this:SetAttribute("chatType", ochatType)
        chatType = "GROUPSAY"
    end
    
    local channel = this:GetAttribute("channelTarget")
    self:Debug("ChatEdit_OnEnterPressed() - Saved "..chatFrameN.." -> "..chatType.."["..(channel or "").."]")
    self.perframe[chatFrameN] = chatType
    self.perframechannum[chatFrameN] = channel
    self.memoNext = nil
end

-- Toggle sticky parameter
function Prat_ChannelSticky:Stickum(channel,stickied)
    if stickied then
        ChatTypeInfo[channel].sticky = 1
    else
        ChatTypeInfo[channel].sticky = 0
    end
end

--[[------------------------------------------------
    Menu Builder Functions
------------------------------------------------]]--

function Prat_ChannelSticky:BuildChannelList()
    local o = self.moduleOptions.args
    for _,va in ipairs(chatList) do
        local val = va
        local chan
        if val ~= "CHANNEL" then
            chan = TEXT(getglobal("CHAT_MSG_"..val))
        else
            chan = L["Channel"]
        end
        o[val] = {
            name = string.format(L["Sticky %s"], CLR:StkyChatType(string.gsub(chan, " ", ""), val)),
            desc = string.format(L["Toggles sticky on and off for %s."], chan),
            type = "toggle",
            get = function() return self.db.profile[string.lower(val)] end,
            set = function(v)
                self.db.profile[string.lower(val)] = v
                self:Stickum(val ,v)
            end
        }
    end
end

function CLR:StkyChatType(text, type) return self:Colorize(Prat_ChannelSticky:GetChatCLR(type), text) end

function Prat_ChannelSticky:GetChatCLR(name)
    local info = ChatTypeInfo[name];
    if not info then
        return CLR.COLOR_NONE
    end
    return CLR:GetHexColor(info)
end


function Prat_ChannelSticky:RegisterSmartGroup()
    if not self.smart_group then
        self.smart_group = true
        Prat:RegisterChatCommand({ "/group", "/gr" }, function(text)   
                 if text:trim():len() > 0 then   
                     local _,pvp = IsInInstance()   
                     if pvp == "pvp" then   
                         SendChatMessage(text, "BATTLEGROUND")   
                     elseif GetNumRaidMembers() > 0 then   
                         SendChatMessage(text, "RAID")   
                     elseif GetNumPartyMembers() > 0 then   
                         SendChatMessage(text, "PARTY")   
                     end   
                 end   
             end, "GROUPSAY")   
             
       ChatTypeInfo["GROUPSAY"] = { r=0.5, g=0.9, b=0.9, sticky = 1 }
       CHAT_GROUPSAY_SEND = "SmartGroup:\32 "
       CHAT_GROUPSAY_GET = "SmartGroup: %1\32 "
    end
end


function Prat_ChannelSticky:SmartGroupChatType()
     local _,pvp = IsInInstance()   

     if pvp == "pvp" then   
        return "BATTLEGROUND"  
     elseif GetNumRaidMembers() > 0 then   
         return "RAID"
     elseif GetNumPartyMembers() > 0 then   
         return "PARTY"
     end 
     
    return "SAY"
end  

function Prat_ChannelSticky:Prat_OutboundChat(m)
   if m.CTYPE == "GROUPSAY" then
    m.CTYPE = self:SmartGroupChatType()
   end
end