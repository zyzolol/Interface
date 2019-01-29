SSAVVersion = "1.1.0";

------------
-- ENGLISH
------------

SSAV_ON = "ON";
SSAV_OFF = "OFF";

SSAV_CMD_ENABLED = "SSAV is %s";
SSAV_CMD_INTERVAL = "Timer display interval set to %s";
SSAV_CMD_FACTIONA = "Showing Alliance messages is %s";
SSAV_CMD_FACTIONH = "Showing Horde messages is %s";
SSAV_CMD_TOLOWINTERVAL = "You cannot set the alert interval below 30, reset to 60.";
SSAV_CMD_NPCSTATUS = "NPC status is %s";
SSAV_CMD_GOD = "God movement timers are now %s";
SSAV_SYNC_STOPPED = "Sync stopped";
SSAV_UI_ENABLE = "Enable timers";
SSAV_UI_ENABLEOVERLAY = "Enable Alterac Valley overlay";
SSAV_UI_BLOODCRYST = "Show blood/crystal count";
SSAV_UI_ARMOR = "Show armor scrap count";
SSAV_UI_MEDALFLESH = "Show flesh/medal count";
SSAV_UI_INTERVAL = "Seconds in between alerts";
SSAV_UI_HORDEENABLE = "Show alerts for Horde events";
SSAV_UI_ALLIANCEENABLE = "Show alerts for Alliance events";
SSAV_UI_NPCSTATUS = "Display NPC Status";
SSAV_UI_NPCSTATUS_TT = "Display engaged or inactive status for NPC's.\nCaptain Balinda Stoneheart, Captain Galvangar, Vanndar Stormpike, Drek'Thar are currently supported.\n\nVanndar Stormpike and Drek'Thar will also provide low health.\n\nRemember that this will not be 100% accurate and is only an estimation.";
SSAV_UI_GODSUMMON = "Show time left before the gods start moving";
SSAV_UI_GODSUMMON_TT = "Shows the time left before Ivus the Forst Lord or Lokholar the Ice Lord starts moving.";

SSAV_SYNC_QUEUEING = "[SS] Queueing for Alterac Valley in %s seconds.";
SSAV_SYNC_QUEUED = "[SS] Queue for Alterac Valley!";
SSAV_SYNC_QUEUE_SEC = "[SS] Queue in %s second(s).";
SSAV_SYNC_QUEUE_STOPPED = "[SS] Sync queue count down has been cancelled.";
SSAV_SYNC_NOW = "QUEUEAV";
SSAV_SYNC_RECIEVED = "Received Alterac Valley queue request from %s.";

SSAV_ITEMS = "Items";
SSAV_TIMERS = "Timers";

SSAV_BLOOD = "Soldier Bloods";
SSAV_SOLDFLESH = "Soldier Flesh";
SSAV_LIETFLESH = "Lietenant Flesh";
SSAV_COMMFLESH = "Commander Flesh";
SSAV_CRYSTALS = "Storm Crystals";
SSAV_ARMORSCRAP = "Armor Scraps";
SSAV_SOLDIERMED = "Soldier Medals";
SSAV_LIETMED = "Lietenant Medals";
SSAV_COMMED = "Commander Medals";


SSAV_NPCSTATUS = "NPC Status";
SSAV_OVERLAY_FORMAT = "*txt: *extra";
SSAV_NPCOVERLAY = "%s: %s";

SSAV_INVALID_CHANTYPE = "Invalid channel entered, %s is not a valid channel.";
SSAV_CHAT_TIMER = "[SS] %s (%s) - %s";


-- NPC Yell status
-- Don't translate abbrev, only name and overlay name
SSAV_NPC_NAMES = {};
table.insert( SSAV_NPC_NAMES, { name = "Captain Balinda Stonehearth", overlayName = "Balinda", faction = "Alliance", abbrev = "balinda", timeout = ( 5 * 60 ) } );
table.insert( SSAV_NPC_NAMES, { name = "Vanndar Stormpike", overlayName = "Vanndar", faction = "Alliance", abbrev = "vanndar", timeout = 0 } );

table.insert( SSAV_NPC_NAMES, { name = "Captain Galvangar", overlayName = "Galvangar", faction = "Horde", abbrev = "galvangar", timeout = ( 5 * 60 ) } );
table.insert( SSAV_NPC_NAMES, { name = "Drek'Thar", overlayName = "Drek'Thar", faction = "Horde", abbrev = "drek", timeout = 0 } );

SSAV_NPC_STATUS = {};
SSAV_NPC_STATUS["engaged"] = "Engaged";
SSAV_NPC_STATUS["reset"] = "Inactive";
SSAV_NPC_STATUS["lowhp"] = "Low Health";
SSAV_NPC_STATUS["medhp"] = "Medium Health";

SSAV_NPC_YELLS = {};

-- Vanndar
table.insert( SSAV_NPC_YELLS, { text = "Soldiers of Stormpike, your General is under attack!", npc = "vanndar", status = "engaged" } );
table.insert( SSAV_NPC_YELLS, { text = "You'll never get me out of me bunker", npc = "vanndar", status = "reset" } );
table.insert( SSAV_NPC_YELLS, { text = "Why don't ya try again without yer cheap", npc = "vanndar", status = "reset" } );
table.insert( SSAV_NPC_YELLS, { text = "Take no prisoners!", npc = "vanndar", status = "reset" } );


table.insert( SSAV_NPC_YELLS, { text = "It'll take more than you rabble", npc = "vanndar", status = "medhp" } );

table.insert( SSAV_NPC_YELLS, { text = "Your attacks are weak!", npc = "vanndar", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "The Stormpike clan bows to no one", npc = "vanndar", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "Is that the best you can do", npc = "vanndar", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "We, the Alliance, will prevail", npc = "vanndar", status = "lowhp" } );

-- Drek'Thar
table.insert( SSAV_NPC_YELLS, { text = "Stormpike filth!", npc = "drek", status = "engaged" } );
table.insert( SSAV_NPC_YELLS, { text = "You seek to draw the General of the Frostwolf", npc = "drek", status = "reset" } );
table.insert( SSAV_NPC_YELLS, { text = "Stormpike weaklings, face me in my fortress", npc = "drek", status = "reset" } );

table.insert( SSAV_NPC_YELLS, { text = "Today, you will meet your ancestors", npc = "drek", status = "medhp" } );
table.insert( SSAV_NPC_YELLS, { text = "You are no match for the strength of the Horde", npc = "drek", status = "medhp" } );

table.insert( SSAV_NPC_YELLS, { text = "You cannot defeat the Frostwolf", npc = "drek", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "Your attacks are slowed by the cold", npc = "drek", status = "lowhp" } );
table.insert( SSAV_NPC_YELLS, { text = "Your spirits are weak, and your blows", npc = "drek", status = "lowhp" } );

-- Galvangar
table.insert( SSAV_NPC_YELLS, { text = "Your kind has no place in Alterac Valley", npc = "galvangar", status = "engaged" } );
table.insert( SSAV_NPC_YELLS, { text = "I'll never fall for that, fool!", npc = "galvangar", status = "reset" } );

-- Balinda
table.insert( SSAV_NPC_YELLS, { text = "Begone, uncouth scum", npc = "balinda", status = "engaged" } );
table.insert( SSAV_NPC_YELLS, { text = "Filthy Frostwolf cowards", npc = "balinda", status = "reset" } );


-- May add an option to sync your timers off of SSPVP broadcasted ones
SSAV_CHAT_TIMER_REGEX = "%[SS%] (.+) %((.+)%) %- ([0-9]+)%:([0-9]+)%:([0-9]+)";

SSAV_HELP = {};
SSAV_HELP[1] = "/ssav <on/off> - Change the status of the mod";
SSAV_HELP[2] = "/ssav interval <seconds> - Seconds inbetween each alert";
SSAV_HELP[3] = "/ssav alliance <on/off> - Show Alliance messages";
SSAV_HELP[4] = "/ssav horde <on/off> - Show Horde messages";
SSAV_HELP[5] = "/ssav npc <on/off> - Displays Captain, Vanndar and Drek'Thar status.";
SSAV_HELP[6] = "/ssav god <on/off> - Enable Ivus the Forest Lord and Lotholar the Ice Lord movement timers.";
SSAV_HELP[7] = "/ssav sync <countdown> - Starts a countdown to queue for Alterac Valley, for those using SSPVP 2.1 or later they'll be auto queued as long as they are on the Join Battlefield page.";
SSAV_HELP[8] = "/ssav status - Display the status of the mod";
SSAV_HELP[9] = "/ssav print <guild/party/raid/battleground/say> - Print the current Alterac Valley timers to chat";
SSAV_HELP[10] = "/ssav cancel - Cancels a running sync countdown";

SSAV_TIMERUPDATE = "%s will be %s by the %s in %s!";