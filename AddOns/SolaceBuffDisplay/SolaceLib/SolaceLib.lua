if ( SOLACELIB_VER ) then 
    if ( SOLACELIB_VER >= 0.1 ) then return end;
end

SOLACELIB_VER=0.1;
SolaceCmdcount = 0;
SolaceCmd = { };

SLASH_SOLACE1 = "/solace";
SlashCmdList["SOLACE"] = function(msg) SolaceSlashHandler(msg) end;

function SolaceCmdInit(cmd,desc,func)
	
	-- Initialize soulmsg
	SolaceCmdcount = SolaceCmdcount + 1;
	SolaceCmd[SolaceCmdcount] = { };
	SolaceCmd[SolaceCmdcount].cmd = cmd;
	SolaceCmd[SolaceCmdcount].desc = desc;
	SolaceCmd[SolaceCmdcount].func = func;
end

function SolaceCmdHelp()
	DEFAULT_CHAT_FRAME:AddMessage("/solace commands:")
	for i = 1, SolaceCmdcount do
		DEFAULT_CHAT_FRAME:AddMessage(" - "..SolaceCmd[i].cmd..": "..SolaceCmd[i].desc);
	end
end

-- Internal function to pick which channel to should get the messages.

function SolaceSlashParser(msg)
	firstspace = string.find(msg, " ", 1, true);
	if (firstspace) then
		local command = string.sub(msg, 1, firstspace - 1);
		local option = string.sub(msg, firstspace + 1);
		return command, option;
	else
		return msg, nil;
	end
end

function SolaceSlashHandler(msg)
    
	local carg1, carg2 = SolaceSlashParser(msg);
	local matchfound = false;
	
	if carg1 then
		carg1 = string.lower(carg1);
	end
	
	if ( not carg1 ) then
		SolaceCmdHelp();
	else
		for i = 1, SolaceCmdcount do
			if ( carg1 == SolaceCmd[i].cmd ) then
				matchfound = true;
				SolaceCmd[i].func(carg2,i);
			end
		end
		if ( not matchfound ) then
			SolaceCmdHelp();
		end
	end    
end

function SolaceGetCmdIndex(cmd)
    for i = 1, SolaceCmdcount do
        if ( cmd == SolaceCmd[i].cmd ) then
            return i;
        end
    end
    return false;
end
