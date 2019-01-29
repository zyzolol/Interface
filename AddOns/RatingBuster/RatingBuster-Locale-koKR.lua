--[[
Name: RatingBuster koKR locale
Revision: $Revision: 173 $
Translated by: 
- Slowhand, 7destiny, kcgcom, fenlis
]]

local L = AceLibrary("AceLocale-2.2"):new("RatingBuster")
if not CR_ARMOR_PENETRATION then
	CR_ARMOR_PENETRATION = 25
end
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "顯示物品編號",
L:RegisterTranslations("koKR", function() return {
	---------------
	-- Waterfall --
	---------------
	["RatingBuster Options"] = "RatingBuster 설정",
	["Waterfall-1.0 is required to access the GUI."] = "GUI를 표시하려면 Waterfall-1.0 라이브러리가 필요합니다!",
	---------------------------
	-- Slash Command Options --
	---------------------------
	-- /rb win
	["Options Window"] = "설정창",
	["Shows the Options Window"] = "설정창을 보여줍니다.",
	-- /rb statmod
	["Enable Stat Mods"] = "애드온 사용",
	["Enable support for Stat Mods"] = "애드온을 활성화합니다.",
	-- /rb avoidancedr
	["Enable avoidance diminishing returns"] = "회피 점감효과 사용",
	["Dodge, Parry, Hit Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "회피, 무기막기, 빗맞힘(자신) 값을 현재에 점감효과 방식을 사용하여 계산됩니다",
	-- /rb itemid
	["Show ItemID"] = "아이템 ID 표시",
	["Show the ItemID in tooltips"] = "툴팁에 아이템 ID를 표시합니다.",
	-- /rb itemlevel
	["Show ItemLevel"] = "아이템 레벨 표시",
	["Show the ItemLevel in tooltips"] = "툴팁에 아이템 레벨을 표시합니다.",
	-- /rb usereqlv
	["Use required level"] = "최소 요구 레벨 사용",
	["Calculate using the required level if you are below the required level"] = "레벨이 낮아 사용하지 못하는 경우 최소 요구 레벨에 따라 계산합니다.",
	-- /rb level
	["Set level"] = "레벨 설정",
	["Set the level used in calculations (0 = your level)"] = "계산에 적용할 레벨을 설정합니다. (0 = 자신의 레벨)",
	---------------------------------------------------------------------------
	-- /rb rating
	["Rating"] = "전투 숙련도",
	["Options for Rating display"] = "전투 숙련도 표시에 대한 설정입니다.",
	-- /rb rating show
	["Show Rating conversions"] = "전투 숙련도 계산 표시",
	["Show Rating conversions in tooltips"] =  "툴팁에 전투 숙련도를 전투 능력치로 계산하여 표시합니다.",
	-- /rb rating spell
	["Show Spell Hit"] = "주문 적중 표시",
	["Show Spell Hit from Hit Rating"] = "적중도에 의한 주문 적중을 표시합니다.",
	-- /rb rating physical
	["Show Physical Hit"] = "물리 적중 표시",
	["Show Physical Hit from Hit ratings"] = "적중도에 의한 물리 적중을 표시합니다.",
	-- /rb rating detail
	["Show detailed conversions text"] = "세부적인 전투 숙련도 계산 표시",
	["Show detailed text for Resiliance and Expertise conversions"] = "탄력도와 숙련을 세부적인 전투 능력치로 계산해서 표시합니다.",
	-- /rb rating def
	["Defense breakdown"] = "방어 숙련 세분화",
	["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "방어 숙련을 치명타(자신) 감소, 빗맞힘(자신), 회피, 무기 막기, 방패 막기로 계산해서 표시합니다.",
	-- /rb rating wpn
	["Weapon Skill breakdown"] = "무기 숙련 세분화",
	["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "무기 숙련을 치명타(공격), 적중, 회피 무시, 무기막기 무시, 방패막기 무시로 계산해서 표시합니다.",
	-- /rb rating exp
	["Expertise breakdown"] = "숙련 세분화",
	["Convert Expertise into Dodge Neglect and Parry Neglect"] = "숙련을 회피 무시와 무기막기 무시로 계산해서 표시합니다.",
	---------------------------------------------------------------------------
	-- /rb rating color
	["Change text color"] = "글자 색상 변경",
	["Changes the color of added text"] = "추가된 글자의 색상을 변경합니다.",
	-- /rb rating color pick
	["Pick color"] = "색상",
	["Pick a color"] = "색상을 선택합니다.",
	-- /rb rating color enable
	["Enable color"] = "색상 사용",
	["Enable colored text"] = "글자에 색상을 적용합니다.",
	---------------------------------------------------------------------------
	-- /rb stat
	["Stat Breakdown"] = "능력치",
	["Changes the display of base stats"] = "기본 능력치의 표시 방법을 변경합니다.",
	-- /rb stat show
	["Show base stat conversions"] = "기본 능력치 계산 표시",
	["Show base stat conversions in tooltips"] = "툴팁에 기본 능력치를 전투 능력치로 계산하여 표시합니다.",
	---------------------------------------------------------------------------
	-- /rb stat str
	["Strength"] = "힘",
	["Changes the display of Strength"] = "힘의 표시 방법을 변경합니다.",
	-- /rb stat str ap
	["Show Attack Power"] = "전투력 표시",
	["Show Attack Power from Strength"] = "힘에 의한 전투력을 표시합니다.",
	-- /rb stat str block
	["Show Block Value"] = "피해 방어량 표시",
	["Show Block Value from Strength"] = "힘에 의한 피해 방어량을 표시합니다.",
	-- /rb stat str dmg
	["Show Spell Damage"] = "주문 공격력 표시",
	["Show Spell Damage from Strength"] = "힘에 의한 주문 공격력을 표시합니다.",
	-- /rb stat str heal
	["Show Healing"] = "치유량 표시",
	["Show Healing from Strength"] = "힘에 의한 치유량을 표시합니다.",
	-- /rb stat str parry
	["Show Parry"] = "무기 막기",
	["Show Parry from Strength"] = "힘에 의한 무기 막기를 표시합니다.",
	---------------------------------------------------------------------------
	-- /rb stat agi
	["Agility"] = "민첩성",
	["Changes the display of Agility"] = "민첩성의 표시 방법을 변경합니다.",
	-- /rb stat agi crit
	["Show Crit"] = "치명타 표시",
	["Show Crit chance from Agility"] = "민첩성에 의한 치명타 확률을 표시합니다.",
	-- /rb stat agi dodge
	["Show Dodge"] = "회피 표시",
	["Show Dodge chance from Agility"] = "민첩성에 의한 회피율을 표시합니다.",
	-- /rb stat agi ap
	["Show Attack Power"] = "전투력 표시",
	["Show Attack Power from Agility"] = "민첩성에 의한 전투력을 표시합니다.",
	-- /rb stat agi rap
	["Show Ranged Attack Power"] = "원거리 전투력 표시",
	["Show Ranged Attack Power from Agility"] = "민첩성에 의한 원거리 전투력을 표시합니다.",
	-- /rb stat agi armor
	["Show Armor"] = "방어도 표시",
	["Show Armor from Agility"] = "민첩성에 의한 방어도를 표시합니다.",
	-- /rb stat agi heal
	["Show Healing"] = "치유량 표시",
	["Show Healing from Agility"] = "민첩성에 의한 치유량을 표시합니다.",
	---------------------------------------------------------------------------
	-- /rb stat sta
	["Stamina"] = "체력",
	["Changes the display of Stamina"] = "체력의 표시 방법을 변경합니다.",
	-- /rb stat sta hp
	["Show Health"] = "생명력 표시",
	["Show Health from Stamina"] = "체력에 의한 생명력을 표시합니다.",
	-- /rb stat sta dmg
	["Show Spell Damage"] = "주문 공격력 표시",
	["Show Spell Damage from Stamina"] = "체력에 의한 주문 공격력을 표시합니다.",
	-- /rb stat sta heal
	["Show Healing"] = "치유량 표시",
	["Show Healing from Stamina"] = "체력에 의한 치유량을 표시합니다.",
	-- /rb stat sta ap
	["Show Attack Power"] = "전투력 표시",
	["Show Attack Power from Stamina"] = "체력에 의한 전투력을 표시합니다.",
	---------------------------------------------------------------------------
	-- /rb stat int
	["Intellect"] = "지능",
	["Changes the display of Intellect"] = "지능 표시방법을 변경합니다.",
	-- /rb stat int spellcrit
	["Show Spell Crit"] = "주문 극대화 표시",
	["Show Spell Crit chance from Intellect"] = "지능에 의한 주문 극대화율 표시",
	-- /rb stat int mp
	["Show Mana"] = "마나 표시",
	["Show Mana from Intellect"] = "지능에 의한 마나량을 표시합니다.",
	-- /rb stat int dmg
	["Show Spell Damage"] = "주문 공격력 표시",
	["Show Spell Damage from Intellect"] = "지능에 의한 주문 공격력을 표시합니다.",
	-- /rb stat int heal
	["Show Healing"] = "치유량 표시",
	["Show Healing from Intellect"] = "지능에 의한 치유량을 표시합니다.",
	-- /rb stat int mp5
	["Show Mana Regen"] = "마나 회복 표시",
	["Show Mana Regen while casting from Intellect"] = "지능에 의한 시전중 마나 회복량을 표시합니다.",
	-- /rb stat int mp5nc
	["Show Mana Regen while NOT casting"] = "비시전중 마나 회복 표시",
	["Show Mana Regen while NOT casting from Intellect"] = "지능에 의한 비시전중 마나 회복량을 표시합니다.",
	-- /rb stat int rap
	["Show Ranged Attack Power"] = "원거리 전투력 표시",
	["Show Ranged Attack Power from Intellect"] = "지능에 의한 원거리 전투력을 표시합니다.",
	-- /rb stat int armor
	["Show Armor"] = "방어도 표시",
	["Show Armor from Intellect"] = "지능에 의한 방어도를 표시합니다.",
	-- /rb stat int ap
	["Show Attack Power"] = "전투력 표시",
	["Show Attack Power from Intellect"] = "지능에 의한 전투력을 표시합니다.",
	---------------------------------------------------------------------------
	-- /rb stat spi
	["Spirit"] = "정신력",
	["Changes the display of Spirit"] = "정신력의 표시방법을 변경합니다.",
	-- /rb stat spi mp5
	["Show Mana Regen"] = "마나 회복 표시",
	["Show Mana Regen while casting from Spirit"] = "정신력에 의한 시전중 마나 회복량을 표시합니다.",
	-- /rb stat spi mp5nc
	["Show Mana Regen while NOT casting"] = "비시전중 마나 회복 표시",
	["Show Mana Regen while NOT casting from Spirit"] = "정신력에 의한 비시전중 마나 회복량을 표시합니다.",
	-- /rb stat spi hp5
	["Show Health Regen"] = "생명력 회복 표시",
	["Show Health Regen from Spirit"] = "정신력에 의한 (비전투중) 생명력 회복량을 표시합니다.",
	-- /rb stat spi dmg
	["Show Spell Damage"] = "주문 공격력 표시",
	["Show Spell Damage from Spirit"] = "정신력에 의한 주문 공격력을 표시합니다.",
	-- /rb stat spi heal
	["Show Healing"] = "치유량 표시",
	["Show Healing from Spirit"] = "정신력에 의한 치유량을 표시합니다.",
	---------------------------------------------------------------------------
	-- /rb sum
	["Stat Summary"] = "능력치 요약",
	["Options for stat summary"] = "능력치 요약에 대한 설정입니다.",
	-- /rb sum show
	["Show stat summary"] = "능력치 요약 표시",
	["Show stat summary in tooltips"] = "툴팁에 능력치 요약을 표시합니다.",
	-- /rb sum ignore
	["Ignore settings"] = "제외 설정",
	["Ignore stuff when calculating the stat summary"] = "능력치 요약 계산에서 제외시킬 항목들을 설정합니다.",
	-- /rb sum ignore unused
	["Ignore unused items types"] = "쓸모없는 아이템 제외",
	["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "능력치 요약 계산에 자신이 사용할 수 있는 가장 높은 방어도 유형과 고급(녹색) 품질 이상의 아이템만 포함시킵니다.",
	-- /rb sum ignore equipped
	["Ignore equipped items"] = "착용 아이템 제외",
	["Hide stat summary for equipped items"] = "능력치 요약 계산에 착용한 아이템은 포함시키지 않습니다.",
	-- /rb sum ignore enchant
	["Ignore enchants"] = "마법부여 제외",
	["Ignore enchants on items when calculating the stat summary"] = "능력치 요약 계산에 아이템에 부여한 마법부여를 포함시키지 않습니다.",
	-- /rb sum ignore gem
	["Ignore gems"] = "보석 제외",
	["Ignore gems on items when calculating the stat summary"] = "능력치 요약 계산에 아이템에 장착한 보석을 포함시키지 않습니다.",
	-- /rb sum diffstyle
	["Display style for diff value"] = "차이값 표시 방식",
	["Display diff values in the main tooltip or only in compare tooltips"] = "기본 툴팁 또는 비교 툴팁에 차이값을 표시합니다.",
	-- /rb sum space
	["Add empty line"] = "구분선 추가",
	["Add a empty line before or after stat summary"] = "능력치 요약 앞/뒤에 구분선을 추가합니다.",
	-- /rb sum space before
	["Add before summary"] = "요약 앞에 추가",
	["Add a empty line before stat summary"] = "능력치 요약 앞에 구분선을 추가합니다.",
	-- /rb sum space after
	["Add after summary"] = "요약 뒤에 추가",
	["Add a empty line after stat summary"] = "능력치 요약 뒤에 구분선을 추가합니다.",
	-- /rb sum icon
	["Show icon"] = "아이콘 표시",
	["Show the sigma icon before summary listing"] = "요약 목록 앞에 시그마 아이콘을 표시합니다.",
	-- /rb sum title
	["Show title text"] = "제목 표시",
	["Show the title text before summary listing"] = "요약 목록 앞에 제목을 표시합니다.",
	-- /rb sum showzerostat
	["Show zero value stats"] = "제로 능력치 표시",
	["Show zero value stats in summary for consistancy"] = "통일되게 보이도록 대한 요약에 제로값의 능력치를 표시합니다.",
	-- /rb sum calcsum
	["Calculate stat sum"] = "능력치 합계 계산",
	["Calculate the total stats for the item"] = "아이템에 대한 총 능력치를 계산합니다.",
	-- /rb sum calcdiff
	["Calculate stat diff"] = "능력치 차이 계산",
	["Calculate the stat difference for the item and equipped items"] = "선택한 아이템과 착용한 아이템의 능력치 차이를 계산합니다.",
	-- /rb sum sort
	["Sort StatSummary alphabetically"] = "능력치 요약 정렬",
	["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "능력치 요약을 알파벳순으로 정렬합니다, 능력치별로 정렬하려면 비활성화하세요.(기본, 물리, 주문, 방어)",
	-- /rb sum avoidhasblock
	["Include block chance in Avoidance summary"] = "완전방어 요약에 방패 막기 포함",
	["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "완전방어 요약에 방패박기를 포함시킵니다. 회피, 무기 막기, 빗맞힘(자신)만 포함시키려면 비활성화하세요.",
	---------------------------------------------------------------------------
	-- /rb sum basic
	["Stat - Basic"] = "능력치 - 기본",
	["Choose basic stats for summary"] = "기본 능력치를 선택합니다.",
	-- /rb sum basic hp
	["Sum Health"] = "생명력 합계",
	["Health <- Health, Stamina"] = "생명력 <- 생명력, 체력",
	-- /rb sum basic mp
	["Sum Mana"] = "마나 합계",
	["Mana <- Mana, Intellect"] = "마나 < 마나, 지능",
	-- /rb sum basic mp5
	["Sum Mana Regen"] = "마나 회복 합계",
	["Mana Regen <- Mana Regen, Spirit"] = "마나 회복 <- 마나 회복, 정신력",
	-- /rb sum basic mp5nc
	["Sum Mana Regen while not casting"] = "비시전중 마나 회복",
	["Mana Regen while not casting <- Spirit"] = "비시전중 마나 회복 <- 정신력",
	-- /rb sum basic hp5
	["Sum Health Regen"] = "생명력 회복 합계",
	["Health Regen <- Health Regen"] = "생명력 회복 <- 생명력 회복",
	-- /rb sum basic hp5oc
	["Sum Health Regen when out of combat"] = "비전투중 생명력 회복",
	["Health Regen when out of combat <- Spirit"] = "비전투중 생명력 회복 <- 정신력",
	-- /rb sum basic str
	["Sum Strength"] = "힘 합계",
	["Strength Summary"] = "힘 요약",
	-- /rb sum basic agi
	["Sum Agility"] = "민첩성 합계",
	["Agility Summary"] = "민첩성 요약",
	-- /rb sum basic sta
	["Sum Stamina"] = "체력 합계",
	["Stamina Summary"] = "체력 요약",
	-- /rb sum basic int
	["Sum Intellect"] = "지능 합계",
	["Intellect Summary"] = "지능 요약",
	-- /rb sum basic spi
	["Sum Spirit"] = "정신력 합계",
	["Spirit Summary"] = "정신력 요약",
	---------------------------------------------------------------------------
	-- /rb sum physical
	["Stat - Physical"] = "능력치 - 물리",
	["Choose physical damage stats for summary"] = "물리 공격력 능력치를 선택합니다.",
	-- /rb sum physical ap
	["Sum Attack Power"] = "전투력 합계",
	["Attack Power <- Attack Power, Strength, Agility"] = "전투력 <- 전투력, 힘, 민첩성",
	-- /rb sum physical rap
	["Sum Ranged Attack Power"] = "원거리 전투력 합계",
	["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "원거리 전투력 <- 원거리 전투력, 지능, 전투력, 힘, 민첩성",
	-- /rb sum physical fap
	["Sum Feral Attack Power"] = "야성 전투력 합계",
	["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "야성 전투력 <- 야성 전투력, 전투력, 힘, 민첩성",
	-- /rb sum physical hit
	["Sum Hit Chance"] = "적중률 합계",
	["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "적중률 <- 적중도, 무기 숙련도",
	-- /rb sum physical hitrating
	["Sum Hit Rating"] = "적중도 합계",
	["Hit Rating Summary"] = "적중도 요약",
	-- /rb sum physical crit
	["Sum Crit Chance"] = "치명타율 합계",
	["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "치명타율 <- 치명타 적중도, 민첩성, 무기 숙련도",
	-- /rb sum physical critrating
	["Sum Crit Rating"] = "치명타 적중도 합계",
	["Crit Rating Summary"] = "치명타 적중도 요약",
	-- /rb sum physical haste
	["Sum Haste"] = "가속율 합계",
	["Haste <- Haste Rating"] = "가속율 <- 공격 가속도",
	-- /rb sum physical hasterating
	["Sum Haste Rating"] = "공격 가속도 합계",
	["Haste Rating Summary"] = "공격 가속도 요약",
	-- /rb sum physical rangedhit
	["Sum Ranged Hit Chance"] = "원거리 적중률 합계",
	["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "원거리 적중률 <- 적중도, 무기 숙련도, 원거리 적중도",
	-- /rb sum physical rangedhitrating
	["Sum Ranged Hit Rating"] = "원거리 적중도 합계",
	["Ranged Hit Rating Summary"] = "원거리 적중도 요약",
	-- /rb sum physical rangedcrit
	["Sum Ranged Crit Chance"] = "원거리 치명타율 합계",
	["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "원거리 치명타율 <- 치명타 적중도, 민첩성, 무기 숙련도, 치명타 적중도",
	-- /rb sum physical rangedcritrating
	["Sum Ranged Crit Rating"] = "원거리 치명타 적중도 합계",
	["Ranged Crit Rating Summary"] = "원거리 치명타 적중도 요약",
	-- /rb sum physical rangedhaste
	["Sum Ranged Haste"] = "원거리 가속율 합계",
	["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "원거리 가속율 <- 공격 가속도, 원거리 가속율",
	-- /rb sum physical rangedhasterating
	["Sum Ranged Haste Rating"] = "원거리 가속도 합계",
	["Ranged Haste Rating Summary"] = "원거리 가속도 요약",
	-- /rb sum physical maxdamage
	["Sum Weapon Max Damage"] = "무기 최대 공격력 합계",
	["Weapon Max Damage Summary"] = "무기 최대 공격력 요약",
	-- /rb sum physical ignorearmor
	["Sum Ignore Armor"] = "방어도 무시 합계",
	["Ignore Armor Summary"] = "방어도 무시 요약",
	-- /rb sum physical arp
	["Sum Armor Penetration"] = "방어도 관통력 합계",
	["Armor Penetration Summary"] = "방어도 관통력 요약",
	-- /rb sum physical weapondps
	--["Sum Weapon DPS"] = true,
	--["Weapon DPS Summary"] = true,
	-- /rb sum physical wpn
	["Sum Weapon Skill"] = "무기 숙련 합계",
	["Weapon Skill <- Weapon Skill Rating"] = "무기 숙련 <- 무기 숙련도",
	-- /rb sum physical exp
	["Sum Expertise"] = "숙련 합계",
	["Expertise <- Expertise Rating"] = "숙련 <- 숙련도",
	-- /rb sum physical arprating
	["Sum Armor Penetration Rating"] = "방어도 관통도 합계",
	["Armor Penetration Rating Summary"] = "방어도 관통도 요약",
	---------------------------------------------------------------------------
	-- /rb sum spell
	["Stat - Spell"] = "능력치 - 주문",
	["Choose spell damage and healing stats for summary"] = "주문 공격력과 치유량 능력치를 선택합니다.",
	-- /rb sum spell dmg
	["Sum Spell Damage"] = "주문 공격력 합계",
	["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "주문 공격력 <- 주문 공격력, 지능, 정신력, 체력",
	-- /rb sum spell dmgholy
	["Sum Holy Spell Damage"] = "신성 주문 공격력 합계",
	["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "신성 주문 공격력 <- 신성 주문 공격력, 주문 공격력, 지능, 정신력",
	-- /rb sum stat dmgarcane
	["Sum Arcane Spell Damage"] = "비전 주문 공격력 합계",
	["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "비전 주문 공격력 <- 비전 주문 공격력, 주문 공격력, 지능",
	-- /rb sum stat dmgfire
	["Sum Fire Spell Damage"] = "화염 주문 공격력 합계",
	["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "화염 주문 공격력 <- 화염 주문 공격력, 주문 공격력, 지능, 체력",
	-- /rb sum stat dmgnature
	["Sum Nature Spell Damage"] = "자연 주문 공격력 합계",
	["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "자연 주문 공격력 <- 자연 주문 공격력, 주문 공격력, 지능",
	-- /rb sum stat dmgfrost
	["Sum Frost Spell Damage"] = "냉기 주문 공격력 합계",
	["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "냉기 주문 공격력 <- 냉기 주문 공격력, 주문 공격력, 지능",
	-- /rb sum stat dmgshadow
	["Sum Shadow Spell Damage"] = "암흑 주문 공격력 합계",
	["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "암흑 주문 공격력 <- 암흑 주문 공격력, 주문 공격력, 지능, 정신력, 체력",
	-- /rb sum spell heal
	["Sum Healing"] = "치유량 합계",
	["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "치유량 <- 치유량, 지능, 정신력, 민첩성, 힘",
	-- /rb sum spell crit
	["Sum Spell Crit Chance"] = "주문 극대화율 합계",
	["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "주문 극대화율 <- 주문 극대화 적중도, 지능",
	-- /rb sum spell hit
	["Sum Spell Hit Chance"] = "주문 적중율 합계",
	["Spell Hit Chance <- Spell Hit Rating"] = "주문 적중율 <- 주문 적중도",
	-- /rb sum spell haste
	["Sum Spell Haste"] = "주문 가속 합계",
	["Spell Haste <- Spell Haste Rating"] = "주문 가속 <- 주문 가속도",
	-- /rb sum spell pen
	["Sum Penetration"] = "관통력 합계",
	["Spell Penetration Summary"] = "주문 관통력 요약",
	-- /rb sum spell hitrating
	["Sum Spell Hit Rating"] = "주문 적중도 합계",
	["Spell Hit Rating Summary"] = "주문 적중도 요약",
	-- /rb sum spell critrating
	["Sum Spell Crit Rating"] = "주문 극대화 적중도 합계",
	["Spell Crit Rating Summary"] = "주문 극대화 적중도 요약",
	-- /rb sum spell hasterating
	["Sum Spell Haste Rating"] = "주문 가속도",
	["Spell Haste Rating Summary"] = "주문 가속도 요약",
	---------------------------------------------------------------------------
	-- /rb sum tank
	["Stat - Tank"] = "능력치 - 방어",
	["Choose tank stats for summary"] = "방어 능력치를 선택합니다.",
	-- /rb sum tank armor
	["Sum Armor"] = "방어도 합계",
	["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "방어도 <- 아이템 방어도, 방어도 보너스, 민첩성, 지능",
	-- /rb sum tank blockvalue
	["Sum Block Value"] = "피해 방어량 합계",
	["Block Value <- Block Value, Strength"] = "피해 방어량 <- 피해 방어량, 힘",
	-- /rb sum tank dodge
	["Sum Dodge Chance"] = "회피율 합계",
	["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "회피율 <- 회피 숙련도, 민첩성, 방어 숙련도",
	-- /rb sum tank parry
	["Sum Parry Chance"] = "무기 막기 확률 합계",
	["Parry Chance <- Parry Rating, Defense Rating"] = "무기 막기 확률 <- 무기 막기 숙련도, 방어 숙련도",
	-- /rb sum tank block
	["Sum Block Chance"] = "방패 막기 확률 합계",
	["Block Chance <- Block Rating, Defense Rating"] = "방패 막기 확률 <- 방패 막기 숙련도, 방어 숙련도",
	-- /rb sum tank avoidhit
	["Sum Hit Avoidance"] = "빗맞힘(자신) 합계",
	["Hit Avoidance <- Defense Rating"] = "빗맞힘(자신) <- 방어 숙련도",
	-- /rb sum tank avoidcrit
	["Sum Crit Avoidance"] = "치명타 감소 합계",
	["Crit Avoidance <- Defense Rating, Resilience"] = "치명타 감소 <- 방어 숙련도, 탄력도",
	-- /rb sum tank neglectdodge
	["Sum Dodge Neglect"] = "회피 무시 합계",
	["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "회피 무시 <- 숙련도, 무기 숙련도", -- 2.3.0
	-- /rb sum tank neglectparry
	["Sum Parry Neglect"] = "무기막기 무시 합계",
	["Parry Neglect <- Expertise, Weapon Skill Rating"] = "무기막기 무시 <- 숙련도, 무기 숙련도", -- 2.3.0
	-- /rb sum tank neglectblock
	["Sum Block Neglect"] = "방패막기 무시 합계",
	["Block Neglect <- Weapon Skill Rating"] = "방패막기 무시 <- 무기 숙련도",
	-- /rb sum tank resarcane
	["Sum Arcane Resistance"] = "비전 저항력 합계",
	["Arcane Resistance Summary"] = "비전 저항력 요약",
	-- /rb sum tank resfire
	["Sum Fire Resistance"] = "화염 저항력 합계",
	["Fire Resistance Summary"] = "화염 저항력 요약",
	-- /rb sum tank resnature
	["Sum Nature Resistance"] = "자연 저항력 합계",
	["Nature Resistance Summary"] = "자연 저항력 요약",
	-- /rb sum tank resfrost
	["Sum Frost Resistance"] = "냉기 저항력 합계",
	["Frost Resistance Summary"] = "냉기 저항력 요약",
	-- /rb sum tank resshadow
	["Sum Shadow Resistance"] = "암흑 저항력 합계",
	["Shadow Resistance Summary"] = "암흑 저항력 요약",
	-- /rb sum tank dodgerating
	["Sum Dodge Rating"] = "회피 숙련도 합계",
	["Dodge Rating Summary"] = "회피 숙련도 요약",
	-- /rb sum tank parryrating
	["Sum Parry Rating"] = "무기 막기 합계",
	["Parry Rating Summary"] = "무기 막기 숙련도 요약",
	-- /rb sum tank blockrating
	["Sum Block Rating"] = "방패 막기 숙련도 합계",
	["Block Rating Summary"] = "방어막기 숙련도 요약",
	-- /rb sum tank res
	["Sum Resilience"] = "탄력 합계",
	["Resilience Summary"] = "탄력 요약",
	-- /rb sum tank def
	["Sum Defense"] = "방어 숙련 합계",
	["Defense <- Defense Rating"] = "방어 숙련 <- 방어 숙련도",
	-- /rb sum tank tp
	["Sum TankPoints"] = "탱커점수(TankPoint) 합계",
	["TankPoints <- Health, Total Reduction"] = "탱커점수 <- 생명력, 총 피해감소",
	-- /rb sum tank tr
	["Sum Total Reduction"] = "총 피해감소 합계",
	["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "총 피해감소 <- 방어도, 회피, 무기 막기, 방패 막기, 피해 방어량, 방어 숙련, 탄력, 빗맞힘(자신), 치명타 감소, 몹강타, 피해감소 효과",
	-- /rb sum tank avoid
	["Sum Avoidance"] = "완전방어 합계",
	["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "완전방어 <- 회피, 무기 막기, 빗맞힘(자신), 방패 막기(선택적)",
	---------------------------------------------------------------------------
	-- /rb sum gem
	["Gems"] = "보석",
	["Auto fill empty gem slots"] = "빈 보석 슬롯을 자동으로 채웁니다.",
	-- /rb sum gem red
	["Red Socket"] = EMPTY_SOCKET_RED,
	["ItemID or Link of the gem you would like to auto fill"] = "자동으로 채우고 싶은 보석의 아이템ID & 링크를 입력하세요.",
	["<ItemID|Link>"] = "<아이템ID|링크>",
	["%s is now set to %s"] = "현재 %s에 %s 설정",
	["Queried server for Gem: %s. Try again in 5 secs."] = "서버에 보석 조회중: %s. 5초 후 다시하세요.",
	-- /rb sum gem yellow
	["Yellow Socket"] = EMPTY_SOCKET_YELLOW,
	-- /rb sum gem blue
	["Blue Socket"] = EMPTY_SOCKET_BLUE,
	-- /rb sum gem meta
	["Meta Socket"] = EMPTY_SOCKET_META,
	
	-----------------------
	-- Item Level and ID --
	-----------------------
	["ItemLevel: "] = "아이템레벨: ",
	["ItemID: "] = "아이템ID: ",
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
		{pattern = "(%d+)만큼 증가합니다.", addInfo = "AfterNumber",},
		{pattern = "([%+%-]%d+)", addInfo = "AfterNumber",},
		--{pattern = "grant.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
		--{pattern = "add.-(%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
		-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID:24261
		-- Added [^|] so that it doesn't match enchant strings (JewelTips)
		{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
	},
	["separators"] = {
		"/", " and ", ",", "%. ", " for ", "&", ":"
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
	SPELL_STAT1_NAME = "힘"
	SPELL_STAT2_NAME = "민첩성"
	SPELL_STAT3_NAME = "체력"
	SPELL_STAT4_NAME = "지능"
	SPELL_STAT5_NAME = "정신력"
	--]]
	["statList"] = {
		{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
		{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
		{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
		{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
		{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
		{pattern = "방어 숙련도", id = CR_DEFENSE_SKILL},
		{pattern = "회피 숙련도", id = CR_DODGE},
		{pattern = "방패 막기 숙련도", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
		{pattern = "무기 막기 숙련도", id = CR_PARRY},
	
		{pattern = "주문 극대화 적중도", id = CR_CRIT_SPELL},
		{pattern = "주문의 극대화 적중도", id = CR_CRIT_SPELL},
--		{pattern = "spell critical rating", id = CR_CRIT_SPELL},
--		{pattern = "spell crit rating", id = CR_CRIT_SPELL},
		{pattern = "원거리 치명타 적중도", id = CR_CRIT_RANGED},
--		{pattern = "ranged critical hit rating", id = CR_CRIT_RANGED},
--		{pattern = "ranged critical rating", id = CR_CRIT_RANGED},
--		{pattern = "ranged crit rating", id = CR_CRIT_RANGED},
		{pattern = "치명타 적중도", id = CR_CRIT_MELEE},
		{pattern = "근접 치명타 적중도", id = CR_CRIT_MELEE},
		{pattern = "critical rating", id = CR_CRIT_MELEE},
--		{pattern = "crit rating", id = CR_CRIT_MELEE},
		
		{pattern = "주문 적중도", id = CR_HIT_SPELL},
		{pattern = "원거리 적중도", id = CR_HIT_RANGED},
		{pattern = "적중도", id = CR_HIT_MELEE},
		
		{pattern = "탄력도", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating
		
		{pattern = "주문 시전 가속도", id = CR_HASTE_SPELL},
		{pattern = "원거리 공격 가속도", id = CR_HASTE_RANGED},
		{pattern = "공격 가속도", id = CR_HASTE_MELEE},
		{pattern = "가속도", id = CR_HASTE_MELEE}, -- [Drums of Battle]
		
		{pattern = "무기 숙련도", id = CR_WEAPON_SKILL},
		{pattern = "숙련도", id = CR_EXPERTISE},
		
		{pattern = "근접 공격 회피", id = CR_HIT_TAKEN_MELEE},
		{pattern = "방어 관통도", id = CR_ARMOR_PENETRATION},	--armor penetration rating
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
	["$value% Crit"] = "치명타 $value%",
	["$value% Spell Crit"] = "극대화 $value%",
	["$value% Dodge"] = "회피 $value%",
	["$value HP"] = "생명력 $value",
	["$value MP"] = "마나 $value",
	["$value AP"] = "전투력 $value",
	["$value RAP"] = "원거리 전투력 $value",
	["$value Dmg"] = "주문 공격력 $value",
	["$value Heal"] = "치유량 $value",
	["$value Armor"] = "방어도 $value",
	["$value Block"] = "방어 $value",
	["$value MP5"] = "$value MP5",
	["$value MP5(NC)"] = "$value MP5(NC)",
	["$value HP5"] = "$value HP5",
	["$value to be Dodged/Parried"] = "상대 회피/막기 $value",
	["$value to be Crit"] = "치명타 적중 $value",
	["$value Crit Dmg Taken"] = "치명타 피해 $value",
	["$value DOT Dmg Taken"] = "DoT 피해 $value",
	["$value% Parry"] = "무기 막기 $value%",
	-- for hit rating showing both physical and spell conversions
	-- (+1.21%, S+0.98%)
	-- (+1.21%, +0.98% S)
	["$value Spell"] = "주문 $value",
	
	------------------
	-- Stat Summary --
	------------------
	["Stat Summary"] = "능력치 요약",
} end)