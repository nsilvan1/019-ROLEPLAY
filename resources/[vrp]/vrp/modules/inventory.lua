local Proxy = module("vrp","lib/Proxy")
local inventario = Proxy.getInterface('nxgroup_inventario')

local Tunnel = module("vrp","lib/Tunnel")
local arena = Tunnel.getInterface("nxgroup_arena")

local cfg = module("cfg/car")

local webhookrevi = "https://discord.com/api/webhooks/1058419279592173680/HaVL_RAZ4YWseMaffNNUzQn0QkI6t02Ec76qvCdm1P5VaDOBLbkz4UKiocZcdGwWo7Sv"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function vRP.itemNameList(item)
	if item ~= nil then
		return exports['nxgroup_inventario']:get_name_list(item)
	end
end

function vRP.itemIndexList(item)
	if item ~= nil then
		return exports['nxgroup_inventario']:get_index_item(item)
	end
end

function vRP.itemTypeList(item)
	if item ~= nil then
		return exports['nxgroup_inventario']:get_type_item(item)
	end
end

function vRP.itemBodyList(item)
	if item ~= nil then
		return exports['nxgroup_inventario']:get_info_item(item)
	end
end

function vRP.getItemDefinition(idname)
	return exports['nxgroup_inventario']:get_name_peso(idname)
end

-- function vRP.itemNameList(item)
-- 	return inventario.get_name_list(item)
-- end

-- function vRP.itemIndexList(item)
-- 	return inventario.get_index_item(item)
-- end

-- function vRP.itemTypeList(item)
-- 	return inventario.get_type_item(item)
-- end

-- function vRP.itemBodyList(item)
-- 	return inventario.get_info_item(item)
-- end

vRP.items = {}
function vRP.defInventoryItem(idname,name,weight)
	if weight == nil then
		weight = 0
	end
	local item = { name = name, weight = weight }
	vRP.items[idname] = item
end

function vRP.computeItemName(item,args)
	if type(item.name) == "string" then
		return item.name
	else
		return item.name(args)
	end
end

function vRP.computeItemWeight(item,args)
	if type(item.weight) == "number" then
		return item.weight
	else
		return item.weight(args)
	end
end

function vRP.parseItem(idname)
	return splitString(idname,"|")
end

function vRP.getItemDefinition(idname)
	inventario.get_name_peso(item)
end

function vRP.getItemWeight(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[idname]
	if item then
		return vRP.computeItemWeight(item)
	end
	return 0
end

function vRP.computeItemsWeight(items)
	local weight = 0
	for k,v in pairs(items) do
		local iweight = vRP.getItemWeight(k)
		weight = weight+iweight*v.amount
	end
	return weight
end

function vRP.computeItemsWeight(items)
	local weight = 0
	for k,v in pairs(items) do
		local iweight = vRP.getItemWeight(k)
		weight = weight+iweight*v.amount
	end
	return weight
end

function vRP.giveInventoryItem(user_id,idname,amount)
	local source = vRP.getUserSource(user_id)

	if source then
		if arena.inArena(source) then
			return
		end
	end
	
	if source then
		local amount = parseInt(amount)
		local data = vRP.getUserDataTable(user_id)
		if data and amount > 0 then
			local entry = data.inventory[idname]
			if entry then
				entry.amount = entry.amount + amount
			else
				data.inventory[idname] = { amount = amount }
			end
		end
	end
	TriggerClientEvent('nyo_notifyItem',source,idname,idname,amount,'#000fff',3000)
end

function vRP.tryGetInventoryItem(user_id,idname,amount)
	local amount = parseInt(amount)
	local data = vRP.getUserDataTable(user_id)
	if data and amount > 0 then
		local entry = data.inventory[idname]
		if entry and entry.amount >= amount then
			entry.amount = entry.amount - amount

			if entry.amount <= 0 then
				data.inventory[idname] = nil
			end
			
			local source = vRP.getUserSource(user_id)
			TriggerClientEvent('nyo_notifyItem',source,idname,idname,amount,'#000fff',3000)
			return true
		end
	end
	return false
end

function vRP.getInventoryItemAmount(user_id,idname)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		local entry = data.inventory[idname]
		if entry then
			return entry.amount
		end
	end
	return 0
end

function vRP.clearInventory(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		data.inventory = {}
		data.weapons = {}
	end
end

function vRP.getInventory(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		return data.inventory
	end
end

function vRP.getInventoryWeight(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		return vRP.computeItemsWeight(data.inventory)
	end
	return 0
end

function vRP.getInventoryMaxWeight(user_id)
	return math.floor(vRP.expToLevel(vRP.getExp(user_id,"physical","strength")))*3
end

RegisterServerEvent("clearInventory")
AddEventHandler("clearInventory",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local data = vRP.getUserDataTable(user_id)
        if data then
            data.inventory = {}
			data.weapons = {}
        end

        vRP.setMoney(user_id,0)
        vRPclient._clearWeapons(source)
        vRPclient._setHandcuffed(source,false)
		
        if not vRP.hasPermission(user_id,"mochila.permissao") then
            vRP.setExp(user_id,"physical","strength",20)
        end
    end
end)

AddEventHandler("vRP:playerJoin", function(user_id,source,name)
	local data = vRP.getUserDataTable(user_id)
	if not data.inventory then
		data.inventory = {}
	end
end)

local chests = {}
local function build_itemlist_menu(name,items,cb)
	local menu = { name = name }
	local kitems = {}

	local choose = function(player,choice)
		local idname = kitems[choice]
		if idname then
			cb(idname)
		end
	end

	for k,v in pairs(items) do 
		local name,weight = vRP.getItemDefinition(k)
		if name then
			kitems[name] = k
			menu[name] = { choose,"<text01>Quantidade:</text01> <text02>"..v.amount.."</text02><text01>Peso:</text01> <text02>"..string.format("%.2f",weight).."kg</text02>" }
		end
	end

	return menu
end

function vRP.vehicleGlobal()
	return car.vehList
end

--[ VEHICLENAME ]---------------------------------------------------------------------------------------------------------------------------------------

function vRP.vehicleName(vname)
	return car.vehList[vname].name
end

--[ VEHICLECHEST ]--------------------------------------------------------------------------------------------------------------------------------------

function vRP.vehicleChest(vname)
	return car.vehList[vname].capacidade
end

--[ VEHICLEPRICE ]--------------------------------------------------------------------------------------------------------------------------------------

function vRP.vehiclePrice(vname)
	return car.vehList[vname].price
end

--[ VEHICLETYPE ]---------------------------------------------------------------------------------------------------------------------------------------

function vRP.vehicleType(vname)
	return car.vehList[vname].tipo
end

function vRP.vehicleModel(vname)
	return car.vehList[vname].modelo
end


function vRP.limparArmas(user_id) -- COLOCAR ISSO DENTRO DE QUALQUER VRP>MODULES [ CASO SUA FUNÇÃO forceClearWeapons for ativada ]
	local data = vRP.getUserDataTable(user_id)
	if user_id then
		if data then
			data.weapons = {}
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
local vehglobal = {
	["blista"] = { ['name'] = "Blista", ['price'] = 60000, ['tipo'] = "carros" },
	["brioso"] = { ['name'] = "Brioso", ['price'] = 35000, ['tipo'] = "carros" },
	["emperor"] = { ['name'] = "Emperor", ['price'] = 50000, ['tipo'] = "carros" },
	["emperor2"] = { ['name'] = "Emperor 2", ['price'] = 50000, ['tipo'] = "carros" },
	["dilettante"] = { ['name'] = "Dilettante", ['price'] = 60000, ['tipo'] = "carros" },
	["issi2"] = { ['name'] = "Issi2", ['price'] = 90000, ['tipo'] = "carros" },
	["panto"] = { ['name'] = "Panto", ['price'] = 5000, ['tipo'] = "carros" },
	["prairie"] = { ['name'] = "Prairie", ['price'] = 1000, ['tipo'] = "carros" },
	["rhapsody"] = { ['name'] = "Rhapsody", ['price'] = 7000, ['tipo'] = "carros" },
	["cogcabrio"] = { ['name'] = "Cogcabrio", ['price'] = 130000, ['tipo'] = "carros" },
	["exemplar"] = { ['name'] = "Exemplar", ['price'] = 80000, ['tipo'] = "carros" },
	["f620"] = { ['name'] = "F620", ['price'] = 55000, ['tipo'] = "carros" },
	["felon"] = { ['name'] = "Felon", ['price'] = 70000, ['tipo'] = "carros" },
	["ingot"] = { ['name'] = "Ingot", ['price'] = 160000, ['tipo'] = "carros" },
	["jackal"] = { ['name'] = "Jackal", ['price'] = 60000, ['tipo'] = "carros" },
	["oracle"] = { ['name'] = "Oracle", ['price'] = 60000, ['tipo'] = "carros" },
	["oracle2"] = { ['name'] = "Oracle2", ['price'] = 80000, ['tipo'] = "carros" },
	["sentinel"] = { ['name'] = "Sentinel", ['price'] = 50000, ['tipo'] = "carros" },
	["sentinel2"] = { ['name'] = "Sentinel2", ['price'] = 60000, ['tipo'] = "carros" },
	["windsor"] = { ['name'] = "Windsor", ['price'] = 150000, ['tipo'] = "carros" },
	["windsor2"] = { ['name'] = "Windsor2", ['price'] = 170000, ['tipo'] = "carros" },
	["zion"] = { ['name'] = "Zion", ['price'] = 50000, ['tipo'] = "carros" },
	["zion2"] = { ['name'] = "Zion2", ['price'] = 60000, ['tipo'] = "carros" },
	["blade"] = { ['name'] = "Blade", ['price'] = 110000, ['tipo'] = "carros" },
	["buccaneer"] = { ['name'] = "Buccaneer", ['price'] = 130000, ['tipo'] = "carros" },
	["buccaneer2"] = { ['name'] = "Buccaneer2", ['price'] = 260000, ['tipo'] = "carros" },
	["primo"] = { ['name'] = "Primo", ['price'] = 130000, ['tipo'] = "carros" },
	["chino"] = { ['name'] = "Chino", ['price'] = 130000, ['tipo'] = "carros" },
	["coquette3"] = { ['name'] = "Coquette3", ['price'] = 195000, ['tipo'] = "carros" },
	["dukes"] = { ['name'] = "Dukes", ['price'] = 150000, ['tipo'] = "carros" },
	["faction"] = { ['name'] = "Faction", ['price'] = 150000, ['tipo'] = "carros" },
	["faction3"] = { ['name'] = "Faction3", ['price'] = 350000, ['tipo'] = "carros" },
	["gauntlet"] = { ['name'] = "Gauntlet", ['price'] = 165000, ['tipo'] = "carros" },
	["gauntlet2"] = { ['name'] = "Gauntlet2", ['price'] = 165000, ['tipo'] = "carros" },
	["hermes"] = { ['name'] = "Hermes", ['price'] = 280000, ['tipo'] = "carros" },
	["hotknife"] = { ['name'] = "Hotknife", ['price'] = 180000, ['tipo'] = "carros" },
	["moonbeam"] = { ['name'] = "Moonbeam", ['price'] = 220000, ['tipo'] = "carros" },
	["moonbeam2"] = { ['name'] = "Moonbeam2", ['price'] = 250000, ['tipo'] = "carros" },
	["nightshade"] = { ['name'] = "Nightshade", ['price'] = 270000, ['tipo'] = "carros" },
	["picador"] = { ['name'] = "Picador", ['price'] = 150000, ['tipo'] = "carros" },
	["ruiner"] = { ['name'] = "Ruiner", ['price'] = 150000, ['tipo'] = "carros" },
	["sabregt"] = { ['name'] = "Sabregt", ['price'] = 260000, ['tipo'] = "carros" },
	["sabregt2"] = { ['name'] = "Sabregt2", ['price'] = 150000, ['tipo'] = "carros" },
	["slamvan"] = { ['name'] = "Slamvan", ['price'] = 180000, ['tipo'] = "carros" },
	["slamvan3"] = { ['name'] = "Slamvan3", ['price'] = 230000, ['tipo'] = "carros" },
	["stalion"] = { ['name'] = "Stalion", ['price'] = 150000, ['tipo'] = "carros" },
	["stalion2"] = { ['name'] = "Stalion2", ['price'] = 150000, ['tipo'] = "carros" },
	["tampa"] = { ['name'] = "Tampa", ['price'] = 170000, ['tipo'] = "carros" },
	["vigero"] = { ['name'] = "Vigero", ['price'] = 170000, ['tipo'] = "carros" },
	["virgo"] = { ['name'] = "Virgo", ['price'] = 150000, ['tipo'] = "carros" },
	["virgo2"] = { ['name'] = "Virgo2", ['price'] = 250000, ['tipo'] = "carros" },
	["virgo3"] = { ['name'] = "Virgo3", ['price'] = 180000, ['tipo'] = "carros" },
	["voodoo"] = { ['name'] = "Voodoo", ['price'] = 220000, ['tipo'] = "carros" },
	["voodoo2"] = { ['name'] = "Voodoo2", ['price'] = 220000, ['tipo'] = "carros" },
	["yosemite"] = { ['name'] = "Yosemite", ['price'] = 350000, ['tipo'] = "carros" },
	["bfinjection"] = { ['name'] = "Bfinjection", ['price'] = 80000, ['tipo'] = "carros" },
	["bifta"] = { ['name'] = "Bifta", ['price'] = 190000, ['tipo'] = "carros" },
	["bodhi2"] = { ['name'] = "Bodhi2", ['price'] = 170000, ['tipo'] = "carros" },
	["brawler"] = { ['name'] = "Brawler", ['price'] = 250000, ['tipo'] = "carros" },
	["trophytruck"] = { ['name'] = "Trophytruck", ['price'] = 400000, ['tipo'] = "carros" },
	["trophytruck2"] = { ['name'] = "Trophytruck2", ['price'] = 400000, ['tipo'] = "carros" },
	["dubsta3"] = { ['name'] = "Dubsta3", ['price'] = 300000, ['tipo'] = "carros" },
	["mesa3"] = { ['name'] = "Mesa3", ['price'] = 200000, ['tipo'] = "carros" },
	["rancherxl"] = { ['name'] = "Rancherxl", ['price'] = 220000, ['tipo'] = "carros" },
	["rebel2"] = { ['name'] = "Rebel2", ['price'] = 250000, ['tipo'] = "carros" },
	["riata"] = { ['name'] = "Riata", ['price'] = 250000, ['tipo'] = "carros" },
	["dloader"] = { ['name'] = "Dloader", ['price'] = 150000, ['tipo'] = "carros" },
	["sandking"] = { ['name'] = "Sandking", ['price'] = 400000, ['tipo'] = "carros" },
	["sandking2"] = { ['name'] = "Sandking2", ['price'] = 370000, ['tipo'] = "carros" },
	["baller"] = { ['name'] = "Baller", ['price'] = 150000, ['tipo'] = "carros" },
	["baller2"] = { ['name'] = "Baller2", ['price'] = 160000, ['tipo'] = "carros" },
	["baller3"] = { ['name'] = "Baller3", ['price'] = 175000, ['tipo'] = "carros" },
	["baller4"] = { ['name'] = "Baller4", ['price'] = 185000, ['tipo'] = "carros" },
	["baller5"] = { ['name'] = "Baller5", ['price'] = 270000, ['tipo'] = "carros" },
	["baller6"] = { ['name'] = "Baller6", ['price'] = 280000, ['tipo'] = "carros" },
	["bjxl"] = { ['name'] = "Bjxl", ['price'] = 110000, ['tipo'] = "carros" },
	["cavalcade"] = { ['name'] = "Cavalcade", ['price'] = 110000, ['tipo'] = "carros" },
	["cavalcade2"] = { ['name'] = "Cavalcade2", ['price'] = 130000, ['tipo'] = "carros" },
	["contender"] = { ['name'] = "Contender", ['price'] = 300000, ['tipo'] = "carros" },
	["dubsta"] = { ['name'] = "Dubsta", ['price'] = 210000, ['tipo'] = "carros" },
	["dubsta2"] = { ['name'] = "Dubsta2", ['price'] = 240000, ['tipo'] = "carros" },
	["fq2"] = { ['name'] = "Fq2", ['price'] = 110000, ['tipo'] = "carros" },
	["granger"] = { ['name'] = "Granger", ['price'] = 345000, ['tipo'] = "carros" },
	["gresley"] = { ['name'] = "Gresley", ['price'] = 150000, ['tipo'] = "carros" },
	["habanero"] = { ['name'] = "Habanero", ['price'] = 110000, ['tipo'] = "carros" },
	["seminole"] = { ['name'] = "Seminole", ['price'] = 110000, ['tipo'] = "carros" },
	["serrano"] = { ['name'] = "Serrano", ['price'] = 150000, ['tipo'] = "carros" },
	["xls"] = { ['name'] = "Xls", ['price'] = 150000, ['tipo'] = "carros" },
	["xls2"] = { ['name'] = "Xls2", ['price'] = 350000, ['tipo'] = "carros" },
	["asea"] = { ['name'] = "Asea", ['price'] = 55000, ['tipo'] = "carros" },
	["asterope"] = { ['name'] = "Asterope", ['price'] = 65000, ['tipo'] = "carros" },
	["cog552"] = { ['name'] = "Cog552", ['price'] = 400000, ['tipo'] = "carros" },
	["cognoscenti"] = { ['name'] = "Cognoscenti", ['price'] = 280000, ['tipo'] = "carros" },
	["cognoscenti2"] = { ['name'] = "Cognoscenti2", ['price'] = 400000, ['tipo'] = "carros" },
	["stanier"] = { ['name'] = "Stanier", ['price'] = 60000, ['tipo'] = "carros" },
	["stratum"] = { ['name'] = "Stratum", ['price'] = 90000, ['tipo'] = "carros" },
	["surge"] = { ['name'] = "Surge", ['price'] = 110000, ['tipo'] = "carros" },
	["tailgater"] = { ['name'] = "Tailgater", ['price'] = 110000, ['tipo'] = "carros" },
	["warrener"] = { ['name'] = "Warrener", ['price'] = 90000, ['tipo'] = "carros" },
	["washington"] = { ['name'] = "Washington", ['price'] = 130000, ['tipo'] = "carros" },
	["alpha"] = { ['name'] = "Alpha", ['price'] = 230000, ['tipo'] = "carros" },
	["banshee"] = { ['name'] = "Banshee", ['price'] = 300000, ['tipo'] = "carros" },
	["bestiagts"] = { ['name'] = "Bestiagts", ['price'] = 290000, ['tipo'] = "carros" },
	["blista2"] = { ['name'] = "Blista2", ['price'] = 55000, ['tipo'] = "carros" },
	["blista3"] = { ['name'] = "Blista3", ['price'] = 80000, ['tipo'] = "carros" },
	["buffalo"] = { ['name'] = "Buffalo", ['price'] = 300000, ['tipo'] = "carros" },
	["buffalo2"] = { ['name'] = "Buffalo2", ['price'] = 300000, ['tipo'] = "carros" },
	["buffalo3"] = { ['name'] = "Buffalo3", ['price'] = 300000, ['tipo'] = "carros" },
	["carbonizzare"] = { ['name'] = "Carbonizzare", ['price'] = 290000, ['tipo'] = "carros" },
	["comet2"] = { ['name'] = "Comet2", ['price'] = 250000, ['tipo'] = "carros" },
	["comet3"] = { ['name'] = "Comet3", ['price'] = 290000, ['tipo'] = "carros" },
	["comet5"] = { ['name'] = "Comet5", ['price'] = 300000, ['tipo'] = "carros" },
	["coquette"] = { ['name'] = "Coquette", ['price'] = 250000, ['tipo'] = "carros" },
	["elegy"] = { ['name'] = "Elegy", ['price'] = 350000, ['tipo'] = "carros" },
	["elegy2"] = { ['name'] = "Elegy2", ['price'] = 355000, ['tipo'] = "carros" },
	["feltzer2"] = { ['name'] = "Feltzer2", ['price'] = 255000, ['tipo'] = "carros" },
	["furoregt"] = { ['name'] = "Furoregt", ['price'] = 290000, ['tipo'] = "carros" },
	["fusilade"] = { ['name'] = "Fusilade", ['price'] = 210000, ['tipo'] = "carros" },
	["futo"] = { ['name'] = "Futo", ['price'] = 170000, ['tipo'] = "carros" },
	["jester"] = { ['name'] = "Jester", ['price'] = 150000, ['tipo'] = "carros" },
	["khamelion"] = { ['name'] = "Khamelion", ['price'] = 210000, ['tipo'] = "carros" },
	["kuruma"] = { ['name'] = "Kuruma", ['price'] = 330000, ['tipo'] = "carros" },
	["massacro"] = { ['name'] = "Massacro", ['price'] = 330000, ['tipo'] = "carros" },
	["massacro2"] = { ['name'] = "Massacro2", ['price'] = 330000, ['tipo'] = "carros" },
	["ninef"] = { ['name'] = "Ninef", ['price'] = 290000, ['tipo'] = "carros" },
	["ninef2"] = { ['name'] = "Ninef2", ['price'] = 290000, ['tipo'] = "carros" },
	["omnis"] = { ['name'] = "Omnis", ['price'] = 240000, ['tipo'] = "carros" },
	["pariah"] = { ['name'] = "Pariah", ['price'] = 500000, ['tipo'] = "carros" },
	["penumbra"] = { ['name'] = "Penumbra", ['price'] = 150000, ['tipo'] = "carros" },
	["raiden"] = { ['name'] = "Raiden", ['price'] = 240000, ['tipo'] = "carros" },
	["rapidgt"] = { ['name'] = "Rapidgt", ['price'] = 250000, ['tipo'] = "carros" },
	["rapidgt2"] = { ['name'] = "Rapidgt2", ['price'] = 300000, ['tipo'] = "carros" },
	["ruston"] = { ['name'] = "Ruston", ['price'] = 370000, ['tipo'] = "carros" },
	["schafter3"] = { ['name'] = "Schafter3", ['price'] = 275000, ['tipo'] = "carros" },
	["schafter4"] = { ['name'] = "Schafter4", ['price'] = 275000, ['tipo'] = "carros" },
	["schafter5"] = { ['name'] = "Schafter5", ['price'] = 275000, ['tipo'] = "carros" },
	["schwarzer"] = { ['name'] = "Schwarzer", ['price'] = 170000, ['tipo'] = "carros" },
	["sentinel3"] = { ['name'] = "Sentinel3", ['price'] = 170000, ['tipo'] = "carros" },
	["seven70"] = { ['name'] = "Seven70", ['price'] = 370000, ['tipo'] = "carros" },
	["specter"] = { ['name'] = "Specter", ['price'] = 320000, ['tipo'] = "carros" },
	["specter2"] = { ['name'] = "Specter2", ['price'] = 355000, ['tipo'] = "carros" },
	["streiter"] = { ['name'] = "Streiter", ['price'] = 250000, ['tipo'] = "carros" },
	["sultan"] = { ['name'] = "Sultan", ['price'] = 210000, ['tipo'] = "carros" },
	["surano"] = { ['name'] = "Surano", ['price'] = 310000, ['tipo'] = "carros" },
	["tampa2"] = { ['name'] = "Tampa2", ['price'] = 200000, ['tipo'] = "carros" },
	["tropos"] = { ['name'] = "Tropos", ['price'] = 170000, ['tipo'] = "carros" },
	["verlierer2"] = { ['name'] = "Verlierer2", ['price'] = 380000, ['tipo'] = "carros" },
	["btype2"] = { ['name'] = "Btype2", ['price'] = 460000, ['tipo'] = "carros" },
	["btype3"] = { ['name'] = "Btype3", ['price'] = 390000, ['tipo'] = "work" },
	["hustler"] = { ['name'] = "Hustler", ['price'] = 390000, ['tipo'] = "work" },
	["casco"] = { ['name'] = "Casco", ['price'] = 355000, ['tipo'] = "carros" },
	["cheetah"] = { ['name'] = "Cheetah", ['price'] = 425000, ['tipo'] = "carros" },
	["coquette2"] = { ['name'] = "Coquette2", ['price'] = 285000, ['tipo'] = "carros" },
	["feltzer3"] = { ['name'] = "Feltzer3", ['price'] = 220000, ['tipo'] = "carros" },
	["gt500"] = { ['name'] = "Gt500", ['price'] = 250000, ['tipo'] = "carros" },
	["infernus2"] = { ['name'] = "Infernus2", ['price'] = 250000, ['tipo'] = "carros" },
	["jb700"] = { ['name'] = "Jb700", ['price'] = 220000, ['tipo'] = "carros" },
	["mamba"] = { ['name'] = "Mamba", ['price'] = 300000, ['tipo'] = "carros" },
	["manana"] = { ['name'] = "Manana", ['price'] = 130000, ['tipo'] = "carros" },
	["monroe"] = { ['name'] = "Monroe", ['price'] = 260000, ['tipo'] = "carros" },
	["peyote"] = { ['name'] = "Peyote", ['price'] = 150000, ['tipo'] = "carros" },
	["pigalle"] = { ['name'] = "Pigalle", ['price'] = 250000, ['tipo'] = "carros" },
	["rapidgt3"] = { ['name'] = "Rapidgt3", ['price'] = 220000, ['tipo'] = "carros" },
	["retinue"] = { ['name'] = "Retinue", ['price'] = 150000, ['tipo'] = "carros" },
	["stinger"] = { ['name'] = "Stinger", ['price'] = 220000, ['tipo'] = "carros" },
	["stingergt"] = { ['name'] = "Stingergt", ['price'] = 230000, ['tipo'] = "carros" },
	["torero"] = { ['name'] = "Torero", ['price'] = 160000, ['tipo'] = "carros" },
	["tornado"] = { ['name'] = "Tornado", ['price'] = 150000, ['tipo'] = "carros" },
	["tornado2"] = { ['name'] = "Tornado2", ['price'] = 160000, ['tipo'] = "carros" },
	["tornado6"] = { ['name'] = "Tornado6", ['price'] = 250000, ['tipo'] = "carros" },
	["turismo2"] = { ['name'] = "Turismo2", ['price'] = 250000, ['tipo'] = "carros" },
	["ztype"] = { ['name'] = "Ztype", ['price'] = 400000, ['tipo'] = "carros" },
	["adder"] = { ['name'] = "Adder", ['price'] = 620000, ['tipo'] = "carros" },
	["tigerpolicia"] = { ['name'] = "Tiger Policia", ['price'] = 620000, ['tipo'] = "motos" },
	["autarch"] = { ['name'] = "Autarch", ['price'] = 760000, ['tipo'] = "carros" },
	["banshee2"] = { ['name'] = "Banshee2", ['price'] = 370000, ['tipo'] = "carros" },
	["bullet"] = { ['name'] = "Bullet", ['price'] = 400000, ['tipo'] = "carros" },
	["cheetah2"] = { ['name'] = "Cheetah2", ['price'] = 240000, ['tipo'] = "carros" },
	["entityxf"] = { ['name'] = "Entityxf", ['price'] = 460000, ['tipo'] = "carros" },
	["fmj"] = { ['name'] = "Fmj", ['price'] = 520000, ['tipo'] = "carros" },
	["gp1"] = { ['name'] = "Gp1", ['price'] = 495000, ['tipo'] = "carros" },
	["infernus"] = { ['name'] = "Infernus", ['price'] = 470000, ['tipo'] = "carros" },
	["nero"] = { ['name'] = "Nero", ['price'] = 450000, ['tipo'] = "carros" },
	["nero2"] = { ['name'] = "Nero2", ['price'] = 480000, ['tipo'] = "carros" },
	["osiris"] = { ['name'] = "Osiris", ['price'] = 460000, ['tipo'] = "carros" },
	["penetrator"] = { ['name'] = "Penetrator", ['price'] = 480000, ['tipo'] = "carros" },
	["pfister811"] = { ['name'] = "Pfister811", ['price'] = 530000, ['tipo'] = "carros" },
	["reaper"] = { ['name'] = "Reaper", ['price'] = 620000, ['tipo'] = "carros" },
	["sc1"] = { ['name'] = "Sc1", ['price'] = 495000, ['tipo'] = "carros" },
	["sultanrs"] = { ['name'] = "Sultan RS", ['price'] = 450000, ['tipo'] = "carros" },
	["t20"] = { ['name'] = "T20", ['price'] = 670000, ['tipo'] = "carros" },
	["tempesta"] = { ['name'] = "Tempesta", ['price'] = 600000, ['tipo'] = "carros" },
	["turismor"] = { ['name'] = "Turismor", ['price'] = 620000, ['tipo'] = "carros" },
	["tyrus"] = { ['name'] = "Tyrus", ['price'] = 620000, ['tipo'] = "carros" },
	["vacca"] = { ['name'] = "Vacca", ['price'] = 620000, ['tipo'] = "carros" },
	["visione"] = { ['name'] = "Visione", ['price'] = 690000, ['tipo'] = "carros" },
	["voltic"] = { ['name'] = "Voltic", ['price'] = 440000, ['tipo'] = "carros" },
	["zentorno"] = { ['name'] = "Zentorno", ['price'] = 920000, ['tipo'] = "carros" },
	["sadler"] = { ['name'] = "Sadler", ['price'] = 180000, ['tipo'] = "carros" },
	["bison"] = { ['name'] = "Bison", ['price'] = 220000, ['tipo'] = "carros" },
	["bison2"] = { ['name'] = "Bison2", ['price'] = 180000, ['tipo'] = "carros" },
	["bobcatxl"] = { ['name'] = "Bobcatxl", ['price'] = 260000, ['tipo'] = "carros" },
	["burrito"] = { ['name'] = "Burrito", ['price'] = 260000, ['tipo'] = "carros" },
	["burrito2"] = { ['name'] = "Burrito2", ['price'] = 260000, ['tipo'] = "carros" },
	["burrito3"] = { ['name'] = "Burrito3", ['price'] = 260000, ['tipo'] = "carros" },
	["burrito4"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros" },
	["mule4"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros" },
	["rallytruck"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros" },
	["minivan"] = { ['name'] = "Minivan", ['price'] = 110000, ['tipo'] = "carros" },
	["minivan2"] = { ['name'] = "Minivan2", ['price'] = 220000, ['tipo'] = "carros" },
	["paradise"] = { ['name'] = "Paradise", ['price'] = 260000, ['tipo'] = "carros" },
	["pony"] = { ['name'] = "Pony", ['price'] = 260000, ['tipo'] = "carros" },
	["pony2"] = { ['name'] = "Pony2", ['price'] = 260000, ['tipo'] = "carros" },
	["rumpo"] = { ['name'] = "Rumpo", ['price'] = 260000, ['tipo'] = "carros" },
	["rumpo2"] = { ['name'] = "Rumpo2", ['price'] = 260000, ['tipo'] = "carros" },
	["rumpo3"] = { ['name'] = "Rumpo3", ['price'] = 350000, ['tipo'] = "carros" },
	["surfer"] = { ['name'] = "Surfer", ['price'] = 55000, ['tipo'] = "carros" },
	["youga"] = { ['name'] = "Youga", ['price'] = 260000, ['tipo'] = "carros" },
	["huntley"] = { ['name'] = "Huntley", ['price'] = 110000, ['tipo'] = "carros" },
	["landstalker"] = { ['name'] = "Landstalker", ['price'] = 130000, ['tipo'] = "carros" },
	["mesa"] = { ['name'] = "Mesa", ['price'] = 90000, ['tipo'] = "carros" },
	["patriot"] = { ['name'] = "Patriot", ['price'] = 250000, ['tipo'] = "carros" },
	["radi"] = { ['name'] = "Radi", ['price'] = 110000, ['tipo'] = "carros" },
	["rocoto"] = { ['name'] = "Rocoto", ['price'] = 110000, ['tipo'] = "carros" },
	["tyrant"] = { ['name'] = "Tyrant", ['price'] = 690000, ['tipo'] = "carros" },
	["entity2"] = { ['name'] = "Entity2", ['price'] = 550000, ['tipo'] = "carros" },
	["cheburek"] = { ['name'] = "Cheburek", ['price'] = 170000, ['tipo'] = "carros" },
	["hotring"] = { ['name'] = "Hotring", ['price'] = 300000, ['tipo'] = "carros" },
	["jester3"] = { ['name'] = "Jester3", ['price'] = 345000, ['tipo'] = "carros" },
	["flashgt"] = { ['name'] = "Flashgt", ['price'] = 370000, ['tipo'] = "carros" },
	["ellie"] = { ['name'] = "Ellie", ['price'] = 320000, ['tipo'] = "carros" },
	["michelli"] = { ['name'] = "Michelli", ['price'] = 160000, ['tipo'] = "carros" },
	["fagaloa"] = { ['name'] = "Fagaloa", ['price'] = 320000, ['tipo'] = "carros" },
	["dominator"] = { ['name'] = "Dominator", ['price'] = 230000, ['tipo'] = "carros" },
	["dominator2"] = { ['name'] = "Dominator2", ['price'] = 230000, ['tipo'] = "carros" },
	["dominator3"] = { ['name'] = "Dominator3", ['price'] = 370000, ['tipo'] = "carros" },
	["issi3"] = { ['name'] = "Issi3", ['price'] = 190000, ['tipo'] = "carros" },
	["taipan"] = { ['name'] = "Taipan", ['price'] = 620000, ['tipo'] = "carros" },
	["gb200"] = { ['name'] = "Gb200", ['price'] = 195000, ['tipo'] = "carros" },
	["stretch"] = { ['name'] = "Stretch", ['price'] = 520000, ['tipo'] = "carros" },
	["guardian"] = { ['name'] = "Guardian", ['price'] = 540000, ['tipo'] = "carros" },
	["kamacho"] = { ['name'] = "Kamacho", ['price'] = 460000, ['tipo'] = "carros" },
	["neon"] = { ['name'] = "Neon", ['price'] = 370000, ['tipo'] = "carros" },
	["cyclone"] = { ['name'] = "Cyclone", ['price'] = 920000, ['tipo'] = "carros" },
	["italigtb"] = { ['name'] = "Italigtb", ['price'] = 600000, ['tipo'] = "carros" },
	["italigtb2"] = { ['name'] = "Italigtb2", ['price'] = 610000, ['tipo'] = "carros" },
	["vagner"] = { ['name'] = "Vagner", ['price'] = 680000, ['tipo'] = "carros" },
	["xa21"] = { ['name'] = "Xa21", ['price'] = 630000, ['tipo'] = "carros" },
	["tezeract"] = { ['name'] = "Tezeract", ['price'] = 920000, ['tipo'] = "carros" },
	["prototipo"] = { ['name'] = "Prototipo", ['price'] = 1030000, ['tipo'] = "carros" },
	["patriot2"] = { ['name'] = "Patriot2", ['price'] = 550000, ['tipo'] = "carros" },
	["swinger"] = { ['name'] = "Swinger", ['price'] = 250000, ['tipo'] = "carros" },
	["clique"] = { ['name'] = "Clique", ['price'] = 360000, ['tipo'] = "carros" },
	["deveste"] = { ['name'] = "Deveste", ['price'] = 920000, ['tipo'] = "carros" },
	["deviant"] = { ['name'] = "Deviant", ['price'] = 370000, ['tipo'] = "carros" },
	["impaler"] = { ['name'] = "Impaler", ['price'] = 320000, ['tipo'] = "carros" },
	["italigto"] = { ['name'] = "Italigto", ['price'] = 800000, ['tipo'] = "carros" },
	["schlagen"] = { ['name'] = "Schlagen", ['price'] = 690000, ['tipo'] = "carros" },
	["toros"] = { ['name'] = "Toros", ['price'] = 520000, ['tipo'] = "carros" },
	["tulip"] = { ['name'] = "Tulip", ['price'] = 320000, ['tipo'] = "carros" },
	["vamos"] = { ['name'] = "Vamos", ['price'] = 320000, ['tipo'] = "carros" },
	["freecrawler"] = { ['name'] = "Freecrawler", ['price'] = 350000, ['tipo'] = "carros" },
	["fugitive"] = { ['name'] = "Fugitive", ['price'] = 50000, ['tipo'] = "carros" },
	["glendale"] = { ['name'] = "Glendale", ['price'] = 70000, ['tipo'] = "carros" },
	["intruder"] = { ['name'] = "Intruder", ['price'] = 60000, ['tipo'] = "carros" },
	["le7b"] = { ['name'] = "Le7b", ['price'] = 700000, ['tipo'] = "carros" },
	["lurcher"] = { ['name'] = "Lurcher", ['price'] = 150000, ['tipo'] = "carros" },
	["lynx"] = { ['name'] = "Lynx", ['price'] = 370000, ['tipo'] = "carros" },
	["phoenix"] = { ['name'] = "Phoenix", ['price'] = 250000, ['tipo'] = "carros" },
	["premier"] = { ['name'] = "Premier", ['price'] = 35000, ['tipo'] = "carros" },
	["raptor"] = { ['name'] = "Raptor", ['price'] = 300000, ['tipo'] = "carros" },
	["sheava"] = { ['name'] = "Sheava", ['price'] = 700000, ['tipo'] = "carros" },
	["z190"] = { ['name'] = "Z190", ['price'] = 350000, ['tipo'] = "carros" },

	--MOTOS
	
	["akuma"] = { ['name'] = "Akuma", ['price'] = 500000, ['tipo'] = "motos" },
	["avarus"] = { ['name'] = "Avarus", ['price'] = 440000, ['tipo'] = "motos" },
	["bagger"] = { ['name'] = "Bagger", ['price'] = 300000, ['tipo'] = "motos" },
	["bati"] = { ['name'] = "Bati", ['price'] = 370000, ['tipo'] = "motos" },
	["bati2"] = { ['name'] = "Bati2", ['price'] = 300000, ['tipo'] = "motos" },
	["bf400"] = { ['name'] = "Bf400", ['price'] = 450000, ['tipo'] = "motos" },
	["carbonrs"] = { ['name'] = "Carbonrs", ['price'] = 370000, ['tipo'] = "motos" },
	["chimera"] = { ['name'] = "Chimera", ['price'] = 345000, ['tipo'] = "motos" },
	["cliffhanger"] = { ['name'] = "Cliffhanger", ['price'] = 310000, ['tipo'] = "motos" },
	["daemon2"]  = { ['name'] = "Daemon2", ['price'] = 240000, ['tipo'] = "motos" },
	["defiler"] = { ['name'] = "Defiler", ['price'] = 460000, ['tipo'] = "motos" },
	["diablous"] = { ['name'] = "Diablous", ['price'] = 430000, ['tipo'] = "motos" },
	["diablous2"] = { ['name'] = "Diablous2", ['price'] = 460000, ['tipo'] = "motos" },
	["double"] = { ['name'] = "Double", ['price'] = 370000, ['tipo'] = "motos" },
	["enduro"] = { ['name'] = "Enduro", ['price'] = 195000, ['tipo'] = "motos" },
	["esskey"] = { ['name'] = "Esskey", ['price'] = 320000, ['tipo'] = "motos" },
	["faggio"] = { ['name'] = "Faggio", ['price'] = 4000, ['tipo'] = "motos" },
	["faggio2"] = { ['name'] = "Faggio2", ['price'] = 5000, ['tipo'] = "motos" },
	["faggio3"] = { ['name'] = "Faggio3", ['price'] = 5000, ['tipo'] = "motos" },
	["fcr"] = { ['name'] = "Fcr", ['price'] = 390000, ['tipo'] = "motos" },
	["fcr2"] = { ['name'] = "Fcr2", ['price'] = 390000, ['tipo'] = "motos" },
	["gargoyle"] = { ['name'] = "Gargoyle", ['price'] = 345000, ['tipo'] = "motos" },
	["hakuchou"] = { ['name'] = "Hakuchou", ['price'] = 380000, ['tipo'] = "motos" },
	["hakuchou2"] = { ['name'] = "Hakuchou2", ['price'] = 550000, ['tipo'] = "motos" },
	["hexer"] = { ['name'] = "Hexer", ['price'] = 250000, ['tipo'] = "motos" },
	["innovation"] = { ['name'] = "Innovation", ['price'] = 250000, ['tipo'] = "motos" },
	["lectro"] = { ['name'] = "Lectro", ['price'] = 380000, ['tipo'] = "motos" },
	["manchez"] = { ['name'] = "Manchez", ['price'] = 355000, ['tipo'] = "motos" },
	["nemesis"] = { ['name'] = "Nemesis", ['price'] = 345000, ['tipo'] = "motos" },
	["nightblade"] = { ['name'] = "Nightblade", ['price'] = 415000, ['tipo'] = "motos" },
	["pcj"] = { ['name'] = "Pcj", ['price'] = 230000, ['tipo'] = "motos" },
	["ruffian"] = { ['name'] = "Ruffian", ['price'] = 345000, ['tipo'] = "motos" },
	["sanchez"] = { ['name'] = "Sanchez", ['price'] = 185000, ['tipo'] = "motos" },
	["sanchez2"] = { ['name'] = "Sanchez2", ['price'] = 185000, ['tipo'] = "motos" },
	["sovereign"] = { ['name'] = "Sovereign", ['price'] = 285000, ['tipo'] = "motos" },
	["thrust"] = { ['name'] = "Thrust", ['price'] = 375000, ['tipo'] = "motos" },
	["vader"] = { ['name'] = "Vader", ['price'] = 345000, ['tipo'] = "motos" },
	["vindicator"] = { ['name'] = "Vindicator", ['price'] = 340000, ['tipo'] = "motos" },
	["vortex"] = { ['name'] = "Vortex", ['price'] = 375000, ['tipo'] = "motos" },
	["wolfsbane"] = { ['name'] = "Wolfsbane", ['price'] = 290000, ['tipo'] = "motos" },
	["zombiea"] = { ['name'] = "Zombiea", ['price'] = 290000, ['tipo'] = "motos" },
	["zombieb"] = { ['name'] = "Zombieb", ['price'] = 300000, ['tipo'] = "motos" },
	["shotaro"] = { ['name'] = "Shotaro", ['price'] = 800000, ['tipo'] = "motos" },
	["ratbike"] = { ['name'] = "Ratbike", ['price'] = 230000, ['tipo'] = "motos" },
	["blazer"] = { ['name'] = "Blazer", ['price'] = 230000, ['tipo'] = "motos" },
	["blazer4"] = { ['name'] = "Blazer4", ['price'] = 370000, ['tipo'] = "motos" },

	--TRABALHO
	["pbus"] = { ['name'] = "Echo", ['price'] = 1000, ['tipo'] = "work" },
	["policiaheli"] = { ['name'] = "Delta", ['price'] = 1000, ['tipo'] = "work" },
	["policiabearcat"] = { ['name'] = "Bravo", ['price'] = 1000, ['tipo'] = "work" },

	["policiacharger2018"] = { ['name'] = "Dodge Charger 2018", ['price'] = 1000, ['tipo'] = "work" },
	["policiasilverado"] = { ['name'] = "Chevrolet Silverado", ['price'] = 1000, ['tipo'] = "work" },
	["policiatahoe"] = { ['name'] = "Chevrolet Tahoe", ['price'] = 1000, ['tipo'] = "work" },
	["policiataurus"] = { ['name'] = "Ford Taurus", ['price'] = 1000, ['tipo'] = "work" },
	["policiabmwr1200"] = { ['name'] = "BMW R1200", ['price'] = 1000, ['tipo'] = "work" },

	["paramedicoambu"] = { ['name'] = "Ambulância", ['price'] = 1000, ['tipo'] = "work" },
	["paramedicocharger2014"] = { ['name'] = "Dodge Charger 2014", ['price'] = 1000, ['tipo'] = "work" },
	["paramedicoheli"] = { ['name'] = "Paramédico Helicóptero", ['price'] = 1000, ['tipo'] = "work" },

	["coach"] = { ['name'] = "Coach", ['price'] = 1000, ['tipo'] = "work" },
	["bus"] = { ['name'] = "Ônibus", ['price'] = 1000, ['tipo'] = "work" },
	["flatbed"] = { ['name'] = "Reboque", ['price'] = 1000, ['tipo'] = "work" },
	["towtruck"] = { ['name'] = "Towtruck", ['price'] = 1000, ['tipo'] = "work" },
	["towtruck2"] = { ['name'] = "Towtruck2", ['price'] = 1000, ['tipo'] = "work" },
	["ratloader"] = { ['name'] = "ratloader", ['price'] = 1000, ['tipo'] = "work" },
	["ratloader2"] = { ['name'] = "Ratloader2", ['price'] = 1000, ['tipo'] = "work" },
	["rubble"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work" },
	["taxi"] = { ['name'] = "Taxi", ['price'] = 1000, ['tipo'] = "work" },
	["boxville4"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work" },
	["trash2"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work" },
	["tiptruck"] = { ['name'] = "Tiptruck", ['price'] = 1000, ['tipo'] = "work" },
	["scorcher"] = { ['name'] = "Scorcher", ['price'] = 1000, ['tipo'] = "work" },
	["tribike"] = { ['name'] = "Tribike", ['price'] = 1000, ['tipo'] = "work" },
	["tribike2"] = { ['name'] = "Tribike2", ['price'] = 1000, ['tipo'] = "work" },
	["tribike3"] = { ['name'] = "Tribike3", ['price'] = 1000, ['tipo'] = "work" },
	["fixter"] = { ['name'] = "Fixter", ['price'] = 1000, ['tipo'] = "work" },
	["cruiser"] = { ['name'] = "Cruiser", ['price'] = 1000, ['tipo'] = "work" },
	["bmx"] = { ['name'] = "Bmx", ['price'] = 1000, ['tipo'] = "work" },
	["dinghy"] = { ['name'] = "Dinghy", ['price'] = 1000, ['tipo'] = "work" },
	["jetmax"] = { ['name'] = "Jetmax", ['price'] = 1000, ['tipo'] = "work" },
	["marquis"] = { ['name'] = "Marquis", ['price'] = 1000, ['tipo'] = "work" },
	["seashark3"] = { ['name'] = "Seashark3", ['price'] = 1000, ['tipo'] = "work" },
	["speeder"] = { ['name'] = "Speeder", ['price'] = 1000, ['tipo'] = "work" },
	["speeder2"] = { ['name'] = "Speeder2", ['price'] = 1000, ['tipo'] = "work" },
	["squalo"] = { ['name'] = "Squalo", ['price'] = 1000, ['tipo'] = "work" },
	["suntrap"] = { ['name'] = "Suntrap", ['price'] = 1000, ['tipo'] = "work" },
	["toro"] = { ['name'] = "Toro", ['price'] = 1000, ['tipo'] = "work" },
	["toro2"] = { ['name'] = "Toro2", ['price'] = 1000, ['tipo'] = "work" },
	["tropic"] = { ['name'] = "Tropic", ['price'] = 1000, ['tipo'] = "work" },
	["tropic2"] = { ['name'] = "Tropic2", ['price'] = 1000, ['tipo'] = "work" },
	["phantom"] = { ['name'] = "Phantom", ['price'] = 1000, ['tipo'] = "work" },
	["packer"] = { ['name'] = "Packer", ['price'] = 1000, ['tipo'] = "work" },
	["supervolito"] = { ['name'] = "Supervolito", ['price'] = 1000, ['tipo'] = "work" },
	["supervolito2"] = { ['name'] = "Supervolito2", ['price'] = 1000, ['tipo'] = "work" },
	["cuban800"] = { ['name'] = "Cuban800", ['price'] = 1000, ['tipo'] = "work" },
	["mammatus"] = { ['name'] = "Mammatus", ['price'] = 1000, ['tipo'] = "work" },
	["vestra"] = { ['name'] = "Vestra", ['price'] = 1000, ['tipo'] = "work" },
	["velum2"] = { ['name'] = "Velum2", ['price'] = 1000, ['tipo'] = "work" },
	["buzzard2"] = { ['name'] = "Buzzard2", ['price'] = 1000, ['tipo'] = "work" },
	["frogger"] = { ['name'] = "Frogger", ['price'] = 1000, ['tipo'] = "work" },
	["maverick"] = { ['name'] = "Maverick", ['price'] = 1000, ['tipo'] = "work" },
	["tanker2"] = { ['name'] = "Gas", ['price'] = 1000, ['tipo'] = "work" },
	["armytanker"] = { ['name'] = "Diesel", ['price'] = 1000, ['tipo'] = "work" },
	["tvtrailer"] = { ['name'] = "Show", ['price'] = 1000, ['tipo'] = "work" },
	["trailerlogs"] = { ['name'] = "Woods", ['price'] = 1000, ['tipo'] = "work" },
	["tr4"] = { ['name'] = "Cars", ['price'] = 1000, ['tipo'] = "work" },
	["speedo"] = { ['name'] = "Speedo", ['price'] = 200000, ['tipo'] = "work" },
	["primo2"] = { ['name'] = "Primo2", ['price'] = 200000, ['tipo'] = "work" },
	["faction2"] = { ['name'] = "Faction2", ['price'] = 200000, ['tipo'] = "work" },
	["chino2"] = { ['name'] = "Chino2", ['price'] = 200000, ['tipo'] = "work" },
	["tornado5"] = { ['name'] = "Tornado5", ['price'] = 200000, ['tipo'] = "work" },
	["daemon"] = { ['name'] = "Daemon", ['price'] = 200000, ['tipo'] = "work" },
	["sanctus"] = { ['name'] = "Sanctus", ['price'] = 200000, ['tipo'] = "work" },
	["gburrito"] = { ['name'] = "GBurrito", ['price'] = 200000, ['tipo'] = "work" },
	["slamvan2"] = { ['name'] = "Slamvan2", ['price'] = 200000, ['tipo'] = "work" },
	["stafford"] = { ['name'] = "Stafford", ['price'] = 200000, ['tipo'] = "work" },
	["cog55"] = { ['name'] = "Cog55", ['price'] = 200000, ['tipo'] = "work" },
	["superd"] = { ['name'] = "Superd", ['price'] = 200000, ['tipo'] = "work" },
	["btype"] = { ['name'] = "Btype", ['price'] = 200000, ['tipo'] = "work" },
	["tractor2"] = { ['name'] = "Tractor2", ['price'] = 1000, ['tipo'] = "work" },
	["rebel"] = { ['name'] = "Rebel", ['price'] = 1000, ['tipo'] = "work" },
	["flatbed3"] = { ['name'] = "flatbed3", ['price'] = 1000, ['tipo'] = "work" },
	["volatus"] = { ['name'] = "Volatus", ['price'] = 800000, ['tipo'] = "work" },
	["cargobob2"] = { ['name'] = "Cargo Bob", ['price'] = 800000, ['tipo'] = "work" },		
	
	--IMPORTADOS

	["dodgechargersrt"] = { ['name'] = "Dodge Charger SRT", ['price'] = 800000, ['tipo'] = "import" },
	["audirs6"] = { ['name'] = "Audi RS6", ['price'] = 800000, ['tipo'] = "import" },
	["bmwm3f80"] = { ['name'] = "BMW M3 F80", ['price'] = 800000, ['tipo'] = "import" },
	["bmwm4gts"] = { ['name'] = "BMW M4 GTS", ['price'] = 800000, ['tipo'] = "import" },
	["mazdarx7"] = { ['name'] = "Mazda RX7", ['price'] = 800000, ['tipo'] = "import" },
	["fordmustang"] = { ['name'] = "Ford Mustang", ['price'] = 800000, ['tipo'] = "import" },
	["lancerevolution9"] = { ['name'] = "Lancer Evolution 9", ['price'] = 800000, ['tipo'] = "import" },
	["lancerevolutionx"] = { ['name'] = "Lancer Evolution X", ['price'] = 800000, ['tipo'] = "import" },
	["focusrs"] = { ['name'] = "Focus RS", ['price'] = 800000, ['tipo'] = "import" },
	["nissangtr"] = { ['name'] = "Nissan GTR", ['price'] = 800000, ['tipo'] = "exclusive" },
	["lamborghinihuracan"] = { ['name'] = "Lamborghini Huracan", ['price'] = 800000, ['tipo'] = "import" },
	["ferrariitalia"] = { ['name'] = "Ferrari Italia 478", ['price'] = 800000, ['tipo'] = "import" },
	["mercedesa45"] = { ['name'] = "Mercedes A45", ['price'] = 800000, ['tipo'] = "import" },
	["nissangtrnismo"] = { ['name'] = "Nissan GTR Nismo", ['price'] = 800000, ['tipo'] = "exclusive" },
	["audirs7"] = { ['name'] = "Audi RS7", ['price'] = 800000, ['tipo'] = "import" },
	["nissanskyliner34"] = { ['name'] = "Nissan Skyline R34", ['price'] = 800000, ['tipo'] = "import" },
	["nissan370z"] = { ['name'] = "Nissan 370Z", ['price'] = 800000, ['tipo'] = "import" },
	["hondafk8"] = { ['name'] = "Honda FK8", ['price'] = 800000, ['tipo'] = "import" },
	["mustangmach1"] = { ['name'] = "Mustang Mach 1", ['price'] = 800000, ['tipo'] = "import" },
	["porsche930"] = { ['name'] = "Porsche 930", ['price'] = 800000, ['tipo'] = "import" },
	["teslaprior"] = { ['name'] = "Tesla Prior", ['price'] = 800000, ['tipo'] = "import" },
	["type263"] = { ['name'] = "Kombi 63", ['price'] = 800000, ['tipo'] = "import" },
	["beetle74"] = { ['name'] = "Fusca 74", ['price'] = 800000, ['tipo'] = "import" },
	["fe86"] = { ['name'] = "Escorte", ['price'] = 800000, ['tipo'] = "import" },		

	--EXCLUSIVE 
	
	["i8"] = { ['name'] = "BMW i8", ['price'] = 800000, ['tipo'] = "exclusive" },
	["raptor2017"] = { ['name'] = "Ford Raptor 2017", ['price'] = 800000, ['tipo'] = "exclusive" },	
	["bc"] = { ['name'] = "Pagani Huayra", ['price'] = 800000, ['tipo'] = "exclusive" },
	["f4rr"] = { ['name'] = "Agusta F4RR", ['price'] = 800000, ['tipo'] = "exclusive" },
	["dm1200"] = { ['name'] = "Ducati dm1200", ['price'] = 800000, ['tipo'] = "exclusive" },
	["cb500x"] = { ['name'] = "CB500x", ['price'] = 800000, ['tipo'] = "exclusive" },
	["hcbr17"] = { ['name'] = "hcbr17", ['price'] = 800000, ['tipo'] = "exclusive" },
	["africat"] = { ['name'] = "africat", ['price'] = 800000, ['tipo'] = "exclusive" },
	["toyotasupra"] = { ['name'] = "Toyota Supra", ['price'] = 800000, ['tipo'] = "exclusive" },
	["488gtb"] = { ['name'] = "Ferrari 488 GTB", ['price'] = 800000, ['tipo'] = "exclusive" },
	["fxxkevo"] = { ['name'] = "Ferrari FXXK Evo", ['price'] = 800000, ['tipo'] = "exclusive" },
	["m2"] = { ['name'] = "BMW M2", ['price'] = 800000, ['tipo'] = "exclusive" },
	["p1"] = { ['name'] = "Mclaren P1", ['price'] = 800000, ['tipo'] = "exclusive" },
	["bme6tun"] = { ['name'] = "BMW M5", ['price'] = 800000, ['tipo'] = "exclusive" },
	["aperta"] = { ['name'] = "La Ferrari", ['price'] = 800000, ['tipo'] = "exclusive" },
	["bettle"] = { ['name'] = "New Bettle", ['price'] = 800000, ['tipo'] = "exclusive" },
	["senna"] = { ['name'] = "Mclaren Senna", ['price'] = 800000, ['tipo'] = "exclusive" },
	["rmodx6"] = { ['name'] = "BMW X6", ['price'] = 800000, ['tipo'] = "exclusive" },
	["bnteam"] = { ['name'] = "Bentley", ['price'] = 800000, ['tipo'] = "exclusive" },
	["rmodlp770"] = { ['name'] = "Lamborghini Centenario", ['price'] = 800000, ['tipo'] = "exclusive" },
	["divo"] = { ['name'] = "Buggati Divo", ['price'] = 800000, ['tipo'] = "exclusive" },
	["s15"] = { ['name'] = "Nissan Silvia S15", ['price'] = 800000, ['tipo'] = "exclusive" },
	["amggtr"] = { ['name'] = "Mercedes AMG", ['price'] = 800000, ['tipo'] = "exclusive" },
	["slsamg"] = { ['name'] = "Mercedes SLS", ['price'] = 800000, ['tipo'] = "exclusive" },
	["lamtmc"] = { ['name'] = "Lamborghini Terzo", ['price'] = 800000, ['tipo'] = "exclusive" },
	["vantage"] = { ['name'] = "Aston Martin Vantage", ['price'] = 800000, ['tipo'] = "exclusive" },
	["urus"] = { ['name'] = "Lamborghini Urus", ['price'] = 800000, ['tipo'] = "exclusive" },
	["amarok"] = { ['name'] = "VW Amarok", ['price'] = 800000, ['tipo'] = "exclusive" },
	["g65amg"] = { ['name'] = "Mercedes G65", ['price'] = 800000, ['tipo'] = "exclusive" },
	["celta"] = { ['name'] = "Celta Paredão", ['price'] = 800000, ['tipo'] = "exclusive" },
	["palameila"] = { ['name'] = "Porsche Panamera", ['price'] = 800000, ['tipo'] = "exclusive" },
	["rsvr16"] = { ['name'] = "Ranger Rover", ['price'] = 800000, ['tipo'] = "exclusive" },
	["veneno"] = { ['name'] = "Lamborghini Veneno", ['price'] = 800000, ['tipo'] = "exclusive" },
	["eleanor"] = { ['name'] = "Mustang Eleanor", ['price'] = 800000, ['tipo'] = "exclusive" },
	["rmodamgc63"] = { ['name'] = "Mercedes AMG C63", ['price'] = 800000, ['tipo'] = "exclusive" },
	["19ramdonk"] = { ['name'] = "Dodge Ram Donk", ['price'] = 800000, ['tipo'] = "exclusive" },
	["silv86"] = { ['name'] = "Silverado Donk", ['price'] = 800000, ['tipo'] = "exclusive" },
	["ninjah2"] = { ['name'] = "Ninja H2", ['price'] = 800000, ['tipo'] = "exclusive" },
	["70camarofn"] = { ['name'] = "camaro Z28 1970", ['price'] = 800000, ['tipo'] = "exclusive" },
	["agerars"] = { ['name'] = "Koenigsegg Agera RS", ['price'] = 800000, ['tipo'] = "exclusive" },
	["fc15"] = { ['name'] = "Ferrari California", ['price'] = 800000, ['tipo'] = "exclusive" },
	["msohs"] = { ['name'] = "Mclaren 688 HS", ['price'] = 800000, ['tipo'] = "exclusive" },
	["gt17"] = { ['name'] = "Ford GT 17", ['price'] = 800000, ['tipo'] = "exclusive" },
	["19ftype"] = { ['name'] = "Jaguar F-Type", ['price'] = 800000, ['tipo'] = "exclusive" },
	["bbentayga"] = { ['name'] = "Bentley Bentayga", ['price'] = 800000, ['tipo'] = "exclusive" },
	["nissantitan17"] = { ['name'] = "Nissan Titan 2017", ['price'] = 800000, ['tipo'] = "exclusive" },
	["911r"] = { ['name'] = "Porsche 911R", ['price'] = 800000, ['tipo'] = "exclusive" },
	["trr"] = { ['name'] = "KTM TRR", ['price'] = 800000, ['tipo'] = "exclusive" },
	["bmws"] = { ['name'] = "BMW S1000", ['price'] = 800000, ['tipo'] = "exclusive" },
	["defiant"] = { ['name'] = "AMC Javelin 72", ['price'] = 800000, ['tipo'] = "exclusive" },
	["f12tdf"] = { ['name'] = "Ferrari F12 TDF", ['price'] = 800000, ['tipo'] = "exclusive" },
	["71gtx"] = { ['name'] = "Plymouth 71 GTX", ['price'] = 800000, ['tipo'] = "exclusive" },
	["porsche992"] = { ['name'] = "Porsche 992", ['price'] = 800000, ['tipo'] = "exclusive" },
	["18macan"] = { ['name'] = "Porsche Macan", ['price'] = 800000, ['tipo'] = "exclusive" },
	["m6e63"] = { ['name'] = "BMW M6 E63", ['price'] = 800000, ['tipo'] = "exclusive" },
	["regera"] = { ['name'] = "Koenigsegg Regera", ['price'] = 800000, ['tipo'] = "exclusive" },
	["180sx"] = { ['name'] = "Nissan 180SX", ['price'] = 800000, ['tipo'] = "exclusive" },
	["filthynsx"] = { ['name'] = "Honda NSX", ['price'] = 800000, ['tipo'] = "exclusive" },
	["2018zl1"] = { ['name'] = "Camaro ZL1", ['price'] = 800000, ['tipo'] = "exclusive" },
	["eclipse"] = { ['name'] = "Mitsubishi Eclipse", ['price'] = 800000, ['tipo'] = "exclusive" },
	["lp700r"] = { ['name'] = "Lamborghini LP700R", ['price'] = 800000, ['tipo'] = "exclusive" },
	["db11"] = { ['name'] = "Aston Martin DB11", ['price'] = 800000, ['tipo'] = "exclusive" },
	["SVR14"] = { ['name'] = "Ranger Rover", ['price'] = 800000, ['tipo'] = "exclusive" },
	["evoque"] = { ['name'] = "Ranger Rover Evoque", ['price'] = 800000, ['tipo'] = "exclusive" },
	["Bimota"] = { ['name'] = "Ducati Bimota", ['price'] = 800000, ['tipo'] = "exclusive" },
	["r8ppi"] = { ['name'] = "Audi R8 PPI Razor", ['price'] = 800000, ['tipo'] = "exclusive" },
	["20r1"] = { ['name'] = "Yamaha YZF R1", ['price'] = 800000, ['tipo'] = "exclusive" },
	["mt03"] = { ['name'] = "Yamaha MT 03", ['price'] = 800000, ['tipo'] = "exclusive" },
	["yzfr125"] = { ['name'] = "Yamaha YZF R125", ['price'] = 800000, ['tipo'] = "exclusive" },
	["pistas"] = { ['name'] = "Ferrari Pista", ['price'] = 800000, ['tipo'] = "exclusive" },
	["bobbes2"] = { ['name'] = "Harley D. Bobber S", ['price'] = 800000, ['tipo'] = "exclusive" },
	["bobber"] = { ['name'] = "Harley D. Bobber ", ['price'] = 800000, ['tipo'] = "exclusive" },
	["911tbs"] = { ['name'] = "Porsche 911S", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["rc"] = { ['name'] = "KTM RC", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["zx10r"] = { ['name'] = "Kawasaki ZX10R", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["fox600lt"] = { ['name'] = "McLaren 600LT", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxbent1"] = { ['name'] = "Bentley Liter 1931", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxevo"] = { ['name'] = "Lamborghini EVO", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["jeepg"] = { ['name'] = "Jeep Gladiator", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxharley1"] = { ['name'] = "Harley-Davidson Softail F.B.", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxharley2"] = { ['name'] = "2016 Harley-Davidson Road Glide", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxleggera"] = { ['name'] = "Aston Martin Leggera", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxrossa"] = { ['name'] = "Ferrari Rossa", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxshelby"] = { ['name'] = "Ford Shelby GT500", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxsian"] = { ['name'] = "Lamborghini Sian", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxsterrato"] = { ['name'] = "Lamborghini Sterrato", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["foxsupra"] = { ['name'] = "Toyota Supra", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["m6x6"] = { ['name'] = "Mercedes Benz 6x6", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["m6gt3"] = { ['name'] = "BMW M6 GT3", ['price'] = 800000, ['tipo'] = "exclusive" },		
	["w900"] = { ['name'] = "Kenworth W900", ['price'] = 800000, ['tipo'] = "exclusive" },
	["918"] = { ['name'] = "Porsche 918", ['price'] = 800000, ['tipo'] = "exclusive" },

	["pounder"] = { ['name'] = "Pounder", ['price'] = 800000, ['tipo'] = "work" },
	["pounder2"] = { ['name'] = "Pounder2", ['price'] = 800000, ['tipo'] = "work" },
}