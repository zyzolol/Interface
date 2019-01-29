--[[
	BottomScanner - An AddOn for WoW to alert you to good purchases as they appear on the AH
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: EvalMatConvert.lua 3502 2008-09-17 18:03:11Z root $
	URL: http://auctioneeraddon.com/dl/BottomScanner/
	Copyright (c) 2006, Norganna

	This is a module for BtmScan to evaluate an item for purchase.

TODO LIST: 
TOP PRIORITY: Gracefully handle any nil results
Add relisting deposit fee projections (like appraiser does, project relisting 10x times subtract 10x deposit fees for conversions that involve deposit costs (primals & depleted)
Considering adding weights for conversions 
Considering adding skillable converts but don't want to step on other evaluators (like prospect or de)
*IN PROGRESS (Add depleted items) Compare the depleted item cost to the real item cost (cause it's also a boe you can sell) 
Change over to a more effecient tables... possibly a converts from to table

KNOWN ISSUES:
A side effect of EMC putting 'always visable' lines into the tooltip is that while scanning, if you have another tooltip open (example, 
mouse over a hearthstone or anything else in bag and leave tooltip open) anytime the evaluator evaluates an item that would add a 
tooltip line, it will add the line to the "open" tooltip, it is possible for it to spam a hearthstone with lines like 'EMC: Convert Me!' or 
'EMC: Just sell me' on items it clearly is not meant to add the tooltip item to. Only thing I can think of atm for fixing this would be to
 assign the tooltip to only attach itself to the current item id or possibly remove the function out of the evaluator and add it to a util.

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

local libName = "EMatsConvert"
local lcName = libName:lower()
local lib = { name = lcName, propername = libName }
table.insert(BtmScan.evaluators, lcName)
local define = BtmScan.Settings.SetDefault
local get = BtmScan.Settings.GetSetting
local set = BtmScan.Settings.SetSetting

BtmScan.evaluators[lcName] = lib

function lib:valuate(item, tooltip)
	local	emcBuyFor = "EMC: Error.Debug"
	
	-- If we're not enabled, scadaddle!	
	if (not get(lcName..".enable")) then return end
	
	-- Fail and exit if auc adv or appraiser is not available. (really doesnt matter anymore we don't call enchantrix for squat its all appraiser based pricing now
		if (AucAdvanced == nil or AucAdvanced.Modules.Util.Appraiser == nil or not AucAdvanced.Modules.Util.Appraiser)  then
			item:info("EMC: Requires AADV + Appraiser")
		return end
			
	-- If this item is grey, forget about it.
	if (item.qual == 0) then return end
			
	local price = 0
	local value = 0	
	local emcTrueSellValue = 0
	
	--Set names to item id so that I don't loose my mind trying to write this/ understand what I did before
	--essence's
	local GPLANAR = 22446
	local GETERNAL = 16203
	local GNETHER = 11175
	local GMYSTIC = 11135
	local GASTRAL = 11082
	local GMAGIC = 10939
	local LPLANAR = 22447
	local LETERNAL = 16202
	local LNETHER = 11174
	local LMYSTIC = 11134
	local LASTRAL = 10998
	local LMAGIC = 10938	
	--motes/primals
	local PAIR = 22451
	local MAIR = 22572	
	local PEARTH= 22452
	local MEARTH = 22573
	local PFIRE = 21884
	local MFIRE = 22574
	local PLIFE = 21886
	local MLIFE = 22575
	local PMANA = 22457
	local MMANA = 22576
	local PSHADOW = 22456
	local MSHADOW = 22577
	local PWATER = 21885
	local MWATER = 22578
	--Depleted items
	local DCBRACER = 0		
	local DCBRACERTO = 32655	-- crystalweave bracers
	local DMGAUNTLETS = 0		
	local DMGAUNTLETSTO = 32656	-- crystalhide handwraps
	local DBADGE = 0			
	local DBADGETO = 32658			-- badge of tenacity
	local DCLOAK = 32677			
	local DCLOAKTO = 32665 	-- crystalweave cape
	local DDAGGER = 32673		
	local DDAGGERTO = 0	-- crystal-infused shiv
	local DMACE = 0		
	local DMACETO = 32661	-- apexis crystal mace
	local DRING = 32678			
	local DRINGTO = 0	-- dreamcrystal band
	local DSTAFF = 0		
	local DSTAFFTO = 32662	-- flaming quartz staff
	local DSWORD = 0		
	local DSWORDTO = 32660	-- crystalforged sword
	local DTHAXE = 32676	
	local DTHAXETO = 32663	-- apexis cleaver

	--Set convertable items table up
	local convertableMat = {
		[GPLANAR] = true,
		[GETERNAL] = true,
		[GNETHER] = true,
		[GMYSTIC] = true,
		[GASTRAL] = true,
		[GMAGIC] = true,
		[LPLANAR] = true,
		[LETERNAL] = true,
		[LNETHER] = true,
		[LMYSTIC] = true,
		[LASTRAL] = true,
		[LMAGIC] = true,
		--[PAIR] = false,  leaving the placeholders for the primals but keeping them commented for possible future use
		[MAIR] = true,
		--[PEARTH] = false, 	-- Blacksmiths can convert them back
		[MEARTH] = true,
		--[PFIRE] = false,           -- Blacksmiths can convert them back
		[MFIRE] = true,
		--[PLIFE] = false,
		[MLIFE] = true,
		--[PMANA] = false,
		[MMANA] = true,
		--[PSHADOW]= false,
		[MSHADOW] = true,
		--[PWATER] = false,
		[MWATER] = true,
	--	[DCBRACER] = true,   --depleted items are disabled until the function is completed and I have all the item id numbers for them and their converted items
	--	[DMGAUNTLETS] = true,
	--	[DBADGE] = true,
		[DCLOAK] = true,
	--	[DDAGGER] = true,
	--	[DMACE] = true,
	--	[DRING] = true,
	--	[DSTAFF] = true,
	--	[DSWORD] = true,
		[DTHAXE] = true,
	}

--Report failure and exit if the item is not in our convertableMat table 
if not convertableMat[ item.id ] then
	if (not get(lcName..".disabletooltip")) then
		item:info("EMC Fail: Not convertable", item.id)
	end
	return
end
	
local convertsToValue = 0
local convertToID = 0
local newBid = 0
local newBuy = 0
local curModelText = "Unknown"
local newBid, newBuy,_, curModelText = AucAdvanced.Modules.Util.Appraiser.GetPrice(item.id, nil ,get(lcName..".matching.check"))
local reagentPrice = 0		

if newBuy == nil then newBuy = newBid end
if newBuy == nil then item:info("EMC Fail: Something went wrong and we have no prices.") return end
		
if get(lcName..".buyout.check") then
	reagentPrice = newBuy
else
	reagentPrice = newBid
end

--set item we are looking at to evalPrice\
local evalPrice = 0
local evalPrice = reagentPrice
	
--Fail and end if appraiser has no value for the item we want to convert
if (evalPrice == nill or evalPrice == 0) then
	if (not get(lcName..".disabletooltip")) then
		item:info("EMC Fail: No appraiser data available")
		item:info("EMC debug: evalPrice = reagentPrice", evalPrice)
	end

	return
end

	--get stack size we are dealing with
	local stackSize = item.count
	
	-- set evalPrice to stack value for tooltip use
	local evalPrice = evalPrice * stackSize

	local convertsToL = {
		[GPLANAR] = true,
		[GETERNAL] = true,
		[GNETHER] = true,
		[GMYSTIC] = true,
		[GASTRAL] = true,
		[GMAGIC] = true,
	}
	
	if convertsToL[ item.id ] then
		--If category is disabled we are done here.
		if (not get(lcName..".enableEssence")) then 
			if (not get(lcName..".disabletooltip")) then
				item:info("EMC Fail: Category disabled.")
			end
		return end
	
		if item.id == GPLANAR then convertToID = LPLANAR end
		if item.id == GETERNAL then convertToID = LETERNAL end
		if item.id == GNETHER then convertToID = LNETHER end
		if item.id == GMYSTIC then convertToID = LMYSTIC end
		if item.id == GASTRAL then convertToID = LASTRAL end
		if item.id == GMAGIC then convertToID = LMAGIC end
				local newBid = 0
				local newBuy = 0
				local curModelText = "Unknown"
				local newBid, newBuy, _, curModelText = AucAdvanced.Modules.Util.Appraiser.GetPrice(convertToID, nil, get(lcName..".matching.check"))
				
				if newBuy == nil then newBuy = newBid end
				if newBuy == nil then item:info("EMC Fail: Something went wrong and we have no prices.") return end
				--update value since greater = 3 lesser ( lesser value *  3 = correct value of one greater )
				if get(lcName..".buyout.check") then
					convertsToValue = newBuy * 3
				else
					convertsToValue = newBid * 3
				end
					
				--Fail and end if appraiser has no value for the item we want to convert
				if (convertsToValue == nill or convertsToValue == 0) then
					if (not get(lcName..".disabletooltip")) then
						item:info("EMC Fail: No appraiser data available")
						item:info("EMC debug: convertsToValue @ to lesser")	
					end
					return
				end
				
			convertsToValue = convertsToValue * stackSize
		value = convertsToValue
	end
	
	local convertsToG = {
		[LPLANAR] = true,
		[LETERNAL] = true,
		[LNETHER] = true,
		[LMYSTIC] = true,
		[LASTRAL] = true,
		[LMAGIC] = true,
	}
	
	if convertsToG[ item.id ] then
		--If category is disabled we are done here.
		if (not get(lcName..".enableEssence")) then 
			if (not get(lcName..".disabletooltip")) then
				item:info("EMC Fail: Category disabled.")
			end		
		return end
		
		if item.id == LPLANAR then convertToID = GPLANAR end
		if item.id == LETERNAL then convertToID = GETERNAL end
		if item.id == LNETHER then convertToID = GNETHER end
		if item.id == LMYSTIC then convertToID = GMYSTIC end
		if item.id == LASTRAL then convertToID = GASTRAL end
		if item.id == LMAGIC then convertToID = GMAGIC end
				newBid = 0
				newBuy = 0
				curModelText = "Unknown"
				newBid, newBuy, _, curModelText = AucAdvanced.Modules.Util.Appraiser.GetPrice(convertToID, nil, get(lcName..".matching.check"))
				
				if newBuy == nil then newBuy = newBid end
				if newBuy == nil then item:info("EMC Fail: Something went wrong and we have no prices.") return end
		
				--update value since 3 lesser = 1 greater ( greater value /  3 = correct value of one lesser )				
					if get(lcName..".buyout.check") then
						convertsToValue = newBuy / 3
					else
						convertsToValue = newBid / 3
					end
				--Fail and end if appraiser has no value for the item we want to convert
				if (convertsToValue == nill or convertsToValue == 0) then
					if (not get(lcName..".disabletooltip")) then
						item:info("EMC Fail: No appraiser data available")
						item:info("EMC debug: convertsToValue @ to greater")
					end	
				return
				end
			convertsToValue = convertsToValue * stackSize

		value = convertsToValue
	end	
	
	local convertsToP = {
		[MAIR] = true,
		[MEARTH] = true,
		[MFIRE] = true,
		[MLIFE] = true,
		[MMANA] = true,
		[MSHADOW] = true,
		[MWATER] = true,
	}
	
	if convertsToP[ item.id ] then
		--If category is disabled we are done here.
		if (not get(lcName..".enableMote")) then 
			if (not get(lcName..".disabletooltip")) then
				item:info("EMC Fail: Category disabled.")		
			end	
		return end
		
		if item.id == MAIR then convertToID = PAIR end
		if item.id == MEARTH then convertToID = PEARTH end
		if item.id == MFIRE then convertToID = PFIRE end
		if item.id == MLIFE then convertToID = PLIFE end
		if item.id == MMANA then convertToID = PMANA end
		if item.id == MSHADOW then convertToID = PSHADOW end
		if item.id == MWATER then convertToID = PWATER end
		
				local newBid = 0
				local newBuy = 0
				local curModelText = "Unknown"
				local newBid, newBuy, _, curModelText = AucAdvanced.Modules.Util.Appraiser.GetPrice(convertToID, nil, get(lcName..".matching.check"))
				
				if newBuy == nil then newBuy = newBid end
				if newBuy == nil then item:info("EMC Fail: Something went wrong and we have no prices.") return end
				
			--update value since 10 motes = 1 primal do primal price / 10 				
					if get(lcName..".buyout.check") then
						convertsToValue = newBuy / 10
					else
						convertsToValue = newBid / 10
					end				
				--Fail and end if appraiser has no value for the item we want to convert
				if (convertsToValue == nill or convertsToValue == 0) then
					if (not get(lcName..".disabletooltip")) then
						item:info("EMC Fail: No appraiser data available")
						item:info("EMC debug: convertsToValue @ to primal")	
					end	
					return
				end					

			convertsToValue = convertsToValue * stackSize
		value = convertsToValue
	end
	
		local convertsFromDepleted = {
	--	[DCBRACER] = true,   --depleted items are disabled until the function is completed and I have all the item id numbers for them and their converted items
	--	[DMGAUNTLETS] = true,
	--	[DBADGE] = true,
	--	[DCLOAK] = true,
	--	[DDAGGER] = true,
	--	[DMACE] = true,
	--	[DRING] = true,
	--	[DSTAFF] = true,
	--	[DSWORD] = true,
		[DTHAXE] = true,
	}
	
	if convertsFromDepleted[ item.id ] then
		--If category is disabled we are done here.
		if (not get(lcName..".enableDepleted")) then 
			if (not get(lcName..".disabletooltip")) then
				item:info("EMC Fail: Category disabled.")			
			end	
		return end
		
		if item.id == DCBRACER then convertToID = DCBRACERTO end
		if item.id == DMGAUNTLETS then convertToID = DMGAUNTLETSTO end
		if item.id == DBADGE then convertToID = DBADGETO end
		if item.id == DCLOAK then convertToID = DCLOAKTO end
		if item.id == DDAGGER then convertToID = DDAGGERTO end
		if item.id == DMACE then convertToID = DMACETO end
		if item.id == DRING then convertToID = DRINGTO end
		if item.id == DSTAFF then convertToID = DSTAFFTO end
		if item.id == DSWORD then convertToID = DSWORDTO end
		if item.id == DTHAXE then convertToID = DTHAXETO end
				
				newBid = 0
				newBuy = 0
				curModelText = "Unknown"
				newBid, newBuy, _, curModelText = AucAdvanced.Modules.Util.Appraiser.GetPrice(convertToID, nil, get(lcName..".matching.check"))
				
				if newBuy == nil then newBuy = newBid end
				if newBuy == nil then item:info("EMC Fail: Something went wrong and we have no prices.") return end
				
			--update value 1 depleted = 1 non depleted item (meaning no modified to newbid or buy below)				
					if get(lcName..".buyout.check") then
						convertsToValue = newBuy
					else
						convertsToValue = newBid
					end									
					--Fail and end if appraiser has no value for the item we want to convert
					if (convertsToValue == nill or convertsToValue == 0) then
						if (not get(lcName..".disabletooltip")) then
							item:info("EMC Fail: No appraiser data available")
							item:info("EMC debug: convertsToValue @ from depleted")
						end
					return end
			convertsToValue = convertsToValue * stackSize
		value = convertsToValue
	end
	
		-- Adjust for brokerage costs
	local brokerage = get(lcName..'.adjust.brokerage')
	local emcAdjustedValue = value
	if (brokerage) then
		local basis = get(lcName..'.adjust.basis')
		local brokerRate, depositRate = 0.05, 0.05
		if (basis == "neutral") then
			brokerRate, depositRate = 0.15, 0.25
		end
		if (brokerage) then
			local amount = (value * brokerRate)
			emcAdjustedValue = value - amount
			
			if (not get(lcName..".disabletooltip")) then
				item:info(" Converted Value", value)
				item:info(" - Brokerage", amount)
				item:info(" = Adjusted amount", emcAdjustedValue)		
			end	
			
			local evalPriceAmount = (evalPrice * brokerRate)	
			
			if (not get(lcName..".disabletooltip")) then
				item:info(" Non-Converted Value", evalPrice + evalPriceAmount)
				item:info(" - Brokerage", evalPriceAmount)
				item:info(" = Adjusted amount", evalPrice)					
			end	
		
			local evalPriceAmount = (evalPrice * brokerRate)
			evalPrice = evalPrice - evalPriceAmount
	
		end

	end

	value = emcAdjustedValue
	
		-- Calculate the real value of this item once our profit is taken out
	local pct = get(lcName..".profit.pct")
	local min = get(lcName..".profit.min")
	local value, mkdown = BtmScan.Markdown(emcAdjustedValue, pct, min)
	if (not get(lcName..".disabletooltip")) then
		item:info(("(Converted) - %d%% / %s markdown"):format(pct,BtmScan.GSC(min, true)), mkdown)
		item:info("mkdown", mkdown)
		item:info("emcAdjustedValue", emcAdjustedValue)
		item:info("Final Converted Value", value)	
	end	

	
	if value > evalPrice then
		if (not get(lcName..".disabletooltip")) then
			EnhTooltip.AddLine("|cff00FF00 EMC: Buy me! Convert Me!|r")					
		end	

		emcBuyFor = "EMC: Convert 2 sell"
	else
		emcBuyFor = "EMC: Just sell me"
	end
	
	if emcAdjustedValue > evalPrice then
		if (not get(lcName..".disabletooltip")) then
			EnhTooltip.AddLine("|cff00FF00 EMC: Convert me to sell! |r")			
		end	
		emcBuyFor = "EMC: Convert 2 sell"	
		emcTrueSellValue = emcAdjustedValue
	else
		if (not get(lcName..".disabletooltip")) then
			EnhTooltip.AddLine("|cffFF0000 EMC: Don't convert me, just sell me! |r")
		end	
		emcBuyFor = "EMC: Just sell me"
		emcTrueSellValue = evalPrice
	end
		
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
	if price > 0 then 
	profit = value - price 
	end
	
	-- If what we are willing to pay for this item beats what
	-- other modules are willing to pay, and we can make more
	-- profit, then we "win".
	if (price >= item.purchase and profit > item.profit) then
		item.purchase = price
		item.reason = emcBuyFor
		item.what = self.name
		item.profit = profit
		item.valuation = emcTrueSellValue
	end
end

--Setup GUI and GUI Defaults 
define(lcName..'.enable', false) -- Evals all default to false
define(lcName..'.allow.buy', true)
define(lcName..'.allow.bid', true)
define(lcName..'.profit.min', 1)
define(lcName..'.profit.pct', 50)
local ahList = {
	{'faction', "Faction AH Fees"},
	{'neutral', "Neutral AH Fees"},
}
define(lcName..'.adjust.brokerage', true)
define(lcName..'.adjust.basis', "faction")
define(lcName..'.matching.check', true)
define(lcName..'.buyout.check', false)

define(lcName..'.enableEssence', true)
define(lcName..'.enableMote', true)
define(lcName..'.enableDepleted', false)
define(lcName..'.disabletooltip', false)

function lib:setup(gui)
	local id = gui:AddTab(libName)	

	gui:AddHelp(id, "what is EMC",
		"What is EMC?",
		"This evaluator allows you to purchase items that can be changed to another item that is worth more (based on your settings here) by simply right clicking the item to convert it.\n\n"..
		"An example of a convertible item would be 1x greater essence into 3x lesser essence or visa versa.\n\n"..
	"\n")
	
	gui:AddHelp(id, "EMC: General settings",
		"EMC: General settings",
		"General settings: This section allows you to configure if the evaluator is enabled and if it is enabled if you only want to allow it to bid or buyout items for converting\n\n"..
		""..
	"\n")

	gui:AddControl(id, "Subhead",		0,	libName.." General settings")
	gui:AddControl(id, "Checkbox",		0, 1, 	lcName..".enable", "Enable purchasing for "..lcName)
	gui:AddControl(id, "Checkbox",		0, 2, 	lcName..".allow.buy", "Allow buyout on items")
	gui:AddControl(id, "Checkbox",		0, 2, 	lcName..".allow.bid", "Allow bid on items")
	gui:AddControl(id, "Checkbox",		0, 2, 	lcName..".disabletooltip", "Disable all EMC Tooltips (may increase performance)")
	
	gui:AddHelp(id, "EMC: Custom profit settings",
		"EMC: Custom profit settings",
		"This section allows you to set your minimum profit requirements for an item to be considered a deal. Both minimum profit and discount % must be met for an item to be considered."..
		""..
		"Please note, this evaluator uses your last used fixed price or last used pricing module from the Appraiser tab, if you haven't posted a mat from the Appraiser tab it will use whatever pricing module you set as your default for Appraiser.\n\n"..
		""..
	"\n")
	
	gui:AddControl(id, "Subhead",		0,	"Custom Profit Settings")
	gui:AddControl(id, "MoneyFramePinned", 0, 1, lcName..".profit.min", 1, 99999999, "Minimum Profit")
	gui:AddControl(id, "WideSlider",		0, 1, 	lcName..".profit.pct", 1, 100, 0.5, "Minimum Discount: %0.01f%%")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".matching.check", "We get prices from the Appraiser tab. Check to use market matching (if enabled on the item).")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".buyout.check", "Use Buyout Price instead of Bid Price:")	
	
	gui:AddHelp(id, "EMC: Fees adjustment",
		"EMC: Fee Adjustment",
		"Fee Adjustments: This section allows you to select if you want brokerage (AH cut) figured in when valuating an item for conversion. \n\n"..
		""..
	"\n")
	
	gui:AddControl(id, "Subhead",		0,    	"Fee Adjustments")
	gui:AddControl(id, "Selectbox",		0, 1, 	ahList, lcName..".adjust.basis", "Deposit/fee basis")
	gui:AddControl(id, "Checkbox",		0, 1, 	lcName..".adjust.brokerage", "Subtract auction fees from the converted profit")
		
	gui:AddHelp(id, "EMC: Enable or disable by category",
		"EMC: Enable or disable by category",
		"This is pretty self explanatory. Either allow the evaluator to look at the specific categories or not. \n\n"..
		""..
	"\n")
		
	gui:AddControl(id, "Subhead",		0,    	"Enable or disable by category")
	gui:AddControl(id, "Checkbox",		0, 1, 	lcName..".enableEssence", "Enable essence conversions")
	gui:AddControl(id, "Checkbox",		0, 1, 	lcName..".enableMote", "Enable mote to primal conversions")
	gui:AddControl(id, "Checkbox",		0, 1, 	lcName..".enableDepleted", "Enable depleted conversions (Warning: if you don't know about depleted items leave off!)") 
end
