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
Name: Prat_History
Revision: $Revision: 79185 $
Author(s): Krtek (krtek4@gmail.com); Fin (fin@instinct.org)
Website: http://files.wowace.com/Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#History
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: Module for Prat that adds chat history options.
Dependencies: Prat
]]

--[[
	2007-06-24: added option to save cmd history - fin
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratHistory")

if PRAT_MODULE == nil then
	return
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
	["History"] = true,
	["Chat history options."] = true,
	["Set Chat Lines"] = true,
	["Set the number of lines of chat history for each window."] = true,
	["Set ChatFrame%d Chat Lines"] = true,
	["Sets the number of lines of chat history to save."] = true,
	["Set Command History"] = true,
	["Maximum number of lines of command history to save."] = true,
	["Save Command History"] = true,
	["Saves command history between sessions (for use with alt+up arrow or just the up arrow)"] = true,
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79185 $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
	["History"] = "历史",
	["Chat history options."] = "聊天历史选项.",
	["Set Chat Lines"] = "设置",
	["Set the number of lines of chat history for each window."] = "为每个聊天窗口设置历史记录行数.",
    ["Set ChatFrame%d Chat Lines"] = "聊天窗口 %d 历史",
    ["Sets the number of lines of chat history to save."] = "设置聊天窗口 %d 聊天历史记录",
	["Save Command History"] = "保存命令历史",
	["Saves command history between sessions (for use with alt+up arrow or just the up arrow)"] = "保存进程命令历史 (使用 <Alt+上> 或 <上> 键可搜索的)",
	["Set Command History"] = "命令历史数",
	["Maximum number of lines of command history to save."] = "保存命令历史最大条目",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
	["History"] = "이력",
	["Chat history options."] = "대화 이력 설정입니다.",
	["Set Chat Lines"] = "대화 라인 설정",
	["Set the number of lines of chat history for each window."] = "각 대화창에 대한 대화 이력의 라인 수를 설정합니다.",
	["Set ChatFrame%d Chat Lines"] = "%d 대화창 대화 라인 설정",
	["Sets the number of lines of chat history to save."] = "저장할 대화 이력의 라인 수를 설정합니다.",
	["Set Command History"] = "명령어 이력 설정",
	["Maximum number of lines of command history to save."] = "저장할 명령어 이력의 최대 라인의 수입니다.",
	["Save Command History"] = "명령어 이력 저장",
	["Saves command history between sessions (for use with alt+up arrow or just the up arrow)"] = "접속간 명령어 이력을 저장합니다. (ALT+위 방향키 혹은 위 방향키 사용)",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
	["History"] = "歷史",
	["Chat history options."] = "聊天歷史選項。",
	["Set Chat Lines"] = "聊天行數",
	["Set the number of lines of chat history for each window."] = "設定各個聊天視窗的聊天行數。",
	["Set ChatFrame%d Chat Lines"] = "聊天視窗%d聊天行數",
	["Sets the number of lines of chat history to save."] = "設定儲存的聊天歷史行數。",
	["Set Command History"] = "指令歷史",
	["Maximum number of lines of command history to save."] = "設定最多儲存多少行指令。",
	["Save Command History"] = "儲存指令歷史",
	["Saves command history between sessions (for use with alt+up arrow or just the up arrow)"] = "儲存指令歷史 (Alt-上或上鍵使用)。",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["History"] = "Historial",
    ["Chat history options."] = "Opciones del historial de chat",
    ["Set Chat Lines"] = "Establecer",
    ["Set the number of lines of chat history for each window."] = "Establece el n\195\186mero de l\195\173neas de historial para cada ventana",
    ["Set ChatFrame%d Chat Lines"] = "Historial del Chat %d",
    ["Sets the number of lines of chat history to save."] = "Establece el historial para la ventana de chat %d",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["History"] = "Verlauf",
    ["Chat history options."] = "Chat Verlauf Optionen.",
    ["Set Chat Lines"] = "Setze",
    ["Set the number of lines of chat history for each window."] = "Setze die Anzahl der Verlauf Zeilen f\195\188r jedes Fenster.",
    ["Set ChatFrame%d Chat Lines"] = "Chat %d Verlauf",
    ["Sets the number of lines of chat history to save."] = "Setze Verlauf f\195\188r Chatfenster %d.",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["History"] = "Historique",
    ["Chat history options."] = "Options de l'historique des chats",
    ["Set Chat Lines"] = "Nombre de lignes",
    ["Set the number of lines of chat history for each window."] = "R195\168gle le nombre de lignes d'historique à garder pour chaque fen\195\170tre.",
    ["Set ChatFrame%d Chat Lines"] = "Historique fen\195\170tre %d",
    ["Sets the number of lines of chat history to save."] = "R195\168gle l'historique pour la fen\195\170tre %d.",
} end)



-- create prat module
Prat_History = Prat:NewModule(PRAT_MODULE, LIB.HOOKS)
local Prat_History = Prat_History
Prat_History.pratModuleName = PRAT_MODULE
Prat_History.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_History.moduleName = L["History"]
Prat_History.moduleDesc = L["Chat history options."]
Prat_History.consoleName = string.lower(Prat_History.moduleName)
Prat_History.guiName = L["History"]

-- define the default db values
Prat_History.defaultDB = {
	on = true,
	chatlines = {384, 384, 384, 384, 384, 384, 384, 384},
	maxlines = 5000,
	savehistory = false,
	cmdhistory = {},
}

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_History.moduleOptions = {}

-- build the options menu using prat templates
Prat_History.toggleOptions = {
	sep115_sep = 115,
}

-- add module options not covered by templates
function Prat_History:GetModuleOptions()
	self.moduleOptions = {
		name = L["History"],
		desc = L["Chat history options."],
		type = "group",
		args = {
			chatlines = {
				name = L["Set Chat Lines"],
				desc = L["Set the number of lines of chat history for each window."],
				type = "group",
                order = 110,
				args = {
					chat1 = {
						name = string.format(L["Set ChatFrame%d Chat Lines"], 1),
						desc = string.format(L["Sets the number of lines of chat history to save."], 1),
						type = "range",
						min = 50,
						max = 5000,
						step = 1,
						get = function() return self.db.profile.chatlines[1] end,
						set = function(v) Prat_History:SetHistory(1, v) end,
					},
					chat2 = {
						name = string.format(L["Set ChatFrame%d Chat Lines"], 2),
						desc = string.format(L["Sets the number of lines of chat history to save."], 2),
						type = "range",
						min = 50,
						max = 5000,
						step = 1,
						get = function() return self.db.profile.chatlines[2] end,
						set = function(v) Prat_History:SetHistory(2, v) end,
					},
					chat3 = {
						name = string.format(L["Set ChatFrame%d Chat Lines"], 3),
						desc = string.format(L["Sets the number of lines of chat history to save."], 3),
						type = "range",
						min = 50,
						max = 5000,
						step = 1,
						get = function() return self.db.profile.chatlines[3] end,
						set = function(v) Prat_History:SetHistory(3, v) end,
					},
					chat4 = {
						name = string.format(L["Set ChatFrame%d Chat Lines"], 4),
						desc = string.format(L["Sets the number of lines of chat history to save."], 4),
						type = "range",
						min = 50,
						max = 5000,
						step = 1,
						get = function() return self.db.profile.chatlines[4] end,
						set = function(v) Prat_History:SetHistory(4, v) end,
					},
					chat5 = {
						name = string.format(L["Set ChatFrame%d Chat Lines"], 5),
						desc = string.format(L["Sets the number of lines of chat history to save."], 5),
						type = "range",
						min = 50,
						max = 5000,
						step = 1,
						get = function() return self.db.profile.chatlines[5] end,
						set = function(v) Prat_History:SetHistory(5, v) end,
					},
					chat6 = {
						name = string.format(L["Set ChatFrame%d Chat Lines"], 6),
						desc = string.format(L["Sets the number of lines of chat history to save."], 6),
						type = "range",
						min = 50,
						max = 5000,
						step = 1,
						get = function() return self.db.profile.chatlines[6] end,
						set = function(v) Prat_History:SetHistory(6, v) end,
					},
					chat7 = {
						name = string.format(L["Set ChatFrame%d Chat Lines"],7),
						desc = string.format(L["Sets the number of lines of chat history to save."], 7),
						type = "range",
						min = 50,
						max = 5000,
						step = 1,
						get = function() return self.db.profile.chatlines[7] end,
						set = function(v) Prat_History:SetHistory(7, v) end,
					},
				}
            },
			maxlines = {
				name	= L["Set Command History"],
				desc	= L["Maximum number of lines of command history to save."],
				type	= "range",
				order	= 120,
				get	= function() return self.db.profile.maxlines end,
				set	= function(n) self.db.profile.maxlines = n end,
				min	= 50,
				max	= 5000,
				step	= 10,
				bigStep	= 50,
            },
			savehistory = {
				name	= L["Save Command History"],
				desc	= L["Saves command history between sessions (for use with alt+up arrow or just the up arrow)"],
				type	= "toggle",
				order	= 130,
				get	= function() return self.db.profile.saveHistory end,
				set	= function() self.db.profile.saveHistory = not self.db.profile.saveHistory end,
			},
		}
	}
   	return self.moduleOptions
end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

-- things to do when the module is enabled
function Prat_History:OnModuleEnable()
	for i=1,NUM_CHAT_WINDOWS do
		self:SetHistory(i,self.db.profile.chatlines[i])
	end

	if self.db.profile.saveHistory then
		if not self.db.profile.cmdhistory then
			self.db.profile.cmdhistory = {}
		end

		self:SecureHook(ChatFrameEditBox, "AddHistoryLine")
		self:addSavedHistory()
	end
end

-- things to do when the module is enabled
function Prat_History:OnModuleDisable()
	for i=1,NUM_CHAT_WINDOWS do
		self:SetHistory(i,512)
	end

	self.db.profile.cmdhistory = {}
end

--[[------------------------------------------------
	Core Functions
------------------------------------------------]]--

function Prat_History:SetHistory(id, lines)
    local f = getglobal("ChatFrame"..id)
	self.db.profile.chatlines[id] = lines
    
	if f:GetMaxLines() ~= lines then
	
	    local chatlines = util:acquire()
        for i=f:GetNumRegions(),1,-1 do
            local x = select(i, f:GetRegions())
            if x:GetObjectType() == "FontString" then
                table.insert(chatlines, { x:GetText(), x:GetTextColor() })
            end
        end
	
		f:SetMaxLines(lines)

        Prat.loading = true
	    for i,v in ipairs(chatlines) do
            f:AddMessage(unpack(v))
        end	        
        Prat.loading = false
        
        util:reclaim(chatlines)
	end
end

function Prat_History:addSavedHistory(cmdhistory)
	local cmdhistory	= self.db.profile.cmdhistory
	local cmdindex		= #cmdhistory

	-- where there"s a while, there"s a way
	while cmdindex > 0 do
		ChatFrameEditBox:AddHistoryLine(cmdhistory[cmdindex])
		cmdindex = cmdindex - 1
		-- way
	end
end

function Prat_History:saveLine(text)
	if not text or (text == "") then
		return false
	end

	local maxlines		= self.db.profile.maxlines
	local cmdhistory	= self.db.profile.cmdhistory

	table.insert(cmdhistory, 1, text)

	if #cmdhistory > maxlines then
		for x = 1, (#cmdhistory - maxlines) do
			table.remove(cmdhistory)
		end
	end

	self.db.profile.cmdhistory = cmdhistory
end

function Prat_History:AddHistoryLine(editBox)
	editBox = editBox or {}

	-- following code mostly ripped off from Blizzard, but at least I understand it now
    local text	= ""
    local type	= editBox:GetAttribute("chatType")
    local header	= getglobal("SLASH_" .. type .. "1")

	if (header) then
		text = header
	end

    if (type == "WHISPER") then
            text = text .. " " .. editBox:GetAttribute("tellTarget")
    elseif (type == "CHANNEL") then
            text = "/" .. editBox:GetAttribute("channelTarget")
    end

    local editBoxText = editBox:GetText();
    if (strlen(editBoxText) > 0) then
            text = text.." "..editBox:GetText();
    self:saveLine(text)
    end
end

--[[ just saving this here temporarily due to paranoia about something...
function Prat_History:AddHistoryLine(editBox)
	editBox = editBox or {}

	-- following code mostly ripped off from Blizzard, but at least I understand it now
        local text = "";
        local type = editBox:GetAttribute("chatType");
        local header = getglobal("SLASH_"..type.."1");

	if (header) then
		text	= header
	end

        if (type == "WHISPER") then
                text = text.." "..editBox:GetAttribute("tellTarget");
        elseif (type == "CHANNEL") then
                text = "/"..editBox:GetAttribute("channelTarget");
        end

        local editBoxText = editBox:GetText();
        if ( strlen(editBoxText) > 0 ) then
                text = text.." "..editBox:GetText();
		self:saveLine(text)
        end
end
]]
