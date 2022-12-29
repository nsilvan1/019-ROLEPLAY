local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("nexus_hud")
local cachehud = {}
local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false
local hour = nil
local minute = nil
local street = ""
local vehicleSignalIndicator = 'off'
local farol = "off"
local rua = ""
local carroLigado = true
local running = false
local engine = 0
local marcha = 0
local fuel = 0
inCar = false

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local ped = PlayerPedId()
		inCar = IsPedInAnyVehicle(ped, false)
		if inCar then 
				running = GetIsVehicleEngineRunning(vehicle)
				if running then
					carroLigado = true;				
				else 
					carroLigado = false;
				end
				if running ~= cachehud.running then
				SendNUIMessage({ action = 'setMotor', id = 'motor', value = carroLigado})
				cachehud.running = running	
				end
			sleep = 5
			vehicle = GetVehiclePedIsIn(ped, false)
			
			local speed = math.ceil(GetEntitySpeed(vehicle) * 3.605936)
			local _,lights,highlights = GetVehicleLightsState(vehicle)
			marcha = GetVehicleCurrentGear(vehicle)
			fuel = GetVehicleFuelLevel(vehicle)
			engine = GetVehicleEngineHealth(vehicle)
			
			if lights == 1 and highlights == 0 then 
				farol = "normal"
			elseif (lights == 1 and highlights == 1) or (lights == 0 and highlights == 1) then 
				farol = "alto"
			elseif lights == 0 then
				farol = "off"
			end
			
			if marcha == 0 and speed > 0 then 
				marcha = "R" 
			elseif marcha == 0 and speed < 2 then 
				marcha = "N" 
			end

			rpm = GetVehicleCurrentRpm(vehicle)
			rpm = math.ceil(rpm * 10000, 2)
			vehicleNailRpm = 280 - math.ceil( math.ceil((rpm-2000) * 140) / 10000)

			if carroLigado ~= cachehud.carroLigado then
				cachehud.carroLigado = carroLigado	
			SendNUIMessage({ action = 'setMotor', id = 'motor', value = carroLigado})
			end
			if marcha ~= cachehud.marcha then
				cachehud.marcha = marcha	
			SendNUIMessage({ action = 'setMarcha', id = 'marcha', value = marcha})	
			end
			if speed ~= cachehud.speed then
				cachehud.speed = speed	
			SendNUIMessage({ action = 'setSpeed', id = 'speed', value = speed})	
			end
			if engine ~= cachehud.engine then
				cachehud.engine = engine	
			SendNUIMessage({ action = 'setDurability', id = 'durability', value = engine})
			end
			if fuel ~= cachehud.fuel then
				cachehud.fuel = fuel
			SendNUIMessage({ action = 'setFuel', id = 'fuel', value = fuel})	
			end
			if farol ~= cachehud.farol then
				cachehud.farol = farol
			SendNUIMessage({ action = 'setLight', id = 'lights', value = farol})
			end
			
			local car = GetVehiclePedIsIn(ped)

			if car ~= 0  then
				if CintoSeguranca then
					SetPedConfigFlag(PlayerPedId(), 32, false)
					DisableControlAction(0,75)
				else
					SetPedConfigFlag(PlayerPedId(), 32, true)
				end
			end
		end
		Citizen.Wait(sleep)	
	end
end)

RegisterKeyMapping("porcinto","Cinto","keyboard","g")
RegisterCommand("porcinto",function()
	if inCar then
		if CintoSeguranca then
			TriggerEvent("vrp_sound:source","unbelt",0.5)
			CintoSeguranca = false
		else
			TriggerEvent("vrp_sound:source","belt",0.5)
			CintoSeguranca = true
		end
		SendNUIMessage({ action = 'setCinto', id = 'cinto', value = CintoSeguranca})
	end
end)

--[[RegisterKeyMapping("desligarMotor","Desligar Carro","keyboard","z")
RegisterCommand("desligarMotor",function()
	running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle)
	if running then
		carroLigado = false;				
	else 
		carroLigado = true;
	end
	SendNUIMessage({ action = 'setMotor', id = 'motor', value = carroLigado})
end)--]]


AddEventHandler("hud:channel", function(_channel) 
	SendNUIMessage({action = 'hudChannel',value = _channel}) 
end)

RegisterNetEvent("pma-voice:setTalkingMode")
AddEventHandler("pma-voice:setTalkingMode", function(_mode) 
	SendNUIMessage({ action = 'hudMode',value = _mode })
 end)

local shownui = true
RegisterCommand("hud",function(source,args)
	shownui = not shownui
	SendNUIMessage({ action = "showHud", value = shownui})

end)


RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	shownui = not status
	-- SendNUIMessage({ display = shownui })
end)

function showHud(status)
	SendNUIMessage({ action = "showHud", value = status})
end

exports('showHud', showHud)

Citizen.CreateThread(function()
	Wait(1000)
	SendNUIMessage({ action = 'hudMode',value = 2 })
	while true do
			local ped = PlayerPedId()
			local vida = (GetEntityHealth(ped)-100)/300 * 100
			local armour = GetPedArmour(ped)
			local coords = GetEntityCoords(ped)
			local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
			hours = GetClockHours()
			minutes = GetClockMinutes()

			if hours <= 9 then
				hours = "0"..hours
			end

			if minutes <= 9 then
				minutes = "0"..minutes
			end
			
			if streetName ~= cachehud.streetName then
				cachehud.streetName = streetName
			SendNUIMessage({ action = 'setLocation', id = 'location', value = streetName})
			end
			if vida ~= cachehud.vida then
				cachehud.vida = vida
			SendNUIMessage({ action = 'setHealth', id = 'health', value = vida})
			end
			if armour ~= cachehud.armour then
				cachehud.armour = armour
			SendNUIMessage({ action = 'setArmour', id = 'armour', value = armour})
			end
			if hours ~= cachehud.hours or minutes ~= cachehud.minutes then
				cachehud.hours = hours
				cachehud.minutes = hours
			SendNUIMessage({ action = 'setTime', id = 'time', value = hours..":"..minutes })
			end
			
			if not IsPedInAnyVehicle(PlayerPedId(), false) then 
				DisplayRadar(false)
				CintoSeguranca = false
				SendNUIMessage({
					action = "update"
				})
			else
				DisplayRadar(true)
				SendNUIMessage({
					action = "inCar"
				})
			end

			SendNUIMessage({ action = 'micColor',value = NetworkIsPlayerTalking(PlayerId()) })
			if IsPauseMenuActive() or  not shownui then
				SendNUIMessage({ action = 'setDisplay',value = false })
			else
				SendNUIMessage({ action = 'setDisplay', value = true })
			end
		Citizen.Wait(500)	
	end
end)

Citizen.CreateThread(function()
    SetFlyThroughWindscreenParams(25.0, 2.0, 15.0, 15.0) 
	-- ResetFlyThroughWindscreenParams()
    SetPedConfigFlag(PlayerPedId(), 32, true)
end)

RegisterNetEvent("progress")
AddEventHandler("progress",function(timer, name)
	SendNUIMessage({ action = 'setProgress', progress = true, value = parseInt(timer) })
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOn",function()
    SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSOFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOff",function()
    SetNuiFocus(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("setWay",function(data)
    SetNewWaypoint(data.x+0.0001,data.y+0.0001)
end)

function updateMapPosition()

    local minimapXOffset,minimapYOffset = 0,0
    
    DisplayRadar(false)
    
    RequestStreamedTextureDict("circleminimap",false)
    while not HasStreamedTextureDictLoaded("circleminimap") do
        Wait(100)
    end
    
    SetMinimapClipType(1)
    AddReplaceTexture("platform:/textures/graphics","radarmasksm","circleminimap","radarmasksm")
    SetMinimapComponentPosition("minimap", "L", "B", -0.0045+minimapXOffset, 0.002+minimapYOffset-0.025, 0.150, 0.188888)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020+minimapXOffset, 0.030+minimapYOffset-0.025, 0.111, 0.159)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.03+minimapXOffset, 0.022+minimapYOffset-0.040, 0.266, 0.200)
    
    SetBigmapActive(true,false)
    Wait(50)
    SetBigmapActive(false,false)
end

CreateThread(function()
    updateMapPosition()
end)
