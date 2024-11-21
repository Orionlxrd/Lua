local utils = require "utils"
local actions = {}

actions.list = {}

function actions.build(monsterData)
     actions.list = {}

     local magicAttack = {
        description = "Ataque mágico",
        requirement = function (playerData, creatureData)
            return creatureData.mana >= 5
        end,

        execute = function (playerData, creatureData)
            local successChance = playerData.speed == 0 and 1 or creatureData.speed / playerData.speed
            local success = math.random() <= successChance

            local rawDamage = creatureData.attack - math.random() * playerData.defense
            local damage = math.max(1, math.ceil(rawDamage))

            if success then
                playerData.health = playerData.health - damage
                    creatureData.mana = creatureData.mana - 5

                print(string.format("%s atacou %s e deu %d pontos de dano", creatureData.name, playerData.name, damage))
                local healthRate = math.floor((playerData.health / playerData.maxHealth) * 10)
                local manaRate = math.floor((creatureData.mana / creatureData.maxMana) * 10)
                print(string.format("%s: %s", playerData.name, utils.getProgressBar3(healthRate)))
                print(string.format("%s gastou 5 de mana", creatureData.name))
                print(string.format("Mana:     %s", utils.getProgressBar2(manaRate)))
                
            else
                print(string.format("%s tentou atacar, mas errou", creatureData.name))
            end
        end
    }

    local sonarAttack = {
        description = "Ataque Sonar",
        requirement = function (playerData, creatureData)
            return playerData.mana >= 2
        end,

        execute = function(playerData, creatureData)
            
        local rawDamage = creatureData.attack - math.random() * playerData.defense
        local damage = math.max(1, math.ceil(rawDamage * 0.3))

            playerData.health = playerData.health - damage

            print(string.format("%s usou sonar e deu %d pontos de dano", creatureData.name, damage))
            local healthRate = math.floor((playerData.health / playerData.maxHealth) * 10)
            print(string.format("%s: %s", playerData.name, utils.getProgressBar3(healthRate)))

            print(string.format("%s gastou 2 de mana ", creatureData.name))
                local manaRate = math.floor((creatureData.mana / creatureData.maxMana) * 10)
                print(string.format("Mana:     %s", utils.getProgressBar2(manaRate)))
        end
    }

    local waitAction = {
        description = "Aguardar",
        requirement = nil,

        execute = function(playerData, creatureData)
        
        print(string.format("%s decidiu aguardar e não fez nada nesse turno.", creatureData.name))
        local healthRate = math.floor((playerData.health / playerData.maxHealth) * 10)
        local manaRate = math.floor((playerData.mana / playerData.maxMana) * 10)
        print(string.format("%s: %s", playerData.name, utils.getProgressBar3(healthRate)))
        print(string.format("Mana:     %s", utils.getProgressBar2(manaRate)))
    end

    }


    actions.list[#actions.list + 1] = magicAttack
    actions.list[#actions.list + 1] = sonarAttack
    actions.list[#actions.list + 1] = waitAction

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