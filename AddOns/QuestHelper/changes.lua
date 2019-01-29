QuestHelper_ChangeLog="|cffffff00       Version 0.50 09/22/2008|r\
\
• Memory leak should now be fixed.\
\
|cffffff00       Version 0.49 09/21/2008|r\
\
• Most importantly: project has been resurrected by me. Let's have it for regular updates again!\
• Fixed code to remove \"flicker\" issue, though at the cost of some speed\
• Re-enabled nagging\
• Fixed a WoW client crash bug involving tooltips\
• Merged in a huge amount of data\
• Quite a few relatively unimportant small tweaks based around learning the codebase and fixing small issues\
\
|cffffff00       Version 0.48 07/16/2008|r\
\
• Fixed a compatability problem with WoW patch 2.4.3\
• Refined routing algorithms, hopefully reducing random fluctuations\
• Changed strategy for timing the background work task: task defaults to 4ms per frame re-draw.  The default perf setting (|cff40bbff/qh perf 100%|r) should now work fine on most systems.\
• Added new filter: |cff40bbff/qh filter tracked|r, which limits routing to objectives marked in the Quest Log.  This is for all the other cases of \"I just want to see X quests\".\
• Many translations updated and added\
\
|cffffff00       Version 0.47 05/20/2008|r\
\
• Added an in-game copy of the change log, to be displayed when an upgrade is detected.\
• The zone filter has been fixed, and will consider whether any of the known locations for an objective are where the player is or is flying to. Before, only the most probable location was considered.\
• Made some changes to the quest tracker:\
    • The progress for objectives for which only one thing is required is omitted. It's either there or it isn't.\
    • Option to add quest levels to quest names: |cff40bbff/qh tlevel|r\
    • Option to colour quest names by their difficulty: |cff40bbff/qh tqcol|r\
    • Option to colour objectives by their progress: |cff40bbff/qh tocol|r\
    • Option to scale the quest tracker: |cff40bbff/qh tscale|r\
    • Added a small button to quickly minimize or restore the quest tracker. The button will be invisible unless the cursor is over the quest tracker, and transparent when the quest tracker is minimized.\
    • The quest tracker can be repositioned by dragging the above button. The tracker will be re-anchored to the button depending on where on the screen it is placed so that when it changes size, it will grow away from the edges of the screen.\
    • The position of the quest tracker can be reset with this command: |cff40bbff/qh treset|r\
    • Hiding QuestHelper will now also hide the quest tracker.\
    • Will now force watched quests to be put at the top of the list, with a small gap seperating them from the automatically added quests. You can use the builtin quest log, beql, or DoubleWide to manage quest watches. Other addons might also work if they hook Blizzard's original quest watch functions properly. I also tried to make this work properly with UberQuest, but your milage may vary.\
    • Will include the quests of your party members, if sharing is enabled and they are also using QuestHelper.\
    • Will display the progress of your party members as a comma seperated list, although the list will only include unique values, so if everyone's progress is the same, this will appear as a single number.\
• Fixed a bug with objective icons inheriting their alpha value from the map frame, which Cartographer could hide.\
• Fixed a bug in routing, was caching the objective locations.\
• Assumes that if you die, you'll need to return to your body.\
• QuestHelper won't try to track objectives for failed quests.\
• Includes a submitted Russian translation.\
\
|cffffff00       Version 0.46 05/14/2008|r\
\
• Replaced the COPPER, SILVER, and GOLD strings that Blizzard renamed.\
• Added a replacement for the built in quest tracker that automatically populates itself and sorts itself to reflect QuestHelper's route.\
    • It only includes your own quests and objectives.\
    • Right click on a quest name to open that quest in your questlog.\
    • It can't be configured and you can't manually add or remove quests from it.\
    • You may disable it and restore the built in quest tracker by typing '|cff40bbff/qh track|r'.\
• Added objective information to the tooltips of items and monsters.\
    • They include information on the progress of party members also using QuestHelper.\
    • You may disable this by typing '|cff40bbff/qh tooltip|r'.\
• QuestHelper should dedicate less CPU time to routing when inside instances.\
• The pathing resets and flight time calculations now happen in a coroutine, so as to not lock up the game while the magic is happening.\
• Offended creationists by reimplementing routing using genetic algorithms.\
• Menus were given borders, and made more opaque.\
• Included an update for the Danish translation.\
• Will verify that QuestHelper's files all came from the same version, to ensure you installed or upgraded it properly.\
• Fixed a bug that sometimes broke the blocked objective filter an made objectives appear complete when there weren't.\
• Fixed a bug involving factions that broke objectives involving buying things from vendors.\
• Made some changes requested by the author of AlphaMap.\
"
