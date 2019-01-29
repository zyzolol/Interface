--[[ 
	Afflicted, Mayen/Amarand/Dayliss from Icecrown (US) PvE
]]

Afflicted = LibStub("AceAddon-3.0"):NewAddon("Afflicted", "AceEvent-3.0")

local L = AfflictedLocals

local instanceType, currentBracket

local objectsSummoned = {}

function Afflicted:OnInitialize()
	if( not self.modules.Config ) then
		return
	end
		
	self.SML = LibStub:GetLibrary("LibSharedMedia-3.0")
	self.revision = tonumber(string.match("$Revision: 939 $", "(%d+)") or 1)
	self.modules.Config:SetupDB()
	
	-- Something went wrong, pretty much debug code
	if( not self.modules.Icons or not self.modules.Bars ) then
		self:UnregisterAllEvents()
		return
	end
	
	-- Setup our visual style
	self.icon = self.modules.Icons:LoadVisual()
	self.bar = self.modules.Bars:LoadVisual()
		
	-- Monitor for zone change
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA")

	-- Quick check
	self:ZONE_CHANGED_NEW_AREA()

	-- Middle of screen alert frame
	self.alertFrame = CreateFrame("MessageFrame", nil, UIParent)
	self.alertFrame:SetInsertMode("TOP")
	self.alertFrame:SetFrameStrata("HIGH")
	self.alertFrame:SetWidth(UIParent:GetWidth())
	self.alertFrame:SetHeight(60)
	self.alertFrame:SetFadeDuration(0.5)
	self.alertFrame:SetTimeVisible(2)
	self.alertFrame:SetFont((GameFontNormal:GetFont()), 20, "OUTLINE")
	self.alertFrame:SetPoint("CENTER", 0, 60)
end

function Afflicted:Enable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function Afflicted:Disable()
	self:UnregisterAllEvents()
	
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA")
end

function Afflicted:Reload()
	self:Disable()
	if( self.db.profile.inside[select(2, IsInInstance())] ) then
		self:Enable()
	end

	self.icon:ReloadVisual()
	self.bar:ReloadVisual()
end

local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE
local COMBATLOG_OBJECT_AFFILIATION_PARTY = COMBATLOG_OBJECT_AFFILIATION_PARTY
local COMBATLOG_OBJECT_AFFILIATION_RAID = COMBATLOG_OBJECT_AFFILIATION_RAID
local COMBATLOG_OBJECT_REACTION_HOSTILE	= COMBATLOG_OBJECT_REACTION_HOSTILE
local GROUP_AFFILIATION = bit.bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID, COMBATLOG_OBJECT_AFFILIATION_MINE)

local eventRegistered = {["SPELL_INTERRUPT"] = true, ["SPELL_CAST_SUCCESS"] = true, ["SPELL_AURA_APPLIED"] = true, ["SPELL_AURA_REMOVED"] = true, ["SPELL_SUMMON"] = true, ["SPELL_CREATE"] = true, ["SPELL_DISPEL_FAILED"] = true, ["SPELL_PERIODIC_DISPEL_FAILED"] = true, ["SPELL_DISPEL"] = true, ["SPELL_STOLEN"] = true, ["PARTY_KILL"] = true, ["UNIT_DIED"] = true}
function Afflicted:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	if( not eventRegistered[eventType] ) then
		return
	end
	
	local isDestEnemy = (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE)
	local isSourceEnemy = (bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE)
		
	-- Enemy gained a debuff
	if( eventType == "SPELL_AURA_APPLIED" and isDestEnemy ) then
		local spellID, spellName, spellSchool, auraType = ...
		self:ProcessAbility(string.format("%s%sENEMY", eventType, auraType), spellID, spellName, spellSchool, destGUID, destName, destGUID, destName)
		
	-- Buff or debuff faded from an enemy
	elseif( eventType == "SPELL_AURA_REMOVED" and isDestEnemy ) then
		local spellID, spellName, spellSchool, auraType = ...
		self:ProcessEnd(string.format("%s%sENEMY", eventType, auraType), spellID, spellName, destGUID, destName)

	-- Spell casted succesfully
	elseif( eventType == "SPELL_CAST_SUCCESS" and isSourceEnemy ) then
		local spellID, spellName, spellSchool, auraType = ...
		if( self.resetSpells[spellID] ) then
			self:ProcessReset(spellID, spellName, sourceGUID, sourceName)
		end

		self:ProcessAbility(eventType, spellID, spellName, spellSchool, sourceGUID, sourceName, destGUID, destName)
		
	-- Check for something being summoned (Pets, totems)
	elseif( eventType == "SPELL_SUMMON" and isSourceEnemy ) then
		local spellID, spellName, spellSchool = ...
		
		-- Fixes an issue with totems not being removed when they get redropped
		local id = sourceGUID .. spellID
		if( objectsSummoned[id] ) then
			self.icon:UnitDied(objectsSummoned[id])
			self.bar:UnitDied(objectsSummoned[id])
		end
		
		objectsSummoned[id] = destGUID

		self:ProcessAbility(eventType, spellID, spellName, spellSchool, sourceGUID, sourceName, destGUID, destName)
		
	-- Check for something being created (Traps, ect)
	elseif( eventType == "SPELL_CREATE" and isSourceEnemy ) then
		local spellID, spellName, spellSchool = ...
		self:ProcessAbility(eventType, spellID, spellName, spellSchool, sourceGUID, sourceName, destGUID, destName)
	
	-- We got interrupted, or we interrupted someone else
	elseif( eventType == "SPELL_INTERRUPT" and self.db.profile.interruptEnabled and isDestEnemy and bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == COMBATLOG_OBJECT_AFFILIATION_MINE ) then
		local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSpellSchool = ...
		
		-- Local output, use a shorttened version, because we already know who we interrupted (Or, hope we do)
		if( self.db.profile.interruptDest == "ct" or tonumber(self.db.profile.interruptDest) ) then
			self:SendMessage(string.format(L["Interrupted %s"], extraSpellName), self.db.profile.interruptDest, self.db.profile.interruptColor, extraSpellID)
		else
			self:SendMessage(string.format(L["Interrupted %s's %s"], self:StripServer(destName), extraSpellName), self.db.profile.interruptDest, self.db.profile.interruptColor, extraSpellID)
		end
		
		
	-- We tried to dispel a buff, and failed
	elseif( ( eventType == "SPELL_DISPEL_FAILED" or eventType == "SPELL_PERIODIC_DISPEL_FAILED" ) and self.db.profile.dispelEnabled ) then
		local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSpellSchool, auraType = ...
		
		if( not isDestEnemy or ( isDestEnemy and self.db.profile.dispelHostile ) ) then
			if( bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == COMBATLOG_OBJECT_AFFILIATION_MINE ) then
				self:SendMessage(string.format(L["FAILED %s's %s"], self:StripServer(destName), extraSpellName), self.db.profile.dispelDest, self.db.profile.dispelColor, extraSpellID)
			end
		end
			
	-- Managed to dispel or steal a buff
	elseif( ( eventType == "SPELL_DISPEL" or eventType == "SPELL_STOLEN" ) and self.db.profile.dispelEnabled ) then
		local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSpellSchool, auraType = ...
		
		if( not isDestEnemy or ( isDestEnemy and self.db.profile.dispelHostile ) ) then
			if( bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == COMBATLOG_OBJECT_AFFILIATION_MINE ) then
				self:SendMessage(string.format(L["Removed %s's %s"], self:StripServer(destName), extraSpellName), self.db.profile.dispelDest, self.db.profile.dispelColor, extraSpellID)
			end
		end
	
	-- Check if we should clear timers
	elseif( eventType == "PARTY_KILL" and isDestEnemy ) then
		self.icon:UnitDied(destGUID)
		self.bar:UnitDied(destGUID)

	-- Don't use UNIT_DIED inside arenas due to accuracy issues, outside of arenas we don't care too much
	elseif( instanceType ~= "arena" and eventType == "UNIT_DIED" and isDestEnemy ) then
		self.icon:UnitDied(destGUID)
		self.bar:UnitDied(destGUID)
	end
end

-- See if we should enable Afflicted in this zone
function Afflicted:ZONE_CHANGED_NEW_AREA()
	local type = select(2, IsInInstance())

	if( type ~= instanceType ) then
		-- Clear anchors because we changed zones
		for name, data in pairs(self.db.profile.anchors) do
			self[data.displayType]:ClearTimers(name)
		end
		
		-- Check if it's supposed to be enabled in this zone
		if( self.db.profile.inside[type] ) then
			if( type == "arena" ) then
				for i=1, MAX_BATTLEFIELD_QUEUES do
					local status, _, _, _, _, teamSize = GetBattlefieldStatus(i)
					if( status == "active" and teamSize > 0 ) then
						currentBracket = teamSize
					end
				end
			end
			
			self:Enable()
		else
			currentBracket = nil
			self:Disable()
		end
	end
		
	instanceType = type
end

local function getSpellData(spellID, spellName)
	local data = Afflicted.db.profile.spells[spellID] or Afflicted.db.profile.spells[spellName]
	if( type(data) == "number" ) then
		data = Afflicted.db.profile.spells[data]
	end
	
	return data
end

-- This lets me modify the duration of spells without having to mess with the variable, mostly for WoTLK
function Afflicted:GetSpellDuration(sourceGUID, spellName, spellID, seconds)
	return seconds
end

-- New ability found
function Afflicted:ProcessAbility(eventType, spellID, spellName, spellSchool, sourceGUID, sourceName, destGUID, destName)
	local spellData = getSpellData(spellID, spellName)
	if( not spellData or spellData.disabled or not spellData[eventType] or ( currentBracket and self.db.profile.disabledSpells[currentBracket][spellID] ) ) then
		return
	end
		
	-- Check if it matches our target/focus only
	if( self.db.profile.showTarget and UnitGUID("target") ~= sourceGUID and UnitGUID("focus") ~= sourceGUID ) then
		return
	end
	
	local anchor = self.db.profile.anchors[spellData.showIn]
	if( not anchor or not anchor.enabled ) then
		return
	end

	
	-- No icon listed, use our own
	local icon = select(3, GetSpellInfo(spellID))
	if( spellData.dontSave or not spellData.icon or spellData.icon == "" ) then
		spellData.icon = icon
	end
		
	-- Start it up
	self[anchor.displayType]:CreateTimer(spellData, eventType, spellID, spellName, sourceGUID, sourceName, destGUID)

	-- Announce it
	-- Work out if we should use a custom message, or a default one
	local msg
	if( spellData.enableCustom ) then
		msg = spellData.triggeredMessage
	elseif( anchor.announce ) then
		msg = anchor.usedMessage
	end	

	if( not msg or msg == "" ) then
		return
	end

	msg = string.gsub(msg, "*spell", spellName)
	msg = string.gsub(msg, "*target", self:StripServer(sourceName))

	self:SendMessage(msg, anchor.announceDest, anchor.announceColor, spellID)
end


-- Resets the spells that are listed under this, for things like Cold Snap or Prep
function Afflicted:ProcessReset(spellID, spellName, sourceGUID, sourceName)
	for _, resetID in pairs(self.resetSpells[spellID]) do
		local spellData = self.db.profile.spells[resetID]
		if( spellData and not spellData.disabled ) then
			local name = GetSpellInfo(resetID)
			
			local anchor = self.db.profile.anchors[spellData.showIn]
			if( anchor and anchor.enabled ) then
				self[anchor.displayType]:RemoveCooldownTimer(resetID, sourceGUID, spellData.cdInside)
			end
		end
	end
end

-- An ability was ended early via the combat log
function Afflicted:ProcessEnd(eventType, spellID, spellName, sourceGUID, sourceName)
	local spellData = getSpellData(spellID, spellName)
	if( not spellData or spellData.disabled or spellData.dontFade ) then
		return
	end
	
	local anchor = self.db.profile.anchors[spellData.showIn]
	if( not anchor or not anchor.enabled ) then
		return
	end

	local removed = self[anchor.displayType]:RemoveTimer(spellData.showIn, spellID, sourceGUID)
	if( removed ) then
		self:AnnounceEnd(spellData, anchor, spellID, spellName, sourceName)
	end
end

-- Ability ended due due to the timer running out, and it was removed from the bar
function Afflicted:AbilityEnded(eventType, spellID, spellName, sourceGUID, sourceName)
	if( eventType == "TEST" ) then
		return
	end

	local spellData = getSpellData(spellID, spellName)
	if( not spellData or spellData.disabled ) then
		return
	end
	
	local anchor = self.db.profile.anchors[spellData.showIn]
	if( not anchor or not anchor.enabled ) then
		return
	end
	
	self:AnnounceEnd(spellData, anchor, spellID, spellName, sourceName)
end

function Afflicted:CooldownEnded(eventType, spellID, spellName, sourceGUID, sourceName)
	if( eventType == "TEST" ) then
		return
	end
	
	local spellData = getSpellData(spellID, spellName)
	if( not spellData or not spellData.cdEnabled ) then
		return
	end
	
	local anchor = self.db.profile.anchors[spellData.cdInside]
	if( not anchor or not anchor.enabled ) then
		return
	end
	
	self:AnnounceEnd(spellData, anchor, spellID, spellName, sourceName)
end

-- Alert that the timers over
function Afflicted:AnnounceEnd(spellData, anchor, spellID, spellName, sourceName)
	-- Work out if we should use a custom message, or a default one
	local msg
	if( spellData.enableCustom ) then
		msg = spellData.fadedMessage
	elseif( anchor.announce ) then
		msg = anchor.fadeMessage
	end

	if( not msg or msg == "" ) then
		return
	end

	msg = string.gsub(msg, "*spell", spellName)
	msg = string.gsub(msg, "*target", self:StripServer(sourceName))

	self:SendMessage(msg, anchor.announceDest, anchor.announceColor, spellID)
end


-- Strips server name
function Afflicted:StripServer(text)
	local name, server = string.match(text, "(.-)%-(.*)$")
	if( not name and not server ) then
		return text
	end
	
	return name
end

-- See if we should wrap an icon stuff around this
function Afflicted:WrapIcon(msg, dest, spellID)
	if( not self.db.profile.showIcons or not spellID ) then
		return msg
	end
	
	-- Make sure we have a valid icon
	local icon = select(3, GetSpellInfo(spellID))
	if( not icon ) then
		return msg
	end

	return string.format("|T%s:0:0|t %s", icon, msg)
end

function Afflicted:SendMessage(msg, dest, color, spellID)
	if( dest == "none" ) then
		return
	end
			
	-- We're ungrouped, so redirect it to RWFrame
	if( dest == "rw" and GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 ) then
		dest = "rwframe"
	-- We're grouped, in a raid and not leader or assist
	elseif( dest == "rw" and not IsRaidLeader() and not IsRaidOfficer() and GetNumRaidMembers() > 0 ) then
		dest = "party"
	end
	
	-- Strip out any () leftover from no name being given
	msg = string.trim(string.gsub(msg, "%(%)", ""))
		
	-- Chat frame
	if( tonumber(dest) ) then
		local frame = getglobal("ChatFrame" .. dest) or DEFAULT_CHAT_FRAME
		frame:AddMessage("|cff33ff99Afflicted|r|cffffffff:|r " .. self:WrapIcon(msg, dest, spellID), color.r, color.g, color.b)
	-- Raid warning announcement to raid/party
	elseif( dest == "rw" ) then
		SendChatMessage(msg, "RAID_WARNING")
	-- Raid warning frame, will not send it out to the party
	elseif( dest == "rwframe" ) then
		self.alertFrame:AddMessage(self:WrapIcon(msg, dest, spellID), color.r, color.g, color.b)
	-- Party chat
	elseif( dest == "party" ) then
		SendChatMessage(msg, "SAY")
	-- Combat text
	elseif( dest == "ct" ) then
		self:CombatText(self:WrapIcon(msg, dest, spellID), color)
	end
end

function Afflicted:CombatText(text, color, spellID)	
	-- SCT
	if( IsAddOnLoaded("sct") ) then
		SCT:DisplayText(text, color, nil, "event", 1)
	-- MSBT
	elseif( IsAddOnLoaded("MikScrollingBattleText") ) then
		MikSBT.DisplayMessage(text, MikSBT.DISPLAYTYPE_NOTIFICATION, false, color.r * 255, color.g * 255, color.b * 255)		
	-- Parrot
	elseif( IsAddOnLoaded("Parrot") ) then
		Parrot:ShowMessage(text, nil, nil, color.r, color.g, color.b)
	-- Blizzard Combat Text
	elseif( IsAddOnLoaded("Blizzard_CombatText") ) then
		-- Haven't cached the movement function yet
		if( not COMBAT_TEXT_SCROLL_FUNCTION ) then
			CombatText_UpdateDisplayedMessages()
		end
		
		CombatText_AddMessage(text, COMBAT_TEXT_SCROLL_FUNCTION, color.r, color.g, color.b)
	end
end

function Afflicted:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Afflicted2|r: " .. msg)
end
