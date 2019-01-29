local gMCEventLib_Version = 8

if not MCEventLib
or (MCEventLib._EventLibVersion and MCEventLib._EventLibVersion < gMCEventLib_Version)
or (MCEventLib.Version and MCEventLib.Version < gMCEventLib_Version) then
	if not MCEventLib then
		local vEventFrame = MCEventLibFrame
		
		if not vEventFrame then
			vEventFrame = CreateFrame("FRAME", "MCEventLibFrame", UIParent)
		end
		
		MCEventLib = {}
	end
	
	-- Deactivate the old library
	
	if (MCEventLib._EventLibVersion and MCEventLib._EventLibVersion < gMCEventLib_Version)
	or (MCEventLib.Version and MCEventLib.Version < gMCEventLib_Version) then
		MCEventLib:UnregisterEvent("MACRO_ACTION_FORBIDDEN", MCEventLib.BlockedActionEvent)
		MCEventLib:UnregisterEvent("ADDON_ACTION_FORBIDDEN", MCEventLib.BlockedActionEvent)
		MCEventLib:UnregisterEvent("MACRO_ACTION_BLOCKED", MCEventLib.BlockedActionEvent)
		MCEventLib:UnregisterEvent("ADDON_ACTION_BLOCKED", MCEventLib.BlockedActionEvent)
	end
	
	-- Upgrade from an older library
	
	if MCEventLib.Iterators then
		MCEventLib.EventIterators = MCEventLib.Iterators
		MCEventLib.Iterators = nil
	end
	
	--
	
	function MCEventLib:DebugPerformance()
		self.PerfMonitor = MCDebugLib:NewPerfMonitor("MCEventLib")
	end
	
	function MCEventLib:InstallEventDispatcher(pObject, pEventFrame)
		-- Leave if it's the same or better
		
		if pObject._EventLibVersion and pObject._EventLibVersion >= gMCEventLib_Version then
			return
		end
		
		-- Install the methods
		
		for vIndex, vValue in pairs(self._EventDispatcher) do
			pObject[vIndex] = vValue
		end
		
		-- Initialize any missing members (may be an upgrade, so gotta check)
		
		if not pObject.EventHandlers then
			pObject.EventHandlers = {}
		end
		
		if not pObject.EventIterators then
			pObject.EventIterators = {}
		end

		if not pObject.EventFrame and pEventFrame then
			pObject.EventFrame = pEventFrame
			pEventFrame.EventDispatcher = pObject
			pEventFrame:SetScript("OnEvent", function (frame, event, ...) frame.EventDispatcher:DispatchEvent(event, ...) end)
		end

		pObject._EventLibVersion = gMCEventLib_Version
	end
	
	MCEventLib._EventDispatcher = {}
	
	function MCEventLib._EventDispatcher:RegisterEvent(pEventID, pFunction, pRefParam, pBlind)
		if not pFunction then
			self:DebugMessage("Attempted to register a nil function pointer for event %s", pEventID or "unknown")
			self:DebugStack()
			return
		end
		
		local vHandlers = self.EventHandlers[pEventID]
		
		if not vHandlers then
			vHandlers = {}
			self.EventHandlers[pEventID] = vHandlers
			
			if self.EventFrame then
				self.EventFrame:RegisterEvent(pEventID)
			end
		end
		
		local vHandler =
		{
			Function = pFunction,
			RefParam = pRefParam,
			Blind = pBlind,
			-- CallStack = MCDebugLib:GetCallStack(),
		}
		
		table.insert(vHandlers, vHandler)
	end
	
	function MCEventLib._EventDispatcher:UnregisterEvent(pEventID, pFunction, pRefParam)
		local vHandlers = self.EventHandlers[pEventID]
		
		if not vHandlers then
			return
		end
		
		for vIndex, vHandler in ipairs(vHandlers) do
			if (not pFunction or vHandler.Function == pFunction)
			and (not pRefParam or vHandler.RefParam == pRefParam) then
				table.remove(vHandlers, vIndex)
				
				if #vHandlers == 0 then
					self.EventHandlers[pEventID] = nil
					
					if self.EventFrame then
						self.EventFrame:UnregisterEvent(pEventID)
					end
				end
				
				local vIterator = self.EventIterators[pEventID]
				
				if vIterator then
					if vIndex <= vIterator.Index then
						vIterator.Index = vIterator.Index -1
					end
					
					vIterator.Count = vIterator.Count - 1
				end
				
				return
			end -- if
		end -- while
	end
	
	function MCEventLib._EventDispatcher:UnregisterAllEvents(pFunction, pRefParam)
		for vEventID, vHandlers in pairs(self.EventHandlers) do
			for vIndex, vHandler in ipairs(vHandlers) do
				if (not pFunction or vHandler.Function == pFunction)
				and (not pRefParam or vHandler.RefParam == pRefParam) then
					table.remove(vHandlers, vIndex)
					
					if #vHandlers == 0 then
						self.EventHandlers[vEventID] = nil
						
						if self.EventFrame then
							self.EventFrame:UnregisterEvent(vEventID)
						end
					end
					
					local vIterator = self.EventIterators[vEventID]
					
					if vIterator then
						if vIndex <= vIterator.Index then
							vIterator.Index = vIterator.Index - 1
						end
						
						vIterator.Count = vIterator.Count - 1
					end
					
					break
				end -- if
			end -- for
		end -- for
	end
	
	function MCEventLib._EventDispatcher:DispatchEvent(pEventID, ...)
		local vHandlers = self.EventHandlers[pEventID]
		
		if not vHandlers then
			return
		end
		
		local vIterator = self.EventIterators[pEventID]
		
		if vIterator then
			return
		end
		
		if self.PerfMonitor then
			self.PerfMonitor:FunctionEnter(GetTime())
		end
		
		-- self:DebugMessage("Dispatching event %s", pEventID)
		
		vIterator = {Index = 1, Count = #vHandlers}
		
		self.EventIterators[pEventID] = vIterator
		
		while vIterator.Index <= vIterator.Count do
			local vHandler = vHandlers[vIterator.Index]
			local vSucceeded, vMessage
			
			if vHandler.Blind then
				if vHandler.RefParam ~= nil then
					vSucceeded, vMessage = pcall(vHandler.Function, vHandler.RefParam, ...)
				else
					vSucceeded, vMessage = pcall(vHandler.Function, ...)
				end
			else
				if vHandler.RefParam ~= nil then
					vSucceeded, vMessage = pcall(vHandler.Function, vHandler.RefParam, pEventID, ...)
				else
					vSucceeded, vMessage = pcall(vHandler.Function, pEventID, ...)
				end
			end
			--[[
			if MCDebugLib.ShowLastEventDebug then
				MCDebugLib.ShowLastEventDebug = nil
				for _, vMessage in ipairs(vHandler.CallStack) do
					self:DebugMessage(vMessage)
				end
			end
			]]--
			if not vSucceeded then
				self:ErrorMessage("Error dispatching event "..pEventID..": "..vMessage)
			end
			
			vIterator.Index = vIterator.Index + 1
		end
		
		self.EventIterators[pEventID] = nil

		if self.PerfMonitor then
			local vEndTime = GetTime()
			
			self.PerfMonitor:FunctionExit(vEndTime)
			
			if not self.LastDumpTime
			or vEndTime - self.LastDumpTime > 2 then
				self.LastDumpTime = vEndTime
				
				self.PerfMonitor:DumpValue()
			end
		end
	end
	
	function MCEventLib.BlockedActionEvent(pEventID, pSource, pAction)
		MCEventLib:DebugMessage(pEventID..": "..pSource.." ("..(pAction or "")..")")
	end
	
	MCDebugLib:InstallDebugger("MCEventLib", MCEventLib, {r=0.25, g=1, b=0.5})
	MCEventLib:InstallEventDispatcher(MCEventLib, MCEventLibFrame)
	
	MCEventLib.Version = MCEventLib._EventLibVersion -- Backward compatibility
	
	MCEventLib:RegisterEvent("MACRO_ACTION_FORBIDDEN", MCEventLib.BlockedActionEvent)
	MCEventLib:RegisterEvent("ADDON_ACTION_FORBIDDEN", MCEventLib.BlockedActionEvent)
	MCEventLib:RegisterEvent("MACRO_ACTION_BLOCKED", MCEventLib.BlockedActionEvent)
	MCEventLib:RegisterEvent("ADDON_ACTION_BLOCKED", MCEventLib.BlockedActionEvent)
end
