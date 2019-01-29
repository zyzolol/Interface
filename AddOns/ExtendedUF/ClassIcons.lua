function ClassIcons_OnEvent(event)
	if (event == "PLAYER_TARGET_CHANGED") then
		ClassIcons_SetUnitClassIcon(this, "target");
	elseif (event == "PLAYER_FOCUS_CHANGED") then
		ClassIcons_SetUnitClassIcon(this, "focus");
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		ClassIcons_SetUnitClassIcon(this, "party"..this:GetID());
	end
end

function ClassIcons_SetUnitClassIcon(frame, unit)
	if (not frame.hide and UnitIsPlayer(unit)) then
		if (not frame:IsVisible()) then
			frame:Show();
		end
		local class = CLASS_BUTTONS[select(2, UnitClass(unit))];
		if (class and class[1] and class[2] and class[3] and class[4]) then
			getglobal(frame:GetName().."Texture"):SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
			getglobal(frame:GetName().."Texture"):SetTexCoord(class[1], class[2], class[3], class[4]);
		else
			getglobal(frame:GetName().."Texture"):SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
			getglobal(frame:GetName().."Texture"):SetTexCoord(0,0,0,1,1,0,1,1);
		end
	else
		frame:Hide();
	end
end