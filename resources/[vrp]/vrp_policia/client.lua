local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vrp_policia")
vTASKBAR = Tunnel.getInterface('np-taskbarskill')

-----------------------------------------------------------------------------------------------------------------------------------------
--[ /RMASCARA ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("rmascara")
AddEventHandler("rmascara",function()
	SetPedComponentVariation(PlayerPedId(),1,0,0,2)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ /RCHAPEU ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("rchapeu")
AddEventHandler("rchapeu",function()
	ClearPedProp(PlayerPedId(),0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET & REMOVE ALGEMAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setalgemas")
AddEventHandler("setalgemas",function()
	local ped = PlayerPedId()
	local finished = vTASKBAR.taskLockpick()
	
	if finished then
		TriggerEvent("Notify","aviso","Você conseguiu escapar das <b>Algemas</b>")
		TriggerEvent("admcuff")
		SetPedComponentVariation(PlayerPedId(),7,0,0,2)
		return 
	end

	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped,7,41,0,2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped,7,25,0,2)
	end
end)

RegisterNetEvent("removealgemas")
AddEventHandler("removealgemas",function()
	SetPedComponentVariation(PlayerPedId(),7,0,0,2)
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR
--------------------------------------------------------------------------------------------------------------------------------------------------
other = nil
drag = false
carregado = false
RegisterNetEvent("carregar")
AddEventHandler("carregar",function(p1)
    other = p1
    drag = not drag
	testecarregar()

end)
function testecarregar()

Citizen.CreateThread(function()
    while true do
		-- local sleep = 1000
		Citizen.Wait(2)
		if drag and other then
			
			local ped = GetPlayerPed(GetPlayerFromServerId(other))
			Citizen.InvokeNative(0x6B9BBD38AB0796DF,PlayerPedId(),ped,4103,11816,0.48,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
			carregado = true
        else
			if carregado then
				sleep = 5
				DetachEntity(PlayerPedId(),true,false)
				carregado = false
			end
		end
		
	end
end)
end
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ALGEMAR
--------------------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping('vrp_policia:algemarnexus', '[G] ALGEMAR', 'keyboard', 'G')

RegisterCommand("vrp_policia:algemarnexus",function(source,args,rawCommand)
	if not IsPedInAnyVehicle(PlayerPedId()) then 
		TriggerServerEvent("vrp_policia:algemar")
	end
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR
--------------------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping('vrp_policia:carregarnexus', '[H] CARREGAR', 'keyboard', 'H')

RegisterCommand("vrp_policia:carregarnexus",function(source,args,rawCommand)
	if not IsPedInAnyVehicle(PlayerPedId()) then 
		TriggerServerEvent("vrp_policia:carregar")
	end
end)

local in_arena = false
RegisterNetEvent("mirtin_survival:updateArena")
AddEventHandler("mirtin_survival:updateArena", function(boolean)
	in_arena = boolean
end)

--------------------------------------------------------------------------------------------------------------------------------------------------
-- DISPAROS
--------------------------------------------------------------------------------------------------------------------------------------------------
local blacklistedWeapons = {
	"WEAPON_DAGGER",
	"WEAPON_BAT",
	"WEAPON_BOTTLE",
	"WEAPON_CROWBAR",
	"WEAPON_FLASHLIGHT",
	"WEAPON_GOLFCLUB",
	"WEAPON_HAMMER",
	"WEAPON_HATCHET",
	"WEAPON_KNUCKLE",
	"WEAPON_KNIFE",
	"WEAPON_MACHETE",
	"WEAPON_SWITCHBLADE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_WRENCH",
	"WEAPON_BATTLEAXE",
	"WEAPON_POOLCUE",
	"WEAPON_STONE_HATCHET",
	"WEAPON_STUNGUN",
	"WEAPON_FLARE",
	"GADGET_PARACHUTE",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_PETROLCAN",
	"WEAPON_RAYPISTOL",
	"WEAPON_FIREWORK",
	"WEAPON_BZGAS",
	"WEAPON_MUSKET"
}

Citizen.CreateThread(function()
	while true do
		local ot = 1000
		local ped = PlayerPedId()
		local blacklistweapon = false
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	
		if IsPedArmed(ped, 6) then 
			ot = 5
			for k,v in ipairs(blacklistedWeapons) do
				if GetSelectedPedWeapon(ped) == GetHashKey(v) then
					blacklistweapon = true
				end
			end

			if not in_arena and IsPedShooting(ped) and not blacklistweapon then
				TriggerServerEvent('atirando',x,y,z)
				Wait(300)
			end
		end
		blacklistweapon = false
		Wait(ot)
	end
end)

local blips = {}
RegisterNetEvent('notificacao')
AddEventHandler('notificacao',function(x,y,z,user_id)
	if not DoesBlipExist(blips[user_id]) then
		PlaySoundFrontend(-1,"Enter_1st","GTAO_FM_Events_Soundset",true)
		TriggerEvent("NotifyPush",{ code = 10, title = "Ocorrência em andamento", x = x, y = y, z = z, badge = "Disparos de arma de fogo" })
		blips[user_id] = AddBlipForCoord(x,y,z)
		SetBlipScale(blips[user_id],0.5)
		SetBlipSprite(blips[user_id],10)
		SetBlipColour(blips[user_id],49)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Disparos de arma de fogo")
		EndTextCommandSetBlipName(blips[user_id])
		SetBlipAsShortRange(blips[user_id],true)
		SetTimeout(1500,function()
			if DoesBlipExist(blips[user_id]) then
				RemoveBlip(blips[user_id])
			end
		end)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ CONE ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local cone = nil
RegisterNetEvent('cone')
AddEventHandler('cone',function(nome)
	local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,1.0,-0.94)
	local prop = "prop_mp_cone_02"
	local h = GetEntityHeading(PlayerPedId())
	if nome ~= "d" then
		cone = CreateObject(GetHashKey(prop),coord.x,coord.y-0.5,coord.z,true,true,true)
		PlaceObjectOnGroundProperly(cone)
		SetModelAsNoLongerNeeded(cone)
		Citizen.InvokeNative(0xAD738C3085FE7E11,cone,true,true)
		SetEntityHeading(cone,h)
		FreezeEntityPosition(cone,true)
		SetEntityAsNoLongerNeeded(cone)
	else
		if DoesObjectOfTypeExistAtCoords(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),true) then
			cone = GetClosestObjectOfType(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),false,false,false)
			Citizen.InvokeNative(0xAD738C3085FE7E11,cone,true,true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(cone))
			DeleteObject(cone)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ BARREIRA ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local barreira = nil
RegisterNetEvent('barreira')
AddEventHandler('barreira',function(nome)
	local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,1.5,-0.94)
	local prop = "prop_mp_barrier_02b"
	local h = GetEntityHeading(PlayerPedId())
	if nome ~= "d" then
		barreira = CreateObject(GetHashKey(prop),coord.x,coord.y-0.95,coord.z,true,true,true)
		PlaceObjectOnGroundProperly(barreira)
		SetModelAsNoLongerNeeded(barreira)
		Citizen.InvokeNative(0xAD738C3085FE7E11,barreira,true,true)
		SetEntityHeading(barreira,h-180)
		FreezeEntityPosition(barreira,true)
		SetEntityAsNoLongerNeeded(barreira)
	else
		if DoesObjectOfTypeExistAtCoords(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),true) then
			barreira = GetClosestObjectOfType(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),false,false,false)
			Citizen.InvokeNative(0xAD738C3085FE7E11,barreira,true,true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(barreira))
			DeleteObject(barreira)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SPIKE ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local spike = nil
RegisterNetEvent('spike')
AddEventHandler('spike',function(nome)
	local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,2.5,0.0)
	local prop = "p_ld_stinger_s"
	local h = GetEntityHeading(PlayerPedId())
	if nome ~= "d" then
		spike = CreateObject(GetHashKey(prop),coord.x,coord.y,coord.z,true,true,true)
		PlaceObjectOnGroundProperly(spike)
		SetModelAsNoLongerNeeded(spike)
		Citizen.InvokeNative(0xAD738C3085FE7E11,spike,true,true)
		SetEntityHeading(spike,h-180)
		FreezeEntityPosition(spike,true)
		SetEntityAsNoLongerNeeded(spike)
	else
		if DoesObjectOfTypeExistAtCoords(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),true) then
			spike = GetClosestObjectOfType(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),false,false,false)
			Citizen.InvokeNative(0xAD738C3085FE7E11,spike,true,true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(spike))
			DeleteObject(spike)
		end
	end
end)

Citizen.CreateThread(function()
	local sleep = 1000
	while true do
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)
		local vcoord = GetEntityCoords(veh)
		local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,1.0,-0.94)
		if IsPedInAnyVehicle(PlayerPedId()) then
			
			if DoesObjectOfTypeExistAtCoords(vcoord.x,vcoord.y,vcoord.z,0.9,GetHashKey("p_ld_stinger_s"),true) then
				SetVehicleTyreBurst(veh,0,true,1000.0)
				SetVehicleTyreBurst(veh,1,true,1000.0)
				SetVehicleTyreBurst(veh,2,true,1000.0)
				SetVehicleTyreBurst(veh,3,true,1000.0)
				SetVehicleTyreBurst(veh,4,true,1000.0)
				SetVehicleTyreBurst(veh,5,true,1000.0)
				SetVehicleTyreBurst(veh,6,true,1000.0)
				SetVehicleTyreBurst(veh,7,true,1000.0)
				if DoesObjectOfTypeExistAtCoords(coord.x,coord.y,coord.z,0.9,GetHashKey("p_ld_stinger_s"),true) then
					sleep = 5
					spike = GetClosestObjectOfType(coord.x,coord.y,coord.z,0.9,GetHashKey("p_ld_stinger_s"),false,false,false)
					Citizen.InvokeNative(0xAD738C3085FE7E11,spike,true,true)
					SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(spike))
					DeleteObject(spike)
				end
			end
		end
		Citizen.Wait(sleep)
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



-- --------------------------------------------------------------------------------------------------------------------------------
-- --- [ EXTRAS] ------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('extras', function()
-- 	exports["dynamic"]:SubMenu("Extras","Todas as funções do extras.","extras")
-- 	exports["dynamic"]:AddButton("Extras 01","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra01","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 02","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra02","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 03","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra03","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 04","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra04","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 05","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra05","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 06","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra06","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 07","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra07","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 08","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra08","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 09","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra09","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 10","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra10","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 11","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra11","extras",true)
-- 	exports["dynamic"]:AddButton("Extras 12","Ativa alguma modificação extra do veículo.","extras:invokeSystem","extra12","extras",true)
-- 	exports["dynamic"]:AddButton("Livery 01","Ativa alguma modificação extra do veículo.","extras:invokeSystem","livery01","extras",true)
-- 	exports["dynamic"]:AddButton("Livery 02","Ativa alguma modificação extra do veículo.","extras:invokeSystem","livery02","extras",true)
-- 	exports["dynamic"]:AddButton("Livery 03","Ativa alguma modificação extra do veículo.","extras:invokeSystem","livery03","extras",true)
-- end)

-- RegisterNetEvent("extrasLivery")
-- AddEventHandler("extrasLivery",function(data)
-- 	local ped = PlayerPedId()
-- 	if IsPedInAnyVehicle(ped) then
-- 		local vehicle = GetVehiclePedIsIn(ped)
-- 		if vehicle then
-- 			if data == "extra01" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),1)
-- 			elseif data == "extra02" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),2)
-- 			elseif data == "extra03" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),3)
-- 			elseif data == "extra04" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),4)
-- 			elseif data == "extra05" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),5)
-- 			elseif data == "extra06" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),6)
-- 			elseif data == "extra07" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),7)
-- 			elseif data == "extra08" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),8)
-- 			elseif data == "extra09" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),9)
-- 			elseif data == "extra10" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),10)
-- 			elseif data == "extra11" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),11)
-- 			elseif data == "extra12" then
-- 				TriggerServerEvent("tryextras",VehToNet(vehicle),12)
-- 			elseif data == "livery01" then
-- 				SetVehicleLivery(vehicle,0)
-- 			elseif data == "livery02" then
-- 				SetVehicleLivery(vehicle,1)
-- 			elseif data == "livery03" then
-- 				SetVehicleLivery(vehicle,2)
-- 			end
-- 		end
-- 	end
-- end)