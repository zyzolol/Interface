--[[
	LibRecycle.lua
	A table recycling embeddable library.
	Released into the Public Domain without warranty. Use at your own peril!
	Credits: Norganna, MentalPower, Esamynn.


	Usage:
		local LibRecycle = LibStub("LibRecycle")
		-- then:
		local acquire, recycle, clone, scrub = LibRecycle.All()
		-- or:
		local acquire = LibRecycle.Acquire
		local recycle = LibRecycle.Recycle
		local clone = LibRecycle.Clone
		local scrub = LibRecycle.Scrub

	Functions:
		acquire( one, two, three, ...); Returns { one, two, three, ... }
		recycle( item ); Recycles the table "item" and all subtables. Clears all keys.
		recycle( table, key, key, ...); Recycles given keys in the table. Also clears their entries.
		clone( item, [unsafe] ); Returns a safe-cloned copy of the table (unless unsafe is true.)
		scrub( item ); Cleans the given table, recycling if necessary. Returns an empty table.
	
	
	unit test for reuse of table
		local foobarTable = {}
		foobarTable.test1 = "test1"
		recycle(foobarTable)
		foobarTable.test2 = "test2"

	unit test for recycling a table twice
		local foobarTable = {}
		foobarTable.test1 = "test1"
		recycle(foobarTable)
		recycle(foobarTable)

]]

local LIBRARY_VERSION_MAJOR = "LibRecycle"
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


-- Global to the library so we can change the value at runtime
-- NOTE - turning this option on will slow things down (maybe quite a bit)
--        but it can help identify who recycled a table incorrectly
-- NOTE - ccox - this is off by default
lib.SaveStackCrawlDebugInfo = false;


-- Create the recylebin (if it doesn't exist)
if not lib.recyclebin then lib.recyclebin = {} end
if not lib.recursion then lib.recursion = {} end
if not lib.safety then
	-- index and newindex both have the table as the first argument
	local function safety(t)
		-- here we can access the table without error, because we're in the meta handler
		if (lib.safety.__metatable and lib.SaveStackCrawlDebugInfo and t.RecycleStackCrawl) then
			assert(not lib.safety.__metatable, "LibRecycle: An AddOn tried to use a recycled table!\nOriginally recycled by:\n"..t.RecycleStackCrawl.."Just now used by (see next stacktrace):")
		else
			assert(not lib.safety.__metatable, "LibRecycle: An AddOn tried to use a recycled table!")
		end
	end
	lib.safety = {
		__index = safety,
		__newindex = safety,
		__metatable = "safety"
	}
end

-- Store the following variables/functions locally to save on lookups.
local tremove = table.remove
local tinsert = table.insert
local recyclebin = lib.recyclebin
local recursion = lib.recursion
local safety = lib.safety

-- Define a local function so we can do the nested subcalls without lookups.
local function recycler(level, ...)
	local tbl, key, item
	-- Get the passed parameter/s
	local n = select("#", ...)
	if n <= 0 then
		return
	elseif n == 1 then
		item = ...
		tbl, key = nil, nil
	elseif n == 2 then
		tbl, key = ...
		item = tbl[key]
	else
		tbl = ...
		for i=2, n do
			key = select(i, ...)
			recycler(level+1, tbl, key)
		end
		return
	end

	-- We can only clean tables
	if type(item) ~= 'table' then
		if tbl and key then
			tbl[key] = nil
		end
		return
	end

	-- If this is the first level, clear out the recursion list
	if level == 1 then
		for k,v in pairs(recursion) do
			recursion[k] = nil
		end
	end

	-- Detect if we have already recursed down this table before
	if recursion[item] then
		-- We may be recursing, but no need to leave a mess
		if tbl and key then
			-- Clean out the caller's entry
			tbl[key] = nil
		end
		return
	end

	-- Flag this item as being processed
	recursion[item] = true

	-- Clean out any values from this table
	for k,v in pairs(item) do
		if type(v) == 'table' and (not v[0] or type(v[0]) ~= 'userdata') then
			-- Recycle this table too
			recycler(level+1, item, k)
		else
			item[k] = nil
		end
	end

	-- Check to see if this table is already flagged as recycled
	local mt = getmetatable(item)
	assert(not mt or mt ~= "safety", "LibRecycle: Attempt to rerecycle a recycled table")
	-- NOTE - ccox - I'd love to get a stack crawl here as well, but it won't work
	
	-- Check to make sure this table is empty on the ground floor
	local unclean = 0
	for k,v in pairs(item) do
		-- Just nuke it and let the GC take care of it.
		unclean = unclean + 1
		item[k] = nil
	end
	assert(unclean==0, "LibRecycle: Unable to recycle given table adequately ("..unclean.."  items remain)")
	
	-- if we are debugging, grab a stack crawl for error reporting
	if (lib.SaveStackCrawlDebugInfo) then
		item.RecycleStackCrawl = debugstack(3, 20, 20)
	end
	
	-- set the metatable after we set a stack crawl and check for items still in the table
	setmetatable(item, safety)

	-- Place the husk of a table in the recycle bin
	tinsert(recyclebin, item)

	-- If we are to clean the input value
	if tbl and key then
		-- Clean out the original table entry too
		tbl[key] = nil
	end

	-- Unflag this item as being processed
	recursion[item] = nil
end

local function recycle(...)
	recycler(1, ...)
end
lib.Recycle = recycle

local function acquire(...)
	local item, v

	-- Get a recycled table or create a new one.
	if #recyclebin > 0 then
		item = tremove(recyclebin)
		safety.__metatable = nil
		setmetatable(item, nil)
		safety.__metatable = "safety"
		item.RecycleStackCrawl = nil
		for k,v in pairs(item) do
			assert(not(k or v), "LibRecycle: Attempted to issue a non-empty table")
		end
	end
	if not item then
		item = {}
	end

	-- And populate it if there's any args
	n = select("#", ...)
	for i = 1, n do
		v = select(i, ...)
		item[i] = v
	end
	return item
end
lib.Acquire = acquire

local function clone(source, unsafe  --[[ internal only: ]], depth, history)
	if type(source) ~= "table" then
		return source
	end

	if not depth then depth = 0 end
	if depth == 0 and not unsafe then
		history = acquire()
	end

	-- For all the values herein, perform a deep copy
	local dest = acquire()
	if history then history[source] = dest end
	for k, v in pairs(source) do
		if type(v) == "table" then
			if history then
				-- We are tracking the clone history.
				if history[v] then
					-- We have already cloned this table once, set a pointer to the previously
					-- cloned copy instead of recloning it.
					dest[k] = history[v]
				else
					-- Do a full clone of this node.
					dest[k] = clone(v, nil, depth+1, history)
				end
			else
				-- Do a full clone of this node.
				dest[k] = clone(v, nil, depth+1)
			end
		else
			dest[k] = v
		end
	end
	for k,v in pairs(history) do history[k] = nil end
	if history then recycle(history) end
	return dest
end
lib.Clone = clone

local function scrub(item)
	-- We can only clean tables
	if type(item) ~= 'table' then return end

	-- Clean out any values from this table
	for k,v in pairs(item) do
		if type(v) == 'table' then
			-- Recycle this table
			recycle(item, k)
		else
			item[k] = nil
		end
	end
end
lib.Scrub = scrub

function lib.All()
	return acquire, recycle, clone, scrub
end
