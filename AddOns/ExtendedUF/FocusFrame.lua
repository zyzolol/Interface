MAX_FOCUS_DEBUFFS = 16;
MAX_FOCUS_BUFFS = 32;
FOCUS_BUFFS_PER_ROW = 8;
FOCUS_DEBUFFS_PER_ROW = 8;

function FocusFrame_OnLoad()
	this.statusCounter = 0;
	this.statusSign = -1;
	this.unitHPPercent = 1;

	this.buffStartX = 5;
	this.buffStartY = 32;
	this.buffSpacing = 3;

	FocusFrame_Update();
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_FOCUS_CHANGED");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_FACTION");
	this:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("PLAYER_FLAGS_CHANGED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("RAID_TARGET_UPDATE");

	local frameLevel = FocusFrameTextureFrame:GetFrameLevel();
	FocusFrameHealthBar:SetFrameLevel(frameLevel-1);
	FocusFrameManaBar:SetFrameLevel(frameLevel-1);
	FocusFrameSpellBar:SetFrameLevel(frameLevel-1);

	local showmenu = function()
		ToggleDropDownMenu(1, nil, FocusFrameDropDown, "FocusFrame", 120, 10);
	end
	SecureUnitButton_OnLoad(this, "focus", showmenu);
end

function FocusFrame_Update()
	if ( UnitExists("focus") ) then
		TargetofFocus_Update();

		UnitFrame_Update();
		FocusFrame_CheckLevel();
		FocusFrame_CheckFaction();
		FocusFrame_CheckClassification();
		FocusFrame_CheckDead();
		if ( UnitIsPartyLeader("focus") ) then
			FocusLeaderIcon:Show();
		else
			FocusLeaderIcon:Hide();
		end
		FocusDebuffButton_Update();
		FocusPortrait:SetAlpha(1.0);
	end
end

function FocusFrame_OnEvent(event)
	UnitFrame_OnEvent(event);

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		FocusFrame_Update();
	elseif ( event == "PLAYER_FOCUS_CHANGED" ) then
		FocusFrame_Update();
		FocusFrame_UpdateRaidTargetIcon();
		CloseDropDownMenus();
	elseif ( event == "UNIT_HEALTH" ) then
		if ( arg1 == "focus" ) then
			FocusFrame_CheckDead();
		end
	elseif ( event == "UNIT_LEVEL" ) then
		if ( arg1 == "focus" ) then
			FocusFrame_CheckLevel();
		end
	elseif ( event == "UNIT_FACTION" ) then
		if ( arg1 == "focus" or arg1 == "player" ) then
			FocusFrame_CheckFaction();
			FocusFrame_CheckLevel();
		end
	elseif ( event == "UNIT_CLASSIFICATION_CHANGED" ) then
		if ( arg1 == "focus" ) then
			FocusFrame_CheckClassification();
		end
	elseif ( event == "UNIT_AURA" ) then
		if ( arg1 == "focus" ) then
			FocusDebuffButton_Update();
		end
	elseif ( event == "PLAYER_FLAGS_CHANGED" ) then
		if ( arg1 == "focus" ) then
			if ( UnitIsPartyLeader("focus") ) then
				FocusLeaderIcon:Show();
			else
				FocusLeaderIcon:Hide();
			end
		end
	elseif ( event == "PARTY_MEMBERS_CHANGED" ) then
		TargetofFocus_Update();
		FocusFrame_CheckFaction();
	elseif ( event == "RAID_TARGET_UPDATE" ) then
		FocusFrame_UpdateRaidTargetIcon();
	end
end

function FocusFrame_OnHide()
	PlaySound("INTERFACESOUND_LOSTTARGETUNIT");
	CloseDropDownMenus();
end

function FocusFrame_CheckLevel()
	local targetLevel = UnitLevel("focus");
	
	if ( UnitIsCorpse("focus") ) then
		FocusLevelText:Hide();
		FocusHighLevelTexture:Show();
	elseif ( targetLevel > 0 ) then
		-- Normal level target
		FocusLevelText:SetText(targetLevel);
		-- Color level number
		if ( UnitCanAttack("player", "focus") ) then
			local color = GetDifficultyColor(targetLevel);
			FocusLevelText:SetVertexColor(color.r, color.g, color.b);
		else
			FocusLevelText:SetVertexColor(1.0, 0.82, 0.0);
		end
		FocusLevelText:Show();
		FocusHighLevelTexture:Hide();
	else
		-- Focus is too high level to tell
		FocusLevelText:Hide();
		FocusHighLevelTexture:Show();
	end
end

function FocusFrame_CheckFaction()
	if ( UnitPlayerControlled("focus") ) then
		local r, g, b;
		if ( UnitCanAttack("focus", "player") ) then
			-- Hostile players are red
			if ( not UnitCanAttack("player", "focus") ) then
				r = 0.0;
				g = 0.0;
				b = 1.0;
			else
				r = UnitReactionColor[2].r;
				g = UnitReactionColor[2].g;
				b = UnitReactionColor[2].b;
			end
		elseif ( UnitCanAttack("player", "focus") ) then
			-- Players we can attack but which are not hostile are yellow
			r = UnitReactionColor[4].r;
			g = UnitReactionColor[4].g;
			b = UnitReactionColor[4].b;
		elseif ( UnitIsPVP("focus") and not UnitIsPVPSanctuary("focus") and not UnitIsPVPSanctuary("player") ) then
			-- Players we can assist but are PvP flagged are green
			r = UnitReactionColor[6].r;
			g = UnitReactionColor[6].g;
			b = UnitReactionColor[6].b;
		else
			-- All other players are blue (the usual state on the "blue" server)
			r = 0.0;
			g = 0.0;
			b = 1.0;
		end
		FocusFrameNameBackground:SetVertexColor(r, g, b);
		FocusPortrait:SetVertexColor(1.0, 1.0, 1.0);
	elseif ( UnitIsTapped("focus") and not UnitIsTappedByPlayer("focus") ) then
		FocusFrameNameBackground:SetVertexColor(0.5, 0.5, 0.5);
		FocusPortrait:SetVertexColor(0.5, 0.5, 0.5);
	else
		local reaction = UnitReaction("focus", "player");
		if ( reaction ) then
			local r, g, b;
			r = UnitReactionColor[reaction].r;
			g = UnitReactionColor[reaction].g;
			b = UnitReactionColor[reaction].b;
			FocusFrameNameBackground:SetVertexColor(r, g, b);
		else
			FocusFrameNameBackground:SetVertexColor(0, 0, 1.0);
		end
		FocusPortrait:SetVertexColor(1.0, 1.0, 1.0);
	end

	local factionGroup = UnitFactionGroup("focus");
	if ( UnitIsPVPFreeForAll("focus") ) then
		FocusPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		FocusPVPIcon:Show();
	elseif ( factionGroup and UnitIsPVP("focus") ) then
		FocusPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		FocusPVPIcon:Show();
	else
		FocusPVPIcon:Hide();
	end
end

function FocusFrame_CheckClassification()
	local classification = UnitClassification("focus");
	if ( classification == "worldboss" ) then
		FocusFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
	elseif ( classification == "rareelite"  ) then
		FocusFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite");
	elseif ( classification == "elite"  ) then
		FocusFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
	elseif ( classification == "rare"  ) then
		FocusFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare");
	else
		FocusFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
	end
end

function FocusFrame_OnUpdate()
	if ( TargetofFocusFrame:IsShown() ~= UnitExists("focustarget") ) then
		TargetofFocus_Update();
	end
end

function FocusFrame_CheckDead()
	if ( (UnitHealth("focus") <= 0) and UnitIsConnected("focus") ) then
		FocusDeadText:Show();
	else
		FocusDeadText:Hide();
	end
end

function FocusDebuffButton_Update()
	local button;
	local name, rank, icon, count, duration, timeLeft;
	local buffCount;
	local numBuffs = 0;
	local largeBuffList = {};
	local playerIsFocus = UnitIsUnit("player", "focus");
	local cooldown, startCooldownTime;
	for i=1, MAX_FOCUS_BUFFS do
		name, rank, icon, count, duration, timeLeft = UnitBuff("focus", i);
		button = getglobal("FocusFrameBuff"..i);
		if ( not button ) then
			if ( not icon ) then
				break;
			else
				button = CreateFrame("Button", "FocusFrameBuff"..i, FocusFrame, "FocusBuffButtonTemplate");
				ExtendedUF:SetZoomedInButton("FocusFrameBuff"..i)
			end
		end
		
		if ( icon ) then
			getglobal("FocusFrameBuff"..i.."Icon"):SetTexture(icon);
			buffCount = getglobal("FocusFrameBuff"..i.."Count");
			button:Show();
			if ( count > 1 ) then
				buffCount:SetText(count);
				buffCount:Show();
			else
				buffCount:Hide();
			end
			
			-- Handle cooldowns
			cooldown = getglobal("FocusFrameBuff"..i.."Cooldown");
			if ( duration ) then
				if ( duration > 0 ) then
					cooldown:Show();
					startCooldownTime = GetTime()-(duration-timeLeft);
					CooldownFrame_SetTimer(cooldown, startCooldownTime, duration, 1);
				else
					cooldown:Hide();
				end
				
				-- Set the buff to be big if the buff is cast by the player and the focus is not the player
				if ( not playerIsFocus ) then
					largeBuffList[i] = 1;
				end
			else
				cooldown:Hide();
			end

			button.id = i;
			numBuffs = numBuffs + 1; 
			button:ClearAllPoints();
		else
			button:Hide();
		end
	end

	local debuffType, color;
	local debuffCount;
	local numDebuffs = 0;
	local largeDebuffList = {};
	for i=1, MAX_FOCUS_DEBUFFS do
		local debuffBorder = getglobal("FocusFrameDebuff"..i.."Border");
		name, rank, icon, count, debuffType, duration, timeLeft = UnitDebuff("focus", i);
		button = getglobal("FocusFrameDebuff"..i);
		if ( not button ) then
			if ( not icon ) then
				break;
			else
				button = CreateFrame("Button", "FocusFrameDebuff"..i, FocusFrame, "FocusDebuffButtonTemplate");
				debuffBorder = getglobal("FocusFrameDebuff"..i.."Border");
			end
		end
		if ( icon ) then
			getglobal("FocusFrameDebuff"..i.."Icon"):SetTexture(icon);
			debuffCount = getglobal("FocusFrameDebuff"..i.."Count");
			if ( debuffType ) then
				color = DebuffTypeColor[debuffType];
			else
				color = DebuffTypeColor["none"];
			end
			if ( count > 1 ) then
				debuffCount:SetText(count);
				debuffCount:Show();
			else
				debuffCount:Hide();
			end

			-- Handle cooldowns
			cooldown = getglobal("FocusFrameDebuff"..i.."Cooldown");
			if ( duration  ) then
				if ( duration > 0 ) then
					cooldown:Show();
					startCooldownTime = GetTime()-(duration-timeLeft);
					CooldownFrame_SetTimer(cooldown, startCooldownTime, duration, 1);
				else
					cooldown:Hide();
				end
				-- Set the buff to be big if the buff is cast by the player
				largeDebuffList[i] = 1;
			else
				cooldown:Hide();
			end
			
			debuffBorder:SetVertexColor(color.r, color.g, color.b);
			button:Show();
			numDebuffs = numDebuffs + 1;
			button:ClearAllPoints();
		else
			button:Hide();
		end
		button.id = i;
	end
	
	-- Figure out general information that affects buff sizing and positioning
	local numFirstRowBuffs;
	if ( TargetofFocusFrame:IsShown() ) then
		numFirstRowBuffs = 5;
	else
		numFirstRowBuffs = 6;
	end
		
	-- Reset number of buff rows
	FocusFrame.buffRows = 0;
	-- Position buffs
	local size;
	local previousWasPlayerCast;
	local offset;
	for i=1, numBuffs do
		if ( largeBuffList[i] ) then
			size = LARGE_BUFF_SIZE;
			offset = 3;
			previousWasPlayerCast = 1;
		else
			size = SMALL_BUFF_SIZE;
			offset = 3;
			if ( previousWasPlayerCast ) then
				offset = 6;
				previousWasPlayerCast = nil;
			end
		end
		FocusFrame_UpdateBuffAnchor("FocusFrameBuff", i, numFirstRowBuffs, numDebuffs, size, offset, TargetofFocusFrame:IsShown());
	end
	-- Position debuffs
	previousWasPlayerCast = nil;
	for i=1, numDebuffs do
		if ( largeDebuffList[i] ) then
			size = LARGE_BUFF_SIZE;
			offset = 4;
			previousWasPlayerCast = 1;
		else
			size = SMALL_BUFF_SIZE;
			offset = 4;
			if ( previousWasPlayerCast ) then
				offset = 6;
				previousWasPlayerCast = nil;
			end
		end
		FocusFrame_UpdateDebuffAnchor("FocusFrameDebuff", i, numFirstRowBuffs, numBuffs, size, offset, TargetofFocusFrame:IsShown());
	end

	-- update the spell bar position
	Focus_Spellbar_AdjustPosition();
end

function FocusFrame_UpdateBuffAnchor(buffName, index, numFirstRowBuffs, numDebuffs, buffSize, offset, hasTargetofFocus)
	local buff = getglobal(buffName..index);
	
	if ( index == 1 ) then
		if ( UnitIsFriend("player", "focus") ) then
			buff:SetPoint("TOPLEFT", FocusFrame, "BOTTOMLEFT", FocusFrame.buffStartX, FocusFrame.buffStartY);
		else
			if ( numDebuffs > 0 ) then
				buff:SetPoint("TOPLEFT", FocusFrameDebuffs, "BOTTOMLEFT", 0, -FocusFrame.buffSpacing);
			else
				buff:SetPoint("TOPLEFT", FocusFrame, "BOTTOMLEFT", FocusFrame.buffStartX, FocusFrame.buffStartY);
			end
		end
		FocusFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
		FocusFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		FocusFrame.buffRows = FocusFrame.buffRows+1;
	elseif ( index == (numFirstRowBuffs+1) ) then
		buff:SetPoint("TOPLEFT", getglobal(buffName..1), "BOTTOMLEFT", 0, -FocusFrame.buffSpacing);
		FocusFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		FocusFrame.buffRows = FocusFrame.buffRows+1;
	elseif ( hasTargetofFocus and index == (2*numFirstRowBuffs+1) ) then
		buff:SetPoint("TOPLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -FocusFrame.buffSpacing);
		FocusFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		FocusFrame.buffRows = FocusFrame.buffRows+1;
	elseif ( (index > numFirstRowBuffs) and (mod(index+(FOCUS_BUFFS_PER_ROW-numFirstRowBuffs), FOCUS_BUFFS_PER_ROW) == 1) and not hasTargetofFocus ) then
		-- Make a new row, have to take the number of buffs in the first row into account
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-FOCUS_BUFFS_PER_ROW)), "BOTTOMLEFT", 0, -FocusFrame.buffSpacing);
		FocusFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		FocusFrame.buffRows = FocusFrame.buffRows+1;
	else
		-- Just anchor to previous
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
	end

	-- Resize
	buff:SetWidth(buffSize);
	buff:SetHeight(buffSize);
end

function FocusFrame_UpdateDebuffAnchor(buffName, index, numFirstRowBuffs, numBuffs, buffSize, offset, hasTargetofFocus)
	local buff = getglobal(buffName..index);

	if ( index == 1 ) then
		if ( UnitIsFriend("player", "focus") and (numBuffs > 0) ) then
			buff:SetPoint("TOPLEFT", FocusFrameBuffs, "BOTTOMLEFT", 0, -FocusFrame.buffSpacing);
		else
			buff:SetPoint("TOPLEFT", FocusFrame, "BOTTOMLEFT", FocusFrame.buffStartX, FocusFrame.buffStartY);
		end
		FocusFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
		FocusFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		FocusFrame.buffRows = FocusFrame.buffRows+1;
	elseif ( index == (numFirstRowBuffs+1) ) then
		buff:SetPoint("TOPLEFT", getglobal(buffName..1), "BOTTOMLEFT", 0, -FocusFrame.buffSpacing);
		FocusFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		FocusFrame.buffRows = FocusFrame.buffRows+1;
	elseif ( hasTargetofFocus and index == (2*numFirstRowBuffs+1) ) then
		buff:SetPoint("TOPLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -FocusFrame.buffSpacing);
		FocusFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		FocusFrame.buffRows = FocusFrame.buffRows+1;
	elseif ( (index > numFirstRowBuffs) and (mod(index+(FOCUS_DEBUFFS_PER_ROW-numFirstRowBuffs), FOCUS_DEBUFFS_PER_ROW) == 1) and not hasTargetofFocus ) then
		-- Make a new row
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-FOCUS_DEBUFFS_PER_ROW)), "BOTTOMLEFT", 0, -FocusFrame.buffSpacing);
		FocusFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
		FocusFrame.buffRows = FocusFrame.buffRows+1;
	else
		-- Just anchor to previous
		buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
	end
	
	-- Resize
	buff:SetWidth(buffSize);
	buff:SetHeight(buffSize);
	local debuffFrame = getglobal(buffName..index.."Border");
	debuffFrame:SetWidth(buffSize+2);
	debuffFrame:SetHeight(buffSize+2);
end

function FocusFrame_HealthUpdate(elapsed, unit)
	if ( UnitIsPlayer(unit) ) then
		if ( (this.unitHPPercent > 0) and (this.unitHPPercent <= 0.2) ) then
			local alpha = 255;
			local counter = this.statusCounter + elapsed;
			local sign = this.statusSign;
	
			if ( counter > 0.5 ) then
				sign = -sign;
				this.statusSign = sign;
			end
			counter = mod(counter, 0.5);
			this.statusCounter = counter;
	
			if ( sign == 1 ) then
				alpha = (127  + (counter * 256)) / 255;
			else
				alpha = (255 - (counter * 256)) / 255;
			end
			FocusPortrait:SetAlpha(alpha);
		end
	end
end

function FocusHealthCheck()
	if ( UnitIsPlayer("focus") ) then
		local unitHPMin, unitHPMax, unitCurrHP;
		unitHPMin, unitHPMax = this:GetMinMaxValues();
		unitCurrHP = this:GetValue();
		this:GetParent().unitHPPercent = unitCurrHP / unitHPMax;
		if ( UnitIsDead("focus") ) then
			FocusPortrait:SetVertexColor(0.35, 0.35, 0.35, 1.0);
		elseif ( UnitIsGhost("focus") ) then
			FocusPortrait:SetVertexColor(0.2, 0.2, 0.75, 1.0);
		elseif ( (this:GetParent().unitHPPercent > 0) and (this:GetParent().unitHPPercent <= 0.2) ) then
			FocusPortrait:SetVertexColor(1.0, 0.0, 0.0);
		else
			FocusPortrait:SetVertexColor(1.0, 1.0, 1.0, 1.0);
		end
	end
end

function FocusFrameDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, FocusFrameDropDown_Initialize, "MENU");
end

function FocusFrameDropDown_Initialize()
	local menu;
	local name;
	local id = nil;
	if ( UnitIsUnit("focus", "player") ) then
		menu = "SELF";
	elseif ( UnitIsUnit("focus", "pet") ) then
		menu = "PET";
	elseif ( UnitIsPlayer("focus") ) then
		id = UnitInRaid("focus");
		if ( id ) then
			menu = "RAID_PLAYER";
			name = GetRaidRosterInfo(id +1);
		elseif ( UnitInParty("focus") ) then
			menu = "PARTY";
		else
			menu = "PLAYER";
		end
	else
		menu = "RAID_TARGET_ICON";
		name = RAID_TARGET_ICON;
	end
	if ( menu ) then
		UnitPopup_ShowMenu(FocusFrameDropDown, menu, "focus", name, id);
	end
end



-- Raid target icon function
function FocusFrame_UpdateRaidTargetIcon()
	local index = GetRaidTargetIndex("focus");
	if ( index ) then
		SetRaidTargetIconTexture(FocusRaidTargetIcon, index);
		FocusRaidTargetIcon:Show();
	else
		FocusRaidTargetIcon:Hide();
	end
end


function TargetofFocus_OnLoad()
	UnitFrame_Initialize("focustarget", TargetofFocusName, TargetofFocusPortrait, TargetofFocusHealthBar, TargetofFocusHealthBarText, TargetofFocusManaBar, TargetofFocusFrameManaBarText);
	SetTextStatusBarTextZeroText(TargetofFocusHealthBar, DEAD);
	this:RegisterEvent("UNIT_AURA");
	SecureUnitButton_OnLoad(this, "focustarget");
	RegisterUnitWatch(TargetofFocusFrame);  
end

function TargetofFocus_OnHide()
	FocusDebuffButton_Update();
end

function TargetofFocus_Update()
	if ( TargetofFocusFrame:IsShown() ) then
		UnitFrame_Update();
		TargetofFocus_CheckDead();
		TargetofFocusHealthCheck();
		RefreshBuffs(TargetofFocusFrame, 0, "focustarget");
	end
end

function TargetofFocus_CheckDead()
	if ( (UnitHealth("focustarget") <= 0) and UnitIsConnected("focustarget") ) then
		TargetofFocusBackground:SetAlpha(0.9);
		TargetofFocusDeadText:Show();
	else
		TargetofFocusBackground:SetAlpha(1);
		TargetofFocusDeadText:Hide();
	end
end

function TargetofFocusHealthCheck()
	if ( UnitIsPlayer("focustarget") ) then
		local unitHPMin, unitHPMax, unitCurrHP;
		unitHPMin, unitHPMax = TargetofFocusHealthBar:GetMinMaxValues();
		unitCurrHP = TargetofFocusHealthBar:GetValue();
		TargetofFocusFrame.unitHPPercent = unitCurrHP / unitHPMax;
		if ( UnitIsDead("focustarget") ) then
			TargetofFocusPortrait:SetVertexColor(0.35, 0.35, 0.35, 1.0);
		elseif ( UnitIsGhost("focustarget") ) then
			TargetofFocusPortrait:SetVertexColor(0.2, 0.2, 0.75, 1.0);
		elseif ( (TargetofFocusFrame.unitHPPercent > 0) and (TargetofFocusFrame.unitHPPercent <= 0.2) ) then
			TargetofFocusPortrait:SetVertexColor(1.0, 0.0, 0.0);
		else
			TargetofFocusPortrait:SetVertexColor(1.0, 1.0, 1.0, 1.0);
		end
	end
end


function SetFocusSpellbarAspect()
	local frameText = getglobal(FocusFrameSpellBar:GetName().."Text");
	if ( frameText ) then
		frameText:SetTextHeight(10);
		frameText:ClearAllPoints();
		frameText:SetPoint("TOP", FocusFrameSpellBar, "TOP", 0, 4);
	end

	local frameBorder = getglobal(FocusFrameSpellBar:GetName().."Border");
	if ( frameBorder ) then
		frameBorder:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small");
		frameBorder:SetWidth(197);
		frameBorder:SetHeight(49);
		frameBorder:ClearAllPoints();
		frameBorder:SetPoint("TOP", FocusFrameSpellBar, "TOP", 0, 20);
	end

	local frameFlash = getglobal(FocusFrameSpellBar:GetName().."Flash");
	if ( frameFlash ) then
		frameFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small");
		frameFlash:SetWidth(197);
		frameFlash:SetHeight(49);
		frameFlash:ClearAllPoints();
		frameFlash:SetPoint("TOP", FocusFrameSpellBar, "TOP", 0, 20);
	end
end

function Focus_Spellbar_OnLoad()
	this:RegisterEvent("PLAYER_FOCUS_CHANGED");

	CastingBarFrame_OnLoad("focus", false);

	local barIcon = getglobal(this:GetName().."Icon");
	barIcon:Show();
	
	SetFocusSpellbarAspect();
end

function Focus_Spellbar_OnEvent()
	local newevent = event;
	local newarg1 = arg1;
	--	Check for target specific events
	if ( event == "PLAYER_FOCUS_CHANGED" ) then
		-- check if the new target is casting a spell
		local nameChannel  = UnitChannelInfo(this.unit);
		local nameSpell  = UnitCastingInfo(this.unit);
		if ( nameChannel ) then
			newevent = "UNIT_SPELLCAST_CHANNEL_START";
			newarg1 = "focus";
		elseif ( nameSpell ) then
			newevent = "UNIT_SPELLCAST_START";
			newarg1 = "focus";
		else
			this.casting = nil;
			this.channeling = nil;
			this:SetMinMaxValues(0, 0);
			this:SetValue(0);
			this:Hide();
			return;
		end
		-- The position depends on the classification of the target
		Focus_Spellbar_AdjustPosition();
	end
	CastingBarFrame_OnEvent(newevent, newarg1);
end

function Focus_Spellbar_AdjustPosition()
	local yPos = 5;
	if ( FocusFrame.buffRows and FocusFrame.buffRows <= 2 ) then
		yPos = 38;
	elseif ( FocusFrame.buffRows ) then
		yPos = 19 * FocusFrame.buffRows;
	end
	if ( TargetofFocusFrame:IsShown() ) then
		if ( yPos <= 25 ) then
			yPos = yPos + 25;
		end
	else
		yPos = yPos - 5;
		local classification = UnitClassification("focus");
		if ( (yPos < 17) and ((classification == "worldboss") or (classification == "rareelite") or (classification == "elite") or (classification == "rare")) ) then
			yPos = 17;
		end
	end
	FocusFrameSpellBar:SetPoint("BOTTOM", "FocusFrame", "BOTTOM", -15, -yPos);
end
