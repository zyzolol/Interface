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
Name: PratChannelNames
Revision: $Revision: 79185 $
Author(s): Curney (asml8ed@gmail.com)
           Krtek (krtek4@gmail.com)
           Sylvanaar (sylvanaar@mindspring.com)
Inspired by: idChat2_ChannelNames by Industrial
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#ChannelNames
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: Module for Prat that options for replacing channel names with abbreviations.
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratChannelNames")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["ChannelNames"] = true,
    ["Channel name abbreviation options."] = true,
    ["Replace"] = true,
    ["Toggle replacing this channel."] = true,
    ["Blank"] = true,
    ["Dont display the channel/chat type name"] = true,
    ["Set"] = true,
    ["Channel %d"] = true,
    ["%s settings."] = true,
    ["Use a custom replacement for the chat %s text."] = true,
    
    ["Add Channel Abbreviation"] = true,
    ["Adds an abbreviated channel name."] = true,
    ["Remove Channel Abbreviation"] = true,
    ["Removes an an abbreviated channel name."] = true,    
    ["Clear Channel Abbreviation"] = true,
    ["Clears an abbreviated channel name."] = true,

    ["space_name"] = "Show Space",
    ["space_desc"] = "Toggle adding space after channel replacement.",
    ["colon_name"] = "Show Colon",
    ["colon_desc"] = "Toggle adding colon after channel replacement.",

    ["chanlink_name"] = "Create Channel Link",
    ["chanlink_desc"] = "Make the channel a clickable link which opens chat to that channel.",
	
    ["<string>"] = true,
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["ChannelNames"] = "Kanal Name",
    ["Channel name abbreviation options."] = "Kanal Namen Abk\195\188rzungsoptionen.",
    ["Replace"] = "Ersetze",
    ["Toggle replacing this channel."] = "Schaltet das ersetzen dieses Kannals ein.",
    ["Blank"] = "Aus",
    ["Dont display the channel/chat type name"] = "Schaltet diesen Kanal aus.",
    ["Set"] = "Einstellen",
    ["Channel %d"] = "Kanal %d",
    ["%s settings."] = "%s Einstellungen.",
    ["Use a custom replacement for the chat %s text."] = "Benutze eigenen Namen f\195\188r den Chat %s Text.",
    ["space_name"] = "Zeige Leerstelle",
    ["space_desc"] = "Aktiviere eine zus\195\164tzliche Leerstelle nach dem eigenen Kanalnamen.",
    ["colon_name"] = "Zeige Doppelpunkt",
    ["colon_desc"] = "Aktiviere das hinzuf\195\188gen eines Doppelpunkts nach dem eigenen Kanalnamen.",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["ChannelNames"] = "Nombres de Canal",
    ["Channel name abbreviation options."] = "Opciones de abreviaci\195\179n de los nombres de canal",
    ["Replace"] = "Reemplazar",
    ["Toggle replacing this channel."] = "Determina si se reemplaza este canal",
    ["Blank"] = "Desactivar",
    ["Dont display the channel/chat type name"] = "Desactivar este canal",
    ["Set"] = "Establecer",
    ["Channel %d"] = "Canal %d",
    ["%s settings."] = "Ajustes de %s",
    ["Use a custom replacement for the chat %s text."] = "Usa un recambio personalizado para el texto del chat %s",
    ["space_name"] = "Mostrar Espacio",
    ["space_desc"] = "Determina si se a\195\177ade un espacio despu\195\169s del recambio de canal.",
    ["colon_name"] = "Mostrar los Dos Puntos",
    ["colon_desc"] = "Determina si se a\195\177aden los dos puntos despu\195\169s del recambio de canal.",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["ChannelNames"] = "채널명",
    ["Channel name abbreviation options."] = "채널명 생략 설정입니다.",
    ["Replace"] = "변경",
    ["Toggle replacing this channel."] = "해당 채널을 변경합니다.",
    ["Blank"] = "공백",
    ["Dont display the channel/chat type name"] = "채널명/대화 종류명을 표시하지 않습니다.",
    ["Set"] = "설정",
    ["Channel %d"] = "채널 %d",
    ["%s settings."] = "%s 설정입니다.",
    ["Use a custom replacement for the chat %s text."] = "%s 대화에 사용자 정의로 변경합니다.",
    
    ["Add Channel Abbreviation"] = "채널 단축 추가",
    ["Adds an abbreviated channel name."] = "단축된 채널명을 추가합니다.",
    ["Remove Channel Abbreviation"] = "채널 단축 제거",
    ["Removes an an abbreviated channel name."] = "단축된 채널명을 제거합니다.",    
    ["Clear Channel Abbreviation"] = "채널 단축 초기화",
    ["Clears an abbreviated channel name."] = "단축된 채널명을 초기화합니다.",

    ["space_name"] = "간격 표시",
    ["space_desc"] = "채널 변경 후 간격을 추가합니다.",
    ["colon_name"] = "콜론 표시",
    ["colon_desc"] = "채널 변경 후 콜론을 추가합니다.",

    ["chanlink_name"] = "채널 링크 생성",
    ["chanlink_desc"] = "해당 채널에 대화창을 여는 클릭 가능한 채널 링크를 생성합니다.",
	
    ["<string>"] = "<문자열>",
} end)

--Chinese Translation: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
local PratCNlocal = GetLocale()
L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["ChannelNames"] = "频道名称",
    ["Channel name abbreviation options."] = "频道名称缩写选项。",
    ["Replace"] = "替换",
    ["Toggle replacing this channel."] = "替换频道。",
    ["Blank"] = "关闭",
    ["Dont display the channel/chat type name"] = "关闭此频道。",
    ["Set"] = "设置",
    ["Channel %d"] = "频道 %d",
    ["%s settings."] = "%s 设置。",
    ["Use a custom replacement for the chat %s text."] = "自定义替换此聊天 %s 文本。",

    ["Add Channel Abbreviation"] = "增加频道缩写",
    ["Adds an abbreviated channel name."] = "增加频道名称缩写。",
    ["Remove Channel Abbreviation"] = "移除频道缩写",
    ["Removes an an abbreviated channel name."] = "移除频道缩写名称。",    
    ["Clear Channel Abbreviation"] = "清除频道缩写", 
    ["Clears an abbreviated channel name."] = "清除频道缩写名称。", 
    
    ["space_name"] = "显示间隔",
    ["space_desc"] = "切换频道替换后增加间隔空间。",
    ["colon_name"] = "显示冒号",
    ["colon_desc"] = "切换频道替换后增加冒号。",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["ChannelNames"] = "頻道名稱",
    ["Channel name abbreviation options."] = "頻道名稱縮寫選項。",
    ["Replace"] = "替換",
    ["Toggle replacing this channel."] = "替換頻道名稱。",
    ["Blank"] = "空白",
    ["Dont display the channel/chat type name"] = "不顯示頻道名稱。",
-- no use anymore    ["Set"] = true,
    ["Channel %d"] = "頻道%d",
    ["%s settings."] = "%s設定。",
    ["Use a custom replacement for the chat %s text."] = "自定義替換聊天頻道 (%s) 名稱。",
    
    ["Add Channel Abbreviation"] = "增加頻道縮寫",
    ["Adds an abbreviated channel name."] = "增加頻道名稱縮寫。",
    ["Remove Channel Abbreviation"] = "移除頻道縮寫",
    ["Removes an an abbreviated channel name."] = "移除頻道名稱縮寫。",    
-- no use anymore    ["Clear Channel Abbreviation"] = true,
-- no use anymore    ["Clears an abbreviated channel name."] = true,

    ["space_name"] = "顯示空白間隔",
    ["space_desc"] = "切換頻道替換後增加空白間隔空間。",
    ["colon_name"] = "顯示冒號",
    ["colon_desc"] = "切換頻道替換後增加冒號。",

    ["chanlink_name"] = "創建頻道連結",
    ["chanlink_desc"] = "使用戶可點選頻道名稱直接在此頻道上聊天。",
	
    ["<string>"] = "<字串>",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["ChannelNames"] = "Noms des canaux",
    ["Channel name abbreviation options."] = "Options pour abbr\195\169ger les noms des canaux.",
    ["Replace"] = "Remplacer",
    ["Toggle replacing this channel."] = "Active/d\195\169sactive le remplacement pour ce canal.",
    ["Blank"] = "D\195\169sactiv\195\169",
    ["Dont display the channel/chat type name"] = "D\195\169sactiver ce canal.",
    ["Set"] = "Set",
    ["Channel %d"] = "Canal %d",
    ["%s settings."] = "R\195\169glages %s",
    ["Use a custom replacement for the chat %s text."] = "Utiliser un remplacement personnalis\195\169 pour le texte du chat %s.",
    ["space_name"] = "Afficher une espace",
    ["space_desc"] = "Ajoute ou non une espace après le nom remplac\195\169.",
    ["colon_name"] = "Afficher \":\"",
    ["colon_desc"] = "Ajoute ou non \":\" après le nom remplac\195\169.",
} end)

-- order to show channels
local orderMap = {
        "say",
        "whisper",
        "whisperincome",
        "yell",
        "party",
        "guild",
        "officer",
        "raid",
        "raidleader",
        "raidwarning",
        "battleground",
        "battlegroundleader",
}

-- Look Up Our Settings Key event..message.CHANNUM
local eventMap = {
    CHAT_MSG_CHANNEL1 = "channel1",
    CHAT_MSG_CHANNEL2 = "channel2",
    CHAT_MSG_CHANNEL3 = "channel3",
    CHAT_MSG_CHANNEL4 = "channel4",
    CHAT_MSG_CHANNEL5 = "channel5",
    CHAT_MSG_CHANNEL6 = "channel6",
    CHAT_MSG_CHANNEL7 = "channel7",
    CHAT_MSG_CHANNEL8 = "channel8",
    CHAT_MSG_CHANNEL9 = "channel9",
    CHAT_MSG_CHANNEL10 = "channel10",
    CHAT_MSG_SAY = "say",
    CHAT_MSG_GUILD = "guild",
    CHAT_MSG_WHISPER = "whisperincome",
    CHAT_MSG_WHISPER_INFORM = "whisper",
    CHAT_MSG_YELL = "yell",
    CHAT_MSG_PARTY = "party",
    CHAT_MSG_OFFICER = "officer",
    CHAT_MSG_RAID = "raid",
    CHAT_MSG_RAID_LEADER = "raidleader",
    CHAT_MSG_RAID_WARNING = "raidwarning",
    CHAT_MSG_BATTLEGROUND = "battleground",
    CHAT_MSG_BATTLEGROUND_LEADER = "battlegroundleader",
}



-- create prat module
Prat_ChannelNames = Prat:NewModule(PRAT_MODULE)
local Prat_ChannelNames = Prat_ChannelNames
Prat_ChannelNames.pratModuleName = PRAT_MODULE
Prat_ChannelNames.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_ChannelNames.moduleName = L["ChannelNames"]
Prat_ChannelNames.moduleDesc = L["Channel name abbreviation options."]
Prat_ChannelNames.consoleName = "channames"
Prat_ChannelNames.guiName = L["ChannelNames"]


-- Set this to true to use Prat Event Support
Prat_ChannelNames.supportsPratEvents = true

-- define the default db values
Prat_ChannelNames.defaultDB = {
    on = true,
    space = true,
    colon = true,
	chanlink = true,
    replace = {
        say = true,
        whisper = true,
        whisperincome = true,
        yell = true,
        party = true,
        guild = true,
        officer = true,
        raid = true,
        raidleader = true,
        raidwarning = true,
        battleground = true,
        battlegroundleader = true,
        channel1 = true,
        channel2 = true,
        channel3 = true,
        channel4 = true,
        channel5 = true,
        channel6 = true,
        channel7 = true,
        channel8 = true,
        channel9 = true,
        channel10 = true,
    },
    chanSave = {},
    shortnames = 
		-- zhCN
		PratCNlocal == "zhCN" and {
        say = "[说]",
        whisper = "[密]",
        whisperincome = "[收]",
        yell = "[喊]",
        party = "[队]",
        guild = "[会]",
        officer = "[管]",
        raid = "[团]",
        raidleader = "[酱]",
        raidwarning = "[警]",
        battleground = "[战]",
        battlegroundleader = "[蟀]",
        channel1 = "[1]",
        channel2 = "[2]",
        channel3 = "[3]",
        channel4 = "[4]",
        channel5 = "[5]",
        channel6 = "[6]",
        channel7 = "[7]",
        channel8 = "[8]",
        channel9 = "[9]",
        channel10 = "[10]",
    }
		--zhTW
		or PratCNlocal == "zhTW" and {
        say = "[說]",
        whisper = "[密]",
        whisperincome = "[聽]",
        yell = "[喊]",
        party = "[隊]",
        guild = "[會]",
        officer = "[官]",
        raid = "[團]",
        raidleader = "[團長]",
        raidwarning = "[警]",
        battleground = "[戰]",
        battlegroundleader = "[戰領]",
        channel1 = "[1]",
        channel2 = "[2]",
        channel3 = "[3]",
        channel4 = "[4]",
        channel5 = "[5]",
        channel6 = "[6]",
        channel7 = "[7]",
        channel8 = "[8]",
        channel9 = "[9]",
        channel10 = "[10]",
    }
		--koKR
		or PratCNlocal == "koKR" and {
        say = "[대화]",
        whisper = "[귓말]",
        whisperincome = "[받은귓말]",
        yell = "[외침]",
        party = "[파티]",
        guild = "[길드]",
        officer = "[오피서]",
        raid = "[공대]",
        raidleader = "[공대장]",
        raidwarning = "[공대경보]",
        battleground = "[전장]",
        battlegroundleader = "[전투대장]",
        channel1 = "[1]",
        channel2 = "[2]",
        channel3 = "[3]",
        channel4 = "[4]",
        channel5 = "[5]",
        channel6 = "[6]",
        channel7 = "[7]",
        channel8 = "[8]",
        channel9 = "[9]",
        channel10 = "[10]",
    }
		--Other
		or {
        say = "[S]",
        whisper = "[W To]",
        whisperincome = "[W From]",
        yell = "[Y]",
        party = "[P]",
        guild = "[G]",
        officer = "[O]",
        raid = "[R]",
        raidleader = "[RL]",
        raidwarning = "[RW]",
        battleground = "[B]",
        battlegroundleader = "[BL]",
        channel1 = "[1]",
        channel2 = "[2]",
        channel3 = "[3]",
        channel4 = "[4]",
        channel5 = "[5]",
        channel6 = "[6]",
        channel7 = "[7]",
        channel8 = "[8]",
        channel9 = "[9]",
        channel10 = "[10]",
    },
    
    nickname = {}
}

-- build the options menu using prat templates
Prat_ChannelNames.toggleOptions = { optsep227_sep = 227, optsep_sep = 229, space = 230, colon = 240, sep241_sep = 241, chanlink = 242 }
-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_ChannelNames.moduleOptions = {}

-- add module options not covered by templates
function Prat_ChannelNames:GetModuleOptions()
    self.moduleOptions = {
        name = L["ChannelNames"],
        desc = L["Channel name abbreviation options."],
        type = "group",
        args = {
        
        

        }
    }
    self:BuildChannelOptions()
    return self.moduleOptions
end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

function Prat_ChannelNames:OnModuleEnable()
    self:BuildChannelOptions()
    self[LIB.REGISTEREVENT](self, "UPDATE_CHAT_COLOR");
    self[LIB.REGISTEREVENT](self, "Prat_PreAddMessage")

    Prat:RegisterLinkType(  { linkid="channel", linkfunc=Prat_ChannelNames.Chan_Link, handler=Prat_ChannelNames }, Prat_ChannelNames.moduleName)    
    Prat:RegisterLinkType(  { linkid="chattyp", linkfunc=Prat_ChannelNames.Chat_Link, handler=Prat_ChannelNames }, Prat_ChannelNames.moduleName)    


--  Possible fix for channel messages not getting formatted
--	Prat:EnableProcessingForEvent("CHAT_MSG_CHANNEL_NOTICE")
--	Prat:EnableProcessingForEvent("CHAT_MSG_CHANNEL_NOTICE_USER")
--	Prat:EnableProcessingForEvent("CHAT_MSG_CHANNEL_LEAVE")
--	Prat:EnableProcessingForEvent("CHAT_MSG_CHANNEL_JOIN")
end

-- things to do when the module is disabled
function Prat_ChannelNames:OnModuleDisable()
    -- unregister events
    self:UnregisterAllEvents()
end

--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--

-- rebuild menu if chat colors change
function Prat_ChannelNames:UPDATE_CHAT_COLOR()
     self:ScheduleEvent(function() Prat_ChannelNames:BuildChannelOptions() end , 1)
end

function Prat_ChannelNames:Chan_Link(link, text, button, ...)
	self:Debug("Chan_Link", link, text, button, ...)
    if self.db.profile.chanlink then
		local chan = strsub(link, 9)

		local cf = SELECTED_CHAT_FRAME
		local editBox = cf.editBox

		editBox:SetAttribute("channelTarget", chan);
		editBox:SetAttribute("chatType", "CHANNEL");

		if ( not cf.editBox:IsShown() ) then
			ChatFrame_OpenChat("", cf);
		else
			ChatEdit_UpdateHeader(editBox);
		end

		return false
	end

	return true
end
function Prat_ChannelNames:Chat_Link(link, text, button, ...)
	self:Debug("Chat_Link", link, text, button, ...)
    if self.db.profile.chanlink then
		local ctype = strsub(link, 9)

		local cf = SELECTED_CHAT_FRAME
		local editBox = cf.editBox

		editBox:SetAttribute("chatType", ctype);

		if ( not cf.editBox:IsShown() ) then
			ChatFrame_OpenChat("", cf);
		else
			ChatEdit_UpdateHeader(editBox);
		end

		return false
	end

	return true
end


function Prat_ChannelNames:AddNickname(name, shortname)
    self.db.profile.nickname[name] = shortname
end

function Prat_ChannelNames:RemoveNickname(name)
    if self.db.profile.nickname[name] then
        self.db.profile.nickname[name] = nil
    end
end


function Prat_ChannelNames:MakeChan_Link(message)
	local prof = self.db.profile
	local cnum = message.ORG.CHANNELNUM

    if prof.chanlink  then
		message.CHANLINK = nil
		
		if type(cnum) == "number" or tonumber(cnum) then 
			message.CHANLINK = "channel:"..tostring(cnum)
		elseif not message.CHATTYPE:find("WHISPER") then 
			message.CHANLINK = "chattyp:"..message.CHATTYPE
		end

		if message.CHANLINK then 
			message.nN = "|H"
			message.NN = "|h"
			message.Nn = "|h"
		end
	end
end

-- replace text using prat event implementation
function Prat_ChannelNames:Prat_PreAddMessage(message, frame, event)
    if message.TYPEPREFIX and message.TYPEPOSTFIX then
        local cfg = eventMap[event..(message.CHANNELNUM or "")]
        if self.db.profile.replace[cfg] then
            message.cC , message.CHANNELNUM, message.CC, message.CHANNEL, message.Cc = "","","","",""
--            local space = self.db.profile.space and " " or ""
            local space = self.db.profile.space and self.db.profile.shortnames[cfg] and self.db.profile.shortnames[cfg] ~= "" and " " or ""
            local colon = self.db.profile.colon and ":" or ""
            message.TYPEPREFIX = self.db.profile.shortnames[cfg] or ""

			if message.TYPEPREFIX:len() > 0 then 
				self:MakeChan_Link(message)
			end

            message.TYPEPREFIX = message.TYPEPREFIX..space
            
            if strlen(message.PLAYERLINK) > 0 or strlen(message.TYPEPREFIX) > 0  then 
                message.TYPEPOSTFIX = colon.."\32"
            else
                message.TYPEPOSTFIX = ""
            end
        elseif self.db.profile.nickname[message.CHANNEL] then
            message.CHANNEL = self.db.profile.nickname[message.CHANNEL]

			self:MakeChan_Link(message, event)			
        end
    end
end

--[[------------------------------------------------
    Menu Builder Functions
------------------------------------------------]]--

function Prat_ChannelNames:BuildChannelOptions()
    for _, v in ipairs(orderMap) do
        self:CreateTypeOption(self.moduleOptions.args, v)
    end
    for i=1,10 do
        self:CreateChannelOption(self.moduleOptions.args, "channel"..i, i)
    end
    
    for _, v in ipairs(DEFAULT_CHAT_FRAME.channelList) do
        self:CreateChanNickOption(self.moduleOptions.args, v)
    end
    
end
function Prat_ChannelNames:CreateChanNickOption(args, keyname)
    local text = keyname
    local name = keyname
    args[name] = {
        name = text,
        desc = string.format(L["%s settings."], text),
        type = "group",
        order = 228,
        args = {
            addnick = {
                name = L["Add Channel Abbreviation"],
                desc = L["Adds an abbreviated channel name."],
                type = "text",
                order = 140,
                usage = "<string>",
                get = false,
				set = function(name) local fullname = text self:AddNickname(fullname, name) end
            },
            removenick = {
                name = L["Remove Channel Abbreviation"],
                desc = L["Removes an an abbreviated channel name."],
                type = "execute",
                order = 150,
				func = function() local fullname = text self:RemoveNickname(fullname) end,
                disabled = function() local fullname = text return self.db.profile.nickname[fullname] == nil end,
            },  
        }
    }        
        

end

function Prat_ChannelNames:CreateTypeOption(args, keyname)
    local name = keyname
    local text
    for k,v in pairs(eventMap) do
        if keyname == v then
            text = k
        end
    end
    local type = text

    text = CLR:ChatType(TEXT(getglobal(text)), type)

    args[name] = args[name] or {
      --  name = text,
     --   desc = string.format(L["%s settings."], text),
        type = "group",
        args = {
            set = {
              --  name = text,
              --  desc = string.format(L["Use a custom replacement for the chat %s text."], text),
                order = 1,
                type = "text",
                usage = L["<string>"],
                get = function() return self.db.profile.shortnames[name] end,
                set = function(v) self.db.profile.shortnames[name] = v end
            },
            optsep = {
                order = 2,
                type = 'header',
            },
            replace = {
                name = L["Replace"],
                desc = L["Toggle replacing this channel."],
                type = "toggle",
                order = 3,
                get = function() return self.db.profile.replace[name]  end,
                set = function(v) self.db.profile.replace[name]  = v end,
            },
            off = {
                name = L["Blank"],
                desc = L["Dont display the channel/chat type name"],
                type = "execute",
                order = 4,
                func = function() self.db.profile.shortnames[name]  = ""  end
            }
        }
    }

	local a = args[name]
	a.desc = string.format(L["%s settings."], text)
	a.name = text
	
	local a = a.args.set
	a.desc = string.format(L["Use a custom replacement for the chat %s text."], text)
	a.name = text
end

function Prat_ChannelNames:CreateChannelOption(args, keyname, keynum)
    local name = keyname
    local num = keynum
    local o = 100+keynum
    local text
    for k,v in pairs(eventMap) do
        if keyname == v then
            text = k
        end
    end
    local type = text
    text = CLR:ChatType(L["Channel %d"], type)
    args[name] = args[name] or {
    --    name = string.format(text, num),
     --   desc = string.format(L["%s settings."],string.format(L["Channel %d"], num)),
        type = "group",
        order = o,
        args = {
            set = {
                --name = string.format(text, num),
                --desc = string.format(L["Use a custom replacement for the chat %s text."], string.format(L["Channel %d"], num)),
                type = "text",
                usage = L["<string>"],
                order = 1,
                get = function() return self.db.profile.shortnames[name] end,
                set = function(v) self.db.profile.shortnames[name] = v end
            },
            optsep = {
                order = 2,
                type = 'header',
            },
            replace = {
                name = L["Replace"],
                desc = L["Toggle replacing this channel."],
                type = "toggle",
                order = 3,
                get = function() return self.db.profile.replace[name]  end,
                set = function(v) self.db.profile.replace[name]  = v end,
            },
            off = {
                name = L["Blank"],
                desc = L["Dont display the channel/chat type name"],
                type = "execute",
                order = 4,
                func = function() self.db.profile.shortnames[name]  = ""  end
            }
        }
    }


	local a = args[name]
	a.desc = string.format(L["%s settings."],string.format(L["Channel %d"], num))
	a.name = string.format(text, num)

	local a = a.args.set
	a.desc = string.format(L["Use a custom replacement for the chat %s text."], string.format(L["Channel %d"], num))
	a.name = string.format(text, num)
end

function CLR:ChatType(text, type) return self:Colorize(Prat_ChannelNames:GetChatCLR(type), text) end

function Prat_ChannelNames:GetChatCLR(name)
    local type = strsub(name, 10);
    self:Debug(type)
    local info = ChatTypeInfo[type];
    if not info then
        return CLR.COLOR_NONE
    end
    return CLR:GetHexColor(info)
end




