--[[
    Necrosis LdC
    Copyright (C) 2005-2006  Lom Enfroy

    This file is part of Necrosis LdC.

    Necrosis LdC is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Necrosis LdC is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Necrosis LdC; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--]]

------------------------------------------------------------------------------------------------------
-- Necrosis LdC
-- Originally by Lomig, Liadora et Nyx (Kael'Thas et Elune) [2005-2007]
-- Now updated by Tarcalion (Nagrand US/Oceanic) [2008-...]
--
-- Skins and French voices: Eliah, Ner'zhul
--
-- German Version by Geschan
-- Spanish Version by DosS (Zul’jin)
--
-- Version $LastChangedDate: 2008-03-30 15:05:46 +1000 $
------------------------------------------------------------------------------------------------------

--[[ ClickBinder

	This is an embedded library to present a UI for users to define
	key bindings for click buttons.

	To use, create a table similar to this:

	mytable = {
	  { "Use action 1", "CLICK SecureButtonName1:LeftButton" },
	  { "Another action", "CLICK SecureButtonName2:RightButton" },
	  { "Yet another", "CLICK AThirdButton:LeftButton" },
	  { "Fortitude", "SPELL Power Word: Fortitude"},
	  { "Mount", "ITEM Swift Green Mechanostrider"},
	  { "Set Assist", "MACRO Set Assist"},
	  etc
	}

	The first element of each entry is a text description of the button.
	The second element is the click binding "action", in one of these
	formats:

						CLICK ButtonName:MouseButton
						SPELL Spell Name
						ITEM Item Name
						MACRO Macro Name

	Once defined, call ClickBinder.Open("Title",table)

	"Title" is only used as a header in the window. (your mod name)
	table is the table defined above.

	You can have different

]]

local VERSION = 900.7 -- change this value always

if not ClickBinder or ClickBinder.version<VERSION then

	ClickBinder = { version = VERSION }

	function ClickBinder.CreateButton(idx,description,action)
		local frame = getglobal("ClickBinderEntry"..idx)
		if not frame then
			frame = CreateFrame("Frame","ClickBinderEntry"..idx,ClickBinderFrame)
			frame:SetWidth(248)
			frame:SetHeight(24)
			local font = frame:CreateFontString("ClickBinderEntry"..idx.."Label","BACKGROUND","GameFontNormalSmall")
			font:SetWidth(102)
			font:SetHeight(24)
			font:SetPoint("TOPLEFT",frame,"TOPLEFT",16,0)
			font:SetJustifyH("LEFT")
			local button = CreateFrame("Button","ClickBinderEntry"..idx.."Button",frame,"UIPanelButtonTemplate2")
			button:SetWidth(120)
			button:SetHeight(24)
			button:SetPoint("TOPLEFT",font,"TOPRIGHT")
			button:SetTextFontObject("GameFontHighlightSmall")
			button:SetHighlightFontObject("GameFontHighlightSmall")
			button:SetScript("OnClick",ClickBinder.StartBinding)
		end
		frame:SetPoint("TOP",ClickBinderFrame,"TOP",0,-(8+(idx*24))-(ClickBinderFrame.numBindings<3 and 24 or 0))
		frame.description = description
		frame.action = action
		return frame
	end

	function ClickBinder.HideButtons()
		local i=1
		while getglobal("ClickBinderEntry"..i) do
			getglobal("ClickBinderEntry"..i):Hide()
			i=i+1
		end
		ClickBinderClose:Hide()
	end

	function ClickBinder.ShowButtons()
		if ClickBinderFrame and tonumber(ClickBinderFrame.numBindings) then
			for i=1,ClickBinderFrame.numBindings do
				getglobal("ClickBinderEntry"..i):Show()
			end
			ClickBinder.DisplayBindings()
		end
		ClickBinderClose:Show()
	end

	function ClickBinder.DisplayBindings()
		local frame,key
		for i=1,ClickBinderFrame.numBindings do
			frame = getglobal("ClickBinderEntry"..i)
			key = frame.action and GetBindingKey(frame.action)
			getglobal("ClickBinderEntry"..i.."Button"):SetText((key or key~="") and key or NORMAL_FONT_COLOR_CODE..NECROSIS_BINDING.NotBound..FONT_COLOR_CODE_CLOSE)
			getglobal("ClickBinderEntry"..i.."Label"):SetText(frame.description)
		end
	end

	-- only function that should be called, summons and builds the binding window
	function ClickBinder.Open(title,bindings,anchorTo)
		if type(bindings)~="table" or #(bindings)<1 then
			return
		end
		if not ClickBinderFrame then
			ClickBinder.CreateFrames()
		end
		ClickBinderTitle:SetText(title)
		ClickBinder.HideButtons()
		ClickBinderFrame.numBindings = #(bindings)
		ClickBinderFrame:SetHeight(math.max(160,48+(ClickBinderFrame.numBindings*24)))
		for i=1,#(bindings) do
			ClickBinder.CreateButton(i,bindings[i][1],bindings[i][2])
		end
		ClickBinder.ShowButtons()
		ClickBinder.DisplayBindings()
		ClickBinderFrame:Show()
		if anchorTo then
			ClickBinderFrame:SetUserPlaced(0)
			ClickBinderFrame:SetPoint("CENTER",anchorTo,"CENTER")
		end
	end

	function ClickBinder.Toggle(title,bindings,anchorTo)
		if ClickBinderFrame and ClickBinderFrame:IsVisible() then
			ClickBinderFrame:Hide()
		else
			ClickBinder.Open(title,bindings,anchorTo)
		end
	end

	function ClickBinder.CreateFrames()
		-- ClickBinderFrame is the primary frame/border
		local frame = CreateFrame("Frame","ClickBinderFrame",UIParent)
		frame:SetFrameStrata("DIALOG")
		frame:EnableMouse(1)
		frame:SetToplevel(1)
		frame:SetMovable(1)
		frame:SetScript("OnMouseDown",function() this:StartMoving() end)
		frame:SetScript("OnMouseUp",function() this:StopMovingOrSizing() end)
		frame:SetWidth(256)
		frame:SetPoint("CENTER",UIParent,"CENTER")
		frame:SetBackdrop( { edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 32 } )
		local back = frame:CreateTexture(nil,"BACKGROUND")
		back:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		back:SetPoint("TOPLEFT",frame,"TOPLEFT",11,-12)
		back:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",-12,11)
		back:SetGradient("VERTICAL",.1,.1,.1,.25,.25,.25)
		frame:SetScript("OnHide",ClickBinder.OnHide)
		local header = frame:CreateTexture(nil,"ARTWORK")
		header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
		header:SetWidth(300)
		header:SetHeight(64)
		header:SetPoint("TOP",frame,"TOP",0,12)
		local title = frame:CreateFontString("ClickBinderTitle","ARTWORK","GameFontNormal")
		title:SetPoint("TOP",frame,"TOP",0,-2)
		-- ClickBinderBindFrame captures key bindings
		local bindFrame = CreateFrame("Frame","ClickBinderBindFrame",ClickBinderFrame)
		bindFrame:SetAllPoints(frame)
		bindFrame:Hide()
		bindFrame:SetScript("OnShow",ClickBinder.HideButtons)
		bindFrame:SetScript("OnHide",ClickBinder.ShowButtons)
		bindFrame:SetScript("OnKeyDown",ClickBinder.BindKeyDown)
		bindFrame:SetScript("OnMouseDown",ClickBinder.BindKeyDown)
		bindFrame:EnableKeyboard(1)
		bindFrame:EnableMouse(1)
		local press = bindFrame:CreateFontString(nil,"ARTWORK","GameFontNormalLarge")
		press:SetPoint("CENTER",bindFrame,"CENTER",0,32)
		press:SetText(NECROSIS_BINDING.Press)
		press:SetTextColor(.8,.8,.8)
		local action = bindFrame:CreateFontString("ClickBinderAction","ARTWORK","GameFontNormalLarge")
		action:SetPoint("CENTER",bindFrame,"CENTER",0,8)
		local current = bindFrame:CreateFontString("ClickBinderCurrent","ARTWORK","GameFontNormal")
		current:SetPoint("CENTER",bindFrame,"CENTER",0,-16)
		current:SetTextColor(.8,.8,.8)
		table.insert(UISpecialFrames,"ClickBinderFrame")
		-- buttons
		local cancel = CreateFrame("Button","ClickBinderBindCancel",bindFrame,"UIPanelButtonTemplate2")
		cancel:SetWidth(80)
		cancel:SetHeight(26)
		cancel:SetPoint("BOTTOMRIGHT",bindFrame,"BOTTOMRIGHT",-12,12)
		cancel:SetText(NECROSIS_BINDING.Cancel)
		cancel:SetScript("OnClick",function() ClickBinderBindFrame:Hide() end)
		local unbind = CreateFrame("Button","ClickBinderBindUnbind",bindFrame,"UIPanelButtonTemplate2")
		unbind:SetWidth(80)
		unbind:SetHeight(26)
		unbind:SetPoint("TOPRIGHT",cancel,"TOPLEFT",-2,0)
		unbind:SetText(NECROSIS_BINDING.Unbind)
		unbind:SetScript("OnClick",function() ClickBinder.UnbindKey() ClickBinderBindFrame:Hide() end)
		local closeb = CreateFrame("Button","ClickBinderClose",ClickBinderFrame)
		closeb:SetWidth(28)
		closeb:SetHeight(28)
		closeb:SetPoint("TOPRIGHT",ClickBinderFrame,"TOPRIGHT",-8,-8)
		closeb:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		closeb:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
		closeb:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
		closeb:SetScript("OnClick",function() ClickBinderFrame:Hide() end)
	end

	function ClickBinder.StartBinding()
		ClickBinder.HideButtons()
		ClickBinderBindFrame:Show()
		ClickBinderBindFrame.description = this:GetParent().description or ""
		ClickBinderBindFrame.action = this:GetParent().action or ""
		ClickBinderAction:SetText(ClickBinderBindFrame.description)
		ClickBinderCurrent:SetText(NECROSIS_BINDING.Now..(GetBindingKey(ClickBinderBindFrame.action) or NECROSIS_BINDING.NotBound))
	end

	function ClickBinder.BindKeyDown()
		if arg1=="ESCAPE" then
			ClickBinderBindFrame:Hide()
			return
		end
		local screenshotKey = GetBindingKey("SCREENSHOT");
		if ( screenshotKey and arg1 == screenshotKey ) then
			Screenshot();
			return;
		end
		local button
		-- Convert the mouse button names
		if ( arg1 == "LeftButton" ) then
			button = "BUTTON1"
		elseif ( arg1 == "RightButton" ) then
			button = "BUTTON2"
		elseif ( arg1 == "MiddleButton" ) then
			button = "BUTTON3"
		elseif ( arg1 == "Button4" ) then
			button = "BUTTON4"
		elseif ( arg1 == "Button5" ) then
			button = "BUTTON5"
		end
		local keyPressed
		if ( button ) then
			if ( button == "BUTTON1" or button == "BUTTON2" ) then
				return;
			end
			keyPressed = button;
		else
			keyPressed = arg1;
		end
		if keyPressed=="UNKNOWN" or keyPressed=="SHIFT" or keyPressed=="CTRL" or keyPressed=="ALT" then
			return
		end
		if ( IsShiftKeyDown() ) then
			keyPressed = "SHIFT-"..keyPressed
		end
		if ( IsControlKeyDown() ) then
			keyPressed = "CTRL-"..keyPressed
		end
		if ( IsAltKeyDown() ) then
			keyPressed = "ALT-"..keyPressed
		end
		if keyPressed then
			ClickBinderBindFrame.keyPressed = keyPressed
			local oldAction = GetBindingAction(keyPressed)
			if oldAction~="" and keyPressed~=ClickBinderBindFrame.action then
				StaticPopupDialogs["ClickBinder_CONFIRMBINDING"] = {
					text = NORMAL_FONT_COLOR_CODE..keyPressed..FONT_COLOR_CODE_CLOSE.."\n"..NECROSIS_BINDING.Current.."\n"..NORMAL_FONT_COLOR_CODE..(GetBindingText(oldAction,"BINDING_NAME_") or "")..FONT_COLOR_CODE_CLOSE.."\n\n"..NECROSIS_BINDING.Confirm.."\n"..NORMAL_FONT_COLOR_CODE..keyPressed..FONT_COLOR_CODE_CLOSE.."\n"..NECROSIS_BINDING.To.."\n"..NORMAL_FONT_COLOR_CODE..ClickBinderBindFrame.description..FONT_COLOR_CODE_CLOSE.." ?",
					button1 = NECROSIS_BINDING.Yes,
					button2 = NECROSIS_BINDING.No,
					timeout = 0,
					hideOnEscape = 1,
					OnAccept = ClickBinder.SetKeyBinding,
					OnCancel = ClickBinder.ResetBindFrame
				}
				ClickBinderBindFrame:EnableKeyboard(0) -- turn off keyboard catching
				ClickBinderBindCancel:Disable()
				ClickBinderBindUnbind:Disable()
				StaticPopup_Show("ClickBinder_CONFIRMBINDING")
			else
				ClickBinder.SetKeyBinding()
			end
		end
	end

	function ClickBinder.SetKeyBinding()
		if not InCombatLockdown() then
			local _,_,bindType,bindee = string.find(ClickBinderBindFrame.action,"^(%w+) (.+)$")
			local _,_,button,mouse = string.find(bindee or "","(.+):(.-)$")
			local key = ClickBinderBindFrame.keyPressed
			if bindType and bindee and key then
				ClickBinder.UnbindKey()
				if bindType=="CLICK" and button and mouse then
					SetBindingClick(key,button,mouse)
				elseif bindType=="SPELL" then
					SetBindingSpell(key,bindee)
				elseif bindType=="ITEM" then
					SetBindingItem(key,bindee)
				elseif bindType=="MACRO" then
					SetBindingMacro(key,bindee)
				end
			end
		else
			Necrosis_Msg(NECROSIS_BINDING.InCombat);
		end
		ClickBinder.ResetBindFrame()
		ClickBinder.DisplayBindings()
		ClickBinderBindFrame:Hide()
	end

	function ClickBinder.ResetBindFrame()
		ClickBinderBindFrame:EnableKeyboard(1)
		ClickBinderBindCancel:Enable()
		ClickBinderBindUnbind:Enable()
	end

	function ClickBinder.UnbindKey()
		if not InCombatLockdown() and ClickBinderBindFrame.action then
			while GetBindingKey(ClickBinderBindFrame.action) do
				SetBinding(GetBindingKey(ClickBinderBindFrame.action))
			end
		end
	end

	function ClickBinder.OnHide()
		SaveBindings(GetCurrentBindingSet())
		ClickBinder.ResetBindFrame()
		ClickBinderBindFrame:Hide()
	end

end
