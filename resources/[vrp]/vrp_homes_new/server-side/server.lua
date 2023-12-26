-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cO = {}
Tunnel.bindInterface("vrp_homes",cO)
Proxy.addInterface("vrp_homes",cO)

vCLIENT = Tunnel.getInterface("vrp_homes")
srv = Proxy.getInterface('nxgroup_inventario')
vTASKBAR = Tunnel.getInterface('np-taskbarskill')

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
------------------------------------------------------------------------------------------------------------------------------------------
-- BACK
vRP._prepare("selectAll","SELECT * FROM core_residences")
vRP._prepare("insertIntHouses","UPDATE core_homes SET interior = @interior WHERE name = @name")
vRP._prepare("insertHouses","INSERT INTO core_residences(name,x,y,z,interiorType,intPrice,slot,trade) VALUES(@name,@x,@y,@z,@interiorType,@intPrice,@slot,@trade)")
vRP._prepare("selectcHouse","SELECT * FROM core_residences WHERE name = @name")
vRP._prepare("deleteHouse","DELETE FROM core_residences WHERE name = @name")
-- AP

vRP._prepare("vRP/deleteAP","DELETE FROM core_homes WHERE name = @name AND number = @number")

vRP._prepare("selectAP2","SELECT * FROM core_homes WHERE name = @name AND number = @number AND user_id = @user_id")
vRP._prepare("selectAppartment","SELECT * FROM core_homes WHERE name = @name AND number = @number")
vRP._prepare("selectOwner","SELECT * FROM core_homes WHERE name = @name AND number = @number AND owner = 1")

vRP._prepare("secondOwnerAP","INSERT INTO core_homes(name,interior,user_id,owner,number) VALUES(@name,@interior,@user_id,@owner,@number)")
vRP._prepare("homes/countHouses","SELECT houses FROM vrp_users WHERE id = @user_id")
vRP._prepare("homes/countPerms","SELECT perms FROM vrp_users WHERE id = @user_id")
vRP._prepare("homes/selling","DELETE FROM core_homes WHERE name = @name")
vRP._prepare("homes/permissions","SELECT * FROM core_homes WHERE name = @name")
vRP._prepare("homes/updateTax","UPDATE core_homes SET tax = @tax WHERE name = @name")
vRP._prepare("homes/userOwnermissions","SELECT * FROM core_homes WHERE name = @name AND owner = 1")
vRP._prepare("homes/userList","SELECT * FROM core_homes WHERE user_id = @user_id")
vRP._prepare("homes/countUsers","SELECT COUNT(*) as qtd FROM core_homes WHERE user_id = @user_id AND owner = 1")
vRP._prepare("homes/countPerms2","SELECT COUNT(*) as qtd FROM core_homes WHERE user_id = @user_id AND owner = 0")
vRP._prepare("homes/countPermissions","SELECT COUNT(*) as qtd FROM core_homes WHERE name = @name")
vRP._prepare("homes/removePermissions","DELETE FROM core_homes WHERE name = @name AND user_id = @user_id")
vRP._prepare("homes/userPermissions","SELECT * FROM core_homes WHERE name = @name AND user_id = @user_id")
vRP._prepare("homes/getVault","SELECT vault FROM core_homes WHERE name = @name")
vRP._prepare("homes/updateVault","UPDATE core_homes SET vault = vault + @vault WHERE name = @name AND owner = 1")
vRP._prepare("homes/updateFridge","UPDATE core_homes SET fridge = fridge + @fridge WHERE name = @name AND owner = 1")
vRP._prepare("homes/updateOwner","UPDATE core_homes SET user_id = @nuser_id WHERE user_id = @user_id AND name = @name")
vRP._prepare("homes/newPermissions","INSERT INTO core_homes(name,interior,user_id,owner) VALUES(@name,@interior,@user_id,@owner)")
vRP._prepare("buyAppartment","INSERT INTO core_homes(name,interior,tax,price,user_id,residents,vault,fridge,owner,number) VALUES(@name,@interior,@tax,@price,@user_id,@residents,@vault,@fridge,1,@number)")
vRP._prepare("homes/buying","INSERT INTO core_homes(name,interior,tax,price,user_id,residents,vault,fridge,owner) VALUES(@name,@interior,@tax,@price,@user_id,@residents,@vault,@fridge,1)")
vRP._prepare("homes/get_allvehs","SELECT * FROM vrp_vehicles")
vRP._prepare("homes/get_casas","SELECT * FROM core_homes")
vRP._prepare("homes/fullGarages","SELECT * FROM homes_garages")
vRP._prepare("homes/getGarages","SELECT * FROM homes_garages WHERE name = @name")
vRP._prepare("homes/setGarage","INSERT INTO homes_garages SET name = @name, xblip = @xblip, yblip = @yblip, zblip = @zblip, xspawn = @xspawn, yspawn = @yspawn, zspawn = @zspawn, hspawn = @hspawn")
vRP._prepare("homes/removeGarages","DELETE FROM homes_garages WHERE name = @name")
vRP._prepare("nyoHomes/remove_ticket", "UPDATE vrp_user_moneys SET t1 = @t1, t2 = @t2, t3 = @t3 WHERE user_id = @user_id")
vRP._prepare("nyoHomes/get_ticket", "SELECT * FROM vrp_user_moneys WHERE user_id = @user_id")
vRP._prepare("nyoHomes/del_homes", "SELECT * FROM vrp_homes_permissions WHERE tax < @time AND tax NOT IN ('')")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local homeLock = {}
local homeEnter = {}
local theftTimers = {}
local networkHouses = {}
homesInterior = {}
homes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEW INTERIOR -- TRADE
-----------------------------------------------------------------------------------------------------------------------------------------
local newInterior = {
	-- Apartamento Com Vista
	["AppartmentFavela2"] = { ["interior"] = vector3(1932.9672851563, -298.01147460938, 248.72827148438), ["vaultCoords"] = vector3(1936.9300537109, -297.1496887207, 248.62005615234), ["wardobeCoords"] = vector3(1939.7064208984, -296.76147460938, 248.62005615234), ["residents"] = 3, ["vault"] = 250, ["fridge"] = 50 },
	["AppartmentFavela"] = { ["interior"] = vector3(747.00256347656, 228.58323669434, 135.4302520752), ["vaultCoords"] = vector3(748.36901855469, 232.64164733887, 135.4302520752), ["wardobeCoords"] = vector3(750.61126708984, 234.11151123047, 135.43028259277), ["residents"] = 3, ["vault"] = 250, ["fridge"] = 50 },
	["AppartmentConker"] = { ["interior"] = vector3(373.5309753418, 423.78149414063, 145.90789794922), ["vaultCoords"] = vector3(369.06936645508, 407.71630859375, 142.10029602051), ["wardobeCoords"] = vector3(374.4772644043, 411.91586303711, 142.10026550293), ["residents"] = 3, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentFloors"] = { ["interior"] = vector3(-734.92254638672, -2253.6564941406, -2.8349561691284), ["vaultCoords"] = vector3(-735.11059570313, -2238.2971191406, -6.6561388969421), ["wardobeCoords"] = vector3(-739.37042236328, -2243.4594726563, -6.6567368507385), ["residents"] = 3, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentSquare3"] = { ["interior"] = vector3(-83.991104125977, -820.9462890625, 139.88084411621), ["vaultCoords"] = vector3(-71.516181945801, -815.92712402344, 139.28059387207), ["wardobeCoords"] = vector3(-58.797672271729, -814.5126953125, 142.68099975586), ["residents"] = 3, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentSquare2"] = { ["interior"] = vector3(-83.681755065918, -818.27709960938, 162.5016784668), ["vaultCoords"] = vector3(-70.507888793945, -814.32501220703, 161.90144348145), ["wardobeCoords"] = vector3(-57.745742797852, -814.05737304688, 165.30409240723), ["residents"] = 3, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentSquare"] = { ["interior"] = vector3(-81.982757568359, -817.75921630859, 201.1597442627), ["vaultCoords"] = vector3(-69.034133911133, -813.98077392578, 200.55912780762), ["wardobeCoords"] = vector3(-56.376396179199, -813.81817626953, 203.95959472656), ["residents"] = 3, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentMax"] = { ["interior"] = vector3(-1448.28, -530.68, 44.04), ["vaultCoords"] = vector3(-1452.91, -543.54, 43.44), ["wardobeCoords"] = vector3(-1451.83, -547.86, 46.84), ["residents"] = 2, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentMax2"] = { ["interior"] = vector3(-774.22, 342.10, 196.68), ["vaultCoords"] = vector3(-766.01, 331.35, 196.08), ["wardobeCoords"] = vector3(-760.89, 319.56, 199.48), ["residents"] = 2, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentMax3"] = { ["interior"] = vector3(-784.55364990234, 323.65466308594, 211.99711608887), ["vaultCoords"] = vector3(-766.73522949219, 328.37292480469, 211.396484375), ["wardobeCoords"] = vector3(-790.78033447266, 330.59237670898, 210.79650878906), ["residents"] = 3, ["vault"] = 500, ["fridge"] = 50 },
	-- Apartamentos
	["AppartmentLuxuous"] = { ["interior"] = vector3(129.33, -1162.08, 765.81), ["vaultCoords"] = vector3(139.71, -1153.41, 765.2), ["wardobeCoords"] = vector3(141.35, -1149.26, 768.61), ["residents"] = 2, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentLuxuous2"] = { ["interior"] = vector3(146.86, -1124.79, 765.81), ["vaultCoords"] = vector3(157.88, -1116.85, 765.21), ["wardobeCoords"] = vector3(169.20596313477, -1111.8032226563, 768.60034179688), ["residents"] = 3, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentLuxuous3"] = { ["interior"] = vector3(105.21, -1130.16, 765.81), ["vaultCoords"] = vector3(116.03, -1122.3, 765.21), ["wardobeCoords"] = vector3(127.72451782227, -1117.1735839844, 768.59979248047), ["residents"] = 3, ["vault"] = 500, ["fridge"] = 50 },
	["AppartmentMiddle"] = { ["interior"] = vector3(190.09, -1156.66, 771.21), ["vaultCoords"] = vector3(198.68, -1155.3, 771.22), ["wardobeCoords"] = vector3(211.61, -1156.35, 765.01), ["residents"] = 3, ["vault"] = 300, ["fridge"] = 50 },
	["AppartmentBasic"] = { ["interior"] = vector3(152.89, -1193.93, 763.0), ["vaultCoords"] = vector3(148.1, -1189.23, 765.0), ["wardobeCoords"] = vector3(146.66, -1190.68, 765.0), ["residents"] = 3, ["vault"] = 300, ["fridge"] = 50 },
	["AppartmentMotel"] = { ["interior"] = vector3(-0.8177450299263, -3.3784673213959, 765.0), ["vaultCoords"] = vector3(-1.0689628124237, 1.18399477005, 765.0), ["wardobeCoords"] = vector3(-0.49, 3.05, 765.0), ["residents"] = 3, ["vault"] = 300, ["fridge"] = 10  },
	-- CASAS
	["Mansion"] = { ["interior"] = vector3(211.55668640137, -1116.2392578125, 770.40191650391), ["vaultCoords"] = vector3(195.22, -1117.21, 769.38), ["wardobeCoords"] = vector3(197.31425476074, -1127.0219726563, 765.00854492188), ["residents"] = 3, ["vault"] = 750, ["fridge"] = 100 },
	["Luxuous"] = { ["interior"] = vector3(199.2, -1199.18, 764.81), ["vaultCoords"] = vector3(204.68, -1185.0, 764.81), ["wardobeCoords"] = vector3(203.51, -1179.76, 764.81), ["residents"] = 3, ["vault"] = 350, ["fridge"] = 35 },
	["Middle"] = {["interior"] = vector3(175.24, -1164.19, 765.01), ["vaultCoords"] = vector3(170.47, -1158.39, 765.00), ["wardobeCoords"] = vector3(179.25, -1158.61, 765.01), ["residents"] = 3, ["vault"] = 250, ["fridge"] = 50 },
	["Trailer"] = { ["interior"] = vector3(205.11, -1143.87, 765.42), ["vaultCoords"] = vector3(210.68, -1143.94, 765.43), ["wardobeCoords"] = vector3(200.26, -1143.78, 765.41), ["residents"] = 3, ["vault"] = 200, ["fridge"] = 50 },	
	["Basic"] = { ["interior"] = vector3(172.22, -1193.22, 764.99), ["vaultCoords"] = vector3(169.41,-1193.71,765.0), ["wardobeCoords"] = vector3(167.97, -1191.69, 765.0), ["residents"] = 3, ["vault"] = 150, ["fridge"] = 20  },
}

-- src.getHomeChsestSize = function()
-- 	return homes
-- end	
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread( function()
	Wait(1000)
	local houseName = vRP.query("selectAll")
	for k,v in pairs(houseName) do 
		homes[v["name"]] = { tonumber(v["x"]),tonumber(v["y"]),tonumber(v["z"]),v["interiorType"],v["intPrice"],v["slot"],v["trade"] }
	end
end)
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

			if string.find(homeName,"Appartament") then 
				local ownerConsult = vRP.query("selectOwner",{ name = homeName, number = homeNumber })
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
			end

			local checkExist = vRP.query("homes/userOwnermissions",{ name = homeName })
			if checkExist[1] then 
				local myInterior = newInterior[interiorType]

				if GetPlayerRoutingBucket(source) == 0 then
					SetPlayerRoutingBucket(source, parseInt(checkExist[1]["user_id"]))
					if checkExist[1]["interior"] ~= interiorType then
						myInterior = newInterior[checkExist[1]["interior"]]
					end
					return myInterior
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REF TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local defaultInteriors = {
	[1] = { "AppartmentFavela2" },
	[2] = { "AppartmentFavela" },
	[3] = { "AppartmentConker" },
	[4] = { "AppartmentFloors" },
	[5] = { "AppartmentSquare3" },
	[6] = { "AppartmentSquare2" },
	[7] = { "AppartmentSquare" },
	[8] = { "AppartmentMax" },
	[9] = { "AppartmentMax2" },
	[10] = { "AppartmentMax3" },
	[11] = { "AppartmentLuxuous" },
	[12] = { "AppartmentLuxuous2" },
	[13] = { "AppartmentLuxuous3" },
	[14] = { "AppartmentMiddle" },
	[15] = { "AppartmentBasic" },
	[16] = { "Mansion" },
	[17] = { "Luxuous" },
	[18] = { "Middle" },
	[19] = { "Trailer" },
	[20] = { "Basic" },
	[21] = { "AppartmentMotel" },
	[22] = { "AppartmentConker" },
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- STAFF MANAGEMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("casa",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.hasPermission(user_id,"ceo.permissao") then 
		if args[1] == "add" then 
			local type = vRP.prompt(source, "Digite 1 para Residência ou 2 para condominio", "")
			if type == "1" then 
				local number = vRP.prompt(source, "Insira o número da casa, deve ser acima de 1186", "")
				if parseInt(number) <= 1184 then TriggerClientEvent("Notify",source,"negado","Insira um numero maíor que 1186",6000) return end 
				local checkExist = vRP.query("selectcHouse", { name = "Homes"..number })
				if checkExist[1] then TriggerClientEvent("Notify",source,"negado","Essa casa já existe",5000) return end 
				local interior = vRP.prompt(source, "Insira o tipo do interior, cheque no /house interior, numero entre 1 e 21", "")
				if interior == "" then return end

				if parseInt(interior) >= 23 then TriggerClientEvent("Notify",source,"negado","Este interior não pertence a uma casa") return end 

				local interiorType = defaultInteriors[parseInt(interior)][1]
				local price = vRP.prompt(source, "Insira o valor da casa", "0")
				if parseInt(price) > 0 then 
					local coords = GetEntityCoords(GetPlayerPed(source))
					homes["Homes"..number] = { coords.x,coords.y,coords.z,interiorType,parseInt(price),0,0 }
					vRP.execute("insertHouses",{ name = "Homes"..number, x = coords.x, y = coords.y, z = coords.z, interiorType = interiorType, intPrice = parseInt(price), slot = 0, trade = 0  })
					Wait(500)
					vCLIENT.updateHomes(-1,homes)
				end
			elseif type == "2" then 
				local number = vRP.prompt(source, "Insira o número do condominio, deve ser acima de 2", "")
				if parseInt(number) <= 2 then TriggerClientEvent("Notify",source,"negado","Insira um numero maíor que 2",6000) return end 
				local checkExist = vRP.query("selectcHouse", { name = "Appartament"..number })
				if checkExist[1] then TriggerClientEvent("Notify",source,"negado","Esse condominio já existe",5000) return end 
				local interior = vRP.prompt(source, "Insira o tipo do interior, cheque no /house interior, numero entre 1 e 13", "")
				if interior == "" then return end
				if parseInt(interior) >= 23 then TriggerClientEvent("Notify",source,"negado","Este interior não pertence a um apartamento") return end 
				local interiorType = defaultInteriors[parseInt(interior)][1]
				local price = vRP.prompt(source, "Insira o valor da casa", "0")
				if parseInt(price) > 0 then 
					local slot = vRP.prompt(source, "Insira o máximo de moradores do condomínio", "10")
					if parseInt(slot) > 0 then 
					local trade = vRP.prompt(source, "Deseja que o apartamento valorize? Se sim insira o quanto vai aumentar a cada venda", "0")
						if parseInt(trade) > 0 then 
							local coords = GetEntityCoords(GetPlayerPed(source))
							homes["Appartament"..number] = { coords.x,coords.y,coords.z,interiorType,parseInt(price),parseInt(slot),parseInt(trade) }
							vRP.execute("insertHouses",{ name = "Appartament"..number, x = coords.x, y = coords.y, z = coords.z, interiorType = interiorType, intPrice = parseInt(price), slot = parseInt(slot), trade = parseInt(trade)   })
							Wait(500)
							vCLIENT.updateHomes(-1,homes)
						end
					end
				end
			end
		elseif args[1] == "rem" then 
			local homeName = nearestHomes(source)
			if homeName then 
				local choice = vRP.request(source, "Deseja deletar a residência e remover todos moradores ? ", 60)
				if choice then 
					vRP.execute("deleteHouse",{ name = homeName })
					vRP.execute("homes/selling",{ name = homeName })
					vRP.remSrvdata("wardrobe:"..homeName)
					vRP.remSrvdata("fridge:"..homeName)
					vRP.remSrvdata("vault:"..homeName)
					homes[homeName] = nil
					vCLIENT.updateHomes(-1,homes)
				end
			end
		elseif args[1] == "interiores" then 
			for k,v in pairs(defaultInteriors) do 
				mensagem = k..": <b>"..defaultInteriors[k][1]
				TriggerClientEvent("Notify",source,"aviso",mensagem,10000)
			end
		end
	end
end)
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
	local rows = vRP.query("selectAppartment",{ name = homeName, number = number })
	if rows[1] then 
		return rows[1].user_id
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
RegisterCommand("casas",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then 
		local homesList = vRP.query("homes/userList",{ user_id = user_id })
		if parseInt(#homesList) >= 1 then
			for k,v in pairs(homesList) do
				if string.find(v["name"],"Appartament") then 
					if parseInt(os.time()) >= parseInt(v["tax"] + 24 * 15 * 60 * 60) then
						TriggerClientEvent("Notify",source,"sucesso","<b>Apartamento:</b> "..v["name"].."<br> <b>Interfone:</b> " ..v["number"].."<br> <b>Taxa:</b> Vencida",20000)
					else
						TriggerClientEvent("Notify",source,"sucesso","<b>Apartamento:</b> "..v["name"].."<br> <b>Interfone:</b> " ..v["number"].."<br> <b>Taxa:</b> "..vRP.getDayHours(86400 * 15 - (os.time() - v["tax"])).." ",20000)
					end
				else
					TriggerClientEvent("Notify",source,"sucesso","<b>Residência:</b> "..v["name"].."<br> <b>Taxa:</b> "..vRP.getDayHours(86400 * 15 - (os.time() - v["tax"])).." ",20000)
				end
			end
		else
			TriggerClientEvent("Notify",source,"negado","Você não possuí residências",6000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOUSES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:invokeSystem")
AddEventHandler("homes:invokeSystem",function(action)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then 
		local homeName = nearestHomes(source) --[[or tostring(args[1])]]
		if homes[tostring(homeName)] then 
			TriggerClientEvent("dynamic2:closeSystem2", source)

			if action == "visitar" then 
				homesInterior[homeName] = homes[homeName][4]
				vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false,0,true)
			elseif action == "buyHouse" then 
				local checkExist = vRP.query("homes/permissions",{ name = homeName })
				if checkExist[1] == nil then
					local value = vRP.getUData(parseInt(user_id),"vRP:multas")
					-- local multas = srv.verify_multas(user_id)
					-- if multas < 0 then
					-- 	TriggerClientEvent("Notify",source,"negado","Você tem multas pendentes.",10000)
					-- 	return
					-- end

					local maxHomes = vRP.query("homes/countUsers",{ user_id = user_id })
					local myHomes = vRP.query("homes/countHouses",{ user_id = user_id })[1]["houses"]

					if parseInt(maxHomes[1]["qtd"]) >= myHomes then
						TriggerClientEvent("Notify",source,"negado","Você atingiu o máximo de residências! Para ter mais contate a prefeitura.",3000)
						return
					end

					local interiorSelect = homes[homeName][4]
					local homesPrice = homes[homeName][5]

					if  buyHomeVip(user_id, interiorSelect,homesPrice,false) then                    
						if vRP.request(source,"Deseja comprar a residência <b>"..interiorSelect.."</b> utlizando seu benefício VIP? </b>",30) then
								buyHomeVip(user_id, interiorSelect,homesPrice,true)
							    vRP.execute("homes/buying",{ name = homeName, user_id = user_id, interior = interiorSelect, tax = os.time(), price = homesPrice, residents = newInterior[interiorSelect]["residents"], vault = newInterior[interiorSelect]["vault"], fridge = newInterior[interiorSelect]["fridge"] })
                                TriggerClientEvent("Notify",source,"sucesso","Compra concluída.",5000)
								sendLog('CasasComprarVip',"[ID]: "..user_id.." \n[COMPROU A CASA COM VIP]: "..homeName.." \n[VALOR]: $"..homesPrice.." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true) 
                                return
                        end
					else 
						if vRP.request(source,"Deseja comprar a residência <b>"..interiorSelect.."</b> por <b>$"..vRP.format(homesPrice).."</b> dólares?",30) then
							if vRP.tryFullPayment(user_id,homesPrice) then
								vRP.execute("homes/buying",{ name = homeName, user_id = user_id, interior = interiorSelect, tax = os.time(), price = homesPrice, residents = newInterior[interiorSelect]["residents"], vault = newInterior[interiorSelect]["vault"], fridge = newInterior[interiorSelect]["fridge"] })
								TriggerClientEvent("Notify",source,"sucesso","Compra concluída.",5000)
								sendLog('CasasComprar',"[ID]: "..user_id.." \n[COMPROU A CASA]: "..homeName.." \n[VALOR]: $"..homesPrice.." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true) 
							else
								TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
							end
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
                        if multas < 0 then
                            TriggerClientEvent("Notify",source,"negado","Você tem multas pendentes.",10000)
                            return
                        end
    
                        local maxHomes = vRP.query("homes/countUsers",{ user_id = user_id })
                        local myHomes = vRP.query("homes/countHouses",{ user_id = user_id })[1]["houses"]
    
                        if parseInt(maxHomes[1]["qtd"]) >= myHomes then
                            TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de residências.",3000)
                            return
                        end

                        -- if vRP.getInventoryItemAmount(user_id,"casavip") >= 1 then 
						--     if vRP.request(source,"Deseja comprar a residência <b>"..interiorSelect.."</b> utlizando o bonus VIP ? </b>",30) then
                        --         if vRP.tryGetInventoryItem(user_id, "casavip", 1) then 
                        --             vRP.execute("buyAppartment",{ name = homeName, user_id = user_id, interior = homes[homeName][4], tax = os.time(), price = homesPrice, number = parseInt(slot), residents = newInterior[interiorSelect]["residents"], vault = newInterior[interiorSelect]["vault"], fridge = newInterior[interiorSelect]["fridge"] })
                        --             TriggerClientEvent("Notify",source,"sucesso","Compra concluída.",5000)
                        --             return
                        --         end
                        --     end
                        -- end

						if  buyHomeVip(user_id, interiorSelect,homesPrice,false) then                    
							if vRP.request(source,"Deseja comprar a residência <b>"..interiorSelect.."</b> utlizando seu benefício VIP? </b>",30) then
									buyHomeVip(user_id, interiorSelect,homesPrice,true)
									vRP.execute("buyAppartment",{ name = homeName, user_id = user_id, interior = homes[homeName][4], tax = os.time(), price = homesPrice, number = parseInt(slot), residents = newInterior[interiorSelect]["residents"], vault = newInterior[interiorSelect]["vault"], fridge = newInterior[interiorSelect]["fridge"] })
									TriggerClientEvent("Notify",source,"sucesso","Compra concluída.",5000)
									sendLog('ApComprarVip',"[ID]: "..user_id.." \n[COMPROU O APT COM TICKET VIP]: "..homeName.." \n[VALOR]: $"..homesPrice.." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true) 
									return
							end
						else 
							
							if vRP.request(source,"Deseja comprar a residência <b>"..interiorSelect.."</b> por <b>$"..vRP.format(homesPrice).."</b> dólares?",30) then
								if vRP.tryFullPayment(user_id,homesPrice) then			
									vRP.execute("buyAppartment",{ name = homeName, user_id = user_id, interior = homes[homeName][4], tax = os.time(), price = homesPrice, number = parseInt(slot), residents = newInterior[interiorSelect]["residents"], vault = newInterior[interiorSelect]["vault"], fridge = newInterior[interiorSelect]["fridge"] })
									TriggerClientEvent("Notify",source,"sucesso","Compra concluída.",5000)
									sendLog('ApComprar',"[ID]: "..user_id.." \n[COMPROU O APT]: "..homeName.." \n[VALOR]: $"..homesPrice.." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true) 
								else		
									TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
								end
							end
						end
					else
						TriggerClientEvent("Notify",source,"negado","Todos apartamentos já foram vendidos.",6000)
					end
				else
					TriggerClientEvent("Notify",source,"negado","Você já possuí um apartamento neste condomínio",6000)
				end
			elseif action == "interfone" then 
				if homes[homeName][6] >= 1 then
					local consult = vRP.query("homes/userPermissions",{ name = homeName, user_id = user_id })
					if consult[1] and consult[1].number then 
						local myInterfone = consult[1].number
						local interfone = vRP.prompt(source, "Insira o número do apartamento", myInterfone)
						if interfone ~= "" and parseInt(interfone) > 0 then 
							
							local myAppartment = getFreeAppartment(homeName,parseInt(interfone))
							if myAppartment then
								homesInterior[homeName] = homes[homeName][4]
								if parseInt(myInterfone) ~= parseInt(interfone) then
	
									local playerOne = vRP.getUserSource(parseInt(myAppartment))
									if playerOne then 
										local identity = vRP.getUserIdentity(user_id)
										local onChoice = vRP.request(playerOne, identity["name"].." "..identity["firstname"].." Está tocando sua campainha, deseja aceitar ?" , 60)
										if onChoice then 
											vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false,parseInt(interfone))
											return 
										else
											TriggerClientEvent("Notify",source,"aviso","Sua solicitação foi recusada.",10000)
											return false
										end
									else
										TriggerClientEvent("Notify",source,"negado","O morador está fora da cidade.",10000)
										return false
									end
								end
								
								local ownerConsult = vRP.query("selectOwner",{ name = homeName, number = consult[1].number })
								if parseInt(os.time()) >= parseInt(ownerConsult[1]["tax"] + 24 * 15 * 60 * 60) then
									TriggerClientEvent("Notify",source,"aviso","As taxas da propriedade estão atrasadas.",10000)
									return false
								end

								vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false,parseInt(interfone))
								if parseInt(consult[1]["owner"]) >= 1 then 
									TriggerClientEvent("Notify",source,"aviso","Taxa em : "..vRP.getDayHours(86400 * 15 - (os.time() - consult[1]["tax"])),10000)
								end
								return
							end
						end
					else
						local interfone = vRP.prompt(source, "Insira o número do apartamento","0")
						if interfone ~= "" and parseInt(interfone) > 0 then 
							local myAppartment = getFreeAppartment(homeName,parseInt(interfone))
							if myAppartment then
								homesInterior[homeName] = homes[homeName][4]
								if user_id ~= myAppartment then
									local playerOne = vRP.getUserSource(parseInt(myAppartment))
									if playerOne then 
										local identity = vRP.getUserIdentity(user_id)
										local onChoice = vRP.request(playerOne, identity["name"].." "..identity["firstname"].." Está tocando sua campainha, deseja aceitar ?" , 60)
										if onChoice then 
											vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false,parseInt(interfone))
											return 
										else
											TriggerClientEvent("Notify",source,"aviso","Sua solicitação foi recusada.",10000)
											return false
										end
									else
										TriggerClientEvent("Notify",source,"negado","O morador está fora da cidade.",10000)
										return false
									end
								end
							end
						end
					end
					return
				end
			elseif action == "list" then 
                if string.find(homeName,"Appartament") then 
					local permList = ""
					local query = vRP.query("homes/userPermissions",{ name = homeName, user_id = user_id })
                    if query[1] then 
						local checkExist = vRP.query("selectAppartment",{ name = homeName, number = query[1].number })
						if checkExist[1] then 
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
                    end
                else
					local permList = ""
                    local checkExist = vRP.query("homes/permissions",{ name = homeName })
					if checkExist[1] then 
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
                end
			elseif action == "enterHouse" then 
				local checkExist = vRP.query("homes/permissions",{ name = homeName })
				if checkExist[1] then
					local ownerConsult = vRP.query("homes/userOwnermissions",{ name = homeName })
					if ownerConsult[1] then
						if parseInt(os.time()) >= parseInt(ownerConsult[1]["tax"] + 24 * 15 * 60 * 60) then
							TriggerClientEvent("Notify",source,"aviso","As taxas da propriedade estão atrasadas.",10000)
							return false
						end
						TriggerClientEvent("Notify",source,"aviso","Taxa em : "..vRP.getDayHours(86400 * 15 - (os.time() - ownerConsult[1]["tax"])),10000)
					end
	
					homesInterior[homeName] = checkExist[1]["interior"]
	
					local consult = vRP.query("homes/userPermissions",{ name = homeName, user_id = user_id })
					if consult[1] then
						vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false)
					else
						if not homeLock[homeName] then
							TriggerClientEvent("Notify",source,"negado","Trancada.",3000)
						else
							local ownerConsult = vRP.query("homes/userOwnermissions",{ name = homeName })
							if ownerConsult[1] then
								if parseInt(os.time()) >= parseInt(ownerConsult[1]["tax"] + 24 * 15 * 60 * 60) then
									TriggerClientEvent("Notify",source,"aviso","As taxas da propriedade estão atrasadas.",10000)
									return false
								end
							end
							vCLIENT.entranceHomes(source,homeName,homesInterior[homeName],false)
						end
					end
				end
			end

			


			-- PARTE DO DONO
			
				
					



			local consult = vRP.query("homes/userPermissions",{ name = homeName, user_id = user_id })
			if consult[1] and consult[1]["owner"] >= 1 then
				if action == "geladeira" then 
					if vRP.request(source,"Deseja aumentar a geladeira por <b>$50.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,50000) then
							vRP.execute("homes/updateFridge",{ name = homeName, fridge = 25 })
							TriggerClientEvent("Notify",source,"sucesso","Compra efetuada.",5000)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$2.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,2000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentMotel" })
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior1" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$2.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,2000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentBasic"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior2" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$2.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,2000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "Trailer"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior3" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$3.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,3000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "Middle"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior4" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$3.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,3000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "Basic"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior5" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentMiddle"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior6" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentFloors"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior7" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentMax"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior8" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentMax2"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior9" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentMax3"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior10" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentSquare"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior11" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentSquare2"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior12" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentSquare3"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior13" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "Luxuous"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior14" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentConker"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior15" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentLuxuous2"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior16" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$8.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,8000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "AppartmentLuxuous3"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "interior17" then 
					if vRP.request(source,"Deseja alterar o interior por <b>$12.000.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,12000000) then
								vRP.execute("insertIntHouses",{ name = homeName, interior = "Mansion"})
								TriggerClientEvent("Notify",source,"sucesso","Interior Alterado. Aguarde 10 segundos para concluirmos a obra.",5000)					
								Wait(500)
								vCLIENT.updateHomes(-1,homes)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end

				elseif action == "baú" then 
					if vRP.request(source,"Deseja aumentar o baú por <b>$200.000</b> dólares?",30) then
						if vRP.tryFullPayment(user_id,200000) then
							vRP.execute("homes/updateVault",{ name = homeName, vault = 150 })
							TriggerClientEvent("Notify",source,"sucesso","Compra efetuada.",5000)
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
						end
					end
				elseif action == "vender" then 
					local homesPrice = parseInt(consult[1]["price"] * 0.02)
					if vRP.request(source,"Deseja concluir a venda por <b>$"..vRP.format(homesPrice).."</b> dólares?",30) then
						local checkOwned 
						if (homeName):find "Appartament" then 
							checkOwned = vRP.query("selectOwner",{ name = homeName, number = consult[1]["number"] })
							if checkOwned[1] then
								vRP.execute("vRP/deleteAP",{ name = homeName, number = consult[1]["number"] })
								exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"chest:"..homeName..consult[1]["number"]})
								vRP.giveBankMoney(user_id,homesPrice)
								TriggerClientEvent("Notify",source,"sucesso","Venda concluída.",5000)
								sendLog('Casasvender',"[ID]: "..user_id.." \nVendeu o Imovel: ["..homeName.."]\n[Por]: "..homesPrice.." \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true)
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
								sendLog('CasasVender',"[ID]: "..user_id.." \nVendeu o Imovel: ["..homeName.."]\n[Por]: "..homesPrice.." \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true) 
							end
						end
					end
				elseif action == "tax" then 
					--if parseInt(os.time()) >= parseInt(consult[1]["tax"] + 24 * 15 * 60 * 60) then
						local homesPrice = parseInt(consult[1]["price"] * 0.12)
						if vRP.hasPermission(user_id, "ilha.permissao") then 
							vRP.execute("homes/updateTax",{ name = homeName, tax = os.time() })
							TriggerClientEvent("Notify",source,"sucesso","Taxa paga pela prefeitura! Obrigado por colaborar com seu imposto VIP.",10000)
							return 
						end
						if vRP.request(source,"Deseja pagar as taxas por <b>$"..vRP.format(homesPrice).."</b> dólares?",30) then
							if vRP.tryFullPayment(user_id,homesPrice) then
								vRP.execute("homes/updateTax",{ name = homeName, tax = os.time() })
								sendLog('pagamentocasas',"[ID]: "..user_id.." \n[CASA]: "..homeName.." \n[VALOR]: $"..vRP.format(homesPrice).." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true)
								TriggerClientEvent("Notify",source,"sucesso","Pagamento efetuado.",10000)
							else
								TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",10000)
							end
						end
					--else
					--	TriggerClientEvent("Notify",source,"negado","Suas taxas não venceram, restam  <b>"..vRP.getDayHours(86400 * 15 - (os.time() - consult[1]["tax"])),10000)
					--end
				elseif action == "garagem" then 
					if string.find(homeName,"Appartament") and string.find(homeName,"Favela") then 
						TriggerClientEvent("Notify",source,"negado","Você não pode comprar garagem.",5000)
						return 
					end
					 local homesGarage = 100000
					 local myGarage = exports["oxmysql"]:singleSync("SELECT name FROM `homes_garages` WHERE `name` = ?", { homeName })
					 if myGarage and myGarage.name then
						 local choice = vRP.request(source, "Já existe uma garagem para essa residência, deseja substitui-la no valor de <b>$"..vRP.format(homesGarage).."</b> dólares ?", 60)
						 if choice then 
							 if vRP.tryFullPayment(user_id,homesGarage) then
								 TriggerClientEvent("Notify",source,"aviso","Fique no local onde vai abrir a garagem e pressione a tecla <b>E</b>.",10000)
								 sendLog('CasasTrocarGaragem',"[TROCO A GARAGEM DE LOCAL]\n[ID]: "..user_id.." \n[CASA]: "..homeName.." \n[VALOR]: $"..vRP.format(homesGarage).." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true)
								 vCLIENT.homeGarage(source,homeName,homes[homeName][1],homes[homeName][2],homes[homeName][3])
							 else
								 TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
							 end
						 end
					 else 
						 if vRP.request(source,"Deseja adicionar a garagem pagando <b>$"..vRP.format(homesGarage).."</b> dólares ?",30) then
							 if vRP.tryFullPayment(user_id,homesGarage) then
								 TriggerClientEvent("Notify",source,"aviso","Fique no local onde vai abrir a garagem e pressione a tecla <b>E</b>.",10000)
								 sendLog('CasasComprarGaragem',"[COMPROU UMA GARAGEM]\n[ID]: "..user_id.." \n[CASA]: "..homeName.." \n[VALOR]: $"..vRP.format(homesGarage).." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true)
								 vCLIENT.homeGarage(source,homeName,homes[homeName][1],homes[homeName][2],homes[homeName][3])
							 else
								 TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
							 end
						 end
					 end
				elseif action == "trans" then 
					local nplayer = vRP.prompt(source, "Insira o passaporte que deseja transferir a residência", "")
					if nplayer and nplayer ~= "" and parseInt(nplayer) > 0 and vRP.getUserSource(parseInt(nplayer)) then 
						local nuser_id = parseInt(nplayer)
						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local maxHomes = vRP.query("homes/countUsers",{ user_id = nuser_id })
							local myHomes = vRP.query("homes/countHouses",{ user_id = nuser_id })[1]["houses"]
							if parseInt(maxHomes[1]["qtd"]) >= myHomes then
								TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de residências.",3000)
								return
							end
					
							local userConsult = vRP.query("homes/userPermissions",{ user_id = nuser_id, name = homeName })
							if userConsult[1] then
								vRP.execute("homes/removePermissions",{ name = homeName, user_id = nuser_id })
							end
					
							vRP.execute("homes/updateOwner",{ name = homeName, user_id = user_id, nuser_id = nuser_id })
							TriggerClientEvent("Notify",source,"sucesso","Transferencia da residência para <b>"..identity["name"].." "..identity["firstname"].."</b> concluída.",5000)
							sendLog('CasasTransferir',"[ID]: "..user_id.." \nTransferiu o Imovel: ["..homeName.."]\n[Para o ID]: "..nplayer.." \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true) 
						else
							TriggerClientEvent("Notify",source,"negado","Passaporte inválido.",5000)
						end
					end
				elseif action == "addchave" then 
					local nplayer = vRP.prompt(source, "Insira o passaporte que deseja adicionar em sua residência","")
					if nplayer and nplayer ~= "" and parseInt(nplayer) > 0 and vRP.getUserSource(parseInt(nplayer)) then 
						local nuser_id = parseInt(nplayer)
						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local maxHomes = vRP.query("homes/countPerms2",{ user_id = nuser_id })
							local myHomes = vRP.query("homes/countPerms",{ user_id = nuser_id })[1]["perms"]
							if parseInt(maxHomes[1]["qtd"]) >= myHomes then
								TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de residências.",3000)
								return
							end
					
							--local homesCount
							--if string.find(homeName,"Appartament") then
							--	homesCount = vRP.query("ap/countPermissions",{ name = homeName, number = consult[1]["number"] })
							--else
							--	homesCount = vRP.query("homes/countPermissions",{ name = homeName })
							--end
							--
							--if homesCount[1]["qtd"] >= consult[1]["residents"] then
							--	TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de moradores.",5000)
							--	return
							--end
				
							local newConsult = vRP.query("homes/userPermissions",{ user_id = nuser_id, name = homeName })
							if newConsult[1] then
								TriggerClientEvent("Notify",source,"importante","<b>"..identity["name"].." "..identity["firstname"].."</b> já pertence a residência.",5000)
							else
								if string.find(homeName,"Appartament") then 
									vRP.execute("secondOwnerAP",{ user_id = nuser_id, name = homeName, interior = consult[1]["interior"], owner = 0, number = consult[1]["number"] })
									TriggerClientEvent("Notify",source,"sucesso","Adicionado o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> a residência.",5000)
								else
									vRP.execute("homes/newPermissions",{ user_id = nuser_id, name = homeName, interior = consult[1]["interior"], owner = 0 })
									TriggerClientEvent("Notify",source,"sucesso","Adicionado o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> a residência.",5000)
								end
							end
						else
							TriggerClientEvent("Notify",source,"negado","Passaporte inválido.",5000)
						end 
					end
				elseif action == "rchave" then 
					local nplayer = vRP.prompt(source, "Insira o passaporte que deseja remover de sua residência","")
					if nplayer and nplayer ~= "" and parseInt(nplayer) > 0 then 
						local nuser_id = parseInt(nplayer)
						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local userConsult
							if string.find(homeName,"Appartament") then
								userConsult = vRP.query("selectAP2",{ name = homeName, user_id = nuser_id, number = consult[1]["number"] })
							else
								userConsult = vRP.query("homes/userPermissions",{ user_id = nuser_id, name = homeName })
							end

							if userConsult[1] then
								vRP.execute("homes/removePermissions",{ name = homeName, user_id = nuser_id })
								TriggerClientEvent("Notify",source,"sucesso","Removido o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> da residência.",5000)
							else
								TriggerClientEvent("Notify",source,"negado","Não foi possível encontrar o passaporte <b>"..vRP.format(nuser_id).."</b> na residência.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"aviso","Passaporte inválido.",5000)
						end
					end
				end
				if action == "trancar" then 
					if consult[1] then 
						if string.find(homeName,"Appartament") then
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
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIQUIDAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	local consult = vRP.query("homes/get_casas")
-- 	for k,v in pairs(consult) do 
-- 		if parseInt(os.time()) >= parseInt(v.tax + 24 * 15 * 60 * 60) then
-- 			if v.owner == 1 then
-- 				vRP.execute("homes/selling",{ name = v.name })
-- 				vRP.execute("creative/rem_srv_data",{ dkey = "chest:"..v.name})
-- 				-- vRP.remSrvdata("wardrobe:"..v.name)
-- 				-- vRP.remSrvdata("fridge:"..v.name)
-- 				-- vRP.remSrvdata("vault:"..v.name)
-- 				SendWebhookMessage(webhookREMO,"```prolog\n[CASA]: "..v.name.." \nfoi entregue ao banco por falta de pagamento."..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```") 
-- 				print("A residência "..v.name.." foi entregue ao banco por falta de pagamento.")
-- 			end
-- 		end
-- 	end
-- end)

Citizen.CreateThread(function()
	local consultHomes = exports["oxmysql"]:executeSync("SELECT * FROM core_homes WHERE owner = 1")
	for k,v in pairs(consultHomes) do 
		if parseInt(os.time()) >= parseInt(v.tax + 24 * 15 * 60 * 60) then
			if string.find(v["name"],"Appartament") then 
				vRP.execute("vRP/deleteAP",{ name = v["name"], number = v["number"] })
				exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"chest:"..v["name"]..v["number"]})
				exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"wardrobe:"..v["name"]})
            else
                vRP.execute("homes/selling",{ name = v["name"] })
				exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"chest:"..v["name"]})
				exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"wardrobe:"..v["name"]})
            end
			sendLog('CasasRemoverFaltaAluguel',"[CASA]: "..v.name.." \nfoi entregue ao banco por falta de pagamento."..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S"),true) 
		end
	end
end)



--[[ Citizen.CreateThread(function()
    local consult = vRP.query("homes/get_casas")
    for k,v in pairs(consult) do 
        if v.owner == 1 and parseInt(v.tax) > 0 then
            if parseInt(os.time()) >= parseInt(v.tax + 24 * 15 * 60 * 60) then
                if string.find(v["name"],"Appartament") then 
                    vRP.execute("deleteAP",{ name = v["name"], number = v["number"] }) 
                    vRP.remSrvdata("vault:"..v["name"]..v["number"])
                    vRP.remSrvdata("wardrobe:"..v["name"])
                else
            --        TriggerEvent("vrp_garages:removeGarages",v["name"])
                    vRP.execute("homes/selling",{ name = v["name"] })
                    vRP.remSrvdata("wardrobe:"..v["name"])
                    vRP.remSrvdata("vault:"..v["name"])
                end
                -- vRP.execute("homes/selling",{ name = v.name })
                -- vRP.remSrvdata("wardrobe:"..v.name)
                -- vRP.remSrvdata("fridge:"..v.name)
                -- vRP.remSrvdata("vault:"..v.name)
                print("A residência "..v.name.." foi entregue ao banco por falta de pagamento.")
            end
        end
    end
end) ]]

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local query = vRP.query("homes/get_casas")
	for k,v in pairs(query) do 
		if homes[v.name] then 
			homes[v.name]["green"] = true
		end
	end

	vCLIENT.updateHomes(source,homes)
	if user_id then
		local myHomes = vRP.query("homes/userList",{ user_id = parseInt(user_id) })
		if parseInt(#myHomes) >= 1 then
			for k,v in pairs(myHomes) do		
				if parseInt(os.time()) >= parseInt(v.tax + 24 * 10 * 60 * 60) then
					if v.owner == 1 then
						-- vRP.execute("homes/selling",{ name = v.name })
						-- vRP.remSrvdata("wardrobe:"..v.name)
						-- vRP.remSrvdata("fridge:"..v.name)
						-- vRP.remSrvdata("vault:"..v.name)
						-- Wait(5000)
						TriggerClientEvent("Notify",source,"importante","Faltam menos de 5 dias para a residência "..v.name.." vencer. Pague suas contas!",10000)
					end
				end

				vCLIENT.setBlipsOwner(source,v["name"],homes[v["name"]][1],homes[v["name"]][2],homes[v["name"]][3])
				Citizen.Wait(10)
			end
		end
	end
end)
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
					TriggerClientEvent("Notify",source,"negado","Trancada.",10000)
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
			TriggerClientEvent("dynamic2:closeSystem2", source)
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
			TriggerClientEvent("dynamic2:closeSystem2", source)
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

cO.myClothes = function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and homeEnter[user_id] then
		local basic = vRP.getSData("wardrobe:"..user_id)
		local consult = json.decode(basic) or {}
		return consult
	end
end


RegisterServerEvent("homes:clotheSystemEdden")
AddEventHandler("homes:clotheSystemEdden",function(action)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local basic = vRP.getSData("wardrobe:"..user_id)
		local consult = json.decode(basic) or {}
		if action == "save" then
			TriggerClientEvent("dynamic2:closeSystem2", source)
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
			TriggerClientEvent("dynamic2:closeSystem2", source)
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

cO.myClothes2 = function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local basic = vRP.getSData("wardrobe:"..user_id)
		local consult = json.decode(basic) or {}
		return consult
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- INVADIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("invadir",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(source,"policia.permissao") then
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
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.openChest(homeName,houseInterfone)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if not vRP.searchReturn(source,user_id) then
            local myResult = vRP.query("homes/userPermissions",{ user_id = parseInt(user_id), name = tostring(homeName) })
            if myResult[1] or vRP.hasPermission(user_id,"policia.permissao") then
				--houseInterfone = myResult[1].number
                if string.find(homeName,"Appartament") then 
                    srv.openHomeChest(source,user_id,homeName..houseInterfone,parseInt(myResult[1].vault))
                    return
                end

                local bau 
                if parseInt(myResult[1].vault) == 1 then 
                    bau = newInterior[tostring(myResult[1].interior)]["vault"]
                else
                    bau = myResult[1].vault
                end
                srv.openHomeChest(source,user_id,homeName,parseInt(bau))
            end
        end
    end
end
function cO.checkWeight(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	local myResult = vRP.query("homes/userPermissions",{ user_id = parseInt(user_id), name = tostring(homeName) })
	bau = newInterior[tostring(myResult[1].interior)]["vault"]
	return parseInt(bau)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYHOUSEOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.applyHouseOpen(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		homeEnter[user_id] = homeName
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
			if GetPlayerRoutingBucket(source) ~= 0 then
				SetPlayerRoutingBucket(source, 0)
			end
			homeEnter[user_id] = nil
		end
		
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if homeEnter[user_id] then
		vRP.updateHomes(user_id,homes[homeEnter[user_id]][1],homes[homeEnter[user_id]][2],homes[homeEnter[user_id]][3])
		homeEnter[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTER HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function enterHomes(source,homeName,status,user)
	if string.find(homeName,"Appartment") then 
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
	Citizen.Wait(10000)
	vCLIENT.updateHomes(-1,homes)
end)

function buyHomeVip(user_id, interiorSelect, homesPrice, descontar)
    local data = vRP.query("nyoHomes/get_ticket", {user_id = user_id})
    if data[1] then 
        local t1 = parseInt(data[1]['t1'])
        local t2 = parseInt(data[1]['t2'])
        local t3 = parseInt(data[1]['t3'])
        local buy = false
        if homesPrice <= 800000 then 
            if t1 >= 1 then 
                t1 = t1 - 1
                buy = true
            elseif t2 >= 1 then 
                t2 = t2 - 1
                buy = true
            elseif t3 >= 1 then 
                t3 = t3 - 1
                buy = true
            end
        elseif homesPrice <= 5500000 then 
            if t2 >= 1 then 
                t2 = t2 - 1
                buy = true
            elseif t3 >= 1 then 
                t3 = t3 - 1
                buy = true
            end
        elseif homesPrice <= 8500000 then 
            if t3 >= 1 then 
                t3 = t3 - 1
                buy = true
            end
        end

        if buy then 
            if descontar then 
				vRP.execute("nyoHomes/remove_ticket", {t1 = t1, t2 = t2, t3 = t3, user_id = user_id})
			end
            return true
        end
    end


    return false
end


