
-- ("lame boring text"):title()	-	"Lame Boring Text"
function string:title()
	return self:gsub("(%a)([%w_']*)", function(a,b) return a:upper() .. b:lower() end)
end

function string:startswith(check)
	check = tostring(check)
	return #self >= #check and self:sub(1, #check) == check
end

function string:endswith(check)
	check = tostring(check)
	return #self >= #check and self:sub(-#check) == check
end

-- ("Hello world"):insert(6, " there")	-	"Hello there world"
function string:insert(index, insertion)
	if #self < index then
		return self .. insertion
	end
	local start = self:sub(1, index - 1)
	local ending = self:sub(index)
	return start .. insertion .. ending
end

-- ("book"):replace("b", "r")	-	"rook"
function string:replace(character, replacement)
	return self:gsub("%" .. character .. "+", replacement)
end

function table:contains(value)
	for _, v in pairs(self) do
		if v == value then
			return true
		end
	end
	return false
end

function table:clear()
	for k in pairs(self) do
		self[k] = nil
	end
end

function table:copy()
	local copy = {}
	for key, value in pairs(self) do
		if type(value) == "table" then
			copy[key] = table.copy(value)
		else
			copy[key] = value
		end
	end
	return setmetatable(copy, getmetatable(self))
end

local _lineswitch
function moveToLine(x1, y1, x2, y2)

	assert(x1 == x2 or y1 == y2, "error: moveToLine: coordinates must be a direct line from each other.")

	if math.random() < .5 then -- 50% chance of making the line a bit shorter
		if x1 == x2 then -- Vertical
			if getPlayerY() ~= y1 then -- Don't modify the current cell, to prevent player from moving back and forth on the same spot
				y1 = y1 + 1
			end
			if getPlayerY() ~= y2 then
				y2 = y2 - 1
			end
		else -- Horizontal
			if getPlayerX() ~= x1 then
				x1 = x1 + 1
			end
			if getPlayerX() ~= x2 then
				x2 = x2 - 1
			end
		end
	end
	
	if _lineswitch then
		if getPlayerX() == x1 and getPlayerY() == y1 then
			_lineswitch = not _lineswitch
		else
			moveToCell(x1, y1)
		end
	else
		if getPlayerX() == x2 and getPlayerY() == y2 then
			_lineswitch = not _lineswitch
		else
			moveToCell(x2, y2)
		end
	end
end
