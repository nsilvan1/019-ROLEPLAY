
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local old_weapons = {}
local old_health = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
config = {}

config.weebhook = {
    link = "",  ---toddynho ok
    logo = "https://cdn.discordapp.com/attachments/863971735145545758/968333219332235326/flush_1.png",
    color = 0255106
}


config.voip = "pma-voice2" -- ou tokovoip [ Para o VO-IP Funcionar no sistema de dimensoes ]
config.maxHealth = 300 -- Maximo de vida em seu servidor
config.rhealth = true -- Recuperar Vida quando matar alguem
config.aKillstreak = false -- Ativar sistema de killstreak
config.forceClearWeapons = true -- Ativar essa função caso acontece qualquer tentativa de bugar armas ( deslogar / crashar ) limpar todas as armas do jogador ( Não que vai acontecer, mas isso é uma forma pra previnir tambem. )
config.cmdarena = "pvpoff" -- Comando de sair da arena
config.cmdkickarena = "arenakick" -- Comando para kickar todos os jogadores de todas as arenas
config.permKick = "admin.permissao" -- Permissao para kickar os jogadores da arena
config.chatkill = false -- Ligar/Desligar chatkill da arena
config.chatKillDelay = 3000 -- Delay para sumir as mensagem do chatkill

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ARENAS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
config.arenas = {
    -- [1] = { 
    --     nome = "Arena X20", -- Nome da Arena 
    --     descricacao = "<b>Arma:</b> Pistola MK2 <br> <b>Tempo:</b> 15 Minutos<br> <b>Vagas:</b> 20 Vagas<br> <b>Aposta Minima:</b> R$ 500 <br><b>Para Sair:</b> /pvpoff", -- Descricao da NUI
    --     arma = "WEAPON_PISTOL_MK2", -- Arma da Arena
    --     imagem = "https://cdn.discordapp.com/attachments/811071824154329108/1028192693140078643/unknown.png", -- Imagem da Arena
    --     maxPlayers = 20, -- Maximo de Jogadores na Arena
    --     timeArena = 15, -- Tempo da Arena (em minutos)
    --     minAposta = 500, -- Valor minimo da Aposta
    --     coords = { -- CORDENADAS DE SPAWNS NA ARENA
    --         [1] = vector3(117.51,-878.63,134.63),
    --         [2] = vector3(120.77,-879.82,134.6),
    --         [3] = vector3(82.42,-867.39,135.04),
    --         [4] = vector3(84.09,-862.67,134.75)
    --     }
    -- },
    -- [2] = { 
    --     nome = "Arena X10", -- Nome da Arena 
    --     descricacao = "<b>Arma:</b> Pistola MK2 <br> <b>Tempo:</b> 30 Minutos<br> <b>Vagas:</b> 10 Vagas<br> <b>Aposta Minima:</b> R$ 500 <br><b>Para Sair:</b> /pvpoff", -- Descricao da NUI
    --     arma = "WEAPON_PISTOL_MK2", -- Arma da Arena
    --     imagem = "https://cdn.discordapp.com/attachments/811071824154329108/1028192693140078643/unknown.png", -- Imagem da Arena
    --     maxPlayers = 10, -- Maximo de Jogadores na Arena
    --     timeArena = 30, -- Tempo da Arena (em minutos)
    --     minAposta = 500, -- Valor minimo da Aposta
    --     coords = { -- CORDENADAS DE SPAWNS NA ARENA
    --         [1] = vector3(2989.71,7607.51,656.02),
    --         [2] = vector3(3007.07,7557.86,656.02),
    --         [3] = vector3(2990.07,7517.7,656.02),
    --         [4] = vector3(2948.32,7506.55,656.02),
    --         [5] = vector3(2925.99,7550.22,656.02),
    --         [6] = vector3(2912.68,7611.09,656.02),
    --         [7] = vector3(2964.4,7605.02,656.47)
    --     }
    -- },

    -- [3] = { 
    --     nome = "Arena X5", -- Nome da Arena 
    --     descricacao = "<b>Arma:</b> Pistola MK2 <br> <b>Tempo:</b> 30 Minutos<br> <b>Vagas:</b> 5 Vagas<br> <b>Aposta Minima:</b> R$ 500 <br><b>Para Sair:</b> /pvpoff", -- Descricao da NUI
    --     arma = "WEAPON_PISTOL_MK2", -- Arma da Arena
    --     imagem = "https://cdn.discordapp.com/attachments/811071824154329108/1028192693140078643/unknown.png", -- Imagem da Arena
    --     maxPlayers = 5, -- Maximo de Jogadores na Arena
    --     timeArena = 30, -- Tempo da Arena (em minutos)
    --     minAposta = 500, -- Valor minimo da Aposta
    --     coords = { -- CORDENADAS DE SPAWNS NA ARENA
    --         [1] = vector3(2989.71,7607.51,656.02),
    --         [2] = vector3(3007.07,7557.86,656.02),
    --         [3] = vector3(2990.07,7517.7,656.02),
    --         [4] = vector3(2948.32,7506.55,656.02),
    --         [5] = vector3(2925.99,7550.22,656.02),
    --         [6] = vector3(2912.68,7611.09,656.02),
    --         [7] = vector3(2964.4,7605.02,656.47)
    --     }
    -- },

    -- [4] = { 
    --     nome = "Arena X1", -- Nome da Arena 
    --     descricacao = "<b>Arma:</b> Pistola MK2 <br> <b>Tempo:</b> 30 Minutos<br> <b>Vagas:</b> 2 Vagas<br> <b>Aposta Minima:</b> R$ 500 <br><b>Para Sair:</b> /pvpoff", -- Descricao da NUI
    --     arma = "WEAPON_PISTOL_MK2", -- Arma da Arena
    --     imagem = "https://cdn.discordapp.com/attachments/622591185298653215/952023238530174996/Predio.png", -- Imagem da Arena
    --     maxPlayers = 2, -- Maximo de Jogadores na Arena
    --     timeArena = 30, -- Tempo da Arena (em minutos)
    --     minAposta = 500, -- Valor minimo da Aposta
    --     coords = { -- CORDENADAS DE SPAWNS NA ARENA
    --         [1] = vector3(-789.47,-216.91,57.54),
    --         [2] = vector3(-777.12,-239.81,57.54)
    --     }
    -- },

    -- [5] = { 
    --     nome = "Arena X20", -- Nome da Arena 
    --     descricacao = "<b>Arma:</b> AK-47 <br> <b>Tempo:</b> 30 Minutos<br> <b>Vagas:</b> 10 Vagas<br> <b>Aposta Minima:</b> R$ 500 <br><b>Para Sair:</b> /pvpoff", -- Descricao da NUI
    --     arma = "WEAPON_ASSAULTRIFLE", -- Arma da Arena
    --     imagem = "https://cdn.discordapp.com/attachments/811071824154329108/1028192693140078643/unknown.png", -- Imagem da Arena
    --     maxPlayers = 20, -- Maximo de Jogadores na Arena
    --     timeArena = 30, -- Tempo da Arena (em minutos)
    --     minAposta = 500, -- Valor minimo da Aposta
    --     coords = { -- CORDENADAS DE SPAWNS NA ARENA
    --         [1] = vector3(2989.71,7607.51,656.02),
    --         [2] = vector3(3007.07,7557.86,656.02),
    --         [3] = vector3(2990.07,7517.7,656.02),
    --         [4] = vector3(2948.32,7506.55,656.02),
    --         [5] = vector3(2925.99,7550.22,656.02),
    --         [6] = vector3(2912.68,7611.09,656.02),
    --         [7] = vector3(2964.4,7605.02,656.47)
    --     }
    -- },

    -- [6] = { 
    --     nome = "Arena X10", -- Nome da Arena 
    --     descricacao = "<b>Arma:</b> AK-47 <br> <b>Tempo:</b> 30 Minutos<br> <b>Vagas:</b> 2 Vagas<br> <b>Aposta Minima:</b> R$ 500 <br><b>Para Sair:</b> /pvpoff", -- Descricao da NUI
    --     arma = "WEAPON_ASSAULTRIFLE", -- Arma da Arena
    --     imagem = "https://cdn.discordapp.com/attachments/811071824154329108/1028192693140078643/unknown.png", -- Imagem da Arena
    --     maxPlayers = 10, -- Maximo de Jogadores na Arena
    --     timeArena = 30, -- Tempo da Arena (em minutos)
    --     minAposta = 500, -- Valor minimo da Aposta
    --     coords = { -- CORDENADAS DE SPAWNS NA ARENA
    --         [1] = vector3(2989.71,7607.51,656.02),
    --         [2] = vector3(3007.07,7557.86,656.02),
    --         [3] = vector3(2990.07,7517.7,656.02),
    --         [4] = vector3(2948.32,7506.55,656.02),
    --         [5] = vector3(2925.99,7550.22,656.02),
    --         [6] = vector3(2912.68,7611.09,656.02),
    --         [7] = vector3(2964.4,7605.02,656.47)
    --     }
    -- },

    -- [7] = { 
    --     nome = "Arena X5", -- Nome da Arena 
    --     descricacao = "<b>Arma:</b> AK-47 <br> <b>Tempo:</b> 30 Minutos<br> <b>Vagas:</b> 2 Vagas<br> <b>Aposta Minima:</b> R$ 500 <br><b>Para Sair:</b> /pvpoff", -- Descricao da NUI
    --     arma = "WEAPON_ASSAULTRIFLE", -- Arma da Arena
    --     imagem = "https://cdn.discordapp.com/attachments/811071824154329108/1028192693140078643/unknown.png", -- Imagem da Arena
    --     maxPlayers = 5, -- Maximo de Jogadores na Arena
    --     timeArena = 30, -- Tempo da Arena (em minutos)
    --     minAposta = 500, -- Valor minimo da Aposta
    --     coords = { -- CORDENADAS DE SPAWNS NA ARENA
    --         [1] = vector3(2989.71,7607.51,656.02),
    --         [2] = vector3(3007.07,7557.86,656.02),
    --         [3] = vector3(2990.07,7517.7,656.02),
    --         [4] = vector3(2948.32,7506.55,656.02),
    --         [5] = vector3(2925.99,7550.22,656.02),
    --         [6] = vector3(2912.68,7611.09,656.02),
    --         [7] = vector3(2964.4,7605.02,656.47)
    --     }
    -- },

    -- [8] = { 
    --     nome = "Arena X1", -- Nome da Arena 
    --     descricacao = "<b>Arma:</b> AK-47 <br> <b>Tempo:</b> 30 Minutos<br> <b>Vagas:</b> 2 Vagas<br> <b>Aposta Minima:</b> R$ 500 <br><b>Para Sair:</b> /pvpoff", -- Descricao da NUI
    --     arma = "WEAPON_ASSAULTRIFLE", -- Arma da Arena
    --     imagem = "https://cdn.discordapp.com/attachments/622591185298653215/952023238530174996/Predio.png", -- Imagem da Arena
    --     maxPlayers = 2, -- Maximo de Jogadores na Arena
    --     timeArena = 30, -- Tempo da Arena (em minutos)
    --     minAposta = 500, -- Valor minimo da Aposta
    --     coords = { -- CORDENADAS DE SPAWNS NA ARENA
    --         [1] = vector3(-789.47,-216.91,57.54),
    --         [2] = vector3(-777.12,-239.81,57.54)
    --     }
    -- },
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRADUCOES
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
config.lang = {
    arenaFinalizada = function(id) return  end, -- Quando a Arena for finalizada
    arenaCancelada = function(id) return  end, -- Quando a Arena for finalizada
    arenaCancelada = function(id) return TriggerClientEvent('chatMessage', -1, "^1[ARENA] ^0 Arena ^2"..id.."^0 acaba de ser cancelada por falta de jogadores.") end, -- Quando a Arena for finalizada
    arenaLotada = function(source) return TriggerClientEvent("Notify",source,"negado","Está arena está lotada.", 3) end, -- Quando a Arena estiver Lotada
    kickAllArena = function(source) return TriggerClientEvent("Notify",source,"sucesso","Você kickou todos os jogadores da arena", 3) end, -- Kickar todos jogadores da arena
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE APOSTAS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
config.apostarArena = function(source, user_id, id)
    local minAposta = parseInt(config.arenas[parseInt(id)].minAposta)
    local aposta = vRP.prompt(source, "Digite a sua Aposta: ", minAposta)
    if aposta ~= nil and aposta ~= "" and tonumber(aposta) then
        if tonumber(aposta) < minAposta then
            TriggerClientEvent("Notify",source,"sucesso","O Valor minimo de aposta é <b>"..vRP.format(minAposta).."</b>", 3)
            return
        end

        if vRP.tryFullPayment(user_id, tonumber(aposta)) then
            entrarArena(source, user_id, id, tonumber(aposta))
        else
            TriggerClientEvent("Notify",source,"negado","Você não possui essa quantia para apostar.", 3)
        end
    end
end

config.pagamentoApostas = function(user_id, kills, arena, cofre)
    local pagamento = cofre * 0.8 -- 80% Do valor do cofre da arena de apostas
    local identity = vRP.getUserIdentity(user_id)

    TriggerClientEvent('chatMessage', -1, "^1[ARENA] ^0O Cidadão ^2"..identity.name.." "..identity.firstname.."^0 venceu a arena ^2 "..arena.."^0 com ^2"..kills.." kill(s)^0.")
    vRP.giveMoney(user_id, pagamento)

    corpoHook = { { ["color"] = config.weebhook['color'], ["title"] = "**".. "Vencedor ( ".. arena .." )" .."**\n", ["thumbnail"] = { ["url"] = config.weebhook['logo'] }, ["description"] = "**ID:** ```css\n- "..user_id.." ```\n**KILLS** ```css\n- ".. kills .."```\n**RECEBEU** ```css\n- ".. vRP.format(pagamento) .."```\n**HORARIO** ```css\n- ".. os.date("%d/%m/%Y") .." ```", ["footer"] = { ["text"] = "Mirt1n Store", }, } }
    sendToDiscord(config.weebhook['link'], corpoHook)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE KILL STREAK
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
config.killStreak = function(source, user_id, kills, arena)
    if kills > 3 then
        local pagamento = 50 + (5 * kills)
        TriggerClientEvent('chatMessage', source, "^1[ARENA] ^0 ** KILL STREAK ** Você matou ^2"..kills.."^0 sem morrer e recebeu ^2"..pagamento.."^0 por isso.")
        vRP.giveMoney(user_id,pagamento)

        corpoHook = { { ["color"] = config.weebhook['color'], ["title"] = "**".. "Kill Streak ( ".. arena .." )" .."**\n", ["thumbnail"] = { ["url"] = config.weebhook['logo'] }, ["description"] = "**ID:** ```css\n- "..user_id.." ```\n**KILLS** ```css\n- ".. kills .."```\n**RECEBEU** ```css\n- ".. vRP.format(pagamento) .."```\n**HORARIO** ```css\n- ".. os.date("%d/%m/%Y") .." ```", ["footer"] = { ["text"] = "Mirt1n Store", }, } }
        sendToDiscord(config.weebhook['link'], corpoHook)
    end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ENTRAR ARENA
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
config.joinArena = function(user_id, id)
    local source = vRP.getUserSource(user_id)

    if source then
        old_weapons[user_id] = vRPclient.getWeapons(source)
        old_health[user_id] = vRPclient.getHealth(source)

        local weapon = config.arenas[parseInt(id)].arma
        vRPclient.giveWeapons(source,{[weapon] = { ammo = 250 }}, true)
        vRPclient.setHealth(source, config.maxHealth)
    end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SAIR DA ARENA
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
config.leaveArena = function(user_id)
    local source = vRP.getUserSource(user_id)
    vRPclient.giveWeapons(source,{}, true)
    if source then
        if old_weapons[user_id] ~= nil then
            vRPclient.giveWeapons(source, old_weapons[user_id], true)
            old_weapons[user_id] = nil
        end

        if old_health[user_id] ~= nil then
            vRPclient.setHealth(source, old_health[user_id])
            old_health[user_id] = nil
        end
    end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
config.identity = function(user_id)
    local identity = vRP.getUserIdentity(user_id)

    if identity then
        identity.nome = identity.name
        identity.sobrenome = identity.firstname

        return identity
    end
end

--[[ COLOQUE ISSO NAS FUNCOES SERVER
    local arena = Tunnel.getInterface("nxgroup_arena")

    if arena.inArena(source) then
		return
    end


    function vRP.limparArmas(user_id) -- COLOCAR ISSO DENTRO DE QUALQUER VRP>MODULES [ CASO SUA FUNÇÃO forceClearWeapons for ativada ]
        local data = vRP.getUserDataTable(user_id)
        if user_id then
            if data then
                data.weapons = {}
            end
        end
    end
]]