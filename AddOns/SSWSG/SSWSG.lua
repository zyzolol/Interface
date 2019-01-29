--[[ 
	SSWSG By Shadowd of Icecrown (PVE)
	Original Release: July 27th (2006)
]]

local Orig_SendChatMessage;

local carrierNames = {};
local BGPlayerData = {};

local PlayerFaction;
local EnemyFaction;

local SkipNextCheck;

local FriendlyCarrierID;
local UpdateWhenOOC;

function SSWSG_OnLoad()
	this:RegisterEvent( "ADDON_LOADED" );
	this:RegisterEvent( "UNIT_HEALTH" );
	
	this:RegisterEvent( "RAID_ROSTER_UPDATE" );
	
	this:RegisterEvent( "UPDATE_BINDINGS" );
	
	this:RegisterEvent( "PLAYER_REGEN_ENABLED" );
	
	SSLibrary_RegisterEvent( "SSWSG_OnEvent", "WSG_FLAG_PICKEDUP" );
	SSLibrary_RegisterEvent( "SSWSG_OnEvent", "WSG_FLAG_DROPPED" );
	SSLibrary_RegisterEvent( "SSWSG_OnEvent", "WSG_FLAG_CAPTURED" );
	SSLibrary_RegisterEvent( "SSWSG_OnEvent", "BATTLEFIELD_SCORES_UPDATED" );
	SSLibrary_RegisterEvent( "SSWSG_OnEvent", "BATTLEFIELD_INFO_UPDATED" );
	SSLibrary_RegisterEvent( "SSWSG_OnEvent", "WSG_CARRIER_LOADED" );
	SSLibrary_RegisterEvent( "SSWSG_OnEvent", "BATTLEFIELD_WON" );
	SSLibrary_RegisterEvent( "SSWSG_OnEvent", "LEFT_BATTLEFIELD" );

	-- Register with SSLoader	
	local SSWSG = { onLoad = "SSWSG_OnLoad", loadInBG = { SS_WARSONGGULCH } };
	SSLoader_RegisterAddOn( "SSWSG", SSWSG );
	SSLoader_RegisterSlash( "SSWSG", "SSWSG_SlashHandler", { "/sswsg" }, "SSWSG" );
end 

function SSWSG_Dump()
	DevTools_Dump( carrierNames );
	Debug( "Player [" .. ( PlayerFaction or "nil" ) .. "] Enemy [" .. ( EnemyFaction or "nil" ) .. "]" );
	Debug( "Friendly ID [" .. ( FriendlyCarrierID or "nil" ) .. "]" );
end

function SSWSG_LoadUI()
	SSUI_RegisterVarType( "sswsg", "SSWSG_SetVariable", "SSWSG_GetVariable" );

	SSUI_AddTab( SS_WARSONGGULCH, "SSWSGConfig", 6 );
	SSUI_AddFrame( "SSWSGConfig", "sspvp" );

	-- Add the elements
	local enable = { name = "SSWSGEnable", text = SSWSG_UI_ENABLE, onClick = "SSWSG_UpdateCarriers", type = "check", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "sswsg", var = { "enabled" }, parent = "SSWSGConfig" };
	local names = { name = "SSWSGCarrierNames", text = SSWSG_UI_NAMES, onClick = "SSWSG_UpdateCarriers", type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sswsg", var = { "names" }, parent = "SSWSGConfig" };
	local colors = { name = "SSWSGCarrierColor", text = SSWSG_UI_COLOR, onClick = "SSWSG_UpdateCarriers",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sswsg", var = { "colors" }, parent = "SSWSGConfig" };
	local cname = { name = "SSWSGClassCarrier", text = SSWSG_UI_CNAME, onClick = "SSWSG_UpdateCarriers",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sswsg", var = { "cname" }, parent = "SSWSGConfig" };
	local cabbrev = { name = "SSWSGCarrierAbbrev", text = SSWSG_UI_CABBREV, onClick = "SSWSG_UpdateCarriers", type = "check", points = { "LEFT", "LEFT", 00, -30 }, varType = "sswsg", var = { "cabbrev" }, parent = "SSWSGConfig" };
	local fhealth = { name = "SSWSGFriendlyHealth", text = SSWSG_UI_FHEALTH, onClick = "SSWSG_UpdateCarriers",  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sswsg", var = { "fhealth" }, parent = "SSWSGConfig" };
	local flagtimer = { name = "SSWSGFlagTimer", text = SSWSG_UI_FLAGTIMER,  type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "sswsg", var = { "flagtimer" }, parent = "SSWSGConfig" };
	
	SSUI_AddElement( enable );
	SSUI_AddElement( names );
	SSUI_AddElement( colors );
	SSUI_AddElement( cname );
	SSUI_AddElement( cabbrev );
	SSUI_AddElement( fhealth );
	SSUI_AddElement( flagtimer );
end

-- Variable management
function SSWSG_GetDefaultConfig( var, fullConfig )
	Config = {};
	Config.enabled = true;
	Config.names = true;
	Config.colors = true;
	Config.cname = false;
	Config.fhealth = true;
	Config.cabbrev = false;
	Config.flagtimer = false;
	
	if( fullConfig ) then
		return Config;
	elseif( var ) then
		return Config[ var ];
	end
	
	return nil;
end

function SSWSG_GetVariable( vars )
	if( SSWSG_Config[ vars[1] ] == nil ) then
		SSWSG_Config[ vars[1] ] = SSWSG_GetDefaultConfig( vars[1] );
	end
	
	return SSWSG_Config[ vars[1] ];
end

function SSWSG_SetVariable( vars, value )
	SSWSG_Config[ vars[1] ] = value;
end


function SSWSG_SlashHandler( msg )
	local command, commandArg, optionState, optionValue;
	
	if( msg ~= nil ) then
		command = string.gsub( msg, "(.+) (.+)", "%1" );
		commandArg = string.gsub( msg, "(.+) (.+)", "%2" );
		command = ( command or msg );
	end
	
	if( commandArg == "on" ) then
		optionState = GREEN_FONT_COLOR_CODE .. SSWSG_ON .. FONT_COLOR_CODE_CLOSE;
		optionValue = true;
	elseif( commandArg == "off" ) then
		optionState = RED_FONT_COLOR_CODE .. SSWSG_OFF .. FONT_COLOR_CODE_CLOSE;
		optionValue = false;
	end
	
	if( command == "on" ) then
		SSWSG_Config.enabled = true;
		SSLibrary_Message( string.format( SSWSG_CMD_ENABLED, GREEN_FONT_COLOR_CODE .. SSWSG_ON .. FONT_COLOR_CODE_CLOSE ) );
		
		SSWSG_UpdateCarriers();		
	elseif( command == "off" ) then
		SSWSG_Config.enabled = false;
		SSLibrary_Message( string.format( SSWSG_CMD_ENABLED, RED_FONT_COLOR_CODE .. SSWSG_OFF .. FONT_COLOR_CODE_CLOSE ) );
		
		SSWorldFlag:Hide();
	elseif( command == "name" and optionState ) then
		SSWSG_Config.names = optionValue;
		SSLibrary_Message( string.format( SSWSG_CMD_FLAGNAME, optionState ) );
		
		SSWSG_UpdateCarriers();
	
	elseif( command == "color" and optionState ) then
		SSWSG_Config.colors = optionValue;
		SSLibrary_Message( string.format( SSWSG_CMD_CLASSCOLOR, optionState ) );
		
		SSWSG_UpdateCarriers();
	
	elseif( command == "fhealth" and optionState ) then
		SSWSG_Config.fhealth = optionValue;
		SSLibrary_Message( string.format( SSWSG_CMD_FRIENDLYHEALTH, optionState ) );
		
		SSWSG_UpdateCarriers();
		
	elseif( command == "flagtimer" and optionState ) then
		SSWSG_Config.flagtimer = optionValue;
		SSLibrary_Message( string.format( SSWSG_CMD_FLAGTIMER, optionState ) );
		
	elseif( command == "class" and optionState ) then
		SSWSG_Config.cname = optionValue;
		SSLibrary_Message( string.format( SSWSG_CMD_CLASSNAME, optionState ) );
		
		SSWSG_UpdateCarriers();

	elseif( command == "status" ) then
		
		local statusList = {	{ SSWSG_Config.enabled, SSWSG_CMD_ENABLED }, { SSWSG_Config.names, SSWSG_CMD_FLAGNAME },
					{ SSWSG_Config.colors, SSWSG_CMD_CLASSCOLOR }, { SSWSG_Config.cname, SSWSG_CMD_CLASSNAME } };
		
		for _, data in pairs( statusList ) do
			local status = RED_FONT_COLOR_CODE .. SSWSG_OFF .. FONT_COLOR_CODE_CLOSE;
			if( data[1] ) then
				status = GREEN_FONT_COLOR_CODE .. SSWSG_ON .. FONT_COLOR_CODE_CLOSE;
			end
			
			SSLibrary_Message( string.format( data[2], status ) );
		end
		
	else
		for _, help in pairs( SSWSG_HELP ) do
			SSLibrary_Message( help, ChatTypeInfo["SYSTEM"] );
		end
	end
end

-- Find the friendly carrier using buffs
function SSWSG_GetFriendlyCarrier()
	for i=1, GetNumRaidMembers() do
		local index = 1;
		while( UnitBuff( "raid" .. i, index ) ) do
			local texture = UnitBuff( "raid" .. i, index );
			if( texture == "Interface\\Icons\\INV_BannerPVP_01" or texture == "Interface\\Icons\\INV_BannerPVP_02" ) then
				return UnitName( "raid" .. i );
			end
			
			index = index + 1;
		end
	end
	
	return nil;
end

-- Update the bindings for targetting
function SSWSG_UpdateFlagBindings()
	local bindKey = GetBindingKey( "SSETARFLAG" );
	if( bindKey ) then
		SetOverrideBindingClick( getglobal( "SSWorldFlag" .. PlayerFaction ), false, bindKey, "SSWorldFlag" .. PlayerFaction );
	end
	
	bindKey = GetBindingKey( "SSFTARFLAG" );
	if( bindKey ) then
		SetOverrideBindingClick( getglobal( "SSWorldFlag" .. EnemyFaction ), false, bindKey, "SSWorldFlag" .. EnemyFaction );
	end
end

function SSWSG_SendChatMessage( text, type, language, targetPlayer )
	
	if( SSLibrary_PlayerInBG() and text ) then
		if( string.find( text, "$efc" ) ) then
			if( carrierNames[ PlayerFaction ] and carrierNames[ PlayerFaction ] ~= "" ) then
				text = string.gsub( text, "$efc", ( carrierNames[ PlayerFaction ] or "" ) );
			else
				text = string.gsub( text, "$efc", SSWSG_NOENEMYCARRIER );
			end
		end

		if( string.find( text, "$ffc" ) ) then
			if( carrierNames[ EnemyFaction ] and carrierNames[ EnemyFaction ] ~= "" ) then
				text = string.gsub( text, "$ffc", ( carrierNames[ EnemyFaction ] or "" ) );
			else
				text = string.gsub( text, "$ffc", SSWSG_NOFRIENDLYCARRIER );
			end
		end
	end
	
	return Orig_SendChatMessage( text, type, language, targetPlayer );
end

-- Checks the map every 30 seconds for the carrier
function SSWSG_CheckFriendlyCarrier()
	if( GetNumRaidMembers() > 0 and not SkipNextCheck ) then
		if( EnemyFaction and carrierNames[ EnemyFaction ] == nil or carrierNames[ EnemyFaction ] == "" ) then
			carrierNames[ EnemyFaction ] = SSWSG_GetFriendlyCarrier();	
			SSWSG_UpdateCarrierInfo( EnemyFaction );
		end
	end

	SkipNextCheck = false;
	SSLibrary_ScheduleEvent( "SSWSG_CheckFriendlyCarrier", 30 );	
end

-- Update the carriers info
function SSWSG_UpdateCarrierInfo( faction )
	if( not SSWSG_Config.names or not SSLibrary_IsInWSG() ) then
		SSWSG_ClearCarriers();
		return;
	end
	
	local unlocalizedClass, localizedClass, abbrevedClass
	local carrierName = ( carrierNames[ faction ] or "" );
	local text = getglobal( "SSWorldFlag" .. faction .. "Text" );
	
	local defaultR, defaultG, defaultB = GameFontNormal:GetTextColor();
	
	-- No name found, reset color/text and hide
	if( carrierName == "" ) then
		text:SetText( "" );
		text:SetTextColor( defaultR, defaultG, defaultB ); 
		text:Hide();
		return;
	end
	
	if( EnemyFaction == faction and ( not FriendlyCarrierID or UnitName( FriendlyCarrierID ) ~= carrierName ) ) then
		FriendlyCarrierID = SSWSG_GetUnitID( carrierName );
	end
	
	-- Find player class
	for id, player in pairs( BGPlayerData ) do
		if( player.name == carrierName ) then
			unlocalizedClass, abbrevedClass = SSLibrary_GetUnLocalizedClass( player.class );
			localizedClass = player.class;
		end
	end
	
	-- Append friendly carrier health
	if( SSWSG_Config.fhealth and faction == EnemyFaction ) then
		if( UnitExists( FriendlyCarrierID ) and UnitHealthMax( FriendlyCarrierID ) > 1 ) then
			local health = floor( UnitHealth( FriendlyCarrierID ) / UnitHealthMax( FriendlyCarrierID ) * 100 + 0.5 );
			carrierName = carrierName .. " [" .. health .. "%]";
		end
	end

	-- Append class name
	if( localizedClass and SSWSG_Config.cname ) then
		carrierName = carrierName .. " [" .. localizedClass .. "]";
	elseif( abbrevedClass and SSWSG_Config.cabbrev ) then
		carrierName = carrierName .. " [" .. abbrevedClass .. "]";
	end

	-- Set carrier color
	if( unlocalizedClass and SSWSG_Config.colors ) then
		text:SetTextColor( RAID_CLASS_COLORS[ unlocalizedClass ].r, RAID_CLASS_COLORS[ unlocalizedClass ].g, RAID_CLASS_COLORS[ unlocalizedClass ].b );
	else
		text:SetTextColor( defaultR, defaultG, defaultB ); 
	end
	
	text:SetText( carrierName );
	
	-- And show it all
	text:Show();

	-- temp
	SSWorldFlag:Show();
	
	if( faction == "Horde" ) then
		id = 1;
	elseif( faction == "Alliance" ) then
		id = 2;
	end
	
	getglobal( "SSWorldFlag" .. faction ):SetAttribute( "type", "macro" );
	if( not carrierNames[ faction ] or carrierNames[ name ] == "" ) then
		getglobal( "SSWorldFlag" .. faction ):SetAttribute( "macrotext", "" );		
	else
		getglobal( "SSWorldFlag" .. faction ):SetAttribute( "macrotext", "/target " .. carrierNames[ faction ] );
	end
	
	getglobal( "SSWorldFlag" .. faction ):Show();
	getglobal( "SSWorldFlag" .. faction ):SetPoint( "LEFT", "AlwaysUpFrame" .. id, "LEFT", 90, 12 );
	
	if( InCombatLockdown() ) then
		UpdateWhenOOC = true;
	end
end

-- Update both carrier info
function SSWSG_UpdateCarriers()
	SSWSG_UpdateCarrierInfo( "Alliance" );
	SSWSG_UpdateCarrierInfo( "Horde" );
end

function SSWSG_ClearCarriers()
	carrierNames = {};
	
	SSWorldFlag:Hide();
	
	SSWorldFlagAlliance:Hide();
	SSWorldFlagHorde:Hide();
	
	SSWorldFlagAllianceText:SetText( "" );
	SSWorldFlagHordeText:SetText( "" );
	
	SSWorldFlagAlliance:SetAttribute( "macrotext", "" );
	SSWorldFlagHorde:SetAttribute( "macrotext", "" );
end


function SSWSG_GetUnitID( name )
	name = string.lower( ( name or "" ) );
	
	for i=1, GetNumRaidMembers() do
		if( string.lower( UnitName( "raid" .. i ) ) == name ) then
			return "raid" .. i;
		end
	end
	
	return nil;
end

function SSWSG_FlagAppearance( timeLeft )
	SSLibrary_PVPMessage( string.format( SSWSG_FLAGAPPEARANCE, timeLeft ), "Neutral" );
end


function SSWSG_OnEvent( event, ... )
	
	if( event == "ADDON_LOADED" and arg1 == "SSWSG" ) then
		if( SSWSG_Config == nil ) then
			SSWSG_Config = SSWSG_GetDefaultConfig( nil, true );
		end
				
		-- Now the send chat message function
		Orig_SendChatMessage = SendChatMessage;
		SendChatMessage = SSWSG_SendChatMessage;
		
		-- Load some other things to keep everyone happy
		if( SSLibrary_IsInWSG() ) then
			SSWSG_OnEvent( "BATTLEFIELD_INFO_UPDATED" );
		end
	
		PlayerFaction = UnitFactionGroup( "player" );
		if( PlayerFaction == "Alliance" ) then
			EnemyFaction = "Horde";
		elseif( PlayerFaction == "Horde" ) then
			EnemyFaction = "Alliance";
		end
		
		SSWSG_UpdateFlagBindings();
	
	-- raidXX will change sometimes, so we have to update it here to make sure it's current
	elseif( event == "RAID_ROSTER_UPDATE" and SSLibrary_PlayerInBG() and carrierNames[ EnemyFaction ] ) then
		
		if( not FriendlyCarrierID or UnitName( FriendlyCarrierID ) ~= carrierNames[ EnemyFaction ] ) then
			FriendlyCarrierID = SSWSG_GetUnitID( carrierName );
		end
		
	elseif( event == "UPDATE_BINDINGS" ) then
		SSWSG_UpdateFlagBindings();

	elseif( event == "PLAYER_REGEN_ENABLED" and UpdateWhenOOC ) then
		SSWSG_UpdateCarrierInfo( "Horde" );
		SSWSG_UpdateCarrierInfo( "Alliance" );
	
	-- Time to update the carriers health
	elseif( event == "UNIT_HEALTH" and SSWSG_Config.fhealth and FriendlyCarrierID == arg1 ) then
		SSWSG_UpdateCarrierInfo( EnemyFaction );
	
	-- We just joined the battlefield, check if somebody has the flag in 5 seconds
	elseif( event == "BATTLEFIELD_INFO_UPDATED" ) then
		SSWSG_ClearCarriers();
		
		RequestBattlefieldScoreData();
		
		SSLibrary_RequestCarrierData();
		SSLibrary_ScheduleEvent( "SSWSG_CheckFriendlyCarrier", 5 );
		SSLibrary_UnScheduleEvent( "SSWSG_FlagAppearance" );		
		
	-- Battlegrounds over or we left early, clear and hide the carriers
	elseif( event == "BATTLEFIELD_WON" or event == "LEFT_BATTLEFIELD" ) then
		SSWSG_ClearCarriers();
		SSLibrary_UnScheduleEvent( "SSWSG_CheckFriendlyCarrier" );
		SSLibrary_UnScheduleEvent( "SSWSG_FlagAppearance" );
		
	-- Scores updated, possibly with carrier class, update info
	elseif( event == "BATTLEFIELD_SCORES_UPDATED" and SSWSG_Config.enabled ) then
		BGPlayerData = select( 1, ... );
		
		SSWSG_UpdateCarriers();
		
	-- Flag status updated, update carriers and the UI
	elseif( ( event == "WSG_CARRIER_LOADED" or event == "WSG_FLAG_PICKEDUP" ) and SSWSG_Config.enabled ) then
		FriendlyCarrierID = SSWSG_GetUnitID( select( 1, ... ) );
		carrierNames[ select( 2, ... ) ] = select( 1, ... );
		
		SSWSG_UpdateCarrierInfo( select( 2, ... ) );

	elseif( ( event == "WSG_FLAG_DROPPED" or event == "WSG_FLAG_CAPTURED" ) and SSWSG_Config.enabled ) then
		FriendlyCarrierID = nil;
		SkipNextCheck = true;
		carrierNames[ select( 2, ... ) ] = "";
		
		SSWSG_UpdateCarriers();
		
		if( event == "WSG_FLAG_CAPTURED" and SSWSG_Config.flagtimer ) then
			SSLibrary_ScheduleEvent( "SSWSG_FlagAppearance", 10, 10 );
			SSLibrary_ScheduleEvent( "SSWSG_FlagAppearance", 15, 5 );
		end
	end
end