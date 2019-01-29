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


local util = {}
local DBG = {}
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

DBG.dbg_cmpts = {}

do
	local function NOP() end
	
	DBG.SetDebug = NOP
	DBG.Debug = NOP
	DBG.Dump = NOP
	DBG.DumpEx = NOP
end

-- Used in several locations
do
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
end

-- Used in presets
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

--[[
	used in altnames

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




function GetPratUtils()
    return util, DBG, CLR
end



