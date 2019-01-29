if( not ExtendedUF ) then return end

local Config = ExtendedUF:NewModule("Config")
local addonVersion = tonumber(string.match(GetAddOnMetadata("ExtendedUF", "Version"), "(%d+)") or 1)

--common functions for options callbacks
local function get(info)
	local arg1, arg2, arg3 = string.split(".", info.arg)
	
	if (arg2 and arg3) then
		return ExtendedUF.db.profile[arg1][arg2][arg3]
	elseif (arg2) then
		return ExtendedUF.db.profile[arg1][arg2]
	else
		return ExtendedUF.db.profile[arg1]
	end
end

local function set(info, value)
	local arg1, arg2, arg3 = string.split(".", info.arg)
	
	if (arg2 and arg3) then
		ExtendedUF.db.profile[arg1][arg2][arg3] = value
	elseif (arg2) then
		ExtendedUF.db.profile[arg1][arg2] = value
	else
		ExtendedUF.db.profile[arg1] = value
	end
	
	ExtendedUF:ReloadVisual(info.arg)
end

local function getCVar(info)
	local value = GetCVar(info.arg)
	if (value == "1") then
		return true
	else
		return false
	end
end

local function getTextures()
	local textures = {}
	for _, name in pairs(ExtendedUF.media:List(ExtendedUF.media.MediaType.STATUSBAR)) do
		textures[name] = name
	end
	
	return textures
end

local CVarEvents = {
	playerStatusText = "STATUS_TEXT_PLAYER",
	petStatusText = "STATUS_TEXT_PET",
	partyStatusText = "STATUS_TEXT_PARTY",
	targetStatusText = "STATUS_TEXT_TARGET",
	ShowTargetCastbar = "SHOW_TARGET_CASTBAR",
}

local function setCVar(info, value)
	local CVarEvent = CVarEvents[info.arg]
	if (value) then
		SetCVar(info.arg, "1", CVarEvent)
	else
		SetCVar(info.arg, "0", CVarEvent)
	end
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

local function slashHandler(option)
	if option == "menu" then
		InterfaceOptionsFrame_OpenToFrame("Extended Unit Frames")
	elseif option == "lock" then
		set({arg="lock"}, not ExtendedUF.db.profile.lock)
	else
		ExtendedUF:Print("Revision "..addonVersion)
		ExtendedUF:Print("/extendeduf lock")
		ExtendedUF:Print("/extendeduf menu")
	end
end

function Config:SetupDB()	
	ExtendedUF.media = LibStub:GetLibrary("LibSharedMedia-3.0")
	ExtendedUF.media:Register(ExtendedUF.media.MediaType.STATUSBAR, "Smooth", "Interface\\Addons\\ExtendedUF\\textures\\smooth")
	ExtendedUF.media:Register(ExtendedUF.media.MediaType.STATUSBAR, "Perl", "Interface\\Addons\\ExtendedUF\\textures\\perl")
	ExtendedUF.media:Register(ExtendedUF.media.MediaType.STATUSBAR, "Glaze", "Interface\\Addons\\ExtendedUF\\textures\\glaze")
	ExtendedUF.media:Register(ExtendedUF.media.MediaType.STATUSBAR, "Charcoal", "Interface\\Addons\\ExtendedUF\\textures\\Charcoal")
	ExtendedUF.media:Register(ExtendedUF.media.MediaType.STATUSBAR, "Otravi", "Interface\\Addons\\ExtendedUF\\textures\\otravi")
	ExtendedUF.media:Register(ExtendedUF.media.MediaType.STATUSBAR, "LiteStep", "Interface\\Addons\\ExtendedUF\\textures\\LiteStep")
		
	local defaults = {
		profile = {
			statusText = {
				playerHP = "[FractionalHP]",
				playerMP = "[FractionalMP]",
				targetHP = "[FractionalHP]",
				targetMP = "[FractionalMP]",
				focusHP = "[FractionalHP]",
				focusMP = "[FractionalMP]",
				partyHP = "[FractionalHP]",
				partyMP = "[FractionalMP]",
				petHP = "[HP]",
				petMP = "[MP]",
			},
			texture = "Blizzard",
			lock = true,
			showFocus = true,
			showTargetofParty = true,
			zoomedInIcons = true,
			showFocusCastbar = true,
			showPartyCastbar = true,
			showFocusStatustext = true,
			showTargetClassIcon = true,
			showFocusClassIcon = true,
			showPartyClassIcon = true,
			smallTextOutline = true,
			--smallBuffSize = SMALL_BUFF_SIZE,
			--largeBuffSize = LARGE_BUFF_SIZE,
			minHpColor = { r = 1.0, g = 0.0, b = 0.0 },
			midHpColor = { r = 1.0, g = 1.0, b = 0.0 },
			maxHpColor = { r = 0.0, g = 1.0, b = 0.0 },
		},
	}
	
	ExtendedUF.db = LibStub:GetLibrary("AceDB-3.0"):New("ExtendedUFDB", defaults)
	
	-- Upgrade
	--[[
	if (ExtendedUF.db.profile.version) then
		if (ExtendedUF.db.profile.version <= 65) then
		end
	end
	]]
	
	if (not ExtendedUF.db.profile.version) then
		SetCVar("playerStatusText", "1", CVarEvents["playerStatusText"])
		SetCVar("targetStatusText", "1", CVarEvents["targetStatusText"])
		SetCVar("partyStatusText", "1", CVarEvents["partyStatusText"])
		SetCVar("petStatusText", "1", CVarEvents["petStatusText"])
	end
	
	ExtendedUF.db.profile.version = addonVersion
		
	if (ExtendedUF.media:Fetch(ExtendedUF.media.MediaType.STATUSBAR, ExtendedUF.db.profile.texture) ~= ExtendedUF.media:Fetch(ExtendedUF.media.MediaType.STATUSBAR, "Blizzard")) then
		ExtendedUF:ReloadVisual("texture")
	else
		ExtendedUF.media.RegisterCallback(Config, "LibSharedMedia_Registered")
	end
	
	local options = {}
	options.general = {
		type = "group",
		name = "Extended Unit Frames",
        get = get,
        set = set,
		args = {
			lock = {
				order = 1,
				name = "Locked frames",
				type = "toggle",
				arg = "lock",
			},
			zoomedInIcons = {
				order = 2,
				name = "Zoomed in icons",
				type = "toggle",
				arg = "zoomedInIcons",
			},
			showFocus = {
				order = 3,
				name = "Enable focus",
				type = "toggle",
				arg = "showFocus",
			},
			showTargetofParty = {
				order = 4,
				name = "Enable party targets",
				type = "toggle",
				arg = "showTargetofParty",
			},
			showTargetCastbar = {
				order = 5,
				name = "Show target castbar",
				type = "toggle",
				arg = "ShowTargetCastbar",
				get = getCVar,
				set = setCVar,
			},
			showFocusCastbar = {
				order = 6,
				name = "Show focus castbar",
				type = "toggle",
				arg = "showFocusCastbar",
			},
			showPartyCastbar = {
				order = 7,
				name = "Show party castbar",
				type = "toggle",
				arg = "showPartyCastbar",
			},
			showTargetClassIcon = {
				order = 8,
				name = "Show target class icon",
				type = "toggle",
				arg = "showTargetClassIcon",
			},
			showFocusClassIcon = {
				order = 9,
				name = "Show focus class icon",
				type = "toggle",
				arg = "showFocusClassIcon",
			},
			showPartyClassIcon = {
				order = 10,
				name = "Show party class icon",
				type = "toggle",
				arg = "showPartyClassIcon",
			},
			smallTextOutline = {
				order = 11,
				name = "Small text outline",
				type = "toggle",
				arg = "smallTextOutline",
				width = "double",
			},
			--[[
			smallBuffSize = {
				order = 12,
				name = "Small buff size",
				type = "range",
				min = 10, max = 34, step = 1,
				arg = "smallBuffSize",
			},
			largeBuffSize = {
				order = 13,
				name = "Large buff size",
				type = "range",
				min = 10, max = 34, step = 1,
				arg = "largeBuffSize",
			},
			]]
			texture = {
				order = 12,
				type = "select",
				name = "Statusbar texture",
				dialogControl = 'LSM30_Statusbar',
				values = getTextures,
				arg = "texture",
				width = "double",
			},
			maxHpColor = {
				order = 13,
				type = "color",
				name = "Full hp color",
				set = setColor,
				get = getColor,
				arg = "maxHpColor",
			},
			midHpColor = {
				order = 14,
				type = "color",
				name = "Medium hp color",
				set = setColor,
				get = getColor,
				arg = "midHpColor",
			},
			minHpColor = {
				order = 15,
				type = "color",
				name = "Empty hp color",
				set = setColor,
				get = getColor,
				arg = "minHpColor",
			},
		}
	}
	
	options.texts = {
		type = "group",
		name = "Status Texts",
        get = get,
        set = set,
		args = {
			visiblity = {
				order = 1,
				type = "group",
				name = "Visibility",
				inline = true,
				args = {
					showPlayerStatusText = {
						order = 1,
						name = "Player",
						type = "toggle",
						arg = "playerStatusText",
						get = getCVar,
						set = setCVar,
						width = "double",
					},
					showTargetStatusText = {
						order = 2,
						name = "Target",
						type = "toggle",
						arg = "targetStatusText",
						get = getCVar,
						set = setCVar,
						width = "double",
					},
					showFocusStatusText = {
						order = 3,
						name = "Focus",
						type = "toggle",
						arg = "showFocusStatusText",
						width = "double",
					},
					showPartyStatusText = {
						order = 4,
						name = "Party",
						type = "toggle",
						arg = "partyStatusText",
						get = getCVar,
						set = setCVar,
						width = "double",
					},
					showPetStatusText = {
						order = 5,
						name = "Pet",
						type = "toggle",
						arg = "petStatusText",
						get = getCVar,
						set = setCVar,
						width = "double",
					},
				}
			},
			playerHP = {
				order = 2,
				name = "Player health",
				type = "input",
				arg = "statusText.playerHP",
			},
			playerMP = {
				order = 3,
				name = "Player mana",
				type = "input",
				arg = "statusText.playerMP",
			},
			targetHP = {
				order = 4,
				name = "Target health",
				type = "input",
				arg = "statusText.targetHP",
			},
			targetMP = {
				order = 5,
				name = "Target mana",
				type = "input",
				arg = "statusText.targetMP",
			},
			focusHP = {
				order = 6,
				name = "Focus health",
				type = "input",
				arg = "statusText.focusHP",
			},
			focusMP = {
				order = 7,
				name = "Focus mana",
				type = "input",
				arg = "statusText.focusMP",
			},
			partyHP = {
				order = 8,
				name = "Party health",
				type = "input",
				arg = "statusText.partyHP",
			},
			partyMP = {
				order = 9,
				name = "Party mana",
				type = "input",
				arg = "statusText.partyMP",
			},
			petHP = {
				order = 10,
				name = "Pet health",
				type = "input",
				arg = "statusText.petHP",
			},
			petMP = {
				order = 11,
				name = "Pet mana",
				type = "input",
				arg = "statusText.petMP",
			},
		}
	}
	
	local config = LibStub("AceConfigRegistry-3.0")
	local dialog = LibStub("AceConfigDialog-3.0")
	
	config:RegisterOptionsTable("Extended Unit Frames", options.general)
	dialog:AddToBlizOptions("Extended Unit Frames", options.general.name)
	
	config:RegisterOptionsTable("Extended Unit Frames-Texts", options.texts)
	dialog:AddToBlizOptions("Extended Unit Frames-Texts", options.texts.name, "Extended Unit Frames")
	
	local console = LibStub("AceConsole-3.0")
	console:RegisterChatCommand("extendedunitframes", slashHandler)
	console:RegisterChatCommand("extendeduf", slashHandler)
	console:RegisterChatCommand("euf", slashHandler)
end

function Config:LibSharedMedia_Registered(event, mediatype, key)
	if (mediatype == "statusbar" and key == ExtendedUF.db.profile.texture) then
		ExtendedUF:ReloadVisual("texture")
		ExtendedUF.media.UnregisterCallback(Config, "LibSharedMedia_Registered")
	end
end
