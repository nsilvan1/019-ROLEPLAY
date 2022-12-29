-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
sRP = {}
Tunnel.bindInterface("CruzRoubos",sRP)
vSERVER = Tunnel.getInterface("CruzRoubos")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local andamento = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CÓDIGO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local oInfinity = 1000
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(Config.roubos) do
			local distance = #(coords - vector3(v.x,v.y,v.z))
			if distance <= 5 and not andamento then
				oInfinity = 4
				if distance <= 1.2 then
					DrawText3Ds(v.x, v.y, v.z, '~r~[G] ~w~ASSALTAR')
					if IsControlJustPressed(0,47) and not IsPedInAnyVehicle(ped) then
						if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") or GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
							vSERVER.startRobbery(json.encode(v), json.encode(Config.setup))
						end
					end
				end
			end
		end
		Citizen.Wait(oInfinity)
	end
end)


Citizen.CreateThread(function()
	while true do
		local oInfinity = 500
		local ped = PlayerPedId()
		if andamento and not IsPedInAnyVehicle(ped) then
			oInfinity = 4
			drawTxt("APERTE ~r~M~w~ PARA CANCELAR O ROUBO EM ANDAMENTO",4,0.5,0.91,0.36,255,255,255,100)
			drawTxt("RESTAM ~r~"..segundos.." SEGUNDOS ~w~PARA TERMINAR",4,0.5,0.93,0.50,255,255,255,180)
			if IsControlJustPressed(0,244) or GetEntityHealth(ped) <= 100 then
				andamento = false
				ClearPedTasks(ped)
				vSERVER.cancelRobbery()
				TriggerEvent('cancelando',false)
			end
		end
		Citizen.Wait(oInfinity)
	end
end)


function sRP.iniciandoRoubo(x,y,z,secs,head)
	segundos = secs
	andamento = true
	SetEntityHeading(PlayerPedId(),head)
	SetEntityCoords(PlayerPedId(),x,y,z-1,false,false,false,false)
	SetPedComponentVariation(PlayerPedId(),5,45,0,2)
	SetCurrentPedWeapon(PlayerPedId(),GetHashKey("WEAPON_UNARMED"),true)
	TriggerEvent('cancelando',true)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if andamento and not IsPedInAnyVehicle(PlayerPedId()) then
			segundos = segundos - 1
			if segundos <= 0 then
				andamento = false
				vSERVER.givePayment()
				ClearPedTasks(PlayerPedId())
				TriggerEvent('cancelando',false)
			end
		end
	end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- MARCAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local blip = nil
RegisterNetEvent('blip:criar:roubo')
AddEventHandler('blip:criar:roubo',function(x,y,z)
	if not DoesBlipExist(blip) then
		blip = AddBlipForCoord(x,y,z)
		SetBlipScale(blip,0.5)
		SetBlipSprite(blip,1)
		SetBlipColour(blip,59)
		BeginTextCommandSetBlipName("STRING")
		SetBlipAsShortRange(blip,false)
		SetBlipRoute(blip,true)
	end
end)

RegisterNetEvent('blip:remover:roubo')
AddEventHandler('blip:remover:roubo',function()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
		blip = nil
	end
end)

function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(6)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end