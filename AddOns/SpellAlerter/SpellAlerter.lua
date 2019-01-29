-----------------------------------------------------
-- Spell Alerter by Kollektiv
-----------------------------------------------------

SpellAlerterDB = SpellAlerterDB or { anchors = {}, version = GetAddOnMetadata("SpellAlerter","version") }

local anchors = {}

local GetSpellInfo = GetSpellInfo
local band = bit.band
local match = string.match
local SpellAlerterFrame
local _G = _G
local pairs = pairs
local next = next

local defaultSpellcasts = {
	-- Heals
	-------------------------------------
		-- Priests
		[25235] = 1, -- Flash Heal
		[25213] = 1, -- Greater Heal
		[32546] = 1, -- Binding Heal
		-- Druid
		[26979] = 1, -- Healing Touch
		[26980] = 1, -- Regrowth
		[26983] = 1, -- Tranquility
		-- Shaman 
		[25396] = 1, -- Healing Wave
		[25420] = 1, -- Lesser Healing Wave
		-- Paladin
		[27137] = 1, -- Flash of Light
		[27136] = 1, -- Holy Light
	-- CC
	-------------------------------------
		-- Priest
		[10912] = 2, -- Mind Control
		[10890] = 2, -- cri psychique
		-- Druid
		[26989] = 2, -- Entangling Roots
		[33786] = 2, -- Cyclone
		-- Hunter
		[14311] = 2, -- Freezing Trap
		[13809] = 2, -- Frost Trap
		[34600] = 2, -- Snake Trap
		-- Mage
		[12826] = 2, -- Polymorph
		-- Warlock
		[6215] = 2,  -- Fear
		[17928] = 2, -- Howl of Terror
		-- Warrior
		[23920] = 2, -- Spell Reflection
		
	-- Destroyable
	-------------------------------------
		[16190] = 3, -- Mana Tide Totem
		[8177] = 3,  -- Grounding Totem
		
	-- Damage
	-------------------------------------
		-- Priest
		[25380] = 4, -- Mana Burn
		-- Mage
		[38697] = 4, -- Frostbolt
		[38692] = 4, -- Fireball
		[33938] = 4, -- Pyroblast
		-- Shaman
		[25449] = 4, -- Lightning Bolt
		[25442] = 4, -- Chain Lightning
		-- Warlock
		[27209] = 4, -- Shadowbolt
		[30545] = 4, -- Soul Fire
}

local tempSpellcasts = {}
for k,v in pairs(defaultSpellcasts) do
	tempSpellcasts[GetSpellInfo(k)] = v
end
defaultSpellcasts = tempSpellcasts

local defaultEnemyBuffs = {
	-- Clearable
	-------------------------------------
		-- Druid
		[29166] = 10, -- Innervate
		-- Shaman
		[32594] = 10, -- Earth Shield
		-- Paladin
		[1044] = 6,   -- Blessing of Freedom
		[10278] = 6,  -- Blessing of Protection
		-- Priest
		[10060] = 10, -- Power Infusion
		-- Mage 
		[12051] = 10, -- Evocation
		[17116] = 10, -- Nature's Swiftness
}

local tempEnemyBuffs = {}
for k,v in pairs(defaultEnemyBuffs) do
	tempEnemyBuffs[GetSpellInfo(k)] = v
end
defaultEnemyBuffs = tempEnemyBuffs

local defaultFriendlyDebuffs = {
	-- Clearable
	-------------------------------------
		[27018] = 13 -- Viper Sting
}

local tempFriendlyDebuffs = {}
for k,v in pairs(defaultFriendlyDebuffs) do
	tempFriendlyDebuffs[GetSpellInfo(k)] = v
end
defaultFriendlyDebuffs = tempFriendlyDebuffs

local backdrop = {bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile=nil,tile=true,tileSize=16,edgeSize=10,}

local function SpellAlerter_GetDefaultSettings() 
	return {fade = 1, spellnames = false, targetonly = false, scale = 1, fontsize = 40, lock = 1, iconsize = 35, showtext = 1, showicon = 1,}
end

local function rgbhex(r, g, b)
	return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

local colors = {
		[1] = {1,1,0,0,hex="|cffffff00",},	-- yellow
		[2] = {1,0,1,0,hex="|cffff00ff",},	-- pink
		[3] = {0,1,0,0,hex="|cff00ff00",},	-- green
		[4] = {1,0,0,0,hex="|cffff0000",},	-- red
		[5] = {1,1,1,0,hex=rgbhex(1,1,1),},	-- white
		[6] = {139/255,0,1,0,hex=rgbhex(139/255,0,1),}, -- violet
		[7] = {210/255,180/255,140/255,0,hex=rgbhex(210/255,180/255,140/255),}, -- tan
		[8] = {0,128/255,128/255,0,hex=rgbhex(0,128/255,128/255),}, -- teal
		[9] = {48/255,213/255,200/255,0,hex=rgbhex(48/255,213/255,200/255),}, -- turquoise
		[10] = {1,229/255,180/255,0,hex=rgbhex(1,229/255,180/255),}, -- peach
		[11] = {0,65/255,106/255,0,hex=rgbhex(0,65/255,106/255),}, -- indigo
		[12] = {128/255,128/255,128/255,0,hex=rgbhex(128/255,128/255,128/255),}, -- grey
		[13] = {0,1,1,0,hex=rgbhex(0,1,1),}, -- aqua
}

-- References
local ref_GetTextColor
local ref_SetText
local ref_SetTexture
local ref_TextureSetVertexColor
local ref_TextSetVertexColor
local ref_Show
local ref_Hide
local ref_SetScript

local function SpellAlerter_SavePosition(self)
	local ref = SpellAlerterDB.anchors[self.name].settings
	local xOfs, yOfs = self:GetLeft()+self:GetWidth()/2,self:GetBottom()+self:GetHeight()/2
	if not ref.Position then
		ref.Position = {}
	end
	ref.Position.xOfs = xOfs
	ref.Position.yOfs = yOfs
end

local function SpellAlerter_LoadPosition(self)
	self:ClearAllPoints()
	local ref = SpellAlerterDB.anchors[self.name].settings
	if ref.Position then
		self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", ref.Position.xOfs, ref.Position.yOfs)
	else
		self:SetPoint("CENTER",UIParent,"CENTER",0,190)
	end
end

local function SpellAlerter_UpdateAnchorSettings(anchor)
	local settings = anchor.settings
	if settings.lock == 1 then
		anchor:SetBackdropColor(0.15,0.15,0.15,0)
		anchor.text:SetText("")
		anchor:EnableMouse(false)
	else
		anchor:SetBackdropColor(0.15,0.15,0.15,0.9)
		anchor.text:SetText(anchor.name)
		anchor:EnableMouse(true)
	end
	if settings.showtext == 1 then anchor.frame.text:Show() else anchor.frame.text:Hide() end
	if settings.showicon == 1 then anchor.frame.texture:Show() else anchor.frame.texture:Hide() end
	anchor.frame.fade = settings.fade
	anchor.frame.text:SetFont(GameFontNormal:GetFont(),settings.fontsize,"THICKOUTLINE")
	anchor.frame.texture:SetHeight(settings.iconsize)
	anchor.frame.texture:SetWidth(settings.iconsize)
	anchor.frame.targetonly = settings.targetonly
	
	SpellAlerter_LoadPosition(anchor)
end

local function SpellAlerter_CreateFrame(name)
	local anchor = CreateFrame("Frame","SpellAlerterAnchor"..name,UIParent)
	anchor:EnableMouse(true)
	anchor:SetMovable(true)
	anchor.name = name
	anchor:SetWidth(50)
	anchor:SetHeight(50)
	
	anchor:SetBackdrop(backdrop)
	anchor:SetScript("OnMouseDown",function(self,button) if button == "LeftButton" then self:StartMoving() end end)
	anchor:SetScript("OnMouseUp",function(self,button) if button == "LeftButton" then self:SetUserPlaced(false); self:StopMovingOrSizing(); SpellAlerter_SavePosition(self) end end)
	
	local anchortext = anchor:CreateFontString(nil,"ARTWORK","GameFontNormal")
	anchortext:SetPoint("CENTER")
	anchortext:SetText(name)
	anchor:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
	anchor.text = anchortext
	
	local frame = CreateFrame("Frame",anchor:GetName().."Frame",anchor)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(1)
	frame:SetHeight(1)
	frame:SetPoint("CENTER")
	frame:Show()
	
	ref_Show = frame.Show
	ref_Hide = frame.Hide
	ref_SetScript = frame.SetScript
	
	local txt = frame:CreateFontString(nil,"ARTWORK")
	txt:SetFont(STANDARD_TEXT_FONT,40,"THICKOUTLINE")
	txt:SetPoint("LEFT",frame,"CENTER",-45,-2)
	txt:SetJustifyH("LEFT")
	
	ref_GetTextColor = txt.GetTextColor
	ref_SetText = txt.SetText
	ref_SetTextColor = txt.SetTextColor
	ref_TextSetVertexColor = txt.SetVertexColor
	
	local txtr = frame:CreateTexture(nil,"BACKGROUND")
	txtr:SetVertexColor(1,1,1,1)
	txtr:SetPoint("RIGHT",frame,"CENTER",-50,0)
	txtr:SetTexCoord(0.07,0.9,0.07,0.90)
	
	ref_SetTexture = txtr.SetTexture
	ref_TextureSetVertexColor = txtr.SetVertexColor
	
	anchor.frame = frame
	frame.texture = txtr
	frame.text = txt
	frame.time = 0
	frame.fadetime = 0
	frame.num = 0
	
	return anchor
end

local function SpellAlerter_OnUpdate(self,elapsed)
	self.time = self.time + elapsed
	self.fadetime = self.fadetime + elapsed
	if self.time > 0.05 then
		local r,g,b = ref_GetTextColor(self.text)
		if self.fadetime < .1 then
			self.num = self.num + 0.5
		elseif self.fadetime >= 0.1 and self.fadetime <= (self.fade - 0.1) then
			self.num = 1
		elseif self.fadetime > (self.fade - 0.1) then
			self.num = self.num - 0.5
		end
		ref_TextSetVertexColor(self.text,r,g,b,self.num)
		ref_TextureSetVertexColor(self.texture,1,1,1,self.num)
		self.time = 0
		if self.fadetime > self.fade then
			ref_SetScript(self,"OnUpdate",nil)
			ref_Hide(self)
		end
	end
end

local function SpellAlerter_AddMessage(frame,unit,type,icon,spell,spellnames)
	ref_SetTexture(frame.texture,icon)
	ref_TextureSetVertexColor(frame.texture,1,1,1,0)
	if spellnames then
		ref_SetText(frame.text,spell.." - "..unit)
	else
		ref_SetText(frame.text,unit)
	end
	frame.text:SetTextColor(unpack(colors[type]))
	frame.time, frame.fadetime, frame.num = 0,0,0
	ref_Show(frame)
	ref_SetScript(frame,"OnUpdate",SpellAlerter_OnUpdate)
end

local target = 0x00010000

local function SpellAlerter_AddHostileSpellcastMessage(spell,icon,unit,srcFlags)
	for name,anchor in pairs(anchors) do
		if anchor.spellcasts[spell] then
			if anchor.settings.targetonly and band(srcFlags,target) ~= target then return end
			SpellAlerter_AddMessage(anchor.frame,unit,anchor.spellcasts[spell],icon,spell,anchor.settings.spellnames)
		end
	end
end

local function SpellAlerter_AddFriendlyDebuffMessage(spell,icon,unit,dstFlags)
	for _,anchor in pairs(anchors) do
		if anchor.friendlydebuffs[spell] then
			if anchor.settings.targetonly and band(dstFlags,target) ~= target then return end
			SpellAlerter_AddMessage(anchor.frame,unit,anchor.friendlydebuffs[spell],icon,spell,anchor.settings.spellnames)
		end
	end
end

local function SpellAlerter_AddHostileBuffMessage(spell,icon,unit,dstFlags)
	for _,anchor in pairs(anchors) do
		if anchor.enemybuffs[spell] then
			if anchor.settings.targetonly and band(dstFlags,target) ~= target then return end
			SpellAlerter_AddMessage(anchor.frame,unit,anchor.enemybuffs[spell],icon,spell,anchor.settings.spellnames)
		end
	end
end

local SpellCastEvents = {
	SPELL_CAST_START = 1,
	SPELL_CAST_SUCCESS = 1,
	SPELL_CREATE = 1,
}

local group = bit.bor(0x00000001,0x00000002,0x00000004)

local function SpellAlerter_COMBAT_LOG_EVENT_UNFILTERED(self, event, _, eventtype, _, srcName, srcFlags, _, dstName, dstFlags, spellID, spellName, _, auraType)
	if not spellID then return end
	local _,_,icon = GetSpellInfo(spellID)
	if spellID == 35216 then return end -- Flash of Light Bug
	if SpellCastEvents[eventtype] and band(srcFlags, 0x00000040) == 0x00000040 then
		SpellAlerter_AddHostileSpellcastMessage(spellName,icon,match(srcName,"[^-]*"),srcFlags)
	elseif eventtype == "SPELL_AURA_APPLIED" then
		if auraType == "BUFF" and band(dstFlags,0x00000040) == 0x00000040 then
			SpellAlerter_AddHostileBuffMessage(spellName,icon,match(dstName,"[^-]*"),dstFlags)
		elseif (band(dstFlags,0x00000010) == 0x00000010 or band(dstFlags,group) > 0) and auraType == "DEBUFF"  then
			SpellAlerter_AddFriendlyDebuffMessage(spellName,icon,match(dstName,"[^-]*"),dstFlags)
		end
	end
end

local function SpellAlerter_Test(anchor)
	SpellAlerter_AddMessage(anchor.frame,"Kollektiv",3,"Interface\\Icons\\Spell_Nature_SkinofEarth","Earth Shield",anchor.settings.spellnames)
end

----------------------------------------------------------------
-- GUI
-- Some widget functions taken from OmniCC, credits to Tuller
----------------------------------------------------------------

local currentbutton
local buttons = {}
local scrollframe
local currentanchor
local selectedspelltab -- 1-"Spell Casts", 2-"Enemy Buffs", 3-"Friendly Debuffs"
local selectedspelltable
local sortedspells = {}

local function SpellAlerter_CreatePanel(self,name,hidetext)
	local panel = CreateFrame('Frame', self:GetName() .. name, self, 'OptionFrameBoxTemplate')
	panel:SetBackdropBorderColor(0.4, 0.4, 0.4)
	panel:SetBackdropColor(0.15, 0.15, 0.15, 0.5)
	if hidetext then else _G[panel:GetName() .. 'Title']:SetText(name) end

	return panel
end

local function SpellAlerter_CreateButton(text,parent)
	local button = CreateFrame('Button',parent:GetName() .. text, parent,"UIPanelButtonTemplate")
	_G[button:GetName() .. 'Text']:SetText(text)
	
	return button
end

local function SpellAlerter_CreateSlider (text, parent, low, high, step)
	local name = parent:GetName() .. text
	local slider = CreateFrame('Slider', name, parent, 'OptionsSliderTemplate')
	slider:SetWidth(160)
	slider:SetMinMaxValues(low, high)
	slider:SetValueStep(step)
	_G[name .. 'Text']:SetText(text)
	_G[name .. 'Low']:SetText('')
	_G[name .. 'High']:SetText('')
	
	local text = slider:CreateFontString(nil, 'BACKGROUND')
	text:SetFontObject('GameFontHighlightSmall')
	text:SetPoint('TOP', slider, 'BOTTOM', 0, 0)
	slider.valText = text

	return slider
end

local function SpellAlerter_CreateCheckButton(name, parent)
	local button = CreateFrame('CheckButton', parent:GetName() .. name, parent, 'OptionsCheckButtonTemplate')
	_G[button:GetName() .. 'Text']:SetText(name)

	return button
end

local function SpellAlerter_CreateDropdown(name, parent)
	local frame = CreateFrame('Frame', parent:GetName() .. name, parent, 'UIDropDownMenuTemplate')
	local text = frame:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 21, 0)
	text:SetFontObject("GameFontNormalSmall")
	text:SetText(name)
	frame.text = text

	return frame
end

local function SpellAlerter_CreateEditBox(name,parent,width,height)
	local editbox = CreateFrame("EditBox",parent:GetName()..name,parent,"InputBoxTemplate")
	editbox:SetHeight(height);editbox:SetWidth(width)
	editbox:SetAutoFocus(false)
	return editbox
end

local function SpellAlerter_CreateCurrentAnchorPanel(parent)
	local panel = SpellAlerter_CreatePanel(parent,"Current Anchor Settings")
	panel:SetWidth(366); panel:SetHeight(165)

	local lock = SpellAlerter_CreateCheckButton("Lock", panel)
	lock:SetScript('OnShow', function(self) self:SetChecked(currentanchor.settings.lock) end)
	lock:SetScript('OnClick', function(self) currentanchor.settings.lock = self:GetChecked(); SpellAlerter_UpdateAnchorSettings(currentanchor) end)
	lock:SetPoint('TOPLEFT', 10, -10)
	
	local fade = SpellAlerter_CreateSlider("Fade time", panel, 0.5, 5, 0.5)
	fade:SetScript('OnShow', function(self)
		self.onShow = true
		self:SetValue(currentanchor.settings.fade)
		self.onShow = nil
	end)
	fade:SetScript('OnValueChanged', function(self, value)
		self.valText:SetText(value.."s")
		if not self.onShow then
			currentanchor.settings.fade = value
			SpellAlerter_UpdateAnchorSettings(currentanchor)
			SpellAlerter_Test(currentanchor)
		end
	end)
	fade:SetPoint("TOPLEFT",lock,"BOTTOMLEFT",0,-4)
	
	local iconsize = SpellAlerter_CreateSlider("Icon Size", panel, 10, 100, 1)
	iconsize:SetScript('OnShow', function(self)
		self.onShow = true
		self:SetValue(currentanchor.settings.iconsize)
		self.onShow = nil
	end)
	iconsize:SetScript('OnValueChanged', function(self, value)
		self.valText:SetText(value)
		if not self.onShow then
			currentanchor.settings.iconsize = value
			SpellAlerter_UpdateAnchorSettings(currentanchor)
			SpellAlerter_Test(currentanchor)
		end
	end)
	iconsize:SetPoint("TOPLEFT",fade,"BOTTOMLEFT",0,-24)
	
	local fontsize = SpellAlerter_CreateSlider("Font Size", panel, 1, 40, 1)
	fontsize:SetScript('OnShow', function(self)
		self.onShow = true
		self:SetValue(currentanchor.settings.fontsize)
		self.onShow = nil
	end)
	fontsize:SetScript('OnValueChanged', function(self, value)
		self.valText:SetText(value)
		if not self.onShow then
			currentanchor.settings.fontsize = value
			SpellAlerter_UpdateAnchorSettings(currentanchor)
			SpellAlerter_Test(currentanchor)
		end
	end)
	fontsize:SetPoint("TOPLEFT",iconsize,"BOTTOMLEFT",0,-24)	

	local targetonly = SpellAlerter_CreateCheckButton("Target only", panel)
	targetonly:SetScript('OnShow', function(self) self:SetChecked(currentanchor.settings.targetonly) end)
	targetonly:SetScript('OnClick', function(self) currentanchor.settings.targetonly = self:GetChecked(); SpellAlerter_UpdateAnchorSettings(currentanchor) end)
	targetonly:SetPoint('TOPLEFT', panel,'TOPLEFT',180,-10)
	
	local spellnames = SpellAlerter_CreateCheckButton("Spell names", panel)
	spellnames:SetScript('OnShow', function(self) self:SetChecked(currentanchor.settings.spellnames) end)
	spellnames:SetScript('OnClick', function(self) currentanchor.settings.spellnames = self:GetChecked(); SpellAlerter_UpdateAnchorSettings(currentanchor); SpellAlerter_Test(currentanchor) end)
	spellnames:SetPoint('TOP', targetonly, "BOTTOM")
	
	local showtext = SpellAlerter_CreateCheckButton("Text", panel)
	showtext:SetScript('OnShow', function(self) self:SetChecked(currentanchor.settings.showtext) end)
	showtext:SetScript('OnClick', function(self) currentanchor.settings.showtext = self:GetChecked(); SpellAlerter_UpdateAnchorSettings(currentanchor); SpellAlerter_Test(currentanchor) end)
	showtext:SetPoint("TOPRIGHT", panel, "TOPRIGHT",-40,-10)
	
	local showicon = SpellAlerter_CreateCheckButton("Icon", panel)
	showicon:SetScript('OnShow', function(self) self:SetChecked(currentanchor.settings.showicon) end)
	showicon:SetScript('OnClick', function(self) currentanchor.settings.showicon = self:GetChecked(); SpellAlerter_UpdateAnchorSettings(currentanchor); SpellAlerter_Test(currentanchor) end)
	showicon:SetPoint('TOP', showtext, "BOTTOM")
	
	local xPos = SpellAlerter_CreateSlider("X Position", panel, 0, 2000, 10)
	xPos:SetScript('OnShow', function(self)
		self.onShow = true
		SpellAlerter_SavePosition(currentanchor)
		self:SetValue(currentanchor.settings.Position.xOfs)
		self.onShow = nil
	end)
	xPos:SetScript('OnValueChanged', function(self, value)
		self.valText:SetText(value)
		if not self.onShow then
			currentanchor.settings.Position.xOfs = value
			SpellAlerter_UpdateAnchorSettings(currentanchor)
			SpellAlerter_Test(currentanchor)
		end
	end)
	xPos:SetPoint("TOPLEFT",spellnames,"BOTTOMLEFT",0,-13)
	
	local yPos = SpellAlerter_CreateSlider("Y Position", panel, 0, 2000, 10)
	yPos:SetScript('OnShow', function(self)
		self.onShow = true
		SpellAlerter_SavePosition(currentanchor)
		self:SetValue(currentanchor.settings.Position.yOfs)
		self.onShow = nil
	end)
	yPos:SetScript('OnValueChanged', function(self, value)
		self.valText:SetText(value)
		if not self.onShow then
			currentanchor.settings.Position.yOfs = value
			SpellAlerter_UpdateAnchorSettings(currentanchor)
			SpellAlerter_Test(currentanchor)
		end
	end)
	yPos:SetPoint("TOPLEFT",xPos,"BOTTOMLEFT",0,-24)
	return panel
end

local function SpellAlerter_CreateSpacer(parent,width)
	local spacer = parent:CreateTexture(nil,"ARTWORK")
	spacer:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-Spacer")
	spacer:SetHeight(16)
	spacer:SetWidth(width-20)
	return spacer
end


local function SpellAlerter_CreateTab(parent,name,text)
	local tab = CreateFrame("Button",parent:GetName()..name,parent,"OptionsFrameTabButtonTemplate")
	tab:SetText(text)
	PanelTemplates_TabResize(0,tab)
	local spacer = SpellAlerter_CreateSpacer(tab,tab:GetWidth())
	spacer:SetPoint("BOTTOM",tab,"BOTTOM",0,-6)
	tab.spacer = spacer
	return tab
end

local function SpellAlerter_SortSpells(sourceTable)
	for k in ipairs(sortedspells) do
		sortedspells[k] = nil
	end
	for k in pairs(sourceTable) do
		sortedspells[#sortedspells+1] = k
	end
	table.sort(sortedspells,function(a,b) return a < b end)
end


local function SpellAlerter_SetSortedSpells()
	if selectedspelltab == 1 then
		SpellAlerter_SortSpells(currentanchor.spellcasts)
		selectedspelltable = currentanchor.spellcasts
	elseif selectedspelltab == 2 then
		SpellAlerter_SortSpells(currentanchor.enemybuffs)
		selectedspelltable = currentanchor.enemybuffs
	elseif selectedspelltab == 3 then
		SpellAlerter_SortSpells(currentanchor.friendlydebuffs)
		selectedspelltable = currentanchor.friendlydebuffs
	end
end


local function SpellAlerter_UpdateScrollBar()
	local line
	local lineplusoffset
	SpellAlerter_SetSortedSpells()
	local isShown = FauxScrollFrame_Update(scrollframe,#sortedspells,21,16,nil,nil,nil,nil,nil,nil,true);
	for line=1,21 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(scrollframe)
		if lineplusoffset <= #sortedspells then
			buttons[line]:SetText(colors[selectedspelltable[sortedspells[lineplusoffset]]].hex.. sortedspells[lineplusoffset] .. "|r")
			if buttons[line]:GetText() ~= currentbutton then 
				buttons[line]:SetNormalTexture("") 
			else 
				buttons[line]:SetNormalTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
				buttons[line]:GetNormalTexture():SetBlendMode("ADD") 
			end
			buttons[line]:Show()
		else
			buttons[line]:Hide()
		end
	end
end

local function SpellAlerter_OnVerticalScroll(offset,itemHeight)
	local scrollbar = _G[scrollframe:GetName().."ScrollBar"]
	scrollbar:SetValue(offset);
	scrollframe.offset = floor((offset / itemHeight) + 0.5);
	SpellAlerter_UpdateScrollBar()
end

local function SpellAlerter_CreateListButton(parent,name)
	local button = CreateFrame("Button",parent:GetName()..name,parent)
	button:SetWidth(130)
	button:SetHeight(16)
	local font = CreateFont("SpellAlerterListFont")
	font:SetFont(GameFontNormal:GetFont(),12)
	font:SetJustifyH("left")
	button:SetTextFontObject(font)
	button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight","ADD")
	button:SetScript("OnClick",function(self) currentbutton = self:GetText(); SpellAlerter_UpdateScrollBar() end)
	return button
end

local function SpellAlerter_CreateColorDropdown(parent)
	local dropdown = SpellAlerter_CreateDropdown("Color",parent)
	function dropdown.OnClick()
		UIDropDownMenu_SetSelectedValue(dropdown, this.value)
	end
	local info = {}
	function dropdown.AddItem(text,value,func) 
		info.text = text
		info.value = value
		info.func = dropdown.OnClick
		info.owner = this:GetParent()
		info.checked = nil
		info.icon = nil
		UIDropDownMenu_AddButton(info,1)
	end
	function dropdown.Initialize()
		for i,t in ipairs(colors) do
			dropdown.AddItem(t.hex.."#".."|r",i,dropdown.OnClick)
		end
	end
	UIDropDownMenu_SetWidth(35, dropdown)
	UIDropDownMenu_SetButtonWidth(26, dropdown)
	UIDropDownMenu_Initialize(dropdown, dropdown.Initialize);
	UIDropDownMenu_SetSelectedValue(dropdown, 1)
	return dropdown
end

local function SpellAlerter_CreateSpellEditor(parent) -- 389, 240
	local panel = SpellAlerter_CreatePanel(parent,"Spell Casts",true)
	panel:SetWidth(183); panel:SetHeight(348)
	
	local tab1 = SpellAlerter_CreateTab(panel,"Tab1","Spell Casts")
	tab1:SetPoint("BOTTOMLEFT",panel,"TOPLEFT",0,4)
	local tab2 = SpellAlerter_CreateTab(panel,"Tab2","Enemy Buffs")
	tab2:SetPoint("LEFT",tab1,"RIGHT",-15,0)
	local tab3 = SpellAlerter_CreateTab(panel,"Tab3","Friendly Debuffs")
	tab3:SetPoint("LEFT",tab2,"RIGHT",-15,0)
	
	local LastTabRightSideSpacer = SpellAlerter_CreateSpacer(panel,104)
	LastTabRightSideSpacer:SetPoint("LEFT",tab3,"BOTTOMRIGHT",-10,2)
	local Tab1Tab2Spacer = SpellAlerter_CreateSpacer(panel,26)
	Tab1Tab2Spacer:SetPoint("LEFT",tab1,"BOTTOMRIGHT",-10,2)
	local Tab2Tab3Spacer = SpellAlerter_CreateSpacer(panel,26)
	Tab2Tab3Spacer:SetPoint("LEFT",tab2,"BOTTOMRIGHT",-10,2)
	local LeftSideFirstTabSpacer = SpellAlerter_CreateSpacer(panel,35)
	LeftSideFirstTabSpacer:SetPoint("RIGHT",tab1,"BOTTOMLEFT",12,2)
	
	PanelTemplates_SetNumTabs(panel,3)
	PanelTemplates_SetTab(panel,tab1)
	tab1:SetScript("OnClick",function()	PanelTemplates_SetTab(panel, 1); tab1.spacer:Hide(); tab2.spacer:Show(); tab3.spacer:Show(); selectedspelltab = 1; currentbutton = false; SpellAlerter_UpdateScrollBar() end)
	tab2:SetScript("OnClick",function() PanelTemplates_SetTab(panel, 2); tab1.spacer:Show(); tab2.spacer:Hide(); tab3.spacer:Show(); selectedspelltab = 2; currentbutton = false; SpellAlerter_UpdateScrollBar() end)
	tab3:SetScript("OnClick",function() PanelTemplates_SetTab(panel, 3); tab1.spacer:Show(); tab2.spacer:Show(); tab3.spacer:Hide(); selectedspelltab = 3; currentbutton = false; SpellAlerter_UpdateScrollBar() end)
	panel:SetScript("OnShow",function() PanelTemplates_SetTab(panel, 1); tab1.spacer:Hide(); tab2.spacer:Show(); tab3.spacer:Show(); selectedspelltab = 1; currentbutton = false; SpellAlerter_UpdateScrollBar() end)

	scrollframe = CreateFrame("ScrollFrame", panel:GetName().."ScrollFrame",panel,"FauxScrollFrameTemplate")
	local button1 = SpellAlerter_CreateListButton(scrollframe,"1")
	button1:SetPoint("TOPLEFT",scrollframe,"TOPLEFT",11,0)
	table.insert(buttons,button1)
	for i=2,21 do
		local button = SpellAlerter_CreateListButton(scrollframe,tostring(i))
		button:SetPoint("TOPLEFT",buttons[#buttons],"BOTTOMLEFT")
		table.insert(buttons,button)
	end
	
	scrollframe:SetWidth(150); scrollframe:SetHeight(338)
	scrollframe:SetPoint('TOPLEFT',0,-5)
	scrollframe:SetScript("OnVerticalScroll", function(self,offset) SpellAlerter_OnVerticalScroll(offset,16) end)
	scrollframe:SetScript("OnShow",function(self) SpellAlerter_UpdateScrollBar() end)
	
	local scrollbar = _G[scrollframe:GetName().."ScrollBar"]
	scrollbar:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile=nil,tile=true,tileSize=16,edgeSize=10,})
	scrollbar:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
	
	local addbutton = SpellAlerter_CreateButton("Add",panel)
	addbutton:SetHeight(25); addbutton:SetWidth(80)
	addbutton:SetPoint("TOPLEFT",panel,"TOPRIGHT",2,0)
	
	local addeditbox = SpellAlerter_CreateEditBox("AddEditBox",panel,120,25)
	addeditbox:SetPoint("TOPLEFT",addbutton,"BOTTOMLEFT",8,0)
	addeditbox:SetScript("OnShow",function(self) self:SetText("") end)
	
	local adddropdown = SpellAlerter_CreateColorDropdown(panel)
	adddropdown:SetPoint("LEFT",addeditbox,"RIGHT",-15,-2)
	
	local updatelist = function(spellname,colortype)
		if selectedspelltab == 1 then
			currentanchor.spellcasts[spellname] = colortype
		elseif selectedspelltab == 2 then
			currentanchor.enemybuffs[spellname] = colortype
		elseif selectedspelltab == 3 then
			currentanchor.friendlydebuffs[spellname] = colortype
		end
	end
	
	addbutton:SetScript("OnMouseDown", function(self,button)
		local spellname = addeditbox:GetText()  
		local colortype = UIDropDownMenu_GetSelectedValue(adddropdown)
		updatelist(spellname,colortype)
		SpellAlerter_UpdateScrollBar()
		addeditbox:SetText("")
	end)
	
	local removebutton = SpellAlerter_CreateButton("Delete", panel)
	removebutton:SetScript("OnMouseDown", function(self, button)
		if not currentbutton then return end
		local spellname = currentbutton:sub(11,#currentbutton-2)
		updatelist(spellname,nil)
		SpellAlerter_UpdateScrollBar()
		currentbutton = false
	end)
	
	removebutton:SetHeight(25); removebutton:SetWidth(80)
	removebutton:SetPoint("TOPLEFT",panel,"TOPRIGHT",2,-55)
	
	return panel
end

local function SpellAlerter_CreateAddRemoveAnchorsPanel(parent,anchorselector)
	local panel = SpellAlerter_CreatePanel(parent,"Add / Remove Anchors")
	panel:SetWidth(180); panel:SetHeight(70)
	
	local addbutton = SpellAlerter_CreateButton("Add",panel)
	addbutton:SetHeight(20); addbutton:SetWidth(40)
	addbutton:SetPoint("TOPLEFT",10,-10)
	
	local addeditbox = SpellAlerter_CreateEditBox("AddEditBox",panel,110,25)
	addeditbox:SetPoint("TOPLEFT",addbutton,"TOPRIGHT",8,3)
	addeditbox:SetScript("OnShow",function(self) self:SetText("") end)
	
	addbutton:SetScript("OnMouseDown", function(self,button)
		local anchorname = addeditbox:GetText()  
		if #anchorname == 0 then ChatFrame1:AddMessage("Spell Alerter: Invalid anchor name"); return end
		anchors[anchorname] = 1
		addeditbox:SetText("")
		UIDropDownMenu_Refresh(anchorselector,currentanchor.name)
	end)
	
	local removebutton = SpellAlerter_CreateButton("Remove",panel)
	removebutton:SetHeight(20); removebutton:SetWidth(65)
	removebutton:SetPoint("TOPLEFT",addbutton,"BOTTOMLEFT",0,-10)
	removebutton:SetScript("OnMouseDown", function(self)
		local len = 0
		for _ in pairs(anchors) do
			len = len + 1
		end
		if len == 1 then ChatFrame1:AddMessage("Spell Alerter: Can't have 0 anchors"); return end
		anchors[currentanchor.name] = nil
		SpellAlerterDB.anchors[currentanchor.name] = nil
		currentanchor:Hide()
		currentanchor = select(2,next(anchors,nil))
		UIDropDownMenu_Refresh(anchorselector,currentanchor.name)
		UIDropDownMenu_SetSelectedValue(anchorselector,currentanchor.name,currentanchor.name)
		parent:Hide()
		parent:Show()
	end)
	
	local removebuttontext = removebutton:CreateFontString(nil,"ARTWORK","GameFontNormal")
	removebuttontext:SetText("(Selected)")
	removebuttontext:SetPoint("LEFT",removebutton,"RIGHT",0,2)
	
	return panel
end

local function SpellAlerter_CreateAnchorSelector(parent)
	local anchorselector = SpellAlerter_CreateDropdown("Anchor Selector",parent)
	function anchorselector.OnClick()
		UIDropDownMenu_SetSelectedValue(anchorselector, this.value)
		currentanchor = anchors[this.value]
		parent:Hide()
		parent:Show()
	end
	local info = {}
	function anchorselector.AddItem(text,value,func) 
		info.text = text
		info.value = value
		info.func = func
		info.owner = this:GetParent()
		info.checked = nil
		info.icon = nil
		UIDropDownMenu_AddButton(info,1)
	end
	function anchorselector.Initialize()
		for name in pairs(anchors) do
			anchorselector.AddItem(name,name,anchorselector.OnClick)
		end
	end
	UIDropDownMenu_SetWidth(100, anchorselector)
	UIDropDownMenu_SetButtonWidth(100, anchorselector)
	UIDropDownMenu_Initialize(anchorselector, anchorselector.Initialize);
	UIDropDownMenu_SetSelectedValue(anchorselector, currentanchor.name)
	anchorselector:SetScript("OnShow",function() UIDropDownMenu_SetSelectedValue(anchorselector, currentanchor.name) end)
	return anchorselector
end

local function SpellAlerter_CreatePanelTab1Page(SAOptionsPanelTab1)
	local SAOptionsPanelTab1Page = CreateFrame("Frame",SAOptionsPanelTab1:GetName().."Page",SAOptionsPanelTab1)
	
	local AnchorSelector = SpellAlerter_CreateAnchorSelector(SAOptionsPanelTab1Page)
	AnchorSelector:SetPoint("TOPLEFT",SAOptionsPanelTab1,"BOTTOMLEFT",0,-15)
	
	local TestButton = SpellAlerter_CreateButton("Test",SAOptionsPanelTab1Page)
	TestButton:SetWidth(70); 
	TestButton:SetHeight(20)
	TestButton:SetPoint("LEFT", AnchorSelector, "RIGHT",0,2)
	TestButton:SetScript("OnClick",function(self,button) SpellAlerter_Test(currentanchor) end)
	
	local CurrentAnchorPanel = SpellAlerter_CreateCurrentAnchorPanel(SAOptionsPanelTab1Page)
	CurrentAnchorPanel:SetPoint("TOPLEFT",AnchorSelector,"BOTTOMLEFT",0,-15)
	
	local AddRemoveAnchorsPanel = SpellAlerter_CreateAddRemoveAnchorsPanel(SAOptionsPanelTab1Page,AnchorSelector)
	AddRemoveAnchorsPanel:SetPoint('TOPLEFT',CurrentAnchorPanel,'BOTTOMLEFT', 0, -13)
	
	return SAOptionsPanelTab1Page
end

local function SpellAlerter_AddPanelOptions()
	local SAOptionsPanel = CreateFrame("Frame","SpellAlerterOptionsPanel",UIParent)
	SAOptionsPanel.name = "Spell Alerter"
	
	local SAOptionsPanelTab1 = SpellAlerter_CreateTab(SAOptionsPanel,"Tab1","Anchors")
	SAOptionsPanelTab1:SetPoint("TOPLEFT",10,-2)
	local SAOptionsPanelTab2 = SpellAlerter_CreateTab(SAOptionsPanel,"Tab2","Spell List")
	SAOptionsPanelTab2:SetPoint("LEFT",SAOptionsPanelTab1,"RIGHT",-15,0)
	
	local SAOptionsPanelTab1Page = SpellAlerter_CreatePanelTab1Page(SAOptionsPanelTab1)
	

	local tab2page = CreateFrame("Frame",SAOptionsPanel:GetName().."Tab2Page",SAOptionsPanelTab2)
	local spelleditor = SpellAlerter_CreateSpellEditor(tab2page)
	spelleditor:SetPoint("TOPLEFT",SAOptionsPanelTab1,"BOTTOMLEFT",0,-31)
	
	local LastTabRightSideSpacer = SpellAlerter_CreateSpacer(SAOptionsPanel,241)
	LastTabRightSideSpacer:SetPoint("LEFT",SAOptionsPanelTab2,"BOTTOMRIGHT",-10,2)
	local Tab1Tab2Spacer = SpellAlerter_CreateSpacer(SAOptionsPanel,26)
	Tab1Tab2Spacer:SetPoint("LEFT",SAOptionsPanelTab1,"BOTTOMRIGHT",-10,2)
	local LeftSideFirstTabSpacer = SpellAlerter_CreateSpacer(SAOptionsPanel,35)
	LeftSideFirstTabSpacer:SetPoint("RIGHT",SAOptionsPanelTab1,"BOTTOMLEFT",12,2)
	
	PanelTemplates_SetNumTabs(SAOptionsPanel,2)
	PanelTemplates_SetTab(SAOptionsPanel,SAOptionsPanelTab1)
	SAOptionsPanelTab1:SetScript("OnClick",function()	
		PanelTemplates_SetTab(SAOptionsPanel, 1); 
		SAOptionsPanelTab1.spacer:Hide(); 
		SAOptionsPanelTab1Page:Show(); 
		tab2page:Hide(); 
		SAOptionsPanelTab2.spacer:Show() 
	end)
	SAOptionsPanelTab2:SetScript("OnClick",function() 
		PanelTemplates_SetTab(SAOptionsPanel, 2); 
		SAOptionsPanelTab2.spacer:Hide(); 
		tab2page:Show(); 
		SAOptionsPanelTab1Page:Hide(); 
		SAOptionsPanelTab1.spacer:Show() 
	end)
	SAOptionsPanel:SetScript("OnShow",function() 
		PanelTemplates_SetTab(SAOptionsPanel, 1); 
		SAOptionsPanelTab1.spacer:Hide(); 
		SAOptionsPanelTab1Page:Show(); 
		tab2page:Hide(); 
		SAOptionsPanelTab2.spacer:Show() 
	end)
	InterfaceOptions_AddCategory(SAOptionsPanel)
end

---------------------------------------------
-- Anchors
---------------------------------------------

local function SpellAlerter_GetNewAnchorSettings()
	return { 
		settings = SpellAlerter_GetDefaultSettings(), 
		spellcasts = {}, 
		enemybuffs = {}, 
		friendlydebuffs = {} 
	}
end

local function SpellAlerter_AddAnchors()
	for name,lists in pairs(SpellAlerterDB.anchors) do
		anchors[name] = lists
	end
	if anchors.Default then
		currentanchor = anchors.Default
	else
		currentanchor = select(2,next(anchors,nil))
	end
end

function SpellAlerter_Command()
	InterfaceOptionsFrame_OpenToFrame(_G["SpellAlerterOptionsPanel"]);
end

local function SpellAlerter_CreateAnchor(name,list)
	if not SpellAlerterDB.anchors[name] then SpellAlerterDB.anchors[name] = list end
	local anchor = SpellAlerter_CreateFrame(name)

	for listName,spells in pairs(list) do
		anchor[listName] = spells
	end
	SpellAlerter_UpdateAnchorSettings(anchor)
	return anchor
end

local function SpellAlerter_OnLoad(self)
	local ver = GetAddOnMetadata("SpellAlerter","version")
	if ver ~= SpellAlerterDB.version then
		SpellAlerterDB = { anchors = {}, version = ver }
	end
	
	setmetatable(anchors,{
		__newindex = function(t,k,v)
			if v == 1 then
				if SpellAlerterDB.anchors[k] then ChatFrame1:AddMessage("Spell Alerter: Anchor already exists"); return end
					v = SpellAlerter_GetNewAnchorSettings()
				end
			rawset(t,k,SpellAlerter_CreateAnchor(k,v))
		end,
	})
	
	local len = 0
	for _ in pairs(SpellAlerterDB.anchors) do
		len = len + 1
	end
	if len == 0 then
		SpellAlerterDB.anchors.Default = {
	 		settings = SpellAlerter_GetDefaultSettings(),
	 		spellcasts = defaultSpellcasts,
	 		enemybuffs = defaultEnemyBuffs,
	 		friendlydebuffs = defaultFriendlyDebuffs,
		}
	end
	
	SpellAlerter_AddAnchors()
	
	SpellAlerter_AddPanelOptions()
	
	self:UnregisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:SetScript("OnEvent",SpellAlerter_COMBAT_LOG_EVENT_UNFILTERED)
	SlashCmdList["SpellAlerter"] = SpellAlerter_Command
 	SLASH_SpellAlerter1 = "/sa"
 	SLASH_SpellAlerter2 = "/spellalerter"

 	ChatFrame1:AddMessage("Spell Alerter by Kollektiv. Type /sa or /spellalerter for options",0,1,0)
end

SpellAlerterFrame = CreateFrame("Frame",nil,UIParent)
SpellAlerterFrame:RegisterEvent("VARIABLES_LOADED")
SpellAlerterFrame:SetScript("OnEvent",SpellAlerter_OnLoad)