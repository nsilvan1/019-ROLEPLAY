local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

Drog = {}
Tunnel.bindInterface("drogas",Drog)
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookvendadrogas = "https://discord.com/api/webhooks/1058404067568799754/pXVVFMYkm9d7mr1RPvahC4Xiqaf7bpVg9CPiCEgdJzmqGqnk6XmLX92c-oxn8aKEFW57"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local pagamento = {}
local total = 0

local quantidade = {}

function Drog.Quantidade()
	local source = source

	if quantidade[source] == nil then
	   quantidade[source] = math.random(3,7)	
	end

	TriggerClientEvent("quantidade-drogas",source,parseInt(quantidade[source]))
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function Drog.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)	
	if user_id then
		if vRP.getInventoryItemAmount(user_id, 'maconha') <= 0 and vRP.getInventoryItemAmount(user_id, 'cocaina') <= 0 and vRP.getInventoryItemAmount(user_id, 'metanfetamina') <= 0 and vRP.getInventoryItemAmount(user_id, 'lsd')  <= 0 then
			TriggerClientEvent("Notify",source,"negado","Número insuficiente de Drogas.")
		else
			local policia = vRP.getUsersByPermission("policia.permissao")
			local valorDroga = math.random(1000,1200) 
				if #policia < 2 then 
					valorDroga = math.random(1000,1200) 
				elseif #policia >= 2 then
					valorDroga = math.random(1400,1600) 
				elseif #policia >= 4 then
					valorDroga = math.random(1800,2000) 
				elseif #policia >= 6 then
					valorDroga = math.random(2100,2200)
				elseif #policia >= 8 then
					valorDroga = math.random(2200,2400)
				end 

			local totalPagamento = 0
			if vRP.getInventoryItemAmount(user_id, 'maconha') >= quantidade[source] then
				if vRP.tryGetInventoryItem(user_id,"maconha",quantidade[source]) then
					total = parseInt(quantidade[source])
					pagamento[source] = valorDroga * total
					totalPagamento = totalPagamento + pagamento[source]
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					vRPclient._playAnim(source, true, {{"mp_common","givetake1_a"}}, false)
				end
			end
			if vRP.getInventoryItemAmount(user_id, 'cocaina') >= quantidade[source] then
				if vRP.tryGetInventoryItem(user_id,"cocaina",quantidade[source]) then
					total = parseInt(quantidade[source])
					pagamento[source] = valorDroga * total
					totalPagamento = totalPagamento + pagamento[source]
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					vRPclient._playAnim(source, true, {{"mp_common","givetake1_a"}}, false)
				end
			end
			
			if vRP.getInventoryItemAmount(user_id, 'metanfetamina') >= quantidade[source] then
				if vRP.tryGetInventoryItem(user_id,"metanfetamina",quantidade[source]) then
					total = parseInt(quantidade[source])
					pagamento[source] = valorDroga * total
					totalPagamento = totalPagamento + pagamento[source]
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					vRPclient._playAnim(source, true, {{"mp_common","givetake1_a"}}, false)
				end
			end

			if vRP.getInventoryItemAmount(user_id, 'lsd') >= quantidade[source] then
				if vRP.tryGetInventoryItem(user_id,"lsd",quantidade[source]) then
					total = parseInt(quantidade[source])
					pagamento[source] = valorDroga * total
					totalPagamento = totalPagamento + pagamento[source]
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					vRPclient._playAnim(source, true, {{"mp_common","givetake1_a"}}, false)
				end
			end
	
			if totalPagamento > 0 then
				vRP.giveInventoryItem(user_id, "dinheirosujo", totalPagamento)
				quantidade[source] = math.random(4,7)
				TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..totalPagamento.." dinheiro sujo.")
						PerformHttpRequest(webhookvendadrogas, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 
									title = "REGISTRO - DROGAS:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
									thumbnail = {
									url = "https://i.imgur.com/q99CLfp.png"
									}, 
									fields = {
										{ 
											name = "**Registro do usuário:**", 
											value = "` "..identity.name.." "..identity.firstname.." ` "
										},
										{ 
											name = "**Nº do ID:**", 
											value = "` "..user_id.." ` "
										},
										{ 
											name = "**Vendeu:**", 
											value = "` "..quantidade[source].." Drogas ` "
										},
										{ 
											name = "**Ganhou:**", 
											value = "` "..totalPagamento.." Dinheiro sujo ` "
										},
									}, 
									footer = { 
										text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
										icon_url = "https://i.imgur.com/q99CLfp.png" 
									},
									color = 16753920 
								}
							}
						}), { ['Content-Type'] = 'application/json' })
				return true
			end			
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
function Drog.MarcarOcorrencia()
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local soldado = vRP.getUsersByPermission("policia.permissao")
		for l,w in pairs(soldado) do
			local player = vRP.getUserSource(parseInt(w))
			if player then
				async(function()
					TriggerClientEvent("Notify",player,{ time = os.date("%H:%M:%S - %d/%m/%Y"), code = 20, title = ".Denúncia de venda de drogas em andamento", x = x, y = y, z = z, rgba = {0,0,0} })
				end)
			end
		end
		
	end
end