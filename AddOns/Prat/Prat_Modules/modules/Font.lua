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
Name: PratFont
Revision: $Revision: 79185 $
Author(s): Curney (asml8ed@gmail.com)
Inspired by: ChatFrameExtender by Satrina
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#Font
SVN: http://svn.wowace.com/wowace/trunk/Prat/
Description: Module for Prat that allows you to set the font face and size for chat windows (default=blizz default font face at size 12).
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratFont")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["Font"] = true,
    ["Chat window font options."] = true,
    ["Set Separately"] = true,
    ["Toggle setting options separately for each chat window."] = true,
    ["Set Font Face"] = true,
    ["Set the text font face for all chat windows."] = true,
    ["rememberfont_name"] = "Remember Font",
    ["rememberfont_desc"] = "Remember your font choice and restore it at startup.",    
    ["Set Font Size"] = true,
    ["Set text font size for each chat window."] = true,
    ["Set ChatFrame%d Font Size"] = true,
    ["Set text font size."] = true,
    ["Auto Restore Font Size"] = true,
    ["Workaround a Blizzard bug which changes the font size when you open a system menu."] = true,
    ["outlinemode_name"] = "Set Outline Mode",
    ["outlinemode_desc"] = "Sets mode for the outline around the font.",
    ["None"] = true, 
    ["Outline"] = true, 
    ["Thick Outline"] = true,
    ["monochrome_name"] = "Toggle Monochrome",
    ["monochrome_desc"] = "Toggles monochrome coloring of the font.",
    ["shadowcolor_name"] = "Set Shadow Color",
    ["shadowcolor_desc"] = "Set the color of the shadow effect.", 
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79185 $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
	["Font"] = "字体尺寸",
	["Chat window font options."] = "聊天窗口字体尺寸选项.",
    ["Set Font Face"] = "字体",
    ["Set the text font face for all chat windows."] = "设置聊天文本字体",
    ["rememberfont_name"] = "记录字体",
    ["rememberfont_desc"] = "记录字体选择并在启动时恢复.",
    ["Set Font Size"] = "字体大小",
    ["Set text font size for each chat window."] = "每个聊天窗口的字体大小.",
    ["Set ChatFrame%d Font Size"] = "聊天窗口 %d 字体大小",
    ["Set text font size."] = "设置聊天窗口 %d 字体大小.",
    ["Auto Restore Font Size"] = "自动恢复",
    ["Workaround a Blizzard bug which changes the font size when you open a system menu."] = "解决打开系统菜单后字体大小变化的错误.",
    ["outlinemode_name"] = "设定轮廓模式",
    ["outlinemode_desc"] = "设定字体阴影模式。",
    ["None"] = "无", 
    ["Outline"] = "普通", 
    ["Thick Outline"] = "厚",
    ["monochrome_name"] = "单色",
    ["monochrome_desc"] = "切换字体使用单色颜色。",
    ["shadowcolor_name"] = "阴影颜色",
    ["shadowcolor_desc"] = "设定字体阴影颜色。",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["Font"] = "字型",
    ["Chat window font options."] = "聊天視窗字型選項。",
-- no use anymore    ["Set Separately"] = true,
-- no use anymore    ["Toggle setting options separately for each chat window."] = true,
    ["Set Font Face"] = "字體",
    ["Set the text font face for all chat windows."] = "設定全部聊天視窗的字體。",
    ["rememberfont_name"] = "記住字型",
    ["rememberfont_desc"] = "進入系統後恢復選擇的字型。",    
    ["Set Font Size"] = "字型大小",
    ["Set text font size for each chat window."] = "設定各個聊天視窗的字型大小。",
    ["Set ChatFrame%d Font Size"] = "聊天視窗%d字型大小",
    ["Set text font size."] = "設定字型大小。",
    ["Auto Restore Font Size"] = "自動恢復設定",
    ["Workaround a Blizzard bug which changes the font size when you open a system menu."] = "修正 Blizzard 的錯誤: 當你開啟系統選單時會改變字型大小。",
    ["outlinemode_name"] = "設定輪廓模式",
    ["outlinemode_desc"] = "設定字型陰影模式。",
    ["None"] = "無", 
    ["Outline"] = "普通", 
    ["Thick Outline"] = "厚",
    ["monochrome_name"] = "單色",
    ["monochrome_desc"] = "切換字型使用單色顏色。",
    ["shadowcolor_name"] = "陰影顏色",
    ["shadowcolor_desc"] = "設定字型陰影顏色。",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["Font"] = "Taille du texte",
    ["Chat window font options."] = "Options des tailles des textes",
    ["Set Font Size"] = "Changer la taille des textes",
    ["Set text font size for each chat window."] = "Change la taille du texte pour chaque fen\195\170tre.",
    ["Set ChatFrame%d Font Size"] = "Taille du texte, fen\195\170tre %d",
    ["Set text font size."] = "Change la taille du texte pour la fen\195\170tre %d.",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["Font"] = "글꼴",
    ["Chat window font options."] = "대화창 글꼴 설정입니다.",
    ["Set Separately"] = "개별 설정",
    ["Toggle setting options separately for each chat window."] = "각 대화창에 대한 개별 설정을 사용합니다.",
    ["Set Font Face"] = "글꼴 서체 설정",
    ["Set the text font face for all chat windows."] = "모든 대화창에 대한 글꼴 서체를 설정합니다.",
    ["rememberfont_name"] = "글꼴 저장",
    ["rememberfont_desc"] = "선택된 글꼴을 저장하고 시작 시 적용합니다.",    
    ["Set Font Size"] = "글꼴 크기 설정",
    ["Set text font size for each chat window."] = "각 대화창에 대한 글꼴 크기를 설정합니다.",
    ["Set ChatFrame%d Font Size"] = "%d 대화창 글꼴 크기 설정",
    ["Set text font size."] = "글자 글꼴 크기를 설정합니다.",
    ["Auto Restore Font Size"] = "글꼴 크기 자동 복원",
    ["Workaround a Blizzard bug which changes the font size when you open a system menu."] = "시스템 메뉴 열 때 글꼴 크기가 변경되는 게임 버그를 수정합니다.",
    ["outlinemode_name"] = "외곽선 모드 설정",
    ["outlinemode_desc"] = "글꼴 주위 외곽선을 위한 모드를 설정합니다.",
    ["None"] = "없음", 
    ["Outline"] = "외곽선", 
    ["Thick Outline"] = "두꺼운 외곽선",
    ["monochrome_name"] = "단색 전환",
    ["monochrome_desc"] = "글꼴의 단색화를 전환합니다.",
    ["shadowcolor_name"] = "그림자 색상 설정",
    ["shadowcolor_desc"] = "그림자 효과의 색상을 설정합니다.", 
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["Font"] = "Tama\195\177o de Fuente",
    ["Chat window font options."] = "Opciones del tama\195\177o de fuente en las ventanas de chat",
    ["Set Separately"] = "Establecer separadamente",
    ["Toggle setting options separately for each chat window."] = "Permite tener configuraciones separadas para cada ventana de chat.",
    ["Set Font Face"] = "Establecer Tipo de Fuente",
    ["Set the text font face for all chat windows."] = "Establece el tipo de fuente del texto para todas las ventanas del chat.",
    ["rememberfont_name"] = "Recordar Fuente",
    ["rememberfont_desc"] = "Recuerda tu selecci\195\179n de fuente y la restaura al inicio.",
    ["Set Font Size"] = "Tama\195\177o de Fuente",
    ["Set text font size for each chat window."] = "Establece el tama\195\177o de fuente para cada ventana de chat",
    ["Set ChatFrame%d Font Size"] = "Tama\195\177o de Fuente del Chat %d",
    ["Set text font size."] = "Establece el tama\195\177o de fuente para la ventana de chat %d",
    ["Auto Restore Font Size"] = "AutoRestaurar Tama\195\177o de la Fuente",
    ["Workaround a Blizzard bug which changes the font size when you open a system menu."] = "Solucina temporalmente un bug de Blizzard que cambia el tama\195\177o de fuente cuando abres el men\195\186 de sistema.",
    ["outlinemode_name"] = "Establecer Borde Fuente",
    ["outlinemode_desc"] = "Establece el modo para el borde de la fuente.",
    ["None"] = "Ninguno",
    ["Outline"] = "Borde",
    ["Thick Outline"] = "Borde Grueso",
    ["monochrome_name"] = "Monocromo",
    ["monochrome_desc"] = "Pono el color de la fuente en modo monocromo.",
    ["shadowcolor_name"] = "Establecer Color de Sombra",
    ["shadowcolor_desc"] = "Establece el color del efecto de la sombra.",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
	["Font"] = "Schriftgr\195\182\195\159e",
	["Chat window font options."] = "Chatfenster Schriftgr\195\182\195\159en Optionen.",
	["Set Font Size"] = "Setze Schriftgr\195\182\195\159e",
	["Set text font size for each chat window."] = "Setze Schriftgr\195\182\195\159e f\195\188r jedes Fenster.",
	["Set ChatFrame%d Font Size"] = "Chat %d Schriftgr\195\182\195\159e",
	["Set text font size."] = "Setze Schrifgr\195\182\195\159e f\195\188r Chatfenster %d.",
} end)



-- create prat module
Prat_Font = Prat:NewModule(PRAT_MODULE, LIB.HOOKS)
local Prat_Font = Prat_Font
Prat_Font.pratModuleName = PRAT_MODULE
Prat_Font.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_Font.moduleName = L["Font"] 	
Prat_Font.moduleDesc = L["Chat window font options."]
Prat_Font.consoleName = string.lower(Prat_Font.moduleName)
Prat_Font.guiName = L["Font"]


-- define the default db values
Prat_Font.defaultDB = {
    on = true,
    font = "",
    rememberfont = false,
    size = {12, 12, 12, 12, 12, 12, 12},
    autorestore = false, 
    outlinemode = "",
    monochrome = false,
    shadowcolor = {
        r = 0,
        g = 0,
        b = 0,
        a = 1,
    },
}

-- Fix the defaults that are being used for the chatframe text font size.
for i=1,NUM_CHAT_WINDOWS do
    local cf = getglobal("ChatFrame"..i)
    local _, s, _ = cf:GetFont()    
    Prat_Font.defaultDB.size[i]  = s
end

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_Font.moduleOptions = {}

-- build the options menu using prat templates
Prat_Font.toggleOptions = { 
    rememberfont = 120,
    sep125_sep = 125,
    sep145_sep = 145,
    outlinemode = {
        type = "text",
        order = 150,
        get = function() return Prat_Font.db.profile.outlinemode end,
        set = function(v) Prat_Font.db.profile.outlinemode = v; Prat_Font:ConfigureAllChatFrames() end,
        validate = {[""] = L["None"], ["OUTLINE"] = L["Outline"], ["THICKOUTLINE"] = L["Thick Outline"]},
    },
    monochrome = {
        type = "toggle",
        order = 160,
        get = function() return Prat_Font.db.profile.monochrome end,
        set = function(v) Prat_Font.db.profile.monochrome = v; Prat_Font:ConfigureAllChatFrames() end,
    },
    shadowcolor = { 
        type = "color", 
        order = 170, 
        get = "GetShadowClr", 
        set = "SetShadowClr",
    },
}

local fontslist = {}
local media 
local cf, i, v, k

function Prat_Font:BuildFontList()
    for i,v in ipairs(fontslist) do
        fontslist[i] = nil
    end
    
    for k,v in pairs(media:List(media.MediaType.FONT)) do
        table.insert(fontslist, v)
    end
end

function Prat_Font:SharedMedia_Registered(mediatype, name)
	self:Debug("SharedMedia_Registered", mediatype, name)
    if mediatype == media.MediaType.FONT then
        self:BuildFontList()
    end
end

function Prat_Font:GetModuleOptions()
    self.moduleOptions = {
        name = L["Font"],
        desc = L["Chat window font options."],
        type = "group",
        args = {
            fontface = {
                name = L["Set Font Face"],
                desc = L["Set the text font face for all chat windows."],
                type = "text",
                order = 110,
                get = function() return self.db.profile.font end,
                set = function(v) self.db.profile.font = v; self:SetFont(v) end,
                validate = fontslist,
            },
            fontsize = {
                name = L["Set Font Size"],
                desc = L["Set text font size for each chat window."],
                type = "group",
                order = 130,
                args = {
                    chat1 = {
                        name = string.format(L["Set ChatFrame%d Font Size"], 1),
                        desc = string.format(L["Set text font size."], 1),
                        type = "range",
                        get = function() return self.db.profile.size[1] end,
                        set = function(v) self.db.profile.size[1] = v; self:SetFontSize(1,v) end,
                        min = 4,
                        max = 22,
                        step = 1
                    },
                    chat2 = {
                        name = string.format(L["Set ChatFrame%d Font Size"], 2),
                        desc = string.format(L["Set text font size."], 2),
                        type = "range",
                        get = function() return self.db.profile.size[2] end,
                        set = function(v) self.db.profile.size[2] = v; self:SetFontSize(2,v) end,
                        min = 4,
                        max = 22,
                        step = 1
                    },
                    chat3 = {
                        name = string.format(L["Set ChatFrame%d Font Size"], 3),
                        desc = string.format(L["Set text font size."], 3),
                        type = "range",
                        get = function() return self.db.profile.size[3] end,
                        set = function(v) self.db.profile.size[3] = v; self:SetFontSize(3,v) end,
                        min = 4,
                        max = 22,
                        step = 1
                    },
                    chat4 = {
                        name = string.format(L["Set ChatFrame%d Font Size"], 4),
                        desc = string.format(L["Set text font size."], 4),
                        type = "range",
                        get = function() return self.db.profile.size[4] end,
                        set = function(v) self.db.profile.size[4] = v; self:SetFontSize(4,v) end,
                        min = 4,
                        max = 22,
                        step = 1
                    },
                    chat5 = {
                        name = string.format(L["Set ChatFrame%d Font Size"], 5),
                        desc = string.format(L["Set text font size."], 5),
                        type = "range",
                        get = function() return self.db.profile.size[5] end,
                        set = function(v) self.db.profile.size[5] = v; self:SetFontSize(5,v) end,
                        min = 4,
                        max = 22,
                        step = 1
                    },
                    chat6 = {
                        name = string.format(L["Set ChatFrame%d Font Size"], 6),
                        desc = string.format(L["Set text font size."], 6),
                        type = "range",
                        get = function() return self.db.profile.size[6] end,
                        set = function(v) self.db.profile.size[6] = v; self:SetFontSize(6,v) end,
                        min = 4,
                        max = 22,
                        step = 1
                    },
                    chat7 = {
                        name = string.format(L["Set ChatFrame%d Font Size"], 7),
                        desc = string.format(L["Set text font size."], 7),
                        type = "range",
                        get = function() return self.db.profile.size[7] end,
                        set = function(v) self.db.profile.size[7] = v; self:SetFontSize(7,v) end,
                        min = 4,
                        max = 22,
                        step = 1
                    },
                }
            },
            autorestore = { 
                name = L["Auto Restore Font Size"],
                desc = L["Workaround a Blizzard bug which changes the font size when you open a system menu."],
                type = "toggle",
                order = 140,
                get = function() return self.db.profile.autorestore end,
                set = function(v) self.db.profile.autorestore = v; self:SetAutoRestore(v) end
            },
        }
    }
    return self.moduleOptions
end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

function Prat_Font:OnModuleEnable()
    -- fix menu ordering
    self.moduleOptions.args.rememberfont.order = 120
    -- set up the font list
    media = media or PRAT_LIBRARY(LIB.MEDIA)
    self.oldsize = {}
    self:BuildFontList()

    if media.RegisterCallback then
		media.RegisterCallback(self, "LibSharedMedia_Registered", "SharedMedia_Registered")
		media.RegisterCallback(self, "LibSharedMedia_SetGlobal", "SharedMedia_Registered")
	else
		self[LIB.REGISTEREVENT](self, "SharedMedia_Registered")
    end

    -- get current font sizes
    for i, cf in ipairs(Prat.Frames) do
        local _, s, _ = cf:GetFont()    
        self.oldsize[i]  = s
    end
    -- force the font size
    if self.db.profile.rememberfont and self.db.profile.font then
        self:SetFont(self.db.profile.font)
    end
    -- refresh chat frames with font parameters
    self:ConfigureAllChatFrames()
    -- This will resolve the issue where, when font sizes are set smaller than 12,
    -- the size resets to 12 when closing UIOptionsFrame.
    self:SetAutoRestore(self.db.profile.autorestore)
    -- hook em
    self:SecureHook("FCF_SetChatWindowFontSize")
end

function Prat_Font:OnModuleDisable()
    for i=1,NUM_CHAT_WINDOWS do
        self:SetFontSize(i,self.oldsize[i] or 12)
    end
    self:SetFontMode("")

    if media.UnregisterCallback then
		media.UnregisterCallback(self, "LibSharedMedia_Registered")
    end
end

--[[------------------------------------------------
	Core Functions
------------------------------------------------]]--

function Prat_Font:ConfigureAllChatFrames()
	local db = self.db.profile

    -- apply font size settings
    for i = 1,NUM_CHAT_WINDOWS do
        self:SetFontSize(i, db.size[i])
    end
    -- apply font flag settings
    if not db.monochrome then
        self:SetFontMode(db.outlinemode)
    else
        self:SetFontMode(db.outlinemode..", MONOCHROME")
    end
end

function Prat_Font:SetFontSize(id, size)
    FCF_SetChatWindowFontSize(getglobal("ChatFrame"..id), size)
end



function Prat_Font:SetFont(font)
    fontfile = media:Fetch(media.MediaType.FONT, font)
    for _, cf in pairs(Prat.Frames) do
        local f, s, m = cf:GetFont()    
        cf:SetFont(fontfile, s, m)
    end
end

function Prat_Font:SetFontMode(mode)
    for _, cf in pairs(Prat.Frames) do
        local f, s, m = cf:GetFont()    
        cf:SetFont(f, s, mode)
        local c = self.db.profile.shadowcolor
        cf:SetShadowColor(c.r, c.g, c.b, 1)
    end
end

function Prat_Font:GetShadowClr()
    local h = self.db.profile.shadowcolor or {}
    return h.r or 1.0, h.g or 1.0, h.b or 1.0
end

function Prat_Font:SetShadowClr(r,g,b)
	local db = self.db.profile
    db.shadowcolor = db.shadowcolor or {}
    local h = db.shadowcolor
    h.r, h.g, h.b = r, g, b
    self:ConfigureAllChatFrames()
end

function Prat_Font:FCF_SetChatWindowFontSize(chatFrame, fontSize)
	if ( not chatFrame ) then
		chatFrame = FCF_GetCurrentChatFrame();
	end
	if ( not fontSize ) then
		fontSize = this.value;
	end    
    self.oldsize[chatFrame:GetID()] = fontSize 
    if self.db and self.db.profile.on then
       self.db.profile.size[chatFrame:GetID()] = fontSize
    end
end

function Prat_Font:SetAutoRestore(val)
    self.db.profile.autorestore = val
    if self.db.profile.autorestore then
    	if not self:IsHooked("UpdateMicroButtons") then self:SecureHook("UpdateMicroButtons", "ConfigureAllChatFrames") end
    else
    	if self:IsHooked("UpdateMicroButtons") then self:Unhook("UpdateMicroButtons") end
    end
end    

function Prat_Font:ModuleGetOption(name)
    if (name == "shadowcolor") then
        local c = self.db.profile.shadowcolor
        self:Debug("getcolor", c.r, c.g, c.b)
        return c.r, c.g, c.b
    else
        return self.super.ModuleGetOption(self, name)
    end
end

function Prat_Font:ModuleSetOption(name, val, v2, v3)
    if (name == "shadowcolor") then
        self:Debug("setcolor", val, v2, v3)
        local c = self.db.profile.shadowcolor
        c.r, c.g, c.b = val, v2, v3
    else
        self.super.ModuleSetOption(self, name, val)
    end
    self:ConfigureAllChatFrames()
end
