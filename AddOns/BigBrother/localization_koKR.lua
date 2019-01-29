local L = AceLibrary("AceLocale-2.2"):new("BigBrother")

L:RegisterTranslations("koKR", function() return {
	["Flask Check"] = "영약 확인",
	["Checks for flasks, elixirs and food buffs."] = "공격대의 영약/비약/음식 버프를 확인합니다.",

	["Quick Check"] = "빠른 확인",
	["A quick report that shows who does not have flasks, elixirs or food."] = "영약/비약/음식 버프가 없는 사람을 간단히 확인합니다.",

	["Self"] = "자신",
	["Reports result only to yourself."] = "결과를 자신에게만 보고",

	["Party"] = "파티",
	["Reports result to your party."] = "결과를 파티에 보고",

	["Raid"] = "공격대",
	["Reports result to your raid."] = "결과를 공격대에 보고",

	["Guild"] = "길드",
	["Reports result to guild chat."] = "결과를 길드에 보고",

	["Officer"] = "길드관리자",
	["Reports result to officer chat."] = "결과를 길드관리자에 보고",

	["Whisper"] = "귓속말",
	["Reports result to the currently targeted individual."] = "결과를 현재 대상에 귓속말로 보고",

	["Reports if hostile polymorphs or shackles are broken and by who."] = "변이/속박 풀림과 누구에 의해 풀리는지 보고",

	["Misdirect"] = "눈속임",
	["Reports who gains misdirection."] = "누구에게 눈속임이 걸리는지 보고",

	["BuffCheck"] = "버프확인",
	["Pops up a window to check various raid/elixir buffs (drag the bottom to resize)."] = "여러가지 영약/비약을 확인할 수 있는 창을 띄웁니다. (아래를 드래그하여 크기조절)",

	["Settings"] = "설정",
	["Mod Settings"] = "모드 설정",
	["Raid Groups"] = "공격대 그룹",
	["Set which raid groups are checked for buffs"] = "공격대 그룹의 버프를 검사합니다.",
	["Group 1"] = "그룹 1",
	["Group 2"] = "그룹 2",
	["Group 3"] = "그룹 3",
	["Group 4"] = "그룹 4",
	["Group 5"] = "그룹 5",
	["Group 6"] = "그룹 6",
	["Group 7"] = "그룹 7",
	["Group 8"] = "그룹 8",

	["Checks"] = "확인",
	["Set whether Flasks, Elixirs and Food are included in flaskcheck/quickcheck"] = "영약, 비약, 음식 버프를 영약확인/빠른확인에 포함시킬지 설정합니다.",
	["Flasks"] = "영약",
	["Elixirs"] = "비약",
	["Food Buffs"] = "음식 버프",

	["No Flask"] = "영약 없음",
	["No Flask or Elixir"] = "영약/비약 없음",
	["Only One Elixir"] = "비약 한개",
	["Well Fed"] = "포만감",
	["\"Well Fed\""] = "\"포만감\"",
	["Enlightened"] = "깨달음",
	["Electrified"] = "전기파",
	["No Food Buff"] = "음식 없음",

	["%s cast %s on %s"] = "%s에 눈속임",
	["Polymorph/Misdirect Output"] = "변이/눈속임 출력",
	["Set where the polymorph/misdirect output is sent"] = "변이/눈속임을 어디에 보낼지 설정",
	["Polymorph"] = "변이",
	["Shackle"] = "속박",
	["Hibernate"] = "겨울잠",
	["%s on %s removed by %s's %s"] = "%s: [%s] %s의 %s 해제",
	["%s on %s removed by %s"] = "%s: [%s] %s 해제",
	["CC on %s removed too frequently.  Throttling announcements."] = "%s 군중제어 해제가 너무 자주 일어납니다.  조절중을 알립니다.",

	["Raid Buffs"] = "공격대 버프",
	["Paladin Buffs"] = "성기사 버프",
	["Consumables"] = "소모품",

	-- Consumables
	["Flask of Supreme Power"] = "강력한 마력의 영약",
	["Shattrath Flask of Mighty Restoration"] = "강력한 마나 회복의 샤트라스 영약",
	["Shattrath Flask of Fortification"] = "증강의 샤트라스 영약",
	["Shattrath Flask of Relentless Assault"] = "가혹한 공격의 샤트라스 영약",
	["Shattrath Flask of Supreme Power"] = "강력한 마력의 샤트라스 영약",
	["Shattrath Flask of Pure Death"] = "순수한 죽음의 샤트라스 영약",
	["Shattrath Flask of Blinding Light"] = "눈부신 빛의 샤트라스 영약",
	
	-- Battle Elixirs
	["Fel Strength Elixir"] = "타락한 힘의 비약",
	["Onslaught Elixir"] = "맹공의 비약",
	["Elixir of Major Strength"] = "최상급 힘의 비약",
	["Elixir of Major Agility"] = "최상급 민첩의 비약",
	["Elixir of Mastery"] = "정통의 비약",
	["Elixir of Major Firepower"] = "최상급 화염 강화의 비약",
	["Elixir of Major Shadow Power"] = "최상급 암흑 강화의 비약",
	["Elixir of Major Frost Power"] = "최상급 냉기 강화의 비약",
	["Elixir of Healing Power"] = "치유력 강화의 비약",
	["Elixir of the Mongoose"] = "살쾡이의 비약",
	["Elixir of Greater Firepower"] = "상급 화염 강화의 비약",
	["Bloodberry Elixir"] = "피딸기 비약",

	-- Guardian Elixirs
	["Elixir of Major Defense"] = "일급 방어의 비약",
	["Elixir of Superior Defense"] = "최상급 방어의 비약",
	["Elixir of Major Mageblood"] = "최상급 마력의 비약",
	["Mageblood Potion"] = "마력의 비약",
	["Elixir of Greater Intellect"] = "상급 지능의 비약",
	["Elixir of Empowerment"] = "권능의 비약",
} end)
