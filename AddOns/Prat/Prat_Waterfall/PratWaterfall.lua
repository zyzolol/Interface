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

if Prat_Waterfall then return end

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

-- Framework abstractions
local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY


local dewdrop = LIB.DROPDOWNMENU and PRAT_LIBRARY:HasInstance(LIB.DROPDOWNMENU, false) and PRAT_LIBRARY(LIB.DROPDOWNMENU)
local WATERFALL_ID = "Prat"

local function unpack_parms(t, i)
	local k,v = next(t, i)
	if not k then return end
	return k, v, unpack_parms(t, k)
end


local PRAT_MODULE = "PratWaterfall"

local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[LIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["Waterfall Config"] = true,
    ["Opens the Waterfall Config window"] = true,
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["Waterfall Config"] = "Waterfall Konfig",
    ["Opens the Waterfall Config window"] = "Öffnet das 'Waterfall' Konfigurationsfenster.",
} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["Waterfall Config"] = "Waterfall 설정",
    ["Opens the Waterfall Config window"] = "Waterfall 설정창을 엽니다",
} end)

--Chinese Translation: 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L[LIB.NEWLOCALE](L, "zhCN", function() return {
    ["Waterfall Config"] = "Waterfall 设置",
    ["Opens the Waterfall Config window"] = "打开 Waterfall 设置窗口",
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["Waterfall Config"] = "Waterfall 設定選單",
    ["Opens the Waterfall Config window"] = "打開 Waterfall 圖形用戶介面設定選單",
} end)


local Mixins = {LIB.EVENTS,
				LIB.DATASTORE}
                 
if LIB.FIRSTMIXIN then 
	table.insert(Mixins, 1, PRAT_MODULE)
end

if LIB.DEBUG then 
	table.insert(Mixins, LIB.DEBUG)
end

local base = PRAT_LIBRARY(LIB.BASE)
PratWaterfall = base[LIB.NEW](base, unpack(Mixins))

PratWaterfall[LIB.NEWDATABASE](PratWaterfall, "PratWaterfallDB")

PratWaterfall.W	= function() return PRAT_LIBRARY:HasInstance(LIB.WINDOWMENU, false) and  PRAT_LIBRARY(LIB.WINDOWMENU) end

function PratWaterfall:RegisterWaterfall()
	local WaterfallOpts
	local p = Prat.db.profile
	
	dewdrop = dewdrop or (LIB.DROPDOWNMENU and PRAT_LIBRARY:HasInstance(LIB.DROPDOWNMENU, false) and PRAT_LIBRARY(LIB.DROPDOWNMENU))

	Prat.Options.args.Waterfall = {
		name = L["Waterfall Config"],
		type = "execute",
		order = 340,
		handler = PratWaterfall,
		wfHidden = true,
		desc = L["Opens the Waterfall Config window"],
		func = "Toggle",
		disabled = "~IsActive"
		}

	Prat.ConsoleOptions.args.menu = {
		name = L["Waterfall Config"],
		type = "execute",
		handler = PratWaterfall,
		wfHidden = true,
		desc = L["Opens the Waterfall Config window"],
		func = "Toggle",
		disabled = "~IsActive"
		}

	WaterfallOpts = {
		aceOptions = Prat.ConsoleOptions,
		treeType = 'TREE',
		colorR = 0.5,
		colorG = 0.5,
		colorB = 1.0,
		treeLevels = 3,
		}

    local W = PratWaterfall.W()
	return W and W:Register(WATERFALL_ID, unpack_parms(WaterfallOpts))
end

function PratWaterfall:OnInitialize()
	self[LIB.REGISTEREVENT](self, "Prat_Ready")
end

function PratWaterfall:Prat_Ready()
    local W = PratWaterfall.W()
    if not W then
        self[LIB.REGISTEREVENT](self, "ADDON_LOADED");
    else
    	self:RegisterWaterfall()
    
    	self[LIB.REGISTEREVENT](self, "Prat_ModuleDisabled", "ModuleUpdate")
    	self[LIB.REGISTEREVENT](self, "Prat_ModuleEnabled", "ModuleUpdate")
    end
end

function PratWaterfall:ModuleUpdate()
	local W = PratWaterfall.W()
    
	return W and W:Refresh(WATERFALL_ID)
end

function PratWaterfall:Open()
	local W = PratWaterfall.W()

	return W and W:Open('Prat')
end

function PratWaterfall:Close()
	local W = PratWaterfall.W()

	return W and W:Close('Prat')
end

function PratWaterfall:ADDON_LOADED()
    local W = PratWaterfall.W()
    if W then 
        self[LIB.UNREGISTEREVENT](self, "ADDON_LOADED")
        self:Prat_Ready()
    end
end

function PratWaterfall:Toggle()
	local W		= PRAT_LIBRARY:HasInstance(LIB.WINDOWMENU) and PRAT_LIBRARY(LIB.WINDOWMENU)
	local open	= W and W:IsOpen('Prat')

    if dewdrop then 
        dewdrop:Close()
    end

	if open then
		self:Close('Prat')
	else
		self:Open('Prat')
	end
end
