-------------------------------------------------------------------------------
-- Title: Mik's Scrolling Battle Text Main
-- Author: Mik
-------------------------------------------------------------------------------

-- Create module and set its name.
local module = {};
local moduleName = "Main";
MikSBT[moduleName] = module;


-------------------------------------------------------------------------------
-- Constants.
-------------------------------------------------------------------------------

-- How long to wait before showing events so that merges may happen.
local MERGE_DELAY_TIME = 0.3;

-- How long to wait between throttle window checking.
local THROTTLE_UPDATE_TIME = 0.5;

-- Amount of time to hold recent monster emotes in cache.
local EMOTE_HOLD_TIME = 1;

-- Damage types.
local DAMAGETYPE_PHYSICAL = 0x1;
local DAMAGETYPE_HOLY = 0x2;
local DAMAGETYPE_FIRE = 0x4;
local DAMAGETYPE_NATURE = 0x8;
local DAMAGETYPE_FROST = 0x10;
local DAMAGETYPE_SHADOW = 0x20;
local DAMAGETYPE_ARCANE = 0x40;

-- Spell names.
local SPELL_INNERVATE	= GetSpellInfo(29166);
local SPELL_SPIRIT_TAP	= GetSpellInfo(15270);

-- Money strings.
local GOLD = string.gsub(GOLD_AMOUNT, "%%d ", "");
local SILVER = string.gsub(SILVER_AMOUNT, "%%d ", "");
local COPPER = string.gsub(COPPER_AMOUNT, "%%d ", "");


-------------------------------------------------------------------------------
-- Private variables.
-------------------------------------------------------------------------------

-- Dynamically created frames for receiving events.
local eventFrame;
local throttleFrame;

-- Pool of dynamically created combat events that are reused.
local combatEventCache = {};

-- Lookup tables.
local eventHandlers = {};
local damageTypeMap = {};
local damageColorProfileEntries = {};
local powerTypes = {};

-- Throttled ability info.
local throttledAbilities = {};

-- Holds unmerged and merged combat events.
local unmergedEvents = {};
local mergedEvents = {};

-- Used for timing between updates.
local lastMergeUpdate = 0;
local lastThrottleUpdate = 0;

-- Spam control info.
local isEnglish;
local lastPowerAmount = 65535;
local finisherShown;
local emoteCleanupTime = 0;
local recentEmotes = {};

-- Holds the player's class.
local playerClass;

-- Regen ability info.
local regenAbilities = {};
local activeRegenAbility;
local currentBuffs = MikSBT.Parser.currentAuras.buffs;



-------------------------------------------------------------------------------
-- Imports.
-------------------------------------------------------------------------------

-- Local references to certain MSBT modules for faster access.
local MSBTAnimations = MikSBT.Animations;
local MSBTParser = MikSBT.Parser;
local MSBTTriggers = MikSBT.Triggers;
local MSBTProfiles = MikSBT.Profiles;
local L = MikSBT.translations;

-- Local references to certain functions and variables for faster access.
local table_remove = table.remove;
local math_ceil = math.ceil;
local string_find = string.find;
local string_gsub = string.gsub;
local string_format = string.format;
local bit_bor = bit.bor;
local GetTime = GetTime;
local EraseTable = MikSBT.EraseTable;
local Print = MikSBT.Print;
local DisplayEvent = MSBTAnimations.DisplayEvent;
local IsScrollAreaActive = MSBTAnimations.IsScrollAreaActive;
local TestFlagsAll = MSBTParser.TestFlagsAll;

local triggerSuppressions = MSBTTriggers.triggerSuppressions;


-------------------------------------------------------------------------------
-- Utility functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Sets up a button to access MSBT's options from the Blizzard interface
-- options AddOns tab.
-- ****************************************************************************
local function SetupBlizzardOptions()
 -- Create a container frame for the Blizzard options area.
 local frame = CreateFrame("Frame");
 frame.name = "MikScrollingBattleText";
 
 -- Create an option button in the center of the frame to launch MSBT's options.
 local button = CreateFrame("Button", nil, frame, "OptionsButtonTemplate");
 button:SetPoint("CENTER");
 button:SetText(MikSBT.COMMAND);
 button:SetScript("OnClick",
  function (this)
   InterfaceOptionsFrameCancel_OnClick();
   HideUIPanel(GameMenuFrame);
   if (not IsAddOnLoaded("MSBTOptions")) then UIParentLoadAddOn("MSBTOptions"); end
   if (IsAddOnLoaded("MSBTOptions")) then MSBTOptions.Main.ShowMainFrame(); end
  end
 );

 -- Add the frame as a new category to Blizzard's interface options.
 InterfaceOptions_AddCategory(frame);
end


-- ****************************************************************************
-- Returns an abbreviated form of the passed skill name.
-- ****************************************************************************
local function AbbreviateSkillName(skillName)
  if (string_find(skillName, "[%s%-]")) then
   skillName = string_gsub(skillName, "(%a)[%l%p]*[%s%-]*", "%1");
  end

  return skillName;
end


-- ****************************************************************************
-- Returns a formatted partial effects trailer using the passed parameters.
-- ****************************************************************************
local function FormatPartialEffects(absorbAmount, blockAmount, resistAmount, isGlancing, isCrushing)
 -- Get a local reference to the current profile.
 local currentProfile = MSBTProfiles.currentProfile;

 local effectSettings, amount;
 local partialEffectText = "";

 -- Partial Absorb
 if (absorbAmount) then
  effectSettings = currentProfile.absorb;
  amount = absorbAmount;

 -- Partial Block
 elseif (blockAmount) then
  effectSettings = currentProfile.block;
  amount = blockAmount;

 -- Partial Resist
 elseif (resistAmount) then
  effectSettings = currentProfile.resist;
  amount = resistAmount;
 end

 -- Set the partial effect text if there are settings for it, it's enabled, and it's valid.
 local trailer = effectSettings and effectSettings.trailer;
 if (trailer and not effectSettings.disabled) then
  -- Substitute the amount into the trailer.
  trailer = string_gsub(trailer, "%%d", amount);
  
  -- Color the text if coloring isn't disabled.
  if (not currentProfile.partialColoringDisabled) then
   partialEffectText = string_format("|cFF%02x%02x%02x%s|r", math_ceil(effectSettings.colorR * 255), math_ceil(effectSettings.colorG * 255), math_ceil(effectSettings.colorB * 255), trailer);
  else
   partialEffectText = trailer;
  end
 end

 
 -- Clear the effect settings and trailer.
 effectSettings = nil;
 trailer = nil;
 
 -- Glancing hit
 if (isGlancing) then
  effectSettings = currentProfile.glancing;

 -- Crushing blow
 elseif (isCrushing) then
  effectSettings = currentProfile.crushing;
 end

 -- Append the crushing/glancing text if there are settings for it, it's enabled, and it's valid.
 trailer = effectSettings and effectSettings.trailer;
 if (trailer and not effectSettings.disabled) then
  -- Color the text if coloring isn't disabled.
  if (not currentProfile.partialColoringDisabled) then
   partialEffectText = partialEffectText .. string_format("|cFF%02x%02x%02x%s|r", math_ceil(effectSettings.colorR * 255), math_ceil(effectSettings.colorG * 255), math_ceil(effectSettings.colorB * 255), trailer);
  else
   partialEffectText = partialEffectText .. trailer;
  end
 end

 return partialEffectText; 
end


-- ****************************************************************************
-- Formats an event with the parameters.
-- ****************************************************************************
local function FormatEvent(message, amount, damageType, overhealAmount, powerType, name, effectName, partialEffects, mergeTrailer, hasTexture, ignorePhysical, filterCodes)
 -- Get a local reference to the current profile.
 local currentProfile = MSBTProfiles.currentProfile;
 local checkParens;
 
 -- Substitute amount.
 if (amount and string_find(message, "%%a")) then
  -- Get the hex color for the damage type if there is one and coloring is enabled.
  local damageColorCode;
  if (damageType and not currentProfile.damageColoringDisabled) then
   -- Set the damage color code if the color data is present for the damage type.
   local damageColor = currentProfile[damageColorProfileEntries[damageType]];
   if (damageColor and not damageColor.disabled) then
    damageColorCode = string_format("|cFF%02x%02x%02x", math_ceil(damageColor.colorR * 255), math_ceil(damageColor.colorG * 255), math_ceil(damageColor.colorB * 255));
   end

   -- Ignore physical damage coloring on outgoing events.
   if (ignorePhysical and damageType == DAMAGETYPE_PHYSICAL and playerClass ~= "HUNTER") then damageColorCode = nil; end
  end -- Damage type and damage coloring is enabled.

  -- Check if there is overheal information and displaying it is enabled.
  if (overhealAmount and not currentProfile.overheal.disabled) then
   -- Deduct the overheal amount from the total amount healed.
   amount = amount - overhealAmount;
   
   -- Get the overheal amount and color it with the correct color if coloring is enabled.
   local overhealColorCode;
   if (not currentProfile.partialColoringDisabled) then
    local overhealColor = currentProfile.overheal;
    overhealColorCode = string_format("|cFF%02x%02x%02x", math_ceil(overhealColor.colorR * 255), math_ceil(overhealColor.colorG * 255), math_ceil(overhealColor.colorB * 255)); 
   end

   -- Color the overheal amount if there is a color code.
   if (overhealColorCode) then
    overhealAmount = overhealColorCode .. overhealAmount .. "|r";
   end
   
   -- Append the overheal amount to the actual amount healed.
   amount = amount .. string_gsub(currentProfile.overheal.trailer, "%%d", overhealAmount);
  end -- Overheal amount and overhealing display enabled.

  -- Color the amount according to the damage type, if any.
  if (damageColorCode) then amount = damageColorCode .. amount .. "|r"; end

  -- Substitute all %a event codes with the amount.
  message = string_gsub(message, "%%a", amount);
 end -- Substitute amount.


 -- Substitute power type.
 if (powerType and string_find(message, "%%p")) then message = string_gsub(message, "%%p", powerTypes[powerType] or UNKNOWN); end
 

 -- Substitute names.
 if (name and string_find(message, "%%n")) then
  if (filterCodes and currentProfile.hideNames) then
   message = string_gsub(message, "%s?%-?%s?%%n", "");
   checkParens = true;
  else
   message = string_gsub(message, "%%n", name);
  end
 end


 -- Substitute effect names. 
 if (effectName and string_find(message, "%%e")) then message = string_gsub(message, "%%e", effectName); end


 -- Substitute skill names.
 if (effectName) then
  if (string_find(message, "%%s")) then
   -- Hide skill names if there is an icon for it and the option is set.
   if (filterCodes and (hasTexture and not currentProfile.exclusiveSkillsDisabled or currentProfile.hideSkills)) then
    message = string_gsub(message, "%s?%-?%s?%%sl?%s?%-?%s?", "");
    checkParens = true;
   else
    -- Use the user defined substitution for the ability if there is one.
    local isChanged;
    if (currentProfile.abilitySubstitutions[effectName]) then
     effectName = currentProfile.abilitySubstitutions[effectName];
     isChanged = true;
    end

    -- Do long substitutions.
    if (string_find(message, "%%sl")) then message = string_gsub(message, "%%sl", effectName); end

    -- Abbreviate skill for English if it wasn't user substituted and abbreviation is enabled.
    if (isEnglish and not isChanged and currentProfile.abbreviateAbilities) then
     effectName = AbbreviateSkillName(effectName);
    end

    -- Do remaining substitutions.
    message = string_gsub(message, "%%s", effectName);
   end
  end
 end
 

 -- Remove empty parenthesis left frame ignoring event codes.
 if (checkParens) then message = string_gsub(message, "%(%)", ""); end


 -- Substitute damage types.
 if (damageType and string_find(message, "%%t")) then message = string_gsub(message, "%%t", damageTypeMap[damageType] or STRING_SCHOOL_UNKNOWN); end
 
 
 -- Append partial effects if there are any.
 if (partialEffects) then message = message .. partialEffects; end

 
 -- Append the merge trailer if there is one.
 if (mergeTrailer) then message = message .. mergeTrailer; end
 
 -- Return the formatted message.
 return message; 
end


-- ****************************************************************************
-- Returns the event type prefix and affected unit name for events that
-- can be incoming or outgoing.
-- ****************************************************************************
local function GetInOutEventData(parserEvent)
 local eventTypeString, affectedUnitName, ignorePhysical;
 
 -- Get the information for whether the event is incoming or outgoing.
 if (parserEvent.recipientUnit == "player") then
  affectedUnitName = parserEvent.sourceName;
  eventTypeString = "INCOMING";
 elseif (parserEvent.sourceUnit == "player") then
  affectedUnitName = parserEvent.recipientName;
  eventTypeString = "OUTGOING";
  ignorePhysical = true;
 elseif (parserEvent.recipientUnit == "pet") then
  affectedUnitName = parserEvent.sourceName;
  eventTypeString = "PET_INCOMING";
 elseif (parserEvent.sourceUnit == "pet") then
  affectedUnitName = parserEvent.recipientName;
  eventTypeString = "PET_OUTGOING";
 end

 return eventTypeString, affectedUnitName, ignorePhysical;
end


-- ****************************************************************************
-- Detect all power gains.
-- ****************************************************************************
local function DetectPowerGain(powerAmount)
 -- Get the event settings.
 local eventSettings = MSBTProfiles.currentProfile.events.NOTIFICATION_POWER_GAIN;

 -- Don't do anything if the event is disabled. 
 if (eventSettings.disabled) then return; end

 -- Display the power change if it is a gain.
 if (powerAmount > lastPowerAmount) then
  DisplayEvent(eventSettings, FormatEvent(eventSettings.message, powerAmount - lastPowerAmount, nil, nil, UnitPowerType("player")));
 end
end


-- ****************************************************************************
-- Handle combo point changes.
-- ****************************************************************************
local function HandleComboPoints(numCP)
 -- Get the correct event settings.
 local eventSettings = MSBTProfiles.currentProfile.events.NOTIFICATION_CP_GAIN;
 if (numCP == MAX_COMBO_POINTS) then
  -- Prevent the full combo point event from showing more than once.
  if (finisherShown) then return; end
  eventSettings = MSBTProfiles.currentProfile.events.NOTIFICATION_CP_FULL;
  finisherShown = true;
 else
  finisherShown = false;
 end

 -- Don't do anything if the event is disabled.
 if (eventSettings.disabled) then return; end

 -- Display the event.
 DisplayEvent(eventSettings, FormatEvent(eventSettings.message, numCP));
end


-- ****************************************************************************
-- Handle monster emotes.
-- ****************************************************************************
local function HandleMonsterEmotes(emoteString)
 -- Get the event settings.
 local eventSettings = MSBTProfiles.currentProfile.events.NOTIFICATION_MONSTER_EMOTE;

 -- Don't do anything if the event is disabled.
 if (eventSettings.disabled) then return; end

 -- Loop through all of the recent emotes and remove the old ones.
 local now = GetTime();
 for emote, cleanupTime in pairs(recentEmotes) do
  if (now >= cleanupTime) then recentEmotes[emote] = nil; end
 end

 -- Don't do anything if the emote has already been shown within the specified time frame.
 if (recentEmotes[emoteString]) then return; end

 -- Display the event and add it to the recent emotes list.
 DisplayEvent(eventSettings, FormatEvent(eventSettings.message, nil, nil, nil, nil, nil, emoteString));
 recentEmotes[emoteString] = now + EMOTE_HOLD_TIME; 
end


-- ****************************************************************************
-- Merges like combat events.
-- ****************************************************************************
local function MergeEvents(numEvents)
 -- Holds an unmerged event and whether or not to merge it.
 local unmergedEvent;
 local doMerge = false;

 -- Don't attempt to merge any more events than were available when the function was called since
 -- more events may get added while the merge is taking place.
 for i = 1, numEvents do
  -- Get the unmerged event.
  unmergedEvent = unmergedEvents[i];

  -- Loop through all of the events in the merged events array.
  for _, mergedEvent in ipairs(mergedEvents) do
   -- Check if the event types match.
   if (unmergedEvent.eventType == mergedEvent.eventType) then
    -- Check if there is no skill name. 
    if (not unmergedEvent.effectName) then
     -- Set the merge flag if the affected unit name is the same.
     if ((unmergedEvent.name == mergedEvent.name) and unmergedEvent.name) then doMerge = true; end

    -- The skill names match.
    elseif (unmergedEvent.effectName == mergedEvent.effectName) then
     -- Change the name to the multiple targets string if the names don't match.
     if (unmergedEvent.name ~= mergedEvent.name) then mergedEvent.name = L.MSG_MULTIPLE_TARGETS; end

     -- Set the merge flag.
     doMerge = true; 
    end
   end -- Event types match.

   -- Check if the event should be merged.
   if (doMerge) then
    -- Clear partial effects.
    mergedEvent.partialEffects = nil;

    -- Set the event merged flag for the event being merged.
    unmergedEvent.eventMerged = true;

    -- Total the amount if there is one.
    if (unmergedEvent.amount) then mergedEvent.amount = (mergedEvent.amount or 0) + unmergedEvent.amount; end

    -- Total the overheal amount if there is one.
    if (unmergedEvent.overhealAmount) then mergedEvent.overhealAmount = (mergedEvent.overhealAmount or 0) + unmergedEvent.overhealAmount; end

    -- Increment the number of merged events.
    mergedEvent.numMerged = mergedEvent.numMerged + 1;

    -- Increment the number of crits is the event being merged is a crit.  Clear the crit flag for the merged event if it isn't.
    if (unmergedEvent.isCrit) then mergedEvent.numCrits = mergedEvent.numCrits + 1; else mergedEvent.isCrit = false; end

    -- Break out of the merged events loop since the event has been merged.
    break;
   end -- Do Merge.
  end -- Loop through merged events.

  -- Add the event to the end of the merged events array if it wasn't merged.
  if (not doMerge) then
   unmergedEvent.numMerged = 0;

   -- Set the number of crits depending on if the event is a crit or not.
   if (unmergedEvent.isCrit) then unmergedEvent.numCrits = 1; else unmergedEvent.numCrits = 0; end

   -- Add the event to the end of the merged events array.
   mergedEvents[#mergedEvents+1] = unmergedEvent;
  end

  -- Reset the event merge flag.
  doMerge = false;
 end -- Loop through unmerged events.

 
 -- Append merge trailer information to the merged events.
 for _, mergedEvent in ipairs(mergedEvents) do
  -- Check if there were any events merged.
  if (mergedEvent.numMerged > 0) then
   -- Create the crit trailer text if there were any crits.
   local critTrailer = "";
   if (mergedEvent.numCrits > 0) then
    critTrailer = string_format(", %d %s", mergedEvent.numCrits, mergedEvent.numCrits == 1 and L.MSG_CRIT or L.MSG_CRITS);
   end
   
   -- Set the event's merge trailer field.
   mergedEvent.mergeTrailer = string_format(" [%d %s%s]", mergedEvent.numMerged + 1, L.MSG_HITS, critTrailer);
  end -- Events were merged.
 end

 
 -- Remove the processed events from unmerged events queue.
 for i = 1, numEvents do
  -- Recycle the unmerged event if it was merged.
  if (unmergedEvents[1].eventMerged) then 
   EraseTable(unmergedEvents[1]);
   combatEventCache[#combatEventCache+1] = unmergedEvents[1];
  end
  
  -- Remove the event from the unmerged events array.
  table_remove(unmergedEvents, 1);
 end
end


-------------------------------------------------------------------------------
-- Command handler functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Returns the current and remaining parameters from the passed string.
-- ****************************************************************************
local function GetNextParameter(paramString)
 local remainingParams;
 local currentParam = paramString;

 -- Look for a space.
 local index = string_find(paramString, " ");
 if (index) then
  -- Get the current and remaing parameters.
  currentParam = string.sub(paramString, 1, index-1);
  remainingParams = string.sub(paramString, index+1);
 end

 -- Return the current parameter and the remaining ones.
 return currentParam, remainingParams;
end


-- ****************************************************************************
-- Called to handle commands.
-- ****************************************************************************
local function CommandHandler(params)
 -- Get the parameter.
 local currentParam, remainingParams;
 currentParam, remainingParams = GetNextParameter(params);

 -- Flag for whether or not to show usage info.
 local showUsage = true;

 -- Make sure there is a current parameter and lower case it.
 if (currentParam) then currentParam = string.lower(currentParam); end

 -- Look for the recognized parameters.
 if (currentParam == "") then
  -- Load the on demand options if they are not loaded.
  if (not IsAddOnLoaded("MSBTOptions")) then UIParentLoadAddOn("MSBTOptions"); end

  -- Show the options interface after verifying the on demand options actually loaded.
  if (IsAddOnLoaded("MSBTOptions")) then MSBTOptions.Main.ShowMainFrame(); end

  -- Don't show the usage info.
  showUsage = false;

  -- Reset.
  elseif (currentParam == L.COMMAND_RESET) then
  -- Reset the current profile.
  MSBTProfiles.ResetProfile(nil, true);

  -- Don't show the usage info.
  showUsage = false;
  
 -- Disable.
 elseif (currentParam == L.COMMAND_DISABLE) then
  -- Set the user disabled option.
  MSBTProfiles.SetOptionUserDisabled(true);

  -- Output an informative message.
  Print(L.MSG_DISABLE, 1,1,1);

  -- Don't show the usage info.
  showUsage = false;

 -- Enable.
 elseif (currentParam == L.COMMAND_ENABLE) then
  -- Unset the user disabled option.
  MSBTProfiles.SetOptionUserDisabled(false);

  -- Output an informative message.
  Print(L.MSG_ENABLE, 1,1,1);

  -- Don't show the usage info.
  showUsage = false;

 -- Version.
 elseif (currentParam == L.COMMAND_SHOWVER) then
  -- Output the current version number.
  Print(MikSBT.VERSION_STRING, 1,1,1);

  -- Don't show the usage info.
  showUsage = false;

 end 

 -- Check if the usage information should be shown.
 if (showUsage) then
  -- Loop through all of the entries in the command usage list.
  for _, msg in ipairs(L.COMMAND_USAGE) do
   Print(msg, 1, 1, 1);
  end
 end -- Show usage.
end


-------------------------------------------------------------------------------
-- Event handlers.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Handles damage parser events.
-- ****************************************************************************
local function DamageHandler(parserEvent, currentProfile)
 -- Setup info for whether the event is incoming or outgoing.
 local eventTypeString, affectedUnitName, ignorePhysical = GetInOutEventData(parserEvent);

 -- Ignore the event if it doesn't pertain to the player or their pet.
 if (not eventTypeString) then return; end
 
 -- Ignore the event if the damage amount is under the damage threshold to be shown.
 if (parserEvent.amount and parserEvent.amount < currentProfile.damageThreshold) then return; end

 -- Append the spell prefix if there is a skill.
 if (parserEvent.skillID) then eventTypeString = eventTypeString .. "_SPELL"; end

 -- Append dot suffix if it's a dot.
 eventTypeString = eventTypeString .. (parserEvent.isDoT and "_DOT" or "_DAMAGE");
 
 return eventTypeString, true, parserEvent.skillName, affectedUnitName, ignorePhysical;
end


-- ****************************************************************************
-- Handles miss parser events.
-- ****************************************************************************
local function MissHandler(parserEvent, currentProfile)
 -- Setup info for whether the event is incoming or outgoing.
 local eventTypeString, affectedUnitName = GetInOutEventData(parserEvent);

 -- Ignore the event if it doesn't pertain to the player or their pet.
 if (not eventTypeString) then return; end

 -- Append the spell prefix if there is a skill.
 if (parserEvent.skillID) then eventTypeString = eventTypeString .. "_SPELL"; end

 -- Append the miss type.
 eventTypeString = eventTypeString .. "_" .. parserEvent.missType;   

 return eventTypeString, true, parserEvent.skillName, affectedUnitName;
end


-- ****************************************************************************
-- Handles heal parser events.
-- ****************************************************************************
local function HealHandler(parserEvent, currentProfile)
 -- Setup info for whether the event is incoming or outgoing.
 local eventTypeString, affectedUnitName = GetInOutEventData(parserEvent);

 -- Ignore the event if it doesn't pertain to the player or their pet.
 if (not eventTypeString) then return; end

 -- Ignore the event if the heal amount is under the healing threshold to be shown.
 if (parserEvent.amount and parserEvent.amount < currentProfile.healThreshold) then return; end

 -- Append hot suffix if it's a hot.
 eventTypeString = eventTypeString .. (parserEvent.isHoT and "_HOT" or "_HEAL");

 return eventTypeString, true, parserEvent.skillName, affectedUnitName;
end


-- ****************************************************************************
-- Handles interrupt parser events.
-- ****************************************************************************
local function InterruptHandler(parserEvent, currentProfile)
 -- Setup info for whether the event is incoming or outgoing.
 local eventTypeString, affectedUnitName = GetInOutEventData(parserEvent);

 -- Ignore the event if it doesn't pertain to the player or their pet.
 if (not eventTypeString) then return; end

 -- Append interrupt suffix. 
 eventTypeString = eventTypeString .. "_SPELL_INTERRUPT";
 
 return eventTypeString, true, parserEvent.extraSkillName, affectedUnitName;
end


-- ****************************************************************************
-- Handles environmental parser events.
-- ****************************************************************************
local function EnvironmentalHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't the player.
 if (parserEvent.recipientUnit ~= "player") then return; end
 
 return "INCOMING_ENVIRONMENTAL", nil, _G["STRING_ENVIRONMENTAL_DAMAGE_" .. parserEvent.hazardType];
end


-- ****************************************************************************
-- Handles aura parser events.
-- ****************************************************************************
local function AuraHandler(parserEvent, currentProfile)
 local eventTypeString, affectedUnitName;
 local effectName = parserEvent.skillName;
  
 -- Aura is pertaining to the player.
 if (parserEvent.recipientUnit == "player") then
  -- Buff gain/fade.
  if (parserEvent.auraType == "BUFF") then
   -- Buff gain.
   if (not parserEvent.isFade) then
    -- Set the active regen ability if the buff being gained is on the regen abilities list.
    if (regenAbilities[effectName] and not currentProfile.regenAbilitiesDisabled) then activeRegenAbility = effectName; end

   -- Buff fade.
   else
    -- Clear the active regen ability if the fading buff is the active one.
    if (effectName == activeRegenAbility) then activeRegenAbility = nil; end
   end
  end

  -- Ignore the event if it's suppressed due to a trigger.
  if (triggerSuppressions[effectName]) then return; end

  -- Set notificaiton buff/debuff and append fade prefix if the aura is fading.   
  eventTypeString = "NOTIFICATION_" .. parserEvent.auraType;
  if (parserEvent.isFade) then eventTypeString = eventTypeString .. "_FADE"; end

 -- Aura is pertaining to another unit.
 else
  -- Ignore the event if it's suppressed due to a trigger.
  if (triggerSuppressions[effectName]) then return; end
  
  -- Ignore the event if it isn't for the current target.
  if (not TestFlagsAll(parserEvent.recipientFlags, MSBTParser.TARGET_TARGET)) then return; end

  -- Ignore the event if it's a friendly unit.
  if (not UnitIsEnemy("player", "target")) then return; end

  -- Ignore the event it isn't not a buff gain.
  if (parserEvent.auraType ~= "BUFF" or parserEvent.isFade == true) then return; end

  eventTypeString = "NOTIFICATION_ENEMY_BUFF";
  affectedUnitName = parserEvent.recipientName;
 end -- Player or enemy check.

 return eventTypeString, nil, effectName, affectedUnitName;
end


-- ****************************************************************************
-- Handles enchant parser events.
-- ****************************************************************************
local function EnchantHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't the player.
 if (parserEvent.recipientUnit ~= "player") then return; end
 
 -- Set the item buff event type and append fade suffix if the enchant is fading.
 local eventTypeString = "NOTIFICATION_ITEM_BUFF";
 if (parserEvent.isFade) then eventTypeString = eventTypeString .. "_FADE"; end
  
 return eventTypeString, nil, parserEvent.skillName;
end


-- ****************************************************************************
-- Handles dispel parser events.
-- ****************************************************************************
local function DispelHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't a buff.
 if (parserEvent.auraType ~= "BUFF") then return; end
 
 -- Get the correct dispel event.
 local eventTypeString;
 if (parserEvent.sourceUnit == "player") then
  eventTypeString = "OUTGOING_DISPEL";
 elseif (parserEvent.sourceUnit == "pet") then
  eventTypeString = "PET_OUTGOING_DISPEL";
 else
  -- Ignore the event if it isn't from the player or their pet.
  return;
 end
 
 return eventTypeString, nil, parserEvent.extraSkillName;
end


-- ****************************************************************************
-- Handles power parser events.
-- ****************************************************************************
local function PowerHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't the player.
 if (parserEvent.isLeech) then
  if (parserEvent.sourceUnit ~= "player") then return; end
 elseif (parserEvent.recipientUnit ~= "player") then
  return;
 end

 -- Ignore the event if all power gains are being shown.
 if (currentProfile.showAllPowerGains or currentBuffs[activeRegenAbility]) then return; end
   
 -- Ignore the event if the power change is under the threshold to be shown.
 if (parserEvent.amount and parserEvent.amount < currentProfile.powerThreshold) then return; end

 -- Append gain or loss suffix. 
 local eventTypeString = "NOTIFICATION_POWER_" .. (parserEvent.isDrain and "LOSS" or "GAIN");
 
 return eventTypeString, true, parserEvent.skillName;
end


-- ****************************************************************************
-- Handles kill parser events.
-- ****************************************************************************
local function KillHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't a kill from the player.
 if (parserEvent.sourceUnit ~= "player") then return; end
 
 -- Ignore the event if it is a player guardian (Hunter snakes, etc).
 if (TestFlagsAll(parserEvent.recipientFlags, bit_bor(MSBTParser.UNITTYPE_GUARDIAN, MSBTParser.CONTROL_HUMAN))) then return; end

 -- Figure out the event type depending on whether a player or the server
 -- controlled the unit that was killed.
 local eventTypeString = "NOTIFICATION_";
 eventTypeString = eventTypeString .. (TestFlagsAll(parserEvent.recipientFlags, MSBTParser.CONTROL_SERVER) and "NPC" or "PC");
 eventTypeString = eventTypeString .. "_KILLING_BLOW";

 return eventTypeString, nil, parserEvent.recipientName;
end


-- ****************************************************************************
-- Handles honor parser events.
-- ****************************************************************************
local function HonorHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't for the player.
 if (parserEvent.recipientUnit ~= "player") then return; end
 
 return "NOTIFICATION_HONOR_GAIN";
end


-- ****************************************************************************
-- Handles reputation parser events.
-- ****************************************************************************
local function ReputationHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't for the player.
 if (parserEvent.recipientUnit ~= "player") then return; end

 -- Append loss or gain suffix.
 local eventTypeString = "NOTIFICATION_REP_" .. (parserEvent.isLoss and "LOSS" or "GAIN");
 return eventTypeString, nil, parserEvent.factionName;
end


-- ****************************************************************************
-- Handles proficiency parser events.
-- ****************************************************************************
local function ProficiencyHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't for the player.
 if (parserEvent.recipientUnit ~= "player") then return; end

 return "NOTIFICATION_SKILL_GAIN", nil, parserEvent.skillName;
end


-- ****************************************************************************
-- Handles experience parser events.
-- ****************************************************************************
local function ExperienceHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't for the player.
 if (parserEvent.recipientUnit ~= "player") then return; end

 return "NOTIFICATION_EXPERIENCE_GAIN";
end


-- ****************************************************************************
-- Handles extra attacks parser events.
-- ****************************************************************************
local function ExtraAttacksHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't for the player.
 if (parserEvent.sourceUnit ~= "player") then return; end

 return "NOTIFICATION_EXTRA_ATTACK", nil, parserEvent.skillName;
end


-- ****************************************************************************
-- Handles loot parser events.
-- ****************************************************************************
local function LootHandler(parserEvent, currentProfile)
 -- Ignore the event if it isn't for the player.
 if (parserEvent.recipientUnit ~= "player") then return; end

 -- Money gain.
 if (parserEvent.isMoney) then
  local moneyString = parserEvent.moneyString;
  moneyString = string_gsub(moneyString, GOLD, "|cffffd700%1|r");
  moneyString = string_gsub(moneyString, SILVER, "|cff808080%1|r");
  moneyString = string_gsub(moneyString, COPPER, "|cffeda55f%1|r");
  
  return "NOTIFICATION_MONEY", nil, moneyString;
 end

 -- Ignore the event if there is no item link.
 local itemLink = parserEvent.itemLink
 if (not itemLink) then return; end
 -- Ignore the event if the item is not a soul shard.
 local matchStart, _, itemID, itemName = string_find(itemLink, "item:(%d+):[%-%d:]+|h%[(.+)%]");
 if (itemID ~= "6265") then return; end

 return "NOTIFICATION_SOUL_SHARD_CREATED", nil, itemName;
end


-- ****************************************************************************
-- Parser events handler.
-- ****************************************************************************
local function ParserEventsHandler(parserEvent)
 -- Get a local reference to the current profile.
 local currentProfile = MSBTProfiles.currentProfile;

 -- Information regarding how to display the event.
 local eventTypeString, mergeEligible, effectName, affectedUnitName, ignorePhysical;

 -- Local copy of the eventType for faster access.
 local eventType = parserEvent.eventType;

 -- Call the correct handler for the event type if there is one.
 local handler = eventHandlers[eventType];
 if (handler) then
  eventTypeString, mergeEligible, effectName, affectedUnitName, ignorePhysical = handler(parserEvent, currentProfile);
 end

 -- Ignore the event if it is unrecognized.
 if (not eventTypeString) then return; end
 
 -- Ignore the event if there is a skill name and it's suppressed.
 if (effectName and currentProfile.abilitySuppressions[effectName]) then return; end
 
 -- Ignore the event if there is no profile data for it, it's disabled, or the scroll area it's using is not active.
 local isCrit = parserEvent.isCrit;
 local eventSettings = currentProfile.events[isCrit and eventTypeString .. "_CRIT" or eventTypeString];
 if (not eventSettings or eventSettings.disabled or not IsScrollAreaActive(eventSettings.scrollArea)) then return; end

 -- Get the formatted partial effects if it's a damage or environmental event. 
 local partialEffects;
 if (eventType == "damage" or eventType == "environmental") then
  partialEffects = FormatPartialEffects(parserEvent.absorbAmount, parserEvent.blockAmount, parserEvent.resistAmount, parserEvent.isGlancing, parserEvent.isCrushing);
 end


 -- Attempt to get the texture for the event if icons are not disabled.
 local effectTexture;
 if (not currentProfile.skillIconsDisabled) then
  effectTexture = parserEvent.skillTexture;
  if (not effectTexture and parserEvent.skillID) then _, _, effectTexture = GetSpellInfo(parserEvent.skillID); end
 
  -- Override texture for dispels and interrupts.
  if ((eventType == "dispel" or eventType == "interrupt") and parserEvent.extraSkillID) then
   _, _, effectTexture = GetSpellInfo(parserEvent.extraSkillID);
  end
 end

 -- Check if the event is eligible for merging. 
 if (mergeEligible and not currentProfile.mergeExclusions[effectName]) then
  -- Acquire a recycled table from cache or create a new one if there aren't any available in cache.
  local combatEvent = table_remove(combatEventCache) or {};
  

  -- Setup the combat event.
  combatEvent.eventType = eventTypeString;
  combatEvent.isCrit = isCrit;
  combatEvent.amount = parserEvent.amount;
  combatEvent.effectName = effectName;
  combatEvent.effectTexture = effectTexture;
  combatEvent.name = affectedUnitName;
  combatEvent.damageType = parserEvent.damageType;
  combatEvent.ignorePhysical = ignorePhysical;
  combatEvent.partialEffects = partialEffects;
  combatEvent.overhealAmount = parserEvent.overhealAmount;
  combatEvent.powerType = parserEvent.powerType;

  
  -- Throttle events according to user settings.
  if (effectName) then
   -- Get the duration the ability should be throttled for, if any.
   local throttleDuration = currentProfile.throttleList[effectName];

   -- Set throttle duration for power changes or dots/hots if there isn't a specific one set for the ability.
   if (not throttleDuration) then
    -- Use the dot throttle duration.
    if (parserEvent.isDoT and currentProfile.dotThrottleDuration > 0) then
     throttleDuration = currentProfile.dotThrottleDuration;

    -- Use the hot throttle duration.
    elseif (parserEvent.isHoT and currentProfile.hotThrottleDuration > 0) then
     throttleDuration = currentProfile.hotThrottleDuration;

    -- Use the power change throttle duration.
    elseif (parserEvent.powerType and currentProfile.powerThrottleDuration > 0) then
     throttleDuration = currentProfile.powerThrottleDuration;
    end
   end

   -- Check if there is a throttle duration for the ability.
   if (throttleDuration and throttleDuration > 0) then
    -- Get throttle info for the ability.  Create it if it hasn't already been.
    local throttledAbility = throttledAbilities[effectName];
    if (not throttledAbility) then
     throttledAbility = {};
     throttledAbility.throttleWindow = 0;
     throttledAbility.lastEventTime = 0;
     throttledAbilities[effectName] = throttledAbility;
    end

    -- Throttle the event and exit if the throttle window for the ability hasn't elapsed.
    local now = GetTime();
    if (throttledAbility.throttleWindow > 0) then
      throttledAbility.lastEventTime = now;
      throttledAbility[#throttledAbility+1] = combatEvent;
      return;

    -- The throttle window for the ability has elapsed.
    else
     -- Set the throttle window for the ability to its throttle duration.
     throttledAbility.throttleWindow = throttleDuration;

     -- Check if the throttle frame is not visible and make it visible so the OnUpdate events start firing.
     -- This is done to keep the number of OnUpdate events down to a minimum for better performance.
     if (not throttleFrame:IsVisible()) then throttleFrame:Show(); end

     -- Throttle the event and exit if it has been seen within the throttle duration.
     if (now - throttledAbility.lastEventTime < throttleDuration) then
      throttledAbility.lastEventTime = now;
      throttledAbility[#throttledAbility+1] = combatEvent; 
      return;
     end
    end
   end -- Has throttle duration.
  end -- Has effectName.
  
  -- Add event to the unmerged events for potential merging.
  unmergedEvents[#unmergedEvents+1] = combatEvent;
  
  -- Check if the merge event frame is not visible and make it visible so the OnUpdate events start firing.
  -- This is done to keep the number of OnUpdate events down to a minimum for better performance.
  if (not eventFrame:IsVisible()) then eventFrame:Show(); end
  
 -- Event is not to be merged so just display it now.
 else
  -- Display the event.
  local outputMessage = FormatEvent(eventSettings.message, parserEvent.amount, parserEvent.damageType, parserEvent.overhealAmount, parserEvent.powerType, affectedUnitName, effectName, partialEffects, nil, effectTexture, ignorePhysical);
  DisplayEvent(eventSettings, outputMessage, effectTexture);
 end
end


-- ****************************************************************************
-- Called when the event frame is updated.
-- ****************************************************************************
local function OnUpdateEventFrame(this, elapsed)
 -- Increment the amount of time passed since the last update. 
 lastMergeUpdate = lastMergeUpdate + elapsed;

 -- If it's time for an update.
 if (lastMergeUpdate >= MERGE_DELAY_TIME) then
  -- Merge like events.
  MergeEvents(#unmergedEvents);

  -- Display and recycle the merged events.
  local eventSettings, outputMessage;
  for i, combatEvent in ipairs(mergedEvents) do
   eventSettings = MSBTProfiles.currentProfile.events[combatEvent.isCrit and combatEvent.eventType .. "_CRIT" or combatEvent.eventType];
   outputMessage = FormatEvent(eventSettings.message, combatEvent.amount, combatEvent.damageType, combatEvent.overhealAmount, combatEvent.powerType, combatEvent.name, combatEvent.effectName, combatEvent.partialEffects, combatEvent.mergeTrailer, combatEvent.effectTexture, combatEvent.ignorePhysical, true)
   DisplayEvent(eventSettings, outputMessage, combatEvent.effectTexture);
   mergedEvents[i] = nil;
   EraseTable(combatEvent);
   combatEventCache[#combatEventCache+1] = combatEvent;
  end

  -- Hide the frame if there are no remaining unmerged events so the OnUpdate events stop firing.
  -- This is done to keep the number of OnUpdate events down to a minimum for better performance.
  if (#unmergedEvents == 0) then this:Hide(); end 
  
  -- Reset the time since last update.
  lastMergeUpdate = 0;
 end
end


-- ****************************************************************************
-- Called when the throttle frame is updated.
-- ****************************************************************************
local function OnUpdateThrottleFrame(this, elapsed)
 -- Increment the amount of time passed since the last update. 
 lastThrottleUpdate = lastThrottleUpdate + elapsed;

 -- If it's time for an update.
 if (lastThrottleUpdate >= THROTTLE_UPDATE_TIME) then
  -- Flag for whether there are any events currently throttled.
  local eventsThrottled;

  -- Loop through all the throttled abilities.
  for _, throttledAbility in pairs(throttledAbilities) do
   -- Check if the ability is currently being throttled.
   if (throttledAbility.throttleWindow > 0) then
    -- Decrement the throttle window.
    throttledAbility.throttleWindow = throttledAbility.throttleWindow - lastThrottleUpdate;

    -- Check if the throttle window has elapsed.
    if (throttledAbility.throttleWindow <= 0) then
     -- Add throttled events to the merging system if there are any.
     if (#throttledAbility > 0) then 
      for i = 1, #throttledAbility do
       unmergedEvents[#unmergedEvents+1] = throttledAbility[i];
       throttledAbility[i] = nil;
      end

      -- Check if the merge event frame is not visible and make it visible so the OnUpdate events start firing.
      -- This is done to keep the number of OnUpdate events down to a minimum for better performance.
      if (not eventFrame:IsVisible()) then eventFrame:Show(); end
     end
    -- Ability is still throttled so set the flag.
	else
     eventsThrottled = true;
    end
   end -- Ability is within its throttle window.
  end -- Loop through throttled abilities.


  -- Hide the frame if there are no remaining throttled events so the OnUpdate events stop firing.
  -- This is done to keep the number of OnUpdate events down to a minimum for better performance.
  if (not eventsThrottled) then this:Hide(); end
  
  -- Reset the time since last update.
  lastThrottleUpdate = 0;
 end
end


-- ****************************************************************************
-- Called when the registered events occur.
-- ****************************************************************************
local function OnEvent(this, event, arg1, arg2)
 -- When an addon is loaded.
 if (event == "ADDON_LOADED") then
  -- Make sure it's this addon.
  if (arg1 == "MikScrollingBattleText") then
   -- Don't get notification for other addons being loaded.
   this:UnregisterEvent("ADDON_LOADED");

   -- Register slash commands
   SLASH_MSBT1 = MikSBT.COMMAND;
   SlashCmdList["MSBT"] = CommandHandler;

   -- Initialize the saved variables to make sure there is a profile to work with.
   MSBTProfiles.InitSavedVariables();

   -- Add a button to launch MSBT's options from the Blizzard interface options.
   SetupBlizzardOptions();
  end

  -- Variables for all addons loaded.
 elseif (event == "VARIABLES_LOADED") then
  -- Disable or enable the mod depending on the saved setting.
  -- Must do it once the variables are loaded because blizzard's code overrides the FCT
  -- settings after the ADDON_LOADED code runs.
  MSBTProfiles.SetOptionUserDisabled(MSBTProfiles.IsModDisabled());

  -- Display warning if the old icon module is loaded.  
  if (MSBTIconSupport) then message(L.MSG_ICON_MODULE_WARNING); end
  collectgarbage("collect");


 -- Power changes.
 elseif (event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_ENERGY") then
  -- Check if the power change is for the player.  
  if (arg1 == "player") then
   -- Update the power amount.
   -- Detect power gains if there is a regen ability active or show all power gains is enabled.
   local powerAmount = UnitMana("player");
   if (currentBuffs[activeRegenAbility] or MSBTProfiles.currentProfile.showAllPowerGains) then DetectPowerGain(powerAmount); end
   lastPowerAmount = powerAmount; 
  end

 -- Leave Combat.  
 elseif (event == "PLAYER_REGEN_ENABLED") then
  -- Get the event settings for leaving combat.
  local eventSettings = MSBTProfiles.currentProfile.events.NOTIFICATION_COMBAT_LEAVE;

  -- Display the event if it isn't disabled.
  if (not eventSettings.disabled) then DisplayEvent(eventSettings, eventSettings.message); end
  
 -- Enter Combat.  
 elseif (event == "PLAYER_REGEN_DISABLED") then
  -- Get the event settings for leaving combat.
  local eventSettings = MSBTProfiles.currentProfile.events.NOTIFICATION_COMBAT_ENTER;

  -- Display the event if it isn't disabled.
  if (not eventSettings.disabled) then DisplayEvent(eventSettings, eventSettings.message); end
  
 -- Leave Combat.  
 elseif (event == "PLAYER_COMBO_POINTS") then
  -- Make sure there are combo points and show the normal or full cp event.
  local numCP = GetComboPoints();
  if (numCP ~= 0) then HandleComboPoints(numCP); end

 -- Monster emotes.
 elseif (event == "CHAT_MSG_MONSTER_EMOTE") then
  -- Ignore the event if it's not the current target.
  if (arg2 ~= UnitName("target")) then return; end
  HandleMonsterEmotes(string_gsub(arg1, "%%s", arg2));
 end
end


-- ****************************************************************************
-- Enables the module.
-- ****************************************************************************
local function Enable()
 -- Register events to handle extra notifications.
 eventFrame:RegisterEvent("UNIT_MANA");
 eventFrame:RegisterEvent("UNIT_RAGE");
 eventFrame:RegisterEvent("UNIT_ENERGY");
 eventFrame:RegisterEvent("PLAYER_COMBO_POINTS");
 eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
 eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
 eventFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE");
 
 -- Register the parser events handler.
 MSBTParser.RegisterHandler(ParserEventsHandler);
end


-- ****************************************************************************
-- Disables the module.
-- ****************************************************************************
local function Disable()
 -- Stop receiving updates.
 eventFrame:Hide();
 eventFrame:UnregisterAllEvents();
 
 -- Unregister the parser events handler.
 MSBTParser.UnregisterHandler(ParserEventsHandler);
end


-- ****************************************************************************
-- Called when the module is loaded.
-- ****************************************************************************
local function OnLoad()
 -- Create a frame to receive events.
 eventFrame = CreateFrame("Frame");
 eventFrame:Hide();
 eventFrame:SetScript("OnEvent", OnEvent);
 eventFrame:SetScript("OnUpdate", OnUpdateEventFrame);
 
 -- Create a frame to receive throttle update events.
 throttleFrame = CreateFrame("Frame");
 throttleFrame:Hide();
 throttleFrame:SetScript("OnUpdate", OnUpdateThrottleFrame);

 -- Create the map of handlers to call for each event.
 eventHandlers["damage"] = DamageHandler;
 eventHandlers["miss"] = MissHandler;
 eventHandlers["heal"] = HealHandler;
 eventHandlers["interrupt"] = InterruptHandler;
 eventHandlers["environmental"] = EnvironmentalHandler;
 eventHandlers["aura"] = AuraHandler;
 eventHandlers["enchant"] = EnchantHandler;
 eventHandlers["dispel"] = DispelHandler;
 eventHandlers["power"] = PowerHandler;
 eventHandlers["kill"] = KillHandler;
 eventHandlers["honor"] = HonorHandler;
 eventHandlers["reputation"] = ReputationHandler;
 eventHandlers["proficiency"] = ProficiencyHandler;
 eventHandlers["experience"] = ExperienceHandler;
 eventHandlers["extraattacks"] = ExtraAttacksHandler;
 eventHandlers["loot"] = LootHandler;
 
 -- Create the damage type lookup map.
 damageTypeMap[DAMAGETYPE_PHYSICAL] = STRING_SCHOOL_PHYSICAL;
 damageTypeMap[DAMAGETYPE_HOLY] = STRING_SCHOOL_HOLY;
 damageTypeMap[DAMAGETYPE_FIRE] = STRING_SCHOOL_FIRE;
 damageTypeMap[DAMAGETYPE_NATURE] = STRING_SCHOOL_NATURE;
 damageTypeMap[DAMAGETYPE_FROST] = STRING_SCHOOL_FROST;
 damageTypeMap[DAMAGETYPE_SHADOW] = STRING_SCHOOL_SHADOW;
 damageTypeMap[DAMAGETYPE_ARCANE] = STRING_SCHOOL_ARCANE;
 
 -- Create the damage color profile entries lookup map. 
 damageColorProfileEntries[DAMAGETYPE_PHYSICAL] = "physical";
 damageColorProfileEntries[DAMAGETYPE_HOLY] = "holy";
 damageColorProfileEntries[DAMAGETYPE_FIRE] = "fire";
 damageColorProfileEntries[DAMAGETYPE_NATURE] = "nature";
 damageColorProfileEntries[DAMAGETYPE_FROST] = "frost";
 damageColorProfileEntries[DAMAGETYPE_SHADOW] = "shadow";
 damageColorProfileEntries[DAMAGETYPE_ARCANE] = "arcane";

 -- Create the power types lookup map. 
 powerTypes[0] = MANA;
 powerTypes[1] = RAGE;
 powerTypes[2] = FOCUS;
 powerTypes[3] = ENERGY;
 powerTypes[4] = HAPPINESS;
 
 -- Set the isEnglish flag correctly.
 if (string_find(GetLocale(), "en..")) then isEnglish = true; end

 -- Add the regen abilities. 
 regenAbilities[SPELL_SPIRIT_TAP] = true;
 regenAbilities[SPELL_INNERVATE] = true;
 
 -- Get the player's class.
 _, playerClass = UnitClass("player");

 -- Register events for when the mod is loaded and variables are loaded.
 eventFrame:RegisterEvent("ADDON_LOADED");
 eventFrame:RegisterEvent("VARIABLES_LOADED");
end




-------------------------------------------------------------------------------
-- Module interface.
-------------------------------------------------------------------------------

-- Protected Variables.
module.damageTypeMap		= damageTypeMap;
module.powerTypes			= powerTypes;

-- Protected Functions.
module.Enable				= Enable;
module.Disable				= Disable;


------------------------------------------------------------------------------------
-- API.
-------------------------------------------------------------------------------

-- Public Constants.
MikSBT.DISPLAYTYPE_INCOMING			= "Incoming";
MikSBT.DISPLAYTYPE_OUTGOING			= "Outgoing";
MikSBT.DISPLAYTYPE_NOTIFICATION		= "Notification";
MikSBT.DISPLAYTYPE_STATIC			= "Static";

-- Public Functions.
MikSBT.RegisterFont					= MSBTAnimations.RegisterFont;
MikSBT.RegisterAnimationStyle		= MSBTAnimations.RegisterAnimationStyle;
MikSBT.RegisterStickyAnimationStyle	= MSBTAnimations.RegisterStickyAnimationStyle;
MikSBT.RegisterSound				= MSBTAnimations.RegisterSound;
MikSBT.IterateFonts					= MSBTAnimations.IterateFonts;
MikSBT.IterateScrollAreas			= MSBTAnimations.IterateScrollAreas;
MikSBT.IterateSounds				= MSBTAnimations.IterateSounds;
MikSBT.DisplayMessage				= MSBTAnimations.DisplayMessage;
MikSBT.IsModDisabled				= MSBTProfiles.IsModDisabled;


-------------------------------------------------------------------------------
-- Load.
-------------------------------------------------------------------------------

OnLoad();