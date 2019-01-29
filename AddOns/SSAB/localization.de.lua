
------------
-- GERMAN
------------

if( GetLocale() == "deDE" ) then

SSAB_ON = "EIN";
SSAB_OFF = "AUS";

SSAB_CMD_ENABLED = "SSAB ist %s";
SSAB_CMD_INTERVAL = "Timer-Anzeigeintervall gesetzt auf %s";
SSAB_CMD_FACTIONA = "Anzeige der Allianz-Nachrichten ist %s";
SSAB_CMD_FACTIONH = "Anzeige der Horden- Nachrichten ist %s";
SSAB_CMD_TOLOWINTERVAL = "Ihr k\195\182nnt das Alarm-Intervall nicht unter 10 setzen, auf 30 zur\195\188ckgesetzt.";
SSAB_CMD_TIMELEFT = "Verbleibende Zeit im Arathibecken ist %s";
SSAB_CMD_FINALREP = "Gesamter Rufzuwachs ist %s";
SSAB_CMD_FINALSCORE = "Endstand ist %s";
SSAB_CMD_BASES = "Basen um zu gewinnen ist %s";

SSAB_UI_ENABLE = "Aktiviere Timer";
SSAB_UI_OVERLAYENABLE = "Aktiviere Info-Fenster";
SSAB_UI_INTERVAL = "Sekunden zwischen Alarmen";
SSAB_UI_HORDEENABLE = "Zeige Alarme f\195\188r Events der Horde";
SSAB_UI_ALLIANCEENABLE = "Zeige Alarme f\195\188r Events der Allianz";
SSAB_UI_TIMELEFT = "Zeige verbleibende Matchdauer";
SSAB_UI_FINALSCORE = "Zeige Endstand f\195\188r beide Fraktionen";
SSAB_UI_BASES = "Zeige f\195\188r Sieg n\195\182tige Basenanzahl";
SSAB_UI_BASES_FINAL = "Zeige Punkte der f\195\188r Sieg n\195\182tigen Basenanzahl";

SSAB_TIMERS = "Timer";

SSAB_INFO = "Match Info";
SSAB_TIMELEFT = "Zeit \195\188brig";
SSAB_BASESTOWIN = "Basen zum Sieg";
SSAB_BASES_FINAL = "(A:*extra2*/H:*extra3*)";
SSAB_FINALSCORE = "Endstand";
SSAB_FINALSCORE_REP = "Endstand: %s (%s Ruf)";
SSAB_FINALSCORE_NOREP = "Endstand: %s";

SSAB_INVALID_CHANTYPE = "Ung\195\188ltigen Channel eingegeben, %s ist kein g\195\188ltiger Channel.";
SSAB_CHAT_TIMER = "%s (%s) - %s";

SSAB_CHAT_MATCH_INFO = "Zeit \195\188brig: %s / Basen zum Sieg: %s (A:%s/H:%s)";
SSAB_CHAT_MATCH_INFO2 = "Endstand (Allianz): %s / Endstand (Horde): %s";

SSAB_HELP = {};
SSAB_HELP[1] = "/ssab <on/off> - \195\132ndert den Status des Mods";
SSAB_HELP[2] = "/ssab interval <seconds> - Sekunden zwischen jedem Alarm";
SSAB_HELP[3] = "/ssab alliance <on/off> - Zeigt Allianz-Nachrichten";
SSAB_HELP[4] = "/ssab horde <on/off> - Zeigt Horden-Nachrichten";
SSAB_HELP[5] = "/ssab timeleft <on/off> - Zeigt verbliebende Zeit im Arathibecken-Match";
SSAB_HELP[6] = "/ssab finalscore <on/off> - Zeigt Endstand an";
SSAB_HELP[8] = "/ssab base <on/off> - Zeigt Anzahl der Basen um zu gewinnen";
SSAB_HELP[9] = "/ssab basefinal <on/off> - Zeigt Punkte der f\195\188r Sieg n\195\182tigen Basenanzahl";
SSAB_HELP[10] = "/ssab print <battleground/say/guild/party/raid> - Gibt die Schlachtfeld-Timer im Chat aus";
SSAB_HELP[11] = "/ssab printmatch <battleground/say/guild/party/raid> - Gibt die Schlachtfeld-Matchinfo im Chat aus";
SSAB_HELP[12] = "/ssab status - Zeigt den Status des Mods";

SSAB_TIMERUPDATE = "%s wird erobert von der %s in %s!";

SSAB_WORLDUI = "Basen%: ([0-9]+)  Ressourcen%: ([0-9]+)/([0-9]+)";

end