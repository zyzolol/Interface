local max = math.max
local CreateFrame = CreateFrame
local GREEN_FONT_COLOR = GREEN_FONT_COLOR
local PlaySound = PlaySound
local Talented = Talented
local GameTooltip = GameTooltip

local dewdrop = AceLibrary("Dewdrop-2.0")
local L = AceLibrary("AceLocale-2.2"):new("Talented")

local wotlk = select(4, GetBuildInfo()) >= 3e4

local function MakeButton(parent)
	local button = CreateFrame("Button", nil, parent)
	if wotlk then
		button:SetNormalFontObject(GameFontNormal)
	else
		button:SetTextFontObject(GameFontNormal)
	end
	button:SetHighlightFontObject(GameFontHighlight)
	button:SetDisabledFontObject(GameFontDisable)
	
	local CreateTexture = function(path, blend)
		local t = button:CreateTexture()
		if path then t:SetTexture(path) end
		if blend then t:SetBlendMode(blend) end
		t:SetTexCoord(0, 0.625, 0, 0.6875)
		t:SetAllPoints(button)
		return t
	end
	
	button:SetNormalTexture(CreateTexture("Interface\\Buttons\\UI-Panel-Button-Up"))
	button:SetPushedTexture(CreateTexture("Interface\\Buttons\\UI-Panel-Button-Down"))
	button:SetDisabledTexture(CreateTexture("Interface\\Buttons\\UI-Panel-Button-Disabled"))
	button:SetHighlightTexture(CreateTexture("Interface\\Buttons\\UI-Panel-Button-Highlight", "ADD"))
	
	return button
end

local function CreateBaseButtons(parent)
	local b = MakeButton(parent)
	parent.boptions = b

	local point = function ()
		return "TOPLEFT", "BOTTOMLEFT"
	end
	local onclick = function (this)
		if dewdrop:IsOpen(this) then
			dewdrop:Close()
		else
			dewdrop:Open(this)
		end
	end
	
	b:SetText(L["Options"])
	local width = max(110, b:GetTextWidth() + 22)
	b:SetWidth(width)
	b:SetHeight(22)
	b:SetScript("OnClick", function (this)
			dewdrop:Register(this, 
				"children", Talented.options.args.options,
				"dontHook", true,
				"point", point)
			this:SetScript("OnClick", onclick)
			dewdrop:Open(this)
		end)
	b:SetPoint("TOPLEFT", 14, -4)
	
	b = MakeButton(parent)
	parent.bmode = b

	b:SetText(L["Mode"])
	local width = max(110, b:GetTextWidth() + 22)
	b:SetWidth(width)
	b:SetHeight(22)
	b:SetScript("OnClick", function (this)
			dewdrop:Register(this, 
				"children", Talented.options.args.mode,
				"dontHook", true,
				"point", point)
			this:SetScript("OnClick", onclick)
			dewdrop:Open(this)
		end)
	b:SetPoint("LEFT", parent.boptions, "RIGHT", 14, 0)
	
	b = MakeButton(parent)
	parent.btemplate = b
	
	b:SetText(L["Template"])
	width = max(110, b:GetTextWidth() + 22)
	b:SetWidth(width)
	b:SetHeight(22)
	b:SetScript("OnClick", function (this)
			dewdrop:Register(this, 
				"children", Talented.options.args.template,
				"dontHook", true,
				"point", point)
			this:SetScript("OnClick", onclick)
			dewdrop:Open(this)
		end)
	b:SetPoint("LEFT", parent.bmode, "RIGHT", 14, 0)

	local e = CreateFrame("EditBox", nil, parent)
	parent.editname = e
	e:SetFontObject(ChatFontNormal)
	e:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	width = 400
	e:SetWidth(width)
	e:SetHeight(13)
	e:SetAutoFocus(false)
	
	e:SetScript("OnEscapePressed", function (this)
			this:ClearFocus()
		end)
	e:SetScript("OnEditFocusLost", function (this)
			this:SetText(Talented.template.name)
		end)
	e:SetScript("OnEnterPressed",  function (this)
			Talented:UpdateTemplateName(Talented.template, this:GetText())
			Talented:UpdateView()
			this:ClearFocus()
		end)
	e:SetScript("OnEnter", function (self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, 1)
		end)
	e:SetScript("OnLeave", function (self)
			if GameTooltip:IsOwned(self) then
				GameTooltip:Hide()
			end
		end)
	e:SetPoint("LEFT", parent.btemplate, "RIGHT", 14, 0)
	e.tooltip = L["You can edit the name of the template here. You must press the Enter key to save your changes."]
	
	local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	fs:SetJustifyH("LEFT")
	fs:SetWidth(width)
	fs:SetHeight(13)
	fs:SetPoint("LEFT", parent.btemplate, "RIGHT", 14, 0)
	parent.targetname = fs
	
	do
		local f = CreateFrame("Frame", nil, parent)
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		fs:SetJustifyH("RIGHT")
		fs:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -14, 8)
		f:SetPoint("BOTTOMRIGHT")
		f:SetFrameLevel(parent:GetFrameLevel()+2)
		f.text = fs
		parent.pointsleft = f
	end
	
	local cb = CreateFrame("Checkbutton", nil, parent)
	parent.checkbox = cb

	local makeTexture = function (path, blend)
		local t = cb:CreateTexture()
		t:SetTexture(path)
		t:SetAllPoints(cb)
		if blend then
			t:SetBlendMode(blend)
		end
		return t
	end
	
	cb:SetHeight(20)
	cb:SetWidth(20)

	local fs = cb:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	cb.label = fs
	fs:SetJustifyH("LEFT")
	fs:SetWidth(400)
	fs:SetHeight(20)
	fs:SetPoint("LEFT", cb, "RIGHT", 1, 1)
	cb:SetNormalTexture(makeTexture("Interface\\Buttons\\UI-CheckBox-Up"))
	cb:SetPushedTexture(makeTexture("Interface\\Buttons\\UI-CheckBox-Down"))
	cb:SetDisabledTexture(makeTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled"))
	cb:SetCheckedTexture(makeTexture("Interface\\Buttons\\UI-CheckBox-Check"))
	cb:SetHighlightTexture(makeTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD"))
	cb:SetScript("OnClick", function ()
		if Talented.mode == "edit" then
			Talented:SetMode("view")
		else
			Talented:SetMode("edit")
		end
	end)
	cb.label:SetText(Talented.options.args.mode.args.edit.name)
	cb:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 14, 8)
	cb:SetFrameLevel(parent:GetFrameLevel()+2)
end

function Talented:CreateBaseFrame()
	local frame = self.base
	if frame then return frame end
	
	local onshow = function ()
		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
		self:RegisterEvent("MODIFIER_STATE_CHANGED")
		SetButtonPulse(TalentMicroButton, 0, 1)
		PlaySound("TalentScreenOpen")
		UpdateMicroButtons()
	end
	
	frame = CreateFrame("Frame", "TalentedFrame", UIParent)
	frame:SetFrameStrata("DIALOG")
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetToplevel(true)
	frame:SetWidth(50)
	frame:SetHeight(50)
	frame:SetBackdrop({
		bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 16,
		tileSize = 32,
		insets = {
			left = 5,
			right = 5,
			top = 5,
			bottom = 5
		}
	})

	frame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	frame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() Talented:SaveFramePosition() end)

	frame.points = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.points:SetJustifyH("RIGHT")
	frame.points:SetWidth(80)
	frame.points:SetHeight(14)
	frame.points:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -40, -6)
	
	local close = CreateFrame("Button", nil, frame)
	frame.close = close
	
	local makeTexture = function (path, blend)
		local t = close:CreateTexture()
		t:SetAllPoints(close)
		t:SetTexture(path)
		if blend then
			t:SetBlendMode(blend)
		end
		return t
	end

	close:SetNormalTexture(makeTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up"))
	close:SetPushedTexture(makeTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down"))
	close:SetHighlightTexture(makeTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD"))
	close:SetScript("OnClick", function () HideUIPanel(frame) end)
	
	close:SetWidth(32)
	close:SetHeight(32)
	close:ClearAllPoints()
	close:SetPoint("TOPRIGHT", 1, 0)

	CreateBaseButtons(frame)

	frame:SetScript("OnShow", onshow)
	frame:SetScript("OnHide", function()
			PlaySound("TalentScreenClose")
			if dewdrop:IsOpen(self.boptions) or dewdrop:IsOpen(self.bmode) or dewdrop:IsOpen(self.btemplate) then
				dewdrop:Close()
			end
			if self.mode == "apply" then
				self:SetMode(self.db.profile.default_mode)
				self:Print(L["Error! Talented window has been closed during template application. Please reapply later."])
				self:EnableUI()
			end
			self:UnregisterEvent("CHARACTER_POINTS_CHANGED")
			self:UnregisterEvent("MODIFIER_STATE_CHANGED")
		end)

	UIPanelWindows["TalentedFrame"] = { area = "center", pushable = 0, whileDead = 1 }

	self.base = frame
	onshow()
	frame:Hide()
	
	if not self:IsTemplateMode() then
		frame.btemplate:Hide()
		frame.editname:Hide()
	end

	self.CreateBaseFrame = function () return self.base end
	return frame
end

function Talented:EnableUI(enable)
	local f = self.base
	if enable then
		f.boptions:Enable()
		f.bmode:Enable()
		f.btemplate:Enable()
		f.close:Enable()
	else
		dewdrop:Close()
		f.boptions:Disable()
		f.bmode:Disable()
		f.btemplate:Disable()
		f.close:Disable()
	end
end
