--[[ $Id: Locale.lua 14438 2006-10-19 22:51:26Z hshh $ ]]--
local L = AceLibrary("AceLocale-2.2"):new("RangeRecolor")
L:RegisterTranslations("frFR", function()
	return {
		["style_desc"] = "Le style de la recoloration a été changé.",
		["custom_desc"] = "Style personnalisé.",
		["custom_usage"] = "<r=num,v=num,b=num>",
		["reset_desc"] = "Réinitialiser tous les paramètres.",
		["MSG_RR_ON"] = "RangeRecolor activé.",
		["MSG_RR_OFF"] = "RangeRecolor desactivé.",
		["MSG_RESETED"] = "Tous les paramètres ont été réinitialisé."
	}
end)