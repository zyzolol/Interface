--[[ 
	SSAB By Shadowd of Icecrown (PVE)
	Original Release: July 27th (2006)
]]

local ABTimers = {};

local PlayerFaction;
local EnemyFaction;

local BaseData = {
	[0] = { amount = 0, interval = 0, perSecond = 0 },
	[1] = { amount = 10, interval = 11, perSecond = 0.83 },
	[2] = { amount = 10, interval = 10, perSecond = 1.11 },
	[3] = { amount = 10, interval = 6, perSecond = 1.66 },
	[4] = { amount = 10, interval = 3, perSecond = 3.3 },
	[5] = { amount = 30, interval = 1, perSecond = 30.0 }
};


function SSAB_OnLoad()
	this:RegisterEvent( "ADDON_LOADED" );
	this:RegisterEvent( "WORLD_MAP_UPDATE" );
	this:RegisterEvent( "UPDATE_BATTLEFIELD_SCORE" );
	
	SSLibrary_RegisterEvent( "SSAB_OnEvent", "BATTLEFIELD_WON" );
	SSLibrary_RegisterEvent( "SSAB_OnEvent", "LEFT_BATTLEFIELD" );
	SSLibrary_RegisterEvent( "SSAB_OnEvent", "BATTLEFIELD_INFO_UPDATED" );
	SSLibrary_RegisterEvent( "SSAB_OnEvent", "AB_RESOURCE_CLAIMED" );
	SSLibrary_RegisterEvent( "SSAB_OnEvent", "AB_RESOURCE_ASSAULTED" );
	SSLibrary_RegisterEvent( "SSAB_OnEvent", "AB_RESOURCE_CAPTURED" );
	SSLibrary_RegisterEvent( "SSAB_OnEvent", "AB_RESOURCE_LOADED" );

	-- Register SSAB with SSLoader
	local SSAB = { onLoad = "SSAB_OnLoad", loadInBG = { SS_ARATHIBASIN } };

	SSLoader_RegisterAddOn( "SSAB", SSAB );
	SSLoader_RegisterSlash( "SSAB", "SSAB_SlashHandler", { "/ssab" }, "SSAB" );
end 


function SSAB_SlashHandler( msg )
	local command, commandArg, optionState, optionValue;
	
	if( msg ~= nil ) then
		command = string.gsub( msg, "(.+) (.+)", "%1" );
		commandArg = string.gsub( msg, "(.+) (.+)", "%2" );
		command = ( command or msg );
	end
	
	if( commandArg == "on" ) then
		optionState = GREEN_FONT_COLOR_CODE .. SSAB_ON .. FONT_COLOR_CODE_CLOSE;
		optionValue = true;
	elseif( commandArg == "off" ) then
		optionState = RED_FONT_COLOR_CODE .. SSAB_OFF .. FONT_COLOR_CODE_CLOSE;
		optionValue = false;
	end
	
	if( command == "on" ) then
		SSAB_Config.enabled = true;
		SSLibrary_Message( string.format( SSAB_CMD_ENABLED, GREEN_FONT_COLOR_CODE .. SSAB_ON .. FONT_COLOR_CODE_CLOSE ) );
		
		SSAB_ReloadEstimatedScore();

	elseif( command == "off" ) then
		SSAB_Config.enabled = false;
		SSLibrary_Message( string.format( SSAB_CMD_ENABLED, RED_FONT_COLOR_CODE .. SSAB_OFF .. FONT_COLOR_CODE_CLOSE ) );
		
		SSAB_ReloadEstimatedScore();
		-- Remove all timers
		SSLibrary_UnScheduleEvent( "SSAB_PrintTimer" );
	elseif( command == "interval" and commandArg ) then
		SSAB_Config.interval = tonumber( commandArg );
		
		if( SSAB_Config.interval < 10 ) then
			SSLibrary_Message( SSAB_CMD_TOLOWINTERVAL );
			SSAB_Config.interval = 30;
		else
			SSLibrary_Message( string.format( SSAB_CMD_INTERVAL, GREEN_FONT_COLOR_CODE .. SSAB_Config.interval .. FONT_COLOR_CODE_CLOSE ) );
		end
	

	elseif( command == "timeleft" and optionState ) then
		SSAB_Config.timeleft = optionValue;
		SSLibrary_Message( string.format( SSAB_CMD_TIMELEFT, optionState ) );
		
		SSAB_ReloadEstimatedScore();

	elseif( command == "finalscore" and optionState ) then
		SSAB_Config.finalscore = optionValue;
		SSLibrary_Message( string.format( SSAB_CMD_FINALSCORE, optionState ) );

		SSAB_ReloadEstimatedScore();

	elseif( command == "base" and optionState ) then
		SSAB_Config.basewin = optionValue;
		SSLibrary_Message( string.format( SSAB_CMD_BASES, optionState ) );

		SSAB_ReloadEstimatedScore();

	elseif( command == "fbase" and optionState ) then
		SSAB_Config.basefinal = optionValue;
		SSLibrary_Message( string.format( SSAB_CMD_BASEFINAL, optionState ) );

		SSAB_ReloadEstimatedScore();

	elseif( command == "horde" and optionState ) then
		SSAB_Config.horde = optionValue;
		SSLibrary_Message( string.format( SSAB_CMD_FACTIONH, optionState ) );
	
	elseif( command == "print" ) then
		if( commandArg == command ) then
			commandArg = nil;
		end

		SSAB_PrintTimersToChat( commandArg );

	elseif( command == "printmatch" and MatchInfo ) then
		if( commandArg == command ) then
			commandArg = nil;
		end
		
		SSAB_PrintMatchToChat( commandArg );
	
	elseif( command == "alliance" and optionState ) then
		SSAB_Config.alliance = optionValue;
		SSLibrary_Message( string.format( SSAB_CMD_FACTIONA, optionState ) );
	
	elseif( command == "status" ) then
		local statusList = {	{ SSAB_Config.enabled, SSAB_CMD_ENABLED }, { SSAB_Config.interval, SSAB_CMD_INTERVAL },
					{ SSAB_Config.horde, SSAB_CMD_FACTIONH }, { SSAB_Config.alliance, SSAB_CMD_FACTIONA },
					{ SSAB_Config.timeleft, SSAB_CMD_TIMELEFT }, { SSAB_Config.finalscore, SSAB_CMD_FINALSCORE },
					{ SSAB_Config.basewin, SSAB_CMD_BASES }, { SSAB_Config.basefinal, SSAB_CMD_BASEFINAL } };

		for _, data in pairs( statusList ) do
			local status = RED_FONT_COLOR_CODE .. SSAB_OFF .. FONT_COLOR_CODE_CLOSE;
			if( data[1] ) then
				status = GREEN_FONT_COLOR_CODE .. SSAB_ON .. FONT_COLOR_CODE_CLOSE;
			end
			
			SSLibrary_Message( string.format( data[2], status ) );
		end
	
	else
		for _, text in pairs( SSAB_HELP ) do
			SSLibrary_Message( text, ChatTypeInfo["SYSTEM"] );
		end
	end

end

function SSAB_PrintSingleTimer()
	local timer = this.extraData;
	
	if( GetTime() >= timer.endTime ) then
		return;	
	end
	
	SendChatMessage( string.format( SSAB_CHAT_TIMER, timer.name, timer.faction, SSLibrary_SecondsToBuff( timer.endTime - GetTime()) ), "BATTLEGROUND" );
end

function SSAB_PrintTimersToChat( channel )
	local channelType = "BATTLEGROUND";
	
	if( type( channel ) == "string" ) then
		-- Make sure it's a valid type
		channelType = string.upper( channel or channelType );
	end
	
	if( channelType ~= "GUILD" and channelType ~= "PARTY" and channelType ~= "RAID" and channelType ~= "BATTLEGROUND" and channelType ~= "SAY" ) then
		SSLibrary_Message( string.format( SSAB_INVALID_CHANTYPE, channel ), ChatTypeInfo["SYSTEM"] );
		return;
	end
	
	for id, timer in pairs( ABTimers ) do
		if( GetLocale() == "enUS" ) then
			timer.name = string.upper( string.sub( timer.name, 0, 1 ) ) .. string.sub( timer.name, 2 );
		end
		
		if( GetTime() <= timer.endTime ) then
			SendChatMessage( string.format( SSAB_CHAT_TIMER, timer.name, timer.faction, SSLibrary_SecondsToBuff( timer.endTime - GetTime() ) ), channelType );
		end
	end
end

function SSAB_PrintMatchToChat( channel )
	local channelType = "BATTLEGROUND";
	
	if( type( channel ) == "string" ) then
		-- Make sure it's a valid type
		channelType = string.upper( channel or channelType );
	end

	if( channelType ~= "GUILD" and channelType ~= "PARTY" and channelType ~= "RAID" and channelType ~= "BATTLEGROUND" and channelType ~= "SAY" ) then
		SSLibrary_Message( string.format( SSAB_INVALID_CHANTYPE, channel ), ChatTypeInfo["SYSTEM"] );
		return;
	end
		
	SendChatMessage( string.format( SSAB_CHAT_MATCH_INFO, SSLibrary_SecondsToBuff( MatchInfo.timeleft ), MatchInfo.towin.bases, MatchInfo.towin.Alliance, MatchInfo.towin.Horde ), channelType );	
	SendChatMessage( string.format( SSAB_CHAT_MATCH_INFO2, MatchInfo.final["Alliance"], MatchInfo.final["Horde"] ), channelType );	
end

function SSAB_PrintTimer( name )
	local data, dataIndex;
	
	-- Find the data first ( of course )
	for id, timer in pairs( ABTimers ) do
		if( timer.name == name ) then
			data = timer;
			dataIndex = id;
		end
	end
	
	if( data == nil or dataIndex == nil or GetTime() >= data.endTime ) then
		return;
	end
	
	local timeLeft = ceil( data.endTime - GetTime() );
	
	if( timeLeft <= 0 ) then
		return;
	end
		
	if( ( not SSAB_Config.enabled ) or ( not SSAB_Config.horde and data.faction == SS_HORDE ) or ( not SSAB_Config.alliance and data.faction == SS_ALLIANCE ) ) then
		return;
	end
	
	SSLibrary_PVPMessage( string.format( SSAB_TIMERUPDATE, data.name, data.faction, string.lower( SSLibrary_SecondsToFull( timeLeft ) ) ), data.faction );
end


function SSAB_ReloadEstimatedScore()
	SSOverlay_RemoveRow( { cat = "abest" } );
	SSAB_OnEvent( "WORLD_MAP_UPDATE" );
end

function SSAB_AddOverlayCategories()
	SSOverlay_AddCategory( "abest", { text = SSAB_INFO } );
	SSOverlay_AddCategory( "ab", {	mouseUp = SSAB_PrintTimersToChat,
					text = SSAB_TIMERS } );
end

function SSAB_OnEvent( event, ... )
	
	if( event == "ADDON_LOADED" and arg1 == "SSAB" ) then
		if( SSAB_Config == nil ) then
			SSAB_Config = SSAB_GetDefaultConfig( nil, true );	
		end
		
		PlayerFaction = UnitFactionGroup( "player" );
		if( PlayerFaction == "Alliance" ) then
			EnemyFaction = "Horde";
		elseif( PlayerFaction == "Horde" ) then
			EnemyFaction = "Alliance";
		end
		
		-- Load some other things to keep everyone happy
		if( SSLibrary_IsInAB() ) then
			SSAB_AddOverlayCategories();
			SSLibrary_RequestABTimers();
		end

	elseif( event == "WORLD_MAP_UPDATE" and GetNumWorldStateUI() == 2 and SSLibrary_IsInAB() ) then
		if( not SSAB_Config.enabled and not SSAB_Config.timeleft and not SSAB_Config.basewin and not SSAB_Config.finalscore ) then
			SSOverlay_RemoveRow( { cat = "ab", text = SSAB_TIMERS } );
			SSOverlay_RemoveRow( { cat = "abest" } );
			return;
		end
		
		local _, allianceText = GetWorldStateUIInfo( 1 );
		local _, hordeText = GetWorldStateUIInfo( 2 );
		
		local ExtraData = {};
		local BGData = {};
		local TimeLeft = { Alliance = 0, Horde = 0 };
		
		if( string.find( allianceText, SSAB_WORLDUI ) ) then
			local _, _, bases, score = string.find( allianceText, SSAB_WORLDUI );
			score = tonumber( score );
			bases = tonumber( bases );
			
			BGData["Alliance"] = { left = ( 2000 - score ), bases = bases, score = score };
			
			if( BGData["Alliance"].bases > 0 ) then
				TimeLeft["Alliance"] = BGData["Alliance"].left / BaseData[ BGData["Alliance"].bases ].perSecond;
			end
		else
			return;
		end
		
		if( string.find( hordeText, SSAB_WORLDUI ) ) then
			local _, _, bases, score = string.find( hordeText, SSAB_WORLDUI );
			score = tonumber( score );
			bases = tonumber( bases );

			BGData["Horde"] = { left = ( 2000 - score ), bases = bases, score = score };
			if( BGData["Horde"].bases > 0 ) then
				TimeLeft["Horde"] = BGData["Horde"].left / BaseData[ BGData["Horde"].bases ].perSecond;
			end
		else
			return;		
		end
		
		if( BGData["Alliance"].score == 0 and BGData["Horde"].score == 0 ) then
			return;
		end
		
		for faction, data in pairs( BGData ) do
			local tick = BaseData[ data.bases ];

			if( tick.perSecond > 0.0 ) then
				TimeLeft[ faction ] = data.left / tick.perSecond;
			else
				TimeLeft[ faction ] = 9999;
			end
		end

		if( TimeLeft["Alliance"] < TimeLeft["Horde"] ) then
			TimeLeft["Lowest"] = TimeLeft["Alliance"];
			TimeLeft["LowestFact"] = "Alliance";
		elseif( TimeLeft["Horde"] < TimeLeft["Alliance"] ) then
			TimeLeft["Lowest"] = TimeLeft["Horde"];
			TimeLeft["LowestFact"] = "Horde";
		elseif( TimeLeft["Horde"] == TimeLeft["Alliance"] ) then
			TimeLeft["Lowest"] = TimeLeft["Horde"];
			TimeLeft["LowestFact"] = "Neutral";
		end
		
		ExtraData["timeleft"] = TimeLeft["Lowest"];
		

		if( TimeLeft["Lowest"] and TimeLeft["Lowest"] ~= 9999 ) then
			-- Time left
			if( SSAB_Config.timeleft ) then
				SSOverlay_UpdateRow( {	type = "down",
							text = SSAB_TIMELEFT,
							seconds = TimeLeft["Lowest"],
							cat = "abest",
							color = SSLibrary_GetFactionColor("Neutral" ) } );
			end

			-- Final score
			local PFinalScore = BGData[ PlayerFaction ].score + math.floor( TimeLeft["Lowest"] * BaseData[ BGData[ PlayerFaction ].bases ].perSecond + 0.5 );
			local EFinalScore = BGData[ EnemyFaction ].score + math.floor( TimeLeft["Lowest"] * BaseData[ BGData[ EnemyFaction ].bases ].perSecond + 0.5 );

			PFinalScore = math.floor( PFinalScore / 10 ) * 10;
			EFinalScore = math.floor( EFinalScore / 10 ) * 10;

			ExtraData["final"] = {};
			ExtraData["final"][ PlayerFaction ] = PFinalScore;
			ExtraData["final"][ EnemyFaction ] = EFinalScore;

			local PText = string.format( SSAB_FINALSCORE_NOREP, PFinalScore );
			local EText = string.format( SSAB_FINALSCORE_NOREP, EFinalScore );
			
			if( SSAB_Config.finalscore ) then
				SSOverlay_UpdateRow( {	type = "text",
							text = SSAB_FINALSCORE,
							newText = PText;
							cat = "abest",
							color = SSLibrary_GetFactionColor( PlayerFaction ),
							looseMatch = true, } );

				SSOverlay_UpdateRow( {	type = "text",
							text = SSAB_FINALSCORE,
							newText = EText;
							cat = "abest",
							color = SSLibrary_GetFactionColor( EnemyFaction ),
							looseMatch = true, } );
			end
		end
				
		-- Bases to win
		for i=1, 5 do
			local data = BaseData[ i ];
			local PTimeLeft = BGData[ PlayerFaction ].left / data.perSecond;
			local ETimeLeft = BGData[ EnemyFaction ].left / BaseData[ 5 - i ].perSecond;
			local LowestTime = 0;

			-- Repeat the same blah code
			if( PTimeLeft < ETimeLeft ) then
				LowestTime = PTimeLeft;	
			elseif( ETimeLeft < PTimeLeft ) then
				LowestTime = ETimeLeft;
			elseif( ETimeLeft == PTimeLeft ) then
				LowestTime = ETimeLeft;
			end

			local PScore = BGData[ PlayerFaction ].score + math.floor( LowestTime * data.perSecond );
			local EScore = BGData[ EnemyFaction ].score + math.floor( LowestTime * ( BaseData[ 5 - i ].perSecond ) );

			PScore = math.floor( PScore / 10 ) * 10;
			EScore = math.floor( EScore / 10 ) * 10;
			
			if( PScore >= 2000 and EScore < 2000 ) then
				ExtraData["towin"] = { bases = id };
				
				if( PlayerFaction == "Horde" ) then
					ExtraData["towin"]["Alliance"] = Escore;  				
					ExtraData["towin"]["Horde"] = PScore;
				elseif( PlayerFaction == "Alliance" ) then
					ExtraData["towin"]["Alliance"] = PScore; 
					ExtraData["towin"]["Horde"] = EScore;
				end
				
				if( SSAB_Config.basewin ) then
					local format, extraText;
					
					if( SSAB_Config.basefinal ) then
						if( PlayerFaction == "Horde" ) then
							extraText = { i, EScore, PScore };
						elseif( PlayerFaction == "Alliance" ) then
							extraText = { i, PScore, EScore };
						end
						
						format = "*text*: *extra1* " .. SSAB_BASES_FINAL;
					else
						extraText = { i };
					end
					
					SSOverlay_UpdateRow( {	type = "text",
								text = SSAB_BASESTOWIN,
								newText = SSAB_BASESTOWIN,
								extra = extraText,
								cat = "abest",
								color = SSLibrary_GetFactionColor( "Neutral" ),
								format = format,
								looseMatch = true } );
				end
				break;
			end
		end
		
		MatchInfo = ExtraData;
		
		SSOverlay_UpdateRow( {	type = "text",
					text = SSAB_INFO,
					newText = SSAB_INFO,
					cat = "abest",
					mouseUp = SSAB_PrintMatchToChat,
					looseMatch = true, } );
		
	elseif( event == "BATTLEFIELD_INFO_UPDATED" ) then
		ABTimers = {};
		SSOverlay_RemoveRow( { cat = "ab" } );
		SSOverlay_RemoveRow( { cat = "abest" } );		

		SSAB_AddOverlayCategories();

	elseif( event == "BATTLEFIELD_WON" or event == "LEFT_BATTLEFIELD" ) then
		ABTimers = {};
		SSOverlay_RemoveRow( { cat = "ab" } );
		SSOverlay_RemoveRow( { cat = "abest" } );		

	elseif( event == "AB_RESOURCE_CAPTURED" ) then
		for i=#( ABTimers ), 1, -1 do
			local timer = ABTimers[ i ];
			if( timer.name == select( 1, ... ) ) then
				SSLibrary_UnScheduleEvent( "SSAB_PrintTimer", timer.name );
				SSOverlay_RemoveRow( { cat = "ab", text = timer.name } );
				
				table.remove( ABTimers, i );
			end
		end
		
	elseif( ( event == "AB_RESOURCE_ASSAULTED" or event == "AB_RESOURCE_CLAIMED" or event == "AB_RESOURCE_LOADED" ) and SSAB_Config.enabled ) then
		local events = {};
		local endTime
		local seconds = 1;
		local secondsLeft = 60;
		
		if( event == "AB_RESOURCE_LOADED" and select( 3, ... ) ~= nil ) then
			secondsLeft = select( 3, ... ) - GetTime();
		end
		
		-- Schedule the status events
		while( seconds < secondsLeft ) do
			if( mod( seconds, SSAB_Config.interval ) == 0 ) then
				SSLibrary_ScheduleEvent( "SSAB_PrintTimer", seconds, select( 1, ... ) );
			end

			seconds = seconds + 1;
		end	
		
		-- If a resource was loaded
		if( event == "AB_RESOURCE_LOADED" ) then
			endTime = select( 3, ... );
		else
			endTime = GetTime() + 60;
		end
		
		local overlayText = select( 1, ... );
		if( GetLocale() == "enUS" and string.len( overlayText ) > 1 ) then
			overlayText = string.upper( string.sub( overlayText, 0, 1 ) ) .. string.sub( overlayText, 2 );
		end
		
		SSOverlay_UpdateRow( {	type = "down",
					seconds = secondsLeft,
					text = overlayText,
					color = SSLibrary_GetFactionColor( select( 2, ... ) ),
					mouseUp = SSAB_PrintSingleTimer,
					extraData = { name = overlayText, faction = select( 2, ... ), endTime = endTime },
					ignoreColor = true,
					cat = "ab" } );
					
		table.insert( ABTimers, { name = select( 1, ... ), faction = select( 2, ... ), endTime = endTime } );
	end
end


function SSAB_LoadUI()
	SSUI_RegisterVarType( "ssab", "SSAB_SetVariable", "SSAB_GetVariable" );

	SSUI_AddTab( SS_ARATHIBASIN, "SSABConfig", 6 );
	SSUI_AddFrame( "SSABConfig", "sspvp" );

	-- Add the elements
	local UIList = {
		{ name = "SSABEnable", text = SSAB_UI_ENABLE, type = "check", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "ssab", var = { "enabled" }, parent = "SSABConfig" },
		{ name = "SSABOverlayEnable", text = SSAB_UI_OVERLAYENABLE, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssab", var = { "enableoverlay" }, parent = "SSABConfig" },
		{ name = "SSABInterval", text = SSAB_UI_INTERVAL, type = "input", points = { "LEFT", "LEFT", 10, -30 }, maxChars = 2, width = 20, varType = "ssab", forceType = "int", var = { "interval" }, parent = "SSABConfig" },
		{ name = "SSABEnableHorde", text = SSAB_UI_HORDEENABLE, type = "check", points = { "LEFT", "LEFT", -10, -30 }, varType = "ssab", var = { "horde" }, parent = "SSABConfig" },
		{ name = "SSABEnableAlliance", text = SSAB_UI_ALLIANCEENABLE, type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssab", var = { "alliance" }, parent = "SSABConfig" },
		{ name = "SSABTimeLeft", text = SSAB_UI_TIMELEFT, onClick = "SSAB_ReloadEstimatedScore", type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssab", var = { "timeleft" }, parent = "SSABConfig" },
		{ name = "SSABFinalScore", text = SSAB_UI_FINALSCORE, onClick = "SSAB_ReloadEstimatedScore",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssab", var = { "finalscore" }, parent = "SSABConfig" },
		{ name = "SSABBases", text = SSAB_UI_BASES, onClick = "SSAB_ReloadEstimatedScore",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssab", var = { "basewin" }, parent = "SSABConfig" },
		{ name = "SSABBasesFinal", text = SSAB_UI_BASES_FINAL, onClick = "SSAB_ReloadEstimatedScore",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssab", var = { "basefinal" }, parent = "SSABConfig" },
	};

	for _, element in pairs( UIList ) do
		SSUI_AddElement( element );
	end
end

-- Variable management
function SSAB_GetDefaultConfig( var, fullConfig )
	Config = {};
	Config.enabled = true;
	Config.interval = 30;
	Config.horde = false;
	Config.alliance = false;
	Config.timeleft = true;
	Config.finalscore = true;
	Config.base = true;
	Config.basefinal = false;
	Config.enableoverlay = true;
	
	if( fullConfig ) then
		return Config;
	elseif( var ) then
		return Config[ var ];
	end
	
	return nil;
end

function SSAB_GetVariable( vars )
	if( SSAB_Config[ vars[1] ] == nil ) then
		SSAB_Config[ vars[1] ] = SSAB_GetDefaultConfig( vars[1] );
	end
	
	return SSAB_Config[ vars[1] ];
end

function SSAB_SetVariable( vars, value )
	SSAB_Config[ vars[1] ] = value;
end