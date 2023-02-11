local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

vRPserver = {}
Tunnel.bindInterface("vrp_policia",vRPserver)

local idgens = Tools.newIDGenerator()
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ WEBHOOK ]------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local webhookocorrencias = "https://discord.com/api/webhooks/1059921606702530620/S5oGr66N_B0654phlFzi4m20q6yb22-vgDNqEnK2w2fAkXQlawjYVT9eb-s3RbCmY_fW"
local webhookprender = "https://discord.com/api/webhooks/1059920931423789096/KhBEyQxSJbqWZWf31r9l1kwAQIHRpnAgGaQhDAt-rAlcjZp5QNjpZzutlfnV3Nk8IUA_"
local webhookparamedico = "https://discord.com/api/webhooks/1059922245524398171/UeXYw-_zhHqHbgW9KhVFzt-UGbMniJNa8pLSnXxYCa0PgrL3SNs0Xor-rCHmFNZUIyCF"
local webhookpolicia = "https://discord.com/api/webhooks/1059919219623464970/BYhw19HxDJAibdZwOmO2lYgtT4zcpwP0mXXoXwe8mBxg53Cg1jjIsL67TOlRgJvEa4hL"
local webhookarsenal = "https://discord.com/api/webhooks/1059921207006339102/lzlYEv_hL2LToXWSkdL4oRofsxDqdPVj_U0396mFMoODoVL0U1THmUV0AUsysCCIbR7k"
local webhookmecanico = "https://discord.com/api/webhooks/1059922915954528318/fLEe1rc-MEStbQkpAoT0dVILQFKwGSpLgXuGiRl40tVg7-iYYgLQLVdhRfm4-6ClNGAm"
local webhookmultas = "https://discord.com/api/webhooks/1059921321590542418/4-1rjTdu3jStyBfBEWQ5E-cNLWPEWeSfFOisDHD9xVZO5pK71hFuAKUCZE5LVyWL7nSK"
local webhookdetido = "https://discord.com/api/webhooks/1059921416381796512/Vw9dR03CDlEJdB0agC9-eCaA8yDPqmWspoxBaC0QM0R5bGwBWEVP0RD1EfMNItSOaLkL"
local webhookpoliciaapreendidos = "https://discord.com/api/webhooks/1059921069324124250/z5_XiffGs1f3a5RwpaModsO0GLukSjcM9ajW937Z-b1g301rWXkopC6pHWFl22OFeS7a"
local webhookArmaAdmin = ""
local webhookToogleAdm = "https://discord.com/api/webhooks/1059922049298092172/xirBn-4spmSD43EKhjbVdGTBFUXI6Yr9vvUqG7euuIZLMBbK57_-0V2CVcie_ZM5oH3D"
local webhookAdv = "https://discord.com/api/webhooks/1058477887503740980/0md0RXIlG7gm6WnL5_BrL696Z9NqmVctQi6_dqE1WHTPNQ1Ec7zg_9kb9_SeMQ3P4qTS"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ PLACA ]--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('placa',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ac.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"mecanico.permissao") then
		if args[1] then
			local user_id = vRP.getUserByRegistration(args[1])
			if user_id then
				local identity = vRP.getUserIdentity(user_id)
				if identity then
					vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
					TriggerClientEvent('chatMessage',source,"911",{64,64,255},"^2Passaporte: ^0"..identity.user_id.."   ^2|   ^2Placa: ^0"..identity.registration.."   ^2|   ^2Proprietário: ^0"..identity.name.." "..identity.firstname.."   ^2|   ^2Idade: ^0"..identity.age.." anos   ^2|   ^2Telefone: ^0"..identity.phone)
				end
			else
				TriggerClientEvent("Notify",source,"importante","Placa inválida ou veículo de americano.")
			end
		else
			local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
			local placa_user = vRP.getUserByRegistration(placa)
			if placa then
				if placa_user then
					local identity = vRP.getUserIdentity(placa_user)
					if identity then
						local vehicleName = vRP.vehicleName(vname)
						vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
						TriggerClientEvent('chatMessage',source,"911",{64,64,255},"^2Passaporte: ^0"..identity.user_id.."   ^2|   ^2Placa: ^0"..identity.registration.."   ^2|   ^2Placa: ^0"..identity.registration.."   ^2|   ^2Proprietário: ^0"..identity.name.." "..identity.firstname.."   ^2|   ^2Modelo: ^0"..vehicleName.."   ^2|   ^1Idade: ^0"..identity.age.." anos   ^2|   ^2Telefone: ^0"..identity.phone)
					end
				else
					TriggerClientEvent("Notify",source,"importante","Placa inválida ou veículo de americano.")
				end
			end
		end
	end
end)




local funcoes = {}
local blips = {}

funcoes.marcarOcorrencia = function(source,mensagem,cor)
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		for l,w in pairs(policia) do
			local player = vRP.getUserSource(parseInt(w))
			if player then
				async(function()
					local id = idgens:gen()
					blips[id] = vRPclient.addBlip(player,x,y,z,10,cor,"Ocorrência",0.3,false)
					vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
					TriggerClientEvent('chatMessage',player,"911",{64,64,255},mensagem)
					SetTimeout(15000,function() 
                        vRPclient.removeBlip(player,blips[id]) 
                        idgens:free(id) 
                    end)
				end)
			end
		end
    end
end

exports('marcar_ocorrencia', funcoes.marcarOcorrencia)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ EMS ]----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ems', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("paramedico.permissao")
	local paramedicos = 0
	for k,v in ipairs(oficiais) do
		local identity = vRP.getUserIdentity(parseInt(v))
		paramedicos = paramedicos + 1
	end
	TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Paramedicos</b> em serviço.")
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ ems ]----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ems2', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("paramedico.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Paramedicos</b> em serviço.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ MEC ]----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mec', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("mecanico.permissao")
	local paramedicos = 0
	for k,v in ipairs(oficiais) do
		local identity = vRP.getUserIdentity(parseInt(v))
		paramedicos = paramedicos + 1
	end
	TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Mecanicos</b> em serviço.")
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ PTR ]----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ptr', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("policia.permissao")
	local paramedicos = 0
	for k,v in ipairs(oficiais) do
		local identity = vRP.getUserIdentity(parseInt(v))
		paramedicos = paramedicos + 1
	end
	TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Oficiais</b> em serviço.")
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ PTR2 ]----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ptr2', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("policia.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Oficiais</b> em serviço.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ PTR3 ]----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ptr3', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("acao-policia.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Oficiais</b> em ação.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ MECS ]---------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mec2', function(source,args,rawCommand)
 	local user_id = vRP.getUserId(source)
 	local player = vRP.getUserSource(user_id)
 	local oficiais = vRP.getUsersByPermission("mecanico.permissao")
 	local paramedicos = 0
 	local oficiais_nomes = ""
 	if vRP.hasPermission(user_id,"mecanico.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
 		for k,v in ipairs(oficiais) do
 			local identity = vRP.getUserIdentity(parseInt(v))
 			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
 			paramedicos = paramedicos + 1
 		end
 		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Mecânicos</b> em serviço.")
 		if parseInt(paramedicos) > 0 then
 			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
 		end
 	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- mcn
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mcn',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"mecanico.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,identity.name.." "..identity.firstname,{224,123,57},rawCommand:sub(4))
			end
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ STAFFON ]----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('staffon', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("ac.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." administradores </b> em serviço.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ MULTAR ]-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('multar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"mecanico.permissao") then
		local id = vRP.prompt(source,"Passaporte:","")
		local valor = vRP.prompt(source,"Valor:","")
		local motivo = vRP.prompt(source,"Motivo:","")
		if id == "" or valor == "" or motivo == "" then
			return
		end
		local value = vRP.getUData(parseInt(id),"vRP:multas")
		local multas = json.decode(value) or 0
		vRP.setUData(parseInt(id),"vRP:multas",json.encode(parseInt(multas)+parseInt(valor)))
		local oficialid = vRP.getUserIdentity(user_id)
		local identity = vRP.getUserIdentity(parseInt(id))
		local nplayer = vRP.getUserSource(parseInt(id))
		
		SendWebhookMessage(webhookmultas,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============MULTOU==============] \n[PASSAPORTE]: "..id.." "..identity.name.." "..identity.firstname.." \n[VALOR]: $"..vRP.format(parseInt(valor)).." \n[MOTIVO]: "..motivo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		-- randmoney = math.random(90,150)
		-- vRP.giveMoney(user_id,parseInt(randmoney))
		TriggerClientEvent("Notify",source,"sucesso","Multa aplicada com sucesso.")
		TriggerClientEvent("Notify",source,"importante","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b> de bonificação.")
		TriggerClientEvent("Notify",nplayer,"importante","Você foi multado em <b>$"..vRP.format(parseInt(valor)).." dólares</b>.<br><b>Motivo:</b> "..motivo..".")
		vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ STAFFOFF ]----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('staffoff', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("paisana-staff.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"ac.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." administradores </b> fazendo RP.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ L ]------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local policia = {}
RegisterCommand('p',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if vRPclient.getHealth(source) > 101 then
		if vRP.hasPermission(user_id,"policia.permissao") then
			local soldado = vRP.getUsersByPermission("policia.permissao")
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player and player ~= uplayer then
					async(function()
						local id = idgens:gen()
						policia[id] = vRPclient.addBlip(player,x,y,z,304,3,"Localização de "..identity.name.." "..identity.firstname,0.6,false)
						TriggerClientEvent("Notify",player,"importante","Localização recebida de <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
						TriggerClientEvent("Notify",uplayer,"importante","Localização enviada.",10000)
						vRPclient._playSound(player,"Place_Prop_Fail","DLC_Dmod_Prop_Editor_Sounds")
						SetTimeout(30000,function()
							idgens:free(id)
							vRPclient.removeBlip(player,policia[id])
							policia[id] = nil
						end)
					end)
				end
				Citizen.Wait(10)
			end
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ PD ]-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pd',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,'policia.permissao') or vRP.hasPermission(user_id, 'acao-policia.permissao') or vRP.hasPermission(user_id, 'comando-acao-policia.permissao') then
			local soldado = vRP.getUsersByPermission("policia.permissao")
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,identity.name.." "..identity.firstname.." ",{64,179,255},rawCommand:sub(3))
					end)
				end
			end
			local soldado2 = vRP.getUsersByPermission("acao-policia.permissao")
			for l,w in pairs(soldado2) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,identity.name.." "..identity.firstname.." ",{64,179,255},rawCommand:sub(3))
					end)
				end
			end
			local soldado3 = vRP.getUsersByPermission("comando-acao-policia.permissao")
			for l,w in pairs(soldado3) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,identity.name.." "..identity.firstname.." ",{64,179,255},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('toogle',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    -- Verifica se a policia está ativa
    local status = "Entrou"

	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
		
	if vRP.hasPermission(user_id,"policial.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"paisana-policia")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
		-- vRPclient.giveWeapons(source,{},true)
	elseif vRP.hasPermission(user_id,"paisana-policia.permissao") then
		TriggerEvent('eblips:add',{ name = "Policial", src = source, color = 3 })
		vRP.addUserGroup(user_id,"policia")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		
	elseif vRP.hasPermission(user_id,"medico-policia.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"medico-paisana-policia")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[MEDICO-POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"medico-paisana-policia.permissao") then
		TriggerEvent('eblips:add',{ name = "Medico Policial", src = source, color = 63 })
		vRP.addUserGroup(user_id,"medico-policia")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[MEDICO-POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

	elseif vRP.hasPermission(user_id,"comando-policia.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"comando-paisana-policia")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[MEDICO-POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"comando-paisana-policia.permissao") then
		TriggerEvent('eblips:add',{ name = "Comandante Policial", src = source, color = 47 })
		vRP.addUserGroup(user_id,"comando-policia")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[MEDICO-POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	
	elseif vRP.hasPermission(user_id,"mecanico.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"paisana-mecanico")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookmecanico,"```prolog\n[MECANICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"paisana-mecanico.permissao") then
		vRP.addUserGroup(user_id,"mecanico")
		-- TriggerEvent('eblips:add',{ name = "Mecânico", src = source, color = 40 })
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookmecanico,"```prolog\n[MECANICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"para.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"paisana-paramedico")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[PARAMEDICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"paisana-paramedico.permissao") then
		TriggerEvent('eblips:add',{ name = "Paramedico", src = source, color = 61 })
		vRP.addUserGroup(user_id,"paramedico")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[PARAMEDICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"enfermeiro.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"paisana-enfermeiro")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[ENFERMEIRO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"paisana-enfermeiro.permissao") then
		TriggerEvent('eblips:add',{ name = "Paramedico", src = source, color = 61 })
		vRP.addUserGroup(user_id,"enfermeiro")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[ENFERMEIRO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"medico.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"paisana-medico")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[MEDICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"paisana-medico.permissao") then
		TriggerEvent('eblips:add',{ name = "Paramedico", src = source, color = 61 })
		vRP.addUserGroup(user_id,"medico")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[MEDICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"psicologo.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"paisana-psicologo")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[PSICOLOGO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"paisana-psicologo.permissao") then
		TriggerEvent('eblips:add',{ name = "Paramedico", src = source, color = 61 })
		vRP.addUserGroup(user_id,"psicologo")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[PSICOLOGO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"especialista.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"paisana-especialista")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[ESPECIALISTA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"paisana-especialista.permissao") then
		TriggerEvent('eblips:add',{ name = "Paramedico", src = source, color = 61 })
		vRP.addUserGroup(user_id,"especialista")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[ESPECIALISTA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"diretor.permissao") then
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"paisana-diretor")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[DIRETOR]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"paisana-diretor.permissao") then
		TriggerEvent('eblips:add',{ name = "Paramedico", src = source, color = 61 })
		vRP.addUserGroup(user_id,"diretor")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[DIRETOR]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE 2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('toogle2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	if vRP.hasPermission(user_id,"comando-acao-policia.permissao") then
		vRP.addUserGroup(user_id,"comando-policia")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de ação.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[COMANDO-POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE ACAO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"comando-policia.permissao") then
		vRP.addUserGroup(user_id,"comando-acao-policia")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em ação.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[COMANDO-POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM ACAO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")	
	
	elseif vRP.hasPermission(user_id,"medico-acao-policia.permissao") then
		vRP.addUserGroup(user_id,"medico-policia")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de ação.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[MEDICO-POLICIAL]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE ACAO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"medico-policia.permissao") then
		vRP.addUserGroup(user_id,"medico-acao-policia")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em ação.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[MEDICO-POLICIAL]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM ACAO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		
	
	elseif vRP.hasPermission(user_id,"acao-policia.permissao") then
		vRP.addUserGroup(user_id,"policia")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de ação.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE ACAO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent('desligarRadios',source)
	elseif vRP.hasPermission(user_id,"policial.permissao") then
		vRP.addUserGroup(user_id,"acao-policia")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em ação.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[POLICIA]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM ACAO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		
	end

end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('toogleadm',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"ceo.permissao") then
		vRP.removeUserGroup(user_id,"CEO")
		vRP.addUserGroup(user_id,"PaisanaCeo")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookToogleAdm,"```prolog\n[CEO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========SAIU DE SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")	
	elseif vRP.hasPermission(user_id,"paisana-ceo.permissao") then
		vRP.addUserGroup(user_id,"CEO")
		vRP.removeUserGroup(user_id,"PaisanaCeo")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookToogleAdm,"```prolog\n[CEO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		
	elseif vRP.hasPermission(user_id,"admin.permissao") then
		vRP.addUserGroup(user_id,"PaisanaAdmin")
		vRP.removeUserGroup(user_id,"Admin")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookToogleAdm,"```prolog\n[ADM]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========SAIU DE SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")	
	elseif vRP.hasPermission(user_id,"paisana-admin.permissao") then
		vRP.addUserGroup(user_id,"Admin")
		vRP.removeUserGroup(user_id,"PaisanaAdmin")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookToogleAdm,"```prolog\n[ADM]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		

	elseif vRP.hasPermission(user_id,"mod.permissao") then
		vRP.addUserGroup(user_id,"PaisanaMod")
		vRP.removeUserGroup(user_id,"Mod")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookToogleAdm,"```prolog\n[MOD]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========SAIU DE SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		
	elseif vRP.hasPermission(user_id,"paisana-mod.permissao") then
		vRP.removeUserGroup(user_id,"PaisanaMod")
		vRP.addUserGroup(user_id,"Mod")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookToogleAdm,"```prolog\n[MOD]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		

	elseif vRP.hasPermission(user_id,"suporte.permissao") then
		vRP.addUserGroup(user_id,"PaisanaSup")
		vRP.removeUserGroup(user_id,"Suporte")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookToogleAdm,"```prolog\n[SUP]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========SAIU DE SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		
	elseif vRP.hasPermission(user_id,"paisana-sup.permissao") then
		vRP.removeUserGroup(user_id,"PaisanaSup")
		vRP.addUserGroup(user_id,"Suporte")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookToogleAdm,"```prolog\n[SUP]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		

	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ OCORRENCIA ]---------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ocorrencia',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
 
	if vRP.hasPermission(user_id,"policia.permissao") then
		local source = source
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		

		local id = vRP.prompt(source,"Passaporte:","")
		local ocorrencia = vRP.prompt(source,"Ocorrência:","")
		if id == "" or ocorrencia == "" then
			return
		end
		local oficialid = vRP.getUserIdentity(user_id)
		local identity = vRP.getUserIdentity(parseInt(id))
		local nplayer = vRP.getUserSource(parseInt(id))
		local crm = user_id

		PerformHttpRequest(webhookocorrencias, function(err, text, headers) end, 'POST', json.encode({
			embeds = {
				{ 
					title = "OCORRENCIA:",
					thumbnail = {
					url = "https://cdn.discordapp.com/attachments/788126888463564810/834886783417974794/1619122760818.png"
					}, 
					fields = {
						{ 
							name = "**NOME:**", 
							value = nomep.." ",
							inline = true
						},
						{ 
							name = "**RG DO PACIENTE:**",
							value = id,
							inline = true
						},
						{ 
							name = "**OCORRENCIA:**",
							value = ocorrencia,
							inline = true
						},
						{ 
							name = "**DATA DO ATENDIMENTO:**",
							value = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),
						},
						{ 
							name = "**NOME DO MÉDICO:**",
							value = identity.name.." "..identity.firstname,
							inline = true
						},
						{ 
							name = "**CRM:**",
							value = crm.."\n⠀",
							inline = true
						},
 
					}, 
					footer = { 
						text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
						icon_url = "https://cdn.discordapp.com/attachments/788126888463564810/834886783417974794/1619122760818.png" 
					},
					color = 13893882 
				}
			}
		}), { ['Content-Type'] = 'application/json' })
	end
 end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ DETIDO ]-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('detido',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") then
        local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,5)
        local motivo = vRP.prompt(source,"Motivo:","")
        if motivo == "" then
			return
		end
		local oficialid = vRP.getUserIdentity(user_id)
        if vehicle then
            local puser_id = vRP.getUserByRegistration(placa)
            local rows = vRP.query("creative/get_vehicles",{ user_id = parseInt(puser_id), vehicle = vname })
            if rows[1] then
                if parseInt(rows[1].detido) == 1 then
                    TriggerClientEvent("Notify",source,"importante","Este veículo já se encontra detido.",8000)
                else
                	local identity = vRP.getUserIdentity(puser_id)
					local nplayer = vRP.getUserSource(parseInt(puser_id))
					
                	SendWebhookMessage(webhookdetido,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============PRENDEU==============] \n[CARRO]: "..vname.." \n[PASSAPORTE]: "..puser_id.." "..identity.name.." "..identity.firstname.." \n[MOTIVO]: "..motivo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					vRP.execute("creative/set_detido",{ user_id = parseInt(puser_id), vehicle = vname, detido = 1, time = parseInt(os.time()) })

					randmoney = math.random(90,150)
					vRP.giveMoney(user_id,parseInt(randmoney))
					TriggerClientEvent("Notify",source,"sucesso","Carro apreendido com sucesso.")
					TriggerClientEvent("Notify",source,"importante","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b> de bonificação.")
					TriggerClientEvent("Notify",nplayer,"importante","Seu Veículo foi <b>Detido</b>.<br><b>Motivo:</b> "..motivo..".")
					vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
                end
            end
        end
    end
end)

RegisterCommand('adv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ac.permissao") then
		local crimes = vRP.prompt(source,"Motivo da ADV:","")
		if crimes == "" then
			return
		end
		local player = vRP.getUserSource(parseInt(args[1]))
		if player then
			local oficialid = vRP.getUserIdentity(user_id)
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			local nplayer = vRP.getUserSource(parseInt(args[1]))

			vRP.setUData(parseInt(args[1]),"vRP:prisao",json.encode(parseInt(args[2])))
			vRPclient.setHandcuffed(player,false)
			TriggerClientEvent('EG:prisioneiro',player,true)
			vRPclient.teleport(player,1680.1,2513.0,45.5)
			TriggerClientEvent('removealgemas',player)
			TriggerClientEvent("vrp_sound:source",player,'jaildoor',0.7)
			TriggerClientEvent("vrp_sound:source",source,'jaildoor',0.7)

			
			SendWebhookMessage(webhookAdv,"```prolog\n[ADM]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[===========ADVERTENCIA===========] \n[PASSAPORTE]: "..(args[1]).." "..identity.name.." "..identity.firstname.." \n[TEMPO]: "..vRP.format(parseInt(args[2])).." Meses \n[MOTIVO]: "..crimes.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

			TriggerClientEvent("Notify",source,"sucesso","Prisão ADV efetuada com sucesso.")
			TriggerClientEvent("Notify",nplayer,"importante","Você foi preso por <b>"..vRP.format(parseInt(args[2])).." meses</b>.<br><b>Motivo:</b> "..crimes..".")
			vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
			SetTimeout(1000,function()
				local model = vRPclient.getModelPlayer(nplayer)
				if model == "mp_m_freemode_01" then
					TriggerClientEvent("updateRoupas",nplayer,{ -1,0,-1,0,0,0,15,0,64,6,15,0,1,0,238,0,-1,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 })
				elseif model == "mp_f_freemode_01" then
					TriggerClientEvent("updateRoupas",nplayer,{ -1,0,0,0,0,0,4,0,101,6,7,0,1,1,247,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 })
				end
			end)
		end 
	end
end)

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --[ RG ]-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('rg',function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"policia.permissao")  or vRP.hasPermission(user_id,"paramedico.permissao") then
-- 		if args[1] then
-- 			local nplayer = vRP.getUserSource(parseInt(args[1]))
-- 			if nplayer == nil then
-- 				TriggerClientEvent("Notify",source,"aviso","Passaporte <b>"..args[1].."</b> indisponível no momento.")
-- 				return
-- 			end
-- 			nuser_id = vRP.getUserId(nplayer)
-- 			if nuser_id then
-- 				local value = vRP.getUData(nuser_id,"vRP:multas")
-- 				local valormultas = json.decode(value) or 0
-- 				local identity = vRP.getUserIdentity(nuser_id)
-- 				local carteira = vRP.getMoney(nuser_id)
-- 				local banco = vRP.getBankMoney(nuser_id)
-- 				vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 18%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"></div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div><div class=\"local2\"><b>Carteira:</b> "..vRP.format(parseInt(carteira)).."</div>")
-- 				vRP.request(source,"Você deseja fechar o registro geral?",1000)
-- 				vRPclient.removeDiv(source,"completerg")
-- 			end
-- 		else
-- 			local nplayer = vRPclient.getNearestPlayer(source,2)
-- 			local nuser_id = vRP.getUserId(nplayer)
-- 			if nuser_id then
-- 				local value = vRP.getUData(nuser_id,"vRP:multas")
-- 				local valormultas = json.decode(value) or 0
-- 				local identityv = vRP.getUserIdentity(user_id)
-- 				local identity = vRP.getUserIdentity(nuser_id)
-- 				local carteira = vRP.getMoney(nuser_id)
-- 				local banco = vRP.getBankMoney(nuser_id)
-- 				-- TriggerClientEvent("Notify",nplayer,"importante","Seu documento está sendo verificado por <b>"..identityv.name.." "..identityv.firstname.."</b>.")
-- 				vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 18%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"><b>Telefone:</b> " "</div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div><div class=\"local2\"><b>Carteira:</b> "..vRP.format(parseInt(carteira)).."</div>")
-- 				vRP.request(source,"Você deseja fechar o registro geral?",1000)
-- 				vRPclient.removeDiv(source,"completerg")
-- 			end
-- 		end
-- 	end
-- end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ RG ]-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rg',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"policia.permissao")  or vRP.hasPermission(user_id,"paramedico.permissao") then
		if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer == nil then
				TriggerClientEvent("Notify",source,"aviso","Passaporte <b>"..args[1].."</b> indisponível no momento.")
				return
			end
			nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local value = vRP.getUData(nuser_id,"vRP:multas")
				local valormultas = json.decode(value) or 0
				local identity = vRP.getUserIdentity(nuser_id)
				local carteira = vRP.getMoney(nuser_id)
				local banco = vRP.getBankMoney(nuser_id)
				vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 18%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"></div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div><div class=\"local2\"><b>Carteira:</b> "..vRP.format(parseInt(carteira)).."</div>")
				vRP.request(source,"Você deseja fechar o registro geral?",1000)
				vRPclient.removeDiv(source,"completerg")
			end
		else
			local nplayer = vRPclient.getNearestPlayer(source,2)
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local value = vRP.getUData(nuser_id,"vRP:multas")
				local valormultas = json.decode(value) or 0
				local identityv = vRP.getUserIdentity(user_id)
				local identity = vRP.getUserIdentity(nuser_id)
				local carteira = vRP.getMoney(nuser_id)
				local banco = vRP.getBankMoney(nuser_id)
				-- TriggerClientEvent("Notify",nplayer,"importante","Seu documento está sendo verificado por <b>"..identityv.name.." "..identityv.firstname.."</b>.")
				vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 18%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"></div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div><div class=\"local2\"><b>Carteira:</b> "..vRP.format(parseInt(carteira)).."</div>")
				vRP.request(source,"Você deseja fechar o registro geral?",1000)
				vRPclient.removeDiv(source,"completerg")
			end
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- ALGEMAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_policia:algemar")
AddEventHandler("vrp_policia:algemar",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if nplayer then
		if not vRPclient.isHandcuffed(source) then
			if vRPclient.isInVehicle(source) then
				TriggerClientEvent("Notify",source,"negado","Você não pode saquear de dentro do carro.")
				return
			end
			if vRP.getInventoryItemAmount(user_id,"algema") >= 1 then
				if vRPclient.isHandcuffed(nplayer) then
					TriggerClientEvent('carregar',nplayer,source)
					vRPclient._playAnim(source,false,{{"mp_arresting","a_uncuff"}},false)
					SetTimeout(5000,function()
						vRP.tryGetInventoryItem(user_id,'algema',1)
						vRPclient.toggleHandcuff(nplayer)
						TriggerClientEvent('carregar',nplayer,source)
						TriggerClientEvent("vrp_sound:source",source,'uncuff',0.1)
						TriggerClientEvent("vrp_sound:source",nplayer,'uncuff',0.1)
						TriggerClientEvent('removealgemas',nplayer)
					end)
				else
					TriggerClientEvent('cancelando',source,true)
					TriggerClientEvent('cancelando',nplayer,true)
					TriggerClientEvent('carregar',nplayer,source)
					vRPclient._playAnim(source,false,{{"mp_arrest_paired","cop_p2_back_left"}},false)
					vRPclient._playAnim(nplayer,false,{{"mp_arrest_paired","crook_p2_back_left"}},false)
					SetTimeout(3500,function()
						vRPclient._stopAnim(source,false)
						vRPclient.toggleHandcuff(nplayer)
						TriggerClientEvent('carregar',nplayer,source)
						TriggerClientEvent('cancelando',source,false)
						TriggerClientEvent('cancelando',nplayer,false)
						TriggerClientEvent("vrp_sound:source",source,'cuff',0.1)
						TriggerClientEvent("vrp_sound:source",nplayer,'cuff',0.1)
						TriggerClientEvent('setalgemas',nplayer)
					end)
				end
			else
				if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"juiz.permissao") then
					if vRPclient.isHandcuffed(nplayer) then
						TriggerClientEvent('carregar',nplayer,source)
						vRPclient._playAnim(source,false,{{"mp_arresting","a_uncuff"}},false)
						SetTimeout(5000,function()
							vRPclient.toggleHandcuff(nplayer)
							TriggerClientEvent('carregar',nplayer,source)
							TriggerClientEvent("vrp_sound:source",source,'uncuff',0.1)
							TriggerClientEvent("vrp_sound:source",nplayer,'uncuff',0.1)
							TriggerClientEvent('removealgemas',nplayer)
						end)
					else
						TriggerClientEvent('cancelando',source,true)
						TriggerClientEvent('cancelando',nplayer,true)
						TriggerClientEvent('carregar',nplayer,source)
						vRPclient._playAnim(source,false,{{"mp_arrest_paired","cop_p2_back_left"}},false)
						vRPclient._playAnim(nplayer,false,{{"mp_arrest_paired","crook_p2_back_left"}},false)
						SetTimeout(3500,function()
							vRPclient._stopAnim(source,false)
							vRPclient.toggleHandcuff(nplayer)
							TriggerClientEvent('carregar',nplayer,source)
							TriggerClientEvent('cancelando',source,false)
							TriggerClientEvent('cancelando',nplayer,false)
							TriggerClientEvent("vrp_sound:source",source,'cuff',0.1)
							TriggerClientEvent("vrp_sound:source",nplayer,'cuff',0.1)
							TriggerClientEvent('setalgemas',nplayer)
						end)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_policia:carregar")
AddEventHandler("vrp_policia:carregar",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"juiz.permissao") then	
		if nplayer then
			if not vRPclient.isHandcuffed(source) then
				TriggerClientEvent('carregar',nplayer,source)
			end
		end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ RMASCARA ]-----------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rmascara',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"paramedico.permissao")  then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			TriggerClientEvent('rmascara',nplayer)
		end
	end
end)

RegisterCommand('anuncio',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"conce.permissao") or vRP.hasPermission(user_id,"jornalista.permissao") then
		local identity = vRP.getUserIdentity(user_id)
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(0,128,192,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 7%; right: 15%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 15px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: "..identity.name.." "..identity.firstname)
		SendWebhookMessage(webhookchatadm,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MENSAGEM ANUNCIO]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		SetTimeout(30000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ RCHAPEU ]------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rchapeu',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			TriggerClientEvent('rchapeu',nplayer)
		end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ RCAPUZ ]-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rcapuz',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"ac.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			if vRPclient.isCapuz(nplayer) then
				vRPclient.setCapuz(nplayer)
				TriggerClientEvent("Notify",source,"sucesso","Capuz colocado com sucesso.")
			else
				TriggerClientEvent("Notify",source,"importante","A pessoa não está com o capuz na cabeça.")
			end
		end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ CV ]-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,10)
		if nplayer then
			vRPclient.putInNearestVehicleAsPassenger(nplayer,7)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ RV ]-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,10)
		if nplayer then
			vRPclient.ejectVehicle(nplayer)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ APREENDER ]----------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	"celular",
	"radio",
	"roupas",
	"dinheiro-sujo",
	"algema",
	"lockpick",
	"capuz",
	"placa",
	"c4",
	"metanfetamina",
	"meta-alta",
	"composito-alta",
	"nitrato-amonia",
	"pecadearma",
	"pecadefuzil",
	"hidroxido-sodio",
	"coca-alta",
	"pasta-alta",
	"acido-sulfurico",
	"folhas-coca",
	"maconha-alta",
	"maconha",
	"cocaina",
	"canabis-alta",
	"pecadearma",
	"molas",
	"placa-metal",
	"gatilho",
	"capsulas",
	"polvora",
	"wbody|WEAPON_FLARE",
	"wbody|WEAPON_KNIFE",
	"wbody|WEAPON_DAGGER",
	"wbody|WEAPON_KNUCKLE",
	"wbody|WEAPON_MACHETE",
	"wbody|WEAPON_SWITCHBLADE",
	"wbody|WEAPON_WRENCH",
	"wbody|WEAPON_HAMMER",
	"wbody|WEAPON_GOLFCLUB",
	"wbody|WEAPON_CROWBAR",
	"wbody|WEAPON_HATCHET",
	"wbody|WEAPON_FLASHLIGHT",
	"wbody|WEAPON_BAT",
	"wbody|WEAPON_BOTTLE",
	"wbody|WEAPON_BATTLEAXE",
	"wbody|WEAPON_POOLCUE",
	"wbody|WEAPON_STONE_HATCHET",
	"wbody|WEAPON_NIGHTSTICK",
	"wbody|WEAPON_COMBATPISTOL",
	"wbody|WEAPON_PISTOL_MK2",
	"wbody|WEAPON_PISTOL",
	"wbody|WEAPON_SNSPISTOL",
	"wbody|WEAPON_STUNGUN",
	"wbody|WEAPON_ASSAULTRIFLE",
	"wbody|WEAPON_CARBINERIFLE",
	"wbody|WEAPON_SPECIALCARBINE",
	"wbody|WEAPON_SMG",
	"wbody|WEAPON_MACHINEPISTOL",

	"wammo|WEAPON_FLARE",
	"wammo|WEAPON_COMBATPISTOL",
	"wammo|WEAPON_PISTOL_MK2",
	"wammo|WEAPON_PISTOL",
	"wammo|WEAPON_SNSPISTOL",
	"wammo|WEAPON_PISTOL50",
	"wammo|WEAPON_STUNGUN",
	"wammo|WEAPON_ASSAULTRIFLE",
	"wammo|WEAPON_CARBINERIFLE",
	"wammo|WEAPON_SPECIALCARBINE",
	"wammo|WEAPON_SMG",
	"wammo|WEAPON_MACHINEPISTOL",
	"wammo|WEAPON_PUMPSHOTGUN_MK2",
	"wbody|WEAPON_MICROSMG",
	
	"wammo|WEAPON_MUSKET"
}

RegisterCommand('apreender',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local user_id = vRP.getUserId(source)

		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			local identity = vRP.getUserIdentity(user_id)
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local nidentity = vRP.getUserIdentity(nuser_id)
				local itens_apreendidos = {}
				local weapons = vRPclient.replaceWeapons(nplayer,{})
				local inv = vRP.getInventory(nuser_id)

				for k,v in pairs(itemlist) do
					local sub_items = { v }
					if string.sub(v,1,1) == "*" then
						local idname = string.sub(v,2)
						sub_items = {}
						for fidname,_ in pairs(inv) do
							if splitString(fidname,"|")[1] == idname then
								table.insert(sub_items,fidname)
							end
						end
					end

					for _,idname in pairs(sub_items) do
						local amount = vRP.getInventoryItemAmount(nuser_id,idname)
						if amount > 0 then
							local item_name = idname
							if item_name then 
								if vRP.tryGetInventoryItem(nuser_id,idname,amount,true) then
									table.insert(itens_apreendidos, "[ITEM]: "..vRP.itemNameList(idname).." [QUANTIDADE]: "..amount)
								end
							end
						end
					end
				end
				local apreendidos = table.concat(itens_apreendidos, "\n")
				
				SendWebhookMessage(webhookpoliciaapreendidos,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APREENDEU DE]:  "..nuser_id.." "..nidentity.name.." "..nidentity.firstname.."\n" .. apreendidos ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

				TriggerClientEvent("Notify",nplayer,"importante","Todos os seus pertences foram apreendidos.")
				TriggerClientEvent("Notify",source,"importante","Apreendeu todos os pertences da pessoa.")
			end
		end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ EXTRAS ]-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('extras',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
        if vRPclient.isInVehicle(source) then
            TriggerClientEvent('extras',source)
        end
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ TRYEXTRAS ]----------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryextras")
AddEventHandler("tryextras",function(index,extra)
    TriggerClientEvent("syncextras",-1,index,parseInt(extra))
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ CONE ]---------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cone',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao")  or vRP.hasPermission(user_id,"mecanico.permissao") then
		TriggerClientEvent('cone',source,args[1])
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ BARREIRA ]-----------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('barreira',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao")  or vRP.hasPermission(user_id,"mecanico.permissao") then
		TriggerClientEvent('barreira',source,args[1])
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ SPIKE ]--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('spike',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao")  or vRP.hasPermission(user_id,"mecanico.permissao") then
		TriggerClientEvent('spike',source,args[1])
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ DISPAROS ]-----------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('atirando')
AddEventHandler('atirando',function(x,y,z)
	local source = source
	local user_id = vRP.getUserId(source)
	local sessao = GetPlayerRoutingBucket(source)

	if user_id and sessao == 0 then
		if not vRP.hasPermission(user_id,"policia.permissao") and not vRP.hasPermission(user_id,"policial-em-acao.permissao") then
			local policiais = vRP.getUsersByPermission("policia.permissao")
			for l,w in pairs(policiais) do
				local player = vRP.getUserSource(w)
				if player then
					TriggerClientEvent('notificacao',player,x,y,z,user_id)
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT STAFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('s',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local permission = "ac.permissao"
		if vRP.hasPermission(user_id,permission) then
			local soldado = vRP.getUsersByPermission(permission)
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,"["..identity.user_id.."] "..identity.name.." "..identity.firstname,{255,0,0},rawCommand:sub(2))
					end)
				end
			end
		end
	end
end)

--------------------------------------------------------------------------------------------------------------------------------
--- [ EXTRAS] ------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
-- RegisterServerEvent("extras:invokeSystem")
-- AddEventHandler("extras:invokeSystem",function(action)
-- 	local source = GetPedSourceOfDamage
-- 	local user_id = vRP.getUserId(source)
-- 	TriggerClientEvent("extrasLivery",source,action)
-- end)
