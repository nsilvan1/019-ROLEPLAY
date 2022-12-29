local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

sRP = {}
Tunnel.bindInterface("CruzRoubos",sRP)

vCLIENT = Tunnel.getInterface("CruzRoubos")

-- [CONFIG WEBHOOCK] --

local lojadepartamento = "https://discord.com/api/webhooks/1055530300878372986/JZ5W6ne6recOOqtW58o7hrKC0uvJaCFQN2HzcfKRZrue700XNiKgoISvZmA0hWl9TQzI"
local registradora = "https://discord.com/api/webhooks/1055530245417074758/0fOLPumyUFonmGdc-TF1rwQi9eBRu8EaOpZGHziNKpPzt4yzylifJDAdM-zE-TJPWcT4"
local caixa = "https://discord.com/api/webhooks/1055530175724535848/fBVjth0gKiEoPjiLo7ChPkdPkv0USvLtVk2ANxkZhv3IqgPq8bBZqNkH6FDTADFJybiA"
local bancopalleto = "https://discord.com/api/webhooks/1055530506852257802/zJW_CbVdc0Jfy-wTL4a0dAMJrjSHlRxKeNjDdbJZ2A_gux9LDQsGzyzx4T9obuywOG3W"
local banco = "https://discord.com/api/webhooks/1055530506852257802/zJW_CbVdc0Jfy-wTL4a0dAMJrjSHlRxKeNjDdbJZ2A_gux9LDQsGzyzx4T9obuywOG3W"
local AmmuNation = "https://discord.com/api/webhooks/1055530119432781984/CziWEkBXoX18pu597lqDv5nhi0qRUpFoJEkL1KWs_xZC1YkY7dYXYrVFOUEdmOZbfMzN"


function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

local ultimoAssaltoHora = {}
local recompensa = {}
local assalto = {}
local tempoAssalto = {}

local policias = nil

function sRP.startRobbery(rouboJson, setupJson)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if user_id then
        local v = json.decode(rouboJson)
        local setup = json.decode(setupJson)    
        for k,c in pairs(setup) do
            Wait(1)
            if k == v.type then
                policias = vRP.getUsersByPermission("policia.permissao")
                --if not vRP.searchReturn(source,user_id) then
                    if #policias < c.lspd then
                        TriggerClientEvent("Notify",source,"negado", "Necessários "..c.lspd.." <b>Políciais</b> para iniciar o roubo.")
                    else
                        if sRP.isEnabledToRob(k,v["id"], c.tempoEspera) then
                            if sRP.hasNecessaryItemsToRob(user_id, c) then

                            -- TODO: Implementar sistemas da checklist...
                            local time = c.tempoEspera * 60 / 2
                            vRP.searchTimer(user_id,parseInt(time))
                            ultimoAssaltoHora[v["id"]] = os.time()
                            recompensa[user_id] = c
                            tempoAssalto[user_id] = c.tempo
                            assalto[k] = true


                            SetTimeout(c.tempo * 1,function()
                                assalto[k] = false
                            end)
                
                            vRPclient._playAnim(source,false,{{"anim@heists@ornate_bank@grab_cash_heels","grab"}},true)

                            vCLIENT.iniciandoRoubo(source,v.x, v.y, v.z, c.tempo, v.h)
                                
                            sRP.avisarPolicia("Roubo em Andamento", "Assalto a "..v.type.." em andamento, verifique o ocorrido.", v.x, v.y, v.z, v.type)
							
							
							if v.type == "Loja De Departamento" then
								SendWebhookMessage(lojadepartamento,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ROUBO]: Loja De Departamento "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")                                     
							elseif v.type == "registradora" then
								SendWebhookMessage(registradora,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ROUBO]: Registradora "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							elseif v.type == "caixa" then
								SendWebhookMessage(caixa,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ROUBO]: Caixa "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							elseif v.type == "banco" then
								SendWebhookMessage(banco,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ROUBO]: Banco "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							elseif v.type == "bancopalleto" then
								SendWebhookMessage(bancopalleto,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ROUBO]: Banco Palleto "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")							
							elseif v.type == "AmmuNation" then							
								SendWebhookMessage(AmmuNation,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ROUBO]: AmmuNation "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							end
							
							
                            else
                                TriggerClientEvent("Notify", source, "sucesso", "Você não conseguiu abrir o cofre, é melhor correr!")
                            end
                        else
                            local tempoRestante = sRP.getRemaningTime(k,v["id"], c.tempoEspera)
                            TriggerClientEvent("Notify", source, "sucesso", "Você ainda deve aguardar "..tempoRestante.." segundos para realizar a ação.")
                        end
                    end
                end
            end
        end
    end
--end


function sRP.getRemaningTime(k, user_id,tempoEspera)
    local t = ((os.time() - ultimoAssaltoHora[user_id]) - tempoEspera * 60) * -1
    return t
end

function sRP.isEnabledToRob(k, user_id, tempoEspera)
    if ultimoAssaltoHora[user_id] then
        if (os.time() - ultimoAssaltoHora[user_id]) < tempoEspera * 60 then
            return false
        else
            return true
        end
    end
    return true
end

function sRP.givePayment()
    local source = source 
    local user_id = vRP.getUserId(source)
    if user_id then
        for n,i in pairs(recompensa[user_id].items) do
            local pagamento = math.random(i.min,i.max)
            vRP._giveInventoryItem(user_id,n,parseInt(pagamento),true)
        end
        recompensa[user_id] = nil
        tempoAssalto[user_id] = nil
    end
end

function sRP.hasNecessaryItemsToRob(user_id, c)
    local source = vRP.getUserSource(user_id)
    local pica = json.encode(c.itemsNecessarios)
    local picapica2 = json.decode(pica)
    if c.itemsNecessarios then
        local itensNecessarios = #c.itemsNecessarios
        local count = 0
        for k,v in pairs(c.itemsNecessarios) do
            if vRP.getInventoryItemAmount(user_id,k) >= parseInt(v.qtd) then 
                vRP.tryGetInventoryItem(user_id,k,v.qtd,true)
                return true 
            else
                TriggerClientEvent("Notify",source, "sucesso", "Você precisa de "..v.qtd.."x <b>"..vRP.itemNameList(k).."</b> para iniciar")
                return false
            end
        end
    end
    return true
end

function sRP.avisarPolicia(titulo, msg, x, y, z, name)
	for l,w in pairs(policias) do
		local player = vRP.getUserSource(parseInt(w))
		if player then
			async(function()
                TriggerClientEvent('blip:criar:roubo',player,x,y,z)
				vRPclient.playSound(player,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
				TriggerClientEvent('chatMessage',player,"911",{64,64,255},"Esta havendo um assalto na "..name..", dirija-se até o local e intercepte o assaltante.")
				SetTimeout(45000, function()
                TriggerClientEvent('blip:remover:roubo',player)
                TriggerClientEvent('chatMessage',player,"190",{64,64,255},"O assaltante saiu correndo e deixou tudo para trás.") 
end)
			end)
		end
    end
end

function sRP.cancelRobbery()
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then
        for n,i in pairs(recompensa[user_id].items) do
            local pagamento = math.random(i.min,i.max)
            vRP._giveInventoryItem(user_id,n,parseInt(pagamento)/10,true)
        end

        tempoAssalto[user_id] = nil
        recompensa[user_id] = nil
        local policia = vRP.getUsersByPermission("policia.permissao")
        for l,w in pairs(policia) do
			local player = vRP.getUserSource(parseInt(w))
			local playerId = vRP.getUserId(player)
            if player then
				async(function()
                    TriggerClientEvent('blip:remover:roubo',player)
                    TriggerClientEvent('chatMessage',player,"190",{64,64,255},"O assaltante saiu correndo e deixou tudo para trás.")
                     
				end)
			end
		end
    end
end