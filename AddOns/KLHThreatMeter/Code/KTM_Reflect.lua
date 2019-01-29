
local me = { name = "reflect"}
local mod = thismod
mod[me.name] = me

me.filters = 
{
	tome = 
	{
		source = { affiliation = "outsider", reaction = "hostile", },
		dest = { affiliation = "mine", control = "player", objecttype = "player" }
	},
	tomob = 
	{ 
		source = { },
		dest = { }
	}
}

me.mycombatevents = 
{
	SPELL_MISSED = me.filters.tome,
	SPELL_DAMAGE = me.filters.tomob,
}

me.oncombatevent = function(...)
	
	local timestamp, eventname, sourceguid, sourcename, sourceflags, destguid, destname, destflags, spellid, spellname, spellschool, misstype = select(1, ...)
	
	if eventname == "SPELL_MISSED" and misstype == "REFLECT" then
		
		-- report
		--mod.printf("reflection detected. source = %s. Spell = %s.", sourcename, spellname)
		
		me.reportreflect(sourceguid, spellid)
		
	elseif eventname == "SPELL_DAMAGE" and sourceguid == destguid and sourceguid and me.data[sourceguid] then
		
		-- get data (check spell and time)
		data = me.data[sourceguid]
		
		-- check time match
		if GetTime() > data.time + 2.0 then
			
			--mod.printf("reflection of spell %s onto %s, but the timestamp is old.", spellname, sourcename)
			me.data[sourceguid] = nil
			return
		end
		
		-- check spell match
		if spellid ~= data.spellid then
			
			--mod.printf("reflection of spell %s onto %s does not match our spell %s.", spellid, sourcename, data.spellid)
			return
		end
		
		-- valid!!
		local damage = misstype -- true for this event
		
		--mod.printf("reflect complete! source name = %s, guid = %s, spell = %s, damage = %s.", sourcename, sourceguid, spellname, damage)
		
		mod.mythreat.addtarget(sourceguid, damage)
		
	end
	
end

me.data = { }	-- soruceguid = {spellid = , time = }

me.reportreflect = function(sourceguid, spellid)
	
	local timenow = GetTime()
	
	local data = 
	{
		spellid = spellid,
		time = timenow,
	}
	
	me.data[sourceguid] = data
	
end