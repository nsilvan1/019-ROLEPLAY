--SCRIPT POR MAER COSTA

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

eletro = {}
Tunnel.bindInterface("instaladorInternet",eletro)
Proxy.addInterface("instaladorInternet",eletro)

local cfg = module("vrp","cfg/groups")
local groups = cfg.groups

valorMin = 20
valorMax = 40


-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------



function eletro.pagar()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local pagamento = math.random(valorMin,valorMax)
		vRP.giveMoney(user_id,pagamento)
		return pagamento
	end
end


