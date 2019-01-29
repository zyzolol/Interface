-- Simp.Chinese localization by Diablohu
-- http://www.dreamgen.cn
-- last update: 8/1/2007


thismod.string.data["zhCN"] =
{
	copybox = "|cffffff00Ctrl + C|r 复制以下文字至剪切板。",
	
	errorbox = 
	{
		header = "%s 错误", -- %s == mod.global.name
		body = "%s发生错误。请查阅帮助菜单下的错误记录以获得详细的错误报告。\n\n",
		first = "该错误再次发生时将不会弹出提示。",
		second = "所有错误讲不再弹出提示。",
	},
	
	console = 
	{
		nocommand = "|cffff8888|cffffff00%s|r命令无效。",
		ambiguous = "你打算输入的命令是？",
		run = "|cff8888ff运行命令 %s|r。",
		
		help = 
		{
			test = 
			{
				["#help"] = "测试该插件是否对对装备、天赋以及其他相关信息产生正确的回应。",
				gear = "显示你所装备的影响威胁值的套装部件。",
				talents = "显示你的天赋中影响威胁值的内容。",
				threat = "显示威胁值参数变化。",
				time = "显示信息处理时间信息。",
				memory = "显示插件内存占用信息。",
				states = "检测插件存档文件的正确性。",
				locale = "检测当前语言版本中确实的翻译文本。",
			},
			
			version = 
			{
				["#help"] = "版本控制命令。需要团队领袖或助理权限。",
				query = "向团队内所有人请求插件版本。",
				notify = "通知使用旧版本插件的队员进行更新。",
			},
			
			gui = 
			{
				["#help"] = "团队威胁列表基础命令。",
				show = "显示团队威胁列表。",
				hide = "隐藏团队威胁列表。",
				reset = "重置团队威胁列表的位置至屏幕中心。"
			},
			
			boss = 
			{
				["#help"] = "决定与设定首领技能。",
				report = "当某队员的威胁值因为首领技能而改变时使用隐藏通报。",
				endreport = "停止通报因首领技能而改变威胁值。",
				setspell = "更改已有首领技能的属性。",
			},
			
			disable = "紧急停止：禁用事件 / onupdate。",
			enable = "在紧急停止后重新载入插件",
			mastertarget = "设定或清除主要目标。",
			resetraid = "重置所有队员的威胁值。",
			help = "显示帮助菜单",
			
		},
	},
	
	["raidtable"] = 
	{
		tooltip = 
		{
			close = "关闭",
			closetext = "隐藏该窗口",
			options = "设置",
			optionstext = "对该窗口的外观以及颜色进行修改。",
			minimise = "最小化",
			minimisetext = "最小化该窗口，仅显示顶层信息。再次点击即可复原。",
			setmt = "设置主要目标",
			setmttext = "将当前目标设置为主要目标，如果你没有选择目标则会清除主要目标。",
		},
		
		column = 
		{
			name = "姓名",
			threat = "威胁值",
			percent = "%", -- percentage of maximum, but has to be short!
			persecond = "TPS", -- threat per second. again, must be short.
		},
	},
	["menu"] = 
	{
		top = 
		{
			description = "首页",
			text = "欢迎来到 |cffffff00%s |cff00ff00%s.%s|r 设置菜单。\n\n这是该设置菜单的主页。当前的设置内容标题将会在上方的方框内显示。与该设置相关的内容会在在左侧列出。\n\n左上方方框内显示的是当前设置的上层设置。点击该方框即可返回上一页。\n\n下放方框内显示的是当前设置内容。点击即可获得帮助信息。\n\n想要关闭该窗口只需要点击右上方的“X”按钮。",
		},
		
		raidtable = 
		{
			description = "团队威胁列表",
			text = "团队威胁列表的外观可以在这里进行设置。\n\n|cffffff00颜色主题|r设置允许你改变文字以及边框颜色。\n\n|cffffff00外观|r设置允许你改变团队威胁列表的大小以及排列方向。\n\n|cffffff00内容|r设置允许你改变团队威胁列表所显示的内容以及职业过滤。",
			button = "显示团队威胁列表",
			
			colour = 
			{
				description = "颜色主题",
				
				text1 = "设置团队威胁列表的边框颜色",
				button1 = "设置边框颜色",
				text2 = "设置主文本颜色（标题颜色等）",
				button2 = "设置主文本颜色",
				text3 = "设置次文本颜色（数据颜色等）",
				button3 = "设置次文本颜色",
				text4 = "设置列表的不透明度。100%为不透明，0%为完全透明。",
				slider = "不透明度",
			},
			
			layout = 
			{
				description = "外观",
				
				text1 = "此处你可是改变团队威胁列表的排列方向。列表总是被固定在一个边角，列表中的内容则会向边角的反方向排列。如你将固定边角设置为左上，列表中的内容则会向右下方扩展排列。点击下方的按钮即可改变固定边角。",
				button1 = "左上",
				button2 = "右上",
				button3 = "左下",
				button4 = "右下",
				
				text2 = "设置团队威胁列表所能显示的最大行数。",
				slider = "行数",
				
				text3 = "该设置开启后，如果仅有少量数据列表则会自动进行缩进。",
				checkbox = "整合显示",
				
				text4 = "设置团队威胁列表的大小。",
				slider2 = "缩放",
			},
			
			filter = 
			{
				description = "内容",
				text1 = "选中的职业会在团队威胁列表中显示。",
				text2 = "选中的内容会在团队威胁列表中显示。",
				
				threat = "威胁值",
				percent = "威胁百分比(%s)",
				persecond = "每秒威胁值(%s)",
				
				text3 = "|cffffff00%s|r条会计算出距离成为第一目标所需要的威胁值。\n如果伤害承受者受到了临时性的减少威胁值的效果，比如恐惧，在效果结束时其他人的威胁没有超过|cffffff00%s|r条的话，那么他会立即成为第一目标。",
			
				aggrogain = "显示|cffffff00%s|r条",
				tankregain = "显示|cffffff00%s|r条",
			},
			
			misc = 
			{
				description = "其它",
				text1 = "设置团队威胁列表的自动显示或隐藏方式。",
				leavegroup = "离开队伍时隐藏列表",
				joinparty = "加入小队时显示列表",
				joinraid = "加入团队时显示列表",
				
				text2 = "你可以通过下面的选项将列表固定住。",
				lockwindow = "锁定列表位置",
			}
		},
		
		mythreat = 
		{
			description = "我的威胁值数据",
			reset = "重置",
			update = "更新",
		},
		
		errorlog = 
		{
			description = "错误记录",
			
			text1 = "在这里列出了所有的该插件运行错误。在出现错误时插件可以继续运行，但是某些功能则会停止工作，所以此时你的威胁值计算将可能出现偏差。\n\n我们需要这些错误信息，请发送到|cffffff00%s|r。",
			
			text2 = "显示错误%d/%d.",
			
			button1 = "复制该网址",
			button2 = "上一个",
			button3 = "下一个",
			button4 = "复制错误详细信息",
			
			format = 
			{
				module = "|cffffff00Module =|r %s",
				process = "|cffffff00Process =|r %s",
				extradata = "|cffffff00Extra Data =|r %s",
				message = "|cffffff00Error Message =|r %s",
			},
		},
		
		bossmod = 
		{
			description = "首领模组",
			text = "此处可以设置插件的首领模组信息。\n\n|cffffff00内置模组|r中列出了插件附带的模组。\n\n|cffffff00自定模组|r列出了玩家自定的模组。你可以设定、导出或广播这些模组。",
			
			builtin = 
			{
				description = "内置模组",
				text1 = "点击一个模组以获知详情。",
			},
			
			usermade = 
			{
				description = "自定模组",
				text1 = "点击一个模组以获知详情。点击|cffffff00广播|r按钮可以将该模组发送到团队，|cffffff00导出|r按钮则会输出一个字符串以便其他用户可以用|cffffff00导入|r按钮将其导入。\n点击|cffffff00新建|r按钮可以新建一个新的模组，|cffffff00删除|r按钮可以删除当前选定的模组，|cffffff00编辑|r按钮则可对其进行编辑。", 
				
				button = 
				{
					import = "导入",
					export = "导出",
					broadcast = "广播",
				}
			}
		}
		
	},
	
	generic = 
	{
		finish = "完成",
		cancel = "取消",
		close = "关闭",
		delete = "删除",
		edit = "编辑",
		new = "新建",
		next = "下一个",
		back = "返回",
	},
	
	wizard = 
	{
		editboss = 
		{
			header = "Change the |cffffff00%s|r boss mod.",
			description = "Select a name for the Boss Mod and enter it below. If it contains spell events, make sure it matches the boss' actual name exactly. A list of suggested names is shown on the right. Click an item in the list to use that name.\nClick |cffffff00Finish|r to complete the boss mod, or |cffffff00Cancel|r to prevent all changes. |cffffff00Next|r takes you to the Speech section.",
		},
		customhandler = 
		{
			heading = "Create a custom handler for |cffffff00%s.",
			description = "? Don't wrap the code in  |cffffff00function ... end|r\n? You will be given access the these variables:\n1) |cffffff00mod|r - pointer to %s table\n2) |cffffff00data|r - persistent data store for the function (empty table)\n? Some useful code:\n1) |cffffff00value = mod.table.getraidthreat()|r - your current threat\n2) |cffffff00something about the raid reset here|r - lol",
			error = "The function does not compile. The error is\n|cffffff00%s.",
		}
	},
	
	class = 
	{
		warrior = "战士",
		priest = "牧师",
		druid = "德鲁伊",
		rogue = "盗贼",
		shaman = "萨满祭司",
		mage = "法师",
		paladin = "圣骑士",
		warlock = "术士",
		hunter = "猎人",
	},
	
	["binding"] = 
	{
		hideshow = "隐藏/显示窗口",
		stop = "紧急停止",
		mastertarget = "设置/清除团队目标",
		resetraid = "重置团队威胁排名",
	},
	["spell"] = 
	{
		-- 19
		vampirictouch = "吸血鬼之触",
		bindingheal = "联结治疗",
		leaderofthepack = "兽群领袖",
		faeriefire = "精灵之火（野性）",
		shadowguard = "暗影守卫",
		anesthetic = "麻醉毒药",
		bearmangle = "裂伤（熊）",
		thunderclap = "雷霆一击",
		soulshatter = "灵魂碎裂",
		invisibility = "隐形术",
		misdirection = "误导",
		disengage = "逃脱",
		anguish = "痛楚", -- Felguard
		lacerate = "割伤", 
		
		-- 18.x
		torment = "折磨",
		suffering = "受难",
		soothingkiss = "安抚之吻",
		intimidation = "胁迫",
		
		righteousdefense = "正义防御",
		eyeofdiminution = "衰落之眼", -- buff from trinket "Eye of Diminution". The buff appears to be slightly different, with 'The' at the start.
		notthere = "移位", -- the buff from Frostfire 8/8 Proc
		frostshock = "冰霜震击", 
		reflectiveshield = "反射护盾", -- this is the damage from Power Word:Shield with the talent.
		devastate = "毁灭打击",
		stormstrike = "风暴打击",
		
		-- warlock affliction spells (others already existed below)
		corruption = "腐蚀术",				
		curseofagony = "痛苦诅咒",
		drainsoul = "吸取灵魂",
		curseofdoom = "厄运诅咒",
		unstableaffliction = "痛苦无常",
		
		-- new warlock destruction spells
		shadowfury = "暗影之怒",
		incinerate = "烧尽", 
		
		-- 17.20
		["execute"] = "斩杀",
		
		["heroicstrike"] = "英勇打击",
		["maul"] = "重殴",
		["swipe"] = "横扫",
		["shieldslam"] = "盾牌猛击",
		["revenge"] = "复仇",
		["shieldbash"] = "盾击",
		["sunder"] = "破甲攻击",
		["feint"] = "佯攻",
		["cower"] = "畏缩",
		["taunt"] = "嘲讽",
		["growl"] = "低吼",
		["vanish"] = "消失",
		["frostbolt"] = "寒冰箭",
		["fireball"] = "火球术",
		["arcanemissiles"] = "奥术飞弹",
		["scorch"] = "灼烧",
		["cleave"] = "顺劈斩",
		
		hemorrhage = "出血",
		backstab = "背刺",
		sinisterstrike = "邪恶攻击",
		eviscerate = "剔骨",
		
		-- Items / Buffs:
		["arcaneshroud"] = "奥术环绕",
		["blackamnesty"] = "Reduce Threat",

		-- Leeches: no threat from heal
		["holynova"] = "神圣新星", -- no heal or damage threat
		["siphonlife"] = "生命虹吸", -- no heal threat
		["drainlife"] = "吸取生命", -- no heal threat
		["deathcoil"] = "死亡缠绕",	
		
		-- Fel Stamina and Fel Energy DO cause threat! GRRRRRRR!!!
		--["felstamina"] = "恶魔耐力",
		--["felenergy"] = "恶魔能量",
		
		["bloodsiphon"] = "血液虹吸", -- poisoned blood vs Hakkar
		
		["lifetap"] = "生命分流", -- no mana gain threat
		["holyshield"] = "神圣之盾", -- multiplier
		["tranquility"] = "宁静",
		["distractingshot"] = "扰乱射击",
		["earthshock"] = "地震术",
		["rockbiter"] = "石化",
		["fade"] = "渐隐术",
		["thunderfury"] = "雷霆之怒",
		
		-- Spell Sets
		-- warlock descruction
		["shadowbolt"] = "暗影箭",
		["immolate"] = "献祭",
		["conflagrate"] = "燃烧",
		["searingpain"] = "灼热之痛", -- 2 threat per damage
		["rainoffire"] = "火焰之雨",
		["soulfire"] = "灵魂之火",
		["shadowburn"] = "暗影灼烧",
		["hellfire"] = "地狱烈焰效果",
		
		-- mage offensive arcane
		["arcaneexplosion"] = "魔爆术",
		["counterspell"] = "法术反制",
		
		-- priest shadow. No longer used (R17).
		["mindblast"] = "心灵震爆",	-- 2 threat per damage
		--[[
		["mindflay"] = "精神鞭笞",
		["devouringplague"] = "噬灵瘟疫",
		["shadowwordpain"] = "暗言术：痛",
		,
		["manaburn"] = "法力燃烧",
		]]
	},
	["power"] = 
	{
		["mana"] = "法力值",
		["rage"] = "怒气",
		["energy"] = "能量",
	},
	["threatsource"] = -- these values are for user printout only
	{
		["powergain"] = "能量获得",
		["total"] = "总计",
		["special"] = "技能伤害",
		["healing"] = "治疗",
		["dot"] = "持续伤害",
		["threatwipe"] = "NPC 法术",
		["damageshield"] = "伤害吸收",
		["whitedamage"] = "普通伤害",
	},
	["talent"] = -- these values are for user printout only
	{
		["defiance"] = "挑衅",
		["impale"] = "穿刺",
		["silentresolve"] = "无声消退",
		["frostchanneling"] = "冰霜导能",
		["burningsoul"] = "燃烧之魂",
		["healinggrace"] = "治疗之赐",
		["shadowaffinity"] = "暗影亲和",
		["druidsubtlety"] = "微妙",
		["feralinstinct"] = "野性本能",
		["ferocity"] = "凶暴",
		["savagefury"] = "野蛮暴怒",
		["tranquility"] = "强化宁静",
		["masterdemonologist"] = "恶魔学识大师",
		["arcanesubtlety"] = "奥术精妙",
		["righteousfury"] = "正义之怒",
		["sleightofhand"] = "狡诈",
		voidwalker = "强化虚空行者",
	},
	["threatmod"] = -- these values are for user printout only
	{
		["tranquilair"] = "宁静之风图腾",
		["salvation"] = "拯救祝福",
		["battlestance"] = "战斗姿态",
		["defensivestance"] = "防御姿态",
		["berserkerstance"] = "狂暴姿态",
		["defiance"] = "挑衅",
		["basevalue"] = "基础值",
		["bearform"] = "熊形态",
		["catform"] = "猎豹形态",
		["glovethreatenchant"] = "附魔手套 - 威胁",
		["backthreatenchant"] = "附魔披风 - 狡诈",
	},
	
	["sets"] = 
	{
		["bloodfang"] = "血牙",
		["nemesis"] = "复仇",
		["netherwind"] = "灵风",
		["might"] = "力量",
		["arcanist"] = "奥术师",
		bonescythe = "骨镰",
		plagueheart = "瘟疫之心",
	},
	["boss"] = 
	{
		["speech"] = 
		{
			onyxiapull = "I must leave my lair",
			onyxiaphase2 = "这毫无意义的行动让我很厌烦。我会从上空把你们都烧成灰！",
			["onyxiaphase3"] = "看起来需要再给你一次教训，凡人！",
			
			["razorgorepull"] = "在宝珠的控制力消失的瞬间，奈法利安的部队逃走了。",
			["thekalphase2"] = "fill me with your RAGE",
			["azuregosport"] = "来吧，小家伙们。面对我！",
			["nefarianpull"] = "燃烧吧！你们这些悲惨的家伙！燃烧吧！",
			
			nightbaneland1 = "Enough! I shall land and crush you myself!",
			nightbaneland2 = "Insects! Let me show you my strength up close!",
			nightbanepull = "What fools! I shall bring a quick end to your suffering!",
			
			attumenmount = "来吧，午夜，让我们解决这群乌合之众！",
			magtheridonpull = "我……自由了！",
			ragnarospull = "YOU HAVE AWAKENED ME TOO SOON",
			
			hydrosspull = "我不能允许你们介入！",
			hydrossswap1 = "啊……毒性侵袭了我……",
			hydrossswap2 = "感觉好多了。",
			
			leotherasswap = "滚开吧，脆弱的精灵。现在我说了算！", -- this isn't the full line
			leotheraspull = "我的放逐终于结束了！",
			
			nothpull1 = "荣耀归于我主！",
			nothpull2 = "我要没收你的生命！",
			nothpull3 = "死吧，入侵者！",
						
			rajaxxpull = "无礼的蠢货！我会亲自要了你们的命！",
			rajaxxignore = "You are not worth my time,? (%s)!",
			
			kaelthasphase1a = "你们击败了我最强大的顾问……但是没有人能战胜鲜血之锤。",
			kaelthasphase1b = "卡波妮娅很快会解决你们的。",
			kaelthasphase1c = "干得不错。看来你们有能力挑战我的首席技师，塔隆尼库斯。",
			kaelthasphase2 = "你们看，我的个人收藏中有许多武器……",
			kaelthasphase3 = "也许我确实低估了你们。",
			kaelthasphase4 = "我的心血是不会被你们轻易浪费的！",
			kaelthasphase4b = "唉，有些时候，有些事情，必须得亲自解决才行。",
			
			supremusphase1 = "punches the ground in anger",
			
			morogrimpull = "深渊中的洪水会淹没你们！",
			
			vashjpull1 = "我唾弃你们，地表的渣滓！",
			vashjpull2 = "伊利丹大人必胜！",
			vashjpull3 = "入侵者都要受死！伊利丹大人必胜！",
			vashjpull4 = "我本不想屈尊与你们交战，但是你们让我别无选择……",
			
			solarianpull = "Tal anu'men no sin'dorei!",
			
		},
		-- Some of these are unused. Also, if none is defined in your localisation, they won't be used,
		-- so don't worry if you don't implement it.
		["name"] = 
		{
			["rajaxx"] = "拉贾克斯将军",
			["onyxia"] = "奥妮克希亚",
			["ebonroc"] = "埃博诺克",
			firemaw = "费尔默",
			flamegor = "弗莱格尔",
			
			["razorgore"] = "狂野的拉佐格尔",
			["thekal"] = "高阶祭司塞卡尔",
			["shazzrah"] = "沙斯拉尔",
			["twinempcaster"] = "维克洛尔大帝",
			["twinempmelee"] = "维克尼拉斯大帝",
			["noth"] = "瘟疫使者诺斯",
			["leotheras"] = "盲眼者莱欧瑟拉斯",
			ouro = "奥罗",
			voidreaver = "空灵机甲",
			bloodboil = "古尔图格·血沸",
			doomwalker = "末日行者",
			ragnaros = "拉格纳罗斯",
			patchwerk = "帕奇维克",
		},
		["spell"] = 
		{
			["shazzrahgate"] = "沙斯拉尔之门", -- "Shazzrah casts Gate of Shazzrah."
			["wrathofragnaros"] = "拉格纳罗斯之怒", -- "Ragnaros's Wrath of Ragnaros hits you for 100 Fire damage."
			["timelapse"] = "时间流逝", -- "You are afflicted by Time Lapse."
			["knockaway"] = "击退",
			["wingbuffet"] = "龙翼打击",
			["burningadrenaline"] = "燃烧刺激",
			["twinteleport"] = "双子传送",
			["nothblink"] = "闪现术",
			["sandblast"] = "沙尘爆裂",
			["fungalbloom"] = "蘑菇花",
			["hatefulstrike"] = "仇恨打击",
			
			-- 4 horsemen marks
			mark1 = "布劳缪克丝印记",
			mark2 = "库尔塔兹印记",
			mark3 = "莫格莱尼印记",
			mark4 = "瑟里耶克印记",
			
			-- Onyxia fireball (presumably same as mage)
			fireball = "火球术",
			
			-- Leotheras, Maulgar, Sartura etc
			whirlwind = "旋风斩",
            
			-- Gurtogg Bloodboil
			insignifigance = "毫无意义",
			eject = "驱逐", -- or 弹射?
			felrage = "Fel Rage",
			
			-- Doomwalker
			overrun = "泛滥",
		}
	},
	["misc"] = 
	{
		["imp"] = "小鬼", -- UnitCreatureFamily("pet")
		["spellrank"] = "等级 (%d+)", -- second value of GetSpellName(x, "spell")
		["aggrogain"] = "目标仇恨",
		tankregain = "重获仇恨",
	},

	-- labels and tooltips for the main window
	["gui"] ={ 
		["self"] = {
			["head"] = {
				-- column headers for the self view
				["name"] = "类型",
				["hits"] = "击中",
				["dam"] = "伤害",
				["threat"] = "威胁",
				["pc"] = "威胁%",			-- Abbreviation of %Threat
			},
			-- text on the self threat reset button
			["reset"] = "重置",
		},
	},
	["print"] = 
	{
		["main"] = 
		{
			["startupmessage"] = "|cffffff00KLHThreatMeter |cff33ff33%s.%s|r 已加载。输入 |cffffff00/ktm|r 以获得帮助信息。",
		},
		["data"] = 
		{
			["abilityrank"] = "你的%s技能为等级%s。",
			["globalthreat"] = "你的全局威胁系数为%s。",
			["globalthreatmod"] = "%s为%s。",
			["multiplier"] = "作为%s，你的%s的威胁值将会乘以系数%s。",
			["damage"] = "伤害",
			["shadowspell"] = "暗影法术",
			["arcanespell"] = "奥术法术",
			["holyspell"] = "神圣法术",
			["setactive"] = "%s%d件效果激活？... %s.",
			["healing"] = "你的治疗造成了%s点威胁（不考虑全局威胁系数）。",
			["talentpoint"] = "你有%d点天赋点赋予了%s。",
			["talent"] = "检测到%d %s天赋。",
			["rockbiter"] = "你的%d级石化武器使每一次近战物理攻击增加了%d点威胁。",
		},
		
		-- new in R17.7
		["boss"] = 
		{
			["automt"] = "|cffffff00%s|r已被自动设定为当前的主要目标。",
			["spellsetmob"] = "|cffffff00%s|r sets the |cffffff00%s|r parameter of |cffffff00%s|r's |cffffff00%s|r ability to |cffffff00%s|r from |cffffff00%s|r.", -- "Kenco sets the multiplier parameter of Onyxia's Knock Away ability to 0.7"
			["spellsetall"] = "|cffffff00%s|r sets the |cffffff00%s|r parameter of the |cffffff00%s|r ability to |cffffff00%s|r from |cffffff00%s|r.",
			["reportmiss"] = "%s报告说%s的%s没有击中他。",
			["reporttick"] = "%s报告说%s的%s击中了他。He has suffered %s ticks, and will be affected in %s more ticks.",
			["reportproc"] = "|cffffff00%s|r reports that |cffffff00%s|r's |cffffff00%s|r changed his threat from |cffffff00%s|r to |cffffff00%s|r.",
			["bosstargetchange"] = "|cffffff00%s|r changed tagets from |cffffff00%s|r (on |cffffff00%s|r threat) to |cffffff00%s|r (on |cffffff00%s|r threat).",
			["autotargetstart"] = "You will automatically clear the meter and set the master target when you next target a world boss.",
			["autotargetabort"] = "The master target has already been set to the world boss %s.",
		},
		
		["network"] = 
		{
			["newmttargetnil"] = "Could not confirm the master target |cffffff00%s|r, because |cffffff00%s|r has no target.",
			["newmttargetmismatch"] = "|cffffff00%s|r sets the master target to |cffffff00%s|r, but his own target is |cffffff00%s|r. Using his own target instead, check this!",
			["mtpollwarning"] = "Updated your master target to |cffffff00%s|r, but could not confirm this. Ask |cffffff00%s|r to rebroadcast the master target if this does not sound correct.",
			["threatreset"] = "团队威胁排名已被|cffffff00%s|r重置。",
			["newmt"] = "|cffffff00%s|r已被|cffffff00%s|r设定为当前的主要目标。",
			["mtclear"] = "主要目标已被|cffffff00%s|r清除。",
			["knockbackstart"] = "NPC Spell reporting has been activated by |cffffff00%s|r.",
			["knockbackstop"] = "NPC Spell reporting has been stopped by |cffffff00%s|r.",
			["aggrogain"] = "|cffffff00%s|r reports gaining aggro with %d threat.",
			["aggroloss"] = "|cffffff00%s|r reports losing aggro with %d threat.",
			["knockback"] = "|cffffff00%s|r reports suffering a knock away. He's down to %d threat.",
			["knockbackstring"] = "%s reports this knockback text: '%s'.",
			["upgraderequest"] = "%s urges you to upgrade to Release %s of KLHThreatMeter. You are currently using Release %s.",
			["remoteoldversion"] = "%s is using the outdated Release %s of KLHThreatMeter. Please tell him to upgrade to Release %s.",
			["knockbackvaluechange"] = "|cffffff00%s|r has set the threat reduction of %s's |cffffff00%s|r attack to |cffffff00%d%%|r.",
			["raidpermission"] = "进行该才作需要团队领袖或助理权限。",
			["needmastertarget"] = "需要设定主要目标。",
			["knockbackinactive"] = "Knockback discovery is not active in the raid.",
			["versionrequest"] = "正在查询团队成员的插件版本情况，这个过程需要3秒钟。",
			["versionrecent"] = "以下成员正在使用%s: { ",
			["versionold"] = "以下成员正在使用旧版本: { ",
			["versionnone"] = "以下成员没有 KLHThreatMeter: { ",
			needtarget = "Target the mob to select as the master target first.",
			upgradenote = "Older versions of the mod have been notified to upgrade.",
		},
	}
}	
