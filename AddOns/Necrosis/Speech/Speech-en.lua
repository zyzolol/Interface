--[[
    Necrosis LdC
    Copyright (C) 2005-2006  Lom Enfroy

    This file is part of Necrosis LdC.

    Necrosis LdC is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Necrosis LdC is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Necrosis LdC; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--]]

------------------------------------------------------------------------------------------------------
-- Necrosis LdC
-- Originally by Lomig, Liadora et Nyx (Kael'Thas et Elune) [2005-2007]
-- Now updated by Tarcalion (Nagrand US/Oceanic) [2008-...]
--
-- Skins and French voices: Eliah, Ner'zhul
--
-- German Version by Geschan
-- Spanish Version by DosS (Zul’jin)
--
-- Version $LastChangedDate: 2008-03-30 15:05:46 +1000 $
------------------------------------------------------------------------------------------------------

function Necrosis:Localization_Speech_En()

	self.Speech.TP = {
		[1] = {
			"<after>Arcanum Taxi Cab! I am summoning <target>, please click on the portal.",
		},
		[2] = {
			"<after>Welcome aboard, <target>, you are flying on the ~Succubus Air Lines~ to <player>...",
			"<after>Air Hostesses and their lashes are at your service during your trip!",
		},
		[3] = {
			"<after>If you click on the portal, someone named <target> will appear and do your job for you!",
		},
		[4] = {
			"<after>If you do not want a sprawling, phlegm-looking, asthmatic creature to come from this portal, click on it to help <target> find a path through Hell as quickly as possible!",
		},
		[5] =  {
			"<after>Arcane Taxi Cab for <target>, please click the portal for the slacker please.",
		},
	}

	self.Speech.Rez = {
		[1] = {
			"<after>If you cherish the idea of a mass suicide, <target> can now self-resurrect, so all should be fine. Go ahead.",
		},
		[2]= {
			"<after><target> can go afk to drink a cup of coffee or something, soulstone is in place to allow for the wipe...",
		},
		[3]= {
			"<after>Hmmm... <target> is soulstoned... full of confidence tonight aren't we!!",
		},
		[4]= {
			"<after><target> is Stoned... duuuude heavy!",
		},
	}

	self.Speech.Demon = {
		-- Imp
		[1] = {
			[1] = {
				"You crappy nasty little Imp, stop sulking and get over here to help! AND THAT'S AN ORDER!",
			},
			[2] = {
				"<pet>! HEEL! NOW!",
			},
		},
		-- Voidwalker
		[2] = {
			[1] = {
				"Oops, I'll probably need an idiot to be knocked for me...",
				"<pet>, please help!",
			},
		},
		-- Succubus
		[3] = {
			[1] = {
				"<pet> baby, please help me sweetheart!",
			},
		},
		-- Felhunter
		[4] = {
			[1] = {
				"<pet> ! <pet>! Come on boy, come here! <pet>!",
			},
		},
		-- Felguard
		[5] = {
			[1] = {
				"<emote> is concentrating hard on Demoniac knowledge...",
				"I'll give you a soul if you come to me, Felguard! Please hear my command!",
				"<after>Obey now, <pet>!",
				"<after><emote>looks in a bag, then throws a mysterious shard at <pet>",
				"<sacrifice>Please return in the Limbs you are from, Demon, and give me your power in exchange!"
			},
		},
		-- Sentences for the first summon : When Necrosis do not know the name of your demons yet
		[6] = {
			[1] = {
				"Fishing? Yes I love fishing... Look!",
				"I close my eyes, I move my fingers like that...",
				"<after>And voila! Yes, yes, it is a fish, I can swear you!",
			},
			[2] = {
				"Anyway I hate you all! I don't need you, I have friends.... powerful friends!",
				"COME TO ME, CREATURE OF HELL AND NIGHTMARE!",
			},
		},
		-- Sentences for the stead summon
		[7] = {
			[1] = {
				"Hey, I'm late! Let's find a horse that roxes!",
			},
			[2] = {
				"<emote> is giggling gloomily...",
				"<yell>I am summoning a steed from nightmare!",
			},
			[3] = {
				"I call forth the flames of feet to make my travels swift!",
			},
		}
	}

	self.Speech.ShortMessage = {
		{{"<after>--> <target> is soulstoned for 30 minutes <--"}},
		{{"<after><TP> Summoning <target>, please click on the portal <TP>"}},
	}

end

