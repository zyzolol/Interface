Displays energy ticks and combo points on a progress bar

EnergyWatch v2 : Usage - /ew option
options:
on	: Enables EnergyWatch
off	: Disables EnergyWatch
unlock	: Allows you to move EnergyWatch
lock	: Locks EnergyWatch
invert	: Invert progress bar direction
scale _	: Scales EnergyWatch bar (0.25 - 3.0)
alpha _	: Sets bar Alpha (opacity) (0.0 - 1.0)
reset	: Resets bar scale, alpha and position to defaults
help _	: Prints help for certain options (below)
text _	: Sets the text on EnergyWatch
sound _	: Sets Sound on/off or custom
show _	: Set when EnergyWatch should be shown

EnergyWatch : Usage - /ew text string
 string may contain a few special replacements:
  &e  : Current Energy
  &em : Maximum Energy
  &c  : Combox Points

Energywatch_v2 : Usage - /ew sound option
 options:");
  on : Plays default sound on energy tick
  off : No sound on energy tick
  <sound name or filename> : Plays specified sound effect on energy tick
  sound name is internal WoW sound effect; list can be found at http://www.wowwiki.com/API_PlaySound
  filename is a WAV or MP3 file in the EnergyWatch_v2 addon folder

EnergyWatch_v2 : Usage - /ew show option
 option:
  always      : Always shown
  combat      : Shown in Combat
  stealth     : Shown in Combat and while Stealthed
  stealthonly : Show only while stealthed

Druids - EnergyWatch will only be visible while you
are in cat form, and your selected "show" option is
true.

---

ChangeLog
2.4.2
------------------------------------------------
EnergyWatch now only plays a sound if the bar is showing

2.4.1
------------------------------------------------
Reverted to old internal method of detecting stealth, as Blizzard's appears to be innacurate at times
Fixed EnergyWatch showing up for Night Elf Druids when they Shadowmeld

2.4
------------------------------------------------
TOC update for WoW 2.4
Changed stealth detection to use Blizzard's IsStealthed API method

2.3
------------------------------------------------
TOC update for WoW 2.3
Added ability to change Energy Watch bar alpha
Added reset function to reset bar scale, alpha and position (useful if you lose the bar)

2.2
------------------------------------------------
TOC update for WoW 2.2 

2.1
------------------------------------------------
TOC update for WoW 2.1
Added ability to play WAV/MP3 sound files on energy tick - see /ew help sound

2.0.3
------------------------------------------------
Updated TOC for 2.0.3
Fixed stealth detection not working for non-english localizations
Minor bug fixes

2.0
------------------------------------------------
Updated for patch 2.0
Refined bar Show/Hide logic and routines
Modified all show options to show for druids only while in cat form

1.4
------------------------------------------------
Updated for patch 1.9

1.3
-------------------------------------------------
There is a new option, stealth only.  Type /ew show stealthonly.

1.2
-------------------------------------------------
EnergyWatch will now work in druid stealth form.
If you reload your UI the energy bar will now be shown if it was before.

1.1
-------------------------------------------------
Changed the file to a zip file.

1.0
--------------------------------------------------
Watching UNIT_ENERGY event. This will fix the problem with 
energy not correctly getting set on load. 
Removed the Event for UNIT_MANA. This is not need since we
are using UNIT_ENERGY.
You can now have your combo points shown on the energy bar. 
I find this extremely useful. When doing the text replacement 
use &c. For example, to show a text of Energy with combo points 
and Current Energy you could do.
/ew text Energy (&c) &e. At 100 energy and 2 combo points this would be 
Energy (2) 100

---

Authors

2.0 Update
------------------------
OneWingedAngel -- Entreri of Silvermoon

Author
------------------------
Repent -- Shadoh of Laughing Skull

Original Author
------------------------
Vector- - Kerryn of Laughing Skull

