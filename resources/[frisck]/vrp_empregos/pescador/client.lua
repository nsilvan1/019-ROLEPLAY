local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
pesca = Tunnel.getInterface("pescador")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 10
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local skips = 1000
		if not processo then
			local ped = PlayerPedId()
			local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),1290.46,4165.0,29.82)
			if distancia <= 100 then
				skips = 1
				DrawMarker(1,1307.16,4232.15,33.92-1.5,0,0,0,0,0,0,350.0,350.0,50.0,255,255,255,30,0,0,0,0)
				if distancia <= 180 then
					skips = 1
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR A PESCARIA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
						if pesca.validateIsca() then 
							segundos = 10;
							processo = true;
							if not IsEntityPlayingAnim(ped,"amb@world_human_stand_fishing@idle_a","idle_c",3) then
								vRP._CarregarObjeto("amb@world_human_stand_fishing@idle_a","idle_c","prop_fishing_rod_01",15,60309)
							end
							TriggerEvent('cancelando',true)
						end 
					end
				end
			end
		end
		if processo then
			skips = 1
			drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FISGAR UM PEIXE",4,0.5,0.93,0.50,255,255,255,180)
		end
		Citizen.Wait(skips)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos >= 0 then
			segundos = segundos - 1
			if segundos < 0 then
				processo = false
				if pesca.checkPayment() then
					local source = source
					-- não existe mais _stopAin colocar clearPedTasks
					ClearPedTasks(PlayerPedId())
					vRP._DeletarObjeto(source)
				end
				TriggerEvent('cancelando',false)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
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