function TargetofPartyHealthCheck()
	local prefix = this:GetParent():GetName();
	local unitHPMin, unitHPMax = this:GetMinMaxValues();	
	local unitCurrHP = this:GetValue();
	this:GetParent().unitHPPercent = unitCurrHP / unitHPMax;
	if ( UnitIsDead("party"..this:GetParent():GetID().."target") ) then
		getglobal(prefix.."Portrait"):SetVertexColor(0.35, 0.35, 0.35, 1.0);
	elseif ( UnitIsGhost("party"..this:GetParent():GetID().."target") ) then
		getglobal(prefix.."Portrait"):SetVertexColor(0.2, 0.2, 0.75, 1.0);
	elseif ( (this:GetParent().unitHPPercent > 0) and (this:GetParent().unitHPPercent <= 0.2) ) then
		getglobal(prefix.."Portrait"):SetVertexColor(1.0, 0.0, 0.0);
	else
		getglobal(prefix.."Portrait"):SetVertexColor(1.0, 1.0, 1.0, 1.0);
	end
	UnitFrameHealthBar_OnValueChanged(arg1);
end

function Party_Spellbar_OnLoad()
	local id = this:GetID();
	
	this:RegisterEvent("UNIT_TARGET");
	
	CastingBarFrame_OnLoad("party"..id, false);

	local barIcon = getglobal(this:GetName().."Icon");
	barIcon:Show();

	SetPartySpellbarAspect();
end

function Party_Spellbar_OnEvent()
	local id = this:GetID();
	
	local newevent = event;
	local newarg1 = arg1;
	--	Check for target specific events
	if ( event == "UNIT_TARGET" and arg1 == "party"..id) then
		-- check if the new target is casting a spell
		local nameChannel  = UnitChannelInfo(this.unit);
		local nameSpell  = UnitCastingInfo(this.unit);
		if ( nameChannel ) then
			newevent = "UNIT_SPELLCAST_CHANNEL_START";
			newarg1 = "party"..id;
		elseif ( nameSpell ) then
			newevent = "UNIT_SPELLCAST_START";
			newarg1 = "party"..id;
		else
			this.casting = nil;
			this.channeling = nil;
			this:SetMinMaxValues(0, 0);
			this:SetValue(0);
			this:Hide();
			return;
		end
	end
	CastingBarFrame_OnEvent(newevent, newarg1);
end

function SetPartySpellbarAspect()
	local barName = this:GetName();
	
	local frameText = getglobal(barName.."Text");
	if ( frameText ) then
		frameText:SetTextHeight(7);
		frameText:ClearAllPoints();
		frameText:SetPoint("TOP", barName, "TOP", 0, 6);
	end

	local frameBorder = getglobal(barName.."Border");
	if ( frameBorder ) then
		frameBorder:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small");
		frameBorder:SetWidth(118);
		frameBorder:SetHeight(29);
		frameBorder:ClearAllPoints();
		frameBorder:SetPoint("TOP", barName, "TOP", 0, 12);
	end

	local frameFlash = getglobal(barName.."Flash");
	if ( frameFlash ) then
		frameFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small");
		frameFlash:SetWidth(118);
		frameFlash:SetHeight(29);
		frameFlash:ClearAllPoints();
		frameFlash:SetPoint("TOP", barName, "TOP", 0, 12);
	end
	
	local frameIcon = getglobal(barName.."Icon");
	if ( frameIcon ) then
		frameIcon:SetWidth(10);
		frameIcon:SetHeight(10);
	end
end

function Party_Spellbar_AdjustPosition()
	local id = this:GetID();
	local yPos = 0;
	if ( getglobal("PartyMemberFrame"..id.."PetFrame"):IsShown() ) then
		yPos = yPos - 18;
	end
	this:SetPoint("TOP", "PartyMemberFrame"..id, "BOTTOM", 5, yPos);
end
