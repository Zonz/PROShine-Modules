--[[					Pokemon data wrapper - created by Zonz

This module wraps Pokemon data into fields to make code look nicer. It also caches data when applicable to reduce function calls.

It's optimized to the point that data that can never change (eg. a pokemon's name, its OT, its ability, etc.) will only call the functions
once, and cache the value for future use. For instance, calling "poke.shiny" will call isPokemonShiny for that pokemon, but only the first time.
Subsequent calls will return the value that was originally returned from isPokemonShiny, instead of calling the function again.
This means static functions only get called once for each pokemon, but it also means functions won't get called at all if you don't use them.
For instance, if you never call "poke.uniqueId", then getPokemonUniqueId for that pokemon will never get called either.

For data that changes frequently, like health or level, the callback functions are called each time you access the data.

Data is locked into the initial index you pass for it - it doesn't follow the same pokemon if it moves.
For example, say your first Pokemon is a Pikachu, your second is a Charmander, and you have a variable named "poke" set to team[1]
Initially, poke.name will be "Pikachu", but if you call "poke:swap(2)" or "swapPokemon(1, 2)", poke.name will be "Charmander"

Attempts are made to keep the data refreshed, such as after swapping a pokemon around or learning a new move.

Team members can be saved to a variable for ease of use, for example: local first = team[1]

Team member fields:
	#team						-	getTeamSize()
	team[index].index			-	The index in the team the Pokemon is in
	team[index].id				-	getPokemonId(index)
	team[index].name			-	getPokemonName(index)
	team[index].form			-	getPokemonForm(index)
	team[index].uniqueId		-	getPokemonUniqueId(index)
	team[index].shiny			-	isPokemonShiny(index)
	team[index].nature			-	getPokemonNature(index)
	team[index].ability			-	getPokemonAbility(index)
	team[index].region			-	getPokemonRegion(index)
	team[index].OT				-	getPokemonOriginalTrainer(index)
	team[index].gender			-	getPokemonGender(index)
	team[index].types			-	getPokemonType(index)
	team[index].type1			-	getPokemonType(index)[1]
	team[index].type2			-	getPokemonType(index)[2]
	team[index].hpType			-	The Hidden Power type of the Pokemon
	team[index].health			-	getPokemonHealth(index)
	team[index].maxHealth		-	getPokemonMaxHealth(index)
	team[index].healthPercent	-	getPokemonHealthPercent(index)
	team[index].level			-	getPokemonLevel(index)
	team[index].totalExp		-	getPokemonTotalExperience(index)
	team[index].remainingExp	-	getPokemonRemainingExperience(index)
	team[index].item			-	getPokemonHeldItem(index)
	team[index].status			-	getPokemonStatus(index)
	team[index].happiness		-	getPokemonHappiness(index)
	team[index].usable			-	isPokemonUsable(index)
	team[index].stats			-	Stat data	-	example: team[index].stats.attack	-	getPokemonStat(index, "attack")
	team[index].ivs				-	IV data		-	example: team[index].ivs.attack		-	getPokemonIndividualValue(index, "attack")
	team[index].evs				-	EV data		-	example: team[index].evs.attack		-	getPokemonEffortValue(index, "attack")
	team[index].moves			-	Move data	-	See below
	You can also get a Pokemon by its name (not case sensitive, returns the first one it finds with a matching name):
	team["Charmander"]

Move fields:
	#team[index].moves						-	The amount of moves known by the Pokemon
	team[index].moves[moveIndex].name		-	getPokemonMoveName(index, moveIndex)
	team[index].moves[moveIndex].PP			-	getRemainingPowerPoints(index, getPokemonMoveName(index, moveIndex))
	team[index].moves[moveIndex].maxPP		-	getPokemonMaxPowerPoints(index, moveIndex)
	team[index].moves[moveIndex].accuracy	-	getPokemonMoveAccuracy(index, moveIndex)
	team[index].moves[moveIndex].power		-	getPokemonMovePower(index, moveIndex)
	team[index].moves[moveIndex].type		-	getPokemonMoveType(index, moveIndex)
	team[index].moves[moveIndex].damageType	-	getPokemonMoveDamageType(index, moveIndex)
	team[index].moves[moveIndex].status		-	getPokemonMoveStatus(index, moveIndex)
	You can also get a move by its name (not case sensitive):
	team[index].moves["False Swipe"]

Move functions:
	pairs(team[index].moves)				-	Iterates through the Pokemon's moves
	team[index].moves[moveIndex]:forget()	-	forgetMove(getPokemonMoveName(index, moveIndex))	-	Only from within onLearningMove
	team[index].moves[moveIndex]:use()		-	useMove(getPokemonMoveName(index, moveIndex))		-	Only from within onBattleAction

Team member functions:
	pairs(team)						-	Iterates through the Pokemon in the team
	team[fromIndex]:swap(toIndex)	-	swapPokemon(fromIndex, toIndex)
	team[index]:swapWithLeader()	-	swapPokemonWithLeader(getPokemonName(index))
	team[index]:hasType(type)		-	getPokemonType(index)[1] == type or getPokemonType(index)[2] == type
	team[index]:deposit()			-	depositPokemonToPC(index)
	team[index]:release()			-	releasePokemonFromTeam(index)
	team[index]:useItem(item)		-	useItemOnPokemon(item, index)
	team[index]:giveItem(item)		-	giveItemToPokemon(item, index)
	team[index]:takeItem()			-	takeItemFromPokemon(index)
	team[index]:hasMove(moveName)	-	hasMove(index, moveName)
	team[index]:send()				-	sendPokemon(index)	-	Only from within onBattleAction

PC Pokemon fields:
	pc[boxIndex][slotIndex].pcbox			-	The number of the box the Pokemon is in
	pc[boxIndex][slotIndex].index			-	The slot index in the box the Pokemon is in
	pc[boxIndex][slotIndex].id				-	getPokemonIdFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].name			-	getPokemonNameFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].form			-	getPokemonFormFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].uniqueId		-	getPokemonUniqueIdFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].shiny			-	isPokemonFromPCShiny(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].nature			-	getPokemonNatureFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].ability			-	getPokemonAbilityFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].region			-	getPokemonRegionFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].OT				-	getPokemonOriginalTrainerFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].gender			-	getPokemonGenderFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].types			-	getPokemonTypeFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].type1			-	getPokemonTypeFromPC(boxIndex, slotIndex)[1]
	pc[boxIndex][slotIndex].type2			-	getPokemonTypeFromPC(boxIndex, slotIndex)[2]
	pc[boxIndex][slotIndex].hpType			-	The Hidden Power type of the Pokemon
	pc[boxIndex][slotIndex].health			-	getPokemonHealthFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].maxHealth		-	getPokemonMaxHealthFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].healthPercent	-	getPokemonHealthPercentFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].level			-	getPokemonLevelFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].totalExp		-	getPokemonTotalExperienceFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].remainingExp	-	getPokemonRemainingExperienceFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].item			-	getPokemonHeldItemFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].status			-	getPokemonStatusFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].happiness		-	getPokemonHappinessFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex].stats			-	PC stat data	-	example: pc[boxIndex][slotIndex].stats.attack	-	getPokemonStatFromPC(boxIndex, slotIndex, "attack")
	pc[boxIndex][slotIndex].ivs				-	PC IV data		-	example: pc[boxIndex][slotIndex].ivs.attack		-	getPokemonIndividualValueFromPC(boxIndex, slotIndex, "attack")
	pc[boxIndex][slotIndex].evs				-	PC EV data		-	example: pc[boxIndex][slotIndex].evs.attack		-	getPokemonEffortValueFromPC(boxIndex, slotIndex, "attack")
	pc[boxIndex][slotIndex].moves			-	PC move data	-	see below
	You can also get a Pokemon by its name (not case sensitive, returns the first one it finds with a matching name):
	pc[boxIndex]["Charmander"]

PC move fields:
	#pc[boxIndex][slotIndex].moves						-	The amount of moves known by the Pokemon
	pairs(pc[boxIndex][slotIndex].moves)				-	Iterates through the Pokemon's moves
	pc[boxIndex][slotIndex].moves[moveIndex].name		-	getPokemonMoveNameFromPC(boxIndex, slotIndex, moveIndex)
	pc[boxIndex][slotIndex].moves[moveIndex].PP			-	getPokemonRemainingPowerPointsFromPC(boxIndex, slotIndex, moveIndex)
	pc[boxIndex][slotIndex].moves[moveIndex].maxPP		-	getPokemonMaxPowerPointsFromPC(boxIndex, slotIndex, moveIndex)
	pc[boxIndex][slotIndex].moves[moveIndex].accuracy	-	getPokemonMoveAccuracyFromPC(boxIndex, slotIndex, moveIndex)
	pc[boxIndex][slotIndex].moves[moveIndex].power		-	getPokemonMovePowerFromPC(boxIndex, slotIndex, moveIndex)
	pc[boxIndex][slotIndex].moves[moveIndex].type		-	getPokemonMoveTypeFromPC(boxIndex, slotIndex, moveIndex)
	pc[boxIndex][slotIndex].moves[moveIndex].damageType	-	getPokemonMoveDamageTypeFromPC(boxIndex, slotIndex, moveIndex)
	pc[boxIndex][slotIndex].moves[moveIndex].status		-	getPokemonMoveStatusFromPC(boxIndex, slotIndex, moveIndex)
	You can also get a move by its name (not case sensitive):
	pc[boxIndex][slotIndex].moves["False Swipe"]

PC Pokemon functions:
	pairs(pc[boxIndex])							-	Iterates through the Pokemon in the box
	pc[boxIndex][slotIndex]:swap(teamIndex)		-	swapPokemonFromPC(boxIndex, slotIndex, teamIndex)
	pc[boxIndex][slotIndex]:swapWithLeader()	-	swapPokemonFromPC(boxIndex, slotIndex, 1)
	pc[boxIndex][slotIndex]:withdraw()			-	withdrawPokemonFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex]:release()			-	releasePokemonFromPC(boxIndex, slotIndex)
	pc[boxIndex][slotIndex]:hasMove(moveName)	-	hasMoveInPC(boxIndex, slotIndex, moveName) (doesn't actually exist)

PC status fields:
	#pc					-	getPCBoxCount()
	#pc[boxIndex]		-	getCurrentPCBoxSize()
	pc.isOpen			-	isPCOpen()
	pc.refreshed		-	isCurrentPCBoxRefreshed()
	pc.currentBoxId		-	getCurrentPCBoxId()
	pc.currentBoxSize	-	getCurrentPCBoxSize()
	pc.boxCount			-	getPCBoxCount()
	pc.pokemonCount		-	getPCPokemonCount()
	pc.currentBox		-	pc[pc.currentBoxId]

PC functions:
	pc.open()				-	usePC()
	pc.openBox(index)		-	openPCBox(index)
	pc.openNextBox()		-	openPCBox(getCurrentPCBoxId() + 1)
	pc.openPreviousBox()	-	openPCBox(getCurrentPCBoxId() - 1)

Opponent fields:
	opponent.shiny			-	isOpponentShiny()
	opponent.alreadyCaught	-	isAlreadyCaught()
	opponent.wild			-	isWildBattle()
	opponent.isTrainer		-	not isWildBattle()
	opponent.id				-	getOpponentId()
	opponent.name			-	getOpponentName()
	opponent.health			-	getOpponentHealth()
	opponent.maxHealth		-	getOpponentMaxHealth()
	opponent.healthPercent	-	getOpponentHealthPercent()
	opponent.level			-	getOpponentLevel()
	opponent.status			-	getOpponentStatus()
	opponent.form			-	getOpponentForm()
	opponent.types			-	getOpponentType()
	opponent.type1			-	getOpponentType()[1]
	opponent.type2			-	getOpponentType()[2]

Opponent functions:
	opponent.isEffortValue(type)	-	isOpponentEffortValue(type)
	opponent.effortValue(type)		-	getOpponentEffortValue(type)
	opponent.hasType(type)			-	opponent.type1 == type or opponent.type2 == type


Some usage examples:

------------------------------------------------------------------------------------------------------

local poke = team[1]

function onPathAction()
	
	-- dynamic - calls getPokemonHeldItem every onPathAction call
	if poke.item ~= "Leftovers" then
		return poke:giveItem("Leftovers")
	end
	
	-- dynamic - calls isPokemonUsable every onPathAction call
	if poke.usable then
		moveToGrass()
	else
		usePokecenter()
	end
end

------------------------------------------------------------------------------------------------------

-- name is static, getPokemonName is only called once - health is dynamic, getPokemonHealth is called every time poke.health is called
log(team[1].name .. " has " .. team[1].health .. " HP left.")

------------------------------------------------------------------------------------------------------

local poke = team[1]

function onPathAction()
	-- dynamic - calls getPokemonHealthPercent and getRemainingPowerPoints every onPathAction call
	if poke.healthPercent > 20 and poke.moves[1].PP > 0 then
		moveToGrass()
	else
		usePokecenter()
	end
end

------------------------------------------------------------------------------------------------------

-- Iterators also work!
for pokemon in pairs(team) do
	log(pokemon.index .. ": " .. pokemon.name)
end

for i, pokemon in ipairs(team) do
	log(i .. ": " .. pokemon.name)
end

------------------------------------------------------------------------------------------------------

-- #team is equivalent to getTeamSize()
for i = 1, #team do
	log(i .. ": " .. team[i].name)
end

]]

local Pokemon = {}

-- This is used for HP types, thus no fairy type
local types = {"Fighting", "Flying", "Poison", "Ground", "Rock", "Bug", "Ghost", "Steel", "Fire", "Water", "Grass", "Electric", "Psychic", "Ice", "Dragon", "Dark"}

-- Used for calculating HP type
local stats = {"Attack", "Defence", "Speed", "SpAttack", "SpDefence", "HP"}

-- These hold references to Pokemon when creating them.
-- Their purpose is to refresh the data and return the same Pokemon when creating more than one at the same index, instead of creating copies.
local cached = {}
local pc_cache = {}

-- Set to true when moving team members around or a new move is learned
local needRefreshed = false

local function pathRefresh()
	if needRefreshed then
		needRefreshed = false
		for i = 1, 6 do
			if cached[i] then
				cached[i] = cached[i]:refresh()
			end
		end
		for i in pairs(pc_cache) do
			pc_cache[i] = nil
		end
	end
end

local function learnedMoveRefresh()
	needRefreshed = true
end

registerHook("onPathAction", pathRefresh)
registerHook("onLearningMove", learnedMoveRefresh)

local callbacks =
{
	static =
	{
		-- Callbacks that only need to be called once
		-- These get cached the first time they're called
		id = getPokemonId,
		name = getPokemonName,
		form = getPokemonForm,
		uniqueId = getPokemonUniqueId,
		shiny = isPokemonShiny,
		nature = getPokemonNature,
		ability = getPokemonAbility,
		region = getPokemonRegion,
		OT = getPokemonOriginalTrainer,
		gender = getPokemonGender,
		types = getPokemonType,
		
		self =
		{
			type1 = function(self)
				return self.types[1]
			end,
			type2 = function(self)
				return self.types[2]
			end,
			hpType = function(self)
				local hpCalc = 0	
				for i = 1, 6 do
					hpCalc = hpCalc + (self.ivs[stats[i]] % 2) * (2 ^ (i - 1))
				end	
				return types[math.floor(hpCalc * 15 / 63) + 1]
			end,
		}
	},
	
	dynamic =
	{
		-- Callbacks that need to be called more than once
		health = getPokemonHealth,
		healthPercent = getPokemonHealthPercent,
		maxHealth = getPokemonMaxHealth,
		level = getPokemonLevel,
		totalExp = getPokemonTotalExperience,
		remainingExp = getPokemonRemainingExperience,
		item = getPokemonHeldItem,
		status = getPokemonStatus,
		happiness = getPokemonHappiness,
		usable = isPokemonUsable,
	},
	
	moves =
	{
		static =
		{
			maxPP = getPokemonMaxPowerPoints,
			accuracy = getPokemonMoveAccuracy,
			power = getPokemonMovePower,
			type = getPokemonMoveType,
			damageType = getPokemonMoveDamageType,
			status = getPokemonMoveStatus,
		},
		-- getRemainingPowerPoints is the only dynamic, so it's handled with the metatable
		
		functions =
		{
			forget = function(self)
				return forgetMove(self.name)
			end,
			
			use = function(self)
				return useMove(self.name)
			end,
		},
	},
	
	PC =
	{
		-- All PC functions are static
		id = getPokemonIdFromPC,
		name = getPokemonNameFromPC,
		form = getPokemonFormFromPC,
		uniqueId = getPokemonUniqueIdFromPC,
		shiny = isPokemonFromPCShiny,
		nature = getPokemonNatureFromPC,
		ability = getPokemonAbilityFromPC,
		region = getPokemonRegionFromPC,
		OT = getPokemonOriginalTrainerFromPC,
		gender = getPokemonGenderFromPC,
		types = getPokemonTypeFromPC,
		
		health = getPokemonHealthFromPC,
		healthPercent = getPokemonHealthPercentFromPC,
		maxHealth = getPokemonMaxHealthFromPC,
		level = getPokemonLevelFromPC,
		totalExp = getPokemonTotalExperienceFromPC,
		remainingExp = getPokemonRemainingExperienceFromPC,
		item = getPokemonHeldItemFromPC,
		status = getPokemonStatusFromPC,
		happiness = getPokemonHappinessFromPC,
		
		self =
		{
			type1 = function(self)
				return self.types[1]
			end,
			type2 = function(self)
				return self.types[2]
			end,
			hpType = function(self)
				local hpCalc = 0	
				for i = 1, 6 do
					hpCalc = hpCalc + (self.ivs[stats[i]] % 2) * (2 ^ (i - 1))
				end	
				return types[math.floor(hpCalc * 15 / 63) + 1]
			end,
		},
		
		status =
		{
			isOpen = isPCOpen,
			refreshed = isCurrentPCBoxRefreshed,
			currentBoxId = getCurrentPCBoxId,
			currentBoxSize = getCurrentPCBoxSize,
			boxCount = getPCBoxCount,
			pokemonCount = getPCPokemonCount,
			currentBox = function(self)
				return self[self.currentBoxId]
			end,
		},
		
		moves =
		{
			PP = getPokemonRemainingPowerPointsFromPC,
			maxPP = getPokemonMaxPowerPointsFromPC,
			accuracy = getPokemonMoveAccuracyFromPC,
			power = getPokemonMovePowerFromPC,
			type = getPokemonMoveTypeFromPC,
			damageType = getPokemonMoveDamageTypeFromPC,
			status = getPokemonMoveStatusFromPC,
		},
	},
	
	-- All battle callbacks are dynamic so we don't have to fuck around with re-caching data
	battle =
	{
		shiny = isOpponentShiny,
		alreadyCaught = isAlreadyCaught,
		wild = isWildBattle,
		id = getOpponentId,
		name = getOpponentName,
		health = getOpponentHealth,
		maxHealth = getOpponentMaxHealth,
		healthPercent = getOpponentHealthPercent,
		level = getOpponentLevel,
		status = getOpponentStatus,
		form = getOpponentForm,
		types = getOpponentType,
		type1 = function() return getOpponentType()[1] end,
		type2 = function() return getOpponentType()[2] end,
		isTrainer = function() return not isWildBattle() end,
	},
}

local metatables =
{
	Pokemon =
	{
		__index = function(self, key)
			if callbacks.static.self[key] then
				local ret = callbacks.static[key](self)
				rawset(self, key, ret)
				return ret
			elseif callbacks.static[key] then
				local ret = callbacks.static[key](self.index)
				rawset(self, key, ret)
				return ret
			elseif callbacks.dynamic[key] then
				-- return value without caching it
				return callbacks.dynamic[key](self.index)
			end
			return Pokemon[key]
		end,
		__eq = function(left, right)
			return left.uniqueId == right.uniqueId
		end,
		__newindex = function(self, key, value)
			error("Pokemon data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__tostring = function(self)
			return self.name .. " level " .. self.level .. " (" .. self.health .. "/" .. self.maxHealth .. " HP - Status: " .. self.status .. ")"
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	Pokemon_move =
	{
		__index = function(self, key)
			if callbacks.moves.static[key] then
				self[key] = callbacks.moves.static[key](self.ownerIndex, self.index)
				return rawget(self, key)
			elseif callbacks.moves.functions[key] then
				return callbacks.moves.functions[key]
			end
			return key == "PP" and getRemainingPowerPoints(self.ownerIndex, self.name) or nil
		end,
		__tostring = function(self)
			return self.name .. " (" .. self.PP .. "/" .. self.maxPP .. " PP)"
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	Pokemon_moves =
	{
		__index = function(self, key)
			if type(key) == "string" then -- Allow for indexing by the move's name, eg Pokemon[1].moves["False Swipe"]
				key = key:lower()
				for i = 1, 4 do
					local moveName = getPokemonMoveName(self.index, i)
					if moveName and moveName:lower() == key then
						return self[i]
					end
				end
				return nil
			end
			if key > 4 then
				return nil
			end
			local moveName = getPokemonMoveName(self.index, key)
			if moveName then
				local move = setmetatable({
				name = moveName,
				ownerIndex = self.index,
				index = key,
				}, self.__move_meta)
				self[key] = move
				return move
			end
			return nil
		end,
		__len = function(self)			
			local moveCount = 0
			for i = 1, 4 do
				if getPokemonMoveName(self.index, i) ~= nil then
					moveCount = moveCount + 1
				end			
			end
			return moveCount
		end,
		__pairs = function(self)
			local index = 1
			return function()
				local move = self[index]
				if move == nil then
					return nil
				end
				index = index + 1
				return move, move
			end
		end,
		__ipairs = function(self)
			local index = 1
			return function()
				local move = self[index]
				if move == nil then
					return nil
				end
				local previous = index
				index = index + 1
				return previous, move
			end
		end,
		__tostring = function(self)
			local ret = getPokemonName(self.index) .. "'s moves:\n"
			for move in pairs(self) do
				ret = ret .. move .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	Pokemon_stats =
	{
		__index = function(self, key)
			return getPokemonStat(self.index, key)
		end,
		__newindex = function(self, key, value)
			error("Stat data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__tostring = function(self)
			local ret = getPokemonName(self.index) .. "'s stats:\n"
			for _, stat in ipairs(stats) do
				ret = ret .. stat .. ": " .. getPokemonStat(self.index, stat) .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	Pokemon_ivs =
	{
		__index = function(self, key)
			return getPokemonIndividualValue(self.index, key)
		end,
		__newindex = function(self, key, value)
			error("IV data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__tostring = function(self)
			local ret = getPokemonName(self.index) .. "'s ivs:\n"
			for _, stat in ipairs(stats) do
				ret = ret .. stat .. ": " .. getPokemonIndividualValue(self.index, stat) .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	Pokemon_evs =
	{
		__index = function(self, key)
			return getPokemonEffortValue(self.index, key)
		end,
		__newindex = function(self, key, value)
			error("EV data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__tostring = function(self)
			local ret = getPokemonName(self.index) .. "'s evs:\n"
			for _, stat in ipairs(stats) do
				ret = ret .. stat .. ": " .. getPokemonEffortValue(self.index, stat) .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	PC_box =
	{
		__index = function(self, key)
			if type(key) == "string" then -- Allow for indexing by the Pokemon's name, eg Pokemon.PC[boxIndex]["Charmander"]
				key = key:lower()
				for i = 1, getCurrentPCBoxSize() do
					if getPokemonNameFromPC(self.index, i):lower() == key then
						return self[i]
					end
				end
				return nil
			end
			local poke = Pokemon.newFromPC(self.index, key)
			self[key] = poke
			return poke
		end,
		__len = function(self)
			return getCurrentPCBoxSize()
		end,
		__pairs = function(self)
			local index = 1
			local size = getCurrentPCBoxSize()
			return function()
				if index > size then
					return nil
				end
				local pokemon = self[index]
				index = index + 1
				return pokemon, pokemon
			end
		end,
		__ipairs = function(self)
			local index = 1
			local size = getCurrentPCBoxSize()
			return function()
				if index > size then
					return nil
				end
				local previous, pokemon = index, self[index]
				index = index + 1
				return previous, pokemon
			end
		end,
		__tostring = function(self)
			local ret = "PC box " .. self.currentBoxId .. ":\n"
			for pokemon in pairs(self) do
				ret = ret .. "Slot " .. pokemon.index .. ": " .. pokemon .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	PC =
	{
		__index = function(self, key)
			if type(key) == "number" then
				local box = setmetatable({index = key}, self.__box_meta)
				rawset(self, key, box)
				return box
			elseif callbacks.PC.status[key] then
				return callbacks.PC.status[key](self)
			end
			return nil
		end,
		__newindex = function(self, key, value)
			error("PC data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__len = function(self)
			return getPCBoxCount()
		end,
		__tostring = function(self)
			if self.isOpen then
				return "PC: " .. self.boxCount .. " boxes"
			end
			return "PC: closed"
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	PC_Pokemon =
	{
		__index = function(self, key)
			if callbacks.PC.self[key] then
				local ret = callbacks.PC.self[key](self)
				rawset(self, key, ret)
				return ret
			elseif callbacks.PC[key] then
				local ret = callbacks.PC[key](self.pcbox, self.index)
				rawset(self, key, ret)
				return ret
			end
			return Pokemon[key]
		end,
		__eq = function(left, right)
			return left.uniqueId == right.uniqueId
		end,
		__newindex = function(self, key, value)
			error("PC Pokemon data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__tostring = function(self)		
			return self.name .. " level " .. self.level .. " (" .. self.health .. "/" .. self.maxHealth .. " HP)"
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	PC_Pokemon_move =
	{
		__index = function(self, key)
			if callbacks.PC.moves[key] then
				self[key] = callbacks.PC.moves[key](self.ownerBox, self.ownerIndex, self.index)
				return rawget(self, key)
			end
			return nil
		end,
		__tostring = function(self)
			return self.name .. " (" .. self.PP .. "/" .. self.maxPP .. " PP)"
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	PC_Pokemon_moves =
	{
		__index = function(self, key)
			if type(key) == "string" then -- Allow for indexing by the move's name, eg Pokemon.PC[1][1].moves["False Swipe"]
				key = key:lower()
				for i = 1, 4 do
					local moveName = getPokemonMoveNameFromPC(self.pcbox, self.index, i)
					if moveName and moveName:lower() == key then
						return self[i]
					end
				end
				return nil
			end
			local moveName = getPokemonMoveNameFromPC(self.pcbox, self.index, key)
			if moveName then
				local move = setmetatable({
				name = moveName,
				ownerBox = self.pcbox,
				ownerIndex = self.index,
				index = key,
				}, self.__move_meta)
				self[key] = move
				return move
			end
			return nil
		end,
		__len = function(self)			
			local moveCount = 0
			for i = 1, 4 do
				if getPokemonMoveNameFromPC(self.pcbox, self.index, key) ~= nil then
					moveCount = moveCount + 1
				end			
			end
			return moveCount
		end,
		__pairs = function(self)
			local index = 1
			return function()
				if index > 4 or getPokemonMoveNameFromPC(self.pcbox, self.index, index) == nil then
					return nil
				end
				local move = self[index]
				index = index + 1
				return move, move
			end
		end,
		__ipairs = function(self)
			local index = 1
			return function()
				if index > 4 or getPokemonMoveNameFromPC(self.pcbox, self.index, index) == nil then
					return nil
				end
				local previous, move = index, self[index]
				index = index + 1
				return previous, move
			end
		end,
		__tostring = function(self)
			local ret = getPokemonNameFromPC(self.pcbox, self.index) .. "'s moves:\n"
			for move in pairs(self) do
				ret = ret .. move .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	PC_stats =
	{
		__index = function(self, key)
			rawset(self, key, getPokemonStatFromPC(self.pcbox, self.index, key))
			return self[key]
		end,
		__newindex = function(self, key, value)
			error("PC Stat data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__tostring = function(self)
			local ret = getPokemonNameFromPC(self.pcbox, self.index) .. "'s stats:\n"
			for _, stat in ipairs(stats) do
				ret = ret .. stat .. ": " .. getPokemonStatFromPC(self.pcbox, self.index, stat) .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	PC_ivs =
	{
		__index = function(self, key)
			rawset(self, key, getPokemonIndividualValueFromPC(self.pcbox, self.index, key))
			return self[key]
		end,
		__newindex = function(self, key, value)
			error("PC IV data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__tostring = function(self)
			local ret = getPokemonNameFromPC(self.pcbox, self.index) .. "'s ivs:\n"
			for _, stat in ipairs(stats) do
				ret = ret .. stat .. ": " .. getPokemonIndividualValueFromPC(self.pcbox, self.index, stat) .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	PC_evs =
	{
		__index = function(self, key)
			rawset(self, key, getPokemonEffortValueFromPC(self.pcbox, self.index, key))
			return self[key]
		end,
		__newindex = function(self, key, value)
			error("PC EV data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__tostring = function(self)
			local ret = getPokemonNameFromPC(self.pcbox, self.index) .. "'s evs:\n"
			for _, stat in ipairs(stats) do
				ret = ret .. stat .. ": " .. getPokemonEffortValueFromPC(self.pcbox, self.index, stat) .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	opponent =
	{
		__index = function(self, key)
			if callbacks.battle[key] then
				return callbacks.battle[key]()
			end
			return nil
		end,
		__newindex = function(self, key, value)
			error("Opponent data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__tostring = function(self)
			return self.name .. " level " .. self.level .. " (" .. self.health .. "/" .. self.maxHealth .. " HP - Status: " .. self.status .. ")"
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
	
	Pokemon_main =
	{
		__index = function(self, key)
			if type(key) == "string" then -- Allow for indexing by the Pokemon's name, eg Pokemon["Charmander"]
				assert(getServer() ~= "None", "You cannot get a Pokemon by its name when you are not logged in.")
				key = key:lower()
				for i = 1, getTeamSize() do
					if getPokemonName(i):lower() == key then
						return self[i]
					end
				end
				return nil
			end
			return Pokemon.new(key)
		end,
		__newindex = function(self, key, value)
			error("Pokemon data is read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		end,
		__len = function(self)
			return getTeamSize()
		end,
		__pairs = function(self)
			local index = 1
			return function()
				if index > getTeamSize() then
					return nil
				end
				local pokemon = self[index]
				index = index + 1
				return pokemon, pokemon
			end
		end,
		__ipairs = function(self)
			local index = 1
			return function()
				if index > getTeamSize() then
					return nil
				end
				local previous, pokemon = index, self[index]
				index = index + 1
				return previous, pokemon
			end
		end,
		__tostring = function(self)
			local ret = ""
			for pokemon in pairs(self) do
				ret = ret .. tostring(pokemon) .. "\n"
			end
			return ret:sub(1, -2)
		end,
		__concat = function(left, right)
			return tostring(left) .. tostring(right)
		end,
	},
}

function Pokemon.new(index, boxSlot)
	
	if type(index) ~= "number" then
		return nil
	end
	
	if type(boxSlot) == "number" then
		-- Treat this new Pokemon data as a PC Pokemon if two values are passed
		return Pokemon.newFromPC(index, boxSlot)
	end
	
	if index < 1 or index > 6 then
		return nil
	end	
	
	-- Check logged in status to allow for loading script while not logged in, if writing a Pokemon to a variable in the outer scope
	if getServer() ~= "None" and index > getTeamSize() then
		return nil
	end
	
	if cached[index] then
		return cached[index]
	end
	
	local new = {}
	new.index = index	
	new.moves = setmetatable({index = index, __move_meta = metatables.Pokemon_move}, metatables.Pokemon_moves)	
	new.stats = setmetatable({index = index}, metatables.Pokemon_stats)	
	new.ivs = setmetatable({index = index}, metatables.Pokemon_ivs)	
	new.evs = setmetatable({index = index}, metatables.Pokemon_evs)	
	setmetatable(new, metatables.Pokemon)	
	cached[index] = new	
	return new
end

function Pokemon.newFromPC(box, index)
	
	if box ~= getCurrentPCBoxId() or index < 1 or index > getCurrentPCBoxSize() then
		return nil
	end
	
	pc_cache[box] = pc_cache[box] or {}
	if pc_cache[box][index] then
		return pc_cache[box][index]
	end
	
	local new = {}
	new.pcbox = box
	new.index = index	
	new.moves = setmetatable({pcbox = box, index = index, __move_meta = metatables.PC_Pokemon_move}, metatables.PC_Pokemon_moves)	
	new.stats = setmetatable({pcbox = box, index = index}, metatables.PC_stats)	
	new.ivs = setmetatable({pcbox = box, index = index}, metatables.PC_ivs)	
	new.evs = setmetatable({pcbox = box, index = index}, metatables.PC_evs)	
	setmetatable(new, metatables.PC_Pokemon)
	pc_cache[box][index] = new
	return new
end

Pokemon.PC = {__box_meta = metatables.PC_box}

function Pokemon.PC.open()
	return usePC()
end

function Pokemon.PC.openBox(index)
	return openPCBox(index)
end

function Pokemon.PC.openNextBox()
	local box = getCurrentPCBoxId()
	if box >= getPCBoxCount() then
		return false
	end
	return openPCBox(box + 1)
end

function Pokemon.PC.openPreviousBox()
	local box = getCurrentPCBoxId()
	if box == 1 then
		return false
	end
	return openPCBox(box - 1)
end

setmetatable(Pokemon.PC, metatables.PC)

Pokemon.opponent = {}

function Pokemon.opponent.isEffortValue(ev)
	return isOpponentEffortValue(ev)
end

function Pokemon.opponent.effortValue(ev)
	return getOpponentEffortValue(ev)
end

function Pokemon.opponent.hasType(type)
	type = type:lower()
	local types = getOpponentType()
	return types[1]:lower() == type or types[2]:lower() == type
end

setmetatable(Pokemon.opponent, metatables.opponent)

function Pokemon:swap(index)
	if self.pcbox then
		return swapPokemonFromPC(self.pcbox, self.index, index)
	end
	return swapPokemon(self.index, index)
end

function Pokemon:swapWithLeader()
	-- In the PC or not already the leader
	if self.pcbox or self.index > 1 then
		return self:swap(1)
	end
	return false
end

function Pokemon:send()
	return sendPokemon(self.index)
end

function Pokemon:hasType(type)
	type = type:lower()
	local types = getPokemonType(self.index)
	return types[1]:lower() == type or types[2]:lower() == type
end

function Pokemon:withdraw()
	assert(self.pcbox, "Tried to withdraw a Pokemon that's already in the party.")
	return withdrawPokemonFromPC(self.pcbox, self.index)
end

function Pokemon:deposit()
	assert(self.pcbox == nil, "Tried to deposit a Pokemon that's already in the PC.")
	return depositPokemonToPC(self.index)
end

function Pokemon:release()
	if self.pcbox then
		return releasePokemonFromPC(self.pcbox, self.index)
	end
	return releasePokemonFromTeam(self.index)
end

function Pokemon:useItem(item)
	assert(self.pcbox == nil, "Tried to use an item on a Pokemon in the PC.")
	return useItemOnPokemon(item, self.index)
end

function Pokemon:giveItem(item)
	assert(self.pcbox == nil, "Tried to give an item to a Pokemon in the PC.")
	return giveItemToPokemon(item, self.index)
end

function Pokemon:takeItem()
	assert(self.pcbox == nil, "Tried to take an item from a Pokemon in the PC.")
	return takeItemFromPokemon(self.index)
end

function Pokemon:hasMove(moveName)
	if self.pcbox then
		-- hasMoveInPC does not exist
		for i = 1, #self.moves do
			if moveName:lower() == self.moves[i].name:lower() then
				return true
			end
		end
		return false
	end
	return hasMove(self.index, moveName)
end

function Pokemon:refresh()
	if self.pcbox then
		return nil
	end
	cached[self.index] = nil
	local new = Pokemon.new(self.index)
	for key in pairs(self) do
		self[key] = nil
	end
	if new == nil then
		return nil
	end
	rawset(self, "index", new.index)
	rawset(self, "moves", new.moves)
	rawset(self, "stats", new.stats)
	rawset(self, "ivs", new.ivs)
	rawset(self, "evs", new.evs)
	return self
end

setmetatable(Pokemon, metatables.Pokemon_main)

-- Here we extend certain callbacks so we know when our data needs refreshed

local _swapPokemon = swapPokemon
function swapPokemon(index1, index2)
	needRefreshed = true
	return _swapPokemon(index1, index2)
end

local _swapPokemonWithLeader = swapPokemonWithLeader
function swapPokemonWithLeader(pokeName)
	needRefreshed = true
	return _swapPokemonWithLeader(pokeName)
end

local _sortTeamByLevelAscending = sortTeamByLevelAscending
function sortTeamByLevelAscending()
	needRefreshed = true
	return _sortTeamByLevelAscending()
end

local _sortTeamByLevelDescending = sortTeamByLevelDescending
function sortTeamByLevelDescending()
	needRefreshed = true
	return _sortTeamByLevelDescending()
end

local _sortTeamRangeByLevelAscending = sortTeamRangeByLevelAscending
function sortTeamRangeByLevelAscending(from, to)
	needRefreshed = true
	return _sortTeamRangeByLevelAscending(from, to)
end

local _sortTeamRangeByLevelDescending = sortTeamRangeByLevelDescending
function sortTeamRangeByLevelDescending(from, to)
	needRefreshed = true
	return _sortTeamRangeByLevelDescending(from, to)
end

local _depositPokemonToPC = depositPokemonToPC
function depositPokemonToPC(index)
	needRefreshed = true
	return _depositPokemonToPC(index)
end

local _swapPokemonFromPC = swapPokemonFromPC
function swapPokemonFromPC(boxIndex, pokeIndex, teamIndex)
	needRefreshed = true
	return _swapPokemonFromPC(boxIndex, pokeIndex, teamIndex)
end

local _releasePokemonFromTeam = releasePokemonFromTeam
function releasePokemonFromTeam(index)
	needRefreshed = true
	return _releasePokemonFromTeam(index)
end

local _releasePokemonFromPC = releasePokemonFromPC
function releasePokemonFromPC(boxID, pokemonID)
	needRefreshed = true
	return _releasePokemonFromPC(boxID, pokemonID)
end


-- Set global variables because we have a lazy Libs folder
team = Pokemon
pc = Pokemon.PC
opponent = Pokemon.opponent

-- Return the table like an actual lib would
return Pokemon
