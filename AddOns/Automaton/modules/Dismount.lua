Automaton_Dismount = Automaton:NewModule("Dismount", "AceEvent-2.0", "AceDebug-2.0")
local module = Automaton_Dismount

local L
local locale = GetLocale()
if locale == "esES" then
	L = {
		["Dismount"] = "Desmontar",
		["Automatically dismount when you receive the 'You are mounted' error"] = "Te desmonta autom\195\161ticamente cuando recibes el error 'Est\195\161s montado'",
	}
elseif locale == "koKR" then
	L = {
		["Dismount"] = "탈것 내림",
		["Automatically dismount when you receive the 'You are mounted' error"] = "'탈것 내리기' 오류시 자동으로 탈것에서 내립니다.",
	}
elseif locale == "zhTW" then
	L = {
		["Dismount"] = "自動下馬",
		["Automatically dismount when you receive the 'You are mounted' error"] = "當收到'您正在騎乘狀態' 的訊息時自動下馬",
	}
elseif locale == "zhCN" then
	L = {
		["Automatically dismount when you receive the 'You are mounted' error"] = "当收到“您正在骑乘状态”这样的信息时自动下马",
	}
end
L = setmetatable(L or {}, { __index = function(self, key) rawset(self, key, key) return key end })

module.description = L["Automatically dismount when you receive the 'You are mounted' error"]
module.options = {}

function module:OnInitialize()
    self.db = Automaton:AcquireDBNamespace("Dismount")
    Automaton:RegisterDefaults("Dismount", "profile", {
		disabled = true,
    })
	Automaton:SetDisabledAsDefault(self, "Dismount")
	self:RegisterOptions(self.options)
end

function module:OnEnable()
	self:RegisterEvent("UI_ERROR_MESSAGE")
end

local messages = {
	[ERR_TAXIPLAYERALREADYMOUNTED] = true,
	[ERR_ATTACK_MOUNTED] = true,
	[SPELL_FAILED_NOT_MOUNTED] = true,
	[SPELL_FAILED_OUT_OF_RANGE] = true,
	[ERR_OUT_OF_RANGE] = true,
	[ERR_PET_SPELL_OUT_OF_RANGE] = true,
	[ERR_NOT_WHILE_MOUNTED] = true,
}

function module:UI_ERROR_MESSAGE(msg)
	if UnitOnTaxi("player") then return end
	if not messages[msg] then return end

	if IsMounted() and not IsFlying() then
		Dismount()
	end
end