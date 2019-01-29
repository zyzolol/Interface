
------------
-- GERMAN
------------

if( GetLocale() == "deDE" ) then

BINDING_HEADER_SSWSG = "SSWSG";
BINDING_NAME_SSETARFLAG = "Feindlichen Flaggentr\195\164ger anvisieren";
BINDING_NAME_SSFTARFLAG = "Eigenen Flaggentr\195\164ger anvisieren";

SSWSG_TARGETTING = "anvisieren von %s";
SSWSG_OOR = "%s ist au\195\159er Reichweite!";
SSWSG_NOBODYHASFLAG = "Niemand hat die Flagge.";

SSWSG_ON = "EIN";
SSWSG_OFF = "AUS";

SSWSG_NOENEMYCARRIER = "<kein feindlicher Flaggentr\195\164ger>";
SSWSG_NOFRIENDLYCARRIER = "<kein eigener Flaggentr\195\164ger>";

SSWSG_FLAGAPPEARANCE = "Die Flagge erscheint wieder in %d Sekunden.";

SSWSG_UI_ENABLE = "Aktiviere SSWSG";
SSWSG_UI_NAMES = "Zeige Namen des Flaggentr\195\164gers neben der Punkteanzeige";
SSWSG_UI_COLOR = "\195\132ndere Namenfarbe des Flaggentr\195\164gers auf Klassenfarbe";
SSWSG_UI_CNAME = "Zeige Klasse des Flaggentr\195\164gers neben seinem Namen";
SSWSG_UI_CABBREV = "Zeige abgek\195\188rzten Klassennamen neben seinem Namen";
SSWSG_UI_FHEALTH = "Zeige Lebensenergie des eigenen Tr\195\164gers neben dem Namen";
SSWSG_UI_FLAGTIMER = "Zeige Timer bis Wiedererscheinen der Flagge nach Eroberung";

SSWSG_HELP = {};
SSWSG_HELP[1] = "/sswsg <on/off> - \195\132ndert den Status von SSFlag.";
SSWSG_HELP[2] = "/sswsg name <on/off> - Name des Flaggentr\195\164gers neben den Kriegshymnenschlucht-Punkten.";
SSWSG_HELP[3] = "/sswsg color <on/off> - Klassenfarbe des Flaggentr\195\164gers als seine Namenfarbe.";
SSWSG_HELP[4] = "/sswsg class <on/off> - Klasse des Flaggentr\195\164gers neben seinem Namen.";
SSWSG_HELP[5] = "/sswsg status - Status der SSFlag-Konfiguration.";
SSWSG_HELP[6] = "/sswsg fhealth - Lebensenergie des eigenen Flaggentr\195\164gers neben dem Namen.";
SSWSG_HELP[7] = "/sswsg flagtimer - Zeigt Timer bis Wiedererscheinen der Flagge mit 10s und 5s bevor sie auftaucht.";

SSWSG_CMD_ENABLED = "SSWSG ist %s!";
SSWSG_CMD_FLAGNAME = "Name des Flaggentr\195\164gers neben der Punkteanzeige ist %s!";
SSWSG_CMD_CLASSCOLOR = "Klassenfarbe des Flaggentr\195\164gers ist %s!";
SSWSG_CMD_FRIENDLYHEALTH = "Lebensenergie des eigenen Flaggentr\195\164gers neben dem Namen ist %s!";
SSWSG_CMD_CLASSNAME = "Klassennamen des Flaggentr\195\164gers neben seinem Namen ist %s!";
SSWSG_CMD_FLAGTIMER = "Timer bis Wiedererscheinen der Flagge ist nun %s";

end
