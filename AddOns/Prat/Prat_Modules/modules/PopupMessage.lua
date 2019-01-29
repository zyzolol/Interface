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
Name: PratPopupMessage
Revision: $Revision: 79185 $
Author(s): Sylvanaar
Inspired by: CleanChat
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#PopupMessage
SVN: http://svn.wowace.com/wowace/trunk/Prat/
Description: Module for Prat that displays chat with your name in a pop up window
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
local PRAT_MODULE = Prat:RequestModuleName("PratPopupMessage")

if PRAT_MODULE == nil then 
    return 
end

local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["PopupMessage"] = true,
    ["Shows messages with your name in a popup."] = true,
    ["Set Separately"] = true,
    ["Toggle setting options separately for each chat window."] = true,
    ["show_name"] = "Show Popups",
    ["show_desc"] = "Show Popups for each window.",
    ["Show Popups"] = true,
    ["Show Popups for each window."] = true,
    ["show_perframename"] = "Show ChatFrame%d Popups",
    ["show_perframedesc"] = "Toggles showing popups on and off.",
    ["showall_name"] = "Show All Popups",
    ["showall_desc"] = "Show Popups for all chat windows.",
    ["Show All Popups"] = true,
    ["Show Popups for all chat windows."] = true,
    ["Add Nickname"] = true,
    ["Adds an alternate name to show in popups."] = true,
    ["Remove Nickname"] = true,
    ["Removes an alternate name to show in popups."] = true,
    ["Clear Nickname"] = true,
    ["Clears alternate name to show in popups."] = true,
    ["framealpha_name"] = "Popup Frame Alpha",
    ["framealpha_desc"] = "Set the alpha value of the popup frame when fully faded in.",
    ["Popup"] = true, 
    ["Shows messages in a popup window."] = true,
-- 	["Use SCT Message"] = true,
--	["Show the text as an SCT message instead of in its own frame"] = true,
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
	["PopupMessage"] = "Alerte pseudo",
	["Shows messages with your name in a popup."] = "Affiche dans une fenêtre les messages qui contiennent votre nom.",
	["Set Separately"] = "Régler séparément",
	["Toggle setting options separately for each chat window."] = "Règle les options séparément pour chaque fenêtre de chat.",
	["Show Popups"] = "Fenêtre flottante",
	["Show Popups for each window."] = "Afficher les fenêtres flottantes pour chaque fenêtre de discussion.",
	["Show All Popups"] = "Afficher toutes les fenêtres flottantes",
	["Show Popups for all chat windows."] = "Afficher les fenêtres flottantes pour toutes les fenêtres de chat.",
	["Adds an alternate name to show in popups."] = "Ajoute un nom secondaire pour lequel afficher les alertes.",
	["Add Nickname"] = "Ajouter un pseudo",
	["Remove Nickname"] = "Supprimer un pseudo",
	["Clear Nickname"] = "Vider les pseudos",
--	["Use SCT Message"] = "Utiliser les messages de SCT",
--	["Show the text as an SCT message instead of in its own frame"] = "Affiche le texte comme un message SCT",
	["show_name"] = "Afficher",
	["show_desc"] = "Afficher l'heure pour chaque fenêtre.",
	["show_perframename"] = "Fenêtre %s ",
	["show_perframedesc"] = "Affiche/masque les fenêtres flottantes pour la fenêtre %s .",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["PopupMessage"] = "메세지 팝업",
    ["Shows messages with your name in a popup."] = "당신의 이름을 포함한 메세지를 팝업으로 표시합니다.",
    ["Set Separately"] = "구분 설정",
    ["Toggle setting options separately for each chat window."] = "각각의 대화창에 구분 설정을 사용합니다.",
    ["show_name"] = "팝업 표시",
    ["show_desc"] = "각 대화창에 대한 팝업을 표시합니다.",
    ["Show Popups"] = "팝업 표시",
    ["Show Popups for each window."] = "각 대화창에 대한 팝업을 표시합니다.",
    ["show_perframename"] = "대화창%d 팝업 표시",
    ["show_perframedesc"] = "팝업 표시를 켜거나 끕니다.Toggles showing popups on and off.",
    ["showall_name"] = "모든 팝업 표시",
    ["showall_desc"] = "모든 대화창에 대한 팝업을 표시합니다.",
    ["Show All Popups"] = "모든 팝업 표시",
    ["Show Popups for all chat windows."] = "모든 대화창에 대한 팝업을 표시합니다.",
    ["Add Nickname"] = "별명 추가",
    ["Adds an alternate name to show in popups."] = "팝업에 표시할 별명을 추가합니다.",
    ["Remove Nickname"] = "별명 삭제",
    ["Removes an alternate name to show in popups."] = "팝업에 표시할 별명을 제거합니다.",
    ["Clear Nickname"] = "별명 초기화",
    ["Clears alternate name to show in popups."] = "팝업에 표시할 별명을 초기화합니다.",
    ["framealpha_name"] = "팝업창 투명도",
    ["framealpha_desc"] = "팝업창의 투명도를 설정합니다.",
    ["Popup"] = "팝업", 
    ["Shows messages in a popup window."] = "팝업창에 메세지를 표시합니다.",
--    ["Use SCT Message"] = "SCT 메세지 사용",
--    ["Show the text as an SCT message instead of in its own frame"] = "SCT 메세지로 팝업을 표시합니다.",
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79185 $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["PopupMessage"] = "弹出信息",
    ["Shows messages with your name in a popup."] = "弹出显示包含本人姓名的信息.",
    ["Set Separately"] = "独立设置",
    ["Toggle setting options separately for each chat window."] = "独立设置每个窗口的选项",
    ["show_name"] = "显示",
    ["show_desc"] = "切换每个窗口显示时间标签.",
    ["Show Popups"] = "弹出显示",
    ["Show Popups for each window."] = "弹出显示每个窗口信息.",
    ["show_perframename"] = "窗口 %s 弹出",
    ["show_perframedesc"] = "切换聊天窗口 %s 弹出显示.",
    ["showall_name"] = "全部弹出",
    ["showall_desc"] = "全部聊天窗口均弹出显示.",
    ["Show All Popups"] = "全部弹出",
    ["Show Popups for all chat windows."] = "全部聊天窗口均弹出显示",
    ["Add Nickname"] = "添加昵称",
    ["Remove Nickname"] = "移除昵称",
    ["Clear Nickname"] = "清除昵称",
    ["framealpha_name"] = "弹出窗口透明度",
    ["framealpha_desc"] = "设置弹出信息窗口的透明度",
-- 	["Use SCT Message"] = "使用 SCT 信息",
--	["Show the text as an SCT message instead of in its own frame"] = "使用 SCT 模式显示弹出信息替代自身框架",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["PopupMessage"] = "彈出訊息",
    ["Shows messages with your name in a popup."] = "將有你的名字的訊息顯示在彈出訊息中。",
    ["Set Separately"] = "個別設定",
    ["Toggle setting options separately for each chat window."] = "分別設定各聊天視窗。",
    ["show_name"] = "顯示彈出訊息",
    ["show_desc"] = "切換是否為各個聊天視窗顯示彈出訊息。",
    ["Show Popups"] = "顯示彈出訊息",
    ["Show Popups for each window."] = "切換是否為各個聊天視窗顯示彈出訊息。",
    ["show_perframename"] = "顯示聊天視窗%d彈出訊息",
    ["show_perframedesc"] = "切換是否顯示彈出訊息。",
    ["showall_name"] = "顯示全部彈出訊息",
    ["showall_desc"] = "為全部聊天視窗顯示彈出訊息。",
    ["Show All Popups"] = "顯示全部彈出訊息",
    ["Show Popups for all chat windows."] = "為全部聊天視窗顯示彈出訊息。",
    ["Add Nickname"] = "增加暱稱",
    ["Adds an alternate name to show in popups."] = "增加顯示在彈出訊息中的暱稱。",
    ["Remove Nickname"] = "移除暱稱",
    ["Removes an alternate name to show in popups."] = "移除顯示在彈出訊息中的暱稱。",
    ["Clear Nickname"] = "清除暱稱",
    ["Clears alternate name to show in popups."] = "清除全部顯示在彈出訊息中的暱稱。",
    ["framealpha_name"] = "彈出視窗透明度",
    ["framealpha_desc"] = "設定彈出視窗透明度。",
    ["Popup"] = "彈出視窗", 
    ["Shows messages in a popup window."] = "在彈出視窗中顯示訊息。",
-- 	["Use SCT Message"] = "使用 SCT 訊息",
--	["Show the text as an SCT message instead of in its own frame"] = "將訊息以 SCT 訊息顯示而不顯示在自己的視窗中。",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["PopupMessage"] = "Mensaje en Ventana Emergente",
    ["Shows messages with your name in a popup."] = "Muestras los mensajes con tu nombre en una ventana emergente",
    ["Set Separately"] = "Por Separado",
    ["Toggle setting options separately for each chat window."] = "Establece las opciones para cada ventana de chat por separado",
    ["show_name"] = "Mostrar",
    ["show_desc"] = "Muestra los ajustes de sello de tiempo para cada ventana.",
    ["Show Popups"] = "Mostrar ventanas emergentes",
    ["Show Popups for each window."] = "Muestra ventanas emergentes para cada ventana",
    ["show_perframename"] = "Mostrar Ventana Emergente en %s ",
    ["show_perframedesc"] = "Muestra las ventanas emergentes para la ventana de %s ",
    ["showall_name"] = "Mostrar Todas las Ventanas Emergentes",
    ["showall_desc"] = "Muestra las ventanas emergentes para todas las ventanas de chat",
    ["Show All Popups"] = "Mostrar Todas las Ventanas Emergentes",
    ["Show Popups for all chat windows."] = "Muestra las ventanas emergentes para todas las ventanas de chat",
    ["Add Nickname"] = "A\195\177adir Pseud\195\179nimmo",
    ["Adds an alternate name to show in popups."] = "A\195\177ade un nombre alternativo para mostrar en las ventanas emergentes",
    ["Remove Nickname"] = "Eliminar Pseud\195\179nimo",
    ["Removes an alternate name to show in popups."] = "Elimina un nombre alternativo para mostrar en las ventanas emergentes",
    ["Clear Nickname"] = "Borrar Pseud\195\179nimo",
    ["Clears alternate name to show in popups."] = "Limpia nombre alternativos a mostrar en ventanas emergentes.",
    ["framealpha_name"] = "Transparencia de Ventana Emergente",
    ["framealpha_desc"] = "Establece la transparencia de la ventana emergente cuando es mostrada",
    ["Popup"] = "Ventana Emergente",
    ["Shows messages in a popup window."] = "Muestra mensajes en una ventana emergente.",
-- 	["Use SCT Message"] = "Usar Mensaje SCT",
--	["Show the text as an SCT message instead of in its own frame"] = "Muestra el texto como un mensaje de SCT en vez de en su propio marco",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
	["PopupMessage"] = "Popup Nachrichten",
	["Shows messages with your name in a popup."] = "Zeige Nachrichten mit deinem Namen in einem Popup.",
	["Set Separately"] = "Seperat einstellen",
	["Toggle setting options separately for each chat window."] = "Aktiviert das seperate Einstellen der Optionen für jedes Chatfenster.",
	["show_name"] = "Zeige Namen",
	["show_desc"] = "Zeige Namen f\195\188r jedes Fenster.",
	["Show Popups"] = "Zeige Popups",
	["Show Popups for each window."] = "Zeige Popups f\195\188r jedes Fenster.",
	["show_perframename"] = "%s Popups Anzeigen",
	["show_perframedesc"] = "Schaltet Popups an und aus f\195\188r %s .",
	["showall_name"] = "Zeige alle Popups",
	["showall_desc"] = "Zeige Popups f\195\188r alle Chatfenster.",
	["Show All Popups"] = "Zeige alle Popups",
	["Show Popups for all chat windows."] = "Zeige Popups f\195\188r alle Chatfenster.",
	["Add Nickname"] = "Nicknamen hinzuf\195\188gen",
	["Adds an alternate name to show in popups."] = "F\195\188gt einen alternativen Namen hinzu der in den Popup's anzeigt wird.",
	["Remove Nickname"] = "Entferne Nicknamen",
	["Removes an alternate name to show in popups."] = "Entfernt einen der alternativen Nicknamen die in den Popup's angezeigt werden.",
	["Clear Nickname"] = "L\195\182sche Nicknamen",
	["Clears alternate name to show in popups."] = "L\195\182sche alternativen Namen der in den Popup's angezeigt wird.",
	["framealpha_name"] = "Popup Fenster Transparenz",
	["framealpha_desc"] = "Justiere die Transparenz des Popup Fensters wenn es voll eingeblendet ist.",
	["Popup"] = "Popup", 
	["Shows messages in a popup window."] = "Zeigt Nachrichten in einem Popup Fenster.",
--	["Use SCT Message"] = "Benutze SCT Nachrichtenfenster",
-- 	["Show the text as an SCT message instead of in its own frame"] = "Zeige die Texte als eine SCT Nachricht anstatt im eigenen Fenster.",
} end)

local EVENTS_EMOTES = {
  ["CHAT_MSG_BG_SYSTEM_ALLIANCE"] = true,
  ["CHAT_MSG_BG_SYSTEM_HORDE"] = true,
  ["CHAT_MSG_BG_SYSTEM_NEUTRAL"] = true,
  ["CHAT_MSG_EMOTE"] = true,
  ["CHAT_MSG_TEXT_EMOTE"] = true,
  ["CHAT_MSG_MONSTER_EMOTE"] = true,
  ["CHAT_MSG_MONSTER_SAY"] = true,
  ["CHAT_MSG_MONSTER_WHISPER"] = true,
  ["CHAT_MSG_MONSTER_YELL"] = true,
  ["CHAT_MSG_RAID_BOSS_EMOTE"] = true
};

local EVENTS_IGNORE = {
 ["CHAT_MSG_CHANNEL_NOTICE_USER"] = true,
 ["CHAT_MSG_SYSTEM"] = true,
}



-- create prat module
Prat_PopupMessage = Prat:NewModule(PRAT_MODULE, LIB.NOTIFICATIONS)
local Prat_PopupMessage = Prat_PopupMessage
Prat_PopupMessage.pratModuleName = PRAT_MODULE

Prat_PopupMessage.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_PopupMessage.moduleName = L["PopupMessage"]
Prat_PopupMessage.moduleDesc = L["Shows messages with your name in a popup."] 
Prat_PopupMessage.consoleName = string.lower(Prat_PopupMessage.moduleName)
Prat_PopupMessage.guiName = L["PopupMessage"]

-- define the default db values
Prat_PopupMessage.defaultDB = {
    on = true,
    separate = true,
    show = {false, false, false, false, false, false, false},
    showall = false,
    secure = true,
    framealpha = 1.0,
    nickname = {},
}

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_PopupMessage.moduleOptions = {}

-- build the options menu using prat templates
Prat_PopupMessage.toggleOptions = { 
    sep115_sep = 105,    
    show = {},
    sep125_sep = 125,    
    sep135_sep = 135,    
    sep155_sep = 165,    
    framealpha = {type = "range", min = 0.0, max = 1.0, step = 0.05, order = 170},
}

-- Set this to true to use Prat Event Support
Prat_PopupMessage.supportsPratEvents = true

-- add module options not covered by templates
function Prat_PopupMessage:GetModuleOptions()
    self.moduleOptions = {
        name = L["PopupMessage"],
        desc = L["Shows messages with your name in a popup."],
        type = "group",
        args = {
            separate = {
                name = L["Set Separately"],
                desc = L["Toggle setting options separately for each chat window."],
                type = "toggle",
                order = 100,
                get = function() return self.db.profile.separate end,
                set = function(v) self.db.profile.separate = v end,
            },
            show = {
                name = L["Show Popups"],
                desc = L["Show Popups for each window."],
                type = "group",
                order = 110,
                args = {
                },
            },
            showall = {
                name = L["Show All Popups"],
                desc = L["Show Popups for all chat windows."],
                type = "toggle",
                order = 120,
                get = function() return self.db.profile.showall end,
                set = function(v)
                    self.db.profile.showall = v
                    for i=1,NUM_CHAT_WINDOWS do
                        self.db.profile.show[i] = v
                    end
                end,
                disabled = function() if self.db.profile.separate then return true else return false end end,
            },
            addnick = {
                name = L["Add Nickname"],
                desc = L["Adds an alternate name to show in popups."],
                type = "text",
                order = 140,
                usage = "<string>",
                get = false,
				set = function(name) self:AddNickname(name) end
            },
            removenick = {
                name = L["Remove Nickname"],
                desc = L["Removes an alternate name to show in popups."],
                type = "text",
                order = 150,
				current = "",
				get = function() return "" end,
				validate = self.db.profile.nickname,
                disabled = function() return #self.db.profile.nickname == 0 end,
				set = function(value) self:RemoveNickname(value) end
            },
            clearnick = {
                name = L["Clear Nickname"],
                desc = L["Clears alternate name to show in popups."],
				type = "execute",
                order = 160,
                disabled = function() return (#self.db.profile.nickname == 0) end,
				func = function() self:ClearNickname() end
            },
        },
    }
    self.moduleOptions.args.output =  PRAT_LIBRARY(LIB.NOTIFICATIONS):GetAceOptionsDataTable(self).output 
  	return self.moduleOptions
end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

-- things to do when the module is enabled
function Prat_PopupMessage:OnModuleEnable(first)
    -- fix menu ordering
    self.moduleOptions.args.show.order = 110
    self.moduleOptions.args.show.disabled = function() if not self.db.profile.separate then return true else return false end end
    self.moduleOptions.args.output.order = 130
--    self.moduleOptions.args.usesct.hidden = function() if SCT then return false else return true end end
--    self.moduleOptions.args.usemsbt.hidden = function() if MikSBT then return false else return true end end

	self[LIB.REGISTEREVENT](self, "Prat_PostAddMessage")
	
	if first then 
    	self:RegisterSink(
    	    L["Popup"], 
    	    L["PopupMessage"], 
    	    L["Shows messages in a popup window."],
    	    "Popup"
    	)
    end
    
    local o = self.moduleOptions.args.output
  	if o.get():find("Default") then
  	    o.set("Popup", true)
  	end    	
    	    
    self.playerName = UnitName("player");
end

--[[------------------------------------------------
	Core Functions
------------------------------------------------]]--

-- /dump Prat_PopupMessage.moduleOptions.args.output.get():find("Default")
-- /script Prat_PopupMessage.moduleOptions.args.output.set("PopupMessage")
-- /dump Prat_PopupMessage.db.profile
-- /script Prat_PopupMessage.db.profile.sink10OutputSink = nil
function Prat_PopupMessage:Popup(source, text, r,g,b, ...)
    self:Debug("Popup", tostring(source), text)
    
    if UIFrameIsFlashing(Prat_PopupFrame) then  
        UIFrameFlashRemoveFrame(Prat_PopupFrame)
    end
    
	Prat_PopupFrame.fadeOut = 5;
	Prat_PopupFrame:SetAlpha(Prat_PopupMessage.db.profile.framealpha or 1.0);
	Prat_PopupFrameText:SetTextColor(r,g,b)
	Prat_PopupFrameText:SetText(text);
	
	local font, _, style = ChatFrame1:GetFont()
	local _, fontsize = GameFontNormal:GetFont()
	Prat_PopupFrameText:SetFont( font, fontsize, style )   
    Prat_PopupFrameText:SetNonSpaceWrap(false)
	Prat_PopupFrame:SetWidth(math.min(math.max(64, Prat_PopupFrameText:GetStringWidth()+20), 520))
    Prat_PopupFrame:SetHeight(64)
	Prat_PopupFrame:SetBackdropBorderColor(r,g,b) 	

    Prat_PopupFrameText:ClearAllPoints()
    Prat_PopupFrameText:SetPoint("TOPLEFT", Prat_PopupFrame, "TOPLEFT", 10, 10)
    Prat_PopupFrameText:SetPoint("BOTTOMRIGHT", Prat_PopupFrame, "BOTTOMRIGHT", -10, -10)
	Prat_PopupFrameText:Show()
	--Prat_PopupFrame:Show()
	
	local inTime, outTime, holdTime = 1, Prat_PopupFrame.fadeOut, 4

--[[
	UIFrameFlash(Prat_PopupFrame, 
	    inTime, outTime, 
	    inTime+outTime+holdTime, 
	    false, 
	    holdTime, 0)
]]    
	    
	    
	    
	local fadeInfo = {}
	fadeInfo.timeToFade = inTime
	fadeInfo.mode = "IN"
	fadeInfo.fadeHoldTime = holdTime
	fadeInfo.startAlpha = 0
	fadeInfo.endAlpha = Prat_PopupMessage.db.profile.framealpha or 1.0

	-- UIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
	fadeInfo.finishedFunc = UIFrameFadeOut
	fadeInfo.finishedArg1 = Prat_PopupFrame
	fadeInfo.finishedArg2 = outTime
	fadeInfo.finishedArg3 = Prat_PopupMessage.db.profile.framealpha or 1.0
	fadeInfo.finishedArg4 = 0
	UIFrameFade(Prat_PopupFrame, fadeInfo)	    
	    
end

function Prat_PopupMessage:Prat_PostAddMessage(message, frame, event, text, r, g, b, id)
    if Prat:GetEventID() and 
       Prat:GetEventID() == self.lastevent and 
       self.lasteventtype == event then 
       return 
    end
    
	if not (EVENTS_EMOTES[event] or EVENTS_IGNORE[event]) then
		if self.db.profile.showall or self.db.profile.show[frame:GetID()] then
			if message.PLAYERLINK ~= self.playerName  or self:IsDebugging() then
				self:CheckText(message.MESSAGE, message.OUTPUT, event, r, g, b)
			end
		end
	end
end

function Prat_PopupMessage:AddNickname(name)
	for k, v in pairs(self.db.profile.nickname) do
		if v == name then
			return
		end
	end
	table.insert(self.db.profile.nickname, name)
end

function Prat_PopupMessage:RemoveNickname(name)
	for k, v in pairs(self.db.profile.nickname) do
		if v == name then
			table.remove(self.db.profile.nickname, k)
		end
	end
end

function Prat_PopupMessage:ClearNickname()
	while getn(self.db.profile.nickname) > 0 do
		table.remove(self.db.profile.nickname)
	end
end

local tmp_color = {}
local function safestr(s) return s or "" end
function Prat_PopupMessage:CheckText(text, display_text, event, r, g, b)
	local textL = string.lower(safestr(text))
	local playerL = string.lower(safestr(self.playerName))
    local show = false
    
    if string.find(textL, playerL) then	
        show = true;
    else
    	for k, v in pairs(self.db.profile.nickname) do
    		local nicknameL = v
    
    		if (nicknameL ~= "" and not show) then
    			if string.find(textL, nicknameL) then	
                    show = true;
    			end
    		end
    	end
	end
	
	if show then 
        self.lasteventtype = event
        self.lastevent = Prat:GetEventID()

	    self:Debug("Showing", self.lasteventtype, self.lastevent)		

		self:Pour(display_text or text, r,g,b)
		PlaySoundFile(Prat.sounds.popup);
	end	
end


