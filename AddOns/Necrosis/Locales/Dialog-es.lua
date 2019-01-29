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
-- Version $LastChangedDate: 2007-01-26 20:37:37 +0100 (ven., 26 janv. 2007) $
------------------------------------------------------------------------------------------------------


------------------------------------------------
-- SPANISH VERSION TEXTS --
------------------------------------------------

function Necrosis:Localization_Dialog_Es()

	function Necrosis:Localization()
		self:Localization_Speech_Es()
	end

	NECROSIS_COOLDOWN = {
		["SpellstoneIn"] = "Piedra de Hechizo equipada",
		["Spellstone"] = "Tiempo de regeneraci\195\179n Piedra de Hechizo",
		["Healthstone"] = "Tiempo de regeneraci\195\179n Piedra de Salud"
	}

	NecrosisTooltipData = {
		["Main"] = {
			Label = "|c00FFFFFFNecrosis|r",
			Stone = {
				[true] = "S\195\173",
				[false] = "No",
			},
			Hellspawn = {
				[true] = "Activar",
				[false] = "Desactivar",
			},
			["Soulshard"] = "Fragmento(s) de Alma: ",
			["InfernalStone"] = "Piedra(s) Infernal(es): ",
			["DemoniacStone"] = "Figura(s) Demon\195\173aca(s): ",
			["Soulstone"] = "\nPiedra de Alma: ",
			["Healthstone"] = "Piedra de Salud: ",
			["Spellstone"] = "Piedra de Hechizo: ",
			["Firestone"] = "Piedra de Fuego: ",
			["CurrentDemon"] = "Demonio: ",
			["EnslavedDemon"] = "Demonio: Esclavizado ",
			["NoCurrentDemon"] = "Demonio: Ninguno",
		},
		["Soulstone"] = {
			Label = "|c00FF99FFPiedra de Alma|r",
			Text = {"Click derecho para crear","Click izquierdo para usar","Usada\nClick derecho para recrear","Esperando"}
		},
		["Healthstone"] = {
			Label = "|c0066FF33Piedra de Salud|r",
			Text = {"Click derecho para crear","Click izquierdo para usar"},
			Text2 = "Click central o Ctrl+Click izquierdo para comerciar",
			Ritual = "|c00FFFFFFShift+Click para empezar el Ritual de Almas|r"
		},
		["Spellstone"] = {
			Label = "|c0099CCFFPiedra de Hechizo|r",
			Text = {"Click derecho para crear","En el inventario\nClick central o Ctrl+Click izquierdo para equipar ","Equipado - Click izquierdo para usar\n Shift+Click para desequipar"}
		},
		["Firestone"] = {
			Label = "|c00FF4444Piedra de Fuego|r",
			Text = {"Click derecho para crear","En el inventario\nClick izquierdo para equipar","Equipado - Shift+Click para desequipar"}
		},
		["SpellTimer"] = {
			Label = "|c00FFFFFFDuraci\195\179n de Hechizos|r",
			Text = "Hechizos activos en el objetivo",
			Right = "Click derecho para usar Piedra de Hogar a "
		},
		["ShadowTrance"] = {
			Label = "|c00FFFFFFTrance de las Sombras|r"
		},
		["Backlash"] = {
			Label = "|c00FFFFFFBacklash|r"
		},
		["Domination"] = {
			Label = "|c00FFFFFFDominio vil|r"
		},
		["Enslave"] = {
			Label = "|c00FFFFFFEsclavizar|r"
		},
		["Armor"] = {
			Label = "|c00FFFFFFArmadura Demon\195\173aca|r"
		},
		["FelArmor"] = {
			Label = "|c00FFFFFFFel Armor|r"
		},
		["Invisible"] = {
			Label = "|c00FFFFFFDetectar Invisibilidad|r"
		},
		["Aqua"] = {
			Label = "|c00FFFFFFAliento Inagotable|r"
		},
		["Kilrogg"] = {
			Label = "|c00FFFFFFOjo de Kilrogg|r"
		},
		["Banish"] = {
			Label = "|c00FFFFFFDesterrar|r",
			Text = "Click derecho para invocar Rango 1"
		},
		["TP"] = {
			Label = "|c00FFFFFFRitual de Invocaci\195\179n|r"
		},
		["SoulLink"] = {
			Label = "|c00FFFFFFEnlace de Alma|r"
		},
		["ShadowProtection"] = {
			Label = "|c00FFFFFFResguardo contra las Sombras|r"
		},
		["Imp"] = {
			Label = "|c00FFFFFFDiablillo|r"
		},
		["Voidwalker"] = {
			Label = "|c00FFFFFFAbisario|r"
		},
		["Succubus"] = {
			Label = "|c00FFFFFFS\195\186cubo|r"
		},
		["Felhunter"] = {
			Label = "|c00FFFFFFMan\195\161fago|r"
		},
		["Felguard"] = {
			Label = "|c00FFFFFFGuardia maldito|r"
		},
		["Infernal"] = {
			Label = "|c00FFFFFFInferno|r"
		},
		["Doomguard"] = {
			Label = "|c00FFFFFFGuardia Apocal\195\173ptico|r"
		},
		["Sacrifice"] = {
			Label = "|c00FFFFFFSacrificio Demon\195\173aco|r"
		},
		["Amplify"] = {
			Label = "|c00FFFFFFAmplificar Maldici\195\179n|r"
		},
		["Weakness"] = {
			Label = "|c00FFFFFFMaldici\195\179n de Debilidad|r"
		},
		["Agony"] = {
			Label = "|c00FFFFFFMaldici\195\179n de Agon\195\173a|r"
		},
		["Reckless"] = {
			Label = "|c00FFFFFFMaldici\195\179n de la Temeridad|r"
		},
		["Tongues"] = {
			Label = "|c00FFFFFFMaldici\195\179n de la Lengua|r"
		},
		["Exhaust"] = {
			Label = "|c00FFFFFFMaldici\195\179n de Agotamiento|r"
		},
		["Elements"] = {
			Label = "|c00FFFFFFMaldici\195\179n de los Elementos|r"
		},
		["Shadow"] = {
			Label = "|c00FFFFFFMaldici\195\179n de las Sombras|r"
		},
		["Doom"] = {
			Label = "|c00FFFFFFMaldici\195\179n del Apocalipsis|r"
		},
		["Mount"] = {
			Label = "|c00FFFFFFCorcel|r",
			Text = "Click derecho para lanzar Rango 1"
		},
		["BuffMenu"] = {
			Label = "|c00FFFFFFMen\195\186 de Hechizos|r",
			Text = "Click Derecho para mantener el men\195\186 abierto",
			Text2 = "Modo autom\195\161tico: Se cierra cuando sales de combate",
		},
		["PetMenu"] = {
			Label = "|c00FFFFFFMen\195\186 de Demonio|r",
			Text = "Click Derecho para mantener el men\195\186 abierto",
			Text2 = "Modo autom\195\161tico: Se cierra cuando sales de combate",
		},
		["CurseMenu"] = {
			Label = "|c00FFFFFFMen\195\186 de Maldici\195\179n|r",
			Text = "Click Derecho para mantener el men\195\186 abierto",
			Text2 = "Modo autom\195\161tico: Se cierra cuando sales de combate",
		},
		["Radar"] = {
			Label = "|c00FFFFFFCaptar Demonios|r"
		},
		["AmplifyCooldown"] = "Click Derecho para amplificar maldici\195\179n",
		["DominationCooldown"] = "Click Derecho para invocaci\195\179n r\195\161pida",
	};

	NECROSIS_SOUND = {
		["Fear"] = "Interface\\AddOns\\Necrosis\\sounds\\Fear-En.mp3",
		["SoulstoneEnd"] = "Interface\\AddOns\\Necrosis\\sounds\\SoulstoneEnd-En.mp3",
		["EnslaveEnd"] = "Interface\\AddOns\\Necrosis\\sounds\\EnslaveDemonEnd-En.mp3",
		["ShadowTrance"] = "Interface\\AddOns\\Necrosis\\sounds\\ShadowTrance-En.mp3",
		["Backlash"] = "Interface\\AddOns\\Necrosis\\sounds\\Backlash-Fr.mp3",
	};

	NECROSIS_PROC_TEXT = {
		["ShadowTrance"] = "<white>Tr<lightPurple1>a<lightPurple2>n<purple>c<darkPurple1>e<darkPurple2> de las S<darkPurple1>o<purple>m<lightPurple2>b<lightPurple1>r<white>as",
		["Backlash"] = "<white>B<lightPurple1>a<lightPurple2>c<purple>k<darkPurple1>l<darkPurple2>a<darkPurple1>s<purple>h"
	};


	NECROSIS_MESSAGE = {
		["Bag"] = {
			["FullPrefix"] = "\194\161 Tu ",
			["FullSuffix"] = " est\195\161 llena !",
			["FullDestroySuffix"] = " est\195\161 llena; \194\161 Los pr\195\179ximos Fragmentos de Alma ser\195\161n destruidos !",
		},
		["Interface"] = {
			["Welcome"] = "<white>\194\161 /necro para mostrar el men\195\186 de preferencias !",
			["TooltipOn"] = "Consejos detallados activados" ,
			["TooltipOff"] = "Consejos detallados desactivados",
			["MessageOn"] = "Mensaje Chat activado",
			["MessageOff"] = "Mensaje Chat desactivado",
			["DefaultConfig"] = "<lightYellow>Configuraci\195\179n por defecto cargada.",
			["UserConfig"] = "<lightYellow>Configuraci\195\179n cargada."
		},
		["Help"] = {
			"/necro <lightOrange>recall<white> -- <lightBlue>Centrar Necrosis y todos los botones en el medio de la pantalla",
			"/necro <lightOrange>reset<white> -- <lightBlue>Reinicia Necrosis entero",
		},
		["Information"] = {
			["FearProtect"] = "\194\161\194\161\194\161 Tu objetivo tiene una protecci\195\179n contra miedo !!!",
			["EnslaveBreak"] = "Tu demonio rompi\195\179 sus cadenas...",
			["SoulstoneEnd"] = "<lightYellow>Tu Piedra de Alma se ha disipado."
		}
	};


	-- Gestion XML - Menu de configuration
	Necrosis.Config.Panel = {
		"Opci\195\179nes de Mensaje",
		"Opci\195\179nes de la Esfera",
		"Opci\195\179nes de Bot\195\179n",
		"Opci\195\179nes de Men\195\186s",
		"Opci\195\179nes de Temporizador",
		"Miscel\195\161neos"
	}

	Necrosis.Config.Messages = {
		["Position"] = "<- Los mensajes de Sistema de Necrosis aparecer\195\161n aqu\195\173 ->",
		["Afficher les bulles d'aide"] = "Mostrar consejos detallados",
		["Afficher les messages dans la zone systeme"] = "Mensajes de Necrosis como mensajes de sistema",
		["Activer les messages aleatoires de TP et de Rez"] = "Activar discursos aleatorios",
		["Utiliser des messages courts"] = "Usar mensajes cortos",
		["Activer egalement les messages pour les Demons"] = "Activar discursos aleatorios (demonio)",
		["Activer egalement les messages pour les Montures"] = "Activar discursos aleatorios (corcel)",
		["Activer les sons"] = "Activar sonidos",
		["Alerter quand la cible est insensible a la peur"] = "Av\195\173same cuando mi objetivo no pueda ser asustado",
		["Alerter quand la cible peut etre banie ou asservie"] = "Av\195\173same cuando mi objetivo pueda ser desterrado o esclavizado",
		["M'alerter quand j'entre en Transe"] = "Al\195\169rtame cuando entre en un Trance",
	}

	Necrosis.Config.Sphere = {
		["Taille de la sphere"] = "Tama\195\177o del bot\195\179n Necrosis",
		["Skin de la pierre Necrosis"] = "Color de la Esfera Necrosis",
		["Evenement montre par la sphere"] = "Evento mostrado en la Esfera",
		["Sort caste par la sphere"] = "Hechizo lanzado desde la Esfera",
		["Afficher le compteur numerique"] = "Mostrar la contabilizaci\195\179n de Fragmentos en Necrosis",
		["Type de compteur numerique"] = "Tipo de Piedra contabilizada"
	}
	Necrosis.Config.Sphere.Colour = {
		"Rosa",
		"Azul",
		"Naranja",
		"Turquesa",
		"P\195\186rpura",
		"666",
		"X"
	}
	Necrosis.Config.Sphere.Count = {
		"Fragmentos de Alma",
		"Piedras de invocaci\195\179n de Demonios",
		"Temporizador de Resurrecci\195\179n",
		"Man\195\161",
		"Salud"
	}

	Necrosis.Config.Buttons = {
		["Rotation des boutons"] = "Rotaci\195\179n de los botones",
		["Fixer les boutons autour de la sphere"] = "Fijar los botones alrededor de la Esfera"
	}
	Necrosis.Config.Buttons.Name = {
		"Mostrar bot\195\179n Piedra de Fuego",
		"Mostrar bot\195\179n Piedra de Hechizo",
		"Mostrar bot\195\179n Piedra de Salud",
		"Mostrar bot\195\179n Piedra de Alma",
		"Mostrar bot\195\179n del men\195\186 Hechizos",
		"Mostrar bot\195\179n Corcel",
		"Mostrar bot\195\179n del men\195\186 Demonio",
		"Mostrar bot\195\179n del men\195\186 Maldici\195\179n",
	}

	Necrosis.Config.Menus = {
		["Options Generales"] = "Opciones Generales",
		["Menu des Buffs"] = "Men\195\186 de Hechizos",
		["Menu des Demons"] = "Men\195\186 de Demonios",
		["Menu des Maledictions"] = "Men\195\186 de Maldiciones",
		["Afficher les menus en permanence"] = "Mostrar los men\195\186s siempre",
		["Afficher automatiquement les menus en combat"] = "Abrir autom\195\161ticamente los men\195\186s mientras est\195\169s en combate",
		["Fermer le menu apres un clic sur un de ses elements"] = "Cerrar el men\195\186 cuando pulses uno de sus botones",
		["Orientation du menu"] = "Orientaci\195\179n de men\195\186s",
		["Changer la symetrie verticale des boutons"] = "Cambiar la simetr\195\173a vertical de los botones",
		["Taille du bouton Banir"] = "Tama\195\177o del bot\195\179n Desterrar",
	}
	Necrosis.Config.Menus.Orientation = {
		"Horizontal",
		"Hacia arriba",
		"Hacia abajo"
	}

	Necrosis.Config.Timers = {
		["Type de timers"] = "Tipo de temporizadores",
		["Afficher le bouton des timers"] = "Mostrar el bot\195\179n de los temporizadores",
		["Afficher les timers sur la gauche du bouton"] = "Mostrar los temporizadores a la izquierda del bot\195\179n",
		["Afficher les timers de bas en haut"] = "Los temporizadores se incrementan ascendentemente",
	}
	Necrosis.Config.Timers.Type = {
		"Ninguno",
		"Modo Gr\195\161fico",
		"Modo texto"
	}

	Necrosis.Config.Misc = {
		["Deplace les fragments"] = "Poner los Fragmentos en la bolsa seleccionada.",
		["Detruit les fragments si le sac plein"] = "Destruir nuevos fragmentos si la bolsa est\195\161 llena",
		["Choix du sac contenant les fragments"] = "Selecci\195\179n de Contenedor de Fragmentos de Alma",
		["Nombre maximum de fragments a conserver"] = "N\195\186mero m\195\161ximo de fragmentos a guardar",
		["Verrouiller Necrosis sur l'interface"] = "Bloquear Necrosis",
		["Afficher les boutons caches"] = "Perm\195\173teme ver los botones ocultos para arrastrarlos",
		["Taille des boutons caches"] = "Tama\195\177o de los botones de aviso"
	}

	NECROSIS_BINDING = {
		["Current"] = " est\195\161 actualmente asignado a ",
		["Confirm"] = "¿Quieres asignar ",
		["To"] = " a ",
		["Yes"] = "S\195\173",
		["No"] = "No",
		["InCombat"] = "Lo siento, no puedes cambiar la asignaci\195\179n de teclas mientras est\195\169s en combate.",
		["Binding"] = "Asignaciones",
		["Unbind"] = "Desasignar",
		["Cancel"] = "Cancelar",
		["Press"] = "Presiona la tecla a asignar...\n\n",
		["Now"] = "Actualmente: ",
		["NotBound"] = "No asignado",
	};

end
