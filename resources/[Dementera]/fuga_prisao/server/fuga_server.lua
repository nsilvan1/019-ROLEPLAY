local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local cFG = module("fuga_prisao", "config")

cnFP = {}
Tunnel.bindInterface("fuga_presao",cnFP)

vRP.prepare("updateForagido",
             "UPDATE vrp_user_identities SET foragido = 1 where user_id = @user_id ")	 


function cnFP.itemEncontrado()
    local source = source
    local user_id = vRP.getUserId(source)
    if 1 == math.random(1, 2) then
        vRP.giveInventoryItem(user_id,cFG.dropItem,1)
        TriggerClientEvent("Notify",source,"sucesso","Você encontrou um(a) "..cFG.dropItem)
    else 
        local item = math.random(1, cFG.qtdItem)
        vRP.giveInventoryItem(user_id,cFG.itemAux[item].item,1) 
        TriggerClientEvent("Notify",source,"sucesso","Você encontrou um ".. cFG.itemAux[item].nome)
    end 
end 

function cnFP.nadaEncontrado()
    TriggerClientEvent("Notify",source,"negado","Nada foi encontrado")
end 

function cnFP.presoTravado()
    TriggerClientEvent("Notify",source,"negado","A chave quebrou")
end 

function cnFP.fuga()
    local source = source
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(parseInt(user_id))
    if user_id then
        vRP.setUData(parseInt(user_id), "vRP:prisao",
                     json.encode(parseInt(0))) 
        if  cFG.foragido then 
          vRP.execute('updateForagido', {user_id = user_id})
        end                   
        vRPclient.teleport(player, cFG.fugaTeleport[1].x , cFG.fugaTeleport[1].y, cFG.fugaTeleport[1].z)
    end
end

function cnFP.validaItem()
    local existeItem = false
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.tryGetInventoryItem(user_id,'chave',1,false) then 
        existeItem = true
    else 
        TriggerClientEvent("Notify",source,"negado","Você não possui uma chave")
    end 
    return existeItem
end 