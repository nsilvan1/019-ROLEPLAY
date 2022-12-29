local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vRPserver = Tunnel.getInterface("vRP")

local nocauteado = false
local deathtimer = 600
local in_arena = false

RegisterNetEvent("mirtin_survival:updateArena")
AddEventHandler("mirtin_survival:updateArena", function(boolean)
	in_arena = boolean
end)

--NEXUS_MORTE

function morte(deathtimer, nui)
    SendNUIMessage({ deathtimer = deathtimer, nui = nui })
end

-- Citizen.CreateThread(function()
-- 	local ped = PlayerPedId()
-- 	local health = GetEntityHealth(ped)
-- 	if GetEntityHealth(ped) == 0 then
-- 		deathtimer = 600
-- 		nocauteado = true
-- 		crestetempo()
-- 		buttonreviver()
-- 		SetEntityInvincible(ped,false) --mqcu
-- 		exports["pma-voice"]:SetRadioChannel(0)
-- 	end
-- end)
CreateThread(function()
	Wait(10000)
	local ped = PlayerPedId()

	if GetEntityHealth(ped) < 101 then 
		deathtimer = 600
		nocauteado = true
		crestetempo()
		buttonreviver()
		SetEntityInvincible(ped,false) --mqcu
		exports["pma-voice"]:SetRadioChannel(0)
	else 
		nocauteado = false
		deathtimer = 0
		morte(deathtimer, false)
	end
end)

local FaixaDeGaza = nil
local faixaActivated = false

RegisterNetEvent("SMT:toogleFaixaGaza")
AddEventHandler("SMT:toogleFaixaGaza",function(value)
	if value == "on" then
		if faixaActivated then
			return
		end
		faixaActivated = true
		FaixaDeGaza = PolyZone:Create({
			vector2(-371.6,5986.83),
			vector2(-476.78,6101.76),
			vector2(-421.47,6305.02),
			vector2(-377.51,6337.98),
			vector2(-129.01,6550.66),
			vector2(34.76,6699.87),
			vector2(206.58,6540.83),
			vector2(150.06,6507.18),
			vector2(-90.35,6270.12),
			vector2(-119.16,6245.55),
			vector2(-143.88,6221.17),
			vector2(-371.6,5986.83),		  
		}, {
			name="FaixaDeGaza",
			minZ=18.4,
			maxZ=68.24,
			debugGrid=true,
			gridDivisions=1,
			debugColors={walls={0, 0, 0}}
		})
	else
		if faixaActivated then
			FaixaDeGaza:destroy()
		end
		faixaActivated = false
	end
end)

AddEventHandler('gameEventTriggered', function (name, args)
	if name == 'CEventNetworkEntityDamage'  then
		local ped = PlayerPedId()
		if not in_arena then
			if args[1] == ped and args[6] == 1 then
				local coords = GetEntityCoords(ped)
				if faixaActivated then
					if FaixaDeGaza:isPointInside(coords) then
						deathtimer = 300
					else
						deathtimer = 600
					end
				else
					deathtimer = 600
				end
				nocauteado = true
				crestetempo()
				buttonreviver()
				vRPserver.updateHealth(0)
				local health = GetEntityHealth(ped)
					SetEntityInvincible(ped,false) --mqcu
					exports["pma-voice"]:SetRadioChannel(0)
					if PlayerPedId() == args[1] and IsPedAPlayer(args[2]) then
							local index = NetworkGetPlayerIndexFromPed(args[2])
							local source = GetPlayerServerId(index)
							local weapon = args[7]
							TriggerServerEvent("survavel:playerdeath",source,weapon)	
					end
			elseif args[1] == ped and args[11] == 1 then 
				if not IsPedAPlayer(args[2]) == args[1] then
					local coords = GetEntityCoords(ped)
					if faixaActivated then
						if FaixaDeGaza:isPointInside(coords) then
							deathtimer = 300
						else
							deathtimer = 600
						end
					else
						deathtimer = 600
					end
					nocauteado = true
					crestetempo()
					buttonreviver()
					local health = GetEntityHealth(ped)
					vRPserver.updateHealth(0)
					SetEntityHealth(ped,0)
					if PlayerPedId() == args[1] and IsPedAPlayer(args[2]) then
							local index = NetworkGetPlayerIndexFromPed(args[2])
							local source = GetPlayerServerId(index)
							local weapon = args[7]
							TriggerServerEvent("survavel:playerdeath",source,weapon)
					end
				end
			end
		else
			morte(deathtimer, false)
			-- TriggerEvent("MarsMorte", deathtimer, false)
		end
	end

end)   

RegisterNetEvent("nRevive")
AddEventHandler("nRevive", function()
	nocauteado = false
	deathtimer = 0
	morte(deathtimer, false)
	-- TriggerEvent("MarsMorte", deathtimer, false)
end)

function crestetempo()
	Citizen.CreateThread(function()
		while nocauteado do
			if deathtimer > 0 then
				morte(deathtimer, true)
				-- TriggerEvent("MarsMorte", deathtimer, true)
				deathtimer = deathtimer - 1	
			else
				morte(0, true)
			end
			Wait(1000)
		end
	end)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function buttonreviver()
	Citizen.CreateThread(function()
		while nocauteado do
			local ped = PlayerPedId()
			local health = GetEntityHealth(ped)
			local coord = GetEntityCoords(ped)

			if deathtimer <= 0 then
				if IsControlJustPressed(0,38) then
					nocauteado = false
					morte(deathtimer, false)
					-- TriggerEvent("MarsMorte", deathtimer, false)
					TriggerEvent("resetBleeding")
					TriggerEvent("resetDiagnostic")
					TriggerServerEvent("clearInventory")

					TriggerServerEvent("revisurve",coord)
					ClearPedBloodDamage(ped)
					SetEntityInvincible(ped,false)
					SetEntityHealth(ped,400)

					TriggerEvent("Midorinha",0)
					Wait(1000)

					SetEntityCoords(PlayerPedId(),-1638.52,-997.56,13.01+0.0001,1,0,0,1)
					FreezeEntityPosition(ped,true)
					local x,y,z = table.unpack(GetEntityCoords(ped)) -- RETIRAR CASO DER MERDA
					NetworkResurrectLocalPlayer(x,y,z,true,true,false) -- RETIRAR CASO DER MERDA
					SetTimeout(4000,function()
						FreezeEntityPosition(ped,false)
						Wait(1000)
					end)
				end
			end
			Wait(5)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ HEALTHRECHARGE ]---------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Wait(0)
		SetPlayerHealthRechargeMultiplier(PlayerId(),0)
		SetPedConfigFlag(PlayerPedId(-1), 438, true)
		-- ILHA
		SetRadarAsExteriorThisFrame()
        SetRadarAsInteriorThisFrame('h4_fake_islandx', vec(4700.0, -5145.0), 0, 0)
		 -- ANT VDM
		SetWeaponDamageModifier(-1553120962, 0.0)
		-- DISABLE FURTIVE
		DisableControlAction(0,36,true)
	end
end)
