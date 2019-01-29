
------------
-- GERMAN
------------

if( GetLocale() == "deDE" ) then

-- General

SS_ALLIANCE = "Allianz";
SS_HORDE = "Horde";

-- Should be the same text that appears on the scoreboard
SS_HORDE_STATS = SS_HORDE .. " Stats";
SS_ALLIANCE_STATS = SS_ALLIANCE .. " Stats";

SS_MINUTE = "Minute";
SS_SECOND = "Sekunde";	

SS_WARSONGGULCH = "Kriegshymnenschlucht";
SS_ALTERACVALLEY = "Alteractal";
SS_ARATHIBASIN = "Arathibecken";
SS_EYEOFTHESTORM = "Auge des Sturms";

SS_CONTESTED = "Umk\195\164mpft";

SS_EASTERNKING = "\195\150stliche K\195\182nigreiche";

-- EPL messages
SS_EASTERNPLAGUELANDS = "Die \195\182stlichen Pestl\195\164nder";
SS_EPL_LOCALDEF = "LokaleVerteidigung - Die \195\182stlichen Pestl\195\164nder";

SS_EPL_TAKEN = "(.+) wurde von der";

-- Warsong Gulch
SS_WSG_PICKEDUP = "(.+) hat die Flagge der %s aufgenommen!";
SS_WSG_DROPPED = "(.+) hat die Flagge der %s fallen lassen!";
SS_WSG_CAPTURED = "(.+) hat die Flagge der %s errungen!";

-- AB messages
SS_AB_TAKEN = "hat ([^!]+) eingenommen!";
SS_AB_ASSAULTED = "hat ([^!]+) angegriffen!";
SS_AB_CLAIMS = "hat ([^!]+) besetzt!";

-- AV messages
SS_AV_TAKEN = "(.+) wurde von der";
SS_AV_DESTROYED = "(.+) wurde von der (.+) zerst\195\182rt";
SS_AV_CLAIMS = "hat ([^!]+) besetzt";

SS_DESTROYED = "zerst\195\182rt";
SS_CAPTURED = "erobert";

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
SSAV_SNOWFALL_GY = "den Schneewehenfriedhof";

-- This should be the exact casing/message when the graveyard is taken
SSAV_CORRECT_SF_GY = "Der Schneewehenfriedhof";

SS_DESTROY = "zerst\195\182ren";
SS_CAPTURE = "erobern";

SS_AV_UNDERATTACK = "(.+) wird angegriffen..?";

SS_HERALD = "Herold";

-- God info
SS_IVUS_FOREST_LORD = "Ivus der Waldf\195\188rst";
SS_LOKHOLAR_ICE_LORD = "Lokholar der Eislord";

SS_MOVING = "In Bewegung";

SS_IVUS_SUMMONED = "Wicked, wicked, mortals";
SS_LOKHOLAR_SUMMONED = "WHO DARES SUMMON LOKHOLA";

SS_CLASSNAMES = {};

-- SSWSG_CLASSNAMES[#] = { "localized name", "short hand name", "unlocalized name" };
-- localized should be changed to the localized version of the class name
-- short hand name doesn't have to be changed, but would be helpful if it was
-- unlocalized should never need to be changed

SS_CLASSNAMES[1] = { "Druide", "Dru", "DRUID" };
SS_CLASSNAMES[2] = { "J\195\164ger", "Hun", "HUNTER" };
SS_CLASSNAMES[3] = { "Paladin", "Pal", "PALADIN" };
SS_CLASSNAMES[4] = { "Krieger", "War", "WARRIOR" };
SS_CLASSNAMES[5] = { "Schamane", "Sha", "SHAMAN" };
SS_CLASSNAMES[6] = { "Priester", "Pri", "PRIEST" };
SS_CLASSNAMES[7] = { "Schurke", "Rog", "ROGUE" };
SS_CLASSNAMES[8] = { "Hexenmeister", "Warl", "WARLOCK" };
SS_CLASSNAMES[9] = { "Magier", "Mage", "MAGE" };

end