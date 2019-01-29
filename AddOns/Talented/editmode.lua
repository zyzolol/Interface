local Talented = Talented
local ipairs = ipairs

local wotlk = select(4, GetBuildInfo()) >= 3e4

local MAX_TALENT_POINTS = wotlk and 71 or 61

function Talented:IsTemplateAtCap(template)
	return self.db.profile.level_cap and self:GetPointCount(template) >= MAX_TALENT_POINTS
end

function Talented:GetPointCount(template)
	local total = 0
	local info = self:GetTalentInfo(template.class)
	if not info then return 0 end
	for tab in ipairs(info) do
		total = total + self:GetTalentTabCount(template, tab)
	end
	return total
end

function Talented:GetTalentTabCount(template, tab)
	local total = 0
	for _, value in ipairs(template[tab]) do
		total = total + value
	end
	return total
end

function Talented:ClearTalentTab(tab)
	local template = self.template
	if template and template ~= self.current and self.mode == "edit" then
		local tab = template[tab]
		for index, value in ipairs(tab) do
			tab[index] = 0
		end
	end
	self:UpdateView()
end

function Talented:GetTalentState(template, tab, index)
	local s
	local info = self:GetTalentInfo(template.class)
	if not info then return end
	info = info[tab].talents[index].info
	local tier = (info.row - 1) * 5
	local count = self:GetTalentTabCount(template, tab)
	local reqs = info.reqs
	
	if count < tier then
		s = false
	else
		s = true
		if reqs then
			for _, req in ipairs(reqs) do
				if self:GetTalentState(template, tab, req.source.index) ~= "full" then
					s = false
					break
				end
			end
		end
	end
	
	if not s then
		s = "unavailable"
	else
		local value = template[tab][index]
		if value == info.ranks then
			s = "full"
		elseif value == 0 then
			s = "empty"
		else
			s = "available"
		end
	end
	return s
end

function Talented:UpdateTalent(tab, index, offset)
	if self.mode ~= "edit" then return end
	if self.template == self.current then
		-- Applying talent
		if offset > 0 then
			self:LearnTalent(tab, index)
		end
		return
	end
	local template = self.template
	
	if offset > 0 and self:IsTemplateAtCap(template) then return end
	local s = self:GetTalentState(template, tab, index)
	
	local info = self:GetTalentInfo(template.class)
	if not info then return end
	local talent = info[tab].talents[index]
	local ranks = talent.info.ranks
	local original = template[tab][index]
	local value = original + offset
	if value < 0 or s == "unavailable" then
		value = 0
	elseif value > ranks then
		value = ranks
	end
	self:Debug("Updating %d-%d : %d -> %d (%d)", tab, index, original, value, offset)
	if value == original or not self:ValidateTalentBranch(template, tab, index, value) then 
		return 
	end
	template[tab][index] = value
	self:UpdateView()
	self:UpdateTooltip()
	return true
end

function Talented:OnTalentClick(button, tab, index)
	if IsModifiedClick("CHATLINK") then
		local link = self:GetTalentLink(self.template, tab, index)
		if link then
			ChatEdit_InsertLink(link)
		end
	else
		self:UpdateTalent(tab, index, button == "LeftButton" and 1 or -1)
	end
end

function Talented:ValidateTalentBranch(template, tab, index, newvalue)
	local count = 0
	local info = self:GetTalentInfo(template.class)
	if not info then return end
	local tree = info[tab]
	local template = template[tab]
	for i, talent in ipairs(tree.talents) do
		local tier = (talent.info.row - 1) * 5
		local value = i == index and newvalue or template[i]
		if count < tier and value > 0 then
			self:Debug("Update refused because of tier")
			return false
		end
		if value > 0 and talent.info.prereqs then
			for _, req in ipairs(talent.info.prereqs) do
				local i = req.source
				local value = i == index and newvalue or template[i]
				if value < tree.talents[i].info.ranks then
					self:Debug("Update refused because of prereq")
					return false
				end
			end
		end
		count = count + value
	end
	return true
end

function Talented:ValidateTemplate(template)
	local class = template.class
	if not class then return end
	local info = self:GetTalentInfo(class)
	if not info then return end
	for tab in ipairs(info) do
		if not template[tab] or not self:ValidateTalentBranch(template, tab) then
			return
		end
	end
	return true
end
