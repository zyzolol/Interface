local function log(msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end -- alias for convenience
local ClassPortraits = CreateFrame("Frame", nil, UIParent);
local iconPath="Interface\\Addons\\SchakaPvPUI\\UI-CLASSES-CIRCLES"

local partyFrames = {
	[1] = PartyMemberFrame1,
	[2] = PartyMemberframe2,
	[3] = PartyMemberframe3,
	[4] = PartyMemberframe4,
}

ClassPortraits:SetScript("OnUpdate",  function()
	if PlayerFrame.portrait~=nil then
		local _, class = UnitClass("player")
		local iconCoords = CLASS_BUTTONS[class]
		PlayerFrame.portrait:SetTexture(iconPath, true)
		PlayerFrame.portrait:SetTexCoord(unpack(iconCoords))
		PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
		PlayerFrameTexture:SetVertexColor(0.1, 0.1, 0.1)
	end
	for i=1, GetNumPartyMembers() do
		if partyFrames[i].portrait~=nil then
			if not CLASS_BUTTONS[select(2,UnitClass("party"..i))] then return end
			partyFrames[i].portrait:SetTexture(iconPath, true)
			partyFrames[i].portrait:SetTexCoord(unpack(CLASS_BUTTONS[select(2,UnitClass("party"..i))]))
		end
	end
		if(UnitGUID("target")~=nil and UnitIsPlayer("target") ~= nil and TargetFrame.portrait~=nil) then
			TargetFrame.portrait:SetTexture(iconPath, true)
			TargetFrame.portrait:SetTexCoord(unpack(CLASS_BUTTONS[select(2,UnitClass("target"))]))
		elseif(UnitGUID("target")~=nil) then
			TargetFrame.portrait:SetTexCoord(0,1,0,1)
		end
		
		if(UnitGUID("targettarget")~=nil and UnitIsPlayer("targettarget") ~= nil and TargetofTargetFrame.portrait~=nil) then
		TargetofTargetFrame.portrait:SetTexture(iconPath, true)
		TargetofTargetFrame.portrait:SetTexCoord(unpack(CLASS_BUTTONS[select(2,UnitClass("targettarget"))]))
		elseif(UnitGUID("targettarget")~=nil) then
			TargetofTargetFrame.portrait:SetTexCoord(0,1,0,1)
		end
		
		if(UnitGUID("focus") ~= nil and UnitIsPlayer("focus") ~= nil and FocusFrame.portrait~=nil) then
		FocusFrame.portrait:SetTexture(iconPath, true)
		FocusFrame.portrait:SetTexCoord(unpack(CLASS_BUTTONS[select(2,UnitClass("focus"))]))
		elseif(UnitGUID("focus")~=nil) then
			FocusFrame.portrait:SetTexCoord(0,1,0,1)
		end
		
		if(UnitGUID("focustarget")~=nil and UnitIsPlayer("focustarget") ~= nil and TargetofFocusFrame.portrait~=nil) then
		TargetofFocusFrame.portrait:SetTexture(iconPath, true)
		TargetofFocusFrame.portrait:SetTexCoord(unpack(CLASS_BUTTONS[select(2,UnitClass("focustarget"))]))
		elseif(UnitGUID("focustarget")~=nil) then
			TargetofFocusFrame.portrait:SetTexCoord(0,1,0,1)
		end
end
)