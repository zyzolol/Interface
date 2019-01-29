---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2007  Prat Development Team
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to:
--
-- Free Software Foundation, Inc., 
-- 51 Franklin Street, Fifth Floor, 
-- Boston, MA  02110-1301, USA.
--
--
-------------------------------------------------------------------------------



--[[
Name: PratPlayerNames
Revision: $Revision: 79185 $
Author(s): Curney (asml8ed@gmail.com)
           Krtek (krtek4@gmail.com)
Inspired by: idChat2_PlayerNames by Industrial
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/Integrated_Modules#PlayerNames
SVN: http://svn.wowace.com/wowace/trunk/Prat/
Description: Module for Prat that adds player name options.
Dependencies: Prat
]]

-- Get Utility Libraries
local util, DBG, CLR = GetPratUtils()

local LIB = PRATLIB
local PRAT_LIBRARY = PRAT_LIBRARY
local PRAT_MODULE = Prat:RequestModuleName("PlayerNames")

if PRAT_MODULE == nil then 
    return 
end
local loc = PRAT_LIBRARY(LIB.LOCALIZATION)
local L = loc[PRATLIB.NEWLOCALENAMESPACE](loc, PRAT_MODULE)

L[LIB.NEWLOCALE](L, "enUS", function() return {
    ["PlayerNames"] = true,
    ["Player name formating options."] = true,
    ["Brackets"] = true,
    ["Square"] = true,
    ["Angled"] = true,
    ["None"] = true,
    ["Class"] = true,
    ["Random"] = true,
	["Reset Settings"] = true,
	["No additional coloring"] = true,
	["Restore default settings, and delete stored character data."] = true,
    ["Sets style of brackets to use around player names."] = true,
    ["Unknown Use Common Color"] = true,
    ["Toggle using a common color for unknown player names."] = true,
    ["Unknown Common Color"] = true,
    ["Set common color of unknown player names."] = true,
    ["Enable TabComplete"] = true,
    ["Toggle tab completion of player names."] = true,
	["Show Level"] = true,
    ["Toggle level showing."] = true,
    ["Level Color Mode"] = true,
    ["Use Player Color"] = true, 
    ["Use Channel Color"]  = true, 
    ["Color by Level Difference"] = true,
    ["How to color other player's level."] = true,
	["Show Group"] = true,
    ["Toggle raid group showing."] = true,
    ["Keep Info"] = true,
    ["Keep Lots Of Info"] = true,
    ["Keep player information between session for all players except cross-server players"] = true,
    ["Keep player information between session, but limit it to friends and guild members."] = true,
    ["Player Color Mode"] = true,
    ["How to color player's name."] = true,
	["Unknown Common Color From TasteTheNaimbow"] = true,
    ["Let TasteTheNaimbow set the common color for unknown player names."] = true,   
	["Enable Alt-Invite"] = true,
    ["Toggle group invites by alt-clicking on player name."] = true,
    ["Enable Invite Links"] = true,
	["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = true,
    ["Brackets Common Color"] = true,
    ["Sets common color of brackets to use around player names."] = true,
    ["Brackets Use Common Color"] = true,
    ["Toggle using a common color for brackets around player names."] = true,
    ["linkifycommon_name"] = "Linkify Common Messages",
    ["linkifycommon_desc"] = "Linkify Common Messages",
    ["Prat_PlayerNames: Stored Player Data Cleared"] = true,
    ["Tab completion : "] = true,
    ["Tab completion : Too many matches (%d possible)"] = true,
    ["Actively Query Player Info"] = true,
    ["Query the server for all player names we do not know. Note: This happpens pretty slowly, and this data is not saved."] = true,    
} end)

--[[
	Chinese Local : CWDG Translation Team 昏睡墨鱼 (Thomas Mo)
	CWDG site: http://Cwowaddon.com
	$Rev: 79185 $
]]

L[LIB.NEWLOCALE](L, "zhCN", function() return {
	["PlayerNames"] = "玩家姓名",
	["Player name formating options."] = "玩家姓名格式选项.",
	["Brackets"] = "圆弧",
	["Square"] = "方形",
	["Angled"] = "折角",
	["None"] = "无",
	["Class"] = "职业",
	["Random"] = "随机",
	["Reset Settings"] = "重置设置",
	["No additional coloring"] = "无附加颜色",
	["Restore default settings, and delete stored character data."] = "恢复默认设置, 删除保存的角色数据.",
	["Sets style of brackets to use around player names."] = "设置玩家姓名括号样式.",
	["Unknown Use Common Color"] = "使用特殊颜色",
	["Toggle using a common color for unknown player names."] = "未知玩家姓名使用特殊颜色",
	["Unknown Common Color"] = "设置特殊颜色",
	["Set common color of unknown player names."] = "改变玩家姓名特殊颜色",
	["Enable TabComplete"] = "标签",
	["Toggle tab completion of player names."] = "为玩家姓名作标签.",
	["Show Level"] = "显示等级",
	["Toggle level showing."] = "人物等级显示.",
    ["Level Color Mode"] = "等级颜色模式",
    ["Use Player Color"] = "使用玩家等级",
    ["Use Channel Color"]  = "使用频道颜色",
    ["Color by Level Difference"] = "不同等级颜色",
    ["How to color other player's level."] = "其他玩家等级颜色设置.",
	["Show Group"] = "显示小组",
	["Toggle raid group showing."] = "团队小组显示.",
	["Keep Info"] = "保留信息",
	["Keep Lots Of Info"] = "保留多数信息",
	["Keep player information between session for all players except cross-server players"] = "保留除跨服外的全部角色信息.",
	["Keep player information between session, but limit it to friends and guild members."] = "保留玩家信息, 仅限于好友和公会成员.",
	["Player Color Mode"] = "颜色模式",
	["How to color player's name."] = "玩家姓名颜色.",
	["Unknown Common Color From TasteTheNaimbow"] = "TasteTheNaimbow 的通用颜色",
    ["Let TasteTheNaimbow set the common color for unknown player names."] = "使用 TasteTheNaimbow 设置未知玩家颜色",
	["Enable Alt-Invite"] = "开启 <Alt> 邀请",
    ["Toggle group invites by alt-clicking on player name."] = "按下 <Alt> 键点击邀请玩家",
    ["Enable Invite Links"] = "开启邀请链接",
	["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "按下 <Alt> 键点击超链接关键词邀请玩家",
    ["Brackets Common Color"] = "括号颜色",
    ["Sets common color of brackets to use around player names."] = "设置指示玩家名字括号的颜色",
    ["Brackets Use Common Color"] = "括号使用通用颜色",
    ["Toggle using a common color for brackets around player names."] = "指示玩家名字的括号使用通用颜色.",
    ["linkifycommon_name"] = "链接通用信息",
    ["linkifycommon_desc"] = "链接通用信息",
    ["Prat_PlayerNames: Stored Player Data Cleared"] = "Prat_PlayerNames: 已删除储存的玩家资料",
    ["Tab completion : "] = "Tab 补齐 : ",
    ["Tab completion : Too many matches (%d possible)"] = "Tab 补齐 : 存在太多 (%d) 符合的名字",
    ["Actively Query Player Info"] = "自动查询玩家信息",
    ["Query the server for all player names we do not know. Note: This happpens pretty slowly, and this data is not saved."] = "主动查询服务器未知玩家的信息。注意: 这是个很慢的操作指令，这些信息也不会被储存。",    

} end)

L[LIB.NEWLOCALE](L, "koKR", function() return {
    ["PlayerNames"] = "플레이어명",
    ["Player name formating options."] = "플레이어명 형식을 설정합니다.",
    ["Brackets"] = "괄호",
    ["Square"] = "사각형",
    ["Angled"] = "각진형",
    ["None"] = "없음",
    ["Class"] = "직업",
    ["Random"] = "무작위",
    ["Reset Settings"] = "설정 초기화",
    ["No additional coloring"] = "색상 미사용",
    ["Restore default settings, and delete stored character data."] = "기본 설정을 복원하고 저장된 케릭터 데이터를 삭제합니다.",
    ["Sets style of brackets to use around player names."] = "플레이어명 주위 괄호의 스타일을 설정합니다.",
    ["Unknown Use Common Color"] = "공통 색상 사용",
    ["Toggle using a common color for unknown player names."] = "알려지지 않은 플레이어명에 대해 공통 색상을 사용합니다.",
    ["Unknown Common Color"] = "공통 색상 설정",
    ["Set common color of unknown player names."] = "플레이어명의 공통 색상을 설정합니다.",
    ["Enable TabComplete"] = "탭완성 사용",
    ["Toggle tab completion of player names."] = "플레이어명의 탭 완성기능을 사용합니다.",
    ["Show Level"] = "레벨 표시",
    ["Toggle level showing."] = "레벨을 표시합니다.",
    ["Level Color Mode"] = "레벨 색상 모드",
    ["Use Player Color"] = "플레이어 색상 사용", 
    ["Use Channel Color"]  = "채널 색상 사용", 
    ["Color by Level Difference"] = "레벨 차이에 의한 색상",
    ["How to color other player's level."] = "다른 플레이어의 레벨 색상 표시 방법을 설정합니다.",
    ["Show Group"] = "파티 표시",
    ["Toggle raid group showing."] = "공격대 내의 파티 번호를 표시합니다.",
    ["Keep Info"] = "정보 유지",
    ["Keep Lots Of Info"] = "각종 정보 유지",
    ["Keep player information between session for all players except cross-server players"] = "서버가 다른 플레이어를 제외하고 모든 플레이어에 대해 접속간 플레이어 정보를 유지합니다.",
    ["Keep player information between session, but limit it to friends and guild members."] = "접속간 플레이어 정보를 유지합니다. 친구와 길드원에 한함.",
    ["Player Color Mode"] = "플레이어 색상 모드",
    ["How to color player's name."] = "플레이어의 이름 색상을 변경합니다.",
    ["Unknown Common Color From TasteTheNaimbow"] = "TasteTheNaimbow의 공통 색상을 사용합니다.",
    ["Let TasteTheNaimbow set the common color for unknown player names."] = "알려지지 않은 플레이어 이름에 대한 공통 색상 설정을 TasteTheNaimbow가 하도록 합니다.",
    ["Enable Alt-Invite"] = "ALT-초대 사용",
    ["Toggle group invites by alt-clicking on player name."] = "플레이어 이름에 ALT-클릭으로 초대합니다.",
    ["Enable Invite Links"] = "링크 초대 사용",
    ["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "'초대'같은 키워드로 된 링크를 ALT-클릭으로 초대합니다.",
    ["Brackets Common Color"] = "괄호 공통 색상",
    ["Sets common color of brackets to use around player names."] = "플레이어 이름 주변에 사용할 괄호의 공통 색상을 설정합니다.",
    ["Brackets Use Common Color"] = "괄호 공통 색상 사용",
    ["Toggle using a common color for brackets around player names."] = "플레이어 이름 주변에 사용되는 괄호에 공통 색상을 사용합니다.",
    ["linkifycommon_name"] = "링크가능한 일반 메세지",
    ["linkifycommon_desc"] = "링크가능한 일반 메세지",
    ["Prat_PlayerNames: Stored Player Data Cleared"] = "Prat_PlayerNames: Stored Player Data Cleared",
    ["Tab completion : "] = "탭 완성 : ",
    ["Tab completion : Too many matches (%d possible)"] = "탭 완성 : 너무 많이 일치함 (%d개 이용 가능)",
    ["Actively Query Player Info"] = "Actively Query Player Info",
    ["Query the server for all player names we do not know. Note: This happpens pretty slowly, and this data is not saved."] = "Query the server for all player names we do not know. Note: This happpens pretty slowly, and this data is not saved.",    
} end)

L[LIB.NEWLOCALE](L, "zhTW", function() return {
    ["PlayerNames"] = "玩家名字",
    ["Player name formating options."] = "玩家名字格式選項。",
    ["Brackets"] = "括弧",
    ["Square"] = "方形",
    ["Angled"] = "折角",
    ["None"] = "無",
    ["Class"] = "職業",
    ["Random"] = "隨機",
	["Reset Settings"] = "重設",
	["No additional coloring"] = "沒有額外著色。",
	["Restore default settings, and delete stored character data."] = "重設回預設設定，並刪除已儲存的玩家資料。",
    ["Sets style of brackets to use around player names."] = "設定包圍玩家名字的括號。",
    ["Unknown Use Common Color"] = "未知玩家使用共用顏色",
    ["Toggle using a common color for unknown player names."] = "切換未知玩家名字是否使用共用顏色。",
    ["Unknown Common Color"] = "未知玩家共用顏色",
    ["Set common color of unknown player names."] = "改變未知玩家名字的共用顏色。",
    ["Enable TabComplete"] = "啟用補齊",
    ["Toggle tab completion of player names."] = "切換是否開啟Tab鍵補齊功能，為玩家名字作補齊。",
	["Show Level"] = "顯示等級",
    ["Toggle level showing."] = "人物等級顯示。",
    ["Level Color Mode"] = "等級顏色模式",
    ["Use Player Color"] = "使用玩家顏色", 
    ["Use Channel Color"]  = "使用頻道顏色", 
    ["Color by Level Difference"] = "依等級差距著色",
    ["How to color other player's level."] = "如何為其他玩家的等級著色。",
	["Show Group"] = "顯示小隊",
    ["Toggle raid group showing."] = "團隊小隊顯示。",
    ["Keep Info"] = "保存資訊",
    ["Keep Lots Of Info"] = "保存大量資訊",
    ["Keep player information between session for all players except cross-server players"] = "保存所有玩家資訊但不含跨伺服器的玩家。",
    ["Keep player information between session, but limit it to friends and guild members."] = "保存玩家資訊，但僅限於好友及公會會員。",
    ["Player Color Mode"] = "玩家顏色模式",
    ["How to color player's name."] = "如何為玩家名字著色。",
	["Unknown Common Color From TasteTheNaimbow"] = "TasteTheNaimbow 的未知玩家共用顏色",
    ["Let TasteTheNaimbow set the common color for unknown player names."] = "讓 TasteTheNaimbow 插件設定未知玩家名字的共用顏色。",   
	["Enable Alt-Invite"] = "啟用Alt-邀請",
    ["Toggle group invites by alt-clicking on player name."] = "使用Alt-左擊聊天視窗內的玩家名字可邀請玩家組隊。",
    ["Enable Invite Links"] = "啟用邀請連結",
	["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "使用Alt-左擊關鍵字連結可邀請玩家組隊，例如「邀請」。",
    ["Brackets Common Color"] = "括弧共用顏色",
    ["Sets common color of brackets to use around player names."] = "改變包圍玩家名字的括號共用顏色。",
    ["Brackets Use Common Color"] = "括弧使用共用顏色",
    ["Toggle using a common color for brackets around player names."] = "切換括弧是否使用共用顏色。",
    ["linkifycommon_name"] = "連結化公共資訊",
    ["linkifycommon_desc"] = "連結化公共資訊。",
    ["Prat_PlayerNames: Stored Player Data Cleared"] = "Prat_PlayerNames: 已刪除儲存的玩家資料",
    ["Tab completion : "] = "Tab鍵補齊 : ",
    ["Tab completion : Too many matches (%d possible)"] = "Tab鍵補齊 : 太多 (%d) 符合的名字",
    ["Actively Query Player Info"] = "主動查詢玩家資訊",
    ["Query the server for all player names we do not know. Note: This happpens pretty slowly, and this data is not saved."] = "主動查詢伺服器未知玩家的資訊。注意: 這是個很慢的操作指令，這些資訊也不會被儲存。",    
} end)

L[LIB.NEWLOCALE](L, "esES", function() return {
    ["PlayerNames"] = "Nombres de Jugador",
    ["Player name formating options."] = "Opciones de formateado de nombres de jugador",
    ["Brackets"] = "Par\195\169ntesis",
    ["Square"] = "Corchetes",
    ["Angled"] = "Llaves",
    ["None"] = "Ninguno",
    ["Class"] = "Clase",
    ["Random"] = "Aleatorio",
    ["Sets style of brackets to use around player names."] = "Establece el estilo de los par\195\169ntesis a usar alrededor de los nombres de jugador",
    ["Unknown Use Common Color"] = "Usar color com\195\186n",
    ["Toggle using a common color for unknown player names."] = "Determina si se usa el color com\195\186n para los nombres de jugadores desconocidos",
    ["Unknown Common Color"] = "Establecer color com\195\186n",
    ["Set common color of unknown player names."] = "Cambia el color com\195\186n de los nombres de jugador",
    ["Enable TabComplete"] = "Usar Tab para Completar",
    ["Toggle tab completion of player names."] = "Determina si se usa Tab para completar nombres de jugadores",
	["Show Level"] = "Mostrar Nivel",
    ["Toggle level showing."] = "Determina si se muestra el nivel",
	["Show Group"] = "Mostrar Grupo",
    ["Toggle raid group showing."] = "Determina si se muestra el grupo en banda",
    ["Keep Info"] = "Guardar Info",
    ["Keep Lots Of Info"] = "Guardar Montones de Info",
    ["Keep player information between session for all players except cross-server players"] = "Guarda la informaci\195\179n sobre jugadores entre sesiones para todos los jugadores excepto los de otros servidores",
    ["Keep player information between session, but limit it to friends and guild members."] = "Guarda la informaci\195\179n sobre jugadores entre sesiones, pero lo limita a los amigos y miembros de hermandad",
    ["Player Color Mode"] = "Modo de Color",
    ["How to color player's name."] = "C\195\179mo se colorean los nombres de jugador",
	["Unknown Common Color From TasteTheNaimbow"] = "Color Com\195\186n de TasteTheNaimbow",
    ["Let TasteTheNaimbow set the common color for unknown player names."] = "Permite a TasteTheNaimbow establecer el color de los jugadores desconocidos",
	["Enable Alt-Invite"] = "Activar Alt-Invitar",
    ["Toggle group invites by alt-clicking on player name."] = "Invita a jugadores hacienco Clic+Alt en su nombre en la ventana de chat",
    ["Enable Invite Links"] = "Activar Enlaces de Invitaci\195\179n",
	["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Invita a los jugadores haciendo Clic+Alt en palabras clave enlazadas como 'invitar'",
    ["Brackets Common Color"] = "Color de Par\195\169ntesis",
    ["Sets common color of brackets to use around player names."] = "Establece el color del par\195\169ntesis de los nombres de jugador",
    ["Brackets Use Common Color"] = "Par\195\169ntesis usan color com\195\186n",
    ["Toggle using a common color for brackets around player names."] = "Determina si se usa un color com\195\186n para los par\195\169ntesis de los nombres de jugador",
} end)

L[LIB.NEWLOCALE](L, "deDE", function() return {
    ["PlayerNames"] = "Spieler Namen",
    ["Player name formating options."] = "Spielernamen Formatierungs Optionen.",
    ["Brackets"] = "Winkel",
    ["Square"] = "Quadrat",
    ["Angled"] = "Spitzwinkel",
    ["None"] = "Kein",
    ["Class"] = "Klasse",
    ["Random"] = "Zufall",
    ["Sets style of brackets to use around player names."] = "Setze Typ der Klammern die Spieler Namen umranden.",
    ["Unknown Use Common Color"] = "Nutze allgemeine Farbe",
    ["Toggle using a common color for unknown player names."] = "Aktiviert das benutzen der allgemeinen Farbe f\195\188r Unbekannte Spieler.",
    ["Unknown Common Color"] = "Setze allgemeine Farbe",
    ["Set common color of unknown player names."] = "Allgemeine Farbe der Spielernamen \195\164ndern.",
    ["Enable TabComplete"] = "Benutze Tab Verfolst\195\164ndigen",
    ["Toggle tab completion of player names."] = "Aktiviere Tab Verfolst\195\164ndigen der Spielernamen.",
	["Show Level"] = "Zeige Level",
    ["Toggle level showing."] = "Aktiviere das Anzeigen des Levels.",
	["Show Group"] = "Zeige Gruppe",
    ["Toggle raid group showing."] = "Aktiviere das Anzeigen der Schlachtgruppe.",
    ["Keep Info"] = "Behalte Infos",
    ["Keep Lots Of Info"] = "Behalte viele Infos",
    ["Keep player information between session for all players except cross-server players"] = "Behalte Spieler Informationen zwischen Spielsessions für alle Spieler außer Serverübergreifende Namen.",
    ["Keep player information between session, but limit it to friends and guild members."] = "Behalte Spielernamen zwischen Spielesessions. Limitiere sie jedoch auf Freunde und Gildenmitglieder.",
    ["Player Color Mode"] = "Farben Modus",
    ["How to color player's name."] = "Wie Spielernamen einzuf\195\164rben sind.",
	["Unknown Common Color From TasteTheNaimbow"] = "Allgemeine Farben von TasteTheNaimbow",
    ["Let TasteTheNaimbow set the common color for unknown player names."] = "Lass TasteTheNaimbow die Farbe f\195\188r Unbekannte Spieler festlegen.",
	["Enable Alt-Invite"] = "Aktiviere Alt-Einladen",
    ["Toggle group invites by alt-clicking on player name."] = "Lade Spieler durch Alt-Klicken ihrer Namen im Chat.",
    ["Enable Invite Links"] = "Aktivieren Einladen Links",
	["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Lade Spieler ein durch Alt-Klicken hypergelinkter Passw\195\182rter wie 'Einladen'.",
    ["Brackets Common Color"] = "Klammern Farbe",
    ["Sets common color of brackets to use around player names."] = "Stellt die Farbe der Klammern ein welche um die Spielernamen angezeigt werden.",
    ["Brackets Use Common Color"] = "Klammern benutzen allgemeine Farbe",
    ["Toggle using a common color for brackets around player names."] = "Bestimmt ob die allgemeine Farbe f\195\188r die Klammern um Spielernamen verwendet wird.",
} end)

L[LIB.NEWLOCALE](L, "frFR", function() return {
    ["PlayerNames"] = "Nom des joueurs",
    ["Player name formating options."] = "Options d'affichage des noms des joueurs",
    ["Brackets"] = "Parentese",
    ["Square"] = "Crochets",
    ["Angled"] = "truc",
    ["None"] = "Aucun",
    ["Class"] = "Classe",
    ["Random"] = "Al\195\169atoire",
    ["Sets style of brackets to use around player names."] = "S\195\169lectionne le style de crochets \195\160 utiliser pour encadrer les noms de joueurs",
    ["Unknown Use Common Color"] = "Utiliser une couleur par d\195\169faut",
    ["Toggle using a common color for unknown player names."] = "Active/d\195\169sactive l'utilisation d'une couleur par d\195\169faut quand la classe du joueur est inconnue",
    ["Unknown Common Color"] = "Couleur par d\195\169faut",
    ["Set common color of unknown player names."] = "Change la couleur par d\195\169faut",
    ["Enable TabComplete"] = "Compl\195\169tion avec Tab",
    ["Toggle tab completion of player names."] = "Compl\195\169ter le nom des joueurs avec Tab",
	["Show Level"] = "Afficher le level",
    ["Toggle level showing."] = "Active/d\195\169sactive l'affichage du niveau",
	["Show Group"] = "Afficher le groupe",
    ["Toggle raid group showing."] = "Affiche le groupe du joueur en raid",
    ["Keep Info"] = "Garder Info",
    ["Keep Lots Of Info"] = "Garder toute les Info",
    ["Keep player information between session for all players except cross-server players"] = "Garder les informations des joueurs entre les sessions pour tous les joueurs excepté les joueurs des autres serveurs",
    ["Keep player information between session, but limit it to friends and guild members."] = "Garde les informacions des joueurs entre sessions, seulement pour les amis et les guildeux",
    ["Player Color Mode"] = "Mode de Coloration",
    ["How to color player's name."] = "Choisit comment coloriser les noms des joueurs",
	["Unknown Common Color From TasteTheNaimbow"] = "Couleur par d\195\169faut tir\195\169e de TasteTheNaimbow",
    ["Let TasteTheNaimbow set the common color for unknown player names."] = "Laisser TasteTheNaimbow choisir la couleur pour les joueurs inconnus",
	["Enable Alt-Invite"] = "Invitation sur Alt-Clic",
    ["Toggle group invites by alt-clicking on player name."] = "Invite le joueur en faisant Alt-Clic sur son nom dans le chat",
    ["Enable Invite Links"] = "Mot invite cliquable",
	["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Inviter le joueur en faisant Alt-Clic sur le mot 'invite'",
    ["Brackets Common Color"] = "Couleur des crochets",
    ["Sets common color of brackets to use around player names."] = "Choisit la couleur des crochets autour du nom des joueurs",
    ["Brackets Use Common Color"] = "Couleur par d\195\169faut pour les crochets",
    ["Toggle using a common color for brackets around player names."] = "Choisit une couleur par d\195\169faut pour les crochets autour du nom des joueurs",
} end)


local BC = PRAT_LIBRARY(PRATLIB.CLASSTRANSLATIONS)


Prat_PlayerNames = Prat:NewModule(PRAT_MODULE)
local Prat_PlayerNames = Prat_PlayerNames
Prat_PlayerNames.pratModuleName = PRAT_MODULE

Prat_PlayerNames.moduleName = L["PlayerNames"] 	
Prat_PlayerNames.consoleName = string.lower(Prat_PlayerNames.moduleName)

Prat_PlayerNames.Classes = {}
Prat_PlayerNames.Levels = {}
Prat_PlayerNames.Subgroups = {}

Prat_PlayerNames.revision = tonumber(string.sub("$Revision: 79185 $", 12, -3))

Prat_PlayerNames.defaultDB = {
    on = true,
    brackets = "Angled",
    tabcomplete = true,
    tabcompletelimit = 20,
    level = true,
    levelcolor = "DIFFICULTY",
    subgroup = true,
    keep = true,
    keeplots = false,
    colormode = "CLASS",
    usecommoncolor = true,
    altinvite = false,
    linkinvite = false,
    bracketscommoncolor = false,
    linkifycommon = true,
    bracketscolor = {
        r = 0.85,
        g = 0.85,
        b = 0.85,
    },
    useTTN = true,
    usewho = false,
    color = {
        r = 0.65,
        g = 0.65,
        b = 0.65,
    },
}

Prat_PlayerNames.moduleOptions = {}
Prat_PlayerNames.toggleOptions = { 
    sep115_sep = 115, 
    sep125_sep = 125, 
    sep135_sep = 135, 
    sep145_sep = 145, 
    linkifycommon = 153,
    sep155_sep = 155, 
    sep165_sep = 205,
}

-- Set this to true to use Prat Event Support
Prat_PlayerNames.supportsPratEvents = true

function Prat_PlayerNames:GetModuleOptions()
    self.moduleOptions = {
        name = L["PlayerNames"],
        desc = L["Player name formating options."],
        type = "group",
        args = {
            brackets = {
                name = L["Brackets"],
                desc = L["Sets style of brackets to use around player names."],
                type = "text",
                order = 110,
                get = function() return Prat_PlayerNames.db.profile.brackets end,
                set = function(v) Prat_PlayerNames.db.profile.brackets = v end,
                validate = {["Square"] = L["Square"], ["Angled"] = L["Angled"], ["None"] = L["None"]}
            },
            bracketscommoncolor = {
                name = L["Brackets Use Common Color"],
                desc = L["Toggle using a common color for brackets around player names."],
                type = "toggle",
                order = 111,
                get = function() return Prat_PlayerNames.db.profile.bracketscommoncolor end,
                set = function(v) Prat_PlayerNames.db.profile.bracketscommoncolor = v end,
            },
            bracketscolor = {
                name = L["Brackets Common Color"],
                desc = L["Sets common color of brackets to use around player names."],
                type = "color",
                order = 112,
                get = function() local c = Prat_PlayerNames.db.profile.bracketscolor 
                        return c.r, c.g, c.b end,
                set = function(r, g, b, a) 
                	Prat_PlayerNames.db.profile.bracketscolor.r, 
                	Prat_PlayerNames.db.profile.bracketscolor.g, 
                	Prat_PlayerNames.db.profile.bracketscolor.b = r,g,b end,
                disabled = function() return not Prat_PlayerNames.db.profile.bracketscommoncolor end,
            },
            usecommoncolor = {
                name = L["Unknown Use Common Color"],
                desc = L["Toggle using a common color for unknown player names."],
                type = "toggle",
                order = 120,
                get = function() return Prat_PlayerNames.db.profile.usecommoncolor end,
                set = function(v) Prat_PlayerNames.db.profile.usecommoncolor = v end
            },
            setcolor = {
                name = L["Unknown Common Color"],
                desc = L["Set common color of unknown player names."],
                type = "color",
                order = 121,
                get = function() return Prat_PlayerNames.db.profile.color.r, Prat_PlayerNames.db.profile.color.g, Prat_PlayerNames.db.profile.color.b end,
                set = function(r, g, b, a) Prat_PlayerNames.db.profile.color.r, Prat_PlayerNames.db.profile.color.g, Prat_PlayerNames.db.profile.color.b = r, g, b end,
                disabled = function() if not Prat_PlayerNames.db.profile.usecommoncolor then return true else return false end end,
            },
            commoncolorTTN = {
                name = L["Unknown Common Color From TasteTheNaimbow"],
                desc = L["Let TasteTheNaimbow set the common color for unknown player names."],
                type = "toggle",
                order = 122,
                get = function() return Prat_PlayerNames.db.profile.useTTN end,
                set = function(v) Prat_PlayerNames.db.profile.useTTN = v end,
                hidden = function() if TasteTheNaimbow_Loaded then return false else return true end end,
                disabled = function() if not Prat_PlayerNames.db.profile.usecommoncolor then return true else return false end end,
            },
            playercolor = {
                name = L["Player Color Mode"],
                desc = L["How to color player's name."],
                type = "text",
                order = 130,
                get = function() return Prat_PlayerNames.db.profile.colormode end,
                set = function(v) Prat_PlayerNames.db.profile.colormode = v end,
                validate = {["RANDOM"] = L["Random"], ["CLASS"] = L["Class"], ["NONE"] = L["None"]}
            },
            levelcolor = {
                name = L["Level Color Mode"],
                desc = L["How to color other player's level."],
                type = "text",
                order = 131,
                get = function() return Prat_PlayerNames.db.profile.levelcolor end,
                set = function(v) Prat_PlayerNames.db.profile.levelcolor = v end,
                validate = {["PLAYER"] = L["Use Player Color"], ["CHANNEL"] = L["Use Channel Color"], ["DIFFICULTY"] = L["Color by Level Difference"], ["NONE"] = L["No additional coloring"]}
            },            
            level = {
                name = L["Show Level"],
                desc = L["Toggle level showing."],
                type = "toggle",
                order = 140,
                get = function() return Prat_PlayerNames.db.profile.level end,
                set = function(v) Prat_PlayerNames.db.profile.level = v end
            },
            subgroup = {
                name = L["Show Group"],
                desc = L["Toggle raid group showing."],
                type = "toggle",
                order = 141,
                get = function() return Prat_PlayerNames.db.profile.subgroup end,
                set = function(v) Prat_PlayerNames.db.profile.subgroup = v end
            },
            tabcomplete = {
                name = L["Enable TabComplete"],
                desc = L["Toggle tab completion of player names."],
                type = "toggle",
                order = 150,
                get = function() return Prat_PlayerNames.db.profile.tabcomplete end,
                set = function(v) Prat_PlayerNames.db.profile.tabcomplete = v; self:TabComplete(v) end
            },
            altinvite = {
                name = L["Enable Alt-Invite"],
                desc = L["Toggle group invites by alt-clicking on player name."],
                type = "toggle",
                order = 151,
                get = function() return Prat_PlayerNames.db.profile.altinvite end,
                set = function(v) Prat_PlayerNames.db.profile.altinvite = v self:SetAltInvite() end,
            },            
            linkinvite = {
                name = L["Enable Invite Links"],
                desc = L["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."],
                type = "toggle",
                order = 152,
                get = function() return Prat_PlayerNames.db.profile.linkinvite end,
                set = function(v) Prat_PlayerNames.db.profile.linkinvite = v self:SetAltInvite() end,
            },             
            keep = {
                name = L["Keep Info"],
                desc = L["Keep player information between session, but limit it to friends and guild members."],
                type = "toggle",
                order = 200,
                get = function() return Prat_PlayerNames.db.profile.keep end,
                set = function(v) Prat_PlayerNames.db.profile.keep = v end
            },
            keeplots = {
                name = L["Keep Lots Of Info"],
                desc = L["Keep player information between session for all players except cross-server players"],
                type = "toggle",
                order = 201,
                get = function() return Prat_PlayerNames.db.profile.keeplots end,
                set = function(v) Prat_PlayerNames.db.profile.keeplots = v end,
                disabled = function() return not Prat_PlayerNames.db.profile.keep end,
            },
            
            usewho = {
                name = L["Actively Query Player Info"],
                desc = L["Query the server for all player names we do not know. Note: This happpens pretty slowly, and this data is not saved."],
                type = "toggle",
                order = 202,
                get = function() return Prat_PlayerNames.db.profile.usewho end,
                set = function(v) Prat_PlayerNames.db.profile.usewho = v  if v then self:updateAll() end end,           
                hidden = function() local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo("WhoLib") if reason == "MISSING" then return true end return false end
            },
			reset = {
				name = L["Reset Settings"],
				desc = L["Restore default settings, and delete stored character data."],
				type = "execute",
				order = 250,
				func = function() Prat_PlayerNames:resetStoredData() end,
			},              
        }
    }
    return self.moduleOptions
end

    
function Prat_PlayerNames:OnModuleInit() 
    self:Debug("OnModuleInit")
    Prat:RegisterDefaults("PlayerNames", "realm", {
        classes = {},
        levels = {}
    })
end

local Glory = PRAT_LIBRARY:HasInstance(LIB.PVP, false) and PRAT_LIBRARY(LIB.PVP)


function Prat_PlayerNames:OnModuleEnable()
    self:Debug("OnModuleEnable")

	self[LIB.REGISTEREVENT](self, "Prat_FrameMessage")
	self[LIB.REGISTEREVENT](self, "Prat_Ready")
	self[LIB.REGISTEREVENT](self, "AceEvent_FullyInitialized")

    if not Glory then
        self[LIB.REGISTEREVENT](self, "AceLibrary_Register")
    end
    
	self:SetAltInvite()

    self[LIB.REGISTEREVENT](self, "FRIENDLIST_UPDATE", "updateFriends")
--    self[LIB.REGISTEREVENT](self, "GUILD_ROSTER_UPDATE", "updateGuild")
--    self[LIB.REGISTEREVENT](self, "RAID_ROSTER_UPDATE", "updateRaid") 
    self[LIB.REGISTEREVENT](self, "PLAYER_LEVEL_UP", "updatePlayerLevel")
    self[LIB.REGISTEREVENT](self, "PARTY_MEMBERS_CHANGED", "updateParty")
    self[LIB.REGISTEREVENT](self, "PLAYER_TARGET_CHANGED", "updateTarget")
    self[LIB.REGISTEREVENT](self, "UPDATE_MOUSEOVER_UNIT", "updateMouseOver")
    self[LIB.REGISTEREVENT](self, "WHO_LIST_UPDATE", "updateWho") 
	self[LIB.REGISTEREVENT](self, "CHAT_MSG_SYSTEM", "updateWho") -- for short /who command

    self[LIB.REGISTEREVENT](self, "PLAYER_LEAVING_WORLD", "EmptyDataCache")

    self.NEEDS_INIT = true

    self:TabComplete(Prat_PlayerNames.db.profile.tabcomplete)   
    
    -- { linkid, linkfunc, handler }
    Prat:RegisterLinkType(  { linkid="invplr", linkfunc=Prat_PlayerNames.Invite_Link, handler=Prat_PlayerNames }, Prat_PlayerNames.moduleName)    
    Prat:RegisterLinkType(  { linkid="player", linkfunc=Prat_PlayerNames.Player_Link, handler=Prat_PlayerNames }, Prat_PlayerNames.moduleName)    
end
function Prat_PlayerNames:AceLibrary_Register(major)
    if major == PRATLIB.PVP then
        Glory = PRAT_LIBRARY(LIB.PVP)
    end
end
function Prat_PlayerNames:OnModuleDisable()
    self:TabComplete(false)
end

function Prat_PlayerNames:GetModulePatterns()
end



function Prat_PlayerNames:Prat_Ready()
    self:updateAll()
end

local cache = { Prat_PlayerNames.Levels,
                Prat_PlayerNames.Classes,
                Prat_PlayerNames.Subgroups }
local who 

function Prat_PlayerNames:EmptyDataCache(force)  
    for k,v in pairs(cache) do
        for x,y in pairs(v) do
            v[x] = nil
        end
    end
    
    self.NEEDS_INIT = true
    self:Debug("Cleared data cache")
end

function Prat_PlayerNames:AceEvent_FullyInitialized()
   -- self:updateAll()
end



--[[------------------------------------------------
	Core Functions
------------------------------------------------]]--
function Prat_PlayerNames:updateAll()
    self:Debug("updateAll -->")
	
    Prat_PlayerNames:updatePlayer()
	Prat_PlayerNames:updateParty()
	
    if MiniMapBattlefieldFrame.status == "active" then
        Prat_PlayerNames:updateBG()
    else
    	Prat_PlayerNames:updateRaid()
    end
    	
	Prat_PlayerNames:updateFriends()
	
	
	if self.db.profile.usewho then 
    	-- Load all the players in all channels
        who = who or PRAT_LIBRARY:HasInstance(LIB.WHO) and PRAT_LIBRARY(LIB.WHO)
        
        if who then     
        	self[LIB.REGISTEREVENT](self, "CHAT_MSG_CHANNEL_LIST")
        	self.listingchan = 1
        	ListChannelByName("10")
        	ListChannelByName("9")
        	ListChannelByName("8")
        	ListChannelByName("7")
        	ListChannelByName("6")
        	ListChannelByName("5")
        	ListChannelByName("4")
        	ListChannelByName("3")
        	ListChannelByName("2")
        	ListChannelByName("1")
        end
    end    

    self.NEEDS_INIT = nil

	Prat_PlayerNames:updateGuild(Prat_PlayerNames.db.profile.keeplots)
   
    self:Debug("updateAll <--")
end


function Prat_PlayerNames:CHAT_MSG_CHANNEL_LIST(list, chan, channum, ...)
    self:Debug(list, self.listingchan, chan, channum, ...)

   local q = self:ReadChannelMembers(util:acquire(), strsplit(",", list))

   for k,v in pairs(q) do
      who:UserInfo(k:trim(), { timeout = -1 } )
   end  

    util:reclaim(q)
    
    if channum == self.listingchan then
        self:ScheduleEvent("Prat_ChannelListDone", self.ChannelListDone, 1, self)
    end
end

function Prat_PlayerNames:ChannelListDone()
    self:UnregisterEvent("CHAT_MSG_CHANNEL_LIST")
end

function Prat_PlayerNames:ReadChannelMembers(t, ...)
	for k in pairs(t) do
		t[k] = nil
	end
	for i=1, select('#', ...) do
		local name = select(i, ...)
		if name and name:len() > 0 then
			t[name] = true
		end
	end
	return t
end



function Prat_PlayerNames:updateGF()
    Prat_PlayerNames:updateGuild()
    Prat_PlayerNames:updateFriends()
    if MiniMapBattlefieldFrame.status == "active" then 
        Prat_PlayerNames:updateBG()
    end
end

function Prat_PlayerNames:updatePlayer()
 	local PlayerClass = select(2, UnitClass("player"))
    local Name, Server = UnitName("player")
    Prat_PlayerNames:addName(Name, Server, PlayerClass, UnitLevel("player"), nil, "PLAYER")
end

function Prat_PlayerNames:updatePlayerLevel()
    local Level = arg1
 	local PlayerClass = select(2, UnitClass("player"))
    local Name, Server = UnitName("player")
    Prat_PlayerNames:addName(Name, Server, PlayerClass, Level, nil, "PLAYER")
end

function Prat_PlayerNames:updateFriends()
    self:Debug("updateFriends -->")
    local Name, Class, Level
    for i = 1, GetNumFriends() do
        Name, Level, Class = GetFriendInfo(i)
        Prat_PlayerNames:addName(Name, nil, Class, Level, nil, "FRIEND")
    end
    self:Debug("updateFriends <--")
end

function Prat_PlayerNames:updateGuild(lots)
    if IsInGuild() == 1 then
        if GetNumGuildMembers(true) == 0 then
            GuildRoster()
            self.NEEDS_INIT = true
        end
        
        local Name, Class, Level, _
        for i = 1, GetNumGuildMembers(true) do
            Name, _, _, Level, Class = GetGuildRosterInfo(i)
            Prat_PlayerNames:addName(Name, nil, Class, Level, nil,"GUILD")
        end
    end
end

function Prat_PlayerNames:updateRaid()
    self:Debug("updateRaid -->")
    local Name, Class, SubGroup, Level, Server
	for k,v in pairs(Prat_PlayerNames.Subgroups) do
	    Prat_PlayerNames.Subgroups[k] = nil
	end
    for i = 1, GetNumRaidMembers() do
        SubGroup, Level, Class = select(3, GetRaidRosterInfo(i))
        Name, Server = UnitName("raid" .. i)
        Prat_PlayerNames:addName(Name, Server, Class, Level, SubGroup, "RAID")
    end
    self:Debug("updateRaid <--")
end

function Prat_PlayerNames:updateParty()
    local Class, Unit, Name, Server
    for i = 1, GetNumPartyMembers() do
        Unit = "party" .. i
        Class = select(2, UnitClass(Unit))
        Name, Server = UnitName(Unit)
        Prat_PlayerNames:addName(Name, Server, Class, UnitLevel(Unit), nil, "PARTY")
    end
end

function Prat_PlayerNames:updateTarget()
    local Class, Name, Server
    if not UnitIsPlayer("target") or not UnitIsFriend("player", "target") then
        return
    end
    Class = select(2, UnitClass("target"))
    Name, Server = UnitName("target")
    self:addName(Name, Server, Class, UnitLevel("target"), nil,  "TARGET")
end

function Prat_PlayerNames:updateMouseOver()
    local Class, Name, Server
    if not UnitIsPlayer("mouseover") or not UnitIsFriend("player", "mouseover") then
        return
    end
    Class = select(2, UnitClass("mouseover"))
    Name, Server = UnitName("mouseover")
    Prat_PlayerNames:addName(Name, Server, Class, UnitLevel("mouseover"), nil,  "MOUSE")
end

function Prat_PlayerNames:updateWho()
    if who then return end
    
    local Name, Class, Level, Server, _
    for i = 1, GetNumWhoResults() do
        Name, _, Level, _, Class = GetWhoInfo(i)
        Prat_PlayerNames:addName(Name, Server, Class, Level, nil, "WHO")
    end
end

function Prat_PlayerNames:updateBG()
    self:Debug("updateBG -->")
	for i = 1, GetNumBattlefieldScores() do
	    local name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i);

        if name then
            local plr, svr = strsplit("-", name)
            Prat_PlayerNames:addName(plr, svr, class, nil, nil, "BATTLEFIELD")
            Prat_PlayerNames:addName(plr, nil, class, nil, nil, "BATTLEFIELD")
        end
	end    
    self:Debug("updateBG <--")
    Prat_PlayerNames:updateRaid()  
end


function Prat_PlayerNames:resetStoredData()
   -- Prat_PlayerNames:ResetDB()

    Prat_PlayerNames.db.realm.classes = {}
    Prat_PlayerNames.db.realm.levels = {}

    self:EmptyDataCache(true)
    
    Prat:Print(L["Prat_PlayerNames: Stored Player Data Cleared"])
end

--
-- Coloring Functions
--
function CLR:Bracket(text) return self:Colorize(Prat_PlayerNames:GetBracketCLR(), text) end
function CLR:Common(text) return self:Colorize(Prat_PlayerNames:GetCommonCLR(), text) end
function CLR:Random(text, seed) return self:Colorize(Prat_PlayerNames:GetRandomCLR(seed), text) end
function CLR:Class(text, class) return self:Colorize(self:GetClassColor(class), text) end
function CLR:Level(text, level, name, class) 
    local mode = Prat_PlayerNames.db.profile.levelcolor
    if mode and type(level) == "number" and level > 0 then
        if mode == "DIFFICULTY" then 
            local diff = GetDifficultyColor(level)
            return self:Colorize(CLR:GetHexColor(CLR:Desaturate(diff)), text)
        elseif mode == "PLAYER" then
            return self:Player(text, name, class)
        end
    end 
    
    return text
end
function CLR:Player(text, name, class) 
    return self:Colorize(Prat_PlayerNames:GetPlayerCLR(name, class), text)
end    


function Prat_PlayerNames:addName(Name, Server, Class, Level, SubGroup, Source)
  if Name then
    local nosave
    
    -- Messy negations, but this says dont save data from 
    -- sources other than guild or friends unless you enable
    -- the keeplots option
    if Source ~= "GUILD" and Source ~= "FRIEND" and Source ~= "PLAYER" then
        nosave = not Prat_PlayerNames.db.profile.keeplots
    end

    if Server and Server:len() > 0 then 
        nosave = true
    end
   

    Name = Name..(Server and Server:len()>0 and ("-"..Server) or "")

	if Level and Level > 0 then
		Prat_PlayerNames.Levels[Name] = Level
        if ((not nosave) and  Prat_PlayerNames.db.profile.keep) then	
            Prat_PlayerNames.db.realm.levels[Name] = Level 
        else -- Update it if it exists
            if Prat_PlayerNames.db.realm.levels[Name] then 
                Prat_PlayerNames.db.realm.levels[Name] = Level
            end
        end
	end
    if Class and Class ~= UNKNOWN then
        if Prat_PlayerNames.Classes[Name] == nil then 
            self:Debug("addName", Name, Class, Level, SubGroup, Source)
        end
        Prat_PlayerNames.Classes[Name] = Class
        if ((not nosave) and   Prat_PlayerNames.db.profile.keep ) then Prat_PlayerNames.db.realm.classes[Name] = Class end
    end
	if SubGroup then
		Prat_PlayerNames.Subgroups[Name] = SubGroup
	end
  end
end

function Prat_PlayerNames:getClass(player)
    return self.Classes[player] or Prat_PlayerNames.db.realm.classes[player]
end

function Prat_PlayerNames:getLevel(player)
    return self.Levels[player] or Prat_PlayerNames.db.realm.levels[player]
end

function Prat_PlayerNames:getSubgroup(player)
    return self.Subgroups[player]
end

function Prat_PlayerNames:GetData(player)
    return self:getClass(player), self:getLevel(player), self:getSubgroup(player)
end

function Prat_PlayerNames:GetClassColor(class)
     return BC:GetHexColor(class)
	--class = string.upper(class)

	--if RAID_CLASS_COLORS and RAID_CLASS_COLORS[class] then
	--	return CLR:GetHexColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)
	--end

	--return CLR:GetHexColor(0.63, 0.63, 0.63)
end

local tmp = {}
function Prat_PlayerNames:addInfo(Name, Server)
    tmp.pP = ""
    tmp.Pp = ""
    tmp.PREPLAYER = ""
    tmp.POSTPLAYER = ""
    tmp.PLAYER = Name or ""
        
    if Server and strlen(Server) > 0 then
        tmp.sS = "-"
        tmp.SERVER = Server
        tmp.Ss = ""
    end    
    
    self:FormatPlayer(tmp, Name)
    
    return tmp.pP..tmp.PREPLAYER..tmp.PLAYER..tmp.POSTPLAYER..tmp.Pp
end



function Prat_PlayerNames:FormatPlayer(message, Name)
    local class, level, subgroup = self:GetData(Name)

    if who then
        local user, cachetime = who:UserInfo(Name, { timeout = -1 }) 

        if user then
            level = user.Level
            class = user.Class
        end
    end

    -- Add level information if needed
    if level and Prat_PlayerNames.db.profile.level then
    	message.PREPLAYER = CLR:Level(tostring(level), level, Name, class)..":"
    end

    -- Add raid subgroup information if needed
    if subgroup and Prat_PlayerNames.db.profile.subgroup and (GetNumRaidMembers() > 0) then
		message.POSTPLAYER  = ":"..subgroup
    end

    -- Add the player name in the proper color
    message.PLAYER = CLR:Player(message.PLAYER, Name, class)


    -- Add the correct bracket style and color
    local prof_brackets = Prat_PlayerNames.db.profile.brackets
    if prof_brackets == "Angled" then
        message.pP = CLR:Bracket("<")..message.pP
        message.Pp  = message.Pp..CLR:Bracket(">")
    elseif prof_brackets == "None" then
    else
        message.pP = CLR:Bracket("[")..message.pP
        message.Pp  = message.Pp..CLR:Bracket("]")
    end
end



--ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h has come online."
local _, _, FRIEND_ONLINE = string.match(ERR_FRIEND_ONLINE_SS, "|Hplayer:(.-)|h%[(.-)%]|h(.+)")

--ERR_BG_PLAYER_JOINED_SS = "|Hplayer:%s|h[%s]|h has joined the battle";
local _, _, BG_JOIN = string.match(ERR_BG_PLAYER_JOINED_SS, "|Hplayer:(.-)|h%[(.-)%]|h(.+)")

--
-- Prat Event Implementation
--
local EVENTS_FOR_RECHECK = {
 ["CHAT_MSG_GUILD"] = Prat_PlayerNames.updateGuild,
 ["CHAT_MSG_OFFICER"] = Prat_PlayerNames.updateGuild,
 ["CHAT_MSG_PARTY"] = Prat_PlayerNames.updateParty,
 ["CHAT_MSG_RAID"] = Prat_PlayerNames.updateRaid,
 ["CHAT_MSG_RAID_LEADER"] = Prat_PlayerNames.updateRaid,
 ["CHAT_MSG_RAID_WARNING"] = Prat_PlayerNames.updateRaid,
 ["CHAT_MSG_BATTLEGROUND"] = Prat_PlayerNames.updateBG,
 ["CHAT_MSG_BATTLEGROUND_LEADER"] = Prat_PlayerNames.updateBG,
 ["CHAT_MSG_SYSTEM"] = Prat_PlayerNames.updateGF,
}


local RAID_JOIN =  string.gsub( ERR_RAID_MEMBER_ADDED_S, "%%s(.*)", "(.+)(%1)")
local RAID_LEAVE =  string.gsub( ERR_RAID_MEMBER_REMOVED_S, "%%s(.*)", "(.+)(%1)")

function Prat_PlayerNames:AddPlayerLinks(message, frame, event)
    local name, rest
    
    if event == "CHAT_MSG_SYSTEM" then 
        name, rest = string.match(message.MESSAGE, RAID_JOIN) 
        if name then self:MakePlayer(message, name) message.MESSAGE = rest return end

        name, rest = string.match(message.MESSAGE, RAID_LEAVE) 
        if name then self:MakePlayer(message, name) message.MESSAGE = rest return end

    end
end

function Prat_PlayerNames:MakePlayer(message, name)
    if type(name) == "string" then
        local plr, svr = strsplit("-", name)
        self:Debug("MakePlayer", name, plr, svr)
    
        message.lL = "|Hplayer:"
        message.PLAYERLINK = name
        message.LL = "|h"
        message.PLAYER = plr
        message.Ll = "|h"
        
        if svr and strlen(svr) > 0 then
            message.sS = "-"
            message.SERVER = svr
        end        
    end
end


function Prat_PlayerNames:Prat_FrameMessage(message, frame, event)
    if self.NEEDS_INIT then
        self:updateAll()
    end
    
    
    if who then 
        if event == "CHAT_MSG_CHANNEL_LIST" and self:IsEventRegistered("CHAT_MSG_CHANNEL_LIST") then
            message.DONOTPROCESS = true
            return
        end        

        if Prat:GetEventID() and 
           Prat:GetEventID() == self.lastevent and 
           self.lasteventtype == event then 
    
            self.lastevent = Prat:GetEventID()
            self.lasteventtype = event
            
            if event == "CHAT_MSG_NOTICE" and message.MESSAGE == "YOU_JOINED" then
                self.listingchan = message.CHANNUM
                self[LIB.REGISTEREVENT](self, "CHAT_MSG_CHANNEL_LIST")
                self:Debug(self.listingchan)
                ListChannelByName(tostring(self.listingchan))
            end
        end    
    end
    
	local Name = message.PLAYERLINK or ""
	message.Pp = ""
	message.pP = ""
	if strlen(Name) == 0 then
        if self.db.profile.linkifycommon then
            self:AddPlayerLinks(message, frame, event)
        end	    

        Name = message.PLAYERLINK or ""
        
        if strlen(Name) == 0 then  
	        return
	    end
	end


    
   -- self:Debug("Prat_FrameMessage", message, frame, event, message.PLAYERLINK)

    local class, level, subgroup = self:GetData(Name)

    local prof_colormode = Prat_PlayerNames.db.profile.colormode


   
    
    if who then
        local user, cachetime = who:UserInfo(Name, { timeout = -1 }) 

        if user then
            level = user.Level
            class = user.Class
            self:Debug("who", Name, level, class)
        end
    end
    
    local fx = EVENTS_FOR_RECHECK[event]
    if fx~=nil and (level==nil or level==0 or class==nil) then
--        self:Debug(Name,  level, class, subgroup, prof_colormode, event)
        
        if event == "CHAT_MSG_SYSTEM" then
         --   if message.MESSAGE == FRIEND_ONLINE or message.MESSAGE == BG_JOIN then
                fx(self)
           -- end
        else
            fx(self)
        end
        
        class, level, subgroup = self:GetData(Name)

        self:Debug("Did a second check", Name, level, class, subgroup)
    end
    
    self:FormatPlayer(message, Name)
end

function Prat_PlayerNames:GetPlayerCLR(name, class, mode)
    if not mode then mode = Prat_PlayerNames.db.profile.colormode end
    
    if name and strlen(name) > 0 then
        if class and mode == "CLASS" then
            return self:GetClassColor(class)
        elseif mode == "RANDOM" then
            return self:GetRandomCLR(name)
    	else
    		return self:GetCommonCLR()
    	end
    end
end

function Prat_PlayerNames:GetBracketCLR()
	if not self.db.profile.bracketscommoncolor then
		return CLR.COLOR_NONE
	else
		local color = self.db.profile.bracketscolor
		return CLR:GetHexColor(color)
	end
end
function Prat_PlayerNames:GetCommonCLR()
	local color = CLR.COLOR_NONE
    if Prat_PlayerNames.db.profile.usecommoncolor then
    	if Prat_PlayerNames.db.profile.useTTN and TasteTheNaimbow_Loaded then
    		color = TasteTheNaimbowExternalColor(name)
    	else
    		color = CLR:GetHexColor(Prat_PlayerNames.db.profile.color)
    	end
    end
    return color
end
function Prat_PlayerNames:GetRandomCLR(Name)
	local hash = 17
	for i=1,string.len(Name) do
		hash = hash * 37 * string.byte(Name, i);
	end

	local r = math.floor(math.fmod(hash / 97, 255));
	local g = math.floor(math.fmod(hash / 17, 255));
	local b = math.floor(math.fmod(hash / 227, 255));

    if ((r * 299 + g * 587 + b * 114) / 1000) < 105 then
    	r = math.abs(r - 255);
        g = math.abs(g - 255);
        b = math.abs(b - 255);
    end

	return string.format("%02x%02x%02x", r, g, b)
end


function Prat_PlayerNames:TabComplete(enabled)
    if enabled then
        if not PRAT_LIBRARY(LIB.TABCOMPLETION):IsTabCompletionRegistered("Prat_PlayerNames") then
            PRAT_LIBRARY(LIB.TABCOMPLETION):RegisterTabCompletion("Prat_PlayerNames", "",
                function(t, text, pos)
                    for name in pairs(Prat_PlayerNames.Classes) do
                        table.insert(t, pos == 0 and name..":" or name)
                    end
                end,
                function(u, cands)
                	local candcount = #cands
                	if candcount <= self.db.profile.tabcompletelimit then
						local text = ""
	                    for _, cand in ipairs(cands) do
							cand = string.gsub(cand, ":", "")
							cand = self:addInfo(cand)
							text = text .. " " .. cand
	                    end
	                    Prat:Print(L["Tab completion : "] .. text)
	                else
	                	Prat:Print(L["Tab completion : Too many matches (%d possible)"]:format(candcount))
	                end
                end
            )
        end
    else
        if PRAT_LIBRARY(LIB.TABCOMPLETION):IsTabCompletionRegistered("Prat_PlayerNames") then
            PRAT_LIBRARY(LIB.TABCOMPLETION):UnregisterTabCompletion("Prat_PlayerNames")
        end
    end
end

function Prat_PlayerNames:SetAltInvite()
	local enabled = self.db.profile.linkinvite or self.db.profile.altinvite

	if enabled then
        for _,v in pairs(Prat_PlayerNames.modulePatterns) do
            Prat:RegisterPattern(v, self.name)
        end
	else
        Prat:UnregisterAllPatterns(self.name)
	end
end

local EVENTS_FOR_INVITE = {
 ["CHAT_MSG_GUILD"] = true,
 ["CHAT_MSG_OFFICER"] = true,
 ["CHAT_MSG_PARTY"] = true,
 ["CHAT_MSG_RAID"] = true,
 ["CHAT_MSG_RAID_LEADER"] = true,
 ["CHAT_MSG_RAID_WARNING"] = true,
 ["CHAT_MSG_SAY"] = true,
 ["CHAT_MSG_YELL"] = true,
 ["CHAT_MSG_WHISPER"] = true,
 ["CHAT_MSG_CHANNEL"] = true,
}

local function Invite(text, ...)
    return Prat_PlayerNames:ScanForLinks(text, Prat.SplitMessage.PLAYERLINK)
end

local INVALID_NAMES = {
    ["me"] = true,
    ["meh"] = true,
    ["now"] = true,
    ["plz"] = true,
    ["please"] = true,
    ["when"] = true,
    ["to"] = true,    
    ["group"] = true,    
    ["raid"] = true,    
    ["grp"] = true,    
}

local INVALID_NAME_REFERENCE = {
    ["him"] = true,
    ["her"] = true,
    ["them"] = true,
    ["us"] = true,
}

local function InviteSomone(text, name)
    if name and not INVALID_NAMES[string.lower(name)] then 
        if INVALID_NAME_REFERENCE[string.lower(name)] then
            return Prat:RegisterMatch(text)
        else
            return Prat_PlayerNames:ScanForLinks(text, name)
        end
    end
end
Prat_PlayerNames.modulePatterns = { 
    { pattern = "(send%s+invite%s+to%s+(%w+))", matchfunc=InviteSomone },
    { pattern = "(invite%s+(%w+))", matchfunc=InviteSomone },
    { pattern = "(invites?%??)", matchfunc=Invite },
    { pattern = "(초대)", matchfunc=Invite },
    { pattern = "(組%??)$", matchfunc=Invite },
    { pattern = "(組我%??)$", matchfunc=Invite },
}

function Prat_PlayerNames:Invite_Link(link, text, button, ...)
    if self.db.profile.linkinvite then
		local name = strsub(link, 8);
		if ( name and (strlen(name) > 0) ) then
			local begin = string.find(name, "%s[^%s]+$");
			if ( begin ) then
				name = strsub(name, begin+1);
			end
			if ( button == "LeftButton" ) then
				InviteUnit(name);
			end
		end
		
	    return false
    end

    return true
end

function Prat_PlayerNames:Player_Link(link, text, button, ...)
    if self.db.profile.altinvite then
		local name = strsub(link, 8);
		if ( name and (strlen(name) > 0) ) then
		    self:Debug(name, link, text, button, this:GetName())
		    local begin, nend = string.find(name, "%s*[^%s:]+");
			if ( begin ) then
			name = strsub(name, begin, nend);
			end
			if ( IsAltKeyDown() ) then
				InviteUnit(name);
				ChatEdit_OnEscapePressed(this.editBox)
				return false;
			end
		end
    end
    
    return true
end

function Prat_PlayerNames:ScanForLinks(text, name)
    if text == nil then 
        return ""
    end

	local enabled = Prat_PlayerNames.db.profile.linkinvite

    	if enabled and CanGroupInvite() then

		if EVENTS_FOR_INVITE[event] then
       			return  Prat_PlayerNames:InviteLink(text, name)
    		end
	end

	return text
end



function Prat_PlayerNames:InviteLink(link, name)
    local returnedLink = ""

	returnedLink = "|cffffff00"

    returnedLink = returnedLink .. "|Hinvplr:" .. name .. "|h"

    returnedLink = returnedLink .. "[" .. link .. "]"

    returnedLink = returnedLink .. "|h|r"

    return Prat:RegisterMatch(returnedLink)
end

