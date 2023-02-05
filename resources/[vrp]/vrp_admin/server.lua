local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {} Tunnel.bindInterface("vrp_admin",src)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare ("EG/tirarRetencao", "UPDATE vrp_user_vehicles SET detido = '0', time = '0' WHERE user_id = @nuser_id AND vehicle = @vehicle")

RegisterCommand('kickbugados',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao")then
        TriggerClientEvent('MQCU:bugado',-1)
    end
end)

RegisterServerEvent("MQCU:bugado")
AddEventHandler("MQCU:bugado",function()
    local user_id = vRP.getUserId(source)
    if user_id == nil then
        local identifiers = GetPlayerIdentifiers(source)
        DropPlayer(source,"Hoje não.")
        identifiers = json.encode(identifiers)
        print("Player bugado encontrado: "..identifiers)
    end
end)

RegisterCommand('iplspawn', function(source,args)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, 'ceo.permissao') then
        TriggerClientEvent('EG:setipl', -1, args[1], args[2])
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CRASH ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('crash',function(source,args)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"ceo.permissao") then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            TriggerClientEvent('crash',nplayer)
            sendLog('LogCrash',"[ID]: "..user_id.."\n[CRASHOU]: "..args[1].."",true)
        end
    end
end)

------------------------------------------------------------------------------
---- 30s    
------------------------------------------------------------------------------
RegisterCommand('30s',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRPclient.getNearestPlayer(source,2)
    local nuser_id = vRP.getUserId(nplayer)
    if vRP.hasPermission(user_id,"policia.permissao") then
        TriggerClientEvent("Notify",source,"negado","Importante","Contagem dos 30 segundos de ação")
        TriggerClientEvent("Notify",nplayer,"importante","Contagem dos 30 segundos de ação iniciada")
        TriggerClientEvent("Notify",source,"importante","Contagem dos 30 segundos de ação iniciada")
        TriggerClientEvent("progress",source,30000,"Iniciar Ação")
        TriggerClientEvent("progress",nplayer,30000,"Iniciar Ação")
    else
        TriggerClientEvent("Notify",source,"negado","Negado","Você não tem permissão para acessar esse comando.")
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DM (MENSAGEM PRIVADA) 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dm',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserSource(parseInt(args[1]))
    local identity = vRP.getUserIdentity(user_id)
    local identitynu = vRP.getUserIdentity(nuser_id)
    local nplayer_id = vRP.getUserId(nplayer)

    if vRP.hasPermission(user_id,"ac.permissao") then
        if args[1] == nil then
            TriggerClientEvent("Notify",source,"negado","Necessário passar o ID após o comando, exemplo: <b>/dm 1</b>")
            return
        elseif nplayer == nil then
            TriggerClientEvent("Notify",source,"negado","O jogador não está online!")
            return
        end
        local mensagem = vRP.prompt(source,"Digite a mensagem:","")
        if mensagem == "" then
            return
        end
        TriggerClientEvent('chatMessage',nplayer,"MENSAGEM DA ADMINISTRAÇÃO:",{255,0,0},mensagem)
        TriggerClientEvent('smartphone:createSMS',nplayer, 'PREFEITURA', mensagem)
        sendLog('LogDm',"[ID]: "..user_id.."\n[MANDOU DM PARA]: "..nplayer_id.."\n[MENSAGEM]: "..mensagem.."",true)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ VROUPAS ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local player_customs = {}
RegisterCommand('vroupas',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	local custom = vRPclient.getCustomization(source)
	
    if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
        if player_customs[source] then
            player_customs[source] = nil
            vRPclient._removeDiv(source,"customization")
        else 
			local content = ""
			-- [3] = { 4,0 },
            for k,v in pairs(custom) do
                -- content = content..k.." => "..json.encode(v).."<br/>" 
                content = content.."["..k.."] = {"..json.encode(v).."}\n" 
            end
            
            vRP.prompt(source, "Roupas", content)
            player_customs[source] = true
            -- vRPclient._setDiv(source,"customization",".div_customization{ margin: auto; padding: 4px; width: 250px; margin-top: 200px; margin-right: 50px; background: rgba(15,15,15,0.7); color: #ffff; font-weight: bold; }",content)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ BLIPS ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        blips[source] = { source }
       TriggerClientEvent("blips:updateBlips",-1,blips)
        if vRP.hasPermission(user_id,"blips.permissao") then
            TriggerClientEvent("blips:adminStart",source)
        end
     end
 end)

AddEventHandler("playerDropped",function()
	if blips[source] then
		blips[source] = nil
		TriggerClientEvent("blips:updateBlips",-1,blips)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ LOG PRINT SCREEN ]-------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
--     Citizen.Wait(10000)
--     local source = source
--     local user_id = vRP.getUserId(source)
--     if user_id then
--         exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(source,logPrintJoin, {encoding = "png", quality = 1},
--             {username = "ANTIHACK DU EG", avatar_url = "https://cdn.discordapp.com/attachments/829108445747478538/832089319958904872/eglogo2.png", content = "```prolog\n======[ENTROU NA CIDADE]====== \n[ID]: "..user_id..""..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").."```"},
--             function(error)
--                 if error then
--                     return print("ERROR: " .. error)
--                 end
--         end)
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adm',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local identity = vRP.getUserIdentity(user_id)
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(255,0,0,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 18%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 15px; }","<bold>"..mensagem.."</bold><br><br>Mensagem da Administração")
		

        sendLog('LogAdmMsg',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MANDOU NO /ADM]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
    
		SetTimeout(30000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mod',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"mod.permissao") then
		local identity = vRP.getUserIdentity(user_id)
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(0,255,0,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 18%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 15px; }","<bold>"..mensagem.."</bold><br><br>Mensagem da Moderação")
		
        sendLog('LogMod',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MANDOU NO /MOD]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
        SetTimeout(30000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- GOVERNADOR ---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('governador',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ceo.permissao") then
		local identity = vRP.getUserIdentity(user_id)
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(218,165,32,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 18%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 15px; }","<bold>"..mensagem.."</bold><br><br>Mensagem do Governador")
		
        sendLog('LogGovernadorMsg',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MANDOU NO /MOD]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
        SetTimeout(30000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK SOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kicksrc",function(source,args,command)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if user_id then
        if vRP.hasPermission(user_id,"ac.permissao")then
            local nuser_id = vRP.getUserId(args[1])
            DropPlayer(args[1],"VOCE FOI KIKADO!")
            sendLog('LogkickSrc',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[KIKOU A SOURCE]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIRAR DETIDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tdetido",function(source,args,command)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if user_id then
      if vRP.hasPermission(user_id,"admin.permissao")then
        if args[1] then
            if args[2] then
                local nuser_id = parseInt(args[1])
                local vehicle = args[2]
                vRP.execute("EG/tirarRetencao", {nuser_id=nuser_id,vehicle=vehicle})
                TriggerClientEvent("Notify",source,"sucesso","Você removeu a detenção do carro: "..vehicle.." do ID: "..nuser_id..".") 
                sendLog('logRetirarDetido',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU O DETIDO DO CARRO]: "..args[2].." \n[DO ID]: "..parseInt(args[1]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
            else
                TriggerClientEvent("Notify",source,"negado","Você não adicionou o carro da pessoa.") 
            end
        else
            TriggerClientEvent("Notify",source,"negado","Você não adicionou o passaporte da pessoa.") 
        end
      end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DVAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dvarea',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"mod.permissao")  then
        local x,y,z = vRPclient.getPosition(source)
        TriggerClientEvent('dvarea', source, args[1], x, y, z)
    else
        TriggerClientEvent("nyo_notify",source, "#8B0000","Negado", "SEM PERMISSÃO", 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD CAR
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare ("EG/add_vehicleLeads","INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,ipva,free,free_time) VALUES(@user_id,@vehicle,@ipva,@free,@free_time)")
RegisterCommand('addcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserId(parseInt(args[2]))
    if vRP.hasPermission(user_id,"ceo.permissao") then
        if args[1] and args[2] then
            local nuser_id = parseInt(args[2])
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(parseInt(args[2]))
            vRP.execute("EG/add_vehicleLeads",{ user_id = parseInt(args[2]),  vehicle = args[1], ipva = os.time(), free = 1, free_time = os.time() }) 
            sendLog('LogAddCar',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true) 
            TriggerClientEvent("nyo_notify",source, "#00FF00","Sucesso", "Voce adicionou o veículo <b>"..args[1].."</b> para o Passaporte: <b>"..parseInt(args[2]).."</b>.", 5000)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REM CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('remcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserId(parseInt(args[2]))
    if vRP.hasPermission(user_id,"ceo.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            vRP.execute("creative/rem_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time())  }) 
                TriggerClientEvent("nyo_notify",source, "#00FF00","Sucesso", "Voce removeu o veículo <b>"..args[1].."</b> do Passaporte: <b>"..parseInt(args[2]).."</b>.", 5000)
                sendLog('LogRemCar',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
			end
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ UNCUFF ]------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('uncuff',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"mod.permissao") then
			TriggerClientEvent("admcuff",source)
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ SYNCAREA ]----------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limpararea',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
    if vRP.hasPermission(user_id,"mod.permissao") then
        TriggerClientEvent("syncarea",-1,x,y,z)
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ APAGAO ]------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('apagao',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"ceo.permissao") and args[1] ~= nil then
            local cond = tonumber(args[1])
            TriggerClientEvent("cloud:setApagao",-1,cond)                    
        end
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ RAIOS ]-------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('raios', function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"ceo.permissao") and args[1] ~= nil then
            local vezes = tonumber(args[1])
            TriggerClientEvent("cloud:raios",-1,vezes)           
        end
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ TROCAR SEXO ]--------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('skinped',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"ceo.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
        if parseInt(args[1]) then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("skinmenu",nplayer,args[2])
                TriggerClientEvent("Notify",source,"sucesso","Voce setou a skin <b>"..args[2].."</b> no passaporte <b>"..parseInt(args[1]).."</b>.")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ PLAYERS ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('players',function(source,args,rawCommand)
	local onlinePlayers = GetNumPlayerIndices()
	TriggerClientEvent('chatMessage',source,"ALERTA",{255,70,50},"Jogadores online: "..onlinePlayers)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ DEBUG ]-------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('debug',function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
			TriggerClientEvent("ToggleDebug",player)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRYDELETEOBJ ]-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj",function(index)
    TriggerClientEvent("syncdeleteobj",-1,index)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ FIX ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fix',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local vehicle = vRPclient.getNearestVehicle(source,11)
	if vehicle then
		if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"ceo.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
			TriggerClientEvent('reparar',source)
            sendLog('LogFix',"[ID]: "..user_id.." \n[FIX]: Usou o comando /fix em um veículo. "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ REVIVER ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('god',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"ceo.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.killGod(nplayer)
				vRPclient.setHealth(nplayer,400)
				
                TriggerClientEvent("resetBleeding",nplayer)
				TriggerClientEvent("resetDiagnostic",nplayer)
				vRP.varyThirst(nplayer,-100)
				vRP.varyHunger(nplayer,-100)
				endLog('LogGod',"[ID]: "..user_id.." \n[GOD]: Usou o comando /god no ID: "..args[1]..". "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
            end
        else
            vRPclient.killGod(source)
			vRPclient.setHealth(source,400)

			vRP.varyThirst(source,-100)
			vRP.varyHunger(source,-100)

            TriggerClientEvent("resetBleeding",source)
			TriggerClientEvent("resetDiagnostic",source)
			endLog('LogGod',"[ID]: "..user_id.." \n[GOD]: Usou o comando /god nele mesmo. "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
        end
    end
end)

RegisterCommand('god2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"ceo.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then

        if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.killGod(nplayer)
				vRPclient.setHealth(nplayer,120)
				
                TriggerClientEvent("resetBleeding",nplayer)
				TriggerClientEvent("resetDiagnostic",nplayer)
				vRP.varyThirst(nplayer,-15)
				vRP.varyHunger(nplayer,-15)
				sendLog('LogGod',"[ID]: "..user_id.." \n[GOD]: Usou o comando /god no ID: "..args[1]..". "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
            end
        else
            vRPclient.killGod(source)
			vRPclient.setHealth(source,120)

			vRP.varyThirst(source,-100)
			vRP.varyHunger(source,-100)

            TriggerClientEvent("resetBleeding",source)
			TriggerClientEvent("resetDiagnostic",source)
			sendLog('LogGod',"[ID]: "..user_id.." \n[GOD]: Usou o comando /god nele mesmo. "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
        end
    end
end)

RegisterCommand('godarea2', function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"ac.permissao") and args[1] then
        local radius = parseInt(args[1])
        if radius > 0 then
            local players = vRPclient.getNearestPlayers(source,radius)
            for k,v in pairs(players) do
                async(function()
                vRPclient.killGod(k)
                vRPclient.setHealth(k, 120)
                end)
            end
        end
    end
end)

RegisterCommand('godarea', function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"ac.permissao") and args[1] then
        local radius = parseInt(args[1])
        if radius > 0 then
            local players = vRPclient.getNearestPlayers(source,radius)
            for k,v in pairs(players) do
                async(function()
                vRPclient.killGod(k)
                vRPclient.setHealth(k, 400)
                end)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ REVIVER ALL ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('godall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ceo.permissao") then
    	local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
            	vRPclient.killGod(id)
				vRPclient.setHealth(id,400)
				print(id)
                sendLog('LogGodAll',"[ID]: "..user_id.." \n[GOD]: DEU GOD EM TODOS "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ HASH ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('hash',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ceo.permissao") then
		TriggerClientEvent('vehash',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TUNING ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tuning',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ceo.permissao") then
		TriggerClientEvent('vehtuning',source)
	end
end)

RegisterCommand('tuning2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao")  then
		TriggerClientEvent('vehtuning2',source)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUEL
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fuel',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"ceo.permissao") then
			TriggerClientEvent("admfuel",source)
		end	
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('wl',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"ac.permissao") then
        if args[1] then
            vRP.setWhitelisted(parseInt(args[1]),true)
            TriggerClientEvent("Notify",source,"sucesso","Voce aprovou o passaporte <b>"..args[1].."</b> na whitelist.")
            sendLog('LogWl',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APROVOU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unwl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] then
			vRP.setWhitelisted(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce retirou o passaporte <b>"..args[1].."</b> da whitelist.")
            sendLog('LogUnWl',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	
	if vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] then
			local id = vRP.getUserSource(parseInt(args[1]))
			if id then
				vRP.kick(id,"Você foi expulso da cidade.")
				TriggerClientEvent("Notify",source,"sucesso","Voce kickou o passaporte <b>"..args[1].."</b> da cidade.")
                sendLog('LogKick',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[KICKOU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK ALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kickall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ceo.permissao") then
        local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare ("EG/updateBanido", "UPDATE vrp_users SET banned = '1', hack = @isHack, Motivo = @motivo WHERE id = @user_id")
RegisterCommand('ban',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nuser_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    
    local motivo = vRP.prompt(source,"Motivo do Banimento:","")
    if motivo == "" then
        return
    end
	if vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] then
            idBanido = parseInt(args[1])
            motivoStaff = user_id..": "..motivo
            vRP.setBanned(idBanido,true)
            vRP.execute("EG/updateBanido", {user_id = idBanido, isHack = 0, motivo = motivoStaff})
			TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte <b>"..args[1].."</b> da cidade.")
            sendLog('LogBan',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[BANIU]: "..idBanido.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
            vRP.kick(idBanido,"Você foi expulso da cidade.")
		end
    end
end)

RegisterCommand('ban2',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nuser_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] then
            idBanido = parseInt(args[1])
            vRP.setBanned(idBanido,true)
            vRP.execute("EG/updateBanido", {user_id = idBanido, isHack = 1, motivo="HACKEG"})
			TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte <b>"..args[1].."</b> da cidade <b>POR HACK</b>!")
            sendLog('LogBan2Hack',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[BANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
		end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce desbaniu o passaporte <b>"..args[1].."</b> da cidade.")
            sendLog('LogUnban',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DESBANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MONEY ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('money',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"ceo.permissao") then
		if args[1] then
			vRP.giveMoney(user_id,parseInt(args[1]))
            sendLog('SpawnMoney',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[FEZ]: $"..vRP.format(parseInt(args[1])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ NC ]---------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ac.permissao") then
		vRPclient.toggleNoclip(source)
        senLog('LogNc',"```prolog\n[ID]: "..user_id.." \n[USOU]: NC "..vRP.format(parseInt(args[1])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TPCDS ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpcds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
		local fcoords = vRP.prompt(source,"Cordenadass:","")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)

local trolls = {}
RegisterCommand('troll', function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,'admin.permissao') then
        if args[1] and args[2] then
            local player = tonumber(args[2])
            if args[1] == 'add' then
                trolls[player] = true
                vRP.setBanned(player,true)
                TriggerClientEvent('Notify',source,'sucesso','Colocou o troll na ilha dos TROLLS')
            elseif args[1] == 'remover' then
                trolls[player] = false
                TriggerClientEvent('Notify',source,'sucesso','removeu o troll da ilha dos TROLLS')
            end
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        for k,v in pairs(trolls) do
            if v then
                local player = vRP.getUserSource(tonumber(k))
                if player then
                    vRPclient.setHealth(player,400)
                    TriggerClientEvent('tpTroll',player)
                end
            end
        end
        Citizen.Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ COORDENADAS ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ac.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		heading = GetEntityHeading(GetPlayerPed(-1))
		vRP.prompt(source,"Cordenadas:","['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z))
	end
end)

RegisterCommand('cds2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ac.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:",tD(x)..","..tD(y)..","..tD(z))
	end
end)

RegisterCommand('cds3',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	h = GetEntityHeading(GetPlayerPed(source))
	if vRP.hasPermission(user_id,"ac.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:","{x="..tD(x)..", y="..tD(y)..", z="..tD(z)..", h="..tD(h)..", assaltavel=true, segundos=60},")
	end
end)

RegisterCommand('cds4',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	h = GetEntityHeading(GetPlayerPed(source))
	if vRP.hasPermission(user_id,"ac.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:","{x="..tD(x)..", y="..tD(y)..", z="..tD(z).."},")
	end
end)

RegisterCommand('cds5',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	h = GetEntityHeading(GetPlayerPed(source))
	if vRP.hasPermission(user_id,"ac.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:","['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z)..", ['h'] = "..tD(h))
	end
end)

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end 
-----------------------------------------------------------------------------------------------------------------------------------------
--[ GROUP ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('group',function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	local identity = vRP.getUserIdentity(user_id)
-- 	if vRP.hasPermission(user_id,"ceo.permissao") then
-- 		if args[2] == "bronze5e" or args[2] == "bronze25e" or args[2] == "bronze35e" or args[2] == "bronze45e" or args[2] == "prata5e" or args[2] == "prata25e" or args[2] == "prata35e" 
--             or args[2] == "prata45e" or args[2] == "ouro5e" or args[2] == "ouro25e" or args[2] == "ouro35e" or args[2] == "ouro45e" or args[2] == "diamante5e" or args[2] == "diamante25e" 
--             or args[2] == "diamante35e" or args[2] == "diamante45e" or args[2] == "esmeralda5e" or args[2] == "esmeralda25e" or args[2] == "esmeralda35e" or args[2] == "esmeralda45e" 
--             or args[2] == "flush5e" or args[2] == "flush25e" or args[2] == "flush35e" or args[2] == "flush45e" or args[2] == "som" or args[2] == "instagram"
--             or args[2] == "gerente" or args[2] == "estagiario" or args[2] == "patrao" or args[2] == "funcionario" then
-- 			TriggerClientEvent("Notify",source,"negado","Você não tem permissão para isso.")
-- 			return true
-- 		elseif args[1] and args[2] then
-- 			vRP.addUserGroup(parseInt(args[1]),args[2])
-- 			TriggerClientEvent("Notify",source,"sucesso","Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")
-- 			sendLog('LogAdmin',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
-- 			return true
-- 		end
-- 	elseif vRP.hasPermission(user_id,"mod.permissao") then
-- 		if args[2] == "mindmaster157" or args[2] == "Admin" or args[2] == "Mod" or args[2] == "Suporte" 
--             or args[2] == "bronze5e" or args[2] == "bronze25e" or args[2] == "bronze35e" or args[2] == "bronze45e" or args[2] == "prata5e" or args[2] == "prata25e" or args[2] == "prata35e" 
--             or args[2] == "prata45e" or args[2] == "ouro5e" or args[2] == "ouro25e" or args[2] == "ouro35e" or args[2] == "ouro45e" or args[2] == "diamante5e" or args[2] == "diamante25e" 
--             or args[2] == "diamante35e" or args[2] == "diamante45e" or args[2] == "esmeralda5e" or args[2] == "esmeralda25e" or args[2] == "esmeralda35e" or args[2] == "esmeralda45e" 
--             or args[2] == "flush5e" or args[2] == "flush25e" or args[2] == "flush35e" or args[2] == "flush45e" or args[2] == "som" or args[2] == "instagram" 
--             or args[2] == "gerente" or args[2] == "estagiario" or args[2] == "patrao" or args[2] == "funcionario" then
-- 			TriggerClientEvent("Notify",source,"negado","Você não tem permissão para isso, chame algum fundador")
-- 			return true
-- 		elseif args[1] and args[2] then
-- 			vRP.addUserGroup(parseInt(args[1]),args[2])
-- 			TriggerClientEvent("Notify",source,"sucesso","Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")
-- 			sendLog('LogAdmin',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
-- 		end
-- 	end
-- end)
RegisterCommand('group',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] and args[2] then
			vRP.addUserGroup(parseInt(args[1]),args[2])
			TriggerClientEvent("Notify",source,"sucesso","Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")
            sendLog('LogAdmin',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
		end
    end
end)	
-----------------------------------------------------------------------------------------------------------------------------------------
--[ UNGROUP ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ungroup',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"mod.permissao") then
        if args[1] and args[2] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                if vRP.hasGroup(parseInt(args[1]),args[2]) then
                    vRP.removeUserGroup(parseInt(args[1]),args[2])
                    TriggerClientEvent("Notify",source,"sucesso","Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.")
                    sendLog('LogAdmin',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[TIROU O SET]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
                else
                    TriggerClientEvent("Notify",source,"negado","O passaporte <b>"..parseInt(args[1]).."</b> não está setado com o grupo de <b>"..args[2].."</b>.")
                end
                else
                local data = json.decode(vRP.getUData(args[1], "vRP:datatable"))
                if data.groups then
                    data.groups[args[2]] = nil
                end
                vRP.setUData(parseInt(args[1]),"vRP:datatable",json.encode(data))
                TriggerClientEvent("Notify",source,"sucesso","Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.")
                sendLog('LogAdmin',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[TIROU O SET]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TPTOME ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tptome',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ac.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			local x,y,z = vRPclient.getPosition(source)
			if tplayer then
				vRPclient.teleport(tplayer,x,y,z)
				sendLog('LogTp',"[ID]: "..user_id.." \n[PUXOU O ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TPTO ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpto',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ac.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			if tplayer then
				vRPclient.teleport(source,vRPclient.getPosition(tplayer))
				sendLog('LogTp',"[ID]: "..user_id.." \n[TELEPORTOU PARA O ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TPWAY ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpway',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
		TriggerClientEvent('tptoway',source)
        sendLog('LogTp',"[ID]: "..user_id.." \n[UTILIZOU TPWAY]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DELNPCS ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('delnpcs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
		TriggerClientEvent('delnpcs',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ PLAYERSON ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pon',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)    
	TriggerClientEvent('chatMessage',source,"ALERTA",{255,70,50},"Jogadores online: "..onlinePlayers)
    if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
        local users = vRP.getUsers()
        local players = ""
        local quantidade = 0
        for k,v in pairs(users) do
            if k ~= #users then
                players = players..", "
            end
            players = players..k
            quantidade = quantidade + 1
        end
        local onlinePlayers = GetNumPlayerIndices()
        TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{255,160,0},onlinePlayers)
        TriggerClientEvent('chatMessage',source,"ID's ONLINE",{255,160,0},players)
    end
end)
----------------------------------------------------------------------------------------------------------------------------------------
------ MUDAR COR DO CARRO
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('carcolor',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ceo.permissao") then
		local vehicle,vehNet = vRPclient.vehList(source,5)
		if vehicle then
            local rgb = vRP.prompt(source,"RGB Color(255 255 255):"," ")
            rgb = sanitizeString(rgb,"\"[]{}+=?!_()#@%/\\|,.",false)
            local r,g,b = table.unpack(splitString(rgb," "))
			TriggerClientEvent('vcolorv',source,vehicle,tonumber(r),tonumber(g),tonumber(b))
			TriggerClientEvent('chatMessage',source,"ALERTA",{255,70,50},"Cor ^1alterada")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DV ]---------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dv',function(source)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, 'ac.permissao') then
        local veh, netId, plate, vName = vRPclient.vehList(source, 25.0)
        TriggerEvent('nyo_module:delete_vehicle',netId,vName)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CAR ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('car',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"admin.permissao") then
			if args[1] then
				TriggerClientEvent('spawnarveiculo',source,args[1])
				TriggerEvent("setPlateEveryone",identity.registration)
				sendLog('LogSpawnVeiculo',"[ID]: "..user_id.." \n[SPAWNOU]: "..args[1]..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true) 
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KILLALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('killall',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"ceo.permissao") then
    	local nusers = vRP.getUsers()
        for k,v in pairs(nusers) do
			local nplayer = vRP.getUserSource(parseInt(k))
            if nplayer then
				vRPclient.setHealth(nplayer,0)
				vRP.updateThirst(parseInt(args[1]),0)
				vRP.updateHunger(parseInt(args[1]),0)
				TriggerClientEvent("resetBleeding",nplayer)
				TriggerClientEvent("resetDiagnostic",nplayer)
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- KILL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kill',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"ceo.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.setHealth(nplayer,0)
				TriggerClientEvent("Notify",source,"importante","Você matou o passaporte "..args[1])
			end
		else
			args[1] = user_id
            vRPclient.setHealth(source,0)
		end	
		sendLog('LogAdmin',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[KILL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAR INVENTARIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limparinv',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(user_id)
    if vRP.hasPermission(user_id,"ceo.permissao") then
        local tuser_id = tonumber(args[1])
        local tplayer = vRP.getUserSource(tonumber(tuser_id))
        local tplayerID = vRP.getUserId (tonumber(tplayer))
            if tplayerID ~= nil then
            local identity = vRP.getUserIdentity(user_id)
            vRP.clearInventory(user_id)
				TriggerClientEvent("Notify",source,"sucesso","Limpou inventario do <id>"..args[1].."</b>.")
                sendLog('LogAdmin',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[LIMPROU O INVENTARIO DO ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."",true)

            else
                TriggerClientEvent("Notify",source,"negado","O usuário não foi encontrado ou está offline.")
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RG2 - ver os sets do player
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rg2',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ceo.permissao") or vRP.hasPermission(user_id,"admin.permissao")then
        local nuser_id = parseInt(args[1])
        local identity = vRP.getUserIdentity(nuser_id)
        local bankMoney = vRP.getBankMoney(nuser_id)
        local walletMoney = vRP.getMoney(nuser_id)
        local paypalMoney = vRP.getPaypal(nuser_id)
        local sets = json.decode(vRP.getUData(nuser_id,"vRP:datatable"))
        
        if args[1] then
           TriggerClientEvent("Notify",source,"aviso","ID: <b>"..parseInt(nuser_id).."</b><br>Nome: <b>"..identity.name.." "..identity.firstname..","..identity.age.." anos</b><br>Telefone: <b>"..identity.phone.."</b><br>Carteira: <b>"..vRP.format(parseInt(walletMoney)).."</b><<br>Paypal: <b>"..vRP.format(parseInt(paypalMoney)).."</b><br>Banco: <b>"..vRP.format(parseInt(bankMoney)).."</b><br>Sets:<b>"..json.encode(sets.groups).."</b>",5000)    
        else
            TriggerClientEvent("Notify",source,"negado","Digite o ID desejado!")
        end
    end
end)

----------------------------------------------------------------------------------------------------------------
-- RENAME
----------------------------------------------------------------------------------------------------------------
RegisterCommand('rename',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "mod.permissao") or vRP.hasPermission(user_id, "advogado.permissao")  or vRP.hasPermission(user_id,"promotor.permissao") or vRP.hasPermission(user_id,"desembargador.permissao") then
        local idjogador = vRP.prompt(source, "PASSAPORTE: ", "")
        local nome = vRP.prompt(source, "NOVO NOME: ", "")
        local firstname = vRP.prompt(source, "NOVO SOBRENOME: ", "")
        local idade = vRP.prompt(source, "NOVA IDADE: ", "")
        local nplayer = vRP.getUserSource(parseInt(idjogador))

        if nplayer then
            local identity = vRP.getUserIdentity(parseInt(idjogador))
            if idjogador == "" or nome == "" or firstname == "" or idade == "" then
                   return
               else
                vRP.execute("vRP/update_user_identity",{ user_id = idjogador, firstname = firstname, name = nome, age = idade, registration = identity.registration, phone = identity.phone })
                TriggerClientEvent("Notify",nplayer,"sucesso","Identidade atualizada!")
                TriggerClientEvent("Notify",source,"sucesso","Identidade do ID: <b>"..parseInt(idjogador).."</b> alterada com sucesso!")
            end
        else
            TriggerClientEvent("Notify",source,"negado","O ID: <b>"..parseInt(idjogador).."</b> n�o est� na cidade!")
        end        
    end
end)

---------------------------------------------------------------------------------
-- RESET ------------------------------------------------------------------------
---------------------------------------------------------------------------------
RegisterCommand('reset',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if user_id then
        if vRP.hasPermission(user_id,"ceo.permissao") or vRP.hasPermission(user_id,"diretor.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
            if args[1] then
                local nplayer = vRP.getUserSource(parseInt(args[1]))
                local id = vRP.getUserId(nplayer)
                if id then
                    vRP.setUData(id,"vRP:spawnController",json.encode(1))
                    TriggerClientEvent("Notify",source,"sucesso","Você <b>resetou</b> o personagem do passaporte <b>"..vRP.format(parseInt(args[1])).."</b>.",5000)
                    sendLog('LogReset',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RESETOU A APARENCIA DO ID]: "..id.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
                end
            end
        end
    end
end)

---------------------------------------------------------------------------------
-- VFERIMENTO -------------------------------------------------------------------
---------------------------------------------------------------------------------
RegisterCommand('vferimento',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		local vnplayer = vRPclient.getHealth(nplayer)
		if nplayer then
			if vnplayer <= 100 then
				local diagnostic = math.random(1,3)
				if diagnostic == 1 then
					TriggerClientEvent("Notify",source,"aviso","O cidadão se encontra morto!")
					TriggerClientEvent("Notify",nplayer,"aviso","Você se encontra morto!")
				elseif diagnostic == 2 then
					TriggerClientEvent("Notify",nplayer,"aviso","Você se encontra vivo e sem ferimento graves,logo vai pra casa!")
					TriggerClientEvent("Notify",source,"aviso","O cidadão se encontra vivo e sem ferimento graves, realize o procedimento o mais rapido!")
				elseif diagnostic == 3 then
					TriggerClientEvent("Notify",nplayer,"aviso","Você se encontra vivo com ferimento grave, olha pra luz!")
					TriggerClientEvent("Notify",source,"aviso","O cidadão se encontra vivo com ferimento grave, realize o procedimento o mais rapido e encaminhe o mesmo para o hospital !")
				end
			else
				TriggerClientEvent("Notify",source,"aviso","O cidadão se encontra vivo e sem ferimentos!")
			end
		end
	end
end)
---------------------------------------------------------------------------------
-- STATUS -----------------------------------------------------------------------
---------------------------------------------------------------------------------
RegisterCommand('status',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ceo.permissao") then
        local onlinePlayers = GetNumPlayerIndices()
        local policia = vRP.getUsersByPermission("policia.permissao")
        local paramedico = vRP.getUsersByPermission("paramedico.permissao")
        local mec = vRP.getUsersByPermission("mecanico.permissao")
        local staff = vRP.getUsersByPermission("ac.permissao")
        local staffoff = vRP.getUsersByPermission("paisana-staff.permissao")
        local ilegal = vRP.getUsersByPermission("ilegal.permissao")
        local bloods = vRP.getUsersByPermission("bloods.permissao")
        local groove = vRP.getUsersByPermission("groove.permissao")
        local vagos = vRP.getUsersByPermission("vagos.permissao")
        local mafia = vRP.getUsersByPermission("mafia.permissao")
        local bratva = vRP.getUsersByPermission("bratva.permissao")
        local crips = vRP.getUsersByPermission("crips.permissao")
        local triade = vRP.getUsersByPermission("triade.permissao")
        local mafia = vRP.getUsersByPermission("mafia.permissao")
        local bahamas = vRP.getUsersByPermission("bahamas.permissao")
        local tequilala = vRP.getUsersByPermission("tequilala.permissao")
        local vanilla = vRP.getUsersByPermission("vanilla.permissao")
        local hells = vRP.getUsersByPermission("hells.permissao")
        local motoclub = vRP.getUsersByPermission("motoclub.permissao")
        
        local user_id = vRP.getUserId(source)        
        TriggerClientEvent("Notify",source,"importante","<bold><b>Jogadores</b>: <b>"..onlinePlayers.."<br>Administração</b>: <b>"..#staff.."<br>Staff em RP: <b>"..#staffoff.."</b><hr>Policiais</b>: <b>"..#policia.."<br>Paramédicos</b>: <b>"..#paramedico.."<br>Mecânicos</b>: <b>"..#mec.."<br>Membros de Faccao</b>: <b>"..#ilegal.."<hr>GDE (Droga)</b>: <b>"..#gde.."<br>TCP (Droga)</b>: <b>"..#tcp.."<br>ADA (Droga)</b>: <b>"..#ada.."<hr>Motoclub (Desmanche)</b>: <b>"..#motoclub.."<br>Hell Angels (Desmanche)</b>: <b>"..#hellangels.."<br>CDD (Desmanche)</b>: <b>"..#cdd.."<hr>LUX (Lavagem)</b>: <b>"..#lux.."<br>Sindicato (Lavagem)</b>: <b>"..#sindicato.."<br>Vanilla (Lavagem)</b>: <b>"..#vanilla.."<hr>PCC (Arma)</b>: <b>"..#pcc.."<br>CV (Arma)</b>: <b>"..#cv.."<br>CPX (Arma)</b>: <b>"..#cpx.."<hr>B13 (Muni)</b>: <b>"..#b13.."<br>FDN (Muni)</b>: <b>"..#fdn.."<br>Rocinha (Muni)</b>: <b>"..#rocinha.."</bold>",9000)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
local hours = 09
local minutes = 00
local weather = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = {
    [1] = { "EXTRASUNNY",240 },
    [2] = { "RAIN",12 },
    [3] = { "THUNDER",3 },
    [4] = { "CLEAR",240 },
    [5] = { "SNOW",2 },
    [6] = { "BLIZZARD",1 },
    [7] = { "XMAS",10 },
    [8] = { "SNOW",2 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- /clima
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("weather",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"ceo.permissao") then 
            local sync = sanitizeString(args[1],"12345678",true)
            weather = parseInt(sync)
            TriggerClientEvent("vrp_vsync:updateWeather",-1,timers[weather][1])
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /tempo
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("time",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"ceo.permissao") then
            hours = parseInt(args[1])
            minutes = parseInt(args[2])
            if parseInt(args[1]) == 24 then 
                hours = 0
            end 
            TriggerClientEvent("vrp_vsync:syncTimers",-1,{minutes,hours})
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        minutes = minutes + 1
        if minutes >= 60 then
            minutes = 0
            hours = hours + 1
            if hours >= 24 then
                hours = 0
            end
        end
        TriggerClientEvent("vrp_vsync:syncTimers",-1,{minutes,hours})
    end
end)


AddEventHandler("vRP:playerSpawn",function(user_id,source)
    TriggerClientEvent("vrp_vsync:syncTimers",source,{minutes,hours})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_vsync:requestSync")
AddEventHandler("vrp_vsync:requestSync",function()
    local source = source
    if weather == nil then 
        weather = 1 
    end
    TriggerClientEvent("vrp_vsync:updateWeather",source,timers[parseInt(weather)][1])
end)

RegisterServerEvent("vrp_vsync:requestSync2")
AddEventHandler("vrp_vsync:requestSync2",function()
    local source = source
    if weather == nil then 
        weather = 1 
    end
    TriggerClientEvent("vrp_vsync:updateWeather2",source,timers[parseInt(weather)][1])
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- FAKE VIP
-----------------------------------------------------------------------------------------------------------------------------------------
-- local produtos = {
--     [1] = 'VIP Bronze',
--     [2] = 'VIP Prata',
--     [3] = 'VIP Ouro',
--     [4] = 'VIP Platina',
--     [5] = 'VIP Platina 2;0',
--     [6] = 'VIP Master [MENSAL]',
--     [7] = 'VIP Ultra [MENSAL]',
--     [8] = 'VIP Master [PERMANENTE]',
--     [9] = 'VIP Ultra [PERMANENTE]',
--     [10] = 'Salário Estagiário',
--     [11] = 'Salário Funcionário',
--     [12] = 'Salário Gerente',
--     [13] = 'Salário Patrão',
--     [14] = '500K',
--     [15] = '1KK',
--     [16] = '3KK',
--     [17] = 'Honda CBR 2017',
--     [18] = 'Africa Twin',
--     [19] = 'Hayabusa',
--     [20] = 'Ducatti Dm1200',
--     [21] = 'XT 660',
--     [22] = 'R6',
--     [23] = 'Z1000',
--     [24] = 'R1',
--     [25] = 'XJ6',
--     [26] = 'BMW S1000',
--     [27] = 'CB 1000',
--     [28] = 'R1250',
--     [29] = 'REMOVER ADV',
--     [30] = 'REMOVER TEMP-BAN',
--     [31] = 'Remoção de Banimento (Voltando sem nada)',
--     [32] = 'Remoção de Banimento (Voltando com tudo)',
--     [33] = 'Remoção de uma Advertência de Facção/Org (1)',
--     [34] = 'Número Personalizado',
--     [35] = 'Verificado Instagram',
--     [36] = 'Verificado Instagram',
--     [37] = 'Mudança de Aparência/Nome',
--     [38] = '+3 Vagas de Garagem',
--     [39] = 'BMW R1250',
--     [40] = 'Koenigsegg Gemera',
--     [41] = 'Lancer Evolution X',
--     [42] = 'Nissan SkyLine R34',
--     [43] = 'Mercedes Classe X',
--     [44] = 'Lamborghini Centenario',
--     [45] = 'Porsche Taycan',
--     [46] = 'BMW i8 Liberty Walk',
--     [47] = 'Bugatti Chiron',
--     [48] = 'Porsche 718 Boxster',
--     [49] = 'Ferrari Italia',
--     [50] = 'Lamborghini Huracan',
--     [51] = 'BMW X7',
--     [52] = 'McLaren P1 GTR',
--     [53] = 'Nissan Titan 2017 (8 Lugares)',
--     [54] = 'BMW M3 E46',
--     [55] = 'Camaro',
--     [56] = 'Maserati F620',
--     [57] = 'Saveiro de Som',
--     [58] = 'Nissan 370Z',
--     [59] = 'Aston Martin',
--     [60] = 'Mazda RX7',
--     [61] = 'Celta de Som',
--     [62] = 'Hyundai Sonata',
--     [63] = 'Dodge Challenger',
--     [64] = 'Dodge Charger 1969',
--     [65] = 'Toyota Supra',
--     [66] = 'BMW I8',
--     [67] = 'Lancer Evolution 9',
--     [68] = 'BMW M4 GTS',
--     [69] = 'Subaru BRZ13',
--     [70] = 'Porsche 918 Spyder',
--     [71] = 'Corvette C7',
--     [72] = 'Audi Q8',
--     [73] = 'Tesla Prior',
--     [74] = 'Audi R8',
--     [75] = 'Audi RS6',
--     [76] = 'Mercedes GT63 S',
--     [77] = 'Amarok',
--     [78] = 'BMW M8',
--     [79] = 'BMW M5 F90',
--     [80] = 'Golf MK6',
--     [81] = 'Jeep Cherokee',
--     [82] = 'Ferrari 812',
--     [83] = 'Nissan GTR',
--     [84] = 'Pagani Huayra',
--     [85] = 'Nissan 350Z PandeM',
--     [86] = 'Audi RS7',
--     [87] = 'Mercedes G65',
--     [88] = 'Fuscão Weevil',
--     [89] = 'Ford Mustang',
--     [90] = 'L200'
-- }

-- local nomes = {
--     [1] = 'Arthur',
--     [2] = 'Bernardo',
--     [3] = 'Heitor',
--     [4] = 'Igor',
--     [5] = 'Daniel',
--     [6] = 'Eduardo',
--     [7] = 'Pedro',
--     [8] = 'Nicollas',
--     [9] = 'Marley',
--     [10] = 'Giovanni',
--     [11] = 'Gabriel',
--     [12] = 'Samuel',
--     [13] = 'Gustavo',
--     [14] = 'Davi',
--     [15] = 'Cleiton',
--     [16] = 'Miguel',
--     [17] = 'Lucas',
--     [18] = 'Dudu',
--     [19] = 'Sophia',
--     [20] = 'Júlia',
--     [21] = 'Isabella'
-- }

-- local sobrenomes = {
--     [1] = 'Silva',
--     [2] = 'Torres',
--     [3] = 'Oliveira',
--     [4] = 'Souza',
--     [5] = 'Lima',
--     [6] = 'Pereira',
--     [7] = 'Ferreira',
--     [8] = 'Costa',
--     [9] = 'Rodrigues',
--     [10] = 'Almeida',
--     [11] = 'Maverick',
--     [12] = 'Malia',
--     [13] = 'Ribeiro',
--     [14] = 'Alves',
--     [15] = 'Alvez',
--     [16] = 'Sampaio',
--     [17] = 'Miller',
--     [18] = 'Ross',
--     [19] = 'Beiramar',
--     [20] = 'Junior',
--     [21] = 'Walker'
-- }

-- CreateThread(function()
--     while true do
--         local escolherprodutos = math.random(1,90)
--         local escolhernomes = math.random(1,21)
--         local escolhersobrenomes = math.random(1,21)
--         TriggerClientEvent('chat:addMessage', -1, { template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, rgba(255, 168, 82,1) 3%, rgba(255, 168, 82,0) 95%);border-radius: 5px;"><img width="24" style="float: left;">'..nomes[escolhernomes]..' '..sobrenomes[escolhersobrenomes]..' comprou '..produtos[escolherprodutos]..'.</div>' })
--         Wait(60e3 * math.random(60, 105))
--     end
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- /FESTA -------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('festa',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ac.permissao") then
        local identity = vRP.getUserIdentity(user_id)
        local mensagem = vRP.prompt(source,"Mensagem:","")
        if mensagem == "" then
            return
        end
        vRPclient.setDiv(-1,"festinha"," @keyframes blinking {    0%{ background-color: #ff3d50; border: 2px solid #871924; opacity: 0.8; } 25%{ background-color: #d22d99; border: 2px solid #901f69; opacity: 0.8; } 50%{ background-color: #55d66b; border: 2px solid #126620; opacity: 0.8; } 75%{ background-color: #22e5e0; border: 2px solid #15928f; opacity: 0.8; } 100%{ background-color: #222291; border: 2px solid #6565f2; opacity: 0.8; }  } .div_festinha { font-size: 11px; font-family: arial; color: rgba(255, 255, 255,1); padding: 20px; bottom: 10%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; animation: blinking 1s infinite; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Festeiro(a): "..identity.name.." "..identity.firstname)
        sendLog('LogComandoFesta',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MANDOU NO /FESTA]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
         SetTimeout(15000,function()
            vRPclient.removeDiv(-1,"festinha")
        end)
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------
---- CLEAR VEH
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limparveiculos', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        if vRP.hasPermission(user_id,"ceo.permissao") then
            TriggerClientEvent('chatMessage', -1, "^1ADMIN: ^0Contagem Iniciada ^260s^0 para limpeza de veiculos. (Entre em seu veiculo para não ser removido)")
            Wait(60000)

            local deleteCount = 0
            for k,v in ipairs(GetAllVehicles()) do 
                local ped = GetPedInVehicleSeat(v, -1)
                if not ped or ped <= 0 then 
                    DeleteEntity(v)
                    deleteCount = deleteCount + 1
                end
            end

            TriggerClientEvent('chatMessage', -1, "^1ADMIN: ^0"..deleteCount.." veiculo deletados!")
        end
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------
---- CLEAR OBJETOS
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('clearallobj', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        if vRP.hasPermission(user_id,"ceo.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
            local deleteCount = 0
            local entityList = {}
            for k,v in ipairs(GetAllObjects()) do 
                DeleteEntity(v)

                if GetEntityScript(v) ~= nil then
                    if not entityList[GetEntityScript(v)] then entityList[GetEntityScript(v)] = 0 end
                    entityList[GetEntityScript(v)] = entityList[GetEntityScript(v)] + 1
                end

                deleteCount = deleteCount + 1
            end

            print(json.encode(entityList, { indent = true }))
            TriggerClientEvent('chatMessage', -1, "^1ADMIN: ^0"..deleteCount.." objetos deletados!")
        end
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------
---- TEMPBAN
-------------------------------------------------------------------------------------------------------------------------------------------
local tempbanOptions = {
	[1] = { days = 1, prision = 100, penalty = 250000 },
	[2] = { days = 2, prision = 250, penalty = 500000 },
	[3] = { days = 7, prision = 500, penalty = 1000000 }
}
local webhooktempban = 'https://discord.com/api/webhooks/1055571630774042684/jvFv9myLKO3grCepIljMzAftg0gJfdspXLraJOjcLpNDGJikhnbeCM1-wddT4K7UADPP'
RegisterCommand('tempban',function(source,args)
	local userId = vRP.getUserId(source)
	if vRP.hasPermission(userId,'admin.permissao') then
		local identity = vRP.getUserIdentity(userId)
		local optionToBan = vRP.prompt(source,'Qual opção de tempbanimento você deseja? 1, 2 ou 3? Digite abaixo:','')
		local otherId = parseInt(args[1])
		local bannedOption = parseInt(optionToBan)
		local sourceOtherPlayer = vRP.getUserSource(otherId)
		local tableOptions = tempbanOptions[bannedOption]
		print('aqui dentroaaa')
		if tempbanOptions[bannedOption] then
			local daysInSeconds = tableOptions.days * 24 * 60 * 60
			local value = vRP.getUData(otherId,"vRP:multas")
    		local multas = json.decode(value) or 0
			print('aqui dentro')
			print('here')
			if sourceOtherPlayer then
				print('trying')
				local ped = GetPlayerPed(sourceOtherPlayer)
				vRP.dropPlayer(sourceOtherPlayer,'Você foi banido temporariamente!', {
					armour = GetPedArmour(ped),
					coords = GetEntityCoords(ped)
				})
				vRP.kick(sourceOtherPlayer,'Você foi banido temporariamente!')
			end
			vRP.setUData(otherId,'arthur:Tempban',json.encode(os.time() +  daysInSeconds))
			vRP.setUData(otherId,'vRP:prisao', json.encode(tableOptions.prision))
			vRP.setUData(otherId,"vRP:multas",json.encode(multas+tableOptions.penalty))
			SendWebhookMessage(webhooktempban,"prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[TEMPBANIU]: "..otherId.." \n[TEMPO]: "..tableOptions.days.." dia(s) "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r") 
		end
	end
end)

-------------------------
-- /w arma
-------------------------
RegisterCommand('w',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if args[1] == "taser" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Taser equipado.")
            vRPclient.giveWeapons(source,{["WEAPON_STUNGUN"] = { ammo = 0 }})            
        elseif args[1] == "ak" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Ak equipada.")
            vRPclient.giveWeapons(source,{["weapon_assaultrifle_mk2"] = { ammo = 250 }})
        elseif args[1] == "tec" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Tec equipada.")
            vRPclient.giveWeapons(source,{["weapon_machinepistol"] = { ammo = 250 }})
        elseif args[1] == "g3" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","G3 equipada.")
            vRPclient.giveWeapons(source,{["weapon_specialcarbine_mk2"] = { ammo = 250 }})
        elseif args[1] == "m4" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","M4A1 equipada.")
            vRPclient.giveWeapons(source,{["weapon_carbinerifle"] = { ammo = 250 }})
        elseif args[1] == "mpx" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","MPX equipada.")
            vRPclient.giveWeapons(source,{["weapon_carbinerifle_mk2"] = { ammo = 250 }})
        elseif args[1] == "sig" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Sig Sauer equipada.")
            vRPclient.giveWeapons(source,{["weapon_combatpdw"] = { ammo = 250 }})
        elseif args[1] == "glock" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Glock equipada.")
            vRPclient.giveWeapons(source,{["weapon_combatpistol"] = { ammo = 250 }})
        elseif args[1] == "da" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Revolver de ação dupla equipado.")
        elseif args[1] == "12" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","12 equipada.")
            vRPclient.giveWeapons(source,{["weapon_pumpshotgun"] = { ammo = 250 }})
        elseif args[1] == "12b" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","12 MK2 equipada.")
            vRPclient.giveWeapons(source,{["weapon_pumpshotgun_mk2"] = { ammo = 250 }})
        elseif args[1] == "paraquedas" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Paraquedas equipado.")
            vRPclient.giveWeapons(source,{["gadget_parachute"] = { ammo = 1 }})
        elseif args[1] == "tg" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Lança misseis teleguiado equipado.")
            vRPclient.giveWeapons(source,{["weapon_hominglauncher"] = { ammo = 10 }})
        elseif args[1] == "uzi" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","UZI equipada.")
            vRPclient.giveWeapons(source,{["weapon_microsmg"] = { ammo = 250 }})
        elseif args[1] == "ap" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","AP 40 equipada.")
            vRPclient.giveWeapons(source,{["weapon_appistol"] = { ammo = 250 }})
        elseif args[1] == "five" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Five Seven equipada.")
            vRPclient.giveWeapons(source,{["weapon_pistol_mk2"] = { ammo = 250 }})
        elseif args[1] == "smg" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","SMG equipada.")
        vRPclient.giveWeapons(source,{["weapon_smg_mk2"] = { ammo = 250 }})
        elseif args[1] == "sniper" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Sniper equipada.")
            vRPclient.giveWeapons(source,{["weapon_heavysniper_mk2"] = { ammo = 250 }})
        elseif args[1] == "fogos" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Fogos equipado.")
            vRPclient.giveWeapons(source,{["weapon_firework"] = { ammo = 25 }})
        elseif args[1] == "luz" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Lanterna equipada.")
            vRPclient.giveWeapons(source,{["weapon_flashlight"] = { ammo = 250 }})
        elseif args[1] == "colete" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso","Colete equipado.")


        elseif args[1] == "todas" and vRP.hasPermission(user_id,"admin.permissao") then
                TriggerClientEvent("Notify",source,"sucesso","Taser equipado.")
                vRPclient.giveWeapons(source,{["WEAPON_STUNGUN"] = { ammo = 0 }})            
                TriggerClientEvent("Notify",source,"sucesso","Ak equipada.")
                vRPclient.giveWeapons(source,{["weapon_assaultrifle_mk2"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","Tec equipada.")
                vRPclient.giveWeapons(source,{["weapon_machinepistol"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","G3 equipada.")
                vRPclient.giveWeapons(source,{["weapon_specialcarbine_mk2"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","M4A1 equipada.")
                vRPclient.giveWeapons(source,{["weapon_carbinerifle"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","MPX equipada.")
                vRPclient.giveWeapons(source,{["weapon_carbinerifle_mk2"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","Sig Sauer equipada.")
                vRPclient.giveWeapons(source,{["weapon_combatpdw"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","Glock equipada.")
                vRPclient.giveWeapons(source,{["weapon_combatpistol"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","Revolver de ação dupla equipado.")
                TriggerClientEvent("Notify",source,"sucesso","12 equipada.")
                vRPclient.giveWeapons(source,{["weapon_pumpshotgun"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","12 MK2 equipada.")
                vRPclient.giveWeapons(source,{["weapon_pumpshotgun_mk2"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","Paraquedas equipado.")
                vRPclient.giveWeapons(source,{["gadget_parachute"] = { ammo = 1 }})
                TriggerClientEvent("Notify",source,"sucesso","Lança misseis teleguiado equipado.")
                vRPclient.giveWeapons(source,{["weapon_hominglauncher"] = { ammo = 10 }})
                TriggerClientEvent("Notify",source,"sucesso","UZI equipada.")
                vRPclient.giveWeapons(source,{["weapon_microsmg"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","AP 40 equipada.")
                vRPclient.giveWeapons(source,{["weapon_appistol"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","Five Seven equipada.")
                vRPclient.giveWeapons(source,{["weapon_pistol_mk2"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","SMG equipada.")
            vRPclient.giveWeapons(source,{["weapon_smg_mk2"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","Sniper equipada.")
                vRPclient.giveWeapons(source,{["weapon_heavysniper_mk2"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","Fogos equipado.")
                vRPclient.giveWeapons(source,{["weapon_firework"] = { ammo = 25 }})
                TriggerClientEvent("Notify",source,"sucesso","Lanterna equipada.")
                vRPclient.giveWeapons(source,{["weapon_flashlight"] = { ammo = 250 }})
                TriggerClientEvent("Notify",source,"sucesso","Colete equipado.")

            vRPclient.setArmour(source,100)
        elseif args[1] == "limpar" and vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"sucesso"," Armamentos removidos.")
			
            vRPclient.giveWeapons(source,{},true)
        elseif vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"negado","Especifique uma arma.")

        end
    end
end)
