--[[
	ScrollSheet
	Version: 3.1.2 (<%codename%>)
	Revision: $Id: ScrollSheet.lua 84 2008-04-18 03:18:13Z RockSlice $
	URL: http://auctioneeraddon.com/dl/

	License:
		This library is free software; you can redistribute it and/or
		modify it under the terms of the GNU Lesser General Public
		License as published by the Free Software Foundation; either
		version 2.1 of the License, or (at your option) any later version.

		This library is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
		Lesser General Public License for more details.

		You should have received a copy of the GNU Lesser General Public
		License along with this library; if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor,
		Boston, MA  02110-1301  USA

	Additional:
		Regardless of any other conditions, you may freely use this code
		within the World of Warcraft game client.
--]]

local LIBRARY_VERSION_MAJOR = "ScrollSheet"
local LIBRARY_VERSION_MINOR = 2

--[[-----------------------------------------------------------------

LibStub is a simple versioning stub meant for use in Libraries.
See <http://www.wowwiki.com/LibStub> for more info.
LibStub is hereby placed in the Public Domain.
Credits:
    Kaelten, Cladhaire, ckknight, Mikk, Ammo, Nevcairiel, joshborke

--]]-----------------------------------------------------------------
do
	local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2
	local LibStub = _G[LIBSTUB_MAJOR]

	if not LibStub or LibStub.minor < LIBSTUB_MINOR then
		LibStub = LibStub or {libs = {}, minors = {} }
		_G[LIBSTUB_MAJOR] = LibStub
		LibStub.minor = LIBSTUB_MINOR

		function LibStub:NewLibrary(major, minor)
			assert(type(major) == "string", "Bad argument #2 to `NewLibrary' (string expected)")
			minor = assert(tonumber(strmatch(minor, "%d+")), "Minor version must either be a number or contain a number.")

			local oldminor = self.minors[major]
			if oldminor and oldminor >= minor then return nil end
			self.minors[major], self.libs[major] = minor, self.libs[major] or {}
			return self.libs[major], oldminor
		end

		function LibStub:GetLibrary(major, silent)
			if not self.libs[major] and not silent then
				error(("Cannot find a library instance of %q."):format(tostring(major)), 2)
			end
			return self.libs[major], self.minors[major]
		end

		function LibStub:IterateLibraries() return pairs(self.libs) end
		setmetatable(LibStub, { __call = LibStub.GetLibrary })
	end
end
--[End of LibStub]---------------------------------------------------

local lib = LibStub:NewLibrary(LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR)
if not lib then return end

local GSC_GOLD="ffd100"
local GSC_SILVER="e6e6e6"
local GSC_COPPER="c8602c"

local GSC_3 = "|cff%s%d|cff000000.|cff%s%02d|cff000000.|cff%s%02d|r"
local GSC_2 = "|cff%s%d|cff000000.|cff%s%02d|r"
local GSC_1 = "|cff%s%d|r"

local LibRecycle = LibStub("LibRecycle")
local recycle = LibRecycle.Recycle
local acquire = LibRecycle.Acquire
local clone = LibRecycle.Clone

local function coins(money)
	money = math.floor(tonumber(money) or 0)
	local g = math.floor(money / 10000)
	local s = math.floor(money % 10000 / 100)
	local c = money % 100

	if (g>0) then
		return (GSC_3):format(GSC_GOLD, g, GSC_SILVER, s, GSC_COPPER, c)
	elseif (s>0) then
		return (GSC_2):format(GSC_SILVER, s, GSC_COPPER, c)
	end
	return (GSC_1):format(GSC_COPPER, c)
end

local kit = {}


--[[
	Format: SetData(input, [inputStyle])
	Where:
		input = {
			{ cellValue, cellValue, ..., styleKey=styleData, ... },
			{ cellValue, cellValue, ..., styleKey=styleData, ... },
			...
		}
		inputStyle = {
			{ { styleKey=styleData, ... }, { styleKey=styleData, ... }, ... },
			{ { styleKey=styleData, ... }, { styleKey=styleData, ... }, ... },
			...
		}
		cellValue = value or { value, styleKey=styleData, ... }
		styleKey = (string) The style type that affects the cell in question.
		styleData = (any type) The data that is to be used by the renderer for this cell.

		input and instyle should be cloned, not copied, so they can be recycled by the caller

	Note:
		There are many ways to represent the style for a given cell.
]]

function kit:SetData(input, instyle)
	local sort = self.sort
	local n = #sort
	for i=n, 1, -1 do
		sort[i] = nil
	end

	local nRows = #input
	local nCols = self.hSize

	local data = self.data
	local style = self.style
	local n = #data

	-- Clean up existing data cells
	for i = n, 1, -1 do
		data[i] = nil
		recycle(style, i)
	end

	-- Clone/Copy the data portion of the input table into the data table,
	-- and the style portion into the style table.
	local pos, content
	for i = 1, nRows do
		sort[i] = i -- Initialize sort table to natural order

		if input[i] then
			for k,v in pairs(input[i]) do
				if type(k) == "string" and type(v) == "table" and #v > 0 then
					style[pos][k] = clone(v)
				end
			end
		end
		for j = 1, nCols do
			pos = (i-1)*nCols+j

			if input[i] and input[i][j] then
				content = input[i][j]				-- temporary, no need to clone here
			else
				content = nil
			end
			if type(content) == "table" then
				data[pos] = clone(content[1])		-- just in case, clone it
				for k,v in pairs(content) do
					if type(k) == "string" then
						if not style[pos] then style[pos] = acquire() end
						style[pos][k] = clone(v)
					end
				end
			else
				data[pos] = content or "NIL"		-- non-table, no need to clone
			end

			if instyle and instyle[i] and instyle[i][j] and type(instyle[i][j]) == "table" then
				for k,v in pairs(instyle[i][j]) do
					if not style[pos] then style[pos] = acquire() end
					style[pos][k] = clone(v)
				end
			end
		end
	end
	self.panel.vSize = nRows
	self:PerformSort()
end

--This function only enables the display of the selected row.  The row still gets selected, and kit:GetSelection() will still work
function kit:EnableSelect(enable)
	if enable then
		self.enableselect = true
	else
		self.enableselect = false
	end
end

function kit:GetSelection()
	local selection = {}
	if self.selected then
		for i = 1, self.hSize do
			local pos = i + ((self.selected-1)*self.hSize)
			selection[i] = self.data[pos]
		end
	end
	return selection
end

function kit:RowSelect(row, mouseButton)
	if mouseButton == "RightButton" then
		return
	end
	local selected
	if row then
		selected = row + math.floor(self.panel.vPos)
		if self.selected ~= self.sort[selected] then
			self.selected = self.sort[selected]
		else
			self.selected = nil
		end
	end
	
	for i = 1, #self.rows do
		for j = 1, #self.rows[i] do
			self.rows[i][j]["highlight"]:SetAlpha(0)
		end
	end
	if self.enableselect and self.selected then
		if not row then
			for i = 1, #self.sort do
				if self.sort[i] == self.selected then
					selected = i
				end
			end
			if selected then
				row = selected - math.floor(self.panel.vPos)
			end
		end
		if row and (row > 0) and (row <= #self.rows) then
			for j = 1, #self.rows[row] do
				self.rows[row][j]["highlight"]:SetAlpha(0.2)
			end
		end
	end
end

function kit:ButtonClick(column, mouseButton)
	if mouseButton == "RightButton" then lib.moveColumn(self, column, mouseButton) return end
	
	if (self.curSort == column) then
		self.curDir = self.curDir * -1
	else
		self.curSort = column
		self.curDir = 1
		if self.labels[column]
		and self.labels[column].sort
		and self.labels[column].sort.DESCENDING
		then
			self.curDir = -1
		end
	end
	self:PerformSort()
end

local function sortDataSet(data, sort, width, column, dir)
	assert(column <= width)
	assert(dir == -1 or dir == 1)
	table.sort(sort, function(a,b)
		local aPos = (a-1)*width+column
		local bPos = (b-1)*width+column
		if dir < 0 then
			return (data[aPos] > data[bPos])
		end
		return (data[aPos] < data[bPos])
	end)
end

function kit:PerformSort()
	if not self.curSort then
		for i=1, #self.labels do
			if self.labels[i].sort and self.labels[i].sort.DEFAULT then
				self.curSort = i
				if self.labels[i].sort.DESCENDING then
					self.curDir = -1
				else
					self.curDir = 1
				end
			end
		end
	end
	if not self.curSort then
		self.curSort = 1
		self.curDir = 1
	end
	for i=1, #self.labels do -- Removes the previous Columns arrows before we create the new arrows
		self.labels[i].texture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		self.labels[i].sortTexture:Hide()
	end

	if self.curDir == 1 then
		self.labels[self.curSort].sortTexture:SetTexCoord(0,0.55,0.9,0.2)
		self.labels[self.curSort].sortTexture:SetVertexColor(1,0.2,0)
		self.labels[self.curSort].sortTexture:Show()
	elseif self.curDir == -1 then
		self.labels[self.curSort].sortTexture:SetTexCoord(0,0.55,0.2,0.9)
		self.labels[self.curSort].sortTexture:SetVertexColor(0.2,1,0)
		self.labels[self.curSort].sortTexture:Show()
	end

	sortDataSet(self.data, self.sort, self.hSize, self.curSort, self.curDir)
	
	self.panel:Update()
end

local empty = {}
function kit:Render()
	local vPos = math.floor(self.panel.vPos)
	local vSize = self.panel.vSize
	local hSize = self.hSize

	local rows = self.rows
	local data = self.data
	local sort = self.sort
	local style = self.style

	for i = 1, #rows do
		local rowNum = sort[vPos+i]
		local rowPos = nil
		if rowNum then rowPos = (rowNum-1)*hSize end

		local cells = rows[i]
		for j = 1, hSize do
			local cell = cells[j]
			if rowPos then
				local pos = rowPos + j
				local text = data[pos] or ""
				local settings = style[pos] or empty
				local red,green,blue = 0.8,0.8,0.8

				if cell.layout == "COIN" then
					text = coins(data[pos])
				end

				if settings["textColor"] then
					red, green, blue = unpack(settings['textColor'])
				elseif settings["date"] then
					text = date(settings["date"], text)
				end

				cell:SetTextColor(red,green,blue)
				cell:SetText(text)
				cell:Show()
			else
				cell:Hide()
			end
		end
	end
	self:RowSelect()
end

local PanelScroller = LibStub:GetLibrary("PanelScroller")

function lib:Create(frame, layout, onEnter, onLeave, onClick, onResize, onSelect)
	local sheet
	local name = (frame:GetName() or "").."ScrollSheet"
	
	local id = 1
	while (_G[name..id]) do
		id = id + 1
	end
	name = name..id

	local parentHeight = frame:GetHeight()
	local content = CreateFrame("Frame", name.."Content", frame)
	content:SetHeight(parentHeight - 30)

	local panel = PanelScroller:Create(name.."ScrollPanel", frame)
	panel:SetPoint("TOPLEFT", frame, "TOPLEFT", 5,-5)
	panel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -25,25)
	panel:SetScrollChild(name.."Content")
	panel:SetScrollBarVisible("VERTICAL","FAUX")
	panel.vSize = 0

	local totalWidth = 0;

	local labels = {}
	for i = 1, #layout do
		local button = CreateFrame("Button", nil, content)
		if i == 1 then
			button:SetPoint("TOPLEFT", content, "TOPLEFT", 5,0)
			totalWidth = totalWidth + 5
		else
			button:SetPoint("TOPLEFT", labels[i-1].button, "TOPRIGHT", 3,0)
			totalWidth = totalWidth + 3
		end
		
		local label = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		label:SetText(layout[i][1])

		local colWidth = layout[i][3] or 0
		
		totalWidth = totalWidth + colWidth
		button:SetWidth(colWidth)
		button:SetHeight(16)
		button:SetID(i)
		button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		button:SetScript("OnMouseDown", function(self, ...) sheet:ButtonClick(self:GetID(), ...) end)

		local texture = content:CreateTexture(nil, "ARTWORK")
		texture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		texture:SetTexCoord(0.1, 0.8, 0, 1)
		texture:SetAllPoints(button)
		button.texture = texture

		local sortTexture = content:CreateTexture(nil, "ARTWORK")
		sortTexture:SetTexture("Interface\\Buttons\\UI-SortArrow")
		sortTexture:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0,0)
		sortTexture:SetPoint("BOTTOM", button, "BOTTOM", 0,0)
		sortTexture:SetWidth(12)
		sortTexture:Hide()
		button.sortTexture = sortTexture

		local background = content:CreateTexture(nil, "ARTWORK")
		background:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		background:SetTexCoord(0.2, 0.9, 0, 0.9)
		background:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0,0)
		background:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0,0)
		background:SetPoint("BOTTOM", content, "BOTTOM", 0,0)
		background:SetAlpha(0.2)

		label:SetPoint("TOPLEFT", button, "TOPLEFT", 0,0)
		label:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0,0)
		label:SetJustifyH("CENTER")
		label:SetJustifyV("TOP")
		label:SetTextColor(0.8,0.8,0.8)

		label.button = button
		label.texture = texture
		label.sortTexture = sortTexture
		label.background = background
		label.sort = layout[i][4]
		labels[i] = label
	end
	totalWidth = totalWidth + 5

	local rows = {}
	local rowNum = 1
	local maxHeight = content:GetHeight()
	local totalHeight = 16
	while (totalHeight + 14 < maxHeight) do
		local row = {}
		for i = 1, #layout do
			local cell = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			local button = CreateFrame("Button", nil, content)
			if rowNum == 1 then
				cell:SetPoint("TOPLEFT", labels[i], "BOTTOMLEFT", 0,0)
				cell:SetPoint("TOPRIGHT", labels[i], "BOTTOMRIGHT", 0,0)

				local width = layout[i][3] or 10
				local row, index = rowNum, i

				button:SetHeight(16)
				button:SetWidth(width)
				button:SetPoint("TOPLEFT", labels[i], "BOTTOMLEFT", 0,0)
				button:SetID(rowNum)
				button:SetScript("OnMouseDown", function(self, ...) sheet:RowSelect(self:GetID(), ...) if onSelect then onSelect() end end)
				if (layout[i][2] == "TOOLTIP") then
					button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
					button:SetScript("OnEnter", function() onEnter(button, row, index) end)
					button:SetScript("OnLeave", function() onLeave(button, row, index) end)

					if onClick then button:SetScript("OnClick", function() onClick(button, row, index) end) end
				end
				cell.button = button --store in cell so we can refrence the button
			else
				cell:SetPoint("TOPLEFT", rows[rowNum-1][i], "BOTTOMLEFT", 0,0)
				cell:SetPoint("TOPRIGHT", rows[rowNum-1][i], "BOTTOMRIGHT", 0,0)

				local width = layout[i][3] or 0
				local row, index = rowNum, i

				button:SetHeight(16)
				button:SetWidth(width)
				button:SetPoint("TOPLEFT", rows[rowNum-1][i], "BOTTOMLEFT", 0,0)
				button:SetID(rowNum)
				button:SetScript("OnMouseDown", function(self, ...) sheet:RowSelect(self:GetID(), ...) if onSelect then onSelect() end end)
				if (layout[i][2] == "TOOLTIP") then
					button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
					button:SetScript("OnEnter", function() onEnter(button, row, index) end)
					button:SetScript("OnLeave", function() onLeave(button, row, index) end)

					if onClick then button:SetScript("OnClick", function() onClick(button, row, index) end) end
				end
				cell.button = button
			end
			local highlight = cell.button:CreateTexture(nil, "ARTWORK")
			highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			highlight:SetTexCoord(0.2, 0.9, 0, 0.9)
			highlight:SetPoint("TOPLEFT", cell.button, "TOPLEFT", 0, 0)
			highlight:SetPoint("BOTTOMRIGHT", cell.button, "BOTTOMRIGHT", 0, 0)
			highlight:SetAlpha(0)
			cell.highlight = highlight
			cell:SetHeight(14)
			cell:SetJustifyV("CENTER")
			if (layout[i][2] == "TEXT") then
				cell:SetJustifyH("LEFT")
			elseif (layout[i][2] == "TOOLTIP") then
				cell:SetJustifyH("LEFT")
			elseif (layout[i][2] == "INT") then
				cell:SetJustifyH("RIGHT")
			elseif (layout[i][2] == "COIN") then
				cell:SetJustifyH("RIGHT")
			end
			cell.layout = layout[i][2]
			cell:SetTextColor(0.9, 0.9, 0.9)
			row[i] = cell
		end
		rows[rowNum] = row
		rowNum = rowNum + 1
		totalHeight = totalHeight + 14
	end

	content:SetWidth(totalWidth)
	panel:UpdateScrollChildRect()
	panel:Update()

	sheet = {
		name = name,
		content = content,
		panel = panel,
		labels = labels,
		rows = rows,
		hSize = #labels,
		resize = onResize,
		data = {},
		style = {},
		sort = {},
	}
	for k,v in pairs(kit) do
		sheet[k] = v
	end
	panel.callback = function() sheet:Render() end

	_G[name] = sheet
	return sheet
end

function lib:ReCreate(frame, layout, onEnter, onLeave, onClick, onResize, onSelect)
	local sheet
	local name = frame.sheet.name
	local content = frame.sheet.content
	local panel = frame.sheet.panel
	local totalWidth = 0;

	local labels = {}
	for i = 1, #layout do
		local button = frame.sheet.labels[i].button
		if i == 1 then
			button:SetPoint("TOPLEFT", content, "TOPLEFT", 5,0)
			totalWidth = totalWidth + 5
		else
			button:SetPoint("TOPLEFT", labels[i-1].button, "TOPRIGHT", 3,0)
			totalWidth = totalWidth + 3
		end
		--If the module does not provide a minimum Column width or the Width is too small for text, resize to fit
		local label = frame.sheet.labels[i]
		label:SetText(layout[i][1])

		local colWidth = layout[i][3] or 0
		if label:GetStringWidth() + 20 > colWidth then
			colWidth = floor(label:GetStringWidth() + 20)
		end

		totalWidth = totalWidth + colWidth
		button:SetWidth(colWidth)
		button:SetHeight(16)
		button:SetID(i)

		button:SetScript("OnMouseDown", function(self, ...) sheet:ButtonClick(self:GetID(), ...) end)


		local texture = frame.sheet.labels[i].texture
		--texture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		texture:SetTexCoord(0.1, 0.8, 0, 1)
		texture:SetAllPoints(button)
		button.texture = texture

		local sortTexture = frame.sheet.labels[i].sortTexture
		--sortTexture:SetTexture("Interface\\Buttons\\UI-SortArrow")
		sortTexture:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0,0)
		sortTexture:SetPoint("BOTTOM", button, "BOTTOM", 0,0)
		sortTexture:SetWidth(12)
		sortTexture:Hide()
		button.sortTexture = sortTexture

		local background = frame.sheet.labels[i].background
		--background:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		background:SetTexCoord(0.2, 0.9, 0, 0.9)
		background:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0,0)
		background:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0,0)
		background:SetPoint("BOTTOM", content, "BOTTOM", 0,0)
		background:SetAlpha(0.2)

		label:SetPoint("TOPLEFT", button, "TOPLEFT", 0,0)
		label:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0,0)
		label:SetJustifyH("CENTER")
		label:SetJustifyV("TOP")
		label:SetTextColor(0.8,0.8,0.8)

		label.button = button
		label.texture = texture
		label.sortTexture = sortTexture
		label.background = background
		label.sort = layout[i][4]
		labels[i] = label
	end
	totalWidth = totalWidth + 5

 	local rows = {}
	local rowNum = 1
 	local maxHeight = content:GetHeight()
 	local totalHeight = 16

	--Store all the "buttons" that are currently used on "Tooltip" style frames for reuse
	local buttonTable = {}
	for rowNum, v in pairs (frame.sheet.rows) do
		for column, data in pairs(v) do
			if frame.sheet.rows[rowNum][column].button then
				table.insert(buttonTable, frame.sheet.rows[rowNum][column].button)
			end
		end
	end
	while (totalHeight + 14 < maxHeight) do
		local row = {}

		for i = 1, #layout do

			local cell = frame.sheet.rows[rowNum][i]
			local button = buttonTable[1] --or CreateFrame("Button", nil, content)
			if rowNum == 1 then
				cell:SetPoint("TOPLEFT", labels[i], "BOTTOMLEFT", 0,0)
 				cell:SetPoint("TOPRIGHT", labels[i], "BOTTOMRIGHT", 0,0)

				local width = layout[i][3] or 10
				local row, index = rowNum, i

				button:SetHeight(16)
				button:SetWidth(width)
				button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
				button:SetPoint("TOPLEFT", labels[i], "BOTTOMLEFT", 0,0)
				button:SetID(rowNum)
				button:SetScript("OnMouseDown", function(self, ...) sheet:RowSelect(self:GetID(), ...) if onSelect then onSelect() end end)
 				if (layout[i][2] == "TOOLTIP") then
					button:SetScript("OnEnter", function() onEnter(button, row, index) end)
					button:SetScript("OnLeave", function() onLeave(button, row, index) end)

					if onClick then button:SetScript("OnClick", function() onClick(button, row, index) end) end

				end
				if buttonTable[1] then table.remove(buttonTable, 1) end
			else
				cell:SetPoint("TOPLEFT", rows[rowNum-1][i], "BOTTOMLEFT", 0,0)
				cell:SetPoint("TOPRIGHT", rows[rowNum-1][i], "BOTTOMRIGHT", 0,0)

				local width = layout[i][3] or 0
				local row, index = rowNum, i

				button:SetHeight(16)
				button:SetWidth(width)
				button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
				button:SetPoint("TOPLEFT", rows[rowNum-1][i], "BOTTOMLEFT", 0,0)
				button:SetID(rowNum)
				button:SetScript("OnMouseDown", function(self, ...) sheet:RowSelect(self:GetID(), ...) if onSelect then onSelect() end end)
				if (layout[i][2] == "TOOLTIP") then
					button:SetScript("OnEnter", function() onEnter(button, row, index) end)
					button:SetScript("OnLeave", function() onLeave(button, row, index) end)

					if onClick then button:SetScript("OnClick", function() onClick(button, row, index) end) end

				end
				if buttonTable[1] then table.remove(buttonTable, 1) end
			end
			local highlight = cell.button:CreateTexture(nil, "ARTWORK")
			highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			highlight:SetTexCoord(0.2, 0.9, 0, 0.9)
			highlight:SetPoint("TOPLEFT", cell.button, "TOPLEFT", 0, 0)
			highlight:SetPoint("BOTTOMRIGHT", cell.button, "BOTTOMRIGHT", 0, 0)
			highlight:SetAlpha(0)
			cell.highlight = highlight
			cell:SetHeight(14)
			cell:SetJustifyV("CENTER")
			if (layout[i][2] == "TEXT") then
				cell:SetJustifyH("LEFT")
			elseif (layout[i][2] == "TOOLTIP") then
				cell:SetJustifyH("LEFT")
			elseif (layout[i][2] == "INT") then
				cell:SetJustifyH("RIGHT")
			elseif (layout[i][2] == "COIN") then
				cell:SetJustifyH("RIGHT")
			end
			cell.layout = layout[i][2]
			--cell:SetTextColor(0.9, 0.9, 0.9)
			row[i] = cell
		end
		rows[rowNum] = row
		rowNum = rowNum + 1
		totalHeight = totalHeight + 14
	end

	content:SetWidth(totalWidth)
	panel:UpdateScrollChildRect()
	panel:Update()

	sheet = {
		name = name,
		content = content,
		panel = panel,
		labels = labels,
		rows = rows,
		hSize = #labels,
		resize = onResize,
		data = frame.sheet.data,
		style = frame.sheet.style,
		sort = frame.sheet.sort,
	}
	for k,v in pairs(kit) do
		sheet[k] = v
	end
	panel.callback = function() sheet:Render() end

	_G[name] = sheet
	return sheet
end
function  lib.moveColumn(self, column)
	if self.resize then 
		if IsControlKeyDown() then --reset column to default
			self.resize(self, column, nil) --sends nil as width, this will reset column to defaults
		else
			local originalScript = self.labels[column].button:GetScript("OnMouseDown") --store the original Sort onclick script will reset it when we are done resizing
			
			local point, relativeTo, relativePoint, xOfs, yOfs = self.labels[column].button:GetPoint() --Store the anchor point since its niled when resized
			--limit the size we will allow buttons to get
			local height = self.labels[column].button:GetHeight()
			self.labels[column].button:SetResizable(true)
			self.labels[column].button:SetMaxResize(400, height)
			self.labels[column].button:SetMinResize(13, height) --Makes the nice ... elipsies line up
			--set the resize script	
			self.labels[column].button:SetScript("OnMouseDown", function() self.labels[column].button:StartSizing(self.labels[column].button) end)
			--resets the original onclick as well as setting new anchor points for our buttons
			self.labels[column].button:SetScript("OnMouseUp", function() 
										self.labels[column].button:StopMovingOrSizing() 
										self.labels[column].button:SetScript("OnMouseDown", originalScript) 
										self.labels[column].button:ClearAllPoints()
										self.labels[column].button:SetPoint(point, relativeTo, relativePoint, xOfs,yOfs)
										self.resize(self, column, self.labels[column].button:GetWidth()) --sends new width info to the module
						end)
			--start resizing self			
			self.labels[column].button:StartSizing(self.labels[column].button)
		end
	end
end