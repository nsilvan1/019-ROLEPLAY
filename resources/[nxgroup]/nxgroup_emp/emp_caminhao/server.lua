local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP2 = Proxy.getInterface("vRP")
emP2 = {}
Tunnel.bindInterface("emp_caminhao",emP2)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local paylist = {
	["diesel"] = {
		[1] = { pay = math.random(8000,15000) },
		[2] = { pay = math.random(8000,15000) },
		[3] = { pay = math.random(8000,15000) },
		[4] = { pay = math.random(8000,15000) },
		[5] = { pay = math.random(8000,15000) },
		[6] = { pay = math.random(8000,15000) }
	},
	["cars"] = {
		[1] = { pay = math.random(8000,15000) },
		[2] = { pay = math.random(8000,15000) },
		[3] = { pay = math.random(8000,15000) },
		[4] = { pay = math.random(8000,15000) },
		[5] = { pay = math.random(8000,15000) },
		[6] = { pay = math.random(8000,15000) }
	},
	["woods"] = {
		[1] = { pay = math.random(15000,20000) },
		[2] = { pay = math.random(15000,20000) },
		[3] = { pay = math.random(8000,15000) },
		[4] = { pay = math.random(8000,15000) }
	},
	["show"] = {
		[1] = { pay = math.random(8000,15000) },
		[2] = { pay = math.random(8000,15000) },
		[3] = { pay = math.random(8000,15000) },
		[4] = { pay = math.random(8000,15000) }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function emP2.checkPayment(id,mod,health)
	local source = source
	local user_id = vRP2.getUserId(source)
	if user_id then
		vRP2.giveMoney(user_id,parseInt(paylist[mod][id].pay+(health-700)))
		TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP2.format(parseInt(paylist[mod][id].pay+(health-700))).." dólares</b>.")
	end
end
