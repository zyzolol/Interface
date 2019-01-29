--[[
BigBrother
Concept and original mod: Cryect
Currently maintained by: Treibh (Vek'nilash US)
Additional thanks:
    * All of the translators
    * Other wowace developers for assistance and bug fixes
    * Ahti and the other members of Cohors Praetoria (Vek'nilash US) for beta testing new versions of the mod
    * Thanks to vhaarr for helping Cryect out with reducing the length of code
    * Thanks to pastamancer for fixing the issues with Supreme Power Flasks and pointing in right direction for others
    * Window Resizing code based off the dragbar from violation
    * And also thanks to all those in #wowace for the various suggestions
]]

BigBrother = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0","AceDB-2.0","AceEvent-2.0","FuBarPlugin-2.0")

local addon = BigBrother

local AceEvent = AceLibrary("AceEvent-2.0")
local RL = AceLibrary("Roster-2.1")
local aura = AceLibrary("SpecialEvents-Aura-2.0")
local L = AceLibrary("AceLocale-2.2"):new("BigBrother")

local function SpellName(spellID)
	local name = GetSpellInfo(spellID)
	return name
end

-- table of flasks that are checked
local buffs = {
	SpellName(17626), -- 17626 Flask of the Titans
	SpellName(17627), -- 17627 Flask of Distilled Wisdom 
	SpellName(17628), -- 17628 Flask of Supreme Power 
	SpellName(17629), -- 17629 Flask of Chromatic Resistance 
	SpellName(28518), -- 28518 Flask of Fortification
	SpellName(28519), -- 28519 Flask of Mighty Restoration 
	SpellName(28520), -- 28520 Flask of Relentless Assault 
	SpellName(28521), -- 28521 Flask of Blinding Light 
	SpellName(28540), -- 28540 Flask of Pure Death 
	SpellName(33053), -- 33053 Mr. Pinchy's Blessing
	SpellName(42735), -- 42735 Flask of Chromatic Wonder 
	SpellName(40567), -- 40567 Unstable Flask of the Bandit
	SpellName(40568), -- 40568 Unstable Flask of the Elder
	SpellName(40572), -- 40572 Unstable Flask of the Beast
	SpellName(40573), -- 40573 Unstable Flask of the Physician
	SpellName(40575), -- 40575 Unstable Flask of the Soldier
	SpellName(40576), -- 40576 Unstable Flask of the Sorcerer
	SpellName(41608), -- 41608 Relentless Assault of Shattrath
	SpellName(41609), -- 41609 Fortification of Shattrath
	SpellName(41610), -- 41610 Mighty Restoration of Shattrath
	SpellName(41611), -- 41611 Sureme Power of Shattrath
	SpellName(46837), -- 46837 Pure Death of Shattrath
	SpellName(46839), -- 46839 Blinding Light of Shattrath
}

-- table of elixirs that are checked
local elixirs = {
	SpellName(11348),-- 11348 Greater Armor 
	SpellName(11390),-- 11390 Arcane Elixir
	SpellName(11396),-- 11396 Greater Intellect 
	SpellName(17538),-- 17538 Elixir of the Mongoose
	SpellName(17539),-- 17539 Greater Arcane Elixir 
	SpellName(24363),-- 24363 Mana Regeneration 
	SpellName(28490),-- 28490 Major Strength 
	SpellName(28491),-- 28491 Healing Power 
	SpellName(28493),-- 28493 Major Frost Power 
	SpellName(28497),-- 28497 Major Agility 
	SpellName(28501),-- 28501 Major Firepower 
	SpellName(28502),-- 28502 Major Armor 
	SpellName(28503),-- 28503 Major Shadow Power 
	SpellName(28509),-- 28509 Greater Mana Regeneration 
	SpellName(28514),-- 28514 Empowerment 
	SpellName(29626),-- 29626 Earthen Elixir 
	SpellName(38954),-- 38954 Fel Strength Elixir
	SpellName(39625),-- 39625 Elixir of Major Fortitude 
	SpellName(33720),-- 33720 Onslaught Elixir 
	SpellName(33721),-- 33721 Adept's Elixir 
	SpellName(33726),-- 33726 Elixir of Mastery 
	SpellName(39627),-- 39627 Elixir of Draenic Wisdom 
	SpellName(39628),-- 39628 Elixir of Ironskin 
	SpellName(45373),-- 45373 Bloodberry
}

local ccspells = {
	SpellName(118), -- Polymorph
	SpellName(9484), -- Shackle Undead
	SpellName(2637), -- Hibernate
	SpellName(14309), -- Freezing Trap Effect
	SpellName(6358), -- Seduction
	SpellName(6770), -- Sap
	SpellName(2094), -- Blind
}

local color = "|cffff8040%s|r"

-- FuBar stuff
addon.name = "BigBrother"
addon.hasIcon = true
addon.hasNoColor = true
addon.clickableTooltip = false
addon.independentProfile = true
addon.cannotDetachTooltip = true
addon.hideWithoutStandby = true


function addon:OnClick(button)
	self:ToggleBuffWindow()
end

function addon:OnTextUpdate()
	self:SetText("BigBrother")
end

-- AceDB stuff
addon:RegisterDB("BigBrotherDB")
addon:RegisterDefaults("profile", {
  PolyBreak = true,
  Misdirect = true,
  Groups = {true, true, true, true, true, true, true, true},
  PolyOut = {true, false, false, false, false},
  CheckFlasks = true,
  CheckElixirs = true,
  CheckFood = true,
})

-- ACE options menu
local options = {
  type = 'group',
  handler = BigBrother,
  args = {
    flaskcheck = {
      name = L["Flask Check"],
      desc = L["Checks for flasks, elixirs and food buffs."],
      type = 'group',
      args = {
        self = {
          name = L["Self"],
          desc = L["Reports result only to yourself."],
          type = 'execute',
          func = "FlaskCheck",
          passValue = "SELF",
        },
        party = {
          name = L["Party"],
          desc = L["Reports result to your party."],
          type = 'execute',
          func = "FlaskCheck",
          disabled = function() return GetNumPartyMembers()==0 end,
          passValue = "PARTY",
        },
        raid = {
          name = L["Raid"],
          desc = L["Reports result to your raid."],
          type = 'execute',
          func = "FlaskCheck",
          disabled = function() return GetNumRaidMembers()==0 end,
          passValue = "RAID",
        },
        guild = {
          name = L["Guild"],
          desc = L["Reports result to guild chat."],
          type = 'execute',
          func = "FlaskCheck",
          passValue = "GUILD",
        },
        officer = {
          name = L["Officer"],
          desc = L["Reports result to officer chat."],
          type = 'execute',
          func = "FlaskCheck",
          passValue = "OFFICER",
        },
        whisper = {
          name = L["Whisper"],
          desc = L["Reports result to the currently targeted individual."],
          type = 'execute',
          func = "FlaskCheck",
          passValue = "WHISPER",
        }
      }
    },
    quickcheck = {
      name = L["Quick Check"],
      desc = L["A quick report that shows who does not have flasks, elixirs or food."],
      type = 'group',
      args = {
        self = {
          name = L["Self"],
          desc = L["Reports result only to yourself."],
          type = 'execute',
          func = "QuickCheck",
          passValue = "SELF",
        },
        party = {
          name = L["Party"],
          desc = L["Reports result to your party."],
          type = 'execute',
          func = "QuickCheck",
          disabled = function() return GetNumPartyMembers()==0 end,
          passValue = "PARTY",
        },
        raid = {
          name = L["Raid"],
          desc = L["Reports result to your raid."],
          type = 'execute',
          func = "QuickCheck",
          disabled = function() return GetNumRaidMembers()==0 end,
          passValue = "RAID",
        },
        guild = {
          name = L["Guild"],
          desc = L["Reports result to guild chat."],
          type = 'execute',
          func = "QuickCheck",
          passValue = "GUILD",
        },
        officer = {
          name = L["Officer"],
          desc = L["Reports result to officer chat."],
          type = 'execute',
          func = "QuickCheck",
          passValue = "OFFICER",
        },
        whisper = {
          name = L["Whisper"],
          desc = L["Reports result to the currently targeted individual."],
          type = 'execute',
          func = "QuickCheck",
          passValue = "WHISPER",
        }
      }
    },
    settings = {
      name = L["Settings"],
      desc = L["Mod Settings"],
      type = 'group',
      args = {
        polymorph = {
          name  = L["Polymorph"],
          desc = L["Reports if hostile polymorphs or shackles are broken and by who."],
          type = 'toggle',
          get = function() return addon.db.profile.PolyBreak end,
          set = function(v)
            addon.db.profile.PolyBreak=v 
          end,
          map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
        },
        misdirect = {
          name  = L["Misdirect"],
          desc = L["Reports who gains misdirection."],
          type = 'toggle',
          get = function() return addon.db.profile.Misdirect end,
          set = function(v) addon.db.profile.Misdirect = v end,
          map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
        },
        polyoutput = {
          name = L["Polymorph/Misdirect Output"],
          desc = L["Set where the polymorph/misdirect output is sent"],
          type = 'group',
          args = {
            self = {
              name = L["Self"],
              desc = L["Reports result only to yourself."],
              type = 'toggle',
              get = function() return addon.db.profile.PolyOut[1] end,
              set = function(v) addon.db.profile.PolyOut[1] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            party = {
              name = L["Party"],
              desc = L["Reports result to your party."],
              type = 'toggle',
              get = function() return addon.db.profile.PolyOut[2] end,
              set = function(v) addon.db.profile.PolyOut[2] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            raid = {
              name = L["Raid"],
              desc = L["Reports result to your raid."],
              type = 'toggle',
              get = function() return addon.db.profile.PolyOut[3] end,
              set = function(v) addon.db.profile.PolyOut[3] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            guild = {
              name = L["Guild"],
              desc = L["Reports result to guild chat."],
              type = 'toggle',
              get = function() return addon.db.profile.PolyOut[4] end,
              set = function(v) addon.db.profile.PolyOut[4] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            officer = {
              name = L["Officer"],
              desc = L["Reports result to officer chat."],
              type = 'toggle',
              get = function() return addon.db.profile.PolyOut[5] end,
              set = function(v) addon.db.profile.PolyOut[5] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
          }
        },
        checks = {
          name = L["Checks"],
          desc = L["Set whether Flasks, Elixirs and Food are included in flaskcheck/quickcheck"],
          type = 'group',
          args = {
            group1 = {
              name  = L["Flasks"],
              desc = L["Flasks"],
              type = 'toggle',
              get = function() return addon.db.profile.CheckFlasks end,
              set = function(v) addon.db.profile.CheckFlasks = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            group2 = {
              name  = L["Elixirs"],
              desc = L["Elixirs"],
              type = 'toggle',
              get = function() return addon.db.profile.CheckElixirs end,
              set = function(v) addon.db.profile.CheckElixirs = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            group3 = {
              name  = L["Food Buffs"],
              desc = L["Food Buffs"],
              type = 'toggle',
              get = function() return addon.db.profile.CheckFood end,
              set = function(v) addon.db.profile.CheckFood = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
          }
        },
        groups = {
          name = L["Raid Groups"],
          desc = L["Set which raid groups are checked for buffs"],
          type = 'group',
          args = {
            group1 = {
              name  = L["Group 1"],
              desc = L["Group 1"],
              type = 'toggle',
              get = function() return addon.db.profile.Groups[1] end,
              set = function(v) addon.db.profile.Groups[1] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            group2 = {
              name  = L["Group 2"],
              desc = L["Group 2"],
              type = 'toggle',
              get = function() return addon.db.profile.Groups[2] end,
              set = function(v) addon.db.profile.Groups[2] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            group3 = {
              name  = L["Group 3"],
              desc = L["Group 3"],
              type = 'toggle',
              get = function() return addon.db.profile.Groups[3] end,
              set = function(v) addon.db.profile.Groups[3] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            group4 = {
              name  = L["Group 4"],
              desc = L["Group 4"],
              type = 'toggle',
              get = function() return addon.db.profile.Groups[4] end,
              set = function(v) addon.db.profile.Groups[4] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            group5 = {
              name  = L["Group 5"],
              desc = L["Group 5"],
              type = 'toggle',
              get = function() return addon.db.profile.Groups[5] end,
              set = function(v) addon.db.profile.Groups[5] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            group6 = {
              name  = L["Group 6"],
              desc = L["Group 6"],
              type = 'toggle',
              get = function() return addon.db.profile.Groups[6] end,
              set = function(v) addon.db.profile.Groups[6] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            group7 = {
              name  = L["Group 7"],
              desc = L["Group 7"],
              type = 'toggle',
              get = function() return addon.db.profile.Groups[7] end,
              set = function(v) addon.db.profile.Groups[7] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
            group8 = {
              name  = L["Group 8"],
              desc = L["Group 8"],
              type = 'toggle',
              get = function() return addon.db.profile.Groups[8] end,
              set = function(v) addon.db.profile.Groups[8] = v end,
              map = { [false] = "|cffff4040Disabled|r", [true] = "|cff40ff40Enabled|r" }
            },
          }
        },
      }
    },
    buffcheck = {
      name = L["BuffCheck"],
      desc = L["Pops up a window to check various raid/elixir buffs (drag the bottom to resize)."],
      type = 'execute',
      func = function() BigBrother:ToggleBuffWindow() end,
    }
  }
}

addon.OnMenuRequest = options

function addon:OnInitialize()
  self:RegisterChatCommand("/bb", "/bigbrother", options, "BIGBROTHER")
end

function addon:OnEnable()
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self:RegisterEvent("SpecialEvents_UnitBuffGained")
  self:RegisterEvent("SpecialEvents_UnitBuffLost", "BuffUpdating")
  self:OnProfileEnable()
end

function addon:OnProfileDisable()
end

function addon:OnProfileEnable()
end

function addon:SpecialEvents_UnitBuffGained(unit, name, index, count, icon, rank)
    self:BuffUpdating()
end

function addon:SendMessageList(Pre,List,Where)
  if #List > 0 then
    if Where == "SELF" then
      self:Print(string.format(color, Pre..":") .. " " .. table.concat(List, ", "))
    elseif Where == "WHISPER" then
      local theTarget = UnitName("playertarget")
      if theTarget == nil then
         theTarget = UnitName("player")
      end
      SendChatMessage(Pre..": "..table.concat(List, ", "),Where,nil,theTarget)
    else
      SendChatMessage(Pre..": "..table.concat(List, ", "),Where)
    end
  end
end

function addon:HasBuff(player,MissingBuffList)
  for k, v in pairs(MissingBuffList) do
    if v==player then
      table.remove(MissingBuffList,k)
    end
  end
end

function addon:FlaskCheck(Where)
  self:ConsumableCheck(Where, true)
end

function addon:QuickCheck(Where)
  self:ConsumableCheck(Where, false)
end


function addon:ConsumableCheck(Where,Full)
  local totalFlaskCount = 0
  local totalElixirCount = 0
  local numElixirs = 0
  local MissingFlaskList={}
  local MissingElixirList={}
  local MissingFoodList={}

  for unit in RL:IterateRoster(false) do
    if self.db.profile.Groups[unit.subgroup] then
      table.insert(MissingFlaskList,unit.name)
      table.insert(MissingFoodList,unit.name)
    end
  end

  --print the flask list and determine who has no flask
  if self.db.profile.CheckFlasks then
    for i, v in ipairs(buffs) do
      local t = self:BuffPlayerList(v,MissingFlaskList)
      if Full then
        self:SendMessageList(v, t, Where)
      end
      totalFlaskCount = totalFlaskCount + #t
    end
    
    if Full then
      self:SendMessageList(L["No Flask"], MissingFlaskList, Where)
    end
  end
  
  --use this to print out who has what elixir, and who has no elixirs
  if self.db.profile.CheckElixirs then
    for i, v in ipairs(elixirs) do
      local t = self:BuffPlayerList(v, MissingFlaskList)
      if Full then
        self:SendMessageList(v, t, Where)
      end
      totalElixirCount = totalElixirCount + #t
    end  
    
    --now figure out who has only one elixir
    for unit in RL:IterateRoster(false) do
      if self.db.profile.Groups[unit.subgroup] then
        numElixirs = 0
        for i, v in ipairs(elixirs) do
            if aura:UnitHasBuff(unit.unitid, v) then
              numElixirs = numElixirs + 1
            end
        end
        if numElixirs == 1 then
            table.insert(MissingElixirList,unit.name)
        end
      end
    end

    self:SendMessageList(L["Only One Elixir"], MissingElixirList, Where)
    self:SendMessageList(L["No Flask or Elixir"], MissingFlaskList, Where)
  end
  
  --check for missing food
  if self.db.profile.CheckFood then
    for i, v in ipairs(elixirs) do
	local t = self:BuffPlayerList(SpellName(35272), MissingFoodList) -- Well Fed
	local t = self:BuffPlayerList(SpellName(44106), MissingFoodList) -- "Well Fed" from Brewfest
	local t = self:BuffPlayerList(SpellName(43730), MissingFoodList) -- Electrified
	local t = self:BuffPlayerList(SpellName(43722), MissingFoodList) -- Enlightened
    end
    self:SendMessageList(L["No Food Buff"], MissingFoodList, Where)
  end  
end

function addon:BuffPlayerList(buffname,MissingBuffList)
  local list = {}
  for unit in RL:IterateRoster(false) do
    if aura:UnitHasBuff(unit.unitid, buffname) then
      table.insert(list, unit.name)
      self:HasBuff(unit.name,MissingBuffList)
    end
  end
  return list
end

local function geticon(flag)
	if bit.band(flag, COMBATLOG_OBJECT_SPECIAL_MASK) ~= 0 then 
		for i=1,8 do
			local mask = COMBATLOG_OBJECT_RAIDTARGET1 * (2 ^ (i - 1))
			local mark = (bit.band(flag, mask) == mask)
 			if mark then return i end
		end
        end
	return nil
end

local function geticonstring(number)
    local path = COMBATLOG_OBJECT_RAIDTARGET1 * (number ^ (number - 1))
    local format = "|Hicon:"..path..":dest|h|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..number..".blp:0|t|h"
    return format
end

local function sendspam(spam)
	if not spam then return end
	for a, b in ipairs(addon.db.profile.PolyOut) do
		if b then
			if a == 2 and GetNumPartyMembers() ~= 0 then
				SendChatMessage(spam, "PARTY")
			elseif a == 3 and GetNumRaidMembers() ~= 0 then
				SendChatMessage(spam, "RAID")
			elseif a == 4 and IsInGuild() and (GetNumPartyMembers() ~= 0 or GetNumRaidMembers() ~= 0) then
				SendChatMessage(spam, "GUILD")
			elseif a == 5 and IsInGuild() and (GetNumPartyMembers() ~= 0 or GetNumRaidMembers() ~= 0) then
				SendChatMessage(spam, "OFFICER")
			end
		end
	end
end

function addon:COMBAT_LOG_EVENT_UNFILTERED(timestamp, subevent, srcGUID, srcname, srcflags, dstGUID, dstname, dstflags, spellID, spellname, spellschool, extraspellID, extraspellname, extraspellschool, auratype)  
	if self.db.profile.PolyBreak
	  and (subevent == "SPELL_AURA_BROKEN" or subevent == "SPELL_AURA_BROKEN_SPELL")
	  and (bit.band(dstflags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0) then

		local throttleResetTime = 15;
		local now = GetTime();

		-- Reset the spam throttling cache if it isn't initialized or
		-- if it's been more than 15 seconds since any CC broke
		if (nil == self.spamCache or (nil ~= self.spamCacheLastTimeMax and now - self.spamCacheLastTimeMax > 15)) then
			self.spamCache = {};
			self.spamCacheLastTimeMax = nil;
		end

		for k,v in pairs(ccspells) do
			if spellname == v then
				local output, spam
				local srcicon = geticon(srcflags)
				local srcspam = srcicon and "{rt"..srcicon.."}"..srcname or srcname 
				local srcout = srcicon and geticonstring(srcicon).."|cff40ff40"..srcname.."|r" or "|cff40ff40"..srcname.."|r"

				local dsticon = geticon(dstflags)
				local dstspam = dsticon and "{rt"..dsticon.."}"..dstname or dstname 
				local dstout = dsticon and geticonstring(dsticon).."|cffff4040"..dstname.."|r" or "|cffff4040"..dstname.."|r"

				if subevent == "SPELL_AURA_BROKEN" then
					spam = (L["%s on %s removed by %s"]):format(spellname, dstspam, srcspam)
					output = (L["%s on %s removed by %s"]):format(spellname, dstout, srcout)
				elseif subevent == "SPELL_AURA_BROKEN_SPELL" then
					spam = (L["%s on %s removed by %s's %s"]):format(spellname, dstspam, srcspam, extraspellname)
					output = (L["%s on %s removed by %s's %s"]):format(spellname, dstout, srcout, extraspellname)
				end

				-- Should we throttle the spam?
				if self.spamCache[dstGUID] and now - self.spamCache[dstGUID]["lasttime"] < 15 then
					-- If we've been broken 3 or more times without a 15 second reprieve, then
					-- supress the spam
					if (self.spamCache[dstGUID]["count"] > 3) then
						spam = nil;
						output = nil;
					end

					-- Increment the cache entry
					self.spamCache[dstGUID]["count"] = self.spamCache[dstGUID]["count"] + 1;
					self.spamCache[dstGUID]["lasttime"] = now;
				else
					-- Reset the cache entry
					self.spamCache[dstGUID] = {["count"] = 1, ["lasttime"] = now};
				end
				self.spamCacheLastTimeMax = now;

				if output and self.db.profile.PolyOut[1] then
					self:Print(output)
				end

				if spam then
					sendspam(spam)
				end
			end
		end
	elseif self.db.profile.Misdirect and subevent == "SPELL_CAST_SUCCESS" and spellID == 34477 then
		if self.db.profile.PolyOut[1] then
			self:Print(L["%s cast %s on %s"]:format("|cff40ff40"..srcname.."|r", spellname, "|cffff4040"..dstname.."|r"))
		end
		sendspam(L["%s cast %s on %s"]:format(srcname, spellname, dstname))
	end
end

function addon:BuffUpdating(info)
  if BigBrother_BuffWindow and BigBrother_BuffWindow:IsShown() then
    self:ScheduleEvent(BigBrother.BuffWindow_Update,0.25)
  end
end

