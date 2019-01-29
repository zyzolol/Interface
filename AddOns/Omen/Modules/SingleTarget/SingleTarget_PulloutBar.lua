local MINOR_VERSION = tonumber(("$Revision: 78999 $"):match("%d+"))
if MINOR_VERSION > Omen.MINOR_VERSION then Omen.MINOR_VERSION = MINOR_VERSION end

local Threat = LibStub("Threat-2.0")
local SingleTarget = Omen:GetModule("SingleTarget")
local Media = LibStub("LibSharedMedia-3.0")
local UnitGUID = _G.UnitGUID

local pullout_cls = setmetatable({}, {__index=Omen.PulloutBase})
local pullout_mt = {__index=pullout_cls}
local playerGUID

local pullouts = {}

function pullout_cls:New(guid)
	playerGUID = UnitGUID("player")
	local pullout = setmetatable({guid=guid}, pullout_mt)
	pullout:MakeFrame()
	Threat.RegisterCallback(pullout, "ThreatUpdated")
	pullout.frame:RegisterEvent("PLAYER_TARGET", function(self) self.parent:UpdateLayout() end)
	Omen:_SetFrameBackdrop(pullout.frame, "SingleTargetPullout")
	pullout.ownBar = pullout:NewBar()
	pullout.ownBar.texture:SetVertexColor(1,0,0)
	pullout.ownBar.frame:SetFrameLevel(10)
	pullout.marker100 = pullout:NewTexture(pullout.frame)
	pullout.marker100:SetTexture("Interface\\AddOns\\Omen\\Media\\Textures\\PulloutMarker.tga")
	pullout.marker100:SetVertexColor(1,0.8,0,0.8)

	pullout.raidTextures = {}

	pullout:UpdateLayout()
	return pullout
end

function pullout_cls:ThreatUpdated(event, srcGUID, dstGUID, threat)
	if dstGUID == UnitGUID("target") then
		self:UpdateLayout()
	end
end


local lastUpdate = 0
function pullout_cls:UpdateLayout()
	local now = GetTime()
	if now < lastUpdate + 0.5 then
		return
	end
	self:UpdateBars()
	local targetGUID = UnitGUID("target")
	if targetGUID then
		self.frame:Show()
	else
		self.frame:Hide()
	end
	local tankThreat
	if self.guid == "AGGRO" then
		local tankGUID = UnitGUID("targettarget")
		if tankGUID then
			tankThreat = Threat:GetThreat(tankGUID, targetGUID)
		else
			tankThreat = Threat:GetMaxThreatOnTarget(targetGUID)
		end
	else
		tankThreat = Threat:GetThreat(self.guid, targetGUID)
	end
	local ownThreat = Threat:GetThreat(playerGUID, targetGUID)
	local scale
	if Threat:UnitInMeleeRange("target") then
		scale = 1/1.1
	else
		scale = 1/1.3
	end
	self.marker100:ClearAllPoints()
	local x = self:GetBarWidth() * scale + 4
	self.marker100:SetPoint("CENTER", self.frame, "LEFT", x, 0)
	self.marker100:SetHeight(self.frame:GetHeight())
	self.marker100:SetWidth(8)
	if tankThreat > 0 then
		local threatRatio = ownThreat/tankThreat
		local r, g, b = 0,0,0
		if threatRatio < 1 then
			g = 1
		elseif threatRatio < scale then
			r = 1
			g = 0.7
		else
			r = 1
		end
		self.ownBar:SetPoints(scale*threatRatio, 1,1,1,1)
		self.ownBar.texture:SetVertexColor(r,g,b,1)
	else
		self.ownBar:SetPoints(scale, 1,1,1,1)
		self.ownBar.texture:SetVertexColor(0,0,1,0.5)
	end
	lastUpdate = now
end

function pullout_cls:OpenMenu()
	local menu = {
		{
			text = "Remove",
			func = function(self)
				       Threat.UnregisterCallback(self, "ThreatUpdated")
				       self:Release()
			       end,
			arg1 = self
		},
	}
	
	if not Omen.EasyMenuFrame then
		Omen.EasyMenuFrame = CreateFrame("Frame", "OmenEasyMenuFrame", nil, "UIDropDownMenuTemplate")
	end
	EasyMenu(menu, Omen.EasyMenuFrame, "cursor", nil, nil, "MENU")
end

function SingleTarget:MakePullout(guid)
	local pullout = pullout_cls:New(guid)
	tinsert(pullouts, pullout)
end

function SingleTarget:MakeBarMenu(bar)
	return {
		{
			text = "Create Pullout",
			func = function(guid)
				       Omen.activeModule:MakePullout(guid)
			       end,
			arg1 = bar.guid,
		},
	}
end


SingleTarget.Pullout = pullout_cls
