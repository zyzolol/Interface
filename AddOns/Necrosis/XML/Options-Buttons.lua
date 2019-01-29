--[[
    Necrosis LdC
    Copyright (C) 2005-2006  Lom Enfroy

    This file is part of Necrosis LdC.

    Necrosis LdC is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Necrosis LdC is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Necrosis LdC; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--]]


------------------------------------------------------------------------------------------------------
-- Necrosis LdC
-- Par Lomig, Liadora et Nyx (Kael'Thas et Elune)
--
-- Skins et voix Françaises : Eliah, Ner'zhul
--
-- Version Allemande par Geschan
-- Version Espagnole par DosS (Zul’jin)
--
-- $LastChangedDate: 2007-01-26 20:37:37 +0100 (ven., 26 janv. 2007) $
------------------------------------------------------------------------------------------------------

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)


------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OPTIONS
------------------------------------------------------------------------------------------------------

-- On crée ou on affiche le panneau de configuration de la sphere
function Necrosis:SetButtonsConfig()

	local frame = _G["NecrosisButtonsConfig"]
	if not frame then
		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisButtonsConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Création du slider de rotation de Necrosis
		frame = CreateFrame("Slider", "NecrosisRotation", NecrosisButtonsConfig, "OptionsSliderTemplate")
		frame:SetMinMaxValues(0, 360)
		frame:SetValueStep(9)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisButtonsConfig, "BOTTOMLEFT", 175, 410)

		frame:SetScript("OnEnter", function()
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
			GameTooltip:SetText(this:GetValue())
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnValueChanged", function()
			NecrosisConfig.NecrosisAngle = this:GetValue()
			GameTooltip:SetText(this:GetValue())
			Necrosis:ButtonSetup()
		end)

		NecrosisRotationLow:SetText("0")
		NecrosisRotationHigh:SetText("360")

		-- Attache ou détache les boutons de Necrosis
		frame = CreateFrame("CheckButton", "NecrosisLockButtons", NecrosisButtonsConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig, "BOTTOMLEFT", 25, 365)

		frame:SetScript("OnClick", function()
			if (this:GetChecked()) then
				NecrosisConfig.NecrosisLockServ = true
				Necrosis:ClearAllPoints()
				Necrosis:ButtonSetup()
				Necrosis:NoDrag()
				if not NecrosisConfig.NoDragAll then
					NecrosisButton:RegisterForDrag("LeftButton")
					NecrosisSpellTimerButton:RegisterForDrag("LeftButton")
				end
			else
				NecrosisConfig.NecrosisLockServ = false
				Necrosis:ClearAllPoints()
				local ButtonName = {
					"NecrosisFirestoneButton",
					"NecrosisSpellstoneButton",
					"NecrosisHealthstoneButton",
					"NecrosisSoulstoneButton",
					"NecrosisBuffMenuButton",
					"NecrosisMountButton",
					"NecrosisPetMenuButton",
					"NecrosisCurseMenuButton"
				}
				local loc = {-121, -87, -53, -17, 17, 53, 87, 121}
				for i in ipairs(ButtonName) do
					if _G[ButtonName[i]] then
						_G[ButtonName[i]]:SetPoint("CENTER", "UIParent", "CENTER", loc[i], -100)
						NecrosisConfig.FramePosition[ButtonName[i]] = {
							"CENTER",
							"UIParent",
							"CENTER",
							loc[i],
							-100
						}
					end
				end
				Necrosis:Drag()
				NecrosisConfig.NoDragAll = false
				NecrosisButton:RegisterForDrag("LeftButton")
				NecrosisSpellTimerButton:RegisterForDrag("LeftButton")
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		frame:SetFontString(FontString)
		frame:SetTextColor(1, 1, 1)

		-- Affiche ou cache les boutons autour de Necrosis
		local boutons = {"Firestone", "Spellstone", "HealthStone", "Soulstone", "BuffMenu", "Mount", "PetMenu", "CurseMenu"}
		local initY = 350
		for i in ipairs(boutons) do
			frame = CreateFrame("CheckButton", "NecrosisShow"..boutons[i], NecrosisButtonsConfig, "UICheckButtonTemplate")
			frame:EnableMouse(true)
			frame:SetWidth(24)
			frame:SetHeight(24)
			frame:Show()
			frame:ClearAllPoints()
			frame:SetPoint("LEFT", NecrosisButtonsConfig, "BOTTOMLEFT", 25, initY - (25 * i))

			frame:SetScript("OnClick", function()
				if (this:GetChecked()) then
					NecrosisConfig.StonePosition[i] = math.abs(NecrosisConfig.StonePosition[i])
				else
					NecrosisConfig.StonePosition[i] = - math.abs(NecrosisConfig.StonePosition[i])
				end
				Necrosis:ButtonSetup()
			end)

			FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
			FontString:Show()
			FontString:ClearAllPoints()
			FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
			frame:SetFontString(FontString)
			frame:SetTextColor(1, 1, 1)
		end

		-- Bindings
		frame = CreateFrame("Button", "Necrosis_Binding", NecrosisButtonsConfig, "OptionsButtonTemplate")
		frame:SetText(NECROSIS_BINDING.Binding)
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisButtonsConfig, "BOTTOMRIGHT", -25, 125)

		frame:SetScript("OnClick", function()
			ClickBinder.Open("Necrosis - "..NECROSIS_BINDING.Binding, Necrosis.Binding)
		end)
	end

	NecrosisRotation:SetValue(NecrosisConfig.NecrosisAngle)
	NecrosisLockButtons:SetChecked(NecrosisConfig.NecrosisLockServ)
	local boutons = {"Firestone", "Spellstone", "HealthStone", "Soulstone", "BuffMenu", "Mount", "PetMenu", "CurseMenu"}
	for i in ipairs(boutons) do
		_G["NecrosisShow"..boutons[i]]:SetChecked(NecrosisConfig.StonePosition[i] > 0)
		_G["NecrosisShow"..boutons[i]]:SetText(self.Config.Buttons.Name[i])
	end
	NecrosisRotationText:SetText(self.Config.Buttons["Rotation des boutons"])
	NecrosisLockButtons:SetText(self.Config.Buttons["Fixer les boutons autour de la sphere"])

	frame:Show()

end
