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
Name: Prat_CustomFilters
Revision: $Revision: 79185 $
Author(s):  Sylvanaar (sylvanaar@mindspring.com)
Website: http://files.wowace.com/Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#CustomFilters
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: Module to support custom filters. (default=off).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("CustomFilters")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
	["CustomFilters"] = true,
	["Module to support custom filters."] = true,
    ["Add Pattern"] = true,
    ["Add a pattern to search for."] = true,
    ["Remove Pattern"] = true,
    ["Remove an existing pattern."] = true,
	["Pattern Options"] = true,
	["Inbound"] = true,
	["Outbound"] = true,
	["Search Pattern"] = true,
	["Search Format String"] = true,
	["Supplied pattern is a format string instead of a pattern"] = true,	
	["<string>"] = true,
	["Replacement Text"] = true,
	["Block Message"] = true,
	["Prevent the message from being displayed"] = true,
	["Hilight Match Text"] = true,
	["Hilight Color"] = true,
	["Secondary Output"] = true,
	["Send to a secondary output"] = true,
	["Play Sound"] = true,
	["Play a sound when this message is output to the chatframe"] = true,
    ["Forward"] = true, 
    ["ForwardMessage"] = true,     
    ["Forward the message to a chat channel."] = true,	
    ["Output Channel"] = true,
    ["Channel to send output text to."] = true,
    ["Channel Data"] = true,
    ["Extra data for WHISPER (target) and CHANNEL (channel name or num)"] = true,
	["Output Message Only"] = true;
	["Only output the message portion of the chat text, leave out the channel, and playername etc."] = true
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
	["CustomFilters"] = "사용자 필터",
	["Module to support custom filters."] = "사용자 필터를 지원하는 모듈입니다.",
	["Add Pattern"] = "패턴 추가",
	["Add a pattern to search for."] = "탐색할 패턴을 추가합니다.",
	["Remove Pattern"] = "패턴 제거",
	["Remove an existing pattern."] = "기존의 패턴을 삭제합니다.",
	["Pattern Options"] = "패턴 설정",
	["Inbound"] = "받는 메세지",
	["Outbound"] = "보내는 메세지",
	["Search Pattern"] = "패턴 탐색",
	["Search Format String"] = "형식 문자열 탐색",
	["Supplied pattern is a format string instead of a pattern"] = "제공된 패턴은 패턴 대신 형식 문자열입니다.",	
	["<string>"] = "<문자열>",
	["Replacement Text"] = "문장 대체",
	["Block Message"] = "메세지 차단",
	["Prevent the message from being displayed"] = "메세지가 표시되는 것을 차단합니다.",
	["Hilight Match Text"] = "일치 문장 강조",
	["Hilight Color"] = "강조 색상",
	["Secondary Output"] = "두번째 출력",
	["Send to a secondary output"] = "두번째 출력에 전송합니다.",
	["Play Sound"] = "효과음 재생",
	["Play a sound when this message is output to the chatframe"] = "해당 메세지를 대화창에 출력할 때 효과음을 재생합니다.",
	["Forward"] = "전달", 
	["ForwardMessage"] = "전달 메세지",     
	["Forward the message to a chat channel."] = "대화 채널에 메세지를 전달합니다.",	
	["Output Channel"] = "출력 채널",
	["Channel to send output text to."] = "출력 텍스트를 전송할 채널입니다.",
	["Channel Data"] = "채널 데이터",
	["Extra data for WHISPER (target) and CHANNEL (channel name or num)"] = "귓속말 (대상) 과 채널 (채널명 혹은 번호)에 대한 부가 데이터",
	["Output Message Only"] = "출력 메세지만",
	["Only output the message portion of the chat text, leave out the channel, and playername etc."] = "대화글, 채널 떠남과 플레이어 이름등의 메세지 일부만 출력합니다."
} end)

--Chinese Translation: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L[LIB.NEWLOCALE](L, "zhCN", function() return {
	["CustomFilters"] = "自定义过滤",
	["Module to support custom filters."] = "支持自定义过滤模块",
    ["Add Pattern"] = "增加字符串",
    ["Add a pattern to search for."] = "增加搜索字符串",
    ["Remove Pattern"] = "移出字符串",
    ["Remove an existing pattern."] = "移出当前字符串",
	["Pattern Options"] = "字符串设置",
	["Inbound"] = "入站",
	["Outbound"] = "出站",
	["Search Pattern"] = "搜索字符串",
	["<string>"] = "<字符串>",
	["Replacement Text"] = "关键字",
	["Block Message"] = "屏蔽信息",
	["Prevent the message from being displayed"] = "屏蔽此类信息显示",
	["Hilight Match Text"] = "高亮匹配文字",
	["Hilight Color"] = "颜色高亮",
	["Secondary Output"] = "其他输出",
	["Send to a secondary output"] = "发送到其他输出。",
	["Play Sound"] = "播放音效",
	["Play a sound when this message is output to the chatframe"] = "当输出消息到聊天窗口时播放音效。",	
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
	["CustomFilters"] = "自訂過濾",
	["Module to support custom filters."] = "支援自訂過濾的模組。",
    ["Add Pattern"] = "增加字串式樣",
    ["Add a pattern to search for."] = "增加搜尋的字串式樣。",
    ["Remove Pattern"] = "移除字串式樣",
    ["Remove an existing pattern."] = "移除現有的字串式樣。",
	["Pattern Options"] = "字串式樣選項",
	["Inbound"] = "入",
	["Outbound"] = "出",
	["Search Pattern"] = "搜尋字串式樣",
	["Search Format String"] = "搜尋格式字串",
	["Supplied pattern is a format string instead of a pattern"] = "提供的式樣是格式字串而不是字串式樣。",	
	["<string>"] = "<字串>",
	["Replacement Text"] = "替換文字",
	["Block Message"] = "封鎖訊息",
	["Prevent the message from being displayed"] = "阻止顯示訊息。",
	["Hilight Match Text"] = "高亮符合的文字",
	["Hilight Color"] = "高亮顏色",
	["Secondary Output"] = "其他輸出",
	["Send to a secondary output"] = "發送到其他輸出。",
	["Play Sound"] = "播放音效",
	["Play a sound when this message is output to the chatframe"] = "當輸出訊息到聊天視窗時播放音效。",
    ["Forward"] = "轉送", 
    ["ForwardMessage"] = "轉送訊息",     
    ["Forward the message to a chat channel."] = "轉送訊息到聊天頻道。",	
    ["Output Channel"] = "輸出頻道",
    ["Channel to send output text to."] = "訊息輸出頻道。",
    ["Channel Data"] = "頻道資料",
    ["Extra data for WHISPER (target) and CHANNEL (channel name or num)"] = "輸出額外資料 (密語對象，頻道名稱/編號)。",
	["Output Message Only"] = "只輸出訊息";
	["Only output the message portion of the chat text, leave out the channel, and playername etc."] = "只輸出訊息部分。"
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
	["CustomFilters"] = "CustomFilter",
	["Module to support custom filters."] = "Ein Modul das selbsterstelle Filter verwaltet.",
    ["Add Pattern"] = "Filter hinzufügen",
    ["Add a pattern to search for."] = "Kurznamen für den Textfilter eingeben nach dem gesucht wird.",
    ["Remove Pattern"] = "Entferne Filter",
    ["Remove an existing pattern."] = "Entfernt ein existierenden Textfilter.",
	["Pattern Options"] = "Textfilter Optionen",
	["Inbound"] = "Eingehend",
	["Outbound"] = "Ausgehend",
	["Search Pattern"] = "Zu suchender Text",
	["<string>"] = "<texteingabefeld>",
	["Replacement Text"] = "Ersatz Text",
	["Block Message"] = "Blockiere Nachricht",
	["Prevent the message from being displayed"] = "Verhindere das diese Nachricht angezeigt wird.",
	["Hilight Match Text"] = "Zutreffenden Text hervorheben",
	["Hilight Color"] = "Farbe hervorheben",
} end)

Prat_CustomFilters = Prat:NewModule(PRAT_MODULE, LIB.NOTIFICATIONS)
local Prat_CustomFilters = Prat_CustomFilters
Prat_CustomFilters.pratModuleName = PRAT_MODULE
Prat_CustomFilters.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

Prat_CustomFilters.moduleName	= L["CustomFilters"] 	-- module name, eg "ExampleMod"
Prat_CustomFilters.moduleDesc	= L["Module to support custom filters."] 	-- module description, eg "An example of a Prat 2 mod"

Prat_CustomFilters.consoleName	= string.lower(Prat_CustomFilters.moduleName)
Prat_CustomFilters.guiName		= Prat_CustomFilters.moduleName

Prat_CustomFilters.moduleOptions = {}

Prat_CustomFilters.defaultDB = {
	on	= false, -- this value tracks if the module should be on or off, 
	             -- an option 'toggle' is automatically created so you can 
	             -- set this value
	inbound = {
	},
	outbound = {
	},
	
	outputchannel = CHAT_MSG_SAY,
	outputchanneldata = "",
}


Prat_CustomFilters.toggleOptions = { sep105_sep = 105 }


local soundslist = {}

local media 
local deformat 

function Prat_CustomFilters:BuildSoundList()
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

function Prat_CustomFilters:SharedMedia_Registered(mediatype, name)
    if mediatype == media.MediaType.SOUND then
        self:BuildSoundList()
    end
end


local eventMap = {
    CHAT_MSG_CHANNEL_LIST,
    CHAT_MSG_SAY,
    CHAT_MSG_GUILD,
    CHAT_MSG_WHISPER_INFORM,
    CHAT_MSG_YELL,
    CHAT_MSG_PARTY,
    CHAT_MSG_OFFICER,
    CHAT_MSG_RAID,
    CHAT_MSG_RAID_LEADER,
    CHAT_MSG_BATTLEGROUND,
    CHAT_MSG_BATTLEGROUND_LEADER,
}


function Prat_CustomFilters:GetModuleOptions()
    media = PRAT_LIBRARY(LIB.MEDIA)
    
	self.moduleOptions = {
		name	= self.moduleName,
		desc	= self.moduleDesc,
		type	= "group",
		args = {
		    inbound = {
		        type = "group",
		        name = L["Inbound"],
		        desc = L["Inbound"],
		        args = {
		        }
		    },
		    outbound = {
		        type = "group",
		        name = L["Outbound"],
		        desc = L["Outbound"],
		        args = {
		        }
		    },
		    
		

		           		    
		}
	}
	
	self:BuildSoundList()
    
    local modeOpts = self.moduleOptions.args
    for k,v in pairs(modeOpts) do 
        self:BuildModeOptions(k, modeOpts)
    end

    self.moduleOptions.args.output =  PRAT_LIBRARY(LIB.NOTIFICATIONS):GetAceOptionsDataTable(self).output 
    self.moduleOptions.args.output.order = 107
    
    self.moduleOptions.args.outputchannel = {
		        type = "text",
		        name = L["Output Channel"],
		        desc = L["Channel to send output text to."],
 		        order = 110,
                validate = eventMap,
                get = function() return self.db.profile.outputchannel end,
                set = function(v) self.db.profile.outputchannel = v end,
		    }
	self.moduleOptions.args.outputchanneldata = {
 		        type = "text",
 		        order = 115,
		        name = L["Channel Data"],
		        desc = L["Extra data for WHISPER (target) and CHANNEL (channel name or num)"],
                get = function() return self.db.profile.outputchanneldata end,
                set = function(v) self.db.profile.outputchanneldata = v end,
                usage = "<string>",
                disabled = function()  return not (self.db.profile.outputchannel == CHAT_MSG_WHISPER_INFORM or self.db.profile.outputchannel == CHAT_MSG_CHANNEL_LIST) end              
		    }
    self.moduleOptions.args.outputmessageonly = {
		        type = "toggle",
		        name = L["Output Message Only"],
		        desc = L["Only output the message portion of the chat text, leave out the channel, and playername etc."],
 		        order = 118,
                get = function() return self.db.profile.outputmessageonly end,
                set = function(v) self.db.profile.outputmessageonly = v end,
		    }
	return self.moduleOptions
end



function Prat_CustomFilters:BuildModeOptions(mode, opts)
    local mode = mode  
    local po = opts[mode].args
    

    self[mode] = {}
    self[mode].validate = {}
    
    po.pathdr = {
        type = "header",
        name = L["Pattern Options"],
        order = 80,
    }

    for k,v in pairs(self.db.profile[mode]) do 
        self:AddPatternOptions(po, k, mode)
    	table.insert(self[mode].validate, k)      
    end

    po.opspc = {
        type = "header",
        order = 94,
    }

    po.addpattern = {
        name = L["Add Pattern"],
        desc = L["Add a pattern to search for."],
        type = "text",
        usage = L["<string>"],
        get = false,
        passValue = mode,
        set = "AddPattern"
    }

    po.removepattern = {
        name = L["Remove Pattern"],
        desc = L["Remove an existing pattern."],
        type = "text",
    	current = "",
        passValue = mode,
    	get = function() return "" end,
    	set = "RemovePattern",
    	validate = self[mode].validate,
        disabled = function(mode) 
            for k,v in pairs(self.db.profile[mode]) do 
                return false             
            end return true end,
    }
    
end
 
function Prat_CustomFilters:AddPatternOptions(o, pattern, mode)
    o[pattern] = o[pattern] or {}
    local po = o[pattern]

    local mode = mode
    local pattern = pattern
    local passval = self.db.profile[mode][pattern]     
    po.type = "group"
    po.name = pattern
    po.desc = pattern
    po.order = 90
    po.passValue = passval
    po.args = {
        searchfor = {
            type = "text",
            name = L["Search Pattern"],
            desc = L["Search Pattern"],
            usage = L["<string>"],
            passValue = passval,
            get = "GetPatternSearch",
            set = "SetPatternSearch"
        },
        searchfordeformat = {
            type = "toggle",
            name = L["Search Format String"],
            desc = L["Supplied pattern is a format string instead of a pattern"],
            usage = L["<string>"],
            passValue = passval,
            get = "GetUseDeformat",
            set = "SetUseDeformat"
            },        
        replacewith = {
            type = "text",
            name = L["Replacement Text"],
            desc = L["Replacement Text"],
            usage = L["<string>"],
            passValue = passval,
            get = "GetPatternReplace",
            set = "SetPatternReplace",
            disabled = "GetDisableReplace",            
        },
        block = {
            type = "toggle",
            passValue = passval,
            name = L["Block Message"],
            desc = L["Prevent the message from being displayed"],
            get = "GetBlockMessage",
            set = "SetBlockMessage"
        },  
        tosink = {
            type = "toggle",
            passValue = passval,
            name = L["Secondary Output"],
            desc = L["Send to a secondary output"],
            get = "GetSinkMessage",
            set = "SetSinkMessage"
        },     
        sound = {
            type = "text",
            passValue = passval,
            name = L["Play Sound"],
            desc = L["Play a sound when this message is output to the chatframe"],
            get = "GetSoundMessage",
            set = "SetSoundMessage",
            validate = soundslist,
        },                      
        hilight = {
            type = "toggle",
            passValue = passval,
            name = L["Hilight Match Text"],
            desc = L["Hilight Match Text"],
            get = "GetPatternHilight",
            set = "SetPatternHilight",
            disabled = "GetBlockMessage",
        },
        hilight_color = {
            type = "color",
            passValue = passval,
            name = L["Hilight Color"],
            desc = L["Hilight Color"],
            get = "GetPatternHilightClr",
            set = "SetPatternHilightClr",
            disabled = "GetBlockMessage",
        },

		
    } 

    po.IsActive = function() return true end

	PRAT_LIBRARY(LIB.NOTIFICATIONS):SetSinkStorage(passval, passval)
	po.args.output =  PRAT_LIBRARY(LIB.NOTIFICATIONS):GetAceOptionsDataTable(passval).output       
end


local function match(text, matchopts, mode)
    Prat_CustomFilters:Debug("match", text, mode)
	if matchopts then Prat:ConsoleDebugDump(matchopts) end
    local matchtype
    if mode == "inbound" then 
        matchtype = "FRAME"
    else
        matchtype = "OUTBOUND"
    end
    
    local textout = text
    
    -- in the deformat case, prat hasnt matched anythign
    -- we have to do it here
    if matchopts.deformat then
		deformat = deformat or PRAT_LIBRARY(LIB.PARSING)
        Prat_CustomFilters:Debug(text, matchopts.searchfor)
        local d = { deformat:Deformat(text, matchopts.searchfor) }
       
        if #d > 0 then        
            Prat_CustomFilters:Debug(unpack(d))
            for i=1,#d do
                if matchopts.hilight then 
                    local hexcolor = CLR:GetHexColor(matchopts.hilight_color)
                    textout = textout:gsub(d[i], Prat:RegisterMatch(CLR:Colorize(hexcolor, d[i]), matchtype))
                end 
            end
        end               
    else        

        if matchopts.replacewith and matchopts.replacewith ~= matchopts.searchfor then
            textout = matchopts.replacewith
        end
        
        if matchopts.hilight then 
            local hexcolor = CLR:GetHexColor(matchopts.hilight_color)
            textout = CLR:Colorize(hexcolor, textout)
        end 
        
        if matchopts.sink10OutputSink then
            if mode == "inbound" then
                Prat.SplitMessage.CF_SINK_OUT = matchopts
            else
                Prat.SplitMessageOut.CF_SINK_OUT = matchopts
            end
        end     

        if matchopts.tosink then
            if mode == "inbound" then
                Prat.SplitMessage.CF_SINK = true
            else
                Prat.SplitMessageOut.CF_SINK = true
            end
        end     
        
        if matchopts.sound then
            if mode == "inbound" then
                Prat.SplitMessage.CF_SOUND =  matchopts.sound
            else
                Prat.SplitMessageOut.CF_SOUND =  matchopts.sound
            end            
        end   

        if matchopts.block then 
            if mode == "inbound" then
                Prat.SplitMessage.DONOTPROCESS = true
            else
                Prat.SplitMessageOut.MESSAGE = ""
            end
        end

        Prat_CustomFilters:Debug("matchresult", textout)
        textout =  Prat:RegisterMatch(textout, matchtype)        
    end
    
    return textout
end

Prat_CustomFilters.modulePatterns = {}

function Prat_CustomFilters:RegisterPattern(matchopts, mode)
    local mode = mode
    local matchopts = matchopts
    if mode == "inbound" then 
        matchtype = "FRAME"
    else
        matchtype = "OUTBOUND"
    end    
    local patterninfo = { pattern = matchopts.searchfor,
                        matchopts = matchopts,
                      matchfunc = 
                        function(text, ...)
                            return match(text, matchopts, mode)
                        end,
                      type = matchtype,
                      deformat = matchopts.deformat }                                             

    Prat:RegisterPattern(patterninfo, self.name)
   
    table.insert(self.modulePatterns, patterninfo)
end

function Prat_CustomFilters:UnregisterPattern(matchopts)
    local patterninfo 
    for _,v in pairs (self.modulePatterns) do
        if v.matchopts == matchopts then 
            patterninfo = v
        end
    end
    
    if patterninfo == nil then return end

    if patterninfo.idx then 
        Prat:UnregisterPattern(patterninfo.idx)
    end
    
    local idx
    for k,v in pairs(self.modulePatterns) do
        if v == patterninfo then
            idx = k
        end
    end
    
    table.remove(self.modulePatterns, idx)
end

function Prat_CustomFilters:UpdatePattern(matchopts)
    local patterninfo 
    for _,v in pairs (self.modulePatterns) do
        if v.matchopts == matchopts then 
            patterninfo = v
        end
    end
    
    self:Debug("No Match")
    if patterninfo == nil then return end
  
    local mode 
    local matchopts = matchopts
    if patterninfo.type == "FRAME" then 
        mode = "inbound"
    else
        mode = "outbound"
    end    
    
    patterninfo.pattern = matchopts.searchfor
    patterninfo.deformat = matchopts.deformat
    patterninfo.matchfunc = 
        function(text, ...)
            return match(text, matchopts, mode)
        end
        
    Prat:ConsoleDebugDump(patterninfo)
end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

-- things to do when the module is enabled
function Prat_CustomFilters:OnModuleEnable(first)
	if first then 
    	self:RegisterSink(
    	    L["Forward"], 
    	    L["ForwardMessage"], 
    	    L["Forward the message to a chat channel."],
    	    "Forward"
    	)

        media = PRAT_LIBRARY(LIB.MEDIA)

		self:BuildSoundList()
    end

    local modeOpts = self.moduleOptions.args
    local mode
    for mode,_ in pairs(modeOpts) do 
        if type(self.db.profile[mode]) == "table" then 
            local patopts
            for _,patopts in pairs(self.db.profile[mode]) do
                self:RegisterPattern(patopts, mode) 
            end
        end 
    end
    
    if media.RegisterCallback then
		media.RegisterCallback(self, "LibSharedMedia_Registered", "SharedMedia_Registered")
	else
		self[LIB.REGISTEREVENT](self, "SharedMedia_Registered")
    end

    self[LIB.REGISTEREVENT](self, Prat.Events.POST_ADDMESSAGE)
end


function Prat_CustomFilters:OnModuleDisable()
	-- unregister events
	self:UnregisterAllEvents()

    if media.UnregisterCallback then
		media.UnregisterCallback(self, "LibSharedMedia_Registered")
    end
end

function Prat_CustomFilters:Prat_PostAddMessage(message, frame, event, text, r, g, b, id)
    local uid = Prat:GetEventID()
    if uid and 
       uid == self.lastevent and 
       self.lasteventtype == event then 
       return 
    end

    self.lasteventtype = event
    self.lastevent = uid	

    self:Debug("Prat_PostAddMessage", text, message.CF_SINK, message.CF_SINK_OUT, message.CF_SOUND)

	if message.CF_SINK or message.CF_SINK_OUT then	
		if self.db.profile.outputmessageonly then
		    self.Pour(message.CF_SINK_OUT or self, message.MESSAGE, r, g, b)
		else
		    self.Pour(message.CF_SINK_OUT or self, text, r, g, b)
		end
	end
	
	if message.CF_SOUND then
	    Prat:PlaySound(message.CF_SOUND)
	end
end

-- things to do when the module is disabled
function Prat_CustomFilters:GetModulePatterns()
end


--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--
function Prat_CustomFilters:GetPatternSearch(p)
    self:Debug(p)
    return p.searchfor
end
function Prat_CustomFilters:SetPatternSearch(p, v)
    self:Debug(p, v)
    p.searchfor = v
    
    self:UpdatePattern(p)
end
function Prat_CustomFilters:GetPatternReplace(p)
    return p.replacewith
end
function Prat_CustomFilters:SetPatternReplace(p, v)
    p.replacewith = v
    
    self:UpdatePattern(p)
end
function Prat_CustomFilters:GetPatternHilight(p)
    return p.hilight
end
function Prat_CustomFilters:SetPatternHilight(p, v)
    p.hilight = v
    
    self:UpdatePattern(p)
end

function Prat_CustomFilters:GetDisableReplace(p)
    return p.block or p.tosink
end

function Prat_CustomFilters:GetBlockMessage(p)
    return p.block
end

function Prat_CustomFilters:SetBlockMessage(p, v)
    p.block = v
end

function Prat_CustomFilters:GetSinkMessage(p)
    return p.tosink
end
function Prat_CustomFilters:SetSinkMessage(p, v)
    p.tosink = v
end

function Prat_CustomFilters:GetSoundMessage(p)
    return p.sound
end
function Prat_CustomFilters:SetSoundMessage(p, v)
    p.sound = v
    
    Prat:PlaySound(v)
end


function Prat_CustomFilters:GetUseDeformat(p)
    return p.deformat
end
function Prat_CustomFilters:SetUseDeformat(p, v)
    p.deformat = v
    self:UpdatePattern(p)    
end


local white_clr = {r=1.0, b=1.0, g=1.0}
function Prat_CustomFilters:GetPatternHilightClr(p)
    local h = p.hilight_color or white_clr
    return h.r or 1.0, h.g or 1.0, h.b or 1.0
end
function Prat_CustomFilters:SetPatternHilightClr(p, r,g,b)
    p.hilight_color = p.hilight_color or {}
    local h = p.hilight_color
    h.r, h.g, h.b = r, g, b
    
    self:UpdatePattern(p)
end



function Prat_CustomFilters:AddPattern(mode, pattern)
    self:Debug("Add", mode, pattern)
    local p = self.db.profile[mode]
    
	for k, v in pairs(p) do
		if v.name == pattern then
			return
		end
	end

    local pattern = pattern
    p[pattern] = { searchfor = pattern, replacewith = pattern }

	
	self[mode].validate = self[mode].validate or {}
	local v = self[mode].validate
	table.insert(v, pattern)
	
	local o = self.moduleOptions.args[mode].args
    self:AddPatternOptions(o, pattern, mode)
    
    self:RegisterPattern(p[pattern], mode)
end

function Prat_CustomFilters:RemovePattern(mode, pattern)
    self:Debug("Remove", mode, pattern)
    local p = self.db.profile[mode]
   
    self:UnregisterPattern(p[pattern])
    p[pattern] = nil    
	local v = self[mode].validate
	local idx
	
	for k, p  in pairs(v) do if pattern == p then idx = k end end
	
	table.remove(v, idx)
	
	self.moduleOptions.args[mode].args[pattern] = nil
end    
--msg, chatType, language, channel)
function Prat_CustomFilters:Forward(source, text, r,g,b, ...)
    local cleantext = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h", ""):gsub("|h", "")
    
    self:Debug("Forward", tostring(source), text, cleantext, self.db.profile.outputchannel, self.db.profile.outputchanneldata)
    
    if self.db.profile.outputchannel == CHAT_MSG_WHISPER_INFORM then
        SendChatMessage(cleantext, "WHISPER",  GetDefaultLanguage("player"), self.db.profile.outputchanneldata)
    elseif self.db.profile.outputchannel == CHAT_MSG_CHANNEL_LIST then 
        SendChatMessage(cleantext, "CHANNEL",  GetDefaultLanguage("player"), GetChannelName(self.db.profile.outputchanneldata))
    else
        local chatType = strsub(self.db.profile.outputchannel, 10) 
        SendChatMessage(cleantext, chatType, GetDefaultLanguage("player"))
    end
end
