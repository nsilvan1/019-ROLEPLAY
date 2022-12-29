local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
carta = {}
Tunnel.bindInterface("carteiro",carta)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function carta.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(4,8)
	end
end

function carta.checkPayment1()
	carta.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"encomenda",quantidade[source]) then
			vRP.giveMoney(user_id,math.random(100,150)*quantidade[source])
			TriggerClientEvent("Notify",source,"sucesso","Você entregou uma encomenda")
			quantidade[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..quantidade[source].."x Encomendas</b>.")
		end
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function carta.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"encomenda") >= 10 then
		    TriggerClientEvent("Notify",source,"aviso","Voce atingiu o numero máximo de encomendas.")
		else
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("encomenda")*5 <= vRP.getInventoryMaxWeight(user_id) then
				TriggerClientEvent("progress",source,5000,"Empacontando Encomenda")
				
				vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
				SetTimeout(10000,function()
					vRPclient._stopAnim(source,false)
					vRP.giveInventoryItem(user_id,"encomenda",5)
					TriggerClientEvent("Notify",source,"sucesso","Você empacotou 5x encomendas.")
				end)
			end
		end 
	end
end

