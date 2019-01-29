local L = AceLibrary("AceLocale-2.2"):new("Talented")
local pcall = pcall
local Talented = Talented

Talented.OnCommReceive = {}

function Talented.OnCommReceive:ShareTemplate(prefix, sender, distribution, name, code)
	local opt = StaticPopupDialogs.TALENTED_CONFIRM_SHARE_TEMPLATE
	if not opt then
		opt = {
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				local res, value, class = pcall(self.StringToTemplate, self, opt.code)
				if res then
					self:ImportFromOther(opt.name, {code = opt.code, class = class})
				else
					self:Print("Invalid template", value)
				end
			end,
			timeout = 0,
			exclusive = 1,
			whileDead = 1,
			interruptCinematic = 1
		}
		StaticPopupDialogs.TALENTED_CONFIRM_SHARE_TEMPLATE = opt
	end
	
	opt.text = L["Do you want to add the template \"%s\" that %s sent you ?"]:format(name, sender)
	opt.name = ("%s - %s"):format(sender, name)
	opt.code = code
	
	StaticPopup_Show("TALENTED_CONFIRM_SHARE_TEMPLATE")
end

function Talented:ExportTemplateToUser(name)
	self:SendCommMessage("WHISPER", name, "ShareTemplate", self.template.name, self:TemplateToString(self.template))
end

-- Support for TalentQuery built in LibRockComm, if it's available.
if Rock then
	local comm = Rock:HasLibrary("LibRockComm-1.0") and Rock:GetLibrary("LibRockComm-1.0")
	if not comm or not comm.AddTalentReceptor then return end
	
	local prat_open_on_reception
	function Talented:QueryTalents(name, open)
		comm:QueryTalents("WHISPER", name)
		if open then
			prat_open_on_reception = name
		end
	end
	
	Talented.options.args.template.args.RockTalents = {
		order = 300,
		type = "group",
		name = L["From Rock"],
		desc = L["Received talent information from LibRock."],
		args = {
			query = {
				type = "text",
				order = 60,
				name = L["Query"],
				desc = L["Request a player's talent spec."],
				usage = L["<name>"],
				get = false,
				set = function (value)
					Talented:QueryTalents(value, true)
				end,
			},
			group = {
				type="execute",
				order=50,
				name = L["Query group"],
				desc = L["Request talent information for your whole group (party or raid)."],
				func = function () comm:QueryTalents("GROUP") end,
			},
		}
	}

	local player_name_map = setmetatable({}, { __mode="kv"})
	function Talented:AddTemplateToRockOptions(template)
		local tname = template.name
		local count, opt, name = 1, self.options.args.template.args.RockTalents.args, player_name_map[tname]
		if not name then
			while true do
				name = format("template%d", count)
				if not opt[name] then break end
				count = count + 1
			end
			player_name_map[tname] = name
		end
		local colour = RAID_CLASS_COLORS[template.class]
		tname = ("|cff%.2x%.2x%.2x%s|r"):format(colour.r*255, colour.g*255, colour.b*255, name)
		opt[name] = {
			type = "execute",
			order = 100,
			name = tname,
			desc = format(L["Select %s"], template.name),
			func = function () self:SetTemplate(template) end,
		}
	end

	comm:AddTalentReceptor(function (name, talents)
		-- clone the template as PackTemplate modifies the table.
		local template = {
			name = name,
			class = talents.class,
		}
		for i, tree in ipairs(talents) do
			local dtree = {}
			template[i] = dtree
			for j, v in ipairs(tree) do
				dtree[j] = v
			end
		end
		local p = Talented.db.profile
		local o = p.report_unavailable
		p.report_unavailable = false
		if Talented:ValidateTemplate(template) then
			Talented:PackTemplate(template)
			Talented:AddTemplateToRockOptions(template)
			if prat_open_on_reception == name then
				prat_open_on_reception = nil
				Talented:OpenTemplate(template)
			end
		end
		p.report_unavailable = o
	end)
end
