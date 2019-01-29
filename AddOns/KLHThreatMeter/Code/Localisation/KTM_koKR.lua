
thismod.string.data["koKR"] =
{
	copybox = "|cffffff00Ctrl + C|r를 눌러 클립보드에 텍스트를 복사하세요.",
	
	errorbox = 
	{
		header = "%s 오류", -- %s == mod.global.name
		body = "%s에 오류가 발생되었습니다. 세부 보고의 도움말 메뉴에 오류 기록 항목에서 확인하세요.\n\n",
		first = "앞으로 이 오류 발생은 감지하지 않을 것입니다.",
		second = "앞으로 발생하는 모든 오류는 감지하지 않을 것입니다.",
	},
	
	console = 
	{
		nocommand = "%s|cffff8888 명령어가 없습니다|cffffff00|r.",
		ambiguous = "다음의 명령어 중 어떤 것을 원하셨습니까?",
		run = "|cff8888ff%s 명령어를 실행합니다|r.",
		
		help = 
		{
			test = 
			{
				["#help"] = "애드온 테스트는 장비, 특성과 그밖의 수치의 정확성을 알아봅니다.",
				gear = "당신이 입고있는 셋트 아이템에서 위협 수준에 영향을 미치는 셋트 옵션을 출력합니다.",
				talents = "당신의 특성중 위협 수준에 영향을 미치는 특성 포인트를 출력합니다.",
				threat = "위협수준 파라미터의 여러가지를 출력합니다.",
				time = "처리 시간 정보를 출력합니다.",
				memory = "메모리 사용량 정보를 출력합니다.",
				states = "애드온이 주어진 변수에 대해 알맞는 수치를 가지고 있는지 검사합니다.",
				locale = "현지 언어에 맞게 번역이 되지 않은 부분을 검사합니다.",
			},
			
			version = 
			{
				["#help"] = "버전 제어 명령. 부공격대장 권한을 필요로 합니다.",
				query = "공격대의 모든 사람에게 버전 정보를 묻습니다.",
				notify = "구버전 사용자에게 업그레이드 할 것을 알립니다.",
			},
			
			gui = 
			{
				["#help"] = "공격대 창에 대한 기본 명령어.",
				show = "공격대 창을 표시합니다.",
				hide = "공격대 창을 숨깁니다.",
				reset = "화면 가운데로 공격대 창을 초기화 합니다."
			},
			
			boss = 
			{
				["#help"] = "최종 결정 및 보스 기술 관련 기능.",
				report = "보스 기술로 인해 위협 수준이 변경될 때 조용히 플레이어 보고서를 작성합니다.",
				endreport = "보스 기술로 인해 위협 수준이 변경될 때 플레이어 보고서 작성을 중단합니다.",
				setspell = "알려진 보스 기술의 파라미터를 변경합니다.",
			},
			
			disable = "긴급 중단: events / onupdate 사용 중지.",
			enable = "긴급 중단 이후 애드온 재시작.",
			mastertarget = "주 대상 설정 또는 초기화.",
			resetraid = "공격대의 모든 사람의 위협 수준 초기화.",
			help = "도움말 메뉴 표시.",
			
		},
	},

	["raidtable"] = 
	{
		tooltip = 
		{
			close = "닫기",
			closetext = "이 창을 숨깁니다.",
			options = "옵션",
			optionstext = "이 창의 레이아웃과 색상을 설정함.",
			minimise = "최소화",
			minimisetext = "최상위 항목 부분만 남기고 테이블을 최소화 합니다. 다시 클릭하면 테이블이 나타납니다.",
			setmt = "주 대상 설정",
			setmttext = "당신의 현재 대상을 주 대상으로 설정하거나, 선택한 대상이 있다면 주 대상을 초기화 합니다.",
		},
		
		column = 
		{
			name = "이름",
			threat = "위협수치",
			percent = "%최대", -- percentage of maximum, but has to be short!
			persecond = "TPS", -- threat per second. again, must be short.
		},
	},
	["menu"] = 
	{
		top = 
		{
			description = "기본 메뉴",
			text = "|cffffff00%s |cff00ff00%s.%s|r 메뉴에 오신걸 환영합니다.\n\n이것은 기본 항목입니다. 현재 항목의 이름은 상자 위에 표시됩니다. 왼쪽에 있는 바는 선택한 항목과 관련있는 주제를 표시합니다.\n\n왼쪽 위의 상자는 현재 항목의 상위 메뉴입니다. 그걸 클릭하면 이전 항목으로 돌아갑니다.\n\n그 아래 상자들은 현재 항목의 하위 주제입니다. 특정 하위 주제를 보려면 이것들을 클릭하십시오.\n\n도움 메뉴를 숨기려면, 현재 항목 상자의 오른쪽 위에 있는 X 버튼을 클릭하십시오.",
		},
		
		raidtable = 
		{
			description = "공격대 테이블",
			text = "이 항목은 공격대 테이블의 표시를 설정합니다.\n\n|cffffff00색상표|r 항목에서 글자와 프레임의 색상을 변경합니다.\n\n|cffffff00레이아웃|r 항목에서는 테이블의 크기와 방향을 설정합니다.\n\n|cffffff00행열|r 항목은 테이블에서 표시열 및 직업 필터 조정을 변경합니다.",
			button = "공격대 테이블 보기",
			
			colour = 
			{
				description = "색상표",
				
				text1 = "공격대 테이불의 외곽선 색을 변경하려면 이곳을 클릭하세요:",
				button1 = "외곽선 색 설정",
				text2 = "큰 글자색을 변경하려면 이곳을 클릭하세요 (예. 머릿글):",
				button2 = "큰 글자색 설정",
				text3 = "작은 글자색을 변경하려면 이곳을 클릭하세요 (예. 일반글):",
				button3 = "작은 글자색 설정",
				text4 = "투명도(알파 값)를 설정합니다. 100%는 완전히 표시이며, 0%는 투명입니다.",
				slider = "알파 값",
			},
			
			layout = 
			{
				description = "레이아웃",
				
				text1 = "이곳에서 어떻게 테이블을 채울지 지정할 수 있습니다. 프레임의 한쪽 구석은 늘 고정되어 있으며, 테이블은 반대방향으로 채워질 것입니다. 그래서 상단 왼쪽이 고정 지점이라면, 테이블은 아래쪽과 오른쪽으로 필요한 만큼 확장됩니다. 버튼을 클릭해서 고정 지점을 변경할 수 있습니다.",
				button1 = "상단 왼쪽",
				button2 = "상단 오른쪽",
				button3 = "하단 왼쪽",
				button4 = "하단 오른쪽",
				
				text2 = "공격대 테이블의 행수의 최대값을 설정함.",
				slider = "행",
				
				text3 = "이 옵션이 켜질 경우, 내용이 적으면 테이블의 길이가 줄어듭니다. 반대의 경우에는 테이블은 일정한 크기를 가지게 됩니다.",
				checkbox = "간이 테이블",
				
				text4 = "공격대 테이블의 모든 요소의 크기를 변경합니다.",
				slider2 = "스케일",
			},
			
			filter = 
			{
				description = "행열",
				text1 = "공격대 테이블에서 보기를 원하는 직업을 선택합니다.",
				text2 = "공격대 테이블에서 보기를 원하는 열을 선택합니다.",
				
				threat = "위협수치열을 나타냅니다.",
				percent = "(%s)백분율열을 나타냅니다.",
				persecond = "(%s)초당 위협수치(TPS)를 나타냅니다.",
				
				text3 = "|cffffff00%s|r 바는 당신이 어그로를 먹기 위해 얼마만큼의 위협 수준이 필요한 지를 예측합니다. 탱커가 공포 등과 같은 일시적인 위협 수준 초기화에 걸릴 경우, 그 상황이 종료될 때 데미지 딜러가 |cffffff00%s|r 바의 수치보다 아래에 있다면 다시 어그로를 획득할 것입니다.",
			
				aggrogain = "|cffffff00%s|r 바를 표시합니다.",
				tankregain = "|cffffff00%s|r 바를 표시합니다. ",
			},

			misc = 
			{
				description = "기타",
				text1 = "당신이 그룹에 들어오거나 나갈 때 자동으로 창이 표시되거나 숨겨지는 것을 설정합니다.",
				leavegroup = "내가 그룹에 나갈 때 창을 숨깁니다.",
				joinparty = "내가 파티에 들어갈 때 창을 표시합니다.",
				joinraid = "내가 공격대에 들어갈 때 창을 표시합니다.",
				
				text2 = "올바른 위치에 있다면 창이 드래그 되는것을 방지할 수 있습니다.",
				lockwindow = "이 위치에서 창을 고정합니다.",
			}
		},
		
		mythreat = 
		{
			description = "내 위협수준 상태",
			reset = "초기화",
			update = "갱신",
		},
		
		errorlog = 
		{
			description = "오류 기록",
			
			text1 = "이 항목은 애드온의 모듈에 발생한 치명적이지 않은 모든 오류를 나열합니다. 애드온은 계속 작동하지만, 일부 구성 요소는 작동을 멈출 것입니다. 그래서 당신의 위협 수준은 정확하게 나열되지 않을 수 있습니다.\n\n이 오류들은 웹페이지 |cffffff00%s|r에 신고하는 것이 좋습니다.",
			
			text2 = "%d / %d 오류 표시중.",
			
			button1 = "웹페이지 주소 복사",
			button2 = "이전 오류",
			button3 = "다음 오류",
			button4 = "오류 세부사항 복사",
			
			format = 
			{
				module = "|cffffff00모듈 =|r %s",
				process = "|cffffff00프로세스 =|r %s",
				extradata = "|cffffff00그밖의 데이터 =|r %s",
				message = "|cffffff00오류 메세지 =|r %s",
			},
		},
		
		bossmod = 
		{
			description = "보스 모듈",
			text = "이 항목은 애드온의 보스 모듈을 설정합니다.\n\n|cffffff00빌트-인|r 항목엔 애드온에 들어있는 보스 모듈의 목록이 있습니다.\n\n|cffffff00사용자 제작|r 항목엔 유저가 만든 보스 모듈의 목록이 있습니다. 자기만의 보스 모듈을 설계하고 파일로 저장하거나 공격대에 방송할 수도 있습니다.",
			
			builtin = 
			{
				description = "빌트-인",
				text1 = "이곳엔 빌트 인 보스 모듈의 목록이 있습니다. 목록을 클릭해서 세부 사항을 볼 수 있습니다.",
			},
			
			usermade = 
			{
				description = "사용자 제작",
				text1 = "목록을 클릭하여 보스 모듈의 세부 사항을 볼 수 있습니다. |cffffff00방송|r을 클릭하여 공격대에 모듈을 전송할 수 있습니다. |cffffff00내보내기|r는 다른 유저가 |cffffff00가져오기|r 버튼으로 불러올 수 있도록 모듈을 텍스트 문자열로 변환합니다.\n|cffffff00새로 만들기|r를 클릭해서 새 모듈을 만들 수 있습니다. |cffffff00삭제|r로 선택한 모듈을 삭제하거나, 또는 |cffffff00편집|r으로 변경합니다.", 
				
				button = 
				{
					import = "가져오기",
					export = "내보내기",
					broadcast = "방송",
				}
			}
		}
		
	},
	
	generic = 
	{
		finish = "마침",
		cancel = "취소",
		close = "닫기",
		delete = "삭제",
		edit = "편집",
		new = "새로 만들기",
		next = "다음",
		back = "뒤로",
	},
	
	wizard = 
	{
		editboss = 
		{
			header = "|cffffff00%s|r 보스 모듈을 변경합니다.",
			description = "보스 모듈의 이름을 선택 하고 아래로 들어갑니다. 주문 이벤트를 포함하고 있다면, 보스의 실제 이름과 정확히 맞는지 확인합니다. 제안된 이름의 목록은 우측에 표시됩니다. 각 목록을 클릭해서 그 이름들을 사용할 수 있습니다.\n|cffffff00마침|r을 클릭하여 보스 모듈을 완료하거나, |cffffff00취소|r로 모든 변경을 막을 수 있습니다. |cffffff00다음|r은 말하기 항목으로 넘어갑니다.",
		},
		customhandler = 
		{
			heading = "|cffffff00%s|r의 커스텀 핸들러를 제작합니다.",
			description = "• |cffffff00function ... end|r 안의 코드를 늘어뜨리지 마십시오\n• 당신은 다음의 변수들의 접근을 받을 것입니다:\n1) |cffffff00mod|r - %s 테이블용 포인터\n2) |cffffff00data|r - 함수의 데이터 저장 지속 (빈 테이블)\n• 몇몇 유용한 코드:\n1) |cffffff00value = mod.table.getraidthreat()|r - 당신의 현재 위협수준\n2) |cffffff00레이드 리셋에 대한 것들이 여기 있습니다|r - lol",
			error = "함수가 컴파일 되지 않았습니다. 오류는 \n|cffffff00%s 입니다.",
		}
	},
	
	class = 
	{
		warrior = "전사",
		priest = "사제",
		druid = "드루이드",
		rogue = "도적",
		shaman = "주술사",
		mage = "마법사",
		paladin = "성기사",
		warlock = "흑마법사",
		hunter = "사냥꾼",
	},

	["binding"] =
	{
		hideshow = "창 숨기기/보기",
		stop = "긴급 중단",
		mastertarget = "주 대상 설정/해제",
		resetraid = "레이드 위협수준 초기화",
	},
	["spell"] =
	{
		-- 19
		vampirictouch = "흡혈의 손길",
		bindingheal = "결속의 치유",
		leaderofthepack = "무리의 우두머리",
		faeriefire = "요정의 불꽃 (야성)",
		shadowguard = "어둠의 수호",
		anesthetic = "정신 마취 독",
		bearmangle = "짓이기기 (곰)",
		thunderclap = "천둥벼락",
		soulshatter = "영혼 붕괴",
		invisibility = "투명화",
		misdirection = "눈속임",
		disengage = "철수",
		anguish = "고뇌", -- Felguard
		lacerate = "가르기", 
		
		-- 18.x
		torment = "고문",
		suffering = "고통",
		soothingkiss = "유혹의 입맞춤",
		intimidation = "위협",

		righteousdefense = "정의의 방어",
		eyeofdiminution = "감쇠의 눈", -- buff from trinket "Eye of Diminution". The buff appears to be slightly different, with 'The' at the start.
		notthere = "Not There", -- the buff from Frostfire 8/8 Proc
		frostshock = "냉기 충격", 
		reflectiveshield = "반사의 보호막", -- this is the damage from Power Word:Shield with the talent.
		devastate = "압도",
		stormstrike = "폭풍의 일격",
		
		-- warlock affliction spells (others already existed below)
		corruption = "부패",				
		curseofagony = "고통의 저주",
		drainsoul = "영혼 흡수",
		curseofdoom = "파멸의 저주",
		unstableaffliction = "불안정한 고통",
		
		-- new warlock destruction spells
		shadowfury = "어둠의 격노",
		incinerate = "소각", 
		
		-- 17.20
		["execute"] = "마무리 일격",
		
		["heroicstrike"] = "영웅의 일격",
		["maul"] = "후려치기",
		["swipe"] = "휘둘러치기",
		["shieldslam"] = "방패 밀쳐내기",
		["revenge"] = "복수",
		["shieldbash"] = "방패 가격",
		["sunder"] = "방어구 가르기",
		["feint"] = "교란",
		["cower"] = "웅크리기",
		["taunt"] = "도발",
		["growl"] = "포효",
		["vanish"] = "소멸",
		["frostbolt"] = "얼음 화살",
		["fireball"] = "화염구",
		["arcanemissiles"] = "신비한 화살",
		["scorch"] = "불태우기",
		["cleave"] = "회전베기",
		
		hemorrhage = "과다출혈",
		backstab = "기습",
		sinisterstrike = "사악한 일격",
		eviscerate = "절개",

		-- Items / Buffs:
		["arcaneshroud"] = "신비의 장막",
		["blackamnesty"] = "위협 수준 감소",

		-- Leeches: no threat from heal
		["holynova"] = "신성한 폭발", -- no heal or damage threat
		["siphonlife"] = "생명력 착취", -- no heal threat
		["drainlife"] = "생명력 흡수", -- no heal threat
		["deathcoil"] = "죽음의 고리",

		-- no threat for fel stamina. energy unknown.
		--["felstamina"] = "마의 체력",
		--["felenergy"] = "마의 에너지",

		["bloodsiphon"] = "생명력 착취", -- poisoned blood vs Hakkar

		["lifetap"] = "생명력 전환", -- no mana gain threat
		["holyshield"] = "신성한 방패", -- multiplier
		["tranquility"] = "평온",
		["distractingshot"] = "견제 사격",
		["earthshock"] = "대지 충격",
		["rockbiter"] = "대지의 무기",
		["fade"] = "소실",
		["thunderfury"] = "우레폭풍",

		-- Spell Sets
		-- warlock descruction
		["shadowbolt"] = "어둠의 화살",
		["immolate"] = "제물",
		["conflagrate"] = "점화",
		["searingpain"] = "불타는 고통", -- 2 threat per damage
		["rainoffire"] = "불의 비",
		["soulfire"] = "영혼의 불꽃",
		["shadowburn"] = "어둠의 연소",
		["hellfire"] = "지옥의 불길 효과",

		-- mage offensive arcane
		["arcaneexplosion"] = "신비한 폭발",
		["counterspell"] = "마법 차단",

		-- priest shadow
		["mindblast"] = "정신 분열", 	-- 2 threat per damage
		--[[
		["mindflay"] = "Mind Flay",
		["devouringplague"] = "Devouring Plague",
		["shadowwordpain"] = "Shadow Word: Pain",
		,
		["manaburn"] = "Mana Burn",
		]]
	},
	["power"] =
	{
		["mana"] = "마나",
		["rage"] = "분노",
		["energy"] = "기력",
	},
	["threatsource"] = -- these values are for user printout only
	{
		["powergain"] = "파워 획득",
		["total"] = "합",
		["special"] = "기술/마법",
		["healing"] = "치유",
		["dot"] = "DOT",
		["threatwipe"] = "NPC 주문",
		["damageshield"] = "피해 보호막",
		["whitedamage"] = "평타",
	},
	["talent"] = -- these values are for user printout only
	{
		["defiance"] = "도전",
		["impale"] = "꿰뚫기",
		["silentresolve"] = "무언의 결심",
		["frostchanneling"] = "냉기계 정신집중",
		["burningsoul"] = "불타는 영혼",
		["healinggrace"] = "회복의 토템",
		["shadowaffinity"] = "암흑 마법 친화",
		["druidsubtlety"] = "미묘함",
		["feralinstinct"] = "야생의 본능",
		["ferocity"] = "야수의 본성",
		["savagefury"] = "맹렬한 격노",
		["tranquility"] = "평온 연마",
		["masterdemonologist"] = "악령술의 대가",
		["arcanesubtlety"] = "신비한 미묘함",
		["righteousfury"] = "정의의 격노",
		["sleightofhand"] = "손재주",
		voidwalker = "보이드워커 연마",
	},
	["threatmod"] = -- these values are for user printout only
	{
		["tranquilair"] = "평온의 토템",
		["salvation"] = "구원의 축복",
		["battlestance"] = "전투 태세",
		["defensivestance"] = "방어 태세",
		["berserkerstance"] = "광폭 태세",
		["defiance"] = "도전",
		["basevalue"] = "기본 값",
		["bearform"] = "곰 변신",
		["catform"] = "표범 변신",
		["glovethreatenchant"] = "장갑에 위협수준 증가 마법부여",
		["backthreatenchant"] = "망토에 위협수준 감소 마법부여",
	},
	
	["sets"] = 
	{
		["bloodfang"] = "붉은송곳니",
		["nemesis"] = "천벌",
		["netherwind"] = "소용돌이",
		["might"] = "투지",
		["arcanist"] = "신비술사",
		bonescythe = "해골사신",
		plagueheart = "역병의심장",
	},
	["boss"] = 
	{
		["speech"] = 
		{
			onyxiapull = "I must leave my lair",
			onyxiaphase2 = "This meaningless exertion bores me. I'll incinerate you all from above!",
	  		["onyxiaphase3"] = "혼이 더 나야 정신을 차리겠구나!",

			["razorgorepull"] = "수정 구슬의 지배 마력이 빠져나가자 도망칩니다.",
			["thekalphase2"] = "시르밸라시여, 분노를 채워 주서소!",
			["azuregosport"] = "오너라, 조무래기들아! 덤벼봐라!",
			["nefarianpull"] = "불타라! 활활! 불타라!",
			
			nightbaneland1 = "그만! 내 친히 내려가서 너희를 짓이겨주마!",
			nightbaneland2 = "하루살이 같은 놈들! 나의 힘을 똑똑히 보여주겠다!",
			nightbanepull = "정말 멍청하군! 고통 없이 빨리 끝내주마!",
			
			attumenmount = "이랴! 이 오합지졸을 데리고 실컷 놀아보자!",
			magtheridonpull = "내가... 풀려났도다!",
			ragnarospull = "날 너무 일찍 깨웠도다",
			
			hydrosspull = "방해하도록 놔두지 않겠습니다!",
			hydrossswap1 = "으아아, 독이...",
			hydrossswap2 = "아... 기분이 훨씬 좋군.",
			
			leotherasswap = "꺼져라, 엘프 꼬맹이", -- this isn't the full line
			leotheraspull = "드디어, 내가 풀려났도다!",
			
			nothpull1 = "주인님께 영광을!",
			nothpull2 = "너희 생명은 끝이다!",
			nothpull3 = "죽어라, 침입자들아!",
						
			rajaxxpull = "건방진...  내 친히 너희를 처치해주마!",
			rajaxxignore = "You are not worth my time,? (%s)!",
			
			kaelthasphase1a = "최고의 조언가를 상대로 잘도 버텨냈군",
			kaelthasphase1b = "카퍼니안, 놈들이 여기 온 것을 후회하게 해 줘라",
			kaelthasphase1c = "좋아, 그 정도 실력이면",
			kaelthasphase2 = "보다시피 내 무기고엔 굉장한 무기가 아주 많지.",
			kaelthasphase3 = "네놈들을 과소평가했나 보군.",
			kaelthasphase4 = "이대로 물러날 내가 아니다!",
			kaelthasphase4b = "때론 직접 나서야 할 때도 있는 법이지.",
			
			supremusphase1 = "분노하여 땅을 내리찍습니다",
			
			morogrimpull = "심연의 해일이 집어삼키리라!",
			
			vashjpull1 = "육지에 사는 더러운 놈들같으니!",
			vashjpull2 = "일리단 군주님께 승리를!",
			vashjpull3 = "침입자들에게 죽음을! 일리단 군주님께 승리를!",
			vashjpull4 = "천한 놈들을 상대하며 품위를 손상시키고 싶진 않았는데... 제 손으로 무덤을 파는구나.",
			
			solarianpull = "탈 아누멘 노 신도레이!",

		},
		-- Some of these are unused. Also, if none is defined in your localisation, they won't be used,
		-- so don't worry if you don't implement it.
		["name"] = 
		{
			["rajaxx"] = "장군 라작스",
			["onyxia"] = "오닉시아",
		  	["ebonroc"] = "에본로크",
			firemaw = "화염아귀",
			flamegor = "플레임고르",
			
  			["razorgore"] = "폭군 서슬송곳니",
			["thekal"] = "대사제 데칼",
			["shazzrah"] = "샤즈라",
			["twinempcaster"] = "제왕 베클로어",
			["twinempmelee"] = "제왕 베크닐라쉬",
			["noth"] = "역병술사 노스",
			["leotheras"] = "눈먼 레오테라스",
			ouro = "아우로",
			voidreaver = "공허의 절단기",
			bloodboil = "그루토그 블러드보일",
			doomwalker = "파멸의 절단기",
			ragnaros = "라그나로스",
			patchwerk = "패치워크",
			leotheras = "눈먼 레오테라스",
		},
		["spell"] =
		{
			["shazzrahgate"] = "샤즈라의 문", -- "Shazzrah casts Gate of Shazzrah."
			["wrathofragnaros"] = "라그나로스의 징벌", -- "Ragnaros's Wrath of Ragnaros hits you for 100 Fire damage."
			["timelapse"] = "시간의 쇠퇴", -- "You are afflicted by Time Lapse."
  			["knockaway"] = "날려버리기",
			["wingbuffet"] = "폭풍 날개",
			["burningadrenaline"] = "불타는 아드레날린",
			["twinteleport"] = "쌍둥이 순간이동",
			["nothblink"] = "점멸",
			["sandblast"] = "모래 돌풍",
			["fungalbloom"] = "곰팡이 번식",
			["hatefulstrike"] = "증오의 일격",

			-- 4 horsemen marks
			mark1 = "블라미우스의 징표",
			mark2 = "코스아즈의 징표",
			mark3 = "모그레인의 징표",
			mark4 = "젤리에크의 징표",
			
			-- Onyxia fireball (presumably same as mage)
			fireball = "화염구",

			-- Leotheras, Maulgar, Sartura etc
			whirlwind = "소용돌이",
            
         -- Gurtogg Bloodboil
         insignifigance = "Insignifigance",
			eject = "밀쳐내기",
			felrage = "마의 분노",
			
			-- Doomwalker
			overrun = "괴멸",
		}
	},
	["misc"] =
	{
		["imp"] = "임프", -- UnitCreatureFamily("pet")
		["spellrank"] = "(%d+) 레벨", -- second value of GetSpellName(x, "spell")
		["aggrogain"] = "어그로 튐",
		tankregain = "탱커 재획득",
	},

	-- labels and tooltips for the main window
	["gui"] ={ 
		["self"] = {
			["head"] = {
				-- column headers for the self view
				["name"] = "이름",
				["hits"] = "횟수",
				["dam"] = "피해",
				["threat"] = "위협수준",
				["pc"] = "%T",
			},
			-- text on the self threat reset button
			["reset"] = "초기화",
		},
	},
	["print"] =
	{
		["main"] =
		{
			["startupmessage"] = "|cffffff00KLHThreatMeter |cff33ff33%s.%s|r 로딩됨. 도움말은 |cffffff00/ktm|r을 치십시오.",
		},
		["data"] =
		{
			["abilityrank"] = "당신의 %s 기술은 %s레벨입니다.",
			["globalthreat"] = "당신의 포괄적인 위협수준 배율은 %s입니다.",
			["globalthreatmod"] = "%s에 의한 위협수준 배율은 %s입니다.",
			["multiplier"] = "%s|1으로써;로써;, %s 기술에 의한 위협수준 배율은 %s입니다.",
			["damage"] = "데미지",
			["shadowspell"] = "암흑 주문",
			["arcanespell"] = "아케인 주문",
			["holyspell"] = "신성 주문",
			["setactive"] = "%s %d 셋템이 활성화 : %s.",
			["healing"] = "당신의 치유는 %s 위협수준을 발생시킨다.(포괄적인 위협수준 배율을 적용하기전).",
			["talentpoint"] = "특성포인트 %d : %s 기술.",
			["talent"] = "%d %s 특성 발견.",
			["rockbiter"] = "당신의 %d레벨의 대지의 무기는 근접공격이 성공할 시, %d 위협수준이 추가된다.",
		},
		
		-- new in R17.7
		["boss"] =
		{
			["automt"] = "주 대상이 자동적으로 %s|1으로;로; 설정되었습니다.",
			["spellsetmob"] = "%1$s님이 %3$s의 %4$s 기술의 %2$s 변수값을 %6$s에서 %5$s으로 설정합니다.",
			["spellsetall"] = "%1$s님이 %3$s 기술의 %2$s 변수값을 %5$s에서 %4$s으로 설정합니다.",
			["reportmiss"] = "%s님이 %s의 %s 기술이 자신을 빛맞췄다고 보고합니다.",
			["reporttick"] = "%s님이 %s의 %s 기술이 자신을 맞추었다고 보고합니다. %s틱 동안 피해를 당했으며, %s틱 동안 더 영향을 받을 것입니다.",
			["reportproc"] = "%s님이 %s의 %s 기술이 위협수준을 %s에서 %s으로 변경시켰다고 보고합니다.",
			["bosstargetchange"] = "%s|1이;가; 타겟을 %s(%s 위협수준)에서 %s (%s 위협수준)으로 변경하였습니다.",
			["autotargetstart"] = "다음 대상을 월드보스로 선택할 때 자동으로 미터기를 초기화 하고 주 대상으로 선택할 것입니다.",
			["autotargetabort"] = "주 대상이 이미 월드보스 %s|1으로;로; 설정되었습니다.",
		},

		["network"] =
		{
			["newmttargetnil"] = "주 대상을 %s|1으로;로; 설정할 수 없습니다. %s님은 대상이 없습니다.",
			["newmttargetmismatch"] = "%s님이 주 대상을 %s|1으로;로; 설정하였습니다, 하지만 현재 자신의 대상은 %s입니다. 자신의 대상을 사용하려 했다면, 확인하십시요!",
			["mtpollwarning"] = "당신의 주 대상이 %s|1으로;로; 갱신되었지만, 확신할 수 없습니다. 정확하지 않다면, %s님에게 주 대상을 다시 방송하도록 요청하십시오.",
			["threatreset"] = "%s님이 레이드 어그로미터를 리셋함.",
			["newmt"] = "%2$s님이 주 대상을 %1$s|1으로;로; 설정함.",
			["mtclear"] = "%s님이 주 대상을 초기화함.",
			["knockbackstart"] = "NPC 주문 보고를 %s님이 활성화함.",
			["knockbackstop"] = "NPC 주문 보고를 %s님이 비활성화함.",
			["aggrogain"] = "%s님이 %d의 위협수준으로 어그로를 얻었다고 보고합니다.",
			["aggroloss"] = "%s님이 %d의 위협수준으로 어그로를 잃었다고 보고합니다.",
			["knockback"] = "%s님이 넉백 당했다고 보고됩니다. 그의 위협수준이 %d만큼 감소되었습니다.",
			["knockbackstring"] = "%s님이 이것의 넉백 문자열을 보고합니다.: '%s'",
			["upgraderequest"] = "%s님에게서 KLHThreatMeter Release %s|1으로;로; 업그레이드하라는 요청이 있습니다. 현재 사용중인 Release는 %s 입니다.",
			["remoteoldversion"] = "%s님이 KLHThreatMeter의 오래된 Release %s|1을;를; 사용하고 있습니다. Release %s|1으로;로; 업그레이드하라고 알려주십시오.",
			["knockbackvaluechange"] = "|cffffff00%s|r님이 %s의 |cffffff00%s|r 공격의 위협수준 감소를 |cffffff00%d%%|r|1으로;로; 설정했습니다.",
			["raidpermission"] = "공격대장 또는 부공격대장 권한이 필요합니다.",
			["needmastertarget"] = "먼저 주 대상을 설정하세요!",
			["knockbackinactive"] = "넉백 감지가 공격대에서 활성화되지 못함.",
			["versionrequest"] = "공격대에 버전 정보를 요청중입니다. 3초 후 결과가 옵니다.",
			["versionrecent"] = "release %s|1을;를; 사용하는 사람: { ",
			["versionold"] = "이전 버전을 사용하는 사람: { ",
			["versionnone"] = "KLHThreatMeter를 사용하지 않는 사람: { ",
			needtarget = "먼저 주 대상으로 설정할 몹을 선택하세요.",
			upgradenote = "이전버전을 업그레이드하라고 알리게 됩니다.",
		},
	}
}
