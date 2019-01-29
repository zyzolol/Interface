local Orig_ConfirmOnShow;
local Orig_DeathOnShow;
local Orig_AcceptBattlefieldPort;
local Orig_RessurectOnShow;
local Orig_WSSF_LeaveButton_OnClick;

local SoundPlayed = {};
local QueuedJoin = {};
local BGPlayers = {};
local EnemyLevels = {};

function SSPVP_OnLoad()
	this:RegisterEvent( "VARIABLES_LOADED" );
	this:RegisterEvent( "GOSSIP_SHOW" );
	this:RegisterEvent( "ADDON_LOADED" );
	this:RegisterEvent( "BATTLEFIELDS_SHOW" );
	
	this:RegisterEvent( "UPDATE_BATTLEFIELD_STATUS" );
	
	this:RegisterEvent( "CHAT_MSG_COMBAT_HOSTILE_DEATH" );
	this:RegisterEvent( "CHAT_MSG_SYSTEM" );
	this:RegisterEvent( "CHAT_MSG_WHISPER" );
	
	this:RegisterEvent( "CHAT_MSG_ADDON" );
	
	this:RegisterEvent( "PLAYER_ENTERING_WORLD" );
	
	this:RegisterEvent( "UPDATE_MOUSEOVER_UNIT" );
	this:RegisterEvent( "PLAYER_TARGET_CHANGED" );
	
	SSLibrary_RegisterEvent( "SSPVP_OnEvent", "JOIN_BATTLEGROUND_QUEUE" );
	SSLibrary_RegisterEvent( "SSPVP_OnEvent", "LEFT_BATTLEGROUND_QUEUE" );
	SSLibrary_RegisterEvent( "SSPVP_OnEvent", "BATTLEFIELD_QUEUE_READY" );	
	SSLibrary_RegisterEvent( "SSPVP_OnEvent", "BATTLEFIELD_TOTALS_CHANGED" );
	SSLibrary_RegisterEvent( "SSPVP_OnEvent", "BATTLEFIELD_SCORES_UPDATED" );
	SSLibrary_RegisterEvent( "SSPVP_OnEvent", "BATTLEFIELD_INFO_UPDATED" );	
	SSLibrary_RegisterEvent( "SSPVP_OnEvent", "BATTLEFIELD_WON" );	
	
	SLASH_SSPVP1 = "/sspvp";
	SlashCmdList["SSPVP"] = SSPVP_SlashHandler;
end 

function SSPVP_SlashHandler( msg )
	if( msg == "on" ) then
		SSLibrary_Message( string.format( SS_CMD_MODSTATUS, GREEN_FONT_COLOR_CODE .. SS_CMD_ON .. FONT_COLOR_CODE_CLOSE ) );					
		SSPVP_SetVariable( { "general", "enabled" }, true );
	elseif( msg == "off" ) then
		SSLibrary_Message( string.format( SS_CMD_MODSTATUS, RED_FONT_COLOR_CODE .. SS_CMD_OFF .. FONT_COLOR_CODE_CLOSE ) );					
		SSPVP_SetVariable( { "general", "enabled" }, false );
	else
		UIParentLoadAddOn( "SSUI" );
		SSUI_Show( "sspvp" );
	end
end

-- Confirm queue leave
function SSPVP_ConfirmBattlefieldLeave( id, accept, confirmed )
	if( not accept and not confirmed ) then
		local status, map, _, _, _, teamSize = GetBattlefieldStatus( id );
		
		if( status == "queued" or status == "confirm" ) then
			StaticPopupDialogs["CONFIRM_BATTLEFIELD_LEAVE"].text = TEXT( SS_CONFIRM_QUEUED );
		elseif( status == "active" ) then
			StaticPopupDialogs["CONFIRM_BATTLEFIELD_LEAVE"].text = TEXT( SS_CONFIRM_ACTIVE );
		else
			StaticPopupDialogs["CONFIRM_BATTLEFIELD_LEAVE"].text = TEXT( SS_CONFIRM_DEFAULT );		
		end
		
		if( teamSize > 0 ) then
			map = map .. " ".. string.format( SS_VS, teamSize, teamSize );
		end
		
		local frame = StaticPopup_Show( "CONFIRM_BATTLEFIELD_LEAVE", map, "", id );
		
		if( frame ) then
			frame.data = id;
		end
	else
		StaticPopup_Hide( "CONFIRM_BATTLEFIELD_LEAVE", id );
		Orig_AcceptBattlefieldPort( id, accept );
	end
end


-- Auto join
function SSPVP_JoinBattlefield( id )
	if( not SSLibrary_IsQueuedToJoin() or QueuedJoin[ map ] ) then
		return;
	end
	
	if( not SSPVP_Config.general.enabled ) then
		SSLibrary_Message( string.format( SS_MOD_DISABLED, SS_JOINDISABLED ), ChatTypeInfo["SYSTEM"] );
		
	elseif( not SSPVP_Config.join.bg and SSLibrary_PlayerInBG() ) then
		SSLibrary_Message( string.format( SS_INSIDEBG, SS_JOINDISABLED ), ChatTypeInfo["SYSTEM"] );
	
	elseif( not SSPVP_Config.join.enabled ) then
		SSLibrary_Message( string.format( SS_JOIN_DISABLED, SS_JOINDISABLED ), ChatTypeInfo["SYSTEM"] );
		
	elseif( not SSPVP_Config.join.window and not StaticPopup_Visible( "CONFIRM_BATTLEFIELD_ENTRY" ) ) then
		SSLibrary_Message( string.format( SS_WINDOW_HIDDEN, SS_JOINDISABLED ), ChatTypeInfo["SYSTEM"] );
	
	elseif( not SSPVP_Config.join.instance and IsInInstance() and not SSLibrary_PlayerInBG() ) then
		SSLibrary_Message( string.format( SS_INSIDEINSTANCE, SS_JOINDISABLED ), ChatTypeInfo["SYSTEM"] );
	
	elseif( not SSPVP_Config.join.grouped and ( GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 ) ) then
		SSLibrary_Message( string.format( SS_INSIDEGROUP, SS_JOINDISABLED ), ChatTypeInfo["SYSTEM"] );
	
	elseif( not SSPVP_Config.join.afk and UnitIsAFK( "player" ) ) then
		SSLibrary_Message( string.format( SS_ISAFK, SS_JOINDISABLED ), ChatTypeInfo["SYSTEM"] );
	
	else
		AcceptBattlefieldPort( id, true );
	end

end

-- Only leave the battlefield if we don't have any other queues active
function SSPVP_AutoLeaveBattlefield()
	if( not GetBattlefieldWinner() ) then
		return;
	end
	
	-- Pain in the ass hack, basically we check
	-- to make sure that we only have one ready battlefield
	-- before exiting
	local totalInactive = 0;
	for i = 1, MAX_BATTLEFIELD_QUEUES do
		local status = GetBattlefieldStatus( i );
		
		if( status == "confirm" ) then
			SSLibrary_Message( SS_AVAILABLEBG, ChatTypeInfo["SYSTEM"] );
			return;
			
		elseif( status == "none" or status == "queued" ) then
			totalInactive = totalInactive + 1;	
		end
	end
	
	if( totalInactive == MAX_BATTLEFIELD_QUEUES - 1 ) then
		LeaveBattlefield( true );
	end
end

-- Auto ressurect
function SSPVP_AutoRessurect()
	if( SSPVP_Config.general.enabled and SSPVP_Config.bg.autores and SSLibrary_PlayerInBG() ) then
		if( GetCorpseRecoveryDelay() == 0 ) then
			RetrieveCorpse();
		else
			SSLibrary_ScheduleEvent( "RetrieveCorpse", ( GetCorpseRecoveryDelay() / 1000 ) );
		end
	end

	if( Orig_RessurectOnShow ) then
		Orig_RessurectOnShow();
	end
end

-- Auto release
function SSPVP_AutoRelease()
	if( SSPVP_Config.general.enabled and SSPVP_Config.bg.release and SSLibrary_PlayerInBG() ) then
		if( not HasSoulstone() or SSPVP_Config.bg.ignoress ) then
			StaticPopupDialogs["DEATH"].text = SS_AUTORELEASING;
			RepopMe();
		
		elseif( HasSoulstone() and SSPVP_Config.bg.autoss ) then
			UseSoulstone();
		else
			StaticPopupDialogs["DEATH"].text = HasSoulstone();
		end
	else
		StaticPopupDialogs["DEATH"].text = TEXT( DEATH_RELEASE_TIMER );
	end

	Orig_DeathOnShow();
end

-- Color player name by class
function SSPVP_WorldStateScoreFrame_Update()
	-- Remove the server name from the player name
	for i=1, MAX_WORLDSTATE_SCORE_BUTTONS do
		local nameButton = getglobal( "WorldStateScoreButton" .. i .. "NameButtonName" );
			
		if( nameButton and nameButton:GetText() ) then
			index = FauxScrollFrame_GetOffset( WorldStateScoreScrollFrame ) + i;
			local name, _, _, _, _, _, _, _, class = GetBattlefieldScore( index );
			
			if( SSPVP_Config.bg.classColor ) then
				local className = SSLibrary_GetUnLocalizedClass( class );

				if( name == UnitName( "player" ) ) then
					nameButton:SetVertexColor( 1.0, 0.82, 0 );
				elseif( className ) then
					nameButton:SetVertexColor( RAID_CLASS_COLORS[ className ].r, RAID_CLASS_COLORS[ className ].g, RAID_CLASS_COLORS[ className ].b );
				elseif( playerClass == 0 ) then
					nameButton:SetVertexColor( 1.0, 0.1, 0.1 );
				else
					nameButton:SetVertexColor( 0, 0.68, 0.94 );
				end
			end
			
			if( SSPVP_Config.bg.recordLevel and EnemyLevels[ name ] and EnemyLevels[ name ] > 0 ) then
				nameButton:SetText( "[" .. EnemyLevels[ name ] .. "] " .. nameButton:GetText() );
			end
						
			if( SSPVP_Config.bg.hideCIcon ) then
				getglobal( "WorldStateScoreButton" .. i .. "ClassButtonIcon" ):Hide();
			end
		end
	end
end

function SSPVP_PrintBalanceToChat( faction )
	local servers, classes, total = SSPVP_UpdateScoreInfo( faction, true );
	
	if( faction == "Horde" ) then
		faction = SS_HORDE;
	elseif( faction == "Alliance" ) then
		faction = SS_ALLIANCE;
	end
	
	-- Get the server min to show the name on the list
	local min = 2;
	if( SSLibrary_IsInAV() ) then
		min = 4;
	end

	local classFormat = {};
	for id, class in pairs( classes ) do
		table.insert( classFormat, class.name .. ": " .. class.total );
	end

	local serverFormat = {};
	for id, server in pairs( servers ) do
		if( server.total >= min ) then
			table.insert( serverFormat, server.name .. ": " .. server.total );
		end
	end

	SendChatMessage( string.format( SS_BALANCE_TOTAL, faction, total ), "BATTLEGROUND" );

	if( #( serverFormat ) > 0 ) then
		SendChatMessage( string.format( SS_SERVER_TOTAL, table.concat( serverFormat, ", " ) ), "BATTLEGROUND" );
	end

	if( #( classFormat ) > 0 ) then
		SendChatMessage( string.format( SS_CLASS_TOTAL, table.concat( classFormat, ", " ) ), "BATTLEGROUND" );
	end
end

-- Tooltip creation for the faction balance and info stuff which I can't think of a better name at the moment
function SSPVP_UpdateScoreInfo( faction, returnCount )
	local FactionColor, factionID;
	if( faction == "Alliance" ) then
		faction = SS_ALLIANCE;
		factionID = 1;
		FactionColor = "|cff0070dd";
	elseif( faction == "Horde" ) then
		faction = SS_HORDE;
		factionID = 0;
		FactionColor = RED_FONT_COLOR_CODE;
	end
	
	local serverCount = {};
	local classCount = {};
	local rankCount = {};
	local totalPlayers = 0;
	
	-- Add it all up (hack!)
	for id, player in pairs( BGPlayers ) do
		if( player.faction == factionID ) then
			-- Add server count
			local foundRecord;
			for id, server in pairs( serverCount ) do
				if( server.name == player.server ) then
					serverCount[ id ].total = serverCount[ id ].total + 1;
					foundRecord = true;
				end
			end
			
			if( not foundRecord ) then
				table.insert( serverCount, { name = player.server, total = 1 } );
			end
			
			-- Add class count
			foundRecord = nil;
			for id, class in pairs( classCount ) do
				if( class.name == player.class ) then
					classCount[ id ].total = classCount[ id ].total + 1;
					foundRecord = true;
				end
			end
			
			if( not foundRecord ) then
				table.insert( classCount, { name = player.class, total = 1 } );
			end

			totalPlayers = totalPlayers + 1;
		end
	end
		
	-- now sort
	table.sort( serverCount, function( a, b )
		return a.total > b.total;
	end );
	
	table.sort( classCount, function( a, b )
		return a.total > b.total;
	end );

	if( returnCount ) then
		return serverCount, classCount, totalPlayers;
	end
	
	-- now add
	local servers = {};
	for _, server in pairs( serverCount ) do
		table.insert( servers, string.format( SS_ROW_FORMAT, server.name, server.total ) );
	end
	
	local classes = {};
	for _, class in pairs( classCount ) do
		table.insert( classes, string.format( SS_ROW_FORMAT, class.name, class.total ) );
	end
			
	-- finish up and return
	return string.format( SS_SCORE_TOOLTIP, FactionColor .. faction .. FONT_COLOR_CODE_CLOSE, totalPlayers, FactionColor .. SS_SERVER .. FONT_COLOR_CODE_CLOSE, table.concat( servers, "\n" ), FactionColor .. SS_CLASS .. FONT_COLOR_CODE_CLOSE, table.concat( classes, "\n" ) );
end

-- Confirmation for leaving a battlefield through the minimap
function SSPVP_WSSF_LeaveButton_OnClick()
	local crtValue = SSPVP_Config.leave.confirm;
	SSPVP_Config.leave.confirm = false;
	
	Orig_WSSF_LeaveButton_OnClick();
	
	SSPVP_Config.leave.confirm = crtValue;
end

function SSPVP_LeaveBattlefield( confirm )
	if( SSPVP_Config.leave.confirm and not confirm ) then
		StaticPopup_Show( "CONFIRM_MINIMAP_BFLEAVE" );
		return;
	end
	
	Orig_LeaveBattlefield();
end

-- Handle moving the always up frame
function SSPVP_UpdateAlwaysUpDragger()
	if( SSPVP_Config.general.lockAlways ) then
		SSAlwaysUpDrag:Hide();
		return;
	end
	
	local currentWidth = 0;
	local currentHeight = 0;
	local frameLevel = 10;
	
	if( not AlwaysUpFrame1 ) then
		NUM_ALWAYS_UP_UI_FRAMES = NUM_ALWAYS_UP_UI_FRAMES + 1;	
		CreateFrame( "Frame", "AlwaysUpFrame" .. NUM_ALWAYS_UP_UI_FRAMES, WorldStateAlwaysUpFrame, "WorldStateAlwaysUpTemplate" );
	end
	
	if( AlwaysUpFrame1 and AlwaysUpFrame1:IsVisible() ) then
		for i=1, NUM_ALWAYS_UP_UI_FRAMES do
			local frame = getglobal( "AlwaysUpFrame" .. i );
			if( frame:IsVisible() ) then
				local icon = getglobal( frame:GetName() .. "Icon" );
				local text = getglobal( frame:GetName() .. "Text" );

				if( ( icon:GetWidth() + text:GetWidth() ) > currentWidth ) then
					currentWidth = icon:GetWidth() + text:GetWidth();
				end

				if( frame:GetFrameLevel() + 2 > frameLevel ) then
					frameLevel = frame:GetFrameLevel() + 2;
				end

				currentHeight = icon:GetHeight() + text:GetHeight();
			end
		end
	end

	SSAlwaysUpDrag:ClearAllPoints();
	SSAlwaysUpDrag:SetPoint( "TOPLEFT", "AlwaysUpFrame1", "TOPLEFT", -10, 15 )

	SSAlwaysUpDrag:SetWidth( currentWidth + 15 );
	SSAlwaysUpDrag:SetHeight( currentHeight + 10 );
	
	-- Just make sure it's above everything
	SSAlwaysUpDrag:SetFrameLevel( frameLevel );
	SSAlwaysUpDrag:Show();
	
	WorldStateAlwaysUpFrame:SetMovable( true );
end

function SSPVP_StartAlwaysUpDragger()
	WorldStateAlwaysUpFrame:StartMoving();
end

function SSPVP_StopAlwaysUpDragger()
	WorldStateAlwaysUpFrame:StopMovingOrSizing();

	if( arg1 == "RightButton" ) then
		WorldStateAlwaysUpFrame:ClearAllPoints();
		WorldStateAlwaysUpFrame:SetPoint( "TOP", "UIParent", "TOP", -5, -15 );

		SSPVP_Config.alwaysPosition = nil;
	else
		local _, _, _, x, y = WorldStateAlwaysUpFrame:GetPoint();
		SSPVP_Config.alwaysPosition = { x = x, y = y };
	end
end


-- Event handler
function SSPVP_OnEvent( event, ... )
	if( event == "VARIABLES_LOADED" ) then
		if( SSPVP_Config == nil ) then
			SSPVP_Config = SSPVP_GetDefaultConfig( nil, nil, true );
		end
		
		-- Remove old configuration
		if( SSPVP_Config.version ~= SSPVPVersion ) then
			local upgraded;
			
			if( SSPVPVersion == "2.1.5" and SSOverlay_Config ) then
				SSOverlay_Config = {};
				SSLoader_AddOns["SSOverlay"] = nil;
				
				upgraded = true;
			elseif( SSPVPVersion == "2.1.6" ) then
				SSPVP_Config.overlay = {};
				upgraded = true;
			end

			-- Check configuration for any changes
			for key, value in pairs( SSPVP_GetDefaultConfig( nil, nil, true ) ) do
				if( SSPVP_Config[ key ] == nil or ( SSPVP_Config[ key ] and type( SSPVP_Config[ key ] ) ~= type( value ) ) ) then
					SSPVP_Config[ key ] = value;
					
					upgraded = true;
				elseif( type( value ) == "table" ) then
					for subKey, subValue in pairs( value ) do
						if( SSPVP_Config[ key ][ subKey ] == nil or ( SSPVP_Config[ key ][ subKey ] and type( SSPVP_Config[ key ][ subKey ] ) ~= type( subValue ) ) ) then
							SSPVP_Config[ key ][ subKey ] = subValue;
							
							upgraded = true;
						end
					end
				end
			end

			if( upgraded ) then
				SSLibrary_Message( string.format( SS_UPGRADED_CONFIG, GREEN_FONT_COLOR_CODE .. SSPVPVersion .. FONT_COLOR_CODE_CLOSE ) );
			end
		end
		
		-- Set the variable version
		SSPVP_Config.version = SSPVPVersion;
		
		-- Hook for auto release
		Orig_DeathOnShow = StaticPopupDialogs["DEATH"].OnShow;
		StaticPopupDialogs["DEATH"].OnShow = SSPVP_AutoRelease;
		
		-- Updates the frame size for moving the always up frame
		hooksecurefunc( "WorldStateAlwaysUpFrame_Update", SSPVP_UpdateAlwaysUpDragger );
		if( SSPVP_Config.alwaysPosition ) then
			WorldStateAlwaysUpFrame:SetPoint( "TOPLEFT", "UIParent", "TOPLEFT", SSPVP_Config.alwaysPosition.x, SSPVP_Config.alwaysPosition.y );
		end
		
		-- Hook for auto ressurect
		Orig_RessurectOnShow = StaticPopupDialogs["RECOVER_CORPSE"].OnShow;
		StaticPopupDialogs["RECOVER_CORPSE"].OnShow = SSPVP_AutoRessurect;
		
		-- Hook for confirmation on leave
		Orig_AcceptBattlefieldPort = AcceptBattlefieldPort;
		AcceptBattlefieldPort = SSPVP_ConfirmBattlefieldLeave;
		
		-- Hooks the leave battlefield button
		Orig_WSSF_LeaveButton_OnClick = WorldStateScoreFrameLeaveButton:GetScript( "OnClick" );
		WorldStateScoreFrameLeaveButton:SetScript( "OnClick", SSPVP_WSSF_LeaveButton_OnClick );
				
		-- Hook leave battlefield
		Orig_LeaveBattlefield = LeaveBattlefield;
		LeaveBattlefield = SSPVP_LeaveBattlefield;
		
		-- Hook battlefield icon tooltip thing
		hooksecurefunc( "WorldStateScoreFrame_Update", SSPVP_WorldStateScoreFrame_Update );
		
		-- Got to load the static popup too
		StaticPopupDialogs["CONFIRM_BATTLEFIELD_LEAVE"] = {
			text = TEXT( SS_CONFIRM_LEAVE ),
			button1 = TEXT( YES ),
			button2 = TEXT( NO ),

			OnAccept = function( id )
				AcceptBattlefieldPort( id, nil, true );
			end,
			
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
			multiple = 1,
		};

		StaticPopupDialogs["CONFIRM_MINIMAP_BFLEAVE"] = {
			text = TEXT( SS_CONFIRM_BFLEAVE ),
			button1 = TEXT( YES ),
			button2 = TEXT( NO ),

			OnAccept = function()
				LeaveBattlefield( true );
			end,
			
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
			multiple = 1,
		};

	-- Group swapping
	elseif( event == "CHAT_MSG_WHISPER" and IsPartyLeader() and SSLibrary_PlayerInBG() and SSPVP_Config.general.enabled and SSPVP_Config.bg.groupAdmin ) then
		local msg = string.lower( arg1 or "" );

		if( msg == SS_AA_LEADER ) then
			PromoteToLeader( arg2 );
			SSLibrary_WhisperMessage( SS_AA_NOW_LEADER, arg2 );
		elseif( string.find( msg, SS_AA_SWAP ) ) then
			if( InCombatLockdown() ) then
				SSLibrary_WhisperMessage( SS_AA_INCOMBAT, arg2 );
				return;
			end
			
			
			local _, _, fromPlayer, toPlayer = string.find( msg, SS_AA_SWAP );
			fromPlayer, toPlayer = string.lower( fromPlayer ), string.lower( toPlayer );

			local fromID, toID;
			for i=1, GetNumRaidMembers() do
				local name, _, group = GetRaidRosterInfo( i );
				name = string.lower( name );
				
				if( name == fromPlayer ) then
					fromID = i;
				elseif( name == toPlayer ) then
					toID = i;
				end
			end
			
			if( not fromID ) then
				SSLibrary_WhisperMessage( string.format( SS_AA_CANTFIND, fromPlayer ), arg2 );
				return;
			end

			if( not toID ) then
				SSLibrary_WhisperMessage( string.format( SS_AA_CANTFIND, toPlayer ), arg2 );
				return;
			end

			SwapRaidSubgroup( fromID, toID );
		else
			for id, text in pairs( SS_AA_INFO_TRIG ) do
				if( string.find( msg, text ) ) then
					SSLibrary_WhisperMessage( SS_AA_INFO, arg2 );
				end
			end
		end
	
	
	elseif( event == "BATTLEFIELD_SCORES_UPDATED" ) then
		if( WorldStateScoreFrameLabel:GetText() == SS_ALLIANCE_STATS ) then
			SSPVPAllianceInfoButton:Show();
			SSPVPHordeInfoButton:Hide();
		elseif( WorldStateScoreFrameLabel:GetText() == SS_HORDE_STATS ) then
			SSPVPHordeInfoButton:Show();
			SSPVPAllianceInfoButton:Hide();
		else
			SSPVPAllianceInfoButton:Show();
			SSPVPHordeInfoButton:Show();	
		end

		BGPlayers = select( 1, ... );
		
	-- Hostile player died and we're in an active battleground
	elseif( event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" and SSLibrary_PlayerInBG() and SSPVP_Config.general.killingblow ) then
		local search = string.gsub( SELFKILLOTHER, "%%s", "(.+)" );
		
		if( string.find( arg1, search ) ) then
			local _, _, playerName = string.find( arg1, search );
			
			-- SCT Loaded, display it
			if( IsAddOnLoaded( "sct" ) ) then
				SCT:DisplayText( SS_KILLING_BLOW, SSPVP_Config.general.killingblowColor, nil, "event", 1 );
			else
				CombatText_AddMessage( SS_KILLING_BLOW, COMBAT_TEXT_SCROLL_FUNCTION, SSPVP_Config.general.killingblowColor.r, SSPVP_Config.general.killingblowColor.g, SSPVP_Config.general.killingblowColor.b, "", nil );
			end
		end
		
	elseif( event == "BATTLEFIELD_INFO_UPDATED" and SSPVP_Config.general.enabled ) then
		SoundPlayed[ select( 2, ... ) ] = nil;
		QueuedJoin[ select( 2, ... ) ] = nil;

		SSPVP_StopSound( SSPVP_Config.general.sound );
	
	elseif( event == "PLAYER_TARGET_CHANGED" and SSPVP_Config.bg.recordLevel and SSLibrary_PlayerInBG() ) then
		if( UnitIsEnemy( "target", "player" ) and UnitIsPVP( "target" ) ) then
			local name, server = UnitName( "target" );
			
			if( server ) then
				EnemyLevels[ name .. "-" .. server ] = UnitLevel( "target" );
			else
				EnemyLevels[ name ] = UnitLevel( "target" );
			end
		end		
		
	elseif( event == "UPDATE_MOUSEOVER_UNIT" and SSPVP_Config.bg.recordLevel and SSLibrary_PlayerInBG() ) then
		if( UnitIsEnemy( "mouseover", "player" ) and UnitIsPVP( "mouseover" ) ) then
			local name, server = UnitName( "mouseover" );
			
			if( server ) then
				EnemyLevels[ name .. "-" .. server ] = UnitLevel( "mouseover" );
			else
				EnemyLevels[ name ] = UnitLevel( "mouseover" );			
			end
		end		
	
	elseif( event == "PLAYER_ENTERING_WORLD" and SSPVP_Config.general.enabled ) then
		
		if( SSPVP_Config.bg.minimap and ( SSLibrary_PlayerInBG() and not SSLibrary_PlayerInArena() ) ) then
			BattlefieldMinimap_LoadUI();
			
			if( IsAddOnLoaded( "Blizzard_BattlefieldMinimap" ) ) then
				SHOW_BATTLEFIELD_MINIMAP = "1";
				
				BattlefieldMinimap:Show();
				BattlefieldMinimap_Update();
			end
		
		elseif( SSLibrary_PlayerInArena() and BattlefieldMinimap ) then
			SHOW_BATTLEFIELD_MINIMAP = "0";
			BattlefieldMinimap:Hide();
		end
		
	elseif( event == "BATTLEFIELDS_SHOW" and SSPVP_Config.general.enabled ) then

		-- Make sure we aren't auto queueing after already being queued
		local name = GetBattlefieldInfo();
		for i=1, MAX_BATTLEFIELD_QUEUES do
			local status, map = GetBattlefieldStatus( i );
			if( map == name and status ~= "none" ) then
				return;
			end
		end
		
		-- Group queue if inside a group
		if( SSPVP_Config.auto.group and ( GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 ) and IsPartyLeader() and CanJoinBattlefieldAsGroup() ) then
			JoinBattlefield( GetSelectedBattlefield(), 1 );
			HideUIPanel( BattlefieldFrame );
			
		-- Solo queue if outside of a group
		elseif( SSPVP_Config.auto.solo and ( GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 ) ) then
			JoinBattlefield( GetSelectedBattlefield() );
			HideUIPanel( BattlefieldFrame );
		end
		
	elseif( event == "JOIN_BATTLEGROUND_QUEUE" and SSPVP_Config.general.enabled ) then
		SoundPlayed[ select( 2, ... ) ] = nil;
		
	elseif( event == "GOSSIP_SHOW" and SSPVP_Config.general.enabled ) then
		
		if( SSPVP_Config.bg.skip and GossipFrame.buttonIndex > 0 ) then
			for i = 1, GossipFrame.buttonIndex do
				local gossipText = getglobal( "GossipTitleButton" .. i ):GetText();

				if( gossipText == SS_BG_GOSSIP or gossipText == SS_BG_HOLIDAY_GOSSIP or gossipText == SS_ARENA_GOSSIP ) then
					getglobal( "GossipTitleButton" .. i ):Click();
					break;
				end
			end
		end
	
	-- Time to enter a battleground
	elseif( event == "BATTLEFIELD_QUEUE_READY" and SSPVP_Config.join.enabled and SSPVP_Config.general.enabled ) then
		if( not SoundPlayed[ select( 2, ... ) ] ) then
			SSPVP_PlaySound( SSPVP_Config.general.sound );
		end
		
		SoundPlayed[ select( 2, ... ) ] = true;
		QueuedJoin[ select( 2, ... ) ] = true;

		local timeout = SSPVP_Config.join.timeout;
		if( UnitIsAFK( "player" ) ) then
			timeout = SSPVP_Config.join.afktimeout;	

			if( ( GetBattlefieldPortExpiration( select( 1, ... ) ) / 1000 ) < timeout ) then
				timeout = ( GetBattlefieldPortExpiration( select( 1, ... ) ) / 1000 ) - 5;
			end
		end
		
		SSLibrary_UnScheduleEvent( "SSPVP_JoinBattlefield" );
		SSLibrary_ScheduleEvent( "SSPVP_JoinBattlefield", timeout, select( 1, ... ) );

	-- Battlefield won, leave
	elseif( event == "BATTLEFIELD_WON" and SSPVP_Config.leave.enabled and SSPVP_Config.general.enabled ) then
		SSLibrary_ScheduleEvent( "SSPVP_AutoLeaveBattlefield", SSPVP_Config.leave.timeout );
	end
end

-- Variable management
function SSPVP_GetDefaultConfig( category, name, fullConfig )
	Config = {};

	Config.general = {};
	Config.general.enabled = true;
	Config.general.killingblow = true;
	Config.general.killingblowColor = { 0.5, 0.5, 1 };
	Config.general.sound = "";
	Config.general.lockAlways = true;

	Config.bg = {};
	Config.bg.classColor = true;
	Config.bg.hideCIcon = true;
	Config.bg.release = true;
	Config.bg.ignoress = false;
	Config.bg.skip = true;
	Config.bg.autoss = false;
	Config.bg.minimap = true;
	Config.bg.groupAdmin = true;

	Config.join = {};
	Config.join.enabled = true;
	Config.join.bg = false;
	Config.join.afk = false;
	Config.join.grouped = true;
	Config.join.window = false;
	Config.join.afktimeout = 110;
	Config.join.timeout = 20;

	Config.leave = {};
	Config.leave.confirm = true;
	Config.leave.enabled = true;
	Config.leave.timeout = 0.1;

	Config.auto = {};
	Config.auto.group = true;
	Config.auto.solo = true;
	
	Config.overlay = {};
	Config.overlay.queue = true;
	Config.overlay.eta = true;
	Config.overlay.etaformat = "mmss";
	Config.overlay.inbg = false;
	
	-- Return the entire configuration
	if( fullConfig ) then
		return Config;
	
	-- Return only a specific category
	elseif( category and not name ) then
		return Config[ category ];
	
	-- Return only a specific variable in a category
	elseif( category and name ) then
		return Config[ category ][ name ];
	end
	
	return nil;
end

function SSPVP_SetVariable( vars, value )
	if( SSPVP_Config[ vars[1] ] == nil ) then
		SSPVP_Config[ vars[1] ] = SSPVP_GetDefaultConfig( vars[1] );
	end
	
	SSPVP_Config[ vars[1] ][ vars[2] ] = value;

	-- This'll update the overlay joining status if we disable it and such
	if( ( vars[1] == "join" or vars[1] == "general" ) and IsAddOnLoaded( "SSOverlay" ) ) then
		SSPVPO_UpdateQueue();
	end
end

function SSPVP_GetVariable( vars )
	if( SSPVP_Config[ vars[1] ] == nil ) then
		SSPVP_Config[ vars[1] ] = SSPVP_GetDefaultConfig( vars[1] );
	elseif( SSPVP_Config[ vars[1] ][ vars[2] ] == nil ) then
		SSPVP_Config[ vars[1] ][ vars[2] ] = SSPVP_GetDefaultConfig( vars[1], vars[2] );
	end
	
	return SSPVP_Config[ vars[1] ][ vars[2] ];
end

-- Sound playing/stopping
function SSPVP_UI_StopSound()
	SSPVP_StopSound( SSSoundFile:GetText() );
	
	SSLibrary_Message( string.format( SS_SOUNDSTOPPED, SSSoundFile:GetText() ), ChatTypeInfo["SYSTEM"] );
end

function SSPVP_UI_PlaySound()
	if( SSPVP_PlaySound( SSSoundFile:GetText() ) ) then
		SSLibrary_Message( string.format( SS_PLAYINGSOUND, SSSoundFile:GetText() ), ChatTypeInfo["SYSTEM"] );
	else
		SSLibrary_Message( SS_SOUNDERROR, ChatTypeInfo["SYSTEM"] );
	end
end

function SSPVP_StopSound( soundFile )
	if( not soundFile or soundFile == "" ) then
		return;
	end
	
	if( string.find( soundFile, "mp3$" ) ) then
		StopMusic();
	else
		local oldMasterSound = GetCVar( "MasterSoundEffects" );
		SetCVar( "MasterSoundEffects", 0 );
		SetCVar( "MasterSoundEffects", oldMasterSound );
	end
end

function SSPVP_PlaySound( soundFile )
	if( not soundFile ) then
		return;
	end
	
	SSPVP_StopSound( soundFile );
	
	local enableVar, volumeVar;
	if( string.find( soundFile, "mp3$" ) ) then
		PlayMusic( "Interface\\AddOns\\SSPVP\\" .. soundFile );
		
		enableVar = "EnableMusic";
		volumeVar = "MusicVolume";
	else
		PlaySoundFile( "Interface\\AddOns\\SSPVP\\" .. soundFile );
		
		enableVar = "MasterSoundEffects";
		volumeVar = "SoundVolume";
	end
	
	-- Check if a sound setting is off/disabled
	if( tonumber( GetCVar( enableVar ) ) == 0 or tonumber( GetCVar( volumeVar ) ) == 0 or tonumber( GetCVar( "MasterVolume" ) ) == 0 ) then
		return false;	
	end
	
	return true;
end

function SSPVP_TogglePlay()
	if( this.soundPlaying ) then
		SSPVP_UI_StopSound();
		this.soundPlaying = nil;

		this:SetText( SS_UI_GENERAL_PLAY );
	else
		SSPVP_UI_PlaySound();
		this.soundPlaying = true;
		
		this:SetText( SS_UI_GENERAL_STOP );
	end
end


-- SSPVP UI
function SSPVP_LoadUI()
	SSUI_RegisterVarType( "sspvp", "SSPVP_SetVariable", "SSPVP_GetVariable" );
	
	SSUI_AddTitle( "sspvp", SS_PVP .. " " .. SSPVPVersion );
	
	SSUI_AddFrame( "SSGeneralConfig", "sspvp", true );
	SSUI_AddFrame( "SSAutoJoinConfig", "sspvp" );
	SSUI_AddFrame( "SSAutoLeaveConfig", "sspvp" );
	SSUI_AddFrame( "SSBGConfig", "sspvp" );
	SSUI_AddFrame( "SSQueueConfig", "sspvp" );
	SSUI_AddFrame( "SSBGOverlayConfig", "sspvp" );

	SSUI_AddTab( SS_UI_TAB_GENERAL, "SSGeneralConfig", 1 );
	SSUI_AddTab( SS_UI_TAB_BG, "SSBGConfig", 2 );
	SSUI_AddTab( SS_UI_TAB_JOIN, "SSAutoJoinConfig", 3 );
	SSUI_AddTab( SS_UI_TAB_LEAVE, "SSAutoLeaveConfig", 4 );
	SSUI_AddTab( SS_UI_TAB_BGOVERLAY, "SSBGOverlayConfig", 4 );
	SSUI_AddTab( SS_UI_TAB_QUEUE, "SSQueueConfig", 5 );
	
	local UIList = {
		-- General config
		{ name = "SSEnableMod", text = SS_UI_GENERAL_ENABLE, type = "check", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "sspvp", var = { "general", "enabled" }, parent = "SSGeneralConfig" },
		{ name = "SSAutoSolo", text = SS_UI_AUTO_SOLO, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "auto", "solo" }, parent = "SSGeneralConfig" },
		{ name = "SSAutoGroup", text = SS_UI_AUTO_GROUP, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "auto", "group" }, parent = "SSGeneralConfig" },
		{ name = "SSLockAlways", text = SS_UI_GENERAL_LOCKALWAYS, tooltip = SS_UI_GENERAL_LOCKALWAYS_TT, onClick = "SSPVP_UpdateAlwaysUpDragger", type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "general", "lockAlways" }, parent = "SSGeneralConfig" },
		{ name = "SSKillingBlow", text = SS_UI_GENERAL_KILLINGBLOW, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "general", "killingblow" }, parent = "SSGeneralConfig" },
		{ name = "SSKillingBlowColor", text = SS_UI_GENERAL_KILLINGBLOWCOLOR, type = "color", points = { "LEFT", "LEFT", 5, -30 }, varType = "sspvp", var = { "general", "killingblowColor" }, parent = "SSGeneralConfig" },
		{ name = "SSSoundFile", text = SS_UI_GENERAL_SOUND, type = "input", points = { "LEFT", "LEFT", 0, -30 }, width = 100, varType = "sspvp", var = { "general", "sound" }, parent = "SSGeneralConfig" },
		{ name = "SSSoundPlay", text = SS_UI_GENERAL_PLAY, type = "button", onClick = "SSPVP_TogglePlay", points = { "LEFT", "LEFT", -5, -30 }, parent = "SSGeneralConfig" },
		
		-- Battleground overlay config
		{ name = "SSInstanceID", text = SS_UI_GENERAL_INSTANCEID, type = "check", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "sspvp", var = { "general", "instanceid" }, parent = "SSBGOverlayConfig" },
		{ name = "SSStartTime", text = SS_UI_GENERAL_STARTTIME, tooltip = SS_UI_GENERAL_STARTTIME_TT, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "overlay", "startin" }, parent = "SSBGOverlayConfig" },
		{ name = "SSFactionBalance", text = SS_UI_GENERAL_FACTIONBALANCE, tooltip = SS_UI_GENERAL_FACTIONBALANCE_TT, onClick="SSPVPO_LoadFactionBalance", type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "overlay", "balance" }, parent = "SSBGOverlayConfig" },

		-- Auto join config
		{ name = "SSAutoJoin", text = SS_UI_JOIN_ENABLE, type = "check", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "sspvp", var = { "join", "enabled" }, parent = "SSAutoJoinConfig" },
		{ name = "SSAutoJoinTimeout", text = SS_UI_JOIN_TIMEOUT, type = "input", points = { "LEFT", "LEFT", 10, -30 }, maxChars = 3, width = 30, varType = "sspvp", forceType = "int", var = { "join", "timeout" }, parent = "SSAutoJoinConfig" },
		{ name = "SSAutoJoinAFKTimeout", text = SS_UI_JOIN_AFKTIMEOUT, type = "input", points = { "LEFT", "LEFT", 0, -30 }, maxChars = 3, width = 30, varType = "sspvp", forceType = "int", var = { "join", "afktimeout" }, parent = "SSAutoJoinConfig" },
		{ name = "SSJoinInBG", text = SS_UI_JOIN_BG, type = "check", points = { "LEFT", "LEFT", -10, -30 }, varType = "sspvp", var = { "join", "bg" }, parent = "SSAutoJoinConfig" },
		{ name = "SSJoinAFK", text = SS_UI_JOIN_AFK, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "join", "afk" }, parent = "SSAutoJoinConfig" },
		{ name = "SSWindowHidden", text = SS_UI_JOIN_WINDOW, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "join", "window" }, parent = "SSAutoJoinConfig" },
		{ name = "SSJoinGrouped", text = SS_UI_JOIN_GROUPED, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "join", "grouped" }, parent = "SSAutoJoinConfig" },

		-- Auto leave config
		{ name = "SSAutoLeave", text = SS_UI_LEAVE_ENABLE, type = "check", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "sspvp", var = { "leave", "enabled" }, parent = "SSAutoLeaveConfig" },
		{ name = "SSLeaveConfirm", text = SS_UI_LEAVE_CONFIRM, tooltip = SSUI_LEAVE_CONFIRM_TT, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "leave", "confirm" }, parent = "SSAutoLeaveConfig" },
		{ name = "SSAutoLeaveTimeout", text = SS_UI_LEAVE_TIMEOUT, type = "input", points = { "LEFT", "LEFT", 10, -30 }, maxChars = 3, width = 30, varType = "sspvp", forceType = "int", var = { "leave", "timeout" }, parent = "SSAutoLeaveConfig" },

		-- BG Config
		{ name = "SSAutoRelease", text = SS_UI_BG_RELEASE, type = "check", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "sspvp", var = { "bg", "release" }, parent = "SSBGConfig" },
		{ name = "SSAutoRessurect", text = SS_UI_BG_AUTORES, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "bg", "autores" }, parent = "SSBGConfig" },
		{ name = "SSGroupAdmin", text = SS_UI_BG_GROUPADMIN, tooltip = SS_UI_BG_GROUPADMIN_TT, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "bg", "groupAdmin" }, parent = "SSBGConfig" },
		{ name = "SSIgnoreSS", text = SS_UI_BG_IGNORESS, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "bg", "ignoress" }, parent = "SSBGConfig" },
		{ name = "SSAutoAcceptSS", text = SS_UI_BG_AUTOSS, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "bg", "autoss" }, parent = "SSBGConfig" },
		{ name = "SSSkipGossip", text = SS_UI_BG_SKIPGOSSIP, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "bg", "skip" }, parent = "SSBGConfig" },
		{ name = "SSClassColor", text = SS_UI_BG_CLASSSCORE, type = "check", onClick ="SSPVP_WorldStateScoreFrame_Update", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "bg", "classColor" }, parent = "SSBGConfig" },
		{ name = "SSHideClassIcon", text = SS_UI_BG_HIDECLASSICON, type = "check", onClick ="SSPVP_WorldStateScoreFrame_Update", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "bg", "hideCIcon" }, parent = "SSBGConfig" },
		{ name = "SSRecordLevel", text = SS_UI_BG_RECORDLEVEL, tooltip = SS_UI_BG_RECORDLEVEL, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "bg", "recordLevel" }, parent = "SSBGConfig" },
		{ name = "SSMinimap", text = SS_UI_BG_MINIMAP, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "bg", "minimap" }, parent = "SSBGConfig" },
		
		-- Queue overlay config
		{ name = "SSQueueOverlay", text = SS_UI_QUEUE_ENABLE, type = "check", onClick = "SSPVPO_LoadQueues", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "sspvp", var = { "overlay", "queue" }, parent = "SSQueueConfig" },
		{ name = "SSShowInBG", text = SS_UI_QUEUE_SHOWINBG, type = "check", onClick = "SSPVPO_LoadQueues", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "overlay", "inbg" }, parent = "SSQueueConfig" },
		{ name = "SSShowETA", text = SS_UI_QUEUE_SHOWETA, type = "check", onClick = "SSPVPO_LoadQueues", points = { "LEFT", "LEFT", 0, -30 }, varType = "sspvp", var = { "overlay", "showeta" }, parent = "SSQueueConfig" },
		{ name = "SSOverlayETAFormat", text = SS_UI_QUEUE_ETAFORMAT, type = "dropdown", onClick = "SSPVPO_LoadQueues",  points = { "LEFT", "LEFT", -13, -35 }, list = { { "minsec", SS_UI_MINSEC }, { "min", SS_UI_MIN }, { "mmss", SS_UI_MMSS } }, varType = "sspvp", var = { "overlay", "etaformat" }, parent = "SSQueueConfig" },


	};
	
	for _, ui in pairs( UIList ) do
		SSUI_AddElement( ui );
	end
end