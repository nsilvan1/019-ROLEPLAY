local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("nxgroup_arena",src)
Proxy.addInterface("nxgroup_arena",src)

vCLIENT = Tunnel.getInterface("nxgroup_arena")

-- vRP.prepare("vRP/getUserKill", "SELECT kills FROM pvp WHERE user_id = @id")
-- vRP.prepare("vRP/getUserDeath", "SELECT death FROM pvp WHERE user_id = @id")
-- vRP.prepare("vRP/updateKill", "UPDATE pvp  SET kills = @old  WHERE user_id = @id")
-- vRP.prepare("vRP/updateDeath", "UPDATE pvp SET death = @old  WHERE user_id = @id")

-- vRP.prepare("vRP/updateKillset", "UPDATE pvp SET death = @death  WHERE user_id = @user_id")
-- vRP.prepare("vRP/getUserInformations", "SELECT * FROM pvp WHERE user_id = @id")

-- vRP.prepare("vRP/inicioarena","INSERT IGNORE INTO pvp(user_id,arena) VALUES(@user_id,@arena)")
-- vRP.prepare("vRP/get_arena","SELECT * FROM pvp WHERE user_id = @user_id")

local arena = {}
local scoreboard = {}
local inArena = {}
local killStreak = {}
local autenticado = true

local playerKills = {}
local playerDeaths = {}

-- RegisterCommand("rank", function(source, args, rawCmd)
-- 	local source = source
-- 	    vCLIENT.scoreboardtt(source)
--         -- vRP.execute("vRP/updateKillset",{ user_id = 1, death = 1 })
-- end)





-- function getUserKill(user_id)
-- 	local rows = vRP.query("vRP/getUserInformations",{ id = user_id })
-- 	if #rows > 0 then
-- 		for k,v in pairs(rows) do
-- 			return rows[1].kills
-- 		end
-- 	end
-- end

-- function getUserDeath(user_id)
-- 	local rows = vRP.query("vRP/getUserInformations",{ id = user_id })
-- 	if #rows > 0 then
-- 		for k,v in pairs(rows) do
-- 			return rows[1].death
-- 		end
-- 	end
-- end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ARENA
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function src.showNuiArena()
    if autenticado then
        local source = source
        local user_id = vRP.getUserId(source)
        if user_id then
            local arenas = {}
            for k,v in pairs(config.arenas) do
                arenas[k] = { id = k, nome = v.nome, descricacao = v.descricacao, imagem = v.imagem }
            end

            return arenas
        end
    end
end

function checkArena(id)
    if autenticado then
        if arena[parseInt(id)] ~= nil then
            if arena[parseInt(id)].jogadores >= config.arenas[parseInt(id)].maxPlayers then
                return true
            end
        end

        return false
    end
end


function src.apostarArena(id)
    if autenticado then
        -- print(id)
        local source = source
        local user_id = vRP.getUserId(source)
        if user_id then
            if arena[parseInt(id)] ~= nil then
                if arena[parseInt(id)].jogadores >= config.arenas[parseInt(id)].maxPlayers then
                    config.lang['arenaLotada'](source)
                    return
                end
            end

            config.apostarArena(source, user_id, id)
        end
    end
end

function entrarArena(source, user_id, id, aposta)
    if autenticado then
        
        if arena[parseInt(id)] == nil then
            arena[parseInt(id)] = { cofreArena = aposta, jogadores = 1, tempo = config.arenas[parseInt(id)].timeArena*60 }
        else
            arena[parseInt(id)] = { cofreArena = arena[parseInt(id)].cofreArena + aposta, jogadores = arena[parseInt(id)].jogadores + 1, tempo = arena[parseInt(id)].tempo }
        end

        vCLIENT.setArena(source, id, config.arenas[parseInt(id)].coords[math.random(#config.arenas[parseInt(id)].coords)], arena[parseInt(id)].tempo)
        inArena[user_id] = parseInt(id)

        local identity = config.identity(user_id)
        table.insert(scoreboard, { arena = parseInt(id), user_id = user_id, kills = 0, identity = identity, killStreak = 0 } )

        -- local rows = vRP.query("vRP/get_arena", {user_id = user_id})
        -- if #rows > 0 then
        -- else
        --     vRP.execute("vRP/inicioarena", {user_id = user_id , arena = parseInt(id)})
        -- end
        -- TriggerClientEvent('_survivalmirtin:updateArena', source, true)
        TriggerClientEvent('mirtin_survival:updateArena', source, true)
        SetPlayerRoutingBucket(source, parseInt(id))
        config.joinArena(user_id, id)

        corpoHook = { { ["color"] = config.weebhook['color'], ["title"] = "**".. "Apostou ( ".. config.arenas[parseInt(id)].nome .." )" .."**\n", ["thumbnail"] = { ["url"] = config.weebhook['logo'] }, ["description"] = "**ID:** ```css\n- "..user_id.." ```\n**APOSTOU** ```css\n- ".. vRP.format(aposta) .."```\n**HORARIO** ```css\n- ".. os.date("%d/%m/%Y") .." ```", ["footer"] = { ["text"] = "Flush Roleplay", }, } }
        sendToDiscord(config.weebhook['link'], corpoHook)

        if config.voip == "pma-voice" then
            exports["pma-voice"]:updateRoutingBucket(source, parseInt(id))
        end
    end
end

function sairArena(user_id, status)
    if autenticado then
        local source = vRP.getUserSource(user_id)
        local id = inArena[user_id]

        if source then
            vCLIENT.removePlayerArena(source)
            config.leaveArena(user_id)
        
            if arena[parseInt(id)] ~= nil then
                arena[parseInt(id)] = { cofreArena = arena[parseInt(id)].cofreArena, jogadores = arena[parseInt(id)].jogadores - 1, tempo = arena[parseInt(id)].tempo }
            end

            SetPlayerRoutingBucket(source, 0)
            if config.voip == "pma-voice" then
                exports["pma-voice"]:updateRoutingBucket(source, 0)
            end 

            if status == nil then
                removeScoreboard(id, user_id)
            end
            
            playerKills[user_id] = 0
            playerDeaths[user_id] = 0
            
            inArena[user_id] = nil
            SetTimeout(5000,function()
                if source then
                    TriggerClientEvent('mirtin_survival:updateArena', source, false)
                end
            end)
        end
    end
end

function encerrarArena(id)
    if autenticado then
        config.lang['arenaFinalizada'](config.arenas[id].nome)
        paymentGanhador(id)

        for k,v in pairs(inArena) do
            if v == id then
                async(function()
                    sairArena(parseInt(k), true)
                end)
            end
        end

        removeScoreboard(id)
        arena[id] = nil
    end
end

function paymentGanhador(id)
    if autenticado then
        if id then
            local value = arena[id].cofreArena

            local ultimoValor
            for k,v in pairs(scoreboard) do
                if v.arena == id then
                    if ultimoValor == nil then
                        ultimoValor = { user_id = v.user_id, kills = v.kills }
                    else
                        if v.kills > ultimoValor.kills then
                            ultimoValor = { user_id = v.user_id, kills = v.kills }
                        end
                    end
                end
            end

            config.pagamentoApostas(ultimoValor.user_id, ultimoValor.kills, config.arenas[id].nome, value)
        end
    end
end

function removeScoreboard(id, user_id)
    if autenticado then
        for k,v in pairs(scoreboard) do
            if v.arena == id and v.user_id == user_id then
                scoreboard[k] = nil
            end

            if v.arena == id and user_id == nil then
                scoreboard[k] = nil
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RANDOM SPAWN
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function src.randomSpawn()
    if autenticado then
        local source = source
        local user_id = vRP.getUserId(source)
        if user_id then
            local arenaID = inArena[user_id]

            if arenaID ~= nil then
                vRPclient.giveWeapons(source,{[config.arenas[parseInt(arenaID)].arma] = { ammo = 250 }}, true)
                return config.arenas[parseInt(arenaID)].coords[math.random(#config.arenas[parseInt(arenaID)].coords)],config.maxHealth
            end
        end
    end
end

-- local id2 = {}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE MORTE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function src.receberMorte(source, arma, ksource)
    if autenticado then
        if source == 0 or source == nil or ksource == 0 or ksource == nil then
            return
        end

        local user_id = vRP.getUserId(source)
        local kuser_id = vRP.getUserId(ksource)

        -- id2 = kuser_id
        if user_id and kuser_id then
            local arenaID = inArena[kuser_id]

            playerKills[kuser_id] = parseInt(playerKills[kuser_id]) + 1
            playerDeaths[user_id] = parseInt(playerDeaths[user_id]) + 1

            if config.aKillstreak then
                killStreak[user_id] = 0

                if killStreak[kuser_id] ~= nil then
                    killStreak[kuser_id] = killStreak[kuser_id] + 1
                else
                    killStreak[kuser_id] = 1
    
                end

                
                -- vRP.execute("vRP/updateKillset",{ user_id = parseInt(user_id), death = parseInt(killStreak[kuser_id]) })
                
                if ksource then
                    config.killStreak(ksource, kuser_id, killStreak[kuser_id], config.arenas[arenaID].nome)
                end
            end

            if config.rhealth then
                if ksource then
                    vRPclient.setHealth(ksource, 300)
                end
            end

   
                for k,v in pairs(scoreboard) do
                    if v.arena == arenaID and v.user_id == kuser_id then
                        scoreboard[parseInt(k)] = { arena = scoreboard[k].arena, user_id = kuser_id, kills = scoreboard[k].kills + 1, identity = scoreboard[k].identity, killStreak = killStreak[kuser_id] }
                    end
                end

            if config.chatkill then
                local kidentity = config.identity(kuser_id)
                local nidentity = config.identity(user_id)
                if kidentity ~= nil and nidentity ~= nil then
                    for k,v in pairs(inArena) do
                        if v == arenaID then
                            async(function()
                                if player then
                                    vCLIENT.sendChatKill(player, kidentity.nome.. " " .. kidentity.sobrenome, nidentity.nome.. " " .. nidentity.sobrenome, arma, config.chatKillDelay)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SCOREBOARD
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
src.scoreBoard = function(arenaID)
    if autenticado then
        local source = source
        local user_id = vRP.getUserId(source)
        
        if user_id then
            if arena[arenaID] ~= nil then
                local arenaName = config.arenas[arenaID].nome
                local cofre = arena[arenaID].cofreArena

                local count = 0
                local user_list = {}
                for k,v in pairs(scoreboard) do
                    if v.arena == arenaID then
                        if not playerKills[v.user_id] then
                            playerKills[v.user_id] = 0
                        end

                        if not playerDeaths[v.user_id] then
                            playerDeaths[v.user_id] = 0
                        end

                        local kills = playerKills[v.user_id]
                        local deaths = playerDeaths[v.user_id]
                        local userKd = kills / deaths
                        local realKd = round(userKd,2)

                        user_list[count] = { user_id = v.user_id, kills = kills, deaths = deaths, kd = realKd, identidade = v.identity.nome.." "..v.identity.sobrenome }

                        count = count + 1
                    end
                end

                return { arenaName,vRP.format(cofre) },user_list
            end
        end
    end
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end


-- function sendToDatabase()
--     SetTimeout(120*1000, sendToDatabase)

--     for k,_ in pairs(playerDeaths) do
--         if playerDeaths[k] > 0 then
--             -- vRP.execute("kush/updateDeaths",{ user_id = k, deaths = playerDeaths[k] })
--             vRP.execute("vRP/updateKillset",{ user_id = k, death = playerDeaths[k] })
--             playerDeaths[k] = 0
--         end
--     end

-- end

-- async(function()
--     sendToDatabase()
-- end)

--   -- vRP.execute("vRP/updateKillset",{ user_id = parseInt(user_id), death = parseInt(killStreak[kuser_id]) })

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -- SCOREBOARD
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- function src.matoumortee(arenaID)
--     local source = source
--     local user_id = vRP.getUserId(source)
--     if user_id then
--         if arena[arenaID] ~= nil then
--             local arenaName = config.arenas[arenaID].nome
--             local cofre = arena[arenaID].cofreArena
--         --    print(json.encode(id2))
--         --    print(id2)

--             -- if id2 then
        
--                 -- local count = 0
--                 -- local user_list = {}
--                 -- for k,v in pairs(scoreboard) do
--                 --     if v.arena == arenaID then
--                 --         user_list[count] = { user_id = v.user_id, kills = v.kills, identidade = v.identity.nome.." "..v.identity.sobrenome, killStreak = playerDeaths[user_id] }

--                 --         count = count + 1
--                 --     end
--                 -- end

--                 local query = vRP.query('vRP/getRankTopTen',{})

--                 local user_list = {}
--                 if #query > 0 then
--                     for i=1,10 do
--                         local user = query[i]['user_id']
--                         local identity = {
--                             id = query[i]['user_id'],
--                             name = query[i]["name"],
--                             name2 = query[i]["name2"]
--                         }
                
--                         local kills = query[i]['kills']
--                         if kills == 0 then
--                             kills = 4000 
--                         end
            
--                         local deaths = query[i]['deaths']
--                         if deaths == 0 then
--                             deaths = 4000
--                         end
            
--                         local kd_real = kills / deaths
--                         user_list[i] = { name = identity['name'], surname = identity['name2'], kills = vRP.format(query[i]['kills']), deaths = vRP.format(query[i]['deaths']), kills_deaths = round(kd_real,2) }
--                     end
--                 end


--                 return { arenaName,vRP.format(cofre) },user_list
--             -- else
--             --     vCLIENT.matoumortet(source)
--             --     nue2[source] = false
--             -- end
--         end
--     end
    
-- end


-- local nue2 = {}

-- RegisterCommand("rankk", function(source, args, rawCmd)
--     source = source
--     if nue2[source] then
--         vCLIENT.matoumortet(source)
--         nue2[source] = false
--     else
--         nue2[source] = true 
--         vCLIENT.matoumorte(source)
--     end
-- end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- OUTROS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if autenticado then
            for k,v in pairs(arena) do
                if arena[k] ~= nil then
                    arena[k] = { cofreArena = arena[k].cofreArena, jogadores = arena[k].jogadores, tempo = arena[k].tempo - 1}

                    if arena[k] ~= nil and arena[k].jogadores <= 0 then
                        config.lang['arenaCancelada'](config.arenas[k].nome)
                        arena[k] = nil
                    end

                    if arena[k] ~= nil and arena[k].tempo <= 0 then
                        encerrarArena(k)
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

function src.getTimeArena(id)
    if autenticado then
        if arena[id] ~= nil then
            return arena[id].tempo
        end
    end
end

function sendToDiscord(weebhook, message)
    PerformHttpRequest(weebhook, function(err, text, headers) end, 'POST', json.encode({embeds = message}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler("vRP:playerLeave",function(user_id,source)
    if autenticado then
        if user_id then
            if inArena[user_id] ~= nil then
                if arena[parseInt(inArena[user_id])] ~= nil then
                    arena[parseInt(inArena[user_id])] = { cofreArena = arena[parseInt(inArena[user_id])].cofreArena, jogadores = arena[parseInt(inArena[user_id])].jogadores - 1, tempo = arena[parseInt(inArena[user_id])].tempo }
                end
                removeScoreboard(inArena[user_id], user_id)
                inArena[user_id] = nil

                SetPlayerRoutingBucket(source, 0)
                if config.voip == "pma-voice" then
                    exports["pma-voice"]:updateRoutingBucket(source, 0)
                end 
                
                if config.forceClearWeapons then
                    vRP.limparArmas(user_id)
                end
            end
        end
    end
end)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(config.cmdarena, function(source,args)
    local user_id = vRP.getUserId(source)
    if user_id then
        if inArena[user_id] ~= nil then
            sairArena(user_id)
        end
    end
end) 

RegisterCommand(config.cmdkickarena, function(source,args)
    if source <= 0 then
        for k,v in pairs(inArena) do
            async(function()
                local player = vRP.getUserSource(parseInt(k))
                if player then
                    sairArena(parseInt(k))
                end
            end)
        end

        print("Jogadores Kickados da Arena")
        return
    end
    
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, config.permKick) then
            for k,v in pairs(inArena) do
                async(function()
                    local player = vRP.getUserSource(parseInt(k))
                    if player then
                        sairArena(parseInt(k))
                    end
                end)
            end

            config.lang['kickAllArena'](source)
        end
    end
end) 