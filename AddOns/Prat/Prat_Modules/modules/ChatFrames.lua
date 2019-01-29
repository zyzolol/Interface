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
Name: PratChatFrames
Revision: $Revision: 79185 $
Author(s): Curney (asml8ed@gmail.com)
           Sylvanaar (sylvanaar@mindspring.com)
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#ChatFrames
Subversion: http://svn.wowace.com/wowace/trunk/Prat/
Discussions: http://groups.google.com/group/wow-prat
Issues and feature requests: http://code.google.com/p/prat/issues/list
Description: Module for Prat that adds options for changing chat window parameters.
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
-- set prat module name
local PRAT_MODULE = Prat:RequestModuleName("PratChatFrames")

if PRAT_MODULE == nil then 
    return 
end

-- define localized strings
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["Frames"] = true,
    ["Chat window frame parameter options."] = true,
    ["minchatwidth_name"] = "Set Minimum Width",
    ["minchatwidth_desc"] = "Sets the minimum width for all chat windows.",
    ["maxchatwidth_name"] = "Set Maximum Width",
    ["maxchatwidth_desc"] = "Sets the maximum width for all chat windows.",
    ["minchatheight_name"] = "Set Minimum Height",
    ["minchatheight_desc"] = "Sets the minimum height for all chat windows.",
    ["maxchatheight_name"] = "Set Maximum Height",
    ["maxchatheight_desc"] = "Sets the maximum height for all chat windows.",
    ["mainchatonload_name"] = "Force Main Chat Frame On Load",
    ["mainchatonload_desc"] = "Automatically select the first chat frame and make it active on load.",
    ["framealpha_name"] = "Alpha Threshold",
    ["framealpha_desc"] = "Sets the 'faded-in' alpha for all chatframes. If the current chat frame has an alpha value which is lower, it will be 'faded-in' when you hover over it with your mouse",    
    ["Lock the Pet Action Bar"] = true,
    ["Lock the Pet Action Bar and show it if not in combat. THIS SETTING IS NOT SAVED"] = true,
    ["WARNING: "] = true,
    ["Your pet action bar has become tainted. Enable the "] = true,
    ["'Lock the Pet Action Bar'"] = true,
    [" option in the "] = true,
    ["ChatFrames"] = true,
    [" module, or "] = true,
    ["/rl"] = true,
    [" to reload your UI"] = true,
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["Frames"] = "Chatfenster",
    ["Chat window frame parameter options."] = "Chatfenster Optionen.",
    ["minchatwidth_name"] = "Minimum Breite einstellen",
    ["minchatwidth_desc"] = "Setzt die minimum Breite f\195\188r alle Chatfenster fest.",
    ["maxchatwidth_name"] = "Maximum Breite einstellen",
    ["maxchatwidth_desc"] = "Setzt die maximum Breite f\195\188r alle  Chatfenster fest.",
    ["minchatheight_name"] = "Minimum H\195\182he einstellen",
    ["minchatheight_desc"] = "Setzt die minimum H\195\182he f\195\188r alle Chatfenster fest.",
    ["maxchatheight_name"] = "Maximum H\195\182he einstellen",
    ["maxchatheight_desc"] = "Setzt die maximum H\195\182he f\195\188r alle Chatfenster fest.",
    ["mainchatonload_name"] = "W\195\164hle Allgemein Chatfenster beim Laden",
    ["mainchatonload_desc"] = "Automatisch das erste Chatfenster beim Laden  ausw\195\164hlen und es als aktives setzen.",
    ["Lock the Pet Action Bar"] = "Sperre die Begleiter Tastenleiste",
    ["Lock the Pet Action Bar and show it if not in combat. THIS SETTING IS NOT SAVED"] = "Sperre die Begleiter Tastenleiste und zeige sie wenn man nicht im Kampf ist. DIESE EINSTELLUNG WIRD NICHT GESPEICHERT",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["Frames"] = "Fen\195\170tres",
    ["Chat window frame parameter options."] = "Options des fen\195\170tres de chat.",
    ["minchatwidth_name"] = "D\195\169finir la largeur minimum",
    ["minchatwidth_desc"] = "D\195\169finit la largeur minimale de toutes les fen\195\170tres de chat.",
    ["maxchatwidth_name"] = "D\195\169finir la largeur maximum",
    ["maxchatwidth_desc"] = "D\195\169finit la largeur maximale de toutes les fen\195\170tres de chat.",
    ["minchatheight_name"] = "D\195\169finir la largeur minimum",
    ["minchatheight_desc"] = "D\195\169finit la hauteur minimale de toutes les fen\195\170tres de chat.",
    ["maxchatheight_name"] = "D\195\169finir la largeur maximum",
    ["maxchatheight_desc"] = "D\195\169finit la hauteur maximale de toutes les fen\195\170tres de chat.",
    ["mainchatonload_name"] = "Forcer la fen\195\170tre principale au chargement",
    ["mainchatonload_desc"] = "S\195\169lectionne automatiquement le premier onglet et le rend actif au chargement.",
    ["Lock the Pet Action Bar"] = "Verrouiller la barre d'action du familier",
    ["Lock the Pet Action Bar and show it if not in combat. THIS SETTING IS NOT SAVED"] = "Verrouille la barre d'action du familier et l'affiche si hors combat. CE REGLAGE N'EST PAS SAUVE",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["Frames"] = "Ventanas de Chat",
    ["Chat window frame parameter options."] = "Opciones de los par\195\161metros de las ventanas de chat",
    ["minchatwidth_name"] = "Anchura m\195\173nima",
    ["minchatwidth_desc"] = "Establece la anchura m\195\173nima de las ventanas de chat",
    ["maxchatwidth_name"] = "Anchura m\195\161xima",
    ["maxchatwidth_desc"] = "Establece la anchura m\195\161xima de las ventanas de chat",
    ["minchatheight_name"] = "Altura m\195\173nima",
    ["minchatheight_desc"] = "Establece la altura m\195\173nima de las ventanas de chat",
    ["maxchatheight_name"] = "Altura m\195\161xima",
    ["maxchatheight_desc"] = "Establece la altura m\195\161xima de las ventanas de chat",
    ["mainchatonload_name"] = "Forzar Ventana de Chat Principal al Cargar",
    ["mainchatonload_desc"] = "Elige autom\195\161ticamente la primera ventana de chat y la hace activa al cargar",
    ["Lock the Pet Action Bar"] = "Bloquear la barra de acciones de la mascota",
    ["Lock the Pet Action Bar and show it if not in combat. THIS SETTING IS NOT SAVED"] = "Bloquea la barra de acciones de la mascota y la muestra si no est\195\161s en combate. ESTA OPCI\195\147N NO SER\195\129 GUARDADA",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["Frames"] = "대화창",
    ["Chat window frame parameter options."] = "대화창 제한 설정입니다.",
    ["minchatwidth_name"] = "최소 넓이 설정",
    ["minchatwidth_desc"] = "대화창의 최소 넓이를 설정합니다.",
    ["maxchatwidth_name"] = "최대 넓이 설정",
    ["maxchatwidth_desc"] = "대화창의 최대 넓이를 설정합니다.",
    ["minchatheight_name"] = "최소 높이 설정",
    ["minchatheight_desc"] = "대화창의 최소 높이를 설정합니다.",
    ["maxchatheight_name"] = "최대 높이 설정",
    ["maxchatheight_desc"] = "대화창의 최대 높이를 설정합니다.",
    ["mainchatonload_name"] = "접속 시 주 대화창 강제 지정",
    ["mainchatonload_desc"] = "접속 시 첫번째 대화창을 주 대화창으로 자동으로 선택합니다.",
    ["framealpha_name"] = "투명도 제한선",
    ["framealpha_desc"] = "모든 대화창의 '페이드-인' 투명도를 설정합니다. 만약 현재 대화창이 낮은 투명도로 설정되어 있다면, 마우스를 올렸을 때 '페이드-인' 될 것 입니다.",
    ["Lock the Pet Action Bar"] = "소황수 행동 바 고정",
    ["Lock the Pet Action Bar and show it if not in combat. THIS SETTING IS NOT SAVED"] = "소환수 행동바를 고정하고 전투 중이 아닐 때 표시합니다. 이 설정은 저장되지 않습니다.",
    ["WARNING: "] = "경고: ",
    ["Your pet action bar has become tainted. Enable the "] = "Your pet action bar has become tainted. Enable the ",
    ["'Lock the Pet Action Bar'"] = "'Lock the Pet Action Bar'",
    [" option in the "] = " option in the ",
    ["ChatFrames"] = "대화창",
    [" module, or "] = " module, or ",
    ["/rl"] = "/rl",
    [" to reload your UI"] = " to reload your UI",
} end)

--Chinese Translation: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["Frames"] = "聊天框架",
    ["Chat window frame parameter options."] = "聊天框架设置选项.",
    ["minchatwidth_name"] = "设定最小宽度值",
    ["minchatwidth_desc"] = "对所有聊天窗口设定最小宽度值",
    ["maxchatwidth_name"] = "设定最大宽度值",
    ["maxchatwidth_desc"] = "对所有聊天窗口设定最大宽度值",
    ["minchatheight_name"] = "设定最小高度值",
    ["minchatheight_desc"] = "对所有聊天窗口设定最小高度值",
    ["maxchatheight_name"] = "设定最大高度值",
    ["maxchatheight_desc"] = "对所有聊天窗口设定最大高度值",
    ["mainchatonload_name"] = "强制使用主聊天窗口",
    ["mainchatonload_desc"] = "自动选择第一聊天窗口并加载.",
    ["framealpha_name"] = "透明度",
    ["framealpha_desc"] = "设置所有聊天窗口‘淡入’的透明度。若当前的聊天窗口本有较低的透明度值，鼠标停留时会有‘淡入’效果",    
    ["Lock the Pet Action Bar"] = "锁定宠物动作条",
    ["Lock the Pet Action Bar and show it if not in combat. THIS SETTING IS NOT SAVED"] = "锁定宠物动作条并在非战斗装都显示. !!此设置不能保存!!",
    ["WARNING: "] = "警告: ",
    ["Your pet action bar has become tainted. Enable the "] = "宠物动作条有问题。请启用。",
    ["'Lock the Pet Action Bar'"] = "「锁定宠物动作条」",
    [" option in the "] = "选项 (在",
    ["ChatFrames"] = "聊天窗口",
    [" module, or "] = "模块)，或 ",
    ["/rl"] = "/rl",
    [" to reload your UI"] = " 重载你的使用界面。",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["Frames"] = "聊天視窗",
    ["Chat window frame parameter options."] = "聊天視窗設定選項。",
    ["minchatwidth_name"] = "設定寬度最小值",
    ["minchatwidth_desc"] = "設定全部聊天視窗的寬度最小值。",
    ["maxchatwidth_name"] = "設定寬度最大值",
    ["maxchatwidth_desc"] = "設定全部聊天視窗的寬度最大值。",
    ["minchatheight_name"] = "設定高度最小值",
    ["minchatheight_desc"] = "設定全部聊天視窗的高度最小值。",
    ["maxchatheight_name"] = "設定高度最大值",
    ["maxchatheight_desc"] = "設定全部聊天視窗的高度最大值。",
    ["mainchatonload_name"] = "載入時強制啟用聊天視窗1",
    ["mainchatonload_desc"] = "自動選擇聊天視窗1並啟用。",
    ["framealpha_name"] = "透明度",
    ["framealpha_desc"] = "設定所有聊天視窗的「淡入」透明度。若當前的聊天視窗有較低的透明度值，滑鼠停留時會有「淡入」效果。",    
    ["Lock the Pet Action Bar"] = "鎖定寵物動作條",
    ["Lock the Pet Action Bar and show it if not in combat. THIS SETTING IS NOT SAVED"] = "鎖定寵物動作條並在非戰鬥狀態時顯示。不會儲存此設定!",
    ["WARNING: "] = "警告: ",
    ["Your pet action bar has become tainted. Enable the "] = "寵物動作條有問題。請啟用",
    ["'Lock the Pet Action Bar'"] = "「鎖定寵物動作條」",
    [" option in the "] = "選項 (在",
    ["ChatFrames"] = "聊天視窗",
    [" module, or "] = "模組)，或 ",
    ["/rl"] = "/rl",
    [" to reload your UI"] = " 重載你的使用者介面。",
} end)



-- create prat module
Prat_ChatFrames = Prat:NewModule(PRAT_MODULE, LIB.HOOKS)
local Prat_ChatFrames = Prat_ChatFrames
Prat_ChatFrames.pratModuleName = PRAT_MODULE
Prat_ChatFrames.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

-- define key module values
Prat_ChatFrames.moduleName = L["Frames"]
Prat_ChatFrames.moduleDesc = L["Chat window frame parameter options."]
Prat_ChatFrames.consoleName = "chatframes"
Prat_ChatFrames.guiName = L["Frames"]


-- define the default db values
Prat_ChatFrames.defaultDB = {
        on = true,
        initialized = false,
        minchatwidth = 160,
        minchatwidthdefault = 160,
        maxchatwidth = 800,
        maxchatwidthdefault = 800,
        minchatheight = 120,
        minchatheightdefault = 120,
        maxchatheight = 600,
        maxchatheightdefault = 600,
        mainchatonload = true,
        framealpha = DEFAULT_CHATFRAME_ALPHA
}

-- create a moduleOptions stub (for setting self.moduleOptions)
Prat_ChatFrames.moduleOptions = {}

-- build the options menu using prat templates
Prat_ChatFrames.toggleOptions = {
    minchatwidth = {type="range", min=25, max=1024, step=1, order=150},
    maxchatwidth = {type="range", min=25, max=1024, step=1, order=160},
    sep165_sep = 165,
    minchatheight = {type="range", min=15, max=1280, step=1, order=170},
    maxchatheight = {type="range", min=15, max=1280, step=1, order=180},
    sep185_sep = 185,
    framealpha = {type="range", min=0.0, max=1.0, step=.01, order=190},
    sep195_sep = 195,
    mainchatonload = 200,
}

-- add module options not covered by templates
function Prat_ChatFrames:GetModuleOptions()
    self.moduleOptions = {
        name = L["Frames"],
        desc = L["Chat window frame parameter options."],
        type = "group",
        args = {
            lockPetBar = {
                name = L["Lock the Pet Action Bar"],
                desc = L["Lock the Pet Action Bar and show it if not in combat. THIS SETTING IS NOT SAVED"],
                type = "toggle",
                get = function() return  Prat_ChatFrames:IsHooked("UnlockPetActionBar")  end,
                set = function(v) return Prat_ChatFrames:LockPetActionBar(v) end,
                disabled = function() return InCombatLockdown() end,
                order = 300,
            },
        }
    }
    
    self:InjectModulePassOptions(self.moduleOptions)
    return self.moduleOptions
end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--

-- things to do when the module is enabled
function Prat_ChatFrames:OnModuleInit()
    if not self.db.profile.initialized then
        self:GetDefaults()
    end
end

-- things to do when the module is enabled
function Prat_ChatFrames:OnModuleEnable()
    self[LIB.REGISTEREVENT](self, "AceEvent_FullyInitialized")

    self:ConfigureAllChatFrames()
end

-- things to do when the module is enabled
function Prat_ChatFrames:OnModuleDisable()
    self:ConfigureAllChatFrames()
    -- unregister events
    self:UnregisterAllEvents()
end

--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--

-- make ChatFrame1 the selected chat frame
function Prat_ChatFrames:AceEvent_FullyInitialized()
    if self.db.profile.mainchatonload then
        FCF_SelectDockFrame(ChatFrame1)
    end
end

-- set parameters for each chatframe
function Prat_ChatFrames:ConfigureAllChatFrames()
    for i = 1,NUM_CHAT_WINDOWS do
        self:SetParameters(i, self.db.profile.on)
    end
    
    DEFAULT_CHATFRAME_ALPHA = self.db.profile.framealpha
end

-- get the defaults for chat frame1 max/min width/height for use when disabling the module
function Prat_ChatFrames:GetDefaults()
    local cf = getglobal("ChatFrame1")
    local minwidthdefault, minheightdefault = cf:GetMinResize()
    local maxwidthdefault, maxheightdefault = cf:GetMaxResize()
    self.db.profile.minchatwidthdefault = defaultminwidth
    self.db.profile.maxchatwidthdefault = defaultmaxwidth
    self.db.profile.minchatheightdefault = defaultminheight
    self.db.profile.maxchatheightdefault = defaultmaxheight
    self.db.profile.initialized = true
end

-- set the max/min width/height for a chatframe
function Prat_ChatFrames:SetParameters(id,enabled)
    local cf = getglobal("ChatFrame"..id)
    if enabled then
        cf:SetMinResize(self.db.profile.minchatwidth,self.db.profile.minchatheight)
        cf:SetMaxResize(self.db.profile.maxchatwidth,self.db.profile.maxchatheight)
    else
        cf:SetMinResize(self.db.profile.minchatwidthdefault,self.db.profile.minchatheightdefault)
        cf:SetMaxResize(self.db.profile.maxchatwidthdefault,self.db.profile.maxchatheightdefault)
    end
end


function Prat_ChatFrames:OnModuleSetOption(name, val)
    self:ConfigureAllChatFrames()
end

