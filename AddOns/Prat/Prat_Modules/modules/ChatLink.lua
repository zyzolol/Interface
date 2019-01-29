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
Name: PratChatLink
Revision: $Revision: 79185 $
Author(s): Krtek (krtek4@gmail.com)
           Sylvanaar (sylvanaar@mindspring.com)
Inspired by: Cirk's Chatmanager by Cirk
             ChatLink by Yrys
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#ChatLink
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: Module for Prat that shows item links in chat channels.
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local Prat = Prat

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratChatLink")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["ChannelLinks"] = true,
    ["Chat channel item link options."] = true,
    ["cm_name"] = "ChatManager",
    ["cm_desc"] = "Toggle sending items in Cirk\" ChatManager format.",
    ["clink_name"] = "ChatLink",
    ["clink_desc"] = "Toggle sending items in ChatLink format.",
    ["gem_name"] = "GEM Compatibility",
    ["gem_desc"] = "Enable GEM Compatiblity Mode",
    ["Trade"] = true

} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["ChannelLinks"] = "ChatLink",
    ["Chat channel item link options."] = "Chat Kanal Item Link Optionen.",
    ["cm_name"] = "Chat Manager",
    ["cm_desc"] = "Aktiviere das Senden von Items im Cirk\" ChatManager Format.",
    ["clink_name"] = "Chat Link",
    ["clink_desc"] = "Aktiviere das Senden von items im ChatLink Format.",
    ["gem_name"] = "GEM Kompatibilität",
    ["gem_desc"] = "Aktiviere den GEM Kompatibilitätsmodus",
    ["Trade"] = "Handel"
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["ChannelLinks"] = "Enlace de Chat",
    ["Chat channel item link options."] = "Opciones de enlace de objeto en un canal de chat",
    ["cm_name"] = "ChatManager",
    ["cm_desc"] = "Determina si se envian los objetos en el formato Cirk\" ChatManager",
    ["clink_name"] = "Enlace de Chat",
    ["clink_desc"] = "Activa y desactiva los objetos en formato Enlace de Chat.",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["ChannelLinks"] = "채널링크",
    ["Chat channel item link options."] = "대화 채널 아이템 링크 설정입니다.",
    ["cm_name"] = "ChatManager",
    ["cm_desc"] = "Cirk\" Chatmanager 형식으로 아이템을 전송합니다.",
    ["clink_name"] = "ChatLink",
    ["clink_desc"] = "ChatLink 형식으로 아이템을 전송합니다.",
    ["gem_name"] = "GEM 호환",
    ["gem_desc"] = "GEM 호환 모드를 사용합니다.",
    ["Trade"] = "거래"
} end)
--Chinese Translation: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["ChannelLinks"] = "聊天链接",
    ["Chat channel item link options."] = "聊天频道物品链接选项。",
    ["cm_name"] = "聊天管理",
    ["cm_desc"] = "切换以 Cirk\" 聊天管理模式发送物品。",
    ["clink_name"] = "聊天链接",
    ["clink_desc"] = "切换聊天链接物品发送格式。",
    ["Trade"] = "交易"
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["ChannelLinks"] = "聊天連結",
    ["Chat channel item link options."] = "聊天頻道物品連結選項。",
    ["cm_name"] = "ChatManager",
    ["cm_desc"] = "切換為 Cirk's ChatManager 格式。",
    ["clink_name"] = "ChatLink",
    ["clink_desc"] = "切換為 ChatLink 格式。",
    ["gem_name"] = "兼容 GEM",
    ["gem_desc"] = "啟用 GEM 兼容模式。",
    ["Trade"] = "交易"

} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["ChannelLinks"] = "Liens",
    ["Chat channel item link options."] = "Options des liens d'objets dans les chats.",
    ["cm_name"] = "ChatManager",
    ["cm_desc"] = "Active l'envoi des liens d'objet au format de Cirk\" ChatManager.",
    ["clink_name"] = "ChatLink",
    ["clink_desc"] = "Active l'envoi des liens d'objets au format ChatLink.",
} end)



-- create prat module
Prat_ChatLink = Prat:NewModule(PRAT_MODULE, LIB.HOOKS)
local Prat_ChatLink = Prat_ChatLink
Prat_ChatLink.pratModuleName = PRAT_MODULE
Prat_ChatLink.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_ChatLink.moduleName = L["ChannelLinks"]
Prat_ChatLink.moduleDesc = L["Chat channel item link options."]
Prat_ChatLink.consoleName = "chatlink"
Prat_ChatLink.guiName = L["ChannelLinks"]


-- Set this to true to use Prat Event Support
Prat_ChatLink.supportsPratEvents = true

-- define the default db values
Prat_ChatLink.defaultDB = {
    on = false,
    clink = true,
    cm = false,
    gem = false,
}

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_ChatLink.moduleOptions = {}

-- build the options menu using prat templates
Prat_ChatLink.toggleOptions = {
    clink = 180,
    cm = 190,
    gem = 195
}

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

-- things to do when the module is enabled
function Prat_ChatLink:OnModuleEnable()
    -- registry events
    self[LIB.REGISTEREVENT](self, "Prat_PreAddMessage")
    -- what da hook gon be?
    self:Hook("SendChatMessage", true)
end

-- things to do when the module is disabled
function Prat_ChatLink:OnModuleDisable()
    -- unregister events
    self:UnregisterAllEvents()
    -- unhook functions
    self:UnhookAll()
end

--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--

-- add item link with a prat event implementation
function Prat_ChatLink:Prat_PreAddMessage(message, frame, event, t, r, g, b)
    message.MESSAGE = self:ProcessText(message.MESSAGE)
end

local function find_iterate_over(name, ...)
	for i=1,select("#", ...) do
		local x = select(i, ...)
		if x and x:len()>0 and x == name then
			return true
		end
	end
	return false
end
function Prat_ChatLink:SendChatMessage(msg, chatType, language, channel)
    if msg and (chatType == "CHANNEL") then
        local _, chanName = GetChannelName(channel)
        if chanName and not string.find (chanName, L["Trade"].." - ") and
            not find_iterate_over(chanName, EnumerateServerChannels()) 
        then
            msg = Prat_ChatLink:CreateLink(msg);
        end
    end
    self.hooks.SendChatMessage(msg, chatType, language, channel)
end

-- Utility Function
function Prat_ChatLink:ProcessText(text)
    if (self.db.profile.clink) then
        return self:ChatLink_Decompose(text)
    end
    if text then
        -- Chatmanager [Thick Furry Mane]{4583:0:0:0}
        text = Prat_ChatLink:DecomposeCMLink(text, "%[([^%[^%]]-)%]{(%d+):(%d+):(%d+):(%d+)}(\b*)")
        -- Code from ChatLink
        text = string.gsub (text, "{CLINK:item:(%x+):(%d-:%d-:%d-:%d-:%d-:%d-:%d-:%d-):([^}]-)}", "|c%1|Hitem:%2|h[%3]|h|r")
        text = string.gsub (text, "{CLINK:enchant:(%x+):(%d-):([^}]-)}", "|c%1|Henchant:%2|h[%3]|h|r")
        -- For backward compatibility (yeah, I should have done it before...).
        text = string.gsub (text, "{CLINK:(%x+):(%d-:%d-:%d-:%d-:%d-:%d-:%d-:%d-):([^}]-)}", "|c%1|Hitem:%2|h[%3]|h|r")
        -- Forward compatibility, for future clink structure changes.
        text = string.gsub (text, "{CLINK(%d):%[?([^:}%]]-)%]?:([^:}]-)[^}]-}", "%2")
        return text
    end
end

function Prat_ChatLink:CreateLink(link)
    local pattern = "|c(%x+)|Hitem:(%d+):(%d+):(%d+):(%d+)|h%[(.-)%]|h|r"
    if (self.db.profile.clink) then
        return self:ChatLink_Compose(link)
    elseif (self.db.profile.chatmanager) then return Prat_ChatLink:CreateCMLink(link, pattern)
    else return link end
end

-- Inspired from Cirk"s Chatmanager
local _rarityConvertToColor = {}
local _rarityLookupByColor = {}

for rarity = 0, 6 do
    local _, _, _, itemColor = GetItemQualityColor(rarity);
    if (itemColor) then
        _rarityConvertToColor[rarity] = itemColor;
        _rarityLookupByColor[string.sub(itemColor, 3)] = rarity;
    end
end

function Prat_ChatLink:DecomposeCMLink(link, pattern)
    local function gsubDecomposeCMLink(name, i1, i2, i3, i4, rS)
        local itemString = "item:"..i1..":"..i2..":"..i3..":"..i4;
        local itemName, itemLink, itemRarity = GetItemInfo(itemString);
        if (itemName and itemLink and itemRarity) then
            local itemColor = _rarityConvertToColor[tonumber(itemRarity)];
            if (not itemColor) then
                itemColor = "";
            end
            return itemColor.."|H"..itemLink.."|h["..itemName.."]|h|r";
        end
        itemRarity = string.len(rS) - 1;
        if (itemRarity >= 0) then
            local itemColor = _rarityConvertToColor[tonumber(itemRarity)];
            if (not itemColor) then
                itemColor = "";
            end
            return itemColor.."|H"..itemString.."|h["..name.."]|h|r";
        end
        return "|H"..itemString.."|h["..name.."]|h|r";
    end
    return string.gsub(link, pattern, gsubDecomposeCMLink)
end

function Prat_ChatLink:CreateCMLink(link, pattern)
    local function gsubCMLink(cS, i1, i2, i3, i4, name)
        local itemString = "item:"..i1..":"..i2..":"..i3..":"..i4;
        local _, _, itemRarity = GetItemInfo(itemString);
        if (not itemRarity) then
            -- Perform reverse color lookup to get rarity instead
            itemRarity = _rarityLookupByColor[cS];
        end
        if (itemRarity) then
            return "["..name.."]{"..i1..":"..i2..":"..i3..":"..i4.."}"..string.rep("\b", tonumber(itemRarity) + 1);
        end
        return "["..name.."]{"..i1..":"..i2..":"..i3..":"..i4.."}";
    end
    return string.gsub(link, pattern, gsubCMLink)
end

-- CREDIT TO: Yrys - Hellscream, author of ChatLink, the following code copied verbatim

-- Turn CLINKs into normal item and enchant links.
function Prat_ChatLink:ChatLink_Decompose (chatstring)
    if chatstring then
		chatstring = string.gsub (chatstring, "{CLINK:item:(%x+):(%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-):([^}]-)}", "|c%1|Hitem:%2|h[%3]|h|r")
		chatstring = string.gsub (chatstring, "{CLINK:enchant:(%x+):(%-?%d-):([^}]-)}", "|c%1|Henchant:%2|h[%3]|h|r")
		chatstring = string.gsub (chatstring, "{CLINK:quest:(%x+):(%-?%d-):(%-?%d-):([^}]-)}","|cffffff00|Hquest:%2:%3|h[%4]|h|r")
		chatstring = string.gsub (chatstring, "{CLINK:spell:(%x+):(%-?%d-):([^}]-)}","|c%1|Hspell:%2|h[%3]|h|r")
        -- For backward compatibility (yeah, I should have done it before...).
		chatstring = string.gsub (chatstring, "{CLINK:(%x+):(%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-):([^}]-)}", "|c%1|Hitem:%2|h[%3]|h|r")
		-- For Compatibility with GEM
		if self.db.profile.gem then 
    		chatstring = string.gsub(chatstring, "\127p", "|")
	    end
	    	
        -- Forward compatibility, for future clink structure changes.
        chatstring = string.gsub (chatstring, "{CLINK(%d):%[?([^:}%]]-)%]?:([^:}]-)[^}]-}", "%2")
    end
    return chatstring
end

-- Turn item and enchant links into CLINKs.
function Prat_ChatLink:ChatLink_Compose (chatstring)
    if chatstring then
--      1.10 item links: to possibly be reactivated in a future version.
--      chatstring = string.gsub (chatstring, "|c(%x+)|H(item):(%d-):(%d-):(%d-):(%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4:%5:%6:%7}")
--      Old item links: backward compatibility.
		chatstring = string.gsub (chatstring, "|c(%x+)|Hitem:(%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%1:%2:%3}")
		chatstring = string.gsub (chatstring, "|c(%x+)|H(enchant):(%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4}")
		chatstring = string.gsub (chatstring, "|c(%x+)|H(quest):(%-?%d-):(%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4:%5}")
		chatstring = string.gsub (chatstring, "|c(%x+)|H(spell):(%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4}")
    end
    return chatstring
end
