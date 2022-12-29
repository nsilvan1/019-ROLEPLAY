local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
maC = Tunnel.getInterface("farm_maconha")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local pronto = false
local plantaaqui = false
local plantado = false
local plantado1 = false
local confirma = false
local adubo = false
local regando = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- COORDENADAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locblips = {
	[1] = { ['x'] = 103.0, ['y'] = 6351.44, ['z'] = 31.38 } -- 103.0,6351.44,31.38
}

local locplantas = {
	[1] = { ['x'] = 104.55, ['y'] = 6351.83, ['z'] = 31.38 }, -- 104.55,6351.83,31.38
	[2] = { ['x'] = 103.16, ['y'] = 6351.06, ['z'] = 31.38 },
	[3] = { ['x'] = 101.81, ['y'] = 6350.42, ['z'] = 31.38 },
	[4] = { ['x'] = 102.29, ['y'] = 6353.01, ['z'] = 31.38 },

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMEÇAR A PLANTAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local ped = PlayerPedId()
	while true do
		Citizen.Wait(1)

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),92.45,6351.23,31.38, true ) <= 1 and not adubo then
			DrawText3D(92.45,6351.23,31.38, "[~r~E~w~] PARA PEGAR O ~g~ADUBO~w~.")
			if IsControlJustPressed(0,38) then
				SetEntityHeading(ped,26.78)
				SetEntityCoords(ped,92.45,6351.23,31.38-1,false,false,false,false)
				maC.freezy()
				adubo = true
				vRP._playAnim(true,{{"pickup_object","pickup_low"}},false)
				SetTimeout(2000,function()
					vRP._playAnim(true,{{"anim@heists@box_carry@","idle"}},true)
					vRP._CarregarObjeto("anim@heists@box_carry@","idle","bkr_prop_weed_bucket_01a",50,28422,0.0,-0.1,-0.18,0.0,0.0,0.0) -- 50,28422,0.07,0.1,-0.21,100.0,0.5,0.1
					TriggerEvent("Notify","sucesso","Você pegou o <b>pote de adubo</b>.")
				end)
			end
		end
		
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),103.0,6351.44,31.38, true ) <= 1 and not plantado and adubo then
			DrawText3D(103.0,6351.44,31.38, "[~r~E~w~] PARA PLANTAR OS PÉS DE ~g~MACONHA~w~.")
			if IsControlJustPressed(0,38) and maC.checkPermissao() and not plantado then
				local bowz,cdz = GetGroundZFor_3dCoord(102.93,6351.56,31.38) -- ped 
				local bowz,cdz = GetGroundZFor_3dCoord(locplantas[1].x,locplantas[1].y,locplantas[1].z) -- planta 
				pote = CreateObject(GetHashKey("bkr_prop_weed_plantpot_stack_01b"),locplantas[1].x,locplantas[1].y,locplantas[1].z-1.1,true,true,true)
				pote1 = CreateObject(GetHashKey("bkr_prop_weed_plantpot_stack_01b"),locplantas[2].x,locplantas[2].y,locplantas[2].z-1.1,true,true,true)
				pote2 = CreateObject(GetHashKey("bkr_prop_weed_plantpot_stack_01b"),locplantas[3].x,locplantas[3].y,locplantas[3].z-1.1,true,true,true)
				adubo1 = CreateObject(GetHashKey("bkr_prop_weed_bucket_open_01a"),102.41,6351.32,31.38-1.1,true,true,true)
				vRP._DeletarObjeto(source)
				vRP._playAnim(false,{{"amb@world_human_gardener_plant@female@base","base_female"}},true)
				SetEntityHeading(ped,209.70)
				SetEntityCoords(ped,102.93,6351.56,31.38-1,false,false,false,false)
				pronto = false
				plantado = true

				SetTimeout(5000,function()
					TriggerEvent("Notify","sucesso","Você plantou um pé de maconha.")
					DeleteObject(pote)
					DeleteObject(pote1)
					DeleteObject(pote2)
					DeleteObject(adubo1)
					vRP._stopAnim(source,false)
					pezinho = CreateObject(GetHashKey("bkr_prop_weed_01_small_01c"),locplantas[1].x,locplantas[1].y,locplantas[1].z-1.1,true,true,true)
					pezinho1 = CreateObject(GetHashKey("bkr_prop_weed_01_small_01c"),locplantas[2].x,locplantas[2].y,locplantas[2].z-1.1,true,true,true)
					pezinho2 = CreateObject(GetHashKey("bkr_prop_weed_01_small_01c"),locplantas[3].x,locplantas[3].y,locplantas[3].z-1.1,true,true,true)
				end)
				SetTimeout(10000,function()
					plantado1 = true
					DeleteObject(pezinho)
					DeleteObject(pezinho1)
					DeleteObject(pezinho2)
					pe2 = CreateObject(GetHashKey("bkr_prop_weed_01_small_01a"),locplantas[3].x,locplantas[3].y,locplantas[3].z-1.1,true,true,true)
					pe1 = CreateObject(GetHashKey("bkr_prop_weed_01_small_01a"),locplantas[2].x,locplantas[2].y,locplantas[2].z-1.1,true,true,true)
					pe = CreateObject(GetHashKey("bkr_prop_weed_01_small_01a"),locplantas[1].x,locplantas[1].y,locplantas[1].z-1.1,true,true,true)
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),103.0,6351.44,31.38, true ) <= 1 and plantado1 and not regando then
			DrawText3D(103.0,6351.44,31.38, "[~r~E~w~] PARA REGAR AS ~g~PLANTAS~w~.")
			if IsControlJustPressed(0,38) then
				SetEntityHeading(ped,209.70)
				SetEntityCoords(ped,102.93,6351.56,31.38-1,false,false,false,false)
				vRP._playAnim(true,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
				vRP._CarregarObjeto("","","prop_wateringcan",50,57005,0.45,0.0,0.05,0.0,260.0,140.0)
				TriggerEvent("Notify","sucesso","Você regou as <b>plantas</b>!")
				regando = true

				SetTimeout(5000,function()
					vRP._stopAnim(source,false)
					vRP._DeletarObjeto(source)
				end)

				SetTimeout(5000,function()
					DeleteObject(pe)
					DeleteObject(pe1)
					DeleteObject(pe2)
					pemedio2 = CreateObject(GetHashKey("bkr_prop_weed_med_01a"),locplantas[3].x,locplantas[3].y,locplantas[3].z-3.5,true,true,true)
					pemedio1 = CreateObject(GetHashKey("bkr_prop_weed_med_01a"),locplantas[2].x,locplantas[2].y,locplantas[2].z-3.5,true,true,true)
					pemedio = CreateObject(GetHashKey("bkr_prop_weed_med_01a"),locplantas[1].x,locplantas[1].y,locplantas[1].z-3.5,true,true,true)
				end)
				
				SetTimeout(10000,function()
					DeleteObject(pemedio)
					DeleteObject(pemedio1)
					DeleteObject(pemedio2)
					pezao2 = CreateObject(GetHashKey("bkr_prop_weed_lrg_01a"),locplantas[3].x,locplantas[3].y,locplantas[3].z-3.5,true,true,true)
					pezao1 = CreateObject(GetHashKey("bkr_prop_weed_lrg_01a"),locplantas[2].x,locplantas[2].y,locplantas[2].z-3.5,true,true,true)
					pezao = CreateObject(GetHashKey("bkr_prop_weed_lrg_01a"),locplantas[1].x,locplantas[1].y,locplantas[1].z-3.5,true,true,true)
					pronto = true
					plantado = true
					confirma = true
					TriggerEvent("Notify","sucesso","Seu <b>pé de maconha</b> está pronto.")
				end)
			end
		end

		if confirma then
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),103.0,6351.44,31.38, true ) <= 1 then
				DrawText3D(locblips[1].x,locblips[1].y,locblips[1].z, "[~r~E~w~] PARA COLHER A ~g~MACONHA~w~.")
				if IsControlJustPressed(0,38) then
					plantaaqui = false
					pronto = false
					confirma = false
					adubo = false
					plantado1 = false
					regando = false
					SetEntityHeading(ped,209.70)
					SetEntityCoords(ped,102.93,6351.56,31.38-1,false,false,false,false)
					vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}},true)
					vRP._CarregarObjeto("amb@prop_human_parking_meter@female@idle_a","idle_a_female","p_cs_scissors_s",50,57005,0.055,0.05,0.0,240.0,0.0,0.0) -- 50,28422,0.07,0.1,-0.21,100.0,0.5,0.1
					SetTimeout(10000,function()
						plantado = false
						vRP._stopAnim(source,false)
						DeleteObject(pezao)
						DeleteObject(pezao1)
						DeleteObject(pezao2)
						TriggerEvent('cancelando',source,true)
						vRP._DeletarObjeto(source)
						maC.checkPayment()
						TriggerEvent("Notify","sucesso","Você colheu os <b>pés de maconha</b>.")
					end)
				end
			end
		end
	end
end)
-------------------------------------------------------------------------------------------------
--[ ANTI-BUG ]-----------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if produzindo then
		if adubo then
			DisableControlAction(0,167,true)
			DisableControlAction(0,21,true)
			DisableControlAction(0,22,true)
		else
			DisableControlAction(0,167,false)
			DisableControlAction(0,21,false)
			DisableControlAction(0,22,false)
		end
	end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end