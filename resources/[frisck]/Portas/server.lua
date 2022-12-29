local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local cfg = module("Portas","config")

src = {}
Tunnel.bindInterface("Portas",src)

src.ListaDoors = function()
	return cfg.list
end


RegisterServerEvent('vrpdoorsystem:open')
AddEventHandler('vrpdoorsystem:open',function(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,cfg.list[id].perm) or vRP.hasPermission(user_id,"administrador.permissao") then
		cfg.list[id].lock = not cfg.list[id].lock
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,cfg.list[id].lock)
		if cfg.list[id].other ~= nil then
			local idsecond = cfg.list[id].other
			cfg.list[idsecond].lock = cfg.list[id].lock
			TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,cfg.list[id].lock)
		end
	end
end)