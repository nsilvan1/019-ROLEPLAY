-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("farm_ilegal")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local _currentFarm
local blipname
local seconds = 0
local selected = 0
local working = false
local process = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local idle = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
		if not working then
			for _,v in pairs(cfg.StartCoords) do
				
				local distance = GetDistanceBetweenCoords(pos,v.coords,true)
				if distance <= 5 then
					idle = 5
			
					DrawMarker(23,v.coords.x,v.coords.y,v.coords.z-0.98,0,0,0,0.0,0,0,0.8,0.8,0.8,255,0,0,50,0,0,0,1)

					if distance <= 1.2 then
						if IsControlJustPressed(0,38) and vSERVER.checkIntPermissions(v.perm) then
							_currentFarm = v.type
							selected = selected + 1
							blipname = v.blipname
							working = true
							CreateBlip(cfg.FarmLocs[v.type][selected].coords)
							TriggerEvent("Notify","sucesso","Você entrou no serviço de <b>"..v.type.."</b>.")
						end
					end
				end
			end
		end
        Citizen.Wait(idle)
    end
end)

-- function starti()
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		if working then
			local coords = cfg.FarmLocs[_currentFarm][selected].coords
			local distance = GetDistanceBetweenCoords(coords,x,y,z,true)
			if distance <= 3 then
				idle = 5
				DrawMarker(23,coords.x,coords.y,coords.z-0.98,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
				if distance <= 1.2 then
					DrawText3Ds(coords.x,coords.y,coords.z-0.2,"PRESSIONE  ~y~E~w~  PARA  ~y~"..string.upper(blipname),350)
					if IsControlJustPressed(0,38) and IsInputDisabled(0) and not IsPedInAnyVehicle(ped) then
						vRP._playAnim(false,{{"mp_common","givetake1_a"}},true)
						Wait(2000)
						vRP.stopAnim(false)
						if vSERVER.checkPayment(_currentFarm) then

							TriggerEvent('cancelando',true,true)
							RemoveBlip(blips)
							working = false
							process = true
							seconds = 1

							--vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

							backdelivery = selected

							while true do
								if backdelivery == selected and not cfg.FarmLocs[_currentFarm][selected].final == true then
									selected = selected + 1
									working = true
								elseif cfg.FarmLocs[_currentFarm][selected].final == true then
									selected = 1
									working = true
								else
									break
								end
								Citizen.Wait(1)
							end

							CreateBlip(cfg.FarmLocs[_currentFarm][selected].coords)
						end
					end
				end
			end
		end
		 if process then
		 	idle = 5
		 	DrawText3Ds(x,y,z-0.2,"AGUARDE  ~y~"..seconds.."~w~  SEGUNDOS PARA  ~y~"..string.upper(blipname),350)
		 end
		Citizen.Wait(idle)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 500
		if working then
			idle = 5
			if IsControlJustPressed(0,168) and IsInputDisabled(0) then
				working = false
				blipname = nil
				RemoveBlip(blips)
				TriggerEvent("Notify","aviso","Você saiu do serviço de <b>".._currentFarm.."</b>.")
			end
		end
		Citizen.Wait(idle)
	end
end)

-- end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if seconds > 0 then
			seconds = seconds - 1
			if seconds == 0 then
				process = false
				vRP.stopAnim(false)
				TriggerEvent('cancelando',false,false)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3DS
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text,size)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/size
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateBlip(coords)
	blips = AddBlipForCoord(coords)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,1)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(blipname)
	EndTextCommandSetBlipName(blips)
end