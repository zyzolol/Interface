----------------------------------------
-- Outfitter
----------------------------------------

Outfitter.cContributors = {"Dridzt", "Kal_Zakath13", "Smurfy", "XMinionX", "Zanoroy"}
Outfitter.cFriendsAndFamily = {"Brian", "Dave", "Glenn", "Leah", "Mark", "Gian", "Jerry", "The Mighty Pol", "Forge"}
Outfitter.cTranslators = {"Jullye (FR)", "Quetzaco (FR)", "Ekhurr (FR)", "Negwe (FR)", "Ani (DE)", "Zokrym (DE)", "Dessa (DE)", "Unknown (KR)"}
Outfitter.cTesters = {"Whishann", "HunterZ", "docthis", "Irdx", "TigaFIN", "iceeagle", "Denrax", "rasmoe", "Katlefiya", "gtmsece", "Militis", "Casard", "saltorio", "elusif"}

----------------------------------------
----------------------------------------

gOutfitter_Settings = nil
gOutfitter_GlobalSettings = nil

Outfitter.Initialized = false
Outfitter.Suspended = false
	
-- Outfit state
	
Outfitter.OutfitStack = {}
Outfitter.OutfitStack.Outfits = {}

Outfitter.CurrentOutfit = nil
Outfitter.ExpectedOutfit = nil
Outfitter.CurrentInventoryOutfit = nil

Outfitter.EquippedNeedsUpdate = false
Outfitter.WeaponsNeedUpdate = false
Outfitter.LastEquipmentUpdateTime = 0
	
Outfitter.SpecialState = {} -- The current state as determined by the engine, not necessarily the state of the outfit itself
	
Outfitter.ScriptContexts = {}
Outfitter.OutfitScriptEvents = {}

-- Player state
	
Outfitter.CurrentZone = ""
Outfitter.CurrentZoneIDs = {}

Outfitter.InCombat = false
Outfitter.MaybeInCombat = false
	
Outfitter.IsDead = false
Outfitter.IsFeigning = false
	
Outfitter.BankFrameIsOpen = false
	
Outfitter.SettingTypeInfo =
{
	string      = {Default = "",    FrameType = "EditBox"          },
	number      = {Default = 0,     FrameType = "EditBox"          },
	stringtable = {Default = {},    FrameType = "ScrollableEditBox"},
	zonelist    = {Default = {},    FrameType = "ZoneListEditBox"  },
	boolean     = {Default = false, FrameType = "Checkbox"         },
}

Outfitter.Style = {}
	
Outfitter.Style.ButtonBar =
{
	ButtonHeight = 37,
	ButtonWidth = 37,
	
	BackgroundTextureHeight = 128,
	BackgroundTextureWidth = 128,
	
	BackgroundWidth = 42,
	BackgroundWidth0 = 26,
	BackgroundWidthN = 27,
	
	BackgroundHeight = 41,
	BackgroundHeight0 = 28,
	BackgroundHeightN = 25,
}

-- UI

Outfitter.CurrentPanel = 0
Outfitter.Collapsed = {}
Outfitter.SelectedOutfit = nil
Outfitter.DisplayIsDirty = true
Outfitter.OutfitInfoCache = {}

function Outfitter:FormatItemList(pList)
	local vNumItems = #pList
	
	if vNumItems == 0 then
		return ""
	elseif vNumItems == 1 then
		return string.format(self.cSingleItemFormat, pList[1])
	elseif vNumItems == 2 then
		return string.format(self.cTwoItemFormat, pList[1], pList[2])
	else
		local vStartIndex, vEndIndex, vPrefix, vRepeat, vSuffix = string.find(self.cMultiItemFormat, "(.*){{(.*)}}(.*)")
		local vResult
		local vParamIndex = 1
		
		if vPrefix and string.find(vPrefix, "%%") then
			vResult = string.format(vPrefix, pList[1])
			vParamIndex = 2
		else
			vResult = vPrefix or ""
		end
		
		if vRepeat then
			for vIndex = vParamIndex, vNumItems - 1 do
				vResult = vResult..string.format(vRepeat, pList[vIndex])
			end
		end
			
		if vSuffix then
			vResult = vResult..string.format(vSuffix, pList[vNumItems])
		end
		
		return vResult
	end
end

-- Define global variables to be used directly in the XML
-- file since those references can't be object paths

Outfitter_cTitle = Outfitter.cTitle
Outfitter_cTitleVersion = Outfitter.cTitleVersion

Outfitter_cCreateUsingTitle = Outfitter.cCreateUsingTitle
Outfitter_cAutomationLabel = Outfitter.cAutomationLabel
Outfitter_cOutfitterTabTitle = Outfitter.cOutfitterTabTitle
Outfitter_cOptionsTabTitle = Outfitter.cOptionsTabTitle
Outfitter_cAboutTabTitle = Outfitter.cAboutTabTitle

Outfitter_cNewOutfit = Outfitter.cNewOutfit
Outfitter_cNameAlreadyUsedError = Outfitter.cNameAlreadyUsedError
Outfitter_cEnableAll = Outfitter.cEnableAll
Outfitter_cEnableNone = Outfitter.cEnableNone
Outfitter_cOptionsTitle = Outfitter.cOptionsTitle

Outfitter.cSpecialThanksNames = "%s"
Outfitter.cTranslationCredit = "Translations by %s"

Outfitter_cAboutTitle = Outfitter.cAboutTitle
Outfitter_cAuthor = string.format(Outfitter.cAuthor, Outfitter:FormatItemList(Outfitter.cContributors))
Outfitter_cTestersTitle = Outfitter.cTestersTitle
Outfitter_cTestersNames = string.format(Outfitter.cTestersNames, Outfitter:FormatItemList(Outfitter.cTesters))
Outfitter_cSpecialThanksTitle = Outfitter.cSpecialThanksTitle
Outfitter_cSpecialThanksNames = string.format(Outfitter.cSpecialThanksNames, Outfitter:FormatItemList(Outfitter.cFriendsAndFamily))
Outfitter_cTranslationCredit = string.format(Outfitter.cTranslationCredit, Outfitter:FormatItemList(Outfitter.cTranslators))
Outfitter_cURL = Outfitter.cURL

Outfitter_cEditScriptTitle = Outfitter.cEditScriptTitle
Outfitter_cEditScriptEllide = Outfitter.cEditScriptEllide
Outfitter_cPresetScript = Outfitter.cPresetScript
Outfitter_cSettings = Outfitter.cSettings
Outfitter_cSource = Outfitter.cSource

Outfitter_cIconFilterLabel = Outfitter.cIconFilterLabel
Outfitter_cIconSetLabel = Outfitter.cIconSetLabel

-- These definitions are for backward compatibility with third-party addons
-- which call into Outfitter directly (OutfitterFu, FishingBuddy, ArkInventory)
-- Hopefully the authors of those addons will eventually migrate their code to
-- use the new functions instead so that these can eventually be eliminated.

Outfitter_cFishingStatName = Outfitter.cFishingStatName

Outfitter_cCompleteOutfits = Outfitter.cCompleteOutfits
Outfitter_cAccessoryOutfits = Outfitter.cAccessoryOutfits
Outfitter_cOddsNEndsOutfits = Outfitter.cOddsNEndsOutfits

function Outfitter_OnLoad(...) return Outfitter:OnLoad(...) end
function Outfitter_IsInitialized(...) return Outfitter:IsInitialized(...) end
function Outfitter_Update(...) return Outfitter:Update(...) end

function Outfitter_FindOutfitByStatID(...) return Outfitter:FindOutfitByStatID(...) end
function Outfitter_FindOutfitByName(...) return Outfitter:FindOutfitByName(...) end

function Outfitter_GetCategoryOrder(...) return Outfitter:GetCategoryOrder(...) end
function Outfitter_GetOutfitsByCategoryID(...) return Outfitter:GetOutfitsByCategoryID(...) end
function Outfitter_HasVisibleOutfits(...) return Outfitter:HasVisibleOutfits(...) end
function Outfitter_OutfitIsVisible(...) return Outfitter:OutfitIsVisible(...) end

function Outfitter_GenerateSmartOutfit(...) return Outfitter:GenerateSmartOutfit(...) end
function Outfitter_AddOutfit(...) return Outfitter:AddOutfit(...) end
function Outfitter_DeleteOutfit(...) return Outfitter:DeleteOutfit(...) end

function Outfitter_WearOutfit(pOutfit, pCategoryID, pWearBelowOutfit) return Outfitter:WearOutfit(pOutfit) end
function Outfitter_RemoveOutfit(...) return Outfitter:RemoveOutfit(...) end
function Outfitter_WearingOutfit(...) return Outfitter:WearingOutfit(...) end

function Outfitter_RegisterOutfitEvent(...) return Outfitter:RegisterOutfitEvent(...) end
function Outfitter_UnregisterOutfitEvent(...) return Outfitter:UnregisterOutfitEvent(...) end

function Outfitter_GetOutfitFromListItem(...) return Outfitter:GetOutfitFromListItem(...) end
function Outfitter_GetCurrentOutfitInfo(...) return Outfitter:GetCurrentOutfitInfo(...) end
function Outfitter_SetShowMinimapButton(...) return Outfitter:SetShowMinimapButton(...) end

function Outfitter_GetItemInfoFromLink(...) return Outfitter:GetItemInfoFromLink(...) end
function Outfitter_GetOutfitsUsingItem(...) return Outfitter:GetOutfitsUsingItem(...) end

function OutfitterItemList_GetEquippableItems(...) return Outfitter.ItemList_GetEquippableItems(...) end
function OutfitterItemList_GetMissingItems(...) return Outfitter.ItemList_GetMissingItems(...) end

function OutfitterMinimapButton_ItemSelected(...) return Outfitter.MinimapButton_ItemSelected(...) end

--

Outfitter.OrigGameTooltipOnShow = nil
Outfitter.OrigGameTooltipOnHide = nil

Outfitter.cMinEquipmentUpdateInterval = 1.5

Outfitter.cInitializationEvents =
{
	["PLAYER_ENTERING_WORLD"] = true,
	["BAG_UPDATE"] = true,
	["UNIT_INVENTORY_CHANGED"] = true,
	["ZONE_CHANGED_NEW_AREA"] = true,
	["PLAYER_ALIVE"] = true,
}

Outfitter.BANKED_FONT_COLOR = {r = 0.25, g = 0.2, b = 1.0}
Outfitter.BANKED_FONT_COLOR_CODE = "|cff4033ff"
Outfitter.OUTFIT_MESSAGE_COLOR = {r = 0.2, g = 0.75, b = 0.3}

Outfitter.cItemLinkFormat = "|(%x+)|Hitem:(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+)|h%[([^%]]+)%]|h|r"

Outfitter.cUniqueEquippedGemIDs =
{
	[2850] = true, -- Blood of Amber, ItemCode 33140, +13 Spell Critical Strike Rating
	[2945] = true, -- Bold Ornate Ruby, ItemCode 28362, +20 Attack Power
	[2749] = true, -- Brilliant Bladestone, ItemCode 33139, +12 Intellect
	[1068] = true, -- Charmed Amani Jewel, ItemCode 34256, +15 Stamina
	[1593] = true, -- Crimson Sun, ItemCode 33131, +24 Attack Power
	[368] = true, -- Delicate Fire Ruby, ItemCode 33132, +12 Agility
	[3210] = true, -- Don Julio's Heart, ItemCode 33133
	[1957] = true, -- Facet of Eternity, ItemCode 33144, +12 Defense Rating
	[1071] = true, -- Falling Star, ItemCode 33135, +18 Stamina
	[2914] = true, -- Gleaming Ornate Dawnstone, ItemCode 28120, +10 Spell Critical Strike Rating FIXME: Is this supposed to be 2934 maybe?

	[3218] = true, -- Great Bladestone, ItemCode 33141, +12 Spell Hit Rating
	[2946] = true, -- Inscribed Ornate Topaz, ItemCode 28363, +10 Attack Power, +5 Critical Strike Rating
	[3211] = true, -- Kailee's Rose, ItemCode 33134, +26 Healing and +9 Spell Damage
	[3215] = true, -- Mystic Bladestone, ItemCode 33138, +12 Resilience Rating
	[2916] = true, -- Potent Ornate Topaz, ItemCode 28123, +6 Spell Damage, +5 Spell Crit Rating
	[1591] = true, -- Radiant Spencerite, ItemCode 32735, +20 Attack Power
	[2784] = true, -- Rigid Bladestone, ItemCode 33142, +12 Hit Rating
	[2912] = true, -- Runed Ornate Ruby, ItemCode 28118, +12 Spell Damage
	[2913] = true, -- Smooth Ornate Dawnstone, ItemCode 28119, +10 Critical Strike Rating
	[370] = true, -- Sparkling Falling Star, ItemCode 33137, +12 Spirit
	
	[3220] = true, -- Stone of Blades, ItemCode 33143, +12 Critical Strike Rating
	[2891] = true, -- Sublime Mystic Dawnstone, ItemCode 27679, +10 Resilience Rating
	[2899] = true, -- Barbed Deep Peridot, ItemCode 27786 & 27809, +3 Stamina, +4 Critical Strike Rating
	[3103] = true, -- Don Amancio's Heart, ItemCode 30598, +8 Strength (numerous enchants of +8 str)
	[3065] = true, -- Don Rodrigo's Heart, ItemCode 30571, +8 Strength
	[3268] = true, -- Eye of the Sea, ItemCode 34831, +15 Stamina
	[2943] = true, -- Mighty Blood Garnet, ItemCode 28360, +14 Attack Power
	[2944] = true, -- Mighty Blood Garnet, ItemCode 28361, +14 Attack Power
	[2898] = true, -- Notched Deep Peridot, ItemCode 27785, +3 Stamina, +4 Spell Critical Strike Rating
	[2923] = true, -- Notched Deep Peridot, ItemCode 27820, +3 Stamina, +4 Spell Critical Strike Rating
	[2896] = true, -- Stark Blood Garnet, ItemCode 27777, +8 Spell Damage
	[2924] = true, -- Stark Blood Garnet, ItemCode 27812, +8 Spell Damage
	[2970] = true, -- Swift Starfire Diamond, ItemCode 28557, +12 Spell Damage and Minor Run Speed Increase
	[2969] = true, -- Swift Windfire Diamond, ItemCode 28556, +20 Attack Power and Minor Run Speed Increase

	[3156] = true, -- Unstable Amethyst, ItemCode 32634, +8 Attack Power and +6 Stamina
	[3159] = true, -- Unstable Citrine, ItemCode 32637, +8 Attack Power
	[3157] = true, -- Unstable Peridot, ItemCode 32635,
	[3158] = true, -- Unstable Sapphire, ItemCode 32636,
	[3161] = true, -- Unstable Talasite, ItemCode 32639,
	[3160] = true, -- Unstable Topaz, ItemCode 32638,

	-- [3091] = true, -- Radiant Chrysoprase, ItemCode 30608, +5 Spell Critical Rating and +5 Spell Penetration
	-- [3077] = true, -- Dazzling Chrysoprase, ItemCode 30589, +5 Intellect and 2 mana per 5 sec.
	-- [3082] = true, -- Effulgent Chrysoprase, ItemCode 30594, +5 Defense Rating and 2 mana per 5 sec.
	-- [3078] = true, -- Enduring Chrysoprase, ItemCode 30590, +6 Stamina and +5 Defense Rating
	-- [3085] = true, -- Jagged Chrysoprase, ItemCode 30602, +6 Stamina and +5 Crit Rating
	-- [3089] = true, -- Lambent Chrysoprase, ItemCode 30606, +5 Spell Hit Rating and 2 mana per 5 sec.
	-- [3047] = true, -- Polished Chrysoprase, ItemCode 30548, +6 Stamina and +5 Spell Crit Rating
	-- [3058] = true, -- Rune Covered Chrysoprase, ItemCode 30560, +5 Spell Critical Rating and 2 mana per 5 sec.
	-- [3074] = true, -- Seer's Chrysoprase, ItemCode 30586, +4 Intellect and +5 Spirit
	-- [3080] = true, -- Steady Chrysoprase, ItemCode 30592, +6 Stamina and +5 Resilience Rating
	-- [3049] = true, -- Sundered Chrysoprase, ItemCode 30550, +5 Critical Strike Rating and +2 mana per 5 sec.
	-- [3071] = true, -- Timeless Chrysoprase, ItemCode 30583, +5 Intellect and +6 Stamina
	-- [3088] = true, -- Vivid Chrysoprase, ItemCode 30605, +5 Spell Hit Rating and +6 Stamina

	-- [3062] = true, -- Assassin's Fire Opal, Item 30565, +6 Critical Rating and +5 Dodge Rating
	-- [3084] = true, -- Beaming Fire Opal, ItemCode 30601, +5 Dodge Rating and +4 Resilience Rating
	-- [3075] = true, -- Champion's Fire Opal, ItemCode 30587, +5 Strength and +4 Defense
	-- [3070] = true, -- Deadly Fire Opal, ItemCode 30582, +8 Attack Power and +5 Critical Rating
	-- [3069] = true, -- Durable Fire Opal, ItemCode 30581, +11 Healing and +4 Resilience Rating
	-- [3079] = true, -- Empowered Fire Opal, ItemCode 30591, +8 Attack Power and +5 Resilience Rating
	-- [3072] = true, -- Enscribed Fire Opal, ItemCode 30584, +5 Strength and +4 Critical Rating
	-- [3057] = true, -- Etched Fire Opal, ItemCode 30559, +5 Strength and +4 Hit Rating
	-- [3056] = true, -- Glimmering Fire Opal, ItemCode 30558, +5 Parry Rating and +4 Defense Rating
	-- [3055] = true, -- Glinting Fire Opal, ItemCode 30556, +5 Agility and +4 Hit Rating
	-- [3073] = true, -- Glistening Fire Opal, ItemCode 30585, +4 Agility and +5 Defense Rating
	-- [3050] = true, -- Infused Fire Opal, ItemCode 30551, +6 Spell Damage and +4 Intellect
	-- [3081] = true, -- Iridescent Fire Opal, ItemCode 30593, +11 Healing and +4 Spell Critical Rating
	-- [3046] = true, -- Luminous Fire Opal, ItemCode 30547, +11 Healing and +4 Intellect
	-- [3066] = true, -- Mysterious Fire Opal, ItemCode 30573, +6 Spell Damage and +5 Spell Penetration
	-- [3068] = true, -- Nimble Fire Opal, ItemCode 30575, +5 Dodge Rating and +4 Hit Rating
	-- [3076] = true, -- Potent Fire Opal, ItemCode 30588, +6 Spell Damage and +4 Spell Critical Rating
	-- [3052] = true, -- Pristine Fire Opal, ItemCode 30553, +10 Attack Power and +4 Hit Rating
	-- [3087] = true, -- Resplendent Fire Opal, Item ID 30604, ItemCode 3087, 
	-- [3061] = true, -- Shining Fire Opal, ItemCode 30564, +6 Spell Damage and +5 Spell Hit Rating
	-- [3090] = true, -- Splendid Fire Opal, ItemCode 30607, +5 Parry Rating and +4 Resilience Rating
	-- [3053] = true, -- Stalwart Fire Opal, ItemCode 30554, +5 Defense Rating and +4 Dodge Rating

	-- [3100] = true, -- Blessed Tanzanite, ItemCode 30552, +11 Healing and +6 Stamina
	-- [3067] = true, -- Brutal Tanzanite, ItemCode 30574, +10 Attack Power and +6 Stamina
	-- [3063] = true, -- Defender's Tanzanite, ItemCode 30566, +5 Parry Rating and +6 Stamina
	-- [3083] = true, -- Fluorescent Tanzanite, ItemCode 30600, +6 Spell Damage and +4 Spirit
	-- [3099] = true, -- Glowing Tanzanite, ItemCode 30555, +6 Spell Damage and +6 Stamina
	-- [3064] = true, -- Imperial Tanzanite, ItemCode 30572, +5 Spirit and +9 Healing
	-- [3060] = true, -- Regal Tanzanite, ItemCode 30563, +5 Dodge Rating and +6 Stamina
	-- [3086] = true, -- Royal Tanzanite, ItemCode 30603, +11 Healing and 2 mana per 5 sec.
	-- [3048] = true, -- Shifting Tanzanite, ItemCode 30549, +5 Strength and +4 Agility
	-- [3045] = true, -- Sovereign Tanzanite, ItemCode 30546, +5 Strength and +6 Stamina
}

StaticPopupDialogs.OUTFITTER_CANT_RELOADUI =
{
	text = TEXT(Outfitter.cCantReloadUI),
	button1 = TEXT(OKAY),
	OnAccept = function() end,
	OnCancel = function() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	showAlert = 1,
}

function Outfitter:GenerateScriptHeader(pEventIDs, pDescription)
	local vDescription
	
	if pDescription then
		vDescription = '-- $DESC '..pDescription..'\n'
	else
		vDescription = ''
	end
	
	if type(pEventIDs) == "table" then
		pEventIDs = table.concat(pEventIDs, " ")
	end
	
	return '-- $EVENTS '..pEventIDs..'\n'..vDescription..'\n'
end

function Outfitter:GenerateSimpleScript(pEventID, pDescription)
	return
		self:GenerateScriptHeader(pEventID.." NOT_"..pEventID, pDescription)..
		'-- If the activation event fires, equip the outfit\n'..
		'\n'..
		'if event == "'..pEventID..'" then\n'..
		'    equip = true\n'..
		'\n'..
		'-- Otherwise it must be the deactivation event so unequip it\n'..
		'\n'..
		'else\n'..
		'    equip = false\n'..
		'end\n'
end

function Outfitter:GenerateSmartUnequipScript(pEventID, pDescription, pUnequipDelay)
	local vScript
	
	vScript = self:GenerateScriptHeader(pEventID.." NOT_"..pEventID, pDescription)..
		'-- If the activation event fires, equip the outfit\n'..
		'\n'..
		'if event == "'..pEventID..'" then\n'..
		'    equip = true\n'..
		'\n'..
		'-- Otherwise it must be the deactivation event so unequip\n'..
		'-- the outfit.\n'..
		'\n'..
		'-- Note that if you manually equipped the outfit the script\n'..
		'-- will not unequip it for you.  This allows you to avoid excess\n'..
		'-- outfit changes, for example when entering and exiting\n'..
		'-- battlegrounds repeatedly. Remove the didEquip condition\n'..
		'-- to change the behavior to always unequip.\n'..
		'\n'..
		'elseif didEquip then\n'..
		'    equip = false\n' if pUnequipDelay then vScript = vScript..
		'    delay = '..pUnequipDelay..'\n' end vScript = vScript..
		'end\n'
	
	return vScript
end

function Outfitter:GenerateShapeshiftScript(pEventID, pDescription)
	return
		self:GenerateScriptHeader({pEventID, 'NOT_'..pEventID, "OUTFIT_EQUIPPED"}, pDescription)..
		'-- $SETTING DisableBG={Type="Boolean", Label="Don\'t equip in Battlegrounds", Default=false}\n'..
		'-- $SETTING DisablePVP={Type="Boolean", Label="Don\'t equip while PvP flagged", Default=false}\n'..
		'\n'..
		'-- Just return if they\'re PvP\'ing and don\'t want the outfit changing\n'..
		'\n'..
		'if (setting.DisableBG and Outfitter:InBattlegroundZone())\n'..
		'or (setting.DisablePVP and UnitIsPVP("player")) then\n'..
		'    return\n'..
		'end\n'..
		'\n'..
		'-- Return if the user isn\'t in full control\n'..
		'\n'..
		'if not Outfitter.IsDead and not HasFullControl() then\n'..
		'    return\n'..
		'end\n'..
		'\n'..
		'-- If the outfit is being equipped then let Outfitter know\n'..
		'-- which layer it\'s representing\n'..
		'\n'..
		'if event == "OUTFIT_EQUIPPED" then\n'..
		'    layer = "shapeshift"\n'..
		'\n'..
		'-- Equip and set the layer if entering the stance\n'..
		'\n'..
		'elseif event == "'..pEventID..'" then\n'..
		'    equip = true\n'..
		'    layer = "shapeshift"\n'..
		'\n'..
		'-- Just unequip if leaving the stance\n'..
		'\n'..
		'else\n'..
		'    equip = false\n'..
		'end\n'
end

function Outfitter:GenerateDruidShapeshiftScript(pEventID, pDescription)
	return
		self:GenerateScriptHeader({pEventID, 'NOT_'..pEventID, 'OUTFIT_EQUIPPED'}, pDescription)..
		'-- $SETTING DisableBG={Type="Boolean", Label="Don\'t equip in Battlegrounds", Default=false}\n'..
		'-- $SETTING DisablePVP={Type="Boolean", Label="Don\'t equip while PvP flagged", Default=false}\n'..
		'\n'..
		'-- Just return if they\'re PvP\'ing and don\'t want the outfit changing\n'..
		'\n'..
		'if (setting.DisableBG and Outfitter:InBattlegroundZone())\n'..
		'or (setting.DisablePVP and UnitIsPVP("player")) then\n'..
		'    return\n'..
		'end\n'..
		'\n'..
		'-- Return if the user isn\'t in full control\n'..
		'\n'..
		'if not Outfitter.IsDead and not HasFullControl() then\n'..
		'    return\n'..
		'end\n'..
		'\n'..
		'-- If the user is manually equipping the outfit, let\n'..
		'-- Outfitter know which layer it\'s representing\n'..
		'\n'..
		'if event == "OUTFIT_EQUIPPED" then\n'..
		'    layer = "shapeshift"\n'..
		'\n'..
		'-- Equip and set the layer if entering the form\n'..
		'\n'..
		'elseif event == "'..pEventID..'" then\n'..
		'    equip = true\n'..
		'    layer = "shapeshift"\n'..
		'\n'..
		'-- Unequip if leaving the form.  If they\'re in combat also\n'..
		'-- add a 2 second delay so they have time to start casting\n'..
		'-- a heal on themselves without triggering the global cooldown\n'..
		'\n'..
		'else\n'..
		'    equip = false\n'..
		'\n'..
		'    if Outfitter.InCombat then\n'..
		'        delay = 2\n'..
		'    end\n'..
		'end\n'
end

function Outfitter:GenerateGatheringScript(pTooltipGatherMessage, pDescription)
	return
		self:GenerateScriptHeader("GAMETOOLTIP_SHOW GAMETOOLTIP_HIDE", pDescription)..
		'-- If the tooltip is being shown see if the outfit should be equipped\n'..
		'\n'..
		'if event == "GAMETOOLTIP_SHOW" then\n'..
		'\n'..
		'    -- Check the tooltip for an orange or red tradeskill message\n'..
		'    -- and equip the outfit if there is one\n'..
		'\n'..
		'    local hasText, isDifficult = Outfitter:TooltipContainsLine(GameTooltip, '..pTooltipGatherMessage..')\n'..
		'\n'..
		'    if hasText and isDifficult then\n'..
		'        equip=true\n'..
		'    end\n'..
		'\n'..
		'    -- The tooltip isn\'t being shown so it\'s being hidden.\n'..
		'    -- A one second delay is used so that the outfit doesn\'t\n'..
		'    -- unequip if the user momentarily moves the cursor off\n'..
		'    -- the node\n'..
		'\n'..
		'elseif didEquip then\n'..
		'    equip=false; delay=1\n'..
		'end'
end

function Outfitter:GenerateLockpickingScript(pTooltipGatherMessage, pDescription)
	return
		self:GenerateScriptHeader("GAMETOOLTIP_SHOW GAMETOOLTIP_HIDE", pDescription)..
		'-- If the tooltip is being shown see if the outfit should be equipped\n'..
		'\n'..
		'if event == "GAMETOOLTIP_SHOW" or event == "TIMER" then\n'..
		'    if event == "GAMETOOLTIP_SHOW" then\n'..
		'        self:RegisterEvent("TIMER")\n'..
		'    end\n'..
		'\n'..
		'    if not SpellIsTargeting() then\n'..
		'        return\n'..
		'    end\n'..
		'\n'..
		'    -- Check the tooltip for an orange or red tradeskill message\n'..
		'    -- and equip the outfit if there is one\n'..
		'\n'..
		'    local hasText, isDifficult = Outfitter:TooltipContainsLine(GameTooltip, Outfitter.cRequiresLockpicking)\n'..
		'\n'..
		'    if hasText and isDifficult then\n'..
		'        equip=true\n'..
		'    end\n'..
		'\n'..
		'    -- The tooltip isn\'t being shown so it\'s being hidden.\n'..
		'    -- A one second delay is used so that the outfit doesn\'t\n'..
		'    -- unequip if the user momentarily moves the cursor off\n'..
		'    -- the node\n'..
		'\n'..
		'else\n'..
		'    self:UnregisterEvent("TIMER")\n'..
		'    if didEquip then -- GAME_TOOLTIP_HIDE\n'..
		'        equip=false; delay=1\n'..
		'    end\n'..
		'end'
end

Outfitter.PresetScripts =
{
	{
		Name = Outfitter.cHerbalismOutfit,
		ID = "HERBALISM",
		Category = "TRADE",
		Script = Outfitter:GenerateGatheringScript("UNIT_SKINNABLE_HERB", Outfitter.cHerbalismDescription),
	},
	{
		Name = Outfitter.cMiningOutfit,
		ID = "MINING",
		Category = "TRADE",
		Script = Outfitter:GenerateGatheringScript("UNIT_SKINNABLE_ROCK", Outfitter.cMiningDescription),
	},
	{
		Name = Outfitter.cSkinningOutfit,
		ID = "SKINNING",
		Category = "TRADE",
		Script = Outfitter:GenerateGatheringScript("UNIT_SKINNABLE_LEATHER", Outfitter.cSkinningDescription),
	},
	{
		Name = Outfitter.cLockpickingOutfit,
		ID = "LOCKPICKING",
		Category = "TRADE",
		Class = "ROGUE",
		Script = Outfitter:GenerateLockpickingScript(Outfitter.cLockpickingDescription),
	},
	{
		Name = Outfitter.cLowHealthOutfit,
		ID = "LOW_HEALTH",
		Category = "GENERAL",
		Script = Outfitter:GenerateScriptHeader("UNIT_HEALTH UNIT_MANA", Outfitter.cLowHealthDescription)..
		       '-- $SETTING Health="Number"\n'..
		       '-- $SETTING Mana="Number"\n'..
		       '\n'..
		       'if arg1=="player"\n'..
		       'and (UnitHealth(arg1) < setting.Health\n'..
		       '  or UnitMana(arg1) < setting.Mana) then\n'..
		       '    equip = true\n'..
		       'elseif didEquip then\n'..
		       '    equip = false\n'..
		       'end',
	},
	{
		Name = Outfitter.cHasBuffOutfit,
		ID = "HAS_BUFF",
		Category = "GENERAL",
		Script = Outfitter:GenerateScriptHeader("PLAYER_AURAS_CHANGED", Outfitter.cHasBuffDescription)..
		         '-- $SETTING buffName = {Type = "String", Label = "Buff name"}\n'..
		         '\n'..
		         'local index = 1\n'..
		         'local lowerName = strlower(setting.buffName)\n'..
		         '\n'..
		         'while true do\n'..
		         '    local buffName = UnitBuff("player", index)\n'..
		         '    if not buffName then break end\n'..
		         '    if strlower(buffName) == lowerName then equip = true break end\n'..
		         '    index = index + 1\n'..
		         'end\n'..
		         '\n'..
		         'if equip == nil and didEquip then equip = false end\n',
	},
	{
		Name = "Trinket Queue",
		ID = "TRINKET_QUEUE",
		Category = "GENERAL",
		Script = Outfitter:GenerateScriptHeader("TIMER", "The highest trinket in the list that isn\'t on cooldown will automatically be equipped for you")..
		       '-- $SETTING Trinkets={Label="Upper slot", Type="StringTable"}\n'..
		       '-- $SETTING Trinkets2={Label="Lower slot", Type="StringTable"}\n'..
		       '\n'..
		       'local upperSlotVisible = true\n'..
		       'local lowerSlotVisible = true\n'..
		       '\n'..
		       'if not Outfitter.OutfitStack:IsTopmostOutfit(outfit) then\n'..
		       '    for index = #Outfitter.OutfitStack.Outfits, 1, -1 do\n'..
		       '        local stackOutfit = Outfitter.OutfitStack.Outfits[index]\n'..
		       '        if outfit == stackOutfit then break end\n'..
		       '        if stackOutfit.Name then\n'..
		       '            if stackOutfit.Items.Trinket0Slot then\n'..
		       '                upperSlotVisible = false\n'..
		       '            end\n'..
		       '            if stackOutfit.Items.Trinket1Slot then\n'..
		       '                lowerSlotVisible = false\n'..
		       '            end\n'..
		       '        end\n'..
		       '    end\n'..
		       'end\n'..
		       '\n'..
		       'if isEquipped and not Outfitter.InCombat and not Outfitter.IsDead then\n'..
		       '    if upperSlotVisible and not Outfitter:InventoryItemIsActive("Trinket0Slot") then\n'..
		       '        for _, itemName in ipairs(setting.Trinkets) do\n'..
		       '            local startTime, duration, enable = GetItemCooldown(itemName)\n'..
		       '            if duration <= 30 then\n'..
		       '                EquipItemByName(itemName)\n'..
		       '                break\n'..
		       '            end\n'..
		       '        end\n'..
		       '    end\n'..
		       '\n'..
		       '    if lowerSlotVisible and not Outfitter:InventoryItemIsActive("Trinket1Slot") then\n'..
		       '        for _, itemName in ipairs(setting.Trinkets2) do\n'..
		       '            local startTime, duration, enable = GetItemCooldown(itemName)\n'..
		       '            if duration <= 30 then\n'..
		       '                EquipItemByName(itemName, 14)\n'..
		       '                break\n'..
		       '            end\n'..
		       '        end\n'..
		       '    end\n'..
		       'end',
	},
	{
		Name = Outfitter.cInZonesOutfit,
		ID = "IN_ZONES",
		Category = "TRADE",
		Script = Outfitter:GenerateScriptHeader("ZONE_CHANGED_INDOORS ZONE_CHANGED ZONE_CHANGED_NEW_AREA", Outfitter.cInZonesOutfitDescription)..
		       '-- $SETTING zoneList={Type=\"ZoneList\", Label=\"Zones\"}\n'..
		       '-- $SETTING minimapZoneList={Type=\"ZoneList\", ZoneType=\"MinimapZone\", Label=\"Minimap zones\"}\n'..
		       '\n'..
		       'local currentZone = GetZoneText()\n'..
		       '\n'..
		       'for _, zoneName in ipairs(setting.zoneList) do\n'..
		       '    if zoneName == currentZone then\n'..
		       '        equip = true\n'..
		       '        break\n'..
		       '    end\n'..
		       'end\n'..
		       '\n'..
		       'if not equip then\n'..
		       '    currentZone = GetMinimapZoneText()\n'..
		       '    for _, zoneName in ipairs(setting.minimapZoneList) do\n'..
		       '        if zoneName == currentZone then\n'..
		       '            equip = true\n'..
		       '            break\n'..
		       '        end\n'..
		       '    end\n'..
		       'end\n'..
		       '\n'..
		       'if didEquip and equip == nil then\n'..
		       '    equip = false\n'..
		       'end',
	},
	{
		Name = Outfitter.cArgentDawnOutfit,
		ID = "ArgentDawn",
		Category = "GENERAL",
		Script = Outfitter:GenerateScriptHeader("ARGENT_DAWN NOT_ARGENT_DAWN", Outfitter.cArgentDawnOutfitDescription)..
		         '-- $SETTING DisableNaxx={Type="Boolean", Label="Disable in Naxxramas"}\n'..
		         'if event == "ARGENT_DAWN" then\n'..
		         '    if not setting.DisableNaxx\n'..
		         '    or not Outfitter:InZoneType("Naxx") then\n'..
		         '        equip = true\n'..
		         '    end\n'..
		         'elseif didEquip then\n'..
		         '    equip = false\n'..
		         'end\n',
	},
	{
		Name = Outfitter.cRidingOutfit,
		ID = "Riding",
		Category = "TRADE",
		Script = Outfitter:GenerateScriptHeader("MOUNTED NOT_MOUNTED", Outfitter.cRidingOutfitDescription)..
		         '-- $SETTING DisableBG={Type="Boolean", Label="Don\'t equip in Battlegrounds", Default=true}\n'..
		         '-- $SETTING DisableInstance={Type="Boolean", Label="Don\'t equip in dungeons", Default=true}\n'..
		         '-- $SETTING DisablePVP={Type="Boolean", Label="Don\'t equip while PvP flagged", Default=false}\n'..
		         '-- $SETTING StayEquippedWhileFalling={Type="Boolean", Label="Leave equipped while falling", Default=false}\n'..
		         '-- $SETTING UnequipDelay={Type="Number", Label="Wait", Suffix="seconds before unequipping", Default=0}\n'..
		         '\n'..
		         '-- Equip on mount unless it\'s disabled\n'..
		         '\n'..
		         'if event == "MOUNTED" then\n'..
		         '    -- The disable options are only checked inside the mounting handler.  This way\n'..
		         '    -- the outfit won\'t equip automatically, but if the player chooses to\n'..
		         '    -- manually equip it after mounting, then Outfitter will still unequip\n'..
		         '    -- it for them when they dismount\n'..
		         '\n'..
		         '    local inInstance, instanceType = IsInInstance()\n'..
		         '    if (setting.DisableInstance and inInstance and (instanceType == "raid" or instanceType == "party"))\n'..
		         '    or (setting.DisableBG and Outfitter:InBattlegroundZone())\n'..
		         '    or (setting.DisablePVP and UnitIsPVP("player")) then\n'..
		         '        return\n'..
		         '    end\n'..
		         '\n'..
		         '    equip = true\n'..
		         '\n'..
		         '-- Unequip on dismount\n'..
		         '\n'..
		         'elseif event == "NOT_MOUNTED" then\n'..
		         '    if not setting.StayEquippedWhileFalling then\n'..
		         '        equip = false\n'..
		         '    else\n'..
				 '        self.UnequipWhenNotFalling = true\n'..
				 '        self.DismountTime = GetTime()\n'..
		         '        self:RegisterEvent("TIMER")\n'..
		         '    end\n'..
		         '\n'..
		         '    if setting.UnequipDelay then\n'..
		         '        delay = setting.UnequipDelay\n'..
		         '    end\n'..
		         '\n'..
		         '-- If they\'re still mounted three seconds after casting then assume\n'..
		         '-- it was nothing important and put the riding gear back on\n'..
		         '\n'..
				 'elseif event == "TIMER" then\n'..
		         '    -- Unequip if the player was falling when dismounted and has now landed\n'..
		         '\n'..
		         '    if self.UnequipWhenNotFalling\n'..
		         '    and GetTime() >= self.DismountTime + 1\n'..
		         '    and not IsFalling() then\n'..
		         '        equip = false\n'..
		         '        self.UnequipWhenNotFalling = nil\n'..
		         '    end\n'..
		         '\n'..
				 '    if not self.UnequipWhenNotFalling then\n'..
				 '        self:UnregisterEvent("TIMER")\n'..
				 '    end\n'..
		         'end\n',
	},
	{
		Name = Outfitter.cSwimmingOutfit,
		ID = "Swimming",
		Category = "TRADE",
		Script = Outfitter:GenerateScriptHeader("SWIMMING NOT_SWIMMING", Outfitter.cSwimmingOutfitDescription)..
				'-- $SETTING DisableBG={Type="Boolean", Label="Don\'t equip in Battlegrounds", Default=false}\n'..
				'-- $SETTING DisablePVP={Type="Boolean", Label="Don\'t equip while PvP flagged", Default=false}\n'..
				'\n'..
				'-- Just return if they\'re PvP\'ing and don\'t want the outfit changing\n'..
				'\n'..
				'if (setting.DisableBG and Outfitter:InBattlegroundZone())\n'..
				'or (setting.DisablePVP and UnitIsPVP("player")) then\n'..
				'    return\n'..
				'end\n'..
				'\n'..
				'if event == "SWIMMING" then\n'..
				'    equip = true\n'..
				'elseif didEquip then\n'..
				'    equip = false\n'..
				'    delay = 2.5 -- Use a delay since hitting spacebar temporarily makes the player not swimming\n'..
				'end\n',
	},
	{
		Name = Outfitter.cFishingOutfit,
		ID = "Fishing",
		Category = "TRADE",
		Script = Outfitter:GenerateScriptHeader("PLAYER_REGEN_ENABLED PLAYER_REGEN_DISABLED PLAYER_ENTERING_WORLD OUTFIT_EQUIPPED OUTFIT_UNEQUIPPED PLAYER_AURAS_CHANGED", Outfitter.cFishingOutfitDescription)..
		         '-- $SETTING EquipOnTrackFish = {Type = "Boolean", Label = "Equip whenever Track Fish is selected"}\n'..
		         '-- $SETTING EnableAutoLoot = {Type = "Boolean", Label = "Enable auto loot while equipped"}\n'..
		         '\n'..
		         '-- Enable auto looting if the outfit is being equipped and EnableAutoLoot is on\n'..
		         '\n'..
		         'if event == "OUTFIT_EQUIPPED" then\n'..
		         '    if setting.EnableAutoLoot then\n'..
		         '        setting.savedAutoLoot = GetAutoLootDefault()\n'..
		         '        SetAutoLootDefault(true)\n'..
		         '        setting.didSetAutoLoot = true\n'..
		         '    end\n'..
		         '\n'..
		         '-- Turn auto looting back off if the outfit is being unequipped and we turned it on\n'..
		         '\n'..
		         'elseif event == "OUTFIT_UNEQUIPPED" then\n'..
		         '    if setting.EnableAutoLoot and setting.didSetAutoLoot then\n'..
		         '        SetAutoLootDefault(setting.savedAutoLoot)\n'..
		         '        setting.didSetAutoLoot = nil\n'..
		         '        setting.savedAutoLoot = nil\n'..
		         '    end\n'..
		         '\n'..
		         '-- If the player is entering combat then unequip the outfit\n'..
		         '\n'..
		         'elseif isEquipped and event == "PLAYER_REGEN_DISABLED" then\n'..
		         '    equip = false\n'..
		         '    outfit.didCombatUnequip = true\n'..
		         '\n'..
		         '-- If the outfit was unequipped because of combat\n'..
		         '-- then put it back on when combat is over\n'..
		         '\n'..
		         'elseif outfit.didCombatUnequip and (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD") then\n'..
		         '    equip = true\n'..
		         '    outfit.didCombatUnequip = nil\n'..
		         '\n'..
		         '-- Equip the outfit when tracking is changed to Find Fish, unequip\n'..
		         '-- it if the tracking is changed to something else\n'..
		         '\n'..
		         'elseif event == "PLAYER_AURAS_CHANGED" then \n'..
		         '    local vTrackingFindFish = GetTrackingTexture() == "Interface\\\\Icons\\\\INV_Misc_Fish_02"\n'..
		         '    if outfit.trackingFindFish == vTrackingFindFish then return end\n'..
		         '    outfit.trackingFindFish = vTrackingFindFish\n'..
		         '\n'..
		         '    if not setting.EquipOnTrackFish then return end\n'..
		         '\n'..
		         '    if vTrackingFindFish then\n'..
		         '        equip = true\n'..
		         '        outfit.equippedByFindFish = true\n'..
		         '    elseif outfit.equippedByFindFish then\n'..
		         '        equip = false\n'..
		         '        outfit.equippedByFindFish = nil\n'..
		         '    end\n'..
		         'end\n',
	},
	{
		Name = Outfitter.cDiningOutfit,
		ID = "Dining",
		Category = "TRADE",
		Script = Outfitter:GenerateSmartUnequipScript("DINING", Outfitter.cDiningOutfitDescription),
	},
	{
		Name = Outfitter.cCityOutfit,
		ID = "City",
		Category = "GENERAL",
		Script = Outfitter:GenerateSimpleScript("CITY", Outfitter.cCityOutfitDescription),
	},
	{
		Name = Outfitter.cBattlegroundOutfit,
		ID = "Battleground",
		Category = "PVP",
		Script = Outfitter:GenerateSmartUnequipScript("BATTLEGROUND", Outfitter.cBattlegroundOutfitDescription),
	},
	{
		Name = Outfitter.cABOutfit,
		ID = "AB",
		Category = "PVP",
		Script = Outfitter:GenerateSmartUnequipScript("BATTLEGROUND_AB", Outfitter.cArathiBasinOutfitDescription),
	},
	{
		Name = Outfitter.cAVOutfit,
		ID = "AV",
		Category = "PVP",
		Script = Outfitter:GenerateSmartUnequipScript("BATTLEGROUND_AV", Outfitter.cAlteracValleyOutfitDescription),
	},
	{
		Name = Outfitter.cWSGOutfit,
		ID = "WSG",
		Category = "PVP",
		Script = Outfitter:GenerateSmartUnequipScript("BATTLEGROUND_WSG", Outfitter.cWarsongGulchOutfitDescription),
	},
	{
		Name = Outfitter.cEotSOutfit,
		ID = "EotS",
		Category = "PVP",
		Script = Outfitter:GenerateSmartUnequipScript("BATTLEGROUND_EOTS", Outfitter.cEotSOutfitDescription),
	},
	{
		Name = Outfitter.cArenaOutfit,
		ID = "Arena",
		Category = "PVP",
		Script = Outfitter:GenerateSmartUnequipScript("BATTLEGROUND_ARENA", Outfitter.cArenaOutfitDescription),
	},
	{
		Name = "Spirit Regen",
		ID = "Spirit",
		Category = "GENERAL",
		Script = Outfitter:GenerateSmartUnequipScript("SPIRIT_REGEN", Outfitter.SpiritRegenOutfitDescription, 0.5),
	},
	{
		Name = Outfitter.cWarriorBattleStance,
		ID = "Battle",
		Class = "WARRIOR",
		Script = Outfitter:GenerateShapeshiftScript("BATTLE_STANCE", Outfitter.cWarriorBattleStanceDescription),
	},
	{
		Name = Outfitter.cWarriorDefensiveStance,
		ID = "Defensive",
		Class = "WARRIOR",
		Script = Outfitter:GenerateShapeshiftScript("DEFENSIVE_STANCE", Outfitter.cWarriorDefensiveStanceDescription),
	},
	{
		Name = Outfitter.cWarriorBerserkerStance,
		ID = "Berserker",
		Class = "WARRIOR",
		Script = Outfitter:GenerateShapeshiftScript("BERSERKER_STANCE", Outfitter.cWarriorBerserkerStanceDescription),
	},
	{
		Name = Outfitter.cDruidCasterForm,
		ID = "Caster",
		Class = "DRUID",
		Script = Outfitter:GenerateScriptHeader("CASTER_FORM NOT_CASTER_FORM OUTFIT_EQUIPPED", Outfitter.cDruidCasterFormDescription)..
			'-- $SETTING DisableBG={Type="Boolean", Label="Don\'t equip in Battlegrounds", Default=false}\n'..
			'-- $SETTING DisablePVP={Type="Boolean", Label="Don\'t equip while PvP flagged", Default=false}\n'..
			'\n'..
			'-- Just return if they\'re PvP\'ing and don\'t want the outfit changing\n'..
			'\n'..
			'if (setting.DisableBG and Outfitter:InBattlegroundZone())\n'..
			'or (setting.DisablePVP and UnitIsPVP("player")) then\n'..
			'    return\n'..
			'end\n'..
			'\n'..
			'-- Return if the user isn\'t in full control\n'..
			'\n'..
			'if not Outfitter.IsDead and not HasFullControl() then\n'..
			'    return\n'..
			'end\n'..
			'\n'..
			'-- If the user is manually equipping the outfit, let\n'..
			'-- Outfitter know which layer it\'s representing\n'..
			'\n'..
			'if event == "OUTFIT_EQUIPPED" then\n'..
			'    layer = "shapeshift"\n'..
			'\n'..
			'-- Equip and set the layer if entering caster form.  When\n'..
			'-- shifting directly between forms, WoW temporarily puts\n'..
			'-- the druid in caster form.  To avoid having the caster\n'..
			'-- outfit equip during those changes, a small delay is\n'..
			'-- added to equipping so it can be canceled when the form\n'..
			'-- shift completes.\n'..
			'\n'..
			'elseif event == "CASTER_FORM" then\n'..
			'    equip = true\n'..
			'    layer = "shapeshift"\n'..
			'    delay = 0.1\n'..
			'\n'..
			'-- Unequip if leaving caster form\n'..
			'\n'..
			'else\n'..
			'    equip = false\n'..
			'end\n',
	},
	{
		Name = Outfitter.cDruidBearForm,
		ID = "Bear",
		Class = "DRUID",
		Script = Outfitter:GenerateDruidShapeshiftScript("BEAR_FORM", "This outfit will be worn whenever you're in Bear or Dire Bear Form"),
	},
	{
		Name = Outfitter.cDruidCatForm,
		ID = "Cat",
		Class = "DRUID",
		Script = Outfitter:GenerateDruidShapeshiftScript("CAT_FORM", "This outfit will be worn whenever you're in Cat Form"),
	},
	{
		Name = Outfitter.cDruidAquaticForm,
		ID = "Aquatic",
		Class = "DRUID",
		Script = Outfitter:GenerateDruidShapeshiftScript("AQUATIC_FORM", "This outfit will be worn whenever you're in Aquatic Form"),
	},
	{
		Name = Outfitter.cDruidFlightForm,
		ID = "Flight",
		Class = "DRUID",
		Script = Outfitter:GenerateDruidShapeshiftScript("FLIGHT_FORM", "This outfit will be worn whenever you're in Flight or Swift Flight Form"),
	},
	{
		Name = Outfitter.cDruidTravelForm,
		ID = "Travel",
		Class = "DRUID",
		Script = Outfitter:GenerateDruidShapeshiftScript("TRAVEL_FORM", "This outfit will be worn whenever you're in Travel Form"),
	},
	{
		Name = Outfitter.cDruidMoonkinForm,
		ID = "Moonkin",
		Class = "DRUID",
		Script = Outfitter:GenerateDruidShapeshiftScript("MOONKIN_FORM", "This outfit will be worn whenever you're in Moonkin Form"),
	},
	{
		Name = Outfitter.cDruidTreeOfLifeForm,
		ID = "Tree",
		Class = "DRUID",
		Script = Outfitter:GenerateDruidShapeshiftScript("TREE_FORM", "This outfit will be worn whenever you're in Tree Form"),
	},
	{
		Name = Outfitter.cDruidProwl,
		ID = "Prowl",
		Class = "DRUID",
		Script = Outfitter:GenerateSimpleScript("STEALTH", "This outfit will be worn whenever you're prowling"),
	},
	{
		Name = Outfitter.cRogueStealth,
		ID = "Stealth",
		Class = "ROGUE",
		Script = Outfitter:GenerateSimpleScript("STEALTH", "This outfit will be worn whenever you're stealthed"),
	},
	{
		Name = Outfitter.cPriestShadowform,
		ID = "Shadowform",
		Class = "PRIEST",
		Script = Outfitter:GenerateShapeshiftScript("SHADOWFORM", Outfitter.cPriestShadowformDescription),
	},
	{
		Name = Outfitter.cShamanGhostWolf,
		ID = "GhostWolf",
		Class = "SHAMAN",
		Script = Outfitter:GenerateSimpleScript("GHOST_WOLF", Outfitter.cShamanGhostWolfDescription),
	},
	{
		Name = Outfitter.cHunterMonkey,
		ID = "Monkey",
		Class = "HUNTER",
		Script = Outfitter:GenerateShapeshiftScript("MONKEY_ASPECT", Outfitter.cHunterMonkeyDescription),
	},
	{
		Name = Outfitter.cHunterHawk,
		ID = "Hawk",
		Class = "HUNTER",
		Script = Outfitter:GenerateShapeshiftScript("HAWK_ASPECT", Outfitter.cHunterHawkDescription),
	},
	{
		Name = Outfitter.cHunterCheetah,
		ID = "Cheetah",
		Class = "HUNTER",
		Script = Outfitter:GenerateShapeshiftScript("CHEETAH_ASPECT", Outfitter.cHunterCheetahDescription),
	},
	{
		Name = Outfitter.cHunterPack,
		ID = "Pack",
		Class = "HUNTER",
		Script = Outfitter:GenerateShapeshiftScript("PACK_ASPECT", Outfitter.cHunterPackDescription),
	},
	{
		Name = Outfitter.cHunterBeast,
		ID = "Beast",
		Class = "HUNTER",
		Script = Outfitter:GenerateShapeshiftScript("BEAST_ASPECT", Outfitter.cHunterBeastDescription),
	},
	{
		Name = Outfitter.cHunterWild,
		ID = "Wild",
		Class = "HUNTER",
		Script = Outfitter:GenerateShapeshiftScript("WILD_ASPECT", Outfitter.cHunterWildDescription),
	},
	{
		Name = Outfitter.cHunterViper,
		ID = "Viper",
		Class = "HUNTER",
		Script = Outfitter:GenerateShapeshiftScript("VIPER_ASPECT", Outfitter.cHunterViperDescription),
	},
	{
		Name = Outfitter.cHunterFeignDeath,
		ID = "Feigning",
		Class = "HUNTER",
		Script = Outfitter:GenerateSimpleScript("FEIGN_DEATH", Outfitter.cHunterFeignDeathDescription),
	},
	{
		Name = Outfitter.cMageEvocate,
		ID = "Evocate",
		Class = "MAGE",
		Script = Outfitter:GenerateSimpleScript("EVOCATE", Outfitter.cMageEvocateDescription),
	},
	{
		Name = Outfitter.cSoloOutfit,
		ID = "SOLO",
		Category = "GENERAL",
		Script = Outfitter:GenerateScriptHeader("PLAYER_ENTERING_WORLD RAID_ROSTER_UPDATE PARTY_MEMBERS_CHANGED", Outfitter.cSoloOutfitDescription)..
			'-- $SETTING EquipSolo = {Label="Equip when solo", Type = "Boolean"}\n'..
			'-- $SETTING EquipGroup = {Label="Equip when in a party", Type = "Boolean"}\n'..
			'-- $SETTING EquipRaid = {Label="Equip when in a raid", Type = "Boolean"}\n'..
			'\n'..
			'if setting.EquipSolo\n'..
			'and GetNumRaidMembers() == 0\n'..
			'and GetNumPartyMembers() == 0 then\n'..
			'    equip = true\n'..
			'elseif setting.EquipGroup\n'..
			'and GetNumRaidMembers() == 0\n'..
			'and GetNumPartyMembers() ~= 0 then\n'..
			'    equip = true\n'..
			'elseif setting.EquipRaid\n'..
			'and GetNumRaidMembers() ~= 0 then\n'..
			'    equip = true\n'..
			'elseif didEquip then\n'..
			'    equip = false\n'..
			'end\n',
	},
	{
		Name = Outfitter.cFallingOutfit,
		ID = "FALLING",
		Category = "GENERAL",
		Script = Outfitter:GenerateScriptHeader("TIMER", Outfitter.cFallingOutfitDescription)..
			'if IsFalling() then\n'..
			'    equip = true\n'..
			'    delay = 1.5\n'..
			'elseif didEquip then\n'..
			'    equip = false\n'..
			'end\n',
	},
}

Outfitter.cScriptCategoryOrder =
{
	GENERAL = 0,
	TRADE = 1,
	PVP = 2,
}

table.sort(
		Outfitter.PresetScripts,
		function (pItem1, pItem2)
			if pItem1.Category ~= pItem2.Category then
				if not pItem1.Category then
					return true
				elseif not pItem2.Category then
					return false
				else
					return Outfitter.cScriptCategoryOrder[pItem1.Category] < Outfitter.cScriptCategoryOrder[pItem2.Category]
				end
			elseif not pItem2.Name then
				return false
			elseif not pItem1.Name then
				return true
			else
				return pItem1.Name < pItem2.Name
			end
		end)

Outfitter.cCategoryDescriptions =
{
	Complete = Outfitter.cCompleteCategoryDescription,
	Accessory = Outfitter.cAccessoryCategoryDescription,
	OddsNEnds = Outfitter.cOddsNEndsCategoryDescription,
}

Outfitter.cSlotNames =
{
	-- First priority goes to armor
	
	"HeadSlot",
	"ShoulderSlot",
	"ChestSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	
	-- Second priority goes to weapons
	
	"MainHandSlot",
	"SecondaryHandSlot",
	"RangedSlot",
	"AmmoSlot",
	
	-- Last priority goes to items with no durability
	
	"BackSlot",
	"NeckSlot",
	"ShirtSlot",
	"TabardSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
}

Outfitter.cSlotDisplayNames =
{
	HeadSlot = HEADSLOT,
	NeckSlot = NECKSLOT,
	ShoulderSlot = SHOULDERSLOT,
	BackSlot = BACKSLOT,
	ChestSlot = CHESTSLOT,
	ShirtSlot = SHIRTSLOT,
	TabardSlot = TABARDSLOT,
	WristSlot = WRISTSLOT,
	HandsSlot = HANDSSLOT,
	WaistSlot = WAISTSLOT,
	LegsSlot = LEGSSLOT,
	FeetSlot = FEETSLOT,
	Finger0Slot = Outfitter.cFinger0SlotName,
	Finger1Slot = Outfitter.cFinger1SlotName,
	Trinket0Slot = Outfitter.cTrinket0SlotName,
	Trinket1Slot = Outfitter.cTrinket1SlotName,
	MainHandSlot = MAINHANDSLOT,
	SecondaryHandSlot = SECONDARYHANDSLOT,
	RangedSlot = RANGEDSLOT,
	AmmoSlot = AMMOSLOT,
}

Outfitter.cInvTypeToSlotName =
{
	INVTYPE_2HWEAPON = {SlotName = "MainHandSlot", MetaSlotName = "TwoHandSlot"},
	INVTYPE_BAG = {SlotName = "Bag"},
	INVTYPE_BODY = {SlotName = "ShirtSlot"},
	INVTYPE_CHEST = {SlotName = "ChestSlot"},
	INVTYPE_CLOAK = {SlotName = "BackSlot"},
	INVTYPE_FEET = {SlotName = "FeetSlot"},
	INVTYPE_FINGER = {SlotName = "Finger0Slot"},
	INVTYPE_HAND = {SlotName = "HandsSlot"},
	INVTYPE_HEAD = {SlotName = "HeadSlot"},
	INVTYPE_HOLDABLE = {SlotName = "SecondaryHandSlot"},
	INVTYPE_LEGS = {SlotName = "LegsSlot"},
	INVTYPE_NECK = {SlotName = "NeckSlot"},
	INVTYPE_RANGED = {SlotName = "RangedSlot"},
	INVTYPE_ROBE = {SlotName = "ChestSlot"},
	INVTYPE_SHIELD = {SlotName = "SecondaryHandSlot"},
	INVTYPE_SHOULDER = {SlotName = "ShoulderSlot"},
	INVTYPE_TABARD = {SlotName = "TabardSlot"},
	INVTYPE_TRINKET = {SlotName = "Trinket0Slot"},
	INVTYPE_WAIST = {SlotName = "WaistSlot"},
	INVTYPE_WEAPON = {SlotName = "MainHandSlot", MetaSlotName = "Weapon0Slot"},
	INVTYPE_WEAPONMAINHAND = {SlotName = "MainHandSlot"},
	INVTYPE_WEAPONOFFHAND = {SlotName = "SecondaryHandSlot"},
	INVTYPE_WRIST = {SlotName = "WristSlot"},
	INVTYPE_RANGEDRIGHT = {SlotName = "RangedSlot"},
	INVTYPE_AMMO = {SlotName = "AmmoSlot"},
	INVTYPE_THROWN = {SlotName = "RangedSlot"},
	INVTYPE_RELIC = {SlotName = "RangedSlot"},
}

Outfitter.cHalfAlternateStatSlot =
{
	Trinket0Slot = "Trinket1Slot",
	Finger0Slot = "Finger1Slot",
	Weapon0Slot = "Weapon1Slot",
}

Outfitter.cFullAlternateStatSlot =
{
	Trinket0Slot = "Trinket1Slot",
	Trinket1Slot = "Trinket0Slot",
	Finger0Slot = "Finger1Slot",
	Finger1Slot = "Finger0Slot",
	Weapon0Slot = "Weapon1Slot",
	Weapon1Slot = "Weapon0Slot",
}

Outfitter.cCategoryOrder =
{
	"Complete",
	"Accessory"
}

Outfitter.cItemAliases =
{
	[18608] = 18609,	-- Benediction -> Anathema
	[18609] = 18608,	-- Anathema -> Benediction
	[17223] = 17074,	-- Thunderstrike -> Shadowstrike
	[17074] = 17223,	-- Shadowstrike -> Thunderstrike
}

Outfitter.cFishingPoles =
{
	{Code = 25978, SubCode = 0}, -- Seth's Graphite Fishing Pole
	{Code = 19970, SubCode = 0}, -- Arcanite Fishing Pole
	{Code = 19022, SubCode = 0}, -- Nat Pagles Fishing Pole
	{Code = 12224, SubCode = 0}, -- Blump Family Fishing Pole
	{Code = 6367, SubCode = 0}, -- Big Iron Fishing Pole
	{Code = 6365, SubCode = 0}, -- Strong Fishing Pole
	{Code = 6256, SubCode = 0}, -- Fishing Pole
}

Outfitter.cRidingItems =
{
	{Code = 11122, SubCode = 0}, -- Carrot on a Stick
	{Code = 25653, SubCode = 0}, -- Riding Crop
}

Outfitter.cArgentDawnTrinkets = 
{
	{Code = 13209, SubCode = 0}, -- Seal of the Dawn
	{Code = 19812, SubCode = 0}, -- Rune of the Dawn
	{Code = 12846, SubCode = 0}, -- Argent Dawn Commission
}

Outfitter.cStatIDItems =
{
	Fishing = Outfitter.cFishingPoles,
	Riding = Outfitter.cRidingItems,
	ArgentDawn = Outfitter.cArgentDawnTrinkets,
}

Outfitter.cIgnoredUnusedItems = 
{
	[2901] = "Mining Pick",
	[5956] = "Blacksmith hammer",
	[6219] = "Arclight Spanner",
	[7005] = "Skinning Knife",
	[7297] = "Morbent's Bane",
	[10696] = "Enchanted Azsharite Felbane Sword",
	[10697] = "Enchanted Azsharite Felbane Dagger",
	[10698] = "Enchanted Azsharite Felbane Staff",
	[20406] = "Twilight Cultist Mantle",
	[20407] = "Twilight Cultist Robe",
	[20408] = "Twilight Cultist Cowl",
}

Outfitter.cSmartOutfits =
{
	{Name = Outfitter.cFishingOutfit, StatID = "Fishing", ScriptID = "Fishing"},
	{Name = Outfitter.cHerbalismOutfit, StatID = "Herbalism", ScriptID = "Herbalism"},
	{Name = Outfitter.cMiningOutfit, StatID = "Mining", ScriptID = "Mining"},
	{Name = Outfitter.cSkinningOutfit, StatID = "Skinning", ScriptID = "Skinning"},
	{Name = Outfitter.cFireResistOutfit, StatID = "FireResist"},
	{Name = Outfitter.cNatureResistOutfit, StatID = "NatureResist"},
	{Name = Outfitter.cShadowResistOutfit, StatID = "ShadowResist"},
	{Name = Outfitter.cArcaneResistOutfit, StatID = "ArcaneResist"},
	{Name = Outfitter.cFrostResistOutfit, StatID = "FrostResist"},
}

Outfitter.cStatCategoryInfo =
{
	{Category = "Stat", Name = Outfitter.cStatsCategory},
	{Category = "Melee", Name = Outfitter.cMeleeCategory},
	{Category = "Spell", Name = Outfitter.cSpellsCategory},
	{Category = "Regen", Name = Outfitter.cRegenCategory},
	{Category = "Resist", Name = Outfitter.cResistCategory},
	{Category = "Trade", Name = Outfitter.cTradeCategory},
}

Outfitter.cItemStatInfo =
{
	{ID = "Agility", Name = Outfitter.cAgilityStatName, Category = "Stat"},
	{ID = "Intellect", Name = Outfitter.cIntellectStatName, Category = "Stat"},
	{ID = "Spirit", Name = Outfitter.cSpiritStatName, Category = "Stat"},
	{ID = "Stamina", Name = Outfitter.cStaminaStatName, Category = "Stat"},
	{ID = "Strength", Name = Outfitter.cStrengthStatName, Category = "Stat"},
	{ID = "Health", Name = Outfitter.cHealthStatName, Category = "Stat"},
	{ID = "Mana", Name = Outfitter.cManaStatName, Category = "Stat"},
	{ID = "TotalStats", Name = Outfitter.cTotalStatsName, Category = "Stat"},
	
	{ID = "ManaRegen", Name = Outfitter.cManaRegenStatName, Category = "Regen"},
	{ID = "CombatManaRegen", Name = Outfitter.cCombatManaRegenStatName, Category = "Regen"},
	{ID = "HealthRegen", Name = Outfitter.cHealthRegenStatName, Category = "Regen"},
	{ID = "CombatHealthRegen", Name = Outfitter.cCombatHealthRegenStatName, Category = "Regen"},
	
	{ID = "SpellCrit", Name = Outfitter.cSpellCritStatName, Category = "Spell"},
	{ID = "SpellHit", Name = Outfitter.cSpellHitStatName, Category = "Spell"},
	{ID = "SpellHaste", Name = Outfitter.cSpellHasteStatName, Category = "Spell"},
	{ID = "SpellDmg", Name = Outfitter.cSpellDmgStatName, Category = "Spell"},
	{ID = "FrostDmg", Name = Outfitter.cFrostDmgStatName, Category = "Spell"},
	{ID = "FireDmg", Name = Outfitter.cFireDmgStatName, Category = "Spell"},
	{ID = "ArcaneDmg", Name = Outfitter.cArcaneDmgStatName, Category = "Spell"},
	{ID = "ShadowDmg", Name = Outfitter.cShadowDmgStatName, Category = "Spell"},
	{ID = "NatureDmg", Name = Outfitter.cNatureDmgStatName, Category = "Spell"},
	{ID = "Healing", Name = Outfitter.cHealingStatName, Category = "Spell"},
	
	{ID = "Armor", Name = Outfitter.cArmorStatName, Category = "Melee"},
	{ID = "Defense", Name = Outfitter.cDefenseStatName, Category = "Melee"},
	{ID = "Dodge", Name = Outfitter.cDodgeStatName, Category = "Melee"},
	{ID = "Parry", Name = Outfitter.cParryStatName, Category = "Melee"},
	{ID = "Block", Name = Outfitter.cBlockStatName, Category = "Melee"},
	{ID = "Resilience", Name = Outfitter.cResilienceStatName, Category = "Melee"},
	{ID = "MeleeDmg", Name = Outfitter.cMeleeDmgStatName, Category = "Melee"},
	{ID = "MeleeCrit", Name = Outfitter.cMeleeCritStatName, Category = "Melee"},
	{ID = "MeleeHit", Name = Outfitter.cMeleeHitStatName, Category = "Melee"},
	{ID = "MeleeHaste", Name = Outfitter.cMeleeHasteStatName, Category = "Melee"},
	
	{ID = "Attack", Name = Outfitter.cAttackStatName, Category = "Melee"},
	{ID = "RangedAttack", Name = Outfitter.cRangedAttackStatName, Category = "Melee"},
	
	{ID = "ArcaneResist", Name = Outfitter.cArcaneResistStatName, Category = "Resist"},
	{ID = "FireResist", Name = Outfitter.cFireResistStatName, Category = "Resist"},
	{ID = "FrostResist", Name = Outfitter.cFrostResistStatName, Category = "Resist"},
	{ID = "NatureResist", Name = Outfitter.cNatureResistStatName, Category = "Resist"},
	{ID = "ShadowResist", Name = Outfitter.cShadowResistStatName, Category = "Resist"},
	
	{ID = "Fishing", Name = Outfitter.cFishingStatName, Category = "Trade"},
	{ID = "Herbalism", Name = Outfitter.cHerbalismStatName, Category = "Trade"},
	{ID = "Mining", Name = Outfitter.cMiningStatName, Category = "Trade"},
	{ID = "Skinning", Name = Outfitter.cSkinningStatName, Category = "Trade"},
}

Outfitter.cSpecialIDEvents =
{
	Battle = {Equip = "BATTLE_STANCE", Unequip = "NOT_BATTLE_STANCE"},
	Defensive = {Equip = "DEFENSIVE_STANCE", Unequip = "NOT_DEFENSIVE_STANCE"},
	Berserker = {Equip = "BERSERKER_STANCE", Unequip = "NOT_BERSERKER_STANCE"},
	
	Bear = {Equip = "BEAR_FORM", Unequip = "NOT_BEAR_FORM"},
	Cat = {Equip = "CAT_FORM", Unequip = "NOT_CAT_FORM"},
	Aquatic = {Equip = "AQUATIC_FORM", Unequip = "NOT_AQUATIC_FORM"},
	Travel = {Equip = "TRAVEL_FORM", Unequip = "NOT_TRAVEL_FORM"},
	Moonkin = {Equip = "MOONKIN_FORM", Unequip = "NOT_MOONKIN_FORM"},
	Tree = {Equip = "TREE_FORM", Unequip = "NOT_TREE_FORM"},
	Prowl = {Equip = "STEALTH", Unequip = "NOT_STEALTH"},
	Flight = {Equip = "FLIGHT_FORM", Unequip = "NOT_FLIGHT_FORM"},
	Caster = {Equip = "CASTER_FORM", Unequip = "NOT_CASTER_FORM"},
	
	Shadowform = {Equip = "SHADOWFORM", Unequip = "NOT_SHADOWFORM"},

	Stealth = {Equip = "STEALTH", Unequip = "NOT_STEALTH"},

	GhostWolf = {Equip = "GHOST_WOLF", Unequip = "NOT_GHOST_WOLF"},

	Monkey = {Equip = "MONKEY_ASPECT", Unequip = "NOT_MONKEY_ASPECT"},
	Hawk = {Equip = "HAWK_ASPECT", Unequip = "NOT_HAWK_ASPECT"},
	Cheetah = {Equip = "CHEETAH_ASPECT", Unequip = "NOT_CHEETAH_ASPECT"},
	Pack = {Equip = "PACK_ASPECT", Unequip = "NOT_PACK_ASPECT"},
	Beast = {Equip = "BEAST_ASPECT", Unequip = "NOT_BEAST_ASPECT"},
	Wild = {Equip = "WILD_ASPECT", Unequip = "NOT_WILD_ASPECT"},
	Viper = {Equip = "VIPER_ASPECT", Unequip = "NOT_VIPER_ASPECT"},
	Feigning = {Equip = "FEIGN_DEATH", Unequip = "NOT_FEIGN_DEATH"},
	
	Evocate = {Equip = "EVOCATE", Unequip = "NOT_EVOCATE"},
	
	Dining = {Equip = "DINING", Unequip = "NOT_DINING"},
	City = {Equip = "CITY", Unequip = "NOT_CITY"},
	Riding = {Equip = "MOUNTED", Unequip = "NOT_MOUNTED"},
	Swimming = {Equip = "SWIMMING", Unequip = "NOT_SWIMMING"},
	Spirit = {Equip = "SPIRIT_REGEN", Unequip = "NOT_SPIRIT_REGEN"},
	ArgentDawn = {Equip = "ARGENT_DAWN", Unequip = "NOT_ARGENT_DAWN"},

	Battleground = {Equip = "BATTLEGROUND", Unequip = "NOT_BATTLEGROUND"},
	AB = {Equip = "BATTLEGROUND_AB", Unequip = "NOT_BATTLEGROUND_AB"},
	AV = {Equip = "BATTLEGROUND_AV", Unequip = "NOT_BATTLEGROUND_AV"},
	WSG = {Equip = "BATTLEGROUND_WSG", Unequip = "NOT_BATTLEGROUND_WSG"},
	EotS = {Equip = "BATTLEGROUND_EOTS", Unequip = "NOT_BATTLEGROUND_EOTS"},
	Arena = {Equip = "BATTLEGROUND_ARENA", Unequip = "NOT_BATTLEGROUND_ARENA"},
	BladesEdgeArena = {Equip = "BATTLEGROUND_BLADESEDGE", Unequip = "NOT_BATTLEGROUND_BLADESEDGE"},
	NagrandArena = {Equip = "BATTLEGROUND_NAGRAND", Unequip = "NOT_BATTLEGROUND_NAGRAND"},
	LordaeronArena = {Equip = "BATTLEGROUND_LORDAERON", Unequip = "NOT_BATTLEGROUND_LORDAERON"},
}

Outfitter.cClassSpecialOutfits =
{
	WARRIOR =
	{
		{Name = Outfitter.cWarriorBattleStance, ScriptID = "Battle"},
		{Name = Outfitter.cWarriorDefensiveStance, ScriptID = "Defensive"},
		{Name = Outfitter.cWarriorBerserkerStance, ScriptID = "Berserker"},
	},
	
	DRUID =
	{
		{Name = Outfitter.cDruidCasterForm, ScriptID = "Caster"},
		{Name = Outfitter.cDruidBearForm, ScriptID = "Bear"},
		{Name = Outfitter.cDruidCatForm, ScriptID = "Cat"},
		{Name = Outfitter.cDruidAquaticForm, ScriptID = "Aquatic"},
		{Name = Outfitter.cDruidTravelForm, ScriptID = "Travel"},
		{Name = Outfitter.cDruidMoonkinForm, ScriptID = "Moonkin"},
		{Name = Outfitter.cDruidTreeOfLifeForm, ScriptID = "Tree"},
		{Name = Outfitter.cDruidProwl, ScriptID = "Prowl"},
		{Name = Outfitter.cDruidFlightForm, ScriptID = "Flight"},
	},
	
	PRIEST =
	{
		{Name = Outfitter.cPriestShadowform, ScriptID = "Shadowform"},
	},
	
	ROGUE =
	{
		{Name = Outfitter.cRogueStealth, ScriptID = "Stealth"},
	},
	
	SHAMAN =
	{
		{Name = Outfitter.cShamanGhostWolf, ScriptID = "GhostWolf"},
	},
	
	HUNTER =
	{
		{Name = Outfitter.cHunterMonkey, ScriptID = "Monkey"},
		{Name = Outfitter.cHunterHawk, ScriptID = "Hawk"},
		{Name = Outfitter.cHunterCheetah, ScriptID = "Cheetah"},
		{Name = Outfitter.cHunterPack, ScriptID = "Pack"},
		{Name = Outfitter.cHunterBeast, ScriptID = "Beast"},
		{Name = Outfitter.cHunterWild, ScriptID = "Wild"},
		{Name = Outfitter.cHunterViper, ScriptID = "Viper"},
	},
	
	MAGE =
	{
		{Name = Outfitter.cMageEvocate, ScriptID = "Evocate"},
	},
}

Outfitter.cSpellNameSpecialID =
{
	[Outfitter.cAspectOfTheCheetah] = "Cheetah",
	[Outfitter.cAspectOfThePack] = "Pack",
	[Outfitter.cAspectOfTheBeast] = "Beast",
	[Outfitter.cAspectOfTheWild] = "Wild",
	[Outfitter.cAspectOfTheViper] = "Viper",
	[Outfitter.cEvocate] = "Evocate",
}

Outfitter.cAuraIconSpecialID =
{
	["INV_Misc_Fork&Knife"] = "Dining",
	["Spell_Shadow_Shadowform"] = "Shadowform",
	["Spell_Nature_SpiritWolf"] = "GhostWolf",
	["Ability_Rogue_FeignDeath"] = "Feigning",
	["Ability_Hunter_AspectOfTheMonkey"] = "Monkey",
	["Spell_Nature_RavenForm"] = "Hawk",
	[Outfitter.cProwl] = "Prowl",
}

-- Note that zone special outfits will be worn in the order
-- the are listed here, with later outfits being worn over
-- earlier outfits (when they're being applied at the same time)
-- This allows BG-specific outfits to take priority over the generic
-- BG outfit

Outfitter.cZoneSpecialIDs =
{
	"ArgentDawn",
	"City",
	"Battleground",
	"AV",
	"AB",
	"WSG",
	"Arena",
	"BladesEdgeArena",
	"NagrandArena",
	"LordaeronArena",
	"EotS",
}

Outfitter.cZoneSpecialIDMap =
{
	[Outfitter.cWesternPlaguelands] = {"ArgentDawn"},
	[Outfitter.cEasternPlaguelands] = {"ArgentDawn"},
	[Outfitter.cStratholme] = {"ArgentDawn"},
	[Outfitter.cScholomance] = {"ArgentDawn"},
	[Outfitter.cNaxxramas] = {"ArgentDawn", "Naxx"},
	[Outfitter.cAlteracValley] = {"Battleground", "AV"},
	[Outfitter.cArathiBasin] = {"Battleground", "AB"},
	[Outfitter.cWarsongGulch] = {"Battleground", "WSG"},
	[Outfitter.cEotS] = {"Battleground", "EotS"},
	[Outfitter.cBladesEdgeArena] = {"Battleground", "BladesEdgeArena", "Arena"},
	[Outfitter.cNagrandArena] = {"Battleground", "NagrandArena", "Arena"},
	[Outfitter.cRuinsOfLordaeron] = {"Battleground", "LordaeronArena", "Arena"},
	[Outfitter.cIronforge] = {"City"},
	[Outfitter.cCityOfIronforge] = {"City"},
	[Outfitter.cDarnassus] = {"City"},
	[Outfitter.cStormwind] = {"City"},
	[Outfitter.cOrgrimmar] = {"City"},
	[Outfitter.cThunderBluff] = {"City"},
	[Outfitter.cUndercity] = {"City"},
	[Outfitter.cSilvermoon] = {"City"},
	[Outfitter.cExodar] = {"City"},
	[Outfitter.cShattrath] = {"City"},
}

Outfitter.cCombatEquipmentSlots =
{
	MainHandSlot = true,
	SecondaryHandSlot = true,
	RangedSlot = true,
	AmmoSlot = true,
}

Outfitter.EquippableItems = nil

Outfitter.cMaxDisplayedItems = 14

Outfitter.cPanelFrames =
{
	"OutfitterMainFrame",
	"OutfitterOptionsFrame",
	"OutfitterAboutFrame",
}

Outfitter.cShapeshiftInfo =
{
	-- Warriors
	
	[Outfitter.cBattleStance] = {ID = "Battle", Type = "WARSTANCE"},
	[Outfitter.cDefensiveStance] = {ID = "Defensive", Type = "WARSTANCE"},
	[Outfitter.cBerserkerStance] = {ID = "Berserker", Type = "WARSTANCE"},
	
	-- Druids
	
	[Outfitter.cBearForm] = {ID = "Bear", Type = "DRUIDFORM", MaybeInCombat = true},
	[Outfitter.cCatForm] = {ID = "Cat", Type = "DRUIDFORM"},
	[Outfitter.cAquaticForm] = {ID = "Aquatic", Type = "DRUIDFORM"},
	[Outfitter.cTravelForm] = {ID = "Travel", Type = "DRUIDFORM"},
	[Outfitter.cDireBearForm] = {ID = "Bear", Type = "DRUIDFORM"},
	[Outfitter.cMoonkinForm] = {ID = "Moonkin", Type = "DRUIDFORM"},
	[Outfitter.cTreeOfLifeForm] = {ID = "Tree", Type = "DRUIDFORM"},
	[Outfitter.cFlightForm] = {ID = "Flight", Type = "DRUIDFORM"},
	[Outfitter.cSwiftFlightForm] = {ID = "Flight", Type = "DRUIDFORM"},
	CasterForm = {ID = "Caster", Type = "DRUIDFORM"}, -- this is a psuedo-form which is active when no other druid form is
	
	-- Rogues
	
	[Outfitter.cStealth] = {ID = "Stealth"},
}

Outfitter.cShapeshiftTypes =
{
	Battle = "WARSTANCE",
	Defensive = "WARSTANCE",
	Berserker = "WARSTANCE",

	Bear = "DRUIDFORM",
	Cat = "DRUIDFORM",
	Aquatic = "DRUIDFORM",
	Travel = "DRUIDFORM",
	Bear = "DRUIDFORM",
	Moonkin = "DRUIDFORM",
	Tree = "DRUIDFORM",
	Flight = "DRUIDFORM",
	Caster = "DRUIDFORM",
}

StaticPopupDialogs.OUTFITTER_CONFIRM_DELETE =
{
	text = TEXT(Outfitter.cConfirmDeleteMsg),
	button1 = TEXT(DELETE),
	button2 = TEXT(CANCEL),
	OnAccept = function() Outfitter:DeleteSelectedOutfit() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs.OUTFITTER_CONFIRM_REBUILD =
{
	text = TEXT(Outfitter.cConfirmRebuildMsg),
	button1 = TEXT(Outfitter.cRebuild),
	button2 = TEXT(CANCEL),
	OnAccept = function() Outfitter:RebuildOutfit(Outfitter.OutfitToRebuild) Outfitter.OutfitToRebuild = nil end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

StaticPopupDialogs.OUTFITTER_CONFIRM_SET_CURRENT =
{
	text = TEXT(Outfitter.cConfirmSetCurrentMsg),
	button1 = TEXT(Outfitter.cSetCurrent),
	button2 = TEXT(CANCEL),
	OnAccept = function() Outfitter:SetOutfitToCurrent(Outfitter.OutfitToRebuild); Outfitter.OutfitToRebuild = nil end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

function Outfitter:ToggleOutfitterFrame()
	if Outfitter:IsOpen() then
		OutfitterFrame:Hide()
	else
		OutfitterFrame:Show()
	end
end

function Outfitter:IsOpen()
	return OutfitterFrame:IsVisible()
end

function Outfitter:OnLoad()
	for vEventID, _ in pairs(Outfitter.cInitializationEvents) do
		MCEventLib:RegisterEvent(vEventID, self.InitializationCheck, self)
	end
end

function Outfitter:OnShow()
	Outfitter.SetFrameLevel(OutfitterFrame, PaperDollFrame:GetFrameLevel() - 1)
	
	Outfitter:ShowPanel(1) -- Always switch to the main view when showing the window
end

function Outfitter:OnHide()
	Outfitter:ClearSelection()
	
	if Outfitter.QuickSlots then
		Outfitter.QuickSlots:Close()
	end
	
	OutfitterFrame:Hide()  -- This seems redundant, but the OnHide handler gets called
	                       -- in response to the parent being hidden (the character window)
	                       -- so calling Hide() on the frame here ensures that when the
	                       -- character window is hidden then Outfitter won't be displayed
	                       -- next time it's opened
end

function Outfitter:SchedulePlayerEnteringWorld()
	MCSchedulerLib:RescheduleTask(0.05, self.PlayerEnteringWorld, self)
end

function Outfitter:PlayerEnteringWorld()
	self.IsCasting = false
	self.IsChanneling = false
	
	self:BeginEquipmentUpdate()
	
	self.ItemList_FlushEquippableItems()
	
	self:RegenEnabled()
	self:UpdateAuraStates()
	
	self:ScheduleUpdateZone()
	
	self:SetSpecialOutfitEnabled("Riding", false)
	
	self:ResumeLoadScreenEvents()
	self:EndEquipmentUpdate()
end

function Outfitter:PlayerLeavingWorld()
	-- To improve load screen performance, suspend events which are
	-- fired repeatedly and rapidly during zoning
	
	self.Suspended = true
	
	MCEventLib:UnregisterEvent("BAG_UPDATE", self.BagUpdate, self)
	MCEventLib:UnregisterEvent("UNIT_INVENTORY_CHANGED", self.UnitInventoryChanged, self)
	MCEventLib:UnregisterEvent("PLAYER_AURAS_CHANGED", self.UpdateAuraStates, self)
	MCEventLib:UnregisterEvent("PLAYERBANKSLOTS_CHANGED", self.BankSlotsChanged, self)
end

function Outfitter:ResumeLoadScreenEvents()
	if Outfitter.Suspended then
		-- To improve load screen performance, suspend events which are
		-- fired repeatedly and rapidly during zoning
		
		Outfitter.Suspended = false

		MCEventLib:RegisterEvent("BAG_UPDATE", Outfitter.BagUpdate, Outfitter)
		MCEventLib:RegisterEvent("UNIT_INVENTORY_CHANGED", Outfitter.UnitInventoryChanged, Outfitter)
		MCEventLib:RegisterEvent("PLAYER_AURAS_CHANGED", Outfitter.UpdateAuraStates, Outfitter)
		MCEventLib:RegisterEvent("PLAYERBANKSLOTS_CHANGED", Outfitter.BankSlotsChanged, Outfitter)
		
		Outfitter:ScheduleSynch()
	end
end

function Outfitter:VariablesLoaded()
	Outfitter.Settings = gOutfitter_Settings
	
	Outfitter.OriginalStaticPopup_EscapePressed = StaticPopup_EscapePressed
	StaticPopup_EscapePressed = Outfitter.StaticPopup_EscapePressed
end

function Outfitter:BankSlotsChanged()
	Outfitter:ScheduleSynch()
end

function Outfitter:BagUpdate()
	Outfitter:ScheduleSynch()
end

Outfitter.OutfitEvents = {}

function Outfitter:RegisterOutfitEvent(pEvent, pFunction)
	local vHandlers = Outfitter.OutfitEvents[pEvent]
	
	if not vHandlers then
		vHandlers = {}
		Outfitter.OutfitEvents[pEvent] = vHandlers
	end
	
	table.insert(vHandlers, pFunction)
end

function Outfitter:UnregisterOutfitEvent(pEvent, pFunction)
	local vHandlers = Outfitter.OutfitEvents[pEvent]
	
	if not vHandlers then
		return
	end
	
	for vIndex, vFunction in ipairs(vHandlers) do
		if vFunction == pFunction then
			table.remove(vHandlers, vIndex)
			return
		end
	end
end

function Outfitter:DispatchOutfitEvent(pEvent, pParameter1, pParameter2)
	-- Don't send out events until we're initialized
	
	if not Outfitter.Initialized then
		return
	end
	
	-- Post a message
	
	local vHandlers = Outfitter.OutfitEvents[pEvent]
	
	if vHandlers then
		for _, vFunction in ipairs(vHandlers) do
			-- Call in protected mode so that if they fail it doesn't
			-- screw up Outfitter or other addons wishing to be notified
			
			local vSucceeded, vMessage = pcall(vFunction, pEvent, pParameter1, pParameter2)
			
			if vMessage then
				self:ErrorMessage("Error dispatching event "..pEvent)
				self:ErrorMessage(vMessage)
			end
		end
	end
	
	local vEventID
	
	if pEvent == "WEAR_OUTFIT" then
		vEventID = "OUTFIT_EQUIPPED"
	elseif pEvent == "UNWEAR_OUTFIT" then
		vEventID = "OUTFIT_UNEQUIPPED"
	end
	
	local vOutfits = Outfitter.OutfitScriptEvents[vEventID]
	
	if vOutfits then
		local vScriptContext = vOutfits[pParameter2]
		
		if vScriptContext then
			local vSucceeded, vMessage = pcall(vScriptContext.Function, vScriptContext, vEventID)
			
			if vMessage then
				self:ErrorMessage("Error dispatching outfit event %s", pEvent or "nil")
				self:ErrorMessage(vMessage)
			end
		end
	end

	-- Translate to the event ids for dispatch through the event system
	
	if pEvent == "WEAR_OUTFIT" then
		MCEventLib:DispatchEvent("WEAROUTFIT")
	elseif pEvent == "UNWEAR_OUTFIT" then
		MCEventLib:DispatchEvent("UNWEAROUTFIT")
	end

	-- Set the correct Helm and Cloak settings.
	
	MCSchedulerLib:ScheduleUniqueTask(0.5, Outfitter.OutfitStack.UpdateHelmAndCloakVisibility, Outfitter.OutfitStack)
end

function Outfitter:BankFrameOpened()
	self.BankFrameIsOpen = true
	self:BankSlotsChanged()
end

function Outfitter:BankFrameClosed()
	self.BankFrameIsOpen = false
	self:BankSlotsChanged()
end

function Outfitter:RegenDisabled(pEvent)
	self.InCombat = true
	
	if self.OutfitBar then
		self.OutfitBar:AdjustAlpha()
	end
end

function Outfitter:RegenEnabled(pEvent)
	Outfitter:BeginEquipmentUpdate()
	self.InCombat = false
	Outfitter:EndEquipmentUpdate()
	
	if Outfitter.OutfitBar then
		Outfitter.OutfitBar:AdjustAlpha()
	end
end

function Outfitter:PlayerDead(pEvent)
	self.IsDead = true
end

function Outfitter:PlayerAlive(pEvent)
	if UnitIsDeadOrGhost("player") then
		return
	end
	
	self:BeginEquipmentUpdate()
	self.IsDead = false
	self:UpdateAuraStates()
	self:EndEquipmentUpdate()
end

function Outfitter:UnitHealthOrManaChanged(pUnitID)
	if pUnitID ~= "player" then
		return
	end
	
	Outfitter:BeginEquipmentUpdate()
	
	-- Check to see if the player is full while dining
	
	if Outfitter.SpecialState.Dining
	and Outfitter:PlayerIsFull() then
		Outfitter:SetSpecialOutfitEnabled("Dining", false)
	end
	
	-- If the mana drops, see if there was a recent spellcast
	
	local vPlayerMana = UnitMana("player")
	
	if vPlayerMana and (not self.PreviousManaLevel or vPlayerMana < self.PreviousManaLevel) then
		local vTime = GetTime()
		
		if self.SpellcastSentTime and vTime < self.SpellcastSentTime + 10 then
			self.SpellcastSentTime = nil
			
			-- Five second rule has begun
			
			if Outfitter.SpiritRegenEnabled then
				Outfitter.SpiritRegenEnabled = false
				Outfitter:SetSpecialOutfitEnabled("Spirit", false)
			end
			
			MCSchedulerLib:RescheduleTask(5.0, Outfitter.SpiritRegenTimer, Outfitter)
		end
	end
	
	self.PreviousManaLevel = vPlayerMana
	
	--
	
	if self.SpellcastSentMana then
		MCSchedulerLib:RescheduleTask(0.01, Outfitter.CheckSpellcastManaDrop, Outfitter)
	end
	
	--
	
	Outfitter:EndEquipmentUpdate()
end

function Outfitter:UnitSpellcastSent(pEventID, pUnitID, pSpellName)
	if pUnitID ~= "player" then
		return
	end
	
	self:TestMessage("UnitSpellcastSent: %s %s %s", pEventID, pUnitID, pSpellName)
	
	self.SpellcastSentTime = GetTime()
	
	if not self.IsCasting then
		self:TestMessage(GREEN_FONT_COLOR_CODE.."IsCasting")
		self.IsCasting = true
	end
end

function Outfitter:UnitSpellcastChannelStart(pEventID, pUnitID, pSpellName)
	if pUnitID ~= "player" then
		return
	end
	
	self:TestMessage("UnitSpellcastChannelStart: %s %s %s", pEventID, pUnitID, pSpellName)
	
	self:TestMessage(GREEN_FONT_COLOR_CODE.."IsChanneling")
	self.IsChanneling = true
end

function Outfitter:UnitSpellcastChannelStop(pEventID, pUnitID, pSpellName)
	if pUnitID ~= "player" then
		return
	end
	
	self:TestMessage("UnitSpellcastChannelStop: %s %s %s", pEventID, pUnitID, pSpellName)
	
	if not self.IsChanneling then
		return
	end

	self:TestMessage(RED_FONT_COLOR_CODE.."NOT IsChanneling")
	self:TestMessage(RED_FONT_COLOR_CODE.."NOT IsCasting")
	
	self:BeginEquipmentUpdate()
	self.IsChanneling = false
	self.IsCasting = false
	self:SetUpdateDelay(GetTime(), 0.5) -- Need a short delay because the 'in combat' message doesn't come until after the spellcast is done
	self:EndEquipmentUpdate()
end

function Outfitter:UnitSpellcastStop(pEventID, pUnitID, pSpellName)
	if pUnitID ~= "player" then
		return
	end
	
	self:TestMessage("UnitSpellcastStop: %s %s %s", pEventID, pUnitID, pSpellName)
	
	if not self.IsCasting then
		return
	end
	
	self:TestMessage(RED_FONT_COLOR_CODE.."NOT IsCasting")
	
	self:BeginEquipmentUpdate()
	self.IsCasting = false
	self:SetUpdateDelay(GetTime(), 0.5) -- Need a short delay because the 'in combat' message doesn't come until after the spellcast is done
	self:EndEquipmentUpdate()
end

function Outfitter:SpiritRegenTimer()
	self.SpiritRegenEnabled = true
	self:SetSpecialOutfitEnabled("Spirit", true)
end

function Outfitter:PlayerIsFull()
	if UnitHealth("player") < (UnitHealthMax("player") * 0.85) then
		return false
	end

	if UnitPowerType("player") ~= 0 then
		return true
	end
	
	return UnitMana("player") > (UnitManaMax("player") * 0.85)
end

function Outfitter:UnitInventoryChanged(pUnitID)
	if pUnitID == "player" then
		Outfitter:ScheduleSynch()
	end
end

function Outfitter:ScheduleSynch()
	MCSchedulerLib:ScheduleUniqueTask(0.01, Outfitter.Synchronize, Outfitter)
end

function Outfitter:InventoryChanged()
	Outfitter.DisplayIsDirty = true -- Update the list so the checkboxes reflect the current state
	
	local vNewItemsOutfit, vCurrentOutfit = Outfitter:GetNewItemsOutfit(Outfitter.CurrentOutfit)
	
	if vNewItemsOutfit then
		-- Save the new outfit
		
		Outfitter.CurrentOutfit = vCurrentOutfit
		
		-- Update the selected outfit or temporary outfit
		
		Outfitter:SubtractOutfit(vNewItemsOutfit, Outfitter.ExpectedOutfit)
		
		if Outfitter.SelectedOutfit then
			Outfitter:UpdateOutfitFromInventory(Outfitter.SelectedOutfit, vNewItemsOutfit)
		else
			Outfitter:UpdateTemporaryOutfit(vNewItemsOutfit)
		end
		
		if Outfitter.QuickSlots then
			Outfitter.QuickSlots:InventoryChanged(Outfitter:OutfitIsAmmoOnly(vNewItemsOutfit))
		end
	end
	
	Outfitter:Update(true)
end

function Outfitter:OutfitIsAmmoOnly(pOutfit)
	local vHasAmmoItem = false
	
	for vInventorySlot, vItem in pairs(pOutfit.Items) do
		if vInventorySlot ~= "AmmoSlot" then
			return false
		else
			vHasAmmoItem = true
		end
	end
	
	return vHasAmmoItem
end

function Outfitter.ExecuteCommand(pCommand)
	local vCommands =
	{
		wear = {useOutfit = true, func = Outfitter.WearOutfit},
		unwear = {useOutfit = true, func = Outfitter.RemoveOutfit},
		toggle = {useOutfit = true, func = Outfitter.ToggleOutfit},
		reset = {func = Outfitter.AskReset},
		
		summary = {func = Outfitter.OutfitSummary},
		rating = {func = Outfitter.RatingSummary},
		sortbags = {func = Outfitter.SortBags},
		iteminfo = {func = Outfitter.ShowLinkInfo},
		itemstats = {func = Outfitter.ShowLinkStats},
		
		missing = {func = Outfitter.ShowMissingItems},
		
		sound = {func = Outfitter.SetSoundOption},
		help = {func = Outfitter.ShowCommandHelp},
		
		disable = {func = Outfitter.DisableAutoChanges},
		enable = {func = Outfitter.EnableAutoChanges},
	}
	
	-- Evaluate options if the command uses them
	
	local vCommand = SecureCmdOptionParse(pCommand)
	
	if string.find(pCommand, "|h") then -- Commands which use item links don't appear to parse correctly
		vCommand = pCommand
	else
		vCommand = SecureCmdOptionParse(pCommand)
	end
	
	if not vCommand then
		return
	end
	
	--
	
	local vStartIndex, vEndIndex, vCommand, vParameter = string.find(vCommand, "(%w+) ?(.*)")
	
	if not vCommand then
		Outfitter:ShowCommandHelp()
		return
	end
	
	vCommand = strlower(vCommand)
	
	local vCommandInfo = vCommands[vCommand]
	
	if not vCommandInfo then
		Outfitter:ShowCommandHelp()
		Outfitter:ErrorMessage("Unknown command %s", vCommand)
		return
	end
	
	local vOutfit = nil
	local vCategoryID = nil
	
	if vCommandInfo.useOutfit then
		if not vParameter then
			Outfitter:ErrorMessage("Expected outfit name for "..vCommand.." command")
			return
		end
		
		vOutfit, vCategoryID = Outfitter:FindOutfitByName(vParameter)
		
		if not vOutfit then
			Outfitter:ErrorMessage("Couldn't find outfit named "..vParameter)
			return
		end
		
		vCommandInfo.func(Outfitter, vOutfit, vCategoryID)
	else
		vCommandInfo.func(Outfitter, vParameter)
	end
end

function Outfitter:DisableAutoChanges()
	Outfitter:SetAutoSwitch(false)
	Outfitter:NoteMessage(Outfitter.cAutoChangesDisabled)
end

function Outfitter:EnableAutoChanges()
	Outfitter:SetAutoSwitch(true)
	Outfitter:NoteMessage(Outfitter.cAutoChangesEnabled)
end

function Outfitter:ShowCommandHelp()
	Outfitter:NoteMessage(HIGHLIGHT_FONT_COLOR_CODE.."/outfitter wear <outfit name>"..NORMAL_FONT_COLOR_CODE..": Wear an outfit")
	Outfitter:NoteMessage(HIGHLIGHT_FONT_COLOR_CODE.."/outfitter unwear <outfit name>"..NORMAL_FONT_COLOR_CODE..": Remove an outfit")
	Outfitter:NoteMessage(HIGHLIGHT_FONT_COLOR_CODE.."/outfitter toggle <outfit name>"..NORMAL_FONT_COLOR_CODE..": Wears or removes an outfit")
	Outfitter:NoteMessage(HIGHLIGHT_FONT_COLOR_CODE.."/outfitter reset"..NORMAL_FONT_COLOR_CODE..": Resets Outfitter, restoring default settings and outfits")
	Outfitter:NoteMessage(HIGHLIGHT_FONT_COLOR_CODE.."/outfitter sound [on|off]"..NORMAL_FONT_COLOR_CODE..": Turns equipment sound effects off during Outfitter's gear changes")
	Outfitter:NoteMessage(HIGHLIGHT_FONT_COLOR_CODE.."/outfitter missing"..NORMAL_FONT_COLOR_CODE..": Generates a list of items which are in your outfits but can't be found")
end

function Outfitter.UnequipItemByName(pItemName)
	local vInventoryID = tonumber(pItemName)
	
	if pItemName  ~= tostring(vInventoryIDthen) then
		-- Search the inventory for a matching item name
		
		vInventoryID = nil
		
		for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
			local vCurrentItemInfo = Outfitter:GetInventoryItemInfo(vInventorySlot)
			
			if vCurrentItemInfo and strlower(vCurrentItemInfo.Name) == strlower(pItemName) then
				vInventoryID = Outfitter.cSlotIDs[vInventorySlot]
			end
		end
		
		if not vInventoryID then
			Outfitter:ErrorMessage("Couldn't find an item named "..pItemName)
		end
	end
	
	local vEmptyBagSlot = Outfitter:GetEmptyBagSlot(NUM_BAG_SLOTS, 1)
	
	if not vEmptyBagSlot then
		Outfitter:ErrorMessage("Couldn't unequip "..pItemName.." because all bags are full")
		return
	end
	
	PickupInventoryItem(vInventoryID)
	PickupContainerItem(vEmptyBagSlot.BagIndex, vEmptyBagSlot.BagSlotIndex)
end

function Outfitter:AskRebuildOutfit(pOutfit)
	self.OutfitToRebuild = pOutfit
	
	StaticPopup_Show("OUTFITTER_CONFIRM_REBUILD", self.OutfitToRebuild.Name)
end

function Outfitter:AskSetCurrent(pOutfit)
	self.OutfitToRebuild = pOutfit
	
	StaticPopup_Show("OUTFITTER_CONFIRM_SET_CURRENT", self.OutfitToRebuild.Name)
end

function Outfitter:RebuildOutfit(pOutfit)
	if not pOutfit then
		return
	end
	
	local vOutfit = Outfitter:GenerateSmartOutfit("temp", pOutfit.StatID, Outfitter.ItemList_GetEquippableItems(true))
	
	if vOutfit then
		pOutfit.Items = vOutfit.Items
		self:OutfitSettingsChanged(pOutfit)
		self:WearOutfit(pOutfit)
		self:Update(true)
	end
end

function Outfitter:SetOutfitToCurrent(pOutfit)
	if not pOutfit then
		return
	end
	
	for vSlotName in pairs(pOutfit.Items) do
		self:SetInventoryItem(pOutfit, vSlotName)
	end
	
	self:OutfitSettingsChanged(pOutfit)
	self:WearOutfit(pOutfit)
	
	Outfitter:Update(true)
end

function Outfitter:AskDeleteOutfit(pOutfit)
	gOutfitter_OutfitToDelete = pOutfit
	StaticPopup_Show("OUTFITTER_CONFIRM_DELETE", gOutfitter_OutfitToDelete.Name)
end

function Outfitter:DeleteSelectedOutfit()
	if not gOutfitter_OutfitToDelete then
		return
	end
	
	Outfitter:DeleteOutfit(gOutfitter_OutfitToDelete)
	
	Outfitter:Update(true)
end

function Outfitter:LoadString(pString)
	assert(loadstring(pString, "Outfit Script"))()
end

Outfitter.cScriptPrefix =
'Outfitter.ScriptFunc = function (self, event)\n'..
'   local outfit = self.Outfit\n'..
'	if outfit.Disabled or (outfit.CombatDisabled and (Outfitter.InCombat or Outfitter.MaybeInCombat)) then return end\n'..
'	local equip, layer, delay\n'..
'	local didEquip, didUnequip, isEquipped = outfit.didEquip, outfit.didUnequip, Outfitter:WearingOutfit(outfit)\n'..
'	local time, setting = GetTime(), outfit.ScriptSettings\n'

-- User's script will be inserted here

Outfitter.cScriptSuffix =
'	self:PostProcess(equip, layer, delay, time)\n'..
'end'

Outfitter.cInputPrefix = "Outfitter.ScriptInputs={"
Outfitter.cInputSuffix = "}"

function Outfitter:LoadScript(pScript)
	local vSucceeded, vMessage = pcall(Outfitter.LoadString, Outfitter, pScript)
	
	if vMessage then
		local _, _, vLine, vMessage2 = string.find(vMessage, Outfitter.cExtractErrorFormat)
		
		if vLine then
			vMessage = string.format(Outfitter.cScriptErrorFormat, vLine, vMessage2)
		end
	end
	
	return vSucceeded, vMessage
end

function Outfitter:ParseScriptFields(pScript)
	local vSettings = {}
	local vMessage
	
	for vSetting, vValue in string.gmatch(pScript, "--%s*$([%w_]+)([^\r\n]*)") do
		vSetting = string.upper(vSetting)
		
		if vSetting == "EVENTS" then
			if not vSettings.Events then
				vSettings.Events = vValue
			else
				vSettings.Events = vSettings.Events.." "..vValue
			end
			
		elseif vSetting == "DESC" then
			vSettings.Description = vValue
		
		elseif vSetting == "SETTING" then
			local vScript = Outfitter.cInputPrefix..vValue..Outfitter.cInputSuffix
			local vSucceeded
			
			Outfitter.ScriptInputs = nil
			
			vSucceeded, vMessage = Outfitter:LoadScript(vScript)
			
			if not vSucceeded then
				return nil, vMessage
			end
			
			if Outfitter.ScriptInputs then
				if not vSettings.Inputs then
					vSettings.Inputs = {}
				end
				
				for vKey, vValue in pairs(Outfitter.ScriptInputs) do
					if type(vValue) == "string" then
						vValue = {Type = vValue, Label = vKey}
						
						if vValue.Type ~= "Boolean" then
							vValue.Label = vValue.Label..":"
						end
					end
					
					vValue.Field = vKey
					table.insert(vSettings.Inputs, vValue)
				end
				
				Outfitter.ScriptInputs = nil
			end
		end
	end
	
	return vSettings
end

function Outfitter:LoadOutfitScript(pScript)
	local vScript = Outfitter.cScriptPrefix..pScript..Outfitter.cScriptSuffix

	Outfitter.ScriptFunc = nil
	
	local vSucceeded, vMessage = Outfitter:LoadScript(vScript)
	local vScriptFunc = Outfitter.ScriptFunc
	
	Outfitter.ScriptFunc = nil
	
	return vScriptFunc, vMessage
end

function Outfitter:ActivateScript(pOutfit)
	local vScript = Outfitter:GetScript(pOutfit)
	
	if gOutfitter_Settings.Options.DisableAutoSwitch
	or pOutfit.Disabled
	or not vScript then
		return
	end
	
	local vScriptFields = Outfitter:ParseScriptFields(vScript)
	local vScriptSettings = {}
	
	if not vScriptFields then
		return
	end
	
	if not vScriptFields.Events then
		Outfitter:ErrorMessage("The script for %s does not specify any events", pOutfit.Name)
		return
	end
	
	-- Initialize the settings to their defaults
	
	if not pOutfit.ScriptSettings then
		pOutfit.ScriptSettings = {}
	end
	
	if vScriptFields.Inputs then
		for _, vDescriptor in ipairs(vScriptFields.Inputs) do
			local vDefault = vDescriptor.Default
			
			if vDefault == nil then
				local vType = string.lower(vDescriptor.Type)
				local vTypeInfo = Outfitter.SettingTypeInfo[vType]
				
				if not vTypeInfo then
					Outfitter:ErrorMessage("Script for outfit %s has an unknown $SETTING type (%s)", pOutfit.Name, vDescriptor.Type or "nil")
					return
				end
				
				vDefault = vTypeInfo.Default -- Override the built-in default if the $SETTING specifies its own default
			end
			
			-- Set to the default if the value is missing or if
			-- it's the wrong type
			
			if pOutfit.ScriptSettings[vDescriptor.Field] == nil
			or type(pOutfit.ScriptSettings[vDescriptor.Field]) ~= type(vDefault) then	
				pOutfit.ScriptSettings[vDescriptor.Field] = vDefault
			end
		end
	end
	
	local vScriptContext, vErrorMessage = Outfitter._ScriptContext:NewContext(pOutfit, vScript)
	
	if not vScriptContext then
		Outfitter:ErrorMessage("Couldn't activate script for %s", pOutfit.Name)
		Outfitter:ErrorMessage(vErrorMessage)
		return
	end
	
	Outfitter.ScriptContexts[pOutfit] = vScriptContext
	
	for vEventID in string.gmatch(vScriptFields.Events, "([%w%d_]+)") do
		vScriptContext:RegisterEvent(vEventID)
	end
	
	self:DispatchOutfitEvent("INITIALIZE", pOutfit.Name, pOutfit)
end

function Outfitter:DeactivateScript(pOutfit)
	self:DispatchOutfitEvent("TERMINATE", pOutfit.Name, pOutfit)
	
	if Outfitter.ScriptContexts[pOutfit] then
		Outfitter.ScriptContexts[pOutfit]:UnregisterAllEvents()
		Outfitter.ScriptContexts[pOutfit] = nil
	end
end

function Outfitter:OutfitHasScript(pOutfit)
	return  pOutfit.ScriptID ~= nil or pOutfit.Script ~= nil
end

function Outfitter:SetScript(pOutfit, pScript)
	Outfitter:DeactivateScript(pOutfit)
	
	if pScript == "" then
		pScript = nil
	end
	
	pOutfit.Script = pScript
	pOutfit.ScriptID = nil
	
	Outfitter:OutfitSettingsChanged(Outfitter.SelectedOutfit)
	Outfitter:ActivateScript(pOutfit)
end

function Outfitter:SetScriptID(pOutfit, pScriptID)
	Outfitter:DeactivateScript(pOutfit)
	
	if pScriptID == "" then
		pScriptID = nil
	end
	
	pOutfit.Script = nil
	pOutfit.ScriptID = pScriptID
	
	Outfitter:OutfitSettingsChanged(Outfitter.SelectedOutfit)
	Outfitter:ActivateScript(pOutfit)
end

function Outfitter:GetScript(pOutfit)
	if pOutfit.ScriptID then
		local vPresetScript = Outfitter:GetPresetScriptByID(pOutfit.ScriptID)
		
		if vPresetScript then
			return vPresetScript.Script, pOutfit.ScriptID
		end
	else
		return pOutfit.Script
	end
end

function Outfitter:ShowPanel(pPanelIndex)
	self:CancelDialogs() -- Force any dialogs to close if they're open
	
	if Outfitter.CurrentPanel > 0
	and Outfitter.CurrentPanel ~= pPanelIndex then
		Outfitter:HidePanel(Outfitter.CurrentPanel)
	end
	
	-- NOTE: Don't check for redundant calls since this function
	-- will be called to reset the field values as well as to 
	-- actually show the panel when it's hidden
	
	Outfitter.CurrentPanel = pPanelIndex
	
	getglobal(Outfitter.cPanelFrames[pPanelIndex]):Show()
	
	PanelTemplates_SetTab(OutfitterFrame, pPanelIndex)
	
	-- Update the control values
	
	if pPanelIndex == 1 then
		-- Main panel
		
	elseif pPanelIndex == 2 then
		-- Options panel
		
	elseif pPanelIndex == 3 then
		-- About panel
		
	else
		Outfitter:ErrorMessage("Unknown index (%d) in ShowPanel()", pPanelIndex)
	end
	
	Outfitter:Update(false)
end

function Outfitter:HidePanel(pPanelIndex)
	if Outfitter.CurrentPanel ~= pPanelIndex then
		return
	end
	
	getglobal(Outfitter.cPanelFrames[pPanelIndex]):Hide()
	Outfitter.CurrentPanel = 0
end

function Outfitter:CancelDialogs()
end

function Outfitter:AddDividerMenuItem()
	UIDropDownMenu_AddButton({text = " ", notCheckable = true, notClickable = true}, UIDROPDOWNMENU_MENU_LEVEL)
end

function Outfitter:AddCategoryMenuItem(pName)
	UIDropDownMenu_AddButton({text = pName, notCheckable = true, notClickable = true}, UIDROPDOWNMENU_MENU_LEVEL)
end

function Outfitter:AddMenuItem(pFrame, pName, pValue, pChecked, pLevel, pColor, pDisabled, pAdditionalOptions)
	if not pColor then
		pColor = NORMAL_FONT_COLOR
	end
	
	local vDesc =
	{
		text = pName,
		value = pValue,
		owner = pFrame,
		checked = pChecked,
		func = Outfitter.DropDown_OnClick,
		textR = pColor.r,
		textG = pColor.g,
		textB = pColor.b,
		disabled = pDisabled,
	}
	
	if pAdditionalOptions then
		for vKey, vValue in pairs(pAdditionalOptions) do
			vDesc[vKey] = vValue
		end
	end
	
	UIDropDownMenu_AddButton(vDesc, pLevel or UIDROPDOWNMENU_MENU_LEVEL)
end

function Outfitter:AddSubmenuItem(pFrame, pName, pValue, pDisabled, pAdditionalOptions)
	local vDesc =
	{
		text = pName,
		owner = pFrame,
		hasArrow = 1,
		value = pValue,
		textR = NORMAL_FONT_COLOR.r,
		textG = NORMAL_FONT_COLOR.g,
		textB = NORMAL_FONT_COLOR.b,
		disabled = pDisabled,
	}
	
	if pAdditionalOptions then
		for vKey, vValue in pairs(pAdditionalOptions) do
			vDesc[vKey] = vValue
		end
	end
	
	UIDropDownMenu_AddButton(vDesc, UIDROPDOWNMENU_MENU_LEVEL)
end

function Outfitter:InitializeOutfitMenu(pFrame, pOutfit)
	if not pOutfit then
		return
	end
	
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		Outfitter:AddCategoryMenuItem(pOutfit.Name)
		
		-- General
		
		Outfitter:AddMenuItem(pFrame, PET_RENAME, "RENAME")
		if pOutfit.StatID then
			local vStatName = Outfitter:GetStatIDName(pOutfit.StatID)
			
			if vStatName then
				Outfitter:AddMenuItem(pFrame, format(Outfitter.cRebuildOutfitFormat, vStatName), "REBUILD")
			end
		end
		Outfitter:AddMenuItem(pFrame, Outfitter.cSetCurrentItems, "SET_CURRENT")
		Outfitter:AddSubmenuItem(pFrame, Outfitter.cKeyBinding, "BINDING")
		Outfitter:AddSubmenuItem(pFrame, Outfitter.cRememberVisibility, "HELMCLOAK")
		Outfitter:AddSubmenuItem(pFrame, Outfitter.cBankCategoryTitle, "BANKING")
		if pOutfit.CategoryID ~= "Complete" then
			Outfitter:AddMenuItem(pFrame, Outfitter.cUnequipOthers, "UNEQUIP_OTHERS", pOutfit.UnequipOthers)
		end
		Outfitter:AddMenuItem(pFrame, DELETE, "DELETE")
		
		-- Automation
		
		Outfitter:AddCategoryMenuItem(Outfitter.cAutomation)
		
		local vPresetScript = Outfitter:GetPresetScriptByID(pOutfit.ScriptID)
		local vScriptName
		
		if vPresetScript then
			vScriptName = vPresetScript.Name
		elseif pOutfit.Script then
			vScriptName = Outfitter.cCustomScript
		else
			vScriptName = nil
		end
		
		Outfitter:AddSubmenuItem(pFrame, string.format(Outfitter.cScriptFormat, vScriptName or Outfitter.cNoScript), "SCRIPT")
		Outfitter:AddMenuItem(pFrame, Outfitter.cScriptSettings, "SCRIPT_SETTINGS", nil, UIDROPDOWNMENU_MENU_LEVEL, nil, vScriptName == nil)
		Outfitter:AddMenuItem(pFrame, Outfitter.cDisableScript, "DISABLE", pOutfit.Disabled, UIDROPDOWNMENU_MENU_LEVEL, nil, vScriptName == nil)
		Outfitter:AddMenuItem(pFrame, Outfitter.cDisableOutfitInCombat, "COMBATDISABLE", pOutfit.CombatDisabled, UIDROPDOWNMENU_MENU_LEVEL, nil, vScriptName == nil)
		
		-- Outfit bar
		
		if Outfitter.OutfitBar then
			Outfitter:AddCategoryMenuItem(Outfitter.cOutfitBar)
			Outfitter:AddMenuItem(pFrame, Outfitter.cShowInOutfitBar, "OUTFITBAR_SHOW", Outfitter.OutfitBar:IsOutfitShown(pOutfit), UIDROPDOWNMENU_MENU_LEVEL)
			Outfitter:AddMenuItem(pFrame, Outfitter.cChangeIcon, "OUTFITBAR_CHOOSEICON", nil, UIDROPDOWNMENU_MENU_LEVEL)
		end
		
	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
		if UIDROPDOWNMENU_MENU_VALUE == "BANKING" then
			Outfitter:AddMenuItem(pFrame, Outfitter.cDepositToBank, "DEPOSIT", nil, UIDROPDOWNMENU_MENU_LEVEL, nil, not Outfitter.BankFrameIsOpen)
			Outfitter:AddMenuItem(pFrame, Outfitter.cDepositUniqueToBank, "DEPOSITUNIQUE", nil, UIDROPDOWNMENU_MENU_LEVEL, nil, not Outfitter.BankFrameIsOpen)
			Outfitter:AddMenuItem(pFrame, Outfitter.cWithdrawFromBank, "WITHDRAW", nil, UIDROPDOWNMENU_MENU_LEVEL, nil, not Outfitter.BankFrameIsOpen)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "BINDING" then
			Outfitter:AddMenuItem(pFrame, Outfitter.cNone, "BINDING_NONE", not pOutfit.BindingIndex, UIDROPDOWNMENU_MENU_LEVEL)
			
			for vIndex = 1, 10 do
				Outfitter:AddMenuItem(pFrame, getglobal("BINDING_NAME_OUTFITTER_OUTFIT"..vIndex), "BINDING_"..vIndex, pOutfit.BindingIndex == vIndex, UIDROPDOWNMENU_MENU_LEVEL)
			end
		elseif UIDROPDOWNMENU_MENU_VALUE == "HELMCLOAK" then
			Outfitter:AddCategoryMenuItem(Outfitter.cHelm)
			Outfitter:AddMenuItem(pFrame, Outfitter.cShow, "SHOWHELM", pOutfit.ShowHelm == true, UIDROPDOWNMENU_MENU_LEVEL)
			Outfitter:AddMenuItem(pFrame, Outfitter.cHide, "HIDEHELM", pOutfit.ShowHelm == false, UIDROPDOWNMENU_MENU_LEVEL)
			Outfitter:AddMenuItem(pFrame, Outfitter.cDontChange, "IGNOREHELM", pOutfit.ShowHelm == nil, UIDROPDOWNMENU_MENU_LEVEL)
			
			Outfitter:AddCategoryMenuItem(Outfitter.cCloak)
			Outfitter:AddMenuItem(pFrame, Outfitter.cShow, "SHOWCLOAK", pOutfit.ShowCloak == true, UIDROPDOWNMENU_MENU_LEVEL)
			Outfitter:AddMenuItem(pFrame, Outfitter.cHide, "HIDECLOAK", pOutfit.ShowCloak == false, UIDROPDOWNMENU_MENU_LEVEL)
			Outfitter:AddMenuItem(pFrame, Outfitter.cDontChange, "IGNORECLOAK", pOutfit.ShowCloak == nil, UIDROPDOWNMENU_MENU_LEVEL)
		elseif UIDROPDOWNMENU_MENU_VALUE == "SCRIPT" then
			Outfitter:AddMenuItem(pFrame, Outfitter.cNoScript, "PRESET_NONE", pOutfit.ScriptID == nil and Outfitter:GetScript(pOutfit) == nil, UIDROPDOWNMENU_MENU_LEVEL)
			Outfitter:AddMenuItem(pFrame, Outfitter.cEditScriptEllide, "EDIT_SCRIPT", pOutfit.ScriptID == nil and Outfitter:GetScript(pOutfit) ~= nil, UIDROPDOWNMENU_MENU_LEVEL)
			
			local vCategory
			
			for _, vPresetScript in ipairs(Outfitter.PresetScripts) do
				if not vPresetScript.Class
				or vPresetScript.Class == Outfitter.PlayerClass then
					-- Start a new category if it's changing
					
					local vNewCategory = vPresetScript.Category or vPresetScript.Class or "GENERAL"
					
					if vCategory ~= vNewCategory then
						vCategory = vNewCategory
						Outfitter:AddSubmenuItem(pFrame, Outfitter.cScriptCategoryName[vCategory] or Outfitter.cClassName[vCategory], vCategory)
					end
				end
			end
		end
	elseif UIDROPDOWNMENU_MENU_LEVEL == 3 then
		for _, vPresetScript in ipairs(Outfitter.PresetScripts) do
			if not vPresetScript.Class
			or vPresetScript.Class == Outfitter.PlayerClass then
				local vCategory = vPresetScript.Category or vPresetScript.Class or "GENERAL"
				
				if vCategory == UIDROPDOWNMENU_MENU_VALUE then
					local vName = vPresetScript.Name
					local vScriptFields = Outfitter:ParseScriptFields(vPresetScript.Script)
					
					if vScriptFields.Inputs ~= nil and #vScriptFields.Inputs ~= 0 then
						vName = vName.."..."
					end
					
					Outfitter:AddMenuItem(
							pFrame,
							vName,
							"PRESET_"..vPresetScript.ID,
							pOutfit.ScriptID == vPresetScript.ID,
							nil, -- Level
							nil, -- Color
							nil, -- Disabled
							{tooltipTitle = vName, tooltipText = vScriptFields.Description})
				end
			end
		end
	end
end

function Outfitter.ItemDropDown_Initialize()
	local vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)
	local vItem = vFrame:GetParent():GetParent()
	local vOutfit = Outfitter:GetOutfitFromListItem(vItem)
	
	Outfitter:InitializeOutfitMenu(vFrame, vOutfit)
	
	vFrame:SetHeight(vFrame.SavedHeight)
end

function Outfitter:SetAutoSwitch(pAutoSwitch)
	local vDisableAutoSwitch = not pAutoSwitch
	
	if gOutfitter_Settings.Options.DisableAutoSwitch == vDisableAutoSwitch then
		return
	end
	
	gOutfitter_Settings.Options.DisableAutoSwitch = vDisableAutoSwitch
	
	if pAutoSwitch then
		Outfitter:ActivateAllScripts()
	else
		Outfitter:DeactivateAllScripts()
	end
	
	Outfitter.DisplayIsDirty = true
	Outfitter:Update(false)
end

function Outfitter:SetShowTooltipInfo(pShowInfo)
	gOutfitter_Settings.Options.DisableToolTipInfo = not pShowInfo
	Outfitter:Update(false)
end

function Outfitter:SetShowMinimapButton(pShowButton)
	gOutfitter_Settings.Options.HideMinimapButton = not pShowButton
	
	if gOutfitter_Settings.Options.HideMinimapButton then
		OutfitterMinimapButton:Hide()
	else
		OutfitterMinimapButton:Show()
	end
	
	Outfitter:Update(false)
end

function Outfitter:SetShowHotkeyMessages(pShowHotkeyMessages)
	gOutfitter_Settings.Options.DisableHotkeyMessages = not pShowHotkeyMessages
	
	Outfitter:Update(false)
end

function Outfitter.MinimapDropDown_OnLoad()
	UIDropDownMenu_SetAnchor(3, -7, this, "TOPRIGHT", this:GetName(), "TOPLEFT")
	UIDropDownMenu_Initialize(this, Outfitter.MinimapDropDown_Initialize)
	--UIDropDownMenu_Refresh(this) -- Don't refresh on menus which don't have a text portion
	
	if not Outfitter.RegisteredMinimapEvents then
		Outfitter:RegisterOutfitEvent("WEAR_OUTFIT", Outfitter.MinimapDropDown_OutfitEvent)
		Outfitter:RegisterOutfitEvent("UNWEAR_OUTFIT", Outfitter.MinimapDropDown_OutfitEvent)
		
		Outfitter.RegisteredMinimapEvents = true
	end
end

function Outfitter.MinimapDropDown_OutfitEvent(pEvent, pParameter1, pParameter2)
	MCSchedulerLib:ScheduleUniqueTask(0.1, Outfitter.MinimapDropDown_OutfitEvent2)
end

function Outfitter.MinimapDropDown_OutfitEvent2()
	if UIDROPDOWNMENU_OPEN_MENU ~= "OutfitterMinimapButton" then
		return
	end
	
	UIDropDownMenu_Initialize(OutfitterMinimapButton, Outfitter.MinimapDropDown_Initialize)
end

function Outfitter.MinimapDropDown_AdjustScreenPosition(pMenu)
	local vListFrame = getglobal("DropDownList1")
	
	if not vListFrame:IsVisible() then
		return
	end
	
	local vCenterX, vCenterY = pMenu:GetCenter()
	local vScreenWidth, vScreenHeight = GetScreenWidth(), GetScreenHeight()
	
	local vAnchor
	local vOffsetX, vOffsetY
	
	if vCenterY < vScreenHeight / 2 then
		vAnchor = "BOTTOM"
		vOffsetY = -8
	else
		vAnchor = "TOP"
		vOffsetY = -17
	end
	
	if vCenterX < vScreenWidth / 2 then
		vAnchor = vAnchor.."LEFT"
		vOffsetX = 21
	else
		vAnchor = vAnchor.."RIGHT"
		vOffsetX = 3
	end
	
	vListFrame:ClearAllPoints()
	vListFrame:SetPoint(vAnchor, pMenu.relativeTo, pMenu.relativePoint, vOffsetX, vOffsetY)
end

function Outfitter:OutfitIsVisible(pOutfit)
	return not pOutfit.Disabled
	   and not Outfitter:IsEmptyOutfit(pOutfit)
end

function Outfitter:HasVisibleOutfits(pOutfits)
	if not pOutfits then
		return false
	end
	
	for vIndex, vOutfit in pairs(pOutfits) do
		if Outfitter:OutfitIsVisible(vOutfit) then	
			return true
		end
	end
	
	return false
end

function Outfitter.MinimapDropDown_Initialize()
	-- Just return if not initialized yet
	
	if not Outfitter.Initialized then
		return
	end
	
	--
	
	local vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)
	
	Outfitter:AddCategoryMenuItem(Outfitter.cTitleVersion)
	Outfitter:AddMenuItem(vFrame, Outfitter.cOpenOutfitter, 0)
	Outfitter:AddMenuItem(vFrame, Outfitter.cAutoSwitch, -1, gOutfitter_Settings.Options.DisableAutoSwitch)
	
	Outfitter.MinimapDropDown_InitializeOutfitList()
end

function Outfitter:GetCategoryOrder()
	return Outfitter.cCategoryOrder
end

function Outfitter:GetOutfitsByCategoryID(pCategoryID)
	return gOutfitter_Settings.Outfits[pCategoryID]
end

function Outfitter.MinimapDropDown_InitializeOutfitList()
	-- Just return if not initialized yet
	
	if not Outfitter.Initialized then
		return
	end
	
	--
	
	local vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	local vCategoryOrder = Outfitter:GetCategoryOrder()
		
	for vCategoryIndex, vCategoryID in ipairs(vCategoryOrder) do
		local vCategoryName = Outfitter["c"..vCategoryID.."Outfits"]
		local vOutfits = Outfitter:GetOutfitsByCategoryID(vCategoryID)

		if Outfitter:HasVisibleOutfits(vOutfits) then
			Outfitter:AddCategoryMenuItem(vCategoryName)
			
			for vIndex, vOutfit in ipairs(vOutfits) do
				if Outfitter:OutfitIsVisible(vOutfit) then
					local vWearingOutfit = Outfitter:WearingOutfit(vOutfit)
					local vMissingItems, vBankedItems = Outfitter.ItemList_GetMissingItems(vEquippableItems, vOutfit)
					local vItemColor = NORMAL_FONT_COLOR
					
					if vMissingItems then
						vItemColor = RED_FONT_COLOR
					elseif vBankedItems then
						vItemColor = Outfitter.BANKED_FONT_COLOR
					end
					
					Outfitter:AddMenuItem(vFrame, vOutfit.Name, {CategoryID = vCategoryID, Index = vIndex}, vWearingOutfit, nil, vItemColor)
				end
			end
		end
	end
end

function Outfitter.DropDown_OnClick()
	if this.owner.AutoSetValue then
		UIDropDownMenu_SetSelectedValue(this.owner, this.value)
	end
	
	if this.owner.ChangedValueFunc then
		this.owner.ChangedValueFunc(this.owner, this.value)
	end
	
	CloseDropDownMenus()
end

function Outfitter.Item_SetTextColor(pItem, pRed, pGreen, pBlue)
	local vItemNameField
	
	if pItem.isCategory then
		vItemNameField = getglobal(pItem:GetName().."CategoryName")
	else
		vItemNameField = getglobal(pItem:GetName().."OutfitName")
	end
	
	vItemNameField:SetTextColor(pRed, pGreen, pBlue)
end

function Outfitter:GenerateItemListString(pLabel, pListColorCode, pItems)
	local vItemList = nil

	for vIndex, vOutfitItem in ipairs(pItems) do
		if not vItemList then
			vItemList = HIGHLIGHT_FONT_COLOR_CODE..pLabel..pListColorCode..vOutfitItem.Name
		else
			vItemList = vItemList..Outfitter.cMissingItemsSeparator..vOutfitItem.Name
		end
	end
	
	return vItemList
end

function Outfitter.Item_OnEnter(pItem)
	Outfitter.Item_SetTextColor(pItem, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	
	if pItem.isCategory then
		local vDescription = Outfitter.cCategoryDescriptions[pItem.categoryID]
		
		if vDescription then
			local vCategoryName = Outfitter["c"..pItem.categoryID.."Outfits"]
			
			GameTooltip_AddNewbieTip(vCategoryName, 1.0, 1.0, 1.0, vDescription, 1)
		end
		
		ResetCursor()
	elseif pItem.isOutfitItem then
		local vHasCooldown, vRepairCost
		
		GameTooltip:SetOwner(pItem, "ANCHOR_TOP")
		
		if pItem.outfitItem.Location.SlotName then
			if not pItem.outfitItem.Location.SlotID then
				pItem.outfitItem.Location.SlotID = Outfitter.cSlotIDs[pItem.outfitItem.Location.SlotName]
			end
			
			GameTooltip:SetInventoryItem("player", pItem.outfitItem.Location.SlotID)
		else
			vHasCooldown, vRepairCost = GameTooltip:SetBagItem(pItem.outfitItem.Location.BagIndex, pItem.outfitItem.Location.BagSlotIndex)
		end
		
		GameTooltip:Show()

		if InRepairMode() and (vRepairCost and vRepairCost > 0) then
			GameTooltip:AddLine(TEXT(REPAIR_COST), "", 1, 1, 1)
			SetTooltipMoney(GameTooltip, vRepairCost)
			GameTooltip:Show()
		elseif MerchantFrame:IsShown() and MerchantFrame.selectedTab == 1 then
			if pItem.outfitItem.Location.BagIndex then
				ShowContainerSellCursor(pItem.outfitItem.Location.BagIndex, pItem.outfitItem.Location.BagSlotIndex)
			end
		else
			ResetCursor()
		end
	else
		local vOutfit = Outfitter:GetOutfitFromListItem(pItem)
		
		Outfitter:ShowOutfitTooltip(vOutfit, pItem, pItem.MissingItems, pItem.BankedItems)
	end
end

function Outfitter:ShowOutfitTooltip(pOutfit, pOwner, pMissingItems, pBankedItems, pShowEmptyTooltips, pTooltipAnchor)
	-- local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	-- local vMissingItems, vBankedItems = Outfitter.ItemList_GetMissingItems(vEquippableItems, pOutfit)
	
	local vDescription = Outfitter:GetOutfitDescription(pOutfit)
	
	if pMissingItems
	or pBankedItems
	or pShowEmptyTooltips then
		GameTooltip:SetOwner(pOwner, pTooltipAnchor or "ANCHOR_LEFT")
		
		GameTooltip:AddLine(pOutfit.Name)
		
		if vDescription then
			GameTooltip:AddLine(vDescription, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
		end
		
		if pMissingItems then
			local vItemList = Outfitter:GenerateItemListString(Outfitter.cMissingItemsLabel, RED_FONT_COLOR_CODE, pMissingItems)
			GameTooltip:AddLine(vItemList, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
		end
		
		if pBankedItems then
			local vItemList = Outfitter:GenerateItemListString(Outfitter.cBankedItemsLabel, Outfitter.BANKED_FONT_COLOR_CODE, pBankedItems)
			GameTooltip:AddLine(vItemList, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
		end
		
		GameTooltip:Show()
	elseif vDescription then
		GameTooltip_AddNewbieTip(pOutfit.Name, 1.0, 1.0, 1.0, vDescription, 1)
	end
	
	ResetCursor()
end

function Outfitter:GetOutfitDescription(pOutfit)
	return Outfitter:GetScriptDescription(Outfitter:GetScript(pOutfit))
end

function Outfitter:GetScriptDescription(pScript)
	if not pScript then
		return
	end
	
	local vScriptFields = Outfitter:ParseScriptFields(pScript)
	
	if not vScriptFields then
		return
	end
	
	return vScriptFields.Description
end

function Outfitter:OutfitHasSettings(pOutfit)
	return Outfitter:ScriptHasSettings(Outfitter:GetScript(pOutfit))
end

function Outfitter:ScriptHasSettings(pScript)
	if not pScript then
		return
	end
	
	local vScriptFields = Outfitter:ParseScriptFields(pScript)
	
	if not vScriptFields then
		return
	end
	
	return vScriptFields.Inputs ~= nil and #vScriptFields.Inputs ~= 0
end

function Outfitter.Item_OnLeave(pItem)
	if pItem.isCategory then
		Outfitter.Item_SetTextColor(pItem, 1, 1, 1)
	else
		Outfitter.Item_SetTextColor(pItem, pItem.DefaultColor.r, pItem.DefaultColor.g, pItem.DefaultColor.b)
	end
	
	GameTooltip:Hide()
end

function Outfitter.Item_OnClick(pItem, pButton, pIgnoreModifiers)
	if pItem.isCategory then
		local vCategoryOutfits = gOutfitter_Settings.Outfits[pItem.categoryID]
		
		Outfitter.Collapsed[pItem.categoryID] = not Outfitter.Collapsed[pItem.categoryID]
		Outfitter.DisplayIsDirty = true
	elseif pItem.isOutfitItem then
		if pButton == "LeftButton" then
			Outfitter:PickupItemLocation(pItem.outfitItem.Location)
			StackSplitFrame:Hide()
		else
			if MerchantFrame:IsShown() and MerchantFrame.selectedTab == 2 then
				-- Don't sell the item if the buyback tab is selected
				return
			else
				if pItem.outfitItem.Location.BagIndex then
					UseContainerItem(pItem.outfitItem.Location.BagIndex, pItem.outfitItem.Location.BagSlotIndex)
					StackSplitFrame:Hide()
				end
			end
		end
	else
		local vOutfit = Outfitter:GetOutfitFromListItem(pItem)
		
		if not vOutfit then
			-- Error: outfit not found
			return
		end
		
		if pButton == "LeftButton" then
			vOutfit.Disabled = nil
			Outfitter:WearOutfit(vOutfit)
		else
			this = pItem.OutfitMenu
			
			if DropDownList1:IsShown() then
				ToggleDropDownMenu(nil, nil, pItem.OutfitMenu)
			else
				ToggleDropDownMenu(nil, nil, pItem.OutfitMenu, "cursor")
				PlaySound("igMainMenuOptionCheckBoxOn")
			end
		end
	end
	
	Outfitter:Update(true)
end

function Outfitter.Item_CheckboxClicked(pItem)
	if pItem.isCategory then
		return
	end
	
	local vOutfits = gOutfitter_Settings.Outfits[pItem.categoryID]
	
	if not vOutfits then
		-- Error: outfit category not found
		return
	end
	
	local vOutfit = vOutfits[pItem.outfitIndex]
	
	if not vOutfit then
		-- Error: outfit not found
		return
	end
	
	local vCheckbox = getglobal(pItem:GetName().."OutfitSelected")
	
	if vCheckbox:GetChecked() then
		vOutfit.Disabled = nil
		Outfitter:WearOutfit(vOutfit)
	else
		Outfitter:RemoveOutfit(vOutfit)
	end
	
	Outfitter:Update(true)
end

function Outfitter.Item_SetToOutfit(pItemIndex, pOutfit, pCategoryID, pOutfitIndex, pEquippableItems)
	local vItemName = "OutfitterItem"..pItemIndex
	local vItem = getglobal(vItemName)
	local vOutfitFrameName = vItemName.."Outfit"
	local vOutfitFrame = getglobal(vOutfitFrameName)
	local vItemFrame = getglobal(vItemName.."Item")
	local vCategoryFrame = getglobal(vItemName.."Category")
	local vMissingItems, vBankedItems = Outfitter.ItemList_GetMissingItems(pEquippableItems, pOutfit)
	
	vOutfitFrame:Show()
	vCategoryFrame:Hide()
	vItemFrame:Hide()
	
	local vItemSelectedCheckmark = getglobal(vOutfitFrameName.."Selected")
	local vItemNameField = getglobal(vOutfitFrameName.."Name")
	local vItemMenu = getglobal(vOutfitFrameName.."Menu")
	
	vItemSelectedCheckmark:Show()
	
	if Outfitter:WearingOutfit(pOutfit) then
		vItemSelectedCheckmark:SetChecked(true)
	else
		vItemSelectedCheckmark:SetChecked(nil)
	end
	
	vItem.MissingItems = vMissingItems
	vItem.BankedItems = vBankedItems
	
	if pOutfit.Disabled then
		vItemNameField:SetText(format(Outfitter.cDisabledOutfitName, pOutfit.Name))
		vItem.DefaultColor = GRAY_FONT_COLOR
	else
		vItemNameField:SetText(pOutfit.Name)
		if vMissingItems then
			vItem.DefaultColor = RED_FONT_COLOR
		elseif vBankedItems then
			vItem.DefaultColor = Outfitter.BANKED_FONT_COLOR
		else
			vItem.DefaultColor = NORMAL_FONT_COLOR
		end
	end
	
	vItemNameField:SetTextColor(vItem.DefaultColor.r, vItem.DefaultColor.g, vItem.DefaultColor.b)
	
	vItemMenu:Show()
	
	vItem.isCategory = false
	vItem.isOutfitItem = false
	vItem.outfitItem = nil
	vItem.categoryID = pOutfit.CategoryID
	vItem.outfitIndex = pOutfitIndex
	
	vItem:Show()
	
	-- Show the script icon if there's one attached
	
	local vScriptIcon = getglobal(vOutfitFrameName.."ScriptIcon")
	
	if pOutfit.ScriptID or pOutfit.Script then
		vScriptIcon:SetTexture("Interface\\Addons\\Outfitter\\Textures\\Gear")
		
		if gOutfitter_Settings.Options.DisableAutoSwitch or pOutfit.Disabled then
			vScriptIcon:SetVertexColor(0.4, 0.4, 0.4)
		else
			vScriptIcon:SetVertexColor(1, 1, 1)
		end

		vScriptIcon:Show()
	else
		vScriptIcon:Hide()
	end
	
	-- Update the highlighting
	
	if Outfitter.SelectedOutfit == pOutfit then
		OutfitterMainFrameHighlight:SetPoint("TOPLEFT", vItem, "TOPLEFT", 0, 0)
		OutfitterMainFrameHighlight:Show()
	end
end

function Outfitter.Item_SetToItem(pItemIndex, pOutfitItem)
	local vItemName = "OutfitterItem"..pItemIndex
	local vItem = getglobal(vItemName)
	local vCategoryFrameName = vItemName.."Category"
	local vItemFrameName = vItemName.."Item"
	local vItemFrame = getglobal(vItemFrameName)
	local vOutfitFrame = getglobal(vItemName.."Outfit")
	local vCategoryFrame = getglobal(vCategoryFrameName)
	
	vItem.isOutfitItem = true
	vItem.isCategory = false
	vItem.outfitItem = pOutfitItem
	
	vItemFrame:Show()
	vOutfitFrame:Hide()
	vCategoryFrame:Hide()

	local vItemNameField = getglobal(vItemFrameName.."Name")
	local vItemIcon = getglobal(vItemFrameName.."Icon")
	
	vItemNameField:SetText(pOutfitItem.Name)
	
	if pOutfitItem.Quality then
		vItem.DefaultColor = ITEM_QUALITY_COLORS[pOutfitItem.Quality]
	else
		vItem.DefaultColor = GRAY_FONT_COLOR
	end
	
	if pOutfitItem.Texture then
		vItemIcon:SetTexture(pOutfitItem.Texture)
		vItemIcon:Show()
	else
		vItemIcon:Hide()
	end
	
	vItemNameField:SetTextColor(vItem.DefaultColor.r, vItem.DefaultColor.g, vItem.DefaultColor.b)
	
	vItem:Show()
end

function Outfitter.Item_SetToCategory(pItemIndex, pCategoryID)
	local vCategoryName = Outfitter["c"..pCategoryID.."Outfits"]
	local vItemName = "OutfitterItem"..pItemIndex
	local vItem = getglobal(vItemName)
	local vCategoryFrameName = vItemName.."Category"
	local vOutfitFrame = getglobal(vItemName.."Outfit")
	local vItemFrame = getglobal(vItemName.."Item")
	local vCategoryFrame = getglobal(vCategoryFrameName)
	
	vOutfitFrame:Hide()
	vCategoryFrame:Show()
	vItemFrame:Hide()
	
	local vItemNameField = getglobal(vCategoryFrameName.."Name")
	local vExpandButton = getglobal(vCategoryFrameName.."Expand")
	
	vItem.MissingItems = nil
	vItem.BankedItems = nil
	
	if Outfitter.Collapsed[pCategoryID] then
		vExpandButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
	else
		vExpandButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
	end
	
	vItemNameField:SetText(vCategoryName)
	
	vItem.isCategory = true
	vItem.isOutfitItem = false
	vItem.outfitItem = nil
	vItem.categoryID = pCategoryID
	
	vItem:Show()
end

function Outfitter:AddOutfitsToList(pOutfits, pCategoryID, pItemIndex, pFirstItemIndex, pEquippableItems)
	local vOutfits = pOutfits[pCategoryID]
	local vItemIndex = pItemIndex
	local vFirstItemIndex = pFirstItemIndex
	
	if vFirstItemIndex == 0 then
		Outfitter.Item_SetToCategory(vItemIndex, pCategoryID, false)
		vItemIndex = vItemIndex + 1
	else
		vFirstItemIndex = vFirstItemIndex - 1
	end

	if vItemIndex >= Outfitter.cMaxDisplayedItems then
		return vItemIndex, vFirstItemIndex
	end

	if not Outfitter.Collapsed[pCategoryID]
	and vOutfits then
		for vIndex, vOutfit in ipairs(vOutfits) do
			if vFirstItemIndex == 0 then
				Outfitter.Item_SetToOutfit(vItemIndex, vOutfit, pCategoryID, vIndex, pEquippableItems)
				vItemIndex = vItemIndex + 1
				
				if vItemIndex >= Outfitter.cMaxDisplayedItems then
					return vItemIndex, vFirstItemIndex
				end
			else
				vFirstItemIndex = vFirstItemIndex - 1
			end
		end
	end
	
	return vItemIndex, vFirstItemIndex
end

function Outfitter:AddOutfitItemsToList(pOutfitItems, pCategoryID, pItemIndex, pFirstItemIndex)
	local vItemIndex = pItemIndex
	local vFirstItemIndex = pFirstItemIndex
	
	if vFirstItemIndex == 0 then
		Outfitter.Item_SetToCategory(vItemIndex, pCategoryID, false)
		vItemIndex = vItemIndex + 1
	else
		vFirstItemIndex = vFirstItemIndex - 1
	end

	if vItemIndex >= Outfitter.cMaxDisplayedItems then
		return vItemIndex, vFirstItemIndex
	end

	if not Outfitter.Collapsed[pCategoryID] then
		for vIndex, vOutfitItem in ipairs(pOutfitItems) do
			if vFirstItemIndex == 0 then
				Outfitter.Item_SetToItem(vItemIndex, vOutfitItem)
				vItemIndex = vItemIndex + 1
				
				if vItemIndex >= Outfitter.cMaxDisplayedItems then
					return vItemIndex, vFirstItemIndex
				end
			else
				vFirstItemIndex = vFirstItemIndex - 1
			end
		end
	end
	
	return vItemIndex, vFirstItemIndex
end

function Outfitter:SortOutfits()
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		table.sort(vOutfits, Outfiter_CompareOutfitNames)
	end
end

function Outfiter_CompareOutfitNames(pOutfit1, pOutfit2)
	return pOutfit1.Name < pOutfit2.Name
end

function Outfitter:Update(pOutfitsChanged)
	-- Flush the caches
	
	if pOutfitsChanged then
		Outfitter:EraseTable(Outfitter.OutfitInfoCache)
	end
	
	--
	
	if not OutfitterFrame:IsVisible() then
		return
	end
	
	if Outfitter.CurrentPanel == 1 then
		-- Main panel
		
		if not Outfitter.DisplayIsDirty then
			return
		end
		
		Outfitter.DisplayIsDirty = false
		
		-- Sort the outfits
		
		Outfitter:SortOutfits()
		
		-- Get the equippable items so outfits can be marked if they're missing anything
		
		local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
		
		-- Update the slot enables if they're shown
		
		if pOutfitsChanged
		and OutfitterSlotEnables:IsVisible() then
			Outfitter:UpdateSlotEnables(Outfitter.SelectedOutfit, vEquippableItems)
		end
		
		Outfitter.ItemList_CompiledUnusedItemsList(vEquippableItems)
		
		-- Update the list
		
		OutfitterMainFrameHighlight:Hide()

		local vFirstItemIndex = FauxScrollFrame_GetOffset(OutfitterMainFrameScrollFrame)
		local vItemIndex = 0
		
		Outfitter.ItemList_ResetIgnoreItemFlags(vEquippableItems)
		
		for vCategoryIndex, vCategoryID in ipairs(Outfitter.cCategoryOrder) do
			vItemIndex, vFirstItemIndex = Outfitter:AddOutfitsToList(gOutfitter_Settings.Outfits, vCategoryID, vItemIndex, vFirstItemIndex, vEquippableItems)
			
			if vItemIndex >= Outfitter.cMaxDisplayedItems then
				break
			end
		end
		
		if vItemIndex < Outfitter.cMaxDisplayedItems
		and vEquippableItems.UnusedItems then
			vItemIndex, vFirstItemIndex = Outfitter:AddOutfitItemsToList(vEquippableItems.UnusedItems, "OddsNEnds", vItemIndex, vFirstItemIndex)
		end
		
		-- Hide any unused items
		
		for vItemIndex2 = vItemIndex, (Outfitter.cMaxDisplayedItems - 1) do
			local vItemName = "OutfitterItem"..vItemIndex2
			local vItem = getglobal(vItemName)
			
			vItem:Hide()
		end
		
		local vTotalNumItems = 0
		
		for vCategoryIndex, vCategoryID in ipairs(Outfitter.cCategoryOrder) do
			vTotalNumItems = vTotalNumItems + 1
			
			local vOutfits = gOutfitter_Settings.Outfits[vCategoryID]
			
			if not Outfitter.Collapsed[vCategoryID]
			and vOutfits then
				vTotalNumItems = vTotalNumItems + #vOutfits
			end
		end
		
		if vEquippableItems.UnusedItems then
			vTotalNumItems = vTotalNumItems + 1
			
			if not Outfitter.Collapsed["OddsNEnds"] then
				vTotalNumItems = vTotalNumItems + #vEquippableItems.UnusedItems
			end
		end
		
		FauxScrollFrame_Update(
				OutfitterMainFrameScrollFrame,
				vTotalNumItems,                 -- numItems
				Outfitter.cMaxDisplayedItems,   -- numToDisplay
				18,                             -- valueStep
				nil, nil, nil,                  -- button, smallWidth, bigWidth
				nil,                            -- highlightFrame
				0, 0)                           -- smallHighlightWidth, bigHighlightWidth
	elseif Outfitter.CurrentPanel == 2 then -- Options panel
		OutfitterAutoSwitch:SetChecked(gOutfitter_Settings.Options.DisableAutoSwitch)
		OutfitterShowMinimapButton:SetChecked(not gOutfitter_Settings.Options.HideMinimapButton)
		OutfitterTooltipInfo:SetChecked(not gOutfitter_Settings.Options.DisableToolTipInfo)
		OutfitterShowHotkeyMessages:SetChecked(not gOutfitter_Settings.Options.DisableHotkeyMessages)
		OutfitterShowOutfitBar:SetChecked(gOutfitter_Settings.OutfitBar.ShowOutfitBar)
	end
end

function Outfitter:OnVerticalScroll()
	Outfitter.DisplayIsDirty = true
	Outfitter:Update(false)
end

function Outfitter:SelectOutfit(pOutfit)
	if not Outfitter:IsOpen() then
		return
	end
	
	Outfitter.SelectedOutfit = pOutfit
	
	-- Get the equippable items so outfits can be marked if they're missing anything
	
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	
	-- Update the slot enables
	
	Outfitter:UpdateSlotEnables(pOutfit, vEquippableItems)
	OutfitterSlotEnables:Show()
	
	-- Done, rebuild the list
	
	Outfitter.DisplayIsDirty = true
end

function Outfitter:UpdateSlotEnables(pOutfit, pEquippableItems)
	if UnitHasRelicSlot("player") then
		OutfitterEnableAmmoSlot:Hide()
	else
		OutfitterEnableAmmoSlot:Show()
	end
	
	for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
		local vOutfitItem = pOutfit.Items[vInventorySlot]
		local vCheckbox = getglobal("OutfitterEnable"..vInventorySlot)
		
		if not vOutfitItem then
			vCheckbox:SetChecked(false)
		else
			if Outfitter.ItemList_InventorySlotContainsItem(pEquippableItems, vInventorySlot, vOutfitItem) then
				vCheckbox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
				vCheckbox.IsUnknown = false
			else
				vCheckbox:SetCheckedTexture("Interface\\Addons\\Outfitter\\Textures\\CheckboxUnknown")
				vCheckbox.IsUnknown = true
			end
			
			vCheckbox:SetChecked(true)
		end
	end
end

function Outfitter:ClearSelection()
	Outfitter.SelectedOutfit = nil
	Outfitter.DisplayIsDirty = true
	OutfitterSlotEnables:Hide()
end

function Outfitter:FindOutfitItemIndex(pOutfit)
	local vOutfitCategoryID, vOutfitIndex = Outfitter:FindOutfit(pOutfit)
	
	if not vOutfitCategoryID then
		return nil
	end
	
	local vItemIndex = 0
	
	for vCategoryIndex, vCategoryID in ipairs(Outfitter.cCategoryOrder) do
		vItemIndex = vItemIndex + 1
		
		if not Outfitter.Collapsed[vCategoryID] then
			if vOutfitCategoryID == vCategoryID then
				return vItemIndex + vOutfitIndex - 1
			else
				vItemIndex = vItemIndex + #gOutfitter_Settings.Outfits[vCategoryID]
			end
		end
	end
	
	return nil
end

function Outfitter:WearOutfitByName(pOutfitName, pLayerID)
	vOutfit = Outfitter:FindOutfitByName(pOutfitName)
	
	if not vOutfit then
		Outfitter:ErrorMessage("Couldn't find outfit named %s", pOutfitName)
		return
	end
	
	self:WearOutfit(vOutfit, pLayerID)
end

function Outfitter:RemoveOutfitByName(pOutfitName, pLayerID)
	vOutfit = Outfitter:FindOutfitByName(pOutfitName)
	
	if not vOutfit then
		Outfitter:ErrorMessage("Couldn't find outfit named %s", pOutfitName)
		return
	end
	
	self:RemoveOutfit(vOutfit)
end

function Outfitter:WearOutfit(pOutfit, pLayerID, pCallerIsScript)
	Outfitter:BeginEquipmentUpdate()
	
	-- Update the equipment
	
	pOutfit.didEquip = pCallerIsScript
	pOutfit.didUnequip = false
	
	Outfitter.EquippedNeedsUpdate = true
	Outfitter.WeaponsNeedUpdate = true
	
	-- Add the outfit to the stack
	
	if pOutfit.CategoryID == "Complete" then
		Outfitter.OutfitStack:Clear()
	elseif pOutfit.UnequipOthers then
		Outfitter.OutfitStack:ClearCategory("Accessory")
	end
	
	Outfitter.OutfitStack:AddOutfit(pOutfit, pLayerID)
	
	-- If it's a Complete outfit, push it onto the list of recent complete outfits
	
	if pOutfit.CategoryID == "Complete" and pOutfit.Name then
		for vRecentIndex, vRecentName in ipairs(gOutfitter_Settings.RecentCompleteOutfits) do
			if vRecentName == pOutfit.Name then
				table.remove(gOutfitter_Settings.RecentCompleteOutfits, vRecentIndex)
				break
			end
		end
		
		table.insert(gOutfitter_Settings.RecentCompleteOutfits, pOutfit.Name)
	end
	
	-- If Outfitter is open then also select the outfit.  This is important
	-- because the UI can't function correctly if the selected outfit and
	-- top outfit don't stay the same.
	
	if Outfitter:IsOpen() then
		if Outfitter.OutfitStack:IsTopmostOutfit(pOutfit) then
			Outfitter:SelectOutfit(pOutfit)
		else
			Outfitter:ClearSelection()
		end
	end
	
	Outfitter:EndEquipmentUpdate("Outfitter:WearOutfit")
end

function Outfitter:RemoveOutfit(pOutfit, pCallerIsScript)
	if not Outfitter.OutfitStack:RemoveOutfit(pOutfit) then
		return
	end
	
	-- If it's a Complete outfit, move it to the bottom of the list of recent complete outfits
	
	if pOutfit.CategoryID == "Complete" and pOutfit.Name then
		for vRecentIndex, vRecentName in ipairs(gOutfitter_Settings.RecentCompleteOutfits) do
			if vRecentName == pOutfit.Name then
				table.remove(gOutfitter_Settings.RecentCompleteOutfits, vRecentIndex)
				break
			end
		end
		
		table.insert(gOutfitter_Settings.RecentCompleteOutfits, 1, pOutfit.Name)
		
		Outfitter:DebugTable("RecentCompleteOutfits", gOutfitter_Settings.RecentCompleteOutfits)
	end
	
	--
	
	Outfitter:BeginEquipmentUpdate()
	
	-- Clear the selection if the outfit being removed
	-- is selected too
	
	if Outfitter.SelectedOutfit == pOutfit then
		Outfitter:ClearSelection()
	end

	-- Update the list
	
	pOutfit.didEquip = false
	pOutfit.didUnequip = pCallerIsScript
	
	Outfitter.EquippedNeedsUpdate = true
	Outfitter.WeaponsNeedUpdate = true
	
	Outfitter:EndEquipmentUpdate("Outfitter:RemoveOutfit")
	
	Outfitter:DispatchOutfitEvent("UNWEAR_OUTFIT", pOutfit.Name, pOutfit)
	
	-- If they're removing a complete outfit, find something else to wear instead
	
	if pOutfit.CategoryID == "Complete"
	and #gOutfitter_Settings.RecentCompleteOutfits then
		local vOutfit
		
		while not vOutfit do
			local vOutfitName = gOutfitter_Settings.RecentCompleteOutfits[#gOutfitter_Settings.RecentCompleteOutfits]
			
			vOutfit = self:FindOutfitByName(vOutfitName)
			
			if vOutfit and vOutfit.CategoryID == "Complete" then
				self:WearOutfit(vOutfit)
				break
			end
			
			table.remove(gOutfitter_Settings.RecentCompleteOutfits)
			
			if #gOutfitter_Settings.RecentCompleteOutfits then
				break
			end
		end
	end
end

function Outfitter:ToggleOutfit(pOutfit)
	if Outfitter:WearingOutfit(pOutfit) then
		Outfitter:RemoveOutfit(pOutfit)
		return false
	else
		Outfitter:WearOutfit(pOutfit)
		return true
	end
end

function Outfitter:SetSoundOption(pParam)
	if pParam == "on" then
		gOutfitter_Settings.DisableEquipSounds = nil
		Outfitter:NoteMessage("Outfitter will no longer affect sounds during equipment changes")
	elseif pParam == "off" then
		gOutfitter_Settings.DisableEquipSounds = true
		Outfitter:NoteMessage("Outfitter will now disable sound effects during equipment changes")
	else
		Outfitter:NoteMessage("Valid sound options are 'default' and 'off'")
	end
end

function Outfitter:ShowLinkStats(pLink)
	local vStats = Outfitter.ItemList_GetItemLinkStats(pLink)
	
	if not vStats then
		Outfitter:NoteMessage("Couldn't get item stats from the link provided")
		return
	end
	
	-- Outfitter:ConvertRatingsToStats(vStats)
	-- Outfitter:DistributeSecondaryStats(vStats, Outfitter:GetPlayerStatDistribution())
	
	for vStatName, vStatValue in pairs(vStats) do
		Outfitter:NoteMessage("%s: %s", vStatName, vStatValue or "nil")
	end
end

function Outfitter:ShowLinkInfo(pLink)
	local vItemInfo = Outfitter:GetItemInfoFromLink(pLink)
	
	if not vItemInfo then
		Outfitter:NoteMessage("Couldn't get item info from the link provided")
		return
	end
	
	Outfitter:NoteMessage("Name: "..vItemInfo.Name)
	Outfitter:NoteMessage("Quality: "..vItemInfo.Quality)
	Outfitter:NoteMessage("Code: "..vItemInfo.Code)
	Outfitter:NoteMessage("SubCode: "..vItemInfo.SubCode)
	Outfitter:NoteMessage("Type: "..vItemInfo.Type)
	Outfitter:NoteMessage("SubType: "..vItemInfo.SubType)
	Outfitter:NoteMessage("InvType: "..vItemInfo.InvType)
	Outfitter:NoteMessage("Level: "..vItemInfo.Level)
	if vItemInfo.EnchantCode then
		Outfitter:NoteMessage("EnchantCode: "..vItemInfo.EnchantCode)
	end
	if vItemInfo.JewelCode1 then
		Outfitter:NoteMessage("JewelCode1: "..vItemInfo.JewelCode1)
	end
	if vItemInfo.JewelCode2 then
		Outfitter:NoteMessage("JewelCode2: "..vItemInfo.JewelCode2)
	end
	if vItemInfo.JewelCode3 then
		Outfitter:NoteMessage("JewelCode3: "..vItemInfo.JewelCode3)
	end
	if vItemInfo.JewelCode4 then
		Outfitter:NoteMessage("JewelCode4: "..vItemInfo.JewelCode4)
	end
	
	local vStats = Outfitter.ItemList_GetItemLinkStats(pLink)
	
	Outfitter:ConvertRatingsToStats(vStats)
	Outfitter:DistributeSecondaryStats(vStats, Outfitter:GetPlayerStatDistribution())
	
	Outfitter:DebugTable("Stats", vStats)
end

StaticPopupDialogs.OUTFITTER_CONFIRM_RESET =
{
	text = TEXT(Outfitter.cConfirmResetMsg),
	button1 = TEXT(Outfitter.cReset),
	button2 = TEXT(CANCEL),
	OnAccept = function() Outfitter:Reset() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

function Outfitter.AskReset()
	StaticPopup_Show("OUTFITTER_CONFIRM_RESET")
end

function Outfitter:Reset()
	OutfitterFrame:Hide()
	
	self:ClearSelection()
	self.OutfitStack:Clear()
	
	self:InitializeSettings()

	self.CurrentOutfit = self:GetInventoryOutfit()
	self:InitializeOutfits()
	
	self.EquippedNeedsUpdate = false
	self.WeaponsNeedUpdate = false
end

function Outfitter:SetOutfitBindingIndex(pOutfit, pBindingIndex)
	if pBindingIndex then
		for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
			for vOutfitIndex, vOutfit in ipairs(vOutfits) do
				if vOutfit.BindingIndex == pBindingIndex then
					vOutfit.BindingIndex = nil
				end
			end
		end
	end
	
	pOutfit.BindingIndex = pBindingIndex
end

Outfitter.LastBindingIndex = nil
Outfitter.LastBindingTime = nil

Outfitter.cMinBindingTime = 0.75

function Outfitter:WearBoundOutfit(pBindingIndex)
	-- Check for the user spamming the button to prevent the outfit from
	-- toggling if they're panicking
	
	local vTime = GetTime()
	
	if Outfitter.LastBindingIndex == pBindingIndex then
		local vElapsed = vTime - Outfitter.LastBindingTime
		
		if vElapsed < Outfitter.cMinBindingTime then
			Outfitter.LastBindingTime = vTime
			return
		end
	end
	
	--
	
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vOutfitIndex, vOutfit in ipairs(vOutfits) do
			if vOutfit.BindingIndex == pBindingIndex then
				vOutfit.Disabled = nil
				if vCategoryID == "Complete" then
					Outfitter:WearOutfit(vOutfit)
					if not gOutfitter_Settings.Options.DisableHotkeyMessages then
						UIErrorsFrame:AddMessage(format(Outfitter.cEquipOutfitMessageFormat, vOutfit.Name), Outfitter.OUTFIT_MESSAGE_COLOR.r, Outfitter.OUTFIT_MESSAGE_COLOR.g, Outfitter.OUTFIT_MESSAGE_COLOR.b)
					end
				else
					local vEquipped = Outfitter:ToggleOutfit(vOutfit, vCategoryID)
					
					if not gOutfitter_Settings.Options.DisableHotkeyMessages then
						if vEquipped then
							UIErrorsFrame:AddMessage(format(Outfitter.cEquipOutfitMessageFormat, vOutfit.Name), Outfitter.OUTFIT_MESSAGE_COLOR.r, Outfitter.OUTFIT_MESSAGE_COLOR.g, Outfitter.OUTFIT_MESSAGE_COLOR.b)
						else
							UIErrorsFrame:AddMessage(format(Outfitter.cUnequipOutfitMessageFormat, vOutfit.Name), Outfitter.OUTFIT_MESSAGE_COLOR.r, Outfitter.OUTFIT_MESSAGE_COLOR.g, Outfitter.OUTFIT_MESSAGE_COLOR.b)
						end
					end
				end
				
				-- Remember the binding used to filter for button spam
				
				Outfitter.LastBindingIndex = pBindingIndex
				Outfitter.LastBindingTime = vTime
				
				return
			end
		end
	end
end

function Outfitter:FindOutfit(pOutfit)
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vOutfitIndex, vOutfit in ipairs(vOutfits) do
			if vOutfit == pOutfit then
				return vCategoryID, vOutfitIndex
			end
		end
	end
	
	return nil, nil
end

function Outfitter:FindOutfitByName(pName)
	if not pName
	or pName == "" then
		return nil
	end
	
	local vLowerName = strlower(pName)
	
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vOutfitIndex, vOutfit in ipairs(vOutfits) do
			if strlower(vOutfit.Name) == vLowerName then
				return vOutfit, vCategoryID, vOutfitIndex
			end
		end
	end
	
	return nil, nil
end

function Outfitter:GetOutfitCategoryID(pOutfit)
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vOutfitIndex, vOutfit in ipairs(vOutfits) do
			if vOutfit == pOutfit then
				return vCategoryID, vOutfitIndex
			end
		end
	end
end

-- Outfitter doesn't use this function, but other addons such as
-- Fishing Buddy might use it to locate specific generated outfits

function Outfitter:FindOutfitByStatID(pStatID)
	if not pStatID or pStatID == "" then
		return nil
	end

	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vOutfitIndex, vOutfit in ipairs(vOutfits) do
			if vOutfit.StatID and vOutfit.StatID == pStatID then
				return vOutfit, vCategoryID, vOutfitIndex
			end
		end
	end
	
	return nil
end

function Outfitter:GetPlayerStatDistribution()
	return Outfitter.cStatDistribution[Outfitter.PlayerClass]
end

Outfitter.BaseRatings61 =
{
	Expertise = 2.5,
	
	MeleeHaste = 10,
	MeleeHit = 10,
	MeleeCrit = 14,
	
	SpellHaste = 10,
	SpellHit = 8,
	SpellCrit = 14,
	
	Defense = 1.5,
	Dodge = 12,
	Parry = 15,
	Block = 5,
	Resilience = 25,
}

function Outfitter:GetPlayerRatingStatDistribution()
	local vLevel = UnitLevel("player")
	
	if Outfitter.RatingStatDistribution
	and Outfitter.RatingStatDistributionLevel == vLevel then
		return Outfitter.RatingStatDistribution
	end
	
	--
	
	Outfitter.RatingStatDistribution = {}
	
	if vLevel < 10 then
		vLevel = 10
	end
	
	local vLevelFactor
	
	if vLevel <= 60 then
		vLevelFactor = (vLevel - 8) / 52
	
	elseif vLevel <= 70 then
		vLevelFactor = 82 / (262 - 3 * vLevel)
	end
	
	for vStatID, vBase in pairs(Outfitter.BaseRatings61) do
		Outfitter.RatingStatDistribution[vStatID.."Rating"] = {[vStatID] = {Coeff = 1.0 / (vBase * vLevelFactor)}}
	end
	
	return Outfitter.RatingStatDistribution
end
	
function Outfitter:OutfitSummary()
	local vStatDistribution = Outfitter:GetPlayerStatDistribution()
	
	Outfitter:DebugTable("StatDistribution", vStatDistribution)
	
	local vCurrentOutfitStats = Outfitter.TankPoints_GetCurrentOutfitStats(vStatDistribution)
	
	Outfitter:DebugTable("Current Stats", vCurrentOutfitStats)
end

function Outfitter:RatingSummary()
	local vRatingIDs =
	{
		"Weapon",
		"Defense",
		"Dodge",
		"Parry",
		"Block",
		"Melee Hit",
		"Ranged Hit",
		"Spell Hit",
		"Melee Crit",
		"Ranged Crit",
		"Spell Crit",
		"Melee Hit Taken",
		"Ranged Hit Taken",
		"Spell Hit Taken",
		"Melee Crit Taken",
		"Ranged Crit Taken",
		"Spell Crit Taken",
		"Melee Haste",
		"Ranged Haste",
		"Spell Haste",
	}
	
	for vRatingID, vRatingName in ipairs(vRatingIDs) do
		local vRating = GetCombatRating(vRatingID)
		local vRatingBonus = GetCombatRatingBonus(vRatingID)
		
		if vRatingBonus > 0 then
			Outfitter:NoteMessage(vRatingName..": "..(vRating / vRatingBonus))
		end
	end
end

-- Work-in-progress for bag organization.  Probably will get split into another addon
-- at some point, just playing around with it for now.

local gOutfitter_SortBagItems
local gOutfitter_Categories =
{
	"Armor",
	"Weapons",
	"Consumables",
		"Potions",
		"Healthstone",
		"Mana gem",
		"Flasks",
		"Elixirs",
		"Bandages",
		"Trinkets",
	"Tradeskill",
		"Herbs",
		"Metals",
		"Gems",
		"Cloth",
		"Leather",
		"Cooking",
			"Spices",
			"Meat",
	"QuestItems",
	"Loot",
		"BoEs",
	"Junk",
}

local gOutfitterItemCorrections =
{
	[6533] = {Type = "Consumable", SubType = "Other"}, -- Aquadynamic Fish Attractor
	[27503] = {SubType = "Scroll"}, -- Scroll of Protection V
	[27515] = {Type = "Trade Goods", SubType = "Meat", InvType = ""}, -- Huge Spotted Feltail
}

function Outfitter:CorrectItemInfo(pItemInfo)
	local vCorrection = gOutfitterItemCorrections[pItemInfo.Code]
	
	if not vCorrection then
		return
	end
	
	for vIndex, vValue in pairs(vCorrection) do
		pItemInfo[vIndex] = vValue
	end
end

function Outfitter.GetItemSortRank(pItem)
	if pItem.ItemIsUsed then
		return 0
	elseif pItem.Quality == 0 then
		return 3
	elseif pItem.Equippable then
		return 2
	else
		return 1
	end
end

function Outfitter:SortBags()
	-- Gather a list of the items
	
	local vItems = {}
	local vIterator = Outfitter:NewBagIterator()
	
	while vIterator:NextSlotLTR() do
		local vItemInfo = Outfitter:GetBagItemInfo(vIterator.BagIndex, vIterator.BagSlotIndex)
		
		if vItemInfo then
			Outfitter:CorrectItemInfo(vItemInfo)
			
			vItemInfo.BagIndex = vIterator.BagIndex
			vItemInfo.BagSlotIndex = vIterator.BagSlotIndex
			vItemInfo.ItemIsUsed = Outfitter:GetOutfitsUsingItem(vItemInfo)
			vItemInfo.Equippable = vItemInfo.InvType ~= ""
			vItemInfo.SortRank = Outfitter.GetItemSortRank(vItemInfo)
			
			table.insert(vItems, vItemInfo)
		end
	end
	
	-- Sort the items
	
	table.sort(vItems, Outfitter.BagSortCompareItems)
	
	-- Assign the items to bag slots
	
	local vDestBagSlot = Outfitter:NewBagIterator()
	
	for _, vItemInfo in ipairs(vItems) do
		if not vDestBagSlot:NextSlotLTR() then
			break
		end
		
		vItemInfo.DestBagIndex = vDestBagSlot.BagIndex
		vItemInfo.DestBagSlotIndex = vDestBagSlot.BagSlotIndex
	end
	
	--
	
	MCEventLib:RegisterEvent("BAG_UPDATE", Outfitter.BagSortBagsChanged, vItems)
	
	Outfitter.BagSortUpdate(vItems)
end	

function Outfitter.BagSortBagsChanged(pItems)
	MCSchedulerLib:RescheduleTask(0.5, Outfitter.BagSortUpdate, pItems)
end

function Outfitter.BagSortCompareItems(pItem1, pItem2) -- Must not be method since it's called by table.sort
	if pItem1.SortRank ~= pItem2.SortRank then
		return pItem1.SortRank < pItem2.SortRank
	end
	
	-- If both items are equippable, sort them by
	-- slot first
	
	if pItem1.Equippable then
		return pItem1.InvType < pItem2.InvType
	end
	
	-- Sort items by type
	
	if pItem1.Type ~= pItem2.Type then
		return pItem1.Type < pItem2.Type
	end
	
	-- Sort by subtype
	
	if pItem1.SubType ~= pItem2.SubType then
		return pItem1.SubType < pItem2.SubType
	end
	
	-- Sort by name
	
	return pItem1.Name < pItem2.Name
end

function Outfitter.BagSortUpdate(pItems)
	local vDidMove = false
	local vBagSlotUsed = {}
	
	for vIndex = 0, NUM_BAG_SLOTS do
		vBagSlotUsed[vIndex] = {}
	end
	
	-- Move the items to their destinations
	
	local vSaved_EnableSFX = GetCVar("Sound_EnableSFX")
	SetCVar("Sound_EnableSFX", "0")
	
	for _, vItemInfo in ipairs(pItems) do
		if (vItemInfo.BagIndex ~= vItemInfo.DestBagIndex
		or vItemInfo.BagSlotIndex ~= vItemInfo.DestBagSlotIndex)
		and not vBagSlotUsed[vItemInfo.BagIndex][vItemInfo.BagSlotIndex]
		and not vBagSlotUsed[vItemInfo.DestBagIndex][vItemInfo.DestBagSlotIndex] then
			
			-- Find the item currently at the destination (if any)
			
			local vDestItemInfo
			
			for _, vItemInfo2 in ipairs(pItems) do
				if vItemInfo2.BagSlotIndex == vItemInfo.DestBagSlotIndex
				and vItemInfo2.BagIndex == vItemInfo.DestBagIndex then
					vDestItemInfo = vItemInfo2
					break
				end
			end
			
			-- Move/swap the items
			
			Outfitter:NoteMessage(format(
					"Moving %s from bag %d, %d to %d, %d",
					vItemInfo.Name,
					vItemInfo.BagIndex, vItemInfo.BagSlotIndex,
					vItemInfo.DestBagIndex, vItemInfo.DestBagSlotIndex))
			
			ClearCursor()
			Outfitter:PickupItemLocation(vItemInfo)
			Outfitter:PickupItemLocation({BagIndex = vItemInfo.DestBagIndex, BagSlotIndex = vItemInfo.DestBagSlotIndex})
			
			-- Mark the bag slots as already being involved in this round
			
			vBagSlotUsed[vItemInfo.BagIndex][vItemInfo.BagSlotIndex] = true
			vBagSlotUsed[vItemInfo.DestBagIndex][vItemInfo.DestBagSlotIndex] = true
			
			-- Update the source and dest item info
			
			if vDestItemInfo then
				vDestItemInfo.BagIndex = vItemInfo.BagIndex
				vDestItemInfo.BagSlotIndex = vItemInfo.BagSlotIndex
			end
			
			vItemInfo.BagIndex = vItemInfo.DestBagIndex
			vItemInfo.BagSlotIndex = vItemInfo.DestBagSlotIndex
			
			vDidMove = true
		end
	end
	
	SetCVar("Sound_EnableSFX", vSaved_EnableSFX)
	
	if vDidMove then
		-- Do nothing: the BAG_UPDATE event should fire once our items start moving
		-- and then we'll be called again
	else
		MCEventLib:UnregisterEvent("BAG_UPDATE", Outfitter.BagSortBagsChanged, pItems)
	end
end

function Outfitter:NewBagIterator()
	local vIterator = {}
	
	function vIterator:ResetLTR()
		self.BagIndex = NUM_BAG_SLOTS
		self.BagSlotIndex = 0
		
		if Outfitter:GetBagType(self.BagIndex) == Outfitter.cContainerBagSubType then
			self.NumBagSlots = GetContainerNumSlots(self.BagIndex)
		else
			self.NumBagSlots = 0
		end
	end
	
	function vIterator:NextSlotLTR()
		self.BagSlotIndex = self.BagSlotIndex + 1
		
		while self.BagSlotIndex > self.NumBagSlots do
			self.BagIndex = self.BagIndex - 1
			
			if self.BagIndex < 0 then
				return false
			end
			
			self.BagSlotIndex = 1
			
			if Outfitter:GetBagType(self.BagIndex) == Outfitter.cContainerBagSubType then
				self.NumBagSlots = GetContainerNumSlots(self.BagIndex)
			else
				self.NumBagSlots = 0
			end
		end
		
		return true
	end
	
	vIterator:ResetLTR()
	
	return vIterator
end

function Outfitter:GetCompiledOutfit()
	local vCompiledOutfit = Outfitter:NewEmptyOutfit()
	
	vCompiledOutfit.SourceOutfit = {}
	
	for vStackIndex, vOutfit in ipairs(Outfitter.OutfitStack.Outfits) do
		for vInventorySlot, vOutfitItem in pairs(vOutfit.Items) do
			vCompiledOutfit.Items[vInventorySlot] = vOutfitItem
			vCompiledOutfit.SourceOutfit[vInventorySlot] = vOutfit.Name
		end
	end
	
	-- Make sure the OH slot is marked as empty if a 2H weapon is equipped
	
	if vCompiledOutfit.Items.MainHandSlot
	and vCompiledOutfit.Items.MainHandSlot.InvType == "INVTYPE_2HWEAPON" then
		vCompiledOutfit.Items.SecondaryHandSlot = Outfitter:NewEmptyItemInfo()
	end
	
	return vCompiledOutfit
end

function Outfitter:GetExpectedOutfit(pExcludeOutfit)
	local vCompiledOutfit = Outfitter:NewEmptyOutfit()
	
	vCompiledOutfit.SourceOutfit = {}
	
	for vStackIndex, vOutfit in ipairs(Outfitter.OutfitStack.Outfits) do
		if vOutfit ~= pExcludeOutfit then
			for vInventorySlot, vOutfitItem in pairs(vOutfit.Items) do
				vCompiledOutfit.Items[vInventorySlot] = vOutfitItem
				vCompiledOutfit.SourceOutfit[vInventorySlot] = vOutfit.Name
			end
		end
	end
	
	return vCompiledOutfit
end

function Outfitter:GetBagType(pBagIndex)
	if pBagIndex == 0 then -- special case zero since ContainerIDToInventoryID will barf on it
		return Outfitter.cContainerBagSubType
	end
	
	if pBagIndex < 0 then
		pBagIndex = 4 - pBagIndex
	end
	
	local vItemLink = GetInventoryItemLink("player", ContainerIDToInventoryID(pBagIndex))
	
	if not vItemLink then
		return nil
	end
	
	local vItemInfo = Outfitter:GetItemInfoFromLink(vItemLink)
	
	if not vItemInfo then
		return nil
	end
	
	return vItemInfo.SubType
end

function Outfitter:GetEmptyBagSlot(pStartBagIndex, pStartBagSlotIndex, pIncludeBank)
	local vStartBagIndex = pStartBagIndex
	local vStartBagSlotIndex = pStartBagSlotIndex
	
	if not vStartBagIndex then
		vStartBagIndex = NUM_BAG_SLOTS
	end
	
	if not vStartBagSlotIndex then
		vStartBagSlotIndex = 1
	end
	
	local vEndBagIndex = 0
	
	if pIncludeBank then
		vEndBagIndex = -1
	end
	
	for vBagIndex = vStartBagIndex, vEndBagIndex, -1 do
		-- Search ordinary container bags for empty slots
		
		if Outfitter:GetBagType(vBagIndex) == Outfitter.cContainerBagSubType then
			local vNumBagSlots = GetContainerNumSlots(vBagIndex)
			
			if vNumBagSlots > 0 then
				for vSlotIndex = vStartBagSlotIndex, vNumBagSlots do
					local vItemInfo = Outfitter:GetBagItemInfo(vBagIndex, vSlotIndex)
					
					if not vItemInfo then
						return {BagIndex = vBagIndex, BagSlotIndex = vSlotIndex}
					end
				end
			end
		end
		
		vStartBagSlotIndex = 1
	end
	
	return nil
end

function Outfitter:GetEmptyBagSlotList()
	local vEmptyBagSlots = {}
	
	local vBagIndex = NUM_BAG_SLOTS
	local vBagSlotIndex = 1
	
	while true do
		local vBagSlotInfo = Outfitter:GetEmptyBagSlot(vBagIndex, vBagSlotIndex)
		
		if not vBagSlotInfo then
			return vEmptyBagSlots
		end
		
		table.insert(vEmptyBagSlots, vBagSlotInfo)
		
		vBagIndex = vBagSlotInfo.BagIndex
		vBagSlotIndex = vBagSlotInfo.BagSlotIndex + 1
	end
end

function Outfitter:GetEmptyBankSlotList()
	local vEmptyBagSlots = {}
	
	local vBagIndex = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
	local vBagSlotIndex = 1
	
	while true do
		local vBagSlotInfo = Outfitter:GetEmptyBagSlot(vBagIndex, vBagSlotIndex, true)
		
		if not vBagSlotInfo then
			return vEmptyBagSlots
		
		elseif vBagSlotInfo.BagIndex > NUM_BAG_SLOTS
		or vBagSlotInfo.BagIndex < 0 then
			table.insert(vEmptyBagSlots, vBagSlotInfo)
		end
		
		vBagIndex = vBagSlotInfo.BagIndex
		vBagSlotIndex = vBagSlotInfo.BagSlotIndex + 1
	end
end

function Outfitter:FindItemsInBagsForSlot(pSlotName, pIgnoreItems)
	-- Alias the slot names down for finger and trinket
	
	local vInventorySlot = pSlotName
	
	if vInventorySlot == "Finger1Slot" then
		vInventorySlot = "Finger0Slot"
	elseif vInventorySlot == "Trinket1Slot" then
		vInventorySlot = "Trinket0Slot"
	end
	
	--
	
	local vItems = {}
	local vNumBags, vFirstBagIndex = Outfitter:GetNumBags()
	
	for vBagIndex = vFirstBagIndex, vNumBags do
		local vNumBagSlots = GetContainerNumSlots(vBagIndex)
		
		if vNumBagSlots > 0 then
			for vSlotIndex = 1, vNumBagSlots do
				local vItemInfo = Outfitter:GetBagItemInfo(vBagIndex, vSlotIndex)
				
				if vItemInfo
				and (not pIgnoreItems or not pIgnoreItems[vItemInfo.Code]) then
					local vItemSlotName = vItemInfo.ItemSlotName
					
					if vItemInfo.MetaSlotName then
						vItemSlotName = vItemInfo.MetaSlotName
					end
					
					if vItemSlotName == "TwoHandSlot" then
						vItemSlotName = "MainHandSlot"
					
					elseif vItemSlotName == "Weapon0Slot" then
						if vInventorySlot == "MainHandSlot"
						or vInventorySlot == "SecondaryHandSlot" then
							vItemSlotName = vInventorySlot
						end
					end
					
					if vItemSlotName == vInventorySlot then
						table.insert(vItems, {BagIndex = vBagIndex, BagSlotIndex = vSlotIndex, Code = vItemInfo.Code, Name = vItemInfo.Name})
					end
				end
			end
		end
	end
	
	if #vItems == 0 then	
		return nil
	end
	
	return vItems
end

function Outfitter:PickupItemLocation(pItemLocation)
	if pItemLocation == nil then
		Outfitter:ErrorMessage("nil location in PickupItemLocation")
		return
	end
	
	if pItemLocation.BagIndex then
		if CT_oldPickupContainerItem then
			CT_oldPickupContainerItem(pItemLocation.BagIndex, pItemLocation.BagSlotIndex)
		else
			PickupContainerItem(pItemLocation.BagIndex, pItemLocation.BagSlotIndex)
		end
	elseif pItemLocation.SlotName then
		PickupInventoryItem(Outfitter.cSlotIDs[pItemLocation.SlotName])
	else
		Outfitter:ErrorMessage("Unknown location in PickupItemLocation")
		return
	end
end

function Outfitter:DebugEquipmentChangeList(pEquipmentChangeList)
	Outfitter:DebugMark()
	Outfitter:DebugTable("ChangeList", pEquipmentChangeList)
end

function Outfitter:BuildUnequipChangeList(pOutfit, pEquippableItems)
	local vEquipmentChangeList = {}

	for vInventorySlot, vOutfitItem in pairs(pOutfit.Items) do
		local vItem, vIgnoredItem = Outfitter.ItemList_FindItemOrAlt(pEquippableItems, vOutfitItem, true)
		
		if vItem then
			table.insert(vEquipmentChangeList, {FromLocation = vItem.Location, Item = vItem, ToLocation = nil})
		end
	end -- for
	
	return vEquipmentChangeList
end

function Outfitter:BuildEquipmentChangeList(pOutfit, pEquippableItems)
	local vEquipmentChangeList = {}
	
	Outfitter.ItemList_ResetIgnoreItemFlags(pEquippableItems)
	
	-- Remove items which are already in the correct slot from the outfit and from the
	-- equippable items list
	
	for vInventorySlot, vOutfitItem in pairs(pOutfit.Items) do
		local vContainsItem, vItem = Outfitter.ItemList_InventorySlotContainsItem(pEquippableItems, vInventorySlot, vOutfitItem)
		
		if vContainsItem then
			pOutfit.Items[vInventorySlot] = nil
			
			if vItem then
				vItem.IgnoreItem = true
			end
		end
	end
	
	-- Scan the outfit using the Outfitter.cSlotNames array as an index so that changes
	-- are executed in the specified order.  The order is designed so that items with
	-- durability values are unequipped first, followed by other items such as cloaks and rings
	-- which have no durability.  This makes unequipping before a wipe more practical for
	-- classes who can get away with it (Feign Death ftw, or "for the repair bill" I should say).
	
	self.EquippedUniqueGemIndex = self:RecycleTable(self.EquippedUniqueGemIndex)
	self.EquippedUniqueGemItem = self:RecycleTable(self.EquippedUniqueGemItem)
	
	for _, vInventorySlot in ipairs(self.cSlotNames) do
		local vOutfitItem = pOutfit.Items[vInventorySlot]
		
		if vOutfitItem then
			local vSlotID = Outfitter.cSlotIDs[vInventorySlot]
			local vCurrentItemInfo = self:GetInventoryItemInfo(vInventorySlot)
			local vInsertBefore = #vEquipmentChangeList + 1
			
			-- The CurrentItemInfo is the item being unequipped.  If another item
			-- with the same gem has already been equipped, then insert the unequip
			-- entry before that one
			
			if vCurrentItemInfo then
				for vIndex = 1, 4 do
					local vJewelCode = vCurrentItemInfo["JewelCode"..vIndex]
					
					if self.EquippedUniqueGemIndex[vJewelCode] then
						-- Move this unequip operation above the first gem it conflicts with
						
						if not vInsertBefore
						or self.EquippedUniqueGemIndex[vJewelCode] < vInsertBefore then
							vInsertBefore = self.EquippedUniqueGemIndex[vJewelCode]
						end
						
						self.EquippedUniqueGemIndex[vJewelCode] = nil
						self.EquippedUniqueGemItem[vJewelCode] = nil
					end
				end
			end
						
			-- Empty the slot if it's supposed to be blank
			
			if vOutfitItem.Code == 0 or vOutfitItem.Code == nil then
				if vCurrentItemInfo then
					table.insert(vEquipmentChangeList, vInsertBefore, {SlotName = vInventorySlot, SlotID = vSlotID, ItemName = vOutfitItem.Name, ItemLocation = nil})
					
					-- Adjust any entries in the EquippedUniqueGemIndex table to account for the insertion
					
					for vJewelCode, vChangeIndex in pairs(self.EquippedUniqueGemIndex) do
						if vChangeIndex >= vInsertBefore then
							self.EquippedUniqueGemIndex[vJewelCode] = vChangeIndex + 1
						end
					end
				end
			else
				-- Find the item
				
				local vItem, vIgnoredItem = Outfitter.ItemList_FindItemOrAlt(pEquippableItems, vOutfitItem, true)
				
				-- If the item wasn't found then show an appropriate error message

				if not vItem then
					self:ShowEquipError(vOutfitItem, vIgnoredItem, vInventorySlot)
				
				-- Otherwise generate a change to move the item from its present location to the correct slot
				
				else
					pOutfit.Items[vInventorySlot].MetaSlotName = vItem.MetaSlotName
					table.insert(vEquipmentChangeList, vInsertBefore, {SlotName = vInventorySlot, SlotID = vSlotID, ItemName = vOutfitItem.Name, ItemMetaSlotName = vItem.MetaSlotName, ItemLocation = vItem})
					
					-- Adjust any entries in the EquippedUniqueGemIndex table to account for the insertion
					
					for vJewelCode, vChangeIndex in pairs(self.EquippedUniqueGemIndex) do
						if vChangeIndex >= vInsertBefore then
							self.EquippedUniqueGemIndex[vJewelCode] = vChangeIndex + 1
						end
					end
					
					-- Note any unique-equipped gems being put on
					
					for vIndex = 1, 4 do
						local vJewelCode = vItem["JewelCode"..vIndex]
						
						if self.cUniqueEquippedGemIDs[vJewelCode] then
							if self.EquippedUniqueGemIndex[vJewelCode] then
								-- Another item with the same jewel code is already being equipped, just warn the user
								
								Outfitter:NoteMessage("Attempting to equip %s and %s, but they have the same unique-equipped gem", vOutfitItem.Name or "unknown", self.EquippedUniqueGemItem[vJewelCode].Name or "unknown")
							else
								self.EquippedUniqueGemIndex[vJewelCode] = vInsertBefore
								self.EquippedUniqueGemItem[vJewelCode] = vOutfitItem
							end
						end -- if cUniqueEquippedGemIDs
					end -- for vIndex
				end -- else not vItem
			end -- else vOutfitItem.Code == 0 or vOutfitItem.Code == nil
		end -- if
	end -- for
	
	if #vEquipmentChangeList == 0 then
		return nil
	end
	
	Outfitter:OptimizeEquipmentChangeList(vEquipmentChangeList)
	
	return vEquipmentChangeList
end

function Outfitter:ShowEquipError(pOutfitItem, pIgnoredItem, pInventorySlot)
	if pOutfitItem.Name then
		if pIgnoredItem then
			local vSlotDisplayName = Outfitter.cSlotDisplayNames[pInventorySlot]
			
			if not vSlotDisplayName then
				vSlotDisplayName = pInventorySlot
			end
			
			Outfitter:ErrorMessage(format(Outfitter.cItemAlreadyUsedError, pOutfitItem.Name, vSlotDisplayName))
		else
			Outfitter:ErrorMessage(format(Outfitter.cItemNotFoundError, pOutfitItem.Name))
		end
	else
		Outfitter:ErrorMessage(format(Outfitter.cItemNotFoundError, "unknown"))
	end
end

function Outfitter:FindEquipmentChangeForSlot(pEquipmentChangeList, pSlotName)
	for vChangeIndex, vEquipmentChange in ipairs(pEquipmentChangeList) do
		if vEquipmentChange.SlotName == pSlotName then
			return vChangeIndex, vEquipmentChange
		end
	end
	
	return nil, nil
end

function Outfitter:FixSlotSwapChange(pEquipmentList, pChangeIndex1, pEquipmentChange1, pSlotName1, pChangeIndex2, pEquipmentChange2, pSlotName2)
	-- No problem if both slots will be emptied
	
	if not pEquipmentChange1.ItemLocation
	and not pEquipmentChange2.ItemLocation then
		return
	end
	
	-- No problem if neither slot is being moved to the other one
	
	local vSlot2ToSlot1 = pEquipmentChange1.ItemLocation ~= nil
			            and pEquipmentChange1.ItemLocation.SlotName == pSlotName2
	
	local vSlot1ToSlot2 = pEquipmentChange2.ItemLocation ~= nil
			            and pEquipmentChange2.ItemLocation.SlotName == pSlotName1
	
	-- No problem if the slots are swapping with each other
	-- or not moving between each other at all
	
	if vSlot2ToSlot1 == vSlot1ToSlot2 then
		return
	end
	
	-- Slot 1 is moving to slot 2
	
	if vSlot1ToSlot2 then
		
		if pEquipmentChange1.ItemLocation then
			-- Swap change 1 and change 2 around
			
			pEquipmentList[pChangeIndex1] = pEquipmentChange2
			pEquipmentList[pChangeIndex2] = pEquipmentChange1
			
			-- Insert a change to empty slot 2
			
			table.insert(pEquipmentList, pChangeIndex1, {SlotName = pEquipmentChange2.SlotName, SlotID = pEquipmentChange2.SlotID, ItemLocation = nil})
		else
			-- Slot 1 is going to be empty, so empty slot 2 instead
			-- and then when slot 1 is moved it'll swap the empty space
			
			pEquipmentChange1.SlotName = pSlotName2
			pEquipmentChange1.SlotID = pEquipmentChange2.SlotID
			pEquipmentChange1.ItemLocation = nil
		end
		
	-- Slot 2 is moving to slot 1
	
	else
		if pEquipmentChange2.ItemLocation then
			-- Insert a change to empty slot 1 first
			
			table.insert(pEquipmentList, pChangeIndex1, {SlotName = pEquipmentChange1.SlotName, SlotID = pEquipmentChange1.SlotID, ItemLocation = nil})
		else
			-- Slot 2 is going to be empty, so empty slot 1 instead
			-- and then when slot 2 is moved it'll swap the empty space
			
			pEquipmentChange2.SlotName = pSlotName1
			pEquipmentChange2.SlotID = pEquipmentChange1.SlotID
			pEquipmentChange2.ItemLocation = nil
			
			-- Change the order so that slot 1 gets emptied before the move
			
			pEquipmentList[pChangeIndex1] = pEquipmentChange2
			pEquipmentList[pChangeIndex2] = pEquipmentChange1
		end
	end
end

function Outfitter:OptimizeEquipmentChangeList(pEquipmentChangeList)
	local vSwapList =
	{
		{Slot1 = "Finger0Slot", Slot2 = "Finger1Slot"},
		{Slot1 = "Trinket0Slot", Slot2 = "Trinket1Slot"},
		{Slot1 = "MainHandSlot", Slot2 = "SecondaryHandSlot"},
	}
	
	local vDidSlot = {}
	
	local vChangeIndex = 1
	local vNumChanges = #pEquipmentChangeList
	
	while vChangeIndex <= vNumChanges do
		local vEquipmentChange = pEquipmentChangeList[vChangeIndex]
		
		-- If a two-hand weapon is being equipped, remove the change event
		-- for removing the offhand slot
		
		if vEquipmentChange.ItemMetaSlotName == "TwoHandSlot" then
			local vChangeIndex2, vEquipmentChange2 = Outfitter:FindEquipmentChangeForSlot(pEquipmentChangeList, "SecondaryHandSlot")
			
			-- If there's a change for the offhand slot, remove it
			
			if vChangeIndex2 then
				table.remove(pEquipmentChangeList, vChangeIndex2)
				
				if vChangeIndex2 < vChangeIndex then
					vChangeIndex = vChangeIndex - 1
				end
				
				vNumChanges = vNumChanges - 1
			end
			
			-- Insert a new change for the offhand slot to empty it ahead
			-- of equipping the two-hand item
			
			local vSlotID = Outfitter.cSlotIDs.SecondaryHandSlot
			
			table.insert(pEquipmentChangeList, vChangeIndex, {SlotName = "SecondaryHandSlot", SlotID = vSlotID, ItemLocation = nil})
			
		-- Otherwise see if the change needs to be re-arranged so that slot
		-- swapping works correctly
		
		else
			for vSwapListIndex, vSwapSlotInfo in ipairs(vSwapList) do
				if vEquipmentChange.SlotName == vSwapSlotInfo.Slot1
				and not vDidSlot[vEquipmentChange.SlotName] then
					local vChangeIndex2, vEquipmentChange2 = Outfitter:FindEquipmentChangeForSlot(pEquipmentChangeList, vSwapSlotInfo.Slot2)
					
					if vChangeIndex2 then
						Outfitter:FixSlotSwapChange(pEquipmentChangeList, vChangeIndex, vEquipmentChange, vSwapSlotInfo.Slot1, vChangeIndex2, vEquipmentChange2, vSwapSlotInfo.Slot2)
					end
					
					vDidSlot[vEquipmentChange.SlotName] = true
					
					vNumChanges = #pEquipmentChangeList
				end
			end
		end
		
		-- Check for a unique-equipped gem being put on, then if the same gem is being removed
		-- we can move the unequipping one to happen first
		
		
		
		--
		
		vChangeIndex = vChangeIndex + 1
	end
end

function Outfitter:ExecuteEquipmentChangeList(pEquipmentChangeList, pEmptyBagSlots, pExpectedEquippableItems)
	local vSaved_EnableSFX
	
	if gOutfitter_Settings.DisableEquipSounds then
		vSaved_EnableSFX = GetCVar("Sound_EnableSFX")
		SetCVar("Sound_EnableSFX", "0")
	end
	
	ClearCursor() -- Make sure nothing is already being held
	
	for vChangeIndex, vEquipmentChange in ipairs(pEquipmentChangeList) do
		if vEquipmentChange.ItemLocation then
			Outfitter:PickupItemLocation(vEquipmentChange.ItemLocation)
			EquipCursorItem(vEquipmentChange.SlotID)
			
			if pExpectedEquippableItems then
				Outfitter.ItemList_SwapLocationWithInventorySlot(pExpectedEquippableItems, vEquipmentChange.ItemLocation, vEquipmentChange.SlotName)
			end
		else
			-- Remove the item
			
			if not pEmptyBagSlots
			or #pEmptyBagSlots == 0 then
				local vItemInfo = Outfitter:GetInventoryItemInfo(vEquipmentChange.SlotName)
				
				if not vItemInfo then
					Outfitter:ErrorMessage("Internal error: Can't empty slot %s because bags are full but slot is empty", vEquipmentChange.SlotName)
				else
					Outfitter:ErrorMessage(format(Outfitter.cBagsFullError, vItemInfo.Name))
				end
			else
				local vBagIndex = pEmptyBagSlots[1].BagIndex
				local vBagSlotIndex = pEmptyBagSlots[1].BagSlotIndex
				
				table.remove(pEmptyBagSlots, 1)
				
				PickupInventoryItem(vEquipmentChange.SlotID)
				if CT_oldPickupContainerItem then
					CT_oldPickupContainerItem(vBagIndex, vBagSlotIndex)
				else
					PickupContainerItem(vBagIndex, vBagSlotIndex)
				end
				
				if pExpectedEquippableItems then
					Outfitter.ItemList_SwapBagSlotWithInventorySlot(pExpectedEquippableItems, vBagIndex, vBagSlotIndex, vEquipmentChange.SlotName)
				end
			end
		end
	end
	
	if vSaved_EnableSFX then
		SetCVar("Sound_EnableSFX", vSaved_EnableSFX)
	end
end

function Outfitter:ExecuteEquipmentChangeList2(pEquipmentChangeList, pEmptySlots, pBagsFullErrorFormat, pExpectedEquippableItems)
	for vChangeIndex, vEquipmentChange in ipairs(pEquipmentChangeList) do
		if vEquipmentChange.ToLocation then
			Outfitter:PickupItemLocation(vEquipmentChange.FromLocation)
			EquipCursorItem(vEquipmentChange.SlotID)
			
			if pExpectedEquippableItems then
				Outfitter.ItemList_SwapLocationWithInventorySlot(pExpectedEquippableItems, vEquipmentChange.ToLocation, vEquipmentChange.SlotName)
			end
		else
			-- Remove the item
			
			if not pEmptySlots
			or #pEmptySlots == 0 then
				Outfitter:ErrorMessage(format(pBagsFullErrorFormat, vEquipmentChange.Item.Name))
			else
				local vToLocation = {BagIndex = pEmptySlots[1].BagIndex, BagSlotIndex = pEmptySlots[1].BagSlotIndex}
				
				table.remove(pEmptySlots, 1)
				
				Outfitter:PickupItemLocation(vEquipmentChange.FromLocation)
				Outfitter:PickupItemLocation(vToLocation)
				
				if pExpectedEquippableItems then
					Outfitter.ItemList_SwapLocations(pExpectedEquippableItems, vEquipmentChange.FromLocation, vToLocation)
				end
			end
		end
	end
end

function Outfitter:OutfitHasCombatEquipmentSlots(pOutfit)
	for vEquipmentSlot, _ in pairs(Outfitter.cCombatEquipmentSlots) do
		if pOutfit.Items[vEquipmentSlot] then
			return true
		end
	end
	
	return false
end

function Outfitter:OutfitOnlyHasCombatEquipmentSlots(pOutfit)
	for vEquipmentSlot, _ in pairs(pOutfit.Items) do
		if not Outfitter.cCombatEquipmentSlots[vEquipmentSlot] then
			return false
		end
	end
	
	return true
end

Outfitter.EquipmentUpdateCount = 0

function Outfitter:BeginEquipmentUpdate()
	self.EquipmentUpdateCount = self.EquipmentUpdateCount + 1
end

function Outfitter:EndEquipmentUpdate(pCallerName)
	self.EquipmentUpdateCount = self.EquipmentUpdateCount - 1
	
	if self.EquipmentUpdateCount == 0 then
		self:ScheduleEquipmentUpdate()
		self:Update(false)
	end
end

function Outfitter:UpdateEquippedItems()
	if not self.EquippedNeedsUpdate
	and not self.WeaponsNeedUpdate then
		return
	end
	
	-- Delay all changes until they're alive or not casting a spell
	
	if self.IsDead
	or self.IsCasting
	or self.IsChanneling then
		return
	end
	
	local vCurrentTime = GetTime()
	
	if vCurrentTime - self.LastEquipmentUpdateTime < self.cMinEquipmentUpdateInterval then
		self:ScheduleEquipmentUpdate()
		return
	end
	
	self.LastEquipmentUpdateTime = vCurrentTime
	
	local vWeaponsNeedUpdate = self.WeaponsNeedUpdate
	
	self.EquippedNeedsUpdate = false
	self.WeaponsNeedUpdate = false
	
	-- Compile the outfit
	
	local vEquippableItems = self.ItemList_GetEquippableItems()
	local vCompiledOutfit = self:GetCompiledOutfit()
	
	-- If the outfit contains non-weapon changes then
	-- delay the change until they're out of combat but go
	-- ahead and swap the weapon slots if there are any
	
	if self.InCombat or self.MaybeInCombat then
		if vWeaponsNeedUpdate
		and self:OutfitHasCombatEquipmentSlots(vCompiledOutfit) then
			
			-- Allow the weapon change to proceed but defer the rest
			-- until they're out of combat
			
			local vWeaponOutfit = self:NewEmptyOutfit()
			
			for vEquipmentSlot, _ in pairs(self.cCombatEquipmentSlots) do
				vWeaponOutfit.Items[vEquipmentSlot] = vCompiledOutfit.Items[vEquipmentSlot]
			end
			
			-- Still need to update the rest once they exit combat
			-- if there are non-equipment slot items
			
			if not self:OutfitOnlyHasCombatEquipmentSlots(vCompiledOutfit) then
				self.EquippedNeedsUpdate = true
			end
			
			-- Switch to the weapons-only part
			
			vCompiledOutfit = vWeaponOutfit
		else
			-- No weapon changes, just defer the whole outfit change
			
			self.EquippedNeedsUpdate = true
			self:ScheduleEquipmentUpdate()
			return
		end
	end
	
	-- Equip it
	
	local vEquipmentChangeList = self:BuildEquipmentChangeList(vCompiledOutfit, vEquippableItems)
	
	if vEquipmentChangeList then
		-- local vExpectedEquippableItems = self.ItemList_New()
	
		self:ExecuteEquipmentChangeList(vEquipmentChangeList, self:GetEmptyBagSlotList(), vExpectedEquippableItems)
		
		-- self:DebugTable("ExpectedEquippableItems", vExpectedEquippableItems)
	end
	
	-- Update the outfit we're expecting to see on the player
	
	for vInventorySlot, vItem in pairs(vCompiledOutfit.Items) do
		self.ExpectedOutfit.Items[vInventorySlot] = vCompiledOutfit.Items[vInventorySlot]
	end
	
	self.MaybeInCombat = false
	
	self:ScheduleEquipmentUpdate()
	
	-- self:TestMessage("Outfitter:UpdateEquippedItems: "..(GetTime() - vCurrentTime).."s")
end

function Outfitter:InventorySlotIsEmpty(pInventorySlot)
	return Outfitter:GetInventoryItemInfo(pInventorySlot) == nil
end

function Outfitter:GetBagItemInfo(pBagIndex, pSlotIndex)
	local vItemLink = GetContainerItemLink(pBagIndex, pSlotIndex)
	local vItemInfo = Outfitter:GetItemInfoFromLink(vItemLink)
	
	if not vItemInfo then
		return nil
	end
	
	vItemInfo.Texture = GetContainerItemInfo(pBagIndex, pSlotIndex)
	
	return vItemInfo
end

function Outfitter:GetAmmotSlotItemName()
	local vSlotID = Outfitter.cSlotIDs.AmmoSlot
	local vAmmoItemTexture = GetInventoryItemTexture("player", vSlotID)
	
	if not vAmmoItemTexture then
		return nil
	end
	
	OutfitterTooltip:SetOwner(OutfitterFrame, "ANCHOR_BOTTOMRIGHT", 0, 0)
	OutfitterTooltip:SetInventoryItem("player", vSlotID)
	
	if not OutfitterTooltipTextLeft1:IsShown() then
		OutfitterTooltip:Hide()
		return nil
	end
	
	local vAmmoItemName = OutfitterTooltipTextLeft1:GetText()
	
	OutfitterTooltip:Hide()
	
	return vAmmoItemName, vAmmoItemTexture
end

function Outfitter:GetBagSlotItemName(pBagIndex, pBagSlotIndex)
	OutfitterTooltip:SetOwner(OutfitterFrame, "ANCHOR_BOTTOMRIGHT", 0, 0)
	OutfitterTooltip:SetBagItem(pBagIndex, pBagSlotIndex)
	
	if not OutfitterTooltipTextLeft1:IsShown() then
		OutfitterTooltip:Hide()
		return nil
	end
	
	local vItemName = OutfitterTooltipTextLeft1:GetText()
	
	OutfitterTooltip:Hide()
	
	return vItemName
end

Outfitter.AmmoLinkByName = {}

function Outfitter:GetAmmotSlotItemLink()
	local vName, vTexture = Outfitter:GetAmmotSlotItemName()
	
	if not vName then
		return nil
	end
	
	local vLink = Outfitter.AmmoLinkByName[vName]
	
	if vLink then
		return vLink
	end
	
	vLink = Outfitter:FindAmmoSlotItemLink(vName)
	
	if not vLink then
		return nil
	end
	
	Outfitter.AmmoLinkByName[vName] = vLink
	return vLink
end

function Outfitter:FindAmmoSlotItemLink(pName)
	for vBagIndex = 0, NUM_BAG_SLOTS do
		local vNumBagSlots = GetContainerNumSlots(vBagIndex)
		
		for vBagSlotIndex = 1, vNumBagSlots do
			local vLink = GetContainerItemLink(vBagIndex, vBagSlotIndex)
			
			if vLink then
				local vName = Outfitter:GetBagSlotItemName(vBagIndex, vBagSlotIndex)
				
				if vName == pName then
					return vLink
				end
			end
		end -- for vBagSlotIndex
	end -- for vBagIndex
	
	-- Failed to find the ammo
	
	return nil
end

function Outfitter:GetInventoryItemInfo(pInventorySlot)
	local vSlotID = Outfitter.cSlotIDs[pInventorySlot]
	local vItemLink = Outfitter:GetInventorySlotIDLink(vSlotID)
	local vItemInfo = Outfitter:GetItemInfoFromLink(vItemLink)
	
	if not vItemInfo then
		return nil
	end
	
	vItemInfo.Quality = GetInventoryItemQuality("player", vSlotID)
	vItemInfo.Texture = GetInventoryItemTexture("player", vSlotID)
	
	return vItemInfo
end

function Outfitter:GetItemInfoFromLink(pItemLink)
	if not pItemLink then
		return nil
	end
	
	-- |cff1eff00|Hitem:1465:803:0:0:0:0:0:0|h[Tigerbane]|h|r
	-- |(hex code for item color)|Hitem:(item ID code):(enchant code):(added stats code):0|h[(item name)]|h|r
	
	local vStartIndex,
			vEndIndex,
			vLinkColor,
			vItemCode,
			vItemEnchantCode,
			vItemJewelCode1,
			vItemJewelCode2,
			vItemJewelCode3,
			vItemJewelCode4,
			vItemSubCode,
			vUnknownCode5,
			vItemName = strfind(pItemLink, Outfitter.cItemLinkFormat)
	
	if not vStartIndex then
		return nil
	end
	
	if vItemName then
		--Outfitter:TestMessage(string.format("Item %s:%d:%d:%d:%d:%d:%d:%d:%d", vItemName, vItemCode, vItemEnchantCode, vItemSubCode, vItemJewelCode1, vItemJewelCode2, vItemJewelCode3, vItemJewelCode4, vUnknownCode5))
	end
	
	vItemCode = tonumber(vItemCode)
	vItemSubCode = tonumber(vItemSubCode)
	vItemEnchantCode = tonumber(vItemEnchantCode)
	vItemJewelCode1 = tonumber(vItemJewelCode1)
	vItemJewelCode2 = tonumber(vItemJewelCode2)
	vItemJewelCode3 = tonumber(vItemJewelCode3)
	vItemJewelCode4 = tonumber(vItemJewelCode4)
	
	local vItemFamilyName,
			vItemLink,
			vItemQuality,
			vItemLevel,
			vItemMinLevel,
			vItemType,
			vItemSubType,
			vItemCount,
			vItemInvType = GetItemInfo(vItemCode)
	
	local vItemInfo =
	{
		Link = pItemLink,
		
		Code = vItemCode,
		SubCode = vItemSubCode,
		
		Name = vItemName,
		Quality = vItemQuality,
		Level = vItemLevel,
		MinLevel = vItemMinLevel,
		Type = vItemType,
		SubType = vItemSubType,
		
		Count = vItemCount,
		InvType = vItemInvType,
		
		EnchantCode = vItemEnchantCode,
		
		JewelCode1 = vItemJewelCode1,
		JewelCode2 = vItemJewelCode2,
		JewelCode3 = vItemJewelCode3,
		JewelCode4 = vItemJewelCode4,		
	}
	
	-- Just return if there's no inventory type
	
	if not vItemInvType
	or vItemInvType == "" then
		return vItemInfo
	end
	
	-- If it's a known inventory type add that knowledge to the item info
	
	local vInvTypeInfo = Outfitter.cInvTypeToSlotName[vItemInvType]
	
	if vInvTypeInfo then
		-- Get the slot name
		
		if not vInvTypeInfo.SlotName then
			Outfitter:ErrorMessage("Unknown slot name for inventory type "..vItemInvType)
			return vItemInfo
		end
		
		vItemInfo.ItemSlotName = vInvTypeInfo.SlotName
		vItemInfo.MetaSlotName = vInvTypeInfo.MetaSlotName
	else
		-- This function can be used to query non-equippable items, so it's not an error for
		-- the inventory type to be unknown.  Should Blizzard ever add a new type though, this
		-- debug message may be useful in figuring out its characteristics
		
		-- Outfitter:ErrorMessage("Unknown slot type "..vItemInvType.." for item "..vItemName)
	end
	
	-- Done
	
	return vItemInfo
end

function Outfitter:CreateNewOutfit()
	Outfitter.NameOutfit_Open(nil)
end

function Outfitter:NewEmptyOutfit(pName)
	return {Name = pName, Items = {}}
end

function Outfitter:IsEmptyOutfit(pOutfit)
	return Outfitter:ArrayIsEmpty(pOutfit.Items)
end

function Outfitter:NewNakedOutfit(pName)
	local vOutfit = Outfitter:NewEmptyOutfit(pName)

	for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
		Outfitter:AddOutfitItem(vOutfit, vInventorySlot, nil)
	end
	
	return vOutfit
end

function Outfitter:NewEmptyItemInfo()
	return
	{
		Name = "",
		Code = 0,
		SubCode = 0,
		EnchantCode = 0,
		JewelCode1 = 0,
		JewelCode2 = 0,
		JewelCode3 = 0,
		JewelCode4 = 0,
		InvType = nil,
	}
end

function Outfitter:AddOutfitItem(pOutfit, pSlotName, pItemInfo)
	if pItemInfo == nil then
		pItemInfo = Outfitter:NewEmptyItemInfo()
	end
	
	pOutfit.Items[pSlotName] =
	{
		Code = tonumber(pItemInfo.Code),
		SubCode = tonumber(pItemInfo.SubCode),
		Name = pItemInfo.Name,
		EnchantCode = tonumber(pItemInfo.EnchantCode),
		JewelCode1 = tonumber(pItemInfo.JewelCode1),
		JewelCode2 = tonumber(pItemInfo.JewelCode2),
		JewelCode3 = tonumber(pItemInfo.JewelCode3),
		JewelCode4 = tonumber(pItemInfo.JewelCode4),
		InvType = pItemInfo.InvType,
	}
end

function Outfitter:AddStats(pItem1, pItem2, pStatID)
	local vStat = 0
	
	if pItem1
	and pItem1[pStatID] then
		vStat = pItem1[pStatID]
	end
	
	if pItem2
	and pItem2[pStatID] then
		vStat = vStat + pItem2[pStatID]
	end
	
	return vStat
end

function Outfitter:CollapseMetaSlotsIfBetter(pOutfit, pStatID)
	-- Compare the weapon slot with the 1H/OH slots
	
	local vWeapon0Item = pOutfit.Items.Weapon0Slot
	local vWeapon1Item = pOutfit.Items.Weapon1Slot
	
	if vWeapon0Item or vWeapon1Item then
		-- Try the various combinations of MH/OH/W0/W1
		
		local v1HItem = pOutfit.Items.MainHandSlot
		local vOHItem = pOutfit.Items.SecondaryHandSlot
		
		local vCombinations =
		{
			{MainHand = v1HItem, SecondaryHand = vOHItem, AllowEmptyMainHand = true},
			{MainHand = v1HItem, SecondaryHand = vWeapon0Item, AllowEmptyMainHand = false},
			{MainHand = v1HItem, SecondaryHand = vWeapon1Item, AllowEmptyMainHand = false},
			{MainHand = vWeapon0Item, SecondaryHand = vOHItem, AllowEmptyMainHand = true},
			{MainHand = vWeapon1Item, SecondaryHand = vOHItem, AllowEmptyMainHand = true},
			{MainHand = vWeapon0Item, SecondaryHand = vWeapon1Item, AllowEmptyMainHand = false},
		}
		
		local vBestCombinationIndex = nil
		local vBestCombinationValue = nil
		
		for vIndex = 1, 6 do
			local vCombination = vCombinations[vIndex]
			
			-- Ignore combinations where the main hand is empty if
			-- that's not allowed in this combinations
			
			if vCombination.AllowEmptyMainHand
			or vCombination.MainHand then
				local vCombinationValue = Outfitter:AddStats(vCombination.MainHand, vCombination.SecondaryHand, pStatID)
				
				if not vBestCombinationIndex
				or vCombinationValue > vBestCombinationValue then
					vBestCombinationIndex = vIndex
					vBestCombinationValue = vCombinationValue
				end
			end
		end
		
		if vBestCombinationIndex then
			local vCombination = vCombinations[vBestCombinationIndex]
			
			pOutfit.Items.MainHandSlot = vCombination.MainHand
			pOutfit.Items.SecondaryHandSlot = vCombination.SecondaryHand
		end
		
		pOutfit.Items.Weapon0Slot = nil
		pOutfit.Items.Weapon1Slot = nil
	end
	
	-- Compare the 2H slot with the 1H/OH slots
	
	local v2HItem = pOutfit.Items.TwoHandSlot
	
	if v2HItem then
		local v1HItem = pOutfit.Items.MainHandSlot
		local vOHItem = pOutfit.Items.SecondaryHandSlot
		local v1HOHTotalStat = Outfitter:AddStats(v1HItem, vOHItem, pStatID)
		
		if v2HItem[pStatID]
		and v2HItem[pStatID] > v1HOHTotalStat then
			pOutfit.Items.MainHandSlot = v2HItem
			pOutfit.Items.SecondaryHandSlot = nil
		end
		
		pOutfit.Items.TwoHandSlot = nil
	end
end

function Outfitter:RemoveOutfitItem(pOutfit, pSlotName)
	pOutfit.Items[pSlotName] = nil
end

function Outfitter:GetInventoryOutfit(pName, pOutfit)
	local vOutfit
	
	if pOutfit then
		vOutfit = pOutfit
	else
		vOutfit = Outfitter:NewEmptyOutfit(pName)
	end
	
	for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
		local vItemInfo = Outfitter:GetInventoryItemInfo(vInventorySlot)
		
		-- To avoid extra memory operations, only update the item if it's different
		
		local vExistingItem = vOutfit.Items[vInventorySlot]
		
		if not vItemInfo then
			if not vExistingItem
			or vExistingItem.Code ~= 0 then
				Outfitter:AddOutfitItem(vOutfit, vInventorySlot, nil)
			end
		else
			if not vExistingItem
			or vExistingItem.Code ~= vItemInfo.Code
			or vExistingItem.SubCode ~= vItemInfo.SubCode
			or vExistingItem.EnchantCode ~= vItemInfo.EnchantCode 
			or vExistingItem.JewelCode1 ~= vItemInfo.JewelCode1
			or vExistingItem.JewelCode2 ~= vItemInfo.JewelCode2
			or vExistingItem.JewelCode3 ~= vItemInfo.JewelCode3
			or vExistingItem.JewelCode4 ~= vItemInfo.JewelCode4	then
				Outfitter:AddOutfitItem(vOutfit, vInventorySlot, vItemInfo)
			end
		end
	end
	
	return vOutfit
end

function Outfitter:UpdateOutfitFromInventory(pOutfit, pNewItemsOutfit)
	if not pNewItemsOutfit then
		return
	end
	
	for vInventorySlot, vItem in pairs(pNewItemsOutfit.Items) do
		-- Only update slots which aren't in an unknown state
		
		local vCheckbox = getglobal("OutfitterEnable"..vInventorySlot)
		
		if not vCheckbox:GetChecked()
		or not vCheckbox.IsUnknown then
			pOutfit.Items[vInventorySlot] = vItem
			Outfitter:NoteMessage(format(Outfitter.cAddingItem, vItem.Name, pOutfit.Name))
		end
	end
	
	-- Add the new items to the current compiled outfit
	
	for vInventorySlot, vItem in pairs(pNewItemsOutfit.Items) do
		Outfitter.ExpectedOutfit.Items[vInventorySlot] = pNewItemsOutfit.Items[vInventorySlot]
	end
	
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter:SubtractOutfit(pOutfit1, pOutfit2, pCheckAlternateSlots)
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	
	-- Remove items from pOutfit1 if they match the item in pOutfit2
	
	for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
		local vItem1 = pOutfit1.Items[vInventorySlot]
		local vItem2 = pOutfit2.Items[vInventorySlot]
		
		if Outfitter.ItemList_ItemsAreSame(vEquippableItems, vItem1, vItem2) then
			pOutfit1.Items[vInventorySlot] = nil
		elseif pCheckAlternateSlots then
			local vAlternateSlotName = Outfitter.cFullAlternateStatSlot[vInventorySlot]
			
			vItem2 = pOutfit2.Items[vAlternateSlotName]
			
			if Outfitter.ItemList_ItemsAreSame(vEquippableItems, vItem1, vItem2) then
				pOutfit1.Items[vInventorySlot] = nil
			end
		end
	end
end

function Outfitter:GetNewItemsOutfit(pPreviousOutfit)
	-- Get the current outfit and the list
	-- of equippable items
	
	Outfitter.CurrentInventoryOutfit = Outfitter:GetInventoryOutfit(Outfitter.CurrentInventoryOutfit)
	
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	
	-- Create a temporary outfit from the differences
	
	local vNewItemsOutfit = Outfitter:NewEmptyOutfit()
	local vOutfitHasItems = false
	
	for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
		local vCurrentItem = Outfitter.CurrentInventoryOutfit.Items[vInventorySlot]
		local vPreviousItem = pPreviousOutfit.Items[vInventorySlot]
		local vSkipSlot = false
		
		if vInventorySlot == "SecondaryHandSlot" then
			local vMainHandItem = pPreviousOutfit.Items["MainHandSlot"]
			
			if vMainHandItem
			and vMainHandItem.MetaSlotName == "TwoHandSlot" then
				vSkipSlot = true
			end
		elseif vInventorySlot == "AmmoSlot"
		and (not vCurrentItem or vCurrentItem.Code == 0) then
			vSkipSlot = true
		end
		
		if not vSkipSlot
		and not Outfitter.ItemList_InventorySlotContainsItem(vEquippableItems, vInventorySlot, vPreviousItem) then
			vNewItemsOutfit.Items[vInventorySlot] = vCurrentItem
			vOutfitHasItems = true
		end
	end
	
	if not vOutfitHasItems then
		return nil
	end
	
	return vNewItemsOutfit, Outfitter.CurrentInventoryOutfit
end

function Outfitter:UpdateTemporaryOutfit(pNewItemsOutfit)
	-- Just return if nothing has changed
	
	if not pNewItemsOutfit then
		return
	end
	
	-- Merge the new items with an existing temporary outfit
	
	local vTemporaryOutfit = Outfitter.OutfitStack:GetTemporaryOutfit()
	local vUsingExistingTempOutfit = false
	
	if vTemporaryOutfit then
	
		for vInventorySlot, vItem in pairs(pNewItemsOutfit.Items) do
			vTemporaryOutfit.Items[vInventorySlot] = vItem
		end
		
		vUsingExistingTempOutfit = true
	
	-- Otherwise add the new items as the temporary outfit
	
	else
		vTemporaryOutfit = pNewItemsOutfit
	end
	
	-- Subtract out items which are expected to be in the outfit
	
	local vExpectedOutfit = Outfitter:GetExpectedOutfit(vTemporaryOutfit)
	
	Outfitter:SubtractOutfit(vTemporaryOutfit, vExpectedOutfit)
	
	if Outfitter:IsEmptyOutfit(vTemporaryOutfit) then
		if vUsingExistingTempOutfit then
			Outfitter:RemoveOutfit(vTemporaryOutfit)
		end
	else
		if not vUsingExistingTempOutfit then
			Outfitter.OutfitStack:AddOutfit(vTemporaryOutfit)
		end
	end
	
	-- Add the new items to the current compiled outfit
	
	for vInventorySlot, vItem in pairs(pNewItemsOutfit.Items) do
		Outfitter.ExpectedOutfit.Items[vInventorySlot] = vItem
	end
end

function Outfitter:SetSlotEnable(pSlotName, pEnable)
	if not Outfitter.SelectedOutfit then
		return
	end
	
	if pEnable then
		Outfitter:SetInventoryItem(Outfitter.SelectedOutfit, pSlotName)
	else
		Outfitter.SelectedOutfit.Items[pSlotName] = nil
	end
	
	Outfitter.DisplayIsDirty = true
end

function Outfitter:SetInventoryItem(pOutfit, pSlotName)
	if not pOutfit then
		return
	end

	Outfitter:AddOutfitItem(pOutfit, pSlotName, Outfitter:GetInventoryItemInfo(pSlotName))
	
	Outfitter.DisplayIsDirty = true
end

function Outfitter:GetOutfitByScriptID(pScriptID)
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for _, vOutfit in ipairs(vOutfits) do
			if vOutfit.ScriptID == pScriptID then
				return vOutfit
			end
		end
	end
	
	return nil
end

function Outfitter:GetPlayerAuraStates()
	local vAuraStates =
	{
		Dining = false,
		Shadowform = false,
		GhostWolf = false,
		Feigning = false,
		Evocate = false,
		Monkey = false,
		Hawk = false,
		Cheetah = false,
		Pack = false,
		Beast = false,
		Wild = false,
		Viper = false,
		Prowl = false,
	}
	
	local vBuffIndex = 1
	
	while true do
		local vName, _, vTexture = UnitBuff("player", vBuffIndex)
		
		if not vTexture then
			return vAuraStates
		end
		
		local vStartIndex, vEndIndex, vTextureName = string.find(vTexture, "([^%\\]*)$")
		
		--
		
		local vSpecialID = Outfitter.cAuraIconSpecialID[vName]
		
		if not vSpecialID then
			vSpecialID = Outfitter.cAuraIconSpecialID[vTextureName]
		end
		
		if vSpecialID then
			vAuraStates[vSpecialID] = true
		
		--
		
		elseif not vAuraStates.Dining
		and string.find(vTextureName, "INV_Drink") then
			vAuraStates.Dining = true
		
		--
		
		else
			local vTextLine1, vTextLine2 = Outfitter:GetBuffTooltipText(vBuffIndex)
			
			if vTextLine1 then
				local vSpecialID = Outfitter.cSpellNameSpecialID[vTextLine1]
				
				if vSpecialID then
					vAuraStates[vSpecialID] = true
				end
			end
		end
		
		vBuffIndex = vBuffIndex + 1
	end
end

function Outfitter:GetBuffTooltipText(pBuffIndex)
	OutfitterTooltip:SetOwner(OutfitterFrame, "ANCHOR_BOTTOMRIGHT", 0, 0)
	OutfitterTooltip:SetUnitBuff("player", pBuffIndex)
	
	local vText1, vText2
	
	if OutfitterTooltipTextLeft1:IsShown() then
		vText1 = OutfitterTooltipTextLeft1:GetText()
	end -- if IsShown

	if OutfitterTooltipTextLeft2:IsShown() then
		vText2 = OutfitterTooltipTextLeft2:GetText()
	end -- if IsShown

	OutfitterTooltip:Hide()
	
	return vText1, vText2
end

function Outfitter:UpdateSwimming()
	MCEventLib:DispatchEvent("TIMER")
	
	Outfitter:UpdateMountedState()
	
	local vSwimming = false
	
	if IsSwimming() then
		vSwimming = true
	end
	
	if not Outfitter.SpecialState.Swimming then
		Outfitter.SpecialState.Swimming = false
	end
	
	Outfitter:SetSpecialOutfitEnabled("Swimming", vSwimming)
end

function Outfitter:UpdateAuraStates()
	Outfitter:BeginEquipmentUpdate()
	
	-- Check for special aura outfits

	local vAuraStates = Outfitter:GetPlayerAuraStates()
	
	for vSpecialID, vIsActive in pairs(vAuraStates) do
		if vSpecialID == "Feigning" then
			Outfitter.IsFeigning = vIsActive
		end
		
		if not Outfitter.SpecialState[vSpecialID] then
			Outfitter.SpecialState[vSpecialID] = false
		end
		
		-- Don't equip the dining outfit if health and mana are almost topped up

		if vSpecialID == "Dining"
		and vIsActive
		and Outfitter:PlayerIsFull() then
			vIsActive = false
		end
		
		-- Update the state
		
		Outfitter:SetSpecialOutfitEnabled(vSpecialID, vIsActive)
	end
	
	Outfitter:EndEquipmentUpdate()
	
	-- Update shapeshift state on aura change too
	-- NOTE: Currently (WoW client 2.3) the shapeshift info isn't
	-- always up-to-date when the AURA event comes in, so update
	-- the shapeshift state after about 1 frame to allow the state to
	-- synch
	
	MCSchedulerLib:ScheduleUniqueTask(0.01, Outfitter.UpdateShapeshiftState, Outfitter)
end

function Outfitter:UpdateMountedState()
	local vRiding = IsMounted() and not UnitOnTaxi("player")
	
	Outfitter:SetSpecialOutfitEnabled("Riding", vRiding)
end

function Outfitter:UpdateShapeshiftState()
	Outfitter:BeginEquipmentUpdate()
	
	local vNumForms = GetNumShapeshiftForms()
	
	-- Deactivate the previous shapeshift form first
	
	local vActiveForm
	
	for vIndex = 1, vNumForms do
		local vTexture, vName, vIsActive, vIsCastable = GetShapeshiftFormInfo(vIndex)
		local vShapeshiftInfo = Outfitter.cShapeshiftInfo[vName]
		
		if vShapeshiftInfo then
			if not vIsActive then
				Outfitter:UpdateShapeshiftInfo(vShapeshiftInfo, false)
			else
				vActiveForm = vShapeshiftInfo
			end
		end
	end
	
	-- Substitute the druid caster pseudo-form if necessary or deactivate it
	-- if it's not
	
	if Outfitter.PlayerClass == "DRUID" then
		if not vActiveForm then
			vActiveForm = Outfitter.cShapeshiftInfo.CasterForm
		else
			Outfitter:UpdateShapeshiftInfo(Outfitter.cShapeshiftInfo.CasterForm, false)
		end
	end
	
	-- Activate the new form
	
	if vActiveForm then
		Outfitter:UpdateShapeshiftInfo(vActiveForm, true)
	end
	
	Outfitter:EndEquipmentUpdate()
end

function Outfitter:UpdateShapeshiftInfo(pShapeshiftInfo, pIsActive)
	-- Ensure a proper boolean
	
	if pIsActive then
		pIsActive = true
	else
		pIsActive = false
	end
	
	--
	
	if Outfitter.SpecialState[pShapeshiftInfo.ID] == nil then
		Outfitter.SpecialState[pShapeshiftInfo.ID] = Outfitter:WearingOutfitWithScriptID(pShapeshiftInfo.ID)
	end
	
	if Outfitter.SpecialState[pShapeshiftInfo.ID] ~= pIsActive then
		if pIsActive and pShapeshiftInfo.MaybeInCombat then
			Outfitter.MaybeInCombat = true
		end
		
		Outfitter:SetSpecialOutfitEnabled(pShapeshiftInfo.ID, pIsActive)
	end
end

function Outfitter:SetSpecialOutfitEnabled(pSpecialID, pEnable)
	-- Ensure a proper boolean
	
	if pEnable then
		pEnable = true
	else
		pEnable = false
	end
	
	if Outfitter.SpecialState[pSpecialID] == pEnable then
		return
	end
	
	-- Suspend or resume monitoring the player health
	-- if the dining outfit is being changed
	
	if pSpecialID == "Dining" and pEnable then
		MCEventLib:RegisterEvent("UNIT_HEALTH", Outfitter.UnitHealthOrManaChanged, Outfitter, true) -- Register as a blind event handler
	else
		MCEventLib:UnregisterEvent("UNIT_HEALTH", Outfitter.UnitHealthOrManaChanged, Outfitter)
	end
	
	--
	
	Outfitter.SpecialState[pSpecialID] = pEnable
	
	-- Dispatch the special ID events
	
	local vEvents = Outfitter.cSpecialIDEvents[pSpecialID]
	
	if vEvents then
		if pEnable then
			MCEventLib:DispatchEvent(vEvents.Equip)
		else
			MCEventLib:DispatchEvent(vEvents.Unequip)
		end
	else
		Outfitter:ErrorMessage("No events found for "..pSpecialID)
	end
end

function Outfitter:WearingOutfitWithScriptID(pSpecialID)
	for vIndex, vOutfit in ipairs(Outfitter.OutfitStack.Outfits) do
		if vOutfit.ScriptID == pSpecialID then
			return true, vIndex
		end
	end
end

function Outfitter:ScheduleUpdateZone()
	MCSchedulerLib:RescheduleTask(0.01, self.UpdateZone, self)
end

function Outfitter:UpdateZone()
	local vCurrentZone = GetZoneText()
	
	-- Just return if the zone isn't changing
	
	if vCurrentZone == Outfitter.CurrentZone then
		return
	end
	
	Outfitter.CurrentZone = vCurrentZone
	Outfitter.CurrentZoneIDs = Outfitter:GetCurrentZoneIDs(Outfitter.CurrentZoneIDs)
	
	Outfitter:BeginEquipmentUpdate()
	
	--
	
	for _, vSpecialID in ipairs(Outfitter.cZoneSpecialIDs) do
		local vIsActive = Outfitter.CurrentZoneIDs[vSpecialID] == true
		local vCurrentIsActive = Outfitter.SpecialState[vSpecialID]
		
		if vCurrentIsActive == nil then
			vCurrentIsActive = Outfitter:WearingOutfitWithScriptID(vSpecialID)
			Outfitter.SpecialState[vSpecialID] = vCurrentIsActive
		end
		
		Outfitter:SetSpecialOutfitEnabled(vSpecialID, vIsActive)
	end
	
	Outfitter:EndEquipmentUpdate()
end

function Outfitter:GetCurrentZoneIDs(pRecycleTable)
	local vZoneIDs = Outfitter:RecycleTable(pRecycleTable)
	
	local vZoneSpecialIDMap = Outfitter.cZoneSpecialIDMap[Outfitter.CurrentZone]
	local vPVPType, vIsArena, vFactionName = GetZonePVPInfo()
	
	if vZoneSpecialIDMap then
		for _, vZoneSpecialID in ipairs(vZoneSpecialIDMap) do
			if vZoneSpecialID ~= "City" or vPVPType ~= "hostile" then
				vZoneIDs[vZoneSpecialID] = true
			end
		end
	end
	
	return vZoneIDs
end

function Outfitter:InZoneType(pZoneType)
	return Outfitter.CurrentZoneIDs[pZoneType] == true
end

function Outfitter:InBattlegroundZone()
	return Outfitter:InZoneType("Battleground")
end

function Outfitter:SetAllSlotEnables(pEnable)
	for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
		Outfitter:SetSlotEnable(vInventorySlot, pEnable)
	end
	
	Outfitter:OutfitSettingsChanged(Outfitter.SelectedOutfit)
	Outfitter:Update(true)
end

function Outfitter:OutfitIsComplete(pOutfit, pIgnoreAmmoSlot)
	for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
		if not pOutfit.Items[vInventorySlot]
		and (not pIgnoreAmmoSlot or vInventorySlot ~= "AmmoSlot") then
			return false
		end
	end
	
	return true
end

function Outfitter:CalculateOutfitCategory(pOutfit)
	local vIgnoreAmmoSlot = UnitHasRelicSlot("player")

	if Outfitter:OutfitIsComplete(pOutfit, vIgnoreAmmoSlot) then
		return "Complete"
	else
		return "Accessory"
	end
end

function Outfitter:OutfitSettingsChanged(pOutfit)
	if not pOutfit then
		return
	end
	
	local vTargetCategoryID = Outfitter:CalculateOutfitCategory(pOutfit)
	
	if pOutfit.CategoryID ~= vTargetCategoryID then
		local vOutfitCategoryID, vOutfitIndex = Outfitter:FindOutfit(pOutfit)
		
		if not vOutfitCategoryID then
			Outfitter:ErrorMessage(pOutfit.Name.." not found in outfit list")
			return
		end
		
		if vOutfitCategoryID ~= pOutfit.CategoryID then
			Outfitter:DebugMessage("OutfitSettingsChanged: "..pOutfit.Name.." says it's in "..pOutfit.CategoryID.." but it's in "..vOutfitCategoryID)
		end
		
		table.remove(gOutfitter_Settings.Outfits[vOutfitCategoryID], vOutfitIndex)
		
		Outfitter:AddOutfit(pOutfit)
	end
	
	Outfitter.DisplayIsDirty = true
	
	Outfitter:DispatchOutfitEvent("EDIT_OUTFIT", pOutfit.Name, pOutfit)
end

function Outfitter:DeleteOutfit(pOutfit)
	local vWearingOutfit = Outfitter:WearingOutfit(pOutfit)
	local vOutfitCategoryID, vOutfitIndex = Outfitter:FindOutfit(pOutfit)
	
	if not vOutfitCategoryID then
		return
	end
	
	Outfitter:DeactivateScript(pOutfit)
	
	-- Delete the outfit
	
	table.remove(gOutfitter_Settings.Outfits[vOutfitCategoryID], vOutfitIndex)
	
	-- Deselect the outfit
	
	if pOutfit == Outfitter.SelectedOutfit then
		Outfitter:ClearSelection()
	end
	
	-- Remove the outfit if it's being worn
	
	Outfitter:RemoveOutfit(pOutfit)
	
	--
	
	Outfitter.DisplayIsDirty = true
	
	Outfitter:DispatchOutfitEvent("DELETE_OUTFIT", pOutfit.Name, pOutfit)
end

function Outfitter:AddOutfit(pOutfit)
	local vCategoryID
	
	vCategoryID = Outfitter:CalculateOutfitCategory(pOutfit)
	
	if not gOutfitter_Settings.Outfits then
		gOutfitter_Settings.Outfits = {}
	end
	
	if not gOutfitter_Settings.Outfits[vCategoryID] then
		gOutfitter_Settings.Outfits[vCategoryID] = {}
	end
	
	table.insert(gOutfitter_Settings.Outfits[vCategoryID], pOutfit)
	pOutfit.CategoryID = vCategoryID
	
	Outfitter.DisplayIsDirty = true
	
	Outfitter:DispatchOutfitEvent("ADD_OUTFIT", pOutfit.Name, pOutfit)
	
	return vCategoryID
end

function Outfitter:SlotEnableClicked(pCheckbox, pButton)
	-- If the user is attempting to drop an item put it in the slot for them
	
	if CursorHasItem() then
		PickupInventoryItem(Outfitter.cSlotIDs[pCheckbox.SlotName])
		return
	end
	
	--
	
	local vChecked = pCheckbox:GetChecked()
	
	if pCheckbox.IsUnknown then
		pCheckbox.IsUnknown = false
		pCheckbox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		vChecked = true
	end
	
	Outfitter:SetSlotEnable(pCheckbox.SlotName, vChecked)
	Outfitter:OutfitSettingsChanged(Outfitter.SelectedOutfit)
	Outfitter:Update(true)
end

function Outfitter:FindMultipleItemLocation(pItems, pEquippableItems)
	for vListIndex, vListItem in ipairs(pItems) do
		local vItem = Outfitter.ItemList_FindItemOrAlt(pEquippableItems, vListItem)
		
		if vItem then
			return vItem, vListItem
		end
	end
	
	return nil, nil
end

function Outfitter:FindAndAddItemsToOutfit(pOutfit, pSlotName, pItems, pEquippableItems)
	vItemLocation, vItem = Outfitter:FindMultipleItemLocation(pItems, pEquippableItems)
	
	if vItemLocation then
		local vInventorySlot = pSlotName
		
		if not vInventorySlot then
			vInventorySlot = vItemLocation.ItemSlotName
		end
		
		Outfitter:AddOutfitItem(pOutfit, vInventorySlot, vItem)
	end
end

function Outfitter:IsInitialized()
	return Outfitter.Initialized
end

function Outfitter:InitializationCheck()
	if not gOutfitter_Settings then
		MCSchedulerLib:RescheduleTask(1, self.Initialize, self) -- First time schedule initialization after a delay
		return
	end

	self:Initialize()
end

function Outfitter:Initialize()
	if self.Initialized then
		return
	end
	
	-- Makes sure they're not upgrading with a reloadui when there are new files
	
	if not self._QuickSlots
	or not self._OutfitIterator then
		OutfitterMinimapButton:Hide() -- Remove access to Outfitter so more errors don't start coming up
		OutfitterButtonFrame:Hide()
		StaticPopup_Show("OUTFITTER_CANT_RELOADUI")
		return
	end
	
	-- Unregister the initialization events
	
	for vEventID, _ in pairs(self.cInitializationEvents) do
		MCEventLib:UnregisterEvent(vEventID, self.InitializationCheck, self)
	end
	
	self.MenuManager = self:NewObject(self._MenuManager)
	-- self.MenuManager:Test()
	
	--
	
	local _, vPlayerClass = UnitClass("player")
	
	self.PlayerClass = vPlayerClass
	
	-- Initialize the main UI tabs
	
	self._SidebarWindowFrame.Construct(OutfitterFrame)
	
	PanelTemplates_SetNumTabs(OutfitterFrame, #self.cPanelFrames)
	OutfitterFrame.selectedTab = self.CurrentPanel
	PanelTemplates_UpdateTabs(OutfitterFrame)
	
	-- Install the /outfit command handler

	SlashCmdList.OUTFITTER = self.ExecuteCommand
	SLASH_OUTFITTER1 = "/outfitter"
	
	if not SlashCmdList.UNEQUIP then
		SlashCmdList.UNEQUIP = self.UnequipItemByName
		SLASH_UNEQUIP1 = "/unequip"
	end
	
	-- Patch GameTooltip so we can monitor hide/show events
	
	self.HookScript(GameTooltip, "OnShow", self.GameToolTip_OnShow)
	self.HookScript(GameTooltip, "OnHide", self.GameToolTip_OnHide)
	
	-- Initialize the slot ID map
	
	self.cSlotIDs = {}
	self.cSlotIDToInventorySlot = {}
		
	for _, vInventorySlot in ipairs(self.cSlotNames) do
		local vSlotID = GetInventorySlotInfo(vInventorySlot)
		
		self.cSlotIDs[vInventorySlot] = vSlotID
		self.cSlotIDToInventorySlot[vSlotID] = vInventorySlot
	end
	
	-- Initialize the settings
	
	if not gOutfitter_Settings then
		self:InitializeSettings()
	end
	
	if not gOutfitter_GlobalSettings then
		self:InitializeGlobalSettings()
	end
	
	-- Initialize the outfits
	
	self.CurrentOutfit = self:GetInventoryOutfit()
	
	if not gOutfitter_Settings.Outfits then
		self:InitializeOutfits()
	end
	
	self:CheckDatabase()
	
	-- Initialize the outfit stack
	
	self.OutfitStack:Initialize()
	
	-- Clean up any recent complete outfits which don't exist as
	-- well as duplicate entries
	
	local vUsedRecentNames = {}
	
	for vIndex = #gOutfitter_Settings.RecentCompleteOutfits, 1, -1 do
		local vName = gOutfitter_Settings.RecentCompleteOutfits[vIndex]
		
		if not self:FindOutfitByName(vName)
		or vUsedRecentNames[vName] then
			table.remove(gOutfitter_Settings.RecentCompleteOutfits, vIndex)
		else
			vUsedRecentNames[vName] = true
		end
	end
	
	-- Set the minimap button
	
	if gOutfitter_Settings.Options.HideMinimapButton then
		OutfitterMinimapButton:Hide()
	else
		OutfitterMinimapButton:Show()
	end
	
	if not gOutfitter_Settings.Options.MinimapButtonAngle
	and not gOutfitter_Settings.Options.MinimapButtonX then
		gOutfitter_Settings.Options.MinimapButtonAngle = -1.5708
	end
	
	if gOutfitter_Settings.Options.MinimapButtonAngle then
		self.MinimapButton_SetPositionAngle(gOutfitter_Settings.Options.MinimapButtonAngle)
	else
		self.MinimapButton_SetPosition(gOutfitter_Settings.Options.MinimapButtonX, gOutfitter_Settings.Options.MinimapButtonY)
	end
	
	-- Initialize player state
	
	self.SpiritRegenEnabled = true
	
	-- Done initializing
	
	self.Initialized = true
	
	-- Make sure the outfit state is good
	
	self:SetSpecialOutfitEnabled("Riding", false)
	self:SetSpecialOutfitEnabled("Spirit", false)
	self:UpdateAuraStates()
	
	-- Start listening for events
	
	MCEventLib:RegisterEvent("PLAYER_ENTERING_WORLD", self.SchedulePlayerEnteringWorld, self)
	MCEventLib:RegisterEvent("PLAYER_LEAVING_WORLD", self.PlayerLeavingWorld, self)
	
	-- For monitoring mounted, dining and shadowform states
	
	MCEventLib:RegisterEvent("PLAYER_AURAS_CHANGED", self.UpdateAuraStates, self)
	MCEventLib:RegisterEvent("UPDATE_SHAPESHIFT_FORMS", self.UpdateShapeshiftState, self)
	
	-- For monitoring plaguelands and battlegrounds
	
	MCEventLib:RegisterEvent("ZONE_CHANGED_NEW_AREA", self.ScheduleUpdateZone, self)
	
	-- For monitoring player combat state
	
	MCEventLib:RegisterEvent("PLAYER_REGEN_ENABLED", self.RegenEnabled, self)
	MCEventLib:RegisterEvent("PLAYER_REGEN_DISABLED", self.RegenDisabled, self)
	
	-- For monitoring player dead/alive state
	
	MCEventLib:RegisterEvent("PLAYER_DEAD", self.PlayerDead, self)
	MCEventLib:RegisterEvent("PLAYER_ALIVE", self.PlayerAlive, self)
	MCEventLib:RegisterEvent("PLAYER_UNGHOST", self.PlayerAlive, self)
	
	MCEventLib:RegisterEvent("UNIT_INVENTORY_CHANGED", self.UnitInventoryChanged, self, true) -- Register as a blind event handler (no event id param)

	-- For indicating which outfits are missing items
	
	MCEventLib:RegisterEvent("BAG_UPDATE", self.BagUpdate, self)
	MCEventLib:RegisterEvent("PLAYERBANKSLOTS_CHANGED", self.BankSlotsChanged, self)
	
	-- For monitoring bank bags
	
	MCEventLib:RegisterEvent("BANKFRAME_OPENED", self.BankFrameOpened, self)
	MCEventLib:RegisterEvent("BANKFRAME_CLOSED", self.BankFrameClosed, self)
	
	-- For unequipping the dining outfit
	
	MCEventLib:RegisterEvent("UNIT_MANA", self.UnitHealthOrManaChanged, self, true) -- Register as a blind event handler (no event id param)
	
	-- For monitoring spirit regen
	
	MCEventLib:RegisterEvent("UNIT_SPELLCAST_SENT", self.UnitSpellcastSent, self) -- Register as a blind event handler (no event id param)
	MCEventLib:RegisterEvent("UNIT_SPELLCAST_START", self.UnitSpellcastSent, self) -- Register as a blind event handler (no event id param)
	
	MCEventLib:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", self.UnitSpellcastStop, self) -- Register as a blind event handler (no event id param)
	MCEventLib:RegisterEvent("UNIT_SPELLCAST_STOP", self.UnitSpellcastStop, self) -- Register as a blind event handler (no event id param)
	
	MCEventLib:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", self.UnitSpellcastChannelStart, self) -- Register as a blind event handler (no event id param)
	MCEventLib:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", self.UnitSpellcastChannelStop, self) -- Register as a blind event handler (no event id param)
	
	MCEventLib:RegisterEvent("UNIT_SPELLCAST_FAILED", self.UnitSpellcastStop, self) -- Register as a blind event handler (no event id param)
	--MCEventLib:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", self.UnitSpellcastStop, self) -- Register as a blind event handler (no event id param)
	
	--
	
	self:DispatchOutfitEvent("OUTFITTER_INIT")
	
	MCSchedulerLib:ScheduleUniqueRepeatingTask(0.5, self.UpdateSwimming, self, nil, "Outfitter:UpdateSwimming")
	
	-- Activate all outfit scripts
	
	if not gOutfitter_Settings.Options.DisableAutoSwitch then
		self:ActivateAllScripts()
	end
	
	-- Install the "Used by outfits" tooltip feature
	
	GameTooltip.Outfitter_OrigSetBagItem = GameTooltip.SetBagItem
	GameTooltip.SetBagItem = self.GameTooltip_SetBagItem
	
	GameTooltip.Outfitter_OrigSetInventoryItem = GameTooltip.SetInventoryItem
	GameTooltip.SetInventoryItem = self.GameTooltip_SetInventoryItem
	
	-- Fire things up with a simulated entrance
	
	self:SchedulePlayerEnteringWorld()
end

function Outfitter:InitializeSettings()
	gOutfitter_Settings =
	{
		Version = 16,
		Options = {},
		LastOutfitStack = {},
		LayerIndex = {},
		RecentCompleteOutfits = {},
	}
	
	self.OutfitBar:InitializeSettings()
	
	Outfitter.Settings = gOutfitter_Settings
end

function Outfitter:InitializeGlobalSettings()
	gOutfitter_GlobalSettings =
	{
		Version = 1,
		SavedScripts = {},
	}
end

function Outfitter:ActivateAllScripts()
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vOutfitIndex, vOutfit in ipairs(vOutfits) do
			vOutfit.LastScriptTime = nil
			vOutfit.ScriptLockupCount = 0
			Outfitter:ActivateScript(vOutfit)
		end
	end
end

function Outfitter:DeactivateAllScripts()
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vOutfitIndex, vOutfit in ipairs(vOutfits) do
			Outfitter:DeactivateScript(vOutfit)
		end
	end
end

function Outfitter:InitializeOutfits()
	local vOutfit, vItemLocation, vItem
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems(true)
	
	-- Create the outfit categories
	
	gOutfitter_Settings.Outfits = {}
	
	for vCategoryIndex, vCategoryID in ipairs(Outfitter.cCategoryOrder) do
		gOutfitter_Settings.Outfits[vCategoryID] = {}
	end

	-- Create the normal outfit using the current
	-- inventory and set it as the currently equipped outfit
	
	vOutfit = Outfitter:GetInventoryOutfit(Outfitter.cNormalOutfit)
	Outfitter:AddOutfit(vOutfit)
	gOutfitter_Settings.LastOutfitStack = {{Name = Outfitter.cNormalOutfit}}
	Outfitter.OutfitStack.Outfits = {vOutfit}
	
	-- Create the naked outfit
	
	vOutfit = Outfitter:NewNakedOutfit(Outfitter.cNakedOutfit)
	Outfitter:AddOutfit(vOutfit)
	
	-- Generate the smart outfits
	
	for vSmartIndex, vSmartOutfit in ipairs(Outfitter.cSmartOutfits) do
		vOutfit = Outfitter:GenerateSmartOutfit(vSmartOutfit.Name, vSmartOutfit.StatID, vEquippableItems)
		
		if vOutfit then
			vOutfit.ScriptID = vSmartOutfit.ScriptID
			Outfitter:AddOutfit(vOutfit)
		end
	end
	
	Outfitter:InitializeSpecialOccasionOutfits()
end

function Outfitter:CreateEmptySpecialOccasionOutfit(pScriptID, pName)
	vOutfit = Outfitter:GetOutfitByScriptID(pScriptID)
	
	if vOutfit then
		return
	end
	
	vOutfit = Outfitter:NewEmptyOutfit(pName)
	vOutfit.ScriptID = pScriptID
	
	Outfitter:AddOutfit(vOutfit)
end

function Outfitter:InitializeSpecialOccasionOutfits()
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems(true)
	local vOutfit
	
	-- Find an argent dawn trinket and set the argent dawn outfit
	--[[ Taking this out since post-TBC it's largely irrelevant
	vOutfit = Outfitter:GetOutfitByScriptID("ArgentDawn")
	
	if not vOutfit then
		vOutfit = Outfitter:GenerateSmartOutfit(Outfitter.cArgentDawnOutfit, "ArgentDawn", vEquippableItems, true)
		vOutfit.ScriptID = "ArgentDawn"
		Outfitter:AddOutfit(vOutfit)
	end
	]]--
	-- Find riding items
	
	vOutfit = Outfitter:GetOutfitByScriptID("Riding")
	
	if not vOutfit then
		vOutfit = Outfitter:GenerateSmartOutfit(Outfitter.cRidingOutfit, "Riding", vEquippableItems, true)
		vOutfit.ScriptID = "Riding"
		vOutfit.ScriptSettings = {}
		vOutfit.ScriptSettings.DisableBG = true -- Default to disabling in BGs since that appears to be the most popular
		Outfitter:AddOutfit(vOutfit)
	end
	
	-- Create the Battlegrounds outfits
	
	Outfitter:CreateEmptySpecialOccasionOutfit("Battleground", Outfitter.cBattlegroundOutfit)
	
	-- Create the swimming outfit
	
	Outfitter:CreateEmptySpecialOccasionOutfit("Swimming", Outfitter.cSwimmingOutfit)
	
	-- Create class-specific outfits
	
	Outfitter:InitializeClassOutfits()
end

function Outfitter:InitializeClassOutfits()
	local vOutfits = Outfitter.cClassSpecialOutfits[Outfitter.PlayerClass]
	
	if not vOutfits then
		return
	end
	
	for vIndex, vOutfitInfo in ipairs(vOutfits) do
		Outfitter:CreateEmptySpecialOccasionOutfit(vOutfitInfo.ScriptID, vOutfitInfo.Name)
	end
end

function Outfitter:GetTooltipLineStats(pText)
	-- Remove the trailing period if it's there
	
	if string.sub(pText, -1) == "." then
		pText = string.sub(pText, 1, -2)
	end
	
	-- Remove any color-code close if it's there
	
	if string.sub(pText, -2) == FONT_COLOR_CODE_CLOSE then
		pText = string.sub(pText, 1, -3)
	end
	
	--
	
	-- Outfitter:TestMessage("GetTooltipLineStats: "..pText)
	
	for _, vStatInfo in ipairs(Outfitter.cItemStatFormats) do
		if type(vStatInfo) == "string" then
			local vResult = {string.find(pText, vStatInfo)}
			
			if vResult[1] then
				local vStatList = {}
				
				-- Outfitter:TestMessage("GetTooltipLineStats: Match found: "..vStatInfo.." with "..(#vResult - 2).." matches")
				
				for vIndex = 3, #vResult, 2 do
					local vStatPhrase = vResult[vIndex]
					local vValue = tonumber(vResult[vIndex + 1])
					
					-- Swap them around if the number is first
					
					if vValue == nil then
						vStatPhrase = vResult[vIndex + 1]
						vValue = tonumber(vResult[vIndex])
					end
					
					if vStatPhrase and vValue then
						local vTypes = Outfitter.cItemStatPhrases[strlower(vStatPhrase)]
						
						if vTypes then
							-- Outfitter:TestMessage("STAT: "..vStatPhrase.." +"..vValue)
							
							if type(vTypes) == "string" then
								if not vStatList[vTypes] then
									vStatList[vTypes] = vValue
								else
									vStatList[vTypes] = vStatList[vTypes] + vValue
								end
							else
								for _, vStatID in ipairs(vTypes) do
									if not vStatList[vStatID] then
										vStatList[vStatID] = vValue
									else
										vStatList[vStatID] = vStatList[vStatID] + vValue
									end
								end
							end
						else
							-- Outfitter:TestMessage(vStatPhrase.." ("..string.len(vStatPhrase)..") not found in cItemStatPhrases")
							-- Outfitter:TestMessage("Matched pattern was "..vStatInfo.." with "..(#vResult - 2).." values captured")
						end
					end
				end
				
				-- Outfitter:DebugTable("StatList", vStatList)
				
				return vStatList
			end -- if vResult[1]
		elseif type(vStatInfo) == "table" then
			local vStartIndex, vEndIndex = string.find(pText, vStatInfo.Format)
			
			if vStartIndex then
				local vStatList = {}
				
				for _, vStatID in ipairs(vStatInfo.Types) do
					if not vStatList[vStatID] then
						vStatList[vStatID] = vStatInfo.Value
					else
						vStatList[vStatID] = vStatList[vStatID] + vStatInfo.Value
					end
				end
				
				return vStatList
			end
		end -- table
	end -- for
end

function Outfitter:GetItemStatsFromTooltip(pTooltip, pDistribution)
	local vStats = {}
	local vTooltipName = pTooltip:GetName()
	local vLineCount = pTooltip:NumLines()
	
	for vLineIndex = 1, vLineCount do
		local vLeftTextFrame = getglobal(vTooltipName.."TextLeft"..vLineIndex)
		
		if not vLeftTextFrame then
			break
		end
		
		local vLeftText = vLeftTextFrame:GetText()
		-- local vRightText = getglobal(vTooltipName.."TextRight"..vLineIndex):GetText()
		
		if vLeftText then
			-- Check for the start of the set bonus section
			
			local vStartIndex, vEndIndex, vValue = string.find(vLeftText, "%(%d/%d%)")
			
			if vStartIndex then
				break
			end
			
			--
			
			local vLineStats = Outfitter:GetTooltipLineStats(vLeftText)
			
			if vLineStats then
				for vStatID, vValue in pairs(vLineStats) do
					Outfitter.Stats_AddStatValue(vStats, vStatID, vValue)
				end
			end
		end
	end -- for vLineIndex
	
	return vStats
end

function Outfitter:ConvertRatingsToStats(pStats)
	local vRatingDistribution = Outfitter:GetPlayerRatingStatDistribution()
	
	for vStatID, vValue in pairs(pStats) do
		Outfitter.Stats_DistributeValue(pStats, vValue, vRatingDistribution[vStatID])
	end
end

function Outfitter:DistributeSecondaryStats(pStats, pDistribution)
	local vStats = {} -- Have to collect them separately or they'll mess up the iterator
	
	for vStatID, vValue in pairs(pStats) do
		Outfitter.Stats_DistributeValue(vStats, vValue, pDistribution[vStatID])
	end
	
	-- Add the secondary stats back in
	
	for vStatID, vValue in pairs(vStats) do
		Outfitter.Stats_AddStatValue(pStats, vStatID, vValue)
	end
end

function Outfitter:TooltipContainsText(pTooltip, pText)
	local vTooltipName = pTooltip:GetName()
	
	for vLineIndex = 1, 100 do
		local vLeftTextFrame = getglobal(vTooltipName.."TextLeft"..vLineIndex)
		
		if not vLeftTextFrame then
			break
		end
		
		local vLeftText = vLeftTextFrame:GetText()
		
		if vLeftText
		and string.find(vLeftText, pText) then
			return true
		end
	end -- for vLineIndex
	
	return false
end

function Outfitter:CanEquipBagItem(pBagIndex, pBagSlotIndex)
	local vItemInfo = Outfitter:GetBagItemInfo(pBagIndex, pBagSlotIndex)
	
	if vItemInfo
	and vItemInfo.MinLevel
	and UnitLevel("player") < vItemInfo.MinLevel then
		return false
	end
	
	return true
end

function Outfitter:BagItemWillBind(pBagIndex, pBagSlotIndex)
	local vItemLink = GetContainerItemLink(pBagIndex, pBagSlotIndex)
	
	if not vItemLink then
		return nil
	end
	
	OutfitterTooltip:SetOwner(OutfitterFrame, "ANCHOR_BOTTOMRIGHT", 0, 0)
	OutfitterTooltip:SetBagItem(pBagIndex, pBagSlotIndex)
	
	local vIsBOE = Outfitter:TooltipContainsText(OutfitterTooltip, ITEM_BIND_ON_EQUIP)
	
	OutfitterTooltip:Hide()
	
	return vIsBOE
end

function Outfitter:GenerateSmartOutfit(pName, pStatID, pEquippableItems, pAllowEmptyOutfit)
	local vOutfit = Outfitter:NewEmptyOutfit(pName)
	
	if pStatID == "TANKPOINTS" then
		return
	end
	
	local vItems = Outfitter.cStatIDItems[pStatID]
	
	Outfitter.ItemList_ResetIgnoreItemFlags(pEquippableItems)
	
	if vItems then
		Outfitter:FindAndAddItemsToOutfit(vOutfit, nil, vItems, pEquippableItems)
	end
	
	Outfitter:AddItemsWithStatToOutfit(vOutfit, pStatID, pEquippableItems)
	
	if not pAllowEmptyOutfit
	and Outfitter:IsEmptyOutfit(vOutfit) then
		return nil
	end
	
	vOutfit.StatID = pStatID
	
	return vOutfit
end

function Outfitter:ArrayIsEmpty(pArray)
	if not pArray then
		return true
	end
	
	return next(pArray) == nil
end

function Outfitter.NameOutfit_Open(pOutfit)
	gOutfitter_OutfitToRename = pOutfit
	
	if gOutfitter_OutfitToRename then
		OutfitterNameOutfitDialogTitle:SetText(Outfitter.cRenameOutfit)
		OutfitterNameOutfitDialog:SetHeight(OutfitterNameOutfitDialog.baseHeight - 70)
		
		OutfitterNameOutfitDialogName:SetText(gOutfitter_OutfitToRename.Name)
		
		OutfitterNameOutfitDialogAutomation:Hide()
		
		OutfitterNameOutfitDialogCreateUsing:Hide()
	else
		OutfitterNameOutfitDialogTitle:SetText(Outfitter.cNewOutfit)
		OutfitterNameOutfitDialog:SetHeight(OutfitterNameOutfitDialog.baseHeight)
		
		OutfitterNameOutfitDialogName:SetText("")
		
		Outfitter.DropDown_SetSelectedValue(OutfitterNameOutfitDialogAutomation, "NONE")
		OutfitterNameOutfitDialogAutomation:Show()
		OutfitterNameOutfitDialogAutomation.ChangedValueFunc = Outfitter.NameOutfit_PresetScriptChanged
		
		Outfitter.DropDown_SetSelectedValue(OutfitterNameOutfitDialogCreateUsing, "EMPTY")
		OutfitterNameOutfitDialogCreateUsing:Show()
		OutfitterNameOutfitDialogCreateUsing.ChangedValueFunc = Outfitter.NameOutfit_CheckForStatOutfit
	end
	
	OutfitterNameOutfitDialog:Show()
	OutfitterNameOutfitDialogName:SetFocus()
end

function Outfitter.NameOutfit_PresetScriptChanged(pMenu, pValue)
	Outfitter.DropDown_SetSelectedValue(pMenu, pValue)
	
	-- Set the default name if there isn't one or it's the previous default
	
	local vName = OutfitterNameOutfitDialogName:GetText()
	
	if pValue ~= "NONE"
	and (not vName or vName == "" or vName == OutfitterNameOutfitDialog.PreviousDefaultName) then
		vName = Outfitter:GetPresetScriptByID(pValue).Name
		
		OutfitterNameOutfitDialogName:SetText(vName)
		OutfitterNameOutfitDialog.PreviousDefaultName = vName
	end
end

function Outfitter.NameOutfit_CheckForStatOutfit(pMenu, pValue)
	Outfitter.NameOutfit_Update(true)
end

function Outfitter.NameOutfit_Done()
	local vName = OutfitterNameOutfitDialogName:GetText()
	
	if vName
	and vName ~= "" then
		if gOutfitter_OutfitToRename then
			local vWearingOutfit = Outfitter:WearingOutfit(gOutfitter_OutfitToRename)
			
			if vWearingOutfit then
				Outfitter:DispatchOutfitEvent("UNWEAR_OUTFIT", gOutfitter_OutfitToRename.Name, gOutfitter_OutfitToRename)
			end
			
			gOutfitter_OutfitToRename.Name = vName
			Outfitter.DisplayIsDirty = true

			if vWearingOutfit then
				Outfitter:DispatchOutfitEvent("WEAR_OUTFIT", gOutfitter_OutfitToRename.Name, gOutfitter_OutfitToRename)
			end
		else
			-- Create the new outift
			
			local vStatID = UIDropDownMenu_GetSelectedValue(OutfitterNameOutfitDialogCreateUsing)
			local vOutfit
			
			if not vStatID
			or vStatID == 0 then
				vOutfit = Outfitter:GetInventoryOutfit(vName)
			elseif vStatID == "EMPTY" then
				vOutfit = Outfitter:NewEmptyOutfit(vName)
			else
				vOutfit = Outfitter:GenerateSmartOutfit(vName, vStatID, Outfitter.ItemList_GetEquippableItems(true))
			end
			
			if not vOutfit then
				vOutfit = Outfitter:NewEmptyOutfit(vName)
			end
			
			-- Add the outfit
			
			local vCategoryID = Outfitter:AddOutfit(vOutfit)
			
			-- Set the script
			
			local vScriptID = UIDropDownMenu_GetSelectedValue(OutfitterNameOutfitDialogAutomation)
			
			if vScriptID ~= "NONE" then
				Outfitter:SetScriptID(vOutfit, vScriptID)
			end
			
			-- Wear the outfit
			
			Outfitter:WearOutfit(vOutfit)
		end
	end
	
	OutfitterNameOutfitDialog:Hide()
	
	Outfitter:Update(true)
end

function Outfitter.NameOutfit_Cancel()
	OutfitterNameOutfitDialog:Hide()
end

function Outfitter.NameOutfit_Update(pCheckForStatOutfit)
	local vEnableDoneButton = true
	local vErrorMessage = nil
	
	-- If there's no name entered then disable the okay button
	
	local vName = OutfitterNameOutfitDialogName:GetText()
	
	if not vName
	or vName == "" then
		vEnableDoneButton = false
	else
		local vOutfit = Outfitter:FindOutfitByName(vName)
		
		if vOutfit
		and vOutfit ~= gOutfitter_OutfitToRename then
			vErrorMessage = Outfitter.cNameAlreadyUsedError
			vEnableDoneButton = false
		end
	end
	
	-- 
	
	if not vErrorMessage
	and pCheckForStatOutfit then
		local vStatID = UIDropDownMenu_GetSelectedValue(OutfitterNameOutfitDialogCreateUsing)
		
		if vStatID
		and vStatID ~= 0
		and vStatID ~= "EMPTY" then
			local vOutfit = Outfitter:GenerateSmartOutfit("temp outfit", vStatID, Outfitter.ItemList_GetEquippableItems(true))
			
			if not vOutfit
			or Outfitter:IsEmptyOutfit(vOutfit) then
				vErrorMessage = Outfitter.cNoItemsWithStatError
			end
		end
	end
	
	if vErrorMessage then
		OutfitterNameOutfitDialogError:SetText(vErrorMessage)
		OutfitterNameOutfitDialogError:Show()
	else
		OutfitterNameOutfitDialogError:Hide()
	end
	
	Outfitter:SetButtonEnable(OutfitterNameOutfitDialogDoneButton, vEnableDoneButton)
end

function Outfitter:SetButtonEnable(pButton, pEnabled)
	if pEnabled then
		pButton:Enable()
		pButton:SetAlpha(1.0)
		pButton:EnableMouse(true)
		--getglobal(pButton:GetName().."Text"):SetAlpha(1.0)
	else
		pButton:Disable()
		pButton:SetAlpha(0.7)
		pButton:EnableMouse(false)
		--getglobal(pButton:GetName().."Text"):SetAlpha(0.7)
	end
end

function Outfitter:GetOutfitFromListItem(pItem)
	if pItem.isCategory then
		return nil
	end
	
	if not gOutfitter_Settings.Outfits then
		return nil
	end
	
	local vOutfits = gOutfitter_Settings.Outfits[pItem.categoryID]
	
	if not vOutfits then
		-- Error: outfit category not found
		return nil
	end
	
	return vOutfits[pItem.outfitIndex]
end

Outfitter.OutfitMenuActions = {}

function Outfitter.OutfitMenuActions.DELETE(pOutfit)
	Outfitter:AskDeleteOutfit(pOutfit)
end

function Outfitter.OutfitMenuActions.RENAME(pOutfit)
	Outfitter.NameOutfit_Open(pOutfit)
end

function Outfitter.OutfitMenuActions.SCRIPT_SETTINGS(pOutfit)
	OutfitterEditScriptDialog:Open(pOutfit)
end

function Outfitter.OutfitMenuActions.EDIT_SCRIPT(pOutfit)
	if pOutfit.ScriptID == nil and pOutfit.Script == nil then
		pOutfit.Script = pOutfit.SavedScript
		pOutfit.SavedScript = nil
	end
	
	OutfitterEditScriptDialog:Open(pOutfit, true)
end

function Outfitter.OutfitMenuActions.DISABLE(pOutfit)
	if pOutfit.Disabled then
		pOutfit.Disabled = nil
		Outfitter:ActivateScript(pOutfit)
	else
		pOutfit.Disabled = true
		Outfitter:DeactivateScript(pOutfit)
	end
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.SHOWHELM(pOutfit)
	pOutfit.ShowHelm = true
	Outfitter.OutfitStack:UpdateHelmAndCloakVisibility()
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.HIDEHELM(pOutfit)
	pOutfit.ShowHelm = false
	Outfitter.OutfitStack:UpdateHelmAndCloakVisibility()
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.IGNOREHELM(pOutfit)
	pOutfit.ShowHelm = nil
	Outfitter.OutfitStack:UpdateHelmAndCloakVisibility()
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.SHOWCLOAK(pOutfit)
	pOutfit.ShowCloak = true
	Outfitter.OutfitStack:UpdateHelmAndCloakVisibility()
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.HIDECLOAK(pOutfit)
	pOutfit.ShowCloak = false
	Outfitter.OutfitStack:UpdateHelmAndCloakVisibility()
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.IGNORECLOAK(pOutfit)
	pOutfit.ShowCloak = nil
	Outfitter.OutfitStack:UpdateHelmAndCloakVisibility()
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.COMBATDISABLE(pOutfit)
	if pOutfit.CombatDisabled then
		pOutfit.CombatDisabled = nil
	else
		pOutfit.CombatDisabled = true
	end
	
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.REBUILD(pOutfit)
	Outfitter:AskRebuildOutfit(pOutfit)
end

function Outfitter.OutfitMenuActions.SET_CURRENT(pOutfit)
	Outfitter:AskSetCurrent(pOutfit)
end

function Outfitter.OutfitMenuActions.UNEQUIP_OTHERS(pOutfit)
	if pOutfit.UnequipOthers then
		pOutfit.UnequipOthers = nil
	else
		pOutfit.UnequipOthers = true
	end
	
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.DEPOSIT(pOutfit)
	Outfitter:DepositOutfit(pOutfit)
end

function Outfitter.OutfitMenuActions.DEPOSITUNIQUE(pOutfit)
	Outfitter:DepositOutfit(pOutfit, true)
end

function Outfitter.OutfitMenuActions.WITHDRAW(pOutfit)
	Outfitter:WithdrawOutfit(pOutfit)
end

function Outfitter.OutfitMenuActions.OUTFITBAR_SHOW(pOutfit)
	local vSettings = Outfitter.OutfitBar:GetOutfitSettings(pOutfit)
	
	vSettings.Hide = not vSettings.Hide
	
	Outfitter:OutfitSettingsChanged(pOutfit)
end

function Outfitter.OutfitMenuActions.OUTFITBAR_CHOOSEICON(pOutfit)
	OutfitterChooseIconDialog:Open(pOutfit)
end

function Outfitter:PerformAction(pActionID, pOutfit)
	local vActionFunc = Outfitter.OutfitMenuActions[pActionID]
	
	if vActionFunc then
		vActionFunc(pOutfit)
	elseif string.sub(pActionID, 1, 8) == "BINDING_" then
		local vBindingIndex = string.sub(pActionID, 9)
		
		if vBindingIndex == "NONE" then
			Outfitter:SetOutfitBindingIndex(pOutfit, nil)
		else
			Outfitter:SetOutfitBindingIndex(pOutfit, tonumber(vBindingIndex))
		end
	elseif string.sub(pActionID, 1, 7) == "PRESET_" then
		local vScriptID = string.sub(pActionID, 8)
		
		if vScriptID == "NONE" then
			Outfitter:DeactivateScript(pOutfit)
			
			pOutfit.SavedScript = pOutfit.Script
			
			pOutfit.ScriptID = nil
			pOutfit.Script = nil
		else
			pOutfit.SavedScript = nil
			
			Outfitter:SetScriptID(pOutfit, vScriptID)
			
			-- If the script has settings then open the
			-- dialog
			
			if Outfitter:OutfitHasSettings(pOutfit) then
				OutfitterEditScriptDialog:Open(pOutfit)
			end
		end
		
		Outfitter:OutfitSettingsChanged(pOutfit)
	else
		return
	end
	
	Outfitter:Update(true)
end

function Outfitter.OutfitItemSelected(pMenu, pValue)
	local vItem = pMenu:GetParent():GetParent()
	local vOutfit = Outfitter:GetOutfitFromListItem(vItem)

	if not vOutfit then
		Outfitter:ErrorMessage("Outfit for menu item "..vItem:GetName().." not found")
		return
	end

	Outfitter:PerformAction(pValue, vOutfit)
end

function Outfitter:GetPresetScriptByID(pID)
	for _, vPresetScript in ipairs(Outfitter.PresetScripts) do
		if vPresetScript.ID == pID then
			return vPresetScript
		end
	end
end

function Outfitter:FindMatchingPresetScriptID(pScript)
	for _, vPresetScript in ipairs(Outfitter.PresetScripts) do
		if vPresetScript.Script == pScript then
			return vPresetScript.ID
		end
	end
end

function Outfitter.PresetScriptDropdown_OnLoad()
	UIDropDownMenu_Initialize(this, Outfitter.PresetScriptDropdown_Initialize)
	UIDropDownMenu_SetWidth(150)
	UIDropDownMenu_Refresh(this)
	
	this.AutoSetValue = true
	this.ChangedValueFunc = Outfitter.PresetScriptDropdown_ChangedValue
end

function Outfitter.PresetScriptDropdown_ChangedValue(pFrame, pValue)
	pFrame.Dialog:SetPresetScriptID(pValue)
end

function Outfitter.PresetScriptDropdown_Initialize()
	local vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)
	
	if UIDROPDOWNMENU_MENU_LEVEL == 2 then
		for _, vPresetScript in ipairs(Outfitter.PresetScripts) do
			if not vPresetScript.Class
			or vPresetScript.Class == Outfitter.PlayerClass then
				local vCategory = vPresetScript.Category or vPresetScript.Class or "GENERAL"
				
				if vCategory == UIDROPDOWNMENU_MENU_VALUE then
					UIDropDownMenu_AddButton({
						text = vPresetScript.Name,
						value = vPresetScript.ID,
						owner = vFrame,
						func = Outfitter.DropDown_OnClick,
						tooltipTitle = vPresetScript.Name,
						tooltipText = Outfitter:GetScriptDescription(vPresetScript.Script),
						textR = NORMAL_FONT_COLOR.r,
						textG = NORMAL_FONT_COLOR.g,
						textB = NORMAL_FONT_COLOR.b,
					}, UIDROPDOWNMENU_MENU_LEVEL)
				end
			end
		end
	else
		local vCategory
		
		for _, vPresetScript in ipairs(Outfitter.PresetScripts) do
			if not vPresetScript.Class
			or vPresetScript.Class == Outfitter.PlayerClass then
				-- Start a new category if it's changing
				
				local vNewCategory = vPresetScript.Category or vPresetScript.Class or "GENERAL"
				
				if vCategory ~= vNewCategory then
					vCategory = vNewCategory
					
					UIDropDownMenu_AddButton({
						text = Outfitter.cScriptCategoryName[vCategory] or Outfitter.cClassName[vCategory],
						owner = vFrame,
						hasArrow = 1,
						value = vCategory}, UIDROPDOWNMENU_MENU_LEVEL)
				end
			end
		end
	end
end

------------------------------------
Outfitter._EditScriptDialog = {}
------------------------------------

Outfitter._EditScriptDialog.Widgets =
{
	"Title",
	"Source",
	"Settings",
	"SettingsDescription",
	"SourceScriptEditBox",
	"SourceStatusMessage",
	"PresetScript",
}

function Outfitter._EditScriptDialog:Construct()
	Outfitter._PortraitWindowFrame.Construct(self)
	
	self.Widgets.SourceScriptEditBox.Dialog = self
	self.Widgets.SourceScriptEditBox.TextChanged = Outfitter.EditorScript_TextChanged
	
	self.Widgets.PresetScript.Dialog = self
	
	self.CloseButton:SetScript("OnClick", function () this:GetParent():Done() end)
	
	-- Tabs
	
	PanelTemplates_SetNumTabs(self, 2)
	self.selectedTab = 1
	PanelTemplates_UpdateTabs(this)
	
	-- Setting frames
	
	self.FrameCache = {}
end

function Outfitter._EditScriptDialog:Open(pOutfit, pShowSource)
	self.Outfit = pOutfit
	
	self.Widgets.Title:SetText(string.format(Outfitter.cEditScriptTitle, pOutfit.Name))
	
	local vScript = Outfitter:GetScript(pOutfit)
	
	if vScript then
		self.Widgets.SourceScriptEditBox:SetText(vScript)
	else
		self.Widgets.SourceScriptEditBox:SetText("")
	end
	
	-- Copy the script values
	
	self.ScriptSettings = {}
	
	if self.Outfit.ScriptSettings then
		for vKey, vValue in pairs(self.Outfit.ScriptSettings) do
			self.ScriptSettings[vKey] = vValue
		end
	end
	
	self:SetPresetScriptID(Outfitter:FindMatchingPresetScriptID(vScript))
	
	--
	
	if pShowSource then
		self:SetPanelIndex(2) -- Show the source panel
	else
		self:SetPanelIndex(1) -- Show the settings panel
	end
	
	self:Show()
	
	Outfitter:DialogOpened(self)
end

function Outfitter._EditScriptDialog:Close()
	MCSchedulerLib:UnscheduleTask(self.CheckScriptErrors, self)
	
	self.Outfit = nil
	self:Hide()
	
	Outfitter:DialogClosed(self)
end

function Outfitter._EditScriptDialog:Done()
	-- Save the script
	
	local vScript = self.Widgets.SourceScriptEditBox:GetText()
	local vScriptID = Outfitter:FindMatchingPresetScriptID(vScript)
	
	if vScriptID then
		Outfitter:SetScriptID(self.Outfit, vScriptID)
	else
		Outfitter:SetScript(self.Outfit, vScript)
	end
	
	-- Save the settings
	
	self.Outfit.ScriptSettings = self:GetScriptSettings()
	
	--
	
	self:Close()
end

function Outfitter._EditScriptDialog:CheckScriptErrors()
	local vScript = self.Widgets.SourceScriptEditBox:GetText()
	local vScriptFields, vMessage = Outfitter:ParseScriptFields(vScript)
	
	if not vMessage then
		_, vMessage = Outfitter:LoadOutfitScript(vScript)
	end
	
	if vMessage then
		self.Widgets.SourceStatusMessage:SetText(vMessage)
	else
		self.Widgets.SourceStatusMessage:SetText("OK")
	end
	
	self:SetPresetScriptID(Outfitter:FindMatchingPresetScriptID(vScript))
end

function Outfitter._EditScriptDialog:SetPresetScriptID(pID)
	local vPresetScript = Outfitter:GetPresetScriptByID(pID)
	
	if not vPresetScript then
		Outfitter.DropDown_SetSelectedValue(self.Widgets.PresetScript, "CUSTOM")
		return
	end
	
	Outfitter.DropDown_SetSelectedValue(self.Widgets.PresetScript, pID)
	
	self.Widgets.SourceScriptEditBox:SetText(vPresetScript.Script)

	local vScriptFields, vMessage = Outfitter:ParseScriptFields(vPresetScript.Script)
	
	if vScriptFields then
		self:ConstructSettingsFields(vScriptFields)
	end
end

function Outfitter._EditScriptDialog:SetPanelIndex(pIndex)
	if pIndex == 1 then
		local vScript = self.Widgets.SourceScriptEditBox:GetText()
		local vScriptFields = Outfitter:ParseScriptFields(vScript)
		
		if vScriptFields then
			self:ConstructSettingsFields(vScriptFields)
		end
		
		self.Widgets.Settings:Show()
		self.Widgets.Source:Hide()
	else
		self.ScriptSettings = self:GetScriptSettings()
		
		self.Widgets.Settings:Hide()
		self.Widgets.Source:Show()
	end
	
	PanelTemplates_SetTab(self, pIndex)
end

function Outfitter._EditScriptDialog:ConstructSettingsFields( pSettings)
	-- Outfitter:DebugTable("ConstructSettingsFields", pSettings)
	
	local vNumFramesUsed = {}
	
	self.SettingsFrames = {}
	
	-- Hide and de-anchor all frames
	
	for vFrameType, vFrames in pairs(self.FrameCache) do
		for _, vFrame in ipairs(vFrames) do
			vFrame:ClearAllPoints()
			vFrame:Hide()
		end
		
		vNumFramesUsed[vFrameType] = 0
	end
	
	--
	
	local vPreviousFrame = nil
	local vPreviousOffsetX = 0
	
	if pSettings.Inputs then
		self.Widgets.SettingsDescription:SetText(pSettings.Description or " ")
		
		for _, vDescriptor in ipairs(pSettings.Inputs) do
			local vType = string.lower(vDescriptor.Type)
			local vSettingTypeInfo = Outfitter.SettingTypeInfo[vType]
			
			if not vSettingTypeInfo then
				Outiftter:ErrorMessage("Unknown $SETTING type %s in the script, I can't create a control for it", vDescriptor.Type or "nil")
				break
			end
			
			local vFrameType = vSettingTypeInfo.FrameType
			
			if not vNumFramesUsed[vFrameType] then
				vNumFramesUsed[vFrameType] = 0
			end
			
			local vFrameIndex = vNumFramesUsed[vFrameType] + 1
			local vFrame
			
			-- Create a new frame if needed
			
			local vFrameCache = self.FrameCache[vFrameType]
			
			if not vFrameCache then
				vFrameCache = {}
				self.FrameCache[vFrameType] = vFrameCache
			end
			
			vFrame = vFrameCache[vFrameIndex]
			
			if not vFrame then
				local vFrameName = self.Widgets.Settings:GetName()..vFrameType..vFrameIndex
				
				-- Outfitter:TestMessage("Creating frame "..vFrameName)
				
				if vFrameType == "ScrollableEditBox" then
					vFrame = CreateFrame("ScrollFrame", vFrameName, self.Widgets.Settings, "OutfitterScrollableEditBox")
					vFrame:SetWidth(300)
					vFrame:SetHeight(80)
				
				elseif vFrameType == "EditBox" then
					vFrame = CreateFrame("EditBox", vFrameName, self.Widgets.Settings, "OutfitterInputBoxTemplate")
					vFrame:SetAutoFocus(false)
					vFrame:SetWidth(300)
					vFrame:SetHeight(18)
				
				elseif vFrameType == "ZoneListEditBox" then
					vFrame = CreateFrame("ScrollFrame", vFrameName, self.Widgets.Settings, "OutfitterZoneListEditBox")
					vFrame:SetWidth(180)
					vFrame:SetHeight(80)
				
				elseif vFrameType == "Checkbox" then
					vFrame = CreateFrame("CheckButton", vFrameName, self.Widgets.Settings, "OutfitterCheckboxTemplate")
					vFrame:SetWidth(24)
					vFrame:SetHeight(24)
				end
				
				if vFrame then
					vFrameCache[vFrameIndex] = vFrame
				end
			end
			
			if vFrame then
				table.insert(self.SettingsFrames, vFrame)
				
				vFrame.Descriptor = vDescriptor
				
				-- Position the frame
				
				local vOffsetX, vOffsetY = 0, -10
				
				if vDescriptor.Type == "Number" then
					vFrame:SetWidth(100)
				end
				
				if vFrameType == "EditBox" then
					vOffsetX = 6
				end
				
				if not vPreviousFrame then
					vFrame:SetPoint("TOPLEFT", self.Widgets.SettingsDescription, "BOTTOMLEFT", vOffsetX - vPreviousOffsetX, vOffsetY)
				else
					vFrame:SetPoint("TOPLEFT", vPreviousFrame, "BOTTOMLEFT", vOffsetX - vPreviousOffsetX, vOffsetY)
				end
				
				vPreviousFrame = vFrame
				vPreviousOffsetX = vOffsetX
				vNumFramesUsed[vFrameType] = vFrameIndex
				
				-- Set the label
				
				local vLabelText = getglobal(vFrame:GetName().."Label")
				
				if not vLabelText then
					vLabelText = getglobal(vFrame:GetName().."Text")
				end
				
				vLabelText:SetText(vDescriptor.Label)
				
				-- Set the suffix
				
				local vSuffixText = getglobal(vFrame:GetName().."Suffix")
				
				if vSuffixText then
					vSuffixText:SetText(vDescriptor.Suffix or "")
				end
				
				-- Set the zone type if it's a zone list
				
				if vFrameType == "ZoneListEditBox" then
					local vType = vDescriptor.ZoneType
					
					if not vType then
						vType = "Zone"
					end
					
					local vZoneButton = getglobal(vFrame:GetName().."ZoneButton")
					
					vZoneButton.GetTextFunc = getglobal("Get"..vType.."Text")
					vZoneButton:SetText(string.format(Outfitter.cInsertFormat, vZoneButton.GetTextFunc()))
				end
				
				-- Show it
				
				vFrame:Show()
			end
		end
	else -- if pSettings.Inputs
		self.Widgets.SettingsDescription:SetText(pSettings.Description or Outfitter.cNoScriptSettings)
	end
	
	self:SetScriptSettings()
end

function Outfitter._EditScriptDialog:GetScriptSettings()
	local vSettings = {}
	
	if self.SettingsFrames then
		for _, vFrame in ipairs(self.SettingsFrames) do
			local vType = string.lower(vFrame.Descriptor.Type)
			local vValue
			
			if vType == "string" then
				vValue = vFrame:GetText()
			
			elseif vType == "number" then
				vValue = tonumber(vFrame:GetText())
			
			elseif vType == "boolean" then
				vValue = vFrame:GetChecked() == 1
			
			elseif vType == "stringtable"
			or vType == "zonelist" then
				local vEditBox = getglobal(vFrame:GetName().."EditBox")
				
				vValue = {}
				
				for vLine in string.gmatch(vEditBox:GetText(), "([^\r\n]*)") do
					if string.len(vLine) > 0 then
						table.insert(vValue, vLine)
					end
				end
			else
				Outfitter:DebugMessage("EditScriptDialog:GetScriptSettings: Unknown type %s", vType or "nil")
			end
			
			vSettings[vFrame.Descriptor.Field] = vValue
		end
	end
	
	-- Outfitter:DebugTable("GetScriptSettings", vSettings)
	
	return vSettings
end

function Outfitter._EditScriptDialog:SetScriptSettings()
	if not self.SettingsFrames then
		return
	end
	
	for _, vFrame in ipairs(self.SettingsFrames) do
		local vType = string.lower(vFrame.Descriptor.Type)
		local vValue = self.ScriptSettings[vFrame.Descriptor.Field]
		
		if not vValue then
			local vSettingTypeInfo = Outfitter.SettingTypeInfo[vType]
			
			if not vSettingTypeInfo then
				return
			end
			
			vValue = vSettingTypeInfo.Default
		end
		
		if vType == "string"
		or vType == "number" then
			vFrame:SetText(vValue)
		
		elseif vType == "boolean" then
			vFrame:SetChecked(vValue)
		
		elseif vType == "stringtable"
		or vType == "zonelist" then
			local vEditBox = getglobal(vFrame:GetName().."EditBox")
			
			if type(vValue) == "table" then
				vEditBox:SetText(table.concat(vValue, "\n"))
			else
				vEditBox:SetText("")
			end
		end
	end
end

function Outfitter.EditorScript_TextChanged(pEditBox)
	local vDialog = pEditBox.Dialog
	
	vDialog.Widgets.SourceStatusMessage:SetText(Outfitter.cTyping)
	
	MCSchedulerLib:RescheduleTask(1.5, vDialog.CheckScriptErrors, vDialog)
end

----------------------------------------
-- Outfitter.StatDropDown
----------------------------------------

function Outfitter.StatDropdown_OnLoad()
	UIDropDownMenu_Initialize(this, Outfitter.StatDropdown_Initialize)
	UIDropDownMenu_SetWidth(150)
	UIDropDownMenu_Refresh(this)

	this.AutoSetValue = true
end

function Outfitter.StatDropdown_Initialize()
	local vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)
	
	if UIDROPDOWNMENU_MENU_LEVEL == 2 then
		for vStatIndex, vStatInfo in ipairs(Outfitter.cItemStatInfo) do
			if vStatInfo.Category == UIDROPDOWNMENU_MENU_VALUE then
				UIDropDownMenu_AddButton({text = vStatInfo.Name, value = vStatInfo.ID, owner = vFrame, func = Outfitter.DropDown_OnClick}, UIDROPDOWNMENU_MENU_LEVEL)
			end
		end
	else
		UIDropDownMenu_AddButton({text = Outfitter.cUseCurrentOutfit, value = 0, owner = vFrame, func = Outfitter.DropDown_OnClick})
		UIDropDownMenu_AddButton({text = Outfitter.cUseEmptyOutfit, value = "EMPTY", owner = vFrame, func = Outfitter.DropDown_OnClick})
		
		UIDropDownMenu_AddButton({text = " ", notCheckable = true, notClickable = true})
		
		for vCategoryIndex, vCategoryInfo in ipairs(Outfitter.cStatCategoryInfo) do
			UIDropDownMenu_AddButton({text = vCategoryInfo.Name, owner = vFrame, hasArrow = 1, value = vCategoryInfo.Category})
		end
		
		if false and IsAddOnLoaded("TankPoints") then
			UIDropDownMenu_AddButton({text = " ", notCheckable = true, notClickable = true})
			UIDropDownMenu_AddButton({text = Outfitter.cTankPoints, value="TANKPOINTS", owner = vFrame, func = Outfitter.DropDown_OnClick})
		end
	end
end

----------------------------------------
-- Outfitter.AutomationDropDown
----------------------------------------

function Outfitter.AutomationDropdown_OnLoad()
	UIDropDownMenu_Initialize(this, Outfitter.AutomationDropdown_Initialize)
	UIDropDownMenu_SetWidth(150)
	UIDropDownMenu_Refresh(this)
end

function Outfitter.AutomationDropdown_Initialize()
	local vFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)

	if UIDROPDOWNMENU_MENU_LEVEL == 2 then
		for _, vPresetScript in ipairs(Outfitter.PresetScripts) do
			if not vPresetScript.Class
			or vPresetScript.Class == Outfitter.PlayerClass then
				local vCategory = vPresetScript.Category or vPresetScript.Class or "GENERAL"
				
				if vCategory == UIDROPDOWNMENU_MENU_VALUE then
					local vName = vPresetScript.Name
					local vDescription = Outfitter:GetScriptDescription(vPresetScript.Script)
					
					Outfitter:AddMenuItem(
							vFrame,
							vName,
							vPresetScript.ID,
							nil, -- Checked
							UIDROPDOWNMENU_MENU_LEVEL,
							nil, -- Color
							nil, -- Disabled
							{tooltipTitle = vName, tooltipText = vDescription})
				end
			end
		end
	else
		local vCategory
		
		Outfitter:AddMenuItem(vFrame, Outfitter.cNoScript, "NONE")
		
		local vCategory
		
		for _, vPresetScript in ipairs(Outfitter.PresetScripts) do
			if not vPresetScript.Class
			or vPresetScript.Class == Outfitter.PlayerClass then
				-- Start a new category if it's changing
				
				local vNewCategory = vPresetScript.Category or vPresetScript.Class or "GENERAL"
				
				if vCategory ~= vNewCategory then
					vCategory = vNewCategory
					
					UIDropDownMenu_AddButton({
						text = Outfitter.cScriptCategoryName[vCategory] or Outfitter.cClassName[vCategory],
						owner = vFrame,
						hasArrow = 1,
						value = vCategory}, UIDROPDOWNMENU_MENU_LEVEL)
				end
			end
		end
	end
end

----------------------------------------
-- 
----------------------------------------

function Outfitter:GetStatIDName(pStatID)
	for vStatIndex, vStatInfo in ipairs(Outfitter.cItemStatInfo) do
		if vStatInfo.ID == pStatID then
			return vStatInfo.Name
		end
	end
	
	return nil
end

function Outfitter.DropDown_SetSelectedValue(pDropDown, pValue)
	UIDropDownMenu_SetText("", pDropDown) -- Set to empty in case the selected value isn't there

	UIDropDownMenu_Initialize(pDropDown, pDropDown.initialize)
	UIDropDownMenu_SetSelectedValue(pDropDown, pValue)
	
	-- All done if the item text got set successfully
	
	local vItemText = UIDropDownMenu_GetText(pDropDown)
	
	if vItemText and vItemText ~= "" then
		return
	end
	
	-- Scan for submenus
	
	local vRootListFrameName = "DropDownList1"
	local vRootListFrame = getglobal(vRootListFrameName)
	local vRootNumItems = vRootListFrame.numButtons
	
	for vRootItemIndex = 1, vRootNumItems do
		local vItem = getglobal(vRootListFrameName.."Button"..vRootItemIndex)
		
		if vItem.hasArrow then
			local vSubMenuFrame = getglobal("DropDownList2")
			
			UIDROPDOWNMENU_OPEN_MENU = pDropDown:GetName()
			UIDROPDOWNMENU_MENU_VALUE = vItem.value
			UIDROPDOWNMENU_MENU_LEVEL = 2
			
			UIDropDownMenu_Initialize(pDropDown, pDropDown.initialize, nil, 2)
			UIDropDownMenu_SetSelectedValue(pDropDown, pValue)
			
			-- All done if the item text got set successfully
			
			local vItemText = UIDropDownMenu_GetText(pDropDown)
			
			if vItemText and vItemText ~= "" then
				return
			end
			
			-- Switch back to the root menu
			
			UIDROPDOWNMENU_OPEN_MENU = nil
			UIDropDownMenu_Initialize(pDropDown, pDropDown.initialize, nil, 1)
		end
	end
end

function Outfitter.ScrollbarTrench_SizeChanged(pScrollbarTrench)
	local vScrollbarTrenchName = pScrollbarTrench:GetName()
	local vScrollbarTrenchMiddle = getglobal(vScrollbarTrenchName.."Middle")
	
	local vMiddleHeight= pScrollbarTrench:GetHeight() - 51
	vScrollbarTrenchMiddle:SetHeight(vMiddleHeight)
end

function Outfitter.InputBox_OnLoad(pChildDepth)
	if not pChildDepth then
		pChildDepth = 0
	end
	
	local vParent = this:GetParent()
	
	for vDepthIndex = 1, pChildDepth do
		vParent = vParent:GetParent()
	end
	
	if vParent.lastEditBox then
		this.prevEditBox = vParent.lastEditBox
		this.nextEditBox = vParent.lastEditBox.nextEditBox
		
		this.prevEditBox.nextEditBox = this
		this.nextEditBox.prevEditBox = this
	else
		this.prevEditBox = this
		this.nextEditBox = this
	end

	vParent.lastEditBox = this
end

function Outfitter.InputBox_TabPressed()
	local vReverse = IsShiftKeyDown()
	local vEditBox = this
	
	for vIndex = 1, 50 do
		local vNextEditBox
			
		if vReverse then
			vNextEditBox = vEditBox.prevEditBox
		else
			vNextEditBox = vEditBox.nextEditBox
		end
		
		if vNextEditBox:IsVisible()
		and not vNextEditBox.isDisabled then
			vNextEditBox:SetFocus()
			return
		end
		
		vEditBox = vNextEditBox
	end
end

function Outfitter:ScheduleEquipmentUpdate()
	if not self.EquippedNeedsUpdate
	and not self.WeaponsNeedUpdate then
		return
	end
	
	local vElapsed = GetTime() - self.LastEquipmentUpdateTime
	local vDelay = self.cMinEquipmentUpdateInterval - vElapsed
	
	 if vDelay < 0.05 then
		vDelay = 0.05
	end
	
	MCSchedulerLib:ScheduleUniqueTask(vDelay, self.UpdateEquippedItems, self)
end

function Outfitter.MinimapButton_MouseDown()
	-- Remember where the cursor was in case the user drags
	
	local vCursorX, vCursorY = GetCursorPosition()
	
	vCursorX = vCursorX / this:GetEffectiveScale()
	vCursorY = vCursorY / this:GetEffectiveScale()
	
	OutfitterMinimapButton.CursorStartX = vCursorX
	OutfitterMinimapButton.CursorStartY = vCursorY
	
	local vCenterX, vCenterY = OutfitterMinimapButton:GetCenter()
	local vMinimapCenterX, vMinimapCenterY = Minimap:GetCenter()
	
	OutfitterMinimapButton.CenterStartX = vCenterX - vMinimapCenterX
	OutfitterMinimapButton.CenterStartY = vCenterY - vMinimapCenterY
	
	OutfitterMinimapButton.EnableFreeDrag = IsModifierKeyDown()
end

function Outfitter.MinimapButton_DragStart()
	MCSchedulerLib:ScheduleUniqueRepeatingTask(0, Outfitter.MinimapButton_UpdateDragPosition)
end

function Outfitter.MinimapButton_DragEnd()
	MCSchedulerLib:UnscheduleTask(Outfitter.MinimapButton_UpdateDragPosition)
end

function Outfitter.MinimapButton_UpdateDragPosition()
	-- Remember where the cursor was in case the user drags
	
	local vCursorX, vCursorY = GetCursorPosition()
	
	vCursorX = vCursorX / this:GetEffectiveScale()
	vCursorY = vCursorY / this:GetEffectiveScale()
	
	local vCursorDeltaX = vCursorX - OutfitterMinimapButton.CursorStartX
	local vCursorDeltaY = vCursorY - OutfitterMinimapButton.CursorStartY
	
	--
	
	local vCenterX = OutfitterMinimapButton.CenterStartX + vCursorDeltaX
	local vCenterY = OutfitterMinimapButton.CenterStartY + vCursorDeltaY
	
	if OutfitterMinimapButton.EnableFreeDrag then
		Outfitter.MinimapButton_SetPosition(vCenterX, vCenterY)
	else
		-- Calculate the angle and set the new position
		
		local vAngle = math.atan2(vCenterX, vCenterY)
		
		Outfitter.MinimapButton_SetPositionAngle(vAngle)
	end
end

function Outfitter:RestrictAngle(pAngle, pRestrictStart, pRestrictEnd)
	if pAngle <= pRestrictStart
	or pAngle >= pRestrictEnd then
		return pAngle
	end
	
	local vDistance = (pAngle - pRestrictStart) / (pRestrictEnd - pRestrictStart)
	
	if vDistance > 0.5 then
		return pRestrictEnd
	else
		return pRestrictStart
	end
end

function Outfitter.MinimapButton_SetPosition(pX, pY)
	gOutfitter_Settings.Options.MinimapButtonAngle = nil
	gOutfitter_Settings.Options.MinimapButtonX = pX
	gOutfitter_Settings.Options.MinimapButtonY = pY
	
	OutfitterMinimapButton:SetPoint("CENTER", Minimap, "CENTER", pX, pY)
end

function Outfitter.MinimapButton_SetPositionAngle(pAngle)
	local vAngle = pAngle
	
	-- Restrict the angle from going over the date/time icon or the zoom in/out icons
	--[[
	local vRestrictedStartAngle = nil
	local vRestrictedEndAngle = nil
	
	if GameTimeFrame:IsVisible() then
		if MinimapZoomIn:IsVisible()
		or MinimapZoomOut:IsVisible() then
			vAngle = Outfitter:RestrictAngle(vAngle, 0.4302272732931596, 2.930420793963121)
		else
			vAngle = Outfitter:RestrictAngle(vAngle, 0.4302272732931596, 1.720531504573905)
		end
		
	elseif MinimapZoomIn:IsVisible()
	or MinimapZoomOut:IsVisible() then
		vAngle = Outfitter:RestrictAngle(vAngle, 1.720531504573905, 2.930420793963121)
	end
	
	-- Restrict it from the tracking icon area
	
	vAngle = Outfitter:RestrictAngle(vAngle, -1.290357134304173, -0.4918423429923585)
	]]--
	
	--
	
	local vRadius = 80
	
	vCenterX = math.sin(vAngle) * vRadius
	vCenterY = math.cos(vAngle) * vRadius
	
	OutfitterMinimapButton:SetPoint("CENTER", Minimap, "CENTER", vCenterX - 1, vCenterY - 1)
	
	gOutfitter_Settings.Options.MinimapButtonAngle = vAngle
end

function Outfitter.MinimapButton_ItemSelected(pMenu, pValue)
	local vType = type(pValue)

	if vType == "table" then
		local vCategoryID = pValue.CategoryID
		local vIndex = pValue.Index
		local vOutfit = gOutfitter_Settings.Outfits[vCategoryID][vIndex]
		local vDoToggle = vCategoryID ~= "Complete"
		
		if vDoToggle
		and Outfitter:WearingOutfit(vOutfit) then
			Outfitter:RemoveOutfit(vOutfit)
		else
			Outfitter:WearOutfit(vOutfit)
		end
		
		if vDoToggle then
			return true
		end
	else
		if pValue == 0 then -- Open Outfitter
			Outfitter:OpenUI()
		end
		if pValue == -1 then -- Change AutoSwitch Value.
			Outfitter:SetAutoSwitch(gOutfitter_Settings.Options.DisableAutoSwitch)
			return true
		end
	end

	return false
end

function Outfitter:OpenUI()
	ShowUIPanel(CharacterFrame)
	CharacterFrame_ShowSubFrame("PaperDollFrame")
	OutfitterFrame:Show()
end

function Outfitter:WearingOutfitName(pOutfitName)
	local vOutfit = Outfitter:FindOutfitByName(pOutfitName)
	
	return vOutfit and Outfitter:WearingOutfit(vOutfit)
end

function Outfitter:WearingOutfit(pOutfit)
	return Outfitter.OutfitStack:FindOutfit(pOutfit)
end

function Outfitter:CheckDatabase()
	local vOutfit
	
	if not gOutfitter_Settings.Version then
		local vOutfits = gOutfitter_Settings.Outfits[vCategoryID]
		
		if gOutfitter_Settings.Outfits then
			for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
				for vIndex, vOutfit in ipairs(vOutfits) do
					if self:OutfitIsComplete(vOutfit, true) then
						self:AddOutfitItem(vOutfit, "AmmoSlot", nil)
					end
				end
			end
		end
		
		gOutfitter_Settings.Version = 1
	end
	
	-- Versions 1 and 2 both simply add class outfits
	-- so just reinitialize those
	
	if gOutfitter_Settings.Version < 3 then
		self:InitializeClassOutfits()
		gOutfitter_Settings.Version = 3
	end
	
	-- Version 4 sets the BGDisabled flag for the mounted outfit
	
	if gOutfitter_Settings.Version < 4 then
		local vRidingOutfit = self:GetOutfitByScriptID("Riding")
		
		if vRidingOutfit then
			vRidingOutfit.BGDisabled = true
		end
		
		gOutfitter_Settings.Version = 4
	end
	
	-- Version 5 adds moonkin form, just reinitialize class outfits

	if gOutfitter_Settings.Version < 5 then
		self:InitializeClassOutfits()
		gOutfitter_Settings.Version = 5
	end
	
	-- Make sure all outfits have an associated category ID
	
	if gOutfitter_Settings.Outfits then
		for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
			for vIndex, vOutfit in ipairs(vOutfits) do
				vOutfit.CategoryID = vCategoryID
			end
		end
	end
	
	-- Version 6 and 7 adds item sub-code and enchantment codes
	-- (7 tries to clean up failed updates from 6)
	
	if gOutfitter_Settings.Version < 7 then
		MCSchedulerLib:ScheduleTask(5, Outfitter.UpdateDatabaseItemCodes, Outfitter)
		
		gOutfitter_Settings.Version = 7
	end
	
	-- Version 8 removes the old style cloak/helm settings
	
	if gOutfitter_Settings.Version < 8 then
		gOutfitter_Settings.HideHelm = nil
		gOutfitter_Settings.HideCloak = nil
		gOutfitter_Settings.Version = 8
	end
	
	-- Version 9 converts old SpecialIDs to ScriptIDs
	-- and removes the parial and special categories
	
	if gOutfitter_Settings.Version < 9 then
		local vUpdatedOutfits = {}
		local vDeletedOutfits = {}
		
		local vPreservedOutfits =
		{
			Battle = true,
			Defensive = true,
			Berserker = true,
			
			Bear = true,
			Cat = true,
			Aquatic = true,
			Travel = true,
			Moonkin = true,
			Tree = true,
			Prowl = true,
			Flight = true,

			Shadowform = true,

			Stealth = true,

			GhostWolf = true,

			Monkey = true,
			Hawk = true,
			Cheetah = true,
			Pack = true,
			Beast = true,
			Wild = true,
			Viper = true,
			Feigning = true,
			
			Evocate = true,
			
			ArgentDawn = true,

			Battleground = true,
		}
		
		for _, vOutfit in ipairs(gOutfitter_Settings.Outfits.Special) do
			if self:IsEmptyOutfit(vOutfit)
			and not vPreservedOutfits[vOutfit.SpecialID] then
				table.insert(vDeletedOutfits, vOutfit)
			else
				vOutfit.ScriptID = vOutfit.SpecialID
				vOutfit.SpecialID = nil
				
				table.insert(vUpdatedOutfits, vOutfit)
			end
		end
		
		--
		
		for _, vOutfit in ipairs(gOutfitter_Settings.Outfits.Partial) do
			vOutfit.IsAccessory = nil
			table.insert(vUpdatedOutfits, vOutfit)
		end
		
		--
		
		for _, vOutfit in ipairs(vUpdatedOutfits) do
			self:OutfitSettingsChanged(vOutfit)
		end
		
		for _, vOutfit in ipairs(vDeletedOutfits) do
			self:DeleteOutfit(vOutfit)
		end
		
		gOutfitter_Settings.Outfits.Special = nil
		gOutfitter_Settings.Outfits.Partial = nil
		
		gOutfitter_Settings.Version = 9
	end
	
	-- Version 10 eliminates the ScriptEvents field and moves
	-- it to the source instead
	
	if gOutfitter_Settings.Version < 10 then
		for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
			for vIndex, vOutfit in ipairs(vOutfits) do
				if vOutfit.Script and vOutfit.ScriptEvents then
					vOutfit.Script = "-- $EVENTS "..vOutfit.ScriptEvents.."\n"..vOutfit.Script
				end
				vOutfit.ScriptEvents = nil
			end
		end
		
		gOutfitter_Settings.Version = 10
	end
	
	-- Version 11 prevents scripted outfits from being treated as complete outfits
	
	if gOutfitter_Settings.Version < 11 then
		self:CheckOutfitCategories()
		gOutfitter_Settings.Version = 11
	end
	
	-- Version 12 moves the BGDisabled, AQDisabled and NaxxDisabled flags to
	-- the script settings for the riding outfiZt
	
	if gOutfitter_Settings.Version < 12 then
		local vRidingOutfit = self:GetOutfitByScriptID("Riding")
		
		if vRidingOutfit then
			if not vRidingOutfit.ScriptSettings then
				vRidingOutfit.ScriptSettings = {}
			end
			
			vRidingOutfit.ScriptSettings.DisableAQ40 = vRidingOutfit.AQDisabled
			vRidingOutfit.ScriptSettings.DisableBG = vRidingOutfit.BGDisabled
			vRidingOutfit.ScriptSettings.DisableNaxx = vRidingOutfit.NaxxDisabled
			
			vRidingOutfit.AQDisabled = nil
			vRidingOutfit.BGDisabled = nil
			vRidingOutfit.NaxxDisabled = nil
		end
		
		gOutfitter_Settings.Version = 12
	end
	
	-- Version 13 adds the LayerIndex table
	
	if gOutfitter_Settings.Version < 13 then
		gOutfitter_Settings.LayerIndex = {}
		gOutfitter_Settings.Version = 13
	end
	
	-- Version 14 updates all outfits with InvType fields
	
	if gOutfitter_Settings.Version < 14 then
		MCSchedulerLib:ScheduleTask(5, Outfitter.UpdateInvTypes, Outfitter)
		
		gOutfitter_Settings.Version = 14
	end
	
	-- Version 15 allows scripted outfits to be complete outfits
	
	if gOutfitter_Settings.Version < 15 then
		self:CheckOutfitCategories()
		gOutfitter_Settings.Version = 15
	end
	
	-- Version 16 adds the RecentCompleteOutfits list to the settings
	
	if gOutfitter_Settings.Version < 16 then
		gOutfitter_Settings.RecentCompleteOutfits = {}
		gOutfitter_Settings.Version = 16
	end
	
	if not gOutfitter_Settings.RecentCompleteOutfits then
		gOutfitter_Settings.RecentCompleteOutfits = {}
	end
	
	-- Fix up any missing settings
	
	if not gOutfitter_Settings.LayerIndex then
		gOutfitter_Settings.LayerIndex = {}
	end
	
	if not gOutfitter_Settings.LastOutfitStack then
		gOutfitter_Settings.LastOutfitStack = {}
	end
	
	if not gOutfitter_Settings.RecentCompleteOutfits then
		gOutfitter_Settings.RecentCompleteOutfits = {}
	end
	
	if not gOutfitter_Settings.OutfitBar then
		gOutfitter_Settings.OutfitBar = {}
		gOutfitter_Settings.OutfitBar.ShowOutfitBar = true
	end
	
	-- Scan the outfits and make sure everything is in order
	
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vIndex, vOutfit in ipairs(vOutfits) do
			self:CheckOutfit(vOutfit, vCategoryID)
		end
	end
end

function Outfitter:CheckOutfitCategories()
	local vAllOutfits = {}
	
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for _, vOutfit in ipairs(vOutfits) do
			table.insert(vAllOutfits, vOutfit)
		end
	end
	
	for _, vOutfit in ipairs(vAllOutfits) do
		self:OutfitSettingsChanged(vOutfit)
	end
end

Outfitter.DefaultRepairValues =
{
	Code = 0,
	SubCode = 0,
	Name = "",
	EnchantCode = 0,
	JewelCode1 = 0,
	JewelCode2 = 0,
	JewelCode3 = 0,
	JewelCode4 = 0,
}

function Outfitter:CheckOutfit(pOutfit, pCategoryID)
	if not pOutfit.Name then
		pOutfit.Name = "Damaged outfit"
	end
	
	if pOutfit.CategoryID ~= pCategoryID then
		pOutfit.CategoryID = pCategoryID
	end
	
	if not pOutfit.Items then
		pOutfit.Items = {}
	end
	
	for vInventorySlot, vItem in pairs(pOutfit.Items) do
		for vField, vDefaultValue in pairs(Outfitter.DefaultRepairValues) do
			if not vItem[vField] then
				vItem[vField] = vDefaultValue
			end
		end
	end
end

function Outfitter:UpdateInvTypes()
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	local vResult = true
	
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vIndex, vOutfit in ipairs(vOutfits) do
			for vInventorySlot, vOutfitItem in pairs(vOutfit.Items) do
				if vOutfitItem.Code ~= 0 then
					local vItem = Outfitter.ItemList_FindItemOrAlt(vEquippableItems, vOutfitItem, false, true)
					
					if vItem then
						vOutfitItem.InvType = vItem.InvType
					else
						vResult = false
					end
				end
			end
		end
	end
	
	return vResult
end

function Outfitter:UpdateDatabaseItemCodes()
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	local vResult = true
	
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vIndex, vOutfit in ipairs(vOutfits) do
			for vInventorySlot, vOutfitItem in pairs(vOutfit.Items) do
				if vOutfitItem.Code ~= 0 then
					local vItem = Outfitter.ItemList_FindItemOrAlt(vEquippableItems, vOutfitItem, false, true)
					
					if vItem then
						vOutfitItem.SubCode = vItem.SubCode
						vOutfitItem.Name = vItem.Name
						vOutfitItem.EnchantCode = vItem.EnchantCode
						vOutfitItem.JewelCode1 = vItem.JewelCode1
						vOutfitItem.JewelCode2 = vItem.JewelCode2
						vOutfitItem.JewelCode3 = vItem.JewelCode3
						vOutfitItem.JewelCode4 = vItem.JewelCode4
						vOutfitItem.Checksum = nil
					else
						vResult = false
					end
				end
			end
		end
	end
	
	return vResult
end

function Outfitter.ItemList_AddItem(pItemList, pItem)
	-- Add the item to the code list

	local vItemFamily = pItemList.ItemsByCode[pItem.Code]

	if not vItemFamily then
		vItemFamily = {}
		pItemList.ItemsByCode[pItem.Code] = vItemFamily
	end
	
	table.insert(vItemFamily, pItem)
	
	-- Add the item to the slot list
	
	local vItemSlot = pItemList.ItemsBySlot[pItem.ItemSlotName]
	
	if not vItemSlot then
		vItemSlot = {}
		pItemList.ItemsBySlot[pItem.ItemSlotName] = vItemSlot
	end
	
	table.insert(vItemSlot, pItem)
	
	-- Add the item to the bags
	
	if pItem.Location.BagIndex then
		local vBagItems = pItemList.BagItems[pItem.Location.BagIndex]
		
		if not vBagItems then
			vBagItems = {}
			pItemList.BagItems[pItem.Location.BagIndex] = vBagItems
		end
		
		vBagItems[pItem.Location.BagSlotIndex] = pItem
		
	-- Add the item to the inventory
	
	elseif pItem.Location.SlotName then
		pItemList.InventoryItems[pItem.Location.SlotName] = pItem
	end
end

function Outfitter:GetNumBags()
	if Outfitter.BankFrameOpened then
		return NUM_BAG_SLOTS + NUM_BANKBAGSLOTS, -1
	else
		return NUM_BAG_SLOTS, 0
	end
end

function Outfitter:GetInventorySlotIDLink(pSlotID)
	if pSlotID == 0 then -- AmmoSlot
		return Outfitter:GetAmmotSlotItemLink()
	else
		return GetInventoryItemLink("player", pSlotID)
	end
end

Outfitter.LinkCache =
{
	Inventory = {},
	FirstBagIndex = 0,
	NumBags = 0,
	Bags = {},
}

function Outfitter:Synchronize()
	local vBagsChanged, vInventoryChanged = false, false

	-- Synchronize bag links
	
	local vNumBags, vFirstBagIndex = Outfitter:GetNumBags()
	
	-- Outfitter:TestMessage(vFirstBagIndex.." - "..vNumBags)
	
	if Outfitter.LinkCache.FirstBagIndex ~= vFirstBagIndex
	or Outfitter.LinkCache.NumBags ~= vNumBags then
		
		Outfitter.LinkCache.FirstBagIndex = vFirstBagIndex
		Outfitter.LinkCache.NumBags = vNumBags
		
		vBagsChanged = true
	end
	
	for vBagIndex = vFirstBagIndex, vNumBags do
		local vBag = Outfitter.LinkCache.Bags[vBagIndex]
		local vBagChanged = false
		
		if not vBag then
			vBag = {}
			Outfitter.LinkCache.Bags[vBagIndex] = vBag
		end
		
		local vNumBagSlots = GetContainerNumSlots(vBagIndex)
		
		if #vBag ~= vNumBagSlots then
			Outfitter:EraseTable(vBag)
			vBagChanged = true
		end
		
		for vSlotIndex = 1, vNumBagSlots do
			local vItemLink = GetContainerItemLink(vBagIndex, vSlotIndex) or ""
			
			if vBag[vSlotIndex] ~= vItemLink then
				vBag[vSlotIndex] = vItemLink
				vBagChanged = true
			end
		end
		
		if vBagChanged then
			Outfitter.ItemList_FlushBagFromEquippableItems(vBagIndex)
			vBagsChanged = true
		end
	end
	
	-- Synchronize inventory links
	
	for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
		local vItemLink
		
		if vInventorySlot == "AmmoSlot" then
			local vName, vTexture = Outfitter:GetAmmotSlotItemName()
			
			if vName then
				vItemLink = vName.."|"..(vTexture or "") -- Not an item link, just a unique reference to the contents
			end
		else
			vItemLink = GetInventoryItemLink("player", Outfitter.cSlotIDs[vInventorySlot])
		end
		
		if Outfitter.LinkCache.Inventory[vInventorySlot] ~= vItemLink then
			Outfitter.LinkCache.Inventory[vInventorySlot] = vItemLink
			vInventoryChanged = true
		end
	end
	
	if vInventoryChanged then
		Outfitter.ItemList_FlushInventoryFromEquippableItems()
		Outfitter:InventoryChanged()
	end
	
	-- Done
	
	if vBagsChanged or vInventoryChanged then
		Outfitter.DisplayIsDirty = true
		Outfitter:Update(false)
	end
	
	return vBagsChanged or vInventoryChanged, vInventoryChanged, vBagsChanged
end

function Outfitter:GetInventorySlotItemInfo(pInventorySlot)
	local vItemLink = Outfitter:GetInventorySlotIDLink(Outfitter.cSlotIDs[pInventorySlot])

	if not vItemLink then
		return
	end
	
	local vStartIndex, vEndIndex,
			vLinkColor,
			vItemCode,
			vItemEnchantCode,
			vItemJewelCode1,
			vItemJewelCode2,
			vItemJewelCode3,
			vItemJewelCode4,
			vItemSubCode,
			vUnknownCode5,
			vItemName = strfind(vItemLink, Outfitter.cItemLinkFormat)
	
	--if vItemName then
	--	Outfitter:TestMessage(string.format("Item %s:%d:%d:%d:%d:%d:%d:%d:%d", vItemName, vItemCode, vItemEnchantCode, vItemSubCode, vUnknownCode1, vUnknownCode2, vUnknownCode3, vUnknownCode4, vUnknownCode5))
	--end
	
	return
	{
		Code = tonumber(vItemCode),
		SubCode = tonumber(vItemSubCode),
		EnchantCode = tonumber(vItemEnchantCode),
		JewelCode1 = tonumber(vItemJewelCode1),
		JewelCode2 = tonumber(vItemJewelCode2),
		JewelCode3 = tonumber(vItemJewelCode3),
		JewelCode4 = tonumber(vItemJewelCode4),	
	}
end

function Outfitter.ItemList_FlushChangedItems()
	if not Outfitter.EquippableItems then
		return
	end
	
	-- Check inventory
	
	local vFlushInventory = false

	for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
		local vEquippedItemInfo = Outfitter:GetInventorySlotItemInfo(vInventorySlot)
		local vItemInfo = Outfitter.EquippableItems.InventoryItems[vInventorySlot]
		
		if (vEquippedItemInfo ~= nil) ~= (vItemInfo ~= nil) then
			vFlushInventory = true
			break
		end
		
		if vItemInfo
		and (vItemInfo.Code ~= vEquippedItemInfo.Code
		  or vItemInfo.SubCode ~= vEquippedItemInfo.SubCode
		  or vItemInfo.EnchantCode ~= vEquippedItemInfo.EnchantCode 
		  or vItemInfo.JewelCode1 ~= vEquippedItemInfo.JewelCode1 
		  or vItemInfo.JewelCode2 ~= vEquippedItemInfo.JewelCode2 
		  or vItemInfo.JewelCode3 ~= vEquippedItemInfo.JewelCode3 
		  or vItemInfo.JewelCode4 ~= vEquippedItemInfo.JewelCode4) then
			vFlushInventory = true
			break
		end
	end
	
	-- Have to flush bags too since inventory event changes probably
	-- also have bag event changes.  Not flushing the bag can result
	-- in a strange state where an item appears to be in two places at once.
	
	if vFlushInventory then
		Outfitter.ItemList_FlushEquippableItems()
	end
end

function Outfitter.ItemList_FindItemInfoByCode(pItemList, pItemInfo)
	local vItems = pItemList.ItemsByCode[pItemInfo.Code]
	
	for _, vItemInfo in ipairs(vItems) do
		if pItemInfo == vItemInfo then
			return true
		end
	end
	
	return false
end

function Outfitter.ItemList_FindItemInfoBySlot(pItemList, pItemInfo)
	local vItems = pItemList.ItemsBySlot[pItemInfo.ItemSlotName]

	for _, vItemInfo in ipairs(vItems) do
		if pItemInfo == vItemInfo then
			return true
		end
	end
	
	return false
end

function Outfitter.ItemList_VerifyItems(pItemList)
	-- Check that all the inventory items are accounted for
	
	for vInventorySlot, vItemInfo in pairs(pItemList.InventoryItems) do
		-- Verify the item in the code list
		
		if not Outfitter.ItemList_FindItemInfoByCode(pItemList, vItemInfo) then
			Outfitter:TestMessage("Didn't find item "..vItemInfo.Name.." by code")
		end
		
		-- Check the item in the slot list
		
		if not Outfitter.ItemList_FindItemInfoBySlot(pItemList, vItemInfo) then
			Outfitter:TestMessage("Didn't find item "..vItemInfo.Name.." by slot")
		end
	end
	
	-- Check that all bag items are accounted for
	
	for _, vBagItems in pairs(pItemList.BagItems) do
		for _, vItemInfo in pairs(vBagItems) do
			-- Verify the item in the code list
			
			if not Outfitter.ItemList_FindItemInfoByCode(pItemList, vItemInfo) then
				Outfitter:TestMessage("Didn't find item "..vItemInfo.Name.." by code")
			end
			
			-- Check the item in the slot list
			
			if not Outfitter.ItemList_FindItemInfoBySlot(pItemList, vItemInfo) then
				Outfitter:TestMessage("Didn't find item "..vItemInfo.Name.." by slot")
			end
		end
	end
end

function Outfitter.ItemList_FlushEquippableItems()
	-- Outfitter:TestMessage("Outfitter.ItemList_FlushEquippableItems")
	Outfitter.EquippableItems = nil
end

function Outfitter.ItemList_FlushBagFromEquippableItems(pBagIndex)
	-- Outfitter:TestMessage("Outfitter.ItemList_FlushBagFromEquippableItems: "..pBagIndex)
	
	if Outfitter.EquippableItems
	and Outfitter.EquippableItems.BagItems[pBagIndex] then
		for vBagSlotIndex, vItem in pairs(Outfitter.EquippableItems.BagItems[pBagIndex]) do
			Outfitter.ItemList_RemoveItem(Outfitter.EquippableItems, vItem)
		end
		
		Outfitter.EquippableItems.NeedsUpdate = true
		Outfitter.EquippableItems.BagItems[pBagIndex] = nil
	end
end

function Outfitter.ItemList_FlushInventoryFromEquippableItems()
	if Outfitter.EquippableItems then
		for vInventorySlot, vItem in pairs(Outfitter.EquippableItems.InventoryItems) do
			Outfitter.ItemList_RemoveItem(Outfitter.EquippableItems, vItem)
		end
		
		Outfitter.EquippableItems.NeedsUpdate = true
		Outfitter.EquippableItems.InventoryItems = nil
	end
end

function Outfitter.ItemList_New()
	return {ItemsByCode = {}, ItemsBySlot = {}, InventoryItems = nil, BagItems = {}}
end

function Outfitter.ItemList_RemoveItem(pItemList, pItem)
	-- Remove the item from the code list
	
	local vItems = pItemList.ItemsByCode[pItem.Code]
	
	for vIndex, vItem in ipairs(vItems) do
		if vItem == pItem then
			table.remove(vItems, vIndex)
			break
		end
	end

	-- Remove the item from the slot list
	
	local vItemSlot = pItemList.ItemsBySlot[pItem.ItemSlotName]
	
	if vItemSlot then
		for vIndex, vItem in ipairs(vItemSlot) do
			if vItem == pItem then
				table.remove(vItemSlot, vIndex)
				break
			end
		end
	end
	
	-- Remove the item from the bags list
	
	if pItem.Location.BagIndex then
		local vBagItems = pItemList.BagItems[pItem.Location.BagIndex]
		
		if vBagItems then
			vBagItems[pItem.Location.BagSlotIndex] = nil
		end
		
	-- Remove the item from the inventory list
	
	elseif pItem.Location.SlotName then
		pItemList.InventoryItems[pItem.Location.SlotName] = nil
	end
end

function Outfitter.ItemList_GetInventoryOutfit(pEquippableItems)
	return pEquippableItems.InventoryItems
end

function Outfitter.ItemList_ResetIgnoreItemFlags(pItemList)
	for vItemCode, vItemFamily in pairs(pItemList.ItemsByCode) do
		for _, vItem in ipairs(vItemFamily) do
			vItem.IgnoreItem = nil
		end
	end
end

function Outfitter.ItemList_GetEquippableItems(pIncludeItemStats)
	-- Check for a change in the number of bags
	
	local vNumBags, vFirstBagIndex = Outfitter:GetNumBags()
	
	if Outfitter.EquippableItems
	and (Outfitter.EquippableItems.FirstBagIndex ~= vFirstBagIndex
	or Outfitter.EquippableItems.NumBags ~= vNumBags) then
		for vBagIndex = Outfitter.EquippableItems.FirstBagIndex, vFirstBagIndex - 1 do
			Outfitter.ItemList_FlushBagFromEquippableItems(vBagIndex)
		end
		
		for vBagIndex = vNumBags + 1, Outfitter.EquippableItems.NumBags do
			Outfitter.ItemList_FlushBagFromEquippableItems(vBagIndex)
		end
		
		Outfitter.EquippableItems.NeedsUpdate = true
	end
	
	-- If there's a cached copy just clear the IgnoreItem flags and return it
	-- (never use the cached copy if the caller wants stats)
	
	if Outfitter.EquippableItems
	and not Outfitter.EquippableItems.NeedsUpdate
	and not pIncludeItemStats then
		-- Outfitter:TestMessage("Outfitter.ItemList_GetEquippableItems: Using cached list")
		Outfitter.ItemList_ResetIgnoreItemFlags(Outfitter.EquippableItems)
		
		return Outfitter.EquippableItems
	end
	
	if not Outfitter.EquippableItems
	or pIncludeItemStats then
		Outfitter.EquippableItems = Outfitter.ItemList_New()
	end
	
	local vStatDistribution = Outfitter:GetPlayerStatDistribution()
	
	if not Outfitter.EquippableItems.InventoryItems
	or pIncludeItemStats then
		-- Outfitter:TestMessage("Outfitter.ItemList_GetEquippableItems: Rebuilding inventory items")
		
		Outfitter.EquippableItems.InventoryItems = {}
		
		for _, vInventorySlot in ipairs(Outfitter.cSlotNames) do
			local vItemInfo = Outfitter:GetInventoryItemInfo(vInventorySlot)
			
			if vItemInfo
			and vItemInfo.ItemSlotName
			and vItemInfo.Code ~= 0 then
				vItemInfo.SlotName = vInventorySlot
				vItemInfo.Location = {SlotName = vInventorySlot}
				
				if pIncludeItemStats then	
					Outfitter.ItemList_GetItemStats(vItemInfo, vStatDistribution)
				end
				
				Outfitter.ItemList_AddItem(Outfitter.EquippableItems, vItemInfo)
			end
		end
	else
		for vInventorySlot, vItem in pairs(Outfitter.EquippableItems.InventoryItems) do
			vItem.IgnoreItem = nil
		end
	end
	
	for vBagIndex = vFirstBagIndex, vNumBags do
		local vBagItems = Outfitter.EquippableItems.BagItems[vBagIndex]
		
		if not vBagItems
		or pIncludeItemStats then
			Outfitter.EquippableItems.BagItems[vBagIndex] = {}
			
			local vNumBagSlots = GetContainerNumSlots(vBagIndex)
			
			if vNumBagSlots > 0 then
				-- Outfitter:TestMessage("Outfitter.ItemList_GetEquippableItems: Rebuilding bag "..vBagIndex)
				
				for vBagSlotIndex = 1, vNumBagSlots do
					local vItemInfo = Outfitter:GetBagItemInfo(vBagIndex, vBagSlotIndex)
					
					if vItemInfo
					and vItemInfo.Code ~= 0
					and vItemInfo.ItemSlotName
					and Outfitter:CanEquipBagItem(vBagIndex, vBagSlotIndex)
					and not Outfitter:BagItemWillBind(vBagIndex, vBagSlotIndex) then
						vItemInfo.BagIndex = vBagIndex
						vItemInfo.BagSlotIndex = vBagSlotIndex
						vItemInfo.Location = {BagIndex = vBagIndex, BagSlotIndex = vBagSlotIndex}
						
						if pIncludeItemStats then	
							Outfitter.ItemList_GetItemStats(vItemInfo, vStatDistribution)
						end
						
						Outfitter.ItemList_AddItem(Outfitter.EquippableItems, vItemInfo)
					end
				end -- for vBagSlotIndex
			end -- if vNumBagSlots > 0
		else -- if not BagItems
			for vBagSlotIndex, vItem in pairs(vBagItems) do
				vItem.IgnoreItem = nil
			end
		end -- if not BagItems
	end -- for vBagIndex
	
	Outfitter.EquippableItems.FirstBagIndex = vFirstBagIndex
	Outfitter.EquippableItems.NumBags = vNumBags
	
	Outfitter.EquippableItems.NeedsUpdate = false
	
	return Outfitter.EquippableItems
end

function Outfitter.ItemList_SwapLocations(pItemList, pLocation1, pLocation2)
	-- if pLocation1.BagIndex then
	-- 	Outfitter:TestMessage("Outfitter.ItemList_SwapLocations: Swapping bag "..pLocation1.BagIndex..", "..pLocation1.BagSlotIndex)
	-- elseif pLocation1.SlotName then
	-- 	Outfitter:TestMessage("Outfitter.ItemList_SwapLocations: Swapping slot "..pLocation1.SlotName)
	-- end
	-- if pLocation2.BagIndex then
	-- 	Outfitter:TestMessage("Outfitter.ItemList_SwapLocations: with bag "..pLocation2.BagIndex..", "..pLocation2.BagSlotIndex)
	-- elseif pLocation2.SlotName then
	-- 	Outfitter:TestMessage("Outfitter.ItemList_SwapLocations: with slot "..pLocation2.SlotName)
	-- end
end

function Outfitter.ItemList_SwapLocationWithInventorySlot(pItemList, pLocation, pSlotName)
	-- if pLocation.BagIndex then
	-- 	Outfitter:TestMessage("Outfitter.ItemList_SwapLocationWithInventorySlot: Swapping bag "..pLocation.BagIndex..", "..pLocation.BagSlotIndex.." with slot "..pSlotName)
	-- elseif pLocation.SlotName then
	-- 	Outfitter:TestMessage("Outfitter.ItemList_SwapLocationWithInventorySlot: Swapping slot "..pLocation.SlotName.." with slot "..pSlotName)
	-- end
end

function Outfitter.ItemList_SwapBagSlotWithInventorySlot(pItemList, pBagIndex, pBagSlotIndex, pSlotName)
	-- Outfitter:TestMessage("Outfitter.ItemList_SwapBagSlotWithInventorySlot: Swapping bag "..pBagIndex..", "..pBagSlotIndex.." with slot "..pSlotName)
end

function Outfitter.ItemList_FindItemOrAlt(pItemList, pOutfitItem, pMarkAsInUse, pAllowSubCodeWildcard)
	local vItem, vIgnoredItem = Outfitter.ItemList_FindItem(pItemList, pOutfitItem, pMarkAsInUse, pAllowSubCodeWildcard)
	
	if vItem then
		return vItem
	end
	
	-- See if there's an alias for the item if it wasn't found
	
	local vAltCode = Outfitter.cItemAliases[pOutfitItem.Code]
	
	if not vAltCode then
		return nil, vIgnoredItem
	end
	
	return Outfitter.ItemList_FindItem(pItemList, {Code = vAltCode}, pMarkAsInUse, true)
end

function Outfitter.ItemList_FindItem(pItemList, pOutfitItem, pMarkAsInUse, pAllowSubCodeWildcard)
	local vItem, vIndex, vItemFamily, vIgnoredItem = Outfitter.ItemList_FindItemIndex(pItemList, pOutfitItem, pAllowSubCodeWildcard)
	
	if not vItem then
		return nil, vIgnoredItem
	end
	
	if pMarkAsInUse then
		vItem.IgnoreItem = true
	end
	
	return vItem
end

function Outfitter.ItemList_FindAllItemsOrAlt(pItemList, pOutfitItem, pAllowSubCodeWildcard, rItems)
	local vNumItems = Outfitter.ItemList_FindAllItems(pItemList, pOutfitItem, pAllowSubCodeWildcard, rItems)
	local vAltCode = Outfitter.cItemAliases[pOutfitItem.Code]
	
	if vAltCode then
		vNumItems = vNumItems + Outfitter.ItemList_FindAllItems(pItemList, {Code = vAltCode}, true, rItems)
	end
	
	return vNumItems
end

function Outfitter.ItemList_FindAllItems(pItemList, pOutfitItem, pAllowSubCodeWildcard, rItems)
	if not pItemList then
		return 0
	end
	
	local vItemFamily = pItemList.ItemsByCode[pOutfitItem.Code]
	
	if not vItemFamily then
		return 0
	end
	
	local vNumItemsFound = 0
	
	for vIndex, vItem in ipairs(vItemFamily) do
		if (pAllowSubCodeWildcard and not pOutfitItem.SubCode)
		or vItem.SubCode == pOutfitItem.SubCode then
			table.insert(rItems, vItem)
			vNumItemsFound = vNumItemsFound + 1
		end
	end
	
	return vNumItemsFound
end

function Outfitter.ItemList_FindItemIndex(pItemList, pOutfitItem, pAllowSubCodeWildcard)
	if not pItemList then
		return
	end
	
	local vItemFamily = pItemList.ItemsByCode[pOutfitItem.Code]
	
	if not vItemFamily then
		return
	end
	
	local vBestMatch = nil
	local vBestMatchIndex = nil
	local vNumItemsFound = 0
	local vFoundIgnoredItem = nil
	
	for vIndex, vItem in ipairs(vItemFamily) do
		-- All done if the caller doesn't care about the SubCode
		
		if pAllowSubCodeWildcard
		and not pOutfitItem.SubCode then
			if vItem.IgnoreItem then
				vFoundIgnoredItem = vItem
			else
				return vItem, vIndex, vItemFamily, nil
			end
		
		-- If the subcode matches then check for an enchant match
		
		elseif vItem.SubCode == pOutfitItem.SubCode then
			-- If the enchant matches then we're all done
			
			if vItem.EnchantCode == pOutfitItem.EnchantCode 
			and vItem.JewelCode1 == pOutfitItem.JewelCode1 
			and vItem.JewelCode2 == pOutfitItem.JewelCode2
			and vItem.JewelCode3 == pOutfitItem.JewelCode3 
			and vItem.JewelCode4 == pOutfitItem.JewelCode4	then
				if vItem.IgnoreItem then
					vFoundIgnoredItem = vItem
				else
					return vItem, vIndex, vItemFamily
				end
			
			-- Otherwise save the match in case a better one can
			-- be found
			
			else
				if vItem.IgnoreItem then
					if not vFoundIgnoredItem then
						vFoundIgnoredItem = vItem
					end
				else
					vBestMatch = vItem
					vBestMatchIndex = vIndex
					vNumItemsFound = vNumItemsFound + 1
				end
			end
		end
	end
	
	-- Return the match if only one item was found
	
	if vNumItemsFound == 1
	and not vBestMatch.IgnoreItem then
		return vBestMatch, vBestMatchIndex, vItemFamily, nil
	end
	
	return nil, nil, nil, vFoundIgnoredItem
end
		
function Outfitter.ItemList_GetItemStats(pItem, pDistribution)
	if pItem.Stats then
		return pItem.Stats
	end
	
	OutfitterTooltip:SetOwner(OutfitterFrame, "ANCHOR_BOTTOMRIGHT", 0, 0)
	
	if pItem.SlotName then
		local vHasItem = OutfitterTooltip:SetInventoryItem("player", Outfitter.cSlotIDs[pItem.SlotName])
		
		if not vHasItem then
			OutfitterTooltip:Hide()
			return nil
		end
	elseif pItem.BagIndex == -1 then
		OutfitterTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(pItem.BagSlotIndex))
	else
		OutfitterTooltip:SetBagItem(pItem.BagIndex, pItem.BagSlotIndex)
	end
	
	local vStats = Outfitter:GetItemStatsFromTooltip(OutfitterTooltip)
	
	OutfitterTooltip:Hide()
	
	if not vStats then
		return nil
	end
	
	pItem.Stats = vStats
	
	if pDistribution then
		Outfitter:ConvertRatingsToStats(vStats)
		Outfitter:DistributeSecondaryStats(vStats, pDistribution)
	end

	return vStats
end

function Outfitter.ItemList_GetItemLinkStats(pItemLink, pDistribution)
	OutfitterTooltip:SetOwner(OutfitterFrame, "ANCHOR_BOTTOMRIGHT", 0, 0)
	OutfitterTooltip:SetHyperlink(pItemLink)
	
	local vStats = Outfitter:GetItemStatsFromTooltip(OutfitterTooltip)
	
	OutfitterTooltip:Hide()
	
	return vStats
end

function Outfitter:IsBankBagIndex(pBagIndex)
	return pBagIndex and (pBagIndex > NUM_BAG_SLOTS or pBagIndex < 0)
end

function Outfitter.ItemList_GetMissingItems(pEquippableItems, pOutfit)
	if not pOutfit then
		Outfitter:DebugMessage("ItemList_GetMissingItems: pOutfit is nil")
		Outfitter:DebugStack()
		return
	end
	
	local vMissingItems = nil
	local vBankedItems = nil
	
	for vInventorySlot, vOutfitItem in pairs(pOutfit.Items) do
		if vOutfitItem.Code ~= 0 then
			local vItem = Outfitter.ItemList_FindItemOrAlt(pEquippableItems, vOutfitItem)
			
			if not vItem then
				if not vMissingItems then
					vMissingItems = {}
				end
				
				table.insert(vMissingItems, vOutfitItem)
			elseif Outfitter:IsBankBagIndex(vItem.Location.BagIndex) then
				if not vBankedItems then
					vBankedItems = {}
				end
				
				table.insert(vBankedItems, vOutfitItem)
			end
		end
	end
	
	return vMissingItems, vBankedItems
end

function Outfitter.ItemList_CompiledUnusedItemsList(pEquippableItems)
	Outfitter.ItemList_ResetIgnoreItemFlags(pEquippableItems)
	
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for vOutfitIndex, vOutfit in ipairs(vOutfits) do
			for vInventorySlot, vOutfitItem in pairs(vOutfit.Items) do
				if vOutfitItem.Code ~= 0 then
					local vItem = Outfitter.ItemList_FindItemOrAlt(pEquippableItems, vOutfitItem, true)
					
					if vItem then
						vItem.UsedInOutfit = true
					end
				end
			end
		end
	end
	
	local vUnusedItems = nil
	
	for vCode, vFamilyItems in pairs(pEquippableItems.ItemsByCode) do
		for vIndex, vOutfitItem in ipairs(vFamilyItems) do
			if not vOutfitItem.UsedInOutfit
			and vOutfitItem.ItemSlotName ~= "AmmoSlot"
			and Outfitter.cIgnoredUnusedItems[vOutfitItem.Code] == nil then
				if not vUnusedItems then
					vUnusedItems = {}
				end
				
				table.insert(vUnusedItems, vOutfitItem)
			end
		end
	end
	
	pEquippableItems.UnusedItems = vUnusedItems
end

function Outfitter.ItemList_ItemsAreSame(pEquippableItems, pItem1, pItem2)
	if not pItem1 then
		return pItem2 == nil
	end
	
	if not pItem2 then
		return false
	end
	
	if pItem1.Code == 0 then
		return pItem2.Code == 0
	end
	
	if pItem1.Code ~= pItem2.Code
	or pItem1.SubCode ~= pItem2.SubCode then
		return false
	end
	
	local vItems = {}
	local vNumItems = Outfitter.ItemList_FindAllItemsOrAlt(pEquippableItems, pItem1, nil, vItems)
	
	if vNumItems == 0 then
		-- Shouldn't ever get here
		
		Outfitter:DebugMessage("Outfitter.ItemList_ItemsAreSame: Item not found")
		Outfitter:DebugTable("Item", pItem1)
		
		return false
	elseif vNumItems == 1 then
		-- If there's only one of that item then the enchant code
		-- is disregarded so just make sure it's the same
		
		return true
	else
		return pItem1.EnchantCode == pItem2.EnchantCode
		   and pItem1.JewelCode1 == pItem2.JewelCode1
		   and pItem1.JewelCode2 == pItem2.JewelCode2
		   and pItem1.JewelCode3 == pItem2.JewelCode3
		   and pItem1.JewelCode4 == pItem2.JewelCode4
	end
end

function Outfitter.ItemList_InventorySlotContainsItem(pEquippableItems, pInventorySlot, pOutfitItem)
	-- Nil items are supposed to be ignored, so never claim the slot contains them
	
	if pOutfitItem == nil then
		return false, nil
	end
	
	-- If the item specifies an empty slot check to see if the slot is actually empty
	
	if pOutfitItem.Code == 0 then
		return pEquippableItems.InventoryItems[pInventorySlot] == nil
	end
	
	local vItems = {}
	local vNumItems = Outfitter.ItemList_FindAllItemsOrAlt(pEquippableItems, pOutfitItem, nil, vItems)
	
	if vNumItems == 0 then
		return false
	elseif vNumItems == 1 then
		-- If there's only one of that item then the enchant code
		-- is disregarded so just make sure it's in the slot
		
		return vItems[1].SlotName == pInventorySlot, vItems[1]
	else
		-- See if one of the items is in the slot
		
		for vIndex, vItem in ipairs(vItems) do
			if vItem.SlotName == pInventorySlot then
				-- Must match the enchant and jewel codes if there are multiple items
				-- in order to be considered a perfect match
				
				local vCodesMatch = vItem.EnchantCode == pOutfitItem.EnchantCode
				                and vItem.JewelCode1 == pOutfitItem.JewelCode1
				                and vItem.JewelCode2 == pOutfitItem.JewelCode2
				                and vItem.JewelCode3 == pOutfitItem.JewelCode3
				                and vItem.JewelCode4 == pOutfitItem.JewelCode4
				
				return vCodesMatch, vItem
			end
		end
		
		-- No items in the slot
		
		return false, nil
	end
end

function Outfitter:GetPlayerStat(pStatIndex)
	local _, vEffectiveValue, vPosValue, vNegValue = UnitStat("player", pStatIndex)
	
	return vEffectiveValue - vPosValue - vNegValue, vPosValue + vNegValue
end

function Outfitter:DepositOutfit(pOutfit, pUniqueItemsOnly)
	-- Deselect any outfits to avoid them from being updated when
	-- items get put away
	
	Outfitter:ClearSelection()
	
	-- Build a list of items for the outfit
	
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	
	Outfitter.ItemList_ResetIgnoreItemFlags(vEquippableItems)
	
	-- Make a copy of the outfit
	
	local vUnequipOutfit = Outfitter:NewEmptyOutfit()
	
	for vInventorySlot, vItem in pairs(pOutfit.Items) do
		vUnequipOutfit.Items[vInventorySlot] = vItem
	end
	
	-- Subtract out items from other outfits if unique is specified
	
	if pUniqueItemsOnly then
		for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
			for vOutfitIndex, vOutfit in ipairs(vOutfits) do
				if vOutfit ~= pOutfit then
					local vMissingItems, vBankedItems = Outfitter.ItemList_GetMissingItems(vEquippableItems, vOutfit)
					
					-- Only subtract out items from outfits which aren't themselves partialy banked
					
					if vBankedItems == nil then
						Outfitter:SubtractOutfit(vUnequipOutfit, vOutfit, true)
					end
				end -- if vOutfit
			end -- for vOutfitIndex
		end -- for vCategoryID
	end -- if pUniqueItemsOnly
	
	-- Build the change list
	
	Outfitter.ItemList_ResetIgnoreItemFlags(vEquippableItems)
	
	local vEquipmentChangeList = Outfitter:BuildUnequipChangeList(vUnequipOutfit, vEquippableItems)
	
	if not vEquipmentChangeList then
		return
	end
	
	-- Eliminate items which are already banked
	
	local vChangeIndex = 1
	local vNumChanges = #vEquipmentChangeList
	
	while vChangeIndex <= vNumChanges do
		vEquipmentChange = vEquipmentChangeList[vChangeIndex]
		
		if Outfitter:IsBankBagIndex(vEquipmentChange.FromLocation.BagIndex) then
			table.remove(vEquipmentChangeList, vChangeIndex)
			vNumChanges = vNumChanges - 1
		else
			vChangeIndex = vChangeIndex + 1
		end
	end
	
	-- Get the list of empty bank slots
	
	local vEmptyBankSlots = Outfitter:GetEmptyBankSlotList()
	
	-- Execute the changes
	
	Outfitter:ExecuteEquipmentChangeList2(vEquipmentChangeList, vEmptyBankSlots, Outfitter.cDepositBagsFullError, vExpectedEquippableItems)
	
	Outfitter:DispatchOutfitEvent("EDIT_OUTFIT", pOutfit.Name, pOutfit)
end

function Outfitter:WithdrawOutfit(pOutfit)
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	
	-- Build a list of items for the outfit
	
	Outfitter.ItemList_ResetIgnoreItemFlags(vEquippableItems)
	
	local vEquipmentChangeList = Outfitter:BuildUnequipChangeList(pOutfit, vEquippableItems)
	
	if not vEquipmentChangeList then
		return
	end
	
	-- Eliminate items which aren't in the bank
	
	local vChangeIndex = 1
	local vNumChanges = #vEquipmentChangeList
	
	while vChangeIndex <= vNumChanges do
		vEquipmentChange = vEquipmentChangeList[vChangeIndex]
		
		if not Outfitter:IsBankBagIndex(vEquipmentChange.FromLocation.BagIndex) then
			table.remove(vEquipmentChangeList, vChangeIndex)
			vNumChanges = vNumChanges - 1
		else
			vChangeIndex = vChangeIndex + 1
		end
	end
	
	-- Get the list of empty bag slots

	local vEmptyBagSlots = Outfitter:GetEmptyBagSlotList()
	
	-- Execute the changes
	
	Outfitter:ExecuteEquipmentChangeList2(vEquipmentChangeList, vEmptyBagSlots, Outfitter.cWithdrawBagsFullError, vExpectedEquippableItems)
	
	Outfitter:DispatchOutfitEvent("EDIT_OUTFIT", pOutfit.Name, pOutfit)
end

function Outfitter.Stats_DistributeValue(pStats, pValue, pDistribution)
	if not pDistribution then
		return
	end
	
	for vSecondaryStat, vFactors in pairs(pDistribution) do
		local vSecondaryValue = pValue * vFactors.Coeff
		
		if vFactors.Const then
			vSecondaryValue = vSecondaryValue + vFactors.Const
		end
		
		Outfitter.Stats_AddStatValue(pStats, vSecondaryStat, vSecondaryValue)
	end
end

function Outfitter.Stats_AddStatValue(pStats, pStat, pValue)
	if not pStats[pStat] then
		pStats[pStat] = pValue
	else
		pStats[pStat] = pStats[pStat] + pValue
	end
	
	-- Outfitter:TestMessage("Stats_AddStatValue: "..pStat.." +"..pValue.." now "..pStats[pStat])
end

function Outfitter.Stats_SubtractStats(pStats, pStats2)
	for vStat, vValue in pairs(pStats2) do
		if pStats[vStat] then
			pStats[vStat] = pStats[vStat] - vValue
		end
	end
end

function Outfitter.Stats_AddStats(pStats, pStats2)
	for vStat, vValue in pairs(pStats2) do
		if pStats[vStat] then
			pStats[vStat] = pStats[vStat] + vValue
		else
			pStats[vStat] = vValue
		end
	end
end

function Outfitter.TankPoints_New()
	local vTankPointData = {}
	local vStatDistribution = Outfitter:GetPlayerStatDistribution()
	
	if not vStatDistribution then
		Outfitter:ErrorMessage("Missing stat distribution data for "..Outfitter.PlayerClass)
		return
	end
	
	vTankPointData.PlayerLevel = UnitLevel("player")
	vTankPointData.StaminaFactor = 1.0 -- Warlocks with demonic embrace = 1.15
	
	-- Get the base stats
	
	vTankPointData.BaseStats = {}
	
	Outfitter.Stats_AddStatValue(vTankPointData.BaseStats, "Strength", UnitStat("player", 1))
	Outfitter.Stats_AddStatValue(vTankPointData.BaseStats, "Agility", UnitStat("player", 2))
	Outfitter.Stats_AddStatValue(vTankPointData.BaseStats, "Stamina", UnitStat("player", 3))
	Outfitter.Stats_AddStatValue(vTankPointData.BaseStats, "Intellect", UnitStat("player", 4))
	Outfitter.Stats_AddStatValue(vTankPointData.BaseStats, "Spirit", UnitStat("player", 5))
	
	Outfitter.Stats_AddStatValue(vTankPointData.BaseStats, "Health", UnitHealthMax("player"))
	
	vTankPointData.BaseStats.Health = vTankPointData.BaseStats.Health - vTankPointData.BaseStats.Stamina * 10
	
	vTankPointData.BaseStats.Dodge = GetDodgeChance()
	vTankPointData.BaseStats.Parry = GetParryChance()
	vTankPointData.BaseStats.Block = GetBlockChance()
	
	local vBaseDefense, vBuffDefense = UnitDefense("player")
	Outfitter.Stats_AddStatValue(vTankPointData.BaseStats, "Defense", vBaseDefense + vBuffDefense)
	
	-- Replace the armor with the current value since that already includes various factors
	
	local vBaseArmor, vEffectiveArmor, vArmor, vArmorPosBuff, vArmorNegBuff = UnitArmor("player")
	vTankPointData.BaseStats.Armor = vEffectiveArmor
	
	Outfitter:TestMessage("------------------------------------------")
	Outfitter:DebugTable("vTankPointData", vTankPointData)
	
	-- Subtract out the current outfit
	
	local vCurrentOutfitStats = Outfitter.TankPoints_GetCurrentOutfitStats(vStatDistribution)
	
	Outfitter:TestMessage("------------------------------------------")
	Outfitter:DebugTable("vCurrentOutfitStats", vCurrentOutfitStats)
	
	Outfitter.Stats_SubtractStats(vTankPointData.BaseStats, vCurrentOutfitStats)
	
	-- Calculate the buff stats (stuff from auras/spell buffs/whatever)
	
	vTankPointData.BuffStats = {}
	
	-- Reset the cumulative values
	
	Outfitter.TankPoints_Reset(vTankPointData)
	
	Outfitter:TestMessage("------------------------------------------")
	Outfitter:DebugTable("vTankPointData", vTankPointData)
	
	Outfitter:TestMessage("------------------------------------------")
	return vTankPointData
end

function Outfitter.TankPoints_Reset(pTankPointData)
	pTankPointData.AdditionalStats = {}
end

function Outfitter.TankPoints_GetTotalStat(pTankPointData, pStat)
	local vTotalStat = pTankPointData.BaseStats[pStat]
	
	if not vTotalStat then
		vTotalStat = 0
	end
	
	local vAdditionalStat = pTankPointData.AdditionalStats[pStat]
	
	if vAdditionalStat then
		vTotalStat = vTotalStat + vAdditionalStat
	end
	
	local vBuffStat = pTankPointData.BuffStats[pStat]
	
	if vBuffStat then
		vTotalStat = vTotalStat + vBuffStat
	end
	
	--
	
	return vTotalStat
end

function Outfitter.TankPoints_CalcTankPoints(pTankPointData, pStanceModifier)
	if not pStanceModifier then
		pStanceModifier = 1
	end
	
	Outfitter:DebugTable("pTankPointData", pTankPointData)
	
	local vEffectiveArmor = Outfitter.TankPoints_GetTotalStat(pTankPointData, "Armor")
	
	Outfitter:TestMessage("Armor: "..vEffectiveArmor)
	
	local vArmorReduction = vEffectiveArmor / ((85 * pTankPointData.PlayerLevel) + 400)
	
	vArmorReduction = vArmorReduction / (vArmorReduction + 1)
	
	local vEffectiveHealth = Outfitter.TankPoints_GetTotalStat(pTankPointData, "Health")
	
	Outfitter:TestMessage("Health: "..vEffectiveHealth)
	
	Outfitter:TestMessage("Stamina: "..Outfitter.TankPoints_GetTotalStat(pTankPointData, "Stamina"))
	
	--
	
	local vEffectiveDodge = Outfitter.TankPoints_GetTotalStat(pTankPointData, "Dodge") * 0.01
	local vEffectiveParry = Outfitter.TankPoints_GetTotalStat(pTankPointData, "Parry") * 0.01
	local vEffectiveBlock = Outfitter.TankPoints_GetTotalStat(pTankPointData, "Block") * 0.01
	local vEffectiveDefense = Outfitter.TankPoints_GetTotalStat(pTankPointData, "Defense")
	
	-- Add agility and defense to dodge
	
	-- defenseInputBox:GetNumber() * 0.04 + agiInputBox:GetNumber() * 0.05

	Outfitter:TestMessage("Dodge: "..vEffectiveDodge)
	Outfitter:TestMessage("Parry: "..vEffectiveParry)
	Outfitter:TestMessage("Block: "..vEffectiveBlock)
	Outfitter:TestMessage("Defense: "..vEffectiveDefense)
	
	local vDefenseModifier = (vEffectiveDefense - pTankPointData.PlayerLevel * 5) * 0.04 * 0.01
	
	Outfitter:TestMessage("Crit reduction: "..vDefenseModifier)
	
	local vMobCrit = max(0, 0.05 - vDefenseModifier)
	local vMobMiss = 0.05 + vDefenseModifier
	local vMobDPS = 1
	
	local vTotalReduction = 1 - (vMobCrit * 2 + (1 - vMobCrit - vMobMiss - vEffectiveDodge - vEffectiveParry)) * (1 - vArmorReduction) * pStanceModifier
	
	Outfitter:TestMessage("Total reduction: "..vTotalReduction)
	
	local vTankPoints = vEffectiveHealth / (vMobDPS * (1 - vTotalReduction))
	
	return vTankPoints
	
	--[[
	Stats used in TankPoints calculation:
		Health
		Dodge
		Parry
		Block
		Defense
		Armor
	]]--
end

function Outfitter.TankPoints_GetCurrentOutfitStats(pStatDistribution)
	local vTotalStats = {}
	
	for _, vSlotName in ipairs(Outfitter.cSlotNames) do
		local vStats = Outfitter.ItemList_GetItemStats({SlotName = vSlotName})
		
		if vStats then
			Outfitter:TestMessage("--------- "..vSlotName)
			
			for vStat, vValue in pairs(vStats) do
				Outfitter.Stats_AddStatValue(vTotalStats, vStat, vValue)
			end
		end
	end
	
	return vTotalStats
end

function Outfitter.TankPoints_Test()
	local vStatDistribution = Outfitter:GetPlayerStatDistribution()
	
	local vTankPointData = Outfitter.TankPoints_New()
	local vStats = Outfitter.TankPoints_GetCurrentOutfitStats(vStatDistribution)
	
	Outfitter.Stats_AddStats(vTankPointData.AdditionalStats, vStats)
	
	local vTankPoints = Outfitter.TankPoints_CalcTankPoints(vTankPointData)
	
	Outfitter:TestMessage("TankPoints = "..vTankPoints)
end

function Outfitter:TestAmmoSlot()
	local vItemInfo = Outfitter:GetInventoryItemInfo("AmmoSlot")
	local vSlotID = Outfitter.cSlotIDs.AmmoSlot
	local vItemLink = GetInventoryItemLink("player", vSlotID)
	
	Outfitter:DebugTable("vItemInfo", vItemInfo)
	
	Outfitter:TestMessage("SlotID: "..vSlotID)
	Outfitter:TestMessage("ItemLink: "..vItemLink)
end

function Outfitter.GameToolTip_OnShow(...)
	MCEventLib:DispatchEvent("GAMETOOLTIP_SHOW")
end

function Outfitter.GameToolTip_OnHide(...)
	MCEventLib:DispatchEvent("GAMETOOLTIP_HIDE")
end

function Outfitter:OutfitUsesItem(pOutfit, pItemInfo)
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems(false)
	local vItemInfo, vItemInfo2
	
	if pItemInfo.ItemSlotName == "Finger0Slot" then
		vItemInfo = pOutfit.Items.Finger0Slot
		vItemInfo2 = pOutfit.Items.Finger1Slot
	elseif pItemInfo.ItemSlotName == "Trinket0Slot" then
		vItemInfo = pOutfit.Items.Trinket0Slot
		vItemInfo2 = pOutfit.Items.Trinket1Slot
	elseif pItemInfo.MetaSlotName == "Weapon0Slot" then
		vItemInfo = pOutfit.Items.MainHandSlot
		vItemInfo2 = pOutfit.Items.SecondaryHandSlot
	else
		vItemInfo = pOutfit.Items[pItemInfo.ItemSlotName]
	end
	
	return (vItemInfo and Outfitter.ItemList_ItemsAreSame(vEquippableItems, vItemInfo, pItemInfo))
	    or (vItemInfo2 and Outfitter.ItemList_ItemsAreSame(vEquippableItems, vItemInfo2, pItemInfo))
end

function Outfitter:GetOutfitsUsingItem(pItemInfo)
	local vFoundOutfits
	
	for vCategoryID, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for _, vOutfit in ipairs(vOutfits) do
			if Outfitter:OutfitUsesItem(vOutfit, pItemInfo) then
				if not vFoundOutfits then
					vFoundOutfits = {}
				end
				
				table.insert(vFoundOutfits, vOutfit)
			end
		end
	end
	
	return vFoundOutfits
end

function Outfitter:GetOutfitsListAsText(pOutfits)
	if not pOutfits
	or #pOutfits == 0 then
		return
	end
	
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	local vNames = nil
	
	for _, vOutfit in ipairs(pOutfits) do
		local vMissingItems, vBankedItems = Outfitter.ItemList_GetMissingItems(vEquippableItems, vOutfit)
		local vName
		
		if vOutfit.Disabled then
			vName = GRAY_FONT_COLOR_CODE
		elseif vMissingItems then
			vName = RED_FONT_COLOR_CODE
		elseif vBankedItems then
			vName = Outfitter.BANKED_FONT_COLOR_CODE
		else
			vName = NORMAL_FONT_COLOR_CODE
		end

		 vName = vName..vOutfit.Name..FONT_COLOR_CODE_CLOSE
		
		if vNames then
			vNames = vNames..", "..vName
		else
			vNames = vName
		end
	end
	
	return vNames
end

function Outfitter:AddOutfitsUsingItemToTooltip(pTooltip, pPrefix, pItemInfo)
	local vOutfitListString
	
	if Outfitter.OutfitInfoCache.OutfitsUsingItem
	and Outfitter.OutfitInfoCache.OutfitsUsingItem.Link
	and Outfitter.OutfitInfoCache.OutfitsUsingItem.Link == pItemInfo.Link then
		vOutfitListString = Outfitter.OutfitInfoCache.OutfitsUsingItem.String
	else
		local vOutfits = Outfitter:GetOutfitsUsingItem(pItemInfo)
		
		if vOutfits then
			vOutfitListString = Outfitter:GetOutfitsListAsText(vOutfits)
		end
		
		-- Update the cache
		
		if pItemInfo.Link then
			if not Outfitter.OutfitInfoCache.OutfitsUsingItem then
				Outfitter.OutfitInfoCache.OutfitsUsingItem = {}
			end
			
			Outfitter.OutfitInfoCache.OutfitsUsingItem.Link = pItemInfo.Link
			Outfitter.OutfitInfoCache.OutfitsUsingItem.String = vOutfitListString
		end
	end
	
	--
	
	if vOutfitListString then
		GameTooltip:AddLine(pPrefix..vOutfitListString, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
		GameTooltip:Show()
	end
end

function Outfitter.GameTooltip_SetBagItem(pTooltip, pBag, pSlot, ...)
	local vResult = {pTooltip:Outfitter_OrigSetBagItem(pBag, pSlot, ...)}
	
	if not gOutfitter_Settings.Options.DisableToolTipInfo then
		local vItemInfo = Outfitter:GetBagItemInfo(pBag, pSlot)
		
		if vItemInfo then
			Outfitter:AddOutfitsUsingItemToTooltip(pTooltip, Outfitter.cUsedByPrefix, vItemInfo)
		end
	end
	
	return unpack(vResult)
end

function Outfitter.GameTooltip_SetInventoryItem(pTooltip, pUnit, pSlot, pNameOnly, ...)
	local vResult = {pTooltip:Outfitter_OrigSetInventoryItem(pUnit, pSlot, pNameOnly, ...)}
	
	-- Add the list of outfits the item is used by
	
	if not gOutfitter_Settings.Options.DisableToolTipInfo
	and UnitIsUnit(pUnit, "player") then
		local vItemLink = Outfitter:GetInventorySlotIDLink(pSlot)
		local vItemInfo = Outfitter:GetItemInfoFromLink(vItemLink)
		
		if vItemInfo then
			Outfitter:AddOutfitsUsingItemToTooltip(pTooltip, Outfitter.cUsedByPrefix, vItemInfo)
		end
	end
	
	return unpack(vResult)
end

function Outfitter:InitializeFrameMethods(pFrame, pMethods)
	if pMethods then
		for vMethodField, vMethodFunction in pairs(pMethods) do
			pFrame[vMethodField] = vMethodFunction
		end
	end
end

function Outfitter:InitializeFrameWidgets(pFrame, pWidgets)
	if pWidgets then
		local vFrameName = pFrame:GetName()
		
		for _, vWidgetName in pairs(pWidgets) do
			if string.sub(vWidgetName, -1) == "*" then
				vWidgetName = string.sub(vWidgetName, 1, -2)
				
				pFrame[vWidgetName] = {ParentFrame = getglobal(vFrameName..vWidgetName)}
				
				local vIndex = 1
				
				while true do
					local vWidget = getglobal(vFrameName..vWidgetName..vIndex)
					
					if not vWidget then
						break
					end
					
					vWidget:SetID(vIndex)
					table.insert(pFrame[vWidgetName], vWidget)
					
					vIndex = vIndex + 1
				end
			else
				pFrame[vWidgetName] = getglobal(vFrameName..vWidgetName)
			end
		end
	end
end

Outfitter.OpenDialogs = {}

function Outfitter:DialogOpened(pDialog)
	-- Make sure it isn't already open
	
	for _, vDialog in ipairs(self.OpenDialogs) do
		if vDialog == pDialog then
			return
		end
	end
	
	table.insert(self.OpenDialogs, pDialog)
end

function Outfitter:DialogClosed(pDialog)
	for vIndex, vDialog in ipairs(self.OpenDialogs) do
		if vDialog == pDialog then
			table.remove(self.OpenDialogs, vIndex)
			return
		end
	end
	
	Outfitter:ErrorMessage("DialogClosed called on an unknown dialog: "..pDialog:GetName())
end

function Outfitter.StaticPopup_EscapePressed()
	local vClosed = Outfitter.OriginalStaticPopup_EscapePressed()
	local vNumDialogs = #self.OpenDialogs
	
	for vIndex = 1, vNumDialogs do
		local vDialog = self.OpenDialogs[1]
		vDialog:Cancel()
		vClosed = 1
	end
	
	return vClosed
end

function Outfitter:TooltipContainsLine(pTooltip, pText)
	local vTooltipName = pTooltip:GetName()
	
	for vLine = 1, 30 do
		local vText = getglobal(vTooltipName.."TextLeft"..vLine)
		
		if not vText then
			return false
		end
		
		local vTextString = vText:GetText()
		
		if not vTextString then
			return false
		end
		
		if string.find(vTextString, pText) then
			local vColor = {}
			
			vColor.r, vColor.g, vColor.b = vText:GetTextColor()
			
			local vHSVColor = Outfitter:RGBToHSV(vColor)
			
			return true, vHSVColor.s > 0.2 and vHSVColor.v > 0.2 and (vHSVColor.h < 50 or vHSVColor.h > 150)
		end
	end
end

function Outfitter:RecycleTable(pTable)
	if not pTable then
		return {}
	else
		Outfitter:EraseTable(pTable)
		return pTable
	end
end

function Outfitter:EraseTable(pTable)
	for vKey in pairs(pTable) do
		pTable[vKey] = nil
	end
end

function Outfitter:RGBToHSV(pRGBColor)
	local vHSVColor = {}
	local vBaseAngle
	local vHueColor
	
	if not pRGBColor.r
	or not pRGBColor.g
	or not pRGBColor.b then
		vHSVColor.h = 0
		vHSVColor.s = 0
		vHSVColor.v = 1
		
		return vHSVColor
	end
	
	if pRGBColor.r >= pRGBColor.g
	and pRGBColor.r >= pRGBColor.b then
		-- Red is dominant
		
		vHSVColor.v = pRGBColor.r
		
		vBaseAngle = 0
		
		if pRGBColor.g >= pRGBColor.b then
			vHSVColor.s = 1 - pRGBColor.b
			vHueColor = pRGBColor.g
		else
			vHSVColor.s = 1 - pRGBColor.g
			vHueColor = -pRGBColor.b
		end
	elseif pRGBColor.g >= pRGBColor.b then
		-- Green is dominant

		vHSVColor.v = pRGBColor.g

		vBaseAngle = 120
		
		if pRGBColor.r >= pRGBColor.b then
			vHSVColor.s = 1 - pRGBColor.b
			vHueColor = -pRGBColor.r
		else
			vHSVColor.s = 1 - pRGBColor.r
			vHueColor = pRGBColor.b
		end
	else
		-- Blue is dominant
		
		vHSVColor.v = pRGBColor.b

		vBaseAngle = 240
		
		if pRGBColor.r >= pRGBColor.g then
			vHSVColor.s = 1 - pRGBColor.g
			vHueColor = pRGBColor.r
		else
			vHSVColor.s = 1 - pRGBColor.r
			vHueColor = -pRGBColor.g
		end
	end
	
	vHSVColor.h = vBaseAngle + (vHueColor / vHSVColor.v) * 60
	
	if vHSVColor.h < 0 then
		vHSVColor.h = vHSVColor.h + 360
	end
	
	return vHSVColor
end

function Outfitter:FrameEditBox(pEditBox)
	local vLeftTexture = pEditBox:CreateTexture(nil, "ARTWORK")
	
	vLeftTexture:SetWidth(12)
	vLeftTexture:SetPoint("TOPLEFT", pEditBox, "TOPLEFT", -11, 0)
	vLeftTexture:SetPoint("BOTTOMLEFT", pEditBox, "BOTTOMLEFT", -11, -9)
	vLeftTexture:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-FilterBorder")
	vLeftTexture:SetTexCoord(0, 0.09375, 0, 1)
	
	local vRightTexture = pEditBox:CreateTexture(nil, "ARTWORK")
	
	vRightTexture:SetWidth(12)
	vRightTexture:SetPoint("TOPRIGHT", pEditBox, "TOPRIGHT", -12, 0)
	vRightTexture:SetPoint("BOTTOMRIGHT", pEditBox, "BOTTOMRIGHT", -12, -9)
	vRightTexture:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-FilterBorder")
	vRightTexture:SetTexCoord(0.90625, 1, 0, 1)
	
	local vMiddleTexture = pEditBox:CreateTexture(nil, "ARTWORK")
	
	vMiddleTexture:SetPoint("TOPLEFT", vLeftTexture, "TOPRIGHT")
	vMiddleTexture:SetPoint("BOTTOMLEFT", vLeftTexture, "BOTTOMRIGHT")
	vMiddleTexture:SetPoint("TOPRIGHT", vRightTexture, "TOPLEFT")
	vMiddleTexture:SetPoint("BOTTOMRIGHT", vRightTexture, "BOTTOMLEFT")
	vMiddleTexture:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-FilterBorder")
	vMiddleTexture:SetTexCoord(0.09375, 0.90625, 0, 1)
end

function Outfitter:NewObject(pMethods, ...)
	local vObject
	
	if pMethods.New then
		vObject = pMethods:New(...)
	else
		vObject = {}
	end
	
	for vIndex, vValue in pairs(pMethods) do
		vObject[vIndex] = vValue
	end
	
	if vObject.Construct then
		vObject:Construct(...)
	end
	
	return vObject
end

function Outfitter:ConstructFrame(pFrame, pMethods, ...)
	for vKey, vValue in pairs(pMethods) do
		if vKey == "Widgets" and type(vValue) == "table" then
			if not pFrame.Widgets then
				pFrame.Widgets = {}
			end
			
			local vNamePrefix
			
			if pFrame.GetName then
				vNamePrefix = pFrame:GetName()
			else
				vNamePrefix = vValue._Prefix
			end
			
			if vNamePrefix then
				for _, vName in ipairs(vValue) do
					local vWidget = getglobal(vNamePrefix..vName)
					
					if vWidget == nil then
						self:ErrorMessage("Couldn't find global "..vNamePrefix..vName)
					else
						pFrame.Widgets[vName] = vWidget
					end
				end
			else
				Outfitter:ErrorMessage("ConstructFrame: Can't initialize widgets for frame because there's no name prefix")
				Outfitter:DebugStack()
			end
		else
			pFrame[vKey] = vValue
		end
	end
	
	if pMethods.Construct then
		pFrame:Construct(...)
	end
	
	return pFrame
end

function Outfitter.InitializeFrame(pObject, ...)
	if not pObject then
		Outfitter:DebugMessage("InitializeFrame called with nil object")
		Outfitter:DebugStack()
		return
	end
	
	local vNumClasses = select("#", ...)
	
	for vIndex = 1, vNumClasses do
		local vFunctionTable = select(vIndex, ...)
		
		for vFunctionName, vFunction in pairs(vFunctionTable) do
			if type(vFunction) == "table" then
				local vTable = {}
				
				pObject[vFunctionName] = vTable
				
				local vNamePrefix
				
				if pObject.GetName then
					vNamePrefix = pObject:GetName()
				else
					vNamePrefix = pObject[vFunctionName.."Prefix"]
				end
				
				for _, vName in ipairs(vFunction) do
					local vValue = getglobal(vNamePrefix..vName)
					
					if vValue == nil then
						self:ErrorMessage("Couldn't find global "..vNamePrefix..vName)
					else
						vTable[vName] = vValue
					end
				end
			else
				pObject[vFunctionName] = vFunction
			end
		end
	end
end

function Outfitter.HookScript(pFrame, pScriptID, pFunction)
	if not pFrame:GetScript(pScriptID) then
		pFrame:SetScript(pScriptID, pFunction)
	else
		pFrame:HookScript(pScriptID, pFunction)
	end
end

function Outfitter.SetFrameLevel(pFrame, pLevel)
	pFrame:SetFrameLevel(pLevel)
	
	local	vChildren = {pFrame:GetChildren()}
	
	for _, vChildFrame in pairs(vChildren) do
		Outfitter.SetFrameLevel(vChildFrame, pLevel + 1)
	end
end

function Outfitter.SetFrameStrata(pFrame, pStrata)
	pFrame:SetFrameStrata(pStrata)
	
	local vChildren = {pFrame:GetChildren()}
	
	for _, vChildFrame in pairs(vChildren) do
		Outfitter.SetFrameStrata(vChildFrame, pStrata)
	end
end

function Outfitter:BeginMenu(pMenu)
	table.insert(UIMenus, pMenu:GetName())
end

function Outfitter:EndMenu(pMenu)
	local vName = pMenu:GetName()
	
	for vIndex = #UIMenus, 1, -1 do
		if vName == UIMenus[vIndex] then
			table.remove(UIMenus, vIndex)
			break
		end
	end
end

function Outfitter:FrameMouseDown(pFrame)
	-- Note the position in case the user decides to drag
	
	if not pFrame.DraggingInfo then
		pFrame.DraggingInfo = {}
	end
	
	pFrame.DraggingInfo.CursorStartX, pFrame.DraggingInfo.CursorStartY = GetCursorPosition()
end
	
function Outfitter:StartMovingFrame(pFrame)
	if not pFrame.DraggingInfo then
		return
	end
	
	pFrame.DraggingInfo.StartX = pFrame:GetLeft() * pFrame:GetEffectiveScale()
	pFrame.DraggingInfo.StartY = pFrame:GetTop() * pFrame:GetEffectiveScale() - UIParent:GetTop() * UIParent:GetEffectiveScale()

	MCSchedulerLib:ScheduleRepeatingTask(0, self.UpdateMovingFrame, pFrame)
end

function Outfitter.UpdateMovingFrame(pFrame) -- Note this is not a method, just a function
	if not pFrame.DraggingInfo then
		Outfitter:FrameStopDragging(pFrame)
		return
	end
	
	-- Move the frame being dragged
	
	local vCursorX, vCursorY = GetCursorPosition()
	
	local vCursorDeltaX = vCursorX - pFrame.DraggingInfo.CursorStartX
	local vCursorDeltaY = vCursorY - pFrame.DraggingInfo.CursorStartY
	
	--
	
	local vPositionX = pFrame.DraggingInfo.StartX + vCursorDeltaX
	local vPositionY = pFrame.DraggingInfo.StartY + vCursorDeltaY
	
	if pFrame.DraggingInfo.PositionX ~= vPositionX
	or pFrame.DraggingInfo.PositionY ~= vPositionY then
		
		pFrame.DraggingInfo.PositionX = vPositionX
		pFrame.DraggingInfo.PositionY = vPositionY
		
		pFrame:ClearAllPoints()
		pFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", vPositionX / pFrame:GetEffectiveScale(), vPositionY / pFrame:GetEffectiveScale())
	end
end

function Outfitter:StopMovingFrame(pFrame)
	MCSchedulerLib:UnscheduleTask(self.UpdateMovingFrame, pFrame)
end

function Outfitter:GetCurrentOutfitInfo()
	return self.OutfitStack:GetCurrentOutfitInfo()
end

----------------------------------------
-- Outfitter.OutfitStack
----------------------------------------

function Outfitter.OutfitStack:Initialize()
	self:RestoreSavedStack()
end

function Outfitter.OutfitStack:RestoreSavedStack()
	if not gOutfitter_Settings.LastOutfitStack then
		gOutfitter_Settings.LastOutfitStack = {}
	end
	
	for vIndex, vOutfit in ipairs(gOutfitter_Settings.LastOutfitStack) do
		if vOutfit.Name then
			vOutfit = Outfitter:FindOutfitByName(vOutfit.Name)
		end
		
		if vOutfit then
			table.insert(self.Outfits, vOutfit)
		end
	end
	
	Outfitter.ExpectedOutfit = Outfitter:GetCompiledOutfit()
	
	Outfitter:UpdateTemporaryOutfit(Outfitter:GetNewItemsOutfit(Outfitter.ExpectedOutfit))
	
	if gOutfitter_Settings.Options.ShowStackContents then
		self:DebugOutfitStack("Restore saved stack")
	end
end

function Outfitter.OutfitStack:AddOutfit(pOutfit, pLayerID)
	local vFound, vIndex = self:FindOutfit(pOutfit)
	
	-- If it's already on then remove it from the stack
	-- so it can be added to the end
	
	if vFound then
		table.remove(self.Outfits, vIndex)
		table.remove(gOutfitter_Settings.LastOutfitStack, vIndex)
		
		for vLayerID, vLayerIndex in pairs(gOutfitter_Settings.LayerIndex) do
			if vIndex < vLayerIndex then
				gOutfitter_Settings.LayerIndex[vLayerID] = vLayerIndex - 1
			end
		end
		
		Outfitter:DispatchOutfitEvent("UNWEAR_OUTFIT", pOutfit.Name, pOutfit)
	end
	
	-- Figure out the position to insert at
	
	local vStackLength = #self.Outfits
	local vInsertIndex = vStackLength + 1
	
	local vLayerIndex = gOutfitter_Settings.LayerIndex[pLayerID]
	
	if vLayerIndex then
		vInsertIndex = vLayerIndex
	end
	
	if pLayerID then
		gOutfitter_Settings.LayerIndex[pLayerID] = vInsertIndex
	end
	
	-- Adjust the layer indices
	
	for vLayerID, vLayerIndex in pairs(gOutfitter_Settings.LayerIndex) do
		if vInsertIndex < vLayerIndex then
			gOutfitter_Settings.LayerIndex[vLayerID] = vLayerIndex + 1
		end
	end
	
	-- Add the outfit
	
	table.insert(self.Outfits, vInsertIndex, pOutfit)
	
	if pOutfit.Name then
		table.insert(gOutfitter_Settings.LastOutfitStack, vInsertIndex, {Name = pOutfit.Name})
	else
		table.insert(gOutfitter_Settings.LastOutfitStack, vInsertIndex, pOutfit)
	end
	
	Outfitter.DisplayIsDirty = true
	
	if gOutfitter_Settings.Options.ShowStackContents then
		self:DebugOutfitStack("Add outfit")
	end
	
	if vFound then
		self:CollapseTemporaryOutfits()
	end
	
	Outfitter:DispatchOutfitEvent("WEAR_OUTFIT", pOutfit.Name, pOutfit)
end

function Outfitter.OutfitStack:RemoveOutfit(pOutfit)
	local vFound, vIndex = self:FindOutfit(pOutfit)
	
	if not vFound then
		return false
	end
	
	-- Remove the outfit
	
	table.remove(self.Outfits, vIndex)
	table.remove(gOutfitter_Settings.LastOutfitStack, vIndex)
	
	self:CollapseTemporaryOutfits()
			
	for vLayerID, vLayerIndex in pairs(gOutfitter_Settings.LayerIndex) do
		if vIndex < vLayerIndex then
			gOutfitter_Settings.LayerIndex[vLayerID] = vLayerIndex - 1
		end
	end
	
	Outfitter.DisplayIsDirty = true
	
	if gOutfitter_Settings.Options.ShowStackContents then
		self:DebugOutfitStack("Remove outfit")
	end
	
	return true
end

function Outfitter.OutfitStack:FindOutfit(pOutfit)
	for vIndex, vOutfit in ipairs(self.Outfits) do
		if vOutfit == pOutfit then
			return true, vIndex
		end
	end
	
	return false, nil
end

function Outfitter.OutfitStack:FindOutfitByCategory(pCategoryID)
	for vIndex, vOutfit in ipairs(self.Outfits) do
		if vOutfit.CategoryID == pCategoryID then
			return true, vIndex
		end
	end
	
	return false, nil
end

function Outfitter.OutfitStack:Clear()
	for vIndex, vOutfit in ipairs(self.Outfits) do
		Outfitter:DispatchOutfitEvent("UNWEAR_OUTFIT", vOutfit.Name, vOutfit)
	end
	
	Outfitter:EraseTable(self.Outfits)
	
	gOutfitter_Settings.LastOutfitStack = Outfitter:RecycleTable(gOutfitter_Settings.LastOutfitStack)
	gOutfitter_Settings.LayerIndex = Outfitter:RecycleTable(gOutfitter_Settings.LayerIndex)
	Outfitter.DisplayIsDirty = true
	
	if gOutfitter_Settings.Options.ShowStackContents then
		Outfitter:DebugMessage("Outfitter stack cleared")
	end
end

function Outfitter.OutfitStack:ClearCategory(pCategoryID)
	local vIndex = 1
	local vStackLength = #self.Outfits
	local vChanged = false
	
	while vIndex <= vStackLength do
		local vOutfit = self.Outfits[vIndex]
		
		if vOutfit
		and vOutfit.CategoryID == pCategoryID then
			-- Remove the outfit from the stack
			
			table.remove(self.Outfits, vIndex)
			table.remove(gOutfitter_Settings.LastOutfitStack, vIndex)
			
			vStackLength = vStackLength - 1
			vChanged = true
			
			-- Adjust the layer indices
			
			for vLayerID, vLayerIndex in pairs(gOutfitter_Settings.LayerIndex) do
				if vIndex < vLayerIndex then
					gOutfitter_Settings.LayerIndex[vLayerID] = vLayerIndex - 1
				end
			end
			
			Outfitter:DispatchOutfitEvent("UNWEAR_OUTFIT", vOutfit.Name, vOutfit)
		else
			vIndex = vIndex + 1
		end
	end
	
	self:CollapseTemporaryOutfits()
	
	if vChanged then
		if gOutfitter_Settings.Options.ShowStackContents then
			self:DebugOutfitStack("Clear category "..pCategoryID)
		end
		
		Outfitter.DisplayIsDirty = true
	end
end

function Outfitter.OutfitStack:GetTemporaryOutfit()
	local vStackSize = #self.Outfits
	
	if vStackSize == 0 then
		return nil
	end
	
	local vOutfit = self.Outfits[vStackSize]
	
	if vOutfit.Name then
		return nil
	end
	
	return vOutfit
end

function Outfitter.OutfitStack:CollapseTemporaryOutfits()
	local vIndex = 1
	local vStackLength = #self.Outfits
	local vTemporaryOutfit1 = nil
	
	while vIndex <= vStackLength do
		local vOutfit = self.Outfits[vIndex]
		
		if vOutfit
		and vOutfit.Name == nil then
			if vTemporaryOutfit1 then
				-- Copy the items up
				
				for vInventorySlot, vItem in pairs(vTemporaryOutfit1.Items) do
					if not vOutfit.Items[vInventorySlot] then
						vOutfit.Items[vInventorySlot] = vItem
					end
				end
				
				-- Remove the lower temp outfit
				
				table.remove(self.Outfits, vIndex - 1)
				vStackLength = vStackLength - 1
			else
				vIndex = vIndex + 1
			end
			
			vTemporaryOutfit1 = vOutfit
		else
			vTemporaryOutfit1 = nil
			vIndex = vIndex + 1
		end
	end
end

function Outfitter.OutfitStack:IsTopmostOutfit(pOutfit)
	local vStackLength = #self.Outfits
	
	if vStackLength == 0 then
		return false
	end
	
	return self.Outfits[vStackLength] == pOutfit
end

function Outfitter.OutfitStack:UpdateHelmAndCloakVisibility()
	local vShowHelm, vShowCloak
	
	for vIndex, vOutfit in ipairs(self.Outfits) do
		if vOutfit.ShowHelm ~= nil then
			vShowHelm = vOutfit.ShowHelm
		end
		if vOutfit.ShowCloak ~= nil then
			vShowCloak = vOutfit.ShowCloak
		end
	end -- for
	
	if vShowHelm == true then
		ShowHelm("1")
	elseif vShowHelm == false then
		ShowHelm("0")
	end
	
	if vShowCloak == true then
		ShowCloak("1")
	elseif vShowCloak == false then
		ShowCloak("0")
	end
end

function Outfitter:TagOutfitLayer(pOutfit, pLayerID)
	local vFound, vIndex = Outfitter.OutfitStack:FindOutfit(pOutfit)
	
	if not vFound then
		return
	end
	
	gOutfitter_Settings.LayerIndex[pLayerID] = vIndex
end

function Outfitter.OutfitStack:DebugOutfitStack(pOperation)
	Outfitter:DebugMessage("Outfitter Stack Contents: "..pOperation)
	
	for vIndex, vOutfit in ipairs(self.Outfits) do
		if vOutfit.Name then
			Outfitter:DebugMessage("Slot "..vIndex..": "..vOutfit.Name)
		else
			Outfitter:DebugMessage("Slot "..vIndex..": Temporaray outfit")
		end
	end
	
	Outfitter:DebugTable("LayerIndex", gOutfitter_Settings.LayerIndex)
end

function Outfitter.OutfitStack:GetCurrentOutfitInfo()
	local vStackLength = #self.Outfits
	
	if vStackLength == 0 then
		return "", nil
	end
	
	local vOutfit = self.Outfits[vStackLength]
	
	if vOutfit and vOutfit.Name then
		return vOutfit.Name, vOutfit
	else
		return Outfitter.cCustom, vOutfit
	end
end

----------------------------------------
Outfitter._ButtonBar = {}
----------------------------------------

function Outfitter._ButtonBar:Construct(pName, pNumColumns, pNumRows, pButtonMethods, pButtonTemplate)
	self.Name = pName
	self.NumColumns = 0
	self.NumRows = 0
	self.Buttons = {}
	self.BackgroundTextures = {}
	self.ButtonMethods = pButtonMethods
	self.ButtonTemplate = pButtonTemplate or "ItemButtonTemplate"
	
	self:SetFrameStrata("DIALOG")
	Outfitter.SetFrameLevel(self, 1)
	self:EnableMouse(true)
	
	self:SetDimensions(pNumColumns, pNumRows)
	self:SetParent(UIParent)
end

function Outfitter._ButtonBar:SetDimensions(pNumColumns, pNumRows)
	self.NumColumns = pNumColumns
	self.NumRows = pNumRows
	
	-- Allocate additional buttons if needed
	
	local vTotalButtons = pNumColumns * pNumRows
	
	for vIndex = #self.Buttons, vTotalButtons do
		local vButtonName = self.Name.."Button"..vIndex
		local vButton = CreateFrame("Button", vButtonName, self, self.ButtonTemplate)
		
		Outfitter.InitializeFrame(vButton, self.ButtonMethods)
		vButton:Construct()
		
		Outfitter.SetFrameLevel(vButton, self:GetFrameLevel() + 1)
		
		table.insert(self.Buttons, vButton)
	end
	
	-- Allocate additional textures if needed
	
	local vNumTexRows = self.NumRows + 1
	local vNumTexColumns = self.NumColumns + 1
	local vTotalTextures = vNumTexRows * vNumTexColumns
	
	for vIndex = #self.BackgroundTextures, vTotalTextures do
		local vTexture = self:CreateTexture(nil, "BACKGROUND")
		
		vTexture:SetTexture("Interface\\Addons\\Outfitter\\Textures\\QuickSlotsBackground")
		vTexture:SetHeight(Outfitter.Style.ButtonBar.BackgroundHeight)
		vTexture:Hide()
		
		table.insert(self.BackgroundTextures, vTexture)
	end
	
	self.NumTextures = vTotalTextures
	
	-- Link the buttons together
	
	local vButtonFrameLevel = self:GetFrameLevel() + 1
	
	local vButtonIndex = 1
	local vPrevRowFirstButton
	local vRowFirstButton
	
	for vRow = 1, self.NumRows do
		local vPrevButton
		local vRowFirstButton = self.Buttons[vButtonIndex]
		
		for vColumn = 1, self.NumColumns do
			local vButton = self.Buttons[vButtonIndex]
			
			vButton:ClearAllPoints()
			
			if vPrevButton then
				vButton:SetPoint("LEFT", vPrevButton, "LEFT", Outfitter.Style.ButtonBar.BackgroundWidth, 0)
			elseif vPrevRowFirstButton then
				vButton:SetPoint("TOP", vPrevRowFirstButton, "TOP", 0, -Outfitter.Style.ButtonBar.BackgroundHeight)
			else
				vButton:SetPoint("TOPLEFT", self, "TOPLEFT", 7, -6)
			end
			
			vButton:EnableMouse(true)
			vButton:SetFrameLevel(vButtonFrameLevel)
			vButton:Enable()
			
			vButton:Show()
			
			vPrevButton = vButton
			vButtonIndex = vButtonIndex + 1
		end
		
		vPrevRowFirstButton = vRowFirstButton
	end
	
	-- Hide unused buttons
	
	for vIndex = vButtonIndex, #self.Buttons do
		local vButton = self.Buttons[vIndex]
		
		vButton.Outfit = nil
		
		vButton:EnableMouse(false)
		vButton:Disable()
		vButton:Hide()
	end
	
	-- Set the textures and link them together
	
	local vTextureIndex = 1
	local vPrevRowFirstTexture
	local vRowFirstTexture
	
	local vTexVertCoord1 = Outfitter.Style.ButtonBar.BackgroundHeight0 / Outfitter.Style.ButtonBar.BackgroundTextureHeight
	local vTexVertCoord2 = (Outfitter.Style.ButtonBar.BackgroundHeight0 + Outfitter.Style.ButtonBar.BackgroundHeight) / Outfitter.Style.ButtonBar.BackgroundTextureHeight
	local vTexVertCoord3 = (Outfitter.Style.ButtonBar.BackgroundHeight0 + Outfitter.Style.ButtonBar.BackgroundHeight + Outfitter.Style.ButtonBar.BackgroundHeightN) / Outfitter.Style.ButtonBar.BackgroundTextureHeight
	
	local vTexHorizCoord1 = Outfitter.Style.ButtonBar.BackgroundWidth0 / Outfitter.Style.ButtonBar.BackgroundTextureWidth
	local vTexHorizCoord2 = (Outfitter.Style.ButtonBar.BackgroundWidth0 + Outfitter.Style.ButtonBar.BackgroundWidth) / Outfitter.Style.ButtonBar.BackgroundTextureWidth
	local vTexHorizCoord3 = (Outfitter.Style.ButtonBar.BackgroundWidth0 + Outfitter.Style.ButtonBar.BackgroundWidth + Outfitter.Style.ButtonBar.BackgroundWidthN) / Outfitter.Style.ButtonBar.BackgroundTextureWidth
	
	for vRow = 1, vNumTexRows do
		local vPrevTexture
		local vRowFirstTexture = self.BackgroundTextures[vTextureIndex]
		local vHeight, vTexTop, vTexBottom
		
		if vRow == 1 then
			vHeight = Outfitter.Style.ButtonBar.BackgroundHeight0
			vTexTop = 0
			vTexBottom = vTexVertCoord1
		elseif vRow == vNumTexRows then
			vHeight = Outfitter.Style.ButtonBar.BackgroundHeightN
			vTexTop = vTexVertCoord2
			vTexBottom = vTexVertCoord3
		else
			vHeight = Outfitter.Style.ButtonBar.BackgroundHeight
			vTexTop = vTexVertCoord1
			vTexBottom = vTexVertCoord2
		end
		
		for vColumn = 1, vNumTexColumns do
			local vTexture = self.BackgroundTextures[vTextureIndex]
			local vWidth, vTexLeft, vTexRight
			
			if vColumn == 1 then
				vWidth = Outfitter.Style.ButtonBar.BackgroundWidth0
				vTexLeft = 0
				vTexRight = vTexHorizCoord1
			elseif vColumn == vNumTexColumns then
				vWidth = Outfitter.Style.ButtonBar.BackgroundWidthN
				vTexLeft = vTexHorizCoord2
				vTexRight = vTexHorizCoord3
			else
				vWidth = Outfitter.Style.ButtonBar.BackgroundWidth
				vTexLeft = vTexHorizCoord1
				vTexRight = vTexHorizCoord2
			end
			
			vTexture:SetTexCoord(vTexLeft, vTexRight, vTexTop, vTexBottom)
			vTexture:SetHeight(vHeight)
			vTexture:SetWidth(vWidth)
			vTexture:ClearAllPoints()
			
			if vPrevTexture then
				vTexture:SetPoint("LEFT", vPrevTexture, "RIGHT")
			elseif vPrevRowFirstTexture then
				vTexture:SetPoint("TOP", vPrevRowFirstTexture, "BOTTOM")
			else
				vTexture:SetPoint("TOPLEFT", self, "TOPLEFT")
			end
			
			if not self.HideBackground then
				vTexture:Show()
			end
			
			vPrevTexture = vTexture
			vTextureIndex = vTextureIndex + 1
		end
		
		vPrevRowFirstTexture = vRowFirstTexture
	end
	
	-- Hide unused textures
	
	for vIndex = vTextureIndex, #self.BackgroundTextures do
		local vTexture = self.BackgroundTextures[vIndex]
		
		vTexture:ClearAllPoints()
		vTexture:Hide()
	end
	
	-- Resize the bar
	
	self:SetWidth(Outfitter.Style.ButtonBar.BackgroundWidth * (pNumColumns - 1) + Outfitter.Style.ButtonBar.BackgroundWidth0 + Outfitter.Style.ButtonBar.BackgroundWidthN)
	self:SetHeight(Outfitter.Style.ButtonBar.BackgroundHeight * (pNumRows - 1) + Outfitter.Style.ButtonBar.BackgroundHeight0 + Outfitter.Style.ButtonBar.BackgroundHeightN)
end

function Outfitter._ButtonBar:GetIndexedButton(pButtonIndex)
	local vNumButtons = self.NumColumns * self.NumRows
	
	if not pButtonIndex or pButtonIndex < 1 or pButtonIndex > vNumButtons then
		return
	end
	
	return self.Buttons[pButtonIndex]
end

function Outfitter._ButtonBar:ShowBackground(pShow)
	self.HideBackground = not pShow
	
	if self.HideBackground then
		for vIndex, vTexture in ipairs(self.BackgroundTextures) do
			if vIndex > self.NumTextures then
				break
			end
			
			vTexture:Hide()
		end
	else
		for vIndex, vTexture in ipairs(self.BackgroundTextures) do
			if vIndex > self.NumTextures then
				break
			end
			
			vTexture:Show()
		end
	end
end

----------------------------------------
Outfitter._SidebarWindowFrame = {}
----------------------------------------

function Outfitter._SidebarWindowFrame:Construct()
	-- Create the textures
	
	self.TopHeight = 80
	self.LeftWidth = 80
	self.BottomHeight = 183
	self.RightWidth = 94
	
	self.TopMargin = 13
	self.LeftMargin = 0
	self.BottomMargin = 3
	self.RightMargin = 1
	
	self.TextureWidth1 = 256
	self.TextureWidth2 = 128
	self.TextureUsedWidth2 = 94
	
	self.TextureHeight1 = 256
	self.TextureHeight2 = 256
	self.TextureUsedHeight2 = 183
	
	self.MiddleWidth1 = self.TextureWidth1 - self.LeftWidth
	self.MiddleWidth2 = 60
	
	self.TexCoordX1 = self.LeftWidth / self.TextureWidth1
	self.TexCoordX2 = (self.TextureUsedWidth2 - self.RightWidth) / self.TextureWidth2
	self.TexCoordX3 = self.TextureUsedWidth2 / self.TextureWidth2
	
	self.TexCoordY1 = self.TopHeight / self.TextureHeight1
	self.TexCoordY2 = (self.TextureUsedHeight2 - self.BottomHeight) / self.TextureHeight2
	self.TexCoordY3 = self.TextureUsedHeight2 / self.TextureHeight2
	
	self.Background = {}
	
	self.Background.TopRight = self:CreateTexture(nil, "BORDER")
	self.Background.TopRight:SetWidth(self.RightWidth)
	self.Background.TopRight:SetHeight(self.TopHeight)
	self.Background.TopRight:SetPoint("TOPRIGHT", self, "TOPRIGHT", self.RightMargin, self.TopMargin)
	self.Background.TopRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight")
	self.Background.TopRight:SetTexCoord(self.TexCoordX2, self.TexCoordX3, 0, self.TexCoordY1)
	
	self.Background.TopLeft = self:CreateTexture(nil, "BORDER")
	self.Background.TopLeft:SetHeight(self.TopHeight)
	self.Background.TopLeft:SetPoint("TOPLEFT", self, "TOPLEFT", -self.LeftMargin, self.TopMargin)
	self.Background.TopLeft:SetPoint("TOPRIGHT", self.Background.TopRight, "TOPLEFT")
	self.Background.TopLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
	self.Background.TopLeft:SetTexCoord(self.TexCoordX1, 1, 0, self.TexCoordY1)
	
	self.Background.BottomRight = self:CreateTexture(nil, "BORDER")
	self.Background.BottomRight:SetWidth(self.RightWidth)
	self.Background.BottomRight:SetHeight(self.BottomHeight)
	self.Background.BottomRight:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", self.RightMargin, -self.BottomMargin)
	self.Background.BottomRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
	self.Background.BottomRight:SetTexCoord(self.TexCoordX2, self.TexCoordX3, self.TexCoordY2, self.TexCoordY3)
	
	self.Background.BottomLeft = self:CreateTexture(nil, "BORDER")
	self.Background.BottomLeft:SetHeight(self.BottomHeight)
	self.Background.BottomLeft:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -self.LeftMargin, -self.BottomMargin)
	self.Background.BottomLeft:SetPoint("BOTTOMRIGHT", self.Background.BottomRight, "BOTTOMLEFT")
	self.Background.BottomLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft")
	self.Background.BottomLeft:SetTexCoord(self.TexCoordX1, 1, self.TexCoordY2, self.TexCoordY3)
	
	self.Background.RightMiddle = self:CreateTexture(nil, "BORDER")
	self.Background.RightMiddle:SetWidth(self.RightWidth)
	self.Background.RightMiddle:SetPoint("TOPRIGHT", self.Background.TopRight, "BOTTOMRIGHT")
	self.Background.RightMiddle:SetPoint("BOTTOMRIGHT", self.Background.BottomRight, "TOPRIGHT")
	self.Background.RightMiddle:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight")
	self.Background.RightMiddle:SetTexCoord(self.TexCoordX2, self.TexCoordX3, self.TexCoordY1, 1)
	
	self.Background.LeftMiddle = self:CreateTexture(nil, "BORDER")
	self.Background.LeftMiddle:SetPoint("TOPLEFT", self.Background.TopLeft, "BOTTOMLEFT")
	self.Background.LeftMiddle:SetPoint("BOTTOMLEFT", self.Background.BottomLeft, "TOPLEFT")
	self.Background.LeftMiddle:SetPoint("TOPRIGHT", self.Background.TopRight, "BOTTOMLEFT")
	self.Background.LeftMiddle:SetPoint("BOTTOMRIGHT", self.Background.BottomRight, "TOPLEFT")
	self.Background.LeftMiddle:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
	self.Background.LeftMiddle:SetTexCoord(self.TexCoordX1, 1, self.TexCoordY1, 1)
	
	self.Background.ShadowFrame = CreateFrame("Frame", nil, self)
	self.Background.ShadowFrame:SetWidth(16)
	self.Background.ShadowFrame:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.Background.ShadowFrame:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
	self.Background.ShadowFrame:SetFrameLevel(self:GetFrameLevel() + 20)
	
	self.Background.Shadow = self.Background.ShadowFrame:CreateTexture(nil, "OVERLAY")
	self.Background.Shadow:SetAllPoints()
	self.Background.Shadow:SetTexture(0, 0, 0, 1)
	self.Background.Shadow:SetGradientAlpha(
			"HORIZONTAL",
			1, 1, 1, 1,
			1, 1, 1, 0)
end

----------------------------------------
Outfitter._PortraitWindowFrame = {}
----------------------------------------

function Outfitter._PortraitWindowFrame:Construct()
	-- Create the textures
	
	self.TopHeight = 80
	self.LeftWidth = 80
	self.BottomHeight = 183
	self.RightWidth = 94
	
	self.TopMargin = 13
	self.LeftMargin = 12
	self.BottomMargin = 3
	self.RightMargin = 1
	
	self.TextureWidth1 = 256
	self.TextureWidth2 = 128
	self.TextureUsedWidth2 = 94
	
	self.TextureHeight1 = 256
	self.TextureHeight2 = 256
	self.TextureUsedHeight2 = 183
	
	self.MiddleWidth1 = self.TextureWidth1 - self.LeftWidth
	self.MiddleWidth2 = 60
	
	self.TexCoordX1 = self.LeftWidth / self.TextureWidth1
	self.TexCoordX2 = (self.TextureUsedWidth2 - self.RightWidth) / self.TextureWidth2
	self.TexCoordX3 = self.TextureUsedWidth2 / self.TextureWidth2
	
	self.TexCoordY1 = self.TopHeight / self.TextureHeight1
	self.TexCoordY2 = (self.TextureUsedHeight2 - self.BottomHeight) / self.TextureHeight2
	self.TexCoordY3 = self.TextureUsedHeight2 / self.TextureHeight2
	
	self.Background = {}
	
	-- Create the four corners first
	
	self.Background.TopLeft = self:CreateTexture(nil, "BORDER")
	self.Background.TopLeft:SetWidth(self.LeftWidth)
	self.Background.TopLeft:SetHeight(self.TopHeight)
	self.Background.TopLeft:SetPoint("TOPLEFT", self, "TOPLEFT", -self.LeftMargin, self.TopMargin)
	self.Background.TopLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
	self.Background.TopLeft:SetTexCoord(0, self.TexCoordX1, 0, self.TexCoordY1)
	
	self.Background.TopRight = self:CreateTexture(nil, "BORDER")
	self.Background.TopRight:SetWidth(self.RightWidth)
	self.Background.TopRight:SetHeight(self.TopHeight)
	self.Background.TopRight:SetPoint("TOPRIGHT", self, "TOPRIGHT", self.RightMargin, self.TopMargin)
	self.Background.TopRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight")
	self.Background.TopRight:SetTexCoord(self.TexCoordX2, self.TexCoordX3, 0, self.TexCoordY1)
	
	self.Background.BottomLeft = self:CreateTexture(nil, "BORDER")
	self.Background.BottomLeft:SetWidth(self.LeftWidth)
	self.Background.BottomLeft:SetHeight(self.BottomHeight)
	self.Background.BottomLeft:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -self.LeftMargin, -self.BottomMargin)
	self.Background.BottomLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft")
	self.Background.BottomLeft:SetTexCoord(0, self.TexCoordX1, self.TexCoordY2, self.TexCoordY3)
	
	self.Background.BottomRight = self:CreateTexture(nil, "BORDER")
	self.Background.BottomRight:SetWidth(self.RightWidth)
	self.Background.BottomRight:SetHeight(self.BottomHeight)
	self.Background.BottomRight:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", self.RightMargin, -self.BottomMargin)
	self.Background.BottomRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
	self.Background.BottomRight:SetTexCoord(self.TexCoordX2, self.TexCoordX3, self.TexCoordY2, self.TexCoordY3)
	
	self.Background.TopMiddle = self:CreateTexture(nil, "BORDER")
	self.Background.TopMiddle:SetHeight(self.TopHeight)
	self.Background.TopMiddle:SetPoint("TOPLEFT", self.Background.TopLeft, "TOPRIGHT")
	self.Background.TopMiddle:SetPoint("TOPRIGHT", self.Background.TopRight, "TOPLEFT")
	self.Background.TopMiddle:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
	self.Background.TopMiddle:SetTexCoord(self.TexCoordX1, 1, 0, self.TexCoordY1)
	
	self.Background.BottomMiddle = self:CreateTexture(nil, "BORDER")
	self.Background.BottomMiddle:SetHeight(self.BottomHeight)
	self.Background.BottomMiddle:SetPoint("TOPLEFT", self.Background.BottomLeft, "TOPRIGHT")
	self.Background.BottomMiddle:SetPoint("TOPRIGHT", self.Background.BottomRight, "TOPLEFT")
	self.Background.BottomMiddle:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft")
	self.Background.BottomMiddle:SetTexCoord(self.TexCoordX1, 1, self.TexCoordY2, self.TexCoordY3)
	
	self.Background.LeftMiddle = self:CreateTexture(nil, "BORDER")
	self.Background.LeftMiddle:SetWidth(self.LeftWidth)
	self.Background.LeftMiddle:SetPoint("TOPLEFT", self.Background.TopLeft, "BOTTOMLEFT")
	self.Background.LeftMiddle:SetPoint("BOTTOMLEFT", self.Background.BottomLeft, "TOPLEFT")
	self.Background.LeftMiddle:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
	self.Background.LeftMiddle:SetTexCoord(0, self.TexCoordX1, self.TexCoordY1, 1)
	
	self.Background.RightMiddle = self:CreateTexture(nil, "BORDER")
	self.Background.RightMiddle:SetWidth(self.RightWidth)
	self.Background.RightMiddle:SetPoint("TOPRIGHT", self.Background.TopRight, "BOTTOMRIGHT")
	self.Background.RightMiddle:SetPoint("BOTTOMRIGHT", self.Background.BottomRight, "TOPRIGHT")
	self.Background.RightMiddle:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight")
	self.Background.RightMiddle:SetTexCoord(self.TexCoordX2, self.TexCoordX3, self.TexCoordY1, 1)
	
	self.Background.Middle = self:CreateTexture(nil, "BORDER")
	self.Background.Middle:SetPoint("TOPLEFT", self.Background.TopLeft, "BOTTOMRIGHT")
	self.Background.Middle:SetPoint("TOPRIGHT", self.Background.TopRight, "BOTTOMLEFT")
	self.Background.Middle:SetPoint("BOTTOMLEFT", self.Background.BottomLeft, "TOPRIGHT")
	self.Background.Middle:SetPoint("BOTTOMRIGHT", self.Background.BottomRight, "TOPLEFT")
	self.Background.Middle:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
	self.Background.Middle:SetTexCoord(self.TexCoordX1, 1, self.TexCoordY1, 1)
	
	self.CloseButton = Outfitter:NewCloseButton(self)
	self.CloseButton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -3, -3)
end

function Outfitter:NewCloseButton(pParent)
	local vButton = CreateFrame("Button", nil, pParent)
	local vTexture
	
	vButton:SetWidth(17)
	vButton:SetHeight(17)
	
	local vTexture
	
	vButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	vTexture = vButton:GetNormalTexture()
	vTexture:SetTexCoord(0.1875, 0.78125, 0.21875, 0.78125)
	
	vButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	vTexture = vButton:GetPushedTexture()
	vTexture:SetTexCoord(0.1875, 0.78125, 0.21875, 0.78125)
	
	vButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
	vTexture = vButton:GetHighlightTexture()
	vTexture:SetTexCoord(0.1875, 0.78125, 0.21875, 0.78125)
	vTexture:SetBlendMode("ADD")
	
	return vButton
end

----------------------------------------
Outfitter._ScriptContext = {}
----------------------------------------

function Outfitter._ScriptContext:NewContext(pOutfit, pScript)
	local vFunction, vMessage = Outfitter:LoadOutfitScript(pScript)
	
	if not vFunction then
		return nil, vMessage
	end
	
	return Outfitter:NewObject(self, pOutfit, vFunction)
end

function Outfitter._ScriptContext:Construct(pOutfit, pFunction)
	self.Outfit = pOutfit
	self.Function = pFunction
	
	if not pFunction then
		Outfitter:ErrorMessage("Internal error: Attempting to create a script context with a nil function")
	end
end

function Outfitter._ScriptContext:RegisterEvent(pEventID)
	if pEventID == "OUTFIT_EQUIPPED"
	or pEventID == "OUTFIT_UNEQUIPPED" then
		if not Outfitter.OutfitScriptEvents[pEventID] then
			Outfitter.OutfitScriptEvents[pEventID] = {}
		end
		
		Outfitter.OutfitScriptEvents[pEventID][self.Outfit] = self
	else
		MCEventLib:RegisterEvent(pEventID, self.Function, self)
	end
end

function Outfitter._ScriptContext:UnregisterEvent(pEventID)
	if pEventID == "OUTFIT_EQUIPPED"
	or pEventID == "OUTFIT_UNEQUIPPED" then
		Outfitter.OutfitScriptEvents[pEventID][self.Outfit] = nil
	else
		MCEventLib:UnregisterEvent(pEventID, self.Function, self)
	end
end

function Outfitter._ScriptContext:UnregisterAllEvents(pEventID)
	for vEventID, vOutfits in pairs(Outfitter.OutfitScriptEvents) do
		vOutfits[self.Outfit] = nil
	end
	
	MCEventLib:UnregisterAllEvents(self.Function, self)
end

function Outfitter._ScriptContext:Debug(pFormat, ...)
	Outfitter:NoteMessage("["..self.Outfit.Name.."] "..pFormat, ...)
end

function Outfitter._ScriptContext:PostProcess(pEquip, pLayer, pDelay, pStartTime)
	-- If the script took a long time to run and it hasn't been very long since
	-- the last time we'll increment a counter.  If that counters gets too high
	-- we can assume the script is misbehaving and shut it down
	
	local vTime = GetTime()
	
	if vTime - pStartTime > 0.1
	and self.Outfit.LastScriptTime
	and pStartTime - self.LastScriptTime < 0.5 then
		if not self.ScriptLockupCount then
			self.ScriptLockupCount = 1
		else
			self.ScriptLockupCount = self.ScriptLockupCount + 1
			
			if self.ScriptLockupCount > 20 then
				Outfitter:ErrorMessage("Excessive CPU time in script for %s, script deactivated.", self.Outfit.Name or "<unnamed>")
				Outfitter:DeactivateScript(self.Outfit)
			end
		end
	else
		self.ScriptLockupCount = 0
	end
	
	self.LastScriptTime = pStartTime
	
	--
	
	if pEquip ~= nil then
		local vChanged
		
		Outfitter:BeginEquipmentUpdate()
		
		if pEquip then
			if not Outfitter:WearingOutfit(self.Outfit) then
				Outfitter:WearOutfit(self.Outfit, pLayer, true)
				vChanged = true
			end
		else
			if Outfitter:WearingOutfit(self.Outfit) then
				Outfitter:RemoveOutfit(self.Outfit, true)
				vChanged = true
			end
		end
		
		-- Adjust the last equipped time to cause a delay if requested
		
		if vChanged and pDelay then
			Outfitter:SetUpdateDelay(pStartTime, pDelay)
		end
		
		Outfitter:EndEquipmentUpdate()
	elseif pLayer then
		Outfitter:TagOutfitLayer(self.Outfit, pLayer)
	end
end

function Outfitter:SetUpdateDelay(pTime, pDelay)
	local vUpdateTime = pTime + (pDelay - self.cMinEquipmentUpdateInterval)

	if vUpdateTime > self.LastEquipmentUpdateTime then
		self.LastEquipmentUpdateTime = vUpdateTime
	end
end

function Outfitter:GetItemUseDuration(pInventorySlot)
	-- Set the tooltip
	
	OutfitterTooltip:SetOwner(OutfitterFrame, "ANCHOR_BOTTOMRIGHT", 0, 0)
	
	if not OutfitterTooltip:SetInventoryItem("player", Outfitter.cSlotIDs[pInventorySlot]) then
		OutfitterTooltip:Hide()
		return false
	end
	
	-- Scan for a "Use:" line
	
	for vLineIndex = 1, 100 do
		local vLeftTextFrame = getglobal("OutfitterTooltipTextLeft"..vLineIndex)
		
		if not vLeftTextFrame then
			break
		end
		
		local vLeftText = vLeftTextFrame:GetText()
		
		if vLeftText then
			local vStartIndex, vEndIndex, vSeconds = string.find(vLeftText, Outfitter.cUseDurationTooltipLineFormat)
			
			if not vSeconds then
				vStartIndex, vEndIndex, vSeconds = string.find(vLeftText, Outfitter.cUseDurationTooltipLineFormat2)
			end
			
			if vSeconds then
				OutfitterTooltip:Hide()
				return tonumber(vSeconds)
			end
		end
	end -- for vLineIndex
	
	OutfitterTooltip:Hide()
	return 0
end

Outfitter.cItemUseDuration = {}

function Outfitter:InventoryItemIsActive(pInventorySlot)
	-- See if the item is on cooldown at all
	
	local vSlotID = Outfitter.cSlotIDs[pInventorySlot]
	local vItemLink = Outfitter:GetInventorySlotIDLink(vSlotID)
	local vStartTime, vDuration, vEnable = GetItemCooldown(vItemLink)
	
	if not vStartTime or vStartTime == 0 then
		return false
	end
	
	-- Determine if there's an activity period for the item
	
	local vItemInfo = Outfitter:GetItemInfoFromLink(vItemLink)
	local vUseDuration
	
	if Outfitter.cItemUseDuration[vItemInfo.Code] then
		vUseDuration  = Outfitter.cItemUseDuration[vItemInfo.Code]
	else
		vUseDuration = Outfitter:GetItemUseDuration(pInventorySlot)
		
		if not vUseDuration then
			vUseDuration = 0
		end
		
		Outfitter.cItemUseDuration[vItemInfo.Code] = vUseDuration
	end
	
	-- If the time since started is less than the use duration the item is still active
	-- and shouldn't be unequipped
	
	return GetTime() < vStartTime + vUseDuration
end

function Outfitter_Hook()
	Outfitter_HookTable(_G, "_G")
end

function Outfitter_HookTable(pTable, pPrefix)
	for vKey, vValue in pairs(pTable) do
		if type(vKey) == "string"
		and type(vValue) == "function"
		and not string.find(vKey, "Outfitter") then
			pTable[vKey] = function (...)
				local vStartTime = GetTime()
				local vResult = {vValue(...)}
				local vEndTime = GetTime()
				if vEndTime - vStartTime > 0.1 then
					Outfitter:DebugMessage("Function %s.%s took %f seconds", pPrefix, vKey, vEndTime - vStartTime)
				end
				
				return unpack(vResult)
			end
		end
	end
end

function Outfitter:ShowAllLinks()
	for vCategory, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for _, vOutfit in ipairs(vOutfits) do
			for _, vItem in pairs(vOutfit.Items) do
				if vItem.Code ~= 0 then
					Outfitter:NoteMessage(Outfitter:GenerateItemLink(vItem))
				end
			end
		end
	end
end

function Outfitter:GenerateItemLink(pItem)
	if not pItem or pItem.Code == 0 then
		return nil
	end
	
	return string.format("|Hitem:%d:%d:%d:%d:%d:%d:%d:%d|h[%s]|h|r", pItem.Code, pItem.EnchantCode, pItem.JewelCode1, pItem.JewelCode2, pItem.JewelCode3, pItem.JewelCode4, pItem.SubCode, 0, pItem.Name)
end

function Outfitter:ShowMissingItems()
	if not Outfitter.BankFrameIsOpen then
		Outfitter:ErrorMessage(Outfitter.cMustBeAtBankError)
		return
	end
	
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems()
	local vFoundItems
	
	for vCategory, vOutfits in pairs(gOutfitter_Settings.Outfits) do
		for _, vOutfit in ipairs(vOutfits) do
			local vMissingItems = Outfitter.ItemList_GetMissingItems(vEquippableItems, vOutfit)
			
			if vMissingItems then
				for _, vItem in pairs(vMissingItems) do
					if not vFoundItems then
						Outfitter:NoteMessage(Outfitter.cMissingItemReportIntro)
						vFoundItems = true
					end
					
					Outfitter:NoteMessage(Outfitter:GenerateItemLink(vItem))
				end
			end
		end
	end
	
	if not vFoundItems then
		Outfitter:NoteMessage(Outfitter.cNoMissingItems)
	end
end

function Outfitter.CursorInFrame(pFrame)
	local vCursorX, vCursorY = GetCursorPosition()
	
	return Outfitter.PointInFrame(pFrame, vCursorX, vCursorY)
end

function Outfitter.PointInFrame(pFrame, pPointX, pPointY)
	local vLeft, vRight, vTop, vBottom = Outfitter.GetFrameEffectiveBounds(pFrame)
	
	return pPointX >= vLeft
	   and pPointX < vRight
	   and pPointY <= vTop
	   and pPointY > vBottom
end

function Outfitter.GetFrameEffectiveBounds(pFrame)
	local vEffectiveScale = pFrame:GetEffectiveScale()
	
	return pFrame:GetLeft() * vEffectiveScale,
	       pFrame:GetRight() * vEffectiveScale,
	       pFrame:GetTop() * vEffectiveScale,
	       pFrame:GetBottom() * vEffectiveScale
end
