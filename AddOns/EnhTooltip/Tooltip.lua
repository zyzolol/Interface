--[[
	EnhTooltip - Additional function hooks to allow hooks into more tooltips
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: Tooltip.lua 3418 2008-08-25 04:33:16Z ccox $
	URL: http://auctioneeraddon.com/dl/EnhTooltip

	You should hook into EnhTooltip using Stubby:
	Stubby.RegisterFunctionHook("EnhTooltip.HOOK", 200, myHookingFunction)
	Where myHooking function is one of your functions (see calling parameters below)
	And HOOK is one of:
		AddTooltip
		CheckPopup
		MerchantHook
		TradeHook
		BankHook
		BagHook
	The number 200 is a number that determines calling order
		A lower number will make your tooltip information display earlier (higher)
		A higher number will call your tooltip later (lower)
		Auctioneer (if installed) gets called at position 100.
		Informant  (if installed) gets called at position 300.
		Enchantrix (if installed) gets called at position 400.

	The appropriate function calls are, respectively:
		tooltip - A tooltip is being displayed, hookFunc will be called as:
		EnhTooltip.AddTooltipHook(frame, name, link, quality, count, price)
		popup - A tooltip may be displayed, unless you want to popup something:
		popped = EnhTooltip.CheckPopupHook(name, link, quality, count, price, hyperlink)
			If your function returns true, then we won't present a tooltip
		merchant - Get called for each of a merchant's items.
		EnhTooltip.MerchantHook(frame, name, link, quality, count, price)
		trade - Get called when a tradeskill window is displayed / item selected
		EnhTooltip.TradeHook(type, selid)
			valid types: 'trade', 'craft'
			selID will be nil when the window is first displayed
		bank - You are at the bank and are able to scan it's containers
			EnhTooltip.BankHook()
		bag - One or more of the items in your bags has updated.
			EnhTooltip.BagHook()


	You may use the following methods of the EnhTooltip class:

	EnhTooltip.HideTooltip()
		Causes the enhanced tooltip to vanish.

	EnhTooltip.ClearTooltip()
		Clears the current tooltip of contents and hides it.

	EnhTooltip.GetGSC(money)
		Returns the given money (in copper) amount in gold, silver and copper.

	EnhTooltip.GetTextGSC(money, exact)
		Returns the money (in copper) amount as colored text, suitable for display.
		If exact evaluates to true, then the text will be exact, otherwise rounded.

	EnhTooltip.AddLine(lineText, moneyAmount, embed)
		Adds the lineText to the tooltip.
		If moneyAmount is supplied, the line has a money amount right-aligned after it.
		If embed evaluates to true, then the line is placed at the end of the game tooltip
		and the money amount is converted to a textual form.

	EnhTooltip.AddSeparator()
		Adds an empty line to the tooltip.

	EnhTooltip.LineColor(r, g, b)
		Changes the color of the most recently added line to the given R,G,B value.
		The R,G,B values are floating point values from 0.0 (dark) to 1.0 (bright)

	EnhTooltip.LineSize(fontSize)
		Changes the size of the FontString associated with the most recently added line to the given fontSize value.

	EnhTooltip.LineQuality(quality)
		Changes the color of the most recently added line to the quality color of the
		item that is supplied in the quality parameter.

	EnhTooltip.SetIcon(iconPath)
		Adds an icon to the current tooltip, where the texture path is set to that of
		the iconPath parameter.

	EnhTooltip.NameFromLink(link)
		Given a link, returns the embedded item name.

	EnhTooltip.HyperlinkFromLink(link)
		Given a link, returns the blizzard hyperlink (eg: "item:12345:0:321:0")

	EnhTooltip.BaselinkFromLink(link)
		Given a link, returns the first 3 numbers from the item link (eg: "12345:0:321")

	EnhTooltip.QualityFromLink(link)
		Given a link, returns the numerical quality value (0=Poor/Gray ... 4=Epic/Purple)

	EnhTooltip.FakeLink(hyperlink, quality, name)
		Given a hyperlink, a numerical quality and an item name, does it's best to fabricate
		as authentic a link as it can. This link may not be suitable for messaging however.

	EnhTooltip.LinkType(link)
		Given a link, returns the type of link (eg: "item", "enchant")

	EnhTooltip.AddHook(hookType, hookFunc, position)
		Allows dependant addons to register a function for inclusion at key moments.
		Where:
			hookType = The type of event to be notified of. One of:
				tooltip - A tooltip is being displayed, hookFunc will be called as:
				EnhTooltip.AddTooltipHook(frame, name, link, quality, count, price)
				popup - A tooltip may be displayed, unless you want to popup something:
				popped = EnhTooltip.CheckPopupHook(name, link, quality, count, price, hyperlink)
					If your function returns true, then we won't present a tooltip
				merchant - Get called for each of a merchant's items.
				EnhTooltip.MerchantHook(frame, name, link, quality, count, price)
				trade - Get called when a tradeskill window is displayed / item selected
				EnhTooltip.TradeHook(type, selid)
					valid types: 'trade', 'craft'
					selID will be nil when the window is first displayed
				bank - You are at the bank and are able to scan it's containers
				EnhTooltip.BankHook()
				bag - One or more of the items in your bags has updated.
					EnhTooltip.BagHook()
			hookFunction = Your function (prototyped as above) that we will call.
			position = A number that determines calling order
				The default position if not supplied is 100.
				A lower number will make your tooltip information display earlier (higher)
				A higher number will call your tooltip later (lower)
				Auctioneer (if installed) gets called at position 50.
				Enchantrix (if installed) gets called at position 150.

	EnhTooltip.BreakLink(link)
		Given an item link, splits it into it's component parts as follows:
			itemID, randomProperty, enchantment, uniqueID, itemName,
				gemSlot1, gemSlot2, gemSlot3, gemSlotBonus = EnhTooltip.BreakLink(link)
			Note that the return order is not the same as the order of the items in the link
			(ie: randomProp and enchant are reversed from their link order)

	EnhTooltip.FindItemInBags(findName)
		Searches through your bags to find an item with the given name (exact match)
		It returns the following information about the item:
			bag, slot, itemID, randomProp, enchant, uniqID = EnhTooltip.FindItemInBags(itemName)

	EnhTooltip.SetElapsed(elapsed)
		If a value is given, adds the elapsed interval to our own internal timer.
			Checks to see if it is time to hide the tooltip.
		Returns the total elapsed time that the tooltip has been displayed since startup.

	EnhTooltip.SetMoneySpacing(spacing)
		Sets the amount of padding (if provided) that money should be given in the tooltips.
		Returns the current spacing.

	EnhTooltip.SetPopupKey(key)
		Sets a key (if provided), which if pressed while a tooltip is being displayed, checks
			for hooked functions that may wish to provide popups.
		Returns the current key.

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

-- setting version number
ENHTOOLTIP_VERSION = "5.0.0"
-- split up the version string, so it won't get replaced by the final version
-- number
if (ENHTOOLTIP_VERSION == "<".."%version%>") then
	ENHTOOLTIP_VERSION = "4.9.DEV"
end

local addonName = "Enhanced Tooltip"

local EMBED_R = 2
local EMBED_G = 3
local EMBED_B = 4


-- Initialize a storage space that all our functions can see
local private = {
	showIgnore = false,
	moneySpacing = 4,
	embedLines = {},   -- list of all embeded lines in/for the current tooltip
	eventTimer = 0,
	hideTime = 0,
	currentGametip = nil, -- tooltip frame, for which our enhanced tooltip frame
	                      -- currently displays the information
	currentItem = nil,
	forcePopupKey = "alt",
	oldChatItem = nil,
	lastFontStringIndex = 1,
	lastMoneyObjectIndex = 0,
	lastHeaderFontStringIndex = 1,
	numberHeaderLines = 0,
}

if not EnhTooltip then 
	EnhTooltip = {}
end

EnhTooltip.Version = ENHTOOLTIP_VERSION
EnhTooltip.Private = private

local public = EnhTooltip
local debugPrint

--Private print does not need to concatenate strings, simply use commas to seperate arguments. Also handles printing functions, nils, and tables without throwing errors
private.Print = function(...)
	local output, part
	for i=1, select("#", ...) do
		part = select(i, ...)
		part = tostring(part):gsub("{{", "|cffddeeff"):gsub("}}", "|r")
		if (output) then output = output .. " " .. part
		else output = part end
	end
	DEFAULT_CHAT_FRAME:AddMessage(output, 0.3, 0.9, 0.8)
end


------------------------
--  Hookable functions
------------------------

function public.AddTooltip(frame, name, link, quality, count, price)
	-- This is it.
	-- Hook this function when you have something to put into the
	-- tooltip and use the AddLine etc methods to do so.
end

function public.CheckPopup(name, link, quality, count, price, hyperlink)
	-- Hook this function to stop EnhTooltip putting up a tooltip
	-- Return true to stop EnhTooltip's tooltip.
end

function public.MerchantHook(merchant, slot, name, link, quality, count, price, limit)
	-- Hook this function to be notified of an item at a merchant
end

function public.BankHook()
	-- Hook this function to be alerted to do a bank scan
end

function public.BagHook()
	-- Hook this function to be alerted to do a bag scan
end

function public.TradeHook(type,selID)
	-- Hook this function to be notified when a trade window is
	-- displayed or an item therein is selected.
	--   type is one of: "trade", or "craft"
	--   selID can be nil when first opened, or the id of the selected item.
end

------------------------
-- Function definitions
------------------------

function private.HideTooltip(pvt)
	--debugPrint(debugstack(2,20,20),"HideTooltip","Debug")
	EnhancedTooltip:Hide()
	private.currentItem = nil
	private.hideTime = 0	
	--debugPrint("End","HideTooltip","Debug")
end

function public.HideTooltip()
	private.HideTooltip(false)
end

-- Iterate over numbered global objects
function public.GetglobalIterator(fmt, first, last)
	local i = tonumber(first) or 1
	return function()
		if last and (i > last) then
			return
		end
		local obj = getglobal(fmt:format(i))
		i = i + 1
		return obj, i - 1
	end
end

-- Create a new fontstring
function private.CreateNewFontString(tooltip)
	local tooltipName = tooltip:GetName()
	local currentFontStringIndex = private.lastFontStringIndex
	local nextFontStringIndex    = currentFontStringIndex + 1

	local newFontString = tooltip:CreateFontString(tooltipName.."Text"..nextFontStringIndex, "INFO", "GameFontNormal")
	newFontString:SetPoint("TOPLEFT", tooltipName.."Text"..currentFontStringIndex, "BOTTOMLEFT", 0, -1)
	newFontString:Hide()
	newFontString:SetTextColor(1.0,1.0,1.0)
	newFontString:SetFontObject("GameTooltipTextSmall")

	-- we do not update the lastFontStringIndex earlier to make sure that the new font string line has successfully been created
	private.lastFontStringIndex = nextFontStringIndex

	return newFontString
end

-- Create a new money object
function private.CreateNewMoneyObject(tooltip)
	private.lastMoneyObjectIndex = private.lastMoneyObjectIndex + 1

	local newMoneyObject = CreateFrame("Frame", tooltip:GetName().."Money"..private.lastMoneyObjectIndex, tooltip, "EnhancedTooltipMoneyTemplate")
	newMoneyObject:SetPoint("LEFT", tooltip:GetName().."Text1", "LEFT")
	newMoneyObject:Hide()
	return newMoneyObject
end

-- Create a new header fontstring
function private.CreateNewHeaderFontString(tooltip)
	local tooltipName = tooltip:GetName()
	local currentHeaderFontStringIndex = private.lastHeaderFontStringIndex
	private.lastHeaderFontStringIndex = currentHeaderFontStringIndex + 1

	local newFontString = tooltip:CreateFontString(tooltipName.."Header"..private.lastHeaderFontStringIndex, "INFO", "GameFontNormal")
	newFontString:SetPoint("TOPLEFT", tooltipName.."Header"..currentHeaderFontStringIndex, "BOTTOMLEFT", 0, -1)
	newFontString:Hide()
	newFontString:SetTextColor(1.0,1.0,1.0)
	newFontString:SetFontObject("GameTooltipTextSmall")
	return newFontString
end

function private.IsForceKeyPressed()
	return (
		(EnhTooltip.Settings.GetSetting("forceSuppresedTooltipKey") == "ctrl" and IsControlKeyDown()) or
		(EnhTooltip.Settings.GetSetting("forceSuppresedTooltipKey") == "alt" and IsAltKeyDown()) or
		(EnhTooltip.Settings.GetSetting("forceSuppresedTooltipKey") == "shift" and IsShiftKeyDown())
	)
end	
	
-------------------------------------------------------------------------------
-- This function returns the requested line object.
-- If the requested line does not exist, it will be created.
--
-- @param  line = line number of the font string line to
-- @return font string line object for the specified line
--
-- Note
--   This function is not absolutely nil safe. If anytime EnhancedTooltipTextX
--   is being removed by a 3rd person addon, this function will return nil!
--   Since this has not been the case, yet, I didn't implement more secure
--   code.
-------------------------------------------------------------------------------
function private.GetLine(line)
	if (line > private.lastFontStringIndex) then
		ret = private.CreateNewFontString(EnhancedTooltip)
	else
		ret = getglobal("EnhancedTooltipText"..line)
	end

	return ret
end

function private.Empty(item)
	if type(item) ~= 'table' then return end
	for k,v in pairs(item) do item[k] = nil end
end

function private.ClearTooltip(pvt)
	--debugPrint(debugstack(2,20,20),"ClearTooltip","Debug")
	if (not pvt) and (EnhTooltip.Settings.GetSetting("blockExternalCalls")) then
		return
	end

	private.HideTooltip(pvt)

	EnhancedTooltip.curEmbed       = false
	EnhancedTooltip.hasData        = false
	EnhancedTooltip.hasIcon        = false
	EnhancedTooltip.curHeaderEmbed = false

	EnhancedTooltipIcon:Hide()
	EnhancedTooltipIcon:SetTexture("Interface\\Buttons\\UI-Quickslot2")

	for ttText in public.GetglobalIterator("EnhancedTooltipText%d") do
		ttText:Hide()
		ttText.myMoney = nil
		ttText:SetTextColor(1.0,1.0,1.0)
		ttText:SetFontObject("GameTooltipTextSmall")
	end

	for ttHeader in public.GetglobalIterator("EnhancedTooltipHeader%d") do
		ttHeader:Hide()
		ttHeader.myMoney = nil
		ttHeader:SetTextColor(1.0,1.0,1.0)
		ttHeader:SetFontObject("GameTooltipTextSmall")
	end

	for ttMoney in public.GetglobalIterator("EnhancedTooltipMoney%d") do
		ttMoney.myLine = nil
		ttMoney:Hide()
	end

	EnhancedTooltipText1:SetPoint("TOPLEFT", EnhancedTooltip, "TOPLEFT", 10, -10)

	EnhancedTooltip.lineCount   = 0
	EnhancedTooltip.headerCount = 0
	EnhancedTooltip.moneyCount  = 0
	EnhancedTooltip.minWidth    = 0

	-- clear the embedLines table, using ipairs instead of = {} to allow
	-- reusing old tables, which should be quite common for this table
	private.Empty(private.embedLines)
	--debugPrint("End","ClearTooltip","Debug")
end

function public.ClearTooltip()
	private.ClearTooltip(false)
end

function public.GetBounds(object)
	local left, bottom, width, height = object:GetRect()
	left = left or 0
	bottom = bottom or 0
	width = width or 0
	height = height or 0

	local top = bottom + height
	local right = left + width
	local xCenter = left + (width / 2)
	local yCenter = bottom + (height / 2)

	return top, left, bottom, right, width, height, xCenter, yCenter
end
function public.GetRect(object)
	local top, left, bottom, right, width, height, xCenter, yCenter = public.GetBounds(object)
	return {
		top = top,
		left = left,
		bottom = bottom,
		right = right,
		width = width,
		height = height,
		xCenter = xCenter,
		yCenter = yCenter,
	}
end

function private.ShowTooltip(pvt, currentTooltip, skipEmbedRender)

	--debugPrint(debugstack(2,20,20),"ShowTooltip","Debug")

	-- prevent recursive calls to public.ShowTooltip()
	if (private.showIgnore) then
		return
	end
		
	if (EnhTooltip.Settings.GetSetting("suppressEnhancedTooltip") and not private.IsForceKeyPressed()) then
		return
	end
		
	if (not pvt) and (EnhTooltip.Settings.GetSetting("blockExternalCalls")) then
		return
	end


	-- if set to true, the flag indicates, that we have already repainted the
	-- game tooltip once and it is now properly aligned (i.e. has the correct
	-- width/height)
	local bTooltipRepainted = false

	-- First thing todo is to update the embeded tooltip to get the correct
	-- width/height it requires, if there are any embeded lines to be displayed.
	if (next(private.embedLines) and (not skipEmbedRender)) then
		private.EmbedRender(currentTooltip, private.embedLines)

		-- update the tooltip without calling our own public.ShowTooltip
		-- this will repaint the game tooltip and update its width and height so
		-- that our just added text is now displayed inside the tooltip
		private.showIgnore = true
		currentTooltip:Show()
		private.showIgnore = false
		bTooltipRepainted  = true
	end

	-- if there is no data for the enhanced tooltip frame, we've got nothing todo
	if (not EnhancedTooltip.hasData) then
		return
	end

	-- repaint the tooltip, if we haven't done so before, to get the tooltip's
	-- correct width/height including all the new lines other addons might add
	-- after our own call
	if not bTooltipRepainted then
		private.showIgnore = true
		currentTooltip:Show()
		private.showIgnore = false
	end

	local lineCount   = EnhancedTooltip.lineCount
	local headerCount = EnhancedTooltip.headerCount

	-- We set the position of the normal text lines just below the last header
	-- line, so they are displayed at the correct place.
	if (headerCount > 0) then
		EnhancedTooltipText1:SetPoint("TOPLEFT", "EnhancedTooltipHeader"..EnhancedTooltip.headerCount, "BOTTOMLEFT", 0, -1)
	end

	-- update the tooltip without calling public.ShowTooltip so we get the correct
	-- tooltip width
	private.showIgnore = true
	currentTooltip:Show()
	private.showIgnore = false

	local requestedWidth, requestedHeight = private.GetTooltipWidth(EnhancedTooltip), private.GetTooltipHeight(EnhancedTooltip)

	local currentWidth = currentTooltip:GetWidth()
	if (currentWidth < requestedWidth) then
		currentTooltip:SetWidth(requestedWidth - 20)
	else
		requestedWidth = currentWidth
	end

	private.AnchorEnhancedTooltip(currentTooltip, requestedHeight, requestedWidth)

	EnhancedTooltip:SetHeight(requestedHeight)
	EnhancedTooltip:SetWidth(requestedWidth)
	currentTooltip:SetWidth(requestedWidth)
	EnhancedTooltip:Show()

	for ttMoney in public.GetglobalIterator("EnhancedTooltipMoney%d") do
		if (ttMoney.myLine) then
			local myLine = getglobal(ttMoney.myLine)
			local ttMoneyWidth = ttMoney:GetWidth()
			local ttMoneyLineWidth = myLine:GetWidth()
			ttMoney:ClearAllPoints()
			if ((EnhancedTooltip.hasIcon) and (ttMoney.myLineNumber + headerCount < 4)) then
				ttMoney:SetPoint("LEFT", myLine, "RIGHT", requestedWidth - ttMoneyLineWidth - ttMoneyWidth - private.moneySpacing * 2 - 34, 0)
			else
				ttMoney:SetPoint("LEFT", myLine, "RIGHT", requestedWidth - ttMoneyLineWidth - ttMoneyWidth - private.moneySpacing * 2, 0)
			end
		end
	end
	--debugPrint("End","ShowTooltip","Debug")
end

function public.ShowTooltip(currentTooltip, skipEmbedRender)
	private.ShowTooltip(false, currentTooltip, skipEmbedRender)
end

-------------------------------------------------------------------------------
-- Attaches the enhanced tooltip window to the currentTooltip, according to
-- where the currentTooltip is shown and what it is attached to  at the moment.
--
-- called by:
--    public.ShowTooltip() - if the enhanced tooltip window is to be displayed
--
-- calls:
--    public.GetRect()           - unless currentTooltip is anchored to the cursor
--    ClearAllPoints()    - always
--    GetAnchorType()     - always
--    GetCursorPosition() - if currentTooltip is anchored to the cursor
--    GetHeight()         - if currentTooltip is anchored to another frame
--    GetName()           - always
--    GetPoint()          - always
--    GetScreenWidth()    - always
--    GetScreenHeight()   - always
--    Show()              - if currentTooltip is not anchored at all
--
-- parameters:
--    currentTooltip  - the tooltip the enhanced tooltip should be anchored to
--    requestedHeight - (number) the requested height for the enhanced tooltip
--                               window in pixel
--    requestedWidth  - (number) the requested width for the enhanced tooltip
--                               window in pixel
-------------------------------------------------------------------------------
function private.AnchorEnhancedTooltip(currentTooltip, requestedHeight, requestedWidth)
	-- We have to be careful in doing the placement calculations to take into
	-- scaling of the various frames we're placing.  GetEffectiveScale() will
	-- give us the conversion factor to the root scale.  However, the UIParent
	-- frame may not be in that scale itself.  In particular this is very important
	-- for vertical placement.
	local UIScale       = UIParent:GetEffectiveScale()
	local EnhancedScale = EnhancedTooltip:GetEffectiveScale()
	local currentScale  = currentTooltip:GetEffectiveScale()
	local ownerScale    = 1
	local screenWidth   = GetScreenWidth() * UIScale
	local screenHeight  = GetScreenHeight() * UIScale

	-- Convert the requested height and width to root units.
	requestedWidth  = requestedWidth  * EnhancedScale
	requestedHeight = requestedHeight * EnhancedScale

	-- Get the frame which the currentTooltip is attached to.
	-- We are using the first point, only, even if the gameTooltip is attached
	-- to multiple anchors, to reduce the code complexity.
	local _, currentTooltipOwner = currentTooltip:GetPoint(1)
	local align                  = currentTooltip:GetAnchorType()

	-- If the currentTooltip is already owned by EnhacedTooltip, meaning that we
	-- already aligned it somewhere, we have to get the EnhancedTooltip owner
	-- instead to get the correct frame to attach EnhancedTooltip and
	-- currentTooltip to.
	if currentTooltipOwner and currentTooltipOwner:GetName() == "EnhancedTooltip" then
		_, currentTooltipOwner = currentTooltipOwner:GetPoint(1)
	end

	-- Now that we know the owner grab their effective scale.
        if (currentTooltipOwner) then 
          ownerScale = currentTooltipOwner:GetEffectiveScale()
	end
	
	-- In case the current tooltip is attached to the cursor, currentTooltipOwner
	-- is nil and align is "ANCHOR_CURSOR".
	if align == "ANCHOR_CURSOR" then
		-- If the currentTooltip is set to be anchored to the cursor, we better
		-- not interfere and simply accept the fact that our tooltip might go
		-- off screen.

		local _, yCursorPos = GetCursorPosition(UIParent)

		-- anchor our tooltip to the bottom or top, depending on where the
		-- current tooltip is being displayed
		EnhancedTooltip:ClearAllPoints()
		if yCursorPos < screenHeight/2 then
			-- display EnhTooltip above the currentTooltip
			EnhancedTooltip:SetPoint("BOTTOMLEFT", currentTooltip, "TOPLEFT", 0, 0)
		else
		   -- display EnhTooltip below the currentTooltip
			EnhancedTooltip:SetPoint("TOPLEFT", currentTooltip, "BOTTOMLEFT", 0, 0)
		end
		EnhancedTooltip:SetScale(currentTooltip:GetScale())
	elseif not currentTooltipOwner or (currentTooltipOwner == UIParent) then
		-- If currentTooltipOwner is nil or UIParent, the current tooltip is not
		-- attached to any other frame, so we don't have to bother about correct
		-- alignment. The only thing to do is put the object
		-- underneath / shuffle it up, if there ain't enough room.
		private.showIgnore = true
		currentTooltip:Show()
		private.showIgnore = false

		local top, left, bottom, right, width, height, xCenter, yCenter = public.GetBounds(currentTooltip)

		-- Convert the bounds to root units, this could be moved to GetBounds
		-- but being a public function it may break other addons to do so.
		top     = top     * currentScale
		bottom  = bottom  * currentScale
		right   = right   * currentScale
		width   = width   * currentScale
		height  = height  * currentScale
		xCenter = xCenter * currentScale
		yCenter = yCenter * currentScale
		
		if (bottom - requestedHeight < 60) then
			currentTooltip:ClearAllPoints()
			-- Note the conversion of offsets back to UIParent scale
			currentTooltip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left / UIScale, (requestedHeight+60) / UIScale)
		end
		EnhancedTooltip:ClearAllPoints()
		if (xCenter < 6*screenWidth/10) then
			EnhancedTooltip:SetPoint("TOPLEFT", currentTooltip, "BOTTOMLEFT", 0,0)
		else
			EnhancedTooltip:SetPoint("TOPRIGHT", currentTooltip, "BOTTOMRIGHT", 0,0)
		end
		EnhancedTooltip:SetScale(currentTooltip:GetScale())
	else
		-- The tooltip is anchored to another frame but not to the cursor. So
		-- we should properly align it.  Note when aligning to another frame we
		-- have to be especially careful of scales not matching.
		local top, left, bottom, right, width, height, xCenter, yCenter = public.GetBounds(currentTooltipOwner)

		-- Convert the bounds to root units, this could be moved to GetBounds
		-- but being a public function it may break other addons to do so.
		top     = top     * ownerScale
		bottom  = bottom  * ownerScale
		right   = right   * ownerScale
		width   = width   * ownerScale
		height  = height  * ownerScale
		xCenter = xCenter * ownerScale
		yCenter = yCenter * ownerScale
		
		local xAnchor
		if (left - requestedWidth < screenWidth * 0.2) then
			xAnchor = "RIGHT"
		elseif (right + requestedWidth > screenWidth * 0.8) then
			xAnchor = "LEFT"
		elseif (align == "ANCHOR_LEFT") then
			xAnchor = "LEFT"
		else -- align == ANCHOR_RIGHT or ANCHOR_NONE or ANCHOR_PRESERVE
			xAnchor = "RIGHT"
		end

		local yAnchor
		if (yCenter < screenHeight/2) then
			yAnchor = "TOP"
		else
			yAnchor = "BOTTOM"
		end

		-- Handle the situation where there isn't enough room on the choosen side of
		-- the parent to display the tooltip. In that case we'll just shift tooltip
		-- enough to the left or right so that it doesn't hang off the screen.
		local xOffset = 0
		if (xAnchor == "RIGHT" and right + requestedWidth > screenWidth - 5) then
			xOffset = -(right + requestedWidth - screenWidth + 5)
		elseif (xAnchor == "LEFT" and left - requestedWidth < 5) then
			xOffset = -(left - requestedWidth - 5)
		end

		-- Handle the situation where there isn't enough room on the top or bottom of
		-- the parent to display the tooltip. In that case we'll just shift tooltip
		-- enough up or down so that it doesn't hang off the screen.
		local yOffset = 0
		local totalHeight = requestedHeight + (currentTooltip:GetHeight())*(currentScale)
		if (totalHeight > screenHeight) then
			-- In the case we absolutely can not make it fit just force a bottom 
			-- alignment and display as much as we can
			yAnchor = "BOTTOM"
			yOffset = -(bottom - totalHeight - 5)
		elseif (yAnchor == "TOP" and top + totalHeight > screenHeight - 5) then
			yOffset = -(top + totalHeight - screenHeight + 5)
		elseif (yAnchor == "BOTTOM" and bottom - totalHeight < 5) then
			yOffset = -(bottom - totalHeight - 5)
		end

		currentTooltip:ClearAllPoints()
		EnhancedTooltip:ClearAllPoints()
		local anchor = yAnchor..xAnchor

		-- Apply the anchor noting that SetPoint uses UIParent units so our offsets
		-- must all be converted to the UIParent scale.
		if (anchor == "TOPLEFT") then
			EnhancedTooltip:SetPoint("BOTTOMRIGHT", currentTooltipOwner, "TOPLEFT", (-5 + xOffset) / UIScale, (5 + yOffset) / UIScale)
			currentTooltip:SetPoint("BOTTOMRIGHT", EnhancedTooltip, "TOPRIGHT", 0,0)
		elseif (anchor == "TOPRIGHT") then
			EnhancedTooltip:SetPoint("BOTTOMLEFT", currentTooltipOwner, "TOPRIGHT", (5 + xOffset) / UIScale, (5 + yOffset) / UIScale)
			currentTooltip:SetPoint("BOTTOMLEFT", EnhancedTooltip, "TOPLEFT", 0,0)
		elseif (anchor == "BOTTOMLEFT") then
			currentTooltip:SetPoint("TOPRIGHT", currentTooltipOwner, "BOTTOMLEFT", (-5 + xOffset) / UIScale, (-5 + yOffset) / UIScale)
			EnhancedTooltip:SetPoint("TOPRIGHT", currentTooltip, "BOTTOMRIGHT", 0,0)
		else -- if (anchor == "BOTTOMRIGHT") then
			currentTooltip:SetPoint("TOPLEFT", currentTooltipOwner, "BOTTOMRIGHT", (5 + xOffset) / UIScale, (-5 + yOffset) / UIScale)
			EnhancedTooltip:SetPoint("TOPLEFT", currentTooltip, "BOTTOMLEFT", 0,0)
		end
		EnhancedTooltip:SetScale(currentTooltip:GetScale())
	end
end

function private.GetTooltipWidth(enhTooltip)
	local width = 0
	local headerCount = enhTooltip.headerCount
	for headerLine, index in public.GetglobalIterator(enhTooltip:GetName().."Header%d", 1, headerCount) do
		if (headerLine.myMoney) then
			if ((enhTooltip.hasIcon) and (index < 4)) then
				width = math.max(width, headerLine:GetWidth() + headerLine.myMoney:GetWidth() + private.moneySpacing + 20 + enhTooltip.hasIcon:GetWidth())
			else
				width = math.max(width, headerLine:GetWidth() + headerLine.myMoney:GetWidth() + private.moneySpacing + 20)
			end
		else
			if ((enhTooltip.hasIcon) and (index < 4)) then
				width = math.max(width, headerLine:GetWidth() + 20 + enhTooltip.hasIcon:GetWidth())
			else
				width = math.max(width, headerLine:GetWidth() + 20)
			end
		end
	end

	local lineCount = enhTooltip.lineCount
	for currentLine, index in public.GetglobalIterator(enhTooltip:GetName().."Text%d", 1, lineCount) do
		if (currentLine.myMoney) then
			if ((enhTooltip.hasIcon) and (index + headerCount < 4)) then
				width = math.max(width, currentLine:GetWidth() + currentLine.myMoney:GetWidth() + private.moneySpacing + 20 + enhTooltip.hasIcon:GetWidth())
			else
				width = math.max(width, currentLine:GetWidth() + currentLine.myMoney:GetWidth() + private.moneySpacing + 20)
			end
		else
			if ((enhTooltip.hasIcon) and (index + headerCount < 4)) then
				width = math.max(width, currentLine:GetWidth() + 20 + enhTooltip.hasIcon:GetWidth())
			else
				width = math.max(width, currentLine:GetWidth() + 20)
			end
		end
	end
	return width
end

function private.GetTooltipHeight(enhTooltip)
	local height = 0
	local lineCount = enhTooltip.lineCount
	local headerCount = enhTooltip.headerCount

	for headerLine in public.GetglobalIterator(enhTooltip:GetName().."Header%d", 1, headerCount) do
		height = height + headerLine:GetHeight() + 1
	end

	for currentLine in public.GetglobalIterator(enhTooltip:GetName().."Text%d", 1, lineCount) do
		height = height + currentLine:GetHeight() + 1
	end

	if (enhTooltip.hasIcon) then
		height = math.max(height, enhTooltip.hasIcon:GetHeight() - 6)
	end
	height = height + 20

	return height
end

-- calculate the gold, silver, and copper values based the amount of copper
function public.GetGSC(money)
	if (not money) then money = 0 end
	local g = math.floor(money / 10000)
	local s = math.floor((money - (g*10000)) / 100)
	local c = math.ceil(money - (g*10000) - (s*100))
	return g,s,c
end

-- formats money text by color for gold, silver, copper
function public.GetTextGSC(money, exact, dontUseColorCodes)
	local TEXT_NONE = "0"

	local GSC_GOLD="ffd100"
	local GSC_SILVER="e6e6e6"
	local GSC_COPPER="c8602c"
	local GSC_START="|cff%s%d|r"
	local GSC_PART=".|cff%s%02d|r"
	local GSC_NONE="|cffa0a0a0"..TEXT_NONE.."|r"

	if (not exact) and (money >= 10000) then
		-- Round to nearest silver
		money = math.floor(money / 100 + 0.5) * 100
	end
	local g, s, c = public.GetGSC(money)

	local gsc = ""
	if (not dontUseColorCodes) then
		local fmt = GSC_START
		if (g > 0) then
			gsc = gsc..fmt:format(GSC_GOLD, g)
			fmt = GSC_PART
		end
		if (s > 0) or (c > 0) then
			gsc = gsc..fmt:format(GSC_SILVER, s)
			fmt = GSC_PART
		end
		if (c > 0) then
			gsc = gsc..fmt:format(GSC_COPPER, c)
		end
		if (gsc == "") then
			gsc = GSC_NONE
		end
	else
		if (g > 0) then
			gsc = gsc .. g .. "g "
		end
		if (s > 0) then
			gsc = gsc .. s .. "s "
		end
		if (c > 0) then
			gsc = gsc .. c .. "c "
		end
		if (gsc == "") then
			gsc = TEXT_NONE
		end
	end
	return gsc
end

function private.EmbedRender(currentTooltip, lines)
	for pos, lData in ipairs(lines) do
		currentTooltip:AddLine(unpack(lData))
	end
end

--[[
	@param bExact (boolean) - optional parameter
		if true, then the copper value of the given moneyAmount will always be printed out
		if false (default), then the copper value of the given moneyAmount will not be printed out, if the moneyAmount is too high (see public.GetTextGSC for the exact limit)
		bExact has no meaning, if moneyAmount is nil.
]]
function public.AddLine(lineText, moneyAmount, embed, bExact)
	if (embed) and (private.currentGametip) then
		EnhancedTooltip.curEmbed = true
		local text = ""
		if (moneyAmount) then
			text = lineText .. ": " .. public.GetTextGSC(moneyAmount, bExact)
		else
			text = lineText
		end
		table.insert(private.embedLines, {text})
		return
	end
	EnhancedTooltip.hasData = true
	EnhancedTooltip.curEmbed = false

	local curLine = EnhancedTooltip.lineCount + 1
	local line    = private.GetLine(curLine)

	line:SetText(lineText)
	line:SetTextColor(1.0, 1.0, 1.0)
	line:Show()
	local lineWidth = line:GetWidth()

	EnhancedTooltip.lineCount = curLine
	if (moneyAmount and moneyAmount > 0) then
		local curMoney = EnhancedTooltip.moneyCount + 1

		local money
		if (curMoney > private.lastMoneyObjectIndex) then
			money = private.CreateNewMoneyObject(EnhancedTooltip)
		else
			money = getglobal("EnhancedTooltipMoney"..curMoney)
		end

		money:SetPoint("LEFT", line, "RIGHT", private.moneySpacing, 0)
		TinyMoneyFrame_Update(money, math.floor(moneyAmount))
		money.myLine = line:GetName()
		money.myLineNumber = curLine
		line.myMoney = money
		money:Show()
		getglobal("EnhancedTooltipMoney"..curMoney.."SilverButtonText"):SetTextColor(1.0,1.0,1.0)
		getglobal("EnhancedTooltipMoney"..curMoney.."CopperButtonText"):SetTextColor(0.86,0.42,0.19)
		EnhancedTooltip.moneyCount = curMoney
	end
end

function public.AddHeaderLine(lineText, moneyAmount, embed, bExact)
	moneyAmount = nil
	if (not lineText) then
		return
	end
	local curHeader = EnhancedTooltip.headerCount + 1
	EnhancedTooltip.headerCount = curHeader

	if (embed) and (private.currentGametip) then
		EnhancedTooltip.curHeaderEmbed = true
		local text = ""
		if (moneyAmount) then
			text = lineText .. ": " .. public.GetTextGSC(moneyAmount, bExact)
		else
			text = lineText
		end
		table.insert(private.embedLines, curHeader, {text})
		return
	end
	EnhancedTooltip.hasData = true
	EnhancedTooltip.curHeaderEmbed = false


	local line
	if (curHeader > private.lastHeaderFontStringIndex) then
		line = private.CreateNewHeaderFontString(EnhancedTooltip)
	else
		line = getglobal("EnhancedTooltipHeader"..curHeader)
	end

	line:SetText(lineText)
	line:SetTextColor(1.0, 1.0, 1.0)
	line:Show()
	local lineWidth = line:GetWidth()


	if (moneyAmount and moneyAmount > 0) then
		local curMoney = EnhancedTooltip.moneyCount + 1

		local money
		if (curMoney > private.lastMoneyObjectIndex) then
			money = private.CreateNewMoneyObject(EnhancedTooltip)
		else
			money = getglobal("EnhancedTooltipMoney"..curMoney)
		end

		money:SetPoint("LEFT", line, "RIGHT", private.moneySpacing, 0)
		TinyMoneyFrame_Update(money, math.floor(moneyAmount))
		money.myLine = line:GetName()
		money.myLineNumber = curHeader
		line.myMoney = money
		money:Show()
		getglobal("EnhancedTooltipMoney"..curMoney.."SilverButtonText"):SetTextColor(1.0,1.0,1.0)
		getglobal("EnhancedTooltipMoney"..curMoney.."CopperButtonText"):SetTextColor(0.86,0.42,0.19)
		EnhancedTooltip.moneyCount = curMoney
	end
end

function public.AddSeparator(embed)
	if (embed) and (private.currentGametip) then
		EnhancedTooltip.curEmbed = true
		table.insert(private.embedLines, {" "})
		return
	end
	EnhancedTooltip.hasData = true
	EnhancedTooltip.curEmbed = false

	local curLine = EnhancedTooltip.lineCount + 1
	local line    = private.GetLine(curLine)

	line:SetText(" ")
	line:SetTextColor(1.0, 1.0, 1.0)
	line:Show()
	EnhancedTooltip.lineCount = curLine
end

function public.LineColor(r, g, b)
	if (EnhancedTooltip.curEmbed) and (private.currentGametip) then
		local n = #private.embedLines
		private.embedLines[n][EMBED_R] = r
		private.embedLines[n][EMBED_G] = g
		private.embedLines[n][EMBED_B] = b
		return
	end
	local curLine = EnhancedTooltip.lineCount
	if (curLine == 0) then return end
	local line = getglobal("EnhancedTooltipText"..curLine)
	return line:SetTextColor(r, g, b)
end

function public.LineSize(fontSize)
	if (EnhancedTooltip.curEmbed) and (private.currentGametip) then
		return
	end

	local curLine = EnhancedTooltip.lineCount
	if (curLine == 0) then
		return
	end

	local line = getglobal("EnhancedTooltipText"..curLine)
	return line:SetFont(STANDARD_TEXT_FONT, fontSize)
end

function public.HeaderColor(r, g, b)
	local curLine = EnhancedTooltip.headerCount
	if (EnhancedTooltip.curHeaderEmbed) and (private.currentGametip) then
		private.embedLines[curLine][EMBED_R] = r
		private.embedLines[curLine][EMBED_G] = g
		private.embedLines[curLine][EMBED_B] = b
		return
	end
	if (curLine == 0) then return end
	local line = getglobal("EnhancedTooltipHeader"..curLine)
	return line:SetTextColor(r, g, b)
end

function public.HeaderSize(fontSize)
	if (EnhancedTooltip.curHeaderEmbed) and (private.currentGametip) then
		return
	end

	local curLine = EnhancedTooltip.headerCount
	if (curLine == 0) then
		return
	end

	local line = getglobal("EnhancedTooltipHeader"..curLine)
	return line:SetFont(STANDARD_TEXT_FONT, fontSize)
end

function public.HeaderQuality(quality)
	if ( quality ) then
		return public.HeaderColor(GetItemQualityColor(quality))
	else
		return public.HeaderColor(1.0, 1.0, 1.0)
	end
end

function public.LineQuality(quality)
	if ( quality ) then
		return public.LineColor(GetItemQualityColor(quality))
	else
		return public.LineColor(1.0, 1.0, 1.0)
	end
end

function public.SetIcon(iconPath)
	EnhancedTooltipIcon:SetTexture(iconPath)
	EnhancedTooltipIcon:Show()
	EnhancedTooltip.hasIcon = EnhancedTooltipIcon
end

function private.GtHookOnHide()
	local curName = ""
	local hidingName = this:GetName()
	if (private.currentGametip) then curName = private.currentGametip:GetName() end
	if (curName == hidingName) then
		HideObj = hidingName
		private.hideTime = private.eventTimer + 0.1
	end
end

function private.DoHyperlink(reference, link, button)

	-- Neither shift-click nor ctrl-click can open a new tooltip, so don't go any farther or else you might accidentally double the embedded tooltip
	if (IsShiftKeyDown() or IsControlKeyDown()) then
		return
	end

	-- Regular- or alt-clicking will close an existing tooltip, so if one is now visible it is new, and should be enhanced by us
	if (ItemRefTooltip:IsVisible()) then
		local itemName = ItemRefTooltipTextLeft1:GetText()
		-- Prevent multiple calls to show one tooltip
		if (itemName and private.currentItem ~= itemName) then
			local testPopup = false
			if (button == "RightButton") then
				testPopup = true
			end
			local callRes = private.TooltipCall(true, ItemRefTooltip, itemName, link, nil, nil, nil, testPopup, reference)
			if (callRes == true) then
				local hasEmbed = #private.embedLines > 0
				private.oldChatItem = {reference, link, button, hasEmbed}
			elseif (callRes == false) then
				return false
			end
		end
	end
end

function private.CheckHide()
	if (private.hideTime == 0) then return end

	if (private.eventTimer >= private.hideTime) then
		private.HideTooltip(true)
		if (HideObj and HideObj == "ItemRefTooltip") then
			-- closing chatreferenceTT?
			private.oldChatItem = nil
		elseif private.oldChatItem then
			-- closing another tooltip
			-- redisplay old chatlinkdata, if it was not embeded
			local reference, link, button, isEmbeded = unpack(private.oldChatItem)
			if not isEmbeded then
				private.DoHyperlink(reference, link, button)
			end
		end
	end
end

------------------------
-- ItemLink functions
------------------------

function public.LinkType(link)
	if type(link) ~= "string" then
		return
	end
	return link:match("|H(%a+):")
end

function public.NameFromLink(link)
	if (not link) then
		return
	end
	return link:match("|c%x+|Hitem:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+|h%[(.-)%]|h|r")
end

function public.HyperlinkFromLink(link)
	if( not link ) then
		return
	end
	return link:match("|H([^|]+)|h")
end

function public.BaselinkFromLink(link)
	if( not link ) then
		return
	end
	return link:match("|Hitem:(%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+):%p?%d+|h")
end

function public.QualityFromLink(link)
	if (not link) then return end
	local color = link:match("(|c%x+)|Hitem:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+:%p?%d+|h%[.-%]|h|r")
	if (color) then
		for i = 0, 6 do
			local _, _, _, hex = GetItemQualityColor(i)
			if color == hex then
				return i
			end
		end
	end
	return -1
end

function public.FakeLink(hyperlink, quality, name)
	-- make this function nilSafe, as it's a global one and might be used by external addons
	if (not hyperlink) then
		return
	end
	local sName, sLink, iQuality = GetItemInfo(hyperlink)

	if (sLink) then
		return sLink
	else
		if (not quality) then
			quality = iQuality or -1
		end
		if (not name) then
			name = sName or "unknown"
		end
		local _, _, _, color = GetItemQualityColor(quality)
		return color.. "|H"..hyperlink.."|h["..name.."]|h|r"
	end
end

-- Given a Blizzard item link, breaks it into it's itemID, randomProperty, enchantProperty, uniqueness, name and the four gemSlots.
function public.BreakLink(link)
	if (type(link) == number) then return link,0,0,0,"",0,0,0,0,0 end
	if (type(link) ~= 'string') then return end
	local itemID, enchant, gemSlot1, gemSlot2, gemSlot3, gemBonus, randomProp, uniqID, name = link:match("|Hitem:(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+)|h%[(.-)%]|h")
	local randomFactor = 0
	randomProp = tonumber(randomProp) or 0
	uniqID = tonumber(uniqID) or 0
	if (randomProp < 0 and uniqID < 0) then
		randomFactor = bit.band(uniqID, 65535)
	end

	return tonumber(itemID) or 0, tonumber(randomProp) or 0, tonumber(enchant) or 0, tonumber(uniqID) or 0, tostring(name), tonumber(gemSlot1) or 0, tonumber(gemSlot2) or 0, tonumber(gemSlot3) or 0, tonumber(gemBonus) or 0, randomFactor
end

------------------------
-- Tooltip generating function
------------------------

function private.TooltipCall(pvt, frame, name, link, quality, count, price, forcePopup, hyperlink, additional)
	if (not pvt) and (EnhTooltip.Settings.GetSetting("blockExternalCalls")) then
		return
	end
	if not link then return end

	private.currentGametip = frame
	private.hideTime = 0

	-- quality, count and price are optional parameters, so set them to their
    -- defaults, if they are not specified
	quality = quality or -1
    count   = count   or  1
	price   = price   or  0

	local itemSig = frame:GetName()
	itemSig = itemSig..link
	itemSig = itemSig.."|"..count
	itemSig = itemSig.."|"..price

	if (private.currentItem == itemSig) then
		-- We are already showing this... No point doing it again.
		private.ShowTooltip(pvt, private.currentGametip)
		return
	end

	private.currentItem = itemSig

	quality = quality or public.QualityFromLink(link)
	hyperlink = hyperlink or link
	local extract = public.HyperlinkFromLink(hyperlink)
	hyperlink = extract or hyperlink

	local showTip = true
	local popupKeyPressed = (
		(private.forcePopupKey == "ctrl" and IsControlKeyDown()) or
		(private.forcePopupKey == "alt" and IsAltKeyDown()) or
		(private.forcePopupKey == "shift" and IsShiftKeyDown())
	)

	if (forcePopup or popupKeyPressed) then
		-- check, if we should show the tooltip even if a popup is being displayed
		local popupTest = EnhTooltip.CheckPopup(name, link, quality, count, price, hyperlink, additional)
		if (popupTest) then
			showTip = false
		end
	end

	if (showTip) then
		private.ClearTooltip(pvt)
		EnhTooltip.AddTooltip(frame, name, link, quality, count, price, additional)
		private.ShowTooltip(pvt, frame)
		private.currentItem = itemSig
		return true
	else
		frame:Hide()
		public.HideTooltip(pvt)
		return false
	end
end

function public.TooltipCall(frame, name, link, quality, count, price, forcePopup, hyperlink, additional)
	private.TooltipCall(false, frame, name, link, quality, count, price, forcePopup, hyperlink, additional)
end

------------------------
-- Hook calling functions
------------------------
function private.MerchantScanner()
	local npcName = UnitName("NPC")
	local numMerchantItems = GetMerchantNumItems()
	local link, quality, name, texture, price, quantity, numAvailable, isUsable
	for i=1, numMerchantItems, 1 do
		link = GetMerchantItemLink(i)
		quality = public.QualityFromLink(link)
		name, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(i)
		return EnhTooltip.MerchantHook(npcName, i, name, link, quality, quantity, price, numAvailable)
	end
end

function private.CallBankHook()
	if not (BankFrame and BankFrame:IsVisible()) then return end
	return EnhTooltip.BankHook(0)
end

function private.CallBagHook(funcVars, event, bagNumber)
	if (bagNumber >= 5) and (bagNumber < 10) then
		if not (BankFrame and BankFrame:IsVisible()) then return end
		return EnhTooltip.BankHook(bagNumber)
	else
		return EnhTooltip.BagHook(bagNumber)
	end
end

function private.CallTradeHook(funcVars, event, selID)
	return EnhTooltip.TradeHook(funcVars[1], selID)
end



------------------------
-- Tooltip functions that we have hooked
------------------------

function private.chatHookOnHyperlinkShow(reference, link, button)
	--debugPrint("Enter","chatHookOnHyperlinkShow","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithChatHyperlink") and not private.IsForceKeyPressed()) then return end	
	private.DoHyperlink(reference, link, button)
end

function private.AfHookOnEnter(funcArgs, retVal, type, index)
	--debugPrint("Enter","AfHookOnEnter","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithAuction") and not private.IsForceKeyPressed()) then return end	
	local link = GetAuctionItemLink(type, index)
	if (link) then
		local name = public.NameFromLink(link)
		if (name) then
			local aiName, aiTexture, aiCount, aiQuality, aiCanUse, aiLevel, aiMinBid, aiMinIncrement, aiBuyoutPrice, aiBidAmount, aiHighBidder, aiOwner = GetAuctionItemInfo(type, index)

			local aiNextBid = aiMinBid
			if (aiBidAmount>0) then aiNextBid = aiBidAmount + aiMinIncrement end

			if not private.priceTable then
				private.priceTable = {}
			end
			private.priceTable[0] = "AuctionPrices"
			private.priceTable[1] = aiBuyoutPrice
			private.priceTable[2] = aiMinBid
			private.priceTable[3] = aiNextBid

			return private.TooltipCall(true, GameTooltip, name, link, aiQuality, aiCount, nil, nil, nil, private.priceTable)
		end
	end
end

function private.GtHookSetLootItem(funcArgs, retVal, frame, slot)
	--debugPrint("Enter","GtHookSetLootItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithLootAndLootRoll") and not private.IsForceKeyPressed()) then return end	
	local link = GetLootSlotLink(slot)
	local name = public.NameFromLink(link)
	if (name) then
		local texture, item, quantity, quality = GetLootSlotInfo(slot)
		quality = quality or public.QualityFromLink(link)
		return private.TooltipCall(true, GameTooltip, name, link, quality, quantity)
	end
end

function private.GtHookSetQuestItem(funcArgs, retVal, frame, qtype, slot)
	--debugPrint("Enter","GtHookSetQuestItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithQuests") and not private.IsForceKeyPressed()) then return end	
	local link = GetQuestItemLink(qtype, slot)
	if (link) then
		local name, texture, quantity, quality, usable = GetQuestItemInfo(qtype, slot)
		return private.TooltipCall(true, GameTooltip, name, link, quality, quantity)
	end
end

function private.GtHookSetQuestLogItem(funcArgs, retVal, frame, qtype, slot)
	--debugPrint("Enter","GtHookSetQuestLogItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithQuests") and not private.IsForceKeyPressed()) then return end	
	local link = GetQuestLogItemLink(qtype, slot)
	if (link) then
		local name, texture, quantity, quality, usable = GetQuestLogRewardInfo(slot)
		name = name or public.NameFromLink(link)
		quality = public.QualityFromLink(link) -- I don't trust the quality returned from the above function.

		return private.TooltipCall(true, GameTooltip, name, link, quality, quantity)
	end
end

function private.GtHookSetBagItem(funcArgs, retVal, frame, frameID, buttonID)
	--debugPrint("Enter","GtHookSetBagItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithBagsAndKeyRing") and not private.IsForceKeyPressed()) then return end	
	local link = GetContainerItemLink(frameID, buttonID)
	local name = public.NameFromLink(link)

	if (name) then
		local texture, itemCount, locked, quality, readable = GetContainerItemInfo(frameID, buttonID)
		quality = (quality ~= -1 and quality) or public.QualityFromLink(link)

		return private.TooltipCall(true, GameTooltip, name, link, quality, itemCount)
	end
end

function private.GtHookSetInboxItem(funcArgs, retVal, frame, index, attachIndex)
	--debugPrint("Enter","GtHookSetInboxItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithMail") and not private.IsForceKeyPressed()) then return end	
	local name, _, count, quality = GetInboxItem(index, attachIndex)
	if (name) then
		local itemString = GetInboxItemLink(index, attachIndex)
		local _, itemLink = GetItemInfo(itemString)
		return private.TooltipCall(true, GameTooltip, name, itemLink, quality, count)
	end
end

function private.GtHookSetSendMailItem(funcArgs, retVal, frame, index, attachIndex)
	--debugPrint("Enter","GtHookSetSendMailItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithMail") and not private.IsForceKeyPressed()) then return end	
	local name, _, count, quality = GetSendMailItem(index, attachIndex)
	if (name) then
		local itemString = GetSendMailItemLink(index, attachIndex)
		local _, itemLink = GetItemInfo(itemString)
		return private.TooltipCall(true, GameTooltip, name, itemLink, quality, count)
	end
end

function private.GtHookSetInventoryItem(funcArgs, retVal, frame, unit, slot)
	--debugPrint("Slot: "..tostring(slot),"GtHookSetInventoryItem","Debug")
	if (slot >= 0 and slot<= 19) then
		if (not EnhTooltip.Settings.GetSetting("showWithCharacterInventory") and not private.IsForceKeyPressed()) then return end	
	end
	
	if (slot >= 20 and slot<= 23) then
		if (not EnhTooltip.Settings.GetSetting("showWithBagBar") and not private.IsForceKeyPressed()) then return end	
	end

	if (slot >= 40 and slot<= 67) then
		if (not EnhTooltip.Settings.GetSetting("showWithBank") and not private.IsForceKeyPressed()) then return end	
	end

	if (slot >= 68 and slot<= 74) then
		if (not EnhTooltip.Settings.GetSetting("showWithBagBar") and not private.IsForceKeyPressed()) then return end	
	end

	if (slot >= 87 and slot<= 118) then
		if (not EnhTooltip.Settings.GetSetting("showWithBagsAndKeyRing") and not private.IsForceKeyPressed()) then return end	
	end

	--if true then return end
	local link = GetInventoryItemLink(unit, slot)
	if (link) then
		local name = public.NameFromLink(link)
		local quantity
		if (slot >= 20 and slot <= 23) then
			-- Workaround for bag slots. Quiver slots report the number of
			-- arrows in there instead of 1 for the actual bag.
			-- And well, bags aren't stackable anyway, so here you go:
			quantity = 1
		else
			-- Should be 1 for anything but quivers, because even empty slots
			-- return 1.. but who knows what crazy stuff Blizzard will add ;)
			quantity = GetInventoryItemCount(unit, slot)
		end
		local quality = GetInventoryItemQuality(unit, slot)
		quality = quality or public.QualityFromLink(link)

		return private.TooltipCall(true, GameTooltip, name, link, quality, quantity)
	end
end

function private.GtHookSetMerchantItem(funcArgs, retVal, frame, slot)
	--debugPrint("Enter","GtHookSetMerchantItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithMerchants") and not private.IsForceKeyPressed()) then return end	
	local link = GetMerchantItemLink(slot)
	if (link) then
		local name, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(slot)
		local quality = public.QualityFromLink(link)
		return private.TooltipCall(true, GameTooltip, name, link, quality, quantity, price)
	end
end

function private.GtHookSetCraftItem(funcArgs, retVal, frame, skill, slot)
	--debugPrint("Enter","GtHookSetCraftItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithProfessions") and not private.IsForceKeyPressed()) then return end	
	local link
	if (slot) then
		link = GetCraftReagentItemLink(skill, slot)
		if (link) then
			local name, texture, quantity, quantityHave = GetCraftReagentInfo(skill, slot)
			local quality = public.QualityFromLink(link)
			return private.TooltipCall(true, GameTooltip, name, link, quality, quantity)
		end
	else
		link = GetCraftItemLink(skill)
		if (link) then
			local name = public.NameFromLink(link)
			local quality = public.QualityFromLink(link)
			return private.TooltipCall(true, GameTooltip, name, link, quality)
		end
	end
end

function private.GtHookSetCraftSpell(funcArgs, retVal, frame, slot)
	--debugPrint("Enter","GtHookSetCraftSpell","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithProfessions") and not private.IsForceKeyPressed()) then return end	
	local name = GetCraftInfo(slot)
	local link = GetCraftItemLink(slot)
	if name and link then
		return private.TooltipCall(true, GameTooltip, name, link)
	end
end

function private.GtHookSetTradeSkillItem(funcArgs, retVal, frame, skill, slot)
	--debugPrint("Enter","GtHookSetTradeSkillItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithProfessions") and not private.IsForceKeyPressed()) then return end	
	local link
	if (slot) then
		link = GetTradeSkillReagentItemLink(skill, slot)
		if (link) then
			local name, texture, quantity, quantityHave = GetTradeSkillReagentInfo(skill, slot)
			local quality = public.QualityFromLink(link)
			return private.TooltipCall(true, GameTooltip, name, link, quality, quantity)
		end
	else
		link = GetTradeSkillItemLink(skill)
		if (link) then
			local name = public.NameFromLink(link)
			local quality = public.QualityFromLink(link)
			return private.TooltipCall(true, GameTooltip, name, link, quality)
		end
	end
end

function public.FindItemInBags(findName)
	for bag = 0, 4, 1 do
		size = GetContainerNumSlots(bag)
		if (size) then
			for slot = size, 1, -1 do
				local link = GetContainerItemLink(bag, slot)
				if (link) then
					local itemID, randomProp, enchant, uniqID, itemName = public.BreakLink(link)
					if (itemName == findName) then
						return bag, slot, itemID, randomProp, enchant, uniqID
					end
				end
			end
		end
	end
end

function private.GtHookSetAuctionSellItem(funcArgs, retVal, frame)
	--debugPrint("Enter","GtHookSetAuctionSellItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithAuction") and not private.IsForceKeyPressed()) then return end	
	local name, texture, quantity, quality, canUse, price = GetAuctionSellItemInfo()
	if (name) then
		local bag, slot = public.FindItemInBags(name)
		if (bag) then
			local link = GetContainerItemLink(bag, slot)
			if (link) then
				return private.TooltipCall(true, GameTooltip, name, link, quality, quantity, price)
			end
		end
	end
end

function private.GtHookSetTradePlayerItem(funcArgs, retVal, frame, index)
	--debugPrint("Enter","GtHookSetTradePlayerItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithTrade") and not private.IsForceKeyPressed()) then return end	
	local link = GetTradePlayerItemLink(index)
	local name, texture, itemCount, quality = GetTradePlayerItemInfo(index)
	
	if (name) then
		return private.TooltipCall(true, GameTooltip, name, link, quality, itemCount)
	end
end

function private.GtHookSetTradeTargetItem(funcArgs, retVal, frame, index)
	--debugPrint("Enter","GtHookSetTradeTargetItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithTrade") and not private.IsForceKeyPressed()) then return end	
	local link = GetTradeTargetItemLink(index)
	local name, texture, itemCount, quality = GetTradeTargetItemInfo(index)
	
	if (name) then
		return private.TooltipCall(true, GameTooltip, name, link, quality, itemCount)
	end
end

function private.GtHookSetGuildBankItem(funcArgs, retVal, frame, tab, slot)
	--debugPrint("Enter","GtHookSetGuildBankItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithGuildBank") and not private.IsForceKeyPressed()) then return end	
	local link = GetGuildBankItemLink(tab, slot)
	local name = public.NameFromLink(link)

	if (name) then
		local texture, itemCount, locked = GetGuildBankItemInfo(tab, slot)
		local quality = public.QualityFromLink(link)
		return private.TooltipCall(true, GameTooltip, name, link, quality, itemCount)
	end
end

function private.GtHookSetHyperlink(funcArgs, retVal, frame, link)
	--debugPrint("Enter","GtHookSetHyperlink","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithOther") and not private.IsForceKeyPressed()) then return end	
	--debugPrint("Enter2","GtHookSetHyperlink","Debug")
	if (link) then
		local name, link, quality = GetItemInfo(link)
		if (name) then
			return private.TooltipCall(true, GameTooltip, name, link, quality)
		end
	end
end

function private.GtSetTrainerService(funcArgs, retVal, frame, index)
	--debugPrint("Enter","GtSetTrainerService","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithProfessions") and not private.IsForceKeyPressed()) then return end	
	local link = GetTrainerServiceItemLink(index)
	--debugPrint(tostring(link),"GtSetTrainerService","Debug")
	if (link) then
		local name, link, quality = GetItemInfo(link)
		if (name) then
			return private.TooltipCall(true, GameTooltip, name, link, quality)
		end
	end
end

function private.GtSetLootRollItem(funcArgs, retVal, frame, id)
	debugPrint("Enter","GtSetLootRollItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithLootAndLootRoll") and not private.IsForceKeyPressed()) then return end	
	local link = GetLootRollItemLink(id)
	local texture, name, itemCount, quality = GetLootRollItemInfo(id);
	if (name) then
		return private.TooltipCall(true, GameTooltip, name, link, quality, itemCount)
	end
end

function private.GtSetBuybackItem(funcArgs, retVal, frame, slot)
	--debugPrint("Enter","GtSetBuybackItem","Debug")
	if (not EnhTooltip.Settings.GetSetting("showWithMerchants") and not private.IsForceKeyPressed()) then return end	
	local link = GetBuybackItemLink(slot)
	local name, texture, price, itemCount = GetBuybackItemInfo(slot);
	local quality = public.QualityFromLink(link)
	if (name) then
		return private.TooltipCall(true, GameTooltip, name, link, quality, itemCount)
	end
end


function private.GtHookSetText(funcArgs, retval, frame)
	-- Nothing to do for plain text
	if (private.currentGametip == frame) then
		-- use proper tail call, so we don't need any extra stack space
		return public.ClearTooltip()
	end
end

function private.GtHookAppendText(funcArgs, retVal, frame)
	if (private.currentGametip and private.currentItem) then
		return public.ShowTooltip(private.currentGametip, true)
	end
end

function private.GtHookShow(funcArgs, retVal, frame)
	if (private.hookRecursion) then
		return
	end
	if (private.currentGametip and private.currentItem) then
		private.hookRecursion = true
		public.ShowTooltip(private.currentGametip, true)
		private.hookRecursion = nil
	end
end

function private.ImiHookOnEnter()
	if(not IM_InvList) then return end
	local id = this:GetID()

	if(id == 0) then
		id = this:GetParent():GetID()
	end
	local offset = FauxScrollFrame_GetOffset(ItemsMatrix_IC_ScrollFrame)
	local item = IM_InvList[id + offset]

	if (not item) then return end
	local imlink = ItemsMatrix_GetHyperlink(item.name)
	local link = public.FakeLink(imlink, item.quality, item.name)
	if (link) then
		return public.TooltipCall(GameTooltip, item.name, link, item.quality, item.count)
	end
end

function private.ImHookOnEnter()
	local imlink = ItemsMatrix_GetHyperlink(this:GetText())
	if (imlink) then
		local name = this:GetText()
		local link = public.FakeLink(imlink, -1, name)
		return public.TooltipCall(GameTooltip, name, link)
	end
end

function private.GetLootLinkServer()
	return LootLinkState.ServerNamesToIndices[GetCVar("realmName")]
end

function private.GetLootLinkLink(name)
	local itemLink = ItemLinks[name]
	if (itemLink and itemLink.c and itemLink.i and LootLink_CheckItemServer(itemLink, private.GetLootLinkServer())) then
		local item = itemLink.i:gsub("(%d+):(%d+):(%d+):(%d+)", "%1:0:%3:%4")
		local link = "|c"..itemLink.c.."|Hitem:"..item.."|h["..name.."]|h|r"
		return link
	end
	return
end

function private.LlHookOnEnter()
	local name = this:GetText()
	local link = private.GetLootLinkLink(name)
	if (link) then
		local quality = public.QualityFromLink(link)
		return public.TooltipCall(GameTooltip, name, link, quality)
	end
end

------------------------
-- Operation functions
------------------------

function public.SetElapsed(elapsed)
	if (elapsed) then
		private.eventTimer = private.eventTimer + elapsed
	end
	private.CheckHide()
	return private.eventTimer
end

function public.SetMoneySpacing(spacing)
	private.moneySpacing = spacing or private.moneySpacing
	return private.moneySpacing
end

function public.SetPopupKey(key)
	private.forcePopupKey = key or private.forcePopupKey
	return private.forcePopupKey
end

local DebugLib
local debug, assert
if LibStub then
	DebugLib = LibStub("DebugLib")
	if DebugLib then
		debug, assert = DebugLib(addonName)
	else
		function debug() end
		assert = debug
	end
end  


------------------------
-- Debug functions
------------------------
-------------------------------------------------------------------------------
-- Prints the specified message to nLog.
--
-- syntax:
--    errorCode, message = debugPrint([message][, category][, title][, errorCode][, level])
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
function debugPrint(message, category, title, errorCode, level)
	return debug(message, category, title, errorCode, level)
end
EnhTooltip.DebugPrint	= debugPrint;


------------------------
-- Load and initialization functions
------------------------

--The new blizzard addons are called:
--	Blizzard_TrainerUI,		Blizzard_MacroUI,		Blizzard_RaidUI,		Blizzard_TradeSkillUI,
--	Blizzard_InspectUI,		Blizzard_BattlefieldMinimap,	Blizzard_TalentUI,
--	Blizzard_AuctionUI,		Blizzard_BindingUI,		Blizzard_CraftUI


-- Hook in alternative Auctionhouse tooltip code
function private.HookAuctionHouse()
	Stubby.RegisterFunctionHook("AuctionFrameItem_OnEnter", 200, private.AfHookOnEnter)
end

-- Hook the ItemsMatrix tooltip functions
function private.HookItemsMatrix()
	Stubby.RegisterFunctionHook("IMInv_ItemButton_OnEnter", 200, private.ImiHookOnEnter)
	Stubby.RegisterFunctionHook("ItemsMatrixItemButton_OnEnter", 200, private.ImHookOnEnter)
end

-- Hook the LootLink tooltip function
function private.HookLootLink()
	if (LootLinkItemButton_OnEnter) then
		Stubby.RegisterFunctionHook("LootLinkItemButton_OnEnter", 200, private.LlHookOnEnter)
	end
end

-- Hook tradeskill functions
function private.HookTradeskill()
	Stubby.RegisterFunctionHook("TradeSkillFrame_Update", 200, private.CallTradeHook, "trade", "")
	Stubby.RegisterFunctionHook("TradeSkillFrame_SetSelection", 200, private.CallTradeHook, "trade", "")
end

-- Hook craft functions
function private.HookCraft()
	Stubby.RegisterFunctionHook("CraftFrame_Update", 200, private.CallTradeHook, "craft", "")
	Stubby.RegisterFunctionHook("CraftFrame_SetSelection", 200, private.CallTradeHook, "craft", "")
end


function private.TtInitialize()
	----  Establish hooks to all the game tooltips.

	-- Hook in alternative Chat/Hyperlinking code
	--Use secure hook to prevent Tainting GM ticket management code
	hooksecurefunc("ChatFrame_OnHyperlinkShow", private.chatHookOnHyperlinkShow)

	-- Game tooltips
	Stubby.RegisterFunctionHook("GameTooltip.SetLootItem", 200, private.GtHookSetLootItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetQuestItem", 200, private.GtHookSetQuestItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetQuestLogItem", 200, private.GtHookSetQuestLogItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetInboxItem", 200, private.GtHookSetInboxItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetInventoryItem", 200, private.GtHookSetInventoryItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetBagItem", 200, private.GtHookSetBagItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetMerchantItem", 200, private.GtHookSetMerchantItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetCraftItem", 200, private.GtHookSetCraftItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetCraftSpell", 200, private.GtHookSetCraftSpell)
	Stubby.RegisterFunctionHook("GameTooltip.SetTradeSkillItem", 200, private.GtHookSetTradeSkillItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetAuctionSellItem", 200, private.GtHookSetAuctionSellItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetGuildBankItem", 200, private.GtHookSetGuildBankItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetTradePlayerItem", 200, private.GtHookSetTradePlayerItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetTradeTargetItem", 200, private.GtHookSetTradeTargetItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetHyperlink", 200, private.GtHookSetHyperlink)
	
	Stubby.RegisterFunctionHook("GameTooltip.SetSendMailItem", 200, private.GtHookSetSendMailItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetTrainerService", 200, private.GtSetTrainerService)
	Stubby.RegisterFunctionHook("GameTooltip.SetLootRollItem", 200, private.GtSetLootRollItem)
	Stubby.RegisterFunctionHook("GameTooltip.SetBuybackItem", 200, private.GtSetBuybackItem)

	Stubby.RegisterFunctionHook("GameTooltip.SetText", 200, private.GtHookSetText)
	Stubby.RegisterFunctionHook("GameTooltip.AppendText", 200, private.GtHookAppendText)
	Stubby.RegisterFunctionHook("GameTooltip.Show", 200, private.GtHookShow)
	Stubby.RegisterFunctionHook("GameTooltip_OnHide", 200, private.GtHookOnHide)

	-- Establish hooks for us to use.
	Stubby.RegisterAddOnHook("Blizzard_AuctionUI", "EnhTooltip", private.HookAuctionHouse)
	Stubby.RegisterAddOnHook("ItemsMatrix", "EnhTooltip", private.HookItemsMatrix)
	Stubby.RegisterAddOnHook("LootLink", "EnhTooltip", private.HookLootLink)
	Stubby.RegisterAddOnHook("Blizzard_TradeSkillUI", "EnhTooltip", private.HookTradeskill)
	Stubby.RegisterAddOnHook("Blizzard_CraftUI", "EnhTooltip", private.HookCraft)

	-- Register event notification
	Stubby.RegisterEventHook("MERCHANT_SHOW", "EnhTooltip", private.MerchantScanner)
	Stubby.RegisterEventHook("TRADE_SKILL_SHOW", "EnhTooltip", private.CallTradeHook, 'trade')
	Stubby.RegisterEventHook("TRADE_SKILL_CLOSE", "EnhTooltip", private.CallTradeHook, 'trade')
	Stubby.RegisterEventHook("CRAFT_SHOW", "EnhTooltip", private.CallTradeHook, 'craft')
	Stubby.RegisterEventHook("CRAFT_CLOSE", "EnhTooltip", private.CallTradeHook, 'craft')
	Stubby.RegisterEventHook("BANKFRAME_OPENED", "EnhTooltip", private.CallBankHook)
	Stubby.RegisterEventHook("PLAYERBANKSLOTS_CHANGED", "EnhTooltip", private.CallBankHook)
	Stubby.RegisterEventHook("BAG_UPDATE", "EnhTooltip", private.CallBagHook)
	Stubby.RegisterEventHook("VARIABLES_LOADED", "EnhTooltip", private.onVariablesLoaded)
end


-- =============== EVENT HANDLERS =============== --

function public.OnLoad()
	EnhancedTooltip:SetBackdropColor(0,0,0)
	private.ClearTooltip(true)
	private.TtInitialize()
end

function private.onVariablesLoaded()
	EnhTooltip.SideIcon.Update()
end
