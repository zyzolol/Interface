local select = select
local ipairs = ipairs
local GetTalentInfo = GetTalentInfo
local GRAY_FONT_COLOR = GRAY_FONT_COLOR
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
local GREEN_FONT_COLOR = GREEN_FONT_COLOR
local RED_FONT_COLOR = RED_FONT_COLOR
local LIGHTBLUE_FONT_COLOR = { r = 0.5, g = 0.6, b = 1 }
local GRAY_FONT_COLOR = GRAY_FONT_COLOR
local Talented = Talented

local L = AceLibrary("AceLocale-2.2"):new("Talented")

function Talented:UpdateCurrentTemplate()
	local info
	local template = self.current
	if not template then
		local class = select(2, UnitClass("player"))
		template = {
			name = "Current",
			class = class,
		}
		info = self:GetTalentInfo(class)
		if not info then
			error(("Unable to get talent for class %s, %s"):format(class, "player"))
		end
		for tab, tree in ipairs(info) do
			template[tab] = { talents = {} }
		end
		self.current = template
	else
		info = self:GetTalentInfo(template.class)
	end
	local total = 0 
	for tab, tree in ipairs(info) do
		for index, info in ipairs(tree.talents) do
			local rank = select(5, GetTalentInfo(tab, index))
			template[tab][index] = rank
			total = total + rank
		end
	end
	self.maxpoints = total + UnitCharacterPoints("player") 
	if self.template == self.current then
		self:UpdateTooltip()
	end
end

function Talented:UpdateView()
	if not self.base then return end
	local template, target
	if self.mode == "apply" then
		template = self.current
	else
		template = self.template
	end
	self:UnpackTemplate(template)
	local total = 0
		
	if template ~= self.current then
		self.base.editname:SetText(template.name)
	else
		self:MakeTarget()
		target = self.db.char.target and self.target
	end
	if target then
		self.base.targetname:Show()
		self.base.targetname:SetFormattedText(L["Target: %s"], self.db.char.target)
	else
		self.base.targetname:Hide()
	end
	local info = self:GetTalentInfo(template.class)
	if not info then return end
	local at_cap = self:IsTemplateAtCap(template)
	for tab, tree in ipairs(info) do
		local count = 0
		for index, talent in ipairs(tree.talents) do
			local rank = template[tab][index]
			if not rank then
				template[tab][index] = 0
				rank = 0
			end
			count = count + rank
			local button = talent.button
			local color = GRAY_FONT_COLOR
			local state = self:GetTalentState(template, tab, index)
			if state == "empty" and (at_cap or self.mode == "view") then
				state = "unavailable"
			end
			if state == "unavailable" then
				button.texture:SetDesaturated(1)
				button.slot:SetVertexColor(0.65, 0.65, 0.65)
				button.rank:Hide()
				button.rank.texture:Hide()
			else
				button.rank:Show()
				button.rank.texture:Show()
				button.rank:SetText(rank)
				button.texture:SetDesaturated(0)
				if state == "full" then
					color = NORMAL_FONT_COLOR
				else
					color = GREEN_FONT_COLOR
				end
				button.slot:SetVertexColor(color.r, color.g, color.b)
				button.rank:SetVertexColor(color.r, color.g, color.b)
			end
			if talent.info.prereqs then
				for _, req in ipairs(talent.info.prereqs) do
					local ecolor = color
					if ecolor == GREEN_FONT_COLOR then
						if self.mode == "edit" then
							local s = self:GetTalentState(template, tab, req.source)
							if s ~= "full" then
								ecolor = RED_FONT_COLOR
							end
						else
							ecolor = NORMAL_FONT_COLOR
						end
					end
					for _, element in ipairs(req.elements) do
						element:SetVertexColor(ecolor.r, ecolor.g, ecolor.b)
					end
				end
			end
			local targetvalue = target and target[tab][index]
			if targetvalue and (targetvalue > 0 or rank > 0) then
				local btarget = self:GetButtonTarget(button)
				btarget:Show()
				btarget.texture:Show()
				btarget:SetText(targetvalue)
				local tcolor
				if rank < targetvalue then
					tcolor = LIGHTBLUE_FONT_COLOR
				elseif rank == targetvalue then
					tcolor = GRAY_FONT_COLOR
				else
					tcolor = RED_FONT_COLOR
				end
				btarget:SetVertexColor(tcolor.r, tcolor.g, tcolor.b)
			elseif button.target then
				button.target:Hide()
				button.target.texture:Hide()
			end
		end
		tree.frame.name:SetFormattedText(L["%s (%d)"], tree.info.name, count)
		total = total + count
		local clear = tree.frame.clear
		if self.mode ~= "edit" or count <= 0 or self.template == self.current then
			clear:Hide()
		else
			clear:Show()
		end
	end
	local points = self.base.points
	local maxpoints = self.maxpoints
	if self.db.profile.show_level_req then
		local level_req = (total == 0) and 1  or (9 + total)
		points:SetFormattedText(L["Level %d"], level_req)
	else
		points:SetFormattedText(L["%d/%d"], total, maxpoints)
	end
	local color
	if total < maxpoints then
		color = GREEN_FONT_COLOR
	elseif total > maxpoints then
		color = RED_FONT_COLOR
	else
		color = NORMAL_FONT_COLOR
	end
	points:SetTextColor(color.r, color.g, color.b)
	if maxpoints ~= total and template == self.current then
		self.base.pointsleft:Show()
		self.base.pointsleft.text:SetFormattedText(L["You have %d talent points left"], maxpoints - total)
	else
		self.base.pointsleft:Hide()
	end
end
