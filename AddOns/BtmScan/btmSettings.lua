--[[
	BottomScanner Addon for World of Warcraft(tm).
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: btmSettings.lua 3469 2008-09-07 23:44:19Z anaral $
	URL: http://auctioneeraddon.com/dl/BottomScanner/
	Copyright (c) 2006, Norganna

	Settings GUI

	Data Layout:
		BtmScanData = {

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
		def = BtmScanner.Settings.GetDefault('ToolTipShowCounts')
		val = BtmScanner.Settings.GetSetting('ToolTipShowCounts')
		BtmScanner.Settings.SetSetting('ToolTipShowCounts', true );

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
		You have an implicit licence to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]

local lib = {}
BtmScan.Settings = lib
local private = {}
local gui

local function getUserSig()
	local userSig = string.format("users.%s.%s", GetRealmName(), UnitName("player"))
	return userSig
end

local function getUserProfileName()
	if (not BtmScanData) then BtmScanData = {} end
	local userSig = getUserSig()
	return BtmScanData[userSig] or "Default"
end

local function getUserProfile()
	if (not BtmScanData) then BtmScanData = {} end
	local profileName = getUserProfileName()
	if (not BtmScanData["profile."..profileName]) then
		if profileName ~= "Default" then
			profileName = "Default"
			BtmScanData[getUserSig()] = "Default"
		end
		if profileName == "Default" then
			BtmScanData["profile."..profileName] = {}
		end
	end
	return BtmScanData["profile."..profileName]
end


local function cleanse( profile )
	if (profile) then
		profile = {}
	end
end


local setter, getter, getDefault

-- Default setting values
local settingDefaults = {
	['all'] = true,
	['locale'] = 'default',
	['scan.always'] = false,
	['scan.reload.enable'] = true,
	['scan.reload.interval'] = 30,
	['global.reserve'] = 20000,
	['global.maxprice'] = 25000,
	['allow.buy'] = true,
	['allow.bid'] = true,
	['playSound'] = true,
	['EnableTopScan'] = false,
	['override.nobid'] = false,
	['show.tooltip'] = true,
	['price.display'] = 'unit_total',
}

function getDefault(setting)
	local a,b,c = strsplit(".", setting)

	-- custom settings
	if (b == "list") then
		local db = getUserProfile()
		if db[setting] then return nil end
		db[setting] = {}
		return db[setting]
	end

	-- lookup the simple settings
	local result = settingDefaults[setting];

	return result
end

function lib.GetDefault(setting)
	local val = getDefault(setting);
	return val;
end

function lib.SetDefault(setting, default)
	local a,b,c = strsplit(".", setting)
	if (b == "allow") then 
		if lib.GetSetting(a..".never."..c) then 
			default = false 
			lib.SetSetting(a..".never."..c, false)
		end
	end
	settingDefaults[setting] = default
end

function setter(setting, value)
	if (not BtmScanData) then BtmScanData = {} end

	-- turn value into a canonical true or false
	if value == 'on' then
		value = true
	elseif value == 'off' then
		value = false
	end
	
	-- is the setting actually a function ref? if so call it.
	if type(setting)=="function" then
		return setting(value)
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
			BtmScanData["profile."..value] = {}

			-- Set the current profile to the new profile
			BtmScanData[getUserSig()] = value
			-- Get the new current profile
			local newProfile = getUserProfile()

			-- Clean it out and then resave all data
			cleanse(newProfile)
			gui:Resave()

			-- Add the new profile to the profiles list
			local profiles = BtmScanData["profiles"]
			if (not profiles) then
				profiles = { "Default" }
				BtmScanData["profiles"] = profiles
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
				cleanse(BtmScanData["profile."..value])

				-- Delete it's profile container
				BtmScanData["profile."..value] = nil

				-- Find it's entry in the profiles list
				local profiles = BtmScanData["profiles"]
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
					BtmScanData[getUserSig()] = 'Default'
				end
			end

		elseif (setting == "profile.default") then
			-- User clicked the reset settings button

			-- Get the current profile from the select box
			value = gui.elements["profile"].value

			-- Clean it's profile container of values
			BtmScanData["profile."..value] = {}

		elseif (setting == "profile") then
			-- User selected a different value in the select box, get it
			value = gui.elements["profile"].value

			-- Change the user's current profile to this new one
			BtmScanData[getUserSig()] = value

		end

		-- Refresh all values to reflect current data
		gui:Refresh()

	elseif (setting == "baserule.edit") then
		BtmScan.EditData("baseRule", BtmScan.CompileBaseRule)
	else
		-- Set the value for this setting in the current profile
		local db = getUserProfile()
		db[setting] = value
	end

end

function lib.SetSetting(...)
	setter(...)
	if (gui) then
		gui:Refresh()
	end
end


function getter(setting)
	if (not BtmScanData) then BtmScanData = {} end
	if not setting then return end

	local a,b,c = strsplit(".", setting)
	if (a == 'profile') then
		if (b == 'profiles') then
			local pList = BtmScanData["profiles"]
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


function lib.Show()
	lib.MakeGuiConfig()
	gui:Show()
end

function lib.Hide()
	if (gui) then
		gui:Hide()
	end
end

function lib.Toggle()
	if (gui and gui:IsShown()) then
		lib.Hide()
	else
		lib.Show()
	end
end


function lib.MakeGuiConfig()
	if gui then return end

	local id, last, cont
	local Configator = LibStub:GetLibrary("Configator")
	gui = Configator:Create(setter, getter)
	lib.Gui = gui

  	gui:AddCat("Core Options")

	id = gui:AddTab("Profiles")
	gui:AddControl(id, "Header",           0,    "Setup, configure and edit profiles")
	gui:AddControl(id, "Subhead",          0,    "Activate a current profile")
	gui:AddControl(id, "Selectbox",        0, 1, "profile.profiles", "profile", "Switch to a given profile")
	gui:AddControl(id, "Button",           0, 1, "profile.delete", "Delete")
	gui:AddControl(id, "Subhead",          0,    "Create or replace a profile")
	gui:AddControl(id, "Text",             0, 1, "profile.name", "New profile name:")
	gui:AddControl(id, "Button",           0, 1, "profile.save", "Save")

	id = gui:AddTab("General")
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",           0,    "Main BtmScanner options")
	gui:AddControl(id, "Subhead",          0,    "Scan Settings")
	gui:AddControl(id, "Checkbox",         0, 1, "scan.always", "Look for bargains while browsing")
	gui:AddControl(id, "Checkbox",         0, 1, "scan.reload.enable", "Enable automatic last page reload (bottom scan):")
	gui:AddControl(id, "WideSlider",       0, 1, "scan.reload.interval", 6, 60, 1, "Reload interval: %s seconds")
	gui:AddControl(id, "Checkbox",         0, 1, "EnableTopScan", "Top scan as well as bottom scan")
	gui:AddControl(id, "Checkbox",         0, 1, "override.nobid", "Override 'Allow bid on items' when topscanning")
	gui:AddControl(id, "Subhead",          0,    "Display Settings")
	gui:AddControl(id, "Checkbox",         0, 1, "show.tooltip", "Display evaluations in tooltip")
	gui:AddControl(id, "Label",            0, 3,  nil, "Display prices as:")
	gui:AddControl(id, "Selectbox",        0, 4, {{"total","Total"},{"unit","Unit"},{"total_unit","Total / Unit"},{"unit_total","Unit / Total"}}, "price.display", "Display prices as:")
	gui:AddControl(id, "Subhead",          0,    "Purchase Settings")
	gui:AddControl(id, "MoneyFramePinned", 0, 1, "global.reserve", 1, 99999999, "Reserve Amount")
	gui:AddControl(id, "MoneyFramePinned", 0, 1, "global.maxprice", 1, 99999999, "Maximum Price")
	gui:AddControl(id, "Subhead",          0,    "Buy/Bid Preferences")
	gui:AddControl(id, "Checkbox",         0, 1, "allow.buy", "Allow buyout on items")
	gui:AddControl(id, "Checkbox",         0, 1, "allow.bid", "Allow bid on items")
	gui:AddControl(id, "Checkbox",	       0, 1, "playSound", "Play sound when a bargain is found")

  	gui:AddCat("Evaluators:")

	for pos, name in ipairs(BtmScan.evaluators) do
		local evaluator = BtmScan.evaluators[name]
		if (evaluator and evaluator.setup) then
			evaluator:setup(gui)
		end
	end

  	gui:AddCat("Filters:")

	for pos, name in ipairs(BtmScan.filters) do
		local filter = BtmScan.filters[name]
		if (filter and filter.setup) then
			filter:setup(gui)
		end
	end
end

local sideIcon
if LibStub then
	local SlideBar = LibStub:GetLibrary("SlideBar", true)
	if SlideBar then
		sideIcon = SlideBar.AddButton("BtmScanner", "Interface\\AddOns\\BtmScan\\Textures\\BtmScanIcon")
		sideIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
		sideIcon:SetScript("OnClick", lib.Toggle)
		sideIcon.tip = {
			"Bottom Scanner",
			"Bottom Scanner allows you to continually scan the Auction House's new auctions for bargains. When it finds a good deal, it will ask you if you wish to purchase it.",
			"{{Click}} to edit the configuration options.",
		}
	end
end
