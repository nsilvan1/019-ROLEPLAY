-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("commands",cRP)
vCLIENT = Tunnel.getInterface("commands")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGS
-----------------------------------------------------------------------------------------------------------------------------------------
configS = {
    enableRats = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHTRASH
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.searchTrash()
    local source = source
    local user_id = vRP.getUserId(source)
    local moneyfound = math.random(1000,2000)
    local chances = math.random(100)
    if chances >= 6 and chances <= 18 then
        vRP.giveInventoryItem(user_id,"borracha",1)
        TriggerClientEvent("Notify",source,"sucesso","Você encontrou <b>Borracha x1</b> dentro da lixeira.")

    elseif chances >= 18 and chances <= 30 then
        vRP.giveInventoryItem(user_id,"molas",1)
        TriggerClientEvent("Notify",source,"sucesso","Você encontrou <b>Molas x1</b> dentro da lixeira.")
        
    elseif chances >= 30 and chances <= 42 then
        vRP.giveInventoryItem(user_id,"lockpick",1)
        TriggerClientEvent("Notify",source,"sucesso","Você encontrou <b>lockpick x1</b> dentro da lixeira.")

    elseif chances >= 42 and chances <= 54 then
        vRP.giveInventoryItem(user_id,"papel",1)
        TriggerClientEvent("Notify",source,"sucesso","Você encontrou <b>Papel x1</b> dentro da lixeira.")

    elseif chances >= 54 and chances <= 66 then
        vRP.giveInventoryItem(user_id,"aluminio",1)
        TriggerClientEvent("Notify",source,"sucesso","Você encontrou <b>Aluminio x1</b> dentro da lixeira.")

    elseif chances >= 66 and chances <= 88 then
        vRP.giveInventoryItem(user_id,"cobre",1)
        TriggerClientEvent("Notify",source,"sucesso","Você encontrou <b>Cobre x1</b> dentro da lixeira.")

    elseif chances >= 88 and chances <= 99 then
        vRP.giveInventoryItem(user_id,"pendrive",1)
        TriggerClientEvent("Notify",source,"sucesso","Você encontrou <b>pendrive x1</b> dentro da lixeira.")

    elseif chances >= 0 and chances <= 6 then
        if configS.enableRats == true then
            TriggerClientEvent("Notify",source,"negado","Você encontrou um rato, e ele te mordeu.")
            vRPclient.varyHealth(source,-2)
        else
            TriggerClientEvent("Notify",source,"aviso","Você encontrou um rato, mas ele fugiu")
        end
    else
        TriggerClientEvent("Notify",source,"aviso","Você não encontrou nada, continue procurando...")
    end
end