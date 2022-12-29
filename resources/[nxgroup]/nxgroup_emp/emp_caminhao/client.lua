local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP2 = Tunnel.getInterface("emp_caminhao")
 
vSERVER2 = Tunnel.getInterface("vrp_garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local random = 0
local modules = ""
local servico = false
local servehicle = nil
local CoordenadaX = 1196.33 -- 1196.33,-3256.16,7.1
local CoordenadaY = -3256.16
local CoordenadaZ = 7.1
local CoordenadaX2 = 0.0
local CoordenadaY2 = 0.0
local CoordenadaZ2 = 0.0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIESEL
-----------------------------------------------------------------------------------------------------------------------------------------
local diesel = {
	[1] = { ['x'] = 43.06, ['y'] = 2803.80, ['z'] = 57.87 },
	[2] = { ['x'] = 243.15, ['y'] = 2602.41, ['z'] = 45.11 },
	[3] = { ['x'] = 1059.15, ['y'] = 2660.69, ['z'] = 39.55 },
	[4] = { ['x'] = 1990.22, ['y'] = 3763.54, ['z'] = 32.18 },
	[5] = { ['x'] = 81.23, ['y'] = 6334.27, ['z'] = 31.22 },
	[6] = { ['x'] = 2770.81, ['y'] = 1439.26, ['z'] = 24.51 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARS
-----------------------------------------------------------------------------------------------------------------------------------------
local cars = {
	[1] = { ['x'] = -774.19, ['y'] = -254.45, ['z'] = 37.10 },
	[2] = { ['x'] = -231.64, ['y'] = -1170.94, ['z'] = 22.83 },
	[3] = { ['x'] = 925.59, ['y'] = -8.79, ['z'] = 78.76 },
	[4] = { ['x'] = -506.18, ['y'] = -2191.37, ['z'] = 6.53 },
	[5] = { ['x'] = 1209.15, ['y'] = 2712.03, ['z'] = 38.00 },
	[6] = { ['x'] = -72.97, ['y'] = -1090.45, ['z'] = 25.95 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WOODS
-----------------------------------------------------------------------------------------------------------------------------------------
local woods = {
	[1] = { ['x'] = -581.20, ['y'] = 5317.28, ['z'] = 70.24 },
	[2] = { ['x'] = 2701.74, ['y'] = 3450.62, ['z'] = 55.79 },
	[3] = { ['x'] = 1203.52, ['y'] = -1309.33, ['z'] = 35.22 },
	[4] = { ['x'] = 16.99, ['y'] = -386.11, ['z'] = 39.32 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOWS
-----------------------------------------------------------------------------------------------------------------------------------------
local show = {
	[1] = { ['x'] = 1994.91, ['y'] = 3061.17, ['z'] = 47.04 },
	[2] = { ['x'] = -1397.32, ['y'] = -581.99, ['z'] = 30.28 },
	[3] = { ['x'] = -552.43, ['y'] = 303.34, ['z'] = 83.21 },
	[4] = { ['x'] = -227.52, ['y'] = -2051.27, ['z'] = 27.62 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- /PACK
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("pack",function(source,args)
-- 	local ped = PlayerPedId()
-- 	local x,y,z = table.unpack(GetEntityCoords(ped))
-- 	local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
-- 	local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

-- 	if distance <= 50.1 and not servico then
-- 		if args[1] == "cars" then
-- 			servico = true
-- 			modules = args[1]
-- 			servehicle = 2091594960
-- 			random = emP2.getTruckpoint(modules)
-- 			CoordenadaX2 = cars[random].x
-- 			CoordenadaY2 = cars[random].y
-- 			CoordenadaZ2 = cars[random].z
-- 			CriandoBlipB(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
-- 			TriggerEvent("Notify","importante","Entrega de <b>Veículos</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.")
-- 		elseif args[1] == "woods" then
-- 			servico = true
-- 			modules = args[1]
-- 			servehicle = 2016027501
-- 			random = emP2.getTruckpoint(modules)
-- 			CoordenadaX2 = woods[random].x
-- 			CoordenadaY2 = woods[random].y
-- 			CoordenadaZ2 = woods[random].z
-- 			CriandoBlipB(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
-- 			TriggerEvent("Notify","importante","Entrega de <b>Madeiras</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.")
-- 		else
-- 			TriggerEvent("Notify","aviso","<b>Disponíveis:</b> diesel, cars, show e woods")
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timing = 1000
		if not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 30.0 then
				timing = 5
				DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,0,200,0,50,0,0,0,0)
				if distance <= 1.2 then
					timing = 5
					drawTxtF("~w~PRESSIONE  ~g~E~w~  PARA INICIAR O TRABALHO",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						servico = true
						modules = 'woods'
                        servehicle = 2016027501
                        random = math.random(1,4)
                        CoordenadaX2 = woods[random].x
                        CoordenadaY2 = woods[random].y
                        CoordenadaZ2 = woods[random].z
                        CriandoBlipB(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
                        TriggerEvent("Notify","importante","Entrega de <b>Madeiras</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.")
					end
				end
			end
		end
		Citizen.Wait(timing)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
			local distance = GetDistanceBetweenCoords(CoordenadaX2,CoordenadaY2,cdz,x,y,z,true)

			if distance <= 50.0 then
				sleep = 5
				DrawMarker(23,CoordenadaX2,CoordenadaY2,CoordenadaZ2-0.96,0,0,0,0,0,0,10.0,10.0,1.0,255,0,0,50,0,0,0,0)
				if distance <= 5.9 then
					if IsControlJustPressed(0,38) then
						local vehicle = getVehicleInDirection(GetEntityCoords(PlayerPedId()),GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,5.0,0.0))
						if GetEntityModel(vehicle) == servehicle then
							emP2.checkPayment(random,modules,parseInt(GetVehicleBodyHealth(GetPlayersLastVehicle())))
							vSERVER2.deleteVehicles(vehicle)
							RemoveBlip(blips)
							servico = false
						end
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local egSleep = 1000
		if servico then
			egSleep = 1
			if IsControlJustPressed(0,168) then
				servico = false
				RemoveBlip(blips)
				TriggerEvent("Notify","sucesso","Você saiu de serviço!",10000)
			end
		end
		Citizen.Wait(egSleep)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function getVehicleInDirection(coordsfrom,coordsto)
	local handle = CastRayPointToPoint(coordsfrom.x,coordsfrom.y,coordsfrom.z,coordsto.x,coordsto.y,coordsto.z,10,PlayerPedId(),false)
	local a,b,c,d,vehicle = GetRaycastResult(handle)
	return vehicle
end

function drawTxtF(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlipB(x,y,z)
	blips = AddBlipForCoord(x,y,z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Carga")
	EndTextCommandSetBlipName(blips)
end