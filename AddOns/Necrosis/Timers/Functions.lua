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

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)


------------------------------------------------------------------------------------------------------
-- FONCTIONS D'INSERTION
------------------------------------------------------------------------------------------------------

-- La table des timers est là pour ça !
function Necrosis:InsertTimerParTable(IndexTable, Target, LevelTarget, Timer)
	-- Insertion de l'entrée dans le tableau
	Timer.SpellTimer:insert(
		{
			Name = Necrosis.Spell[IndexTable].Name,
			Time = Necrosis.Spell[IndexTable].Length,
			TimeMax = floor(GetTime() + Necrosis.Spell[IndexTable].Length),
			Type = Necrosis.Spell[IndexTable].Type,
			Target = Target,
			TargetLevel = LevelTarget,
			Group = 0,
			Gtimer = nil
		}
	)

	-- Association d'un timer graphique au timer
	-- Si il y a une frame timer de libérée, on l'associe au timer
	if NecrosisConfig.TimerType == 1 then
		local TimerLibre = nil
		for index, valeur in ipairs(Timer.TimerTable) do
			if not valeur then
				TimerLibre = index
				Timer.TimerTable[index] = true
				break
			end
		end
		-- Si il n'y a pas de frame de libérée, on rajoute une frame
		if not TimerLibre then
			Timer.TimerTable:insert(true)
			TimerLibre = #Timer.TimerTable
		end
		-- Association effective au timer
		Timer.SpellTimer[#Timer.SpellTimer].Gtimer = TimerLibre
		local FontString, StatusBar = self:AddFrame("NecrosisTimerFrame"..TimerLibre)
		FontString:SetText(Timer.SpellTimer[#Timer.SpellTimer].Name)
		StatusBar:SetMinMaxValues(
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax - Timer.SpellTimer[#Timer.SpellTimer].Time,
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax
		)
	end

	if NecrosisConfig.TimerType > 0 then
		-- Tri des entrées par type de sort
		self:Tri(Timer.SpellTimer, "Type")

		-- Création des groupes (noms des mobs) des timers
		Timer.SpellGroup, Timer.SpellTimer = self:Parsing(Timer.SpellGroup, Timer.SpellTimer)

		-- On met à jour l'affichage
		NecrosisUpdateTimer(Timer.SpellTimer, Timer.SpellGroup)
	end

		-- Détection des resists
	if not (Necrosis.Spell[IndexTable].Type == 0) then
		Timer.LastSpell.Name = Necrosis.Spell[IndexTable].Name
		Timer.LastSpell.Target = Target
		Timer.LastSpell.TargetLevel = LevelTarget
		Timer.LastSpell.Time = GetTime()
		for i in ipairs(Timer.SpellTimer) do
			if Timer.SpellTimer[i].Name == Timer.LastSpell.Name
				and Timer.SpellTimer[i].Target == Timer.LastSpell.Target
				and Timer.SpellTimer[i].TargetLevel == Timer.LastSpell.TargetLevel
				then
					Timer.LastSpell.Index = i
					break
			end
		end
	end

	return Timer
end

-- Et pour insérer le timer de pierres
function Necrosis:InsertTimerStone(Stone, start, duration, Timer)

	-- Insertion de l'entrée dans le tableau
	if Stone == "Healthstone" then
		Timer.SpellTimer:insert(
			{
				Name = NECROSIS_COOLDOWN.Healthstone,
				Time = 180,
				TimeMax = floor(GetTime() + 180),
				Type = 2,
				Target = "",
				TargetLevel = "",
				Group = 2,
				Gtimer = nil
			}
		)
	elseif Stone == "SpellstoneIn" then
		if self:TimerExisteDeja(NECROSIS_COOLDOWN.Spellstone, Timer.SpellTimer) then
			return Timer
		end
		if self:TimerExisteDeja(NECROSIS_COOLDOWN.SpellstoneIn, Timer.SpellTimer) then
			self:RetraitTimerParNom(NECROSIS_COOLDOWN.SpellstoneIn, Timer.SpellTimer, Timer.TimerTable)
		end
		Timer.SpellTimer:insert(
			{
				Name = NECROSIS_COOLDOWN.SpellstoneIn,
				Time = 30,
				TimeMax = floor(GetTime() + 30),
				Type = 2,
				Target = "",
				TargetLevel = "",
				Group = 2,
				Gtimer = nil
			}
		)
	elseif Stone == "Spellstone" then
		Timer.SpellTimer:insert(
			{
				Name = NECROSIS_COOLDOWN.Spellstone,
				Time = 180,
				TimeMax = floor(GetTime() + 180),
				Type = 2,
				Target = "",
				TargetLevel = "",
				Group = 2,
				Gtimer = nil
			}
		)
	elseif Stone == "Soulstone" then
		Timer.SpellTimer:insert(
			{
				Name = Necrosis.Spell[11].Name,
				Time = floor(duration - GetTime() + start),
				TimeMax = floor(start + duration),
				Type = Necrosis.Spell[11].Type,
				Target = "???",
				TargetLevel = "",
				Group = 1,
				Gtimer = nil,
			}
		)
	end

	-- Association d'un timer graphique au timer
	-- Si il y a une frame timer de libérée, on l'associe au timer
	if NecrosisConfig.TimerType == 1 then
		local TimerLibre = nil
		for index, valeur in ipairs(Timer.TimerTable) do
			if not valeur then
				TimerLibre = index
				Timer.TimerTable[index] = true
				break
			end
		end
		-- Si il n'y a pas de frame de libérée, on rajoute une frame
		if not TimerLibre then
			Timer.TimerTable:insert(true)
			TimerLibre = #Timer.TimerTable
		end
		-- Association effective au timer
		Timer.SpellTimer[#Timer.SpellTimer].Gtimer = TimerLibre
		local FontString, StatusBar = self:AddFrame("NecrosisTimerFrame"..TimerLibre)
		FontString:SetText(Timer.SpellTimer[#Timer.SpellTimer].Name)
		StatusBar:SetMinMaxValues(
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax - Timer.SpellTimer[#Timer.SpellTimer].Time,
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax
		)
	end

	if NecrosisConfig.TimerType > 0 then
		-- Tri des entrées par type de sort
		self:Tri(Timer.SpellTimer, "Type")

		-- Création des groupes (noms des mobs) des timers
		Timer.SpellGroup, Timer.SpellTimer = self:Parsing(Timer.SpellGroup, Timer.SpellTimer)

		-- On met à jour l'affichage
		NecrosisUpdateTimer(Timer.SpellTimer, Timer.SpellGroup)
	end

	return Timer
end

-- Pour la création de timers personnels
function NecrosisTimerX(nom, duree, truc, Target, LevelTarget, Timer)

	Timer.SpellTimer:insert(
		{
			Name = nom,
			Time = duree,
			TimeMax = floor(GetTime() + duree),
			Type = truc,
			Target = Target,
			TargetLevel = LevelTarget,
			Group = 0,
			Gtimer = nil
		}
	)

	if NecrosisConfig.TimerType == 1 then
		-- Association d'un timer graphique au timer
		-- Si il y a une frame timer de libérée, on l'associe au timer
		local TimerLibre = nil
		for index, valeur in ipairs(Timer.TimerTable) do
			if not valeur then
				TimerLibre = index
				Timer.TimerTable[index] = true
				break
			end
		end
		-- Si il n'y a pas de frame de libérée, on rajoute une frame
		if not TimerLibre then
			Timer.TimerTable:insert(true)
			TimerLibre = #Timer.TimerTable
		end
		-- Association effective au timer
		Timer.SpellTimer[#Timer.SpellTimer].Gtimer = TimerLibre
		local FontString, StatusBar = self:AddFrame("NecrosisTimerFrame"..TimerLibre)
		FontString:SetText(Timer.SpellTimer[#Timer.SpellTimer].Name)
		StatusBar:SetMinMaxValues(
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax - Timer.SpellTimer[#Timer.SpellTimer].Time,
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax
		)
	end

	if NecrosisConfig.TimerType > 0 then
		-- Tri des entrées par type de sort
		self:Tri(Timer.SpellTimer, "Type")

		-- Création des groupes (noms des mobs) des timers
		Timer.SpellGroup, Timer.SpellTimer = self:Parsing(Timer.SpellGroup, Timer.SpellTimer)

		-- On met à jour l'affichage
		NecrosisUpdateTimer(Timer.SpellTimer, Timer.SpellGroup)
	end

	return Timer
end

------------------------------------------------------------------------------------------------------
-- FONCTIONS DE RETRAIT
------------------------------------------------------------------------------------------------------

-- Connaissant l'index du Timer dans la liste, on le supprime
function Necrosis:RetraitTimerParIndex(index, Timer)

	if NecrosisConfig.TimerType > 0 then
		-- Suppression du timer graphique
		if NecrosisConfig.TimerType == 1 and Timer.SpellTimer[index] then
			Timer.TimerTable[Timer.SpellTimer[index].Gtimer] = false
			_G["NecrosisTimerFrame"..Timer.SpellTimer[index].Gtimer]:Hide()
		end

		-- Suppression du timer du groupe de mob
		if Timer.SpellTimer[index] and Timer.SpellGroup[Timer.SpellTimer[index].Group] then
			if Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible  then
				Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible = Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible - 1
				-- On cache la Frame des groupes si elle est vide
				if Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible <= 0 then
					local frameGroup = _G["NecrosisSpellTimer"..Timer.SpellTimer[index].Group]
					if frameGroup then frameGroup:Hide() end
				end
			end
		end
	end

	-- On enlève le timer de la liste
	Timer.SpellTimer:remove(index)

	-- On met à jour l'affichage
	NecrosisUpdateTimer(Timer.SpellTimer, Timer.SpellGroup)

	return Timer
end

-- Si on veut supprimer spécifiquement un Timer...
function Necrosis:RetraitTimerParNom(name, Timer)
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index].Name == name then
			Timer = self:RetraitTimerParIndex(index, Timer)
			break
		end
	end
	return Timer
end

-- Fonction pour enlever les timers de combat lors de la regen
function Necrosis:RetraitTimerCombat(Timer)
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index] then
			-- Si les cooldowns sont nominatifs, on enlève le nom
			if Timer.SpellTimer[index].Type == 3 then
				Timer.SpellTimer[index].Target = ""
				Timer.SpellTimer[index].TargetLevel = ""
			end
			-- Enlevage des timers de combat
			if Timer.SpellTimer[index].Type == 4
				or Timer.SpellTimer[index].Type == 5
				or Timer.SpellTimer[index].Type == 6
				then
					Timer = self:RetraitTimerParIndex(index, Timer)
			end
		end
	end

	if NecrosisConfig.TimerType > 0 then
		local index = 4
		while #Timer.SpellGroup >= 4 do
			if _G["NecrosisSpellTimer"..index] then _G["NecrosisSpellTimer"..index]:Hide() end
			Timer.SpellGroup:remove()
			index = index + 1
		end
	end

	return Timer
end



------------------------------------------------------------------------------------------------------
-- FONCTIONS BOOLEENNES
------------------------------------------------------------------------------------------------------

function Necrosis:TimerExisteDeja(Nom, SpellTimer)
	for index = 1, #SpellTimer, 1 do
		if SpellTimer[index].Name == Nom then
			return true;
		end
	end
	return false;
end


------------------------------------------------------------------------------------------------------
-- FONCTIONS DE TRI
------------------------------------------------------------------------------------------------------

-- On définit les groupes de chaque Timer
function Necrosis:Parsing(SpellGroup, SpellTimer)
	for index = 1, #SpellTimer, 1 do
		if SpellTimer[index].Group == 0 then
			local GroupeOK = false
			for i = 1, #SpellGroup, 1 do
				if ((SpellTimer[index].Type == i) and (i <= 3)) or
				   (SpellTimer[index].Target == SpellGroup[i].Name
					and SpellTimer[index].TargetLevel == SpellGroup[i].SubName)
					then
					GroupeOK = true
					SpellTimer[index].Group = i
					SpellGroup[i].Visible = SpellGroup[i].Visible + 1
					break
				end
			end
			-- Si le groupe n'existe pas, on en crée un nouveau
			if not GroupeOK then
				SpellGroup:insert(
					{
						Name = SpellTimer[index].Target,
						SubName = SpellTimer[index].TargetLevel,
						Visible = 1
					}
				)
				SpellTimer[index].Group = #SpellGroup
			end
		end
	end

	self:Tri(SpellTimer, "Group")
	return SpellGroup, SpellTimer
end

-- On trie les timers selon leur groupe
function Necrosis:Tri(SpellTimer, clef)
	return SpellTimer:sort(
		function (SubTab1, SubTab2)
			return SubTab1[clef] < SubTab2[clef]
		end)
end