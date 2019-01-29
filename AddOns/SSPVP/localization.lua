SSPVPVersion = "2.3.8";

-----------
-- ENGLISH
-----------
SS_VS = "(%svs%s)";
SS_CONFIRM_QUEUED = "You are about to leave the queue for %s, are you sure?";
SS_CONFIRM_DEFAULT = "You are about to leave %s, are you sure?";
SS_CONFIRM_ACTIVE = "You are about to leave the active battlefield %s, are you sure?";
SS_CONFIRM_BFLEAVE = "You are about to leave an active battlefield, are you sure?";

SS_AUTORELEASING = "Auto Releasing";
SS_ARENA = "Arena";
SS_ARENAS = "Arenas";

SS_PVP = "SSPVP";

SS_SOLO_QUEUED = "You are now solo queued for %s";
SS_BG_GOSSIP = "I would like to go to the battleground.";
SS_BG_HOLIDAY_GOSSIP = "I wish to join the battle!";
SS_ARENA_GOSSIP = "I would like to fight in an arena.";
SS_AVAILABLEBG = "Another battlefield is ready to join, auto leave has been disabled.";

SS_SOUNDSTOPPED = "Stopped playing file %s";
SS_SOUNDERROR = "It appears that your sound settings aren't enabled to hear the file you are trying to play.";
SS_PLAYINGSOUND = "Playing sound file %s";

SS_INSIDEGROUP = "You are currently grouped. %s";
SS_INSIDEBG = "You are currently inside an active battlefield. %s";
SS_INSIDEINSTANCE = "You are currently inside an instance. %s";
SS_ISAFK = "You are currently AFK. %s";

SS_JOIN_DISABLED = "Auto join is disabled. %s";
SS_MOD_DISABLED = "SSPVP is disabled. %s";

SS_WINDOW_HIDDEN = "Queue window is hidden. %s";

SS_READY_TO_JOIN = "You are now eligible to join %s and will be auto joined in %d seconds.";

SS_UPGRADED_CONFIG = "Upgraded SSPVP configuration to %s.";

SS_FACTOTALS = "Faction Balance";
SS_STATS = "Stats";

SS_BALANCE_TOTAL = "[SS] %s (%s players)";
SS_SERVER_TOTAL = "[SS] %s";
SS_CLASS_TOTAL = "[SS] %s";

SS_ALWAYSDRAG = "Left click and drag to move the frame.\nRight click to reset the position.";


-- Auto admin ( this will only run inside a battleground )
-- LEADER, SWAP and INFO_TRIG should all be lower case
SS_AA_LEADER = "leader"; -- Give leader to someone
SS_AA_NOW_LEADER = "<SSPVP> You are now group leader.";
SS_AA_SWAP = "swap (.+) for (.+)";
SS_AA_INFO = "<SSPVP> Whisper me " .. SS_AA_LEADER .. " for group leader, or swap person1 for person1 to move people around.";
SS_AA_CANTFIND = "<SSPVP> Cannot find anyone by the name of %s, remember that the name needs to be exact however casing does not matter.";
SS_AA_INCOMBAT = "I am currently in combat and cannot move people around, please wait and try again.";

-- Different cases to match for to send out the SS_AA_INFO message
SS_AA_INFO_TRIG = {};
SS_AA_INFO_TRIG[1] = "move me into";
SS_AA_INFO_TRIG[2] = "can you move";
SS_AA_INFO_TRIG[3] = "can you put";
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
SS_SERVER = "Server Balance";
SS_CLASS = "Class Balance";
SS_RANKS = "Rank Balance";
SS_SCORE_TOOLTIP = "%s (%s players)\n\n%s\n%s\n\n%s\n%s";

-- Queue overlay
SS_QUEUED = "Battleground queues";
SS_JOINDISABLED = "Auto join disabled";
SS_JOINING = "Joining";
SS_UNAVAILABLE = "Unavailable";
SS_BGINFO = "Battleground info";
SS_STARTIN = "Starting In";

-- Command
SS_CMD_MODSTATUS = "SSPVP is now %s!";
SS_CMD_ON = "ON";
SS_CMD_OFF = "OFF";

-- Displayed when you are the final blow against a NPC or player in a battleground
SS_KILLING_BLOW = "Killing Blow!"

SS_UI_TAB_BG = "Battlegrounds";
SS_UI_TAB_JOIN = "Auto Join";
SS_UI_TAB_LEAVE = "Auto Leave";
SS_UI_TAB_GENERAL = "General";
SS_UI_TAB_QUEUE = "Queue Overlay";
SS_UI_TAB_BGOVERLAY = "BG Overlay";

SS_UI_GENERAL_ENABLE = "Enable SSPVP";
SS_UI_GENERAL_SOUND = "File to play when queue is ready";
SS_UI_GENERAL_PLAY = "Play Sound";
SS_UI_GENERAL_STOP = "Stop Sound";
SS_UI_GENERAL_DISABLECLICK = "Disable overlay clicking";
SS_UI_GENERAL_INSTANCEID = "Display battlefield instance ID on overlay";
SS_UI_GENERAL_STARTTIME = "Time until battlefield start on overlay";
SS_UI_GENERAL_STARTTIME_TT = "Shows how many seconds until the battlefield starts on the overlay.";
SS_UI_GENERAL_FACTIONBALANCE = "Display faction balance on overlay";
SS_UI_GENERAL_FACTIONBALANCE_TT = "Displays how many players are inside a battleground, if the maximum limit has been reached by both factions it'll auto hide.";
SS_UI_GENERAL_LOCKALWAYS = "Lock PVP objectives frame";
SS_UI_GENERAL_LOCKALWAYS_TT = "Allows you to move the frame that displays information like how many towers each faction controls in world PVP, or the score inside Warsong Gulch.";

SS_UI_AUTO_SOLO = "Auto solo queue when outside of a group";
SS_UI_AUTO_GROUP = "Auto group queue when inside a group";

SS_UI_LEAVE_ENABLE = "Enable auto leave";
SS_UI_LEAVE_TIMEOUT = "Seconds before auto leaving";

SS_UI_BG_SKIPGOSSIP = "Skip battlemaster gossip";
SS_UI_BG_IGNORESS = "Always auto release regardless of a soulstone being active";
SS_UI_BG_RELEASE = "Auto release on death";
SS_UI_BG_AUTORES = "Auto ressurect when available?";
SS_UI_BG_GROUPADMIN = "Enable auto group admin?";
SS_UI_BG_GROUPADMIN_TT = "This will allow people to move around or get leader from you, this will only work inside a battleground and if you are group leader.\n\nIf you're whispered leader you'll give leader to whoever sent the message, people will be moved around when you're whispered swap person1 for person2.\n\nCertain word combinations or !ssinfo will whisper the info text with how to request leader or swap people.";
SS_UI_BG_RECORDLEVEL = "Show enemy level on scoreboard";
SS_UI_BG_RECORDLEVEL_TT = "Records enemy levels inside battlegrounds when you target them, or mouseover them. This data is only saved in your current session, once you log off the data will be removed.";

SS_UI_JOIN_ENABLE = "Enable auto join"
SS_UI_JOIN_TIMEOUT = "Seconds before auto joining";
SS_UI_JOIN_AFKTIMEOUT = "Seconds before auto joining while AFK";
SS_UI_JOIN_AFK = "Join while AFK";
SS_UI_JOIN_BG = "Join inside an active battlefield";
SS_UI_JOIN_GROUPED = "Join while grouped";

SS_UI_QUEUE_SHOWETA = "Show ETA on queue overlay";
SS_UI_QUEUE_ETAFORMAT = "ETA format";
SS_UI_QUEUE_ENABLE = "Enable queue overlay";
SS_UI_QUEUE_SHOWINBG = "Show queue overlay inside battlegrounds";

SS_UI_MINSEC = "Min X, Sec X";
SS_UI_MIN = "Min X";
SS_UI_MMSS = "mm:ss";

SS_UI_LEAVE_CONFIRM = "Battleground leave confirmation";
SS_UI_LEAVE_CONFIRM_TT = "Confirms that you really want to leave a battleground when exiting through the PvP icon on your minimap.\nThis does not apply to clicking leave arena/battlefield on the scoreboard.";

SS_UI_BG_MINIMAP = "Auto open battlefield minimap";
SS_UI_GROUP_ADMIN = "Allow players to move users in your group inside a battleground?";

SS_UI_BG_AUTOSS = "Auto accept soul stone ressurection?";

SS_UI_JOIN_WINDOW = "Join while entry window is hidden?";

SS_UI_GENERAL_KILLINGBLOW = "Killing Blow Alert";
SS_UI_GENERAL_KILLINGBLOWCOLOR = "Killing Blow Color";

SS_UI_BG_CLASSSCORE = "Color name by class color on scoreboard";
SS_UI_BG_HIDECLASSICON = "Hide class icon on scoreboard";