local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
jp = {}
Tunnel.bindInterface(GetCurrentResourceName(),jp)


function jp.getStats()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.getThirst(user_id),vRP.getHunger(user_id)
end
RegisterCommand("cr",function(source,args)
	player_id = vRP.getUserId(source)

        if args[1] then
            vRP.varyHunger(player_id,100)
            vRP.varyThirst(player_id,100)
        else
            vRP.varyHunger(player_id,100)
            vRP.varyThirst(player_id,100)
        end

end)