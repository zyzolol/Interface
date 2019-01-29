if not Talented.spelldata then return end

local function handle_ranks(...)
	local result = {}
	for i = 1, select("#", ...) do
		result[i] = tonumber((select(i, ...)))
	end
	return result
end

local function handle_talents(...)
	local result = {}
	for talent = 1, select("#", ...) do
		result[talent] = handle_ranks(strsplit(";", (select(talent, ...))))
	end
	return result
end

local function handle_tabs(...)
	local result = {}
	for tab = 1, select("#", ...) do
		result[tab] = handle_talents(strsplit(",", (select(tab, ...))))
	end
	return result
end

function Talented:UncompressSpellData(class)
	local data = self.spelldata[class]
	if type(data) == "table" then return data end
	data = handle_tabs(strsplit("|", data))
	self.spelldata[class] = data
	return data
end

function Talented:GetTalentLink(template, tab, index, rank)
	local data = self:UncompressSpellData(template.class)
	local rank = rank or (template[tab] and template[tab][index])
	if not rank or rank == 0 then
		rank = 1
	end
	return -- GetSpellLink(data[tab][index][rank]) -- DOES not work for all spells...
		("|cff71d5ff|Hspell:%d|h[%s]|h|r"):format(data[tab][index][rank], self:GetTalentInfo(template.class)[tab].talents[index].info.name)
end
