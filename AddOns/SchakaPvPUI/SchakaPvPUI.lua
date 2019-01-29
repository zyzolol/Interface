local frame = CreateFrame("Frame")
local function log(msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end -- alias for convenience
log("|c64FE2E0ASchakaPvPUI|r by |cff0070DESchaka|r @ github.com/Schaka")
log("Type /SchakaPvPUI pab to lock PartyAbilityBars to PartyFrames (or unlock)")
log("Use /SchakaPvPUI target|player|party|focus [number] to scale frames")
log("To move InterruptBar around, type /juked test. Do not change the settings via the menu.")
frame:RegisterEvent("PLAYER_LOGIN")
SchakaPvPUI = SchakaPvPUI or { target = 1.0, player = 1.0, party = 1.0, focus = 1.0, pab = false}

SLASH_PVPUI1 = '/SchakaPvPUI';
function SlashCmdList.PVPUI (msg, editBox)
	if msg == 'PAB' or msg == 'pab' then
		if SchakaPvPUI.pab == false then
			SchakaPvPUI.pab = true
			log("PartyAbilityBars are now moveable")
		else
			SchakaPvPUI.pab = false
			log("PartyAbilityBars are now linked to PartyFrames")
		end	
	elseif string.find(msg, "target") ~= nil then
		local message = string.sub(msg, 8)
		SchakaPvPUI.target = tonumber(message)
		TargetFrame:SetScale(SchakaPvPUI.target)
	elseif string.find(msg, "focus") ~= nil then
		local message = string.sub(msg, 7)
		SchakaPvPUI.focus = tonumber(message)
		FocusFrame:SetScale(SchakaPvPUI.focus)
	elseif string.find(msg, "player") ~= nil then
		local message = string.sub(msg, 8)
		SchakaPvPUI.player = tonumber(message)
		PlayerFrame:SetScale(SchakaPvPUI.player)
	elseif string.find(msg, "party") ~= nil then
		local message = string.sub(msg, 7)
		SchakaPvPUI.party = tonumber(message)
		PartyMemberFrame1:SetScale(SchakaPvPUI.party)
		PartyMemberFrame2:SetScale(SchakaPvPUI.party)
		PartyMemberFrame3:SetScale(SchakaPvPUI.party)
		PartyMemberFrame4:SetScale(SchakaPvPUI.party)
	end
end

local function eventHandler(self, event)
        if event == "PLAYER_LOGIN" then
                --PetFrame:ClearAllPoints()
                --PetFrame:SetPoint("LEFT",-22,50)
                --TotemFrame:ClearAllPoints()
                --TotemFrame:SetPoint("TOPRIGHT",0,22)
				
				PlayerFrame:SetScale(SchakaPvPUI.player)
				FocusFrame:SetScale(SchakaPvPUI.focus)
				TargetFrame:SetScale(SchakaPvPUI.target)
				PartyMemberFrame1:SetScale(SchakaPvPUI.party)
				PartyMemberFrame2:SetScale(SchakaPvPUI.party)
				PartyMemberFrame3:SetScale(SchakaPvPUI.party)
				PartyMemberFrame4:SetScale(SchakaPvPUI.party)
				
				TargetofTargetFrame:ClearAllPoints()
				TargetofTargetFrame:SetPoint("BOTTOMRIGHT", TargetFrame,-15,-10)
				TargetofFocusFrame:ClearAllPoints()
				TargetofFocusFrame:SetPoint("BOTTOMRIGHT", FocusFrame,-15,-10)
				
				TargetFrameFlash:SetAlpha(0)
				-- pvp icons
                PlayerPVPIcon:SetAlpha(0)
                TargetPVPIcon:SetAlpha(0)
                FocusPVPIcon:SetAlpha(0)
				-- interface
                MainMenuBarLeftEndCap:SetAlpha(0)
                MainMenuBarRightEndCap:SetAlpha(0)
				
				BuffFrame:SetScale(1.3)
				
				
		end
        if LoadAddOn("Blizzard_CombatText") then
                ENTERING_COMBAT = "+Combat"
                LEAVING_COMBAT = "-Combat"
                CombatText:SetScale(.85)
                COMBAT_TEXT_TYPE_INFO["ENTERING_COMBAT"].r = 1
                COMBAT_TEXT_TYPE_INFO["ENTERING_COMBAT"].g = 0
                COMBAT_TEXT_TYPE_INFO["ENTERING_COMBAT"].b = 1
                COMBAT_TEXT_TYPE_INFO["LEAVING_COMBAT"].r = 1
                COMBAT_TEXT_TYPE_INFO["LEAVING_COMBAT"].g = 0
                COMBAT_TEXT_TYPE_INFO["LEAVING_COMBAT"].b = 1
        end
end
frame:SetScript("OnEvent", eventHandler)


local frame2=CreateFrame("Frame")
frame2:RegisterEvent("ADDON_LOADED")
frame2:SetScript("OnEvent", function(self, event, addon)
        if (addon == "Blizzard_TimeManager") then
                for i, v in pairs({PlayerFrameTexture, TargetFrameTexture, PetFrameTexture, PartyMemberFrame1Texture, PartyMemberFrame2Texture, PartyMemberFrame3Texture, PartyMemberFrame4Texture,
                        PartyMemberFrame1PetFrameTexture, PartyMemberFrame2PetFrameTexture, PartyMemberFrame3PetFrameTexture, PartyMemberFrame4PetFrameTexture, PaperDollInfoFrameTexture, PaperDollFrameTexture,
						FocusFrameTexture, TargetofTargetTexture, TargetofFocusTexture, BonusActionBarFrameTexture0, BonusActionBarFrameTexture1, BonusActionBarFrameTexture2, BonusActionBarFrameTexture3,
                        BonusActionBarFrameTexture4, MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3, MainMenuMaxLevelBar0, MainMenuMaxLevelBar1, MainMenuMaxLevelBar2,
                        MainMenuMaxLevelBar3, MinimapBorder, CastingBarFrameBorder, FocusFrameSpellBarBorder, TargetFrameSpellBarBorder, MiniMapTrackingButtonBorder, MiniMapLFGFrameBorder, MiniMapBattlefieldBorder,
                        MiniMapMailBorder, MinimapBorderTop,
                        select(1, TimeManagerClockButton:GetRegions())
                }) do
                        v:SetVertexColor(0, 0, 0, 1)
                end

                for i,v in pairs({ select(2, TimeManagerClockButton:GetRegions()) }) do
                        v:SetVertexColor(0, 0, 0, 1)
                end

                self:UnregisterEvent("ADDON_LOADED")
                frame:SetScript("OnEvent", nil)
             
		end
end)

for i, v in pairs({ MainMenuBarLeftEndCap, MainMenuBarRightEndCap }) do
        v:SetVertexColor(0, 0, 0, 1)
end

---hides hotbar arrows

ActionBarUpButton:Hide()
ActionBarDownButton:Hide() 

---end

---Hides zoom in/out buttons / enables mousewheel zoom

MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("TOPRIGHT", -26, 7)

---end


local frame3 = CreateFrame("FRAME")
frame3:RegisterEvent("GROUP_ROSTER_UPDATE")
frame3:RegisterEvent("PARTY_MEMBERS_CHANGED")
frame3:RegisterEvent("PLAYER_TARGET_CHANGED")
frame3:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame3:RegisterEvent("UNIT_FACTION")
local function eventHandler2(self, event, ...)
        if UnitIsPlayer("target") then
                c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
                TargetFrameNameBackground:SetVertexColor(0, 0, 0, 0)
        end
        if UnitIsPlayer("focus") then
                c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
                FocusFrameNameBackground:SetVertexColor(0, 0, 0, 0)
        end
		--code to align PAB frames right to party
		for i=1,4 do
			local anchor = getglobal("PABAnchor"..i)
			if anchor and SchakaPvPUI.pab == true then
				anchor:SetPoint("TOPLEFT", "PartyMemberFrame"..i, "TOPRIGHT", -20, 0)
			end
		end
end
frame3:SetScript("OnEvent", eventHandler2)