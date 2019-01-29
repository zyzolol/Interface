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
-- Gotta have Prat
if not Prat then return end

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

-- Framework abstractions
local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY



if not PRAT_LIBRARY:HasInstance(LIB.BARMENU) then return end

local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[LIB.NEWLOCALENAMESPACE](loc, "PratFu")

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["Prat"] = true,
    ["Fubar Options"] = true,
    ["FuBar"] = true,
    ["minimap"] = true,
    ["Minimap"] = true,
    ["Toggle the minimap button."] = true,
    ["Show it again with /prat minimap."] = true,
    ["%s icon is now %s."] = true,
    ["hidden"] = true,
    ["shown"] = true,
    ["The standard FuBar options."] = true,
    ["FuBar Options"] = true,
    ['Prat - a framework for chat addons'] = true,
    ['|cffffff00Left-Click|r to open the Waterfall configuration menu'] = true,
}end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["Prat"] = "Prat",
    ["Fubar Options"] = "Fubar 설정",
    ["FuBar"] = "Fubar",
--    ["minimap"] = true,
    ["Minimap"] = "미니맵",
    ["Toggle the minimap button."] = "미니맵 버튼 켜고/끄기",
    ["Show it again with /prat minimap."] = "/prat minimap 명령으로 미니맵 아이콘을 다시 표시할 수 있습니다.",
    ["%s icon is now %s."] = "%s 아이콘 : %s",
    ["hidden"] = "숨김",
    ["shown"] = "표시",
    ["The standard FuBar options."] = "기본 FuBar 설정입니다.",
    ["FuBar Options"] = "FuBar 설정",
    ['Prat - a framework for chat addons'] = "Prat - 대화창 애드온 구성",
    ['|cffffff00Left-Click|r to open the Waterfall configuration menu'] = "Waterfall 환경설정 메뉴를 열려면 |cffffff00좌-클릭|r하세요.",
} end)

--Chinese Translate: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["Prat"] = "Prat",
    ["Fubar Options"] = "FuBar 设置",
    ["FuBar"] = "FuBar",
    ["minimap"] = "小地图",
    ["Minimap"] = "小地图",
    ["Toggle the minimap button."] = "显示小地图按钮",
    ["Show it again with /prat minimap."] = "若需在小地图显示请输入/prat minimap",
    ["%s icon is now %s."] = "%s标记当前为%s.",
    ["hidden"] = "隐藏",
    ["shown"] = "显示",
    ["The standard FuBar options."] = "标准 FuBar 设置",
    ["FuBar Options"] = "FuBar 设置",
    ['Prat - a framework for chat addons'] = "Prat - 聊天框架插件模块",
    ['|cffffff00Left-Click|r to open the Waterfall configuration menu'] = "|cffffff00左击|r打开 Waterfall 设置目录",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["Prat"] = "Prat",
    ["Fubar Options"] = "FuBar Optionsmen\195\188",
    ["FuBar"] = "FuBar",
    ["minimap"] = "minimap",
    ["Minimap"] = "Minimap",
    ["Toggle the minimap button."] = "Aktiviere die Minimap Taste.",
    ["Show it again with /prat minimap."] = "Zeige es wieder mit /prat minimap.",
    ["%s icon is now %s."] = "%s Symbol ist nun %s.",
    ["hidden"] = "versteckt",
    ["shown"] = "sichtbar",
    ["The standard FuBar options."] = "Die Standart FuBar Optionen.",
    ["FuBar Options"] = "FuBar Optionen",
    ['|cffffff00Left-Click|r to open the Waterfall configuration menu'] = '|cffffff00Links-Klick|r um das Waterfall Konfigurationsmenü zu öffnen.',
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["Prat"] = "Prat",
    ["Fubar Options"] = "Menu d'options",
    ["FuBar"] = "FuBar",
    ["minimap"] = "mini-carte",
    ["Minimap"] = "Mini-carte",
    ["Toggle the minimap button."] = "Activer/d\195\169sactiver le bouton sur la mini-carte.",
    ["Show it again with /prat minimap."] = "Affichez le de nouveau avec /prat minimap.",
    ["%s icon is now %s."] = "L'ic\195\180ne %s est maintenant %s.",
    ["hidden"] = "cach\195\169e",
    ["shown"] = "affich\195\169e",
    ["The standard FuBar options."] = "Les options standard de FuBar.",
    ["FuBar Options"] = "Options de FuBar",
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["Prat"] = "Prat",
    ["Fubar Options"] = "Men\195\186 de Opciones",
    ["FuBar"] = "FuBar",
    ["minimap"] = "minimapa",
    ["Minimap"] = "Minimapa",
    ["Toggle the minimap button."] = "Determina si se activa el bot\195\179n del minimapa",
    ["Show it again with /prat minimap."] = "Mu\195\169stralo de nuevo con /prat minimap",
    ["%s icon is now %s."] = "El icono de %s es ahora %s.",
    ["hidden"] = "oculto",
    ["shown"] = "mostrado",
    ["The standard FuBar options."] = "Las opciones est\195\161ndar de FuBar",
    ["FuBar Options"] = "Opciones de FuBar",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["Prat"] = "Prat",
    ["Fubar Options"] = "FuBar 選項",
    ["FuBar"] = "FuBar",
-- no use anymore    ["minimap"] = true,
    ["Minimap"] = "小地圖",
    ["Toggle the minimap button."] = "顯示小地圖按鈕。",
    ["Show it again with /prat minimap."] = "/prat minimap 再次顯示小地圖按鈕。",
    ["%s icon is now %s."] = "%s按鈕: %s",
    ["hidden"] = "隱藏",
    ["shown"] = "顯示",
-- no use anymore    ["The standard FuBar options."] = true,
-- no use anymore    ["FuBar Options"] = true,
    ['Prat - a framework for chat addons'] = "\nPrat - 整合的聊天視窗模組",
    ['|cffffff00Left-Click|r to open the Waterfall configuration menu'] = "|cffeda55f左擊: |r打開 Waterfall 圖形用戶介面設定選單。",
}end)


local Mixins = {LIB.DATASTORE, 
                LIB.EVENTS, 
                LIB.BARMENU}
                 
if LIB.FIRSTMIXIN then 
	table.insert(Mixins, 1, "PratFu")
end

if LIB.DEBUG then 
	table.insert(Mixins, LIB.DEBUG)
end

local base = PRAT_LIBRARY(LIB.BASE)
PratFu = base[LIB.NEW](base, unpack(Mixins))


PratFu[LIB.NEWDATABASE](PratFu, "PratFuDB")

PratFu.title			= L["Prat"]
PratFu.name			= L["FuBar"].." - "..L["Prat"]
PratFu.category			= 'Chat/Communication'
PratFu.hasIcon			= "Interface\\Addons\\Prat\\textures\\chat-bubble"
PratFu.cannotDetachTooltip	= true
PratFu.hideWithoutStandby	= true
PratFu.waterfallavailable	= PRAT_LIBRARY:HasInstance(PRATLIB.WINDOWMENU)
PratFu.OnMenuRequest		= Prat.Options
PratFu.defaultPosition		= 'CENTER'
PratFu.hideMenuTitle		= true
PratFu.hasNoColor		= true



local PRAT_MODULE = "minimap"
--
-- Code from bigwigs can be used to provide a console command)
local mm = Prat:NewModule(Prat:RequestModuleName(PRAT_MODULE))
mm.pratModuleName = PRAT_MODULE

mm.moduleHidden	= true
mm.hasFuBar	= IsAddOnLoaded("FuBar") and FuBar

function mm:GetModuleOptions()
	-- module options heeyah
	self.moduleOptions = not mm.hasFuBar and {
	
	    args = {
		toggleminimap = {
			type	= "toggle",
			name	= L["Minimap"],
			desc	= L["Toggle the minimap button."],
			get	= function() return PratFu.minimapFrame and PratFu.minimapFrame:IsVisible() or false end,
			set = function(v)
				if v then
					PratFu:Show()
				else
					PratFu:Hide()
					Prat:Print(L["Show it again with /prat minimap."])
				end
			end,

			map = {[false] = L["hidden"], [true] = L["shown"]},
			message = L["%s icon is now %s."],		
			},

		toggleicon = {
			type	= 'toggle',
			name	= 'Icon',
			desc	= 'Toggle the FuBar icon',
			get	= function() return PratFu:IsIconShown() end,
			set	= function() return PratFu:ToggleIconShown() end,
			},

		toggletext = {
			type	= 'toggle',
			name	= 'Text',
			desc	= 'Toggle the FuBar title',
			get	= function() return PratFu:IsTextShown() end,
			set	= function() return PratFu:ToggleTextShown() end,
			},
			},
			
			hidden = function() return mm.hasFuBar end,
			disabled = false
			
		}

	return self.moduleOptions
end

if PratFu.waterfallavailable then
	local W = PRAT_LIBRARY(PRATLIB.WINDOWMENU)
end

local clrstr = function(str, type)
	str = str or ''

	return CLR:Colorize(Prat.Colors.type, str)
end

local clrpratversion = function(ver)
	return clrstr(ver, 'VERSION2')
end

local clrdebugging = function(str)
	return clrstr(str, 'DEBUGGING')
end

local clrprofiling = function(str)
	return clrstr(str, 'PROFILING')
end

function PratFu:OnTextUpdate()
	local title	= L['Prat']
	local space	= nil
	local tags	= {}

	-- check if we're debugging
	if Prat:IsDebugging() then
		table.insert(tags, clrdebugging('Debugging'))
	end

	-- check if we're profiling
	if Prat:IsProfiling() then
		table.insert(tags, clrprofiling('Profiling'))
	end

	-- build a string to append if needed
	local tagstr	= table.concat(tags, ', ')

	-- build the title
	title	= title .. clrpratversion('2.0') .. (#tags > 0 and (' - ' .. tagstr) or '')
	-- title = 'Prat v2.0'

	self:SetText(title)
end

local bar = PRAT_LIBRARY(PRATLIB.BARMENU)
local args = bar[LIB.FUBAROPTIONS](bar, PratFu)

if not PratFu.OnMenuRequest.args[L["Fubar Options"]] then
	PratFu.OnMenuRequest.args[L["Fubar Options"]] = {
		type = "group",
		name = L["Fubar Options"],
		desc = L["Fubar Options"],
		args = args,
		order = 340,
	}
end


function PratFu:OnEnable()
	self[LIB.REGISTEREVENT](self, "Prat_DebugModeChanged", "Update")
	self[LIB.REGISTEREVENT](self, "Prat_ModuleDisabled", "ModuleUpdate")
	self[LIB.REGISTEREVENT](self, "Prat_ModuleEnabled", "ModuleUpdate")

	if LIB.DEBUG then 
		self:SetDebugging(Prat:IsDebugging())
	end
end

local dewdrop = LIB.DROPDOWNMENU and PRAT_LIBRARY(PRATLIB.DROPDOWNMENU)


function PratFu:ModuleUpdate()
	self:ScheduleEvent("PratFu_ModuleUpdate", self.ModuleUpdate2, 0.1, self)
end

function PratFu:ModuleUpdate2()
	if dewdrop then 
		dewdrop:Refresh(1)
	end
end


function PratFu:OnClick(button)
	if button == 'LeftButton' then
		if Prat:IsDebugging() and IsShiftKeyDown() then
			ReloadUI()
		elseif IsAltKeyDown() and IsControlKeyDown() then
			--util:print('|cff80ff80Fin|r says: |r|cffffb200drink more beer.|r This has been a PSA brought to you by the letter |cffff8080AWESOME|r.')
		elseif self.waterfallavailable and PratWaterfall then
			PratWaterfall:Toggle()
		end
	end
end

function PratFu:OnDebugEnable()
	if not Prat:IsDebugging() then
		Prat:SetDebugging(true)
	end
end

function PratFu:OnDebugDisable()
	Prat:SetDebugging(false)
end


local tablet =  PRAT_LIBRARY(PRATLIB.TOOLTIPS)

function PratFu:OnTooltipUpdate()
	local hint	= L['Prat - a framework for chat addons']

	if self.waterfallavailable then
		hint = hint .. "\n\n"
		hint = hint .. L['|cffffff00Left-Click|r to open the Waterfall configuration menu']
	end

	tablet:SetTitle(Prat.VERSION_STRING)
	tablet:SetHint(hint)

	--[[
	local cat	= tablet:AddCategory({ 'columns', 2 })

	cat:AddLine(
		'text',		'Version:',
		'text2',	'2.0',
		)

	cat:AddLine(
		'text',		'Credits:',
		'text2',	'Sylvanaar, Fin, Krtek, Curney, and others',
		)

	cat:AddLine(
		'text',		'Beer:',
		'text2',	'Good',
		)
	]]
end
