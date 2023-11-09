local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local sanitizes = module("cfg/sanitizes") -- Varia de bases
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
