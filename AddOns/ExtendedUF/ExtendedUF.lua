ExtendedUF = LibStub("AceAddon-3.0"):NewAddon("ExtendedUF", "AceEvent-3.0")

local dogTag = LibStub("LibDogTag-3.0")

local function UnitFrame_OnDragStart(self)
	self.isMoving = true
	self:StartMoving()
end

local function UnitFrame_OnDragStop(self)
	if( self.isMoving ) then
		self.isMoving = nil
		self:StopMovingOrSizing()
	end
end

local function PartyMemberFrame_OnDragStart()
	UnitFrame_OnDragStart(PartyMemberFrame1)
end

local function PartyMemberFrame_OnDragStop()
	UnitFrame_OnDragStop(PartyMemberFrame1)
end

function ExtendedUF:OnInitialize()
	self.modules.Config:SetupDB()
	
	PlayerFrame:SetScript("OnDragStart", UnitFrame_OnDragStart)
	PlayerFrame:SetScript("OnDragStop", UnitFrame_OnDragStop)
	TargetFrame:SetScript("OnDragStart", UnitFrame_OnDragStart)
	TargetFrame:SetScript("OnDragStop", UnitFrame_OnDragStop)
	FocusFrame:SetScript("OnDragStart", UnitFrame_OnDragStart)
	FocusFrame:SetScript("OnDragStop", UnitFrame_OnDragStop)
	
	CastingBarFrame:SetScript("OnDragStart", UnitFrame_OnDragStart)
	CastingBarFrame:SetScript("OnDragStop", UnitFrame_OnDragStop)
	PartyMemberFrame1:SetScript("OnDragStart", UnitFrame_OnDragStart)
	PartyMemberFrame1:SetScript("OnDragStop", UnitFrame_OnDragStop)
	
	CastingBarFrame:SetMovable(true)
	CastingBarFrame:EnableMouse(true)
	
	for i=2, MAX_PARTY_MEMBERS do
		getglobal("PartyMemberFrame"..i):SetScript("OnDragStart", PartyMemberFrame_OnDragStart)
		getglobal("PartyMemberFrame"..i):SetScript("OnDragStop", PartyMemberFrame_OnDragStop)
	end
	
	for i=1, MAX_PARTY_MEMBERS do
		getglobal("TargetofPartyFrame"..i):SetScale(0.85)
		getglobal("PartyMemberFrame"..i.."PetFrameTexture"):SetTexture("Interface\\TargetingFrame\\UI-SmallTargetingFrame-NoMana")
		getglobal("PartyMemberFrame"..i.."PetFrameHealthBar"):SetPoint("TOPLEFT", "PartyMemberFrame"..i.."PetFrame", "TOPLEFT", 23, -12)
	end
	
	self:ReloadVisual("lock")
	self:ReloadVisual("permanentZoomedInIcons")
	self:ReloadVisual("showFocus")
	self:ReloadVisual("showTargetofParty")
	self:ReloadVisual("showFocusStatusText")
	self:ReloadVisual("showFocusCastbar")
	self:ReloadVisual("showPartyCastbar")
	self:ReloadVisual("showTargetClassIcon")
	self:ReloadVisual("showFocusClassIcon")
	self:ReloadVisual("showPartyClassIcon")
	self:ReloadVisual("smallTextOutline")
	--self:ReloadVisual("smallBuffSize")
	--self:ReloadVisual("largeBuffSize")
	
	hooksecurefunc("TextStatusBar_UpdateTextString", ExtendedUF_UpdateStatusBarText)
	hooksecurefunc("UnitFrameHealthBar_Update", ExtendedUF_UpdateHealthBar)
	hooksecurefunc("BuffButton_Update", ExtendedUF_UpdateBuffButton)
	hooksecurefunc("TargetDebuffButton_Update", ExtendedUF_UpdateTargetDebuffButton)
end

function ExtendedUF:SetZoomedInButton(buttonName)
	local button = getglobal(buttonName.."Icon")
	if (button) then
		if (self.db.profile.zoomedInIcons) then
			button:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		else
			button:SetTexCoord(0, 1, 0, 1)
		end
	end
end

function ExtendedUF:ReloadVisual(arg)
	if (arg == "texture") then
		local texture = self.media:Fetch(self.media.MediaType.STATUSBAR, self.db.profile.texture)
		
		PlayerFrameHealthBar:SetStatusBarTexture(texture)
		PlayerFrameManaBar:SetStatusBarTexture(texture)
		TargetFrameHealthBar:SetStatusBarTexture(texture)
		TargetFrameManaBar:SetStatusBarTexture(texture)
		TargetofTargetHealthBar:SetStatusBarTexture(texture)
		TargetofTargetManaBar:SetStatusBarTexture(texture)
		FocusFrameHealthBar:SetStatusBarTexture(texture)
		FocusFrameManaBar:SetStatusBarTexture(texture)
		TargetofFocusHealthBar:SetStatusBarTexture(texture)
		TargetofFocusManaBar:SetStatusBarTexture(texture)
		PetFrameHealthBar:SetStatusBarTexture(texture)
		PetFrameManaBar:SetStatusBarTexture(texture)
		
		TargetFrameNameBackground:SetTexture(texture)
		FocusFrameNameBackground:SetTexture(texture)
		
		for i=1, MAX_PARTY_MEMBERS do
			getglobal("PartyMemberFrame"..i.."HealthBar"):SetStatusBarTexture(texture)
			getglobal("PartyMemberFrame"..i.."ManaBar"):SetStatusBarTexture(texture)
			getglobal("TargetofPartyFrame"..i.."HealthBar"):SetStatusBarTexture(texture)
			getglobal("TargetofPartyFrame"..i.."ManaBar"):SetStatusBarTexture(texture)
			getglobal("PartyMemberFrame"..i.."PetFrameHealthBar"):SetStatusBarTexture(texture)
		end
		
	elseif (arg == "lock") then
		local registerValue = nil
		if (not self.db.profile.lock) then
			registerValue = "LeftButton"
		end
		
		PlayerFrame:RegisterForDrag(registerValue)
		TargetFrame:RegisterForDrag(registerValue)
		FocusFrame:RegisterForDrag(registerValue)
		CastingBarFrame:RegisterForDrag(registerValue)
		
		for i=1, MAX_PARTY_MEMBERS do
			getglobal("PartyMemberFrame"..i):RegisterForDrag(registerValue)
		end
		
	elseif (string.sub(arg, 1, 10) == "statusText") then
		TextStatusBar_UpdateTextString(PlayerFrameHealthBar)
		TextStatusBar_UpdateTextString(PlayerFrameManaBar)
		
		if (TargetFrame:IsVisible()) then
			TextStatusBar_UpdateTextString(TargetFrameHealthBar)
			TextStatusBar_UpdateTextString(TargetFrameManaBar)
		end
		
		if (FocusFrame:IsVisible()) then
			TextStatusBar_UpdateTextString(FocusFrameHealthBar)
			TextStatusBar_UpdateTextString(FocusFrameManaBar)
		end
		
		if (PetFrame:IsVisible()) then
			TextStatusBar_UpdateTextString(PetFrameHealthBar)
			TextStatusBar_UpdateTextString(PetFrameManaBar)
		end
		
		for i=1, MAX_PARTY_MEMBERS do
			if (getglobal("PartyMemberFrame"..i):IsVisible()) then
				TextStatusBar_UpdateTextString(getglobal("PartyMemberFrame"..i.."HealthBar"))
				TextStatusBar_UpdateTextString(getglobal("PartyMemberFrame"..i.."ManaBar"))
			end
		end
		
	elseif (arg == "zoomedInIcons") then
		for i=1, BUFF_ACTUAL_DISPLAY do
			self:SetZoomedInButton("BuffButton"..i)
		end
		
		for i=1, DEBUFF_ACTUAL_DISPLAY do
			self:SetZoomedInButton("DebuffButton"..i)
		end
		
		if (TargetFrame:IsVisible()) then
			for i=1, MAX_TARGET_BUFFS do
				self:SetZoomedInButton("TargetFrameBuff"..i)
			end
			
			for i=1, MAX_TARGET_DEBUFFS do
				self:SetZoomedInButton("TargetFrameDebuff"..i)
			end
		end
		
		if (FocusFrame:IsVisible()) then
			for i=1, MAX_FOCUS_BUFFS do
				self:SetZoomedInButton("FocusFrameBuff"..i)
			end
			
			for i=1, MAX_FOCUS_DEBUFFS do
				self:SetZoomedInButton("FocusFrameDebuff"..i)
			end
		end
		
		self:ReloadVisual("permanentZoomedInIcons")
		
	elseif (arg == "permanentZoomedInIcons") then
		for i=1, MAX_PARTY_DEBUFFS do --use MAX_PARTY_DEBUFFS because targettarget and focustarget debuffs inherit from party debuffs
			self:SetZoomedInButton("TargetofTargetFrameDebuff"..i)
			self:SetZoomedInButton("TargetofFocusFrameDebuff"..i)
		end
		
		for i=1, MAX_PARTY_MEMBERS do
			for j=1, MAX_PARTY_DEBUFFS do
				self:SetZoomedInButton("PartyMemberFrame"..i.."Debuff"..j)
				self:SetZoomedInButton("PartyMemberFrame"..i.."PetFrameDebuff"..j)
			end
			
			self:SetZoomedInButton("PartySpellBar"..i)
		end
		
		for i=1, MAX_PARTY_TOOLTIP_BUFFS do
			self:SetZoomedInButton("PartyMemberBuffTooltipBuff"..i)
		end
		
		for i=1, MAX_PARTY_TOOLTIP_DEBUFFS do
			self:SetZoomedInButton("PartyMemberBuffTooltipDebuff"..i)
		end
		
		self:SetZoomedInButton("FocusFrameSpellBar")
		self:SetZoomedInButton("TargetFrameSpellBar")
		
	elseif (arg == "showFocusStatusText") then
		if (self.db.profile.showFocusStatusText) then
			ShowTextStatusBarText(FocusFrameHealthBar)
			ShowTextStatusBarText(FocusFrameManaBar)
		else
			HideTextStatusBarText(FocusFrameHealthBar)
			HideTextStatusBarText(FocusFrameManaBar)
		end
		
	elseif (arg == "showFocusCastbar") then
		if (self.db.profile.showFocusCastbar) then
			if (FocusFrameSpellBar.casting or FocusFrameSpellBar.channeling) then
				FocusFrameSpellBar:Show()
			end
			FocusFrameSpellBar.showCastbar = true
		else
			FocusFrameSpellBar:Hide()
			FocusFrameSpellBar.showCastbar = false
		end
		
	elseif (arg == "showPartyCastbar") then
		for i=1, MAX_PARTY_MEMBERS do
			local castBar = getglobal("PartySpellBar"..i)
			if (self.db.profile.showPartyCastbar) then
				if (castBar.casting or castBar.channeling) then
					castBar:Show()
				end
				castBar.showCastbar = true
			else
				castBar:Hide()
				castBar.showCastbar = false
			end
		end
		
	elseif (arg == "showTargetClassIcon") then
		if (self.db.profile.showTargetClassIcon) then
			TargetFrameClassIcon.hide = nil
			ClassIcons_SetUnitClassIcon(TargetFrameClassIcon, "target")
		else
			TargetFrameClassIcon.hide = true
			TargetFrameClassIcon:Hide()
		end
		
	elseif (arg == "showFocusClassIcon") then
		if (self.db.profile.showFocusClassIcon) then
			FocusFrameClassIcon.hide = nil
			ClassIcons_SetUnitClassIcon(FocusFrameClassIcon, "focus")
		else
			FocusFrameClassIcon.hide = true
			FocusFrameClassIcon:Hide()
		end
		
	elseif (arg == "showPartyClassIcon") then
		for i=1, MAX_PARTY_MEMBERS do
			if (self.db.profile.showPartyClassIcon) then
				getglobal("PartyMemberFrame"..i.."ClassIcon").hide = nil
				ClassIcons_SetUnitClassIcon(getglobal("PartyMemberFrame"..i.."ClassIcon"), "party"..i)
			else
				getglobal("PartyMemberFrame"..i.."ClassIcon").hide = true
				getglobal("PartyMemberFrame"..i.."ClassIcon"):Hide()
			end
		end
		
	elseif (arg == "smallTextOutline") then
		
		local fontObject
		if (self.db.profile.smallTextOutline) then
			fontObject = GameFontHighlightSmallOutline
		else
			fontObject = TextStatusBarText
			fontObject:SetShadowOffset(0, 0)
		end
		
		PlayerFrameHealthBarText:SetFontObject(fontObject)
		PlayerFrameManaBarText:SetFontObject(fontObject)
		TargetFrameHealthBarText:SetFontObject(fontObject)
		TargetFrameManaBarText:SetFontObject(fontObject)
		FocusFrameHealthBarText:SetFontObject(fontObject)
		FocusFrameManaBarText:SetFontObject(fontObject)
		PetFrameHealthBarText:SetFontObject(fontObject)
		PetFrameManaBarText:SetFontObject(fontObject)
		
		for i=1, MAX_PARTY_MEMBERS do
			getglobal("PartyMemberFrame"..i.."HealthBarText"):SetFontObject(fontObject)
			getglobal("PartyMemberFrame"..i.."ManaBarText"):SetFontObject(fontObject)
		end
		
	--[[elseif (arg == "smallBuffSize") then
		SMALL_BUFF_SIZE = self.db.profile.smallBuffSize
		
	elseif (arg == "largeBuffSize") then
		LARGE_BUFF_SIZE = self.db.profile.largeBuffSize]]
		
	elseif (arg == "showTargetofParty") then
		for i=1, MAX_PARTY_MEMBERS do
			if (self.db.profile.showTargetofParty) then
				RegisterStateDriver(getglobal("TargetofPartyFrame"..i), "visibility", "[target=party"..i.."target,noexists]hide;show")
			else
				RegisterStateDriver(getglobal("TargetofPartyFrame"..i), "visibility", "hide")
			end
		end
		
	elseif (arg == "showFocus") then
		if (self.db.profile.showFocus) then
			RegisterStateDriver(FocusFrame, "visibility", "[target=focus,noexists][target=focus,harm,dead]hide;show")
		else
			RegisterStateDriver(FocusFrame, "visibility", "hide")
		end
		
	elseif (arg == "maxHpColor" or arg == "midHpColor" or arg == "minHpColor") then
		TextStatusBar_UpdateTextString(PlayerFrameHealthBar)
		
		if (TargetFrame:IsVisible()) then
			TextStatusBar_UpdateTextString(TargetFrameHealthBar)
			if (TargetofTargetFrame:IsVisible()) then
				TextStatusBar_UpdateTextString(TargetofTargetFrameHealthBar)
			end
		end
		if (FocusFrame:IsVisible()) then
			TextStatusBar_UpdateTextString(FocusFrameHealthBar)
			if (TargetofFocusFrame:IsVisible()) then
				TextStatusBar_UpdateTextString(TargetofFocusFrameHealthBar)
			end
		end
		if (PetFrame:IsVisible()) then
			TextStatusBar_UpdateTextString(PetFrameHealthBar)
		end
		for i=1, MAX_PARTY_MEMBERS do
			if (getglobal("PartyMemberFrame"..i):IsVisible()) then
				TextStatusBar_UpdateTextString(getglobal("PartyMemberFrame"..i.."HealthBar"))
			end
			if (getglobal("TargetofPartyFrame"..i):IsVisible()) then
				TextStatusBar_UpdateTextString(getglobal("TargetofPartyFrame"..i.."HealthBar"))
			end
			if (getglobal("PartyMemberFrame"..i.."PetFrame"):IsVisible()) then
				TextStatusBar_UpdateTextString(getglobal("PartyMemberFrame"..i.."PetFrameHealthBar"))
			end
		end
	
	end
end

function ExtendedUF:GetGradientHealth(percent)
	local color1
	local color2
	
	if percent <= 0.5 then
		percent = percent * 2
		color1 = self.db.profile.minHpColor
		color2 = self.db.profile.midHpColor
	else
		percent = percent * 2 - 1
		color1 = self.db.profile.midHpColor
		color2 = self.db.profile.maxHpColor
	end
	
	return color1.r + (color2.r-color1.r)*percent, color1.g + (color2.g-color1.g)*percent, color1.b + (color2.b-color1.b)*percent
end

function ExtendedUF:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99ExtendedUF|r: " .. msg)
end



--overwrite default interface functions
function ExtendedUF_UpdateStatusBarText(textStatusBar)
	if (not textStatusBar) then
		textStatusBar = this
	end
	local textString = textStatusBar.TextString
	if (textString and textStatusBar.unit and textStatusBar.isZero ~= 1 and not textStatusBar.pauseUpdates) then
		local unitId
		
		if (string.sub(textStatusBar.unit, 1, 5) == "party") then
			unitId = "party"
		else
			unitId = textStatusBar.unit
		end
		
		if (string.sub(textStatusBar:GetName(), -7) == "ManaBar") then
			unitId = unitId.."MP"
		else
			unitId = unitId.."HP"
		end
		
		textString:SetText(dogTag:Evaluate(ExtendedUF.db.profile.statusText[unitId], "Unit", {["unit"] = textStatusBar.unit}))
	end
end

function ExtendedUF_UpdateHealthBar(statusbar, unit)
	if (statusbar and unit == statusbar.unit and UnitIsConnected(unit)) then
		statusbar:SetStatusBarColor(ExtendedUF:GetGradientHealth(statusbar:GetValue()/select(2, statusbar:GetMinMaxValues())))
	end
end

function ExtendedUF_UpdateBuffButton(buttonName, index, filter)
	if ( filter == "HELPFUL" ) then
		ExtendedUF:SetZoomedInButton(buttonName..index)
	end
end

function ExtendedUF_UpdateTargetDebuffButton()
	for i=1, MAX_TARGET_BUFFS do
		ExtendedUF:SetZoomedInButton("TargetFrameBuff"..i)
	end
end
