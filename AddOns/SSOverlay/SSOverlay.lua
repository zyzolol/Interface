--[[ 
	SSOverlay By Shadowd of Icecrown (PVE)
	Original Release: No Damn Idea
]]

local Categories = {};

local MAXIMUM_ROWS = 20;
local CREATED_ROWS = 0;

local timeElapsed = 0;

local AutoHideCatText = true;

local ActiveTimers = {};
local ActiveTimerCount = { total = 0, item = 0, down = 0, up = 0, text = 0 };

local SortingPriorities = { text = 1, down = 2, up = 3, item = 4 };

function SSOverlay_OnLoad()
	this:RegisterEvent( "ADDON_LOADED" );
	this:RegisterEvent( "BAG_UPDATE" );
end

function SSOverlay_OnEvent( event )
	if( event == "ADDON_LOADED" and arg1 == "SSOverlay" ) then
		if( SSOverlay_Config == nil ) then
			SSOverlay_Config = SSOverlay_GetDefaultConfig( nil, true );
		end
		
		if( SSOverlay_Config.position ) then
			SSOverlay:ClearAllPoints();
			SSOverlay:SetPoint( "TOPLEFT", "UIParent", "BOTTOMLEFT", SSOverlay_Config.position.x, SSOverlay_Config.position.y );
			SSOverlay:SetUserPlaced( true );
		else
			SSOverlay:SetPoint( "TOPLEFT", "UIParent", "TOPLEFT", 200, -100 );
		end
		
	elseif( event == "BAG_UPDATE" and ActiveTimerCount.item > 0 ) then
		for id, row in pairs( ActiveTimers ) do
			if( row.type == "item" ) then
				row.count = GetItemCount( row.item );
				ActiveTimers[ id ] = row;	

				SSOverlay_UpdateOverlay();
			end
		end
	end
end

-- Stopped moving the overlay, update the position
function SSOverlay_SavePosition()
	if( SSOverlay:IsUserPlaced() ) then
		if( not SSOverlay_Config.position ) then
			SSOverlay_Config.position = {};
		end
		
		SSOverlay_Config.position.x, SSOverlay_Config.position.y = SSOverlay:GetLeft(), SSOverlay:GetTop();
		SSOverlay:SetUserPlaced( true );
	else
		SSOverlay_Config.position = nil;		
	end
end

function SSOverlay_UpdateOverlayColors()
	-- Set background and border color
	SSOverlay:SetBackdropColor( SSOverlay_Config.color.r, SSOverlay_Config.color.g, SSOverlay_Config.color.b, SSOverlay_Config.opacity );
	SSOverlay:SetBackdropBorderColor( SSOverlay_Config.border.r, SSOverlay_Config.border.g, SSOverlay_Config.border.b, SSOverlay_Config.opacity );
	
	-- Set text color
	for i=1, CREATED_ROWS do
		local row = getglobal( "SSOverlayRow" .. i .. "Text" );
		if( row ) then
			local timer = ActiveTimers[ i ];
			
			if( timer and timer.color ) then
				row:SetTextColor( timer.color.r, timer.color.g, timer.color.b, SSOverlay_Config.textOpacity );
			elseif( timer and timer.catText and SSOverlay_Config.catText ) then
				row:SetTextColor( SSOverlay_Config.catText.r, SSOverlay_Config.catText.g, SSOverlay_Config.catText.b, SSOverlay_Config.textOpacity );
			else
				row:SetTextColor( SSOverlay_Config.text.r, SSOverlay_Config.text.g, SSOverlay_Config.text.b, SSOverlay_Config.textOpacity );
			end
		end
	end
end

function SSOverlay_CreateOverlayRow()
	if( CREATED_ROWS >= MAXIMUM_ROWS ) then
		return;
	end
	
	CREATED_ROWS = CREATED_ROWS + 1;
	
	local parent = "SSOverlayRow" .. ( CREATED_ROWS - 1 );
	if( CREATED_ROWS == 1 ) then
		parent = "SSOverlay";
	end

	local row = CreateFrame( "Frame", "SSOverlayRow" .. CREATED_ROWS, getglobal( parent ), "SSOverlayRow" );

	if( CREATED_ROWS == 1 ) then
		row:SetPoint( "TOPLEFT", parent, "TOPLEFT", 5, -5 );
	else
		row:SetPoint( "TOPLEFT", parent, "TOPLEFT", 0, -12 );
	end
		
	return row;
end

function SSOverlay_ColorMatches( a, b )
	if( not a or not b ) then
		return nil;
	end
	
	if( a.r == b.r and a.g == b.g and a.b == b.b ) then
		return true;
	end
	
	return nil;
end

-- Clean later
function SSOverlay_GetRows( search )
	local reqCount = 0;
	if( search.text ) then
		reqCount = reqCount + 1;
	end
	
	if( search.cat ) then
		reqCount = reqCount + 1;
	end
	
	if( search.color ) then
		reqCount = reqCount + 1;
	end
	
	if( search.type and search.matchType ) then
		reqCount = reqCount + 1;
	end
	
	local results = {};
	
	for i=#( ActiveTimers ), 1, -1 do
		local row = ActiveTimers[i];
		
		local found = 0;
		if( search.looseMatch and row.text and search.text and string.find( string.lower( row.text ), string.lower( search.text ) ) ) then
			found = found + 1;
		elseif( not search.looseMatch and row.text and search.text and string.lower( row.text ) == string.lower( search.text ) ) then
			found = found + 1;
		end
		
		if( not search.ignoreColor and search.color and row.color and SSOverlay_ColorMatches( row.color, search.color ) ) then
			found = found + 1;
		end
		
		if( row.cat and search.cat and row.cat == search.cat ) then
			found = found + 1;
		end
		
		if( search.matchType and search.type == row.type ) then
			found = found + 1;
		end
		
		
		if( found >= reqCount ) then
			row.rowID = i;
			table.insert( results, row );
		end
	end
	
	return results;
end

function SSOverlay_GetRow( search )
	local rows = SSOverlay_GetRows( search );
	
	if( rows[1] ) then
		return rows[1], rows[1].rowID;
	end
	
	return {}, 0;
end

-- Hack code, need to cleanup soon
function SSOverlay_AddAsFirstCategory( name, data )
	SSOverlay_AddCategory( name, data );
end

function SSOverlay_AddCategory( name, data )
	-- Nothing like spending 2 hours to find out a problem
	-- and realising I forgot to update a single line of code
	for _, category in pairs( Categories ) do
		if( category.name == name ) then
			return;
		end
	end
	
	if( not data or ( data and not data.id ) ) then
		id = 0;
	else
		id = data.id;
	end

	data.id = nil;
	table.insert( Categories, { name = name, pos = 0, id = id, data = data } );

	SSOverlay_SortCategories();
	SSOverlay_SortOverlay();
end

function SSOverlay_SortCategories()
	table.sort( Categories, function( a, b )
		if( not a ) then
			return true;
		end
		
		if( not b ) then
			return false;
		end
		
		if( a.id and b.id ) then
			return ( a.id > b.id );
		elseif( a.id and not b.id ) then
			return true;
		elseif( b.id and not a.id ) then
			return false;
		end
		
		return ( a.pos > b.pos );
	end );
end

function SSOverlay_AddRow( data )
	if( data.type == "up" and not data.seconds ) then
		data.seconds = 1;
	end
	
	local removeData = { "looseMatch", "matchType", "newText", "ignoreColor" };
	for _, name in pairs( removeData ) do
		data[ name ] = nil;
	end

	if( data.type == "up" or data.type == "down" ) then
		data.startSeconds = data.seconds;
		data.added = GetTime();
	end

	if( data.type == "item" ) then
		data.count = GetItemCount( data.item );
	end
	
	data.rowID = #( ActiveTimers ) + 1;
	table.insert( ActiveTimers, data );
			
	ActiveTimerCount[ data.type ] = ( ActiveTimerCount[ data.type ] or 0 ) + 1;
	ActiveTimerCount.total = ( ActiveTimerCount.total or 0 ) + 1;
	
	SSOverlay_CreateOverlayRow();
	
	if( not data.catText ) then
		SSOverlay_UpdateCatText();
	end
	
	SSOverlay_SortOverlay();
	SSOverlay_UpdateOverlay();
	SSOverlay:Show();
end

function SSOverlay_RemoveRow( data )
	local rowRemoved;		
	
	for _, row in pairs( SSOverlay_GetRows( data ) ) do
		ActiveTimerCount[ row.type ] = ( ActiveTimerCount[ row.type ] or 1 ) - 1;
		ActiveTimerCount.total = ( ActiveTimerCount.total or 1 ) - 1;
		
		rowRemoved = true;
		table.remove( ActiveTimers, row.rowID );
	end
	
	if( #( ActiveTimers ) == 0 ) then
		SSOverlay_RemoveAll();
		return;
	end
	
	if( rowRemoved ) then
		SSOverlay_UpdateCatText();
	end
	
	SSOverlay_SortOverlay();
	SSOverlay_UpdateOverlay();

	if( ActiveTimerCount.total <= 0 ) then
		SSOverlay:Hide();
	end
end

function SSOverlay_RemoveAll()
	ActiveTimers = {};
	ActiveTimerCount = { total = 0, item = 0, down = 0, up = 0, text = 0 };
	
	SSOverlay_UpdateOverlay();
	SSOverlay:Hide();
end

function SSOverlay_UpdateRow( data )
	local row, id = SSOverlay_GetRow( data );
	
	if( id > 0 ) then
		local removeData = { "looseMatch", "matchType", "newText", "ignoreColor" };
		
		ActiveTimerCount[ ActiveTimers[ row.rowID ].type ] = ( ActiveTimerCount[ ActiveTimers[ row.rowID ].type ] or 1 ) - 1;
		ActiveTimerCount[ data.type ] = ( ActiveTimerCount[ data.type ] or 1 ) + 1;
		
		-- Update timer start if seconds have changed
		if( data.type == "down" or data.type == "up" ) then
			if( ActiveTimers[ row.rowID ].startSeconds ~= data.seconds or ActiveTimers[ row.rowID ].type ~= data.type ) then
				data.startSeconds = data.seconds;
				data.added = GetTime();
			end
		end
		
		if( data.newText ) then
			data.text = data.newText;
		end
		
		if( data.type == "item" ) then
			data.count = GetItemCount( data.item );
		end
		
		-- Add the old timer data if it doesn't already exist
		for name, info in pairs( ActiveTimers[ row.rowID ] ) do
			data[ name ] = ( data[ name ] or info );
		end
		
		-- Now remove any of the unwanted data
		for _, name in pairs( removeData ) do
			data[ name ] = nil;
		end

		ActiveTimers[ row.rowID ] = data;
		
		if( not data.catText ) then
			SSOverlay_UpdateCatText();
		end

		SSOverlay_SortOverlay();
		SSOverlay_UpdateOverlay();
	else
		if( data.newText ) then
			data.text = data.newText;
		end
		
		SSOverlay_AddRow( data );
	end
end

function SSOverlay_UpdateOverlay()
	if( #( ActiveTimers ) <= 0 ) then
		SSOverlay:Hide();
		return;
	end

	for i=1, CREATED_ROWS do
		local row = getglobal( "SSOverlayRow" .. i .. "Text" );
		if( ActiveTimers[ i ] ) then 
			local timer = ActiveTimers[ i ];
			
			row:SetText( SSOverlay_FormatText( timer ) );

			if( timer.color ) then
				row:SetTextColor( timer.color.r, timer.color.g, timer.color.b, SSOverlay_Config.textOpacity );
			elseif( timer.catText and SSOverlay_Config.catText ) then
				row:SetTextColor( SSOverlay_Config.catText.r, SSOverlay_Config.catText.g, SSOverlay_Config.catText.b, SSOverlay_Config.textOpacity );
			else
				row:SetTextColor( SSOverlay_Config.text.r, SSOverlay_Config.text.g, SSOverlay_Config.text.b, SSOverlay_Config.textOpacity );
			end

			local parent = row:GetParent();
			
			parent:Show();
			parent:SetScript( "OnEnter", timer.onEnter );
			parent:SetScript( "OnLeave", timer.onLeave );
		
			if( SSOverlay_Config.click ) then
				parent.extraData = nil;
				parent:SetScript( "OnMouseDown", nil );
				parent:SetScript( "OnMouseUp", nil );
			else
				parent.extraData = timer.extraData;
				parent:SetScript( "OnMouseDown", timer.mouseDown );
				parent:SetScript( "OnMouseUp", timer.mouseUp );
			end
		else
			row:SetText( "" );
						
			local parent = row:GetParent();
			
			parent.extraData = nil;
			parent:SetScript( "OnMouseDown", nil );
			parent:SetScript( "OnMouseUp", nil );
			parent:SetScript( "OnEnter", nil );
			parent:SetScript( "OnLeave", nil );
			parent:Hide();
		end
	end
	
	SSOverlay_Resize();
end

function SSOverlay_FormatText( timer )
	if( timer.type == "text" and not timer.extra ) then
		return timer.text;
	end
	
	local text, format;
	
	if( timer.type == "text" ) then
		format = ( timer.format or "*text*: *extra1*" );
	elseif( timer.extra ) then
		format = ( timer.format or "*text*: *timer* (*extra1*)" );
	else
		format = ( timer.format or "*text*: *timer*" )
	end
	
	if( not format ) then
		return text;
	end
	
	text = string.gsub( format, "%*text%*", ( timer.text or "" ) );
	
	if( timer.type == "up" or timer.type == "down" ) then
		text = string.gsub( text, "%*timer%*", SSOverlay_FormatTime( timer.seconds ) );
	elseif( timer.type == "item" ) then
		text = string.gsub( text, "%*timer%*", timer.count );
	end

	if( timer.extra ) then
		for id, extra in pairs( timer.extra ) do
			text = string.gsub( text, "%*extra" .. id .. "%*", extra );				
		end
		
		-- Remove any left over extras
		text = string.gsub( text, "%*extra([0-9]+)%*", "" );
	end

	return text;
end

function SSOverlay_FormatTime( time, formatType )
	formatType = ( formatType or SSOverlay_Config.format );
	
	if( formatType == "minsec" ) then
		text = SecondsToTime( time );
	elseif( formatType == "min" and time >= 60 ) then
		text = SecondsToTime( time, 1 );
	elseif( formatType == "mmss" ) then
		text = SSOverlay_SecondsToBuff( time );	
	else
		text = SecondsToTime( time );
	end
	
	if( string.sub( text, string.len( text ) ) == " " ) then
		text = string.sub( text, 1, string.len( text ) - 1 );
	end
	
	return text;
end

function SSOverlay_SecondsToBuff( seconds )
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

function SSOverlay_OverlayLocked()
	for i=1, CREATED_ROWS do
		local row = getglobal( "SSOverlayRow" .. i );
		
		if( SSOverlay_Config.locked ) then
			row:EnableMouse( true );
		else
			row:EnableMouse( false );
		end
	end
end

function SSOverlay_SortOverlay()
	ActiveTimers = SSOverlay_Sort( ActiveTimers );
end

function SSOverlay_Sort( sortTable )
	local temp = {};
	local cats = {};
	
	for id, row in pairs( sortTable ) do
		if( not cats[ row.cat ] ) then
			cats[ row.cat ] = {};
		end
		
		row.rowID = id;
		
		table.insert( cats[ row.cat ], row );
	end

	for id, category in pairs( Categories ) do
		if( cats[ category.name ] ) then
			table.insert( temp, cats[ category.name ] );
		end
	end

	sortTable = {};
	
	for _, timers in pairs( temp ) do
		table.sort( timers, function( a, b )
			if( not a ) then
				return true;
			end
			
			if( not b ) then
				return false;
			end
			
			if( a.catText and not b.catText ) then
				return true;
			elseif( not a.catText and b.catText ) then
				return false;
			end
			
			if( a.type == b.type ) then
				return a.rowID < b.rowID;
			end

			return SortingPriorities[ a.type ] < SortingPriorities[ b.type ];
		end );

		for id, timer in pairs( timers ) do
			table.insert( sortTable, timer );
		end
	end
	
	return sortTable;
end

function SSOverlay_SetCategoryAutoHide( status )
	AutoHideCatText = status;
	
	SSOverlay_UpdateCatText();
end

function SSOverlay_UpdateCatText()
	local ActiveCategories = {};
	local usedCategories = 0;
	
	-- Auto hide the category text if it's the only one displaying
	if( AutoHideCatText ) then
		for _, row in pairs( ActiveTimers ) do
			if( not row.catText ) then
				if( not ActiveCategories[ row.cat ] ) then
					usedCategories = usedCategories + 1;
				end
				ActiveCategories[ row.cat ] = ActiveCategories[ row.cat ] or 0 + 1;
			end
		end
	end	

	for _, cat in pairs( Categories ) do
		if( cat.data ) then
			if( ActiveCategories[ cat.name ] and ActiveCategories[ cat.name ] > 0 and usedCategories > 1 and not SSOverlay_Config.hideCat ) then
				local data = cat.data;
				if( not data.type ) then
					data.type = "text";
				end

				if( data.type == "text" and not data.newText ) then
					data.newText = data.text;
				end

				data.cat = cat.name;
				data.catText = true;
				
				SSOverlay_UpdateRow( data );	
			else
				SSOverlay_RemoveRow( { cat = cat.name, text = cat.data.text } );
			end
		end
	end
end

function SSOverlay_Dump()
	DevTools_Dump( ActiveTimers );
end

-- Clean later
function SSOverlay_Resize()
	if( ActiveTimerCount.total == 0 ) then
		return;
	end
	
	local timerHeight = 0;
	local timerWidth = 0;
	local overlayWidth = SSOverlay:GetWidth();
	local textHeight = ( getglobal( "SSOverlayRow1Text" ):GetHeight() + 2 );
	
	if( ActiveTimerCount.total >= CREATED_ROWS ) then
		timerHeight = textHeight * CREATED_ROWS;
	else
		timerHeight = textHeight * ActiveTimerCount.total;
	end
	
	for i = 1, CREATED_ROWS do
		local width = getglobal( "SSOverlayRow" .. i .. "Text" ):GetWidth();
		if( width > timerWidth ) then
			timerWidth = width;
			
		end
	end
	
	timerWidth = timerWidth + 20;
	
	-- Don't adjust width if it's only grown by two
	if( ( timerWidth - 2 ) <= overlayWidth and ( timerWidth + 2 ) >= overlayWidth ) then
		SSOverlay:SetHeight( timerHeight + 9 );
		return;
	end
	
	SSOverlay:SetWidth( timerWidth );
	SSOverlay:SetHeight( timerHeight + 9 );
	
	-- Now set all the row sizes to what the overlay is
	for i=1, CREATED_ROWS do
		local row = getglobal( "SSOverlayRow" .. i );
		row:SetWidth( timerWidth );
	end
end

function SSOverlay_OnUpdate( elapsed )
	if( ActiveTimerCount.total > 0 and ( ActiveTimerCount.up > 0 or ActiveTimerCount.down > 0 ) ) then
		timeElapsed = timeElapsed + elapsed

		if( timeElapsed >= 0.1 ) then
			timeElapsed = timeElapsed - 0.1;
			
			local currentTime = GetTime();
			
			for i=ActiveTimerCount.total, 1, -1 do
				local timer = ActiveTimers[ i ];
				
				if( timer ) then
					if( timer.type == "up" ) then
						timer.seconds = timer.startSeconds + ( currentTime - timer.added );

						ActiveTimers[ i ].seconds = timer.seconds;
					elseif( timer.type == "down" ) then
						timer.seconds = timer.startSeconds - ( currentTime - timer.added );

						ActiveTimers[ i ].seconds = timer.seconds;
						if( floor( timer.seconds ) <= 0 ) then
							ActiveTimerCount.down = ActiveTimerCount.down - 1;
							ActiveTimerCount.total = ActiveTimerCount.total - 1;
							
							table.remove( ActiveTimers, i );

							SSOverlay_UpdateCatText();
							SSOverlay_SortOverlay();
							SSOverlay_UpdateOverlay();
							
							if( ActiveTimerCount.total <= 0 ) then
								SSOverlay:Hide();
							end
						end
					end


					if( i <= CREATED_ROWS and getglobal( "SSOverlayRow" .. i ) ) then
						getglobal( "SSOverlayRow" .. i .. "Text" ):SetText( SSOverlay_FormatText( timer ) );
					end
				end
			end
			
			SSOverlay_UpdateOverlay();
		end
	
	end
end


function SSOverlay_ReloadOverlay()
	if( not SSOverlay_Config.enabled ) then
		SSOverlay_RemoveAll();
		return;
	end
	
	SSOverlay_UpdateOverlayColors();
end

function SSOverlay_LoadUI()
	SSUI_RegisterVarType( "ssoverlay", "SSOverlay_SetVariable", "SSOverlay_GetVariable" );
	SSUI_AddFrame( "SSOverlayConfig", "sspvp" );
	SSUI_AddTab( SSO_OVERLAY, "SSOverlayConfig", 5 );

	local UIList = {
		{ name = "SSEnableOverlay", text = SSO_UI_ENABLE, type = "check", onClick = "SSOverlay_ReloadOverlay", points = { "TOPLEFT", "TOPLEFT", 10, -10 }, varType = "ssoverlay", var = { "enabled" }, parent = "SSOverlayConfig" },
		{ name = "SSLockOverlay", text = SSO_UI_LOCKED, tooltip = SSO_UI_LOCKED_TT, type = "check", onClick = "SSOverlay_OverlayLocked", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssoverlay", var = { "locked" }, parent = "SSOverlayConfig" },
		{ name = "SSDisableClick", text = SSO_UI_DISABLECLICK, tooltip = SSO_UI_DISABLECLICK_TT, onClick="SSOverlay_UpdateOverlay", type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssoverlay", var = { "click" }, parent = "SSOverlayConfig" },
		{ name = "SSHideCatText", text = SSO_UI_HIDECAT, tooltip = SSO_UI_HIDECAT_TT, onClick="SSOverlay_UpdateCatText", type = "check", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssoverlay", var = { "hideCat" }, parent = "SSOverlayConfig" },
		{ name = "SSOverlayBGColor", text = SSO_UI_BGCOLOR, type = "color", onChange = "SSOverlay_UpdateOverlay", points = { "LEFT", "LEFT", 6, -30 }, varType = "ssoverlay", var = { "color" }, parent = "SSOverlayConfig" },
		{ name = "SSOverlayBorderColor", text = SSO_UI_BORDERCOLOR, onChange = "SSOverlay_UpdateOverlay",  type = "color", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssoverlay", var = { "border" }, parent = "SSOverlayConfig" },
		{ name = "SSOverlayTextColor", text = SSO_UI_TEXTCOLOR, onChange = "SSOverlay_UpdateOverlay",  type = "color", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssoverlay", var = { "text" }, parent = "SSOverlayConfig" },
		{ name = "SSOverlayCatTextColor", text = SSO_UI_CATTEXTCOLOR, tooltip = SSO_UI_CATTEXTCOLOR_TT, onChange = "SSOverlay_UpdateOverlay",  type = "color", points = { "LEFT", "LEFT", 0, -30 }, varType = "ssoverlay", var = { "catText" }, parent = "SSOverlayConfig" },
		{ name = "SSOverlayFormat", text = SSO_UI_FORMAT, type = "dropdown", onClick = "SSOverlay_UpdateOverlay",  points = { "LEFT", "LEFT", -17, -40 }, list = { { "minsec", SSO_UI_MINSEC }, { "min", SSO_UI_MIN }, { "mmss", SSO_UI_MMSS } }, varType = "ssoverlay", var = { "format" }, parent = "SSOverlayConfig" },
		{ name = "SSOverlayOpacity", text = SSO_UI_OPACITY, onChange = "SSOverlay_UpdateOverlay", minText = SSU_0_PERCENT, maxText = SSU_100_PERCENT, type = "slider", points = { "LEFT", "LEFT", 17, -40 }, varType = "ssoverlay", var = { "opacity" }, parent = "SSOverlayConfig" },
		{ name = "SSOverlayTextOpacity", text = SSO_UI_TEXTOPACITY, onChange = "SSOverlay_UpdateOverlay", minText = SSU_0_PERCENT, maxText = SSU_100_PERCENT, type = "slider", points = { "LEFT", "LEFT", 0, -37 }, varType = "ssoverlay", var = { "textOpacity" }, parent = "SSOverlayConfig" },
	};
	
	for _, list in pairs( UIList ) do
		SSUI_AddElement( list );
	end
end


-- Variable management
function SSOverlay_GetDefaultConfig( var, fullConfig )
	Config = {};
	Config.enabled = true;
	Config.locked = true;
	
	Config.opacity = 1.0;
	Config.textOpacity = 1.0;

	Config.color = { r = 0.0, g = 0.0, b = 0.0 };
	Config.text = { r = 1.0, g = 1.0, b = 1.0 };
	Config.border = { r = 0.5, g = 0.5, b = 0.5 };
	Config.catText = { r = 0.75, g = 0.75, b = 0.75 };
	
	Config.hideCat = false;
	
	Config.click = true;

	if( fullConfig ) then
		return Config;
	elseif( var ) then
		return Config[ var ];
	end
	
	return nil;
end

function SSOverlay_GetVariable( vars )
	if( SSOverlay_Config[ vars[1] ] == nil ) then
		SSOverlay_Config[ vars[1] ] = SSOverlay_GetDefaultConfig( vars[1] );
	end
	
	return SSOverlay_Config[ vars[1] ];
end

function SSOverlay_SetVariable( vars, value )
	SSOverlay_Config[ vars[1] ] = value;
end
