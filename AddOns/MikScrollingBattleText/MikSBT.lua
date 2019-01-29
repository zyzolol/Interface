-------------------------------------------------------------------------------
-- Title: Mik's Scrolling Battle Text
-- Author: Mik
-------------------------------------------------------------------------------

-- Create mod namespace and set its name.
local mod = {};
local modName = "MikSBT";
_G[modName] = mod;


-------------------------------------------------------------------------------
-- Mod constants
-------------------------------------------------------------------------------

local TOC_VERSION = string.gsub(GetAddOnMetadata("MikScrollingBattleText", "Version"), "wowi:revision", 0);
mod.VERSION = tonumber(select(3, string.find(TOC_VERSION, "(%d+%.%d+)")));
mod.VERSION_STRING = "v" .. TOC_VERSION;
mod.SVN_REVISION = tonumber(select(3, string.find(TOC_VERSION, "%d+%.%d+.(%d+)")));

mod.COMMAND = "/msbt";


-------------------------------------------------------------------------------
-- Localization.
-------------------------------------------------------------------------------

-- Holds localized strings.
local translations = {};


-------------------------------------------------------------------------------
-- Utility functions.
-------------------------------------------------------------------------------

-- ****************************************************************************
-- Copies the passed table and all its subtables.
-- ****************************************************************************
local function CopyTable(srcTable)
 -- Create a new table.
 local newTable = {};

 -- Loop through all of the entries in the table.
 for key, value in pairs(srcTable) do
  -- Recursively call the function to copy nested tables.
  if (type(value) == "table") then value = CopyTable(value); end

  -- Make a copy of the value into the new table.
  newTable[key] = value;
 end

 -- Return the new table.
 return newTable;
end


-- ****************************************************************************
-- Erases the passed table.  Subtables are NOT erased.
-- ****************************************************************************
local function EraseTable(t)
 -- Loop through all the keys in the table and clear it.
 for key in next, t do
  t[key] = nil;
 end
end


-- ****************************************************************************
-- Splits a string into the passed table using the delimeter.
-- ****************************************************************************
local function SplitString(text, delimeter, splitTable)
 local start = 1;
 local splitStart, splitEnd = string.find(text, delimeter, start);  
 while splitStart do
  splitTable[#splitTable+1] = string.sub(text, start, splitStart - 1);
  start = splitEnd + 1;
  splitStart, splitEnd = string.find(text, delimeter, start);  
 end
 splitTable[#splitTable+1] = string.sub(text, start);
end


-- ****************************************************************************
-- Prints out the passed message to the default chat frame.
-- ****************************************************************************
local function Print(msg, r, g, b)
 -- Add the message to the default chat frame.
 DEFAULT_CHAT_FRAME:AddMessage("MSBT: " .. tostring(msg), r, g, b);
end




-------------------------------------------------------------------------------
-- Mod utility interface.
-------------------------------------------------------------------------------

-- Protected Variables.
mod.translations = translations;

-- Protected Functions.
mod.CopyTable	= CopyTable;
mod.EraseTable	= EraseTable;
mod.SplitString	= SplitString;
mod.Print		= Print;