-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

nyoBSClient = Tunnel.getInterface("nyo_barbershop")
nyoBSServer = {}
Tunnel.bindInterface("nyo_barbershop",nyoBSServer)

-----------------------------------------------------------------
-- | Functions [1]
-----------------------------------------------------------------
function nyoBSServer.checkout(preco, custom)
	local source = source 
	local user_id = vRP.getUserId(source)
	if preco then 
		if vRP.tryPayment(user_id,parseInt(preco)) then
			vRP.setUData(user_id,"currentCharacterMode", custom)
			TriggerClientEvent("Notify",source,"sucesso","Você pagou <b>$"..preco.." dolar</b>.",10000)
		else 
			nyoBSClient.resetBuy(source)	
			TriggerClientEvent("Notify",source,"negado","Você não possui dinheiro.",10000)			
		end		
	else 
		TriggerClientEvent("Notify",source,"negado","Ocorreu um Erro! Tente novamente.",10000)		
		nyoBSClient.resetBuy(source)
	end
end


function nyoBSServer.checkProcurado() 
    local user_id = vRP.getUserId(source)
	return vRP.searchReturn(source,user_id)
end




AddEventHandler("nyo_barbershop:init", function(user_id) -- sincronizar a criação de personagem
	local player = vRP.getUserSource(user_id)
	if player then
		local value = vRP.getUData(user_id,"currentCharacterMode")
		if value ~= nil then
            local custom = json.decode(value) or {}
			nyoBSClient.setCharacter(player,custom)
		end
	end
end)
