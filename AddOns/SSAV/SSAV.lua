--[[ 
	SSAV By Shadowd of Icecrown (PVE)
	Original Release: July 27th (2006)
]]

local Orig_ChatFrame_OnEvent;
local AVTimers = {};

function SSAV_OnLoad()
	this:RegisterEvent( "ADDON_LOADED" );
	this:RegisterEvent( "CHAT_MSG_ADDON" );
	this:RegisterEvent( "CHAT_MSG_MONSTER_YELL" );
	this:RegisterEvent( "CHAT_MSG_COMBAT_HOSTILE_DEATH" );
	
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "BATTLEFIELD_WON" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "LEFT_BATTLEFIELD" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "BATTLEFIELD_INFO_UPDATED" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "AV_HERALD_MESSAGE" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "AV_HORDE_GOD_SUMMONED" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "AV_ALLIANCE_GOD_SUMMONED" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "AV_RESOURCE_CLAIMED" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "AV_RESOURCE_DESTROYING" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "AV_RESOURCE_CAPTURING" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "AV_RESOURCE_CAPTURED" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "AV_RESOURCE_DESTROYED" );
	SSLibrary_RegisterEvent( "SSAV_OnEvent", "AV_RESOURCE_LOADED" );
	
	-- Register with SSLoader
	local SSAV = { onLoad = "SSAV_OnLoad", loadInBG = { SS_ALTERACVALLEY }, loadOnMsg = "SSAV", onEvent = "SSAV_OnEvent", };
	SSLoader_RegisterAddOn( "SSAV", SSAV );
	SSLoader_RegisterSlash( "SSAV", "SSAV_SlashHandler", { "/ssav" }, "SSAV" );
end 


function SSAV_SlashHandler( msg )
	local command, commandArg, optionState, optionValue;
	
	if( msg ~= nil ) then
		command = string.gsub( msg, "(.+) (.+)", "%1" );
		commandArg = string.gsub( msg, "(.+) (.+)", "%2" );
		command = ( command or msg );
	end
	
	if( commandArg == "on" ) then
		optionState = GREEN_FONT_COLOR_CODE .. SSAV_ON .. FONT_COLOR_CODE_CLOSE;
		optionValue = true;
	elseif( commandArg == "off" ) then
		optionState = RED_FONT_COLOR_CODE .. SSAV_OFF .. FONT_COLOR_CODE_CLOSE;
		optionValue = false;
	end
	
	if( command == "on" ) then
		SSAV_Config.enabled = true;
		SSLibrary_Message( string.format( SSAV_CMD_ENABLED, GREEN_FONT_COLOR_CODE .. SSAV_ON .. FONT_COLOR_CODE_CLOSE ) );
		
		AVTimers = {};
		SSLibrary_RequestAVTimers();
	elseif( command == "off" ) then
		SSAV_Config.enabled = false;
		SSLibrary_Message( string.format( SSAV_CMD_ENABLED, RED_FONT_COLOR_CODE .. SSAV_OFF .. FONT_COLOR_CODE_CLOSE ) );
		
		-- Remove all timers
		AVTimers = {};
		SSLibrary_UnScheduleEvent( "SSAV_PrintTimer" );
	elseif( command == "interval" and commandArg ) then
		SSAV_Config.interval = tonumber( commandArg );
		
		if( SSAV_Config.interval < 30 ) then
			SSLibrary_Message( SSAV_CMD_TOLOWINTERVAL );
			SSAV_Config.interval = 90;
		else
			SSLibrary_Message( string.format( SSAV_CMD_INTERVAL, GREEN_FONT_COLOR_CODE .. SSAV_Config.interval .. FONT_COLOR_CODE_CLOSE ) );
		end
	
	elseif( command == "sync" ) then
		if( GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 ) then
			SSLibrary_Message( SSAV_NOT_IN_RAID, ChatTypeInfo["SYSTEM"] );
			return;
		end
		
		local countdown = tonumber( commandArg );
		
		if( countdown == nil or countdown <= 0 ) then
			countdown = 3;
		end
		
		for i=0, countdown - 1 do
			SSLibrary_ScheduleEvent( "SSAV_SendMessage", i, string.format( SSAV_SYNC_QUEUE_SEC, countdown - i ) );
		end
		
		SSLibrary_ScheduleEvent( "SSAV_SendMessage", countdown, SSAV_SYNC_QUEUED );
		SSLibrary_ScheduleEvent( SSAV_SendAVSync, countdown );
	
	elseif( command == "cancel" ) then
		SSLibrary_UnScheduleEvent( "SSAV_SendMessage" );
		SSLibrary_UnScheduleEvent( "SSAV_SendAVSync" );
		
		--SSLibrary_Message( SSAV_SYNC_STOPPED, ChatTypeInfo["SYSTEM"] );
		SSAV_SendMessage( SSAV_SYNC_QUEUE_STOPPED );
	
	elseif( command == "horde" and optionState ) then
		SSAV_Config.horde = optionValue;
		SSLibrary_Message( string.format( SSAV_CMD_FACTIONH, optionState ) );

	elseif( command == "npc" and optionState ) then
		SSAV_Config.npc = optionValue;
		SSLibrary_Message( string.format( SSAV_CMD_NPCSTATUS, optionState ) );
		
		SSAV_LoadNPCStatus();
	
	elseif( command == "god" and optionState ) then
		SSAV_Config.god = optionValue;
		SSLibrary_Message( string.format( SSAV_CMD_GOD, optionState ) );
	
	elseif( command == "alliance" and optionState ) then
		SSAV_Config.alliance = optionValue;
		SSLibrary_Message( string.format( SSAV_CMD_FACTIONA, optionState ) );
	
	elseif( command == "print" ) then
		if( commandArg == command ) then
			commandArg = nil;
		end

		SSAV_PrintTimersToChat( commandArg );
	
	elseif( command == "status" ) then
		local statusList = {	{ SSAV_Config.enabled, SSAV_CMD_ENABLED }, { SSAV_Config.interval, SSAV_CMD_INTERVAL },
					{ SSAV_Config.horde, SSAV_CMD_FACTIONH }, { SSAV_Config.alliance, SSAV_CMD_FACTIONA },
					{ SSAV_Config.npc, SSAV_CMD_NPCSTATUS }, };

		for _, data in pairs( statusList ) do
			local status = RED_FONT_COLOR_CODE .. SSAV_OFF .. FONT_COLOR_CODE_CLOSE;
			if( data[1] ) then
				status = GREEN_FONT_COLOR_CODE .. SSAV_ON .. FONT_COLOR_CODE_CLOSE;
			end
			
			SSLibrary_Message( string.format( data[2], status ) );
		end
	
	else
		for _, text in pairs( SSAV_HELP ) do
			SSLibrary_Message( text, ChatTypeInfo["SYSTEM"] );
		end
	end
end

function SSAV_SendMessage( msg )
	if( GetNumRaidMembers() > 0 ) then
		SSLibrary_RaidMessage( msg );
	elseif( GetNumRaidMembers() == 0 and GetNumPartyMembers() > 0 ) then
		SSLibrary_PartyMessage( msg );
	end
end

function SSAV_ReloadOverlay()
	if( not SSLibrary_IsInAV() ) then
		SSOverlay_RemoveRow( { cat = "av" } );
		SSOverlay_RemoveRow( { cat = "avitem" } );
		SSOverlay_RemoveRow( { cat = "avnpc" } );
		return;
	end
	
	if( not SSAV_Config.overlay ) then
		SSOverlay_RemoveRow( { cat = "av" } );
	else
		SSLibrary_RequestAVTimers();
	end
	
	SSAV_LoadNPCStatus();	
	SSAV_LoadAVItems();
end

function SSAV_LoadAVItems()
	if( not SSAV_Config.avcrystal and not SSAV_Config.avmedals and not SSAV_Config.avarmor ) then
		SSOverlay_RemoveRow( { cat = "avitem" } );
		return;
	end
	
	local _, PlayerFaction = UnitFactionGroup( "player" );
	
	local ItemList = {};
	
	if( PlayerFaction == "Alliance" ) then
		table.insert( ItemList, { text = SSAV_CRYSTALS, id = 17423, type = "avcrystal" } );
		table.insert( ItemList, { text = SSAV_ARMORSCRAP, id = 17422, type = "avarmor" } );
		table.insert( ItemList, { text = SSAV_SOLDIERMED, id = 17502, type = "avmedals" } );
		table.insert( ItemList, { text = SSAV_LIETMED, id = 17503, type = "avmedals" } );
		table.insert( ItemList, { text = SSAV_COMMED, id = 17504, type = "avmedals" } );
	
	elseif( PlayerFaction == "Horde" ) then
		table.insert( ItemList, { text = SSAV_AMORSCRAP, id = 17422, type = "avarmor" } );
		table.insert( ItemList, { text = SSAV_BLOOD, id = 17306, type = "avcrystal" } );
		table.insert( ItemList, { text = SSAV_SOLDFLESH, id = 17326, type = "avmedals" } );
		table.insert( ItemList, { text = SSAV_LIETFLESH, id = 17327, type = "avmedals" } );
		table.insert( ItemList, { text = SSAV_COMMFLESH, id = 17328, type = "avmedals" } );
	else
		SSOverlay_RemoveRow( { cat = "avitem" } );
		return;
	end
	
	local ItemAdded = false;
	
	-- Now add the flavor items if enabled
	for id, item in pairs( ItemList ) do
		if( SSAV_Config[ item.type ] ) then
			SSOverlay_UpdateRow( { type = "item", text = item.text, item = item.id, cat = "avitem" } );
			ItemAdded = true;
		else
			SSOverlay_RemoveRow( { cat = "avitem", text = item.text } );
		end
	end
	
	if( not ItemAdded ) then
		SSOverlay_RemoveRow( { cat = "avitem" } );
	end
end


function SSAV_SendAVSync()
	SSLibrary_CommMessage( SSAV_SYNC_NOW, "SSAV" );
end

function SSAV_PrintSingleTimer()
	local timer = this.extraData;
	
	if( GetTime() >= timer.endTime ) then
		return;
	end
	
	SendChatMessage( string.format( SSAV_CHAT_TIMER, timer.name, timer.faction, SSLibrary_SecondsToBuff( timer.endTime - GetTime() ) ), "BATTLEGROUND" );
end

function SSAV_PrintTimersToChat( channel )
	local channelType = "BATTLEGROUND";
	
	-- Quick hack
	if( channel and type( channel ) == "table" ) then
		channel = nil;
	end
	
	-- Make sure it's a valid type
	channelType = string.upper( channel or channelType );

	if( channelType ~= "GUILD" and channelType ~= "PARTY" and channelType ~= "RAID" and channelType ~= "BATTLEGROUND" and channelType ~= "SAY" ) then
		SSLibrary_Message( string.format( SSAV_INVALID_CHANTYPE, channel ), ChatTypeInfo["SYSTEM"] );
		return;
	end
	
	for id, timer in pairs( AVTimers ) do
		if( GetTime() <= timer.endTime ) then
			SendChatMessage( string.format( SSAV_CHAT_TIMER, timer.name, timer.faction, SSLibrary_SecondsToBuff( timer.endTime - GetTime() ) ), channelType );
		end
	end
end

function SSAV_ChatFrame_OnEvent( event )
	if( SSAV_Config.enabled and event == "CHAT_MSG_MONSTER_YELL" and arg2 == SS_HERALD ) then
		return;
	end
	
	return Orig_ChatFrame_OnEvent( event );
end

function SSAV_PrintTimer( name )
	local data, dataIndex;
	
	-- Find the data first ( of course )
	for id, timer in pairs( AVTimers ) do
		if( timer.name == name ) then
			data = timer;
			dataIndex = id;
		end
	end
	
	if( data == nil or dataIndex == nil or not data.endTime ) then
		return;
	end
	
	local timeLeft = ceil( data.endTime - GetTime() );
	
	if( timeLeft <= 0 ) then
		return;
	end
	
	if( ( not SSAV_Config.enabled ) or ( not SSAV_Config.horde and data.faction == SS_HORDE ) or ( not SSAV_Config.alliance and data.faction == SS_ALLIANCE ) ) then
		return;
	end
	
	SSLibrary_PVPMessage( string.format( SSAV_TIMERUPDATE, data.name, data.type, data.faction, string.lower( SSLibrary_SecondsToFull( timeLeft ) ) ), data.faction );
end

function SSAV_AddTimer( name, faction, type, endTime )
	local events = {};
	local seconds = 1;
	local secondsLeft = 300;

	SSLibrary_UnScheduleEvent( "SSAV_PrintTimer", name );
	
	if( endTime ) then
		secondsLeft = endTime - GetTime();
	end

	-- Schedule the status events
	if( type ~= "god" ) then
		while( seconds < secondsLeft ) do
			if( mod( seconds, SSAV_Config.interval ) == 0 ) then
				SSLibrary_ScheduleEvent( "SSAV_PrintTimer", seconds, name );
			end

			seconds = seconds + 1;
		end	
	end
	
	-- Does an event by this name exist?
	for i=#( AVTimers ), 1, -1 do
		if( AVTimers[i].name == name ) then
			SSOverlay_RemoveRow( { cat ="av", text = name } );
			table.remove( AVTimers, i );
		end
	end

	
	endTime = ( endTime or ( GetTime() + ( 60 * 5 ) ) );
	
	if( SSAV_Config.overlay ) then
		local timerFormat, extra;
		if( type == "god" ) then
			timerFormat = "*text*: *extra1* *timer*";
			extra = { SS_MOVING };
		end
	
		SSOverlay_UpdateRow( {	type = "down",
					seconds = secondsLeft,
					text = name,
					color = SSLibrary_GetFactionColor( faction ),
					mouseUp = SSAV_PrintSingleTimer,
					format = timerFormat,
					extra = extra,
					extraData = { name = name, faction = faction, endTime = endTime },
					cat = "av" } );
	end

	table.insert( AVTimers, { name = name, faction = faction, type = type, endTime = endTime } );
end

function SSAV_LoadNPCStatus()
	if( SSAV_Config.npc ) then
		SSOverlay_UpdateRow( { type = "text", text = SSAV_NPCSTATUS, newText = SSAV_NPCSTATUS, cat = "avnpc", catText = true } );
		
		for id, npc in pairs( SSAV_NPC_NAMES ) do
			SSOverlay_UpdateRow( {	type = "text",
						text = npc.overlayName,
						cat = "avnpc",
						color = SSLibrary_GetFactionColor( npc.faction ),
						extra = { SSAV_NPC_STATUS["reset"] } } );
		end
	else
		SSOverlay_RemoveRow( { cat = "avnpc" } );
	end
end

function SSAV_AddOverlayCategories()
	SSOverlay_AddAsFirstCategory( "avnpc", { text = SSAV_NPCINFO } );
	SSOverlay_AddCategory( "avitem", { text = SSAV_ITEMS } );
	SSOverlay_AddCategory( "av", {	mouseUp = SSAV_PrintTimersToChat,
					text = SSAV_TIMERS,
					newText = SSAV_TIMERS } );			
end

function SSAV_OnEvent( event, ... )
	if( event == "ADDON_LOADED" and arg1 == "SSAV" ) then
		if( SSAV_Config == nil ) then
			SSAV_Config = SSAV_GetDefaultConfig( nil, true );
		end
		
		-- Hook chat frame
		Orig_ChatFrame_OnEvent = ChatFrame_OnEvent;
		ChatFrame_OnEvent = SSAV_ChatFrame_OnEvent;

		-- Load any timers that are already active
		if( SSLibrary_IsInAV() ) then
			SSAV_AddOverlayCategories();
			
			SSLibrary_RequestAVTimers();
			SSAV_ReloadOverlay();
		end
		
	elseif( event == "CHAT_MSG_ADDON" and arg1 == "SSAV" ) then
		if( arg2 == SSAV_SYNC_NOW ) then
			SSLibrary_Message( string.format( SSAV_SYNC_RECIEVED, arg4 ), ChatTypeInfo["SYSTEM"] );
			
			if( GetBattlefieldInfo() == SS_ALTERACVALLEY ) then
				JoinBattlefield( 0 );
				HideUIPanel( BattlefieldFrame );
			end
		end
	
	elseif( event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" and SSLibrary_IsInAV() ) then
		
		for id, npc in pairs( SSAV_NPC_NAMES ) do
			if( string.find( arg1, npc.name ) ) then
				SSOverlay_RemoveRow( { text = npc.overlayName } );
			end
		end
		
	elseif( event == "AV_ALLIANCE_GOD_SUMMONED" and SSAV_Config.god ) then
		SSAV_AddTimer( SS_IVUS_FOREST_LORD, SS_ALLIANCE, "god", GetTime() + ( 10 * 60 ) )
	
	elseif( event == "AV_HORDE_GOD_SUMMONED" and SSAV_Config.god ) then
		SSAV_AddTimer( SS_LOKHOLAR_ICE_LORD, SS_HORDE, "god", GetTime() + ( 10 * 60 ) )
	
	elseif( event == "CHAT_MSG_MONSTER_YELL" and SSAV_Config.npc and SSLibrary_IsInAV() ) then
		local npc;
		
		-- Figure out if we care about it
		for id, mob in pairs( SSAV_NPC_NAMES ) do
			if( mob.name == arg2 ) then
				npc = mob;
				break;
			end
		end
		
		-- Not a NPC we care about
		if( not npc ) then
			return;
		end
		
		-- Now search messages
		for id, yell in pairs( SSAV_NPC_YELLS ) do
			if( yell.npc == npc.abbrev ) then
				if( string.find( arg1, yell.text ) ) then
					
					if( npc.timeout > 0 and yell.status == "engaged" ) then
						SSOverlay_UpdateRow( {	text = npc.overlayName,
									seconds = npc.timeout,
									type = "down",
									cat = "avnpc",
									format = "*text*: *extra1*",
									looseMatch = true;
									color = SSLibrary_GetFactionColor( npc.faction ),
									extra = { SSAV_NPC_STATUS[ yell.status ] } } );
					else
						SSOverlay_UpdateRow( {	text = npc.overlayName,
									type = "text",
									cat = "avnpc",
									format = "*text*: *extra1*",
									looseMatch = true,
									color = SSLibrary_GetFactionColor( npc.faction ),
									extra = { SSAV_NPC_STATUS[ yell.status ] or SSAV_NPC_STATUS["reset"] } } );
					end
				end
			end
		end
		
	
	elseif( event == "BATTLEFIELD_INFO_UPDATED" ) then
		AVTimers = {};
		SSOverlay_RemoveRow( { cat = "av" } );
		SSOverlay_RemoveRow( { cat = "avitem" } );
		SSOverlay_RemoveRow( { cat = "avnpc" } );
		
		if( select( 2, ... ) == SS_ALTERACVALLEY ) then
			SSAV_AddOverlayCategories();
			
			SSLibrary_RequestAVTimers();
			SSAV_ReloadOverlay();
		end
	
	elseif( event == "BATTLEFIELD_WON" or event == "LEFT_BATTLEFIELD" ) then
		AVTimers = {};
		SSOverlay_RemoveRow( { cat = "av" } );
		SSOverlay_RemoveRow( { cat = "avitem" } );
		SSOverlay_RemoveRow( { cat = "avnpc" } );
		
	elseif( event == "AV_RESOURCE_LOADED" and SSAV_Config.enabled ) then
		if( select( 3, ... ) == "capture" ) then
			SSAV_AddTimer( select( 1, ... ), select( 2, ... ), SS_CAPTURED, select( 4, ... ) );
		elseif( select( 3, ... ) == "destroy" ) then
			SSAV_AddTimer( select( 1, ... ), select( 2, ... ), SS_DESTROYED, select( 4, ... ) );
		end

	elseif( event == "AV_RESOURCE_CAPTURED" or event == "AV_RESOURCE_DESTROYED" ) then
		for i=#( AVTimers ), 1, -1 do
			local timer = AVTimers[ i ];
			
			if( timer.name == arg1 ) then
				SSLibrary_UnScheduleEvent( "SSAV_PrintTimer", timer.name );
				SSOverlay_RemoveRow( { cat = "av", type = "down", text = timer.name, matchType = true } );
				
				table.remove( AVTimers, i );
			end
		end
	
	elseif( event == "AV_HERALD_MESSAGE" and SSAV_Config.enabled ) then
		SSLibrary_PVPMessage( select( 1, ... ), select( 2, ... ) );
		
	elseif( event == "AV_RESOURCE_DESTROYING" and SSAV_Config.enabled ) then
		SSAV_AddTimer( select( 1, ... ), select( 2, ... ), SS_DESTROYED );
		
	elseif( ( event == "AV_RESOURCE_CAPTURING" or event == "AV_RESOURCE_CLAIMED" ) and SSAV_Config.enabled ) then
		SSAV_AddTimer( select( 1, ... ), select( 2, ... ), SS_CAPTURED );
	end
end


function SSAV_LoadUI()
	SSUI_RegisterVarType( "ssav", "SSAV_SetVariable", "SSAV_GetVariable" );

	SSUI_AddTab( SS_ALTERACVALLEY, "SSAVConfig", 6 );
	SSUI_AddFrame( "SSAVConfig", "sspvp" );

	-- Add the elements
	local UIList = {
		{ name = "SSAVEnable", text = SSAV_UI_ENABLE, type = "check", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "ssav", var = { "enabled" }, parent = "SSAVConfig" };
		{ name = "SSEnableAVOverlay", text = SSAV_UI_ENABLEOVERLAY, type = "check", onClick = "SSAV_ReloadOverlay", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssav", var = { "overlay" }, parent = "SSAVConfig" },
		{ name = "SSEnableAVGods", text = SSAV_UI_GODSUMMON, tooltip = SSAV_UI_GODSUMMON_TT, type = "check", onClick = "SSAV_ReloadOverlay", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssav", var = { "god" }, parent = "SSAVConfig" },

		{ name = "SSAVInterval", text = SSAV_UI_INTERVAL, type = "input", points = { "LEFT", "LEFT", 10, -30 }, maxChars = 3, width = 30, varType = "ssav", forceType = "int", var = { "interval" }, parent = "SSAVConfig" };

		{ name = "SSAVEnableHorde", text = SSAV_UI_HORDEENABLE, type = "check", points = { "LEFT", "LEFT", -10, -30 }, varType = "ssav", var = { "horde" }, parent = "SSAVConfig" };
		{ name = "SSAVEnableAlliance", text = SSAV_UI_ALLIANCEENABLE, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssav", var = { "alliance" }, parent = "SSAVConfig" };
		{ name = "SSAVEnableNPC", text = SSAV_UI_NPCSTATUS, tooltip = SSAV_UI_NPCSTATUS_TT, onClick = "SSAV_ReloadOverlay", type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssav", var = { "npc" }, parent = "SSAVConfig" };

		{ name = "SSEnableCrystals", text = SSAV_UI_BLOODCRYST, type = "check", onClick = "SSAV_ReloadOverlay", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssav", var = { "avcrystal" }, parent = "SSAVConfig" },
		{ name = "SSEnableMedals", text = SSAV_UI_ARMOR, type = "check", onClick = "SSAV_ReloadOverlay", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssav", var = { "avarmor" }, parent = "SSAVConfig" },
		{ name = "SSEnableArmor", text = SSAV_UI_MEDALFLESH, type = "check", onClick = "SSAV_ReloadOverlay", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssav", var = { "avmedals" }, parent = "SSAVConfig" },
	};
	
	for id, element in pairs( UIList ) do
		SSUI_AddElement( element );
	end
end

-- Variable management
function SSAV_GetDefaultConfig( var, fullConfig )
	Config = {};
	Config.enabled = true;
	Config.interval = 60;
	Config.horde = false;
	Config.alliance = false;
	Config.npc = false;
	Config.overlay = true;
	Config.avcrystal = false;
	Config.avmedal = false;
	Config.avarmor = false;
	Config.god = true;
	
	if( fullConfig ) then
		return Config;
	elseif( var ) then
		return Config[ var ];
	end
	
	return nil;
end

function SSAV_GetVariable( vars )
	if( SSAV_Config[ vars[1] ] == nil ) then
		SSAV_Config[ vars[1] ] = SSAV_GetDefaultConfig( vars[1] );
	end
	
	return SSAV_Config[ vars[1] ];
end

function SSAV_SetVariable( vars, value )
	SSAV_Config[ vars[1] ] = value;
end