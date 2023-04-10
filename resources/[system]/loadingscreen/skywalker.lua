local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("loadingscreen",src)
vCLIENT = Tunnel.getInterface("loadingscreen")

function src.useScript()	
	return true
end