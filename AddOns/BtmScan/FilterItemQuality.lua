--[[
	BottomScanner - An AddOn for WoW to alert you to good purchases as they appear on the AH
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: FilterItemQuality.lua 2311 2007-10-09 15:10:00Z rockslice $
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

local libName = "IgnoreItemQuality"
local lcName = libName:lower()
local lib = { name = lcName, propername = libName }
table.insert(BtmScan.filters, lcName)
local define = BtmScan.Settings.SetDefault
local get = BtmScan.Settings.GetSetting
local set = BtmScan.Settings.SetSetting
local translate = BtmScan.Locales.Translate

BtmScan.filters[lcName] = lib

local typename = {
	[1] = "Armor",
	[2] = "Consumable",
	[3] = "Container",
	[4] = "Gem",
	[5] = "Key",
	[6] = "Miscellaneous",
	[7] = "Reagent",
	[8] = "Recipe",
	[9] = "Projectile",
	[10] = "Quest",
	[11] = "Quiver",
	[12] = "Trade Goods",
	[13] = "Weapon",
}

local qualname = {
	[0] = "Poor",
	[1] = "Common",
	[2] = "Uncommon",
	[3] = "Rare",
	[4] = "Epic",
	[5] = "Legendary",
	[6] = "Artifact",
}

function lib:filterItem(item, evaluationModule)

	local price = 0
	local filterModule=false

	-- If we're not enabled, scadaddle!
	if (not get(lcName..".enable")) then return end

	if ( get(lcName..".filter."..evaluationModule)==false) then return end

	local _, _, itemQuality, _, _, itemType  = GetItemInfo(item.id)

	if (not itemType) then return end
	
	itemQuality = qualname[itemQuality]
	if (itemType==translate("Armor")) then
		itemType = "Armor"
	elseif (itemType==translate("Weapon")) then
		itemType = "Weapon"
	elseif (itemType==translate("Consumable")) then
		itemType = "Consumable"
	elseif (itemType==translate("Container")) then
		itemType = "Container"
	elseif (itemType==translate("Gem")) then
		itemType = "Gem"
	elseif (itemType==translate("Key")) then
		itemType = "Key"
	elseif (itemType==translate("Miscellaneous")) then
		itemType = "Miscellaneous"
	elseif (itemType==translate("Reagent")) then
		itemType = "Reagent"
	elseif (itemType==translate("Recipe")) then
		itemType = "Recipe"
	elseif (itemType==translate("Projectile")) then
		itemType = "Projectile"
	elseif (itemType==translate("Quest")) then
		itemType = "Quest"
	elseif (itemType==translate("Quiver")) then
		itemType = "Quiver"
	elseif (itemType==translate("Trade Goods")) then
		itemType = "Trade Goods"
	else return
	end
	--BtmScan.Print("testing "..lcName.."."..itemType.."."..itemQuality)
	filterModule = get(lcName.."."..itemType.."."..itemQuality)
	if filterModule then
		--BtmScan.Print(" filterd "..itemType.." q:"..itemQuality)
	end
	
	return filterModule
end

define(lcName..'.enable', false)

for i = 1, 13 do
	define(lcName.."."..typename[i]..".".."Poor", true)
end
function lib:setup(gui)
	local id = gui:AddTab(libName)
	gui:MakeScrollable(id)

	gui:AddControl(id, "Subhead",          0,    libName.." Settings")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".enable", "Enable quality-filtering")

	for pos, name in ipairs(BtmScan.evaluators) do
		if (name=="vendor") then
			define(lcName..".filter."..name, false)
		else
			define(lcName..".filter."..name, true)
		end
		gui:AddControl(id, "Checkbox",         0, 1, lcName..".filter."..name, " activate Filter for module:"..name)
	end

	gui:AddControl(id, "Subhead",          0,    "Item Quality by Type")
	for i = 0, 6 do
		local last = gui:GetLast(id)
		gui:AddControl(id, "Note", i*0.07, 1, 50, 20, qualname[i])--tostring(i) )
		if i < 6 then gui:SetLast(id, last) end
	end
	for i = 1, 13 do
		for j = 0, 6 do
		local last = gui:GetLast(id)
		gui:AddControl(id, "Checkbox", j*0.07+0.02, 1, lcName.."."..typename[i].."."..qualname[j], "")
		gui:AddTip(id, qualname[j].." "..typename[i])
		gui:SetLast(id, last)
		end
		gui:AddControl(id, "Note", 0.49, 1, 200, 20, typename[i])
	end
	
end
