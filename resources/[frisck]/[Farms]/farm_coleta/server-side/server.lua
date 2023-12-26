-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
emP = {}
Tunnel.bindInterface("farm_coleta",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSAO 
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"motoclub.permissao") or
		   vRP.hasPermission(user_id,"municao.permissao") 	or
		   vRP.hasPermission(user_id,"hells.permissao")  or
		   vRP.hasPermission(user_id,"armas.permissao") or 
		   vRP.hasPermission(user_id,"cartel.permissao") or 
		   vRP.hasPermission(user_id,"lsd.permissao") then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não tem acesso.")
			return false
		end						
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PAGAMENTO 
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"lsd.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(2,3)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("lsd")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(2,3)
					vRP.giveInventoryItem( user_id,"lsd",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x LSD.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	
		elseif vRP.hasPermission(user_id,"hells.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(2,3)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("lockpick")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(0,5)
					vRP.giveInventoryItem( user_id,"lockpick",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x lockpick.</b>")
					quantidade = math.random(0,5)
					vRP.giveInventoryItem( user_id,"placa",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x placa.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	
	
		elseif vRP.hasPermission(user_id,"motoclub.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(2,3)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("lockpick")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(0,5)
					vRP.giveInventoryItem( user_id,"lockpick",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x lockpick.</b>")
					quantidade = math.random(0,5)
					vRP.giveInventoryItem( user_id,"placa",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x placa.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"municao.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(2,3)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("capsulas")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(5,10)
					vRP.giveInventoryItem( user_id,"capsulas",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x capsula de Arma.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	
		

		elseif vRP.hasPermission(user_id,"bratva.permissao") then
			local itens = math.random(0,100)
			local quantidade = math.random(5,6)
			local pagamento = math.random(2000,5000)
			print(itens)
			if itens <= 10  then
				quantidade = math.random(1,2)
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("placa-metal")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					vRP.giveInventoryItem( user_id,"placa-metal",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Placa de metal.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			
			elseif itens >= 11 and itens <= 30  then
				quantidade = math.random(2,4)
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("molas")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					vRP.giveInventoryItem( user_id,"molas",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Molas.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			
			elseif itens >= 31 and itens <= 50  then
					quantidade = math.random(1,2)
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("gatilho")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
						vRP.giveInventoryItem( user_id,"gatilho",quantidade)
						TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Gatilho.</b>")
					else
						TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
					end
			
			else 
					quantidade = math.random(5,6)
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("pecadearma")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
						vRP.giveInventoryItem( user_id,"pecadearma",quantidade)
						TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Peça de Arma.</b>")
					else
						TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
					end
			end

		
		end
		return true			
	end
end