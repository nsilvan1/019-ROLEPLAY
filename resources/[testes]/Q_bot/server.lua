local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local prefix = "bot:"
local responsePrefix = "bot:response:"

-- COMMANDS --

function log(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterServerEvent(prefix .. "kick")
AddEventHandler(prefix .. "kick", function(id, reason)
    local source = vRP.getUserSource(parseInt(id))
    if (source) then
        vRP.kick(source, reason)
    end
end)

RegisterServerEvent(prefix .. "ban")
AddEventHandler(prefix .. "ban", function(id, reason, adminId)
    local source = vRP.getUserSource(parseInt(id))
    vRP.setBanned(parseInt(id), true)
    if (source) then
        vRP.kick(source, reason)
    end
end)

RegisterServerEvent(prefix .. "unban")
AddEventHandler(prefix .. "unban", function(id, reason, adminId)
    vRP.setBanned(parseInt(id), false)
end)

RegisterServerEvent(prefix .. "group")
AddEventHandler(prefix .. "group", function(id, group, adminId)
    vRP.addUserGroup(parseInt(id), group)
end)

RegisterServerEvent(prefix .. "ungroup")
AddEventHandler(prefix .. "ungroup", function(id, group, adminId)
    vRP.removeUserGroup(parseInt(id), group)
end)

RegisterServerEvent(prefix .. "money")
AddEventHandler(prefix .. "money", function(id, money, adminId)
    vRP.giveMoney(id, parseFloat(money))
end)

RegisterServerEvent(prefix .. "skin")
AddEventHandler(prefix .. "skin", function(id, skin)
    nplayer = vRP.getUserSource(parseInt(id))

    if skin == "homem" then
        skin = "mp_m_freemode_01"
    elseif skin == "mulher" then
        skin = "mp_f_freemode_01"
    elseif skin == "ron" then
        skin = "Ron Weasley"
    elseif skin == "harry" then
        skin = "Harry Suit"
    end
    TriggerClientEvent("skinmenu", nplayer, skin)
    vRPclient.killGod(nplayer)
    vRPclient.setHealth(nplayer, 400)
    TriggerClientEvent("resetBleeding", nplayer)
    TriggerClientEvent("resetDiagnostic", nplayer)
end)

RegisterServerEvent(prefix .. "resetp")
AddEventHandler(prefix .. "resetp", function(id)
    vRP.execute("vRP/reset_personagem", { user_id = id })
    local userSource = vRP.getUserSource(parseInt(id))
    vRP.kick(userSource, 'Seu personagem foi resetado, faça o login novamente.')
end)

RegisterServerEvent(prefix .. "god")
AddEventHandler(prefix .. "god", function(id)
    local nplayer = vRP.getUserSource(parseInt(id))
    if nplayer then
        vRPclient.killGod(nplayer)
        vRPclient.setHealth(nplayer, 400)
        TriggerClientEvent("resetBleeding", nplayer)
        TriggerClientEvent("resetDiagnostic", nplayer)
    end
end)

RegisterServerEvent(prefix .. "gud")
AddEventHandler(prefix .. "gud", function(id)
    local nplayer = vRP.getUserSource(parseInt(id))
    if nplayer then
        vRPclient.killGod(nplayer)
        vRPclient.setHealth(nplayer, 400)
        vRPclient.setArmour(nplayer, 100)
        TriggerClientEvent("resetBleeding", nplayer)
        TriggerClientEvent("resetDiagnostic", nplayer)
    end
end)

RegisterServerEvent(prefix .. "prender")
AddEventHandler(prefix .. "prender", function(id, crimes, time)
    local nplayer = vRP.getUserSource(parseInt(id))
    local nuser_id = vRP.getUserId(nplayer)

    local player = vRP.getUserSource(parseInt(id))
    if player then
        vRP.setUData(parseInt(id), "vRP:prisao", json.encode(parseInt(time)))
        vRPclient.setHandcuffed(player, false)
        TriggerClientEvent('prisioneiro', player, true)
        vRPclient.teleport(player,cfg.locSprisao[1],cfg.locSprisao[2],cfg.locSprisao[3] )
        prison_lock(parseInt(id))
        TriggerClientEvent('removealgemas', player)
        TriggerClientEvent("vrp_sound:source", player, 'jaildoor', 0.7)

        local nplayer = vRP.getUserSource(parseInt(id))
        vRPclient.giveWeapons(nplayer, {}, true, 'ForceGiveWeapon')
        vRP.clearInventory(nuser_id)
        TriggerEvent(responsePrefix .. "prender", id, crimes, time)
        TriggerClientEvent("Notify", nplayer, "importante", "Você foi preso por <b>" .. vRP.format(parseInt(time)) .. " meses</b>.<br><b>Motivo:</b> " .. crimes .. ".")
    else
        TriggerEvent(responsePrefix .. "log",'`<@' .. author .. '> não foi possível prender o [' .. id .. ']`')
    end
end)

RegisterServerEvent(prefix .. "desprender")
AddEventHandler(prefix .. "desprender", function(id)
    local player = vRP.getUserSource(parseInt(id))
    vRP.setUData(parseInt(id),"vRP:prisao",json.encode(parseInt(0)))
    --vRPclient.setHandcuffed(player,false)
    TriggerClientEvent('prisioneiro',player,false)
    local nplayer = vRP.getUserSource(parseInt(id))
    vRPclient._playAnim(nplayer,true,{{"clothingshirt","try_shirt_positive_d"}},false)
    Citizen.Wait(2500)
    vRPclient._stopAnim(nplayer,true)
    vRP.removeCloak(nplayer)
    desprendeu(parseInt(id))
    TriggerEvent(responsePrefix .. "log",'`<@' .. author .. '> não foi possível desprender o [' .. id .. ']`')
end)

function desprendeu(target_id)
	local player = vRP.getUserSource(parseInt(target_id))
	if player then
		SetTimeout(1000,function()
			local value = vRP.getUData(parseInt(target_id),"vRP:prisao")
			local tempo = json.decode(value) or 0
			if parseInt(tempo) == 0 then
				vRPclient._playAnim(player,true,{{"clothingshirt","try_shirt_positive_d"}},false)
				Citizen.Wait(2500)
				vRPclient._stopAnim(player,true)
				vRP.removeCloak(player)
				TriggerClientEvent('prisioneiro',player,false)
				vRPclient.teleport(player,cfg.spawSprisao[1],cfg.spawSprisao[2],cfg.spawSprisao[3])
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(-1))
				TriggerClientEvent("Notify",player,"importante","Você foi solto!")
			end
			vRPclient.killGod(player)
			vRPclient.setHealth(player,400)
		end)
	end
end

RegisterServerEvent(prefix .. "staff")
AddEventHandler(prefix .. "staff", function(channel)
    local staffs = vRP.getUsersByGroup("Admin")
    local staffQuantity = 0
    local staffs_names = ""
    for k, v in ipairs(staffs) do
        local identity = vRP.getUserIdentity(parseInt(v))
        staffs_names = staffs_names .. v .. ": " .. identity.name .. " " .. identity.firstname .. "\n"
        staffQuantity = staffQuantity + 1
    end
    TriggerEvent(responsePrefix .. "staff", staffQuantity, staffs_names, channel)
end)

RegisterServerEvent(prefix .. "players")
AddEventHandler(prefix .. "players", function(channel)
    local quantidade = 0
    local players = ""
    local users = vRP.getUsers()
    for k,v in pairs(users) do
        if k ~= #users then
            players = players..", "
        end
        players = players..k
        quantidade = parseInt(quantidade) + 1
    end
    TriggerEvent(responsePrefix .. "log",'Players Conectados:'..quantidade)
end)

RegisterServerEvent(prefix .. "pegar")
AddEventHandler(prefix .. "pegar", function(userId, author)
    local target_source = vRP.getUserSource(userId)

    TriggerClientEvent('screenshot', target_source)
    TriggerEvent(responsePrefix .. "pegar", userId, author)
end)

RegisterServerEvent(prefix .. "pegarall")
AddEventHandler(prefix .. "pegarall", function(userId, author)
	local users = vRP.getUsers()
	if users then
		log(cfg.webhookTelas, "```.\n.\n.\n VERIFICAÇÃO DE TELA INICIADA\n.\n.\n.```")
		for k,v in pairs(users) do
            local use_source = vRP.getUserSource(tonumber(k))
            x,y,z = vRPclient.getPosition(use_source)
            log(cfg.webhookTelas,"```ID: " .. tonumber(k).."\nLOC: "..x..","..y..","..z.."```")
            TriggerClientEvent('screenshot',use_source)
			Citizen.Wait(2000)
        end
        log(cfg.webhookTelas, "```.\n.\n.\n VERIFICAÇÃO DE TELA FINALIZADA\n.\n.\n.```")
	end
    TriggerEvent(responsePrefix .. "pegarall", userId,author)
end)


RegisterServerEvent(prefix .. "unwl")
AddEventHandler(prefix .. "unwl", function(id)
    vRP.setWhitelisted(parseInt(id), false)
end)

RegisterServerEvent(prefix .. "addcoins")
AddEventHandler(prefix .. "addcoins", function(id, coins, author)
    if vRP.addCoinsId(id, coins) then
        --TriggerEvent(responsePrefix .. "log", '`<@' .. author .. '> removeu' .. coins .. ' coins de ' .. id .. '`')
    else
        --TriggerEvent(responsePrefix .. "log",'`<@' .. author .. '> não foi possível remover os coins de [' .. id .. ']`')
    end
end)

RegisterServerEvent(prefix .. "remcoins")
AddEventHandler(prefix .. "remcoins", function(id, coins, author)
    if vRP.remCoinsId(id, coins) then
        --TriggerEvent(responsePrefix .. "log", '`<@' .. author .. '> removeu' .. coins .. ' coins de ' .. id .. '`')
    else
        --TriggerEvent(responsePrefix .. "log",'`<@' .. author .. '> não foi possível remover os coins de [' .. id .. ']`')
    end
end)

-- COMMANDS --

-- EVENTS --

RegisterServerEvent(prefix .. "guildMemberRemove")
AddEventHandler(prefix .. "guildMemberRemove", function(id)
    local source = vRP.getUserSource(parseInt(id))
    vRP.setWhitelisted(parseInt(id), false)
    vRP.kick(source, 'Você saiu do nosso servidor do Discord e perdeu automaticamente sua WL.')
end)

vRP._prepare('getName', "SELECT CONCAT(name, ' ', firstname) AS userName FROM vrp_users WHERE id = @user_id")

RegisterNetEvent('bot:rename')
AddEventHandler('bot:rename', function(user_id, src)
    local discord = ''
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if find(id, "discord") then
            discord = id
        end
    end
    local nameQuery = vRP.query('getName', {user_id = user_id})
    local nome = nameQuery[1].userName
   --BaseClient:_Webhook(discord..' '..user_id..' '..nome)
end)