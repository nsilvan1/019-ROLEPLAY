local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
Min = {}
Tunnel.bindInterface("minerador", Min)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
local porcentagem = 0
local itemname = ""
function Min.Quantidade()
    local source = source
    if quantidade[source] == nil then quantidade[source] = math.random(1, 3) end
end

function Min.checkWeight()
    Min.Quantidade()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        porcentagem = math.random(100)
        if porcentagem <= 30 then
            itemname = "ferro"
        elseif porcentagem >= 31 and porcentagem <= 50 then
            itemname = "safira"    
        elseif porcentagem >= 51 and porcentagem <= 60 then
            itemname = "bronze"
        elseif porcentagem >= 71 and porcentagem <= 80 then
            itemname = "mouro"
        elseif porcentagem >= 81 and porcentagem <= 90 then
            itemname = "rubi"
        elseif porcentagem >= 91 and porcentagem <= 94 then
            itemname = "topazio"
        elseif porcentagem >= 95 then
            itemname = "diamante"
        end
        quantidade[source] = 1
        if itemname == nil then itemname = "bronze"; end
        if source == nil then
            source = 1
        elseif source == 0 then
            source = 1
        end
        if quantidade[source] == nil then
            quantidade[source] = 1
            return vRP.getItemWeight(itemname) * quantidade[source] <=
                       vRP.getInventoryMaxWeight(user_id)
        else
            if vRP.getInventoryWeight(user_id) >= vRP.getInventoryMaxWeight(user_id) then
				TriggerClientEvent("Notify",source,"negado","Sua mochila está cheia!") 
                return false
            end
            return vRP.getItemWeight(itemname) * quantidade[source] <=
                       vRP.getInventoryMaxWeight(user_id)
        end
    end
end

function Min.checkPayment()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.giveInventoryItem(user_id, itemname, quantidade[source])
        quantidade[source] = nil
    end
end
