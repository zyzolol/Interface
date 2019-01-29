if type(GetFunctionCPUUsage) == "nil" then
    return
end
    

local lib = {}
local CLR = {}
CLR.COLOR_NONE = nil

function CLR:Colorize(hexColor, text)
    if text == nil or text == "" then 
        return "" 
    end
    
    if hexColor == CLR.COLOR_NONE then
        return text
    end

    return "|cff" .. tostring(hexColor or 'ffffff') .. tostring(text) .. "|r"
end


 function CLR:Time(duration) 
    return CLR:Colorize("80ff80", duration)  
 end
  function CLR:TimePlus(duration) 
    return CLR:Colorize("A0A0ff", duration)  
 end
 function CLR:TimeLabel(duration) 
    return CLR:Colorize("ffff80", duration)  
 end
 function CLR:Calls(duration) 
    return CLR:Colorize("80ffff", duration)  
 end

function lib:MakeFxProfileEntry(t, k, f)
	local time, count = GetFunctionCPUUsage(f, false)
	local timesubs = GetFunctionCPUUsage(f, true)
    local p = t
    
    local lt, lk, lf = t, k, f
    p.type = "execute"
    p.name = k.." ("..CLR:TimePlus(("%d ms"):format(timesubs))..", "..CLR:Calls(tostring(count).." calls")..")"
    p.desc = CLR:TimeLabel("time")..": "..CLR:Time(("%d ms"):format(time)).."\n"..
             CLR:TimeLabel("time+subs")..": "..CLR:TimePlus(("%d ms"):format(timesubs)).."\n"..
             CLR:TimeLabel("count")..": "..CLR:Calls(tostring(count).." calls").."\n"..
             CLR:TimeLabel("tim/count")..": "..CLR:Time(("%.0f ms"):format(time/count)).."\n"..
             CLR:TimeLabel("time+subs/count")..": "..CLR:TimePlus(("%.0f ms"):format(timesubs/count))
    p.func = p.func or function() return end
    p.perf_time = timesubs
    p.perf_upd = function() lib:MakeFxProfileEntry(lt, lk, lf) end
end

function lib:MakeModuleFxProfileMenu(menu, namespace, core)
     local p,m,c = menu, namespace, core
     p.disabled = function() lib:UpdateModuleProfilingData(p, m, c) end
     lib:MakeFxProfileMenu(p, m)
end

function lib:MakeFxProfileMenu(menu, namespace)
     local p,m = menu, namespace
     p.disabled = p.disabled or function() lib:UpdateProfilingData(p) end
     p.name_o = p.name_o or p.name
     local perf = p.args
     for k,v in pairs(m) do   
		if type(v) == "function" then
			local time, count = GetFunctionCPUUsage(v, false)
			local timesubs = GetFunctionCPUUsage(v, true)
			local keystr = tostring(k)
            perf[keystr] = perf[keystr] or {}
            local perf_fx = perf[keystr]
            
			local f = v 

            lib:MakeFxProfileEntry(perf_fx, keystr, f)
		end
	end
end   
    
function lib:UpdateProfilingData(t)    
    local totalTime = 0
    for k,v in pairs(t.args) do
        local f, tm = v.perf_upd, v.perf_time
        if type(f) == "function" then
            f()
        end
        if type(tm) == "number" then
            totalTime = totalTime + tm
        end
    end
    
    t.name = t.name_o.." ("..CLR:TimePlus(("%d ms"):format(totalTime))..")"
end

function lib:UpdateModuleProfilingData(t, m, core)
    if not core:IsModuleActive(m) then return true end
    
    lib:UpdateProfilingData(t)
end


function lib:InjectAceOptions(options, handler)
        local o = options.args
        local handler = handler
        o.optsep346 = {
            order = 346,
            type = 'header',
            hidden = function() return not self:IsProfiling() end,
        }             
        o.performance = {
            type = "group",
            order = 347,
            name = "Performance",
            desc = "Profiling data",
            hidden = function() return not self:IsProfiling() end,
            args = {
            }   
        } 
        
    self:MakeFxProfileMenu(o.performance, handler)  
    
    return options      
end    


function lib:InjectModuleAceOptions(options, handler, core)
    options.args["performance"] = {
        type = "group",
        order = 401,
        name = "Performance",
        name_o = "Performance",
        desc = "Profiling data for this module",
        hidden = function() return not core:IsProfiling() end,
        args = {
        }   
     } 
     
     local p = options.args["performance"]
     
          
     self:MakeModuleFxProfileMenu(p, handler, Prat)    
    
    return options
end    


function lib:IsProfiling()
    local p_on = (GetCVar("scriptProfile") == "1")
    
    return p_on
end

PerfLib = lib