----------------------------------------

----------------------------------------

Outfitter.cStatDistribution =
{
	DRUID =
	{
		Agility = {Armor = {Coeff = 2}, Dodge = {Coeff = 1 / 14.7}, Attack = {Coeff = 1}, MeleeCrit = {Coeff = 1 / 25}, TotalStats = {Coeff = 1}},
		Stamina = {Health = {Coeff = 10}, TotalStats = {Coeff = 1}},
		Intellect = {Mana = {Coeff = 15}, SpellCrit = {Coeff = 1 / 80}, TotalStats = {Coeff = 1}},
		Spirit = {ManaRegen = {Coeff = 0.2 * 2.5}, TotalStats = {Coeff = 1}}, -- * 2.5 to convert from ticks to per-five-seconds
		Strength = {BlockAmount = {Coeff = 1 / 22}, Attack = {Coeff = 2}, TotalStats = {Coeff = 1}},
		Defense = {Dodge = {Coeff = 0.05}, Parry = {Coeff = 0.05}, Block = {Coeff = 0.05}},
	},
	
	HUNTER =
	{
		Agility = {Armor = {Coeff = 2}, Dodge = {Coeff = 1 / 25}, RangedAttack = {Coeff = 1}, Attack = {Coeff = 1}, MeleeCrit = {Coeff = 1 / 40}, TotalStats = {Coeff = 1}},
		Stamina = {Health = {Coeff = 10}, TotalStats = {Coeff = 1}},
		Intellect = {Mana = {Coeff = 15}, TotalStats = {Coeff = 1}},
		Spirit = {ManaRegen = {Coeff = 0.2 * 2.5}, TotalStats = {Coeff = 1}}, -- * 2.5 to convert from ticks to per-five-seconds
		Strength = {BlockAmount = {Coeff = 1 / 22}, Attack = {Coeff = 1}, TotalStats = {Coeff = 1}},
		Defense = {Dodge = {Coeff = 0.05}, Parry = {Coeff = 0.05}, Block = {Coeff = 0.05}},
	},
	
	MAGE =
	{
		Agility = {Armor = {Coeff = 2}, Dodge = {Coeff = 1 / 25}, MeleeCrit = {Coeff = 1 / 25}, TotalStats = {Coeff = 0}},
		Stamina = {Health = {Coeff = 10}, TotalStats = {Coeff = 1}},
		Intellect = {Mana = {Coeff = 15}, SpellCrit = {Coeff = 1.0 / 80}, TotalStats = {Coeff = 1}},
		Spirit = {ManaRegen = {Coeff = 0.25 * 2.5}, TotalStats = {Coeff = 1}}, -- * 2.5 to convert from ticks to per-five-seconds
		Strength = {BlockAmount = {Coeff = 1 / 22}, TotalStats = {Coeff = 0}},
		Defense = {Dodge = {Coeff = 0.05}, Parry = {Coeff = 0.05}, Block = {Coeff = 0.05}},
	},
	
	PALADIN =
	{
		Agility = {Armor = {Coeff = 2}, Dodge = {Coeff = 1 / 25}, MeleeCrit = {Coeff = 1 / 25}, TotalStats = {Coeff = 1}},
		Stamina = {Health = {Coeff = 10}, TotalStats = {Coeff = 1}},
		Intellect = {Mana = {Coeff = 15}, SpellCrit = {Coeff = 1.0 / 80.05}, TotalStats = {Coeff = 1}},
		Spirit = {ManaRegen = {Coeff = 0.2 * 2.5}, TotalStats = {Coeff = 1}}, -- * 2.5 to convert from ticks to per-five-seconds
		Strength = {BlockAmount = {Coeff = 1 / 22}, Attack = {Coeff = 2}, TotalStats = {Coeff = 1}},
		Defense = {Dodge = {Coeff = 0.05}, Parry = {Coeff = 0.05}, Block = {Coeff = 0.05}},
	},
	
	PRIEST =
	{
		Agility = {Armor = {Coeff = 2}, Dodge = {Coeff = 1 / 25}, MeleeCrit = {Coeff = 1 / 25}, TotalStats = {Coeff = 0}},
		Stamina = {Health = {Coeff = 10}, TotalStats = {Coeff = 1}},
		Intellect = {Mana = {Coeff = 15}, SpellCrit = {Coeff = 1.0 / 80}, TotalStats = {Coeff = 1}},
		Spirit = {ManaRegen = {Coeff = 0.25 * 2.5}, TotalStats = {Coeff = 1}}, -- * 2.5 to convert from ticks to per-five-seconds
		Strength = {BlockAmount = {Coeff = 1 / 22}, TotalStats = {Coeff = 0}},
		Defense = {Dodge = {Coeff = 0.05}, Parry = {Coeff = 0.05}, Block = {Coeff = 0.05}},
	},
	
	ROGUE =
	{
		Agility = {Armor = {Coeff = 2}, Dodge = {Coeff = 1 / 20}, Attack = {Coeff = 1}, RangedAttack = {Coeff = 2}, MeleeCrit = {Coeff = 1 / 40}, TotalStats = {Coeff = 1}},
		Stamina = {Health = {Coeff = 10}, TotalStats = {Coeff = 1}},
		Intellect = {Mana = {Coeff = 15}, TotalStats = {Coeff = 0}},
		Spirit = {ManaRegen = {Coeff = 0.25 * 2.5}, TotalStats = {Coeff = 0}}, -- * 2.5 to convert from ticks to per-five-seconds
		Strength = {BlockAmount = {Coeff = 1 / 22}, Attack = {Coeff = 1}, TotalStats = {Coeff = 1}},
		Defense = {Dodge = {Coeff = 0.05}, Parry = {Coeff = 0.05}, Block = {Coeff = 0.05}},
	},
	
	SHAMAN =
	{
		Agility = {Armor = {Coeff = 2}, Dodge = {Coeff = 1 / 25}, MeleeCrit = {Coeff = 1 / 25}, TotalStats = {Coeff = 1}},
		Stamina = {Health = {Coeff = 10}, TotalStats = {Coeff = 1}},
		Intellect = {Mana = {Coeff = 15}, SpellCrit = {Coeff = 1.0 / 80}, TotalStats = {Coeff = 1}},
		Spirit = {ManaRegen = {Coeff = 0.2 * 2.5}, TotalStats = {Coeff = 1}}, -- * 2.5 to convert from ticks to per-five-seconds
		Strength = {BlockAmount = {Coeff = 1 / 22}, Attack = {Coeff = 2}, TotalStats = {Coeff = 1}},
		Defense = {Dodge = {Coeff = 0.05}, Parry = {Coeff = 0.05}, Block = {Coeff = 0.05}},
	},
	
	WARLOCK =
	{
		Agility = {Armor = {Coeff = 2}, Dodge = {Coeff = 1 / 25}, MeleeCrit = {Coeff = 1 / 33}, TotalStats = {Coeff = 0}},
		Stamina = {Health = {Coeff = 10}, TotalStats = {Coeff = 1}},
		Intellect = {Mana = {Coeff = 15}, SpellCrit = {Coeff = 1.0 / 81.92}, TotalStats = {Coeff = 1}},
		Spirit = {ManaRegen = {Coeff = 0.2 * 2.5}, TotalStats = {Coeff = 1}}, -- * 2.5 to convert from ticks to per-five-seconds
		Strength = {BlockAmount = {Coeff = 1 / 22}, TotalStats = {Coeff = 0}},
		Defense = {Dodge = {Coeff = 0.05}, Parry = {Coeff = 0.05}, Block = {Coeff = 0.05}},
	},
	
	WARRIOR =
	{
		Agility = {Armor = {Coeff = 2}, Dodge = {Coeff = 1 / 30}, MeleeCrit = {Coeff = 1 / 20}, TotalStats = {Coeff = 1}},
		Stamina = {Health = {Coeff = 10}, TotalStats = {Coeff = 1}},
		Intellect = {Mana = {Coeff = 15}, TotalStats = {Coeff = 0}},
		Spirit = {ManaRegen = {Coeff = 0.25 * 2.5}, TotalStats = {Coeff = 0}}, -- * 2.5 to convert from ticks to per-five-seconds
		Strength = {BlockAmount = {Coeff = 1 / 22}, Attack = {Coeff = 2}, TotalStats = {Coeff = 1}},
		Defense = {Dodge = {Coeff = 0.05}, Parry = {Coeff = 0.05}, Block = {Coeff = 0.05}},
	},
}

----------------------------------------
Outfitter._OutfitIterator = {}
----------------------------------------

function Outfitter._OutfitIterator:Construct(pItems)
	self.Items = pItems
	self.SlotIterators = {}
	self.CombinationIndex = 1
	self.NumCombinations = 1
	
	for vInventorySlot, vItems in pairs(self.Items) do
		local vSlotInfo =
		{
			SlotName = vInventorySlot,
			Items = vItems,
			Index = 1,
		}
		
		table.insert(self.SlotIterators, vSlotInfo)
		
		self.NumCombinations = self.NumCombinations * #vItems
	end
	
	vSlotIterators.NumCombinations = vNumCombinations
end

function Outfitter._OutfitIterator:Next()
	for vSlotIndex, vSlotIterator in ipairs(self.SlotIterators) do
		vSlotIterator.Index = vSlotIterator.Index + 1
		
		if vSlotIterator.Index <= #vSlotIterator.Items then
			self.CombinationIndex = self.CombinationIndex + 1
			return true
		end
		
		vSlotIterator.Index = 1
	end
	
	self.CombinationIndex = 1
	
	return false -- Couldn't increment
end

function Outfitter._OutfitIterator:GetOutfit()
	local vOutfit = Outfitter:NewEmptyOutfit()

	for _, vSlotIterator in ipairs(self.SlotIterators) do
		Outfitter:AddOutfitItem(vOutfit, vSlotIterator.SlotName, vSlotIterator.Items[vSlotIterator.Index])
	end
	
	return vOutfit
end

----------------------------------------
----------------------------------------

function Outfitter:GetItemsWithStats(pEquippableItems, pDesiredStats)
	local vItems = {}
	
	for vInventorySlot, vItems in pairs(pEquippableItems.ItemsBySlot) do
		local vFoundItemInSlot
		
		for vIndex, vItem in ipairs(vItems) do
			-- If the item has any of the desired stats then add it to the list
			
			for vStatID, _ in pairs(pDesiredStats) do
				if vItem[vStatID] and vItem[vStatID] > 0 then
					if not vFoundItemInSlot then
						vItems[vInventorySlot] = {}
						vFoundItemInSlot = true
					end
					
					table.insert(vItems[vInventorySlot], vItem)
					break
				end
			end
		end
	end
	
	return vItems
end

----------------------------------------
----------------------------------------

function Outfitter:AddItemsWithStatToOutfit(pOutfit, pStatID, pEquippableItems)
	local vItemStats
	
	if not pEquippableItems then
		return
	end
	
	for vInventorySlot, vItems in pairs(pEquippableItems.ItemsBySlot) do
		for vIndex, vItem in ipairs(vItems) do
			local vStatValue = vItem.Stats[pStatID]
			
			if vStatValue then
				local vSlotName = vItem.MetaSlotName
				
				if not vSlotName then
					vSlotName = vItem.ItemSlotName
				end
				
				Outfitter:AddOutfitStatItemIfBetter(pOutfit, vSlotName, vItem, pStatID, vStatValue)
			end
		end
	end
	
	-- Collapse the meta slots (currently just 2H vs. 1H/OH)
	
	Outfitter:CollapseMetaSlotsIfBetter(pOutfit, pStatID)
end

function Outfitter:AddOutfitStatItemIfBetter(pOutfit, pSlotName, pItemInfo, pStatID, pStatValue)
	local vCurrentItem = pOutfit.Items[pSlotName]
	local vAlternateSlotName = Outfitter.cHalfAlternateStatSlot[pSlotName]
	
	if not vCurrentItem
	or not vCurrentItem[pStatID]
	or vCurrentItem[pStatID] < pStatValue then
		-- If we're bumping the current item, see if it should be moved to the alternate slot
		
		if vCurrentItem
		and vCurrentItem[pStatID]
		and vAlternateSlotName then
			Outfitter:AddOutfitStatItemIfBetter(pOutfit, vAlternateSlotName, vCurrentItem, pStatID, vCurrentItem[pStatID])
		end
		
		Outfitter:AddOutfitStatItem(pOutfit, pSlotName, pItemInfo, pStatID, pStatValue)
	else
		if not vAlternateSlotName then
			return
		end
		
		return Outfitter:AddOutfitStatItemIfBetter(pOutfit, vAlternateSlotName, pItemInfo, pStatID, pStatValue)
	end
end

function Outfitter:AddOutfitStatItem(pOutfit, pSlotName, pItemInfo, pStatID, pStatValue)
	if not pSlotName then
		Outfitter:ErrorMessage("AddOutfitStatItem: SlotName is nil for "..pItemName)
		return
	end
	
	if not pStatID then
		Outfitter:ErrorMessage("AddOutfitStatItem: StatID is nil for "..pItemName)
		return
	end
	
	Outfitter:AddOutfitItem(pOutfit, pSlotName, pItemInfo)
	
	pOutfit.Items[pSlotName][pStatID] = pStatValue
end

function Outfitter:TestOutfitCombinations()
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems(true)
	local vFilterStats = {FireResist = true}
	local vOutfit = Outfitter:FindOutfitCombination(vEquippableItems, vFilterStats, Outfitter.OutfitTestEval, {})
end

function Outfitter.OutfitTestEval(pOpcode, pParams, pOutfit1, pOutfit2)
	if pOpcode == "INIT" then
		Outfitter:TestMessage("Outfitter:OutfitTestEval: INIT")
	elseif pOpcode == "COMPARE" then
		Outfitter:TestMessage("Outfitter:OutfitTestEval: COMPARE")
	end
end

function Outfitter:FindOutfitCombination(pEquippableItems, pFilterStats, pOutfitEvalFunc, pOutfitEvalParams)
	local vSlotIterators = Outfitter.SlotIterators_New(pEquippableItems, pFilterStats)
	
	Outfitter:DebugTable("vSlotIterators", vSlotIterators)
	
	local vBestOutfit = nil
	local vNumIterations = 0
	
	pOutfitEvalFunc("INIT", pOutfitEvalParams)
	
	while vSlotIterators:Increment() do
		local vOutfit = vSlotIterators:GetOutfit()
		
		if pOutfitEvalFunc("COMPARE", pOutfitEvalParams, vBestOutfit, vOutfit) then
			vBestOutfit = vOutfit
		end
		
		vNumIterations = vNumIterations + 1
		
		if vNumIterations > 20 then
			return vBestOutfit
		end
	end
	
	return vBestOutfit
end

function Outfitter:MultiStatTest()
	local vStat = "Intellect"
	local vMinValue = 100
	local vStat2 = "FireResist"
	local vEquippableItems = Outfitter.ItemList_GetEquippableItems(true)
	
	local vIterator = Outfitter.SlotIterators_New(vEquippableItems, {[vStat] = true})
	
	vIterator:SortItemsByStat(vStat)
	
	local vMinNumSlots = vIterator:CalcMinNumSlotsByStat(vStat, vMinValue)
	
	Outfitter:DebugTable("Iterator", vIterator)
	Outfitter:DebugMessage(vMinNumSlots.." needed for "..vMinValue.." "..vStat)
end

function Outfitter:ItemContainsStats(pItem, pFilterStats)
	for vStatID, _ in pairs(pFilterStats) do
		if pItem.Stats[vStatID] then
			return true
		end
	end
	
	return false
end

function Outfitter.SlotIterators_New(pEquippableItems, pFilterStats)
	local vSlotIterators = {Slots = {}}
	local vNumCombinations = 1
	
	for vInventorySlot, vItems in pairs(pEquippableItems.ItemsBySlot) do
		local vNumItems = #vItems
		
		if vInventorySlot ~= "AmmoSlot"
		and vNumItems > 0 then
			-- Filter the items by stat
			
			local vFilteredItems = nil
			
			if pFilterStats then
				vNumItems = 0
				
				for vItemIndex, vItem in ipairs(vItems) do
					if Outfitter:ItemContainsStats(vItem, pFilterStats) then
						if not vFilteredItems then
							vFilteredItems = {}
						end
						
						table.insert(vFilteredItems, vItem)
						vNumItems = vNumItems + 1
					end
				end
			else
				vFilteredItems = vItems
			end
			
			-- Add the filtered list
			
			if vFilteredItems then
				table.insert(vSlotIterators.Slots, {ItemSlotName = vInventorySlot, Items = vFilteredItems, Index = 0, MaxIndex = vNumItems})
				
				vNumCombinations = vNumCombinations * (vNumItems + 1)
				
				Outfitter:TestMessage("Outfitter.SlotIterators_New: "..vInventorySlot.." has "..vNumItems.." items. Combinations "..vNumCombinations)
			end
		end
	end
	
	vSlotIterators.Increment = Outfitter.SlotIterators_Increment
	vSlotIterators.GetOutfit = Outfitter.SlotIterators_GetOutfit
	vSlotIterators.SortItemsByStat = Outfitter.SlotIterators_SortItemsByStat
	vSlotIterators.CalcMinNumSlotsByStat = Outfitter.SlotIterators_CalcMinNumSlotsByStat
	
	vSlotIterators.NumCombinations = vNumCombinations
	
	Outfitter:TestMessage("Outfitter.SlotIterators_New: Total combinations "..vNumCombinations)
	
	return vSlotIterators
end

function Outfitter.SlotIterators_Increment(pSlotIterators)
	for vSlotIndex, vSlotIterator in ipairs(pSlotIterators.Slots) do
		vSlotIterator.Index = vSlotIterator.Index + 1
		
		if vSlotIterator.Index <= vSlotIterator.MaxIndex then
			return true
		end
		
		vSlotIterator.Index = 0
	end
	
	return false -- Couldn't increment
end

function Outfitter.SlotIterators_GetOutfit(pSlotIterators)
	local vOutfit = Outfitter:NewEmptyOutfit()

	for _, vItems in ipairs(pSlotIterators.Slots) do
		-- if vItems.Index > 0 then
		-- 	local vItem = vItems.Items[vItems.Index]
		-- 	
		-- 	Outfitter:AddOutfitItem(vOutfit, vItems.ItemSlotName, vItem)
		-- end
	end
	
	return vOutfit
end

local gOutfitter_CompareStat

function Outfitter.SlotIterators_SortItemsByStat(pIterator, pStat)
	gOutfitter_CompareStat = pStat
	
	for _, vSlotInfo in ipairs(pIterator.Slots) do
		table.sort(vSlotInfo.Items,
			function (pItem1, pItem2)
				local vStat1, vStat2 = pItem1[gOutfitter_CompareStat], pItem2[gOutfitter_CompareStat]
				
				if vStat1 == nil then
					return vStat2 ~= nil
				elseif not vStat2 then
					return false
				else
					return vStat1 < vStat2
				end
			end
		)
	end
end

function Outfitter.SlotIterators_CalcMinNumSlotsByStat(pIterator, pStat, pMinValue)
	local vStatValues = {}

	for _, vSlotInfo in ipairs(pIterator.Slots) do
		local vNumItems = #vSlotInfo.Items
		
		if vNumItems > 0 then
			local vValue = vSlotInfo.Items[1].Stats[pStat]
			
			if vValue then
				table.insert(vStatValues, vValue)
			end

			if vNumItems > 1
			and (vSlotInfo.ItemSlotName == "Trinket0Slot"
			or vSlotInfo.ItemSlotName == "Finger0Slot"
			or vSlotInfo.ItemSlotName == "WeaponSlot") then
				local vValue = vSlotInfo.Items[2].Stats[pStat]
				
				if vValue then
					table.insert(vStatValues, vValue)
				end
			end
		end
	end
	
	table.sort(vStatValues, function (pValue1, pValue2) return pValue1 > pValue2 end)
	
	local vTotal = 0
	
	for vIndex, vValue in ipairs(vStatValues) do
		vTotal = vTotal + vValue
		
		if vTotal >= pMinValue then
			return vIndex
		end
	end
	
	return #vStatValues
end

----------------------------------------
Outfitter.OutfitBuilder = {}
----------------------------------------

function Outfitter.OutfitBuilder:Start(pEvaluator)
end

function Outfitter.OutfitBuilder:GetCandidateItems()
end

function Outfitter.OutfitBuilder:OutfitIsBetter(pOutfit)
end

----------------------------------------
Outfitter._SingleStatEvaluator = {}
----------------------------------------

function Outfitter._SingleStatEvaluator:Construct(pStatID)
end

function Outfitter._SingleStatEvaluator:GetCandidateItems()
end

function Outfitter._SingleStatEvaluator:GetOutfitScore(pOutfit)
end
