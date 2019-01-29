local L = AceLibrary("AceLocale-2.2"):new("BigBrother")

L:RegisterTranslations("deDE", function() return {
	["Flask Check"] = "Fläschchen-Check",
	["Checks for flasks, elixirs and food buffs."] = "Überprüft die Nutzung von Fläschchen, Elixieren und Essen-Buffs.",

	["Quick Check"] = "Schnellprüfung",
	["A quick report that shows who does not have flasks, elixirs or food."] = "Eine Schnellprüfung, wer keine Fläschchen, Elixiere oder Essen-Buffs hat.",

	["Self"] = "Selbst",
	["Reports result only to yourself."] = "Berichtet die Resultate nur an dich selbst.",

	["Party"] = "Gruppe",
	["Reports result to your party."] = "Berichtet die Resultate an deine Gruppe.",

	["Raid"] = "Raid",
	["Reports result to your raid."] = "Berichtet die Resultate an den gesamten Raid.",

	["Guild"] = "Gilde",
	["Reports result to guild chat."] = "Berichtet die Resultate an die gesamte Gilde.",

	["Officer"] = "Offizier",
	["Reports result to officer chat."] = "Berichtet die Resultate an den Offiziers-Chat.",

	["Whisper"] = "Flüstern",
	["Reports result to the currently targeted individual."] = "Berichtet die Resultate an die aktuell ausgewählte Person.",

	["Reports if hostile polymorphs or shackles are broken and by who."] = "Berichtet wenn Verwandlungen unterbrochen werden, und von wem.",

	["Misdirect"] = "Irreführung",
	["Reports who gains misdirection."] = "Berichtet wer Irreführung bekommt.",

	["BuffCheck"] = "BuffCheck",
	["Pops up a window to check various raid/elixir buffs (drag the bottom to resize)."] = "Öffnet ein Fenster, um diverse Raid- und Elixier-Buffs zu überprüfen.",

	["Settings"] = "Einstellungen",
	["Mod Settings"] = "Mod-Einstellungen",
	["Raid Groups"] = "Raidgruppen",
	["Set which raid groups are checked for buffs"] = "Festlegen, welche Raidgruppen auf Buffs überprüft werden",
	["Group 1"] = "Gruppe 1",
	["Group 2"] = "Gruppe 2",
	["Group 3"] = "Gruppe 3",
	["Group 4"] = "Gruppe 4",
	["Group 5"] = "Gruppe 5",
	["Group 6"] = "Gruppe 6",
	["Group 7"] = "Gruppe 7",
	["Group 8"] = "Gruppe 8",

	["Checks"] = "Prüfungen",
	["Set whether Flasks, Elixirs and Food are included in flaskcheck/quickcheck"] = "Festlegen, ob Fläschchen, Elixiere und Essen-Buffs im Fläschchen-Check/der Schnellprüfung geprüft werden",
	["Flasks"] = "Fläschchen",
	["Elixirs"] = "Elixiere",
	["Food Buffs"] = "Essen-Buffs",

	["No Flask"] = "Kein Fläschchen",
	["No Flask or Elixir"] = "Kein Fläschchen oder Elixier",
	["Only One Elixir"] = "Nur ein Elixier",
	["Well Fed"] = "Satt",
	["\"Well Fed\""] = "\"Satt\"",
	["Enlightened"] = "Erleuchtet",
	["Electrified"] = "Elektrisiert",
	["No Food Buff"] = "Kein Essen-Buff",

	["%s cast %s on %s"] = "%s cast %s auf %s",
	["Polymorph/Misdirect Output"] = "Ausgabe von Verwandlung/Irreführung",
	["Set where the polymorph/misdirect output is sent"] = "Festlegen, wo Verwandlung/Irreführung ausgegeben werden soll",
	["Polymorph"] = "Verwandlung",
	["Shackle"] = "Fesseln",
	["%s on %s removed by %s's %s"] = "%s von %s unterbrochen durch %ss %s",
	["%s on %s removed by %s"] = "%s von %s unterbrochen durch %s",
--	["CC on %s removed too frequently.  Throttling announcements."] = "",

	["Raid Buffs"] = "Raidbuffs",
	["Paladin Buffs"] = "Paladin-Buffs",
	["Consumables"] = "Verbrauchsartikel",

	-- Consumables
	["Flask of Supreme Power"] = "Fläschchen der obersten Macht",
	["Shattrath Flask of Mighty Restoration"] = "Fläschchen der mächtigen Wiederherstellung von Shattrath",
	["Shattrath Flask of Fortification"] = "Fläschchen der Stärkung von Shattrath",
	["Shattrath Flask of Relentless Assault"] = "Fläschchen des unerbittlichen Angriffs von Shattrath",
	["Shattrath Flask of Supreme Power"] = "Fläschchen der obersten Macht von Shattrath",
	["Shattrath Flask of Pure Death"] = "Fläschchen des reinen Todes aus Shattrath",
	["Shattrath Flask of Blinding Light"] = "Fläschchen des blendenden Lichts aus Shattrath",

	--Battle Elixirs
	["Fel Strength Elixir"] = "Elixier der Teufelsstärke",
	["Onslaught Elixir"] = "Elixier des Ansturms",
	["Elixir of Major Strength"] = "Elixier der erheblichen Stärke",
	["Elixir of Major Agility"] = "Elixier der erheblichen Beweglichkeit",
	["Elixir of Mastery"] = "Elixier des Meisters",
	["Elixir of Major Firepower"] = "Elixier der erheblichen Feuermacht",
	["Elixir of Major Shadow Power"] = "Elixier der erheblichen Schattenmacht",
	["Elixir of Major Frost Power"] = "Elixier der erheblichen Frostmacht",
	["Elixir of Healing Power"] = "Elixier der Heilkraft",
	["Elixir of the Mongoose"] = "Elixier des Mungos",
	["Elixir of Greater Firepower"] = "Elixier der großen Feuermacht",
	--["Bloodberry Elixir"] = "",

	-- Guardian Elixirs
	["Elixir of Major Defense"] = "Elixier der erheblichen Verteidigung",
	["Elixir of Superior Defense"] = "Elixier der überragenden Verteidigung",
	["Elixir of Major Mageblood"] = "Elixier des erheblichen Magierbluts",
	["Mageblood Potion"] = "Magierbluttrank",
	["Elixir of Greater Intellect"] = "Elixier der großen Intelligenz",
	["Elixir of Empowerment"] = "Elixier der Schwächung",
} end)
