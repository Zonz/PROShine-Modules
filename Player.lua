--[[					Player data wrapper - created by Zonz

This module wraps player data into fields to make code look nicer.

Player fields:
	player.x				-	getPlayerX()
	player.y				-	getPlayerY()
	player.name				-	getAccountName()
	player.money			-	getMoney()
	player.isMember			-	isAccountMember()
	player.isMounted		-	isMounted()
	player.isSurfing		-	isSurfing()
	player.isOutside		-	isOutside()
	player.pokedexOwned		-	getPokedexOwned()
	player.pokedexSeen		-	getPokedexSeen()
	player.pokedexEvolved	-	getPokedexEvolved()

Player functions:
	player.isOnCell(x, y)					-	Equivalent to player.x == x and player.y == y
	player.isInRectangle(x1, y1, x2, y2)	-	player.x >= x1 and player.y >= y1 and player.x <= x2 and player.y <= y2

]]

local callbacks =
{
	x = getPlayerX,
	y = getPlayerY,
	name = getAccountName,
	money = getMoney,
	isMember = isAccountMember,
	isMounted = isMounted,
	isSurfing = isSurfing,
	isOutside = isOutside,
	pokedexOwned = getPokedexOwned,
	pokedexSeen = getPokedexSeen,
	pokedexEvolved = getPokedexEvolved,
}

local player = {}

function player.isOnCell(x, y)
	return getPlayerX() == x and getPlayerY() == y
end

function player.isInRectangle(x1, y1, x2, y2)
	return getPlayerX() >= x1 and getPlayerY() >= y1 and getPlayerX() <= x2 and getPlayerY() <= y2
end

setmetatable(player, {
__index = function(self, key)
	if callbacks[key] then
		return callbacks[key]()
	end
	return nil
end,
__newindex = function(self, key, value)
	assert(callbacks[key] == nil, "Player fields are read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
	rawset(self, key, value)
end,
})

-- Set global variable
_G.player = player

-- Return the table like an actual lib would
return player
