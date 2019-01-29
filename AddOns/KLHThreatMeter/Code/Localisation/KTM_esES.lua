
thismod.string.data["esES"] = 
{
	copybox = "Pulsa |cffffff00Ctrl + C|r para copiar el texto al portapapeles.",
	
	errorbox = 
	{
		header = "Error en %s", -- %s == mod.global.name
		body = "Ha ocurrido un error en %s. Mira en la secci\195\179n de Registro de errores del men\195\186 ayuda para ver un informe detallado.\n\n",
		first = "Las siguientes ocurrencias de este error ser\195\161n suprimidas.",
		second = "Todos los siguientes errores ser\195\161n suprimidos.",
	},
	
	console = 
	{
		nocommand = "|cffff8888No hay comando |cffffff00%s|r.",
		ambiguous = "¿A cu\195\161l de los siguientes comandos te refieres?",
		run = "|cff8888ffEjecutando el comando %s|r.",
		
		help = 
		{
			test = 
			{
				["#help"] = "Pruebas de detecci\195\179n de equipo, talentos y otros valores.",
				gear = "Imprime el conjunto de piezas equipadas para bonificaciones de conjuntos que afectan tu amenaza.",
				talents = "Imprime los puntos gastados en talentos que afectan tu amenaza.",
				threat = "Imprime distintos par\195\161metros de amenaza.",
				time = "Imprime informaci\195\179n sobre el uso del procesador.",
				memory = "Imprime informaci\195\179n sobe el uso de memoria.",
				states = "Comprueba que el mod tiene el valor correcto para sus variables de estado.",
				locale = "Comprueba traducciones que faltan de localizaci\195\179n.",
			},
			
			version = 
			{
				["#help"] = "Comandos de control de versi\195\179n. Requiere permisos de oficial.",
				query = "Pregunta a todos los jugadores de tu grupo la versi\195\179n que utilizan.",
				notify = "Notifica a jugadores con versiones antiguas que deben actualizar el mod.",
			},
			
			gui = 
			{
				["#help"] = "Comandos b\195\161sicos para la ventana de Banda.",
				show = "Muestra la ventana de banda.",
				hide = "Oculta la ventana de banda.",
				reset = "Restablece la posici\195\179n de la ventana de banda al centro de la pantalla."
			},
			
			boss = 
			{
				["#help"] = "Funciones para determinar y establecer facultades de jefes que modifican la amenaza.",
				report = "Los jugadores informan cuando su amenaza cambia a partir de la facultad de un jefe.",
				endreport = "Los jugadores no informan cuando su amenaza cambia a partir de la facultad de un jefe.",
				setspell = "Cambiar par\195\161metros de una facultado conocida de un jefe que modifica amenaza.",
			},
			
			disable = "Parada de emergencia: deshabilita eventos / onupdate.",
			enable = "Reiniciar el mod tras una parada cr\195\173tica.",
			mastertarget = "Establecer o eliminar el Objetivo Principal.",
			resetraid = "Reiniciar la amenaza de todos los jugadores de la banda.",
			help = "Muestra el men\195\186 de ayuda.",
			
		},
	},
	
	["raidtable"] = 
	{
		tooltip = 
		{
			close = "Cerrar",
			closetext = "Ocultar ventana.",
			options = "Opciones",
			optionstext = "Configurar dise\195\177o y esquema de colores para esta ventana.",
			minimise = "Minimizar",
			minimisetext = "Minimizar tabla, dejando solo la parte de arriba. Clic otra vez para mostrarla de nuevo.",
			setmt = "Establecer objetivo principal",
			setmttext = "Establece el objetivo principal a tu objetivo actual o lo borra si no tienes un objetivo seleccionado.",
		},
		
		column = 
		{
			name = "Nombre",
			threat = "Puntos",
			percent = "%Max", -- percentage of maximum, but has to be short!
			persecond = "APS", -- threat per second. again, must be short.
		},
	},
	["menu"] = 
	{
		top = 
		{
			description = "Inicio",
			text = "Bienvenido al men\195\186 |cffffff00%s |cff00ff00%s.%s|r.\n\nEste es el tema de inicio. El nombre del tema actual se proporciona en la caja de encima. La barra de la izquierda muestra temas relacionados con este.\n\nLa caja superior izquierda es el tema superior al actual. Clic para volver al tema anterior.\n\nLas cajas inferiores son los sub-temas del tema actual. Clic para ver un sub-tema en particular.\n\nPara ocultar el men\195\186 de ayuda, pulsa el bot\195\179n X en la parte superior derecha de la caja del tema actual.",
		},
		
		raidtable = 
		{
			description = "Tabla de amenaza",
			text = "Esta secci\195\179n configura la visualizaci\195\179n de la tabla de amenaza.\n\nLa secci\195\179n |cffffff00esquema de color|r te permite cambiar la fuente y los colores de la ventana.\n\nEn la secci\195\179n |cffffff00dise\195\177o|r puedes cambiar el tama\195\177o y la direcci\195\179n de la tabla.\n\nLa secci\195\179n |cffffff00filas y columnas|r cambia las columnas visibles en la tabla y controla los filtros de clase.",
			button = "Mostrar tabla",
			
			colour = 
			{
				description = "Esquema de color",
				
				text1 = "Cambia el color del borde de la tabla de amenaza:",
				button1 = "Color de borde",
				text2 = "Cambia el color del texto principal (las cabeceras):",
				button2 = "Color texto principal",
				text3 = "Cambia el color del texto secundario (texto normal):",
				button3 = "Color texto secundario",
				text4 = "Establece la transparencia (valor alpha). 100% es completamente visible, 0% es invisible.",
				slider = "Transparencia",
			},
			
			layout = 
			{
				description = "Dise\195\177o",
				
				text1 = "Aqu\195\173 puedes especificar como se llena la tabla. Una esquina de la tabla est\195\161 siempre fija y la tabla crecer\195\161 en la direcci\195\179n opuesta. As\195\173, si el punto fijo es la esquina superior izquierda, la tabla crecer\195\161 hacia abajo y a la derecha tanto como sea necesario. Pulsa los botones para cambiar el punto fijo.",
				button1 = "Superior Izquierda",
				button2 = "Superior Derecha",
				button3 = "Inferior Izquierda",
				button4 = "Inferior Derecha",
				
				text2 = "Establece el m\195\161ximo n\195\186mero de filas en la tabla.",
				slider = "Filas",
				
				text3 = "Activando la siguiente opci\195\179n la tabla se reducir\195\161 sus filas autom\195\161ticamente si hay pocas entradas. En caso contrario tendr\195\161 siempre un n\195\186mero fijo de filas.",
				checkbox = "Tabla compacta",
				
				text4 = "Cambia el tama\195\177o de todos los elementos de la tabla de amenaza.",
				slider2 = "Escala",
			},
			
			filter = 
			{
				description = "Filas y columnas",
				text1 = "Selecciona las clases que quieres mostrar en la tabla.",
				text2 = "Selecciona las columnas que quieres mostrar en la tabla.",
				
				threat = "Mostrar columna de puntos de amenaza.",
				percent = "Mostrar columna de porcentaje (%s).",
				persecond = "Mostrar columna de amenaza por segundo (%s).",
				
				text3 = "La barra |cffffff00%s|r predice la cantidad de amenaza que necesitas para ganar agro. Si el tanque sufre una p\195\169rdida de amenaza temporal causada por la facultad de un enemigo (como el miedo), ganar\195\161 agro de nuevo cuando esta desaparezca si el DPS se mantiene por debajo del valor de la barra |cffffff00%s|r.",
			
				aggrogain = "Mostrar barra |cffffff00%s|r.",
				tankregain = "Mostrar barra |cffffff00%s|r. ",
			},
			
			misc = 
			{
				description = "Otras opciones",
				text1 = "Configura la ventana para que aparezca o desaparezca autom\195\161ticamente cuando te unes a o abandonas un grupo/banda.",
				leavegroup = "Ocultar ventana al abandonar un grupo/banda.",
				joinparty = "Mostrar ventana al unirse a un grupo.",
				joinraid = "Mostrar ventana al unirse a una banda.",
				
				text2 = "Previene que la ventana pueda ser movida una vez la tienes en la posici\195\179n deseada.",
				lockwindow = "Fijar ventana.",
			}
		},
		
		mythreat = 
		{
			description = "Mis estad\195\173sticas de amenaza",
			reset = "Borrar",
			update = "Actualizar",
		},
		
		errorlog = 
		{
			description = "Registro de errores",
			
			text1 = "Esta secci\195\179n lista todos los errores no cr\195\173ticos que han ocurrido en m\195\179dulos del accesorio. El accesorio seguir\195\161 activo pero algunos componentes dejar\195\161n de funcionar; haciendo que la amenza no se muestre con precisi\195\179n.\n\nEs aconsejable notificar estos errores en la p\195\161gina Web |cffffff00%s|r .",
			
			text2 = "Mostrando error %d de %d.",
			
			button1 = "Copiar direcci\195\179n Web",
			button2 = "Error anterior",
			button3 = "Error siguiente",
			button4 = "Copiar detalles del error",
			
			format = 
			{
				module = "|cffffff00Module =|r %s",
				process = "|cffffff00Process =|r %s",
				extradata = "|cffffff00Extra Data =|r %s",
				message = "|cffffff00Error Message =|r %s",
			},
		}
		
	},
	
	class = 
	{
		warrior = "Guerrero",
		priest = "Sacerdote",
		druid = "Druida",
		rogue = "P\195\173caro",
		shaman = "Cham\195\161n",
		mage = "Mago",
		paladin = "Palad\195\173n",
		warlock = "Brujo",
		hunter = "Cazador",
	},
	
	["binding"] = 
	{
		hideshow = "Ocultar/Mostrar ventana",
		stop = "Parada de emergencia",
		mastertarget = "Establecer/Borrar objetivo principal",
		resetraid = "Reiniciar amenaza de raid",
	},
	["spell"] = 
	{
		-- 19
		vampirictouch = "Toque vamp\195\173rico",
		bindingheal = "Sanaci\195\179n conjunta",
		leaderofthepack = "L\195\173der de la manada",
		faeriefire = "Fuego fe\195\169rico (feral)",
		shadowguard = "Guardia de las Sombras",
		anesthetic = "Veneno anest\195\169sico",
		bearmangle = "Destrozar (oso)",
		thunderclap = "Atronar",
		soulshatter = "Despedazar alma",
		invisibility = "Invisibilidad",
		misdirection = "Redirecci\195\179n",
		disengage = "Separaci\195\179n",
		anguish = "Angustia", -- Felguard
		lacerate = "Lacerar", 
		
		-- 18.x
		torment = "Tormento",
		suffering = "Sufrimiento",
		soothingkiss = "Beso calmante",
		intimidation = "Intimidaci\195\179n",
		
		righteousdefense = "Defensa justa",
		eyeofdiminution = "El ojo de reducci\195\179n", -- buff from trinket "Eye of Diminution". The buff appears to be slightly different, with 'The' at the start.
		notthere = "No est\195\161 ah\195\173", -- the buff from Frostfire 8/8 Proc
		frostshock = "Choque de Escarcha", 
		reflectiveshield = "Escudo reflectante", -- this is the damage from Power Word:Shield with the talent.
		devastate = "Devastar",
		stormstrike = "Golpe de tormenta",
		
		-- warlock affliction spells (others already existed below)
		corruption = "Corrupci\195\179n",				
		curseofagony = "Maldici\195\179n de agon\195\173a",
		drainsoul = "Drenar alma",
		curseofdoom = "Maldici\195\179n del Apocalipsis",
		unstableaffliction = "Aflicci\195\179n inestable",
		
		-- new warlock destruction spells
		shadowfury = "Furia de las Sombras",
		incinerate = "Incinerar", 
		
		-- 17.20
		["execute"] = "Ejecutar",
		
		["heroicstrike"] = "Golpe heroico",
		["maul"] = "Magullar",
		["swipe"] = "Flagelo",
		["shieldslam"] = "Embate con escudo",
		["revenge"] = "Revancha",
		["shieldbash"] = "Azote de escudo",
		["sunder"] = "Hender armadura",
		["feint"] = "Amago",
		["cower"] = "Agazapar",
		["taunt"] = "Provocar",
		["growl"] = "Bramido",
		["vanish"] = "Esfumarse",
		["frostbolt"] = "Descarga de Escarcha",
		["fireball"] = "Bola de Fuego",
		["arcanemissiles"] = "Misiles Arcanos",
		["scorch"] = "Agostar",
		["cleave"] = "Rajar",
		
		hemorrhage = "Hemorragia",
		backstab = "Pu\195\177alada",
		sinisterstrike = "Golpe siniestro",
		eviscerate = "Eviscerar",
		
		-- Items / Buffs:
		["arcaneshroud"] = "Sudario Arcano",
		["blackamnesty"] = "Reducir amenaza",

		-- Leeches: no threat from heal
		["holynova"] = "Nova Sagrada", -- no heal or damage threat
		["siphonlife"] = "Succionar vida", -- no heal threat
		["drainlife"] = "Drenar vida", -- no heal threat
		["deathcoil"] = "Espiral de la muerte",	
		
		-- Fel Stamina and Fel Energy DO cause threat! GRRRRRRR!!!
		--["felstamina"] = "Aguante vil",
		--["felenergy"] = "Energ\195\173a vil",
		
		["bloodsiphon"] = "Succi\195\179n de sangre", -- poisoned blood vs Hakkar
		
		["lifetap"] = "Transfusi\195\179n de vida", -- no mana gain threat
		["holyshield"] = "Escudo Sagrado", -- multiplier
		["tranquility"] = "Tranquilidad",
		["distractingshot"] = "Disparo de distracci\195\179n",
		["earthshock"] = "Choque de tierra",
		["rockbiter"] = "Muerdepiedras",
		["fade"] = "Desvanecerse",
		["thunderfury"] = "Furiatrueno",
		
		-- Spell Sets
		-- warlock descruction
		["shadowbolt"] = "Descarga de las Sombras",
		["immolate"] = "Inmolar",
		["conflagrate"] = "Conflagrar",
		["searingpain"] = "Dolor abrasador", -- 2 threat per damage
		["rainoffire"] = "Lluvia de Fuego",
		["soulfire"] = "Fuego de alma",
		["shadowburn"] = "Quemadura de las Sombras",
		["hellfire"] = "Efecto de Llamas infernales",
		
		-- mage offensive arcane
		["arcaneexplosion"] = "Deflagraci\195\179n Arcana",
		["counterspell"] = "Contrahechizo",
		
		-- priest shadow. No longer used (R17).
		["mindblast"] = "Explosi\195\179n mental",	-- 2 threat per damage
		--[[
		["mindflay"] = "Tortura mental",
		["devouringplague"] = "Peste devoradora",
		["shadowwordpain"] = "Palabra de las Sombras: dolor",
		,
		["manaburn"] = "Quemadura de man\195\161",
		]]
	},
	["power"] = 
	{
		["mana"] = "Man\195\161",
		["rage"] = "Ira",
		["energy"] = "Energ\195\173a",
	},
	["threatsource"] = -- these values are for user printout only
	{
		["powergain"] = "Ganancia de poder",
		["total"] = "Total",
		["special"] = "Especiales",
		["healing"] = "Sanaci\195\179n",
		["dot"] = "Da\195\177o en el tiempo",
		["threatwipe"] = "Hechizos de PNJ",
		["damageshield"] = "Escudos de da\195\177o",
		["whitedamage"] = "Da\195\177o blanco",
	},
	["talent"] = -- these values are for user printout only
	{
		["defiance"] = "Desaf\195\173o",
		["impale"] = "Empalar",
		["silentresolve"] = "Resoluci\195\179n silenciosa",
		["frostchanneling"] = "Canalizaci\195\179n de Escarcha",
		["burningsoul"] = "Alma ardiente",
		["healinggrace"] = "Gracia de sanaci\195\179n",
		["shadowaffinity"] = "Afinidad de las Sombras",
		["druidsubtlety"] = "Sutileza",
		["feralinstinct"] = "Instinto feral",
		["ferocity"] = "Ferocidad",
		["savagefury"] = "Furia cruel",
		["tranquility"] = "Tranquilidad mejorada",
		["masterdemonologist"] = "Maestro demon\195\179logo",
		["arcanesubtlety"] = "Sutileza Arcana",
		["righteousfury"] = "Furia justa",
		["sleightofhand"] = "Prestidigitaci\195\179n",
		voidwalker = "Abisario mejorado",
	},
	["threatmod"] = -- these values are for user printout only
	{
		["tranquilair"] = "T\195\179tem de Aire sosegado",
		["salvation"] = "Bendici\195\179n de salvaci\195\179n",
		["battlestance"] = "Actitud de batalla",
		["defensivestance"] = "Actitud defensiva",
		["berserkerstance"] = "Actitud rabiosa",
		["defiance"] = "Desaf\195\173o",
		["basevalue"] = "Valor Base",
		["bearform"] = "Forma de oso",
		["catform"] = "Forma felina",
		["glovethreatenchant"] = "+Encantamiento de amenaza en guantes",
		["backthreatenchant"] = "-Encantamiento de amenaza en guantes",
	},
	
	["sets"] = 
	{
		["bloodfang"] = "colmillo de sangre",
		["nemesis"] = "N\195\169mesis",
		["netherwind"] = "viento abisal",
		["might"] = "poder\195\173o",
		["arcanist"] = "arcanista",
		bonescythe = "segahuesos",
		plagueheart = "coraz\195\179n de la Peste",
	},
	["boss"] = 
	{
		["speech"] = 
		{
			onyxiaphase2 = "Este ejercicio sin sentido me aburre. ¡Os incinerar\195\169 a todos desde arriba!",
			["razorphase2"] = "huye mientras se consume el poder del orbe.",
			["onyxiaphase3"] = "¡Parece ser que vais a necesitar otra lecci\195\179n, mortales!",
			["thekalphase2"] = "Shirvallah, ¡ll\195\169name de tu IRA!",
			["rajaxxfinal"] = "¡Idiota insolente! ¡Te matar\195\169 yo mismo!",
			["azuregosport"] = "Vamos, peque\195\177ajos. ¡Luchad conmigo!",
			["nefphase2"] = "¡QUEMAD! ¡Malditos! ¡QUEMAD!",
			nightbane2 = "¡Ya basta! Voy a aterrizar y a aplastarte yo mismo.",
			nightbane2b = "¡Insectos! ¡Os ense\195\177ar\195\169 mi fuerza de cerca!",
			nightbane = "¡Necios! ¡Voy a acabar r\195\161pidamente con tu sufrimiento!",
			attumen3 = "¡Vamos, Medianoche, dispersemos esta muchedumbre insignificante!",
			magtheridon2 = "¡Soy... libre!",
			hydross2 = "Aagh, el veneno",
			hydross3 = "Mejor, mucho mejor.",
			leotheras = "Desaparece, elfo pusil\195\161nime", -- this isn't the full line
			leotheraspull = "¡Al fin acaba mi destierro!",
			
		},
		-- Some of these are unused. Also, if none is defined in your localisation, they won't be used,
		-- so don't worry if you don't implement it.
		["name"] = 
		{
			["rajaxx"] = "General Rajaxx",
			["onyxia"] = "Onyxia",
			["ebonroc"] = "Ebanorroca",
			["razorgore"] = "Sangrevaja el Indomable",
			["thekal"] = "Sumo Sacerdote Thekal",
			["shazzrah"] = "Shazzrah",
			["twinempcaster"] = "Emperador Vek'lor",
			["twinempmelee"] = "Emperador Vek'nilash",
			["noth"] = "Noth el Pesteador",
			["leotheras"] = "Leotheras el Ciego",
		},
		["spell"] = 
		{
			["shazzrahgate"] = "Portal de Shazzrah", -- "Shazzrah casts Gate of Shazzrah."
			["wrathofragnaros"] = "C\195\179lera de Ragnaros", -- "Ragnaros's Wrath of Ragnaros hits you for 100 Fire damage."
			["timelapse"] = "Lapso de tiempo", -- "You are afflicted by Time Lapse."
			["knockaway"] = "Empujar",
			["wingbuffet"] = "Sacudida de alas",
			["burningadrenaline"] = "Adrenalina ardiente",
			["twinteleport"] = "Teletransporte gemelo",
			["nothblink"] = "Traslaci\195\179n",
			["sandblast"] = "Explosi\195\179n de arena",
			["fungalbloom"] = "Florecimiento f\195\186ngico",
			["hatefulstrike"] = "Golpe de odio",
			
			-- 4 horsemen marks
			mark1 = "Marca de Blaumeux",
			mark2 = "Marca de Korth'azz",
			mark3 = "Marca de Mograine",
			mark4 = "Marca de Zeliek",
			
			-- Onyxia fireball (presumably same as mage)
			fireball = "Bola de Fuego",
			
			-- Leotheras, Maulgar, Sartura etc
			whirlwind = "Torbellino",
		}
	},
	["misc"] = 
	{
		["imp"] = "Diablillo", -- UnitCreatureFamily("pet")
		["spellrank"] = "Rango (%d+)", -- second value of GetSpellName(x, "spell")
		["aggrogain"] = "Ganar Agro",
		tankregain = "Recuperar Tanque",
	},

	-- labels and tooltips for the main window
	["gui"] ={ 
		["self"] = {
			["head"] = {
				-- column headers for the self view
				["name"] = "Nombre",
				["hits"] = "Golpes",
				["dam"] = "Da\195\177o",
				["threat"] = "Amenaza",
				["pc"] = "%A",			-- Abbreviation of %Threat
			},
			-- text on the self threat reset button
			["reset"] = "Reiniciar",
		},
	},
	["print"] = 
	{
		["main"] = 
		{
			["startupmessage"] = "|cffffff00KLHThreatMeter |cff33ff33%s.%s|r cargado. Escribe |cffffff00/ktm|r para ver la ayuda.",
		},
		["data"] = 
		{
			["abilityrank"] = "Tu facultad %s es de rango %s.",
			["globalthreat"] = "Tu multiplicador global de amenaza es %s.",
			["globalthreatmod"] = "[%s] ==> %s.",
			["multiplier"] = "Como %s, tu amenaza de %s se multiplica por %s.",
			["damage"] = "da\195\177o",
			["shadowspell"] = "Hechizos de sombras",
			["arcanespell"] = "Hechizos arcanos",
			["holyspell"] = "Hechizos sagrados",
			["setactive"] = "%s %d piezas activas? ... %s.",
			["healing"] = "Tu sanaci\195\179n causa %s amenaza (antes de aplicar el multiplicador global).",
			["talentpoint"] = "Tienes %d punto(s) de talento en %s.",
			["talent"] = "Encontrado(s) %d punto(s) de talento de %s.",
			["rockbiter"] = "Tu rango %d de Muerdepiedras a\195\177ade %d amenaza a los golpes cuerpo a cuerpo certeros.",
		},
		
		-- new in R17.7
		["boss"] = 
		{
			["automt"] = "El objetivo principal ha sido establecido autom\195\161ticamente a |cffffff00%s|r.",
			["spellsetmob"] = "|cffffff00%1$s|r establece el par\195\161metro |cffffff00%2$s|r de la facultad |cffffff00%4$s|r de |cffffff00%3$s|r a |cffffff00%5$s|r desde ffffff00%6$s|r.", -- "Kenco sets the multiplier parameter of Onyxia's Knock Away ability to 0.7"
			["spellsetall"] = "|cffffff00%s|r establece el par\195\161metro |cffffff00%s|r de la facultad |cffffff00%s|r a |cffffff00%s|r desde |cffffff00%s|r.",
			["reportmiss"] = "%1$s informa de que %3$s de %2$s no le ha alcanzado.",
			["reporttick"] = "%1$s informa de que %3$s de %2$s le ha alcanzado. Ha sufrido %4$s pulsaciones y le quedan otras %5$s pulsaciones m\195\161s.",
			["reportproc"] = "|cffffff00%1$s|r informa de que |cffffff00%3$s|r de |cffffff00%2$s|r ha modificado su amenaza de |cffffff00%4$s|r a |cffffff00%5$s|r.",
			["bosstargetchange"] = "|cffffff00%s|r cambia objetivo de |cffffff00%s|r (con |cffffff00%s|r p. de amenaza) a |cffffff00%s|r (con |cffffff00%s|r p. de amenaza).",
			["autotargetstart"] = "Reiniciar\195\161s el contador de amenaza y establecer\195\161s el objetivo principal autom\195\161ticamente cuando selecciones a un jefe global.",
			["autotargetabort"] = "El objetivo principal ya ha sido establecido al jefe global %s.",
		},
		
		["network"] = 
		{
			["newmttargetnil"] = "No se pudo validar el objetivo principal |cffffff00%s|r ya que |cffffff00%s|r no tiene ning\195\186n objetivo seleccionado.",
			["newmttargetmismatch"] = "|cffffff00%s|r intenta establecer el objetivo principal a |cffffff00%s|r, pero su objetivo actual es |cffffff00%s|r. Utilizando su objetivo actual.",
			["mtpollwarning"] = "Actualizado tu objetivo principal a |cffffff00%s|r aunque \195\169ste no existe. Dile a |cffffff00%s|r que cambie el objetivo principal si este no es correcto.",
			["threatreset"] = "|cffffff00%s|r ha reiniciado el contador de amenaza.",
			["newmt"] = "|cffffff00%2$s|r ha establecido el objetivo principal a |cffffff00%1$s|r.",
			["mtclear"] = "|cffffff00%s|r ha quitado el objetivo principal.",
			["knockbackstart"] = "|cffffff00%s|r ha activado el informe de hechizos de PNJ.",
			["knockbackstop"] = "|cffffff00%s|r ha desactivado el informe de hechizos de PNJ.",
			["aggrogain"] = "|cffffff00%s|r informa de que gana agro con %d p. de amenaza.",
			["aggroloss"] = "|cffffff00%s|r informa de que pierde agro con %d p. de amenaza.",
			["knockback"] = "|cffffff00%s|r informa de que ha sido empujado. Le quedan %d p. de amenaza.",
			["knockbackstring"] = "%s informa del siguiente texto de facultad Empujar: '%s'.",
			["upgraderequest"] = "%s te ruega que actualices tu versi\195\179n de KLHThreatMeter a la %s. Actualmente tienes instalada la versi\195\179n %s.",
			["remoteoldversion"] = "%s est\195\161 en la parra y utiliza la versi\195\179n obsoleta KLHThreatMeter %s. Por favor, pedidle que se actualice a la versi\195\179n %s. XD",
			["knockbackvaluechange"] = "|cffffff00%1$s|r ha establecido la reducci\195\179n de amenaza del ataque |cffffff00%3$s|r de %2$s a |cffffff00%4$d%%|r.",
			["raidpermission"] = "¡Tienes que ser l\195\173der de banda o asistente para realizar esta acci\195\179n!",
			["needmastertarget"] = "¡Antes debes establecer un objetivo principal!",
			["knockbackinactive"] = "El descubrimiento de facultades de Empujar no est\195\161 activado en la banda.",
			["versionrequest"] = "Solicitando informaci\195\179n de versi\195\179n. Respuestas en 3 segundos.",
			["versionrecent"] = "Jugadores espabilados con la versi\195\179n %s: { ",
			["versionold"] = "Jugadores despistados con versiones obsoletas: { ",
			["versionnone"] = "Jugadores en la parra sin KLHThreatMeter: { ",
			needtarget = "Primero selecciona al mob para establecerlo como objetivo principal.",
			upgradenote = "Jugadores con versiones obsoletas del mod han sido avisados para que se actualicen.",
		},
	}
}
