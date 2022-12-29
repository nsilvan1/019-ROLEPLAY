-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for i = 1,120 do
		EnableDispatchService(i,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE WEAPON VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	local sleep = 1000
-- 	while true do
-- 		local ped = PlayerPedId()
-- 		if IsPedInAnyVehicle(ped) then
			
-- 			local vehicle = GetVehiclePedIsIn(PlayerPedId())
-- 			if GetPedInVehicleSeat(vehicle,-1) == ped then
-- 				sleep = 5
-- 				local speed = GetEntitySpeed(vehicle)*2.236936
-- 				if speed >= 40 then
					
-- 					SetPlayerCanDoDriveBy(PlayerId(),false)
-- 				else
-- 					SetPlayerCanDoDriveBy(PlayerId(),true)
-- 				end
-- 			end
-- 		end
-- 		Citizen.Wait(sleep)
-- 	end
-- end)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- DRIFT
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(100)
--         local ped = PlayerPedId()
--         local vehicle = GetVehiclePedIsIn(PlayerPedId())
--         if IsPedInAnyVehicle(ped) then
--             local speed = GetEntitySpeed(vehicle)*2.236936
--             if GetPedInVehicleSeat(vehicle,-1) == ped 
--                 and (GetEntityModel(vehicle) ~= GetHashKey("coach") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("bus") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("youga2") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("ratloader") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("taxi") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("boxville4") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("trash2") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("tiptruck") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("rebel") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("speedo") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("phantom") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("packer") 
--                     and GetEntityModel(vehicle) ~= GetHashKey("paramedicoambu")) then
--                     if speed <= 100.0 then
--                     if IsControlPressed(1,21) then
--                         SetVehicleReduceGrip(vehicle,true)
--                     else
--                         SetVehicleReduceGrip(vehicle,false)
--                     end
--                 end    
--             end
--         end
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVER X NA MOTO
-----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
--     while true do
--         local timeDistance = 500
--         local ped = PlayerPedId()
--         if IsPedInAnyVehicle(ped) then
--             local vehicle = GetVehiclePedIsIn(ped)
--             if (GetPedInVehicleSeat(vehicle, -1) == ped or GetPedInVehicleSeat(vehicle, 0) == ped) and GetVehicleClass(vehicle) == 8 then
--                 timeDistance = 4
--                 DisableControlAction(0, 345, true)
--             end
--         end
		
--         Citizen.Wait(timeDistance)
--     end
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [ REMOVER O Q ]-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timing = 1000
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if health >= 101 then
			timing = 5 
        DisableControlAction(0,44,true)
        end
		Citizen.Wait(timing)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAMAGE WALK MODE
-----------------------------------------------------------------------------------------------------------------------------------------
local hurt = false
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if not IsEntityInWater(ped) then
			if GetEntityHealth(ped) <= 199 then
				idle = 5
				setHurt()
			elseif hurt and GetEntityHealth(ped) > 200 then
				setNotHurt()
			end
		end
		Citizen.Wait(idle)
	end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(PlayerPedId(),"move_m@injured",true)
	SetPlayerHealthRechargeMultiplier(PlayerId(),0.0)
	DisableControlAction(0,21) 
	DisableControlAction(0,22)
end

function setNotHurt()
    hurt = false
	SetPlayerHealthRechargeMultiplier(PlayerId(),0.0)
    ResetPedMovementClipset(PlayerPedId())
    ResetPedWeaponMovementClipset(PlayerPedId())
    ResetPedStrafeClipset(PlayerPedId())
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- AIM REMOVE PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	while true do
-- 		local ped = PlayerPedId()
-- 		local bool,hash = GetCurrentPedWeapon(ped,1)
-- 		local weapongroup = GetWeapontypeGroup(hash)
-- 		if bool and weapongroup ~= -728555052 then
-- 			SetPlayerLockon(PlayerId(),false)
-- 		else
-- 			SetPlayerLockon(PlayerId(),true)
-- 		end
-- 		Citizen.Wait(1000)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUDACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
local densityActived = false
RegisterNetEvent("densityActived")
AddEventHandler("densityActived",function()
	Citizen.Wait(60000)
	densityActived = true
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------

-- Citizen.CreateThread(function()
-- 	while true do
-- 		for i = 1,51 do
-- 			if i ~= 10 and i ~= 14 and i ~= 15 and i ~= 16 and i ~= 19 then
-- 				HideHudComponentThisFrame(i)
-- 			end
-- 		end
-- 		Citizen.Wait(0)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDROPWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ot = 1000
		--if not IsPedInAnyVehicle(PlayerPedId()) then-- ç-ç mil treta
			local handle,ped = FindFirstPed()
			local finished = false
			repeat
				if not IsEntityDead(ped) then
					SetPedDropsWeaponsWhenDead(ped,false)
				end
				finished,ped = FindNextPed(handle)
			until not finished

			EndFindPed(handle)
		--end
		Wait(ot)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ ESTOURAR OS PNEUS ]------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	
	while true do
		local sleep = 1000
		local ped = PlayerPedId()
		local vehicleped = IsPedInAnyVehicle(ped) 
		if vehicleped then
			sleep = 5
			local vehicle = GetVehiclePedIsIn(ped)
			local assento = GetPedInVehicleSeat(vehicle,-1)
           if assento == ped then
               local speed = GetEntitySpeed(vehicle)*2.236936
				if speed >= 390 and math.random(100) >= 97 then
					local estourar = GetVehicleTyresCanBurst(vehicle)
                   if estourar == false then return end
                   local pneus = GetVehicleNumberOfWheels(vehicle)
                   local pneusEffects
                   if pneus == 2 then
                        pneusEffects = (math.random(2)-1)*4
                   elseif pneus == 4 then
                       pneusEffects = (math.random(4)-1)
                       if pneusEffects > 1 then
                           pneusEffects = pneusEffects + 2
                       end
                   elseif pneus == 6 then
                       pneusEffects = (math.random(6)-1)
                   else
                       pneusEffects = 0
                   end
                   SetVehicleTyreBurst(vehicle,pneusEffects,false,1000.0)
               end
           end
		end
		Citizen.Wait(sleep)
   end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- IPLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	LoadInterior(GetInteriorAtCoords(-447.35,6010.87,31.72))
	LoadInterior(GetInteriorAtCoords(165.52,6640.41,31.72))
	LoadInterior(GetInteriorAtCoords(-2543.5,2310.94,33.42))
	LoadInterior(GetInteriorAtCoords(326.65,-593.17,43.29))
	LoadInterior(GetInteriorAtCoords(134.83,-1043.01,22.97))
	LoadInterior(GetInteriorAtCoords(798.45,-735.37,28.0))
	LoadInterior(GetInteriorAtCoords(1827.15,3681.98,34.28))
	LoadInterior(GetInteriorAtCoords(-160.24,6322.65,31.6))
	LoadInterior(GetInteriorAtCoords(1851.54,3689.08,34.29))
	LoadInterior(GetInteriorAtCoords(14.95,-1602.61,29.38))
	for _,ipl in pairs(allIpls) do
		loadInt(ipl.coords,ipl.interiorsProps)
	end
end)

function loadInt(coordsTable,table)
	for _,v in pairs(coordsTable) do
		local interior = GetInteriorAtCoords(v[1],v[2],v[3])
		LoadInterior(interior)
		for _,i in pairs(table) do
			EnableInteriorProp(interior,i)
			Citizen.Wait(10)
		end
		RefreshInterior(interior)
	end
end

allIpls = {
	{
		interiorsProps = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		coords = {{ -1150.7,-1520.7,10.6 }}
	},
	{
		interiorsProps = {
			"csr_beforeMission",
			"csr_inMission"
		},
		coords = {{ -47.1,-1115.3,26.5 }}
	},
	{
		interiorsProps = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		coords = {{ -802.3,175.0,72.8 }}
	},
	{
		interiorsProps = {
			"coke_stash1",
			"coke_stash2",
			"coke_stash3",
			"decorative_02",
			"furnishings_02",
			"walls_01",
			"mural_02",
			"gun_locker",
			"mod_booth"
		},
		coords = {{ 1107.0,-3157.3,-37.5 }}
	},
	{
		interiorsProps = {
			"coke_large",
			"decorative_01",
			"furnishings_01",
			"walls_01",
			"lower_walls_default",
			"gun_locker",
			"mod_booth"
		},
		coords = {{ 998.4,-3164.7,-38.9 }}
	},
	{
		interiorsProps = {
			"chair01",
			"equipment_basic",
			"interior_upgrade",
			"security_low",
			"set_up"
		},
		coords = {{ 1163.8,-3195.7,-39.0 }}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASERTIME
-----------------------------------------------------------------------------------------------------------------------------------------
local tasertime = false
Citizen.CreateThread(function()
	while true do
		local ORTiming = 1000
		local ped = PlayerPedId()
		if IsPedBeingStunned(ped) then
			ORTiming = 5
			SetPedToRagdoll(ped,10000,10000,0,0,0,0)
		end

		if IsPedBeingStunned(ped) and not tasertime then
			tasertime = true
			ORTiming = 5
			TriggerEvent("cancelando",true)
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE",1.0)
		elseif not IsPedBeingStunned(ped) and tasertime then
			tasertime = false
			SetTimeout(10000,function()
				StopGameplayCamShaking()
				TriggerEvent("cancelando",false)
			end)
		end

		Citizen.Wait(ORTiming)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ ['x'] = 265.64, ['y'] = -1261.30, ['z'] = 29.29, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 819.65, ['y'] = -1028.84, ['z'] = 26.40, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1208.95, ['y'] = -1402.56, ['z'] = 35.22, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1181.38, ['y'] = -330.84, ['z'] = 69.31, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 620.84, ['y'] = 269.10, ['z'] = 103.08, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 2581.32, ['y'] = 362.03, ['z'] = 108.46, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 176.63, ['y'] = -1562.02, ['z'] = 29.26, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 176.63, ['y'] = -1562.02, ['z'] = 29.26, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -319.29, ['y'] = -1471.71, ['z'] = 30.54, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1784.32, ['y'] = 3330.55, ['z'] = 41.25, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 49.418, ['y'] = 2778.79, ['z'] = 58.04, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 263.89, ['y'] = 2606.46, ['z'] = 44.98, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1039.95, ['y'] = 2671.13, ['z'] = 39.55, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1207.26, ['y'] = 2660.17, ['z'] = 37.89, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 2539.68, ['y'] = 2594.19, ['z'] = 37.94, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 2679.85, ['y'] = 3263.94, ['z'] = 55.24, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 2005.05, ['y'] = 3773.88, ['z'] = 32.40, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1687.15, ['y'] = 4929.39, ['z'] = 42.07, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1701.31, ['y'] = 6416.02, ['z'] = 32.76, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 179.85, ['y'] = 6602.83, ['z'] = 31.86, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -94.46, ['y'] = 6419.59, ['z'] = 31.48, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -2554.99, ['y'] = 2334.40, ['z'] = 33.07, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -1800.37, ['y'] = 803.66, ['z'] = 138.65, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -1437.62, ['y'] = -276.74, ['z'] = 46.20, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -2096.24, ['y'] = -320.28, ['z'] = 13.16, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -724.61, ['y'] = -935.16, ['z'] = 19.21, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -526.01, ['y'] = -1211.00, ['z'] = 18.18, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -70.21, ['y'] = -1761.79, ['z'] = 29.53, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	----
	{ ['x'] = -633.99, ['y'] = -238.98, ['z'] = 38.53, ['sprite'] = 617, ['color'] = 0, ['nome'] = "Joalheria", ['scale'] = 0.4 },
	{ ['x'] = 161.01, ['y'] = -1110.98, ['z'] = 29.89, ['sprite'] = 102, ['color'] = 13, ['nome'] = "Advogados / Tribunal", ['scale'] = 0.6 },

	{ ['x'] = 1308.01, ['y'] = 4261.0, ['z'] = 33.92, ['sprite'] = 68, ['color'] = 13, ['nome'] = "Central | Pescadores", ['scale'] = 0.4 },
	{ ['x'] = 1551.22, ['y'] = 3798.98, ['z'] = 34.41, ['sprite'] = 68, ['color'] = 13, ['nome'] = "Venda | Pescados", ['scale'] = 0.3 },
	
	{ ['x'] = 740.2, ['y'] = 6454.31, ['z'] = 31.93, ['sprite'] = 67, ['color'] = 45, ['nome'] = "Colher-Graos", ['scale'] = 0.6 },
	{ ['x'] = 1706.62, ['y'] = 4727.93, ['z'] = 42.18, ['sprite'] = 67, ['color'] = 45, ['nome'] = "Processar-Graos", ['scale'] = 0.6 },
	{ ['x'] = 2885.11, ['y'] = 4387.0, ['z'] = 50.74, ['sprite'] = 67, ['color'] = 45, ['nome'] = "Vender-Graos", ['scale'] = 0.6 },
	
	{ ['x'] = 460.249, ['y'] = -604.30,   ['z'] = 28.499, ['sprite'] = 513, ['color'] = 45, ['nome'] = "Central de Motorista", ['scale'] = 0.5 },
	{ ['x'] = 2832.0, ['y'] = 2797.02, ['z'] = 57.5, ['sprite'] = 513, ['color'] = 45, ['nome'] = "Minerador", ['scale'] = 0.5 },
	{ ['x'] = 1218.01, ['y'] = -1266.98, ['z'] = 36.43, ['sprite'] = 513, ['color'] = 45, ['nome'] = "Lenhadores", ['scale'] = 0.5 },
	{ ['x'] = -1576.99, ['y'] = 4504.0, ['z'] = 20.87, ['sprite'] = 285, ['color'] = 45, ['nome'] = "Floresta", ['scale'] = 0.5 },

	{ ['x'] = 902.98, ['y'] = -182.11, ['z'] = 73.97, ['sprite'] = 56, ['color'] = 38, ['nome'] = "Taxi", ['scale'] = 0.8 }, 
	{ ['x'] = -1135.23, ['y'] = -2860.82, ['z'] = 13.95, ['sprite'] = 43, ['color'] = 0, ['nome'] = "Helicoptero", ['scale'] = 0.4 }, 

	{ ['x'] = 55.34, ['y'] = -876.67, ['z'] = 30.66, ['sprite'] = 357, ['color'] = 3, ['nome'] = "Garagem", ['scale'] = 0.4 }, 
	{ ['x'] = 214.09, ['y'] = -809.02, ['z'] = 31.02, ['sprite'] = 357, ['color'] = 3, ['nome'] = "Garagem", ['scale'] = 0.4 }, 
	{ ['x'] = 55.34, ['y'] = -876.67, ['z'] = 30.66, ['sprite'] = 357, ['color'] = 3, ['nome'] = "Garagem", ['scale'] = 0.4 }, 
	{ ['x'] = 55.34, ['y'] = -876.67, ['z'] = 30.66, ['sprite'] = 357, ['color'] = 3, ['nome'] = "Garagem", ['scale'] = 0.4 }, 

	{ ['x'] = 1526.11, ['y'] = -640.11, ['z'] = 146.01, ['sprite'] = 310, ['color'] = 3, ['nome'] = "Favelas", ['scale'] = 0.4 }, 
	{ ['x'] = 1615.0, ['y'] = 457.01, ['z'] = 257.25, ['sprite'] = 310, ['color'] = 3, ['nome'] = "Favelas", ['scale'] = 0.4 }, 
	{ ['x'] = -22.39, ['y'] = 592.64, ['z'] = 196.99, ['sprite'] = 310, ['color'] = 3, ['nome'] = "Favelas", ['scale'] = 0.4 }, 
	{ ['x'] = -347.6, ['y'] = 1518.47, ['z'] = 375.52, ['sprite'] = 310, ['color'] = 3, ['nome'] = "Favelas", ['scale'] = 0.4 }, 
	{ ['x'] = -16.93, ['y'] = 2659.5, ['z'] = 82.92, ['sprite'] = 310, ['color'] = 3, ['nome'] = "Favelas", ['scale'] = 0.4 }, 
	{ ['x'] = 2250.83, ['y'] = 3934.48, ['z'] = 36.45, ['sprite'] = 310, ['color'] = 3, ['nome'] = "Favelas", ['scale'] = 0.4 }, 


	{ ['x'] = -1085.32, ['y'] = -802.17, ['z'] = 19.25, ['sprite'] = 60, ['color'] = 38, ['nome'] = "Departamento de Policia", ['scale'] = 0.5 },
	{ ['x'] = 287.06, ['y'] = -581.14, ['z'] = 49.72, ['sprite'] = 489, ['color'] = 59, ['nome'] = "Hospital", ['scale'] = 0.5 },
	{ ['x'] = 839.0, ['y'] = -917.0, ['z'] = 25.6, ['sprite'] = 402, ['color'] = 51, ['nome'] = "Mecânica", ['scale'] = 0.7 },
	-- { ['x'] = -1200.77, ['y'] = -880.1, ['z'] = 13.35, ['sprite'] = 106, ['color'] = 51, ['nome'] = "Burger-shot", ['scale'] = 0.5 },
	-- { ['x'] = -3405.51, ['y'] = 967.8, ['z'] = 8.3, ['sprite'] = 606, ['color'] = 56, ['nome'] = "Café", ['scale'] = 0.5 },
	{ ['x'] = -358.17, ['y'] = -1562.58, ['z'] = 26.21, ['sprite'] = 318, ['color'] = 0, ['nome'] = "Lixeiro", ['scale'] = 0.5 },
	{ ['x'] = -52.11, ['y'] = -1111.07, ['z'] = 26.82, ['sprite'] = 225, ['color'] = 3, ['nome'] = "Concessionária", ['scale'] = 0.5 }
	
}

Citizen.CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v.x,v.y,v.z)
		SetBlipSprite(blip,v.sprite)
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v.color)
		SetBlipScale(blip,v.scale)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.nome)
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local teleport = {
	["TELEFERICO"] = {
		positionFrom = { -741.06,5593.12,41.65 },
		positionTo = { 446.15,5571.72,781.18 }
	},
	["MOTOCLUB"] = {
		positionFrom = { -80.89,214.78,96.55 },
		positionTo = { 1120.96,-3152.57,-37.06 }
	},
	["MINERACAO"] = {
		positionFrom = { -597.04,2091.55,131.42 },
		positionTo = { -594.89,2084.97,131.39 }
	},
	["MOTOCLUB2"] = {
		positionFrom = { 224.60,-1511.02,29.29 },
		positionTo = { 997.24,-3158.00,-38.90 }
	},
	["ESCRITORIO2"] = {
		positionFrom = { -1194.46,-1189.31,7.69 },
		positionTo = { 1173.55,-3196.68,-39.00 }
	},
	["ESCRITORIO3"] = {
		positionFrom = { -1007.12,-486.67,39.97 },
		positionTo = { -1003.05,-477.92,50.02 }
	},
	["ESCRITORIO4"] = {
		positionFrom = { -1898.5,-572.36,11.85 },
		positionTo = { -1902.05,-572.42,19.09 }
	},
	["CENTRAL"] = {
		positionFrom = { 254.1,225.41,101.88 },
		positionTo = { 253.31,222.99,101.69 }
	},
	["ELEVADORH"] = {
		positionFrom = { 335.84,-580.34,43.3 },
		positionTo = { 335.84,-580.36,74.08 }
	},
	-- ["DELEGACIAH"] = {
	-- 	positionFrom = { 2504.47,-341.89,101.93 },
	-- 	positionTo = { 2504.23,-342.15,94.1 }
	-- },
	["TRIBUNAL"] = {
		positionFrom = { 233.10,-410.53,48.11 },
		positionTo = { 243.36,-344.08,-118.78 }
	},
	["CASSINO"] = {
		positionFrom = { 935.06,46.44,81.1 },
		positionTo = { 1090.00,207.00,-49.9 }
	},
	["CASSINO2"] = {
		positionFrom = { 987.86,79.29,81.0 },
		positionTo = { 2550.07,-269.63,-58.72 }
	},
	["CASSINO3"] = {
		positionFrom = { 1085.17,214.15,-49.2 },
		positionTo = { 965.15,58.64,112.56 }
	},
	["CASSINO4"] = {
		positionFrom = { 968.04,63.41,112.56 },
		positionTo = { 970.93,62.71,112.57 }
	},
	["ROUND61"] = {
		positionFrom = { -279.62,-3644.72,288.71 },
		positionTo = { -249.37,-3286.37,290.01 }
	},
	["ROUND62"] = {
		positionFrom = { -346.76,-3286.94,290.01 },
		positionTo = { -291.12,-3655.42,290.25 }
	},
	["ROUND63"] = {
		positionFrom = { -297.34,-3405.56,304.8 },
		positionTo = { -297.35,-3420.32,304.8 }
	},
	["ROUND64"] = {
		positionFrom = { -297.67,-3496.49,304.8 },
		positionTo = { -297.61,-3510.76,304.8 }
	},
	["ROUND65"] = {
		positionFrom = { -297.52,-3585.38,304.8 },
		positionTo = { -296.78,-3654.45,290.25 }
	},
	["ROUND66"] = {
		positionFrom = { 3513.06,3754.94,29.97 },
		positionTo = { -304.91,-3656.73,290.25 }
	},
	["ROUND67"] = {
		positionFrom = { -314.76,-3645.0,288.71 },
		positionTo = { -297.31,-3328.63,304.8 }
	},
	["NIOBIO"] = {
		positionFrom = { 3540.5,3675.14,21.0 },
		positionTo = { 3540.75,3675.71,28.13 }
	},

	["BAHAMAS2"] = {
		positionFrom = { -1373.72,-624.78,30.81 },
		positionTo = { -1371.41,-626.09,30.81 }
	},
	["HOSPITAL"] = {
		positionFrom = { -452.93,-289.03,34.95 },
		positionTo = { -444.0,-332.0,78.17 }
	},
	["LAVAGEM"] = {
		positionFrom = { 764.33,-3208.05,6.03 },
		positionTo = { 1137.90,-3197.50,-39.66 }
	},

}


Citizen.CreateThread(function()
	while true do
		local ORTiming = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(teleport) do
				if GetDistanceBetweenCoords(v.positionFrom[1],v.positionFrom[2],v.positionFrom[3],x,y,z,true) <= 1.5 then
					ORTiming = 5
					DrawMarker(21,v.positionFrom[1],v.positionFrom[2],v.positionFrom[3]-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
					if IsControlJustPressed(0,38) then
						DoScreenFadeOut(500)
						SetTimeout(500,function()
							SetEntityCoords(ped,v.positionTo[1]+0.0001,v.positionTo[2]+0.0001,v.positionTo[3]+0.0001-0.50,1,0,0,1)
							Citizen.Wait(500)
							DoScreenFadeIn(500)
						end)
					end
				end

				if GetDistanceBetweenCoords(v.positionTo[1],v.positionTo[2],v.positionTo[3],x,y,z,true) <= 1.5 then
					ORTiming = 5
					DrawMarker(21,v.positionTo[1],v.positionTo[2],v.positionTo[3]-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
					if IsControlJustPressed(0,38) then
						DoScreenFadeOut(500)
						SetTimeout(500,function()
							SetEntityCoords(ped,v.positionFrom[1]+0.0001,v.positionFrom[2]+0.0001,v.positionFrom[3]+0.0001-0.50,1,0,0,1)
							Citizen.Wait(500)
							DoScreenFadeIn(500)
						end)
					end
				end
			end
		end
		Citizen.Wait(ORTiming)
	end
end)

	Citizen.CreateThread(function()
		while true do
			local sleep = 100
			if IsPedArmed(PlayerPedId(),6) then
				sleep = 4
				DisableControlAction(1,140,true)
				DisableControlAction(1,141,true)
				DisableControlAction(1,142,true)
			end
			Citizen.Wait(sleep)
		end
	end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(text,height)
	SetTextFont(4)
	SetTextScale(0.50,0.50)
	SetTextColour(255,255,255,180)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5,height)
end

------------------------------------------------------------
-- [ LIMITAR VELOCIDADE DE TODOS CARROS ] 
------------------------------------------------------------
Citizen.CreateThread( function()
    while true do 
        Citizen.Wait( 0 )
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local speed = GetEntitySpeed(vehicle)
            if ( ped ) then
                if math.floor(speed*3.6) == 220 then --Velocidade limitada em 250
                    cruise = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                    SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), cruise)
                end
            end
        end
end)