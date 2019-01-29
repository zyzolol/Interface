
------------
-- GERMAN
------------

if( GetLocale() == "deDE" ) then

SS_VS = "(%svs%s)";
SS_CONFIRM_QUEUED = "Seid Ihr sicher, dass ihr die Warteschlange f\195\188r %s verlassen wollt?";
SS_CONFIRM_DEFAULT = "Ihr seid gerade dabei, %s zu verlassen, seid Ihr sicher?";
SS_CONFIRM_ACTIVE = "Ihr seid gerade dabei, das aktive Schlachtfeld %s zu verlassen, seid Ihr sicher?";
SS_CONFIRM_BFLEAVE = "Ihr seid gerade dabei, ein aktives Schlachtfeld zu verlassen, seid Ihr sicher?";

SS_AUTORELEASING = "Automatischer Release";
SS_ARENA = "Arena";
SS_ARENAS = "Arenas";

SS_PVP = "SSPVP";

SS_SOLO_QUEUED = "Ihr seid nun allein angemeldet f\195\188r %s";
SS_BG_GOSSIP = "Ich m\195\182chte das Schlachtfeld betreten.";
SS_BG_HOLIDAY_GOSSIP = "Ich m\195\182chte mich dem Kampf anschlie\195\159en!";
SS_ARENA_GOSSIP = "Ich m\195\182chte in der Arena k\195\164mpfen.";
SS_AVAILABLEBG = "Ein anderes Schlachtfeld steht zum Beitreten bereit, Auto-Verlassen wurde deaktiviert.";

SS_SOUNDSTOPPED = "Abspielen von Sounddatei %s angehalten";
SS_SOUNDERROR = "Es scheint, dass Eure Musikeinstellungen nicht aktiviert sind, um die Datei zu h\195\182ren, die Ihr versucht abzuspielen.";
SS_PLAYINGSOUND = "Spiele Sounddatei %s";

SS_INSIDEGROUP = "Ihr seid derzeit in einer Gruppe. %s";
SS_INSIDEBG = "Ihr seid derzeit in einem aktiven Schlachtfeld. %s";
SS_INSIDEINSTANCE = "Ihr seid derzeit in einer Instanz. %s";
SS_ISAFK = "Ihr seid gerade AFK. %s";

SS_JOIN_DISABLED = "Auto-Beitreten ist deaktiviert. %s";
SS_MOD_DISABLED = "SSPVP ist deaktiviert. %s";

SS_WINDOW_HIDDEN = "Warteschlangenfenster ist verborgen. %s";

SS_READY_TO_JOIN = "Ihr seid nun bereit zum Beitreten von %s und werdet automatisch beitreten in %d Sekunden.";

SS_UPGRADED_CONFIG = "SSPVP-Konfiguration erweitert auf %s.";

SS_FACTOTALS = "Fraktionsverteilung";
SS_STATS = "Statistiken";

SS_BALANCE_TOTAL = "[SS] %s (Spieler)";
SS_SERVER_TOTAL = "[SS] %s";
SS_CLASS_TOTAL = "[SS] %s";

SS_ALWAYSDRAG = "Links klicken und ziehen, um den Rahmen zu verschieben.\nRechts klicken, um die Position zur\195\188ckzusetzen.";

-- Auto admin ( this will only run inside a battleground )
-- LEADER, SWAP and INFO_TRIG should all be lower case
SS_AA_LEADER = "leader"; -- Give leader to someone
SS_AA_NOW_LEADER = "<SSPVP> Du bist nun der Gruppenanf\195\188hrer.";
SS_AA_SWAP = "tausche (.+) mit (.+)";
SS_AA_INFO = "<SSPVP> Fl\195\188stere mir " .. SS_AA_LEADER .. " um Anf\195\188hrer zu werden, oder 'tausche person1 mit person2', um Spieler zu bewegen.";
SS_AA_CANTFIND = "<SSPVP> Kann niemanden mit dem Namen %s finden - beachte dass der Name exakt stimmen muss.";
SS_AA_INCOMBAT = "Ich bin gerade im Kampf und kann keine Leute verschieben, bitte warte kurz und probiere es noch einmal.";

-- Different cases to match for to send out the SS_AA_INFO message
SS_AA_INFO_TRIG = {};
SS_AA_INFO_TRIG[1] = "schiebe mich in";
SS_AA_INFO_TRIG[2] = "kannst du mich";
SS_AA_INFO_TRIG[3] = "gib mir";
SS_AA_INFO_TRIG[4] = "!ssinfo";
SS_AA_INFO_TRIG[5] = "leader pl";
SS_AA_INFO_TRIG[6] = "can you switch";
SS_AA_INFO_TRIG[7] = "can you give";

-- lazy talk trigs
SS_AA_INFO_TRIG[8] = "can u put";
SS_AA_INFO_TRIG[9] = "can u move";
SS_AA_INFO_TRIG[10] = "can u give";
SS_AA_INFO_TRIG[11] = "can u switch";

-- score tooltip stuff
SS_ROW_FORMAT = "%s: %s";
SS_SERVER = "Serververteilung";
SS_CLASS = "Klassenverteilung";
SS_RANKS = "Rangverteilung";
SS_SCORE_TOOLTIP = "%s (%s Spieler)\n\n%s\n%s\n\n%s\n%s";

-- Queue overlay
SS_QUEUED = "Schlachtfeld-Warteschlangen";
SS_JOINDISABLED = "Auto-Beitreten deaktiviert";
SS_JOINING = "Beitreten";
SS_UNAVAILABLE = "Nicht verf\195\188gbar";
SS_BGINFO = "Schlachtfeldinfo";
SS_STARTIN = "Startet in";

-- Command
SS_CMD_MODSTATUS = "SSPVP ist nun %s!";
SS_CMD_ON = "EIN";
SS_CMD_OFF = "AUS";

-- Displayed when you are the final blow against a NPC or player in a battleground
SS_KILLING_BLOW = "T\195\182dlicher Schlag!"

SS_UI_TAB_BG = "Schlachtfelder";
SS_UI_TAB_JOIN = "Auto-Beitreten";
SS_UI_TAB_LEAVE = "Auto-Verlassen";
SS_UI_TAB_GENERAL = "Allgemein";
SS_UI_TAB_QUEUE = "Warteschlangen";
SS_UI_TAB_BGOVERLAY = "BG Infofenster";

SS_UI_GENERAL_ENABLE = "Aktiviere SSPVP";
SS_UI_GENERAL_SOUND = "Sound abspielen wenn Warteschlange bereit";
SS_UI_GENERAL_PLAY = "Sound abspielen";
SS_UI_GENERAL_STOP = "Sound anhalten";
SS_UI_GENERAL_DISABLECLICK = "Deaktiviere Klicken des Info-Fensters";
SS_UI_GENERAL_INSTANCEID = "Zeige Schlachtfeld-Instanz-ID im Info-Fensters";
SS_UI_GENERAL_STARTTIME = "Zeit bis zum Start des Schlachtfelds im Info-Fenster";
SS_UI_GENERAL_STARTTIME_TT = "Zeigt verbleibende Sekunden bis zum Start des Schlachtfelds im Info-Fenster.";
SS_UI_GENERAL_FACTIONBALANCE = "Zeige Fraktionsverteilung im Info-Fensters";
SS_UI_GENERAL_FACTIONBALANCE_TT = "Zeigt die Anzahl der Spieler im Schlachtfeld, wenn das Maximum bei beiden Fraktionen errreicht ist, wird sie automatisch ausgeblendet.";
SS_UI_GENERAL_LOCKALWAYS = "Fixiere PVP-Ziel-Rahmen";
SS_UI_GENERAL_LOCKALWAYS_TT = "Erlaubt euch, den Anzeigerahmen der Schlachtfeldinfos, wie z.B. die kontrollierten T\195\188rme im World PVP, oder die Punkteanzeige in der Kriegshymnenschlucht zu verschieben.";

SS_UI_AUTO_SOLO = "Automatische Soloanmeldung au\195\159erhalb einer Gruppe";
SS_UI_AUTO_GROUP = "Automatische Gruppenanmeldung innerhalb einer Gruppe";

SS_UI_LEAVE_ENABLE = "Aktiviere Auto-Verlassen";
SS_UI_LEAVE_TIMEOUT = "Sekunden vor Auto-Verlassen.";

SS_UI_BG_SKIPGOSSIP = "Waffenmeister-Text \195\188berspringen";
SS_UI_BG_IGNORESS = "Immer Auto-Release, egal ob ein Seelenstein aktiv ist";
SS_UI_BG_RELEASE = "Auto-Release bei Tod";
SS_UI_BG_AUTORES = "Automatisch wiederbeleben, wenn m\195\182glich";
SS_UI_BG_GROUPADMIN = "Aktiviere automatischen Gruppen-Admin?";
SS_UI_BG_GROUPADMIN_TT = "Erlaubt Spielern, die Gruppe zu wechseln oder Gruppenf\195\188hrer zu beantragen. Funktioniert nur in einem Schlachtfeld und wenn Du der Gruppenanf\195\188hrer bist.\nFl\195\188sternachrichten: leader, tausche person1 mit person2.\nBestimmte Stichw\195\182rter oder !ssinfo senden eine Anleitung zur\195\188ck.";
SS_UI_BG_RECORDLEVEL = "Zeige Gegnerlevel auf der Punkteanzeige";
SS_UI_BG_RECORDLEVEL_TT = "Zeichnet die Gegnerlevel im Schlachtfeld auf, wenn Ihr sie anvisiert, oder mit der Maus \195\188berfahrt. Diese Daten werden nur f\195\188r die aktuelle Session gespeichert, wenn Ihr ausloggt, werden sie entfernt.";

SS_UI_JOIN_ENABLE = "Aktiviere Auto-Beitreten"
SS_UI_JOIN_TIMEOUT = "Sekunden vor Auto-Beitreten";
SS_UI_JOIN_AFKTIMEOUT = "Sekunden vor Auto-Beitreten wenn AFK";
SS_UI_JOIN_AFK = "Beitreten wenn AFK";
SS_UI_JOIN_BG = "Beitreten in einem aktiven Schlachtfeld";
SS_UI_JOIN_GROUPED = "Beitreten trotz Gruppe";

SS_UI_QUEUE_SHOWETA = "Zeige ETA auf Warteschlangen-Infofenster";
SS_UI_QUEUE_ETAFORMAT = "ETA-Format";
SS_UI_QUEUE_ENABLE = "Aktiviere Warteschlangen-Infofenster";
SS_UI_QUEUE_SHOWINBG = "Zeige Warteschlangen-Infofenster in Schlachtfeldern";

SS_UI_MINSEC = "Min X, Sek X";
SS_UI_MIN = "Min X";
SS_UI_MMSS = "mm:ss";

SS_UI_LEAVE_CONFIRM = "Best\195\164tigung f\195\188r Verlassen des Schlachtfelds";
SS_UI_LEAVE_CONFIRM_TT = "Best\195\164tigt, dass Ihr das Schlachtfeld wirklich verlassen wollt, wenn Ihr daf\195\188r das PVP-Icon Eurer Minimap nutzt.\nDies funktioniert nicht f\195\188r Klicken von Schlachtfeld/Arena verlassen auf der Pukteanzeige.";

SS_UI_BG_MINIMAP = "\195\150ffne Minimap beim Beitreten";
SS_UI_GROUP_ADMIN = "Spielern erlauben die Nutzer in Eurer Gruppe im Schlachtfeld zu verschieben?";

SS_UI_BG_AUTOSS = "Akzeptiere automatische Seelenstein-Wiedererweckung";

SS_UI_JOIN_WINDOW = "Beitreten w\195\164hrend Zutrittsfenster verborgen ist?";

SS_UI_GENERAL_KILLINGBLOW = "Killing Blow Alarm";
SS_UI_GENERAL_KILLINGBLOWCOLOR = "Killing Blow Textfarbe";

SS_UI_BG_CLASSSCORE = "Namen auf Punkteanzeige in Klassenfarbe einf\195\164rben";
SS_UI_BG_HIDECLASSICON = "Verberge Klassenicon auf der Punkteanzeige";

end