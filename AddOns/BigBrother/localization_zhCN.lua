local L = AceLibrary("AceLocale-2.2"):new("BigBrother")

L:RegisterTranslations("zhCN", function() return {
	["Flask Check"] = "合剂检查",
	["Checks for flasks, elixirs and food buffs."] = "检查合剂，药剂，及食物增益",
  
  ["Quick Check"] = "快速检查",
	["A quick report that shows who does not have flasks, elixirs or food."] = "快速报告谁没有合剂，药剂，及食物效果",

	["Self"] = "自身",
	["Reports result only to yourself."] = "仅报告给自己看",

	["Party"] = "小队",
	["Reports result to your party."] = "把结果报告到小队",

	["Raid"] = "团队",
	["Reports result to your raid."] = "把结果报告到团队",

	["Guild"] = "公会",
	["Reports result to guild chat."] = "把结果报告到公会",

	["Officer"] = "官员",
	["Reports result to officer chat."] = "把结果报告到官员频道",
  
  ["Whisper"] = "密语",
	["Reports result to the currently targeted individual."] = "把结果密语报告给目标玩家",

	["Reports if hostile polymorphs or shackles are broken and by who."] = "报告是否有人将敌对的变形术或束缚亡灵被打破",

	["Misdirect"] = "误导",
	["Reports who gains misdirection."] = "报告谁获得了误导效果",

	["BuffCheck"] = "增益检查",
	["Pops up a window to check various raid/elixir buffs (drag the bottom to resize)."] = "打开一个窗口以检查各种团队/药剂增益效果（可以拖动放大缩小）",

  ["Settings"] = "设置",
  ["Mod Settings"] = "模块设置",
  ["Raid Groups"] = "团队队伍",
  ["Set which raid groups are checked for buffs"] = "设置要检查哪些队伍的增益效果",
  ["Group 1"] = "队伍1",
  ["Group 2"] = "队伍2",
  ["Group 3"] = "队伍3",
  ["Group 4"] = "队伍4",
  ["Group 5"] = "队伍5",
  ["Group 6"] = "队伍6",
  ["Group 7"] = "队伍7",
  ["Group 8"] = "队伍8",
  
  ["Checks"] = "检查",
  ["Set whether Flasks, Elixirs and Food are included in flaskcheck/quickcheck"] = "设置合剂，药剂，及食物是否要包括于合剂检查/快速检查",
  ["Flasks"] = "合剂",
  ["Elixirs"] = "药剂",
  ["Food Buffs"] = "增益食物",
  
	["No Flask"] = "无合剂",
	["No Flask or Elixir"] = "无合剂或药剂",
	["Only One Elixir"] = "仅有一种药剂",
	["Well Fed"] = "充分进食",
	["\"Well Fed\""] = "【沉醉】",
  ["No Food Buff"] = "没吃食物",

  ["%s cast %s on %s"] = "%s 获得了误导",
  ["Polymorph/Misdirect Output"] = "变形术/误导信息提示",
  ["Set where the polymorph/misdirect output is sent"] = "设置将变形术/误导信息发送至何处",
  ["Polymorph"] = "变形术",
  ["Shackle"] = "束缚亡灵",
  ["%s on %s removed by %s's %s"] = "%s （%s）被 %s 的 %s 打破了",
	["%s on %s removed by %s"] = "%s （%s）被 %s 打破了",
--	["CC on %s removed too frequently.  Throttling announcements."] = "",

	["Raid Buffs"] = "团队增益",
	["Paladin Buffs"] = "圣骑士增益",
	["Consumables"] = "消耗品",

	-- Consumables（消耗品）
	["Flask of Supreme Power"] = "超级能量合剂",
	["Shattrath Flask of Mighty Restoration"] = "沙塔斯强效回复合剂",
	["Shattrath Flask of Fortification"] = "沙塔斯强固合剂",
	["Shattrath Flask of Relentless Assault"] = "沙塔斯无情突袭合剂",
	["Shattrath Flask of Supreme Power"] = "沙塔斯超级能量合剂",
	["Shattrath Flask of Pure Death"] = "沙塔斯纯粹死亡合剂",
	["Shattrath Flask of Blinding Light"] = "沙塔斯盲目光芒合剂",
	
	-- Battle Elixirs（战斗药剂）
	["Fel Strength Elixir"] = "魔能力量药水",
	["Onslaught Elixir"] = "强攻药剂",
	["Elixir of Major Strength"] = "特效力量药剂",
	["Elixir of Major Agility"] = "特效敏捷药剂",
	["Elixir of Mastery"] = "掌控药剂",
	["Elixir of Major Firepower"] = "特效火力药剂",
	["Elixir of Major Shadow Power"] = "暗影之力药剂",
	["Elixir of Major Frost Power"] = "冰霜之力药剂",
	["Elixir of Healing Power"] = "治疗能量药剂",
	["Elixir of the Mongoose"] = "猫鼬药剂",
	["Elixir of Greater Firepower"] = "强效火力药剂",
	--["Bloodberry Elixir"] = "",

	-- Guardian Elixirs（守护药剂）
	["Elixir of Major Defense"] = "特效防御药剂",
	["Elixir of Superior Defense"] = "超强防御药剂",
	["Elixir of Major Mageblood"] = "特效魔血药剂",
	["Mageblood Potion"] = "魔血药剂",
	["Elixir of Greater Intellect"] = "强效聪颖药剂",
	["Elixir of Empowerment"] = "强化药剂",
} end)
