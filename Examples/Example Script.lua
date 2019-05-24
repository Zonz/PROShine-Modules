name = "Route 6 SpDefence EV Trainer"
author = "Zonz"
description = "Trains the Special Defence EV of the first Pokemon in the team. Start script between Route 6 and Vermilion Pokecenter."

local first = team[1]

function onPathAction()
	if first.evs.spdef >= 252 then
		fatal("Training complete.")
	elseif first.isUsable then
		if map.name == "Pokecenter Vermilion" then
			moveToCell(9, 22)
		elseif map.name == "Vermilion City" then
			moveToRectangle(41, 0, 43, 0)
		elseif map.name == "Route 6" then
			moveToLine(36, 22, 36, 46) -- a long stretch of grass
		end
	else
		if map.name == "Route 6" then
			moveToCell(23, 61)
		elseif map.name == "Vermilion City" then
			moveToCell(27, 21)
		elseif map.name == "Pokecenter Vermilion" then
			usePokecenter()
		end
	end
end

function onBattleAction()
	if opponent.isSpecial then
		return useItem("Pokeball")
	elseif opponent.isTrainer then
		return attack() or sendUsablePokemon() or sendAnyPokemon()
	elseif opponent.isEffortValue("SpDefence") then
		return attack() or run() or sendAnyPokemon()
	else
		return run() or sendAnyPokemon()
	end
end
