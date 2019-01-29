
------------
-- GERMAN
------------

if( GetLocale() == "deDE" ) then

SST_CMD_ENABLED = "SSTurn ist %s";
SST_ON = "EIN";
SST_OFF = "AUS";

SST_HELP = {};
table.insert( SST_HELP, "/ssturn <on/off> - \195\132ndert den Status des Mods" );
table.insert( SST_HELP, "/ssturn status - Konfigurationsstatus" );

SST_HELP_CAT = "/ssturn %s <on/off> - Automatisch abgeben %s?";
SST_CAT_ENABLED = "%s ist %s";

SST_REMOVED_SKIP = "Quest entfernt aus Auto-\195\156berspringen!";
SST_ADDED_SKIP = "Quest hinzugef\195\188gt zur \195\156berspringen-Liste, Ihr k\195\182nnt ALT dr\195\188cken w\195\164hrend des Klickens des Quests um es wieder zu entfernen.";

-- UI
SST_UI_TAB = "Auto-Abschluss";
SST_UI_ENABLE = "Aktiviere SSTurn in";
SST_UI_CAT_STATUS = "Deaktiviere %s";


-- categories and data and such

SST_QUESTTYPE = {};

-- Used for categories in configuration
table.insert( SST_QUESTTYPE, { cat = "manual", text = "H\195\164ndisch hinzugef\195\188gte Quests" } );
table.insert( SST_QUESTTYPE, { cat = "av", text = "Alteractal-Quests" } );

SST_QUESTLIST = {};

-- Neutral Alterac Valley quests
table.insert( SST_QUESTLIST, { name = "Irondeep-Vorr\195\164te", type = "av" } );
table.insert( SST_QUESTLIST, { name = "Coldtooth-Vorr\195\164te", type = "av" } );

-- Alliance Alterac Valley quests
table.insert( SST_QUESTLIST, { name = "Mehr R\195\188stungsfetzen", type = "av", item = { 17422 }, quantity = { 20 } } );
table.insert( SST_QUESTLIST, { name = "Ivus der Waldf\195\188rst", type = "av", item = { 17423 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Haufenweise Kristalle", type = "av", item = { 17423 }, quantity = { 5 } } );
table.insert( SST_QUESTLIST, { name = "Widderzaumzeug", type = "av", item = { 17643 }, quantity = { 1 } } );

table.insert( SST_QUESTLIST, { name = "Slidores Luftflotte", type = "av", item = { 17502 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Vipores Luftflotte", type = "av", item = { 17503 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Ichmans Luftflotte", type = "av", item = { 17504 }, quantity = { 1 } } );

-- Horde Alterac Valley quests
table.insert( SST_QUESTLIST, { name = "Mehr Beute!", type = "av", item = { 17422 }, quantity = { 20 } } );
table.insert( SST_QUESTLIST, { name = "Eine Gallone Blut", type = "av", item = { 17306 }, quantity = { 5 } } );
table.insert( SST_QUESTLIST, { name = "Lokholar der Eislord", type = "av", item = { 17306 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Widderledernes Zaumzeug", type = "av", item = { 17642 }, quantity = { 1 } } );

table.insert( SST_QUESTLIST, { name = "Guses Luftflotte", type = "av", item = { 17326 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Jeztors Luftflotte", type = "av", item = { 17327 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Mulvericks Luftflotte", type = "av", item = { 17328 }, quantity = { 1 } } );

end
