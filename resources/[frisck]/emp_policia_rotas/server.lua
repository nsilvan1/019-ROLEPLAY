local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_policia_rotas",emP)
local profit = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"policia.permissao")
end

function emP.endService()
	local source = source
	local user_id = vRP.getUserId(source)
	TriggerClientEvent("Notify",source,"importante","Patrulhamento encerrado. Bom descanso!")
	TriggerClientEvent("Notify",source,"sucesso","Bonificação total recebida: $"..profit[user_id].."")
	profit[user_id] = nil
end

function emP.startService()
	local source = source
	local user_id = vRP.getUserId(source)
	profit[user_id] = 0
end

function emP.checkPayment(distance)
	local money = math.random(30,50)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		profit[user_id] = profit[user_id] + money
		vRP.giveBankMoney(user_id, money)
		TriggerClientEvent("Notify",source,"sucesso","$"..money.." recebido (bônus de patrulha)")
	end
end