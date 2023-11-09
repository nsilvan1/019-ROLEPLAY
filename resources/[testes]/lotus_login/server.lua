local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

PL = {}
Tunnel.bindInterface("lotus_login", PL)
vCLIENT = Tunnel.getInterface("lotus_login")

RegisterCommand("login",function(source)
    TriggerClientEvent("vrp:ToogleLoginMenu",source)
    end)