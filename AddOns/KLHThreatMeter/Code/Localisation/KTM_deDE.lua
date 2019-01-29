thismod.string.data["deDE"] = 
{
	copybox = "Drücke |cffffff00Ctrl + C|r um den Text iin die Zwischenablage zu kopieren",
	
	errorbox = 
	{
		header = "%s Fehler", -- %s == mod.global.name
		body = "Es trat ein Fehler in %s auf. Für weitere Details siehe die Fehlerprotokollsektion des Hilfe-Menüs.\n\n",
		first = "Weitere Meldungen dieses Fehlers werden unterdrückt.",
		second = "Alle weiteren Fehlermeldungen werden unterdrückt.",
	},
	
	console = 
	{
		nocommand = "|cffff8888 Es gibt keinen Befehl |cffffff00%s|r.",
		ambiguous = "Welchen der folgenden Befehle meintest du?",
		run = "|cff8888ff Der Befehl %s|r wird ausgeführt.",
		
		help = 
		{
			test = 
			{
				["#help"] = "Überprüft ob das Addon  Ausrüstung, Talente und andere Werte korrekt erkennt.",
				gear = "Listet die Setteile die du trägst auf, die deine Bedrohung beeinflussen.",
				talents = "Listet die Talentpunkte aller Talente auf die deine Bedrohung beeinflussen.",
				threat = "Listet eine Vielzahl verschiedener Bedrohungsfaktoren auf.",
				time = "Zeigt die Prozessorbelastung",
				memory = "Zeigt den Speicherbedarf",
				states = "Überprüft ob das Addon den korrekten Wert für seine Statusvariablen hat.",
				locale = "Sucht nach Übersetzungen die in deiner Sprachversion fehlen.",
			},
			
			version = 
			{
				["#help"] = "Befehle zur Versionsverwaltung. Erforden Offiziersstatus.",
				query = "Fragt jedes Gruppenmitglied nach dessen KTM-Version.",
				notify = "Fordert Nutzer älterer Versionen zum Aktualisieren von KTM auf",
			},
			
			gui = 
			{
				["#help"] = "Grundlegende Befehle für das Raid-Fenster.",
				show = "Zeigt das Raid-Fenster.",
				hide = "Versteckt das Raid-Fenster.",
				reset = "Setzt die Fenster-Postion wieder auf die Bildschirmmitte zurück."
			},
			
			boss = 
			{
				["#help"] = "Funktionen um Bossfertigkeiten zu bestimmen und festzulegen.",
				report = "Lässt Spieler melden wenn ihre Bedrohung von Bossfertigkeiten verändert wird.",
				endreport = "Stoppt Meldungen über Bedrohungsänderungen der Mitspieler.",
				setspell = "Verändere die Parameter einer bekannten Boss-Fertigkeit.",
			},
			
			disable = "Notfallstop: Deaktiviert events / onupdate.",
			enable = "Starte das Addon nach einem Notfallstop neu.",
			mastertarget = "Setzen /Entfernen eines Haupt-Ziels.",
			resetraid = "Lösche die Bedrohung aller Raidmitglieder.",
			help = "Zeigt das Hilfe-Menü.",
			
		},
	},
	
	["raidtable"] = 
	{
		tooltip = 
		{
			close = "Schließen",
			closetext = "Dieses Fenster ausblenden.",
			options = "Optionen",
			optionstext = "Die Anordnung sowie das Farbschema dieses Fensters festlegen.",
			minimise = "Minimieren",
			minimisetext = "Die Tabelle minimieren und nur den oberen Balken anzeigen. Nochmals klicken um die Tabelle wieder anzuzeigen.",
			setmt = "Hauptziel festlegen",
			setmttext = "Dein aktuelles Ziel wird als Hauptziel festgelegt, oder es wird gelöscht wenn du kein Ziel hast.",
		},
		
		column = 
		{
			name = "Name",
			threat = "Bedrohung",
			percent = "%Max", -- percentage of maximum, but has to be short!
			persecond = "BpS", -- threat per second. again, must be short.
		},
	},
	["menu"] = 
	{
		top = 
		{
			description = "Hauptmenü",
			text = "Willkommen im |cffffff00%s |cff00ff00%s.%s|r Menü.\n\nDu befindest dich im Hauptmenü. Der Name der aktuellen Kategorie wird in der Box oben angezeigt. Die Leiste auf der linken Seite bezieht sich auf den jeweiligen Menüpunkt.\n\nDie oberste linke Box ist das Ursprungsmenue der aktuellen Kategorie. Klicke auf sie um zur vorherigen Kategorie zurueck zu gehen.\n\nDie Boxen darunter sind Unterkategorien der aktuellen Kategorie. Klicke auf sie um in die Unterkategorien zu gelangen.\n\nUm das Menue zu verlassen, klicke rechts oben auf das X.",
		},
		
		raidtable = 
		{
			description = "Schlachtzugstabelle",
			text = "In dieser Kategorie kannst du das Aussehen der Schlachtzugstabelle ändern.\n\nUnter |cffffff00Farbschema|r kannst du die Farben der Schrift und des Fensters verändern.\n\nUnter |cffffff00Anordnung|r kannst du die Größe und Ausrichtung der Tabelle ändern.\n\nUnter |cffffff00Zeilen und Spalten|r werden die sichtbaren Spalten in der Tabelle sowie der Klassenfliter verändert.",
			button = "Tabelle anzeigen",
			
			colour = 
			{
				description = "Farbschema",
				
				text1 = "Klicke hier um die Rahmenfarbe der Tabelle zu ändern:",
				button1 = "Rahmenfarbe ändern",
				text2 = "Klicke hier um die Farbe des Haupttextes zu ändern (z.B. für Überschriften):",
				button2 = "Haupttext Farbe ändern",
				text3 = "Klicke hier um die Farbe des Nebentextes zu ändern (z.B. für normalen Text):",
				button3 = "Nebentext Farbe ändern",
				text4 = "Transparenz einstellen (Alphawert). 100% ist voll sichtbar, 0% ist unsichtbar.",
				slider = "Alphawert",
			},
			
			layout = 
			{
				description = "Anordnung",
				
				text1 = "Hier kannst du spezifizieren wie sich die Tabelle füllt. Eine Ecke des Fensters ist immer fest und die Tabelle wächst in die gegenüberliegende Richtung. Wenn z.B. der Punkt oben links ist wird die Tabelle, so weit wie erforderlich, nach unten und rechts wachsen. Klicke auf das jeweilige Feld um den fixierten Punkt zu ändern.",
				button1 = "Oben Links",
				button2 = "Oben Rechts",
				button3 = "Unten Links",
				button4 = "Unten Rechts",
				
				text2 = "Die maximale Anzahl der Zeilen in der Tabelle.",
				slider = "Zeilen",
				
				text3 = "Wenn diese Option gewählt ist wird die Länge der Tabelle, abhängig von der maximalen Anzahl der Zeilen, an die Anzahl ihrer Einträge angepasst. Andernfalls hat sie eine feste Größe.",
				checkbox = "Kompakte Tabelle",
				
				text4 = "Die Größe aller Elemente der Tabelle ändern",
				slider2 = "Skalierung",
			},
			
			filter = 
			{
				description = "Zeilen und Spalten",
				text1 = "Wähle die Klassen welche in der Tabelle angezeigt werden sollen.",
				text2 = "Wähle die Spalten welche in der Tabelle angezeigt werden sollen.",
				
				threat = "Zeige die Bedrohungsspalte.",
				percent = "Zeige die Prozentspalte (%s).",
				persecond = "Zeige die Bedrohung pro Sekunde - Spalte (%s)."
			},
			
			misc = 
			{
				description = "Verschiedenes",
				text1 = "Das Fenster automatisch anzeigen oder verstecken wenn du einer Gruppe beitrittst oder diese verlässt.",
				leavegroup = "Verstecke das Fenster wenn ich die Gruppe verlasse.",
				joinparty = "Zeige das Fenster wenn ich einer Gruppe beitrete.",
				joinraid = "Zeige das Fenster wenn ich einem Schlachtzug beitrete.",
				
				text2 = "Wurde das Fenster richtig positioniert, kann ein weiteres Verschieben verhindert werden.",
				lockwindow = "Das Fenster am aktuellen Platz fixieren.",
			}
		},
		
		mythreat = 
		{
			
			description = "Mein Bedrohungsstatus",
			reset = "Reset",
			update = "Aktualisieren",
			
		},

		errorlog = 
		{
			description = "Fehlerprotokoll",
			
			text1 = "Hier werden alle nichtkritischen Fehler die in allen Modulen des Addons aufgetreten sind angezeigt.Das Addon kann weiter funktionieren, aber einige Komponenten werden ihre Funktion einstellen, daher wird die Bedrohung nicht genau erfasst werden können.\n\nAm Besten werden solche Fehler auf der Website gemeldet, |cffffff00%s|r .",
			
			text2 = "Zeige Fehler %d von %d.",
			
			button1 = "Kopiere Webseitenadresse",
			button2 = "Vorhergehender Fehler",
			button3 = "Nächster Fehler",
			button4 = "Kopiere Fehlerdetails",
			
			format = 
			{
				module = "|cffffff00Modul =|r %s",
				process = "|cffffff00Prozess =|r %s",
				extradata = "|cffffff00Extradaten =|r %s",
				message = "|cffffff00Fehlermeldung =|r %s",
			},
		},
		
		bossmod = 
		{
			description = "Bossmodule",
			text = "Diese Sektion konfiguriert die einzelnen Bossmodule des Addons.\n\nDer Abschnitt|cffffff00EVorgefertigte Module|r beinhaltet eine Liste an Modulen die offiziell mit KTM ausgeliefert wurden.\n\nDer Abschnitt |cffffff00User Made|r  zeigt eine Liste von Bossmodulen die von Nutzern erstellt wurden. Du kannst deine eigenen Bossmodule entwerfen und diese als Datei speichern oder an die Raidgruppe senden.",
			
			builtin = 
			{
				description = "Vorgefertigte Module",
				text1 = "Hier ist eine Liste eingebauter Bossmodule. Für weitere Details auf das entsprechende Modul klicken.",
			},
			
			usermade = 
			{
				description = "User Made",
				text1 = "Klicke auf ein Modul in der Liste um die Details zu sehen. Klicke auf  |cffffff00Verbreiten|r um das Modul an die Raidgruppe zu senden. |cffffff00Exportieren|r speichert das Modul als Datei ab, die andere Nutzer mittels des |cffffff00Importieren|r Buttons einlesen können.\nKlicke auf |cffffff00Neu|r um ein neues Modul zu erstellen , |cffffff00Löschen|r um das ausgewählte Modul zu entfernen, oder|cffffff00Bearbeiten|r um es zu verändern.", 
				
				button = 
				{
					import = "Importieren",
					export = "Exportieren",
					broadcast = "Verbreiten",
				}
			}
		}
		
	},
	
	generic = 
	{
		finish = "Beenden",
		cancel = "Abbrechen",
		close = "Schliessen",
		delete = "Löschen",
		edit = "Bearbeiten",
		new = "Neu",
		next = "Weiter",
		back = "Zurück",
	},
	
	wizard = 
	{
		editboss = 
		{
			header = "Bearbeite das |cffffff00%s|r Bossmodul.",
			description = "Wähle einen Namen für das Bossmodul aus unter gib ihn unten ein. Falls es Zauber-Events enthält, stell sicher dass es mit dem genauen Boss-Namen exakt übereinstimmt. Eine Liste möglicher Namen wird auf der rechten Seite gezeigt. Um einen dieser Vorschläge zu nutzen, einfach den Vorschlag anklicken.\nKlicke auf|cffffff00Beenden|r um das Bossmodul fertigzustellen, oder |cffffff00Abbrechen|r um sämtliche Änderungen rückgängig zu machen. |cffffff00Weiter|r bringt dich zur Ausrufsektion.",
		},
		customhandler = 
		{
			heading = "Create a custom handler for |cffffff00%s.",
			description = "• Wrappe den Code nicht in  |cffffff00function ... end|r\n• Du wirst Zugriff auf folgende Variablen erhalten:\n1) |cffffff00mod|r - pointer auf %s table\n2) |cffffff00data|r - Dauerhafter Datenspeicher für die Funktion  (empty table)\n• Etwas nützlicher Code:\n1) |cffffff00value = mod.table.getraidthreat()|r - deine aktuelle Bedrohung\n2) |cffffff00Sachen über das Bedrohungszurücksetzen des Raids|r - lol",
			error = "Diese Funktion kompiliert nicht sauber. Der Fehler lautet \n|cffffff00%s.",
		}
	},
	
			
	class = 
	{
		warrior = "Krieger",
		priest = "Priester",
		druid = "Druide",
		rogue = "Schurke",
		shaman = "Schamane",
		mage = "Magier",
		paladin = "Paladin",
		warlock = "Hexenmeister",
		hunter = "Jäger",
	},
	
	["binding"] = 
	{
		hideshow = "Fenster zeigen/verstecken",
		stop = "Notaus",
		mastertarget = "Hauptziel setzen/löschen",
		resetraid = "Raidbedrohung zurücksetzen",
	},
	["spell"] = 
	{
		-- 19
		vampirictouch = "Vampirberührung",
		bindingheal = "Verbindende Heilung",
		leaderofthepack = "Rudelführer",
		faeriefire = "Feenfeuer (Tiergestalt)",
		shadowguard = "Schattenschild",
		anesthetic = "Beruhigendes Gift",
		bearmangle = "Zerfleischen (Bär)",
		thunderclap = "Donnerschlag",
		soulshatter = "Seele brechen",
		invisibility = "Unsichtbarkeit",
		misdirection = "Irreführung",
		disengage = "Rückzug",
		anguish = "Seelenpein", -- Felguard
		lacerate = "Aufschlitzen", 
		
		-- 18.x
		torment = "Qual",
		suffering = "Leiden",
		soothingkiss = "Besänftigender Kuss",
		intimidation = "Einschüchterung",
		
		righteousdefense = "Rechtschaffene Verteidigung",
		eyeofdiminution = "Das Auge des Schwunds", -- buff from trinket "Eye of Diminution". The buff appears to be slightly different, with 'The' at the start.
		notthere = "Not There", -- the buff from Frostfire 8/8 Proc
		frostshock = "Frostschock", 
		reflectiveshield = "Reflektierendes Schild", -- this is the damage from Power Word:Shield with the talent.
		devastate = "Verwüsten",
		stormstrike = "Sturmschlag",
		
		-- warlock affliction spells (others already existed below)
		corruption = "Verderbnis",				
		curseofagony = "Fluch der Pein",
		drainsoul = "Seelendieb",
		curseofdoom = "Fluch der Verdammnis",
		unstableaffliction = "Instabiles Gebrechen",
		
		-- new warlock destruction spells
		shadowfury = "Schattenfurie",
		incinerate = "Verbrennen", 
		
		-- 17.20
		["execute"] = "Hinrichten",
		
		["heroicstrike"] = "Heldenhafter Stoß",
		["maul"] = "Zermalmen",
		["swipe"] = "Prankenhieb",
		["shieldslam"] = "Schildschlag",
		["revenge"] = "Rache",
		["shieldbash"] = "Schildhieb",
		["sunder"] = "Rüstung zerreißen",
		["feint"] = "Finte",
		["cower"] = "Ducken",
		["taunt"] = "Spott",
		["growl"] = "Knurren",
		["vanish"] = "Verschwinden",
		["frostbolt"] = "Frostblitz",
		["fireball"] = "Feuerball",
		["arcanemissiles"] = "Arkane Geschosse",
		["scorch"] = "Versengen",
		["cleave"] = "Spalten",
		
		hemorrhage = "Blutsturz",
		backstab = "Meucheln",
		sinisterstrike = "Finsterer Stoß",
		eviscerate = "Ausweiden",
		
		-- Items / Buffs:
		["arcaneshroud"] = "Arkaner Schleier",
		["blackamnesty"] = "Verringerte Bedrohung",

		-- Leeches: no threat from heal
		["holynova"] = "Heilige Nova", -- no heal or damage threat
		["siphonlife"] = "Lebensentzug", -- no heal threat
		["drainlife"] = "Blutsauger", -- no heal threat
		["deathcoil"] = "Todesmantel",	
		
		-- Fel Stamina and Fel Energy DO cause threat! GRRRRRRR!!!
		--["felstamina"] = "Teufelsausdauer",
		--["felenergy"] = "Teufelsenergie",
		
		["bloodsiphon"] = "Bluttrinker", -- poisoned blood vs Hakkar
		
		["lifetap"] = "Aderlass", -- no mana gain threat
		["holyshield"] = "Heiliger Schild", -- multiplier
		["tranquility"] = "Gelassenheit",
		["distractingshot"] = "Ablenkender Schuss",
		["earthshock"] = "Erdschock",
		["rockbiter"] = "Felsbeißer",
		["fade"] = "Verblassen",
		["thunderfury"] = "Donnerzorn",
		
		-- Spell Sets
		-- warlock descruction
		["shadowbolt"] = "Schattenblitz",
		["immolate"] = "Feuerbrand",
		["conflagrate"] = "Feuersbrunst",
		["searingpain"] = "Sengender Schmerz", -- 2 threat per damage
		["rainoffire"] = "Feuerregen",
		["soulfire"] = "Seelenfeuer",
		["shadowburn"] = "Schattenbrand",
		["hellfire"] = "Hoellenfeuer",
		
		-- mage offensive arcane
		["arcaneexplosion"] = "Arkane Explosion",
		["counterspell"] = "Gegenzauber",
		
		-- priest shadow. No longer used (R17).
		["mindblast"] = "Gedankenschlag",	-- 2 threat per damage
		--[[
		["mindflay"] = "Gedankenschinden",
		["devouringplague"] = "Verschlingende Seuche",
		["shadowwordpain"] = "Schattenwort: Schmerz",
		,
		["manaburn"] = "Manabrand",
		]]
	},
	["power"] = 
	{
		["mana"] = "Mana",
		["rage"] = "Wut",
		["energy"] = "Energie",
	},
	["threatsource"] = -- these values are for user printout only
	{
		["powergain"] = "Power Gain",
		["total"] = "Total",
		["special"] = "Spezial",
		["healing"] = "Heilung",
		["dot"] = "DoTs",
		["threatwipe"] = "NPC Zauber",
		["damageshield"] = "Schadensschild",
		["whitedamage"] = "Weißer Schaden",
	},
	["talent"] = -- these values are for user printout only
	{
		["defiance"] = "Trotz",
		["impale"] = "Durchbohren",
		["silentresolve"] = "Schweigsame Entschlossenheit",
		["frostchanneling"] = "Frost-Kanalisierung",
		["burningsoul"] = "Brennende Seele",
		["healinggrace"] = "Geschick der Heilung",
		["shadowaffinity"] = "Schattenaffinität",
		["druidsubtlety"] = "Druide Feingefühl",
		["feralinstinct"] = "Instinkt der Wildnis",
		["ferocity"] = "Wildheit",
		["savagefury"] = "Ungezähmte Wut",
		["tranquility"] = "Verbesserte Gelassenheit",
		["masterdemonologist"] = "Meister der Dämonologie",
		["arcanesubtlety"] = "Arkanes Feingefühl",
		["righteousfury"] = "Zorn der Gerechtigkeit",
		["sleightofhand"] = "Kunstgriff",
		voidwalker = "Verbesserter Leerwandler",
	},
	["threatmod"] = -- these values are for user printout only
	{
		["tranquilair"] = "Totem der beruhigenden Winde",
		["salvation"] = "Segen der Rettung",
		["battlestance"] = "Kampfhaltung",
		["defensivestance"] = "Verteidigungshaltung",
		["berserkerstance"] = "Berserkerhaltung",
		["defiance"] = "Trotz",
		["basevalue"] = "Basiswert",
		["bearform"] = "Bärengestalt",
		["catform"] = "Katzengestalt",
		["glovethreatenchant"] = "+Bedrohung durch Handschuhverzauberung",
		["backthreatenchant"] = "-Bedrohung durch Umhangverzauberung",
	},
	
	["sets"] = 
	{
		["bloodfang"] = "Blutfang",
		["nemesis"] = "Nemesis",
		["netherwind"] = "Netherwind",
		["might"] = "der Macht",
		["arcanist"] = "des Arkanisten",
		bonescythe = "Knochensense",
		plagueheart = "des verseuchten Herzens",
	},
	["boss"] = 
	{
		["speech"] = 
		{
			onyxiapull = "I must leave my lair",
			onyxiaphase2 = "Diese sinnlose Anstrengung langweilt mich. Ich werde Euch alle von oben verbrennen!",
			["onyxiaphase3"] = "Mir scheint, dass Ihr noch eine Lektion braucht, sterbliche Wesen!",
			
			["razorgorepull"] = "flieht während die kontrollierenden Kräfte der Kugel schwinden",
			
			["azuregosport"] = "Kommt ihr Wichte! Tretet mir gegenüber!",
			["nefarianpull"] = "BRENNT! Ihr Elenden! BRENNT!",

			nightbaneland1 = "Genug! Ich werde landen und mich höchstpersönlich um Euch kümmern!",
			nightbaneland2 = "Insekten! Lasst mich Euch meine Kraft aus nächster Nähe demonstrieren!",
			nightbanepull = "Narren! Ich werde Eurem Leiden ein schnelles Ende setzen!",

			attumenmount = "Komm Mittnacht, lass' uns dieses Gesindel auseinander treiben!",
			magtheridonpull = "Ich... bin... frei!",
			
			
			hydrosspull = "Ich kann nicht zulassen, dass ihr Euch einmischt!",
			hydrossswap1 = "Aahh, das Gift...",
			hydrossswap2 = "Besser, viel besser.",
			
			leotherasswap = "Ich habe jetzt die Kontrolle!", -- this isn't the full line
			leotheraspull = "Endlich hat meine Verbannung ein Ende!",
		
			nothpull1 = "Ehre unserem Meister!",
			nothpull2 = "Euer Leben ist verwirkt!",
			nothpull3 = "Sterbt, Eindringling!",
			
			["rajaxxpull"] = "Unverschämter Narr! Ich werde euch höchstpersoenlich töten!",
			rajaxxignore = "You are not worth my time,? (%s)!",
			
			kaelthasphase1a = "Ihr habt gegen einige meiner besten Berater bestanden",
			kaelthasphase1b = "Capernian wird daf",
			kaelthasphase1c = "Gut gemacht. Ihr habt Euch würdig erwiesen, gegen meinen Meisteringenieur",
			kaelthasphase2 = "Wie Ihr seht, habe ich viele Waffen in meinem Arsenal...",
			kaelthasphase3 = "Vielleicht habe ich Euch unterschätzt.",
			kaelthasphase4 = "Ich bin nicht so weit gekommen, um jetzt noch aufgehalten zu werden!",
			kaelthasphase4b = "Ach, manchmal muss man die Sache selbst in die Hand nehmen.",	

			supremusphase1 = "schlägt wütend auf den Boden!",
			
			morogrimpull = "Die Fluten der Tiefen werden euch verschlingen",
			
			vashjpull1 = "Ich spucke auf Euch, Oberflächenbewohner",
			vashjpull2 = "Victory to Lord Illidan!",
			vashjpull3 = "Tod den Eindringlingen!",
			vashjpull4 = "Normalerweise würde ich mich nicht herablassen, Euresgleichen persönlich",
			
			solarianpull = "Tal anu'men no sin'dorei!",			
		},
		-- Some of these are unused. Also, if none is defined in your localisation, they won't be used,
		-- so don't worry if you don't implement it.
		["name"] = 
		{
			["rajaxx"] = "General Rajaxx",
			["onyxia"] = "Onyxia",
			["ebonroc"] = "Schattenschwinge",

			firemaw = "Feuerschwinge",
			flamegor = "Flammenmaul",

			["razorgore"] = "Feuerkralle der Ungezähmte",
			["thekal"] = "Hohepriester Thekal",
			["shazzrah"] = "Shazzrah",
			
			["twinempcaster"] = "Imperator Vek'lor",
			["twinempmelee"] = "Imperator Vek'nilash",
			
			["noth"] = "Noth der Seuchenfürst",
			ouro = "Ouro",
			voidreaver = "Leerhäscher",
			bloodboil = "Gurtogg Siedeblut",
			doomwalker = "Verdammniswandler",
			ragnaros = "Ragnaros",
			patchwerk = "Flickwerk",
			leotheras = "Leotheras der Blinde",
			
		},
		["spell"] = 
		{
			["shazzrahgate"] = "Portal von Shazzrah", -- "Shazzrah casts Gate of Shazzrah."
			["wrathofragnaros"] = "Zorn des Ragnaros", -- "Ragnaros's Wrath of Ragnaros hits you for 100 Fire damage."
			["timelapse"] = "Zeitraffer", -- "You are afflicted by Time Lapse."
			["knockaway"] = "Wegschlagen",
			["wingbuffet"] = "Flügelstoß",
			["burningadrenaline"] = "Brennendes Adrenalin",
			["twinteleport"] = "Zwillingsteleport",
			["nothblink"] = "Blinzeln",
			["sandblast"] = "Sandstoß",
			["fungalbloom"] = "Pilzwucher",
			["hatefulstrike"] = "Hasserfüllter Stoß",
			
			-- 4 horsemen marks
			mark1 = "Mal von Blaumeux",
			mark2 = "Mal von Korth'azz",
			mark3 = "Mal von Mograine",
			mark4 = "Mal von Zeliek",
			
			-- Onyxia fireball (presumably same as mage)
			fireball = "Feuerball",
			
			-- Leotheras, Maulgar, Sartura etc
			whirlwind = "Wirbelwind",
			
			insignifigance = "Bedeutungslosigkeit",
			felrage = "Teufelswut",
			eject = "Rauswurf",
			
			-- Doomwalker
			overrun = "Overrun",
		}
	},
	["misc"] = 
	{
		["imp"] = "Wichtel", -- UnitCreatureFamily("pet")
		["spellrank"] = "Rang (%d+)", -- second value of GetSpellName(x, "spell")
		["aggrogain"] = "Aggro bekommen",
	},

	-- labels and tooltips for the main window
	["gui"] ={ 
		["self"] = {
			["head"] = {
				-- column headers for the self view
				["name"] = "Name",
				["hits"] = "Treffer",
				["dam"] = "Schaden",
				["threat"] = "Bedrohung",
				["pc"] = "%B",			-- Abbreviation of %Threat
			},
			-- text on the self threat reset button
			["reset"] = "Zurücksetzen",
		},
	},
	["print"] = 
	{
		["main"] = 
		{
			["startupmessage"] = "|cffffff00KLHThreatMeter |cff33ff33%s.%s|r geladen. Gib |cffffff00/ktm|r ein um Hilfe zu erhalten.",
		},
		["data"] = 
		{
			["abilityrank"] = "Deine %s Fähigkeit ist Rang %s.",
			["globalthreat"] = "Dein globaler Bedrohungsmultiplikator ist %s.",
			["globalthreatmod"] = "%s gibt dir einen Wert von %s.",
			["multiplier"] = "Als %s wird deine Bedrohung durch %s mit %s multipliziert.",
			["damage"] = "Schaden",
			["shadowspell"] = "Schattenzauber",
			["arcanespell"] = "Arkanzauber",
			["holyspell"] = "Heiligzauber",
			["setactive"] = "%s %d Teile aktiv? ... %s.",
			["true"] = "ja",
			["false"] = "nein",
			["healing"] = "Deine Heilung verursacht %s Bedrohung (vor Einrechnung des globalen Bedrohungsmultiplikators).",
			["talentpoint"] = "Du hast %d Talentpunkte in %s.",
			["talent"] = "%d %s Talente gefunden.",
			["rockbiter"] = "Dein Rang %d Felsbeißer fügt %d Bedrohung zu erfolgreichen Nahkampfangriffen hinzu.",
		},
		
		-- new in R17.7
		["boss"] = 
		{
			["automt"] = "Das Hauptziel wurde automatisch auf |cffffff00%s|r gesetzt.",
			["spellsetmob"] = "|cffffff00%s|r legt den |cffffff00%s|r Parameter von |cffffff00%s|r's |cffffff00%s|r Fähigkeit von |cffffff00%s|r auf |cffffff00%s|r.", -- "Kenco sets the multiplier parameter of Onyxia's Knock Away ability to 0.7"
			["spellsetall"] = "|cffffff00%s|r legt die |cffffff00%s|r Parameter von |cffffff00%s|r Fähigkeiten von |cffffff00%s|r auf |cffffff00%s|r.",
			["reportmiss"] = "%s berichtet, dass %s's %s ihn verfehlt hat.",
			["reporttick"] = "%s berichtet, dass %s's %s ihn getroffen hat. Er hat bereits %s Stapelungen hinter sich und wird an %s mehr Stapelungen leiden.",
			["reportproc"] = "|cffffff00%s|r berichtet, dass |cffffff00%s|r's |cffffff00%s|r seine Bedrohung von |cffffff00%s|r zu |cffffff00%s|r geändert hat.",
			["bosstargetchange"] = "|cffffff00%s|r änderte das Ziel von |cffffff00%s|r (mit |cffffff00%s|r Bedrohung) zu |cffffff00%s|r (mit |cffffff00%s|r Bedrohung).",
			["autotargetstart"] = "Du wirst automatisch das Threatmeter löschen und das Hauptziel neu setzen, wenn du das nchste Mal einen Weltboss anvisierst.",
			["autotargetabort"] = "Das Hauptziel wurde bereits auf den Weltboss %s gesetzt.",
		},
		
		["network"] = 
		{
			["newmttargetnil"] = "Das neue Hauptziel |cffffff00%s|r konnte nicht festgelegt werden, da |cffffff00%s|r kein Ziel hat.",
			["newmttargetmismatch"] = "|cffffff00%s|r setzte das Hauptziel auf |cffffff00%s|r, aber sein eigenes Ziel ist |cffffff00%s|r. Sein eigenes Ziel wird stattdessen benutzt, bitte überprüfen!",
			["mtpollwarning"] = "Dein Hauptziel wurde auf |cffffff00%s|r gesetzt, aber dies konnte nicht überprüft werden. Falls es dir falsch erscheint, bitte |cffffff00%s|r das Hauptziel erneut bekanntzugeben.",
			["threatreset"] = "Das Threatmeter wurde von |cffffff00%s|r zurückgesetzt.",
			["newmt"] = "Das Hauptziel wurde auf |cffffff00%s|r festgelegt. (von |cffffff00%s|r)",
			["mtclear"] = "Das Hauptziel wurde von |cffffff00%s|r gelöscht.",
			["knockbackstart"] = "NPC Zaubemeldungen wurden von |cffffff00%s|r aktiviert.",
			["knockbackstop"] = "NPC Zaubermeldungen wurden von |cffffff00%s|r deaktiviert.",
			["aggrogain"] = "|cffffff00%s|r meldet 'Aggro bekommen' mit %d Bedrohung.",
			["aggroloss"] = "|cffffff00%s|r meldet 'Aggro verloren' mit %d Bedrohung.",
			["knockback"] = "|cffffff00%s|r meldet 'Rückstoß abbekommen'. Er ist runter auf %d Bedrohung.",
			["knockbackstring"] = "%s meldet diesen Rückstoßtext: '%s'.",
			["upgraderequest"] = "%s bittet dich um Upgrade auf Release %s von KLHThreatMeter. Du benutzt gerade Release %s.",
			["remoteoldversion"] = "%s benutzt die veraltete Version %s von KLHThreatMeter. Bitte sage ihm er soll auf Release %s upgraden.",
			["knockbackvaluechange"] = "|cffffff00%s|r hat die Bedrohungreduzierung von %s's |cffffff00%s|r Angriff auf |cffffff00%d%%|r gesetzt.",
			["raidpermission"] = "Du musst Schlachtzugsleiter oder Assistent sein um das zu tun!",
			["needmastertarget"] = "Du musst zuerst ein Hauptziel setzen!",
			["knockbackinactive"] = "Rückstoßentdeckung ist nicht aktiv im Schlachtzug.",
			["versionrequest"] = "Fordere Versionsinformationen des Schlachtzugs an. Antwort in 3 Sekunden.",
			["versionrecent"] = "Diese Leute haben Release %s: { ",
			["versionold"] = "Diese Leute haben ältere Versionen: { ",
			["versionnone"] = "Diese Leute haben kein KLHThreatMeter: { ",
			["channel"] = 
			{
				ctra = "CTRA Channel",
				ora = "oRA Channel",
				manual = "Manueller Eingriff",
			},
			needtarget = "Wähle zuerst einen Gegner aus, bevor du das Hauptziel setzt.",
			upgradenote = "Benutzer veralteter Versionen des Mods wurden zum Upgraden aufgefordert.",
			advertisestart = "Du wirst nun Spieler die Aggro ziehen dazu auffordern KLHThreatMeter zu installieren.",
			advertisestop = "Du hast aufgehört automatisch Werbung für KLHThreatMeter zu machen.",
			advertisemessage = "Wenn du KLHThreatMeter hättest, hättest du vielleicht keine Aggro gezogen, %s.",
		},
		
		-- ok, so autohide isn't really a word, but just improvise
		table = 
		{
			autohideon = "Das Fenster wird nun automatisch versteckt und angezeigt.",
			autohideoff = "Das Fenster wird nicht länger automatisch versteckt.",
		}
	}
}