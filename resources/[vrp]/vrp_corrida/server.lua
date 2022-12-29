
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel") 
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP") 
vRPclient = Tunnel.getInterface("vRP")

cRP = {}
Tunnel.bindInterface("vrp_corrida",cRP)
vRACES = Tunnel.getInterface("vrp_corrida")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local pay = {
	[1] = { ['min'] = 10000, ['max'] = 40000 },
	[2] = { ['min'] = 10000, ['max'] = 40000 },
	[3] = { ['min'] = 10000, ['max'] = 40000 },
	[4] = { ['min'] = 10000, ['max'] = 40000 },
	[5] = { ['min'] = 10000, ['max'] = 40000 },
	[6] = { ['min'] = 10000, ['max'] = 40000 },
	[7] = { ['min'] = 10000, ['max'] = 40000 },
	[8] = { ['min'] = 10000, ['max'] = 40000 },
	[9] = { ['min'] = 10000, ['max'] = 40000 },
	[10] = { ['min'] = 10000, ['max'] = 40000 }
}

function cRP.paymentCheck(check, status)
	local source = source
	local user_id = vRP.getUserId(source)
	local random = math.random(pay[check]["min"], pay[check]["max"])
	-- local policia = vRP.getUsersByPermission("policia.permissao")
	TriggerEvent('eblips:remove',source)
	local policia = 1
	if parseInt(policia) == 0 then
		vRP.giveInventoryItem(user_id, "dinheiro-sujo", parseInt(random*status))
	else
		if policia >= 3 then 	
			vRP.giveInventoryItem(user_id, "dinheiro-sujo", parseInt((random*6 / 3)*status))
		else
			vRP.giveInventoryItem(user_id, "dinheiro-sujo", parseInt((random*policia / 3)*status))
		end
	end
end

local racepoint = 1
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(180000)
		racepoint = math.random(#pay)
	end
end)

function cRP.getRacepoint()
	return parseInt(racepoint)
end

function cRP.startBombRace()
	local source = source
	local policia = vRP.getUsersByPermission("policia.permissao")
	TriggerEvent('eblips:add',{ name = "Corredor", src = source, color = 2 })
	TriggerClientEvent("vrp_sysblips:ToggleService",source,"Corredor",2)
	for l,w in pairs(policia) do
		local player = vRP.getUserSource(parseInt(w))
		if player then
			async(function()
				vRPclient._playSound(player, 'Oneshot_Final', 'MP_MISSION_COUNTDOWN_SOUNDSET')
				TriggerClientEvent('chatMessage', player, '911', {64,64,255}, 'Encontramos um corredor ilegal na cidade, intercepte-o.')
			end)
		end
	end
end

function cRP.setSearchTimer()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.searchTimer(user_id,parseInt(600))
	end
end

function cRP.searchTimer()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.searchReturn(source,user_id)
	end
end

function cRP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id, 'policia.permissao') or vRP.hasPermission(user_id, 'paramedico.permissao') then
		return false
	else 
		if vRP.getInventoryItemAmount(user_id,"ticket") >= 1 then 
			vRP.tryGetInventoryItem(user_id,"ticket",1,true)
			TriggerClientEvent("Notify",source,"negado","Você não tem um <b>Ticket</b>",4000)
			return true
		end
		return false
	end
end

function cRP.removeBombRace()
	local source = source
	TriggerEvent('eblips:remove',source)
	TriggerEvent("vrp_sysblips:ExitService",source)
end

RegisterCommand('unbomb',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, 'policia.permissao') then
		local nplayer = vRPclient.getNearestPlayer(source,5)
		if nplayer then
			TriggerClientEvent('emp_race:unbomb', nplayer)
			TriggerClientEvent("Notify",source,"sucesso","Você desarmou a <b>Bomba</b>",4000)
		end
	end
end)
