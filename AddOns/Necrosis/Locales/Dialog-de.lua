--[[
    Necrosis LdC
    Copyright (C) 2005-2006  Lom Enfroy

    This file is part of Necrosis LdC.

    Necrosis LdC is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Necrosis LdC is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Necrosis LdC; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--]]

------------------------------------------------------------------------------------------------------
-- Necrosis LdC
-- Originally by Lomig, Liadora et Nyx (Kael'Thas et Elune) [2005-2007]
-- Now updated by Tarcalion (Nagrand US/Oceanic) [2008-...]
--
-- Skins and French voices: Eliah, Ner'zhul
--
-- German Version by Geschan
-- Spanish Version by DosS (Zul’jin)
--
-- Version $LastChangedDate: 2008-03-30 15:05:46 +1000 $
------------------------------------------------------------------------------------------------------

------------------------------------------------
-- GERMAN VERSION TEXTS --
------------------------------------------------

function Necrosis:Localization_Dialog_De()

	function Necrosis:Localization()
		self:Localization_Speech_De();
	end

	NECROSIS_COOLDOWN = {
		["SpellstoneIn"] = "Zauberstein ausr\195\188sten",
		["Spellstone"] = "Zauberstein Cooldown",
		["Healthstone"] = "Gesundheitsstein Cooldown"
	};

	NecrosisTooltipData = {
		["Main"] = {
			Label = "|c00FFFFFFNecrosis|r",
			Stone = {
				[true] = "Ja";
				[false] = "Nein";
			},
			Hellspawn = {
				[true] = "An";
				[false] = "Aus";
			},
			["Soulshard"] = "Seelensplitter : ",
			["InfernalStone"] = "H\195\182llensteine : ",
			["DemoniacStone"] = "D\195\164monen-Statuetten : ",
			["Soulstone"] = "\nSeelenstein : ",
			["Healthstone"] = "Gesundheitsstein : ",
			["Spellstone"] = "Zauberstein: ",
			["Firestone"] = "Feuerstein : ",
			["CurrentDemon"] = "D\195\164mon : ",
			["EnslavedDemon"] = "D\195\164mon : Versklavter",
			["NoCurrentDemon"] = "D\195\164mon : Keiner",
		},
		["Soulstone"] = {
			Label = "|c00FF99FFSeelenstein|r",
			Text = {"Rechte Maustaste zum herstellen","Linke Maustaste zum benutzten","Benutzt\nRechte Maustaste zum wiederherstellen","Warten"}
		},
		["Healthstone"] = {
			Label = "|c0066FF33Gesundheitsstein|r",
			Text = {"Rechte Maustaste zum herstellen","Linke Maustaste zum benutzten"},
			Text2 = "Mittlerer Maustaste oder Strg+rechte Maustaste zum handeln",
			Ritual = "|c00FFFFFFShift+Klick um das Ritual der Seelen zu zaubern|r"
		},
		["Spellstone"] = {
			Label = "|c0099CCFFZauberstein|r",
			Text = {"Rechte Maustaste zum herstellen","Im Inventar\nMittlere Maustaste oder Strg+linke Maustaste zum ausr\195\188sten","Ausger\195\188stet - Linke Maustaste zum benutzten\nShift+Klick um abzulegen"}
		},
		["Firestone"] = {
			Label = "|c00FF4444Feuerstein|r",
			Text = {"Rechte Maustaste zum herstellen","Im Inventar\nMittlere Maustaste zum ausr\195\188sten","Ausger\195\188stet\nShift+Klick um abzulegen"}
		},
		["SpellTimer"] = {
			Label = "|c00FFFFFFSpruchdauer|r",
			Text = "Aktive Spr\195\188che auf dem Ziel\n",
			Right = "Rechtsklick f\195\188r Ruhestein nach "
		},
		["ShadowTrance"] = {
			Label = "|c00FFFFFFSchatten Trance|r"
		},
		["Backlash"] = {
			Label = "|c00FFFFFFHeimzahlen|r"
		},
		["Domination"] = {
			Label = "|c00FFFFFFTeufelsbeherrschung|r"
		},
		["Enslave"] = {
			Label = "|c00FFFFFFVersklavt|r"
		},
		["Armor"] = {
			Label = "|c00FFFFFFD\195\164monenr\195\188stung|r"
		},
		["FelArmor"] = {
			Label = "|c00FFFFFFTeufelsr\195\188stung|r"
		},
		["Invisible"] = {
			Label = "|c00FFFFFFUnsichtbarkeit entdecken|r"
		},
		["Aqua"] = {
			Label = "|c00FFFFFFUnendlicher Atem|r"
		},
		["Kilrogg"] = {
			Label = "|c00FFFFFFAuge von Kilrogg|r"
		},
		["Banish"] = {
			Label = "|c00FFFFFFVerbannen|r",
			Text = "Rechtsklick f\195\188r Rang 1"
		},
		["TP"] = {
			Label = "|c00FFFFFFRitual der Beschw\195\182rung|r"
		},
		["SoulLink"] = {
			Label = "|c00FFFFFFSeelenverbindung|r"
		},
		["ShadowProtection"] = {
			Label = "|c00FFFFFFSchattenzauberschutz|r"
		},
		["Imp"] = {
			Label = "|c00FFFFFFWichtel|r"
		},
		["Voidwalker"] = {
			Label = "|c00FFFFFFLeerwandler|r"
		},
		["Succubus"] = {
			Label = "|c00FFFFFFSukkubus|r"
		},
		["Felhunter"] = {
			Label = "|c00FFFFFFTeufelsj\195\164ger|r"
		},
		["Felguard"] = {
			Label = "|c00FFFFFFTeufelswache|r"
		},
		["Infernal"] = {
			Label = "|c00FFFFFFH\195\182llenbestie|r"
		},
		["Doomguard"] = {
			Label = "|c00FFFFFFVerdammniswache|r"
		},
		["Sacrifice"] = {
			Label = "|c00FFFFFFD\195\164monenopferung|r"
		},
		["Amplify"] = {
			Label = "|c00FFFFFFFluch verst\195\164rken|r"
		},
		["Weakness"] = {
			Label = "|c00FFFFFFFluch der Schw\195\164che|r"
		},
		["Agony"] = {
			Label = "|c00FFFFFFFluch der Pein|r"
		},
		["Reckless"] = {
			Label = "|c00FFFFFFFluch der Tollk\195\188hnheit|r"
		},
		["Tongues"] = {
			Label = "|c00FFFFFFFluch der Sprachen|r"
		},
		["Exhaust"] = {
			Label = "|c00FFFFFFFluch der Ersch\195\182pfung|r"
		},
		["Elements"] = {
			Label = "|c00FFFFFFFluch der Elemente|r"
		},
		["Shadow"] = {
			Label = "|c00FFFFFFFluch der Schatten|r"
		},
		["Doom"] = {
			Label = "|c00FFFFFFFluch der Verdammnis|r"
		},
		["Mount"] = {
			Label = "|c00FFFFFFMount|r",
			Text = "Rechtsklick f\195\188r Rang 1"
		},
		["BuffMenu"] = {
			Label = "|c00FFFFFFSpruch Men\195\188|r",
			Text = "Rechtsklick um das Men\195\188 zu \195\182ffnen",
			Text2 = "Automatischer Modus: Wird beim verlassen des Kampfes geschlossen",
		},
		["PetMenu"] = {
			Label = "|c00FFFFFFD\195\164monen Men\195\188|r",
			Text = "Rechtsklick um das Men\195\188 zu \195\182ffnen",
			Text2 = "Automatischer Modus: Wird beim verlassen des Kampfes geschlossen",
		},
		["CurseMenu"] = {
			Label = "|c00FFFFFFFluch Men\195\188|r",
			Text = "Rechtsklick um das Men\195\188 zu \195\182ffnen",
			Text2 = "Automatischer Modus: Wird beim verlassen des Kampfes geschlossen",
		},
		["Radar"] = {
			Label = "|c00FFFFFFD\195\164monen sp\195\188ren|r"
		},
		["AmplifyCooldown"] = "Mit der rechten Taste klicken um den n\195\164chsten Fluch zu verst\195\164rken",
		["DominationCooldown"] = "Mit der rechten Taste klicken f\195\188r eine schnelle Beschw\195\182rung",
	};


	NECROSIS_SOUND = {
		["Fear"] = "Interface\\AddOns\\Necrosis\\sounds\\Fear-En.mp3",
		["SoulstoneEnd"] = "Interface\\AddOns\\Necrosis\\sounds\\SoulstoneEnd-En.mp3",
		["EnslaveEnd"] = "Interface\\AddOns\\Necrosis\\sounds\\EnslaveDemonEnd-En.mp3",
		["ShadowTrance"] = "Interface\\AddOns\\Necrosis\\sounds\\ShadowTrance-En.mp3",
		["Backlash"] = "Interface\\AddOns\\Necrosis\\sounds\\Backlash-Fr.mp3",
	};


	NECROSIS_PROC_TEXT = {
		["ShadowTrance"] = "<white>S<lightPurple1>c<lightPurple2>h<purple>a<darkPurple1>tt<darkPurple2>en<darkPurple1>tr<purple>a<lightPurple2>n<lightPurple1>c<white>e",
		["Backlash"] = "<white>H<lightPurple1>e<lightPurple2>i<purple>m<darkPurple1>z<darkPurple2>a<darkPurple1>h<purple>l<lightPurple2>e<lightPurple1>n"
	};

	NECROSIS_MESSAGE = {
		["Bag"] = {
			["FullPrefix"] = "Dein ",
			["FullSuffix"] = " ist voll !",
			["FullDestroySuffix"] = " ist voll; folgende Seelensplitter werden zerst\195\182rt !",
		},
		["Interface"] = {
			["Welcome"] = "<white>/necro f\195\188r das Einstellungsmen\195\188.",
			["TooltipOn"] = "Tooltips an" ,
			["TooltipOff"] = "Tooltips aus",
			["MessageOn"] = "Chat Nachrichten an",
			["MessageOff"] = "Chat Nachrichten aus",
			["DefaultConfig"] = "<lightYellow>Standard-Einstellungen geladen.",
			["UserConfig"] = "<lightYellow>Einstellungen geladen."
		},
		["Help"] = {
			"/necro <lightOrange>recall<white> -- <lightBlue>Zentriere Necrosis und alle Buttons in der Mitte des Bildschirms",
			"/necro <lightOrange>reset<white> -- <lightBlue>Setzt Necrosis komplett auf Grundeinstellungen zur\195\188ck",
		},
		["Information"] = {
			["FearProtect"] = "Dein Ziel hat Fear-Protection!!!",
			["EnslaveBreak"] = "Dein D\195\164mon hat seine Ketten gebrochen...",
			["SoulstoneEnd"] = "<lightYellow>Dein Seelenstein ist ausgelaufen."
		}
	};


	-- Gestion XML - Menu de configuration
	Necrosis.Config.Panel = {
		"Nachrichten Einstellungen",
		"Sph\195\164re Einstellungen",
		"Buttons Einstellungen",
		"Men\195\188s Einstellungen",
		"Timer Einstellungen",
		"Sonstiges"
	}

	Necrosis.Config.Messages = {
		["Position"] = "<- Hier werden Nachrichten von Necrosis erscheinen ->",
		["Afficher les bulles d'aide"] = "Zeige Tooltips",
		["Afficher les messages dans la zone systeme"] = "Zeige Nachrichten von Necrosis im System Frame",
		["Activer les messages aleatoires de TP et de Rez"] = "Zuf\195\164llige Spr\195\188che",
		["Utiliser des messages courts"] = "Benutzte kurze Nachrichten",
		["Activer egalement les messages pour les Demons"] = "Zuf\195\164llige Spr\195\188che f\195\188r D\195\164monen auch",
		["Activer egalement les messages pour les Montures"] = "Zuf\195\164llige Spr\195\188che f\195\188r Mount auch",
		["Activer les sons"] = "Aktiviere Sounds",
		["Alerter quand la cible est insensible a la peur"] = "Warnung, wenn Ziel immun gegen\195\188ber Fear ist",
		["Alerter quand la cible peut etre banie ou asservie"] = "Warnung, wenn ein Ziel verbannt\\versklavt werden kann",
		["M'alerter quand j'entre en Transe"] = "Warnung, wenn Trance eintritt"
	}

	Necrosis.Config.Sphere = {
		["Taille de la sphere"] = "Gr\195\182\195\159e der Sph\195\164re",
		["Skin de la pierre Necrosis"] = "Aussehen der Necrosis Sph\195\164re",
		["Evenement montre par la sphere"] = "Anzeige in der grafischen Sph\195\164re",
		["Sort caste par la sphere"] = "Zauber der durch Klick auf die\nSph\195\164re gewirkt wird",
		["Afficher le compteur numerique"] = "Zeige die gew\195\164hlte Anzeige in der Sph\195\164re",
		["Type de compteur numerique"] = "Anzeige w\195\164hlen:"
	}
	Necrosis.Config.Sphere.Colour = {
		"Pink",
		"Blau",
		"Orange",
		"T\195\188rkis",
		"Lila",
		"666",
		"X"
	}
	Necrosis.Config.Sphere.Count = {
		"Seelensplitter",
		"D\195\164monenen-Beschw\195\182rungs-Steine",
		"Wiederbelebungs-Timer",
		"Mana",
		"Gesundheit"
	}

	Necrosis.Config.Buttons = {
		["Rotation des boutons"] = "Rotation der Buttons",
		["Fixer les boutons autour de la sphere"] = "Fixiere die Buttons um die Sph\195\164re"
	}
	Necrosis.Config.Buttons.Name = {
		"Zeige den Feuerstein Button",
		"Zeige den Zauberstein Button",
		"Zeige den Gesundheitsstein Button",
		"Zeige den Seelenstein Button",
		"Zeige den Spruch Men\195\188 Button",
		"Zeige den Mount Button",
		"Zeige den D\195\164monen Men\195\188 Button",
		"Zeige den Fluch Men\195\188 Button",
	}

	Necrosis.Config.Menus = {
		["Options Generales"] = "Allgemeine Einstellungen",
		["Menu des Buffs"] = "Zauber Men\195\188",
		["Menu des Demons"] = "D\195\164monen Men\195\188",
		["Menu des Maledictions"] = "Fluch Men\195\188",
		["Afficher les menus en permanence"] = "Zeige die Men\195\188s permanent",
		["Afficher automatiquement les menus en combat"] = "Men\195\188s im Kampf automatisch \195\182ffnen",
		["Fermer le menu apres un clic sur un de ses elements"] = "Schließe das Men\195\188, sobald ein Button geklickt wurde",
		["Orientation du menu"] = "Ausrichtung des Men\195\188s",
		["Changer la symetrie verticale des boutons"] = "Ver\195\164ndert die Vertikale Symmetrie der Buttons",
		["Taille du bouton Banir"] = "Gr\195\182\195\159e des Verbannen Button",
	}
	Necrosis.Config.Menus.Orientation = {
		"Horizontal",
		"Aufw\195\164rts",
		"Abw\195\164rts"
	}

	Necrosis.Config.Timers = {
		["Type de timers"] = "Timer Typ",
		["Afficher le bouton des timers"] = "Zeige den Timer Button",
		["Afficher les timers sur la gauche du bouton"] = "Zeige die Timer auf der linken Seite des Knopfes",
		["Afficher les timers de bas en haut"] = "Neue Timer oberhalb der bestehenden Timer anzeigen",
	}
	Necrosis.Config.Timers.Type = {
		"Kein",
		"Graphische",
		"Texttimer"
	}

	Necrosis.Config.Misc = {
		["Deplace les fragments"] = "Lege die Seelensplitter in die ausgew\195\164hlte Tasche.",
		["Detruit les fragments si le sac plein"] = "Zerst\195\182re neue Seelensplitter,\nwenn die Tasche voll ist.",
		["Choix du sac contenant les fragments"] = "W\195\164hle die Seelensplitter-Tasche",
		["Nombre maximum de fragments a conserver"] = "Maximale Anzahl der zu behaltenden Splitter:",
		["Verrouiller Necrosis sur l'interface"] = "Sperre Necrosis",
		["Afficher les boutons caches"] = "Zeige versteckte Buttons um sie zu verschieben",
		["Taille des boutons caches"] = "Gr\195\182\195\159e des versteckten Buttons"
	}

	NECROSIS_BINDING = {
		["Current"] = "  ist im Moment gebunden an ",
		["Confirm"] = "M\195\182chtest du eine neue Bindung der Taste ",
		["To"] = " an ",
		["Yes"] = "Ja",
		["No"] = "Nein",
		["InCombat"] = "Es tut mir leid, du kannst Tastenk\195\188rzel nicht im Kampf binden..",
		["Binding"] = "Tastenk\195\188rzel",
		["Unbind"] = "Verbindung l\195\182sen",
		["Cancel"] = "Abbrechen",
		["Press"] = "Dr\195\188cke zu bindende Taste...\n\n",
		["Now"] = "Aktuell: ",
		["NotBound"] = "Nicht gebunden",
	};
end
