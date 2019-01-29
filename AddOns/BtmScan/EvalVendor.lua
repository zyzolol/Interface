--[[
	BottomScanner - An AddOn for WoW to alert you to good purchases as they appear on the AH
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: EvalVendor.lua 3502 2008-09-17 18:03:11Z root $
	URL: http://auctioneeraddon.com/dl/BottomScanner/
	Copyright (c) 2006, Norganna

	This is a module for BtmScan to evaluate an item for purchase.

	If you wish to make your own module, do the following:
	 -  Make a copy of the supplied "EvalTemplate.lua" file.
	 -  Rename your copy to a name of your choosing.
	 -  Edit your copy to do your own valuations of the item.
	      (search for the "TODO" sections in the file)
	 -  Insert your new file's name into the "BtmScan.toc" file.
	 -  Optionally, put it up on the wiki at:
	      http://norganna.org/wiki/BottomScanner/Evaluators

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

local libName = "Vendor"
local lcName = libName:lower()
local lib = { name = lcName, propername = libName }
table.insert(BtmScan.evaluators, lcName)
local define = BtmScan.Settings.SetDefault
local get = BtmScan.Settings.GetSetting
local set = BtmScan.Settings.SetSetting

BtmScan.evaluators[lcName] = lib

function lib:valuate(item, tooltip)
	local price = 0

	-- If we're not enabled, scadaddle!
	if (not get(lcName..".enable")) then return end

	-- Valuate this item
	local pct = get(lcName..".profit.pct")
	local min = get(lcName..".profit.min")
	local vendor = GetSellValue and GetSellValue(item.id) or 0
	-- If there's no price, then we obviously can't sell it, ignore!
	if not vendor or vendor == 0 then return end
	vendor = vendor * item.count
	item:info("Vendor price", vendor)

	-- Mark it down
	local value, mkdown = BtmScan.Markdown(vendor, pct, min)
	item:info((" - %d%% / %s markdown"):format(pct,BtmScan.GSC(min, true)), mkdown)

	-- Check for tooltip evaluation
	if (tooltip) then
		item.what = self.name
		item.valuation = value
		if (item.bid == 0) then
			return
		end
	end

	-- If the current purchase price is more than our valuation,
	-- another module "wins" this purchase.
	if (value < item.purchase) then return end

	-- Check to see what the most we can pay for this item is.
	if (item.canbuy and get(lcName..".allow.buy") and item.buy < value) then
		price = item.buy
	elseif (item.canbid and get(lcName..".allow.bid") and item.bid < value) then
		price = item.bid
	end

	-- Check our projected profit level
	local profit = 0
	if price > 0 then profit = value - price end

	-- If what we are willing to pay for this item beats what
	-- other modules are willing to pay, and we can make more
	-- profit, then we "win".
	if (price >= item.purchase and profit > item.profit) then
		item.purchase = price
		item.reason = self.name
		item.what = self.name
		item.profit = profit
		item.valuation = vendor
	end
end

define(lcName..'.enable', true)
define(lcName..'.profit.min', 20)
define(lcName..'.profit.pct', 0)
define(lcName..'.allow.bid', true)
define(lcName..'.allow.buy', true)
function lib:setup(gui)
	local id = gui:AddTab(libName)
	
	gui:AddHelp(id, "what is the vendor evaluator",
		"What is the Vendor evaluator?",
		"This evaluator allows you to purchase items that can be sold to a vendor for more than you pay for it based on your settings here.\n\n"..
		""..
		"General Settings: This section allows you to configure if the evaluator is enabled and if it is enabled, if you only want to allow it to bid or buyout an item for selling to a vendor.\n\n"..
		""..
		"Profit Settings: Minimum profit(discount from mat value) % and fixed $ amounts both must be met in order to allow an item to be purchased for this evaluator based on your settings here.\n\n"..
		""..
		"\n")
		
	gui:AddControl(id, "Subhead",          0,    libName.." General Settings")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".enable", "Enable purchasing for "..lcName)
	gui:AddControl(id, "Checkbox",         0, 2, lcName..".allow.buy", "Allow buyout on items")
	gui:AddControl(id, "Checkbox",         0, 2, lcName..".allow.bid", "Allow bid on items")

	gui:AddControl(id, "Subhead",          0,    "Profit Settings")
	gui:AddControl(id, "MoneyFramePinned", 0, 1, lcName..".profit.min", 1, 99999999, "Minimum Profit")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".profit.pct", 1, 100, 0.5, "Minimum Discount: %0.01f%%")
end
