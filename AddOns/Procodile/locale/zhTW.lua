local L = LibStub("AceLocale-3.0"):NewLocale("Procodile", "zhTW", false)
if not L then return end

L["PROCODILE_DESC"] = "收集並統計觸發式法術的幾率和狀態"

L["OPTIONS_NAME"] = "選項"
L["OPTIONS_DESC"] = "Procodile 基本選項"

L["SPELLS_NAME"] = "法術"
L["SPELLS_DESC"] = "設定哪些法術需要追蹤"

L["TOGGLE_PROCODILE"] = "打開/關閉 Procodile"

L["TOGGLE_ENABLED"] = "開始追蹤"
L["TOGGLE_DISABLED"] = "結束追蹤"

L["SHOWSPELLS_NAME"] = "診斷法術"
L["SHOWSPELLS_DESC"] = "在聊天視窗顯示你想 Procodile 追蹤的法術的信息。當你想要加入新的法術並想獲取其 ID 的時候非常有用。"

L["COMBATONLY_NAME"] = "僅戰鬥狀態"
L["COMBATONLY_DESC"] = "Procodile 僅在戰鬥狀態下自動開啟。這將會使你想要的每分鐘觸發率和內建 CD 更加精準。"

L["SELFSPELLS_NAME"] = "自我施法法術"
L["SELFSPELLS_DESC"] = "這個將會追蹤給你自己的 Buff 的幾率"

L["VERBOSE_NAME"] = "詳情"
L["VERBOSE_DESC"] = "在聊天視窗顯示追蹤開啟或關閉，以及追蹤的技能開始和結束的情況。"

L["COOLDOWNS_NAME"] = "顯示冷卻計時條"
L["COOLDOWNS_DESC"] = "給內建冷卻計時的技能一個內建冷卻計時條"

L["MOVABLECOOLDOWNS_NAME"] = "可移動計時條"
L["MOVABLECOOLDOWNS_DESC"] = "給冷卻計時條一個錨點以方便你拖動"

L["ANNOUNCE_NAME"] = "冷卻計時通告"
L["ANNOUNCE_DESC"] = "在戰鬥文字區域顯示冷卻結束文字"

L["FONTSIZE_NAME"] = "字體大小"
L["FONTSIZE_DESC"] = "設定冷卻計時條的文字大小"

L["BARWIDTH_NAME"] = "計時條寬度"
L["BARWIDTH_DESC"] = "設定冷卻計時條的寬度"

L["BARHEIGHT_NAME"] = "計時條高度"
L["BARHEIGHT_DESC"] = "設定冷卻計時條的高度"

L["BARTEST_NAME"] = "測試計時條"
L["BARTEST_DESC"] = "顯示測試計時條"

L["BARS_NAME"] = "冷卻計時條"
L["BARS_DESC"] = "冷卻計時條的相關配置選項"

L["BARFONT_NAME"] = "計時條字體"
L["BARFONT_DESC"] = "設定冷卻計時條使用的字體"

L["BARTEXTURE_NAME"] = "計時條材質"
L["BARTEXTURE_DESC"] = "設定冷卻計時條使用的材質"

L["CUSTOM_NAME"] = "自定義法術"
L["CUSTOM_DESC"] = "你可以在這裡增加你想要追蹤的法術。法術 ID 可以在'診斷法術'選項打開時獲取，自定義法術不會像內建法術一樣自動移除，並且其名字和圖標都是這個法術自身擁有的。"

L["NEWCUSTOM_NAME"] = "增加自定義法術"
L["NEWCUSTOM_DESC"] = "請輸入一個法術 ID 以開始對其進行追蹤"

L["REMOVECUSTOM_NAME"] = "移除自定義法術"
L["REMOVECUSTOM_DESC"] = "選擇一個自定義法術來停止對其進行追蹤"

--ProcodileFu.lua
L["Procodile"] = "觸發統計器 (Procodile)"
L["Procs"] = "觸發率"
L["PPM"] = "每分鐘觸發率"
L["Uptime"] = "持續時間"
L["Cooldown"] = "冷卻時間"
L["Hint: Ctrl-Click to reset."] = "提示: Ctrl+點擊重置"
L["Shift-click to toggle tracking."] = "Shift+點擊切換是否追蹤"
L["Right-click to configure"] = "右鍵點擊打開設定視窗"
