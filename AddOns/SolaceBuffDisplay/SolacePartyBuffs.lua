SPB_VER = "2.4.3-r1"

SPB_Options = {
    ["max_party_buffs"] = 32,
    ["max_party_debuffs"] = 40,
    ["filter_castable"] = false
}

SPB = { };

SPB.CanDispel = {
    PRIEST = {
        Magic = true,
        Disease = true,
    },
    SHAMAN = {
        Poison = true,
        Disease = true,
    },
    PALADIN = {
        Magic = true,
        Poison = true,
        Disease = true,
    },
    MAGE = {
        Curse = true,
    },
    DRUID = {
        Curse = true,
        Poison = true,
    }
}

SPB.frameref = {
    ["party1"] = "SolacePartyBuffFrame1",
    ["party2"] = "SolacePartyBuffFrame2",
    ["party3"] = "SolacePartyBuffFrame3",
    ["party4"] = "SolacePartyBuffFrame4"
}

function SPB.onLoad()
    this:RegisterEvent("UNIT_AURA");
    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("PARTY_MEMBERS_CHANGED");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function SPB.ErrorMsg(name, index)
    DEFAULT_CHAT_FRAME:AddMessage("/solace"..SolaceCmd[index].cmd..": "..SolaceCmd[index].desc);
    DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SPB_Options[name]);
end

function SPB_buffshandler(msg, index)
    if msg then
        msg = tonumber(msg);
        if ( msg > 0 and msg < 33 ) then
            if ( msg < SPB_Options.max_party_buffs ) then
                for j = 1, GetNumPartyMembers() do
                    local frame = "SolacePartyBuffFrame"..j;
                    for i = msg, SPB_Options.max_party_buffs do
                        local button = getglobal(frame.."Buff"..i);
                        button:Hide();
                    end
                end
            end
            SPB_Options.max_party_buffs = msg;
            for i = 1, GetNumPartyMembers() do
                SPB.UpdateBuffs("party"..i);
            end
            
            DEFAULT_CHAT_FRAME:AddMessage(SPB_PBUFFS_CHANGED..msg);
        else
            SPB.ErrorMsg("max_party_debuffs", index);
        end
    else
        SPB.ErrorMsg("max_party_buffs",index);
    end
end

function SPB_debuffshandler(msg, index)
    if msg then
        msg = tonumber(msg);
        if ( msg > 0 and msg < 33 ) then
            if ( msg < SPB_Options.max_party_debuffs ) then
                for j = 1, GetNumPartyMembers() do
                    local frame = "SolacePartyDebuffFrame"..j;
                    for i = msg, SPB_Options.max_party_debuffs do
                        local button = getglobal(frame.."Debuff"..i);
                        button:Hide();
                    end
                end
            end
            SPB_Options.max_party_debuffs = msg;
            for i = 1, GetNumPartyMembers() do
                SPB.UpdateBuffs("party"..i);
            end
            
            DEFAULT_CHAT_FRAME:AddMessage(SPB_PDEBUFFS_CHANGED..msg);
        else
            SPB.ErrorMsg("max_party_debuffs", index);
        end
    else
        SPB.ErrorMsg("max_party_debuffs",index);
    end
end

function SPB_filterhandler(msg, index)
    if msg then
        if ( msg == "on" ) then
            SPB_Options.filter_castable = true;
            DEFAULT_CHAT_FRAME:AddMessage(SPB_PFILTER_CHANGED..SPB_ENABLED);
        elseif ( msg == "off" ) then
            SPB_Options.filter_castable = false;
            DEFAULT_CHAT_FRAME:AddMessage(SPB_PFILTER_CHANGED..SPB_DISABLED);
        else
            DEFAULT_CHAT_FRAME:AddMessage("/solace"..SolaceCmd[index].cmd..": "..SolaceCmd[index].desc);
            if ( SPB_Options.filter_castable == true ) then
                DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SPB_ENABLED);
            else
                DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SPB_DISABLED);
            end
        end
        for i = 1, GetNumPartyMembers() do
            SPB.UpdateBuffs("party"..i);
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("/solace"..SolaceCmd[index].cmd..": "..SolaceCmd[index].desc);
        if ( SPB_Options.filter_castable == true ) then
            DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SPB_ENABLED);
        else
            DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SPB_DISABLED);
        end
    end
end

function SPB.onEvent(event)
    if ( event == "VARIABLES_LOADED" ) then
        SolaceCmdInit("maxpartybuffs", SPB_MAXPARTYBUFFS, SPB_buffshandler);
        SolaceCmdInit("maxpartydebuffs", SPB_MAXPARTYDEBUFFS, SPB_debuffshandler);
        SolaceCmdInit("partyaurafilter", SPB_FILTERDEBUFFS, SPB_filterhandler);
        DEFAULT_CHAT_FRAME:AddMessage(SPB_LOADED);
    elseif ( event == "UNIT_AURA" ) then
        for k, v in pairs(SPB.frameref) do
            if ( arg1 == k ) then
                SPB.UpdateBuffs(arg1);
                return;
            end
        end
    elseif ( event == "PARTY_MEMBERS_CHANGED" or event == "PLAYER_ENTERING_WORLD" ) then
        for i = 1, GetNumPartyMembers() do
            SPB.UpdateBuffs("party"..i);
        end
    end
end

function SPB.UpdateBuffs(unit)
    local frame = SPB.frameref[unit];
    local button, buttonname;
    local name, rank, icon, count, duration, timeLeft;
    local buffCount;
    local numBuffs = 0;
    local cooldown, startCooldownTime;
    
    for i = 1, SPB_Options.max_party_buffs do
        name, rank, icon, count, duration, timeLeft = UnitBuff(unit, i, SPB_Options.filter_castable);
        buttonname = frame.."Buff"..i;
        button = getglobal(frame.."Buff"..i);
        
        if ( not button ) then
            if ( not icon ) then
                break;
            else
                button = CreateFrame("Button", buttonname, getglobal(frame), "SolacePartyBuffButtonTemplate");
            end
        end
        
        if ( icon ) then
            getglobal( buttonname.."Icon"):SetTexture(icon);
            buffCount = getglobal(buttonname.."Count");
            button:Show();
            
            if (count > 1) then
                buffCount:SetText(count);
                buffCount:Show();
            else
                buffCount:Hide();
            end
            
            cooldown = getglobal(buttonname.."Cooldown")
            if ( duration ) then
                if ( duration > 0 ) then
                    cooldown:Show();
                    startCooldownTime = GetTime() - ( duration - timeLeft );
                    CooldownFrame_SetTimer(cooldown, startCooldownTime, duration, 1);
                else
                    cooldown:Hide();
                end
            else
                cooldown:Hide();
            end
            
            button:SetID(i);
            numBuffs = numBuffs + 1;
            
            button:ClearAllPoints();
            
            SPB.PositionButtons(frame.."Buff", i, frame, "Buff");
        else
            button:Hide();
        end
    end
    
    local debuffType, color;
    local debuffCount;
    local numDebuffs = 0;
    
    for i = 1, SPB_Options.max_party_debuffs do
        
        if ( i <= 4 ) then
            getglobal("PartyMemberFrame" .. getglobal(frame):GetID() .. "Debuff" .. i):Hide();
        end
        
        buttonname = frame.."Debuff"..i;
        local debuffBorder = getglobal(buttonname.."Border");
        name, rank, icon, count, debuffType, duration, timeLeft = SPB.UnitDebuff(unit, i);
        button = getglobal(frame.."Debuff"..i);
        
        if ( not button ) then
            if ( not icon ) then
                break;
            else
                button = CreateFrame("Button", frame.."Debuff"..i, getglobal(frame), "SolacePartyDebuffButtonTemplate");
                debuffBorder = getglobal(buttonname.."Border")
            end
        end
        
        if ( icon ) then
            getglobal( buttonname.."Icon"):SetTexture(icon);
            debuffCount = getglobal(buttonname.."Count");
            
            if ( debuffType ) then
                color = DebuffTypeColor[debuffType];
            else
                color = DebuffTypeColor["none"];
            end
            
            if (count > 1) then
                debuffCount:SetText(count);
                debuffCount:Show();
            else
                debuffCount:Hide();
            end
            
            cooldown = getglobal(buttonname.."Cooldown")
            if ( duration ) then
                if ( duration > 0 ) then
                    cooldown:Show();
                    startCooldownTime = GetTime() - ( duration - timeLeft );
                    CooldownFrame_SetTimer(cooldown, startCooldownTime, duration, 1);
                else
                    cooldown:Hide();
                end
            else
                cooldown:Hide();
            end
            
            debuffBorder:SetVertexColor(color.r, color.g, color.b);
            button:Show();
            button:SetID(i);
            numDebuffs = numDebuffs + 1;
            
            button:ClearAllPoints();
            
            SPB.PositionButtons(frame.."Debuff", i, frame, "Debuff");
        else
            button:Hide();
        end
    end
end

function SPB.PositionButtons(name, index, frame, btype)
    local button = getglobal(name..index);
    local debuffBorder = getglobal(name..index.."Border");
    if ( btype == "Buff" ) then	
        if ( index == 1 ) then
            button:SetPoint("TOPLEFT", getglobal(frame), "TOPLEFT", 0, 0);
        elseif ( index == 17 ) then
            button:SetPoint("TOPLEFT", getglobal(name.."3"), "BOTTOM", 0, -2);
        else
            button:SetPoint("TOPLEFT", getglobal(name..(index - 1)), "TOPRIGHT", 2, 0);
        end
    else
        if ( index == 1 ) then
            debuffBorder:Hide();
            button:SetPoint("TOPLEFT", getglobal(frame), "TOPLEFT", 75, 38);
            debuffBorder:SetPoint("CENTER", button, "CENTER", 0, 0);
            debuffBorder:Show();
        else
            button:SetPoint("TOPLEFT", getglobal(name..(index - 1)), "TOPRIGHT", 2, 0);
        end
    end
end

function SPB.UnitDebuff(unit,id)
if not unit then return end
    local name, rank, icon, count, debuffType, duration, timeLeft = UnitDebuff(unit,id);

    if SPB_Options.filter_castable == 1 then
        local _, eClass = UnitClass("player");
        if ( SPB.CanDispel[eClass] and SPB.CanDispel[eClass][debuffType] == true or ( eClass == "PRIEST" and (aura == "Interface\\Icons\\Spell_Holy_AshesToAshes")) ) then
            return name, rank, icon, count or 0, debuffType, duration, timeLeft;
        end
    else
        return name, rank, icon, count or 0, debuffType, duration, timeLeft;
    end
end

SPB.oldPartyMemberBuffTooltip_Update = PartyMemberBuffTooltip_Update;
function SPB.newPartyMemberBuffTooltip_Update(id, ispet)
    SPB.oldPartyMemberBuffTooltip_Update(id, ispet);
    if not ispet then
        PartyMemberBuffTooltip:Hide();
    end
end
PartyMemberBuffTooltip_Update = SPB.newPartyMemberBuffTooltip_Update;