if( not Afflicted ) then return end

local Config = Afflicted:NewModule("Config")
local L = AfflictedLocals

local SML, registered, options, config, dialog

function Config:OnInitialize()
	config = LibStub("AceConfig-3.0")
	dialog = LibStub("AceConfigDialog-3.0")
	

	SML = Afflicted.SML
	SML:Register(SML.MediaType.STATUSBAR, "BantoBar", "Interface\\Addons\\Afflicted\\images\\banto")
	SML:Register(SML.MediaType.STATUSBAR, "Smooth",   "Interface\\Addons\\Afflicted\\images\\smooth")
	SML:Register(SML.MediaType.STATUSBAR, "Perl",     "Interface\\Addons\\Afflicted\\images\\perl")
	SML:Register(SML.MediaType.STATUSBAR, "Glaze",    "Interface\\Addons\\Afflicted\\images\\glaze")
	SML:Register(SML.MediaType.STATUSBAR, "Charcoal", "Interface\\Addons\\Afflicted\\images\\Charcoal")
	SML:Register(SML.MediaType.STATUSBAR, "Otravi",   "Interface\\Addons\\Afflicted\\images\\otravi")
	SML:Register(SML.MediaType.STATUSBAR, "Striped",  "Interface\\Addons\\Afflicted\\images\\striped")
	SML:Register(SML.MediaType.STATUSBAR, "LiteStep", "Interface\\Addons\\Afflicted\\images\\LiteStep")
end

function Config:SetupDB()
	local self = Afflicted
	self.defaults = {
		profile = {
			showAnchors = true,
			showIcons = true,
			showTarget = false,
			
			dispelEnabled = false,
			dispelHostile = true,
			dispelDest = "party",
			dispelColor = { r = 1, g = 1, b = 1 },
			
			interruptEnabled = true,
			interruptDest = "party",
			interruptColor = { r = 1, g = 1, b = 1 },
			
			barWidth = 180,
			barNameOnly = false,
			barName = "BantoBar",
			
			spells = AfflictedSpells,
			inside = {["arena"] = true, ["pvp"] = true},
			anchors = {},
			
			disabledSpells = { [2] = {}, [3] = {}, [5] = {} },

			anchorDefault = {
				enabled = true,
				announce = false,
				growUp = false,
				announceColor = { r = 1.0, g = 1.0, b = 1.0 },
				announceDest = "1",
				scale = 1.0,
				maxRows = 20,
				redirectTo = "",
				displayType = "bar",

				usedMessage = L["USED *spell (*target)"],
				fadeMessage = L["FINISHED *spell (*target)"],
			},
			spellDefault = {
				seconds = 0,
				cooldown = 0,
				cdEnabled = false,
				cdInside = "cooldowns",
				showIn = "buffs",
				icon = "",
				SPELL_CAST_SUCCESS = true
			},
		},
	}

	self.defaults.profile.anchors.buffs = CopyTable(self.defaults.profile.anchorDefault)
	self.defaults.profile.anchors.buffs.text = L["Buffs"]
	
	self.defaults.profile.anchors.spells = CopyTable(self.defaults.profile.anchorDefault)
	self.defaults.profile.anchors.spells.text = L["Spells"]
	
	self.defaults.profile.anchors.totems = CopyTable(self.defaults.profile.anchorDefault)
	self.defaults.profile.anchors.totems.text = L["Totems"]
	
	self.defaults.profile.anchors.cooldowns = CopyTable(self.defaults.profile.anchorDefault)
	self.defaults.profile.anchors.cooldowns.text = L["Cooldowns"]
	self.defaults.profile.anchors.cooldowns.usedMessage = ""
	self.defaults.profile.anchors.cooldowns.fadeLessage = L["READY *spell (*target)"]

	self.db = LibStub:GetLibrary("AceDB-3.0"):New("AfflictedDB", self.defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "Reload")
	self.db.RegisterCallback(self, "OnProfileCopied", "Reload")
	self.db.RegisterCallback(self, "OnProfileReset", "Reload")
	
	self.resetSpells = {}
	
	-- Set defaults to have actual values if they're missing
	for id, spell in pairs(self.defaults.profile.spells) do
		if( type(id) == "number" and type(spell) == "table" ) then
			for k, v in pairs(self.defaults.profile.spellDefault) do
				if( k ~= "SPELL_CAST_SUCCESS" and spell[k] == nil ) then
					spell[k] = v
				end
			end
			
			if( spell.resetOn ) then
				if( not self.resetSpells[spell.resetOn] ) then
					self.resetSpells[spell.resetOn] = {}
				end
				
				table.insert(self.resetSpells[spell.resetOn], id)
			end
						
			-- Set spell text if we didn't list it already
			if( AfflictedSpells[id] and not AfflictedSpells[id].text ) then
				spell.text = GetSpellInfo(id)
			end
		end
	end
	

	-- Upgrade
	if( self.db.profile.version ) then
		if( self.db.profile.version <= 655 ) then
			self.db:ResetProfile()
			self:Print(L["Your configuration has been reset to the defaults."])
		elseif( self.db.profile.version <= 667 ) then
			for k, spell in pairs(self.db.profile.spells) do
				if( type(spell) == "table" ) then
					spell.SPELL_MISC = nil
					spell.SPELL_AURA_APPLIEDDEBUFFGROUP = nil
					spell.SPELL_AURA_APPLIEDBUFFENEMY = nil
					spell.SPELL_INTERRUPT = nil

					if( not spell.SPELL_SUMMON and not spell.SPELL_CREATE and not spell.SPELL_AURA_APPLIEDDEBUFFENEMY ) then
						spell.SPELL_CAST_SUCCESS = true
					end
				end
			end
		elseif( self.db.profile.version <= 702 ) then
			for k, anchor in pairs(self.db.profile.anchors) do
				if( not anchor.redirectTo ) then
					anchor.redirectTo = ""
				end
			end
			
		elseif( self.db.profile.version <= 758 ) then
			for k, anchor in pairs(self.db.profile.anchors) do
				anchor.maxRows = anchor.maxRows or self.defaults.profile.anchorDefault.maxRows
				anchor.displayType = anchor.displayType or self.defaults.profile.anchorDefault.displayType

				if( self.db.profile.showBars == false ) then
					self.db.profile.showBars = nil
					anchor.displayType = "icon"
				end
			end
		
		elseif( self.db.profile.version <= 838 ) then
			if( self.db.profile.anchors.cooldowns.fadeMessage == L["FINISHED *spell (*target)"] ) then
				self.db.profile.anchors.cooldowns.fadeMessage = L["READY *spell (*target)"]
			end
		end
		
		-- Do a quick spell check to see if something was removed from the default list
		if( self.db.profile.version ~= self.revision ) then
			for id, data in pairs(self.db.profile.spells) do
				-- Type changed, eg we have a number saved and it's actually a table, either way reset it
				if( AfflictedSpells[id] and type(data) ~= type(AfflictedSpells[id]) ) then
					self.db.profile.spells[id] = nil
				
				-- We're storing a number, but it's not listed anymore. And it doesn't have seconds or showIn set
				elseif( ( type(id) == "number" and not AfflictedSpells[id] ) and ( not data.showIn or not data.seconds ) ) then
					self.db.profile.spells[id] = nil
				end
			end
		end
	end	
	
	self.db.profile.version = self.revision
end

-- GUI
local announceDest = {["none"] = L["None"], ["ct"] = L["Combat text"], ["party"] = L["Party"], ["raid"] = L["Raid"], ["rw"] = L["Raid warning"], ["rwframe"] = L["Middle of screen"], ["1"] = string.format(L["Chat frame #%d"], 1), ["2"] = string.format(L["Chat frame #%d"], 2), ["3"] = string.format(L["Chat frame #%d"], 3), ["4"] = string.format(L["Chat frame #%d"], 4), ["5"] = string.format(L["Chat frame #%d"], 5), ["6"] = string.format(L["Chat frame #%d"], 6), ["7"] = string.format(L["Chat frame #%d"], 7)}

local function set(info, value)
	local arg1, arg2, arg3 = string.split(".", info.arg)
	if( tonumber(arg2) ) then arg2 = tonumber(arg2) end
	if( tonumber(arg3) ) then arg3 = tonumber(arg3) end
	
	if( arg2 and arg3 ) then
		Afflicted.db.profile[arg1][arg2][arg3] = value
	elseif( arg2 ) then
		Afflicted.db.profile[arg1][arg2] = value
	else
		Afflicted.db.profile[arg1] = value
	end
	
	Afflicted:Reload()
end

local function get(info)
	local arg1, arg2, arg3 = string.split(".", info.arg)
	if( tonumber(arg2) ) then arg2 = tonumber(arg2) end
	if( tonumber(arg3) ) then arg3 = tonumber(arg3) end
	
	if( arg2 and arg3 ) then
		return Afflicted.db.profile[arg1][arg2][arg3]
	elseif( arg2 ) then
		return Afflicted.db.profile[arg1][arg2]
	else
		return Afflicted.db.profile[arg1]
	end
end

local function setNumber(info, value)
	set(info, tonumber(value))
end

local function setColor(info, r, g, b)
	set(info, {r = r, g = g, b = b})
end

local function getColor(info)
	local value = get(info)
	if( type(value) == "table" ) then
		return value.r, value.g, value.b
	end
	
	return value
end

local function setType(info, value)
	if( tonumber(value) ) then
		set(info, tonumber(value))
	else
		set(info, value)
	end
end

local function getString(info)
	return tostring(get(info))
end

local function setMulti(info, value, state)
	local arg1, arg2, arg3 = string.split(".", info.arg)
	if( tonumber(arg2) ) then arg2 = tonumber(arg2) end

	if( arg2 and arg3 ) then
		Afflicted.db.profile[arg1][arg2][arg3][value] = state
	elseif( arg2 ) then
		Afflicted.db.profile[arg1][arg2][value] = state
	else
		Afflicted.db.profile[arg1][value] = state
	end

	Afflicted:Reload()
end

local function getMulti(info, value)
	local arg1, arg2, arg3 = string.split(".", info.arg)
	if( tonumber(arg2) ) then arg2 = tonumber(arg2) end
	
	if( arg2 and arg3 ) then
		return Afflicted.db.profile[arg1][arg2][arg3][value]
	elseif( arg2 ) then
		return Afflicted.db.profile[arg1][arg2][value]
	else
		return Afflicted.db.profile[arg1][value]
	end
end

local globalOptions = {["displayType"] = "", ["scale"] = 1, ["maxRows"] = 10, ["growUp"] = false}
local function getGlobalOption(info)
	return globalOptions[info.arg]
end

local function setGlobalOption(info, value)
	if( info.arg == "displayType" and value == "" ) then
		return
	end
	
	for name, anchor in pairs(Afflicted.db.profile.anchors) do
		anchor[info.arg] = value
	end
	
	Afflicted.modules.Bars:ReloadVisual()
	Afflicted.modules.Icons:ReloadVisual()
	
	globalOptions[info.arg] = value
end

-- Return all registered SML textures
local textures = {}
function Config:GetTextures()
	for k in pairs(textures) do textures[k] = nil end

	for _, name in pairs(SML:List(SML.MediaType.STATUSBAR)) do
		textures[name] = name
	end
	
	return textures
end

-- Return all registered GTB groups
local groups = {}
function Config:GetGroups()
	for k in pairs(groups) do groups[k] = nil end

	groups[""] = L["None"]
	for name, data in pairs(Afflicted.modules.Bars.GTB:GetGroups()) do
		groups[name] = name
	end
	
	return groups
end

-- Check if we should disable this option
function Config:IsDisabled(info)
	local type = info[#(info) - 1]
	
	if( type == "bars" or type == "redirect" ) then
		return not Afflicted.db.profile.showBars
	elseif( type == "interrupt" ) then
		return not Afflicted.db.profile.interruptEnabled
	elseif( type == "dispel" ) then
		return not Afflicted.db.profile.dispelEnabled
	end
	
	return true
end

-- ANCHORS
function Config:ValidateAnchor(info, value)
	if( value == "" ) then
		return L["You must enter a name for this anchor."]
	end
	
	local id = string.lower(string.gsub(string.gsub(value, "%.", ""), " ", ""))
	if( Afflicted.db.profile.anchors[id] ) then
		return string.format(L["The anchor \"%s\" already exists."], value)
	end
	
	return true
end

local displayTypes = {["bar"] = L["Bars"], ["icon"] = L["Icons"]}

function Config:CreateAnchorDisplay(info, value)
	local id = string.lower(string.gsub(string.gsub(value, "%.", ""), " ", ""))
	
	if( not Afflicted.db.profile.anchors[id] ) then
		Afflicted.db.profile.anchors[id] = CopyTable(Afflicted.defaults.profile.anchorDefault)
		Afflicted.db.profile.anchors[id].text = value
	end
		
	options.args.anchors.args[value] = {
		order = 1,
		type = "group",
		name = value,
		get = get,
		set = set,
		handler = Config,
		args = {
			enabled = {
				order = 1,
				type = "toggle",
				name = L["Enable showing timers in this anchor"],
				desc = L["Allows timers to be shown under this anchor, if the anchor is disabled you won't see any timers."],
				width = "full",
				arg = "anchors." .. id .. ".enabled",
			},
			display = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Timer display"],
				args = {
					desc = {
						order = 0,
						name = L["Per anchor display for how timers should be displayed."],
						type = "description",
					},
					growUp = {
						order = 1,
						type = "toggle",
						name = L["Grow display up"],
						desc = L["Instead of adding everything from top to bottom, timers will be shown from bottom to top."],
						width = "double",
						arg = "anchors." .. id .. ".growUp",
					},
					displayType = {
						order = 2,
						type = "select",
						name = L["Display style"],
						values = displayTypes,
						arg = "anchors." .. id .. ".displayType",
					},
					sep = {
						order = 3,
						name = "",
						type = "description",
					},
					scale = {
						order = 4,
						type = "range",
						name = L["Display scale"],
						desc = L["How big the actual timers should be."],
						min = 0, max = 2, step = 0.1,
						arg = "anchors." .. id .. ".scale",
					},
					maxRows = {
						order = 5,
						type = "range",
						name = L["Max timers"],
						desc = L["Maximum amount of timers that should be ran per an anchor at the same time, if too many are running at the same time then the new ones will simply be hidden until older ones are removed."],
						min = 1, max = 50, step = 1,
						arg = "anchors." .. id .. ".maxRows",
					},
					redirection = {
						order = 6,
						type = "group",
						inline = true,
						name = L["Redirection"],
						args = {
							desc = {
								order = 0,
								name = L["Group name to redirect bars to, this lets you show Afflicted timers under another addons bar group. Requires the bars to be created using GTB, and the bar display to be enabled for this anchor."],
								type = "description",
							},
							location = {
								order = 1,
								type = "select",
								name = L["Redirect bars to group"],
								values = "GetGroups",
								arg = "anchors." .. id .. ".redirectTo",
							},
						},
					},
				},
			},
			announce = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Announcements"],
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable announcements"],
						desc = L["Enables showing alerts for when timers are triggered to this anchor."],
						arg = "anchors." .. id .. ".announce",
					},
					color = {
						order = 2,
						type = "color",
						name = L["Text color"],
						desc = L["Alert text color, only applies to local outputs."],
						set = setColor,
						get = getColor,
						arg = "anchors." .. id .. ".announceColor",
					},
					dispelDest = {
						order = 3,
						type = "select",
						name = L["Announce destination"],
						desc = L["Location to send announcements for this option to."],
						values = announceDest,
						arg = "anchors." .. id .. ".announceDest",
					},
				},
			},
			announceText = {
				order = 6,
				type = "group",
				inline = true,
				name = L["Announce text"],
				args = {
					desc = {
						order = 0,
						name = L["Announcement text for when timers are triggered in this anchor. You can use *spell for the spell name, and *target for the person who triggered it (if any)."],
						type = "description",
					},
					used = {
						order = 2,
						type = "input",
						name = L["Triggered message"],
						desc = L["Custom message to use for when this timer starts, if you leave the message blank and you have custom messages enabled then no message will be given when it's triggered."],
						width = "full",
						arg = "anchors." .. id .. ".usedMessage",
					},
					fade = {
						order = 3,
						type = "input",
						name = L["Ended message"],
						desc = L["Custom message to use for when this timer ends, if you leave the message blank and you have custom messages enabled then no message will be given when it's ends."],
						width = "full",
						arg = "anchors." .. id .. ".fadeMessage",
					},
				},
			},
		},
	}
end

-- SPELLS
function Config:ValidateSpell(info, value)
	if( value == "" ) then
		return L["You must enter a spell name, or spellID for this."]
	end
	
	if( Afflicted.db.profile.spells[value] ) then
		return string.format(L["The spell \"%s\" already exists."], value)
	end
	
	return true
end

local spells = {}
function Config:GetSpells()
	for k in pairs(spells) do spells[k] = nil end
	
	spells[""] = L["None"]

	for id, data in pairs(Afflicted.db.profile.spells) do
		if( tonumber(id) and type(data) == "table" ) then
			local text = id
			if( data.text ) then
				text = data.text
			else
				text = string.format("#%s", id)
			end

			spells[tostring(id)] = tostring(text)
		end
	end
	
	return spells
end

local anchors = {}
function Config:GetAnchors()
	for k in pairs(anchors) do anchors[k] = nil end

	for id, data in pairs(Afflicted.db.profile.anchors) do
		anchors[id] = data.text
	end
	
	return anchors
end

local function getSpellInfo(info)
	local spellID = string.match(info.arg, "spells%.(.+)%.disabled")
	if( tonumber(spellID) ) then
		spellID = tonumber(spellID)
	end
	
	local data = Afflicted.db.profile.spells[spellID]
	local anchorName = data.showIn
	if( Afflicted.db.profile.anchors[anchorName] ) then
		anchorName = Afflicted.db.profile.anchors[anchorName].text
	end
	
	return string.format(L["%s\nAnchor: %s\nDuration: %d\nCooldown: %d (%s)"], data.disabled and ( RED_FONT_COLOR_CODE .. L["Timer disabled"] .. FONT_COLOR_CODE_CLOSE ) or ( GREEN_FONT_COLOR_CODE .. L["Timer enabled"] .. FONT_COLOR_CODE_CLOSE ), anchorName or L["None"], data.seconds or 0, data.cooldown or 0, data.cdEnabled and L["Enabled"] or L["Disabled"])
end

local function getArenaSpellInfo(info)
	local bracket, spellID = string.match(info.arg, "disabledSpells%.(.+)%.(.+)")
	bracket = tonumber(bracket)
	
	if( tonumber(spellID) ) then
		spellID = tonumber(spellID)
	end
	
	local data = Afflicted.db.profile.spells[spellID]
	if( type(data) == "number" ) then
		data = Afflicted.db.profile.spells[data]
	end
	
	local anchorName = data.showIn
	if( Afflicted.db.profile.anchors[anchorName] ) then
		anchorName = Afflicted.db.profile.anchors[anchorName].text
	end
	
	return string.format(L["%s in %dvs%d\nAnchor: %s\nDuration: %d\nCooldown: %d (%s)"], Afflicted.db.profile.disabledSpells[bracket][spellID] and ( RED_FONT_COLOR_CODE .. L["Timer disabled"] .. FONT_COLOR_CODE_CLOSE ) or ( GREEN_FONT_COLOR_CODE .. L["Timer enabled"] .. FONT_COLOR_CODE_CLOSE ), bracket, bracket, anchorName or L["None"], data.seconds or 0, data.cooldown or 0, data.cdEnabled and L["Enabled"] or L["Disabled"])
end

-- Quick wrappers, flips the check boxes so we can use it as checked = enabled, unchecked = disabled
local function setDisabled(info, value)
	set(info, not value)
end

local function getDisabled(info)
	return not get(info)
end

local checkEvents = { ["SPELL_AURA_APPLIEDDEBUFFENEMY"] = L["Enemy, gained debuff"], ["SPELL_CAST_SUCCESS"] = L["Enemy, successfully casts"], ["SPELL_SUMMON"] = L["Enemy, summons object"], ["SPELL_CREATE"] = L["Enemy, creates object"]}
function Config:CreateSpellDisplay(info, value)
	-- Do a quick type change
	if( tonumber(value) ) then
		value = tonumber(value)
	end
	
	if( not Afflicted.db.profile.spells[value] ) then
		Afflicted.db.profile.spells[value] = CopyTable(Afflicted.defaults.profile.spellDefault)
	end
	
	-- If it's a spellID, either show the text because we've seen the spell, or show the spellID
	local text = value
	if( type(value) == "number" ) then
		local data = Afflicted.db.profile.spells[value]
		if( data.text ) then
			text = data.text
		else
			text = string.format("#%d", tonumber(value))
		end
	end
	
	local id = string.gsub(value, " ", "")
	options.args.spells.args.list.args[id] = {
		type = "toggle",
		name = text or value,
		desc = getSpellInfo,
		get = getDisabled,
		set = setDisabled,
		arg = "spells." .. value .. ".disabled"
	}

	options.args.spells.args[id] = {
		order = 1,
		type = "group",
		name = tostring(text),
		get = get,
		set = set,
		handler = Config,
		args = {
			disabled = {
				order = 1,
				type = "toggle",
				name = L["Disable spell"],
				desc = L["While disabled, this spell will be completely ignored and no timer will be started for it."],
				width = "double",
				arg = "spells." .. value .. ".disabled",
			},
			showIn = {
				order = 2,
				type = "select",
				name = L["Show inside anchor"],
				desc = L["Anchor to display this timer inside, if the anchor is disabled then this timer won't show up."],
				values = "GetAnchors",
				arg = "spells." .. value .. ".showIn",
			},
			icon = {
				order = 4,
				type = "input",
				name = L["Icon path"],
				desc = L["Icon path to use for display, you do not have to specify this option. As long as you leave it blank or using the question mark icon then will auto-detect and save it."],
				width = "double",
				arg = "spells." .. value .. ".icon",
			},
			timer = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Timer"],
				args = {
					seconds = {
						order = 0,
						type = "input",
						name = L["Duration"],
						desc = L["How many seconds this timer should last."],
						validate = function(info, value) return tonumber(value) end,
						get = getString,
						set = setNumber,
						arg = "spells." .. value .. ".seconds",
					},
					desc = {
						order = 1,
						name = "",
						width = "full",
						type = "description",
					},
					repeating = {
						order = 2,
						type = "toggle",
						name = L["Repeating timer"],
						desc = L["Sets the timer as repeating, meaning once it hits 0 it'll start back up at the original time until the timer is specifically removed."],
						arg = "spells." .. value .. ".repeating",
					},
					noFade = {
						order = 3,
						type = "toggle",
						name = L["Ignore fade events"],
						desc = L["Prevents the timer from ending early due to the spell fading early before the timer runs out."],
						arg = "spells." .. value .. ".dontFade",
					},
					checkEvents = {
						order = 4,
						type = "multiselect",
						name = L["Check events to trigger"],
						desc = L["List of events that should be checked to see if we should trigger this timer."],
						values = checkEvents,
						set = setMulti,
						get = getMulti,
						width = "double",
						arg = "spells." .. value,
					},
				},
			},
			cooldown = {
				order = 6,
				type = "group",
				inline = true,
				name = L["Cooldown"],
				args = {
					desc = {
						order = 0,
						name = L["Allows you to start a new timer when this one is triggered that has the cooldown left on the ability, use this if you want to track both the timer duration and the timer cooldown."],
						type = "description",
					},
					disabled = {
						order = 1,
						type = "toggle",
						name = L["Enable cooldown"],
						desc = L["While disabled, no cooldown will be started when this timer is triggered."],
						width = "double",
						arg = "spells." .. value .. ".cdEnabled",
					},
					seconds = {
						order = 3,
						type = "input",
						name = L["Duration"],
						desc = L["How many seconds this cooldown timer should last."],
						validate = function(info, value) return tonumber(value) end,
						get = getString,
						set = setNumber,
						arg = "spells." .. value .. ".cooldown",
					},
					showIn = {
						order = 3,
						type = "select",
						name = L["Show inside anchor"],
						desc = L["Anchor to display this cooldown timer inside, if the anchor is disabled nothing will be shown."],
						values = "GetAnchors",
						arg = "spells." .. value .. ".cdInside",
					},
				},
			},
			--[[
			limit = {
				order = 7,
				type = "group",
				inline = true,
				name = L["Trigger limits"],
				args = {
					desc = {
						order = 0,
						name = L["Lets you prevent timers from trigger too quickly, causing duplicates."],
						type = "description",
					},
					single = {
						order = 1,
						type = "input",
						name = L["Per-player limit"],
						desc = L["How many seconds between the time this timer triggers, and the next one can trigger. This is the per player one, meaning it won't trigger more then the set amount per the player it triggered on/from."],
						validate = function(info, value) return tonumber(value) end,
						get = getString,
						set = setNumber,
						arg = "spells." .. value .. ".singleLimit",
					},
					global = {
						order = 1,
						type = "input",
						name = L["Per-spell limit"],
						desc = L["How many seconds between the time this timer triggers, and the next one can trigger. This is the per spell one, meaning it won't trigger more then the set amount per the spellID that triggers it."],
						validate = function(info, value) return tonumber(value) end,
						get = getString,
						set = setNumber,
						arg = "spells." .. value .. ".globalLimit",
					},
				},
			},
			]]
			announce = {
				order = 8,
				type = "group",
				inline = true,
				name = L["Custom announcements"],
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable custom messages"],
						desc = L["Allows you to override the per-anchor messages for this specific timer, if the anchor has announcements disabled then this will do nothing."],
						width = "double",
						arg = "spells." .. value .. ".enableCustom",
					},
					triggered = {
						order = 2,
						type = "input",
						name = L["Triggered message"],
						desc = L["Custom message to use for when this timer starts, if you leave the message blank and you have custom messages enabled then no message will be given when it's triggered."],
						width = "full",
						arg = "spells." .. value .. ".triggeredMessage",
					},
					ended = {
						order = 3,
						type = "input",
						name = L["Ended message"],
						desc = L["Custom message to use for when this timer ends, if you leave the message blank and you have custom messages enabled then no message will be given when it's ends."],
						width = "full",
						arg = "spells." .. value .. ".fadedMessage",
					},
				},
			},
			delete = {
				order = 9,
				type = "group",
				inline = true,
				name = L["Delete"],
				args = {
					desc = {
						order = 1,
						type = "description",
						name = L["You can delete spells manually added through this, note that spells that are included with Afflicted by default cannot be deleted. All this will do is reset them to the default values."],
					},
					delete = {
						order = 2,
						type = "execute",
						name = L["Delete"],
						confirm = true,
						confirmText = L["Are you REALLY sure you want to delete this spell?"],
						func = function(info)
							Afflicted.db.profile.spells[info.arg] = nil
							
							local id = string.gsub(value, " ", "")
							options.args.spells.args[id] = nil
							options.args.spells.args.list.args[id] = nil
						end,
						arg = value,
					},
				},
			},
		},
	}
end

-- Spell list just for arenas
function Config:GetArenaSpellList(bracket)
	local options = {
		desc = {
			order = 0,
			name = L["Spells that should be DISABLED for this specific arena bracket.\nThis means do not check everything and then complain that it's broken."],
			type = "description",
			width = "full",
		},
		list = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Spell list"],
			args = {},
		},
	}

	local i = 0
	for id, data in pairs(Afflicted.db.profile.spells) do
		if( type(data) == "table" ) then
			i = i + 1

			-- If it's a spellID, either show the text because we've seen the spell, or show the spellID
			local text = id
			if( type(id) == "number" ) then
				if( data.text ) then
					text = data.text
				else
					text = string.format("#%d", tonumber(id))
				end
			end
			
			options.list.args[tostring(i)] = {
				order  = i,
				type = "toggle",
				name = text,
				desc = getArenaSpellInfo,
				arg = "disabledSpells." .. bracket .. "." .. id
			}
		end
	end
	
	return options
end

-- General options
local enabledIn = {["none"] = L["Everywhere else"], ["pvp"] = L["Battlegrounds"], ["arena"] = L["Arenas"], ["raid"] = L["Raid instances"], ["party"] = L["Party instances"]}

local function loadOptions()
	options = {}
	options.type = "group"
	options.name = "Afflicted"
	
	options.args = {}
	options.args.general = {
		type = "group",
		order = 1,
		name = L["General"],
		get = get,
		set = set,
		handler = Config,
		args = {
			enabled = {
				order = 0,
				type = "toggle",
				name = L["Hide timer anchors"],
				desc = L["Hides the anchors that lets you drag timer groups around."],
				set = function(info, value) Afflicted.db.profile.showAnchors = not value; Afflicted:Reload(); end,
				get = function() return not Afflicted.db.profile.showAnchors end,
				arg = "showAnchors",
			},
			showIcons = {
				order = 1,
				type = "toggle",
				name = L["Show spell icons"],
				desc = L["Prefixes messages with the spell icon if you're using local outputs."], 
				arg = "showIcons",
			},
			display = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Timer display"],
				args = {
					desc = {
						order = 0,
						name = L["Global display setting, changing these will change all the anchors settings."],
						type = "description",
					},
					growUp = {
						order = 1,
						type = "toggle",
						name = L["Grow display up"],
						desc = L["Instead of adding everything from top to bottom, timers will be shown from bottom to top."],
						get = getGlobalOption,
						set = setGlobalOption,
						width = "full",
						arg = "growUp",
					},
					showTarget = {
						order = 2,
						type = "toggle",
						name = L["Only show target/focus timers"],
						desc = L["Only timers of people you have targeted, or focused will be triggered. They will not be removed if you change targets however."],   
						width = "full",
						arg = "showTarget",
					},

					displayType = {
						order = 3,
						type = "select",
						name = L["Display style"],
						values = {[""] = "----", ["bar"] = L["Bars"], ["icon"] = L["Icons"]},
						get = getGlobalOption,
						set = setGlobalOption,
						arg = "displayType",
					},
					sep = {
						order = 4,
						name = "",
						type = "description",
					},
					scale = {
						order = 5,
						type = "range",
						name = L["Display scale"],
						desc = L["How big the actual timers should be."],
						min = 0, max = 2, step = 0.1,
						get = getGlobalOption,
						set = setGlobalOption,
						arg = "scale",
					},
					maxRows = {
						order = 6,
						type = "range",
						name = L["Max timers"],
						desc = L["Maximum amount of timers that should be ran per an anchor at the same time, if too many are running at the same time then the new ones will simply be hidden until older ones are removed."],
						min = 1, max = 50, step = 1,
						get = getGlobalOption,
						set = setGlobalOption,
						arg = "maxRows",
					},
					display = {
						order = 8,
						type = "group",
						inline = true,
						name = L["Bar only"],
						args = {
							desc = {
								order = 0,
								name = L["Configuration that only applies to bar displays."],
								type = "description",
							},
							nameOnly = {
								order = 1,
								type = "toggle",
								name = L["Only show triggered name in text"],
								desc = L["Instead of showing both the spell name and the triggered name, only the name will be shown in the bar."],
								width = "double",
								arg = "barNameOnly",
							},
							barWidth = {
								order = 2,
								type = "range",
								name = L["Bar width"],
								min = 0, max = 300, step = 1,
								set = setNumber,
								arg = "barWidth",
							},
							sep = {
								order = 3,
								name = "",
								type = "description",
							},
							barName = {
								order = 4,
								type = "select",
								name = L["Bar texture"],
								dialogControl = 'LSM30_Statusbar',
								values = "GetTextures",
								arg = "barName",
							},
						},
					},
				},
			},
			enabledIn = {
				order = 4,
				type = "multiselect",
				name = L["Enable Afflicted inside"],
				desc = L["Allows you to set what scenario's Afflicted should be enabled inside."],
				values = enabledIn,
				set = setMulti,
				get = getMulti,
				width = "double",
				arg = "inside"
			},
		},
	}
	
	options.args.alerts = {
		type = "group",
		order = 3,
		name = L["Alerts"],
		get = get,
		set = set,
		handler = Config,
		args = {
			dispel = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Dispels"],
				args = {
					dispelEnabled = {
						order = 1,
						type = "toggle",
						name = L["Enable dispel alerts"],
						desc = L["Displays alerts when you dispel a friendly player, can also be enabled to show alerts for enemies as well."],
						arg = "dispelEnabled",
					},
					dispelColor = {
						order = 2,
						type = "color",
						name = L["Text color"],
						desc = L["Alert text color, only applies to local outputs."],
						disabled = "IsDisabled",
						set = setColor,
						get = getColor,
						arg = "dispelColor",
					},
					dispelHostile = {
						order = 3,
						type = "toggle",
						name = L["Show alerts for dispelling enemies"],
						desc = L["Enables showing alerts for when you dispel enemies as well as friendly players."],
						width = "full",
						disabled = "IsDisabled",
						arg = "dispelHostile",
					},
					dispelDest = {
						order = 4,
						type = "select",
						name = L["Announce destination"],
						desc = L["Location to send announcements for this option to."],
						values = announceDest,
						disabled = "IsDisabled",
						arg = "dispelDest",
					},
				},
			},
			interrupt = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Interrupts"],
				args = {
					interruptEnabled = {
						order = 1,
						type = "toggle",
						name = L["Enable interrupt alerts"],
						desc = L["Displays alerts when you interrupt enemies."],
						arg = "interruptEnabled",
					},
					interruptColor = {
						order = 2,
						type = "color",
						name = L["Text color"],
						desc = L["Alert text color, only applies to local outputs."],
						disabled = "IsDisabled",
						set = setColor,
						get = getColor,
						arg = "interruptColor",
					},
					interruptDest = {
						order = 3,
						type = "select",
						name = L["Announce destination"],
						desc = L["Location to send announcements for this option to."],
						values = announceDest,
						disabled = "IsDisabled",
						arg = "interruptDest",
					},
				},
			},
		},
	}
	
	options.args.anchors = {
		type = "group",
		order = 4,
		name = L["Anchors"],
		get = get,
		set = set,
		handler = Config,
		args = {
			desc = {
				order = 0,
				name = L["Allows you to add a new anchor to Afflicted that you can then show timers under."],
				type = "description",
			},
			new = {
				order = 1,
				type = "input",
				name = L["Anchor name"],
				desc = L["Name of the new anchor to create that timers can be shown under."],
				validate = "ValidateAnchor",
				get = function() return "" end,
				set = "CreateAnchorDisplay",
			},
		},
	}
	
	-- Load our created anchors in
	for id, data in pairs(Afflicted.db.profile.anchors) do
		if( not data.text ) then
			data.text = id
		end
		
		Config:CreateAnchorDisplay(nil, data.text)
	end
	
	options.args.spells = {
		type = "group",
		order = 5,
		name = L["Spells"],
		get = get,
		set = set,
		handler = Config,
		args = {
			add = {
				order = 1,
				type = "group",
				inline = true,
				name = L["New spell"],
				args = {
					desc = {
						order = 0,
						name = L["Allows you to add a new spell that Afflicted should start tracking."],
						type = "description",
						width = "full",
					},
					new = {
						order = 1,
						type = "input",
						width = "full",
						name = L["Spell name or spell ID"],
						desc = L["The name of the spell, or the spell ID. This is note always the exact spell name, for example Intercept is actually Intercept Stun."],
						validate = "ValidateSpell",
						get = function() return "" end,
						set = "CreateSpellDisplay",
					},
				}
			},
			list = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Spell list"],
				args = {
					desc = {
						order = 0,
						name = L["Allows you to quickly enable or disable spells in Afflicted."],
						type = "description",
						width = "full",
					},
				}
			},
		},
	}

	options.args.arenaSpells = {
		type = "group",
		order = 6,
		name = L["Arena spells"],
		get = get,
		set = set,
		handler = Config,
		args = {
			two = {
				order = 1,
				type = "group",
				name = L["2 vs 2"],
			},
			three = {
				order = 1,
				type = "group",
				name = L["3 vs 3"],
			},
			five = {
				order = 1,
				type = "group",
				name = L["5 vs 5"],
			},
		},
	}
	
	options.args.arenaSpells.args.two.args = Config:GetArenaSpellList(2)
	options.args.arenaSpells.args.three.args = Config:GetArenaSpellList(3)
	options.args.arenaSpells.args.five.args = Config:GetArenaSpellList(5)
	
	-- Load our created anchors in
	for id, data in pairs(Afflicted.db.profile.spells) do
		if( type(data) == "table" ) then
			Config:CreateSpellDisplay(nil, id)
		end
	end
	
	-- DB Profiles
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(Afflicted.db)
	options.args.profile.order = 2
end

-- Slash commands
SLASH_AFFLICTED1 = "/afflicted"
SLASH_AFFLICTED2 = "/afflict"
SlashCmdList["AFFLICTED"] = function(msg)
	if( msg == "clear" ) then
		for name, data in pairs(Afflicted.db.profile.anchors) do
			Afflicted[data.displayType]:ClearTimers(name)
		end
	elseif( msg == "test" ) then
		-- Clear out any running timers first
		for name, data in pairs(Afflicted.db.profile.anchors) do
			Afflicted[data.displayType]:ClearTimers(name)
		end

		local i = 0
		local addedTypes = {}
		for spell, data in pairs(Afflicted.db.profile.spells) do
			if( type(data) == "table" ) then
				i = i + 1

				if( not addedTypes[data.showIn] ) then
					addedTypes[data.showIn] = 0
				end

				if( addedTypes[data.showIn] < 5 and not data.disabled ) then
					addedTypes[data.showIn] = addedTypes[data.showIn] + 1
					
					local anchor = Afflicted.db.profile.anchors[data.showIn]
					if( anchor.enabled ) then
						if( ( not data.icon or data.icon == "" ) and type(spell) == "number" ) then
							data.icon = select(3, GetSpellInfo(spell))
						end
						
						Afflicted[anchor.displayType]:CreateTimer(data, "TEST", -1, data.text or spell, i, UnitName("player"), i)
					end
				end
			end
		end

	elseif( msg == "ui" ) then
		if( not registered ) then
			if( not options ) then
				loadOptions()
			end
			
			config:RegisterOptionsTable("Afflicted2", options)
			dialog:SetDefaultSize("Afflicted2", 625, 590)
			registered = true
		end

		dialog:Open("Afflicted2")
	else
		DEFAULT_CHAT_FRAME:AddMessage(L["Afflicted slash commands"])
		DEFAULT_CHAT_FRAME:AddMessage(L["- clear - Clears all running timers."])
		DEFAULT_CHAT_FRAME:AddMessage(L["- test - Shows test timers in Afflicted."])
		DEFAULT_CHAT_FRAME:AddMessage(L["- ui - Opens the configuration for Afflicted."])
	end
end

-- CONFIGURATION SYNCING WITH BAZAAR
function Config:Receive(data, categories)
	local self = Afflicted
	
	if( categories.general ) then
		for key, value in pairs(data.general) do
			self.db.profile[key] = value
		end
	end
	
	if( categories.spells ) then
		self.db.profile.spells = data.spells
	end
	
	if( categories.arenaSpells ) then
		self.db.profile.arenaSpells = data.arenaSpells
	end
	
	if( categories.anchors ) then
		self.db.profile.anchors = data.anchors
	end
	
	Afflicted:Reload()
end

local blacklist = {["anchorDefault"] = true, ["disabledSpells"] = true, ["anchors"] = true, ["spellDefault"] = true}
function Config:Send(categories)
	local config = {}
	local self = Afflicted
	if( categories.general ) then
		config.general = {}
		for key, value in pairs(self.db.profile) do
			if( not blacklist[key] ) then
				if( type(value) == "table" ) then
					config.general[key] = CopyTable(value)
				else
					config.general[key] = value
				end
			end
		end
	end
	
	if( categories.spells ) then
		config.spells = CopyTable(self.db.profile.spells)
	end
	
	if( categories.arenaSpells ) then
		config.arenaSpells = CopyTable(self.db.profile.disabledSpells)
	end
	
	if( categories.anchors ) then
		config.anchors = CopyTable(self.db.profile.anchors)
	end
	
	return config
end

if( Bazaar ) then
	local obj = Bazaar:RegisterAddOn("Afflicted")
	obj:RegisterCategory("general", "General")
	obj:RegisterCategory("spells", "Spells")
	obj:RegisterCategory("arenaSpells", "Arena only spells")
	obj:RegisterCategory("anchors", "Anchors")
	
	obj:RegisterReceiveHandler(Config, "Receive")
	obj:RegisterSendHandler(Config, "Send")
end