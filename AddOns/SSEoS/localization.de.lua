
------------
-- GERMAN
------------

if( GetLocale() == "deDE" ) then

SSEOSVersion = "1.0.0";

SSES_INFO = "Match Info";

SSES_WORLDUI = "Bases%: ([0-9]+)  Victory Points%: ([0-9]+)/([0-9]+)"
SSES_FINALSCORE = "Final Score";
SSES_PERCAPTURE = "Points per flag";
SSES_TIMELEFT = "Time Left";
SSES_TOWERS_FINAL = "(A:*extra2*/H:*extra3*)";
SSES_TOWERSTOWIN = "Towers to win";

SSES_INVALID_CHANTYPE = "Invalid channel type %s entered.";

SSES_CHAT_MATCH_INFO = "[SS] Time Left: %s / Towers to win: %s (A:%s/H:%s)";
SSES_CHAT_MATCH_INFO2 = "[SS] Final Score (Alliance): %s / Final Score (Horde): %s";

-- UI
SSES_UI_ENABLE = "Enable mod";
SSES_UI_FINALSCORE = "Show final score for both factions";
SSES_UI_TIMELEFT = "Show time left in a match";
SSES_UI_FINALTOWER = "Show final bases to win score";
SSES_UI_TOWERS = "Show towers to win";
SSES_UI_PERCAPTURE = "Show points per a flag capture";

-- Command line
SSES_ON = "ON";
SSES_OFF = "OFF";

SSES_CMD_ENABLED = "SSEoS is %s";
SSES_CMD_TIMELEFT = "Time left in Eye of the Storm is %s";
SSES_CMD_FINALSCORE = "Final score is %s";
SSES_CMD_TOWERS = "Towers to win is %s";
SSES_CMD_TOWERFINAL = "Towers to win final score is %s";
SSES_CMD_PERCAPTURE = "Points per flag capture is %s";

SSES_HELP = {};
SSES_HELP[1] = "/sses <on/off> - Change the status of the mod";
SSES_HELP[2] = "/sses timeleft <on/off> - Display time left in an Eye of the Storm match";
SSES_HELP[3] = "/sses finalscore <on/off> - Display the final score";
SSES_HELP[4] = "/sses tower <on/off> - Display towers to win";
SSES_HELP[5] = "/sses ftower <on/off> - Display final towers to win score";
SSES_HELP[6] = "/sses percap <on/off> - Displays how many points you'll gain per a flag capture";
SSES_HELP[7] = "/sses printmatch <battleground/say/guild/party/raid> - Prints the battleground match info to chat";
SSES_HELP[8] = "/sses status - Display the status of the mod";

end