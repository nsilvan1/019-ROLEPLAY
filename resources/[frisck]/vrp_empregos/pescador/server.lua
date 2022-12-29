local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
pesca = {}
Tunnel.bindInterface("pescador",pesca)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local peixes = {
	[1] = { x = "dourado" },
	[2] = { x = "corvina" },
	[3] = { x = "salmao" },
	[4] = { x = "pacu" },
	[5] = { x = "pintado" },
	[6] = { x = "pirarucu" },
	[7] = { x = "tilapia" },
	[8] = { x = "tucunare" }
}

function pesca.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("dourado") <= vRP.getInventoryMaxWeight(user_id) then
			if math.random(100) >= 98 then
				vRP.giveInventoryItem(user_id,"lambari",1)
			else
				vRP.giveInventoryItem(user_id,peixes[math.random(8)].x,1)
			end
			return true
		end
	end
end

function pesca.validateIsca()
	local validate = false
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.tryGetInventoryItem(user_id,"isca",1) then
		validate = true
	else 
		TriggerClientEvent("Notify",source,"negado","Você precisa de <b>Isca</b>.") 
	end 
	
	return validate
end
