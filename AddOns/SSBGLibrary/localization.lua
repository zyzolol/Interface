-----------
-- ENGLISH
-----------

-- General
SS_HORDE = "Horde";
SS_ALLIANCE = "Alliance";

-- Should be the same text that appears on the scoreboard
SS_HORDE_STATS = SS_HORDE .. " Stats";
SS_ALLIANCE_STATS = SS_ALLIANCE .. " Stats";

SS_MINUTE = "minute";
SS_SECOND = "second";

SS_WARSONGGULCH = "Warsong Gulch";
SS_ARATHIBASIN = "Arathi Basin";
SS_ALTERACVALLEY = "Alterac Valley";
SS_EYEOFTHESTORM = "Eye of the Storm";

SS_CONTESTED = "Contested";

SS_EASTERNKING = "Eastern Kingdoms";

-- Eastern Plaguelands
SS_EASTERNPLAGUELANDS = "Eastern Plaguelands";
SS_EPL_LOCALDEF = "LocalDefense - Eastern Plaguelands";

SS_EPL_TAKEN = "(.+) has been taken by the";

-- Warsong Gulch
SS_WSG_PICKEDUP = "The %s [fF]lag was picked up by ([^!]+)!";
SS_WSG_DROPPED = "The %s [fF]lag was dropped by ([^!]+)!";
SS_WSG_CAPTURED = "(.+) captured the %s [fF]lag!";

-- Arathi Basin
SS_AB_TAKEN = "has taken the ([^!]+)!";
SS_AB_ASSAULTED = "has assaulted the ([^!]+)!";
SS_AB_CLAIMS = "claims the ([^!]+)!";

-- Alterac Valley
SS_AV_TAKEN = "(.+) was taken by the";
SS_AV_DESTROYED = "(.+) was destroyed by the";
SS_AV_CLAIMS = "claims ([^!]+)!";

SS_DESTROYED = "destroyed";
SS_CAPTURED = "captured";

-- Eye of the Storm
--Swazi has taken the flag!
--The Alliance have captured the flag!
--The flag has been reset
--The flag has been dropped!

--The arena battle has begun
SS_BATTLESTART = {};

-- WSG/AB/AV and as far as I know EoS
table.insert( SS_BATTLESTART, { search = "1 minute", time = 60 } );
table.insert( SS_BATTLESTART, { search = "30 seconds", time = 30 } );
table.insert( SS_BATTLESTART, { search = "Let the battle for", time = 0 } );
table.insert( SS_BATTLESTART, { search = "The battle for", time = 0 } );

-- Arenas
table.insert( SS_BATTLESTART, { search = "One minute until", time = 60 } );
table.insert( SS_BATTLESTART, { search = "Thirty seconds until", time = 30 } );
table.insert( SS_BATTLESTART, { search = "Fifteen seconds until", time = 15 } );
table.insert( SS_BATTLESTART, { search = "The arena battle has begun", time = 0 } );

-- This should be the exact casing/message for the claims message of a graveyard
SSAV_SNOWFALL_GY = "the Snowfall graveyard";

-- This should be the exact casing/message when the graveyard is taken
SSAV_CORRECT_SF_GY = "The Snowfall Graveyard";

SS_DESTROY = "destroy";
SS_CAPTURE = "capture";

SS_AV_UNDERATTACK = "(.+) is under attack!";

SS_HERALD = "Herald";

-- God info
SS_IVUS_FOREST_LORD = "Ivus the Forest Lord";
SS_LOKHOLAR_ICE_LORD = "Lokholar the Ice Lord";

SS_MOVING = "Moving";

SS_IVUS_SUMMONED = "Wicked, wicked, mortals";
SS_LOKHOLAR_SUMMONED = "WHO DARES SUMMON LOKHOLA";

SS_CLASSNAMES = {};

-- SSWSG_CLASSNAMES[#] = { "localized name", "short hand name", "unlocalized name" };
-- localized should be changed to the localized version of the class name
-- short hand name doesn't have to be changed, but would be helpful if it was
-- unlocalized should never need to be changed

SS_CLASSNAMES[1] = { "Druid", "Dru", "DRUID" };
SS_CLASSNAMES[2] = { "Hunter", "Hun", "HUNTER" };
SS_CLASSNAMES[3] = { "Paladin", "Pal", "PALADIN" };
SS_CLASSNAMES[4] = { "Warrior", "War", "WARRIOR" };
SS_CLASSNAMES[5] = { "Shaman", "Sha", "SHAMAN" };
SS_CLASSNAMES[6] = { "Priest", "Pri", "PRIEST" };
SS_CLASSNAMES[7] = { "Rogue", "Rog", "ROGUE" };
SS_CLASSNAMES[8] = { "Warlock", "Warl", "WARLOCK" };
SS_CLASSNAMES[9] = { "Mage", "Mage", "MAGE" };
