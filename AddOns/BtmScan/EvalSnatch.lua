--[[
	BottomScanner - An AddOn for WoW to alert you to good purchases as they appear on the AH
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: EvalSnatch.lua 3502 2008-09-17 18:03:11Z root $
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

-- If auctioneer is not loaded, then we cannot run.
if not (AucAdvanced or (Auctioneer and Auctioneer.Statistic)) then return end

local libName = "Snatch"
local lcName = libName:lower()
local lib = { name = lcName, propername = libName }
table.insert(BtmScan.evaluators, lcName)
local define = BtmScan.Settings.SetDefault
local get = BtmScan.Settings.GetSetting
local set = BtmScan.Settings.SetSetting
local translate = BtmScan.Locales.Translate


BtmScan.evaluators[lcName] = lib

function lib:valuate(item, tooltip)
	local price = 0

	-- If we're not enabled, scadaddle!
	if (not get(lcName..".enable")) then return end

	if ((not item.itemconfig.buyBelow) or item.itemconfig.buyBelow==0) then return end

	local value = item.itemconfig.buyBelow * item.count

	-- If the current purchase price is more than our valuation,
	-- another module "wins" this purchase.
	if (value < item.purchase) then return end

	-- Check to see what the most we can pay for this item is.
	if (item.canbuy and get(lcName..".allow.buy") and item.buy < value) then
		price = item.buy
	elseif (item.canbid and get(lcName..".allow.bid") and item.bid < value) then
		price = item.bid
	end

	item.purchase = price
	item.reason = self.name
	item.what = self.name
	item.profit = value-price
	item.valuation = value
end

function lib.PrintHelp()
	BtmScan.Print("/btm snatch")
	BtmScan.Print("/btm snatch [ItemLink] maxPrice")
	BtmScan.Print("/btm snatch list")
end

function lib.AddSnatch(itemlink, price, count)	-- give price=(0 or nil) to stop snatching
	local itemid, itemsuffix, itemenchant, itemseed = BtmScan.BreakLink(itemlink)
	local itemsig = (":"):join(itemid, itemsuffix, itemenchant)
	local itemconfig = BtmScan.getItemConfig(itemsig)
	
	if price and price<=0 then
		price=nil
	end
	if count and count<=0 then
		count=nil
	end
	
	itemconfig.buyBelow = price
	itemconfig.maxCount = count
	
	if not price then
		BtmScan.Print(translate("BottomScanner will now %1 %2", translate("not snatch"), itemlink))
		BtmScan.storeItemConfig(itemconfig, itemsig)
		return
	end

	local _,_,_,_,_,_,_,stack = GetItemInfo(itemid)
	if (not stack) then
		stack = 1
	end

	local stackText = ""
	if (stack > 1) then
		stackText = " ("..translate("%1 per %2 stack", BtmScan.GSC(price*stack, 1), stack)..")"
	end
	local countText =""
	if count then
		countText = translate("up to %1", count).." "
	else
		countText = translate("unlimited").." "
	end

	BtmScan.Print(translate("BottomScanner will now %1 %2", translate("snatch"), countText..translate("%1 at %2", itemlink, translate("%1 per unit", BtmScan.GSC(price, 1)))..stackText))
	BtmScan.storeItemConfig(itemconfig, itemsig)
end

function lib.CommandHandler(msg)
	-- BtmScan.Print("called snatch-handler: "..msg)
	if (string.lower(msg) == "snatch") then 
		lib.snatchGUI()
		return
	end
	if (string.lower(msg) == "snatch list") then 
		lib.PrintList()
		return
	end
	local i,j, ocmd, oparam = string.find(msg, "^([^ ]+) (.*)$")
	local i,j, cmd, param = string.find(string.lower(msg), "^([^ ]+) (.*)$")
	if (not i) then cmd = msg param = nil oparam = nil end
	if (oparam == "") then param = nil oparam = nil end


	if (oparam) then
		local des, count, price, itemid,itemrand,itemlink, remain = BtmScan.ItemDes(oparam)
		if (not des) then
			BtmScan.Print(translate("Unable to understand command. Please see /btm help"))
			return
		end

		if (price <= 0) then
			price = BtmScan.ParseGSC(remain) or 0
		end

		lib.AddSnatch(itemlink, price, count)
	end

end

function lib.PrintList()
	local itemConfigTable = get("itemconfig.list")
	local itemConfig = {}
	for itemkey, itemConfigString in pairs(itemConfigTable) do
		BtmScan.unpackItemConfiguration(itemConfigString, itemConfig)
		if itemConfig.buyBelow and itemConfig.buyBelow > 0 then
			local itemID, itemsuffix, itemenchant = strsplit(":", itemkey)
			itemkey = strjoin(":", "item", itemID, itemenchant, 0, 0, 0, 0, itemsuffix)
			local _, itemlink = GetItemInfo(itemkey)
			if not itemlink then
				itemlink="(Uncached item "..itemkey..")"
			end
			if itemConfig.maxCount and itemConfig.maxCount>0 then
				BtmScan.Print(itemlink.."  "..BtmScan.GSC(itemConfig.buyBelow, 1).." (<="..itemConfig.maxCount..")")
			else
				BtmScan.Print(itemlink.."  "..BtmScan.GSC(itemConfig.buyBelow, 1))
			end
		end
	end
end

define(lcName..'.enable', true)
define(lcName..'.allow.bid', true)
define(lcName..'.allow.buy', true)
function lib:setup(gui)
	local id = gui:AddTab(libName)
	
	gui:AddHelp(id, "what snatch evaluator",
		"What is the snatch evaluator?",
		"This evaluator allows you to purchase specific items you want, for a maximum price set by you.\n\n"..
		"Hint: When configuring the list of items to snatch, you can click any chat link to add a new item to the list."
		)
	
	gui:AddControl(id, "Subhead",          0,    libName.." Settings")
	gui:AddControl(id, "Checkbox",         0, 1, lcName..".enable", "Enable purchasing for "..lcName)
	gui:AddControl(id, "Checkbox",         0, 2, lcName..".allow.buy", "Allow buyout on items")
	gui:AddControl(id, "Checkbox",         0, 2, lcName..".allow.bid", "Allow bid on items")
	
	gui:AddControl(id, "Subhead",          0,    libName.." List")
	gui:AddControl(id, "Button",           0, 2, lib.snatchGUI, "Edit")
	
end

--[[ Everything below this point belongs to the snatch ui
 the ui has not modified any of the original snatch code 
 except adding the command handler]]

local snatchui = {
	itemLink = nil,
}

local print = BtmScan.Print
local SelectBox = LibStub:GetLibrary("SelectBox")
local ScrollSheet = LibStub:GetLibrary("ScrollSheet")

local tmpItemConfig={}
function snatchui.SetWorkingItem(link)
	snatchui.ClearWorkingItem()
	if type(link)~="string" then return false end
	local name, _, _, _, _, _, _, _, _, texture = GetItemInfo(link)
	if not name or not texture then return false end
	workingItemLink = link
	
	snatchui.frame.workingname:SetText(link)
	snatchui.frame.icon.tx:SetTexture(texture)
	snatchui.frame.icon.tx:Show()
	snatchui.frame.additem:Show()
	
	
	BtmScan.getItemConfig(format("%d:%d:%d", BtmScan.BreakLink(link)),  tmpItemConfig)
	if tmpItemConfig.buyBelow then
		local g,s,c = BtmScan.GetGSC(tmpItemConfig.buyBelow)
		snatchui.frame.gold:SetText(g)
		snatchui.frame.silver:SetText(s)
		snatchui.frame.copper:SetText(c)
		snatchui.frame.additem:SetText("Update")
		snatchui.frame.removeitem:Show()
	else
		snatchui.frame.gold:SetText("")
		snatchui.frame.silver:SetText("")
		snatchui.frame.copper:SetText("")
		snatchui.frame.additem:SetText("Add Item")
		snatchui.frame.removeitem:Hide()
		
	end
	
	return true
end



function snatchui.PopulateSnatchSheet()
	local itemConfigTable = get("itemconfig.list")
	
	local display = {}
	
	local appraiser = AucAdvanced and AucAdvanced.Modules.Util.Appraiser
	
	local itemConfig = {}
	for sig, itemConfigString in pairs(itemConfigTable) do
		BtmScan.unpackItemConfiguration(itemConfigString, itemConfig)
		if itemConfig.buyBelow and itemConfig.buyBelow>0 then
			local itemID, itemsuffix, itemenchant = strsplit(':', sig)
			local itemString = strjoin(":", "item", itemID, itemenchant, 0, 0, 0, 0, itemsuffix)
			local _, itemlink = GetItemInfo(itemString)
			
			if not appraiser then
				table.insert(display,{
					itemlink,
					itemConfig.buyBelow,
				}) 
			else
				local abid, abuy = appraiser.GetPrice(itemlink, nil, true)
				table.insert(display,{
					itemlink,
					itemConfig.buyBelow,
					tonumber(abuy) or tonumber(abid) --Appraisers buyout value
				}) 
			end
		end
	end
		
	snatchui.frame.snatchlist.sheet:SetData(display)
end 


function snatchui.OnClickClearAllSnatches()
	local itemConfig = {}
	for sig, itemConfigString in pairs(itemConfigTable) do
		BtmScan.unpackItemConfiguration(itemConfigString, itemConfig)
		if itemConfig.buyBelow then
			itemConfig.buyBelow = nil
			itemConfig.maxCount = nil
			BtmScan.storeItemConfig(itemConfig, sig)
		end
	end

	snatchui.PopulateSnatchSheet()
end




function snatchui.OnClickRemoveSnatch()
	lib.AddSnatch(workingItemLink, nil)
	snatchui.ClearWorkingItem()
	snatchui.PopulateSnatchSheet()
end

function snatchui.OnClickAddSnatch()
	local g = tonumber(snatchui.frame.gold:GetText()) or 0
	local s = tonumber(snatchui.frame.silver:GetText()) or 0
	local c = tonumber(snatchui.frame.copper:GetText()) or 0
	
	lib.AddSnatch(workingItemLink, g*10000 + s*100 + c)
	snatchui.ClearWorkingItem()
	snatchui.PopulateSnatchSheet()	
end

function snatchui.OnEnterSnatchSheet(button, row, index)
	if snatchui.frame.snatchlist.sheet.rows[row][index]:IsShown()then --Hide tooltip for hidden cells
		local link = snatchui.frame.snatchlist.sheet.rows[row][index]:GetText() or "FAILED LINK"
		local name = GetItemInfo(link)
		if link and name then
			GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(link)
			if (EnhTooltip) then 
				EnhTooltip.TooltipCall(GameTooltip, name, link, -1, 1) 
			end
		end
	end		
end

function snatchui.OnEnterBagSheet(button, row, index)
	if snatchui.frame.baglist.sheet.rows[row][index]:IsShown() then --Hide tooltip for hidden cells
		local link = snatchui.frame.baglist.sheet.rows[row][index]:GetText()
		local name = GetItemInfo(link)
		if link and name then
			GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(link)
			if (EnhTooltip) then 
				EnhTooltip.TooltipCall(GameTooltip, name, link, -1, 1) 
			end
		end
	end		
end

function snatchui.OnLeaveSheet(button, row, index)
	GameTooltip:Hide()
end


function snatchui.OnClickSnatchSheet(button, row, index)
	local link = snatchui.frame.snatchlist.sheet.rows[row][1]:GetText()
	snatchui.SetWorkingItem(link)
end	

function snatchui.OnClickBagSheet(button, row, index)
	local link = snatchui.frame.baglist.sheet.rows[row][1]:GetText()
	snatchui.SetWorkingItem(link)
end	

function snatchui.OnResize()
	--empty function needed to resize columns. This function can be used later if we want to save columns across sessions
end

function snatchui.ClearWorkingItem()
	snatchui.frame.workingname:SetText("")
	snatchui.frame.icon.tx:Hide()
	snatchui.frame.additem:Hide()
	snatchui.frame.removeitem:Hide()
	snatchui.frame.gold:SetText("")
	snatchui.frame.silver:SetText("")
	snatchui.frame.copper:SetText("")
end

function snatchui.OnClickIcon()
	snatchui.ClearWorkingItem()
end 

function snatchui.OnDragToIcon()
	local objtype, _, itemlink = GetCursorInfo()
	if objtype == "item" then
		ClearCursor()
		snatchui.SetWorkingItem(itemlink)
	end
end

function snatchui.ClickLinkHook(_, link, button)
	if link and snatchui.frame and snatchui.frame:IsShown() then
		if (button == "LeftButton") then --and (IsAltKeyDown()) and itemName then -- Commented mod key, I want to catch any item clicked.
			snatchui.SetWorkingItem(link)
		end
	end
end
hooksecurefunc("ChatFrame_OnHyperlinkShow", snatchui.ClickLinkHook)

function snatchui.PopulateBagSheet()
	
	local unique={}
	local bagcontents = {}
	local appraiser = AucAdvanced and AucAdvanced.Modules.Util.Appraiser
	
	for bag=0,NUM_BAG_SLOTS do
		for slot=1,GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag,slot)
			if itemLink then
				local itemid, suffix, enchant, seed = BtmScan.BreakLink(itemLink)
				local sig = ("%d:%d"):format(itemid,suffix)
				if not unique[sig] then
					unique[sig]=true
					local _,itemCount = GetContainerItemInfo(bag,slot)
					local itemName, _, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemLink)
					local btmRule = ""
					
					local bidlist = get("bid.list")
					if (bidlist) then
						local bids = bidlist[("%d:%d:%d:%dx%d"):format(itemid,suffix,enchant,seed,itemCount)]
						if(bids and bids[1]) then 
							btmRule = bids[1]
						end 
					end
					
					if not appraiser then
						tinsert(bagcontents, {
							itemLink,
							btmRule
						})
					else
						local abid,abuy = appraiser.GetPrice(itemLink, nil, true)
						tinsert(bagcontents, {
							itemLink,
							tonumber(abuy) or tonumber(abid),
							btmRule
						})
					end
				end
			end
		end
	end
	
	snatchui.frame.baglist.sheet:SetData(bagcontents) --Set the GUI scrollsheet
	snatchui.PopulateSnatchSheet()
end



function lib.snatchGUI() 
	if not snatchui.frame then
		snatchui.frame = CreateFrame("Frame", "snatchframe", UIParent)

		snatchui.frame:SetToplevel(true)
		snatchui.frame:SetFrameStrata("HIGH")
		snatchui.frame:SetBackdrop({
			bgFile = "Interface/Tooltips/ChatBubble-Background",
			edgeFile = "Interface/Tooltips/ChatBubble-BackDrop",
			tile = true, tileSize = 32, edgeSize = 32,
			insets = { left = 32, right = 32, top = 32, bottom = 32 }
		})
		snatchui.frame:SetBackdropColor(0,0,0, 1)
		snatchui.frame:Hide()
		
		snatchui.frame:SetPoint("CENTER", UIParent, "CENTER")
		snatchui.frame:SetWidth(950)
		snatchui.frame:SetHeight(450)
		
		snatchui.frame:SetMovable(true)
		snatchui.frame:EnableMouse(true)
		snatchui.frame.Drag = CreateFrame("Button", nil, snatchui.frame)
		snatchui.frame.Drag:SetPoint("TOPLEFT", snatchui.frame, "TOPLEFT", 10,-5)
		snatchui.frame.Drag:SetPoint("TOPRIGHT", snatchui.frame, "TOPRIGHT", -10,-5)
		snatchui.frame.Drag:SetHeight(6)
		snatchui.frame.Drag:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")

		snatchui.frame.Drag:SetScript("OnMouseDown", function() snatchui.frame:StartMoving() end)
		snatchui.frame.Drag:SetScript("OnMouseUp", function() snatchui.frame:StopMovingOrSizing() end)
		
		snatchui.frame.DragBottom = CreateFrame("Button",nil, snatchui.frame)
		snatchui.frame.DragBottom:SetPoint("BOTTOMLEFT", snatchui.frame, "BOTTOMLEFT", 10,5)
		snatchui.frame.DragBottom:SetPoint("BOTTOMRIGHT", snatchui.frame, "BOTTOMRIGHT", -10,5)
		snatchui.frame.DragBottom:SetHeight(6)
		snatchui.frame.DragBottom:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")

		snatchui.frame.DragBottom:SetScript("OnMouseDown", function() snatchui.frame:StartMoving() end)
		snatchui.frame.DragBottom:SetScript("OnMouseUp", function() snatchui.frame:StopMovingOrSizing() end)
		
		--Add Drag slot / Item icon
		snatchui.frame.slot = snatchui.frame:CreateTexture(nil, "BORDER")
		snatchui.frame.slot:SetDrawLayer("Artwork") -- or the border shades it
		snatchui.frame.slot:SetPoint("TOPLEFT", snatchui.frame, "TOPLEFT", 23, -75)
		snatchui.frame.slot:SetWidth(45)
		snatchui.frame.slot:SetHeight(45)
		snatchui.frame.slot:SetTexCoord(0.17, 0.83, 0.17, 0.83)
		snatchui.frame.slot:SetTexture("Interface\\Buttons\\UI-EmptySlot")

		snatchui.frame.icon = CreateFrame("Button", nil, snatchui.frame)
		snatchui.frame.icon:SetPoint("TOPLEFT", snatchui.frame.slot, "TOPLEFT", 2, -2)
		snatchui.frame.icon:SetPoint("BOTTOMRIGHT", snatchui.frame.slot, "BOTTOMRIGHT", -2, 2)
		snatchui.frame.icon:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square.blp")
		snatchui.frame.icon:SetScript("OnClick", snatchui.OnClickIcon)
		snatchui.frame.icon:SetScript("OnReceiveDrag", snatchui.OnDragToIcon)
		snatchui.frame.icon.tx = snatchui.frame.icon:CreateTexture()
		snatchui.frame.icon.tx:SetAllPoints(snatchui.frame.icon)
		
		
		snatchui.frame.slot.help = snatchui.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		snatchui.frame.slot.help:SetPoint("LEFT", snatchui.frame.slot, "RIGHT", 2, 7)
		snatchui.frame.slot.help:SetText(("Drop item into box")) --"Drop item into box to search."
		snatchui.frame.slot.help:SetWidth(80)
		
		snatchui.frame.workingname = snatchui.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		snatchui.frame.workingname:SetPoint("TOPLEFT", snatchui.frame, "TOPLEFT", 15, -135)
		snatchui.frame.workingname:SetWidth(160)
		snatchui.frame.workingname:SetJustifyH("LEFT")
		
		
		--Add Title text
		local	snatchtitle = snatchui.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		snatchtitle:SetText("BTM Snatch Configuration")
		snatchtitle:SetJustifyH("CENTER")
		snatchtitle:SetWidth(300)
		snatchtitle:SetHeight(10)
		snatchtitle:SetPoint("TOPLEFT",  snatchui.frame, "TOPLEFT", 0, -17)
		snatchui.frame.snatchtitle = snatchtitle
		
			
		--Create the snatch list results frame
		snatchui.frame.snatchlist = CreateFrame("Frame", nil, snatchui.frame)
		snatchui.frame.snatchlist:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 32, edgeSize = 16,
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
		})
		
		snatchui.frame.snatchlist:SetBackdropColor(0, 0, 0.0, 0.5)
		snatchui.frame.snatchlist:SetPoint("TOPLEFT", snatchui.frame, "TOPLEFT", 187, -40)
		snatchui.frame.snatchlist:SetPoint("BOTTOM", snatchui.frame, "BOTTOM", 0, 57)
		snatchui.frame.snatchlist:SetWidth(360)

		if not ( AucAdvanced and AucAdvanced.Modules.Util.Appraiser ) then
			snatchui.frame.snatchlist.sheet = ScrollSheet:Create(snatchui.frame.snatchlist, {
			{ "Snatching", "TOOLTIP", 150 }, 
			{ "Buy at", "COIN", 70 }, 
			}, snatchui.OnEnterSnatchSheet, snatchui.OnLeaveSheet, snatchui.OnClickSnatchSheet, snatchui.OnResize)
		else
			snatchui.frame.snatchlist.sheet = ScrollSheet:Create(snatchui.frame.snatchlist, {
			{ "Snatching", "TOOLTIP", 150 }, 
			{ "Buy at", "COIN", 70}, 
			{ "Appraiser", "COIN", 70 }, 
			}, snatchui.OnEnterSnatchSheet, snatchui.OnLeaveSheet, snatchui.OnClickSnatchSheet, snatchui.OnResize)
		end
		


		-- Bag List
		snatchui.frame.baglist = CreateFrame("Frame", nil, snatchui.frame)
		snatchui.frame.baglist:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 32, edgeSize = 16,
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
		})
		
		snatchui.frame.baglist:SetBackdropColor(0, 0, 0.0, 0.5)
		snatchui.frame.baglist:SetPoint("TOPLEFT", snatchui.frame.snatchlist, "TOPRIGHT", 20, 0)
		snatchui.frame.baglist:SetPoint("RIGHT", snatchui.frame, "RIGHT", -30, -0)
		snatchui.frame.baglist:SetPoint("BOTTOM", snatchui.frame.snatchlist, "BOTTOM", 0, 0)
		
		snatchui.frame.bagscan = CreateFrame("Button", nil, snatchui.frame, "OptionsButtonTemplate")
		snatchui.frame.bagscan:SetPoint("TOP", snatchui.frame.baglist, "BOTTOM", 0, -15)
		snatchui.frame.bagscan:SetText(("Refresh Data"))
		snatchui.frame.bagscan:SetScript("OnClick", snatchui.PopulateBagSheet)
		
		if not ( AucAdvanced and AucAdvanced.Modules.Util.Appraiser ) then
			snatchui.frame.baglist.sheet = ScrollSheet:Create(snatchui.frame.baglist, {
				{ "Bag Contents", "TOOLTIP", 150 }, 
				{ "BTM Rule", "TEXT", 70 }, 
				}, snatchui.OnEnterBagSheet, snatchui.OnLeaveSheet, snatchui.OnClickBagSheet, snatchui.OnResize)
		else
			snatchui.frame.baglist.sheet = ScrollSheet:Create(snatchui.frame.baglist, {
				{ "Bag Contents", "TOOLTIP", 150 }, 
				{ "Appraiser", "COIN", 70 }, 
				{ "BTM Rule", "TEXT", 70 }, 
				}, snatchui.OnEnterBagSheet, snatchui.OnLeaveSheet, snatchui.OnClickBagSheet, snatchui.OnResize)
		end

		
		--Add close button
		snatchui.frame.closeButton = CreateFrame("Button", nil, snatchui.frame, "OptionsButtonTemplate")
		snatchui.frame.closeButton:SetPoint("BOTTOMRIGHT", snatchui.frame, "BOTTOMRIGHT", -10, 10)
		snatchui.frame.closeButton:SetText(("Close"))
		snatchui.frame.closeButton:SetScript("OnClick",  lib.closeSnatchGUI)
		
		--Add Item to list button	
		snatchui.frame.additem = CreateFrame("Button", nil, snatchui.frame, "OptionsButtonTemplate")
		snatchui.frame.additem:SetPoint("TOPLEFT", snatchui.frame, "TOPLEFT", 10, -210)
		snatchui.frame.additem:SetText(('Add Item'))
		snatchui.frame.additem:SetScript("OnClick", snatchui.OnClickAddSnatch)
		
		--[[
		snatchui.frame.additem.help = snatchui.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		snatchui.frame.additem.help:SetPoint("TOPLEFT", snatchui.frame.additem, "TOPRIGHT", 1, 1)
		snatchui.frame.additem.help:SetText(("(to Snatch list)")) 
		snatchui.frame.additem.help:SetWidth(90)
		]]
		
		--Add coin boxes
		local function goldtosilver()
			snatchui.frame.silver:SetFocus()
		end
		
		local function silvertocopper()
			snatchui.frame.copper:SetFocus()
		end
		
		local function copper()
			snatchui.frame.copper:ClearFocus()
		end

			
		snatchui.frame.gold = CreateFrame("EditBox", "snatchgold", snatchui.frame, "InputBoxTemplate")
		snatchui.frame.gold:SetPoint("BOTTOMLEFT", snatchui.frame.additem, "TOPLEFT", 10, 10)
		snatchui.frame.gold:SetAutoFocus(false)
		snatchui.frame.gold:SetHeight(15)
		snatchui.frame.gold:SetWidth(40)
		snatchui.frame.gold:SetScript("OnEnterPressed", goldtosilver)
		snatchui.frame.gold:SetScript("OnTabPressed", goldtosilver)
		
		snatchui.frame.silver = CreateFrame("EditBox", "snatchsilver", snatchui.frame, "InputBoxTemplate")
		snatchui.frame.silver:SetPoint("TOPLEFT", snatchui.frame.gold, "TOPRIGHT", 10, 0)
		snatchui.frame.silver:SetAutoFocus(false)
		snatchui.frame.silver:SetHeight(15)
		snatchui.frame.silver:SetWidth(20)
		snatchui.frame.silver:SetMaxLetters(2)
		snatchui.frame.silver:SetScript("OnEnterPressed", silvertocopper)
		snatchui.frame.silver:SetScript("OnTabPressed", silvertocopper)
		
		snatchui.frame.copper = CreateFrame("EditBox", "snatchcopper", snatchui.frame, "InputBoxTemplate")
		snatchui.frame.copper:SetPoint("TOPLEFT", snatchui.frame.silver, "TOPRIGHT", 10, 0)
		snatchui.frame.copper:SetAutoFocus(false)
		snatchui.frame.copper:SetHeight(15)
		snatchui.frame.copper:SetWidth(20)
		snatchui.frame.copper:SetMaxLetters(2)
		snatchui.frame.copper:SetScript("OnEnterPressed", copper)
		snatchui.frame.copper:SetScript("OnTabPressed", copper)
		
		--Remove Item from list button	
		snatchui.frame.removeitem = CreateFrame("Button", nil, snatchui.frame, "OptionsButtonTemplate")
		snatchui.frame.removeitem:SetPoint("TOPLEFT", snatchui.frame.additem, "BOTTOMLEFT", 0, -20)
		snatchui.frame.removeitem:SetText(('Remove Item'))
		snatchui.frame.removeitem:SetScript("OnClick", snatchui.OnClickRemoveSnatch)
		
		--Reset snatch list
		snatchui.frame.resetList = CreateFrame("Button", nil, snatchui.frame, "OptionsButtonTemplate")
		snatchui.frame.resetList:SetPoint("TOP", snatchui.frame.snatchlist, "BOTTOM", 0, -15)
		snatchui.frame.resetList:SetText(("Clear List"))
		snatchui.frame.resetList:SetScript("OnClick", snatchui.OnClickClearAllSnatches)
		
	elseif (snatchui.frame:IsVisible()) then 
		lib.closeSnatchGUI()
	end

	snatchui.frame:Show()
	snatchui.PopulateBagSheet()
	snatchui.PopulateSnatchSheet()
	snatchui.ClearWorkingItem()
end

function lib.closeSnatchGUI()
	snatchui.ClearWorkingItem()
	snatchui.frame:Hide()
end


