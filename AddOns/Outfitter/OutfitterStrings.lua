Outfitter = {}
MCDebugLib:InstallDebugger("Outfitter", Outfitter, {r=0.6,g=1,b=0.8})

Outfitter.cVersion = "4.2.6"

Outfitter.cTitle = "Outfitter"
Outfitter.cTitleVersion = Outfitter.cTitle.." "..Outfitter.cVersion

Outfitter.cSingleItemFormat = "%s"
Outfitter.cTwoItemFormat = "%s and %s"
Outfitter.cMultiItemFormat = "%s{{, %s}} and %s"

Outfitter.cNameLabel = "Name:"
Outfitter.cCreateUsingTitle = "Optimize for:"
Outfitter.cUseCurrentOutfit = "Use Current Outfit"
Outfitter.cUseEmptyOutfit = "Create Empty Outfit"
Outfitter.cAutomationLabel = "Automation:"

Outfitter.cOutfitterTabTitle = "Outfitter"
Outfitter.cOptionsTabTitle = "Options"
Outfitter.cAboutTabTitle = "About"

Outfitter.cNewOutfit = "New Outfit"
Outfitter.cRenameOutfit = "Rename Outfit"

Outfitter.cCompleteOutfits = "Complete outfits"
Outfitter.cAccessoryOutfits = "Accessories"
Outfitter.cOddsNEndsOutfits = "Odds 'n ends"

Outfitter.cGlobalCategory = "Special Outfits"
Outfitter.cNormalOutfit = "Normal"
Outfitter.cNakedOutfit = "Birthday Suit"

Outfitter.cScriptCategoryName = {}
Outfitter.cScriptCategoryName.PVP = "PvP"
Outfitter.cScriptCategoryName.TRADE = "Activities"
Outfitter.cScriptCategoryName.GENERAL = "General"

Outfitter.cArgentDawnOutfit = "Argent Dawn"
Outfitter.cCityOutfit = "Around Town"
Outfitter.cBattlegroundOutfit = "Battleground"
Outfitter.cAVOutfit = "Battleground: Alterac Valley"
Outfitter.cABOutfit = "Battleground: Arathi Basin"
Outfitter.cArenaOutfit = "Battleground: Arena"
Outfitter.cEotSOutfit = "Battleground: Eye of the Storm"
Outfitter.cWSGOutfit = "Battleground: Warsong Gulch"
Outfitter.cDiningOutfit = "Dining"
Outfitter.cFishingOutfit = "Fishing"
Outfitter.cHerbalismOutfit = "Herbalism"
Outfitter.cMiningOutfit = "Mining"
Outfitter.cFireResistOutfit = "Resist: Fire"
Outfitter.cNatureResistOutfit = "Resist: Nature"
Outfitter.cShadowResistOutfit = "Resist: Shadow"
Outfitter.cArcaneResistOutfit = "Resist: Arcane"
Outfitter.cFrostResistOutfit = "Resist: Frost"
Outfitter.cRidingOutfit = "Riding"
Outfitter.cSkinningOutfit = "Skinning"
Outfitter.cSwimmingOutfit = "Swimming"
Outfitter.cLowHealthOutfit = "Low Health or Mana"
Outfitter.cHasBuffOutfit = "Player has buff"
Outfitter.cInZonesOutfit = "In Zones"
Outfitter.cSoloOutfit = "Solo/Party/Raid"
Outfitter.cFallingOutfit = "Falling"

Outfitter.cArgentDawnOutfitDescription = "Equips the outfit when you're in the Plaguelands"
Outfitter.cRidingOutfitDescription = "Equips the outfit when you're mounted"
Outfitter.cDiningOutfitDescription = "Equips the outfit when you're eating or drinking until your health/mana are above 90%"
Outfitter.cBattlegroundOutfitDescription = "Equips the outfit when you're in any battleground"
Outfitter.cArathiBasinOutfitDescription = "Equips the outfit when you're in the Arathi Basin battleground"
Outfitter.cAlteracValleyOutfitDescription = "Equips the outfit when you're in in the Alterac Valley battleground"
Outfitter.cWarsongGulchOutfitDescription = "Equips the outfit when you're in the Warsong Gulch battleground"
Outfitter.cEotSOutfitDescription = "Equips the outfit when you're in the Eye of the Storm battleground"
Outfitter.cArenaOutfitDescription = "Equips the outfit when you're in a PvP Arena"
Outfitter.cCityOutfitDescription = "Equips the outfit when you're in a friendly major city"
Outfitter.cSwimmingOutfitDescription = "Equips the outfit when you're swimming"
Outfitter.cFishingOutfitDescription = "Unequips the outfit if you enter combat, then requips it afterwards."
Outfitter.cSpiritOutfitDescription = "Equips the outfit when you're regenerating mana (out of the five-second rule)"
Outfitter.cHerbalismDescription = "Equips the outfit when your cursor is over an herb node that is orange or red to you"
Outfitter.cMiningDescription = "Equips the outfit when your cursor is over a mining node that is orange or red to you"
Outfitter.cLockpickingDescription = "Equips the outfit when your cursor is over a lock that is orange or red to you"
Outfitter.cSkinningDescription = "Equips the outfit when your cursor is over a skinnable creature that is orange or red to you"
Outfitter.cLowHealthDescription = "Equips the outfit when your health or mana go below the specified values"
Outfitter.cHasBuffDescription = "Equips the outfit when you have a buff with the specified name"
Outfitter.SpiritRegenOutfitDescription = "Equips the outfit when you are regenerating mana (out of the five-second rule)"
Outfitter.cDruidCasterFormDescription = "Equips the outfit when you are not in any druid form"
Outfitter.cPriestShadowformDescription = "Equips the outfit when you are in shadow form"
Outfitter.cShamanGhostWolfDescription = "Equips the outfit when you are in ghost wolf form"
Outfitter.cHunterMonkeyDescription = "Equips the outfit when you are in Monkey aspect"
Outfitter.cHunterHawkDescription = "Equips the outfit when you are in Hawk aspect"
Outfitter.cHunterCheetahDescription = "Equips the outfit when you are in Cheetah aspect"
Outfitter.cHunterPackDescription = "Equips the outfit when you are in Pack aspect"
Outfitter.cHunterBeastDescription = "Equips the outfit when you are in Beast aspect"
Outfitter.cHunterWildDescription = "Equips the outfit when you are in Wild aspect"
Outfitter.cHunterViperDescription = "Equips the outfit when you are in Viper aspect"
Outfitter.cHunterFeignDeathDescription = "Equips the outfit when you are feigning death"
Outfitter.cMageEvocateDescription = "Equips the outfit when you are evocating"
Outfitter.cWarriorBerserkerStanceDescription = "Equips the outfit when you are in Berserker stance"
Outfitter.cWarriorDefensiveStanceDescription = "Equips the outfit when you are in Defensive stance"
Outfitter.cWarriorBattleStanceDescription = "Equips the outfit when you are in Battle stance"
Outfitter.cInZonesOutfitDescription = "Equips the outfit when you are in one of the zones or minimap sub-zones listed below"
Outfitter.cSoloOutfitDescription = "Equips the outfit when solo, partied or raiding, based on the settings"
Outfitter.cFallingOutfitDescription = "Equips the outfit when you're falling"

Outfitter.cMountSpeedFormat = "Increases speed by (%d+)%%%."; -- For detecting when mounted
Outfitter.cFlyingMountSpeedFormat = "Increases flight speed by (%d+)%%%."; -- For detecting when mounted

Outfitter.cBagsFullError = "Can't remove %s because all bags are full"
Outfitter.cDepositBagsFullError = "Can't deposit %s because all bank bags are full"
Outfitter.cWithdrawBagsFullError = "Can't withdraw %s because all bags are full"
Outfitter.cItemNotFoundError = "Can't find item %s"
Outfitter.cItemAlreadyUsedError = "Can't put %s in the %s slot because it's already being used in another slot"
Outfitter.cAddingItem = "Adding %s to %s outfit"
Outfitter.cNameAlreadyUsedError = "Error: That name is already being used"
Outfitter.cNoItemsWithStatError = "Warning: None of your items have that attribute"
Outfitter.cCantUnequipCompleteError = "Can't unequip %s because complete outfits can't be unequipped (you must equip a different complete outfit instead)"

Outfitter.cEnableAll = "Enable all"
Outfitter.cEnableNone = "Enable none"

Outfitter.cConfirmDeleteMsg = "Are you sure you want to delete the outfit %s?"
Outfitter.cConfirmRebuildMsg = "Are you sure you want to rebuild the outfit %s?"
Outfitter.cRebuild = "Rebuild"

Outfitter.cWesternPlaguelands = "Western Plaguelands"
Outfitter.cEasternPlaguelands = "Eastern Plaguelands"
Outfitter.cStratholme = "Stratholme"
Outfitter.cScholomance = "Scholomance"
Outfitter.cNaxxramas = "Naxxramas"
Outfitter.cAlteracValley = "Alterac Valley"
Outfitter.cArathiBasin = "Arathi Basin"
Outfitter.cWarsongGulch = "Warsong Gulch"
Outfitter.cEotS = "Eye of the Storm"
Outfitter.cIronforge = "Ironforge"
Outfitter.cCityOfIronforge = "City of Ironforge"
Outfitter.cDarnassus = "Darnassus"
Outfitter.cStormwind = "Stormwind City"
Outfitter.cOrgrimmar = "Orgrimmar"
Outfitter.cThunderBluff = "Thunder Bluff"
Outfitter.cUndercity = "Undercity"
Outfitter.cSilvermoon = "Silvermoon City"
Outfitter.cExodar = "The Exodar"
Outfitter.cShattrath = "Shattrath City"
Outfitter.cAQ40 = "Ahn'Qiraj Temple"
Outfitter.cBladesEdgeArena = "Blade's Edge Arena"
Outfitter.cNagrandArena = "Nagrand Arena"
Outfitter.cRuinsOfLordaeron = "Ruins of Lordaeron"

Outfitter.cItemStatFormats =
{
	{Format = "Minor Mount Speed Increase", Value = 3, Types = {"Riding"}},
	{Format = "Mithril Spurs", Value = 3, Types = {"Riding"}},
	
	"Increases damage done by (.+) spells and effects by up to (%d+)",
	"Increases (.+) done by up to (%d+) and (healing) done by up to (%d+)",
	"Increases (healing) done by up to (%d+) and damage done by up to (%d+) for all (magical spells and effects)",
	"Increases the (.+) of your .+ by (%d+)",
	"Increases your (.+) by (%d+)",
	"Improves your (.+) by (%d+)",
	"Increases (.+) by up to (%d+)",
	"Increases (.+) by (%d+)",
	"%+(%d+) (.+) and %+(%d+) (.+)", -- Multi-stat items like secondary-color gems
	"%+(%d+) (.+)/%+(%d+) (.+)/%+(%d+) (.+)", -- Multi-stat enchants from ZG
	"%+(%d+) (.+)/%+(%d+) (.+)", -- Multi-stat enchants from ZG
	
	"Increased (.+) %+(%d+)",
	"Improves (.+) by (%d+)",
	
	"Restores (%d+) (.+)",
	
	"%+(%d+) (%w+) Spell Damage",
	
	"(%d+) (.+)",
	"(.+) %+(%d+)",
}

Outfitter.cItemStatPhrases =
{
	["stamina"] = "Stamina",
	["intellect"] = "Intellect",
	["agility"] = "Agility",
	["strength"] = "Strength",
	["spirit"] = "Spirit",
	["all stats"] = {"Stamina", "Intellect", "Agility", "Strength", "Spirit"},
	
	["armor"] = "Armor",
	
	["mana"] = "Mana",
	["health"] = "Health",
	
	["fire resistance"] = "FireResist",
	["nature resistance"] = "NatureResist",
	["frost resistance"] = "FrostResist",
	["shadow resistance"] = "ShadowResist",
	["arcane resistance"] = "ArcaneResist",
	["all resistances"] = {"FireResist", "NatureResist", "FrostResist", "ShadowResist", "ArcaneResist"},
	
	["defense rating"] = "DefenseRating",
	["resilience rating"] = "ResilienceRating",
	["attack power"] = {"Attack", "RangedAttack"},
	["ranged attack power"] = "RangedAttack",
	["critical strike rating"] = "MeleeCritRating",
	["hit rating"] = "MeleeHitRating",
	["dodge rating"] = "DodgeRating",
	["parry rating"] = "ParryRating",
	["block"] = "Block",
	["block value"] = "Block",
	["weapon damage"] = "MeleeDmg",
	["damage"] = "MeleeDmg",
	["haste rating"] = "MeleeHasteRating",
	
	["spell critical rating"] = "SpellCritRating",
	["spell critical strike rating"] = "SpellCritRating",
	["spell hit rating"] = "SpellHitRating",
	["spell penetration"] = "SpellPen",
	["spell haste rating"] = "SpellHasteRating",
	
	["damage and healing done by magical spells and effects"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg", "Healing"},
	["spell damage"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg"},
	["spell power"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg"},
	["spell damage and healing"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg", "Healing"},
	["magical spells and effects"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg"},
	
	["fire"] = "FireDmg",
	["shadow"] = "ShadowDmg",
	["frost"] = "FrostDmg",
	["arcane"] = "ArcaneDmg",
	["nature"] = "NatureDmg",
	
	["healing done by spells and effects"] = "Healing",
	["healing"] = "Healing",
	["healing spells"] = "Healing",
	
	["fishing"] = "Fishing",
	["herbalism"] = "Herbalism",
	["mining"] = "Mining",
	["skinning"] = "Skinning",
	["mount speed"] = "Riding",
	
	["mana per 5 sec"] = {"ManaRegen", "CombatManaRegen"},
	["mana regen"] = {"ManaRegen", "CombatManaRegen"},
	["health per 5 sec"] = {"HealthRegen", "CombatHealthRegen"},
	["health regen"] = {"HealthRegen", "CombatHealthRegen"},
}

Outfitter.cAgilityStatName = "Agility"
Outfitter.cArmorStatName = "Armor"
Outfitter.cDefenseStatName = "Defense"
Outfitter.cIntellectStatName = "Intellect"
Outfitter.cSpiritStatName = "Spirit"
Outfitter.cStaminaStatName = "Stamina"
Outfitter.cStrengthStatName = "Strength"
Outfitter.cTotalStatsName = "Total Stats"
Outfitter.cHealthStatName = "Health"
Outfitter.cManaStatName = "Mana"

Outfitter.cManaRegenStatName = "Mana per 5"
Outfitter.cCombatManaRegenStatName = "Mana per 5 (combat)"
Outfitter.cHealthRegenStatName = "Health per 5"
Outfitter.cCombatHealthRegenStatName = "Health per 5 (combat)"

Outfitter.cSpellCritStatName = "Spell Critical Strike"
Outfitter.cSpellHitStatName = "Spell Chance to Hit"
Outfitter.cSpellDmgStatName = "Spell Damage"
Outfitter.cSpellHasteStatName = "Spell Haste"
Outfitter.cFrostDmgStatName = "Frost Spell Damage"
Outfitter.cFireDmgStatName = "Fire Spell Damage"
Outfitter.cArcaneDmgStatName = "Arcane Spell Damage"
Outfitter.cShadowDmgStatName = "Shadow Spell Damage"
Outfitter.cNatureDmgStatName = "Nature Spell Damage"
Outfitter.cHealingStatName = "Healing"

Outfitter.cMeleeCritStatName = "Melee Critical Strike"
Outfitter.cMeleeHitStatName = "Melee Chance to Hit"
Outfitter.cMeleeHasteStatName = "Melee Haste Rating"
Outfitter.cMeleeDmgStatName = "Melee Damage"
Outfitter.cAttackStatName = "Attack Power"
Outfitter.cRangedAttackStatName = "Ranged Attack Power"
Outfitter.cDodgeStatName = "Dodge"
Outfitter.cParryStatName = "Parry"
Outfitter.cBlockStatName = "Block"
Outfitter.cResilienceStatName = "Resilience"

Outfitter.cArcaneResistStatName = "Arcane Resistance"
Outfitter.cFireResistStatName = "Fire Resistance"
Outfitter.cFrostResistStatName = "Frost Resistance"
Outfitter.cNatureResistStatName = "Nature Resistance"
Outfitter.cShadowResistStatName = "Shadow Resistance"

Outfitter.cFishingStatName = "Fishing"
Outfitter.cHerbalismStatName = "Herbalism"
Outfitter.cMiningStatName = "Mining"
Outfitter.cSkinningStatName = "Skinning"

Outfitter.cOptionsTitle = "Outfitter Options"
Outfitter.cShowMinimapButton = "Show Minimap Button"
Outfitter.cShowMinimapButtonOnDescription = "Turn this off if you don't want the Outfitter button on your minimap cluster"
Outfitter.cShowMinimapButtonOffDescription = "Turn this on if you want the Outfitter button on your minimap cluster"
Outfitter.cAutoSwitch = "Disable automatic changes"
Outfitter.cAutoSwitchOnDescription = "Turn this on to disable automatic outfit switching"
Outfitter.cAutoSwitchOffDescription = "Turn this off to enable automatic outfit switching"
Outfitter.cTooltipInfo = "Show 'Used by:' in tooltips"
Outfitter.cTooltipInfoOnDescription = "Turn this off if you experience performance problems when mousing over equippable items"
Outfitter.cTooltipInfoOffDescription = "Turn this on if you want to display 'Used By:' information in Tooltip"
Outfitter.cRememberVisibility = "Helm and Cloak settings"
Outfitter.cRememberVisibilityOnDescription = "Turn this off if you want to use a single show/hide setting for all cloaks and helms"
Outfitter.cRememberVisibilityOffDescription = "Turn this on if you want Outfitter to remember your preference for showing or hiding each cloak and helm individually"
Outfitter.cShowHotkeyMessages = "Show outfit change messages"
Outfitter.cShowHotkeyMessagesOnDescription = "Turn this off if you don't want to see a message when you change outfits using a key binding"
Outfitter.cShowHotkeyMessagesOffDescription = "Turn this on if you want to see a message when you change outfits using a key binding"
Outfitter.cShowOutfitBar = "Show outfit bar"
Outfitter.cShowOutfitBarDescription = "Shows a bar of icon buttons you can click to change outfits"
Outfitter.cEquipOutfitMessageFormat = "Outfitter: %s equipped"
Outfitter.cUnequipOutfitMessageFormat = "Outfitter: %s unequipped"

Outfitter.cAboutTitle = "About Outfitter"
Outfitter.cAuthor = "Designed and written by John Stephen and Bruce Quinton with contributions by %s"
Outfitter.cTestersTitle = "Outfitter 4.1 testers"
Outfitter.cTestersNames = "%s"
Outfitter.cSpecialThanksTitle = "Special thanks to"
Outfitter.cSpecialThanksNames = "%s"
Outfitter.cTranslationCredit = "Translations by %s"
Outfitter.cURL = "wobbleworks.com"

Outfitter.cOpenOutfitter = "Open Outfitter"

Outfitter.cKeyBinding = "Key Binding"

BINDING_HEADER_OUTFITTER_TITLE = Outfitter.cTitle
BINDING_NAME_OUTFITTER_OUTFIT = "Open Outfitter"

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

Outfitter.cShow = "Show"
Outfitter.cHide = "Hide"
Outfitter.cDontChange = "Don't change"

Outfitter.cHelm = "Helm"
Outfitter.cCloak = "Cloak"

Outfitter.cAutomation = "Automation"

Outfitter.cDisableOutfit = "Disable"
Outfitter.cDisableAlways = "Always"
Outfitter.cDisableOutfitInBG = "In Battlegrounds"
Outfitter.cDisableOutfitInCombat = "Disable while in combat"
Outfitter.cDisableOutfitInAQ40 = "In Temple of Ahn'Qiraj"
Outfitter.cDisableOutfitInNaxx = "In Naxxramas"
Outfitter.cDisabledOutfitName = "%s (Disabled)"

Outfitter.cOutfitBar = "Outfit Bar"
Outfitter.cShowInOutfitBar = "Show in outfit bar"
Outfitter.cChangeIcon = "Choose icon..."

Outfitter.cMinimapButtonTitle = "Outfitter Minimap Button"
Outfitter.cMinimapButtonDescription = "Click to select a different outfit or drag to re-position this button."

Outfitter.cClassName = {}
Outfitter.cClassName.DRUID = "Druid"
Outfitter.cClassName.HUNTER = "Hunter"
Outfitter.cClassName.MAGE = "Mage"
Outfitter.cClassName.PALADIN = "Paladin"
Outfitter.cClassName.PRIEST = "Priest"
Outfitter.cClassName.ROGUE = "Rogue"
Outfitter.cClassName.SHAMAN = "Shaman"
Outfitter.cClassName.WARLOCK = "Warlock"
Outfitter.cClassName.WARRIOR = "Warrior"

Outfitter.cBattleStance = "Battle Stance"
Outfitter.cDefensiveStance = "Defensive Stance"
Outfitter.cBerserkerStance = "Berserker Stance"

Outfitter.cWarriorBattleStance = "Warrior: Battle Stance"
Outfitter.cWarriorDefensiveStance = "Warrior: Defensive Stance"
Outfitter.cWarriorBerserkerStance = "Warrior: Berserker Stance"

Outfitter.cBearForm = "Bear Form"
Outfitter.cFlightForm = "Flight Form"
Outfitter.cSwiftFlightForm = "Swift Flight Form"
Outfitter.cCatForm = "Cat Form"
Outfitter.cAquaticForm = "Aquatic Form"
Outfitter.cTravelForm = "Travel Form"
Outfitter.cDireBearForm = "Dire Bear Form"
Outfitter.cMoonkinForm = "Moonkin Form"
Outfitter.cTreeOfLifeForm = "Tree of Life"

Outfitter.cGhostWolfForm = "Ghost Wolf"

Outfitter.cStealth = "Stealth"

Outfitter.cDruidCasterForm = "Druid: Caster Form"
Outfitter.cDruidBearForm = "Druid: Bear Form"
Outfitter.cDruidCatForm = "Druid: Cat Form"
Outfitter.cDruidAquaticForm = "Druid: Aquatic Form"
Outfitter.cDruidTravelForm = "Druid: Travel Form"
Outfitter.cDruidMoonkinForm = "Druid: Moonkin Form"
Outfitter.cDruidFlightForm = "Druid: Flight Form"
Outfitter.cDruidSwiftFlightForm = "Druid: Swift Flight Form"
Outfitter.cDruidTreeOfLifeForm = "Druid: Tree of Life"
Outfitter.cDruidProwl = "Druid: Prowl"
Outfitter.cProwl = "Prowl"

Outfitter.cPriestShadowform = "Priest: Shadowform"

Outfitter.cRogueStealth = "Rogue: Stealth"
Outfitter.cLockpickingOutfit = "Rogue: Lockpicking"

Outfitter.cShamanGhostWolf = "Shaman: Ghost Wolf"

Outfitter.cHunterMonkey = "Hunter: Monkey"
Outfitter.cHunterHawk =  "Hunter: Hawk"
Outfitter.cHunterCheetah =  "Hunter: Cheetah"
Outfitter.cHunterPack =  "Hunter: Pack"
Outfitter.cHunterBeast =  "Hunter: Beast"
Outfitter.cHunterWild =  "Hunter: Wild"
Outfitter.cHunterViper = "Hunter: Viper"
Outfitter.cHunterFeignDeath = "Hunter: Feign Death"

Outfitter.cMageEvocate = "Mage: Evocate"

Outfitter.cAspectOfTheCheetah = "Aspect of the Cheetah"
Outfitter.cAspectOfThePack = "Aspect of the Pack"
Outfitter.cAspectOfTheBeast = "Aspect of the Beast"
Outfitter.cAspectOfTheWild = "Aspect of the Wild"
Outfitter.cAspectOfTheViper = "Aspect of the Viper"
Outfitter.cEvocate = "Evocation"

Outfitter.cCompleteCategoryDescription = "Complete outfits have all slots specified.  When these outfits are equipped all other outfits will automatically be unequipped."
Outfitter.cAccessoryCategoryDescription = "Accessory outfits have some, but not all, slots specified.  You can equip as many accessory outfits at a time as you like."
Outfitter.cOddsNEndsCategoryDescription = "Odds 'n ends is a list of items which you haven't used in any of your outfits.  This may be useful in ensuring that you're using all of your items or that you're not carrying around excess baggage."

Outfitter.cRebuildOutfitFormat = "Rebuild for %s"

Outfitter.cSlotEnableTitle = "Slot Enable"
Outfitter.cSlotEnableDescription = "Select this if you want the item in this slot to be equipped when changing to the selected outfit.  If not selected then this slot will not be modified when changing to the selected outfit."

Outfitter.cFinger0SlotName = "First Finger"
Outfitter.cFinger1SlotName = "Second Finger"

Outfitter.cTrinket0SlotName = "First Trinket"
Outfitter.cTrinket1SlotName = "Second Trinket"

Outfitter.cOutfitCategoryTitle = "Category"
Outfitter.cBankCategoryTitle = "Bank"
Outfitter.cDepositToBank = "Deposit all items to bank"
Outfitter.cDepositUniqueToBank = "Deposit unique items to bank"
Outfitter.cWithdrawFromBank = "Withdraw items from bank"

Outfitter.cMissingItemsLabel = "Missing items: "
Outfitter.cBankedItemsLabel = "Banked items: "

Outfitter.cStatsCategory = "Stats"
Outfitter.cMeleeCategory = "Melee"
Outfitter.cSpellsCategory = "Healing and Spells"
Outfitter.cRegenCategory = "Regeneration"
Outfitter.cResistCategory = "Resistances"
Outfitter.cTradeCategory = "Skills"

Outfitter.cTankPoints = "TankPoints"
Outfitter.cCustom = "Custom"

Outfitter.cScriptFormat = "Script (%s)"
Outfitter.cScriptSettings = "Settings..."
Outfitter.cNoScript = "None"
Outfitter.cDisableScript = "Disable"
Outfitter.cDisableIn = "Disable more"
Outfitter.cEditScriptTitle = "Script for %s outfit"
Outfitter.cEditScriptEllide = "Custom..."
Outfitter.cEventsLabel = "Events:"
Outfitter.cScriptLabel = "Script:"
Outfitter.cSetCurrentItems = "Update to current items"
Outfitter.cConfirmSetCurrentMsg = "Are you sure you want to update %s to use the currently equipped items? Note: Only slots currently enabled in the outfit will be updated -- you can turn on additional slots afterwards"
Outfitter.cSetCurrent = "Update"
Outfitter.cTyping = "Typing..."
Outfitter.cScriptErrorFormat = "Error at line %d: %s"
Outfitter.cExtractErrorFormat = "%[string \"Outfit Script\"%]:(%d+):(.*)"
Outfitter.cPresetScript = "Preset script:"
Outfitter.cCustomScript = "Custom"
Outfitter.cSettings = "Settings"
Outfitter.cSource = "Source"
Outfitter.cInsertFormat = "<- %s"

Outfitter.cContainerBagSubType = "Bag"
Outfitter.cUsedByPrefix = "Used by outfits: "

Outfitter.cNone = "None"
Outfitter.cTooltipMultibuffSeparator1 = " and "
Outfitter.cTooltipMultibuffSeparator2 = " / "
Outfitter.cNoScriptSettings = "There are no settings for this script."
Outfitter.cMissingItemsSeparator = ", "
Outfitter.cUnequipOthers = "On equip, unequip other Accessory outfits"

Outfitter.cConfirmResetMsg = "Are you sure you want to reset Outfitter on this character?  All outfits will be deleted and the default outfits re-created."
Outfitter.cReset = "Reset"

Outfitter.cIconFilterLabel = "Search:"
Outfitter.cIconSetLabel = "Icons:"

Outfitter.cCantReloadUI = "You must completely restart WoW to upgrade to this version of Outfitter"
Outfitter.cChooseIconTitle = "Choose an icon for the %s outfit"
Outfitter.cOutfitterDecides = "Outfitter will choose an icon for you"

Outfitter.cSuggestedIcons = "Suggested icons"
Outfitter.cSpellbookIcons = "Your Spellbook"
Outfitter.cYourItemIcons = "Your bags"
Outfitter.cEveryIcon = "All icons"
Outfitter.cItemIcons = "All icons (items only)"
Outfitter.cAbilityIcons = "All icons (spells only)"

Outfitter.cRequiresLockpicking = "Requires Lockpicking"
Outfitter.cUseDurationTooltipLineFormat = "^Use:.*for (%d+) sec"
Outfitter.cUseDurationTooltipLineFormat2 = "^Use:.*Lasts (%d+) sec"

Outfitter.cOutfitBarSizeLabel = "Size"
Outfitter.cOutfitBarSmallSizeLabel = "Small"
Outfitter.cOutfitBarLargeSizeLabel = "Large"
Outfitter.cOutfitBarAlphaLabel = "Alpha"
Outfitter.cOutfitBarCombatAlphaLabel = "Combat Alpha"
Outfitter.cOutfitBarVerticalLabel = "Vertical"
Outfitter.cOutfitBarLockPositionLabel = "Lock Position"
Outfitter.cOutfitBarHideBackgroundLabel = "Hide Background"

Outfitter.cPositionLockedError = "The outfit bar can't be moved because you've locked its position"

Outfitter.cMustBeAtBankError = "You must have your bank open to generate a missing items report"
Outfitter.cMissingItemReportIntro = "Missing items (note that a missing item will be listed multiple times if it was used by multiple outfits):"
Outfitter.cNoMissingItems = "No items are missing"

Outfitter.cAutoChangesDisabled = "Automated changes are now disabled"
Outfitter.cAutoChangesEnabled = "Automated changes are now enabled"
