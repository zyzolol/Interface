--[[
	Template encoding code is heavily borrowed from wowhead, but use a different map.
	StringToTemplate and TemplateToString
]]
local assert = assert
local ipairs = ipairs
local pcall = pcall
local modf = math.modf
local fmod = math.fmod
local Talented = Talented

local stop = 'Z'
local talented_map = "012345abcdefABCDEFmnopqrMNOPQRtuvwxy"
local classmap = { 'DRUID','HUNTER','MAGE','PALADIN','PRIEST','ROGUE','SHAMAN','WARLOCK','WARRIOR' }

function Talented:StringToTemplate(code, template, nmap)
	nmap = nmap or talented_map
	if code:len() <= 0 then return end
	
	local index = modf((nmap:find(code:sub(1, 1), nil, true) - 1) / 3) + 1
	assert(index and index <= #classmap, "Unknown class code")
	
--[[
	if not class then
		_, class = UnitClass("player")
	end
	assert(classmap[index] == class, "Invalid class")
]]
	local class = classmap[index]
	
	template = template or {}

	template.class = class
	
	local talents = self:GetTalentInfo(class)
	
	assert(talents)
		
	template[1] = template[1] or {}
		
	for i = 2, code:len() do
		local char = code:sub(i, i)
		if char == stop then
			local tab = #template
			local t = template[tab]
			if #t >= #talents[tab].talents then
				t = {}
				template[#template + 1] = t
			end
			t = {}
			template[#template + 1] = t
		else
			index = nmap:find(char, nil, true) - 1
			if not index then return end
			local b = fmod(index, 6)
			local a = (index - b) / 6
			
			local tab = #template
			local t = template[tab]
			if #t >= #talents[tab].talents then
				t = {}
				template[#template + 1] = t
			end
			t[#t + 1] = a
			
			tab = #template
			t = template[tab]
			if #t < #talents[tab].talents then
				t[#t + 1] = b
			else
				assert(b == 0)
			end
		end
	end

	assert(#template <= #talents, "Too many branches")
	do
		for tab, tree in ipairs(talents) do
			local t = template[tab] or {}
			template[tab] = t
			for index in ipairs(tree.talents) do
				t[index] = t[index] or 0
			end
		end
	end

	return  template, class
end

local function rtrim(s, c)
	local l = #s
	while l >= 1 and s:sub(l, l) == c do
		l = l - 1
	end
	return s:sub(1, l)
end

function Talented:TemplateToString(template, nmap)
	nmap = nmap or talented_map
	
	local class = template.class
	
	local code, ccode = ""
	do
		for index, c in ipairs(classmap) do
			if c == class then
				local i = (index - 1) * 3 + 1
				ccode = nmap:sub(i, i)
				break
			end
		end
	end
	assert(ccode, "invalid class")
	local s = nmap:sub(1, 1)
	local info = self:GetTalentInfo(class)
	assert(info)
	for tab, talents in ipairs(info) do
		local tmpl = template[tab]
		for index = 1, #tmpl, 2 do
			local v = tmpl[index] * 6 + (index < #tmpl and tmpl[index + 1] or 0) + 1
			local c = nmap:sub(v, v)
			assert(c)
			code = code .. c
		end
		local ncode = rtrim(code, s)
		if ncode ~= code then
			code = ncode..stop
		end
	end
	return ccode..rtrim(code, stop)
end

function Talented:PackTemplate(template)
	if not template or template == self.current or template.code then return end
	local res, value = pcall(self.TemplateToString, self, template)
	if res then
		template.code = value
		for tab in ipairs(template) do
			template[tab] = nil
		end
	end
end

function Talented:UnpackTemplate(template)
	if template == self.current or not template.code then return end
	local res, value = pcall(self.StringToTemplate, self, template.code, template)
	if res then
		template.code = nil
	end
end

function Talented:CopyPackedTemplate(src, dst)
	local packed = src.code
	if packed then self:UnpackTemplate(src) end
	dst.class = src.class
	for tab, talents in ipairs(src) do
		local d = dst[tab]
		if not d then
			d = {}
			dst[tab] = d
		end
		for index, value in ipairs(talents) do
			d[index] = value
		end
	end
	if packed then self:PackTemplate(src) end
end
