--[[
	BottomScanner - An AddOn for WoW to alert you to good purchases as they appear on the AH
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: FilterItemType.lua 2311 2007-10-09 15:10:00Z mentalpower $
	URL: http://auctioneeraddon.com/dl/BottomScanner/
	Copyright (c) 2006, Norganna

	This is a module for BtmScan to filter an item for purchase.

	If you wish to make your own module, do the following:
	 -  Make a copy of the supplied "EvalFilterTemplate.lua" file.
	 -  Rename your copy to a name of your choosing.
	 -  Edit your copy to do your own valuations of the item.
	      (search for the "TODO" sections in the file)
	 -  Insert your new file's name into the "BtmScan.toc" file.
	 -  Optionally, put it up on the wiki at:
	      http://norganna.org/wiki/BottomScanner/Filters

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit licence to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]

local libName = "IgnoreItemType"
local lcName = libName:lower()
local lib = { name = lcName, propername = libName }
table.insert(BtmScan.filters, lcName)
local define = BtmScan.Settings.SetDefault
local get = BtmScan.Settings.GetSetting
local set = BtmScan.Settings.SetSetting
local translate = BtmScan.Locales.Translate

BtmScan.filters[lcName] = lib

function lib:filterItem(item, evaluationModule)

	local price = 0
	local filterModule=false

	-- If we're not enabled, scadaddle!
	if (not get(lcName..".enable")) then return end

	if ( get(lcName..".filter."..evaluationModule)==false) then return end

	-- If this item is grey, forget about it.
	if (item.qual == 0) then return end

	local _, _, itemRarity, itemLevel, _, itemType  = GetItemInfo(item.id)

	if (not itemLevel) then return end
	if (not itemType) then return end
	local minLevel=0

	if (itemType==translate("Armor")) then
		minLevel = get(lcName..".armor.minlevel")
	elseif (itemType==translate("Weapon")) then
		minLevel = get(lcName..".weapon.minlevel")
	elseif (itemType==translate("")) then
		minLevel = get(lcName.."..minlevel")
	elseif (itemType==translate("Consumable")) then
		minLevel = get(lcName..".consumable.minlevel")
	elseif (itemType==translate("Container")) then
		minLevel = get(lcName..".container.minlevel")
	elseif (itemType==translate("Gem")) then
		minLevel = get(lcName..".gem.minlevel")
	elseif (itemType==translate("Key")) then
		minLevel = get(lcName..".key.minlevel")
	elseif (itemType==translate("Miscellaneous")) then
		minLevel = get(lcName..".miscellaneous.minlevel")
	elseif (itemType==translate("Reagent")) then
		minLevel = get(lcName..".reagent.minlevel")
	elseif (itemType==translate("Recipe")) then
		minLevel = get(lcName..".recipe.minlevel")
	elseif (itemType==translate("Projectile")) then
		minLevel = get(lcName..".projectile.minlevel")
	elseif (itemType==translate("Quest")) then
		minLevel = get(lcName..".quest.minlevel")
	elseif (itemType==translate("Quiver")) then
		minLevel = get(lcName..".quiver.minlevel")
	elseif (itemType==translate("Trade Goods")) then
		minLevel = get(lcName..".tradegoods.minlevel")
	end

	if (itemLevel < minLevel) then
--		BtmScan.Print(" filterd "..itemType.." level:"..tostring(itemLevel).." required:"..tostring(minLevel))
		-- module-filter ->
		filterModule=true
	end
	return filterModule
end

define(lcName..'.enable', false)

define(lcName..'.armor.minlevel', 61)

define(lcName..'.consumable.minlevel', 61)
define(lcName..'.container.minlevel', 61)
define(lcName..'.gem.minlevel', 61)
define(lcName..'.key.minlevel', 61)
define(lcName..'.miscellaneous.minlevel', 61)
define(lcName..'.reagent.minlevel', 61)
define(lcName..'.recipe.minlevel', 61)
define(lcName..'.projectile.minlevel', 61)
define(lcName..'.quest.minlevel', 61)
define(lcName..'.quiver.minlevel', 61)
define(lcName..'.tradegoods.minlevel', 61)
define(lcName..'.weapon.minlevel', 61)

function lib:setup(gui)
	id = gui:AddTab(libName)
	gui:AddControl(id, "Subhead",          0,    libName.." Settings")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".enable", "Enable basic-filtering")

	for pos, name in ipairs(BtmScan.evaluators) do
		if (name=="vendor") then
			define(lcName..".filter."..name, false)
		else
			define(lcName..".filter."..name, true)
		end
		gui:AddControl(id, "Checkbox",         0, 1, lcName..".filter."..name, " activate Filter for module:"..name)
	end

	gui:AddControl(id, "WideSlider",       0, 1, lcName..".armor.minlevel", 1, 140, 1, "Minimum Armor-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".consumable.minlevel", 1, 140, 1, "Minimum Consumable-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".container.minlevel", 1, 140, 1, "Minimum Container-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".gem.minlevel", 1, 140, 1, "Minimum Gem-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".miscellaneous.minlevel", 1, 140, 1, "Minimum Miscellaneous-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".reagent.minlevel", 1, 140, 1, "Minimum Reagent-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".recipe.minlevel", 1, 140, 1, "Minimum Recipe-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".projectile.minlevel", 1, 140, 1, "Minimum Projectile-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".quest.minlevel", 1, 140, 1, "Minimum Quest-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".quiver.minlevel", 1, 140, 1, "Minimum Quiver-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".tradegoods.minlevel", 1, 140, 1, "Minimum Trade Goods-ItemLevel: %s")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".weapon.minlevel", 1, 140, 1, "Minimum Weapon-ItemLevel: %s")

end
