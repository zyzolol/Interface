local SaySapped = CreateFrame("Frame")

SaySapped:SetScript("OnEvent",function()
	if (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 51724 or arg9 == 11297 or arg9 == 2070 or arg9 ==  6770) and arg7 == UnitName("player")) then
		SendChatMessage("Sapped", "SAY")
	elseif (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 18469 or arg9 == 15487 or arg9 == 34490 or arg9 == 41084 or arg9 == 19244 or arg9 == 19647 or arg9 == 30849) and arg7 == UnitName("player")) then
		SendChatMessage("Silenced", "SAY") -- silence mage priest hunter lock
		elseif (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 8643 or arg9 == 27615 or arg9 == 30621 or arg9 == 30832 or arg9 == 32864 or arg9 == 41389) and arg7 == UnitName("player")) then
		SendChatMessage("KS", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 33786 or arg9 == 32332 or arg9 == 43119) and arg7 == UnitName("player")) then
		SendChatMessage("Cyclone", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 5246 or arg9 == 20511 or arg9 == 5782 or arg9 == 6213 or arg9 == 6215 or arg9 == 31970 or arg9 == 8122 or arg9 == 8124 or arg9 == 10888 or arg9 == 10890 or arg9 == 27610) and arg7 == UnitName("player")) then
		SendChatMessage("FEAR", "SAY") -- warrior priest lock
		elseif (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 853 or arg9 == 5588 or arg9 == 5589 or arg9 == 10308 ) and arg7 == UnitName("player")) then
		SendChatMessage("HoJ", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and arg9 ==  20066 and arg7 == UnitName("player")) then
		SendChatMessage("Repentance", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 118 or arg9 == 12824 or arg9 == 15825 or arg9 == 12826 or arg9 == 28271 or arg9 == 28272 ) and arg7 == UnitName("player")) then
		SendChatMessage("Sheep", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and(arg9 == 339 or arg9 == 1062 or arg9 == 5195 or arg9 == 5196 or arg9 == 9852 or arg9 == 9853 or arg9 == 19970 or arg9 == 19971 or arg9 == 19972 or arg9 == 19973 or arg9 == 19974 or arg9 == 19975 or arg9 == 26989 or arg9 == 27010 or arg9 == 11922 or arg9 == 12747 or arg9 == 20654 or arg9 == 20699 or arg9 == 21331 or arg9 == 22127 or arg9 == 22415 or arg9 == 22800 or arg9 == 24648 or arg9 == 26071 or arg9 == 28858 or arg9 == 31287 or arg9 == 32173 or arg9 == 33844 or arg9 == 37823 or arg9 == 40363) and arg7 == UnitName("player")) then
		SendChatMessage("Roots", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and(arg9 == 19503 or arg9 == 23601 or arg9 == 36732) and arg7 == UnitName("player")) then
		SendChatMessage("Scatter Shot", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and arg9 == 2094 and arg7 == UnitName("player")) then
		SendChatMessage("Blind", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 3355 or arg9 == 14308 or arg9 == 14309) and arg7 == UnitName("player")) then
		SendChatMessage("Trap", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and arg9 == 27068 and arg7 == UnitName("player")) then
		SendChatMessage("Wyvern", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and arg9 == 38764 and arg7 == UnitName("player")) then
		SendChatMessage("Gouge", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 122 or arg9 == 865 or arg9 == 6131 or arg9 == 9915 or arg9 == 10230 or arg9 == 27088) and arg7 == UnitName("player")) then
		SendChatMessage("Frost Nova", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and (arg9 == 605 or arg9 == 10911 or arg9 == 10912) and arg7 == UnitName("player")) then
		SendChatMessage("Mind Control", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and arg9 == 6358 and arg7 == UnitName("player")) then
		SendChatMessage("Charmed", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and(arg9 == 5211 or arg9 == 6798 or arg9 == 8983) and arg7 == UnitName("player")) then
		SendChatMessage("Bash", "SAY")
		elseif (arg2 == "SPELL_AURA_APPLIED" and arg9 == 22570 and arg7 == UnitName("player")) then
		SendChatMessage("Maim", "SAY")
	end
end)

SaySapped:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
DEFAULT_CHAT_FRAME:AddMessage("SaySapped loaded")
