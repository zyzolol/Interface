local type = type
local ipairs = ipairs
local Talented = Talented
local GameTooltip = GameTooltip
local IsAltKeyDown = IsAltKeyDown
local TOOLTIP_TALENT_RANK = TOOLTIP_TALENT_RANK
local TOOLTIP_TALENT_TIER_POINTS = TOOLTIP_TALENT_TIER_POINTS
local TOOLTIP_TALENT_PREREQ = TOOLTIP_TALENT_PREREQ
local TOOLTIP_TALENT_NEXT_RANK = TOOLTIP_TALENT_NEXT_RANK
local GREEN_FONT_COLOR = GREEN_FONT_COLOR
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
local RED_FONT_COLOR = RED_FONT_COLOR
local TOOLTIP_TALENT_LEARN = TOOLTIP_TALENT_LEARN

local L = AceLibrary("AceLocale-2.2"):new("Talented")

local function addline(line, color, split)
	GameTooltip:AddLine(line, color.r, color.g, color.b, split)
end

local function add2line(left, right)
	GameTooltip:AddDoubleLine(left, right, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
end

local function gettipline(tips, value)
	local fmt = tips.format
	if fmt then
		local v = tips[value] or (tips.multiplier or 1) * value
		if type(v) == "table" then
			return fmt:format(unpack(v))
		else
			return fmt:format(v)
		end
	end
	return tips[value]
end

local function addtipline(tip, color)
	color = color or NORMAL_FONT_COLOR
	tip = tip or ""
	if type(tip) == "string" then
		addline(tip, color, true)
	else
		for _, i in ipairs(tip) do
			if i.right then
				GameTooltip:AddDoubleLine(i.left, i.right, color.r, color.g, color.b, color.r, color.g, color.b)
			else
				addline(i.left, color, true)
			end
		end
	end
end

local lastTooltipFrame
function Talented:SetTooltipInfo(frame, tab, index)
	if not tab or not index then return end
	if not GameTooltip:IsOwned(frame) then
		GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	end

	local tree = self.talents[self.viewclass][tab]
	local info = tree.talents[index].info
	local tiptype = type(info.tips)
	GameTooltip:ClearLines()
	if tiptype ~= "table" and self.template == self.current then
		GameTooltip:SetTalent(tab, index)
		addline(L["Effective tooltip information not available"], RED_FONT_COLOR)
		return
	end
	local tier = (info.row - 1) * 5
	self:UnpackTemplate(self.template)
	local value = self.template[tab][index]
	addline(info.name, HIGHLIGHT_FONT_COLOR)
	addline(TOOLTIP_TALENT_RANK:format(value, info.ranks), HIGHLIGHT_FONT_COLOR)
	if info.prereqs then
		for _, req in ipairs(info.prereqs) do
			local o = tree.talents[req.source].info
			if self.template[tab][req.source] < o.ranks then
				addline(TOOLTIP_TALENT_PREREQ:format(o.ranks, o.name), RED_FONT_COLOR)
			end
		end
	end
	if tier >= 1 and self:GetTalentTabCount(self.template, tab) < tier then
		addline(TOOLTIP_TALENT_TIER_POINTS:format(tier, tree.info.name), RED_FONT_COLOR)
	end
	if tiptype == "table" then
		if IsAltKeyDown() then
			for i = 1, info.ranks do
				addtipline(gettipline(info.tips, i), i == value and HIGHLIGHT_FONT_COLOR or NORMAL_FONT_COLOR)
			end
		else
			if value > 0 then
				addtipline(gettipline(info.tips, value))
			end
			if value < info.ranks then
				addline(TOOLTIP_TALENT_NEXT_RANK, HIGHLIGHT_FONT_COLOR)
				addtipline(gettipline(info.tips, value + 1))
			end
		end
	else
		if tiptype == "string" then
			addtipline(info.tips)
		end
		addline(L["Effective tooltip information not available"], RED_FONT_COLOR)
	end
	local s = self:GetTalentState(self.template, tab, index)
	if self.mode == "edit" then
		if self.template == self.current then
			if s == "available" or s == "empty" then
				addline(TOOLTIP_TALENT_LEARN, GREEN_FONT_COLOR)
			end
		elseif s == "full" then
			addline(L["Right-click to unlearn"], GREEN_FONT_COLOR)
		elseif s == "available" then
			add2line(TOOLTIP_TALENT_LEARN, L["Right-click to unlearn"])
		elseif s == "empty" then
			addline(TOOLTIP_TALENT_LEARN, GREEN_FONT_COLOR)
		end
	end
	GameTooltip:Show()
	lastTooltipFrame = frame
end

function Talented:HideTooltipInfo()
	GameTooltip:Hide()
	lastTooltipFrame = nil
end

function Talented:UpdateTooltip()
	if lastTooltipFrame and GameTooltip:IsShown() and  GameTooltip:IsOwned(lastTooltipFrame) then
		self:SetTooltipInfo(lastTooltipFrame, lastTooltipFrame.tab, lastTooltipFrame.id)
	end
end

function Talented:MODIFIER_STATE_CHANGED(mod)
	if mod:sub(-3) == "ALT" then
		self:UpdateTooltip()
	end
end
