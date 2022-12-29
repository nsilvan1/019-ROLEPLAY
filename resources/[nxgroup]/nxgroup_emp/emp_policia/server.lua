local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP7 = Proxy.getInterface("vRP")
emP7 = {}
Tunnel.bindInterface("emp_policia",emP7)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP7.checkPermission()
	local source = source
	local user_id = vRP7.getUserId(source)
	return vRP7.hasPermission(user_id,"policia.permissao")
end

function emP7.checkPayment()
    local source = source
    local user_id = vRP7.getUserId(source)
    if user_id then
        randmoney = math.random(200,420)
        vRP7.giveMoney(user_id,parseInt(randmoney))
        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..parseInt(randmoney).." dólares</b>.")
    end
end