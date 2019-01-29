--ZYGORGUIDESVIEWERFRAME_TITLE = "Zygor Guides Viewer";
ZYGORGUIDESVIEWERFRAME_TITLE = " ";

function ZygorGuidesViewerFrame_OnLoad()
end

function ZygorGuidesViewerFrame_OnHide()
	PlaySound("igQuestLogClose");
end

function ZygorGuidesViewerFrame_OnLoad()
	--
end

function ZygorGuidesViewerFrame_OnShow()
	PlaySound("igQuestLogOpen");
	--ZygorGuidesViewerFrame_Filter()
	if UnitFactionGroup("player")=="Horde" then
		ZygorGuidesViewerFrameTitleAlliance:Hide()
	else
		ZygorGuidesViewerFrameTitleHorde:Hide()
	end
	ZygorGuidesViewerFrame_Update()
end

function ZygorGuidesViewerFrame_Update()
	if ZygorGuidesViewer then ZygorGuidesViewer:UpdateMainFrame() end
end

function ZGVFSectionDropDown_Initialize()
	if ZygorGuidesViewer then ZygorGuidesViewer:InitializeDropDown() end
end

function ZGVFSectionDropDown_Func()
	if ZygorGuidesViewer then ZygorGuidesViewer:SectionChange(this.value) end
	ToggleDropDownMenu(1, nil, ZygorGuidesViewerFrameSectionDropDown, ZygorGuidesViewerFrame, 0, 0);
end

function ZygorGuidesViewerFrame_HighlightCurrentStep()
	if ZygorGuidesViewer.CurrentStepNum then ZygorGuidesViewer:HighlightCurrentStep() end
end