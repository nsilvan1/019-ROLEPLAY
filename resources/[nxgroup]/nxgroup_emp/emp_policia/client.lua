local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

emP7 = Tunnel.getInterface("emP_policia")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0

local coordenadas = {
	{ ['id'] = 1, ['x'] = -925.37, ['y'] = -2044.42, ['z'] = 9.41 },  
	{ ['id'] = 2, ['x'] = 1849.48, ['y'] = 3687.3, ['z'] = 34.27 }, 
	{ ['id'] = 3, ['x'] = -450.5, ['y'] = 6011.02, ['z'] = 31.72 }, 
	{ ['id'] = 4, ['x'] = 1835.02, ['y'] = 2581.61, ['z'] = 45.96 }, 
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = -816.78, ['y'] = -1679.09, ['z'] = 16.92 }, 
	[2] = { ['x'] = -508.51, ['y'] = -912.63, ['z'] = 25.26 }, 
	[3] = { ['x'] = -204.22, ['y'] = -546.34, ['z'] = 33.9 }, 
	[4] = { ['x'] = 172.59, ['y'] = 192.61, ['z'] = 105.11 }, 
	[5] = { ['x'] = 624.24, ['y'] = -47.98, ['z'] = 76.15 }, 
	[6] = { ['x'] = -85.35, ['y'] = 62.55, ['z'] = 70.89 }, 
	[7] = { ['x'] = -483.32, ['y'] = 16.07, ['z'] = 44.51 }, 
	[8] = { ['x'] = -1683.46, ['y'] = -542.58, ['z'] = 35.37 }, 
	[9] = { ['x'] = -2067.89, ['y'] = -406.32, ['z'] = 10.58 }, 
	[10] = { ['x'] = -1054.81, ['y'] = -895.16, ['z'] = 3.9 }, 
	[11] = { ['x'] = -726.19, ['y'] = -1197.7, ['z'] = 9.92 }, 
	[12] = { ['x'] = -997.68, ['y'] = -1854.41, ['z'] = 17.1 }, 
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timing = 1000
		if not servico then
			for _,v in pairs(coordenadas) do
				local ped = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
				local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
				
				if distance <= 3 then
					timing = 5
					DrawMarker(21,v.x,v.y,v.z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
					if distance <= 1.2 then
						timing = 5
						drawTxtG("PRESSIONE  ~r~E~w~  PARA INICIAR A ROTA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) and emP7.checkPermission() then
							servico = true
							policostart()
							if v.id == 2 then
								selecionado = 43
							else
								selecionado = 1
							end
							CriandoBlipE(locs,selecionado)
							TriggerEvent("Notify","sucesso","Você entrou em serviço.")
						end
					end
				end
			end
		end
		Citizen.Wait(timing)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVIÇO
-----------------------------------------------------------------------------------------------------------------------------------------
function policostart()
	Citizen.CreateThread(function()
		while servico do
			local timing = 1000
			-- if servico then
				local ped = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(ped))
					local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
					local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)
					
					if distance <= 15.0 then
						timing = 5
						DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z+0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,50,1,0,0,1)
						if distance <= 4.5 then
							timing = 5
							if emP7.checkPermission() then
							if 1 > 0 then
								RemoveBlip(blips)
								if selecionado == 42 then
									selecionado = 1
								elseif selecionado == 82 then
									selecionado = 43
								else
									selecionado = selecionado + 1
								end							
								emP7.checkPayment()
								CriandoBlipE(locs,selecionado)
							end
						end
					end
				end
			-- end
			Citizen.Wait(timing)
		end
	end)
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- CANCELAR
	-----------------------------------------------------------------------------------------------------------------------------------------
	Citizen.CreateThread(function()
		while servico do
			local timing = 1000
			-- if servico then
				timing = 5
				if IsControlJustPressed(0,168) then
					servico = false
					RemoveBlip(blips)
					TriggerEvent("Notify","aviso","Você saiu de serviço.")
				end
			-- end
			Citizen.Wait(timing)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlipE(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rota de Patrulha")
	EndTextCommandSetBlipName(blips)
end

function drawTxtG(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end