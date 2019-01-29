--[[
	Informant - An addon for World of Warcraft that shows pertinent information about
	an item in a tooltip when you hover over the item in the game.
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: InfCommand.lua 3499 2008-09-17 02:48:46Z ccox $
	URL: http://auctioneeraddon.com/dl/Informant/

	Command handler. Assumes responsibility for allowing the user to set the
	options via slash command, MyAddon etc.

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
Informant_RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/RC_5.0/Informant/InfCommand.lua $", "$Rev: 3499 $")

-- function prototypes
local commandHandler, cmdHelp, onOff, genVarSet, chatPrint, restoreDefault, cmdLocale, setLocale, isValidLocale
local debugPrint

-- Localization function prototypes
local delocalizeFilterVal, localizeFilterVal, getLocalizedFilterVal, delocalizeCommand, localizeCommand, buildCommandMap

local commandMap = nil
local commandMapRev = nil

Informant.InitCommands = function()
	SLASH_INFORMANT1 = "/informant"
	SLASH_INFORMANT2 = "/inform"
	SLASH_INFORMANT3 = "/info"
	SLASH_INFORMANT4 = "/inf"
	SlashCmdList["INFORMANT"] = commandHandler

	chatPrint(_INFM('FrmtWelcome'):format(INFORMANT_VERSION))
end


function buildCommandMap()
	commandMap = {
		[_INFM('CmdOn')]			=	'on',
		[_INFM('CmdOff')]			=	'off',
		[_INFM('CmdHelp')]			=	'help',
		[_INFM('CmdToggle')]		=	'toggle',
		[_INFM('CmdDisable')]		=	'disable',
		[_INFM('CmdLocale')]		=	'locale',
		[_INFM('CmdDefault')]		=	'default',
		[_INFM('CmdEmbed')]			=	'embed',
		[_INFM('ShowIcon')]			=	'show-icon',
		[_INFM('ShowName')]			=	'show-name',
		[_INFM('ShowILevel')]		=	'show-ilevel',
		[_INFM('ShowLink')]			=	'show-link',
		[_INFM('ShowStack')]		=	'show-stack',
		[_INFM('ShowUsage')]		=	'show-usage',
		[_INFM('ShowQuest')]		=	'show-quest',
		[_INFM('ShowMerchant')]		=	'show-merchant',
		[_INFM('ShowZeroMerchants')] =	'show-zero-merchants',
		[_INFM('ShowVendor')]		=	'show-vendor',
		[_INFM('ShowVendorBuy')]	=	'show-vendor-buy',
		[_INFM('ShowVendorSell')]	=	'show-vendor-sell',
	}

	commandMapRev = {}
	for k,v in pairs(commandMap) do
		commandMapRev[v] = k
	end
end

--Cleaner Command Handling Functions (added by MentalPower)
function commandHandler(command, source)
	--To print or not to print, that is the question...
	local chatprint
	if (source == "GUI") then
		chatprint = false
	else
		chatprint = true
	end

	--Divide the large command into smaller logical sections (Shameless copy from the original function)
	local cmd, param = command:match("^([%w%-]+)%s*(.*)$")

	cmd = cmd or command or ""
	param = param or ""
	cmd = delocalizeCommand(cmd)

	--Now for the real Command handling
	if ((cmd == "") or (cmd == "help")) then
		cmdHelp()
		return

	elseif (cmd == 'show' or cmd == 'config') then
		-- show or hide our settings UI
		Informant.Settings.MakeGuiConfig()
		local gui = Informant.Settings.Gui
		if (gui:IsVisible()) then
			gui:Hide()
		else
			gui:Show()
		end

	elseif (cmd == "on" or cmd == "off" or cmd == "toggle") then
		onOff(cmd, chatprint)
	elseif (cmd == "disable") then
		Stubby.SetConfig("Informant", "LoadType", "never")
	elseif (cmd == "load") then
		if (param == "always") or (param == "never") then
			chatPrint("Setting Informant to "..param.." load for this toon")
			Stubby.SetConfig("Informant", "LoadType", param)
		end
	elseif (cmd == "locale") then
		setLocale(param, chatprint)
	elseif (cmd == "default") then
		restoreDefault(param, chatprint)
	elseif (
		cmd == "embed" or cmd == "show-stack" or cmd == "show-usage" or
		cmd == "show-quest" or cmd == "show-merchant" or cmd == "show-vendor" or
		cmd == "show-vendor-buy" or cmd == "show-vendor-sell" or cmd == "show-icon" or
		cmd == "show-ilevel" or cmd == "show-link" or cmd == "show-zero-merchants" or
		cmd == "show-name"
	) then
		genVarSet(cmd, param, chatprint)
	elseif (cmd == "about") then
		chatPrint(_INFM('about'))
	else
		if (chatprint) then
			chatPrint(_INFM('FrmtActUnknown'):format(cmd))
		end
	end
end

--Help ME!! (The Handler) (Another shameless copy from the original function)
function cmdHelp()

	local onOffToggle = " (".._INFM('CmdOn').."/".._INFM('CmdOff').."/".._INFM('CmdToggle')..")"
	local lineFormat = "  |cffffffff/informant %s "..onOffToggle.."|r |cffff4020[%s]|r - %s"

	chatPrint(_INFM('TextUsage'))
	chatPrint("  |cffffffff/informant "..onOffToggle.."|r |cffff4020["..getLocalizedFilterVal('all').."]|r - " .. _INFM('HelpOnoff'))

	chatPrint("  |cffffffff/informant ".._INFM('CmdDisable').."|r - " .. _INFM('HelpDisable'))

	chatPrint(lineFormat:format(_INFM('ShowName'), getLocalizedFilterVal('show-name'), _INFM('HelpName')))
	chatPrint(lineFormat:format(_INFM('ShowVendor'), getLocalizedFilterVal('show-vendor'), _INFM('HelpVendor')))
	chatPrint(lineFormat:format(_INFM('ShowVendorSell'), getLocalizedFilterVal('show-vendor-sell'), _INFM('HelpVendorSell')))
	chatPrint(lineFormat:format(_INFM('ShowVendorBuy'), getLocalizedFilterVal('show-vendor-buy'), _INFM('HelpVendorBuy')))
	chatPrint(lineFormat:format(_INFM('ShowUsage'), getLocalizedFilterVal('show-usage'), _INFM('HelpUsage')))
	chatPrint(lineFormat:format(_INFM('ShowQuest'), getLocalizedFilterVal('show-quest'), _INFM('HelpQuest')))
	chatPrint(lineFormat:format(_INFM('ShowMerchant'), getLocalizedFilterVal('show-merchant'), _INFM('HelpMerchant')))
	chatPrint(lineFormat:format(_INFM('ShowZeroMerchants'), getLocalizedFilterVal('show-zero-merchants'), _INFM('HelpZeroMerchants')))
	chatPrint(lineFormat:format(_INFM('ShowStack'), getLocalizedFilterVal('show-stack'), _INFM('HelpStack')))
	chatPrint(lineFormat:format(_INFM('ShowIcon'), getLocalizedFilterVal('show-icon'), _INFM('HelpIcon')))
	chatPrint(lineFormat:format(_INFM('ShowILevel'), getLocalizedFilterVal('show-ilevel'), _INFM('HelpILevel')))
	chatPrint(lineFormat:format(_INFM('ShowLink'), getLocalizedFilterVal('show-link'), _INFM('HelpLink')))
	chatPrint(lineFormat:format(_INFM('CmdEmbed'), getLocalizedFilterVal('embed'), _INFM('HelpEmbed')))

	lineFormat = "  |cffffffff/informant %s %s|r |cffff4020[%s]|r - %s"
	chatPrint(lineFormat:format(_INFM('CmdLocale'), _INFM('OptLocale'), getLocalizedFilterVal('locale'), _INFM('HelpLocale')))

	lineFormat = "  |cffffffff/informant %s %s|r - %s"
	chatPrint(lineFormat:format(_INFM('CmdDefault'), "", _INFM('HelpDefault')))
end


--[[
	The onOff(state, chatprint) function handles the state of the Informant AddOn (whether it is currently on or off)
	If "on" or "off" is specified in the first argument then Informant's state is changed to that value,
	If "toggle" is specified then it will toggle Informant's state (if currently on then it will be turned off and vice-versa)

	If a boolean (or nil) value is passed as the first argument the conversion is as follows:
	"true" is the same as "on"
	"false" is the same as "off"
	"nil" is the same as "toggle"

	If chatprint is "true" then the state will also be printed to the user.
--]]
function onOff(state, chatprint)
	if (type(state) == "string") then
		state = delocalizeFilterVal(state)

	elseif (state == nil) then
		state = 'toggle'
	end

	if (state == 'on' or state == 'off' or type(param) == "boolean") then
		Informant.Settings.SetSetting('all', state)

	elseif (state == 'toggle') then
		Informant.Settings.SetSetting('all', not Informant.Settings.GetSetting('all'))
	end

	--Print the change and alert the GUI if the command came from slash commands. Do nothing if they came from the GUI.
	if (chatprint) then
		state = Informant.Settings.GetSetting('all')

		if (state) then
			chatPrint(_INFM('StatOn'))
		else
			chatPrint(_INFM('StatOff'))
		end
	end
end

function restoreDefault(param, chatprint)
	local paramLocalized

	if ( (param == nil) or (param == "") ) then
		return
	elseif ((param == _INFM('CmdClearAll')) or (param == "all")) then
		param = "all"
		Informant.Settings.RestoreDefaults()
	else
		paramLocalized = param
		param = delocalizeCommand(param)
		Informant.Settings.SetSetting(param, nil)
	end

	if (chatprint) then
		if (param == "all") then
			chatPrint(_INFM('FrmtActDefaultall'))
		else
			chatPrint(_INFM('FrmtActDefault'):format(paramLocalized))
		end
	end
end

function genVarSet(variable, param, chatprint)
	if (type(param) == "string") then
		param = delocalizeFilterVal(param)
	end

	if (param == "on" or param == "off" or type(param) == "boolean") then
		Informant.Settings.SetSetting(variable, param)
	elseif (param == "toggle" or param == nil or param == "") then
		param = Informant.Settings.SetSetting(variable, not Informant.Settings.GetSetting(variable))
	end

	if (chatprint) then
		if (Informant.Settings.GetSetting(variable)) then
			chatPrint(_INFM('FrmtActEnable'):format(localizeCommand(variable)))
		else
			chatPrint(_INFM('FrmtActDisable'):format(localizeCommand(variable)))
		end
	end
end

function isValidLocale(param)
	return (InformantLocalizations and InformantLocalizations[param])
end

function setLocale(param, chatprint)
	param = delocalizeFilterVal(param)
	local validLocale

	if (param == 'default') or (param == 'off') then
		Babylonian.SetOrder('')
		validLocale = true

	elseif (isValidLocale(param)) then
		Babylonian.SetOrder(param)
		validLocale = true

	else
		validLocale = false
	end

	BINDING_HEADER_INFORMANT_HEADER = "Informant"
	BINDING_NAME_INFORMANT_POPUPDOWN = _INFM('MesgToggleWindow')

	if (chatprint) then
		if (validLocale) then
			chatPrint(_INFM('FrmtActSet'):format(_INFM('CmdLocale'), param))

		else
			chatPrint(_INFM("FrmtUnknownLocale"):format(param))
			local locales = "    "
			for locale, data in pairs(InformantLocalizations) do
				locales = locales .. " '" .. locale .. "' "
			end
			chatPrint(locales)
		end
	end

	commandMap = nil
	commandMapRev = nil
end

function chatPrint(msg)
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, 0.25, 0.55, 1.0)
	end
end

--------------------------------------
--		Localization functions		--
--------------------------------------

function delocalizeFilterVal(value)
	if (value == _INFM('CmdOn')) then
		return true

	elseif (value == _INFM('CmdOff')) then
		return false

	elseif (value == _INFM('CmdDefault')) then
		return 'default'

	elseif (value == _INFM('CmdToggle')) then
		return 'toggle'

	else
		return value
	end
end

function localizeFilterVal(value)
	local result

	if (value == 'on' or (type(value) == "boolean" and value == true)) then
		result = _INFM('CmdOn')

	elseif (value == 'off' or (type(value) == "boolean" and value == false)) then
		result = _INFM('CmdOff')

	elseif (value == 'default') then
		result = _INFM('CmdDefault')

	elseif (value == 'toggle') then
		result = _INFM('CmdToggle')
	end

	return result or value
end

function getLocalizedFilterVal(key)
	return localizeFilterVal(Informant.Settings.GetSetting(key))
end

-- Turns a localized slash command into the generic English version of the command
function delocalizeCommand(cmd)
	if (not commandMap) then
		buildCommandMap()
	end

	return commandMap[cmd] or cmd
end

-- Translate a generic English slash command to the localized version, if available
function localizeCommand(cmd)
	if (not commandMapRev) then
		buildCommandMap()
	end

	return commandMapRev[cmd] or cmd
end

-------------------------------------------------------------------------------
-- Prints the specified message to nLog.
--
-- syntax:
--    errorCode, message = debugPrint([message][, title][, errorCode][, level])
--
-- parameters:
--    message   - (string) the error message
--                nil, no error message specified
--    title     - (string) the title for the debug message
--                nil, no title specified
--    errorCode - (number) the error code
--                nil, no error code specified
--    level     - (string) nLog message level
--                         Any nLog.levels string is valid.
--                nil, no level specified
--
-- returns:
--    errorCode - (number) errorCode, if one is specified
--                nil, otherwise
--    message   - (string) message, if one is specified
--                nil, otherwise
-------------------------------------------------------------------------------
function debugPrint(message, title, errorCode, level)
	return Informant.DebugPrint(message, "InfCommand", title, errorCode, level)
end

-- Globally accessible functions
Informant.SetLocale = setLocale



