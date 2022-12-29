local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
lenha = {}
Tunnel.bindInterface("lenhador",lenha)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES COLETA
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function lenha.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(3)
	end
end

function lenha.checkPayment()
	lenha.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("tora")*quantidade[source] <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,"tora",quantidade[source])
			quantidade[source] = nil
			return true
		end
	end
end




-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function lenha.Quantidade1()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(6,10)
	end
end

function lenha.checkPayment1()
	lenha.Quantidade1()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"tora",quantidade[source]) then
			vRP.giveMoney(user_id,math.random(90,130)*quantidade[source])
			quantidade[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..quantidade[source].."x Toras de Madeira</b>.")
		end
	end
end