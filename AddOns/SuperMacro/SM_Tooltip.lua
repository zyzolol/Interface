--SM_VARS.macroTip1 = 1; -- for spell, item
--SM_VARS.macroTip2 = 1; -- for macro code

SM_ITEM_PATTERN = "[%w '%-:]+";
SM_SPELL_PATTERN="[%w'%(%) %-:]+";

function SM_ActionButton_SetTooltip()
	local actionid=ActionButton_GetPagedID(this);
	local macroname=GetActionText(actionid) or getglobal(this:GetName().."Name"):GetText();

	if ( macroname ) then
		local macro, _, body = GetMacroInfo(macroname);
		
		-- for supermacros
		local superfound = SM_ACTION[this:GetName()];
		if ( superfound ) then
			macro,_,body=GetSuperMacroInfo(superfound);
			GameTooltipTextLeft1:SetText(macro);
			GameTooltip:Show();
		end
		if ( SM_VARS.macroTip1==1 ) then
			local actiontype, spell = SM_GetActionSpell(macro, superfound);
			if ( actiontype=="spell" ) then
				local id, book = SM_FindSpell(spell);
				if ( not GameTooltip:IsVisible() ) then
					if ( GetCVar("UberTooltips") == "1" ) then
						GameTooltip_SetDefaultAnchor(GameTooltip, this);
					else
						if ( this:GetParent() == MultiBarBottomRight or this:GetParent() == MultiBarRight or this:GetParent() == MultiBarLeft ) then
							GameTooltip:SetOwner(this, "ANCHOR_LEFT");
						else
							GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
						end
					end
				end
				GameTooltip:SetSpell(id, book);
				this.updateTooltip = TOOLTIP_UPDATE_TIME;
				local s, r = GetSpellName(id, book);
				if ( r ) then
					GameTooltipTextRight1:SetText("|cff00ffff"..r.."|r");
					GameTooltipTextRight1:Show();
					GameTooltip:Show();
				end
				return;
			elseif ( actiontype=="item" ) then
				local id, book = FindItem(spell);
				if ( book ) then
					GameTooltip:SetBagItem(id, book);
				elseif ( id ) then
					GameTooltip:SetInventoryItem( 'player', id);
				end
				this.updateTooltip = TOOLTIP_UPDATE_TIME;
				return;
			end
		end
		if ( SM_VARS.macroTip2 == 1 ) then
			-- show macro code
			if ( not GameTooltipTextLeft1:GetText() ) then
				if ( GetCVar("UberTooltips") == "1" ) then
					GameTooltip_SetDefaultAnchor(GameTooltip, this);
				else
					if ( this:GetParent() == MultiBarBottomRight or this:GetParent() == MultiBarRight or this:GetParent() == MultiBarLeft ) then
						GameTooltip:SetOwner(this, "ANCHOR_LEFT");
					else
						GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
					end
				end
				GameTooltip:SetText(" ");
				GameTooltip:Show();
			end
			body = gsub(body, "\n$", "");
			GameTooltip:AddLine(" ");
			GameTooltipTextLeft1:SetText( "|cff00ffff"..macro.."|r");
			GameTooltipTextLeft2:SetText("|cffffffff"..body.."|r");
			GameTooltipTextLeft1:SetWidth(min(GameTooltipTextLeft1:GetWidth(), 234));
			GameTooltipTextLeft2:SetWidth(min(GameTooltipTextLeft2:GetWidth(), 234));
			GameTooltipTextLeft2:SetNonSpaceWrap(true)
			GameTooltip:Show();
			return;
		end
	end
	
	-- show macro name if nothing shown
	if ( not GameTooltipTextLeft1:GetText() and macroname) then
		if ( GetCVar("UberTooltips") == "1" ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, this);
		else
			if ( this:GetParent() == MultiBarBottomRight or this:GetParent() == MultiBarRight or this:GetParent() == MultiBarLeft ) then
				GameTooltip:SetOwner(this, "ANCHOR_LEFT");
			else
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
			end
		end		GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE..macroname..FONT_COLOR_CODE_CLOSE);
		GameTooltip:Show();
	end
	
	-- brighten rank text on all tooltips
	if ( GameTooltipTextRight1:GetText() ) then
		local t = GameTooltipTextRight1:GetText();
		GameTooltipTextRight1:SetText("|cff00ffff"..t.."|r");
	end
	
	-- show crit info for Attack
	if ( GameTooltipTextLeft1:GetText()=="Attack" ) then
		id, book = FindSpell("Attack","");
		GameTooltip:SetSpell(id, book);
		GameTooltip:Show();
	end
end
hooksecurefunc("ActionButton_SetTooltip", SM_ActionButton_SetTooltip);

--[[
function SM_ActionButton_OnLeave()
	this.updateTooltip=nil;
	--GameTooltipTextLeft2:SetWidth(150);
	--GameTooltipTextLeft2:SetText("");
	GameTooltip:Hide();
end
--]]

function SM_ActionButton_OnUpdate(elapsed)
	-- limit memory use, update every 2 fps
	if elapsed < .0316 then
		return;
	end
	if ( SM_VARS.checkCooldown==1 ) then
		this.texture = nil;
		this.type, this.spell, this.book = nil, nil, nil;
		this.count = nil;

		local actionid = ActionButton_GetPagedID(this) or this:GetID();
		local action, macro = GetActionInfo(actionid);
		if ( not (action=="macro") ) then
			macro = GetActionText(actionid);
		end
		if ( macro ) then
			local name, icon, body = GetMacroInfo(macro);
			
			--  for supermacros
			local superfound = SM_ACTION[this:GetName()];
			if ( superfound ) then
				name,icon,body=GetSuperMacroInfo(superfound);
			end
			
			local macroname, pic, counttext;
			if ( this and this:GetName() ) then
				macroname=getglobal(this:GetName().."Name");
				if ( macroname ) then
					macroname:SetText(name);
				end
				pic=getglobal(this:GetName().."Icon");
				if ( pic ) then
					pic:SetTexture(icon);
				end
				counttext = getglobal(this:GetName().."Count");
				if ( counttext ) then
					counttext:SetText("");
					counttext:Show();
				end
			end

			local macrotype = "regular";
			if ( superfound ) then
				macrotype = "super";
			end
			local bag, slot, texture, spell, count = SM_UpdateActionSpell( name, macrotype, body);

			if ( texture and SM_VARS.replaceIcon==1 ) then
				this.texture = texture;
				if ( pic and icon~=texture ) then
					pic:SetTexture(texture);
				end
			end

			if ( spell and this ) then
				if ( not count ) then
					this.type, this.spell, this.book = "spell", bag, slot;
				else
					this.type, this.spell = "item", spell;
				end
			end
			this.count = count;
			if ( count and counttext ) then
				if ( count>=1 ) then
					counttext:SetText(count);
				elseif ( count==0 ) then
					counttext:SetText(0);
				end
			end
		end
	end
end
hooksecurefunc("ActionButton_OnUpdate", SM_ActionButton_OnUpdate);

oldGetActionCooldown = GetActionCooldown;
function GetActionCooldown( actionid )
	-- start, duration, enable
	local action, macro = GetActionInfo(actionid);
	if ( action=="macro" ) then
		if ( this and this.type ) then
			if ( this.type=="spell" ) then
				return GetSpellCooldown(this.spell, this.book);
			elseif ( this.type=="item" ) then
				return GetItemCooldown(this.spell);
			end
		end
	end
	return oldGetActionCooldown(actionid);
end

oldIsActionInRange = IsActionInRange;
function IsActionInRange(actionid)
	local action, macro = GetActionInfo(actionid);
	if ( action=="macro" ) then
		if ( this and this.type ) then
			if ( this.type=="spell" ) then
				return IsSpellInRange(this.spell, this.book);
			elseif ( this.type=="item" ) then
				return IsItemInRange(this.spell);
			end
		end
	end
	return oldIsActionInRange(actionid);
end

oldIsUsableAction = IsUsableAction;
function IsUsableAction(actionid)
	local action, macro = GetActionInfo(actionid);
	if ( action=="macro" ) then
		if ( this and this.type ) then
			if ( this.type=="spell" ) then
				return IsUsableSpell(this.spell, this.book);
			elseif ( this.type=="item" ) then
				return IsUsableItem(this.spell);
			end
		end
	end
	return oldIsUsableAction(actionid);
end

--[[ cannot hook
oldGetActionTexture = GetActionTexture;
function GetActionTexture(actionid)
	local action, macro = GetActionInfo(actionid);
	if ( action=="macro" ) then
		if ( this and this.texture ) then
			return this.texture;
		end
	end
	return oldGetActionTexture(actionid);
end
--]]

oldGetActionCount = GetActionCount;
function GetActionCount(actionid)
	local action, macro = GetActionInfo(actionid);
	if ( action=="macro" ) then
		if ( this and this.type=="item" ) then
			return GetItemCount(this.spell);
		end
	end
	return oldGetActionCount(actionid);
end

function ActionButton_UpdateCount()
	local text = getglobal(this:GetName().."Count");
	local action = ActionButton_GetPagedID(this);
	local count = GetActionCount(action);
	count = count == 0 and "" or count;
	text:SetText(count);
end

function FindFirstSpellOrItem( text )
	if not text then return nil end;
	local body = text;
	local id, book, texture, spell, count;
	for line in string.gmatch(body, "[^\n]+") do
		id, book, texture, spell, count = nil, nil, nil, nil, nil;
		if ( string.find(line,"^# *show ") or string.find(line,"^# *showtooltip ") ) then
			line = TrimSpaces(gsub(line,"^# *show *(.*)$", "%1"));
			line = TrimSpaces(gsub(line,"^# *showtooltip *(.*)$", "%1"));
			spell = line;
			if ( spell=="none") then
				return nil;
			end
			id, book = SM_FindSpell(spell);
			if ( id and book ) then
				texture = GetSpellTexture(id, book);
				break;
			end
			id, book, texture, count = FindItem(spell);
			if ( id ) then
				break;
			end
		end
		if ( string.find(line,"^/cast ") ) then
			line = gsub(line, "^/cast ", "");
			spell = SecureCmdOptionParse(line);
			id, book = SM_FindSpell(spell);
			if ( id and book ) then
				texture = GetSpellTexture(id, book);
				break;
			end
			id, book, texture, count = FindItem(spell);
			if ( id ) then
				break;
			end
		end
		if ( string.find(line,"^/castsequence ") ) then
			line = gsub(line, "^/castsequence ", "");
			local qindex, qitem, qspell = QueryCastSequence(line);
			if ( qitem ) then
				id, book, texture, count = FindItem(item);
				spell = qitem;
				break;
			end
			if ( qspell ) then
				id, book = SM_FindSpell(qspell);
				if ( id and book ) then
					texture = GetSpellTexture(id, book);
					spell = qspell;
					break;
				end
			end
		end
		local bag, slot, item;
		if ( strfind(line, '^/use ') ) then
			-- number means container or inventory slot
			gsub(line,'^/use +(%-?%d+)[,%s]*(%d*)', function(b,s)
				bag=tonumber(b);
				slot=tonumber(s);
			end );
			if ( not bag ) then
				-- not a number
				line = gsub(line, "^/use ", "");
				item = SecureCmdOptionParse(line) or "";				
				bag, slot, texture, count = FindItem(item);
				if ( bag ) then
					id, book, spell = bag, slot, item;
					break;
				end
				gsub(item,'(%-?%d+)[,%s]*(%d*)', function(b,s)
					bag=tonumber(b);
					slot=tonumber(s);
				end );
			end
			if ( bag and slot ) then
				texture, count = GetContainerItemInfo(bag, slot);
				item = ItemLinkToName(GetContainerItemLink(bag, slot));
			elseif ( (bag and bag>0 and bag<=23) ) then
				texture, count = GetInventoryItemTexture('player', bag), GetInventoryItemCount('player', bag);
				item = ItemLinkToName(GetInventoryItemLink('player', bag));
			end
			if ( item ) then
				id, book, spell = bag, slot, item;
				break;
			end
		end
		if ( strfind(line, "^/equip ") or strfind(line, "^/equipslot ") ) then
			local item = line;
			item = gsub(item, "^/equip +("..SM_ITEM_PATTERN..")%s*$", "%1");
			item = gsub(item, "^/equipslot +%d+ +("..SM_ITEM_PATTERN..")%s*$", "%1");
			bag, slot, texture, count = FindItem(item);
			if ( bag ) then
				id, book, spell = bag, slot, item;
				break;
			end
		end
		if ( strfind(line, "^/click ") ) then
			line = gsub(line, "^/click ", "");
			if ( strfind(line, "SuperMacroClick") ) then
				local macro = gsub(line, "SuperMacroClick", "");
				gsub(macro, "^_(.*)", function( name )
					id, book, texture, spell, count = FindFirstSpellOrItem( GetSuperMacroInfo( name, "body") );
				end);
				if ( id ) then break; end
				local name, texture, body = GetOrderedSuperMacroInfo( tonumber(macro) );
				return FindFirstSpellOrItem( body );
			elseif ( strfind(line, "MacroClick") ) then
				local macro = gsub(line, "MacroClick", "");
				gsub(macro, "^_(.*)", function( name )
					id, book, texture, spell, count = FindFirstSpellOrItem( GetMacroInfo( name, "body") );
				end);
				if ( id ) then break; end
				local name, texture, body = GetMacroInfo( tonumber(macro) );
				return FindFirstSpellOrItem( body );
			end
		end
	end
	return id, book, texture, spell, count;
end

--[[
function SM_EvalCastOptions(line)
	local retval = true;
	local retspell = "";
	local unit = "target";
	for section in gmatch(line, "[^;]+") do
		if ( not strfind(section, "%[") ) then
			-- no options
			return TrimSpaces(section);
		end
		local options = gsub(section, " *%[(.*)%] *.* *", "%1");
		options = strlower(options);
		retspell = TrimSpaces(gsub(section, " *%[.*%] *(.*) *", "%1"));
		retval = true; -- until proven false, then break
		-- go through every option separated by commas
		for option in gmatch(options, "[^,]+") do
			option = TrimSpaces(option);
			if (string.match(option, "target=%w+") ) then
				unit=gsub(option, "target=(%w+)", "%1");
			elseif (option == "combat" ) then
				if ( not UnitAffectingCombat("player") and not UnitAffectingCombat("pet") ) then
					retval = false;
					break;
				end
			elseif (option == "nocombat" ) then
				if ( UnitAffectingCombat("player") or UnitAffectingCombat("pet") ) then
					retval = false;
					break;
				end
			elseif (option == "exists" ) then
				if ( not UnitExists(unit) ) then
					retval = false;
					break;
				end
			elseif (option == "noexists" ) then
				if ( UnitExists(unit) ) then
					retval = false;
					break;
				end
			elseif (option == "help" ) then
				if ( not UnitCanAssist("player", unit) ) then
					retval = false;
					break;
				end
			elseif (option == "nohelp" ) then
				if ( UnitCanAssist("player", unit) ) then
					retval = false;
					break;
				end
			elseif (option == "harm" ) then
				if ( not UnitCanAttack("player", unit) ) then
					retval = false;
					break;
				end
			elseif (option == "noharm" ) then
				if ( UnitCanAttack("player", unit) ) then
					retval = false;
					break;
				end
			elseif (option == "party" ) then
				if ( not UnitPlayerOrPetInParty(unit) ) then
					retval = false;
					break;
				end
			elseif (option == "noparty" ) then
				if ( UnitPlayerOrPetInParty(unit) ) then
					retval = false;
					break;
				end
			elseif (option == "raid" ) then
				if ( not UnitPlayerOrPetInParty(unit) and not UnitPlayerOrPetInRaid(unit) ) then
					retval = false;
					break;
				end
			elseif (option == "noraid" ) then
				if ( UnitPlayerOrPetInParty(unit) or UnitPlayerOrPetInRaid(unit) ) then
					retval = false;
					break;
				end
			elseif (option == "dead" ) then
				if ( not UnitIsDead(unit) and not UnitIsGhost(unit) ) then
					retval = false;
					break;
				end
			elseif (option == "nodead" ) then
				if ( UnitIsDead(unit) or UnitIsGhost(unit) ) then
					retval = false;
					break;
				end
			elseif (option == "indoors" ) then
				if ( not IsIndoors() ) then
					retval = false;
					break;
				end
			elseif (option == "noindoors" ) then
				if ( IsIndoors() ) then
					retval = false;
					break;
				end
			elseif (option == "outdoors" ) then
				if ( not IsOutdoors() ) then
					retval = false;
					break;
				end
			elseif (option == "nooutdoors" ) then
				if ( IsOutdoors() ) then
					retval = false;
					break;
				end
			elseif (option == "swimming" ) then
				if ( not IsSwimming() ) then
					retval = false;
					break;
				end
			elseif (option == "noswimming" ) then
				if ( IsSwimming() ) then
					retval = false;
					break;
				end
			elseif (option == "flying" ) then
				if ( not IsFlying() ) then
					retval = false;
					break;
				end
			elseif (option == "noflying" ) then
				if ( IsFlying() ) then
					retval = false;
					break;
				end
			elseif (option == "mounted" ) then
				if ( not IsMounted() ) then
					retval = false;
					break;
				end
			elseif (option == "nomounted" ) then
				if ( IsMounted() ) then
					retval = false;
					break;
				end
			elseif (option == "stealth" ) then
				if ( not IsStealthed() ) then
					retval = false;
					break;
				end
			elseif (option == "nostealth" ) then
				if ( IsStealthed() ) then
					retval = false;
					break;
				end
			elseif (option == "group" ) then
				if ( (GetNumPartyMembers() < 1) and (GetNumRaidMembers() < 1) ) then
					retval = false;
					break;
				end
			elseif (option == "nogroup" ) then
				if ( (GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0) ) then
					retval = false;
					break;
				end
			elseif (string.match(option, "group:[%a/]+") ) then
				local group = TrimSpaces(gsub(option, "group:([%a/]+)", "%1"));
				local matched = false;
				for desired in gmatch(group, "[^/]+") do
					if ( desired == "party" ) then
						if ( GetNumPartyMembers() > 0 ) then
							matched = true;
							break;
						end
					elseif ( desired == "raid" ) then
						if ( GetNumRaidMembers() > 0 ) then
							matched = true;
							break;
						end
					end
				end
				if ( not matched ) then
					retval = false;
					break;
				end
			elseif (option == "stance" ) then
				local stance = false;
				for i = 1, GetNumShapeshiftForms() do
					local icon, name, active = GetShapeshiftFormInfo(i);
					if ( active ) then
						stance = true;
						break;
					end
				end
				if ( not stance ) then
					retval = false;
					break;
				end			
			elseif (option == "nostance" ) then
				local nostance = true;
				for i = 1, GetNumShapeshiftForms() do
					local icon, name, active = GetShapeshiftFormInfo(i);
					if ( active ) then
						nostance = false;
						break;
					end
				end
				if ( not nostance ) then
					retval = false;
					break;
				end
			elseif (string.match(option, "stance:[%d/]+") ) then
				local stance = TrimSpaces(gsub(option, "stance:([%d/]+)", "%1"));
				local matched = false;
				for id in gmatch(stance, "[^/]+") do
					local icon, name, active = GetShapeshiftFormInfo(id);
					if ( active ) then
						matched = true;
						break;
					end
				end
				if ( not matched ) then
					retval = false;
					break;
				end
			elseif (option == "pet" ) then
				if ( not UnitName("pet") ) then
					retval = false;
					break;
				end
			elseif (option == "nopet" ) then
				if ( UnitName("pet") ) then
					retval = false;
					break;
				end
			elseif (string.match(option, "pet:[%a /]+") ) then
				local pet = TrimSpaces(gsub(option, "pet:([%a /]+)", "%1"));
				local matched = false;
				if ( UnitExists("pet") ) then				
					local name = strlower(UnitName("pet"));
					local family = strlower(UnitCreatureFamily("pet"));
					for word in gmatch(pet, "[^/]+") do
						word = strlower(TrimSpaces(word));
						if ( name == word ) then
							matched = true;
							break;
						end
						if ( family == word ) then
							matched = true;
							break;
						end
					end
				end
				if ( not matched ) then
					retval = false;
					break;
				end
			elseif (option == "modifier" ) then
				if ( not IsModifierKeyDown() ) then
					retval = false;
					break;
				end
			elseif (option == "nomodifier" ) then
				if ( IsModifierKeyDown() ) then
					retval = false;
					break;
				end
			elseif (string.match(option, "modifier:[%a/]+") ) then
				local modifier = TrimSpaces(gsub(option, "modifier:([%a/]+)", "%1"));
				local matched = true;
				for word in gmatch(modifier, "[^/]+") do
					word = strlower(TrimSpaces(word));
					if ( word == "shift" ) then
						if ( not IsShiftKeyDown() ) then
							matched = false;
							break;
						end
					elseif ( word == "ctrl" ) then
						if ( not IsControlKeyDown() ) then
							matched = false;
							break;
						end
					elseif ( word == "alt" ) then
						if ( not IsAltKeyDown() ) then
							matched = false;
							break;
						end
					else
						matched = false;
						break;
					end
				end
				if ( not matched ) then
					retval = false;
					break;
				end
			elseif (string.match(option, "button:[%d/]+") ) then
				local button = TrimSpaces(gsub(option, "button:([%d/]+)", "%1"));
				local matched = true;
				local clickbutton = GetMouseButtonClicked();
				local macrobutton = GetRunningMacroButton();
				for id in gmatch(button, "[^/]+") do
					id = GetMouseButtonName(id);
					if ( id == clickbutton or id == macrobutton ) then
						match = true;
						break;
					end
				end
				if ( not matched ) then
					retval = false;
					break;
				end
			elseif (string.match(option, "actionbar:[%d/]+") ) then
				local actionbar = gsub(option, "actionbar:([%d/]+)", "%1");
				local matched = false;
				local currpage = GetActionBarPage();
				for page in gmatch(actionbar, "[^/]+") do
					if ( currpage == tonumber(page) ) then
						matched = true;
						break;
					end
				end
				if ( not matched ) then
					retval = false;
					break;
				end
			elseif (string.match(option, "equipped:") ) then
				local equipped = gsub(option, "equipped:(.*)", "%1");
				local matched = false;
				for itemtype in gmatch(equipped, "[^/]+") do
					if ( IsEquippedItemType(itemtype) ) then
						matched = true;
						break;
					end
				end
				if ( not matched ) then
					retval = false;
					break;
				end
			elseif ( option == "channeling" ) then
				if ( not UnitChannelInfo("player") ) then
					retval = false;
					break;
				end
			elseif ( option == "nochanneling" ) then
				if ( UnitChannelInfo("player") ) then
					retval = false;
					break;
				end
			elseif (string.match(option, "channeling:") ) then
				local channeling = gsub(option, "channeling:(.*)", "%1");
				local matched = false;
				local spell = UnitChannelInfo("player");
				if ( spell ) then
					spell = strlower(spell);
					for desired in gmatch(channeling, "[^/]+") do
						desired = strlower(desired);
						if ( desired == spell ) then
							matched = true;
							break;
						end
					end
				end
				if ( not matched ) then
					retval = false;
					break;
				end
			else
				-- invalid option default to false?
				retval = false;
				break;
			end
		end
		if ( retval ) then
			return retspell;
		end
	end
	return "";
end
--]]

-- FindFirstSpell obsolete?
--[[
function FindFirstSpell( text )
	if not text then return nil end;
	local body = text;
	if (ReplaceAlias and ASFOptions.aliasOn) then
		-- correct aliases
		body = ReplaceAlias(body);
	end
	local id, book, texture, spell;
	for line in string.gmatch(body, "[^\n]+") do
		if ( string.find(line,"^/cast") ) then
			-- single, simple [options]
			spell = gsub(line,'^/cast +%b[] *('..SM_SPELL_PATTERN..').*$','%1');
			if ( spell == line ) then
				spell = gsub(line,'^/cast +('..SM_SPELL_PATTERN..').*$','%1');
			end
			if ( spell ) then
				id, book = SM_FindSpell(spell);
				if ( id and book ) then
					texture = GetSpellTexture(id, book);
					break;
				end
				id, book, texture, count = FindItem(spell);
				if ( id ) then
					break;
				end
			end
		end
	end
	return id, book, texture, spell;
end
--]]

-- FindFirstItem obsolete?
--[[
function FindFirstItem( text )
	if not text then return nil end;
	local body = text;
	if (ReplaceAlias and ASFOptions.aliasOn) then
		-- correct aliases
		body = ReplaceAlias(body);
	end
	local bag, slot, texture, count, item;
	
	for line in string.gmatch(body, "[^\n]+") do
		if ( strfind(line, '^/use ') ) then
			-- number means container or inventory slot
			bag, slot = nil, nil;
			gsub(line,'^/use +(%d+)[,%s]*(%d*)', function(b,s)
				bag=tonumber(b);
				slot=tonumber(s);
			end );
			if ( bag and slot ) then
				texture, count = GetContainerItemInfo(bag, slot);
				item = ItemLinkToName(GetContainerItemLink(bag, slot));
			elseif ( (bag and bag>0 and bag<=23) ) then
				texture, count = GetInventoryItemTexture('player', bag), GetInventoryItemCount('player', bag);
				item = ItemLinkToName(GetInventoryItemLink('player', bag));
			else
				-- not a number
				item = gsub(line,'^/use +('..SM_ITEM_PATTERN..').*$', '%1');
				bag, slot, texture, count = FindItem(item);
			end
			if ( bag ) then
				break;
			end
		end
		if ( strfind(line, "UseInventoryItem") ) then
			bag = gsub(line,'^.-UseInventoryItem.-(%d+)%s-%).*$','%1');
			if ( bag~=line) then
				texture = GetInventoryItemTexture('player', bag);
				count = GetInventoryItemCount('player', bag);
			end
			if ( texture ) then
				item=ItemLinkToName( GetInventoryItemLink('player', bag) );
				break;
			end
			count=0;
		end
		if ( strfind(line, "UseContainerItem") ) then
			bag = gsub(line,'^.-UseContainerItem.-(%d+)%s-,%s-(%d+)%s-%).*$','%1');
			slot = gsub(line,'^.-UseContainerItem.-(%d+)%s-,%s-(%d+)%s-%).*$','%2');
			if ( bag~=line and slot~=line) then
				texture, count = GetContainerItemInfo(bag, slot);
			end
			if ( bag~=line and slot~=line and texture ) then
				item=ItemLinkToName( GetContainerItemLink(bag, slot) );
				break;
			end
			count=0;
		end
	end
	return bag, slot, texture, count, item;
end
--]]