--[[
Name: Tourist-2.0
Revision: $Rev: 30153 $
Author(s): ckknight (ckknight@gmail.com)
Website: http://ckknight.wowinterface.com/
Documentation: http://wiki.wowace.com/index.php/Tourist-2.0
SVN: http://svn.wowace.com/root/trunk/TouristLib/Tourist-2.0
Description: A library to provide information about zones and instances.
Dependencies: AceLibrary, Babble-Zone-2.2, AceConsole-2.0 (optional)
License: LGPL v2.1
]]

local MAJOR_VERSION = "Tourist-2.0"
local MINOR_VERSION = "$Revision: 30153 $"

if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end

if not AceLibrary:HasInstance("Babble-Zone-2.2") then error(MAJOR_VERSION .. " requires Babble-Zone-2.2.") end

local Tourist = {}

local Z = AceLibrary("Babble-Zone-2.2")

local playerLevel = 1
local _,race = UnitRace("player")
local isHorde = (race == "Orc" or race == "Troll" or race == "Tauren" or race == "Scourge" or race == "BloodElf")
local isWestern = GetLocale() == "enUS" or GetLocale() == "deDE" or GetLocale() == "frFR" or GetLocale() == "esES"

local Kalimdor, Eastern_Kingdoms, Outland = GetMapContinents()
if not Outland then
	Outland = "Outland"
end
local Azeroth = Z["Azeroth"]

local X_Y_ZEPPELIN = "%s/%s Zeppelin"
local X_Y_BOAT = "%s/%s Boat"
local X_Y_PORTAL = "%s/%s Portal"

local recZones = {}
local recInstances = {}
local lows = setmetatable({}, {__index = function() return 0 end})
local highs = setmetatable({}, getmetatable(lows))
local continents = {}
local instances = {}
local paths = {}
local types = {}
local groupSizes = {}
local factions = {}
local yardWidths = {}
local yardHeights = {}
local yardXOffsets = {}
local yardYOffsets = {}
local fishing = {}
local cost = {}
local textures = {}
local textures_rev = {}
local complexes = {}

local function PLAYER_LEVEL_UP(self)
	playerLevel = UnitLevel("player")
	for k in pairs(recZones) do
		recZones[k] = nil
	end
	for k in pairs(recInstances) do
		recInstances[k] = nil
	end
	for k in pairs(cost) do
		cost[k] = nil
	end
	for zone in pairs(lows) do
		if not self:IsHostile(zone) then
			local low, high = self:GetLevel(zone)
			if types[zone] == "Zone" or types[zone] == "PvP Zone" and low and high then
				if low <= playerLevel and playerLevel <= high then
					recZones[zone] = true
				end
			elseif types[zone] == "Battleground" and low and high then
				local playerLevel = playerLevel
				if zone == Z["Alterac Valley"] then
					playerLevel = playerLevel - 1
				end
				if playerLevel >= low and (playerLevel == MAX_PLAYER_LEVEL or math.fmod(playerLevel, 10) >= 6) then
					recInstances[zone] = true
				end
			elseif types[zone] == "Instance" and low and high then
				if low <= playerLevel and playerLevel <= high then
					recInstances[zone] = true
				end
			end
		end
	end
end

-- minimum fishing skill to fish these zones
function Tourist:GetFishingLevel(zone)
	self:argCheck(zone,2,"string")
	return fishing[zone]
end

function Tourist:GetLevel(zone)
	self:argCheck(zone, 2, "string")
	if types[zone] == "Battleground" then
		if zone == Z["Eye of the Storm"] then
			return 61, 70
		elseif zone == Z["Alterac Valley"] then
			return 51, 60
		elseif playerLevel >= MAX_PLAYER_LEVEL then
			return MAX_PLAYER_LEVEL, MAX_PLAYER_LEVEL
		elseif playerLevel >= 60 then
			return 60, 69
		elseif playerLevel >= 50 then
			return 50, 59
		elseif playerLevel >= 40 then
			return 40, 49
		elseif playerLevel >= 30 then
			return 30, 39
		elseif playerLevel >= 20 or zone == Z["Arathi Basin"] then
			return 20, 29
		else
			return 10, 19
		end
	end
	return lows[zone], highs[zone]
end

function Tourist:GetLevelColor(zone)
	self:argCheck(zone, 2, "string")
	if types[zone] == "Battleground" then
		if (playerLevel < 61 and zone == Z["Eye of the Storm"]) or (playerLevel < 51 and zone == Z["Alterac Valley"]) or (playerLevel < 20 and zone == Z["Arathi Basin"]) or (playerLevel < 10 and zone == Z["Warsong Gulch"]) then
			return 1, 0, 0
		end
		local playerLevel = playerLevel
		if zone == Z["Alterac Valley"] or zone == "Eye of the Storm" then
			playerLevel = playerLevel - 1
		end
		if playerLevel == MAX_PLAYER_LEVEL then
			return 1, 1, 0
		end
		playerLevel = math.fmod(playerLevel, 10)
		if playerLevel <= 5 then
			return 1, playerLevel / 10, 0
		elseif playerLevel <= 7 then
			return 1, (playerLevel - 3) / 4, 0
		else
			return (9 - playerLevel) / 2, 1, 0
		end
	end
	local low, high = lows[zone], highs[zone]
	
	if low <= 0 and high <= 0 then
		-- City
		return 1, 1, 1
	elseif playerLevel == low and playerLevel == high then
		return 1, 1, 0
	elseif playerLevel <= low - 3 then
		return 1, 0, 0
	elseif playerLevel <= low then
		return 1, (playerLevel - low - 3) / -6, 0
	elseif playerLevel <= (low + high) / 2 then
		return 1, (playerLevel - low) / (high - low) + 0.5, 0
	elseif playerLevel <= high then
		return 2 * (playerLevel - high) / (low - high), 1, 0
	elseif playerLevel <= high + 3 then
		local num = (playerLevel - high) / 6
		return num, 1 - num, num
	else
		return 0.5, 0.5, 0.5
	end
end

function Tourist:GetFactionColor(zone)
	self:argCheck(zone, 2, "string")
	if factions[zone] == (isHorde and "Alliance" or "Horde") then
		return 1, 0, 0
	elseif factions[zone] == (isHorde and "Horde" or "Alliance") then
		return 0, 1, 0
	else
		return 1, 1, 0
	end
end

function Tourist:GetZoneYardSize(zone)
	self:argCheck(zone, 2, "string")
	return yardWidths[zone], yardHeights[zone]
end

local ekXOffset = 15525.32200715066
local ekYOffset = 672.3934326738229

local kalXOffset = -8310.762035321373
local kalYOffset = 1815.149000954498

function Tourist:GetYardDistance(zone1, x1, y1, zone2, x2, y2)
	self:argCheck(zone1, 2, "string")
	self:argCheck(x1, 3, "number")
	self:argCheck(y1, 4, "number")
	self:argCheck(zone2, 5, "string")
	self:argCheck(x2, 6, "number")
	self:argCheck(y2, 7, "number")
	
	local zone1_yardXOffset = yardXOffsets[zone1]
	if not zone1_yardXOffset then
		return nil
	end
	local zone2_yardXOffset = yardXOffsets[zone2]
	if not zone2_yardXOffset then
		return nil
	end
	local zone1_yardYOffset = yardYOffsets[zone1]
	local zone2_yardYOffset = yardYOffsets[zone2]
	
	local zone1_continent = continents[zone1]
	local zone2_continent = continents[zone2]
	if (zone1_continent == Outland) ~= (zone2_continent == Outland) then
		return nil
	end
	
	local zone1_yardWidth = yardWidths[zone1]
	local zone1_yardHeight = yardHeights[zone1]
	local zone2_yardWidth = yardWidths[zone2]
	local zone2_yardHeight = yardHeights[zone2]
	
	local x1_yard = zone1_yardWidth*x1
	local y1_yard = zone1_yardHeight*y1
	local x2_yard = zone2_yardWidth*x2
	local y2_yard = zone2_yardHeight*y2
	
	if zone1 ~= zone2 then
		x1_yard = x1_yard + zone1_yardXOffset
		y1_yard = y1_yard + zone1_yardYOffset
		
		x2_yard = x2_yard + zone2_yardXOffset
		y2_yard = y2_yard + zone2_yardYOffset
		
		if zone1_continent ~= zone2_continent then
			if zone1_continent == Kalimdor then
				x1_yard = x1_yard + kalXOffset
				y1_yard = y1_yard + kalYOffset
			elseif zone1_continent == Eastern_Kingdoms then
				x1_yard = x1_yard + ekXOffset
				y1_yard = y1_yard + ekYOffset
			end
		
			if zone2_continent == Kalimdor then
				x2_yard = x2_yard + kalXOffset
				y2_yard = y2_yard + kalYOffset
			elseif zone2_continent == Eastern_Kingdoms then
				x2_yard = x2_yard + ekXOffset
				y2_yard = y2_yard + ekYOffset
			end
		end
	end
	
	local x_diff = x1_yard - x2_yard
	local y_diff = y1_yard - y2_yard
	local dist_2 = x_diff*x_diff + y_diff*y_diff
	return dist_2^0.5
end

function Tourist:TransposeZoneCoordinate(x, y, zone1, zone2)
	self:argCheck(x, 2, "number")
	self:argCheck(y, 3, "number")
	self:argCheck(zone1, 4, "string")
	self:argCheck(zone2, 5, "string")
	if zone1 == zone2 then
		return x, y
	end
	
	local zone1_yardXOffset = yardXOffsets[zone1]
	if not zone1_yardXOffset then
		return nil
	end
	local zone2_yardXOffset = yardXOffsets[zone2]
	if not zone2_yardXOffset then
		return nil
	end
	local zone1_yardYOffset = yardYOffsets[zone1]
	local zone2_yardYOffset = yardYOffsets[zone2]
	
	local zone1_continent = continents[zone1]
	local zone2_continent = continents[zone2]
	if (zone1_continent == Outland) ~= (zone2_continent == Outland) then
		return nil
	end
	
	local zone1_yardWidth = yardWidths[zone1]
	local zone1_yardHeight = yardHeights[zone1]
	local zone2_yardWidth = yardWidths[zone2]
	local zone2_yardHeight = yardHeights[zone2]
	
	local x_yard = zone1_yardWidth*x
	local y_yard = zone1_yardHeight*y
	
	x_yard = x_yard + zone1_yardXOffset
	y_yard = y_yard + zone1_yardYOffset
	
	if zone1_continent ~= zone2_continent then
		if zone1_continent == Kalimdor then
			x_yard = x_yard + kalXOffset
			y_yard = y_yard + kalYOffset
		elseif zone1_continent == Eastern_Kingdoms then
			x_yard = x_yard + ekXOffset
			y_yard = y_yard + ekYOffset
		end
	
		if zone2_continent == Kalimdor then
			x_yard = x_yard - kalXOffset
			y_yard = y_yard - kalYOffset
		elseif zone2_continent == Eastern_Kingdoms then
			x_yard = x_yard - ekXOffset
			y_yard = y_yard - ekYOffset
		end
	end
	
	x_yard = x_yard - zone2_yardXOffset
	y_yard = y_yard - zone2_yardYOffset
	
	x = x_yard / zone2_yardWidth
	y = y_yard / zone2_yardHeight
	
	return x, y
end

local zonesToIterate = setmetatable({}, {__index = function(self, key)
	local t = {}
	self[key] = t
	for k,v in pairs(continents) do
		if v == key and v ~= k and yardXOffsets[k] then
			t[#t+1] = k
		end
	end
	return t
end})

local kal_yardWidth
local kal_yardHeight
local ek_yardWidth
local ek_yardHeight

function Tourist:GetBestZoneCoordinate(x, y, zone)
	self:argCheck(x, 2, "number")
	self:argCheck(y, 3, "number")
	self:argCheck(zone, 4, "string")
	
	if not kal_yardWidth then
		kal_yardWidth = yardWidths[Kalimdor]
		kal_yardHeight = yardHeights[Kalimdor]
		ek_yardWidth = yardWidths[Eastern_Kingdoms]
		ek_yardHeight = yardHeights[Eastern_Kingdoms]
	end
	
	local zone_yardXOffset = yardXOffsets[zone]
	if not zone_yardXOffset then
		return x, y, zone
	end
	local zone_yardYOffset = yardYOffsets[zone]
	
	local zone_yardWidth = yardWidths[zone]
	local zone_yardHeight = yardHeights[zone]
	
	local x_yard = zone_yardWidth*x
	local y_yard = zone_yardHeight*y
	
	x_yard = x_yard + zone_yardXOffset
	y_yard = y_yard + zone_yardYOffset
	
	local zone_continent = continents[zone]
	local azeroth = false
	if zone_continent == Kalimdor then
		if x_yard < 0 or y_yard < 0 or x_yard > kal_yardWidth or y_yard > kal_yardHeight then
			x_yard = x_yard + kalXOffset
			y_yard = y_yard + kalYOffset
			azeroth = true
		end
	elseif zone_continent == Eastern_Kingdoms then
		if x_yard < 0 or y_yard < 0 or x_yard > ek_yardWidth or y_yard > ek_yardHeight then
			x_yard = x_yard + ekXOffset
			y_yard = y_yard + ekYOffset
			azeroth = true
		end
	end
	if azeroth then
		local kal, ek = zone_continent ~= Kalimdor, zone_continent ~= Eastern_Kingdoms
		if kal and (x_yard < kalXOffset or y_yard < kalYOffset or x_yard > kalXOffset + kal_yardWidth or y_yard > kalYOffset + kal_yardWidth) then
			kal = false
		end
		if ek and (x_yard < ekXOffset or y_yard < ekYOffset or x_yard > ekXOffset + ek_yardWidth or y_yard > ekYOffset + ek_yardWidth) then
			ek = false
		end
		if kal then
			x_yard = x_yard - kalXOffset
			y_yard = y_yard - kalYOffset
			zone_continent = Kalimdor
		elseif ek then
			x_yard = x_yard - ekXOffset
			y_yard = y_yard - ekYOffset
			zone_continent = Eastern_Kingdoms
		else
			return x_yard / yardWidths[Azeroth], y_yard / yardHeights[Azeroth], Azeroth
		end
	end
	
	local best_zone, best_x, best_y, best_value
	
	for _,z in ipairs(zonesToIterate[zone_continent]) do
		local z_yardXOffset = yardXOffsets[z]
		local z_yardYOffset = yardYOffsets[z]
		local z_yardWidth = yardWidths[z]
		local z_yardHeight = yardHeights[z]
		
		local x_yd = x_yard - z_yardXOffset
		local y_yd = y_yard - z_yardYOffset
		
		if x_yd >= 0 and y_yd >= 0 and x_yd <= z_yardWidth and y_yd <= z_yardHeight then
			if types[z] == "City" then
				return x_yd/z_yardWidth, y_yd/z_yardHeight,  z
			end
			local x_tmp = x_yd - z_yardWidth / 2
			local y_tmp = y_yd - z_yardHeight / 2
			local value = x_tmp*x_tmp + y_tmp*y_tmp
			if not best_value or value < best_value then
				best_zone = z
				best_value = value
				best_x = x_yd/z_yardWidth
				best_y = y_yd/z_yardHeight
			end
		end
	end
	if not best_zone then
		return x_yard / yardWidths[zone_continent], y_yard / yardHeights[zone_continent], zone_continent
	end
	return best_x, best_y, best_zone
end

local function retNil() return nil end
local function retOne(object, state)
	if state == object then
		return nil
	else
		return object
	end
end

local function retNormal(t, position)
	return (next(t, position))
end

local function mysort(a,b)
	if not lows[a] then
		return false
	elseif not lows[b] then
		return true
	else	
		local aval, bval = groupSizes[a], groupSizes[b]
		if aval ~= bval then
			return aval < bval
		end
		aval, bval = lows[a], lows[b]
		if aval ~= bval then
			return aval < bval
		end
		aval, bval = highs[a], highs[b]
		if aval ~= bval then
			return aval < bval
		end
		return a < b
	end
end	
local t = {}
local function myiter(t)
	local n = t.n
	n = n + 1
	local v = t[n]
	if v then
		t[n] = nil
		t.n = n
		return v
	else
		t.n = nil
	end
end
function Tourist:IterateZoneInstances(zone)
	self:argCheck(zone, 2, "string")
	
	local inst = instances[zone]
	
	if not inst then
		return retNil
	elseif type(inst) == "table" then
		for k in pairs(t) do
			t[k] = nil
		end
		for k in pairs(inst) do
			t[#t+1] = k
		end
		table.sort(t, mysort)
		t.n = 0
		return myiter, t, nil
	else
		return retOne, inst, nil
	end
end

function Tourist:GetInstanceZone(instance)
	self:argCheck(instance, 2, "string")
	for k, v in pairs(instances) do
		if v then
			if type(v) == "string" then
				if v == instance then
					return k
				end
			else -- table
				for l in pairs(v) do
					if l == instance then
						return k
					end
				end
			end
		end
	end
end

function Tourist:DoesZoneHaveInstances(zone)
	self:argCheck(zone, 2, "string")
	return instances[zone] and true or false
end

local zonesInstances
local function initZonesInstances()
	if not zonesInstances then
		zonesInstances = {}
		for zone, v in pairs(lows) do
			if types[zone] ~= "Transport" then
				zonesInstances[zone] = true
			end
		end
	end
	initZonesInstances = nil
end

function Tourist:IterateZonesAndInstances()
	if initZonesInstances then
		initZonesInstances()
	end
	return retNormal, zonesInstances, nil
end

local function zoneIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and (types[k] == "Instance" or types[k] == "Battleground") do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateZones()
	if initZonesInstances then
		initZonesInstances()
	end
	return zoneIter, nil, nil
end

local function instanceIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and (types[k] ~= "Instance" and types[k] ~= "Battleground") do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateInstances()
	if initZonesInstances then
		initZonesInstances()
	end
	return instanceIter, nil, nil
end

local function bgIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and types[k] ~= "Battleground" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateBattlegrounds()
	if initZonesInstances then
		initZonesInstances()
	end
	return bgIter, nil, nil
end

local function pvpIter(_, position)
    local k = next(zonesInstances, position)
    while k ~= nil and types[k] ~= "PvP Zone" do
        k = next(zonesInstances, k)
    end
    return k
end
function Tourist:IteratePvPZones()
	if initZonesInstances then
		initZonesInstances()
	end
    return pvpIter, nil, nil
end

local function allianceIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] ~= "Alliance" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateAlliance()
	if initZonesInstances then
		initZonesInstances()
	end
	return allianceIter, nil, nil
end

local function hordeIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] ~= "Horde" do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateHorde()
	if initZonesInstances then
		initZonesInstances()
	end
	return hordeIter, nil, nil
end

if isHorde then
	Tourist.IterateFriendly = Tourist.IterateHorde
	Tourist.IterateHostile = Tourist.IterateAlliance
else
	Tourist.IterateFriendly = Tourist.IterateAlliance
	Tourist.IterateHostile = Tourist.IterateHorde
end

local function contestedIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and factions[k] do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateContested()
	if initZonesInstances then
		initZonesInstances()
	end
	return contestedIter, nil, nil
end

local function kalimdorIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Kalimdor do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateKalimdor()
	if initZonesInstances then
		initZonesInstances()
	end
	return kalimdorIter, nil, nil
end

local function easternKingdomsIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Eastern_Kingdoms do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateEasternKingdoms()
	if initZonesInstances then
		initZonesInstances()
	end
	return easternKingdomsIter, nil, nil
end

local function outlandIter(_, position)
	local k = next(zonesInstances, position)
	while k ~= nil and continents[k] ~= Outland do
		k = next(zonesInstances, k)
	end
	return k
end
function Tourist:IterateOutland()
	if initZonesInstances then
		initZonesInstances()
	end
	return outlandIter, nil, nil
end

function Tourist:IterateRecommendedZones()
	return retNormal, recZones, nil
end

function Tourist:IterateRecommendedInstances()
	return retNormal, recInstances, nil
end

function Tourist:HasRecommendedInstances()
	return next(recInstances) ~= nil
end

function Tourist:IsInstance(zone)
	self:argCheck(zone, 2, "string")
	local t = types[zone]
	return t == "Instance" or t == "Battleground"
end

function Tourist:IsZone(zone)
	self:argCheck(zone, 2, "string")
	local t = types[zone]
	return t ~= "Instance" and t ~= "Battleground" and t ~= "Transport"
end

function Tourist:GetComplex(zone)
	self:argCheck(zone, 2, "string")
	return complexes[zone]
end

function Tourist:IsZoneOrInstance(zone)
	self:argCheck(zone, 2, "string")
	local t = types[zone]
	return t and t ~= "Transport"
end

function Tourist:IsBattleground(zone)
	self:argCheck(zone, 2, "string")
	local t = types[zone]
	return t == "Battleground"
end

function Tourist:IsArena(zone)
	self:argCheck(zone, 2, "string")
	local t = types[zone]
	return t == "Arena"
end

function Tourist:IsPvPZone(zone)
    self:argCheck(zone, 2, "string")
    local t = types[zone]
    return t == "PvP Zone"
end

function Tourist:IsCity(zone)
	self:argCheck(zone, 2, "string")
	local t = types[zone]
	return t == "City"
end

function Tourist:IsAlliance(zone)
	self:argCheck(zone, 2, "string")
	return factions[zone] == "Alliance"
end

function Tourist:IsHorde(zone)
	self:argCheck(zone, 2, "string")
	return factions[zone] == "Horde"
end

if isHorde then
	Tourist.IsFriendly = Tourist.IsHorde
	Tourist.IsHostile = Tourist.IsAlliance
else
	Tourist.IsFriendly = Tourist.IsAlliance
	Tourist.IsHostile = Tourist.IsHorde
end

function Tourist:IsContested(zone)
	self:argCheck(zone, 2, "string")
	return not factions[zone]
end

function Tourist:GetContinent(zone)
	self:argCheck(zone, 2, "string")
	
	return continents[zone] or UNKNOWN
end

function Tourist:IsInKalimdor(zone)
	self:argCheck(zone, 2, "string")
	
	return continents[zone] == Kalimdor
end

function Tourist:IsInEasternKingdoms(zone)
	self:argCheck(zone, 2, "string")
	
	return continents[zone] == Eastern_Kingdoms
end

function Tourist:IsInOutland(zone)
	self:argCheck(zone, 2, "string")
	
	return continents[zone] == Outland
end

function Tourist:GetInstanceGroupSize(instance)
	self:argCheck(instance, 2, "string")
	
	return groupSizes[instance] or 0
end

function Tourist:GetTexture(zone)
	self:argCheck(zone, 2, "string")
	
	return textures[zone]
end

function Tourist:GetZoneFromTexture(texture)
	self:argCheck(texture, 2, "string", "nil")
	
	if not texture then
		return Z["Azeroth"]
	end
	return textures_rev[texture]
end

function Tourist:GetEnglishZoneFromTexture(texture)
	self:argCheck(texture, 2, "string", "nil")
	
	if not texture then
		return "Azeroth"
	end
	local zone = textures_rev[texture]
	if zone then
		return Z:GetReverseTranslation(zone)
	end
	return nil
end

local inf = 1/0
local stack = setmetatable({}, {__mode='k'})
local function iterator(S)
	local position = S['#'] - 1
	S['#'] = position
	local x = S[position]
	if not x then
		for k in pairs(S) do
			S[k] = nil
		end
		stack[S] = true
		return nil
	end
	return x
end

setmetatable(cost, {
	__index = function(self, vertex)
		local price = 1
		
		if lows[vertex] > playerLevel then
			price = price * (1 + math.ceil((lows[vertex] - playerLevel) / 6))
		end
		
		if factions[vertex] == (isHorde and "Horde" or "Alliance") then
			price = price / 2
		elseif factions[vertex] == (isHorde and "Alliance" or "Horde") then
			if types[vertex] == "City" then
				price = price * 10
			else
				price = price * 3
			end
		end
		
		if types[x] == "Transport" then
			price = price * 2
		end
		
		self[vertex] = price
		return price
	end
})

function Tourist:IteratePath(alpha, bravo)
	self:argCheck(alpha, 2, "string")
	self:argCheck(bravo, 3, "string")
	
	if paths[alpha] == nil or paths[bravo] == nil then
		return retNil
	end
	
	local d = next(stack) or {}
	stack[d] = nil
	local Q = next(stack) or {}
	stack[Q] = nil
	local S = next(stack) or {}
	stack[S] = nil
	local pi = next(stack) or {}
	stack[pi] = nil
	
	for vertex, v in pairs(paths) do
		d[vertex] = inf
		Q[vertex] = v
	end
	d[alpha] = 0
	
	while next(Q) do
		local u
		local min = inf
		for z in pairs(Q) do
			local value = d[z]
			if value < min then
				min = value
				u = z
			end
		end
		if min == inf then
			return retNil
		end
		Q[u] = nil
		if u == bravo then
			break
		end
		
		local adj = paths[u]
		if type(adj) == "table" then
			local d_u = d[u]
			for v in pairs(adj) do
				local c = d_u + cost[v]
				if d[v] > c then
					d[v] = c
					pi[v] = u
				end
			end
		elseif adj ~= false then
			local c = d[u] + cost[adj]
			if d[adj] > c then
				d[adj] = c
				pi[adj] = u
			end
		end
	end
	
	local i = 1
	local last = bravo
	while last do
		S[i] = last
		i = i + 1
		last = pi[last]
	end
	
	for k in pairs(pi) do
		pi[k] = nil
	end
	for k in pairs(Q) do
		Q[k] = nil
	end
	for k in pairs(d) do
		d[k] = nil
	end
	stack[pi] = true
	stack[Q] = true
	stack[d] = true
	
	S['#'] = i
	
	return iterator, S
end

local function retWithOffset(t, key)
	while true do
		key = next(t, key)
		if not key then
			return nil
		end
		if yardYOffsets[key] then
			return key
		end
	end
end

function Tourist:IterateBorderZones(zone, zonesOnly)
	self:argCheck(zone, 2, "string")
	local path = paths[zone]
	if not path then
		return retNil
	elseif type(path) == "table" then
		return zonesOnly and retWithOffset or retNormal, path
	else
		if zonesOnly and not yardYOffsets[path] then
			return retNil
		end
		return retOne, path
	end
end

local function activate(self, oldLib, oldDeactivate)
	Tourist = self
	self.frame = oldLib and oldLib.frame or CreateFrame("Frame", "TouristLibFrame", UIParent)
	self.frame:UnregisterAllEvents()
	self.frame:RegisterEvent("PLAYER_LEVEL_UP")
	self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.frame:SetScript("OnEvent", function()
		PLAYER_LEVEL_UP(self)
	end)
	
	local BOOTYBAY_RATCHET_BOAT = string.format(X_Y_BOAT, Z["Booty Bay"], Z["Ratchet"])
	local MENETHIL_THERAMORE_BOAT = string.format(X_Y_BOAT, Z["Menethil Harbor"], Z["Theramore Isle"])
	local MENETHIL_AUBERDINE_BOAT = string.format(X_Y_BOAT, Z["Menethil Harbor"], Z["Auberdine"])
	local AUBERDINE_DARNASSUS_BOAT = string.format(X_Y_BOAT, Z["Auberdine"], Z["Darnassus"])
	local AUBERDINE_AZUREMYST_BOAT = string.format(X_Y_BOAT, Z["Auberdine"], Z["Azuremyst Isle"])
	local ORGRIMMAR_UNDERCITY_ZEPPELIN = string.format(X_Y_ZEPPELIN, Z["Orgrimmar"], Z["Undercity"])
	local ORGRIMMAR_GROMGOL_ZEPPELIN = string.format(X_Y_ZEPPELIN, Z["Orgrimmar"], Z["Grom'gol Base Camp"])
	local UNDERCITY_GROMGOL_ZEPPELIN = string.format(X_Y_ZEPPELIN, Z["Undercity"], Z["Grom'gol Base Camp"])
	local SHATTRATH_IRONFORGE_PORTAL = string.format(X_Y_PORTAL, Z["Shattrath City"], Z["Ironforge"])
	local SHATTRATH_STORMWIND_PORTAL = string.format(X_Y_PORTAL, Z["Shattrath City"], Z["Stormwind City"])
	local SHATTRATH_DARNASSUS_PORTAL = string.format(X_Y_PORTAL, Z["Shattrath City"], Z["Darnassus"])
	local SHATTRATH_ORGRIMMAR_PORTAL = string.format(X_Y_PORTAL, Z["Shattrath City"], Z["Orgrimmar"])
	local SHATTRATH_THUNDERBLUFF_PORTAL = string.format(X_Y_PORTAL, Z["Shattrath City"], Z["Thunder Bluff"])
	local SHATTRATH_UNDERCITY_PORTAL = string.format(X_Y_PORTAL, Z["Shattrath City"], Z["Undercity"])
	local SHATTRATH_EXODAR_PORTAL = string.format(X_Y_PORTAL, Z["Shattrath City"], Z["The Exodar"])
	local SHATTRATH_SILVERMOON_PORTAL = string.format(X_Y_PORTAL, Z["Shattrath City"], Z["Silvermoon City"])
	
	local zones = {}
	
	zones[Z["Eastern Kingdoms"]] = {
		type = "Continent",
		yards = 37649.15159852673,
		x_offset = 0,
		y_offset = 0,
		continent = Eastern_Kingdoms,
		texture = "Azeroth",
	}
	
	zones[Z["Kalimdor"]] = {
		type = "Continent",
		yards = 36798.56388065484,
		x_offset = 0,
		y_offset = 0,
		continent = Kalimdor,
		texture = "Kalimdor",
	}
	
	zones[Z["Outland"]] = {
		type = "Continent",
		yards = 17463.5328406368,
		x_offset = 0,
		y_offset = 0,
		continent = Outland,
		texture = "Expansion01",
	}

	zones[Z["Azeroth"]] = {
		type = "Continent",
		yards = 44531.82907938571,
		x_offset = 0,
		y_offset = 0,
	}
	
	zones[AUBERDINE_AZUREMYST_BOAT] = {
		paths = {
			[Z["Darkshore"]] = true,
			[Z["Azuremyst Isle"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}
	
	zones[AUBERDINE_DARNASSUS_BOAT] = {
		paths = {
			[Z["Darkshore"]] = true,
			[Z["Darnassus"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[BOOTYBAY_RATCHET_BOAT] = {
		paths = {
			[Z["Stranglethorn Vale"]] = true,
			[Z["The Barrens"]] = true,
		},
		type = "Transport",
	}

	zones[MENETHIL_AUBERDINE_BOAT] = {
		paths = {
			[Z["Wetlands"]] = true,
			[Z["Darkshore"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[MENETHIL_THERAMORE_BOAT] = {
		paths = {
			[Z["Wetlands"]] = true,
			[Z["Dustwallow Marsh"]] = true,
		},
		faction = "Alliance",
		type = "Transport",
	}

	zones[ORGRIMMAR_GROMGOL_ZEPPELIN] = {
		paths = {
			[Z["Durotar"]] = true,
			[Z["Stranglethorn Vale"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[ORGRIMMAR_UNDERCITY_ZEPPELIN] = {
		paths = {
			[Z["Durotar"]] = true,
			[Z["Tirisfal Glades"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}
	
	zones[SHATTRATH_DARNASSUS_PORTAL] = {
		paths = Z["Darnassus"],
		type = "Transport",
	}
	
	zones[SHATTRATH_EXODAR_PORTAL] = {
		paths = Z["The Exodar"],
		type = "Transport",
	}
	
	zones[SHATTRATH_IRONFORGE_PORTAL] = {
		paths = Z["Ironforge"],
		type = "Transport",
	}
	
	zones[SHATTRATH_ORGRIMMAR_PORTAL] = {
		paths = Z["Orgrimmar"],
		type = "Transport",
	}
	
	zones[SHATTRATH_SILVERMOON_PORTAL] = {
		paths = Z["Silvermoon City"],
		type = "Transport",
	}
	
	zones[SHATTRATH_STORMWIND_PORTAL] = {
		paths = Z["Stormwind City"],
		type = "Transport",
	}
	
	zones[SHATTRATH_THUNDERBLUFF_PORTAL] = {
		paths = Z["Thunder Bluff"],
		type = "Transport",
	}
	
	zones[SHATTRATH_UNDERCITY_PORTAL] = {
		paths = Z["Undercity"],
		type = "Transport",
	}
	
	zones[Z["The Dark Portal"]] = {
		paths = {
			[Z["Blasted Lands"]] = true,
			[Z["Hellfire Peninsula"]] = true,
		},
		type = "Transport",
	}

	zones[UNDERCITY_GROMGOL_ZEPPELIN] = {
		paths = {
			[Z["Stranglethorn Vale"]] = true,
			[Z["Tirisfal Glades"]] = true,
		},
		faction = "Horde",
		type = "Transport",
	}

	zones[Z["Alterac Valley"]] = {
		continent = Eastern_Kingdoms,
		paths = Z["Alterac Mountains"],
		groupSize = 40,
		type = "Battleground",
		texture = "AlteracValley",
	}

	zones[Z["Arathi Basin"]] = {
		continent = Eastern_Kingdoms,
		paths = Z["Arathi Highlands"],
		groupSize = 15,
		type = "Battleground",
		texture = "ArathiBasin",
	}

	zones[Z["Warsong Gulch"]] = {
		continent = Kalimdor,
		paths = isHorde and Z["The Barrens"] or Z["Ashenvale"],
		groupSize = 10,
		type = "Battleground",
		texture = "WarsongGulch",
	}

	zones[Z["Deeprun Tram"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Stormwind City"]] = true,
			[Z["Ironforge"]] = true,
		},
		faction = "Alliance",
	}

	zones[Z["Ironforge"]] = {
		continent = Eastern_Kingdoms,
		instances = Z["Gnomeregan"],
		paths = {
			[Z["Dun Morogh"]] = true,
			[Z["Deeprun Tram"]] = true,
		},
		faction = "Alliance",
		type = "City",
		yards = 790.5745810546713,
		x_offset = 17764.34206355846,
		y_offset = 13762.32403658607,
		fishing_min = 1,
		texture = "Ironforge",
	}
	
	zones[Z["Silvermoon City"]] = {
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Eversong Woods"]] = true,
			[Z["Undercity"]] = true,
		},
		faction = "Horde",
		type = "City",
		yards = 1211.384457945605,
		x_offset = 21051.29911245071,
		y_offset = 1440.439646345552,
		fishing_min = 1,
		texture = "SilvermoonCity",
	}
	
	zones[Z["Stormwind City"]] = {
		continent = Eastern_Kingdoms,
		instances = Z["The Stockade"],
		paths = {
			[Z["Deeprun Tram"]] = true,
			[Z["The Stockade"]] = true,
			[Z["Elwynn Forest"]] = true,
			[Z["Champions' Hall"]] = true,
		},
		faction = "Alliance",
		type = "City",
		yards = 1344.138055148283,
		x_offset = 15669.93346231942,
		y_offset = 17471.62163820253,
		fishing_min = 1,
		texture = "Stormwind",
	}
	
	zones[Z["Champions' Hall"]] = {
		continent = Eastern_Kingdoms,
		paths = Z["Stormwind City"],
		faction = "Alliance",
	}
	
	zones[Z["Undercity"]] = {
		continent = Eastern_Kingdoms,
		instances = {
			[Z["Armory"]] = true,
			[Z["Library"]] = true,
			[Z["Graveyard"]] = true,
			[Z["Cathedral"]] = true,
		},
		paths = {
			[Z["Silvermoon City"]] = true,
			[Z["Tirisfal Glades"]] = true,
		},
		faction = "Horde",
		type = "City",
		yards = 959.3140238076666,
		x_offset = 16177.65630384973,
		y_offset = 7315.685533181013,
		texture = "Undercity",
	}
	
	zones[Z["Dun Morogh"]] = {
		low = 1,
		high = 10,
		continent = Eastern_Kingdoms,
		instances = Z["Gnomeregan"],
		paths = {
			[Z["Wetlands"]] = true,
			[Z["Gnomeregan"]] = true,
			[Z["Ironforge"]] = true,
			[Z["Loch Modan"]] = true,
		},
		faction = "Alliance",
		yards = 4924.664537147015,
		x_offset = 15248.84370721237,
		y_offset = 13070.22369811241,
		fishing_min = 1,
		texture = "DunMorogh",
	}
	
	zones[Z["Elwynn Forest"]] = {
		low = 1,
		high = 10,
		continent = Eastern_Kingdoms,
		instances = Z["The Stockade"],
		paths = {
			[Z["Westfall"]] = true,
			[Z["Redridge Mountains"]] = true,
			[Z["Stormwind City"]] = true,
			[Z["Duskwood"]] = true,
		},
		faction = "Alliance",
		yards = 3470.62593362794,
		x_offset = 15515.46777926721,
		y_offset = 17132.38313881497,
		fishing_min = 1,
		texture = "Elwynn",
	}
	
	zones[Z["Eversong Woods"]] = {
		low = 1,
		high = 10,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Silvermoon City"]] = true,
			[Z["Ghostlands"]] = true,
		},
		faction = "Horde",
		yards = 4924.70470173181,
		x_offset = 19138.16325760612,
		y_offset = 552.5351270080572,
		fishing_min = 20,
		texture = "EversongWoods",
	}
	
	zones[Z["Tirisfal Glades"]] = {
		low = 1,
		high = 10,
		continent = Eastern_Kingdoms,
		instances = {
			[Z["Armory"]] = true,
			[Z["Library"]] = true,
			[Z["Graveyard"]] = true,
			[Z["Cathedral"]] = true,
		},
		paths = {
			[Z["Western Plaguelands"]] = true,
			[Z["Undercity"]] = true,
			[Z["Scarlet Monastery"]] = true,
			[UNDERCITY_GROMGOL_ZEPPELIN] = true,
			[ORGRIMMAR_UNDERCITY_ZEPPELIN] = true,
			[Z["Silverpine Forest"]] = true,
		},
		faction = "Horde",
		yards = 4518.469744413802,
		x_offset = 14017.64852522109,
		y_offset = 5356.296558943325,
		fishing_min = 1,
		texture = "Tirisfal",
	}
	
	zones[Z["Ghostlands"]] = {
		low = 10,
		high = 20,
		continent = Eastern_Kingdoms,
		instances = Z["Zul'Aman"],
		paths = {
			[Z["Eastern Plaguelands"]] = true,
			[Z["Zul'Aman"]] = true,
			[Z["Eversong Woods"]] = true,
		},
		faction = "Horde",
		yards = 3299.755735439147,
		x_offset = 19933.969945598,
		y_offset = 3327.317139912411,
		fishing_min = 20,
		texture = "Ghostlands",
	}
	
	zones[Z["Loch Modan"]] = {
		low = 10,
		high = 20,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Wetlands"]] = true,
			[Z["Badlands"]] = true,
			[Z["Dun Morogh"]] = true,
			[Z["Searing Gorge"]] = not isHorde and true or nil,
		},
		faction = "Alliance",
		yards = 2758.158752877019,
		x_offset = 19044.42466174755,
		y_offset = 13680.58746225864,
		fishing_min = 20,
		texture = "LochModan",
	}

	zones[Z["Silverpine Forest"]] = {
		low = 10,
		high = 20,
		continent = Eastern_Kingdoms,
		instances = Z["Shadowfang Keep"],
		paths = {
			[Z["Tirisfal Glades"]] = true,
			[Z["Hillsbrad Foothills"]] = true,
			[Z["Shadowfang Keep"]] = true,
		},
		faction = "Horde",
		yards = 4199.739879721531,
		x_offset = 13601.00798540562,
		y_offset = 7526.945768538925,
		fishing_min = 20,
		texture = "Silverpine",
	}

	zones[Z["Westfall"]] = {
		low = 10,
		high = 20,
		continent = Eastern_Kingdoms,
		instances = Z["The Deadmines"],
		paths = {
			[Z["Duskwood"]] = true,
			[Z["Elwynn Forest"]] = true,
			[Z["The Deadmines"]] = true,
		},
		faction = "Alliance",
		yards = 3499.786489780177,
		x_offset = 14034.31142029944,
		y_offset = 18592.67765947875,
		fishing_min = 55,
		texture = "Westfall",
	}

	zones[Z["Redridge Mountains"]] = {
		low = 15,
		high = 25,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Burning Steppes"]] = true,
			[Z["Elwynn Forest"]] = true,
			[Z["Duskwood"]] = true,
		},
		yards = 2170.704876735185,
		x_offset = 18621.52904187992,
		y_offset = 17767.73128664901,
		fishing_min = 55,
		texture = "Redridge",
	}

	zones[Z["Duskwood"]] = {
		low = 18,
		high = 30,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Redridge Mountains"]] = true,
			[Z["Stranglethorn Vale"]] = true,
			[Z["Westfall"]] = true,
			[Z["Deadwind Pass"]] = true,
			[Z["Elwynn Forest"]] = true,
		},
		yards = 2699.837284973949,
		x_offset = 16217.51007473156,
		y_offset = 18909.31475362112,
		fishing_min = 55,
		texture = "Duskwood",
	}

	zones[Z["Hillsbrad Foothills"]] = {
		low = 20,
		high = 30,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Alterac Mountains"]] = true,
			[Z["The Hinterlands"]] = true,
			[Z["Arathi Highlands"]] = true,
			[Z["Silverpine Forest"]] = true,
		},
		yards = 3199.802496078764,
		x_offset = 15984.19170342619,
		y_offset = 8793.505832296016,
		fishing_min = 55,
		texture = "Hilsbrad",
	}

	zones[Z["Wetlands"]] = {
		low = 20,
		high = 30,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Arathi Highlands"]] = true,
			[MENETHIL_AUBERDINE_BOAT] = true,
			[MENETHIL_THERAMORE_BOAT] = true,
			[Z["Dun Morogh"]] = true,
			[Z["Loch Modan"]] = true,
		},
		yards = 4135.166184805389,
		x_offset = 17440.35277057554,
		y_offset = 11341.20698670613,
		fishing_min = 55,
		texture = "Wetlands",
	}

	zones[Z["Alterac Mountains"]] = {
		low = 30,
		high = 40,
		continent = Eastern_Kingdoms,
		instances = Z["Alterac Valley"],
		paths = {
			[Z["Western Plaguelands"]] = true,
			[Z["Alterac Valley"]] = true,
			[Z["Hillsbrad Foothills"]] = true,
		},
		yards = 2799.820894040741,
		x_offset = 16267.51182664554,
		y_offset = 7693.598754637632,
		fishing_min = 130,
		texture = "Alterac",
	}

	zones[Z["Arathi Highlands"]] = {
		low = 30,
		high = 40,
		continent = Eastern_Kingdoms,
		instances = Z["Arathi Basin"],
		paths = {
			[Z["Wetlands"]] = true,
			[Z["Hillsbrad Foothills"]] = true,
			[Z["Arathi Basin"]] = true,
		},
		yards = 3599.78645678886,
		x_offset = 17917.40598190062,
		y_offset = 9326.804744097401,
		fishing_min = 130,
		texture = "Arathi",
	}

	zones[Z["Stranglethorn Vale"]] = {
		low = 30,
		high = 45,
		continent = Eastern_Kingdoms,
		instances = Z["Zul'Gurub"],
		paths = {
			[Z["Zul'Gurub"]] = true,
			[BOOTYBAY_RATCHET_BOAT] = true,
			[Z["Duskwood"]] = true,
			[ORGRIMMAR_GROMGOL_ZEPPELIN] = true,
			[UNDERCITY_GROMGOL_ZEPPELIN] = true,
		},
		yards = 6380.866711475876,
		x_offset = 14830.09122763351,
		y_offset = 20361.27611706414,
		fishing_min = 130,
		texture = "Stranglethorn",
	}

	zones[Z["Badlands"]] = {
		low = 35,
		high = 45,
		continent = Eastern_Kingdoms,
		instances = Z["Uldaman"],
		paths = {
			[Z["Uldaman"]] = true,
			[Z["Searing Gorge"]] = true,
			[Z["Loch Modan"]] = true,
		},
		yards = 2487.343589680943,
		x_offset = 19129.83542887301,
		y_offset = 15082.55526717644,
		texture = "Badlands",
	}

	zones[Z["Swamp of Sorrows"]] = {
		low = 35,
		high = 45,
		continent = Eastern_Kingdoms,
		instances = Z["The Temple of Atal'Hakkar"],
		paths = {
			[Z["Blasted Lands"]] = true,
			[Z["Deadwind Pass"]] = true,
			[Z["The Temple of Atal'Hakkar"]] = true,
		},
		yards = 2293.606089974149,
		x_offset = 19273.57577346738,
		y_offset = 18813.48829580375,
		fishing_min = 130,
		texture = "SwampOfSorrows",
	}

	zones[Z["The Hinterlands"]] = {
		low = 40,
		high = 50,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Hillsbrad Foothills"]] = true,
			[Z["Western Plaguelands"]] = true,
		},
		yards = 3849.77134323942,
		x_offset = 18625.69536724846,
		y_offset = 7726.929725104341,
		fishing_min = 205,
		texture = "Hinterlands",
	}

	zones[Z["Searing Gorge"]] = {
		low = 43,
		high = 50,
		continent = Eastern_Kingdoms,
		instances = {
			[Z["Blackrock Depths"]] = true,
			[Z["Blackwing Lair"]] = true,
			[Z["Molten Core"]] = true,
			[Z["Blackrock Spire"]] = true,
		},
		paths = {
			[Z["Blackrock Mountain"]] = true,
			[Z["Badlands"]] = true,
			[Z["Loch Modan"]] = not isHorde and true or nil,
		},
		yards = 2231.119799153945,
		x_offset = 17373.68649889545,
		y_offset = 15292.9566475719,
		texture = "SearingGorge",
	}

	zones[Z["Blackrock Mountain"]] = {
		low = 42,
		high = 54,
		continent = Eastern_Kingdoms,
		instances = {
			[Z["Blackrock Depths"]] = true,
			[Z["Blackwing Lair"]] = true,
			[Z["Molten Core"]] = true,
			[Z["Blackrock Spire"]] = true,
		},
		paths = {
			[Z["Burning Steppes"]] = true,
			[Z["Blackwing Lair"]] = true,
			[Z["Molten Core"]] = true,
			[Z["Blackrock Depths"]] = true,
			[Z["Searing Gorge"]] = true,
			[Z["Blackrock Spire"]] = true,
		},
	}

	zones[Z["Deadwind Pass"]] = {
		low = 55,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = Z["Karazhan"],
		paths = {
			[Z["Duskwood"]] = true,
			[Z["Swamp of Sorrows"]] = true,
			[Z["Karazhan"]] = true,
		},
		yards = 2499.848163715574,
		x_offset = 17884.07519016362,
		y_offset = 19059.30117481421,
		fishing_min = 330,
		texture = "DeadwindPass",
	}

	zones[Z["Blasted Lands"]] = {
		low = 45,
		high = 55,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["The Dark Portal"]] = true,
			[Z["Swamp of Sorrows"]] = true,
		},
		yards = 3349.808966078055,
		x_offset = 18292.37876312771,
		y_offset = 19759.24272564734,
		texture = "BlastedLands",
	}

	zones[Z["Burning Steppes"]] = {
		low = 50,
		high = 58,
		continent = Eastern_Kingdoms,
		instances = {
			[Z["Blackrock Depths"]] = true,
			[Z["Blackwing Lair"]] = true,
			[Z["Molten Core"]] = true,
			[Z["Blackrock Spire"]] = true,
		},
		paths = {
			[Z["Blackrock Mountain"]] = true,
			[Z["Redridge Mountains"]] = true,
		},
		yards = 2928.988452241535,
		x_offset = 17317.44291506163,
		y_offset = 16224.12640057407,
		fishing_min = 330,
		texture = "BurningSteppes",
	}

	zones[Z["Western Plaguelands"]] = {
		low = 51,
		high = 58,
		continent = Eastern_Kingdoms,
		instances = Z["Scholomance"],
		paths = {
			[Z["The Hinterlands"]] = true,
			[Z["Eastern Plaguelands"]] = true,
			[Z["Tirisfal Glades"]] = true,
			[Z["Scholomance"]] = true,
			[Z["Alterac Mountains"]] = true,
		},
		yards = 4299.7374000546,
		x_offset = 16634.14908983872,
		y_offset = 5827.092974820261,
		fishing_min = 205,
		texture = "WesternPlaguelands",
	}

	zones[Z["Eastern Plaguelands"]] = {
		low = 53,
		high = 60,
		continent = Eastern_Kingdoms,
		instances = {
			[Z["Stratholme"]] = true,
			[Z["Naxxramas"]] = true,
		},
		paths = {
			[Z["Western Plaguelands"]] = true,
			[Z["Naxxramas"]] = true,
			[Z["Stratholme"]] = true,
			[Z["Ghostlands"]] = true,
		},
		yards = 3870.596078314358,
		x_offset = 19236.07699848783,
		y_offset = 5393.799386328108,
        type = "PvP Zone",
		fishing_min = 330,
		texture = "EasternPlaguelands",
	}

	zones[Z["The Deadmines"]] = {
		low = isWestern and 17 or 15,
		high = isWestern and 26 or 20,
		continent = Eastern_Kingdoms,
		paths = Z["Westfall"],
		groupSize = 5,
		faction = "Alliance",
		type = "Instance",
		fishing_min = 20,
	}

	zones[Z["Shadowfang Keep"]] = {
		low = isWestern and 22 or 18,
		high = isWestern and 30 or 25,
		continent = Eastern_Kingdoms,
		paths = Z["Silverpine Forest"],
		groupSize = 5,
		faction = "Horde",
		type = "Instance",
	}

	zones[Z["The Stockade"]] = {
		low = isWestern and 24 or 23,
		high = isWestern and 32 or 26,
		continent = Eastern_Kingdoms,
		paths = Z["Stormwind City"],
		groupSize = 5,
		faction = "Alliance",
		type = "Instance",
	}

	zones[Z["Gnomeregan"]] = {
		low = isWestern and 29 or 24,
		high = isWestern and 38 or 33,
		continent = Eastern_Kingdoms,
		paths = Z["Dun Morogh"],
		groupSize = 5,
		faction = "Alliance",
		type = "Instance",
	}

	zones[Z["Scarlet Monastery"]] = {
		low = isWestern and 34 or 30,
		high = isWestern and 45 or 40,
		continent = Eastern_Kingdoms,
		instances = {
			[Z["Armory"]] = true,
			[Z["Library"]] = true,
			[Z["Graveyard"]] = true,
			[Z["Cathedral"]] = true,
		},
		paths = {
			[Z["Tirisfal Glades"]] = true,
			[Z["Armory"]] = true,
			[Z["Library"]] = true,
			[Z["Graveyard"]] = true,
			[Z["Cathedral"]] = true,
		},
		faction = "Horde",
		type = "Instance",
	}

	zones[Z["Armory"]] = {
		low = isWestern and 34 or 30,
		high = isWestern and 45 or 40,
		continent = Eastern_Kingdoms,
		paths = Z["Scarlet Monastery"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Scarlet Monastery"],
	}

	zones[Z["Library"]] = {
		low = isWestern and 34 or 30,
		high = isWestern and 45 or 40,
		continent = Eastern_Kingdoms,
		paths = Z["Scarlet Monastery"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Scarlet Monastery"],
	}

	zones[Z["Graveyard"]] = {
		low = isWestern and 34 or 30,
		high = isWestern and 45 or 40,
		continent = Eastern_Kingdoms,
		paths = Z["Scarlet Monastery"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Scarlet Monastery"],
	}

	zones[Z["Cathedral"]] = {
		low = isWestern and 34 or 30,
		high = isWestern and 45 or 40,
		continent = Eastern_Kingdoms,
		paths = Z["Scarlet Monastery"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Scarlet Monastery"],
	}

	zones[Z["Uldaman"]] = {
		low = isWestern and 41 or 35,
		high = isWestern and 51 or 45,
		continent = Eastern_Kingdoms,
		paths = Z["Badlands"],
		groupSize = 5,
		type = "Instance",
	}

	zones[Z["The Temple of Atal'Hakkar"]] = {
		low = isWestern and 50 or 44,
		high = isWestern and 60 or 50,
		continent = Eastern_Kingdoms,
		paths = Z["Swamp of Sorrows"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 205,
	}

	zones[Z["Blackrock Depths"]] = {
		low = isWestern and 52 or 48,
		high = isWestern and 60 or 56,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Molten Core"]] = true,
			[Z["Blackrock Mountain"]] = true,
		},
		groupSize = 5,
		type = "Instance",
	}

	zones[Z["Blackrock Spire"]] = {
		low = isWestern and 55 or 53,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = {
			[Z["Blackrock Mountain"]] = true,
			[Z["Blackwing Lair"]] = true,
		},
		groupSize = 10,
		type = "Instance",
	}

	zones[Z["Scholomance"]] = {
		low = 58,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = Z["Western Plaguelands"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 330,
	}

	zones[Z["Stratholme"]] = {
		low = isWestern and 58 or 55,
		high = 60,
		continent = Eastern_Kingdoms,
		paths = Z["Eastern Plaguelands"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 330,
	}

	zones[Z["Blackwing Lair"]] = {
		low = 60,
		high = 62,
		continent = Eastern_Kingdoms,
		paths = Z["Blackrock Mountain"],
		groupSize = 40,
		type = "Instance",
	}

	zones[Z["Molten Core"]] = {
		low = 60,
		high = 62,
		continent = Eastern_Kingdoms,
		paths = Z["Blackrock Mountain"],
		groupSize = 40,
		type = "Instance",
	}

	zones[Z["Zul'Gurub"]] = {
		low = 60,
		high = 62,
		continent = Eastern_Kingdoms,
		paths = Z["Stranglethorn Vale"],
		groupSize = 20,
		type = "Instance",
		fishing_min = 330,
	}

	zones[Z["Naxxramas"]] = {
		low = 60,
		high = 70,
		continent = Eastern_Kingdoms,
		groupSize = 40,
		type = "Instance",
	}
	
	zones[Z["Karazhan"]] = {
		low = 70,
		high = 70,
		continent = Eastern_Kingdoms,
		paths = Z["Deadwind Pass"],
		groupSize = 10,
		type = "Instance",
	}
	
	zones[Z["Zul'Aman"]] = {
		low = 70,
		high = 70,
		continent = Eastern_Kingdoms,
		paths = Z["Ghostlands"],
		groupSize = 0,
		type = "Instance",
	}

	zones[Z["Darnassus"]] = {
		continent = Kalimdor,
		paths = {
			[Z["Teldrassil"]] = true,
			[AUBERDINE_DARNASSUS_BOAT] = true,
		},
		faction = "Alliance",
		type = "City",
		yards = 1058.300884213672,
		x_offset = 14127.75729935019,
		y_offset = 2561.497770365213,
		fishing_min = 1,
		texture = "Darnassis",
	}

	zones[Z["Hyjal"]] = {
		continent = Kalimdor,
	}

	zones[Z["Moonglade"]] = {
		continent = Kalimdor,
		paths = {
			[Z["Felwood"]] = true,
			[Z["Winterspring"]] = true,
		},
		yards = 2308.253559286662,
		x_offset = 18447.22668103606,
		y_offset = 4308.084192710569,
		fishing_min = 205,
		texture = "Moonglade",
	}

	zones[Z["Orgrimmar"]] = {
		continent = Kalimdor,
		instances = Z["Ragefire Chasm"],
		paths = {
			[Z["Durotar"]] = true,
			[Z["Ragefire Chasm"]] = true,
			[Z["Hall of Legends"]] = true,
		},
		faction = "Horde",
		type = "City",
		yards = 1402.563051365538,
		x_offset = 20746.49533101771,
		y_offset = 10525.68532631853,
		fishing_min = 1,
		texture = "Ogrimmar",
	}
	
	zones[Z["Hall of Legends"]] = {
		continent = Kalimdor,
		paths = Z["Orgrimmar"],
		faction = "Horde",
	}
	
	zones[Z["The Exodar"]] = {
		continent = Kalimdor,
		paths = Z["Azuremyst Isle"],
		faction = "Alliance",
		type = "City",
		yards = 1056.732317707213,
		x_offset = 10532.61275516805,
		y_offset = 6276.045028807911,
		fishing_min = 1,
		texture = "TheExodar",
	}

	zones[Z["Thunder Bluff"]] = {
		continent = Kalimdor,
		paths = Z["Mulgore"],
		faction = "Horde",
		type = "City",
		yards = 1043.762849319158,
		x_offset = 16549.32009877855,
		y_offset = 13649.45129927044,
		texture = "ThunderBluff",
	}
	
	zones[Z["Azuremyst Isle"]] = {
		low = 1,
		high = 10,
		continent = Kalimdor,
		paths = {
			[Z["The Exodar"]] = true,
			[Z["Bloodmyst Isle"]] = true,
			[AUBERDINE_AZUREMYST_BOAT] = true,
		},
		faction = "Alliance",
		yards = 4070.691916244019,
		x_offset = 9966.264785353642,
		y_offset = 5460.139378090237,
		fishing_min = 20,
		texture = "AzuremystIsle",
	}

	zones[Z["Durotar"]] = {
		low = 1,
		high = 10,
		continent = Kalimdor,
		instances = Z["Ragefire Chasm"],
		paths = {
			[ORGRIMMAR_UNDERCITY_ZEPPELIN] = true,
			[ORGRIMMAR_GROMGOL_ZEPPELIN] = true,
			[Z["The Barrens"]] = true,
			[Z["Orgrimmar"]] = true,
		},
		faction = "Horde",
		yards = 5287.285801274457,
		x_offset = 19028.47465485265,
		y_offset = 10991.20642822035,
		fishing_min = 1,
		texture = "Durotar",
	}

	zones[Z["Mulgore"]] = {
		low = 1,
		high = 10,
		continent = Kalimdor,
		paths = {
			[Z["Thunder Bluff"]] = true,
			[Z["The Barrens"]] = true,
		},
		faction = "Horde",
		yards = 5137.32138887616,
		x_offset = 15018.17633401988,
		y_offset = 13072.38917227894,
		fishing_min = 1,
		texture = "Mulgore",
	}

	zones[Z["Teldrassil"]] = {
		low = 1,
		high = 10,
		continent = Kalimdor,
		paths = Z["Darnassus"],
		faction = "Alliance",
		yards = 5091.467863261982,
		x_offset = 13251.58449896318,
		y_offset = 968.6223632831094,
		fishing_min = 1,
		texture = "Teldrassil",
	}
	
	zones[Z["Bloodmyst Isle"]] = {
		low = 10,
		high = 20,
		continent = Kalimdor,
		paths = {
			[Z["Azuremyst Isle"]] = true,
		},
		faction = "Alliance",
		yards = 3262.385067990556,
		x_offset = 9541.280691875327,
		y_offset = 3424.790637352245,
		fishing_min = 1,
		texture = "BloodmystIsle",
	}

	zones[Z["Darkshore"]] = {
		low = 10,
		high = 20,
		continent = Kalimdor,
		paths = {
			[MENETHIL_AUBERDINE_BOAT] = true,
			[AUBERDINE_DARNASSUS_BOAT] = true,
			[AUBERDINE_AZUREMYST_BOAT] = true,
			[Z["Ashenvale"]] = true,
		},
		faction = "Alliance",
		yards = 6549.780280774227,
		x_offset = 14124.4534386827,
		y_offset = 4466.419105960455,
		fishing_min = 20,
		texture = "Darkshore",
	}

	zones[Z["The Barrens"]] = {
		low = 10,
		high = 25,
		continent = Kalimdor,
		instances = {
			[Z["Razorfen Kraul"]] = true,
			[Z["Wailing Caverns"]] = true,
			[Z["Razorfen Downs"]] = true,
			[Z["Warsong Gulch"]] = isHorde and true or nil,
		},
		paths = {
			[Z["Thousand Needles"]] = true,
			[Z["Razorfen Kraul"]] = true,
			[Z["Ashenvale"]] = true,
			[Z["Durotar"]] = true,
			[Z["Wailing Caverns"]] = true,
			[BOOTYBAY_RATCHET_BOAT] = true,
			[Z["Dustwallow Marsh"]] = true,
			[Z["Razorfen Downs"]] = true,
			[Z["Stonetalon Mountains"]] = true,
			[Z["Mulgore"]] = true,
			[Z["Warsong Gulch"]] = isHorde and true or nil,
		},
		faction = "Horde",
		yards = 10132.98626357964,
		x_offset = 14443.19633043607,
		y_offset = 11187.03406016663,
		fishing_min = 20,
		texture = "Barrens",
	}

	zones[Z["Stonetalon Mountains"]] = {
		low = 15,
		high = 27,
		continent = Kalimdor,
		paths = {
			[Z["Desolace"]] = true,
			[Z["The Barrens"]] = true,
			[Z["Ashenvale"]] = true,
		},
		yards = 4883.173287670144,
		x_offset = 13820.29750397374,
		y_offset = 9882.909063258192,
		fishing_min = 55,
		texture = "StonetalonMountains",
	}

	zones[Z["Ashenvale"]] = {
		low = 18,
		high = 30,
		continent = Kalimdor,
		instances = {
			[Z["Blackfathom Deeps"]] = true,
			[Z["Warsong Gulch"]] = not isHorde and true or nil,
		},
		paths = {
			[Z["Azshara"]] = true,
			[Z["The Barrens"]] = true,
			[Z["Blackfathom Deeps"]] = true,
			[Z["Warsong Gulch"]] = not isHorde and true or nil,
			[Z["Felwood"]] = true,
			[Z["Darkshore"]] = true,
			[Z["Stonetalon Mountains"]] = true,
		},
		yards = 5766.471113365881,
		x_offset = 15366.08027406009,
		y_offset = 8126.716152815561,
		fishing_min = 55,
		texture = "Ashenvale",
	}

	zones[Z["Thousand Needles"]] = {
		low = 25,
		high = 35,
		continent = Kalimdor,
		paths = {
			[Z["Feralas"]] = true,
			[Z["The Barrens"]] = true,
			[Z["Tanaris"]] = true,
		},
		yards = 4399.86408093722,
		x_offset = 17499.32929341832,
		y_offset = 16766.0151133423,
		fishing_min = 130,
		texture = "ThousandNeedles",
	}

	zones[Z["Desolace"]] = {
		low = 30,
		high = 40,
		continent = Kalimdor,
		instances = Z["Maraudon"],
		paths = {
			[Z["Feralas"]] = true,
			[Z["Stonetalon Mountains"]] = true,
			[Z["Maraudon"]] = true,
		},
		yards = 4495.726850591814,
		x_offset = 12832.80723200791,
		y_offset = 12347.420176847,
		fishing_min = 130,
		texture = "Desolace",
	}

	zones[Z["Dustwallow Marsh"]] = {
		low = 35,
		high = 45,
		continent = Kalimdor,
		instances = Z["Onyxia's Lair"],
		paths = {
			[Z["Onyxia's Lair"]] = true,
			[Z["The Barrens"]] = true,
			[MENETHIL_THERAMORE_BOAT] = true,
		},
		yards = 5249.824712249077,
		x_offset = 18040.98829886713,
		y_offset = 14832.74650226312,
		fishing_min = 130,
		texture = "Dustwallow",
	}

	zones[Z["Feralas"]] = {
		low = 40,
		high = 50,
		continent = Kalimdor,
		instances = Z["Dire Maul"],
		paths = {
			[Z["Thousand Needles"]] = true,
			[Z["Desolace"]] = true,
			[Z["Dire Maul"]] = true,
		},
		yards = 6949.760203962193,
		x_offset = 11624.54217828119,
		y_offset = 15166.06954533647,
		fishing_min = 205,
		texture = "Feralas",
	}
	
	zones[Z["Tanaris"]] = {
		low = 40,
		high = 50,
		continent = Kalimdor,
		instances = {
			[Z["Zul'Farrak"]] = true,
			[Z["Old Hillsbrad Foothills"]] = true,
			[Z["The Black Morass"]] = true,
			[Z["The Battle of Mount Hyjal"]] = true, -- check
		},
		paths = {
			[Z["Thousand Needles"]] = true,
			[Z["Un'Goro Crater"]] = true,
			[Z["Zul'Farrak"]] = true,
			[Z["Caverns of Time"]] = true,
		},
		yards = 6899.765399158026,
		x_offset = 17284.7655865671,
		y_offset = 18674.28905369955,
		fishing_min = 205,
		texture = "Tanaris",
	}

	zones[Z["Azshara"]] = {
		low = 45,
		high = 55,
		continent = Kalimdor,
		paths = Z["Ashenvale"],
		yards = 5070.669448432522,
		x_offset = 20342.99178351035,
		y_offset = 7457.974565554941,
		fishing_min = 205,
		texture = "Aszhara",
	}

	zones[Z["Felwood"]] = {
		low = 48,
		high = 55,
		continent = Kalimdor,
		paths = {
			[Z["Winterspring"]] = true,
			[Z["Moonglade"]] = true,
			[Z["Ashenvale"]] = true,
		},
		yards = 5749.8046476606,
		x_offset = 15424.4116748014,
		y_offset = 5666.381311442202,
		fishing_min = 205,
		texture = "Felwood",
	}

	zones[Z["Un'Goro Crater"]] = {
		low = 48,
		high = 55,
		continent = Kalimdor,
		paths = {
			[Z["Silithus"]] = true,
			[Z["Tanaris"]] = true,
		},
		yards = 3699.872808671186,
		x_offset = 16532.70803775362,
		y_offset = 18765.95157787033,
		fishing_min = 205,
		texture = "UngoroCrater",
	}

	zones[Z["Silithus"]] = {
		low = 55,
		high = 60,
		continent = Kalimdor,
		instances = {
			[Z["Ahn'Qiraj"]] = true,
			[Z["Ruins of Ahn'Qiraj"]] = true,
		},
		paths = {
			[Z["Ruins of Ahn'Qiraj"]] = true,
			[Z["Un'Goro Crater"]] = true,
			[Z["Ahn'Qiraj"]] = true,
		},
		yards = 3483.224287356748,
		x_offset = 14528.60591761034,
		y_offset = 18757.61998086822,
        type = "PvP Zone",
		fishing_min = 330,
		texture = "Silithus",
	}

	zones[Z["Winterspring"]] = {
		low = 55,
		high = 60,
		continent = Kalimdor,
		paths = {
			[Z["Felwood"]] = true,
			[Z["Moonglade"]] = true,
		},
		yards = 7099.756078049357,
		x_offset = 17382.67868933954,
		y_offset = 4266.421320915686,
		fishing_min = 330,
		texture = "Winterspring",
	}

	zones[Z["Ragefire Chasm"]] = {
		low = 13,
		high = isWestern and 18 or 15,
		continent = Kalimdor,
		paths = Z["Orgrimmar"],
		groupSize = 5,
		faction = "Horde",
		type = "Instance",
	}

	zones[Z["Wailing Caverns"]] = {
		low = isWestern and 17 or 15,
		high = isWestern and 24 or 21,
		continent = Kalimdor,
		paths = Z["The Barrens"],
		groupSize = 5,
		faction = "Horde",
		type = "Instance",
		fishing_min = 20,
	}

	zones[Z["Blackfathom Deeps"]] = {
		low = isWestern and 24 or 20,
		high = isWestern and 32 or 27,
		continent = Kalimdor,
		paths = Z["Ashenvale"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 20,
	}

	zones[Z["Razorfen Kraul"]] = {
		low = isWestern and 29 or 25,
		high = isWestern and 38 or 35,
		continent = Kalimdor,
		paths = Z["The Barrens"],
		groupSize = 5,
		type = "Instance",
	}

	zones[Z["Razorfen Downs"]] = {
		low = isWestern and 37 or 35,
		high = isWestern and 46 or 40,
		continent = Kalimdor,
		paths = Z["The Barrens"],
		groupSize = 5,
		type = "Instance",
	}

	zones[Z["Zul'Farrak"]] = {
		low = isWestern and 44 or 43,
		high = isWestern and 54 or 47,
		continent = Kalimdor,
		paths = Z["Tanaris"],
		groupSize = 5,
		type = "Instance",
	}

	zones[Z["Maraudon"]] = {
		low = isWestern and 46 or 40,
		high = isWestern and 55 or 49,
		continent = Kalimdor,
		paths = Z["Desolace"],
		groupSize = 5,
		type = "Instance",
		fishing_min = 205,
	}

	zones[Z["Dire Maul"]] = {
		low = 56,
		high = 60,
		continent = Kalimdor,
		paths = Z["Feralas"],
		groupSize = 5,
		type = "Instance",
	}

	zones[Z["Onyxia's Lair"]] = {
		low = 60,
		high = 62,
		continent = Kalimdor,
		paths = Z["Dustwallow Marsh"],
		groupSize = 40,
		type = "Instance",
	}

	zones[Z["Ahn'Qiraj"]] = {
		low = 60,
		high = 65,
		continent = Kalimdor,
		paths = Z["Silithus"],
		groupSize = 40,
		type = "Instance",
	}

	zones[Z["Ruins of Ahn'Qiraj"]] = {
		low = 60,
		high = 65,
		continent = Kalimdor,
		paths = Z["Silithus"],
		groupSize = 20,
		type = "Instance",
	}
	
	zones[Z["Caverns of Time"]] = {
		continent = Kalimdor,
		instances = {
			[Z["Old Hillsbrad Foothills"]] = true,
			[Z["The Black Morass"]] = true,
			[Z["The Battle of Mount Hyjal"]] = true,
		},
		paths = {
			[Z["Tanaris"]] = true,
			[Z["Old Hillsbrad Foothills"]] = true,
			[Z["The Black Morass"]] = true,
			[Z["The Battle of Mount Hyjal"]] = true,
		},
	}
	
	zones[Z["Old Hillsbrad Foothills"]] = {
		low = 66,
		high = 68,
		continent = Kalimdor,
		paths = Z["Tanaris"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Caverns of Time"]
	}
	
	zones[Z["The Black Morass"]] = {
		low = 67,
		high = 72,
		continent = Kalimdor,
		paths = Z["Tanaris"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Caverns of Time"]
	}
	
	-- check once implemented
	zones[Z["The Battle of Mount Hyjal"]] = {
		low = 70,
		high = 72,
		continent = Kalimdor,
		paths = Z["Tanaris"],
		groupSize = 25,
		type = "Instance",
		complex = Z["Caverns of Time"]
	}
	
	zones[Z["Shattrath City"]] = {
		continent = Outland,
		paths = {
			[SHATTRATH_THUNDERBLUFF_PORTAL] = true,
			[SHATTRATH_STORMWIND_PORTAL] = true,
			[SHATTRATH_UNDERCITY_PORTAL] = true,
			[Z["Terokkar Forest"]] = true,
			[SHATTRATH_SILVERMOON_PORTAL] = true,
			[SHATTRATH_EXODAR_PORTAL] = true,
			[SHATTRATH_DARNASSUS_PORTAL] = true,
			[SHATTRATH_ORGRIMMAR_PORTAL] = true,
			[SHATTRATH_IRONFORGE_PORTAL] = true,
			[Z["Nagrand"]] = true,
		},
		type = "City",
		yards = 1306.210386847456,
		x_offset = 6860.565394341991,
		y_offset = 7295.086145447915,
		texture = "ShattrathCity",
	}
	
	zones[Z["Hellfire Citadel"]] = {
		continent = Outland,
		instances = {
			[Z["The Blood Furnace"]] = true,
			[Z["Hellfire Ramparts"]] = true,
			[Z["Magtheridon's Lair"]] = true,
			[Z["The Shattered Halls"]] = true,
		},
		paths = {
			[Z["Hellfire Peninsula"]] = true,
			[Z["The Blood Furnace"]] = true,
			[Z["Hellfire Ramparts"]] = true,
			[Z["Magtheridon's Lair"]] = true,
			[Z["The Shattered Halls"]] = true,
		},
	}
	
	zones[Z["Hellfire Peninsula"]] = {
		low = 58,
		high = 63,
		continent = Outland,
		instances = {
			[Z["The Blood Furnace"]] = true,
			[Z["Hellfire Ramparts"]] = true,
			[Z["Magtheridon's Lair"]] = true,
			[Z["The Shattered Halls"]] = true,
		},
		paths = {
			[Z["Zangarmarsh"]] = true,
			[Z["The Dark Portal"]] = true,
			[Z["Terokkar Forest"]] = true,
			[Z["Hellfire Citadel"]] = true,
		},
		yards = 5164.421615455519,
		x_offset = 7456.223236253186,
		y_offset = 4339.973528794677,
        type = "PvP Zone",
		texture = "Hellfire",
	}
	
	zones[Z["Coilfang Reservoir"]] = {
		continent = Outland,
		instances = {
			[Z["The Underbog"]] = true,
			[Z["Serpentshrine Cavern"]] = true,
			[Z["The Steamvault"]] = true,
			[Z["The Slave Pens"]] = true,
		},
		paths = {
			[Z["Zangarmarsh"]] = true,
			[Z["The Underbog"]] = true,
			[Z["Serpentshrine Cavern"]] = true,
			[Z["The Steamvault"]] = true,
			[Z["The Slave Pens"]] = true,
		},
	}
	
	zones[Z["Zangarmarsh"]] = {
		low = 60,
		high = 64,
		continent = Outland,
		instances = {
			[Z["The Underbog"]] = true,
			[Z["Serpentshrine Cavern"]] = true,
			[Z["The Steamvault"]] = true,
			[Z["The Slave Pens"]] = true,
		},
		paths = {
			[Z["Coilfang Reservoir"]] = true,
			[Z["Blade's Edge Mountains"]] = true,
			[Z["Terokkar Forest"]] = true,
			[Z["Nagrand"]] = true,
			[Z["Hellfire Peninsula"]] = true,
		},
		yards = 5026.925554043871,
		x_offset = 3520.930685571132,
		y_offset = 3885.821388791224,
        type = "PvP Zone",
		fishing_min = 305,
		texture = "Zangarmarsh",
	}

	zones[Z["Ring of Observance"]] = {
		continent = Outland,
		instances = {
			[Z["Mana-Tombs"]] = true,
			[Z["Sethekk Halls"]] = true,
			[Z["Shadow Labyrinth"]] = true,
			[Z["Auchenai Crypts"]] = true,
		},
		paths = {
			[Z["Terokkar Forest"]] = true,
			[Z["Mana-Tombs"]] = true,
			[Z["Sethekk Halls"]] = true,
			[Z["Shadow Labyrinth"]] = true,
			[Z["Auchenai Crypts"]] = true,
		},
	}

	zones[Z["Terokkar Forest"]] = {
		low = 62,
		high = 65,
		continent = Outland,
		instances = {
			[Z["Mana-Tombs"]] = true,
			[Z["Sethekk Halls"]] = true,
			[Z["Shadow Labyrinth"]] = true,
			[Z["Auchenai Crypts"]] = true,
		},
		paths = {
			[Z["Ring of Observance"]] = true,
			[Z["Shadowmoon Valley"]] = true,
			[Z["Zangarmarsh"]] = true,
			[Z["Shattrath City"]] = true,
			[Z["Hellfire Peninsula"]] = true,
			[Z["Nagrand"]] = true,
		},
		yards = 5399.832305361811,
		x_offset = 5912.521284664757,
		y_offset = 6821.146112637057,
        type = "PvP Zone",
		fishing_min = 355,
		texture = "TerokkarForest",
	}

	zones[Z["Nagrand"]] = {
		low = 64,
		high = 67,
		continent = Outland,
		paths = {
			[Z["Zangarmarsh"]] = true,
			[Z["Shattrath City"]] = true,
			[Z["Terokkar Forest"]] = true,
		},
		yards = 5524.827295176373,
		x_offset = 2700.121400200201,
		y_offset = 5779.512212073806,
        type = "PvP Zone",
		fishing_min = 380,
		texture = "Nagrand",
	}

	zones[Z["Blade's Edge Mountains"]] = {
		low = 65,
		high = 68,
		continent = Outland,
		instances = Z["Gruul's Lair"],
		paths = {
			[Z["Netherstorm"]] = true,
			[Z["Zangarmarsh"]] = true,
		},
		yards = 5424.84803598309,
		x_offset = 4150.068157139826,
		y_offset = 1412.982266241851,
		texture = "BladesEdgeMountains",
	}
	
	zones[Z["Tempest Keep"]] = {
		continent = Outland,
		instances = {
			[Z["The Mechanar"]] = true,
			[Z["The Eye"]] = true,
			[Z["The Botanica"]] = true,
			[Z["The Arcatraz"]] = true,
		},
		paths = {
			[Z["Netherstorm"]] = true,
			[Z["The Mechanar"]] = true,
			[Z["The Eye"]] = true,
			[Z["The Botanica"]] = true,
			[Z["The Arcatraz"]] = true,
		},
	}
	
	zones[Z["Netherstorm"]] = {
		low = 67,
		high = 70,
		continent = Outland,
		instances = {
			[Z["The Mechanar"]] = true,
			[Z["The Botanica"]] = true,
			[Z["The Arcatraz"]] = true,
			[Z["The Eye"]] = true,
		},
		paths = {
			[Z["Tempest Keep"]] = true,
			[Z["Blade's Edge Mountains"]] = true,
		},
		yards = 5574.82788866266,
		x_offset = 7512.470386633603,
		y_offset = 365.0992858464317,
		fishing_min = 380,
		texture = "Netherstorm",
	}

	zones[Z["Shadowmoon Valley"]] = {
		low = 67,
		high = 70,
		continent = Outland,
		instances = Z["Black Temple"],
		paths = Z["Terokkar Forest"],
		yards = 5499.827432644566,
		x_offset = 8770.765422136874,
		y_offset = 7769.034259125071,
		texture = "ShadowmoonValley",
	}
	
	zones[Z["Black Temple"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		paths = Z["Shadowmoon Valley"],
		groupSize = 25,
		type = "Instance",
	}
	
	zones[Z["Auchenai Crypts"]] = {
		low = 64,
		high = 66,
		continent = Outland,
		paths = Z["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Auchindoun"],
	}
	
	zones[Z["Auchenai Crypts"]] = {
		low = 65,
		high = 67,
		continent = Outland,
		paths = Z["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Auchindoun"],
	}
	
	zones[Z["Shadow Labyrinth"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = Z["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Auchindoun"],
	}
	
	zones[Z["Sethekk Halls"]] = {
		low = 67,
		high = 69,
		continent = Outland,
		paths = Z["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Auchindoun"],
	}
	
	zones[Z["Mana-Tombs"]] = {
		low = 64,
		high = 66,
		continent = Outland,
		paths = Z["Ring of Observance"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Auchindoun"],
	}
	
	zones[Z["Hellfire Ramparts"]] = {
		low = 60,
		high = 62,
		continent = Outland,
		paths = Z["Hellfire Citadel"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Hellfire Citadel"],
	}
	
	zones[Z["The Blood Furnace"]] = {
		low = 61,
		high = 63,
		continent = Outland,
		paths = Z["Hellfire Citadel"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Hellfire Citadel"],
	}
	
	zones[Z["The Shattered Halls"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = Z["Hellfire Citadel"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Hellfire Citadel"],
	}
	
	zones[Z["Magtheridon's Lair"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		paths = Z["Hellfire Citadel"],
		groupSize = 25,
		type = "Instance",
		complex = Z["Hellfire Citadel"],
	}
	
	zones[Z["The Slave Pens"]] = {
		low = 62,
		high = 64,
		continent = Outland,
		paths = Z["Coilfang Reservoir"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Coilfang Reservoir"],
	}
	
	zones[Z["The Underbog"]] = {
		low = 63,
		high = 65,
		continent = Outland,
		paths = Z["Coilfang Reservoir"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Coilfang Reservoir"],
	}
	
	zones[Z["The Steamvault"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = Z["Coilfang Reservoir"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Coilfang Reservoir"],
	}
	
	zones[Z["Serpentshrine Cavern"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		paths = Z["Coilfang Reservoir"],
		groupSize = 25,
		type = "Instance",
		complex = Z["Coilfang Reservoir"],
	}
	
	zones[Z["Gruul's Lair"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		paths = Z["Blade's Edge Mountains"],
		groupSize = 25,
		type = "Instance",
	}
	
	zones[Z["The Mechanar"]] = {
		low = 69,
		high = 72,
		continent = Outland,
		paths = Z["Tempest Keep"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Tempest Keep"],
	}
	
	zones[Z["The Botanica"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = Z["Tempest Keep"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Tempest Keep"],
	}
	
	zones[Z["The Arcatraz"]] = {
		low = 70,
		high = 72,
		continent = Outland,
		paths = Z["Tempest Keep"],
		groupSize = 5,
		type = "Instance",
		complex = Z["Tempest Keep"],
	}

	zones[Z["The Eye"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		paths = Z["Tempest Keep"],
		groupSize = 25,
		type = "Instance",
		complex = Z["Tempest Keep"],
	}

	zones[Z["Eye of the Storm"]] = {
		low = 61,
		high = 70,
		continent = Outland,
		groupSize = 25,
		type = "Battleground",
		texture = "NetherstormArena",
	}
 
	-- arenas
	zones[Z["Blade's Edge Arena"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		type = "Arena",
	}

	zones[Z["Nagrand Arena"]] = {
		low = 70,
		high = 70,
		continent = Outland,
		type = "Arena",
	}


	for k,v in pairs(zones) do
		lows[k] = v.low or 0
		highs[k] = v.high or 0
		continents[k] = v.continent or UNKNOWN
		instances[k] = v.instances
		paths[k] = v.paths or false
		types[k] = v.type or "Zone"
		groupSizes[k] = v.groupSize
		factions[k] = v.faction
		yardWidths[k] = v.yards
		yardHeights[k] = v.yards and v.yards * 2/3 or nil
		yardXOffsets[k] = v.x_offset
		yardYOffsets[k] = v.y_offset
		fishing[k] = v.fishing_min
		textures[k] = v.texture
		complexes[k] = v.complex
		if v.texture then
			textures_rev[v.texture] = k
		end
	end
	zones = nil
	
	PLAYER_LEVEL_UP(self)
	
	if oldDeactivate then
		oldDeactivate(oldLib)
	end
end

local function external(self, major, instance)
	if major == "AceConsole-2.0" then
		local print = print
		if DEFAULT_CHAT_FRAME then
			function print(text)
				DEFAULT_CHAT_FRAME:AddMessage(text)
			end
		end
		local t = {
			name = MAJOR_VERSION .. "." .. string.gsub(MINOR_VERSION, ".-(%d+).*", "%1"),
			desc = "A library to provide information about zones and instances.",
			type = "group",
			args = {
				zone = {
					name = "Zone",
					desc = "Get information about a zone",
					type = "text",
					usage = "<zone name>",
					get = false,
					set = function(text)
						local type
						if self:IsBattleground(text) then
							type = "Battleground"
						elseif self:IsInstance(text) then
							type = "Instance"
                        elseif self:IsPvPZone(text) then
                            type = "PvP Zone"
						else
							type = "Zone"
						end
						local faction
						if self:IsAlliance(text) then
							faction = "Alliance"
						elseif self:IsHorde(text) then
							faction = "Horde"
						else
							faction = "Contested"
						end
						if self:IsHostile(text) then
							faction = faction .. " (hostile)"
						elseif self:IsFriendly(text) then
							faction = faction .. " (friendly)"
						end
						local low, high = self:GetLevel(text)
						print("|cffffff7f" .. text .. "|r")
						print("  |cffffff7fType: [|r" .. type .. "|cffffff7f]|r")
						print("  |cffffff7fFaction: [|r" .. faction .. "|cffffff7f]|r")
						if low > 0 and high > 0 then
							if low == high then
								print("  |cffffff7fLevel: [|r" .. low .. "|cffffff7f]|r")
							else
								print("  |cffffff7fLevels: [|r" .. low .. "-" .. high .. "|cffffff7f]|r")
							end
						end
						print("  |cffffff7fContinent: [|r" .. self:GetContinent(text) .. "|cffffff7f]|r")
						local groupSize = self:GetInstanceGroupSize(text)
						if groupSize > 0 then
							print("  |cffffff7fGroup size: [|r" .. groupSize .. "|cffffff7f]|r")
						end
						if self:DoesZoneHaveInstances(text) then
							print("  |cffffff7fInstances:|r")
							for instance in self:IterateZoneInstances(text) do
								local isBG = self:IsBattleground(instance) and " (BG)" or ""
								local low, high = self:GetLevel(instance)
								local faction = ""
								if self:IsAlliance(instance) then
									faction = " - Alliance"
								elseif self:IsHorde(instance) then
									faction = " - Horde"
								end
								if self:IsHostile(instance) then
									faction = faction .. " (hostile)"
								elseif self:IsFriendly(instance) then
									faction = faction .. " (friendly)"
								end
								print("    " .. instance .. isBG .. " - " .. low .. "-" .. high .. faction)
							end
						end
					end,
					validate = {}
				},
				path = {
					name = "Shortest path to destination",
					desc = "Prints the fastest route from your current location to the destination.",
					type = "text",
					get = false,
					set = function(destination)
						if not Z:HasTranslation(destination) or not Z:HasReverseTranslation(destination) then return end
						local current = GetRealZoneText()
						print(string.format("|cffffff7fPath from %s to %s:|r", current, destination))
						for zone in self:IteratePath(current, destination) do
							local text
							if self:IsHostile(zone) then
								text = "    |cffff0000" .. zone .. "|r"
							elseif self:IsFriendly(zone) then
								text = "    |cff00ff00" .. zone .. "|r"
							else
								text = "    |cffffff00" .. zone .. "|r"
							end
							
							local low, high = self:GetLevel(zone)
							if low > 0 then
								local r, g, b = self:GetLevelColor(zone)
								if low == high then
									text = text .. string.format(" (|cff%02x%02x%02x%d|r)", r * 255, g * 255, b * 255, low)
								else
									text = text .. string.format(" (|cff%02x%02x%02x%d-%d|r)", r * 255, g * 255, b * 255, low, high)
								end
							end
							
							if zone == destination then
								print(text)
							else
								print(text .. " ->")
							end
						end
					end
				},
				recommend = {
					name = "Recommended Zones",
					desc = "List recommended zones",
					type = "execute",
					func = function()
						print("|cffffff7fRecommended zones:|r")
						for zone in self:IterateRecommendedZones() do
							local low, high = self:GetLevel(zone)
							local faction = ""
							if self:IsAlliance(zone) then
								faction = " - Alliance"
							elseif self:IsHorde(zone) then
								faction = " - Horde"
							end
							if self:IsHostile(zone) then
								faction = faction .. " (hostile)"
							elseif self:IsFriendly(zone) then
								faction = faction .. " (friendly)"
							end
							print("  |cffffff7f" .. zone .. "|r - " .. low .. "-" .. high .. faction)
						end
						if self:HasRecommendedInstances() then
							print("|cffffff7fRecommended instances:|r")
							for instance in self:IterateRecommendedInstances() do
								local isBG = self:IsBattleground(instance) and " (BG)" or ""
								local low, high = self:GetLevel(instance)
								local faction = ""
								if self:IsAlliance(instance) then
									faction = " - Alliance"
								elseif self:IsHorde(instance) then
									faction = " - Horde"
								end
								if self:IsHostile(instance) then
									faction = faction .. " (hostile)"
								elseif self:IsFriendly(instance) then
									faction = faction .. " (friendly)"
								end
								print("  |cffffff7f" .. instance .. "|r" .. isBG .. " - " .. low .. "-" .. high .. faction)
							end
						end
					end
				}
			}
		}
		for zone in self:IterateZonesAndInstances() do
			t.args.zone.validate[zone] = zone
		end
		t.args.path.validate = t.args.zone.validate
		instance.RegisterChatCommand(self, { "/tourist", "/touristLib" }, t, "TOURIST")
	end
end

AceLibrary:Register(Tourist, MAJOR_VERSION, MINOR_VERSION, activate, nil, external)
