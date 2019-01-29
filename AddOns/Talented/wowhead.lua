local Talented = Talented
local ipairs = ipairs

local L = AceLibrary("AceLocale-2.2"):new("Talented")

function Talented:ImportWowTemplate(url, dst)
	local s, _, class, src = url:find(".*/(.*)/talents.html%?tal=(%d+)$")
	if not s then
		return
	end
	
	dst.class = class:upper()
	local count = 1
	local info = self:GetTalentInfo(dst.class)
	if not info then return end
	local len = src:len()
	
	for tab, tree in ipairs(info) do
		local t = {}
		dst[tab] = t
		for index in ipairs(tree.talents) do
			t[index] = tonumber(src:sub(count, count))
			count = count + 1
			if count > len then break end
		end
	end
	return dst
end

function Talented:ExportWowTemplate(template)
	local s = {}
	for _, tree in ipairs(template) do
		for _, n in ipairs(tree) do
			s[#s + 1] = tostring(n)
		end
	end
	return L["http://www.worldofwarcraft.com/info/classes/%s/talents.html?%s"]:format(template.class:lower(), "tal="..table.concat(s))
end

function Talented:ImportWowheadTemplate(url, dst)
	local s, _, code = url:find(".*/%?talent=(.*)$")
	if not s or not code then
		return
	end
	local res, val, class = pcall(self.StringToTemplate, self, code, dst, "0zMcmVokRsaqbdrfwihuGINALpTjnyxtgevE")
	if not res then
		return
	end
	dst.class = class
	return dst
end

function Talented:ExportWowheadTemplate(template)
	return L["http://www.wowhead.com/?talent=%s"]:format(self:TemplateToString(template, "0zMcmVokRsaqbdrfwihuGINALpTjnyxtgevE"))
end
