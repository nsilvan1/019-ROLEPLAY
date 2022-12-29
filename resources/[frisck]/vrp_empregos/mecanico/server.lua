local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
hel = {}
Tunnel.bindInterface("mecanico",hel)
----------------------------------------------
-- PAGAMENTO
----------------------------------------------
function hel.checkPayment()
    local source = source
    local user_id = vRP.getUserId(source)
    local valor = math.random(500,1000) 
    local valorCaixa = math.random(0,1)


    if user_id then
            vRP.giveMoney(user_id,valor)
            TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
            TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..valor.." pelo reparo do veículo!")
            if valorCaixa > 0 then
                vRP.giveInventoryItem(user_id,"repairkit",valorCaixa)
                TriggerClientEvent("Notify",source,"sucesso","Você recebeu "..valorCaixa.." caixa de reparo !")
            end 
        else
            TriggerClientEvent("Notify",source,"negado","Você não recebeu pelo serviço!")
        end
end                        