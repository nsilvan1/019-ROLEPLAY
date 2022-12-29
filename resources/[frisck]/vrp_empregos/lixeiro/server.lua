local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
Lix = {}
Tunnel.bindInterface("lixeiro",Lix)

function Lix.checkPayment(bonus)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
        randmoney = (math.random(50,150))
	    vRP.giveMoney(user_id,parseInt(randmoney))
		TriggerClientEvent("vrp_sound:source",source,'coins',0.3)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..vRP.format(parseInt(randmoney)).." dolar.")
		if math.random(0, 1) > 0 then 
			vRP.giveInventoryItem(user_id,"etiqueta",math.random(1, 2))
	    end;
		if math.random(0, 100) > 90 then 
			vRP.giveInventoryItem(user_id,"chip",math.random(1, 2))
	    end;
		if math.random(0, 100) > 95 then 
			vRP.giveInventoryItem(user_id,"notequebrado",1)
	    end;
	end
end

