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
			local itens = math.random(100)
			local quantidade = math.random(5,6)
			local pagamento = math.random(2000,5000)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("pecadearma")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(5,6)
					vRP.giveInventoryItem( user_id,"pecadearma",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Peça de Arma.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end

		-- elseif vRP.hasPermission(user_id,"native.permissao") then
		-- 	local itens = math.random(100)
		-- 	local quantidade = math.random(5,6)
		-- 	local pagamento = math.random(2000,5000)
		-- 	if itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("polvora")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"polvora",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Polvora.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- elseif vRP.hasPermission(user_id,"contrabando.permissao") then
		-- 	local itens = math.random(100)
		-- 	local quantidade = math.random(1,6)
		-- 	local pagamento = math.random(2000,5000)
		-- 	if itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("algemas")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(0,3)
		-- 			vRP.giveInventoryItem( user_id,"algemas",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Algemas.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("capuz")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(0,3)
		-- 			vRP.giveInventoryItem( user_id,"capuz",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Capuz.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end


		-- elseif vRP.hasPermission(user_id,"lavagem.permissao") then
		-- 	local itens = math.random(100)
		-- 	local quantidade = math.random(1,6)
		-- 	if itens <= 29 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("detergenteneutro")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(0,6)
		-- 			vRP.giveInventoryItem( user_id,"detergenteneutro",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Detergente Neutro.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("agua")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"agua",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Agua.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("bicarbonatodesodio")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"bicarbonatodesodio",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Bicarbonato De Sodio.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end	

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("vinagre")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"vinagre",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Vinagre.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end		
			
			
		-- elseif vRP.hasPermission(user_id,"lifeinvader.permissao") then
		-- 	local itens = math.random(100)
		-- 	local quantidade = math.random(5,6)
		-- 	if itens <= 29 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("detergenteneutro")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"detergenteneutro",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Detergente Neutro.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("agua")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"agua",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Agua.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("bicarbonatodesodio")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"bicarbonatodesodio",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Bicarbonato De Sodio.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end	
			
		end
		return true			
	end
end