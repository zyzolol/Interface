local L = LibStub("AceLocale-3.0"):NewLocale("Procodile", "zhCN", false)
if not L then return end

L["PROCODILE_DESC"] = "采集几率式法术的触发几率和状态。"

L["OPTIONS_NAME"] = "选项"
L["OPTIONS_DESC"] = "Procodile的基本选项。"

L["SPELLS_NAME"] = "法术"
L["SPELLS_DESC"] = "设置哪些法术需要追踪。"

L["TOGGLE_PROCODILE"] = "打开/关闭Procodile。"

L["TOGGLE_ENABLED"] = "开始追踪"
L["TOGGLE_DISABLED"] = "结束追踪"

L["SHOWSPELLS_NAME"] = "法术调试"
L["SHOWSPELLS_DESC"] = "在聊天窗口显示你想Procodile追踪的法术的信息。当你想要加入新的法术并想获取其ID的时候非常有用。"

L["COMBATONLY_NAME"] = "仅战斗状态"
L["COMBATONLY_DESC"] = "Procodile将会仅在战斗状态下自动开启。这将会使你想要的每分钟触发率和内置CD更加精准。"

L["SELFSPELLS_NAME"] = "自我施法法术"
L["SELFSPELLS_DESC"] = "这个将会追踪给你自己的Buff的几率。"

L["VERBOSE_NAME"] = "详情"
L["VERBOSE_DESC"] = "在聊天窗口显示追踪启用或者禁用，以及追踪的技能开始和结束的情况。"

L["COOLDOWNS_NAME"] = "显示冷却计时条"
L["COOLDOWNS_DESC"] = "给内置冷却计时的技能一个内置冷却计时条。"

L["MOVABLECOOLDOWNS_NAME"] = "可以动计时条"
L["MOVABLECOOLDOWNS_DESC"] = "给冷却计时条一个锚点以方便你拖动。"

L["ANNOUNCE_NAME"] = "冷却计时通告"
L["ANNOUNCE_DESC"] = "在战斗文字区域显示冷却结束文字。"

L["FONTSIZE_NAME"] = "字体大小"
L["FONTSIZE_DESC"] = "设置冷却计时条的文字大小。"

L["BARWIDTH_NAME"] = "计时条宽度"
L["BARWIDTH_DESC"] = "设置冷却计时条的宽度。"

L["BARHEIGHT_NAME"] = "计时条高度"
L["BARHEIGHT_DESC"] = "设置冷却计时条的高度。"

L["BARTEST_NAME"] = "测试计时条"
L["BARTEST_DESC"] = "显示一个测试计时条以方便你拖拽。"

L["BARS_NAME"] = "冷却计时条"
L["BARS_DESC"] = "冷却计时条的相关配置选项。"

L["BARFONT_NAME"] = "计时条字体"
L["BARFONT_DESC"] = "设置冷却计时条使用的字体。"

L["BARTEXTURE_NAME"] = "计时条材质"
L["BARTEXTURE_DESC"] = "设置冷却计时条使用的材质。"

L["CUSTOM_NAME"] = "自定义法术"
L["CUSTOM_DESC"] = "你可以在这里增加你想要追踪的法术。法术ID可以在'法术调试'选项打开时获取，自定义法术不会像内置法术一样自动移除，并且其名字和图标都是这个法术自身拥有的。"

L["NEWCUSTOM_NAME"] = "增加自定义法术"
L["NEWCUSTOM_DESC"] = "请键入一个法术ID以开始对其进行追踪。"

L["REMOVECUSTOM_NAME"] = "移除自定义法术"
L["REMOVECUSTOM_DESC"] = "选择一个自定义法术来停止对其进行追踪。"

--ProcodileFu.lua
L["Procodile"] = "触发统计器(Procodile)"
L["Procs"] = "触发率"
L["PPM"] = "每分钟触发率"
L["Uptime"] = "持续时间"
L["Cooldown"] = "冷却时间"
L["Hint: Ctrl-Click to reset."] = "提示：Ctrl+点击重置。"
L["Shift-click to toggle tracking."] = "Shift+点击切换是否追踪。"
L["Right-click to configure"] = "右键点击打开配置窗口。"
