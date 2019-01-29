--ZYGORGUIDESVIEWERFRAME_TITLE = "Zygor Guides Viewer";

function ZygorGuidesViewerMiniFrame_OnLoad()
--	this.selectedButtonID = 2;
--	this:RegisterEvent("QUEST_LOG_UPDATE");
--	this:RegisterEvent("QUEST_WATCH_UPDATE");
--	this:RegisterEvent("UPDATE_FACTION");
--	this:RegisterEvent("UNIT_QUEST_LOG_CHANGED");
--	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
--	this:RegisterEvent("PARTY_MEMBER_ENABLE");
--	this:RegisterEvent("PARTY_MEMBER_DISABLE");
	if ZygorGuidesViewer then
		--
	end

	ZygorGuidesViewerMiniFrame:SetMinResize(320,100)
end

function ZygorGuidesViewerMiniFrame_OnHide()
	PlaySound("igQuestLogClose");
end

function ZygorGuidesViewerMiniFrame_OnShow()
	PlaySound("igQuestLogOpen");
	--ZygorGuidesViewerFrame_Filter()
	ZygorGuidesViewer:UpdateMiniFrame()
end

