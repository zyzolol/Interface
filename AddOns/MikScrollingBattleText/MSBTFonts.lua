-------------------------------------------------------------------------------
-- Title: Mik's Scrolling Battle Text Fonts
-- Author: Mik
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Private constants.
-------------------------------------------------------------------------------

-- The custom font files to use.
local FONT_FILES = {
-- UniqueFontName		= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\font_name.ttf",
-- DifferentFontName	= "Interface\\Addons\\MikScrollingBattleText\\Fonts\\different_font_name.ttf",
}


-------------------------------------------------------------------------------
-- Load.
-------------------------------------------------------------------------------

-- Loop through all of the fonts defined above and register them.
for fontName, fontPath in pairs(FONT_FILES) do
 MikSBT.RegisterFont(fontName, fontPath);
end