local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
eG = Tunnel.getInterface("egEventss")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emServico = false
local Cordenadas = {1391.32,-2086.87,45.5}
local localPeds = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE VENDA
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timing = 2000
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local bowz,cdz = GetGroundZFor_3dCoord(Cordenadas[1],Cordenadas[2],Cordenadas[3])
		local distance = GetDistanceBetweenCoords(Cordenadas[1],Cordenadas[2],cdz,x,y,z,true)
		if distance <= 30.0 then
			timing = 5
			DrawMarker(23,Cordenadas[1],Cordenadas[2],Cordenadas[3]-0.97,0,0,0,0,0,0,1.0,1.0,0.5,0,200,0,50,0,0,0,0)
			if distance <= 1.2 then
				timing = 5
				drawTxtF("PRESSIONE  ~g~E~w~  PARA LAVAR DINHEIRO",4,0.5,0.93,0.50,255,255,255,180)
				if IsControlJustPressed(0,38) then
					eG.lavarDinheiro()
				end
			end
		end
		Citizen.Wait(timing)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCOES
-----------------------------------------------------------------------------------------------------------------------------------------
-- function drawTxtF(text,font,x,y,scale,r,g,b,a)
-- 	SetTextFont(font)
-- 	SetTextScale(scale,scale)
-- 	SetTextColour(r,g,b,a)
-- 	SetTextOutline()
-- 	SetTextCentre(1)
-- 	SetTextEntry("STRING")
-- 	AddTextComponentString(text)
-- 	DrawText(x,y)
-- end

-- function CriandoBlipD(entregas,destino)
-- 	blip = AddBlipForCoord(entregas[destino].x,entregas[destino].y,entregas[destino].z)
-- 	SetBlipSprite(blip,1)
-- 	SetBlipColour(blip,5)
-- 	SetBlipScale(blip,0.4)
-- 	SetBlipAsShortRange(blip,false)
-- 	SetBlipRoute(blip,true)
-- 	BeginTextCommandSetBlipName("STRING")
-- 	AddTextComponentString("Rota de Motorista")
-- 	EndTextCommandSetBlipName(blip)
-- end