SolaceTargetOptions = {
    ["maxbuffs"] = 32,
    ["maxdebuffs"] = 40,
    ["showownbig"] = "on"
}

function SolaceTargetFrame_OnEvent(event)
    if ( ( event == "VARIABLES_LOADED" ) ) then
        SolaceCmdInit("showbuffs",SOLACE_SHOWBUFFS_HELP,SolaceShowbuffsHandler);
        SolaceCmdInit("showdebuffs",SOLACE_SHOWDEBUFFS_HELP,SolaceShowdebuffsHandler);
        SolaceCmdInit("showownbig",SOLACE_SHOWOWN_HELP,SolaceShowownHandler);
        
        --DEFAULT_CHAT_FRAME:AddMessage(SOLACETARGETFRAME_WELCOME);
        
        --SolaceShowownHandler(SolaceTargetOptions.showownbig,SolaceGetCmdIndex("showownbig"));
        --SolaceShowbuffsHandler(SolaceTargetOptions.maxbuffs,SolaceGetCmdIndex("showbuffs"));
        --SolaceShowdebuffsHandler(SolaceTargetOptions.maxdebuffs,SolaceGetCmdIndex("showdebuffs"));
	
	SolaceTargetFrame_UpdateSVars();
    end
end

function SolaceTargetFrame_UpdateSVars()
	if ( SolaceTargetOptions.numrow ) then
		SolaceTargetOptionsold = SolaceTargetOptions;
		SolaceTargetOptions = nil;
		SolaceTargetOptions = {
			["maxbuffs"] = SolaceTargetOptionsold.maxbuffs,
			["maxdebuffs"] = SolaceTargetOptionsold.maxdebuffs,
			["showownbig"] = SolaceTargetOptionsold.showownbig
		};
	end	
end

function SolaceShowbuffsHandler(msg,index)
    if msg then
	msg = tonumber(msg);
        if ( SolaceTargetOptions.maxbuffs > msg ) then
            local button;
            for i = msg+1, SolaceTargetOptions.maxbuffs do
                button = getglobal("TargetFrameBuff"..i)
                if ( button ) then
                    button:Hide();
                end
            end
        end
        MAX_TARGET_BUFFS = msg;
        SolaceTargetOptions.maxbuffs = msg;
        DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWBUFFS..MAX_TARGET_BUFFS);
	TargetDebuffButton_Update();
    else
        DEFAULT_CHAT_FRAME:AddMessage("/solace "..SolaceCmd[index].cmd..": "..SolaceCmd[index].desc);
        DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWBUFFS..MAX_TARGET_BUFFS);
    end
end

function SolaceShowdebuffsHandler(msg,index)
    if msg then
	msg = tonumber(msg);
        if ( SolaceTargetOptions.maxdebuffs > msg ) then
            local button;
            for i = msg+1, SolaceTargetOptions.maxdebuffs do
                button = getglobal("TargetFrameDebuff"..i)
                if ( button ) then
                    button:Hide();
                end
            end
        end
        MAX_TARGET_DEBUFFS = msg;
        SolaceTargetOptions.maxdebuffs = msg;
        DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWDEBUFFS..MAX_TARGET_DEBUFFS);
	TargetDebuffButton_Update();
    else
        DEFAULT_CHAT_FRAME:AddMessage("/solace "..SolaceCmd[index].cmd..": "..SolaceCmd[index].desc);
        DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWDEBUFFS..MAX_TARGET_DEBUFFS);
    end
end

function SolaceShowownHandler(msg,index)
	if ( msg == "on" ) then
		LARGE_BUFF_SIZE = 21;
		LARGE_BUFF_FRAME_SIZE = 23;
		SolaceTargetOptions.showownbig = msg;
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWOWNON);
	elseif ( msg == "off" ) then
		LARGE_BUFF_SIZE = 17;
		LARGE_BUFF_FRAME_SIZE = 19;
		SolaceTargetOptions.showownbig = msg;
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWOWNOFF);
	else
		DEFAULT_CHAT_FRAME:AddMessage("/solace "..SolaceCmd[index].cmd..": "..SolaceCmd[index].desc);
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWOWNCURRENT..SolaceTargetOptions.showownbig);
	end
end
