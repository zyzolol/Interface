local CurrentBG = { id = -1, joining = -1, teamSize = 0 };

local LastQueueData = {};

local BGPlayerData = {};
local TotalPlayers = {};

local RegisteredEvents = {};
local ScheduledEvents = {};

local TimeElapsed = 0;
local ScoreTimeElapsed = 0;

function SSLibrary_OnLoad()
	this:RegisterEvent( "VARIABLES_LOADED" );
	
	this:RegisterEvent( "UPDATE_BATTLEFIELD_STATUS" );
	this:RegisterEvent( "UPDATE_BATTLEFIELD_SCORE" );
	
	this:RegisterEvent( "CHAT_MSG_CHANNEL" );
	this:RegisterEvent( "CHAT_MSG_MONSTER_YELL" );	
	this:RegisterEvent( "CHAT_MSG_BG_SYSTEM_HORDE" );
	this:RegisterEvent( "CHAT_MSG_BG_SYSTEM_ALLIANCE" );
	this:RegisterEvent( "CHAT_MSG_BG_SYSTEM_NEUTRAL" );
end

-- Add the blacklist instance stuff later
function SSLibrary_GetBGLimit()
	if( CurrentBG.map == SS_WARSONGGULCH ) then
		return 10;
	elseif( CurrentBG.map == SS_ARATHIBASIN or CurrentBG.map == SS_EYEOFTHESTORM ) then
		return 15;
	elseif( CurrentBG.map == SS_ALTERACVALLEY ) then
		return 40;
	end
	
	return 0;
end

function SSLibrary_PlayerInArena()
	return ( CurrentBG.id > 0 and CurrentBG.teamSize > 0 );
end

function SSLibrary_PlayerInBG()
	return ( CurrentBG.id > 0 );
end

function SSLibrary_GetNumActiveBG()
	local active = 0;
	for i = 1, MAX_BATTLEFIELD_QUEUES do
		if( GetBattlefieldStatus( i ) == "active" ) then
			active = active + 1;
		end
	end
	
	return active;
end

function SSLibrary_IsInAV()
	return ( CurrentBG.map == SS_ALTERACVALLEY );
end

function SSLibrary_IsInWSG()
	return ( CurrentBG.map == SS_WARSONGGULCH );
end

function SSLibrary_IsInAB()
	return ( CurrentBG.map == SS_ARATHIBASIN );
end

function SSLibrary_IsInEOS()
	return ( CurrentBG.map == SS_EYEOFTHESTORM );
end

function SSLibrary_IsQueuedToJoin()
	return ( CurrentBG.joining > 0 );
end

function SSLibrary_GetServer( name )
	local characterName, serverName;
	local serverPos = string.find( name, "-" );

	if( serverPos ~= nil ) then
		characterName = string.sub( name, 1, serverPos - 1 );
		serverName = string.sub( name, serverPos + 1 );
	else
		characterName = name;
	end
	
	return characterName, serverName;
end

function SSLibrary_CommMessage( msg, prefix, location )
	SendAddonMessage( prefix or "SSLIB", msg, location or "RAID" );
end

function SSLibrary_RaidMessage( msg )
	SendChatMessage( msg, "RAID" );
end

function SSLibrary_PartyMessage( msg )
	SendChatMessage( msg, "PARTY" );
end

function SSLibrary_WhisperMessage( msg, target )
	SendChatMessage( msg, "WHISPER", nil, target );
end

function SSLibrary_Message( msg, color )
	if( color == nil ) then
		color = { r = 1, g = 1, b = 1 };
	end
	
	DEFAULT_CHAT_FRAME:AddMessage( msg, color.r, color.g, color.b );
end

function SSLibrary_GetFactionColor( faction )
	local color = ChatTypeInfo["BG_SYSTEM_NEUTRAL"];
	
	if( faction == SS_HORDE or faction == "Horde" ) then
		color = ChatTypeInfo["BG_SYSTEM_HORDE"];
	elseif( faction == SS_ALLIANCE or faction == "Alliance" ) then
		color = ChatTypeInfo["BG_SYSTEM_ALLIANCE"];
	end
	
	if( not color ) then
		return { r = 1, g = 1, b = 1 };
	end
	
	return { r = color.r, g = color.g, b = color.b };
end

function SSLibrary_PVPMessage( msg, faction )
	if( faction == SS_ALLIANCE or faction == "Alliance" ) then
		SSLibrary_Message( msg, ChatTypeInfo["BG_SYSTEM_ALLIANCE"] );
	elseif( faction == SS_HORDE or faction == "Horde" ) then
		SSLibrary_Message( msg, ChatTypeInfo["BG_SYSTEM_HORDE"] );
	else
		SSLibrary_Message( msg, ChatTypeInfo["BG_SYSTEM_NEUTRAL"] );
	end
end

-- Get the unlocalized and the abbreved version of a class name using the localized version
function SSLibrary_GetUnLocalizedClass( localizedClass )
	for id, class in pairs( SS_CLASSNAMES ) do
		if( class[1] == localizedClass ) then
			return class[3], class[2];
		end
	end
	
	return nil, nil;
end

function SSLibrary_OnEvent( event )
	if( event == "VARIABLES_LOADED" ) then
		if( BGData == nil ) then
			BGData = {};
		end
		
		-- Do a quick data check to remove old timers
		SSLibrary_CheckData();

	elseif( event == "UPDATE_BATTLEFIELD_SCORE" ) then
		local TotalAlliance = 0;
		local TotalHorde = 0;
		
		-- If we're viewing a specific faction, clear the data for only them and use the cached data for the other
		if( WorldStateScoreFrameLabel:GetText() == SS_ALLIANCE_STATS ) then
			for i=#( BGPlayerData ), 1, -1 do
				if( BGPlayerData[ i ].faction ~= 0 ) then
					table.remove( BGPlayerData, i );
				end
			end
			
			TotalHorde = TotalPlayers["Horde"]; 
		
		elseif( WorldStateScoreFrameLabel:GetText() == SS_HORDE_STATS ) then
			for i=#( BGPlayerData ), 1, -1 do
				if( BGPlayerData[ i ].faction == 0 ) then
					table.remove( BGPlayerData, i );
				end
			end
			
			TotalAlliance = TotalPlayers["Alliance"];
		else
			-- Alright viewing all, clear cache
			TotalPlayers = { Alliance = 0, Horde =  0 };
			BGPlayerData = {};
		end
				
		for i=1, GetNumBattlefieldScores() do
			local name, kb, hk, deaths, honor, faction, rank, race, class, server = GetBattlefieldScore( i );
			
			-- Seperate name and server name
			name, server = SSLibrary_GetServer( name );
			server = ( server or GetRealmName() );
			
			if( faction == 0 ) then
				TotalHorde = TotalHorde + 1;
			else
				TotalAlliance = TotalAlliance + 1;
			end
			
			table.insert( BGPlayerData, { name = name, server = server, kb = kb, hk = hk, deaths = deaths, honor = honor, faction = faction, rank = rank, race = race, class = class } );
		end
		
		TotalPlayers = { Alliance = TotalAlliance, Horde = TotalHorde };
		
		SSLibrary_FireEvent( "BATTLEFIELD_TOTALS_CHANGED", TotalAlliance, TotalHorde );
		SSLibrary_FireEvent( "BATTLEFIELD_SCORES_UPDATED", BGPlayerData );
	
	elseif( event == "UPDATE_BATTLEFIELD_STATUS" ) then
		local queueData = {};
		
		for i = 1, MAX_BATTLEFIELD_QUEUES do
			local status, map, id, _, _, teamSize = GetBattlefieldStatus( i );

			-- Ready to join battlefield
			if( status == "confirm" and i ~= CurrentBG.joining ) then
				if( CurrentBG.id == -1 ) then
					BGData = {};
					CurrentBG = { joining = i, id = -1, teamSize = 0 };
				end
				
				SSLibrary_FireEvent( "BATTLEFIELD_QUEUE_READY", i, map );
			
			-- Joined a battlefield with an invalid id set
			elseif( status == "active" and i ~= CurrentBG.id ) then
				BGData = {};
				CurrentBG = { id = i, map = map, teamSize = teamSize, joining = -1 };
				
				RequestBattlefieldScoreData();
				SSLibrary_FireEvent( "BATTLEFIELD_INFO_UPDATED", i, map );
			
			-- Left an active battlefield
			elseif( status ~= "active" and i == CurrentBG.id ) then
				CurrentBG = { id = -1, joining = -1, teamSize = 0 };
				BGData = {};

				SSLibrary_FireEvent( "LEFT_BATTLEFIELD", i, map );
			
			-- We left the queue before we could auto join
			elseif( status == "none" and i == CurrentBG.joining ) then
				CurrentBG = { joining = -1, id = -1, teamSize = 0 };
			end
			
			if( map ~= nil ) then
				queueData[ map ] = {};
				queueData[ map ] = { id = i, status = status };
			end
		end		
		
		-- Now figure out what queues we left
		for map, data in pairs( LastQueueData ) do
			if( ( not queueData[ map ] or queueData[ map ].status == "none" ) and map ~= SS_EASTERNKING ) then	
				SSLibrary_FireEvent( "LEFT_BATTLEGROUND_QUEUE", data.id, map );
				queueData[ map ] = nil;
			end
		end

		-- Figure out what queues we joined
		for map, data in pairs( queueData ) do
			if( ( not LastQueueData[ map ] or LastQueueData[ map ].status == "none" ) and map ~= SS_EASTERNKING and data.status ~= "none" ) then
				SSLibrary_FireEvent( "JOIN_BATTLEGROUND_QUEUE", data.id, map );
			end
		end
		
		for i = 1, MAX_BATTLEFIELD_QUEUES do
			local status, map = GetBattlefieldStatus( i );
			
			if( status ~= "none" ) then
				SSLibrary_FireEvent( "BATTLEGROUND_QUEUE_UPDATED", i, status, map );
			end
		end
				
		
		-- Is the battlefield over?
		if( GetBattlefieldWinner() ) then
			local winner;
			if( GetBattlefieldWinner() == 0 ) then
				winner = SS_HORDE;
			else
				winner = SS_ALLIANCE;
			end

			SSLibrary_FireEvent( "BATTLEFIELD_WON", winner );
		end

		LastQueueData = queueData;
		
	elseif( event == "CHAT_MSG_MONSTER_YELL" ) then
		SSLibrary_ParseAVEvent( arg1, arg2, event );
	
	elseif( event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" ) then
		for _, battle in pairs( SS_BATTLESTART ) do
			if( string.find( arg1, battle.search ) ) then
				SSLibrary_FireEvent( "BATTLEFIELD_START_IN", battle.time );
				break;
			end
		end
	
	elseif( event == "CHAT_MSG_BG_SYSTEM_HORDE" or event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" ) then
		if( CurrentBG.map == SS_WARSONGGULCH ) then
			SSLibrary_ParseWSGEvent( arg1, event );
		elseif( CurrentBG.map == SS_ARATHIBASIN ) then
			SSLibrary_ParseABEvent( arg1, event );
		elseif( CurrentBG.map == SS_ALTERACVALLEY ) then
			SSLibrary_ParseAVEvent( arg1, SS_HERALD, event, true );
		end
	end
end

-- Event parsing
function SSLibrary_RequestCarrierData()
	if( CurrentBG.map ~= SS_WARSONGGULCH ) then
		return;
	end

	BGData["Alliance"] = ( BGData["Alliance"] or "" );
	BGData["Horde"] = ( BGData["Horde"] or "" );
	
	SSLibrary_FireEvent( "WSG_CARRIER_LOADED", BGData["Alliance"], "Alliance" );
	SSLibrary_FireEvent( "WSG_CARRIER_LOADED", BGData["Horde"], "Horde" );
end

function SSLibrary_ParseWSGEvent( msg, event )
	local PlayerFaction, localizedFaction = UnitFactionGroup( "player" );
	local enemyFaction, factionUsed, factionFrom,unLocalEnemy, unLocalFaction;
	
	-- Figure out who the enemy faction is
	if( localizedFaction == SS_HORDE ) then
		enemyFaction = SS_ALLIANCE;
		unLocalEnemy = "Alliance";
	
	elseif( localizedFaction == SS_ALLIANCE ) then
		enemyFaction = SS_HORDE;
		unLocalEnemy = "Horde";
	end
	
	-- Now figure out which message it's for ( our faction = enemy message, enemy faction = friendly message )
	if( string.find( msg, localizedFaction ) ) then
		factionUsed = localizedFaction;
		unLocalFaction = PlayerFaction;

	elseif( string.find( msg, enemyFaction ) ) then
		factionUsed = enemyFaction;
		unLocalFaction = unLocalEnemy;
	else
		return;
	end
	
	-- Set the messages
	local pickedUp = string.format( SS_WSG_PICKEDUP, factionUsed );
	local dropped = string.format( SS_WSG_DROPPED, factionUsed );
	local captured = string.format( SS_WSG_CAPTURED, factionUsed );
	
	-- Alright, time to find out whats going on
	if( string.find( msg, pickedUp ) ) then
		local _, _, playerName = string.find( msg, pickedUp );
		BGData[ unLocalFaction ] = playerName;
		
		SSLibrary_FireEvent( "WSG_FLAG_PICKEDUP", playerName, unLocalFaction );
	elseif( string.find( msg, dropped ) ) then
		local _, _, playerName = string.find( msg, dropped );
		BGData[ unLocalFaction ] = "";	

		SSLibrary_FireEvent( "WSG_FLAG_DROPPED", playerName, unLocalFaction );
	elseif( string.find( msg, captured ) ) then
		local _, _, playerName = string.find( msg, captured );
		BGData[ unLocalFaction ] = "";
		
		SSLibrary_FireEvent( "WSG_FLAG_CAPTURED", playerName, unLocalFaction );
	end
end

-- "Borrowed" from UIParent.lua, but shows full hours/minutes/seconds instead of short hand
function SSLibrary_SecondsToFull( seconds, noSeconds )
	local time = "";
	local tempTime;
	local count = 0;
	
	seconds = floor( seconds );
	
	if( seconds > 3600 ) then
		tempTime = floor( seconds / 3600 );
		time = time .. tempTime .. " " .. GetText( "HOURS", nil, tempTime ) .. " ";
		seconds = mod( seconds, 3600 );
		count = count + 1;
	end
	if( count < 2 and seconds >= 60 ) then
		tempTime = floor( seconds / 60 );
		time = time .. tempTime .. " " .. GetText( "MINUTES", nil, tempTime ) .. " ";
		seconds = mod( seconds, 60 );
		count = count + 1;
	end
	
	if( count < 2 and seconds > 0 and not noSeconds ) then
		seconds = format( "%d", seconds );
		time = time .. seconds .. " " .. GetText( "SECONDS", nil, seconds ) .. " ";
	end
	
	return string.sub( time, 1, string.len( time ) - 1 );
end

-- Convert time into hh:mm:ss format ( clean up later )
function SSLibrary_SecondsToBuff( seconds )
	seconds = floor( seconds );
	local hours, minutes;
	
	if( seconds >= 3600 ) then
		hours = floor( seconds / 3600 );
		if( hours <= 9 ) then
			hours = "0" .. hours; 
		end
		
		hours = hours .. ":";
		seconds = mod( seconds, 3600 );
	else
		hours = "";
	end
	
	if( seconds >= 60 ) then
		minutes = floor( seconds / 60 );
		if( minutes <= 9 ) then
			minutes = "0" .. minutes;
		end
		
		seconds = mod( seconds, 60 );
	else
		minutes = "00";
	end
	
	if( seconds <= 9 and seconds > 0 ) then
		seconds = "0" .. seconds;
	elseif( seconds <= 0 ) then
		seconds = "00";
	end
	
	return hours .. minutes .. ":" .. seconds;
end


function SSLibrary_RequestABTimers()
	if( CurrentBG.map ~= SS_ARATHIBASIN ) then
		return;
	end
	
	for i=#( BGData ), 1, -1 do
		if( type( data ) == "table" and data.endTime > GetTime() ) then
			SSLibrary_FireEvent( "AB_RESOURCE_LOADED", data.name, data.faction, data.endTime );
		else
			table.remove( BGData, i );
		end
	end
end

-- Clean this up later
function SSLibrary_CheckData()
	-- Figure out whats active
	for i=#( BGData ), 1, -1 do
		if( type( BGData[ i ] ) == "table" and BGData[ i ].endTime ) then
			if( tonumber( BGData[ i ].endTime ) < GetTime() ) then
				table.remove( BGData, i );
			end
		end
	end
end

function SSLibrary_ParseABEvent( msg, event )
	local factionFound;
	if( string.sub( event, 20 ) == "ALLIANCE" ) then
		factionFound = SS_ALLIANCE;
	elseif( string.sub( event, 20 ) == "HORDE" ) then
		factionFound = SS_HORDE;
	end
	
	if( string.find( msg, SS_AB_TAKEN ) ) then
		local _, _, resourceName = string.find( msg, SS_AB_TAKEN );
		
		for i=#( BGData ), 1, -1 do
			if( type( BGData[i] ) == "table" and BGData[i].name == resourceName ) then
				table.remove( BGData, i );
			end
		end

		SSLibrary_FireEvent( "AB_RESOURCE_CAPTURED", resourceName, factionFound );
	elseif( string.find( msg, SS_AB_ASSAULTED ) ) then
		local _, _, resourceName = string.find( msg, SS_AB_ASSAULTED );
		
		table.insert( BGData, { name = resourceName, faction = factionFound, startTime = GetTime(), endTime = GetTime() + 60 } );

		SSLibrary_FireEvent( "AB_RESOURCE_ASSAULTED", resourceName, factionFound );
	elseif( string.find( msg, SS_AB_CLAIMS ) ) then
		local _, _, resourceName = string.find( msg, SS_AB_CLAIMS );
		
		table.insert( BGData, { name = resourceName, faction = factionFound, startTime = GetTime(), endTime = GetTime() + 60 } );
		SSLibrary_FireEvent( "AB_RESOURCE_CLAIMED", resourceName, factionFound );
	end
end

function SSLibrary_RequestAVTimers()
	if( CurrentBG.map ~= SS_ALTERACVALLEY ) then
		return;
	end

	for i=#( BGData ), 1, -1 do
		if( type( data ) == "table" and data.endTime > GetTime() ) then
			SSLibrary_FireEvent( "AV_RESOURCE_LOADED", data.name, data.faction, data.type, data.endTime );
		else
			table.remove( BGData, i );
		end
	end
end


function SSLibrary_ParseAVEvent( msg, author, event, dontSend )
	local factionFound;
	
	if( author == SS_IVUS_FOREST_LORD ) then
		if( string.find( msg, SS_IVUS_SUMMONED ) ) then
			table.insert( BGData, { name = SS_IVUS_FOREST_LORD, type = "god", faction = SS_ALLIANCE, startTime = GetTime(), endTime = GetTime() + ( 60 * 10 ) } );
			SSLibrary_FireEvent( "AV_ALLIANCE_GOD_SUMMONED" );
		end

	elseif( author == SS_LOKHOLAR_ICE_LORD ) then
		if( string.find( msg, SS_LOKHOLAR_SUMMONED ) ) then
			table.insert( BGData, { name = SS_LOKHOLAR_ICE_LORD, type = "god", faction = SS_HORDE, startTime = GetTime(), endTime = GetTime() + ( 60 * 10 ) } );
			SSLibrary_FireEvent( "AV_HORDE_GOD_SUMMONED" );
		end
	
	elseif( author ~= SS_HERALD ) then
		return;
	end
	
	if( string.find( msg, SS_ALLIANCE ) ) then
		factionFound = SS_ALLIANCE;
	elseif( string.find( msg, SS_HORDE ) ) then
		factionFound = SS_HORDE;
	end
	
	
	-- Something was taken or saved from being taken (Graveyards)
	if( string.find( msg, SS_AV_TAKEN ) ) then
		if( not dontSend ) then
			SSLibrary_FireEvent( "AV_HERALD_MESSAGE", msg, factionFound );
		end

		local _, _, resourceName = string.find( msg, SS_AV_TAKEN );
		
		SSLibrary_FireEvent( "AV_RESOURCE_CAPTURED", resourceName, factionFound );

		for i=#( BGData ), 1, -1 do
			if( type( BGData[i] ) == "table" and string.lower( BGData[i].name ) == string.lower( resourceName ) ) then
				table.remove( BGData, i );
			end
		end
	
	-- Something was destroyed (Towers/Bunkers)
	elseif( string.find( msg, SS_AV_DESTROYED ) ) then
		if( not dontSend ) then
			SSLibrary_FireEvent( "AV_HERALD_MESSAGE", msg, factionFound );
		end

		local _, _, resourceName = string.find( msg, SS_AV_DESTROYED );
		
		SSLibrary_FireEvent( "AV_RESOURCE_DESTROYED", resourceName, factionFound );			

		for i=#( BGData ), 1, -1 do
			if( type( BGData[i] ) == "table" and string.lower( BGData[i].name ) == string.lower( resourceName ) ) then
				table.remove( BGData, i );
			end
		end
	
	-- Something is being destroyed (Tower/Bunkers)
	elseif( string.find( msg, SS_DESTROY ) ) then
		if( not dontSend ) then
			SSLibrary_FireEvent( "AV_HERALD_MESSAGE", msg, factionFound );
		end

		local _, _, resourceName = string.find( msg, SS_AV_UNDERATTACK );
		
		if( resourceName ) then
			table.insert( BGData, { name = resourceName, type = "destroy", faction = factionFound, startTime = GetTime(), endTime = GetTime() + ( 60 * 5 ) } );
			SSLibrary_FireEvent( "AV_RESOURCE_DESTROYING", resourceName, factionFound );
		end
	
	-- Something is being captured (Graveyards)
	elseif( string.find( msg, SS_CAPTURE ) ) then
		if( not dontSend ) then
			SSLibrary_FireEvent( "AV_HERALD_MESSAGE", msg, factionFound );
		end

		local _, _, resourceName = string.find( msg, SS_AV_UNDERATTACK );
		
		if( resourceName ) then
			table.insert( BGData, { name = resourceName, type = "capture", faction = factionFound, startTime = GetTime(), endTime = GetTime() + ( 60 * 5 ) } )
			SSLibrary_FireEvent( "AV_RESOURCE_CAPTURING", resourceName, factionFound );
		end
	
	-- Something is being claimed and used ot be neutral (Graveyards)
	elseif( string.find( msg, SS_AV_CLAIMS ) ) then
		if( not dontSend ) then
			SSLibrary_FireEvent( "AV_HERALD_MESSAGE", msg, factionFound );
		end

		local _, _, resourceName = string.find( msg, SS_AV_CLAIMS );
		
		if( resourceName == SSAV_SNOWFALL_GY ) then
			resourceName = SSAV_CORRECT_SF_GY;
		end

		if( resourceName ) then
			table.insert( BGData, { name = resourceName, type = "capture", faction = factionFound, startTime = GetTime(), endTime = GetTime() + ( 60 * 5 ) } );
			SSLibrary_FireEvent( "AV_RESOURCE_CLAIMED", resourceName, factionFound );
		end
	end
end

-- Event handling
function SSLibrary_FireEvent( event, ... )
	for _, frame in pairs( RegisteredEvents ) do
		if( frame.event == event ) then
			getglobal( frame.obj )( event, ... );
		end
	end
end

function SSLibrary_RegisterEvent( obj, event )
	SSLibrary_UnregisterEvent( obj, event );
	
	table.insert( RegisteredEvents, { obj = obj, event = event } );
end

function SSLibrary_UnregisterEvent( obj, event )
	for i=#( RegisteredEvents ), 1, -1 do
		if( RegisteredEvents[ i ].obj == obj and RegisteredEvents[ i ].event == event ) then
			table.remove( RegisteredEvents, i );
		end
	end
end

function SSLibrary_UnregisterAllEvents( obj )
	for i=#( RegisteredEvents ), 1, -1 do
		if( RegisteredEvents[i].obj == obj ) then
			table.remove( RegisteredEvents, i );
		end
	end
end

-- Timer functions
function SSLibrary_ScheduleEvent( functionName, timeDelay, eventName )
	table.insert( ScheduledEvents, { functionName, GetTime() + timeDelay, eventName } );
end

function SSLibrary_UnScheduleEvent( functionName, eventName )
	for i=#( ScheduledEvents ), 1, -1 do
		local row = ScheduledEvents[ i ];
		if( row[1] == functionName ) then
			if( ( not eventName ) or ( eventName and eventName == row[3] ) ) then
				table.remove( ScheduledEvents, i );
			end
		end
	end
end

function SSLibrary_OnUpdate( elapsed )
	TimeElapsed = elapsed + TimeElapsed;
	
	if( TimeElapsed > 0.1 ) then
		TimeElapsed = TimeElapsed - 0.1;
		local currentTime = GetTime();
		
		for i=#( ScheduledEvents ), 1, -1 do
			local row = ScheduledEvents[ i ];
			
			if( row[2] <= currentTime ) then
				table.remove( ScheduledEvents, i );

				if( type( row[1] ) == "function" ) then
					row[1]( row[3] );
				else
					getglobal( row[1] )( row[3] );
				end
			end
		end
	end
	
	-- This makes sure that every 10 seconds we request new score data
	if( CurrentBG.id ~= -1 ) then
		ScoreTimeElapsed = ScoreTimeElapsed + elapsed;
		
		if( ScoreTimeElapsed > 10 ) then
			ScoreTimeElapsed = 0;

			SSLibrary_CheckData();
			RequestBattlefieldScoreData();
		end
	end
end

