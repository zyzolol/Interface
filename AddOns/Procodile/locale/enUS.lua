local L = LibStub("AceLocale-3.0"):NewLocale("Procodile", "enUS", true)

L["PROCODILE_DESC"] = "Gathers statistics on certain chance-on-use spells, also known as procs."

L["OPTIONS_NAME"] = "Options"
L["OPTIONS_DESC"] = "Basic options for Procodile."

L["SPELLS_NAME"] = "Spells"
L["SPELLS_DESC"] = "Set up which spells to track."

L["TOGGLE_PROCODILE"] = "Toggle Procodile on or off."

L["TOGGLE_ENABLED"] = "Started tracking"
L["TOGGLE_DISABLED"] = "Stopped tracking"

L["SHOWSPELLS_NAME"] = "Debug spells"
L["SHOWSPELLS_DESC"] = "Shows information in the chat about spells that Procodile could track if you wanted it to. Useful for finding out spell IDs and adding as custom spells."

L["COMBATONLY_NAME"] = "Combat only"
L["COMBATONLY_DESC"] = "Procodile will be active during combat. This is probably what you want for accurate procs per minute and uptime measurement."

L["SELFSPELLS_NAME"] = "Self-spells"
L["SELFSPELLS_DESC"] = "These are procs that occurs on yourself as a buff."

L["VERBOSE_NAME"] = "Verbose"
L["VERBOSE_DESC"] = "Shows in chat when tracking is enabled or disabled, and when tracked spells starts and ends."

L["COOLDOWNS_NAME"] = "Show cooldown bars"
L["COOLDOWNS_DESC"] = "Shows bars with estimated internal cooldowns for procs."

L["MOVABLECOOLDOWNS_NAME"] = "Movable cooldowns"
L["MOVABLECOOLDOWNS_DESC"] = "Shows an anchor for the cooldown bars."

L["ANNOUNCE_NAME"] = "Announce cooldowns"
L["ANNOUNCE_DESC"] = "Displays expired cooldowns in the combat text area."

L["FONTSIZE_NAME"] = "Font size"
L["FONTSIZE_DESC"] = "Sets the font size for the cooldown bars."

L["BARWIDTH_NAME"] = "Bar width"
L["BARWIDTH_DESC"] = "Sets the width of the cooldown bars."

L["BARHEIGHT_NAME"] = "Bar height"
L["BARHEIGHT_DESC"] = "Sets the height of the cooldown bars."

L["BARTEST_NAME"] = "Test bars"
L["BARTEST_DESC"] = "Shows an example cooldown bar."

L["BARS_NAME"] = "Cooldown bars"
L["BARS_DESC"] = "Configuration of the cooldown bars."

L["BARFONT_NAME"] = "Bar font"
L["BARFONT_DESC"] = "Sets the font to use for cooldown bars."

L["BARTEXTURE_NAME"] = "Bar texture"
L["BARTEXTURE_DESC"] = "Sets the texture to use for cooldown bars."

L["CUSTOM_NAME"] = "Custom spells"
L["CUSTOM_DESC"] = "You can add arbitrary spells to track from here. Spell IDs can be found out using the 'Debug spells' option. Custom spells are never automatically removed like the built-in ones, and the name and icon used are taken from the spell itself."

L["NEWCUSTOM_NAME"] = "New custom spell"
L["NEWCUSTOM_DESC"] = "Enter the spell ID of a spell to start tracking it."

L["REMOVECUSTOM_NAME"] = "Remove a custom spell"
L["REMOVECUSTOM_DESC"] = "Select a custom spell to stop tracking it."

--ProcodileFu.lua
L["Procodile"] = true
L["Procs"] = true
L["PPM"] = true
L["Uptime"] = true
L["Cooldown"] = true
L["Hint: Ctrl-Click to reset."] = true
L["Shift-click to toggle tracking."] = true
L["Right-click to configure"] = true
