local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
lenha = Tunnel.getInterface("lenhador")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
local list = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORDENADAS DAS ARVORES
-----------------------------------------------------------------------------------------------------------------------------------------
local arvores = {
	{ 1,-1578.97,4538.94,18.98 },
	{ 2,-1572.79,4520.81,19.07 },
	{ 3,-1575.64,4517.89,19.24 },
	{ 4,-1574.02,4513.43,19.98 },
	{ 5,-1572.27,4503.38,21.09 },
	{ 6,-1577.34,4504.02,20.82 },
	{ 7,-1580.87,4495.17,21.35 },
	{ 8,-1586.38,4500.06,20.75 },
	{ 9,-1591.82,4503.67,20.38 },
	{ 10,-1592.93,4501.04,20.44 },
	{ 11,-1596.97,4496.67,20.07 },
	{ 12,-1597.50,4487.70,18.69 },
	{ 13,-1602.40,4480.68,16.42 },
	{ 14,-1603.45,4483.81,17.05 },
	{ 15,-1605.55,4485.84,17.09 },
	{ 16,-1592.38,4484.62,17.17 },
	{ 17,-1591.48,4481.66,16.31 },
	{ 18,-1589.24,4487.65,18.72 },
	{ 19,-1584.40,4491.20,20.81 },
	{ 20,-1574.44,4496.91,21.73 },
	{ 21,-1574.99,4491.95,22.53 },
	{ 22,-1576.33,4485.01,22.22 },
	{ 23,-1578.53,4511.93,19.95 },
	{ 24,-1581.35,4513.32,19.59 },
	{ 25,-1583.85,4515.67,19.07 },
	{ 26,-1585.75,4517.67,18.66 },
	{ 27,-1592.67,4516.29,17.82 },
	{ 28,-1591.53,4513.23,18.69 },
	{ 29,-1599.65,4509.46,18.32 },
	{ 30,-1605.21,4508.43,17.04 },
	{ 31,-1599.58,4517.08,16.56 },
	{ 32,-1585.39,4509.44,19.97 },
	{ 33,-1589.57,4507.30,20.12 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local skips = 1000
		if not processo then
			for _,func in pairs(arvores) do
				local ped = PlayerPedId()
				local i,x,y,z = table.unpack(func)
				local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),x,y,z)
				if distancia <= 20 and list[i] == nil then
					skips = 1
					DrawMarker(21,x,y,z,0,0,0,0,180.0,130.0,0.6,0.8,0.5,98,163,41,25,1,0,0,1)
					if distancia <= 1.2 then
						skips = 1
						drawTxt("PRESSIONE  ~b~E~w~  PARA CORTAR MADEIRA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HATCHET") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BATTLEAXE") then
								if lenha.checkPayment() then
									list[i] = true
									processo = true
									segundos = 3
									SetEntityCoords(ped,x,y,z-1)
									SetEntityHeading(ped,100.0)
									vRP._playAnim(false,{{"melee@hatchet@streamed_core","plyr_front_takedown_b"}},true)
									TriggerEvent('cancelando',true)
								end
							end
						end
					end
				end
			end
		end
		if processo then
			drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR A EXTRAÇÃO DA MADEIRA",4,0.5,0.93,0.50,255,255,255,180)
		end
		Citizen.Wait(skips)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if processo then
			if segundos > 0 then
				segundos = segundos - 1
				if segundos == 0 then
					processo = false
					vRP._stopAnim(false)
					TriggerEvent('cancelando',false)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(180000)
		list = {}
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





-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------

local servico = false
local selecionado = 0
local CoordenadaX = 1213.29 --- 1213.29,-1251.14,36.33
local CoordenadaY = -1251.14
local CoordenadaZ = 36.33
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = 1408.65, ['y'] = -734.98, ['z'] = 67.69 },
	[2] = { ['x'] = 1210.62, ['y'] = -1309.52, ['z'] = 35.22 },
	[3] = { ['x'] = 1561.41, ['y'] = -1693.56, ['z'] = 89.21 },
	[4] = { ['x'] = 557.64, ['y'] = -2328.00, ['z'] = 5.82 },
	[5] = { ['x'] = -1097.71, ['y'] = -1649.72, ['z'] = 4.39 },
	[6] = { ['x'] = -2016.37, ['y'] = 559.32, ['z'] = 108.30 },
	[7] = { ['x'] = -663.58, ['y'] = 222.33, ['z'] = 81.95 },
	[8] = { ['x'] = 141.28, ['y'] = -379.58, ['z'] = 43.25 },
	[9] = { ['x'] = 23.99, ['y'] = -619.81, ['z'] = 35.34 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local skips = 1000
		if not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 30.0 then
				skips = 1
				 DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
				if distance <= 1.2 then
					skips = 1
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ENTREGAS",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						servico = true
						selecionado = math.random(9)
						CriandoBlip(locs,selecionado)
					end
				end
			end
		end
		Citizen.Wait(skips)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local skips = 1000
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 30.0 then
				skips = 1
				DrawMarker(23,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
				if distance <= 1.2 then
					skips = 1
					drawTxt("PRESSIONE  ~b~E~w~  PARA ENTREGAR TORAS DE MADEIRA",4,0.5,0.93,0.50,255,255,255,255)
					if IsControlJustPressed(0,38) then
						if lenha.checkPayment1() then
							RemoveBlip(blip)
							backentrega = selecionado
							while true do
								if backentrega == selecionado then
									selecionado = math.random(9)
								else
									break
								end
								Citizen.Wait(1)
							end
							CriandoBlip(locs,selecionado)
						end
					end
				end
			end
		end
		Citizen.Wait(skips)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if servico then		
			if IsControlJustPressed(0,168) then
				servico = false
				RemoveBlip(blip)
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

function CriandoBlip(locs,selecionado)
	blip = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	Setblipprite(blip,1)
	SetBlipColour(blip,5)
	Setblipcale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Madeira")
	EndTextCommandSetBlipName(blip)
end