--[[ 
	SSAutoTurnIn By Shadowd of Icecrown (PVE)
	Original Release: August 15th (2006)
]]

local AutoAcceptList = {};
local Orig_GossipClicks = {};

function SSTurn_OnLoad()
	this:RegisterEvent( "ADDON_LOADED" );
	this:RegisterEvent( "GOSSIP_SHOW" );
	this:RegisterEvent( "QUEST_COMPLETE" );
	this:RegisterEvent( "QUEST_PROGRESS" );
	
	SLASH_SSTURN1 = "/ssturn";
	SlashCmdList["SSTURN"] = SSTurn_SlashHandler;
end 

function SSAutoTurnIn_LoadUI()
	SSTurn_UpdateQuestList();
	
	SSUI_RegisterVarType( "ssturn", "SSTurn_SetVariable", "SSTurn_GetVariable" );

	SSUI_AddTab( SST_UI_TAB, "SSTurnConfig" );
	SSUI_AddFrame( "SSTurnConfig", "sspvp" );

	-- Add the elements
	local UIList = {
		{ name = "SSTurnEnable", text = SST_UI_ENABLE, type = "check", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "ssturn", var = { "enabled" }, parent = "SSTurnConfig" }
	};
	
	for id, quest in pairs( SST_QUESTTYPE ) do
		table.insert( UIList, { name = "SSTurn" .. quest.cat, text = string.format( SST_UI_CAT_STATUS, quest.text ), onClick = "SSTurn_UpdateQuestList", type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssturn", var = { "disabled", quest.cat }, parent = "SSTurnConfig" } );
	end
	
	for _, element in pairs( UIList ) do
		SSUI_AddElement( element );
	end
end

-- Variable management
function SSTurn_GetDefaultConfig( var, fullConfig )
	Config = {};
	Config.enabled = false;
	Config.quests = {};
	Config.disabled = {};
	
	if( fullConfig ) then
		return Config;
	elseif( var ) then
		return Config[ var ];
	end
	
	return nil;
end

function SSTurn_GetVariable( vars )
	if( SSTurn_Config[ vars[1] ] == nil ) then
		SSTurn_Config[ vars[1] ] = SSTurn_GetDefaultConfig( vars[1] );
	end
	
	if( vars[1] and vars[2] ) then
		return SSTurn_Config[ vars[1] ][ vars[2] ];
	end
	
	return SSTurn_Config[ vars[1] ];
end

function SSTurn_SetVariable( vars, value )
	if( vars[1] and vars[2] ) then
		SSTurn_Config[ vars[1] ][ vars[2] ] = value;	
	else
		SSTurn_Config[ vars[1] ] = value;
	end
end

function SSTurn_Message( msg, color )
	if( color == nil ) then
		color = { r = 1, g = 1, b = 1 };
	end
	
	DEFAULT_CHAT_FRAME:AddMessage( msg, color.r, color.g, color.b );
end

function SSTurn_SlashHandler( msg )
	local command, commandArg, optionState, optionValue;
	
	if( msg ~= nil ) then
		command = string.gsub( msg, "(.+) (.+)", "%1" );
		commandArg = string.gsub( msg, "(.+) (.+)", "%2" );
		command = ( command or msg );
	end
	
	if( commandArg == "on" ) then
		optionState = GREEN_FONT_COLOR_CODE .. SST_ON .. FONT_COLOR_CODE_CLOSE;
		optionValue = true;
	elseif( commandArg == "off" ) then
		optionState = RED_FONT_COLOR_CODE .. SST_OFF .. FONT_COLOR_CODE_CLOSE;
		optionValue = false;
	end
	
	-- Check if we're changing the status of a quest type
	for _, quest in pairs( SST_QUESTTYPE ) do
		if( quest.cat == command ) then
			if( not optionValue ) then
				status = RED_FONT_COLOR_CODE .. SST_OFF .. FONT_COLOR_CODE_CLOSE;
				optionValue = true;
			else
				status = GREEN_FONT_COLOR_CODE .. SST_ON .. FONT_COLOR_CODE_CLOSE;
				optionValue = nil;
			end
			
			SSTurn_Config.disabled[ quest.cat ] = optionValue;
			SSTurn_UpdateQuestList();
			
			SSTurn_Message( string.format( SST_CAT_ENABLED, quest.text, status ) );
			return;
		end
	end
	
	if( command == "on" ) then
		SSTurn_Config.enabled = true;
		SSTurn_Message( string.format( SST_CMD_ENABLED, GREEN_FONT_COLOR_CODE .. SST_ON .. FONT_COLOR_CODE_CLOSE ) );
	elseif( command == "off" ) then
		SSTurn_Config.enabled = false;
		SSTurn_Message( string.format( SST_CMD_ENABLED, RED_FONT_COLOR_CODE .. SST_OFF .. FONT_COLOR_CODE_CLOSE ) );
		
	elseif( command == "status" ) then
		
		local statusList = {	{ SSTurn_Config.enabled, SST_CMD_ENABLED } };
		
		
		for _, quest in pairs( SST_QUESTTYPE ) do
			local text = string.format( SST_CAT_ENABLED, quest.text, "%s" );
			local status = nil;
			if( not SSTurn_Config.disabled[ quest.cat ] ) then
				status = true;
			end
			
			table.insert( statusList, { status, text } ); 
		end
		
		for _, data in pairs( statusList ) do
			local status = RED_FONT_COLOR_CODE .. SST_OFF .. FONT_COLOR_CODE_CLOSE;
			if( data[1] ) then
				status = GREEN_FONT_COLOR_CODE .. SST_ON .. FONT_COLOR_CODE_CLOSE;
			end
			
			SSTurn_Message( string.format( data[2], status ) );
		end
		
	else
		for _, help in pairs( SST_HELP ) do
			SSTurn_Message( help, ChatTypeInfo["SYSTEM"] );
		end
		
		for _, quest in pairs( SST_QUESTTYPE ) do
			SSTurn_Message( string.format( SST_HELP_CAT, quest.cat, quest.text ), ChatTypeInfo["SYSTEM"] );
		end
	end
end

function SSTurn_IsAutoQuest( name )
	name = string.lower( ( name or "" ) );
	
	-- Scan the default quests
	for id, quest in pairs( AutoAcceptList ) do
		quest.name = string.lower( quest.name );
		
		-- Make sure it's not disabled
		if( string.find( name, quest.name ) ) then
			if( quest.item and quest.quantity ) then
				local required = #( quest.item );
				local found = 0;
				for id, item in pairs( quest.item ) do
					if( GetItemCount( item ) >= quest.quantity[ id ] ) then
						found = found + 1;
					end
				end
				
				if( required == found ) then
					return true;
				end
			else
				return true;
			end
		end
	end
	
	return nil;
end

function SSTurn_UpdateQuestList()
	AutoAcceptList = SSTurn_MergeTable( SST_QUESTLIST, SSTurn_Config.quests );

	for id, quest in pairs( AutoAcceptList ) do
		if( SSTurn_Config.disabled[ quest.type ] ) then
			AutoAcceptList[id] = nil;
		end
	end
end


function SSTurn_MergeTable( a, b )
	local newTable = {};
	
	for id, row in pairs( a ) do
		table.insert( newTable, row );
	end
	
	for id, row in pairs( b ) do 
		table.insert( newTable, row );
	end
	
	return newTable;
end

function SSTurn_IsHighestRequired( name )
	name = string.lower( ( name or "" ) );
	local highest = {};
	
	-- Scan the quest we added
	for id, quest in pairs( AutoAcceptList ) do
		quest.name = string.lower( quest.name );
		
		if( string.find( name, quest.name ) ) then
			if( quest.item ) then
				for id, item in pairs( quest.item ) do
					highest[ item ] = quest.quantity[ id ];				
				end
			else
				-- Quest doesn't require anything, so it's the "highest"
				return true;
			end
		end
	end

	for id, quest in pairs( AutoAcceptList ) do
		quest.name = string.lower( quest.name );
		-- make sure we aren't checking what we just added
		if( not string.find( name, quest.name ) and quest.item and quest.quantity ) then
			local required = #( quest.item );
			local found = 0;
			
			for id, item in pairs( quest.item ) do
				if( highest[ item ] and ( quest.quantity[ id ] > highest[ item ] ) and GetItemCount( item ) >= quest.quantity[ id ] ) then
					found = found + 1;
				end
			end
			
			if( found == required ) then
				return false;
			end
		end
	end
	
	return true;
end

function SSTurn_AddToAccept()
	if( IsAltKeyDown() ) then
		local skipText = this:GetText();

		for i=#( SSTurn_Config.quests ), 1, -1 do
			if( string.lower( SSTurn_Config.quests[i].name ) == string.lower( skipText ) ) then
				table.remove( SSTurn_Config.quests, i );

				SSTurn_UpdateQuestList();
				SSTurn_Message( SST_REMOVED_SKIP, ChatTypeInfo["SYSTEM"] );
				return;
			end
		end
		
		table.insert( SSTurn_Config.quests, { name = skipText, type = "manual", checkItems = true } );

		SSTurn_UpdateQuestList();
		SSTurn_Message( SST_ADDED_SKIP, ChatTypeInfo["SYSTEM"] );
		return;
	end
	
	if( Orig_GossipClicks[ this:GetName() ] ) then
		Orig_GossipClicks[ this:GetName() ]();
	end
end

function SSTurn_OnEvent( event )
	
	if( event == "ADDON_LOADED" and arg1 == "SSAutoTurnIn" ) then
		if( SSTurn_Config == nil ) then
			SSTurn_Config = SSTurn_GetDefaultConfig( nil, true );
		end
		
		SSTurn_UpdateQuestList();
		
	elseif( event == "QUEST_PROGRESS" and SSTurn_Config.enabled ) then
		-- Check if we need to log the items from this
		if( GetNumQuestItems() > 0 ) then
			for id, quest in pairs( SSTurn_Config.quests ) do
				-- Do we have a quest that needs the items added?
				if( string.lower( quest.name ) == string.lower( GetTitleText() ) and quest.checkItems ) then
					if( not quest.item ) then
						quest.item = {};
					end
					if( not quest.quantity ) then
						quest.quantity = {};
					end
					
					for i=1, GetNumQuestItems() do
						local itemName, _, required = GetQuestItemInfo( "required", i );
						local itemLink = GetQuestItemLink( "required", i );
						
						-- Do we have required items?
						if( itemLink and itemName ) then
							local _, _, _, itemid = string.find( itemLink, "|c(.+)|Hitem:([0-9]+):(.+)|h%[(.+)%]|h|r" );
							itemid = tonumber( itemid );
							
							-- Did we find the item id?
							if( itemid and itemid > 0 ) then
								table.insert( quest.item, itemid );
								table.insert( quest.quantity, required or 1 );
							end
						end
					end

					-- If the itemid and quantities match up then add it, else reset it
					if( #( quest.item ) == #( quest.quantity ) ) then
						quest.checkItems = nil;
					else
						quest.item = nil;
						quest.quantity = nil;
						quest.checkItems = true;
					end
					
					SSTurn_Config.quests[ id ] = quest;
					SSTurn_UpdateQuestList();
				end
			end
		end

		if( SSTurn_IsAutoQuest( GetTitleText() ) and IsQuestCompletable() ) then
			QuestFrameCompleteButton:Click();
		end

	elseif( event == "QUEST_COMPLETE" and SSTurn_Config.enabled ) then
		if( SSTurn_IsAutoQuest( GetTitleText() ) and IsQuestCompletable() ) then
			QuestFrameCompleteQuestButton:Click();
		end
		
	elseif( event == "GOSSIP_SHOW" and SSTurn_Config.enabled and GossipFrame.buttonIndex > 0 ) then
		for i=1, GossipFrame.buttonIndex do
			local button = getglobal( "GossipTitleButton" .. i );
			
			if( button and not button.hookedOnClick ) then
				Orig_GossipClicks[ button:GetName() ] = button:GetScript( "OnClick" );
				
				button:SetScript( "OnClick", SSTurn_AddToAccept );
				button.hookedOnClick = true;
			end
			
			-- Disable auto turn in if shift key is down
			if( button and button:GetText() and not IsShiftKeyDown() ) then
				if( SSTurn_IsHighestRequired( button:GetText() ) and SSTurn_IsAutoQuest( button:GetText() ) ) then
					button:Click();
				end
			end
		end
	end
end