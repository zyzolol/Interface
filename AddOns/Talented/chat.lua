local ipairs = ipairs
local pcall = pcall
local Prat = Prat
local Talented = Talented
local format = string.format

local L = AceLibrary("AceLocale-2.2"):new("Talented")

local function getChatWrite()
	local edit = DEFAULT_CHAT_FRAME.editBox
	local SendChatMessage = SendChatMessage
	local type = edit:GetAttribute("chatType")
	local lang = edit.language
	if type == "WHISPER" then
		local target = edit:GetAttribute("tellTarget")
		return function (text, ...)
			if text:find("%", 1, true) then text = text:format(...) end
			SendChatMessage(text, type, lang, target)
		end
	elseif type == "CHANNEL" then
		local channel = edit:GetAttribute("channelTarget")
		return function (text, ...)
			if text:find("%", 1, true) then text = text:format(...) end
			SendChatMessage(text, type, lang, channel)
		end
	else
		return function (text, ...)
			if text:find("%", 1, true) then text = text:format(...) end
			SendChatMessage(text, type, lang)
		end
	end
end

function Talented:ExportTemplateToChat()
	local write = getChatWrite()
	write(L["Talented - Template \"%s\" - %s :"], self.template.name, self.template.class)
	for tab, tree in ipairs(self:GetTalentInfo(self.template.class)) do
		local branchwritten = false
		for index, talent in ipairs(tree.talents) do
			local value = self.template[tab][index]
			if value > 0 then
				local ranks = talent.info.ranks
				if not branchwritten then
					write(L["%s :"], tree.info.name)
					branchwritten = true
				end
				if ranks == 1 then
					write(L["_ %s"], talent.info.name)
				else
					write(L["_ %s (%d/%d)"], talent.info.name, value, ranks)
				end
			end
		end
	end
end

function Talented:ExportTemplateURL(type)
	local write = getChatWrite()
	if type == "wowhead" then
		write(self:ExportWowheadTemplate(self.template))
	elseif type == "wowdb" then
		write(self:ExportWowdbTemplate(self.template))
	else
		write(self:ExportWowTemplate(self.template))
	end
end

if Prat then
	local PRAT_MODULE = "PratTalented"
	local Prat_Talented = Prat:NewModule(Prat:RequestModuleName(PRAT_MODULE), "AceHook-2.1")

	Prat_Talented.pratModuleName = PRAT_MODULE
	Prat_Talented.defaultDB = {
		on = true,
		colortemplate = true,
		color = { r = 0.1, g = 0.3, b = 1.0 },
	}

	Prat_Talented.moduleOptions = {
			name = "Talented",
			desc = L["Talented Links options."],
			type = "group",
			args = {
				colortemplate = {
					name = L["Color Template"],
					desc = L["Toggle the Template color on and off."],
					type = "toggle",
					order = 180,
					get = function() return Prat_Talented.db.profile.colortemplate end,
					set = function(v) Prat_Talented.db.profile.colortemplate = v end
				},
				setcolor = {
					name = L["Set Color"],
					desc = L["Change the color of the Template."],
					type = "color",
					order = 190,
					get = function() 
						local c = Prat_Talented.db.profile.color
						return c.r, c.g, c.b
					end,
					set = function(r, g, b, a)
						local c = Prat_Talented.db.profile.color
						c.r, c.g, c.b = r, g, b 
					end,
					disabled = function() return not Prat_Talented.db.profile.colortemplate end,
				},
			}
		}

	function Prat_Talented:GetModuleOptions()
		return self.moduleOptions
	end

	function Prat_Talented:TemplateLinkToChat(template)
		if not template then return end
		local code
		if template.code then
			code = template.code
		else
			local res, value = pcall(Talented.TemplateToString, Talented, template)
			if not res then return end
			code = value
		end
		self:InsertLink(UnitName("player"), template.name, code)
	end

	Prat_Talented.chat_options = {
		name = L["Write template link"],
		desc = L["Write a link to the current template in chat."],
		type = "execute",
		order = 230,
		func = function () Prat_Talented:TemplateLinkToChat(Talented.template) end,
	}

	function Prat_Talented:InsertLink(player, name, code)
		local link = format("{template:%s:%s:%s}", player, name:gsub(":", " "), code)
		ChatEdit_InsertLink(link)
	end

	if Talented.QueryTalents then	
		function Prat_Talented:QueryTalentSpec()			
			local dropdownFrame = _G[UIDROPDOWNMENU_INIT_MENU]
			
			local name = dropdownFrame.name
			local server = dropdownFrame.server
			
			local fullname
			
			if server and server:len() > 0 then
				fullname = name.."-"..server
			else
				fullname = name
			end   
		
			Talented:QueryTalents(fullname, true)
		end

		function Prat_Talented:UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData, ...)
			for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
				local button = _G["DropDownList"..UIDROPDOWNMENU_MENU_LEVEL.."Button"..i]
				
				if button.value == "TALENTEDLOOKUP" then 
					button.func = UnitPopupButtons["TALENTEDLOOKUP"].func
					break
				end
			end
		end
	end

	function Prat_Talented:OnModuleEnable()

		Talented.template_mode_args.chat = self.chat_options
		Talented.normal_mode_args.chat = self.chat_options

		Prat:RegisterLinkType({
			linkid = "template",
			linkfunc = self.Template_Link, 
			handler = self
		}, self.moduleName)

		Prat:RegisterPattern({
			pattern = "{template:(.-):(.-):(.-)}", 
			matchfunc = function(...) return self:MakeTemplateLink(...) end
		}, self.name)
		
		if self.QueryTalentSpec then 
			-- The generic button to use on the popup menus
			UnitPopupButtons["TALENTEDLOOKUP"] = {
				text = L["Query Talent Spec"],
				dist = 0 , 
				func = function() self:QueryTalentSpec() end,
				arg1 = "",
				arg2 = ""
			}
			
			-- Insert into the various menu's
			tinsert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"] - 1, "TALENTEDLOOKUP")    

			-- Hook to patch the handler functions in    
			self:SecureHook("UnitPopup_ShowMenu")
		end
	end

	function Prat_Talented:MakeTemplateLink(player, name, code)
		local link = format("|Htemplate:%s:%s:%s|h[Template %s - %s]|h", code, player, name, player, name)
		if self.db.profile.colortemplate then
			local c = self.db.profile.color
			link = format("|cff%02x%02x%02x%s|r", c.r*255, c.g*255, c.b*255, link)
		end
		return Prat:RegisterMatch(link)
	end

	function Prat_Talented:OnModuleDisable()
		Talented.options.args.mode.args.chat = nil

		Prat:UnregisterAllPatterns(self.name)
	end

	function Prat_Talented:Template_Link(link, text, button)
		local linktype, code, player, name = (":"):split(link)

		local res, val, class = pcall(Talented.StringToTemplate, Talented, code)
		if not res then return false end

		Talented:ImportFromOther(player, { name = name, code = code, class = class})

		return false
	end
end



