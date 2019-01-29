BindPad -- Created by Tageshi

-------------------------------------------------------------------------
1. WHAT IS "BindPad"?
-------------------------------------------------------------------------

BindPad is an addon to make KeyBindings for spells, items, and macros.
You no longer need actionbar slots just to make Key bindings for your macores etc.

BindPad addon provides many icon slots in its frame.  You can drag and drop 
anything into one of these slots, and click the slot to set KeyBindings.



-------------------------------------------------------------------------
2. HOW TO USE "BindPad"?
-------------------------------------------------------------------------

  (1) Type /bindpad or /bp to display BindPad frame.
      (Also you can find "Toggle BindPad" Keybinding command in standard 
       KeyBindings frame of Blizzard-UI.)

  (2) Open spellbook frame (p), you bag (b), or Macro Panel (/macro).
      (Also you can use three mini-icons on BindPad frame to open these windows.)

  (3) Drag an spell icon, item icon, or macro icon using left button drag and 
      drop it onto the BindPad window.  
      (Maybe you need shift key + left button drag if action bars are locked.)

  (4) Now you see the icon placed on BindPad frame.  Click it,
      and a dialog window "Press a key to bind" will appear.

  (5) Type a key to bind.  And click 'Close' button.

  (6) When you want to remove icons from BindPad frame, simply drag away the icon 
      and press right click to delete it.

      Note that KeyBinding itself will not be unbinded when you delete the icon.
      To unbind it, click the icon and click Unbind button on the dialog window.
      Also you can simply override Keybindings.


-------------------------------------------------------------------------
3. HOW TO USE TABS
-------------------------------------------------------------------------

There are four tabs on BindPad frame; 'General Slots', '<Character> Specific Slots',
'2' and '3'. (aka. 2nd and 3rd <Character> specific slots)
Any icons placed on 'General Slots' are for all characters of your account. 
Those on '<Character> Specific Slots' are for that specific character only.

Note that you can use '<Character> Specific Slots' tab only after you click
'Character Specific Key Bindings' check box at standard KeyBindings frame of Blizzard-UI.

From BindPad version 1.5, you can see this checkbox on BindPad window itself too.
(Also BindPad will inform you about 'Character Specific Key Bindings' and automatically 
activate it for you when you click '<Character> Specific Slots' tab.)



-------------------------------------------------------------------------
4.  "You want to convert this icon into a BINDPAD MACRO?"... What?
-------------------------------------------------------------------------

"BindPad Macro" is a new feature from BidPad version 1.8.0 ;
which allow you to make almost unlimited number of virtual macro icons.

Older versions of BindPad just let you save your limited action bar slots.
This new BindPad will let you save your limited macro slots on the standard 
"Create Macro" panel.

Usage:
  - Click the small red "+" icon to create an empty BindPad Macro.
  - Right-click an existing spell/item/macro icon on BindPad to convert it into a BindPad Macro.
  - Right-click the "BindPad Macro" to edit macro-text.
  - ...and you can use left-click to set keybindings as usual.

Note that BindPad Macro will only exist within the BindPad frame; 
You can drag-and-drop them within BindPad, but you cannot drop them outside.


-------------------------------------------------------------------------
5.  DETAILS
-------------------------------------------------------------------------

BindPad addon utilizes new functions added from WoW API 2.0 .

You can use these functions (and many others) in any addons or macros.

  GetBindingKey("command")
  SetBindingSpell("KEY", "Spell Name")
  SetBindingItem("KEY", "itemname")
  SetBindingMacro("KEY", "macroname"|macroid)

Just don't forget to save changes by
  SaveBindings(GetCurrentBindingSet());


There are some other similar addons by other authers.
Try them and choose what you like.

SpellBinder
http://www.wowinterface.com/downloads/info5614-SpellBinder.html

And at least one more good addon that I have forgot its name...



-------------------------------------------------------------------------
6.  WHERE CAN I GET LATEST VERSION?
-------------------------------------------------------------------------

You can get latest version of BindPad from www.wowinterface.com:

http://www.wowinterface.com/downloads/fileinfo.php?id=6385

Or from Curse:

http://www.curse.com/downloads/details/5002/


-------------------------------------------------------------------------
7.  CHANGES
-------------------------------------------------------------------------

Version 1.8.6
- Fixed a drawing order problem of "Show Hotkeys"
  for Bartendar4 and probably for Bartendar3.
- Added locatization for zhCN and zhTW. (Thanks xinsonic)

Version 1.8.5
"Show Hotkeys" now supports Bartendar4.

Version 1.8.4
Added a workaround for error message "GetSpellName(): Invalid spell slot".

Version 1.8.3
- (Really) fixed the display issue of "Show Hotkeys" on compatibility with Bongos3.
- Added "Test" button on the BindPad Macro frame to test the macro while editing.
- Improved the keybinding confirmation window when the key is already
  bound to a BindPad Macro.

Version 1.8.2
Fixed a bug which sometimes prevented BindPad to detect correct spell 
rank after respeccing talent or training new spells.


Version 1.8.1
Fixed display issue of "Show Hotkeys" function introduced in 1.7.1; Compatibility with Bongos3 fixed.
(EDIT: Actually it was not yet fixed.)


Version 1.8.0

"BindPad Macro" : New feature to make almost unlimited number of virtual macro icons.
BindPad Macro is made for you to save limited macro slots on the standard Blizzard UI.
BindPad Macro will only exist within the BindPad frame, and allow you to make keybindings on them.

  - Click the small red "+" icon to create an empty BindPad Macro.
  - Right-click an existing spell/item/macro icon on BindPad frame to convert it into a BindPad Macro.
  - Right-click the "BindPad Macro" to edit macro-text.
  - ...and you can use left-click to set keybindings as usual.


Version 1.7.1
Added an option checkbox "Show Hotkeys".
The hotkey function now supports all ActionBar AddOns in addition to Blizard UI.
(Only tested for Bartendar3 addon.)


Version 1.7.0
Added an ability to automatically display binded hotkeys on ActionBar buttons.
(Suggested by Pheon)


Version 1.6.1
Updated for WoW client 2.3.0 .
Fixed a bug causing macro icons sometimes not working.


Version 1.6
Added two extra tabs for heavy users.


Version 1.5.1
TOC update.


Version 1.5
TOC update.
Added the 'Character Specific Key Bindings' check box at upper right corner of BindPad frame.
Added some functions to inform about 'Character Specific Key Bindings'.


Version 1.4
TOC update.
Added three mini-icons to open Spellbook, Macros Panel, and All bags.
Now uses new GetCursorInfo() API. (Slouken have kindly added it for me.)
You can now drag&drop icons from Action Bars too.
You can now use mouse wheel up/down as a keybind.


Version 1.3 (Now really updated version):
Added slash command /bindpad and /bp


Version 1.2 (not uploaded!):
More bug fixes.
Savefile format was changed and not compatible to 1.0 and 1.1.
(Old save data will be deleted when you use version 1.2; that don't unbind but you need to drag icons again.)


Version 1.1 (not uploaded!):
Fixed some tainting bug.


Version 1.0
Initial release.
