local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = {}
Tunnel.bindInterface("ozk_caminhoneiro",emP)
local Tools = module("vrp","lib/Tools")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRPReceiver.checkPayment(mod,health)
	local source = source
	local user_id = vRP.getUserId(source)
	print(user_id .. 'entrou ')
    if user_id then
        local pagamento = math.random(cfg.cargas[mod]['valor'][1],cfg.cargas[mod]['valor'][2])
		vRP.giveMoney(user_id,parseInt(pagamento))
	end
end



