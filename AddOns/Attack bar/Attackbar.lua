pont=0.000
pofft= 0.000
ont = 0.000
offt= 0.000
ons = 0.000
offs= 0.000
offh = 0
onh  = 0
epont=0.000
epofft= 0.000
eont = 0.000
eofft= 0.000
eons = 0.000
eoffs= 0.000
eoffh = 0
eonh  = 0
testvar = 0
if not(abar) then abar={} end
function Abar_loaded()
	SlashCmdList["ATKBAR"] = Abar_chat;
	SLASH_ATKBAR1 = "/abar";
	SLASH_ATKBAR2 = "/atkbar";
	if abar.range == nil then
		abar.range=true
	end
	if abar.h2h == nil then
		abar.h2h=true
	end
	if abar.timer == nil then
		abar.timer=true
	end
	if abar.mob == nil then
		abar.mob=true
	end
	if abar.pvp == nil then
		abar.pvp=true
	end
	if abar.text == nil then
		abar.text="standard"
	end
	if abar.info == nil then
		abar.info=true
	end
	Abar_Mhr:SetPoint("LEFT",Abar_Frame,"TOPLEFT",6,-13)
	Abar_Oh:SetPoint("LEFT",Abar_Frame,"TOPLEFT",6,-35)
	Abar_MhrText:SetJustifyH("Left")
	Abar_OhText:SetJustifyH("Left")
	ebar_VL()
		local Border = "Border"
		local Bordern = "Bordern"
		if abar.text == "thin" then
		getglobal(Abar_Mhr:GetName()..Border):Hide()
		getglobal(Abar_Oh:GetName()..Border):Hide()
		getglobal(ebar_mh:GetName()..Border):Hide()
		getglobal(ebar_oh:GetName()..Border):Hide()
		getglobal(Abar_Mhr:GetName()..Bordern):Show()
		getglobal(Abar_Oh:GetName()..Bordern):Show()
		getglobal(ebar_mh:GetName()..Bordern):Show()
		getglobal(ebar_oh:GetName()..Bordern):Show()
		elseif abar.text == "none" then
		getglobal(Abar_Mhr:GetName()..Bordern):Hide()
		getglobal(Abar_Oh:GetName()..Bordern):Hide()
		getglobal(ebar_mh:GetName()..Bordern):Hide()
		getglobal(ebar_oh:GetName()..Bordern):Hide()
		getglobal(Abar_Mhr:GetName()..Border):Hide()
		getglobal(Abar_Oh:GetName()..Border):Hide()
		getglobal(ebar_mh:GetName()..Border):Hide()
		getglobal(ebar_oh:GetName()..Border):Hide()
		else
		abar.text = "standard"
		getglobal(Abar_Mhr:GetName()..Bordern):Hide()
		getglobal(Abar_Oh:GetName()..Bordern):Hide()
		getglobal(ebar_mh:GetName()..Bordern):Hide()
		getglobal(ebar_oh:GetName()..Bordern):Hide()
		getglobal(Abar_Mhr:GetName()..Border):Show()
		getglobal(Abar_Oh:GetName()..Border):Show()
		getglobal(ebar_mh:GetName()..Border):Show()
		getglobal(ebar_oh:GetName()..Border):Show()
		end
end
function Abar_chat(msg)
	msg = strlower(msg)
	if msg == "fix" then
		Abar_reset()
	elseif msg=="lock" then
		Abar_Frame:Hide()
		ebar_Frame:Hide()
	elseif msg=="unlock" then
		Abar_Frame:Show()
		ebar_Frame:Show()
	elseif msg=="range" then
		abar.range= not(abar.range)
		DEFAULT_CHAT_FRAME:AddMessage('range is'.. Abar_Boo(abar.range));
	elseif msg=="h2h" then
		abar.h2h = not(abar.h2h)
		DEFAULT_CHAT_FRAME:AddMessage('H2H is'.. Abar_Boo(abar.h2h));
	elseif msg=="timer" then
		abar.timer = not(abar.timer)
		DEFAULT_CHAT_FRAME:AddMessage('timer is'.. Abar_Boo(abar.timer));
	elseif msg=="pvp" then
		abar.pvp = not(abar.pvp)
		DEFAULT_CHAT_FRAME:AddMessage('pvp is'.. Abar_Boo(abar.pvp));
	elseif msg=="text" then
		local Border = "Border"
		local Bordern = "Bordern"
		if abar.text == "standard" then
		abar.text = "thin"
		getglobal(Abar_Mhr:GetName()..Border):Hide()
		getglobal(Abar_Oh:GetName()..Border):Hide()
		getglobal(ebar_mh:GetName()..Border):Hide()
		getglobal(ebar_oh:GetName()..Border):Hide()
		getglobal(Abar_Mhr:GetName()..Bordern):Show()
		getglobal(Abar_Oh:GetName()..Bordern):Show()
		getglobal(ebar_mh:GetName()..Bordern):Show()
		getglobal(ebar_oh:GetName()..Bordern):Show()
		elseif abar.text == "thin" then
		abar.text = "none"
		getglobal(Abar_Mhr:GetName()..Bordern):Hide()
		getglobal(Abar_Oh:GetName()..Bordern):Hide()
		getglobal(ebar_mh:GetName()..Bordern):Hide()
		getglobal(ebar_oh:GetName()..Bordern):Hide()
		getglobal(Abar_Mhr:GetName()..Border):Hide()
		getglobal(Abar_Oh:GetName()..Border):Hide()
		getglobal(ebar_mh:GetName()..Border):Hide()
		getglobal(ebar_oh:GetName()..Border):Hide()
		else
		abar.text = "standard"
		getglobal(Abar_Mhr:GetName()..Bordern):Hide()
		getglobal(Abar_Oh:GetName()..Bordern):Hide()
		getglobal(ebar_mh:GetName()..Bordern):Hide()
		getglobal(ebar_oh:GetName()..Bordern):Hide()
		getglobal(Abar_Mhr:GetName()..Border):Show()
		getglobal(Abar_Oh:GetName()..Border):Show()
		getglobal(ebar_mh:GetName()..Border):Show()
		getglobal(ebar_oh:GetName()..Border):Show()
		end
		DEFAULT_CHAT_FRAME:AddMessage("Attack bar textures are ".. abar.text)
	elseif msg=="mob" then
		abar.mob = not(abar.mob)
		DEFAULT_CHAT_FRAME:AddMessage('mobs are'.. Abar_Boo(abar.mob))
	elseif msg=="info" then
		abar.info = not (abar.info)
		DEFAULT_CHAT_FRAME:AddMessage('mobs are'.. Abar_Boo(abar.info))
	else
		DEFAULT_CHAT_FRAME:AddMessage('use any of these to control Abar:')
		DEFAULT_CHAT_FRAME:AddMessage('Lock- to lock and hide the anchor')
		DEFAULT_CHAT_FRAME:AddMessage('unlock- to unlock and show the anchor')
		DEFAULT_CHAT_FRAME:AddMessage('fix- to reset the values should they go awry, wait 5 sec after attacking to use this command')
		DEFAULT_CHAT_FRAME:AddMessage('h2h- to turn on and off the melee bar(s)')
		DEFAULT_CHAT_FRAME:AddMessage('range- to turn on and off the ranged bar')
		DEFAULT_CHAT_FRAME:AddMessage('pvp- to turn on and off the enemy player bar(s)')
		DEFAULT_CHAT_FRAME:AddMessage('mob- to turn on and off the enemy mob bar(s)')
		DEFAULT_CHAT_FRAME:AddMessage('text- toggle from standard to line to no texture')
		DEFAULT_CHAT_FRAME:AddMessage('info- toggle the info')
	end
end
function Abar_selfhit()
  local go = true;
	ons,offs=UnitAttackSpeed("player");
	hd,ld,ohd,old = UnitDamage("player")
	hd,ld= hd-math.fmod(hd,1),ld-math.fmod(ld,1)
	if old then
		ohd,old = ohd-math.fmod(ohd,1),old-math.fmod(old,1)
	end	
	if offs then
	ont,offt=GetTime(),GetTime()
	if ((math.abs((ont-pont)-ons) <= math.abs((offt-pofft)-offs))and not(onh <= offs/ons)) or offh >= 	ons/offs then
		if pofft == 0 then pofft=offt end
			pont = ont
			tons = ons
			offh = 0
			onh = onh +1
			ons = ons - math.fmod(ons,0.01)
			Abar_Mhrs(tons,"Main["..ons.."s]("..hd.."-"..ld..")",0,0,1)
		else
			pofft = offt
			offh = offh+1
			onh = 0
			ohd,old = ohd-math.fmod(ohd,1),old-math.fmod(old,1)
			offs = offs - math.fmod(offs,0.01)
			Abar_Ohs(offs,"Off["..offs.."s]("..ohd.."-"..old..")",0,0,1)
		end
	else
		ont=GetTime()
		tons = ons
		ons = ons - math.fmod(ons,0.01)
		Abar_Mhrs(tons,"Main["..ons.."s]("..hd.."-"..ld..")",0,0,1)
--	end
end
end
function Abar_reset()
pont=0.000
pofft= 0.000
ont=0.000
offt= 0.000
onid=0
offid=0
lastus=0.000
end
function Abar_event(event)
  if event == "VARIABLES_LOADED" then Abar_loaded() end  
	
  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
	if arg3 and arg7 then
		if arg3 == UnitGUID("player") and arg6 == UnitGUID("playertarget") then
			if arg2 == "SWING_DAMAGE" or arg2 == "SWING_MISSED" then
				Abar_selfhit()
				return
			end
			if arg2 == "RANGE_DAMAGE" or arg2 == "RANGE_MISSED" then
				abar_spelldir(arg10, 1)
				return
			end
			if arg2 == "SPELL_DAMAGE" or arg2 == "SPELL_MISSED" then
				abar_spelldir(arg10,1)
				return
			end
		end
		if arg3 == UnitGUID("playertarget") and arg6 == UnitGUID("playertargettarget") and abar.mob == true then
			if arg2 == "SWING_DAMAGE" or arg2 == "SWING_MISSED" then
				ebar_set("")
				
				if arg2 == "SWING_MISSED" and arg9 == "PARRY" and arg6 == UnitGUID("player") then
					Abar_parry("")
--					if arg9 then message(arg9) end
				end
				return
			end
		end
	end  
  end


  if event == "UNIT_SPELLCAST_SENT" then abar_spelldir(arg2, 0) end	
  if event=="PLAYER_LEAVE_COMBAT" then Abar_reset() end 
  if event == "UNIT_ATTACK_SPEED" then
	a,b = UnitAttackSpeed("player")
	if (not(lastus == a) and Abar_Mhr.st) then
		lastus = a
		Abar_Mhr.et = Abar_Mhr.st + a
		Abar_Mhr:SetMinMaxValues(Abar_Mhr.st,Abar_Mhr.et)
		Abar_Mhr:SetValue(GetTime())
		if b then
			Abar_Oh.et = Abar_Oh.st + b
			Abar_Oh:SetMinMaxValues(Abar_Oh.st,Abar_Oh.et)
			Abar_Oh:SetValue(GetTime())
		end
	end
  end
end
function Abar_parry(arg1)
--	local a,b, hitter = string.find (arg1, "(.+) attacks. You parry")
--	if hitter then
		local curtime = GetTime()
		local stt = Abar_Mhr.st
		local ett = Abar_Mhr.et
		local wspd = UnitAttackSpeed("player")
		local bpos = curtime - stt
		if .4 * wspd < (wspd - bpos) then
			Abar_Mhr.et = Abar_Mhr.et - .4 * wspd
			Abar_Mhr:SetMinMaxValues(Abar_Mhr.st,Abar_Mhr.et)
			Abar_Mhr:SetValue(curtime)
		end
--	end
end
function Abar_spellhit(arg1)

end
function abar_spelldir(spellname, prs)
	spell = spellname
	if (spell == "Raptor Strike" or spell == "Heroic Strike" or
	spell == "Maul" or spell == "Cleave" or spell == "Slam") and abar.h2h==true and prs == 1 then
		hd,ld,ohd,lhd = UnitDamage("player")
		hd,ld= hd-math.fmod(hd,1),ld-math.fmod(ld,1)
		if pofft == 0 then pofft=offt end
		pont = ont
		tons = ons
		ons = ons - math.fmod(ons,0.01)
		Abar_Mhrs(tons,"Main["..ons.."s]("..hd.."-"..ld..")",0,0,1)
	elseif abar.range then
	        rs,rhd,rld =UnitRangedDamage("player");
			rhd,rld= rhd-math.fmod(rhd,1),rld-math.fmod(rld,1)
			if prs == 0 then 					
				if spellname == "Throw" then
					rs = rs-math.fmod(rs,0.01)
					Abar_Mhrs(.5,spellname .. "["..(rs).."s]("..rhd.."-"..rld..")",1,.5,0)
				elseif spellname == "Shoot" then
					rs = rs-math.fmod(rs,0.01)
					Abar_Mhrs(.5,"Range["..(rs).."s]("..rhd.."-"..rld..")",.5,0,1)
				elseif spellname == "Shoot Bow" then
					rs = rs-math.fmod(rs,0.01)
					Abar_Mhrs(.5,"Bow["..(rs).."s]("..rhd.."-"..rld..")",1,.5,0)
				elseif spellname == "Shoot Gun" then
					rs = rs-math.fmod(rs,0.01)
					Abar_Mhrs(.5,"Gun["..(rs).."s]("..rhd.."-"..rld..")",1,.5,0)
				elseif spellname == "Shoot Crossbow" then
					rs = rs-math.fmod(rs,0.01)
					Abar_Mhrs(.5,"X-Bow["..(rs).."s]("..rhd.."-"..rld..")",1,.5,0)
				elseif spellname == "Aimed Shot" then
					Abar_Mhrs(3,"Aiming["..(3).."s]",1,.1,.1)
				end
			elseif prs == 1 then
				trs=rs
				rs = rs-math.fmod(rs,0.01)
				Abar_Mhrs(trs,spellname .. "["..(rs).."s]("..rhd.."-"..rld..")",1,.5,0)
			end
	end
end
	
function Abar_Update()
	local ttime = GetTime()
	local left = 0.00
	local a, b, lag = GetNetStats()
	local e = this.et
	local s = this.st
	tSpark=getglobal(this:GetName().. "Spark")
	tText=getglobal(this:GetName().. "Tmr")
	tLag=getglobal(this:GetName().. "Lag")
	if abar.timer==true then
		left = (e-ttime) - (math.fmod((e-ttime),.01))
		tText:SetText("{"..left.."}")
		tText:Show()
	else
			tText:Hide()
	end
	this:SetValue(ttime)
	tSpark:SetPoint("CENTER", this, "LEFT", (ttime-s)/(e-s)*195, 2);
	tLag:SetWidth((lag * 195) / (1000 * (e-s)))
	if ttime>=e then 
	this:Hide() 
	tSpark:SetPoint("CENTER", this, "LEFT",195, 2);
	end
end
function Abar_Mhrs(bartime,text,r,g,b)
	Abar_Mhr:Hide()
	if abar.info == true then
		Abar_Mhr.txt = text
		Abar_MhrText:SetText(text)
	else
		Abar_Mhr.txt = ""
		Abar_MhrText:SetText("")
	end
	Abar_Mhr.st = GetTime()
	Abar_Mhr.et = GetTime() + bartime
	Abar_Mhr:SetStatusBarColor(r,g,b)
	Abar_Mhr:SetMinMaxValues(Abar_Mhr.st,Abar_Mhr.et)
	Abar_Mhr:SetValue(Abar_Mhr.st)
	Abar_Mhr:Show()
	end
	function Abar_Ohs(bartime,text,r,g,b)
	Abar_Oh:Hide()
	if abar.info == true then
		Abar_Oh.txt = text
		Abar_OhText:SetText(text)
	else
		Abar_Oh.txt = ""
		Abar_OhText:SetText("")
	end
	Abar_Oh.st = GetTime()
	Abar_Oh.et = GetTime() + bartime
	Abar_Oh:SetStatusBarColor(r,g,b)
	Abar_Oh:SetMinMaxValues(Abar_Oh.st,Abar_Oh.et)
	Abar_Oh:SetValue(Abar_Oh.st)
	Abar_Oh:Show()
end
function Abar_Boo(inpt)
	if inpt == true then return " ON" else return " OFF" end
end
-----------------------------------------------------------------------------------------------------------------------
-- ENEMY BAR CODE --
-----------------------------------------------------------------------------------------------------------------------

function ebar_VL()
	ebar_mh:SetPoint("LEFT",ebar_Frame,"TOPLEFT",6,-13)
	ebar_oh:SetPoint("LEFT",ebar_Frame,"TOPLEFT",6,-35)
	ebar_mhText:SetJustifyH("Left")
	ebar_ohText:SetJustifyH("Left")
end
function ebar_event(event)
	if event=="VARIABLES_LOADED" then
	ebar_VL()
	end
end

function ebar_set(targ)
	eons,eoffs = UnitAttackSpeed("playertarget")
--[[	
	Mob duel weild code.... I cant get their off hand speed to return
	
	if eoffs then 		
			eont,eofft=GetTime(),GetTime()
	if ((math.abs((eont-epont)-eons) <= math.abs((eofft-epofft)-eoffs))and not(eonh <= eoffs/eons)) or eoffh >= eons/eoffs then
		if epofft == 0 then epofft=eofft end
		epont = eont
		etons = eons
		eoffh = 0
		eonh = eonh +1
		eons = eons - math.fmod(eons,0.01)
		ebar_mhs(eons,"Target Main["..eons.."s]",1,.1,.1)
	else
		epofft = eofft
		eoffh = eoffh+1
		eonh = 0
		eohd,eold = ohd-math.fmod(eohd,1),old-math.fmod(eold,1)
		eoffs = eoffs - math.fmod(eoffs,0.01)
		ebar_ohs(eoffs,"Target Off["..eoffs.."s]",1,.1,.1)
	end
	else ]]--
	eons = eons - math.fmod(eons,0.01)
	ebar_mhs(eons,"Target".."["..eons.."s]",1,.1,.1)
	--end
end
function ebar_mhs(bartime,text,r,g,b)
ebar_mh:Hide()
if abar.info == true then
	ebar_mh.txt = text
	ebar_mhText:SetText(text)
else
	--ebar_mh.txt = ""
	--ebar_mhText:SetText("")
end
ebar_mh.st = GetTime()
ebar_mh.et = GetTime() + bartime
ebar_mh:SetStatusBarColor(r,g,b)
ebar_mh:SetMinMaxValues(ebar_mh.st,ebar_mh.et)
ebar_mh:SetValue(ebar_mh.st)
ebar_mh:Show()
end
function ebar_ohs(bartime,text,r,g,b)
ebar_oh:Hide()
--ebar_oh.txt = text
ebar_oh.st = GetTime()
ebar_oh.et = GetTime() + bartime
ebar_oh:SetStatusBarColor(r,g,b)
--ebar_ohText:SetText(text)
ebar_oh:SetMinMaxValues(ebar_oh.st,ebar_oh.et)
ebar_oh:SetValue(ebar_oh.st)
ebar_oh:Show()
end

