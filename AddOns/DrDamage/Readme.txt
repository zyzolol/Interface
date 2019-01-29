You can report bugs you find in #wowace @ irc.freenode.net to rw3/Gagorian or alternatively email me at gagorian(at)gmail.com

*** If any damage/healing calculation is incorrect, please report it. Provide as much information as possible. ***



DrDamage displays the calculated, average damage or healing of abilities with talents, gear and buffs included on your actionbar buttons. 
The addon will also add various information to the default tooltips in your spellbook and on the actionbar.


'''Slash Commands:'''

/drdmg or /drdamage


'''Functionality:'''

* Supports all classes
* Actionbar addons supported: Default, Bartender3&4, Bongos 2&3, CT_BarMod, DAB, Nurfed AB, CogsBar, InfiniBar, FlexBar2, TrinityBar 1&2, idActionBar and IPopBar.
* Places a text with metric of your choosing on the actionbar buttons
* Different damage and healing statistics from tooltips on the actionbar and in the spellbook. This includes for example crit %, spell damage and damage coefficients, averages (w/ or w/o crits/DoTs), DPS, DPSC (damage per seconds cast), damage until OOM and more!
* Includes your buffs and the target debuffs in calculations


'''More information about functionality:'''

* Uses mostly default WoW API to retrieve your stats, keeping tooltip scanning to a minimum
* Uses the same Adaptable damage/healing calculation engine used for all the calculations
* Easy table design to add/modify talent effects, spells and buffs/debuffs
* Allows manual modification of the essential base stats used to calculate (you can test how much that +n spelldamage or healing would increase your spells different calculated values)


'''FAQ:'''

*Are you planning to make a user interface for configuration?
** DrDamage has a FuBar plugin capability for easy configuration. DeuceCommander works as well.


KNOWN ISSUES:

*Improved divine spirit doesn't affect some spells (dark pact, lifetap at least) even if character screen displays it. DrDamage will report too high values. REASON: Blizzard bug. SOLUTION: None.
*Impossible to detect if the warlock curse (CoS/CoE) has been improved with malediction. REASON: Tooltip doesn't display it. SOLUTION: None.