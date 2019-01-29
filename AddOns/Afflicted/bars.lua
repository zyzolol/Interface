if( not Afflicted ) then return end

local Bars = Afflicted:NewModule("Bars", "AceEvent-3.0")
local methods = {"CreateDisplay", "ClearTimers", "CreateTimer", "RemoveTimer", "RemoveCooldownTimer", "ReloadVisual", "UnitDied"}
local SML, GTBLib
local barData = {}
local nameToType = {}
local savedGroups = {}

-- PUBLIC METHODS
-- Create our main display frame
local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 0.80,
		insets = {left = 1, right = 1, top = 1, bottom = 1}}

function Bars:CreateDisplay(type)
	local anchorData = Afflicted.db.profile.anchors[type]
	nameToType[string.format("Afflicted (%s)", anchorData.text)] = type
	
	local group = GTBLib:RegisterGroup(string.format("Afflicted (%s)", anchorData.text), SML:Fetch(SML.MediaType.STATUSBAR, Afflicted.db.profile.barName))
	group:RegisterOnFade(Bars, "OnBarFade")
	group:RegisterOnMove(Bars, "OnBarMove")
	group:SetScale(anchorData.scale)
	group:SetWidth(Afflicted.db.profile.barWidth)
	group:SetAnchorVisible(Afflicted.db.profile.showAnchors)
	group:SetDisplayGroup(anchorData.redirectTo ~= "" and anchorData.redirectTo or nil)
	group:SetBarGrowth(anchorData.growUp and "UP" or "DOWN")
	group:SetMaxBars(anchorData.maxRows)

	if( anchorData.position ) then
		group:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", anchorData.position.x, anchorData.position.y)
	end
	
	return group
end

function Bars:OnBarMove(parent, x, y)
	if( not Afflicted.db.profile.anchors[nameToType[parent.name]].position ) then
		Afflicted.db.profile.anchors[nameToType[parent.name]].position = {}
	end

	Afflicted.db.profile.anchors[nameToType[parent.name]].position.x = x
	Afflicted.db.profile.anchors[nameToType[parent.name]].position.y = y
end

function Bars:TextureRegistered(event, mediaType, key)
	if( mediaType == SML.MediaType.STATUSBAR and Afflicted.db.profile.barName == key ) then
		for id, group in pairs(Bars.groups) do
			group:SetTexture(SML:Fetch(SML.MediaType.STATUSBAR, Afflicted.db.profile.barName))
		end
	end
end

-- Return an object to access our visual style
function Bars:LoadVisual()
	if( not GTBLib ) then
		SML = Afflicted.SML
		SML.RegisterCallback(Bars, "LibSharedMedia_Registered", "TextureRegistered")
		
		GTBLib = LibStub:GetLibrary("GTB-1.0")
		self.GTB = GTBLib
	end

	local obj = {}
	for _, func in pairs(methods) do
		obj[func] = self[func]
	end
	
	-- Create anchors
	Bars.groups = {}
	for name, data in pairs(Afflicted.db.profile.anchors) do
		if( data.enabled and data.displayType == "bar" ) then
			Bars.groups[name] = Bars:CreateDisplay(name)
		end
	end
	
	return obj
end

-- Clear all running timers for this anchor type
function Bars:ClearTimers(type)
	if( Bars.groups[type] ) then
		Bars.groups[type]:UnregisterAllBars()
	end
end

-- Unit died, removed their timers
function Bars:UnitDied(diedGUID)
	for id in pairs(barData) do
		local spellID, sourceGUID, destGUID = string.split(":", id)
		if( destGUID == diedGUID or sourceGUID == diedGUID ) then
			for _, group in pairs(Bars.groups) do
				group:UnregisterBar(id)
			end
		end
	end
end

-- Create a new timer
function Bars:CreateTimer(spellData, eventType, spellID, spellName, sourceGUID, sourceName, destGUID)
	local group = Bars.groups[spellData.showIn]
	if( not group ) then
		return
	end
		
	local id = string.format("%s:%s:%s", spellID, sourceGUID, destGUID)
	local text = spellName

	if( Afflicted.db.profile.barNameOnly and sourceName ~= "" ) then
		text = sourceName
	elseif( sourceName ~= "" ) then
		text = string.format("%s - %s", spellName, sourceName)
	else
		text = spellName
	end

	
	-- We can only pass one argument, so we do this to prevent creating and dumping tables and such
	local data = string.format("%s,%s,%s,%s,%s", eventType, spellID, spellName, sourceGUID, sourceName)
	barData[id] = data
	barData[spellName .. sourceGUID] = true

	group:RegisterBar(id, text, Afflicted:GetSpellDuration(sourceGUID, spellName, spellID, spellData.seconds), nil, spellData.icon)
	group:SetRepeatingTimer(id, spellData.repeating or false)
	
	-- Start a cooldown timer
	if( spellData.cdEnabled and spellData.cooldown > 0 ) then
		local group = Bars.groups[spellData.cdInside]
		if( not group ) then
			return
		end

		local id = id .. ":CD"
		local cd = ""
		local text
		
		barData[id] = data .. ",cd"
		
		-- If the timer is being redirected to another anchor, show the CD text
		if( Afflicted.db.profile.anchors[spellData.cdInside].redirectTo ~= "" ) then
			cd = "[CD] "
		end
		
		if( Afflicted.db.profile.barNameOnly and sourceName ~= "" ) then
			text = string.format("%s%s", cd, sourceName)
		elseif( sourceName ~= "" ) then
			text = string.format("%s%s - %s", cd, spellName, sourceName)
		else
			text = string.format("%s%s", cd, spellName)
		end

		group:RegisterBar(id, text, spellData.cooldown, nil, spellData.icon)
	end
end

-- Bar timer ran out
function Bars:OnBarFade(barID)
	local eventType, spellID, spellName, sourceGUID, sourceName, type = string.split(",", barData[barID])
	barData[barID] = nil
	
	if( not type ) then
		Afflicted:AbilityEnded(eventType, tonumber(spellID), spellName, sourceGUID, sourceName)
		barData[spellName .. sourceGUID] = nil
	else
		Afflicted:CooldownEnded(eventType, tonumber(spellID), spellName, sourceGUID, sourceName)
	end
end

-- Remove a specific anchors timer by spellID/sourceGUID
function Bars:RemoveTimer(anchorName, spellID, sourceGUID)
	local group = Bars.groups[anchorName]
	if( not group ) then
		return nil
	end
	
	for id in pairs(barData) do
		local sID, guid, _, isCooldown = string.split(":", id)
		if( guid == sourceGUID and tonumber(sID) == spellID and not isCooldown ) then
			return group:UnregisterBar(id)
		end
	end
end

-- Removes a cooldown timer
function Bars:RemoveCooldownTimer(spellID, sourceGUID, anchorName)
	local group = Bars.groups[anchorName]
	if( not group ) then
		return nil
	end
	
	for id, groupName in pairs(barData) do
 		local sID, guid, _, isCooldown = string.split(":", id)
		if( guid == sourceGUID and tonumber(sID) == spellID and isCooldown ) then
			return group:UnregisterBar(id)
		end
	end	
end

function Bars:ReloadVisual()
	for name, data in pairs(Afflicted.db.profile.anchors) do
		-- Had a bad anchor that was either enabled recently, or it used to be an icon anchor
		if( data.enabled and data.displayType == "bar" and not Bars.groups[name] ) then
			Bars.groups[name] = savedGroups[name] or Bars:CreateDisplay(name)
			savedGroups[name] = nil
		
		-- Had a bar anchor that was either disabled recently, or it's not a bar anchor anymore
		elseif( ( not data.enabled or data.displayType ~= "bar" ) and Bars.groups[name] ) then
			savedGroups[name] = Bars.groups[name]
			
			Bars.groups[name]:SetAnchorVisible(false)
			Bars.groups[name]:UnregisterAllBars()
			Bars.groups[name] = nil
		end
	end

	-- Update!
	for _, group in pairs(Bars.groups) do
		local data = Afflicted.db.profile.anchors[nameToType[group.name]]
		group:SetScale(data.scale)
		group:SetDisplayGroup(data.redirectTo ~= "" and data.redirectTo or nil)
		group:SetBarGrowth(data.growUp and "UP" or "DOWN")
		group:SetWidth(Afflicted.db.profile.barWidth)
		group:SetAnchorVisible(Afflicted.db.profile.showAnchors)
		group:SetMaxBars(data.maxRows)
	end
end