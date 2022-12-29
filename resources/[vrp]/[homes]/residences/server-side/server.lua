-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cO = {}
Tunnel.bindInterface("residences",cO)
vCLIENT = Tunnel.getInterface("residences")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
homes = {}
homesInterior = {}
local homeLock = {}
local homeEnter = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEW INTERIOR -- TRADE
-----------------------------------------------------------------------------------------------------------------------------------------
local newInterior = {
	-- Apartamento Com Vista
	["AppartmentMax"] = { ["valor"] = 7500000, ["interior"] = vector3(-1448.28, -530.68, 44.04), ["vaultCoords"] = vector3(-1452.91, -543.54, 43.44), ["wardobeCoords"] = vector3(-1451.83, -547.86, 46.84), ["residents"] = 4, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentMax2"] = { ["valor"] = 7500000, ["interior"] = vector3(-597.33, 61.76, 77.59), ["vaultCoords"] = vector3(-608.02, 53.83, 76.99), ["wardobeCoords"] = vector3(-610.32, 49.66, 80.39), ["residents"] = 4, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentMax3"] = { ["valor"] = 7500000, ["interior"] = vector3(-260.23, -708.68, 43.74), ["vaultCoords"] = vector3(-272.77, -712.22, 43.14), ["wardobeCoords"] = vector3(-276.68, -715.22, 46.54), ["residents"] = 4, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentAcqua"] = { ["valor"] = 7500000, ["interior"] = vector3(-787.38, 315.79, 187.92), ["vaultCoords"] = vector3(-794.99, 326.22, 187.32), ["wardobeCoords"] = vector3(-799.16, 327.89, 190.72), ["residents"] = 4, ["vault"] = 500, ["fridge"] = 50 },
	-- Apartamentos
	["AppartmentLuxuous"] = { ["valor"] = 4500000, ["interior"] = vector3(129.33, -1162.08, 765.81), ["vaultCoords"] = vector3(139.71, -1153.41, 765.2), ["wardobeCoords"] = vector3(141.35, -1149.26, 768.61), ["residents"] = 4, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentLuxuous2"] = { ["valor"] = 4500000, ["interior"] = vector3(146.86, -1124.79, 765.81), ["vaultCoords"] = vector3(157.88, -1116.85, 765.21), ["wardobeCoords"] = vector3(159.41, -1112.69, 768.61), ["residents"] = 4, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentLuxuous3"] = { ["valor"] = 6000000, ["interior"] = vector3(105.21, -1130.16, 765.81), ["vaultCoords"] = vector3(116.03, -1122.3, 765.21), ["wardobeCoords"] = vector3(117.69, -1118.11, 768.61), ["residents"] = 4, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentMiddle"] = { ["valor"] = 5000000, ["interior"] = vector3(190.09, -1156.66, 771.21), ["vaultCoords"] = vector3(198.68, -1155.3, 771.22), ["wardobeCoords"] = vector3(211.61, -1156.35, 765.01), ["residents"] = 3, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentBasic"] = { ["valor"] = 500000, ["interior"] = vector3(152.89, -1193.93, 763.0), ["vaultCoords"] = vector3(148.1, -1189.23, 765.0), ["wardobeCoords"] = vector3(146.66, -1190.68, 765.0), ["residents"] = 2, ["vault"] = 200, ["fridge"] = 50 },
	["AppartmentMotel"] = { ["valor"] = 100000, ["interior"] = vector3(-0.71,-3.49,765.01), ["vaultCoords"] = vector3(-0.99, 0.98, 765.0), ["wardobeCoords"] = vector3(-0.49, 3.05, 765.0), ["residents"] = 1, ["vault"] = 100, ["fridge"] = 10  },

	-- CASAS
	["Mansion"] = { ["valor"] = 7000000, ["interior"] = vector3(211.93, -1115.8, 770.41), ["vaultCoords"] = vector3(195.22, -1117.21, 769.38), ["wardobeCoords"] = vector3(209.16, -1125.53, 765.0), ["residents"] = 6, ["vault"] = 750, ["fridge"] = 100 },
	["Luxuous"] = { ["valor"] = 700000, ["interior"] = vector3(199.2, -1199.18, 764.81), ["vaultCoords"] = vector3(204.68, -1185.0, 764.81), ["wardobeCoords"] = vector3(203.51, -1179.76, 764.81), ["residents"] = 4, ["vault"] = 350, ["fridge"] = 35 },
	["Middle"] = {["valor"] = 300000, ["interior"] = vector3(175.24, -1164.19, 765.01), ["vaultCoords"] = vector3(179.24, -1158.63, 765.01), ["wardobeCoords"] = vector3(179.25, -1158.61, 765.01), ["residents"] = 5, ["vault"] = 500, ["fridge"] = 50 },
	["Trailer"] = {["valor"] = 50000,  ["interior"] = vector3(202.82, -1140.8, 765.47), ["vaultCoords"] = vector3(210.68, -1143.94, 765.43), ["wardobeCoords"] = vector3(200.26, -1143.78, 765.41), ["residents"] = 5, ["vault"] = 500, ["fridge"] = 50 },	
	["Basic"] = { ["valor"] = 25000, ["interior"] = vector3(172.11, -1180.49, 765.0), ["vaultCoords"] = vector3(169.42, -1183.41, 765.0), ["wardobeCoords"] = vector3(167.97, -1191.69, 765.0), ["residents"] = 2, ["vault"] = 150, ["fridge"] = 20  },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	local houseName = exports["oxmysql"]:executeSync("SELECT * FROM cfg_residences")
	for k,v in pairs(houseName) do 
		if v["slot"] == 0 then 
			v["slot"] = 1 
		end
		homes[v["name"]] = { v["x"],v["y"],v["z"],v["interiorType"],v["intPrice"],v["slot"],v["trade"] }
	end
	syncSelled()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES SELLED
-----------------------------------------------------------------------------------------------------------------------------------------
syncSelled = function()
	Citizen.CreateThread( function()
		while true do
			local homesInfos = exports["oxmysql"]:executeSync("SELECT * FROM characters_homes")
			for k,v in pairs(homesInfos) do 
				if homes[v.name] and homes[v.name].selled == nil then 
					homes[v.name].selled = true
				end
			end
			Citizen.Wait(10*60000)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTER INTERIOR
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.myInterior(interiorType,homeName,homeNumber)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then 
		if newInterior[interiorType] then 
			if homeNumber == 0 then 
				if GetPlayerRoutingBucket(source) == 0 then
					SetPlayerRoutingBucket(source, parseInt(user_id))
					return newInterior[interiorType]
				end
			end

			if (homeName):find "Apartamento" then 
				local ownerConsult = vRP.query("vRP/selectOwner",{ name = homeName, number = homeNumber })
				if ownerConsult[1] then
					local interiorCasa = newInterior[interiorType]
					if ownerConsult[1]["interior"] ~= interiorType then
						interiorCasa = newInterior[ownerConsult[1]["interior"]]
					end

					if GetPlayerRoutingBucket(source) == 0 then
						SetPlayerRoutingBucket(source, parseInt(ownerConsult[1]["user_id"]))
					end
					return interiorCasa
				end
				return newInterior[interiorType]
			else
				local checkExist = vRP.query("homes/userOwnermissions",{ name = homeName })
				if checkExist[1] then 
					if GetPlayerRoutingBucket(source) == 0 then
						SetPlayerRoutingBucket(source, parseInt(checkExist[1]["user_id"]))
						local myInterior = newInterior[interiorType]
						if checkExist[1]["interior"] ~= interiorType then
							myInterior = newInterior[checkExist[1]["interior"]]
						end
						return myInterior
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEARESTHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function nearestHomes(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	for k,v in pairs(homes) do
		local distance = #(coords - vector3(v[1],v[2],v[3]))
		if distance <= 1.5 then
			return k
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSULT APARTAMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function getFreeAppartment(homeName,number)
	local query = exports["oxmysql"]:singleSync("SELECT `user_id` FROM characters_homes WHERE name = @name AND number = @number",{ name = homeName, number = number })
	if query then 
		return query.user_id
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIND INTERFONE
-----------------------------------------------------------------------------------------------------------------------------------------
function findFreeNumber(homeName,max)
	local i = 1
	while i <= max do
		if not getFreeAppartment(homeName,i) then
			return i
		end
		i = i+1
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APARTAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("residencias",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then 
		local homesList = vRP.query("homes/userList",{ user_id = user_id })
		if parseInt(#homesList) >= 1 then
			for k,v in pairs(homesList) do
				if string.find(v["name"],"Apartamento") then 
					if parseInt(os.time()) >= parseInt(v["tax"] + 24 * 15 * 60 * 60) then
						TriggerClientEvent("Notify",source,"sucesso","<b>Apartamento:</b> "..v["name"].."<br> <b>Interfone:</b> " ..v["number"].."<br> <b>Taxa:</b> Vencida",20000)
					else
						TriggerClientEvent("Notify",source,"sucesso","<b>Apartamento:</b> "..v["name"].."<br> <b>Interfone:</b> " ..v["number"].."<br> <b>Taxa:</b> "..vRP.getDayHours(86400 * 15 - (os.time() - v["tax"])).." ",20000)
					end
				else
					TriggerClientEvent("Notify",source,"sucesso","<b>Residência:</b> "..v["name"],20000)
				end
			end
		else
			TriggerClientEvent("Notify",source,"negado","Você não possuí residências",6000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRIAÇÃO DE NOVAS CASAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("house",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.hasTablePermission(user_id, {"admin.permissao","mod.permissao"}) then 
		if args[1] == "deletar" then 
			local homeName = nearestHomes(source)
			if homeName then 
				local choice = vRP.request(source, "Deseja deletar a residência e remover todos moradores ? ", 60)
				if choice then 
					vRP.execute("vRP/deleteHouse",{ name = homeName })
					vRP.execute("homes/selling",{ name = homeName })
					exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"chest:"..homeName})
					exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"wardrobe:"..homeName})
					homes[homeName] = nil
					vCLIENT.updateHomes(-1,homes)
				end
			end
		else
			vCLIENT.showOptions(source,1)
		end
	end	
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INTERAÇÃO CRIAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:createSystem",function(actionType)
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id and vRP.hasPermission(user_id,"admin.permissao") then
		local coords = GetEntityCoords(GetPlayerPed(source))
		TriggerClientEvent("dynamic:closeSystem2", source)
		if actionType == "Apartamento" then 
			local number = vRP.prompt(source, "Insira o número do condominio", "0")
			if parseInt(number) > 0 then 
				local checkExist = vRP.query("vRP/selectcHouse", { name = "Apartamento"..number })
				if not checkExist[1] then 
					local price = vRP.prompt(source, "Insira o valor do apartamento", "0")
					if parseInt(price) > 0 then 
						local slot = vRP.prompt(source, "Insira o máximo de moradores do condomínio", "10")
						if parseInt(slot) > 0 then 
							local trade = vRP.prompt(source, "Deseja que o apartamento valorize ? , se sim insira o valor que vai aumentar a cada venda", "0")
							if parseInt(trade) > 0 then 
								vCLIENT.showOptions(source,2,newInterior)
							end
						end
					end		
					local actived = {}

					RegisterServerEvent("homes:interiorCheck",function(interiorType)
						if actived[user_id] then return end 
						actived[user_id] = true 
						if newInterior[interiorType] and not homes["Apartamento"..number] then 
							TriggerClientEvent("dynamic:closeSystem2", source)
							homes["Apartamento"..number] = { coords.x,coords.y,coords.z,interiorType,parseInt(price),parseInt(slot),parseInt(trade) }
							vRP.execute("vRP/insertHouses",{ name = "Apartamento"..number, x = coords.x, y = coords.y, z = coords.z, interiorType = interiorType, intPrice = parseInt(price), slot = parseInt(slot), trade = parseInt(trade)   })
							vCLIENT.updateHomes(-1,homes)
							return
						end
					end)

				else
					TriggerClientEvent("Notify",source,"negado","Esse condominio já existe",5000) 
				end 
			end
		elseif actionType == "Casa" then 
			local number = vRP.prompt(source, "Insira o número da casa", "0")
			local checkExist = vRP.query("vRP/selectcHouse", { name = "Homes"..number })
			if not checkExist[1] then 
				local price = vRP.prompt(source, "Insira o valor da casa", "0")
				if parseInt(price) > 0 then 
					vCLIENT.showOptions(source,2,newInterior)
				end

				local actived = {}

				RegisterServerEvent("homes:interiorCheck",function(interiorType)
					if actived[user_id] then return end 
					actived[user_id] = true 
					if newInterior[interiorType] and not homes["Homes"..number]  then 
						TriggerClientEvent("dynamic:closeSystem2", source)
						homes["Homes"..number] = { coords.x,coords.y,coords.z,interiorType,parseInt(price),0,0 }
						vRP.execute("vRP/insertHouses",{ name = "Homes"..number, x = coords.x, y = coords.y, z = coords.z, interiorType = interiorType, intPrice = parseInt(price), slot = 0, trade = 0  })
						vCLIENT.updateHomes(-1,homes)
						return
					end
				end)

			else
				TriggerClientEvent("Notify",source,"negado","Essa casa já existe",5000) 
			end 
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK TAX
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.checkTax(home,interfone)
	local row = exports["oxmysql"]:singleSync('SELECT tax FROM characters_homes WHERE name=? AND owner=1 AND number = ?', { home,interfone or 1 })
	if row then
		if parseInt(os.time()) >= parseInt(row.tax + 24 * 15 * 60 * 60) then
			return true,"As taxas da propriedade estão atrasadas."
		else
			return false,"Taxa em : "..vRP.getDayHours(86400 * 15 - (os.time() - row.tax))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:invokeSystem",function(action)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then 
		local homeName = nearestHomes(source) 
		if homes[homeName] then 
			TriggerClientEvent("dynamic:closeSystem2", source)
			if action == "visitar" then 
				homesInterior[homeName] = homes[homeName][4]
				vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false,0,true)
			elseif action == "buyHouse" then 
				local checkExist = vRP.query("homes/permissions",{ name = homeName })
				if checkExist[1] == nil then
					local value = vRP.getUData(parseInt(user_id),"vRP:multas")
					local multas = json.decode(value) or 0
					if multas > 0 then
						TriggerClientEvent("Notify",source,"negado","Você tem multas pendentes.",10000)
						return
					end

					local maxHomes = vRP.query("homes/countUsers",{ user_id = user_id })
					local myHomes = exports["oxmysql"]:singleSync("SELECT `house_limit` FROM `characters_props` WHERE `character_id` = ?",{ user_id })
					if parseInt(maxHomes[1]["qtd"]) >= myHomes["house_limit"] then
						TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de residências.",3000)
						return
					end

					local interiorSelect = homes[homeName][4]
					local homesPrice = homes[homeName][5]

					if vRP.request(source,"Deseja comprar a residência <b>"..interiorSelect.."</b> por <b>$"..vRP.format(homesPrice).."</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,homesPrice) then 
							vRP.execute("homes/buying",{ name = homeName, user_id = user_id, interior = homes[homeName][4], tax = os.time(), price = homesPrice, residents = newInterior[interiorSelect]["residents"], vault = newInterior[interiorSelect]["vault"] })
							TriggerClientEvent("Notify",source,"sucesso","Compra concluída.",5000)
							generateWebhook(user_id,{ transaction = "buyHouse", message = "Comprou a residência "..homeName.." no valor de $"..homesPrice.."" })
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				end
			elseif action == "buyAp" then 
				local checkHouse = 0
				local ownerConsult = vRP.query("homes/userOwnermissions",{ name = homeName })
							
				if ownerConsult[1] == nil then checkHouse = 0 else checkHouse = ownerConsult[1]["user_id"] end 
				if checkHouse == 0 or checkHouse ~= user_id then 
					local slot = findFreeNumber(homeName,homes[homeName][6])
					if slot then 
						local interiorSelect = homes[homeName][4]
						local homesPrice = homes[homeName][5]
						if #ownerConsult > 1  then 
							if homes[homeName][7] then 
								local trading = homes[homeName][7] * #ownerConsult
								homesPrice = homesPrice + trading
							end
						end

						local value = vRP.getUData(parseInt(user_id),"vRP:multas")
                        local multas = json.decode(value) or 0
                        if multas > 0 then
                            TriggerClientEvent("Notify",source,"negado","Você tem multas pendentes.",10000)
                            return
                        end
    
                        local maxHomes = vRP.query("homes/countUsers",{ user_id = user_id })
						local myHomes = exports["oxmysql"]:singleSync("SELECT `house_limit` FROM `characters_props` WHERE `character_id` = ?",{ user_id })
						if parseInt(maxHomes[1]["qtd"]) >= myHomes["house_limit"] then
                            TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de residências.",3000)
                            return
                        end

	
						if vRP.request(source,"Deseja comprar a residência <b>"..interiorSelect.."</b> por <b>$"..vRP.format(homesPrice).."</b> dólares?",30) then
							if vRP.tryFullPayment(user_id,homesPrice) then
								vRP.execute("vRP/buyAppartment",{ name = homeName, user_id = user_id, interior = homes[homeName][4], tax = os.time(), price = homesPrice, number = parseInt(slot), residents = newInterior[interiorSelect]["residents"], vault = newInterior[interiorSelect]["vault"], fridge = newInterior[interiorSelect]["fridge"] })
								TriggerClientEvent("Notify",source,"sucesso","Compra concluída.",5000)
								generateWebhook(user_id,{ transaction = "buyAp", message = "Comprou o apartamento "..homeName.." com interfone "..slot.." no valor de $"..homesPrice.."" })
							else
								TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"negado","Todos apartamentos já foram vendidos.",6000)
					end
				else
					TriggerClientEvent("Notify",source,"negado","Você já possuí um apartamento neste condomínio",6000)
				end
			elseif action == "interfone" then 
				local consult = vRP.query("homes/userPermissions",{ name = homeName, user_id = user_id })[1]
				local myInterfone = consult and consult["number"] or "0" 
				local interfone = vRP.prompt(source, "Insira o número do apartamento", myInterfone)
				if interfone ~= "" and parseInt(interfone) > 0 then 
					interfone = parseInt(interfone)
					local myAppartment = getFreeAppartment(homeName,interfone)
					if myAppartment then
						homesInterior[homeName] = homes[homeName][4]
						if parseInt(myInterfone) ~= interfone then
							local playerOne = vRP.getUserSource(parseInt(myAppartment))
							if playerOne then 
								local identity = vRP.getUserIdentity(user_id)
								if vRP.request(playerOne, identity["name"].." "..identity["firstname"].." está tocando sua campainha, deseja aceitar ?" , 60) then 
									vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false,interfone)
									return 
								else
									TriggerClientEvent("Notify",source,"importante","Sua solicitação foi recusada.",10000)
									return false
								end
							else
								TriggerClientEvent("Notify",source,"negado","O morador está fora da cidade.",10000)
								return false
							end
						end

						local tax,taxInfos = cO.checkTax(homeName,interfone)
						TriggerClientEvent("Notify",source,"azul",taxInfos)

						if not tax then 
							vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false,interfone)
						end

					end
				end
			elseif action == "list" then 
				local permList = ""
				local infosHouses = vRP.query("homes/userPermissions",{ name = homeName, user_id = user_id })[1]
                if infosHouses then 
					local checkExist = vRP.query("vRP/selectAppartment",{ name = homeName, number = infosHouses["number"] or 1 })
					for k,v in pairs(checkExist) do
						local identity = vRP.getUserIdentity(v["user_id"])
						if identity then
							permList = permList.."<b>Nome:</b> "..identity["name"].." "..identity["firstname"].."   -   <b>Passaporte:</b> "..v["user_id"]
							if k ~= #checkExist then
								permList = permList.."<br>"
							end
						end
					end
					TriggerClientEvent("Notify",source,"importante","Lista de permissões da residência: <br>"..permList,20000)
                end
			elseif action == "enterHouse" then 
				local checkExist = vRP.query("homes/permissions",{ name = homeName })
				if checkExist[1] then
					homesInterior[homeName] = checkExist[1]["interior"]

					local tax,taxInfos = cO.checkTax(homeName)
					
					for _,v in pairs(checkExist) do 
						if v["user_id"] == user_id then 
							if not tax then 
								TriggerClientEvent("Notify",source,"azul",taxInfos)
								return vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false)
							end
						end
					end

					if not homeLock[homeName] then
						TriggerClientEvent("Notify",source,"negado","Trancada.",3000)
					else
						if not tax then 
							vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false)
						end
					end
					TriggerClientEvent("Notify",source,"azul",taxInfos)
				end
			end


			-- PARTE DO DONO
			local consult = vRP.query("homes/userPermissions",{ name = homeName, user_id = user_id })
			if consult[1] and consult[1]["owner"] >= 1 then
				if action == "baú" then 
					if vRP.request(source,"Deseja aumentar o baú por <b>$100.000</b> dólares?",30) then
						if consult[1]["vault"] <= 1000 then 
							if vRP.tryFullPayment(user_id,100000) then
								vRP.execute("homes/updateVault",{ name = homeName, vault = 50 })
								TriggerClientEvent("Notify",source,"sucesso","Compra efetuada.",5000)
							else
								TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"negado","Atingiu o peso máximo do baú",5000)
						end
					end
				elseif action == "vender" then 
					local homesPrice = parseInt(consult[1]["price"] * 0.7)
					if vRP.request(source,"Deseja concluir a venda por <b>$"..vRP.format(homesPrice).."</b> dólares?",30) then
						local checkOwned 
						if (homeName):find "Apartamento" then 
							checkOwned = vRP.query("vRP/selectOwner",{ name = homeName, number = consult[1]["number"] })
							if checkOwned[1] then
								vRP.execute("vRP/deleteAP",{ name = homeName, number = consult[1]["number"] })
								exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"chest:"..homeName..consult[1]["number"]})
								vRP.giveBankMoney(user_id,homesPrice)
								TriggerClientEvent("Notify",source,"sucesso","Venda concluída.",5000)
								generateWebhook(user_id,{ transaction = "sell", message = "Vendeu o apartamento "..homeName.." "..consult[1]["number"].." por $"..homesPrice.."" })
							end
						else
							checkOwned = vRP.query("homes/userPermissions",{ name = homeName, user_id = user_id })
							if checkOwned[1] then
								TriggerEvent("vrp_garages:removeGarages",homeName)
								vRP.execute("homes/selling",{ name = homeName })
								exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"wardrobe:"..homeName})
								exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"chest:"..homeName})
								vRP.giveBankMoney(user_id,homesPrice)
								TriggerClientEvent("Notify",source,"sucesso","Venda concluída.",5000)
								generateWebhook(user_id,{ transaction = "sell", message = "Vendeu a residência "..homeName.." por $"..homesPrice.."" })
							end
						end
					end
				elseif action == "tax" then 
					local homesPrice = parseInt(consult[1]["price"] * 0.12)
					if vRP.request(source,"Suas taxas não venceram, restam  <b>"..vRP.getDayHours(86400 * 15 - (os.time() - consult[1]["tax"])).."</b>, Deseja pagar as taxas por <b>$"..vRP.format(homesPrice).."</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,homesPrice) then
							vRP.execute("homes/updateTax",{ name = homeName, tax = os.time() })
							TriggerClientEvent("Notify",source,"sucesso","Pagamento efetuado.",10000)
							generateWebhook(user_id,{ transaction = "tax", message = "Pagou a taxa da residência "..homeName.." por $"..homesPrice })
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",10000)
						end
					end
				elseif action == "garagem" then 
					if (homeName):find "Apartamento" then return end
					if vRP.hasPermission(user_id,"admin.permissao") then 
						local homesGarage = 50000
						if vRP.request(source,"Deseja adicionar a garagem pagando <b>$"..vRP.format(homesGarage).."</b> dólares?",30) then
							if vRP.getBankMoney(user_id) + vRP.getMoney(user_id) >= homesGarage then
								TriggerClientEvent("Notify",source,"aviso","Fique no local onde vai abrir a garagem e pressione a tecla <b>E</b>.",10000)
								vCLIENT.homeGarage(source,homeName,homes[homeName][1],homes[homeName][2],homes[homeName][3])
							else
								TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"negado","Habilitado apenas para doadores.",10000)
					end
				elseif action == "trans" then 
					local nplayer = vRP.prompt(source, "Insira o passaporte que deseja transferir a residência")
					if nplayer and nplayer ~= "" and parseInt(nplayer) > 0 and vRP.getUserSource(parseInt(nplayer)) then 
						local nuser_id = parseInt(nplayer)
						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local maxHomes = vRP.query("homes/countUsers",{ user_id = nuser_id })
							local myHomes = exports["oxmysql"]:singleSync("SELECT `house_limit` FROM `characters_props` WHERE `character_id` = ?",{ nuser_id })
							if parseInt(maxHomes[1]["qtd"]) >= myHomes["house_limit"] then
								TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de residências.",3000)
								return
							end
					
							local userConsult = vRP.query("homes/userPermissions",{ user_id = nuser_id, name = homeName })
							if userConsult[1] then
								vRP.execute("homes/removePermissions",{ name = homeName, user_id = nuser_id })
							end
					
							vRP.execute("homes/updateOwner",{ name = homeName, user_id = user_id, nuser_id = nuser_id })
							TriggerClientEvent("Notify",source,"sucesso","Transferencia da residência para <b>"..identity["name"].." "..identity["firstname"].."</b> concluída.",5000)
							generateWebhook(user_id,{ transaction = "transfer", message = "Transferencia da residência "..homeName.." para <b>"..identity["name"].." "..identity["firstname"].."</b> concluída." })
						else
							TriggerClientEvent("Notify",source,"negado","Passaporte inválido.",5000)
						end
					end
				elseif action == "addchave" then 
					local nplayer = vRP.prompt(source, "Insira o passaporte que deseja adicionar em sua residência")
					if nplayer and nplayer ~= "" and parseInt(nplayer) > 0 and vRP.getUserSource(parseInt(nplayer)) then 
						local nuser_id = parseInt(nplayer)
						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local maxHomes = vRP.query("homes/countUsers",{ user_id = nuser_id })
							local myHomes = exports["oxmysql"]:singleSync("SELECT `house_limit` FROM `characters_props` WHERE `character_id` = ?",{ nuser_id })
							if parseInt(maxHomes[1]["qtd"]) >= myHomes["house_limit"] then
								TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de residências.",3000)
								return
							end
					
							
							local homesCount = vRP.query("homes/countPermissions",{ name = homeName })
							if homesCount[1]["qtd"] >= consult[1]["residents"] then
								TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de moradores.",5000)
								return
							end
				
							local newConsult = vRP.query("homes/userPermissions",{ user_id = nuser_id, name = homeName })
							if newConsult[1] then
								TriggerClientEvent("Notify",source,"importante","<b>"..identity["name"].." "..identity["firstname"].."</b> já pertence a residência.",5000)
							else
								if (homeName):find "Apartamento" then 
									vRP.execute("vRP/secondOwnerAP",{ user_id = nuser_id, name = homeName, interior = consult[1]["interior"], owner = 0, number = consult[1]["number"] })
									TriggerClientEvent("Notify",source,"sucesso","Adicionado o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> a residência.",5000)
								else
									vRP.execute("homes/newPermissions",{ user_id = nuser_id, name = homeName, interior = consult[1]["interior"], owner = 0 })
									TriggerClientEvent("Notify",source,"sucesso","Adicionado o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> a residência.",5000)
								end
								generateWebhook(user_id,{ transaction = "addmorador", message = "Adicionado o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> a residência "..homeName })
							end
						else
							TriggerClientEvent("Notify",source,"negado","Passaporte inválido.",5000)
						end 
					end
				elseif action == "rchave" then 
					local nplayer = vRP.prompt(source, "Insira o passaporte que deseja remover de sua residência","0")
					if nplayer and nplayer ~= "" and parseInt(nplayer) > 0 then 
						local nuser_id = parseInt(nplayer)
						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local userConsult
							if (homeName):find "Apartamento" then
								userConsult = vRP.query("vRP/selectAP2",{ name = homeName, user_id = nuser_id, number = consult[1]["number"] })
							else
								userConsult = vRP.query("homes/userPermissions",{ user_id = nuser_id, name = homeName })
							end

							if userConsult[1] then
								vRP.execute("homes/removePermissions",{ name = homeName, user_id = nuser_id })
								TriggerClientEvent("Notify",source,"sucesso","Removido o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> da residência.",5000)
								generateWebhook(user_id,{ transaction = "remmorador", message = "Removido o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> da residência "..homeName })
							else
								TriggerClientEvent("Notify",source,"negado","Não foi possível encontrar o passaporte <b>"..vRP.format(nuser_id).."</b> na residência.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"negado","Passaporte inválido.",5000)
						end
					end
				elseif action == "upgrade" then 
					local oldType = consult[1]["interior"]
					TriggerClientEvent("dynamic:closeSystem2", source)

					vCLIENT.showOptions(source,2,newInterior)

					local actived = {}
					RegisterServerEvent("homes:interiorCheck")
					AddEventHandler("homes:interiorCheck",function(interiorType)
						local user_id = user_id
						if not actived[user_id] then 
							actived[user_id] = true
							TriggerClientEvent("dynamic:closeSystem2", source)
							if interiorType ~= oldType then 
								if vRP.request(source, "Você deseja visitar o novo interior antes de fazer a alteração ?, recuse para prosseguir com a compra e alteração.", 6000) then 
									vCLIENT.entranceHomes(source,homeName,interiorType,false,0,true)
								else
									if vRP.request(source, "O valor do novo interior é de <b>$"..vRP.format(newInterior[interiorType]["valor"]).."</b>, deseja comprar ?", 6000) then 
										if vRP.tryFullPayment(user_id,newInterior[interiorType]["valor"]) then 
											if (homeName):find "Apartamento" then 
												vRP.execute("vRP/updateInterior2",{ interior = interiorType, name = homeName, number = consult[1]["number"], user_id = user_id })
												TriggerClientEvent("Notify",source,"sucesso","Interior atualizado com sucesso.",6000)
											else
												vRP.execute("vRP/updateInterior",{ interior = interiorType, name = homeName, user_id = user_id })
												TriggerClientEvent("Notify",source,"sucesso","Interior atualizado com sucesso.",6000)
											end
											generateWebhook(user_id,{ transaction = "upgrade", message = "O Jogador realizou a troca de interior na residência : "..homeName.." por $"..newInterior[interiorType]["valor"].."" })
										else
											TriggerClientEvent("Notify",source,"negado","Dinheiro Insuficiente.",6000)
										end
									end
								end
							else
								TriggerClientEvent("Notify",source,"negado","Escolha um interior diferente do seu atual",5000)
							end
						end 		
					end)
				end
			end
			
			if action == "trancar" then 
				if consult[1] then 
					if (homeName):find "Apartamento" then
						return 
					end

					if homeLock[homeName] then
						homeLock[homeName] = nil
						TriggerClientEvent("Notify",source,"aviso","Trancada.",3000)
					else
						homeLock[homeName] = true
						TriggerClientEvent("Notify",source,"aviso","Destrancada.",3000)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("spawnModule:spawnCharacter",function(source,user_id)
	vCLIENT.updateHomes(source,homes)
	if homeEnter[user_id] then 
		local checkHomes = exports["oxmysql"]:query_async("SELECT * FROM characters_homes WHERE name = ? AND number = ?",{  homeEnter[user_id][1],homeEnter[user_id][2] or 1 })
		if checkHomes[1] then 
			vCLIENT.entranceHomes(source,checkHomes[1].name,homesInterior[checkHomes[1].name],false,checkHomes[1].number)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if homeEnter[user_id] then
		local homeName = homeEnter[user_id][1]
		vRP.updateHomes(user_id,homes[homeName][1],homes[homeName][2],homes[homeName][3])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FETCH PLAYER HOUSES
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.fetchMyHouses()
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id then 
		local myHomes = vRP.query("homes/userList",{ user_id = parseInt(user_id) })
		if parseInt(#myHomes) >= 1 then
			return myHomes
		end
	end	
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.checkPermissions(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local checkExist = vRP.query("homes/permissions",{ name = homeName })
		if checkExist[1] then
			local consult = vRP.query("homes/userPermissions",{ name = homeName, user_id = user_id })
			if consult[1] or vRP.hasPermission(user_id,"policia.permissao") then
				return true
			else
				if not homeLock[homeName] then
					TriggerClientEvent("Notify",source,"vermelho","Trancada.",3000)
				else
					return true
				end
			end
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:clotheSystem")
AddEventHandler("homes:clotheSystem",function(action)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and homeEnter[user_id] then
		local basic = vRP.getSData("wardrobe:"..user_id)
		local consult = json.decode(basic) or {}
		if action == "save" then
			TriggerClientEvent("dynamic:closeSystem2", source)
			local custom = vRPC.getCustomPlayer(source)
			local nameFit = vRP.prompt(source, "Insira o nome do outfit.", "")
			if nameFit ~= "" then 
				if consult[nameFit] == nil and string.len(nameFit) > 0 then
					consult[nameFit] = custom
					vRP.setSData("wardrobe:"..user_id,json.encode(consult))
					TriggerClientEvent("Notify",source,"sucesso","Outfit <b>"..nameFit.."</b> adicionado.",5000)
				else
					TriggerClientEvent("Notify",source,"aviso","Outfit escolhido já existe em seu armário de roupas.",5000)
				end
			end
		elseif action == "delete" then 
			TriggerClientEvent("dynamic:closeSystem2", source)
			local nameFit = vRP.prompt(source, "Insira o nome do outfit.", "")
			if nameFit ~= "" then 
				if consult[nameFit] ~= nil and string.len(nameFit) > 0 then
					consult[nameFit] = nil
					vRP.setSData("wardrobe:"..user_id,json.encode(consult))
					TriggerClientEvent("Notify",source,"sucesso","Outfit <b>"..nameFit.."</b> removido.",5000)
				else
					TriggerClientEvent("Notify",source,"negado","Outfit escolhido não existe em seu armário de roupas.",5000)
				end
			end
		else
			if consult[action] ~= nil and string.len(action) > 0 then
				TriggerClientEvent("updateRoupas",source,consult[action])
				TriggerClientEvent("Notify",source,"sucesso","Outfit <b>"..action.."</b> aplicado.",5000)
			else
				TriggerClientEvent("Notify",source,"negado","Outfit escolhido não existe em seu armário de roupas.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURN CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.myClothes() 
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and homeEnter[user_id] then
		return json.decode(vRP.getSData("wardrobe:"..user_id)) or {}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVADIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("invadir",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			local homeName = nearestHomes(source)
			if homeName then
				if args[1] then 
					enterHomes(source,homeName,false,args[1])
				else
					enterHomes(source,homeName,false)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYHOUSEOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.applyHouseOpen(homeName,homeCaller)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not homeEnter[user_id] then 
			homeEnter[user_id] = { homeName,homeCaller }
		end 
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEHOUSEOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.removeHouseOpen()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if homeEnter[user_id] then
			SetPlayerRoutingBucket(source, 0)
			homeEnter[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTER HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function enterHomes(source,homeName,status,user)
	if (homeName):find "Apartamento" then 
		local checkExist = vRP.query("homes/userPermissions",{ name = homeName, user_id = parseInt(user) })
		if checkExist[1] then
			homesInterior[homeName] = checkExist[1]["interior"]
			vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],status,checkExist[1]["number"])
			return
		end
	end
	
	local checkExist = vRP.query("homes/permissions",{ name = homeName })
	if checkExist[1] then
		homesInterior[homeName] = checkExist[1]["interior"]
	else
		if homesInterior[homeName] == nil then
			homesInterior[homeName] = newInterior[math.random(#newInterior)]["interior"]
		end
	end

	vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],status)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	Citizen.Wait(1500)
	vCLIENT.updateHomes(-1,homes)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local homesInfos = exports["oxmysql"]:executeSync("SELECT * FROM characters_homes WHERE tax > 0 AND owner = 1")
    for k,v in pairs(homesInfos) do 
        if parseInt(os.time()) >= parseInt(v["tax"] + 24 * 30 * 60 * 60) then
            if string.find(v["name"],"Apartamento") then 
				vRP.execute("vRP/deleteAP",{ name = homeName, number = v["number"] })
				exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"chest:"..v["name"]..v["number"]})
				exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"wardrobe:"..v["name"]})
            else
                vRP.execute("homes/selling",{ name = v["name"] })
				exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"chest:"..v["name"]})
				exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"wardrobe:"..v["name"]})
            end
        end
    end
end)