-------------------------------------------------------------------------------
-- Title: MSBT Options French Localization
-- Author: Mik
-- French Translation by: Calthas
-------------------------------------------------------------------------------

-- Don't do anything if the locale isn't French.
if (GetLocale() ~= "frFR") then return; end

-- Local reference for faster access.
local L = MikSBT.translations;

-------------------------------------------------------------------------------
-- French localization
-------------------------------------------------------------------------------


------------------------------
-- Interface messages
------------------------------

L.MSG_NEW_PROFILE					= "Nouveau Profil";
L.MSG_PROFILE_ALREADY_EXISTS		= "Le Profil existe d\195\169j\195\160.";
L.MSG_INVALID_PROFILE_NAME			= "Nom de profil invalide.";
L.MSG_NEW_SCROLL_AREA				= "Nouveau zone de d\195\169filement";
L.MSG_SCROLL_AREA_ALREADY_EXISTS	= "Une zone de d\195\169filement portant ce nom existe d\195\169j\195\160.";
L.MSG_INVALID_SCROLL_AREA_NAME		= "Nom de zone de d\195\169filement invalide.";
L.MSG_ACKNOWLEDGE_TEXT				= "Etes-vous certain de vouloir effectuer cette action?";
--L.MSG_NORMAL_PREVIEW_TEXT			= "Normal";
--L.MSG_INVALID_SOUND_FILE			= "Sound must be a .mp3 or .wav file.";
L.MSG_NEW_TRIGGER					= "Nouveau d\195\169clencheur";
L.MSG_TRIGGER_CLASSES				= "Classes du d\195\169clencheur";
--L.MSG_MAIN_EVENTS					= "Main Events";
--L.MSG_TRIGGER_EXCEPTIONS			= "Trigger Exceptions";
--L.MSG_EVENT_CONDITIONS				= "Event Conditions";
L.MSG_SKILLS						= "Comp\195\169tences";
--L.MSG_SKILL_ALREADY_EXISTS			= "Skill name already exists.";
L.MSG_INVALID_SKILL_NAME			= "Nom de comp\195\169tence invalide.";
--L.MSG_HOSTILE						= "Hostile";
--L.MSG_ANY							= "Any";
--L.MSG_CONDITION						= "Condition";
--L.MSG_CONDITIONS					= "Conditions";


------------------------------
-- Class Names.
------------------------------

local obj = L.CLASS_NAMES;
obj["DRUID"]	= "Druide";
obj["HUNTER"]	= "Chasseur";
obj["MAGE"]		= "Mage";
obj["PALADIN"]	= "Paladin";
obj["PRIEST"]	= "Pr\195\170tre";
obj["ROGUE"]	= "Voleur";
obj["SHAMAN"]	= "Chaman";
obj["WARLOCK"]	= "D\195\169moniste";
obj["WARRIOR"]	= "Guerrier";


------------------------------
-- Interface tabs
------------------------------

-- #2, 3, and 4 need additional translation.
obj = L.TABS;
obj[1] = { label="G\195\169n\195\169ral", tooltip="Afficher les options g\195\169n\195\169rales."};
obj[2] = { label="Zones de d\195\169filement", tooltip="Affiche les options de cr\195\169ation, suppression et configuration des zones de d\195\169filement.\n\nMouse over the icon buttons for more information."};
obj[3] = { label="Ev\195\168nements", tooltip="Affiche les options pour les \195\169v\195\168nements entrants, sortants et de notification.\n\nMouse over the icon buttons for more information."};
obj[4] = { label="D\195\169clencheurs", tooltip="Affiche les options du syst\195\168me de d\195\169clencheurs.\n\nMouse over the icon buttons for more information."};
--obj[5] = { label="Spam Control", tooltip="Display options for controlling spam."};
--obj[6] = { label="Cooldowns", tooltip="Display options for cooldown notifications."};
--obj[7] = { label="Skill Icons", tooltip="Display options for skill icons."};


------------------------------
-- Interface checkboxes
------------------------------

obj = L.CHECKBOXES;
obj["enableMSBT"]				= { label="Activer Mik's Scrolling Battle Text", tooltip="Activer MSBT."};
obj["stickyCrits"]				= { label="Coups critiques persistants", tooltip="Utiliser le style persistant pour les coups critiques."};
obj["gameDamage"]				= { label="Dommages du jeu", tooltip="Afficher les dommages par d\195\169faut du jeu au dessus de la t\195\170te des ennemis."};
obj["gameHealing"]				= { label="Soins du jeu", tooltip="Afficher les soins par d\195\169aut du jeu au dessus de la t\195\170te des ennemis."};
obj["enableSounds"]				= { label="Activer les sons", tooltip="Utiliser les sons associ\195\169s aux \195\169v\195\168nements et d\195\169clencheurs."};
obj["colorPartialEffects"]		= { label="Coloriser les effets partiels", tooltip="Assigner des couleurs aux effets partiels."};
obj["crushing"]					= { label="Ecrasements", tooltip="Signaler les \195\169crasements."};
obj["glancing"]					= { label="Eraflures", tooltip="Signaler les \195\169raflures."};
obj["absorb"]					= { label="Absorptions partielles", tooltip="Afficher la valeur des absorptions partielles."};
obj["block"]					= { label="Bloquages partiels", tooltip="Afficher la valeur des bloquages partiels."};
obj["resist"]					= { label="R\195\169sistances partielles", tooltip="Afficher la valeur des r\195\169sistances partielles."};
obj["vulnerability"]			= { label="Bonus de vuln\195\169rabilit\195\169", tooltip="Afficher la valeur des bonus de vuln\195\169rabilit\195\169."};
obj["overheal"]					= { label="Overheals", tooltip="Afficher la valeur d'overheal."};
obj["colorDamageAmounts"]		= { label="Valeurs des dommages en couleur", tooltip="Utiliser des couleurs pour la valeur des dommages."};
--obj["colorDamageEntry"]			= { tooltip="Enable coloring for this damage type."};
obj["enableScrollArea"]			= { tooltip="Activer la zone de d\195\169filement."};
obj["inheritField"]				= { label="H\195\169riter", tooltip="H\195\169riter la valeur."};
obj["stickyEvent"]				= { label="Toujours Persistant", tooltip="Utiliser le style persistant pour l'\195\169v\195\168nement."};
obj["enableTrigger"]			= { tooltip="Activer le d\195\169clencheur."};
--obj["allPowerGains"]			= { label="ALL Power Gains", tooltip="Display all power gains including those that are not reported to the combat log.\n\nWARNING: This option is very spammy and will ignore the power threshold and throttling mechanics.\n\nNOT RECOMMENDED."};
--obj["hyperRegen"]				= { label="Hyper Regen", tooltip="Display power gains during fast regen abilities such as Innervate and Spirit Tap.\n\nNOTE: The gains shown will not be throttled."};
--obj["abbreviateSkills"]			= { label="Abbreviate Skills", tooltip="Abbreviates skill names (English only).\n\nThis can be overriden by each event with the %sl event code."};
--obj["hideSkills"]				= { label="Hide Skills", tooltip="Don't display skill names for incoming and outgoing events.\n\nYou will give up some customization capability at the event level if you choose to use this option since it causes the %s event code to be ignored."};
--obj["hideNames"]				= { label="Hide Names", tooltip="Don't display unit names for incoming and outgoing events.\n\nYou will give up some customization capability at the event level if you choose to use this option since it causes the %n event code to be ignored."};
obj["allClasses"]				= { label="Toutes les classes"};
--obj["enableCooldowns"]			= { label="Enable Cooldowns", tooltip="Display notifications when cooldowns complete."};
--obj["enableIcons"]				= { label="Enable Skill Icons", tooltip="Displays icons for events that have a skill when possible."};
--obj["exclusiveSkills"]			= { label="Exclusive Skill Names", tooltip="Only show skill names when an icon is not available."};


------------------------------
-- Interface dropdowns
------------------------------

obj = L.DROPDOWNS;
obj["profile"]				= { label="Profil actuel:", tooltip="Assigne le profil actif."};
obj["normalFont"]			= { label="Police normale:", tooltip="Assigne la police de caract\195\168res utilis\195\169e pour les coups non critiques."};
obj["critFont"]				= { label="Police critique:", tooltip="Assigne la police de caract\195\168res utilis\195\169e pour les coups critiques."};
obj["normalOutline"]		= { label="Contour normal:", tooltip="Assigne le contour utilis\195\169 pour les coups non critiques."};
obj["critOutline"]			= { label="Contour critique:", tooltip="Assigne le contour utilis\195\169 pour les coups critiques."};
obj["scrollArea"]			= { label="Zone de d\195\169filement:", tooltip="S\195\169lectionne la zone de d\195\169filement \195\160 configurer."};
--obj["sound"]				= { label="Sound:", tooltip="Selects the sound to play when the event occurs."};
obj["animationStyle"]		= { label="Animations:", tooltip="Style d'animation pour les animations non persistantes dans la zone de d\195\169filement.."};
obj["stickyAnimationStyle"]	= { label="Animations persistantes:", tooltip="Style d'animation pour les animations persistantes dans la zone de d\195\169filement."};
--obj["direction"]			= { label="Direction:", tooltip="The direction of the animation."};
--obj["behavior"]				= { label="Behavior:", tooltip="The behavior of the animation."};
obj["textAlign"]			= { label="Alignement du texte:", tooltip="Alignement du texte pour l'animation."};
obj["eventCategory"]		= { label="Cat\195\169gorie d'\195\169v\195\168ne:", tooltip="La cat\195\169gorie de l'\195\169v\195\168nement \195\160 configurer."};
obj["outputScrollArea"]		= { label="Zone de d\195\169filement sortante:", tooltip="S\195\169lectionne la zone de d\195\169filement \195\160 utiliser pour les informations sortantes."};
--obj["mainEvent"]			= { label="Main Event:"};
--obj["triggerCondition"]		= { label="Condition:", tooltip="The condition to test."};
--obj["triggerRelation"]		= { label="Relation:"};
--obj["triggerParameter"]		= { label="Parameter:"};


------------------------------
-- Interface buttons
------------------------------

obj = L.BUTTONS;
obj["copyProfile"]				= { label="Copier", tooltip="Copie le profil sous un nouveau nom."};
obj["resetProfile"]				= { label="R\195\169initialiser", tooltip="R\195\169initialise le profil avec les param\195\168tres par d\195\169faut."};
obj["deleteProfile"]			= { label="Supprimer", tooltip="Supprime le profil."};
obj["masterFont"]				= { label="Police principale", tooltip="Param\195\168tres principaux de police, h\195\169rit\195\169s par toutes les zones de d\195\169filement sauf si surcharg\195\169s."};
obj["partialEffects"]			= { label="Effets partiels", tooltip="D\195\169termine les effets partiels affich\195\169s et les param\195\168tres de couleurs."};
obj["damageColors"]				= { label="Couleurs des dommages", tooltip="Vous permet de param\195\169trer les couleurs assign\195\169s aux dommages suivant le type de dommage (nature, feu, givre...)"};
obj["inputOkay"]				= { label="OK", tooltip="Accepte la saisie."};
obj["inputCancel"]				= { label="Annuler", tooltip="Annule la saisie."};
obj["genericSave"]				= { label="Enregistrer", tooltip="Enregistre les modifications."};
obj["genericCancel"]			= { label="Annuler", tooltip="Annule les modifications."};
obj["addScrollArea"]			= { label="Ajouter une zone", tooltip="Ajoute une zone de d\195\169filement \195\160 laquelle des d\195\169clencheurs et \195\169v\195\168nements peuvent \195\170tre assign\195\169s."};
obj["configScrollAreas"]		= { label="Configurer les zones", tooltip="Permet de configurer les styles d'animation normales et persistantes, l'alignement du texte, la largeur/hauteur de la zone de d\195\169filement et leur emplacement."};
obj["editScrollAreaName"]		= { tooltip="Cliquer pour modifier le nom de la zone de d\195\169filement."};
obj["scrollAreaFontSettings"]	= { tooltip="Cliquer pour modifier les param\195\168tres de police pour la zone de d\195\169filement. Ces param\195\168tres seront utilis\195\169s par tous les \195\169v\195\168nements de cette zone \195\160 moins qu'ils ne soient surcharg\195\169s."};
obj["deleteScrollArea"]			= { tooltip="Cliquer pour supprimer la zone de d\195\169filement."};
obj["scrollAreasPreview"]		= { label="Aper\195\167u", tooltip="Pr\195\169visualiser les modifications."};
--obj["toggleAll"]				= { label="Toggle All", tooltip="Toggle the enable state of all events in the selected category."};
--obj["moveAll"]					= { label="Move All", tooltip="Moves all of the events in the selected category to the specified scroll area."};
obj["eventFontSettings"]		= { tooltip="Cliquer pour \195\169diter les param\195\168tres de police pour l'\195\169v\195\168nement."};
obj["eventSettings"]			= { tooltip="Cliquer pour \195\169diter les param\195\168tres de l'\195\169v\195\168nement comme la zone de d\195\169filement, message, sonore, etc."};
--obj["customSound"]				= { tooltip="Click to enter a custom sound file." };
--obj["playSound"]				= { label="Play", tooltip="Click to play the selected sound."};
obj["addTrigger"]				= { label="Ajouter un d\195\169clencheur", tooltip="Ajoute un nouveau d\195\169clencheur."};
obj["triggerSettings"]			= { tooltip="Configurer les conditions de ce d\195\169clencheur."};
obj["deleteTrigger"]			= { tooltip="Cliquer pour supprimer ce d\195\169clencheur."};
obj["editTriggerClasses"]		= { tooltip="D\195\169termine \195\160 quelles classes le d\195\169clencheur s'applique."};
--obj["addMainEvent"]				= { label="Add Event", tooltip="When ANY of these events occur and their defined conditions are true, the trigger will fire unless one of the exceptions specified below is true."};
--obj["addTriggerException"]		= { label="Add Exception", tooltip="When ANY of these exceptions are true, the trigger will not fire."};
--obj["editEventConditions"]		= { tooltip="Click to edit the conditions for the event."};
--obj["deleteMainEvent"]			= { tooltip="Click to delete the event."};
--obj["addEventCondition"]		= { label="Add Condition", tooltip="When ALL of these conditions are true for the selected event, the trigger will fire unless one of the specified exceptions is true."};
--obj["editCondition"]			= { tooltip="Click to edit the condition."};
--obj["deleteCondition"]			= { tooltip="Click to delete the condition."};
--obj["throttleList"]				= { label="Throttle List", tooltip="Set custom throttle times for specified skills."};
--obj["mergeExclusions"]			= { label="Merge Exclusions", tooltip="Prevents specified skills from being merged."};
--obj["skillSuppressions"]		= { label="Skill Suppressions", tooltip="Suppress skills by their name."};
--obj["skillSubstitutions"]		= { label="Skill Substitutions", tooltip="Substitute skill names with customized values."};
--obj["addSkill"]					= { label="Add Skill", tooltip="Add a new skill to the list."};
--obj["deleteSkill"]				= { tooltip="Click to delete the skill."};
--obj["cooldownExclusions"]		= { label="Cooldown Exclusions", tooltip="Specify skills that will ignore cooldown tracking."};


------------------------------
-- Interface editboxes
------------------------------

obj = L.EDITBOXES;
obj["copyProfile"]		= { label="Nom du nouveau profil:", tooltip="Nom du nouveau profil vers lequel copier le profil courant."};
obj["scrollAreaName"]	= { label="Nouveau nom pour la zone de d\195\169filement:", tooltip="Nouveau nom pour la zone de d\195\169filement."};
obj["xOffset"]			= { label="D\195\169calage X:", tooltip="Le d\195\169calage horizontale de la zone de d\195\169filement."};
obj["yOffset"]			= { label="D\195\169calage Y:", tooltip="Le d\195\169calage vertical de la zone de d\195\169filement."};
obj["eventMessage"]		= { label="Message affich\195\169:", tooltip="Le message affich\195\169 pour cet \195\169v\195\168nement."};
--obj["soundFile"]		= { label="Sound filename:", tooltip="The name of the sound file to play when the trigger occurs."};
--obj["iconSkill"]		= { label="Icon Skill:", tooltip="The name or spell ID of a skill whose icon will be displayed when the event occurs.\n\nMSBT will automatically try to figure out an appropriate icon if one is not specified.\n\nNOTE: A spell ID must be used in place of a name if the skill is not in the spellbook for the class that is playing when the event occurs.  Most online databases such as wowhead can be used to discover it."};
--obj["skillName"]		= { label="Skill name:", tooltip="The name of the skill to add."};
--obj["substitutionText"]	= { label="Substition text:", tooltip="The text to be substituted for the skill name."};


------------------------------
-- Interface sliders
------------------------------

obj = L.SLIDERS;
obj["animationSpeed"]		= { label="Vitesse d'animation", tooltip="D\195\169finit la vitesse ma\195\174tre de l'animation."};
obj["normalFontSize"]		= { label="Taille normale", tooltip="D\195\169finit la taille de la police pour les coups non critiques."};
--obj["normalFontOpacity"]	= { label="Normal Opacity", tooltip="Sets the font opacity for non-crits."};
obj["critFontSize"]			= { label="Taille critique", tooltip="D\195\169finit la taille de la police pour les coups critiques."};
--obj["critFontOpacity"]		= { label="Crit Opacity", tooltip="Sets the font opacity for crits."};
obj["scrollHeight"]			= { label="Hauteur de d\195\169filement", tooltip="La hauteur de la zone de d\195\169filement."};
obj["scrollWidth"]			= { label="Largeur de d\195\169filement", tooltip="La largeur de la zone de d\195\169filement."};
obj["scrollAnimationSpeed"]	= { label="Vitesse d'animation", tooltip="La vitesse de l'animation pour la zone de d\195\169filement."};
--obj["powerThreshold"]		= { label="Power Threshold", tooltip="The threshold that power gains must exceed to be displayed."};
--obj["healThreshold"]		= { label="Heal Threshold", tooltip="The threshold that heals must exceed to be displayed."};
--obj["damageThreshold"]		= { label="Damage Threshold", tooltip="The threshold that damage must exceed to be displayed."};
--obj["dotThrottleTime"]		= { label="DoT Throttle Time", tooltip="The number of seconds to throttle DoTs."};
--obj["hotThrottleTime"]		= { label="HoT Throttle Time", tooltip="The number of seconds to throttle HoTs."};
--obj["powerThrottleTime"]	= { label="Power Throttle Time", tooltip="The number of seconds to throttle power changes."};
obj["skillThrottleTime"]	= { label="D\195\169lai de r\195\169gulation", tooltip="D\195\169lai \195\160 prendre en compte pour la r\195\169gulation des comp\195\169tences."};
--obj["cooldownThreshold"]	= { label="Cooldown Threshold", tooltip="Skills with a cooldown less than the specified number of seconds will not be displayed."};

------------------------------
-- Event categories
------------------------------
obj = L.EVENT_CATEGORIES;
obj[1] = "Entrant player";
obj[2] = "Entrant familier";
obj[3] = "Sortant player";
obj[4] = "Sortant familier";
obj[5] = "Alertes";


------------------------------
-- Event codes
------------------------------

obj = L.EVENT_CODES;
obj["DAMAGE_TAKEN"]			= "%a - Quantit\195\169 de dommages.\n";
obj["HEALING_TAKEN"]		= "%a - Quantit\195\169 de soins re\195\167us.\n";
obj["DAMAGE_DONE"]			= "%a - Dommages inflig\195\169s.\n";
obj["HEALING_DONE"]			= "%a - Quantit\195\169 de soins.\n";
obj["ENERGY_AMOUNT"]		= "%a - Quantit\195\169 de pouvoir.\n";
obj["CP_AMOUNT"]			= "%a - Nombre de points de combo.\n";
obj["HONOR_AMOUNT"]			= "%a - Quantit\195\169 de honneur.\n";
obj["REP_AMOUNT"]			= "%a - Quantit\195\169 de r\195\169putation.\n";
obj["SKILL_AMOUNT"]			= "%a - Nouveau niveau dans la comp\195\169tence.\n";
obj["EXPERIENCE_AMOUNT"]	= "%a - Quantit\195\169 de exp\195\169rience.\n";
obj["ATTACKER_NAME"]		= "%n -  Nom de l'attaquant.\n";
obj["HEALER_NAME"]			= "%n - Nom du soigneur.\n";
obj["ATTACKED_NAME"]		= "%n - Nom de l'unit\195\169 attaqu\195\169e.\n";
obj["HEALED_NAME"]			= "%n - Nom de l'unit\195\169 soign\195\169e.\n";
obj["BUFFED_NAME"]			= "%n - Nom de l'unit\195\169.\n";
obj["SKILL_NAME"]			= "%s - Nom de la comp\195\169tence.\n";
obj["SPELL_NAME"]			= "%s - Nom du sort.\n";
obj["DEBUFF_NAME"]			= "%s - Nom du debuff.\n";
obj["BUFF_NAME"]			= "%s - Nom du buff.\n";
obj["ITEM_BUFF_NAME"]		= "%s - Nom du buff d'objet.\n";
obj["EXTRA_ATTACKS"]		= "%s - Attaque suppl\195\169mentaire.\n";
--obj["SKILL_LONG"]			= "%sl - Long form of %s. Used to override abbreviation for the event.\n";
obj["DAMAGE_TYPE_TAKEN"]	= "%t - Type de dommages.\n";
obj["DAMAGE_TYPE_DONE"]		= "%t - Type de dommages faits.\n";
obj["ENVIRONMENTAL_DAMAGE"]	= "%e - Nom de la source de dommages (chute, noyade, lave, etc...)\n";
obj["FACTION_NAME"]			= "%e - Faction.\n";
obj["UNIT_KILLED"]			= "%e - Nom de l'unit\195\169 tu\195\169e.\n";
obj["SHARD_NAME"]			= "%e - Fragment d'\195\162me.\n";
--obj["EMOTE_TEXT"]			= "%e - The text of the emote.\n";
--obj["MONEY_TEXT"]			= "%e - The money gained text.\n";
--obj["COOLDOWN_NAME"]		= "%e - The name of skill that is ready.\n"
obj["POWER_TYPE"]			= "%p - Type de pouvoir (\195\169nergie, rage, mana).\n";


------------------------------
-- Incoming events
------------------------------

obj = L.INCOMING_PLAYER_EVENTS;
obj[1]	= { label="M\195\170l\195\169e", tooltip="Afficher les dommages des attaques de m\195\170l\195\169e."};
obj[2]	= { label="M\195\170l\195\169e critiques", tooltip="Afficher les dommages des attaques critiques de m\195\170l\195\169e."};
obj[3]	= { label="Manques de m\195\170l\195\169e", tooltip="Afficher les attaques de m\195\170l\195\169e manqu\195\169es."};
obj[4]	= { label="Esquives de m\195\170l\195\169e", tooltip="Afficher les attaques de m\195\170l\195\169e esquiv\195\169es."};
obj[5]	= { label="Parades de m\195\170l\195\169e", tooltip="Afficher les attaques de m\195\170l\195\169e par\195\169es."};
obj[6]	= { label="Bloquage de m\195\170l\195\169e", tooltip="Afficher les dommages en m\195\170l\195\169e bloqu\195\169es."};
obj[7]	= { label="Absorption de m\195\170l\195\169e", tooltip="Afficher les dommages en m\195\170l\195\169e absorb\195\169s."};
obj[8]	= { label="Immunit\195\169s de m\195\170l\195\169e", tooltip="Afficher les attaques de m\195\170l\195\169e auxquelles vous \195\170tes immunis\195\169."};
obj[9]	= { label="Comp\195\169tences", tooltip="Afficher les dommages des comp\195\169tences."};
obj[10]	= { label="Comp\195\169tences critiques", tooltip="Afficher les dommages des comp\195\169tences critiques."};
obj[11]	= { label="DoTs des comp\195\169tences", tooltip="Afficher les dommages des DoTs de comp\195\169tences."};
obj[12]	= { label="Manques comp\195\169tences", tooltip="Afficher les comp\195\169tences qui vous ont manqu\195\169."};
obj[13]	= { label="Esquives comp\195\169tences", tooltip="Afficher les comp\195\169tences que vous avez esquiv\195\169."};
obj[14]	= { label="Parades comp\195\169tences", tooltip="Afficher les comp\195\169tences que vous avez par\195\169."};
obj[15]	= { label="Bloquages comp\195\169tences", tooltip="Afficher les capacit\195\169s que vous avez bloqu\195\169."};
obj[16]	= { label="R\195\169sistances aux sorts", tooltip="Afficher les sorts auxquels vous avez r\195\169sist\195\169."};
obj[17]	= { label="Absorptions comp\195\169tences", tooltip="Afficher les dommages absorb\195\169s des comp\195\169tences."};
obj[18]	= { label="Immunit\195\169s comp\195\169tences", tooltip="Afficher les comp\195\169tences auxquels vous \195\170tes immunis\195\169."};
obj[19]	= { label="Comp\195\169tences renvoy\195\169s", tooltip="Afficher les comp\195\169tences que vous avez renvoy\195\169."};
--obj[20]	= { label="Spell Interrupts", tooltip="Enable incoming spell interrupts."};
obj[21]	= { label="Soins", tooltip="Afficher les soins re\195\167us."};
obj[22]	= { label="Soins critiques", tooltip="Afficher les soins critiques re\195\167us."};
obj[23]	= { label="Soins sur le temps (HoT)", tooltip="Afficher les soins des soins sur le temps (HoT)."};
obj[24]	= { label="Dommages de l'environnement", tooltip="Afficher les effets de l'environnement (chutes, noyades, lave, etc...)."};

obj = L.INCOMING_PET_EVENTS;
--obj[1]	= { label="M\195\170l\195\169e", tooltip="Enable your pet's incoming melee hits."};
--obj[2]	= { label="M\195\170l\195\169e critiques", tooltip="Enable your pet's incoming melee crits."};
--obj[3]	= { label="Manques de m\195\170l\195\169e", tooltip="Enable your pet's incoming melee misses."};
--obj[4]	= { label="Esquives de m\195\170l\195\169e", tooltip="Enable your pet's incoming melee dodges."};
--obj[5]	= { label="Parades de m\195\170l\195\169e", tooltip="Enable your pet's incoming melee parries."};
--obj[6]	= { label="Bloquage de m\195\170l\195\169e", tooltip="Enable your pet's incoming melee blocks."};
--obj[7]	= { label="Absorption de m\195\170l\195\169e", tooltip="Enable your pet's absorbed incoming melee damage."};
--obj[8]	= { label="Immunit\195\169s de m\195\170l\195\169e", tooltip="Enable melee damage your is pet immune to."};
--obj[9]	= { label="Comp\195\169tences", tooltip="Enable your pet's incoming skill hits."};
--obj[10]	= { label="Comp\195\169tences critiques", tooltip="Enable your pet's incoming skill crits."};
--obj[11]	= { label="DoTs des comp\195\169tences", tooltip="Enable your pet's incoming skill damage over time."};
--obj[12]	= { label="Manques comp\195\169tences", tooltip="Enable your pet's incoming skill misses."};
--obj[13]	= { label="Esquives comp\195\169tences", tooltip="Enable your pet's incoming skill dodges."};
--obj[14]	= { label="Parades comp\195\169tences", tooltip="Enable your pet's incoming skill parries."};
--obj[15]	= { label="Bloquages comp\195\169tences", tooltip="Enable your pet's incoming skill blocks."};
--obj[16]	= { label="R\195\169sistances aux sorts", tooltip="Enable your pet's incoming spell resists."};
--obj[17]	= { label="Absorptions comp\195\169tences", tooltip="Enable absorbed damage from your pet's incoming skills."};
--obj[18]	= { label="Immunit\195\169s comp\195\169tences", tooltip="Enable incoming skill damage your pet is immune to."};
--obj[19]	= { label="Soins", tooltip="Enable your pet's incoming heals."};
--obj[20]	= { label="Soins critiques", tooltip="Enable your pet's incoming crit heals."};
--obj[21]	= { label="Soins sur le temps (HoT)", tooltip="Enable your pet's incoming heals over time."};


------------------------------
-- Outgoing events
------------------------------

obj = L.OUTGOING_PLAYER_EVENTS;
obj[1]	= { label="M\195\170l\195\169e", tooltip="Afficher les dommages inflig\195\169s en m\195\170l\195\169e."};
obj[2]	= { label="M\195\170l\195\169e critiques", tooltip="Afficher les dommages critiques inflig\195\169s en m\195\170l\195\169e."};
obj[3]	= { label="Manques de m\195\170l\195\169e", tooltip="Afficher vos attaques manquées en m\195\170l\195\169e."};
obj[4]	= { label="Esquives de m\195\170l\195\169e", tooltip="Afficher vos attaques esquiv\195\169es en m\195\170l\195\169e."};
obj[5]	= { label="Parades de m\195\170l\195\169e", tooltip="Afficher vos attaques par\195\169es en m\195\170l\195\169e."};
obj[6]	= { label="Bloquage de m\195\170l\195\169e", tooltip="Afficher vos dommages en m\195\170l\195\169e bloqu\195\169es."};
obj[7]	= { label="Absorption de m\195\170l\195\169e", tooltip="Afficher vos dommages en m\195\170l\195\169e absorb\195\169s."};
obj[8]	= { label="Immunit\195\169s de m\195\170l\195\169e", tooltip="Afficher vos attaques de m\195\170l\195\169e auxquelles l'ennemi est immunis\195\169."};
obj[9]	= { label="Evites de m\195\170l\195\169e", tooltip="Afficher vos attaques de m\195\170l\195\169e evit\195\169es."};
obj[10]	= { label="Comp\195\169tences", tooltip="Afficher les dommages de vos comp\195\169tences."};
obj[11]	= { label="Comp\195\169tences critiques", tooltip="Afficher les dommages de vos comp\195\169tences critiques."};
obj[12]	= { label="DoTs des comp\195\169tences", tooltip="Afficher les dommages sur le temps (DoTs) de vos comp\195\169tences."};
obj[13]	= { label="Manques comp\195\169tences", tooltip="Afficher les coups manqu\195\169s de vos comp\195\169tences."};
obj[14]	= { label="Esquives comp\195\169tences", tooltip="Afficher vos comp\195\169tences esquiv\195\169es."};
obj[15]	= { label="Parades comp\195\169tences", tooltip="Afficher vos comp\195\169tences par\195\169es."};
obj[16]	= { label="Bloquages comp\195\169tences", tooltip="Afficher vos comp\195\169tences bloqu\195\169es."};
obj[17]	= { label="R\195\169sistances aux sorts", tooltip="Afficher les r\195\169sistances \195\160 vos sorts."};
obj[18]	= { label="Absorptions comp\195\169tences", tooltip="Afficher les absorptions de dommages de vos comp\195\169tences."};
obj[19]	= { label="Immunit\195\169s comp\195\169tences", tooltip="Afficher les dommages vos comp\195\169tences auxquels l'ennemi est immunis\195\169."};
obj[20]	= { label="Comp\195\169tences renvoy\195\169s", tooltip="Afficher les dommages de vos comp\195\169tences qui vous sont renvoy\195\169s."};
--obj[21]	= { label="Spell Interrupts", tooltip="Enable outgoing spell interrupts."};
obj[22]	= { label="Evites comp\195\169tences", tooltip="Afficher les evites de vos comp\195\169tences."};
obj[23]	= { label="Soins", tooltip="Afficher les soins effectu\195\169s."};
obj[24]	= { label="Soins critiques", tooltip="Afficher les soins critiques effectu\195\169s."};
obj[25]	= { label="Soins sur le temps (HoT)", tooltip="Afficher les soins sur le temps."};
--obj[26] = { label="Dispels", tooltip="Enable outgoing dispels."};

obj = L.OUTGOING_PET_EVENTS;
obj[1]	= { label="M\195\170l\195\169e", tooltip="Afficher les dommages inflig\195\169s par votre familier."};
obj[2]	= { label="M\195\170l\195\169e critiques", tooltip="Afficher les dommages critiques inflig\195\169s par votre familier."};
obj[3]	= { label="Manques de m\195\170l\195\169e", tooltip="Afficher les attaques manqu\195\169es par votre familier."};
obj[4]	= { label="Esquives de m\195\170l\195\169e", tooltip="Afficher les attaques de m\195\170l\195\169e de votre familier esquiv\195\169es."};
obj[5]	= { label="Parades de m\195\170l\195\169e", tooltip="Afficher les attaques de m\195\170l\195\169e de votre familier par\195\169es."};
obj[6]	= { label="Bloquage de m\195\170l\195\169e", tooltip="Afficher les attaques de m\195\170l\195\169e de votre familier bloqu\195\169es."};
obj[7]	= { label="Absorption de m\195\170l\195\169e", tooltip="Afficher les dommages en m\195\170l\195\169e absorb\195\169s de votre familier."};
obj[8]	= { label="Immunit\195\169s de m\195\170l\195\169e", tooltip="Afficher les capacit\195\169s en m\195\170l\195\169e de votre familier auxquelles l'ennemi est immunis\195\169."};
obj[9]	= { label="Evites de m\195\170l\195\169e", tooltip="Afficher les evites en m\195\170l\195\169e de votre familier."};
obj[10]	= { label="Comp\195\169tences", tooltip="Afficher les dommages des comp\195\169tences de votre familier."};
obj[11]	= { label="Comp\195\169tences critiques", tooltip="Afficher les dommages des comp\195\169tences critiques de votre familier."};
obj[12]	= { label="DoTs des comp\195\169tences", tooltip="Afficher les dommages sur le temps (DoTs) des comp\195\169tences de votre familier."};
obj[13]	= { label="Manques comp\195\169tences", tooltip="Afficher les comp\195\169tences de votre familier qui ont manqu\195\169."};
obj[14]	= { label="Esquives comp\195\169tences", tooltip="Afficher les comp\195\169tences de votre familier qui ont \195\169t\195\169 esquiv\195\169es."};
obj[15]	= { label="Parades comp\195\169tences", tooltip="Afficher les comp\195\169tences de votre familier qui ont \195\169t\195\169 par\195\169es."};
obj[16]	= { label="Bloquages comp\195\169tences", tooltip="Afficher les bloquages des comp\195\169tences de votre familier."};
obj[17]	= { label="R\195\169sistances aux sorts", tooltip="Afficher les sorts de votre familier r\195\169sist\195\169."};
obj[18]	= { label="Absorptions comp\195\169tences", tooltip="Afficher les comp\195\169tences de votre familier absorb\195\169s."};
obj[19]	= { label="Immunit\195\169s comp\195\169tences", tooltip="Afficher les comp\195\169tences de votre familier auxquels l'ennemi est immunis\195\169."};
obj[20]	= { label="Evites comp\195\169tences", tooltip="Afficher les \195\169vites des comp\195\169tences de votre familier."};
--obj[21] = { label="Dispels", tooltip="Enable your pet's outgoing dispels."};


------------------------------
-- Notification events
------------------------------

obj = L.NOTIFICATION_EVENTS;
obj[1]	= { label="Debuffs", tooltip="Afficher les debuffs par lesquels vous \195\170tes affect\195\169s."};
obj[2]	= { label="Buffs", tooltip="Afficher les buffs re\195\167us."};
obj[3]	= { label="Buffs des objets", tooltip="Afficher les buffs re\195\167us par les objets."};
obj[4]	= { label="Fin des debuffs", tooltip="Signaler la fin des debuffs."};
obj[5]	= { label="Fin des buffs", tooltip="Signaler la fin des buffs."};
obj[6]	= { label="Fin des buffs d'objets", tooltip="Signaler quand un de vos buffs d'objet se termine."};
obj[7]	= { label="D\195\169but combat", tooltip="Signaler l'entr\195\169e en combat."};
obj[8]	= { label="Sortie combat", tooltip="Signaler la fin du combat."};
obj[9]	= { label="Gains de puissance", tooltip="Signaler les gains de mana, rage et \195\169nergie."};
obj[10]	= { label="Pertes de puissance", tooltip="Signaler les pertes de mana, rage et \195\169nergie par des drains."};
obj[11]	= { label="Gain de points de combo", tooltip="Signaler les points de combo."};
obj[12]	= { label="5 points de combo", tooltip="Signaler quand vous avez atteint 5 points de combo."};
obj[13]	= { label="Gains d'honneur", tooltip="Afficher les gains d'honneur."};
obj[14]	= { label="Gains de r\195\169putation", tooltip="Afficher les gains de r\195\169putation."};
obj[15]	= { label="Pertes de r\195\169putation", tooltip="Afficher les pertes de r\195\169putation."};
obj[16]	= { label="Progression de comp\195\169tences", tooltip="Afficher les progressions de comp\195\169tences."};
obj[17]	= { label="Gains d'exp\195\169rience", tooltip="Afficher les gains d'exp\195\169rience."};
obj[18]	= { label="Coups fatals sur un joueur", tooltip="Afficher vos coups fatals sur les joueurs ennemis."};
obj[19]	= { label="Coups fatals sur un PNJ", tooltip="Afficher vos coups fatals sur les personnages non joueurs ennemis."};
obj[20]	= { label="Gains de fragments d'\195\162me", tooltip="Afficher les gains de fragments d'\195\162me."};
obj[21]	= { label="Attaques suppl\195\169mentaires", tooltip="Afficher les gains d'attaques suppl\195\169mentaires, comme Windfury, etc."};
--obj[22]	= { label="Enemy Buff Gains", tooltip="Enable buffs your currently targeted enemy gains."};
--obj[23]	= { label="Monster Emotes", tooltip="Enable emotes by the currently targeted monster."};
--obj[24]	= { label="Money Gains", tooltip="Enable money you gain."};


------------------------------
-- Trigger info
------------------------------

-- Main events.
obj = L.TRIGGER_DATA;
--obj["SWING_DAMAGE"]				= "Swing Damage";
--obj["RANGE_DAMAGE"]				= "Range Damage";
--obj["SPELL_DAMAGE"]				= "Skill Damage";
--obj["GENERIC_DAMAGE"]			= "Swing/Range/Skill Damage";
--obj["SPELL_PERIODIC_DAMAGE"]	= "Periodic Skill Damage (DoT)";
--obj["DAMAGE_SHIELD"]			= "Damage Shield Damage";
--obj["DAMAGE_SPLIT"]				= "Split Damage";
--obj["ENVIRONMENTAL_DAMAGE"]		= "Environmental Damage";
--obj["SWING_MISSED"]				= "Swing Miss";
--obj["RANGE_MISSED"]				= "Range Miss";
--obj["SPELL_MISSED"]				= "Skill Miss";
--obj["GENERIC_MISSED"]			= "Swing/Range/Skill Miss";
--obj["SPELL_PERIODIC_MISSED"]	= "Periodic Skill Miss";
--obj["SPELL_DISPEL_FAILED"]		= "Dispel Failed";
--obj["DAMAGE_SHIELD_MISSED"]		= "Damage Shield Miss";
--obj["SPELL_HEAL"]				= "Heal";
--obj["SPELL_PERIODIC_HEAL"]		= "Periodic Heal (HoT)";
--obj["SPELL_ENERGIZE"]			= "Power Gain";
--obj["SPELL_PERIODIC_ENERGIZE"]	= "Periodic Power Gain";
--obj["SPELL_DRAIN"]				= "Power Drain";
--obj["SPELL_PERIODIC_DRAIN"]		= "Periodic Power Drain";
--obj["SPELL_LEECH"]				= "Power Leech";
--obj["SPELL_PERIODIC_LEECH"]		= "Periodic Power Leech";
--obj["SPELL_INTERRUPT"]			= "Skill Interrupt";
--obj["SPELL_AURA_APPLIED"]		= "Aura Application";
--obj["SPELL_AURA_REMOVED"]		= "Aura Removal";
--obj["SPELL_STOLEN"]				= "Aura Stolen";
--obj["SPELL_DISPEL"]				= "Aura Dispel";
--obj["ENCHANT_APPLIED"]			= "Enchant Application";
--obj["ENCHANT_REMOVED"]			= "Enchant Removal";
--obj["SPELL_CAST_START"]			= "Cast Start";
--obj["SPELL_CAST_SUCCESS"]		= "Cast Success";
--obj["SPELL_CAST_FAILED"]		= "Cast Failure";
--obj["SPELL_SUMMON"]				= "Summon";
--obj["SPELL_CREATE"]				= "Create";
--obj["PARTY_KILL"]				= "Killing Blow";
--obj["UNIT_DIED"]				= "Unit Death";
--obj["UNIT_DESTROYED"]			= "Unit Destroy";
--obj["SPELL_EXTRA_ATTACKS"]		= "Extra Attacks";
--obj["UNIT_HEALTH"]				= "Health Change";
--obj["UNIT_MANA"]				= "Mana Change";
--obj["UNIT_ENERGY"]				= "Energy Change";
--obj["UNIT_RAGE"]				= "Rage Change";
--obj["SKILL_COOLDOWN"]			= "Skill Cooldown Complete";
 
-- Main event conditions.
--obj["sourceName"]				= "Source Unit Name";
--obj["sourceAffiliation"]		= "Source Unit Affiliation";
--obj["sourceReaction"]			= "Source Unit Reaction";
--obj["sourceControl"]			= "Source Unit Control";
--obj["sourceUnitType"]			= "Source Unit Type";
--obj["recipientName"]			= "Recipient Unit Name";
--obj["recipientAffiliation"]		= "Recipient Unit Affiliation";
--obj["recipientReaction"]		= "Recipient Unit Reaction";
--obj["recipientControl"]			= "Recipient Unit Control";
--obj["recipientUnitType"]		= "Recipient Unit Type";
--obj["skillID"]					= "Skill ID";
--obj["skillName"]				= "Skill Name";
--obj["skillSchool"]				= "Skill School";
--obj["extraSkillID"]				= "Extra Skill ID";
--obj["extraSkillName"]			= "Extra Skill Name";
--obj["extraSkillSchool"]			= "Extra Skill School";
--obj["amount"]					= "Amount";
--obj["damageType"]				= "Damage Type";
--obj["resistAmount"]				= "Resist Amount";
--obj["blockAmount"]				= "Block Amount";
--obj["absorbAmount"]				= "Absorb Amount";
--obj["isCrit"]					= "Crit";
--obj["isGlancing"]				= "Glancing Hit";
--obj["isCrushing"]				= "Crushing Blow";
--obj["extraAmount"]				= "Extra Amount";
--obj["missType"]					= "Miss Type";
--obj["hazardType"]				= "Hazard Type";
--obj["powerType"]				= "Power Type";
--obj["auraType"]					= "Aura Type";
--obj["threshold"]				= "Threshold";
--obj["unitID"]					= "Unit ID";
--obj["unitReaction"]				= "Unit Reaction";

-- Exception conditions.
--obj["buffActive"]				= "Buff Active";
--obj["currentCP"]				= "Current Combo Points";
--obj["currentPower"]				= "Current Power";
--obj["recentlyFired"]			= "Trigger Recently Fired";
--obj["trivialTarget"]			= "Trivial Target";
--obj["unavailableSkill"]			= "Unavailable Skill";
--obj["warriorStance"]			= "Warrior Stance";
--obj["zoneName"]					= "Zone Name";
--obj["zoneType"]					= "Zone Type";
 
-- Relationships.
--obj["eq"]						= "Is Equal To";
--obj["ne"]						= "Is Not Equal To";
--obj["like"]						= "Is Like";
--obj["unlike"]					= "Is Not Like";
--obj["lt"]						= "Is Less Than";
--obj["gt"]						= "Is Greater Than";
 
-- Affiliations.
--obj["affiliationMine"]			= "Mine";
--obj["affiliationParty"]			= "Party Member";
--obj["affiliationRaid"]			= "Raid Member";
--obj["affiliationOutsider"]		= "Outsider";
obj["affiliationTarget"]		= TARGET;
obj["affiliationFocus"]			= FOCUS;
obj["affiliationYou"]			= YOU;

-- Reactions.
--obj["reactionFriendly"]			= "Friendly";
--obj["reactionNeutral"]			= "Neutral";
--obj["reactionHostile"]			= HOSTILE;

-- Control types.
--obj["controlServer"]			= "Server";
--obj["controlHuman"]				= "Human";

-- Unit types.
obj["unitTypePlayer"]			= PLAYER; 
--obj["unitTypeNPC"]				= "NPC";
obj["unitTypePet"]				= PET;
--obj["unitTypeGuardian"]			= "Guardian";
--obj["unitTypeObject"]			= "Object";

-- Aura types.
--obj["auraTypeBuff"]				= "Buff";
--obj["auraTypeDebuff"]			= "Debuff";

-- Zone types.
--obj["zoneTypeArena"]			= "Arena";
obj["zoneTypePvP"]				= BATTLEGROUND;
--obj["zoneTypeParty"]			= "5 man instance";
--obj["zoneTypeRaid"]				= "Raid instance";

-- Booleans
--obj["booleanTrue"]				= "True";
--obj["booleanFalse"]				= "False";


------------------------------
-- Font info
------------------------------

-- Font outlines.
obj = L.OUTLINES;
obj[1] = "Aucun";
obj[2] = "Fin";
obj[3] = "Epais";

-- Text aligns.
obj = L.TEXT_ALIGNS;
obj[1] = "Gauche";
obj[2] = "Centre";
obj[3] = "Droite";


------------------------------
-- Sound info
------------------------------

obj = L.SOUNDS;
obj["LowMana"]		= "Mana Faible";
obj["LowHealth"]	= "Vie Faible";


------------------------------
-- Animation style info
------------------------------

-- Animation styles
obj = L.ANIMATION_STYLE_DATA;
--obj["Horizontal"]	= "Horizontal";
obj["Parabola"]		= "Parabole";
obj["Straight"]		= "Directement";
obj["Static"]		= "Statique";
obj["Pow"]			= "Pow";

-- Animation style directions.
--obj["Alternate"]	= "Alternate";
obj["Left"]			= "Gauche";
obj["Right"]		= "Droite";
--obj["Up"]			= "Up";
--obj["Down"]			= "Down";

-- Animation style behaviors.
--obj["GrowUp"]			= "Grow Upwards";
--obj["GrowDown"]			= "Grow Downwards";
--obj["CurvedLeft"]		= "Curved Left";
--obj["CurvedRight"]		= "Curved Right";
--obj["Jiggle"]			= "Jiggle";
--obj["Normal"]			= "Normal";