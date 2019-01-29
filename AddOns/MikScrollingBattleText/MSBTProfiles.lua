-------------------------------------------------------------------------------
-- Title: Mik's Scrolling Battle Text Profiles
-- Author: Mik
-------------------------------------------------------------------------------

-- Create module and set its name.
local module = {};
local moduleName = "Profiles";
MikSBT[moduleName] = module;


-------------------------------------------------------------------------------
-- Private constants.
-------------------------------------------------------------------------------

local DEFAULT_PROFILE_NAME = "Default";

-- The .toc entries for saved variables.
local SAVED_VARS_NAME			= "MSBTProfiles_SavedVars";
local SAVED_VARS_PER_CHAR_NAME	= "MSBTProfiles_SavedVarsPerChar";

-- Localized pet name followed by a space.
local PET_SPACE = PET .. " ";

-- Flags used by the combat log.
local FLAG_YOU 			= 0xF0000000;
local TARGET_TARGET		= 0x00010000;
local REACTION_HOSTILE	= 0x00000040;


-- Spell IDs.
local SPELLID_COUNTER_ATTACK	= 19306;
local SPELLID_EXECUTE			= 5308;
local SPELLID_FIRST_AID			= 3273;
local SPELLID_HAMMER_OF_WRATH	= 24275;
local SPELLID_KILL_COMMAND		= 34026;
local SPELLID_MONGOOSE_BITE		= 1495;
local SPELLID_RAMPAGE			= 29801;
local SPELLID_REVENGE			= 6572;
local SPELLID_RIPOSTE			= 14251;
local SPELLID_OVERPOWER			= 7384;
local SPELLID_VICTORY_RUSH		= 34428

-- Spell names.
local SPELL_BACKLASH			= GetSpellInfo(34935);
local SPELL_BLACKOUT			= GetSpellInfo(15268);
local SPELL_CLEARCASTING		= GetSpellInfo(12536);
local SPELL_COUNTER_ATTACK		= GetSpellInfo(SPELLID_COUNTER_ATTACK);
local SPELL_EXECUTE				= GetSpellInfo(SPELLID_EXECUTE);
local SPELL_FROSTBITE			= GetSpellInfo(11071);
local SPELL_HAMMER_OF_WRATH		= GetSpellInfo(SPELLID_HAMMER_OF_WRATH);
local SPELL_IMPACT				= GetSpellInfo(11103);
local SPELL_KILL_COMMAND		= GetSpellInfo(SPELLID_KILL_COMMAND);
local SPELL_MONGOOSE_BITE		= GetSpellInfo(SPELLID_MONGOOSE_BITE);
local SPELL_NIGHTFALL			= GetSpellInfo(18094);
local SPELL_SHADOW_TRANCE		= GetSpellInfo(17941);
local SPELL_RAMPAGE				= GetSpellInfo(SPELLID_RAMPAGE);
local SPELL_REVENGE				= GetSpellInfo(SPELLID_REVENGE);
local SPELL_RIPOSTE				= GetSpellInfo(SPELLID_RIPOSTE);
local SPELL_OVERPOWER			= GetSpellInfo(SPELLID_OVERPOWER);
local SPELL_VICTORY_RUSH		= GetSpellInfo(SPELLID_VICTORY_RUSH);
local SPELL_DRAIN_LIFE			= GetSpellInfo(689);
local SPELL_MANA_SPRING			= GetSpellInfo(5677);
local SPELL_SHADOWMEND			= GetSpellInfo(39373);
local SPELL_SIPHON_LIFE			= GetSpellInfo(18265);
local SPELL_REFLECTIVE_SHIELD	= GetSpellInfo(33201);
local SPELL_VAMPIRIC_EMBRACE	= GetSpellInfo(15286);
local SPELL_VAMPIRIC_TOUCH		= GetSpellInfo(34914);
local SPELL_VIPER_STING			= GetSpellInfo(3034);


-------------------------------------------------------------------------------
-- Private variables.
-------------------------------------------------------------------------------

-- Meta table for the differential profile tables.
local differentialMap = {};
local differential_mt = { __index = function(t,k) return differentialMap[t][k] end };
local differentialCache = {};

-- Holds variables to be saved between sessions.
local savedVariables;
local savedVariablesPerChar;

-- Currently selected profile.
local currentProfile;

-- Path information for setting differential options.
local pathTable = {};


-------------------------------------------------------------------------------
-- Imports.
-------------------------------------------------------------------------------

-- Local references to certain MSBT modules for faster access.
local L = MikSBT.translations;

-- Local references to certain functions for faster access.
local string_find = string.find;
local string_gsub = string.gsub;
local CopyTable = MikSBT.CopyTable;
local EraseTable = MikSBT.EraseTable;
local SplitString = MikSBT.SplitString;
local Print = MikSBT.Print;


-------------------------------------------------------------------------------
-- Master profile.
-------------------------------------------------------------------------------

local masterProfile = {
 scrollAreas = {
  Incoming = {
   name					= L.MSG_INCOMING,
   offsetX				= -140,
   offsetY				= -160,
   animationStyle		= "Parabola",
   direction			= "Down",
   behavior				= "CurvedLeft",
   stickyBehavior		= "Jiggle",
   textAlignIndex		= 3,
   stickyTextAlignIndex	= 3,
  },
  Outgoing = {
   name					= L.MSG_OUTGOING,
   offsetX				= 100,
   offsetY				= -160,
   animationStyle		= "Parabola",
   direction			= "Down",
   behavior				= "CurvedRight",
   stickyBehavior		= "Jiggle",
   textAlignIndex		= 1,
   stickyTextAlignIndex	= 1,
  },
  Notification = {
   name					= L.MSG_NOTIFICATION,
   offsetX				= -175,
   offsetY				= 120,
   scrollHeight			= 200,
   scrollWidth			= 350,
  },
  Static = {
   name					= L.MSG_STATIC,
   offsetX				= -20,
   offsetY				= -300,
   scrollHeight			= 125,
   animationStyle		= "Static",
   direction			= "Down",
   normalFontName		= "Yellowjacket",
   normalFontSize		= 20,
  },
 },

 
 events = {
  INCOMING_DAMAGE = {
   colorG		= 0,
   colorB		= 0,
   message		= "(%n) -%a",
   scrollArea	= "Incoming",
  },
  INCOMING_DAMAGE_CRIT = {
   colorG		= 0,
   colorB		= 0,
   message		= "(%n) -%a",
   scrollArea	= "Incoming",
   isCrit		= true,
  },
  INCOMING_MISS = {
   colorR		= 0,
   colorG		= 0,
   message		= MISS .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_DODGE = {
   colorR		= 0,
   colorG		= 0,
   message		= DODGE .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_PARRY = {
   colorR		= 0,
   colorG		= 0,
   message		= PARRY .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_BLOCK	= {
   colorR		= 0,
   colorG		= 0,
   message		= BLOCK .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_ABSORB = {
   colorB		= 0,
   message		= ABSORB .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_IMMUNE = {
   colorB		= 0,
   message		= IMMUNE .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_DAMAGE = {
   colorG		= 0,
   colorB		= 0,
   message		= "(%s) -%a",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_DAMAGE_CRIT = {
   colorG		= 0,
   colorB		= 0,
   message		= "(%s) -%a",
   scrollArea	= "Incoming",
   isCrit		= true,
  },
  INCOMING_SPELL_DOT = {
   colorG		= 0,
   colorB		= 0,
   message		= "(%s) -%a",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_MISS = {
   colorR		= 0,
   colorG		= 0,
   message		= "(%s) " .. MISS .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_DODGE = {
   colorR		= 0,
   colorG		= 0,
   message		= "(%s) " .. DODGE .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_PARRY = {
   colorR		= 0,
   colorG		= 0,
   message		= "(%s) " .. PARRY .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_BLOCK = {
   colorR		= 0,
   colorG		= 0,
   message		= "(%s) " .. BLOCK  .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_RESIST = {
   colorR		= 0.5,
   colorG		= 0,
   colorB		= 0.5,
   message		= "(%s) " .. RESIST .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_ABSORB = {
   colorB		= 0,
   message		= "(%s) " .. ABSORB .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_IMMUNE = {
   colorB		= 0,
   message		= "(%s) " .. IMMUNE .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_REFLECT = {
   colorR		= 0.5,
   colorG		= 0,
   colorB		= 0.5,
   message		= "(%s - %a) " .. REFLECT .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_SPELL_INTERRUPT = {
   colorB		= 0,
   message		= "(%s) " .. INTERRUPT .. "!",
   scrollArea	= "Incoming",
  },
  INCOMING_HEAL = {
   colorR		= 0,
   colorB		= 0,
   message		= "(%s - %n) +%a",
   scrollArea	= "Incoming",
  },
  INCOMING_HEAL_CRIT = {
   colorR		= 0,
   colorB		= 0,
   message		= "(%s - %n) +%a",
   fontSize		= 22,
   scrollArea	= "Incoming",
   isCrit		= true,
  },
  INCOMING_HOT = {
   colorR		= 0,
   colorB		= 0,
   message		= "(%s - %n) +%a",
   scrollArea	= "Incoming",
  },
  INCOMING_ENVIRONMENTAL = {
   colorG		= 0,
   colorB		= 0,
   message		= "-%a %e",
   scrollArea	= "Incoming",
  },


  OUTGOING_DAMAGE = {
   message		= "%a",
   scrollArea	= "Outgoing",
  },
  OUTGOING_DAMAGE_CRIT = {
   message		= "%a",
   scrollArea	= "Outgoing",
   isCrit		= true,
  },
  OUTGOING_MISS = {
   message		= MISS .. "!",
   scrollArea	= "Outgoing",
  },
  OUTGOING_DODGE = {
   message		= DODGE .. "!",
   scrollArea	= "Outgoing",
  },
  OUTGOING_PARRY = {
   message		= PARRY .. "!",
   scrollArea	= "Outgoing",
  },
  OUTGOING_BLOCK = {
   message		= BLOCK .. "!",
   scrollArea	= "Outgoing",
  },
  OUTGOING_ABSORB = {
   colorB		= 0,
   message		= ABSORB .. "!",
   scrollArea	= "Outgoing",
  },
  OUTGOING_IMMUNE = {
   colorB		= 0,
   message		= IMMUNE .. "!",
   scrollArea	= "Outgoing",
  },
  OUTGOING_EVADE = {
   colorG		= 0.5,
   colorB		= 0,
   message		= EVADE .. "!",
   fontSize		= 22,
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_DAMAGE = {
   colorB		= 0,
   message		= "%a (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_DAMAGE_CRIT = {
   colorB		= 0,
   message		= "%a (%s)",
   scrollArea	= "Outgoing",
   isCrit		= true,
  },
  OUTGOING_SPELL_DOT = {
   colorB		= 0,
   message		= "%a (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_MISS = {
   message		= MISS .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_DODGE = {
   message		= DODGE .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_PARRY = {
   message		= PARRY .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_BLOCK = {
   message		= BLOCK .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_RESIST = {
   colorR		= 0.5,
   colorG		= 0.5,
   colorB		= 0.698,
   message		= RESIST .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_ABSORB = {
   colorB		= 0,
   message		= ABSORB .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_IMMUNE = {
   colorB		= 0,
   message		= IMMUNE .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_REFLECT = {
   colorB		= 0,
   message		= REFLECT .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_INTERRUPT = {
   colorB		= 0,
   message		= INTERRUPT .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_SPELL_EVADE = {
   colorG		= 0.5,
   colorB		= 0,
   message		= EVADE .. "! (%s)",
   fontSize		= 22,
   scrollArea	= "Outgoing",
  },
  OUTGOING_HEAL = {
   colorR		= 0,
   colorB		= 0,
   message		= "+%a (%s - %n)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_HEAL_CRIT = {
   colorR		= 0,
   colorB		= 0,
   message		= "+%a (%s - %n)",
   fontSize		= 22,
   scrollArea	= "Outgoing",
   isCrit		= true,
  },
  OUTGOING_HOT = {
   colorR		= 0,
   colorB		= 0,
   message		= "+%a (%s - %n)",
   scrollArea	= "Outgoing",
  },
  OUTGOING_DISPEL = {
   colorB		= 0.5,
   message		= L.MSG_DISPEL .. "! (%s)",
   scrollArea	= "Outgoing",
  },


  PET_INCOMING_DAMAGE = {
   colorG		= 0.41,
   colorB		= 0.41,
   message		= "(%n) " .. PET .. " -%a",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_DAMAGE_CRIT = {
   colorG		= 0.41,
   colorB		= 0.41,
   message		= "(%n) " .. PET .. " -%a",
   scrollArea	= "Incoming",
   isCrit		= true,
  },
  PET_INCOMING_MISS = {
   colorR		= 0.57,
   colorG		= 0.58,
   message		= PET .. " " .. MISS .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_DODGE = {
   colorR		= 0.57,
   colorG		= 0.58,
   message		= PET .. " " .. DODGE .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_PARRY = {
   colorR		= 0.57,
   colorG		= 0.58,
   message		= PET .. " " .. PARRY .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_BLOCK	= {
   colorR		= 0.57,
   colorG		= 0.58,
   message		= PET .. " " .. BLOCK .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_ABSORB = {
   colorB		= 0.57,
   message		= PET .. " " .. ABSORB .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_IMMUNE = {
   colorB		= 0.57,
   message		= PET .. " " .. IMMUNE .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_SPELL_DAMAGE = {
   colorG		= 0.41,
   colorB		= 0.41,
   message		= "(%s) " .. PET .. " -%a",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_SPELL_DAMAGE_CRIT = {
   colorG		= 0.41,
   colorB		= 0.41,
   message		= "(%s) " .. PET .. " -%a",
   scrollArea	= "Incoming",
   isCrit		= true,
  },
  PET_INCOMING_SPELL_DOT = {
   colorG		= 0.41,
   colorB		= 0.41,
   message		= "(%s) " .. PET .. " -%a",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_SPELL_MISS = {
   colorR		= 0.57,
   colorG		= 0.58,
   message		= "(%s) " .. PET .. " " .. MISS .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_SPELL_DODGE = {
   colorR		= 0.57,
   colorG		= 0.58,
   message		= "(%s) " .. PET .. " " .. DODGE .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_SPELL_PARRY = {
   colorR		= 0.57,
   colorG		= 0.58,
   message		= "(%s) " .. PET .. " " .. PARRY .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_SPELL_BLOCK = {
   colorR		= 0.57,
   colorG		= 0.58,
   message		= "(%s) " .. PET .. " " .. BLOCK  .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_SPELL_RESIST = {
   colorR		= 0.94,
   colorG		= 0,
   colorB		= 0.94,
   message		= "(%s) " .. PET .. " " .. RESIST .. "!",
   scrollArea		= "Incoming",
  },
  PET_INCOMING_SPELL_ABSORB = {
   colorB		= 0.57,
   message		= "(%s) " .. PET .. " " .. ABSORB .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_SPELL_IMMUNE = {
   colorB		= 0.57,
   message		= "(%s) " .. PET .. " " .. IMMUNE .. "!",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_HEAL = {
   colorR		= 0.57,
   colorB		= 0.57,
   message		= "(%s - %n) " .. PET .. " +%a",
   scrollArea	= "Incoming",
  },
  PET_INCOMING_HEAL_CRIT = {
   colorR		= 0.57,
   colorB		= 0.57,
   message		= "(%s - %n) " .. PET .. " +%a",
   scrollArea	= "Incoming",
   isCrit		= true,
  },
  PET_INCOMING_HOT = {
   colorR		= 0.57,
   colorB		= 0.57,
   message		= "(%s - %n) " .. PET .. " +%a",
   scrollArea	= "Incoming",
  },


  PET_OUTGOING_DAMAGE = {
   colorG		= 0.5,
   colorB		= 0,
   message		= PET .. " %a",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_DAMAGE_CRIT = {
   colorG		= 0.5,
   colorB		= 0,
   message		= PET .. " %a",
   scrollArea	= "Outgoing",
   isCrit		= true,
  },
  PET_OUTGOING_MISS = {
   colorG		= 0.5,
   colorB		= 0,
   message		= PET .. " " .. MISS,
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_DODGE = {
   colorG		= 0.5,
   colorB		= 0,
   message		= PET .. " " .. DODGE,
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_PARRY = {
   colorG		= 0.5,
   colorB		= 0,
   message		= PET .. " " .. PARRY,
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_BLOCK = {
   colorG		= 0.5,
   colorB		= 0,
   message		= PET .. " " .. BLOCK,
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_ABSORB = {
   colorR		= 0.5,
   colorG		= 0.5,
   message		= PET .. " " .. ABSORB,
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_IMMUNE = {
   colorR		= 0.5,
   colorG		= 0.5,
   message		= PET .. " " .. IMMUNE,
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_EVADE = {
   colorG		= 0.77,
   colorB		= 0.57,
   message		= PET .. " " .. EVADE,
   fontSize		= 22,
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_DAMAGE = {
   colorR		= 0.33,
   colorG		= 0.33,
   message		= PET .. " %a (%s)",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_DAMAGE_CRIT = {
   colorR		= 0.33,
   colorG		= 0.33,
   message		= PET .. " %a (%s)",
   scrollArea	= "Outgoing",
   isCrit		= true,
  },
  PET_OUTGOING_SPELL_DOT = {
   colorR		= 0.33,
   colorG		= 0.33,
   message		= PET .. " %a (%s)",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_MISS	 = {
   colorR		= 0.33,
   colorG		= 0.33,
   message		= PET .. " " .. MISS .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_DODGE = {
   colorR		= 0.33,
   colorG		= 0.33,
   message		= PET .. " " .. DODGE .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_PARRY = {
   colorR		= 0.33,
   colorG		= 0.33,
   message		= PET .. " " .. PARRY .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_BLOCK = {
   colorR		= 0.33,
   colorG		= 0.33,
   message		= PET .. " " .. BLOCK .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_RESIST = {
   colorR		= 0.73,
   colorG		= 0.73,
   colorB		= 0.84,
   message		= PET .. " " .. RESIST .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_ABSORB = {
   colorR		= 0.5,
   colorG		= 0.5,
   message		= PET .. " " .. ABSORB .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_IMMUNE = {
   colorR		= 0.5,
   colorG		= 0.5,
   message		= PET .. " " .. IMMUNE .. "! (%s)",
   scrollArea	= "Outgoing",
  },
  PET_OUTGOING_SPELL_EVADE = {
   colorG		= 0.77,
   colorB		= 0.57,
   message		= PET .. " " .. EVADE .. "! (%s)",
   scrollArea	= "Outgoing",
  }, 
  PET_OUTGOING_DISPEL = {
   colorB		= 0.73,
   message		= PET .. " " .. L.MSG_DISPEL .. "! (%s)",
   scrollArea	= "Outgoing",
  },


  NOTIFICATION_DEBUFF = {
   colorR		= 0,
   colorG		= 0.5,
   colorB		= 0.5,
   message		= "[%sl]",
  },
  NOTIFICATION_BUFF = {
   colorR		= 0.698,
   colorG		= 0.698,
   colorB		= 0,
   message		= "[%sl]",
  },
  NOTIFICATION_ITEM_BUFF = {
   colorR		= 0.698,
   colorG		= 0.698,
   colorB		= 0.698,
   message		= "[%sl]",
  },
  NOTIFICATION_DEBUFF_FADE = {
   colorR		= 0,
   colorG		= 0.835,
   colorB		= 0.835,
   message		= "-[%sl]",
  },
  NOTIFICATION_BUFF_FADE = {
   colorR		= 0.918,
   colorG		= 0.918,
   colorB		= 0,
   message		= "-[%sl]",
  },
  NOTIFICATION_ITEM_BUFF_FADE = {
   colorR		= 0.831,
   colorG		= 0.831,
   colorB		= 0.831,
   message		= "-[%sl]",
  },
  NOTIFICATION_COMBAT_ENTER = {
   message		= "+" .. L.MSG_COMBAT,
  },
  NOTIFICATION_COMBAT_LEAVE = {
   message		= "-" .. L.MSG_COMBAT,
  },
  NOTIFICATION_POWER_GAIN = {
   colorB		= 0,
   message		= "+%a %p",
  },
  NOTIFICATION_POWER_LOSS = {
   colorB		= 0,
   message		= "-%a %p",
  },
  NOTIFICATION_CP_GAIN = {
   colorG		= 0.5,
   colorB		= 0,
   message		= "%a " .. L.MSG_CP,
  },
  NOTIFICATION_CP_FULL = {
   colorG		= 0.5,
   colorB		= 0,
   message		= L.MSG_CP_FULL .. "!",
   alwaysSticky	= true,
   fontSize		= 26,
  },
  NOTIFICATION_HONOR_GAIN = {
   colorR		= 0.5,
   colorG		= 0.5,
   colorB		= 0.698,
   message		= "+%a " .. HONOR,
  },
  NOTIFICATION_REP_GAIN = {
   colorR		= 0.5,
   colorG		= 0.5,
   colorB		= 0.698,
   message		= "+%a " .. REPUTATION .. " (%e)",
  },
  NOTIFICATION_REP_LOSS = {
   colorR		= 0.5,
   colorG		= 0.5,
   colorB		= 0.698,
   message		= "-%a " .. REPUTATION .. " (%e)",
  },
  NOTIFICATION_SKILL_GAIN = {
   colorR		= 0.333,
   colorG		= 0.333,
   message		= "%sl: %a",
  },
  NOTIFICATION_EXPERIENCE_GAIN = {
   disabled		= true,
   colorR		= 0.756,
   colorG		= 0.270,
   colorB		= 0.823,
   message		= "%a " .. XP,
   alwaysSticky	= true,
   fontSize		= 26,
  },
  NOTIFICATION_PC_KILLING_BLOW = {
   colorR		= 0.333,
   colorG		= 0.333,
   message		= L.MSG_KILLING_BLOW .. "! (%e)",
   alwaysSticky	= true,
   fontSize		= 26,
  },
  NOTIFICATION_NPC_KILLING_BLOW = {
   disabled		= true,
   colorR		= 0.333,
   colorG		= 0.333,
   message		= L.MSG_KILLING_BLOW .. "! (%e)",
   alwaysSticky	= true,
   fontSize		= 26,
  },
  NOTIFICATION_SOUL_SHARD_CREATED = {
   colorR		= 0.628,
   colorG		= 0,
   colorB		= 0.628,
   message		= "+%e",
   alwaysSticky	= true,
   fontSize		= 26,
  },
  NOTIFICATION_EXTRA_ATTACK = {
   colorB		= 0,
   message		= "%sl!",
   alwaysSticky	= true,
   fontSize		= 26,
  },
  NOTIFICATION_ENEMY_BUFF = {
   colorB		= 0.5,
   message		= "%n: [%sl]",
   scrollArea	= "Static",
  },
  NOTIFICATION_MONSTER_EMOTE = {
   colorG		= 0.5,
   colorB		= 0,
   message		= "%e",
   scrollArea	= "Static",
  },
  NOTIFICATION_MONEY = {
   message		= "+%e",
   scrollArea	= "Static",
  },
  NOTIFICATION_COOLDOWN = {
   message		= "%e " .. L.MSG_READY_NOW .. "!",
   scrollArea	= "Static",
   fontSize		= 22,
  },
 }, -- End events

 
 triggers = {
  MSBT_TRIGGER_BACKLASH = {
   colorR			= 0.709,
   colorG			= 0,
   colorB			= 0.709,
   message			= SPELL_BACKLASH .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "WARLOCK",
   mainEvents		= "SPELL_AURA_APPLIED{skillName;;eq;;" .. SPELL_BACKLASH .. ";;recipientAffiliation;;eq;;" .. FLAG_YOU .. "}",
  },
  MSBT_TRIGGER_BLACKOUT = {
   colorR			= 0.709,
   colorG			= 0,
   colorB			= 0.709,
   message			= SPELL_BLACKOUT .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "PRIEST",
   mainEvents		= "SPELL_AURA_APPLIED{skillName;;eq;;" .. SPELL_BLACKOUT .. ";;recipientAffiliation;;eq;;" .. TARGET_TARGET .. "}"
  },
  MSBT_TRIGGER_CLEARCASTING = {
   colorB			= 0,
   message			= SPELL_CLEARCASTING .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "DRUID,MAGE,SHAMAN",
   mainEvents		= "SPELL_AURA_APPLIED{skillName;;eq;;" .. SPELL_CLEARCASTING .. ";;recipientAffiliation;;eq;;" .. FLAG_YOU .. "}",
  },
  MSBT_TRIGGER_COUNTER_ATTACK = {
   colorB			= 0,
   message			= SPELL_COUNTER_ATTACK .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "HUNTER",
   mainEvents		= "GENERIC_MISSED{recipientAffiliation;;eq;;" .. FLAG_YOU .. ";;missType;;eq;;PARRY}",
   exceptions		= "unavailableSkill;;eq;;" .. SPELL_COUNTER_ATTACK,
   iconSkill		= SPELLID_COUNTER_ATTACK,
  },
  MSBT_TRIGGER_EXECUTE = {
   colorB			= 0,
   message			= SPELL_EXECUTE .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "WARRIOR",
   mainEvents		= "UNIT_HEALTH{unitID;;eq;;target;;threshold;;lt;;20;;unitReaction;;eq;;" .. REACTION_HOSTILE .. "}",
   exceptions		= "unavailableSkill;;eq;;" .. SPELL_EXECUTE,
   iconSkill		= SPELLID_EXECUTE,
  },
  MSBT_TRIGGER_FROSTBITE = {
   colorR			= 0,
   colorG			= 0.5,
   message			= SPELL_FROSTBITE .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "MAGE",
   mainEvents		= "SPELL_AURA_APPLIED{skillName;;eq;;" .. SPELL_FROSTBITE .. ";;recipientAffiliation;;eq;;" .. TARGET_TARGET .. "}"
  },
  MSBT_TRIGGER_HAMMER_OF_WRATH = {
   colorB			= 0,
   message			= SPELL_HAMMER_OF_WRATH .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "PALADIN",
   mainEvents		= "UNIT_HEALTH{unitID;;eq;;target;;threshold;;lt;;20;;unitReaction;;eq;;" .. REACTION_HOSTILE .. "}",
   exceptions		= "unavailableSkill;;eq;;" .. SPELL_HAMMER_OF_WRATH,
   iconSkill		= SPELLID_HAMMER_OF_WRATH,
  },
  MSBT_TRIGGER_IMPACT = {
   colorG			= 0.25,
   colorB			= 0.25,
   message			= SPELL_IMPACT .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "MAGE",
   mainEvents		= "SPELL_AURA_APPLIED{skillName;;eq;;" .. SPELL_IMPACT .. ";;recipientAffiliation;;eq;;" .. TARGET_TARGET .. "}"
  },
  MSBT_TRIGGER_KILL_COMMAND = {
   colorB			= 0,
   message			= SPELL_KILL_COMMAND .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "HUNTER",
   mainEvents		= "GENERIC_DAMAGE{sourceAffiliation;;eq;;" .. FLAG_YOU .. ";;isCrit;;eq;;true}",
   exceptions		= "unavailableSkill;;eq;;" .. SPELL_KILL_COMMAND;
   iconSkill		= SPELLID_KILL_COMMAND,
  },
  MSBT_TRIGGER_LOW_HEALTH = {
   colorG			= 0.5,
   colorB			= 0.5,
   message			= L.MSG_TRIGGER_LOW_HEALTH .. "! (%a)",
   alwaysSticky		= true,
   fontSize			= 26,
   soundFile		= "LowHealth",
   mainEvents		= "UNIT_HEALTH{unitID;;eq;;player;;threshold;;lt;;35}",
   exceptions		= "recentlyFired;;lt;;5",
   iconSkill		= SPELLID_FIRST_AID,
  },
  MSBT_TRIGGER_LOW_MANA = {
   colorR			= 0.5,
   colorG			= 0.5,
   message			= L.MSG_TRIGGER_LOW_MANA .. "! (%a)",
   alwaysSticky		= true,
   fontSize			= 26,
   soundFile		= "LowMana",
   classes			= "DRUID,HUNTER,MAGE,PALADIN,PRIEST,SHAMAN,WARLOCK",
   mainEvents		= "UNIT_MANA{unitID;;eq;;player;;threshold;;lt;;35}",
   exceptions		= "recentlyFired;;lt;;5",
  },
  MSBT_TRIGGER_LOW_PET_HEALTH = {
   colorG			= 0.5,
   colorB			= 0.5,
   message			= L.MSG_TRIGGER_LOW_PET_HEALTH .. "! (%a)",
   fontSize			= 26,
   classes			= "HUNTER,MAGE,WARLOCK",
   mainEvents		= "UNIT_HEALTH{unitID;;eq;;pet;;threshold;;lt;;40}",
   exceptions		= "recentlyFired;;lt;;5",
  },
  MSBT_TRIGGER_MONGOOSE_BITE = {
   colorB			= 0,
   message			= SPELL_MONGOOSE_BITE .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "HUNTER",
   mainEvents		= "GENERIC_MISSED{recipientAffiliation;;eq;;" .. FLAG_YOU .. ";;missType;;eq;;DODGE}",
   exceptions		= "unavailableSkill;;eq;;" .. SPELL_MONGOOSE_BITE,
   iconSkill		= SPELLID_MONGOOSE_BITE,
  },
  MSBT_TRIGGER_NIGHTFALL = {
   colorR			= 0.709,
   colorG			= 0,
   colorB			= 0.709,
   message			= SPELL_NIGHTFALL .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "WARLOCK",
   mainEvents		= "SPELL_AURA_APPLIED{skillName;;eq;;" .. SPELL_SHADOW_TRANCE .. ";;recipientAffiliation;;eq;;" .. FLAG_YOU .. "}",
  },
  MSBT_TRIGGER_RAMPAGE = {
   colorG			= 0.25,
   colorB			= 0.25,
   message			= SPELL_RAMPAGE .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "WARRIOR",
   mainEvents		= "GENERIC_DAMAGE{sourceAffiliation;;eq;;" .. FLAG_YOU .. ";;isCrit;;eq;;true}",
   exceptions		= "unavailableSkill;;eq;;" .. SPELL_RAMPAGE .. ";;buffActive;;eq;;" .. SPELL_RAMPAGE .. ";;currentPower;;lt;;20",
   iconSkill		= SPELLID_RAMPAGE,
  },
  MSBT_TRIGGER_REVENGE = {
   colorB			= 0,
   message			= SPELL_REVENGE .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "WARRIOR",
   mainEvents		= "GENERIC_MISSED{recipientAffiliation;;eq;;" .. FLAG_YOU .. ";;missType;;eq;;BLOCK}&&GENERIC_MISSED{recipientAffiliation;;eq;;" .. FLAG_YOU .. ";;missType;;eq;;DODGE}&&GENERIC_MISSED{recipientAffiliation;;eq;;" .. FLAG_YOU .. ";;missType;;eq;;PARRY}",
   exceptions		= "warriorStance;;ne;;2;;unavailableSkill;;eq;;" .. SPELL_REVENGE .. ";;recentlyFired;;lt;;2",
   iconSkill		= SPELLID_REVENGE,
  },
  MSBT_TRIGGER_RIPOSTE = {
   colorB			= 0,
   message			= SPELL_RIPOSTE .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "ROGUE",
   mainEvents		= "GENERIC_MISSED{recipientAffiliation;;eq;;" .. FLAG_YOU .. ";;missType;;eq;;PARRY}",
   exceptions		= "unavailableSkill;;eq;;" .. SPELL_RIPOSTE,
   iconSkill		= SPELLID_RIPOSTE,
  },
  MSBT_TRIGGER_OVERPOWER = {
   colorB			= 0,
   message			= SPELL_OVERPOWER .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "WARRIOR",
   mainEvents		= "GENERIC_MISSED{sourceAffiliation;;eq;;" .. FLAG_YOU .. ";;missType;;eq;;DODGE}",
   exceptions		= "unavailableSkill;;eq;;" .. SPELL_OVERPOWER,
   iconSkill		= SPELLID_OVERPOWER,
  },
  MSBT_TRIGGER_VICTORY_RUSH = {
   colorG			= 0.25,
   colorB			= 0.25,
   message			= SPELL_VICTORY_RUSH .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "WARRIOR",
   mainEvents		= "PARTY_KILL{sourceAffiliation;;eq;;" .. FLAG_YOU .. "}",
   exceptions		= "unavailableSkill;;eq;;" .. SPELL_VICTORY_RUSH .. ";;trivialTarget;;eq;;true",
   iconSkill		= SPELLID_VICTORY_RUSH,
  },
  MSBT_TRIGGER_VIPER_STING = {
   colorR			= 0,
   colorG			= 0,
   message			= SPELL_VIPER_STING .. "!",
   alwaysSticky		= true,
   fontSize			= 26,
   classes			= "DRUID,HUNTER,MAGE,PALADIN,PRIEST,SHAMAN,WARLOCK",
   mainEvents		= "SPELL_AURA_APPLIED{skillName;;eq;;" .. SPELL_VIPER_STING .. ";;recipientAffiliation;;eq;;" .. FLAG_YOU .. "}",
  },
 }, -- End triggers


 -- Master font settings.
 normalFontName		= "Default",
 normalOutlineIndex	= 2,
 normalFontSize		= 18,
 normalFontAlpha	= 100,
 critFontName		= "Default",
 critOutlineIndex	= 2,
 critFontSize		= 26,
 critFontAlpha		= 100,


 -- Animation speed. 
 animationSpeed		= 100,
 
  
 -- Partial effect settings. 
 crushing		= { colorR = 0.5, colorG = 0, colorB = 0, trailer = CRUSHING_TRAILER },
 glancing		= { colorR = 1, colorG = 0, colorB = 0, trailer = GLANCING_TRAILER },
 absorb			= { colorR = 1, colorG = 1, colorB = 0, trailer = ABSORB_TRAILER },
 block			= { colorR = 0.5, colorG = 0, colorB = 1, trailer = BLOCK_TRAILER },
 resist			= { colorR = 0.5, colorG = 0, colorB = 0.5, trailer = RESIST_TRAILER },
 overheal		= { colorR = 0, colorG = 0.705, colorB = 0.5, trailer = " <%d>" },
 
 
 -- Damage color settings.
 physical	= { colorR = 1, colorG = 1, colorB = 1 },
 holy		= { colorR = 1, colorG = 1, colorB = 0.627 },
 fire		= { colorR = 1, colorG = 0.5, colorB = 0.5 },
 nature		= { colorR = 0.5, colorG = 1, colorB = 0.5 },
 frost		= { colorR = 0.5, colorG = 0.5, colorB = 1 },
 shadow		= { colorR = 0.628, colorG = 0, colorB = 0.628 },
 arcane		= { colorR = 1, colorG = 0.725, colorB = 1 },

 
 -- Throttle settings.
 dotThrottleDuration	= 3,
 hotThrottleDuration	= 3,
 powerThrottleDuration	= 0,
 throttleList = {
  [SPELL_DRAIN_LIFE]		= 3,
  [SPELL_MANA_SPRING]		= 5,
  [SPELL_SHADOWMEND]		= 5,
  [SPELL_SIPHON_LIFE]		= 3,
  [SPELL_REFLECTIVE_SHIELD]	= 5,
  [SPELL_VAMPIRIC_EMBRACE]	= 5,
  [SPELL_VAMPIRIC_TOUCH]	= 5,
 },

 
 -- Spam control settings.
 mergeExclusions		= {},
 abilitySubstitutions	= {},
 abilitySuppressions	= {},
 damageThreshold		= 0,
 healThreshold			= 0,
 powerThreshold			= 0,

 -- Cooldown settings.
 cooldownExclusions		= {},
 cooldownThreshold		= 5,
};


-------------------------------------------------------------------------------
-- Utility functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Recursively removes empty tables and their differential map entries.
-- ****************************************************************************
local function RemoveEmptyDifferentials(currentTable)
 -- Find nested tables in the current table.
 for fieldName, fieldValue in pairs(currentTable) do
  if (type(fieldValue) == "table") then
   -- Recursively clear empty tables in the nested table.
   RemoveEmptyDifferentials(fieldValue);

   -- Remove the table from the differential map and current table if it's
   -- empty.
   if (not next(fieldValue)) then
    differentialMap[fieldValue] = nil;
	differentialCache[#differentialCache+1] = fieldValue;
    currentTable[fieldName] = nil;
   end
  end
 end
end


-- ****************************************************************************
-- Recursively associates the tables in the passed saved table to corresponding
-- entries in the passed master table.
-- ****************************************************************************
local function AssociateDifferentialTables(savedTable, masterTable)
 -- Associate the saved table with the corresponding master entry.
 differentialMap[savedTable] = masterTable;
 setmetatable(savedTable, differential_mt);
 
 -- Look for nested tables that have a corresponding master entry.
 for fieldName, fieldValue in pairs(savedTable) do
  if (type(fieldValue) == "table" and type(masterTable[fieldName]) == "table") then
   -- Recursively call the function to associate nested tables.
   AssociateDifferentialTables(fieldValue, masterTable[fieldName]);
  end
 end 
end


-- ****************************************************************************
-- Set the passed option to the current profile while handling differential
-- profile mechanics.
-- ****************************************************************************
local function SetOption(optionPath, optionName, optionValue, optionDefault)
 -- Clear the path table.
 EraseTable(pathTable);
 
 -- Split the passed option path into the path table.
 if (optionPath) then SplitString(optionPath, "%.", pathTable); end

 -- Attempt to go to the option path in the master profile.
 local masterOption = masterProfile;
 for _, fieldName in ipairs(pathTable) do
  masterOption = masterOption[fieldName];
  if (not masterOption) then break; end
 end
 
 -- Get the option name from the master profile.
 masterOption = masterOption and masterOption[optionName];

 -- Check if the option being set needs to be overridden.
 local needsOverride = false;
 if (optionValue ~= masterOption) then needsOverride = true; end

 -- Treat a nil master option the same as false. 
 if ((optionValue == false or optionValue == optionDefault) and not masterOption) then
  needsOverride = false;
 end

 -- Make the option value false if the option being set is nil and the master option set. 
 if (optionValue == nil and masterOption) then optionValue = false; end
  
 -- Start at the root of the current profile and master profile.
 local currentTable = currentProfile;
 local masterTable = masterProfile;

 -- Override needed.
 if (needsOverride and optionValue ~= nil) then
  -- Loop through all of the fields in path table.
  for _, fieldName in ipairs(pathTable) do
   -- Check if the field doesn't exist in the current profile.
   if (not rawget(currentTable, fieldName)) then
    -- Create a table for the field and setup the associated inheritance table.
    currentTable[fieldName] = table.remove(differentialCache) or {};
    if (masterTable and masterTable[fieldName]) then
     differentialMap[currentTable[fieldName]] = masterTable[fieldName];
     setmetatable(currentTable[fieldName], differential_mt);
    end
   end
  
   -- Move to the next field in the option path.
   currentTable = currentTable[fieldName];
   masterTable = masterTable and masterTable[fieldName];
  end

  -- Set the option's value.
  currentTable[optionName] = optionValue;
  
 -- Override NOT needed.
 else
 -- Attempt to go to the option path in the current profile.
  for _, fieldName in ipairs(pathTable) do
   currentTable = rawget(currentTable, fieldName);
   if (not currentTable) then return; end
  end

  -- Clear the option from the path and remove any empty differential tables.
  if (currentTable) then
   currentTable[optionName] = nil;
   RemoveEmptyDifferentials(currentProfile);
  end
 end
end


-- ****************************************************************************
-- Sets the game damage and healing options according to the current profile.
-- ****************************************************************************
local function UpdateGameOptions()
 -- Turn the game damage and healing display on or off.
 SetCVar("CombatDamage", currentProfile.gameDamageEnabled and 1 or 0)
 SetCVar("CombatHealing", currentProfile.gameHealingEnabled and 1 or 0)
end


-- ****************************************************************************
-- Disable or enable blizzard's combat text.
-- ****************************************************************************
local function DisableBlizzardCombatText(isDisabled)
 -- Check if the text should be disabled.
 if (isDisabled) then
  -- Turn off Blizzard's default combat text.
  SetCVar("enableCombatText", 0);
  SHOW_COMBAT_TEXT = "0";
  if (CombatText_UpdateDisplayedMessages) then
   CombatText_UpdateDisplayedMessages();
  end
 else
  -- Turn on Blizzard's default combat text.
  SetCVar("enableCombatText", 1);
  SHOW_COMBAT_TEXT = "1";
  if (not IsAddOnLoaded("Blizzard_CombatText")) then
   UIParentLoadAddOn("Blizzard_CombatText");
  end
  if (CombatText_UpdateDisplayedMessages) then
   CombatText_UpdateDisplayedMessages();
  end
 end  
end


-- ****************************************************************************
-- Set the user disabled option
-- ****************************************************************************
local function SetOptionUserDisabled(isDisabled)
 savedVariables.userDisabled = isDisabled or nil;

 -- Check if the mod is being set to disabled.
 if (isDisabled) then
  -- Disable the cooldowns, triggers, event parser, and main modules.
  MikSBT.Cooldowns.Disable();
  MikSBT.Triggers.Disable();
  MikSBT.Parser.Disable();
  MikSBT.Main.Disable();

  -- Turn on the game's display of outgoing damage.
  SetCVar("CombatDamage", 1);
  
  -- Turn on the game's display of outgoing heals.
  SetCVar("CombatHealing", 1);

 else 
  -- Enable the main, event parser, triggers, and cooldowns modules.
  MikSBT.Main.Enable();
  MikSBT.Parser.Enable(); 
  MikSBT.Triggers.Enable();
  MikSBT.Cooldowns.UpdateEnableState();

  -- Disable or enable game damage and healing based on the settings.
  UpdateGameOptions();
 end

 -- Toggle the game's floating combat text depending on mod's disable state.
 DisableBlizzardCombatText(not isDisabled);
end


-- ****************************************************************************
-- Returns whether or not the mod is disabled.
-- ****************************************************************************
local function IsModDisabled()
 return savedVariables.userDisabled;
end


-------------------------------------------------------------------------------
-- Profile functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Updates profiles created with older versions.
-- ****************************************************************************
local function UpdateProfiles()
 -- Loop through all the profiles.
 for profileName, profile in pairs(savedVariables.profiles) do
  -- Get numeric creation version.
  local creationVersion = tonumber(select(3, string_find(tostring(profile.creationVersion), "(%d+%.%d+)")));

  -- Delete triggers if upgrading from a version prior to 5.2.
  if (creationVersion < 5.2) then
   profile.triggers = nil;
   profile.creationVersion = MikSBT.VERSION .. "." .. MikSBT.SVN_REVISION;
  end
 end
end


-- ****************************************************************************
-- Selects the passed profile.
-- ****************************************************************************
local function SelectProfile(profileName)
 -- Make sure the profile exists.
 if (savedVariables.profiles[profileName]) then
  -- Set the current profile name for the character to the one being selected.
  savedVariablesPerChar.currentProfileName = profileName;

  -- Set the current profile pointer.
  currentProfile = savedVariables.profiles[profileName];
  module.currentProfile = currentProfile;
  
  -- Clear the differential table map.
  EraseTable(differentialMap);
 
  -- Associate the current profile tables with the corresponding master profile entries.
  AssociateDifferentialTables(currentProfile, masterProfile);
 
  -- Disable or enable game damage and healing based on the settings.
  UpdateGameOptions();

  -- Update the scroll areas and triggers with the current profile settings. 
  MikSBT.Animations.UpdateScrollAreas();
  MikSBT.Triggers.UpdateTriggers();
 end
end


-- ****************************************************************************
-- Copies the passed profile to a new profile with the passed name.
-- ****************************************************************************
local function CopyProfile(srcProfileName, destProfileName)
 -- Leave the function if the the destination profile name is invalid.
 if (not destProfileName or destProfileName == "") then return; end

 -- Make sure the source profile exists and the destination profile doesn't.
 if (savedVariables.profiles[srcProfileName] and not savedVariables.profiles[destProfileName]) then
  -- Copy the profile.
  savedVariables.profiles[destProfileName] = CopyTable(savedVariables.profiles[srcProfileName]);
 end
end


-- ****************************************************************************
-- Deletes the passed profile.
-- ****************************************************************************
local function DeleteProfile(profileName)
 -- Ignore the delete if the passed profile is the default one.
 if (profileName == DEFAULT_PROFILE_NAME) then return; end

 -- Make sure the profile exists.
 if (savedVariables.profiles[profileName]) then
  -- Check if the profile being deleted is the current one.
  if (profileName == savedVariablesPerChar.currentProfileName) then
   -- Select the default profile.
   SelectProfile(DEFAULT_PROFILE_NAME);
  end

  -- Delete the profile.
  savedVariables.profiles[profileName] = nil;
 end
end


-- ****************************************************************************
-- Resets the passed profile to its defaults.
-- ****************************************************************************
local function ResetProfile(profileName, showOutput)
 -- Set the profile name to the current profile is one wasn't passed.
 if (not profileName) then profileName = savedVariablesPerChar.currentProfileName; end
 
 -- Make sure the profile exists.
 if (savedVariables.profiles[profileName]) then
  -- Reset the profile.
  EraseTable(savedVariables.profiles[profileName]);

  -- Reset the profile's creation version.
  savedVariables.profiles[profileName].creationVersion = MikSBT.VERSION .. "." .. MikSBT.SVN_REVISION;
  
  
  -- Check if it's the current profile being reset.
  if (profileName == savedVariablesPerChar.currentProfileName) then
   -- Reselect the profile to update everything.
   SelectProfile(profileName);
  end

  -- Check if the output text is to be shown.
  if (showOutput) then
   -- Print the profile reset string.
   Print(profileName .. " " .. L.MSG_PROFILE_RESET, 0, 1, 0);
  end
 end 
end


-- ****************************************************************************
-- This function initializes the saved variables. 
-- ****************************************************************************
local function InitSavedVariables()
 -- Set the saved variables per character to the value specified in the .toc file.
 savedVariablesPerChar = _G[SAVED_VARS_PER_CHAR_NAME];

 -- Check if there are no saved variables per character.
 if (not savedVariablesPerChar) then
  -- Create a new table to hold the saved variables per character, and set the .toc entry to it.
  savedVariablesPerChar = {};
  _G[SAVED_VARS_PER_CHAR_NAME] = savedVariablesPerChar;

  -- Set the current profile for the character to the default profile.
  savedVariablesPerChar.currentProfileName = DEFAULT_PROFILE_NAME;
 end


 -- Set the saved variables to the value specified in the .toc file.
 savedVariables = _G[SAVED_VARS_NAME];

 -- Check if there are no saved variables.
 if (not savedVariables) then
  -- Create a new table to hold the saved variables, and set the .toc entry to it.
  savedVariables = {};
  _G[SAVED_VARS_NAME] = savedVariables;

  -- Create the profiles table and default profile.
  savedVariablesPerChar.currentProfileName = DEFAULT_PROFILE_NAME;
  savedVariables.profiles = {};
  savedVariables.profiles[DEFAULT_PROFILE_NAME] = {};

  savedVariables.profiles[DEFAULT_PROFILE_NAME].creationVersion = MikSBT.VERSION .. "." .. MikSBT.SVN_REVISION;
  
 -- There are saved variables.
 else
  -- Updates profiles created by older versions.
  UpdateProfiles();
 end

 -- Select the current profile for the character if it exists, otherwise select the default profile.
 if (savedVariables.profiles[savedVariablesPerChar.currentProfileName]) then
  SelectProfile(savedVariablesPerChar.currentProfileName);
 else
  SelectProfile(DEFAULT_PROFILE_NAME);
 end
 
 -- Allow public access to saved variables.
 module.savedVariables = savedVariables;
end




-------------------------------------------------------------------------------
-- Module interface.
-------------------------------------------------------------------------------

-- Protected Variables. 
module.masterProfile = masterProfile;

-- Protected Functions.
module.InitSavedVariables			= InitSavedVariables;
module.CopyProfile					= CopyProfile;
module.DeleteProfile				= DeleteProfile;
module.ResetProfile					= ResetProfile;
module.SelectProfile				= SelectProfile;
module.UpdateGameOptions			= UpdateGameOptions;
module.SetOption					= SetOption;
module.SetOptionUserDisabled		= SetOptionUserDisabled;
module.IsModDisabled				= IsModDisabled;