local L = AceLibrary("AceLocale-2.2"):new("BigBrother")

L:RegisterTranslations("zhTW", function() return {
	["Flask Check"] = "詳細檢查",
	["Checks for flasks, elixirs and food buffs."] = "詳細檢查精煉/藥劑/食物 buffs",

	["Quick Check"] = "快速檢查",
	["A quick report that shows who does not have flasks, elixirs or food."] = "快速檢查回報誰沒有藥水/藥劑/食物 buffs",

	["Self"] = "自己",
	["Reports result only to yourself."] = "只對自己報告結果",

	["Party"] = "隊伍",
	["Reports result to your party."] = "在隊伍報告結果",

	["Raid"] = "團隊",
	["Reports result to your raid."] = "在團隊報告結果",

	["Guild"] = "公會",
	["Reports result to guild chat."] = "在公會報告結果",

	["Officer"] = "公會管理",
	["Reports result to officer chat."] = "在公會管理報告結果",
	
	["Whisper"] = "密語",
	["Reports result to the currently targeted individual."] = "選定目標密語報告結果",

	["Reports if hostile polymorphs or shackles are broken and by who."] = "報告是誰打了變羊和束縛不死生物的怪",

	["Misdirect"] = "誤導",
	["Reports who gains misdirection."] = "報告誰獲得誤導",

	["BuffCheck"] = "狀態檢查",
	["Pops up a window to check various raid/elixir buffs (drag the bottom to resize)."] = "顯示一個視窗檢查各種團隊/藥水 buffs (拖曳底部可以控制大小)",

	["Settings"] = "設定",
	["Mod Settings"] = "設定模組",
	["Raid Groups"] = "團隊隊伍",
	["Set which raid groups are checked for buffs"] = "設定哪些隊伍檢查 buffs",
	["Group 1"] = "隊伍 1",
	["Group 2"] = "隊伍 2",
	["Group 3"] = "隊伍 3",
	["Group 4"] = "隊伍 4",
	["Group 5"] = "隊伍 5",
	["Group 6"] = "隊伍 6",
	["Group 7"] = "隊伍 7",
	["Group 8"] = "隊伍 8",
  
	["Checks"] = "檢查",
	["Set whether Flasks, Elixirs and Food are included in flaskcheck/quickcheck"] = "在詳細檢查/快速檢查設定是否檢查精煉、藥劑和食物 buffs",
	["Flasks"] = "精煉",
	["Elixirs"] = "藥劑",
	["Food Buffs"] = "食物 buffs",
	
	["No Flask"] = "沒精煉藥劑",
	["No Flask or Elixir"] = "沒精煉或藥劑",
	["Only One Elixir"] = "只有一種藥劑",
	["Well Fed"] = "充分進食",
	["\"Well Fed\""] = "「沉醉」",
	["Enlightened"] = "啟發",
	["Electrified"] = "負電",
	["No Food Buff"] = "沒吃食物",

	["%s cast %s on %s"] = "%s 獲得了誤導",
	["Polymorph/Misdirect Output"] = "變形術/誤導資訊提示",
	["Set where the polymorph/misdirect output is sent"] = "設置將變形術/誤導資訊發送至何處",
	["Polymorph"] = "變形術",
	["Shackle"] = "束縛不死生物",
	["Hibernate"] = "休眠",
	["%s on %s removed by %s's %s"] = "%s （%s）被 %s 的 %s 移除了",
	["%s on %s removed by %s"] = "%s （%s）被 %s 移除了",
	["CC on %s removed too frequently.  Throttling announcements."] = "CC 在 %s 被移除過於頻繁. 關閉訊息發送",

	["Raid Buffs"] = "團隊 buffs",
	["Paladin Buffs"] = "聖騎 buffs",
	["Consumables"] = "消耗品",
	
	-- Consumables 消耗品/精煉
	["Flask of Supreme Power"] = "超級能量精煉藥劑",
	["Shattrath Flask of Mighty Restoration"] = "撒塔斯強力恢復精煉藥劑",
	["Shattrath Flask of Fortification"] = "撒塔斯防禦壁壘精煉藥劑",
	["Shattrath Flask of Relentless Assault"] = "撒塔斯無情攻擊精煉藥劑",
	["Shattrath Flask of Supreme Power"] = "撒塔斯極效法傷精煉藥劑",
	["Shattrath Flask of Pure Death"] = "撒塔斯純淨死亡精煉藥劑",
	["Shattrath Flask of Blinding Light"] = "撒塔斯盲目之光精煉藥劑",

	-- Battle Elixirs 作戰藥劑
	["Fel Strength Elixir"] = "魔化力量藥劑",
	["Onslaught Elixir"] = "猛擊藥劑",
	["Elixir of Major Strength"] = "極效力量藥劑",
	["Elixir of Major Agility"] = "極效敏捷藥劑",
	["Elixir of Mastery"] = "精通藥劑",
	["Elixir of Major Firepower"] = "極效火焰之力藥劑",
	["Elixir of Major Shadow Power"] = "極效暗影之力藥劑",
	["Elixir of Major Frost Power"] = "極效冰霜之力藥劑",
	["Elixir of Healing Power"] = "治療能量藥劑",
	["Elixir of the Mongoose"] = "貓鼬藥劑",
	["Elixir of Greater Firepower"] = "強效火力藥劑",
	["Bloodberry Elixir"] = "血莓藥劑",

	-- Guardian Elixirs 守護藥劑
	["Elixir of Major Defense"] = "極效防禦藥劑",
	["Elixir of Superior Defense"] = "超強防禦藥劑",
	["Elixir of Major Mageblood"] = "極效魔血藥劑",
	["Mageblood Potion"] = "魔血藥水",
	["Elixir of Greater Intellect"] = "強效聰穎藥劑",
	["Elixir of Empowerment"] = "活效藥劑",
} end)
