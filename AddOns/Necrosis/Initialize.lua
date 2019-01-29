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
-- Originally by Lomig, Liadora et Nyx (Kael'Thas et Elune) [2005-2007]
-- Now updated by Tarcalion (Nagrand US/Oceanic) [2008-...]
--
-- Skins and French voices: Eliah, Ner'zhul
--
-- German Version by Geschan
-- Spanish Version by DosS (Zul’jin)
--
-- Version $LastChangedDate: 2008-03-30 15:05:46 +1000 $
------------------------------------------------------------------------------------------------------

-- On définit _G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

------------------------------------------------------------------------------------------------------
-- FONCTION D'INITIALISATION
------------------------------------------------------------------------------------------------------

function Necrosis:Initialize(Config)

	-- Initilialisation des Textes (VO / VF / VA / VCT / VCS / VE)
	if NecrosisConfig.Version then
		if (NecrosisConfig.Language == "enUS") or (NecrosisConfig.Language == "enGB") then
			self:Localization_Dialog_En()
		elseif (NecrosisConfig.Language == "deDE") then
			self:Localization_Dialog_De()
		elseif (NecrosisConfig.Language == "zhTW") then
			self:Localization_Dialog_Tw()
		elseif (NecrosisConfig.Language == "zhCN") then
			self:Localization_Dialog_Cn()
		elseif (NecrosisConfig.Language == "esES") then
			self:Localization_Dialog_Es()
		else
			self:Localization_Dialog_Fr()
		end
	elseif GetLocale() == "enUS" or GetLocale() == "enGB" then
		self:Localization_Dialog_En()
	elseif GetLocale() == "deDE" then
		self:Localization_Dialog_De()
	elseif GetLocale() == "zhTW" then
		self:Localization_Dialog_Tw()
	elseif GetLocale() == "zhCN" then
		self:Localization_Dialog_Cn()
	elseif  GetLocale() == "esES" then
		self:Localization_Dialog_Es()
	else
		self:Localization_Dialog_Fr()
	end


	-- On charge (ou on crée la configuration pour le joueur et on l'affiche sur la console
	if not NecrosisConfig.Version or type(NecrosisConfig.Version) == "string" or Necrosis.Data.LastConfig > NecrosisConfig.Version then
		NecrosisConfig = {}
		NecrosisConfig = Config
		NecrosisConfig.Version = Necrosis.Data.LastConfig
		self:Msg(NECROSIS_MESSAGE.Interface.DefaultConfig, "USER")
	else
		self:Msg(NECROSIS_MESSAGE.Interface.UserConfig, "USER")
	end

	self:CreateWarlockUI()
	self:CreateWarlockPopup()

	-----------------------------------------------------------
	-- Exécution des fonctions de démarrage
	-----------------------------------------------------------
	-- Affichage d'un message sur la console
	self:Msg(NECROSIS_MESSAGE.Interface.Welcome, "USER")
	-- Création de la liste des sorts disponibles
	for index in ipairs(self.Spell) do
		self.Spell[index].ID = nil
	end
	self:SpellSetup()
	-- Création des menus de buff et d'invocation
	self:CreateMenu()
	-- Les boutons sont-ils verrouillés sur le Shard ?
	self:ButtonSetup()

	-- Enregistrement de la commande console
	SlashCmdList["NecrosisCommand"] = Necrosis.SlashHandler
	SLASH_NecrosisCommand1 = "/necro"

	-- On règle la taille de la pierre et des boutons suivant les réglages du SavedVariables
	NecrosisButton:SetScale(NecrosisConfig.NecrosisButtonScale/100)
	NecrosisShadowTranceButton:SetScale(NecrosisConfig.ShadowTranceScale/100)
	NecrosisBacklashButton:SetScale(NecrosisConfig.ShadowTranceScale/100)
	NecrosisAntiFearButton:SetScale(NecrosisConfig.ShadowTranceScale/100)
	NecrosisCreatureAlertButton:SetScale(NecrosisConfig.ShadowTranceScale/100)

	-- On définit l'affichage des Timers Graphiques à gauche ou à droite du bouton
	if _G["NecrosisTimerFrame0"] then
		NecrosisTimerFrame0:ClearAllPoints()
		NecrosisTimerFrame0:SetPoint(
			NecrosisConfig.SpellTimerJust,
			NecrosisSpellTimerButton,
			"CENTER",
			NecrosisConfig.SpellTimerPos * 20,
			0
		)
	end

	-- On définit l'affichage des Timers Textes à gauche ou à droite du bouton
	if _G["NecrosisListSpells"] then
		NecrosisListSpells:ClearAllPoints()
		NecrosisListSpells:SetJustifyH(NecrosisConfig.SpellTimerJust)
		NecrosisListSpells:SetPoint(
			"TOP"..NecrosisConfig.SpellTimerJust,
			"NecrosisSpellTimerButton",
			"CENTER",
			NecrosisConfig.SpellTimerPos * 23,
			5
		)
	end

	--On affiche ou on cache le bouton, d'ailleurs !
	if not NecrosisConfig.ShowSpellTimers then NecrosisSpellTimerButton:Hide() end

	-- Le Shard est-il verrouillé sur l'interface ?
	if NecrosisConfig.NoDragAll then
		self:NoDrag()
		NecrosisButton:RegisterForDrag("")
		NecrosisSpellTimerButton:RegisterForDrag("")
	else
		self:Drag()
		NecrosisButton:RegisterForDrag("LeftButton")
		NecrosisSpellTimerButton:RegisterForDrag("LeftButton")
	end



	-- Si pas d'objet en distance, on tente d'en équiper un
	self:MoneyToggle()
	NecrosisTooltip:SetInventoryItem("player", 18)
	local itemName = tostring(NecrosisTooltipTextLeft1:GetText())
	self:MoneyToggle()
	if (not GetInventoryItemLink("player", 18))
		or itemName:find(Necrosis.Translation.Item.Spellstone)
		or itemName:find(Necrosis.Translation.Item.Firestone) then
			self:SearchWand()
	end


	-- Inventaire des pierres et des fragments possedés par le Démoniste
	self:BagExplore()

	-- Si la sphere doit indiquer la vie ou la mana, on y va
	Necrosis:UpdateHealth()
	Necrosis:UpdateMana()

	-- On vérifie que les fragments sont dans le sac défini par le Démoniste
	if NecrosisConfig.SoulshardSort then
		self:SoulshardSwitch("CHECK")
	end

	-- Initialisation des fichiers de langues -- Mise en place ponctuelle du SMS
	self:Localization()
	if NecrosisConfig.SM then
		self.Speech.Rez = self.Speech.ShortMessage[1]
		self.Speech.TP = self.Speech.ShortMessage[2]
	end
end


------------------------------------------------------------------------------------------------------
-- FONCTION GERANT LA COMMANDE CONSOLE /NECRO
------------------------------------------------------------------------------------------------------

function Necrosis.SlashHandler(arg1)
	if arg1:lower():find("recall") then
		Necrosis:Recall()
	elseif arg1:lower():find("reset") and not InCombatLockdown() then
		NecrosisConfig = {}
		ReloadUI()
	elseif arg1:lower():find("glasofruix") then
		NecrosisConfig.Smooth = not NecrosisConfig.Smooth
		Necrosis:Msg("SpellTimer smoothing  : <lightBlue>Toggled")
	else
		Necrosis:OpenConfigPanel()
	end
end

