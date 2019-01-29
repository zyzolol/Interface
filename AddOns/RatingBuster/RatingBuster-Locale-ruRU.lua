--[[
Name: RatingBuster ruRU locale
Revision: $Revision: 148 $
Translated by: 
- Orsana
]]

local L = AceLibrary("AceLocale-2.2"):new("RatingBuster")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "Показывать ID",
L:RegisterTranslations("ruRU", function() return {
	---------------
	-- Waterfall --
	---------------
	["RatingBuster Options"] = "Окно настроек",
	["Waterfall-1.0 is required to access the GUI."] = "Требуется Waterfall чтобы открыть настройки",
	---------------------------
	-- Slash Command Options --
	---------------------------
	-- /rb win
	["Options Window"] = "Окно настроек",
	["Shows the Options Window"] = "Показать окно настроек",
	-- /rb statmod
	["Enable Stat Mods"] = "Включить Stat Mods",
	["Enable support for Stat Mods"] = "Включает поддержку Stat Mods",
	-- /rb itemid
	["Show ItemID"] = "Показывать ID предметов",
	["Show the ItemID in tooltips"] = "Показывать ID предметов в подсказке",
	-- /rb itemlevel
	["Show ItemLevel"] = "Показывать уровень предмета",
	["Show the ItemLevel in tooltips"] = "Показывать уровень предмета в подсказке",
	-- /rb usereqlv
	["Use required level"] = "Использовать необходимый уровень",
	["Calculate using the required level if you are below the required level"] = "Рассчитывать статы исходя из минимально необходимого для надевания предмета уровня, если вы ниже этого уровня",
	-- /rb setlevel
	["Set level"] = "Задать уровень",
	["Set the level used in calculations (0 = your level)"] = "Задать уровень используемый в расчетах (0 - ваш уровень)",
	-- /rb color
	["Change text color"] = "Изменить цвет текста",
	["Changes the color of added text"] = "Изменить цвет добавляемого текста",
	-- /rb color pick
	["Pick color"] = "Выбрать цвет",
	["Pick a color"] = "Выбрать цвет",
	-- /rb color enable
	["Enable color"] = "Включить цвет текста",
	["Enable colored text"] = "Включить цвет текста",
	-- /rb rating
	["Rating"] = "Рейтинги",
	["Options for Rating display"] = "Настройки отображения рейтингов",
	-- /rb rating show
	["Show Rating conversions"] = "Показывать конвертацию рейтингов",
	["Show Rating conversions in tooltips"] = "Показывать конвертацию рейтингов в подсказке",
	-- /rb rating detail
	["Show detailed conversions text"] = "Показывать детальную конвертацию рейтингов",
	["Show detailed text for Resiliance and Expertise conversions"] = "Показывать детальную конвертацию рейтингов мастерства и устойчивости",
	-- /rb rating def
	["Defense breakdown"] = "Разбивать дефенс рейтинг",
	["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "Разбивать дефенс рейтинг на минус крит, минус хит, уклонение, парировани и блокирование",
	-- /rb rating wpn
	["Weapon Skill breakdown"] = "Разбивать уровень владения оружием",
	["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Разбивать уровень владения оружием",
	-- /rb rating exp -- 2.3.0
	["Expertise breakdown"] = "Разбивать уровень мастерства",
	["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Разбивать уровень мастерства на минус уклонение и минус парирование",
	
	-- /rb stat
	["Stat Breakdown"] = "Настройки статов",
	["Changes the display of base stats"] = "Показывать изменения базовых статов",
	-- /rb stat show
	["Show base stat conversions"] = "Show base stat conversions",
	["Show base stat conversions in tooltips"] = "Show base stat conversions",
	-- /rb stat str
	["Strength"] = "Сила",
	["Changes the display of Strength"] = "Показывать изменение силы",
	-- /rb stat str ap
	["Show Attack Power"] = "Показывать изменение АП",
	["Show Attack Power from Strength"] = "Показывать изменение АП от силы",
	-- /rb stat str block
	["Show Block Value"] = "Показывать изменение блокирования",
	["Show Block Value from Strength"] = "Показывать изменение блокирования силы",
	-- /rb stat str dmg
	["Show Spell Damage"] = "Показывать изменение спел дамага",
	["Show Spell Damage from Strength"] = "Показывать изменение спел дамага от силы",
	-- /rb stat str heal
	["Show Healing"] = "Показывать изменения хилинга",
	["Show Healing from Strength"] = "Показывать изменение хилинга от силы",
	
	-- /rb stat agi
	["Agility"] = "Ловкость",
	["Changes the display of Agility"] = "Показывать изменения ловкости",
	-- /rb stat agi crit
	["Show Crit"] = "Показывать изменение крита",
	["Show Crit chance from Agility"] = "Показывать изменение крита от ловкости ",
	-- /rb stat agi dodge
	["Show Dodge"] = "Показывать изменение уклонения",
	["Show Dodge chance from Agility"] = "Показывать изменение уклонения от ловкости",
	-- /rb stat agi ap
	["Show Attack Power"] = "Показывать изменение АП",
	["Show Attack Power from Agility"] = "Показывать изменение АП от ловкости",
	-- /rb stat agi rap
	["Show Ranged Attack Power"] = "Показывать изменение РАП",
	["Show Ranged Attack Power from Agility"] = "Показывать изменение РАП от ловкости",
	-- /rb stat agi armor
	["Show Armor"] = "Показывать изменение армора",
	["Show Armor from Agility"] = "Показывать изменение армора от ловкости",
	-- /rb stat agi heal
	["Show Healing"] = "Показывать изменение хиллинга",
	["Show Healing from Agility"] = "Показывать изменение хиллинга от ловкости",
	
	-- /rb stat sta
	["Stamina"] = "Выносливость",
	["Changes the display of Stamina"] = "Показывать изменение выносливости",
	-- /rb stat sta hp
	["Show Health"] = "Показывать изменение хитов",
	["Show Health from Stamina"] = "Показывать изменение хитов от стамины",
	-- /rb stat sta dmg
	["Show Spell Damage"] = "Показывать изменение спелдамага",
	["Show Spell Damage from Stamina"] = "Показывать изменение спалдамага от стамины",
	
	-- /rb stat int
	["Intellect"] = "Интеллект",
	["Changes the display of Intellect"] = "Показывать изменение интеллекта",
	-- /rb stat int spellcrit
	["Show Spell Crit"] = "Показывать изменение спелкрита",
	["Show Spell Crit chance from Intellect"] = "Показывать изменение спелкрита от интеллекта",
	-- /rb stat int mp
	["Show Mana"] = "Показывать изменение маны",
	["Show Mana from Intellect"] = "Показывать изменение маны от интеллекта",
	-- /rb stat int dmg
	["Show Spell Damage"] = "Показывать изменение спелдамага",
	["Show Spell Damage from Intellect"] = "Показывать изменение спелдамага от интеллекта",
	-- /rb stat int heal
	["Show Healing"] = "Показывать изменение хилинга",
	["Show Healing from Intellect"] = "Показывать изменение хилинга от интеллекта",
	-- /rb stat int mp5
	["Show Mana Regen"] = "Показывать изменение манарегена",
	["Show Mana Regen while casting from Intellect"] = "Показывать изменение манарегена от интеллекта",
	-- /rb stat int mp5nc
	["Show Mana Regen while NOT casting"] = "Показывать изменение манарегена(вне каста)",
	["Show Mana Regen while NOT casting from Intellect"] = "Показывать изменение манарегена (вне каста)",
	-- /rb stat int rap
	["Show Ranged Attack Power"] = "Показывать изменение АП",
	["Show Ranged Attack Power from Intellect"] = "Показывать изменение АП от интеллекта",
	-- /rb stat int armor
	["Show Armor"] = "Показывать изменение армора",
	["Show Armor from Intellect"] = "Показывать изменение армора от интеллекта",
	
	-- /rb stat spi
	["Spirit"] = "Дух",
	["Changes the display of Spirit"] = "Показывать изменение духа",
	-- /rb stat spi mp5
	["Show Mana Regen"] = "Показывать изменение манарегена",
	["Show Mana Regen while casting from Spirit"] = "Показывать изменение манарегена от духа",
	-- /rb stat spi mp5nc
	["Show Mana Regen while NOT casting"] = "Показывать изменение манарегена (вне каста)",
	["Show Mana Regen while NOT casting from Spirit"] = "Показывать изменение манарегена (вне каста)",
	-- /rb stat spi hp5
	["Show Health Regen"] = "Показывать изменение восстановления хитов",
	["Show Health Regen from Spirit"] = "Показывать изменение восстановления хитов",
	-- /rb stat spi dmg
	["Show Spell Damage"] = "Показывать изменение спелдамага",
	["Show Spell Damage from Spirit"] = "Показывать изменение спелдамага от спирита",
	-- /rb stat spi heal
	["Show Healing"] = "Показывать изменение хилинга",
	["Show Healing from Spirit"] = "Показывать изменение хилинга от спирита",
	
	-- /rb sum
	["Stat Summary"] = "Настройки итогов",
	["Options for stat summary"] = "Итоги по статам",
	-- /rb sum show
	["Show stat summary"] = "Показывать суммарные изменения",
	["Show stat summary in tooltips"] = "Показывать суммарные изменения",
	-- /rb sum ignore
	["Ignore settings"] = "Ignore settings",
	["Ignore stuff when calculating the stat summary"] = "Ignore stuff when calculating the stat summary",
	-- /rb sum ignore unused
	["Ignore unused items types"] = "Ignore unused items types",
	["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Show stat summary only for highest level armor type and items you can use with uncommon quality and up",
	-- /rb sum ignore equipped
	["Ignore equipped items"] = "Не показывать для надетых вещей",
	["Hide stat summary for equipped items"] = "Не показывать для надетых вещей",
	-- /rb sum ignore enchant
	["Ignore enchants"] = "Игнорировать энчанты",
	["Ignore enchants on items when calculating the stat summary"] = "Игнорировать энчанты при расчете итога",
	-- /rb sum ignore gem
	["Ignore gems"] = "Игнорировать камни",
	["Ignore gems on items when calculating the stat summary"] = "Игнорировать камни при расчете итога",
	-- /rb sum diffstyle
	["Display style for diff value"] = "Display style for diff value",
	["Display diff values in the main tooltip or only in compare tooltips"] = "Display diff values in the main tooltip or only in compare tooltips",
	-- /rb sum space
	["Add empty line"] = "Добавить пустую линию",
	["Add a empty line before or after stat summary"] = "Добавить пустую линию",
	-- /rb sum space before
	["Add before summary"] = "Добавить линию до итога",
	["Add a empty line before stat summary"] = "Добавить линию до итога",
	-- /rb sum space after
	["Add after summary"] = "Добавить линию после итога",
	["Add a empty line after stat summary"] = "Добавить линию после итога",
	-- /rb sum icon
	["Show icon"] = "Добавить иконку",
	["Show the sigma icon before summary listing"] = "Добавит иконку",
	-- /rb sum title
	["Show title text"] = "Показывать заголовок",
	["Show the title text before summary listing"] = "Показывать заголовок",
	-- /rb sum showzerostat
	["Show zero value stats"] = "Показывать нулевые статы",
	["Show zero value stats in summary for consistancy"] = "Показывать нулевые статы",
	-- /rb sum calcsum
	["Calculate stat sum"] = "Calculate stat sum",
	["Calculate the total stats for the item"] = "Calculate the total stats for the item",
	-- /rb sum calcdiff
	["Calculate stat diff"] = "Рассчитывать разницу в статах",
	["Calculate the stat difference for the item and equipped items"] = "Рассчитывать разницу в статах с надетой вещью",
	-- /rb sum sort
	["Sort StatSummary alphabetically"] = "Сортировать статы в алфавитном порядке",
	["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "Если включено - то по алфавиту, если выключено, то по смыслу (базовые, заклинания, танковые)",
	-- /rb sum avoidhasblock
	["Include block chance in Avoidance summary"] = "Include block chance in Avoidance summary",
	["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss",
	-- /rb sum basic
	["Stat - Basic"] = "Stat - Basic",
	["Choose basic stats for summary"] = "Choose basic stats for summary",
	-- /rb sum physical
	["Stat - Physical"] = "Stat - Physical",
	["Choose physical damage stats for summary"] = "Choose physical damage stats for summary",
	-- /rb sum spell
	["Stat - Spell"] = "Stat - Spell",
	["Choose spell damage and healing stats for summary"] = "Choose spell damage and healing stats for summary",
	-- /rb sum tank
	["Stat - Tank"] = "Stat - Tank",
	["Choose tank stats for summary"] = "Choose tank stats for summary",
	-- /rb sum stat hp
	["Sum Health"] = "Sum Health",
	["Health <- Health, Stamina"] = "Health <- Health, Stamina",
	-- /rb sum stat mp
	["Sum Mana"] = "Sum Mana",
	["Mana <- Mana, Intellect"] = "Mana <- Mana, Intellect",
	-- /rb sum stat ap
	["Sum Attack Power"] = "Sum Attack Power",
	["Attack Power <- Attack Power, Strength, Agility"] = "Attack Power <- Attack Power, Strength, Agility",
	-- /rb sum stat rap
	["Sum Ranged Attack Power"] = "Sum Ranged Attack Power",
	["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility",
	-- /rb sum stat fap
	["Sum Feral Attack Power"] = "Sum Feral Attack Power",
	["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility",
	-- /rb sum stat dmg
	["Sum Spell Damage"] = "Sum Spell Damage",
	["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Spell Damage <- Spell Damage, Intellect, Spirit, Stamina",
	-- /rb sum stat dmgholy
	["Sum Holy Spell Damage"] = "Sum Holy Spell Damage",
	["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit",
	-- /rb sum stat dmgarcane
	["Sum Arcane Spell Damage"] = "Sum Arcane Spell Damage",
	["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect",
	-- /rb sum stat dmgfire
	["Sum Fire Spell Damage"] = "Sum Fire Spell Damage",
	["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina",
	-- /rb sum stat dmgnature
	["Sum Nature Spell Damage"] = "Sum Nature Spell Damage",
	["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect",
	-- /rb sum stat dmgfrost
	["Sum Frost Spell Damage"] = "Sum Frost Spell Damage",
	["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect",
	-- /rb sum stat dmgshadow
	["Sum Shadow Spell Damage"] = "Sum Shadow Spell Damage",
	["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina",
	-- /rb sum stat heal
	["Sum Healing"] = "Sum Healing",
	["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Healing <- Healing, Intellect, Spirit, Agility, Strength",
	-- /rb sum stat hit
	["Sum Hit Chance"] = "Sum Hit Chance",
	["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Hit Chance <- Hit Rating, Weapon Skill Rating",
	-- /rb sum stat crit
	["Sum Crit Chance"] = "Sum Crit Chance",
	["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "Crit Chance <- Crit Rating, Agility, Weapon Skill Rating",
	-- /rb sum stat haste
	["Sum Haste"] = "Sum Haste",
	["Haste <- Haste Rating"] = "Haste <- Haste Rating",
	-- /rb sum stat critspell
	["Sum Spell Crit Chance"] = "Sum Spell Crit Chance",
	["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "Spell Crit Chance <- Spell Crit Rating, Intellect",
	-- /rb sum stat hitspell
	["Sum Spell Hit Chance"] = "Sum Spell Hit Chance",
	["Spell Hit Chance <- Spell Hit Rating"] = "Spell Hit Chance <- Spell Hit Rating",
	-- /rb sum stat hastespell
	["Sum Spell Haste"] = "Sum Spell Haste",
	["Spell Haste <- Spell Haste Rating"] = "Spell Haste <- Spell Haste Rating",
	-- /rb sum stat mp5
	["Sum Mana Regen"] = "Sum Mana Regen",
	["Mana Regen <- Mana Regen, Spirit"] = "Mana Regen <- Mana Regen, Spirit",
	-- /rb sum stat mp5nc
	["Sum Mana Regen while not casting"] = "Sum Mana Regen while not casting",
	["Mana Regen while not casting <- Spirit"] = "Mana Regen while not casting <- Spirit",
	-- /rb sum stat hp5
	["Sum Health Regen"] = "Sum Health Regen",
	["Health Regen <- Health Regen"] = "Health Regen <- Health Regen",
	-- /rb sum stat hp5oc
	["Sum Health Regen when out of combat"] = "Sum Health Regen when out of combat",
	["Health Regen when out of combat <- Spirit"] ="Health Regen when out of combat <- Spirit",
	-- /rb sum stat armor
	["Sum Armor"] = "Sum Armor",
	["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "Armor <- Armor from items, Armor from bonuses, Agility, Intellect",
	-- /rb sum stat blockvalue
	["Sum Block Value"] = "Sum Block Value",
	["Block Value <- Block Value, Strength"] = "Block Value <- Block Value, Strength",
	-- /rb sum stat dodge
	["Sum Dodge Chance"] = "Sum Dodge Chance",
	["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "Dodge Chance <- Dodge Rating, Agility, Defense Rating",
	-- /rb sum stat parry
	["Sum Parry Chance"] = "Sum Parry Chance",
	["Parry Chance <- Parry Rating, Defense Rating"] = "Parry Chance <- Parry Rating, Defense Rating",
	-- /rb sum stat block
	["Sum Block Chance"] = "Sum Block Chance",
	["Block Chance <- Block Rating, Defense Rating"] = "Block Chance <- Block Rating, Defense Rating",
	-- /rb sum stat avoidhit
	["Sum Hit Avoidance"] = "Sum Hit Avoidance",
	["Hit Avoidance <- Defense Rating"] = "Hit Avoidance <- Defense Rating",
	-- /rb sum stat avoidcrit
	["Sum Crit Avoidance"] = "Sum Crit Avoidance",
	["Crit Avoidance <- Defense Rating, Resilience"] = "Crit Avoidance <- Defense Rating, Resilience",
	-- /rb sum stat neglectdodge
	["Sum Dodge Neglect"] = "Sum Dodge Neglect",
	["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "Dodge Neglect <- Expertise, Weapon Skill Rating", -- 2.3.0
	-- /rb sum stat neglectparry
	["Sum Parry Neglect"] = "Sum Parry Neglect",
	["Parry Neglect <- Expertise, Weapon Skill Rating"] = "Parry Neglect <- Expertise, Weapon Skill Rating", -- 2.3.0
	-- /rb sum stat neglectblock
	["Sum Block Neglect"] = "Sum Block Neglect",
	["Block Neglect <- Weapon Skill Rating"] = "Block Neglect <- Weapon Skill Rating",
	-- /rb sum stat resarcane
	["Sum Arcane Resistance"] = "Sum Arcane Resistance",
	["Arcane Resistance Summary"] = "Arcane Resistance Summary",
	-- /rb sum stat resfire
	["Sum Fire Resistance"] = "Sum Fire Resistance",
	["Fire Resistance Summary"] = "Fire Resistance Summary",
	-- /rb sum stat resnature
	["Sum Nature Resistance"] = "Sum Nature Resistance",
	["Nature Resistance Summary"] = "Nature Resistance Summary",
	-- /rb sum stat resfrost
	["Sum Frost Resistance"] = "Sum Frost Resistance",
	["Frost Resistance Summary"] = "Frost Resistance Summary",
	-- /rb sum stat resshadow
	["Sum Shadow Resistance"] = "Sum Shadow Resistance",
	["Shadow Resistance Summary"] = "Shadow Resistance Summary",
	-- /rb sum stat maxdamage
	["Sum Weapon Max Damage"] = "Sum Weapon Max Damage",
	["Weapon Max Damage Summary"] = "Weapon Max Damage Summary",
	-- /rb sum stat pen
	["Sum Penetration"] = "Sum Penetration",
	["Spell Penetration Summary"] = "Spell Penetration Summary",
	-- /rb sum stat ignorearmor
	["Sum Ignore Armor"] = "Sum Ignore Armor",
	["Ignore Armor Summary"] = "Ignore Armor Summary",
	-- /rb sum stat weapondps
	--["Sum Weapon DPS"] = "1 ",
	--["Weapon DPS Summary"] = "1 ",
	-- /rb sum statcomp str
	["Sum Strength"] = "Sum Strength",
	["Strength Summary"] = "Strength Summary",
	-- /rb sum statcomp agi
	["Sum Agility"] = "Sum Agility",
	["Agility Summary"] = "Agility Summary",
	-- /rb sum statcomp sta
	["Sum Stamina"] = "Sum Stamina",
	["Stamina Summary"] = "Stamina Summary",
	-- /rb sum statcomp int
	["Sum Intellect"] = "Sum Intellect",
	["Intellect Summary"] = "Intellect Summary",
	-- /rb sum statcomp spi
	["Sum Spirit"] = "Sum Spirit",
	["Spirit Summary"] = "Spirit Summary",
	-- /rb sum statcomp hitrating
	["Sum Hit Rating"] = "Sum Hit Rating",
	["Hit Rating Summary"] = "Hit Rating Summary",
	-- /rb sum statcomp critrating
	["Sum Crit Rating"] = "Sum Crit Rating",
	["Crit Rating Summary"] = "Crit Rating Summary",
	-- /rb sum statcomp hasterating
	["Sum Haste Rating"] = "Sum Haste Rating",
	["Haste Rating Summary"] = "Haste Rating Summary",
	-- /rb sum statcomp hitspellrating
	["Sum Spell Hit Rating"] = "Sum Spell Hit Rating",
	["Spell Hit Rating Summary"] = "Spell Hit Rating Summary",
	-- /rb sum statcomp critspellrating
	["Sum Spell Crit Rating"] = "Sum Spell Crit Rating",
	["Spell Crit Rating Summary"] = "Spell Crit Rating Summary",
	-- /rb sum statcomp hastespellrating
	["Sum Spell Haste Rating"] = "Sum Spell Haste Rating",
	["Spell Haste Rating Summary"] = "Spell Haste Rating Summary",
	-- /rb sum statcomp dodgerating
	["Sum Dodge Rating"] = "Sum Dodge Rating",
	["Dodge Rating Summary"] = "Dodge Rating Summary",
	-- /rb sum statcomp parryrating
	["Sum Parry Rating"] = "Sum Parry Rating",
	["Parry Rating Summary"] = "Parry Rating Summary",
	-- /rb sum statcomp blockrating
	["Sum Block Rating"] = "Sum Block Rating",
	["Block Rating Summary"] = "Block Rating Summary",
	-- /rb sum statcomp res
	["Sum Resilience"] = "Sum Resilience",
	["Resilience Summary"] = "Resilience Summary",
	-- /rb sum statcomp def
	["Sum Defense"] = "Sum Defense",
	["Defense <- Defense Rating"] = "Defense <- Defense Rating",
	-- /rb sum statcomp wpn
	["Sum Weapon Skill"] = "Sum Weapon Skill",
	["Weapon Skill <- Weapon Skill Rating"] = "Weapon Skill <- Weapon Skill Rating",
	-- /rb sum statcomp exp -- 2.3.0
	["Sum Expertise"] = "Sum Expertise",
	["Expertise <- Expertise Rating"] = "Expertise <- Expertise Rating",
	-- /rb sum statcomp tp
	["Sum TankPoints"] = "Sum TankPoints",
	["TankPoints <- Health, Total Reduction"] = "TankPoints <- Health, Total Reduction",
	-- /rb sum statcomp tr
	["Sum Total Reduction"] = "Sum Total Reduction",
	["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods",
	-- /rb sum statcomp avoid
	["Sum Avoidance"] = "Sum Avoidance",
	["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "Avoidance <- Dodge, Parry, MobMiss, Block(Optional)",
	-- /rb sum gem
	["Gems"] = "Gems",
	["Auto fill empty gem slots"] = "Auto fill empty gem slots",
	-- /rb sum gem red
	["Red Socket"] = EMPTY_SOCKET_RED,
	["ItemID or Link of the gem you would like to auto fill"] = "ItemID or Link of the gem you would like to auto fill",
	["<ItemID|Link>"] = "<ItemID|Link>",
	["%s is now set to %s"] = "%s is now set to %s",
	["Queried server for Gem: %s. Try again in 5 secs."] = "Queried server for Gem: %s. Try again in 5 secs.",
	-- /rb sum gem yellow
	["Yellow Socket"] = EMPTY_SOCKET_YELLOW,
	-- /rb sum gem blue
	["Blue Socket"] = EMPTY_SOCKET_BLUE,
	-- /rb sum gem meta
	["Meta Socket"] = EMPTY_SOCKET_META,

	-----------------------
	-- Item Level and ID --
	-----------------------
	["ItemLevel: "] = "Уровень предмета: ",
	["ItemID: "] = "ID предмета: ",
	-----------------------
	-- Matching Patterns --
	-----------------------
	-- Items to check --
	--------------------
	-- [Potent Ornate Topaz]
	-- +6 Spell Damage, +5 Spell Crit Rating
	--------------------
	-- ZG enchant
	-- +10 Defense Rating/+10 Stamina/+15 Block Value
	--------------------
	-- [Glinting Flam Spessarite]
	-- +3 Hit Rating and +3 Agility
	--------------------
	-- ItemID: 22589
	-- [Atiesh, Greatstaff of the Guardian] warlock version
	-- Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.
	--------------------
	-- [Brilliant Wizard Oil]
	-- Use: While applied to target weapon it increases spell damage by up to 36 and increases spell critical strike rating by 14 . Lasts for 30 minutes. 
	----------------------------------------------------------------------------------------------------
	-- I redesigned the tooltip scanner using a more locale friendly, 2 pass matching matching algorithm.
	--
	-- The first pass searches for the rating number, the patterns are read from ["numberPatterns"] here,
	-- " by (%d+)" will match strings like: "Increases defense rating by 16."
	-- "%+(%d+)" will match strings like: "+10 Defense Rating"
	-- You can add additional patterns if needed, its not limited to 2 patterns.
	-- The separators are a table of strings used to break up a line into multiple lines what will be parsed seperately.
	-- For example "+3 Hit Rating, +5 Spell Crit Rating" will be split into "+3 Hit Rating" and " +5 Spell Crit Rating"
	--
	-- The second pass searches for the rating name, the names are read from ["statList"] here,
	-- It will look through the table in order, so you can put common strings at the begining to speed up the search,
	-- and longer strings should be listed first, like "spell critical strike" should be listed before "critical strike", 
	-- this way "spell critical strike" does get matched by "critical strike".
	-- Strings need to be in lower case letters, because string.lower is called on lookup
	--
	-- IMPORTANT: there may not exist a one-to-one correspondence, meaning you can't just translate this file, 
	-- but will need to go in game and find out what needs to be put in here.
	-- For example, in english I found 3 different strings that maps to CR_CRIT_MELEE: "critical strike", "critical hit" and "crit".
	-- You will need to find out every string that represents CR_CRIT_MELEE, and so on.
	-- In other languages there may be 5 different strings that should all map to CR_CRIT_MELEE.
	-- so please check in game that you have all strings, and not translate directly off this table.
	--
	-- Tip1: When doing localizations, I recommend you set debugging to true in RatingBuster.lua
	-- Find RatingBuster:SetDebugging(false) and change it to RatingBuster:SetDebugging(true)
	-- or you can type /rb debug to enable it in game
	--
	-- Tip2: The strings are passed into string.find, so you should escape the magic characters ^$()%.[]*+-? with a %
	["numberPatterns"] = {
		--{pattern = " на (%d+)", addInfo = "AfterStat",},
		{pattern = "([%+%-]%d+)", addInfo = "AfterNumber",},
		{pattern = "(%d+) к ", addInfo = "AfterNumber"}, -- тест
		{pattern = "увеличение (%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
		{pattern = "дополнительно (%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
		-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
		-- Added [^|] so that it doesn't match enchant strings (JewelTips)
		{pattern = "на (%d+)([^%d%%|]+)", addInfo = "AfterNumber",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
	},
	["separators"] = {
		"/", " и ", ",", " for ", "&"
	},
	--[[ Rating ID
	CR_WEAPON_SKILL = 1;
	CR_DEFENSE_SKILL = 2;
	CR_DODGE = 3;
	CR_PARRY = 4;
	CR_BLOCK = 5;
	CR_HIT_MELEE = 6;
	CR_HIT_RANGED = 7;
	CR_HIT_SPELL = 8;
	CR_CRIT_MELEE = 9;
	CR_CRIT_RANGED = 10;
	CR_CRIT_SPELL = 11;
	CR_HIT_TAKEN_MELEE = 12;
	CR_HIT_TAKEN_RANGED = 13;
	CR_HIT_TAKEN_SPELL = 14;
	CR_CRIT_TAKEN_MELEE = 15;
	CR_CRIT_TAKEN_RANGED = 16;
	CR_CRIT_TAKEN_SPELL = 17;
	CR_HASTE_MELEE = 18;
	CR_HASTE_RANGED = 19;
	CR_HASTE_SPELL = 20;
	CR_WEAPON_SKILL_MAINHAND = 21;
	CR_WEAPON_SKILL_OFFHAND = 22;
	CR_WEAPON_SKILL_RANGED = 23;
	CR_EXPERTISE = 24;
	--
	SPELL_STAT1_NAME = "Strength"
	SPELL_STAT2_NAME = "Agility"
	SPELL_STAT3_NAME = "Stamina"
	SPELL_STAT4_NAME = "Intellect"
	SPELL_STAT5_NAME = "Spirit"
	--]]
	-- для русской локализации надо указывать все используемые склонения рейтингов (рейтинг, рейтинга,
        -- рейтингу) т.к. иначе распознование не работает.
	-- 

	["statList"] = {
		{pattern = string.lower("Силе атаки"), id = SPELL_STAT1115_NAME}, --чтобы Сила атаки не распознавалась как Сила
		{pattern = string.lower("Сила атаки"), id = SPELL_STAT1115_NAME}, -- эти строки должны быть впереди
		{pattern = string.lower("Силу атаки"), id = SPELL_STAT1115_NAME},
		{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
		{pattern = string.lower("Силе"), id = SPELL_STAT1_NAME},
		{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
		{pattern = string.lower("Ловкости"), id = SPELL_STAT2_NAME},
		{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
		{pattern = string.lower("Выносливости"), id = SPELL_STAT3_NAME},
		{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
		{pattern = string.lower("Интеллекту"), id = SPELL_STAT4_NAME},
		{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
		{pattern = string.lower("Духу"), id = SPELL_STAT5_NAME},

		{pattern = "рейтинг защиты", id = CR_DEFENSE_SKILL},
		{pattern = "рейтингу защиты", id = CR_DEFENSE_SKILL},
		{pattern = "рейтинга защиты", id = CR_DEFENSE_SKILL},
		{pattern = "рейтинг уклонения", id = CR_DODGE},
		{pattern = "рейтингу уклонения", id = CR_DODGE},
		{pattern = "рейтинга уклонения", id = CR_DODGE},
		{pattern = "рейтинг блокирования щитом", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
		{pattern = "рейтинга блокирования щитом", id = CR_BLOCK},
		{pattern = "рейтингу блокирования щитом", id = CR_BLOCK},
		{pattern = "увеличение рейтинга блокирования щита на", id = CR_BLOCK},
		{pattern = "рейтинга блока", id = CR_BLOCK},
		{pattern = "рейтинг парирования", id = CR_PARRY},
		{pattern = "рейтинга парирования", id = CR_PARRY},
		{pattern = "рейтингу парирования", id = CR_PARRY},
	
		{pattern = "рейтинг критического удара %(заклинания%)", id = CR_CRIT_SPELL},
		{pattern = "рейтингу критического удара %(заклинания%)", id = CR_CRIT_SPELL},
		{pattern = "рейтинга критического удара %(заклинания%)", id = CR_CRIT_SPELL},
		{pattern = "рейтинга критического удара заклинаниями", id = CR_CRIT_SPELL},
		{pattern = "рейтингу критического удара заклинаниями", id = CR_CRIT_SPELL},
		{pattern = "рейтинг критического удара заклинаниями", id = CR_CRIT_SPELL},
		{pattern = "spell critical hit rating", id = CR_CRIT_SPELL},
		{pattern = "spell critical rating", id = CR_CRIT_SPELL},
		{pattern = "spell crit rating", id = CR_CRIT_SPELL},
		{pattern = "ranged critical strike rating", id = CR_CRIT_RANGED},
		{pattern = "ranged critical hit rating", id = CR_CRIT_RANGED},
		{pattern = "ranged critical rating", id = CR_CRIT_RANGED},
		{pattern = "ranged crit rating", id = CR_CRIT_RANGED},
		{pattern = "рейтинг критического удара", id = CR_CRIT_MELEE},
		{pattern = "рейтингу критического удара", id = CR_CRIT_MELEE},
		{pattern = "рейтинга критического удара", id = CR_CRIT_MELEE},
		{pattern = "рейтинг крит. удара оруж. ближнего боя", id = CR_CRIT_MELEE},
		{pattern = "critical hit rating", id = CR_CRIT_MELEE},
		{pattern = "critical rating", id = CR_CRIT_MELEE},
		{pattern = "crit rating", id = CR_CRIT_MELEE},
		
		{pattern = "рейтинг меткости %(заклинания%)", id = CR_HIT_SPELL},
		{pattern = "рейтингу меткости %(заклинания%)", id = CR_HIT_SPELL},
		{pattern = "рейтинга меткости %(заклинания%)", id = CR_HIT_SPELL},
		{pattern = "рейтингу меткости заклинаний", id = CR_HIT_SPELL},
		{pattern = "ranged hit rating", id = CR_HIT_RANGED},
		{pattern = "рейтинга нанесения удара ближнего боя", id = CR_HIT_MELEE},
		{pattern = "рейтинг меткости", id = CR_HIT_MELEE},
		{pattern = "рейтинга меткости", id = CR_HIT_MELEE},
		{pattern = "рейтингу меткости", id = CR_HIT_MELEE},

		{pattern = "рейтинг устойчивости", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating
		{pattern = "рейтингу устойчивости", id = CR_CRIT_TAKEN_MELEE},
		{pattern = "рейтинга устойчивости", id = CR_CRIT_TAKEN_MELEE},

		{pattern = "рейтинг скорости боя %(заклинания%)", id = CR_HASTE_SPELL},
		{pattern = "рейтингу скорости боя %(заклинания%)", id = CR_HASTE_SPELL},
		{pattern = "рейтинга скорости боя %(заклинания%)", id = CR_HASTE_SPELL},
		{pattern = "скорости наложения заклинаний", id = CR_HASTE_SPELL},
		{pattern = "скорость наложения заклинаний", id = CR_HASTE_SPELL},
		{pattern = "ranged haste rating", id = CR_HASTE_RANGED},
		{pattern = "рейтинг скорости боя", id = CR_HASTE_MELEE},
		{pattern = "рейтингу скорости боя", id = CR_HASTE_MELEE},
		{pattern = "рейтинга скорости боя", id = CR_HASTE_MELEE},
		{pattern = "speed rating", id = CR_HASTE_MELEE}, -- [Drums of Battle]
		
		{pattern = "skill rating", id = CR_WEAPON_SKILL},
		{pattern = "рейтинг мастерства", id = CR_EXPERTISE},
		{pattern = "рейтингу мастерства", id = CR_EXPERTISE},
		{pattern = "рейтинга мастерства", id = CR_EXPERTISE},

		{pattern = "hit avoidance rating", id = CR_HIT_TAKEN_MELEE},
		--[[
		{pattern = "dagger skill rating", id = CR_WEAPON_SKILL},
		{pattern = "sword skill rating", id = CR_WEAPON_SKILL},
		{pattern = "two%-handed swords skill rating", id = CR_WEAPON_SKILL},
		{pattern = "axe skill rating", id = CR_WEAPON_SKILL},
		{pattern = "bow skill rating", id = CR_WEAPON_SKILL},
		{pattern = "crossbow skill rating", id = CR_WEAPON_SKILL},
		{pattern = "gun skill rating", id = CR_WEAPON_SKILL},
		{pattern = "feral combat skill rating", id = CR_WEAPON_SKILL},
		{pattern = "mace skill rating", id = CR_WEAPON_SKILL},
		{pattern = "polearm skill rating", id = CR_WEAPON_SKILL},
		{pattern = "staff skill rating", id = CR_WEAPON_SKILL},
		{pattern = "two%-handed axes skill rating", id = CR_WEAPON_SKILL},
		{pattern = "two%-handed maces skill rating", id = CR_WEAPON_SKILL},
		{pattern = "fist weapons skill rating", id = CR_WEAPON_SKILL},
		--]]
	},
	-------------------------
	-- Added info patterns --
	-------------------------
	-- $value will be replaced with the number
	-- EX: "$value% Crit" -> "+1.34% Crit"
	-- EX: "Crit $value%" -> "Crit +1.34%"
	["$value% Crit"] = "$value% крит",
	["$value% Spell Crit"] = "$value% крит закл",
	["$value% Dodge"] = "$value% уклонение",
	["$value HP"] = "$value Здор",
	["$value MP"] = "$value Мана",
	["$value AP"] = "$value Сила атаки",
	["$value RAP"] = "$value Сила атаки",
	["$value Dmg"] = "$value Дмг",
	["$value Heal"] = "$value Хилл",
	["$value Armor"] = "$value Армор",
	["$value Block"] = "$value% Блок",
	["$value MP5"] = "$value МП5сек",
	["$value MP5(NC)"] = "$value МП 5сек НК",
	["$value HP5"] = "$value Здор 5сек",
	["$value to be Dodged/Parried"] = "$value% уклон/парир",
	["$value to be Crit"] = "$value% крит",
	["$value Crit Dmg Taken"] = "$value дамаг крита",
	["$value DOT Dmg Taken"] = "$value дамаг дотов",
	
	------------------
	-- Stat Summary --
	------------------
	["Stat Summary"] = "Итог по статам",
} end)