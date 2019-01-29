--[[-------------------------------------------------------------------------
  LightHeaded -  Copyright 2007 by Jim Whitehead

  This is a very simple addon which compiles quest information and comments
  from http://www.wowhead.com and displays them in-game.  This addon was 
  inspired by Wowhead_Quests by sid367, and I thank him for the idea

  IMPORTANT: Addon authors that wish to use this API and data should
  include the wowhead logo in the frame that displays this information.
  They are kind enough to let me continue parsing their database, and we
  owe them at least that much.  Thank you.
---------------------------------------------------------------------------]]

LightHeaded = {}
LightHeaded.rev = tonumber(string.match("$Revision: 176 $", "(%d+)") or 1)

-- This stores all of the quest data
local questdata = {}
local stack = {} -- Stack for navigation
local KFMT = "%s\031%s"
local noop = function() return nil end

function LightHeaded:Enable()
	-- Database defaults
	self.defaults = {
		profile = {
			attached = true,
			open = true,
			singlepage = false,
			positions = {
			},
			sound = true,
			bgalpha = 1.0,
			debug = false,
		},
	}

	self.db = self:InitializeDB("LightHeadedDB", self.defaults)
	self:CreateGUI()
	hooksecurefunc("QuestLogTitleButton_OnClick", function() self:QuestLogTitleButton_OnClick() end)

	-- Create slash command
	self.cmd = self:InitializeSlashCommand("LightHeaded config options", "LIGHTHEADED", "lh", "lightheaded", "lighthead")
	self.cmd:RegisterSlashHandler("attach - Re-Attaches LightHeaded to the Quest Log", "^attach$", "AttachFrame")
	self.cmd:RegisterSlashHandler("detach - Detach LightHeaded from the Quest Log", "^detach$", "DetachFrame")
	self.cmd:RegisterSlashHandler("sound - Toggles open/close sound on or off", "^sound$", "ToggleSound")
	self.cmd:RegisterSlashHandler("page - Toggle showing quest information on a single page, or multiple pages.", "^page$", "TogglePages")
	self.cmd:RegisterSlashHandler("bgalpha <0.0-1.0> - Changes the alpha transparency of the LightHeaded background", "^bgalpha (%d%.?%d?)$", "ChangeBGAlpha")
	self.cmd:RegisterSlashHandler("debug - Toggles debug mode on/off.", "^debug$", "ToggleDebug")

	-- Set initial settings
	self:ChangeBGAlpha(self.db.profile.bgalpha)
	if self.db.profile.debug then
		self:EnableDebug(1)
	else
		self:EnableDebug()
	end

	-- Snag deDE localisation
	if GetLocale() == "deDE" then
		self:Debug(1, "Loading LightHeaded_deDE_Data")
		local succ,reason = LoadAddOn("LightHeaded_deDE_Data")
		if succ ~= 1 then
			self:Debug(1, "Could not load LightHeaded_deDE_Data:", reason)
		end
		collectgarbage("collect")
	end
end

function LightHeaded:QuestLogTitleButton_OnClick(frame, button)
	local idx = GetQuestLogSelection()
	if not idx then return end

	local title, level, _, _, _, header = GetQuestLogTitle(idx)
	if header then return end
	if not title then return end

	-- Clear the stack
	for k,v in pairs(stack) do stack[k] = nil end

	if self.db.profile.singlepage then
		self:UpdateFrame(title, level, nil)
	else
		self:UpdateFrame(title, level, 1)
	end
end

function LightHeaded:TranslateTitle(title)
	-- German translations from buffed.de
	if LH_Quests_deDE then
		return LH_Quests_deDE[title] or title
	end

	return title
end

function LightHeaded:GetBracket(level)
	if type(level) == "string" then
		level = tonumber(level)
	elseif type(level) == "nil" then
		self:Print(debugstack())
	end

	if type(level) ~= "number" then
		self:Print(debugstack())
	end

	if level >= 1 and level <= 20 then
		return 20
	elseif level > 20 and level <= 40 then
		return 40
	elseif level > 40 and level <= 60 then
		return 60
	elseif level > 60 and level <= 80 then
		return 80
	end
end

function LightHeaded:LoadQIDData(qid)
	if not LH_QuestData then
		self:Debug(1, "Loading LightHeaded_Quest_Data")
		local succ,reason = LoadAddOn("LightHeaded_Quest_Data")
		if succ ~= 1 then
			self:Debug(1, "Could not load LightHeaded_Quest_Data:", reason)
		end
		collectgarbage("collect")
	end
	return LH_QuestData and LH_QuestData[qid]
end

function LightHeaded:KeyMatchQID(title, level, qid)
	if LH_QuestData then
		local key = self:GetKey(title, level)

		if LH_QuestData[key] then return 
			LH_QuestData[key]
		end

		for k,v in pairs(LH_QuestData) do
			if v == key and k == qid then
				return true
			end
		end
	end		
end

-- Converts a QID to name, level
function LightHeaded:QIDToTitleLevel(qid)
	qid = tonumber(qid)
	if LH_QuestData then
		local key = LH_QuestData[qid]

		if not key then
			return "Quest " .. qid, -1
		end

		local title,level = key:match("([^\031]+)\031(.+)")
		return title,level
	end
end

function LightHeaded:LoadNPCData(id)
	if not LH_NPCData then
		self:Debug(1, "Loading LightHeaded_NPC_Data")
		local succ,reason = LoadAddOn("LightHeaded_NPC_Data")
		if succ ~= 1 then
			self:Debug(1, "Could not load LightHeaded_NPC_Data:", reason)
		end
		collectgarbage("collect")
	end
	return LH_NPCData and LH_NPCData[id]
end

function LightHeaded:LoadQuestData(title, level)
	local bracket = self:GetBracket(level)
	if not bracket then
		-- Bad input
		return nil
	end

	local key = KFMT:format(title, level)
	if questdata and questdata[bracket] then return questdata[bracket][key] end

	local faction = UnitFactionGroup("player")
	local varname = "LH_"..faction.."_"..bracket
	local addonname = ("LightHeaded_%s%s_Data"):format(faction:sub(1,1), bracket)

	if not getglobal(varname) then
		self:Debug(1, "Loading " .. addonname)
		local succ,reason = LoadAddOn(addonname)
		if succ ~= 1 then
			self:Debug(1, "Could not load " .. addonname, reason)
		end
		collectgarbage("collect")
	end

	questdata[bracket] = getglobal(varname)

	return questdata[bracket] and questdata[bracket][key]
end

-- IMPORTANT: Addon authors that wish to use this API and data should
-- include the wowhead logo in the frame that displays this information.
-- They are kind enough to let me continue parsing their database, and we
-- owe them at least that much.  Thank you.

function LightHeaded:GetNumQuestComments(title, level)
	title = self:TranslateTitle(title)
	local data = self:LoadQuestData(title, level)
	return data and #data - 1 or 0
end

function LightHeaded:GetQuestComment(title, level, idx)
	-- Adjust for offset
	idx = idx + 1
	title = self:TranslateTitle(title)
	local data = self:LoadQuestData(title, level)
	local cinfo = data and data[idx]
	if cinfo then
		local qid,cid,rating,indent,parent,date,poster,comment = cinfo:match("([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)$")
		return qid,cid,rating,indent,parent,date,poster,comment
	end
end

local function iter_comments(tbl, idx)
	idx = idx + 1
	local val = tbl and tbl[idx]
	if val then
		local qid,cid,rating,indent,parent,date,poster,comment = val:match("([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)$")
		return idx,qid,cid,rating,indent,parent,date,poster,comment
	end
end

function LightHeaded:IterateQuestComments(title, level)
	title = self:TranslateTitle(title)
	local data = self:LoadQuestData(title, level)
	return iter_comments, data, 1
end

local qinfopattern = "([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\031]*)\031([^\030]-)\030"
function LightHeaded:GetQuestInfo(title, level)
	title = self:TranslateTitle(title)
	local data = self:LoadQuestData(title, level)
	if not data or not data[1] then
		self:DebugF(1, "Could not find quest information for %s [%s]", title, level)
		return
	end

	local qinfo = data[1]
	local qid,sharable,level,reqlev,stype,sname,sid,etype,ename,eid,exp,rep,series = qinfo:match(qinfopattern)
	return qid,sharable,level,reqlev,stype,sname,sid,etype,ename,eid,exp,rep,series
end

function LightHeaded:IterateQuestInfo(title, level)
	title = self:TranslateTitle(title)
	local data = self:LoadQuestData(title, level)
	local qinfo = data and data[1]
	if not qinfo then
		self:DebugF(1, "Could not find quest information for %s [%s]", title, level)
		return noop
	end

	return qinfo:gmatch(qinfopattern)	
end

function LightHeaded:IterateNPCLocs(id)
	local data = self:LoadNPCData(id)
	if data then
		local iter,inv,state = data:gmatch("(%d+),(%d+),(%d+%.?%d*),(%d+%.?%d*):")
		return function(...)
				   local state,c,z,x,y = iter(...)
				   if c then c = tonumber(c) end
				   if z then z = tonumber(z) end
				   if x then x = tonumber(x) end
				   if y then y = tonumber(y) end
				   return state,c,z,x,y
			   end
	end
	return noop
end

function LightHeaded:SetFrameTooltip(frame, text)
	frame:SetScript("OnEnter", function(frame, ...)
								   GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
								   GameTooltip:SetText(text)
								   GameTooltip:Show()
							   end)
	frame:SetScript("OnLeave", function(frame, ...)
								   GameTooltip:Hide()
							   end)
end

local function linkifyItemURLs(comment,pattern)
	while true do
		local front,back,id = 1
		front,back,id = comment:find(pattern,front)
		if not front then break end
		local link = ("item:%d:0:0:0:0:0:0:0"):format(id)
		local name,_,rarity = GetItemInfo(link)
		local color
		if name then
			color = ITEM_QUALITY_COLORS[rarity].hex
		else
			name = "Item: " .. id
			color = "|cffff1111"
		end
		comment = ("%s%s|Hlhref:%s|h[%s]|h|r%s"):format(comment:sub(1,front-1),color,link,name,comment:sub(back+1))
	end
	return comment
end

function LightHeaded:GetCommentText(title, level, idx)
	local qid,cid,rating,indent,parent,date,poster,comment = self:GetQuestComment(title, level, idx)
	local fmt = "|cffffd100Comments for |r%s\n|cffffd100Posted by |r%s |cffffd100on|r %s|cffffd100:|r\n\n%s"

	-- Href items into clickable links
	comment = linkifyItemURLs(comment,"http://w?w?w?%.?wowhead%.com/%?item=(%d+)")
	comment = linkifyItemURLs(comment,"http://w?w?w?%.?thottbot%.com/i(%d+)")
	comment = linkifyItemURLs(comment,"http://wow%.allakhazam%.com/db/item%.html?witem=(%d+)")
	
	-- Href the coordinates
	comment = comment:gsub("(%d%d?%.?%d?%d?)%s*[, ]%s*(%d%d?%.?%d?%d?)", "|cFF0066FF|Hlhref:coord:%1:%2:"..title .. " ["..level.."]".."|h[%1, %2]|h|r")
	-- Href any quests into clickable links

	if LH_QuestData then
		-- Do gmatch
		for qurl in comment:gmatch("(http://w?w?w?%.?wowhead.com/%?quest=%d+)") do
			local qid = qurl:match("http://w?w?w?%.?wowhead.com/%?quest=(%d+)")

			if not qid then
				self:Debug(1, "BAD QID", qurl)
				error("zomg")
			end

			local title = self:QIDToTitleLevel(qid)
			local link = "|cFF0066FF|Hlhref:quest:"..qid.."|h["..title.."]|h|r"
			comment = comment:gsub("http://w?w?w?%.?wowhead.com/%?quest="..qid, link)
		end
	else
		comment = comment:gsub("http://w?w?w?%.?wowhead.com/%?quest=(%d+)", "|cFF0066FF|Hlhref:quest:%1|h[Quest %1]|h|r")
	end

	-- Href any URLS into clickable links
	comment = comment:gsub("(http://w?w?w?%.?wowhead.com/%?[^=]+=%d+)", "|Hlhref:external:%1|h%1|h")

	return fmt:format(title, poster, date, comment)
end

-- This function is called with a quest title and level
-- In addition, a page can be specified.  If the page is specified
-- then we show that page (where page 1 is the qinfo).  If page
-- is nil, then we will display everything in one single string

function LightHeaded:GetPageText(title, level, page)
	local text = ""

	-- Generate the qinfo page
	if not page or page == 1 then
		for qid,sharable,level,reqlev,stype,sname,sid,etype,ename,eid,exp,rep,series in self:IterateQuestInfo(title, level) do

			if not qid then
				-- There was an error
				self:Print("Unable to parse " .. data[1] .. ", please report this error to cladhaire")
				return
			end

			-- Add a line feed if this is a second entry
			if text ~= "" then
				text = text .. "\n\n"
			end

			-- Title will always exist
			text = text .. "|cffffd100Name:|r " .. title
			-- QID will always exist
			text = text .. "\n|cffffd100Quest ID:|r |Hlhref:external:http://www.wowhead.com/?quest="..qid.."|h" .. qid .. "|h"
			-- Sharable will always exist
			text = text .. "\n|cffffd100Sharable:|r " .. (sharable and "Yes" or "No")
			-- Level will always exist
			text = text .. "\n|cffffd100Level:|r " .. level

			-- All other params are optional
			if reqlev ~= "" then
				text = text .. "\n|cffffd100Required Level:|r " .. reqlev
			end

			if stype ~= "" and sname ~= "" then
				local link
				if stype == "npc" then
					link = "|cFF0066FF|Hlhref:npc:"..sid..":"..sname.."|h["..sname.."]|h|r"
				else
					link = "|cFFFFFFFF"..sname.."|r"
				end

				text = text .. "\n|cffffd100Starts:|r " .. link
			end

			if etype ~= "" and ename ~= "" then
				local link
				if etype == "npc" then
					link = "|cFF0066FF|Hlhref:npc:"..eid..":"..ename.."|h["..ename.."]|h|r"
				else
					link = "|cFFFFFFFF"..ename.."|r"
				end

				text = text .. "\n|cffffd100Ends:|r " .. link
			end

			if exp ~= "" then
				text = text .. "\n|cffffd100Experience:|r " .. exp
			end

			if rep ~= "" then
				text = text .. "\n|cffffd100Reputation Gains:|r"

				for name,value in rep:gmatch("([^\029]+)\029([^\029]+)") do
					text = text .. "\n|cffffd100 - " .. name .. "|r: " .. value
				end
			end

			if series ~= "" then
				text = text .. "\n|cffffd100Quest Series:|r"
		
				for step,id in series:gmatch("([^\029]+)\029([^\029]+)") do
					local name = ""

					if not LH_QuestData then
						name = "Quest " .. id
					else
						id = tonumber(id)
						name = self:QIDToTitleLevel(id)
					end

					local link
					if self:KeyMatchQID(title, level, id) then
						link = name
					else
						link = "|cFF0066FF|Hlhref:quest:"..id.."|h["..name.."]|h|r"
					end

					text = text .. "\n|cffffd100 - "..step..".|r " .. link
				end
			end
		end
	end

	if not page then
		text = text .. "\n\n"
	end

	-- Generate the comments pages
	if page and page > 1 then
		text = text .. self:GetCommentText(title, level, page - 1)
	elseif not page then
		for i=1,self:GetNumQuestComments(title, level) do
			text = text .. self:GetCommentText(title, level, i) .. "\n\n"
		end
	end

	return text
end

function LightHeaded:StripTitle(title)
	if not title then return end

	-- Remove quest levels if they're at the beginning of the quest name
	if title:match("^%[[^%]]+%]") then
		title = title:match("^%[[^%]]+%]%s*(.+)$")
	end
	return title
end

function LightHeaded:GetKey(title, level)
	-- Generate the key we use to identify each quest
	local key = ("%s\031%s"):format(title, level)
	return key
end

-- This function can be called from a few different places
-- 1. In response to a quest being clicked in the quest log
-- 2. In response to a lhref:quest link
-- 3. In response to the "Next" button being pushed
-- 4. In response to the "Prev" button being pushed
-- In response to a lhref:back link
--
-- Each of these should be able to pass in their own page information,
-- or possibly no page information.  This function just calls 
-- GetPageText() and enables/disables the buttons and sets the
-- page text.
-- 
-- Stack is a local table which allows us to store the stack of pages
-- So we can navigate back out.
--
-- Possible values for page:
--   1 - Show the Quest Information Page, and page the results
--  >1 - Show the given Comment Page, paging the results
-- nil - Show all quest information, in a single scrolling frame  

function LightHeaded:UpdateFrame(title, level, page)
	-- If we're not visible, do nothing.
	local lhframe = LightHeadedFrameSub
	if not lhframe:IsVisible() then
		return
	end

	title = self:StripTitle(title)

	-- This is where we store our output as we build it
	local text = ""

	-- Check to see if we have something on the stack
	if #stack > 0 then
		-- Create a backlink to the last quest on the stack
		local link = "|cFF0066FF|Hlhref:back|h[Back]|h|r\n"
		text = text .. link
	end

	text = text .. self:GetPageText(title, level, page)
	lhframe.text:MySetText(text)

	if page then
		local num = self:GetNumQuestComments(title, level)
		if not num then return end

		local max = num + 1
		lhframe.page:SetText(("Page %s of %s"):format(page, max))

		lhframe.page:Show()
		lhframe.prev:Show()
		lhframe.next:Show()
		
		lhframe.prev:Enable()
		lhframe.next:Enable()
	
		if page == 1 then
			lhframe.prev:Disable()
		end

		if page == max then
			lhframe.next:Disable()
		end
	else
		lhframe.page:Hide()
		lhframe.prev:Hide()
		lhframe.next:Hide()
	end


	lhframe.title = title
	lhframe.level = level
	lhframe.current_page = page
	lhframe.scroll:UpdateScrollChildRect()
end

function LightHeaded:OnHyperlinkClick(frame, link)
	local lhframe = LightHeadedFrameSub

	if not link then return end

	if link:match("^lhref:npc") then
		-- Push the current quest onto the stack
		table.insert(stack, lhframe.current_page)
		table.insert(stack, lhframe.level)
		table.insert(stack, lhframe.title)

		local id,name = link:match("^lhref:npc:(.+):(.+)$")
		local text = "|cFF0066FF|Hlhref:back|h[Back]|h|r\n\n"

		id = tonumber(id)

		text = text .. "\nKnown locations for |cFFFFFFFF" .. name .. "|r:\n"
		
		if self:LoadNPCData(id) then
			for c,z,x,y in self:IterateNPCLocs(id) do
				text = text .. "\n|cFF0066FF|Hlhref:zcoord:"..c..":"..z..":"..x..":"..y..":"..name.."|h["..x..", "..y.."]|h|r"
			end
		else
			text = text .. "\nLocation unknown"
		end

		lhframe.text:MySetText(text)
		lhframe.scroll:UpdateScrollChildRect()
		lhframe.next:Disable()
		lhframe.prev:Disable()
	elseif link:match("^lhref:coord") then
		local x,y,note = link:match("^lhref:coord:([^:]+):([^:]+):(.+)")
		x = tonumber(x)
		y = tonumber(y)
		
		if TomTom then
			TomTom:AddWaypoint(x, y, note)
		end

		if  Cartographer_Waypoints and type(Cartographer_Waypoints.AddLHWaypoint) == "function" then
			Cartographer_Waypoints:AddLHWaypoint(nil, nil, x, y, note)
		elseif Cartographer_Waypoints then
			self:Print("LightHeaded waypoints are not supported in this version of Cartographer_Waypoints.")
		end			

		if MN_ThottInterface and type(MN_ThottInterface_Local) == "function" then
			MN_ThottInterface_Local(x, y, note)
		end

	elseif link:match("^lhref:zcoord") then
		local c,z,x,y,note = link:match("^lhref:zcoord:([^:]+):([^:]+):([^:]+):([^:]+):(.+)")
		c = tonumber(c)
		z = tonumber(z)
		x = tonumber(x)
		y = tonumber(y)

		if TomTom and type(TomTom.AddZWaypoint) == "function" then
			TomTom:AddZWaypoint(c, z, x, y, note)
		elseif TomTom then
			self:Print("NPC locations are not supported in this version of TomTom.")
		end

		if  Cartographer_Waypoints and type(Cartographer_Waypoints.AddLHWaypoint) == "function" then
			Cartographer_Waypoints:AddLHWaypoint(c, z, x, y, note)
		elseif Cartographer_Waypoints then
			self:Print("LightHeaded waypoints are not supported in this version of Cartographer_Waypoints.")
		end			

		if MN_ThottInterface and type(MN_ThottInterface_Legacy) == "function" then
			MN_ThottInterface_Legacy(c, z, x, y, note)
		end

	elseif link:match("^lhref:external") then
		local url = link:match("^lhref:external:(.+)$")
		ChatFrameEditBox:Show()
		ChatFrameEditBox:SetText(url)
		ChatFrameEditBox:SetFocus()

	elseif link:match("^lhref:quest:") then
		-- This is only called from within LH, so push the stack
		table.insert(stack, lhframe.current_page)
		table.insert(stack, lhframe.level)
		table.insert(stack, lhframe.title)

		local qid = link:match("^lhref:quest:(.+)$")
		qid = tonumber(qid)
		local key = self:LoadQIDData(qid)
		
		if not key then return end

		--[[
		if not key then
			StaticPopupDialogs["LIGHTHEADED_NO_DATA"].text = StaticPopupDialogs["LIGHTHEADED_NO_DATA"].template .. "(Quest ID: " .. qid .. ")"
			StaticPopup_Show("LIGHTHEADED_NO_DATA")
			return
		end
		--]]
		local title,level = key:match("([^\031]+)\031(.+)")

		if self.db.profile.singlepage then
			self:UpdateFrame(title, level, nil)
		else
			self:UpdateFrame(title, level, 1)
		end
	elseif link:match("^lhref:back$") then
		-- Pop from the stack and display
		local title = table.remove(stack)
		local level = table.remove(stack)
		local page = table.remove(stack)

		self:UpdateFrame(title, level, page)
	elseif link:match("^lhref:item:") then
		link = link:sub(7)
		local name,chatLink = GetItemInfo(link)
		if name then
			if IsControlKeyDown() then
				DressUpItemLink(link)
			elseif IsShiftKeyDown() and ChatFrameEditBox:IsVisible() then
				ChatFrameEditBox:Insert(chatLink)
			else
				SetItemRef(link)
			end
		elseif IsAltKeyDown() then
			local tooltip = lhframe.tooltip
			tooltip.linkForced = link
			tooltip:SetOwner(lhframe.text,"ANCHOR_CURSOR")
			tooltip:SetHyperlink(link)
		end
	else
		self:Print("Unmanaged lhref: " .. link)
	end
end


StaticPopupDialogs["LIGHTHEADED_NO_DATA"] = {
	template = "This quest data could not be found.  Please report this quest number to cladhaire@gmail.com.",
	button1 = TEXT(OKAY),
	OnAccept = function()
			   end,
	timeout = 0,
	hideOnEscape = 1
}

function LightHeaded:OnHyperlinkEnter(frame, link)
	local lhframe = LightHeadedFrameSub

	if not link then return end
	
	if link:match("^lhref:item") then
		link = link:sub(7)
		local tooltip = lhframe.tooltip
		local name = GetItemInfo(link)
		tooltip:SetOwner(frame,"ANCHOR_CURSOR")
		if name then
			tooltip:SetHyperlink(link)
		else
			tooltip:AddLine("WARNING",1,0,0)
			tooltip:AddLine("This item is not cached by your game client. You may request the item from the server by |cffffffffALT-CLICKing|r the item link.  However, if the server hasn't seen this item since the last server restart, you will be disconnected.",1,1,0,1)  
		end
		tooltip:Show()
	end
end

function LightHeaded:CreateGUI()
	if LightHeadedFrame then
		return
	end

	local lhframe = CreateFrame("Frame", "LightHeadedFrame", QuestLogFrame)

	lhframe:SetWidth(640)
	lhframe:SetHeight(512)
	lhframe:SetPoint("LEFT", QuestLogFrame, "RIGHT", 0, 0)

	local topleft = lhframe:CreateTexture(nil, "ARTWORK")
	topleft:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-TopLeft")
	topleft:SetWidth(128)
	topleft:SetHeight(256)
	topleft:SetPoint("TOPLEFT", 0, 0)

	local topright = lhframe:CreateTexture(nil, "ARTWORK")
	topright:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-TopRight")
	topright:SetWidth(140)
	topright:SetHeight(256)
	topright:SetPoint("TOPRIGHT", 0, 0)
	topright:SetTexCoord(0, (140 / 256), 0, 1)

	local top = lhframe:CreateTexture(nil, "ARTWORK")
	top:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-Top")
	top:SetHeight(256)
	top:SetPoint("TOPLEFT", topleft, "TOPRIGHT", 0, 0)
	top:SetPoint("TOPRIGHT", topright, "TOPLEFT", 0, 0)

	local botleft = lhframe:CreateTexture(nil, "ARTWORK")
	botleft:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-BotLeft")
	botleft:SetWidth(128)
	botleft:SetHeight(168)
	botleft:SetPoint("BOTTOMLEFT", 0, 0)
	botleft:SetTexCoord(0, 1, 0, (168 / 256))

	local botright = lhframe:CreateTexture(nil, "ARTWORK")
	botright:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-BotRIght")
	botright:SetWidth(140)
	botright:SetHeight(168)
	botright:SetPoint("BOTTOMRIGHT", 0, 0)
	botright:SetTexCoord(0, (140 / 256), 0, (168 / 256))

	local bot = lhframe:CreateTexture(nil, "ARTWORK")
	bot:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-Bot")
	bot:SetHeight(168)
	bot:SetPoint("TOPLEFT", botleft, "TOPRIGHT", 0, 0)
	bot:SetPoint("TOPRIGHT", botright, "TOPLEFT", 0, 0)
	bot:SetTexCoord(0, 1, 0, (168 / 256))

	local midleft = lhframe:CreateTexture(nil, "ARTWORK")
	midleft:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-TopLeft")
	midleft:SetWidth(128)
	midleft:SetPoint("TOPLEFT", topleft, "BOTTOMLEFT", 0, 0)
	midleft:SetPoint("BOTTOMLEFT", botleft, "TOPLEFT", 0, 0)
	midleft:SetTexCoord(0, 1, (240 / 256), 1)

	local midright = lhframe:CreateTexture(nil, "ARTWORK")
	midright:SetTexture("Interface\\AddOns\\LightHeaded\\images\\MidRight")
	midright:SetWidth(140)
	midright:SetPoint("TOPRIGHT", topright, "BOTTOMRIGHT", 0, 0)
	midright:SetPoint("BOTTOMRIGHT", botright, "TOPRIGHT", 0, 0)
	midright:SetTexCoord(0, (140 / 256), 0, 1)

	local mid = lhframe:CreateTexture(nil, "ARTWORK")
	mid:SetTexture("Interface\\AddOns\\LightHeaded\\images\\Mid")
	mid:SetPoint("TOPLEFT", midleft, "TOPRIGHT", 0, 0)
	mid:SetPoint("BOTTOMRIGHT", midright, "BOTTOMLEFT", 0, 0)
	
	local bg1 = lhframe:CreateTexture(nil, "BACKGROUND")
	bg1:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-TopBackground")
	bg1:SetHeight(64)
	bg1:SetPoint("TOPLEFT", topleft, "TOPLEFT", 5, -4)
	bg1:SetWidth(256)

	local bg2 = lhframe:CreateTexture(nil, "BACKGROUND")
	bg2:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-TopBackground")
	bg2:SetHeight(64)
	bg2:SetPoint("TOPLEFT", bg1, "TOPRIGHT", 0, 0)
	bg2:SetWidth(256)

	local bg3 = lhframe:CreateTexture(nil, "BACKGROUND")
	bg3:SetTexture("Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-TopBackground")
	bg3:SetHeight(64)
	bg3:SetPoint("TOPLEFT", bg2, "TOPRIGHT", 0, 0)
	bg3:SetWidth(256)

	local close = CreateFrame("Button", nil, lhframe, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 5, 4)
	close:SetFrameLevel(1)
	self:SetFrameTooltip(close, "Click to close LightHeaded")

	local resize = CreateFrame("Button", nil, lhframe)
	resize:SetNormalTexture("Interface\\AddOns\\LightHeaded\\images\\Resize")
	resize:GetNormalTexture():SetTexCoord((12 / 32), 1, (12 / 32), 1)
	resize:SetHighlightTexture("Interface\\AddOns\\LightHeaded\\images\\Resize")
	resize:GetHighlightTexture():SetTexCoord((12 / 32), 1, (12 / 32), 1)
	resize:SetHeight(12)
	resize:SetWidth(12)
	resize:SetPoint("BOTTOMRIGHT", -3, 3)
	self:SetFrameTooltip(resize, "Click to resize LightHeaded")

	local titlereg = CreateFrame("Button", nil, lhframe)
	titlereg:SetPoint("TOPLEFT", 5, -5)
	titlereg:SetPoint("TOPRIGHT", 0, 0)
	titlereg:SetHeight(20)
	titlereg:SetScript("OnMouseDown", function(frame)
										  local parent = frame:GetParent()
										  if parent:IsMovable() then
											  parent:StartMoving()
										  end
									  end)
	titlereg:SetScript("OnMouseUp", function(frame)
										local parent = frame:GetParent()
										parent:StopMovingOrSizing()
										self:SavePosition("LightHeadedFrame")
									end)

	lhframe:EnableMouse()
	lhframe:SetMovable(1)
	lhframe:SetResizable(1)
	lhframe:SetMinResize(300, 300)
	lhframe:SetWidth(400)
	lhframe:SetFrameLevel(0)
	lhframe:SetWidth(325)
	lhframe:SetHeight(450)

	lhframe.bg1 = bg1
	lhframe.bg2 = bg2
	lhframe.bg3 = bg3
	lhframe.top = top
	lhframe.bot = bot
	lhframe.topleft = topleft
	lhframe.topright = topright
	lhframe.botleft = botleft
	lhframe.botright = botright
	lhframe.close = close
	lhframe.resize = resize
	lhframe.mid = mid
	lhframe.midleft = midleft
	lhframe.midright = midright
	lhframe.titlereg = titlereg

	local lhframe = LightHeadedFrame

	local cos = math.cos
	local pi = math.pi

	-- internal functions
	local function cosineInterpolation(y1, y2, mu)
		return y1+(y2-y1)*(1 - cos(pi*mu))/2
	end

	local min,max = -360, -50
	local steps = 45
	local timeToFade = 1.5
	local mod = 1/timeToFade
	local modifier = 1/steps
	
	local count = 0
	local totalElapsed = 0
	local function onupdate(self, elapsed)   
		count = count + 1
		totalElapsed = totalElapsed + elapsed
		
		if totalElapsed >= timeToFade then
			local temp = max
			max = min
			min = temp
			count = 0
			totalElapsed = 0
			self:SetScript("OnUpdate", nil)
			
			-- Do the frame fading
			if not LightHeaded.db.profile.open then
				if LightHeadedFrameSub.justclosed == true then
					LightHeadedFrameSub.justclosed = false
					LightHeadedFrameSub:Hide()
				else
					UIFrameFadeIn(LightHeadedFrameSub, 0.25, 0, 1)
					LightHeadedFrameSub:Show()
					LightHeaded.db.profile.open = true
					LightHeaded:QuestLogTitleButton_OnClick()
				end
			end
			return
		elseif count == 1 and LightHeaded.db.profile.open then
			UIFrameFadeOut(LightHeadedFrameSub, 0.25, 1, 0)
			LightHeaded.db.profile.open = false
			LightHeadedFrameSub.justclosed = true
		end
		
		local offset = cosineInterpolation(min, max, mod * totalElapsed)
		self:SetPoint("LEFT", QuestLogFrame, "RIGHT", offset, 19)
	end

	-- Flip min and max, if we're supposed to be open
	if self.db.profile.open then
		min,max = max,min
	end

	if not lhframe.handle then
		lhframe.handle = CreateFrame("Button", nil, lhframe)
	end

	lhframe.handle:SetWidth(8)
	lhframe.handle:SetHeight(128)
	lhframe.handle:SetPoint("LEFT", lhframe, "RIGHT", 0, 0)
	lhframe.handle:SetNormalTexture("Interface\\AddOns\\LightHeaded\\images\\tabhandle")

	lhframe.handle:RegisterForClicks("AnyUp")
	lhframe.handle:SetScript("OnClick", function(self, button)
											lhframe:SetScript("OnUpdate", onupdate)
											if LightHeaded.db.profile.sound then
												PlaySoundFile("Sound\\Doodad\\Karazahn_WoodenDoors_Close_A.wav")
											end

											LightHeaded.db.profile.lhopen = not LightHeaded.db.profile.lhopen
										end)

	lhframe.handle:SetScript("OnEnter", function(self)
											--SetCursor("Interface\\AddOns\\LightHeaded\\images\\cursor")
											SetCursor("INTERACT_CURSOR")
											GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
											GameTooltip:SetText("Click to open/close LightHeaded")
											GameTooltip:Show()
										end)

	lhframe.handle:SetScript("OnLeave",function(self)
										   SetCursor(nil)
										   GameTooltip:Hide()
									   end)

	lhframe.close:SetScript("OnClick", function() lhframe.handle:Click() end)

	local lhframe = CreateFrame("Frame", "LightHeadedFrameSub", LightHeadedFrame)
	lhframe:SetPoint("TOPLEFT", 0, 0)
	lhframe:SetPoint("BOTTOMRIGHT", 0, 0)
	lhframe:SetAlpha(0)

	lhframe.icon = CreateFrame("Button", nil, lhframe)
	lhframe.icon:SetHeight(64)
	lhframe.icon:SetHeight(64)
	lhframe.icon:SetWidth(64)
	lhframe.icon:SetNormalTexture("Interface\\AddOns\\LightHeaded\\images\\wh_icon")
	lhframe.icon:SetHighlightTexture("Interface\\AddOns\\LightHeaded\\images\\wh_icon_hover")
	lhframe.icon:GetHighlightTexture():SetBlendMode("BLEND")
	lhframe.icon:SetPoint("BOTTOMRIGHT", -10, -10)

	StaticPopupDialogs["LIGHTHEADED_ABOUT_DIALOG"] = {
		text = "LightHeaded (C) 2007 by Jim Whitehead\n\nThis add-on only provides you with the comments and some basic information on quests. For the full information, be sure to visit http://www.wowhead.com",
		button1 = TEXT(OKAY),
		OnAccept = function()
				   end,
		timeout = 0,
		hideOnEscape = 1
	}

	lhframe.icon:SetScript("OnClick", function()
										  StaticPopup_Show("LIGHTHEADED_ABOUT_DIALOG")
									  end)

	lhframe.page = lhframe:CreateFontString(nil, "ARTWORK")
	lhframe.page:SetFontObject(GameFontNormalSmall)
	lhframe.page:SetPoint("BOTTOM", -32, 20)

	lhframe.prev = CreateFrame("Button", nil, lhframe)
	lhframe.prev:SetWidth(32)
	lhframe.prev:SetHeight(32)
	lhframe.prev:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	lhframe.prev:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	lhframe.prev:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
	lhframe.prev:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	lhframe.prev:SetPoint("RIGHT", lhframe.page, "LEFT", -25, 0)

	self:SetFrameTooltip(lhframe.prev, "Previous page")
	lhframe.prev:SetScript("OnClick", function(frame)
										  if lhframe.current_page then
											  self:UpdateFrame(lhframe.title, lhframe.level, lhframe.current_page - 1)
										  end
									  end)
										  
	lhframe.next = CreateFrame("Button", nil, lhframe)
	lhframe.next:SetWidth(32)
	lhframe.next:SetHeight(32)
	lhframe.next:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	lhframe.next:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	lhframe.next:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
	lhframe.next:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	lhframe.next:SetPoint("LEFT", lhframe.page, "RIGHT", 25, 0)

	self:SetFrameTooltip(lhframe.next, "Next page")
	lhframe.next:SetScript("OnClick", function(frame)
										  if lhframe.current_page then
											  self:UpdateFrame(lhframe.title, lhframe.level, lhframe.current_page + 1)
										  end
									  end)										  

	lhframe.title = lhframe:CreateFontString(nil, "ARTWORK")
	lhframe.title:SetFontObject(GameFontHighlight)
	lhframe.title:SetPoint("TOP", 0, -4)
	lhframe.title:SetText("LightHeaded v." .. self.rev)

	lhframe.scroll = CreateFrame("ScrollFrame", "LightHeadedScrollFrame", lhframe, "UIPanelScrollFrameTemplate")
	lhframe.scroll:SetPoint("TOPLEFT", 30, -75)
	lhframe.scroll:SetPoint("BOTTOMRIGHT", -35, 55)

	lhframe.scrollchild = CreateFrame("Frame", "LightHeadedScrollFrameChild", lhframe.scroll)
	lhframe.scrollchild:SetWidth(10)
	lhframe.scrollchild:SetHeight(10)

	lhframe.tooltip = CreateFrame("GameTooltip","LightHeadedTooltip",UIParent,"GameTooltipTemplate")
	lhframe.tooltip:SetScript("OnTooltipSetItem",function(frame)
		if frame.linkForced and GetItemInfo(frame.linkForced) then
			frame.linkForced = nil
			self:UpdateFrame()
		end
	end)
	if IDCard and type(IDCard.RegisterTooltip) == "function" then
		IDCard:RegisterTooltip(lhframe.tooltip)
	end
	
	lhframe.text = CreateFrame("SimpleHTML", "LightHeadedHTML", lhframe.scrollchild)
	lhframe.text:SetPoint("TOPLEFT", 0, 0)
	lhframe.text:SetHeight(300)
	lhframe.text:SetFontObject(GameFontHighlight)

	function lhframe.text:MySetText(msg)
		self.text = msg
		self:SetText(msg)
	end

	function lhframe.text:UpdateSize()
		local lhw = LightHeadedFrame:GetWidth()
		local width = lhw - 65
		self:SetWidth(width)
		self:SetText(self.text)
		lhframe.scroll:UpdateScrollChildRect()
	end
	
	lhframe.text:SetScript("OnHyperlinkClick", function(...) self:OnHyperlinkClick(...) end)
	lhframe.text:SetScript("OnHyperlinkEnter", function(...) self:OnHyperlinkEnter(...) end)
	lhframe.text:SetScript("OnHyperlinkLeave", function() lhframe.tooltip:Hide() end)
	
	lhframe.scroll:SetScrollChild(lhframe.scrollchild)
	
--	text = "<HTML><BODY>"
--	text = text .. "<P>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed quis lacus. Mauris fringilla consequat velit. Aenean dolor libero, placerat nec, feugiat sed, tincidunt ac, leo. In hac habitasse platea dictumst. Aliquam non sem adipiscing massa sagittis suscipit. Pellentesque ultrices nisl at ante. Vestibulum dapibus. Nulla facilisi. Nullam lobortis dictum diam. Donec mollis augue ut nulla. Donec ullamcorper mauris sit amet erat. Vivamus ante augue, rutrum sit amet, iaculis sit amet, congue vel, risus. Sed magna. Sed a eros. Aenean sed orci nec sem dapibus fringilla. Donec id diam. Praesent adipiscing. Sed dignissim pellentesque velit. Aenean blandit sapien a ipsum. Quisque tempus commodo erat.</P>"
--	text = text .. "<P>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed quis lacus. Mauris fringilla consequat velit. Aenean dolor libero, placerat nec, feugiat sed, tincidunt ac, leo. In hac habitasse platea dictumst. Aliquam non sem adipiscing massa sagittis suscipit. Pellentesque ultrices nisl at ante. Vestibulum dapibus. Nulla facilisi. Nullam lobortis dictum diam. Donec mollis augue ut nulla. Donec ullamcorper mauris sit amet erat. Vivamus ante augue, rutrum sit amet, iaculis sit amet, congue vel, risus. Sed magna. Sed a eros. Aenean sed orci nec sem dapibus fringilla. Donec id diam. Praesent adipiscing. Sed dignissim pellentesque velit. Aenean blandit sapien a ipsum. Quisque tempus commodo erat.</P>"
--	text = text .. "</BODY></HTML>"

	local text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed quis lacus. Mauris fringilla consequat velit. Aenean dolor libero, placerat nec, feugiat sed, tincidunt ac, leo. In hac habitasse platea dictumst. Aliquam non sem adipiscing massa sagittis suscipit. Pellentesque ultrices nisl at ante. Vestibulum dapibus. Nulla facilisi. Nullam lobortis dictum diam. Donec mollis augue ut nulla. Donec ullamcorper mauris sit amet erat. Vivamus ante augue, rutrum sit amet, iaculis sit amet, congue vel, risus. Sed magna. Sed a eros. Aenean sed orci nec sem dapibus fringilla. Donec id diam. Praesent adipiscing. Sed dignissim pellentesque velit. Aenean blandit sapien a ipsum. Quisque tempus commodo erat."
	text = text .. "\n\nLorem |cffffffffipsum|r dolor |cffff3311sit amet|r, consectetuer adipiscing elit. Sed quis lacus. Mauris fringilla consequat velit. Aenean dolor libero, placerat nec, feugiat sed, tincidunt ac, leo. In hac habitasse platea dictumst. Aliquam non sem adipiscing massa sagittis suscipit. Pellentesque ultrices nisl at ante. Vestibulum dapibus. Nulla facilisi. Nullam lobortis dictum diam. Donec mollis augue ut nulla. Donec ullamcorper mauris sit amet erat. Vivamus ante augue, rutrum sit amet, iaculis sit amet, congue vel, risus. Sed magna. Sed a eros. Aenean sed orci nec sem dapibus fringilla. Donec id diam. Praesent adipiscing. Sed dignissim pellentesque velit. Aenean blandit sapien a ipsum. Quisque tempus commodo erat."

	local function resizebg(frame)
		local width = frame:GetWidth() - 5
		-- bg1 will be okay due to minresize

		-- We'll resize bg2 up to 256
		local bg2w = width - 256
		local bg3w
		if bg2w > 256 then
			bg3w = bg2w - 256
			bg2w = 256
		end

		if bg2w > 0 then
			frame.bg2:SetWidth(bg2w)
			frame.bg2:SetTexCoord(0, (bg2w / 256), 0, 1)
			frame.bg2:Show()
		else
			frame.bg2:Hide()
		end

		
		if bg3w and bg3w > 0 then
			frame.bg3:SetWidth(bg3w)
			frame.bg3:SetTexCoord(0, (bg3w / 256), 0, 1)
			frame.bg3:Show()
		else
			frame.bg3:Hide()
		end
	end

	LightHeadedFrame.resizebg = resizebg

	resize:SetScript("OnMouseDown", function(frame)
										LightHeadedFrame:StartSizing()
										LightHeadedFrame:SetScript("OnUpdate", resizebg)
									end)
	resize:SetScript("OnMouseUp", function(frame)
									  LightHeadedFrame:StopMovingOrSizing()
									  LightHeadedFrame:SetScript("OnUpdate", nil)
									  self:SavePosition("LightHeadedFrame")
									  lhframe.text:UpdateSize()
									  lhframe.scroll:UpdateScrollChildRect()
									  LightHeadedFrame.resizebg(LightHeadedFrame)
								  end)

	lhframe.text:MySetText(text)
	lhframe:SetScript("OnShow", function(frame) frame:SetScript("OnShow", nil); self:QuestLogTitleButton_OnClick() end)

	resizebg(LightHeadedFrame)

	lhframe:SetAlpha(1)
	lhframe:Show()

	self:LockUnlockFrame()
end

function LightHeaded:LockUnlockFrame()
	local lhframe = LightHeadedFrameSub

	LightHeadedFrame:ClearAllPoints()

	if self.db.profile.attached then
		-- Lock the frame
		LightHeadedFrame.titlereg:Hide()
		LightHeadedFrame.resize:Hide()
		LightHeadedFrame.handle:Show()
		LightHeadedFrame:SetWidth(325)
		LightHeadedFrame:SetHeight(450)
		LightHeadedFrame.resizebg(LightHeadedFrame)
		LightHeadedFrame:SetFrameStrata("MEDIUM")
		LightHeadedFrame.close:Show()
		LightHeadedFrame:SetParent(QuestLogFrame)

		lhframe.text:UpdateSize()

		if self.db.profile.open then
			LightHeadedFrame:SetPoint("LEFT", QuestLogFrame, "RIGHT", -50, 19)
			lhframe:Show()
			lhframe:SetAlpha(1)
			lhframe.open = true
		else
			LightHeadedFrame:SetPoint("LEFT", QuestLogFrame, "RIGHT", -360, 19)
			lhframe:Hide()
			lhframe:SetAlpha(0)
		end
	else
		-- Unlock the frame
		LightHeadedFrame.titlereg:Show()
		LightHeadedFrame.resize:Show()
		LightHeadedFrame.handle:Hide()
		LightHeadedFrame:SetFrameStrata("HIGH")
		LightHeadedFrame.close:Hide()

		-- Make sure we can see the frame
		lhframe:Show()
		lhframe:SetAlpha(1)

		-- Update the size of the scroll child
		lhframe.text:UpdateSize()

		-- Restore the position
		self:RestorePosition("LightHeadedFrame")
	end
end

function LightHeaded:SavePosition(name)
    local f = getglobal(name)
    local x,y = f:GetLeft(), f:GetTop()
    local s = f:GetEffectiveScale()
    
    x,y = x*s,y*s
    
	local opt = self.db.profile.positions[name]
	if not opt then 
		self.db.profile.positions[name] = {}
		opt = self.db.profile.positions[name]
	end
    opt.PosX = x
    opt.PosY = y
	opt.Width = f:GetWidth()
	opt.Height = f:GetHeight()
end

function LightHeaded:RestorePosition(name)
	local f = getglobal(name)
	local opt = self.db.profile.positions[name]
	if not opt then 
		self.db.profile.positions[name] = {}
		opt = self.db.profile.positions[name]
	end

	local x = opt.PosX
	local y = opt.PosY

    local s = f:GetEffectiveScale()
        
    if not x or not y then
        f:ClearAllPoints()
        f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        return 
    end

    x,y = x/s,y/s

    f:ClearAllPoints()
	f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)

	-- restore height/width if stored
	if opt.Width then
		f:SetWidth(opt.Width)
	end

	if opt.Height then
		f:SetHeight(opt.Height)
	end

	-- Resize the background
	f.resizebg(f)
end

function LightHeaded:ToggleSound()
	if self.db.profile.sound then
		self:Print("Sound toggled off")
	else
		self:Print("Sound toggled on")
	end

	self.db.profile.sound = not self.db.profile.sound 
end

function LightHeaded:AttachFrame()
	self:Print("Re-Attaching the LightHeaded Frame")

	self.db.profile.attached = true
	self:LockUnlockFrame()
end

function LightHeaded:DetachFrame()
	self:Print("Detaching the LightHeaded Frame")

	self.db.profile.attached = false
	self:LockUnlockFrame()
end

function LightHeaded:TogglePages()
	local lhframe = LightHeadedFrameSub

	if self.db.profile.singlepage then
		self:Print("Showing quest information in multiple pages")
	else
		self:Print("Showing quest information in a single page")
	end

	self.db.profile.singlepage = not self.db.profile.singlepage

	if self.db.profile.singlepage then
		self:UpdateFrame(lhframe.title, lhframe.level, nil)
	else
		self:QuestLogTitleButton_OnClick()
	end
end

function LightHeaded:ChangeBGAlpha(value)
	value = tonumber(value)

	self.db.profile.bgalpha = value

	local lhframe = LightHeadedFrame
	local textures = {
		"topleft",
		"top",
		"topright",
		"midleft",
		"mid",
		"midright",
		"botleft",
		"bot",
		"botright",
		"bg1",
		"bg2",
		"bg3",
		"resize",
		"titlereg",
		"handle",
		"close",
	}

	for k,v in pairs(textures) do
		lhframe[v]:SetAlpha(value)
	end
end

function LightHeaded:ToggleDebug()
	local level
	if self.db.profile.debug then
		self:Print("Debug messages have been disabled.")
	else
		self:Print("Debug messages have been enabled.")
		level = 1		
	end

	self.db.profile.debug = not self.db.profile.debug 
	self:EnableDebug(level)
end
		
LightHeaded = DongleStub("Dongle-1.1"):New("LightHeaded", LightHeaded)
