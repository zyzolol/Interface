--[[

  BindPad Addon for World of Warcraft

  Auther: Tageshi

--]]

local NUM_MACRO_ICONS_SHOWN = 20;
local NUM_ICONS_PER_ROW = 5;
local NUM_ICON_ROWS = 4;
local MACRO_ICON_ROW_HEIGHT = 36;

-- Avoid taint of official lua codes.
local i, j;

-- Register BindPad frame to be controlled together with
-- other panels in standard UI.
UIPanelWindows["BindPadFrame"] = { area = "left", pushable = 8, whileDead = 1 };
UIPanelWindows["BindPadMacroTextFrame"] = { area = "left", pushable = 9, whileDead = 1 };

-- Register BindPad binding frame to be closed on Escape press.
tinsert(UISpecialFrames,"BindPadBindFrame");

local BINDPAD_MAXSLOTS = 42;
local BINDPAD_GENERAL_TAB = 1;
local BINDPAD_SPECIFIC_TAB = 2;
local BINDPAD_SAVEFILE_VERSION = 1.3;
local BINDPADMACRO_SPECIFIC_OFFSET = 100;

-- Initialize the saved variable for BindPad.
BindPadVars = {
  tab = BINDPAD_GENERAL_TAB,
  version = BINDPAD_SAVEFILE_VERSION,
};

-- Initialize BindPad core object.
BindPadCore = {
  actionButtonNames = {};
  actionButtonIds = {};
  IsHighestCash = {};
  hotkeyShownBefore = {};
  hotkeyTextBefore = {};
  hotkeyShownAfter = {};
  hotkeyTextAfter = {};
  drag = {};
  dragswap = {};
  bindpadmacro = {};
};
local BindPadCore = BindPadCore;

StaticPopupDialogs["BINDPAD_CONFIRM_DELETING_CHARACTER_SPECIFIC_BINDINGS"] = {
  text = CONFIRM_DELETING_CHARACTER_SPECIFIC_BINDINGS,
  button1 = OKAY,
  button2 = CANCEL,
  OnAccept = function()
    StaticPopup_Show("BINDPAD_CONFIRM_DELETING_CHARACTER_SPECIFIC_BINDINGS2");
  end,
  OnCancel = function()
    BindPadFrameCharacterButton:SetChecked(GetCurrentBindingSet() == 2);
  end,
  timeout = 0,
  whileDead = 1,
  showAlert = 1,
  hideOnEscape = 1
};

StaticPopupDialogs["BINDPAD_CONFIRM_DELETING_CHARACTER_SPECIFIC_BINDINGS2"] = {
  text = BINDPAD_TEXT_ARE_YOU_SURE,
  button1 = OKAY,
  button2 = CANCEL,
  OnAccept = function()
    LoadBindings(1);
    SaveBindings(1);
    BindPadVars.tab = 1;
    BindPadFrame_OnShow();
  end,
  OnCancel = function()
    BindPadFrameCharacterButton:SetChecked(GetCurrentBindingSet() == 2);
  end,
  timeout = 0,
  whileDead = 1,
  showAlert = 1,
  hideOnEscape = 1
};

StaticPopupDialogs["BINDPAD_CONFIRM_CHANGE_BINDING_PROFILE"] = {
  text = BINDPAD_TEXT_CONFIRM_CHANGE_BINDING_PROFILE,
  button1 = OKAY,
  button2 = CANCEL,
  OnAccept = function()
    LoadBindings(2);
    SaveBindings(2);
    BindPadVars.tab = 2;
    BindPadFrame_OnShow();
  end,
  OnCancel = function()
    BindPadVars.tab = 1;
  end,
  timeout = 0,
  whileDead = 1,
  showAlert = 1,
  hideOnEscape = 1
};

StaticPopupDialogs["BINDPAD_CONFIRM_CONVERT"] = {
  text = BINDPAD_TEXT_CONFIRM_CONVERT,
  button1 = OKAY,
  button2 = CANCEL,
  OnAccept = function(id)
    BindPadCore.ConvertToBindPadMacro(id);
  end,
  OnCancel = function()
  end,
  timeout = 0,
  whileDead = 1,
  showAlert = 1,
  hideOnEscape = 1
};

function BindPadFrame_OnLoad()
  PanelTemplates_SetNumTabs(BindPadFrame, 4);

  SlashCmdList["BINDPAD"] = BindPadFrame_Toggle;
  SLASH_BINDPAD1 = "/bindpad";
  SLASH_BINDPAD2 = "/bp";

  this:RegisterEvent("VARIABLES_LOADED");
  this:RegisterEvent("SPELLS_CHANGED");
  this:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
  this:RegisterEvent("UPDATE_BINDINGS");
end

function BindPadFrame_OnMouseDown()
  if arg1 == "RightButton" then
    BindPadCore.ClearCursor();
  end
end

function BindPadFrame_OnEnter()
  BindPadCore.UpdateCursor();
end

function BindPadFrame_OnEvent()
  if event == "ACTIONBAR_SLOT_CHANGED" then
    BindPadCore.UpdateHotkey(arg1, BindPadCore.GetActionButton(arg1));
  elseif event == "UPDATE_BINDINGS" then
    -- Use a single shot of OnUpdate for update of hotkeys.
    BindPadUpdateFrame:Show();
  elseif event == "SPELLS_CHANGED" then
    BindPadCore.InitCash();
  elseif event == "VARIABLES_LOADED" then
    BindPadCore.InitBindPadMacroButton();
  end
end

function BindPadFrame_OutputText(text)
  ChatFrame1:AddMessage("[BindPad] "..text, 1.0, 1.0, 0.0);
end

function BindPadFrame_Toggle()
  if BindPadFrame:IsVisible() then
    HideUIPanel(BindPadFrame);
  else
    ShowUIPanel(BindPadFrame);
  end
end

function BindPadFrame_OnShow(id)
  -- Savefile version 1.0 and 1.1 are obsolated.
  if BindPadVars.version == nil or
     BindPadVars.version < 1.2 then
    BindPadVars = {
      tab = BINDPAD_GENERAL_TAB;
    };
    BindPadFrame_OutputText(BINDPAD_TEXT_OBSOLATED);
  end
  -- Set current version number
  BindPadVars.version = BINDPAD_SAVEFILE_VERSION;

  if id then
    BindPadVars.tab = id;
  elseif nil == BindPadVars.tab then
    BindPadVars.tab = 1;
  end
  if GetCurrentBindingSet() == 1 then
    -- Don't show Character Specific Slots tab at first.
    BindPadVars.tab = 1;
    if id then
      StaticPopup_Show("BINDPAD_CONFIRM_CHANGE_BINDING_PROFILE");
    end
  end
  PanelTemplates_SetTab(BindPadFrame, BindPadVars.tab);

  -- Update character button
  BindPadFrameCharacterButton:SetChecked(GetCurrentBindingSet() == 2);

  -- Update Show Hotkey button
  BindPadFrameShowHotkeysButton:SetChecked(BindPadVars.showHotkey);

  for i = 1, BINDPAD_MAXSLOTS, 1 do
    local button = getglobal("BindPadSlot"..i);
    BindPadSlot_UpdateState(button);
  end
end

function BindPadFrame_OnHide()
  BindPadBindFrame:Hide();
  BindPadMacroPopupFrame:Hide();
  HideUIPanel(BindPadMacroTextFrame);
end

function BindPadUpdateFrame_OnUpdate()
  if BindPadVars.showHotkey == nil then
    BindPadVars.showHotkey = true;
  end

  BindPadUpdateFrame:Hide();
  BindPadCore.UpdateAllHotKeys();
end

function BindPadBindFrame_Update()
  StaticPopup_Hide("BINDPAD_CONFIRM_BINDING")
  BindPadBindFrameAction:SetText(BindPadCore.selectedSlot.action);

  local key = GetBindingKey(BindPadCore.selectedSlot.action);
  if key then
    BindPadBindFrameKey:SetText(BINDPAD_TEXT_KEY..BindPadCore.GetBindingText(key, "KEY_"));
  else
    BindPadBindFrameKey:SetText(BINDPAD_TEXT_KEY..BINDPAD_TEXT_NOTBOUND);
  end
end

function BindPadBindFrame_OnKeyDown(key)
  if key=="ESCAPE" then
    BindPadBindFrame:Hide()
    return
  end
  local screenshotKey = GetBindingKey("SCREENSHOT");
  if ( screenshotKey and key == screenshotKey ) then
    Screenshot();
    return;
  end
  local button
  -- Convert the mouse button names
  if ( key == "LeftButton" ) then
    button = "BUTTON1"
  elseif ( key == "RightButton" ) then
    button = "BUTTON2"
  elseif ( key == "MiddleButton" ) then
    button = "BUTTON3"
  elseif ( key == "Button4" ) then
    button = "BUTTON4"
  elseif ( key == "Button5" ) then
    button = "BUTTON5"
  end
  local keyPressed
  if ( button ) then
    if ( button == "BUTTON1" or button == "BUTTON2" ) then
      return;
    end
    keyPressed = button;
  else
    keyPressed = key;
  end
  if (keyPressed == "UNKNOWN") then
    return;
  end
  if ( keyPressed == "LSHIFT" or
       keyPressed == "RSHIFT" or
       keyPressed == "LCTRL" or
       keyPressed == "RCTRL" or
       keyPressed == "LALT" or
       keyPressed == "RALT" ) then
    return;
  end
  if ( IsShiftKeyDown() ) then
    keyPressed = "SHIFT-"..keyPressed
  end
  if ( IsControlKeyDown() ) then
    keyPressed = "CTRL-"..keyPressed
  end
  if ( IsAltKeyDown() ) then
    keyPressed = "ALT-"..keyPressed
  end
  if keyPressed then
    BindPadCore.keyPressed = keyPressed
    local oldAction = GetBindingAction(keyPressed)

    local keyText = BindPadCore.GetBindingText(keyPressed, "KEY_");
    if oldAction~="" and oldAction ~= BindPadCore.selectedSlot.action then
      if StaticPopupDialogs["BINDPAD_CONFIRM_BINDING"] == nil then
        StaticPopupDialogs["BINDPAD_CONFIRM_BINDING"] = {
          button1 = YES,
          button2 = NO,
          timeout = 0,
          hideOnEscape = 1,
          OnAccept = BindPadBindFrame_SetBindKey,
          OnCancel = BindPadBindFrame_Update
        }
      end
      StaticPopupDialogs["BINDPAD_CONFIRM_BINDING"].text = format(BINDPAD_TEXT_CONFIRM_BINDING, keyText, BindPadCore.GetBindingName(oldAction), keyText, BindPadCore.selectedSlot.action);
      StaticPopup_Show("BINDPAD_CONFIRM_BINDING")
    else
      BindPadBindFrame_SetBindKey();
    end
  end
end

function BindPadBindFrame_SetBindKey()
  BindPadCore.BindKey();
  BindPadBindFrame_Update();
end

function BindPadBindFrame_Unbind()
  BindPadCore.UnbindSlot(BindPadCore.selectedSlot);
  BindPadBindFrame_Update();
end

function BindPadBindFrame_OnHide()
  -- Close the confirmation dialog frame if it is still open.
  StaticPopup_Hide("BINDPAD_CONFIRM_BINDING")
end

function BindPadSlot_OnUpdate()
  BindPadSlot_UpdateState(this);
end

function BindPadSlot_OnClick(button)
  if button == "RightButton" then
    if BindPadCore.CursorHasIcon() then
      BindPadCore.ClearCursor();
    else
      BindPadMacroTextFrame_Open(this);
    end
    return;
  end

  if BindPadCore.CursorHasIcon() then
    -- If cursor has icon to drop, drop it.
    BindPadSlot_OnReceiveDrag();
  elseif IsShiftKeyDown() then
    -- Shift+click to start drag.
    BindPadSlot_OnDragStart();
  else
    -- Otherwise open dialog window to set keybinding.
    BindPadCore.selectedSlot = BindPadCore.GetSlotInfo(this:GetID());
    if nil ~= BindPadCore.selectedSlot.type then
      BindPadMacroPopupFrame:Hide();
      HideUIPanel(BindPadMacroTextFrame);
      BindPadBindFrame_Update();
      BindPadBindFrame:Show();
    end
  end
end

function BindPadSlot_OnDragStart(button)
  if button == nil then
    button = this;
  end

  BindPadCore.PickupSlot(button:GetID());
  BindPadSlot_UpdateState(button);
end

function BindPadSlot_OnReceiveDrag(button)
  if button == nil then
    button = this;
  end
  if button == BindPadCore.selectedSlotButton then
    BindPadMacroPopupFrame:Hide();
    HideUIPanel(BindPadMacroTextFrame);
    BindPadBindFrame:Hide();
  end

  local type, detail, subdetail = GetCursorInfo();
  if type then
    ClearCursor();
    ResetCursor();
    BindPadCore.PickupSlot(button:GetID());
    BindPadCore.PlaceIntoSlot(button:GetID(), type, detail, subdetail);

    BindPadSlot_UpdateState(button);
    BindPadSlot_OnEnter();
  elseif "CLICK" == BindPadCore.drag.type then
    local drag = BindPadCore.drag;
    ClearCursor();
    ResetCursor();
    BindPadCore.PickupSlot(button:GetID());
    BindPadCore.PlaceVirtualIconIntoSlot(button:GetID(), drag);

    BindPadSlot_UpdateState(button);
    BindPadSlot_OnEnter();
  end
end

function BindPadSlot_OnEnter()
  BindPadCore.UpdateCursor();

  local padSlot = BindPadCore.GetSlotInfo(this:GetID());

  if padSlot == nil or padSlot.type == nil then
    return;
  end
  GameTooltip:SetOwner(this, "ANCHOR_LEFT");

  if "ITEM" == padSlot.type then
    GameTooltip:SetHyperlink(padSlot.linktext);
  elseif "SPELL" == padSlot.type then
    local spellID = BindPadCore.FindSpellIdByName(padSlot.name, padSlot.rank, padSlot.bookType);
    if spellID then
      GameTooltip:SetSpell(spellID, padSlot.bookType)
    else
      GameTooltip:SetText(BINDPAD_TOOLTIP_UNKNOWN_SPELL..padSlot.name, 1.0, 1.0, 1.0);
    end
    if padSlot.rank then
      GameTooltip:AddLine(BINDPAD_TOOLTIP_DOWNRANK..padSlot.rank, 1.0, 0.7, 0.7);
    end
  elseif "MACRO" == padSlot.type then
    GameTooltip:SetText(BINDPAD_TOOLTIP_MACRO..padSlot.name, 1.0, 1.0, 1.0);
  elseif "CLICK" == padSlot.type then
    GameTooltip:SetText(format(BINDPAD_TOOLTIP_BINDPADMACRO, padSlot.id, padSlot.name), 1.0, 1.0, 1.0);
  end

  local key = GetBindingKey(padSlot.action);
  if key then
    GameTooltip:AddLine(BINDPAD_TOOLTIP_KEYBINDING..BindPadCore.GetBindingText(key, "KEY_"), 0.8, 0.8, 1.0);
  end

  if not BindPadCore.CursorHasIcon() then
    if "CLICK" == padSlot.type then
      GameTooltip:AddLine(BINDPAD_TOOLTIP_CLICK_USAGE1, 0.8, 1.0, 0.8);
    else
      GameTooltip:AddLine(BINDPAD_TOOLTIP_CLICK_USAGE2, 0.8, 1.0, 0.8);
    end
  end

  GameTooltip:Show();
end

function BindPadSlot_UpdateState(button)
  local padSlot = BindPadCore.GetSlotInfo(button:GetID());

  local icon = getglobal(button:GetName().."Icon");
  local name = getglobal(button:GetName().."Name");
  local hotkey = getglobal(button:GetName().."HotKey");
  local addbutton = getglobal(button:GetName().."AddButton");
  local border = getglobal(button:GetName().."Border");

  if padSlot and padSlot.type then
    icon:SetTexture(padSlot.texture);
    icon:Show();
    addbutton:Hide();

    if name then
      name:SetText(padSlot.name);
    else
      name:SetText("");
    end

    local key = GetBindingKey(padSlot.action);
    if key then
      hotkey:SetText(BindPadCore.GetBindingText(key, "KEY_", 1));
    else
      hotkey:SetText("");
    end
    if "CLICK" == padSlot.type then
      border:SetVertexColor(0, 1.0, 0, 0.35);
      border:Show();
    else
      border:Hide();
    end

  else
    icon:Hide();
    addbutton:Show();
    name:SetText("");
    hotkey:SetText("");
    border:Hide();
  end
end

local BindPadMacroPopup_oldPadSlot = {};
function BindPadMacroPopupFrame_Open(button)
  local padSlot = BindPadCore.GetSlotInfo(button:GetID());
  local newFlag = false;

  BindPadMacroPopup_oldPadSlot.action = padSlot.action;
  BindPadMacroPopup_oldPadSlot.id = padSlot.id;
  BindPadMacroPopup_oldPadSlot.macrotext = padSlot.macrotext;
  BindPadMacroPopup_oldPadSlot.name = padSlot.name;
  BindPadMacroPopup_oldPadSlot.texture = padSlot.texture;
  BindPadMacroPopup_oldPadSlot.type = padSlot.type;

  if nil == padSlot.type then
    newFlag = true;
    GetNumMacroIcons(); -- Load macro icons

    padSlot.id = BindPadCore.NewBindPadMacroID();
    padSlot.type = "CLICK";
    padSlot.name = "macro"..padSlot.id;
    padSlot.texture = GetMacroIconInfo(1);
    padSlot.macrotext = "";
    padSlot.action = BindPadCore.CreateBindPadMacroAction(padSlot.id);
    BindPadSlot_UpdateState(button)
  end

  if "CLICK" == padSlot.type then
    BindPadCore.selectedSlot = padSlot;
    BindPadCore.selectedSlotButton = button;

    BindPadMacroPopupEditBox:SetText(padSlot.name);
    BindPadMacroPopupFrame.selectedIconTexture = padSlot.texture;
    BindPadMacroPopupFrame.selectedIcon = nil;
    BindPadBindFrame:Hide();
    HideUIPanel(BindPadMacroTextFrame);
    BindPadMacroPopupFrame:Show();
    if newFlag then
      BindPadMacroPopupEditBox:HighlightText();
    end
  end
end

function BindPadMacroAddButton_OnClick(button)
  if BindPadCore.CursorHasIcon() then
    BindPadSlot_OnReceiveDrag(button);

  else
    HideUIPanel(BindPadMacroTextFrame);

    PlaySound("gsTitleOptionOK");
    BindPadMacroPopupFrame_Open(button);
  end
end

function BindPadMacroPopupFrame_OnShow()
  BindPadMacroPopupEditBox:SetFocus();
  BindPadMacroPopupFrame_Update();
  BindPadMacroPopupOkayButton_Update();
end

function BindPadMacroPopupFrame_OnHide()
end

function BindPadMacroPopupFrame_Update()
  local numMacroIcons = GetNumMacroIcons();
  local macroPopupIcon, macroPopupButton;
  local macroPopupOffset = FauxScrollFrame_GetOffset(BindPadMacroPopupScrollFrame);
  local index;
  
  -- Icon list
  local texture;
  for i=1, NUM_MACRO_ICONS_SHOWN do
    macroPopupIcon = getglobal("BindPadMacroPopupButton"..i.."Icon");
    macroPopupButton = getglobal("BindPadMacroPopupButton"..i);
    index = (macroPopupOffset * NUM_ICONS_PER_ROW) + i;
    texture = GetMacroIconInfo(index);
    if ( index <= numMacroIcons ) then
      macroPopupIcon:SetTexture(texture);
      macroPopupButton:Show();
    else
      macroPopupIcon:SetTexture("");
      macroPopupButton:Hide();
    end
    if ( BindPadMacroPopupFrame.selectedIcon and (index == BindPadMacroPopupFrame.selectedIcon) ) then
      macroPopupButton:SetChecked(1);
    elseif ( BindPadMacroPopupFrame.selectedIconTexture ==  texture ) then
      macroPopupButton:SetChecked(1);
    else
      macroPopupButton:SetChecked(nil);
    end
  end
  
  -- Scrollbar stuff
  FauxScrollFrame_Update(BindPadMacroPopupScrollFrame, ceil(numMacroIcons / NUM_ICONS_PER_ROW) , NUM_ICON_ROWS, MACRO_ICON_ROW_HEIGHT );
end

function BindPadMacroPopupFrame_OnScroll()
  FauxScrollFrame_OnVerticalScroll(MACRO_ICON_ROW_HEIGHT, BindPadMacroPopupFrame_Update);
end

function BindPadMacroPopupEditBox_OnTextChanged()
  local padSlot = BindPadCore.selectedSlot;
  padSlot.name = this:GetText();
  BindPadSlot_UpdateState(BindPadCore.selectedSlotButton)
end

function BindPadMacroPopupFrame_CancelEdit()
  local padSlot = BindPadCore.GetSlotInfo(BindPadCore.selectedSlotButton:GetID());
  BindPadMacroPopupFrame:Hide();

  if "CLICK" ~= BindPadMacroPopup_oldPadSlot.type then
    BindPadCore.DeleteBindPadMacroID(padSlot.id);
  end

  padSlot.action = BindPadMacroPopup_oldPadSlot.action;
  padSlot.id = BindPadMacroPopup_oldPadSlot.id;
  padSlot.macrotext = BindPadMacroPopup_oldPadSlot.macrotext;
  padSlot.name = BindPadMacroPopup_oldPadSlot.name;
  padSlot.texture = BindPadMacroPopup_oldPadSlot.texture;
  padSlot.type = BindPadMacroPopup_oldPadSlot.type;

  BindPadMacroPopupFrame.selectedIcon = nil;
  BindPadSlot_UpdateState(BindPadCore.selectedSlotButton)
end

function BindPadMacroPopupOkayButton_Update()
  if ( (strlen(BindPadMacroPopupEditBox:GetText()) > 0) and BindPadMacroPopupFrame.selectedIcon ) then
    BindPadMacroPopupOkayButton:Enable();
  else
    BindPadMacroPopupOkayButton:Disable();
  end
  if (strlen(BindPadMacroPopupEditBox:GetText()) > 0) then
    BindPadMacroPopupOkayButton:Enable();
  end
end

function BindPadMacroPopupButton_OnClick()
  BindPadMacroPopupFrame.selectedIcon = this:GetID() + (FauxScrollFrame_GetOffset(BindPadMacroPopupScrollFrame) * NUM_ICONS_PER_ROW);
  -- Clear out selected texture
  BindPadMacroPopupFrame.selectedIconTexture = nil;

  BindPadCore.selectedSlot.texture = GetMacroIconInfo(BindPadMacroPopupFrame.selectedIcon);
  BindPadSlot_UpdateState(BindPadCore.selectedSlotButton);

  BindPadMacroPopupOkayButton_Update();
  BindPadMacroPopupFrame_Update();
end

function BindPadMacroPopupOkayButton_OnClick()
  BindPadMacroPopupFrame:Hide();
  BindPadSlot_UpdateState(BindPadCore.selectedSlotButton);
  BindPadMacroTextFrame_Open(BindPadCore.selectedSlotButton);
end

function BindPadMacroTextFrame_Open(button)
  HideUIPanel(BindPadMacroTextFrame);

  local id = button:GetID();
  local padSlot = BindPadCore.GetSlotInfo(id);

  if nil == padSlot.type then
    return;
  end
  BindPadCore.selectedSlot = padSlot;
  BindPadCore.selectedSlotButton = button;

  if "CLICK" ~= padSlot.type then
    StaticPopup_Show("BINDPAD_CONFIRM_CONVERT", padSlot.type, padSlot.name);
    return;
  end

  BindPadMacroTextFrameSelectedMacroName:SetText(padSlot.name);
  BindPadMacroTextFrameSelectedMacroButtonIcon:SetTexture(padSlot.texture);
  BindPadMacroTextFrameText:SetText(padSlot.macrotext);

  BindPadBindFrame:Hide()
  BindPadMacroPopupFrame:Hide();
  ShowUIPanel(BindPadMacroTextFrame);
end

function BindPadMacroTextFrameEditButton_OnClick()
  BindPadMacroPopupFrame_Open(BindPadCore.selectedSlotButton);
end

function BindPadMacroDeleteButton_OnClick()
  HideUIPanel(this:GetParent());

  local padSlot = BindPadCore.GetSlotInfo(BindPadCore.selectedSlotButton:GetID());

  BindPadCore.DeleteBindPadMacroID(padSlot.id);

  padSlot.action = nil;
  padSlot.bookType = nil;
  padSlot.id = nil;
  padSlot.linkText = nil;
  padSlot.macrotext = nil;
  padSlot.name = nil;
  padSlot.rank = nil;
  padSlot.texture = nil;
  padSlot.type = nil;

  BindPadSlot_UpdateState(BindPadCore.selectedSlotButton);
end

function BindPadMacroTextFrame_OnShow()
  BindPadMacroTextFrameText:SetFocus();
end

function BindPadMacroTextFrame_OnHide()
  BindPadCore.selectedSlot.macrotext = BindPadMacroTextFrameText:GetText();
  BindPadCore.UpdateMacroText(BindPadCore.selectedSlot);
end



--
-- BindPadCore:  A set of core functions
--

function BindPadCore.PlaceIntoSlot(id, type, detail, subdetail)

  local padSlot = BindPadCore.GetSlotInfo(id);

  if type == "item" then
    padSlot.linktext = subdetail;
    local name,_,_,_,_,_,_,_,_,texture = GetItemInfo(padSlot.linktext);
    padSlot.name = name;
    padSlot.texture = texture;
    padSlot.type = "ITEM";

  elseif type == "macro" then
    local name, texture = GetMacroInfo(detail);
    padSlot.name = name;
    padSlot.texture = texture;
    padSlot.type = "MACRO";

  elseif type == "spell" then
    local spellName, spellRank = GetSpellName(detail, subdetail);
    local texture = GetSpellTexture(detail, subdetail);
    padSlot.bookType = subdetail;
    padSlot.name = spellName;
    if BindPadCore.IsHighestRank(detail, subdetail) then
      padSlot.rank = nil;
    else
      padSlot.rank = spellRank;
    end
    padSlot.texture = texture;
    padSlot.type = "SPELL";

  elseif type == "merchant" then
    padSlot.linktext = GetMerchantItemLink(detail);
    local name,_,_,_,_,_,_,_,_,texture = GetItemInfo(padSlot.linktext);
    padSlot.name = name;
    padSlot.texture = texture;
    padSlot.type = "ITEM";

  else
    BindPadFrame_OutputText(format(BINDPAD_TEXT_CANNOT_PLACE, type));
    return;
  end

  padSlot.action = padSlot.type.." "..padSlot.name;
  if padSlot.rank then
    padSlot.action = padSlot.action.."("..padSlot.rank..")";
  end
end

function BindPadCore.PlaceVirtualIconIntoSlot(id, drag)
  if "CLICK" ~= drag.type then
    return;
  end
  
  local padSlot = BindPadCore.GetSlotInfo(id);

  local icon_is_character_specific = (drag.id >= BINDPADMACRO_SPECIFIC_OFFSET);
  local slot_is_character_specific = BindPadCore.IsCharacterSpecific();
  if icon_is_character_specific == slot_is_character_specific then
    padSlot.id = drag.id;
    padSlot.action = drag.action;
  else
    padSlot.id = BindPadCore.NewBindPadMacroID();
    padSlot.action = BindPadCore.CreateBindPadMacroAction(padSlot.id);
  end
  padSlot.macrotext = drag.macrotext;
  padSlot.name = drag.name;
  padSlot.texture = drag.texture;
  padSlot.type = drag.type;
  drag.type = nil;
  PlaySound("igAbilityIconDrop");
end

function BindPadCore.IsCharacterSpecific()
  if BINDPAD_GENERAL_TAB ~= BindPadVars.tab then
    return true;
  end
  return false;
end

function BindPadCore.GetCharacterName(id)
  local character = GetRealmName().."_"..UnitName("player");
  if (BindPadVars.tab or 0) > BINDPAD_SPECIFIC_TAB then
    character = character.."_"..(BindPadVars.tab);
  end
  return character;
end

function BindPadCore.GetSlotInfo(id)
  if id == nil then
    return nil;
  end
  if BindPadCore.IsCharacterSpecific() then
    local character = BindPadCore.GetCharacterName(id);
    if nil == BindPadVars[character] then
      BindPadVars[character] = {};
    end
    if nil == BindPadVars[character][id] then
      BindPadVars[character][id] = {};
    end
    return BindPadVars[character][id];
  else
    if nil == BindPadVars[id] then
      BindPadVars[id] = {};
    end
    return BindPadVars[id];
  end
end

function BindPadCore.GetAllSlotInfo(gid)
  local id = (gid-1) % BINDPAD_MAXSLOTS + 1;
  if gid > BINDPAD_MAXSLOTS then
    local character = GetRealmName().."_"..UnitName("player");
    if gid > BINDPAD_MAXSLOTS * 2 then
      character = character.."_"..(math.floor((gid-1) / BINDPAD_MAXSLOTS) + 1);
    end
    if nil == BindPadVars[character] then
      BindPadVars[character] = {};
    end
    if nil == BindPadVars[character][id] then
      BindPadVars[character][id] = {};
    end
    return BindPadVars[character][id];
  else
    if nil == BindPadVars[id] then
      BindPadVars[id] = {};
    end
    return BindPadVars[id];
  end
end

function BindPadCore.PickupSlot(id)
  local padSlot = BindPadCore.GetSlotInfo(id);
  if "ITEM" == padSlot.type then
    PickupItem(padSlot.linktext);
  elseif "SPELL" == padSlot.type then
    local spellID = BindPadCore.FindSpellIdByName(padSlot.name, padSlot.rank, padSlot.bookType);
    if spellID then
      PickupSpell(spellID, padSlot.bookType);
    end
  elseif "MACRO" == padSlot.type then
    PickupMacro(padSlot.name);
  elseif "CLICK" == padSlot.type then
    if this == BindPadCore.selectedSlotButton then
      BindPadMacroPopupFrame:Hide();
      HideUIPanel(BindPadMacroTextFrame);
      BindPadBindFrame:Hide();
    end

    local drag = BindPadCore.dragswap;
    BindPadCore.dragswap = BindPadCore.drag;
    BindPadCore.drag = drag;

    drag.action = padSlot.action;
    drag.id = padSlot.id;
    drag.macrotext = padSlot.macrotext;
    drag.name = padSlot.name;
    drag.texture = padSlot.texture;
    drag.type = padSlot.type;

    BindPadCore.UpdateCursor();
    PlaySound("igAbilityIconPickup");
  end

  if (not IsModifierKeyDown()) or ("CLICK" == padSlot.type) then
    padSlot.action = nil;
    padSlot.bookType = nil;
    padSlot.id = nil;
    padSlot.linkText = nil;
    padSlot.macrotext = nil;
    padSlot.name = nil;
    padSlot.rank = nil;
    padSlot.texture = nil;
    padSlot.type = nil;
  end
end


function BindPadCore.BindKey()
  if not InCombatLockdown() then
    local padSlot = BindPadCore.selectedSlot;
    BindPadCore.UnbindSlot(padSlot);

    if "ITEM" == padSlot.type then
      SetBindingItem(BindPadCore.keyPressed, padSlot.name);
    elseif "SPELL" == padSlot.type then
      if padSlot.rank then
        SetBindingSpell(BindPadCore.keyPressed, padSlot.name.."("..padSlot.rank..")");
      else
        SetBindingSpell(BindPadCore.keyPressed, padSlot.name);
      end
    elseif "MACRO" == padSlot.type then
      SetBindingMacro(BindPadCore.keyPressed, padSlot.name);
    elseif "CLICK" == padSlot.type then
      SetBinding(BindPadCore.keyPressed, BindPadCore.CreateBindPadMacroAction(padSlot.id));
    end
  SaveBindings(GetCurrentBindingSet());
  else
    BindPadFrame_OutputText(BINDPAD_TEXT_CANNOT_BIND);
  end
end

function BindPadCore.UnbindSlot(padSlot)
  if not InCombatLockdown() then
    repeat
      local key = GetBindingKey(padSlot.action);
      if key then
        SetBinding(key);
      end
    until key == nil
    SaveBindings(GetCurrentBindingSet());
  end
end

function BindPadCore.GetSpellNum(bookType)
  local spellNum;
  if bookType == BOOKTYPE_PET then
    spellNum = HasPetSpells() or 0;
  else
    local _,_,offset,num = GetSpellTabInfo(GetNumSpellTabs());
    spellNum = offset+num;
  end
  return spellNum;
end

function BindPadCore.InitCash()
  for k,v in pairs(BindPadCore.IsHighestCash) do
    BindPadCore.IsHighestCash[k] = nil;
  end

end

function BindPadCore.IsHighestRank(spellID, bookType)
  local cash = BindPadCore.IsHighestCash[spellID.."_"..bookType];
  if cash ~= nil then
    return cash;
  end

  local srchSpellName, srchSpellRank = GetSpellName(spellID, bookType);
  for i = BindPadCore.GetSpellNum(bookType), 1, -1 do
    spellName, spellRank = GetSpellName(i, bookType);
    if spellName == srchSpellName then
      local result = (srchSpellRank == spellRank);
      BindPadCore.IsHighestCash[spellID.."_"..bookType] = result;
      return result;
    end
  end 
end

function BindPadCore.FindSpellIdByName(srchName, srchRank, bookType)
  for i = BindPadCore.GetSpellNum(bookType), 1, -1 do
    spellName, spellRank = GetSpellName(i, bookType);
    if spellName == srchName and (nil == srchRank or spellRank == srchRank) then
      return i;
    end
  end 
end

function BindPadCore.GetBindingText(name, prefix, returnAbbr)
  local modKeys = GetBindingText(name, prefix, nil);

  if ( returnAbbr ) then
    modKeys = gsub(modKeys, "CTRL", "c");
    modKeys = gsub(modKeys, "SHIFT", "s");
    modKeys = gsub(modKeys, "ALT", "a");
    modKeys = gsub(modKeys, "STRG", "st");
    modKeys = gsub(modKeys, "(%l)-(%l)-", "%1%2-");
    modKeys = gsub(modKeys, "Num Pad ", "#");
  end

  return modKeys;
end

function BindPadFrame_ChangeBindingProfile()
  if ( GetCurrentBindingSet() == 1 ) then
    LoadBindings(2);
    SaveBindings(2);
    BindPadFrameCharacterButton:SetChecked(true);
  else
    StaticPopup_Show("BINDPAD_CONFIRM_DELETING_CHARACTER_SPECIFIC_BINDINGS");
  end
end

function BindPadCore.GetActionCommand(actionSlot)
  local type, id, subType = GetActionInfo(actionSlot);
  local commandType, name;

  if type == "spell" then
    if id == 0 then
      -- When player is training new rank of the spell,
      -- two GetActionInfo events fired and 1st one returns invalid id from GetActionInfo.
      return nil;
    end
    commandType = "SPELL ";
    local spellName, spellRank = GetSpellName(id, subType);
    if BindPadCore.IsHighestRank(id, subType) then
      name = spellName;
    else
      name = spellName.."("..spellRank..")";
    end
  elseif type == "item" then
    commandType = "ITEM ";
    name,_ = GetItemInfo(id);
  elseif type == "macro" then
    commandType = "MACRO ";
    name,_ = GetMacroInfo(id);
  else
    return nil; 
  end

  if name then
    return commandType..name;
  end
end

function BindPadCore.UpdateHotkey(actionSlot, ...)
  local thisName = select(1, ...);
  if thisName == nil then
    return;
  end
  local thisButton = getglobal(thisName);
  local hotkey = getglobal(thisName.."HotKey") or thisButton.hotkey;
  local text = hotkey:GetText();
  local shown = not (not hotkey:IsShown());  -- true or false (it never be nil.)
  local textBefore, shownBefore;
  local textNew, shownNew;

  if (BindPadCore.hotkeyShownAfter[thisName] ~= nil) and
     (BindPadCore.hotkeyTextAfter[thisName] == text) then
    -- Revert back to original text if it is still my own autobinding text.
    textBefore = BindPadCore.hotkeyTextBefore[thisName];
    if BindPadCore.hotkeyShownAfter[thisName] == shown then
      shownBefore = BindPadCore.hotkeyShownBefore[thisName];
    end
  else
    -- Keep any text and stat if someone changed it.
    BindPadCore.hotkeyTextBefore[thisName] = text;
    BindPadCore.hotkeyShownBefore[thisName] = shown;
    textBefore = text;
    shownBefore = shown;
  end

  if (BindPadVars.showHotkey and
     (not shownBefore or textBefore == nil or textBefore == "" or textBefore == RANGE_INDICATOR)) then
    local command = BindPadCore.GetActionCommand(actionSlot);
    if command then
      local key = GetBindingKey(command);
      textNew = BindPadCore.GetBindingText(key, "KEY_", 1);
    end
  end

  if textNew == nil or textNew == "" then
    textNew = textBefore;
    shownNew = shownBefore;
    BindPadCore.hotkeyShownAfter[thisName] = nil;
  else
    shownNew = true;
    BindPadCore.hotkeyShownAfter[thisName] = true;
    BindPadCore.hotkeyTextAfter[thisName] = textNew;
  end

  if text ~= textNew then
    hotkey:SetText(textNew);
  end
  if textNew == RANGE_INDICATOR and text ~= RANGE_INDICATOR then
    hotkey:SetPoint("TOPLEFT", thisButton, "TOPLEFT", 1, -2);
  elseif textNew ~= RANGE_INDICATOR and text == RANGE_INDICATOR then
    hotkey:SetPoint("TOPLEFT", thisButton, "TOPLEFT", -2, -2);
  end
  if shown and not shownNew then
    hotkey:Hide();
  elseif not shown and shownNew then
    hotkey:Show();
  end

  -- Recursive call of UpdateHotkey.
  if select("#", ...) >= 2 then
    BindPadCore.UpdateHotkey(actionSlot, select(2, ...));
  end
end

function BindPadCore.AddActionButton(actionSlot, buttonName)
  local oldSlot = BindPadCore.actionButtonIds[buttonName];
  if oldSlot == actionSlot then
    return;
  elseif oldSlot ~= nil then
    local oldElement = BindPadCore.actionButtonNames[oldSlot];
    if type(oldElement) == "table" then
      for k,v in pairs(oldElement) do 
        if v == buttonName then
          tremove(oldElement, k);
        end
      end
    elseif oldElement == buttonName then
      BindPadCore.actionButtonNames[oldSlot] = nil;
    end
  end
  local element = BindPadCore.actionButtonNames[actionSlot];
  if type(element) == "table" then
    tinsert(element, buttonName);
  elseif type(element) == "string" then
    BindPadCore.actionButtonNames[actionSlot] = {element, buttonName};
  else
    BindPadCore.actionButtonNames[actionSlot] = buttonName;
  end
  BindPadCore.actionButtonIds[buttonName] = actionSlot;
end

function BindPadCore.GetActionButton(actionSlot)
  local element = BindPadCore.actionButtonNames[actionSlot];
  if type(element) == "table" then
    return unpack(element);
  else
    return element;
  end
end

function BindPadCore.UpdateAllHotKeys()
  for k,v in pairs(BindPadCore.actionButtonNames) do
    BindPadCore.UpdateHotkey(k, BindPadCore.GetActionButton(k));
  end
end

function BindPadFrame_ShowHotkeysToggle()
  BindPadVars.showHotkey = (this:GetChecked() == 1);

  BindPadCore.UpdateAllHotKeys();
end

function BindPadCore.GetActionTextureHook(actionSlot)
  if not this then return; end

  local thisName = this:GetName();
  if not thisName then return; end

  local hotkey = getglobal(thisName.."HotKey") or this.hotkey;
  if not hotkey then return; end

  BindPadCore.AddActionButton(actionSlot, thisName);

  -- Use a single shot of OnUpdate for intial update of hotkeys.
  BindPadUpdateFrame:Show();
end
-- As far as I know, GetActionTexture is only called by various ActionButtons.
hooksecurefunc("GetActionTexture", BindPadCore.GetActionTextureHook);


function BindPadCore.InitBindPadMacroButton()
  local gid;
  for gid = 1, BINDPAD_MAXSLOTS * 4, 1 do
    BindPadCore.UpdateMacroText(BindPadCore.GetAllSlotInfo(gid));
  end
end

function BindPadCore.UpdateMacroText(padSlot)
  if padSlot.macrotext ~= nil and padSlot.id ~= nil then
    local button = BindPadCore.GetBindPadMacroButton(padSlot.id);
    button:SetAttribute("macrotext", padSlot.macrotext);
  end
end

function BindPadCore.NewBindPadMacroID()
  local id;
  if BindPadCore.IsCharacterSpecific() then
    id = BINDPADMACRO_SPECIFIC_OFFSET;
  else
    id = 1;
  end
  while BindPadCore.bindpadmacro[id] ~= nil do
    id = id + 1;
  end

  return id;
end

function BindPadCore.GetBindPadMacroButton(id)
  local button = BindPadCore.bindpadmacro[id];
  if button == nil then
    local buttonName = "BindPadMacro"..id;

    button = getglobal(buttonName);
    if button == nil then
      button = CreateFrame("Button", buttonName, nil, "SecureActionButtonTemplate");
      button:SetAttribute("type", "macro");
    end

    BindPadCore.bindpadmacro[id] = button;
  end
  return button;
end

function BindPadCore.DeleteBindPadMacroID(id)
  BindPadCore.bindpadmacro[id] = nil;
end

function BindPadCore.UpdateCursor()
  local drag = BindPadCore.drag;
  if GetCursorInfo() then
    BindPadCore.ClearCursor();
  end
  if "CLICK" == drag.type then
    SetCursor(drag.texture);
  end
end

function BindPadCore.CreateBindPadMacroAction(id)
  return "CLICK "..BindPadCore.GetBindPadMacroButton(id):GetName()..":";
end

function BindPadCore.ConvertToBindPadMacro()
  local padSlot = BindPadCore.selectedSlot;

  if "ITEM" == padSlot.type then
    padSlot.type = "CLICK";
    padSlot.linktext = nil;
    padSlot.macrotext = "/use "..padSlot.name;

  elseif "SPELL" == padSlot.type then
    padSlot.type = "CLICK";
    if padSlot.rank == nil then
      padSlot.macrotext = "/cast "..padSlot.name;
    else
      padSlot.macrotext = "/cast "..padSlot.name.."("..padSlot.rank..")";
      padSlot.rank = nil;
    end

  elseif "MACRO" == padSlot.type then
    local name, texture, macrotext = GetMacroInfo(padSlot.name);
    padSlot.type = "CLICK";
    padSlot.macrotext = (macrotext or "");

  else
    return;
  end

  padSlot.id = BindPadCore.NewBindPadMacroID();
  padSlot.action = BindPadCore.CreateBindPadMacroAction(padSlot.id);

  BindPadSlot_UpdateState(BindPadCore.selectedSlotButton);
  BindPadMacroTextFrame_Open(BindPadCore.selectedSlotButton);
end

function BindPadCore.CursorHasIcon()
  return (GetCursorInfo() or BindPadCore.drag.type)
end

function BindPadCore.ClearCursor()
  local drag = BindPadCore.drag;
  if "CLICK" == drag.type then
    BindPadCore.DeleteBindPadMacroID(drag.id);
    ResetCursor();
    PlaySound("igAbilityIconDrop");
  end
  drag.type = nil;
end

function BindPadCore.GetBindingName(action)
  local text = GetBindingText(action, "BINDING_NAME_");

  if string.match(text, "^CLICK ") then
    local gid;
    for gid = 1, BINDPAD_MAXSLOTS * 4, 1 do
      local padSlot = BindPadCore.GetAllSlotInfo(gid);
      if padSlot.action == text then
        return format(BINDPAD_TOOLTIP_BINDPADMACRO, padSlot.id, padSlot.name);
      end
    end
  end

  return text;
end
