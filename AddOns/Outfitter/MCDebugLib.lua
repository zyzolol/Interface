local gMCDebugLib_Version = 14

if tern == nil then tern = function(b, t, f) if b then return t else return f end end end

if not MCDebugLib or MCDebugLib.Version < gMCDebugLib_Version then
	if not MCDebugLib then
		MCDebugLib = {}
	end
	
	if not SLASH_RELOADUI1 then
		SlashCmdList.RELOADUI = ReloadUI
		SLASH_RELOADUI1 = "/reloadui"
	end

	SlashCmdList.DEBUGCLEAR = function () MCDebugLib:ClearDebugLog() end
	SLASH_DEBUGCLEAR1 = "/debugclear"

	SlashCmdList.DEBUGMARK = function () MCDebugLib:DebugMark() end
	SLASH_DEBUGMARK1 = "/debugmark"
	
	function MCDebugLib:InstallDebugger(pAddOnName, pObject, pFontColorRGB)
		pObject._AddOnName = pAddOnName
		
		if pFontColorRGB then
			pObject._DebugColorCode = string.format("|cff%02x%02x%02x", pFontColorRGB.r * 255 + 0.5, pFontColorRGB.g * 255 + 0.5, pFontColorRGB.b * 255 + 0.5)
		else
			pObject._DebugColorCode = GREEN_FONT_COLOR_CODE
		end
		
		pObject.TestMessage = self.TestMessage
		pObject.DebugMessage = self.DebugMessage
		pObject.NoteMessage = self.NoteMessage
		pObject.ErrorMessage = self.ErrorMessage
		pObject.DebugTable = self.DebugTable
		pObject.DebugStack = self.DebugStack
		pObject.ErrorStack = self.ErrorStack
		pObject.DebugMark = self.DebugMark
	end
	
	function MCDebugLib:Initialize()
		if self.Initialized then
			return
		end
		
		self.Initialized = true
		
		hooksecurefunc(
				"ChatFrame_ConfigEventHandler",
				function (event)
					if event == "UPDATE_CHAT_WINDOWS"
					and not MCDebugLib.DebugFrame then
						MCDebugLib:FindDebugFrame()
					end
				end)
		
		self:FindDebugFrame()
	end
	
	function MCDebugLib:FindDebugFrame()
		if self.DebugFrame then
			return
		end
		
		for vChatIndex = 1, NUM_CHAT_WINDOWS do
			local vChatFrame = getglobal("ChatFrame"..vChatIndex)
			
			if vChatFrame
			and (vChatFrame:IsVisible() or vChatFrame.isDocked) then
				local vTab = getglobal("ChatFrame"..vChatIndex.."Tab")
				local vName = vTab:GetText()
				
				if vName == "Debug" then
					self.DebugFrame = vChatFrame
					
					if self.DebugFrame:GetMaxLines() < 1000 then
						self.DebugFrame:SetMaxLines(1000)
					end
					
					self.DebugFrame:SetFading(false)
				end
			end
		end
		
		if self.DebugFrame then
			self:NoteMessage("MCDebugLib: Found debugging chat frame")
		end
	end
	
	function MCDebugLib:ClearDebugLog()
		if not self.Initialized then
			self:Initialize()
		end
		
		if not self.DebugFrame then
			return
		end
		
		self.DebugFrame:Clear()
	end
	
	function MCDebugLib:DebugMark(pPrefix)
		MCDebugLib:DebugMessage((pPrefix or "").."————————————————————————————————————————")
	end
	
	function MCDebugLib.FormatNamed(pFormat, pFields)
		return string.gsub(pFormat, "%$(%w+)", pFields)
	end

	function MCDebugLib:AddDebugMessage(pMessage, ...)
		if not self.Initialized then
			self:Initialize()
		end
		
		if not self.DebugFrame then
			return
		end
		
		if false then -- set to false to diagnose debug message problems
			if select("#", ...) > 0 and type(select(1, ...)) == "table" then
				self.DebugFrame:AddMessage(MCDebugLib.FormatNamed(pMessage, ...))
			else
				self.DebugFrame:AddMessage(string.format(pMessage, ...))
			end
		else
			local vSucceeded, vMessage
			
			if select("#", ...) > 0 and type(select(1, ...)) == "table" then
				vSucceeded, vMessage = pcall(MCDebugLib.FormatNamed, pMessage, ...)
			else
				vSucceeded, vMessage = pcall(string.format, pMessage, ...)
			end
			
			if not vSucceeded then
				vMessage = pMessage
			end
			
			self.DebugFrame:AddMessage(vMessage)
		end
		
		local vTabFlash = getglobal(self.DebugFrame:GetName().."TabFlash")
		
		vTabFlash:Show()
		UIFrameFlash(vTabFlash, 0.25, 0.25, 60, nil, 0.5, 0.5)
	end
	
	function MCDebugLib:DebugMessage(pMessage, ...)
		if self._AddOnName then
			MCDebugLib:DebugMessage(self._DebugColorCode.."["..self._AddOnName.."] "..FONT_COLOR_CODE_CLOSE..pMessage, ...)
		else
			MCDebugLib:AddDebugMessage(NORMAL_FONT_COLOR_CODE.."[DEBUG] "..HIGHLIGHT_FONT_COLOR_CODE..pMessage..FONT_COLOR_CODE_CLOSE, ...)
		end
	end

	function MCDebugLib:TestMessage(pMessage, ...)
		if self._AddOnName then
			MCDebugLib:TestMessage(self._DebugColorCode.."["..self._AddOnName.."] "..FONT_COLOR_CODE_CLOSE..pMessage, ...)
		else
			self:AddDebugMessage(GREEN_FONT_COLOR_CODE.."[   TEST] "..HIGHLIGHT_FONT_COLOR_CODE..pMessage..FONT_COLOR_CODE_CLOSE, ...)
		end
	end
	
	function MCDebugLib:ErrorMessage(pMessage, ...)
		local vErrorMessageFontColorCode = "|cffffeeee"
		
		if self._AddOnName then
			MCDebugLib:ErrorMessage(self._DebugColorCode.."["..self._AddOnName.."] "..vErrorMessageFontColorCode..pMessage..FONT_COLOR_CODE_CLOSE, ...)
		else
			local vFormat = RED_FONT_COLOR_CODE.."[ERROR] "..vErrorMessageFontColorCode..pMessage..FONT_COLOR_CODE_CLOSE
			
			if self.DebugFrame then
				self:AddDebugMessage(vFormat, ...)
			end
			
			if select("#", ...) > 0 and type(select(1, ...)) == "table" then
				DEFAULT_CHAT_FRAME:AddMessage(MCDebugLib.FormatNamed(vFormat, ...))
			else
				DEFAULT_CHAT_FRAME:AddMessage(string.format(vFormat, ...))
			end
		end
	end
	
	function MCDebugLib:NoteMessage(pMessage, ...)
		if self._AddOnName then
			MCDebugLib:NoteMessage(self._DebugColorCode.."["..self._AddOnName.."] "..FONT_COLOR_CODE_CLOSE..pMessage, ...)
		elseif select("#", ...) > 0 and type(select(1, ...)) == "table" then
			DEFAULT_CHAT_FRAME:AddMessage(MCDebugLib.FormatNamed(NORMAL_FONT_COLOR_CODE..pMessage..FONT_COLOR_CODE_CLOSE, ...))
		else
			DEFAULT_CHAT_FRAME:AddMessage(string.format(NORMAL_FONT_COLOR_CODE..pMessage..FONT_COLOR_CODE_CLOSE, ...))
		end
	end
	
	function MCDebugLib:DumpArray(...) self:DebugTable(...) end
	
	function MCDebugLib:DebugTable(pValuePath, pValue, pMaxDepth, pMode)
		if not pValue then
			self:DebugMessage(pValuePath.." = nil")
			return
		end
		
		local vType = type(pValue)
		
		if vType == "number" then
			self:DebugMessage(pValuePath.." = "..pValue)
		elseif vType == "string" then
			self:DebugMessage(pValuePath.." = \""..pValue.."\"")
		elseif vType == "boolean" then
			if pValue then
				self:DebugMessage(pValuePath.." = true")
			else
				self:DebugMessage(pValuePath.." = false")
			end
		elseif vType == "table" then
			local vMaxDepth
			
			if pMaxDepth then
				vMaxDepth = pMaxDepth
			else
				vMaxDepth = 5
			end
			
			if vMaxDepth == 0 then
				self:DebugMessage(pValuePath.." = {...}")
			else
				local vFoundElement = false
				
				for vIndex, vElement in pairs(pValue) do
					local vValuePath 
					
					if not vFoundElement then
						vValuePath = pValuePath
					elseif string.sub(pValuePath, 1, 10) == "|cff888888" then
						vValuePath = string.gsub(pValuePath, "|cffffffff", "")
					else
						vValuePath = "|cff888888"..string.gsub(pValuePath, "|cffffffff", "")
					end
					
					if type(vIndex) == "number" then
						vValuePath = vValuePath.."|cffffffff["..vIndex.."]"
					else
						vValuePath = vValuePath.."|cffffffff."..vIndex
					end
					
					self:DebugTable(vValuePath, vElement, vMaxDepth - 1, pMode)
					
					vFoundElement = true
				end
				
				if not vFoundElement then
					self:DebugMessage(pValuePath.." = {}")
				end
			end
		elseif vType == "function" then
			if pMode ~= "NO_FUNCTIONS" then
				self:DebugMessage(pValuePath.." "..vType)
			end
		else
			self:DebugMessage(pValuePath.." "..vType)
		end
	end
	
	function MCDebugLib:ShowCallStack(...) return MCDebugLib:DebugStack(...) end -- Obsolete
	
	function MCDebugLib:DebugStack(pPrefix, pDepth)
		local vCallStack = MCDebugLib:GetCallStack(pPrefix, pDepth, 1)
		
		for vIndex, vMessage in ipairs(vCallStack) do
			self:DebugMessage(vMessage)
		end
	end
	
	function MCDebugLib:ErrorStack(pPrefix, pDepth)
		local vCallStack = MCDebugLib:GetCallStack(pPrefix, pDepth, 1)
		
		for vIndex, vMessage in ipairs(vCallStack) do
			self:ErrorMessage(vMessage)
		end
	end
	
	function MCDebugLib:ReduceAddonPath(pPath)
		return string.gsub(pPath, "^Interface\\AddOns\\[^\\]*\\", "")
	end
	
	function MCDebugLib:GetCallStack(pPrefix, pDepth, pDepthOffset)
		local vCallStack = {}
		
		if not pPrefix then
			pPrefix = "    "
		end
		
		if not pDepth then
			pDepth = 18
		end
		
		local vStackString = debugstack((pDepthOffset or 0) + 2, pDepth, 0)
		
		for vMessageLine in string.gmatch(vStackString, "(.-)\n") do
			--table.insert(vCallStack, pPrefix.."LINE: "..vMessageLine)
			
			local _, _, vFile, vLine, vFunction = string.find(vMessageLine, "([%w%.]+):(%d+): in function .(.*)'")
			
			if not vFunction then
				_, _, vFunction, vLine, vFile = string.find(vMessageLine, "%[string \"(.*)\"%]:(%d+): in (.*)")
			end
			
			if not vFunction then
				_, _, vFile, vLine, vFunctionFile, vFunctionLine = string.find(vMessageLine, "([^:]+):(%d+): in function <([^:]+):(%d+)>")
				
				if vFunctionLine then
					vFunctionFile = self:ReduceAddonPath(vFunctionFile)
					vFunction = vFunctionFile..", "..vFunctionLine
				end
			end
			
			if not vFunction then
				_, _, vFunction = string.find(vMessageLine, "(tail call.*)")
			end
			
			if not vFunction then
				_, _, _, vFunction = string.find(vMessageLine, "(%[C%]): in function .(.*)'")
				
				if vFunction then
					vFunction = "[C] "..vFunction
					vFile = nil
					vLine = nil
				end
			end
			
			if vFunction then
				if vFile then
					if not vLine then
						vLine = 0
					end
					
					vFile = self:ReduceAddonPath(vFile)
					
					table.insert(vCallStack, pPrefix..vFile..", "..vLine..": "..vFunction)
				else
					table.insert(vCallStack, pPrefix..vFunction)
				end
			else
				table.insert(vCallStack, pPrefix.."Unknown function: "..vMessageLine)
			end
		end
		
		return vCallStack
	end
	
	function MCDebugLib:NewBuckets(pInterval)
		local vBuckets =
		{
			Interval = pInterval,
			BucketStartTime = GetTime(),
			BucketIndex = 1,
			NumBuckets = math.floor(pInterval),
			Buckets = {[1] = {Value = 0, Time = 0}},
			
			AddSample = self.BucketsAddSample,
			GetValue = self.BucketsGetValue,
		}
		
		return vBuckets
	end
	
	function MCDebugLib:BucketsAddSample(pValue, pTime)
		local vBucket = self.Buckets[self.BucketIndex]
		
		vBucket.Value = vBucket.Value + pValue
		
		local vElapsed = pTime - self.BucketStartTime
		
		if vElapsed > 1 then
			vBucket.Time = vElapsed
			
			self.BucketStartTime = pTime
			self.BucketIndex = self.BucketIndex + 1
			
			if self.BucketIndex > self.NumBuckets then
				self.BucketIndex = 1
			end
			
			vBucket = self.Buckets[self.BucketIndex]
			
			if not vBucket then
				vBucket = {}
				self.Buckets[self.BucketIndex] = vBucket
			end
			
			vBucket.Value = 0
			vBucket.Time = 0
		end
	end
	
	function MCDebugLib:BucketsGetValue()
		local vTotalElapsed = 0
		local vTotalValue = 0
		
		for vIndex, vBucket in ipairs(self.Buckets) do
			if vBucket.Time > 0 then
				vTotalElapsed = vTotalElapsed + vBucket.Time
				vTotalValue = vTotalValue + vBucket.Value
			end
		end
		
		if vTotalElapsed == 0 then
			return 0, 0
		end
		
		return vTotalValue / vTotalElapsed, vTotalElapsed
	end
	
	function MCDebugLib:NewPerfMonitor(pLabel)
		local vPerfMonitor =
		{
			Label = pLabel,
			CPUBuckets = self:NewBuckets(10),
			MemBuckets = self:NewBuckets(10),
			
			FunctionEnter = self.PerfMonitorFunctionEnter,
			FunctionExit = self.PerfMonitorFunctionExit,
			DumpValue = self.PerfMonitorDumpValue,
		}
		
		return vPerfMonitor
	end
	
	function MCDebugLib:PerfMonitorFunctionEnter(pTime)
		self.StartTime = pTime
		self.StartMem = gcinfo()
	end
	
	function MCDebugLib:PerfMonitorFunctionExit(pTime)
		local vEndMem = gcinfo()
		
		self.CPUBuckets:AddSample(pTime - self.StartTime, pTime)
		self.MemBuckets:AddSample(vEndMem - self.StartMem, pTime)
	end
	
	function MCDebugLib:PerfMonitorDumpValue()
		local vCPUTime, vTotalTime = self.CPUBuckets:GetValue()
		local vMemRate = self.MemBuckets:GetValue()
		local vCPUPercent
		
		if vTotalTime > 0 then
			vCPUPercent = 100 * vCPUTime / vTotalTime
		else
			vCPUPercent = 0
		end
		
		MCDebugLib:DebugMessage("%s: CPU: %.1f%% Mem: %dKB/sec", self.Label, vCPUPercent, vMemRate)
	end
	
	function MCDebugLib.BoolToString(pValue)
		if pValue then
			return "true"
		else
			return "false"
		end
	end
	
	function MCDebugLib:ShowFrameStatus(pFrame, pPrefix)
		self:DebugMessage("%sVisible: %s Protected: %s Width: %d Height: %d Level: %d", pPrefix or pFrame:GetName(), self.BoolToString(pFrame:IsVisible()), self.BoolToString(pFrame:IsProtected()), pFrame:GetWidth(), pFrame:GetHeight(), pFrame:GetFrameLevel())
	end
	
	function MCDebugLib:ShowParentTree(pFrame, pPrefix)
		if not pPrefix then
			pPrefix = ""
		end
		
		local vParent = pFrame:GetParent()
		
		if vParent then
			self:DebugMessage(pPrefix.."Parent: "..vParent:GetName())
			
			if vParent ~= UIParent then
				self:ShowFrameStatus(vParent, pPrefix.."    ")
				self:ShowParentTree(vParent, pPrefix.."    ")
			end
		end
	end
	
	function MCDebugLib:ShowAnchorTree(pFrame, pPrefix)
		if not pPrefix then
			pPrefix = ""
		end
		
		local vIndex = 1
		local vDidAnchor = {}
		
		local vIndex = 1
		
		while true do
			local vPoint, vRelativeTo, vRelativePoint, vOffsetX, vOffsetY = pFrame:GetPoint(vIndex)
			
			if not vPoint
			or not vRelativeTo then
				break
			end
			
			MCDebugLib:DebugMessage("%sAnchor %d: %s, %s, %s, %d, %d", pPrefix, vIndex, vPoint, vRelativeTo:GetName(), vRelativePoint, vOffsetX, vOffsetY)
			
			if vRelativeTo ~= UIParent
			and not vDidAnchor[vRelativeTo] then
				vDidAnchor[vRelativeTo] = true
				
				self:DebugMessage(pPrefix.."RelativeTo: "..vRelativeTo:GetName())
				self:ShowFrameStatus(vRelativeTo, pPrefix.."    ")
				self:ShowAnchorTree(vRelativeTo, pPrefix.."    ")
			end
			
			vIndex = vIndex + 1
		end
		
		if vIndex == 1 then
			MCDebugLib:DebugMessage(pPrefix.." No Anchors")
		end
	end
	
	function MCDebugLib:ShowFrameTree(pFrame)
		self:DebugMessage("ShowFrameTree: "..pFrame:GetName())
		self:ShowFrameStatus(pFrame, "    ")
		self:ShowParentTree(pFrame, "    ")
		self:ShowAnchorTree(pFrame, "    ")
	end
	
	MCDebugLib.Version = gMCDebugLib_Version
end
