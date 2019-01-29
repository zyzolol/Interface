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
Name: PratParagraph
Revision: $Revision: 79185 $
Author(s): Curney (asml8ed@gmail.com)
Thanks to: Wubin for helping me understand variables better
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#Paragraph
SVN: http://svn.wowace.com/wowace/trunk/Prat/
Description: Module for Prat that gives options for paragraphs in chat windows (defaults=left-aligned text, linespacing=0).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratParagraph")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["Paragraph"] = true,
    ["Chat window paragraph options."] = true,
    ["Set Alignment"] = true,
    ["Set horizontal alignment for each chat window."] = true,
    ["Set ChatFrame%d Alignment"] = true,
    ["Set horizontal alignment to left, right, or center."] = true,
    ["Line Spacing"] = true,
    ["Set the line spacing for all chat windows."] = true,
    ["adjustlinks_name"] = "Fix placement of player/item links",
    ["adjustlinks_desc"] = "Adjust links to restore clickability on centered or right-aligned text.",    
	["Center"] = true,
	["Right"] = true,
	["Left"] = true,
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79185 $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
 	["Paragraph"] = "段落",
 	["Chat window paragraph options."] = "聊天窗口段落选项.",
    ["Set Alignment"] = "设置对齐",
    ["Set horizontal alignment for each chat window."] = "设置每个聊天窗口对齐格式.",
    ["Set ChatFrame%d Alignment"] = "聊天窗口 %d 对齐",
    ["Set horizontal alignment to left, right, or center."] = "给聊天窗口 %d 设置对齐",
    ["Line Spacing"] = "行间距",
    ["Set the line spacing for all chat windows."] = "为全部聊天窗口设置行间距",
    ["adjustlinks_name"] = "修正玩家/物品链接位置",
    ["adjustlinks_desc"] = "右对齐或置中时调整链接保持点击功能.",
	["Center"] = "置中",
	["Right"] = "右",
	["Left"] = "左",
 } end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["Paragraph"] = "段落",
    ["Chat window paragraph options."] = "聊天視窗段落選項。",
    ["Set Alignment"] = "設定對齊",
    ["Set horizontal alignment for each chat window."] = "設定各個聊天視窗的對齊。",
    ["Set ChatFrame%d Alignment"] = "聊天視窗%d對齊",
    ["Set horizontal alignment to left, right, or center."] = "設定聊天視窗的對齊選項。",
    ["Line Spacing"] = "行距",
    ["Set the line spacing for all chat windows."] = "設定全部聊天視窗的行距。",
    ["adjustlinks_name"] = "修正玩家/物品連結位置",
    ["adjustlinks_desc"] = "使連結在靠右或置中對齊時依然可以點擊。",    
	["Center"] = "置中",
	["Right"] = "靠右",
	["Left"] = "靠左",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
	["Paragraph"] = "Justification",
	["Chat window paragraph options."] = "Options concernant la justification.",
	["Set Alignment"] = "Justification",
	["Set horizontal alignment for each chat window."] = "Règle la justification pour toutes les fenêtres.",
	["Set ChatFrame%d Alignment"] = "Fenêtre %d",
	["Set horizontal alignment to left, right, or center."] = "R\195\168gle la justification pour la fenêtre %d.",
	["adjustlinks_name"] = "Corrige le placement des liens",
	["adjustlinks_desc"] = "Corrige le placement des liens lorsque la justification est sur Centrée ou Droite.",    
	["Center"] = "Centré",
	["Right"] = "Aligné à droite",
	["Left"] = "Aligné à gauche",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["Paragraph"] = "단락",
    ["Chat window paragraph options."] = "대화창 단락 설정입니다.",
    ["Set Alignment"] = "정렬 설정",
    ["Set horizontal alignment for each chat window."] = "각 대화창에 대한 수평 정렬을 설정합니다.",
    ["Set ChatFrame%d Alignment"] = "%d 대화창 정렬 설정",
    ["Set horizontal alignment to left, right, or center."] = "왼쪽, 오른쪽, 혹은 가운데 수평 정렬을 설정합니다.",
    ["Line Spacing"] = "줄 간격",
    ["Set the line spacing for all chat windows."] = "모든 대화창에 대한 줄 간력을 설정합니다.",
    ["adjustlinks_name"] = "플레이어/아이템 링크 위치 수정",
    ["adjustlinks_desc"] = "우측 혹은 가운데 정렬일 때 클릭가능한 것들을 복원하기 위내 링크를 조절합니다.",
	["Center"] = "가운데",
	["Right"] = "우측",
	["Left"] = "좌측",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["Paragraph"] = "Justificar",
    ["Chat window paragraph options."] = "Opciones de parrafo para la ventana de chat.",
    ["Set Alignment"] = "Establecer Justificaci\195\179n",
    ["Set horizontal alignment for each chat window."] = "Establece la justificaci\195\179n para cada ventana",
    ["Set ChatFrame%d Alignment"] = "Justificaci\195\179n del Chat %d",
    ["Set horizontal alignment to left, right, or center."] = "Establece la justificaci\195\179n para la ventana de chat %d",
    ["Line Spacing"] = "Espaciado de L\195\173nea",
    ["Set the line spacing for all chat windows."] = "Establece el espaciado de l\195\173nea para todas las ventanas del chat",
    ["adjustlinks_name"] = "Arreglar la posici\195\179n de los enlaces de jugador/objeto",
    ["adjustlinks_desc"] = "Permite volver a hacer clic sobre los enlaces cuando la justificaci\195\179n es derecha o centro.",
	["Center"] = "Centro",
	["Right"] = "Derecha",
	["Left"] = "Izquierda",
} end)
 
L[LIB.NEWLOCALE](L, "deDE", function() return {
	["Paragraph"] = "Absatz",
	["Chat window paragraph options."] = "Chatfenster Absatz Optionen",
	["Set Alignment"] = "B\195\188ndigkeit einstellen",
	["Set horizontal alignment for each chat window."] = "Setze horizontale B\195\188ndigkeit f\195\188r jedes Fenster.",
	["Set ChatFrame%d Alignment"] = "Chat %d B\195\188ndigkeit",
	["Set horizontal alignment to left, right, or center."] = "Setze horizontale B\195\188ndigkeit auf Links, Rechts oder Mitte.",
	["Line Spacing"] = "Zeilenabstand",
	["Set the line spacing for all chat windows."] = "Justiere den Zeilenabstand f\195\188r alle chatfenster.",
	["adjustlinks_name"] = "Fixiere Plazierung von Spieler/Item Links",
	["adjustlinks_desc"] = "Justiere Links um ihre anklickbarkeit zu gew\195\164rleisten wenn die B\195\188ndigkeit auf rechts oder mitte eingestellt ist.",
	["Center"] = "Mitte",
	["Right"] = "Rechts",
	["Left"] = "Links",    
} end)



-- create prat module
Prat_Paragraph = Prat:NewModule(PRAT_MODULE, LIB.HOOKS)
local Prat_Paragraph = Prat_Paragraph
Prat_Paragraph.pratModuleName = PRAT_MODULE
Prat_Paragraph.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_Paragraph.moduleName = L["Paragraph"] 	
Prat_Paragraph.moduleDesc = L["Chat window paragraph options."]
Prat_Paragraph.consoleName = string.lower(Prat_Paragraph.moduleName)
Prat_Paragraph.guiName = L["Paragraph"]


-- define the default db values
Prat_Paragraph.defaultDB = {
    on = true,
    justification = {"LEFT", "LEFT", "LEFT", "LEFT", "LEFT", "LEFT", "LEFT"},
    adjustlinks = false,
    linespacing = 0,
}

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_Paragraph.moduleOptions = {}

-- build the options menu using prat templates
Prat_Paragraph.toggleOptions = { adjustlinks = true, optsep_sep = 125 }

-- add module options not covered by templates
function Prat_Paragraph:GetModuleOptions()
    self.moduleOptions = {
        name = L["Paragraph"],
        desc = L["Chat window paragraph options."],
        type = "group",
        args = {
            alignment = {
                name = L["Set Alignment"],
                desc = L["Set horizontal alignment for each chat window."],
                type = "group",
                order = 110,
                args = {
                    chat1 = {
                        name = string.format(L["Set ChatFrame%d Alignment"], 1),
                        desc = string.format(L["Set horizontal alignment to left, right, or center."], 1),
                        type = "text",
                        get = function() return self.db.profile.justification[1] end,
                        set = function(v) self.db.profile.justification[1] = v; self:SetJustify(1,v) end,
                        validate = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["CENTER"] = L["Center"]}
                    },
                    chat2 = {
                        name = string.format(L["Set ChatFrame%d Alignment"], 2),
                        desc = string.format(L["Set horizontal alignment to left, right, or center."], 2),
                        type = "text",
                        get = function() return self.db.profile.justification[2] end,
                        set = function(v) self.db.profile.justification[2] = v; self:SetJustify(2,v) end,
                        validate = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["CENTER"] = L["Center"]}
                    },
                    chat3 = {
                        name = string.format(L["Set ChatFrame%d Alignment"], 3),
                        desc = string.format(L["Set horizontal alignment to left, right, or center."], 3),
                        type = "text",
                        get = function() return self.db.profile.justification[3] end,
                        set = function(v) self.db.profile.justification[3] = v; self:SetJustify(3,v) end,
                        validate = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["CENTER"] = L["Center"]}
                    },
                    chat4 = {
                        name = string.format(L["Set ChatFrame%d Alignment"], 4),
                        desc = string.format(L["Set horizontal alignment to left, right, or center."], 4),
                        type = "text",
                        get = function() return self.db.profile.justification[4] end,
                        set = function(v) self.db.profile.justification[4] = v; self:SetJustify(4,v) end,
                        validate = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["CENTER"] = L["Center"]}
                    },
                    chat5 = {
                        name = string.format(L["Set ChatFrame%d Alignment"], 5),
                        desc = string.format(L["Set horizontal alignment to left, right, or center."], 5),
                        type = "text",
                        get = function() return self.db.profile.justification[5] end,
                        set = function(v) self.db.profile.justification[5] = v; self:SetJustify(5,v) end,
                        validate = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["CENTER"] = L["Center"]}
                    },
                    chat6 = {
                        name = string.format(L["Set ChatFrame%d Alignment"], 6),
                        desc = string.format(L["Set horizontal alignment to left, right, or center."], 6),
                        type = "text",
                        get = function() return self.db.profile.justification[6] end,
                        set = function(v) self.db.profile.justification[6] = v; self:SetJustify(6,v) end,
                        validate = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["CENTER"] = L["Center"]}
                    },
                    chat7 = {
                        name = string.format(L["Set ChatFrame%d Alignment"], 7),
                        desc = string.format(L["Set horizontal alignment to left, right, or center."], 7),
                        type = "text",
                        get = function() return self.db.profile.justification[7] end,
                        set = function(v) self.db.profile.justification[7] = v; self:SetJustify(7,v) end,
                        validate = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["CENTER"] = L["Center"]}
                    }
                }
            },
            linespacing = {
                name = L["Line Spacing"],
                desc = L["Set the line spacing for all chat windows."],
                type = "range",
                get = function() return self.db.profile.linespacing end,
                set = function(v) self.db.profile.linespacing = v; self:ConfigureAllChatFrames() end,
                min = 0, 
                max = 30, 
                step = 1,
                order = 130
            },
        }
    }
   	return self.moduleOptions
end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

function Prat_Paragraph:OnModuleEnable()
    -- fix menu ordering
    self.moduleOptions.args.adjustlinks.order = 120
    -- set justification and line spacing
    self:ConfigureAllChatFrames()
    -- hook functions
    self:SecureHook("ChatFrame_OnUpdate")
end

function Prat_Paragraph:OnModuleDisable()
    -- set justification to left and line spacing to 0
    for i=1,NUM_CHAT_WINDOWS do
        self:SetJustify(i,"LEFT")
        self:SetSpacing(i, 0)
    end
end

--[[------------------------------------------------
	Core Functions
------------------------------------------------]]--

function Prat_Paragraph:ConfigureAllChatFrames()
    -- set justification and line spacing
    for i=1,NUM_CHAT_WINDOWS do
        self:SetJustify(i,self.db.profile.justification[i])
        self:SetSpacing(i,self.db.profile.linespacing)
    end
end

function Prat_Paragraph:SetJustify(id, justification)
    local cf = getglobal("ChatFrame"..id)
    cf:SetJustifyH(justification)
end

function Prat_Paragraph:ChatFrame_OnUpdate(...)
    if ( not this:IsShown() ) then
        return
    end
    if self.db.profile.adjustlinks then
        local just = self.db.profile.justification[this:GetID()]
        if just ~= "LEFT" then
            self:MoveLink(just == "CENTER" and 2 or 1, this:GetChildren())
        end
    end
end

function Prat_Paragraph:MoveLink(coeff, ...)
  for i=1,select("#", ...) do
    local o = select(i, ...)
        a,b,c,d,e = o:GetPoint()
        if b and b:GetObjectType() == "FontString" and o:GetObjectType() == "Button" then
        o:ClearAllPoints()
        o:SetPoint(a, b, c, (b:GetWidth()-b:GetStringWidth())/coeff, e)
        end
  end
end

function Prat_Paragraph:SetSpacing(id, space)
    local cf = getglobal("ChatFrame"..id)
    getglobal("ChatFrame"..id):SetSpacing(space)
end
