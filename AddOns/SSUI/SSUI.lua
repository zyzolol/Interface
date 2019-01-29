local MAX_UI_TABS = 17;

local UITitles = {};
local UITabs = {};
local UIFrames = {};
local UIElements = {};

local VarTypes = {};
local ColorData;

local UILoaded = {};

function SSUI_Show( UIType )
	SSUI.activeType = UIType;
	SSUI:Show();
end

function SSUI_Hide()
	SSUI:Hide()
end

-- Build the UI
function SSUI_OnShow()
	if( not this.activeType ) then
		return;
	end
	
	-- Load anything that has UI elements
	SSUI_ScanAndLoadAddOns();
	
	local defaultSet;
	
	-- Create the config frames
	for name, data in pairs( UIFrames ) do
		-- Hide it if it's not the active frame we want to show
		if( data.UIType == this.activeType ) then
			local frame;
			if( not getglobal( name ) ) then
				frame = CreateFrame( "Frame", name, this, "SSConfigTemplate" );
			else
				frame = getglobal( name );
			end

			if( data.defaultFrame and not defaultSet ) then
				frame:Show();
				defaultSet = true;
			else
				frame:Hide();
			end
		elseif( getglobal( name ) ) then
			getglobal( name ):Hide();
		end
	end
	
	local ShownTab = 1;
	for id, tab in pairs( UITabs ) do
		if( tab.configPage and UIFrames[ tab.configPage ].UIType == this.activeType ) then
			local frame;
			if( not getglobal( "SSTab" .. ShownTab ) ) then
				frame = CreateFrame( "Button", "SSTab" .. ShownTab, this, "SSTabButtonTemplate" );
				if( ShownTab > 1 ) then
					frame:SetPoint( "LEFT", "SSTab" .. ( ShownTab - 1 ), "LEFT", 0, -21 );
				else
					frame:SetPoint( "LEFT", "SSUI", "TOPLEFT", 14, -32 );		
				end
			else
				frame = getglobal( "SSTab" .. ShownTab );
			end

			ShownTab = ShownTab + 1;
			
			frame:SetText( tab.text or SSUI_NOTEXT );
			frame.configFrame = tab.configPage;
			frame:Show();
		end
	end
	
	for i=ShownTab, MAX_UI_TABS do
		local tab = getglobal( "SSTab" .. i );
		if( tab ) then
			tab:SetText( "" );
			tab.configFrame = nil;
			tab:Hide();
		end
	end
		
	-- Now do close
	SSTabClose:SetScript( "OnClick", SSUI_Hide );
	SSTabClose:SetText( SSU_CLOSE );
	
	if( UITitles[ this.activeType ] ) then
		SSUITitleText:SetText( UITitles[ this.activeType ].title );
		SSUITitle:SetWidth( UITitles[ this.activeType ].width or 175 );
	else
		SSUITitleText:SetText( SSU_DEFTITLE );
		SSUITitle:SetWidth( 175 );		
	end
	
	-- Setup some things
	local LastParent;
	local LastFrame = {};
	
	-- Create UI Elements
	for _, data in pairs( UIElements ) do		
		if( UIFrames[ data.parentFrame ].UIType == this.activeType ) then
			local frame = getglobal( data.name );

			LastParent = data.parent;

			if( not LastFrame[ data.parent ] ) then
				LastFrame[ data.parent ] = {};
				LastFrame[ data.parent ] = data.name;
			else
				data.parent = LastFrame[ data.parent ];
			end

			-- CHECK BOXES
			if( data.type == "check" and not frame ) then
				frame = SSUI_CreateFrame( "CheckButton", "SSCheckBoxTemplate", data );

				frame.varInfo = { type = data.varType, var = data.var };
				frame.onClick = data.onClick;
				frame.tooltipText = data.tooltip;

				frame:SetChecked( SSUI_GetVariable( data.varType, data.var ) );

			-- BUTTONS
			elseif( data.type == "button" and not frame ) then
				frame = SSUI_CreateFrame( "Button", "SSButtonTemplate", data );

				if( data.width ) then
					frame:SetWidth( data.width );
				else
					frame:SetWidth( frame:GetTextWidth() + 20 );
				end

				if( data.height ) then
					frame:SetHeight( data.height );
				end

				frame.onClick = data.onClick;
				frame.tooltipText = data.tooltip;

			-- EDIT BOXES
			elseif( data.type == "input" and not frame ) then
				frame = SSUI_CreateFrame( "EditBox", "SSInputTemplate", data );

				-- Change width/max chars if needed
				if( data.width ) then
					frame:SetWidth( data.width );
				end

				if( data.maxChars ) then
					frame:SetMaxLetters( data.maxChars );
				end

				-- Load default data
				frame.varInfo = { type = data.varType, var = data.var, force = data.forceType };
				frame.tooltipText = data.tooltip;
				frame.onChange = data.onChange;

				frame:SetText( SSUI_GetVariable( data.varType, data.var ) );

			-- SLIDERS
			elseif( data.type == "slider" and not frame ) then
				frame = SSUI_CreateFrame( "Slider", "SSSliderTemplate", data );

				-- Load the usuals
				frame.varInfo = { type = data.varType, var = data.var };
				frame.showValue = data.showValue;
				frame.isPercent = data.isPercent;
				frame.origText = data.text;
				frame.onChange = data.onChange;
				frame.tooltipText = data.tooltip;

				-- Set the special stuff
				frame:SetMinMaxValues( ( data.minValue or 0.0 ), ( data.maxValue or 1.0 ) );
				frame:SetValueStep ( ( data.valueStep or 0.01 ) );
				frame:SetValue( SSUI_GetVariable( data.varType, data.var ) );

				-- Change min/max text if needed
				if( data.minText ) then
					getglobal( frame:GetName() .. "Low" ):SetText( data.minText );
				end

				if( data.maxText ) then
					getglobal( frame:GetName() .. "High" ):SetText( data.maxText );
				end

				if( data.showValue ) then
					local value = SSUI_GetVariable( data.varType, data.var );

					if( data.isPercent and value > 0.0 ) then
						value = value * 100;	
					elseif( data.isPercent ) then
						value = 0;
					end

					getglobal( frame:GetName() .. "Text" ):SetText( string.format( data.text, value ) );			
				end

			-- DROP DOWNS
			elseif( data.type == "dropdown" and not frame ) then
				frame = SSUI_CreateFrame( "Frame", "SSDropDownTemplate", data );

				-- Load the required data
				frame.varInfo = { type = data.varType, var = data.var, force = data.forceType };
				frame.dropList = data.list;
				frame.onClick = data.onClick;
				frame.tooltipText = data.tooltip;

				-- Load the drop down data
				selected = ( SSUI_GetVariable( data.varType, data.var ) or 1 );

				if( #( data.list ) > 0 ) then
					UIDropDownMenu_SetSelectedID( frame, selected );

					for index, row in pairs( data.list ) do
						if( index == selected or row[1] == selected ) then
							UIDropDownMenu_SetText( row[2], frame );
						end
					end
				end	

				if( getglobal( frame:GetName() .. "InfoText" ) ) then
					getglobal( frame:GetName() .. "InfoText" ):SetText( data.text );
				end

			elseif( data.type == "color" and not frame ) then
				frame = SSUI_CreateFrame( "Button", "SSColorPickerTemplate", data );

				frame.varInfo = { type = data.varType, var = data.var };
				frame.onChange = data.onChange;
				frame.tooltipText = data.tooltip;

				local color = SSUI_GetVariable( data.varType, data.var );

				getglobal( frame:GetName() .. "NormalTexture" ):SetVertexColor( color.r, color.g, color.b );
				getglobal( frame:GetName() .. "Text" ):SetText( data.text );
			end
			
			if( frame ) then
				frame:Show();
				LastFrame[ LastParent ] = data.name;
			end
		end
	end
end

function SSUI_OnHide()
	for _, data in pairs( UIElements ) do
		if( getglobal( data.name ) ) then
			getglobal( data.name ):Hide();
		end
	end
	
	this.activeType = nil;
end

-- rare case, but may as well have it functionized
function SSUI_Error( msg )
	error( msg );
	SSUI_Hide();
end

function SSUI_CreateFrame( frameType, inherits, data )
	local frame;
	
	if( not getglobal( data.name ) ) then
		frame = CreateFrame( frameType, data.name, getglobal( data.parent ), inherits );
	else
		frame = getglobal( data.name );
	end
	
	if( not data.text ) then
		data.text = SSU_NOTEXT;
		DEFAULT_CHAT_FRAME:AddMessage( string.format( SSU_NOTEXTFOUND, data.name ) );
	end
	
	frame:SetPoint( data.points[1], getglobal( data.parent ), data.points[2], data.points[3], data.points[4] );
	--[[
	if( data.points[5] ) then
		frame:SetPoint( data.points[1], data.points[2], data.points[3], data.points[4], data.points[5] );
	else
		frame:SetPoint( data.points[1], getglobal( data.parent ), data.points[2], data.points[3], data.points[4] );
	end
	]]
	
	if( not data.ignoreText ) then
		if( data.type ~= "button" ) then
			getglobal( frame:GetName() .. ( data.textName or "Text" ) ):SetText( data.text );
		else
			frame:SetText( data.text );
		end
	end
	
	return frame;
end


function SSUI_TabButton_OnClick()
	if( getglobal( this.configFrame ) ) then
		-- Hide all the config frames
		for _, tab in pairs( UITabs ) do
			if( getglobal( tab.configPage ) ) then
				getglobal( tab.configPage ):Hide();
			end
		end
		
		-- Now show the one we clicked
		getglobal( this.configFrame ):Show();
	end
end

-- Clean this up later
function SSUI_OpenColorPicker()
	local color = SSUI_GetVariable( this.varInfo.type, this.varInfo.var );
	
	ColorData = {};
	ColorData.varInfo = this.varInfo;
	ColorData.onChange = this.onChange;
	ColorData.buttonName = this:GetName();

	ColorPickerFrame.func = SSUI_SetColor;
	ColorPickerFrame.cancelFunc = SSUI_CancelColor;

	ColorPickerFrame.previousValues = { r = color.r, g = color.g, b = color.b };
	ColorPickerFrame:SetColorRGB( color.r, color.g, color.b );
	ColorPickerFrame:Show();
end

function SSUI_SetColor()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	
	getglobal( ColorData.buttonName .. "NormalTexture" ):SetVertexColor( r, g, b );
	
	SSUI_SetVariable( ColorData.varInfo.type, ColorData.varInfo.var, { r = r, g = g, b = b } );
	if( ColorData.onChange ) then
		getglobal( ColorData.onChange )();
	end
end

function SSUI_CancelColor( prevColor )
	getglobal( ColorData.buttonName .. "NormalTexture" ):SetVertexColor( prevColor.r, prevColor.g, prevColor.b );
	
	SSUI_SetVariable( ColorData.varInfo.type, ColorData.varInfo.var, prevColor );
	if( ColorData.onChange ) then
		getglobal( ColorData.onChange )();
	end
end


function SSUI_Slider_OnValueChanged()
	SSUI_SetVariable( this.varInfo.type, this.varInfo.var, this:GetValue() );

	if( this.showValue ) then
		local value = SSUI_GetVariable( this.varInfo.type, this.varInfo.var );

		if( this.isPercent and value > 0.0 ) then
			value = value * 100;	
		elseif( this.isPercent ) then
			value = 0;
		end

		getglobal( this:GetName() .. "Text" ):SetText( string.format( this.origText, value ) );			
	end
	
	if( this.onChange ) then
		getglobal( this.onChange )();
	end
end

function SSUI_DropDown_OnClick()
	local frame = this.owner;

	if( frame.varInfo.type ) then
		UIDropDownMenu_SetSelectedID( frame, this:GetID() );
		
		for index, row in pairs( frame.dropList ) do
			if( index == this:GetID() ) then
				SSUI_SetVariable( frame.varInfo.type, frame.varInfo.var, row[1] );			
			end
		end
	end
	
	if( frame.onClick ) then
		getglobal( frame.onClick )();
	end
end

-- Fix this later
function SSUI_DropDown_Initialize()
	local frame = this;
	if( string.find( frame:GetName(), "Button$" ) ) then
		frame = getglobal( string.gsub( this:GetName(), "Button$", "" ) );
	end
	
	if( not frame.dropList ) then
		return;
	end
	
	for id, row in pairs( frame.dropList ) do
		local button = {};
		button.text = row[2];
		button.value = row[1];
		button.owner = frame;
		button.func = SSUI_DropDown_OnClick;
		
		UIDropDownMenu_AddButton( button );
	end
end

function SSUI_Button_OnClick()
	if( this.onClick ) then
		getglobal( this.onClick )();
	end
end

function SSUI_CheckBox_OnClick()
	if( this.varInfo.type ) then
		if( this:GetChecked() ) then
			SSUI_SetVariable( this.varInfo.type, this.varInfo.var, true );
		else
			SSUI_SetVariable( this.varInfo.type, this.varInfo.var, false );
		end
	end
	
	if( this.onClick ) then
		getglobal( this.onClick )();
	end
end

function SSUI_EditBox_TextChanged()
	local value = this:GetText();
	
	if( this.varInfo.force == "int" ) then
		value = tonumber( value );
		
		if( not value ) then
			value = 0;
		end
	end
	
	SSUI_SetVariable( this.varInfo.type, this.varInfo.var, value );
	
	if( this.onChange and getglobal( this.onChange ) ) then
		getglobal( this.onChange )();
	end
end

-- Call the set or get for variable management
function SSUI_SetVariable( type, vars, value )
	if( not type or not vars ) then
		return nil;
	end
	
	local data = VarTypes[ type ];
	return getglobal( data.set )( vars, value );
end

function SSUI_GetVariable( type, vars )
	if( not type or not vars ) then
		return nil;
	end
	
	local data = VarTypes[ type ];

	return getglobal( data.get )( vars );
end

-- Registering new UI elements and such
function SSUI_AddTitle( UIType, title, width )
	UITitles[ UIType ] = { title = title, width = width };
end

function SSUI_RegisterVarType( name, set, get )
	VarTypes[ name ] = { set = set, get = get };
end

function SSUI_AddFrame( frameName, UIType, isDefault )
	UIFrames[ frameName ] = { defaultFrame = isDefault, UIType = UIType };
end

function SSUI_AddTab( text, configPage, order )
	-- Make sure we don't have a tab of the same name
	for _, tab in pairs( UITabs ) do
		if( tab.configPage == configPage ) then
			return;
		end
	end
	
	table.insert( UITabs, { text = text, order = order or 999999, configPage = configPage } );
	
	table.sort( UITabs, function( a, b )
		if( not a or not b ) then
			return nil;
		end
		
		return a.order < b.order;
	end );
end

function SSUI_RemoveTab( configPage )
	for i=#( UITabs ), 1, -1 do
		if( UITabs[i].configPage == configPage ) then
			table.remove( UITabs, i );
		end
	end
end

function SSUI_AddElement( element )
	-- Make sure it doesn't exist already, if it does update it
	for id, row in pairs( UIElements ) do
		if( row.name == element.name ) then
			return;
		end
	end
	
	element.parentFrame = element.parent;
	
	table.insert( UIElements, element );
end

-- Loads any addon that has UI elements
function SSUI_ScanAndLoadAddOns()
	for i=1, GetNumAddOns() do
		local name, _, _, _, _, status = GetAddOnInfo( i );
					
		if( status ~= "DISABLED" and GetAddOnMetadata( name, "X-SSUIDep" ) and not UILoaded[ name ] ) then
			UIParentLoadAddOn( name );
			
			if( getglobal( name .. "_LoadUI" ) ) then
				UILoaded[ name ] = true;
				getglobal( name .. "_LoadUI" )();		
			end			
		end
	end
end

-- Misc stuff
function SSUI_OnLoad()
	table.insert( UISpecialFrames, "SSUI" );
	this:RegisterEvent( "ADDON_LOADED" );
end

function SSUI_OnEvent( event )
	if( event == "ADDON_LOADED" and arg1 == "SSUI" ) then
		if( not SSUI_Config ) then
			SSUI_Config = {};
		end

		if( SSUI_Config.position ) then
			SSUI:ClearAllPoints();
			SSUI:SetPoint( "TOPLEFT", "UIParent", "BOTTOMLEFT", SSUI_Config.position.x, SSUI_Config.position.y );
			SSUI:SetUserPlaced( true );
		end
	end
end

function SSUI_SavePosition()
	if( SSUI:IsUserPlaced() ) then
		if( not SSUI_Config.position ) then
			SSUI_Config.position = {};
		end
		
		SSUI_Config.position.x, SSUI_Config.position.y = SSUI:GetLeft(), SSUI:GetTop();
		SSUI:SetUserPlaced( true );
	else
		SSUI_Config.position = nil;		
	end
end