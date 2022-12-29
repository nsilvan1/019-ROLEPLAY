local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent("vrp_legacyfuel:pagamentoadjia232")
AddEventHandler("vrp_legacyfuel:pagamentoadjia232",function(price,galao)
	local user_id = vRP.getUserId(source)
	if user_id and price > 0 then
		if vRP.tryPayment(user_id,price) then
			if galao then
				TriggerClientEvent('vrp_legacyfuel:galaoadjia232',source)
				TriggerClientEvent("Notify",source,"sucesso","Pagou <b>$"..vRP.format(price).." dolar</b> pelo <b>Galão</b>.")
			else
				TriggerClientEvent("Notify",source,"sucesso","Pagou <b>$"..vRP.format(price).." dolar</b> em combustível.")
			end
		else
			TriggerClientEvent('vrp_legacyfuel:insuficienteadjia232',source)
			TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
		end
	end
end)