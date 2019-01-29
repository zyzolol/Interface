DM_Red = "|cffff1010"
DM_Green = "|cff00ff00"
DM_Blue = "|cff0000ff"
DM_White = "|cffffffff"
DM_Gray = "|cff888888"
DM_Yellow  = "|cffffff00"
DM_Cyan   = "|cff00ffff"
DM_Orange = "|cffff7000"
DM_Gold = "|cffffcc00"
DM_Mageta = "|cffe040ff"
DM_ItemBlue = "|cff2060ff"
DM_LightBlue = "|cff00e0ff"
DM_LightGreen = "|cff60ff60"
DM_LightRed = "|cffff5050"
DM_SubWhite = "|cffbbbbbb"

autoq = "enabled";

function AutoQuest_Onevent(event)
	if autoq == "enabled" then
		if (event == "QUEST_DETAIL") then
			AcceptQuest();
			CompleteQuest();
		elseif (event == "QUEST_COMPLETE") then
			CompleteQuest();
		elseif (event == "QUEST_FINISHED") then
			CompleteQuest();
		elseif (event == "QUEST_PROGRESS") then
			CompleteQuest();
		end
	end
end

function AutoQuest_Onload() 
	SLASH_AutoQuest1 = "/AutoQuest";
	SLASH_AutoQuest2 = "/aq";
	SlashCmdList["AutoQuest"] = AutoQuest_Command;

	DEFAULT_CHAT_FRAME:AddMessage(DM_Yellow .. "AutoQuest v1.0 by " .. DM_LightBlue .. "Noaide (Ragnaros EU)");
	
	this:RegisterEvent("QUEST_DETAIL");
	this:RegisterEvent("QUEST_COMPLETE");
	this:RegisterEvent("QUEST_PROGRESS");
	this:RegisterEvent("QUEST_FINISHED");
end

function AutoQuest_Command(cmd)
	if (cmd == "on") then
		DEFAULT_CHAT_FRAME:AddMessage(DM_LightBlue .. "{AutoQuest} AQ enabled.");
		autoq = "enabled"
	elseif (cmd == "off") then
		DEFAULT_CHAT_FRAME:AddMessage(DM_LightBlue .. "{AutoQuest} AQ disabled.");
		autoq = "disabled"
	elseif (cmd == "status") then
		DEFAULT_CHAT_FRAME:AddMessage(DM_LightBlue .. "{AutoQuest} AQ is currently " .. autoq .. ".");
	elseif (cmd == "about") then
		DEFAULT_CHAT_FRAME:AddMessage(DM_LightBlue .. "{AutoQuest} v1.0 by Noaide (Ragnaros EU).");
	end
end
