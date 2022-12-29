local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
Drog = Tunnel.getInterface("drogas")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local entregando = false
local selecionado = 0
local quantidade = 0

local pontos = {
	{1231.34,-290.40,71.76}, -- CV
	{736.61,-320.90,51.43}, -- ADA
	{3229.64,5127.45,19.24} -- TCP
}

local locs = {
    [1] = {['x'] = -17.23, ['y'] = -296.64, ['z'] = 45.76},
	[2] = {['x'] = -239.27, ['y'] = 244.48, ['z'] = 92.05},
    [3] = {['x'] = -559.41, ['y'] = -1804.25, ['z'] = 22.60},
    [4] = {['x'] = -566.13, ['y'] = 295.44, ['z'] = 83.02},
    [5] = {['x'] = 138.72, ['y'] = -1293.62, ['z'] = 29.23},
    [6] = {['x'] = 962.17, ['y'] = -2189.49, ['z'] = 30.50},
    [7] = {['x'] = 1121.15, ['y'] = -645.60, ['z'] = 56.81},
    [8] = {['x'] = 1242.95, ['y'] = -3113.73, ['z'] = 6.02},
    [9] = {['x'] = -67.10, ['y'] = -1312.11, ['z'] = 29.28},
    [10] = {['x'] = 1338.12, ['y'] = -1524.22, ['z'] = 54.58},
    [11] = {['x'] = -330.49, ['y'] = -2778.76, ['z'] = 5.32},
    [12] = {['x'] = 318.93, ['y'] = 268.84, ['z'] = 104.54},
    [13] = {['x'] = 1029.21, ['y'] = -408.81, ['z'] = 65.95},
    [14] = {['x'] = 632.83, ['y'] = -3015.15, ['z'] = 7.34},
    [15] = {['x'] = 183.03, ['y'] = -1688.77, ['z'] = 29.68},
    [16] = {['x'] = -1715.55, ['y'] = -447.27, ['z'] = 42.65},
    [17] = {['x'] = -1753.0, ['y'] = -724.24, ['z'] = 10.42},
    [18] = {['x'] = 794.5, ['y'] = -102.84, ['z'] = 82.04},
    [19] = {['x'] = -1116.95, ['y'] = -1505.63, ['z'] = 4.4},
    [20] = {['x'] = 941.16, ['y'] = -2141.44, ['z'] = 31.23},
    [21] = {['x'] = -18.4, ['y'] = 218.91, ['z'] = 106.75},
    [22] = {['x'] = -556.45, ['y'] = 274.72, ['z'] = 83.01},
    [23] = {['x'] = 91.33, ['y'] = 298.52, ['z'] = 110.22},
    [24] = {['x'] = -1038.40, ['y'] = -1396.94, ['z'] = 5.55},
    [25] = {['x'] = -1192.20, ['y'] = -1546.56, ['z'] = 4.37},
    [26] = {['x'] = -3005.09, ['y'] = 79.05, ['z'] = 11.60},
    [27] = {['x'] = 793.79, ['y'] = -735.68, ['z'] = 27.96},
    [28] = {['x'] = 220.47, ['y'] = 304.54, ['z'] = 105.57},
    [29] = {['x'] = 1234.31, ['y'] = -354.74, ['z'] = 69.08},
    [30] = {['x'] = -1342.50, ['y'] = -871.89, ['z'] = 16.85},
    [31] = {['x'] = 225.58, ['y'] = -1746.03, ['z'] = 29.28},
    [32] = {['x'] = -428.07, ['y'] = 294.03, ['z'] = 83.22},
    [33] = {['x'] = 930.08, ['y'] = 41.57, ['z'] = 81.09},
    [34] = {['x'] = -3152.76, ['y'] = 1110.03, ['z'] = 20.87},
    [35] = {['x'] = -1829.52, ['y'] = 801.37, ['z'] = 138.41}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIAR ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timedistance = 300
		for _,mark in pairs(pontos) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 5 then
				timedistance = 4
				if not entregando then
					if distance <= 1.2 then
						DrawText3D(x,y,z, "~g~E~w~ PARA INICIAR AS ~g~ENTREGAS DE DROGAS")
						if IsControlJustPressed(0,38) then
							entregando = true
							selecionado = math.random(#locs)
							CriandoBlipDroga(locs,selecionado)
							Drog.Quantidade()
						end
					end
				end
			end
		end
		Citizen.Wait(timedistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ STATUS ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("quantidade-drogas")
AddEventHandler("quantidade-drogas",function(status)
    quantidade = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timedistance = 300
		if entregando then
			timedistance = 4
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 10.0 then
				DrawMarker(0,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,255,255,100,1,1,0,0)
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) then
						droga = CreateObject(GetHashKey("prop_weed_block_01"),locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-1,true,true,true)
						if Drog.checkPayment() then
						
							local random = math.random(100)
							if random >= 60 then
								Drog.MarcarOcorrencia()
							end
							RemoveBlip(blips)
							backentrega = selecionado
							
							while true do
								if backentrega == selecionado then
									selecionado = math.random(#locs)
								else
									break
								end
								Citizen.Wait(1)
							end
							CriandoBlipDroga(locs,selecionado)
							Drog.Quantidade()
						end
					end
				end
			end

			if entregando then
				drawTxt("PRESSIONE ~g~F7 ~w~PARA FINALIZAR A ROTA",4,0.260,0.905,0.5,255,255,255,200)
				drawTxt("VÁ ATÉ O DESTINO ENTREGUE ~g~"..quantidade.."x~w~ DROGAS",4,0.260,0.929,0.5,255,255,255,200)
			  end
			  
			if IsControlJustPressed(0,168) then
				entregando = false
				RemoveBlip(blips)
			end
		end
		Citizen.Wait(timedistance)
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

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
	local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 50)
end

function CriandoBlipDroga(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,162)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de drogas")
	EndTextCommandSetBlipName(blips)
end
