--[[
	SSLoader By Shadowd of Icecrown PvE (US)
	Original Release: July 17th, 2006.
]]

local currentBG = -1;
local currentBGName = "";

function SSLoader_OnLoad()
	this:RegisterEvent( "VARIABLES_LOADED" );
	this:RegisterEvent( "UPDATE_BATTLEFIELD_STATUS" );
	this:RegisterEvent( "CHAT_MSG_ADDON" );
end 

function SSLoader_ScanAddOns()
	for index=1, GetNumAddOns() do
		local name = GetAddOnInfo( index );
		local LoadAddOn = false;
	
		for _, dep in pairs( { GetAddOnDependencies( index ) } ) do
			if( string.lower( dep ) == "ssloader" ) then
				LoadAddOn = true;
			end
		end
		
		if( LoadAddOn and SSLoader_AddOnEnabled( name ) and not SSLoader_AddOns[ name ] ) then
			UIParentLoadAddOn( name );
		end
	end
end

function SSLoader_GetAddOnUIList()
	local list = {};
	for name, addon in pairs( SSLoader_AddOns ) do
		if( addon.UI and SSLoader_AddOnEnabled( name ) ) then
			table.insert( list, { name, addon.UI } );
		end
	end
	
	return list;
end


function SSLoader_Message( msg, color )
	if( color == nil ) then
		color = { r = 1, g = 1, b = 1 };
	end
	
	DEFAULT_CHAT_FRAME:AddMessage( msg, color.r, color.g, color.b );
end

function SSLoader_RegisterAddOn( addonName, addonInfo )
	if( SSLoader_AddOns == nil ) then
		SSLoader_AddOns = {};
	end
	
	SSLoader_AddOns[ addonName ] = ( addonInfo or {} );
	SSLoader_AddOns[ addonName ]["cmd"] = {};
	SSLoader_AddOns[ addonName ]["cmdSlashes"] = {};
end

function SSLoader_RegisterSlash( addonName, cmdFunc, commands, name, registerOnly )
	for i=1, #( commands ) do
		setglobal( "SLASH_" .. name .. i, commands[i] );
	end
	
	SlashCmdList[ name ] = function( msg ) SSLoader_SlashCommand( addonName, name, msg ) end
	
	if( not registerOnly ) then
		SSLoader_AddOns[ addonName ]["cmdSlashes"][ name ] = commands;
		SSLoader_AddOns[ addonName ]["cmd"][ name ] = cmdFunc;
	end
end

function SSLoader_SlashCommand( addonName, command, msg )
	local addon = SSLoader_AddOns[ addonName ];
	
	-- Make sure it exists and that we can call it.
	if( not addon ) then
		return;
	
	-- Is the addon disabled at the character select screen
	elseif( not SSLoader_AddOnEnabled( addonName ) ) then
		SSLoader_Message( string.format( SSL_ADDONDISABLED, addonName ), ChatTypeInfo["SYSTEM"] );
		return;
	
	-- Does the command even exist
	elseif( not addon["cmd"][ command ] ) then
		SSLoader_Message( string.format( SSL_ADDONNOCMD, command, addonName ), ChatTypeInfo["SYSTEM"] );
		return;
	end
		
	-- Load it	
	UIParentLoadAddOn( addonName );
	
	if( IsAddOnLoaded( addonName ) ) then
		getglobal( addon["cmd"][ command ] )( msg );
	else
		-- Failed to load, display error message
		SSLoader_Message( string.format( SSL_ADDONFAILEDLOAD, addonName ), ChatTypeInfo["SYSTEM"] );
	end
end

function SSLoader_AddOnEnabled( addon )
	local _, _, _, _, _, reason = GetAddOnInfo( addon );
	
	if( reason == "DISABLED" or reason == "MISSING" ) then
		return nil;
	end
	
	return true;
end

-- Where all the magic goes on
function SSLoader_OnEvent( event )
	if( event == "VARIABLES_LOADED" ) then
		if( SSLoader_AddOns == nil ) then
			SSLoader_AddOns = {};
		end
		
		-- Scan for new addons
		SSLoader_ScanAddOns();
		
		-- Register slash commands
		for addonName, addon in pairs( SSLoader_AddOns ) do
			if( addon.cmd ) then
				for cmdName, cmd in pairs( addon.cmd ) do
					if( addon["cmdSlashes"] and addon["cmdSlashes"][ cmdName ] ) then
						SSLoader_RegisterSlash( addonName, cmdFunc, addon["cmdSlashes"][ cmdName ], cmdName, true );
					end
				end
			end
		end	
	
	elseif( event == "CHAT_MSG_ADDON" ) then		
		for name, addon in pairs( SSLoader_AddOns ) do
			if( addon.loadOnMsg and SSLoader_AddOnEnabled( name ) and addon.onLoad and not IsAddOnLoaded( name ) ) then
				if( addon.loadOnMsg == arg1 ) then
					UIParentLoadAddOn( name );
					
					if( IsAddOnLoaded( name ) ) then
						getglobal( addon.onLoad )();
						getglobal( addon.onEvent )( event );
					end
				end
			end
		end
	
	elseif( event == "UPDATE_BATTLEFIELD_STATUS" ) then
		for i = 1, MAX_BATTLEFIELD_QUEUES do
			local status, map, id = GetBattlefieldStatus( i );
			
			if( status == "active" and i ~= currentBG ) then
				currentBG = i;
				currentBGName = map;
				
				-- Check if any addons need to be loaded inside a battleground
				for name, addon in pairs( SSLoader_AddOns ) do
					if( addon.loadInBG and SSLoader_AddOnEnabled( name ) and addon.onLoad ) then
						for _, bgName in pairs( addon.loadInBG ) do
							if( bgName == currentBGName ) then
								UIParentLoadAddOn( name );

								if( IsAddOnLoaded( name ) ) then
									getglobal( addon.onLoad )();
								end
							end
						end
					end
				end

			elseif( ( status == "queued" or status == "none" ) and i == currentBG ) then
				currentBG = -1;
				currentBGName = "";
				
				-- Check if any addons need to be loaded when leaving a battleground
				for name, addon in pairs( SSLoader_AddOns ) do
					if( not IsAddOnLoaded( name ) and SSLoader_AddOnEnabled( name ) and addon.onBGLeave ) then
						UIParentLoadAddOn( name );
						if( IsAddOnLoaded( name ) ) then
							getglobal( addon.onBGLeave )();
						end
					end
				end
			end
		end	
		
		-- Any battlegrounds need to be loaded on a battlefield status?
		for name, addon in pairs( SSLoader_AddOns ) do
			if( not IsAddOnLoaded( name ) and SSLoader_AddOnEnabled( name ) and addon.onBFStatus ) then
				UIParentLoadAddOn( name );
				if( IsAddOnLoaded( name ) ) then
					getglobal( addon.onBFStatus )();
				end
			end
		end
			
	end
end