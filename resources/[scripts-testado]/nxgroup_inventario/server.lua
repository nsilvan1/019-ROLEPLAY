local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
local cfg = module("vrp","cfg/groups")

local config = module("nxgroup_inventario", "config")
local cfg_itens = module("nxgroup_inventario", "itens")
-- local garage = Proxy.getInterface("nyo_modules")
local garage = Proxy.getInterface("nation_garages")


vRPN = {}
Tunnel.bindInterface("nxgroup_inventario",vRPN)
Proxy.addInterface("nxgroup_inventario",vRPN)

vRPNclient = Tunnel.getInterface("nxgroup_inventario")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local idgens = Tools.newIDGenerator()
local groups = cfg.groups

vGARAGE = Tunnel.getInterface("vrp_garages")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookdropar = config.webhookdropar
local webhookenviar = config.webhookenviar
local webhookequipar = config.webhookequipar
local webhookrecarregar = config.webhookrecarregar
local webhookpegar = config.webhookpegar
local webhookbaucarro = config.webhookbaucarro
local webhookbau = config.webhookbau
local webhookbaucasas = config.webhookbaucasas
local webhookGuardarArmas = config.webhookGuardarArmas
local webhookTryDup = config.webhookTryDup
local itens_config = cfg_itens.usaveis

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
----------------------------------------------------------------------------
--[ VARIÁVEIS ]-------------------------------------------------------------
----------------------------------------------------------------------------
local network_delay = {}
local bind1 = {}
local bind2 = {}
local bind3 = {}
local bind4 = {}
local chestActived = {}

function vRPN.chestInUse(chest)
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)

	if nuser_id then
		TriggerClientEvent("Notify",source,"negado","Você não consegue pegar os itens com pessoas por perto.")
		return false
	else
		for k,v in pairs(chestActived) do
			if v == chest then
				TriggerClientEvent("Notify",source,"negado","Baú já está sendo utilizado por outra pessoa.")
				return false
			end
		end
		return true
	end
end

function vRPN.closeChest()
	local source = source
	local user_id = vRP.getUserId(source)
	chestActived[user_id] = nil
end

AddEventHandler("vRP:playerLeave",function(user_id,source)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		chestActived[user_id] = nil
	end
end)
----------------------------------------------------------------------------
--[ PARTE NOVA ] -----------------------------------------------------------
----------------------------------------------------------------------------
function vRPN.Mochila()
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserDataTable(user_id)
	local inventario = {}
	local armas = {}
	if data and data.inventory then
		for k,v in pairs(data.inventory) do
			if vRP.itemBodyList(k) then
				table.insert(inventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k) })
			end
		end
		for k,v in pairs(data.weapons) do
			local arma = "wbody|"..k
			table.insert(armas,{ amount = parseInt(v.ammo), arma = k,name = vRP.itemNameList(arma), index = vRP.itemIndexList(arma)})
		end
		return inventario,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id),bind1[user_id],bind2[user_id],bind3[user_id],bind4[user_id],armas
	end
end

function vRPN.getIdentity()
    local source = source
    local user_id = vRP.getUserId(source)
    local data = vRP.getUserDataTable(user_id)
    if data then
        local bank = vRP.getBankMoney(user_id)
        local job = getUserGroupByType(user_id,"job")
        local vip = getUserGroupByType(user_id,"vip")
        local multas = vRP.getUData(user_id,"vRP:multas")
        local carteira = vRP.getMoney(user_id)
        local identity = vRP.getUserIdentity(user_id)
        local peso = vRP.getInventoryWeight(user_id)
        local maxPeso = vRP.getInventoryMaxWeight(user_id)
        return {identity.firstname,identity.name,parseInt(user_id),identity.user_id,identity.phone,identity.registration,bank,job,vip,multas,carteira,identity.age, peso, maxPeso}
    end
end

function vRPN.unEquip(arma)
    local source = source
    local user_id = vRP.getUserId(source)
	if not network_delay[source] then
		network_delay[source] = true
		SetTimeout(3000, function()
			network_delay[source] = nil
		end)
		local data = vRP.getUserDataTable(user_id)
		local identity = vRP.getUserIdentity(user_id)
		local weapons = {}

		for k,v in pairs(data.weapons) do 
			if k ~= arma.item then
				weapons[k] = v
			else
				if not config.policeItems[arma.item] then
					vRP.giveInventoryItem(user_id,"wbody|"..arma.item,1)
					if arma.amount > 0 then
						vRP.giveInventoryItem(user_id,"wammo|"..arma.item,arma.amount)
						TriggerClientEvent('save:database',source)
						TriggerClientEvent("Notify",source,"sucesso","Guardou sua "..arma.nome.." na mochila.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Impossível guardar armamento de policial.")
				end
			end
		end
		vRPclient.replaceWeapons(source,weapons)
		SendWebhookMessage(webhookGuardarArmas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU UMA]: "..arma.item.." \n[QUANTIDADE MUNICAO]: "..arma.amount.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

local inve = {}
inve.get_name_list = function(item)
	if config.itemlist[item] then
		return(config.itemlist[item].nome)
	end
end

inve.get_index_item = function(item)
	if config.itemlist[item] then
		return(config.itemlist[item].index)
	end
end

inve.get_type_item = function(item)
	if config.itemlist[item] then
		return(config.itemlist[item].type)
	end
end

inve.get_name_peso = function(item)
	if config.itemlist[item] then
		return(config.itemlist[item].peso)
	end
end

inve.get_info_item = function(item)
	return(config.itemlist[item])
end

exports('get_name_list', inve.get_name_list)
exports('get_index_item', inve.get_index_item)
exports('get_type_item', inve.get_type_item)
exports('get_name_peso', inve.get_name_peso)
exports('get_info_item', inve.get_info_item)

for k,v in pairs(config.itemlist) do
	vRP.defInventoryItem(k,v.nome,v.peso)
end
----------------------------------------------------------------------------
--[ FIM DA PARTE NOVA ] ----------------------------------------------------
----------------------------------------------------------------------------
function vRPN.sendItem(itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local nplayer = vRPclient.getNearestPlayer(source,2)
		local nuser_id = vRP.getUserId(nplayer)
		local identity = vRP.getUserIdentity(user_id)
		local identitynu = vRP.getUserIdentity(nuser_id)
		if nuser_id and vRP.itemIndexList(itemName) then
			if parseInt(amount) > 0 then
				if vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(itemName) * amount <= vRP.getInventoryMaxWeight(nuser_id) then
					if vRP.tryGetInventoryItem(user_id,itemName,amount) then
						vRP.giveInventoryItem(nuser_id,itemName,amount)
						vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
						TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..vRP.format(amount).."x "..vRP.itemNameList(itemName).."</b>.",8000)
						
						local quantidaItem = vRP.format(parseInt(amount))
						SendWebhookMessage(webhookenviar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						
						TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..vRP.format(amount).."x "..vRP.itemNameList(itemName).."</b>.",8000)
						vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)
						TriggerClientEvent('EG:UpdateInv',source,'updateMochila')
						TriggerClientEvent('EG:UpdateInv',nplayer,'updateMochila')
						return true
					end
				end
			else
				local data = vRP.getUserDataTable(user_id)
				for k,v in pairs(data.inventory) do
					if itemName == k then
						if vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(itemName) * parseInt(v.amount) <= vRP.getInventoryMaxWeight(nuser_id) then
							if vRP.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
								vRP.giveInventoryItem(nuser_id,itemName,parseInt(v.amount))
								vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
								TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
								
								local quantidaItem = vRP.format(parseInt(amount))
								SendWebhookMessage(webhookenviar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(parseInt(v.amount)).." "..vRP.itemNameList(itemName).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								
								TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
								vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)
								TriggerClientEvent('EG:UpdateInv',source,'updateMochila')
								TriggerClientEvent('EG:UpdateInv',nplayer,'updateMochila')
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end

local pick = {}
local blips = {}
function vRPN.useItem(itemName,type,ramount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and ramount ~= nil and parseInt(ramount) >= 0 then
		if type == "usar" then
			if itens_config[itemName] ~= nil then
				itens_config[itemName](source,user_id)
			else
			end
		elseif type == "equipar" then
			if vRP.tryGetInventoryItem(user_id,itemName,1) then
				local weapons = {}
				local identity = vRP.getUserIdentity(user_id)
				weapons[string.gsub(itemName,"wbody|","")] = { ammo = 0 }
				vRPclient._giveWeapons(source,weapons)
				SendWebhookMessage(webhookequipar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[EQUIPOU]: "..vRP.itemNameList(itemName).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				TriggerClientEvent('EG:UpdateInv',source,'updateMochila')
			end
		elseif type == "recarregar" then
			local uweapons = vRPclient.getWeapons(source)
			local weaponuse = string.gsub(itemName,"wammo|","")
			local weaponusename = "wammo|"..weaponuse
			local identity = vRP.getUserIdentity(user_id)
			if uweapons[weaponuse] then
				local itemAmount = 0
				local data = vRP.getUserDataTable(user_id)
				for k,v in pairs(data.inventory) do
					if weaponusename == k then
						if v.amount > 250 then
							v.amount = 250
						end
						itemAmount = v.amount
						if vRP.tryGetInventoryItem(user_id, weaponusename, parseInt(v.amount)) then
							local weapons = {}
							weapons[weaponuse] = { ammo = v.amount }
							itemAmount = v.amount
							vRPclient._giveWeapons(source,weapons,false)
							local quantidaItem = vRP.format(parseInt(amount))
							SendWebhookMessage(webhookrecarregar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RECARREGOU]: "..vRP.itemNameList(itemName).." \n[MUNICAO]: "..vRP.format(parseInt(v.amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							TriggerClientEvent('EG:UpdateInv',source,'updateMochila')
						end
					end
				end
			end
		end
	end
end
-------------------------------------------------------------------
--[ DROP ITEM ]----------------------------------------------------
-------------------------------------------------------------------
function vRPN.dropItem(itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local x,y,z = vRPclient.getPosition(source)
		if parseInt(amount) > 0 and vRP.tryGetInventoryItem(user_id,itemName,amount) then
			TriggerEvent("DropSystem:create",itemName,amount,x,y,z,3600)
			vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
			local quantidaItem = vRP.format(parseInt(amount))
			SendWebhookMessage(webhookdropar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			
			TriggerClientEvent('Creative:Update',source,'updateMochila')
			return true
		else
			local data = vRP.getUserDataTable(user_id)
			for k,v in pairs(data.inventory) do
				if itemName == k then
					if vRP.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
						TriggerEvent("DropSystem:create",itemName,parseInt(v.amount),x,y,z,3600)
						vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
						local quantidaItem = vRP.format(parseInt(amount))
						SendWebhookMessage(webhookdropar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.format(parseInt(v.amount)).." "..vRP.itemNameList(itemName).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

						TriggerClientEvent('Creative:Update',source,'updateMochila')
						return true
					end
				end
			end
		end
	end
	return false
end
-------------------------------------------------------------------
--[ SISTEMA DE DROP ITEMS ]----------------------------------------
-------------------------------------------------------------------
local markers_ids = Tools.newIDGenerator()
local items = {}
AddEventHandler('DropSystem:create',function(item,count,px,py,pz,tempo)
	local id = markers_ids:gen()
	if id then
		items[id] = { item = item, count = count, x = px, y = py, z = pz, name = vRP.itemNameList(item), tempo = tempo, peso = vRP.getItemWeight(item) }
		TriggerClientEvent('DropSystem:createForAll',-1,id,items[id])
	end
end)

RegisterServerEvent('DropSystem:drop')
AddEventHandler('DropSystem:drop',function(item,count)
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.giveInventoryItem(user_id,item,count)
		TriggerClientEvent('DropSystem:createForAll',-1)
	end
end)

function vRPN.takeDropItem(id)
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)

	if nuser_id then
		TriggerClientEvent("Notify",source,"negado","Você não consegue pegar os itens com pessoas por perto.")
	else
		if user_id then
			if items[id] ~= nil then
				local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight(items[id].item)*items[id].count
				if new_weight <= vRP.getInventoryMaxWeight(user_id) then
					if items[id] == nil then
						return
					end
					vRP.giveInventoryItem(user_id,items[id].item,items[id].count)
					vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
					local identity = vRP.getUserIdentity(user_id)
					SendWebhookMessage(webhookpegar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[PEGOU]: "..items[id].count.." "..items[id].name..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					
					items[id] = nil
					markers_ids:free(id)
					TriggerClientEvent('DropSystem:remove',-1,id)
					return true
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.")
					return false
				end
			end
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(items) do
			if items[k].tempo > 0 then
				items[k].tempo = items[k].tempo - 1
				if items[k].tempo <= 0 then
					items[k] = nil
					markers_ids:free(k)
					TriggerClientEvent('DropSystem:remove',-1,k)
				end
			end
		end
	end
end)

-----------------------------------------------------------------
-- CHEST --------------------------------------------------------
-----------------------------------------------------------------
local chest = config.chest

function vRPN.checkIntPermissions(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			if vRP.hasPermission(user_id,chest[chestName][6]) then
				return true
			end
		end
	end
	return false
end

function vRPN.openChest(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	chestActived[user_id] = chestName

	if user_id then
		local data = vRP.getUserDataTable(user_id)
		local inventario = {}
		if data and data.inventory then
			for k,v in pairs(data.inventory) do
				if vRP.itemBodyList(k) then
					table.insert(inventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k) })
				end
			end 
		end

		local hsinventory = {}
		local myinventory = {}
		local data = vRP.getSData("chest:"..tostring(chestName))
		local result = json.decode(data) or {}
		if result then
			for k,v in pairs(result) do
				table.insert(hsinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
			end

			local inv = vRP.getInventory(parseInt(user_id))
			for k,v in pairs(inv) do
				table.insert(myinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
			end
		end
		return hsinventory,inventario,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(result),parseInt(chest[tostring(chestName)][5])
	end
end

function vRPN.storeItem(chestName,itemName,amount)
	local source = source
	if not network_delay[source] then
		network_delay[source] = true
		SetTimeout(3000, function()
			network_delay[source] = nil
		end)
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id then
					local data = vRP.getSData("chest:"..tostring(chestName))
					local items = json.decode(data) or {}
					if items then
						if parseInt(amount) > 0 then
							local new_weight = vRP.computeItemsWeight(items)+vRP.getItemWeight(itemName)*parseInt(amount)
							if new_weight <= parseInt(chest[tostring(chestName)][5]) then
								if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(amount)) then
									if user_id then
										if items[itemName] ~= nil then
											items[itemName].amount = parseInt(items[itemName].amount) + parseInt(amount)
									else
										items[itemName] = { amount = parseInt(amount) }
									end
									vRP.setSData("chest:"..tostring(chestName),json.encode(items))
									SendWebhookMessage(chest[chestName][7],"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..amount.." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									SendWebhookMessage(webhookbau,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..amount.." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									TriggerClientEvent('EG:UpdateInv',source,'updateChest')						
								end
							end
						else
							TriggerClientEvent("Notify",source,"negado","<b>BAU</b> cheio.",8000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
					end
				end
			end
		end
	end
	return false
end

function vRPN.takeItem(chestName,itemName,amount)
	local source = source
	if not network_delay[source] then
		network_delay[source] = true
		SetTimeout(3000, function()
			network_delay[source] = nil
		end)
		if itemName then
			local user_id = vRP.getUserId(source)
			local identity = vRP.getUserIdentity(user_id)
			if user_id then
				local data = vRP.getSData("chest:"..tostring(chestName))
				local items = json.decode(data) or {}
				if items then
					if parseInt(amount) > 0 then
						if items[itemName] ~= nil and parseInt(items[itemName].amount) >= parseInt(amount) then
							if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
								if user_id then
									vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(amount))
									items[itemName].amount = parseInt(items[itemName].amount) - parseInt(amount)
									if parseInt(items[itemName].amount) <= 0 then
										items[itemName] = nil
									end
									vRP.setSData("chest:"..tostring(chestName),json.encode(items))
									SendWebhookMessage(chest[chestName][7],"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..amount.." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									SendWebhookMessage(webhookbau,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..amount.." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									TriggerClientEvent('EG:UpdateInv',source,'updateChest')
								end
							else
								TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------
---- HOME -------------------------------------------------------
-----------------------------------------------------------------
local chestPeso = {}
function vRPN.openHomeChest(chestName, weight)
	local source = source
	local user_id = vRP.getUserId(source)
	chestPeso[user_id] = weight
	chestActived[user_id] = chestName

	local nplayer = vRPclient.getNearestPlayer(source,3)
	local nuser_id = vRP.getUserId(nplayer)

	if user_id then
		local data = vRP.getUserDataTable(user_id)
		local inventario = {}
		if data and data.inventory then
			for k,v in pairs(data.inventory) do
				if vRP.itemBodyList(k) then
					table.insert(inventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k) })
				end
			end 
		end

		local hsinventory = {}
		local myinventory = {}
		local data = vRP.getSData("chest:"..tostring(chestName))
		local result = json.decode(data) or {}
		if result then
			for k,v in pairs(result) do
				table.insert(hsinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
			end

			local inv = vRP.getInventory(parseInt(user_id))
			for k,v in pairs(inv) do
				table.insert(myinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
			end
		end

		return hsinventory,inventario,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id),parseInt(chest[tostring(chestName)])
	end
end

function vRPN.storeHomeItem(chestName,itemName,amount)
	local source = source
	if not network_delay[source] then
		network_delay[source] = true
		SetTimeout(3000, function()
			network_delay[source] = nil
		end)
		if itemName then
			local user_id = vRP.getUserId(source)
			local identity = vRP.getUserIdentity(user_id)
			if user_id then
				if string.match(itemName,"identidade") then
					TriggerClientEvent("Notify",source,"importante","Não pode guardar este item.",8000)
					return
				end
				local data = vRP.getSData("chest:"..tostring(chestName))

				local items = json.decode(data) or {}
				if items then
					if parseInt(amount) > 0 then
						local new_weight = vRP.computeItemsWeight(items)+vRP.getItemWeight(itemName)*parseInt(amount)
						if new_weight <= chestPeso[user_id] then
							if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(amount)) then
								if user_id then								
									if items[itemName] ~= nil then
										items[itemName].amount = parseInt(items[itemName].amount) + parseInt(amount)
									else
										items[itemName] = { amount = parseInt(amount) }
									end
									vRP.setSData("chest:"..tostring(chestName),json.encode(items))
									SendWebhookMessage(chest[chestName],"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..amount.." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									SendWebhookMessage(webhookbaucasas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..amount.." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									TriggerClientEvent('EG:UpdateInv',source,'updateHomeChest')						
								end
							end
						else
							TriggerClientEvent("Notify",source,"negado","<b>BAU</b> cheio.",8000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
					end
				end
			end
		end
	end
	return false
end

function vRPN.takeHomeItem(chestName,itemName,amount)
	local source = source
	if not network_delay[source] then
		network_delay[source] = true
		SetTimeout(3000, function()
			network_delay[source] = nil
		end)
		if itemName then
			local user_id = vRP.getUserId(source)
			local identity = vRP.getUserIdentity(user_id)
			if user_id then
				local data = vRP.getSData("chest:"..tostring(chestName))
				local items = json.decode(data) or {}
				if items then
					if parseInt(amount) > 0 then
						if items[itemName] ~= nil and parseInt(items[itemName].amount) >= parseInt(amount) then
							if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
								if user_id then
									vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(amount))
									items[itemName].amount = parseInt(items[itemName].amount) - parseInt(amount)
									if parseInt(items[itemName].amount) <= 0 then
										items[itemName] = nil
									end
									vRP.setSData("chest:"..tostring(chestName),json.encode(items))
									SendWebhookMessage(chest[chestName],"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..amount.." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									SendWebhookMessage(webhookbaucasas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..amount.." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									TriggerClientEvent('EG:UpdateInv',source,'updateHomeChest')
								end
							else
								TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------
-- TRUNKCHEST ---------------------------------------------------
-----------------------------------------------------------------
local uchests = {}
local vchests = {}

function vRPN.trunkChest()
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,10)
	local nuser_id = vRP.getUserId(nplayer)

	if user_id then
		local vehicle,vnetid,placa,vname,lock,banned,trunk = vRPclient.vehList(source,5)
		if vehicle then
			if lock == 1 then
				local placa_user_id = vRP.getUserByRegistration(placa)
				if placa_user_id then
					local myinventory = {}
					local myvehicle = {}
					local mala = vRP.getSData("chest:u"..parseInt(placa_user_id).."veh_"..vname)
					local sdata = json.decode(mala) or {}
					
					local max_veh = 0
					if config.nyoGarages then
						max_veh = exports['nyo_modules']:getVehicleTrunk(vname)
					elseif config.nationGarages then
						max_veh = parseInt(garage.getVehicleTrunk(vname))
					else
						max_veh = inventory.chestweight[vname] or 50
					end

					if sdata then
						for k,v in pairs(sdata) do
							table.insert(myinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), type = vRP.itemTypeList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
						end
						local data2 = vRP.getUserDataTable(user_id)
						if data2 and data2.inventory then
							for k,v in pairs(data2.inventory) do
								table.insert(myvehicle,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
							end
						end
						uchests[parseInt(user_id)] = mala
						vchests[parseInt(user_id)] = vname
					end
					
					local bauDoCarro = "chest:u"..parseInt(placa_user_id).."veh_"..vname
					chestActived[user_id] = bauDoCarro

					return myinventory,myvehicle,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(sdata),parseInt(max_veh)
				end
			else 
				TriggerClientEvent("Notify",source,"importante","Veículo Trancado.",8000)
			end
		end
	end
end

function vRPN.storeTrunkItem(itemName,amount)
	local source = source
	if not network_delay[source] then
		network_delay[source] = true
		SetTimeout(3000, function()
			network_delay[source] = nil
		end)
		if itemName then
			local user_id = vRP.getUserId(source)
			local identity = vRP.getUserIdentity(user_id)
			if user_id then
				if string.match(itemName,"dinheiro-sujo") then
					TriggerClientEvent("Notify",source,"importante","Não pode guardar este item em veículos.",8000)
					return
				end

				local vehicle,vnetid,placa,vname,lock,banned,trunk = vRPclient.vehList(source,5)
				local placa_user_id = vRP.getUserByRegistration(placa)
				local data = vRP.getSData("chest:u"..parseInt(placa_user_id).."veh_"..vname)
				local items = json.decode(data) or {}

				if items then
					local max_veh = 0
					if config.nyoGarages then
						max_veh = exports['nyo_modules']:getVehicleTrunk(vname)
					elseif config.nationGarages then
						max_veh = parseInt(garage.getVehicleTrunk(vname))
					else
						max_veh = inventory.chestweight[vname] or 50
					end
					if parseInt(amount) > 0 then
						local new_weight = vRP.computeItemsWeight(items)+vRP.getItemWeight(itemName)*parseInt(amount)
						if new_weight <= parseInt(max_veh) then
							if vRP.tryGetInventoryItem(user_id,itemName,parseInt(amount)) then
								if user_id then
									if items[itemName] == nil then
										items[itemName] = { amount = parseInt(amount) }
									else
										items[itemName].amount = parseInt(items[itemName].amount) + parseInt(amount)
									end
									SendWebhookMessage(webhookbaucarro,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(items[itemName].amount)).." "..vRP.itemNameList(itemName).." \n[BAU][ID]:"..parseInt(placa_user_id).." do carro: "..vname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									vRP.setSData("chest:u"..parseInt(placa_user_id).."veh_"..vname,json.encode(items))
									TriggerClientEvent('EG:UpdateInv',source,'updateTrunkChest')
								end
							end
						else
							TriggerClientEvent("Notify",source,"negado","<b>Porta malas</b> cheio.",8000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
					end
				end
			end
		end
	end
	return false
end

function vRPN.takeTrunkchestItem(itemName,amount)
	local source = source
	if not network_delay[source] then
		network_delay[source] = true
		SetTimeout(3000, function()
			network_delay[source] = nil
		end)
		if itemName then
			local user_id = vRP.getUserId(source)
			local identity = vRP.getUserIdentity(user_id)
			if user_id then

				local vehicle,vnetid,placa,vname,lock,banned,trunk = vRPclient.vehList(source,5)
				local placa_user_id = vRP.getUserByRegistration(placa)
				local data = vRP.getSData("chest:u"..parseInt(placa_user_id).."veh_"..vname)
				local items = json.decode(data) or {}

				if items then
					if parseInt(amount) > 0 then
						if items[itemName] ~= nil and items[itemName].amount >= parseInt(amount) then
							if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then
								if user_id then
									SendWebhookMessage(webhookbaucarro,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU][ID]:"..parseInt(placa_user_id).." do carro: "..vname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									vRP.giveInventoryItem(user_id,itemName,parseInt(amount))
									
									items[itemName].amount = items[itemName].amount - parseInt(amount)
									if items[itemName].amount <= 0 then
										items[itemName] = nil
									end
									TriggerClientEvent('EG:UpdateInv',source,'updateTrunkChest')
									vRP.setSData("chest:u"..parseInt(placa_user_id).."veh_"..vname,json.encode(items))
								end

							else
								TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
					end

				end
			end
		end
	end
	return false
end

function vRPN.trunkChestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vnetid = vRPclient.vehList(source,5)
		if vehicle then
			vGARAGE.vehicleClientTrunk(-1,vnetid,true)
		end
	end
	return false
end
 
function vRPN.trunkChestOpen()
	local source = source
	local user_id = vRP.getUserId(source)	
	local nplayer = vRPclient.getNearestPlayer(source,10)
	local nuser_id = vRP.getUserId(nplayer)

	if nuser_id then
		TriggerClientEvent("Notify",source,"negado","Você não consegue pegar os itens com pessoas por perto.")
		return false
	else
		if user_id then
			if config.nyoGarages then
				local vehicle,vnetid,placa,vname,lock,banned,trunk,teste,teste2,teste3 = vRPclient.vehList(source,5)
				local trunk = exports['nation_garages']:getVehicleTrunk(vname)
				if vehicle then
					if lock == 1 then
						if banned then
							return
						end
						local placa_user_id = vRP.getUserByRegistration(placa)
						if placa_user_id then
							local mala = "chest:u"..parseInt(placa_user_id).."veh_"..vname
							vGARAGE.vehicleClientTrunk(-1,vnetid,false)
							TriggerClientEvent("trunkchest:Open",source,mala)
						end
					end
				end
			elseif config.nationGarages then
				local vehicle,vnetid,placa,vname,lock,banned,trunk,teste,teste2,teste3 = vRPclient.vehList(source,5)
				local trunk = garage.getVehicleTrunk(vname)
				if vehicle then
					if lock == 1 then
						if banned then
							return
						end
						local placa_user_id = vRP.getUserByRegistration(placa)
						if placa_user_id then
							local mala = "chest:u"..parseInt(placa_user_id).."veh_"..vname
							vGARAGE.vehicleClientTrunk(-1,vnetid,false)
							TriggerClientEvent("trunkchest:Open",source,mala)
						end
					end
				end
			else
				local vehicle,vnetid,placa,vname,lock,banned,trunk,teste,teste2,teste3,teste4 = vRPclient.vehList(source,5)
				if vehicle then
					if lock == 1 then
						if banned then
							return
						end
						local placa_user_id = vRP.getUserByRegistration(placa)
						if placa_user_id then
							vGARAGE.vehicleClientTrunk(-1,vnetid,false)
							TriggerClientEvent("trunkchest:Open",source)
						end
					end
				end
			end
		end
	end
end

-----------------------------------------------------------------
--[ SISTEMA DE STORE ]-------------------------------------------
-----------------------------------------------------------------
local shops = config.itemShops
function vRPN.requestShop(name)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local inventoryShop = {}
		for k,v in pairs(shops[name]["list"]) do
			table.insert(inventoryShop,{ price = parseInt(v), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, weight = vRP.getItemWeight(k) })
		end
		local data = vRP.getUserDataTable(user_id)
		local inventario = {}
		if data and data.inventory then
			for k,v in pairs(data.inventory) do
				if vRP.itemBodyList(k) then
					table.insert(inventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k) })
				end
			end
		end
		return inventoryShop,inventario,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),{ identity.name.." "..identity.firstname,parseInt(user_id),parseInt(identity.bank),parseInt(user_id),identity.phone,identity.registration }
	end
end

function vRPN.tryBuyItem(shopItem,shopQTD,shopType)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	local craftar = false
	if not shops[shopType]["list"][shopItem] then
		SendWebhookMessage(webhookTryDup,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[FOI PEGO TENTANDO DUPAR PELO DEVTOOLS NA LOJA]: "..shopQTD.."x "..shopItem.." - "..shopType.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		TriggerClientEvent("Notify",source,"negado","ERRO, Reporte ao EG!",3000)
		return true
	end
	if shopQTD > 0 then
		if shopType == "gunsCraft" or shopType == "ammoCraft" then
			for k in pairs(shops[shopType]["list"][shopItem]) do
				if vRP.getInventoryItemAmount(user_id,k) >= shops[shopType]["list"][shopItem][k]*shopQTD then
					craftar = true
				else
					craftar = false
					TriggerClientEvent("Notify",source,"negado","Você não possui "..shops[shopType]["list"][shopItem][k]*shopQTD.." "..k..".",3000)
					return
				end
			end
			if craftar then
				if vRP.hasPermission(user_id,shops[shopType]["perm"]) then
					for k in pairs(shops[shopType]["list"][shopItem]) do
						vRP.tryGetInventoryItem(user_id,k,shops[shopType]["list"][shopItem][k]*shopQTD)
					end
					vRP.giveInventoryItem(user_id,shopItem,shopQTD)
					TriggerClientEvent("Notify",source,"sucesso","Você montou "..shopItem..".",3000)
				else
					TriggerClientEvent("Notify",source,"negado","Você não tem permissão.",3000)
				end
			end
		else
			if shops[shopType]["perm"] == nil then
				if shops[shopType]["cash"] == "limpo" then
					local new_weight = vRP.getInventoryWeight(user_id)+(vRP.getItemWeight(shopItem)*shopQTD)
				
					if new_weight <= vRP.getInventoryMaxWeight(user_id) then
						if vRP.tryFullPayment(user_id,parseInt(shops[shopType]["list"][shopItem])*shopQTD) then
							vRP.giveInventoryItem(user_id,shopItem,shopQTD)
							TriggerClientEvent("Notify",source,"sucesso","Comprou "..shopQTD.." "..shopItem..".",3000)
						else
							TriggerClientEvent("Notify",source,"negado","Dinheiro Insuficiente.",3000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.",3000)
					end
				elseif  shops[shopType]["cash"] == "sujo" then
					local new_weight = vRP.getInventoryWeight(user_id)+(vRP.getItemWeight(shopItem)*shopQTD)
					if new_weight <= vRP.getInventoryMaxWeight(user_id) then
						if vRP.tryGetInventoryItem(user_id, "dinheiro-sujo", shops[shopType]["list"][shopItem]*shopQTD) then
							vRP.giveInventoryItem(user_id,shopItem,shopQTD)
							TriggerClientEvent("Notify",source,"sucesso","Comprou "..shopQTD.." "..shopItem..".",3000)
						else
							TriggerClientEvent("Notify",source,"negado","Dinheiro SUJO Insuficiente.",3000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.",3000)
					end
				end
			elseif vRP.hasPermission(user_id,shops[shopType]["perm"]) then
				if shops[shopType]["cash"] == "limpo" then
					local new_weight = vRP.getInventoryWeight(user_id)+(vRP.getItemWeight(shopItem)*shopQTD)
					if new_weight <= vRP.getInventoryMaxWeight(user_id) then
						if vRP.tryFullPayment(user_id,parseInt(shops[shopType]["list"][shopItem])*shopQTD) then
							vRP.giveInventoryItem(user_id,shopItem,shopQTD)
							TriggerClientEvent("Notify",source,"sucesso","Comprou "..shopQTD.." "..shopItem..".",3000)
						else
							TriggerClientEvent("Notify",source,"negado","Dinheiro Insuficiente.",3000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.",3000)
					end
				elseif  shops[shopType]["cash"] == "sujo" then
					local new_weight = vRP.getInventoryWeight(user_id)+(vRP.getItemWeight(shopItem)*shopQTD)
					if new_weight <= vRP.getInventoryMaxWeight(user_id) then
						if vRP.tryGetInventoryItem(user_id, "dinheiro-sujo", shops[shopType]["list"][shopItem]*shopQTD) then
							vRP.giveInventoryItem(user_id,shopItem,shopQTD)
							TriggerClientEvent("Notify",source,"sucesso","Comprou "..shopQTD.." "..shopItem..".",3000)
						else
							TriggerClientEvent("Notify",source,"negado","Dinheiro SUJO Insuficiente.",3000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.",3000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"negado","Você não tem permissão.",3000)
			end
		end
	else
		TriggerClientEvent("Notify",source,"negado","Quantidade Invalida.",3000)
	end
end

function vRPN.trySellItem(shopItem,shopQTD,shopType)
	local source = source
	local user_id = vRP.getUserId(source)
	shopType = shopType
	if shopQTD then
		if shopQTD >= 0 then
			print(shopItem..'-'.. shopType)
			if shops[shopType]["list"][shopItem] then
				if vRP.tryGetInventoryItem(user_id, shopItem, shopQTD) then
					vRP.giveMoney(user_id,shops[shopType]["list"][shopItem]*shopQTD)
					TriggerClientEvent("Notify",source,"sucesso","Vendeu "..shopQTD.." "..shopItem.." por "..shops[shopType]["list"][shopItem]*shopQTD.." .")
				else
					TriggerClientEvent("Notify",source,"negado","NEGADO.")
				end
			else
			TriggerClientEvent("Notify",source,"negado","A lojinha não compra esse item.")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Quantidade Invalida.")
		end
	end
end

-----------------------------------------------------------------
--[ SISTEMA DE BIND ]--------------------------------------------
-----------------------------------------------------------------
function vRPN.tryBind(data)
	local source = source
	local user_id = vRP.getUserId(source)

	if parseInt(data.slot) == 1 then
		bind1[user_id] = data.item
	end

	if parseInt(data.slot) == 2 then
		bind2[user_id] = data.item
	end

	if parseInt(data.slot) == 3 then
		bind3[user_id] = data.item
	end

	if parseInt(data.slot) == 4 then
		bind4[user_id] = data.item
	end
end

function vRPN.useBind(data)
	local source = source
	local user_id = vRP.getUserId(source)
	local item = nil
	if user_id ~= nil then
		if data == 1 then
			item = bind1[user_id]
		end
		if data == 2 then
			item = bind2[user_id]
		end
		if data == 3 then
			item = bind3[user_id]
		end
		if data == 4 then
			item = bind4[user_id]
		end

		if item then
			if itens_config[item] ~= nil then
				itens_config[item](source,user_id)
			end
		end
	end
end

function getUserGroupByType(user_id,gtype)
	local user_groups = vRP.getUserGroups(user_id)
	for k,v in pairs(user_groups) do
		local eggroup = groups[k]
		if eggroup then
			if eggroup._config and eggroup._config.gtype and eggroup._config.gtype == gtype then
				return eggroup._config.title
			end
		end
	end
	return ""
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNAR ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
local qtdAmmunition = 250
local itemlist = {
    ["GADGET_PARACHUTE"] = { arg = "paraquedas" },
    ["WEAPON_PISTOL"] = { arg = "pistol" },
    ["WEAPON_COMBATPISTOL"] = { arg = "glock" },
    ["WEAPON_PISTOL_MK2"] = { arg = "five" },
    ["WEAPON_REVOLVER"] = { arg = "38" },
    ["WEAPON_RAYPISTOL"] = { arg = "ray" },
    ["WEAPON_FIREWORK"] = { arg = "fire"},
    ["WEAPON_SNOWBALL"] = { arg = "tijolo"},
    ["WEAPON_BALL"] = { arg = "bola"},
    ["WEAPON_ASSAULTSMG"] = { arg = "mtar" },
    ["WEAPON_MICROSMG"] = { arg = "uzi" },
    ["WEAPON_SMG"] = { arg = "smg" },
    ["WEAPON_COMBATPDW"] = { arg = "pdw" },
    ["WEAPON_ASSAULTRIFLE"] = { arg = "ak" },
    ["WEAPON_ASSAULTRIFLE_MK2"] = { arg = "ak2" },
    ["WEAPON_CARBINERIFLE"] = { arg = "m4a1" },
    ["WEAPON_CARBINERIFLE_MK2"] = { arg = "m4a4" },
    ["WEAPON_SPECIALCARBINE"] = { arg = "g36" },
    ["WEAPON_CERAMICPISTOL"] = { arg = "ceramic" },
    ["WEAPON_HEAVYPISTOL"] = { arg = "heavy" },
    ["WEAPON_GADGETPISTOL"] = { arg = "gadget" },
    ["WEAPON_DOUBLEACTION"] = { arg = "double" },
    ["WEAPON_MARKSMANPISTOL"] = { arg = "marks" },
    ["WEAPON_FLARE"] = { arg = "flare" },
    ["WEAPON_BZGAS"] = { arg = "gas" },
    ["WEAPON_MINIGUN"] = { arg = "gun" },
    ["WEAPON_STICKYBOMB"] = { arg = "bomb" },
    ["WEAPON_GRENADE"] = { arg = "grenade" },
    ["WEAPON_HEAVYSNIPER"] = { arg = "sniper" },
    ["WEAPON_MARKSMANRIFLE"] = { arg = "snipeer" },
    ["WEAPON_SNIPERRIFLE"] = { arg = "rifle" },
    ["WEAPON_MOLOTOV"] = { arg = "molotov" },
    ["WEAPON_GUSENBERG"] = { arg = "thompson" },
    ["WEAPON_PUMPSHOTGUN"] = { arg = "doze" },
    ["WEAPON_STUNGUN"] = { arg = "taser" },
}

RegisterCommand('arma',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,config.permSpawn) then
        if args[1] then
            for k,v in pairs(itemlist) do
                if v.arg == args[1] then
                    result = k
					SendWebhookMessage(config.webhookSpawn,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[PUXOU]: "..result.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."\r```")
                    vRPclient.giveWeapons(source,{[result] = { ammo = qtdAmmunition }})
                end
            end
        end
    end
end)

RegisterCommand('revistar',function(source,args,rawCommand)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local user_id = vRP.getUserId(source)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		TriggerClientEvent("EG:REVISTAR",source)
	else
		TriggerClientEvent("Notify",source,"negado","Não existem pessoas próximas de você para REVISTAR.")
	end
end)

local roubando = {}
local acaoRoubo = {}
function vRPN.closeRoubo()
	local source = source
	local user_id = vRP.getUserId(source)
	local nsource = vRP.getUserSource(roubando[user_id])
	TriggerClientEvent("EG:SENDOROUBADO",nsource,false)
	roubando[user_id] = nil
end

RegisterCommand('roubar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		local vida = vRPclient.getHealth(nplayer)
		if vida >= 1 then
			if vRP.request(nplayer,"Você está sendo roubado, deseja passar tudo?",30) then
				TriggerClientEvent("EG:ROUBAR",source)
				TriggerClientEvent("EG:SENDOROUBADO",nplayer,true)
				roubando[user_id] = nuser_id
				acaoRoubo[user_id] = 'ROUBOU'
				guardarArmas(nuser_id)
				local nmoney = vRP.getMoney(nuser_id)
				if vRP.tryPayment(nuser_id,nmoney) then
					vRP.giveMoney(user_id,nmoney)
					TriggerClientEvent("Notify",source,"aviso","Você roubou $ "..nmoney..".")
					TriggerClientEvent("Notify",nplayer,"aviso","Você teve todo seu dinheiro roubado.")
				end

				TriggerClientEvent("Notify",source,"aviso","Você está roubando o "..nIdentity.firstname..".")
				TriggerClientEvent("Notify",nplayer,"aviso","Você está sendo roubado.")
			else
				TriggerClientEvent("Notify",source,"negado","A pessoa está resistindo ao roubo.")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Não dá pra roubar pessoa morta.")
		end
	else
		TriggerClientEvent("Notify",source,"negado","Não existem pessoas próximas de você para ROUBAR.")
	end
end)

RegisterCommand('saquear',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		local vida = vRPclient.getHealth(nplayer)
		if vida < 1 then
			TriggerClientEvent("EG:ROUBAR",source)
			TriggerClientEvent("EG:SENDOROUBADO",nplayer,true)
			roubando[user_id] = nuser_id
			acaoRoubo[user_id] = 'SAQUEOU'
			guardarArmas(nuser_id)
			local nmoney = vRP.getMoney(nuser_id)
			if vRP.tryPayment(nuser_id,nmoney) then
				vRP.giveMoney(user_id,nmoney)
				TriggerClientEvent("Notify",source,"aviso","Você pegou $ "..nmoney..".")
			end
			TriggerClientEvent("Notify",source,"aviso","Você está saqueando o "..nIdentity.firstname..".")
		else
			TriggerClientEvent("Notify",source,"negado","Não dá pra saquear pessoa viva.")
		end
	else
		TriggerClientEvent("Notify",source,"negado","Não existem pessoas próximas de você para SAQUEAR.")
	end
end)

-- RegisterCommand('apreender',function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	local nplayer = vRPclient.getNearestPlayer(source,2)
-- 	local nuser_id = vRP.getUserId(nplayer)
-- 	if nuser_id then
-- 		if vRP.hasPermission(user_id, "policia.permissao") then
-- 			TriggerClientEvent("EG:ROUBAR",source)
-- 			TriggerClientEvent("EG:SENDOROUBADO",nplayer,true)
-- 			roubando[user_id] = nuser_id
-- 			acaoRoubo[user_id] = 'APREENDEU'
-- 			guardarArmas(nuser_id)
-- 			TriggerClientEvent("Notify",source,"aviso","Você está apreendendo o "..nIdentity.firstname..".")
-- 		else
-- 			TriggerClientEvent("Notify",source,"negado","Você não é um POLICIAL.")
-- 		end
-- 	else
-- 		TriggerClientEvent("Notify",source,"negado","Não existem pessoas próximas de você para APREENDER.")
-- 	end
-- end)

function vRPN.Roubar(item)
	local user_id = vRP.getUserId(source)
	if roubando[user_id] then
		local data = vRP.getUserDataTable(user_id)
		local nData = vRP.getUserDataTable(roubando[user_id])
		
		local identity = vRP.getUserIdentity(user_id)
		local nIdentity = vRP.getUserIdentity(roubando[user_id])

		if nData then
			if nData.inventory[item.item] then
				if nData.inventory[item.item].amount >= item.amount then
					if vRP.getInventoryWeight(user_id)+config.itemlist[item.item].peso*item.amount <= vRP.getInventoryMaxWeight(user_id) then
						if vRP.tryGetInventoryItem(roubando[user_id],item.item,item.amount) then
							vRP.giveInventoryItem(user_id,item.item,item.amount)
							SendWebhookMessage(config.webhookroubar,"```prolog\n[ID]: "..user_id.." - "..identity.name.." "..identity.firstname.."\n["..acaoRoubo[user_id].."]: "..roubando[user_id].." - "..nIdentity.name.." "..nIdentity.firstname.."\n[ITEMS]: "..item.amount.." - "..config.itemlist[item.item].nome..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						end
					else
						TriggerClientEvent("Notify",source,"negado","Mochila não suporta por causa do peso.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Quantidade Inválida.")
				end
			end
		end
	end
end

function vRPN.Revistar()
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,3)
	local nuser_id = vRP.getUserId(nplayer)

	local identity = vRP.getUserIdentity(user_id)
	local nIdentity = vRP.getUserIdentity(nuser_id)

	if nuser_id then
		local data = vRP.getUserDataTable(user_id)
		local nData = vRP.getUserDataTable(nuser_id)
		local inventario = {}
		local nInventario = {}

		if data then
			if data.inventory then
				for k,v in pairs(data.inventory) do
					table.insert(inventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k) })
				end
			end
			if data.weapons then
				for k,v in pairs(data.weapons) do
					if v.ammo == 0 then
						local aux = "wbody|"..k
						table.insert(inventario,{ amount = parseInt(1), name = vRP.itemNameList(aux), index = vRP.itemIndexList(aux), key = k, type = vRP.itemTypeList(aux), peso = vRP.getItemWeight(aux) })
					elseif v.ammo > 0 then
						local aux = "wbody|"..k
						table.insert(inventario,{ amount = parseInt(1), name = vRP.itemNameList(aux), index = vRP.itemIndexList(aux), key = k, type = vRP.itemTypeList(aux), peso = vRP.getItemWeight(aux) })
					end
				end
			end
		end

		if nData then
			if nData.inventory then
				for k,v in pairs(nData.inventory) do
					table.insert(nInventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k) })
				end
			end
			if nData.weapons then
				for k,v in pairs(nData.weapons) do
					if v.ammo == 0 then
						local aux = "wbody|"..k
						table.insert(nInventario,{ amount = parseInt(1), name = vRP.itemNameList(aux), index = vRP.itemIndexList(aux), key = k, type = vRP.itemTypeList(aux), peso = vRP.getItemWeight(aux) })
					elseif v.ammo > 0 then
						local aux = "wbody|"..k
						table.insert(nInventario,{ amount = parseInt(1), name = vRP.itemNameList(aux), index = vRP.itemIndexList(aux), key = k, type = vRP.itemTypeList(aux), peso = vRP.getItemWeight(aux) })
						local aux2 = "wammo|"..k
						table.insert(nInventario,{ amount = parseInt(v.ammo), name = vRP.itemNameList(aux2), index = vRP.itemIndexList(aux2), key = k, type = vRP.itemTypeList(aux2), peso = vRP.getItemWeight(aux2) })
					end
				end
			end
		end
		SendWebhookMessage(config.webhookrevistar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REVISTOU]: "..nuser_id.." "..nIdentity.name.." "..nIdentity.firstname..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		
		TriggerClientEvent("Notify",source,"aviso","Você está revistando.")
		TriggerClientEvent("Notify",nplayer,"aviso","Você está sendo revistado.")
		return inventario, nInventario
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--[ GARMAS ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local nation = Tunnel.getInterface("nation_paintball")
local wCooldown = {}


function guardarArmas(id)
	local source = vRP.getUserSource(id)
	local user_id = id
	if not network_delay[source] then
		network_delay[source] = true
		SetTimeout(3000, function()
			network_delay[source] = nil
		end)
		local identity = vRP.getUserIdentity(user_id)
		if config.nationPaintball then
			if nation.isInPaintball(source) then
				return
			end
		end
		if user_id then
			local weapons = vRPclient.replaceWeapons(source,{})
			for k,v in pairs(weapons) do
				if not config.policeItems[k] then 
					wCooldown[user_id] = 10
					vRP.giveInventoryItem(user_id,"wbody|"..k,1)
					if v.ammo > 0 then
						vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
					end
				end
			end
			garmas[user_id] = 10
			TriggerClientEvent('save:database',source)
			Wait(3000)
			wCooldown[user_id] = nil
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--[ ITEM ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('item',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,config.permSpawn) then
		if config.itemlist[args[1]] then
			if config.itemlist[args[1]].nome then
				if args[1] and args[2] and config.itemlist[args[1]].nome ~= nil then
					vRP.giveInventoryItem(user_id,args[1],parseInt(args[2]))
					local nomeItem = itemlist[args[1]]
					local quantItem = parseInt(args[2])	
					SendWebhookMessage(config.webhookSpawn,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[PEGOU]: "..args[1].." \n[QUANTIDADE]: "..vRP.format(parseInt(args[2])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end
			end
		end
	end
end)