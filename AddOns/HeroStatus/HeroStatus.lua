-- Handles my onevent events
EventFrame = CreateFrame("Frame");
EventFrame:Hide();
EventFrame:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
EventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
EventFrame:RegisterEvent("ADDON_LOADED");
EventFrame:RegisterEvent("CHAT_MSG_ADDON");
EventFrame:SetScript("OnEvent", HeroStatus_OnEvent);

-- Handles my onupdate events
UpdateFrame = CreateFrame("Frame");
UpdateFrame:SetScript("OnUpdate", HS_OnUpdate);

-- Handles text that needs to be output to the top center of the screen and afk reporting
TextFrame = CreateFrame("Frame");
TextFrame:ClearAllPoints();
TextFrame:SetHeight(300);
TextFrame:SetWidth(300);
TextFrame:SetScript("OnUpdate", HS_TextFrame_OnUpdate);
TextFrame:Hide();
TextFrame.text = TextFrame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont");
TextFrame.text:SetAllPoints();
TextFrame:SetPoint("CENTER", 0, 200);

-- Handles parsing battleground starting messages
ChatFrame_AddMessageEventFilter("CHAT_MSG_BG_SYSTEM_NEUTRAL", HS_BGMessage)

-- Handles battleground status bar count down
HSStatusBar = CreateFrame("StatusBar", nil, UIParent);
HSStatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
HSStatusBar:Hide();
HSStatusBar:SetMinMaxValues(0, 100);
HSStatusBar:SetValue(100);
HSStatusBar:SetWidth(200);
HSStatusBar:SetHeight(10);
HSStatusBar:SetPoint("CENTER",UIParent,"CENTER");
HSStatusBar:SetStatusBarColor(0,1,0);
HSStatusBar:SetPoint("CENTER", 0, 300);

-- Handles battleground status bar text
HSStatusText = CreateFrame("Frame");
HSStatusText:ClearAllPoints();
HSStatusText:SetHeight(300);
HSStatusText:SetWidth(300);
HSStatusText:Hide();
HSStatusText.text = HSStatusText:CreateFontString(nil, "BACKGROUND", "GameFontNormal");
HSStatusText.text:SetAllPoints();
HSStatusText:SetPoint("CENTER", 0, 250);


-- Global variables
HeroStatus_Version = "2.0.5";
HS_BadQue1 = 0;
HS_BadQue2 = 0;
HS_BadQue3 = 0;
HS_BGTimer = 0;
HS_BGTimerTotal = 0;
HS_Buffs = "";
HS_HonorWarn = 0;
HS_Kills = GetPVPLifetimeStats(hk);
HS_LastKillCount = GetPVPLifetimeStats(hk);
HS_PlayerInfo = {};
HS_PlayerInfoReportTime = GetTime();
HS_TextFrameTime = 0;

-- Slash command config
SLASH_HEROSTATUS1 = "/hs";
SLASH_HEROSTATUS2 = "/herostatus";
SlashCmdList["HEROSTATUS"] = HS_SlashCmd


-- PVP Healer Addition

local heallist = {};

-- Check if name on nameplate is in heallist, this is "updated" for wow 2.4.3
local function UpdatePlate(frame)
  unitName = select(5, frame:GetRegions()):GetText();
  if HeroStatusVars.heal_icon == 1 then
    if heallist[unitName] then
      frame.HSHeal:Show();
    else
      frame.HSHeal:Hide();
    end
  else
    frame.HSHeal:Hide();
  end
end

local function IsValidFrame(frame)
  if frame.done then return false; end
  frameName = frame:GetName();
  if frameName and frameName:sub(1,9) ~= "NamePlate" then return false; end
  if frame:GetID() ~= 0 then return false; end
  if frame:GetObjectType() ~= "Frame" then return false; end
  if frame:GetNumChildren() ~= 2 then return false; end
  if frame:GetNumRegions() ~= 8 then return false; end

  overlayRegion = select(2, frame:GetRegions());
  return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == "Interface\\Tooltips\\Nameplate-Border";
end

-- Add Icon over name plate, this is "updated" for wow 2.4.3
local function CreatePlate(frame)
  frame.nameplate = true;
  frame.HSHeal = frame:CreateTexture();
  frame.HSHeal:SetHeight(35);
  frame.HSHeal:SetWidth(35);
  frame.HSHeal:SetPoint("BOTTOM", frame, "TOP", 0, 10);
  frame.HSHeal:SetTexture();
  frame.HSHeal:SetTexture("Interface\\ICONS\\Spell_ChargePositive");
  --frame.HSHeal:SetTexCoord(GetTexCoordsForRole("HEALER"));
  frame.done = true;
  UpdatePlate(frame);
  frame:SetScript("OnShow", UpdatePlate);
end

local numKids = 0;
local lastUpdate = 0;

local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function(self, elapsed)
  if (HeroStatusVars.heal_icon == 1 and HeroStatusVars.enabled == 1) then
    lastUpdate = lastUpdate + elapsed;
    if lastUpdate > 5 then
      lastUpdate = 0;
      local newNumKids = WorldFrame:GetNumChildren();
      if newNumKids ~= numKids then
        for i = numKids + 1, newNumKids do
          local frame = select(i, WorldFrame:GetChildren());
          if IsValidFrame(frame) then
            CreatePlate(frame);
          end
        end
        numKids = newNumKids;
      end
    end
  end
end)

local lastcheck = 0;
local t = CreateFrame("Frame");

-- Check for healers from info in bg scoreboard, is healer if healing is 2x damage, this is "updated" for wow 2.4.3
local function CheckHealers(self, elapsed)
  lastcheck = lastcheck + elapsed;
  if lastcheck > 30 then
    lastcheck = 0;
    heallist = {};
    playerFaction = UnitFactionGroup("Player");
    if playerFaction == "Horde" then playerFaction = 0; end
    if playerFaction == "Alliance" then playerFaction = 1; end
    for i = 1, GetNumBattlefieldScores() do
      local name, _, _, _, _, faction, _, _, class, classToken, damageDone, healingDone, _, _ = GetBattlefieldScore(i);
      if (class ~= "Rogue" and class ~= "Warrior" and class ~= "Warlock" and class ~= "Hunter" and class ~= "Mage") then
        if (healingDone > damageDone*2 and faction ~= playerFaction) then
          name = name:match("(.+)%-.+") or name;
          heallist[name] = true;
        end
      end
    end
  end
end

local function checkloc(self, event)
  if (event == "PLAYER_ENTERING_WORLD") or (event == "PLAYER_ENTERING_BATTLEGROUND") then
    local isin, instype = IsInInstance();
    if isin and instype == "pvp" then
      t:SetScript("OnUpdate", CheckHealers);
    else
      heallist = {};
      t:SetScript("OnUpdate", nil);
    end
  end
end
t:RegisterEvent("PLAYER_ENTERING_WORLD");
t:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
t:SetScript("OnEvent", checkloc);