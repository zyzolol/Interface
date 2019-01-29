SSTurnInVersion = "2.0.0";

--[[
************
** ENGLISH
************
]]

SST_CMD_ENABLED = "SSTurn is %s";
SST_ON = "ON";
SST_OFF = "OFF";

SST_HELP = {};
table.insert( SST_HELP, "/ssturn <on/off> - Changes the mod status" );
table.insert( SST_HELP, "/ssturn status - Configuration status" );

SST_HELP_CAT = "/ssturn %s <on/off> - Auto complete %s?";
SST_CAT_ENABLED = "%s is %s";

SST_REMOVED_SKIP = "Quest removed from auto-skip!";
SST_ADDED_SKIP = "Quest added to skip list, you can hold ALT down while clicking the quest again to remove it.";

-- UI
SST_UI_TAB = "Auto-Complete";
SST_UI_ENABLE = "Enable SSTurn in";
SST_UI_CAT_STATUS = "Disable %s";


-- categories and data and such

SST_QUESTTYPE = {};

-- Used for categories in configuration
table.insert( SST_QUESTTYPE, { cat = "av", text = "Alterac Valley quests" } );
table.insert( SST_QUESTTYPE, { cat = "manual", text = "Manually added quests" } );

SST_QUESTLIST = {};

-- Neutral Alterac Valley quests
table.insert( SST_QUESTLIST, { name = "Irondeep Supplies", type = "av" } );
table.insert( SST_QUESTLIST, { name = "Coldtooth Supplies", type = "av" } );

-- Alliance Alterac Valley quests
table.insert( SST_QUESTLIST, { name = "More Armor Scraps", type = "av", item = { 17422 }, quantity = { 20 } } );
table.insert( SST_QUESTLIST, { name = "Ivus the Forest Lord", type = "av", item = { 17423 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Crystal Cluster", type = "av", item = { 17423 }, quantity = { 5 } } );
table.insert( SST_QUESTLIST, { name = "Ram Riding Harnesses", type = "av", item = { 17643 }, quantity = { 1 } } );

table.insert( SST_QUESTLIST, { name = "Slidore's Fleet", type = "av", item = { 17502 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Vipore's Fleet", type = "av", item = { 17503 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Ichman's Fleet", type = "av", item = { 17504 }, quantity = { 1 } } );

-- Horde Alterac Valley quests
table.insert( SST_QUESTLIST, { name = "More Booty", type = "av", item = { 17422 }, quantity = { 20 } } );
table.insert( SST_QUESTLIST, { name = "A Gallon of Blood", type = "av", item = { 17306 }, quantity = { 5 } } );
table.insert( SST_QUESTLIST, { name = "Lokholar the Ice Lord", type = "av", item = { 17306 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Ram Hide Harness", type = "av", item = { 17642 }, quantity = { 1 } } );

table.insert( SST_QUESTLIST, { name = "Guse's Fleet", type = "av", item = { 17326 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Jeztor's Fleet", type = "av", item = { 17327 }, quantity = { 1 } } );
table.insert( SST_QUESTLIST, { name = "Mulverick's Fleet", type = "av", item = { 17328 }, quantity = { 1 } } );