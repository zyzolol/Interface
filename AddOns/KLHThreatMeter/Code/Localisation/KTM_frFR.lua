-- Translation by Minihunt EU@Ner'zhul
-- Maj - Mormegil EU@ELune v1.41 - 29/10/2007 - KTM 20.5a
-- Recherchez cette chaine "-- AC" pour les manques dans la traduction ( bossmods )


thismod.string.data["frFR"] = 
{
	copybox = "Pressez |cffffff00Ctrl + C|r pour copier le texte dans le presse-papier.",
	
	errorbox = 
	{
		header = "%s Error", -- %s == mod.global.name
		body = "Une erreur s'est produite dans %s. V\195\169rifiez les logs dans le menu help pour de plus amples d\195\169tails.\n\n",
		first = "Les prochaines occurrences de cette erreur seront supprim\195\169es.",
		second = "Toutes les prochaines erreurs seront supprim\195\169es.",
	},
	
	console = 
	{
		nocommand = "|Commande |cffffff00%s|r inconnue.",
		ambiguous = "Quelle commande souhaitez vous \195\169x\195\169cuter ?",
		run = "|cff8888ffEx\195\169cution de la commande %s|r.",
		
		help = 
		{
			test = 
			{
				["#help"] = "V\195\169rifie si le mod d\195\169tecte votre \195\169quipement, talents et autres valeurs correctement.",
				gear = "Liste les pi\195\168ces de set que vous portez affectant votre menace.",
				talents = "Liste vos points de talent d\195\169pens\195\169s dans des talents affectant votre menace.",
				threat = "Liste les diff\195\169rents parametres de menace.",
				time = "Affiche une information sur les temps processeur.",
				memory = "Affiche une information sur l'usage m\195\169moire.",
				states = "V\195\169rifie que le mod poss\195\168de les valeurs correctes pour ses variables d'\195\169tat.",
				locale = "V\195\169rifie les traductions manquantes dans votre langue.",
			},
			
			version = 
			{
				["#help"] = "Contr\195\180le des versions, N\195\169cessite des droits d'officier.",
				query = "R\195\169cup\195\169rer les versions des membres du groupe/raid.",
				notify = "Notifier aux utilisateurs qui utilisent une vieille version de la mettre \195\160 jour.",
			},
			
			gui = 
			{
				["#help"] = "Commandes basiques pour la fen\195\170tre de Raid.",
				show = "Affiche la fen\195\170tre de Raid.",
				hide = "Cache la fen\195\170tre de Raid.",
				reset = "R\195\169initialise la fen\195\170tre de Raid au milieu de l \195\169cran."
			},
			
			boss = 
			{
				["#help"] = "Fonctions d\195\169terminant les abilit\195\169s des boss.",
				report = "Activer la mise \195\160 jour des joueurs dont la menace est modifi\195\169e par une abilit\195\169 connue.",
				endreport = "Stopper la mise \195\160 jour des joueurs dont la menace est modifi\195\169e par une abilit\195\169 connue.",
				setspell = "Changer un param\195\170tre pour une abilit\195\169 connue d'un boss.",
			},
			
			disable = "Arr\195\170t d'urgence : d\195\169sactivation Events/OnUpdate.",
			enable = "Red\195\169marrer le mod apr\195\168s un arr\195\170t d'urgence.",
			mastertarget = "D\195\169fini ou d\195\169s\195\169lectionne la cible principale.",
			resetraid = "R\195\169initialise la menace du Raid.",
			help = "Affiche l'aide.",
			
		},
	},
	
	["raidtable"] = 
	{
		tooltip = 
		{
			close = "Fermer",
			closetext = "Cache cette fen\195\170tre.",
			options = "Options",
			optionstext = "Configure la disposition et le mod\195\168le de couleur de cette fen\195\170tre.",
			minimise = "R\195\169duire",
			minimisetext = "R\195\169duit le tableau, laisse seulement la partie haute visible. Cliquez encore pour r\195\169tablir le tableau.",
			setmt = "D\195\169signer la cible principale",
			setmttext = "D\195\169signe la cible actuelle comme cible principale ou d\195\169s\195\169lectionne la cible principale si vous n'avez pas de cible.",
		},
		
		column = 
		{
			name = "Nom",
			threat = "Total",
			percent = "%Max", -- Pourcentage par rapport au max, doit etre court !
			persecond = "MPS", -- Menace par seconde, doit etre court !
		},
	},
	["menu"] = 
	{
		top = 
		{
			description = "Acceuil",
			text = "Bienvenu dans le menu |cffffff00%s |cff00ff00%s.%s|r.\n\nC'est le sujet d'acceuil. Le nom du sujet actuel est donn\195\169 dans la boite au-dessus de lui. Les barres \195\160 gauche montre les sujets li\195\169s \195\160 celui-ci.\n\nLa boite en haut \195\160 gauche est le sujet principal de l'actuel sujet. Cliquez dessus pour revenir au sujet pr\195\169c\195\169dant.\n\nLes boites en dessous sont les sous sujets de l'actuel sujet. Cliquez dessus pour voir un sous sujet en particulier.\n\nPour cacher le menu d'aide, cliquez sur le bouton X en haut \195\160 droite de l'actuelle boite de sujet.",
		},
		
		raidtable = 
		{
			description = "Tableau de Raid",
			text = "Cette section configure l'affichage du tableau de raid.\n\nLa section de |cffffff00Mod\195\168le de couleur|r vous permet de changer la couleur des polices de caract\195\168re et des cadres.\n\nDans la section |cffffff00Disposition|r vous pourrez changer la taille et l'orientation du tableau.\n\nLa section |cffffff00Lignes et colonnes|r change les colonnes visibles dans le tableau et contr\195\180le le filtre de classe.",
			button = "Afficher le tableau", -- Verifier la taille lors de l'affichage dans le bouton
			
			colour = 
			{
				description = "Mod\195\168le de couleur",
				
				text1 = "Cliquez ici pour changer la couleur des contours du tableau de raid:",
				button1 = "Contours",
				text2 = "Cliquez ici pour changer la couleur des textes importants\n(Ex: pour les ent\195\170tes):",
				button2 = "Textes importants",
				text3 = "Cliquez ici pour changer la couleur des textes mineurs\n(Ex: pour les textes normaux):",
				button3 = "Textes mineurs",
				text4 = "D\195\169finit la transparence (Valeur Alpha). 100% est compl\195\168tement visible, 0% est invisible.",
				slider = "Valeur Alpha",
			},
			
			layout = 
			{
				description = "Disposition",

				text1 = "Ici, vous pouvez sp\195\169cifier comment le tableau se rempli. Un coin du cadre est toujours fixe, et le tableau se d\195\169veloppera en dehors, dans la direction oppos\195\169e. Ainsi, si le point fixe est en haut gauche, le tableau augmentera en bas vers la droite d'autant selon les besoins. Cliquez sur les boutons pour changer de point fixe.",
				button1 = "Haut gauche",
				button2 = "Haut droit",
				button3 = "Bas gauche",
				button4 = "Bas droit",

				text2 = "D\195\169fini le nombre maximum de lignes dans le tableau de raid.",
				slider = "Lignes",

				text3 = "Si cette option est s\195\169lectionn\195\169e, le tableau affiche uniquement les entr\195\169es actives. Sinon, sa taille restera fixe.",
				checkbox = "Tableau compact",

				text4 = "Change la taille de tous les \195\169l\195\169ments du tableau de raid",
				slider2 = "Redimentionner",
			},
			
			filter = 
			{
				description = "Lignes et colonnes",
				text1 = "S\195\169lectionnez les classes que vous souhaitez afficher dans le tableau de raid.",
				text2 = "S\195\169lectionnez les colonnes que vous souhaitez afficher dans le tableau de raid.",

				threat = "Montrer la colonne d'aggro.",
				percent = "Montrer la colonne de pourcentage (%s).",
				persecond = "Montrer la colonne de menace par seconde (%s).",

				text3 = "La barre de |cffffff00%s|r pr\195\169voit de combien de menaces vous avez besoin pour prendre l'aggro. Si le tank souffre temporairement d'une absence de menace comme une peur, il reprendra l'aggro quand elle finit si le DPS est inf\195\169rieur \195\160 la valeur de la barre de |cffffff00%s|r.",

				aggrogain = "Montrer la barre de |cffffff00%s|r.",
				tankregain = "Montrer la barre de |cffffff00%s|r. ",
			},
			
			misc = 
			{
				description = "Divers",
				text1 = "Configurez la fen\195\170tre pour qu'elle s'affiche ou se cache automatiquement quand vous rejoignez ou quittez un groupe.",
				leavegroup = "Cacher la fen\195\170tre quand je quitte un groupe/raid.",
				joinparty = "Afficher la fen\195\170tre quand je rejoins un groupe.",
				joinraid = "Afficher la fen\195\170tre quand je rejoins un raid.",

				text2 = "Vous pouvez \195\169viter le d\195\169placement de la fen\195\170tre une fois qu'elle est correctement positionn\195\169e.",
				lockwindow = "Verrouiller la fen\195\170tre.",
			}
		},
		
		mythreat = 
		{
			description = "Stats de ma menace",
			reset = "R\195\169initialiser",
			update = "Mettre \195\160 jour",
		},
		
		errorlog = 
		{
			description = "Journal d'erreur",

			text1 = "Cette section liste toutes les erreurs non critiques qui se sont produites dans les modules du mod. Le mod peut continuer de fonctionner, mais quelques composants doivent s'arr\195\170ter, ainsi votre menace pourrait ne pas \195\170tre \195\169num\195\169r\195\169e correctement.\n\nLe mieux est de rapporter ces erreurs sur le site Web,\n |cffffff00%s|r .",

			text2 = "Montrer l'erreur %d sur %d.",

			button1 = "Copier l'adresse Web",
			button2 = "Erreur pr\195\169c\195\169dente",
			button3 = "Erreur suivante",
			button4 = "Copier les d\195\169tails de l'erreur",

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
			text = "Cette section configure les bossmods.\n\nLa section |cffffff00Built-in|r affiche une liste de bossmods int\195\169gr\195\169s.\n\nLa section |cffffff00User Made|r affiche une liste des bossmods personnels. Vous pouvez cr\195\169er vos propres bossmods et les enregistrer dans un fichier ou les partager dans le Raid.",
			
			builtin = 
			{
				description = "Built-in",
				text1 = "Voici la liste des bossmods int\195\169gr\195\169s. Cliquez dans la liste pour plus de d\195\169tails.",
			},
			
			usermade = 
			{
				description = "User Made",
				text1 = "Cliquez dans la liste pour plus de d\195\169tails. Cliquez sur |cffffff00Broadcast|r pour partager avec le Raid. |cffffff00Exporter|r converti le module en une chaine de texte r\195\169cup\195\169rable par le bouton |cffffff00Importer|r .\nCliquez sur  |cffffff00Nouveau|r pour cr\195\169er un nouveau module, |cffffff00Effacer|r pour supprimer, ou |cffffff00Editer|r pour le modifier.", 
				
				button = 
				{
					import = "Importer",
					export = "Exporter",
					broadcast = "Broadcast",
				}
			}
		}
		
	},
	
	generic = 
	{
		finish = "Finir",
		cancel = "Annuler",
		close = "Fermer",
		delete = "Effacer",
		edit = "Editer",
		new = "Nouveau",
		next = "Suivant",
		back = "Pr\195\169c\195\169dent",
	},
	
	wizard = 
	{
		editboss = 
		{
			header = "Modifier le bossmod |cffffff00%s|r .",
			description = "Selectionner un nom pour le bossmod. Il doit correspondre exactement au nom du boss en question. Une liste de suggestion se trouve sur la droite. Cliquez sur un \195\169l\195\169ment pour utiliser ce nom.\nCliquez sur |cffffff00Finish|r pour enregistrer ce bossmod, ou |cffffff00Cancel|r pour annuler. |cffffff00Next|r pour aller \195\160 la section Emote du Boss.",
		},
		customhandler = 
		{
			heading = "Cr\195\169er un nouveau d\195\169clencheur pour |cffffff00%s.",
			description = "• N'enlevez pas de code dans |cffffff00function ... end|r\n• Vous aurez acc\195\168s a ces variables:\n1) |cffffff00mod|r - pointeur pour la table %s \n2) |cffffff00data|r - donn\195\169es stock\195\169es pour la fonction (empty table)\n• Quelques codes utiles:\n1) |cffffff00value = mod.table.getraidthreat()|r - votre menace actuelle\n2) |cffffff00Quelquechose a propos des resets de la menace du raid|r - lol",
			error = "Echec lors de la compilation. L'erreur est\n|cffffff00%s.",
		}
	},
	
	class = 
	{
		warrior = "Guerrier",
		priest = "Pr\195\170tre",
		druid = "Druide",
		rogue = "Voleur",
		shaman = "Chaman",
		mage = "Mage",
		paladin = "Paladin",
		warlock = "D\195\169moniste",
		hunter = "Chasseur",
	},
	
	["binding"] = 
	{
		hideshow = "Cache / Affiche la fen\195\170tre",
		stop = "Arr\195\170t d'urgence",
		mastertarget = "D\195\169signe / D\195\169s\195\169lectionne la cible principale",
		resetraid = "R\195\169initialise la menace du raid",
	},
	["spell"] = 
	{
		
		feigndeath = "Feindre la mort",

		-- 19
		vampirictouch = "Toucher vampirique",
		bindingheal = "Soins de lien",
		leaderofthepack = "Chef de la meute",
		faeriefire = "Lucioles (farouche)",
		shadowguard = "Garde de l'ombre",
		anesthetic = "Poison anesth\195\169siant",
		bearmangle = "Mutilation (ours)",
		thunderclap = "Coup de tonnerre",
		soulshatter = "Brise-\195\162me",
		invisibility = "Invisibilit\195\169",
		misdirection = "D\195\169tournement",
		disengage = "D\195\169sengagement",
		anguish = "Angoisse", -- Felguard
		lacerate = "Lac\195\169rer",
		
		-- 18.x
		torment = "Tourment",
		suffering = "Souffrance",
		soothingkiss = "Baiser apaisant",
		intimidation = "Intimidation",
		
		righteousdefense = "D\195\169fense vertueuse",
		eyeofdiminution = "L'Oeil de diminution", -- buff from trinket "Eye of Diminution". The buff appears to be slightly different, with 'The' at the start.
		notthere = "Absent", -- the buff from Frostfire 8/8 Proc ( tenue de parade de givrefeu bonus 8/8 )
		frostshock = "Horion de givre",
		reflectiveshield = "Bouclier r\195\169flecteur", -- this is the damage from Power Word:Shield with the talent.
		devastate = "D\195\169vaster",
		stormstrike = "Frappe-temp\195\170te",
		
		-- Sorts d'affliction du d\195\169moniste (Les autres existent d\195\169j\195\160 plus haut)
		corruption = "Corruption",
		curseofagony = "Mal\195\169diction d'agonie",
		drainsoul = "Siphon d'\195\162me",
		curseofdoom = "Mal\195\169diction funeste",
		unstableaffliction = "Affliction instable",
		
		-- Nouveaux sorts d\195\169moniste
		shadowfury = "Furie de l'ombre",
		incinerate = "Incin\195\169rer",
		
		-- 17.20
		["execute"] = "Ex\195\169cution",
		
		["heroicstrike"] = "Frappe h\195\169roïque",
		["maul"] = "Mutiler",
		["swipe"] = "Balayage",
		["shieldslam"] = "Heurt de bouclier",
		["revenge"] = "Vengeance",
		["shieldbash"] = "Coup de bouclier",
		["sunder"] = "Fracasser armure",
		["feint"] = "Feinte",
		["cower"] = "D\195\169robade",
		["taunt"] = "Provocation",
		["growl"] = "Grondement",
		["vanish"] = "Disparition",
		["frostbolt"] = "Eclair de givre",
		["fireball"] = "Boule de feu",
		["arcanemissiles"] = "Projectiles des arcanes",
		["scorch"] = "Br\195\187lure",
		["cleave"] = "Encha\195\174nement",
		
		hemorrhage = "H\195\169morragie",
		backstab = "Attaque sournoise",
		sinisterstrike = "Attaque pernicieuse",
		eviscerate = "Evisc\195\169ration",
		
		-- Items / Buffs:
		["arcaneshroud"] = "Voile des arcanes",
		["blackamnesty"] = "R\195\169duction de la menace",

		-- Leeches: no threat from heal
		["holynova"] = "Nova sacr\195\169e", -- no heal or damage threat
		["siphonlife"] = "Siphon de vie", -- no heal threat
		["drainlife"] = "Drain de vie", -- no heal threat
		["deathcoil"] = "Voile mortel",
		
		-- Fel Stamina and Fel Energy DO cause threat! GRRRRRRR!!!
		--["felstamina"] = "Endurance corrompue",
		--["felenergy"] = "Energie corrompue",
		
		["bloodsiphon"] = "Siphon de sang", -- poisoned blood vs Hakkar
		
		["lifetap"] = "Connexion", -- no mana gain threat
		["holyshield"] = "Bouclier sacr\195\169", -- multiplier
		["tranquility"] = "Tranquillit\195\169",
		["distractingshot"] = "Trait provocateur",
		["earthshock"] = "Horion de terre",
		["rockbiter"] = "Arme Croque-roc",
		["fade"] = "Oubli",
		["thunderfury"] = "Lame-tonnerre",
		
		-- Spell Sets
		-- warlock descruction
		["shadowbolt"] = "Trait de l'ombre",
		["immolate"] = "Immolation",
		["conflagrate"] = "Conflagration",
		["searingpain"] = "Douleur br\195\187lante", -- 2 threat per damage
		["rainoffire"] = "Pluie de feu",
		["soulfire"] = "Feu de l'\195\162me",
		["shadowburn"] = "Br\195\187lure de l'ombre",
		["hellfire"] = "Effet Flammes infernales",
		
		-- mage offensive arcane
		["arcaneexplosion"] = "Explosion des arcanes",
		["counterspell"] = "Contresort",
		
		-- priest shadow. No longer used (R17).
		["mindblast"] = "Attaque mentale",	-- 2 threat per damage
		--[[
		["mindflay"] = "Fouet mental",
		["devouringplague"] = "Peste d\195\169vorante",
		["shadowwordpain"] = "Mot de l'ombre : Douleur",
		,
		["manaburn"] = "Br\195\187lure de mana",
		]]
	},
	["power"] = 
	{
		["mana"] = "Mana",
		["rage"] = "Rage",
		["energy"] = "Energie",
	},
	["threatsource"] = -- these values are for user printout only
	{
		["powergain"] = "Gain de puissance",
		["total"] = "Total",
		["special"] = "Sp\195\169ciaux",
		["healing"] = "Soins",
		["dot"] = "Dots",
		["threatwipe"] = "Sort de PNJ",
		["damageshield"] = "Boucliers de d\195\169g\195\162ts",
		["whitedamage"] = "Dommages blancs",
	},
	["talent"] = -- these values are for user printout only
	{
		["defiance"] = "D\195\169fi",
		["impale"] = "Empaler",
		["silentresolve"] = "R\195\169solution silencieuse",
		["frostchanneling"] = "Canalisation du givre",
		["burningsoul"] = "Ame ardente",
		["healinggrace"] = "Gr\195\162ce gu\195\169risseuse",
		["shadowaffinity"] = "Affinit\195\169 avec l'ombre",
		["druidsubtlety"] = "Discr\195\169tion",
		["feralinstinct"] = "Instinct farouche",
		["ferocity"] = "F\195\169rocit\195\169",
		["savagefury"] = "Furie sauvage",
		["tranquility"] = "Tranquillit\195\169 am\195\169lior\195\169e",
		["masterdemonologist"] = "Ma\195\174tre d\195\169monologue",
		["arcanesubtlety"] = "Subtilit\195\169 des arcanes",
		["righteousfury"] = "Fureur vertueuse",
		["sleightofhand"] = "Passe-passe",
		voidwalker = "Marcheur du Vide am\195\169lior\195\169",
	},
	["threatmod"] = -- these values are for user printout only
	{
		["tranquilair"] = "Totem de Tranquillit\195\169 de l'air",
		["salvation"] = "B\195\169n\195\169diction de salut",
		["battlestance"] = "Posture de combat",
		["defensivestance"] = "Posture d\195\169fensive",
		["berserkerstance"] = "Posture berserker",
		["defiance"] = "D\195\169fi",
		["basevalue"] = "Valeur de base",
		["bearform"] = "Forme d'ours sinistre",
		["catform"] = "Forme de F\195\169lin",
		["glovethreatenchant"] = "Enchantement +2% menace sur gants",
		["backthreatenchant"] = "Enchantement -2% menace sur cape",
	},
	
	["sets"] = 
	{
		["bloodfang"] = "Rougecroc",
		["nemesis"] = "N\195\169m\195\169sis",
		["netherwind"] = "Vent du n\195\169ant",
		["might"] = "Courroux",
		["arcanist"] = "Arcaniste",
		bonescythe = "Faucheuse d'os",
		plagueheart = "Pestecoeur",
	},
	["boss"] = 
	{
		["speech"] = 
		{
			onyxiapull = "I must leave my lair", -- AC
			onyxiaphase2 = "un seul coup !",
			["onyxiaphase3"] = "Il semble que vous ayez besoin d'une autre le\195\167on, mortels !",
			
			["razorgorepull"] = "Sonnez l'alarme",
			["thekalphase2"] = "fill me with your RAGE", -- AC
			["azuregosport"] = "Venez m'affronter, mes petits !",
			["nefarianpull"] = "BR\195\155LEZ, mis\195\169rables",
			
			nightbaneland1 = "Assez ! Je vais atterrir et vous \195\169craser moi-m\195\170me !",
			nightbaneland2 = "Insectes ! Je vais vous montrer de quel bois je me chauffe !",
			nightbanepull = "Fous ! Je vais mettre un terme \195\160 vos souffrances !",
			
			attumenmount = "Viens, Minuit, allons disperser cette insignifiante racaille",
			magtheridonpull = "Me... voil\195\160... d\195\169cha\195\174n\195\169",
			ragnarospull = "ET MAINTENANT", -- pas complete
			
			hydrosspull = "Je ne peux pas vous laisser nous g\195\170ner !",
			hydrossswap1 = "Aaarrgh, le poison...",
			hydrossswap2 = "va mieux. Beaucoup mieux.", -- nerf la majuscule oO'
			
			leotherasswap = "Hors d'ici, elfe insignifiant. Je prends le contr\195\180le !",
			leotheraspull = "Enfin, mon exil s'ach\195\168ve !",
			
			nothpull1 = "Gloire au ma\195\174tre !",
			nothpull2 = "Vos vies ne valent plus rien !",
			nothpull3 = "Mourez, intrus !",
						
			rajaxxpull = "Imb\195\169cile imprudent ! Je vais te tuer moi-m\195\170me !",
			rajaxxignore = "You are not worth my time,? (%s)!", -- AC
			
			kaelthasphase1a = "Vous avez tenu t\195\170te \195\160 certains de mes plus talentueux conseillers…", -- pas complete
			kaelthasphase1b = "Capernian fera en sorte que votre s\195\169jour ici ne se prolonge pas.", -- pas complete
			kaelthasphase1c = "Bien, vous \195\170tes dignes de mesurer votre talent \195\160 celui de mon ma\195\174tre ing\195\169nieur, Telonicus.",
			kaelthasphase2 = "Comme vous le voyez, j'ai plus d'une corde \195\160 mon arc…",
			kaelthasphase3 = "Peut-\195\170tre vous ai-je sous-estim\195\169s.", -- pas complete
			kaelthasphase4 = "Je ne suis pas arriv\195\169 si loin pour \195\169chouer maintenant !", -- pas complete
			kaelthasphase4b = "Il est h\195\169las parfois n\195\169cessaire de prendre les choses en main soi-m\195\170me.", -- pas complete
			
			supremusphase1 = "De rage, Supremus frappe le sol !",
			
			morogrimpull = "Que les flots des profondeurs vous emportent !", -- a verifier
			
			vashjpull1 = "Je te crache dessus, racaille de la surface !", -- a verifier
			vashjpull2 = "Victoire au seigneur Illidan !", -- a verifier
			vashjpull3 = "Mort aux \195\169trangers !", -- a verifier
			vashjpull4 = "J'esp\195\169rais ne pas devoir m'abaisser \195\160 affronter des cr\195\169atures de la surface, mais vous ne me laissez pas le choix…", -- a verifier
			
			solarianpull = "Tal anu'men no sin'dorei!", -- OK frFR

			reliquaryphase2 = "Vous pouvez avoir tout ce que vous d\195\169sirez… en y mettant le prix.", -- a verifier
			reliquaryphase3 = "Beware: I live!", -- AC

			illidanphase1 = "Vous n'\195\170tes pas pr\195\170ts !", -- a verifier
			illidanphase3 = "Contemplez la puissance... du d\195\169mon int\195\169rieur !", -- a verifier
			illidanphase4 = "You know nothing of power!", -- AC
			illidanphase5 = "C'est tout, mortels ? Est-ce l\195\160 toute la fureur que vous pouvez \195\169voquer ?", -- a verifier
			
		},
		-- Some of these are unused. Also, if none is defined in your localisation, they won't be used,
		-- so don't worry if you don't implement it.
		["name"] = 
		{
			["rajaxx"] = "G\195\169n\195\169ral Rajaxx",
			["onyxia"] = "Onyxia",
			["ebonroc"] = "Roch\195\169b\195\168ne",
			firemaw = "Gueule-de-feu",
			flamegor = "Flamegor", -- la meme en FR ^^
			
			["razorgore"] = "Tranchetripe l'Indompt\195\169",
			["thekal"] = "Grand pr\195\170tre Thekal",
			["shazzrah"] = "Shazzrah",
			["twinempcaster"] = "Empereur Vek'lor",
			["twinempmelee"] = "Empereur Vek'nilash",
			["noth"] = "Noth le Porte-peste",
			["leotheras"] = "Leotheras l'Aveugle",
			ouro = "Ouro", -- ok FR
			voidreaver = "Saccageur du Vide",
			bloodboil = "Gurtogg Fi\195\168vresang",
			doomwalker = "Marche-funeste",
			ragnaros = "Ragnaros",
			patchwerk = "Le Recousu",
			leotheras = "Leotheras l'Aveugle",

			azzinoth = "Flamme d'Azzinoth", -- DON'T BLIND COPY. If you don't know it set to nil!
			azzinothblade = "Blade of Azzinoth", -- AC

		},
		["spell"] = 
		{
			["shazzrahgate"] = "Porte de Shazzrah", -- "Shazzrah casts Gate of Shazzrah."
			["wrathofragnaros"] = "Col\195\168re de Ragnaros", -- "Ragnaros's Wrath of Ragnaros hits you for 100 Fire damage."
			["timelapse"] = "Trou du temps", -- "You are afflicted by Time Lapse."
			--["knockaway"] = "Renversement", -- Repousser au loin de Saccageur du Vide / Donjon de la tempete ( ??? )
			["knockaway"] = "Repousser au loin", -- Test OK sur Void Reaver !!!
			["wingbuffet"] = "Frappe des ailes",
			["burningadrenaline"] = "Mont\195\169e d'adr\195\169naline",
			["twinteleport"] = "T\195\169l\195\169portation des jumeaux",
			["nothblink"] = "Transfert",
			["sandblast"] = "Explosion de sable",
			["fungalbloom"] = "Floraison fongique",
			["hatefulstrike"] = "Frappe haineuse",
			
			-- 4 horsemen marks
			mark1 = "Marque de Blaumeux",
			mark2 = "Marque de Korth'azz",
			mark3 = "Marque de Mograine",
			mark4 = "Marque de Zeliek",
			
			-- Onyxia fireball (presumably same as mage)
			fireball = "Boule de feu",
			
			-- Leotheras, Maulgar, Sartura etc
			whirlwind = "Tourbillon",
            
         		-- Gurtogg Bloodboil
			insignifigance = "Insignifiance",
			eject = "Ejection",
			felrage = "Gangrerage",
			
			-- Doomwalker
			overrun = "Renversement",

			-- Essence of Souls
			seethe = "Bouillant de rage", -- a verifier

			-- illidan
			summonblade = "Invocation de la Larme d'Azzinoth", -- a verifier
		}
	},
	["misc"] = 
	{
		["imp"] = "Imp", -- UnitCreatureFamily("pet")
		["spellrank"] = "Rang (%d+)", -- second value of GetSpellName(x, "spell")
		["aggrogain"] = "Gain d'aggro",
		tankregain = "Reprise d'aggro",
	},

	-- labels and tooltips for the main window
	["gui"] ={ 
		["self"] = {
			["head"] = {
				-- column headers for the self view
				["name"] = "Nom",
				["hits"] = "touch\195\169",
				["dam"] = "Dmg",
				["threat"] = "Menace",
				["pc"] = "%M",			-- Abbreviation of %Menace
			},
			-- text on the self threat reset button
			["reset"] = "R\195\169initialiser",
		},
	},
	["print"] = 
	{
		["main"] = 
		{
			["startupmessage"] = "|cffffff00KLHThreatMeter |cff33ff33%s.%s|r charg\195\169. Tapez |cffffff00/ktm|r pour l'aide.",
		},
		["data"] = 
		{
			["abilityrank"] = "Votre abilit\195\169 %s est de rang %s.",
			["globalthreat"] = "Votre multiplicateur global de menace est %s.",
			["globalthreatmod"] = "%s vous donne %s.",
			["multiplier"] = "En tant que %s, votre menace de %s est multipli\195\169e par %s.",
			["damage"] = "dommage",
			["shadowspell"] = "sorts d'ombre",
			["arcanespell"] = "sorts d'arcane",
			["holyspell"] = "sort de sacr\195\169",
			["setactive"] = "%s %d pi\195\168ces actives ? ... %s.",
			["healing"] = "Vos soins g\195\169n\195\168re %s de menace (avant la multiplication globale de menace).",
			["talentpoint"] = "Vous avez %d point(s) de talents dans %s.",
			["talent"] = "%d %s talents trouv\195\169s.",
			["rockbiter"] = "Votre rang %d de Rockbiter ajoute %d menace aux attaques en m\195\169l\195\169e r\195\169ussies.",
		},
		
		-- new in R17.7
		["boss"] = 
		{
			["automt"] = "La cible principale a \195\169t\195\169 automatiquement d\195\169sign\195\169e sur |cffffff00%s|r.",
			["spellsetmob"] = "|cffffff00%s|r change le param\195\168tre de |cffffff00%s|r du talent de |cffffff00%s|r de |cffffff00%s|r vers |cffffff00%s|r.",
			["spellsetall"] = "|cffffff00%s|r change le param\195\168tre de |cffffff00%s|r du talent de |cffffff00%s|r de |cffffff00%s|r \195\160 |cffffff00%s|r.",
			["reportmiss"] = "%s vous informe que %s l'a manqu\195\169.",
			["reporttick"] = "%s vous informe que %s l'a touch\195\169. Il a subi %s tick(s), et sera affect\195\169 de %s tick(s) de plus.",
			["reportproc"] = "|cffffff00%s|r signale que |cffffff00%s|r |cffffff00%s|r a chang\195\169 son niveau de menace de |cffffff00%s|r \195\160 |cffffff00%s|r.",
			["bosstargetchange"] = "|cffffff00%s|r a chang\195\169 de cible de |cffffff00%s|r (avec |cffffff00%s|r de menace) vers |cffffff00%s|r (avec |cffffff00%s|r de menace).",
			["autotargetstart"] = "Vous devez automatiquement effacer la mesure et d\195\169finir la cible principale quand votre prochaine cible sera un world boss.",
			["autotargetabort"] = "La cible principale a d\195\169j\195\160 \195\169t\195\169 d\195\169sign\195\169e sur le world boss %s.",
		},
		
		["network"] = 
		{
			["newmttargetnil"] = "Impossible de confirmer la cible principale sur |cffffff00%s|r, parce que |cffffff00%s|r n'a pas de cible.",
			["newmttargetmismatch"] = "|cffffff00%s|r a d\195\169sign\195\169 la cible principale sur |cffffff00%s|r, mais sa propre cible est |cffffff00%s|r. Utilisation de sa propre cible, v\195\169rifiez !",
			["mtpollwarning"] = "Mise \195\160 jour de votre cible principale d\195\169sign\195\169e sur |cffffff00%s|r, mais cela ne peut pas \195\170tre confirm\195\169. Demandez \195\160 |cffffff00%s|r de redistribuer la cible principale si cela ne semble pas correct.",
			["threatreset"] = "La mesure de la menace du raid a \195\169t\195\169 r\195\169initialis\195\169e par |cffffff00%s|r.",
			["newmt"] = "La cible principale a \195\169t\195\169 d\195\169sign\195\169e sur |cffffff00%s|r par |cffffff00%s|r.",
			["mtclear"] = "La cible principale a \195\169t\195\169 d\195\169s\195\169lectionn\195\169e par |cffffff00%s|r.",
			["knockbackstart"] = "Le rapport des sorts de PNJ a \195\169t\195\169 activ\195\169 par |cffffff00%s|r.",
			["knockbackstop"] = "Le rapport des sorts de PNJ d\195\169sactiv\195\169 par |cffffff00%s|r.",
			["aggrogain"] = "|cffffff00%s|r vous pr\195\169vient d'un gain d'aggro avec %d de menace.",
			["aggroloss"] = "|cffffff00%s|r vous pr\195\169vient d'une perte d'aggro avec %d de menace.",
			["knockback"] = "|cffffff00%s|r vous pr\195\169vient qu'il subit un knock away. Il est descendu \195\160 %d de menace.",
			["knockbackstring"] = "%s vous pr\195\169vient du contrecoup suivant: '%s'.",
			["upgraderequest"] = "%s vous averti de mettre \195\160 jour \195\160 la version %s de KLHThreatMeter. Vous utilisez actuellement la version %s.",
			["remoteoldversion"] = "%s utilise une version %s p\195\169rim\195\169 de KLHThreatMeter. Pr\195\169venez le qu'il puisse mettre \195\160 jour vers la version %s.",
			["knockbackvaluechange"] = "|cffffff00%s|r a d\195\169fini la r\195\169duction de la menace de %s |cffffff00%s|r attaque \195\160 |cffffff00%d%%|r.",
			["raidpermission"] = "Vous devez \195\170tre le responsable du raid ou un assistant pour faire cela !",
			["needmastertarget"] = "Vous devez d'abord d\195\169signer une cible principale!",
			["knockbackinactive"] = "La d\195\169couverte des contrecoups n'est pas active dans le raid.",
			["versionrequest"] = "Demande d'information sur la version du raid. R\195\169ponse dans 3 secondes.",
			["versionrecent"] = "Ces personnes utilisent la version %s: { ",
			["versionold"] = "Ces personnes utilisent une ancienne version: { ",
			["versionnone"] = "Ces personnes n'ont pas KLHThreatMeter: { ",
			needtarget = "D\195\169signez un mob s\195\169lectionn\195\169 comme cible principale.",
			upgradenote = "Les utilisateurs d'anciennes versions ont \195\169t\195\169 inform\195\169s qu'une mise \195\160 jour est disponible.",
		},
	}
}
