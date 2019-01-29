-- zhTW （Traditional Chinese/繁體中文） translation
if GetLocale() ~= "zhTW" then return end

local L = AnnounceInterrupts_Locales

L.enable_addon = "啟用插件"

L.active_raid = "在團隊中啟用"
L.active_party = "在5人副本中啟用"
L.active_BG = "在戰場中啟用"
L.active_arena = "在競技場中啟用"
L.active_scenario = "在劇情中啟用"
L.active_outdoors = "在野外啟用"

L.include_pet_interrupts = "包括來自寵物的打斷"
L.channel = "頻道:"

L.channel_say = "說"
L.channel_raid = "團隊"
L.channel_party = "隊伍"
L.channel_instance = "副本"
L.channel_yell = "大喊"
L.channel_self = "自己"
L.channel_emote = "表情"
L.channel_whisper = "密語"
L.channel_custom = "自定頻道"

L.output = "輸出:"

L.hint = "提示:\n%t 將顯示為目標\n%sl 將顯示為被打斷技能鏈接\n%sn 將顯示為被打斷技能名\n%sc 將顯示為被打斷技能的屬性種類\n%ys 將顯示為你成功使用的打斷技能"

L.defualt_message = "我成功打斷了 %t 的 %sl"

L.welcome_message = "感謝你安裝Announce Interrupts! 你可以透過命令 /ai 來設定。"

L.smart_channel = "智能頻道檢測"

L.smart_details = "如果你選擇的頻道\n不可用, 插件會自動選擇\n一個其他頻道。"
