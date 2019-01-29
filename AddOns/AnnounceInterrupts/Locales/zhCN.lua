-- zhCN (Simplified Chinese/简体中文) translation
if GetLocale() ~= "zhCN" then return end

local L = AnnounceInterrupts_Locales

L.enable_addon = "启用插件"

L.active_raid = "在团队中启用"
L.active_party = "在5人地下城中启用"
L.active_BG = "在战场中启用"
L.active_arena = "在竞技场中启用"
L.active_scenario = "在剧情动画中启用"
L.active_outdoors = "在野外启用"

L.include_pet_interrupts = "包括来自宠物的打断"
L.channel = "频道:"

L.channel_say = "说"
L.channel_raid = "团队"
L.channel_party = "队伍"
L.channel_instance = "副本"
L.channel_yell = "大喊"
L.channel_self = "自己"
L.channel_emote = "表情"
L.channel_whisper = "密语"
L.channel_custom = "自定频道"

L.output = "信息输出:"

L.hint = "提示:\n%t 将显示为目标\n%sl 将显示为被打断技能的链接\n%sn 将显示为被打断技能的名字\n%sc 将显示为被打断技能的属性种类\n%ys 将显示为你成功使用的打断技能"

L.defualt_message = "我成功打断了 %t 的 %sl"

L.welcome_message = "感谢你安装Announce Interrupts! 你可以通过命令 /ai 来设定。"

L.smart_channel = "智能频道检测"

L.smart_details = "如果你选择的频道不可用,插\n件会自动选择一个可用频道。"
