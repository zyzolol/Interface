--[[ $Id: Locale.lua 41746 2007-06-26 10:09:43Z hshh $ ]]--
local L = AceLibrary("AceLocale-2.2"):new("RangeRecolor")
L:RegisterTranslations("enUS", function()
	return {
		["style_desc"] = "Button re-color style is changed.",
		["custom_desc"] = "Custom color style.",
		["custom_usage"] = "<r=num,g=num,b=num>",
		["reset_desc"] = "Reset all settings to default.",
		["MSG_RR_ON"] = "RangeRecolor enabled.",
		["MSG_RR_OFF"] = "RangeRecolor disabled.",
		["MSG_RESETED"] = "All settings are reseted to default."
	}
end)