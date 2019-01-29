-------------------------------------------------------------------------------
-- Title: Mik's Scrolling Battle Text Sounds
-- Author: Mik
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Private constants.
-------------------------------------------------------------------------------

-- The sound files to use.
local SOUND_FILES = {
 LowHealth		= "Interface\\Addons\\MikScrollingBattleText\\Sounds\\LowHealth.mp3",
 LowMana		= "Interface\\Addons\\MikScrollingBattleText\\Sounds\\LowMana.mp3",
}


-------------------------------------------------------------------------------
-- Load.
-------------------------------------------------------------------------------

-- Loop through all of the sounds and register them.
for soundName, soundPath in pairs(SOUND_FILES) do
 MikSBT.RegisterSound(soundName, soundPath);
end