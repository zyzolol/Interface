local L = AceLibrary("AceLocale-2.2"):new("Talented")
local StaticPopupDialogs = StaticPopupDialogs

function Talented:LearnTalent(tab, index)
	local p = self.db.profile
	
	if not p.confirmlearn or 
		p.confirmlearn_skip_on_apply and self.mode == "apply" then
		LearnTalent(tab, index)
		return
	end
	
	if not p.always_call_learn_talents then
		local state = self:GetTalentState(self.current, tab, index)
		if
			state == "full" or -- talent maxed out
			state == "unavailable" or -- prereqs not fullfilled
			UnitCharacterPoints("player") == 0 -- no more points
		then
			return
		end
	end
	
	local info = self:GetTalentInfo(self.current.class)
	if not info then return end
	
	local opt = StaticPopupDialogs.TALENTED_CONFIRM_LEARN
	if not opt then
		opt = {
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				LearnTalent(opt.talent_tab, opt.talent_index)
			end,
			OnCancel = function()
				if self.mode == "apply" then
					self:SetMode(self.db.profile.default_mode)
					self:Print(L["Talent application has been cancelled. %d talent points remaining."], UnitCharacterPoints("player"))
					self:EnableUI(true)
				end
			end,
			timeout = 0,
			exclusive = 1,
			whileDead = 1,
			interruptCinematic = 1
		}
		StaticPopupDialogs.TALENTED_CONFIRM_LEARN = opt
	end
	
	local talent = info[tab].talents[index]
	
	opt.text = string.format(L["Are you sure that you want to learn \"%s (%d/%d)\" ?"], talent.info.name, self.current[tab][index] + 1, talent.info.ranks)
	
	opt.talent_tab = tab
	opt.talent_index = index
	
	StaticPopup_Show("TALENTED_CONFIRM_LEARN")
end
