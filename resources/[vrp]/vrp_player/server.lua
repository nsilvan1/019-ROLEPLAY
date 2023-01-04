local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
local cfg = module("vrp","cfg/groups")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local idgens = Tools.newIDGenerator()

src = {}
Tunnel.bindInterface("vrp_player",src)
Proxy.addInterface("vrp_player",src)
-- KX_me = {}
-- Tunnel.bindInterface("vrp_player",KX_me)
-- KX_meCl = Tunnel.getInterface("vrp_player")


-----------------------------------------------------------------------------------------------------------------------------------------
--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare ("EG/controleChamados", "INSERT INTO eg_controle_staff(user_id,chamados) VALUES(@user_id,@chamados)")
vRP.prepare ("EG/addVipStarter", "INSERT INTO fstore_appointments(command,expires_at) VALUES(@string,CURRENT_DATE()+3)")
vRP.prepare("EG/updateVipStarter","UPDATE vrp_users SET vipteste = 1 WHERE id = @user_id")
vRP.prepare("EG/getVipStarter","SELECT vipteste FROM vrp_users WHERE id = @user_id")

local groups = cfg.groups
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Identidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local cash = vRP.getMoney(user_id)
		local banco = vRP.getBankMoney(user_id)
		local identity = vRP.getUserIdentity(user_id)
		local multas = vRP.getUData(user_id,"vRP:multas")
		local mymultas = json.decode(multas) or 0
		local paypal = vRP.getUData(user_id,"vRP:paypal")
		local mypaypal = json.decode(paypal) or 0
		local job = src.getUserGroupByType(user_id,"job")
		local vip = src.getUserGroupByType(user_id,"vip")
		if identity then
			return vRP.format(parseInt(cash)),vRP.format(parseInt(banco)),identity.name,identity.firstname,identity.age,identity.user_id,identity.registration,identity.phone,job,vip,vRP.format(parseInt(mymultas)),vRP.format(parseInt(mypaypal))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDRICH
-----------------------------------------------------------------------------------------------------------------------------------------
function src.GetDCpresence()
    local onlinePlayers = GetNumPlayerIndices()
    return onlinePlayers + 1
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.getUserGroupByType(user_id,gtype)
	local user_groups = vRP.getUserGroups(user_id)
	for k,v in pairs(user_groups) do
		local kgroup = groups[k]
		if kgroup then
			if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then
				return kgroup._config.title
			end
		end
	end
	return ""
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CHECK ROUPAS ]-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkRoupas()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"roupas") >= 1 or 
		   vRP.hasPermission(user_id,"diamante.permissao") or 
		   vRP.hasPermission(user_id,"esmeralda.permissao") or 
		   vRP.hasPermission(user_id,"aztlan.permissao") then
			return true 
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila ou VIP Diamante.") 
			return false
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--[ USER VEHS [ADMIN]]-------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('uservehs',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
        	local nuser_id = parseInt(args[1])
            if nuser_id > 0 then 
                local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(nuser_id) })
                local car_names = {}
                for k,v in pairs(vehicle) do
                	table.insert(car_names, "<b>" .. vRP.vehicleName(v.vehicle) .. "</b>")
                end
                car_names = table.concat(car_names, ", ")
                local identity = vRP.getUserIdentity(nuser_id)
                TriggerClientEvent("Notify",source,"importante","Veículos de <b>"..identity.name.." " .. identity.firstname.. " ("..#vehicle..")</b>: "..car_names,10000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ RESKIN ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('reskin',function(source,rawCommand)
	local user_id = vRP.getUserId(source)		
	vRPclient._setCustomization(vRPclient.getCustomization(source))		
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ID ]---------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('id',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		local value = vRP.getUData(nuser_id,"vRP:multas")
		local valormultas = json.decode(value) or 0
		local identityv = vRP.getUserIdentity(user_id)
		local identity = vRP.getUserIdentity(nuser_id)
		local carteira = vRP.getMoney(nuser_id)
		local banco = vRP.getBankMoney(nuser_id)
		vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 18%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>ID:</b> ( "..vRP.format(identity.registration).." )</div>")
		vRP.request(source,"Você deseja fechar o registro geral?",1000)
		vRPclient.removeDiv(source,"completerg")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SALÁRIO ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local salarios = {
	-- VIPS
	{ ['permissao'] = "bronze.permissao", ['nome'] = "Bronze", ['payment'] = 2000 },
	{ ['permissao'] = "prata.permissao", ['nome'] = "Prata", ['payment'] = 4000 },
    { ['permissao'] = "ouro.permissao", ['nome'] = "Ouro", ['payment'] = 6000 },
    { ['permissao'] = "diamante4.permissao", ['nome'] = "Diamante", ['payment'] = 8000 },
    { ['permissao'] = "esmeralda.permissao", ['nome'] = "Esmeralda", ['payment'] = 12000 },

	{ ['permissao'] = "aztlan.permissao", ['nome'] = "Aztlan", ['payment'] = 20000 },
	{ ['permissao'] = "aztlan2.permissao", ['nome'] = "Flush2", ['payment'] = 20000 },
	
	{ ['permissao'] = "patrao.permissao", ['nome'] = "Patrão", ['payment'] = 20000 },
	{ ['permissao'] = "gerente.permissao", ['nome'] = "Gerente", ['payment'] = 7000 },
	{ ['permissao'] = "funcionario.permissao", ['nome'] = "Funcionario", ['payment'] = 5000 },
	{ ['permissao'] = "estagiario.permissao", ['nome'] = "Estagiario", ['payment'] = 2000 },
	{ ['permissao'] = "booster.permissao", ['nome'] = "Booster", ['payment'] = 500 },
	{ ['permissao'] = "news.permissao", ['nome'] = "News", ['payment'] = 0 },
	{ ['permissao'] = "advogado.permissao", ['nome'] = "Advogado(a)", ['payment'] = 6000 },
	{ ['permissao'] = "desembargador.permissao", ['nome'] = "Desembargador", ['payment'] = 8500 },
	{ ['permissao'] = "promotor.permissao", ['nome'] = "Promotor(a)", ['payment'] = 7000 },
	{ ['permissao'] = "juiz.permissao", ['nome'] = "Juiz", ['payment'] = 7500 },
	{ ['permissao'] = "diretor.permissao", ['nome'] = "Hospital Diretor", ['payment'] = 10000 },
	{ ['permissao'] = "especialista.permissao", ['nome'] = "Especialista", ['payment'] = 9500 },
	{ ['permissao'] = "psicologo.permissao", ['nome'] = "Psicologo", ['payment'] = 9000 },
	{ ['permissao'] = "medico.permissao", ['nome'] = "Medico", ['payment'] = 9000 },
	{ ['permissao'] = "enfermeiro.permissao", ['nome'] = "Enfermeiro", ['payment'] = 8000 },
	{ ['permissao'] = "para.permissao", ['nome'] = "Hospital", ['payment'] = 8000 },
	{ ['permissao'] = "mecanico.permissao", ['nome'] = "Mêcanico", ['payment'] = 5000 },
}

RegisterServerEvent('salario:pagamento2')
AddEventHandler('salario:pagamento2',function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(salarios) do
			if vRP.hasPermission(user_id,v.permissao) then
				TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				TriggerClientEvent("Notify",source,"importante","Obrigado por colaborar com a cidade, seu salario <b>"..v.nome.." de $"..vRP.format(parseInt(v.payment)).." dólares</b> foi depositado.")
				-- sendLog('LogSalario',"[ID]:"..user_id.." \n[VALOR]: "..vRP.format(parseInt(v.payment)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
				vRP.giveBankMoney(user_id,parseInt(v.payment))
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERM
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkperm()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
		return true 
        -- if vRP.hasPermission(user_id,"master.permissao") or vRP.hasPermission(user_id,"platina.permissao") then
        -- else
        --     TriggerClientEvent("Notify",source,"negado","Você não possui permissão.") 
        -- end
    end
end

function src.checkMasterPerm()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"esmeralda.permissao") or vRP.hasPermission(user_id,"ac.permissao") or vRP.hasPermission(user_id,"diamante.permissao") or vRP.hasPermission(user_id,"aztlan.permissao") then
            return true 
        else
            TriggerClientEvent("Notify",source,"negado","Você não possui VIP ESMERALDA.") 
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--[ SEQUESTRO ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('sequestro',function(source,args,rawCommand)
	local nplayer = vRPclient.getNearestPlayer(source,5)
	if nplayer then
		if vRPclient.isHandcuffed(nplayer) then
			if not vRPclient.getNoCarro(source) then
				local vehicle = vRPclient.getNearestVehicle(source,7)
				if vehicle then
					if vRPclient.getCarroClass(source,vehicle) then
						vRPclient.setMalas(nplayer)
					end
				end
			elseif vRPclient.isMalas(nplayer) then
				vRPclient.setMalas(nplayer)
			end
		else
			TriggerClientEvent("Notify",source,"aviso","A pessoa precisa estar algemada para colocar ou retirar do Porta-Malas.")
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ ENTRAR NO PORTA MALA ]---------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('entrarportamala',function(source,args,rawCommand)
	local source = source
	if source then
		if not vRPclient.getNoCarro(source) then
			local vehicle = vRPclient.getNearestVehicle(source,7)
			if vehicle then
				if vRPclient.getCarroClass(source,vehicle) then
					vRPclient.setMalas(source)
				end
			end
		elseif vRPclient.isMalas(source) then
			vRPclient.setMalas(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ FINALIZAR ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('finalizar',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nplayer_id = vRP.getUserId(nplayer)
	local nplayer_identity = vRP.getUserIdentity(nplayer_id)
	if vRPclient.isInComa(nplayer) then
		TriggerClientEvent("EG:updateSurvival",nplayer,true)
	end

	sendLog('LogFinalizar',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[FINALIZOU O ID]: "..nplayer_id.." "..nplayer_identity.name.." "..nplayer_identity.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- /enviar
-----------------------------------------------------------------------------------------------------------------------------------------
local mCooldown = {}
RegisterCommand('enviar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRPclient.getNearestPlayer(source,2)
    local nuser_id = vRP.getUserId(nplayer)
    if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
        return
    end
    if nuser_id and parseInt(args[1]) > 0 then
        if vRP.tryPayment(user_id,parseInt(args[1]),true) then
            vRP.giveMoney(nuser_id,parseInt(args[1]),true)
            vRPclient._playAnim(source,true,{"mp_common","givetake1_a"},false)
            vRPclient._playAnim(nplayer,true,{"mp_common","givetake1_a"},false)

            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            TriggerClientEvent("Notify",source,"sucesso","Você enviou $"..vRP.format(parseInt(args[1])).." para o "..identitynu.name.." "..identitynu.firstname..".",8000)
            TriggerClientEvent("Notify",nplayer,"sucesso","Você recebeu $"..vRP.format(parseInt(args[1])).." do "..identity.name.." "..identity.firstname..".",8000)
			sendLog('LogEnviarDinheiro',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: $"..vRP.format(parseInt(args[1])).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
			mCooldown[user_id] = true
            SetTimeout(5000,function()
            	mCooldown[user_id] = nil
            end)
        else
            TriggerClientEvent("Notify",source,"negado","Não tem a quantia que deseja enviar.",8000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
    if mCooldown[user_id] ~= nil then 
        vRP.deleteMoney(user_id)
		sendLog('LogDumpDinheiro',"[ID]: "..user_id.."  \n[TENTOU DUPAR DINHEIRO E PERDEU TODO DINHEIRO QUE ESTAVA NA MÃO]  "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECCK PARAMEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkServices()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dmla = vRP.getUsersByPermission("paramedico.permissao")
		if parseInt(#dmla) < 1 then	
			return true
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COBRAR PARAMEDICO E MECANICO 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cobrar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local consulta = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(consulta)
	local resultado = json.decode(consulta) or 0
	local banco = vRP.getBankMoney(nuser_id)
	local identity =  vRP.getUserIdentity(user_id)
	local identityu = vRP.getUserIdentity(nuser_id)
	if vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"mecanico.permissao") or vRP.hasPermission(user_id,"advogado.permissao") then
		if parseInt(args[1]) > 0 then
			if vRP.prompt(consulta,"Deseja pagar <b>$"..vRP.format(parseInt(args[1])).."</b> dólares para <b>"..identity.name.." "..identity.firstname.."</b>? Digite 'sim'","") == "sim" then    
				if banco >= parseInt(args[1]) then
					vRP.setBankMoney(nuser_id,parseInt(banco-args[1]))
					vRP.giveBankMoney(user_id,parseInt(args[1]))
					TriggerClientEvent("Notify",source,"sucesso","Recebeu <b>$"..vRP.format(parseInt(args[1])).." dólares</b> de <b>"..identityu.name.. " "..identityu.firstname.."</b>.")
					sendLog('LogCobrar',"[ID]: "..user_id.."  \n[COBROU]: "..vRP.format(parseInt(args[1])).." \n[DO ID]: "..nuser_id.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)

					local player = vRP.getUserSource(parseInt(args[2]))
					if player == nil then
						return
					else
						local identity = vRP.getUserIdentity(user_id)
						TriggerClientEvent("Notify",player,"importante","<b>"..identity.name.." "..identity.firstname.."</b> transferiu <b>$"..vRP.format(parseInt(args[1])).." dólares</b> para sua conta.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
				end
			end
		else
			TriggerClientEvent("Notify",source,"negado","Impossivel cobrar valor NEGATIVO")
		end
	else
		TriggerClientEvent("Notify",source,"negado","Você não pode cobrar nada enquanto não trabalha para a cidade!")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SOCORRO
-----------------------------------------------------------------------------------------------------------------------------------------
local command = {}
local command2 = {}
Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(command) do 
            if v > 0 then 
                command[k] = v - 1 
                if v == 0 then 
                    command[k] = nil
                end
            end
        end 
        for k,v in pairs(command2) do 
            if v > 0 then 
                command2[k] = v - 1 
                if v == 0 then 
                    command2[k] = nil
                end
            end
        end 
    end
end)

-- REVER
RegisterCommand("socorro",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then 
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(source)))
        if args[1] == "ems" then 
            local paramedic = vRP.getUsersByPermission("paramedico.permissao")
            if #paramedic == 0 and not vRPclient.getFinalizado(source) then 
                if command[user_id] == 0 or not command[user_id] then
                    local request = vRP.request(source, "Você deseja pagar $8.000 pelo tratamento ?", 60)
                    if request then 
                        if vRP.tryFullPayment(user_id,8000) then 
                            TriggerClientEvent("Notify",source,"sucesso","Revivido com sucesso, pagou 8000 pelo tratamento")
							sendLog('LogSocorro',"[ID]: "..user_id.." \n[FOI REVIVIDO PELO /SOCORRO]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
                            command[user_id] = 1800
                            vRPclient.killGod(source)
						end
                    end
                else
                    TriggerClientEvent("Notify",source,"aviso","Aguarde seu cooldown acabar, faltam: <b>" ..command[user_id].. "</b> segundos.") 
                end
			else
				TriggerClientEvent("Notify",source,"aviso","Existem: <b>" ..#paramedic.. " paramédicos</b> em serviço.") 
            end
        -- elseif args[1] == "mec" then
        --     local mecanico = vRP.getUsersByPermission("mecanico.permissao")
        --     if #mecanico == 0 then 
        --         if command2[user_id] == 0 or not command2[user_id] then
        --             local request = vRP.request(source, "Você deseja pagar $10.000 pelo conserto ?", 60)
        --             if request then 
        --                 if vRP.tryFullPayment(user_id,10000) then 
        --                     TriggerClientEvent("reparar",source)
        --                     command2[user_id] = 1800
        --                     TriggerClientEvent("Notify",source,"sucesso","Veículo reparado com sucesso, pagou 10000 pelo conserto")
		-- 					SendWebhookMessage(webhookSocorro,"```prolog\n[ID]: "..user_id.." \n[TEVE O CARRO CONCERTADO PELO /SOCORRO]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        --                 end
        --             end
        --         else
        --             TriggerClientEvent("Notify",source,"aviso","Aguarde seu cooldown acabar, faltam: <b>" ..command2[user_id].. "</b> segundos.") 
        --         end
		-- 	else
		-- 		TriggerClientEvent("Notify",source,"aviso","Existem: <b>" ..#mecanico.. " mecanicos</b> em serviço.") 
        --     end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRYTOW ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trytow")
AddEventHandler("trytow",function(nveh,rveh)
	TriggerClientEvent("synctow",-1,nveh,rveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DENUNCIAR ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("denunciar",function(source)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
		local nplayer = vRPclient.getNearestPlayers(source,100)
		local denuncia = vRP.prompt(source,"Denuncia: Descreva o ocorrido detalhadamente...<br>Itens uteis: Vestimenta da pessoa, modelo de carro/moto, cor do veiculo, etc...","")
		local proximos = {}
		local distancia = {}
		local variavel = 1
		if denuncia >= '1' then
			for k,v in pairs(nplayer) do
				local nuser_id = vRP.getUserId(k)
				proximos[variavel] = nuser_id
				distancia[variavel] = v
				variavel = variavel + 1
			end
			if not proximos[1] then
				TriggerClientEvent('Notify',source,"aviso","Nao existem pessoas por perto.")
			else
				TriggerClientEvent('Notify',source,"sucesso","Denuncia recebida, aguarde ser atendido. Nao efetue spam!")
				sendLog('LogDenuncia',"[ID]: "..user_id.." fez uma denuncia: "..denuncia.." \n[IDs PROXIMOS]: "..table.concat(proximos,", ").." [DISTANCIA]:"..table.concat(distancia,", ")..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
			end
		else
			TriggerClientEvent('Notify',source,"negado","Voce nao escreveu nada, envie novamente.")
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CALL ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
local call = {}

RegisterCommand('call',function(source,args,rawCommand)
	local source = source
	local answered = false
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	vida = vRPclient.getHealth(source)

	local prison_time = vRP.getUData(parseInt(user_id),"vRP:prisao")
	local prison_parsed = json.decode(prison_time) or 0
	if user_id then
		if prison_parsed <= 0 then
			if vida > 101 or string.lower(args[1]) == "adm" then
				if not call[user_id] or GetGameTimer() >= call[user_id] then
					vRPclient._CarregarObjeto(source,"cellphone@","cellphone_call_to_text","prop_amb_phone",50,28422)
					local descricao = vRP.prompt(source,"Descrição:","")
					if descricao == "" then
						vRPclient._stopAnim(source,false)
						vRPclient._DeletarObjeto(source)
						return
					end
					local x,y,z = vRPclient.getPosition(source)
					local players = {}
					vRPclient._stopAnim(source,false)
					vRPclient._DeletarObjeto(source)
					local especialidade = false
					if args[1] == "911" then
						players = vRP.getUsersByPermission("policia.permissao")
						especialidade = "policiais"
					elseif args[1] == "112" then
						players = vRP.getUsersByPermission("paramedico.permissao")
						especialidade = "colaboradores do <b>Departamento Médico</b>"
					elseif args[1] == "mec" then
						players = vRP.getUsersByPermission("mecanico.permissao")
						especialidade = "mecânicos"
					elseif args[1] == "taxi" then
						players = vRP.getUsersByPermission("taxista.permissao")
						especialidade = "taxistas"
					elseif args[1] == "adv" then
						players = vRP.getUsersByPermission("advogado.permissao")
						especialidade = "advogados"
					elseif args[1] == "juiz" then
						players = vRP.getUsersByPermission("juiz.permissao")	
						especialidade = "juizes"
					--elseif args[1] == "css" then
					--	players = vRP.getUsersByPermission("conce.permissao")	
					--	especialidade = "vendedores"
					--elseif args[1] == "jornal" then
					--	players = vRP.getUsersByPermission("news.permissao")	
					--	especialidade = "jornalistas"
					--elseif args[1] == "bns" then
					--	players = vRP.getUsersByPermission("bennys.permissao")	
					--	especialidade = "ninguém da Bennys"
					elseif args[1] == "adm" then
						players = vRP.getUsersByPermission("mod.permissao")	
						especialidade = "Administradores"
					end
					local adm = ""
					if especialidade == "Administradores" then
						adm = "[ADM] "
					end
					
					vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
					if #players == 0  and especialidade ~= "policiais" then
						TriggerClientEvent("Notify",source,"importante","Não há "..especialidade.." em serviço.")
					else
							local identitys = vRP.getUserIdentity(user_id)
							call[user_id] = GetGameTimer() + 200000
							TriggerClientEvent("nyo_notify",source, "#008000", "sucesso", "Chamado enviado com sucesso", 5000)
							sendLog('LogChamadosFeitos',"[ID]: "..user_id.." "..identitys.name.." "..identitys.firstname.."\n[FEZ O CHAMADO PARA]: "..especialidade.."\n[COM A DESCRICAO]: "..descricao..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
							for l,w in pairs(players) do
								local player = vRP.getUserSource(parseInt(w))
								local nuser_id = vRP.getUserId(player)
								local identity = vRP.getUserIdentity(nuser_id)
								if player and player ~= uplayer then
									async(function()
										vRPclient.playSound(player,"Out_Of_Area","DLC_Lowrider_Relay_Race_Sounds")
										TriggerClientEvent('chatMessage',player,"CHAMADO",{19,197,43},adm.."Enviado por ^1"..identitys.name.." "..identitys.firstname.."^0 ["..user_id.."], "..descricao)
										local ok = vRP.request(player,"Aceitar o chamado de <b>"..identitys.name.." "..identitys.firstname.."</b>?",30)
										if ok then
											if not answered then
												answered = true
												local identity = vRP.getUserIdentity(nuser_id)
												TriggerClientEvent("Notify",source,"importante","Chamado atendido por <b>"..identity.name.." "..identity.firstname.."</b>, aguarde no local.")
	
												if especialidade == "Administradores" then
													sendLog('LogChamadosAtendeu',"[STAFF]: "..nuser_id.." "..identity.name.." "..identity.firstname.."\n[ATENDEU O CHAMADO DO]: "..user_id.." "..identitys.name.." "..identitys.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
												end
	
												vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
												vRPclient._setGPS(player,x,y)
											else
												TriggerClientEvent("nyo_notify",player, "#008000", "importante", "Chamado já atendido!", 5000)
												vRPclient.playSound(player,"CHECKPOINT_MISSED","HUD_MINI_GAME_SOUNDSET")
											end
										end
										local id = idgens:gen()
										blips[id] = vRPclient.addBlip(player,x,y,z,358,71,"Chamado",0.6,false)
										SetTimeout(300000,function() vRPclient.removeBlip(player,blips[id]) idgens:free(id) end)
									end)
								end
							end
					end
				else
					TriggerClientEvent("nyo_notify",source, "#008000", "importante", "Você precisa esperar <b>"..math.ceil((call[user_id] - GetGameTimer())/1000).." segundos</b> para fazer outro chamado.", 5000)
				end	
			else
				TriggerClientEvent("nyo_notify",source, "#008000", "importante", "Você precisa não pode fazer chamado estando <b>morto</b>", 5000)
			end
			
		else
			TriggerClientEvent("nyo_notify",source, "#008000", "importante", "Você não pode realizar chamados enquanto está preso!", 5000)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ REMOVER PROPRIO CAPUZ ]--------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rcapuz2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
	if vRP.hasPermission(user_id,"ac.permissao") then
		vRPclient.setCapuz(source)
		sendLog('LogCapuz2',"[ID]: "..user_id.." removeu o proprio capuz\n[XYZ]: "..x..", "..y..", "..z..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- [ OBJETOS ]
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('objetos',function(source,rawCommand)
    local user_id = vRP.getUserId(source)
	vRPclient._setCustomization(source,vRPclient.getCustomization(source))
    vRP.removeCloak(source)
	TriggerClientEvent('cancelando',false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MEC ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('jz',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"juiz.permissao") or vRP.hasPermission(user_id,"promotor.permissao") or vRP.hasPermission(user_id,"desembargador.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,"JUDICIÁRIO ",{0,175,175},rawCommand:sub(4))
				sendLog('LogChat',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MENSAGEM]: "..rawCommand:sub(4)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MEC ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mc',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"mecanico.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,"Central Mecânica",{255,128,0},rawCommand:sub(4))
				sendLog('Logchat',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MENSAGEM]: "..rawCommand:sub(4)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MR ]---------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mr',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local permission = "mecanico.permissao"
		if vRP.hasPermission(user_id,permission) then
			local mec = vRP.getUsersByPermission(permission)
			for l,w in pairs(mec) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,identity.name.." "..identity.firstname,{255,191,128},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /semems
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('semems',function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local paramedico = vRP.getUsersByPermission("paramedico.permissao")
    if vRPclient.getHealth(source) <= 101 then
       if parseInt(#paramedico) >= 1 then 
            TriggerClientEvent("Notify",source,"negado","Há paramédico em trabalho.")
        else

            if vRP.request(source, "Você deseja rezar pra ser renascido ? Esse serviço custará $10000", 60) then
                    if vRP.tryFullPayment(user_id,10000) then
                        TriggerClientEvent("progress",source, 20000,"Revivendo")
                       TriggerClientEvent("Notify",source,"importante","estamos orando por você! Aguarde!!!",8000)
                        Citizen.Wait(20000)
						vRP.clearInventory(user_id)
                        vRPclient.killGod(source)
                        vRPclient.setHealth(source,200)
                        TriggerClientEvent("Notify",source,"sucesso","Você foi reanimado e seu inventario foi limpo .",8000)
                        sendLog('LogSemems',"[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SEMEMS]: "..user_id.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),true)
                        else
                            TriggerClientEvent("Notify",source,"negado","Você não tem dinheiro suficiente",8000) 
                            return
                    end
                end
           end
        else
            TriggerClientEvent("Notify",source,"negado","Você não está morto",8000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /attachs
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('attachs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.getInventoryItemAmount(user_id,"modificacaodearma") == 1 or vRP.hasPermission(user_id,"master.permissao") or vRP.hasPermission(user_id,"policia.permissao") then
		TriggerClientEvent("setattachs",source,args[1])
		return true
	else
		TriggerClientEvent("Notify",source,"negado","Você não tem modificador de arma.") 
		return false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mascara
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mascara',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setmascara",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /blusa
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('blusa',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					if args[1] == '123' then
						if vRP.getInventoryItemAmount(user_id,"kitdemergulho") == 1 then
							TriggerClientEvent("setblusa",source,args[1],args[2])
						else
							TriggerClientEvent("Notify",source,"negado","Você não tem kit de mergulho.") 
						end
					else
						TriggerClientEvent("setblusa",source,args[1],args[2])
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /colete
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('colete',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setcolete",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /jaqueta
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('jaqueta',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setjaqueta",source,args[1],args[2])
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- /maos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('maos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setmaos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /calca
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('calca',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setcalca",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /acessorios
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('acessorios',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setacessorios",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------
-- /sapatos ------------------------------------
-----------------------------------------------
RegisterCommand('sapatos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setsapatos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------
-- /chapeu ------------------------------------
-----------------------------------------------
RegisterCommand('chapeu',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setchapeu",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------
-- /oculos ------------------------------------
-----------------------------------------------
RegisterCommand('oculos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setoculos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------
-- /mochila -----------------------------------
-----------------------------------------------
RegisterCommand('mochila',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRPclient.getHealth(source) > 101 then
        if not vRPclient.isHandcuffed(source) then
            if not vRP.searchReturn(source,user_id) then
                if user_id then
                    TriggerClientEvent("setmochila",source,args[1],args[2])
                end
            end
        end
    end
end)
-----------------------------------------------
-- /croupa ------------------------------------
-----------------------------------------------
RegisterCommand('croupa',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nearestplayer = vRPclient.getNearestPlayer(source,3)
    if vRP.hasPermission(user_id,"ceo.permissao") or vRP.hasPermission(user_id, "aztlan.permissao") then
        local custom = vRPclient.getCustomization(nearestplayer)
        if custom  then
            vRPclient._setCustomization(source,custom)
        end
    end
end)

RegisterCommand('roupas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if args[1] then
					local custom = roupas[tostring(args[1])]
					if custom then
						local old_custom = vRPclient.getCustomization(source)
						local idle_copy = {}

						idle_copy = vRP.save_idle_custom(source,old_custom)
						idle_copy.modelhash = nil

						for l,w in pairs(custom[old_custom.modelhash]) do
							idle_copy[l] = w
						end
						vRPclient._playAnim(source,true,{{"clothingshirt","try_shirt_positive_d"}},false)
						Citizen.Wait(2500)
						vRPclient._stopAnim(source,true)
						vRPclient._setCustomization(source,idle_copy)
					end
				else
					vRPclient._playAnim(source,true,{{"clothingshirt","try_shirt_positive_d"}},false)
					Citizen.Wait(2500)
					vRPclient._stopAnim(source,true)
					vRP.removeCloak(source)
				end
			end
		end
	end
end)

RegisterCommand('carrgb',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ceo.permissao") then
        TriggerClientEvent('rbgcar',source)
        TriggerClientEvent("Notify",source,"sucesso","Você tunou o <b>veículo</b> RGB com sucesso.")
    end
end)

RegisterServerEvent("chuveiro")
AddEventHandler("chuveiro",function()
    local source = source
    vRPclient._setCustomization(source,vRPclient.getCustomization(source))
    vRP.removeCloak(source)
end)

RegisterServerEvent('Tackle:Server:TacklePlayer')
AddEventHandler('Tackle:Server:TacklePlayer',function(Tackled,ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
	TriggerClientEvent("Tackle:Client:TacklePlayer",Tackled,ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
end)


local NotifyMortes = {}
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if user_id then
        if vRP.hasPermission(user_id,"ac.permissao") then
            NotifyMortes[user_id] = true
        end
    end
 end)

 Citizen.CreateThread( function()
	local admin = vRP.getUsersByPermission("ac.permissao")
	for l,w in pairs(admin) do
		NotifyMortes[w] = true
	end
	vRPclient = Tunnel.getInterface("vRP")
 end)

RegisterCommand("logkill",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, "ac.permissao") then
		if args[1] == "on" then
			TriggerClientEvent('Notify',source,'sucesso','Sistema de kill log ativado')
			NotifyMortes[user_id] = true
		end
		if args[1] == "off" then
			TriggerClientEvent('Notify',source,'aviso','Sistema de kill log desativado')
			NotifyMortes[user_id] = nil
		end
	end
end)


RegisterServerEvent('survavel:playerdeath')
AddEventHandler('survavel:playerdeath',function(nSource,weapon)
			local source = source
			local user_id = vRP.getUserId(source)
			if user_id and source ~= nSource then
				local isalive = vRPclient.isInComa(nSource)
			if isalive == true then 
			return
			end

			local nuser_id = vRP.getUserId(nSource)
			if nuser_id then
				
			local hash = weapon
			local kx,ky,kz = table.unpack(GetEntityCoords(GetPlayerPed(nSource)))
			local vx,vy,vz = table.unpack(GetEntityCoords(GetPlayerPed(source)))
			local weapons = {
				--[ MÃO ]--
				[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
				--[ ARMAS BRANCAS ]--
				[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
				[tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
				[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Broken Bottle',
				[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
				[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
				[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
				[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
				[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
				[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
				[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
				[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
				[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
				[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
				[tostring(GetHashKey('WEAPON_WRENCH'))] = 'Pipe Wrench',
				[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battle Axe',
				[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
				[tostring(GetHashKey('WEAPON_STONE_HATCHET'))] = 'Stone Hatchet',
				--[ PISTOLAS ]--
				[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
				[tostring(GetHashKey('WEAPON_PISTOL_MK2'))] = 'Pistol Mk II',
				[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
				[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
				[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stun Gun',
				[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50',
				[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
				[tostring(GetHashKey('WEAPON_SNSPISTOL_MK2'))] = 'SNS Pistol Mk II',
				[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
				[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
				[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare Gun',
				[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
				[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
				[tostring(GetHashKey('WEAPON_REVOLVER_MK2'))] = 'Heavy Revolver Mk II',
				[tostring(GetHashKey('WEAPON_DOUBLEACTION'))] = 'Double Action Revolver',
				[tostring(GetHashKey('WEAPON_RAYPISTOL'))] = 'Up-n-Atomizer',
				[tostring(GetHashKey('WEAPON_CERAMICPISTOL'))] = 'Ceramic Pistol',
				[tostring(GetHashKey('WEAPON_NAVYREVOLVER'))] = 'Navy Revolver',
				[tostring(GetHashKey('WEAPON_GADGETPISTOL'))] = 'Perico Pistol',
				--[ SUB METRALHADORAS ]--
				[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
				[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
				[tostring(GetHashKey('WEAPON_SMG_MK2'))] = 'SMG Mk II',
				[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
				[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
				[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
				[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
				[tostring(GetHashKey('WEAPON_RAYCARBINE'))] = 'Unholy Hellbringer',
				--[ SHOTGUNS ]--
				[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
				[tostring(GetHashKey('WEAPON_PUMPSHOTGUN_MK2'))] = 'Pump Shotgun Mk II',
				[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-Off Shotgun',
				[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
				[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
				[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
				[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
				[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
				[tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
				[tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
				[tostring(GetHashKey('WEAPON_COMBATSHOTGUN'))] = 'Combat Shotgun',
				--[ ASSAULT RIFLES ]--
				[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
				[tostring(GetHashKey('WEAPON_ASSAULTRIFLE_MK2'))] = 'Assault Rifle Mk II',
				[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
				[tostring(GetHashKey('WEAPON_CARBINERIFLE_MK2'))] = 'Carbine Rifle Mk II',
				[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
				[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
				[tostring(GetHashKey('WEAPON_SPECIALCARBINE_MK2'))] = 'Special Carbine Mk II',
				[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
				[tostring(GetHashKey('WEAPON_BULLPUPRIFLE_MK2'))] = 'Bullpup Rifle Mk II',
				[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',
				[tostring(GetHashKey('WEAPON_MILITARYRIFLE'))] = 'Military Rifle',
				--[ LIGHT MACHINE GUNS ]--
				[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
				[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
				[tostring(GetHashKey('WEAPON_COMBATMG_MK2'))] = 'Combat MG Mk II',
				[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
				--[ SPECIAL CARBINE ]--
				[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
				[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
				[tostring(GetHashKey('WEAPON_HEAVYSNIPER_MK2'))] = 'Heavy Sniper Mk II',
				[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
				[tostring(GetHashKey('WEAPON_MARKSMANRIFLE_MK2'))] = 'Marksman Rifle Mk II',
				--[ HEAVY WEAPONS ]--
				[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
				[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
				[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
				[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
				[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
				[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
				[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
				[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
				[tostring(GetHashKey('WEAPON_RAYMINIGUN'))] = 'Widowmaker',
				--[ THROWABLES ]--
				[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
				[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
				[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
				[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
				[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
				[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
				[tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipebomb',
				[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
				[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
				[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
				--[ MISCELLANEOUS ]--
				[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Combustível',
				[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Extintor',
				[tostring(GetHashKey('WEAPON_HAZARDCAN'))] = 'Hazardous Jerry Cantintor',
				--[ OUTRAS MORTES ]--
				[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
				[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
				[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
				[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
				[tostring(GetHashKey('OBJECT'))] = 'Object',
				[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
				[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
				[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
				[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
				[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
				[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
				[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
				[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
				[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
				[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
				[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
				[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
				[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
				[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
				[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
				[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
				[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
				[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
				[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
				[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
				[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
				[tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',
				[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
				[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
				[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
				[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar'
			}
			local weapon = weapons[tostring(hash)] or "Desconhecido"

			local date = os.date("[Data]: %d/%m/%y   [Hora]: %X")
			local killer_identity = vRP.getUserIdentity(user_id)
			local victim_identity = vRP.getUserIdentity(nuser_id)

			sendLog('LogMorte',"[ID]: "..nuser_id.." - '"..victim_identity.name.." "..victim_identity.firstname.."'\n[MATOU O ID]: "..user_id.." - '"..killer_identity.name.." "..killer_identity.firstname.."'\n[ARMA]: '"..weapon.."' [HASH]: "..hash.."\n[LOCAL ASSASSINO]: "..kx..","..ky..","..kz.."\n[LOCAL VITIMA]: "..vx..","..vy..","..vz.."\n"..date.."```",true)
			local admin = vRP.getUsersByPermission("ac.permissao")
			for l,w in pairs(admin) do
				if  NotifyMortes[w] then
					local player = vRP.getUserSource(parseInt(w))
					if player then
						async(function()
						
							TriggerClientEvent('chatMessage',player,"",{77,70,254},"[ID]: "..nuser_id.." [MATOU O ID]: "..user_id.." [ARMA]: "..weapon)
						end)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ VIP FOX ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vip",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    local resgate =  vRP.query("EG/getVipStarter", {user_id = user_id})
    local identity = vRP.getUserIdentity(user_id)
    local message = "Resgatou seu VIP EXPERIMENTAL! use ^1/vip ^0para resgatar o seu!"
    if resgate[1].vipteste == 0 then
        if vRP.hasPermission(user_id,'bronze.permissao') or vRP.hasPermission(user_id,'basic.permissao') or vRP.hasPermission(user_id,'gold.permissao') or vRP.hasPermission(user_id,'platinium.permissao') or vRP.hasPermission(user_id,'diamante.permissao') or vRP.hasPermission(user_id,'esmeralda.permissao') or vRP.hasPermission(user_id,'ultimate.permissao') or vRP.hasPermission(user_id,'kingbellavista.permissao') then
            TriggerClientEvent('Notify',source,'aviso','Você não pode resgatar um vip já tendo um VIP.')
            return
        end
        local string = 'vrp.removeGroup("'..user_id..'",VipOuro")'
        vRP.addUserGroup(user_id,"VipOuro")
        vRP.execute("EG/addVipStarter", {string = string})
        vRP.execute("EG/updateVipStarter", {user_id = user_id})
        TriggerClientEvent('Notify',source,'sucesso','VIP Teste de 3 Dias ATIVADO com sucesso, digite <b>/beneficios</b> para ver os beneficios.')
        TriggerClientEvent('chatMessage',-1,"",{255, 0, 0},"SISTEMA DE VIPS:  "..identity.name.." "..identity.firstname.. "  ^0"..message)
    else
        TriggerClientEvent('Notify',source,'aviso','Você já resgatou seu vip teste bonitão...')
    end
end)

RegisterCommand("beneficios",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        TriggerClientEvent('Notify',source,'sucesso','- Salario de $3000 a cada 30 minutos.<br>- Liberado /tv<br>- Prioridade na fila: 70%<br>- Troca de roupas sem o item roupas.<br>    - Desconto na concessionaria.<br>       - Trocar a cor da arma com o /weaponcolor<br>   - Acesso ao sistema de suspensão a ar.<br>   - Acesso ao /attachs<br>- Acesso ao comando /som para colocar música no carro.',20000)
    end
end)