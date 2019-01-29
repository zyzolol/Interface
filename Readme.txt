----------------------------
BLP2PNG
Written by John Stephen
----------------------------

This tool is used for converting between BLP images and PNG images.  The tool fully supports alpha channels and can be used as a drag-and-drop converter or from the command line.  It can also convert your existing TGA files to PNG.

BLP2PNG will convert the file based on the original type:

BLP are converted to PNG
BMP are converted to PNG
TGA are converted to PNG
PNG are converted to BLP

----------------------------
Why PNG when everybody uses TGA?
----------------------------

PNG is a modern image format and is better supported by more tools and even most web browsers.  Support for PNG in Photoshop is much better than it is for TGA, which makes editing high-quality textures for addons a lot easier.  If you prefer working in TGA then by all means keep using the many existing tools for converting those images.  I use this tool for converting WoW's artwork to PNG so I can use it as a reference for my own artwork.  I also use this tool to convert my own artwork to BLP files for use in my addons, including GroupCalendar and Outfitter.  If you prefer PNG like I do, this tool will make things much easier for you.

----------------------------
Drag-and-drop operation
----------------------------

Select one or more image files and drop them onto the BLP2PNG.exe file.  The converted file(s) will be placed in the same directory as the original file but with the new extension.

----------------------------
Command line operation
----------------------------

BLP2PNG.exe file [-o folder]

file   Specifies the file you want to convert
folder Specifies the folder you want the output file place
       in.  The file will have the same name as the original
       with the new extension.  If this folder isn't specified
       then the file will be placed in the same folder as the 
       original

----------------------------
WARNING: If the output file already exists it will be replaced without warning.
----------------------------
NOTE: Windows has limits on the total length of parameters passed to an application.  Because of this you may get an error from Windows if you try to drag-and-drop convert too many files at one time.  If this happens, select them in smaller batches for conversion.
----------------------------
