---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2007  Prat Development Team
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to:
--
-- Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor,
-- Boston, MA  02110-1301, USA.
--
--
-------------------------------------------------------------------------------

local tostring = tostring


local util = {}

function util:print(text, name, r, g, b, frame, delay)
	if not text or text:len() == 0 then
		text = " "
	end
	if not name or name == AceConsole then
	else
		text = "|cffffff78" .. tostring(name) .. ":|r " .. text
	end
	local last_color
	for t in text:gmatch("[^\n]+") do
		(frame or DEFAULT_CHAT_FRAME):AddMessage(last_color and "|cff" .. last_color .. t or t, r, g, b, nil, delay or 5)
		if not last_color or t:find("|r") or t:find("|c") then
			last_color = t:match(".*|c[fF][fF](%x%x%x%x%x%x)[^|]-$")
		end
	end
end

local real_tostring = tostring

local function tostring(t)
	if type(t) == "table" then
		if type(rawget(t, 0)) == "userdata" and type(t.GetObjectType) == "function" then
			return ("<%s:%s>"):format(t:GetObjectType(), t:GetName() or "(anon)")
		end
	end
	return real_tostring(t)
end

local getkeystring

function util:isList(t)
	local n = #t
	for k,v in pairs(t) do
		if type(k) ~= "number" then
			return false
		elseif k < 1 or k > n then
			return false
		end
	end
	return true
end

local findGlobal = setmetatable({}, {__index=function(self, t)
	for k,v in pairs(_G) do
		if v == t then
			k = tostring(k)
			self[v] = k
			return k
		end
	end
	self[t] = false
	return false
end})


local recurse = {}
local timeToEnd
local GetTime = GetTime
local type = type
function util:literal_tostring_prime(t, depth, order_table)
	if type(t) == "string" then
		return ("|cff00ff00%q|r"):format((t:gsub("|", "||")))
	elseif type(t) == "table" then
		if t == _G then
			return "|cffffea00_G|r"
		end
		if type(rawget(t, 0)) == "userdata" and type(t.GetObjectType) == "function" then
			return ("|cffffea00<%s:%s>|r"):format(t:GetObjectType(), t:GetName() or "(anon)")
		end

		if recurse[t] then
			local g = findGlobal[t]
			if g then
				return ("|cff9f9f9f<Recursion _G[%q]>|r"):format(g)
			else
				return ("|cff9f9f9f<Recursion %s>|r"):format(real_tostring(t):gsub("|", "||"))
			end
		elseif GetTime() > timeToEnd then
			local g = findGlobal[t]
			if g then
				return ("|cff9f9f9f<Timeout _G[%q]>|r"):format(g)
			else
				return ("|cff9f9f9f<Timeout %s>|r"):format(real_tostring(t):gsub("|", "||"))
			end
		elseif depth >= 2 then
			local g = findGlobal[t]
			if g then
				return ("|cff9f9f9f<_G[%q]>|r"):format(g)
			else
				return ("|cff9f9f9f<%s>|r"):format(real_tostring(t):gsub("|", "||"))
			end
		end
		recurse[t] = true
		if next(t) == nil then
			return "{}"
		elseif next(t, (next(t))) == nil then
			local k, v = next(t)
			if k == 1 then
				return "{ " ..util:literal_tostring_prime(v, depth+1) .. " }"
			else
				return "{ " .. util:getkeystring(k, depth+1) .. " = " ..util:literal_tostring_prime(v, depth+1) .. " }"
			end
		end
		local s
		local g = findGlobal[t]
		if g then
			s = ("{ |cff9f9f9f-- _G[%q]|r\n"):format(g)
		else
			s = "{ |cff9f9f9f-- " .. real_tostring(t):gsub("|", "||") .. "|r\n"
		end
		if util:isList(t) then
			for i = 1, #t do
				s = s .. ("    "):rep(depth+1) ..util:literal_tostring_prime(t[i], depth+1) .. (i == #t and "\n" or ",\n")
			end
		else
		if order_table then
			local v
			for _,k in ipairs(order_table) do
				v = t[k]
				if v then
					s = s .. ("    "):rep(depth+1) .. util:getkeystring(k, depth+1) .. " = " ..util:literal_tostring_prime(v, depth+1) .. (next(t, k) == nil and "\n" or ",\n")
				end
			end
		else
			for k,v in pairs(t) do
				s = s .. ("    "):rep(depth+1) .. util:getkeystring(k, depth+1) .. " = " ..util:literal_tostring_prime(v, depth+1) .. (next(t, k) == nil and "\n" or ",\n")
			end
		end

		end
		if g then
			s = s .. ("    "):rep(depth) .. string.format("} |cff9f9f9f-- _G[%q]|r", g)
		else
			s = s .. ("    "):rep(depth) .. "} |cff9f9f9f-- " .. real_tostring(t):gsub("|", "||")
		end
		return s
	end
	if type(t) == "number" then
		return "|cffff7fff" .. real_tostring(t) .. "|r"
	elseif type(t) == "boolean" then
		return "|cffff9100" .. real_tostring(t) .. "|r"
	elseif t == nil then
		return "|cffff7f7f" .. real_tostring(t) .. "|r"
	else
		return "|cffffea00" .. real_tostring(t) .. "|r"
	end
end

function util:getkeystring(t, depth)
	if type(t) == "string" then
		if t:find("^[%a_][%a%d_]*$") then
			return "|cff7fd5ff" .. t .. "|r"
		end
	end
	return "[" ..util:literal_tostring_prime(t, depth) .. "]"
end

local get_stringed_args
do
	local function g(value, ...)
		if select('#', ...) == 0 then
			return util:literal_tostring_prime(value, 1)
		end
		return util:literal_tostring_prime(value, 1) .. ", " .. g(...)
	end

	local function f(success, ...)
		if not success then
			return
		end
		return g(...)
	end

	function get_stringed_args(func, ...)
		return f(pcall(func, ...))
	end
end

function util:my_sort(alpha, bravo)
	if not alpha or not bravo then
		return false
	end
	return tostring(alpha):lower() < tostring(bravo):lower()
end


-- Copy Paste Reuse (How Modern)
function util:destroyTable(t)
	setmetatable(t, nil)
	for k,v in pairs(t) do
		t[k] = nil
	end
end

function util:copyTable(src, dst)
	if dst == nil then dst = {} end
	for k,v in pairs(src) do
		if type(v) ~="table" then
			dst[k] = v
		else
			util:copyTable(v, dst[k])
		end
	end
end

function util:orderedCopy(src, dst, order)
	util:copyTable(src, dst)
end

function util:tableMerge(src, dst, replace)
	if src == nil then return end
	for k,v in pairs(src) do
		if type(v) ~="table" then
		    if replace and type(v) ~= "nil" then
    			dst[k] = v
    		end
		else
		    if type(dst[k]) ~= "table" then
		        dst[k] = {}
		    end
			util:tableMerge(v, dst[k], replace)
		end
	end
end
local tmp = {}
local tmp2 = {}
function util:literal_tostring_frame(t)
	local s = ("|cffffea00<%s:%s|r\n"):format(t:GetObjectType(), t:GetName() or "(anon)")
	local __index = getmetatable(t).__index
	for k in pairs(t) do
		if k ~= 0 then
			tmp2[k] = true
		end
	end
	for k in pairs(__index) do
		tmp2[k] = true
	end
	for k in pairs(tmp2) do
		tmp[#tmp+1] = k
		tmp2[k] = nil
	end
	table.sort(tmp, my_sort)
	local first = true
	for i,k in ipairs(tmp) do
		local v = t[k]
		local good = true
		if k == "GetPoint" then
			for i = 1, t:GetNumPoints() do
				if not first then
					s = s .. ",\n"
				else
					first = false
				end
				s = s .. "    " .. util:getkeystring(k, 1) .. "(" ..util:literal_tostring_prime(i, 1) .. ") => " .. get_stringed_args(v, t, i)
			end
		elseif type(v) == "function" and type(k) == "string" and (k:find("^Is") or k:find("^Get") or k:find("^Can")) then
			local q = get_stringed_args(v, t)
			if q then
				if not first then
					s = s .. ",\n"
				else
					first = false
				end
				s = s .. "    " .. util:getkeystring(k, 1) .. "() => " .. q
			end
		elseif type(v) ~= "function" then
			if not first then
				s = s .. ",\n"
			else
				first = false
			end
			s = s .. "    " .. util:getkeystring(k, 1) .. " = " ..util:literal_tostring_prime(v, 1)
		else
			good = false
		end
	end
	for k in pairs(tmp) do
		tmp[k] = nil
	end
	s = s .. "\n|cffffea00>|r"
	return s
end

function util:literal_tostring(t, only, order)
	timeToEnd = GetTime() + 0.2
	local s
	if only and type(t) == "table" and type(rawget(t, 0)) == "userdata" and type(t.GetObjectType) == "function" then
		s =util:literal_tostring_frame(t)
	else
		s =util:literal_tostring_prime(t, 0, order)
	end
	for k,v in pairs(recurse) do
		recurse[k] = nil
	end
	for k,v in pairs(findGlobal) do
		findGlobal[k] = nil
	end
	return s
end

function util:tostring_args(a1, ...)
	if select('#', ...) < 1 then
		return tostring(a1)
	end
	return tostring(a1), util:tostring_args(...)
end

function util:literal_tostring_args_ordered(order, a1, ...)
	if select('#', ...) < 1 then
		return util:literal_tostring(a1, order)
	end
	return util:literal_tostring(a1, order),util:literal_tostring_args(...)
end
function util:literal_tostring_args(a1, ...)
	if select('#', ...) < 1 then
		return util:literal_tostring(a1)
	end
	return util:literal_tostring(a1),util:literal_tostring_args(...)
end

util.keytable = nil
function util:setKeytable(t)
	for i,v in ipairs(t) do
		self.keytable[i] = v
	end
end

function util:sort_keytable(a, b)
	if not a or not b then
		return false
	end
	if not keytable[a] or not keytable[b] then
		return false
	end
	return keytable[a] > keytable[b]
end

-- Append any extra keys found in the table
-- to the end of the keys table
local mytmp = {}
function util:merge_keys(keys, t)
	if not t then return keys end

	local add = true
	for k,v in pairs(t) do
		add = true
		for _,key in ipairs(keys) do
			if key == k then
				add = false
			end
		end
		if add then table.insert(keys, k) end
	end
	return keys
end


local CLR = {}

CLR.DEFAULT = "ffffff" -- default to white
CLR.LINK = { "|cff", CLR.DEFAULT, "", "|r" }

CLR.COLOR_NONE = nil

local function get_default_color()
    return 1.0, 1.0, 1.0
end

local function get_color(c)
    if type(c.r) == "number" and type(c.g) == "number" and type(c.b) == "number" then
        return c.r, c.g, c.b
    end

    return get_default_color()
end

local function get_var_color(a1, a2, a3)
    local r, g, b

    if type(a1) == "table" then
        r, g, b = get_color(a1)
    elseif type(a1) == "number" and type(a2) == "number" and type(a3) == "number" then
        r, g, b = a1, a2, a3
    else
        r, g, b = get_default_color()
    end

    return r, g, b
end

-- CLR:GetHexColor(color or cr, cg, cb)
local function mult_255(r,g,b)
    return r*255, g*255, b*255
end

function CLR:GetHexColor(a1, a2, a3)
    return string.format("%02x%02x%02x", mult_255(get_var_color(a1, a2, a3)))
end


function CLR:Colorize(hexColor, text)
    if text == nil or text == "" then
        return ""
    end

    local color = hexColor
    if type(hexColor) == "table" then
        color = self:GetHexColor(hexColor)
    end

    if color == CLR.COLOR_NONE then
        return text
    end

    local link = CLR.LINK

    link[2] = tostring(color or 'ffffff')
    link[3] = text

    return table.concat(link, "")
end



local function desat_chan(c) return ((c or 1.0)*192*0.8+63) / 255 end

function CLR:RGBtoHSL(red, green, blue)
	local hue, saturation, luminance
	local minimum = math.min( red, green, blue )
	local maximum = math.max( red, green, blue )
	local difference = maximum - minimum
	
	luminance = ( maximum + minimum ) / 2
	
	if difference == 0 then --Greyscale
		hue = 0
		saturation = 0
	else              --Colour
		if luminance < 0.5 then 
			saturation = difference / ( maximum + minimum )
		else 
			saturation = difference / ( 2 - maximum- minimum ) 
		end
		
		local tmpRed   = ( ( ( maximum - red   ) / 6 ) + ( difference / 2 ) ) / difference
		local tmpGreen = ( ( ( maximum - green ) / 6 ) + ( difference / 2 ) ) / difference
		local tmpBlue  = ( ( ( maximum - blue  ) / 6 ) + ( difference / 2 ) ) / difference
		
		if red == maximum then 
			hue = tmpBlue - tmpGreen
		elseif green == maximum then 
			hue = ( 1 / 3 ) + tmpRed - tmpBlue
		elseif blue == maximum then 
			hue = ( 2 / 3 ) + tmpGreen - tmpRed
		end
		
		hue = hue % 1
		if hue < 0 then hue = hue + 1 end
	end
	
	return hue, saturation, luminance
end

function CLR:HSLtoRGB(hue, saturation, luminance)
	local red, green, blue
	
	if ( S == 0 ) then
		red, green, blue = luminance, luminance, luminance
	else
		if luminance < 0.5 then 
			var2 = luminance * ( 1 + saturation )
		else 
			var2 = ( luminance + saturation ) - ( saturation * luminance ) 
		end
		
		var1 = 2 * luminance - var2
		
		red   = self:HueToColor( var1, var2, hue + ( 1 / 3 ) )
		green = self:HueToColor( var1, var2, hue )
		blue  = self:HueToColor( var1, var2, hue - ( 1 / 3 ) )
	end
	
	return red, green, blue
end

function CLR:HueToColor(var1, var2, hue)
	hue = hue % 1
	if hue < 0 then hue = hue + 1 end

	if ( 6 * hue ) < 1 then 
		return hue + ( var2 - var1 ) * 6 * hue  
	elseif ( 2 * hue ) < 1 then 
		return var2 
	elseif ( 3 * hue ) < 2 then 
		return var1 + ( var2 - var1 ) * ( ( 2 / 3 ) - hue ) * 6 
	else 
		return var1 
	end
end

function CLR:Desaturate(a1, a2, a3)
    local r, g, b = get_var_color(a1, a2, a3)

    r = desat_chan(r)
    g = desat_chan(g)
    b = desat_chan(b)

    return r, g, b
end

-- CLR:Desaturate(color or cr, cg, cb)
--function CLR:Desaturate(a1, a2, a3)
--    local h, s, l = self:RGBtoHSL(get_var_color(a1, a2, a3))
--
--    return self:HSLtoRGB(h, s / 2, l)
--end


--[[

-- You are always a component in the table
-- So that ComponentDebug(self.NAME, ...) is
-- the same as Debug(...)
--
-- Also :
--
--  ComponentDebug("ERR", ...) = LevelDebug(1, ...)
--  ComponentDebug("INFO", ...) = LevelDebug(2, ...)
--  ComponentDebug("DBG", ...) = LevelDebug(3, ...)
--



local dbg_cmpts = {
    ["NAME"] = function() return self.debugging end
    ["ERR"] = function() return self.debuglevel == 1 end
    ["INFO"] = function() return self.debuglevel == 2 end
    ["DBG"] = function() return self.debuglevel == 3 end
}

function AceDebug:ComponentDebug(component, value)
     AceDebug:argCheck(component, 1, "string")
     AceDebug:argCheck(component, 1, "string", "function", "nil")

    dbg_cmpts[component] = value
end

function AceDebug:ComponentDebug(component, ...)
    AceDebug:argCheck(component, 1, "string", "function", "nil")
    if not component then
        component = "NAME"
    end

    local dbg = false
    if type(component) == "function" then
        dbg = safecall(component, self)
    else
        local tc = dbg_cmpts[component]

        if type(tc == "function" then
           dbg = safecall(tc, self)
        else
           dbg = tc
        end
    end

    if dbg then
        AceDebug.CustomDebug(self, nil, nil, nil, nil, nil, ...)
    end
end

-- ]]

function util:Debug(level, r, g, b, frame, delay, a1, ...)
	local output = ("|cff7fff7f(DEBUG) %s:[%s.%3d]|r"):format( tostring(self), date("%H:%M:%S"), (GetTime() % 1) * 1000)

	a1 = tostring(a1)
	if a1:find("%%") and select('#', ...) >= 1 then
		for i = 1, select('#', ...) do
			tmp[i] = tostring((select(i, ...)))
		end
		output = output .. " " .. a1:format(unpack(tmp))
		for i = 1, select('#', ...) do
			tmp[i] = nil
		end
	else
		-- This block dynamically rebuilds the tmp array stopping on the first nil.
		tmp[1] = output
		tmp[2] = a1
		for i = 1, select('#', ...) do
			tmp[i+2] = tostring((select(i, ...)))
		end

		output = table.concat(tmp, " ")

		for i = 1, select('#', ...) + 2 do
			tmp[i] = nil
		end
	end

	print(output, r, g, b, frame or self.debugFrame, delay)
end



-- You are always a component in the table
-- So that ComponentDebug(self.NAME, ...) is
-- the same as Debug(...)
--
-- Also :
--
--  ComponentDebug("ERR", ...) = LevelDebug(1, ...)
--  ComponentDebug("INFO", ...) = LevelDebug(2, ...)
--  ComponentDebug("DBG", ...) = LevelDebug(3, ...)
--
local DBG ={}
DBG.dbg_cmpts = {}

function DBG:SetDebug(component, value, aceoptions)
   DBG.dbg_cmpts[component] = value

    if aceoptions and aceoptions.pass then
        local a = aceoptions.args
        for k,v in pairs(DBG.dbg_cmpts) do
            a[k] = a[k] or { }
            a[k].name, a[k].desc, a[k].type  = k, k, "toggle"
        end
    end
    return false
end

function DBG:Debug(component, ...)
    if DBG.dbg_cmpts[component] then
        Prat.dbgcmpt = component
        Prat:Debug(...)
        Prat.dbgcmpt = nil
    end
end


-- Debug Decorators

function DBG:Dump(component, ...)
    if DBG.dbg_cmpts[component] then
        Prat.dbgcmpt = component
        Prat:ConsoleDebugDump(...)
        Prat.dbgcmpt = nil
    end
end

function DBG:DumpEx(component, frame, name, order, ...)
    if DBG.dbg_cmpts[component] then
        Prat.dbgcmpt = component
        Prat:ConsoleDump(frame, name, order, ...)
        Prat.dbgcmpt = nil
    end
end


function util:empty(var)
	local v = var
	return (v == nil or v == "" or v == 0 or v == {})
end

function util:ok(var)
	return empty(var) and var
end

function util:escpat(str)
	-- escape meta characters in patterns
	if (type(str) == string) then
		return str:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?%)])', '%%%1')
	else
		return str
	end
end

--[[
function util:returns(...)
	-- see what was returned by some function - doesn't work though!
	for k, v in pairs(arg) do
		util:msg(string.format("k: %s   --   v: %s", k, tostring(v)))
	end
end
]]

local fixedIndex = nil

function util:setOrderedIndex( t )
    fixedIndex = t
end

function util:genOrderedIndex( t )
    if fixedIndex then return fixedIndex end

    local orderedIndex = util:acquire()
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function util:freeOrderedIndex( t )
    local orderedIndex = t.__orderedIndex
    t.__orderedIndex = nil

    if fixedIndex then return end

    util:reclaim(orderedIndex)
end

function util:orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = util:genOrderedIndex( t )
        key = t.__orderedIndex[1]
        return key, t[key]
    end
    -- fetch the next value
    key = nil
    for i = 1,#t.__orderedIndex do
        if t.__orderedIndex[i] == state then
            key = t.__orderedIndex[i+1]
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    util:freeOrderedIndex(t)
    return
end

function util:orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return util.orderedNext, t, nil
end

local cache = setmetatable({}, {__mode='k'})
function util:acquire()
	local t = next(cache) or {}
	cache[t] = nil
	return t
end
function util:reclaim(t)
	for k in pairs(t) do
		t[k] = nil
	end
	cache[t] = true
end

function GetPratUtils()
    return util, DBG, CLR
end



--[[
	str util:nicejoin(mixed t [, str glue [, str gluebeforelast ] ]):

	returns a nicely joined list of items as a string, eg:

	  'one, two, and three' = nicejoin({'one', 'two', 'three'})

	glue between items can be set in the same way as table.concat,
	and the glue between the last and penultimate items can be set
	as a third optional parameter.

]]
function util:nicejoin(t, glue, gluebeforelast)
	-- check we've got a table
	if type(t) ~= 'table' then return false end

	local list	= {}
	local index	= 1

	-- create a copy of the table with a numerical and no nested tables
	for i, v in pairs(t) do
		local vtype	= type(v)
		local item	= v

		if vtype ~= 'string' then
			item = vtype
		end

		list[index]	= item or vtype
		index		= index + 1
	end

	-- make sure we have some items to join
	if #list == 0 then
		return ""
	end

	-- trying to join one item = that item
	if #list == 1 then
		return list[1]
	end

	-- defaults with which we will want wo woin no that's not going to work
	-- defaults
	glue		= glue or ', '
	gluebeforelast	= gluebeforelast or ', and '

	-- pop the last value off
	local last	= table.remove(list) or "" -- shouldn't need the ' or ""'?

	-- standard way of joining a list of items together
	local str	= table.concat(list, glue)

	-- return the previous list, but add the last value nicely
	return str .. gluebeforelast .. last
end
