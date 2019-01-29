--[[
	BottomScanner - An AddOn for WoW to alert you to good purchases as they appear on the AH
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: EvalProspect.lua 3481 2008-09-12 14:39:29Z anaral $
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

local libName = "Prospect"
local lcName = libName:lower()
local lib = { name = lcName, propername = libName }
table.insert(BtmScan.evaluators, lcName)
local define = BtmScan.Settings.SetDefault
local get = BtmScan.Settings.GetSetting
local set = BtmScan.Settings.SetSetting

BtmScan.evaluators[lcName] = lib

function lib:valuate(item, tooltip)
	local price = 0

	-- Bail immediately if we're not enabled
	if (not get(lcName..".enable")) then return end

	-- Can't do anything without Enchantrix
	if not (Enchantrix and Enchantrix.Storage) then return end

	-- All prospectable ores are "Common" quality
	if (item.qual ~= 1) then return end

	-- Give up if it doesn't prospect to anything
	local prospects = Enchantrix.Storage.GetItemProspects(item.link)
	if not prospects then return end

	-- Check if prospectable item is within our custom skill level range if enabled	
	local jcSkillRequired = Enchantrix.Util.JewelCraftSkillRequiredForItem(item.link)
	if (get(lcName..".level.custom")) then
		-- if jcSkillRequired is less than our custom minimum skill then we don't want it
		if (jcSkillRequired < get(lcName..".level.min")) then
			item:info("Fail:Prospect skill < Custom Min Skill")
			return
		end
		-- if jcSkillRequired is less than our custom minimum skill then we don't want it
		if (jcSkillRequired > get(lcName..".level.max")) then
			item:info("Fail:Prospect skill > Custom Max Skill")
			return
		end
	end
	
	-- Set up deposit/brokerage factors
	local useDeposit = get(lcName..'.adjust.deposit')
	local relistCount = get(lcName..'.adjust.listings')
	local useBroker = get(lcName..'.adjust.brokerage')
	local feesBasis = get(lcName..'.adjust.basis')
	local brokerRate, depositRate = 0.05, 0.05
	if (feesBasis == "neutral") then
		brokerRate, depositRate = 0.15, 0.25
	end

	-- Tally up value for each possible result
	local trashTotal, marketTotal, depositTotal, brokerTotal = 0, 0, 0, 0
	for result, yield in pairs(prospects) do
		-- adjust for stack size
		yield = yield * item.count / 5

		local _, _, quality = GetItemInfo(result)
		if quality == 0 then
			-- vendor trash (lower level powders)
			-- we need informant to get the vendor prices, if it is missing, use price of zero
			if Informant then
				local info = Informant.GetItem(result)
				if info and info.sell then
					trashTotal = trashTotal + info.sell * yield
				end
			end
		else
			-- gem or non-trashy powder
			local market, _, _, market5 = Enchantrix.Util.GetReagentPrice(result)
			-- if Auc4 price not available, use Auc5 market value
			-- also, use a zero value if no price is available (may happen for reagents you haven't seen)
			if (not market) then
				market = market5 or 0
			end
			local marketPrice = market * yield
			marketTotal = marketTotal + marketPrice

			-- calculate costs
			if (useDeposit) then
				depositTotal = depositTotal + BtmScan.GetDepositCost(result, 1, depositRate) * relistCount * yield
			end
			if (useBroker) then
				brokerTotal = brokerTotal + marketPrice * brokerRate
			end
		end
	end

	local resaleTotal = marketTotal - depositTotal - brokerTotal

	if tooltip then
		item:info("Market value", marketTotal)
		if depositTotal > 0 then item:info(" - " .. relistCount .. " x deposits", depositTotal) end
		if brokerTotal  > 0 then item:info(" - brokerage", brokerTotal) end
		if trashTotal   > 0 then item:info(" + vendor trash", trashTotal) end
	end

	local total = resaleTotal + trashTotal
	local pct = get(lcName..".profit.pct")
	local min = get(lcName..".profit.min")
	local value, mkdown = BtmScan.Markdown(total, pct, min)
	if tooltip then item:info((" - %d%% / %s markdown"):format(pct,BtmScan.GSC(min, true)), mkdown) end

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
		item.valuation = marketTotal + trashTotal
	end
end

local ahList = {
	{'faction', "Faction AH Fees"},
	{'neutral', "Neutral AH Fees"},
}

define(lcName..'.enable', true)
define(lcName..'.profit.min', 3000)
define(lcName..'.profit.pct', 30)
define(lcName..'.adjust.basis', "faction")
define(lcName..'.adjust.brokerage', true)
define(lcName..'.adjust.listings', 1)
define(lcName..'.allow.bid', true)
define(lcName..'.allow.buy', true)
define(lcName..'.level.custom', false)
define(lcName..'.level.min',0)
define(lcName..'.level.max', 375)

function lib:setup(gui)
	local id = gui:AddTab(libName)
	
	gui:AddHelp(id, "what is the prospect evaluator",
		"What is the Prospect evaluator?",
		"This evaluator allows you to purchase items that can be prospected (via the Jewel Crafting skill) into items that sell for more than the ore you are buying based on your settings.\n\n"..
		""..
		"General Settings: This section allows you to configure if the evaluator is enabled and if it is enabled, if you only want to allow it to bid or buyout ore for prospecting.\n\n"..
		""..
		"Custom Skill & Profit Settings: This section allows you to set your prospecting skill in order to avoid buying ores that you cannot prospect due to being outside of your desired prospecting skill range. Minimum profit(discount from mat value) % and fixed $ amounts both must be met in order to allow an item to be purchased for this evaluator based on your settings here.\n\n"..
		""..
		"Fee Adjustments: This section allows you to select if you want brokerage (AH cut) and/or deposit costs figured in when valuating an item to prospect. You may also select how many times you project having to re-list the mats before they will sell.\n\n"..
		""..
		"\n")
		
	gui:AddControl(id, "Subhead",          0,    libName.." General Settings")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".enable", "Enable purchasing for "..lcName)
	gui:AddControl(id, "Checkbox",         0, 2, lcName..".allow.buy", "Allow buyout on items")
	gui:AddControl(id, "Checkbox",         0, 2, lcName..".allow.bid", "Allow bid on items")
	
	gui:AddControl(id, "Subhead",          0,    "Custom Skill & Profit Settings")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".level.custom", "Use custom prospecting skill levels")
	gui:AddControl(id, "Slider",           0, 2, lcName..".level.min", 0, 375, 25, "Minimum skill: %s")
	gui:AddControl(id, "Slider",           0, 2, lcName..".level.max", 25, 375, 25, "Maximum skill: %s")
	gui:AddControl(id, "MoneyFramePinned", 0, 1, lcName..".profit.min", 1, 99999999, "Minimum Profit")
	gui:AddControl(id, "WideSlider",       0, 1, lcName..".profit.pct", 1, 100, 0.5, "Minimum Discount: %0.01f%%")
	
	gui:AddControl(id, "Subhead",          0,    "Fees adjustment")
	gui:AddControl(id, "Selectbox",        0, 1, ahList, lcName..".adjust.basis", "Deposit/fees basis")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".adjust.brokerage", "Subtract auction fees from projected profit")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".adjust.deposit", "Subtract deposit cost from projected profit")
	gui:AddControl(id, "WideSlider",       0, 2, lcName..".adjust.listings", 1, 10, 0.1, "Average re-listings: %0.1fx")
end
