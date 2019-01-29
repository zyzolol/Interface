local ipairs = ipairs
local select = select
local Talented = Talented
local PlayerClass = select(2, UnitClass("player"))
local L = AceLibrary("AceLocale-2.2"):new("Talented")

local reset = function(...)
	if select("#", ...) > 0 then
		Talented:Print(...)
	end
	Talented:SetTemplate()
	Talented:EnableUI(true)
end

function Talented:ApplyNextTalentPoint()
	local cp = UnitCharacterPoints("player")
	
	local found = false
	local current = self.current
	local template = self.template
	for tab, tree in ipairs(self:GetTalentInfo(PlayerClass)) do
		local ctab = current[tab]
		local ttab = template[tab]
		for index in ipairs(tree.talents) do
			local cvalue = ctab[index]
			if cvalue < ttab[index] then
				if cp == 0 then
					reset(L["Error while applying talents! Not enough talent points!"])
					return
				end
				found = true
				if self:ValidateTalentBranch(current, tab, index, cvalue + 1) then
					self:LearnTalent(tab, index)
					return
				end
			end
		end
	end
	if not found then
		reset(L["Template applied successfully, %d talent points remaining."], cp)
	else
		reset(L["Error while applying talents! Invalid template!"])
	end
end
