
-- module setup
local me = { name = "skin"}
local mod = thismod
mod[me.name] = me

me.fontsize = 15
me.textinset = 15	-- This is the inset between the edge of the frame and where the text block starts.
me.borderinset = 4		-- Minimum distance between edge of a frame and an internal control (due to border)
me.borderinvis = 2.5		-- Width of frame border that is invisible (due to the border texture)

me.background = 
{
	generic = -- dull grey
	{
		red = 0.2,
		green = 0.2,
		blue = 0.2,
		alpha = 1.0,
	},
	box = -- blue
	{
		red = 0.2,
		green = 0.2,
		blue = 0.6,
		alpha = 1.0,
	},
	window = -- green
	{
		red = 0.2,
		green = 0.6,
		blue = 0.2,
		alpha = 1.0,
	},
	button = -- red
	{
		red = 0.6,
		green = 0.2,
		blue = 0.2,
		alpha = 1.0,
	},		
}

-- example usage:
-- frame:SetBackdropBorderColor(unpack(mod.skin.border.selected)) 
me.border = 
{
	normal = { 1, 1, 1, 1 }, 		-- white
	mouseover = { 1, 1, 0, 1},		-- yellow
	selected = { 0.5, 0.5, 1, 1},	-- light blue
}

-- This is a standard frame border
me.framebackdrop = 
{
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
	tile = false,
	tileSize = 32,
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

-- this is a standard button border. It's not as thick as a frame border, see?
me.buttonbackdrop = 
{
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = false,
	tileSize = 32,
	edgeSize = 12,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
}
