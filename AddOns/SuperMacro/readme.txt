~~==[[=^=^=^==>

SuperMacro v4.04 by Aquendyn

Installing SuperMacro:
Before you unzip, backup your old Bindings.xml and SM_Extend.lua that are in the SuperMacro folder (if you have on older version of SuperMacro).
Unzip the files into WoW/Interface/Addons . A new directory called SuperMacro will be automatically created, and the files will be extracted there.
Then, copy your backup Bindings.xml into SuperMacro folder, if you have one.
You may also create a text file called SM_Extend.lua and put extra-long codes in there.

This addon provides a very much improved interface for macros. Its special functions includes the following, and probably more:
New SuperMacro frame shows all 18 global and 18 character macros. *
Work around the maximum macro character length of 256 characters (system limit).**
Run macros through keybinds*** and call other macros with RunMacro()****.
Some convenient slash commands and functions*****.
Put an item link or tradeskill recipe into the macro***** *.
Ingame extended LUA code editor***** **.
Options frame***** ***.
Also see functions.txt for user-friendly functions and slash commands that can be used in your macros.

~~==[[=^=^=^==>

* The new SuperMacro interface displays 18 (global) account macros on the left and 18 character-specific macros on the right. Buttons at the top create new macros for each category. Buttons on the bottom are, in order, open SuperMacro options frame; delete macro; save macro; delete extend; save extend; exit frame. Enter your macro in the left editbox, and your extended LUA codes and functions in the right editbox. Right-click on the macro icons to execute that macro. (Trying to cast a spell this may cause an error to pop up. Non-secure scripts are still performed.)

Switch between Regular and Super macros by clicking on the tabs on the bottom of the frame. The Super tab displays 30 Super macros at a time. If you have more than 30, it will turn into a scroll frame so that scrolling down will show the rest. In theory, there is no limit to the number of Super macros you can have, except maybe hard drive space, memory, etc. Buttons on the bottom are, in order, open SuperMacro options frame; delete Super; save Super; new Super; exit frame. Enter your macro in the wide editbox--up to 7000 characters long. These Super macros are saved in SavedVariables.

There are a few ways to open the SuperMacro frame:
The button below the minimap
The vertical button in main menu (can be turned off in SM Options)
Set a keybinding (in Key Bindings Options, look for Toggle SuperMacro Frame under SuperMacro heading)

~~==[[=^=^=^==>

** The letter limit for the entire macro is 256. However, you can get around that if you call it through another macro, or put long functions in SM_Extend.lua file, or use the in-game extend editor (explained further down in this document.)

Suppose macro 1 has more than 256 characters. If you put this directly on your action bar and try to activate it, you will get an error because the rest of the line beyond the 256th character will be cut off when the macro is saved. What you can do is break up the long macro into smaller parts, and have them call each other, like so (where macro 1 is named Macro1):
/script RunMacro("Macro1") --more scripting here

Then put this new macro on your action bar.

WARNING: You cannot cast spells from other macros using RunMacro or RunSuperMacro or /macro.

However, you can chain onto other macros that WILL cast spells by putting the /click command at the very end of the macro. (Everything after it will not execute.)

SuperMacro uses two methods.

Method 1:
/click MacroClickN or /click SuperMacroClickN , where N is the macro or supermacro's id as shown in the frame.
(CAUTION: Deleting or creating new macros will shift the numbers, so you may need to update the /click lines for each macro.)

Method 2:
/click MacroClick_macroname or /click SuperMacroClick_macroname, where macroname is the macro's name. (note the underscore _ )

Ex. SuperMacro #1 has this body
/startattack
/cast heroic strike

And Macro #2 named "strike" has this body
/click SuperMacroClick1

Now put Macro #2 on your action bar and press the button to start attacking.

Ex. if we added to the last 2 examples
Macro #3 has this body
/click MacroClick_strike

If you execute Macro #3, it will execute Macro #2, which will execute SuperMacro #1.

~~==[[=^=^=^==>

Alternatively, put extremely long functions in a file called SM_Extend.lua, which you have to create since the zip doesn't come with this file (so that it doesn't get overwritten when you unzip.)

You can also put global variables and constants in this file.

To define a function in a lua file:

function FunctionName(parameter1, parameter2, etc.)
	-- code goes here
	-- return variable
end

FOR EXAMPLE:

function FindTradeSkillIndex(tradeskill)
	if (TradeSkillFrame:IsVisible()) then
		for i=1,GetNumTradeSkills() do
			tsn,tst,tsx=GetTradeSkillInfo(i);
			if (tsn==tradeskill) then
				tsi=i;
				SelectTradeSkill(tsi);
				TradeSkillInputBox:SetNumber(tsx);
				TradeSkillFrame.numAvailable=tsx;
				return tsi, tsx;
			end
		end
	end
end

Then, your macro would look something like this:
/cast First Aid
/script tsi,tsx=FindTradeSkillIndex("Heavy Linen Bandage") if (tsx) then DoTradeSkill(tsi,tsx-1) end

If you change the file SM_Extend.lua while in-game, you need to reload your UI by closing your Macro frame, then entering /script ReloadUI() or /rl into the chat line--even better make a macro and keybind for this:
/script ReloadUI()
OR
/rl

~~==[[=^=^=^==>

*** The default bindings for this addon provides entries for Macros #1 through #36. Using these as examples, you can add more keybinds by editing the bindings.xml file. Backup this file before you install a new version of SuperMacro.

~~==[[=^=^=^==>

**** SuperMacro lets your macros call other macros with the special function RunMacro(index) or RunMacro("name"). If index is a number without quotes, it will call the macro in the order displayed in the macro frame. If you instead provide a name of the macro within quotes, you can call the macro if you know its name.

In Bindings.xml for this addon, you will notice bindings for RunMacro(1) through RunMacro(36). They will run the respective macro in the order that you see in the macro frame. Macros 1 to 18 are account macros, and Macros 19-36 are character-specific macros. If you add or delete macros, their order may change, so be careful here. You are free to edit those bindings to call your own macros.

You can use a macro to call other macros simply by providing the name of the other macro. When writing a macro, you will have something like this:
/script RunMacro("CookFood");

where CookFood can be replaced by the name of another macro.
You can also use Macro() in place of RunMacro() if you are close to 256 letter limit.

WARNING: You cannot cast spells from other macros using RunMacro or RunSuperMacro or /macro. Scroll UP to see how to use /click to call other macros that WILL cast spells.

~~==[[=^=^=^==>

***** SLASH COMMANDS
For complete info on slash commands and their corresponding LUA functions, read functions.txt.

SuperMacro changes the /macro command so that you can run a macro from the chat line. Use /macro <macro_name>. This is equivalent to /script RunMacro("macro_name").
Ex. /macro CookFood

Another slash command is /supermacro for setting SuperMacro options. Just /supermacro shows help for these options.

The first option is hideaction 1 or 0. For instance,
/supermacro hideaction 1
/supermacro hideaction 0
Setting it to 1 hides the macro names on action buttons, and 0 shows them. This option is saved between sessions under SM_VARS.hideAction.

/supermacro macrotip 0-3
/supermacro macrotip 1 is default setting
0 is normal, 1 show spells only, 2 show macro code only, 3 show spells and/or macro
This replaces the text in the game tooltip when the cursor moves over the action bar buttons. Instead of just showing the macro name, you can choose to have it show the spell's name, if the macro casts a spell, or show the macro code. For option 3, it will try to show the spell first. If that fails, it will show the macro code.

These options and more can also be set in the SuperMacro options frame.

To print some text to the default chat frame, you can use the /print command. Other people cannot see what is printed.
Ex. /print Hello, world.
The default color is white. You can change the color of this text with /supermacro printcolor <red> <green> <blue>
where red, green, and blue are decimal numbers between 0 and 1. This option changes the color of the text in the /print slash command.
Ex. /supermacro printcolor 1 .5 0.03
Ex. /supermacro printcolor default
The last line sets the color back to default color, which is white.

~~==[[=^=^=^==>

***** * ITEM LINKS
You can put item links directly into a macro by using Alt-click on the item button. You can do this for container items,  inventory (equipment) items, bagslots, and tradeskills. Bagslots are the icons on the main menu bar.

To link tradeskills items, Alt-click on the skill in the top half of the frame, that is, where you would select the skill, or Alt-click the icon. Ctrl-Alt-click will insert the recipe into the macro.

Shift-click on item or tradeskill will insert its name, and Ctrl-Shift will insert its name inside quotes.

Since I was doing this anyway, you can also Shift-click on the skill in the same way to put it into the chat edit box (in addition to Shift-clicking on the icon). Ctrl-Shift-click will insert the recipe into chat edit box.

Similarly, you can Shift-click spells from the spell book to insert /cast <spellname>(<spellrank>). Ctrl-Shift-click to insert just the "<spellname>(<spellrank>)" (with quotes.) Alt-Shift-click on spell in spellbook to insert <spellname>(<spellrank>) (without quotes).

~~==[[=^=^=^==>

***** ** Ingame extend LUA code editor and SM_EXTEND.lua
The right edit box in SuperMacro frame is for extended codes that is associated with that macro. This is saved in SavedVariables under SM_EXTEND table, which is not associated with SM_EXTEND.lua in any way. Either way, these extended codes can be accessed by all macros, usually in the form of functions.

SM_EXTEND.lua does not come with the zip. If you choose to use this feature, you must create a text file and name it SM_EXTEND.lua . Any code you put in this file will be loaded when the addon is first loaded. Your code can be any length. However, if you edit this during playing, you have to reload UI for the changes to take effect.

The in-game extend editor does not need reloading, simply press the Save Extend button. However, the max length for each macro's extend is 7000 letters (not including the macro itself, which is a totally separate issue.) CAUTION, make sure your code has no errors before you close the macro frame.

There are also weird behaviors when you make a new macro or rename a macro.
When you create a new macro with the same name as an existing macro, it will inherit the same extend code from the existing macro.
When you rename a macro with a new name that is the same as another existing macro, the former's extend will be used for both. For example, if macro A has the extend code a=b, macro B has extend b=a, and you rename macro A to macro B, then both macros will now have extend a=b.

If a macro is deleted, the extend that goes with it is also deleted if there are no other macros with the same name.

