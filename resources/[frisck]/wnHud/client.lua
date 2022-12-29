local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')



jp = Tunnel.getInterface(GetCurrentResourceName())

local hashstreet,street = nil
local streetName = nil
local Vehicle = nil
local inVeh = false
local vida = 0
local colete = 0
local stamina = 0
local fome,sede = 0
local horas = 0
local minutos = 0
local voice = 2
local sBuffer = {}
local showHud = true
local showMovie = false
local showRadar = false
local ExNoCarro = false
local timedown = 0
local talking = false
local beltSpeed = 0
local entVelocity = 0
local seatbelt = false



local hour = 0
local voice = 2
local minute = 0

local isTalking = 0
local talkRange = 1

RegisterNetEvent("hud:talkingState")
AddEventHandler("hud:talkingState",function(voiceMode)
	talkRange = voiceMode
end)

RegisterNetEvent("hud:talknow")
AddEventHandler("hud:talknow",function(lastTalkingStatus)
	if lastTalkingStatus then
        SendNUIMessage({type = 'radio', isTalking = 1})
    else
        SendNUIMessage({type = 'radio', isTalking = 0})
    end
end)


CreateThread(function()
    while true do
        local ped = PlayerPedId()
        GetHoursTime()
        vida = (GetEntityHealth(GetPlayerPed(-1))-100)/300*100
        colete = GetPedArmour(PlayerPedId())
        fome,sede = jp.getStats()
        stamina = GetPlayerSprintStaminaRemaining(PlayerId())
        x,y,z = table.unpack(GetEntityCoords(ped))
        street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))



        if IsPedInAnyVehicle(ped) then 
            vehicle = GetVehiclePedIsIn(ped)
            
            healthcar = GetVehicleEngineHealth(vehicle)
            gear = GetVehicleCurrentGear(vehicle)
          

          
            SendNUIMessage({type = 'hud', vida = vida, colete = colete, fome = fome, sede = sede, horas = horas, minutos = minutos, street = streetName, car = true, healthcar = parseInt(healthcar), talkRange = talkRange})
        else
            SendNUIMessage({type = 'hud', vida = vida, colete = colete, fome = fome, sede = sede, horas = horas, minutos = minutos, street = streetName, car = false, stamina = stamina, street, talkRange = talkRange})
        end

        Wait(200)
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBEAT
-----------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
end

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			ExNoCarro = true
			if seatbelt then
				DisableControlAction(0,75)
			end

			timeDistance = 4
			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not seatbelt and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				SetEntityHealth(ped,GetEntityHealth(ped)-10)
				TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped),4160)
				timedown = 10
			end

			if IsControlJustReleased(1,47) then
				if seatbelt then
					TriggerEvent("vrp_sound:source","unbelt",0.5)
                 
					seatbelt = false
                    
				else
                   
					TriggerEvent("vrp_sound:source","belt",0.5)
                  
					seatbelt = true
                    
				end
			end

		elseif ExNoCarro then
			ExNoCarro = false
			seatbelt = false
			sBuffer[1],sBuffer[2] = 0.0,0.0
		end

		Citizen.Wait(timeDistance)

	end
end)
CreateThread(function()

    while true do
        
        if not IsPedInAnyVehicle(PlayerPedId(), false) then

            DisplayRadar(0)
            inVeh = false
            SendNUIMessage({type = "Vehicle", config = 'fecharMenu'})
            
        else
            DisplayRadar(1)
            Vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
            SendNUIMessage({type = "Vehicle", config = 'abrirMenu'})
            if inVeh == false then
                InVehicle()
            end
            inVeh = true
        end

        Wait(3000)
    end
end)


function InVehicle()
    CreateThread(function()
        while inVeh do
            local speed = GetEntitySpeed(Vehicle) * 3.6
            local ped = PlayerPedId()
            carro = GetVehiclePedIsIn(ped)
            fuel = GetVehicleFuelLevel(carro)
            locked = GetVehicleDoorLockStatus(Vehicle)
            SendNUIMessage({type = "system", velocity = GetEntitySpeed(Vehicle) * 3.6, fuel = parseInt(fuel), engine = GetVehicleEngineHealth(Vehicle), speed = parseInt(speed), seatbelt = seatbelt, locked = locked})
            Wait(50)
        end
    end)
end

function GetHoursTime()
    local pCDS = GetEntityCoords(PlayerPedId())
    horas = GetClockHours()
    minutos = GetClockMinutes()
    
    hashstreet,street = GetStreetNameAtCoord(pCDS[1],pCDS[2],pCDS[3])
    streetName = GetStreetNameFromHashKey(hashstreet)

    if minutos <= 9 then
        minutos = '0'..minutos
    end

    if horas <= 9 then
        horas = '0'..horas

    end
end

