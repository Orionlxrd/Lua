local utils = require "utils"
local actions = {}

actions.list = {}

function actions.build(playerData)
     actions.list = {}

     local magicAttack = {
        description = "Ataque mágico",
        requirement = function (playerData, creatureData)
            return playerData.mana >= 5
        end,

        execute = function (playerData, creatureData)

            local rawDamage = playerData.attack - math.random() * creatureData.defense
            local damage = math.max(1, math.ceil(rawDamage))
           
                creatureData.health = creatureData.health - damage
                playerData.mana = playerData.mana - 5

                print(string.format("%s atacou a criatura e deu %d pontos de dano", playerData.name, damage))
                local healthRate = math.floor((creatureData.health / creatureData.maxHealth) * 10)
                print(string.format("%s: %s", creatureData.name, utils.getProgressBar3(healthRate)))

                print(string.format("%s gastou 5 de mana ", playerData.name))
                local manaRate = math.floor((playerData.mana / playerData.maxMana) * 10)
                print(string.format("Mana:     %s", utils.getProgressBar2(manaRate)))

        end
    }

    local swordAttack = {
        description = "Ataque com espada",
        requirement = nil,

        execute = function (playerData, creatureData)
            local successChance = creatureData.speed == 0 and 1 or playerData.speed / creatureData.speed
            local success = math.random() <= successChance

            local rawDamage = playerData.attack - math.random() * creatureData.defense
            local damage = math.max(1, math.ceil(rawDamage))

            if success then
                creatureData.health = creatureData.health - damage

                print(string.format("%s atacou a criatura e deu %d pontos de dano", playerData.name, damage))
                local healthRate = math.floor((creatureData.health / creatureData.maxHealth) * 10)
                print(string.format("%s: %s", creatureData.name, utils.getProgressBar3(healthRate)))

                local manaRate = math.floor((creatureData.mana / creatureData.maxMana) * 10)
                print(string.format("Mana:     %s", utils.getProgressBar2(manaRate)))

        
            else
                print(string.format("%s tentou atacar, mas esqueceu a espada na mochila", playerData.name))
            end
        end
    }


    local regenPotions = {
        description = "Tomar uma poção de regeneração.",
        requirement = function (playerData, creatureData)
            return playerData.potions >= 1
            
        end,
        
        execute = function(playerData, creatureData)
            playerData.potions = playerData.potions - 1

            local regenPoints = 10
            playerData.health = math.min(playerData.maxHealth, playerData.health + regenPoints)
            local healthRate = math.floor((playerData.health / playerData.maxHealth) * 10)
            print(string.format("%s usou uma poção e recuperou alguns pontos de vida", playerData.name))
            print(string.format("%s: %s", playerData.name, utils.getProgressBar3(healthRate)))
        end
    }



    actions.list[#actions.list + 1] = magicAttack
    actions.list[#actions.list + 1] = swordAttack
    actions.list[#actions.list + 1] = regenPotions
end

function actions.getValidActions(playerData, creatureData)
    local validActions = {}
    for _, action in pairs(actions.list) do
        local requirement = action.requirement
        local isValid = requirement == nil or requirement(playerData, creatureData)
        if isValid then
            validActions[#validActions+1] = action
        end
    end
    return validActions
end

return actions