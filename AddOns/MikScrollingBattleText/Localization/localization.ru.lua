-------------------------------------------------------------------------------
-- Title: Mik's Scrolling Battle Text Russian Localization
-- Author: Mik
-- Russian Translation by: Eritnull
-------------------------------------------------------------------------------

-- Don't do anything if the locale isn't Russian.
if (GetLocale() ~= "ruRU") then return; end

-- Local reference for faster access.
local L = MikSBT.translations;

-------------------------------------------------------------------------------
-- Russian localization
-------------------------------------------------------------------------------

------------------------------
-- Fonts
------------------------------

L.FONT_FILES = {
 Default		= "Fonts\\NIM_____.ttf",
 Morpheus		= "Fonts\\MORPHEUS.TTF",
 Skurri			= "Fonts\\SKURRI.TTF",
}


------------------------------
-- Commands
------------------------------

L.COMMAND_USAGE = {
 "Используйте: " .. MikSBT.COMMAND .. " <команда> [параметр]",
 " Команды:",
 "  " .. L.COMMAND_RESET .. " - Сброс текущего профиля на стандартные настройки.",
 "  " .. L.COMMAND_DISABLE .. " - Отключить данный мод.",
 "  " .. L.COMMAND_ENABLE .. " - Включить данный мод.",
 "  " .. L.COMMAND_SHOWVER .. " - Показать текущую версию.",
 "  " .. L.COMMAND_HELP .. " - Показать доступные команды.",
};


------------------------------
-- Output messages
------------------------------

L.MSG_ICON_MODULE_WARNING		= "ПРЕДУПРЕЖДЕНИЕ: Модуль MSBTIcons больше не требуется. Удалите его из папки AddOns во избежания загрузки ресурсов ЦПУ.";
--L.MSG_SEARCH_ENABLE			= "Event search mode enabled.  Searching for: ";
--L.MSG_SEARCH_DISABLE			= "Event search mode disabled.";
L.MSG_DISABLE					= "Мод отключен.";
L.MSG_ENABLE					= "Мод включен.";
L.MSG_PROFILE_RESET				= "Сброс профиля";
L.MSG_HITS						= "Попадания";
L.MSG_CRIT						= "Крит";
L.MSG_CRITS						= "Критов";
L.MSG_MULTIPLE_TARGETS			= "Multiple";
L.MSG_READY_NOW					= "Готов";


------------------------------
-- Scroll area names
------------------------------

L.MSG_INCOMING			= "Входящий";
L.MSG_OUTGOING			= "Исходящий";
L.MSG_NOTIFICATION		= "Извещения";
L.MSG_STATIC			= "Статический";


----------------------------------------
-- Master profile event output messages
----------------------------------------

L.MSG_COMBAT					= "Бой";
L.MSG_DISPEL					= "Рассеяно";
L.MSG_CP						= "Приём в Серии";
L.MSG_CP_FULL					= "Прикончи!";
L.MSG_KILLING_BLOW				= "Победный удар!";
L.MSG_TRIGGER_LOW_HEALTH		= "Малый запас здоровья";
L.MSG_TRIGGER_LOW_MANA			= "Малый запас маны";
L.MSG_TRIGGER_LOW_PET_HEALTH	= "Малый запас здоровья питомца";
