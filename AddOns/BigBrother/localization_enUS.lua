local L = AceLibrary("AceLocale-2.2"):new("BigBrother")

L:RegisterTranslations("enUS", function() return {
	["Flask Check"] = true,
	["Checks for flasks, elixirs and food buffs."] = true,

	["Quick Check"] = true,
	["A quick report that shows who does not have flasks, elixirs or food."] = true,

	["Self"] = true,
	["Reports result only to yourself."] = true,

	["Party"] = true,
	["Reports result to your party."] = true,

	["Raid"] = true,
	["Reports result to your raid."] = true,

	["Guild"] = true,
	["Reports result to guild chat."] = true,

	["Officer"] = true,
	["Reports result to officer chat."] = true,

	["Whisper"] = true,
	["Reports result to the currently targeted individual."] = true,

	["Reports if hostile polymorphs or shackles are broken and by who."] = true,

	["Misdirect"] = true,
	["Reports who gains misdirection."] = true,

	["BuffCheck"] = true,
	["Pops up a window to check various raid/elixir buffs (drag the bottom to resize)."] = true,

	["Settings"] = true,
	["Mod Settings"] = true,
	["Raid Groups"] = true,
	["Set which raid groups are checked for buffs"] = true,
	["Group 1"] = true,
	["Group 2"] = true,
	["Group 3"] = true,
	["Group 4"] = true,
	["Group 5"] = true,
	["Group 6"] = true,
	["Group 7"] = true,
	["Group 8"] = true,

	["Checks"] = true,
	["Set whether Flasks, Elixirs and Food are included in flaskcheck/quickcheck"] = true,
	["Flasks"] = true,
	["Elixirs"] = true,
	["Food Buffs"] = true,

	["No Flask"] = true,
	["No Flask or Elixir"] = true,
	["Only One Elixir"] = true,
	["Well Fed"] = true,
	["\"Well Fed\""] = true,
	["Enlightened"] = true,
	["Electrified"] = true,
	["No Food Buff"] = true,

	["%s cast %s on %s"] = true,
	["Polymorph/Misdirect Output"] = true,
	["Set where the polymorph/misdirect output is sent"] = true,
	["Polymorph"] = true,
	["Shackle"] = true,
	["Hibernate"] = true,
	["%s on %s removed by %s's %s"] = true,
	["%s on %s removed by %s"] = true,
	["CC on %s removed too frequently.  Throttling announcements."] = true,

	["Raid Buffs"] = true,
	["Paladin Buffs"] = true,
	["Consumables"] = true,

	-- Consumables
	["Flask of Supreme Power"] = true,
	["Shattrath Flask of Mighty Restoration"] = true,
	["Shattrath Flask of Fortification"] = true,
	["Shattrath Flask of Relentless Assault"] = true,
	["Shattrath Flask of Supreme Power"] = true,
	["Shattrath Flask of Pure Death"] = true,
	["Shattrath Flask of Blinding Light"] = true,

	-- Battle Elixirs
	["Fel Strength Elixir"] = true,
	["Onslaught Elixir"] = true,
	["Elixir of Major Strength"] = true,
	["Elixir of Major Agility"] = true,
	["Elixir of Mastery"] = true,
	["Elixir of Major Firepower"] = true,
	["Elixir of Major Shadow Power"] = true,
	["Elixir of Major Frost Power"] = true,
	["Elixir of Healing Power"] = true,
	["Elixir of the Mongoose"] = true,
	["Elixir of Greater Firepower"] = true,
	["Bloodberry Elixir"] = true,

	-- Guardian Elixirs
	["Elixir of Major Defense"] = true,
	["Elixir of Superior Defense"] = true,
	["Elixir of Major Mageblood"] = true,
	["Mageblood Potion"] = true,
	["Elixir of Greater Intellect"] = true,
	["Elixir of Empowerment"] = true,
} end)
