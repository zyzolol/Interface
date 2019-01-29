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
Name: PratSounds
Revision: $Revision: 79185 $
Author(s): Sylvanaar - Copy/Pasted from ChatSounds hy TotalPackage
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#Filtering
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: A port of the Chatsounds addon to the Prat framework. (default=off).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratSounds")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
	["Sounds"] = true,
	["A module to play sounds on certain chat messages."] = true,
	["Add a custom channel"] = true,
	["Play a sound for a certain channel name (can be a substring)"] = true,
	["Remove a custom channel"] = true,
	["Reset settings"] = true,
	["Restore default settings and resets custom channel list"] = true,
	["Incoming Sounds"] = true,
	["Sound selection for incoming chat messages"] = true,
	["Party"] = true,
	["Sound for incoming party messages"] = true,
	["Raid"] = true,
	["Sound for incoming raid or battleground group/leader messages"] = true,
	["Guild"] = true,
	["Sound for incoming guild messages"] = true,
	["Officer/Custom"] = true,
	["Sound for incoming officer or custom channel messages"] = true,
	["Whisper"] = true,
	["Sound for incoming whisper messages"] = true,
	["Outgoing Sounds"] = true,
	["Sound selection for outgoing (from you) chat messages"] = true,
	["Sound for outgoing party messages"] = true,
	["Sound for outgoing raid or battleground group/leader messages"] = true,
	["Sound for outgoing guild messages"] = true,
	["Sound for outgoing officer or custom channel messages"] = true,
	["Sound for outgoing whisper messages"] = true,
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79185 $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
	["Sounds"] = "声音",
	["A module to play sounds on certain chat messages."] = "特定聊天消息出现时播放声音提醒.",
	["Add a custom channel"] = "增加自定义频道",
	["Play a sound for a certain channel name (can be a substring)"] = "频道有消息时播放音效 (可以是子字符串)。",
	["Remove a custom channel"] = "移除自定义频道",
	["Reset settings"] = "重设",
	["Restore default settings and resets custom channel list"] = "重设回默认值和重设自定义频道列表。",
	["Incoming Sounds"] = "音效 (入)",
	["Sound selection for incoming chat messages"] = "聊天消息 (入) 的音效。",
	["Party"] = "队伍",
	["Sound for incoming party messages"] = "队伍频道 (入) 的音效。",
	["Raid"] = "团队",
	["Sound for incoming raid or battleground group/leader messages"] = "团队/团队队长/战场/战场指挥频道 (入) 的音效。",
	["Guild"] = "公会",
	["Sound for incoming guild messages"] = "公会频道 (入) 的音效。",
	["Officer/Custom"] = "公会官员/自定义",
	["Sound for incoming officer or custom channel messages"] = "公会官员/自定义频道 (入) 的音效。",
	["Whisper"] = "悄悄话",
	["Sound for incoming whisper messages"] = "悄悄话 (入) 的音效。",
	["Outgoing Sounds"] = "音效 (出)",
	["Sound selection for outgoing (from you) chat messages"] = "聊天消息 (出) 的音效。",
	["Sound for outgoing party messages"] = "队伍频道 (出) 的音效。",
	["Sound for outgoing raid or battleground group/leader messages"] = "团队/团队队长/战场/战场指挥频道 (出) 的音效。",
	["Sound for outgoing guild messages"] = "公会频道 (出) 的音效。",
	["Sound for outgoing officer or custom channel messages"] = "公会官员/自定义频道 (出) 的音效。",
	["Sound for outgoing whisper messages"] = "悄悄话 (出) 的音效。",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
	["Sounds"] = "音效",
	["A module to play sounds on certain chat messages."] = "在特定聊天訊息出現時播放音效。",
	["Add a custom channel"] = "增加自訂頻道",
	["Play a sound for a certain channel name (can be a substring)"] = "頻道有訊息時播放音效 (可以是子字串)。",
	["Remove a custom channel"] = "移除自訂頻道",
	["Reset settings"] = "重設",
	["Restore default settings and resets custom channel list"] = "重設回預設值和重設自訂頻道列表。",
	["Incoming Sounds"] = "音效 (入)",
	["Sound selection for incoming chat messages"] = "聊天訊息 (入) 的音效。",
	["Party"] = "隊伍",
	["Sound for incoming party messages"] = "隊伍頻道 (入) 的音效。",
	["Raid"] = "團隊",
	["Sound for incoming raid or battleground group/leader messages"] = "團隊/團隊隊長/戰場/戰場領導者頻道 (入) 的音效。",
	["Guild"] = "公會",
	["Sound for incoming guild messages"] = "公會頻道 (入) 的音效。",
	["Officer/Custom"] = "公會理事/自訂",
	["Sound for incoming officer or custom channel messages"] = "公會理事/自訂頻道 (入) 的音效。",
	["Whisper"] = "悄悄話",
	["Sound for incoming whisper messages"] = "悄悄話 (入) 的音效。",
	["Outgoing Sounds"] = "音效 (出)",
	["Sound selection for outgoing (from you) chat messages"] = "聊天訊息 (出) 的音效。",
	["Sound for outgoing party messages"] = "隊伍頻道 (出) 的音效。",
	["Sound for outgoing raid or battleground group/leader messages"] = "團隊/團隊隊長/戰場/戰場領導者頻道 (出) 的音效。",
	["Sound for outgoing guild messages"] = "公會頻道 (出) 的音效。",
	["Sound for outgoing officer or custom channel messages"] = "公會理事/自訂頻道 (出) 的音效。",
	["Sound for outgoing whisper messages"] = "悄悄話 (出) 的音效。",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
	["Sounds"] = "Sounds",
	["A module to play sounds on certain chat messages."] = "Ein Modul um Sounds jeh nach Chatnachrichtenart abzuspielen.",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
	["Sounds"] = "효과음",
	["A module to play sounds on certain chat messages."] = "특정 대화 메세지에 효과음을 재생하기 위한 모듈입니다.",
	["Add a custom channel"] = "사용자 채널 추가",
	["Play a sound for a certain channel name (can be a substring)"] = "특정 채널명에 대한 효과음을 재생합니다.(단축 문자열 가능)",
	["Remove a custom channel"] = "사용자 채널 제거",
	["Reset settings"] = "설정 초기화",
	["Restore default settings and resets custom channel list"] = "사용자 채널 목록을 초기화 하고 기본 설정으로 복원합니다.",
	["Incoming Sounds"] = "받은 메세지 효과음",
	["Sound selection for incoming chat messages"] = "받은 대화 메세지에 대한 효과음 선택",
	["Sound selection for outgoing (from you) chat messages"] = "보낸 대화 메세지에 대한 효과음 선택",
	["Party"] = "파티",
	["Sound for incoming party messages"] = "받은 파티 메세지에 대한 효과음",
	["Raid"] = "공격대",
	["Sound for incoming raid or battleground group/leader messages"] = "받은 공격대 혹은 전장 파티/지휘관 메세지에 대한 효과음",
	["Guild"] = "길드",
	["Sound for incoming guild messages"] = "받은 길드 메세지에 대한 효과음",
	["Officer/Custom"] = "오피서/사용자",
	["Sound for incoming officer or custom channel messages"] = "받은 오피서 혹은 사용자 채널 메세지에 대한 효과음",
	["Whisper"] = "귓속말",
	["Sound for incoming whisper messages"] = "받은 귓속말 메세지에 대한 효과음",
	["Outgoing Sounds"] = "보낸 메세지 효과음",
	["Sound for outgoing party messages"] = "보낸 파티 메세지에 대한 효과음",
	["Sound for outgoing raid or battleground group/leader messages"] = "보낸 공격대 혹은 전장 파티/지휘관 메세지에 대한 효과음",
	["Sound for outgoing guild messages"] = "보낸 길드 메세지에 대한 효과음",
	["Sound for outgoing officer or custom channel messages"] = "보낸 오피서 혹은 사용자 채널 메세지에 대한 효과음",
	["Sound for outgoing whisper messages"] = "보낸 귓속말 메세지에 대한 효과음",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
	["Sounds"] = "Sonidos",
	["A module to play sounds on certain chat messages."] = "Un módulo que permite reproducir sonidos para ciertos mensajes de chat.",
} end)



-- create prat module
Prat_Sounds = Prat:NewModule(PRAT_MODULE)
local Prat_Sounds = Prat_Sounds
Prat_Sounds.pratModuleName = PRAT_MODULE
Prat_Sounds.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_Sounds.moduleName = L["Sounds"] 	
Prat_Sounds.moduleDesc = L["A module to play sounds on certain chat messages."] 	

Prat_Sounds.consoleName = string.lower(Prat_Sounds.moduleName)
Prat_Sounds.guiName = Prat_Sounds.moduleName


-- init moduleOoptions (which gets populated by the other
-- various options tables below
Prat_Sounds.moduleOptions = {}

-- default values for any settings that need them
Prat_Sounds.defaultDB = {
	on	= false,
	["incoming"] = {
		["GUILD"] = "Kachink",
		["OFFICER"] = "Link",
		["PARTY"] = "Text1",
		["RAID"] = "Text2",
		["WHISPER"] = "Heart",
	},
	["outgoing"] = {
		["GUILD"] = "none",
		["OFFICER"] = "none",
		["PARTY"] = "none",
		["RAID"] = "none",
		["WHISPER"] = "none",
	},
	["customlist"] =
	GetLocale() == "zhTW" and {
	}
	or {
		"healer",
		"pall",
		"priest",
		"warrior",
		"mage",
		"hunter",
		"druid",
		"lock",
		"rogue",
	},
}

-- any boolean options
Prat_Sounds.toggleOptions = { sep19_sep=19, sep9_sep=9 }

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--
-- things to do when the module is enabled
function Prat_Sounds:OnModuleEnable(first)
    if first then
        media = PRAT_LIBRARY(LIB.MEDIA)

		self:BuildSoundList()
	end
	
	self[LIB.REGISTEREVENT](self, Prat.Events.OUTBOUND)	
	self[LIB.REGISTEREVENT](self, Prat.Events.POST_ADDMESSAGE)	
	

    if media.RegisterCallback then
		media.RegisterCallback(self, "LibSharedMedia_Registered", "SharedMedia_Registered")
	else
		self[LIB.REGISTEREVENT](self, "SharedMedia_Registered")
    end
end

-- things to do when the module is disabled
function Prat_Sounds:OnModuleDisable()
	-- unregister events
	self:UnregisterAllEvents()

    if media.UnregisterCallback then
		media.UnregisterCallback(self, "LibSharedMedia_Registered")
    end
end

function Prat_Sounds:Prat_OutboundChat(m)
    if self:IsDebugging() then
        self:Debug("Prat_OutboundChat", m.CTYPE, Prat:GetEventID())
    end
end

local soundslist = {}


function Prat_Sounds:BuildSoundList()
	if not media then return end

    for i,v in ipairs(soundslist) do
        soundslist[i] = nil
    end
    
    for k,v in pairs(Prat.sounds) do
        table.insert(soundslist, k)
    end

    for k,v in pairs(media:List(media.MediaType.SOUND)) do
        if not Prat.sounds[v] then 
            table.insert(soundslist, v)
        end
    end
    
    -- SML has a None sound
    --table.insert(soundslist, "none")
end

function Prat_Sounds:SharedMedia_Registered(mediatype, name)
    if mediatype == media.MediaType.SOUND then
        self:BuildSoundList()
    end
end

function Prat_Sounds:GetModuleOptions()
	local db = self.db.profile
	
	self:BuildSoundList()
	
    self.moduleOptions = {
        name = L["Sounds"],
        desc = L["A module to play sounds on certain chat messages."],
        type = "group",
		args = {
			custom = {
				type = "text",
				name = L["Add a custom channel"],
				desc = L["Play a sound for a certain channel name (can be a substring)"],
				set = function(v) tinsert(db.customlist, v) end,
				get = function() return end,
				usage = "",
				order = 3,
			},
			
            removenick = {
                name = L["Remove a custom channel"],
                desc = L["Remove a custom channel"],
                type = "text",
                order = 4,
				current = "",
				get = function() return "" end,
				validate = db.customlist,
                disabled = function() return #db.customlist == 0 end,
				set = function(v) for i,v2 in ipairs(db.customlist) do if v == v2 then tremove(db.customlist, i) end end end,
            },			
			reset = {
				type = "execute",
				name = L["Reset settings"],
				desc = L["Restore default settings and resets custom channel list"],
--				func = function() db.customlist = { } Prat_Sounds:ResetDB() end,
				func = function() db.customlist = { } db.customlist = Prat_Sounds.defaultDB.customlist end,
				order = 10,
			},
			inc = {
				type = "group",
				name = L["Incoming Sounds"],
				desc = L["Sound selection for incoming chat messages"],
				order = 20,
				hidden = function() Prat_Sounds:BuildSoundList() end,
				args = {
					party = {
						type = "text",
						name = L["Party"],
						desc = L["Sound for incoming party messages"],
						get = function() return db.incoming["PARTY"] end,
						set = function(v) Prat:PlaySound(v) db.incoming["PARTY"] = v end,
						order = 1,
						validate = soundslist,
					},
					raid = {
						type = "text",
						name = L["Raid"],
						desc = L["Sound for incoming raid or battleground group/leader messages"],
						get = function() return db.incoming["RAID"] end,
						set = function(v) Prat:PlaySound(v) db.incoming["RAID"] = v end,
						order = 2,
						validate = soundslist,
					},
					guild = {
						type = "text",
						name = L["Guild"],
						desc = L["Sound for incoming guild messages"],
						get = function() return db.incoming["GUILD"] end,
						set = function(v) Prat:PlaySound(v) db.incoming["GUILD"] = v end,
						order = 3,
						validate = soundslist,
					},
					officer = {
						type = "text",
						name = L["Officer/Custom"],
						desc = L["Sound for incoming officer or custom channel messages"],
						get = function() return db.incoming["OFFICER"] end,
						set = function(v) Prat:PlaySound(v) db.incoming["OFFICER"] = v end,
						order = 4,
						validate = soundslist,
					},
					whisper = {
						type = "text",
						name = L["Whisper"],
						desc = L["Sound for incoming whisper messages"],
						get = function() return db.incoming["WHISPER"] end,
						set = function(v) Prat:PlaySound(v) db.incoming["WHISPER"] = v end,
						order = 5,
						validate = soundslist,
					},
				},
			},
			out = {
				type = "group",
				name = L["Outgoing Sounds"],
				desc = L["Sound selection for outgoing (from you) chat messages"],
				order = 30,
				args = {
					party = {
						type = "text",
						name = L["Party"],
						desc = L["Sound for outgoing party messages"],
						get = function() return db.outgoing["PARTY"] end,
						set = function(v) Prat:PlaySound(v) db.outgoing["PARTY"] = v end,
						order = 1,
						validate = soundslist,
					},
					raid = {
						type = "text",
						name = L["Raid"],
						desc = L["Sound for outgoing raid or battleground group/leader messages"],
						get = function() return db.outgoing["RAID"] end,
						set = function(v) Prat:PlaySound(v) db.outgoing["RAID"] = v end,
						order = 2,
						validate = soundslist,
					},
					guild = {
						type = "text",
						name = L["Guild"],
						desc = L["Sound for outgoing guild messages"],
						get = function() return db.outgoing["GUILD"] end,
						set = function(v) Prat:PlaySound(v) db.outgoing["GUILD"] = v end,
						order = 3,
						validate = soundslist,
					},
					officer = {
						type = "text",
						name = L["Officer/Custom"],
						desc = L["Sound for outgoing officer or custom channel messages"],
						get = function() return db.outgoing["OFFICER"] end,
						set = function(v) Prat:PlaySound(v) db.outgoing["OFFICER"] = v end,
						order = 4,
						validate = soundslist,
					},
					whisper = {
						type = "text",
						name = L["Whisper"],
						desc = L["Sound for outgoing whisper messages"],
						get = function() return db.outgoing["WHISPER"] end,
						set = function(v) Prat:PlaySound(v) db.outgoing["WHISPER"] = v end,
						order = 5,
						validate = soundslist,
					},
				},
			},
		},
	}
	
  	return self.moduleOptions	
end


--[[------------------------------------------------
	Core Functions
------------------------------------------------]]--
function Prat_Sounds:Prat_PostAddMessage(message, frame, event, text, r, g, b, id)
    if Prat:GetEventID() and Prat:GetEventID() == self.lastevent and self.lasteventtype == event then return end
    
	local msgtype = string.sub(event, 10)
	local plr, svr = strsplit("-", (message.PLAYERLINK or ""))
	local outgoing = (plr == UnitName("player")) and true or false
	local sndprof = outgoing and self.db.profile.outgoing or self.db.profile.incoming

    if self:IsDebugging() then 
        self:Debug("Prat_PostAddMessage", msgtype, frame:GetName(), Prat:GetEventID())
    end  
    
    if msgtype == "CHANNEL" then 
	    local chan = string.lower(message.ORG.CHANNEL)
        if self:IsDebugging() then 
            self:Debug("ChatEvent", event, chan)
        end
		for _,value in pairs(self.db.profile.customlist) do
			if strlen(value) > 0 and string.find(chan, string.lower(value)) then
                self:PlaySound(sndprof["OFFICER"], event)
			end
		end
    else 
		if msgtype == "WHISPER_INFORM" then
		    msgtype = "WHISPER"
		    sndprof = self.db.profile.outgoing
		elseif msgtype == "WHISPER" then
		    sndprof = self.db.profile.incoming
		end
		
		if msgtype == "RAID_LEADER" or msgtype == "BATTLEGROUND" or msgtype == "BATTLEGROUND_LEADER" then
			msgtype = "RAID"
		end
 
		self:PlaySound(sndprof[msgtype], event)
    end
end


function Prat_Sounds:PlaySound(sound, event)
    if self:IsDebugging() then 
        self:Debug("PlaySound", sound, Prat:GetEventID())
    end
    self.lasteventtype = event
    self.lastevent = Prat:GetEventID()
    Prat:PlaySound(sound)
end