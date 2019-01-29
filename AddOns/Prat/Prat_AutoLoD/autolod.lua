local L = AceLibrary("AceLocale-2.2"):new("Prat_AutoLod")

L:RegisterTranslations("enUS", function() return {
    ["Load Modules"] = true,
    ["Hiding %d Modules"] = true,
    ["Modules Not Loaded: Loading Modules"] = true,
    ["Disabled: Loading %d Previously Not Loaded Modules"] = true,
    ["Enabled: %s Your UI To Unload Unused Modules"] = true,
    ["Enabled: %d Modules Removed"] = true,
} end)

--Chinese Translate by Ananhaid(NovaLOG)@CWDG
--CWDG site: http://Cwowaddon.com
L:RegisterTranslations("zhCN", function() return {
    ["Load Modules"] = "加载模块",
    ["Hiding %d Modules"] = "隐藏 %d 模块",
    ["Modules Not Loaded: Loading Modules"] = "未加载此模块: 加载模块",
    ["Disabled: Loading %d Previously Not Loaded Modules"] = "已禁用: 加载 %d 先前未加载模块",
    ["Enabled: %s Your UI To Unload Unused Modules"] = "已启用: %s 使用者界面，卸载不用的模块",
    ["Enabled: %d Modules Removed"] = "已启用: 移除 %d 模块",
} end)

L:RegisterTranslations("zhTW", function() return {
    ["Load Modules"] = "載入模組",
    ["Hiding %d Modules"] = "隱藏%d個模組",
    ["Modules Not Loaded: Loading Modules"] = "未載入模組: 載入模組",
    ["Disabled: Loading %d Previously Not Loaded Modules"] = "已停用: 載入%d個先前未載入模組",
    ["Enabled: %s Your UI To Unload Unused Modules"] = "已啟用: %s使用者介面，卸載不用的模組",
    ["Enabled: %d Modules Removed"] = "已啟用: 移除%d個模組",
} end)


AutoLOD = {}

local AutoLOD = AutoLOD

local function LoadComponent(name)
    EnableAddOn(name)
    LoadAddOn(name)
    collectgarbage('collect')
end

function AutoLOD:VariablesLoaded()
    PratAutoLOD = PratAutoLOD or {}
    AutoLOD.SaveData = PratAutoLOD
end

function AutoLOD:GetMessage()
    if not IsAddOnLoaded("Prat_Modules") then
        return L["Load Modules"]
    end

    if not IsAddOnLoaded("Prat_Modules_AutoLoD") then
        if self.off_count and self.off_count > 0 then
            return L["Hiding %d Modules"]:format(self.off_count)
        end
    end

    return nil
end


function AutoLOD:Save(autolod_enabled)
    AutoLOD:VariablesLoaded()

    if not IsAddOnLoaded("Prat_Modules") then
        Prat:Print("|r[|cffeda55fAutoLoD|r] "..L["Modules Not Loaded: Loading Modules"])

        LoadComponent("Prat_Modules")
        return false
    end


    local data = Prat.Modules
    local count = 0

    for k,v in pairs(data) do
        if autolod_enabled then
            if Prat:HasModule(v) then
                local m = Prat:GetModule(v)

				if m.db then 
	                self.SaveData[v] = m.db.profile.on
				end
            end
        else
            if not Prat:HasModule(v) then
                data[k] = nil
                count = count + 1
            end

            self.SaveData[v] = true
        end
    end


    if not autolod_enabled and IsAddOnLoaded("Prat_Modules") then
        Prat:Print("|r[|cffeda55fAutoLoD|r] "..L["Disabled: Loading %d Previously Not Loaded Modules"]:format(count))

        LoadComponent("Prat_Modules_AutoLoD")
        
     	-- Enable all modules
    	local name, module = nil, nil
    	for name, module in Prat:IterateModules() do
    	    if not Prat:IsModuleActive(module) then
        		Prat:ToggleModuleActive(module, true)
        	end
    	end        
    end

    if autolod_enabled then
        Prat:Print("|r[|cffeda55fAutoLoD|r] "..L["Enabled: %s Your UI To Unload Unused Modules"]:format(Prat:GetReloadUILink()))
    end

    return autolod_enabled
end


function AutoLOD:Load(auto_lod_enabled)
    AutoLOD:VariablesLoaded()

    if auto_lod_enabled then
        local total_count, off_count = 0, 0
        for k,v in pairs(self.SaveData) do
            total_count = total_count + 2
            if v == false then
                off_count = off_count + 1
                Prat:RequestModuleName(k)
            end
        end

        if not IsAddOnLoaded("Prat_Modules") then
            self.off_count = off_count

	    if not Prat.db.profile.hidestartupspam then
		Prat:Print("|r[|cffeda55fAutoLoD|r] "..L["Enabled: %d Modules Removed"]:format(off_count))
	    end

            LoadComponent("Prat_Modules")
        end
    else
        if not IsAddOnLoaded("Prat_Modules") then
            LoadComponent("Prat_Modules")
        end
    end
end
