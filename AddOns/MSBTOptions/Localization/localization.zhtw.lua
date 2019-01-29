----------------------------------------------------------------------------
-- Title: MSBT Options Traditional Chinese Localization
-- Author: Mik
-- 繁體中文版翻譯 by  Whitepaw  @暗影之月 server in TWOW on June 11th,2008
-- Traditional Chinese translated by Whitepaw @Shadowmoon server in TWOW
-- on June 11th,2008
-------------------------------------------------------------------------------

-- Don't do anything if the locale isn't Traditional Chinese.
if (GetLocale() ~= "zhTW") then return; end

-- Local reference for faster access.
local L = MikSBT.translations;

-------------------------------------------------------------------------------
-- Traditional Chinese localization
-------------------------------------------------------------------------------


------------------------------
-- Interface messages
------------------------------

L.MSG_NEW_PROFILE					= "新建記錄檔";
L.MSG_PROFILE_ALREADY_EXISTS		= "記錄檔已存在";
L.MSG_INVALID_PROFILE_NAME			= "無效的記錄檔名稱";
L.MSG_NEW_SCROLL_AREA				= "新增滾動區域";
L.MSG_SCROLL_AREA_ALREADY_EXISTS	= "此滾動區域名稱已存在";
L.MSG_INVALID_SCROLL_AREA_NAME		= "無效的滾動區名稱";
L.MSG_ACKNOWLEDGE_TEXT				= "你確定要執行這個動作嗎？";
L.MSG_NORMAL_PREVIEW_TEXT			= "一般";
L.MSG_INVALID_SOUND_FILE			= "音效必須為MP3或WAV格式。";
L.MSG_NEW_TRIGGER					= "新增觸發";
L.MSG_TRIGGER_CLASSES				= "觸發職業";
L.MSG_MAIN_EVENTS					= "主要事件";
L.MSG_TRIGGER_EXCEPTIONS			= "觸發例外";
--L.MSG_EVENT_CONDITIONS				= "Event Conditions";
L.MSG_SKILLS						= "技能";
L.MSG_SKILL_ALREADY_EXISTS			= "技能名稱已存在";
L.MSG_INVALID_SKILL_NAME			= "無效的技能名稱";
L.MSG_HOSTILE						= "敵對玩家";
L.MSG_ANY							= "任何";
--L.MSG_CONDITION						= "Condition";
--L.MSG_CONDITIONS					= "Conditions";


------------------------------
-- Class Names.
------------------------------

local obj = L.CLASS_NAMES;
obj["DRUID"]	= "德魯伊";
obj["HUNTER"]	= "獵人";
obj["MAGE"]		= "法師";
obj["PALADIN"]	= "聖騎士";
obj["PRIEST"]	= "牧師";
obj["ROGUE"]	= "盜賊";
obj["SHAMAN"]	= "薩滿";
obj["WARLOCK"]	= "術士";
obj["WARRIOR"]	= "戰士";


------------------------------
-- Interface tabs
------------------------------

obj = L.TABS;
obj[1] = { label="一般設定", tooltip="一般選項設定"};
obj[2] = { label="滾動區域", tooltip="新增、刪除和設定滾動區域；移動滑鼠到按鈕上可以得到更多訊息"};
obj[3] = { label="事件設定", tooltip="設定承受傷害、輸出傷害和通知的事件；移動滑鼠到按鈕可得到更多訊息"};
obj[4] = { label="技能觸發", tooltip="設定觸發；移動滑鼠到按鈕可得到更多訊息"};
obj[5] = { label="洗屏控制", tooltip="設定對可能造成洗畫面的訊息進行控制"};
obj[6] = { label="冷卻通知", tooltip="設定技能冷卻通知"};
obj[7] = { label="技能圖示", tooltip="設定技能圖示"};


------------------------------
-- Interface checkboxes
------------------------------

obj = L.CHECKBOXES;
obj["enableMSBT"]				= { label="啟用MSBT", tooltip="啟用MSBT"};
obj["stickyCrits"]				= { label="爆擊特效顯示", tooltip="使用爆擊特效來顯示致命一擊"};
obj["gameDamage"]				= { label="遊戲預設傷害", tooltip="開啟在敵人頭上顯示遊戲預設傷害訊息"};
obj["gameHealing"]				= { label="遊戲預設治療", tooltip="開啟在目標頭上顯示遊戲預設治療訊息"};
obj["enableSounds"]				= { label="啟用音效", tooltip="設定是否當指定事件和觸發器發生時播放音效"};
obj["colorPartialEffects"]		= { label="特效著色", tooltip="設定是否開啟為部分特效指定顏色"};
obj["crushing"]					= { label="碾壓", tooltip="設定是否顯示碾壓訊息"};
obj["glancing"]					= { label="偏斜", tooltip="設定是否顯示偏斜訊息"};
obj["absorb"]					= { label="吸收", tooltip="設定是否顯示部分吸收數值"};
obj["block"]					= { label="格擋", tooltip="設定是否顯示部分格擋數值"};
obj["resist"]					= { label="抵抗", tooltip="設定是否顯示部分抵抗數值"};
obj["vulnerability"]			= { label="虛弱加成", tooltip="設定是否顯示虛弱加成數值"};
obj["overheal"]					= { label="過量治療", tooltip="設定是否顯示過量治療數值"};
obj["colorDamageAmounts"]		= { label="傷害數值著色", tooltip="設定是否讓不同的傷害類型顯示不同的顏色"};
obj["colorDamageEntry"]			= { tooltip="讓此傷害類型顯示不同的顏色"};
obj["enableScrollArea"]			= { tooltip="啟用滾動區域"};
obj["inheritField"]				= { label="沿用", tooltip="沿用主要字型，不勾選則無效"};
obj["stickyEvent"]				= { label="套用爆擊", tooltip="使用爆擊效果來顯示事件"};
obj["enableTrigger"]			= { tooltip="啟用觸發"};
obj["allPowerGains"]			= { label="所有能量獲取", tooltip="顯示所有獲取的能量包括那些戰鬥日誌中不顯示的。警告：這個選項將會大量洗頻同時無視能量門檻和抑制顯示設定\n不推薦"};
obj["hyperRegen"]				= { label="超級回復", tooltip="顯示從快速回復技能（比如喚醒和精神分流）中獲取的能量數值；注意：此顯示無法抑制顯示"};
obj["abbreviateSkills"]			= { label="技能縮寫", tooltip="縮減技能名稱（僅適用於英文版）。若事件描述中加入「%sl」代碼，此選項即失效"};
obj["hideSkills"]				= { label="隱藏技能", tooltip="在承受傷害和輸出傷害中不顯示技能名稱。開啟此選項將使你失去某些事件自定義功能，因為它會忽略「%s」代碼"};
obj["hideNames"]				= { label="隱藏名稱", tooltip="在承受傷害和輸出傷害中不顯示單位名稱。開啟此選項將使你失去某些事件自定義功能，因為它會忽略「%n」代碼"};
obj["allClasses"]				= { label="所有職業"};
obj["enableCooldowns"]			= { label="啟用冷卻", tooltip="當冷卻結束時顯示通知"};
obj["enableIcons"]				= { label="啟用技能圖示", tooltip="顯示事件的技能圖示"};
obj["exclusiveSkills"]			= { label="排除技能名稱", tooltip="僅在沒有技能圖示時，顯示技能名稱"};


------------------------------
-- Interface dropdowns
------------------------------

obj = L.DROPDOWNS;
obj["profile"]				= { label="目前記錄檔：", tooltip="設定目前記錄檔"};
obj["normalFont"]			= { label="一般傷害字型：", tooltip="選擇非爆擊傷害的字型"};
obj["critFont"]				= { label="爆擊傷害字型：", tooltip="選擇爆擊傷害的字型"};
obj["normalOutline"]		= { label="一般文字描邊：", tooltip="選擇非爆擊傷害字型的描邊樣式"};
obj["critOutline"]			= { label="爆擊文字描邊：", tooltip="選擇爆擊傷害字型的描邊樣式"};
obj["scrollArea"]			= { label="滾動區域：", tooltip="選擇滾動區域進行設定"};
obj["sound"]				= { label="音效：", tooltip="選擇事件發生時播放的音效"};
obj["animationStyle"]		= { label="動畫樣式：", tooltip="滾動區域內非黏滯的動畫樣式"};
obj["stickyAnimationStyle"]	= { label="爆擊特效：", tooltip="滾動區域內爆擊特效的動畫樣式"};
obj["direction"]			= { label="方向：", tooltip="動畫的方向"};
obj["behavior"]				= { label="效果：", tooltip="動畫的效果"};
obj["textAlign"]			= { label="對齊：", tooltip="動畫文字的對齊方式"};
obj["eventCategory"]		= { label="事件種類：", tooltip="設定事件種類"};
obj["outputScrollArea"]		= { label="輸出滾動區域：", tooltip="選擇輸出傷害滾動區域"};
obj["mainEvent"]			= { label="主要事件:"};
--obj["triggerCondition"]		= { label="Condition:", tooltip="The condition to test."};
--obj["triggerRelation"]		= { label="Relation:"};
--obj["triggerParameter"]		= { label="Parameter:"};


------------------------------
-- Interface buttons
------------------------------

obj = L.BUTTONS;
obj["copyProfile"]				= { label="複製記錄檔", tooltip="複製記錄檔到新增的記錄檔中"};
obj["resetProfile"]				= { label="重置記錄檔", tooltip="重置記錄檔至默認設定"};
obj["deleteProfile"]			= { label="刪除記錄檔", tooltip="刪除記錄檔"};
obj["masterFont"]				= { label="主要字型", tooltip="設定主要字型樣式；除非另有指定，否則所有的滾動區域和事件均將使用這種字型樣式"};
obj["partialEffects"]			= { label="特效著色", tooltip="設定顯示哪些特殊戰鬥效果以及著什麼顏色"};
obj["damageColors"]				= { label="傷害著色", tooltip="設定是否為某種傷害數值著色以及著什麼顏色"};
obj["inputOkay"]				= { label=OKAY, tooltip="接受輸入"};
obj["inputCancel"]				= { label=CANCEL, tooltip="取消輸入"};
obj["genericSave"]				= { label=SAVE, tooltip="儲存改變"};
obj["genericCancel"]			= { label=CANCEL, tooltip="取消改變"};
obj["addScrollArea"]			= { label="新增滾動區域", tooltip="增加一個新的滾動區域以包含事件和觸發"};
obj["configScrollAreas"]		= { label="設定滾動區域", tooltip="設定普通和黏滯動畫效果，對齊，滾動區域的寬度/高度，以及區域位置"};
obj["editScrollAreaName"]		= { tooltip="編輯滾動區域名稱"};
obj["scrollAreaFontSettings"]	= { tooltip="設定字型；除非另有指定，否則此區域中所有事件均將使用這種字型樣式顯示"};
obj["deleteScrollArea"]			= { tooltip="刪除此滾動區域"};
obj["scrollAreasPreview"]		= { label="預覽", tooltip="預覽效果"};
obj["toggleAll"]				= { label="開啟/關閉所有事件", tooltip="開啟/關閉所選事件分類中所有事件顯示"};
obj["moveAll"]					= { label="移動所有事件", tooltip="移動所選事件分類中所有事件至指定滾動區域"};
obj["eventFontSettings"]		= { tooltip="設定此事件字型"};
obj["eventSettings"]			= { tooltip="設定事件效果比如輸出區域，輸出訊息，播放音效等"};
obj["customSound"]				= { tooltip="選擇自定義音效文件" };
--obj["playSound"]				= { label="Play", tooltip="Click to play the selected sound."};
obj["addTrigger"]				= { label="增加新觸發", tooltip="增加新觸發"};
obj["triggerSettings"]			= { tooltip="設定觸發條件"};
obj["deleteTrigger"]			= { tooltip="刪除觸發"};
obj["editTriggerClasses"]		= { tooltip="編輯觸發使用職業"};
obj["addMainEvent"]				= { label="新增事件", tooltip="當任何此類事件發生，並且跟設定的條件相符，將會啟動觸發，除非發生以下的例外"};
obj["addTriggerException"]		= { label="新增例外", tooltip="當任何此類例外發生，觸發就不會啟動"};
obj["editEventConditions"]		= { tooltip="設定這個事件的條件"};
obj["deleteMainEvent"]			= { tooltip="刪除事件"};
--obj["addEventCondition"]		= { label="Add Condition", tooltip="When ALL of these conditions are true for the selected event, the trigger will fire unless one of the specified exceptions is true."};
--obj["editCondition"]			= { tooltip="Click to edit the condition."};
--obj["deleteCondition"]			= { tooltip="Click to delete the condition."};
obj["throttleList"]				= { label="抑制列表", tooltip="設定指定技能的自定義抑制時間"};
obj["mergeExclusions"]			= { label="合併排除", tooltip="排除指定技能的傷害數值合併"};
obj["skillSuppressions"]		= { label="技能縮寫", tooltip="縮寫技能名稱"};
obj["skillSubstitutions"]		= { label="技能替換", tooltip="用自定義名稱替換技能名稱"};
obj["addSkill"]					= { label="增加技能", tooltip="增加新技能到列表中"};
obj["deleteSkill"]				= { tooltip="點擊刪除技能"};
obj["cooldownExclusions"]		= { label="冷卻排除", tooltip="不追蹤指定技能的冷卻"};


------------------------------
-- Interface editboxes
------------------------------

obj = L.EDITBOXES;
obj["copyProfile"]		= { label="新增記錄檔：", tooltip="輸入新增記錄檔的名稱"};
obj["scrollAreaName"]	= { label="新增滾動區域:", tooltip="新增滾動區域的名稱"};
obj["xOffset"]			= { label="X值：", tooltip="所選擇滾動區域的X值"};
obj["yOffset"]			= { label="Y值：", tooltip="所選擇滾動區域的Y值"};
obj["eventMessage"]		= { label="顯示訊息：", tooltip="事件發生時顯示的訊息"};
obj["soundFile"]		= { label="音效檔：", tooltip="事件發生時播放的音效"};
obj["iconSkill"]		= { label="技能圖示：", tooltip="事件發生時會顯示該技能的圖示\n\n如果沒有圖示MSBT會自動找一個圖示\n\n注意: 如果目前玩家的技能書中無該技能，必須用技能ID取代技能名稱。可以在各大網站(例：WOWhead)找到技能ID。"};
obj["skillName"]		= { label="技能名稱：", tooltip="所增加的技能的名稱"};
obj["substitutionText"]	= { label="替代文字：", tooltip="用來代替技能名稱的文字"};


------------------------------
-- Interface sliders
------------------------------

obj = L.SLIDERS;
obj["animationSpeed"]		= { label="動畫速度", tooltip="設定主動畫速度\n每個滾動區域也可以設定自身獨有的速度"};
obj["normalFontSize"]		= { label="一般字型大小", tooltip="設定非爆擊字型的大小"};
obj["normalFontOpacity"]	= { label="普通字型不透明度", tooltip="設定非爆擊字型的不透明度"};
obj["critFontSize"]			= { label="一般字型大小", tooltip="設定爆擊字型大小"};
obj["critFontOpacity"]		= { label="爆擊字型不透明度", tooltip="設定爆擊字型不透明度"};
obj["scrollHeight"]			= { label="滾動高度", tooltip="滾動區域高度"};
obj["scrollWidth"]			= { label="滾動寬度", tooltip="滾動區域寬度"};
obj["scrollAnimationSpeed"]	= { label="動畫速度", tooltip="設定滾動區域內動畫速度"};
obj["powerThreshold"]		= { label="能量門檻", tooltip="能量獲得只有超過此值才會被顯示"};
obj["healThreshold"]		= { label="治療門檻", tooltip="治療量只有超過此值才會被顯示"};
obj["damageThreshold"]		= { label="傷害門檻", tooltip="傷害量只有超過此值才會被顯示"};
obj["dotThrottleTime"]		= { label="持續傷害抑制顯示", tooltip="在設定的秒數中造成的持續傷害將合併為一次顯示"};
obj["hotThrottleTime"]		= { label="持續治療抑制顯示", tooltip="在設定的秒數中造成的持續治療將合併為一次顯示"};
obj["powerThrottleTime"]	= { label="能量抑制顯示", tooltip="在設定的秒數中持續獲得的能量將合併為一次顯示"};
obj["skillThrottleTime"]	= { label="技能抑制顯示", tooltip="在設定的秒數中持續使用的技能將只顯示一次"};
obj["cooldownThreshold"]	= { label="冷卻計時門檻", tooltip="冷卻時間低於設定秒數的技能不會被顯示"};


------------------------------
-- Event categories
------------------------------
obj = L.EVENT_CATEGORIES;
obj[1] = "玩家受到傷害";
obj[2] = "寵物受到傷害";
obj[3] = "玩家輸出傷害";
obj[4] = "寵物輸出傷害";
obj[5] = "訊息通知";


------------------------------
-- Event codes
------------------------------

obj = L.EVENT_CODES;
--obj["DAMAGE_TAKEN"]			= "%a - Amount of damage taken.\n";
--obj["HEALING_TAKEN"]		= "%a - Amount of healing taken.\n";
--obj["DAMAGE_DONE"]			= "%a - Amount of damage done.\n";
--obj["HEALING_DONE"]			= "%a - Amount of healing done.\n";
--obj["ENERGY_AMOUNT"]		= "%a - Amount of energy.\n";
--obj["CP_AMOUNT"]			= "%a - Amount of combo points you have.\n";
--obj["HONOR_AMOUNT"]			= "%a - Amount of honor.\n";
--obj["REP_AMOUNT"]			= "%a - Amount of reputation.\n";
--obj["SKILL_AMOUNT"]			= "%a - Amount of points you have in the skill.\n";
--obj["EXPERIENCE_AMOUNT"]	= "%a - Amount of experience you gained.\n";
--obj["ATTACKER_NAME"]		= "%n - Name of the attacker.\n";
--obj["HEALER_NAME"]			= "%n - Name of the healer.\n";
--obj["ATTACKED_NAME"]		= "%n - Name of the attacked unit.\n";
--obj["HEALED_NAME"]			= "%n - Name of the healed unit.\n";
--obj["BUFFED_NAME"]			= "%n - Name of the buffed unit.\n";
--obj["SKILL_NAME"]			= "%s - Name of the skill.\n";
--obj["SPELL_NAME"]			= "%s - Name of the spell.\n";
--obj["DEBUFF_NAME"]			= "%s - Name of the debuff.\n";
--obj["BUFF_NAME"]			= "%s - Name of the buff.\n";
--obj["ITEM_BUFF_NAME"]		= "%s - Name of the item buff.\n";
--obj["EXTRA_ATTACKS"]		= "%s - Name of skill granting the extra attacks.\n";
--obj["SKILL_LONG"]			= "%sl - Long form of %s. Used to override abbreviation for the event.\n";
--obj["DAMAGE_TYPE_TAKEN"]	= "%t - Type of damage taken.\n";
--obj["DAMAGE_TYPE_DONE"]		= "%t - Type of damage done.\n";
--obj["ENVIRONMENTAL_DAMAGE"]	= "%e - Name of the source of the damage (falling, drowning, lava, etc...)\n";
--obj["FACTION_NAME"]			= "%e - Name of the faction.\n";
--obj["UNIT_KILLED"]			= "%e - Name of the unit killed.\n";
--obj["SHARD_NAME"]			= "%e - Localized name of the soul shard.\n";
--obj["EMOTE_TEXT"]			= "%e - The text of the emote.\n";
--obj["MONEY_TEXT"]			= "%e - The money gained text.\n";
--obj["COOLDOWN_NAME"]		= "%e - The name of skill that is ready.\n"
--obj["POWER_TYPE"]			= "%p - Type of power (energy, rage, mana).\n";


------------------------------
-- Incoming events
------------------------------

obj = L.INCOMING_PLAYER_EVENTS;
obj[1]	= { label="近戰傷害", tooltip="顯示被近戰傷害"};
obj[2]	= { label="近戰爆擊", tooltip="顯示被近戰爆擊"};
obj[3]	= { label="近戰未命中", tooltip="顯示未被近戰命中"};
obj[4]	= { label="近戰閃躲", tooltip="顯示閃躲近戰攻擊"};
obj[5]	= { label="近戰招架", tooltip="顯示招架近戰攻擊"};
obj[6]	= { label="近戰格擋", tooltip="顯示格擋近戰攻擊"};
obj[7]	= { label="近戰吸收", tooltip="顯示吸收近戰傷害"};
obj[8]	= { label="近戰免疫", tooltip="顯示免疫近戰傷害"};
obj[9]	= { label="技能傷害", tooltip="顯示被技能傷害"};
obj[10]	= { label="技能爆擊", tooltip="顯示被技能爆擊"};
obj[11]	= { label="技能持續傷害", tooltip="顯示被技能持續傷害"};
obj[12]	= { label="技能未命中", tooltip="顯示未被技能命中"};
obj[13]	= { label="技能閃躲", tooltip="顯示閃躲技能攻擊"};
obj[14]	= { label="技能招架", tooltip="顯示招架技能攻擊"};
obj[15]	= { label="技能格擋", tooltip="顯示格擋技能攻擊"};
obj[16]	= { label="法術抵抗", tooltip="顯示抵抗法術攻擊"};
obj[17]	= { label="技能吸收", tooltip="顯示吸收技能傷害"};
obj[18]	= { label="技能免疫", tooltip="顯示免疫技能傷害"};
obj[19]	= { label="技能反射", tooltip="顯示反射技能傷害"};
obj[20]	= { label="法術打斷", tooltip="顯示打斷法術"};
obj[21]	= { label="治療", tooltip="顯示被治療"};
obj[22]	= { label="爆擊治療", tooltip="顯示被治療爆擊"};
obj[23]	= { label="持續治療", tooltip="顯示被持續治療"};
obj[24]	= { label="環境傷害", tooltip="顯示環境傷害（如跌落，窒息，熔岩等）"};

obj = L.INCOMING_PET_EVENTS;
obj[1]	= { label="近戰傷害", tooltip="顯示寵物被近戰傷害"};
obj[2]	= { label="近戰爆擊", tooltip="顯示寵物被近戰爆擊"};
obj[3]	= { label="近戰未命中", tooltip="顯示寵物未被近戰命中"};
obj[4]	= { label="近戰閃躲", tooltip="顯示寵物閃躲近戰攻擊"};
obj[5]	= { label="近戰招架", tooltip="顯示寵物招架近戰攻擊"};
obj[6]	= { label="近戰格擋", tooltip="顯示寵物格擋近戰攻擊"};
obj[7]	= { label="近戰吸收", tooltip="顯示寵物吸收近戰傷害"};
obj[8]	= { label="近戰免疫", tooltip="顯示寵物免疫近戰傷害"};
obj[9]	= { label="技能傷害", tooltip="顯示寵物被技能傷害"};
obj[10]	= { label="技能爆擊", tooltip="顯示寵物被技能爆擊"};
obj[11]	= { label="技能持續傷害", tooltip="顯示寵物被技能持續傷害"};
obj[12]	= { label="技能未命中", tooltip="顯示寵物未被技能命中"};
obj[13]	= { label="技能閃躲", tooltip="顯示寵物閃躲技能攻擊"};
obj[14]	= { label="技能招架", tooltip="顯示寵物招架技能攻擊"};
obj[15]	= { label="技能格擋", tooltip="顯示寵物格擋技能攻擊"};
obj[16]	= { label="法術抵抗", tooltip="顯示寵物抵抗法術攻擊"};
obj[17]	= { label="技能吸收", tooltip="顯示寵物吸收技能傷害"};
obj[18]	= { label="技能免疫", tooltip="顯示寵物免疫技能傷害"};
obj[19]	= { label="治療", tooltip="顯示寵物被治療"};
obj[20]	= { label="治療爆擊", tooltip="顯示寵物被治療爆擊"};
obj[21]	= { label="持續治療", tooltip="顯示寵物被持續治療"};


------------------------------
-- Outgoing events
------------------------------

obj = L.OUTGOING_PLAYER_EVENTS;
obj[1]	= { label="近戰傷害", tooltip="顯示對敵近戰傷害"};
obj[2]	= { label="近戰爆擊", tooltip="顯示對敵近戰爆擊"};
obj[3]	= { label="近戰未命中", tooltip="顯示近戰未命中敵人"};
obj[4]	= { label="近戰閃躲", tooltip="顯示敵人閃躲近戰攻擊"};
obj[5]	= { label="近戰招架", tooltip="顯示敵人招架近戰攻擊"};
obj[6]	= { label="近戰格擋", tooltip="顯示敵人格擋近戰攻擊"};
obj[7]	= { label="近戰吸收", tooltip="顯示敵人吸收近戰傷害"};
obj[8]	= { label="近戰免疫", tooltip="顯示敵人免疫近戰傷害"};
obj[9]	= { label="近戰閃避", tooltip="顯示敵人閃避近戰攻擊"};
obj[10]	= { label="技能傷害", tooltip="顯示技能傷害敵人"};
obj[11]	= { label="技能爆擊", tooltip="顯示技能爆擊敵人"};
obj[12]	= { label="技能持續傷害", tooltip="顯示技能持續傷害敵人"};
obj[13]	= { label="技能未命中", tooltip="顯示技能未命中敵人"};
obj[14]	= { label="技能閃躲", tooltip="顯示敵人閃躲技能攻擊"};
obj[15]	= { label="技能招架", tooltip="顯示敵人招架技能攻擊"};
obj[16]	= { label="技能格擋", tooltip="顯示敵人格擋技能攻擊"};
obj[17]	= { label="法術抵抗", tooltip="顯示敵人抵抗法術攻擊"};
obj[18]	= { label="技能吸收", tooltip="顯示敵人吸收法術傷害"};
obj[19]	= { label="技能免疫", tooltip="顯示敵人免疫技能傷害"};
obj[20]	= { label="技能反射", tooltip="顯示敵人反射技能傷害"};
obj[21]	= { label="法術打斷", tooltip="顯示法術攻擊被打斷"};
obj[22]	= { label="技能閃避", tooltip="顯示技能攻擊被閃避"};
obj[23]	= { label="治療", tooltip="顯示治療目標"};
obj[24]	= { label="治療爆擊", tooltip="顯示爆擊治療目標"};
obj[25]	= { label="持續治療", tooltip="顯示持續治療目標"};
obj[26]	= { label="淨化法術", tooltip="顯示你的淨化法術"};

obj = L.OUTGOING_PET_EVENTS;
obj[1]	= { label="近戰傷害", tooltip="顯示寵物近戰傷害"};
obj[2]	= { label="近戰爆擊", tooltip="顯示寵物近戰爆擊"};
obj[3]	= { label="近戰未命中", tooltip="顯示寵物的近戰攻擊未命中敵人"};
obj[4]	= { label="近戰閃躲", tooltip="顯示寵物的近戰攻擊被閃躲"};
obj[5]	= { label="近戰招架", tooltip="顯示寵物的近戰攻擊被招架"};
obj[6]	= { label="近戰格擋", tooltip="顯示寵物的近戰攻擊被格擋"};
obj[7]	= { label="近戰吸收", tooltip="顯示寵物的近戰傷害被吸收"};
obj[8]	= { label="近戰免疫", tooltip="顯示寵物的近戰傷害被免疫"};
obj[9]	= { label="近戰閃避", tooltip="顯示寵物的近戰攻擊被閃避"};
obj[10]	= { label="技能傷害", tooltip="顯示寵物的技能傷害"};
obj[11]	= { label="技能爆擊", tooltip="顯示寵物的技能爆擊"};
obj[12]	= { label="技能持續傷害", tooltip="顯示寵物技能的持續傷害"};
obj[13]	= { label="技能未命中", tooltip="顯示寵物技能攻擊未命中敵人"};
obj[14]	= { label="技能閃躲", tooltip="顯示寵物的技能攻擊被閃躲"};
obj[15]	= { label="技能招架", tooltip="顯示寵物的技能攻擊被招架"};
obj[16]	= { label="技能格擋", tooltip="顯示寵物的技能攻擊被格擋"};
obj[17]	= { label="法術抵抗", tooltip="顯示寵物的法術攻擊被抵抗"};
obj[18]	= { label="技能吸收", tooltip="顯示寵物的技能傷害被吸收"};
obj[19]	= { label="技能免疫", tooltip="顯示寵物的技能傷害被免疫"};
obj[20]	= { label="技能閃避", tooltip="顯示寵物的技能攻擊被閃避"};
obj[21]	= { label="淨化法術", tooltip="顯示寵物的淨化法術"};


------------------------------
-- Notification events
------------------------------

obj = L.NOTIFICATION_EVENTS;
obj[1]	= { label="Debuff", tooltip="顯示你遭受的Debuff"};
obj[2]	= { label="Buff", tooltip="顯示你得到的Buff"};
obj[3]	= { label="物品Buff", tooltip="顯示使用物品得到的Buff"};
obj[4]	= { label="Debuff消失", tooltip="顯示從你身上消失的Debuff"};
obj[5]	= { label="Buff消失", tooltip="顯示從你身上消失的Buff"};
obj[6]	= { label="物品Buff消失", tooltip="顯示從你身上消失的物品Buff"};
obj[7]	= { label="戰鬥開始", tooltip="顯示你已經開始戰鬥"};
obj[8]	= { label="戰鬥結束", tooltip="顯示你已經結束了戰鬥"};
obj[9]	= { label="能量獲得", tooltip="顯示你額外獲得的法力，怒氣或者能量"};
obj[10]	= { label="能量失去", tooltip="顯示你失去的法力，怒氣或者能量"};
obj[11]	= { label="連擊點獲得", tooltip="顯示你獲得的連擊點"};
obj[12]	= { label="連擊點全滿", tooltip="顯示你的連擊點已滿"};
obj[13]	= { label="獲得榮譽", tooltip="顯示你獲得榮譽"};
obj[14]	= { label="聲望提高", tooltip="顯示你的聲望提高"};
obj[15]	= { label="聲望下降", tooltip="顯示你的聲望下降"};
obj[16]	= { label="獲得技能點", tooltip="顯示你獲得了技能點"};
obj[17]	= { label="獲得經驗", tooltip="顯示你獲得了經驗值"};
obj[18]	= { label="擊殺玩家", tooltip="顯示你擊殺了一個敵對玩家"};
obj[19]	= { label="擊殺NPC", tooltip="顯示你擊殺了一個敵對NPC"};
obj[20]	= { label="獲得靈魂碎片", tooltip="顯示你獲得了一個靈魂碎片"};
obj[21]	= { label="額外攻擊", tooltip="顯示你從風怒，痛擊之刃，劍系掌握等方面獲得了一次額外攻擊"};
obj[22]	= { label="敵人獲得Buff", tooltip="顯示目前敵對目標獲得的Buff"};
obj[23]	= { label="怪物表情", tooltip="顯示目前目標怪物表情"};
obj[24]	= { label="獲得金錢", tooltip="顯示獲得的金錢"};


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
obj["SPELL_CAST_START"]			= "開始施法";
--obj["SPELL_CAST_SUCCESS"]		= "Cast Success";
--obj["SPELL_CAST_FAILED"]		= "Cast Failure";
--obj["SPELL_SUMMON"]				= "Summon";
--obj["SPELL_CREATE"]				= "Create";
obj["PARTY_KILL"]				= "擊殺音效";
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
obj["buffActive"]				= "Buff啟動";
--obj["currentCP"]				= "Current Combo Points";
--obj["currentPower"]				= "Current Power";
obj["recentlyFired"]			= "最近觸發過";
obj["trivialTarget"]			= "次級目標";
--obj["unavailableSkill"]			= "Unavailable Skill";
obj["warriorStance"]			= "戰士姿態";
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
--obj["unitTypePlayer"]			= PLAYER; 
--obj["unitTypeNPC"]				= "NPC";
--obj["unitTypePet"]				= PET;
--obj["unitTypeGuardian"]			= "Guardian";
--obj["unitTypeObject"]			= "Object";

-- Aura types.
--obj["auraTypeBuff"]				= "Buff";
--obj["auraTypeDebuff"]			= "Debuff";

-- Zone types.
--obj["zoneTypeArena"]			= "Arena";
--obj["zoneTypePvP"]				= BATTLEGROUND;
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
obj[1] = "無";
obj[2] = "細";
obj[3] = "粗";

-- Text aligns.
obj = L.TEXT_ALIGNS;
obj[1] = "左邊";
obj[2] = "中間";
obj[3] = "右邊";


------------------------------
-- Sound info
------------------------------

obj = L.SOUNDS;
obj["LowMana"]		= "法力過低";
obj["LowHealth"]	= "生命過低";


------------------------------
-- Animation style info
------------------------------

-- Animation styles
obj = L.ANIMATION_STYLE_DATA;
obj["Horizontal"]	= "水平";
obj["Parabola"]		= "拋物線";
obj["Straight"]		= "直線";
obj["Static"]		= "靜止";
obj["Pow"]			= "繃跳";

-- Animation style directions.
obj["Alternate"]	= "交替";
obj["Left"]			= "左";
obj["Right"]		= "右";
obj["Up"]			= "上";
obj["Down"]			= "下";

-- Animation style behaviors.
obj["GrowUp"]			= "漸漸向上";
obj["GrowDown"]			= "漸漸向下";
obj["CurvedLeft"]		= "弧形向左";
obj["CurvedRight"]		= "弧形向右";
obj["Jiggle"]			= "抖動";
obj["Normal"]			= "一般";