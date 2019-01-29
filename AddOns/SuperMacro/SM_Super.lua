-- hook API functions
local oldPickupMacro=PickupMacro;
--local oldPickupContainerItem=PickupContainerItem;
--local oldPickupInventoryItem=PickupInventoryItem;
local oldPickupSpell=PickupSpell;
local oldPickupAction=PickupAction;
local oldPlaceAction=PlaceAction;
local oldGetActionText=GetActionText;
--local oldGetActionTexture=GetActionTexture;
CursorHasMacro = nil;

function PickupMacro(macroid, supername)
	CursorHasMacro = true;
	if ( supername ) then
		SM_CURSOR=supername;
		local tempicon=SM_MACRO_ICON[GetSuperMacroInfo(supername,"texture")];
		local macroname, macroicon=GetMacroInfo(1);
		macroicon=SM_MACRO_ICON[macroicon];
		EditMacro(1,macroname, tempicon);
		oldPickupMacro(1);
		EditMacro(1,macroname, macroicon);
	else
		SM_CURSOR=nil;
		oldPickupMacro(macroid);
	end
end

function SM_PickupContainerItem(index, slot)
	CursorHasMacro = nil;
	SM_CURSOR=nil;
	--oldPickupContainerItem(index, slot);
end
hooksecurefunc( "PickupContainerItem", SM_PickupContainerItem );

function SM_PickupInventoryItem(index)
	CursorHasMacro = nil;
	SM_CURSOR=nil;
	--oldPickupInventoryItem(index);
end
hooksecurefunc( "PickupInventoryItem", SM_PickupInventoryItem );

function PickupSpell(index, book)
	CursorHasMacro = nil;
	SM_CURSOR=nil;
	oldPickupSpell(index, book);
end

function PickupAction(id)
	local button = this:GetName();
	-- secure template
	this:SetAttribute("type", "action");

	if ( SM_ACTION[button] ) then
		SM_CURSOR=SM_ACTION[button];
		local tempicon=SM_MACRO_ICON[GetSuperMacroInfo(SM_CURSOR,"texture")];
		local macroname, macroicon=GetMacroInfo(1);
		macroicon=SM_MACRO_ICON[macroicon];
		EditMacro(1,macroname, tempicon);
		SM_ACTION[button]=nil;
		oldPickupAction(id);
		EditMacro(1,macroname, macroicon);		
		CursorHasMacro = true;
	else
		SM_CURSOR=nil;
		SM_ACTION[button]=nil;
		oldPickupAction(id);
		CursorHasMacro = nil;
	end
end

function PlaceAction(id)
	local button = this:GetName();
	-- place and pickup super
	local cursor;
	CursorHasMacro = nil;
	
	-- replace old action
	if ( SM_ACTION[button] ) then
		cursor=SM_ACTION[button];
		CursorHasMacro = true;
	end
	SM_ACTION[button]=SM_CURSOR;
	SM_CURSOR=cursor;
	oldPlaceAction(id);
	
	-- secure template for super, needs work
	if ( SM_ACTION[button] and this ) then
		local body = gsub(GetSuperMacroInfo(SM_ACTION[button],"body") or "", "\\n", "\\n");
		body = SM_ReplaceAlias(body);
		this:SetAttribute("*type*", "macro");
		this:SetAttribute("*macrotext*", body);		
		ActionButton_UpdateState(this);
	else
		this:SetAttribute("type", "action");
	end
end

function GetActionText(id)
	if ( this ) then
		local button = this:GetName();
		if ( SM_ACTION[button] ) then
			return SM_ACTION[button];
		end
	end
	return oldGetActionText(id);
end

function SM_GetActionTexture(button) -- button is string
	if ( not button ) then
		button = this:GetName();
	end
	if ( SM_ACTION[button] ) then
		return GetSuperMacroInfo(SM_ACTION[button], "texture");
	end
	return nil;
end

function SM_ActionButton_Update(id) -- can't use GetActionTexture directly, so update icon after update
	local texture = SM_GetActionTexture();
	if ( texture ) then
		getglobal(this:GetName().."Icon"):SetTexture(texture);
	end
end
hooksecurefunc("ActionButton_Update", SM_ActionButton_Update);

function SuperMacro_UpdateAction(oldsuper, newsuper)
	for k,v in pairs(SM_ACTION) do
		if ( v==oldsuper ) then
			SM_ACTION[k]=newsuper;
		end
	end
end

function SetActionSuperMacro(button, supername)
	if ( supername and button ) then
		PickupAction( button:GetID() );
		PickupMacro(1, supername );
		PlaceAction ( button:GetID() );
	end
end

function SM_ActionButton_OnClick()
	lastActionUsed = this:GetID();
	if ( CursorHasMacro ) then
		PlaceAction(ActionButton_GetPagedID(this));
		ActionButton_Update();
		return 1;
	end
end

function SuperMacro_WriteMacroToButton()
	for k, v in pairs(SM_ACTION) do
		local button = getglobal(k);
		if ( button ) then
			local body = GetSuperMacroInfo(v, "body");
			body = gsub(body or "", "\\n", "\\n");
			body = SM_ReplaceAlias(body);
			button:SetAttribute("*type*", "macro");
			button:SetAttribute("*macrotext*", body);
		end
	end
end