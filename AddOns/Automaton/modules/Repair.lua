Automaton_Repair = Automaton:NewModule("Repair", "AceEvent-2.0", "AceConsole-2.0", "AceDebug-2.0")

local module = Automaton_Repair
local abacus = AceLibrary("Abacus-2.0")

local L = {}
local locale = GetLocale()
if locale == "esES" then L = {
	["Repair"] = "Reparar",
	["Automatically repair all inventory items when at merchant"] = "Repara autom\195\161ticamente todos tus objetos del inventario cuando est\195\161s en un vendedor",
--	["Use Guild Bank Funds"] = "",
--	["With this option enabled, Repair will try to repair from guild bank funds before using your personal money."] = "",
	["Repairing all items for %s."] = "Reparando todos los objetos por %s",
--	["Repairing all items for %s from guild bank funds."] = "",
	["You cannot afford to repair. Go farm you poor newbie."] = "No tienes suficiente dinero para la reparaci\195\179n",
}
elseif locale == "frFR" then L = {
	["Repair"] = "Réparer",
	["Automatically repair all inventory items when at merchant"] = "Repare automatiquement tous les objets de votres inventaire chez les marchands",
	["Use Guild Bank Funds"] = "Utiliser les fonds de la banque de guilde",
	["With this option enabled, Repair will try to repair from guild bank funds before using your personal money."] = "En activant cette option, les fonds de la banque de guilde seront utilisé en priorité pour effectuer les réparations",
	["Repairing all items for %s."] = "Réparation de tous les objets pour %s.",
	["Repairing all items for %s from guild bank funds."] = "Réparation de tous les objets pour %s des fonds de la banque de guilde.",
	["You cannot afford to repair. Go farm you poor newbie."] = "Vous ne pouvez pas vous permettre de réparer. Va farmer péon ^^.",
}
elseif locale == "koKR" then L = {
	["Repair"] = "수리",
	["Automatically repair all inventory items when at merchant"] = "상인에게 모든 아이템을 자동으로 수리합니다.",
	["Use Guild Bank Funds"] = "길드 은행 골드 사용",
	["With this option enabled, Repair will try to repair from guild bank funds before using your personal money."] = "개인 골드를 사용하기전 길드 은행의 골드를 사용합니다.",
	["Repairing all items for %s."] = "모든 아이템 수리비: %s",
	["Repairing all items for %s from guild bank funds."] = "길드 은행으로부터 아이템 수리비 : %s",
	["You cannot afford to repair. Go farm you poor newbie."] = "당신은 아이템 수리를 할 수 없습니다. 돈이 부족합니다.",
}
elseif locale == "zhCN" then L = {
	["Repair"] = "自动修理",
	["Automatically repair all inventory items when at merchant"] = "当打开商人窗口时自动修理全部装备",
	["Use Guild Bank Funds"] = "使用公会公款",
	["With this option enabled, Repair will try to repair from guild bank funds before using your personal money."] = "当该选项开启后，将会在使用你自己的钱修理前先尝试使用公会银行的钱。",
	["Repairing all items for %s."] = "本次修理花费：%s",
	["Repairing all items for %s from guild bank funds."] = "本次修理公会花费：%s",
	["You cannot afford to repair. Go farm you poor newbie."] = "你个穷鬼都修不起你的装备，赶紧去Farm去！",
}
elseif locale == "zhTW" then L = {
	["Repair"] = "自動修裝",
	["Automatically repair all inventory items when at merchant"] = "自動修理裝備",
	["Use Guild Bank Funds"] = "使用公會銀行金錢",
	["With this option enabled, Repair will try to repair from guild bank funds before using your personal money."] = "此選項開啟後，將在使用自己金錢前試著用公會銀行金錢修理裝備。",
	["Repairing all items for %s."] = "此次共修理了 : %s",
	["Repairing all items for %s from guild bank funds."] = "此次使用公會銀行修理了 ： %s",
	["You cannot afford to repair. Go farm you poor newbie."] = "你身上沒有組購的修裝費用!",
}
end
L = setmetatable(L, { __index = function(t, k) t[k] = k; return k end })

module.description = L["Automatically repair all inventory items when at merchant"]
module.options = {
	guild = {
		name = L["Use Guild Bank Funds"],
		desc = L["With this option enabled, Repair will try to repair from guild bank funds before using your personal money."],
		type = "toggle",
		get = function() return module.db.profile.guild end,
		set = function(v) module.db.profile.guild = v end,
	}
}

function module:OnInitialize()
	self.db = Automaton:AcquireDBNamespace("Repair")
	Automaton:RegisterDefaults("Repair", "profile", {
		disabled = true,
		guild = false,
	})
	self:RegisterOptions(self.options)
end

function module:OnEnable()
	self:RegisterEvent("MERCHANT_SHOW")
end

function module:MERCHANT_SHOW()
	if IsShiftKeyDown() or not CanMerchantRepair() then return end

	local cost = GetRepairAllCost()
	if cost > 0 then
		local money = GetMoney()

		if module.db.profile.guild and IsInGuild() then
			local guildMoney = GetGuildBankWithdrawMoney()
			if guildMoney == -1 then
				guildMoney = GetGuildBankMoney()
			end
			if guildMoney > cost then
				if not self:IsDebugging() then
					RepairAllItems(1)
				end
				self:Print(L["Repairing all items for %s from guild bank funds"], abacus:FormatMoneyFull(cost, true))
				return
			end
		end

		if money > cost then
			if not self:IsDebugging() then
				RepairAllItems()
			end
			self:Print(L["Repairing all items for %s"], abacus:FormatMoneyFull(cost, true))
		else
			self:Print(L["You cannot afford to repair. Go farm you poor newbie."])
		end
	end
end