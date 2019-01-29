-------------------------------------------------------------------------------
-- Title: MSBT Options Tab Frames
-- Author: Mik
-------------------------------------------------------------------------------

-- Create module and set its name.
local module = {};
local moduleName = "Tabs";
MSBTOptions[moduleName] = module;


-------------------------------------------------------------------------------
-- Private constants.
-------------------------------------------------------------------------------

local DEFAULT_PROFILE_NAME = "Default";
local DEFAULT_FONT_NAME = "Default";
local DEFAULT_SCROLL_AREA = "Notification";

local EVENT_CATEGORY_MAP = {
  "INCOMING_PLAYER_EVENTS", "INCOMING_PET_EVENTS",
  "OUTGOING_PLAYER_EVENTS", "OUTGOING_PET_EVENTS",
  "NOTIFICATION_EVENTS"
};
  

-------------------------------------------------------------------------------
-- Private variables.
-------------------------------------------------------------------------------

-- Various tab frames.
local tabFrames = {};

-- Reusable table to configure popup frames.
local configTable = {};

-- Reusable table for skill lists.
local skillsTable = {};

-------------------------------------------------------------------------------
-- Imports.
-------------------------------------------------------------------------------

-- Local references to certain modules for faster access.
local MSBTOptMain = MSBTOptions.Main;
local MSBTControls = MSBTOptions.Controls;
local MSBTPopups = MSBTOptions.Popups;
local MSBTProfiles = MikSBT.Profiles;
local MSBTAnimations = MikSBT.Animations;
local MSBTTriggers = MikSBT.Triggers;
local MSBTCooldowns = MikSBT.Cooldowns;
local L = MikSBT.translations;

-- Local references to certain functions for faster access.
local EraseTable = MikSBT.EraseTable;
local DisableControls = MSBTPopups.DisableControls;


-------------------------------------------------------------------------------
-- Utility functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Returns a list of keys for the passed table sorted according to their
-- associated value.
-- ****************************************************************************
local function SortKeysByValue(t)
 local sortedKeys = {};
 local sortedValues = {};

 for k, v in pairs(t) do
  sortedKeys[#sortedKeys+1] = k;
  sortedValues[#sortedValues+1] = v;
 end

 local tempKey, tempValue, j;
 for i = 2, #sortedValues do
  tempValue = sortedValues[i];
  tempKey = sortedKeys[i];
  j = i - 1;
  while (j > 0 and sortedValues[j] > tempValue) do
   sortedValues[j + 1] = sortedValues[j];
   sortedKeys[j + 1] = sortedKeys[j];
   j = j - 1;
  end
  sortedValues[j + 1] = tempValue;
  sortedKeys[j + 1] = tempKey;
 end

 return sortedKeys;
end



-- ****************************************************************************
-- Populates the skills table with the skills from the current/master profile.
-- ****************************************************************************
local function PopulateSkillList(listName)
 EraseTable(skillsTable);
 local currentProfileList = rawget(MSBTProfiles.currentProfile, listName);
 if (currentProfileList) then
  for skillName, value in pairs(currentProfileList) do
   skillsTable[skillName] = value;
  end
 end
 
 -- Get skills available in the master profile that aren't in the current profile. 
 for skillName, value in pairs(MSBTProfiles.masterProfile[listName]) do
  if (skillsTable[skillName] == nil) then skillsTable[skillName] = value; end
 end
end


-- ****************************************************************************
-- Saves the modified skill list to the current profile.
-- ****************************************************************************
local function SaveSkillList(listName)
 for skillName, value in pairs(skillsTable) do
  MSBTProfiles.SetOption(listName, skillName, value);
 end
end


-------------------------------------------------------------------------------
-- General tab functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Toggle the enable state of the profile buttons appropriately.
-- ****************************************************************************
local function GeneralTab_ToggleDeleteButton()
 local controls = tabFrames.general.controls;
 
 if (controls.profileDropdown:GetSelectedID() == DEFAULT_PROFILE_NAME) then
  controls.deleteProfileButton:Disable();
 else
  controls.deleteProfileButton:Enable();
 end
end


-- ****************************************************************************
-- Enables the controls on the general tab.
-- ****************************************************************************
local function GeneralTab_EnableControls()
 for name, frame in pairs(tabFrames.general.controls) do
  if (frame.Enable) then frame:Enable(); end
 end
 
 GeneralTab_ToggleDeleteButton();
end


-- ****************************************************************************
-- Populate the controls with the profile settings.
-- ****************************************************************************
local function GeneralTab_Populate()
 local currentProfile = MSBTProfiles.currentProfile;
 local controls = tabFrames.general.controls;
 
 controls.enableCheckbox:SetChecked(not MSBTProfiles.IsModDisabled());
 controls.stickyCritsCheckbox:SetChecked(not currentProfile.stickyCritsDisabled);
 controls.gameDamageCheckbox:SetChecked(currentProfile.gameDamageEnabled);
 controls.gameHealingCheckbox:SetChecked(currentProfile.gameHealingEnabled);
 controls.enableSoundsCheckbox:SetChecked(not currentProfile.soundsDisabled);
 controls.animationSpeedSlider:SetValue(currentProfile.animationSpeed);
end


-- ****************************************************************************
-- Validates if the passed profile name does not already exist and is valid.
-- ****************************************************************************
local function GenerelTab_ValidateProfileName(profileName)
 if (not profileName or profileName == "") then
  return L.MSG_INVALID_PROFILE_NAME;
 end

 if (MSBTProfiles.savedVariables.profiles[profileName]) then
  return L.MSG_PROFILE_ALREADY_EXISTS;
 end
end


-- ****************************************************************************
-- Copies the selected profile to the name entered.
-- ****************************************************************************
local function GeneralTab_CopyProfile(settings)
 local profileName = settings.inputText;
 local controls = tabFrames.general.controls;

 local dropdown = controls.profileDropdown;
 MSBTProfiles.CopyProfile(dropdown:GetSelectedID(), profileName);
 dropdown:AddItem(profileName, profileName);
 dropdown:Sort();

 dropdown:SetSelectedID(profileName);
 MSBTProfiles.SelectProfile(profileName);
 GeneralTab_Populate();
 GeneralTab_ToggleDeleteButton();
end


-- ****************************************************************************
-- Resets the selected profile.
-- ****************************************************************************
local function GeneralTab_ResetProfile()
 local controls = tabFrames.general.controls;

 MSBTProfiles.ResetProfile(controls.profileDropdown:GetSelectedID());
 GeneralTab_Populate();
end


-- ****************************************************************************
-- Deletes the selected profile.
-- ****************************************************************************
local function GeneralTab_DeleteProfile()
 local controls = tabFrames.general.controls;

 local dropdown = controls.profileDropdown;
 local profileName = dropdown:GetSelectedID();
 MSBTProfiles.DeleteProfile(profileName);
 dropdown:RemoveItem(profileName);

 dropdown:SetSelectedID(DEFAULT_PROFILE_NAME);
 GeneralTab_Populate();
 GeneralTab_ToggleDeleteButton();
end


-- ****************************************************************************
-- Saves the font settings selected by the user.
-- ****************************************************************************
local function GeneralTab_SaveFontSettings(fontSettings)
 -- Normal font settings.
 MSBTProfiles.SetOption(nil, "normalFontName", fontSettings.normalFontName);
 MSBTProfiles.SetOption(nil, "normalOutlineIndex", fontSettings.normalOutlineIndex);
 MSBTProfiles.SetOption(nil, "normalFontSize", fontSettings.normalFontSize);
 MSBTProfiles.SetOption(nil, "normalFontAlpha", fontSettings.normalFontAlpha); 
 
 -- Crit font settings.
 MSBTProfiles.SetOption(nil, "critFontName", fontSettings.critFontName);
 MSBTProfiles.SetOption(nil, "critOutlineIndex", fontSettings.critOutlineIndex);
 MSBTProfiles.SetOption(nil, "critFontSize", fontSettings.critFontSize);
 MSBTProfiles.SetOption(nil, "critFontAlpha", fontSettings.critFontAlpha); 
end


-- ****************************************************************************
-- Creates the general tab frame contents.
-- ****************************************************************************
local function GeneralTab_Create()
 local tabFrame = tabFrames.general;
 tabFrame.controls = {};
 local controls = tabFrame.controls;
 
 -- Enable checkbox.
 local checkbox = MSBTControls.CreateCheckbox(tabFrame);
 local objLocale = L.CHECKBOXES["enableMSBT"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 5, -5);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOptionUserDisabled(not isChecked);
   end
 );
 controls.enableCheckbox = checkbox;


 -- Profile dropdown.
 local dropdown =  MSBTControls.CreateDropdown(tabFrame);
 objLocale = L.DROPDOWNS["profile"];
 dropdown:Configure(180, objLocale.label, objLocale.tooltip);
 dropdown:SetPoint("TOPLEFT", checkbox, "BOTTOMLEFT", 0, -30);
 dropdown:SetChangeHandler(
  function (this, id)
   MSBTProfiles.SelectProfile(id);
   GeneralTab_Populate();
   GeneralTab_ToggleDeleteButton();
  end
 );
 controls.profileDropdown = dropdown;

 
 -- Copy profile button.
 local button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["copyProfile"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 0, -20);
 button:SetClickHandler(
   function (this)
    local objLocale = L.EDITBOXES["copyProfile"];
    EraseTable(configTable);
    configTable.defaultText = L.MSG_NEW_PROFILE;
    configTable.editboxLabel = objLocale.label;
    configTable.editboxTooltip = objLocale.tooltip
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = this;
    configTable.validateHandler = GeneralTab_ValidateProfileName;
    configTable.saveHandler = GeneralTab_CopyProfile;
    configTable.hideHandler = GeneralTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowInput(configTable);
   end
 );
 controls.copyProfileButton = button;

 -- Reset profile button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["resetProfile"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("LEFT", controls.copyProfileButton, "RIGHT", 10, 0);
 button:SetClickHandler(
   function (this)
    EraseTable(configTable);
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = this;
    configTable.acknowledgeHandler = GeneralTab_ResetProfile;
    configTable.hideHandler = GeneralTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowAcknowledge(configTable);
   end
 );
 controls.resetProfileButton = button;
 
 -- Delete profile button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["deleteProfile"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("LEFT", controls.resetProfileButton, "RIGHT", 10, 0);
 button:SetClickHandler(
   function (this)
    EraseTable(configTable);
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = this;
    configTable.anchorPoint = "TOPRIGHT";
    configTable.relativePoint = "BOTTOMRIGHT";
    configTable.acknowledgeHandler = GeneralTab_DeleteProfile;
    configTable.hideHandler = GeneralTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowAcknowledge(configTable);
   end
 );
 controls.deleteProfileButton = button;
 

 -- Animation speed slider.
 local slider = MSBTControls.CreateSlider(tabFrame);
 objLocale = L.SLIDERS["animationSpeed"]; 
 slider:Configure(180, objLocale.label, objLocale.tooltip);
 slider:SetPoint("TOPLEFT", controls.copyProfileButton, "BOTTOMLEFT", 0, -45);
 slider:SetMinMaxValues(20, 250);
 slider:SetValueStep(10);
 slider:SetValueChangedHandler(
   function(this, value)
     MSBTProfiles.SetOption(nil, "animationSpeed", value);
   end
 );
 controls.animationSpeedSlider = slider;

 
 -- Enable sounds checkbox.
 checkbox = MSBTControls.CreateCheckbox(tabFrame);
 objLocale = L.CHECKBOXES["enableSounds"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("BOTTOMRIGHT", tabFrame, "BOTTOMRIGHT", -10, 15);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "soundsDisabled", not isChecked);
   end
 );
 controls.enableSoundsCheckbox = checkbox;

 -- Game healing checkbox.
 checkbox = MSBTControls.CreateCheckbox(tabFrame);
 objLocale = L.CHECKBOXES["gameHealing"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("BOTTOMRIGHT", controls.enableSoundsCheckbox, "TOPRIGHT", 0, 0);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "gameHealingEnabled", isChecked);
    MSBTProfiles.UpdateGameOptions();
   end
 );
 controls.gameHealingCheckbox = checkbox;
 
 -- Game damage checkbox.
 checkbox = MSBTControls.CreateCheckbox(tabFrame);
 objLocale = L.CHECKBOXES["gameDamage"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("BOTTOMRIGHT", controls.gameHealingCheckbox, "TOPRIGHT", 0, 0);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "gameDamageEnabled", isChecked);
    MSBTProfiles.UpdateGameOptions();
   end
 );
 controls.gameDamageCheckbox = checkbox;

 -- Sticky crits checkbox.
 checkbox = MSBTControls.CreateCheckbox(tabFrame);
 objLocale = L.CHECKBOXES["stickyCrits"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("BOTTOMRIGHT", controls.gameDamageCheckbox, "TOPRIGHT", 0, 0);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "stickyCritsDisabled", not isChecked);
   end
 );
 controls.stickyCritsCheckbox = checkbox;
 


  -- Damage colors button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["damageColors"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", tabFrame, "BOTTOMLEFT", 5, 15);
 button:SetClickHandler(
   function (this)
    EraseTable(configTable);
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = this;
    configTable.anchorPoint = "BOTTOMLEFT";
    configTable.relativePoint = "TOPLEFT";
    configTable.hideHandler = GeneralTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowDamageColors(configTable);
   end
 );
 controls.damageColorsButton = button;

 -- Partial effects button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["partialEffects"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", controls.damageColorsButton, "TOPLEFT", 0, 10);
 button:SetClickHandler(
   function (this)
    EraseTable(configTable);
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = this;
    configTable.anchorPoint = "BOTTOMLEFT";
    configTable.relativePoint = "TOPLEFT";
    configTable.hideHandler = GeneralTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowPartialEffects(configTable);
   end
 );
 controls.partialEffectsButton = button;

 -- Master font settings button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["masterFont"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", controls.partialEffectsButton, "TOPLEFT", 0, 10);
 button:SetClickHandler(
   function (this)
    EraseTable(configTable);
    configTable.title = objLocale.label;

    local fontName = MSBTProfiles.currentProfile.normalFontName;
    if (not MSBTAnimations.fonts[fontName]) then fontName = DEFAULT_FONT_NAME; end
    configTable.normalFontName = fontName;
    configTable.normalOutlineIndex = MSBTProfiles.currentProfile.normalOutlineIndex;
    configTable.normalFontSize = MSBTProfiles.currentProfile.normalFontSize;
    configTable.normalFontAlpha = MSBTProfiles.currentProfile.normalFontAlpha;

    fontName = MSBTProfiles.currentProfile.critFontName;
    if (not MSBTAnimations.fonts[fontName]) then fontName = DEFAULT_FONT_NAME; end
    configTable.critFontName = fontName;
    configTable.critOutlineIndex = MSBTProfiles.currentProfile.critOutlineIndex;
    configTable.critFontSize = MSBTProfiles.currentProfile.critFontSize;
    configTable.critFontAlpha = MSBTProfiles.currentProfile.critFontAlpha;
    configTable.hideInherit = true;
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = tabFrame;
    configTable.anchorPoint = "BOTTOM";
    configTable.relativePoint = "BOTTOM";
    configTable.saveHandler = GeneralTab_SaveFontSettings;
    configTable.hideHandler = GeneralTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowFont(configTable);
   end
 );
 controls.masterFontButton = button;


 -- Populate the available profiles and select the current profile by default.
 local currentProfileName;
 for profileName, profile in pairs(MSBTProfiles.savedVariables.profiles) do
  dropdown:AddItem(profileName, profileName);
  if (profile == MSBTProfiles.currentProfile) then currentProfileName = profileName; end
 end
 dropdown:SetSelectedID(currentProfileName);
 dropdown:Sort();
 GeneralTab_ToggleDeleteButton();
 
 tabFrame.created = true;
end


-- ****************************************************************************
-- Called when the tab frame is shown.
-- ****************************************************************************
local function GeneralTab_OnShow()
 if (not tabFrames.general.created) then GeneralTab_Create(); end

  -- Set the frame up to populate the profile options when it is shown.
 GeneralTab_Populate();
end


-------------------------------------------------------------------------------
-- Scroll areas tab functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Enables the controls on the scroll areas tab.
-- ****************************************************************************
local function ScrollAreasTab_EnableControls()
 for name, frame in pairs(tabFrames.scrollAreas.controls) do
  if (frame.Enable) then frame:Enable(); end
 end

 -- Refresh listbox so the default scroll area delete buttons are disabled.
 tabFrames.scrollAreas.controls.scrollAreasListbox:Refresh();
end


-- ****************************************************************************
-- Validates if the passed scroll area does not already exist and is valid.
-- ****************************************************************************
local function ScrollAreasTab_ValidateScrollAreaName(scrollAreaName)
 if (not scrollAreaName or scrollAreaName == "") then
  return L.MSG_INVALID_SCROLL_AREA_NAME;
 end

 for saKey, saSettings in pairs(MSBTAnimations.scrollAreas) do
  if (saSettings.name == scrollAreaName) then return L.MSG_SCROLL_AREA_ALREADY_EXISTS; end
 end
end


-- ****************************************************************************
-- Adds a new scroll area with the passed scroll area name.
-- ****************************************************************************
local function ScrollAreasTab_AddScrollArea(settings)
 local nextAvailable = 1;
 while (MSBTProfiles.currentProfile.scrollAreas["Custom" .. nextAvailable]) do
  nextAvailable = nextAvailable + 1;
 end
 
 local newKey = "Custom" .. nextAvailable;
 local saSettings = {};
 saSettings.name = settings.inputText;
 MSBTProfiles.SetOption("scrollAreas", newKey, saSettings);
 MSBTAnimations.UpdateScrollAreas();
 tabFrames.scrollAreas.controls.scrollAreasListbox:AddItem(newKey, true);
end


-- ****************************************************************************
-- Called when one of the enable scroll area checkboxes is clicked.
-- ****************************************************************************
local function ScrollAreasTab_EnableOnClick(this, isChecked)
 local line = this:GetParent();
 MSBTProfiles.SetOption("scrollAreas." .. line.scrollAreaKey, "disabled", not isChecked);
 MSBTAnimations.UpdateScrollAreas();
end


-- ****************************************************************************
-- Changes the passed scroll area to the passed name.
-- ****************************************************************************
local function ScrollAreasTab_ChangeScrollAreaName(settings)
 MSBTProfiles.SetOption("scrollAreas." .. settings.saveArg1, "name", settings.inputText);
 MSBTAnimations.UpdateScrollAreas();
 tabFrames.scrollAreas.controls.scrollAreasListbox:Refresh();
end


-- ****************************************************************************
-- Called when one of the edit scroll area name buttons is clicked.
-- ****************************************************************************
local function ScrollAreasTab_EditNameButtonOnClick(this)
  local saKey = this:GetParent().scrollAreaKey;
  local objLocale = L.EDITBOXES["scrollAreaName"];
  EraseTable(configTable);
  configTable.defaultText = MSBTProfiles.currentProfile.scrollAreas[saKey].name;
  configTable.editboxLabel = objLocale.label;
  configTable.editboxTooltip = objLocale.tooltip
  configTable.parentFrame = tabFrames.scrollAreas;
  configTable.anchorFrame = this;
  configTable.anchorPoint = this:GetParent().lineNumber > 5 and "BOTTOMRIGHT" or "TOPRIGHT";
  configTable.relativePoint = this:GetParent().lineNumber > 5 and "TOPRIGHT" or "BOTTOMRIGHT";
  configTable.validateHandler = ScrollAreasTab_ValidateScrollAreaName;
  configTable.saveHandler = ScrollAreasTab_ChangeScrollAreaName;
  configTable.saveArg1 = saKey;
  configTable.hideHandler = ScrollAreasTab_EnableControls;
  DisableControls(tabFrames.scrollAreas.controls);
  MSBTPopups.ShowInput(configTable);
end


-- ****************************************************************************
-- Deletes the scroll area for the passed line and removes the line.
-- ****************************************************************************
local function ScrollAreasTab_DeleteScrollArea(line)
 MSBTProfiles.SetOption("scrollAreas", line.scrollAreaKey, nil);
 tabFrames.scrollAreas.controls.scrollAreasListbox:RemoveItem(line.itemNumber);
 MSBTAnimations.UpdateScrollAreas();
end


-- ****************************************************************************
-- Called when one of the delete scroll area buttons is clicked.
-- ****************************************************************************
local function ScrollAreasTab_DeleteButtonOnClick(this)
 EraseTable(configTable);
 configTable.parentFrame = tabFrames.scrollAreas;
 configTable.anchorFrame = this;
 configTable.anchorPoint = this:GetParent().lineNumber > 5 and "BOTTOMRIGHT" or "TOPRIGHT";
 configTable.relativePoint = this:GetParent().lineNumber > 5 and "TOPRIGHT" or "BOTTOMRIGHT";
 configTable.acknowledgeHandler = ScrollAreasTab_DeleteScrollArea;
 configTable.saveArg1 = this:GetParent();
 configTable.hideHandler = ScrollAreasTab_EnableControls;
 DisableControls(tabFrames.scrollAreas.controls);
 MSBTPopups.ShowAcknowledge(configTable);
end


-- ****************************************************************************
-- Saves the font settings selected by the user.
-- ****************************************************************************
local function ScrollAreasTab_SaveFontSettings(fontSettings, scrollAreaKey)
 -- Normal font settings.
 MSBTProfiles.SetOption("scrollAreas." .. scrollAreaKey, "normalFontName", fontSettings.normalFontName);
 MSBTProfiles.SetOption("scrollAreas." .. scrollAreaKey, "normalOutlineIndex", fontSettings.normalOutlineIndex);
 MSBTProfiles.SetOption("scrollAreas." .. scrollAreaKey, "normalFontSize", fontSettings.normalFontSize);
 MSBTProfiles.SetOption("scrollAreas." .. scrollAreaKey, "normalFontAlpha", fontSettings.normalFontAlpha); 
 
 -- Crit font settings.
 MSBTProfiles.SetOption("scrollAreas." .. scrollAreaKey, "critFontName", fontSettings.critFontName);
 MSBTProfiles.SetOption("scrollAreas." .. scrollAreaKey, "critOutlineIndex", fontSettings.critOutlineIndex);
 MSBTProfiles.SetOption("scrollAreas." .. scrollAreaKey, "critFontSize", fontSettings.critFontSize);
 MSBTProfiles.SetOption("scrollAreas." .. scrollAreaKey, "critFontAlpha", fontSettings.critFontAlpha);
 
 MSBTAnimations.UpdateScrollAreas();
end


-- ****************************************************************************
-- Called when one of the font settings buttons is clicked.
-- ****************************************************************************
local function ScrollAreasTab_FontButtonOnClick(this)
 local saKey = this:GetParent().scrollAreaKey;
 local saSettings = MSBTProfiles.currentProfile.scrollAreas[saKey];
 local fonts = MSBTAnimations.fonts;
 
 EraseTable(configTable);
 configTable.title = saSettings.name;
 local fontName = MSBTProfiles.currentProfile.normalFontName;
 if (not MSBTAnimations.fonts[fontName]) then fontName = DEFAULT_FONT_NAME; end
 configTable.inheritedNormalFontName = fontName;
 configTable.inheritedNormalOutlineIndex = MSBTProfiles.currentProfile.normalOutlineIndex;
 configTable.inheritedNormalFontSize = MSBTProfiles.currentProfile.normalFontSize;
 configTable.inheritedNormalFontAlpha = MSBTProfiles.currentProfile.normalFontAlpha;

 fontName = MSBTProfiles.currentProfile.critFontName;
 if (not MSBTAnimations.fonts[fontName]) then fontName = DEFAULT_FONT_NAME; end
 configTable.inheritedCritFontName = fontName;
 configTable.inheritedCritFontName = MSBTProfiles.currentProfile.critFontName;
 configTable.inheritedCritOutlineIndex = MSBTProfiles.currentProfile.critOutlineIndex;
 configTable.inheritedCritFontSize = MSBTProfiles.currentProfile.critFontSize;
 configTable.inheritedCritFontAlpha = MSBTProfiles.currentProfile.critFontAlpha;

 fontName = saSettings.normalFontName;
 if (not MSBTAnimations.fonts[fontName]) then fontName = nil; end
 configTable.normalFontName = fontName;
 configTable.normalOutlineIndex = saSettings.normalOutlineIndex;
 configTable.normalFontSize = saSettings.normalFontSize;
 configTable.normalFontAlpha = saSettings.normalFontAlpha;

 fontName = saSettings.critFontName;
 if (not MSBTAnimations.fonts[fontName]) then fontName = nil; end
 configTable.critFontName = fontName;
 configTable.critOutlineIndex = saSettings.critOutlineIndex;
 configTable.critFontSize = saSettings.critFontSize;
 configTable.critFontAlpha = saSettings.critFontAlpha;
 
 configTable.parentFrame = tabFrames.scrollAreas;
 configTable.anchorFrame = tabFrames.scrollAreas;
 configTable.anchorPoint = "BOTTOM";
 configTable.relativePoint = "BOTTOM";
 configTable.saveHandler = ScrollAreasTab_SaveFontSettings;
 configTable.saveArg1 = saKey;
 configTable.hideHandler = ScrollAreasTab_EnableControls;
 DisableControls(tabFrames.scrollAreas.controls);
 MSBTPopups.ShowFont(configTable);
end


-- ****************************************************************************
-- Called by listbox to create a line for scroll areas.
-- ****************************************************************************
local function ScrollAreasTab_CreateLine(this)
 local controls = tabFrames.scrollAreas.controls;
 
 local frame = CreateFrame("Button", nil, this);
 frame:EnableMouse(false);

 -- Enable checkbox.
 local checkbox = MSBTControls.CreateCheckbox(frame);
 local objLocale = L.CHECKBOXES["enableScrollArea"];
 checkbox:Configure(24, nil, objLocale.tooltip);
 checkbox:SetPoint("LEFT", frame, "LEFT", 5, 0);
 checkbox:SetClickHandler(ScrollAreasTab_EnableOnClick);
 frame.enableCheckbox = checkbox;
 controls[#controls+1] = checkbox;

 -- Delete scroll area button. 
 button = MSBTControls.CreateIconButton(frame, "Delete");
 objLocale = L.BUTTONS["deleteScrollArea"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", frame, "RIGHT", -10, 0);
 button:SetClickHandler(ScrollAreasTab_DeleteButtonOnClick);
 frame.deleteButton = button;
 controls[#controls+1] = button;

 -- Edit scroll area name button. 
 local button = MSBTControls.CreateIconButton(frame, "Configure");
 objLocale = L.BUTTONS["editScrollAreaName"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", controls[#controls], "LEFT", 0, 0);
 button:SetClickHandler(ScrollAreasTab_EditNameButtonOnClick);
 controls[#controls+1] = button;

 
 -- Scroll area font settings button. 
 button = MSBTControls.CreateIconButton(frame, "FontSettings");
 objLocale = L.BUTTONS["scrollAreaFontSettings"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", controls[#controls], "LEFT", 0, 0);
 button:SetClickHandler(ScrollAreasTab_FontButtonOnClick);
 controls[#controls+1] = button;

 return frame;
end


-- ****************************************************************************
-- Called by listbox to display a line.
-- ****************************************************************************
local function ScrollAreasTab_DisplayLine(this, line, key, isSelected)
 local saSettings = MSBTProfiles.currentProfile.scrollAreas[key];
 line.scrollAreaKey = key;
 line.enableCheckbox:SetLabel(saSettings.name);
 line.enableCheckbox:SetChecked(not saSettings.disabled);
 
 -- Disable the delete button for the default scroll areas.
 if (MSBTProfiles.masterProfile.scrollAreas[key]) then
  line.deleteButton:Disable();
 else
  line.deleteButton:Enable();
 end
end


-- ****************************************************************************
-- Creates the scroll areas tab frame contents.
-- ****************************************************************************
local function ScrollAreasTab_Create()
 local tabFrame = tabFrames.scrollAreas;
 tabFrame.controls = {};
 local controls = tabFrame.controls;
 
 -- Horizontal bar.
 local texture = tabFrame:CreateTexture(nil, "ARTWORK");
 texture:SetTexture("Interface\\PaperDollInfoFrame\\SkillFrame-BotLeft");
 texture:SetHeight(4);
 texture:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 0, -45);
 texture:SetPoint("TOPRIGHT", tabFrame, "TOPRIGHT", 0, -45);
 texture:SetTexCoord(0.078125, 1, 0.59765625, 0.61328125);

 -- Add scroll area button.
 local button = MSBTControls.CreateOptionButton(tabFrame);
 local objLocale = L.BUTTONS["addScrollArea"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", texture, "TOPLEFT", 5, 15);
 button:SetClickHandler(
   function (this)
    objLocale = L.EDITBOXES["scrollAreaName"];
    EraseTable(configTable);
    configTable.defaultText = L.MSG_NEW_SCROLL_AREA;
    configTable.editboxLabel = objLocale.label;
    configTable.editboxTooltip = objLocale.tooltip
    configTable.parentFrame = tabFrames.scrollAreas;
    configTable.anchorFrame = this;
    configTable.validateHandler = ScrollAreasTab_ValidateScrollAreaName;
    configTable.saveHandler = ScrollAreasTab_AddScrollArea;
    configTable.hideHandler = ScrollAreasTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowInput(configTable);
   end
 );
 controls.addScrollAreaButton = button;
 
 -- Configure scroll areas button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["configScrollAreas"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMRIGHT", texture, "TOPRIGHT", -5, 15);
 button:SetClickHandler(
   function (this)
	MSBTOptMain.HideMainFrame();
	MSBTPopups.ShowScrollAreaConfig();
   end
 );
 controls.configScrollAreasButton = button;
 
 -- Scroll areas listbox. 
 local listbox = MSBTControls.CreateListbox(tabFrame);
 listbox:Configure(400, 300, 25);
 listbox:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 0, -50);
 listbox:SetCreateLineHandler(ScrollAreasTab_CreateLine);
 listbox:SetDisplayHandler(ScrollAreasTab_DisplayLine);
 controls.scrollAreasListbox = listbox;
 
 -- Reusable table for scroll areas.
 tabFrame.scrollAreasTable = {};

 tabFrame.created = true;
end


-- ****************************************************************************
-- Called when the tab frame is shown.
-- ****************************************************************************
local function ScrollAreasTab_OnShow()
 if (not tabFrames.scrollAreas.created) then ScrollAreasTab_Create(); end

 -- Set the frame up to populate the profile options when it is shown.
 local listbox = tabFrames.scrollAreas.controls.scrollAreasListbox;

 local scrollAreasTable = tabFrames.scrollAreas.scrollAreasTable;
 EraseTable(scrollAreasTable);
 for saKey, saSettings in pairs(MSBTAnimations.scrollAreas) do
  scrollAreasTable[saKey] = saSettings.name;
 end
 local sortedKeys = SortKeysByValue(scrollAreasTable);

 local previousOffset = listbox:GetOffset();
 listbox:Clear();
 for _, key in ipairs(sortedKeys) do
  listbox:AddItem(key);
 end
 listbox:SetOffset(previousOffset);
end


-------------------------------------------------------------------------------
-- Events tab functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Sets up an event with the passed event type and codes.
-- ****************************************************************************
local function EventsTab_SetupEvent(event, eventType, codes)
 event.eventType = eventType;
 event.codes = codes;
end


-- ****************************************************************************
-- Sets up the event category entries with their associated event types and
-- codes.
-- ****************************************************************************
local function EventsTab_SetupEvents()
 local c = L.EVENT_CODES;
 local obj = L.INCOMING_PLAYER_EVENTS;
 EventsTab_SetupEvent(obj[1], "INCOMING_DAMAGE", c.DAMAGE_TAKEN .. c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[2], "INCOMING_DAMAGE_CRIT", c.DAMAGE_TAKEN .. c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[3], "INCOMING_MISS", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[4], "INCOMING_DODGE", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[5], "INCOMING_PARRY", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[6], "INCOMING_BLOCK", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[7], "INCOMING_ABSORB", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[8], "INCOMING_IMMUNE", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[9], "INCOMING_SPELL_DAMAGE", c.DAMAGE_TAKEN .. c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_TAKEN);
 EventsTab_SetupEvent(obj[10], "INCOMING_SPELL_DAMAGE_CRIT", c.DAMAGE_TAKEN .. c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_TAKEN);
 EventsTab_SetupEvent(obj[11], "INCOMING_SPELL_DOT", c.DAMAGE_TAKEN .. c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_TAKEN);
 EventsTab_SetupEvent(obj[12], "INCOMING_SPELL_MISS", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[13], "INCOMING_SPELL_DODGE", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[14], "INCOMING_SPELL_PARRY", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[15], "INCOMING_SPELL_BLOCK", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[16], "INCOMING_SPELL_RESIST", c.ATTACKER_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[17], "INCOMING_SPELL_ABSORB", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[18], "INCOMING_SPELL_IMMUNE", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[19], "INCOMING_SPELL_REFLECT", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[20], "INCOMING_SPELL_INTERRUPT", c.ATTACKER_NAME .. c.SPELL_NAME);
 EventsTab_SetupEvent(obj[21], "INCOMING_HEAL", c.HEALING_TAKEN .. c.HEALER_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[22], "INCOMING_HEAL_CRIT", c.HEALING_TAKEN .. c.HEALER_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[23], "INCOMING_HOT", c.HEALING_TAKEN .. c.HEALER_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[24], "INCOMING_ENVIRONMENTAL", c.DAMAGE_TAKEN .. c.ENVIRONMENTAL_DAMAGE);

 obj = L.INCOMING_PET_EVENTS;
 EventsTab_SetupEvent(obj[1], "PET_INCOMING_DAMAGE", c.DAMAGE_TAKEN .. c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[2], "PET_INCOMING_DAMAGE_CRIT", c.DAMAGE_TAKEN .. c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[3], "PET_INCOMING_MISS", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[4], "PET_INCOMING_DODGE", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[5], "PET_INCOMING_PARRY", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[6], "PET_INCOMING_BLOCK", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[7], "PET_INCOMING_ABSORB", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[8], "PET_INCOMING_IMMUNE", c.ATTACKER_NAME);
 EventsTab_SetupEvent(obj[9], "PET_INCOMING_SPELL_DAMAGE", c.DAMAGE_TAKEN .. c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_TAKEN);
 EventsTab_SetupEvent(obj[10], "PET_INCOMING_SPELL_DAMAGE_CRIT", c.DAMAGE_TAKEN .. c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_TAKEN);
 EventsTab_SetupEvent(obj[11], "PET_INCOMING_SPELL_DOT", c.DAMAGE_TAKEN .. c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_TAKEN);
 EventsTab_SetupEvent(obj[12], "PET_INCOMING_SPELL_MISS", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[13], "PET_INCOMING_SPELL_DODGE", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[14], "PET_INCOMING_SPELL_PARRY", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[15], "PET_INCOMING_SPELL_BLOCK", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[16], "PET_INCOMING_SPELL_RESIST", c.ATTACKER_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[17], "PET_INCOMING_SPELL_ABSORB", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[18], "PET_INCOMING_SPELL_IMMUNE", c.ATTACKER_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[19], "PET_INCOMING_HEAL", c.HEALING_TAKEN .. c.HEALER_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[20], "PET_INCOMING_HEAL_CRIT", c.HEALING_TAKEN .. c.HEALER_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[21], "PET_INCOMING_HOT", c.HEALING_TAKEN .. c.HEALER_NAME .. c.SPELL_NAME .. c.SKILL_LONG);

 obj = L.OUTGOING_PLAYER_EVENTS;
 EventsTab_SetupEvent(obj[1], "OUTGOING_DAMAGE", c.DAMAGE_DONE .. c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[2], "OUTGOING_DAMAGE_CRIT", c.DAMAGE_DONE .. c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[3], "OUTGOING_MISS", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[4], "OUTGOING_DODGE", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[5], "OUTGOING_PARRY", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[6], "OUTGOING_BLOCK", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[7], "OUTGOING_ABSORB", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[8], "OUTGOING_IMMUNE", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[9], "OUTGOING_EVADE", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[10], "OUTGOING_SPELL_DAMAGE", c.DAMAGE_DONE .. c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_DONE);
 EventsTab_SetupEvent(obj[11], "OUTGOING_SPELL_DAMAGE_CRIT", c.DAMAGE_DONE .. c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_DONE);
 EventsTab_SetupEvent(obj[12], "OUTGOING_SPELL_DOT", c.DAMAGE_DONE .. c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_DONE);
 EventsTab_SetupEvent(obj[13], "OUTGOING_SPELL_MISS", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[14], "OUTGOING_SPELL_DODGE", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[15], "OUTGOING_SPELL_PARRY", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[16], "OUTGOING_SPELL_BLOCK", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[17], "OUTGOING_SPELL_RESIST", c.ATTACKED_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[18], "OUTGOING_SPELL_ABSORB", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[19], "OUTGOING_SPELL_IMMUNE", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[20], "OUTGOING_SPELL_REFLECT", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[21], "OUTGOING_SPELL_INTERRUPT", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[22], "OUTGOING_SPELL_EVADE", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[23], "OUTGOING_HEAL", c.HEALING_DONE .. c.HEALED_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[24], "OUTGOING_HEAL_CRIT", c.HEALING_DONE .. c.HEALED_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[25], "OUTGOING_HOT", c.HEALING_DONE .. c.HEALED_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[26], "OUTGOING_DISPEL", c.BUFF_NAME .. c.SKILL_LONG);
 
 obj = L.OUTGOING_PET_EVENTS;
 EventsTab_SetupEvent(obj[1], "PET_OUTGOING_DAMAGE", c.DAMAGE_DONE .. c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[2], "PET_OUTGOING_DAMAGE_CRIT", c.DAMAGE_DONE .. c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[3], "PET_OUTGOING_MISS", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[4], "PET_OUTGOING_DODGE", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[5], "PET_OUTGOING_PARRY", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[6], "PET_OUTGOING_BLOCK", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[7], "PET_OUTGOING_ABSORB", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[8], "PET_OUTGOING_IMMUNE", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[9], "PET_OUTGOING_EVADE", c.ATTACKED_NAME);
 EventsTab_SetupEvent(obj[10], "PET_OUTGOING_SPELL_DAMAGE", c.DAMAGE_DONE .. c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_DONE);
 EventsTab_SetupEvent(obj[11], "PET_OUTGOING_SPELL_DAMAGE_CRIT", c.DAMAGE_DONE .. c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_DONE);
 EventsTab_SetupEvent(obj[12], "PET_OUTGOING_SPELL_DOT", c.DAMAGE_DONE .. c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG .. c.DAMAGE_TYPE_DONE);
 EventsTab_SetupEvent(obj[13], "PET_OUTGOING_SPELL_MISS", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[14], "PET_OUTGOING_SPELL_DODGE", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[15], "PET_OUTGOING_SPELL_PARRY", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[16], "PET_OUTGOING_SPELL_BLOCK", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[17], "PET_OUTGOING_SPELL_RESIST", c.ATTACKED_NAME .. c.SPELL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[18], "PET_OUTGOING_SPELL_ABSORB", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[19], "PET_OUTGOING_SPELL_IMMUNE", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[20], "PET_OUTGOING_SPELL_EVADE", c.ATTACKED_NAME .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[21], "PET_OUTGOING_DISPEL", c.BUFF_NAME .. c.SKILL_LONG);
 
 obj = L.NOTIFICATION_EVENTS;
 EventsTab_SetupEvent(obj[1], "NOTIFICATION_DEBUFF", c.DEBUFF_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[2], "NOTIFICATION_BUFF", c.BUFF_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[3], "NOTIFICATION_ITEM_BUFF", c.ITEM_BUFF_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[4], "NOTIFICATION_DEBUFF_FADE", c.DEBUFF_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[5], "NOTIFICATION_BUFF_FADE", c.BUFF_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[6], "NOTIFICATION_ITEM_BUFF_FADE", c.ITEM_BUFF_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[7], "NOTIFICATION_COMBAT_ENTER", "");
 EventsTab_SetupEvent(obj[8], "NOTIFICATION_COMBAT_LEAVE", "");
 EventsTab_SetupEvent(obj[9], "NOTIFICATION_POWER_GAIN", c.ENERGY_AMOUNT .. c.POWER_TYPE .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[10], "NOTIFICATION_POWER_LOSS", c.ENERGY_AMOUNT .. c.POWER_TYPE .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[11], "NOTIFICATION_CP_GAIN", c.CP_AMOUNT);
 EventsTab_SetupEvent(obj[12], "NOTIFICATION_CP_FULL", c.CP_AMOUNT);
 EventsTab_SetupEvent(obj[13], "NOTIFICATION_HONOR_GAIN", c.HONOR_AMOUNT);
 EventsTab_SetupEvent(obj[14], "NOTIFICATION_REP_GAIN", c.REP_AMOUNT);
 EventsTab_SetupEvent(obj[15], "NOTIFICATION_REP_LOSS", c.REP_AMOUNT);
 EventsTab_SetupEvent(obj[16], "NOTIFICATION_SKILL_GAIN", c.SKILL_AMOUNT .. c.SKILL_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[17], "NOTIFICATION_EXPERIENCE_GAIN", c.EXPERIENCE_AMOUNT);
 EventsTab_SetupEvent(obj[18], "NOTIFICATION_PC_KILLING_BLOW", c.UNIT_KILLED);
 EventsTab_SetupEvent(obj[19], "NOTIFICATION_NPC_KILLING_BLOW", c.UNIT_KILLED);
 EventsTab_SetupEvent(obj[20], "NOTIFICATION_SOUL_SHARD_CREATED", c.SHARD_NAME);
 EventsTab_SetupEvent(obj[21], "NOTIFICATION_EXTRA_ATTACK", c.EXTRA_ATTACKS .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[22], "NOTIFICATION_ENEMY_BUFF", c.BUFFED_NAME .. c.BUFF_NAME .. c.SKILL_LONG);
 EventsTab_SetupEvent(obj[23], "NOTIFICATION_MONSTER_EMOTE", c.EMOTE_TEXT);
 EventsTab_SetupEvent(obj[24], "NOTIFICATION_MONEY", c.MONEY_TEXT);
end


-- ****************************************************************************
-- Changes the event category to the passed value.
-- ****************************************************************************
local function EventsTab_ChangeEventCategory(category)
 local controls = tabFrames.events.controls;
 
 controls.eventsListbox:Clear();
 for index in ipairs(L[category]) do
  controls.eventsListbox:AddItem(index);
 end
end


-- ****************************************************************************
-- Enables the controls on the events tab.
-- ****************************************************************************
local function EventsTab_EnableControls()
 for name, frame in pairs(tabFrames.events.controls) do
  if (frame.Enable) then frame:Enable(); end
 end
end


-- ****************************************************************************
-- Moves all the events in the selected category to the passed scroll area.
-- ****************************************************************************
local function EventsTab_MoveAll(scrollArea)
 local events = L[tabFrames.events.controls.eventCategoryDropdown:GetSelectedID()];
 for index, eventData in ipairs(events) do
  MSBTProfiles.SetOption("events." .. eventData.eventType, "scrollArea", scrollArea);
 end
end


-- ****************************************************************************
-- Called when one of the event color swatches is changed.
-- ****************************************************************************
local function EventsTab_ColorswatchOnChanged(this)
 local eventType = this:GetParent().eventType;
 MSBTProfiles.SetOption("events." .. eventType, "colorR", this.r, 1);
 MSBTProfiles.SetOption("events." .. eventType, "colorG", this.g, 1);
 MSBTProfiles.SetOption("events." .. eventType, "colorB", this.b, 1);
end


-- ****************************************************************************
-- Called when one of the event enable checkboxes is clicked.
-- ****************************************************************************
local function EventsTab_EnableOnClick(this, isChecked)
 local eventType = this:GetParent().eventType;
 MSBTProfiles.SetOption("events." .. eventType, "disabled", not isChecked); 
end


-- ****************************************************************************
-- Saves the additional event settings selected by the user.
-- ****************************************************************************
local function EventsTab_SaveEventSettings(settings, eventType)
 MSBTProfiles.SetOption("events." .. eventType, "scrollArea", settings.scrollArea, DEFAULT_SCROLL_AREA);
 MSBTProfiles.SetOption("events." .. eventType, "message", settings.message);
 MSBTProfiles.SetOption("events." .. eventType, "alwaysSticky", settings.alwaysSticky);
 MSBTProfiles.SetOption("events." .. eventType, "soundFile", settings.soundFile, "");
 
 tabFrames.events.controls.eventsListbox:Refresh();
end


-- ****************************************************************************
-- Called when one of the event settings buttons is clicked.
-- ****************************************************************************
local function EventsTab_SettingsButtonOnClick(this)
 local eventType = this:GetParent().eventType;
 local eventSettings = MSBTProfiles.currentProfile.events[eventType];
 local categoryText = tabFrames.events.controls.eventCategoryDropdown:GetSelectedText();
 
 EraseTable(configTable);
 configTable.title =  categoryText .. " - " .. this:GetParent().enableCheckbox.fontString:GetText();
 configTable.message = eventSettings.message;
 configTable.codes = this:GetParent().codes;
 configTable.scrollArea = eventSettings.scrollArea or DEFAULT_SCROLL_AREA;
 configTable.alwaysSticky = eventSettings.alwaysSticky;
 configTable.soundFile = eventSettings.soundFile;
 configTable.isCrit = eventSettings.isCrit;
 configTable.parentFrame = tabFrames.events;
 configTable.anchorFrame = tabFrames.events;
 configTable.anchorPoint = "TOPRIGHT";
 configTable.relativePoint = "TOPRIGHT";
 configTable.saveHandler = EventsTab_SaveEventSettings;
 configTable.saveArg1 = eventType;
 configTable.hideHandler = EventsTab_EnableControls;
 DisableControls(tabFrames.events.controls);
 MSBTPopups.ShowEvent(configTable);
end


-- ****************************************************************************
-- Saves the font settings selected by the user.
-- ****************************************************************************
local function EventsTab_SaveFontSettings(settings, eventType)
 local isCrit = MSBTProfiles.currentProfile.events[eventType].isCrit;
 MSBTProfiles.SetOption("events." .. eventType, "fontName", isCrit and settings.critFontName or settings.normalFontName);
 MSBTProfiles.SetOption("events." .. eventType, "outlineIndex", isCrit and settings.critOutlineIndex or settings.normalOutlineIndex);
 MSBTProfiles.SetOption("events." .. eventType, "fontSize", isCrit and settings.critFontSize or settings.normalFontSize);
 MSBTProfiles.SetOption("events." .. eventType, "fontAlpha", isCrit and settings.critFontAlpha or settings.normalFontAlpha); 
end


-- ****************************************************************************
-- Called when one of the font settings buttons is clicked.
-- ****************************************************************************
local function EventsTab_FontButtonOnClick(this)
 local categoryText = tabFrames.events.controls.eventCategoryDropdown:GetSelectedText();
 local eventType = this:GetParent().eventType;
 local eventSettings = MSBTProfiles.currentProfile.events[eventType];

 local saKey = eventSettings.scrollArea;
 local saSettings = MSBTProfiles.currentProfile.scrollAreas[saKey];
 if (not saSettings) then saSettings = MSBTProfiles.currentProfile.scrollAreas[DEFAULT_SCROLL_AREA]; end
 local fonts = MSBTAnimations.fonts;
 
 EraseTable(configTable);
 configTable.title = categoryText .. " - " .. this:GetParent().enableCheckbox.fontString:GetText();
 
 local fontName;
 if (not eventSettings.isCrit) then
  -- Inherit from the correct scroll area.
  fontName = saSettings.normalFontName;
  if (not MSBTAnimations.fonts[fontName]) then fontName = MSBTProfiles.currentProfile.normalFontName; end
  if (not MSBTAnimations.fonts[fontName]) then fontName = DEFAULT_FONT_NAME; end
  configTable.inheritedNormalFontName = fontName;
  configTable.inheritedNormalOutlineIndex = saSettings.normalOutlineIndex or MSBTProfiles.currentProfile.normalOutlineIndex;
  configTable.inheritedNormalFontSize = saSettings.normalFontSize or MSBTProfiles.currentProfile.normalFontSize;
  configTable.inheritedNormalFontAlpha = saSettings.normalFontAlpha or MSBTProfiles.currentProfile.normalFontAlpha;

  fontName = eventSettings.fontName;
  if (not MSBTAnimations.fonts[fontName]) then fontName = nil; end
  configTable.normalFontName = fontName;
  configTable.normalOutlineIndex = eventSettings.outlineIndex;
  configTable.normalFontSize = eventSettings.fontSize;
  configTable.normalFontAlpha = eventSettings.fontAlpha;

  configTable.hideCrit = true;
 else
  -- Inherit from the correct scroll area.
  fontName = saSettings.critFontName;
  if (not MSBTAnimations.fonts[fontName]) then fontName = MSBTProfiles.currentProfile.critFontName; end
  if (not MSBTAnimations.fonts[fontName]) then fontName = DEFAULT_FONT_NAME; end
  configTable.inheritedCritFontName = fontName;
  configTable.inheritedCritOutlineIndex = saSettings.critOutlineIndex or MSBTProfiles.currentProfile.critOutlineIndex;
  configTable.inheritedCritFontSize = saSettings.critFontSize or MSBTProfiles.currentProfile.critFontSize;
  configTable.inheritedCritFontAlpha = saSettings.critFontAlpha or MSBTProfiles.currentProfile.critFontAlpha;

  fontName = eventSettings.fontName;
  if (not MSBTAnimations.fonts[fontName]) then fontName = nil; end
  configTable.critFontName = fontName;
  configTable.critOutlineIndex = eventSettings.outlineIndex;
  configTable.critFontSize = eventSettings.fontSize;
  configTable.critFontAlpha = eventSettings.fontAlpha;

  configTable.hideNormal = true;
 end

 configTable.parentFrame = tabFrames.events;
 configTable.anchorFrame = tabFrames.events;
 configTable.anchorPoint = "BOTTOM";
 configTable.relativePoint = "BOTTOM";
 configTable.saveHandler = EventsTab_SaveFontSettings;
 configTable.saveArg1 = eventType;
 configTable.hideHandler = EventsTab_EnableControls;
 DisableControls(tabFrames.events.controls);
 MSBTPopups.ShowFont(configTable);
end


-- ****************************************************************************
-- Called by listbox to create a line for events.
-- ****************************************************************************
local function EventsTab_CreateLine(this)
 local controls = tabFrames.events.controls;
 
 local frame = CreateFrame("Button", nil, this);
 frame:EnableMouse(false);
 
 -- Event colorswatch.
 local colorswatch = MSBTControls.CreateColorswatch(frame);
 colorswatch:SetPoint("LEFT", frame, "LEFT", 5, 0);
 colorswatch:SetColorChangedHandler(EventsTab_ColorswatchOnChanged);
 frame.colorSwatch = colorswatch;
 controls[#controls+1] = colorswatch;

 -- Enable checkbox.
 local checkbox = MSBTControls.CreateCheckbox(frame);
 checkbox:Configure(24, nil, nil);
 checkbox:SetPoint("LEFT", colorswatch, "RIGHT", 5, 0);
 checkbox:SetPoint("RIGHT", frame, "LEFT", 190, 0);
 checkbox:SetClickHandler(EventsTab_EnableOnClick);
 frame.enableCheckbox = checkbox;
 controls[#controls+1] = checkbox;
 
 -- Event settings button. 
 button = MSBTControls.CreateIconButton(frame, "Configure");
 objLocale = L.BUTTONS["eventSettings"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", frame, "RIGHT", -10, 0);
 button:SetClickHandler(EventsTab_SettingsButtonOnClick);
 controls[#controls+1] = button;

 -- Event font settings button. 
 button = MSBTControls.CreateIconButton(frame, "FontSettings");
 objLocale = L.BUTTONS["eventFontSettings"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", controls[#controls], "LEFT", 0, 0);
 button:SetClickHandler(EventsTab_FontButtonOnClick);
 controls[#controls+1] = button;

 -- Message font string.
 local fontString = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
 fontString:SetPoint("LEFT", checkbox, "RIGHT", 10, 0);
 fontString:SetPoint("RIGHT", button, "LEFT", -10, 0);
 fontString:SetJustifyH("LEFT");
 frame.messageFontString = fontString;


 return frame;
end


-- ****************************************************************************
-- Called by listbox to display a line.
-- ****************************************************************************
local function EventsTab_DisplayLine(this, line, key, isSelected)
 local events = L[tabFrames.events.controls.eventCategoryDropdown:GetSelectedID()];
 local eventType = events[key].eventType;
 local eventSettings = MSBTProfiles.currentProfile.events[eventType];
 local objLocale = events[key];
 line.eventType = eventType;
 line.codes = events[key].codes;

 line.colorSwatch:SetColor(eventSettings.colorR or 1, eventSettings.colorG or 1, eventSettings.colorB or 1);
 line.enableCheckbox:SetLabel(objLocale.label);
 line.enableCheckbox:SetTooltip(objLocale.tooltip);
 line.enableCheckbox:SetChecked(not eventSettings.disabled);
 line.messageFontString:SetText(eventSettings.message);
end


-- ****************************************************************************
-- Creates the scroll areas tab frame contents.
-- ****************************************************************************
local function EventsTab_Create()
 local tabFrame = tabFrames.events;
 tabFrame.controls = {};
 local controls = tabFrame.controls;
 
 -- Horizontal bar.
 local texture = tabFrame:CreateTexture(nil, "ARTWORK");
 texture:SetTexture("Interface\\PaperDollInfoFrame\\SkillFrame-BotLeft");
 texture:SetHeight(4);
 texture:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 0, -45);
 texture:SetPoint("TOPRIGHT", tabFrame, "TOPRIGHT", 0, -45);
 texture:SetTexCoord(0.078125, 1, 0.59765625, 0.61328125);

 -- Move all button.
 local button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["moveAll"];
 button:Configure(15, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", texture, "TOPLEFT", 5, 5);
 button:SetClickHandler(
  function (this)
   EraseTable(configTable);
   configTable.title = this:GetText() .. " - " .. controls.eventCategoryDropdown:GetSelectedText();
   configTable.parentFrame = tabFrame;
   configTable.anchorFrame = this;
   configTable.saveHandler = EventsTab_MoveAll;
   configTable.hideHandler = EventsTab_EnableControls;
   DisableControls(controls);
   MSBTPopups.ShowScrollAreaSelection(configTable);
  end
 );
 controls.moveButton = button;

 -- Toggle all button.
 local button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["toggleAll"];
 button:Configure(15, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", controls.moveButton, "TOPLEFT", 0, 10);
 button:SetClickHandler(
  function (this)
   local events = L[controls.eventCategoryDropdown:GetSelectedID()];
   for index, eventData in ipairs(events) do
    MSBTProfiles.SetOption("events." .. eventData.eventType, "disabled", not MSBTProfiles.currentProfile.events[eventData.eventType].disabled);
    controls.eventsListbox:Refresh();
   end
  end
 );
 controls.toggleButton = button;

 -- Event category dropdown.
 local dropdown = MSBTControls.CreateDropdown(tabFrame);
 objLocale = L.DROPDOWNS["eventCategory"];
 dropdown:Configure(180, objLocale.label, objLocale.tooltip);
 dropdown:SetPoint("BOTTOMRIGHT", texture, "TOPRIGHT", -5, 8);
 dropdown:SetChangeHandler(
   function (this, id)
    EventsTab_ChangeEventCategory(id);
   end
 );
 controls.eventCategoryDropdown = dropdown;

 -- Events listbox. 
 local listbox = MSBTControls.CreateListbox(tabFrame);
 listbox:Configure(400, 300, 25);
 listbox:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 0, -50);
 listbox:SetCreateLineHandler(EventsTab_CreateLine);
 listbox:SetDisplayHandler(EventsTab_DisplayLine);
 controls.eventsListbox = listbox;


 -- Setup the events for all categories.
 EventsTab_SetupEvents();

 -- Populate the available event categories and select incoming player by default.
 for index, category in ipairs(L.EVENT_CATEGORIES) do
  dropdown:AddItem(category, EVENT_CATEGORY_MAP[index]);
 end
 dropdown:SetSelectedID(EVENT_CATEGORY_MAP[1]);
 EventsTab_ChangeEventCategory(EVENT_CATEGORY_MAP[1]);
 
 tabFrame.created = true;
end


-- ****************************************************************************
-- Called when the tab frame is shown.
-- ****************************************************************************
local function EventsTab_OnShow()
 if (not tabFrames.events.created) then EventsTab_Create(); end

 -- Set the frame up to populate the profile options when it is shown.
 tabFrames.events.controls.eventsListbox:Refresh();
end


-------------------------------------------------------------------------------
-- Triggers tab functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Enables the controls on the triggers tab.
-- ****************************************************************************
local function TriggersTab_EnableControls()
 for name, frame in pairs(tabFrames.triggers.controls) do
  if (frame.Enable) then frame:Enable(); end
 end
end


-- ****************************************************************************
-- Adds a new trigger with the passed output message.
-- ****************************************************************************
local function TriggersTab_AddTrigger(settings)
 local nextAvailable = 1;
 while (MSBTProfiles.currentProfile.triggers["Custom" .. nextAvailable]) do
  nextAvailable = nextAvailable + 1;
 end
 
 local newKey = "Custom" .. nextAvailable;
 local triggerSettings = {};
 triggerSettings.message = settings.inputText;
 triggerSettings.alwaysSticky = true;
 triggerSettings.fontSize = 26;
 MSBTProfiles.SetOption("triggers", newKey, triggerSettings);
 MSBTTriggers.UpdateTriggers();
 tabFrames.triggers.controls.triggersListbox:AddItem(newKey, true);
end


-- ****************************************************************************
-- Called when one of the trigger color swatches is changed.
-- ****************************************************************************
local function TriggersTab_ColorswatchOnChanged(this)
 local triggerKey = this:GetParent().triggerKey;
 MSBTProfiles.SetOption("triggers." .. triggerKey, "colorR", this.r, 1);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "colorG", this.g, 1);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "colorB", this.b, 1);
 MSBTTriggers.UpdateTriggers();
end


-- ****************************************************************************
-- Called when one of the trigger enable checkboxes is clicked.
-- ****************************************************************************
local function TriggersTab_EnableOnClick(this, isChecked)
 local triggerKey = this:GetParent().triggerKey;
 MSBTProfiles.SetOption("triggers." .. triggerKey, "disabled", not isChecked); 
 MSBTTriggers.UpdateTriggers();
end


-- ****************************************************************************
-- Saves the trigger settings selected by the user.
-- ****************************************************************************
local function TriggersTab_SaveTriggerSettings(settings, triggerKey)
 MSBTProfiles.SetOption("triggers." .. triggerKey, "classes", settings.classes);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "mainEvents", settings.mainEvents);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "exceptions", settings.exceptions);
 MSBTTriggers.UpdateTriggers();
end


-- ****************************************************************************
-- Called when one of the trigger settings buttons is clicked.
-- ****************************************************************************
local function TriggersTab_TriggerSettingsButtonOnClick(this)
 local triggerKey = this:GetParent().triggerKey;
 local triggerSettings = MSBTProfiles.currentProfile.triggers[triggerKey];
 
 EraseTable(configTable);
 configTable.title =  this:GetParent().enableCheckbox.fontString:GetText();
 configTable.triggerKey = triggerKey;
 configTable.parentFrame = tabFrames.triggers;
 configTable.anchorFrame = tabFrames.triggers;
 configTable.anchorPoint = "RIGHT";
 configTable.relativePoint = "RIGHT";
 configTable.saveHandler = TriggersTab_SaveTriggerSettings;
 configTable.saveArg1 = triggerKey;
 configTable.hideHandler = TriggersTab_EnableControls;
 DisableControls(tabFrames.triggers.controls);
 MSBTPopups.ShowTrigger(configTable);
end


-- ****************************************************************************
-- Saves the font settings selected by the user.
-- ****************************************************************************
local function TriggersTab_SaveFontSettings(settings, triggerKey)
 MSBTProfiles.SetOption("triggers." .. triggerKey, "fontName", settings.normalFontName);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "outlineIndex", settings.normalOutlineIndex);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "fontSize", settings.normalFontSize);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "fontAlpha", settings.normalFontAlpha); 
 MSBTTriggers.UpdateTriggers();
end


-- ****************************************************************************
-- Called when one of the font settings buttons is clicked.
-- ****************************************************************************
local function TriggersTab_FontButtonOnClick(this)
 local triggerKey = this:GetParent().triggerKey;
 local triggerSettings = MSBTProfiles.currentProfile.triggers[triggerKey];

 local saKey = triggerSettings.scrollArea;
 local saSettings = MSBTProfiles.currentProfile.scrollAreas[saKey];
 if (not saSettings) then saSettings = MSBTProfiles.currentProfile.scrollAreas[DEFAULT_SCROLL_AREA]; end
 local fonts = MSBTAnimations.fonts;
 
 EraseTable(configTable);
 configTable.title = this:GetParent().enableCheckbox.fontString:GetText();
 
 local fontName;
 fontName = saSettings.normalFontName;
 if (not MSBTAnimations.fonts[fontName]) then fontName = MSBTProfiles.currentProfile.normalFontName; end
 if (not MSBTAnimations.fonts[fontName]) then fontName = DEFAULT_FONT_NAME; end
 configTable.inheritedNormalFontName = fontName;
 configTable.inheritedNormalOutlineIndex = saSettings.normalOutlineIndex or MSBTProfiles.currentProfile.normalOutlineIndex;
 configTable.inheritedNormalFontSize = saSettings.normalFontSize or MSBTProfiles.currentProfile.normalFontSize;
 configTable.inheritedNormalFontAlpha = saSettings.normalFontAlpha or MSBTProfiles.currentProfile.normalFontAlpha;

 fontName = triggerSettings.fontName;
 if (not MSBTAnimations.fonts[fontName]) then fontName = nil; end
 configTable.normalFontName = fontName;
 configTable.normalOutlineIndex = triggerSettings.outlineIndex;
 configTable.normalFontSize = triggerSettings.fontSize;
 configTable.normalFontAlpha = triggerSettings.fontAlpha;
 
 configTable.hideCrit = true;

 
 configTable.parentFrame = tabFrames.triggers;
 configTable.anchorFrame = tabFrames.triggers;
 configTable.anchorPoint = "BOTTOM";
 configTable.relativePoint = "BOTTOM";
 configTable.saveHandler = TriggersTab_SaveFontSettings;
 configTable.saveArg1 = triggerKey;
 configTable.hideHandler = TriggersTab_EnableControls;
 DisableControls(tabFrames.triggers.controls);
 MSBTPopups.ShowFont(configTable);
end


-- ****************************************************************************
-- Saves the additional event settings selected by the user.
-- ****************************************************************************
local function TriggersTab_SaveEventSettings(settings, triggerKey)
 MSBTProfiles.SetOption("triggers." .. triggerKey, "scrollArea", settings.scrollArea, DEFAULT_SCROLL_AREA);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "message", settings.message);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "alwaysSticky", settings.alwaysSticky);
 MSBTProfiles.SetOption("triggers." .. triggerKey, "soundFile", settings.soundFile, "");
 MSBTProfiles.SetOption("triggers." .. triggerKey, "iconSkill", settings.iconSkill, "");
 MSBTTriggers.UpdateTriggers();

 tabFrames.triggers.controls.triggersListbox:Refresh();
end


-- ****************************************************************************
-- Called when one of the event settings buttons is clicked.
-- ****************************************************************************
local function TriggersTab_EventSettingsButtonOnClick(this)
 local triggerKey = this:GetParent().triggerKey;
 local triggerSettings = MSBTProfiles.currentProfile.triggers[triggerKey];
 
 EraseTable(configTable);
 configTable.title =  this:GetParent().enableCheckbox.fontString:GetText();
 configTable.message = triggerSettings.message;
 configTable.scrollArea = triggerSettings.scrollArea or DEFAULT_SCROLL_AREA;
 configTable.alwaysSticky = triggerSettings.alwaysSticky;
 configTable.soundFile = triggerSettings.soundFile;
 configTable.showIconSkillEditbox = true;
 configTable.iconSkill = triggerSettings.iconSkill;
 configTable.parentFrame = tabFrames.triggers;
 configTable.anchorFrame = tabFrames.triggers;
 configTable.anchorPoint = "TOPRIGHT";
 configTable.relativePoint = "TOPRIGHT";
 configTable.saveHandler = TriggersTab_SaveEventSettings;
 configTable.saveArg1 = triggerKey;
 configTable.hideHandler = TriggersTab_EnableControls;
 DisableControls(tabFrames.triggers.controls);
 MSBTPopups.ShowEvent(configTable);
end


-- ****************************************************************************
-- Deletes the trigger for the passed line and removes the line.
-- ****************************************************************************
local function TriggersTab_DeleteTrigger(line)
 MSBTProfiles.SetOption("triggers", line.triggerKey, false);
 tabFrames.triggers.controls.triggersListbox:RemoveItem(line.itemNumber);
 MSBTTriggers.UpdateTriggers();
end


-- ****************************************************************************
-- Called when one of the delete buttons is clicked.
-- ****************************************************************************
local function TriggersTab_DeleteButtonOnClick(this)
 EraseTable(configTable);
 configTable.parentFrame = tabFrames.triggers;
 configTable.anchorFrame = this;
 configTable.anchorPoint = this:GetParent().lineNumber > 5 and "BOTTOMRIGHT" or "TOPRIGHT";
 configTable.relativePoint = this:GetParent().lineNumber > 5 and "TOPRIGHT" or "BOTTOMRIGHT";
 configTable.acknowledgeHandler = TriggersTab_DeleteTrigger;
 configTable.saveArg1 = this:GetParent();
 configTable.hideHandler = TriggersTab_EnableControls;
 DisableControls(tabFrames.triggers.controls);
 MSBTPopups.ShowAcknowledge(configTable);
end


-- ****************************************************************************
-- Called by listbox to create a line for triggers.
-- ****************************************************************************
local function TriggersTab_CreateLine(this)
 local controls = tabFrames.triggers.controls;
 
 local frame = CreateFrame("Button", nil, this);
 frame:EnableMouse(false);
 
 -- Event colorswatch.
 local colorswatch = MSBTControls.CreateColorswatch(frame);
 colorswatch:SetPoint("LEFT", frame, "LEFT", 5, 0);
 colorswatch:SetColorChangedHandler(TriggersTab_ColorswatchOnChanged);
 frame.colorSwatch = colorswatch;
 controls[#controls+1] = colorswatch;

 -- Enable checkbox.
 local checkbox = MSBTControls.CreateCheckbox(frame);
 local objLocale = L.CHECKBOXES["enableTrigger"];
 checkbox:Configure(24, nil, objLocale.tooltip);
 checkbox:SetPoint("LEFT", colorswatch, "RIGHT", 5, 0);
 checkbox:SetPoint("RIGHT", frame, "LEFT", 190, 0);
 checkbox:SetClickHandler(TriggersTab_EnableOnClick);
 frame.enableCheckbox = checkbox;
 controls[#controls+1] = checkbox;
 
 -- Delete trigger button. 
 button = MSBTControls.CreateIconButton(frame, "Delete");
 objLocale = L.BUTTONS["deleteTrigger"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", frame, "RIGHT", -10, 0);
 button:SetClickHandler(TriggersTab_DeleteButtonOnClick);
 controls[#controls+1] = button;

 -- Event settings button. 
 button = MSBTControls.CreateIconButton(frame, "Configure");
 objLocale = L.BUTTONS["eventSettings"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", controls[#controls], "LEFT", 0, 0);
 button:SetClickHandler(TriggersTab_EventSettingsButtonOnClick);
 controls[#controls+1] = button;

 -- Event font settings button. 
 button = MSBTControls.CreateIconButton(frame, "FontSettings");
 objLocale = L.BUTTONS["eventFontSettings"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", controls[#controls], "LEFT", 0, 0);
 button:SetClickHandler(TriggersTab_FontButtonOnClick);
 controls[#controls+1] = button;

 -- Trigger settings button. 
 button = MSBTControls.CreateIconButton(frame, "TriggerSettings");
 objLocale = L.BUTTONS["triggerSettings"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", controls[#controls], "LEFT", 0, 0);
 button:SetClickHandler(TriggersTab_TriggerSettingsButtonOnClick);
 controls[#controls+1] = button;

 return frame;
end


-- ****************************************************************************
-- Called by listbox to display a line.
-- ****************************************************************************
local function TriggersTab_DisplayLine(this, line, key, isSelected)
 local triggerSettings = MSBTProfiles.currentProfile.triggers[key];
 line.triggerKey = key;

 line.colorSwatch:SetColor(triggerSettings.colorR or 1, triggerSettings.colorG or 1, triggerSettings.colorB or 1);
 line.enableCheckbox:SetLabel(triggerSettings.message);
 line.enableCheckbox:SetChecked(not triggerSettings.disabled);
end


-- ****************************************************************************
-- Creates the triggers tab frame contents.
-- ****************************************************************************
local function TriggersTab_Create()
 local tabFrame = tabFrames.triggers;
 tabFrame.controls = {};
 local controls = tabFrame.controls;

 -- Horizontal bar.
 local texture = tabFrame:CreateTexture(nil, "ARTWORK");
 texture:SetTexture("Interface\\PaperDollInfoFrame\\SkillFrame-BotLeft");
 texture:SetHeight(4);
 texture:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 0, -45);
 texture:SetPoint("TOPRIGHT", tabFrame, "TOPRIGHT", 0, -45);
 texture:SetTexCoord(0.078125, 1, 0.59765625, 0.61328125);

 -- Add trigger button.
 local button = MSBTControls.CreateOptionButton(tabFrame);
 local objLocale = L.BUTTONS["addTrigger"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", texture, "TOPLEFT", 5, 15);
 button:SetClickHandler(
   function (this)
    objLocale = L.EDITBOXES["eventMessage"];
    EraseTable(configTable);
    configTable.defaultText = L.MSG_NEW_TRIGGER;
    configTable.editboxLabel = objLocale.label;
    configTable.editboxTooltip = objLocale.tooltip
    configTable.parentFrame = tabFrames.triggers;
    configTable.anchorFrame = this;
    configTable.saveHandler = TriggersTab_AddTrigger;
    configTable.hideHandler = TriggersTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowInput(configTable);
   end
 );
 controls.addTriggerButton = button;

 
 -- Triggers listbox. 
 local listbox = MSBTControls.CreateListbox(tabFrame);
 listbox:Configure(400, 300, 25);
 listbox:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 0, -50);
 listbox:SetCreateLineHandler(TriggersTab_CreateLine);
 listbox:SetDisplayHandler(TriggersTab_DisplayLine);
 controls.triggersListbox = listbox;
 
 -- Reusable table for triggers.
 tabFrame.triggerTable = {};
  
 tabFrame.created = true;
end


-- ****************************************************************************
-- Called when the tab frame is shown.
-- ****************************************************************************
local function TriggersTab_OnShow()
 if (not tabFrames.triggers.created) then TriggersTab_Create(); end

 -- Set the frame up to populate the profile options when it is shown.
 local triggersListbox = tabFrames.triggers.controls.triggersListbox;

 -- Get triggers from the current profile.
 local triggerTable = tabFrames.triggers.triggerTable;
 EraseTable(triggerTable);
 local currentProfileTriggers = rawget(MSBTProfiles.currentProfile, "triggers");
 if (currentProfileTriggers) then
  for triggerKey, triggerSettings in pairs(currentProfileTriggers) do
   if (triggerSettings) then triggerTable[triggerKey] = triggerSettings.message; end
  end
 end
 
 -- Get triggers available in the master profile that aren't in the current profile. 
 for triggerKey, triggerSettings in pairs(MSBTProfiles.masterProfile.triggers) do
  if (not currentProfileTriggers or rawget(currentProfileTriggers, triggerKey) == nil) then
   triggerTable[triggerKey] = triggerSettings.message;
  end
 end
 
 -- Set the frame up to populate the profile options when it is shown.
 local listbox = tabFrames.triggers.controls.triggersListbox;
 local sortedKeys = SortKeysByValue(triggerTable);
 
 local previousOffset = listbox:GetOffset();
 listbox:Clear();
 for _, key in ipairs(sortedKeys) do
  listbox:AddItem(key);
 end
 listbox:SetOffset(previousOffset);
end


-------------------------------------------------------------------------------
-- Spam tab functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Enables the controls on the spam tab.
-- ****************************************************************************
local function SpamTab_EnableControls()
 local controls = tabFrames.spam.controls;
 for name, frame in pairs(controls) do
  if (frame.Enable) then frame:Enable(); end
 end
end


-- ****************************************************************************
-- Creates the spam tab frame contents.
-- ****************************************************************************
local function SpamTab_Create()
 local tabFrame = tabFrames.spam;
 tabFrame.controls = {};
 local controls = tabFrame.controls;

 -- Heal threshold slider.
 local slider = MSBTControls.CreateSlider(tabFrame);
 objLocale = L.SLIDERS["healThreshold"];
 slider:Configure(150, objLocale.label, objLocale.tooltip);
 slider:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 5, -10);
 slider:SetMinMaxValues(0, 1000);
 slider:SetValueStep(20);
 slider:SetValueChangedHandler(
   function(this, value)
    MSBTProfiles.SetOption(nil, "healThreshold", value);
   end
 );
 controls.healSlider = slider;

 -- Damage threshold slider.
 slider = MSBTControls.CreateSlider(tabFrame);
 objLocale = L.SLIDERS["damageThreshold"];
 slider:Configure(150, objLocale.label, objLocale.tooltip);
 slider:SetPoint("TOPLEFT", controls.healSlider, "BOTTOMLEFT", 0, -10);
 slider:SetMinMaxValues(0, 500);
 slider:SetValueStep(10);
 slider:SetValueChangedHandler(
   function(this, value)
    MSBTProfiles.SetOption(nil, "damageThreshold", value);
   end
 );
 controls.damageSlider = slider;

 -- Power threshold slider.
 slider = MSBTControls.CreateSlider(tabFrame);
 objLocale = L.SLIDERS["powerThreshold"];
 slider:Configure(150, objLocale.label, objLocale.tooltip);
 slider:SetPoint("TOPLEFT", controls.damageSlider, "BOTTOMLEFT", 0, -10);
 slider:SetMinMaxValues(0, 250);
 slider:SetValueStep(5);
 slider:SetValueChangedHandler(
   function(this, value)
    MSBTProfiles.SetOption(nil, "powerThreshold", value);
   end
 );
 controls.powerSlider = slider;

 -- HoT throttling time slider.
 slider = MSBTControls.CreateSlider(tabFrame);
 objLocale = L.SLIDERS["hotThrottleTime"];
 slider:Configure(150, objLocale.label, objLocale.tooltip);
 slider:SetPoint("LEFT", controls.healSlider, "RIGHT", 40, 0);
 slider:SetMinMaxValues(0, 5);
 slider:SetValueStep(1);
 slider:SetValueChangedHandler(
   function(this, value)
    MSBTProfiles.SetOption(nil, "hotThrottleDuration", value);
   end
 );
 controls.hotThrottlingSlider = slider;

 -- DoT throttling time slider.
 slider = MSBTControls.CreateSlider(tabFrame);
 objLocale = L.SLIDERS["dotThrottleTime"];
 slider:Configure(150, objLocale.label, objLocale.tooltip);
 slider:SetPoint("TOPLEFT", controls.hotThrottlingSlider, "BOTTOMLEFT", 0, -10);
 slider:SetMinMaxValues(0, 5);
 slider:SetValueStep(1);
 slider:SetValueChangedHandler(
   function(this, value)
    MSBTProfiles.SetOption(nil, "dotThrottleDuration", value);
   end
 );
 controls.dotThrottlingSlider = slider;

 -- Power throttling time slider.
 slider = MSBTControls.CreateSlider(tabFrame);
 objLocale = L.SLIDERS["powerThrottleTime"];
 slider:Configure(150, objLocale.label, objLocale.tooltip);
 slider:SetPoint("TOPLEFT", controls.dotThrottlingSlider, "BOTTOMLEFT", 0, -10);
 slider:SetMinMaxValues(0, 5);
 slider:SetValueStep(1);
 slider:SetValueChangedHandler(
   function(this, value)
    MSBTProfiles.SetOption(nil, "powerThrottleDuration", value);
   end
 );
 controls.powerThrottlingSlider = slider;
 
 -- All power gains checkbox.
 local checkbox = MSBTControls.CreateCheckbox(tabFrame);
 local objLocale = L.CHECKBOXES["allPowerGains"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 5, -150);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "showAllPowerGains", isChecked);
   end
 );
 controls.allPowerCheckbox = checkbox;

 -- Hyper regen checkbox.
 checkbox = MSBTControls.CreateCheckbox(tabFrame);
 objLocale = L.CHECKBOXES["hyperRegen"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("TOPLEFT", controls.allPowerCheckbox, "BOTTOMLEFT", 0, 0);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "regenAbilitiesDisabled", not isChecked);
   end
 );
 controls.hyperRegenCheckbox = checkbox;

 -- Abbreviate skills checkbox.
 checkbox = MSBTControls.CreateCheckbox(tabFrame);
 objLocale = L.CHECKBOXES["abbreviateSkills"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("TOPLEFT", controls.hyperRegenCheckbox, "BOTTOMLEFT", 0, 0);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "abbreviateAbilities", isChecked);
   end
 );
 controls.abbreviateCheckbox = checkbox;
 
 -- Hide skills checkbox.
 checkbox = MSBTControls.CreateCheckbox(tabFrame);
 objLocale = L.CHECKBOXES["hideSkills"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("LEFT", controls.powerThrottlingSlider, "LEFT", 0, 0);
 checkbox:SetPoint("TOP", controls.allPowerCheckbox, "TOP", 0, 0);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "hideSkills", isChecked);
   end
 );
 controls.hideSkillsCheckbox = checkbox;

 -- Hide names checkbox.
 checkbox = MSBTControls.CreateCheckbox(tabFrame);
 objLocale = L.CHECKBOXES["hideNames"];
 checkbox:Configure(28, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("TOPLEFT", controls.hideSkillsCheckbox, "BOTTOMLEFT");
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "hideNames", isChecked);
   end
 );
 controls.hideNamesCheckbox = checkbox;
 
 -- Merge exclusions button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["mergeExclusions"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", tabFrame, "BOTTOMLEFT", 5, 15);
 button:SetClickHandler(
   function (this)
    local listName = "mergeExclusions";
    PopulateSkillList(listName);
    EraseTable(configTable);
    configTable.title = this:GetText();
    configTable.skills = skillsTable;
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = this;
    configTable.anchorPoint = "BOTTOMLEFT";
    configTable.relativePoint = "TOPLEFT";
    configTable.saveHandler = SaveSkillList;
    configTable.saveArg1 = listName;
    configTable.hideHandler = SpamTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowSkillList(configTable);
   end
 );
 controls.mergeExclusionsButton = button;

 -- Throttle list button.
 local button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["throttleList"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", controls.mergeExclusionsButton, "TOPLEFT", 0, 10);
 button:SetClickHandler(
   function (this)
    local listName = "throttleList";
    PopulateSkillList(listName);
    EraseTable(configTable);
    configTable.title = this:GetText();
    configTable.skills = skillsTable;
    configTable.listType = "throttle";
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = this;
    configTable.anchorPoint = "BOTTOMLEFT";
    configTable.relativePoint = "TOPLEFT";
    configTable.saveHandler = SaveSkillList;
    configTable.saveArg1 = listName;
    configTable.hideHandler = SpamTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowSkillList(configTable);
   end
 );
 controls.throttleListButton = button;

 -- Skill substitutions button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["skillSubstitutions"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMRIGHT", tabFrame, "BOTTOMRIGHT", -10, 15);
 button:SetClickHandler(
   function (this)
    local listName = "abilitySubstitutions";
    PopulateSkillList(listName);
    EraseTable(configTable);
    configTable.title = this:GetText();
    configTable.skills = skillsTable;
    configTable.listType = "substitution";
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = this;
    configTable.anchorPoint = "BOTTOMRIGHT";
    configTable.relativePoint = "TOPRIGHT";
    configTable.saveHandler = SaveSkillList;
    configTable.saveArg1 = listName;
    configTable.hideHandler = SpamTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowSkillList(configTable);
   end
 );
 controls.skillSubstitutionsButton = button;

 -- Skill suppressions button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["skillSuppressions"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("BOTTOMLEFT", controls.skillSubstitutionsButton, "TOPLEFT", 0, 10);
 button:SetClickHandler(
   function (this)
    local listName = "abilitySuppressions";
    PopulateSkillList(listName);
    EraseTable(configTable);
    configTable.title = this:GetText();
    configTable.skills = skillsTable;
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = this;
    configTable.anchorPoint = "BOTTOMRIGHT";
    configTable.relativePoint = "TOPRIGHT";
    configTable.saveHandler = SaveSkillList;
    configTable.saveArg1 = listName;
    configTable.hideHandler = SpamTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowSkillList(configTable);
   end
 );
 controls.skillSuppressionsButton = button;
 
 tabFrame.created = true;
end


-- ****************************************************************************
-- Called when the tab frame is shown.
-- ****************************************************************************
local function SpamTab_OnShow()
 if (not tabFrames.spam.created) then SpamTab_Create(); end

 local currentProfile = MSBTProfiles.currentProfile;
 local controls = tabFrames.spam.controls;

 controls.healSlider:SetValue(currentProfile.healThreshold);
 controls.damageSlider:SetValue(currentProfile.damageThreshold);
 controls.powerSlider:SetValue(currentProfile.powerThreshold);
 controls.dotThrottlingSlider:SetValue(currentProfile.dotThrottleDuration);
 controls.hotThrottlingSlider:SetValue(currentProfile.hotThrottleDuration);
 controls.powerThrottlingSlider:SetValue(currentProfile.powerThrottleDuration);
 controls.allPowerCheckbox:SetChecked(currentProfile.showAllPowerGains);
 controls.hyperRegenCheckbox:SetChecked(not currentProfile.regenAbilitiesDisabled);
 controls.abbreviateCheckbox:SetChecked(currentProfile.abbreviateAbilities);
 controls.hideSkillsCheckbox:SetChecked(currentProfile.hideSkills);
 controls.hideNamesCheckbox:SetChecked(currentProfile.hideNames);
end


-------------------------------------------------------------------------------
-- Cooldowns tab functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Enables the controls on the cooldowns tab.
-- ****************************************************************************
local function CooldownsTab_EnableControls()
 for name, frame in pairs(tabFrames.cooldowns.controls) do
  if (frame.Enable) then frame:Enable(); end
 end
end


-- ****************************************************************************
-- Saves the event settings selected by the user.
-- ****************************************************************************
local function CooldownsTab_SaveEventSettings(settings)
 local eventType = "NOTIFICATION_COOLDOWN";
 MSBTProfiles.SetOption("events." .. eventType, "scrollArea", settings.scrollArea, DEFAULT_SCROLL_AREA);
 MSBTProfiles.SetOption("events." .. eventType, "message", settings.message);
 MSBTProfiles.SetOption("events." .. eventType, "alwaysSticky", settings.alwaysSticky);
 MSBTProfiles.SetOption("events." .. eventType, "soundFile", settings.soundFile, "");

 tabFrames.cooldowns.messageFontString:SetText(settings.message); 
end


-- ****************************************************************************
-- Saves the font settings selected by the user.
-- ****************************************************************************
local function CooldownsTab_SaveFontSettings(settings)
 local eventType = "NOTIFICATION_COOLDOWN";
 MSBTProfiles.SetOption("events." .. eventType, "fontName", settings.normalFontName);
 MSBTProfiles.SetOption("events." .. eventType, "outlineIndex", settings.normalOutlineIndex);
 MSBTProfiles.SetOption("events." .. eventType, "fontSize", settings.normalFontSize);
 MSBTProfiles.SetOption("events." .. eventType, "fontAlpha", settings.normalFontAlpha); 
end


-- ****************************************************************************
-- Creates the cooldowns tab frame contents.
-- ****************************************************************************
local function CooldownsTab_Create()
 local tabFrame = tabFrames.cooldowns;
 tabFrame.controls = {};
 local controls = tabFrame.controls;

 -- Colorswatch.
 local colorswatch = MSBTControls.CreateColorswatch(tabFrame);
 colorswatch:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 5, -10);
 colorswatch:SetColorChangedHandler(
   function (this)
    local eventType = "NOTIFICATION_COOLDOWN";
    MSBTProfiles.SetOption("events." .. eventType, "colorR", this.r, 1);
    MSBTProfiles.SetOption("events." .. eventType, "colorG", this.g, 1);
    MSBTProfiles.SetOption("events." .. eventType, "colorB", this.b, 1);
   end
 );
 controls.colorSwatch = colorswatch;

 -- Enable checkbox.
 local checkbox = MSBTControls.CreateCheckbox(tabFrame);
 local objLocale = L.CHECKBOXES["enableCooldowns"];
 checkbox:Configure(24, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("LEFT", colorswatch, "RIGHT", 5, 0);
 checkbox:SetPoint("RIGHT", tabFrame, "TOPLEFT", 190, -10);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption("events.NOTIFICATION_COOLDOWN", "disabled", not isChecked);
	MSBTCooldowns.UpdateEnableState();
   end
 );
 controls.enableCheckbox = checkbox;
 
 -- Event settings button. 
 local button = MSBTControls.CreateIconButton(tabFrame, "Configure");
 objLocale = L.BUTTONS["eventSettings"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("TOPRIGHT", tabFrame, "TOPRIGHT", -10, -5);
 button:SetClickHandler(
   function (this)
    local eventSettings = MSBTProfiles.currentProfile.events.NOTIFICATION_COOLDOWN;
 
    EraseTable(configTable);
    configTable.title = L.TABS[6].label;
    configTable.message = eventSettings.message;
    configTable.codes = L.EVENT_CODES["COOLDOWN_NAME"];
    configTable.scrollArea = eventSettings.scrollArea or DEFAULT_SCROLL_AREA;
    configTable.alwaysSticky = eventSettings.alwaysSticky;
    configTable.soundFile = eventSettings.soundFile;
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = tabFrame;
    configTable.anchorPoint = "TOPRIGHT";
    configTable.relativePoint = "TOPRIGHT";
    configTable.saveHandler = CooldownsTab_SaveEventSettings;
    configTable.hideHandler = CooldownsTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowEvent(configTable);
   end
 );
 controls[#controls+1] = button;

 -- Font settings button. 
 button = MSBTControls.CreateIconButton(tabFrame, "FontSettings");
 objLocale = L.BUTTONS["eventFontSettings"];
 button:SetTooltip(objLocale.tooltip);
 button:SetPoint("RIGHT", controls[#controls], "LEFT", 0, 0);
 button:SetClickHandler(
   function (this)
    local eventSettings = MSBTProfiles.currentProfile.events.NOTIFICATION_COOLDOWN;
    local saSettings = MSBTProfiles.currentProfile.scrollAreas[eventSettings.scrollArea];
    if (not saSettings) then saSettings = MSBTProfiles.currentProfile.scrollAreas[DEFAULT_SCROLL_AREA]; end
    local fonts = MSBTAnimations.fonts;
 
    EraseTable(configTable);
    configTable.title = L.TABS[6].label;
 
    -- Inherit from the correct scroll area.
    local fontName = saSettings.normalFontName;
    if (not MSBTAnimations.fonts[fontName]) then fontName = MSBTProfiles.currentProfile.normalFontName; end
    if (not MSBTAnimations.fonts[fontName]) then fontName = DEFAULT_FONT_NAME; end
    configTable.inheritedNormalFontName = fontName;
    configTable.inheritedNormalOutlineIndex = saSettings.normalOutlineIndex or MSBTProfiles.currentProfile.normalOutlineIndex;
    configTable.inheritedNormalFontSize = saSettings.normalFontSize or MSBTProfiles.currentProfile.normalFontSize;
    configTable.inheritedNormalFontAlpha = saSettings.normalFontAlpha or MSBTProfiles.currentProfile.normalFontAlpha;

    fontName = eventSettings.fontName;
    if (not MSBTAnimations.fonts[fontName]) then fontName = nil; end
    configTable.normalFontName = fontName;
    configTable.normalOutlineIndex = eventSettings.outlineIndex;
    configTable.normalFontSize = eventSettings.fontSize;
    configTable.normalFontAlpha = eventSettings.fontAlpha;

    configTable.hideCrit = true;
    configTable.parentFrame = tabFrames.cooldowns;
    configTable.anchorFrame = tabFrames.cooldowns;
    configTable.anchorPoint = "BOTTOM";
    configTable.relativePoint = "BOTTOM";
    configTable.saveHandler = CooldownsTab_SaveFontSettings;
    configTable.hideHandler = CooldownsTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowFont(configTable);
   end
 );
 controls[#controls+1] = button;

 -- Message font string.
 local fontString = tabFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
 fontString:SetPoint("LEFT", checkbox, "RIGHT", 10, 0);
 fontString:SetPoint("RIGHT", button, "LEFT", -10, 0);
 fontString:SetJustifyH("LEFT");
 tabFrame.messageFontString = fontString;
 
 -- Cooldown threshold slider.
 local slider = MSBTControls.CreateSlider(tabFrame);
 objLocale = L.SLIDERS["cooldownThreshold"]; 
 slider:Configure(180, objLocale.label, objLocale.tooltip);
 slider:SetPoint("TOPLEFT", controls.colorSwatch, "BOTTOMLEFT", 0, -40);
 slider:SetMinMaxValues(5, 300);
 slider:SetValueStep(5);
 slider:SetValueChangedHandler(
   function(this, value)
     MSBTProfiles.SetOption(nil, "cooldownThreshold", value);
   end
 );
 controls.cooldownSlider = slider;

 -- Cooldown exclusions button.
 button = MSBTControls.CreateOptionButton(tabFrame);
 objLocale = L.BUTTONS["cooldownExclusions"];
 button:Configure(20, objLocale.label, objLocale.tooltip);
 button:SetPoint("TOPLEFT", controls.cooldownSlider, "BOTTOMLEFT", 0, -40);
 button:SetClickHandler(
   function (this)
    local listName = "cooldownExclusions";
    PopulateSkillList(listName);
    EraseTable(configTable);
    configTable.title = this:GetText();
    configTable.skills = skillsTable;
    configTable.parentFrame = tabFrame;
    configTable.anchorFrame = tabFrame;
    configTable.anchorPoint = "TOPRIGHT";
    configTable.relativePoint = "TOPRIGHT";
    configTable.saveHandler = SaveSkillList;
    configTable.saveArg1 = listName;
    configTable.hideHandler = CooldownsTab_EnableControls;
    DisableControls(controls);
    MSBTPopups.ShowSkillList(configTable);
   end
 );
 controls.cooldownExclusions = button;

 tabFrame.created = true;
end

-- ****************************************************************************
-- Called when the tab frame is shown.
-- ****************************************************************************
local function CooldownsTab_OnShow()
 if (not tabFrames.cooldowns.created) then CooldownsTab_Create(); end

 local tabFrame = tabFrames.cooldowns;
 local controls = tabFrame.controls;
 local currentProfile = MSBTProfiles.currentProfile;
 local eventSettings = currentProfile.events["NOTIFICATION_COOLDOWN"];

 controls.colorSwatch:SetColor(eventSettings.colorR or 1, eventSettings.colorG or 1, eventSettings.colorB or 1);
 controls.enableCheckbox:SetChecked(not eventSettings.disabled);
 tabFrame.messageFontString:SetText(eventSettings.message);
 controls.cooldownSlider:SetValue(currentProfile.cooldownThreshold);
end

-------------------------------------------------------------------------------
-- Skill icons tab functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Creates the skill icons tab frame contents.
-- ****************************************************************************
local function SkillIconsTab_Create()
 local tabFrame = tabFrames.skillIcons;
 tabFrame.controls = {};
 local controls = tabFrame.controls;
 
 -- Enable checkbox.
 local checkbox = MSBTControls.CreateCheckbox(tabFrame);
 local objLocale = L.CHECKBOXES["enableIcons"];
 checkbox:Configure(24, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 5, -10);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "skillIconsDisabled", not isChecked);
    if (isChecked) then controls.exclusiveCheckbox:Enable(); else controls.exclusiveCheckbox:Disable(); end
   end
 );
 controls.enableCheckbox = checkbox;

 -- Exclusive skills checkbox.
 checkbox = MSBTControls.CreateCheckbox(tabFrame);
 local objLocale = L.CHECKBOXES["exclusiveSkills"];
 checkbox:Configure(24, objLocale.label, objLocale.tooltip);
 checkbox:SetPoint("TOPLEFT", controls.enableCheckbox, "BOTTOMLEFT", 20, -10);
 checkbox:SetClickHandler(
   function (this, isChecked)
    MSBTProfiles.SetOption(nil, "exclusiveSkillsDisabled", not isChecked);
   end
 );
 controls.exclusiveCheckbox = checkbox;


 tabFrame.created = true;
end


-- ****************************************************************************
-- Called when the tab frame is shown.
-- ****************************************************************************
local function SkillIconsTab_OnShow()
 if (not tabFrames.skillIcons.created) then SkillIconsTab_Create(); end

 local tabFrame = tabFrames.skillIcons;
 local controls = tabFrame.controls;
 local currentProfile = MSBTProfiles.currentProfile;

 controls.enableCheckbox:SetChecked(not currentProfile.skillIconsDisabled);
 controls.exclusiveCheckbox:SetChecked(not currentProfile.exclusiveSkillsDisabled);
 
 if (controls.enableCheckbox:GetChecked()) then
  controls.exclusiveCheckbox:Enable();
 else
  controls.exclusiveCheckbox:Disable();
 end
end




-- ****************************************************************************
-- Called when the module is loaded.
-- ****************************************************************************
local function OnLoad()
 -- Create an empty frame for the general tab that will be dynamically created when shown.
 local tabFrame = CreateFrame("Frame");
 tabFrame:Hide();
 tabFrame:SetScript("OnShow", GeneralTab_OnShow);
 tabFrames.general = tabFrame;
 MSBTOptMain.AddTab(tabFrame, L.TABS[1].label, L.TABS[1].tooltip);

 -- Create an empty frame for the scroll areas tab that will be dynamically created when shown.
 tabFrame = CreateFrame("Frame");
 tabFrame:Hide();
 tabFrame:SetScript("OnShow", ScrollAreasTab_OnShow);
 tabFrames.scrollAreas = tabFrame;
 MSBTOptMain.AddTab(tabFrame, L.TABS[2].label, L.TABS[2].tooltip);

 -- Create an empty frame for the events tab that will be dynamically created when shown.
 tabFrame = CreateFrame("Frame");
 tabFrame:Hide();
 tabFrame:SetScript("OnShow", EventsTab_OnShow);
 tabFrames.events = tabFrame;
 MSBTOptMain.AddTab(tabFrame, L.TABS[3].label, L.TABS[3].tooltip);

 -- Create an empty frame for the triggers tab that will be dynamically created when shown.
 tabFrame = CreateFrame("Frame");
 tabFrame:Hide();
 tabFrame:SetScript("OnShow", TriggersTab_OnShow);
 tabFrames.triggers = tabFrame;
 MSBTOptMain.AddTab(tabFrame, L.TABS[4].label, L.TABS[4].tooltip);

 -- Create an empty frame for the spam tab that will be dynamically created when shown.
 tabFrame = CreateFrame("Frame");
 tabFrame:Hide();
 tabFrame:SetScript("OnShow", SpamTab_OnShow);
 tabFrames.spam = tabFrame;
 MSBTOptMain.AddTab(tabFrame, L.TABS[5].label, L.TABS[5].tooltip);

 -- Create an empty frame for the cooldowns tab that will be dynamically created when shown.
 tabFrame = CreateFrame("Frame");
 tabFrame:Hide();
 tabFrame:SetScript("OnShow", CooldownsTab_OnShow);
 tabFrames.cooldowns = tabFrame;
 MSBTOptMain.AddTab(tabFrame, L.TABS[6].label, L.TABS[6].tooltip);

 -- Create an empty frame for the icons tab that will be dynamically created when shown.
 tabFrame = CreateFrame("Frame");
 tabFrame:Hide();
 tabFrame:SetScript("OnShow", SkillIconsTab_OnShow);
 tabFrames.skillIcons = tabFrame;
 MSBTOptMain.AddTab(tabFrame, L.TABS[7].label, L.TABS[7].tooltip);
end




-------------------------------------------------------------------------------
-- Load.
-------------------------------------------------------------------------------

OnLoad();