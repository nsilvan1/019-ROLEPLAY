local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
eG = Tunnel.getInterface("egEventss")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emServico = false
local Cordenadas = {-20.45,-1471.95,30.72}
local localPeds = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE VENDA
-----------------------------------------------------------------------------------------------------------------------------------------
local vendas = {
	-- [1] = { x = -23.73, y = -1472.21, z = 30.83, h = 270.26 },
	[1] = { x = 327.12, y = -1258.71, z = 32.11, h = 270.26 },
	[2] = { x = 857.59, y = -1038.39, z = 33.14, h = 270.26 },
	[3] = { x = 105.23, y = -259.03, z = 51.5, h = 270.26 },
	[4] = { x = -180.57, y = 314.46, z = 97.8, h = 96.38 },   --- edit toddynho
	[5] = { x = -1321.87, y = -247.55, z = 42.47, h = 270.26 },
	[6] = { x = -1286.95, y = -833.34, z = 17.1, h = 270.26 },
	[7] = { x = -762.81, y = -1310.56, z = 9.6, h = 270.26 },
	[8] = { x = -289.26, y = -1080.56, z = 23.03, h = 270.26 },
	[9] = { x = 355.4, y = -1284.43, z = 32.53, h = 223.94 }, 		-- edit toddynho
	[10] = { x = 746.82, y = -1399.34, z = 26.63, h = 270.26 },
	[11] = { x = 889.78, y = -1045.8, z = 35.18, h = 270.26 },
	[12] = { x = 910.68, y = -1065.39, z = 37.95, h = 101.12 },		--- edit toddynho
	[13] = { x = 1257.22, y = -517.12, z = 69.1, h = 257.96 }, 	-- edit toddynho
	[14] = { x = 641.61, y = 260.8, z = 103.3, h = 62.37 },	-- edit toddynho
	[15] = { x = -326.08, y = -54.57, z = 49.04, h = 270.26 },
	[16] = { x = -490.25, y = 28.46, z = 46.3, h = 270.26 },
	[17] = { x = -1118.01, y = -185.79, z = 38.55, h = 270.26 },
	[18] = { x = -211.55, y = -787.22, z = 30.92, h = 270.26 },
	[19] = { x = -319.82, y = -1389.73, z = 36.51, h = 270.26 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRABALHAR ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("drogas",function(source,args)
	if not emServico then
		emprocesso = true
		emServico = true
		CriandoBlipD(vendas,destino)
		TriggerEvent("Notify","sucesso","Você entrou em serviço.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timing = 2000
		if not emServico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(Cordenadas[1],Cordenadas[2],Cordenadas[3])
			local distance = GetDistanceBetweenCoords(Cordenadas[1],Cordenadas[2],cdz,x,y,z,true)

			if distance <= 30.0 then
				timing = 5
				DrawMarker(23,Cordenadas[1],Cordenadas[2],Cordenadas[3]-0.97,0,0,0,0,0,0,1.0,1.0,0.5,0,200,0,50,0,0,0,0)
				if distance <= 1.2 then
					timing = 5
					drawTxtF("PRESSIONE  ~g~E~w~  PARA INICIAR ROTA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						emServico = true
						destino = 1
						CriandoBlipD(vendas,destino)
						TriggerEvent("Notify","sucesso","Você entrou em serviço.",10000)
					end
				end
			end
		end
		Citizen.Wait(timing)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timing = 2000
		if emServico then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vendas[destino].x,vendas[destino].y,vendas[destino].z,true)
			if distance <= 100 then
				timing = 1000
				SpawnPed(destino,vendas[destino].x,vendas[destino].y,vendas[destino].z,vendas[destino].h)
				local cdsPed = GetEntityCoords(localPeds[destino])
				local distancePed = #(GetEntityCoords(PlayerPedId()) - vector3(cdsPed[1],cdsPed[2],cdsPed[3]))
				if distancePed <= 2.5 and not IsPedInAnyVehicle(PlayerPedId(),true) then
					timing = 5
					drawTxtF("PRESSIONE  ~g~E~w~  PARA ENTREGAR A DROGA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						eG.marcarOcorrencia('venda de drogas')
						RequestAnimDict('mp_ped_interaction')
						EntregarDroga(destino)
						RemoveBlip(blip)
						if destino == 19 then
							eG.receberVendaDroga(1)
							destino = 1
						else
							eG.receberVendaDroga(0)
							destino = destino + 1
						end
						CriandoBlipD(vendas,destino)
					end
				end
			end
		end
		Citizen.Wait(timing)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local egSleep = 1000
		if emServico then
			egSleep = 1
			if IsControlJustPressed(0,168) then
				emServico = false
				RemoveBlip(blip)
				NpcSumir(destino)
				TriggerEvent("Notify","sucesso","Você saiu de serviço!",10000)
			end
		end
		Citizen.Wait(egSleep)
	end
end)

local peds = {
	[1] = {'g_m_y_strpunk_02',0x0DA1EAC6},
	[2] = {'cs_stretch',0x893D6805},
	[3] = {'g_m_y_strpunk_02',0x0DA1EAC6},
	[4] = {'cs_stretch',0x893D6805},
	[5] = {'g_m_y_strpunk_02',0x0DA1EAC6},
	[6] = {'cs_stretch',0x893D6805}
}

function SpawnPed(destino,x,y,z,h)
	if localPeds[destino] == nil then
		local pedType = math.random(1,6)
		RequestModel(GetHashKey(peds[pedType][1]))
		while not HasModelLoaded(GetHashKey(peds[pedType][1])) do
			RequestModel(GetHashKey(peds[pedType][1]))
			Citizen.Wait(10)
		end
		localPeds[destino] = CreatePed(4,peds[pedType][2],x,y,z-1,h,false,false)
		GiveWeaponToPed(localPeds[destino], "weapon_revolver_mk2", 1, false, false)
		SetPedTalk(localPeds[destino])
		SetPedCombatAbility(localPeds[destino],2)
		SetEntityInvincible(localPeds[destino],true)
	end
end


function EntregarDroga(destino)
	PlayPedAmbientSpeechWithVoiceNative(localPeds[destino], "GENERIC_INSULT_HIGH", "s_m_y_sheriff_01_white_full_01", "SPEECH_PARAMS_FORCE_SHOUTED", 0);
	RequestAnimDict('mp_ped_interaction')
	local ped = PlayerPedId()
	local heading = GetEntityHeading(localPeds[destino])
	local pedInFront = GetEntityCoords(localPeds[destino])
	SetEntityHeading(ped, heading - 180.1)
	-- SetEntityCoordsNoOffset(ped, pedInFront.x+1, pedInFront.y, pedInFront.z, 0)
	TaskPlayAnim(localPeds[destino],'mp_ped_interaction','handshake_guy_a',8.0,0.0,-1,2,0,0,0,0)
	TaskPlayAnim(ped,'mp_ped_interaction','handshake_guy_b',8.0,0.0,-1,2,0,0,0,0)
	Citizen.Wait(4000)
	StopAnimTask(ped, "mp_ped_interaction", "handshake_guy_b", -4.0)
	TaskChatToPed(localPeds[destino], ped,1,0,0,0,0,0,0,0)
	-- Citizen.Wait(3000)
	DeletePed(localPeds[destino])
	localPeds[destino] = nil
end

function NpcSumir(destino)
	DeletePed(localPeds[destino])
	localPeds[destino] = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCOES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxtF(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlipD(entregas,destino)
	blip = AddBlipForCoord(entregas[destino].x,entregas[destino].y,entregas[destino].z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rota de Motorista")
	EndTextCommandSetBlipName(blip)
end