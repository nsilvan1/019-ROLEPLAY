local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
maC = {}
Tunnel.bindInterface("farm_maconha",maC)
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUANTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function maC.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(10,12)
	end
end

function maC.Checkmaconha()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(10,12)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO
-----------------------------------------------------------------------------------------------------------------------------------------
function maC.checkPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"groove.permissao") then -- PERMISSÃO
		return true
	else
		TriggerClientEvent("Notify",source,"negado","Você não tem permissão para <b>produzir maconha</b>.")
		return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAGAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
function maC.checkPayment()
	maC.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("adubo")*quantidade[source] <= vRP.getInventoryMaxWeight(user_id) then -- ITEM QUE DERÁ PRECISAR
		vRP.giveInventoryItem(user_id,"maconha",quantidade[source]) -- ITEM QUE IRÁ RECEBER
		quantidade[source] = nil
		return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES EXTRAS
-----------------------------------------------------------------------------------------------------------------------------------------
function maC.freezy()
	local source = source
	FreezeEntityPosition(source, true)
	SetTimeout(2000,function()
		FreezeEntityPosition(source, false)
	end)
end