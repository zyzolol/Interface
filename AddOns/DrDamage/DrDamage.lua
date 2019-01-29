local _, playerClass = UnitClass("player")
local playerHealer = (playerClass == "PRIEST") or (playerClass == "SHAMAN") or (playerClass == "PALADIN") or (playerClass == "DRUID")
local playerCaster = (playerClass == "MAGE") or (playerClass == "PRIEST") or (playerClass == "WARLOCK")
local playerMelee = (playerClass == "ROGUE") or (playerClass == "WARRIOR") or (playerClass == "HUNTER")
local playerHybrid = (playerClass == "DRUID") or (playerClass == "PALADIN") or (playerClass == "SHAMAN")

--Libraries
local L = AceLibrary("AceLocale-2.2"):new("DrDamage")
local GT = LibStub:GetLibrary("LibGratuity-3.0")
local DrDamage = DrDamage

--General
local settings
local _G = getfenv(0)
local type = type
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local math_floor = math.floor
local math_min = math.min
local math_max = math.max
local string_match = string.match
local string_format = string.format
local string_find = string.find
local string_sub = string.sub
local string_gsub = string.gsub
local string_len = string.len
local select = select

--Module
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local UnitMana = UnitMana
local UnitLevel = UnitLevel
local UnitDamage = UnitDamage
local UnitPowerType = UnitPowerType
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local GetSpellName = GetSpellName
local GetSpellInfo = GetSpellInfo
local GetMacroSpell = GetMacroSpell
local GetActionInfo = GetActionInfo
local GetCursorInfo = GetCursorInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetInventorySlotInfo = GetInventorySlotInfo
local GetItemInfo = GetItemInfo
local GetItemGem = GetItemGem
local GetTime = GetTime
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local HasAction = HasAction
local IsEquippedItem = IsEquippedItem
local SecureButton_GetModifiedAttribute = SecureButton_GetModifiedAttribute
local SecureStateChild_GetEffectiveButton = SecureStateChild_GetEffectiveButton
local ActionButton_GetPagedID = ActionButton_GetPagedID

--Module variables
local spellInfo
local playerCompatible
local updatingSpell, updateSetItems
local dmgMod
local loadedTalents
local DrD_Font = GameFontNormal:GetFont()
DrDamage.visualChange = true

--Local functions
local function DrD_ClearTable( table )
	for k in pairs( table ) do
		table[k] = nil
	end
end

local function DrD_Round(x, y)
	return math_floor( x * 10 ^ y + 0.5 ) / 10 ^ y
end

local function DrD_MatchData( data, ... )
	if not data or not ... then
		return false
	end

	if type( data ) == "table" then
		for _, dataName in ipairs( data ) do
			for i = 1, select('#', ...) do
				if dataName == select(i, ...) then
					return true
				end
			end
		end
	else	
		for i = 1, select('#', ...) do
			if data == select(i, ...) then
				return true
			end
		end
	end
	
	return false
end

local function DrD_Set( n, set, change )
	return function(v) 
		settings[n] = v
		if change then
			DrDamage.visualChange = true
		end
		if not set and not DrDamage:IsEventScheduled("DrD_FullUpdate") then
			DrDamage:CancelSpellUpdate()
			DrDamage:ScheduleEvent("DrD_FullUpdate", DrDamage.UpdateAB, 1.0, DrDamage)
		end
	end
end

local ABstop, ABdefault, ABtable, ABgetID, ABglobalbutton, ABglobalbutton2, ABdisable, ABfunc, ABhidden
local defaultBars = { "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton" }
local function DrD_DetermineAB()
	--Default
	ABgetID = function( button ) return SecureButton_GetModifiedAttribute(button,"action",SecureStateChild_GetEffectiveButton(button)) end
	
	if IsAddOnLoaded("Bartender3") then
		ABglobalbutton = "BT3Button"
		ABtable = Bartender3.actionbuttons
		ABgetID = function( button, index, ABtable )
					if ABtable[index] and ABtable[index].state == "used" then
						return ABtable[index].object:PagedID()
					end
		end
	elseif IsAddOnLoaded("Bartender4") then
		ABglobalbutton = "BT4Button"
		ABgetID = function( button ) return button.Secure:GetActionID() end
	elseif IsAddOnLoaded( "Bongos2" ) then
		ABglobalbutton = "BongosActionButton"
		ABgetID = function(button) return button:GetPagedID() end
	elseif IsAddOnLoaded( "Bongos" ) then
		ABglobalbutton = "Bongos3ActionButton"
		ABgetID = function(button) return button:GetPagedID() end
	elseif IsAddOnLoaded( "CogsBar" ) then
		ABglobalbutton = "CogsBarButton"
	elseif IsAddOnLoaded("TrinityBars") then
		ABglobalbutton = "TrinityActionButton"
		ABgetID = function( button )
			return SecureButton_GetModifiedAttribute(button,"action",SecureStateChild_GetEffectiveButton(button))
		end
	elseif IsAddOnLoaded("TrinityBars2") then
		ABglobalbutton = "TrinityActionButton"
		ABgetID = function( button )
			if (button.config.type == "spell") then
				return nil, button.config.spell, tonumber(button.config.spellrank)
			else
				return SecureButton_GetModifiedAttribute(button,"action",SecureStateChild_GetEffectiveButton(button))
			end
		end
	elseif IsAddOnLoaded("Dominos") then
		ABglobalbutton = "DominosActionButton"
		settings.BlizzardAB = true
	elseif IsAddOnLoaded("Poppins") then
		ABglobalbutton = "PoppinsPopButton"
		ABglobalbutton2 = "PoppinsFrame%dButton"
		ABhidden = true
		ABgetID = function(button)
			local spell = SecureButton_GetModifiedAttribute(button,"spell",SecureStateChild_GetEffectiveButton(button))
			if spell then return nil, GetSpellName(spell) end
		end
		settings.BlizzardAB = true
	elseif IsAddOnLoaded("idActionbar") then
		ABglobalbutton = "idButton"
	elseif IsAddOnLoaded("IPopBar") then
		ABglobalbutton = "IPopBarButton"
		settings.BlizzardAB = true
	elseif IsAddOnLoaded( "InfiniBar" ) then
		ABstop = true
		ABgetID = nil
	elseif IsAddOnLoaded( "FlexBar2" ) then
		ABstop = true
		ABgetID = nil
		ABfunc = function()
				for _, button in pairs(FlexBar2.Buttons) do
					button:UpdateTextSub("drd")
				end
			end
	elseif IsAddOnLoaded("DiscordActionBars") then
		ABglobalbutton = "DAB_ActionButton_"
		ABgetID = function( button ) return button:GetActionID() end
	elseif IsAddOnLoaded("Nurfed") then
		ABglobalbutton = "Nurfed_Button"
		ABgetID = function( button )
				if button.spell then
					if button.type == "spell" then
						local pid = Nurfed:getspell(button.spell)
						if pid then
							return nil, GetSpellName(pid, BOOKTYPE_SPELL)
						end
					elseif button.type == "macro" then
						local action, rank = GetMacroSpell(button.spell)
						if action then 							
							return nil, action, rank
						end
					end
				end
		end	
	elseif IsAddOnLoaded("CT_BarMod") then
		ABtable = CT_BarMod.actionButtonList
		ABgetID = function( button, index, ABtable )
			if ABtable[index] and ABtable[index].hasAction then return index end
		end
		settings.BlizzardAB = true
	else
		ABdefault = true
		ABgetID = nil
	end
end

--Defaults
local defaults = DrDamage.defaults
defaults.ABText = true
defaults.FontEffect = "OUTLINE"
defaults.FontSize = 10
defaults.FontXPosition = 0
defaults.FontYPosition = 0
defaults.FontColorDmg = { r = 1, g = 1, b = 0.2 }
defaults.FontColorHeal = { r = 0.4, g = 1.0, b = 0.3 }
defaults.UpdateShift = false
defaults.UpdateAlt = false
defaults.UpdateCtrl = false
defaults.BlizzardAB = false
defaults.AlwaysTooltip = true
defaults.NeverTooltip = false
defaults.AltTooltip = false
defaults.CtrlTooltip = false
defaults.ShiftTooltip = false
defaults.DefaultColor = false
defaults.SwapCalc = false
defaults.PlayerAura = {}
defaults.TargetAura = {}
defaults.Consumables = {}
DrDamage:RegisterDB("DrDamageDB");
DrDamage:RegisterDefaults("profile", defaults)

--FuBar options
DrDamage.name = "DrDamage"
DrDamage.title = "Dr. Damage"
DrDamage.hasNoColor = true
DrDamage.hasNoText = true
DrDamage.cannotDetachTooltip = true
DrDamage.hideWithoutStandby = true
DrDamage.independentProfile = true
DrDamage.blizzardTooltip = true
DrDamage.hasIcon = playerMelee and "Interface\\Icons\\Ability_DualWield" or "Interface\\Icons\\Spell_Holy_SearingLightPriest"

function DrDamage:OnTooltipUpdate()
	GameTooltip:AddLine( "          Dr. Damage" )
	GameTooltip:AddLine( "Hint: Right-Click for options", 0, 1, 0, true )
end

function DrDamage:OnInitialize()
	settings = self.db.profile	

	self.options = { type='group', args = {} }
	self:RegisterChatCommand({ "/drdmg", "/drdamage" }, self.options)
	self.OnMenuRequest = self.options		

	if IsAddOnLoaded( "InfiniBar" ) then
		InfiniBar:RegisterTextSub("drd", "DrDamage_Update",
		function(bar, btn, options, spell)
			if not playerCompatible then return false end
			if not settings.ABText then return "" end
			local name, rank = bar:GetSpellNameAndRank( btn )
			if name and rank then
				if not spell or DrD_MatchData( spell, name ) then
					return self:CheckAction( nil, nil, nil, name, rank )
				end
			end
			return false
		end)
	end
end

function DrDamage:OnEnable()
	if IsAddOnLoaded("FlexBar2") and FlexBar2:HasModule("TextSubs") then
		FlexBar2:GetModule("TextSubs"):RegisterTextSub("drd", 
		function(button)
			if not playerCompatible then return false end
			if not settings.ABText then return "" end
			local spell = button:GetModifiedAttribute("spell");
			if(spell and spell ~= "") then
				-- Run the spell through GetSpellName to seperate Name & Rank and get the rank if its not specified
				local name, rank = GetSpellName(spell)
				return self:CheckAction(nil, nil, nil, name, rank)
			end
		end)		
	end

	if self.PlayerData then
		self.ClassSpecials = {}
		self.Calculation = {}
		self.DmgCalculation = {}
		self.FinalCalculation = {}
		self.SetBonuses = {}
		self.RelicSlot = {}
		self.talents = {}
		self:PlayerData()
		self.PlayerData = nil
		spellInfo = self.spellInfo
	elseif not self.spellInfo and not self.talentInfo then
		return
	end
	
	self:OnProfileEnable()
	
	if self.GeneralOptions then
		self:GeneralOptions()
		self.GeneralOptions = nil
	end
	
	dmgMod = select(7, UnitDamage("player"))
	
    	self:RegisterEvent("AceDB20_ResetDB")
    	self:RegisterEvent("AceEvent_FullyInitialized")
  	
  	if AceLibrary("AceEvent-2.0"):IsFullyInitialized() then
  		self:AceEvent_FullyInitialized()
  	end
end

function DrDamage:AceEvent_FullyInitialized()
	if self.Caster_OnEnable then
		self:Caster_OnEnable()
		self.Caster_OnEnable = nil
	end
	if self.Melee_OnEnable then
		self:Melee_OnEnable()
		self.Melee_OnEnable = nil
	end
	if DrD_DetermineAB then 
		DrD_DetermineAB()
		DrD_DetermineAB = nil
	end
	if self.Caster_InventoryChanged then
		self:Caster_InventoryChanged()
	end
	if self.Melee_InventoryChanged then
		self:Melee_InventoryChanged()
	end
	
	self:MetaGems(true)
	playerCompatible = true
	
	if not loadedTalents then
    		self:UpdateTalents()
    	else
    		self:UpdateAB()
    	end
	
	self:Hook(GameTooltip, "SetAction", true)
	self:SecureHook(GameTooltip, "SetSpell")   	
   	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
    	self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	
	if settings.ABText then
		if settings.UpdateAlt or settings.UpdateCtrl or settings.UpdateShift then
			self:RegisterEvent( "MODIFIER_STATE_CHANGED" )
		end
    		self:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    		self:RegisterEvent("ACTIONBAR_HIDEGRID")
    		self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    		self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    		self:RegisterEvent("PLAYER_TARGET_CHANGED")
    		self:RegisterEvent("UPDATE_MACROS")
    		self:RegisterEvent("LEARNED_SPELL_IN_TAB")
		self:RegisterEvent("PLAYER_AURAS_CHANGED", "PlayerAuraUpdate")
		self:RegisterEvent("UNIT_AURA", "TargetAuraUpdate")
    	end
end

function DrDamage:OnDisable()
	if playerCompatible then
		local tempType = settings.ABText
		settings.ABText = false
		self:UpdateAB()
		settings.ABText = tempType
	end	
end

function DrDamage:OnProfileEnable()
	if self.Caster_OnProfileEnable then self:Caster_OnProfileEnable() end
	if self.Melee_OnProfileEnable then self:Melee_OnProfileEnable() end
	settings = self.db.profile
end

function DrDamage:GeneralOptions()
	self.options.args.General = {
		type = "group", 
		desc = L["General Options"], 
		name = L["General"],
		order = 1,
		args = {
			ABText = {
				type = 'toggle',
				name = L["Actionbar text on/off"],
				desc = L["Toggles the actionbar text on/off"],
				order = 10,
				get = function() return settings["ABText"] end,
				set = DrD_Set("ABText"),
			},
			BlizzardAB = {
				type = 'toggle',
				name = L["Support for Blizzard AB even with other AB addons running."],
				desc = L["Toggles updating on for the default actionbar."],
				order = 20,
				get =  function() return settings["BlizzardAB"] end,
				set =  DrD_Set("BlizzardAB"),				
			},			
			FontSize = {
				type = 'range',
				name = L["Actionbar font size"],
				desc = L["Set the font size"],
				min = 6,
				max = 20,
				step = 1,
				order = 30,
				get =  function() return settings["FontSize"] end,
				set = DrD_Set("FontSize", false, true),
			},
			FontEffect = {
				type = "text",
				name = L["Actionbar font effect"],
				desc = L["Set the font effect"],
				validate = { L["Outline"], L["ThickOutline"], L["None"] },
				order = 40,
				get =	function()
	
						if settings.FontEffect == "" then
							return L["None"]
						elseif settings.FontEffect == "THICKOUTLINE" then
							return L["ThickOutline"]
						else
							return L["Outline"]
						end
					end,
				set = 	function(v)
						if v == L["None"] then
							settings.FontEffect = ""
						elseif v == L["ThickOutline"] then
							settings.FontEffect = "THICKOUTLINE"
						else
							settings.FontEffect = "OUTLINE"
						end

						self.visualChange = true
						self:UpdateAB()
					end,
			},				
			FontXPosition = {
				type = 'range',
				name = L["Actionbar font horizontal position"],
				desc = L["Set the font horizontal position"],
				min = -5,
				max = 5,
				step = 1,
				order = 50,
				get =  function() return settings["FontXPosition"] end,
				set = 	DrD_Set("FontXPosition", false, true),
			},
			FontYPosition = {
				type = 'range',
				name = L["Actionbar font vertical position"],
				desc = L["Set the font vertical position"],
				min = -15,
				max = 30,
				step = 1,
				order = 60,
				get =  function() return settings["FontYPosition"] end,
				set = 	DrD_Set("FontYPosition", false, true),
			},
			FontColorDmg = {
				type = "text",
				name = L["Damage text color"],
				desc = L["Set the actionbar damage text color"],
				usage = L["<r=n, g=n, b=n> where n is 0-1"],
				order = 70,
				get = function()
					return "r="..settings.FontColorDmg.r..", g="..settings.FontColorDmg.g..", b="..settings.FontColorDmg.b
				end,
				set = function(colors)
					for k, v in string.gmatch(string.lower(colors), "([r|g|b])=([%d\.]+)") do
						if tonumber(v) >= 0 and tonumber(v) <= 1 then
							settings.FontColorDmg[k] = v
						end
					end
					self.visualChange = true
					self:UpdateAB()						
				end
			},
			Update = {
				type = 'group', 
				name = L["Update"],
				desc = L["Update"],
				order = 90,
				args = {
					Update = {
						name = L["Update"],
						desc = L["Forces update to actionbar"],
						type = "execute",
						order = 1,
						func = function() self.visualChange = true, self:UpdateAB() end,
					},
					UpdateShift = {
						type = 'toggle',
						name = L["Updates actionbars on shift modifier key."],

						desc = L["Toggles updates on modifier key on/off."],
						order = 2,
						get =  function() return settings["UpdateShift"] end,
						set =  function(v)
								settings["UpdateShift"] = v
								if v then
									if not self:IsEventRegistered("MODIFIER_STATE_CHANGED") then
										self:RegisterEvent("MODIFIER_STATE_CHANGED")
									end
								elseif not settings.UpdateAlt and not settings.UpdateCtrl then
									self:UnregisterEvent("MODIFIER_STATE_CHANGED")
								end
							end,				
					},
					UpdateAlt = {
						type = 'toggle',
						name = L["Updates actionbars on alt modifier key."],
						desc = L["Toggles updates on modifier key on/off."],
						order = 3,
						get =  function() return settings["UpdateAlt"] end,
						set =  function(v)
								settings["UpdateAlt"] = v
								if v then
									if not self:IsEventRegistered("MODIFIER_STATE_CHANGED") then
										self:RegisterEvent("MODIFIER_STATE_CHANGED")
									end
								elseif not settings.UpdateCtrl and not settings.UpdateShift then
									self:UnregisterEvent("MODIFIER_STATE_CHANGED")
								end
							end,				
					}, 
					UpdateCtrl = {
						type = 'toggle',
						name = L["Updates actionbars on ctrl modifier key."],
						desc = L["Toggles updates on modifier key on/off."],
						order = 4,
						get =  function() return settings["UpdateCtrl"] end,
						set =  function(v)
								settings["UpdateCtrl"] = v
								if v then
									if not self:IsEventRegistered("MODIFIER_STATE_CHANGED") then
										self:RegisterEvent("MODIFIER_STATE_CHANGED")
									end
								elseif not settings.UpdateAlt and not settings.UpdateShift then
									self:UnregisterEvent("MODIFIER_STATE_CHANGED")
								end
							end,				
					},
				},
			},
			DisplayTooltip = {
				type = 'group',
				name = L["Display tooltip"],
				desc = L["Control when the tooltip is displayed"],
				order = 100,
				args = {
					Always = {
						type = 'toggle',
						name = L["Always"],
						desc = L["Always display the tooltip"],
						order = 1,
						get = function() return settings["AlwaysTooltip"] end,
						set = function(v)
							settings.AlwaysTooltip = v
							settings.NeverTooltip = not v
							settings.ShiftTooltip = false
							settings.CtrlTooltip = false
							settings.AltTooltip = false
	
						end,
					},
					Never = {
						type = 'toggle',
						name = L["Never"],
						desc = L["Never display the tooltip"],
						order = 2,
						get = function() return settings["NeverTooltip"] end,
						set = function(v)
							settings.AlwaysTooltip = not v
							settings.NeverTooltip = v
							settings.ShiftTooltip = false
							settings.CtrlTooltip = false
							settings.AltTooltip = false
						end,
					},
					Alt = {
						type = 'toggle',
						name = L["With Alt"],
						desc = L["Display tooltip when Alt is pressed"],
						order = 3,
						get = function() return settings["AltTooltip"] end,
						set = function(v)
							settings.NeverTooltip = false
							settings.AltTooltip = v
							if v then
								settings.AlwaysTooltip = false
							elseif not settings.CtrlTooltip and not settings.ShiftTooltip then
								settings.AlwaysTooltip = true
							end
						end,
					},
					Ctrl = {
						type = 'toggle',
						name = L["With Ctrl"],
						desc = L["Display tooltip when Ctrl is pressed"],
						order = 4,
						get = function() return settings["CtrlTooltip"] end,
						set = function(v)
							settings.NeverTooltip = false
							settings.CtrlTooltip = v
							if v then
								settings.AlwaysTooltip = false
							elseif not settings.AltTooltip and not settings.ShiftTooltip then
								settings.AlwaysTooltip = true
							end
						end,
					},
					Shift = {
						type = 'toggle',
						name = L["With Shift"],
						desc = L["Display tooltip when Shift is pressed"],
						order = 5,
						get = function() return settings["ShiftTooltip"] end,
						set = function(v)
							settings.NeverTooltip = false
							settings.ShiftTooltip = v
							if v then
								settings.AlwaysTooltip = false
							elseif not settings.CtrlTooltip and not settings.AltTooltip then
								settings.AlwaysTooltip = true
							end
						end,
					},
				},
			},
			DefaultColor = {
				type = 'toggle',
				name = L["Default tooltip colors"],
				desc = L["Toggles the default blizzard tooltip colors on/off"],
				order = 110,
				get = function() return settings["DefaultColor"] end,
				set = DrD_Set("DefaultColor", true),
			},
			SwapCalc = {
				type = 'toggle',
				name = L["Swap calculation for double purpose abilities"],
				desc = L["Toggles between the two calculations for abilities."],
				order = 120,
				get = function() return settings["SwapCalc"] end,
				set = DrD_Set("SwapCalc", false, true),
			},
			Aura = {
				type = 'group',
				name = L["Modify Buffs/Debuffs"],
				desc = L["Choose what buffs/debuffs to always include into calculations. Abilities will mostly NOT double stack if buff/debuff is really applied."],
				order = 170,
				args = {
					Player = {
						type = 'group',
						name = L["Player"],
						desc = L["Choose player buffs/debuffs."],
						args = {},
						},
					Target = {
						type = 'group',
						name = L["Target"],
						desc = L["Choose target buffs/debuffs."],
						args = {},
						},
					Consumables = {
						type = 'group',
						name = L["Consumables"],
						desc = L["Choose consumables to include."],
						args = {},
						},
				},
			},			
		},
	}
	local optionsTable = self.options.args.General.args
	local auraTable = optionsTable.Aura.args.Player.args
	for k,v in pairs( self.PlayerAura ) do
		if not v.ModType or v.ModType ~= "Update" then
			auraTable[(string_gsub(k," +", ""))] = {
				type = 'toggle',
				name = k,
				desc = L["Include "] .. k,
				get = function() return settings["PlayerAura"][k] end,
				set = function(v) settings["PlayerAura"][k] = v or nil; self:UpdateAB() end,
			}
		end
	end
	auraTable = optionsTable.Aura.args.Target.args
	for k,v in pairs( self.TargetAura ) do
		if not v.ModType or v.ModType ~= "Update" then
			auraTable[(string_gsub(k," +", ""))] = {
				type = 'toggle',
				name = k,
				desc = L["Include "] .. k,
				get = function() return settings["TargetAura"][k] end,
				set = function(v) settings["TargetAura"][k] = v or nil; self:UpdateAB() end,
			}
		end
	end
	auraTable = optionsTable.Aura.args.Consumables.args
	for k,v in pairs( self.Consumables ) do
		auraTable[(string_gsub(k," +", ""))] = {
			type = 'toggle',
			name = k,
			desc = L["Include "] .. k,
			get = function() return settings["Consumables"][k] end,
			set = function(v) settings["Consumables"][k] = v or nil; self:UpdateAB() end,
		}
	end	
	if playerHealer then
		optionsTable.FontColorHeal = {
			type = "text",
			name = L["Heal text color"],
			desc = L["Set the actionbar heal text color"],
			usage = L["<r=n, g=n, b=n> where n is 0-1"],
			order = 80,
			get = function()
				return "r="..settings.FontColorHeal.r..", g="..settings.FontColorHeal.g..", b="..settings.FontColorHeal.b
			end,
			set = function(colors)
				for k, v in string.gmatch(string.lower(colors), "([r|g|b])=([%d\.]+)") do
					if tonumber(v) >= 0 and tonumber(v) <= 1 then
						settings.FontColorHeal[k] = v
					end
				end
				self.visualChange = true 
				self:UpdateAB()
			end
		}
	end
end

--EVENTS:
function DrDamage:CancelSpellUpdate()
	updatingSpell = nil
	self:CancelScheduledEvent("DrD_SpellUpdate")
end

--REQUIRES DELAY:
function DrDamage:ACTIONBAR_PAGE_CHANGED()
	self.visualChange = true
	if not self:IsEventScheduled("DrD_FullUpdate") then
		self:CancelSpellUpdate()
		self:ScheduleEvent("DrD_FullUpdate", self.UpdateAB, 0.2, self)
	end
end

function DrDamage:ACTIONBAR_HIDEGRID()
	self.visualChange = true
	if not self:IsEventScheduled("DrD_FullUpdate") and (GetCursorInfo() == "spell" or GetCursorInfo() == "macro") then
		self:CancelSpellUpdate()
		self:ScheduleEvent("DrD_FullUpdate", self.UpdateAB, 0.2, self)
	end
end

function DrDamage:UPDATE_SHAPESHIFT_FORM()
	self.visualChange = true
	if not self:IsEventScheduled("DrD_FullUpdate") then
		self:CancelSpellUpdate()
		self:ScheduleEvent("DrD_FullUpdate", self.UpdateAB, 0.5, self)
	end
end

--INSTANT SLOT UPDATE
function DrDamage:ACTIONBAR_SLOT_CHANGED(id)
	local gtype, pid = GetActionInfo(id)
	if gtype == "macro" then
		local name = GetMacroSpell(pid)
		if name and spellInfo[name] then
			self.visualChange = true
			if not self:IsEventScheduled("DrD_FullUpdate") then
				self:UpdateAB(nil, id)
			end
		end
	end
end

--INSTANT FULL UPDATES
function DrDamage:CHARACTER_POINTS_CHANGED()
    	self:UpdateTalents()
end

function DrDamage:AceDB20_ResetDB( name, dab )
	if dab == self.db.name then
		self.visualChange = true
		self:UpdateAB()
	end
end

function DrDamage:UPDATE_MACROS()
	self:CancelScheduledEvent("DrD_FullUpdate")
	self.visualChange = true
	self:UpdateAB()
end

function DrDamage:PLAYER_COMBO_POINTS()
	if settings.ComboPoints_M == 0 then
		self:CancelScheduledEvent("DrD_FullUpdate")
		self:UpdateAB()
	end
end

function DrDamage:UNIT_INVENTORY_CHANGED( unit )
	if UnitIsUnit(unit,"player") then
		if self.Caster_InventoryChanged and self:Caster_InventoryChanged() then
			updateSetItems = true
			self:CancelScheduledEvent("DrD_FullUpdate")
			self:UpdateAB()
			self:ScheduleEvent("DrDamage_UpdateMetaGem", self.MetaGems, 0.5, self)
			return
		end
		if self.Melee_InventoryChanged and self:Melee_InventoryChanged() then
			updateSetItems = true
			self:CancelScheduledEvent("DrD_FullUpdate")
			self:UpdateAB()
			self:ScheduleEvent("DrDamage_UpdateMetaGem", self.MetaGems, 0.5, self)
			return
		end
	end
end

DrDamage.Melee_critMBonus = 0
DrDamage.Caster_critMBonus = 0

function DrDamage:MetaGems( initial )
	local oldactive, newactive
	
	if self.Melee_critMBonus ~= 0 or self.Caster_critMBonus ~= 0 then
		self.Melee_critMBonus = 0
		self.Caster_critMBonus = 0
		oldactive = true
	end

	local helm = GetInventoryItemLink("player", 1)
	if helm then
		for i = 1, 3 do 
			local mgem = string_match(select(2, GetItemGem(helm, i)) or "",".-item:(%d+).*")
			if tonumber(mgem) == 34220 then
				if not self:IsMetaGemInactive() then
					self.Caster_critMBonus = 0.03
					newactive = true
				end
				break
			elseif tonumber(mgem) == 32409 then
				if not self:IsMetaGemInactive() then
					self.Melee_critMBonus = 0.03
					newactive = true
				end
				break
			end
		end
	end
	if not initial and newactive ~= oldactive then
		self:CancelScheduledEvent("DrD_FullUpdate")
		self:UpdateAB()
	end
end

function DrDamage:IsMetaGemInactive()
	GT:SetInventoryItem("player", 1)
	for j = 1, GT:NumLines() do 
		if GT:GetLine(j) and string_find(GT:GetLine(j), "|cff808080.*808080") then
			return true
		end
	end
end

--DELAY FOR EFFICIENCY
function DrDamage:LEARNED_SPELL_IN_TAB()
	if not self:IsEventScheduled("DrD_FullUpdate") then
		self:CancelSpellUpdate()
		self:ScheduleEvent("DrD_FullUpdate", self.UpdateAB, 1, self)
	end
end

function DrDamage:PLAYER_TARGET_CHANGED()
	if not self:IsEventScheduled("DrD_FullUpdate") then
		self:CancelSpellUpdate()
		self:ScheduleEvent("DrD_FullUpdate", self.UpdateAB, 1.5, self)
	end
	self:TargetAuraUpdate("target",true)
end

local PlayerAura = DrDamage.PlayerAura
local TargetAura = DrDamage.TargetAura
local oPlayerAura = {}
local nPlayerAura = {}
local oTargetAura = {}
local nTargetAura = {}

function DrDamage:PlayerAuraUpdate()
	if self:IsEventScheduled("DrD_FullUpdate") then
		return
	end	
	if dmgMod ~= select(7, UnitDamage("player")) then
		dmgMod = select(7, UnitDamage("player"))
		self:UpdateAB()
		return
	end
	if self.Caster_CheckBaseStats and self:Caster_CheckBaseStats() then
		self:UpdateAB()
		return
	end
	if self.Melee_CheckBaseStats and self:Melee_CheckBaseStats() then
		self:UpdateAB()
		return
	end
	for i=1,40 do
		local name, rank, texture, count = UnitBuff("player",i)
		if name then
			if PlayerAura[name] then			
				nPlayerAura[name] = (rank or "") .. (count or "")
			end
		else
			break
		end
	end
	for i=1,40 do
		local name, rank, texture, count = UnitDebuff("player",i)
		if name then
			if PlayerAura[name] then
				nPlayerAura[name] = (rank or "") .. (count or "")
			end
		else 
			break
		end
	end
	local buffName, multi
	--Buff/debuff gained or count/rank changed
	for k,v in pairs(nPlayerAura) do
		if not oPlayerAura[k] then
			multi = buffName
			buffName = k
		elseif 	oPlayerAura[k] ~= v then
			multi = buffName
			buffName = k
		end
	end	
	--Buff/debuff lost
	for k,v in pairs(oPlayerAura) do
		if not nPlayerAura[k] then
			multi = buffName
			buffName = k
		end
		oPlayerAura[k] = nil
	end
	--Copy new table to old and clear
	for k,v in pairs(nPlayerAura) do
		oPlayerAura[k] = v
		nPlayerAura[k] = nil
	end
	if buffName then
		local updateSpell = not multi and PlayerAura[buffName].Spell
		
		if updatingSpell and updatingSpell == updateSpell then
			return
		end
		if updateSpell then
			updatingSpell = updateSpell
			self:ScheduleEvent("DrD_SpellUpdate", self.UpdateAB, 0.5, self, updateSpell)
		else
			self:CancelSpellUpdate()
			self:ScheduleEvent("DrD_FullUpdate", self.UpdateAB, 0.5, self)
		end
	end	
end


function DrDamage:TargetAuraUpdate( unitID, changed )
	if unitID == "target" then
		if self:IsEventScheduled("DrD_FullUpdate") and not changed then
			return
		end
		if playerHealer then
			for i=1,40 do
				local name, rank, texture, count = UnitBuff("target",i)
				if name then
					if TargetAura[name] then			
						nTargetAura[name.."|"..texture] = (rank or "") .. (count or "")
					end
				else
					break
				end
			end
		end
		for i=1,40 do
			local name, rank, texture, count = UnitDebuff("target",i)
			if name then
				if TargetAura[name] then
					nTargetAura[name.."|"..texture] = (rank or "") .. (count or "")
				end
			else 
				break
			end
		end
		local buffName, multi
		--Buff/debuff gained or count/rank changed
		for k,v in pairs(nTargetAura) do
			if not oTargetAura[k] then
				multi = buffName
				buffName = string_match(k,"[%w%s]+")
			elseif 	oTargetAura[k] ~= v then
				multi = buffName
				buffName = string_match(k,"[%w%s]+")
			end
		end	
		--Buff/debuff lost
		for k,v in pairs(oTargetAura) do
			if not nTargetAura[k] then
				multi = buffName
				buffName = string_match(k,"[%w%s]+")
			end
			oTargetAura[k] = nil
		end
		--Copy new table to old and clear
		for k,v in pairs(nTargetAura) do
			oTargetAura[k] = v
			nTargetAura[k] = nil
		end		
		if TargetAura[buffName] and not changed then
			local updateSpell = not multi and TargetAura[buffName].Spell
			
			if updatingSpell and updatingSpell == updateSpell then
				return
			end
			if updateSpell then
				updatingSpell = updateSpell
				self:ScheduleEvent("DrD_SpellUpdate", self.UpdateAB, 0.8, self, updateSpell )				
			else
				self:CancelSpellUpdate()
				self:ScheduleEvent("DrD_FullUpdate", self.UpdateAB, 1.0, self)
			end
		end
	end
end

local lastState = GetTime()
function DrDamage:MODIFIER_STATE_CHANGED( state )
	if (state == "LALT" or state == "RALT") and settings.UpdateAlt or (state == "LCTRL" or state == "RCTRL") and settings.UpdateCtrl or (state == "LSHIFT" or state == "RSHIFT") and settings.UpdateShift then
		if GetTime() - lastState < 0.3 then
			if self:IsEventScheduled("Modifier_UpdatingAB") then
				self:CancelScheduledEvent( "Modifier_UpdatingAB" )
				self.visualChange = false
			end
		else
			if not self:IsEventScheduled("Modifier_UpdatingAB") then
				self:ScheduleEvent("Modifier_UpdatingAB", self.UpdateAB, 0.3, self)
			end
			self.visualChange = true
		end
		lastState = GetTime()
	end
end

function DrDamage:UpdateTalents()
	DrD_ClearTable( self.talents )
	
	local talentTable
	
	if not loadedTalents then
		self.options.args.General.args.Talents = { type = "group", name = L["Modify Talents"], desc = L["Modify talents manually. Modified talents are not saved between sessions."], order = 160, args = {} }
		talentTable = self.options.args.General.args.Talents.args
		talentTable.Reset = { type = "execute", name = L["Reset Talents"], desc = L["Reset talents to your current talent configuration."], order = 1, func = function() self:UpdateTalents() end }
		loadedTalents = true
	end

	for t = 1, GetNumTalentTabs() do	
		for i = 1, GetNumTalents(t) do
			local talentName, _, _, _, currRank, maxRank = GetTalentInfo(t, i)
			
			if talentTable and self.talentInfo[talentName] and not self.talentInfo[talentName].NoManual then
				talentTable[(string_gsub(talentName," +", ""))] = {
						type = 'range',
						name = talentName,
						desc = L["Modify "] .. talentName,
						min = 0,
						max = maxRank,
						step = 1,
						order = i + (t-1) * 35,
						get =  function() 
								if self.talents[talentName] then
									return self.talents[talentName]
								else
									return 0
								end
							end,
						set = 	function(v) 
								self.talents[talentName] = math_floor(v+0.5)
								self:UpdateAB()
							end,
				}
			end
			if currRank ~= 0 and self.talentInfo[talentName] then
				self.talents[talentName] = currRank
			end	    	    
		end
	end
	self:UpdateAB()
end

local SetItems = {}
function DrDamage:GetSetAmount(set)
	if not updateSetItems and SetItems[set] then
		return SetItems[set]
	end
	
	if updateSetItems then
		DrD_ClearTable( SetItems )
		updateSetItems = false
	end
	
	local amount = 0
	local setData = self.SetBonuses[set]
	if setData then
		for _, itemID in ipairs(setData) do
			if IsEquippedItem(itemID) then
				amount = amount + 1
			end
		end
	end
	SetItems[set] = amount
	return amount
end

function DrDamage:SetSpell( frame, slot )
	if settings.NeverTooltip or (not settings.AlwaysTooltip and not (settings.AltTooltip and IsAltKeyDown()) and not (settings.CtrlTooltip and IsControlKeyDown()) and not (settings.ShiftTooltip and IsShiftKeyDown())) then
		return
	end
	
	local name, rank = GetSpellName(slot,BOOKTYPE_SPELL)
	
	if spellInfo[name] then
		local baseSpell = spellInfo[name][0]
		if type(baseSpell) == "function" then baseSpell = baseSpell() end

		if baseSpell and not baseSpell.NoTooltip then	
			if playerCaster or playerHybrid and not baseSpell.Melee then
				self:CasterTooltip( frame, name, rank )
			elseif playerMelee or playerHybrid and baseSpell.Melee then
				self:MeleeTooltip( frame, name, rank )
			end
		end
	end
end

function DrDamage:SetAction( frame, slot )
	self.hooks[frame].SetAction(frame, slot)
	
	if settings.NeverTooltip or (not settings.AlwaysTooltip and not (settings.AltTooltip and IsAltKeyDown()) and not (settings.CtrlTooltip and IsControlKeyDown()) and not (settings.ShiftTooltip and IsShiftKeyDown())) then
		return
	end
	
	local gtype, pid = GetActionInfo(slot)
	local name, rank
		
	if gtype == "spell" then
		name, rank = GetSpellName(pid, BOOKTYPE_SPELL)
	elseif gtype == "macro" then
		name, rank = GetMacroSpell(pid)
	end

	if name and spellInfo[name] then
		local baseSpell = spellInfo[name][0]
		if type(baseSpell) == "function" then baseSpell = baseSpell() end

		if baseSpell and not baseSpell.NoTooltip then
			rank = rank or select(2,GetSpellInfo(name))
			if playerCaster or playerHybrid and not baseSpell.Melee then
				self:CasterTooltip( frame, name, rank )
			elseif playerMelee or playerHybrid and baseSpell.Melee then
				self:MeleeTooltip( frame, name, rank )
			end
		end
	end
end

local DrD_ProcessButton, DrD_CreateText, DrD_SpecialText
function DrDamage:UpdateAB(spell, uid)

	self:TriggerEvent("DrDamage_Update", spell, uid)
	self:CancelSpellUpdate()

	--	Used for debugging updates.
	--[[
	if spell then
		self:Print( "Update AB: Spell" )
		
		if type( spell ) == "table" then
			for _, gar in ipairs( spell ) do
				self:Print( "Updating: " .. gar )
			end
		else
			self:Print( "Updating: " .. spell )
		end
	elseif uid then
		self:Print( "Update AB: ID" )
		
	else
		self:Print( "Update AB: All" )
	end
	--]]
	
	if ABfunc then
		ABfunc()
	end

	if not ABdefault then
		if settings.BlizzardAB then 
			ABdefault = true 
		elseif ABstop then
			return
		end
	elseif not settings.BlizzardAB and ABglobalbutton then
		ABdisable = true
		ABdefault = false
	end
	
	if ABglobalbutton then
		for i = 1,120 do
		    DrD_ProcessButton(_G[ABglobalbutton..i], i, spell, uid)
		end
		local i = 121
		while (_G[ABglobalbutton..i]) do
			DrD_ProcessButton(_G[ABglobalbutton..i], i, spell, uid)
			i = i + 1
		end		
	elseif ABtable then
		for i, list in pairs(ABtable) do
			DrD_ProcessButton(list.button, i, spell, uid)
		end	
	end
	if ABglobalbutton2 then
		for i = 1,120 do
			DrD_ProcessButton(_G[string_format(ABglobalbutton2,i)], i, spell, uid)
		end
	end
	if ABdefault or ABdisable then
		for bar = 1, 5 do
			for i = 1, 12 do
				DrD_ProcessButton(_G[defaultBars[bar]..i], nil, spell, uid)
			end
		end
		if _G["BonusActionButton1"]:IsVisible() or _G["BonusActionBarFrame"]:IsVisible() then
			for i = 1, 12 do		
				DrD_ProcessButton(_G["BonusActionButton"..i], nil, spell, uid)
			end
		end
	end
					
	self.visualChange = nil
	ABdisable = false
end

DrD_ProcessButton = function(button, index, spell, uid)
	if not button then return end 
	if not settings.ABText or ABdisable then 
		if button.drd then button.drd:Hide() end		
		return 
	end
	if button:IsVisible() or ABhidden then
		if not spell and not uid then
			local frame = button.drd
			if frame then frame:Hide() end
		end	
		local id, name, rank
		
		if index then 
			id, name, rank = ABgetID(button, index, ABtable)
		else
			id = ActionButton_GetPagedID(button)
		end
		if id then
			if not HasAction(id) then return end
			if uid and uid ~= id then return end
			DrDamage:CheckAction(button, spell, id)
		elseif name then
			DrDamage:CheckAction(button, spell, nil, name, rank)
		end
	end
end

function DrDamage:CheckAction(button, spell, id, name, rank)
	local gtype, pid
	
	if id then
		gtype, pid = GetActionInfo(id)

		if gtype == "spell" then
			name, rank = GetSpellName(pid, BOOKTYPE_SPELL)
		elseif gtype == "macro" then
			name, rank = GetMacroSpell(pid)
		end
	end
	if name then
		if spell and not DrD_MatchData(spell, name) then
			return
		end
		if rank and tonumber(rank) and GetSpellInfo(name) then
			rank = string_gsub(select(2,GetSpellInfo(name)),"%d+", rank)
		end
		if self.ClassSpecials[name] then
			return DrD_SpecialText(self.ClassSpecials[name], rank, button)
		end
		if spellInfo[name] then
			local baseSpell = settings.SwapCalc and spellInfo[name]["Secondary"] and spellInfo[name]["Secondary"][0] or spellInfo[name][0]
			if type(baseSpell) == "function" then baseSpell = baseSpell() end

			if baseSpell then
				if gtype == "macro" and button then
					local macroText = _G[button:GetName().."Name"]
					if macroText then macroText:Hide() end
				end			

				local text, healingSpell

				if playerCaster or playerHybrid and not baseSpell.Melee then
					healingSpell = baseSpell.Healing or DrD_MatchData(baseSpell.School, "Healing")

					if (settings.CastsLeft and healingSpell or settings.CastsLeftDmg and not healingSpell) and not baseSpell.NoDPM then
						local _, _, _, manaCost = GetSpellInfo(name,rank)

						if manaCost and manaCost > 0 then
							if UnitPowerType("player") == 0 then
								text = math_floor(UnitMana("player") / manaCost)
							else
								text = math_floor(self.lastMana / manaCost)	
							end
						else
							text = "\226\136\158"
						end
					else
						text = self:CasterCalc(name, rank)								
					end
				elseif playerMelee or playerHybrid and baseSpell.Melee then
					text = self:MeleeCalc(name, rank)
				end

				if type(text) == "number" then
					text = math_floor(text + 0.5)
				end

				if button then
					DrD_CreateText(text, button, healingSpell)
				elseif text then
					if healingSpell then
						return "|cff".. string_format("%02x%02x%02x", settings.FontColorHeal.r * 255, settings.FontColorHeal.g * 255, settings.FontColorHeal.b * 255).. text .. "|r"
					else
						return "|cff".. string_format("%02x%02x%02x", settings.FontColorDmg.r * 255, settings.FontColorDmg.g * 255, settings.FontColorDmg.b * 255).. text .. "|r"
					end
				end
			end
		end
	end
end

DrD_CreateText = function(text, button, healing, r, g, b )
	local drd = button.drd

	if not r and (DrDamage.visualChange or not drd) then
		local color = healing and settings.FontColorHeal or settings.FontColorDmg
		r,g,b = color.r, color.g, color.b
	end		
	
	if drd then
		if DrDamage.visualChange then
			drd:SetFont(DrD_Font, settings.FontSize, settings.FontEffect)
			drd:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -10 + settings.FontXPosition, settings.FontYPosition + 5)
			drd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 10 + settings.FontXPosition, settings.FontYPosition + 5)
			drd:SetTextColor(r,g,b)	
		end
		drd:SetText(text)
		drd:Show()
	else
		drd = button:CreateFontString("drd", "OVERLAY")
		button.drd = drd
		drd:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -10 + settings.FontXPosition, settings.FontYPosition + 5)
		drd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 10 + settings.FontXPosition, settings.FontYPosition + 5)
		drd:SetFont(DrD_Font, settings.FontSize, settings.FontEffect)
		drd:SetJustifyH("CENTER")
		drd:SetTextColor(r,g,b)
		drd:SetText(text)
		drd:Show()
	end
end

DrD_SpecialText = function( func, rank, button )
	local text, r, g, b = func(rank)
	if type(text) == "number" then text = math_floor(text + 0.5) end
	if text then
		if button then 
			DrD_CreateText(text, button, false, r, g, b)
		else
			if r then
				return "|cff".. string_format("%02x%02x%02x", r * 255, g * 255, b * 255) .. text .. "|r"
			else
				return "|cff".. string_format("%02x%02x%02x", settings.FontColorDmg.r * 255, settings.FontColorDmg.g * 255, settings.FontColorDmg.b * 255) .. text .. "|r"
			end
		end
	end
end

--Credits to the author of RatingBuster (Whitetooth) for the formula!
local ratingTypes = { ["Hit"] = 8, ["Crit"] = 14, ["MeleeHit"] = 10, ["SpellHaste"] = 10 }
function DrDamage:GetRating( rType, convertR, full )
	local playerLevel = UnitLevel("player")
	local base = ratingTypes[rType]
	local rating, value

	if playerLevel > 60 then
		rating = base * 82 / (262 - 3 * playerLevel)
	elseif playerLevel > 10 then
		rating = base * ((playerLevel - 8) / 52)
	elseif 	playerLevel <= 10 then
		rating = base / 26
	end

	value = convertR and convertR/rating or rating
	value = full and value or DrD_Round(value,2)
	return value
end

function DrDamage:GetLevels()
	local targetLevel = UnitLevel("target")
	local playerLevel = UnitLevel("player")
	
	if targetLevel == -1 then
		if playerLevel >= 60 then 
			targetLevel = 73
		else
			targetLevel = playerLevel + 10
		end
	end
	
	local lvlDiff = math_min(10, targetLevel - playerLevel)
	return lvlDiff, playerLevel, targetLevel
end

local oldRangedItem
function DrDamage:CheckRelicSlot()
	local newRangedItem
	if GetInventoryItemLink("player", GetInventorySlotInfo("RangedSlot")) then
		newRangedItem = GetItemInfo(GetInventoryItemLink("player", GetInventorySlotInfo("RangedSlot")))
	end
	if newRangedItem ~= oldRangedItem then
		oldRangedItem = newRangedItem
		return true
	end
end

local WeaponBuffScan = GetTime()
local WeaponBuff, WeaponBuffRank 
function DrDamage:GetWeaponBuff(off)
	local mh, _, _, oh = GetWeaponEnchantInfo()
	local name, rank, buff
	
	if not off and mh then
		if GetTime() > WeaponBuffScan then
			WeaponBuffScan = GetTime() + 2
			GT:SetInventoryItem("player", GetInventorySlotInfo("MainHandSlot"))
			_, _, buff = GT:Find("^([^%(]+) %(%d+ [^%)]+%)$", nil, nil, false, true)
			if buff then
				name, rank = string_match(buff,"^(.*) (%d+)$")
			end
			WeaponBuff, WeaponBuffRank = name or buff, rank
		end
		return WeaponBuff, WeaponBuffRank
	elseif off and oh then
		GT:SetInventoryItem("player", GetInventorySlotInfo("SecondaryHandSlot"))
		_, _, name, rank = GT:Find("^([^%(]+) %(%d+ [^%)]+%)$", nil, nil, false, true)
		if buff then
			name, rank = string_match(buff,"^(.*) (%d+)$")
		end
	end
	return name or buff, rank
end

function DrDamage:Calc(name, rank, tooltip, modify)
	if not spellInfo or not name then return end
	if not spellInfo[name] then return end
	local baseSpell = settings.SwapCalc and spellInfo[name]["Secondary"] and spellInfo[name]["Secondary"][0] or spellInfo[name][0]
	if type(baseSpell) == "function" then baseSpell = baseSpell() end
	if baseSpell then
		if playerCaster or playerHybrid and not baseSpell.Melee then
			return self:CasterCalc(name, rank, tooltip, modify)								
		elseif playerMelee or playerHybrid and baseSpell.Melee then
			return self:MeleeCalc(name, rank, tooltip, modify)
		end
	end
end
