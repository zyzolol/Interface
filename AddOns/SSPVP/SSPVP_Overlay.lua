local FactionBalance = { Alliance = 0, Horde = 0 };

function SSPVPO_OnLoad()
	this:RegisterEvent( "UPDATE_BATTLEFIELD_STATUS" );

	SSLibrary_RegisterEvent( "SSPVPO_OnEvent", "BATTLEFIELD_TOTALS_CHANGED" );
	SSLibrary_RegisterEvent( "SSPVPO_OnEvent", "BATTLEFIELD_INFO_UPDATED" );
	SSLibrary_RegisterEvent( "SSPVPO_OnEvent", "LEFT_BATTLEFIELD" );
	SSLibrary_RegisterEvent( "SSPVPO_OnEvent", "BATTLEFIELD_START_IN" );
end

function SSPVPO_OnEvent( event, ... )
	if( not IsAddOnLoaded( "SSOverlay" ) or not SSOverlay_Config.enabled ) then
		return;
	end
	
	if( event == "BATTLEFIELD_INFO_UPDATED" or event == "LEFT_BATTLEFIELD" ) then
		SSOverlay_RemoveRow( { cat = "factotals" } );
		SSOverlay_RemoveRow( { cat = "bginfo" } );
		
	elseif( event == "BATTLEFIELD_TOTALS_CHANGED" ) then
		FactionBalance = { Alliance = select( 1, ... ), Horde = select( 2, ... ) };
		
		SSPVPO_LoadFactionBalance();
	
	elseif( event == "BATTLEFIELD_START_IN" ) then
		SSPVPO_UpdateBGStart( select( 1, ... ) );
	elseif( event == "UPDATE_BATTLEFIELD_STATUS" ) then
		SSPVPO_UpdateQueue();
	end

end

function SSPVPO_UpdateBGStart( timeUntil )
	if( not SSPVP_Config.overlay.startin or not SSLibrary_PlayerInBG() or timeUntil == 0 ) then
		SSOverlay_RemoveRow( { cat = "bginfo", type = "down", matchType = true } );
		return;
	end
	
	SSOverlay_AddAsFirstCategory( "bginfo", { text = SS_BGINFO, id = 2 } );
	SSOverlay_UpdateRow( {	type = "down",
				cat = "bginfo",
				seconds = timeUntil,
				text = SS_STARTIN,
				newText = SS_STARTIN,
				} );
end

function SSPVPO_UpdateQueue()
	SSOverlay_RemoveRow( { cat = "queue" } );
	SSOverlay_RemoveRow( { cat = "bginfo", type = "text", matchType = true } );

	for i=1, MAX_BATTLEFIELD_QUEUES do
		local status, map, id = GetBattlefieldStatus( i );

		if( status == "confirm" or status == "queued" ) then
			if( status == "confirm" ) then
				SSPVPO_QueueReady( i, map );
			elseif( status == "queued" ) then
				SSPVPO_AddQueue( i, map );
			end

		elseif( status == "active" ) then
			if( not SSPVP_Config.overlay.inbg ) then
				SSOverlay_RemoveRow( { cat = "queue" } );
			end

			if( SSPVP_Config.general.instanceid ) then
				SSOverlay_AddCategory( "bginfo", { text = SS_BGINFO, id = 1 } );
				SSOverlay_UpdateRow( {	type = "text",
							text = map,
							newText = map,
							format = "*text* #*extra1*",
							extra = { id },
							cat = "bginfo" } );

			end
		end
	end	
end

function SSPVPO_AddQueue( id, map )
	if( not SSPVP_Config.overlay.queue or ( SSLibrary_PlayerInBG() and not SSPVP_Config.overlay.inbg ) ) then
		return;
	end
	
	SSOverlay_AddCategory( "queue", { text = SS_QUEUED } );

	local timeWaited = GetBattlefieldTimeWaited( id ) / 1000;
	
	if( timeWaited <= 0 ) then
		timeWaited = 1;
	end
	
	if( string.find( map, SS_ARENA ) ) then
		local _, _, _, _, _, teamLimit = GetBattlefieldStatus( id );
		map = map .. " " .. string.format( SS_VS, teamLimit, teamLimit );
	end
	
	
	if( SSPVP_Config.overlay.showeta ) then
		local estimatedWait = SS_UNAVAILABLE;
		if( ( GetBattlefieldEstimatedWaitTime( id ) / 1000 ) > 0 ) then
			estimatedWait = SSOverlay_FormatTime( ( GetBattlefieldEstimatedWaitTime( id ) / 1000 ), SSPVP_Config.overlay.etaformat );
		end
		
		SSOverlay_UpdateRow( {	type = "up",
					text = map,
					seconds = timeWaited,
					cat = "queue",
					extra = { estimatedWait } } );
	else
		SSOverlay_UpdateRow( {	type = "up",
					text = map,
					seconds = timeWaited,
					cat = "queue" } );
	end
end

function SSPVPO_QueueReady( id, map )
	if( not SSPVP_Config.overlay.queue or ( SSLibrary_PlayerInBG() and not SSPVP_Config.overlay.inbg ) ) then
		return;
	end
	
	SSOverlay_AddCategory( "queue", { text = SS_QUEUED } );
	
	local newMap;
	local maxQueueTime = 120;
	if( string.find( map, SS_ARENA ) ) then
		local _, _, _, _, _, teamLimit = GetBattlefieldStatus( id );

		maxQueueTime = 60;
		local arena = SS_ARENAS .. " " .. string.format( SS_VS, teamLimit, teamLimit );
		if( SSOverlay_GetRow( { text = arena } ) ) then
			newMap = map .. " " .. string.format( SS_VS, teamLimit, teamLimit );
			map = arena;	
		else
			map = map .. " " .. string.format( SS_VS, teamLimit, teamLimit );
		end
	end
	
	if( SSPVP_Config.join.enabled and SSPVP_Config.general.enabled ) then
		local timeout = maxQueueTime - ( GetBattlefieldPortExpiration( id ) / 1000 );
		if( timeout >= tonumber( SSPVP_Config.join.timeout ) ) then
			timeout = 0;
		else
			timeout = SSPVP_Config.join.timeout - timeout;
		end

		SSOverlay_UpdateRow( {	type = "down",
					cat = "queue",
					seconds = timeout,
					text = map,
					newText = newMap,
					format = "*text*: *extra1* *timer*",
					looseMatch = true,
					extra = { SS_JOINING } } );
	else
		SSOverlay_UpdateRow( {	type = "text",
					cat = "queue",
					text = map,
					newText = newMap,
					looseMatch = true,
					format = "*text*: *extra1*",
					extra = { SS_JOINDISABLED } } );
	end
end

function SSPVPO_LoadFactionBalance()
	if( not SSPVP_Config.overlay.balance or ( FactionBalance["Alliance"] == SSLibrary_GetBGLimit() and FactionBalance["Horde"] == SSLibrary_GetBGLimit() ) ) then
		SSOverlay_RemoveRow( { cat = "factotals" } );
		return;
	end

	SSOverlay_AddCategory( "factotals", { text = SS_FACTOTALS, id = 1 } );

	SSOverlay_UpdateRow( {	type = "text",
				cat = "factotals",
				text = SS_ALLIANCE,
				color = SSLibrary_GetFactionColor( "Alliance" ),
				extra = { FactionBalance["Alliance"] } } );

	SSOverlay_UpdateRow( {	type = "text",
				cat = "factotals",
				text = SS_HORDE,
				color = SSLibrary_GetFactionColor( "Horde" ),
				extra = { FactionBalance["Horde"] } } );
end
