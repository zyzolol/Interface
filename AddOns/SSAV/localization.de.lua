------------
-- GERMAN
------------

if( GetLocale() == "deDE" ) then

SSAV_ON = "EIN";
SSAV_OFF = "AUS";

SSAV_CMD_ENABLED = "SSAV ist %s";
SSAV_CMD_INTERVAL = "Timer-Anzeigeintervall gesetzt auf %s";
SSAV_CMD_FACTIONA = "Anzeige der Allianz-Nachrichten ist %s";
SSAV_CMD_FACTIONH = "Anzeige der Horden-Nachrichten ist %s";
SSAV_CMD_TOLOWINTERVAL = "Ihr k\195\182nnt das Alarm-Intervall nicht unter 30 setzen; auf 60 zur\195\188ckgesetzt.";
SSAV_CMD_NPCSTATUS = "NPC-Status ist %s";
SSAV_CMD_GOD = "Gott-Bewegungs-Timer sind nun %s";
SSAV_SYNC_STOPPED = "Sync angehalten";
SSAV_UI_ENABLE = "Aktiviere Timer";
SSAV_UI_ENABLEOVERLAY = "Aktiviere Alteractal-\195\156bersichtsfenster";
SSAV_UI_BLOODCRYST = "Zeige Blut/Kristalle";
SSAV_UI_ARMOR = "Zeige R\195\188stungsfetzen";
SSAV_UI_MEDALFLESH = "Zeige Fleisch/Medallien";
SSAV_UI_INTERVAL = "Sekunden zwischen Alarmen";
SSAV_UI_HORDEENABLE = "Zeige Alarme f\195\188r Events der Horde";
SSAV_UI_ALLIANCEENABLE = "Zeige Alarme f\195\188r Events der Allianz";
SSAV_UI_NPCSTATUS = "Zeige NPC-Status";
SSAV_UI_NPCSTATUS_TT = "Zeigt angegriffene oder inaktive NPCs.\nListe: Balinda Stoneheart, Galvangar, Vanndar Stormpike, Drek'Thar werden derzeit unterst\195\188tzt.\nF\195\188r Vanndar Stormpike und Drek'Thar werden Warnungen bei niedriger Gesundheit ausgegeben.";
SSAV_UI_GODSUMMON = "Zeige verbleibende Zeit, bevor sich G\195\182tter in Bewegung setzen.";
SSAV_UI_GODSUMMON_TT = "Zeigt die verbleibende Zeit an, bevor sich Ivus und Lokholar in Bewegung setzen.";

SSAV_SYNC_QUEUEING = "<SSPVP> Warteschlange f\195\188r Alteractal in %s Sekunden.";
SSAV_SYNC_QUEUED = "<SSPVP> Warteschlange f\195\188r Alteractal!";
SSAV_SYNC_QUEUE_SEC = "<SSPVP> Warteschlange in %s Sekunde(n).";
SSAV_SYNC_QUEUE_STOPPED = "[SS] Abgleich des Warteschlangen-Countdowns wurde abgebrochen.";
SSAV_SYNC_NOW = "QUEUEAV";
SSAV_SYNC_RECIEVED = "Alteractal-Warteschlangen-Anfrage von %s empfangen.";

SSAV_ITEMS = "Gegenst\195\164nde";
SSAV_TIMERS = "Timer";

SSAV_BLOOD = "Blut eines Soldaten";
SSAV_SOLDFLESH = "Fleisch eines Soldaten";
SSAV_LIETFLESH = "Fleisch eines Lieutenants";
SSAV_COMMFLESH = "Fleisch eines Kommandanten";
SSAV_CRYSTALS = "Sturmkristalle";
SSAV_ARMORSCRAP = "R\195\188stungsfetzen";
SSAV_SOLDIERMED = "Medaillen des Soldaten";
SSAV_LIETMED = "Medaillen des Lieutenant";
SSAV_COMMED = "Medaillen des Kommandanten";


SSAV_NPCSTATUS = "NPC-Status";
SSAV_OVERLAY_FORMAT = "*txt: *extra";
SSAV_NPCOVERLAY = "%s: %s";

SSAV_INVALID_CHANTYPE = "Ung\195\188ltiger Channel eingegeben, %s ist kein g\195\188ltiger Channel.";
SSAV_CHAT_TIMER = "[SS] %s (%s) - %s";


-- NPC Yell status
-- Don't translate abbrev, only name and overlay name
SSAV_NPC_NAMES = {};
table.insert( SSAV_NPC_NAMES, { name = "Captain Balinda Steinbruch", overlayName = "Balinda", faction = "Alliance", abbrev = "balinda", timeout = ( 5 * 60 ) } );
table.insert( SSAV_NPC_NAMES, { name = "Vanndar Sturmlanze", overlayName = "Vanndar", faction = "Alliance", abbrev = "vanndar", timeout = 0 } );

table.insert( SSAV_NPC_NAMES, { name = "Captain Galvangar", overlayName = "Galvangar", faction = "Horde", abbrev = "galvangar", timeout = ( 5 * 60 ) } );
table.insert( SSAV_NPC_NAMES, { name = "Drek'Thar", overlayName = "Drek'Thar", faction = "Horde", abbrev = "drek", timeout = 0 } );

SSAV_NPC_STATUS = {};
SSAV_NPC_STATUS["engaged"] = "Angegriffen";
SSAV_NPC_STATUS["reset"] = "Inaktiv";
SSAV_NPC_STATUS["lowhp"] = "Wenig HP";
SSAV_NPC_STATUS["medhp"] = "Medium HP";

SSAV_NPC_YELLS = {};

-- Vanndar
table.insert( SSAV_NPC_YELLS, { text = "Soldaten des Sturmlanzenklans, euer General wird angegriffen!", npc = "vanndar", status = "engaged" } );

table.insert( SSAV_NPC_YELLS, { text = "Ihr werdet mich niemals aus meinem Bunker", npc = "vanndar", status = "reset" } );
table.insert( SSAV_NPC_YELLS, { text = "Warum versucht Ihr es nicht nochmal", npc = "vanndar", status = "reset" } );

table.insert( SSAV_NPC_YELLS, { text = "Es braucht mehr als einen Wicht wie Euch", npc = "vanndar", status = "medhp" } );

table.insert( SSAV_NPC_YELLS, { text = "Eure Angriffe sind schwach!", npc = "vanndar", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "Der Sturmlanzenklan beugt sich niemandem", npc = "vanndar", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "Ist das alles", npc = "vanndar", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "Wir, die Allianz, werden siegen", npc = "vanndar", status = "lowhp" } );

-- Drek'Thar
table.insert( SSAV_NPC_YELLS, { text = "Sturmlanzenabschaum!", npc = "drek", status = "engaged" } );

table.insert( SSAV_NPC_YELLS, { text = "Ihr versucht, den General der Frostwolf", npc = "drek", status = "reset" } );
table.insert( SSAV_NPC_YELLS, { text = "Sturmlanzenschw\195\164chlinge, stellt Euch mir", npc = "drek", status = "reset" } );

table.insert( SSAV_NPC_YELLS, { text = "Heute werdet Ihr Euren Ahnen begegnen", npc = "drek", status = "medhp" } );
table.insert( SSAV_NPC_YELLS, { text = "Ihr seid kein Gegner f\195\188r die", npc = "drek", status = "medhp" } );

table.insert( SSAV_NPC_YELLS, { text = "Ihr k\195\182nnt den Frostwolfklan nicht besiegen!", npc = "drek", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "Eure Angriffe sind wohl durch die", npc = "drek", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "Euer Geist ist schwach", npc = "drek", status = "lowhp" } );

-- Galvangar
table.insert( SSAV_NPC_YELLS, { text = "F\195\188r Eure Art ist kein Platz im Alteractal!", npc = "galvangar", status = "engaged" } );
table.insert( SSAV_NPC_YELLS, { text = "Ich werde niemals", npc = "galvangar", status = "reset" } );

-- Balinda
table.insert( SSAV_NPC_YELLS, { text = "Verschwinde, dreckiger Abschaum!", npc = "balinda", status = "engaged" } );
table.insert( SSAV_NPC_YELLS, { text = "R\195\164udige Frostwolf-Feiglinge", npc = "balinda", status = "reset" } );


-- May add an option to sync your timers off of SSPVP broadcasted ones
SSAV_CHAT_TIMER_REGEX = "%[SS%] (.+) %((.+)%) %- ([0-9]+)%:([0-9]+)%:([0-9]+)";

SSAV_HELP = {};
SSAV_HELP[1] = "/ssav <on/off> - \195\132ndert den Status des Mods";
SSAV_HELP[2] = "/ssav interval <seconds> - Sekunden zwischen jedem Alarm";
SSAV_HELP[3] = "/ssav alliance <on/off> - Zeigt Allianz-Nachrichten";
SSAV_HELP[4] = "/ssav horde <on/off> - Zeigt Horden-Nachrichten";
SSAV_HELP[5] = "/ssav npc <on/off> - Zeigt Status der Captains, von Vanndar und Drek'Thar.";
SSAV_HELP[6] = "/ssav god <on/off> - Aktiviert Bewegungstimer f\195\188r Ivus der Waldf\195\188rst und Lotholar der Eislord.";
SSAV_HELP[7] = "/ssav sync - Startet einen 3-Sekunden-Countdown um der Warteschlange des Alteractals beizutreten, Nutzer von SSPVP 2.1 oder h\195\182her werden automatisch angemeldet so lange sie auf der Schlachtfeld beitreten-Seite sind.";
SSAV_HELP[8] = "/ssav status - Zeigt den Status des Mods";
SSAV_HELP[9] = "/ssav print <guild/party/raid/battleground/say> - Gibt die aktuellen Alteractal-Timer im Chat aus.";
SSAV_HELP[10] = "/ssav cancel - Bricht einen laufenden Abgleichs-Countdown ab";

SSAV_TIMERUPDATE = "%s wird %s von der %s in %s!";

end