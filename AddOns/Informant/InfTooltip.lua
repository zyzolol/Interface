--[[
	Informant - An addon for World of Warcraft that shows pertinent information about
	an item in a tooltip when you hover over the item in the game.
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: InfTooltip.lua 3502 2008-09-17 18:03:11Z root $
	URL: http://auctioneeraddon.com/dl/Informant/

	Tooltip handler. Assumes the responsibility of filling the tooltip
	with the user-selected information

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
]]
Informant_RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/RC_5.0/Informant/InfTooltip.lua $", "$Rev: 3502 $")

local nilSafeString			-- nilSafeString(String)
local whitespace			-- whitespace(length)
local getFilter = Informant.Settings.GetSetting
local debugPrint

function Informant.TooltipHandler(funcVars, retVal, frame, name, link, quality, count, price)
	-- nothing to do, if informant is disabled
	if (not getFilter('all')) then
		return;
	end;

	if EnhTooltip.LinkType(link) ~= "item" then return end

	local quant = 0
	local sell = 0
	local buy = 0
	local stacks = 1

	local itemID, randomProp, enchant, uniqID, _, gemSlot1, gemSlot2, gemSlot3, gemSlotBonus = EnhTooltip.BreakLink(link)

	local itemInfo
	if (itemID and itemID > 0) then
		itemInfo = Informant.GetItem(itemID)
	end
	if (not itemInfo) then return end
	Informant.itemInfo = itemInfo

	itemInfo.itemName = name
	itemInfo.itemLink = link
	itemInfo.itemCount = count
	itemInfo.itemQuality = quality

	stacks = itemInfo.stack
	if (not stacks) then stacks = 1 end

	buy = tonumber(itemInfo.buy) or 0
	sell = tonumber(itemInfo.sell) or 0
	quant = tonumber(itemInfo.quantity) or 0

	if (quant == 0) and (sell > 0) then
		local ratio = buy / sell
		if ((ratio > 3) and (ratio < 6)) then
			quant = 1
		else
			ratio = buy / (sell * 5)
			if ((ratio > 3) and (ratio < 6)) then
				quant = 5
			end
		end
	end
	if (quant == 0) then quant = 1 end

	buy = buy/quant

	itemInfo.itemBuy = buy
	itemInfo.itemSell = sell
	itemInfo.itemQuant = quant

	local embedded = getFilter('embed')

	if (getFilter('show-icon')) then
		if (itemInfo.texture) then
			EnhTooltip.SetIcon(itemInfo.texture)
		end
	end

	if (not embedded and getFilter('show-name')) then
		EnhTooltip.AddHeaderLine(itemInfo.itemName, nil, embedded)
		EnhTooltip.HeaderQuality(itemInfo.itemQuality)
		EnhTooltip.HeaderSize(12)
	end

	if (getFilter('show-ilevel')) then
		if (itemInfo.itemLevel) then
			EnhTooltip.AddHeaderLine(_INFM('FrmtInfoItemLevel'):format(itemInfo.itemLevel), nil, embedded)
			EnhTooltip.HeaderQuality(itemInfo.itemQuality)
		end
	end

	if (getFilter('show-link')) then
		EnhTooltip.AddHeaderLine(_INFM('FrmtInfoItemLink'):format((":"):join(itemID, enchant, gemSlot1, gemSlot2, gemSlot3, gemSlotBonus, randomProp, uniqID), nil, embedded))
		EnhTooltip.HeaderQuality(itemInfo.itemQuality)
	end

	--DEFAULT_CHAT_FRAME:AddMessage("Got vendor: "..(buy or 0).."/"..(sell or 0))
	if (getFilter('show-vendor')) then
		if ((buy > 0) or (sell > 0)) then
			local bgsc = EnhTooltip.GetTextGSC(buy, true)
			local sgsc = EnhTooltip.GetTextGSC(sell, true)

			if (count and (count > 1)) then
				if (getFilter('show-vendor-buy')) then
					EnhTooltip.AddLine(_INFM('FrmtInfoBuymult'):format(count, bgsc), buy*count, embedded, true)
					EnhTooltip.LineColor(0.8, 0.5, 0.1)
				end
				if (getFilter('show-vendor-sell')) then
					EnhTooltip.AddLine(_INFM('FrmtInfoSellmult'):format(count, sgsc), sell*count, embedded, true)
					EnhTooltip.LineColor(0.8, 0.5, 0.1)
				end
			else
				if (getFilter('show-vendor-buy')) then
					EnhTooltip.AddLine(_INFM('FrmtInfoBuy'):format(), buy, embedded, true)
					EnhTooltip.LineColor(0.8, 0.5, 0.1)
				end
				if (getFilter('show-vendor-sell')) then
					EnhTooltip.AddLine(_INFM('FrmtInfoSell'):format(), sell, embedded, true)
					EnhTooltip.LineColor(0.8, 0.5, 0.1)
				end
			end
		end
	end

	if (getFilter('show-stack')) then
		if (stacks > 1) then
			EnhTooltip.AddLine(_INFM('FrmtInfoStx'):format(stacks), nil, embedded)
		end
	end
	if (getFilter('show-merchant')) then
		if (itemInfo.vendors) then
			local merchantCount = #itemInfo.vendors
			if (merchantCount > 0) then
				EnhTooltip.AddLine(_INFM('FrmtInfoMerchants'):format(merchantCount), nil, embedded)
				EnhTooltip.LineColor(0.5, 0.8, 0.5)
			else
				-- NOTE - there are 2 cases for "no known":  nil list, and zero length list
				if (getFilter('show-zero-merchants')) then
					EnhTooltip.AddLine(_INFM('FrmtInfoNoKnownMerchants'), nil, embedded)
					EnhTooltip.LineColor(0.8, 0.2, 0.2)
				end
			end
		else
			-- NOTE - there are 2 cases for "no known":  nil list, and zero length list
			if (getFilter('show-zero-merchants')) then
				EnhTooltip.AddLine(_INFM('FrmtInfoNoKnownMerchants'), nil, embedded)
				EnhTooltip.LineColor(0.8, 0.2, 0.2)
			end
		end
	end
	if (getFilter('show-usage')) then
		local reagentInfo = ""
		if (itemInfo.classText) then
			reagentInfo = _INFM('FrmtInfoClass'):format(itemInfo.classText)
			EnhTooltip.AddLine(reagentInfo, nil, embedded)
			EnhTooltip.LineColor(0.6, 0.4, 0.8)
		end
		if (itemInfo.usedList and itemInfo.usageText) then
			if (#itemInfo.usedList > 2) then

				local currentUseLine = nilSafeString(itemInfo.usedList[1])..", "..nilSafeString(itemInfo.usedList[2])..","
				reagentInfo = _INFM('FrmtInfoUse'):format(currentUseLine)
				EnhTooltip.AddLine(reagentInfo, nil, embedded)
				EnhTooltip.LineColor(0.6, 0.4, 0.8)

				for index = 3, #itemInfo.usedList, 2 do
					if (itemInfo.usedList[index+1]) then
						reagentInfo = whitespace(#_INFM('FrmtInfoUse') + 3)..nilSafeString(itemInfo.usedList[index])..", "..nilSafeString(itemInfo.usedList[index+1])..","
						EnhTooltip.AddLine(reagentInfo, nil, embedded)
						EnhTooltip.LineColor(0.6, 0.4, 0.8)
					else
						reagentInfo = whitespace(#_INFM('FrmtInfoUse') + 3)..nilSafeString(itemInfo.usedList[index])
						EnhTooltip.AddLine(reagentInfo, nil, embedded)
						EnhTooltip.LineColor(0.6, 0.4, 0.8)
					end
				end
			else
				reagentInfo = _INFM('FrmtInfoUse'):format(itemInfo.usageText)
				EnhTooltip.AddLine(reagentInfo, nil, embedded)
				EnhTooltip.LineColor(0.6, 0.4, 0.8)
			end
		end
	end
	if (getFilter('show-quest')) then
		if (itemInfo.quests) then
			local questCount = itemInfo.questCount
			if (questCount > 0) then
				EnhTooltip.AddLine(_INFM('FrmtInfoQuest'):format(questCount), nil, embedded)
				EnhTooltip.LineColor(0.5, 0.5, 0.8)
			end
		end
	end
end

function nilSafeString(str)
	return str or "";
end

function whitespace(length)
	local spaces = ""
	for index = length, 0, -1 do
		spaces = spaces.." "
	end
	return spaces
end

-------------------------------------------------------------------------------
-- Prints the specified message to nLog.
--
-- syntax:
--    errorCode, message = debugPrint([message][, title][, errorCode][, level])
--
-- parameters:
--    message   - (string) the error message
--                nil, no error message specified
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
function debugPrint(message, title, errorCode, level)
	return Informant.DebugPrint(message, "InfTooltip", title, errorCode, level)
end