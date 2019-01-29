--[[
_ Talented is a complete rewrite of the Talent Frame using a little bit of Ace.

_ Talented makes a lot more assumptions than the original Blizzard code about talents.

_ Talented show all 3 talent tabs at the same time.
_ Talented allows to create and store templates
]]

Talented = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceDebug-2.0", "AceHook-2.1", "AceEvent-2.0", "AceComm-2.0")

local Talented = Talented
local ipairs = ipairs
local pairs = pairs
local format = string.format
local PlayerClass = select(2, UnitClass("player"))

local L = AceLibrary("AceLocale-2.2"):new("Talented")

Talented:RegisterDB("TalentedDB", "TalentedCharDB")
-- Talented:RegisterDefaults("class", { templates = {} })
Talented:RegisterDefaults("profile", {
	confirmlearn = true,
	confirmlearn_skip_on_apply = true,
	always_call_learn_talents = false,
	default_mode = "view",
	report_unavailable = true,
	reported_once = false,
	level_cap = true,
	show_level_req = true,
	offset = 64,
	scale = 1,
	templates = {},
--	last_template = nil,
	force_load = false,
	offsetx = 0,
	offsety = 0,
	point = "CENTER",
	hook_inspect_ui = false,
})
Talented:RegisterDefaults("char", {
--	target = nil,
})

Talented.template_mode_args = {
	switch = {
		name = L["Back to normal mode"],
		desc = L["Return to the normal talents mode."],
		type = "execute",
		order = 80,
		func = function () Talented:SetTemplateMode(false) end,
	},
	h0 = {
		type = "header",
		order = 90,
	},
	edit = {
		name = L["Edit template"],
		desc = L["Toggle editing of the template."],
		type = "toggle",
		disabled = function () return Talented.mode ~= "view" and Talented.mode ~= "edit" end,
		get = function () return Talented.mode == "edit" end,
		set = function (value) 
				if Talented.mode == "edit" then
					Talented:SetMode("view")
				else
					Talented:SetMode("edit")
				end
			end,
		order = 100,
	},
	h1 = {
		type = "header",
		order = 150,
	},
	apply = {
		name = L["Apply template"],
		desc = L["Apply the current template to your character."],
		type = "execute",
		order = 200,
		disabled = function () return Talented.template == Talented.current or Talented.template.class ~= PlayerClass end,
		func = function () Talented:SetMode("apply") end,
		confirm = L["Are you sure that you want to apply the current template's talents?"],
	},
	delete = {
		name = L["Delete template"],
		desc = L["Delete the current template."],
		type = "execute",
		order = 210,
		disabled = function () return Talented.template == Talented.current end,
		func = function () Talented:SetMode("delete") end,
		confirm = L["Are you sure that you want to delete this template?"],
	},
	import = {
		name = L["Import template"],
		desc = L["Import a template from Blizzard's talent calculator."],
		usage = L["<full url of the template>"],
		type = "text",
		order = 220,
		get = false,
		set = function (url) Talented:SetTemplate(Talented:ImportTemplate(url)) end,
	},
	export = {
		name = L["Export template"],
		desc = L["Export the template."],
		type = "group",
		order = 230,
		args = {
			chat = {
				name = L["Export to chat"],
				desc = L["Export this template to your current chat channel."],
				type = "execute",
				order = 10,
				func = function () Talented:ExportTemplateToChat() end,
			},
			url = {
				name = L["Export as URL"],
				desc = L["Export the template as a URL."],
				type = "group",
				order = 20,
				args = {
					wow = {
						name = L["WoW Talent Calculator"],
						desc = L["Export the template as a URL to the official talent calculator"],
						type = "execute",
						order = 10,
						func = function () Talented:ExportTemplateURL() end,
					},
					wh = {
						name = L["Wowhead Talent Calculator"],
						desc = L["Export the template as a URL to the wowhead talent calculator."],
						type = "execute",
						order = 20,
						func = function () Talented:ExportTemplateURL("wowhead") end,
					},
					wd = {
						name = L["Wowdb Talent Calculator"],
						desc = L["Export the template as a URL to the wowdb talent calculator."],
						type = "execute",
						order = 30,
						func = function () Talented:ExportTemplateURL("wowdb") end,
					}
				},
			},
			sendto = {
				name = L["Export to ..."],
				desc = L["Send the template to another Talented user."],
				usage = L["<name>"],
				type = "text",
				order = 30,
				get = false,
				set = function (name) Talented:ExportTemplateToUser(name) end,
			},
		},
	},
	target = {
		name = L["Set as target"],
		desc = L["Set this template as the target template, so that you may use it as a guide in normal mode."],
		type = "toggle",
		order = 240,
		disabled = function () return Talented.template == Talented.current or Talented.template.class ~= PlayerClass end,
		get = function () return Talented.db.char.target == Talented.template.name end,
		set = function (v)
			if v then 
				Talented.db.char.target = Talented.template.name
			else 
				Talented.db.char.target = nil
			end
		end,
	},
}

Talented.normal_mode_args = {
	switch = {
		name = L["Switch to template mode"],
		desc = L["Enter template editing mode."],
		type = "execute",
		order = 80,
		func = function () Talented:SetTemplateMode(true) end,
	},
	h0 = Talented.template_mode_args.h0,
	edit = {
		name = L["Edit talents"],
		desc = L["Toggle editing of talents."],
		type = "toggle",
		disabled = Talented.template_mode_args.edit.disabled,
		get = Talented.template_mode_args.edit.get,
		set = Talented.template_mode_args.edit.set,
		order = 100,
	},
	h1 = Talented.template_mode_args.h1,
	export = Talented.template_mode_args.export,
}

Talented.options = {
	desc = L["Talented - Talent Editor"],
	type = "group",
	args = {
		options = {
			name = L["Options of Talented"],
			desc = L["Options for Talented."],
			type = "group",
			args = {
				default_mode = {
					name = L["Default to edit"],
					desc = L["Always show templates and talent in edit mode by default."],
					type = "toggle",
					get = function() return Talented.db.profile.default_mode == "edit" end,
					set = function(value) Talented.db.profile.default_mode = value and "edit" or "view" end,
					order = 100,
				},
				confirmlearn = {
					name = L["Confirm Learning"],
					desc = L["Ask for user confirmation before learning any talent."],
					type = "toggle",
					get = function() return Talented.db.profile.confirmlearn end,
					set = function(value) Talented.db.profile.confirmlearn = value end,
					order = 200,
				},
				confirmlearn_skip_on_apply = {
					name = L["Don't Confirm when applying"],
					desc = L["Don't ask for user confirmation when applying full template."],
					type = "toggle",
					get = function() return Talented.db.profile.confirmlearn_skip_on_apply end,
					set = function(value) Talented.db.profile.confirmlearn_skip_on_apply = value end,
					disabled = function () return not Talented.db.profile.confirmlearn end,
					order = 210,
				},
				always_call_learn_talents = {
					name = L["Always try to learn talent"],
					desc = L["Always call the underlying API when a user input is made, even when no talent should be learned from it."],
					type = "toggle",
					get = function() return Talented.db.profile.always_call_learn_talents end,
					set = function(value) Talented.db.profile.always_call_learn_talents = value end,
					disabled = function () return not Talented.db.profile.confirmlearn end,
					order = 220,
				},
				level_cap = {
					name = L["Talent cap"],
					desc = L["Restrict templates to a maximum of 61 points."],
					type = "toggle",
					get = function() return Talented.db.profile.level_cap end,
					set = function(value) Talented.db.profile.level_cap = value ; Talented:UpdateView() end,
					order = 300,
				},
				level_req = {
					name = L["Level restriction"],
					desc = L["Show the required level for the template, instead of the number of points."],
					type = "toggle",
					get = function() return Talented.db.profile.show_level_req end,
					set = function(value) Talented.db.profile.show_level_req = value ; Talented:UpdateView() end,
					order = 400,
				},
				layout = {
					name = L["Layout options"],
					desc = L["Options that change the visual layout of Talented."],
					type = "group",
					order = 500,
					args = {
						offset = {
							name = L["Icon offset"],
							desc = L["Distance between icons."],
							type = "range",
							min = 42,
							max = 64,
							step = 1,
							get = function() return Talented.db.profile.offset end,
							set = function(value) Talented.db.profile.offset = value ; Talented:ReLayout() end,
							order = 100,
						},
						scale = {
							name = L["Frame scale"],
							desc = L["Overall scale of the Talented frame."],
							type = "range",
							min = 0.5,
							max = 1.0,
							step = 0.01,
							get = function () return Talented.db.profile.scale end,
							set = function (value) Talented.db.profile.scale = value ; Talented:ReLayout() end,
							order = 200,
						},
					},
				},
				force_load = {
					name = L["Load outdated data"],
					desc = L["Load Talented_Data, even if outdated."],
					type = "toggle",
					hidden = not GetAddOnInfo("Talented_Data"),
					get = function() return Talented.db.profile.force_load end,
					set = function(value) Talented.db.profile.force_load = value ; Talented:ResetDataLoadedStatus() end,
					order = 600,
				},
				inspect_ui = {
					name = L["Hook Inspect UI"],
					desc = L["Hook the Talent Inspection UI."],
					type = "toggle",
					get = function() return Talented.db.profile.hook_inspect_ui end,
					set = function(value) Talented.db.profile.hook_inspect_ui = value ; Talented:CheckHookInspectUI() end,
					order = 700,
				},
			}
		},
		mode = {
			name = L["Mode"],
			desc = L["Mode of operation."],
			type = "group",
		},
		template = {
			name = L["Template"],
			desc = L["Template"],
			type = "group",
			args = {
				new = {
					name = L["New Template"],
					desc = L["Create a new Template."],
					type = "group",
					order = 100,
					args = {
						empty = {
							name = L["New empty template"],
							desc = L["Create a new template from scratch."],
							type = "execute",
							order = 100,
							func = function() Talented:SetTemplate(Talented:CreateEmptyTemplate()) end,
						},
						h1 = {
							type = "header",
							order = 150,
						},
						-- copy from existing templates here
						current = {
							name = L["Copy current talent spec"],
							desc = L["Create a new template from your current spec."],
							type = "execute",
							order = 300,
							func = function() Talented:SetTemplate(Talented:CopyTemplate(Talented.current)) end,
						},
						clone = {
							name = L["Clone selected"],
							desc = L["Make a copy of the current template."],
							type = "execute",
							order = 400,
							func = function () Talented:SetTemplate(Talented:CopyTemplate(Talented.template)) end,
						}
					},
				},
			}
		}
	},
}

function Talented:MakeTarget()
	local name = self.db.char.target
	local src = name and self.db.profile.templates[name]
	if not src then 
		if name then
			self.db.char.target = nil
		end
		return
	end
	
	local target = self.target
	if not target then
		target = {}
		self.target = target
	end
	self:CopyPackedTemplate(src, target)

	if not self:ValidateTemplate(target) or target.class ~= PlayerClass then
		self.target = nil
		self.db.char.target = nil
	end
end

function Talented:InitializeOptions()
	self.db.profile.target = nil
	self:SetTemplateMode(false)
	do
		local dst = self.db.profile.templates
		local src = self.db.char.templates
		if src then
			for name, template in pairs(src) do
				if not dst[name] then
					dst[name] = template
					dst[name].class = PlayerClass
				end
			end
		end
		local src = self.db.class.templates
		if src then
			for name, template in pairs(src) do
				if not dst[name] then
					dst[name] = template
					dst[name].class = PlayerClass
				end
			end
		end
		self.db.char.templates = nil
		self.db.class.templates = nil
		for _, template in pairs(dst) do
			if not template.class then
				template.class = PlayerClass
			end
--			self:PackTemplate(template)
		end
	end
	
	for _, template in pairs(self.db.profile.templates) do
		self:AddTemplateToOptions(template)
	end
	self:RegisterChatCommand(L["CHAT_COMMANDS"], self.options.args.options)
end

function Talented:SetTemplateMode(mode, template)
	local b = self.base
	if mode then
		self.options.args.mode.args = self.template_mode_args
		if not template then
			local p = self.db.profile
			local t = p.last_template
			if t then
				template = p.templates[t]
			end
			if not template then
				template = next(self.templaterefs)
			end
		end
		self:SetTemplate(template or self:CreateEmptyTemplate(PlayerClass))
		if b then
			b.btemplate:Show()
			b.editname:Show()
		end
	else
		self.options.args.mode.args = self.normal_mode_args
		self:SetTemplate()
		if b then
			b.btemplate:Hide()
			b.editname:Hide()
		end
	end
	if b then
		local cb = b.checkbox
		cb.label:SetText(self.options.args.mode.args.edit.name)
		cb:SetChecked(self.mode == "edit")
	end
end

function Talented:IsTemplateMode()
	return self.options.args.mode.args == self.template_mode_args
end

function Talented:OnDisable()
	self:SetTemplateMode()
	self:UnhookInspectUI()
end

function Talented:GetMode()
	return self.mode
end

function Talented:ApplyCurrentTemplate()
	local template = self.template
	if template.class ~= PlayerClass then
		return
	end
	local count = 0
	-- check if enough talent points are available
	local available = UnitCharacterPoints("player")
	for tab, tree in ipairs(self:GetTalentInfo(PlayerClass)) do
		for index, info in ipairs(tree.talents) do
			local delta = template[tab][index] - self.current[tab][index]
			if delta > 0 then
				count = count + delta
			end
		end
	end
	if count > available then
		self:Print(L["Sorry, I can't apply this template because you don't have enough talent points available (need %d)!"], count)
		self.mode = "view"
		self:UpdateView()
	else
		-- let's go !
		self:Print(L["Please wait while I set your talents..."])
		self:EnableUI(false)
		self:CHARACTER_POINTS_CHANGED()
	end
end

function Talented:SetMode(mode)
	if self.template == self.current and mode ~= "edit" then
		mode = "view"
	end
	if self.mode ~= mode then
		self.mode = mode
		if mode == "apply" then
			self:ApplyCurrentTemplate()
		elseif mode == "delete" then
			self:DeleteCurrentTemplate()
		end
		self:UpdateView()
	end
	local cb = self.base and self.base.checkbox 
	if cb then
		cb:SetChecked(mode == "edit")
	end
end

function Talented:OnInitialize()
	self.templaterefs = {}
	self.mode = self.db.profile.default_mode
	self:SetCommPrefix("Talented")
	
	self:InitializeOptions()
end

function Talented:RemoveTemplateFromOptions(template)
	local key = self.templaterefs[template]
	if key then
		local a = self.options.args.template.args
		a[key] = nil
		a.new.args[key] = nil
		self.templaterefs[template] = nil
	end
end

function Talented:DeleteCurrentTemplate()
	local template = self.template
	if template == self.current then return end
	self:RemoveTemplateFromOptions(template)
	local templates = self.db.profile.templates
	templates[template.name] = nil
	template = next(templates)
	self:SetTemplateMode(template ~= nil, template)
end

function Talented:UpdateTemplateName(template, newname)
	if self.db.profile.templates[newname] or
			self.mode == "apply" or
			self.current == template then
		return
	end
	
	local oldname = template.name
	template.name = newname
	local t = self.db.profile.templates
	t[newname] = template
	t[oldname] = nil
	local key = self.templaterefs[template]
	if key then
		local colour = RAID_CLASS_COLORS[template.class]
		local tname = ("|cff%.2x%.2x%.2x%s|r"):format(colour.r*255, colour.g*255, colour.b*255, template.name)
		local a = self.options.args.template.args
		local i = a[key]
		i.name = tname
		i.desc = format(L["Select %s"], template.name)
		i = a.new.args[key]
		i.name = format(L["Copy from %s"], tname)
		i.desc = format(L["Create a new template from %s."], template.name)
	end
end

function Talented:AddTemplateToOptions(template)
	self.db.profile.templates[template.name] = template
	local count, opt, name = 1, self.options.args.template.args
	while true do
		name = format("template%d", count)
		if not opt[name] then break end
		count = count + 1
	end
	self.templaterefs[template] = name
	local colour = RAID_CLASS_COLORS[template.class]
	local tname = ("|cff%.2x%.2x%.2x%s|r"):format(colour.r*255, colour.g*255, colour.b*255, template.name)
	opt[name] = {
		name = tname,
		desc = format(L["Select %s"], template.name),
		type = "execute",
		order = 200,
		func = function () self:SetTemplate(template) end,
	}
	self.options.args.template.args.new.args[name] = {
		name = format(L["Copy from %s"], tname),
		desc = format(L["Create a new template from %s."], template.name),
		type = "execute",
		order = 200,
		func = function() self:SetTemplate(self:CopyTemplate(template)) end,
	}
end

do
	local function new(templates, name, class)
		local count = 0
		local template = {
			name = name,
			class = class
		}
		while templates[template.name] do
			count = count + 1
			template.name = format(L["%s (%d)"], name, count)
		end
		return template
	end
	
	local function copy(dst, src)
		dst.class = src.class
		if src.code then
			dst.code = src.code
			return
		else
			for tab, tree in ipairs(Talented:GetTalentInfo(src.class)) do
				local s, d = src[tab], {}
				dst[tab] = d
				for index in ipairs(tree.talents) do
					d[index] = s[index]
				end
			end
		end
	end
	
	function Talented:ImportFromOther(name, src)
		if not self:GetTalentInfo(src.class) then return end
		
		local dst = new(self.db.profile.templates, name, src.class)
		
		copy(dst, src)

		self:AddTemplateToOptions(dst)
		self:OpenTemplate(dst)

		return dst
	end
	
	function Talented:CopyTemplate(src)
		local dst = new(self.db.profile.templates, format(L["Copy of %s"], src.name), src.class)
		
		copy(dst, src)

		self:AddTemplateToOptions(dst)
		return dst
	end

	function Talented:CreateEmptyTemplate(class)
		if not class then class = PlayerClass end
		local template = new(self.db.profile.templates, L["Empty"], class)
		
		local info = self:GetTalentInfo(class)
		if not info then return end
		
		for tab, tree in ipairs(info) do
			local t = {}
			template[tab] = t
			for index in ipairs(tree.talents) do
				t[index] = 0
			end
		end

		self:AddTemplateToOptions(template)
		return template
	end

	function Talented:ImportTemplate(url)
		local dst, result = new(self.db.profile.templates, L["Imported"])
		if url:find(".*/.*/talents.html%?tal=%d+$") then
			result = self:ImportWowTemplate(url, dst)
		elseif url:find("/%?talent=") then 
			result = self:ImportWowheadTemplate(url, dst)
		elseif url:find("/talent.aspx%?") then
			result = self:ImportWowdbTemplate(url, dst)
		end
		if result then
			if not self:ValidateTemplate(dst) then
				self:Print(L["The given template is not a valid one! (%s)"], format("branch %d is invalid", tab))
			else
				self:AddTemplateToOptions(dst)
				return dst
			end
		else
			self:Print(L["\"%s\" does not appear to be a valid URL!"], url)
		end
	end
end

function Talented:OpenTemplate(template)
	local base = self:CreateBaseFrame()
	if not self.current then
		self:UpdateCurrentTemplate()
	end
	self:SetTemplateMode(true, template)
	if not base:IsVisible() then
		ShowUIPanel(base)
	end
end

function Talented:SetTemplate(template)
	if not template then template = self.current end
	local old = self.template
	if template ~= old then
		self:UnpackTemplate(template)
		if not self:CreateTalentMatrix(template.class) then
			assert(template ~= self.current)
			return self:SetTemplate() -- default to current
		end
		self:PackTemplate(old)
		self.template = template
	end
	if template and template ~= self.current then
		self.db.profile.last_template = template.name
	end
	self:SetMode(self.db.profile.default_mode)
	self:UpdateView()
end

function Talented:OnEnable()
	self:Hook("ToggleTalentFrame", true)
	self:SecureHook("UpdateTalentButton")
	self:RegisterComm("Talented", "WHISPER")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:CheckHookInspectUI()
end

function Talented:PLAYER_LOGOUT()
	self:SetTemplate()
end

function Talented:CHARACTER_POINTS_CHANGED()
	self:UpdateCurrentTemplate()
	self:UpdateView()
	if self.mode == "apply" then
		self:ApplyNextTalentPoint()
	end
end

function Talented:UpdateTalentButton()
	if self.db.profile.donthide and UnitLevel("player") < 10 then
		TalentMicroButton:Show()
		QuestLogMicroButton:SetPoint("BOTTOMLEFT", "TalentMicroButton", "BOTTOMRIGHT", -2, 0)
	end
end

function Talented:ToggleTalentFrame()
	local frame = self.base
	if not frame or not frame:IsVisible() then
		self:Update()
		ShowUIPanel(self.base)
	else
		HideUIPanel(frame)
	end
end

function Talented:Update()
	self:CreateBaseFrame()
	self:UpdateCurrentTemplate()
	if not self.template then
		self:SetTemplate(self.current)
	end
	self:UpdateView()
end
