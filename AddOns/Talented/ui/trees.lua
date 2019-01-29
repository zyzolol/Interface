local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local Talented = Talented

local L = AceLibrary("AceLocale-2.2"):new("Talented")

local function CreateTexture(base, layer, path, blend)
	local t = base:CreateTexture(nil, layer)
	if path then t:SetTexture(path) end
	if blend then t:SetBlendMode(blend)	end
	return t
end

local trees = Talented.Pool:new()

local function setsize(frame, width, height)
	frame:SetWidth(width)
	frame:SetHeight(height)
end

local function Layout(frame, width, height)
	local texture_height = height / (256+75)
	local texture_width = width / (256+44)
	
	setsize(frame, width, height)
	
	local wl, wr, ht, hb =
		texture_width * 256, texture_width * 64,
		texture_height * 256, texture_height * 128

	setsize(frame.topleft, wl, ht)
	setsize(frame.topright, wr, ht)
	setsize(frame.bottomleft, wl, hb)
	setsize(frame.bottomright, wr, hb)

	frame.name:SetWidth(width)
end

local function ClearBranchButton_OnClick (self)
	Talented:ClearTalentTab(self:GetParent().tab)
end

local function NewTalentFrame(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint("TOPLEFT")
	
	local t = CreateTexture(frame, "BACKGROUND")
	t:SetPoint("TOPLEFT")
	frame.topleft = t
	
	t = CreateTexture(frame, "BACKGROUND")
	t:SetPoint("TOPLEFT", frame.topleft, "TOPRIGHT")
	frame.topright = t
	
	t = CreateTexture(frame, "BACKGROUND")
	t:SetPoint("TOPLEFT", frame.topleft, "BOTTOMLEFT")
	frame.bottomleft = t
	
	t = CreateTexture(frame, "BACKGROUND")
	t:SetPoint("TOPLEFT", frame.topleft, "BOTTOMRIGHT")
	frame.bottomright = t
	
	local fs = frame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	fs:SetPoint("TOP", 0, -4)
	fs:SetJustifyH("CENTER")
	frame.name = fs
	
	local overlay = CreateFrame("Frame", nil, frame)
	overlay:SetAllPoints(frame)
	
	frame.overlay = overlay

	local clear = CreateFrame("Button", nil, frame)
	frame.clear = clear
	
	local makeTexture = function (path, blend)
		local t = CreateTexture(clear, nil, path, blend)
		t:SetAllPoints(clear)
		return t
	end

	clear:SetNormalTexture(makeTexture("Interface\\Buttons\\CancelButton-Up"))
	clear:SetPushedTexture(makeTexture("Interface\\Buttons\\CancelButton-Down"))
	clear:SetHighlightTexture(makeTexture("Interface\\Buttons\\CancelButton-Highlight", "ADD"))
	
	clear:SetScript("OnClick", ClearBranchButton_OnClick)
	clear:SetScript("OnEnter", parent.editname:GetScript("OnEnter"))
	clear:SetScript("OnLeave", parent.editname:GetScript("OnLeave"))
	clear.tooltip = L["Remove all talent points from this tree."]
	clear:SetWidth(32)
	clear:SetHeight(32)
	clear:ClearAllPoints()
	clear:SetPoint("TOPRIGHT", -4, -4)
	
	trees:push(frame)
	
	return frame
end

function Talented:MakeTalentFrame(parent, width, height)
	local tree = trees:next()
	if tree then
		tree:SetParent(parent)
	else
		tree = NewTalentFrame(parent)
	end
	Layout(tree, width, height)
	return tree
end
