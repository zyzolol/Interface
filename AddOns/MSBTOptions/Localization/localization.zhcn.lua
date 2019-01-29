----------------------------------------------------------------------------
-- Title: MSBT Options Simplified Chinese Localization
-- Author: Mik
-- Simplified Chinese Translation by: elafor, hscui
-------------------------------------------------------------------------------

-- Don't do anything if the locale isn't Simplified Chinese.
if (GetLocale() ~= "zhCN") then return; end

-- Local reference for faster access.
local L = MikSBT.translations;

-------------------------------------------------------------------------------
-- Simplified Chinese localization
-------------------------------------------------------------------------------


------------------------------
-- Interface messages
------------------------------

L.MSG_NEW_PROFILE					= "新建配置";
L.MSG_PROFILE_ALREADY_EXISTS		= "此配置文件已存在";
L.MSG_INVALID_PROFILE_NAME			= "无效的配置名字";
L.MSG_NEW_SCROLL_AREA				= "新建滚动区域";
L.MSG_SCROLL_AREA_ALREADY_EXISTS	= "此滚动区域已存在";
L.MSG_INVALID_SCROLL_AREA_NAME		= "无效的滚动区名字";
L.MSG_ACKNOWLEDGE_TEXT				= "你确定想这样做吗？";
L.MSG_NORMAL_PREVIEW_TEXT			= "普通文字";
L.MSG_INVALID_SOUND_FILE			= "声音必须为MP3或WAV文件。";
L.MSG_NEW_TRIGGER					= "新建触发器";
L.MSG_TRIGGER_CLASSES				= "触发种类";
--L.MSG_MAIN_EVENTS					= "Main Events";
--L.MSG_TRIGGER_EXCEPTIONS			= "Trigger Exceptions";
--L.MSG_EVENT_CONDITIONS				= "Event Conditions";
L.MSG_SKILLS						= "技能";
L.MSG_SKILL_ALREADY_EXISTS			= "技能名字已存在";
L.MSG_INVALID_SKILL_NAME			= "无效的技能名字";
--L.MSG_HOSTILE						= "Hostile";
--L.MSG_ANY							= "Any";
--L.MSG_CONDITION						= "Condition";
--L.MSG_CONDITIONS					= "Conditions";


------------------------------
-- Class Names.
------------------------------

local obj = L.CLASS_NAMES;
obj["DRUID"]	= "德鲁伊";
obj["HUNTER"]	= "猎人";
obj["MAGE"]		= "法师";
obj["PALADIN"]	= "圣骑士";
obj["PRIEST"]	= "牧师";
obj["ROGUE"]	= "潜行者";
obj["SHAMAN"]	= "萨满祭司";
obj["WARLOCK"]	= "术士";
obj["WARRIOR"]	= "战士";


------------------------------
-- Interface tabs
------------------------------

obj = L.TABS;
obj[1] = { label="总体", tooltip="总体设置"};
obj[2] = { label="滚动区域", tooltip="创建、删除和配置滚动区域；鼠标指向按钮可得到更多提示"};
obj[3] = { label="事件", tooltip="设置承受伤害、输出伤害和通告的事件；鼠标指向按钮可得到更多提示"};
obj[4] = { label="触发器", tooltip="设置触发器；鼠标指向按钮可得到更多提示"};
obj[5] = { label="预防刷屏", tooltip="设置对可能造成刷屏的信息进行控制"};
obj[6] = { label="冷却通告", tooltip="设置冷却通告"};
obj[7] = { label="技能图标", tooltip="设置技能图标"};


------------------------------
-- Interface checkboxes
------------------------------

obj = L.CHECKBOXES;
obj["enableMSBT"]				= { label="启用MSBT", tooltip="启用MSBT"};
obj["stickyCrits"]				= { label="爆击粘滞显示", tooltip="使用粘滞样式显示爆击"};
obj["gameDamage"]				= { label="游戏内置伤害", tooltip="在敌人头上显示游戏内置伤害信息"};
obj["gameHealing"]				= { label="游戏内置治疗", tooltip="在目标头上显示游戏内置治疗信息"};
obj["enableSounds"]				= { label="启用声音", tooltip="当指定事件和触发器发生时播放声音"};
obj["colorPartialEffects"]		= { label="特效着色", tooltip="给某些特殊战斗效果的信息着色"};
obj["crushing"]					= { label="碾压", tooltip="显示碾压提示"};
obj["glancing"]					= { label="偏斜", tooltip="显示偏斜提示"};
obj["absorb"]					= { label="部分吸收", tooltip="显示部分吸收数值"};
obj["block"]					= { label="部分格挡", tooltip="显示部分格挡数值"};
obj["resist"]					= { label="部分抵抗", tooltip="显示部分抵抗数值"};
obj["vulnerability"]			= { label="易伤加成", tooltip="显示易伤加成数值"};
obj["overheal"]					= { label="过量治疗", tooltip="显示过量治疗数值"};
obj["colorDamageAmounts"]		= { label="伤害数值着色", tooltip="为伤害值着色"};
obj["colorDamageEntry"]			= { tooltip="为此类伤害着色"};
obj["enableScrollArea"]			= { tooltip="启用滚动区域"};
obj["inheritField"]				= { label="继承", tooltip="继承此区域的值，不勾选则无效"};
obj["stickyEvent"]				= { label="始终粘滞", tooltip="总是使用粘滞样式显示事件"};
obj["enableTrigger"]			= { tooltip="启用触发器"};
obj["allPowerGains"]			= { label="所有能量获取", tooltip="显示所有获取的能量包括那些战斗日志中不显示的。警告：这个选项将会大量刷屏同时无视能量阈值和抑制显示设置\n不推荐"};
obj["hyperRegen"]				= { label="超级回复", tooltip="显示从快速回复技能（比如唤醒和精神分流）中获取的能量数值；注意：此显示无法抑制显示"};
obj["abbreviateSkills"]			= { label="技能简称", tooltip="简缩技能名字（仅适用于英文版）。若事件描述中加入“%sl”代码，此选项即失效"};
obj["hideSkills"]				= { label="隐藏技能", tooltip="在承受伤害和输出伤害中不显示技能名字。开启此选项将使你失去某些事件自定义功能，因为它会忽略“%s”代码"};
obj["hideNames"]				= { label="隐藏名字", tooltip="在承受伤害和输出伤害中不显示单位名字。开启此选项将使你失去某些事件自定义功能，因为它会忽略“%n”代码"};
obj["allClasses"]				= { label="所有职业"};
obj["enableCooldowns"]			= { label="启用冷却", tooltip="当冷却结束时显示通告"};
obj["enableIcons"]				= { label="启用技能图标", tooltip="如果可能，在技能旁显示图标"};
obj["exclusiveSkills"]			= { label="否则仅显示技能名字", tooltip="如果没有图标，就只显示技能名字"};


------------------------------
-- Interface dropdowns
------------------------------

obj = L.DROPDOWNS;
obj["profile"]				= { label="当前配置文件：", tooltip="设置当前配置文件"};
obj["normalFont"]			= { label="普通字体：", tooltip="选择非爆击伤害的字体"};
obj["critFont"]				= { label="爆击字体：", tooltip="选择爆击伤害的字体"};
obj["normalOutline"]		= { label="普通字体描边：", tooltip="选择非爆击伤害字体的描边样式"};
obj["critOutline"]			= { label="爆击字体描边：", tooltip="选择爆击伤害字体的描边样式"};
obj["scrollArea"]			= { label="滚动区域：", tooltip="选择滚动区域进行配置"};
obj["sound"]				= { label="声音：", tooltip="选择事件发生时播放的声音"};
obj["animationStyle"]		= { label="动画样式：", tooltip="滚动区域内非粘滞的动画样式"};
obj["stickyAnimationStyle"]	= { label="粘滞样式：", tooltip="滚动区域内粘滞的动画样式"};
obj["direction"]			= { label="方向：", tooltip="动画的方向"};
obj["behavior"]				= { label="特效：", tooltip="动画的特效"};
obj["textAlign"]			= { label="文本排列：", tooltip="动画中文本的排列方式"};
obj["eventCategory"]		= { label="事件种类：", tooltip="设置事件种类"};
obj["outputScrollArea"]		= { label="输出滚动区域：", tooltip="选择输出伤害滚动区域"};
--obj["mainEvent"]			= { label="Main Event:"};
--obj["triggerCondition"]		= { label="Condition:", tooltip="The condition to test."};
--obj["triggerRelation"]		= { label="Relation:"};
--obj["triggerParameter"]		= { label="Parameter:"};


------------------------------
-- Interface buttons
------------------------------

obj = L.BUTTONS;
obj["copyProfile"]				= { label="复制配置", tooltip="复制配置文件到新建的配置中"};
obj["resetProfile"]				= { label="重置配置", tooltip="重置配置至默认设置"};
obj["deleteProfile"]			= { label="删除配置", tooltip="删除配置文件"};
obj["masterFont"]				= { label="主要字体", tooltip="设置主要字体样式；除非另有指定，否则所有的滚动区域和事件均将使用这种字体样式"};
obj["partialEffects"]			= { label="特效着色", tooltip="设置显示哪些特殊战斗效果以及着什么颜色"};
obj["damageColors"]				= { label="伤害着色", tooltip="设置是否为某种伤害数值着色以及着什么颜色"};
obj["inputOkay"]				= { label=OKAY, tooltip="接受输入"};
obj["inputCancel"]				= { label=CANCEL, tooltip="取消输入"};
obj["genericSave"]				= { label=SAVE, tooltip="保存改变"};
obj["genericCancel"]			= { label=CANCEL, tooltip="取消改变"};
obj["addScrollArea"]			= { label="增加滚动区域", tooltip="增加一个新的滚动区域以包含事件和触发器"};
obj["configScrollAreas"]		= { label="设置滚动区域", tooltip="设置普通和粘滞动画效果，文本排列，滚动区域的宽度/高度，以及区域位置"};
obj["editScrollAreaName"]		= { tooltip="点击编辑滚动区域名字"};
obj["scrollAreaFontSettings"]	= { tooltip="点击设置字体；除非另有指定，否则此区域中所有事件均将使用这种字体样式显示"};
obj["deleteScrollArea"]			= { tooltip="点击删除此滚动区域"};
obj["scrollAreasPreview"]		= { label="预览", tooltip="预览效果"};
obj["toggleAll"]				= { label="开启/关闭所有事件", tooltip="开启/关闭所选事件分类中所有事件显示"};
obj["moveAll"]					= { label="移动所有事件", tooltip="移动所选事件分类中所有事件至指定滚动区域"};
obj["eventFontSettings"]		= { tooltip="点击设置此事件字体"};
obj["eventSettings"]			= { tooltip="点击设置事件效果比如输出区域，输出信息，播放声音等"};
obj["customSound"]				= { tooltip="点击选择自定义声音文件" };
--obj["playSound"]				= { label="Play", tooltip="Click to play the selected sound."};
obj["addTrigger"]				= { label="增加新触发器", tooltip="增加新触发器"};
obj["triggerSettings"]			= { tooltip="点击设置触发条件"};
obj["deleteTrigger"]			= { tooltip="点击删除触发器"};
obj["editTriggerClasses"]		= { tooltip="点击编辑触发器使用职业"};
--obj["addMainEvent"]				= { label="Add Event", tooltip="When ANY of these events occur and their defined conditions are true, the trigger will fire unless one of the exceptions specified below is true."};
--obj["addTriggerException"]		= { label="Add Exception", tooltip="When ANY of these exceptions are true, the trigger will not fire."};
--obj["editEventConditions"]		= { tooltip="Click to edit the conditions for the event."};
--obj["deleteMainEvent"]			= { tooltip="Click to delete the event."};
--obj["addEventCondition"]		= { label="Add Condition", tooltip="When ALL of these conditions are true for the selected event, the trigger will fire unless one of the specified exceptions is true."};
--obj["editCondition"]			= { tooltip="Click to edit the condition."};
--obj["deleteCondition"]			= { tooltip="Click to delete the condition."};
obj["throttleList"]				= { label="抑制列表", tooltip="设置指定技能的自定义抑制时间"};
obj["mergeExclusions"]			= { label="防止合并", tooltip="防止指定技能的伤害数值合并"};
obj["skillSuppressions"]		= { label="技能缩写", tooltip="缩写技能名字"};
obj["skillSubstitutions"]		= { label="技能替换", tooltip="用自定义名称替换技能名字"};
obj["addSkill"]					= { label="增加技能", tooltip="增加新技能到列表中"};
obj["deleteSkill"]				= { tooltip="点击删除技能"};
obj["cooldownExclusions"]		= { label="冷却排除列表", tooltip="不追踪指定技能的冷却"};


------------------------------
-- Interface editboxes
------------------------------

obj = L.EDITBOXES;
obj["copyProfile"]		= { label="新建配置：", tooltip="输入新建配置的名称"};
obj["scrollAreaName"]	= { label="新建滚动区域:", tooltip="新建滚动区域的名称"};
obj["xOffset"]			= { label="X值：", tooltip="所选择滚动区域的X值"};
obj["yOffset"]			= { label="Y值：", tooltip="所选择滚动区域的Y值"};
obj["eventMessage"]		= { label="输出信息：", tooltip="事件发生时显示的信息"};
obj["soundFile"]		= { label="声音文件：", tooltip="事件发生时播放的声音"};
obj["iconSkill"]		= { label="技能图标：", tooltip="The name or spell ID of a skill whose icon will be displayed when the event occurs.\n\nMSBT will automatically try to figure out an appropriate icon if one is not specified.\n\nNOTE: A spell ID must be used in place of a name if the skill is not in the spellbook for the class that is playing when the event occurs.  Most online databases such as wowhead can be used to discover it."};
obj["skillName"]		= { label="技能名称：", tooltip="所增加的技能的名字"};
obj["substitutionText"]	= { label="替代文本：", tooltip="用来代替技能名字的文本"};


------------------------------
-- Interface sliders
------------------------------

obj = L.SLIDERS;
obj["animationSpeed"]		= { label="动画速度", tooltip="设置主动画速度\n每个滚动区域也可以设置自身独有的速度"};
obj["normalFontSize"]		= { label="普通字体大小", tooltip="设置非爆击字体的大小"};
obj["normalFontOpacity"]	= { label="普通字体不透明度", tooltip="设置非爆击字体的不透明度"};
obj["critFontSize"]			= { label="爆击字体大小", tooltip="设置爆击字体大小"};
obj["critFontOpacity"]		= { label="爆击字体不透明度", tooltip="设置爆击字体不透明度"};
obj["scrollHeight"]			= { label="滚动高度", tooltip="滚动区域高度"};
obj["scrollWidth"]			= { label="滚动宽度", tooltip="滚动区域宽度"};
obj["scrollAnimationSpeed"]	= { label="动画速度", tooltip="设置滚动区域内动画速度"};
obj["powerThreshold"]		= { label="能量阈值", tooltip="能量获得只有超过此值才会被显示"};
obj["healThreshold"]		= { label="治疗阈值", tooltip="治疗量只有超过此值才会被显示"};
obj["damageThreshold"]		= { label="伤害阈值", tooltip="伤害量只有超过此值才会被显示"};
obj["dotThrottleTime"]		= { label="持续伤害抑制显示", tooltip="在设定的秒数中造成的持续伤害将合并为一次显示"};
obj["hotThrottleTime"]		= { label="持续治疗抑制显示", tooltip="在设定的秒数中造成的持续治疗将合并为一次显示"};
obj["powerThrottleTime"]	= { label="能量抑制显示", tooltip="在设定的秒数中持续获得的能量将合并为一次显示"};
obj["skillThrottleTime"]	= { label="技能抑制显示", tooltip="在设定的秒数中持续使用的技能将只显示一次"};
obj["cooldownThreshold"]	= { label="冷却阈值", tooltip="冷却时间低于设定秒数的技能不会被显示"};


------------------------------
-- Event categories
------------------------------
obj = L.EVENT_CATEGORIES;
obj[1] = "玩家受到伤害";
obj[2] = "宠物受到伤害";
obj[3] = "玩家输出伤害";
obj[4] = "宠物输出伤害";
obj[5] = "通告";


------------------------------
-- Event codes
------------------------------

obj = L.EVENT_CODES;
obj["DAMAGE_TAKEN"]			= "%a - Amount of damage taken.\n";
obj["HEALING_TAKEN"]		= "%a - Amount of healing taken.\n";
obj["DAMAGE_DONE"]			= "%a - Amount of damage done.\n";
obj["HEALING_DONE"]			= "%a - Amount of healing done.\n";
obj["ENERGY_AMOUNT"]		= "%a - Amount of energy.\n";
obj["CP_AMOUNT"]			= "%a - Amount of combo points you have.\n";
obj["HONOR_AMOUNT"]			= "%a - Amount of honor.\n";
obj["REP_AMOUNT"]			= "%a - Amount of reputation.\n";
obj["SKILL_AMOUNT"]			= "%a - Amount of points you have in the skill.\n";
obj["EXPERIENCE_AMOUNT"]	= "%a - Amount of experience you gained.\n";
obj["ATTACKER_NAME"]		= "%n - Name of the attacker.\n";
obj["HEALER_NAME"]			= "%n - Name of the healer.\n";
obj["ATTACKED_NAME"]		= "%n - Name of the attacked unit.\n";
obj["HEALED_NAME"]			= "%n - Name of the healed unit.\n";
obj["BUFFED_NAME"]			= "%n - Name of the buffed unit.\n";
obj["SKILL_NAME"]			= "%s - Name of the skill.\n";
obj["SPELL_NAME"]			= "%s - Name of the spell.\n";
obj["DEBUFF_NAME"]			= "%s - Name of the debuff.\n";
obj["BUFF_NAME"]			= "%s - Name of the buff.\n";
obj["ITEM_BUFF_NAME"]		= "%s - Name of the item buff.\n";
obj["EXTRA_ATTACKS"]		= "%s - Name of skill granting the extra attacks.\n";
obj["SKILL_LONG"]			= "%sl - Long form of %s. Used to override abbreviation for the event.\n";
obj["DAMAGE_TYPE_TAKEN"]	= "%t - Type of damage taken.\n";
obj["DAMAGE_TYPE_DONE"]		= "%t - Type of damage done.\n";
obj["ENVIRONMENTAL_DAMAGE"]	= "%e - Name of the source of the damage (falling, drowning, lava, etc...)\n";
obj["FACTION_NAME"]			= "%e - Name of the faction.\n";
obj["UNIT_KILLED"]			= "%e - Name of the unit killed.\n";
obj["SHARD_NAME"]			= "%e - Localized name of the soul shard.\n";
obj["EMOTE_TEXT"]			= "%e - The text of the emote.\n";
obj["MONEY_TEXT"]			= "%e - The money gained text.\n";
obj["COOLDOWN_NAME"]		= "%e - The name of skill that is ready.\n"
obj["POWER_TYPE"]			= "%p - Type of power (energy, rage, mana).\n";


------------------------------
-- Incoming events
------------------------------

obj = L.INCOMING_PLAYER_EVENTS;
obj[1]	= { label="近战伤害", tooltip="显示被近战伤害"};
obj[2]	= { label="近战爆击", tooltip="显示被近战爆击"};
obj[3]	= { label="近战未命中", tooltip="显示未被近战命中"};
obj[4]	= { label="近战闪躲", tooltip="显示闪躲近战攻击"};
obj[5]	= { label="近战招架", tooltip="显示招架近战攻击"};
obj[6]	= { label="近战格挡", tooltip="显示格挡近战攻击"};
obj[7]	= { label="近战吸收", tooltip="显示吸收近战伤害"};
obj[8]	= { label="近战免疫", tooltip="显示免疫近战伤害"};
obj[9]	= { label="技能伤害", tooltip="显示被技能伤害"};
obj[10]	= { label="技能爆击", tooltip="显示被技能爆击"};
obj[11]	= { label="技能持续伤害", tooltip="显示被技能持续伤害"};
obj[12]	= { label="技能未命中", tooltip="显示未被技能命中"};
obj[13]	= { label="技能闪躲", tooltip="显示闪躲技能攻击"};
obj[14]	= { label="技能招架", tooltip="显示招架技能攻击"};
obj[15]	= { label="技能格挡", tooltip="显示格挡技能攻击"};
obj[16]	= { label="法术抵抗", tooltip="显示抵抗法术攻击"};
obj[17]	= { label="技能吸收", tooltip="显示吸收技能伤害"};
obj[18]	= { label="技能免疫", tooltip="显示免疫技能伤害"};
obj[19]	= { label="技能反射", tooltip="显示反射技能伤害"};
obj[20]	= { label="法术打断", tooltip="显示打断法术"};
obj[21]	= { label="治疗", tooltip="显示被治疗"};
obj[22]	= { label="爆击治疗", tooltip="显示被治疗爆击"};
obj[23]	= { label="持续治疗", tooltip="显示被持续治疗"};
obj[24]	= { label="环境伤害", tooltip="显示环境伤害（如跌落，窒息，熔岩等）"};

obj = L.INCOMING_PET_EVENTS;
obj[1]	= { label="近战伤害", tooltip="显示宠物被近战伤害"};
obj[2]	= { label="近战爆击", tooltip="显示宠物被近战爆击"};
obj[3]	= { label="近战未命中", tooltip="显示宠物未被近战命中"};
obj[4]	= { label="近战闪躲", tooltip="显示宠物闪躲近战攻击"};
obj[5]	= { label="近战招架", tooltip="显示宠物招架近战攻击"};
obj[6]	= { label="近战格挡", tooltip="显示宠物格挡近战攻击"};
obj[7]	= { label="近战吸收", tooltip="显示宠物吸收近战伤害"};
obj[8]	= { label="近战免疫", tooltip="显示宠物免疫近战伤害"};
obj[9]	= { label="技能伤害", tooltip="显示宠物被技能伤害"};
obj[10]	= { label="技能爆击", tooltip="显示宠物被技能爆击"};
obj[11]	= { label="技能持续伤害", tooltip="显示宠物被技能持续伤害"};
obj[12]	= { label="技能未命中", tooltip="显示宠物未被技能命中"};
obj[13]	= { label="技能闪躲", tooltip="显示宠物闪躲技能攻击"};
obj[14]	= { label="技能招架", tooltip="显示宠物招架技能攻击"};
obj[15]	= { label="技能格挡", tooltip="显示宠物格挡技能攻击"};
obj[16]	= { label="法术抵抗", tooltip="显示宠物抵抗法术攻击"};
obj[17]	= { label="技能吸收", tooltip="显示宠物吸收技能伤害"};
obj[18]	= { label="技能免疫", tooltip="显示宠物免疫技能伤害"};
obj[19]	= { label="治疗", tooltip="显示宠物被治疗"};
obj[20]	= { label="治疗爆击", tooltip="显示宠物被治疗爆击"};
obj[21]	= { label="持续治疗", tooltip="显示宠物被持续治疗"};


------------------------------
-- Outgoing events
------------------------------

obj = L.OUTGOING_PLAYER_EVENTS;
obj[1]	= { label="近战伤害", tooltip="显示对敌近战伤害"};
obj[2]	= { label="近战爆击", tooltip="显示对敌近战爆击"};
obj[3]	= { label="近战未命中", tooltip="显示近战未命中敌人"};
obj[4]	= { label="近战闪躲", tooltip="显示敌人闪躲近战攻击"};
obj[5]	= { label="近战招架", tooltip="显示敌人招架近战攻击"};
obj[6]	= { label="近战格挡", tooltip="显示敌人格挡近战攻击"};
obj[7]	= { label="近战吸收", tooltip="显示敌人吸收近战伤害"};
obj[8]	= { label="近战免疫", tooltip="显示敌人免疫近战伤害"};
obj[9]	= { label="近战闪避", tooltip="显示敌人闪避近战攻击"};
obj[10]	= { label="技能伤害", tooltip="显示技能伤害敌人"};
obj[11]	= { label="技能爆击", tooltip="显示技能爆击敌人"};
obj[12]	= { label="技能持续伤害", tooltip="显示技能持续伤害敌人"};
obj[13]	= { label="技能未命中", tooltip="显示技能未命中敌人"};
obj[14]	= { label="技能闪躲", tooltip="显示敌人闪躲技能攻击"};
obj[15]	= { label="技能招架", tooltip="显示敌人招架技能攻击"};
obj[16]	= { label="技能格挡", tooltip="显示敌人格挡技能攻击"};
obj[17]	= { label="法术抵抗", tooltip="显示敌人抵抗法术攻击"};
obj[18]	= { label="技能吸收", tooltip="显示敌人吸收法术伤害"};
obj[19]	= { label="技能免疫", tooltip="显示敌人免疫技能伤害"};
obj[20]	= { label="技能反射", tooltip="显示敌人反射技能伤害"};
obj[21]	= { label="法术打断", tooltip="显示法术攻击被打断"};
obj[22]	= { label="技能闪避", tooltip="显示技能攻击被闪避"};
obj[23]	= { label="治疗", tooltip="显示治疗目标"};
obj[24]	= { label="治疗爆击", tooltip="显示爆击治疗目标"};
obj[25]	= { label="持续治疗", tooltip="显示持续治疗目标"};
--obj[26] = { label="Dispels", tooltip="Enable outgoing dispels."};

obj = L.OUTGOING_PET_EVENTS;
obj[1]	= { label="近战伤害", tooltip="显示宠物近战伤害"};
obj[2]	= { label="近战爆击", tooltip="显示宠物近战爆击"};
obj[3]	= { label="近战未命中", tooltip="显示宠物的近战攻击未命中敌人"};
obj[4]	= { label="近战闪躲", tooltip="显示宠物的近战攻击被闪躲"};
obj[5]	= { label="近战招架", tooltip="显示宠物的近战攻击被招架"};
obj[6]	= { label="近战格挡", tooltip="显示宠物的近战攻击被格挡"};
obj[7]	= { label="近战吸收", tooltip="显示宠物的近战伤害被吸收"};
obj[8]	= { label="近战免疫", tooltip="显示宠物的近战伤害被免疫"};
obj[9]	= { label="近战闪避", tooltip="显示宠物的近战攻击被闪避"};
obj[10]	= { label="技能伤害", tooltip="显示宠物的技能伤害"};
obj[11]	= { label="技能爆击", tooltip="显示宠物的技能爆击"};
obj[12]	= { label="技能持续伤害", tooltip="显示宠物技能的持续伤害"};
obj[13]	= { label="技能未命中", tooltip="显示宠物技能攻击未命中敌人"};
obj[14]	= { label="技能闪躲", tooltip="显示宠物的技能攻击被闪躲"};
obj[15]	= { label="技能招架", tooltip="显示宠物的技能攻击被招架"};
obj[16]	= { label="技能格挡", tooltip="显示宠物的技能攻击被格挡"};
obj[17]	= { label="法术抵抗", tooltip="显示宠物的法术攻击被抵抗"};
obj[18]	= { label="技能吸收", tooltip="显示宠物的技能伤害被吸收"};
obj[19]	= { label="技能免疫", tooltip="显示宠物的技能伤害被免疫"};
obj[20]	= { label="技能闪避", tooltip="显示宠物的技能攻击被闪避"};
--obj[21] = { label="Dispels", tooltip="Enable your pet's outgoing dispels."};


------------------------------
-- Notification events
------------------------------

obj = L.NOTIFICATION_EVENTS;
obj[1]	= { label="Debuff", tooltip="显示你遭受的Debuff"};
obj[2]	= { label="Buff", tooltip="显示你得到的Buff"};
obj[3]	= { label="物品Buff", tooltip="显示使用物品得到的Buff"};
obj[4]	= { label="Debuff消失", tooltip="显示从你身上消失的Debuff"};
obj[5]	= { label="Buff消失", tooltip="显示从你身上消失的Buff"};
obj[6]	= { label="物品Buff消失", tooltip="显示从你身上消失的物品Buff"};
obj[7]	= { label="战斗开始", tooltip="显示你已经开始战斗"};
obj[8]	= { label="战斗结束", tooltip="显示你已经结束了战斗"};
obj[9]	= { label="能量获得", tooltip="显示你额外获得的法力，怒气或者能量"};
obj[10]	= { label="能量行动", tooltip="显示你失去的法力，怒气或者能量"};
obj[11]	= { label="连击点获得", tooltip="显示你获得的连击点"};
obj[12]	= { label="连击点已满", tooltip="显示你的连击点已满"};
obj[13]	= { label="获得荣誉", tooltip="显示你获得荣誉"};
obj[14]	= { label="声望提高", tooltip="显示你的声望提高"};
obj[15]	= { label="声望下降", tooltip="显示你的声望下降"};
obj[16]	= { label="获得技能点", tooltip="显示你获得了技能点"};
obj[17]	= { label="获得经验", tooltip="显示你获得了经验值"};
obj[18]	= { label="击杀玩家", tooltip="显示你击杀了一个敌对玩家"};
obj[19]	= { label="击杀NPC", tooltip="显示你击杀了一个敌对NPC"};
obj[20]	= { label="获得灵魂碎片", tooltip="显示你获得了一个灵魂碎片"};
obj[21]	= { label="额外攻击", tooltip="显示你从风怒，痛击之刃，剑系掌握等方面获得了一次额外攻击"};
obj[22]	= { label="敌人获得Buff", tooltip="显示当前敌对目标获得的Buff"};
obj[23]	= { label="怪物表情", tooltip="显示当前目标怪物表情"};
obj[24]	= { label="获得金钱", tooltip="显示获得的金钱"};


------------------------------
-- Trigger info
------------------------------

-- Main events.
obj = L.TRIGGER_DATA;
--obj["SWING_DAMAGE"]				= "Swing Damage";
--obj["RANGE_DAMAGE"]				= "Range Damage";
--obj["SPELL_DAMAGE"]				= "Skill Damage";
--obj["GENERIC_DAMAGE"]			= "Swing/Range/Skill Damage";
--obj["SPELL_PERIODIC_DAMAGE"]	= "Periodic Skill Damage (DoT)";
--obj["DAMAGE_SHIELD"]			= "Damage Shield Damage";
--obj["DAMAGE_SPLIT"]				= "Split Damage";
--obj["ENVIRONMENTAL_DAMAGE"]		= "Environmental Damage";
--obj["SWING_MISSED"]				= "Swing Miss";
--obj["RANGE_MISSED"]				= "Range Miss";
--obj["SPELL_MISSED"]				= "Skill Miss";
--obj["GENERIC_MISSED"]			= "Swing/Range/Skill Miss";
--obj["SPELL_PERIODIC_MISSED"]	= "Periodic Skill Miss";
--obj["SPELL_DISPEL_FAILED"]		= "Dispel Failed";
--obj["DAMAGE_SHIELD_MISSED"]		= "Damage Shield Miss";
--obj["SPELL_HEAL"]				= "Heal";
--obj["SPELL_PERIODIC_HEAL"]		= "Periodic Heal (HoT)";
--obj["SPELL_ENERGIZE"]			= "Power Gain";
--obj["SPELL_PERIODIC_ENERGIZE"]	= "Periodic Power Gain";
--obj["SPELL_DRAIN"]				= "Power Drain";
--obj["SPELL_PERIODIC_DRAIN"]		= "Periodic Power Drain";
--obj["SPELL_LEECH"]				= "Power Leech";
--obj["SPELL_PERIODIC_LEECH"]		= "Periodic Power Leech";
--obj["SPELL_INTERRUPT"]			= "Skill Interrupt";
--obj["SPELL_AURA_APPLIED"]		= "Aura Application";
--obj["SPELL_AURA_REMOVED"]		= "Aura Removal";
--obj["SPELL_STOLEN"]				= "Aura Stolen";
--obj["SPELL_DISPEL"]				= "Aura Dispel";
--obj["ENCHANT_APPLIED"]			= "Enchant Application";
--obj["ENCHANT_REMOVED"]			= "Enchant Removal";
--obj["SPELL_CAST_START"]			= "Cast Start";
--obj["SPELL_CAST_SUCCESS"]		= "Cast Success";
--obj["SPELL_CAST_FAILED"]		= "Cast Failure";
--obj["SPELL_SUMMON"]				= "Summon";
--obj["SPELL_CREATE"]				= "Create";
--obj["PARTY_KILL"]				= "Killing Blow";
--obj["UNIT_DIED"]				= "Unit Death";
--obj["UNIT_DESTROYED"]			= "Unit Destroy";
--obj["SPELL_EXTRA_ATTACKS"]		= "Extra Attacks";
--obj["UNIT_HEALTH"]				= "Health Change";
--obj["UNIT_MANA"]				= "Mana Change";
--obj["UNIT_ENERGY"]				= "Energy Change";
--obj["UNIT_RAGE"]				= "Rage Change";
--obj["SKILL_COOLDOWN"]			= "Skill Cooldown Complete";
 
-- Main event conditions.
--obj["sourceName"]				= "Source Unit Name";
--obj["sourceAffiliation"]		= "Source Unit Affiliation";
--obj["sourceReaction"]			= "Source Unit Reaction";
--obj["sourceControl"]			= "Source Unit Control";
--obj["sourceUnitType"]			= "Source Unit Type";
--obj["recipientName"]			= "Recipient Unit Name";
--obj["recipientAffiliation"]		= "Recipient Unit Affiliation";
--obj["recipientReaction"]		= "Recipient Unit Reaction";
--obj["recipientControl"]			= "Recipient Unit Control";
--obj["recipientUnitType"]		= "Recipient Unit Type";
--obj["skillID"]					= "Skill ID";
--obj["skillName"]				= "Skill Name";
--obj["skillSchool"]				= "Skill School";
--obj["extraSkillID"]				= "Extra Skill ID";
--obj["extraSkillName"]			= "Extra Skill Name";
--obj["extraSkillSchool"]			= "Extra Skill School";
--obj["amount"]					= "Amount";
--obj["damageType"]				= "Damage Type";
--obj["resistAmount"]				= "Resist Amount";
--obj["blockAmount"]				= "Block Amount";
--obj["absorbAmount"]				= "Absorb Amount";
--obj["isCrit"]					= "Crit";
--obj["isGlancing"]				= "Glancing Hit";
--obj["isCrushing"]				= "Crushing Blow";
--obj["extraAmount"]				= "Extra Amount";
--obj["missType"]					= "Miss Type";
--obj["hazardType"]				= "Hazard Type";
--obj["powerType"]				= "Power Type";
--obj["auraType"]					= "Aura Type";
--obj["threshold"]				= "Threshold";
--obj["unitID"]					= "Unit ID";
--obj["unitReaction"]				= "Unit Reaction";

-- Exception conditions.
--obj["buffActive"]				= "Buff Active";
--obj["currentCP"]				= "Current Combo Points";
--obj["currentPower"]				= "Current Power";
--obj["recentlyFired"]			= "Trigger Recently Fired";
--obj["trivialTarget"]			= "Trivial Target";
--obj["unavailableSkill"]			= "Unavailable Skill";
obj["warriorStance"]			= "战士姿态";
--obj["zoneName"]					= "Zone Name";
--obj["zoneType"]					= "Zone Type";
 
-- Relationships.
--obj["eq"]						= "Is Equal To";
--obj["ne"]						= "Is Not Equal To";
--obj["like"]						= "Is Like";
--obj["unlike"]					= "Is Not Like";
--obj["lt"]						= "Is Less Than";
--obj["gt"]						= "Is Greater Than";
 
-- Affiliations.
--obj["affiliationMine"]			= "Mine";
--obj["affiliationParty"]			= "Party Member";
--obj["affiliationRaid"]			= "Raid Member";
--obj["affiliationOutsider"]		= "Outsider";
obj["affiliationTarget"]		= TARGET;
obj["affiliationFocus"]			= FOCUS;
obj["affiliationYou"]			= YOU;

-- Reactions.
--obj["reactionFriendly"]			= "Friendly";
--obj["reactionNeutral"]			= "Neutral";
--obj["reactionHostile"]			= HOSTILE;

-- Control types.
--obj["controlServer"]			= "Server";
--obj["controlHuman"]				= "Human";

-- Unit types.
obj["unitTypePlayer"]			= PLAYER; 
--obj["unitTypeNPC"]				= "NPC";
obj["unitTypePet"]				= PET;
--obj["unitTypeGuardian"]			= "Guardian";
--obj["unitTypeObject"]			= "Object";

-- Aura types.
--obj["auraTypeBuff"]				= "Buff";
--obj["auraTypeDebuff"]			= "Debuff";

-- Zone types.
--obj["zoneTypeArena"]			= "Arena";
obj["zoneTypePvP"]				= BATTLEGROUND;
--obj["zoneTypeParty"]			= "5 man instance";
--obj["zoneTypeRaid"]				= "Raid instance";

-- Booleans
--obj["booleanTrue"]				= "True";
--obj["booleanFalse"]				= "False";


------------------------------
-- Font info
------------------------------

-- Font outlines.
obj = L.OUTLINES;
obj[1] = "无";
obj[2] = "细";
obj[3] = "粗";

-- Text aligns.
obj = L.TEXT_ALIGNS;
obj[1] = "左边";
obj[2] = "中间";
obj[3] = "右边";


------------------------------
-- Sound info
------------------------------

obj = L.SOUNDS;
obj["LowMana"]		= "能量不足";
obj["LowHealth"]	= "血量不足";


------------------------------
-- Animation style info
------------------------------

-- Animation styles
obj = L.ANIMATION_STYLE_DATA;
obj["Horizontal"]	= "水平";
obj["Parabola"]		= "抛物线";
obj["Straight"]		= "直线";
obj["Static"]		= "静止";
obj["Pow"]			= "抖动";

-- Animation style directions.
--obj["Alternate"]	= "Alternate";
obj["Left"]			= "左";
obj["Right"]		= "右";
obj["Up"]			= "上";
obj["Down"]			= "下";

-- Animation style behaviors.
obj["GrowUp"]			= "向上增长";
obj["GrowDown"]			= "向下增长";
obj["CurvedLeft"]		= "向左抛出";
obj["CurvedRight"]		= "向右抛出";
obj["Jiggle"]			= "摇动";
obj["Normal"]			= "普通";