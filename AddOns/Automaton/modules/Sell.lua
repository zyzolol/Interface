--[[
  if there are any grey items you wish autosell to ignore, add them to the following table
  crochet hat and large slimy bones are examples, be sure not to include comment mark "--"
  in items which should actually be ignored.
--]]

local ignore = {
--		"Crochet Hat",
--		"Large Slimy Bone",
}

local L = AceLibrary("AceLocale-2.2"):new("Automaton_Sell")
Automaton_Sell = Automaton:NewModule("Sell", "AceEvent-2.0", "AceDebug-2.0")
local module = Automaton_Sell

L:RegisterTranslations("enUS", function() return {
    ["Sell"] = true,
	["Automatically sell all grey inventory items when at merchant"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
    ["Sell"] = "아이템 판매",
	["Automatically sell all grey inventory items when at merchant"] = "상인에게 자동으로 모든 회색 품목의 아이템을 판매합니다.",
} end)

L:RegisterTranslations("esES", function() return {
    ["Sell"] = "Vender",
	["Automatically sell all grey inventory items when at merchant"] = "Vende autom\195\161ticamente todos los objetos grises de tu inventario cuando est\195\161s en un vendedor",
} end)

L:RegisterTranslations("zhTW", function() return {
    ["Sell"] = "清理垃圾",
	["Automatically sell all grey inventory items when at merchant"] = "與商人交易時自動賣出灰色物品",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Automatically sell all grey inventory items when at merchant"] = "与商人交易时自动出售灰色的物品",
} end)

module.description = L["Automatically sell all grey inventory items when at merchant"]
module.options = {
}

function module:OnInitialize()
	self:RegisterOptions(self.options)
end

function module:OnEnable()
	self:RegisterEvent("MERCHANT_SHOW")
end

local bag, slot
function module:MERCHANT_SHOW()
	for bag = 0, 4 do
		if GetContainerNumSlots(bag) > 0 then
			for slot = 1, GetContainerNumSlots(bag) do
				local texture, itemCount, locked, quality = GetContainerItemInfo(bag, slot)
				if quality == 0 or quality == -1 then
					local linkcolor = self:ProcessLink(GetContainerItemLink(bag, slot))
					if linkcolor == 1 and not self:IsDebugging() then
						UseContainerItem(bag, slot)
					end
				end
			end
		end
	end
end

local color, name
function module:ProcessLink(link)
	for color, name in string.gmatch(link, "(|c%x+)|Hitem:.+|h%[(.-)%]|h|r") do
		for k,v in pairs(ignore) do
			if name == v then
				return 0
			end
		end

		if color == ITEM_QUALITY_COLORS[0].hex then
			self:Debug("ProcessLink: %s", name)
			return 1
		end
	end
	return 0
end