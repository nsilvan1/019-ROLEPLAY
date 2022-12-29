local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')
vCLIENT = Tunnel.getInterface('radio')
src = {}
Tunnel.bindInterface('radio', src)

function src.hasPermission(value)
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id, value)
end

function src.hasRadio()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.getInventoryItemAmount(user_id, 'radio') >= 1
end


