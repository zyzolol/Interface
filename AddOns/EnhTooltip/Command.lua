--[[
	EnhTooltip - Additional function hooks to allow hooks into more tooltips
	Version: 5.0.0 (BillyGoat)
	Revision: $Id: Command.lua 3481 2008-09-12 14:39:29Z anaral $
	URL: http://auctioneeraddon.com/dl/EnhTooltip

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

EnhTooltip.Config = {}
local lib = EnhTooltip.Config
--Allows EhTT sub lua's access to functions and settings in other EhTT files. This also makes private.Print accessible from all EhTT luas
--Private print does not need to concatenate strings, simply use commas to separate arguments. Also handles printing functions, nils, and tables without throwing errors
local private = EnhTooltip.Private

function private.CommandHandler(command, subcommand, subcommand2, ...)
	command = command:lower()
	if (command == "help") then
		private.Print("Auctioneer Advanced Help")
		private.Print("  {{/ett help}} - Show this help")
		private.Print("  {{/ett on||off}} - Show or hide enhanced tooltip globally")
		private.Print("  {{/ett force alt||shift||ctrl||off}} - Force showing enhanced tooltip, when a key pressed")
		private.Print("  {{/ett config}} - Open configuration interface")
		private.Print("  {{/ett show auction||bags||bagbar||bank||chat||inventory||guildbank||loot||mail||merchants||professions||quests||trade||other on||off}} - shows or hide enhanced tooltip for a particular frame.")
		private.Print("  {{/ett block on||off}} - blocks / allows external addons from using Enhanced Tooltip tooltip manipulation API")
	elseif command == "on" then
		EnhTooltip.Settings.SetSetting("suppressEnhancedTooltip", false)
		private.Print("Enhanced tooltips are now on")
	elseif command == "off" then
		EnhTooltip.Settings.SetSetting("suppressEnhancedTooltip", true)
		private.Print("Enhanced tooltips are now off")
	elseif command == "force" then
		EnhTooltip.SetSetting("forceSuppresedTooltipKey", subcommand)
		if (subcommand == "shift") or (subcommand == "alt") or (subcommand == "ctrl") then
			private.Print("Enhanced tooltips are forced with ", subcommand, " key")
		else
			private.Print("Enhanced tooltips are not forced")
		end
	elseif command == "config" then
		EnhTooltip.Settings.MakeGuiConfig()
		local gui = EnhTooltip.Settings.Gui
		if (gui) then
			if (gui:IsVisible()) then
				gui:Hide()
			else
				gui:Show()
			end		
		else
			private.Print("Configator library is not found. Can't open configuration UI")
		end
	elseif command == "show" then
		local optionName
		if subcommand == "auction" then
			optionName = "showWithAuction"
		elseif subcommand == "bags" then
			optionName = "showWithBagsAndKeyRing"
		elseif subcommand == "bagbar" then
			optionName = "showWithBagBar"
		elseif subcommand == "bank" then
			optionName = "showWithBank"
		elseif subcommand == "quests" then
			optionName = "showWithQuests"
		elseif subcommand == "trade" then
			optionName = "showWithTrade"
		elseif subcommand == "inventory" then
			optionName = "showWithCharacterInventory"
		elseif subcommand == "chat" then
			optionName = "showWithChatHyperlink"
		elseif subcommand == "guildbank" then
			optionName = "showWithGuildBank"
		elseif subcommand == "loot" then
			optionName = "showWithLootAndLootRoll"
		elseif subcommand == "mail" then
			optionName = "showWithMail"
		elseif subcommand == "merchants" then
			optionName = "showWithMerchants"
		elseif subcommand == "professions" then
			optionName = "showWithProfessions"
		elseif subcommand == "other" then
			optionName = "showWithOther"
		else
			private.Print("Unknown option for show argument: ", subcommand)
		end
		
		local state
		if subcommand2 == "on" then
			state = true
		elseif subcommand2 == "off" then
			state = false
		else
			private.Print("Unknown state for show argument: ", subcommand2)
		end
				
		if optionName or (state ~= nil) then	
			EnhTooltip.Settings.SetSetting(optionName, state)
			private.Print("Enhanced tooltip for ", subcommand, " is now ",subcommand2)
		end
	elseif command == "block" then
		if subcommand == "on" then
			EnhTooltip.Settings.SetSetting("blockExternalCalls", true)
			private.Print("External calls are now blocked")
		elseif subcommand == "off" then
			EnhTooltip.Settings.SetSetting("blockExternalCalls", false)
			private.Print("External calls are now allowed")
		else
			private.Print("Unknown state for block argument: ", subcommand)
		end		
	else	
		-- No match found
		private.Print("Unable to find command: ", command)
		private.Print("Type {{/ett help}} for help")
	end
	if EnhTooltip.Gui then
		EnhTooltip.Gui:Refresh()
	end
end

SLASH_ENHTOOLTIP1 = "/ett"
SLASH_ENHTOOLTIP2 = "/enhtooltip"
SlashCmdList["ENHTOOLTIP"] = function(msg) private.CommandHandler(strsplit(" ", msg)) end
