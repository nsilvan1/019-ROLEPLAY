local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPReceiver = {}
Tunnel.bindInterface("Q_bank",vRPReceiver)
vRPSend = Tunnel.getInterface("Q_bank")