local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
func = {}
Tunnel.bindInterface("vrp_trafico",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,perm)
end

local src = {
-----------------------------------------------------------------------------------------------------------------------------------------
-- [ FARM HOSPITAL ]
-----------------------------------------------------------------------------------------------------------------------------------------
	[1] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "paracetamil", ['itemqtd'] = 1 },
	[2] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "voltarom", ['itemqtd'] = 1 },
	[3] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "dorflex", ['itemqtd'] = 1 },
	[4] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "paracetamil", ['itemqtd'] = 1 },
	[5] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "voltarom", ['itemqtd'] = 1 },
	[6] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "dorflex", ['itemqtd'] = 1 },
-----------------------------------------------------------------------------------------------------------------------------------------
-- [ FARM BENNYS ]
-----------------------------------------------------------------------------------------------------------------------------------------
	[7] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "repairkit", ['itemqtd'] = 1 },
	[8] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "repairkit", ['itemqtd'] = 1 },
	[9] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "repairkit", ['itemqtd'] = 1 },
}

function func.checkPayment(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if src[id].re ~= nil then
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(src[id].item)*src[id].itemqtd <= vRP.getInventoryMaxWeight(user_id) then
				if vRP.tryGetInventoryItem(user_id,src[id].re,src[id].reqtd,false) then
					vRP.giveInventoryItem(user_id,src[id].item,src[id].itemqtd,false)
					vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_ped"}},true)
					return true
				else
					TriggerClientEvent("Notify",source,"aviso","Você não possui os itens necessários para o processo")
				end
			end
		else
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(src[id].item)*src[id].itemqtd <= vRP.getInventoryMaxWeight(user_id) then
				vRP.giveInventoryItem(user_id,src[id].item,src[id].itemqtd,false)
				vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_ped"}},true)
				return true
			end
		end
	end
end