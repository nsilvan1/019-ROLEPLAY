local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
coC = {}
Tunnel.bindInterface("farm_cocaina",coC)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECAR DROGA
-----------------------------------------------------------------------------------------------------------------------------------------
function coC.checkcocaina()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.giveInventoryItem(user_id,"cocaina",12) -- ITEM QUE O PLAYER IRÁ RECEBER
        TriggerClientEvent("Notify",source,"sucesso","Você produziu <b>12 Cocainas</b>.")
    end
end

function coC.checkPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"bloods.permissao") then -- PERMISSÃO QUE O PLAYER NECESSITA
            return true
        else
            TriggerClientEvent("Notify",source,"negado","Você não tem permissão para <b>produzir cocaína</b>.")
            return false
        end
    end
end