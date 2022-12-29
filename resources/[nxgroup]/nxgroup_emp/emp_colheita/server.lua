local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP3 = Proxy.getInterface("vRP")
emP3 = {}
Tunnel.bindInterface("emp_colheita",emP3)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS COLHEITA
-----------------------------------------------------------------------------------------------------------------------------------------
function emP3.checkPayment()
    local source = source
    local user_id = vRP3.getUserId(source)
    if user_id then
        randgraos = math.random(1,3)
        if vRP3.getInventoryWeight(user_id)+vRP3.getItemWeight("graosimpuros") <= vRP3.getInventoryMaxWeight(user_id) then
            vRP3.giveInventoryItem(user_id,"graosimpuros",parseInt(randgraos))
            TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>"..randgraos.."</b> Grãos.")
        else
            TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.")
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS SEPARAR GRAOS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP3.checkGraos()
	local source = source
	local user_id = vRP3.getUserId(source)
	if user_id then
		if vRP3.getInventoryItemAmount(user_id,"graosimpuros") >= 5 then
			return true 
		else
			TriggerClientEvent("Notify",source,"negado","<b>Grãos</b> insuficientes.") 
			return false
		end
	end
end

function emP3.separarGraos()
    local source = source
    local user_id = vRP3.getUserId(source)
    if user_id then
        if vRP3.tryGetInventoryItem(user_id,"graosimpuros",5) then
            rgraos = math.random(2,4)
            vRP3.giveInventoryItem(user_id,"graos",parseInt(rgraos))
            TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>"..rgraos.."</b> Grãos.")
        end
    end
end