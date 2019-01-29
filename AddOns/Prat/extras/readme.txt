PRAT - A chat framework for WoW
===============================


--

Prat consists of a core set of functions built on the Ace2 libraries, which
make up a framework providing a stable, extensible, and relatively light
environment for modifying aspects of WoW's chat system.


--


Quick pointers to other resources:
----------------------------------

 - WOWACE WIKI:     http://www.wowace.com/wiki/Prat
 - WOWACE FORUM:    http://www.wowace.com/forums/index.php?topic=6243
 - GOOGLE CODE:     http://code.google.com/p/prat/
 - GOOGLE GROUP:    http://groups.google.com/group/wow-prat/
 - LATEST VERSION:  http://files.wowace.com/Prat/


--


About Prat
----------
The Prat system consists of the core (Prat/Prat.lua) and a number of
integrated Prat modules in the modules folder (Prat/modules/*). The core
only provides a basic slash command ("/prat") and registers a database
(PratDB). It also provides an API that allows modules (and other addons)
to modify the in-game chat system without having to worry about conflicting
addons.


Each Prat module is a self-contained unit of functionality, and can be
enabled or disabled using a simple in-game management system or simply by
deleting the module's .lua file. There are no interdependencies between
modules, making it safe to use as much or as little of the available
features as you prefer.


The entire focus of the Prat system is to add chat related functionality to
World of Warcraft.  If you are looking for a feature or function that is
not currently listed here as available or planned, then please take a
moment to let the Prat Development Team know - you can get in touch with us
on IRC, via PMs in the forum, or just by posting to the forum thread listed
above.


--


Why the name Prat?
------------------
That's a great question that I've seen asked quite often on the IRC channel.
In theory the word Prat loosely translates to Chat in swedish.  The system
itself has nothing to do with Sweden, however inspiration for the name was
drawn from thoughts of The Swedish Chef (Bork! Bork! Bork!), IKEA, Swiss
Miss Hot Chocolate (Mmm..), Swedish Meatballs (Mmm..), and Swedish Swimsuit
Models (Mmm..).  It may help users to accept the name if they, too, think
of these things.  ^^

It has been thought that "Prat" came from "Prattle". This may be true.


--


Development Team
----------------
These are the authors currently working on the project:

 * Sylvanaar of Proudmore
 * Fin of Stormrage-EU
 * Curney of Uther
 * Krtek

Developers interested in contributing are welcome to get in touch with a
team member.



Integrated Modules
------------------
[NB: Please note that Prat is still in development, modules are being added,
 updated, removed, and merged all the time; for a definitive list, it's
 always best to just download the latest version.]

These modules are included in the Prat modules folder (Prat/modules/*):

 * AddonMessages - Toggles showing hidden addon messages on and off (default=off).
 * Alias - Allows you to specify aliases for commonly used slash commands (default=off).
 * AltNames - Lets you identify alt characters in chat messages (default=off).
 * Buttons - Toggles the chat menu and chat window buttons on and off (default=off).
 * ChannelColorMemory - Remembers the colors of channels by channel name.
 * ChannelNames - Shortens channel names in the chatframe.
 * ChannelSeparator - Separates various channel options in the Blizzard UI (default=on).
 * ChatFrames - Options for manipulating chat frames.
 * ChatLink - Enables item linking in all channels (default=CHATLINKmode).
 * Editbox - Options for editbox position, width, and backdrop alpha (default=attachedTop,widthChatFrame1,visibleBackdrop).
 * EventNames - Toggles showing event names on and off (default=off).
 * Fading - Toggles the fading in chat windows on and off (default=off).
 * FontSize - Sets the font size for chat windows (default=12).
 * Highlight (text highlighting options coming soon)
 * History - Expands chat history options.
 * Justify - Sets the justification for chat windows (default=Left).
 * Keybindings - Adds keybindings for different chat channels.
 * PlayerNames - Color player names by class, set brackets around player names (default=angledBrackets).
 * PopupMessage - Displays chat with your name in a pop up window.
 * Scroll - Enables mousewheel scrolling for chat windows (default=on).
 * StickyChannels - Toggles sticky of different chat channels on and off (default=on).
 * Substitutions - Provides a basic set of chat tags for use in macros (default=off).
 * TellTarget - Adds a slash command (/tt) to send a message to your target (default=on).
 * Timestamps - Adds timestamps to chat windows (default=on).
 * UrlCopy - Makes URL copying easy (default=on).


--


Reporting Bugs and Requesting Features
--------------------------------------
Please use the Google Project issues tracker for reporting bugs and
suggesting feature requests, or post to the WoWAce.com forum thread:

 - http://code.google.com/p/prat/
 - http://www.wowace.com/forums/index.php?topic=6243

You are also welcome to come by #wowace on irc.freenode.net - Fin is often
there, and while sylvanaar is less often around than before (and missed),
he can still sometimes be caught if you camp out long enough. Please note
the following site is useful for showing error logs, code changes, patches,
and other large amounts of text that would otherwise annoy people on IRC:

 - http://ace.pastey.net/


--


More information
----------------
For more information, please see the Wiki, or any of the URLs listed at the
top of this file.


Love,

 - The Prat Development Team
