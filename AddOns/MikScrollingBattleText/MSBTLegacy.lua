-------------------------------------------------------------------------------
-- Title: Mik's Scrolling Battle Text Legacy
-- Author: Mik
-------------------------------------------------------------------------------

-- ****************************************************************************
-- DEPRECATED.  DO NOT USE.
-- USE MikSBT.IterateScrollAreas INSTEAD.
-- See the included API.html file for usage info.
-- ****************************************************************************
function MikSBT.GetScrollAreaList()
 -- Create a new table to hold the list.
 local scrollAreas = {};

 -- Loop through all of the scroll areas and add them to the list.
 for _, scrollAreaName in MikSBT.IterateScrollAreas() do
  scrollAreas[#scrollAreas+1] = scrollAreaName;
 end
 
 return scrollAreas;
end


-- ****************************************************************************
-- DEPRECATED.  DO NOT USE.
-- USE MikSBT.IterateFonts INSTEAD.
-- See the included API.html file for usage info.
-- ****************************************************************************
function MikSBT.GetRegisteredFontList()
 -- Create a new table to hold the list.
 local fonts = {};

 -- Loop through all of the registered fonts and add them to the list.
 for fontName in MikSBT.IterateFonts() do
  fonts[#fonts+1] = fontName;
 end

 return fonts;
end