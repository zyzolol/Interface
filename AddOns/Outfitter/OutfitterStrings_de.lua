if GetLocale() == "deDE" then
	Outfitter.cTitle = "Outfitter"
	Outfitter.cTitleVersion = Outfitter.cTitle.." "..Outfitter.cVersion

	Outfitter.cSingleItemFormat = "%s"
	Outfitter.cTwoItemFormat = "%s und %s"
	Outfitter.cMultiItemFormat = "%s{{, %s}} und %s"
	
	Outfitter.cNameLabel = "Name:"
	Outfitter.cCreateUsingTitle = "Optimieren für:"
	Outfitter.cUseCurrentOutfit = "Benutze derzeitiges Outfit"
	Outfitter.cUseEmptyOutfit = "Erstelle neues Outfit"

	Outfitter.cOutfitterTabTitle = "Outfitter"
	Outfitter.cOptionsTabTitle = "Einstellungen"
	Outfitter.cAboutTabTitle = "über"

	Outfitter.cNewOutfit = "Neues Outfit"
	Outfitter.cRenameOutfit = "Outfit umbenennen"

	Outfitter.cCompleteOutfits = "Vollständige Ausrüstungen"
	Outfitter.cPartialOutfits = "Mix-n-match"
	Outfitter.cAccessoryOutfits = "Zusatzgegenstände"
	Outfitter.cSpecialOutfits = "Besondere Gelegenheiten"

	Outfitter.cGlobalCategory = "Special Outfits"
	Outfitter.cNormalOutfit = "Normal"
	Outfitter.cNakedOutfit = "Unbekleidet"

	Outfitter.cFishingOutfit = "Angeln"
	Outfitter.cHerbalismOutfit = "Kräuterkunde"
	Outfitter.cMiningOutfit = "Bergbau"
	Outfitter.cLockpickingOutfit = "Lockpicking"
	Outfitter.cSkinningOutfit = "Kürschnerei"
	Outfitter.cFireResistOutfit = "Feuerwiderstand"
	Outfitter.cNatureResistOutfit = "Naturwiderstand"
	Outfitter.cShadowResistOutfit = "Schattenwiderstand"
	Outfitter.cArcaneResistOutfit = "Arkanwiderstand"
	Outfitter.cFrostResistOutfit = "Frostwiderstand"

	Outfitter.cArgentDawnOutfit = "Argentumdämmerung"
	Outfitter.cRidingOutfit = "Reiten"
	Outfitter.cDiningOutfit = "Ausruhen"
	Outfitter.cBattlegroundOutfit = "Schlachtfeld"
	
	Outfitter.cABOutfit = "Schlachtfeld: Arathibecken"
	Outfitter.cAVOutfit = "Schlachtfeld: Alteractal"
	Outfitter.cWSGOutfit = "Schlachtfeld: Kriegshymnenschlucht"
	Outfitter.cEotSOutfit = "Schlachtfeld: Auge des Sturms"
	Outfitter.cCityOutfit = "Stadt"
	Outfitter.cSwimmingOutfit = "Schwimmen"
	
	Outfitter.cMountSpeedFormat = "Erhöht %w+empo um %d+%%"; -- For detecting when mounted
	Outfitter.cFlyingMountSpeedFormat = "Erhöht Fluggeschwindigkeit um (%d+)%%%."; -- For detecting when mounted
	
	Outfitter.cBagsFullError = "%s kann nicht enfernt werden da alle Taschen voll sind."
	Outfitter.cItemNotFoundError = "Kann %s nicht finden."
	Outfitter.cAddingItem = "Füge %s zum %s Outfit."
	Outfitter.cNameAlreadyUsedError = "Fehler: Dieser Name ist bereits vergeben."
	Outfitter.cNoItemsWithStatError = "Warnung: Keiner deiner Gegenstände hat dieses Attribut."

	Outfitter.cEnableAll = "Alle aktivieren"
	Outfitter.cEnableNone = "Alle deaktivieren"

	Outfitter.cConfirmDeleteMsg = "Bist du sicher dass du das %s Outfit löschen willst?"
	Outfitter.cConfirmRebuildMsg = "Bist du sicher dass du das %s Outfit verändern willst?"
	Outfitter.cRebuild = "Verändern"

	Outfitter.cWesternPlaguelands = "Westliche Pestländer"
	Outfitter.cEasternPlaguelands = "Östliche Pestländer"
	Outfitter.cStratholme = "Stratholme"
	Outfitter.cScholomance = "Scholomance"
	Outfitter.cNaxxramas = "Naxxramas"
	Outfitter.cAlteracValley = "Alteractal"
	Outfitter.cArathiBasin = "Arathibecken"
	Outfitter.cWarsongGulch = "Kriegshymnenschlucht"
	Outfitter.cEotS = "Auge des Sturms"
	Outfitter.cIronforge = "Eisenschmiede"
	Outfitter.cDarnassus = "Darnassus"
	Outfitter.cStormwind = "Sturmwind"
	Outfitter.cOrgrimmar = "Orgrimmar"
	Outfitter.cThunderBluff = "Donnerfels"
	Outfitter.cUndercity = "Unterstadt"
	Outfitter.cSilvermoon = "Silbermond"
	Outfitter.cExodar = "Die Exodar"
	Outfitter.cShattrath = "Shattrath"
	Outfitter.cAQ40 = "Tempel von Ahn'Qiraj"
	Outfitter.cBladesEdgeArena = "Arena des Schergrats"
	Outfitter.cNagrandArena = "Arena von Nagrand"
	Outfitter.cRuinsOfLordaeron = "Ruinen von Lordaeron"

	Outfitter.cItemStatFormats =
	{
		{Format = "Schwache Reittemposteigerung", Value = 3, Types = {"Riding"}},
		{Format = "Mithrilsporen", Value = 3, Types = {"Riding"}},
		
		"Erhöht durch (.+) um bis zu (%d+)",
		
		"Increases damage done by (.+) spells and effects by up to (%d+)",
		"Increases (.+) done by up to (%d+) and (healing) done by up to (%d+)",
		"Increases (healing) done by up to (%d+) and damage done by up to (%d+) for all (magical spells and effects)",
		"Increases the (.+) of your .+ by (%d+)",
		"Increases your (.+) by (%d+)",
		"Increases (.+) by up to (%d+)",
		"Increases (.+) by (%d+)",
		"%+(%d+) (.+) and %+(%d+) (.+)", -- Multi-stat items like secondary-color gems
		"%+(%d+) (.+)/%+(%d+) (.+)/%+(%d+) (.+)", -- Multi-stat enchants from ZG
		"%+(%d+) (.+)/%+(%d+) (.+)", -- Multi-stat enchants from ZG
		
		"Increased (.+) %+(%d+)",
		"Improves (.+) by (%d+)",
		
		"Restores (%d+) (.+)",
		
		"(%d+) (.+)",
		"(.+) %+(%d+)",
	}

	Outfitter.cItemStatPhrases =
	{
		["ausdauer"] = "Stamina",
		["intelligenz"] = "Intellect",
		["beweglichkeit"] = "Agility",
		["stärke"] = "Stength",
		["willenskraft"] = "Spirit",
		["all stats"] = {"Stamina", "Intellect", "Agility", "Strength", "Spirit"},
		
		["rüstung"] = "Armor",
		
		["mana"] = "Mana",
		["gesundheit"] = "Health",
		
		["feuerwiderstand"] = "FireResist",
		["naturwiderstand"] = "NatureResist",
		["frostwiderstand"] = "FrostResist",
		["schattenwiderstand"] = "ShadowResist",
		["arkanwiderstand"] = "ArcaneResist",
		["alle widerstände"] = {"FireResist", "NatureResist", "FrostResist", "ShadowResist", "ArcaneResist"},
		
		["defense rating"] = "DefenseRating",
		["resilience rating"] = "ResilienceRating",
		["angriffskraft"] = {"Attack", "RangedAttack"},
		["ranged attack power"] = "RangedAttack",
		["critical strike rating"] = "MeleeCritRating",
		["hit rating"] = "MeleeHitRating",
		["dodge rating"] = "DodgeRating",
		["parry rating"] = "ParryRating",
		["block"] = "Block",
		["block value"] = "Block",
		["waffenschaden"] = "MeleeDmg",
		["schaden"] = "MeleeDmg",
		
		["spell critical rating"] = "SpellCritRating",
		["spell critical strike rating"] = "SpellCritRating",
		["spell hit rating"] = "SpellHitRating",
		["spell penetration"] = "SpellPen",
		
		["zauber und magische effekte verursachten schaden und heilung"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg", "Healing"},
		["spell damage"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg"},
		["magical spells and effects"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg"},
		
		["feuerzauberschaden"] = "FireDmg",
		["schattenzauberschaden"] = "ShadowDmg",
		["frostzauberschaden"] = "FrostDmg",
		["arkanzauberschaden"] = "ArcaneDmg",
		["naturzauberschaden"] = "NatureDmg",
		["feuerzauber und feuereffekte zugefügten schaden"] = "FireDmg",
		["schattenzauber und schatteneffekte zugefügten schaden"] = "ShadowDmg",
		["frostzauber und frosteffekte zugefügten schaden"] = "FrostDmg",
		["arkanzauber und arkaneffekte zugefügten schaden"] = "ArcaneDmg",
		["naturzauber und natureffekte zugefügten schaden"] = "NatureDmg",
		
		["zauber und effekte verursachte heilung"] = "Healing",
		["heilzauber"] = "Healing",
		
		["erhöht angeln"] = "Fishing",
		["angeln"] = "Fishing",
		["kräuterkunde"] = "Herbalism",
		["bergbau"] = "Mining",
		["kürschnerei"] = "Skinning",
		["mount speed"] = "Riding",
		
		["mana alle 5 sek"] = {"ManaRegen", "CombatManaRegen"},
		["mana regen"] = {"ManaRegen", "CombatManaRegen"},
		["gesundheit alle 5 sek"] = {"HealthRegen", "CombatHealthRegen"},
		["health regen"] = {"HealthRegen", "CombatHealthRegen"},
	}
	
	Outfitter.cAgilityStatName = "Beweglichkeit"
	Outfitter.cArmorStatName = "Rüstung"
	Outfitter.cDefenseStatName = "Verteidigung"
	Outfitter.cIntellectStatName = "Intelligenz"
	Outfitter.cSpiritStatName = "Willenskraft"
	Outfitter.cStaminaStatName = "Ausdauer"
	Outfitter.cStrengthStatName = "Stärke"
	Outfitter.cTotalStatsName = "Gesamtwerte"
	
	Outfitter.cManaRegenStatName = "Manaregeneration"
	Outfitter.cHealthRegenStatName = "Gesundheitsregeneration"

	Outfitter.cSpellCritStatName = "Zauberkritisch"
	Outfitter.cSpellHitStatName = "Trefferchance für Zauber"
	Outfitter.cSpellDmgStatName = "Zauberschaden"
	Outfitter.cFrostDmgStatName = "Frostzauberschaden"
	Outfitter.cFireDmgStatName = "Feuerzauberschaden"
	Outfitter.cArcaneDmgStatName = "Arkanzauberschaden"
	Outfitter.cShadowDmgStatName = "Schattenzauberschaden"
	Outfitter.cNatureDmgStatName = "Naturzauberschaden"
	Outfitter.cHealingStatName = "Heilung"

	Outfitter.cMeleeCritStatName = "Kampfkritisch"
	Outfitter.cMeleeHitStatName = "Kampftrefferchance"
	Outfitter.cMeleeDmgStatName = "Kampfschaden"
	Outfitter.cAttackStatName = "Angriffskraft"
	Outfitter.cRangedAttackStatName = "Distanzangriffskraft"
	Outfitter.cDodgeStatName = "Ausweichen"

	Outfitter.cArcaneResistStatName = "Arkanwiderstand"
	Outfitter.cFireResistStatName = "Feuerwiderstand"
	Outfitter.cFrostResistStatName = "Frostwiderstand"
	Outfitter.cNatureResistStatName = "Naturwiderstand"
	Outfitter.cShadowResistStatName = "Schattenwiderstand"

	Outfitter.cFishingStatName = "Angeln"
	Outfitter.cHerbalismStatName = "Kräuterkunde"
	Outfitter.cMiningStatName = "Bergbau"
	Outfitter.cSkinningStatName = "Kürschnerei"

	Outfitter.cOptionsTitle = "Outfitter Einstellungen"
	Outfitter.cShowMinimapButton = "Zeige Minimapbutton"
	Outfitter.cShowMinimapButtonOnDescription = "Deaktivieren, um den Minimapbutton von Outfitter zu verstecken."
	Outfitter.cShowMinimapButtonOffDescription = "Aktivieren, um den Minimapbutton von Outfitter zu zeigen."

	Outfitter.cAutoSwitch = "Outfit nicht automatisch umschalten"
	Outfitter.cAutoSwitchOnDescription = "Abschalten um automatische Outfitwechsel zu aktivieren."
	Outfitter.cAutoSwitchOffDescription = "Einschalten, um automatische Outfitwechsel zu deaktivieren."
 	Outfitter.cTooltipInfo = "Tooltips anzeigen"
	Outfitter.cTooltipInfoOnDescription = "Abschalten, um 'Benutzt von:' in Tooltips zu verstecken. (Verbessert die Frame-Rate geringfügig)"
	Outfitter.cTooltipInfoOffDescription = "Einschalten, um 'Benutzt von:' in Tooltips anzuzeigen."
	Outfitter.cRememberVisibility = "Umhang- und Helm-Einstellungen merken"
	Outfitter.cRememberVisibilityOnDescription = "Abschalten, um die Anzeige von Umhängen und Helmen allgemein festzulegen"
	Outfitter.cRememberVisibilityOffDescription = "Einschalten, um die Anzeige für jeden Helm und Umhang individuell zu regeln"

	Outfitter.cAboutTitle = "über Outfitter"
	Outfitter.cAuthor = "Designed and written by John Stephen and Bruce Quinton with contributions by %s"
	Outfitter.cTestersTitle = "Outfitter 4.1 testers"
	Outfitter.cTestersNames = "%s"
	Outfitter.cSpecialThanksTitle = "Besonderen Dank für ihre Unterstützung geht an"
	Outfitter.cSpecialThanksNames = "%s"
	Outfitter.cTranslationCredit = "Übersetzung: %s"
	Outfitter.cURL = "wobbleworks.com"

	Outfitter.cOpenOutfitter = "Outfitter öffnen"

	Outfitter.cArgentDawnOutfitDescription = "Dieses Outfit wird automatisch beim Betreten der Pestländer angelegt"
	Outfitter.cRidingOutfitDescription = "Dieses Outfit wird automatisch beim Reiten angelegt"
	Outfitter.cDiningOutfitDescription = "Dieses Outfit wird automatisch beim Essen und/oder Trinken angelegt"
	Outfitter.cBattlegroundOutfitDescription = "Dieses Outfit wird automatisch beim Betreten eines Schlachtfeldes angelegt"
	Outfitter.cArathiBasinOutfitDescription = "Dieses Outfit wird automatisch beim Betreten des Arathibeckens angelegt"
	Outfitter.cAlteracValleyOutfitDescription = "Dieses Outfit wird automatisch beim Betreten des Alteractals angelegt"
	Outfitter.cWarsongGulchOutfitDescription = "Dieses Outfit wird automatisch beim Betreten der Kriegshymnenschlucht angelegt"
	Outfitter.cEotSOutfitDescription = "Dieses Outfit wird automatisch beim Betreten des Auge des Sturms angelegt"
	Outfitter.cCityOutfitDescription = "Dieses Outfit wird automatisch beim Betreten freundlicher Hauptstädte angelegt"

	Outfitter.cKeyBinding = "Tastaturbelegung"

	BINDING_HEADER_OUTFITTER_TITLE = Outfitter.cTitle

	BINDING_NAME_OUTFITTER_OUTFIT1  = "Outfit 1"
	BINDING_NAME_OUTFITTER_OUTFIT2  = "Outfit 2"
	BINDING_NAME_OUTFITTER_OUTFIT3  = "Outfit 3"
	BINDING_NAME_OUTFITTER_OUTFIT4  = "Outfit 4"
	BINDING_NAME_OUTFITTER_OUTFIT5  = "Outfit 5"
	BINDING_NAME_OUTFITTER_OUTFIT6  = "Outfit 6"
	BINDING_NAME_OUTFITTER_OUTFIT7  = "Outfit 7"
	BINDING_NAME_OUTFITTER_OUTFIT8  = "Outfit 8"
	BINDING_NAME_OUTFITTER_OUTFIT9  = "Outfit 9"
	BINDING_NAME_OUTFITTER_OUTFIT10 = "Outfit 10"

	Outfitter.cShowHelm = "Helm anzeigen"
	Outfitter.cShowCloak = "Umhang anzeigen"
	Outfitter.cHideHelm = "Helm verstecken"
	Outfitter.cHideCloak = "Umhang verstecken"
	
	Outfitter.cDisableOutfit = "Outfit abschalten"
	Outfitter.cDisableOutfitInBG = "Outfit beim Betreten eines Schlachtfeldes abschalten."
	Outfitter.cDisabledOutfitName = "%s (Abgeschalten)"

	Outfitter.cOutfitBar = "Outfit Bar"
	Outfitter.cShowInOutfitBar = "Show in outfit bar"
	Outfitter.cChangeIcon = "Choose icon..."

	Outfitter.cMinimapButtonTitle = "Outfitter Minimapbutton"
	Outfitter.cMinimapButtonDescription = "Klicken für eine Auswahl an Outfits oder gedrückt halten zum Bewegen des Buttons."

	Outfitter.cClassName.DRUID = "Druide"
	Outfitter.cClassName.HUNTER = "Jäger"
	Outfitter.cClassName.MAGE = "Magier"
	Outfitter.cClassName.PALADIN = "Paladin"
	Outfitter.cClassName.PRIEST = "Priester"
	Outfitter.cClassName.ROGUE = "Schurke"
	Outfitter.cClassName.SHAMAN = "Schamane"
	Outfitter.cClassName.WARLOCK = "Hexenmeister"
	Outfitter.cClassName.WARRIOR = "Krieger"

	Outfitter.cBattleStance = "Kampfhaltung"
	Outfitter.cDefensiveStance = "Verteidigungshaltung"
	Outfitter.cBerserkerStance = "Berserkerhaltung"

	Outfitter.cWarriorBattleStance = "Krieger: Kampfhaltung"
	Outfitter.cWarriorDefensiveStance = "Krieger: Verteidigungshaltung"
	Outfitter.cWarriorBerserkerStance = "Krieger: Berserkerhaltung"

	Outfitter.cBearForm = "Bärengestalt"
	Outfitter.cCatForm = "Katzengestalt"
	Outfitter.cAquaticForm = "Wassergestalt"
	Outfitter.cTravelForm = "Reisegestalt"
	Outfitter.cDireBearForm = "Terrorbärengestalt"
	Outfitter.cMoonkinForm = "Mondkingestalt"
	Outfitter.cTreeOfLifeForm = "Baum des Lebens"
	Outfitter.cGhostWolfForm = "Geisterwolf"
	Outfitter.cFlightForm = "Fluggestalt"
	Outfitter.cSwiftFlightForm = "Schnelle Fluggestalt"
  
	Outfitter.cStealth = "Verstohlenheit"

	Outfitter.cDruidBearForm = "Druide: Bärengestalt"
	Outfitter.cDruidCatForm = "Druide: Katzengestalt"
	Outfitter.cDruidAquaticForm = "Druide: Wassergestalt"
	Outfitter.cDruidFlightForm = "Druide: Fluggestalt"
	Outfitter.cDruidSwiftFlightForm = "Druide: Schnelle Fluggestalt"
	Outfitter.cDruidTravelForm = "Druide: Reisegestalt"
	Outfitter.cDruidMoonkinForm = "Druide: Mondkingestalt"
	Outfitter.cDruidProwl = "Druide: Prowl"
	Outfitter.cDruidTreeOfLifeForm = "Druide: Baum des Lebens";	
	Outfitter.cProwl = "Pirschen"

	Outfitter.cPriestShadowform = "Priester: Schattengestalt"

	Outfitter.cRogueStealth = "Schurke: Verstohlenheit"

	Outfitter.cShamanGhostWolf = "Schamane: Geisterwolf"

	Outfitter.cHunterMonkey = "Jäger: Affe"
	Outfitter.cHunterHawk =  "Jäger: Falke"
	Outfitter.cHunterCheetah =  "Jäger: Gepard"
	Outfitter.cHunterPack =  "Jäger: Rudel"
	Outfitter.cHunterBeast =  "Jäger: Wildtier"
	Outfitter.cHunterWild =  "Jäger: Wildnis"

	Outfitter.cMageEvocate = "Magier: Hervorrufung"

	Outfitter.cAspectOfTheCheetah = "Aspekt des Geparden"
	Outfitter.cAspectOfThePack = "Aspekt des Rudels"
	Outfitter.cAspectOfTheBeast = "Aspekt des Wildtiers"
	Outfitter.cAspectOfTheWild = "Aspekt der Wildnis"
	Outfitter.cEvocate = "Hervorrufung"

	Outfitter.cCompleteCategoryDescription = "Vollständige Outfits haben für jeden Inventarslot festgelegte Gegenstände, die alles andere ersetzen wenn sie getragen werden."
	Outfitter.cPartialCategoryDescription = "Bei Mix-n-match Outfits sind nur einige Gegenstände festgelegt, jedoch nicht alle.  Werden diese Outfits ausgewählt bleibt das vorherige Outfit erhalten, nur die neuen Gegenstände werden geändert."
	Outfitter.cAccessoryCategoryDescription = "Zusatzgegenstände-Outfits haben nur einige festgelegte Inventarslots.  Anders als beim Mix-n-match kannst du so viele Zusatzgegenstände-Outfits erstellen und tragen, sie werden alle miteinander verbunden und über bestehenden Outfits getragen."
	Outfitter.cSpecialCategoryDescription = "Besondere Gelegenheit-Outfits werden automatisch angelegt wenn die Situation es verlangt.  Sie werden über allen anderen Outfits getragen."
	Outfitter.cOddsNEndsCategoryDescription = "Odds 'n ends ist eine Auflistung der Gegenstände, die keinem Outfit zugewiesen sind. Mit dieser Funktion kannst du sicherstellen, dass alle Gegenstände ihren Platz haben oder dass du keine unnötigen Gegenstände mit dir herumträgst."
	
	Outfitter.cRebuildOutfitFormat = "%s geändert."
	
	Outfitter.cSlotEnableTitle = "Slot aktivieren"
	Outfitter.cSlotEnableDescription = "Aktiviere diese Option, damit der Gegenstand in diesem Slot automatisch angelegt wird wenn du zu diesem Outfit wechselst.  Ist dieser Slot nicht aktiviert, wird er beim Anlegen eines anderen Outfits nicht verändert."
	
	Outfitter.cFinger0SlotName = "Erster Finger"
	Outfitter.cFinger1SlotName = "Zweiter Finger"
	
	Outfitter.cTrinket0SlotName = "Erstes Schmuckstück"
	Outfitter.cTrinket1SlotName = "Zweites Schmuckstück"
	
	Outfitter.cOutfitCategoryTitle = "Kategorie"
	Outfitter.cBankCategoryTitle = "Bank"
	Outfitter.cDepositToBank = "Gegenstände im Bankfach ablegen"
	Outfitter.cDepositUniqueToBank = "Einzigartige Gegenstände im Bankfach ablegen"
	Outfitter.cWithdrawFromBank = "Gegenstände vom Bankfach aufnehmen"
	
	Outfitter.cMissingItemsLabel = "Fehlende Gegenstände: "
	Outfitter.cBankedItemsLabel = "Gegenstände auf der Bank: "

	Outfitter.cStatsCategory = "Werte"
	Outfitter.cMeleeCategory = "Nahkampf"
	Outfitter.cSpellsCategory = "Heilung und Zauber"
	Outfitter.cRegenCategory = "Regeneration"
	Outfitter.cResistCategory = "Widerstände"
	Outfitter.cTradeCategory = "Fähigkeiten"
	
	Outfitter.cScript = "Script"
	Outfitter.cDisableScript = "Script abschalten"
	Outfitter.cEditScript = "Script bearbeiten"
	Outfitter.cEventsLabel = "Ereignisse:"
	Outfitter.cScriptLabel = "Script:"

	Outfitter.cSetCurrentItems = "Mit aktuellem Outfit überschreiben"
	Outfitter.cConfirmSetCurrentMsg = "Wollt ihr %s wirklich mit den zur Zeit angelegten Gegenständen überschreiben? Hinweis: Nur aktive Slots werden berücksichtigt. Zusätzliche Slots können später hinzugefügt werden"
	Outfitter.cSetCurrent = "Aktualisieren"
	Outfitter.cTyping = "Schreibe..."
	Outfitter.cScriptErrorFormat = "Fehler in Zeile %d: %s"
	Outfitter.cExtractErrorFormat = "%[string \"Outfit Script\"%]:(%d+):(.*)"
	Outfitter.cPresetScript = "Vorgefertigtes Script:"
	Outfitter.cCustomScript = "Benutzerdefiniert"
	Outfitter.cSettings = "Einstellungen"
	Outfitter.cSource = "Quellcode"
	Outfitter.cInsertFormat = "<- %s"
	
	Outfitter.cContainerBagSubType = "Behälter"
	Outfitter.cUsedByPrefix = "Benutzt von Outfits: "

	Outfitter.cNone = "Keins"
	
	Outfitter.cUseDurationTooltipLineFormat = "^Benutzen:.*(%d+) Sek%. lang"
	Outfitter.cUseDurationTooltipLineFormat2 = "^Benutzen:.*(%d+) Sek%. lang"
	
	Outfitter.cAutoChangesDisabled = "Automated changes are now disabled"
	Outfitter.cAutoChangesEnabled = "Automated changes are now enabled"
end
