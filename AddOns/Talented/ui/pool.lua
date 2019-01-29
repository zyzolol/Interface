local rawget = rawget
local rawset = rawset
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs

local Pool = {
	pools = {},
	methods = {
		next = true,
		push = true,
	}
}

function Pool:new()
	local pool = setmetatable({ pool = {}, count = 0 }, self)
	self.pools[pool] = true
	return pool
end

function Pool:ResetAll()
	for pool in pairs(self.pools) do
		rawset(pool, "count", 0)
		for _, widget in ipairs(pool.pool) do
			widget:Hide()
		end
	end
end

function Pool.next(pool)
	local index = pool.count + 1
	local res = pool.pool[index]
	if res then
		pool.count = index
		res:Show()
		return res
	end
end

function Pool.push(pool, value)
	local t = pool.pool
	t[#t + 1] = value
	pool.count = #t
end

function Pool.__index(pool, value)
	-- Talented:Print("__index %s %s %s", tostring(self), tostring(pool), tostring(value))
	if Pool.methods[value] then
		return rawget(Pool, value)
	end
end

Talented.Pool = Pool
