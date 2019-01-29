---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2007  Prat Development Team
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to:
--
-- Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor,
-- Boston, MA  02110-1301, USA.
--
--
-------------------------------------------------------------------------------
--[[
Name: Frameworks
Revision: $Revision: 79186 $
Author(s): Sylvaanar (sylvanaar@mindspring.com)
Website: http://files.wowace.com/Prat/
Description: Logical naming of libraries used througout Prat and all its modules.
]]

PRAT_LIBRARY = AceLibrary

--PRAT_LIBRARY = Rock



PRAT_FRAMEWORKNAME = "Ace2"
--PRAT_FRAMEWORKNAME = "Rock"

PRAT_FRAMEWORK = {
    Ace2 = {
        LOCALIZATION = "AceLocale-2.2",
        PVP = "Glory-2.0",
        MEDIA = "LibSharedMedia-3.0",
        PARSING = "Deformat-2.0",
        BASE = "AceAddon-2.0",
        BARMENU = "FuBarPlugin-2.0", 
        TOOLTIPS = "Tablet-2.0", 
        WINDOWMENU = "Waterfall-1.0",
        EVENTS = "AceEvent-2.0",
        DATASTORE = "AceDB-2.0",
        CLASSTRANSLATIONS = "Babble-Class-2.2",
        TABCOMPLETION = "AceTab-2.0",
        DEBUGROUTING = "DebugStub-1.0", 
        CONSOLEMENU = "AceConsole-2.0", 
        NOTIFICATIONS = "Sink-1.0", 
        DEBUG = "AceDebug-2.0",
        HOOKS = "AceHook-2.1",
        MODULES = "AceModuleCore-2.0", 
        DROPDOWNMENU = "Dewdrop-2.0",
        WHO = "WhoLib-1.0",

		NEW = "new",
		NEWLOCALENAMESPACE = "new", 
		NEWLOCALE = "RegisterTranslations",
		NEWDATABASE = "RegisterDB", 
		NEWSLASHCOMMAND = "RegisterChatCommand", 
		FUBAROPTIONS = "GetAceOptionsDataTable",
		GETDATABASE = "AcquireDBNamespace",
		SETDATABSEDEFAULTS = "RegisterDefaults", 
		REGISTEREVENT = "RegisterEvent", 
		UNREGISTEREVENT = "UnregisterEvent",
		RAISEEVENT = "TriggerEvent", 
		HOOK = "Hook",
		SECUREHOOK = "SecureHook",

    },
    
--    Rock = {
--        LOCALIZATION = "LibRockLocale-1.0",
--        MEDIA = "LibSharedMedia-2.0",
--        BASE = "LibRock-1.0",
--        BARMENU = "LibFuBarPlugin-3.0", 
--        EVENTS = "LibRockEvent-1.0",
--        DATASTORE = "LibRockDB-1.0",
--        CONSOLEMENU = "LibRockConsole-1.0", 
--        HOOKS = "LibRockHook-1.0",
--        MODULES = "LibRockModuleCore-1.0",     
--
--        -- UNCHANGED --
--        PARSING = "Deformat-2.0",
--        PVP = "Glory-2.0",
--
--		-- ADDITIONAL --
--		TIMERS = "LibRockTimer-1.0", 
--
--        -- TODO -- 
--        TOOLTIPS = "Tablet-2.0", 
--        WINDOWMENU = "Waterfall-1.0",
--        CLASSTRANSLATIONS = "Babble-Class-2.2",
--        TABCOMPLETION = "AceTab-2.0",
--        DEBUGROUTING = "DebugStub-1.0", 
--        WHO = "WhoLib-1.0", 
--        NOTIFICATIONS = "Sink-1.0", 
--        --DEBUG = "AceDebug-2.0",
--        --DROPDOWNMENU = "Dewdrop-2.0",
--
--		NEW = "NewAddon",
--		NEWLOCALENAMESPACE = "GetTranslationNamespace", 
--		NEWLOCALE = "AddTranslations",
--		FIRSTMIXIN = true,
--		NEWDATABASE = "SetDatabase", 
--		NEWSLASHCOMMAND = "AddSlashCommand", 
--		FUBAROPTIONS = "GetEmbedRockConfigOptions",
--		GETDATABASE = "GetDatabaseNamespace", 
--		SETDATABSEDEFAULTS = "SetDatabaseDefaults", 
--		REGISTEREVENT = "AddEventListener", 
--		UNREGISTEREVENT = "RemoveEventListener",
--		RAISEEVENT = "DispatchEvent", 
--		HOOK = "Hook",
----		HOOK = "AddHook",
--		SECUREHOOK = "AddSecureHook",
--    }
}


--if Rock and PRAT_LIBRARY == Rock and not Rock.HasInstance then
--	Rock.HasInstance = function(source, a, b)
--		if type(b) == "boolean" and b == false then 
--            Rock:GetLibrary(a, false, true)
--		else
--            Rock:GetLibrary(a, true, true)
--		end				
--	end
--end 



PRATLIB = PRAT_FRAMEWORK[PRAT_FRAMEWORKNAME]
