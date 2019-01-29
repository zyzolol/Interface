
function HeroStatus_OnClickCheckButton()
  if HS_Button_Enabled:GetChecked() then
    HS_Kills = GetPVPLifetimeStats(hk);
    HS_Button_Sap:Enable();
    HS_Button_Honor:Enable();
    HS_Button_KB:Enable();
    if HS_Button_KB:GetChecked() then
      HS_Button_Sounds:Enable();
    else
      HS_Button_Sounds:Disable();
    end
    HS_Button_AFK:Enable();
    if HS_Button_AFK:GetChecked() then
      HS_Button_AFK_Silent:Enable();
    else
      HS_Button_AFK_Silent:Disable();
    end
    HS_Button_Heal_Icon:Enable();
    --HS_Button_Que_Watcher:Enable();
  else
    HS_Button_Sap:Disable();
    HS_Button_Honor:Disable();
    HS_Button_KB:Disable();
    HS_Button_Sounds:Disable();
    HS_Button_AFK:Disable();
    HS_Button_AFK_Silent:Disable();
    HS_Button_Heal_Icon:Disable();
    --HS_Button_Que_Watcher:Disable();
  end
end

function HeroStatus_OnClickSave()
  HeroStatusVars.enabled = 0;
  HeroStatusVars.sap = 0;
  HeroStatusVars.cap_alert = 0;
  HeroStatusChars.honor_amount = HS_Honor_Amount:GetNumber();
  HeroStatusVars.killing_blow_alert = 0;
  HeroStatusVars.sounds = 0;
  HeroStatusVars.afk_check = 0;
  HeroStatusVars.afk_silent = 0;
  HeroStatusVars.heal_icon = 0;
  --HeroStatusVars.que_watcher = 0;

  if HS_Button_Enabled:GetChecked() then HeroStatusVars.enabled = 1; end
  if HS_Button_Sap:GetChecked() then HeroStatusVars.sap = 1; end
  if HS_Button_Honor:GetChecked() then HeroStatusVars.cap_alert = 1; end
  if HS_Button_KB:GetChecked() then HeroStatusVars.killing_blow_alert = 1; end
  if HS_Button_Sounds:GetChecked() then HeroStatusVars.sounds = 1; end
  if HS_Button_AFK:GetChecked() then HeroStatusVars.afk_check = 1; end
  if HS_Button_AFK_Silent:GetChecked() then HeroStatusVars.afk_silent = 1; end
  if HS_Button_Heal_Icon:GetChecked() then HeroStatusVars.heal_icon = 1; end
  --if HS_Button_Que_Watcher:GetChecked() then HeroStatusVars.que_watcher = 1; end

  HeroStatus_Frame:Hide();
end

function HeroStatus_OnEvent(self, event, arg1, ...)
  if (event == "CHAT_MSG_COMBAT_HONOR_GAIN") then
    HS_Report();
  end
  if (event == "ADDON_LOADED" and arg1 == "HeroStatus") then
    EventFrame:UnregisterEvent("ADDON_LOADED");
    HS_CheckSavedVars();
    HeroStatus_Frame:Hide();
    HeroStatus_Frame:RegisterForDrag("LeftButton");
    HS_Honor_Amount:SetNumeric("true");
    HS_Honor_Amount:SetAutoFocus("false");
    HS_Message("HeroStatus: Loaded");
    HS_Check_Date();
    HS_TextMessage("");
  end
  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    local player = UnitGUID("player");
    local eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, _, spellName = select(1, ...);
    local playerType = tonumber(dstGUID:sub(5,5), 16) % 8;
    if (eventType == "PARTY_KILL" and srcGUID == player and playerType == 0) then
      if (HeroStatusVars.killing_blow_alert == 1 and HeroStatusVars.enabled == 1) then
        HS_Message("Killing Blow on: " .. dstName);
        HS_TextMessage("Killing Blow");
        HS_KillingBlowSound();
      end
    end
	if (eventType == "SPELL_AURA_APPLIED" and dstGUID == player and spellName == "Sap") then
	  if (HeroStatusVars.sap == 1 and HeroStatusVars.enabled == 1) then
	    HS_Sapped();
	  end
	end
  end
end

function HS_BGMessage(msg)
  if(HS_CheckZone()) then
    if (string.match(msg, "1 minute") and HS_BGTimer == 0) then
	  HSStatusBar:SetMinMaxValues(0, 60);
	  HSStatusBar:SetValue(60);
	  HS_BG_Start();
	end
    if (string.match(msg, "30 seconds")) then
	  HSStatusBar:SetMinMaxValues(0, 60);
	  HSStatusBar:SetValue(30);
	  HS_BG_Start();
	end
    if (string.match(msg, "has begun")) then
	  HS_BG_Stop();
	end
  else
    HS_BGTimer = 0;
  end
end

function HS_BG_Start()
  HS_BGTimer = 1;
  HSStatusBar:Show();
  HSStatusText:Show();
end

function HS_BG_Stop()
  HS_BGTimer = 0;
  HSStatusBar:Hide();
  HSStatusText:Hide();
end

function HS_BGTimerText(message)
  HSStatusText.text:SetText(message);
end

function HS_Check_Date()
  if (date("%x") ~= HeroStatusChars.date) then
    HS_Message("Your last recorded HKs was: " .. HeroStatusChars.kills_today);
    HS_Message("HeroStatus has been reset due to date rollover.");
    HeroStatusChars.date = date("%x");
    HeroStatusChars.kills_today = 0;
  end
end

function HS_Check_Honor_Cap()
  -- Check for certain amount of honor (configured in settings) and alert player if they are at or above amount
  if (HeroStatusVars.cap_alert == 1 and HeroStatusVars.enabled == 1) then
    if (GetHonorCurrency() >= HeroStatusChars.honor_amount) then
      if (HS_HonorWarn == 0) then
        HS_TextMessage("HonorStatus: \nYou have " .. GetHonorCurrency() .. " honor. Go get some gear!");
        HS_Message("HonorStatus: You have " .. GetHonorCurrency() .. " honor. Go get some gear!");
        HS_HonorWarn = 1;
      end
    else
      HS_HonorWarn = 0;
    end
  end
end

function HS_CheckSavedVars()
  if HeroStatusVars == nil then HeroStatusVars = {}; end
  if HeroStatusChars == nil then HeroStatusChars = {}; end

  if (HeroStatusVars.minimapPos == nil) then HeroStatusVars.minimapPos = 45; end
  if (HeroStatusVars.enabled == nil) then HeroStatusVars.enabled = 1; end
  if (HeroStatusVars.kills_today == nil) then HeroStatusVars.kills_today = 0; end
  if (HeroStatusVars.honor == nil) then HeroStatusVars.honor = 0; end
  if (HeroStatusVars.frequency == nil) then HeroStatusVars.frequency = 1; end
  if (HeroStatusVars.cap_alert == nil) then HeroStatusVars.cap_alert = 1; end
  if (HeroStatusVars.killing_blow_alert == nil) then HeroStatusVars.killing_blow_alert = 1; end
  if (HeroStatusVars.sap == nil) then HeroStatusVars.sap = 1; end
  if (HeroStatusVars.sounds == nil) then HeroStatusVars.sounds = 1; end
  if (HeroStatusVars.afk_check == nil) then HeroStatusVars.afk_check = 1; end
  if (HeroStatusVars.afk_silent == nil) then HeroStatusVars.afk_silent = 1; end
  if (HeroStatusVars.heal_icon == nil) then HeroStatusVars.heal_icon = 1; end
  if (HeroStatusVars.que_watcher == nil) then HeroStatusVars.que_watcher = 1; end

  if (HeroStatusChars.enabled == nil) then HeroStatusChars.enabled = 1; end
  if (HeroStatusChars.kills_today == nil) then HeroStatusChars.kills_today = 0; end
  if (HeroStatusChars.date == nil) then HeroStatusChars.date = date("%x"); end
  if (HeroStatusChars.honor == nil) then HeroStatusChars.honor = 0; end
  if (HeroStatusChars.frequency == nil) then HeroStatusChars.frequency = 1; end
  if (HeroStatusChars.cap_alert == nil) then HeroStatusChars.cap_alert = 0; end
  if (HeroStatusChars.honor_amount == nil) then HeroStatusChars.honor_amount = 0; end
end

function HS_CheckQue()
  if (HeroStatusChars.enabled == 1 and HeroStatusVars.que_watcher == 1) then
    if (GetBattlefieldTimeWaited(1) > 0) then
      if (GetBattlefieldTimeWaited(1) > GetBattlefieldEstimatedWaitTime(1) + 65000) then
        if (HS_BadQue1 == 0) then
          HS_TextMessage(select(2, GetBattlefieldStatus(1)) .. " que over limit!");
          HS_Message("HeroStatus: " .. select(2, GetBattlefieldStatus(1)) .. " que over limit!");
        end
        HS_BadQue1 = 1;
      else
        HS_BadQue1 = 0;
      end
      if (GetBattlefieldTimeWaited(2) > GetBattlefieldEstimatedWaitTime(2) + 65000) then
        if (HS_BadQue2 == 0) then
          HS_TextMessage(select(2, GetBattlefieldStatus(2)) .. " que over limit!");
          HS_Message("HeroStatus: " .. select(2, GetBattlefieldStatus(2)) .. " que over limit!");
        end
        HS_BadQue2 = 1;
      else
        HS_BadQue2 = 0;
      end
	  if (GetBattlefieldTimeWaited(3) > GetBattlefieldEstimatedWaitTime(3) + 65000) then
        if (HS_BadQue3 == 0) then
          HS_TextMessage(select(2, GetBattlefieldStatus(3)) .. " que over limit!");
          HS_Message("HeroStatus: " .. select(2, GetBattlefieldStatus(3)) .. " que over limit!");
        end
        HS_BadQue3 = 1;
      else
        HS_BadQue3 = 0;
      end
    end
  end
end

function HS_CheckZone()
  local zone = GetRealZoneText();
  if (zone == "Alterac Valley") then return true; end
  if (zone == "Arathi Basin") then return true; end
  if (zone == "Eye of the Storm") then return true; end
  if (zone == "Warsong Gulch") then return true; end
  return false;
end

function HS_GetBuffs()
  local buffs, i = { }, 1;
  local buff = UnitBuff("player", i);
  while buff do
    buffs[#buffs + 1] = buff;
    i = i + 1;
    buff = UnitBuff("player", i);
  end;
  if #buffs < 1 then
    buffs = "You have no buffs";
  else
    buffs[1] = "You're buffed with: "..buffs[1];
    buffs = table.concat(buffs, ", ");
  end;
  return buffs;
end

function HS_GetPlayerInfo(unit, dmg, heal)
  x, y = GetPlayerMapPosition(unit);

  if HS_CheckZone() then
    if (HS_PlayerInfo[unit] == nil) then
      HS_PlayerInfo[unit] = {
        x = x,
        y = y,
        time = GetTime(),
        report = 0,
        afkcount = 0
      }
    else
      if (HS_PlayerInfo[unit].x == x and HS_PlayerInfo[unit].y == y) then
		if (tonumber(dmg) < 3500 and tonumber(heal) < 3500 and HS_PlayerInfo[unit].report == 0) then
          HS_PlayerInfo[unit].afkcount = HS_PlayerInfo[unit].afkcount + 1;
          if (HS_PlayerInfo[unit].afkcount == 4) then
            HS_PlayerInfo[unit].afkcount = 0;
            x = format("%.2f", x);
            y = format("%.2f", y);
            HS_PlayerInfo[unit].report = 1;
            HS_PlayerInfo[unit].inGuild = 0;
            for i = 1, GetNumGuildMembers(true) do
              name, _, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(i);
              if (name == unit) then
                HS_PlayerInfo[unit].inGuild = 1;
                print("HeroStatus: Not reporting guildie '" .. unit .. "'");
              end
            end
            if (HS_PlayerInfo[unit].inGuild == 0) then
              ReportPlayerIsPVPAFK(unit);
              reportMsg = "HeroStatus: Reported " .. unit .. " AFK - Position: " .. x .. ", " .. y .. " Damage: " .. dmg .. " Healing: " .. heal;
              if (HeroStatusVars.afk_silent == 1) then
                HS_Message(reportMsg);
              else
                SendChatMessage(reportMsg, "BATTLEGROUND", GetDefaultLanguage("player"));
              end
            end
          end
        end
      else
        HS_PlayerInfo[unit].x = x;
        HS_PlayerInfo[unit].y = y;
        HS_PlayerInfo[unit].time = GetTime();
        HS_PlayerInfo[unit].report = 0;
        HS_PlayerInfo[unit].afkcount = 0;
      end
    end
  else
    wipe(HS_PlayerInfo);
    HS_Version_Acknowledged = 0;
  end
end

function HS_GetScoreInfo()
  if HS_CheckZone() then
    local numScores = GetNumBattlefieldScores();
    local playerFaction = UnitFactionGroup("player");
    if (UnitLevel("player") == 70) then
      for i=1, numScores do
        name, killingBlows, _, _, _, faction, _, _, _, _, damageDone, healingDone = GetBattlefieldScore(i);
        if faction then
          if (faction == 0 and playerFaction == "Horde" and name ~= UnitName("player")) then
			HS_GetPlayerInfo(name, damageDone, healingDone);
          end
          if (faction == 1 and playerFaction == "Alliance" and name ~= UnitName("player")) then
            HS_GetPlayerInfo(name, damageDone, healingDone);
          end
        end
      end
    end
  else
    wipe(HS_PlayerInfo);
  end
end

function HS_HKReport()
  HS_Check_Date();
  HS_Message("You have " .. HeroStatusChars.kills_today .. " honor kills today!");
end

function HS_Increase_Player_Kills()
  HeroStatusChars.kills_today = HeroStatusChars.kills_today + 1;
  HeroStatus_FrameToday:SetText("You have " .. HeroStatusChars.kills_today .. " honor kills today!");
  HeroStatus_OnClickCheckButton();
end

function HS_KillingBlowSound()
  if (HeroStatusVars.enabled == 1) then
    if (HeroStatusVars.sounds == 1) then
      local rng = random(1, 39);
      local list = {
        [1] = "Sound\\Creature\\Doomwalker\\GRULLAIR_Doom_Slay02.wav",
        [2] = "Sound\\Creature\\Doomwalker\\GRULLAIR_Doom_Slay03.wav",
        [3] = "Sound\\Creature\\BlackheartTheInciter\\Auch_Blckhrt02_Slay01.wav",
        [4] = "Sound\\Creature\\BlackheartTheInciter\\Auch_Blckhrt02_Slay02.wav",
        [5] = "Sound\\Creature\\GrandmasterVorpil\\Auch_Vorpil_Slay02.wav",
        [6] = "Sound\\Creature\\HydromancerThespia\\COIL_Thesp_Slay01.wav",
        [7] = "Sound\\Creature\\KelidanTheBreaker\\HELL_Keli_Slay01.wav",
        [8] = "Sound\\Creature\\KelidanTheBreaker\\HELL_Keli_Slay02.wav",
        [9] = "Sound\\Creature\\MekgineerSteamrigger\\COIL_Meksteam_Slay01.wav",
        [10] = "Sound\\Creature\\MekgineerSteamrigger\\COIL_Meksteam_Slay02.wav",
        [11] = "Sound\\Creature\\MennuTheTraitorous\\COIL_Menn_Slay01.wav",
        [12] = "Sound\\Creature\\Nethekurse\\HELL_Neth_Slay01.wav",
        [13] = "Sound\\Creature\\Nethekurse\\HELL_Neth_Slay02.wav",
        [14] = "Sound\\Creature\\OmorTheUnscarred\\HELL_Omor_Slay01.wav",
        [15] = "Sound\\Creature\\OmorTheUnscarred\\HELL_Omor_Slay02.wav",
        [16] = "Sound\\Creature\\VazrudenTheHerald\\HELL_Vaz_Slay01.wav",
        [17] = "Sound\\Creature\\VazrudenTheHerald\\HELL_Vaz_Slay02.wav",
        [18] = "Sound\\Creature\\WarlordKalithresh\\COIL_Kali_Slay02.wav",
        [19] = "Sound\\Creature\\WatchkeeperGargolmar\\HELL_Garg_Slay01.wav",
        [20] = "Sound\\Creature\\WatchkeeperGargolmar\\HELL_Garg_Slay02.wav",
        [21] = "Sound\\Creature\\CommanderSarannis\\TEMPEST_Saran_Slay02.wav",
        [22] = "Sound\\Creature\\DaliahTheDoomsayer\\TEMPEST_Dalliah_Slay02.wav",
        [23] = "Sound\\Creature\\EssenceOfGrief\\BLCKTMPLE_EssnceGrf_Slay03.wav",
        [24] = "Sound\\Creature\\GruulTheDragonkiller\\GRULLAIR_Gruul_Slay02.wav",
        [25] = "Sound\\Creature\\GruulTheDragonkiller\\GRULLAIR_Gruul_Slay03.wav",
        [26] = "Sound\\Creature\\HarbingerSkyriss\\TEMPEST_Harbinger_Slay01.wav",
        [27] = "Sound\\Creature\\HighKingMaulgar\\GRULLAIR_Maul_Slay01.wav",
        [28] = "Sound\\Creature\\Illidan\\BLACK_Illidan_04.wav",
        [29] = "Sound\\Creature\\LadyVashj\\COIL_LadyVashj_Slay02.wav",
        [30] = "Sound\\Creature\\Leotheras_NightElf\\COIL_LeoNghtElf_Slay03.wav",
        [31] = "Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Slay01.wav",
        [32] = "Sound\\Creature\\PathaleonTheCalculator\\TEMPEST_Pathal_Slay01.wav",
        [33] = "Sound\\Creature\\PathaleonTheCalculator\\TEMPEST_Pathal_Slay02.wav",
        [34] = "Sound\\Creature\\ThorngrinTheTender\\TEMPEST_Thorngrin_Slay02.wav",
        [35] = "Sound\\Creature\\VoidReaver\\TEMPEST_VoidRvr_Slay01.wav",
        [36] = "Sound\\Creature\\VoidReaver\\TEMPEST_VoidRvr_Slay03.wav",
        [37] = "Sound\\Creature\\ThrallCoT\\CAV_Thrall_Slay01.wav",
        [38] = "Sound\\Creature\\ThrallCoT\\CAV_Thrall_Slay02.wav",
        [39] = "Sound\\Creature\\KazRogal\\CAV_Kaz_Slay02.wav"
      }
      PlaySoundFile(list[rng]);
    end
  end
end

function HS_Message(message)
  DEFAULT_CHAT_FRAME:AddMessage("|cffffff00" .. message);
end

function HS_OnUpdate(self, elapsed)
  if (HS_BGTimer == 1) then
    HS_BGTimerTotal = HS_BGTimerTotal + elapsed;
    if HS_BGTimerTotal >= 1 then
	  HSStatusBar:SetValue(HSStatusBar:GetValue() - 1);
	  HS_BGTimerTotal = 0;
	  HS_BGTimerText(HSStatusBar:GetValue());
	  if (HSStatusBar:GetValue() == 0) then HS_BG_Stop(); end
	end
  end
end

function HS_Report()
  HS_Kills = GetPVPLifetimeStats(hk);
  HS_Check_Honor_Cap();
  if (HS_Kills > HS_LastKillCount) then
    HS_Check_Date();
    HS_Increase_Player_Kills();
    HS_LastKillCount = HS_Kills;
  end
end

function HS_Sapped()
  SendChatMessage("Sapped!!!", "SAY");
  SendChatMessage("Sapped!!!", "PARTY");
end

function HS_Show()
  if(HeroStatus_Frame:IsVisible()) then
    HeroStatus_Frame:Hide();
  else
    HS_Button_Enabled:SetChecked(HeroStatusVars.enabled);
    HS_Button_Sap:SetChecked(HeroStatusVars.sap);
    HS_Button_Honor:SetChecked(HeroStatusVars.cap_alert);
    HS_Honor_Amount:SetNumber(HeroStatusChars.honor_amount);
    HS_Button_KB:SetChecked(HeroStatusVars.killing_blow_alert);
    HS_Button_Sounds:SetChecked(HeroStatusVars.sounds);
    HS_Button_AFK:SetChecked(HeroStatusVars.afk_check);
    HS_Button_AFK_Silent:SetChecked(HeroStatusVars.afk_silent);
    HS_Button_Heal_Icon:SetChecked(HeroStatusVars.heal_icon);
    --HS_Button_Que_Watcher:SetChecked(HeroStatusVars.que_watcher);
    HeroStatus_OnClickCheckButton();
    HeroStatus_FrameVersion:SetText("v" .. HeroStatus_Version);
    HeroStatus_FrameToday:SetText("You have " .. HeroStatusChars.kills_today .. " honor kills today!");
    HeroStatus_Frame:Show();
  end
end

function HS_SlashCmd(arg)
  arg = arg:lower()
  msgPrint = 0;
  if (arg == "" or arg == nil) then
    HS_Message("------------------------------------------------");
    HS_Message("Following commands for /hs:");
    HS_Message("off - Turns off HeroStatus");
    HS_Message("on - Turns on HeroStatus");
    HS_Message("show - Displays config window");
    HS_Message("version - Displays current HeroStatus Version");
    HS_Message("------------------------------------------------");
    msgPrint = 1;
  end
  if (arg == "report") then
    HS_HKReport();
    msgPrint = 1;                                       
  end
  if (arg == "off") then
    HeroStatusVars.enabled = 0;
    HS_Message("HeroStatus: off");
    HeroStatus_OnClickCheckButton();
    msgPrint = 1;
  end
  if (arg == "on") then
    HeroStatusVars.enabled = 1;
    HS_Message("HeroStatus: on");
    HeroStatus_OnClickCheckButton();
    msgPrint = 1;
  end
  if (arg == "show") then
    HS_Show();
    msgPrint = 1;
  end
  if (arg == "version") then
    HS_Message("HeroStatus: Version " .. HeroStatus_Version);
    msgPrint = 1;
  end
  if (msgPrint == 0) then
    HS_Message("Invalid argument for /hs");
  end
end

function HS_TextFrame_OnUpdate()
  if (HS_TextFrameTime < GetTime() - 3) then
    local alpha = TextFrame:GetAlpha();
    if (alpha ~= 0) then TextFrame:SetAlpha(alpha - .05); end
    if (aplha == 0) then TextFrame:Hide(); end
  end
  -- AFK Reporter Call (every 15 seconds)
  if (HeroStatusVars.enabled == 1 and HS_CheckZone()) then
    if (not string.match(HS_GetBuffs(), "Preparation") and HS_PlayerInfoReportTime < GetTime() - 15 and HeroStatusVars.afk_check == 1) then
	  HS_GetScoreInfo();
      HS_PlayerInfoReportTime = GetTime();
	end
  else
    HS_PlayerInfo = {};
  end
  -- BG Que watcher
  HS_CheckQue();
end

function HS_TextMessage(message)
  TextFrame.text:SetText(message);
  TextFrame:SetAlpha(1);
  TextFrame:Show();
  HS_TextFrameTime = GetTime();
end

function HS_UIMessage(message)
  UIErrorsFrame:AddMessage(message, 0, 1, 0, 1, 10);
end
