-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
emP = {}
Tunnel.bindInterface("farm_ilegal",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(farm)
    local source = source
    local user_id = vRP.getUserId(source)
    local item = cfg.FarmItems[farm]["item"].item
    local item2 = cfg.FarmItems[farm]["item"].item2
    local times = cfg.FarmItems[farm]["item"].times

    local random = math.random(parseInt(cfg.FarmItems[farm]["item"].a1),parseInt(cfg.FarmItems[farm]["item"].a2))
	if times > 1 then
		local random2 = math.random(parseInt(cfg.FarmItems[farm]["item"].a3),parseInt(cfg.FarmItems[farm]["item"].a4))
        if vRP.getInventoryWeight(user_id) + (vRP.getItemWeight(item) * random) + (vRP.getItemWeight(item2) * random2) <= vRP.getInventoryMaxWeight(user_id) then
            if vRP.hasPermission(user_id,"contrabando.permissao") then
                if vRP.tryPayment(user_id,5000) then
                    vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                    TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                    return true
                else
                    TriggerClientEvent("Notify",source,"Negado","Você Não tem 5000 para comprar esse item.")
                    return true
                end
            else 
                vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                vRP.giveInventoryItem(user_id,item2,parseInt(random2),true)
                TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                return true
            end
        else
            TriggerClientEvent("Notify",source,"Negado","Você Não tem espaço suficiente na mochila.") 
        end
    else
        if vRP.getInventoryWeight(user_id) + (vRP.getItemWeight(item) * random) <= vRP.getInventoryMaxWeight(user_id) then 
            if vRP.hasPermission(user_id,"contrabando.permissao") then
                if item == "algema" then
                    if vRP.tryPayment(user_id,10000) then
                        vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                        TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                        return true
                    else
                        TriggerClientEvent("Notify",source,"Negado","Você Não tem 10000 para comprar esse item.")
                        return true
                    end
                elseif item == "c4" then
                    if vRP.tryPayment(user_id,5000) then
                        vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                        TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                        return true
                    else
                        TriggerClientEvent("Notify",source,"Negado","Você Não tem 5000 para comprar esse item.")
                        return true
                    end
                elseif item == "lockpick" then
                    if vRP.tryPayment(user_id,8000) then
                        vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                        TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                        return true
                    else
                        TriggerClientEvent("Notify",source,"Negado","Você Não tem 8000 para comprar esse item.")
                        return true
                    end
                elseif item == "masterpick" then
                    if vRP.tryPayment(user_id,12000) then
                        vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                        TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                        return true
                    else
                        TriggerClientEvent("Notify",source,"Negado","Você Não tem 12000 para comprar esse item.")
                        return true
                    end
                elseif item == "capuz" then
                    if vRP.tryPayment(user_id,10000) then
                        vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                        TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                        return true
                    else
                        TriggerClientEvent("Notify",source,"Negado","Você Não tem 10000 para comprar esse item.")
                        return true
                    end
                elseif item == "colete" then
                    if vRP.tryPayment(user_id,35000) then
                        vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                        TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                        return true
                    else
                        TriggerClientEvent("Notify",source,"Negado","Você Não tem 35000 para comprar esse item.")
                        return true
                    end
                elseif item == "pendrive" then
                    if vRP.tryPayment(user_id,5000) then
                        vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                        TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                        return true
                    else
                        TriggerClientEvent("Notify",source,"Negado","Você Não tem 5000 para comprar esse item.")
                        return true
                    end
                elseif item == "ticket" then
                    if vRP.tryPayment(user_id,5000) then
                        vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                        TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                        return true
                    else
                        TriggerClientEvent("Notify",source,"Negado","Você Não tem 5000 para comprar esse item.")
                        return true
                    end
                else
                    return true
                end
            else 
                vRP.giveInventoryItem(user_id,item,parseInt(random),true)
                TriggerClientEvent("Notify",source,"sucesso","Você recebeu os itens, vá para o próximo ponto.")
                return true
            end
        else
            TriggerClientEvent("Notify",source,"Negado","Você Não tem espaço suficiente na mochila.") 
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkIntPermissions(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			return vRP.hasPermission(user_id,perm)
		end
	end
end