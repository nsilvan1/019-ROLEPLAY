local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
Ifoo = {}
Tunnel.bindInterface("ifood",Ifoo)
----------------------------------------------------------------------
-- [ PAGAMENTO ]
----------------------------------------------------------------------
function Ifoo.checkPayment(bonus)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
        randmoney = (math.random(3500,3700))
	    vRP.giveMoney(user_id,parseInt(randmoney))
        TriggerClientEvent("vrp_sound:source",source,'coins',0.3)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..vRP.format(parseInt(randmoney)).." dolar.")
	end
end
