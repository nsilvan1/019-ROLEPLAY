local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

Klaus = {}
-- Tunnel.bindinterface("FD_login", Klaus)
vCLIENT = Tunnel.getInterface("FD_login")

function Klaus.login()
	local src = src
	local player = vRP.getUserId(src)
	local identity = vRP.getUserIdentity(player)
	return vRP.getMoney(player), vRP.getBankMoney(player), identity.name .. "" .. identity.firstname
end

RegisterCommand("login",function(source)
    TriggerClientEvent("vrp:ToogleLoginMenu",source)
    end)