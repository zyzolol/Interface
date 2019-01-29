if( not Afflicted ) then return end

local Icons = Afflicted:NewModule("Icons", "AceEvent-3.0")

local ICON_SIZE = 20
local POSITION_SIZE = ICON_SIZE + 2
local methods = {"CreateDisplay", "ClearTimers", "CreateTimer", "RemoveTimer", "RemoveCooldownTimer", "UnitDied", "ReloadVisual"}
local savedGroups = {}
local inactiveIcons = {}

function Icons:OnInitialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

-- Reposition the passed groups timers
local function repositionTimers(group)
	local data = Afflicted.db.profile.anchors[group.type]
	
	-- Reposition everything
	for id, icon in pairs(group.active) do
		if( id > 1 ) then
			icon:ClearAllPoints()
			if( not data.growUp ) then
				icon:SetPoint("TOPLEFT", group.active[id - 1], "BOTTOMLEFT", 0, 0)
			else
				icon:SetPoint("BOTTOMLEFT", group.active[id - 1], "TOPLEFT", 0, 0)
			end
		
		elseif( data.growUp ) then
			icon:ClearAllPoints()
			icon:SetPoint("BOTTOMLEFT", group, "TOPLEFT", 0, 0)
		else
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", group, "BOTTOMLEFT", 0, 0)
		end
		
		if( id <= data.maxRows ) then
			icon:Show()
		else
			icon:Hide()
		end
	end
end

-- Create our little icon
local function createRow()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetWidth(50)
	frame:SetHeight(ICON_SIZE)
	frame:SetClampedToScreen(true)
	frame:Hide()
	
	frame.icon = frame:CreateTexture(nil, "BACKGROUND")
	frame.icon:SetWidth(ICON_SIZE)
	frame.icon:SetHeight(ICON_SIZE)
	frame.icon:SetPoint("LEFT")
	
	frame.text = frame:CreateFontString(nil, "BACKGROUND")
	frame.text:SetFontObject(GameFontHighlight)
	frame.text:SetPoint("LEFT", ICON_SIZE + 2, 0)
	
	return frame
end

-- Handle grabbing/releasing icons for everything
local function releaseIcon(group, id)
	local icon = table.remove(group.active, id)
	icon:SetScript("OnUpdate", nil)
	icon:Hide()
	
	table.insert(inactiveIcons, icon)
end

local function getIcon(group)
	local icon = table.remove(inactiveIcons, 1)
	if( not icon ) then
		icon = createRow()
	end
	
	table.insert(group.active, icon)
	return icon
end

-- Sort timers by time left
local function sortTimers(a, b)
	return a.endTime < b.endTime
end


-- Dragging functions
local function OnDragStart(self)
	if( IsAltKeyDown() ) then
		self.isMoving = true
		self:StartMoving()
	end
end

local function OnDragStop(self)
	if( self.isMoving ) then
		self.isMoving = nil
		self:StopMovingOrSizing()
		
		if( not Afflicted.db.profile.anchors[self.type].position ) then
			Afflicted.db.profile.anchors[self.type].position = {}
		end
		
		local scale = self:GetEffectiveScale()
		Afflicted.db.profile.anchors[self.type].position.x = self:GetLeft() * scale
		Afflicted.db.profile.anchors[self.type].position.y = self:GetTop() * scale
	end
end

local function OnShow(self)
	local position = Afflicted.db.profile.anchors[self.type].position
	if( position ) then
		local scale = self:GetEffectiveScale()
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", position.x / scale, position.y / scale)
	else
		self:ClearAllPoints()
		self:SetPoint("CENTER", UIParent, "CENTER")
	end
end

-- Update icon timer
local function OnUpdate(self, elapsed)
	local time = GetTime()
	self.timeLeft = self.timeLeft - (time - self.lastUpdate)
	self.lastUpdate = time
	
	if( self.timeLeft <= 0 ) then
		-- Check if we should start the timer again
		if( self.repeating ) then
			self.timeLeft = self.startSeconds
			self.lastUpdate = time
			
			local anchor = Icons.groups[self.type]
			table.sort(anchor.active, sortTimers)
			repositionTimers(anchor)
			return
		end

		if( not self.isCooldown ) then
			Afflicted:AbilityEnded(self.eventType, self.spellID, self.spellName, self.sourceGUID, self.sourceName)
		else
			Afflicted:CooldownEnded(self.eventType, self.spellID, self.spellName, self.sourceGUID, self.sourceName)
		end

		local group = Icons.groups[self.type]
		for id, row in pairs(group.active) do
			if( row.id == self.id ) then
				releaseIcon(group, id)
				repositionTimers(group)
				break
			end
		end
			
		return
	end
	
	if( self.timeLeft > 60 ) then
		self.text:SetFormattedText("%dm", self.timeLeft / 60)

	elseif( self.timeLeft > 10 ) then
		self.text:SetFormattedText("%d", self.timeLeft)
	else
		self.text:SetFormattedText("%.1f", self.timeLeft)
	end
end


local function showTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetText(AfflictedLocals["ALT + Drag to move the frame anchor."], nil, nil, nil, nil, 1)
end

local function hideTooltip(self)
	GameTooltip:Hide()
end

-- PUBLIC METHODS
-- Create our main display frame
local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 0.80,
		insets = {left = 1, right = 1, top = 1, bottom = 1}}

function Icons:CreateDisplay(type)
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetWidth(120)
	frame:SetHeight(12)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScale(Afflicted.db.profile.anchors[type].scale)
	frame:SetBackdrop(backdrop)
	frame:SetBackdropColor(0, 0, 0, 1.0)
	frame:SetBackdropBorderColor(0.75, 0.75, 0.75, 1.0)
	frame:SetScript("OnDragStart", OnDragStart)
	frame:SetScript("OnDragStop", OnDragStop)
	frame:SetScript("OnShow", OnShow)
	frame:SetScript("OnEnter", showTooltip)
	frame:SetScript("OnLeave", hideTooltip)
	frame.active = {}
	frame.type = type
	
	-- Display name
	frame.text = frame:CreateFontString(nil, "OVERLAY")
	frame.text:SetPoint("CENTER", frame)
	frame.text:SetFontObject(GameFontHighlight)
	frame.text:SetText(Afflicted.db.profile.anchors[type].text)

	if( Afflicted.db.profile.showAnchors ) then
		frame:EnableMouse(true)
		frame:SetAlpha(1)
	else
		frame:EnableMouse(false)
		frame:SetAlpha(0)
	end
	
	return frame
end

-- Return an object to access our visual style
function Icons:LoadVisual()
	local obj = {}
	for _, func in pairs(methods) do
		obj[func] = Icons[func]
	end
	
	-- Create anchors
	Icons.groups = {}
	for name, data in pairs(Afflicted.db.profile.anchors) do
		if( data.enabled and data.displayType == "icon" ) then
			Icons.groups[name] = Icons:CreateDisplay(name)
		end
	end
	
	return obj
end

-- Clear all running timers for this anchor type
function Icons:ClearTimers(type)
	local group = Icons.groups[type]
	if( not group ) then
		return
	end
	
	for i=#(group.active), 1, -1 do
		releaseIcon(group, i)
	end
end

-- Unit died, remove their timers
function Icons:UnitDied(destGUID)
	-- Loop through all created anchors
	for name, group in pairs(Icons.groups) do
		if( group and #(group.active) > 0 ) then
			-- Now through all active timers
			for i=#(group.active), 1, -1 do
				local row = group.active[i]

				if( ( row.sourceGUID == destGUID or row.destGUID == destGUID ) and not row.dontFade and not row.isCooldown ) then
					releaseIcon(group, i)
				end
			end

			-- Reposition everything
			repositionTimers(group)
		end
	end
end

-- Create a new timer
local function createTimer(id, showIn, eventType, repeating, spellID, spellName, sourceGUID, sourceName, destGUID, icon, seconds, isCooldown)
	local group = Icons.groups[showIn]
	if( not group ) then
		return
	end	
		
	-- Grabby
	local frame = getIcon(group)
	
	-- Set it for when it fades
	frame.id = id
	frame.eventType = eventType
	frame.repeating = repeating
	frame.isCooldown = isCooldown
	
	frame.spellID = spellID
	frame.spellName = spellName

	frame.sourceGUID = sourceGUID
	frame.sourceName = sourceName
	frame.destGUID = destGUID

	frame.startSeconds = seconds
	frame.timeLeft = seconds
	frame.lastUpdate = GetTime()
	frame.endTime = GetTime() + seconds

	frame.type = group.type
	frame.icon:SetTexture(icon)
	frame:SetScript("OnUpdate", OnUpdate)
	frame:SetScale(Afflicted.db.profile.anchors[group.type].scale)
	
	-- Reposition
	repositionTimers(group)
end

function Icons:CreateTimer(spellData, eventType, spellID, spellName, sourceGUID, sourceName, destGUID)
	local id = string.format("%s:%s:%s", spellID, sourceGUID, destGUID)
	createTimer(id, spellData.showIn, eventType, spellData.repeating, spellID, spellName, sourceGUID, sourceName, destGUID, spellData.icon, Afflicted:GetSpellDuration(sourceGUID, spellName, spellID, spellData.seconds))
	
	if( spellData.cdEnabled and spellData.cooldown > 0 ) then
		id = id .. ":CD"
		createTimer(id, spellData.cdInside, eventType, false, spellID, spellName, sourceGUID, sourceName, destGUID, spellData.icon, spellData.cooldown, true)
	end
end

-- Remove a specific anchors timer by spellID/sourceGUID
function Icons:RemoveTimer(anchorName, spellID, sourceGUID)
	local group = Icons.groups[anchorName]
	if( not group ) then
		return nil
	end
	
	-- Remove the icon timer
	local total = #(group.active)
	for i=#(group.active), 1, -1 do
		local row = group.active[i]
		local sID, guid, _, isCooldown = string.split(":", row.id)
		if( not isCooldown and guid == sourceGUID and tonumber(sID) == spellID ) then
			releaseIcon(group, i)
		end
	end
	
	-- Didn't remove anything, nothing to change
	if( total == #(group.active) ) then
		return nil
	end
	
	-- Reposition everything
	repositionTimers(group)
	return true
end

-- Removes a cooldown timer
function Icons:RemoveCooldownTimer(spellID, sourceGUID, anchorName)
	local group = Icons.groups[anchorName]
	if( not group ) then
		return nil
	end
	
	-- Remove the icon timer
	local total = #(group.active)
	for i=#(group.active), 1, -1 do
		local row = group.active[i]
		local sID, guid, _, isCooldown = string.split(":", row.id)
		if( isCooldown and guid == sourceGUID and tonumber(sID) == spellID ) then
			releaseIcon(group, i)
		end
	end
	
	-- Didn't remove anything, nothing to change
	if( total == #(group.active) ) then
		return nil
	end
	
	-- Reposition everything
	repositionTimers(group)
	return true
end

function Icons:ReloadVisual()
	for name, data in pairs(Afflicted.db.profile.anchors) do
		-- Had a bad anchor that was either enabled recently, or it used to be a bar anchor
		if( data.enabled and data.displayType == "icon" and not Icons.groups[name] ) then
			Icons.groups[name] = savedGroups[name] or Icons:CreateDisplay(name)
			savedGroups[name] = nil
		
		-- Had a bar anchor that was either disabled recently, or it's not an icon anchor anymore
		elseif( ( not data.enabled or data.displayType ~= "icon" ) and Icons.groups[name] ) then
			savedGroups[name] = Icons.groups[name]
			
			Icons:ClearTimers(name)
			Icons.groups[name]:SetAlpha(0)
			Icons.groups[name]:EnableMouse(false)
			Icons.groups[name] = nil
		end
	end

	-- Update anchors and icons inside
	for name, group in pairs(Icons.groups) do
		local data = Afflicted.db.profile.anchors[name]
		
		-- Update group scale
		group:SetScale(data.scale)

		-- Update icon scale
		for _, group in pairs(group.active) do
			group:SetScale(data.scale)
		end

		-- Annnd make sure it's shown or hidden
		if( Afflicted.db.profile.showAnchors ) then
			group:SetAlpha(1)
			group:EnableMouse(true)
		else
			group:SetAlpha(0)
			group:EnableMouse(false)
		end
		
		-- Reposition
		OnShow(group)
	end
end


-- We delay this until PEW to fix UIScale issues
function Icons:PLAYER_ENTERING_WORLD()
	if( Icons.groups ) then
		for _, group in pairs(Icons.groups) do
			OnShow(group)
		end
	end
	
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end