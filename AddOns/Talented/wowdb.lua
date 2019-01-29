local Talented = Talented
local ipairs = ipairs

local idFromClass = {
	WARRIOR = 1,
	PALADIN = 2,
	HUNTER = 3,
	ROGUE = 4,
	PRIEST = 5,
	SHAMAN = 7,
	MAGE = 8,
	WARLOCK = 9,
	DRUID = 11,
}

local classFromId = {}
for k, v in pairs(idFromClass) do classFromId[v] = k end

--[[
	wowdb sorts the talents in a very weird way.
	(looks like the spell id of the first rank of each talent is used.)
	This makes their encoding very difficult to use, and require the following table
	to be defined.
]]
local classTalentMap = {
	WARRIOR = {
		{ 15, 9, 1, 14, 4, 3, 6, 17, 2, 12, 7, 13, 16, 20, 10, 8, 5, 23, 18, 11, 21, 22, 19 },
		{ 8, 11, 16, 2, 1, 4, 6, 3, 13, 5, 12, 7, 18, 15, 10, 14, 9, 19, 17, 20, 21 },
		{ 3, 5, 2, 1, 12, 9, 7, 10, 8, 19, 15, 13, 11, 14, 6, 17, 4, 21, 18, 16, 20, 22 },
	},
	PALADIN = {
		{ 3, 12, 6, 7, 5, 10, 2, 1, 9, 4, 17, 15, 13, 8, 11, 14, 18, 16, 19, 20 },
		{ 2, 1, 5, 8, 4, 15, 17, 19, 14, 6, 7, 11, 12, 9, 3, 10, 13, 16, 20, 21, 22, 18 },
		{ 1, 16, 5, 2, 14, 13, 7, 19, 4, 11, 8, 3, 10, 6, 9, 12, 15, 20, 21, 17, 18, 22 },
	},
	HUNTER = {
		{ 1, 4, 7, 18, 13, 12, 2, 10, 14, 8, 11, 9, 16, 5, 3, 6, 15, 17, 20, 19, 21 },
		{ 1, 4, 3, 2, 7, 6, 9, 10, 13, 11, 12, 17, 15, 14, 16, 19, 20, 5, 8, 18 },
		{ 18, 2, 5, 7, 8, 10, 13, 12, 6, 16, 15, 11, 20, 4, 9, 1, 17, 14, 19, 22, 23, 3, 21 },
	},
	ROGUE = {
		{ 11, 9, 3, 2, 4, 5, 1, 6, 8, 13, 7, 16, 18, 10, 14, 17, 20, 19, 21, 12, 15 },
		{ 6, 11, 16, 13, 3, 5, 2, 1, 7, 21, 10, 12, 14, 15, 8, 19, 9, 18, 20, 17, 24, 23, 22, 4 },
		{ 1, 5, 6, 9, 2, 10, 4, 8, 14, 13, 7, 19, 15, 11, 3, 12, 17, 21, 18, 16, 22, 20 },
	},
	PRIEST = {
		{ 19, 11, 1, 6, 5, 2, 4, 10, 9, 8, 12, 14, 3, 13, 17, 7, 15, 21, 20, 22, 18, 16 },
		{ 3, 14, 8, 11, 16, 2, 10, 4, 1, 12, 6, 5, 13, 9, 7, 18, 19, 20, 15, 17, 21 },
		{ 11, 17, 5, 2, 1, 7, 3, 4, 13, 8, 18, 12, 6, 9, 10, 14, 15, 19, 20, 21, 16 },
	},
	SHAMAN = {
		{ 8, 2, 1, 5, 13, 9, 17, 6, 7, 16, 3, 4, 12, 10, 11, 14, 18, 19, 15, 20 },
		{ 9, 10, 5, 6, 3, 7, 2, 4, 1, 11, 13, 8, 19, 16, 14, 12, 20, 18, 15, 17, 21 },
		{ 8, 6, 1, 7, 10, 4, 3, 16, 13, 15, 2, 11, 5, 9, 12, 14, 18, 19, 20, 17 },
	},
	MAGE = {
		{ 6, 2, 15, 1, 4, 3, 8, 7, 9, 14, 20, 11, 10, 17, 5, 12, 13, 18, 16, 22, 19, 23, 21 },
		{ 9, 11, 1, 10, 5, 8, 2, 4, 7, 15, 14, 3, 17, 19, 6, 12, 13, 16, 20, 18, 21, 22 },
		{ 2, 5, 8, 6, 10, 16, 7, 13, 18, 12, 9, 1, 19, 15, 4, 11, 3, 14, 17, 20, 21, 22 },
	},
	WARLOCK = {
		{ 8, 2, 11, 6, 1, 3, 5, 18, 14, 16, 9, 15, 4, 10, 7, 20, 19, 17, 21, 13, 12 },
		{ 1, 2, 3, 4, 5, 8, 11, 9, 6, 7, 17, 12, 15, 20, 14, 19, 13, 22, 21, 10, 18, 16 },
		{ 2, 3, 1, 13, 8, 10, 11, 16, 14, 18, 7, 4, 5, 6, 12, 21, 20, 9, 19, 15, 17 },
	},
	DRUID = {
		{ 2, 1, 6, 9, 7, 14, 11, 4, 8, 13, 15, 10, 18, 3, 12, 16, 17, 19, 20, 21, 5 },
		{ 2, 1, 5, 4, 8, 3, 11, 9, 10, 7, 12, 15, 18, 13, 14, 6, 17, 20, 16, 21, 19 },
		{ 1, 2, 4, 3, 15, 8, 12, 5, 6, 11, 7, 10, 13, 9, 19, 17, 14, 18, 20, 16 },
	},
}

local diffStringMap = {
	[0] = "e",
	[1] = "d",
	[2] = "c",
	[3] = "b",
	[4] = "a",
	e = 0,
	d = 1,
	c = 2,
	b = 3,
	a = 4,
}

function Talented:ExportWowdbTemplate(template)
	local class = template.class
	local talents = self:GetTalentInfo(class)
	if not talents then return end
	local tmap = classTalentMap[class]

	local result = "http://www.wowdb.com/talent.aspx?id="..idFromClass[class].."#"
	local lchar, nchar, clen = "", nil, 0
	
	for tab, tree in ipairs(talents) do
		for _, id in ipairs(tmap[tab]) do
			local value = template[tab][id]
			local max = tree.talents[id].info.ranks
			local diff = max - value
			if diff == max then
				nchar = "f"
			else
				nchar = diffStringMap[diff]
			end
			if nchar == lchar then
				clen = clen + 1
			else
				if clen > 1 then
					result = result..lchar..clen
				else
					result = result..lchar
				end
				clen = 1
				lchar = nchar
			end
		end
	end
	if clen > 1 then
		result = result..lchar..clen
	else
		result = result..lchar
	end
	return result
end

function Talented:ImportWowdbTemplate(s, dst)
	local id, code = s:match("/talent%.aspx%?id=(%d+)#(.*)")
	if not id then
		return
	end
	local class = classFromId[tonumber(id)]
	dst.class = class
	local talents = self:GetTalentInfo(class)
	if not talents then return end
	local tmap = classTalentMap[class]
	local tab, index = 1, 1
	for char, count in code:gmatch("([a-f])([0-9]*)") do
		count = tonumber(count) or 1
		for _ = 1, count do
			local t = dst[tab]
			if not t then
				t = {}
				dst[tab] = t
			end
			local tindex = tmap[tab][index]
			local ranks = talents[tab].talents[tindex].info.ranks
			local result
			if char == "f" then
				result = 0
			else
				result = ranks - diffStringMap[char]
			end
			t[tindex] = result
			index = index + 1
			if index > #tmap[tab] then
				tab = tab + 1
				index = 1
			end
		end
	end
	return dst
end
