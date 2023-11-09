local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')
vCLIENT = Tunnel.getInterface('pma-radio')
src = {}
Tunnel.bindInterface('pma-radio', src)

function src.hasPermission(value)
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id, value)
end

function src.hasRadio()
    local source = source
    local user_id = vRP.getUserId(source)
    radios = vRP.getInventoryItemAmount(user_id,"radio")
    return radios > 0
end