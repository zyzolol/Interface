if GetLocale() == "koKR" then	
	Outfitter.cTitle = "Outfitter"
	Outfitter.cTitleVersion = Outfitter.cTitle.." "..Outfitter.cVersion

	Outfitter.cSingleItemFormat = "%s"
	Outfitter.cTwoItemFormat = "%s and %s"
	Outfitter.cMultiItemFormat = "%s{{, %s}} and %s"
	
	Outfitter.cNameLabel = "이름:"
	Outfitter.cCreateUsingTitle = "최적화:"
	Outfitter.cUseCurrentOutfit = "현재 장비 세트 사용"
	Outfitter.cUseEmptyOutfit = "빈 장비 세트 생성"

	Outfitter.cOutfitterTabTitle = "Outfitter"
	Outfitter.cOptionsTabTitle = "옵션"
	Outfitter.cAboutTabTitle = "정보"

	Outfitter.cNewOutfit = "신규 장비 세트"
	Outfitter.cRenameOutfit = "장비 세트 이름 변경"

	Outfitter.cCompleteOutfits = "완비 세트"
	Outfitter.cPartialOutfits = "부분 세트"
	Outfitter.cAccessoryOutfits = "액세서리"
	Outfitter.cSpecialOutfits = "특수 조건"
	Outfitter.cOddsNEndsOutfits = "나머지 장비들"

	Outfitter.cGlobalCategory = "특별 세트"
	Outfitter.cNormalOutfit = "평상시"
	Outfitter.cNakedOutfit = "벗기"

	Outfitter.cFishingOutfit = "낚시"
	Outfitter.cHerbalismOutfit = "약초 채집"
	Outfitter.cMiningOutfit = "채광"
	Outfitter.cLockpickingOutfit = "Lockpicking"
	Outfitter.cSkinningOutfit = "무두질"
	Outfitter.cFireResistOutfit = "화염 저항"
	Outfitter.cNatureResistOutfit = "자연 저항"
	Outfitter.cShadowResistOutfit = "암흑 저항"
	Outfitter.cArcaneResistOutfit = "비전 저항"
	Outfitter.cFrostResistOutfit = "냉기 저항"

	Outfitter.cArgentDawnOutfit = "은빛 여명회"
	Outfitter.cRidingOutfit = "말타기"
	Outfitter.cDiningOutfit = "음식 먹기"
	Outfitter.cBattlegroundOutfit = "전장"
	Outfitter.cABOutfit = "전장: 아라시 분지"
	Outfitter.cAVOutfit = "전장: 알터랙 계곡"
	Outfitter.cWSGOutfit = "전장: 전쟁노래 협곡"
	Outfitter.cArenaOutfit = "전장: 투기장"
	Outfitter.cEotSOutfit = "전장: 폭풍의 눈"
	Outfitter.cCityOutfit = "마을 주변"
	Outfitter.cSwimmingOutfit = "수영"

	Outfitter.cMountSpeedFormat = "이동 속도 (%d+)%%만큼 증가"; -- For detecting when mounted
	Outfitter.cFlyingMountSpeedFormat = "비행 속도 (%d+)%%만큼 증가"; -- For detecting when mounted

	Outfitter.cBagsFullError = "가방이 가득 차서 %s|1을;를; 벗을 수 없습니다."
	Outfitter.cDepositBagsFullError = "가방이 가득 차서 %s|1을;를; 벗을 수 없습니다."
	Outfitter.cWithdrawBagsFullError = "가방이 가득 차서 %s|1을;를; 벗을 수 없습니다."
	Outfitter.cItemNotFoundError = "%s 아이템을 찾을 수 없습니다."
	Outfitter.cItemAlreadyUsedError = "%s|1은;는; 이미 다른 슬롯에서 사용중이므로 %s 슬롯에 착용할 수 없습니다."
	Outfitter.cAddingItem = "%s|1을;를; %s 세트에 추가합니다."
	Outfitter.cNameAlreadyUsedError = "오류: 사용중인 이름입니다."
	Outfitter.cNoItemsWithStatError = "경고: 해당 능력을 가진 아이템이 없습니다."

	Outfitter.cEnableAll = "모두 활성화"
	Outfitter.cEnableNone = "모두 비활성화"

	Outfitter.cConfirmDeleteMsg = "%s 세트를 삭제 하시겠습니까?"
	Outfitter.cConfirmRebuildMsg = "%s 세트를 재구성 하시겠습니까?"
	Outfitter.cRebuild = "재구성"

	Outfitter.cWesternPlaguelands = "서부 역병지대"
	Outfitter.cEasternPlaguelands = "동부 역병지대"
	Outfitter.cStratholme = "스트라솔름"
	Outfitter.cScholomance = "스칼로맨스"
	Outfitter.cNaxxramas = "낙스라마스"
	Outfitter.cAlteracValley = "알터랙 계곡"
	Outfitter.cArathiBasin = "아라시 분지"
	Outfitter.cWarsongGulch = "전쟁노래 협곡"
	Outfitter.cEotS = "폭풍의 눈"
	Outfitter.cIronforge = "아이언포지"
	Outfitter.cCityOfIronforge = "아이언포지"
	Outfitter.cDarnassus = "다르나서스"
	Outfitter.cStormwind = "스톰윈드"
	Outfitter.cOrgrimmar = "오그리마"
	Outfitter.cThunderBluff = "썬더 블러프"
	Outfitter.cUndercity = "언더시티"
	Outfitter.cSilvermoon = "실버문"
	Outfitter.cExodar = "엑소다르"
	Outfitter.cShattrath = "샤트라스"
	Outfitter.cAQ40 = "안퀴라즈 사원"
	Outfitter.cBladesEdgeArena = "칼날 투기장"
	Outfitter.cNagrandArena = "나그란드 투기장"
	Outfitter.cRuinsOfLordaeron = "로데론의 폐허"

	Outfitter.cItemStatFormats =
	{
		{Format = "Minor Mount Speed Increase", Value = 3, Types = {"Riding"}},
		{Format = "Mithril Spurs", Value = 3, Types = {"Riding"}},
		
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
		
		"%+(%d+) (%w+) Spell Damage",
		
		"(%d+) (.+)",
		"(.+) %+(%d+)",
	}

	Outfitter.cItemStatPhrases =
	{
		["stamina"] = "Stamina",
		["intellect"] = "Intellect",
		["agility"] = "Agility",
		["strength"] = "Stength",
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
		
		["spell critical rating"] = "SpellCritRating",
		["spell critical strike rating"] = "SpellCritRating",
		["spell hit rating"] = "SpellHitRating",
		["spell penetration"] = "SpellPen",
		
		["damage and healing done by magical spells and effects"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg", "Healing"},
		["spell damage"] = {"SpellDmg", "ShadowDmg", "FireDmg", "FrostDmg", "ArcaneDmg", "NatureDmg"},
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

	Outfitter.cAgilityStatName = "민첩성"
	Outfitter.cArmorStatName = "방어도"
	Outfitter.cDefenseStatName = "방어 숙련도"
	Outfitter.cIntellectStatName = "지능"
	Outfitter.cSpiritStatName = "정신력"
	Outfitter.cStaminaStatName = "체력"
	Outfitter.cStrengthStatName = "힘"
	Outfitter.cTotalStatsName = "모든 능력치"

	Outfitter.cManaRegenStatName = "마나 회복"
	Outfitter.cHealthRegenStatName = "생명력 회복"

	Outfitter.cSpellCritStatName = "주문 극대화"
	Outfitter.cSpellHitStatName = "주문 적중도"
	Outfitter.cSpellDmgStatName = "주문 공격력"
	Outfitter.cFrostDmgStatName = "냉기 주문 공격력"
	Outfitter.cFireDmgStatName = "화염 주문 공격력"
	Outfitter.cArcaneDmgStatName = "비전 주문 공격력"
	Outfitter.cShadowDmgStatName = "암흑 주문 공격력"
	Outfitter.cNatureDmgStatName = "자연 주문 공격력"
	Outfitter.cHealingStatName = "치유량"

	Outfitter.cMeleeCritStatName = "근접 치명타"
	Outfitter.cMeleeHitStatName = "근접 적중도"
	Outfitter.cMeleeDmgStatName = "근접 공격력"
	Outfitter.cAttackStatName = "전투력"
	Outfitter.cRangedAttackStatName = "원거리 전투력"
	Outfitter.cDodgeStatName = "회피"

	Outfitter.cArcaneResistStatName = "비전 저항력"
	Outfitter.cFireResistStatName = "화염 저항력"
	Outfitter.cFrostResistStatName = "냉기 저항력"
	Outfitter.cNatureResistStatName = "자연 저항력"
	Outfitter.cShadowResistStatName = "암흑 저항력"

	Outfitter.cFishingStatName = "낚시"
	Outfitter.cHerbalismStatName = "약초 채집"
	Outfitter.cMiningStatName = "채광"
	Outfitter.cSkinningStatName = "무두질"

	Outfitter.cOptionsTitle = "Outfitter 옵션"
	Outfitter.cShowMinimapButton = "미니맵 버튼 표시"
	Outfitter.cShowMinimapButtonOnDescription = "미니맵 버튼을 사용하지 않으려면 이 설정을 끄십시오."
	Outfitter.cShowMinimapButtonOffDescription = "미니맵 버튼을 사용하려면 이 설정을 켜십시오."
	Outfitter.cAutoSwitch = "장비 자동-교환"
	Outfitter.cAutoSwitchOnDescription = "장비를 자동적으로 변경하지 않으려면 이 설정을 끄십시오."
	Outfitter.cAutoSwitchOffDescription = "장비를 자동으로 변경하려면 이 설정을 켜십시오."
	Outfitter.cTooltipInfo = "툴팁 표시"
	Outfitter.cTooltipInfoOnDescription = "툴팁에 '사용처:' 정보를 표시하지 않으려면 이 설정을 끄십시오. (착용장비에 마우스을 올렸을 때 프레임율을 향상 시킵니다.)"
	Outfitter.cTooltipInfoOffDescription = "툴팁에 '사용처:' 정보를 표시하려면 이 설정을 켜십시오."
	Outfitter.cRememberVisibility = "망토와 투구 설정 기억"
	Outfitter.cRememberVisibilityOnDescription = "모든 망토와 투구에 대해서 동일한 설정을 하려면 이 설정을 끄십시오."
	Outfitter.cRememberVisibilityOffDescription = "각각의 망토와 투구에 대한 설정을 기억하려면 이 설정을 켜십시오."
	Outfitter.cShowHotkeyMessages = "단축키로 변경할때 보여주기"
	Outfitter.cShowHotkeyMessagesOnDescription = "단축키로 세트를 변경할때 메시지를 보지 않으려면 이 설정을 끄십시오."
	Outfitter.cShowHotkeyMessagesOffDescription = "단축키로 세트를 변경할때 메시지를 보려면 이 설정을 켜십시오."

	Outfitter.cEquipOutfitMessageFormat = "Outfitter: %s 장비됨"
	Outfitter.cUnequipOutfitMessageFormat = "Outfitter: %s 해제됨"

	Outfitter.cURL = "wobbleworks.com"
	Outfitter.cAboutTitle = "Outfitter 정보"
	Outfitter.cAuthor = "Designed and written by John Stephen and Bruce Quinton with contributions by %s"
	Outfitter.cTestersTitle = "Outfitter 4.1 testers"
	Outfitter.cSpecialThanksTitle = "Special thanks to"
	Outfitter.cTranslationCredit = "Translations by %s"
	Outfitter.cURL = "wobbleworks.com"

	Outfitter.cOpenOutfitter = "Outfitter 열기"

	Outfitter.cArgentDawnOutfitDescription = "이 세트는 역병지대에 있을 때 자동으로 착용 됩니다."
	Outfitter.cRidingOutfitDescription = "이 세트는 탈것을 탈 때 자동으로 착용 됩니다."
	Outfitter.cDiningOutfitDescription = "이 세트는 음식을 먹거나 음료를 마실 때 자동으로 착용 됩니다."
	Outfitter.cBattlegroundOutfitDescription = "이 세트는 전장에 있을 때 자동으로 착용 됩니다."
	Outfitter.cArathiBasinOutfitDescription = "이 세트는 아라시 분지에 있을 때 자동으로 착용 됩니다."
	Outfitter.cAlteracValleyOutfitDescription = "이 세트는 알터랙 계곡에 있을 때 자동으로 착용 됩니다."
	Outfitter.cWarsongGulchOutfitDescription = "이 세트는 전쟁노래 협곡에 있을 때 자동으로 착용 됩니다."
	Outfitter.cEotSOutfitDescription = "이 세트는 폭풍의 눈에 있을 때 자동으로 착용 됩니다."
	Outfitter.cCityOutfitDescription = "이 세트는 우호적인 대도시에 있을 때 자동으로 착용 됩니다."
	Outfitter.cSwimmingOutfitDescription = "이 세트는 수영할 때 자동적으로 장착됩니다."

	Outfitter.cKeyBinding = "단축키"

	BINDING_HEADER_OUTFITTER_TITLE = Outfitter.cTitle
	BINDING_NAME_OUTFITTER_OUTFIT = "Outfitter 열기"

	BINDING_NAME_OUTFITTER_OUTFIT1  = "세트 1"
	BINDING_NAME_OUTFITTER_OUTFIT2  = "세트 2"
	BINDING_NAME_OUTFITTER_OUTFIT3  = "세트 3"
	BINDING_NAME_OUTFITTER_OUTFIT4  = "세트 4"
	BINDING_NAME_OUTFITTER_OUTFIT5  = "세트 5"
	BINDING_NAME_OUTFITTER_OUTFIT6  = "세트 6"
	BINDING_NAME_OUTFITTER_OUTFIT7  = "세트 7"
	BINDING_NAME_OUTFITTER_OUTFIT8  = "세트 8"
	BINDING_NAME_OUTFITTER_OUTFIT9  = "세트 9"
	BINDING_NAME_OUTFITTER_OUTFIT10 = "세트 10"

	Outfitter.cShowHelm = "투구 보이기"
	Outfitter.cShowCloak = "망토 보이기"
	Outfitter.cHideHelm = "투구 숨기기"
	Outfitter.cHideCloak = "망토 숨기기"

	Outfitter.cDisableOutfit = "세트 사용 안함"
	Outfitter.cDisableOutfitInBG = "전장에서 사용 안함"
	Outfitter.cDisableOutfitInCombat = "전투중 사용 안함"
	Outfitter.cDisableOutfitInAQ40 = "안퀴라즈 사원 내 사용 안함"
	Outfitter.cDisableOutfitInNaxx = "낙스라마스 내 사용 안함"
	Outfitter.cDisabledOutfitName = "%s (사용 안함)"
	
	Outfitter.cOutfitBar = "Outfit Bar"
	Outfitter.cShowInOutfitBar = "Show in outfit bar"
	Outfitter.cChangeIcon = "Choose icon..."
	
	Outfitter.cMinimapButtonTitle = "미니맵 버튼"
	Outfitter.cMinimapButtonDescription = "클릭 : 세트 선택, 드래그 : 미니맵 버튼 이동"

	Outfitter.cClassName.DRUID = "드루이드"
	Outfitter.cClassName.HUNTER = "사냥꾼"
	Outfitter.cClassName.MAGE = "마법사"
	Outfitter.cClassName.PALADIN = "성기사"
	Outfitter.cClassName.PRIEST = "사제"
	Outfitter.cClassName.ROGUE = "도적"
	Outfitter.cClassName.SHAMAN = "주술사"
	Outfitter.cClassName.WARLOCK = "흑마법사"
	Outfitter.cClassName.WARRIOR = "전사"
	
	Outfitter.cBattleStance = "전투 태세"
	Outfitter.cDefensiveStance = "방어 태세"
	Outfitter.cBerserkerStance = "광폭 태세"

	Outfitter.cWarriorBattleStance = "전사: 전투 태세"
	Outfitter.cWarriorDefensiveStance = "전사: 방어 태세"
	Outfitter.cWarriorBerserkerStance = "전사: 광폭 태세"

	Outfitter.cBearForm = "곰 변신"
	Outfitter.cFlightForm = "폭풍까마귀 변신"
	Outfitter.cSwiftFlightForm = "빠른 폭풍까마귀 변신"
	Outfitter.cCatForm = "표범 변신"
	Outfitter.cAquaticForm = "바다표범 변신"
	Outfitter.cTravelForm = "치타 변신"
	Outfitter.cDireBearForm = "광포한 곰 변신"
	Outfitter.cMoonkinForm = "달빛야수 변신"
	Outfitter.cTreeOfLifeForm = "생명의 나무"

	Outfitter.cGhostWolfForm = "늑대 정령"

	Outfitter.cStealth = "은신"

	Outfitter.cDruidBearForm = "드루이드: 곰 변신"
	Outfitter.cDruidCatForm = "드루이드: 표범 변신"
	Outfitter.cDruidAquaticForm = "드루이드: 바다표범 변신"
	Outfitter.cDruidTravelForm = "드루이드: 치타 변신"
	Outfitter.cDruidMoonkinForm = "드루이드: 달빛야수 변신"
	Outfitter.cDruidFlightForm = "드루이드: 폭풍까마귀 변신"
	Outfitter.cDruidSwiftFlightForm = "드루이드: 빠른 폭풍까마귀 변신"
	Outfitter.cDruidTreeOfLifeForm = "드루이드: 생명의 나무"
	Outfitter.cDruidProwl = "드루이드: 숨기"
	Outfitter.cProwl = "숨기"
	
	Outfitter.cPriestShadowform = "사제: 어둠의 형상"

	Outfitter.cRogueStealth = "도적: 은신"

	Outfitter.cShamanGhostWolf = "주술사: 늑대 정령"

	Outfitter.cHunterMonkey = "사냥꾼: 원숭이의 상"
	Outfitter.cHunterHawk =  "사냥꾼: 매의 상"
	Outfitter.cHunterCheetah =  "사냥꾼: 치타의 상"
	Outfitter.cHunterPack =  "사냥꾼: 치타 무리의 상"
	Outfitter.cHunterBeast =  "사냥꾼: 야수의 상"
	Outfitter.cHunterWild =  "사냥꾼: 야생의 상"
	Outfitter.cHunterViper = "사냥꾼: 독사의 상"

	Outfitter.cMageEvocate = "마법사: 환기"

	Outfitter.cAspectOfTheCheetah = "치타의 상"
	Outfitter.cAspectOfThePack = "치타 무리의 상"
	Outfitter.cAspectOfTheBeast = "야수의 상"
	Outfitter.cAspectOfTheWild = "야생의 상"
	Outfitter.cAspectOfTheViper = "독사의 상"
	Outfitter.cEvocate = "환기"

	Outfitter.cCompleteCategoryDescription = "모든 슬롯의 아이템에 관한 설정이 들어있는 완전한 장비 세트입니다."
	Outfitter.cPartialCategoryDescription = "Mix-n-match의 장비 세트는 전부가 아닌 일부 슬롯만 가집니다. 장비 세트가 선택되면 이전에 선택되었던 보조 장비 세트 또는 Mix-n-match 세트를 대체하면서, 완비 세트에서 해당 아이템만을 교체합니다."
	Outfitter.cAccessoryCategoryDescription = "보조 장비의 장비 세트는 전부가 아닌 일부 슬롯만 가집니다. Mix-n-match와는 다르게 이전에 선택되었던 보조 장비 세트 또는 Mix-n-match 세트를 대체하지 않고 추가로 완비 세트에서 해당 아이템을 교체합니다."
	Outfitter.cSpecialCategoryDescription = "특수 조건의 장비 세트는 해당하는 조건을 충족시킬 경우 자동으로 착용됩니다."
	Outfitter.cOddsNEndsCategoryDescription = "나머지 장비들의 아이템들은 장비 세트에 한번도 사용되지 않은 아이템들입니다."

	Outfitter.cRebuildOutfitFormat = "%s 재구성"

	Outfitter.cSlotEnableTitle = "슬롯 활성화"
	Outfitter.cSlotEnableDescription = "슬롯을 활성화 하면 해당 장비 세트를 사용할때 같이 변경됩니다."

	Outfitter.cFinger0SlotName = "첫번째 손가락"
	Outfitter.cFinger1SlotName = "두번째 손가락"

	Outfitter.cTrinket0SlotName = "첫번째 장신구"
	Outfitter.cTrinket1SlotName = "두번째 장신구"

	Outfitter.cOutfitCategoryTitle = "카테고리"
	Outfitter.cBankCategoryTitle = "은행"
	Outfitter.cDepositToBank = "모든 아이템을 은행으로"
	Outfitter.cDepositUniqueToBank = "특정 아이템을 은행으로"
	Outfitter.cWithdrawFromBank = "은행으로부터 아이템 회수"

	Outfitter.cMissingItemsLabel = "찾을 수 없는 아이템: "
	Outfitter.cBankedItemsLabel = "은행에 있는 아이템: "

	Outfitter.cStatsCategory = "능력치"
	Outfitter.cMeleeCategory = "근접"
	Outfitter.cSpellsCategory = "주문과 치유"
	Outfitter.cRegenCategory = "회복"
	Outfitter.cResistCategory = "저항"
	Outfitter.cTradeCategory = "전문기술"

	Outfitter.cTankPoints = "탱크 포인트"
	Outfitter.cCustom = "사용자 설정"

	Outfitter.cScript = "스크립트"
	Outfitter.cDisableScript = "스크립트 비활성화"
	Outfitter.cEditScriptTitle = "%s 세트에 대한 스크립트"
	Outfitter.cEditScriptEllide = "스크립트 편집..."
	Outfitter.cEventsLabel = "이벤트:"
	Outfitter.cScriptLabel = "스크립트:"
	Outfitter.cSetCurrentItems = "현재 아이템으로 갱신"
	Outfitter.cConfirmSetCurrentMsg = "%s|1을;를; 현재 착용 장비를 사용하여 갱신하시겠습니까? 주의: 세트에 현재 활성화된 슬롯만 갱신됩니다. -- 적용후 추가적으로 슬롯을 변경할 수 있습니다."
	Outfitter.cSetCurrent = "갱신"
	Outfitter.cTyping = "입력..."
	Outfitter.cScriptErrorFormat = "%d 라인 오류: %s"
	Outfitter.cExtractErrorFormat = "%[문자열 \"장비 스크립트\"%]:(%d+):(.*)"
	Outfitter.cPresetScript = "미리 정의된 스크립트:"
	Outfitter.cCustomScript = "사용자 정의"
	Outfitter.cSettings = "설정"
	Outfitter.cSource = "원본"
	Outfitter.cInsertFormat = "<- %s"

	Outfitter.cContainerBagSubType = "가방"
	Outfitter.cUsedByPrefix = "장비 세트: "

	Outfitter.cNone = "없음"
	Outfitter.cUseDurationTooltipLineFormat = "^사용 효과: (%d+) seconds"

	Outfitter.cAutoChangesDisabled = "Automated changes are now disabled"
	Outfitter.cAutoChangesEnabled = "Automated changes are now enabled"
end
