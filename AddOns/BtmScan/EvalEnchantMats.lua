--[[
	Version: 5.0.PRE.2303 (BillyGoat)
	Revision: $Id: EvalEnchantMats.lua 2193 2007-09-18 06:10:48Z mentalpower $
	URL: http://auctioneeraddon.com/dl/BottomScanner/
	Copyright (c) 2006, Norganna

	This is a module for BtmScan to evaluate an item for purchase.

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

	Goal:
		To create an btmscan evaluator for enchanters that will watch for
		enchanting reagents or disenchantable items that will disenchant
		into the reagents wanted.
		
		The choice of what reagents is controlled by sliders representing
		a percentage of market price that you are willing to pay.
		The sliders run from 0 to 200 with 0 = not needed,
		100 = pay market price, and 200 = pay twice market price.
		
	BEWARNED:
		THIS IS NOT FOR MAKING A PROFIT, IT IS FOR FINDING REAGENTS

	Thanks:
		to jona for the initial version
		to Ironmind, Speeddymon, Sedatechipmunk and mental power for helping
		me through my basic programming mistakes. also thanks to chardonnay
		and iain who posted baserules for me to copy off.
]]


local libName = "Enchant Mats"			-- I'd love to use "Enchanting Materials" but the UI isn't too savvy about long names
local lcName = libName:lower()
local lib = { name = lcName, propername = libName }
table.insert(BtmScan.evaluators, lcName)
local define = BtmScan.Settings.SetDefault
local get = BtmScan.Settings.GetSetting
local set = BtmScan.Settings.SetSetting

BtmScan.evaluators[lcName] = lib


-- Enchanting reagents, from Enchantrix EnxConstants.lua
local VOID = 22450
local NEXUS = 20725
local LPRISMATIC = 22449
local LBRILLIANT = 14344
local LRADIANT = 11178
local LGLOWING = 11139
local LGLIMMERING = 11084
local SPRISMATIC = 22448
local SBRILLIANT = 14343
local SRADIANT = 11177
local SGLOWING = 11138
local SGLIMMERING = 10978
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
local ARCANE = 22445
local ILLUSION = 16204
local DREAM = 11176
local VISION = 11137
local SOUL = 11083
local STRANGE = 10940

-- a table we can check for item ids
local validReagents = 
	{
	[VOID] = true,
	[NEXUS] = true,
	[LPRISMATIC] = true,
	[LBRILLIANT] = true,
	[LRADIANT] = true,
	[LGLOWING] = true,
	[LGLIMMERING] = true,
	[SPRISMATIC] = true,
	[SBRILLIANT] = true,
	[SRADIANT] = true,
	[SGLOWING] = true,
	[SGLIMMERING] = true,
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
	[ARCANE] = true,
	[ILLUSION] = true,
	[DREAM] = true,
	[VISION] = true,
	[SOUL] = true,
	[STRANGE] = true,
	}



-- This is the meat of the evaluator
-- it processes each item, and needs to be fast

function lib:valuate(item, tooltip)

	-- Bail immediately if we're not enabled
	if (not get(lcName..".enable")) then return end
	
	-- Check for bogus/corrupted item links
	if not (item and item.qual) then return end

	-- Can't do anything without Enchantrix
	if not (Enchantrix and Enchantrix.Storage) then return end


	-- market value for this item
	local market = 0;


	
	-- first, is this an enchanting reagent itself?
	-- if so, just use the value of the reagent
	
	if validReagents[ item.id ] then
					
		local reagentPrice, med, baseline, five = Enchantrix.Util.GetReagentPrice(item.id);
		
		-- if no Auc4 price, use Auc5 price
		if (not reagentPrice) then
			reagentPrice = five
		end
		
		-- still nothing, try the baseline (hard coded)
		if (not reagentPrice) then
			reagentPrice = baseline
		end
		
		-- be safe and handle nil results
		local adjustment = get(lcName..".PriceAdjust."..item.id) or 0;
		
		market = (reagentPrice or 0) * adjustment / 100;
	end


	-- second, see if we can disenchant the item

	if (not market or market == 0) then
		
		-- All disenchantable items are "uncommon" quality or higher
		-- so bail on items that are white or gray
		if (item.qual <= 1) then return end

		-- Check to see if the ilevel is below the disenchant threshold
		local name,_,iQual,iLevel = GetItemInfo(item.link) 
		
		if (get(lcName..".level.custom")) then
			if (NonDisenchantables) then
				if (NonDisenchantables[item.id..":0:0"]) then
					item:info("Abort: Not DEable")
					return true
				end
			end

			-- We have to test a custom level
			local canDe, required = BtmScan.isDEAble(iLevel, iQual, get(lcName..".level.max"))

			-- If it's not disenchantable by our maxlevel, we don't want it
			if not canDe then
				item:info("Abort: DE level > max")
				return
			end
			-- If it is below our minlevel, we don't want it
			if (required < get(lcName..".level.min")) then
				item:info("Abort: DE level < min")
				return
			end
		else
			-- Otherwise, just use our current level
			if (BtmScan.isDEAble(iLevel, iQual)) then
				item:info("Abort: DE level > current")
				return
			end
		end
		
		
		-- Give up if it doesn't disenchant to anything
		local data = Enchantrix.Storage.GetItemDisenchants(item.link)
		if not data then return end

		local total = data.total
		
		if (total and total[1] > 0) then
			local totalNumber, totalQuantity = unpack(total)
			for result, resData in pairs(data) do
				if (result ~= "total") then
					local resNumber, resQuantity = unpack(resData)
					
					local reagentPrice, med, baseline, five = Enchantrix.Util.GetReagentPrice(result);
					
					-- if no Auc4 price, use Auc5 price
					if (not reagentPrice) then
						reagentPrice = five
					end
					
					-- still nothing, try the baseline (hard coded)
					if (not reagentPrice) then
						reagentPrice = baseline
					end
					
					local resYield = resQuantity / totalNumber;
					local resPrice = (reagentPrice or 0) * resYield;
					--local percentage = resNumber / totalNumber;
					--local simpleYield = resQuantity/resNumber;
					
					-- be safe and handle nil results
					local adjustment = get(lcName..".PriceAdjust."..result) or 0;
					
					market = market + resPrice * adjustment / 100;
				end
			end
		end

	end


	-- If we don't know what it's worth, then there's not much we can do
	if( not market or market <= 0) then return end
	
	item:info("Market price", market)


	-- Valuate this item
	local value = market

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
	
	local price = 0;

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
		item.valuation = value
	end
end



-- our variables for UI
define(lcName..'.enable', false)
define(lcName..'.level.custom', false)
define(lcName..'.level.min', 0)
define(lcName..'.level.max', 375)
define(lcName..'.allow.bid', true)
define(lcName..'.allow.buy', true)

--Slider variables
define(lcName..'.PriceAdjust.'..GPLANAR, 100)
define(lcName..'.PriceAdjust.'..GETERNAL, 100)
define(lcName..'.PriceAdjust.'..GNETHER, 100)
define(lcName..'.PriceAdjust.'..GMYSTIC, 100)
define(lcName..'.PriceAdjust.'..GASTRAL, 100)
define(lcName..'.PriceAdjust.'..GMAGIC, 100)
define(lcName..'.PriceAdjust.'..LPLANAR, 100)
define(lcName..'.PriceAdjust.'..LETERNAL, 100)
define(lcName..'.PriceAdjust.'..LNETHER, 100)
define(lcName..'.PriceAdjust.'..LMYSTIC, 100)
define(lcName..'.PriceAdjust.'..LASTRAL, 100)
define(lcName..'.PriceAdjust.'..LMAGIC, 100)
define(lcName..'.PriceAdjust.'..ARCANE, 100)
define(lcName..'.PriceAdjust.'..ILLUSION, 100)
define(lcName..'.PriceAdjust.'..DREAM, 100)
define(lcName..'.PriceAdjust.'..VISION, 100)
define(lcName..'.PriceAdjust.'..SOUL, 100)
define(lcName..'.PriceAdjust.'..STRANGE, 100)
define(lcName..'.PriceAdjust.'..LPRISMATIC, 100)
define(lcName..'.PriceAdjust.'..LBRILLIANT, 100)
define(lcName..'.PriceAdjust.'..LRADIANT, 100)
define(lcName..'.PriceAdjust.'..LGLOWING, 100)
define(lcName..'.PriceAdjust.'..LGLIMMERING, 100)
define(lcName..'.PriceAdjust.'..SPRISMATIC, 100)
define(lcName..'.PriceAdjust.'..SBRILLIANT, 100)
define(lcName..'.PriceAdjust.'..SRADIANT, 100)
define(lcName..'.PriceAdjust.'..SGLOWING, 100)
define(lcName..'.PriceAdjust.'..SGLIMMERING, 100)
define(lcName..'.PriceAdjust.'..VOID, 100)
define(lcName..'.PriceAdjust.'..NEXUS, 100)


-- create our UI
function lib:setup(gui)
	local id = gui:AddTab(libName)
	gui:MakeScrollable(id)
	
	gui:AddControl(id, "Subhead",          0,    libName.." Settings")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".enable", "Enable purchasing for "..lcName)
	gui:AddControl(id, "Checkbox",         0, 2, lcName..".allow.buy", "Allow buyout on items")
	gui:AddControl(id, "Checkbox",         0, 2, lcName..".allow.bid", "Allow bid on items")

	gui:AddControl(id, "Checkbox",         0, 1, lcName..".level.custom", "Use custom enchanting skill levels")
	gui:AddControl(id, "Slider",           0, 2, lcName..".level.min", 0, 375, 25, "Minimum skill: %s")
	gui:AddControl(id, "Slider",           0, 2, lcName..".level.max", 25, 375, 25, "Maximum skill: %s")
	
	-- aka "what percentage of market value am I willing to pay for this reagent"?
	gui:AddControl(id, "Subhead",          0,    "Reagent Price Modification")

	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..GPLANAR, 0, 200, 1, "Greater Planar Essence %s%%" )
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..GETERNAL, 0, 200, 1, "Greater Eternal Essence %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..GNETHER, 0, 200, 1, "Greater Nether Essence %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..GMYSTIC, 0, 200, 1, "Greater Mystic Essence %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..GASTRAL, 0, 200, 1, "Greater Astral Essence %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..GMAGIC, 0, 200, 1, "Greater Magic Essence %s%%")
	
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LPLANAR, 0, 200, 1, "Lesser Planar Essence %s%%" )
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LETERNAL, 0, 200, 1, "Lesser Eternal Essence %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LNETHER, 0, 200, 1, "Lesser Nether Essence %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LMYSTIC, 0, 200, 1, "Lesser Mystic Essence %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LASTRAL, 0, 200, 1, "Lesser Astral Essence %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LMAGIC, 0, 200, 1, "Lesser Magic Essence %s%%")
	
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..ARCANE, 0, 200, 1, "Arcane Dust %s%%" )
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..ILLUSION, 0, 200, 1, "Illusion Dust %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..DREAM, 0, 200, 1, "Dream Dust %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..VISION, 0, 200, 1, "Vision Dust %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..SOUL, 0, 200, 1, "Soul Dust %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..STRANGE, 0, 200, 1, "Strange Dust %s%%")
	
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LPRISMATIC, 0, 200, 1, "Large Prismatic Shard %s%%" )
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LBRILLIANT, 0, 200, 1, "Large Brilliant Shard %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LRADIANT, 0, 200, 1, "Large Radiant Shard %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LGLOWING, 0, 200, 1, "Large Glowing Shard %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..LGLIMMERING, 0, 200, 1, "Large Glimmering Shard %s%%")
	
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..SPRISMATIC, 0, 200, 1, "Small Prismatic Shard %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..SBRILLIANT, 0, 200, 1, "Small Brilliant Shard %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..SRADIANT, 0, 200, 1, "Small Radiant Shard %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..SGLOWING, 0, 200, 1, "Small Glowing Shard %s%%")
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..SGLIMMERING, 0, 200, 1, "Small Glimmering Shard %s%%")
	
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..VOID, 0, 200, 1, "Void Crystal %s%%" )
	gui:AddControl(id, "WideSlider", 0, 1, lcName..".PriceAdjust."..NEXUS, 0, 200, 1, "Nexus Crystal %s%%")

end
