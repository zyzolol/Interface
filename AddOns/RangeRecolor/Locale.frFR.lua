--[[ $Id: Locale.lua 14438 2006-10-19 22:51:26Z hshh $ ]]--
local L = AceLibrary("AceLocale-2.2"):new("RangeRecolor")
L:RegisterTranslations("frFR", function()
	return {
		["style_desc"] = "Le style de la recoloration a �t� chang�.",
		["custom_desc"] = "Style personnalis�.",
		["custom_usage"] = "<r=num,v=num,b=num>",
		["reset_desc"] = "R�initialiser tous les param�tres.",
		["MSG_RR_ON"] = "RangeRecolor activ�.",
		["MSG_RR_OFF"] = "RangeRecolor desactiv�.",
		["MSG_RESETED"] = "Tous les param�tres ont �t� r�initialis�."
	}
end)