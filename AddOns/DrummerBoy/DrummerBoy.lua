-- Addon Declaration
DrummerBoy = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0")
local addon = DrummerBoy

-- Locals
local L = AceLibrary("AceLocale-2.2"):new("DrummerBoy")

local DrumsOfBattleID = 35476
local DrumsOfRestorationID = 35478
local DrumsOfWarID = 35475

-- Localization
L:RegisterTranslations("enUS", function() return {
	['Drums of Battle'] = true,
	['Set options for Drums of Battle'] = true,
	['Drums of Battle used!'] = true,
	['Drums of Battle fading in 5 seconds!'] = true,
	['Drums of Battle faded!'] = true,

	['Drums of Restoration'] = true,
	['Set options for Drums of Restoration'] = true,
	['Drums of Restoration used!'] = true,
	['Drums of Restoration fading in 5 seconds!'] = true,
	['Drums of Restoration faded!'] = true,

	['Drums of War'] = true,
	['Set options for Drums of War'] = true,
	['Drums of War used!'] = true,
	['Drums of War fading in 5 seconds!'] = true,
	['Drums of War faded!'] = true,

	['Track drums'] = true,
	['Toggle tracking of drums'] = true,

	['Enter a message to be sent'] = true,

	['Start message'] = true,
	['This message will be sent when drums start'] = true,

	['End in five seconds message'] = true,
	['This message will be sent five seconds before drums fade'] = true,

	['End message'] = true,
	['This message will be sent when drums fade'] = true,

	['Five second warning'] = true,
	['Send a warning five seconds before drums fade'] = true,

	['Use /say'] = true,
	['Send messages using /say'] = true,

	['Use /party'] = true,
	['Send messages using /party'] = true,
} end)

-- Initialization
function addon:OnInitialize()
	self:RegisterDB("DrummerBoyDB")

	-- Defaults	
	self.defaults = {
		['ValidDrums'] = {
			[DrumsOfBattleID] = true,
			[DrumsOfRestorationID] = true,
			[DrumsOfWarID] = true,
		},
		['DrumInfo'] = {
			[DrumsOfBattleID] = {
				['Duration'] = 30,
				['Track'] = true,
				['StartMessage'] = L['Drums of Battle used!'],
				['EndSoonMessage'] = L['Drums of Battle fading in 5 seconds!'],
				['EndMessage'] = L['Drums of Battle faded!'],
				['FiveSecondWarning'] = true,
				['UseSay'] = false,
				['UseParty'] = true,
			},
			[DrumsOfRestorationID] = {
				['Duration'] = 15,
				['Track'] = true,
				['StartMessage'] = L['Drums of Restoration used!'],
				['EndSoonMessage'] = L['Drums of Restoration fading in 5 seconds!'],
				['EndMessage'] = L['Drums of Restoration faded!'],
				['FiveSecondWarning'] = true,
				['UseSay'] = false,
				['UseParty'] = true,
			},
			[DrumsOfWarID] = {
				['Duration'] = 30,
				['Track'] = true,
				['StartMessage'] = L['Drums of War used!'],
				['EndSoonMessage'] = L['Drums of War fading in 5 seconds!'],
				['EndMessage'] = L['Drums of War faded!'],
				['FiveSecondWarning'] = true,
				['UseSay'] = false,
				['UseParty'] = true,
			},
		},
	}

	self:RegisterDefaults('profile', self.defaults)

	-- Options
	self.optionsTable = {
		type = "group",
		args = {
			DrumsOfBattle = {
				name = L['Drums of Battle'],
				desc = L['Set options for Drums of Battle'],
				type = 'group',
				order = 1,
				args = {
					Track = {
						type = 'toggle',
						name = L['Track drums'],
						desc = L['Toggle tracking of drums'],
						order = 1,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfBattleID]['Track']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfBattleID]['Track'] = v
							if v then
								self.db.profile.ValidDrums[DrumsOfBattleID] = true
							else
								for key, value in ipairs(self.db.profile.ValidDrums) do
									if key == DrumsOfBattleID then
										table.remove(self.db.profile.ValidDrums, key)
										break
									end
								end
							end
						end,
					},
					DrumStart = {
						type = 'text',
						name = L['Start message'],
						desc = L['This message will be sent when drums start'],
						order = 2,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfBattleID]['StartMessage']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfBattleID]['StartMessage'] = v
						end,
						usage = L['Enter a message to be sent'],
					},
					DrumEndSoon = {
						type = 'text',
						name = L['End in five seconds message'],
						desc = L['This message will be sent five seconds before drums fade'],
						order = 3,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfBattleID]['EndSoonMessage']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfBattleID]['EndSoonMessage'] = v
						end,
						usage = L['Enter a message to be sent'],
					},
					DrumEnd = {
						type = 'text',
						name = L['End message'],
						desc = L['This message will be sent when drums fade'],
						order = 4,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfBattleID]['EndMessage']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfBattleID]['EndMessage'] = v
						end,
						usage = L['Enter a message to be sent'],
					},
					DrumEndSoonWarning = {
						type = 'toggle',
						name = L['Five second warning'],
						desc = L['Send a warning five seconds before drums fade'],
						order = 5,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfBattleID]['FiveSecondWarning']
						end,
						set = function()
							self.db.profile.DrumInfo[DrumsOfBattleID]['FiveSecondWarning'] = v
						end,
					},
					Say = {
						type = 'toggle',
						name = L['Use /say'],
						desc = L['Send messages using /say'],
						order = 6,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfBattleID]['UseSay']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfBattleID]['UseSay'] = v
							self.db.profile.DrumInfo[DrumsOfBattleID]['UseParty'] = not v
						end,
					},
					Party = {
						type = 'toggle',
						name = L['Use /party'],
						desc = L['Send messages using /party'],
						order = 7,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfBattleID]['UseParty']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfBattleID]['UseSay'] = not v
							self.db.profile.DrumInfo[DrumsOfBattleID]['UseParty'] = v
						end,
					},
				},
			},
			DrumsOfRestoration = {
				name = L['Drums of Restoration'],
				desc = L['Set options for Drums of Restoration'],
				type = 'group',
				order = 2,
				args = {
					Track = {
						type = 'toggle',
						name = L['Track drums'],
						desc = L['Toggle tracking of drums'],
						order = 1,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfRestorationID]['Track']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfRestorationID]['Track'] = v
							if v then
								self.db.profile.ValidDrums[DrumsOfRestorationID] = true
							else
								for key, value in ipairs(self.db.profile.ValidDrums) do
									if key == DrumsOfRestorationID then
										table.remove(self.db.profile.ValidDrums, key)
										break
									end
								end
							end
						end,
					},
					DrumStart = {
						type = 'text',
						name = L['Start message'],
						desc = L['This message will be sent when drums start'],
						order = 2,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfRestorationID]['StartMessage']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfRestorationID]['StartMessage'] = v
						end,
						usage = L['Enter a message to be sent'],
					},
					DrumEndSoon = {
						type = 'text',
						name = L['End in five seconds message'],
						desc = L['This message will be sent five seconds before drums fade'],
						order = 3,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfRestorationID]['EndSoonMessage']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfRestorationID]['EndSoonMessage'] = v
						end,
						usage = L['Enter a message to be sent'],
					},
					DrumEnd = {
						type = 'text',
						name = L['End message'],
						desc = L['This message will be sent when drums fade'],
						order = 4,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfRestorationID]['EndMessage']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfRestorationID]['EndMessage'] = v
						end,
						usage = L['Enter a message to be sent'],
					},
					DrumEndSoonWarning = {
						type = 'toggle',
						name = L['Five second warning'],
						desc = L['Send a warning five seconds before drums fade'],
						order = 5,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfRestorationID]['FiveSecondWarning']
						end,
						set = function()
							self.db.profile.DrumInfo[DrumsOfRestorationID]['FiveSecondWarning'] = v
						end,
					},
					Say = {
						type = 'toggle',
						name = L['Use /say'],
						desc = L['Send messages using /say'],
						order = 6,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfRestorationID]['UseSay']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfRestorationID]['UseSay'] = v
							self.db.profile.DrumInfo[DrumsOfRestorationID]['UseParty'] = not v
						end,
					},
					Party = {
						type = 'toggle',
						name = L['Use /party'],
						desc = L['Send messages using /party'],
						order = 7,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfRestorationID]['UseParty']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfRestorationID]['UseSay'] = not v
							self.db.profile.DrumInfo[DrumsOfRestorationID]['UseParty'] = v
						end,
					},
				},
			},
			DrumsOfWar = {
				name = L['Drums of War'],
				desc = L['Set options for Drums of War'],
				type = 'group',
				order = 3,
				args = {
					Track = {
						type = 'toggle',
						name = L['Track drums'],
						desc = L['Toggle tracking of drums'],
						order = 1,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfWarID]['Track']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfWarID]['Track'] = v
							if v then
								self.db.profile.ValidDrums[DrumsOfWarID] = true
							else
								for key, value in ipairs(self.db.profile.ValidDrums) do
									if key == DrumsOfWarID then
										table.remove(self.db.profile.ValidDrums, key)
										break
									end
								end
							end
						end,
					},
					DrumStart = {
						type = 'text',
						name = L['Start message'],
						desc = L['This message will be sent when drums start'],
						order = 2,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfWarID]['StartMessage']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfWarID]['StartMessage'] = v
						end,
						usage = L['Enter a message to be sent'],
					},
					DrumEndSoon = {
						type = 'text',
						name = L['End in five seconds message'],
						desc = L['This message will be sent five seconds before drums fade'],
						order = 3,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfWarID]['EndSoonMessage']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfWarID]['EndSoonMessage'] = v
						end,
						usage = L['Enter a message to be sent'],
					},
					DrumEnd = {
						type = 'text',
						name = L['End message'],
						desc = L['This message will be sent when drums fade'],
						order = 4,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfWarID]['EndMessage']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfWarID]['EndMessage'] = v
						end,
						usage = L['Enter a message to be sent'],
					},
					DrumEndSoonWarning = {
						type = 'toggle',
						name = L['Five second warning'],
						desc = L['Send a warning five seconds before drums fade'],
						order = 5,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfWarID]['FiveSecondWarning']
						end,
						set = function()
							self.db.profile.DrumInfo[DrumsOfWarID]['FiveSecondWarning'] = v
						end,
					},
					Say = {
						type = 'toggle',
						name = L['Use /say'],
						desc = L['Send messages using /say'],
						order = 6,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfWarID]['UseSay']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfWarID]['UseSay'] = v
							self.db.profile.DrumInfo[DrumsOfWarID]['UseParty'] = not v
						end,
					},
					Party = {
						type = 'toggle',
						name = L['Use /party'],
						desc = L['Send messages using /party'],
						order = 7,
						get = function()
							return self.db.profile.DrumInfo[DrumsOfWarID]['UseParty']
						end,
						set = function(v)
							self.db.profile.DrumInfo[DrumsOfWarID]['UseSay'] = not v
							self.db.profile.DrumInfo[DrumsOfWarID]['UseParty'] = v
						end,
					},
				},
			},
		},
	}

	self:RegisterChatCommand({"/drummerboy"}, self.optionsTable)
	self.OnMenuRequest = self.optionsTable
end

function addon:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "CombatEvents")
end

function addon:OnDisable()
	self:UnregisterAllEvents()
	self:CancelAllScheduledEvents()
end

function addon:LogEventIsPlayer(flags)
	return (bit.band(flags, 0x00000001) == 0x00000001);
end

function addon:CombatEvents(timestamp, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	if event == "SPELL_CAST_SUCCESS" and self:LogEventIsPlayer(srcFlags) and GetNumPartyMembers() > 0 then
		local spellID, spellName = select(1, ...)
		if self.db.profile.ValidDrums[spellID] and self.db.profile.DrumInfo[spellID]['Track'] then
			self:AnnounceDrums(spellID, self.db.profile.DrumInfo[spellID]['StartMessage'])
			if self.db.profile.DrumInfo[spellID]['FiveSecondWarning'] then
				local announceDrumsEndSoon = 'AnnounceDrumsEndSoon' .. spellID
				self:ScheduleEvent(announceDrumsEndSoon, self.AnnounceDrums, self.db.profile.DrumInfo[spellID]['Duration'] - 5, self, spellID, self.db.profile.DrumInfo[spellID]['EndSoonMessage'])
			end
			local announceDrumsEnd = 'AnnounceDrumsEnd' .. spellID
			self:ScheduleEvent(announceDrumsEnd, self.AnnounceDrums, self.db.profile.DrumInfo[spellID]['Duration'], self, spellID, self.db.profile.DrumInfo[spellID]['EndMessage'])
		end
	end
end

function addon:AnnounceDrums(drumID, message)
	if GetNumPartyMembers() <= 0 then
		return
	end

	local chatChannel = nil
	if self.db.profile.DrumInfo[drumID]['UseParty'] then
		chatChannel = 'PARTY'
	end
	SendChatMessage(message, chatChannel)
end
