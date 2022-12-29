-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cO = {}
Tunnel.bindInterface("residences",cO)
vSERVER = Tunnel.getInterface("residences")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
houseOpen = ""
local houseTheft = false
local interFone = 0
local homeCoords
local homesList = {}
local homesBlips = {}
local internLocates = {}
local blipsActived = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIM
-----------------------------------------------------------------------------------------------------------------------------------------
local function startAnim()
    TaskStartScenarioInPlace(PlayerPedId(),"PROP_HUMAN_BUM_BIN",0,true)
    Citizen.Wait(6000)
    ClearPedTasks(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIAR VISITA
-----------------------------------------------------------------------------------------------------------------------------------------
local function startVisit()
	local timing = 60
	local ped = PlayerPedId()
	TriggerEvent("Notify","importante","Sua visita foi iniciada, você tem 1 minuto",6000)
	Citizen.CreateThread( function()
		while true do
			Citizen.Wait(1000)
			timing = timing -1 
			if timing == 30 then
				TriggerEvent("Notify","importante","Restam 30 segundos de visita",6000)
			end

			if timing == 0 then 
				DoScreenFadeOut(0)
				homeCoords = nil
				SetEntityCoords(ped,homesList[houseOpen][1],homesList[houseOpen][2],homesList[houseOpen][3] - 0.4)
				vSERVER.removeHouseOpen()
				internLocates = {}
				theftRobberys = {}
				houseOpen = ""
				interFone = 0

				FreezeEntityPosition(ped,true)
				Citizen.Wait(2000)
				FreezeEntityPosition(ped,false)
				DoScreenFadeIn(1000)
				TriggerEvent("Notify","importante","Seu tempo de visita acabou",6000)
				break
			end
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTRANCEHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.entranceHomes(homeName,interior,theft,homeNumber,visitation)
	DoScreenFadeOut(0)
	houseOpen = homeName
	local ped = PlayerPedId()
	vSERVER.applyHouseOpen(homeName,homeNumber)
	if interior then 		
		local myHouse = vSERVER.myInterior(interior,homeName,homeNumber)
		interFone = homeNumber
		if myHouse then
			if visitation then
				StartPlayerTeleport(PlayerId(),myHouse["interior"].x,myHouse["interior"].y,myHouse["interior"].z,0.0,0,1,0)
				startVisit()
			else
				StartPlayerTeleport(PlayerId(),myHouse["interior"].x,myHouse["interior"].y,myHouse["interior"].z,0.0,0,1,0)
				table.insert(internLocates,{ myHouse["interior"],"exit","SAIR" })
				if not theft then 
					table.insert(internLocates,{ myHouse["vaultCoords"],"vault","ABRIR" })
					table.insert(internLocates,{ myHouse["wardobeCoords"],"wardobe","ABRIR" })
				else
					houseTheft = true
					table.insert(internLocates,{ myHouse["vaultCoords"],"vaultTH","ROUBAR" })
					for k,v in pairs(config["theftCoords"][interior]["randCoords"]) do 
						local cds = config["theftCoords"][interior]["randCoords"]
						if cds[k] then 
							table.insert(internLocates,{ cds[k],"theft"..k,"VASCULHAR" })
						end
					end
					TriggerEvent("Notify","verde","Vasculhe a residência para encontrar objetos.",6000)
				end
			end
			homeCoords = vec3(myHouse["interior"].x,myHouse["interior"].y,myHouse["interior"].z)
		end
	end
	DoScreenFadeIn(1000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOLTAR PRA CASA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 700
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and houseOpen ~= "" and homeCoords ~= nil then
			timeDistance = 10
			local coords = GetEntityCoords(ped)
			local distance = #(coords - homeCoords)
			if distance > 50 then 
				StartPlayerTeleport(PlayerId(),homeCoords.x,homeCoords.y,homeCoords.z,0.0,0,1,0)
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIP
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(homesList) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance <= 3 then
				timeDistance = 0
				if string.find(k,"Apartamento") then 
					DrawText3Ds(v[1],v[2],v[3],"[~b~"..string.upper(k).."~w~] : [~g~E~w~] - ENTRAR")
				else 
					DrawText3Ds(v[1],v[2],v[3],"[~b~"..string.upper(k).."~w~] : [~g~E~w~] - ENTRAR ~b~|~w~ [~y~G~w~] - ROUBAR")
				end

				if IsControlJustPressed(0,38) then
					if string.find(k,"Apartamento") then 
						exports["dynamic"]:SubMenu("Apartamento","Todas as funções do apartamento.","appartament")
						exports["dynamic"]:AddButton("Comprar","Comprar um apartamento no condomínio.","homes:invokeSystem","buyAp","appartament",true)
						exports["dynamic"]:AddButton("Interfone","Tocar o intefone e entrar na sua residência.","homes:invokeSystem","interfone","appartament",true)
						exports["dynamic"]:AddButton("Adicionar","Adicionar Moradores.","homes:invokeSystem","addchave","appartament",true)
						exports["dynamic"]:AddButton("Remover","Remover moradores.","homes:invokeSystem","rchave","appartament",true)
						exports["dynamic"]:AddButton("Transferir","Transferir a residência para outra pessoas.","homes:invokeSystem","trans","appartament",true)
						exports["dynamic"]:AddButton("Lista","Lista de moradores.","homes:invokeSystem","list","appartament",true)
						exports["dynamic"]:AddButton("Vender","Vender a propriedade.","homes:invokeSystem","vender","appartament",true)
						exports["dynamic"]:AddButton("Visitar","Visita ao interior de 2 minutos.","homes:invokeSystem","visitar","appartament",true)
					else
						exports["dynamic"]:SubMenu("Casas","Todas as funções das casas.","casas")
						exports["dynamic"]:AddButton("Comprar","Adquirir a casa.","homes:invokeSystem","buyHouse","casas",true)
						exports["dynamic"]:AddButton("Adicionar","Adicionar Moradores.","homes:invokeSystem","addchave","casas",true)
						exports["dynamic"]:AddButton("Remover","Remover moradores.","homes:invokeSystem","rchave","casas",true)
						exports["dynamic"]:AddButton("Entrar","Entrar na residência.","homes:invokeSystem","enterHouse","casas",true)
						exports["dynamic"]:AddButton("Lista","Lista de moradores.","homes:invokeSystem","list","casas",true)
						exports["dynamic"]:AddButton("Transferir","Transferir a residência para outra pessoas.","homes:invokeSystem","trans","casas",true)
						exports["dynamic"]:AddButton("Vender","Vender a propriedade.","homes:invokeSystem","vender","casas",true)
						exports["dynamic"]:AddButton("Visitar","Visita ao interior de 3 minutos.","homes:invokeSystem","visitar","casas",true)
						exports["dynamic"]:AddButton("Trancar","Trancar a propriedade.","homes:invokeSystem","trancar","propertys",true)
						exports["dynamic"]:AddButton("Garagem","Comprar garagem da propriedade.","homes:invokeSystem","garagem","propertys",true)
					end
					
					exports["dynamic"]:AddButton("Upgrade","Faça upgrade no seu interior.","homes:invokeSystem","upgrade","propertys",true)
					exports["dynamic"]:SubMenu("Opções","Funções secundárias das propriedades.","propertys")
					exports["dynamic"]:AddButton("Taxas","Pagar as taxas da propriedade.","homes:invokeSystem","tax","propertys",true)
					exports["dynamic"]:AddButton("Báu","Aumentar o báu da propriedade.","homes:invokeSystem","baú","propertys",true)
				elseif IsControlJustPressed(0,47) then 
					vSERVER.theftHouse(k)
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTERN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and houseOpen ~= "" then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(internLocates) do
				local distance = #(coords - vector3(v[1].x,v[1].y,v[1].z))
				if distance <= 1.3 then
					timeDistance = 1
					DrawText3Ds(v[1].x,v[1].y,v[1].z,"~b~E~w~   "..v[3])

					if IsControlJustPressed(1,38) then
						if v[2] == "exit" then
							if distance <= 0.9 then
								DoScreenFadeOut(0)
								homeCoords = nil
								houseTheft = false
								SetEntityCoords(ped,homesList[houseOpen][1],homesList[houseOpen][2],homesList[houseOpen][3] - 0.4)
								vSERVER.removeHouseOpen()
								internLocates = {}
								theftRobberys = {}
								houseOpen = ""
								interFone = 0
								DoScreenFadeIn(1000)
							end
						elseif houseTheft and (v[2]):find "theft" then 
							startAnim()
							if vSERVER.checkRewards(houseOpen,string.sub(v[2],6)) then 
								table.remove(internLocates,k)
							else
								TriggerEvent("Notify","vermelho","Você não encontrou nada aqui.",3000)
								table.remove(internLocates,k)
							end
						elseif houseTheft and v[2] == "vaultTH" then 
							if vSERVER.theftVault(houseOpen) then 
								table.remove(internLocates,k)
								TriggerEvent("Notify","verde","Você esvaziou o báu.",3000) 
								ClearPedTasks(PlayerPedId())
							end
						elseif v[2] == "vault" then
							if vSERVER.checkPermissions(houseOpen) then
								exports["inventory"]:homesChest(houseOpen,interFone)					
							end
						elseif v[2] == "wardobe" then 
							openClothes()
						end
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.updateHomes(status)
	homesList = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CASAS2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("casas2",function(source,args)
	if blipsActived then
		blipsActived = false
		TriggerEvent("Notify","sucesso","Marcações desativadas.",3000)

		for k,v in pairs(homesBlips) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end
	else
		blipsActived = true
		TriggerEvent("Notify","sucesso","Marcações ativadas, aguarde o carregamento.",3000)

		for k,v in pairs(homesList) do

			homesBlips[k] = AddBlipForRadius(v[1],v[2],v[3],10.0)
			SetBlipAlpha(homesBlips[k],150)
			SetBlipSprite(homesBlips[k],9)
			local color = (k):find "Apartamento" and 84 or 11
			local setColour = homesList[k]["selled"] == true and 59 or color

			SetBlipColour(homesBlips[k],setColour)
		end
	end
end)

openClothes = function()
	if houseOpen ~= "" then 
		local clothes = vSERVER.myClothes()
		if clothes then 
			exports["dynamic"]:SubMenu("Roupas","Todas as roupas salvas na residência.","clothes")
			for k,v in pairs(clothes) do
				exports["dynamic"]:AddButton(k,"Outfit salvo.","homes:clotheSystem",k,"clothes",true)
			end
		end
		exports["dynamic"]:SubMenu("Opções","Gerenciamento de roupas da residência.","optionClothes")
		exports["dynamic"]:AddButton("Adicionar","Adicione o outfit que está em seu corpo.","homes:clotheSystem","save","optionClothes",true)
		exports["dynamic"]:AddButton("Deletar","Delete um outfit existente.","homes:clotheSystem","delete","optionClothes",true)
	end
end

function cO.showOptions(choiceType,interiorTypes)
	if choiceType == 1 then 
		exports["dynamic"]:SubMenu("Adicionar","Adicione uma residência em sua localização.","createHouses")
		exports["dynamic"]:AddButton("Apartamento","Adicione um apartamento.","homes:createSystem","Apartamento","createHouses",true)
		exports["dynamic"]:AddButton("Casa","Adicione uma Casa.","homes:createSystem","Casa","createHouses",true)
	elseif choiceType == 2 then 
		exports["dynamic"]:SubMenu("Interiores","Escolha um interior para a residência.","interiorHouses")
		for k,v in spairs(interiorTypes) do 
			exports["dynamic"]:AddButton(k,"Escolha de interior.","homes:interiorCheck",k,"interiorHouses",true)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIP NO MAPA
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.setBlipsOwner(myHomes)
	for k,v in pairs(myHomes) do 
		if homesList[v["name"]] then 
			local x,y,z = homesList[v["name"]][1],homesList[v["name"]][2],homesList[v["name"]][3]
			local blip = AddBlipForCoord(x,y,z)
			SetBlipAsShortRange(blip,true)
			SetBlipColour(blip,4)
			SetBlipScale(blip,0.3)
			if string.find(v["name"],"Apartamento") then 
				SetBlipSprite(blip,475)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Apartamento: ~b~"..string.gsub(v["name"],"Apartamento",""))
				EndTextCommandSetBlipName(blip)
			else
				SetBlipSprite(blip,411)
		
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Residência: ~b~"..v["name"])
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUXAR BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	Citizen.Wait(5000)
	local myHomes = vSERVER.fetchMyHouses()
	for k,v in pairs(myHomes) do 
		if homesList[v["name"]] then 
			local x,y,z = homesList[v["name"]][1],homesList[v["name"]][2],homesList[v["name"]][3]
			local blip = AddBlipForCoord(x,y,z)
			SetBlipAsShortRange(blip,true)
			SetBlipColour(blip,4)
			SetBlipScale(blip,0.3)
			if string.find(v["name"],"Apartamento") then 
				SetBlipSprite(blip,475)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Apartamento: ~b~"..string.gsub(v["name"],"Apartamento",""))
				EndTextCommandSetBlipName(blip)
			else
				SetBlipSprite(blip,411)
		
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Residência: ~b~"..v["name"])
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/450
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEGARAGE
-----------------------------------------------------------------------------------------------------------------------------------------
local makeGarage = false
local makePoints = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMEGARAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function cO.homeGarage(homeName,v1,v2,v3)
	makePoints = 0
	local homeCoords = {}
	local homeCds = {}
	homeCds[homeName] = {}
	homeCoords[homeName] = {}

	Citizen.CreateThread(function()
		while true do
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)
			local distance = #(coords - vector3(v1,v2,v3))

			if makePoints >= 2 then
				TriggerServerEvent("vrp_garages:updateGarages",homeName,homeCoords[homeName],homeCds[homeName])
				break
			end

			if distance <= 45 then
				if IsControlJustPressed(1,38) then
					makePoints = makePoints + 1

					if makePoints <= 1 then
						TriggerEvent("Notify","importante","Fique no <b>local olhando</b> pra onde deseja que o veículo<br>apareça e pressione a tecla <b>E</b> novamente.",10000)
						homeCoords[homeName] = { x = mathLegth(coords["x"]), y = mathLegth(coords["y"]), z = mathLegth(coords["z"]) }
					else
						TriggerEvent("Notify","importante","Garagem adicionada.",10000)
						homeCds[homeName] = { x = mathLegth(coords["x"]), y = mathLegth(coords["y"]), z = mathLegth(coords["z"]), h = mathLegth(heading) }
					end
				end
			end

			Citizen.Wait(1)
		end
	end)
end

function cO.exitHouse()
	Citizen.CreateThread( function()
		local cooldown = 60
		while true do
			Citizen.Wait(1000)
			cooldown = cooldown -1 
			local ped = PlayerPedId()
			if cooldown == 0 then 
				DoScreenFadeOut(0)
				SetEntityCoords(ped,homesList[houseOpen][1],homesList[houseOpen][2],homesList[houseOpen][3] - 0.4)
				vSERVER.removeHouseOpen()
				internLocates = {}
				theftRobberys = {}
				houseOpen = ""
				interFone = 0

				FreezeEntityPosition(ped,true)
				Citizen.Wait(2000)
				FreezeEntityPosition(ped,false)
				DoScreenFadeIn(1000)
				break
			end
		end
	end)
end



function mathLegth(n)
	return math.ceil(n*100) / 100
end


