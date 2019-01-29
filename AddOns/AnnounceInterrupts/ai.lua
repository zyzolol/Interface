
local staticInterruptMessage = "Interrupted %sl!"

local options = {}
local f = CreateFrame("frame")
local L = AnnounceInterrupts_Locales

local config = CreateFrame("Frame")
local configOpenRunOnce = false


local function printFormattedString(destName, spellID, spellName, spellSchool, spellInterruptedID)
	local msg = staticInterruptMessage
	msg = msg:gsub("%%t", destName):gsub("%%sn", spellName):gsub("%%sc", CombatLog_String_SchoolString(spellSchool)):gsub("%%sl", GetSpellLink(spellInterruptedID)):gsub("%%ys", GetSpellLink(spellID))
	if options.channel == "SELF" then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	else
		local ec = options.channelExtra
		local announceChannel = options.channel
		if options.channel == "CHANNEL" and options.channelExtra then
			ec = GetChannelName(options.channelExtra)
		end

		--if options.smartChannel then
		--	local inInstance, instanceType = IsInInstance()
		--	if announceChannel == "RAID" and not (instanceType == "raid") then
		--		announceChannel = "PARTY"
		--	end
        --
		--	if announceChannel == "PARTY" and not (instanceType == "party") then
		--		announceChannel = "SAY"
		--	end
        --
		--	if announceChannel == "CHANNEL" and ec == 0 then
		--		announceChannel = "SAY"
		--	end
		--end

		SendChatMessage(msg, announceChannel, nil, ec)
	end
end

local function registerEvents()
	if options.enabled then
		local inInstance, instanceType = IsInInstance()
		if instanceType == "arena" and options.inArena then
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif inInstance and instanceType == "party" and options.inParty then
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif instanceType == "pvp" and options.inBG then
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif instanceType == "raid" and options.inRaid then
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif ( instanceType == "none"  or (not inInstance and instanceType == "party")) and options.outdoors then  -- Fix for garrison
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif instanceType == "scenario" and options.inScenario then
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		else
			f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
	else
		f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

local function selectIdFromChannelName(cname)
	if cname == "SAY" then
		return 1
	elseif cname == "RAID" then
		return 2
	elseif cname == "PARTY" then
		return 3
	elseif cname == "YELL" then
		return 4
	elseif cname == "SELF" then
		return 5
	elseif cname == "EMOTE" then
		return 6
	elseif cname == "WHISPER" then
		return 7
	elseif cname == "CHANNEL" then
		return 8
	end
	return 1
end

local function getBoolean(val)
	if val then
		return true
	else
		return false
	end
end

local function setupAIConfig(c)
	if configOpenRunOnce then
		return
	end

	configOpenRunOnce = true

	config.name = "Announce Interrupts"

	config.title = config:CreateFontString("AIconfigTitleFont", "ARTWORK", "GameFontNormal")
	config.title:SetFont(GameFontNormal:GetFont(), 16, "OUTLINE")
	config.title:SetPoint("TOPLEFT", config, 10, -10)
	config.title:SetText(config.name)

	config.enablebox = CreateFrame("CheckButton", "AIenableButton", config, "InterfaceOptionsCheckButtonTemplate")
	config.enablebox:SetPoint("TOPLEFT", config, 10, -28)
	config.enablebox:SetChecked(options.enabled)
	config.enablebox:SetHitRectInsets(0, -200, 0, 0)
	config.enableboxtitle = config:CreateFontString("AIconfigEnableboxFont", "ARTWORK", "GameFontNormal")
	config.enableboxtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	config.enableboxtitle:SetPoint("LEFT", config.enablebox, 30, 0)
	config.enableboxtitle:SetText("|cffffffff" .. L.enable_addon .. "|r")


	config.raidbox = CreateFrame("CheckButton", "AIraidButton", config, "InterfaceOptionsCheckButtonTemplate")
	config.raidbox:SetPoint("TOPLEFT", config, 10, -68)
	config.raidbox:SetChecked(options.inRaid)
	config.raidbox:SetHitRectInsets(0, -200, 0, 0)
	config.raidboxtitle = config:CreateFontString("AIconfigraidboxFont", "ARTWORK", "GameFontNormal")
	config.raidboxtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	config.raidboxtitle:SetPoint("LEFT", config.raidbox, 30, 0)
	config.raidboxtitle:SetText("|cffffffff" .. L.active_raid .. "|r")

	config.partybox = CreateFrame("CheckButton", "AIpartyButton", config, "InterfaceOptionsCheckButtonTemplate")
	config.partybox:SetPoint("TOPLEFT", config, 10, -88)
	config.partybox:SetChecked(options.inParty)
	config.partybox:SetHitRectInsets(0, -200, 0, 0)
	config.partyboxtitle = config:CreateFontString("AIconfigpartyboxFont", "ARTWORK", "GameFontNormal")
	config.partyboxtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	config.partyboxtitle:SetPoint("LEFT", config.partybox, 30, 0)
	config.partyboxtitle:SetText("|cffffffff" .. L.active_party .. "|r")

	config.bgbox = CreateFrame("CheckButton", "AIbgButton", config, "InterfaceOptionsCheckButtonTemplate")
	config.bgbox:SetPoint("TOPLEFT", config, 10, -108)
	config.bgbox:SetChecked(options.inBG)
	config.bgbox:SetHitRectInsets(0, -200, 0, 0)
	config.bgboxtitle = config:CreateFontString("AIconfigbgboxFont", "ARTWORK", "GameFontNormal")
	config.bgboxtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	config.bgboxtitle:SetPoint("LEFT", config.bgbox, 30, 0)
	config.bgboxtitle:SetText("|cffffffff" .. L.active_BG .. "|r")

	config.arenabox = CreateFrame("CheckButton", "AIarenaButton", config, "InterfaceOptionsCheckButtonTemplate")
	config.arenabox:SetPoint("TOPLEFT", config, 10, -128)
	config.arenabox:SetChecked(options.inArena)
	config.arenabox:SetHitRectInsets(0, -200, 0, 0)
	config.arenaboxtitle = config:CreateFontString("AIconfigarenaboxFont", "ARTWORK", "GameFontNormal")
	config.arenaboxtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	config.arenaboxtitle:SetPoint("LEFT", config.arenabox, 30, 0)
	config.arenaboxtitle:SetText("|cffffffff" .. L.active_arena .. "|r")

	local robinYOffset = 20
	--config.scenariobox = CreateFrame("CheckButton", "AIscenarioButton", config, "InterfaceOptionsCheckButtonTemplate")
	--config.scenariobox:SetPoint("TOPLEFT", config, 10, -148)
	--config.scenariobox:SetChecked(options.inScenario)
	--config.scenariobox:SetHitRectInsets(0, -200, 0, 0)
	--config.scenarioboxtitle = config:CreateFontString("AIconfigscenarioboxFont", "ARTWORK", "GameFontNormal")
	--config.scenarioboxtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	--config.scenarioboxtitle:SetPoint("LEFT", config.scenariobox, 30, 0)
	--config.scenarioboxtitle:SetText("|cffffffff" .. L.active_scenario .. "|r")

	config.outdoorbox = CreateFrame("CheckButton", "AIoutdoorButton", config, "InterfaceOptionsCheckButtonTemplate")
	config.outdoorbox:SetPoint("TOPLEFT", config, 10, -168 + robinYOffset)
	config.outdoorbox:SetChecked(options.outdoors)
	config.outdoorbox:SetHitRectInsets(0, -200, 0, 0)
	config.outdoorboxtitle = config:CreateFontString("AIconfigoutdoorboxFont", "ARTWORK", "GameFontNormal")
	config.outdoorboxtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	config.outdoorboxtitle:SetPoint("LEFT", config.outdoorbox, 30, 0)
	config.outdoorboxtitle:SetText("|cffffffff" .. L.active_outdoors .. "|r")

	robinYOffset = robinYOffset + 23
	--config.petbox = CreateFrame("CheckButton", "AIpetButton", config, "InterfaceOptionsCheckButtonTemplate")
	--config.petbox:SetPoint("TOPLEFT", config, 10, -198 + robinYOffset)
	--config.petbox:SetChecked(options.includePets)
	--config.petbox:SetHitRectInsets(0, -200, 0, 0)
	--config.petboxtitle = config:CreateFontString("AIpetboxFont", "ARTWORK", "GameFontNormal")
	--config.petboxtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	--config.petboxtitle:SetPoint("LEFT", config.petbox, 30, 0)
	--config.petboxtitle:SetText("|cffffffff" .. L.include_pet_interrupts .. "|r")

	config.channeltitle = config:CreateFontString("AIconfigchanneltitleFont", "ARTWORK", "GameFontNormal")
	config.channeltitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	config.channeltitle:SetPoint("TOPLEFT", config, 10, -233 + robinYOffset)
	config.channeltitle:SetText("|cffffffff" .. L.channel .. "|r")

	config.channeldropdown = CreateFrame("Button", "AIchannelDropdown", config, "Lib_UIDropDownMenuTemplate")
	config.channeldropdown:SetPoint("TOPLEFT", config, 10, -253 + robinYOffset)

	Lib_UIDropDownMenu_Initialize(config.channeldropdown, function(self, level)   
		local info = Lib_UIDropDownMenu_CreateInfo()
		local channelOptions = {
			L.channel_say,
			L.channel_raid,
			L.channel_party,
			L.channel_yell,
			L.channel_self,
			L.channel_emote,
			L.channel_whisper,
			L.channel_custom
		}
		for k,v in pairs(channelOptions) do
			info = Lib_UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = function(self) Lib_UIDropDownMenu_SetSelectedID(config.channeldropdown, self:GetID()) if self:GetID() < 7 then config.channelextrabox:Hide() else config.channelextrabox:Show() end end
			Lib_UIDropDownMenu_AddButton(info, level)
		end 
	end)
	Lib_UIDropDownMenu_SetSelectedID(config.channeldropdown, selectIdFromChannelName(options.channel))

	config.channelextrabox = CreateFrame("EditBox", "AIextrachannelbox", config.channeldropdown, "InputBoxTemplate")
	config.channelextrabox:SetPoint("RIGHT", 250, 2)
	config.channelextrabox:SetWidth(130)
	config.channelextrabox:SetHeight(25)
	config.channelextrabox:SetAutoFocus(false)
	config.channelextrabox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	if Lib_UIDropDownMenu_GetSelectedID(config.channeldropdown) < 7 then
		config.channelextrabox:Hide()
	end
	config.channelextrabox:SetText(options.channelExtra)
	config.channelextrabox:SetCursorPosition(0)


	--config.smartbox = CreateFrame("CheckButton", "AIsmartChannelButton", config, "InterfaceOptionsCheckButtonTemplate")
	--config.smartbox:SetPoint("TOPLEFT", config, 10, -283 + robinYOffset)
	--config.smartbox:SetChecked(options.smartChannel)
	--config.smartbox:SetHitRectInsets(0, -200, 0, 0)

	--config.smartbox:SetScript("OnEnter", function(self)   
	--	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
	--	GameTooltip:SetText(L.smart_channel)
	--	GameTooltip:AddLine(L.smart_details, 1, 1, 1)
	--	
	--	GameTooltip:Show() 
	--end)

	--config.smartbox:SetScript("OnLeave", function(self) GameTooltip:Hide() end)


	--config.smartboxtitle = config:CreateFontString("AIconfigsmartboxFont", "ARTWORK", "GameFontNormal")
	--config.smartboxtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	--config.smartboxtitle:SetPoint("LEFT", config.smartbox, 30, 0)
	--config.smartboxtitle:SetText("|cffffffff" .. L.smart_channel .. "|r")

	--config.outputtitle = config:CreateFontString("AIconfigoutputtitleFont", "ARTWORK", "GameFontNormal")
	--config.outputtitle:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
	--config.outputtitle:SetPoint("TOPLEFT", config, 10, -318 + robinYOffset)
	--config.outputtitle:SetText("|cffffffff" .. L.output .. "|r")

	--config.outputbox = CreateFrame("EditBox", "AIoutputbox", config, "InputBoxTemplate")
	--config.outputbox:SetPoint("TOPLEFT", config, 20, -338 + robinYOffset)
	--config.outputbox:SetWidth(250)
	--config.outputbox:SetHeight(25)
	--config.outputbox:SetAutoFocus(false)
	--config.outputbox:SetMultiLine(false)
	--config.outputbox:SetText(options.message)
	--config.outputbox:SetCursorPosition(0)
	--config.outputbox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

	--config.hints = config:CreateFontString("AIconfighintFont", "ARTWORK", "GameFontNormal")
	--config.hints:SetFont(GameFontNormal:GetFont(), 10, "OUTLINE")
	--config.hints:SetPoint("TOPLEFT", config, 12, -368 + robinYOffset)
	--config.hints:SetText("|cffffffff" .. L.hint .. "|r")
	--config.hints:SetJustifyH("LEFT")


	config.okay = function(self)
		AnnounceInterruptsDB.enabled = getBoolean(config.enablebox:GetChecked())
		AnnounceInterruptsDB.inRaid = getBoolean(config.raidbox:GetChecked())
		AnnounceInterruptsDB.inParty = getBoolean(config.partybox:GetChecked())
		AnnounceInterruptsDB.inArena = getBoolean(config.arenabox:GetChecked())
		--AnnounceInterruptsDB.inScenario = getBoolean(config.scenariobox:GetChecked())
		AnnounceInterruptsDB.inBG = getBoolean(config.bgbox:GetChecked())
		AnnounceInterruptsDB.outdoors = getBoolean(config.outdoorbox:GetChecked())
		--AnnounceInterruptsDB.includePets = getBoolean(config.petbox:GetChecked())
		--AnnounceInterruptsDB.smartChannel = getBoolean(config.smartbox:GetChecked())
		AnnounceInterruptsDB.message = staticInterruptMessage
		AnnounceInterruptsDB.channelExtra = config.channelextrabox:GetText()
		local channelOptions = {
			"SAY",
			"RAID",
			"PARTY",
			"YELL",
			"SELF",
			"EMOTE",
			"WHISPER",
			"CHANNEL"
		}
		AnnounceInterruptsDB.channel = channelOptions[Lib_UIDropDownMenu_GetSelectedID(config.channeldropdown)]

		options = AnnounceInterruptsDB
		registerEvents()

	end

	config.cancel = function(self)
		config.enablebox:SetChecked(options.enabled)
		config.raidbox:SetChecked(options.inRaid)
		config.partybox:SetChecked(options.inParty)
		config.bgbox:SetChecked(options.inBG)
		--config.scenariobox:SetChecked(options.inScenario)
		config.arenabox:SetChecked(options.inArena)
		config.outdoorbox:SetChecked(options.outdoors)
		--config.petbox:SetChecked(options.includePets)
		--config.smartbox:SetChecked(options.smartChannel)
		--config.outputbox:SetText(options.message)
		config.channelextrabox:SetText(options.channelExtra)
		Lib_UIDropDownMenu_SetSelectedID(config.channeldropdown, selectIdFromChannelName(options.channel))
	end

	InterfaceOptions_AddCategory(config)

end


f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)


function f:COMBAT_LOG_EVENT_UNFILTERED(...)
	local _, eventType, _, sourceName, _, _, destName, _, spellID, spellName, spellSchool, spellInterruptedID = ...
	--if sourceName == UnitName("player") or ( options.includePets and sourceName == UnitName("pet") ) then
	if sourceName == UnitName("player") then
		if eventType == "SPELL_INTERRUPT" then
			printFormattedString(destName, spellID, spellName, spellSchool, spellInterruptedID)
		end
	end
end

function f:PLAYER_ENTERING_WORLD()
	registerEvents()
end

function f:PLAYER_LOGIN()
	setupAIConfig()
end

function f:ADDON_LOADED(addon)
    if addon ~= "AnnounceInterrupts" then return end

    local defaults = {
		channel = "SAY",
		channelExtra = "",
		enabled = true,
		inRaid = true,
		inParty = true,
		inBG = true,
		inArena = true,
		inScenario = true,
		outdoors = true,
		--includePets = true,
		--smartChannel = false,
		printedOnce = false,
		message = L.defualt_message
	}

	AnnounceInterruptsDB = AnnounceInterruptsDB or {}

	for k,v in pairs(defaults) do
		if AnnounceInterruptsDB[k] == nil then
			AnnounceInterruptsDB[k] = v
		end
	end

	options = AnnounceInterruptsDB

	-- This is where config setup used to be


	SLASH_ANNOUNCEINTERRUPTS1, SLASH_ANNOUNCEINTERRUPTS2 = "/ai", "/announceinterrupts"
	SlashCmdList.ANNOUNCEINTERRUPTS = function(msg)
		InterfaceOptionsFrame_Show()
		InterfaceOptionsFrame_OpenToCategory(config)
	end



	f:RegisterEvent("PLAYER_LOGIN")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	registerEvents()

	
	if not AnnounceInterruptsDB.printedOnce then
		DEFAULT_CHAT_FRAME:AddMessage("|cff3399FF" .. L.welcome_message .. "|r")
		AnnounceInterruptsDB.printedOnce = true
	end

end

f:RegisterEvent("ADDON_LOADED")
