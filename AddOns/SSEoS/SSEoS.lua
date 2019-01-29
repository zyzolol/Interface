--[[ 
	SSEoS By Shadowd of Icecrown (PVE)
	Original Release: February 2nd (2007)
]]

local PlayerFaction;
local EnemyFaction;

local TowerData = {
	[0] = { perSecond = 0 },
	[1] = { perSecond = 0.5 },
	[2] = { perSecond = 1 },
	[3] = { perSecond = 2.5 },
	[4] = { perSecond = 5 },
};

function SSES_OnLoad()
	this:RegisterEvent( "ADDON_LOADED" );
	this:RegisterEvent( "WORLD_MAP_UPDATE" );
	this:RegisterEvent( "UPDATE_BATTLEFIELD_SCORE" );
	
	SSLibrary_RegisterEvent( "SSES_OnEvent", "BATTLEFIELD_WON" );
	SSLibrary_RegisterEvent( "SSES_OnEvent", "LEFT_BATTLEFIELD" );
	SSLibrary_RegisterEvent( "SSES_OnEvent", "BATTLEFIELD_INFO_UPDATED" );
	
	SSLoader_RegisterAddOn( "SSEoS", { onLoad = "SSES_OnLoad", loadInBG = { SS_EYEOFTHESTORM } } );
	SSLoader_RegisterSlash( "SSEoS", "SSES_SlashHandler", { "/sses", "/sseos", "/sseots" }, "SSEoS" );
end 

function SSES_SlashHandler( msg )
	local command, commandArg, optionState, optionValue;
	
	if( msg ~= nil ) then
		command = string.gsub( msg, "(.+) (.+)", "%1" );
		commandArg = string.gsub( msg, "(.+) (.+)", "%2" );
		command = ( command or msg );
	end
	
	if( commandArg == "on" ) then
		optionState = GREEN_FONT_COLOR_CODE .. SSES_ON .. FONT_COLOR_CODE_CLOSE;
		optionValue = true;
	elseif( commandArg == "off" ) then
		optionState = RED_FONT_COLOR_CODE .. SSES_OFF .. FONT_COLOR_CODE_CLOSE;
		optionValue = false;
	end
	
	if( command == "on" ) then
		SSES_Config.enabled = true;
		SSLibrary_Message( string.format( SSES_CMD_ENABLED, GREEN_FONT_COLOR_CODE .. SSES_ON .. FONT_COLOR_CODE_CLOSE ) );
		
	elseif( command == "off" ) then
		SSES_Config.enabled = false;
		SSLibrary_Message( string.format( SSES_CMD_ENABLED, RED_FONT_COLOR_CODE .. SSES_OFF .. FONT_COLOR_CODE_CLOSE ) );
		
	elseif( command == "timeleft" and optionState ) then
		SSES_Config.timeleft = optionValue;
		SSLibrary_Message( string.format( SSES_CMD_TIMELEFT, optionState ) );
		
		SSES_ReloadEstimatedScore();

	elseif( command == "finalscore" and optionState ) then
		SSES_Config.finalscore = optionValue;
		SSLibrary_Message( string.format( SSES_CMD_FINALSCORE, optionState ) );

		SSES_ReloadEstimatedScore();

	elseif( command == "tower" and optionState ) then
		SSES_Config.towerwin = optionValue;
		SSLibrary_Message( string.format( SSES_CMD_TOWERS, optionState ) );

		SSES_ReloadEstimatedScore();

	elseif( command == "ftower" and optionState ) then
		SSES_Config.finaltower = optionValue;
		SSLibrary_Message( string.format( SSES_CMD_TOWERFINAL, optionState ) );

		SSES_ReloadEstimatedScore();
		
	elseif( command == "percap" and optionState ) then
		SSES_Config.percapture = optionValue;
		SSLibrary_Message( string.format( SSES_CMD_PERCAPTURE, optionState ) );
		
		SSES_ReloadEstimatedScore();

	elseif( command == "printmatch" and MatchInfo ) then
		if( commandArg == command ) then
			commandArg = nil;
		end
		
		SSES_PrintMatchToChat( commandArg );
	
	elseif( command == "status" ) then
		local statusList = {	{ SSES_Config.enabled, SSES_CMD_ENABLED }, { SSES_Config.timeleft, SSES_CMD_TIMELEFT },
					{ SSES_Config.finalscore, SSES_CMD_FINALSCORE }, { SSES_Config.towerwin, SSES_CMD_TOWERS },
					{ SSES_Config.percapture, SSES_CMD_PERCAPTURE }, { SSES_Config.finaltower, SSES_CMD_TOWERFINAL } };

		for _, data in pairs( statusList ) do
			local status = RED_FONT_COLOR_CODE .. SSES_OFF .. FONT_COLOR_CODE_CLOSE;
			if( data[1] ) then
				status = GREEN_FONT_COLOR_CODE .. SSES_ON .. FONT_COLOR_CODE_CLOSE;
			end
			
			SSLibrary_Message( string.format( data[2], status ) );
		end
	
	else
		for _, text in pairs( SSES_HELP ) do
			SSLibrary_Message( text, ChatTypeInfo["SYSTEM"] );
		end
	end

end

function SSES_PrintMatchToChat( channel )
	local channelType = "BATTLEGROUND";
	
	if( type( channel ) == "string" ) then
		-- Make sure it's a valid type
		channelType = string.upper( channel or channelType );
	end

	if( channelType ~= "GUILD" and channelType ~= "PARTY" and channelType ~= "RAID" and channelType ~= "BATTLEGROUND" and channelType ~= "SAY" ) then
		SSLibrary_Message( string.format( SSES_INVALID_CHANTYPE, channel ), ChatTypeInfo["SYSTEM"] );
		return;
	end
	
	SendChatMessage( string.format( SSES_CHAT_MATCH_INFO, SSLibrary_SecondsToBuff( MatchInfo.timeleft ), MatchInfo.towin.towers, MatchInfo.towin.Alliance, MatchInfo.towin.Horde ), channelType );	
	SendChatMessage( string.format( SSES_CHAT_MATCH_INFO2, MatchInfo.final["Alliance"], MatchInfo.final["Horde"] ), channelType );	
end


function SSES_AddOverlayCategories()
	SSOverlay_AddCategory( "esest", {	mouseUp = SSES_PrintMatchToChat,
						text = SSES_INFO,
						newText = SSES_INFO } );
end

function SSES_ReloadEstimatedScore()
	SSOverlay_RemoveRow( { cat = "esest" } );
	SSES_OnEvent( "WORLD_MAP_UPDATE" );
end

function SSES_OnEvent( event, ... )

	if( event == "ADDON_LOADED" and arg1 == "SSEoS" ) then
		if( SSES_Config == nil ) then
			SSES_Config = SSES_GetDefaultConfig( nil, true );	
		end
		
		PlayerFaction = UnitFactionGroup( "player" );
		if( PlayerFaction == "Alliance" ) then
			EnemyFaction = "Horde";
		elseif( PlayerFaction == "Horde" ) then
			EnemyFaction = "Alliance";
		end

		if( SSLibrary_IsInEOS() ) then
			SSES_AddOverlayCategories();
		end
		
	elseif( event == "WORLD_MAP_UPDATE" and GetNumWorldStateUI() == 3 and SSLibrary_IsInEOS() ) then
		if( not SSES_Config.enabled ) then
			SSOverlay_RemoveRow( { cat = "esest" } );
			return;
		end
		
		local _, allianceText = GetWorldStateUIInfo( 2 );
		local _, hordeText = GetWorldStateUIInfo( 3 );
		
		local ExtraData = {};
		local BGData = {};
		local TimeLeft = { Alliance = 0, Horde = 0 };
		
		if( string.find( allianceText, SSES_WORLDUI ) ) then
			local _, _, towers, score = string.find( allianceText, SSES_WORLDUI );
			score = tonumber( score );
			towers = tonumber( towers );
			
			BGData["Alliance"] = { left = ( 2000 - score ), towers = towers, score = score };
			
			if( BGData["Alliance"].towers > 0 ) then
				TimeLeft["Alliance"] = BGData["Alliance"].left / TowerData[ BGData["Alliance"].towers ].perSecond;
			end
		else
			return;
		end
		
		if( string.find( hordeText, SSES_WORLDUI ) ) then
			local _, _, towers, score = string.find( hordeText, SSES_WORLDUI );
			score = tonumber( score );
			towers = tonumber( towers );

			BGData["Horde"] = { left = ( 2000 - score ), towers = towers, score = score };
			if( BGData["Horde"].towers > 0 ) then
				TimeLeft["Horde"] = BGData["Horde"].left / TowerData[ BGData["Horde"].towers ].perSecond;
			end
		else
			return;		
		end
		
		if( BGData["Alliance"].score == 0 and BGData["Horde"].score == 0 ) then
			return;
		end
		
		for faction, data in pairs( BGData ) do
			local tick = TowerData[ data.towers ];

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
			if( SSES_Config.timeleft ) then
				SSOverlay_UpdateRow( {	type = "down",
							text = SSES_TIMELEFT,
							seconds = TimeLeft["Lowest"],
							cat = "esest",
							color = SSLibrary_GetFactionColor("Neutral" ) } );
			end
			
			-- Final score
			local PFinalScore = BGData[ PlayerFaction ].score + math.floor( TimeLeft["Lowest"] * TowerData[ BGData[ PlayerFaction ].towers ].perSecond + 0.5 );
			local EFinalScore = BGData[ EnemyFaction ].score + math.floor( TimeLeft["Lowest"] * TowerData[ BGData[ EnemyFaction ].towers ].perSecond + 0.5 );

			ExtraData["final"] = {};
			ExtraData["final"][ PlayerFaction ] = PFinalScore;
			ExtraData["final"][ EnemyFaction ] = EFinalScore;

			if( SSES_Config.finalscore ) then
				SSOverlay_UpdateRow( {	type = "text",
							text = SSES_FINALSCORE,
							newText = SSES_FINALSCORE,
							extra = { PFinalScore },
							cat = "esest",
							color = SSLibrary_GetFactionColor( PlayerFaction ),
							looseMatch = true, } );

				SSOverlay_UpdateRow( {	type = "text",
							text = SSES_FINALSCORE,
							newText = SSES_FINALSCORE,
							extra = { EFinalScore },
							cat = "esest",
							color = SSLibrary_GetFactionColor( EnemyFaction ),
							looseMatch = true, } );
			end
		end
				
		-- Towers to win
		for i=1, 4 do
			local data = TowerData[ i ];
			local PTimeLeft = BGData[ PlayerFaction ].left / data.perSecond;
			local ETimeLeft = BGData[ EnemyFaction ].left / TowerData[ 4 - i ].perSecond;
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
			local EScore = BGData[ EnemyFaction ].score + math.floor( LowestTime * ( TowerData[ 4 - i ].perSecond ) );

			if( PScore >= 2000 and EScore < 2000 ) then
				ExtraData["towin"] = { towers = i };
				
				if( PlayerFaction == "Horde" ) then
					ExtraData["towin"]["Alliance"] = Escore;  				
					ExtraData["towin"]["Horde"] = PScore;
				elseif( PlayerFaction == "Alliance" ) then
					ExtraData["towin"]["Alliance"] = PScore; 
					ExtraData["towin"]["Horde"] = EScore;
				end
				
				local format, extraText;

				if( SSES_Config.finaltower ) then
					if( PlayerFaction == "Horde" ) then
						extraText = { i, EScore, PScore };
					elseif( PlayerFaction == "Alliance" ) then
						extraText = { i, PScore, EScore };
					end

					format = "*text*: *extra1* " .. SSES_TOWERS_FINAL;
				else
					extraText = { i };
				end

				if( SSES_Config.towerwin ) then
					SSOverlay_UpdateRow( {	type = "text",
								text = SSES_TOWERSTOWIN,
								newText = SSES_TOWERSTOWIN,
								extra = extraText,
								cat = "esest",
								color = SSLibrary_GetFactionColor( "Neutral" ),
								format = format,
								looseMatch = true } );
				end
				break;
			end
		end
		
		-- Points per a capture
		if( SSES_Config.percapture ) then
			SSOverlay_UpdateRow( {	type = "text",
						text = SSES_PERCAPTURE,
						newText = SSES_PERCAPTURE,
						extra = { BGData[ PlayerFaction ].towers * 25 },
						cat = "esest",
						looseMatch = true,
						color = SSLibrary_GetFactionColor( "Neutral" ),
						} );
		end
		
		MatchInfo = ExtraData;
				
	elseif( event == "BATTLEFIELD_INFO_UPDATED" ) then
		SSOverlay_RemoveRow( { cat = "esest" } );		
		
		if( SSLibrary_IsInEOS() ) then
			SSES_AddOverlayCategories();
		end
	
	elseif( event == "BATTLEFIELD_WON" or event == "LEFT_BATTLEFIELD" ) then
		SSOverlay_RemoveRow( { cat = "esest" } );		
	end
end


function SSEoS_LoadUI()
	SSUI_RegisterVarType( "sses", "SSES_SetVariable", "SSES_GetVariable" );

	SSUI_AddTab( SS_EYEOFTHESTORM, "SSESConfig", 6 );
	SSUI_AddFrame( "SSESConfig", "sspvp" );

	-- Add the elements
	local UIList = {
		{ name = "SSESEnable", text = SSES_UI_ENABLE, type = "check", onClick = "SSES_ReloadEstimatedScore", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "sses", var = { "enabled" }, parent = "SSESConfig" },
		{ name = "SSESTimeLeft", text = SSES_UI_TIMELEFT, onClick = "SSES_ReloadEstimatedScore", type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sses", var = { "timeleft" }, parent = "SSESConfig" },
		{ name = "SSESFinalScore", text = SSES_UI_FINALSCORE, onClick = "SSES_ReloadEstimatedScore",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sses", var = { "finalscore" }, parent = "SSESConfig" },
		{ name = "SSESPerCapture", text = SSES_UI_PERCAPTURE, onClick = "SSES_ReloadEstimatedScore",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sses", var = { "percapture" }, parent = "SSESConfig" },
		{ name = "SSESTowers", text = SSES_UI_TOWERS, onClick = "SSES_ReloadEstimatedScore",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sses", var = { "towerwin" }, parent = "SSESConfig" },
		{ name = "SSESTowersFinal", text = SSES_UI_FINALTOWER, onClick = "SSES_ReloadEstimatedScore",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sses", var = { "finaltower" }, parent = "SSESConfig" },
	};

	for _, element in pairs( UIList ) do
		SSUI_AddElement( element );
	end
end

-- Variable management
function SSES_GetDefaultConfig( var, fullConfig )
	Config = {};
	Config.enabled = true;
	Config.finalscore = true;
	Config.finaltower = false;
	Config.towerwin = true;
	Config.percapture = true;
	Config.timeleft = true;
	
	if( fullConfig ) then
		return Config;
	elseif( var ) then
		return Config[ var ];
	end
	
	return nil;
end

function SSES_GetVariable( vars )
	if( SSES_Config[ vars[1] ] == nil ) then
		SSES_Config[ vars[1] ] = SSES_GetDefaultConfig( vars[1] );
	end
	
	return SSES_Config[ vars[1] ];
end

function SSES_SetVariable( vars, value )
	SSES_Config[ vars[1] ] = value;
end