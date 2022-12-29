local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
coC = Tunnel.getInterface("farm_cocaina")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS --
-----------------------------------------------------------------------------------------------------------------------------------------
local acido = false -- [ ACIDO ]
local acidoobj = false -- [ ACIDO OBJETO ]
local panela = false -- [ PANELA ]
local panelaobj = false -- [ PANELA OBJETO ]
local misturar = false -- [ MISTURAR ]
local produzindococa = false  -- [ PRODUZIR ]
-------------------------------------------------------------------------------------------------
--[ AÇÃO ]---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
Citizen.CreateThread(function() -- PEGAR PAPEL
	while true do
		Citizen.Wait(1)

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1104.56,4946.54,218.65, true ) <= 2 and not acido then -- PEGAR ACIDO
			DrawText3D(-1104.56,4946.54,218.65, "[~p~E~w~] Para coletar o ~p~Ácido Corrosivo~w~.")
			if IsControlJustPressed(0,38) and coC.checkPermissao() then
				local ped = PlayerPedId()
				acido = true
				produzindococa = true
				SetEntityCoords(PlayerPedId(),-1104.48,4946.55,218.65-1.1)
				SetEntityHeading(PlayerPedId(),250.42)
				vRP._playAnim(false,{{"amb@medic@standing@tendtodead@idle_a","idle_a"}},true)
				TriggerEvent("Notify","sucesso","Você pegou o <b>Ácido Corrosivo</b>.")
				SetTimeout(5000,function()
					vRP._stopAnim(source,false)
					vRP._playAnim(true,{{"anim@heists@box_carry@","idle"}},true)
					vRP._CarregarObjeto("anim@heists@box_carry@","idle","bkr_prop_meth_hcacid",50,28422,0.0,-0.05,-0.2,0.0,0.0,0.0)
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1107.26,4940.23,218.65, true ) <= 2 and acido and not acidoobj then -- COLOCAR ACIDO
			DrawText3D(-1107.26,4940.23,218.65, "[~p~E~w~] Para colocar o ~p~Ácido Corrosivo~w~.")
			if IsControlJustPressed(0,38) and acido and not acidoobj then
				local ped = PlayerPedId()
				SetEntityCoords(PlayerPedId(),-1107.23,4940.16,218.65-1.1)
				SetEntityHeading(PlayerPedId(),250.42)
				vRP._playAnim(false,{{"mp_common","givetake1_a"}},false)
				vRP._DeletarObjeto(source)
				acidoobj = true
				SetTimeout(1500,function()
					acidoobj1 = CreateObject(GetHashKey("bkr_prop_meth_hcacid"),-1106.48,4940.17,219.45-1.0,true,true,true)
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1108.26,4945.95,218.65, true ) <= 2 and acidoobj and not panela then -- PEGAR PANELA
			DrawText3D(-1108.26,4945.95,218.65, "[~p~E~w~] Para pegar a ~p~Panela de Cocaína~w~.")
			if IsControlJustPressed(0,38) and acidoobj and not panela then
				local ped = PlayerPedId()
				panela = true
				SetEntityCoords(PlayerPedId(),-1108.45,4946.0,218.65-1.1)
				SetEntityHeading(PlayerPedId(),250.42)
				vRP._playAnim(false,{{"amb@medic@standing@tendtodead@idle_a","idle_a"}},true)
				TriggerEvent("Notify","sucesso","Você pegou a <b>Panela de Cocaína</b>.")
				SetTimeout(5000,function()
					vRP._stopAnim(source,false)
					vRP._playAnim(true,{{"anim@heists@box_carry@","idle"}},true)
					vRP._CarregarObjeto("anim@heists@box_carry@","idle","bkr_prop_coke_metalbowl_01",50,28422,0.0,-0.08,-0.35,0.0,0.0,0.0)
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1107.26,4940.23,218.65, true ) <= 2 and panela and not panelaobj then -- COLOCAR PANELA
			DrawText3D(-1107.26,4940.23,218.65, "[~p~E~w~] Para colocar a ~p~Panela de Cocaína~w~.")
			if IsControlJustPressed(0,38) and panela and not panelaobj then
				local ped = PlayerPedId()
				SetEntityCoords(PlayerPedId(),-1107.23,4940.16,218.65-1.1)
				SetEntityHeading(PlayerPedId(),250.42)
				vRP._playAnim(false,{{"mp_common","givetake1_a"}},false)
				vRP._DeletarObjeto(source)
				SetTimeout(1500,function()
					panelacoca = CreateObject(GetHashKey("bkr_prop_coke_metalbowl_01"),-1106.76,4939.86,219.52-1.0,true,true,true)
					panelaobj = true
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1107.57,4939.26,218.65, true ) <= 2 and panelaobj and not misturar then -- PESAR COCAÍNA
			DrawText3D(-1107.57,4939.26,218.65, "[~p~E~w~] Para pesar a ~p~Cocaína~w~.")
			if IsControlJustPressed(0,38) and panelaobj and not misturar then
				local ped = PlayerPedId()
				misturar = true
				SetEntityCoords(PlayerPedId(),-1107.56,4939.28,218.65-1.1)
				SetEntityHeading(PlayerPedId(),250.42)
				TriggerEvent("progress",20300,"PESANDO A COCAÍNA")
				vRP._playAnim(false,{{"anim@amb@business@coc@coc_packing_hi@","full_cycle_v3_pressoperator"}},true)
				balanca = CreateObject(GetHashKey("bkr_prop_coke_scale_01"),-1107.19,4938.66,219.52-1.6,true,true,true)
				espatula = CreateObject(GetHashKey("bkr_prop_coke_fullscoop_01a"),-1107.48,4938.29,219.69-1.1,true,true,true)
				SetTimeout(2500,function()
					DeleteObject(balanca)
					vRP._CarregarObjeto("","","bkr_prop_coke_scale_01",50,28422,0.0,0.0,-0.1,0.0,0.0,0.0)
				end)
				SetTimeout(5000,function()
					vRP._DeletarObjeto(source)
					balanca1 = CreateObject(GetHashKey("bkr_prop_coke_scale_01"),-1107.19,4938.66,219.52-1.1,true,true,true)
				end)
				SetTimeout(7500,function()
					DeleteObject(espatula)
					vRP._CarregarObjeto("","","bkr_prop_coke_fullscoop_01a",50,57005,0.16,0.07,-0.05,200.0,120.0,0.0)
				end)
				SetTimeout(15000,function()
					cocaina = CreateObject(GetHashKey("bkr_prop_coke_powder_02"),-1107.19,4938.66,219.52-1.0,true,true,true)
				end)
				SetTimeout(20000,function()
					vRP._DeletarObjeto(source)
				end)
				SetTimeout(20300,function()
					vRP._stopAnim(source,false)
					DeleteObject(balanca1)
					DeleteObject(cocaina)
					DeleteObject(panelacoca)
					DeleteObject(acidoobj1)
					coC.checkcocaina()
					acido = false -- [ ACIDO ]
					acidoobj = false -- [ ACIDO OBJETO ]
					panela = false -- [ PANELA ]
					panelaobj = false -- [ PANELA OBJETO ]
					misturar = false -- [ MISTURAR ]
					produzindococa = false -- [ PRODUZIR ]
				end)
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
			if acido then
				DisableControlAction(0,167,true)
				DisableControlAction(0,21,true)
				DisableControlAction(0,22,true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES --
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