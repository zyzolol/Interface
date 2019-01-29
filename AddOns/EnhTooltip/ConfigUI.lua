--[[
	EnhTooltip - Additional function hooks to allow hooks into more tooltips
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: ConfigUI.lua 3481 2008-09-12 14:39:29Z anaral $
	URL: http://auctioneeraddon.com/dl/EnhTooltip

	AucModule functions

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
data layout:
		EnhTooltipConfig = {

			["profile.test4"] = {
				["miniicon.distance"] = 56,
				["miniicon.angle"] = 189,
				["show"] = true,
				["enable"] = true,
			},

			["profiles"] = {
				"Default", -- [1]
				"test4", -- [2]
			},

			["users.Foobar.Picksell"] = "test4",

			["profile.Default"] = {
				["miniicon.angle"] = 187,
				["miniicon.distance"] = 15,
			},

		}

if user does not have a set profile name, they get the default profile


Usage:
	def = EnhTooltip.Settings.GetDefault('suppressEnhancedTooltip')
	val = EnhTooltip.Settings.GetSetting('suppressEnhancedTooltip')
	EnhTooltiprix.Settings.SetSetting('suppressEnhancedTooltip', true );
]]

-- TODO
-- Remove debug output
-- Add self reliant locale strings

--Allows EhTT sub lua's sccess to functions and settings in other EhTT files. This also makes private.Print accessable from all EhTT luas
local private = EnhTooltip.Private

EnhTooltip.Settings = {}
local lib = EnhTooltip.Settings

local gui

local function processSetting(setting, action, value)
	if action == "getsetting" then
		return EnhTooltip.Settings.GetSetting(setting)
	end
	if action == "set" then
		EnhTooltip.Settings.SetSetting(setting, value)
	end
end

local function enhancedTooltipForceShow(action, value)
	if action == "getsetting" then
		return EnhTooltip.Settings.GetSetting("forceSuppresedTooltipKey") == "alt"
	end
	if action == "set" then
		if value then
			EnhTooltip.Settings.SetSetting("forceSuppresedTooltipKey","alt")
		else
			EnhTooltip.Settings.SetSetting("forceSuppresedTooltipKey","off")
		end
	end
end

local function getUserSig()
	local userSig = string.format("users.%s.%s", GetRealmName(), UnitName("player"))
	return userSig
end

local function getUserProfileName()
	if (not EnhTooltipConfig) then EnhTooltipConfig = {} end
	local userSig = getUserSig()
	return EnhTooltipConfig[userSig] or "Default"
end

local function getUserProfile()
	if (not EnhTooltipConfig) then EnhTooltipConfig = {} end
	local profileName = getUserProfileName()
	if (not EnhTooltipConfig["profile."..profileName]) then
		if profileName ~= "Default" then
			profileName = "Default"
			EnhTooltipConfig[getUserSig()] = "Default"
		end
		if profileName == "Default" then
			EnhTooltipConfig["profile."..profileName] = {}
		end
	end
	return EnhTooltipConfig["profile."..profileName]
end


local function cleanse( profile )
	if (profile) then
		profile = {}
	end
end


-- Default setting values
local settingDefaults = {
		suppressEnhancedTooltip = false,
		forceSuppresedTooltipKey = "alt",
		showWithAuction = true,
		showWithBagsAndKeyRing = true,
		showWithBagBar = true,
		showWithBank = true,
		showWithCharacterInventory = true,
		showWithChatHyperlink = true,
		showWithGuildBank = true,
		showWithLootAndLootRoll = true,
		showWithMail = true,
		showWithMerchants = true,
		showWithProfessions = true,
		showWithQuests = true,
		showWithTrade = true,
		showWithOther = true,
		blockExternalCalls = false;
	}

local function getDefault(setting)
	local a,b,c = strsplit(".", setting)

	-- basic settings
	if (a == "show") then return true end
	if (b == "enable") then return true end
	
	-- lookup the simple settings
	local result = settingDefaults[setting];
	return result
end

function lib.GetDefault(setting)
	local val = getDefault(setting);
	return val;
end

local function setter(setting, value)
	if (not EnhTooltipConfig) then EnhTooltipConfig = {} end

	-- turn value into a canonical true or false
	if value == 'on' then
		value = true
	elseif value == 'off' then
		value = false
	end

	-- is the setting actually a function ref? if so call it.
	-- This was added to enable Protect Window to update its
	-- status without a UI reload by calling a function rather
	-- than a setting in the Control definition.
	if (type(setting)=="function") or (type(setting)=="table" and setting.setting) then
		return setting("set", value)
	end

	-- for defaults, just remove the value and it'll fall through
	if (value == 'default') or (value == getDefault(setting)) then
		-- Don't save default values
		value = nil
	end

	local a,b,c = strsplit(".", setting)
	if (a == "profile") then
		if (setting == "profile.save") then
			value = gui.elements["profile.name"]:GetText()

			-- Create the new profile
			EnhTooltipConfig["profile."..value] = {}

			-- Set the current profile to the new profile
			EnhTooltipConfig[getUserSig()] = value
			-- Get the new current profile
			local newProfile = getUserProfile()

			-- Clean it out and then resave all data
			cleanse(newProfile)
			gui:Resave()

			-- Add the new profile to the profiles list
			local profiles = EnhTooltipConfig["profiles"]
			if (not profiles) then
				profiles = { "Default" }
				EnhTooltipConfig["profiles"] = profiles
			end

			-- Check to see if it already exists
			local found = false
			for pos, name in ipairs(profiles) do
				if (name == value) then found = true end
			end

			-- If not, add it and then sort it
			if (not found) then
				table.insert(profiles, value)
				table.sort(profiles)
			end

		elseif (setting == "profile.delete") then
			-- User clicked the Delete button, see what the select box's value is.
			value = gui.elements["profile"].value

			-- If there's a profile name supplied
			if (value) then
				-- Clean it's profile container of values
				cleanse(EnhTooltipConfig["profile."..value])

				-- Delete it's profile container
				EnhTooltipConfig["profile."..value] = nil

				-- Find it's entry in the profiles list
				local profiles = EnhTooltipConfig["profiles"]
				if (profiles) then
					for pos, name in ipairs(profiles) do
						-- If this is it, then extract it
						if (name == value and name ~= "Default") then
							table.remove(profiles, pos)
						end
					end
				end

				-- If the user was using this one, then move them to Default
				if (getUserProfileName() == value) then
					EnhTooltipConfig[getUserSig()] = 'Default'
				end


			end

		elseif (setting == "profile.default") then
			-- User clicked the reset settings button

			-- Get the current profile from the select box
			value = gui.elements["profile"].value

			-- Clean it's profile container of values
			EnhTooltipConfig["profile."..value] = {}

			private.Print("Reset all settings for: ", value)

		elseif (setting == "profile") then
			-- User selected a different value in the select box, get it
			value = gui.elements["profile"].value

			-- Change the user's current profile to this new one
			EnhTooltipConfig[getUserSig()] = value

			private.Print("Now using profile: ", value)

		end

		-- Refresh all values to reflect current data
		gui:Refresh()

	else
		-- Set the value for this setting in the current profile
		local db = getUserProfile()
		db[setting] = value
		--setUpdated()
	end
	
	if (a == "sideIcon") and EnhTooltip.SideIcon then
		EnhTooltip.SideIcon.Update()
	end
end

function lib.SetSetting(...)
	setter(...)
	if (gui) then
		gui:Refresh()
	end
end

local function getter(setting)
	if (not EnhTooltipConfig) then EnhTooltipConfig = {} end
	if not setting then return end

	--Is the setting actually a function reference? If so, call it.
	-- This was added to enable Protect Window to update its
	-- status without a UI reload by calling a function rather
	-- than a setting in the Control definition.
	if (type(setting)=="function") or (type(setting)=="table" and setting.setting) then
		return setting("getsetting")
	end

	local a,b,c = strsplit(".", setting)
	if (a == 'profile') then
		if (b == 'profiles') then
			local pList = EnhTooltipConfig["profiles"]
			if (not pList) then
				pList = { "Default" }
			end
			return pList
		end
	end

	if (setting == 'profile') then
		return getUserProfileName()
	end

	local db = getUserProfile()
	if ( db[setting] ~= nil ) then
		return db[setting]
	else
		return getDefault(setting)
	end
end

function lib.GetSetting(setting, default)
	local option = getter(setting)
	if ( option ~= nil ) then
		return option
	else
		return default
	end
end

function lib.UpdateGuiConfig()
	if gui then
		if gui:IsVisible() then
			gui:Hide()
		end
		gui = nil
		lib.MakeGuiConfig()
	end
end

local metaProcessor = 
{
	__call = function(tbl, ...) return processSetting(tbl.setting, ...) end
}

local function getOption(value)
	local tbl = {setting = value}	
	setmetatable(tbl,metaProcessor)
	return tbl
end

function lib.MakeGuiConfig()
	if gui then return end

	local id, last, cont
	local Configator = LibStub:GetLibrary("Configator",true)
	
	if not Configator then return end
	
	gui = Configator:Create(setter, getter)
	lib.Gui = gui

  	gui:AddCat("EnhTooltip")

	id = gui:AddTab("Profiles")
	
	gui:AddControl(id, "Header",     0,    "Setup, configure and edit profiles")
	gui:AddControl(id, "Subhead",    0,    "Activate a current profile")
	gui:AddControl(id, "Selectbox",  0, 1, "profile.profiles", "profile", "Switch to given profile")
	gui:AddTip(id, "Select the profile that you wish to use for this character")

	gui:AddControl(id, "Button",     0, 1, "profile.delete", "Delete")
	gui:AddTip(id, "Deletes the currently selected profile")

	gui:AddControl(id, "Subhead",    0,    "Create or replace a profile")
	gui:AddControl(id, "Text",       0, 1, "profile.name", "New profile name:")
	gui:AddTip(id, "Enter the name of the profile that you wish to create")

	gui:AddControl(id, "Button",     0, 1, "profile.save", "Save")
	gui:AddTip(id, "Click this button to create or overwrite the specified profile name")

	gui:AddHelp(id, "what is",
		"What is a profile?",
		"A profile is used to contain a group of settings, you can use different profiles for different characters, or switch between profiles for the same character when doing different tasks."
	)
	gui:AddHelp(id, "how create",
		"How do I create a new profile?",
		"You enter the name of the new profile that you wish to create into the text box labelled \"New profile name\", and then click the \"Save\" button. A profile may be called whatever you wish, but it should reflect the purpose of the profile so that you may more easily recall that purpose at a later date."
	)
	gui:AddHelp(id, "how delete",
		"How do I delete a profile?",
		"To delete a profile, simply select the profile you wish to delete with the drop-down selection box and then click the Delete button."
	)
	gui:AddHelp(id, "why delete",
		"Why would I want to delete a profile?",
		"You can delete a profile when you don't want to use it anymore, or you want to create it from scratch again with default values. Deleting a profile will also affect any other characters who are using the profile."
	)

	id = gui:AddTab("General")

	gui:AddControl(id, "Header", 0, "EnhTooltip options")
	gui:AddControl(id, "Note", 0, 1, nil, nil, " ")

	gui:AddControl(id, "Checkbox", 0, 1, getOption("suppressEnhancedTooltip"), "Hide Enhanced Tooltip")
	gui:AddTip(id, "Disables Enhanced Tooltip globally")

	gui:AddControl(id, "Checkbox", 0, 2, enhancedTooltipForceShow, "Show Enhanced Tooltip if Alt is pressed")
	gui:AddTip(id, "Shows Enhanced Tooltip when the Alt button is pressed")

	gui:AddControl(id, "Subhead", 0, "Show Enhanced Tooltip with following frames:")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithAuction"), "Auction")
	gui:AddTip(id, "Show Enhanced Tooltip in Auction House")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithBagsAndKeyRing"), "Bags and Keyring")
	gui:AddTip(id, "Show Enhanced Tooltip in Bags, including Bank Bags and in the Keyring")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithBagBar"), "Bag Bar")
	gui:AddTip(id, "Show Enhanced Tooltip in the Bag Bar (the bar displaying your four bags) and in the Bank Bag bar")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithBank"), "Bank")
	gui:AddTip(id, "Show Enhanced Tooltip in your Bank")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithCharacterInventory"), "Character Inventory")
	gui:AddTip(id, "Show Enhanced Tooltip for equipped items")

	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithChatHyperlink"), "Chat Hyperlink")
	gui:AddTip(id, "Show Enhanced Tooltip for Chat Hyperlinks")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithGuildBank"), "Guild Bank")
	gui:AddTip(id, "Show Enhanced Tooltip in Guild Bank")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithLootAndLootRoll"), "Loot and Loot Roll")
	gui:AddTip(id, "Show Enhanced Tooltip in the loot window, and on the pop-up that appears when you are rolling for loot.")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithMail"), "Mail")
	gui:AddTip(id, "Show Enhanced Tooltip in Mail interface")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithMerchants"), "Merchants")
	gui:AddTip(id, "Show Enhanced Tooltip in Merchant window")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithProfessions"), "Professions")
	gui:AddTip(id, "Show Enhanced Tooltip for Professions interface")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithQuests"), "Quests")
	gui:AddTip(id, "Show Enhanced Tooltip for Quests and Quest Log")
	
	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithTrade"), "Trade")
	gui:AddTip(id, "Show Enhanced Tooltip when trading with another player")

	gui:AddControl(id, "Checkbox", 0, 1, getOption("showWithOther"), "Other")
	gui:AddTip(id, "Show Enhanced Tooltip with other items, for example in certain addon specific windows")

	gui:AddControl(id, "Note", 0, 1, nil, nil, " ")
	gui:AddControl(id, "Checkbox", 0, 1, getOption("blockExternalCalls"), "Block External Calls")
	gui:AddTip(id, "Block other addons from manipulating Enhanced Tooltip. See help for more details.")

	
	gui:AddControl(id, "Checkbox",   0, 1, "sideIcon.enable", "Display the SlideBar button")

	gui:AddHelp(id, "what is",
		"What is Enhanced Tooltip?",
		"Enhanced Tooltip is an additional tooltip that appears next to the main tooltip when you mouse over an item. This tooltip displays various extra information about the item supplied by other addons, such as AucAdvanced, Enchantrix, Informant and others. Which pieces of information are displayed and which are not is configured within each respective addon."
	)
	
	gui:AddHelp(id, "how hiding works",
		"How do the options controlling whether Enhanced Tooltip is shown work?",
		"The main option \"Hide Enhanced Tooltip\" controls whether Enhanced Tooltip is shown. It overrides individual frame options. The alt button option works both for the main and individual frame options and shows the hidden tooltip when the Alt button is pressed. Note, that in order to work 100% of the time the Alt button should be pressed *before* you mouse over an item. Some frames do support activating tooltip when Alt button is pressed when mouse is already over an item and some frames do not."
	)

	gui:AddHelp(id, "what does block external calls option do",
		"What does Block External Calls option do?",
		"The EnhTooltip addon is sometimes used by other 3rd party addons to display custom tooltip information.  In most cases, enabling or disabling the \"Other\" category of tooltips will enable or disable those 3rd party addon tooltips.  However, there are some limitations.  For example, if a 3rd party addon bypasses this control and explicitly calls the EnhTooltip functions for it's own purposes, it's own tooltips may be displayed regardless of EnhTooltip configuration settings.  If \"Block External Calls\" is set, 3rd party addons are prevented from using EnhTooltip to display custom tooltip information.  It may be useful to set this option if you see tooltips being displayed even though you've otherwise set the configuration option to hide certain types of tooltips."
	)
end


local function click(obj, button)
	if (button == "LeftButton") then
		EnhTooltip.Settings.MakeGuiConfig()
		local gui = EnhTooltip.Settings.Gui
		if (gui) then
			if (gui:IsVisible()) then
				gui:Hide()
			else
				gui:Show()
			end		
		end
	elseif (button == "RightButton") then
		if (Informant and Informant.Settings) then
			Informant.Settings.MakeGuiConfig()
			local gui = Informant.Settings.Gui
			if (gui) then
				if (gui:IsVisible()) then
					gui:Hide()
				else
					gui:Show()
				end
			end
		end
	end
end

local sideIcon
local SlideBar

if LibStub then
	SlideBar = LibStub:GetLibrary("SlideBar", true)
	if SlideBar then
		sideIcon = SlideBar.AddButton("EnhTooltip", "Interface\\AddOns\\EnhTooltip\\Skin\\EnhOrb")
		sideIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
		sideIcon:SetScript("OnClick", click)
-- TODO - localize these strings!
		sideIcon.tip = {
			"EnhTooltip/Informant",
			"Description.",
			"{{Click}} to open the Enhanced Tooltip configuration.",
			"{{Right-Click}} to open Informant configuration.",
		}
	end
end

if sideIcon then
	function sideIcon.Update()
		if (EnhTooltip.Settings.GetSetting("sideIcon.enable")) then
			SlideBar.AddButton("EnhTooltip")
		else
			SlideBar.RemoveButton("EnhTooltip")
		end
	end
else
	sideIcon = {}
	function sideIcon.Update() end
end

EnhTooltip.SideIcon = sideIcon
