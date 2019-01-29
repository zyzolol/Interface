local Procodile = LibStub("AceAddon-3.0"):GetAddon("Procodile")
local L = LibStub("AceLocale-3.0"):GetLocale("Procodile", false)
ProcodileFu = Procodile:NewModule("FuBar", "LibFuBarPlugin-Mod-3.0")

function ProcodileFu:OnModuleInitialize()
	self:SetFuBarOption('iconPath', "Interface\\Icons\\Spell_Holy_WordFortitude")
	self:SetFuBarOption('tooltipType', "GameTooltip")
	self:SetFuBarOption('configType', "AceConfigDialog-3.0")
	self:SetFuBarOption('defaultPosition', "RIGHT")
end

function ProcodileFu:OpenMenu()
	Procodile:OpenOptions()
end

function ProcodileFu:OnModuleEnable()
	Procodile:Print("ProcodileFu:OnModuleEnable")
end

function ProcodileFu:OnUpdateFuBarText()
	if Procodile:IsEnabled() then
		self:SetFuBarText("|cff22ff22"..L["Procodile"])
	else
		self:SetFuBarText("|cffff2222"..L["Procodile"])
	end
end

function ProcodileFu:OnUpdateFuBarTooltip()
    GameTooltip:AddLine(L["Procodile"])
    GameTooltip:AddLine(" ")
    
    local tracked = Procodile:GetTrackedSpells()
    
	for internalname,proc in pairs(tracked) do
		-- PPM
		local ppm = 0
		if proc.count > 0 then
			ppm = proc.count / (proc.totaltime / 60)
		end
		
		-- Uptime
		local uptime = 0
		if proc.seconds > 0 and proc.totaltime > 0 then
			uptime = proc.seconds / proc.totaltime * 100
		end
				
		GameTooltip:AddLine(proc.name, 0.3, 0.3, 0.8)
		GameTooltip:AddTexture(proc.icon)
		if proc.count > 0 then
		    GameTooltip:AddDoubleLine(L["Procs"], proc.count, nil, nil, nil, 1,1,1)
		else
		    GameTooltip:AddDoubleLine(L["Procs"], "none", nil, nil, nil, 1,1,1)
		end
			
	    if ppm > 0 then
		    GameTooltip:AddDoubleLine(L["PPM"], string.format("%.2f", ppm), nil, nil, nil, 1,1,1)
		else
		    GameTooltip:AddDoubleLine(L["PPM"],"unknown", nil, nil, nil, 1,1,1)
		end
		
		if uptime > 0 then
		    GameTooltip:AddDoubleLine(L["Uptime"], string.format("%.2f", uptime).."%", nil, nil, nil, 1,1,1)
		else
		    GameTooltip:AddDoubleLine(L["Uptime"], "unknown", nil, nil, nil, 1,1,1)
		end
		
	    if proc.cooldown > 0 then
		    GameTooltip:AddDoubleLine(L["Cooldown"], proc.cooldown.."s", nil, nil, nil, 1,1,1)
		else
		    GameTooltip:AddDoubleLine(L["Cooldown"], "unknown", nil, nil, nil, 1,1,1)
		end
		GameTooltip:AddLine(" ")
	end

    GameTooltip:AddLine(L["Hint: Ctrl-Click to reset."], 0, 1, 0)
    GameTooltip:AddLine(L["Shift-click to toggle tracking."], 0, 1, 0)
    GameTooltip:AddLine(L["Right-click to configure"], 0, 1, 0)
end

function ProcodileFu:OnFuBarEnter()
end

function ProcodileFu:OnFuBarLeave()
end

function ProcodileFu:OnFuBarClick(button)
	if button == "LeftButton" and IsShiftKeyDown() then
		Procodile:Toggle()
	elseif button == "LeftButton" and IsControlKeyDown() then
		Procodile:Reset()
	end
end