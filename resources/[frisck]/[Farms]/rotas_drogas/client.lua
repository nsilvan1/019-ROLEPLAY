local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
emP = Tunnel.getInterface("drugs_sell")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local entregando = false
local selecionado = 0
local quantidade = 0

local pontos = {
	{ -2190.17,-399.46,13.31 }, 
	-- { 2623.52, -697.25, 74.69 }, 
	-- { 776.64, -307.41, 60.6 },
}

local locs = {
    [1] = { ['x'] = -14.09, ['y'] = -1442.08, ['z'] = 31.11 },
    [2] = { ['x'] = 152.58, ['y'] = -1823.7, ['z'] = 27.87 }, 
    [3] = { ['x'] = 282.63, ['y'] = -1899.0, ['z'] = 27.27 },
    [4] = { ['x'] = 399.46, ['y'] = -1864.94, ['z'] = 26.72 }, 
    [5] = { ['x'] = 443.45, ['y'] = -1707.33, ['z'] = 29.71 },
    [6] = { ['x'] = 269.6, ['y'] = -1712.98, ['z'] = 29.67 }, 
    [7] = { ['x'] = 216.41, ['y'] = -1717.29, ['z'] = 29.68 }, 
    [8] = { ['x'] = 1295.05, ['y'] = -1739.69, ['z'] = 54.28 }, 
    [9] = { ['x'] = 1220.23, ['y'] = -1658.77, ['z'] = 48.65 }, 
    [10] = { ['x'] = 970.78, ['y'] = -701.16, ['z'] = 58.49 }, 
    [11] = { ['x'] = 1388.93, ['y'] = -569.47, ['z'] = 74.5 }, 
    [12] = { ['x'] = 1328.36, ['y'] = -536.0, ['z'] = 72.45 }, 
    [13] = { ['x'] = 1264.84, ['y'] = -702.83, ['z'] = 64.91 }, 
    [14] = { ['x'] = 965.3, ['y'] = -542.01, ['z'] = 59.73 }, 
    [15] = { ['x'] = 1028.86, ['y'] = -408.42, ['z'] = 66.35 }, 
    [16] = { ['x'] = 880.28, ['y'] = -205.45, ['z'] = 71.98 }, 
    [17] = { ['x'] = -106.84, ['y'] = -8.49, ['z'] = 70.53 }, 
    [18] = { ['x'] = -667.14, ['y'] = 471.54, ['z'] = 114.14 }, 
    [19] = { ['x'] = -1107.62, ['y'] = 594.52, ['z'] = 104.46 }, 
    [20] = { ['x'] = -1174.8, ['y'] = 440.15, ['z'] = 86.85 }, 
    [21] = { ['x'] = -1753.23, ['y'] = -724.21, ['z'] = 10.41 }, 
    [22] = { ['x'] = -1967.67, ['y'] = -531.77, ['z'] = 12.18 }, 
    [23] = { ['x'] = -1093.6, ['y'] = -1608.24, ['z'] = 8.46 }, 
    [24] = { ['x'] = -1995.67, ['y'] = 591.13, ['z'] = 117.91 }, 
    [25] = { ['x'] = -597.12, ['y'] = 851.67, ['z'] = 211.45 }, 
    [26] = { ['x'] = -1100.54, ['y'] = 2722.43, ['z'] = 18.81 }, 
    [27] = { ['x'] = 634.94, ['y'] = 2774.95, ['z'] = 42.02 }, 
    [28] = { ['x'] = 1142.33, ['y'] = 2654.7, ['z'] = 38.16 }, 
    [29] = { ['x'] = 106.23, ['y'] = -1280.82, ['z'] = 29.26 }, 
    [30] = { ['x'] = -833.35, ['y'] = -1071.59, ['z'] = 11.66 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIAR ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local sleep = 300
		for _,mark in pairs(pontos) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 5 then
				sleep = 4
				DrawMarker(21,x,y,z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,255,0,50,0,0,0,1)
				if not entregando then
					if distance <= 1.0 then
						drawTxt("PRESSIONE  ~y~E~w~  PARA INICIAR AS ENTREGAS",4,0.5,0.92,0.35,255,255,255,180)
						if IsControlJustPressed(0,38) then
							entregando = true
							selecionado = math.random(#locs)
							CriandoBlip(locs,selecionado)
							emP.Quantidade()
						end
					end
				end
			end
		end
		Citizen.Wait(sleep)
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
		local sleep = 300
		if entregando then
			sleep = 4
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 30.0 then
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,255,0,50,0,0,0,1)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~y~E~w~  PARA ENTREGAR AS DROGAS",4,0.5,0.92,0.35,255,255,255,180)
					if IsControlJustPressed(0,38) then
						droga = CreateObject(GetHashKey("prop_weed_block_01"),locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-1,true,true,true)
						if emP.checkPayment() then
							emP.MarcarOcorrencia()
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
							CriandoBlip(locs,selecionado)
							emP.Quantidade()
						end
					end
				end
			end

			if entregando then
				drawTxt("~y~PRESSIONE ~r~F7 ~w~PARA FINALIZAR A ROTA",4,0.230,0.905,0.35,255,255,255,200)
				drawTxt("VÁ ATÉ O DESTINO E VENDA ~g~"..quantidade.."x~w~ DROGAS",4,0.230,0.93,0.35,255,255,255,200)
			  end
			  
			if IsControlJustPressed(0,168) then
				entregando = false
				RemoveBlip(blips)
			end
		end
		Citizen.Wait(sleep)
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
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Drogas")
	EndTextCommandSetBlipName(blips)
end
