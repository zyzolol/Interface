
thismod.string.data["enUS"] = 
{
	copybox = "Press |cffffff00Ctrl + C|r to copy the text to the clipboard.",
	
	errorbox = 
	{
		header = "%s Error", -- %s == mod.global.name
		body = "An error has occurred in %s. Check the Error Log section of the Help Menu for a detailed report.\n\n",
		first = "Further occurrences of this error will be suppressed.",
		second = "All further errors will be suppressed.",
	},
	
	console = 
	{
		nocommand = "|cffff8888There is no command |cffffff00%s|r.",
		ambiguous = "Which of the following commands did you mean?",
		run = "|cff8888ffRunning the command %s|r.",
		
		help = 
		{
			test = 
			{
				["#help"] = "Test the mod is detecting gear, talents and other values correctly.",
				gear = "Prints out the set pieces you are wearing for sets that affect your threat.",
				talents = "Prints out your talent points in any talents that affect your threat.",
				threat = "Prints out a variety of threat parameters.",
				time = "Prints out processor time information.",
				memory = "Prints out memory usage information.",
				states = "Check that the mod has the correct value for its state variables.",
				locale = "Check for translations that are missing in your locale.",
			},
			
			version = 
			{
				["#help"] = "Version contol commands. Requires officer permission.",
				query = "Asks everyone in the group to report their version.",
				notify = "Notifies users with an older version of the mod to upgrade.",
			},
			
			gui = 
			{
				["#help"] = "Basic commands for the raid window.",
				show = "Shows the raid window.",
				hide = "Hides the raid window.",
				reset = "Reset the raid window to the middle of the screen."
			},
			
			boss = 
			{
				["#help"] = "Functions to determine and set boss abilities.",
				report = "Make players silently report when their threat is changed by boss abilities.",
				endreport = "Stop players reporting when their threat is changed by boss abilities.",
				setspell = "Change a parameter of a known boss ability.",
			},
			
			disable = "Emergency stop: disables events / onupdate.",
			enable = "Restart the mod after an emergency stop.",
			mastertarget = "Set or clear the Master Target.",
			resetraid = "Reset the threat of everyone in the raid group.",
			help = "Shows the Help Menu.",
			
		},
	},
	
	["raidtable"] = 
	{
		tooltip = 
		{
			close = "Close",
			closetext = "Hide this window.",
			options = "Options",
			optionstext = "Configure the layout and colour scheme of this window.",
			minimise = "Minimise",
			minimisetext = "Minimise the table, leaving only the top section shown. Click again to reveal the table.",
			setmt = "Set Master Target",
			setmttext = "Sets the Master Target to your current target, or clears the Master Target if you have to target selected.",
		},
		
		column = 
		{
			name = "Name",
			threat = "Threat",
			percent = "%Max", -- percentage of maximum, but has to be short!
			persecond = "TPS", -- threat per second. again, must be short.
		},
	},
	["menu"] = 
	{
		top = 
		{
			description = "Home",
			text = "Welcome to the |cffffff00%s |cff00ff00%s.%s|r Menu.\n\nThis is the Home topic. The name of the current topic is given in the box above it. The bar on the left shows topics related to this one.\n\nThe top left box is the parent of the current topic. Click it to return to the previous topic.\n\nThe boxes below it are the subtopics of the current topic. Click on them to view the particular subtopic.\n\nTo hide the help menu, click the X button in the top right of the current topic box.",
		},
		
		raidtable = 
		{
			description = "Raid Table",
			text = "This section configures the display of the raid table.\n\nThe |cffffff00Colour Scheme|r section allows you to change the font and frame colours.\n\nIn the |cffffff00Layout|r section you can change the size and direction of the table.\n\nThe |cffffff00Rows and Columns|r section changes the visible columns in the table and controls class filters.",
			button = "Show Raid Table",
			
			colour = 
			{
				description = "Colour Scheme",
				
				text1 = "Click here to change the Raid Table's border colour:",
				button1 = "Set Border Colour",
				text2 = "Click here to change the Major Text colour (e.g. for headings):",
				button2 = "Set Major Text Colour",
				text3 = "Click here to change the Minor Text colour (e.g. for normal text):",
				button3 = "Set Minor Text Colour",
				text4 = "Set the Transparency (alpha value). 100% is fully visible, 0% is invisible.",
				slider = "Alpha Value",
			},
			
			layout = 
			{
				description = "Layout",
				
				text1 = "Here you can specify how the table fills up. One corner of the frame is always fixed, and the table will grow out in the opposite direction. So if the fixed point is Top Left, the table will expand downwards and to the right as much as necessary. Click the buttons to change the fixed point.",
				button1 = "Top Left",
				button2 = "Top Right",
				button3 = "Bottom Left",
				button4 = "Bottom Right",
				
				text2 = "Set the maximum number of rows in the raid table.",
				slider = "Rows",
				
				text3 = "If this option is selected, the table will decrease its length if there are few entries. Otherwise it will have a fixed size.",
				checkbox = "Compact Table",
				
				text4 = "Change the size of all elements of the raid table",
				slider2 = "Scale",
			},
			
			filter = 
			{
				description = "Rows and Columns",
				text1 = "Select the classes you want to be showed in the raid table.",
				text2 = "Select the columns you want in the raid table.",
				
				threat = "Show the Threat column.",
				percent = "Show the Percent column (%s).",
				persecond = "Show the Threat Per Second column (%s).",
				
				text3 = "The |cffffff00%s|r bar predicts how much threat you need to pull aggro. If the tank suffers a temporary threat wipe such as a fear, he will regain aggro when it ends if the DPS are below the value of the |cffffff00%s|r bar.",
			
				aggrogain = "Show the |cffffff00%s|r bar.",
				tankregain = "Show the |cffffff00%s|r bar. ",
			},
			
			misc = 
			{
				description = "Miscellaneous",
				text1 = "Configure the window to automatically show or hide itself when you join or leave a party.",
				leavegroup = "Hide the window when I leave a group.",
				joinparty = "Show the window when I join a party.",
				joinraid = "Show the window when I join a raid.",
				
				text2 = "You can prevent the window from being dragged once it is positioned correctly.",
				lockwindow = "Lock the window in place.",
			}
		},
		
		mythreat = 
		{
			description = "My Threat Stats",
			reset = "Reset",
			update = "Update",
		},
		
		errorlog = 
		{
			description = "Error Log",
			
			text1 = "This section lists any noncritical errors that have occurred in modules of the addon. The addon can continue to operate, but some components will stop working, so your threat might not be listed accurately.\n\nIt's best to report these errors at the webpage, |cffffff00%s|r .",
			
			text2 = "Showing error %d of %d.",
			
			button1 = "Copy Webpage Address",
			button2 = "Previous Error",
			button3 = "Next Error",
			button4 = "Copy Error Details",
			
			format = 
			{
				module = "|cffffff00Module =|r %s",
				process = "|cffffff00Process =|r %s",
				extradata = "|cffffff00Extra Data =|r %s",
				message = "|cffffff00Error Message =|r %s",
			},
		},
		
		bossmod = 
		{
			description = "Boss Mods",
			text = "This section configures the addon's boss mods.\n\nThe |cffffff00Built-in|r section has a list of boss mods that come with the addon.\n\nThe |cffffff00User Made|r section has a list of user made boss mods. You can design your own boss mods and export them to file or broadcast them to the raid group.",
			
			builtin = 
			{
				description = "Built-in",
				text1 = "Here is a list of built in boss mods. Click on an item in the list for details.",
			},
			
			usermade = 
			{
				description = "User Made",
				text1 = "Click on an item in the list to view the boss mod's details. Click |cffffff00Broadcast|r to send the mod to the raid group. |cffffff00Export|r converts the mod to a text string that other users can load with the |cffffff00Import|r button.\nClick |cffffff00New|r to make a new mod, |cffffff00Delete|r to delete the selected mod, or |cffffff00Edit|r to change it.", 
				
				button = 
				{
					import = "Import",
					export = "Export",
					broadcast = "Broadcast",
				}
			}
		}
		
	},
	
	generic = 
	{
		finish = "Finish",
		cancel = "Cancel",
		close = "Close",
		delete = "Delete",
		edit = "Edit",
		new = "New",
		next = "Next",
		back = "Back",
	},
	
	wizard = 
	{
		editboss = 
		{
			header = "Change the |cffffff00%s|r boss mod.",
			description = "Select a name for the Boss Mod and enter it below. If it contains spell events, make sure it matches the boss' actual name exactly. A list of suggested names is shown on the right. Click an item in the list to use that name.\nClick |cffffff00Finish|r to complete the boss mod, or |cffffff00Cancel|r to prevent all changes. |cffffff00Next|r takes you to the Speech section.",
		},
		customhandler = 
		{
			heading = "Create a custom handler for |cffffff00%s.",
			description = "• Don't wrap the code in  |cffffff00function ... end|r\n• You will be given access the these variables:\n1) |cffffff00mod|r - pointer to %s table\n2) |cffffff00data|r - persistent data store for the function (empty table)\n• Some useful code:\n1) |cffffff00value = mod.table.getraidthreat()|r - your current threat\n2) |cffffff00something about the raid reset here|r - lol",
			error = "The function does not compile. The error is\n|cffffff00%s.",
		}
	},
	
	class = 
	{
		warrior = "Warrior",
		priest = "Priest",
		druid = "Druid",
		rogue = "Rogue",
		shaman = "Shaman",
		mage = "Mage",
		paladin = "Paladin",
		warlock = "Warlock",
		hunter = "Hunter",
	},
	
	["binding"] = 
	{
		hideshow = "Hide / Show Window",
		stop = "Emergency Stop",
		mastertarget = "Set / Clear Master Target",
		resetraid = "Reset Raid Threat",
	},
	["spell"] = 
	{
		feigndeath = "Feign Death",
		mortalstrike = "Mortal Strike",
		bloodthirst = "Bloodthirst",
		
		-- 19
		vampirictouch = "Vampiric Touch",
		bindingheal = "Binding Heal",
		leaderofthepack = "Leader of the Pack",
		faeriefire = "Faerie Fire (Feral)",
		shadowguard = "Shadowguard",
		anesthetic = "Anesthetic Poison",
		bearmangle = "Mangle (Bear)",
		thunderclap = "Thunder Clap",
		soulshatter = "Soulshatter",
		invisibility = "Invisibility",
		misdirection = "Misdirection",
		disengage = "Disengage",
		anguish = "Anguish", -- Felguard
		lacerate = "Lacerate", 
		
		-- 18.x
		torment = "Torment",
		suffering = "Suffering",
		soothingkiss = "Soothing Kiss",
		intimidation = "Intimidation",
		
		righteousdefense = "Righteous Defense",
		eyeofdiminution = "The Eye of Diminution", -- buff from trinket "Eye of Diminution". The buff appears to be slightly different, with 'The' at the start.
		notthere = "Not There", -- the buff from Frostfire 8/8 Proc
		frostshock = "Frost Shock", 
		reflectiveshield = "Reflective Shield", -- this is the damage from Power Word:Shield with the talent.
		devastate = "Devastate",
		stormstrike = "Stormstrike",
		
		-- warlock affliction spells (others already existed below)
		corruption = "Corruption",				
		curseofagony = "Curse of Agony",
		drainsoul = "Drain Soul",
		curseofdoom = "Curse of Doom",
		unstableaffliction = "Unstable Affliction",
		
		-- new warlock destruction spells
		shadowfury = "Shadowfury",
		incinerate = "Incinerate", 
		
		-- 17.20
		["execute"] = "Execute",
		
		["heroicstrike"] = "Heroic Strike",
		["maul"] = "Maul",
		["swipe"] = "Swipe",
		["shieldslam"] = "Shield Slam",
		["revenge"] = "Revenge",
		["shieldbash"] = "Shield Bash",
		["sunder"] = "Sunder Armor",
		["feint"] = "Feint",
		["cower"] = "Cower",
		["taunt"] = "Taunt",
		["growl"] = "Growl",
		["vanish"] = "Vanish",
		["frostbolt"] = "Frostbolt",
		["fireball"] = "Fireball",
		["arcanemissiles"] = "Arcane Missiles",
		["scorch"] = "Scorch",
		["cleave"] = "Cleave",
		
		hemorrhage = "Hemorrhage",
		backstab = "Backstab",
		sinisterstrike = "Sinister Strike",
		eviscerate = "Eviscerate",
		
		-- Items / Buffs:
		["arcaneshroud"] = "Arcane Shroud",
		["blackamnesty"] = "Reduce Threat",

		-- Leeches: no threat from heal
		["holynova"] = "Holy Nova", -- no heal or damage threat
		["siphonlife"] = "Siphon Life", -- no heal threat
		["drainlife"] = "Drain Life", -- no heal threat
		["deathcoil"] = "Death Coil",	
		
		-- Fel Stamina and Fel Energy DO cause threat! GRRRRRRR!!!
		--["felstamina"] = "Fel Stamina",
		--["felenergy"] = "Fel Energy",
		
		["bloodsiphon"] = "Blood Siphon", -- poisoned blood vs Hakkar
		
		["lifetap"] = "Life Tap", -- no mana gain threat
		["holyshield"] = "Holy Shield", -- multiplier
		["tranquility"] = "Tranquility",
		["distractingshot"] = "Distracting Shot",
		["earthshock"] = "Earth Shock",
		["rockbiter"] = "Rockbiter",
		["fade"] = "Fade",
		["thunderfury"] = "Thunderfury",
		
		-- Spell Sets
		-- warlock descruction
		["shadowbolt"] = "Shadow Bolt",
		["immolate"] = "Immolate",
		["conflagrate"] = "Conflagrate",
		["searingpain"] = "Searing Pain", -- 2 threat per damage
		["rainoffire"] = "Rain of Fire",
		["soulfire"] = "Soul Fire",
		["shadowburn"] = "Shadowburn",
		["hellfire"] = "Hellfire Effect",
		
		-- mage offensive arcane
		["arcaneexplosion"] = "Arcane Explosion",
		["counterspell"] = "Counterspell",
		
		-- priest shadow. No longer used (R17).
		["mindblast"] = "Mind Blast",	-- 2 threat per damage
		--[[
		["mindflay"] = "Mind Flay",
		["devouringplague"] = "Devouring Plague",
		["shadowwordpain"] = "Shadow Word: Pain",
		,
		["manaburn"] = "Mana Burn",
		]]
	},
	["power"] = 
	{
		["mana"] = "Mana",
		["rage"] = "Rage",
		["energy"] = "Energy",
	},
	["threatsource"] = -- these values are for user printout only
	{
		["powergain"] = "Power Gain",
		["total"] = "Total",
		["special"] = "Specials",
		["healing"] = "Healing",
		["dot"] = "Dots",
		["threatwipe"] = "NPC Spells",
		["damageshield"] = "Damage Shields",
		["whitedamage"] = "White Damage",
	},
	["talent"] = -- these values are for user printout only
	{
		improvedberserker = "Improved Berserker Stance",
		tacticalmastery = "Tactical Mastery",
		fanaticism = "Fanaticism",
		["defiance"] = "Defiance",
		["impale"] = "Impale",
		["silentresolve"] = "Silent Resolve",
		["frostchanneling"] = "Frost Channeling",
		["burningsoul"] = "Burning Soul",
		["healinggrace"] = "Healing Grace",
		["shadowaffinity"] = "Shadow Affinity",
		["druidsubtlety"] = "Druid Subtlety",
		["feralinstinct"] = "Feral Instinct",
		["ferocity"] = "Ferocity",
		["savagefury"] = "Savage Fury",
		["tranquility"] = "Improved Tranquility",
		["masterdemonologist"] = "Master Demonologist",
		["arcanesubtlety"] = "Arcane Subtlety",
		["righteousfury"] = "Righteous Fury",
		["sleightofhand"] = "Sleight of Hand",
		voidwalker = "Improved Voidwalker",
	},
	["threatmod"] = -- these values are for user printout only
	{
		["tranquilair"] = "Tranquil Air Totem",
		["salvation"] = "Blessing of Salvation",
		["battlestance"] = "Battle Stance",
		["defensivestance"] = "Defensive Stance",
		["berserkerstance"] = "Berserker Stance",
		["defiance"] = "Defiance",
		["basevalue"] = "Base Value",
		["bearform"] = "Bear Form",
		["catform"] = "Cat Form",
		["glovethreatenchant"] = "+Threat Enchant to Gloves",
		["backthreatenchant"] = "-Threat Enchant to Back",
	},
	
	["sets"] = 
	{
		["bloodfang"] = "Bloodfang",
		["nemesis"] = "Nemesis",
		["netherwind"] = "Netherwind",
		["might"] = "Might",
		["arcanist"] = "Arcanist",
		bonescythe = "Bonescythe",
		plagueheart = "Plagueheart",
	},
	["boss"] = 
	{
		["speech"] = 
		{
			onyxiapull = "I must leave my lair",
			onyxiaphase2 = "This meaningless exertion bores me. I'll incinerate you all from above!",
			["onyxiaphase3"] = "It seems you'll need another lesson",
			
			["razorgorepull"] = "flee as the controlling power of the orb is drained.",
			["thekalphase2"] = "fill me with your RAGE",
			["azuregosport"] = "Come, little ones",
			["nefarianpull"] = "BURN! You wretches! BURN!",
			
			nightbaneland1 = "Enough! I shall land and crush you myself!",
			nightbaneland2 = "Insects! Let me show you my strength up close!",
			nightbanepull = "What fools! I shall bring a quick end to your suffering!",
			
			attumenmount = "Come Midnight, let's disperse this petty rabble!",
			magtheridonpull = "I... am... unleashed!",
			ragnarospull = "YOU HAVE AWAKENED ME TOO SOON",
			
			hydrosspull = "I cannot allow you to interfere!",
			hydrossswap1 = "Aaghh, the poison...",
			hydrossswap2 = "Better, much better.",
			
			leotherasswap = "Be gone, trifling elf", -- this isn't the full line
			leotheraspull = "Finally, my banishment ends!",
			
			nothpull1 = "Glory to the master!",
			nothpull2 = "Your life is forfeit.",
			nothpull3 = "Die trespasser!",
						
			rajaxxpull = "Impudent fool! I will kill you myself!",
			rajaxxignore = "You are not worth my time,? (%s)!",
			
			kaelthasphase1a = "You have persevered against some of my best advisors",
			kaelthasphase1b = "Capernian will see to it",
			kaelthasphase1c = "Well done, you have proven worthy to test your skills",
			kaelthasphase2 = "As you see, I have many weapons in my arsenal.",
			kaelthasphase3 = "Perhaps I underestimated you.",
			kaelthasphase4 = "I have not come this far to be stopped!",
			kaelthasphase4b = "Alas, sometimes one must take matters",
			
			supremusphase1 = "punches the ground in anger",
			
			morogrimpull = "Flood of the deep, take you!",
			
			vashjpull1 = "I spit on you, surface filth!",
			vashjpull2 = "Victory to Lord Illidan!",
			vashjpull3 = "Death to the outsiders! Victory to Lord Illidan!",
			vashjpull4 = "I did not wish to lower myself by engaging your kind",
			
			solarianpull = "Tal anu'men no sin'dorei!",
			
			reliquaryphase2 = "You can have anything you desire... for a price.",
			reliquaryphase3 = "Beware: I live!",
			
			illidanphase1 = "You are not prepared!",
			illidanphase3 = "Behold the power... of the demon within!",
			illidanphase4 = "You know nothing of power!",
			illidanphase5 = "Is this it, mortals?",
			
		},
		-- Some of these are unused. Also, if none is defined in your localisation, they won't be used,
		-- so don't worry if you don't implement it.
		["name"] = 
		{
			["rajaxx"] = "General Rajaxx",
			["onyxia"] = "Onyxia",
			["ebonroc"] = "Ebonroc",
			firemaw = "Firemaw",
			flamegor = "Flamegor",
			
			["razorgore"] = "Razorgore the Untamed",
			["thekal"] = "High Priest Thekal",
			["shazzrah"] = "Shazzrah",
			["twinempcaster"] = "Emperor Vek'lor",
			["twinempmelee"] = "Emperor Vek'nilash",
			["noth"] = "Noth the Plaguebringer",
			["leotheras"] = "Leotheras the Blind",
			ouro = "Ouro",
			voidreaver = "Void Reaver",
			bloodboil = "Gurtogg Bloodboil",
			doomwalker = "Doomwalker",
			ragnaros = "Ragnaros",
			patchwerk = "Patchwerk",
			leotheras = "Leotheras the Blind",
			
			azzinoth = "Flame of Azzinoth", -- DON'T BLIND COPY. If you don't know it set to nil!
			azzinothblade = "Blade of Azzinoth",
			
		},
		["spell"] = 
		{
			["shazzrahgate"] = "Gate of Shazzrah", -- "Shazzrah casts Gate of Shazzrah."
			["wrathofragnaros"] = "Wrath of Ragnaros", -- "Ragnaros's Wrath of Ragnaros hits you for 100 Fire damage."
			["timelapse"] = "Time Lapse", -- "You are afflicted by Time Lapse."
			["knockaway"] = "Knock Away",
			["wingbuffet"] = "Wing Buffet",
			["burningadrenaline"] = "Burning Adrenaline",
			["twinteleport"] = "Twin Teleport",
			["nothblink"] = "Blink",
			["sandblast"] = "Sand Blast",
			["fungalbloom"] = "Fungal Bloom",
			["hatefulstrike"] = "Hateful Strike",
			
			-- 4 horsemen marks
			mark1 = "Mark of Blaumeux",
			mark2 = "Mark of Korth'azz",
			mark3 = "Mark of Mograine",
			mark4 = "Mark of Zeliek",
			
			-- Onyxia fireball (presumably same as mage)
			fireball = "Fireball",
			
			-- Leotheras, Maulgar, Sartura etc
			whirlwind = "Whirlwind",
            
         -- Gurtogg Bloodboil
         insignifigance = "Insignifigance",
			eject = "Eject",
			felrage = "Fel Rage",
			
			-- Doomwalker
			overrun = "Overrun",
			
			-- Essence of Souls
			seethe = "Seethe",
			
			-- illidan
			summonblade = "Summon Tear of Azzinoth",
		}
	},
	["misc"] = 
	{
		["imp"] = "Imp", -- UnitCreatureFamily("pet")
		["spellrank"] = "Rank (%d+)", -- second value of GetSpellName(x, "spell")
		["aggrogain"] = "Aggro Gain",
		tankregain = "Tank Regain",
	},

	-- labels and tooltips for the main window
	["gui"] ={ 
		["self"] = {
			["head"] = {
				-- column headers for the self view
				["name"] = "Name",
				["hits"] = "Hits",
				["dam"] = "Damage",
				["threat"] = "Threat",
				["pc"] = "%T",			-- Abbreviation of %Threat
			},
			-- text on the self threat reset button
			["reset"] = "Reset",
		},
	},
	["print"] = 
	{
		["main"] = 
		{
			["startupmessage"] = "|cffffff00KLHThreatMeter |cff33ff33%s.%s|r loaded. Type |cffffff00/ktm|r for help.",
		},
		["data"] = 
		{
			["abilityrank"] = "Your %s ability is rank %s.",
			["globalthreat"] = "Your global threat multiplier is %s.",
			["globalthreatmod"] = "%s gives you %s.",
			["multiplier"] = "As a %s, your threat from %s is multiplied by %s.",
			["damage"] = "damage",
			["shadowspell"] = "shadow spells",
			["arcanespell"] = "arcane spells",
			["holyspell"] = "holy spells",
			["setactive"] = "%s %d piece active? ... %s.",
			["healing"] = "Your healing causes %s threat (before global threat multiplier).",
			["talentpoint"] = "You have %d talent points in %s.",
			["talent"] = "Found %d %s talents.",
			["rockbiter"] = "Your rank %d Rockbiter adds %d threat to successful melee attacks.",
		},
		
		-- new in R17.7
		["boss"] = 
		{
			["automt"] = "The master target has been automatically set to |cffffff00%s|r.",
			["spellsetmob"] = "|cffffff00%s|r sets the |cffffff00%s|r parameter of |cffffff00%s|r's |cffffff00%s|r ability to |cffffff00%s|r from |cffffff00%s|r.", -- "Kenco sets the multiplier parameter of Onyxia's Knock Away ability to 0.7"
			["spellsetall"] = "|cffffff00%s|r sets the |cffffff00%s|r parameter of the |cffffff00%s|r ability to |cffffff00%s|r from |cffffff00%s|r.",
			["reportmiss"] = "%s reports that %s's %s missed him.",
			["reporttick"] = "%s reports that %s's %s hit him. He has suffered %s ticks, and will be affected in %s more ticks.",
			["reportproc"] = "|cffffff00%s|r reports that |cffffff00%s|r's |cffffff00%s|r changed his threat from |cffffff00%s|r to |cffffff00%s|r.",
			["bosstargetchange"] = "|cffffff00%s|r changed tagets from |cffffff00%s|r (on |cffffff00%s|r threat) to |cffffff00%s|r (on |cffffff00%s|r threat).",
			["autotargetstart"] = "You will automatically clear the meter and set the master target when you next target a world boss.",
			["autotargetabort"] = "The master target has already been set to the world boss %s.",
		},
		
		["network"] = 
		{
			["newmttargetnil"] = "Could not confirm the master target |cffffff00%s|r, because |cffffff00%s|r has no target.",
			["newmttargetmismatch"] = "|cffffff00%s|r sets the master target to |cffffff00%s|r, but his own target is |cffffff00%s|r. Using his own target instead, check this!",
			["mtpollwarning"] = "Updated your master target to |cffffff00%s|r, but could not confirm this. Ask |cffffff00%s|r to rebroadcast the master target if this does not sound correct.",
			["threatreset"] = "The raid threat meter was cleared by |cffffff00%s|r.",
			["newmt"] = "The master target has been set to |cffffff00%s|r by |cffffff00%s|r.",
			["mtclear"] = "The master target has been cleared by |cffffff00%s|r.",
			["knockbackstart"] = "NPC Spell reporting has been activated by |cffffff00%s|r.",
			["knockbackstop"] = "NPC Spell reporting has been stopped by |cffffff00%s|r.",
			["aggrogain"] = "|cffffff00%s|r reports gaining aggro with %d threat.",
			["aggroloss"] = "|cffffff00%s|r reports losing aggro with %d threat.",
			["knockback"] = "|cffffff00%s|r reports suffering a knock away. He's down to %d threat.",
			["knockbackstring"] = "%s reports this knockback text: '%s'.",
			["upgraderequest"] = "%s urges you to upgrade to Release %s of KLHThreatMeter. You are currently using Release %s.",
			["remoteoldversion"] = "%s is using the outdated Release %s of KLHThreatMeter. Please tell him to upgrade to Release %s.",
			["knockbackvaluechange"] = "|cffffff00%s|r has set the threat reduction of %s's |cffffff00%s|r attack to |cffffff00%d%%|r.",
			["raidpermission"] = "You need to be the raid leader or an assistant to do that!",
			["needmastertarget"] = "You have to set a master target first!",
			["knockbackinactive"] = "Knockback discovery is not active in the raid.",
			["versionrequest"] = "Requesting version information from the raid. Responses in 3 seconds.",
			["versionrecent"] = "These people have release %s: { ",
			["versionold"] = "These people have older versions: { ",
			["versionnone"] = "These people do not have KLHThreatMeter: { ",
			needtarget = "Target the mob to select as the master target first.",
			upgradenote = "Older versions of the mod have been notified to upgrade.",
		},
	}
}
