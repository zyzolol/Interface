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
-- Version $LastChangedDate: 2007-01-29 13:45:48 +0100 (lun., 29 janv. 2007) $
------------------------------------------------------------------------------------------------------

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)



------------------------------------------------------------------------------------------------------
-- DEFINITION INITIALE DES ATTRIBUTS DES MENUS
------------------------------------------------------------------------------------------------------

-- On crée les menus sécurisés pour les différents sorts Buff / Démon / Malédictions
function Necrosis:MenuAttribute(menu)
	if InCombatLockdown() then
		return
	end

	local menu0 = _G[menu.."0"]
	local menuButton = _G[menu.."Button"]

	menuButton:SetAttribute("*childraise*", true)

	menuButton:SetAttribute("onmousedownbutton1", "down1")
	menuButton:SetAttribute("onmousedownbutton2", "down2")
	menuButton:SetAttribute("*anchorchild-down1", menu0)
	menuButton:SetAttribute("*anchorchild-down2", menu0)

	menuButton:SetAttribute("*childofsx-down1", 0)
	menuButton:SetAttribute("*childofsy-down1", 0)
	menuButton:SetAttribute("*childofsx-down2", 0)
	menuButton:SetAttribute("*childofsy-down2", 0)
	menuButton:SetAttribute("*childpoint-down1", "CENTER")
	menuButton:SetAttribute("*childpoint-down2", "CENTER")
	menuButton:SetAttribute("*childrelpoint-down1", "CENTER")
	menuButton:SetAttribute("*childrelpoint-down2", "CENTER")

	menuButton:SetAttribute("*childstate-down1", "^mousedown1")
	menuButton:SetAttribute("*childstate-down2", "^mousedown2")
	menuButton:SetAttribute("*childreparent-down1", "true")
	menuButton:SetAttribute("*childreparent-down2", "true")

	menu0:SetAttribute("state", 0)

	menu0:SetAttribute("statemap-anchor-mousedown1", "0:1;1:0;3:3;4:4")
	menu0:SetAttribute("statemap-anchor-mousedown2", "0:1;1:0;3:3;4:4")
	menu0:SetAttribute("delaystatemap-anchor-mousedown1", "3:3;4:4;*:0")
	menu0:SetAttribute("delaytimemap-anchor-mousedown1", "8")
	menu0:SetAttribute("delayhovermap-anchor-mousedown1", "true")

end



------------------------------------------------------------------------------------------------------
-- DEFINITION INITIALE DES ATTRIBUTS DES SORTS
------------------------------------------------------------------------------------------------------

-- On associe les buffs au clic sur le bouton concerné
function Necrosis:BuffSpellAttribute()
	if InCombatLockdown() then
		return
	end

	-- Association de l'armure demoniaque si le sort est disponible
	if _G["NecrosisBuffMenu1"] then
		NecrosisBuffMenu1:SetAttribute("type", "spell")
		if not Necrosis.Spell[31].ID then
			NecrosisBuffMenu1:SetAttribute("spell",
				Necrosis.Spell[36].Name.."("..Necrosis.Spell[36].Rank..")"
			)
		else
			NecrosisBuffMenu1:SetAttribute("spell",
				Necrosis.Spell[31].Name.."("..Necrosis.Spell[31].Rank..")"
			)
		end
		-- Création du tableau des raccourcis claviers
		if not Necrosis.AlreadyBind["NecrosisBuffMenu1"] then
			Necrosis.AlreadyBind["NecrosisBuffMenu1"] = true
			Necrosis.Binding:insert({Necrosis.Spell[31].Name, "CLICK NecrosisBuffMenu1:LeftButton"})
		end
	end


	-- Association des autres buffs aux boutons
	local buffID = {31, 47, 32, 33, 34, 37, 39, 38, 43, 35, 9}
	for i = 2, #buffID - 1, 1 do
		local f = _G["NecrosisBuffMenu"..i]
		if f then
			f:SetAttribute("type", "spell")
			-- Si le sort nécessite une cible, on lui en associe une
			if not (i == 2 or i == 5 or i == 7 or i == 8 or i == 9) then
				f:SetAttribute("unit", "target")
			end
			local SpellName_Rank = Necrosis.Spell[ buffID[i] ].Name
			if Necrosis.Spell[ buffID[i] ].Rank and not (Necrosis.Spell[ buffID[i] ].Rank == " ") then
				SpellName_Rank = SpellName_Rank.."("..Necrosis.Spell[ buffID[i] ].Rank..")"
			end
			f:SetAttribute("spell", SpellName_Rank)
			-- Création du tableau des raccourcis claviers
			if not Necrosis.AlreadyBind["NecrosisBuffMenu"..i] then
				Necrosis.AlreadyBind["NecrosisBuffMenu"..i] = true
				Necrosis.Binding:insert(
					{Necrosis.Spell[ buffID[i] ].Name, "CLICK NecrosisBuffMenu"..i..":LeftButton"}
				)
			end
		end
	end


	-- Cas particulier : Bouton de Banish
	if _G["NecrosisBuffMenu11"] then
		local SpellName_Rank = Necrosis.Spell[9].Name.."("..Necrosis.Spell[9].Rank..")"
		local Rank1 = SpellName_Rank:gsub("2", "1")
		-- Association du sort au clic gauche
		NecrosisBuffMenu11:SetAttribute("unit*", "target")
		NecrosisBuffMenu11:SetAttribute("type*", "macro")
		NecrosisBuffMenu11:SetAttribute("macrotext*", "/focus\n/cast "..SpellName_Rank)

		-- Si le démoniste control + click le bouton de banish
		-- On rebanish la dernière cible bannie
		NecrosisBuffMenu11:SetAttribute("ctrl-unit*", "focus")
		NecrosisBuffMenu11:SetAttribute("ctrl-type*", "spell")
		NecrosisBuffMenu11:SetAttribute("ctrl-spell*", SpellName_Rank)

		-- Création du tableau des raccourcis claviers
		if not Necrosis.AlreadyBind["NecrosisBuffMenu11Left"] then
			Necrosis.AlreadyBind["NecrosisBuffMenu11Left"] = true
			Necrosis.Binding:insert({Necrosis.Spell[9].Name, "CLICK NecrosisBuffMenu11:LeftButton"})
		end
		-- Si le démoniste possède le Banish rang 2, on associe le rang 1 au clic droit
		if Necrosis.Spell[9].Rank:find("2") then
			NecrosisBuffMenu11:SetAttribute("ctrl-unit*", "focus")
			NecrosisBuffMenu11:SetAttribute("harmbutton*", "banish")
			NecrosisBuffMenu11:SetAttribute("unit*", "target")
			NecrosisBuffMenu11:SetAttribute("type-banish1", "macro")
			NecrosisBuffMenu11:SetAttribute("macrotext-banish1", "/focus\n/cast "..SpellName_Rank)
			NecrosisBuffMenu11:SetAttribute("type-banish2", "macro")
			NecrosisBuffMenu11:SetAttribute("macrotext-banish2", "/focus\n/cast "..Rank1)

			NecrosisBuffMenu11:SetAttribute("ctrl-type1", "spell")
			NecrosisBuffMenu11:SetAttribute("ctrl-spell1", SpellName_Rank)
			NecrosisBuffMenu11:SetAttribute("ctrl-type2", "spell")
			NecrosisBuffMenu11:SetAttribute("ctrl-spell2", Rank1)

			if not Necrosis.AlreadyBind["NecrosisBuffMenu11Right"] then
				Necrosis.AlreadyBind["NecrosisBuffMenu11Right"] = true
				Necrosis.Binding:insert(
					{Necrosis.Spell[9].Name.." Rank 1", "CLICK NecrosisBuffMenu11:RightButton"}
				)
			end
		end


	end
end

-- On associe les démons au clic sur le bouton concerné
function Necrosis:PetSpellAttribute()
	if InCombatLockdown() then
		return
	end

	-- Démons maitrisés
	for i = 2, 6, 1 do
		local f = _G["NecrosisPetMenu"..i]
		if f then
			local SpellName_Rank = Necrosis.Spell[i+1].Name
			if Necrosis.Spell[i+1].Rank and not (Necrosis.Spell[i+1].Rank == " ") then
				SpellName_Rank = SpellName_Rank.."("..Necrosis.Spell[i+1].Rank..")"
			end
			f:SetAttribute("type1", "spell")
			f:SetAttribute("type2", "macro")
			f:SetAttribute("spell", SpellName_Rank)
			f:SetAttribute("macrotext",
				"/cast "..Necrosis.Spell[15].Name.."\n/stopcasting\n/cast "..SpellName_Rank
			)
			-- Création du tableau des raccourcis claviers
			if not Necrosis.AlreadyBind["NecrosisPetMenu"..i] then
				Necrosis.AlreadyBind["NecrosisPetMenu"..i] = true
				Necrosis.Binding:insert(
					{Necrosis.Spell[i+2].Name, "CLICK NecrosisPetMenu"..i..":LeftButton"}
				)
			end
		end
	end

	-- Autres sorts démoniaques
	local buttonID = {1, 7, 8, 9, 10}
	local BuffID = {15, 8, 30, 35, 44}
	for i = 1, #buttonID, 1 do
		local f = _G["NecrosisPetMenu"..buttonID[i]]
		if f then
			local SpellName_Rank = Necrosis.Spell[ BuffID[i] ].Name
			if Necrosis.Spell[ BuffID[i] ].Rank and not (Necrosis.Spell[ BuffID[i] ].Rank == " ") then
				SpellName_Rank = SpellName_Rank.."("..Necrosis.Spell[ BuffID[i] ].Rank..")"
			end
			f:SetAttribute("type", "spell")
			f:SetAttribute("spell", SpellName_Rank)
			-- Création du tableau des raccourcis claviers
			if not Necrosis.AlreadyBind["NecrosisPetMenu"..buttonID[i]] then
				Necrosis.AlreadyBind["NecrosisPetMenu"..buttonID[i]] = true
				Necrosis.Binding:insert(
					{Necrosis.Spell[BuffID[i]].Name, "CLICK NecrosisPetMenu"..buttonID[i]..":LeftButton"}
				)
			end
		end
	end
end

-- On associe les malédictions au clic sur le bouton concerné
function Necrosis:CurseSpellAttribute()
	if InCombatLockdown() then
		return
	end

	-- Malédiction amplifiée
	if _G["NecrosisCurseMenu1"] then
		NecrosisCurseMenu1:SetAttribute("type", "spell")
		NecrosisCurseMenu1:SetAttribute("spell", Necrosis.Spell[42].Name)
		-- Création du tableau des raccourcis claviers
		if not Necrosis.AlreadyBind["NecrosisCurseMenu1"] then
			Necrosis.AlreadyBind["NecrosisCurseMenu1"] = true
			Necrosis.Binding:insert({Necrosis.Spell[42].Name, "CLICK NecrosisCurseMenu1:LeftButton"})
		end
	end

	-- Malédictions amplifiables
	local buttonID = {3, 6, 9}
	local buffID = {22, 40, 16}
	for i = 1, #buttonID, 1 do
		local f = _G["NecrosisCurseMenu"..buttonID[i]]
		if f then
			local SpellName_Rank = Necrosis.Spell[ buffID[i] ].Name
			if Necrosis.Spell[ buffID[i] ].Rank and not (Necrosis.Spell[ buffID[i] ].Rank == " ") then
				SpellName_Rank = SpellName_Rank.."("..Necrosis.Spell[ buffID[i] ].Rank..")"
			end
			f:SetAttribute("harmbutton1", "debuff")
			f:SetAttribute("type-debuff", "spell")
			f:SetAttribute("unit", "target")
			f:SetAttribute("spell-debuff", SpellName_Rank)
			f:SetAttribute("harmbutton2", "amplif")
			f:SetAttribute("type-amplif", "macro")
			f:SetAttribute("macrotext-amplif",
				"/cast "..Necrosis.Spell[42].Name.."\n/stopcasting\n/cast "..SpellName_Rank
			)
			-- Création du tableau des raccourcis claviers
			if not Necrosis.AlreadyBind["NecrosisCurseMenu"..buttonID[i]] then
				Necrosis.AlreadyBind["NecrosisCurseMenu"..buttonID[i]] = true
				Necrosis.Binding:insert(
					{Necrosis.Spell[buffID[i]].Name,
					"CLICK NecrosisCurseMenu"..buttonID[i]..":LeftButton"}
				)
			end
		end
	end

	-- Autres malédictions
	local buttonID = {2, 4, 5, 7, 8, 9}
	local buffID = {23, 24, 25, 26, 27, 16}
	for i = 1, #buttonID, 1 do
		local f = _G["NecrosisCurseMenu"..buttonID[i]]
		if f then
			local SpellName_Rank = Necrosis.Spell[ buffID[i] ].Name
			if Necrosis.Spell[ buffID[i] ].Rank and not (Necrosis.Spell[ buffID[i] ].Rank == " ") then
				SpellName_Rank = SpellName_Rank.."("..Necrosis.Spell[ buffID[i] ].Rank..")"
			end
			f:SetAttribute("harmbutton", "debuff")
			f:SetAttribute("type-debuff", "spell")
			f:SetAttribute("unit", "target")
			f:SetAttribute("spell-debuff", SpellName_Rank)
			-- Création du tableau des raccourcis claviers
			if not Necrosis.AlreadyBind["NecrosisCurseMenu"..buttonID[i]] then
				Necrosis.AlreadyBind["NecrosisCurseMenu"..buttonID[i]] = true
				Necrosis.Binding:insert(
					{Necrosis.Spell[ buffID[i] ].Name,
					"CLICK NecrosisCurseMenu"..buttonID[i]..":LeftButton"}
				)
			end
		end
	end
end

-- Association de la monture au bouton, et de la création des pierres sur un clic droit
function Necrosis:StoneAttribute(Steed)
	if InCombatLockdown() then
		return
	end

	-- Pour les pierres
	local itemName = {"Soulstone", "Healthstone", "Spellstone", "Firestone" }
	local buffID = {51,52,53,54}
	for i = 1, #itemName, 1 do
		local f = _G["Necrosis"..itemName[i].."Button"]
		if f then
			f:SetAttribute("type2", "spell")
			f:SetAttribute("spell2", Necrosis.Spell[ buffID[i] ].Name.."("..Necrosis.Spell[ buffID[i] ].Rank..")")

			-- On prépare le tableau des raccourcis claviers
			if not Necrosis.AlreadyBind["Necrosis"..itemName[i].."Button"] then
				Necrosis.AlreadyBind["Necrosis"..itemName[i].."Button"] = true
				Necrosis.Binding:insert(
					{Necrosis.Spell[ buffID[i] ].Name,
					"CLICK Necrosis"..itemName[i].."Button:RightButton"}
				)
				Necrosis.Binding:insert(
					{Necrosis.Translation.Item[ itemName[i] ], "CLICK Necrosis"..itemName[i].."Button:LeftButton"}
				)
				if i == 2 then
					Necrosis.Binding:insert(
						{
							"Trade "..Necrosis.Translation.Item[ itemName[i] ],
							"CLICK Necrosis"..itemName[i].."Button:MiddleButton"
						}
					)
				end
			end
		end
	end

	-- Pour la monture
	if Steed and  _G["NecrosisMountButton"] then
		NecrosisMountButton:SetAttribute("type1", "spell")
		NecrosisMountButton:SetAttribute("type2", "spell")
		-- Si le démoniste possède une monture épique, on associe la monture classique au clic droit
		if Necrosis.Spell[2].ID then
			NecrosisMountButton:SetAttribute("spell1", Necrosis.Spell[2].Name)
			NecrosisMountButton:SetAttribute("spell2", Necrosis.Spell[1].Name)

		else
			NecrosisMountButton:SetAttribute("spell*", Necrosis.Spell[1].Name)
		end
		if not Necrosis.AlreadyBind["NecrosisMountButton"] then
			Necrosis.AlreadyBind["NecrosisMountButton"] = true
			Necrosis.Binding:insert({Necrosis.Spell[2].Name, "CLICK NecrosisMountButton:LeftButton"})
		end
	end

	-- Pour la pierre de foyer
	NecrosisSpellTimerButton:SetAttribute("unit1", "target")
	NecrosisSpellTimerButton:SetAttribute("type1", "macro")
	NecrosisSpellTimerButton:SetAttribute("macrotext", "/focus")
	NecrosisSpellTimerButton:SetAttribute("type2", "item")
	NecrosisSpellTimerButton:SetAttribute("item", Necrosis.Translation.Item.Hearthstone)

	-- Cas particulier : Si le sort du Rituel des âmes existe, on l'associe au shift+clic healthstone.
	if _G["NecrosisHealthstoneButton"] and Necrosis.Spell[50].ID then
		NecrosisHealthstoneButton:SetAttribute("shift-type*", "spell")
		NecrosisHealthstoneButton:SetAttribute("shift-spell*", Necrosis.Spell[50].Name)
	end
end

-- Association de la Connexion au bouton central si le sort est disponible
function Necrosis:MainButtonAttribute()
	-- Le clic droit ouvre le Menu des options
	NecrosisButton:SetAttribute("type2", "Open")
	NecrosisButton.Open = function()
		if not InCombatLockdown() then
			Necrosis:OpenConfigPanel()
		end
	end

	if Necrosis.Spell[NecrosisConfig.MainSpell].ID then
		NecrosisButton:SetAttribute("type1", "spell")
		NecrosisButton:SetAttribute("spell", Necrosis.Spell[NecrosisConfig.MainSpell].Name)
		if not Necrosis.AlreadyBind["NecrosisButton"] then
			Necrosis.AlreadyBind["NecrosisButton"] = true
			Necrosis.Binding:insert(
				{Necrosis.Spell[NecrosisConfig.MainSpell].Name, "CLICK NecrosisButton:LeftButton"}
			)
		end
	end
end


------------------------------------------------------------------------------------------------------
-- DEFINITION DES ATTRIBUTS DES SORTS EN FONCTION DU COMBAT / REGEN
------------------------------------------------------------------------------------------------------

function Necrosis:NoCombatAttribute(SoulstoneMode, FirestoneMode, SpellstoneMode)

	-- Si on veut que le menu s'engage automatiquement en combat
	-- Et se désengage à la fin
	if NecrosisConfig.AutomaticMenu and not NecrosisConfig.BlockedMenu then
		if _G["NecrosisPetMenu0"] then NecrosisPetMenu0:SetAttribute("state", "0") end
		if _G["NecrosisBuffMenu0"] then NecrosisBuffMenu0:SetAttribute("state", "0") end
		if _G["NecrosisCurseMenu0"] then NecrosisCurseMenu0:SetAttribute("state", "0") end
	end

	-- Si la pierre de sort est équipée, et qu'on connait une baguette,
	-- Alors cliquer milieu sur la pierre de sort équipe la baguette.
	if SpellstoneMode == 3 and NecrosisConfig.ItemSwitchCombat[3] and _G["NecrosisSpellstoneButton"] then
		NecrosisSpellstoneButton:SetAttribute("macrotext3","/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
		NecrosisSpellstoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
	-- Sinon, si la pierre de feu est équipée, et qu'on connait une baguette,
	-- Alors cliquer sur la pierre de feu équipe la baguette
	elseif FirestoneMode == 3 and NecrosisConfig.ItemSwitchCombat[3] and _G["NecrosisFirestoneButton"] then
		NecrosisFirestoneButton:SetAttribute("macrotext*", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
		NecrosisFirestoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
	else
		-- Si on connait l'emplacement de la pierre de sort,
		-- Alors cliquer sur le bouton de pierre de sort l'équipe.
		if NecrosisConfig.ItemSwitchCombat[1] and _G["NecrosisSpellstoneButton"] then
			NecrosisSpellstoneButton:SetAttribute("macrotext3","/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[1])
			NecrosisSpellstoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[1])
		end
		-- Si on connait l'emplacement de la pierre de feu,
		-- Alors cliquer sur le bouton de pierre de feu l'équipe.
		if NecrosisConfig.ItemSwitchCombat[2] and _G["NecrosisFirestoneButton"] then
			NecrosisFirestoneButton:SetAttribute("macrotext*", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[2])
			NecrosisFirestoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[2])
		end
	end
end

function Necrosis:InCombatAttribute()

	-- Si on veut que le menu s'engage automatiquement en combat
	if NecrosisConfig.AutomaticMenu and not NecrosisConfig.BlockedMenu then
		if _G["NecrosisPetMenu0"] and NecrosisConfig.StonePosition[7] then NecrosisPetMenu0:SetAttribute("state", "3") end
		if _G["NecrosisBuffMenu0"] and NecrosisConfig.StonePosition[5] then NecrosisBuffMenu0:SetAttribute("state", "3") end
		if _G["NecrosisCurseMenu0"] and NecrosisConfig.StonePosition[8] then NecrosisCurseMenu0:SetAttribute("state", "3") end
	end

	-- Si on connait le nom de la pierre de sort,
	-- Alors le clic gauche utiliser la pierre
	-- Alors le clic milieu sur le bouton équipera la pierre
	if NecrosisConfig.ItemSwitchCombat[1] and _G["NecrosisSpellstoneButton"] then
		NecrosisSpellstoneButton:SetAttribute("type1", "item")
		NecrosisSpellstoneButton:SetAttribute("item", NecrosisConfig.ItemSwitchCombat[1])
		NecrosisSpellstoneButton:SetAttribute("macrotext3","/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[1])
		NecrosisSpellstoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[1])
	end

	-- Si on connait le nom de la pierre de feu,
	-- Alors le clic sur le bouton équipera la pierre
	if NecrosisConfig.ItemSwitchCombat[2] and _G["NecrosisFirestoneButton"] then
		NecrosisFirestoneButton:SetAttribute("type1", "macro")
		NecrosisFirestoneButton:SetAttribute("macrotext*", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[2])
		NecrosisFirestoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[2])
	end

	-- Si on connait le nom de la pierre de soin,
	-- Alors le clic gauche sur le bouton utilisera la pierre
	if NecrosisConfig.ItemSwitchCombat[4] and _G["NecrosisHealthstoneButton"] then
		NecrosisHealthstoneButton:SetAttribute("type1", "macro")
		NecrosisHealthstoneButton:SetAttribute("macrotext1", "/stopcasting \n/use "..NecrosisConfig.ItemSwitchCombat[4])
	end

	-- Si on connait le nom de la pierre d'âme,
	-- Alors le clic gauche sur le bouton utilisera la pierre
	if NecrosisConfig.ItemSwitchCombat[5] and _G["NecrosisSoulstoneButton"] then
		NecrosisSoulstoneButton:SetAttribute("type1", "item")
		NecrosisSoulstoneButton:SetAttribute("unit", "target")
		NecrosisSoulstoneButton:SetAttribute("item1", NecrosisConfig.ItemSwitchCombat[5])
	end
end

------------------------------------------------------------------------------------------------------
-- DEFINITION SITUATIONNELLE DES ATTRIBUTS DES SORTS
------------------------------------------------------------------------------------------------------

function Necrosis:SoulstoneUpdateAttribute(nostone)
	-- Si le démoniste est en combat, on ne fait rien :)
	if InCombatLockdown() or not _G["NecrosisSoulstoneButton"] then
		return
	end

	-- Si le démoniste n'a pas de pierre dans son inventaire,
	-- Un clic gauche crée la pierre
	if nostone then
		NecrosisSoulstoneButton:SetAttribute("type1", "spell")
		NecrosisSoulstoneButton:SetAttribute("spell1", Necrosis.Spell[51].Name.."("..Necrosis.Spell[51].Rank..")")
		return
	end

	NecrosisSoulstoneButton:SetAttribute("type1", "item")
	NecrosisSoulstoneButton:SetAttribute("type3", "item")
	NecrosisSoulstoneButton:SetAttribute("unit", "target")
	NecrosisSoulstoneButton:SetAttribute("item1", NecrosisConfig.ItemSwitchCombat[5])
	NecrosisSoulstoneButton:SetAttribute("item3", NecrosisConfig.ItemSwitchCombat[5])
end

function Necrosis:HealthstoneUpdateAttribute(nostone)
	-- Si le démoniste est en combat, on ne fait rien :)
	if InCombatLockdown() or not _G["NecrosisHealthstoneButton"] then
		return
	end

	-- Si le démoniste n'a pas de pierre dans son inventaire,
	-- Un clic gauche crée la pierre
	if nostone then
		NecrosisHealthstoneButton:SetAttribute("type1", "spell")
		NecrosisHealthstoneButton:SetAttribute("spell1", Necrosis.Spell[52].Name.."("..Necrosis.Spell[52].Rank..")")
		return
	end

	NecrosisHealthstoneButton:SetAttribute("type1", "macro")
	NecrosisHealthstoneButton:SetAttribute("macrotext1", "/stopcasting \n/use "..NecrosisConfig.ItemSwitchCombat[4])
	NecrosisHealthstoneButton:SetAttribute("type3", "Trade")
	NecrosisHealthstoneButton:SetAttribute("ctrl-type1", "Trade")
	NecrosisHealthstoneButton.Trade = function () self:TradeStone() end
end

function Necrosis:SpellstoneUpdateAttribute(nostone)
	-- Si le démoniste est en combat, on ne fait rien :)
	if InCombatLockdown() or not _G["NecrosisSpellstoneButton"] then
		return
	end

	-- Si le démoniste n'a pas de pierre dans son inventaire,
	-- Un clic gauche crée la pierre
	if nostone then
		NecrosisSpellstoneButton:SetAttribute("type1", "spell")
		NecrosisSpellstoneButton:SetAttribute("spell1", Necrosis.Spell[53].Name.."("..Necrosis.Spell[53].Rank..")")
		return
	end

	NecrosisSpellstoneButton:SetAttribute("type1", "item")
	NecrosisSpellstoneButton:SetAttribute("item", NecrosisConfig.ItemSwitchCombat[1])
	NecrosisSpellstoneButton:SetAttribute("ctrl-type1", "macro")
	NecrosisSpellstoneButton:SetAttribute("shift-type1", "macro")
	NecrosisSpellstoneButton:SetAttribute("type3", "macro")
	NecrosisSpellstoneButton:SetAttribute("macrotext3", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[1])
	NecrosisSpellstoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[1])
	if NecrosisConfig.ItemSwitchCombat[3] then
		NecrosisSpellstoneButton:SetAttribute("shift-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
	end
end

function Necrosis:FirestoneUpdateAttribute(nostone)
	-- Si le démoniste est en combat, on ne fait rien :)
	if InCombatLockdown() or not _G["NecrosisFirestoneButton"] then
		return
	end

	-- Si le démoniste n'a pas de pierre dans son inventaire,
	-- Un clic gauche crée la pierre
	if nostone then
		NecrosisFirestoneButton:SetAttribute("type1", "spell")
		NecrosisFirestoneButton:SetAttribute("spell1", Necrosis.Spell[54].Name.."("..Necrosis.Spell[54].Rank..")")
		return
	end

	NecrosisFirestoneButton:SetAttribute("ctrl-type1", "macro")
	NecrosisFirestoneButton:SetAttribute("shift-type1", "macro")
	NecrosisFirestoneButton:SetAttribute("type1", "macro")
	NecrosisFirestoneButton:SetAttribute("type3", "macro")
	NecrosisFirestoneButton:SetAttribute("macrotext*", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[2])
	NecrosisFirestoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[2])
	if NecrosisConfig.ItemSwitchCombat[3] then
		NecrosisFirestoneButton:SetAttribute("shift-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
	end
end

function Necrosis:RangedUpdateAttribute()
	-- Si le démoniste est en combat, on ne fait rien :)
	if InCombatLockdown() then
		return
	end

	-- Si le démoniste a une baguette d'équipée
	if IsEquippedItemType("Wand") then
		-- Si on connait la pierre de sort,
		-- Alors le bouton du milieu équipe la pierre de sort
		if NecrosisConfig.ItemSwitchCombat[1] and _G["NecrosisSpellstoneButton"] then
			NecrosisSpellstoneButton:SetAttribute("macrotext3","/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[1])
			NecrosisSpellstoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[1])
		end
		-- Si on connait la pierre de feu,
		-- Alors cliquer équipe la pierre de feu
		if NecrosisConfig.ItemSwitchCombat[2] and _G["NecrosisFirestoneButton"] then
			NecrosisFirestoneButton:SetAttribute("macrotext*", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[2])
			NecrosisFirestoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[2])
		end
	-- Sinon, si le démoniste à une pierre de sort d'équipée et qu'on connait une baguette,
	-- Cliquer milieu rééquipe la baguette
	elseif SpellstoneMode == 3 and NecrosisConfig.ItemSwitchCombat[3] and _G["NecrosisSpellstoneButton"] then
		NecrosisSpellstoneButton:SetAttribute("macrotext3","/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
		NecrosisSpellstoneButton:SetAttribute("ctrl-macrotext1","/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
	-- Sinon, si le démoniste a une pierre de feu d'équipée et qu'on connait une baguette,
	-- Cliquer rééquipe la baguette
	elseif FirestoneMode == 3 and NecrosisConfig.ItemSwitchCombat[3] and _G["NecrosisFirestoneButton"] then
		NecrosisFirestoneButton:SetAttribute("macrotext*", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
		NecrosisFirestoneButton:SetAttribute("ctrl-macrotext1", "/equipslot 18 "..NecrosisConfig.ItemSwitchCombat[3])
	end
end
