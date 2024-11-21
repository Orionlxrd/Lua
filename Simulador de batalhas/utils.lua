local utils = {}

function utils.enableUtf8()
    os.execute("chcp 65001")
end

function utils.printHeader()
    print([[
=======================================================


         />_________________________________
[########[]_________________________________>
         \>

        ---------------------------------
              SIMULADOR DE BATALHA 

=======================================================

        Você empunha sua espada e se prepara para lutar.
                      É hora da batalha!

]])
end

function utils.getProgressBar(attribute)
    local fullChar = "⬜"
    local emptyChar = "⬛"
 
    local result = ""
    for i = 1, 10, 1 do 
      --if i <= attribute then
        --result = result .. fullChar
      --else
        --result = result .. emptyChar
        result = result .. (i <= attribute and fullChar or emptyChar)
      --end
    end
    return result
end

function utils.getProgressBar2(attribute)
  local emptyChar = "⬛"
  local manaChar = "🟦"

  local result = ""
  for i = 1, 10, 1 do 
      result = result .. (i <= attribute and manaChar or emptyChar)
  end
  return result
end

function utils.getProgressBar3(attribute)
  local emptyChar = "⬛"
  local lifeChar = "🟥"

  local result = ""
  for i = 1, 10, 1 do 
      result = result .. (i <= attribute and lifeChar or emptyChar)
  end
  return result
end

function utils.printCreature(creature)
   local healthRate = math.floor((creature.health / creature.maxHealth) * 10)

   print("/" .. creature.name)
   print("/" .. creature.description)
   print("/")
   print("/ Atributos")
   print("/   Ataque:      ".. utils.getProgressBar(creature.attack))
   print("/   Defesa:      ".. utils.getProgressBar(creature.defense))
   print("/   Vida:        ".. utils.getProgressBar3(creature.health))
   print("/   Velocidade:  ".. utils.getProgressBar(creature.speed))
   print("/   Mana:        ".. utils.getProgressBar2(creature.mana))
end

function utils.ask()
     io.write(">")
     local answer = io.read("*n")
     return answer
    end
return utils