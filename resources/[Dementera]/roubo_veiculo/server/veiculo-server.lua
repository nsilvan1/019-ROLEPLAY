local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local DinhieroSujo = false
local limitCloned = true
local days = 1 
veiculoSever = {}
Tunnel.bindInterface("roubo_veiculo_server",veiculoSever)

----------------- querys
vRP.prepare("queryConfiCarro",
             "SELECT edi.id FROM emp_user eu INNER JOIN emp_diario_ilegal edi on edi.emp_user_id = eu.id WHERE eu.user_id = @user_id")
vRP.prepare("queryvehicleCloned",
             "SELECT user_id FROM vehicle_cloned WHERE user_id = @user_id")			 
vRP.prepare("queryvehicleUser",
             "SELECT user_id FROM vehicle_cloned WHERE user_id = @user_id and vehicle = @vehicle")			 			 
vRP.prepare("queryEmpUser",
             "SELECT id FROM emp_user WHERE user_id = @user_id")			
----------------- Insert

vRP.prepare("insertCloned",
             "INSERT INTO vehicle_cloned(user_id, vehicle, dataInicio, dataFim) VALUES(@user_id, @vehicle, NOW(), ADDDATE(NOW(), INTERVAL @days DAY) )")
vRP._prepare("InsertEmpUser",
             "INSERT INTO emp_user (user_id,ativo, dataInicio) VALUES (@user_id, @ativo, DATE_FORMAT(NOW() ,'%Y-%m-%d'))")
vRP._prepare("InsertEmpDiarioIlegal",
             "INSERT INTO emp_diario_ilegal (nome, dataInicio, emp_user_id) VALUES ('Emprego Informal', NOW() , @emp_user_id)")
vRP.prepare("addUserVehicle",[[
	INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,detido,time,engine,body,fuel,ipva) 
	VALUES(@user_id,@vehicle,0,0,1000,1000,100,0);]])
----------------- update 

----------------- Delete
vRP.prepare("deleteEmpJob",
             "DELETE FROM emp_diario_ilegal WHERE id = @id")
------------------------

------------ items 


function veiculoSever.configEmpCarro( )
	local existeVaga = false
	local source = source
	local user_id = vRP.getUserId(source)
    local rows,affected = vRP.query("queryConfiCarro",{ user_id = user_id })
	if #rows > 0 then
		 existeVaga = true
	end
    return existeVaga
end	

function veiculoSever.endEmpJog ()
	local source = source
	local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("queryConfiCarro",{ user_id = user_id })
	if #rows > 0 then
		local emp_id = rows[1].id
		vRP.execute("deleteEmpJob",{ id = emp_id })
    end
	return 
end


function veiculoSever.insertCloned (vehicle)
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.execute("insertCloned",{ user_id = user_id, vehicle = vehicle, days = days })
	vRP.execute("addUserVehicle", {
		user_id = user_id, vehicle = vehicle})
	return 
end

function veiculoSever.validaCarrosClonados (vehicle)
	local source = source
	local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("queryvehicleUser",{ user_id = user_id, vehicle = vehicle })
	if #rows > 0 then
		TriggerClientEvent("Notify",source,"negado","Você não pode clonar este carro"..vehicle .." pois já possui na sua garagem ")
		return true
	end
	if limitCloned then 
		local rows,affected = vRP.query("queryvehicleCloned",{ user_id = user_id })
		if #rows > 0 then
			TriggerClientEvent("Notify",source,"negado","Você não pode clonar este carro"..vehicle .." pois já chegou ao seu limite de clonagem ")
			return true
		end
	end 

	return false
end


function veiculoSever.iniciaEmpregoInformal ()
	local source = source
	local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("queryEmpUser",{ user_id = user_id })
	if #rows > 0 then
		vRP.execute("InsertEmpDiarioIlegal",{ emp_user_id =  rows[1].id })
		TriggerClientEvent("Notify",source,"sucesso","Siga até o local indicado e procure o Zé ")
	else 
		vRP.execute("InsertEmpUser",{ user_id =  user_id, ativo = 'S'})
		rows,affected = vRP.query("queryEmpUser",{ user_id = user_id })
	    if #rows > 0 then
		 	vRP.execute("InsertEmpDiarioIlegal",{ emp_user_id =  rows[1].id })
			TriggerClientEvent("Notify",source,"sucesso","Siga até o local indicado e procure o Zé ")
		end
	end
	return 
end



function veiculoSever.checkKey(modelo)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("encomenda") <= vRP.getInventoryMaxWeight(user_id) then
			TriggerClientEvent("progress",source,5000,"Empacontando Encomenda")			
			vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
			SetTimeout(500,function()
				vRPclient._stopAnim(source,false)
				vRP.giveInventoryItem(user_id,"chavemestre",1)
				TriggerClientEvent("Notify",source,"sucesso","Você ganhou uma chave mestre, procure o carro "..modelo)
			end)
		end
	end
end

function veiculoSever.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id  then
        randmoney = math.random(500,1000) * 2
        if DinhieroSujo then 
            vRP.giveInventoryItem(user_id, "dinheirosujo", randmoney)
            TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..vRP.format(parseInt(randmoney)).." dinhieor sujo.")
        else 
            vRP.giveMoney(user_id,parseInt(randmoney))
            TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..vRP.format(parseInt(randmoney)).." dolar.")			
        end 
	end
end

function veiculoSever.checkError(erro)
	local source = source
    if erro == 'CARRO' then 
		TriggerClientEvent("Notify",source,"negado","Você não pode pegar este trabalho, não existe vagas")
	end 
end


function veiculoSever.iniciaEmprego()
	local source = source
		TriggerClientEvent("Notify",source,"sucesso","Você iniciou um emprego ilegal, isso pode te causar problemas, caso queira cancelar é só para pelo tablet")
end
