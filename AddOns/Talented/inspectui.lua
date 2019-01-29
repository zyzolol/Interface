local L = AceLibrary("AceLocale-2.2"):new("Talented")
local Talented = Talented

local prev_script
local new_script = function ()
	Talented:OpenTemplate(Talented:UpdateInspectTemplate())
end

local player_name_map = setmetatable({}, { __mode="kv"})
local InspectedTalents = {
	order = 300,
	type = "group",
	name = L["Inspected Players"],
	desc = L["Talent trees of inspected players."],
	args = {
	}
}


function Talented:HookInspectUI()
	if not prev_script then
		prev_script = InspectFrameTab3:GetScript("OnClick")
		InspectFrameTab3:SetScript("OnClick", new_script)
	end
end

function Talented:UnhookInspectUI()
	if prev_script then
		InspectFrameTab3:SetScript("OnClick", prev_script)
	end
end

function Talented:CheckHookInspectUI()
	if not self:IsEventRegistered("INSPECT_TALENT_READY") then
		self:RegisterEvent("INSPECT_TALENT_READY")
	end
	if self.db.profile.hook_inspect_ui then
		if IsAddOnLoaded("Blizzard_InspectUI") then
			self:HookInspectUI()
		else
			self:RegisterEvent("ADDON_LOADED")
		end
	else
		if IsAddOnLoaded("Blizzard_InspectUI") then
			self:UnhookInspectUI()
		elseif self:IsEventRegistered("ADDON_LOADED") then
			self:UnregisterEvent("ADDON_LOADED")
		end
	end
end

function Talented:INSPECT_TALENT_READY()
	local template = self:UpdateInspectTemplate()
	if template == self.current then
		self:UpdateView()
	end
end

function Talented:ADDON_LOADED(addon)
	if addon == "Blizzard_InspectUI" then
		self:UnregisterEvent("ADDON_LOADED")
		self:HookInspectUI()
	end
end

function Talented:UpdateInspectTemplate()
	local unit = InspectFrame and InspectFrame.unit
	if not unit then return end
	local name = UnitName(unit)
	if not name then return end
	local info
	local inspections = self.inspections
	if not inspections then
		inspections = {}
		self.inspections = inspections
		Talented.options.args.template.args.InspectedTalents = InspectedTalents
	end
	local template = inspections[name]
	if not template then
		local class = select(2, UnitClass(unit))
		template = {
			name = L["Inspection of %s"]:format(name),
			class = class,
		}
		info = self:GetTalentInfo(class, true)
		if not info then
			error(("Unable to get talent for class %s, %s"):format(class, "inspect"))
		end
		for tab, tree in ipairs(info) do
			template[tab] = { talents = {} }
		end
		inspections[name] = template
	else
		self:UnpackTemplate(template)
		info = self:GetTalentInfo(template.class)
	end
	local total = 0 
	for tab, tree in ipairs(info) do
		for index, info in ipairs(tree.talents) do
			local rank = select(5, GetTalentInfo(tab, index, true))
			template[tab][index] = rank
			total = total + rank
		end
	end
	if self:ValidateTemplate(template) then
		self:PackTemplate(template)
		self:AddTemplateToInspectedTalents(template)
	end
	return template
end

function Talented:AddTemplateToInspectedTalents(template)
	local tname = template.name
	local count, opt, name = 1, InspectedTalents.args, player_name_map[tname]
	if not name then
		while true do
			name = format("template%d", count)
			if not opt[name] then break end
			count = count + 1
		end
		player_name_map[tname] = name
	end
	local colour = RAID_CLASS_COLORS[template.class]
	tname = ("|cff%.2x%.2x%.2x%s|r"):format(colour.r*255, colour.g*255, colour.b*255, tname)
	opt[name] = {
		type = "execute",
		order = 100,
		name = tname,
		desc = format(L["Select %s"], template.name),
		func = function () self:SetTemplate(template) end,
	}
end

