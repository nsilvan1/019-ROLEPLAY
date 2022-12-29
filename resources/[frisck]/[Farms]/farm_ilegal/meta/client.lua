local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
meT = Tunnel.getInterface("farm_metanfetamina")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS --
-----------------------------------------------------------------------------------------------------------------------------------------
local benzoato = false
local benzoatoobj1 = false
local toulene = false
local touleneobj1 = false
local misturar = false
local pegarbandeija = false
local colocarbandeija = false
local produzindo = false
-------------------------------------------------------------------------------------------------
--[ AÇÃO ]---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1505.36,6391.54,20.79, true ) <= 2 and not benzoato then -- PEGAR BENZOATO
			DrawText3D(1505.36,6391.54,20.79, "[~p~E~w~] Para coletar o ~p~Benzoato de Sódio~w~.")
			if IsControlJustPressed(0,38) and meT.checkPermissao() then
				local ped = PlayerPedId()
				benzoato = true
				produzindo = true
				vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
				TriggerEvent("Notify","sucesso","Você pegou o <b>Benzoato de Sódio</b>.")
				SetTimeout(5000,function()
					vRP._stopAnim(source,false)
					vRP._playAnim(true,{{"anim@heists@box_carry@","idle"}},true)
					vRP._CarregarObjeto("anim@heists@box_carry@","idle","bkr_prop_meth_sacid",50,28422,0.0,-0.05,-0.2,0.0,0.0,0.0)
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1493.1,6390.37,21.26, true ) <= 2 and benzoato and not benzoatoobj1 then -- COLOCAR BENZOATO
			DrawText3D(1493.1,6390.37,21.26, "[~p~E~w~] Para colocar o ~p~Benzoato de Sódio~w~.")
			if IsControlJustPressed(0,38) and benzoato and not benzoatoobj1 then
				local ped = PlayerPedId()
				vRP._playAnim(false,{{"pickup_object","pickup_low"}},false)
				vRP._DeletarObjeto(source)
				benzoatoobj1 = true
				SetTimeout(1500,function()
					benzoatoobj = CreateObject(GetHashKey("bkr_prop_meth_sacid"),1492.77,6390.41,21.26-1.0,true,true,true)
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1485.65,6392.84,20.79, true ) <= 2 and benzoatoobj1 and not toulene then -- PEGAR TOULENE
			DrawText3D(1485.65,6392.84,20.79, "[~p~E~w~] Para pegar a ~p~Toulene~w~.")
			if IsControlJustPressed(0,38) and benzoatoobj1 and not toulene then
				local ped = PlayerPedId()
				toulene = true
				vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
				TriggerEvent("Notify","sucesso","Você pegou a <b>Toulene</b>.")
				SetTimeout(5000,function()
					vRP._stopAnim(source,false)
					vRP._playAnim(true,{{"anim@heists@box_carry@","idle"}},true)
					vRP._CarregarObjeto("anim@heists@box_carry@","idle","bkr_prop_meth_toulene",50,28422,0.0,-0.05,-0.2,0.0,0.0,0.0)
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1493.1,6390.37,21.26, true ) <= 2 and toulene and not touleneobj1 then -- COLOCAR TOULENE
			DrawText3D(1493.1,6390.37,21.26, "[~p~E~w~] Para colocar o ~p~Toulene~w~.")
			if IsControlJustPressed(0,38) and toulene and not touleneobj1 then
				local ped = PlayerPedId()
				vRP._playAnim(false,{{"pickup_object","pickup_low"}},false)
				vRP._DeletarObjeto(source)
				SetTimeout(1500,function()
					touleneobj1 = true
					touleneobj = CreateObject(GetHashKey("bkr_prop_meth_toulene"),1493.76,6390.18,21.26-1.0,true,true,true)
				end)
			end
		end
		
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1493.24,6390.24,21.26, true ) <= 2 and touleneobj1 and not misturar then -- MISTURAR COMPONENTES
			DrawText3D(1493.24,6390.24,21.26, "[~p~E~w~] Para misturar os ~p~Componentes~w~.")
			if IsControlJustPressed(0,38) and touleneobj1 and not misturar then
				local ped = PlayerPedId()
				misturar = true
				vRP._playAnim(false,{{"mini@repair","fixing_a_ped"}},true)
				TriggerEvent("progress",10000,"MISTURANDO OS COMPONENTES")
				bandeija = CreateObject(GetHashKey("bkr_prop_meth_smashedtray_01_frag_"),1500.12,6395.16,21.58-1.0,true,true,true)
				bandeija1 = CreateObject(GetHashKey("bkr_prop_meth_smashedtray_01_frag_"),1500.83,6394.96,21.58-1.0,true,true,true)
				bandeija2 = CreateObject(GetHashKey("bkr_prop_meth_smashedtray_01_frag_"),1501.61,6394.8,21.58-1.0,true,true,true)
				SetTimeout(10000,function()
					TriggerEvent("Notify","sucesso","Você misturou os <b>Componentes</b>.")
					vRP._stopAnim(source,false)
					DeleteObject(benzoatoobj)
					DeleteObject(touleneobj)
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1500.72,6394.2,20.79, true ) <= 2 and misturar and not pegarbandeija then -- PEGAR BANDEIJA
			DrawText3D(1500.72,6394.2,20.79, "[~p~E~w~] Para pegar a ~p~Bandeija de Metanfetamina~w~.")
			if IsControlJustPressed(0,38) and misturar and not pegarbandeija then
				local ped = PlayerPedId()
				pegarbandeija = true
				vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
				SetTimeout(1000,function()
					TriggerEvent("Notify","sucesso","Você pegou a <b>Bandeija de Metanfetamina</b>.")
					vRP._stopAnim(source,false)
					DeleteObject(bandeija)
					DeleteObject(bandeija1)
					DeleteObject(bandeija2)
					vRP._playAnim(true,{{"anim@heists@box_carry@","idle"}},true)
					vRP._CarregarObjeto("anim@heists@box_carry@","idle","bkr_prop_meth_smashedtray_01",50,28422,0.0,-0.23,-0.15,0.0,0.0,90.0)
				end)
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1496.81,6394.89,20.79, true ) <= 2 and pegarbandeija and not colocarbandeija then -- COLOCAR BANDEIJA
			DrawText3D(1496.81,6394.89,20.79, "[~p~E~w~] Para colocar a ~p~Bandeija de Metanfetamina~w~.")
			if IsControlJustPressed(0,38) and pegarbandeija and not colocarbandeija then
				local ped = PlayerPedId()
				colocarbandeija = true
				vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
				SetTimeout(1000,function()
					vRP._stopAnim(source,false)
					vRP._DeletarObjeto(source)
					bandeija3 = CreateObject(GetHashKey("bkr_prop_meth_smashedtray_01_frag_"),1497.03,6395.74,23.03-2.0,true,true,true)
					meT.checkPayment()
				end)
				SetTimeout(5000,function()
					DeleteObject(bandeija3)
					benzoato = false
					benzoatoobj1 = false
					toulene = false
					touleneobj1 = false
					misturar = false
					pegarbandeija = false
					colocarbandeija = false
					produzindo = false
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
			if benzoato then
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