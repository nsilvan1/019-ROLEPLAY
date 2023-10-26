-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("products",cnVRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local amount = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST --------- ALTERAR PREÇO
-----------------------------------------------------------------------------------------------------------------------------------------
local itemList = {
	{ item = "cocaina", priceMin = 1000, priceMax = 2000, randMin = 3, randMax = 6 }, 
	{ item = "maconha", priceMin = 1000, priceMax = 2000, randMin = 3, randMax = 6 },
	{ item = "metanfetamina", priceMin = 1000, priceMax = 2000, randMin = 3, randMax = 6 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.checkAmount()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(itemList) do
			local rand = math.random(v.randMin,v.randMax)
			local price = math.random(v.priceMin,v.priceMax)
			if vRP.getInventoryItemAmount(user_id,v.item) >= parseInt(rand) then
				amount[user_id] = { v.item,rand,price }

				TriggerClientEvent("products:lastItem",source,v.item)

				if (v.item == "maconha" or v.item == "cocaina" or v.item == "metanfetamina" or v.item == "maconha" or v.item == "cocaina") 
				     and math.random(100) >= 75 then
					local x,y,z = vRPclient.getPosition(source)
					-- local copAmount = vRP.numPermission("policia.permissao")
					-- for k,v in pairs(copAmount) do
					-- 	async(function()
					-- 		TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), code = 5, title = "Denúncia de Venda de Drogas", x = x, y = y, z = z, rgba = {163, 0, 0} })
					-- 	end)
					-- end
				end

				return true
			-- else
			-- 	TriggerClientEvent("Notify",source,"negado","Voce nao possui nada que me interesse",5000)
			end
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,amount[user_id][1],amount[user_id][2],true) then
			--vRP.upgradeStress(user_id,2)
			local value = amount[user_id][3] * amount[user_id][2]
			vRP.giveInventoryItem(user_id,"dinheirosujo",parseInt(value),true)
			TriggerClientEvent("sound:source",source,"coin",0.5)
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
function cnVRP.MarcarOcorrencia()
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local soldado = vRP.getUsersByPermission("policia.permissao")
		for l,w in pairs(soldado) do
			print(1)
			local player = vRP.getUserSource(parseInt(w))
			if player then
				async(function()
					local id = idgens:gen()
					blips[id] = vRPclient.addBlip(player,x,y,z,10,84,"Ocorrência",0.5,false)
					vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
					TriggerClientEvent('chatMessage',player,"911 - ",{64,64,255},"Recebemos uma denuncia de tráfico, verifique o ocorrido.")
					local data = { x = x, y = y, z = z, title = "911 " , code = "Tráfico", veh = "Recebemos uma denuncia de tráfico, verifique o ocorrido." }
					TriggerClientEvent('NotifyPush',player,data)
					SetTimeout(20000,function() vRPclient.removeBlip(player,blips[id]) idgens:free(id) end)
				end)
			end
		end
		PerformHttpRequest(webhookdrugs, function(err, text, headers) end, 'POST', json.encode({
			embeds = {
				{ 
					title = "REGISTRO DE DROGAS",
					thumbnail = {
					url = "LOGO DO SEU SERVIDOR"
					}, 
					fields = {
						{ 
							name = "**QUEM FOI DENUNCIADO:**", 
							value = "` "..identity.name.." "..identity.firstname.." ["..user_id.."] `"
						}
					}, 
					footer = { 
						text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
						icon_url = "LOGO DO SEU SERVIDOR" 
					},
					color = 15914080 
				}
			}
		}), { ['Content-Type'] = 'application/json' })
	end
end