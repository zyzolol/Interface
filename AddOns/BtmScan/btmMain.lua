--[[
	BottomScanner  -  An AddOn for WoW to alert you to good purchases as they appear on the AH
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: btmMain.lua 3502 2008-09-17 18:03:11Z root $
	URL: http://auctioneeraddon.com/dl/BottomScanner/
	Copyright (c) 2006, Norganna

	Documentation of the various member variables used in this module:

	BtmScan.interval - How many seconds between new last page Queries
		set to 1 when query isn't available for some reason, to try again in 1 second; also right after you hit the play button to schedule the first scan
		set to 6 when BTM query first starts and we are trying to zero in on last page, and also when value was previously nil (not sure how this would happen)
		set to 25 (actually BtmScanData.refresh, but I think this is only set to 25) once we have gotten the last page nailed
		set to 30 on module load, but I don't think this gets used anywhere
	BtmScan.offset - how many pages back from last page to scan (will be 0 normally, 1 every 5th page scan)
	BtmScan.lasttry - the .timer value from the previous attempt (I think this is used to create the Log window, and maybe to control the flashing it used to do)
	BtmScan.auctPriceModel - used in creating the BtmScanner price model in Auctioneer
	BtmScan.timer - seconds since the last scheduled scan start; gets reset to 0 after any purchase decision
	BtmScan.pageScan - time between scans of the current query results (set to shorter than .interval in order to allow multiple passes through results without requerying, as when a purchase attempt breaks PageScan() early)
		set to 0.001 after any purchase dialog result or when piggybacking on currently running query (auctioneer scan or manual), to cause immediate search of current results
		set to 2 after a new last page query is sent to AH (to give results time to return)
		set to nil once PageScan() begins (to prevent repeated attempts to check this page of items unless we break out early for a purchase and need to resume later)
	BtmScan.scanStage
		0 - no longer scanning page / reached end of query page
		1 - waiting for query results
		2 - scanning page
		3 - prompting for a purchase / scanning paused
	BtmScan.scanning - are we currently scanning
	BtmScan.pageCount - number of pages in the AH
	BtmScan.resume - index to resume bargain search for in PageScan() [needed after breaking out of scan to prompt for a bid, to avoid double bidding and generally be slightly more efficient]
		set to a value just prior to breaking out of PageScan() for a purchase opportunity
		set to nil on init, when PageScan() completes successfully, or when bottom scanning is ended

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
]]

BtmScanData = {}
local tr = BtmScan.Locales.Translate
local data, dataZone

local addonName = "BottomScanner"

-- Used to control whether BTM tooltip includes help message for items with no "sanity" price history
-- Preferred setting is true, to eliminate tooltip (for BoP items and others which can't be auctioned)
-- Right after updates when we don't have all new items uploaded, can be set to false
local upToDateConservativePrices = false

-- Used in BtmScan.CanSendAuctionQuery() to disable the additional checks
-- performed in the hooked CanSendAuctionQuery() function. This is necessary
-- since we'd otherwise lock ourselves off from scanning, instead of other
-- addons.
local hookCanSendAuctionQuery = true -- (boolean)
local TopScanActive = false

--warn once per session if purchase would cause you to fall below reserve
local reserveWarning = true

BTMSCAN_VERSION = "5.0.0"
if (BTMSCAN_VERSION == "<\037version%>") then
	BTMSCAN_VERSION = "4.1.0-DEV"
end
BtmScan.Version = BTMSCAN_VERSION

BtmScan.NoPrompt = {}
BtmScan.resume = nil

if (AucAdvanced and AucAdvanced.Modules) then
	if not AucAdvanced.Modules.External then
		AucAdvanced.Modules.External = {}
	end
	AucAdvanced.Modules.External.BtmScan = BtmScan
end

-- Load function gets run when this addon has loaded.
BtmScan.OnLoad = function ()
	BtmScan.Print(tr("Welcome to BottomScanner. Type /btm for help"))

	-- Register our command handlers
	SLASH_BTMSCAN1 = "/btm"
	SLASH_BTMSCAN2 = "/btmscan"
	SLASH_BTMSCAN3 = "/bottomscan"
	SLASH_BTMSCAN4 = "/bottomscanner"
	SlashCmdList["BTMSCAN"] = BtmScan.Command

	-- Ensure sane defaults
	if (not BtmScanData.config) then BtmScanData.config = {} end
	if (not BtmScanData.factions) then BtmScanData.factions = {} end

	Stubby.RegisterFunctionHook("EnhTooltip.AddTooltip", 600, BtmScan.TooltipHook)
	Stubby.RegisterFunctionHook("QueryAuctionItems", 600, BtmScan.QueryAuctionItems)
	Stubby.RegisterFunctionHook("CanSendAuctionQuery", 10, BtmScan.PostCanSendAuctionQuery)
	
	if BeanCounter then
		Stubby.RegisterFunctionHook("BeanCounter.Private.databaseAdd", 600, BtmScan.BeanCounterStored)
	end
	-- Register our temporary command hook with stubby
	Stubby.RegisterBootCode("BtmScan", "CommandHandler", [[
		local function cmdHandler(msg)
			local cmd, param = msg:lower():match("^(%w+)%s*(.*)$")
			cmd = cmd or msg:lower() or ""
			param = param or ""
			if (cmd == "load") then
				if (param == "") then
					Stubby.Print("Manually loading BottomScanner...")
					LoadAddOn("BtmScan")
				elseif (param == "auctionhouse") then
					Stubby.Print("Setting BottomScanner to load when this character visits the auction house")
					Stubby.SetConfig("BtmScan", "LoadType", param)
				elseif (param == "always") then
					Stubby.Print("Setting BottomScanner to always load for this character")
					Stubby.SetConfig("BtmScan", "LoadType", param)
					LoadAddOn("BtmScan")
				elseif (param == "never") then
					Stubby.Print("Setting BottomScanner to never load automatically for this character (you may still load manually)")
					Stubby.SetConfig("BtmScan", "LoadType", param)
				else
					Stubby.Print("Your command was not understood")
				end
			else
				if BtmScan and BtmScan.Command then
					BtmScan.Command(msg)
				else
					Stubby.Print("BottomScanner is currently not loaded.")
					Stubby.Print("  You may load it now by typing |cffffffff/btmscan load|r")
					Stubby.Print("  You may also set your loading preferences for this character by using the following commands:")
					Stubby.Print("  |cffffffff/btmscan load auctionhouse|r - BottomScanner will load when you visit the auction house")
					Stubby.Print("  |cffffffff/btmscan load always|r - BottomScanner will always load for this character")
					Stubby.Print("  |cffffffff/btmscan load never|r - BottomScanner will never load automatically for this character (you may still load it manually)")
				end
			end
		end
		SLASH_BTMSCAN1 = "/btm"
		SLASH_BTMSCAN2 = "/btmscan"
		SLASH_BTMSCAN3 = "/bottomscan"
		SLASH_BTMSCAN4 = "/bottomscanner"
		SlashCmdList["BTMSCAN"] = cmdHandler
	]])
	Stubby.RegisterBootCode("BtmScan", "Triggers", [[
		function BtmScan_CheckLoad()
			local loadType = Stubby.GetConfig("BtmScan", "LoadType")
			if (loadType == "auctionhouse" or not loadType) then
				LoadAddOn("BtmScan")
			end
		end
		Stubby.RegisterFunctionHook("AuctionFrame_LoadUI", 100, BtmScan_CheckLoad)
		local loadType = Stubby.GetConfig("BtmScan", "LoadType")
		if (loadType == "always") then
			LoadAddOn("BtmScan")
		else
			Stubby.Print("BottomScanner is not loaded. Type /btmscan for more info.")
		end
	]])

	BtmScan.timer = 0
end

local function tt(tip, price)
	EnhTooltip.AddLine(tip, price)
	EnhTooltip.LineColor(0.9,0.6,0.2)
end

-- Event handler
BtmScan.OnEvent = function(...)
	local event, arg = select(2, ...)
	if (event == "ADDON_LOADED") then
		if (string.lower(arg) == "btmscan") then
			BtmScan.OnLoad()
		end
	elseif (event == "AUCTION_HOUSE_CLOSED") then
		BtmScan.ClosePrompt()
	end
end
--hook beancounters storeage event
local CallBackString
function BtmScan.BeanCounterStored(_, _, event)
	if CallBackString and event == "postedBids" then 
		--BeanCounter.Print("Sent to beanc @", time(), T)
		BeanCounter.Private.storeReasonForBid(CallBackString)
		CallBackString = nil
	end
end
-- Timing routines
BtmScan.interval = 30
BtmScan.offset = 0
BtmScan.pageScanTimeout = 0
BtmScan.OnUpdate = function(...)
	local elapsed = select(2, ...)

	if (not BtmScan.lastTry) then BtmScan.lastTry = 0 end
	if (not BtmScan.interval) then BtmScan.interval = 6 end
	if (BtmScan.timer) then
		if (not BtmScan.LogFrame and AuctionFrame and BtmScan.lastTry < BtmScan.timer - 1 ) then
			BtmScan.CreateLogWindow()
			if (BtmScan.LogFrame) then BtmScan.LogFrame.Update() end
			BtmScan.lastTry = BtmScan.timer
		end

		BtmScan.timer = BtmScan.timer + elapsed

		-- Check whether we should scan the current page of query results for purchase opportunities
		if (BtmScan.pageScan) then
			if (BtmScan.timer > BtmScan.pageScan) then
				BtmScan.PageScan(BtmScan.resume)
			end
		end

		-- Now check if enough time has elapsed to do everything else - i.e. request a new last page query, among other tasks
		-- Note that if any bid opportunity happened above in PageScan(), BtmScan.timer has been reset to 0 now
		-- So you're going to wait a whole .interval from the time the last bid/BO dialog is dismissed before you get past this next section to get any new query results
		if (BtmScan.timer < BtmScan.interval) then
			return
		end
		BtmScan.timer = BtmScan.timer - BtmScan.interval
		BtmScan.lastTry = BtmScan.lastTry - BtmScan.interval
	else
		BtmScan.timer = 0
	end

	-- Set the background at the correct stage color
	if (not BtmScan.LogParent) then return end

	-- Don't go any farther if we're still waiting on a purchase dialog decision
	if (BtmScan.scanStage == 3) then return end

	-- If we are supposed to be scanning, then let's do it!
	if (BtmScan.scanning) then

		-- Check to see if the AH is open for business
		if not (AuctionFrame and AuctionFrame:IsVisible()) then
			BtmScan.interval = 1 -- Try again in one second
			return
		end
		
		-- Get the current number of auctions and pages
		local pageCount, totalCount = GetNumAuctionItems("list")
		local totalPages = math.floor((totalCount-1)/NUM_AUCTION_ITEMS_PER_PAGE)
		if (totalPages < 0) then totalPages = 0 end

		-- Set the AH page count to a signal value, if this is our first time
		if (not BtmScan.pageCount) then
			BtmScan.pageCount = -1
		end

		-- Decide whether we are just starting to use the BtmScanner queries (as opposed to piggybacking), which means we are going to do a few quick scans to get to the last page quickly
		if (totalPages ~= BtmScan.pageCount) then
			BtmScan.pageCount = totalPages
			BtmScan.interval = 6 -- Short cut the delay, we need to reload now damnit!
		else
			-- We have the last page pegged, go back to the default slow query speed
			BtmScan.interval = BtmScanData.refresh
		end

		-- Check to see if we can send a query
		if not (BtmScan.CanSendAuctionQuery()) then
			BtmScan.interval = 1 -- Try again in one second
			return
		end

		-- Every 5 pages, go back a page just to double check that nothing got by us.
		BtmScan.offset = (BtmScan.offset + 1) % 5
		local offset = 0
		if (BtmScan.offset == 0) then offset = 1 end

		-- Show me tha money!  Either do a new AH query, or piggyback on an existing query
		--BtmScan.processing = true
		BtmScan.scanStage = 2
		local page = BtmScan.pageCount-offset or 0
		-- Nothing will fix this logic except renesting
		if not (Auctioneer and (Auctioneer.ScanManager and Auctioneer.ScanManager.IsScanning()
			or Auctioneer.BidScanner and Auctioneer.BidScanner.IsScanning())) and
			not (AucAdvanced and AucAdvanced.Scan.IsScanning()) and (BtmScan.Settings.GetSetting("scan.reload.enable")) then
			-- Auctioneer is not scanning and page refresh is enabled, so let's send  off a query
				if (BtmScan.Settings.GetSetting("EnableTopScan")) then
					TopScanActive = not TopScanActive
				else
					TopScanActive = false --Makes sure it doesn't get stuck on if BtmScan.Settings.GetSetting("EnableTopScan") is turned off
				end
				if (TopScanActive) then
					page = 0
				end	
			AuctionFrameBrowse.page = page
			if SortAuctionClearSort then SortAuctionClearSort("list") end--the If-Then can be removed once 2.3 is live
			QueryAuctionItems("", "", "", nil, nil, nil, page, nil, nil)
		else
			-- If Auctioneer is currently scanning, then we just need to piggyback its calls.
			TopScanActive = false
			BtmScan.timer = 0
			BtmScan.pageScan = 0.001
		end

		-- Since we're getting a new set of query results, let's reset resume here to make sure we don't skip anything in the new results
		BtmScan.resume = nil

		AuctionFrameBid.page = page
	end
end

local lastNextPage = 0
BtmScan.QueryAuctionItems = function(par,ret, name,lmin,lmax,itype,class,sclass,page,able,qual)
--	BtmScan.Print("QueryAuctionItems (" .. GetTime() .. ")")

	lastNextPage = 0

	if (not BtmScan.scanning) then return end
	if (AucAdvanced and AucAdvanced.Scan.IsScanning()) then
		-- We will get notified when to check the page. We don't have to "guess".
		return
	end

	-- Wait at least a second for query results to become available
	BtmScan.timer = 0
	BtmScan.scanStage = 1
	BtmScan.pageScan = 1
	-- And give up after 20 seconds if the page still hasn't arrived
	BtmScan.pageScanTimeout = GetTime() + 20
end

-- Called by AucAdvanced when it's finished it's page to ask us if we're finished with it.
-- We'll schedule an immediate page scan to make certian!
function BtmScan.FinishedPage(nextPage)
	if (not BtmScan.scanning) then return end
	if lastNextPage == nextPage then return end
	lastNextPage = nextPage
	BtmScan.timer = 0.1 -- Force a scan
	BtmScan.pageScan = 0
	if (BtmScan.scanStage and BtmScan.scanStage ~= 3) then
		BtmScan.scanStage = 2
	end
end

function BtmScan.IsPageReady(timeout)
	if GetTime() >= timeout then
		BtmScan.Print("Page scan timed out (" .. GetTime() .. ")")
		return true
	end
	
	local pageCount, totalCount = GetNumAuctionItems("list")
	for idx = 1, pageCount do
		local link = GetAuctionItemLink("list", idx)
		if not link then return false end
		local owner = select(12, GetAuctionItemInfo("list", idx))
		if not owner then return false end
	end
	return true
end

function BtmScan.PageScan(resume)
	-- BtmScan.Print("PageScan (" .. GetTime() .. ")")

	if not (AucAdvanced and AucAdvanced.Scan.IsScanning()) then
		if not BtmScan.IsPageReady(BtmScan.pageScanTimeout) then
			-- Wait a bit
			BtmScan.pageScan = BtmScan.pageScan + 0.05
			return
		end
	else
		-- We will get notified when to check the page. No need to poll.
	end
	
	-- BtmScan.Print("Ready (" .. GetTime() .. ")")

	BtmScan.pageScan = nil
	if (not BtmScan.scanStage or BtmScan.scanStage == 0 or BtmScan.scanStage == 3) then return end

	-- Make sure the current zone is loaded and has defaults
	BtmScan.GetZoneConfig("pagescan")

	-- Ok, we've just queried the auction house, page should be loaded etc.
	-- lets get the items on the list and scan them.
	local pageCount, totalCount = GetNumAuctionItems("list")

	if Enchantrix and Enchantrix.Util and Enchantrix.Util.CreateReagentPricingTable then
		BtmScan.deReagentTable = Enchantrix.Util.CreateReagentPricingTable()
	end

	local log = BtmScan.Log
	if (BtmScan.dryRun) then log = BtmScan.Print end

	local reserve = BtmScan.Settings.GetSetting("global.reserve")
	local maxprice = BtmScan.Settings.GetSetting("global.maxprice")
	local itemConfigTable = BtmScan.Settings.GetSetting("itemconfig.list")

	-- Ok, lets look at all these lovely items
	if (not resume) then resume = pageCount end
	local i = resume

	local item = {}

	while ((i >= 1) and (BtmScan.scanning == true)) do
		item.pos = i

		item.link = GetAuctionItemLink("list", item.pos)

		-- If this item exists
		if (item.link) then
			item.name, item.tex, item.count, item.qual,
			item.use, item.lvl, item.min, item.inc, item.buy,
			item.cur, item.high, item.owner = GetAuctionItemInfo("list", item.pos)
			item.remain = GetAuctionItemTimeLeft("list", item.pos)
			
			item.count = item.count or 1

			if (item.owner ~= UnitName("player") and not item.high) then
				-- Disassemble the link
				item.id, item.suffix, item.enchant, item.seed = BtmScan.BreakLink(item.link)
				item.sig = ("%d:%d:%d"):format(item.id, item.suffix, item.enchant)
				
				-- read ItemConfig
				local itemconfig = itemConfigTable[item.sig]
				if (itemconfig) then
					itemconfig = BtmScan.unpackItemConfiguration(itemconfig)
				else
					itemconfig = {}
				end
				item.itemconfig=itemconfig

				-- Check that we're not ignoring this item
				if itemconfig.isIgnore==true then
--					BtmScan.Print(" is on item-ignore-list ")
				else

					-- Work out the item's "next-bid"
					item.bid = item.min
					if (item.cur and item.cur > 0) then item.bid = item.cur + item.inc end

					-- Determine whether buys/bid are valid
					item.canbid = true
					item.canbuy = true
					local balance = GetMoney()

					if (not BtmScan.Settings.GetSetting("allow.bid")) then
						if (not (TopScanActive and BtmScan.Settings.GetSetting("override.nobid"))) then item.canbid = false end
					end
					if (not BtmScan.Settings.GetSetting("allow.buy")) then item.canbuy = false end
					
					-- Check that item won't put us below reserve
					if (item.canbid and balance - item.bid < reserve) then
						item.canbid = false
						item.canbuy = false
					elseif (item.canbuy and balance - item.buy < reserve) then
						item.canbuy = false
					end
					
					-- Check maxprice setting and for buyout price
					if (item.canbid and item.bid > maxprice) then
						item.canbid = false
						item.canbuy = false
					elseif (item.canbuy and item.buy > maxprice) then
						item.canbuy = false
					elseif (item.canbuy and item.buy == 0) then
						-- can't buy if no buyout
						item.canbuy = false
					end
					
					-- Check that price isn't above ignore price, if any
					local autoignore = BtmScan.NoPrompt[item.sig]
					if (autoignore) then
						if (item.canbid and item.bid/item.count >= autoignore) then
							item.canbid = false
							item.canbuy = false
						elseif (item.canbuy and item.buy/item.count >= autoignore) then
							item.canbuy = false
						end
					end
					
					-- Initialize the purchasing variables
					item.purchase = 0   -- The amount to purchase for
					item.reason = ""    -- The reason why we are purchasing
					item.what = ""      -- The component that is making the purchase
					item.profit = 0     -- The projected profit amount
					item.valuation = 0  -- The estimated value of this item

					item.force = false  -- Forcefully purchase now!
					item.ignore = false -- Forcefully ignore this item!

					-- Don't waste processing if, for whatever reason, we can't bid or buyout
					local purchasable = true
					if (not (item.canbid or item.canbuy)) then purchasable = false end

					-- Run through all the evaluators to find the best purchase order
					if purchasable then
						purchasable = BtmScan.EvaluateItem(item)
						if item.force then
							if balance - item.purchase < 0 then
								purchasable = false
							end
						end
					end

					-- One last check to make sure this is a valid purchase order
					if purchasable then
						BtmScan.PromptPurchase(item)
						BtmScan.resume = i - 1
						return
					end
				end
			end
		end
		i = i - 1
	end

	BtmScan.scanStage = 0

	--reached the end of the page, set resume back to nil
	BtmScan.resume = nil
end

local function itemAddInfo(self, info, amount)
	if not self or not info then return end
	amount = tonumber(amount)
	if amount then
		table.insert(self, tostring(info))
		table.insert(self, amount)
	else
		table.insert(self, tostring(info))
	end
end

local function itemClearInfo(self)
	if not self then return end
	while (#self > 0) do
		table.remove(self)
	end
end

local function ttItemInfo(item)
	local i = 1
	while i <= #item do
		if (type(item[i+1]) == "number") then
			local val = item[i+1]
			tt("  "..item[i], val)
			i = i + 1
		else
			tt("  "..item[i])
		end
		i = i + 1
	end
end

function BtmScan.CreateItem(itemLink, itemCount)
	local item = {
		count = itemCount or 1,
		canbid = false,
		canbuy = false,
		bid = 0,
		buy = 0,
		purchase = 0,
		profit = 0,
		valuation = 0,
		info = itemAddInfo,
		clear = itemClearInfo,
	}
	item.name, item.link, item.qual, item.ilevel, item.level = GetItemInfo(itemLink)
	item.id, item.suffix, item.enchant, item.seed = BtmScan.BreakLink(item.link)
	item.sig = ("%d:%d:%d"):format(item.id, item.suffix, item.enchant)
	return item
end

function BtmScan.CrossEvaluateItem(evaluatorName, item, doTooltip)
	local evaluator = BtmScan.evaluators[evaluatorName]
	if not evaluator then return end

	local pushEnabled = BtmScan.Settings.GetSetting(evaluatorName .. ".enable")
	BtmScan.Settings.SetSetting(evaluatorName .. ".enable", true)
	evaluator:valuate(item, doTooltip)
	BtmScan.Settings.SetSetting(evaluatorName .. ".enable", pushEnabled)
end

BtmScan.evaluators = {}
BtmScan.filters = {}

function BtmScan.EvaluateItem(item, doTooltip)
	item.info = itemAddInfo
	item.clear = itemClearInfo
	for pos, name in ipairs(BtmScan.evaluators) do
		local valuator = BtmScan.evaluators[name]

		-- first check filters for this module
		local isFiltered
		for filterPos, filterName in ipairs(BtmScan.filters) do
			local filter=BtmScan.filters[filterName]
			if (filter and filter.filterItem) then
				if (filter:filterItem(item,name)) then
					-- disable only this module
--					BtmScan.Print(" got filter hit "..name..":"..filterName)
					valuator=nil
				end
			end
		end




		local ignoreString = item.itemconfig.ignoreModuleList
		if (ignoreString and strfind(ignoreString,name)) then
--				BtmScan.Print(" got filter hit(ignore-list) "..item.sig..":"..ignoreString)
				valuator=nil
		end

		if (valuator and valuator.valuate) then
			item:clear()
			valuator:valuate(item, doTooltip)
			if (doTooltip) then
				local header = false
				if (item.valuation > 0) then
					tt(valuator.propername.." valuation", item.valuation)
					if (item.force) then
						item:info("- Forced: "..item.reason)
					end
				end
				if (item.ignore) then
					item:info("- Ignore: "..item.reason)
				end
				if (#item > 0 and IsModifierKeyDown()) then
					if (item.valuation <= 0) then
						tt(valuator.propername.." valuation", 0)
					end
					ttItemInfo(item)
				end
				if (item.bid == 0) then
					item.purchase = 0
					item.reason = ""
					item.what = ""
					item.profit = 0
					item.valuation = 0

					item.force = false
					item.ignore = false
				end
			end
			if item.ignore or item.force then
				break
			end
		end
	end
	-- if item is overpriced or ignored, skip it
	-- or if it's at least as valuable as buyout price, buy it
	-- or if it's at least as valuable as bid price, bid on it
	if item.ignore or item.purchase < item.bid then
		item.purchase = 0
	elseif item.canbuy and item.purchase >= item.buy then
		item.purchase = item.buy
	elseif item.canbid and item.purchase >= item.bid then
		item.purchase = item.bid
	end
	return item.purchase > 0
end

function BtmScan.Markdown(price, pct, min)
	local mark = 0
	if (min) then
		mark = min
	end
	if (pct) then
		mark = math.max(price * pct / 100, mark)
	end
	return price - mark, mark
end

--Return whether the item is disenchantable give the item's level and the user's enchanting level
BtmScan.isDEAble = function(iLevel, iQual, eLevel)
	if not eLevel then
		if (data) then eLevel = data.enchLevel end
		if not eLevel then
			if Enchantrix and Enchantrix.Util and Enchantrix.Util.GetUserEnchantingSkill then
				eLevel = Enchantrix.Util.GetUserEnchantingSkill()
				if data then
					data.enchLevel = eLevel
				end
			end
		end
		if not eLevel then eLevel = 300 end
	end

	local required = 1
	if (iQual < 2) then return false end
	if iLevel > 100 then required = 275
	elseif iLevel > 60 then required = 225
	elseif iLevel > 55 then required = 200
	elseif iLevel > 50 then required = 175
	elseif iLevel > 45 then required = 150
	elseif iLevel > 40 then required = 125
	elseif iLevel > 35 then required = 100
	elseif iLevel > 30 then required = 75
	elseif iLevel > 25 then required = 50
	elseif iLevel > 20 then required = 25
	end
	if (iQual == 3) then
		required = math.max(25, required)
	elseif (iQual == 4) then
		required = math.max(125, required)
		if (iLevel >= 90) then
			required = 300
		end
	end

	if eLevel and eLevel > 0 then
		if eLevel >= required then
			return true, required
		end
	end
	return false, required
end

-------------------------------------------------------------------------------
-- Hook called after Blizzard's CanSendAuctionQuery().
-- Overrides the return value, if we are scanning the AH to make sure that no
-- other addon interferes with our scanning procedure, messing the whole scan
-- up.
-- A special version of CanSendAuctionQuery() is provided, which can be used
-- to receive the almost unaltered return value. See
-- BtmScan.CanSendAuctionQuery() for more details.
--
-- called by:
--    function hook - CanSendAuctionQuery() (position: 10)
--    globally      - BtmScan.PostCanSendAuctionQuery()
--
-- parameters:
--    _     - ignoring the first parameter, which is an empty table, since no
--            parameters are passed when registering this function with Stubby
--            (see Stubby.RegisterFunctionHook() for more details)
--    _     - ignoring the second parameter, which is a table containing the
--            return value of the original function call.
--            (see Stubby.RegisterFunctionHook() for more details)
--
-- returns:
--    first value:
--       nil, if sending an auction query is fine
--       "setreturn", otherwise
--    second value:
--       nil, if sending an auction query is fine
--       {}, otherwise
-------------------------------------------------------------------------------
BtmScan.PostCanSendAuctionQuery = function(_, _)
	if not hookCanSendAuctionQuery then
		 -- we are calling the function via BtmScan.CanSendAuctionQuery()
		 -- and therefore are asked not to alter the return value
		return
	end

	-- We are performing our own scans. Permit other addons from interfering.
	if (BtmScan.scanStage and BtmScan.scanStage > 0) then
		return "setreturn", {}
	end
end


-------------------------------------------------------------------------------
-- BottomScanner's version of CanSendAuctionQuery().
-- This function can be called, if BottomScanner should not interfere with the
-- CanSendAuctionQuery()-return value.
-- Refere to AucQueryManager.CanSendAuctionQuery() to see a more detailed
-- description on when the original return value is still being altered (not
-- by us, but by Auctioneer).
--
-- called by:
--    globally - BtmScan.CanSendAuctionQuery()
--       called in BtmScan.OnUpdate()
--
-- calls:
--    AucQueryManager.CanSendAuctionQuery() - always
--
-- returns:
--    1, if sending an auction query is fine
--    nil, otherwise
-------------------------------------------------------------------------------
BtmScan.CanSendAuctionQuery = function()
	-- Exclude our own checks in CanSendAuctionQuery() as well as use
	-- Auctioneer's special CanSendAuctionQuery()-function.
	local ret = true
	if (Auctioneer and Auctioneer.QueryManager) then
		hookCanSendAuctionQuery = false
		ret = Auctioneer.QueryManager.CanSendAuctionQuery()
		hookCanSendAuctionQuery = true
	end
	return ret
end

-- Get a GSC value and work out what it's worth
BtmScan.ParseGSC = function (price)
	price = string.gsub(price, "|c[%a%d][%a%d][%a%d][%a%d][%a%d][%a%d][%a%d][%a%d]", " ") 
	price = string.gsub(price, "[gG]", "0000 ")
	price = string.gsub(price, "[sS]", "00 ")
	price = string.gsub(price, "[^0-9]+", " ")	-- Note that we're stripping out all non-digits here, so any garbage in the input stream is automatically lost now

	local total = 0
	for q in string.gmatch(price, "(%d+)") do
		local number = tonumber(q) or 0
		total = total + number
	end

	return total
end

-- Break an ItemID into it's component pieces
BtmScan.BreakLink = function (link)
	if (type(link) ~= 'string') then return end
	local whole, item, name, remain = string.match(link, "(|c[0-9a-fA-F]+|Hitem:([^|]+)|h%[(.-)%]|h|r)(.*)")
	if (not item) then return end

	local itemID, enchant, gem1, gem2, gem3, gem4, randomProp, uniqID = strsplit(":", item)

	-- original search format is "[ItemLink]x(Count) at (Price)".
	local i,j, count, price, nextpart
	i,j, count, nextpart = string.find(remain or "", "^x(%d+)(.*)")
	if (i) then
		count = tonumber(count) or 0
		remain = nextpart
	else count = 0 end
	i,j, price, nextpart = string.find(remain or "", "^ at ([^ ]+)(.*)")
	if (i) then
		price = BtmScan.ParseGSC(price)
	remain = nextpart
	else price = 0 end

	-- Now check for new format "[ItemLink] <price> <count>" if original format came up empty
	if (price == 0) then
		i, j, price, count, nextpart = string.find(remain or "", "^ *([%dgGsScC]+) *(%d*)(.*)")
		if (i) then
			price = BtmScan.ParseGSC(price)
			count = tonumber(count) or 0
			remain = nextpart
		else
			price = 0
			count = 0
		end
	end

	return tonumber(itemID) or 0, tonumber(randomProp) or 0, tonumber(enchant) or 0, tonumber(uniqID) or 0, name, whole, count, price, remain
end

-- Item Designation used in several places
BtmScan.ItemDes = function (link)
	local itemID, itemRand, _,_,_, itemLink, count, price, remain = BtmScan.BreakLink(link)
	if (not itemID) then return end
	return string.format("%d:%d", tonumber(itemID) or 0, tonumber(itemRand) or 0), tonumber(count) or 0, tonumber(price) or 0, itemID, itemRand, itemLink, remain
end

-- Item Designation used in several places
BtmScan.BreakItemDes = function (des)
	local i,j, itemID, itemRand = string.find(des, "(%d+):(%d+)")
	return tonumber(itemID) or 0, tonumber(itemRand) or 0
end

-- Makes up a pretend link based off the hyperlink code
BtmScan.FakeLink = function (hyperlink, quality, name)
	if not hyperlink then return end
	local sName, sLink, iQuality = GetItemInfo(hyperlink)
	if (quality == nil) then quality = iQuality or -1 end
	if (name == nil) then name = sName or "unknown ("..hyperlink..")" end
	local _, _, _, color = GetItemQualityColor(quality)
	return color.. "|H"..hyperlink.."|h["..name.."]|h|r"
end

BtmScan.GetGSC = function (money)
	if (money == nil) then money = 0 end
	local g = math.floor(money / 10000)
	local s = math.floor((money - (g*10000)) / 100)
	local c = math.ceil(money - (g*10000) - (s*100))
	return g,s,c
end

-- formats money text by color for gold, silver, copper
BtmScan.GSC = function (money, exact, dontUseColorCodes)
	if (type(money) ~= "number") then return end

	local TEXT_NONE = "0"

	local GSC_GOLD="ffd100"
	local GSC_SILVER="e6e6e6"
	local GSC_COPPER="c8602c"
	local GSC_START="|cff%s%d%s|r"
	local GSC_PART=".|cff%s%02d%s|r"
	local GSC_NONE="|cffa0a0a0"..TEXT_NONE.."|r"

	if (not money) then money = 0 end
	if (not exact) and (money >= 10000) then money = math.floor(money / 100 + 0.5) * 100 end
	local g, s, c = BtmScan.GetGSC(money)

	local gsc = ""
	if (not dontUseColorCodes) then
		local fmt = GSC_START
		if (g > 0) then gsc = gsc..string.format(fmt, GSC_GOLD, g, 'g') fmt = GSC_PART end
		if (s > 0) or (c > 0) then gsc = gsc..string.format(fmt, GSC_SILVER, s, 's') fmt = GSC_PART end
		if (c > 0) then gsc = gsc..string.format(fmt, GSC_COPPER, c, 'c') end
		if (gsc == "") then gsc = GSC_NONE end
	else
		if (g > 0) then gsc = gsc .. g .. "g " end
		if (s > 0) then gsc = gsc .. s .. "s " end
		if (c > 0) then gsc = gsc .. c .. "c " end
		if (gsc == "") then gsc = TEXT_NONE end
	end
	return gsc
end

local GSC_GOLD="ffd100"
local GSC_SILVER="e6e6e6"
local GSC_COPPER="c8602c"

local GSC_3 = "|cff%s%d|cff000000.|cff%s%02d|cff000000.|cff%s%02d|r"
local GSC_2 = "|cff%s%d|cff000000.|cff%s%02d|r"
local GSC_1 = "|cff%s%d|r"

function BtmScan.Coins(money)
	money = math.floor(tonumber(money) or 0)
	local g = math.floor(money / 10000)
	local s = math.floor(money % 10000 / 100)
	local c = money % 100

	if (g>0) then
		return (GSC_3):format(GSC_GOLD, g, GSC_SILVER, s, GSC_COPPER, c)
	elseif (s>0) then
		return (GSC_2):format(GSC_SILVER, s, GSC_COPPER, c)
	end
	return (GSC_1):format(GSC_COPPER, c)
end
local coins = BtmScan.Coins

BtmScan.Print = function (text, cRed, cGreen, cBlue, cAlpha, holdTime)
	local frameIndex = BtmScan.getFrameIndex()

	if (cRed and cGreen and cBlue) then
		if getglobal("ChatFrame"..frameIndex) then
			getglobal("ChatFrame"..frameIndex):AddMessage(text, cRed, cGreen, cBlue, cAlpha, holdTime)

		elseif (DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(text, cRed, cGreen, cBlue, cAlpha, holdTime)
		end

	else
		if getglobal("ChatFrame"..frameIndex) then
			getglobal("ChatFrame"..frameIndex):AddMessage(text, 0.9, 0.6, 0.2)

		elseif (DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(text, 0.9, 0.6, 0.2)
		end
	end
end

BtmScan.getFrameNames = function (index)
	local frames = {}
	local frameName = ""

	for i=1, 10 do
		local name, fontSize, r, g, b, a, shown, locked, docked = GetChatWindowInfo(i)

		if ( name == "" ) then
			if (i == 1) then
				frames[string.lower(GENERAL)] = 1

			elseif (i == 2) then
				frames[string.lower(COMBAT_LOG)] = 2
			end

		else
			frames[string.lower(name)] = i
		end
	end

	if (type(index) == "number") then
		local name, fontSize, r, g, b, a, shown, locked, docked = GetChatWindowInfo(index)

		if ( name == "" ) then
			if (index == 1) then
				frameName = GENERAL

			elseif (index == 2) then
				frameName = COMBAT_LOG
			end

		else
			frameName = name
		end
	end

	return frames, frameName
end

BtmScan.getFrameIndex = function ()
	if not BtmScanData.printFrame then return 1 end
	return tonumber(BtmScanData.printFrame) or 1
end

BtmScan.setFrame = function (frame, chatprint)
	local frameNumber
	local frameVal
	frameVal = tonumber(frame)

	--If no arguments are passed, then set it to the default frame.
	if not (frame) then
		frameNumber = 1

	--If the frame argument is a number then set our chatframe to that number.
	elseif ((frameVal) ~= nil) then
		frameNumber = frameVal

	--If the frame argument is a string, find out if there's a chatframe with that name, and set our chatframe to that index. If not set it to the default frame.
	elseif (type(frame) == "string") then
		local allFrames = BtmScan.getFrameNames()
		if (allFrames[string.lower(frame)]) then
			frameNumber = allFrames[frame]
		else
			frameNumber = 1
		end

	--If the argument is something else, set our chatframe to its default value.
	else
		frameNumber = 1
	end

	local _, frameName

	_, frameName = BtmScan.getFrameNames(frameNumber)
	if (BtmScan.getFrameIndex() ~= frameNumber) then
		BtmScan.Print(tr("BottomScanner's messages will now print on the \"%1\" chat frame", frameName))
	end

	BtmScanData.printFrame = frameNumber
	BtmScan.Print(tr("BottomScanner's messages will now print on the \"%1\" chat frame", frameName))
end

BtmScan.Log = function (msg)
	-- Make sure the current zone is loaded and has defaults
	BtmScan.GetZoneConfig("log")

	if (not data.logText) then data.logText = {} end
	table.insert(data.logText, { time(), msg })
	if (not BtmScan.LogFrame) then BtmScan.CreateLogWindow() end
	if (BtmScan.LogFrame) then BtmScan.LogFrame.Update() end
end

-- Command function handles the processing of slash commands.
BtmScan.Command = function (msg)
	local i,j, ocmd, oparam = string.find(msg, "^([^ ]+) (.*)$")
	local i,j, cmd, param = string.find(string.lower(msg), "^([^ ]+) (.*)$")
	if (not i) then cmd = msg param = nil oparam = nil end
	if (oparam == "") then param = nil oparam = nil end

	-- Make sure the current zone is loaded and has defaults
	BtmScan.GetZoneConfig("command")

	local help = false
	local known = false
	if (not cmd or cmd == "config" or cmd == "") then
		BtmScan.Settings.Toggle()
		known = true
	elseif (cmd == "load") then
		if (param == "always") or (param == "never") or (param == "auctionhouse") then
			Stubby.SetConfig("BtmScan", "LoadType", param)
			BtmScan.Print(tr("Setting BottomScanner to %1 load for this toon",param))
		end
		known = true
	elseif ((cmd == "end") or (cmd == "stop") or (cmd == "cancel")) then
		known = true
		BtmScan.EndScan()
	elseif ((cmd == "begin") or (cmd == "start") or (cmd == "scan")) then
		known = true
		BtmScan.BeginScan()
	elseif (cmd == "help") then
		known = true
		help = true
	end

	for pos, name in ipairs(BtmScan.evaluators) do
		local valuator = BtmScan.evaluators[name]
		if (name==cmd and valuator.CommandHandler) then
			valuator.CommandHandler(msg)
			help=false
			known = true
		end
	end
	
	if known == false then
		BtmScan.Print(tr("BottomScanner: %1 [%2]", tr("Unknown command"), cmd))
		help = true
	end
	
	if (help) then
		BtmScan.Print(tr("BottomScanner help:"))
		BtmScan.Print(tr(" %1 [%2]", "config", tr("Opens up the configuration screen")))
		BtmScan.Print(tr(" %1 [%2]", "begin", tr("Begins the scanning process (must have AH open)")))
		BtmScan.Print(tr(" %1 [%2]", "end", tr("Ends the scanning process")))
		BtmScan.Print(tr(" %1 [%2]", "load (always|never|auctionhouse)", tr("Set when BottomScanner will load")))

		for pos, name in ipairs(BtmScan.evaluators) do
			local valuator = BtmScan.evaluators[name]
			if (valuator.PrintHelp) then
				valuator.PrintHelp()
			end
		end
		for filterPos, filterName in ipairs(BtmScan.filters) do
			local filter=BtmScan.filters[filterName]
			if (filter.PrintHelp) then
				filter.PrintHelp()
			end
		end

	end
end

BtmScan.BeginScan = function ()
	if (BtmScan.scanning ~= true) then
		BtmScan.PlayButton:SetButtonState("PUSHED", true)
		BtmScan.Log(tr("BottomScanner is now scanning"))
		BtmScan.scanning = true
		BtmScan.interval = 1
	end
end
BtmScan.EndScan = function ()
    if (BtmScan.scanning == true) then
		BtmScan.PlayButton:SetButtonState("NORMAL")
		BtmScan.Log(tr("BottomScanner is stopping scanning"))
		BtmScan.scanning = false
		BtmScan.resume = nil
	end
end

BtmScan.GetDepositCost = function (itemID, count, rate)
	if (not rate) then rate = BtmScan.depositRate end
	local vendorValue = BtmScan.GetVendorPrice(itemID, count)
	if (not vendorValue) then return 0 end
	local baseDeposit = math.floor(vendorValue * rate * 3) -- 12 hr auction
	return baseDeposit * 2 -- 24 hour auction
end

BtmScan.GetVendorPrice = function(itemID, count)
	local vendorValue = BtmScan.VendorPrices[itemID]
	if (not vendorValue and Informant and Informant.GetItem) then
		local itemInfo = Informant.GetItem(itemID, true)
		if (itemInfo and itemInfo.sell) then
			vendorValue = tonumber(itemInfo.sell) or 0
		end
	end
	if ((not vendorValue) and GetSellValue) then
		vendorValue = GetSellValue(itemID)
	end
	if not vendorValue then return end
	if (count and count > 1) then vendorValue = vendorValue * count end
	return vendorValue
end

BtmScan.ConfigZone = function (whence)
	local realmName = GetRealmName()
	local currentZone = GetMinimapZoneText()
	local factionGroup

	if (not BtmScanData.factions) then
		BtmScan.Print(tr("BottomScanner: %1", tr("Zone data uninitialized: %1", whence)))
		return
	end
	if (BtmScanData.factions[currentZone]) then
		factionGroup = BtmScanData.factions[currentZone]
	else
		SetMapToCurrentZone()
		local map = GetMapInfo()
		if ((map == "Tanaris") or (map == "Winterspring") or (map == "Stranglethorn")) then
			factionGroup = "Neutral"
		end
		BtmScanData.factions[currentZone] = factionGroup
	end

	if not factionGroup then factionGroup = UnitFactionGroup("player") end
	if not factionGroup then return end
	if (factionGroup == "Neutral") then
		BtmScan.cutRate = 0.15
		BtmScan.depositRate = 0.25
	else
		BtmScan.cutRate = 0.05
		BtmScan.depositRate = 0.05
	end

	return realmName.."-"..factionGroup
end

-- Gets the configdata for the current zone
BtmScan.GetZoneConfig = function (whence)
	local newZone = BtmScan.ConfigZone(whence.."getzone")
	BtmScanData.refresh = BtmScan.Settings.GetSetting("scan.reload.interval") -- Page refresh time
	if not newZone then
		BtmScan.Print(tr("BottomScanner: %1", tr("Unable to get config zone: %1", whence)))
		dataZone = ""
		data = {}
	elseif (newZone ~= dataZone) then
		BtmScan.Print(tr("BottomScanner: %1", tr("Switching to %1 config zone", newZone)))
		dataZone = newZone
		if (not BtmScanData.config[dataZone]) then BtmScanData.config[dataZone] = {} end
		data = BtmScanData.config[dataZone]

		if (not BtmScanData.version or BtmScanData.version < 115) then
			for i,j in pairs(BtmScanData) do
				-- Copy realm specific data to realm element
				if (i ~= "config" and i ~= "unlocked" and
				    i ~= "refresh" and i ~= "factions" and
				    i ~= "printFrame" and i ~= "version" and
				    not data[i]) then
					data[i] = j
					BtmScanData[i] = nil
				end
			end
			BtmScanData.version = 115
		end
	else
		return
	end
	if (not data.enchLevel) then data.enchLevel = 300 end --Shows all disenchant deals regardless of user's enchanting level

	if (not data.tooltipOn) then
		data.tooltipOn = true	 --Sets the tooltip as on by default
	end
end

local tooltipItem = {}
BtmScan.TooltipHook = function (funcVars, retVal, frame, name, link, quality, count, price,force,hyperlink, additional)
	--If the tooltip option is disabled, then disable the tooltip
	if (not BtmScan.Settings.GetSetting("show.tooltip")) then return end

	-- Create the deReagentTable once only if it does not exist
	if not BtmScan.deReagentTable and Enchantrix and Enchantrix.Util and Enchantrix.Util.CreateReagentPricingTable then
		BtmScan.deReagentTable = Enchantrix.Util.CreateReagentPricingTable()
	end

	local reserve = BtmScan.Settings.GetSetting("global.reserve")
	local maxprice = BtmScan.Settings.GetSetting("global.maxprice")
	local itemConfigTable = BtmScan.Settings.GetSetting("itemconfig.list")

	local item = tooltipItem
	item.link = link


	-- If this item exists
	if (item.link) then
		item.id, item.suffix, item.enchant, item.seed = BtmScan.BreakLink(item.link)
		if (not item.id) then return end -- Not an "item"

		item.name, _, item.qual, item.ilevel, item.level, _, _, _, _, item.tex = GetItemInfo(item.link)
		--GetItemInfo will return nil if the item data is not in your local cache
		--So we need to make sure that we have the data before proceeding, or a nil error may occur later
		if not item.name or not item.qual or not item.ilevel or not item.level or not item.tex then
			return
		end
		item.count = count
		item.use = 1
		item.inc = 0
		item.min = 0
		item.buy = 0
		item.bid = 0

		if (additional and additional[0] == "AuctionPrices") then
			item.min = additional[2]
			item.bid = additional[3]
			item.inc = item.bid - item.min
			item.buy = additional[1]
		end

		item.sig = ("%d:%d:%d"):format(item.id, item.suffix, item.enchant)

		-- read ItemConfig
		local itemconfig = itemConfigTable[item.sig]
		if (itemconfig) then
--			BtmScan.Print(" use itemconfig "..itemconfig)
			itemconfig = BtmScan.unpackItemConfiguration(itemconfig)
		else
			itemconfig = {}
		end
		item.itemconfig=itemconfig


		-- Check that we're not ignoring this item
		if itemconfig.isIgnore then
			-- TODO: Do tooltip that we are ignoring
			return
		end

		-- Determine whether buys/bid are valid
		item.canbid = true
		item.canbuy = true
		local balance = GetMoney()

		if (not BtmScan.Settings.GetSetting("allow.bid")) then
			if (not (TopScanActive and BtmScan.Settings.GetSetting("override.nobid"))) then item.canbid = false end
		end
		if (not BtmScan.Settings.GetSetting("allow.buy")) then item.canbuy = false end
		if (item.canbid and balance - item.bid < reserve) then
			tt("Bid exceeds reserve")
			item.canbid = false
			item.canbuy = false
		elseif (item.canbuy and balance - item.buy < reserve) then
			tt("Buy exceeds reserve")
			item.canbuy = false
		end
		if (item.canbid and item.bid > maxprice) then
			tt("Bid exceeds maxprice")
			item.canbid = false
			item.canbuy = false
		elseif (item.canbuy and item.buy > maxprice) then
			tt("Buy exceeds maxprice")
			item.canbuy = false
		elseif (item.canbuy and item.buy == 0) then
			-- can't buy if no buyout
			item.canbuy = false
		end
		local autoignore = BtmScan.NoPrompt[item.sig]
		if (autoignore) then
			if (item.canbid and item.bid >= autoignore) then
				tt("Auto-ignoring item")
				item.canbid = false
				item.canbuy = false
			elseif (item.canbuy and item.buy >= autoignore) then
				tt("Auto-ignoring buyout")
				item.canbuy = false
			end
		end

		-- Initialize the purchasing variables
		item.purchase = 0   -- The amount to purchase for
		item.reason = ""    -- The reason why we are purchasing
		item.what = ""      -- The component that is making the purchase
		item.profit = 0     -- The projected profit amount
		item.valuation = 0  -- The estimated value of this item

		item.force = false  -- Forcefully purchase now!
		item.ignore = false -- Forcefully ignore this item!

		-- Run through all the evaluators to find the best purchase order
		local purchasable = BtmScan.EvaluateItem(item, true)
		if purchasable then
			if item.force then
				if balance - item.purchase < 0 then
					tt("Not enough funds")
					purchasable = false
				end
			else
				if balance - item.purchase < reserve then
					tt("Not enough reserve")
					purchasable = false
				end
				if item.purchase > maxprice then
					tt("Price > MaxPrice")
					purchasable = false
				end
			end
		end
		local bids = BtmScan.Settings.GetSetting("bid.list")
		if (bids) then
			local lastbid = bids[item.sig..":"..item.seed.."x"..item.count]
			if (lastbid) then
				local whyBuy =  lastbid[1]
				local howMuch = lastbid[2]
				local bidType = tr("bid")
				if lastbid[3] then bidType = tr("bought") end
				local tStamp =  lastbid[4]
				local ago = ""
				if (tStamp) then
					local elapsed = time() - tStamp
					ago = tr(" (%1 ago)", SecondsToTime(elapsed))
				end
				tt("  "..tr("Last %1 for %2%3", bidType, whyBuy, ago), tonumber(howMuch) or 0)
			end
		end
	end
end

BtmScan.DoTooltip = function ()
	if (not this.lineID) then return end

	local i = this.lineID
	local line = BtmScan.LogFrame.Lines[i]:GetText()

	local itemID, itemRand, itemEnch, itemUniq, itemName, wholeLink, count, cost = BtmScan.BreakLink(line)
	if (itemID and itemID > 0) then
		--GameTooltip:SetOwner(BtmScan.LogFrame, "ANCHOR_NONE")
		GameTooltip:SetOwner(AuctionFrameCloseButton, "ANCHOR_NONE")
		GameTooltip:SetHyperlink(wholeLink)
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPLEFT", "AuctionFrame", "TOPRIGHT", 10, -20)
		if (EnhTooltip) then
			EnhTooltip.TooltipCall(GameTooltip, itemName, wholeLink, -1, count, cost)
		end
	end
end
BtmScan.PurchaseTooltip = function()
	local item = BtmScan.Prompt.item
	if (item.link) then
		if (item.id and item.id > 0) then
			GameTooltip:SetOwner(AuctionFrameCloseButton, "ANCHOR_NONE")
			GameTooltip:SetHyperlink(item.link)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("TOPRIGHT", "BtmScanPromptItem", "TOPLEFT", -10, -20)
			if (EnhTooltip) then
				EnhTooltip.TooltipCall(GameTooltip, item.name, item.link, -1, item.count, item.purchase)
			end
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("TOPRIGHT", "BtmScanPromptItem", "TOPLEFT", -10, -20)
		end
	end
end
BtmScan.UndoTooltip = function ()
	GameTooltip:Hide()
end

function BtmScan.AuctionFrameTabClickHook(_,_, index)
	if (not index) then index = this:GetID() end

	local tab = getglobal("AuctionFrameTab"..index)
	if (tab and tab:GetName() == "AuctionFrameTabBtmScan") then
		AuctionFrameTopLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopLeft")
		AuctionFrameTop:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-Top")
		AuctionFrameTopRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopRight")
		AuctionFrameBotLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-BotLeft")
		AuctionFrameBot:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-Bot")
		AuctionFrameBotRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-BotRight")
		BtmScan.LogParent:SetPoint("TOPLEFT", "AuctionFrame", "TOPLEFT", 10,-70)
		BtmScan.LogParent:Show()
		AuctionFrameMoneyFrame:Hide()
	else
		BtmScan.LogParent:Hide()
		AuctionFrameMoneyFrame:Show()
	end
end


BtmScan.GetDisplayPrice = function(total, count)
	local totalCoins = BtmScan.Coins(total, true)
	local result = totalCoins
	if (count > 1) and not (displayType == "total") then
		local unitCoins = BtmScan.Coins((total / count), true)
		local displayType = BtmScan.Settings.GetSetting("price.display")
		if (displayType == "unit") or (count == 1) then
			result = unitCoins
		elseif (displayType == "total_unit") then
			result = totalCoins .. " / " .. unitCoins
		else
			result = unitCoins .. " / " .. totalCoins
		end	
	end
	return result
end


BtmScan.PromptPurchase = function(item)
	BtmScan.scanStage = 3
	BtmScan.Prompt.item = item

	-- format the profit percentage as an integer (can still be huge)
	local Vi, Vf, Vc = item.purchase, item.valuation, item.count

	local profit = Vf - Vi
	local roi = math.floor( (100 * profit / Vi) + 0.5 )
	local disc = math.floor( (100 * (1 - Vi / Vf)) + 0.5 )

	local bidText, BidText = "purchase", "Buyout"
	if (not item.canbuy or item.purchase < item.buy) then bidText, BidText = "bid on", "Bid" end

	local hours
	if (item.remain == 4) then hours = 48
	elseif (item.remain == 3) then hours = 12
	elseif (item.remain == 2) then hours = 2
	elseif (item.remain == 1) then hours = 0.5
	end

	BtmScan.Prompt.Lines[1]:SetLine(tr("Do you want to %1:", bidText))
	BtmScan.Prompt.Lines[2]:SetLine("  "..item.link.." x"..Vc)
	BtmScan.Prompt.Lines[3]:SetLine("  "..tr("Seller: %1, Remain: %2h", item.owner, hours))
	BtmScan.Prompt.Lines[4]:SetLine("  "..tr("%1 price:", BidText), BtmScan.GetDisplayPrice(Vi, Vc))
	BtmScan.Prompt.Lines[5]:SetLine("  "..tr("Purchasing for:"), item.reason)
	BtmScan.Prompt.Lines[6]:SetLine("  "..tr("Valuation estimate:"), BtmScan.GetDisplayPrice(Vf, Vc))
	BtmScan.Prompt.Lines[7]:SetLine("  "..tr("Potential profit:"), BtmScan.GetDisplayPrice(profit, Vc))
	BtmScan.Prompt.Lines[8]:SetLine("  "..tr("Return on investment:"), roi.."%")
	BtmScan.Prompt.Lines[9]:SetLine("  "..tr("Discounted rate:"), disc.."%")
	BtmScan.Prompt.Lines[10]:SetLine("  "..tr("Profit above requirements:"), BtmScan.GetDisplayPrice(item.profit, Vc))
	BtmScan.Prompt.Item:GetNormalTexture():SetTexture(item.tex)
	BtmScan.Prompt.Item:GetNormalTexture():SetTexCoord(0,1,0,1)
	if BtmScan.Settings.GetSetting("playSound") then PlaySoundFile("Interface\\AddOns\\btmScan\\Sounds\\DoorBell.mp3") end
	BtmScan.Prompt:Show()
end


local function checkItem(pos, item)
	local isCorrect = false
	local link = GetAuctionItemLink("list", pos)
	if (link == item.link) then
		local aName,aTex,aCount,aQual,aUse,aLvl,aMin,aInc,aBuy,aCur,aHigh,aOwner = GetAuctionItemInfo("list", pos)
		if (aCount == item.count) then
			if (item.purchase == item.buy) then
				if (aBuy == item.buy) then
					isCorrect = true
				end
			else
				if (aCur and aCur > 0) then
					if (aCur + aInc <= item.purchase) then
						isCorrect = true
					end
				elseif (aMin <= item.purchase) then
					isCorrect = true
				end
			end
		end
	end
	return isCorrect
end

function BtmScan.ClosePrompt()
	if BtmScan.Prompt and BtmScan.Prompt:IsShown() then
		BtmScan.Prompt:Hide()
		BtmScan.scanStage = 2
		BtmScan.timer = 0
		BtmScan.pageScan = 0.001
	end
end

BtmScan.PerformPurchase = function()
	local item = BtmScan.Prompt.item

	-- Verify first that the item is still there
	local there = false
	local pageCount, totalCount = GetNumAuctionItems("list")
	local i = item.pos
	if (i <= pageCount) then
		for j = i, 1, -1 do
			there = checkItem(j, item)
			if (there) then
				i = j
				break
			end
		end
	end

	if (not there) then
		BtmScan.Prompt:Hide()
		BtmScan.Log(tr("Warning: Unable to make purchase of %1. Can't find on current page.", item.link))
		BtmScan.scanStage = 2
		return
	end

	local buyout, btext, ptext = false, "", "Bidding on"
	if item.purchase == item.buy then 
		buyout = true 
		btext = " ("..tr("buyout")..")" 
		ptext = "Purchasing"
	end
	
	BtmScan.Log(tr(ptext.." %1x%2 at %3 for %4%5", item.link, item.count, BtmScan.GSC(item.purchase,1), item.what, btext))
	PlaceAuctionBid("list", i, item.purchase)
	local bids = BtmScan.Settings.GetSetting("bid.list")
	bids[item.sig..":"..item.seed.."x"..item.count] = { item.what, item.purchase, buyout, time() }

	BtmScan.Prompt:Hide()
	BtmScan.scanStage = 2
	BtmScan.timer = 0
	BtmScan.pageScan = 0.001
	if BeanCounter and BeanCounter.Private.storeReasonForBid then
		CallBackString = string.join(";", tostring(item.link), tostring(item.owner), tostring(item.count), tostring(item.buy), tostring(item.purchase), tostring(item.what))
	end
end

BtmScan.CancelPurchase = function()
	local item = BtmScan.Prompt.item
	local price = math.floor(item.purchase / item.count)
	if (not BtmScan.NoPrompt[item.sig]) or (price < BtmScan.NoPrompt[item.sig]) then
		BtmScan.NoPrompt[item.sig] = price
		BtmScan.Print(tr("BottomScanner autoignoring %1 for more than %2 this session.", item.link, BtmScan.GSC(price)))
	end
	BtmScan.scanStage = 2
	BtmScan.timer = 0
	BtmScan.pageScan = 0.001
	BtmScan.Prompt:Hide()
end

BtmScan.IgnorePurchase = function()
	local item = BtmScan.Prompt.item
	item.itemconfig.isIgnore=true
	-- BtmScan.Print(" ignoreStatusAfter:"..tostring(BtmScan.Prompt.item.itemconfig.isIgnore))


--	local ignore = BtmScan.Settings.GetSetting("ignore.list")
--	ignore[item.sig] = true
	BtmScan.Print(tr("BottomScanner will now %1 %2", tr("ignore"), item.link))
	BtmScan.scanStage = 2
	BtmScan.timer = 0
	BtmScan.pageScan = 0.001
	BtmScan.Prompt:Hide()
	BtmScan.storeItemConfig(item.itemconfig, item.sig)
end

BtmScan.IgnorePurchaseModule = function()
	local item = BtmScan.Prompt.item
	local ignoreString = item.itemconfig.ignoreModuleList

	if (not item.itemconfig.ignoreModuleList) then
		item.itemconfig.ignoreModuleList=item.reason
	else
		item.itemconfig.ignoreModuleList=item.itemconfig.ignoreModuleList..","..item.reason
	end
	BtmScan.Print(tr("BottomScanner will now %1 %2 for module %3", tr("ignore"), item.link,item.reason))
	BtmScan.scanStage = 2
	BtmScan.timer = 0
	BtmScan.pageScan = 0.001
	BtmScan.Prompt:Hide()
	BtmScan.storeItemConfig(item.itemconfig, item.sig)
end

BtmScan.InputData = {
	dataField = nil,
	callBack = nil
}
BtmScan.InputShow = function ()
	if (BtmScan.InputData.dataField) then
		BtmScan.Input.Box:SetText(data[BtmScan.InputData.dataField] or "")
	else
		BtmScan.Input.Box:SetText("")
	end
end
BtmScan.InputDone = function ()
	if (BtmScan.InputData.dataField) then
		data[BtmScan.InputData.dataField] = BtmScan.Input.Box:GetText()
	end
	if (BtmScan.InputData.callBack) then
		BtmScan.InputData.callBack(BtmScan.Input.Box:GetText())
	end
	BtmScan.Input:Hide()
end
BtmScan.EditData = function (dataField, callBack)
	BtmScan.InputData.dataField = dataField
	BtmScan.InputData.callBack = callBack
	BtmScan.Input:Show()
end
BtmScan.InputUpdate = function()
	BtmScan.Input.Scroll:UpdateScrollChildRect()
--	local bar = getglobal(this:GetParent():GetName().."ScrollBar")
--	local min, max
--	min, max = bar:GetMinMaxValues()
--	if (max > 0 and this.max ~= max) then
--		this.max = max
--		bar:SetValue(max)
--	end
end
BtmScan.ToggleScan = function()
	if (BtmScan.scanning) then
		BtmScan.EndScan()
	else
		BtmScan.BeginScan()
	end
end

BtmScan.Frame = CreateFrame("Frame")
BtmScan.Frame:RegisterEvent("ADDON_LOADED")
BtmScan.Frame:RegisterEvent("AUCTION_HOUSE_CLOSED")
BtmScan.Frame:SetScript("OnEvent", BtmScan.OnEvent)
BtmScan.Frame:SetScript("OnUpdate", BtmScan.OnUpdate)

BtmScan.Prompt = CreateFrame("Frame", "", UIParent)
BtmScan.Prompt:Hide()
BtmScan.Prompt:SetPoint("TOP", "UIParent", "TOP", 0, -100)
BtmScan.Prompt:SetFrameStrata("DIALOG")
BtmScan.Prompt:SetHeight(220)
BtmScan.Prompt:SetWidth(400)
BtmScan.Prompt:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 9, right = 9, top = 9, bottom = 9 }
})
BtmScan.Prompt:SetBackdropColor(0,0,0, 0.8)
BtmScan.Prompt:SetMovable(true)

BtmScan.Prompt.Drag = CreateFrame("Button", "", BtmScan.Prompt)
BtmScan.Prompt.Drag:SetPoint("TOPLEFT", BtmScan.Prompt, "TOPLEFT", 10,-5)
BtmScan.Prompt.Drag:SetPoint("TOPRIGHT", BtmScan.Prompt, "TOPRIGHT", -10,-5)
BtmScan.Prompt.Drag:SetHeight(6)
BtmScan.Prompt.Drag:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
BtmScan.Prompt.Drag:SetScript("OnMouseDown", function() BtmScan.Prompt:StartMoving() end)
BtmScan.Prompt.Drag:SetScript("OnMouseUp", function() BtmScan.Prompt:StopMovingOrSizing() end)

BtmScan.Prompt.Item = CreateFrame("Button", "BtmScanPromptItem", BtmScan.Prompt)
BtmScan.Prompt.Item:SetNormalTexture("Interface\\Buttons\\UI-Slot-Background")
BtmScan.Prompt.Item:GetNormalTexture():SetTexCoord(0,0.640625, 0,0.640625)
BtmScan.Prompt.Item:SetPoint("TOPLEFT", BtmScan.Prompt, "TOPLEFT", 15, -15)
BtmScan.Prompt.Item:SetHeight(37)
BtmScan.Prompt.Item:SetWidth(37)
BtmScan.Prompt.Item:SetScript("OnEnter", BtmScan.PurchaseTooltip)
BtmScan.Prompt.Item:SetScript("OnLeave", BtmScan.UndoTooltip)
BtmScan.Prompt.Item:SetScript("OnClick", function(this,button)
	local item = BtmScan.Prompt.item
	if item and item.link and GetItemInfo(item.link) then
		SetItemRef(item.link, item.link, button)
	end
end)
	

BtmScan.Prompt.Lines = {}
for i = 1, 10 do
	BtmScan.Prompt.Lines[i] = BtmScan.Prompt:CreateFontString("BtmScanPromptLine"..i, "HIGH", "GameFontHighlight")
	local path, size, flags = BtmScan.Prompt.Lines[i]:GetFont()
	if (i == 1) then
		BtmScan.Prompt.Lines[i]:SetPoint("TOPLEFT", BtmScan.Prompt.Item, "TOPRIGHT", 5, 5)
		BtmScan.Prompt.Lines[i]:SetFont(path, 16, flags)
	else
		BtmScan.Prompt.Lines[i]:SetPoint("TOPLEFT", BtmScan.Prompt.Lines[i-1], "BOTTOMLEFT", 0,-2)
		if (i == 2) then
			BtmScan.Prompt.Lines[i]:SetFont(path, 14, flags)
		else
			BtmScan.Prompt.Lines[i]:SetFont(path, 13, flags)
		end
	end
	BtmScan.Prompt.Lines[i]:SetPoint("RIGHT", BtmScan.Prompt, "RIGHT", -20, 0)
	BtmScan.Prompt.Lines[i]:SetJustifyH("LEFT")
	BtmScan.Prompt.Lines[i]:SetJustifyV("CENTER")
	BtmScan.Prompt.Lines[i]:SetText("")
	BtmScan.Prompt.Lines[i]:Show()
	BtmScan.Prompt.Lines[i].Right = BtmScan.Prompt:CreateFontString("BtmScanPromptLine"..i.."Right", "HIGH", "GameFontHighlight")
	BtmScan.Prompt.Lines[i].Right:SetAllPoints(BtmScan.Prompt.Lines[i])
	BtmScan.Prompt.Lines[i].Right:SetJustifyH("RIGHT")
	BtmScan.Prompt.Lines[i].Right:SetJustifyV("CENTER")
	BtmScan.Prompt.Lines[i].Right:SetFont(path, 14, flags)
	BtmScan.Prompt.Lines[i].SetLine = function(self, left, right)
		self:SetText(left or "")
		self.Right:SetText(right or "")
	end
end

BtmScan.Prompt.Yes = CreateFrame("Button", "", BtmScan.Prompt, "OptionsButtonTemplate")
BtmScan.Prompt.Yes:SetText(tr("Yes"))
BtmScan.Prompt.Yes:SetPoint("BOTTOMRIGHT", BtmScan.Prompt, "BOTTOMRIGHT", -10, 10)
BtmScan.Prompt.Yes:SetScript("OnClick", BtmScan.PerformPurchase)
BtmScan.Prompt.No = CreateFrame("Button", "", BtmScan.Prompt, "OptionsButtonTemplate")
BtmScan.Prompt.No:SetText(tr("No"))
BtmScan.Prompt.No:SetPoint("BOTTOMRIGHT", BtmScan.Prompt.Yes, "BOTTOMLEFT", -5, 0)
BtmScan.Prompt.No:SetScript("OnClick", BtmScan.CancelPurchase)

BtmScan.Prompt.Ignore = CreateFrame("Button", "", BtmScan.Prompt, "OptionsButtonTemplate")
BtmScan.Prompt.Ignore:SetText(tr("Ignore"))
BtmScan.Prompt.Ignore:SetPoint("BOTTOMRIGHT", BtmScan.Prompt.No, "BOTTOMLEFT", -5, 0)
BtmScan.Prompt.Ignore:SetScript("OnClick", BtmScan.IgnorePurchase)

BtmScan.Prompt.IgnorePurchase = CreateFrame("Button", "", BtmScan.Prompt, "OptionsButtonTemplate")
BtmScan.Prompt.IgnorePurchase:SetText(tr("IgnoreMod"))
BtmScan.Prompt.IgnorePurchase:SetPoint("BOTTOMLEFT", BtmScan.Prompt, "BOTTOMLEFT", 5, 30)
BtmScan.Prompt.IgnorePurchase:SetScript("OnClick", BtmScan.IgnorePurchaseModule)
BtmScan.Prompt.lastbutton=BtmScan.Prompt.IgnorePurchase

BtmScan.Input = CreateFrame("Frame", "", UIParent)
BtmScan.Input:Hide()
BtmScan.Input:SetPoint("CENTER", "UIParent", "CENTER")
BtmScan.Input:SetFrameStrata("DIALOG")
BtmScan.Input:SetHeight(280)
BtmScan.Input:SetWidth(500)
BtmScan.Input:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 9, right = 9, top = 9, bottom = 9 }
})
BtmScan.Input:SetBackdropColor(0,0,0, 0.8)
BtmScan.Input:SetScript("OnShow", BtmScan.InputShow)

BtmScan.Input.Done = CreateFrame("Button", "", BtmScan.Input, "OptionsButtonTemplate")
BtmScan.Input.Done:SetText(tr("Done"))
BtmScan.Input.Done:SetPoint("BOTTOMRIGHT", BtmScan.Input, "BOTTOMRIGHT", -10, 10)
BtmScan.Input.Done:SetScript("OnClick", BtmScan.InputDone)

BtmScan.Input.Scroll = CreateFrame("ScrollFrame", "BtmScanInputScroll", BtmScan.Input, "UIPanelScrollFrameTemplate")
BtmScan.Input.Scroll:SetPoint("TOPLEFT", BtmScan.Input, "TOPLEFT", 20, -20)
BtmScan.Input.Scroll:SetPoint("RIGHT", BtmScan.Input, "RIGHT", -30, 0)
BtmScan.Input.Scroll:SetPoint("BOTTOM", BtmScan.Input.Done, "TOP", 0, 10)

BtmScan.Input.Box = CreateFrame("EditBox", "BtmScanEditBox", BtmScan.Input.Scroll)
BtmScan.Input.Box:SetWidth(460)
BtmScan.Input.Box:SetHeight(85)
BtmScan.Input.Box:SetMultiLine(true)
BtmScan.Input.Box:SetAutoFocus(true)
BtmScan.Input.Box:SetFontObject(GameFontHighlight)
BtmScan.Input.Box:SetScript("OnEscapePressed", BtmScan.InputDone)
BtmScan.Input.Box:SetScript("OnTextChanged", BtmScan.InputUpdate)

BtmScan.Input.Scroll:SetScrollChild(BtmScan.Input.Box)

BtmScan.CreateLogWindow = function()
	if (BtmScan.LogFrame) then return end
	if (not AuctionFrame) then return end
	if (not ((Auctioneer and Auctioneer.UI) or (AucAdvanced and AucAdvanced.AddTab))) then return end

	local LOG_LINES = 22

	-- Make sure the current zone is loaded and has defaults
	BtmScan.GetZoneConfig("createlog")

	BtmScan.LogParent = CreateFrame("Frame", "", AuctionFrame)
	BtmScan.LogParent:SetPoint("TOPLEFT", "AuctionFrame", "TOPLEFT", 10,-70)
--	BtmScan.LogParent:SetFrameStrata("BACKGROUND")
	BtmScan.LogParent:SetWidth(822)
	BtmScan.LogParent:SetHeight(370)
	BtmScan.LogParent:SetBackdrop({
		bgFile = "Interface\\AddOns\\BtmScan\\Textures\\Back",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 128, edgeSize = 16,
		insets = { left = 6, right = 6, top = 6, bottom = 6
	}})
--	BtmScan.LogParent:SetBackdropColor(0,0,0, 1)
	BtmScan.LogParent:Hide()

	BtmScan.LogFrame = CreateFrame("ScrollFrame", "BtmScanLogFrame", BtmScan.LogParent, "FauxScrollFrameTemplate")
	BtmScan.LogFrame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 4,
		insets = { left = 6, right = 6, top = 6, bottom = 6
	}})
	BtmScan.LogFrame:SetBackdropColor(0,0,0, 0.78)
	BtmScan.LogFrame:SetPoint("TOPLEFT", BtmScan.LogParent, "BOTTOMLEFT", 10, 250)
	BtmScan.LogFrame:SetPoint("BOTTOMRIGHT", BtmScan.LogParent, "BOTTOMRIGHT", -35, 10)

	BtmScan.LogFrame.LineFrames = {}
	BtmScan.LogFrame.Dates = {}
	BtmScan.LogFrame.Lines = {}
	for i=1, LOG_LINES do
		BtmScan.LogFrame.LineFrames[i] = CreateFrame("Frame", "BtmScanLogFrame"..i, BtmScan.LogFrame)
		if (i == 1) then
			BtmScan.LogFrame.LineFrames[i]:SetPoint("TOPLEFT", BtmScan.LogFrame, "TOPLEFT", 10, -10)
			BtmScan.LogFrame.LineFrames[i]:SetPoint("RIGHT", BtmScan.LogFrame, "RIGHT", -20, 0)
		else
			BtmScan.LogFrame.LineFrames[i]:SetPoint("TOPLEFT", BtmScan.LogFrame.LineFrames[i-1], "BOTTOMLEFT")
			BtmScan.LogFrame.LineFrames[i]:SetPoint("RIGHT", BtmScan.LogFrame.LineFrames[i-1], "RIGHT")
		end
		BtmScan.LogFrame.LineFrames[i]:SetHeight(10)
		BtmScan.LogFrame.LineFrames[i].lineID = i
		BtmScan.LogFrame.LineFrames[i]:EnableMouse(true)
		BtmScan.LogFrame.LineFrames[i]:SetScript("OnEnter", BtmScan.DoTooltip)
		BtmScan.LogFrame.LineFrames[i]:SetScript("OnLeave", BtmScan.UndoTooltip)

		BtmScan.LogFrame.Dates[i] = BtmScan.LogFrame.LineFrames[i]:CreateFontString("BtmScanLogDate"..i, "HIGH")
		BtmScan.LogFrame.Dates[i]:SetPoint("TOPLEFT", BtmScan.LogFrame.LineFrames[i], "TOPLEFT")
		BtmScan.LogFrame.Dates[i]:SetWidth(90)
		BtmScan.LogFrame.Dates[i]:SetFont("Fonts\\FRIZQT__.TTF",10)
		BtmScan.LogFrame.Dates[i]:SetJustifyH("LEFT")
		BtmScan.LogFrame.Dates[i]:SetText("Date"..i)
		BtmScan.LogFrame.Dates[i]:Show()

		BtmScan.LogFrame.Lines[i] = BtmScan.LogFrame.LineFrames[i]:CreateFontString("BtmScanLogLine"..i, "HIGH")
		BtmScan.LogFrame.Lines[i]:SetFont("Fonts\\FRIZQT__.TTF",11)
		BtmScan.LogFrame.Lines[i]:SetPoint("TOPLEFT", BtmScan.LogFrame.Dates[i], "TOPRIGHT", 5, 0)
		BtmScan.LogFrame.Lines[i]:SetPoint("RIGHT", BtmScan.LogFrame.LineFrames[i], "RIGHT")
		BtmScan.LogFrame.Lines[i]:SetJustifyH("LEFT")
		BtmScan.LogFrame.Lines[i]:SetText("Text"..i)
		BtmScan.LogFrame.Lines[i]:Show()
	end

	BtmScan.LogFrame.Update = function()
		if (not data.logText) then
			data.logText = { { time(), "--- Welcome to BottomScanner ---" } }
		end
		local rows = table.getn(data.logText)
		local scrollrows = rows
		if (scrollrows > 0 and scrollrows < LOG_LINES+1) then scrollrows = LOG_LINES+1 end
		FauxScrollFrame_Update(BtmScan.LogFrame, scrollrows, LOG_LINES, LOG_LINES*2)
		local line
		for i=1, LOG_LINES do
			line = rows - (FauxScrollFrame_GetOffset(BtmScanLogFrame) + i) + 1
			if (rows > 0 and line <= rows and line > 0) then
				BtmScan.LogFrame.Dates[i]:SetText("["..date("%d %b %H:%M", data.logText[line][1]).."]")
				BtmScan.LogFrame.Lines[i]:SetText(data.logText[line][2])
			else
				BtmScan.LogFrame.Dates[i]:SetText("")
				BtmScan.LogFrame.Lines[i]:SetText("")
			end
		end
	end
	BtmScan.LogFrame:SetScript("OnVerticalScroll", function ()
		FauxScrollFrame_OnVerticalScroll(16, BtmScan.LogFrame.Update)
	end)
	BtmScan.LogFrame:SetScript("OnShow", function()
		BtmScan.LogFrame.Update()
	end)

	-- Insert a tab into the AH
	BtmScan.ScanTab = CreateFrame("Button", "AuctionFrameTabBtmScan", AuctionFrame, "AuctionTabTemplate")
	BtmScan.ScanTab:SetText(tr("BtmScan"))
	BtmScan.ScanTab:Hide()
	BtmScan.ScanTab:Show()
	PanelTemplates_DeselectTab(BtmScan.ScanTab)

	if (Auctioneer and Auctioneer.UI) then Auctioneer.UI.InsertAHTab(BtmScan.ScanTab, BtmScan.LogParent)
	elseif (AucAdvanced and AucAdvanced.AddTab) then AucAdvanced.AddTab(BtmScan.ScanTab, BtmScan.LogParent)
	end

	Stubby.RegisterFunctionHook("AuctionFrameTab_OnClick", 200, BtmScan.AuctionFrameTabClickHook)

	BtmScan.PlayButton = CreateFrame("Button", "", BtmScan.LogParent)
	BtmScan.PlayButton:SetNormalTexture("Interface\\AddOns\\BtmScan\\Textures\\Play")
	BtmScan.PlayButton:SetPushedTexture("Interface\\AddOns\\BtmScan\\Textures\\Stop")
	BtmScan.PlayButton:SetPoint("BOTTOMLEFT", BtmScan.LogParent, "TOPLEFT", 70, 5)
	BtmScan.PlayButton:SetHeight(24)
	BtmScan.PlayButton:SetWidth(24)
	BtmScan.PlayButton:SetScript("OnClick", BtmScan.ToggleScan)
	BtmScan.PlayButton:Show()
	
	BtmScan.ConfigButton = CreateFrame("Button", nil, BtmScan.LogParent, "OptionsButtonTemplate")
	BtmScan.ConfigButton:SetPoint("TOPLEFT", BtmScan.PlayButton, "TOPRIGHT", 10, -2)
	BtmScan.ConfigButton:SetText("Configure")
	BtmScan.ConfigButton:SetScript("OnClick", function()
		BtmScan.Settings.Toggle()
	end)
end


local DebugLib = LibStub("DebugLib")
local debug, assert
if DebugLib then
	debug, assert = DebugLib("BtmScan")
else
	function debug() end
	assert = debug
end

-------------------------------------------------------------------------------
-- Prints the specified message to nLog.
--
-- syntax:
--    errorCode, message = aucDebugPrint([message][, category][, title][, errorCode][, level])
--
-- parameters:
--    message   - (string) the error message
--                nil, no error message specified
--    category  - (string) the category of the debug message
--                nil, no category specified
--    title     - (string) the title for the debug message
--                nil, no title specified
--    errorCode - (number) the error code
--                nil, no error code specified
--    level     - (string) nLog message level
--                         Any nLog.levels string is valid.
--                nil, no level specified
--
-- returns:
--    errorCode - (number) errorCode, if one is specified
--                nil, otherwise
--    message   - (string) message, if one is specified
--                nil, otherwise
-------------------------------------------------------------------------------
function BtmScan.DebugPrint(message, category, title, errorCode, level)
	return debug(message, category, title, errorCode, level)
end

-- when you just want to print a message and don't care about the rest
function BtmScan.DebugPrintQuick(...)
	local message = debug:Dump(...)
	debug(message)
end

-------------------------------------------------------------------------------
-- Converts a itemconfiguration into a ';' delimited string.
-------------------------------------------------------------------------------
local tmp={}
function BtmScan.packItemConfiguration(itemconfig)
	if type(itemconfig.maxPrice)=="number" and itemconfig.maxPrice>0 then
		tmp[1] = tostring(ceil(itemconfig.maxPrice))
	else
		tmp[1]=nil
	end
	tmp[2] = itemconfig.isIgnore and tostring(true) or nil
	if type(itemconfig.ignoreModuleList)=="string" and itemconfig.ignoreModuleList~="" then
		tmp[3] = itemconfig.ignoreModuleList
	else
		tmp[3] = nil
	end
	if type(itemconfig.buyBelow)=="number" and itemconfig.buyBelow>0 then
		tmp[4] = tostring(itemconfig.buyBelow)
	else
		tmp[4] = nil
	end
	if type(itemconfig.maxCount)=="number" and itemconfig.maxCount>0 then
		tmp[5] = tostring(itemconfig.maxCount)
	else
		tmp[5] = nil
	end
	-- see how many entries we actually have
	local n
	for i=5,1,-1 do
		if tmp[i]~=nil then
			n=i
			break
		end
	end
	if not n then	-- nothing to save!
		return ""
	end
	-- turn nil entries into ""
	for i=1,n do
		if tmp[i]==nil then
			tmp[i] = ""
		end
	end
	return table.concat(tmp, ";", 1, n)
end

-------------------------------------------------------------------------------
-- Converts a ';' delimited string into a usable item configuration (optionally into the given table)
-------------------------------------------------------------------------------
function BtmScan.unpackItemConfiguration(packedItemConfiguration,   resultTable)
	local itemconfig = resultTable or {}
	itemconfig.maxPrice, 
	itemconfig.isIgnore, 
	itemconfig.ignoreModuleList, 
	itemconfig.buyBelow, 
	itemconfig.maxCount = strsplit(";",packedItemConfiguration)

	itemconfig.maxPrice = tonumber(itemconfig.maxPrice)
	itemconfig.isIgnore = (itemconfig.isIgnore == "true")
	if itemconfig.ignoreModuleList == "nil" then	-- old items (prior to 23 mar 2008) will have been stored this way
		itemconfig.ignoreModuleList = nil
	end
	itemconfig.buyBelow = tonumber(itemconfig.buyBelow)
	itemconfig.maxCount = tonumber(itemconfig.maxCount)
	
	return itemconfig
end

-------------------------------------------------------------------------------
-- stores the itemConfig-Structure
-------------------------------------------------------------------------------
function BtmScan.storeItemConfig(itemconfig, itemid)
	local itemConfigTable = BtmScan.Settings.GetSetting("itemconfig.list")

	local itemConfigString=BtmScan.packItemConfiguration(itemconfig)
	-- BtmScan.Print("BtmScan.storeItemConfig: "..itemid..": "..itemConfigString)
	if itemConfigString=="" then
		itemConfigTable[itemid]=nil
	else
		itemConfigTable[itemid]=itemConfigString
	end
end

-------------------------------------------------------------------------------
-- retreives the itemConfig-Structure (optionally into a given table)
-------------------------------------------------------------------------------
function BtmScan.getItemConfig(itemsig,   resultTable)
	return BtmScan.unpackItemConfiguration(BtmScan.Settings.GetSetting("itemconfig.list")[itemsig] or "", resultTable)
end
