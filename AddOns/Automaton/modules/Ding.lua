local L = AceLibrary("AceLocale-2.2"):new("Automaton_Ding")
Automaton_Ding = Automaton:NewModule("Ding", "AceEvent-2.0", "AceConsole-2.0", "AceDebug-2.0")
local module = Automaton_Ding

L:RegisterTranslations("enUS", function() return {
    ["Ding"] = true,
    ["Notification on level up"] = true,
    ["Enable"] = true,
    ["Enable module"] = true,
    ["Message"] = true,
    ["Notification message"] = true,
    ["Notification usage"] = [[

$L - New Level
$l - Old Level
$C - Class
$R - Race
$N - Name]],
    ["Woot, ding $L!"] = true, -- default message
    ["Channels"] = true,
    ["Channels to notify"] = true,
    ["Notify %s channel"] = true,
    ["Minimum Level"] = true,
    ["Notify only when player level is greater than or equal to this minimum"] = true,
    ["Multiple"] = true,
    ["Notify only when player level is a positive multiple of this number"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
    ["Ding"] = "울림",
    ["Notification on level up"] = "레벨 업 통지",
    ["Enable"] = "활성화",
    ["Enable module"] = "모듈 활성화",
    ["Message"] = "메시지",
    ["Notification message"] = "메시지 통지",
    ["Notification usage"] = [[

$L - New Level
$l - Old Level
$C - Class
$R - Race
$N - Name]],
    ["Woot, ding $L!"] = "Woot, ding $L!", -- 기본 메시지
    ["Channels"] = "채널",
    ["Channels to notify"] = "통지 채널",
    ["Notify %s channel"] = "%s 채널에 통지",
    ["Minimum Level"] = "최소 레벨",
    ["Notify only when player level is greater than or equal to this minimum"] = "플레이어 레벨이 최소 레벨과 같거나 높을때 알립니다.",
    ["Multiple"] = "배수",
    ["Notify only when player level is a positive multiple of this number"] = "플레이어 레벨이 이 숫자의 배수일때 통지합니다.",
} end)

L:RegisterTranslations("esES", function() return {
    ["Ding"] = "Ding",
    ["Notification on level up"] = "Notificaci\195\179n al subir de nivel",
    ["Enable"] = "Activar",
    ["Enable module"] = "Activa el m\195\179dulo",
    ["Message"] = "Mensaje",
    ["Notification message"] = "Mensaje de notificaci\195\179n",
    ["Notification usage"] = [[

$L - New Level
$l - Old Level
$C - Class
$R - Race
$N - Name]],
    ["Woot, ding $L!"] = "\194\161Genial, ding $L!", -- default message
    ["Channels"] = "Canales",
    ["Channels to notify"] = "Canales a notificar",
    ["Notify %s channel"] = "Notifica en el canal %s",
    ["Minimum Level"] = "Nivel m\195\173nimo",
    ["Notify only when player level is greater than or equal to this minimum"] = "Notificar s\195\179lo cuando el nivel del jugador sea mayor o igual a este m\195\173nimo",
    ["Multiple"] = "M\195\186ltiplo",
    ["Notify only when player level is a positive multiple of this number"] = "Notificar s\195\179lo cuando el nivel del jugador sea un m\195\186ltiplo positivo de este n\195\186mero",
} end)

L:RegisterTranslations("zhTW", function() return {
["Ding"] = "升級提醒",
["Notification on level up"] = "升級時提醒",
["Enable"] = "開啟",
["Enable module"] = "開啟模塊",
["Message"] = "信息",
["Notification message"] = "提示信息",
["Notification usage"] = [[

$L - New Level
$l - Old Level
$C - Class
$R - Race
$N - Name]],
["Woot, ding $L!"] = "$L 嘍!",  -- default message
["Channels"] = "頻道",
["Channels to notify"] = "需要提醒的頻道",
["Notify %s channel"] = "提醒您查看 %s 頻道",
["Minimum Level"] = "最小等級",
["Notify only when player level is greater than or equal to this minimum"] = "當您的等級遠遠超過或與此最小等級相當時發出警告",
["Multiple"] = "倍數",
["Notify only when player level is a positive multiple of this number"] = "當您的等級為此設定值的倍數時發出警告",

} end)

L:RegisterTranslations("zhCN", function() return {
    ["Notification on level up"] = "升级时进行通知",
    ["Enable"] = "启用",
    ["Enable module"] = "启用该模块",
    ["Message"] = "信息",
    ["Notification message"] = "提醒信息",
    ["Notification usage"] = [[

$L - 新的级别
$l - 旧的级别
$C - 职业
$R - 种族
$N - 名称]],
    ["Woot, ding $L!"] = "哇哈哈，$L级了！",
    ["Channels"] = "频道",
    ["Channels to notify"] = "要通知到的频道",
    ["Notify %s channel"] = "通知%s频道",
    ["Minimum Level"] = "最低级别",
    ["Notify only when player level is greater than or equal to this minimum"] = "只有当玩家级别大于或等于这个值时才通知",
    ["Multiple"] = "倍数",
    ["Notify only when player level is a positive multiple of this number"] = "只有当玩家级别为这个值的倍数时才通知",
} end)

local types = {"say", "emote", "yell", "party", "guild", "officer", "raid", "battleground"}
local gsubtbl = {}

module.description = L["Notification on level up"]
module.options = {
	message = {
		type  = "text",
		name  = L["Message"],
		desc  = L["Notification message"],
		usage = L["Notification usage"],
		get   = function() return module.db.profile.message end,
		set   = function(v) module.db.profile.message = v end,
		order = 20,
	},
	minlevel = {
        type  = "range",
        name  = L["Minimum Level"],
        desc  = L["Notify only when player level is greater than or equal to this minimum"],
        min   = 1,
        max   = MAX_PLAYER_LEVEL,
        step  = 1,
        get   = function() return module.db.profile.minlevel end,
        set   = function(v) module.db.profile.minlevel = v end,
        order = 25,
    },
	multiple = {
		type  = "range",
		name  = L["Multiple"],
		desc  = L["Notify only when player level is a positive multiple of this number"],
		min   = 1,
		max   = MAX_PLAYER_LEVEL,
		step  = 1,
		get   = function() return module.db.profile.multiple end,
		set   = function(v) module.db.profile.multiple = v end,
		order = 30,
	},
	channels = {
		type  = "group",
		name  = L["Channels"],
		desc  = L["Channels to notify"],
		args  = {},
		order = 40,
	},
}

function module:OnInitialize()
	for _,t in ipairs(types) do
		self.options.channels.args[t] = {
			type = "toggle",
			name = t,
			desc = L["Notify %s channel"]:format(t),
			get  = function()
				return self.db.profile.channels[t]
			end,
			set  = function(v)
				self.db.profile.channels[t] = v
			end,
		}
	end

    self.db = Automaton:AcquireDBNamespace("Ding")
    Automaton:RegisterDefaults("Ding", "profile", {
		disabled = true,
        message  = L["Woot, ding $L!"],
        minlevel = 5,
        multiple = 1,
        channels = {
            guild = true,
            party = true,
        },
    })
	Automaton:SetDisabledAsDefault(self, "Ding")
	self:RegisterOptions(self.options)
end

function module:OnEnable()
    self:RegisterEvent("PLAYER_LEVEL_UP")

    gsubtbl["$R"] = UnitRace("player")
    gsubtbl["$N"] = UnitName("player")
    gsubtbl["$C"] = UnitClass("player")
end

function module:PLAYER_LEVEL_UP(level, hp, mp, tp, str, agi, sta, int, spi)
	if level < self.db.profile.minlevel then
        self:Debug(("Skipping notification: %s is below threshold %s."):format(level, self.db.profile.minlevel))
        return
    end
    if level % self.db.profile.multiple ~= 0 then
        self:Debug(("Skipping notification: %s is not a positive multiple of %s"):format(level, self.db.profile.multiple))
        return
    end

    gsubtbl["$L"] = tostring(level)
    gsubtbl["$l"] = tostring(level - 1)
    local msg = self.db.profile.message:gsub("($%w)", gsubtbl)
    for k,v in ipairs(types) do
        if self.db.profile.channels[v] then
            self:Debug(("Sending `%s' to channel `%s'."):format(msg, v:upper()))
            SendChatMessage(msg, v:upper())
        end
    end
end