local L = AceLibrary("AceLocale-2.2"):new("BigBrother")

L:RegisterTranslations("frFR", function() return {
	["Flask Check"] = "Vérification des flacons",
	["Checks for flasks, elixirs and food buffs."] = "Vérifie la présence de flacon, d'élixir et de buff de nourriture.",

	["Quick Check"] = "Vérification rapide",
	["A quick report that shows who does not have flasks, elixirs or food."] = "Un rapport rapide qui indique les personnes sans flacon, élixir ou buff de nourriture.",

	["Self"] = "Soi-même",
	["Reports result only to yourself."] = "Affiche le résultat uniquement pour vous-même.",

	["Party"] = "Groupe",
	["Reports result to your party."] = "Affiche le résultat sur le canal Groupe.",

	["Raid"] = "Raid",
	["Reports result to your raid."] = "Affiche le résultat sur le canal Raid.",

	["Guild"] = "Guilde",
	["Reports result to guild chat."] = "Affiche le résultat sur le canal Guilde.",

	["Officer"] = "Officier",
	["Reports result to officer chat."] = "Affiche le résultat sur le canal Officier.",

	["Whisper"] = "Chuchoter",
	["Reports result to the currently targeted individual."] = "Chuchote le résultat à la personne actuellement ciblée.",

	["Reports if hostile polymorphs or shackles are broken and by who."] = "Indique si les métamorphoses et les entraves ont été enlevées et par qui.",

	["Misdirect"] = "Détournement",
	["Reports who gains misdirection."] = "Indique la personne qui gagne Détournement.",

	["BuffCheck"] = "Vérifier les buffs",
	["Pops up a window to check various raid/elixir buffs (drag the bottom to resize)."] = "Affiche une fenêtre indiquant les divers buffs de raid et les élixirs (saisissez le bas pour redimensionner).",

	["Settings"] = "Paramètres",
	["Mod Settings"] = "Paramètres de l'addon.",
	["Raid Groups"] = "Groupes de raid",
	["Set which raid groups are checked for buffs"] = "Détermine les groupes de raid à vérifier pour les buffs.",
	["Group 1"] = "Groupe 1",
	["Group 2"] = "Groupe 2",
	["Group 3"] = "Groupe 3",
	["Group 4"] = "Groupe 4",
	["Group 5"] = "Groupe 5",
	["Group 6"] = "Groupe 6",
	["Group 7"] = "Groupe 7",
	["Group 8"] = "Groupe 8",

	["Checks"] = "Vérifications",
	["Set whether Flasks, Elixirs and Food are included in flaskcheck/quickcheck"] = "Détermine si les flacons, les élixirs et la nourriture sont compris dans les vérifications des flacons et les vérifications rapides.",
	["Flasks"] = "Flacons",
	["Elixirs"] = "Elixirs",
	["Food Buffs"] = "Buffs de nourriture",

	["No Flask"] = "Pas de flacon",
	["No Flask or Elixir"] = "Pas de flacon ou d'élixir",
	["Only One Elixir"] = "Uniquement un élixir",
	["Well Fed"] = "Bien nourri",
	["\"Well Fed\""] = "\"Bien nourri\"",
	["No Food Buff"] = "Pas de buff de nourriture",

	["%s cast %s on %s"] = "%s cast %s sur %s.",
	["Polymorph/Misdirect Output"] = "Sortie Métamorphose/Détournement",
	["Set where the polymorph/misdirect output is sent"] = "Détermine où la sortie des métamorphoses/entraves est envoyé.",
	["Polymorph"] = "Métamorphose",
	["Shackle"] = "Entrave",
	["Hibernate"] = "Hibernation",
	["%s on %s removed by %s's %s"] = "%s |2 %s enlevée par %s (%s).",
	["%s on %s removed by %s"] = "%s |2 %s enlevée par %s.",
--	["CC on %s removed too frequently.  Throttling announcements."] = "",

	["Raid Buffs"] = "Buffs de raid",
	["Paladin Buffs"] = "Buffs paladin",
	["Consumables"] = "Consom.",

	-- Consumables
	["Flask of Supreme Power"] = "Flacon de pouvoir suprême",
	["Shattrath Flask of Mighty Restoration"] = "Flacon de puissante restauration de Shattrath",
	["Shattrath Flask of Fortification"] = "Flacon de fortifiant de Shattrath",
	["Shattrath Flask of Relentless Assault"] = "Flacon d'attaque implacable de Shattrath",
	["Shattrath Flask of Supreme Power"] = "Flacon de pouvoir suprême de Shattrath",
	["Shattrath Flask of Pure Death"] = "Flacon de pure mort de Shattrath",
	["Shattrath Flask of Blinding Light"] = "Flacon de lumière aveuglante de Shattrath",

	-- Battle Elixirs
	["Fel Strength Elixir"] = "Elixir de force gangrené",
	["Onslaught Elixir"] = "Elixir d'assaut",
	["Elixir of Major Strength"] = "Elixir de force majeure",
	["Elixir of Major Agility"] = "Elixir d'agilité majeure",
	["Elixir of Mastery"] = "Elixir de maîtrise",
	["Elixir of Major Firepower"] = "Elixir de maîtrise du Feu majeure",
	["Elixir of Major Shadow Power"] = "Elixir de puissance de l'Ombre majeure",
	["Elixir of Major Frost Power"] = "Elixir de puissance du Givre majeure",
	["Elixir of Healing Power"] = "Elixir de pouvoir de guérison",
	["Elixir of the Mongoose"] = "Elixir de la mangouste",
	["Elixir of Greater Firepower"] = "Elixir de maîtrise du Feu supérieure",
	["Bloodberry Elixir"] = "Elixir de sangrelle",

	-- Guardian Elixirs
	["Elixir of Major Defense"] = "Elixir de défense majeure",
	["Elixir of Superior Defense"] = "Elixir de défense excellente",
	["Elixir of Major Mageblood"] = "Elixir magesang majeur",
	["Mageblood Potion"] = "Potion Magesang",
	["Elixir of Greater Intellect"] = "Elixir d'intelligence supérieure",
	["Elixir of Empowerment"] = "Elixir de renforcement",
} end)
