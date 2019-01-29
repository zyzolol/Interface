-------------------------------------------------------------------------------
-- Title: Mik's Scrolling Battle Text Localization
-- Author: Mik
-------------------------------------------------------------------------------

-- Local reference for faster access.
local L = MikSBT.translations;

-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------

------------------------------
-- Fonts
------------------------------

L.FONT_FILES = {
 Adventure		= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\adventure.ttf",
 Bazooka		= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\bazooka.ttf",
 Cooline		= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\cooline.ttf",
 Default		= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\porky.ttf",
 Diogenes		= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\diogenes.ttf",
 Friz			= "Fonts\\FRIZQT__.TTF",
 Ginko			= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\ginko.ttf",
 Heroic			= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\heroic.ttf",
 Talisman		= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\talisman.ttf",
 Transformers	= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\transformers.ttf",
 Yellowjacket	= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\yellowjacket.ttf",
 Zephyr			= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\zephyr.ttf",
}


------------------------------
-- Commands
------------------------------

L.COMMAND_RESET		= "reset";
L.COMMAND_DISABLE	= "disable";
L.COMMAND_ENABLE	= "enable";
L.COMMAND_SHOWVER	= "version";
L.COMMAND_HELP		= "help";

L.COMMAND_USAGE = {
 "Usage: " .. MikSBT.COMMAND .. " <command> [params]",
 " Commands:",
 "  " .. L.COMMAND_RESET .. " - Reset the current profile to the default settings.",
 "  " .. L.COMMAND_DISABLE .. " - Disables the mod.",
 "  " .. L.COMMAND_ENABLE .. " - Enables the mod.",
 "  " .. L.COMMAND_SHOWVER .. " - Shows the current version.",
 "  " .. L.COMMAND_HELP .. " - Show the command usage.",
}


------------------------------
-- Output messages
------------------------------

L.MSG_ICON_MODULE_WARNING	= "WARNING: The MSBTIcons module is no longer required. Remove it from your AddOns folder to avoid wasting memory.";
--L.MSG_SEARCH_ENABLE			= "Event search mode enabled.  Searching for: ";
--L.MSG_SEARCH_DISABLE		= "Event search mode disabled.";
L.MSG_DISABLE				= "Mod disabled.";
L.MSG_ENABLE				= "Mod enabled.";
L.MSG_PROFILE_RESET			= "Profile Reset";
L.MSG_HITS					= "Hits";
L.MSG_CRIT					= "Crit";
L.MSG_CRITS					= "Crits";
L.MSG_MULTIPLE_TARGETS		= "Multiple";
L.MSG_READY_NOW				= "Ready Now";


------------------------------
-- Scroll area names
------------------------------

L.MSG_INCOMING			= "Incoming";
L.MSG_OUTGOING			= "Outgoing";
L.MSG_NOTIFICATION		= "Notification";
L.MSG_STATIC			= "Static";


----------------------------------------
-- Master profile event output messages
----------------------------------------

L.MSG_COMBAT					= "Combat";
L.MSG_DISPEL					= "Dispel";
L.MSG_CP						= "CP";
L.MSG_CP_FULL					= "Finish It";
L.MSG_KILLING_BLOW				= "Killing Blow";
L.MSG_TRIGGER_LOW_HEALTH		= "Low Health";
L.MSG_TRIGGER_LOW_MANA			= "Low Mana";
L.MSG_TRIGGER_LOW_PET_HEALTH	= "Low Pet Health";