local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vRPclient = Tunnel.getInterface("vRP")
cnCR = {}
Tunnel.bindInterface("assassino",cnCR)

-----------------------------------------------------------------------------------------------------------------------------------------
-- Busca
---------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("queryPassport", "SELECT * FROM vrp_user_identities WHERE user_id = @user_id")
vRP.prepare("queryCacador", "SELECT * FROM elite_assassino_user")
vRP.prepare("queryCacadorAtivo", "SELECT c.id AS assassino_id, vui.name,vui.firstname, vui.phone as phone, c.ativo, c.user_id, ch.id AS hierarquia_id, ch.nome AS hierarquia_nome, ch.altera AS permite_alterar  FROM elite_assassino_user c INNER JOIN vrp_user_identities vui ON c.user_id = vui.user_id  INNER JOIN elite_assassino_hierarquia ch ON ch.id = c.hierarquia_id WHERE c.ativo = 'S' ")

vRP.prepare("queryProcurados", "SELECT * FROM elite_cprocurado")	
vRP.prepare("queryHierarquia", "SELECT * FROM elite_assassino_hierarquia")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Update/inserts
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("insertCacador", "INSERT INTO elite_assassino_user (user_id, ativo, hierarquia_id) VALUES ( @user_id, 'S', @hierarquia_id) ")	

vRP.prepare("updateCacador", "DELETE FROM elite_assassino_user where id = @id ")	        

vRP.prepare("updateHierarquiaCacador", "UPDATE elite_assassino_user set hierarquia_id = @hierarquia_id where id = @id ")	                    
             
vRP.prepare("insertCacadorHierarquia", "INSERT INTO elite_assassino_hierarquia (nome, altera) VALUES ( @nome, 'N') ")	

vRP.prepare("updateCacadorHierarquia", "UPDATE elite_assassino_hierarquia set nome = @nome, altera = @altera where id = @id ")	                   

vRP.prepare("insertRecompensa", "INSERT INTO elite_cprocurado (user_id, recompensa, name, firstname, motivo) VALUES ( @user_id, @recompensa, @name, @firstname, @motivo) ")	

vRP.prepare("updateRecompensa", "UPDATE elite_cprocurado set recompensa = @recompensa where procurado_id = @id ")	

vRP.prepare("removeProcurado", "DELETE FROM elite_cprocurado where procurado_id = @id ")	
             
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getPassport
-----------------------------------------------------------------------------------------------------------------------------------------
function cnCR.getPass(user_id)
	return vRP.query("queryPassport", {user_id = user_id})
end	

function cnCR.addCacador (user_id, hierarquia_id)
    vRP.execute('insertCacador', {user_id = user_id, hierarquia_id = hierarquia_id})
    return true    
end

function cnCR.updateCacador (id, status)
    vRP.execute('updateCacador', {ativo = status, id = id})
    return true    
end

function cnCR.updateHierarquiaCacador (id, hierarquia_id)
    vRP.execute('updateHierarquiaCacador', {hierarquia_id = hierarquia_id , id = id})
    return true    
end

function cnCR.getCacadores()
return vRP.query("queryCacadorAtivo", {})
end

function cnCR.getProcurados()
    return vRP.query("queryProcurados", {})

end

function cnCR.insertHierarquia(nome, id, altera)
    if id > 0 then 
        vRP.execute('updateCacadorHierarquia', {nome = nome, id = id, altera = altera})
    else 
       vRP.execute('insertCacadorHierarquia', {nome = nome})
    end
end 

function cnCR.updateRecompensa (id, recompensa)
    vRP.execute('updateRecompensa', { id = id, recompensa = recompensa})
    return true    
end

function cnCR.getHierarquia()
    return vRP.query("queryHierarquia", {})
end

function cnCR.insertRecompensa(user_id, recompensa, motivo)
    local playerWanted = vRP.getUserSource(parseInt(user_id))
    local identity = vRP.getUserIdentity(user_id)
    local PassaporteWanted = vRP.getUserId(playerWanted)
    local name = identity.name
    local firstname = identity.firstname
    if playerWanted then
        vRP.setUData(PassaporteWanted,"vRP:Procurado",99999999999)
        TriggerClientEvent('Procurado:IniciouProcura',playerWanted,true) 
        TriggerClientEvent("vrp_sound:source",playerWanted,'jaildoor',0.7)
        -- SendWebhookMessage(config.logaddprocurado,'```prolog\n---------------[Policial que executou a ação]--------------- \n\n[Passaporte]: ' .. user_id .. ' \n[Nome]: Nome ' ..getUserNomeCompleto(user_id)..'\n\n\n---------------[Cidadão na lista de procurados]--------------- \n[Passaporte]: ' .. PassaporteWanted .. ' \n[Nome]:' ..getUserNomeCompleto(PassaporteWanted)..' \n[Registro]: '..identityWanted.registration..' \n\n[Crimes Cometidos]: ' .. crimes .. '```')
        TriggerClientEvent('Notify',source, 'sucesso', 'Passaporte ' ..PassaporteWanted..',\n\n Nome: '..identity.name..identity.firstname..', adicionado a lista de procurados',15000)
    end
    return vRP.execute("insertRecompensa", {user_id = user_id, recompensa = recompensa, name = name, firstname = firstname, motivo = motivo })
end

function cnCR.removeProcurado(id)
    local passaporteRem = id
    if tonumber(passaporteRem) then
        local playerWanted = vRP.getUserSource(parseInt(passaporteRem))
        local PassaporteWanted = vRP.getUserId(playerWanted)
        local identityWanted = vRP.getUserIdentity(PassaporteWanted)
        if playerWanted then
            vRP.setUData(PassaporteWanted,"vRP:Procurado",0)
            TriggerClientEvent('tirandoprocurado',playerWanted,true)
            -- SendWebhookMessage(config.logremprocurado,'```prolog\n---------------[Quem removeu da lista de procurados]--------------- \n\n[Passaporte]: ' .. user_id .. ' \n[Nome]: Nome ' ..getUserNomeCompleto(user_id)..'\n\n---------------[Cidadão removido da lista de procurados]--------------- \n[Passaporte]: ' .. PassaporteWanted .. ' \n[Nome]:' ..getUserNomeCompleto(PassaporteWanted)..' \n[Registro]: '..identityWanted.registration..' \n\n[Motivo da remoção]: ' .. motivo .. '```')
            -- TriggerClientEvent('Notify',source, 'sucesso', 'Passaporte ' ..PassaporteWanted..',\n\n Nome: '..getUserNomeCompleto(playerWanted)..', não está mais procurado',15000)
        end
    end
    vRP.execute("removeProcurado", {id = id })
end
function cnCR.removeProcuradoHack(id)
    vRP.execute("removeProcurado", {id = id })
end

function cnCR.pagamentoRecompensa(valor, id, user_id )
    bankMoney = vRP.getBankMoney(user_id)
    amount = tonumber(valor)
    newBankMoney = tonumber(bankMoney + amount)
	vRP.setBankMoney(user_id, newBankMoney)
    vRP.execute("removeProcurado", {id = id })
    local identity = vRP.getUserIdentity(user_id)
    TriggerClientEvent("Notify",user_id,"sucesso","Pegue R$"..vRP.format(parseInt(valor)).." Reais com o Polícial "..identity.name..identity.firstname.." por sua recompensa ao capturar um procurado.", 10000)			
end 


function cnCR.ValidationUser( )
    local validado = false
    local source = source
    local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("queryCacadorAtivo",{ user_id = user_id })
    if #rows > 0  then
        for k, v in pairs(config.permissaoBlip) do
            if vRP.hasPermission(user_id,v) then
                validado = true
            end
        end
        return validado
    end
end 

function cnCR.ValidationUserRemote( )
    local validado = false
    local source = source
    local user_id = vRP.getUserId(source)
    local assassino = cnCR.ValidationUser()
    if assassino then 
        validado = true
    else 
        for k, v in pairs(config.permissaoComando) do
            if vRP.hasPermission(user_id,v) then
                validado = true
            end
        end
    end
    return validado
end 

function cnCR.permiteAlterar( )
    local Alterar = false
    local source = source
    local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("queryCacadorAtivo",{ user_id = user_id })
    for k, v in pairs(config.permissaoAlterar) do
        if vRP.hasPermission(user_id,v) then
            Alterar = true
        end
        if  #rows > 0  then
            if rows[1].permite_alterar == 'S' then 
            Alterar = true
            end
        end
        return Alterar
    end
end 

function cnCR.permitirPolicia( )
    local validado = false
    local source = source
    local user_id = vRP.getUserId(source)
    for k, v in pairs(config.permissaoPolicia) do
        if vRP.hasPermission(user_id,v) then
            validado = true
        end
    end
    return validado
end 


RegisterServerEvent('Procurado:rProcurado') -- Evento para usar o item remover o procurado com taskbar e em lugar específico
AddEventHandler('Procurado:rProcurado',function()
    local source = source
    local user_id = puxarID(source)
    if user_id then
        TriggerClientEvent('tirandoprocurado',source,true)
        TriggerEvent('remprocuradoevento',source, true)
    end
end)

RegisterServerEvent('remprocuradoevento')
AddEventHandler('remprocuradoevento',function(source,user_id)
    local source = source
    local user_id = puxarID(source)
    if user_id then
        setarUserData(user_id,"vRP:Procurado",0)
    end
end)


RegisterServerEvent('item_r_Procurado') -- Evento para usar o item remover o procurado com taskbar e em lugar específico
AddEventHandler('item_r_Procurado',function()
    local source = source
    local user_id = puxarID(source)
    local identity = pegarIdentidade(user_id)
    local x, y, z = pegarPosicao(source)
    if user_id then
        if verificarItemInventario(user_id, config.item) >= config.amount then
            if puxarItemDoInventario(user_id, config.item, config.amount) then
                local taskbarresult = exports['c2n_taskbar']:getTaskBar(source,"facil","Ocenside")
                if taskbarresult then
                    TriggerClientEvent('cancelando', source, true)
                    config.startanim2(source)
                    TriggerClientEvent("progress", source, 2000, "HACKEANDO")
                    SetTimeout(2000, function()
                        TriggerClientEvent('tirandoprocurado',source,true)
                        TriggerEvent('remprocuradoevento',source, true)
                        vRP.execute("removeProcurado", {user_id = user_id })
                        setarUserData(user_id,"vRP:Procurado",0)
                        TriggerClientEvent("vrp_sound:source", source, 'finish', 0.5)
                        TriggerClientEvent('cancelando', source, false)
                        config.stopanim2(source)
                        SendWebhookMessage(config.hackersucess,"```prolog\n[ID]: "..user_id.." "..getUserNomeCompleto(user_id).." \n[LOCALIZAÇÃO] ".. x.. ", "..y..", "..z.." \nHACKEOU O SISTEMA DA POLÍCIA E TIROU SEU NOME DA LISTA DE PROCURADOS  "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                    end)
                else
                    local policia = PermissoesDeUsers(config.policiapermissao)
                    local x, y, z = pegarPosicao(source)
                    for k, v in pairs(policia) do
                        local player = vRP.getUserSource(parseInt(v))
                        if player then
                            local data = { x = x, y = y, z = z, title = config.titulo2, code = config.codigo2, veh = config.textonotify2 }
                            TriggerClientEvent('NotifyPush',player,data)
                        end
                    end
                    SendWebhookMessage(config.hackerfail,"```prolog\n[ID]: "..user_id.." "..getUserNomeCompleto(user_id).." \n[LOCALIZAÇÃO] ".. x.. ", "..y..", "..z.." \nFALHOU AO HACKEAR O SISTEMA DA POLÍCIA"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                    TriggerClientEvent("Notify",source,"negado","Você falhou ao tentar hacker o sistema da polícia",5000)
                    TriggerClientEvent('Notify',source, 'aviso',textolocalizado2,9000)
                end
            end 
        else
            TriggerClientEvent("Notify",source,"negado","Item insuficiente.",5000)
        end
    end
end)

RegisterServerEvent('item_r_ProcuradoSimples') -- Evento para usar o item remover o procurado sem taskbar e em lugar específico
AddEventHandler('item_r_ProcuradoSimples',function()
    local source = source
    local user_id = puxarID(source)
    local identity = pegarIdentidade(user_id)
    if user_id then
        if verificarItemInventario(user_id, config.item) >= config.amount then
            if puxarItemDoInventario(user_id, config.item, config.amount) then
                TriggerClientEvent('cancelando', source, true)
                config.startanim2(source)
                TriggerClientEvent("progress", source, 15000, "HACKEANDO")
                SetTimeout(15000, function()
                    TriggerClientEvent('tirandoprocurado',user_id,true)
                    setarUserData(user_id,"vRP:Procurado",0)
                    TriggerClientEvent("vrp_sound:source", source, 'finish', 0.5)
                    TriggerClientEvent('cancelando', source, false)
                    config.stopanim2(source)
                    SendWebhookMessage(config.hackersucess,"```prolog\n[ID]: "..user_id.." "..getUserNomeCompleto(user_id).." \n[LOCALIZAÇÃO] ".. x.. ", "..y..", "..z.." \nHACKEOU O SISTEMA DA POLÍCIA E TIROU SEU NOME DA LISTA DE PROCURADOS  "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                end)
            end
        else
            TriggerClientEvent("Notify",source,"negado","Item insuficiente.",5000)
        end 
    end
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    local playerWanted = vRP.getUserSource(parseInt(user_id))
    if playerWanted then
        SetTimeout(10000,function()
            local value = pegarUserData(parseInt(user_id),"vRP:Procurado")
            local tempo = json.decode(value) or -1
        
            if tempo == -1 then
                return
            end
        
            if tempo > 0 then
                TriggerClientEvent('Procurado:IniciouProcura',playerWanted,true)
            end
        end)
    end
end)
------------------------------------------------------------------------------------
------ [ Função para chamar a polícia ] --------------------------------------------
------------------------------------------------------------------------------------

function cnCR.chamouPolicia1()
    local policia = PermissoesDeUsers(config.recebeChamados)
    local x, y, z = pegarPosicao(source)
    for k, v in pairs(policia) do
        local player = vRP.getUserSource(parseInt(v))
        if player then
            local data = { x = x, y = y, z = z, title = config.titulo, code = config.codigo, veh = config.textonotify }
            TriggerClientEvent('NotifyPush',player,data)
        end
    end
end

function cnCR.chamouPolicia2() 
    local policia = PermissoesDeUsers(config.recebeChamados)
    local x, y, z = pegarPosicao(source)
    for k, v in pairs(policia) do
        local player = vRP.getUserSource(parseInt(v))
        if player then
            local data = { x = x, y = y, z = z, title = config.titulo2, code = config.codigo2, veh = config.textonotify2 }
            TriggerClientEvent('NotifyPush',player,data)
        end
    end
end

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	print(resourceName,'^2INICIADO^0')
	Wait(10000)
	print( "[+] ^2Autenticado^0 - Qualquer dúvida entre em contato com -> ^4DoSantos#2208.")
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	print(resourceName,'^1PARADO^0')
end)