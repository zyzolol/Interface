Automaton_Flight = Automaton:NewModule("Flight", "AceEvent-2.0", "AceDebug-2.0")
local module = Automaton_Flight

local L
local locale = GetLocale()
if locale == "esES" then
	L = {
		["Ghost Wolf"] = "Lobo fantasmal",
	}
elseif locale == "frFR" then
	L = {
		["Ghost Wolf"] = "Loup fantôme",
	}
elseif locale == "deDE" then
	L = {
		["Ghost Wolf"] = "Geisterwolf",
	}	
elseif locale == "koKR" then
	L = {
		["Automatically dismount or unshapeshift when speaking to flight masters"] = "비행 조련사와 대화시 탈것에서 내리거나 변신 상태를 해제합니다.",
		["Ghost Wolf"] = "늑대 정령",
	}
elseif locale == "zhTW" then
	L = {
		["Automatically dismount or unshapeshift when speaking to flight masters"] = "跟飛行管理員說話時自動下馬或者取消變形形態。",
		["Ghost Wolf"] = "幽魂之狼",
	}
elseif locale == "zhCN" then
	L = {
		["Automatically dismount or unshapeshift when speaking to flight masters"] = "跟飞行管理员说话时自动下马或者取消变形形态。",
		["Ghost Wolf"] = "幽魂之狼",
	}
end
L = setmetatable(L or {}, { __index = function(self, key) rawset(self, key, key) return key end })

module.description = L["Automatically dismount or unshapeshift when speaking to flight masters"]
module.options = {}

function module:OnInitialize()
    self.db = Automaton:AcquireDBNamespace("Flight")
    Automaton:RegisterDefaults("Flight", "profile", {
		disabled = false,
    })
	self:RegisterOptions(self.options)
end

function module:OnEnable()
	self:RegisterEvent("TAXIMAP_OPENED")
end

local _, class = UnitClass("player")
function module:TAXIMAP_OPENED()
	if IsMounted() then
		Dismount()
	elseif class == "DRUID" then
		for i = 1,GetNumShapeshiftForms() do
			local _, name, active = GetShapeshiftFormInfo(i)
			if active then
				CancelPlayerBuff(name)
			end
		end
	elseif class == "SHAMAN" then
		CancelPlayerBuff(L["Ghost Wolf"])
	end
end