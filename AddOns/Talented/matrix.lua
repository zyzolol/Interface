local Talented = Talented
local ipairs = ipairs

local wotlk = select(4, GetBuildInfo()) >= 3e4

local LAYOUT_BASE_X = 4
local LAYOUT_BASE_Y = 24
-- local LAYOUT_MAX_COLUMNS = 4
-- local LAYOUT_MAX_ROWS = 9

local LAYOUT_OFFSET_X, LAYOUT_OFFSET_Y, LAYOUT_DELTA_X, LAYOUT_DELTA_Y
local LAYOUT_SIZE_X, LAYOUT_SIZE_Y

local function RecalcLayout(offset)
	if LAYOUT_OFFSET_X ~= offset then
		
		LAYOUT_OFFSET_X = offset
		LAYOUT_OFFSET_Y = LAYOUT_OFFSET_X
		
		LAYOUT_DELTA_X = LAYOUT_OFFSET_X / 2
		LAYOUT_DELTA_Y = LAYOUT_OFFSET_Y / 2

		LAYOUT_SIZE_X = --[[LAYOUT_MAX_COLUMNS]] 4 * LAYOUT_OFFSET_X + LAYOUT_DELTA_X
		if wotlk then
			LAYOUT_SIZE_Y = --[[LAYOUT_MAX_ROWS]] 11 * LAYOUT_OFFSET_Y + LAYOUT_DELTA_Y
		else
			LAYOUT_SIZE_Y = --[[LAYOUT_MAX_ROWS]] 9 * LAYOUT_OFFSET_Y + LAYOUT_DELTA_Y
		end
		
		return true
	end
end

local function offset(row, column)
	return (column - 1) * LAYOUT_OFFSET_X + LAYOUT_DELTA_X, - ((row - 1) * LAYOUT_OFFSET_Y + LAYOUT_DELTA_Y)
end

local function UIReset()
	local viewclass = Talented.viewclass
	Talented.viewclass = nil

	if viewclass then
		local info = Talented:GetTalentInfo(viewclass)
		if not info then return end
		for tab, tree in ipairs(info) do
			tree.frame = nil
			for idx, talent in ipairs(tree.talents) do
				local prereqs = talent.info.prereqs
				if prereqs then
					for _, req in ipairs(prereqs) do
						req.elements = nil
					end
				end
				talent.button = nil
			end
		end
		Talented.Pool:ResetAll()
	end
end

function Talented:CreateTalentMatrix(class, force)
	if not force and class ~= nil and self.viewclass == class then return true end
	local talents = self:GetTalentInfo(class)
	
	if not talents then return end
	
	local parent = self.base
	
	UIReset()
	
	if not LAYOUT_OFFSET_X then
		RecalcLayout(self.db.profile.offset)
	end

	for tab, tree in ipairs(talents) do
		local frame = self:MakeTalentFrame(parent, LAYOUT_SIZE_X, LAYOUT_SIZE_Y)
		frame.tab = tab
		
		local background = "Interface\\TalentFrame\\"..tree.info.background.."-"
		frame.topleft:SetTexture(background.."TopLeft")
		frame.topright:SetTexture(background.."TopRight")
		frame.bottomleft:SetTexture(background.."BottomLeft")
		frame.bottomright:SetTexture(background.."BottomRight")
		
		if frame.icon then
			frame.icon:SetTexture(tree.info.icon)
		end

		tree.frame = frame
		
		for idx, talent in ipairs(tree.talents) do
			local button = self:MakeButton(frame)
			button.tab = tab
			button.id = idx
			
			talent.button = button
			
			button:SetPoint("TOPLEFT", offset(talent.info.row, talent.info.column))
			button.texture:SetTexture(talent.info.icon)
			if talent.info.exceptional then
				button.slot:SetVertexColor(1, 1, 0)
			else
				button.slot:SetVertexColor(0, 1, 0)
			end
			button:Show()
		end
		
		for idx, talent in ipairs(tree.talents) do
			local prereqs = talent.info.prereqs
			if prereqs then
				for _, req in ipairs(prereqs) do
					req.elements = {}
					self.DrawLine(req.elements, frame, offset, talent.info.row, talent.info.column, req.row, req.column)
				end
			end
		end
		
		frame:SetPoint("TOPLEFT", (tab-1) * LAYOUT_SIZE_X + LAYOUT_BASE_X, -LAYOUT_BASE_Y)
	end
	parent:SetWidth(#talents * LAYOUT_SIZE_X + LAYOUT_BASE_X * 2)
	parent:SetHeight(LAYOUT_SIZE_Y + LAYOUT_BASE_Y + LAYOUT_BASE_X)
	parent:SetPoint(self.db.profile.point, UIParent, self.db.profile.point, self.db.profile.offsetx, self.db.profile.offsety)
	
	parent:SetScale(self.db.profile.scale)

	self.viewclass = class
	return true
end

function Talented:SaveFramePosition()
	local p, _ = self.db.profile
	p.point, _, _, p.offsetx, p.offsety = self.base:GetPoint()
	self.base:SetPoint(p.point, UIParent, p.point, p.offsetx, p.offsety)
end

function Talented:ReLayout()
	if RecalcLayout(self.db.profile.offset) then
		self:CreateTalentMatrix(self.viewclass, true)
	end
	self.base:SetScale(self.db.profile.scale)
end


