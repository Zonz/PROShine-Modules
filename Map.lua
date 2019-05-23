--[[					Map data wrapper - created by Zonz

This module wraps map data into fields to make code look nicer. It also provides a wrapper class for the map cells.
You can also write custom values to the map table, and it will save them on a per-map basis.
For instance, doing "map.seen = true" in Pallet Town will save that value, however it will only be readable while in Pallet Town.
You could then save the same variable while in a different map, and the 2 values will be independent of each other.


Map fields:
	map.name			-	getMapName()
	map.width			-	getMapWidth()
	map.height			-	getMapHeight()
	map.links			-	getMapLinks()
	map.npcs			-	getNpcData()
	map.cells			-	A 2D table containing map cell data
	map.battlers		-	getActiveBattlers()			-	Doesn't cache
	map.digSpots		-	getActiveDigSpots()			-	Doesn't cache
	map.headbuttTrees	-	getActiveHeadbuttTrees()	-	Doesn't cache
	map.berries			-	getActiveBerryTrees()		-	Doesn't cache
	map.items			-	getDiscoverableItems()		-	Doesn't cache
	

Cell fields:
	cell.x				-	Cell x coordinate
	cell.y				-	Cell y coordinate
	cell.type			-	getCellType(cell.x, cell.y)
	cell.walkable		-	Whether or not the cell can be walked (or surfed) on
	cell.neighbours		-	Directly adjacent cells that are walkable

Cell functions:
	cell:moveTo()		-	moveToCell(cell.x, cell.y)


Usage:

function onPathAction()
	if map.name == "Pallet Town" then
		-- do something
	elseif map.name == "Route 1" then
		-- etc.
	end
end

-- Standard iteration
for cell in pairs(map.cells) do
	log("Cell (" .. cell.x .. ", " .. cell.y .. ") " .. cell.type)
end

-- Numerical iteration
for x = 0, map.width do
	for y = 0, map.height do
		local cell = map.cells[x][y]
		log("Cell (" .. x .. ", " .. y .. ") " .. cell.type)
	end
end

#map.cells	-	The total number of all cells in the map

]]

local map = {}
local cachedMaps = {}

local callbacks
local metatables

local walkableTypes =
{
	["Link"] = true,
	["Grass"] = true,
	["Water"] = true,
	["Normal Ground"] = true,
	["Ice"] = true,
	["Tree"] = true,
	["Rock"] = true,
}

local function newCell(x, y)
	local cell = {}
	cell.x = x
	cell.y = y
	cell.type = getCellType(x, y)
	cell.walkable = walkableTypes[cell.type] or false
	cell.neighbours = {}	
	setmetatable(cell, metatables.cell)
	return cell
end

local cellFunctions = {}
function cellFunctions:moveTo()
	return moveToCell(self.x, self.y)
end

function cellFunctions:highlight()
	if highlightCell ~= nil then -- only Zonz has this. Sorry
		highlightCell(self.x, self.y)
	end
end

local function setNeighbours(cell, cellMap)
	
	local left
	local right
	local top
	local bottom
	
	local x, y = cell.x, cell.y
	
	if x > 0 then
		left = cellMap[x - 1][y]
		if left.walkable then
			table.insert(cell.neighbours, left)
		end
	end
	
	if x < map.width then
		right = cellMap[x + 1][y]
		if right.walkable then
			table.insert(cell.neighbours, right)
		end
	end
	
	if y > 0 then
		top = cellMap[x][y - 1]
		if top.walkable then
			table.insert(cell.neighbours, top)
		end
	end
	
	if y < map.height then
		bottom = cellMap[x][y + 1]
		if bottom.walkable then
			table.insert(cell.neighbours, bottom)
		end
	end
	
	if x > 1 and left.type == "Ledge West" then
		left = cellMap[x - 2][y]
		if left.walkable and left.type ~= "Water" then
			table.insert(cell.neighbours, left)
		end
	end
	
	if x < map.width - 1 and right.type == "Ledge East" then
		right = cellMap[x + 2][y]
		if right.walkable and right.type ~= "Water" then
			table.insert(cell.neighbours, right)
		end
	end
	
	if y < map.height - 1 and bottom.type == "Ledge South" then	
		bottom = cellMap[x][y + 2]
		if bottom.walkable and bottom.type ~= "Water" then
			table.insert(cell.neighbours, bottom)
		end
	end
end

local function buildMap()
	local cells = {}
	-- Loop through the map twice. Once to create the cells, then again to set their neighbours.
	for x = 0, map.width do
		cells[x] = {}
		for y = 0, map.height do
			cells[x][y] = newCell(x, y)
		end
	end
	for x = 0, map.width do
		for y = 0, map.height do
			setNeighbours(cells[x][y], cells)
		end
	end
	setmetatable(cells, metatables.cells)
	return cells
end

callbacks =
{
	name = getMapName,
	width = getMapWidth,
	height = getMapHeight,
	links = getMapLinks,
	npcs = getNpcData,
	cells = buildMap,
	
	dynamic =
	{
		battlers = getActiveBattlers,
		digSpots = getActiveDigSpots,
		headbuttTrees = getActiveHeadbuttTrees,
		berries = getActiveBerryTrees,
		items = getDiscoverableItems,		
	},
}

metatables =
{
	cell =
	{
		__index = cellFunctions,
		__eq = function(left, right)
			return left.x == right.x and left.y == right.y
		end,
		__tostring = function(self)
			return "Cell (" .. self.x .. ", " .. self.y .. ") type: " .. self.type .. ", neighbours: " .. #self.neighbours
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	cells =
	{
		__pairs = function(self)
			local x = 0
			local y = 0
			return function()
				if x > map.width then
					if y == map.height then
						return nil
					end
					x = 0
					y = y + 1
				end
				local cell = self[x][y]
				x = x + 1
				return cell, cell
			end
		end,
		__ipairs = function(self)
			local x = 0
			local y = 0
			local index = 0
			return function()
				if x > map.width then
					if y == map.height then
						return nil
					end
					x = 0
					y = y + 1
				end
				index = index + 1
				local cell = self[x][y]
				x = x + 1
				return index, cell
			end
		end,
		__len = function(self)
			if self.__length ~= nil then
				return self.__length
			end
			self.__length = (map.width + 1) * (map.height + 1)
			return self.__length
		end,
		__tostring = function(self)
			return map.name .. " - " .. #self .. " cells"
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	map =
	{
		__index = function(self, key)
			if callbacks[key] then
				local data = callbacks[key]()
				self[key] = data
				return data
			end
			return nil
		end,
	},
	
	map_main =
	{
		__index = function(self, key)
			if callbacks.dynamic[key] then
				return callbacks.dynamic[key]()
			end
			local currentMap = getMapName()
			cachedMaps[currentMap] = cachedMaps[currentMap] or setmetatable({}, self.__map_meta)
			return cachedMaps[currentMap][key]
		end,
		__newindex = function(self, key, value)
			assert(callbacks[key] == nil and callbacks.dynamic[key] == nil, "Map fields are read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
			local currentMap = getMapName()
			cachedMaps[currentMap] = cachedMaps[currentMap] or setmetatable({}, self.__map_meta)
			cachedMaps[currentMap][key] = value
		end,
		__tostring = function(self)
			return map.name .. "\nWidth: " .. self.width .. "\nHeight: " .. self.height .. "\n" .. #self.links .. " links\n" .. #self.npcs .. " npcs"
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	}
}

map.__map_meta = metatables.map

setmetatable(map, metatables.map_main)

-- Set global variable
_G.map = map

-- Return table
return map
