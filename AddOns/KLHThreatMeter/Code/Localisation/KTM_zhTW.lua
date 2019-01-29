--[[
-- Traditional Chinese localization file Copyright
--
-- You may only distribute electronic versions of this file, for non-commercial 
-- purposes and not for resale.
--
-- You may not sell, rent, lease, loan, sublicense or otherwise commercially 
-- distribute this file.
--
-- You may not modify or remove the author name.
--
-- Otherwise you may use this file free with KLHThreatMeter AddOn in WoW Taiwan 
-- edition, EXCEPT meidoku.

-- 正體中文語系檔版權
--
-- 你只被允許在非商業目的下, 以電子檔的形式散播本檔案, 且禁止販售.
-- 你不得販賣, 出租, 抵押, 再授權或是其他商業行為散播此檔案.
-- 你不得修改或移除作者的名字.
-- 除此之外, 你可以免費的在繁體中文版魔獸世界中與插件 KLHThreatMeter 使用本檔, 
-- 唯獨不授權給予 meidoku 使用.
--
-- 繁体字中国語ローカライズファイル著作権
--
-- あなたは転売ではなく、非営利的な目的のためのこのファイルの電子版を分配する
-- ことができるだけです。
-- あなたは売れることができないで、借りてください、そして、リース、
--「副-ライセンス」の、または、そうでないローンは商業的にこのファイルを分配します。
-- あなたは、作者名を変更することができないし、取り除くことができません。
-- さもなければ、meidokuを除いて、あなたはWorld of Warcraft台湾版でKLHThreatMeter 
-- AddOnを惜しまないこのファイルを使用することができます。
--
-- KLHThreatMeter Traditional Chinese localization file
-- Maintained by: Kuraki, Suzuna
-- Last updated: 04/11/2007 (19.16)
--
-- 接力翻譯 BY 憤怒使者的胖胖鳥
-- 公會開始轉入OMEN時代 KTM我應該不會再搞下去
-- 假如有人接手的話就把我的碎碎念刪掉吧
-- Last updated: 09/20/2007 (20.4)
--
-- revised again by ethyne乙炔@語風 2008/March/5 for 20.5b
--]]

thismod.string.data["zhTW"] = 
{
	copybox = "按下 |cffffff00Ctrl + C|r 複製文字到剪貼簿.",
	
	errorbox = 
	{
		header = "%s 錯誤", -- %s == mod.global.name
		body = "在 %s 發生了一個錯誤. 從幫助選單檢查錯誤紀錄區段以取得詳細資訊.\n\n",
		first = "較早前發生的這個錯誤將會被抑制.",
		second = "所有較早前的錯誤都將被抑制.",
	},
	
	console = 
	{
		nocommand = "|cffff8888沒有這個命令 |cffffff00%s|r.",
		ambiguous = "你指的是下面這些命令中的哪一個呢?",
		run = "|cff8888ff執行命令 %s|r.",
		
		help = 
		{
			test = 
			{
				["#help"] = "測試這個插件偵測套裝, 天賦以及其他數值是否正確.",
				gear = "列印出穿在你身上會影響仇恨計算的套裝部位.",
				talents = "列印出任何會影響仇恨的天賦.",
				threat = "列印出仇恨變動參數.",
				time = "列印出處理時間資訊.",
				memory = "列印出記憶體使用資訊.",
				states = "檢查這個插件的狀態變數是否正確.",
				locale = "檢查在你的語言中, 有哪些翻譯被遺漏了.",
			},
			
			version = 
			{
				["#help"] = "版本控制命令. 需要幹部權限.",
				query = "要求所有團隊中的人回報他們的版本.",
				notify = "提醒使用較舊版本的人升級插件.",
			},
			
			gui = 
			{
				["#help"] = "團隊視窗的基本命令.",
				show = "顯示團隊視窗.",
				hide = "隱藏團隊視窗.",
				reset = "重置團隊視窗位置到螢幕中央."
			},
			
			boss = 
			{
				["#help"] = "用來決定和設定首領技能.",
				report = "當玩家的仇恨被首領的技能改變時, 做無聲回報.",
				endreport = "當玩家的仇恨被首領的技能改變時, 停止回報.",
				setspell = "改變已知首領的技能參數.",
			},
			
			disable = "緊急停止: 停止事件 / 更新事件.",
			enable = "在緊急停止後重新啟動這個插件.",
			mastertarget = "設定或清除主要目標.",
			resetraid = "把團隊中所有人的仇恨重置.",
			help = "顯示輔助選單.",
			
		},
	},
	
	["raidtable"] = 
	{
		tooltip = 
		{
			close = "關閉",
			closetext = "隱藏這個視窗.",
			options = "選項",
			optionstext = "設定本視窗的配置與外框顏色.",
			minimise = "最小化",
			minimisetext = "最小化本列表, 只留下最頂端的部份顯示. 再點擊一次顯示本列表.",
			setmt = "設定主要目標",
			setmttext = "設定主要目標為你目前的目標, 或是你現在有選擇目標, 則清除主要目標.",
		},
		
		column = 
		{
			name = "名稱",
			threat = "仇恨",
			percent = "%Max", -- percentage of maximum, but has to be short!
			persecond = "TPS", -- threat per second. again, must be short.
		},
	},
	["menu"] = 
	{
		top = 
		{
			description = "首頁",
			text = "歡迎來到 |cffffff00%s |cff00ff00%s.%s|r 選單.\n\n這裡是首頁. 目前的主題名稱將會被顯示在本視窗正上方. 在左邊的選單, 則顯示了一些相關的主題.\n\n左上方的選單是目前主題的上一層選單. 點擊它可以回到上一層主題.\n\這個方框下方是目前主題的細部主題. 點擊他們可以觀看單獨的細部主題.\n\n想關閉這個幫助選單, 點擊本主題窗右上方的 X 按鈕.",
		},
		
		raidtable = 
		{
			description = "團隊列表",
			text = "本頁設定團隊列表的顯示.\n\n在 |cffffff00配色|r 頁允許你改變文字與外框的顏色.\n\n在 |cffffff00配置|r 頁你可以列表的改變大小與方向.\n\n在 |cffffff00行與列|r 頁可以改變顯示在表格中的橫列以及控制哪些職業要顯示.",
			button = "顯示團隊列表",
			
			colour = 
			{
				description = "配色",
				
				text1 = "點擊這裡改變團隊列表的外框顏色:",
				button1 = "設定外框顏色",
				text2 = "點擊這裡改變主要文字的顏色 (例如: 標題列):",
				button2 = "設定主要文字顏色",
				text3 = "點擊這裡改變次要文字顏色 (例如: 一般文字):",
				button3 = "設定次要文字顏色",
				text4 = "設定透明度 (alpha 數值). 100% 完全顯示, 0% 隱形.",
				slider = "Alpha 數值",
			},
			
			layout = 
			{
				description = "配置",
				
				text1 = "你可以在這裡指定該如何填滿列表. 這個視窗的某一個邊角總是固定的, 同時, 這個列表將會朝向對角方向擴展. 因此, 如果固定的邊角是左上, 這個列表將會往下以及往右邊擴展. 點擊某個按鈕以改變固定的邊角.",
				button1 = "左上",
				button2 = "右上",
				button3 = "左下",
				button4 = "右下",
				
				text2 = "設定團隊列表擁有的最大橫列數目.",
				slider = "列數",
				
				text3 = "如果這個選項被選取, 且列表內的內容較少時, 列表的長度將會被減少. 否則將會維持固定大小.",
				checkbox = "緊密的列表",
				
				text4 = "改變團隊列表所有物件的大小",
				slider2 = "縮放",
			},
			
			filter = 
			{
				description = "行與列",
				text1 = "選擇你想在團隊列表看到的職業.",
				text2 = "選擇你想在團隊列表看到的列.",
				
				threat = "顯示仇恨列.",
				percent = "顯示百分比列 (%s).",
				persecond = "顯示每秒仇恨列 (%s).",
				
				text3 = "|cffffff00%s|r 棒告訴你還需要多少仇恨可以取得 aggro. 如果坦克受到了某些等因素暫時失去 aggro, 比方說恐懼. 而 DPS 群的仇恨值低於 |cffffff00%s|r, 則坦克將會在恐懼結束後重新取得 aggro.",
			
				aggrogain = "顯示 |cffffff00%s|r 條.",
				tankregain = "顯示 |cffffff00%s|r 條. ",
			},
			
			misc = 
			{
				description = "其他",
				text1 = "設定當你加入或離開一個隊伍時, KTM 視窗將自動顯示或隱藏.",
				leavegroup = "當我離開一個隊伍時, 隱藏本視窗.",
				joinparty = "當我加入一個隊伍時, 顯示本視窗.",
				joinraid = "當我加入一個團隊時, 顯示本視窗.",
				
				text2 = "你可以預防本視窗被意外拖動到其他地方.",
				lockwindow = "鎖定本視窗在原地.",
			}
		},
		
		mythreat = 
		{
			description = "我的仇恨狀態",
			reset = "重置",
			update = "更新",
		},
		
		errorlog = 
		{
			description = "錯誤紀錄",
			
			text1 = "這一頁列出本插件模組的所有非致命性錯誤. 本插件可能可以繼續操作, 但是有些元件將停止工作. 因此, 你的仇很可能無法精準的計算.\n\n最好的辦法是, 將這些錯誤回報到網站: |cffffff00%s|r .",
			
			text2 = "顯示第 %d / %d 的錯誤.",
			
			button1 = "複製網站位置",
			button2 = "上一個錯誤",
			button3 = "下一個錯誤",
			button4 = "複製錯誤詳細訊息",
			
			format = 
			{
				module = "|cffffff00模組 =|r %s",
				process = "|cffffff00行程 =|r %s",
				extradata = "|cffffff00額外資料 =|r %s",
				message = "|cffffff00錯誤訊息 =|r %s",
			},
		},
		
		bossmod = 
		{
			description = "首領模組",
			text = "這一頁是關於插件的首領模組.\n\n|cffffff00內建|r 部分有一系列內建的首領模組附屬於這個插件.\n\n|cffffff00自訂|r 部份有一系列使用者自訂的首領模組. 你可以設計自訂的首領模組並且將檔案輸出或者是對團隊成員廣播內容.",
			
			builtin = 
			{
				description = "內建",
				text1 = "這是一系列內建的首領模組. 點選項目來查看細節.",
			},
			
			usermade = 
			{
				description = "自訂",
				text1 = "點選清單中項目來查看該首領模組的細節. 點選 |cffffff00廣播|r 來發送模組給團隊成員. |cffffff00匯出|r 轉換模組成唯一個文字字串檔案讓其他使用者可以下載並使用 |cffffff00匯入|r 按鈕.\n點選 |cffffff00新增|r 來建立一個新的模組, |cffffff00刪除|r 來刪除選取的模組, 或|cffffff00編輯|r 來改變.", 
				
				button = 
				{
					import = "匯入",
					export = "匯出",
					broadcast = "廣播",
				}
			}
		}		
	},
	
	generic = 
	{
		finish = "結束",
		cancel = "取消",
		close = "關閉",
		delete = "刪除",
		edit = "編輯",
		new = "新增",
		next = "繼續",
		back = "返回",
	},
	
	wizard = 
	{
		editboss = 
		{
			header = "改變 |cffffff00%s|r 首領模組.",
			description = "為這個首領模組取名字並輸入於下. 假如它包含法術事件, 確保它完全地吻合首領實際名稱. 建議命名清單顯示在右邊. 點選清單中的一個項目來使用這個名字.\n點選 |cffffff00結束|r 來完成首領模組, 或 |cffffff00取消|r 來防止檔案更動. |cffffff00繼續|r 將前往首領喊話設定.",
		},
		customhandler = 
		{
			heading = "為了 |cffffff00%s|r 建立一自訂執行流程.",
			description = "• 不要將程式碼包裹在  |cffffff00function ... end|r\n• 你允許接觸這類變數:\n1) |cffffff00mod|r - pointer to %s table\n2) |cffffff00data|r - persistent data store for the function (empty table)\n• 一些有用的程式碼:\n1) |cffffff00value = mod.table.getraidthreat()|r - 你當前的仇恨\n2) |cffffff00something about the raid reset here|r - lol",
			error = "這個功能沒有定義. 錯誤是\n|cffffff00%s.",
		}
	},
		
	class = 
	{
		warrior = "戰士",
		priest = "牧師",
		druid = "德魯伊",
		rogue = "盜賊",
		shaman = "薩滿",
		mage = "法師",
		paladin = "聖騎士",
		warlock = "術士",
		hunter = "獵人",
	},
	
	["binding"] =
	{
		hideshow = "隱藏 / 顯示視窗",
		stop = "緊急停止",
		mastertarget = "設定 / 清除主要目標",
		resetraid = "重置團隊仇恨",
	},
	["spell"] =
	{
		feigndeath = "假死",
		mortalstrike = "致死打擊",
		bloodthirst = "嗜血",
		
		-- 19
		vampirictouch = "吸血之觸",
		bindingheal = "束縛治療",
		leaderofthepack = "獸群領袖",
		faeriefire = "精靈之火(野性)",
		shadowguard = "暗影守衛",
		anesthetic = "麻醉毒藥",
		bearmangle = "割碎(熊型態)",
		thunderclap = "雷霆一擊",
		soulshatter = "靈魂粉碎",
		invisibility = "隱形術",
		misdirection = "誤導",
		disengage = "逃脫",
		anguish = "苦痛", -- Felguard
		lacerate = "割裂", 
		
		-- 18.x
		torment = "折磨",
		suffering = "受難",
		soothingkiss = "安撫之吻",
		intimidation = "脅迫",
		
		righteousdefense = "正義防禦",
		eyeofdiminution = "統禦之眼", -- buff from trinket "Eye of Diminution". The buff appears to be slightly different, with 'The' at the start.
		notthere = "不在那", -- the buff from Frostfire 8/8 Proc
		frostshock = "冰霜震擊", 
		reflectiveshield = "反射護盾", -- this is the damage from Power Word:Shield with the talent.
		devastate = "挫敗",
		stormstrike = "風暴打擊",
		
		-- warlock affliction spells (others already existed below)
		corruption = "腐蝕術",				
		curseofagony = "痛苦詛咒",
		drainsoul = "靈魂虹吸",
		curseofdoom = "厄運詛咒",
		unstableaffliction = "痛苦動盪",
		
		-- new warlock destruction spells
		shadowfury = "暗影之怒",
		incinerate = "燒盡", 
		
		-- 17.20
		["execute"] = "斬殺",
		
		["heroicstrike"] = "英勇打擊",
		["maul"] = "搥擊",
		["swipe"] = "揮擊",
		["shieldslam"] = "盾牌猛擊",
		["revenge"] = "復仇",
		["shieldbash"] = "盾擊",
		["sunder"] = "破甲攻擊",
		["feint"] = "佯攻",
		["cower"] = "畏縮",
		["taunt"] = "嘲諷",
		["growl"] = "低吼",
		["vanish"] = "消失",
		["frostbolt"] = "寒冰箭",
		["fireball"] = "火球術",
		["arcanemissiles"] = "秘法飛彈",
		["scorch"] = "灼燒",
		["cleave"] = "順劈斬",
		
		hemorrhage = "出血",
		backstab = "背刺",
		sinisterstrike = "邪惡攻擊",
		eviscerate = "剔骨",
		
		-- Items / Buffs:
		["arcaneshroud"] = "秘法環繞",
		["blackamnesty"] = "降低威脅",

		-- Leeches: no threat from heal
		["holynova"] = "神聖新星", -- no heal or damage threat
		["siphonlife"] = "生命虹吸", -- no heal threat
		["drainlife"] = "吸取生命", -- no heal threat
		["deathcoil"] = "死亡纏繞",

		-- Fel Stamina and Fel Energy DO cause threat! GRRRRRRR!!!
		--["felstamina"] = "惡魔耐力",
		--["felenergy"] = "惡魔能量",

		["bloodsiphon"] = "血液虹吸", -- poisoned blood vs Hakkar

		["lifetap"] = "生命分流", -- no mana gain threat
		["holyshield"] = "神聖之盾", -- multiplier
		["tranquility"] = "寧靜",
		["distractingshot"] = "擾亂射擊",
		["earthshock"] = "地震術",
		["rockbiter"] = "石化",
		["fade"] = "漸隱術",
		["thunderfury"] = "雷霆之怒",

		-- Spell Sets
		-- warlock descruction
		["shadowbolt"] = "暗影箭",
		["immolate"] = "獻祭",
		["conflagrate"] = "燃燒",
		["searingpain"] = "灼熱之痛", -- 2 threat per damage
		["rainoffire"] = "火焰之雨",
		["soulfire"] = "靈魂之火",
		["shadowburn"] = "暗影灼燒",
		["hellfire"] = "地獄烈焰",

		-- mage offensive arcane
		["arcaneexplosion"] = "魔爆術",
		["counterspell"] = "法術反制",

		-- priest shadow. No longer used (R17).
		["mindblast"] = "心靈震爆",	-- 2 threat per damage
		--[[
		["mindflay"] = "精神鞭笞",
		["devouringplague"] = "吸血鬼的擁抱",
		["shadowwordpain"] = "暗言術:痛",
		,
		["manaburn"] = "法力燃燒",
		]]
	},
	["power"] =
	{
		["mana"] = "法力",
		["rage"] = "怒氣",
		["energy"] = "能量",
	},
	["threatsource"] = -- these values are for user printout only
	{
		["powergain"] = "能源產生",
		["total"] = "總計",
		["special"] = "特殊",
		["healing"] = "治療",
		["dot"] = "持續傷害",
		["threatwipe"] = "仇恨減免",
		["damageshield"] = "傷害盾",
		["whitedamage"] = "白字傷害",
	},
	["talent"] = -- these values are for user printout only
	{
		improvedberserker = "強化狂暴姿態",
		tacticalmastery = "精通戰術",
		fanaticism = "狂熱",		
		["defiance"] = "挑釁",
		["impale"] = "穿刺",
		["silentresolve"] = "無聲消退",
		["frostchanneling"] = "冰霜導能",
		["burningsoul"] = "燃燒之魂",
		["healinggrace"] = "治療之賜",
		["shadowaffinity"] = "精神治療",
		["druidsubtlety"] = "微妙",
		["feralinstinct"] = " 野性本能",
		["ferocity"] = "兇暴",
		["savagefury"] = "野蠻暴怒",
		["tranquility"] = "強化寧靜",
		["masterdemonologist"] = "惡魔學識大師",
		["arcanesubtlety"] = "秘法精妙",
		["righteousfury"] = "強化憤怒聖印",
		["sleightofhand"] = "靈巧之手",
		voidwalker = "強化虛空行者",
	},
	["threatmod"] = -- these values are for user printout only
	{
		["tranquilair"] = "寧靜之風圖騰",
		["salvation"] = "拯救祝福",
		["battlestance"] = "戰鬥姿態",
		["defensivestance"] = "防禦姿態",
		["berserkerstance"] = "狂暴姿態",
		["defiance"] = "挑釁",
		["basevalue"] = "基本值",
		["bearform"] = "熊型態",
		["catform"] = "貓型態",
		["glovethreatenchant"] = "手套附魔增加威脅值",
		["backthreatenchant"] = "披風附魔減少威脅值",
	},

	["sets"] =
	{
		["bloodfang"] = "血牙",    -- Rog, 5件 增加佯攻減少的威脅值 25%
		["nemesis"] = "復仇",      -- Wlk, 8件 降低毀滅系法術所產生的威脅值 20%
		["netherwind"] = "靈風",   -- Mag, 3件 使你的灼燒(-100)、祕法飛彈(每發-20)、火球術(-100)和寒冰箭(-100)所造成的威脅值降低
		["might"] = "力量",        -- War, 8件 增加破甲產生的威脅值 15%
		["arcanist"] = "祕法師",   -- Mag, 8件 使你因攻擊而產生的威脅值減少15%
		bonescythe = "骨鐮",       -- Rog, 6件 使你的邪惡攻擊、背刺、出血、和剔骨所產生的威脅值降低 (-8%)
		plagueheart = "瘟疫之心",  -- Wlk, 6件 你的法術造成致命一及後降低該法術25%威脅值. 另外，腐蝕術、獻祭、痛苦詛咒和生命吸虹所產生的威脅值降低25%.
	},
	["boss"] =
	{
		["speech"] =
		{
			onyxiapull = "不用離開",	--不確定 "I must leave my lair" 
			onyxiaphase2 = "這毫無意義的行動讓我很厭煩。我會從上空把你們都燒成灰!",
			["onyxiaphase3"] = "看起來需要再給你一次教訓",

			["razorgorepull"] = "在寶珠的控制力消失之前逃走。",
			["thekalphase2"] = "給我憤怒的力量吧",
			["azuregosport"] = "來吧，小子。面對我!",
			["nefarianpull"] = "燃燒吧!你這個不幸的人!燃燒吧!",

			nightbaneland1 = "夠了!我要親自挑戰你!",
			nightbaneland2 = "昆蟲!給你們近距離嚐嚐我的厲害!",
			nightbanepull = "真是蠢蛋!我會快點結束你的痛苦!",
			
			attumenmount = "來吧午夜，讓我們驅散這群小規模的烏合之眾!",
			magtheridonpull = "我……被……釋放了!",
			ragnarospull = "YOU HAVE AWAKENED ME TOO SOON",
			
			hydrosspull = "我不准你涉入這件事!",
			hydrossswap1 = "啊，毒……",
			hydrossswap2 = "很好，舒服多了。",
			
			leotherasswap = "消失吧，微不足道的精靈。現在開始由我掌管!",
			leotheraspull = "終於結束了我的流放生涯!",
			
			nothpull1 = "榮耀歸於我主!",
			nothpull2 = "我要沒收你的生命!",
			nothpull3 = "死吧,入侵者!", 
						
			rajaxxpull = "厚顏無恥的笨蛋!我要親手殺了你!",
			rajaxxignore = "You are not worth my time,? (%s)!",
			
			kaelthasphase1a = "你已經努力的打敗了我的幾位最忠誠的諫言者…但是沒有人可以抵抗血錘的力量。等著看桑古納爾的力量吧!",
			kaelthasphase1b = "卡普尼恩將保證你們不會在這裡停留太久。",
			kaelthasphase1c = "做得好，你已經證明你的實力足以挑戰我的工程大師泰隆尼卡斯。",
			kaelthasphase2 = "你們看，我的個人收藏中有許多武器……",
			kaelthasphase3 = "也許我低估了你。要你一次對付四位諫言者也許對你來說是不太公平，但是……我的人民從未得到公平的對待。我只是以牙還牙而已。",
			kaelthasphase4 = "我的心血是不會被你們輕易浪費的!我精心謀劃的未來是不會被你們輕易破壞的!感受我真正的力量吧!",
			kaelthasphase4b = "唉，有些時候，有些事情，必須得親自解決才行。(薩拉斯語)受死吧!",
			
			supremusphase1 = "瑟普莫斯憤怒的捶擊地面!",
			
			morogrimpull = "深海的洪水，淹沒吧!",
			
			vashjpull1 = "我唾棄你們，地表的渣滓!",
			vashjpull2 = "伊利丹王必勝!",
			vashjpull3 = "我要把你們全部殺死!",
			vashjpull4 = "我不想要因為跟你這種人交手而降低我自己的身份，但是你們讓我別無選擇……",
			vashjpull5 = "入侵者都要死!",

			solarianpull = "與血精靈為敵者死!",
			
			reliquaryphase2 = "你可以得到任何你想要的東西……只要付得起代價。",
			reliquaryphase3 = "當心吧，我復活了﹗",

			illidanphase1 = "你們還沒準備好!",
			illidanphase3 = "感受我體內的惡魔之力吧!",
			illidanphase4 = "你們就這點本事嗎?這就是你們全部的能耐?",
			illidanphase5 = "瑪翼夫...這怎麼可能呢?",
		},
		-- Some of these are unused. Also, if none is defined in your localisation, they won't be used,
		-- so don't worry if you don't implement it.
		["name"] =
		{
			["rajaxx"] = "拉賈克斯將軍",
			["onyxia"] = "奧妮克希亞",
			["ebonroc"] = "埃博諾克",
			firemaw = "費爾默",
			flamegor = "弗萊格爾",

			["razorgore"] = "狂野的拉佐格爾",
			["thekal"] = "古拉巴什食腐者",
			["shazzrah"] = "沙斯拉爾",
			["twinempcaster"] = "維克洛爾大帝",
			["twinempmelee"] = "維克尼拉斯大帝",
			["noth"] = "瘟疫者諾斯",
			["leotheras"] = "盲目者李奧薩拉斯",
			ouro = "奧羅",
			voidreaver = "虛無搶奪者",
			bloodboil = "葛塔格‧血沸",
			doomwalker = "厄運行者",
			ragnaros = "拉格納羅斯",
			patchwerk = "縫補者",
			leotheras = "『盲目者』李奧薩拉斯",

			supremus = "瑟普莫斯",
			attumen = "獵人阿圖曼",
			nefarian = "奈法利安",
			vashj = "瓦許女士",
			solarian = "高階星術師索拉瑞恩",
			nightbane = "夜禍",
			azuregos = "艾索雷格斯",
			hydross = "不穩定者海卓司",
			reliquary = "靈魂精華群",
			kaelthas = "凱爾薩斯·逐日者",
			loatheb = "洛斯伯",
			morogrim = "莫洛葛利姆·潮行者",
			horsemen = "四騎士",
			magtheridon = "瑪瑟里頓",

			illidan = "伊利丹‧怒風",
			--伊利丹戰鬥過程中出現的小目標
			azzinoth = "埃辛諾斯之焰", -- DON'T BLIND COPY. If you don't know it set to nil!
			azzinothblade = "埃辛諾斯之刃",
			
		},
		["spell"] =
		{
			["shazzrahgate"] = "沙斯拉爾之門", -- "Shazzrah casts Gate of Shazzrah."
			["wrathofragnaros"] = "拉格納羅斯之怒", -- "Ragnaros's Wrath of Ragnaros hits you for 100 Fire damage."
			["timelapse"] = "時間流逝", -- "You are afflicted by Time Lapse."
			["knockaway"] = "擊退",
			["wingbuffet"] = "龍翼打擊",
			["burningadrenaline"] = "燃燒刺激",
			["twinteleport"] = "雙子傳送",
			["nothblink"] = "閃現術",
			["sandblast"] = "沙塵爆裂",
			["fungalbloom"] = "真菌成長",
			["hatefulstrike"] = "憎恨打擊",
			
			-- 4 horsemen marks
			mark1 = "布洛莫斯印記",
			mark2 = "寇斯艾茲印記",
			mark3 = "莫格萊尼印記",
			mark4 = "札里克印記",
			
			-- Onyxia fireball (presumably same as mage)
			fireball = "火球術",
			
			-- Leotheras, Maulgar, Sartura etc
			whirlwind = "旋風斬",
            
		        -- Gurtogg Bloodboil(未確定)
	       		insignifigance = "攻擊無效",
			eject = "轟擊",
			felrage = "惡魔之怒",
			
			-- Doomwalker
			overrun = "超越",
			
			-- Essence of Souls(未確定)
			seethe = "激動",

			-- illidan
			summonblade = "埃辛諾斯之刃施放了召喚埃辛諾斯之淚。",
		}
	},
	["misc"] =
	{
		["imp"] = "小鬼", -- UnitCreatureFamily("pet")
		["spellrank"] = "等級 (%d+)", -- second value of GetSpellName(x, "spell")
		["aggrogain"] = "取得 Aggro",
		tankregain = "坦克取回",
	},

	-- labels and tooltips for the main window
	["gui"] = {
		["self"] = {
			["head"] = {
				-- column headers for the self view
				["name"] = "名稱",
				["hits"] = "命中",
				["dam"] = "傷害",
				["threat"] = "仇恨",
				["pc"] = "%T",
			},
			-- text on the self threat reset button
			["reset"] = "重置",
		},
	},
	["print"] =
	{
		["main"] =
		{
			["startupmessage"] = "|cffffff00KLHThreatMeter |cff33ff33%s.%s|r 已載入. 輸入 |cffffff00/ktm|r 取得幫助訊息.",
		},
		["data"] =
		{
			["abilityrank"] = "你的 %s 技能的排名為 %s.",
			["globalthreat"] = "你的整體仇恨倍率為 %s.",
			["globalthreatmod"] = "%s 給予你 %s.",
			["multiplier"] = "作為一個%s, 你的%s仇恨倍率為%s.",
			["damage"] = "傷害",
			["shadowspell"] = "暗影法術",
			["arcanespell"] = "秘法法術",
			["holyspell"] = "神聖法術",
			["setactive"] = "是否正穿著 %s 套裝 %d 件? ... %s.",
			["healing"] = "你的治療產生了 %s 仇恨 (在經過整體仇恨修正之前).",
			["talentpoint"] = "你有 %d 點天賦點數在 %s.",
			["talent"] = "發現 %d 點 %s 天賦.",
			["rockbiter"] = "你的等級 %d 石化增加了 %d 點仇恨成功的進行了肉搏戰.",
		},

		-- new in R17.7
		["boss"] = 
		{
			["automt"] = "主要目標已經自動被設定為 %s.",
			["spellsetmob"] = "%$1s 變更了 %$3s 的 %$4s 技能 %$2s 參數設定值, 從 %$6s 變更為 %$5s.", -- "Kenco sets the multiplier parameter of Onyxia's Knock Away ability to 0.7"
			["spellsetall"] = "%$1s 變更了 %$3s 技能的 %$2s 參數設定值, 從 %$5s 變更為 %$4s.",
			["reportmiss"] = "%s 回報 %s 的 %s 未擊中他.",
			["reporttick"] = "%s 回報 %s 的 %s 擊中了他. 他已經受傷害 %s 回, 並且將會受 %s 影響更多的時間.",
			["reportproc"] = "%s 回報 %s 的 %s 改變了他的仇恨值, 從 %s 到 %s.",
			["bosstargetchange"] = "%s 改變了目標, 從 %s (%s 仇恨) 到 %s (%s 仇恨).",
			["autotargetstart"] = "當你下一次選取了一個世界首領, 你將會自動清除主要目標並將他設定為新的主要目標.",
			["autotargetabort"] = "主要目標已經被設定為世界首領 %s.",
		},

		["network"] =
		{
			["newmttargetnil"] = "無法確認主要目標 %s, 因為 %s 沒有目標.",
			["newmttargetmismatch"] = "%s 設定主要目標為 %s, 但是他的目標是 %s. 將使用他的目標替代, 並確認這一點!!",
			["mtpollwarning"] = "已經更新你的主要目標為 %s, 但是無法確認. 如果這個是不正確的, 請 %s 重新廣播一次主要目標.",
			["threatreset"] = "團隊仇恨測量器已被 %s 清除.",
			["newmt"] = "主要目標已更改為 '%s', 由 %s 變更.",
			["mtclear"] = "主要目標已被 %s 清除.",
			["knockbackstart"] = "擊飛偵測在已被 %s 啟用.",
			["knockbackstop"] = "擊飛偵測在已被 %s 停用.",
			["aggrogain"] = "%s 回報, 在產生了 %d 仇恨後取得 aggro.",
			["aggroloss"] = "%s 回報, %d 仇恨失去了 aggro.",
			["knockback"] = "%s 回報受到傷害被擊飛. 他的仇恨值下降到 %d.",
			["knockbackstring"] = "%s 回報這個踢飛的文字: '%s'.",
			["upgraderequest"] = "%s 促使你更新 KLHThreatMeter 到版本 Release %d. 你現在正使用 Release %d.",
			["remoteoldversion"] = "%s 正在使用過期的 KLHThreatMeter Release %d. 請告訴他該更新到 Release %d 了.",
			["knockbackvaluechange"] = "|cffffff00%s|r 設定 %s 的 |cffffff00%s|r 攻擊仇恨減少至 |cffffff00%d%%|r.",
			["raidpermission"] = "你必須是領隊或是隊長才能夠這樣作!",
			["needmastertarget"] = "你必須先設定一個主要目標!",
			["knockbackinactive"] = "擊飛偵測在本團隊中被關閉.",
			["versionrequest"] = "正在向團隊查詢版本資訊, 將在 3 秒內回應.",
			["versionrecent"] = "這些人使用 release %s: { ",
			["versionold"] = "這些人使用舊的版本: { ",
			["versionnone"] = "這些人沒有使用 KLHThreatMeter, 或是他們沒有在正確的 CTRA 頻道: { ",
			needtarget = "請先標記一個怪物並設定成為主要目標.",
			upgradenote = "使用這個插件較舊版本的用戶端已經被通知需要升級.",
		},
	}
}
