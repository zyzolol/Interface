local BarHeight=18
local BarWidth=200
local TotalBuffs=5
local PlayersShown=8
local RowsCreated=8
local BuffSpacing=18

local BuffWindow_Functions={}

local BuffWindow_ResizeWindow, BuffWindow_UpdateWindow, BuffWindow_UpdateBuffs

local RL = AceLibrary("Roster-2.1")
local aura = AceLibrary("SpecialEvents-Aura-2.0")
local L = AceLibrary("AceLocale-2.2"):new("BigBrother")

local function spellData(spellID)
	local name,rank,icon = GetSpellInfo(spellID)
	return name, icon
end

local function spellName(spellID)
	local name = GetSpellInfo(spellID)
	return name
end

local BigBrother_Flasks={
{spellData(17626)}, -- 17626 Flask of the Titans
{spellData(17627)}, -- 17627 Flask of Distilled Wisdom 
{spellName(17628),"Interface\\Icons\\INV_Potion_41.blp",L["Flask of Supreme Power"]}, -- 17628 Flask of Supreme Power 
{spellData(17629)}, -- 17629 Flask of Chromatic Resistance 
{spellData(28518)}, -- 28518 Flask of Fortification
{spellData(28519)}, -- 28519 Flask of Mighty Restoration 
{spellData(28520)}, -- 28520 Flask of Relentless Assault 
{spellData(28521)}, -- 28521 Flask of Blinding Light 
{spellData(28540)}, -- 28540 Flask of Pure Death 
{spellData(33053)}, -- 33053 Mr. Pinchy's Blessing
{spellData(42735)}, -- 42735 Flask of Chromatic Wonder 
{spellData(40567)}, -- 40567 Unstable Flask of the Bandit
{spellData(40568)}, -- 40568 Unstable Flask of the Elder
{spellData(40572)}, -- 40572 Unstable Flask of the Beast
{spellData(40573)}, -- 40573 Unstable Flask of the Physician
{spellData(40575)}, -- 40575 Unstable Flask of the Soldier
{spellData(40576)}, -- 40576 Unstable Flask of the Sorcerer
{spellName(41608),"Interface\\Icons\\INV_Potion_117.blp",L["Shattrath Flask of Relentless Assault"]}, -- 41608 Relentless Assault of Shattrath
{spellName(41609),"Interface\\Icons\\INV_Potion_119.blp",L["Shattrath Flask of Fortification"]}, -- 41609 Fortification of Shattrath
{spellName(41610),"Interface\\Icons\\INV_Potion_118.blp",L["Shattrath Flask of Mighty Restoration"]}, -- 41610 Mighty Restoration of Shattrath
{spellName(41611),"Interface\\Icons\\INV_Potion_41.blp",L["Shattrath Flask of Supreme Power"]}, -- 41611 Sureme Power of Shattrath
{spellName(46837),"Interface\\Icons\\INV_Potion_115.blp",L["Shattrath Flask of Pure Death"]}, -- 46837 Pure Death of Shattrath
{spellName(46839),"Interface\\Icons\\INV_Potion_116.blp",L["Shattrath Flask of Blinding Light"]}, -- 46839 Blinding Light of Shattrath
}

local BigBrother_Elixirs_Battle={
{spellData(11390)}, -- 11390 Arcane Elixir
{spellData(17538)}, -- 17538 Elixir of the Mongoose
{spellData(17539)}, -- 17539 Greater Arcane Elixir 
{spellData(33720)}, -- 33720 Onslaught Elixir 
{spellData(33721)}, -- 33721 Adept's Elixir 
{spellData(33726)}, -- 33726 Elixir of Mastery 
{spellData(38954)}, -- 38954 Fel Strength Elixir
{spellName(28490),"Interface\\Icons\\INV_Potion_147.blp",L["Elixir of Major Strength"]}, -- 28490 Major Strength 
{spellName(28491),"Interface\\Icons\\INV_Potion_142.blp",L["Elixir of Healing Power"]}, -- 28491 Healing Power 
{spellName(28493),"Interface\\Icons\\INV_Potion_148.blp",L["Elixir of Major Frost Power"]}, -- 28493 Major Frost Power 
{spellName(28497),"Interface\\Icons\\INV_Potion_127.blp",L["Elixir of Major Agility"]}, -- 28497 Major Agility 
{spellName(28501),"Interface\\Icons\\INV_Potion_146.blp",L["Elixir of Major Firepower"]}, -- 28501 Major Firepower 
{spellName(28503),"Interface\\Icons\\INV_Potion_145.blp",L["Elixir of Major Shadow Power"]}, -- 28503 Major Shadow Power 
{spellName(45373),"Interface\\Icons\\INV_Potion_111.blp",L["Bloodberry Elixir"]}, -- 45373 Bloodberry 
}
local BigBrother_Elixirs_Guardian={
{spellData(39625)}, -- 39625 Elixir of Major Fortitude 
{spellData(29626)}, -- 29626 Earthen Elixir 
{spellData(39627)}, -- 39627 Elixir of Draenic Wisdom 
{spellData(39628)}, -- 39628 Elixir of Ironskin 
{spellName(11348),"Interface\\Icons\\INV_Potion_66.blp",L["Elixir of Superior Defense"]}, -- 11348 Greater Armor 
{spellName(11396),"Interface\\Icons\\INV_Potion_10.blp",L["Elixir of Greater Intellect"]}, -- 11396 Greater Intellect 
{spellName(24363),"Interface\\Icons\\INV_Potion_45.blp",L["Mageblood Potion"]}, -- 24363 Mana Regeneration 
{spellName(28502),"Interface\\Icons\\INV_Potion_66.blp",L["Elixir of Major Defense"]}, -- 28502 Major Armor 
{spellName(28509),"Interface\\Icons\\INV_Potion_151.blp",L["Elixir of Major Mageblood"]}, -- 28509 Greater Mana Regeneration 
{spellName(28514),"Interface\\Icons\\INV_Potion_136.blp",L["Elixir of Empowerment"]}, -- 28514 Empowerment 
}
local BigBrother_Foodbuffs={
{spellData(35272)}, -- 35272 Well Fed 
{spellData(44106)}, -- 44106 "Well Fed" from Brewfest 
--{L["Well Fed"],"Interface\\Icons\\Spell_Misc_Food.blp"},
--{L["\"Well Fed\""],"Interface\\Icons\\INV_Drink_23.blp"},
{spellData(43722)}, -- 43722 Enlightened 
{spellData(43730)}, -- 43730 Electrified 
}

local function Sort_RaidBuffs(a,b)
	if a.totalBuffs<b.totalBuffs then
		return true
	elseif a.totalBuffs>b.totalBuffs then
		return false
	elseif a.name<b.name then
		return true
	end
	return false
end

local function Sort_PallyBuffs(a,b)
	if a.class<b.class then
		return true
	elseif a.class>b.class then
		return false
	elseif a.name<b.name then
		return true
	end
	return false
end

local BigBrother_BuffTable={
	{
		name=L["Raid Buffs"],
		sortFunc=Sort_RaidBuffs,
		buffs={
			{{spellData(1459)},{spellData(23028)}}, -- 1459 Arcane Intellect, 230238 Arcane Brilliance
			{{spellData(1243)},{spellData(21562)}}, -- 1243 Power Word: Fortitude, 21562 Prayer of Fortitude
			{{spellData(1126)},{spellData(21849)}}, -- 1126 Mark of the Wild, 21849 Gift of the Wild
			{{spellData(976)},{spellData(27683)}}, -- 976 Shadow Protection, 27683 Prayer of Shadow Protection
			{{spellData(14752)},{spellData(27681)}} -- 14752 Divine Spirit, 27681 Prayer of Spirit
		}
	},
	{
		name=L["Paladin Buffs"],
		sortFunc=Sort_PallyBuffs,
		buffs={
			{{spellData(20217)},{spellData(25898)}}, -- 20217 Blessing of Kings, 25898 Greater Blessing of Kings
			{{spellData(19977)},{spellData(25890)}}, -- 19977 Blessing of Light, 25890 Greater Blessing of Light
			{{spellData(19740)},{spellData(25782)}}, -- 19740 Blessing of Might, 25782 Greater Blessing of Might
			{{spellData(1038)},{spellData(25895)}}, -- 1038 Blessing of Salvation, 25895 Greater Blessing of Salvation
			{{spellData(19742)},{spellData(25894)}}, -- 19742 Blessing of Wisdom, 25894 Greater Blessing of Wisdom
		}
	},
	{
		name=L["Consumables"],
		sortFunc=Sort_PallyBuffs,
		buffs={
			{},
			BigBrother_Flasks,
			BigBrother_Elixirs_Battle,
			BigBrother_Elixirs_Guardian,
      BigBrother_Foodbuffs,
		}
	}
}

function BuffWindow_Functions:CreateBuffRow(parent, xoffset, yoffset)
	local Row=CreateFrame("FRAME",nil,parent)

	Row:SetPoint("TOPLEFT",parent,"TOPLEFT",xoffset,yoffset)
	Row:SetHeight(BarHeight)
	Row:SetWidth(BarWidth)
	Row:Show()
	
	Row.Background=Row:CreateTexture(nil,"BACKGROUND")
	Row.Background:SetAllPoints(Row)
	Row.Background:SetTexture("Interface\\Buttons\\WHITE8X8.blp")
	Row.Background:SetGradientAlpha("HORIZONTAL",1.0/2,0.0,0.0,0.8,1.0/2,0.0,0.0,0.0)
	Row.Background:Show()

	Row.Name=Row:CreateFontString(nil,"OVERLAY","GameFontNormal")	
	Row.Name:SetPoint("LEFT",Row,"LEFT",4,0)
	Row.Name:SetTextColor(1.0,1.0,1.0)
	Row.Name:SetText("Test")

	

	Row.Buff={}
	for i=1,TotalBuffs do
		Row.Buff[i]=CreateFrame("FRAME",nil,Row)		
		Row.Buff[i]:SetPoint("RIGHT",Row,"RIGHT",-4-(TotalBuffs-i)*BuffSpacing,0)
		Row.Buff[i]:SetHeight(16)
		Row.Buff[i]:SetWidth(16)

		Row.Buff[i].texture=Row.Buff[i]:CreateTexture(nil,"OVERLAY")
		Row.Buff[i].texture:SetAllPoints(Row.Buff[i])
		Row.Buff[i].texture:SetTexture("Interface\\Buttons\\UI-CheckBox-Check.blp")
			
		Row.Buff[i].BuffIndex=0
		--GameTooltip:ClearLines();GameTooltip:AddLine(this.BuffName);GameTooltip:Show()
		Row.Buff[i]:SetScript("OnEnter", BuffWindow_Functions.OnEnterBuff)
		Row.Buff[i]:SetScript("OnLeave", BuffWindow_Functions.OnLeaveBuff)
		Row.Buff[i]:EnableMouse()

		Row.Buff[i]:Show()
	end

	Row.SetPlayer=BuffWindow_Functions.SetPlayer
	Row.SetBuffValue=BuffWindow_Functions.SetBuffValue
	Row.SetBuffIcon=BuffWindow_Functions.SetBuffIcon
	Row.SetBuffIndex=BuffWindow_Functions.SetBuffIndex

	return Row
end

function BuffWindow_Functions:OnEnterBuff()
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	GameTooltip:SetUnitBuff(self.unit, self.BuffIndex)
	GameTooltip:Show()
end

function BuffWindow_Functions:OnLeaveBuff()
	GameTooltip:Hide()
end


function BuffWindow_Functions:SetPlayer(player,class,unit)
	self.Name:SetText(player)
	local color=RAID_CLASS_COLORS[class]
	self.Background:SetGradientAlpha("HORIZONTAL",color.r/1.5,color.g/1.5,color.b/1.5,0.8,color.r/1.5,color.g/2,color.b/1.5,0)
end

function BuffWindow_Functions:SetBuffValue(num,enabled)
	if enabled then
		self.Buff[num]:Show()
	else
		self.Buff[num]:Hide()
	end
end

function BuffWindow_Functions:SetBuffIcon(num,texture)
	self.Buff[num].texture:SetTexture(texture)
end

function BuffWindow_Functions:SetBuffIndex(num,index,unit)
	self.Buff[num].BuffIndex=index
	self.Buff[num].unit=unit
end

function BigBrother:ToggleBuffWindow()
	if BigBrother_BuffWindow then
		if BigBrother_BuffWindow:IsShown() then
			BigBrother_BuffWindow:Hide()
		else
			BuffWindow_UpdateBuffs()
			BuffWindow_UpdateWindow()
			BigBrother_BuffWindow:Show()
		end
	else
		self:CreateBuffWindow()
	end
end

function BigBrother:CreateBuffWindow()
	local BuffWindow
--[[
	if BigBrother_BuffWindow then
		BuffWindow_UpdateBuffs()
		BuffWindow_UpdateWindow()
		BigBrother_BuffWindow:Show()
		return
	end
]]
	BuffWindow=CreateFrame("FRAME",nil,UIParent)


	BuffWindow:ClearAllPoints()
	BuffWindow:SetPoint("CENTER",UIParent)

	BuffWindow:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
                                            tile = true, tileSize = 16, edgeSize = 16, 
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
	BuffWindow:SetBackdropColor(0,0,0,0.5);

	BuffWindow:SetWidth(BarWidth+16+24);
	BuffWindow:SetHeight(190);

	BuffWindow:SetScript("OnMouseDown", function() 
						if ( ( ( not BigBrother_BuffWindow.isLocked ) or ( BigBrother_BuffWindow.isLocked == 0 ) ) and ( arg1 == "LeftButton" ) ) then
						  BigBrother_BuffWindow:StartMoving();
						  BigBrother_BuffWindow.isMoving = true;
						 end
						end)
	BuffWindow:SetScript("OnMouseUp", function() 
						if ( BigBrother_BuffWindow.isMoving ) then
						  BigBrother_BuffWindow:StopMovingOrSizing();
						  BigBrother_BuffWindow.isMoving = false;
						 end
						end)
					
	BuffWindow:SetScript("OnHide", function() 
						if ( BigBrother_BuffWindow.isMoving ) then
						  BigBrother_BuffWindow:StopMovingOrSizing();
						  BigBrother_BuffWindow.isMoving = false;
						 end
						end)
	

	BuffWindow:SetMovable(true)
	BuffWindow:EnableMouse()
	BuffWindow:Show()

	BuffWindow.Title=BuffWindow:CreateFontString(nil,"OVERLAY","GameFontNormal")
	BuffWindow.Title:SetPoint("TOP",BuffWindow,"TOP",0,-8)
	BuffWindow.Title:SetTextColor(1.0,1.0,1.0)

	BuffWindow.LeftButton=CreateFrame("Button",nil,BuffWindow)
	BuffWindow.LeftButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up.blp")
	BuffWindow.LeftButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down.blp")
	BuffWindow.LeftButton:SetWidth(16)
	BuffWindow.LeftButton:SetHeight(18)
	BuffWindow.LeftButton:SetPoint("TOPLEFT",BuffWindow,"TOPLEFT",64,-5)
	BuffWindow.LeftButton:SetScript("OnClick",function() 
							BigBrother_BuffWindow.SelectedBuffs=BigBrother_BuffWindow.SelectedBuffs-1
							if BigBrother_BuffWindow.SelectedBuffs==0 then
								BigBrother_BuffWindow.SelectedBuffs=table.getn(BigBrother_BuffTable)
							end
							BuffWindow_UpdateBuffs()
							BuffWindow_UpdateWindow()
						end)

	BuffWindow.RightButton=CreateFrame("Button",nil,BuffWindow)
	BuffWindow.RightButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up.blp")
	BuffWindow.RightButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down.blp")
	
	BuffWindow.RightButton:SetWidth(16)
	BuffWindow.RightButton:SetHeight(18)
	BuffWindow.RightButton:SetPoint("TOPRIGHT",BuffWindow,"TOPRIGHT",-64,-5)
	BuffWindow.RightButton:SetScript("OnClick",function() 
							BigBrother_BuffWindow.SelectedBuffs=BigBrother_BuffWindow.SelectedBuffs+1
							if BigBrother_BuffWindow.SelectedBuffs>table.getn(BigBrother_BuffTable) then
								BigBrother_BuffWindow.SelectedBuffs=1
								
							end
							BuffWindow_UpdateBuffs()
							BuffWindow_UpdateWindow()
						end)
	
	BuffWindow.CloseButton=CreateFrame("Button",nil,BuffWindow)
	BuffWindow.CloseButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up.blp")
	BuffWindow.CloseButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
	BuffWindow.CloseButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	BuffWindow.CloseButton:SetWidth(20)
	BuffWindow.CloseButton:SetHeight(20)
	BuffWindow.CloseButton:SetPoint("TOPRIGHT",BuffWindow,"TOPRIGHT",-4,-4)
	BuffWindow.CloseButton:SetScript("OnClick",function() BigBrother_BuffWindow:Hide() end)


	BuffWindow.Rows={}
	for i=1,PlayersShown do
		BuffWindow.Rows[i]=BuffWindow_Functions:CreateBuffRow(BuffWindow,8,-4-i*(BuffSpacing+2))
	end

	RowsCreated=PlayersShown

	BuffWindow.ScrollBar=CreateFrame("SCROLLFRAME","BuffWindow_ScrollBar",BuffWindow,"FauxScrollFrameTemplate")
	BuffWindow.ScrollBar:SetScript("OnVerticalScroll", function() FauxScrollFrame_OnVerticalScroll(20, BuffWindow_UpdateWindow) end)

	BuffWindow.ScrollBar:SetPoint("TOPLEFT", BuffWindow.Rows[1], "TOPLEFT", 0, 0)
	BuffWindow.ScrollBar:SetPoint("BOTTOMRIGHT", BuffWindow.Rows[8], "BOTTOMRIGHT", 0, 0)




	-- drag handle
	
	BuffWindow.draghandle = CreateFrame("Frame", nil, BuffWindow)
	BuffWindow.draghandle:Show()
	BuffWindow.draghandle:SetFrameLevel( BuffWindow:GetFrameLevel() + 10 ) -- place this above everything
	BuffWindow.draghandle:SetWidth(BarWidth+16+24)
	BuffWindow.draghandle:SetHeight(16)
	BuffWindow.draghandle:SetPoint("BOTTOM", BuffWindow, "BOTTOM", 0, 0)
	BuffWindow.draghandle:EnableMouse(true)
	BuffWindow.draghandle:SetScript("OnMouseDown", function() this:GetParent().isResizing = true; this:GetParent():StartSizing("BOTTOMRIGHT") end )
	BuffWindow.draghandle:SetScript("OnMouseUp", function() this:GetParent():StopMovingOrSizing(); this:GetParent().isResizing = false; end )
	
	BuffWindow:SetMinResize(BarWidth+16+24,110)
	BuffWindow:SetMaxResize(BarWidth+16+24,530.5)	
	BuffWindow:SetResizable(true);

	BuffWindow:SetScript("OnSizeChanged", function()
						if ( BigBrother_BuffWindow.isResizing ) then
							BuffWindow_ResizeWindow()
						end
					end)
    

	BigBrother_BuffWindow=BuffWindow
	BigBrother_BuffWindow.SelectedBuffs=1
	BuffWindow_UpdateBuffs()
	BuffWindow_UpdateWindow()
end

--When called will update buffs and the window
function BigBrother:BuffWindow_Update()
	BuffWindow_UpdateBuffs()
	BuffWindow_UpdateWindow()
end



--When called will update the table of what buffs everyone has
function BuffWindow_UpdateBuffs()
	local unit
	local PlayerList={}
	local BuffChecking=BigBrother_BuffTable[BigBrother_BuffWindow.SelectedBuffs]
	local Filter=BuffChecking.filter

	for unit in RL:IterateRoster(false) do
		if BigBrother.db.profile.Groups[unit.subgroup] then
      if (not Filter) or Filter[unit.class] then
  			local player={}
  			player.name=unit.name
  			player.class=unit.class
  			player.totalBuffs=0
  			player.buff={}
				player.buffIndex={}
				player.unit=unit.unitid
  			for i, BuffList in pairs(BuffChecking.buffs) do
  				for _, buffs in pairs(BuffList) do
  					local index = aura:UnitHasBuff(unit.unitid, buffs[1])
						if index then
  						player.totalBuffs=player.totalBuffs+1
  						player.buff[i]=buffs
							player.buffIndex[i] = index
  						break
  					end
  				end
  			end
  			table.insert(PlayerList,player)
  		end
    end
	end

	table.sort(PlayerList,BuffChecking.sortFunc)
	BigBrother_BuffWindow.List=PlayerList
end

function BuffWindow_UpdateWindow()
	local PlayerList=BigBrother_BuffWindow.List
	local Rows=BigBrother_BuffWindow.Rows
	
	FauxScrollFrame_Update(BigBrother_BuffWindow.ScrollBar, table.getn(PlayerList), PlayersShown, 20)
	local offset = FauxScrollFrame_GetOffset(BigBrother_BuffWindow.ScrollBar)
	
	BigBrother_BuffWindow.Title:SetText(BigBrother_BuffTable[BigBrother_BuffWindow.SelectedBuffs].name)

	for i=1,PlayersShown do
		if PlayerList[i+offset] then
			local Player=PlayerList[i+offset]
			Rows[i]:SetPlayer(Player.name,Player.class,Player.unit)
			for j=1,5 do
				if Player.buff[j] then
					Rows[i]:SetBuffIcon(j,Player.buff[j][2])
					Rows[i]:SetBuffIndex(j,Player.buffIndex[j], Player.unit)
					Rows[i]:SetBuffValue(j,true)
				else
					Rows[i]:SetBuffValue(j,false)
				end
			end
			Rows[i]:Show()
		else
			Rows[i]:Hide()
		end
	end
end

function BuffWindow_ResizeWindow()

	local NumVisibleRows=math.floor( (BigBrother_BuffWindow:GetHeight() - (BuffSpacing+4)-8) / (BuffSpacing+2) )

	if NumVisibleRows>RowsCreated then
		for i=(1+RowsCreated),NumVisibleRows do
			BigBrother_BuffWindow.Rows[i]=BuffWindow_Functions:CreateBuffRow(BigBrother_BuffWindow,8,-4-i*(BuffSpacing+2))
			BigBrother_BuffWindow.Rows[i]:Hide()
		end
		RowsCreated=NumVisibleRows
	end

	if NumVisibleRows<PlayersShown then
		for i=(1+NumVisibleRows),PlayersShown do
			BigBrother_BuffWindow.Rows[i]:Hide()
		end
	end
	PlayersShown=NumVisibleRows

	BigBrother_BuffWindow.ScrollBar:SetPoint("BOTTOMRIGHT", BigBrother_BuffWindow.Rows[PlayersShown], "BOTTOMRIGHT", 0, 0)
	BuffWindow_UpdateWindow()
end

