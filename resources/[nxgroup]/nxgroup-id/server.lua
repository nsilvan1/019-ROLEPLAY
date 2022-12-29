local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
fclient = Tunnel.getInterface("nxgroup-id")
func = {}
Tunnel.bindInterface("nxgroup-id",func)


func.checkid = function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.isWhitelisted(user_id)
	end
	return false
end

RegisterNetEvent("checkWhitelisted")
AddEventHandler("checkWhitelisted", function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.isWhitelisted(user_id) then
			print(1)
			fclient.idclient(source,user_id)
		end
	end 
end)

RegisterCommand("testewl",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.isWhitelisted(user_id) then
			print(2)
			fclient.idclient(source,user_id)
		end
	end
end)
