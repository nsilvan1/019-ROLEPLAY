local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = Tunnel.getInterface("vrp_player")
srcserver = Tunnel.getInterface("vrp_player")
------------------------------------------------------------------------------------------------------------------------
--------[ COMANDO /FPS ON & OFF ]---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fps",function(source,args)
    if args[1] == "on" then
        SetTimecycleModifier("cinema")
        TriggerEvent("Notify","sucesso","Boost de fps ligado!")
    elseif args[1] == "off" then
        SetTimecycleModifier("default")
        TriggerEvent("Notify","sucesso","Boost de fps desligado!")
    end
end)

RegisterCommand('record',function(source, args) 
    if tostring(args[1]) == 'start' then
        StartRecording(1)
    elseif tostring(args[1]) == 'save' then
        StopRecordingAndSaveClip()
    elseif tostring(args[1]) == 'discard' then
        StopRecordingAndDiscardClip()
    elseif tostring(args[1]) == 'open' then
        NetworkSessionLeaveSinglePlayer()

        ActivateRockstarEditor()
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(10000)
-- 		local players = GlobalState.qtdPl or 0--vRPdc.GetDCpresence()
--     	SetDiscordAppId(936250353450627102)
--         SetDiscordRichPresenceAsset('AZTLAN')
--         SetDiscordRichPresenceAssetText('CITY AZTLAN')
--         SetDiscordRichPresenceAssetSmall('capa')
--         SetDiscordRichPresenceAssetSmallText('discord.gg/BRhMcVGRWT')
--         SetRichPresence("Jogadores online: "..players.."")
-- 		SetDiscordRichPresenceAction(0, "JOGAR", "fivem://connect/3boqe8")
-- 		SetDiscordRichPresenceAction(1, "DISCORD", "discord.gg/BRhMcVGRWT")
--     end
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUS DO DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        players = {}
        -- for i = 0,1024 do
        --     if NetworkIsPlayerActive(i) then
        --         table.insert(players,i)
        --     end
        -- end
        SetDiscordAppId(936250353450627102) -- ID DO APP AQUI
		SetDiscordRichPresenceAssetText('AZTLAN, WL ABERTA!') -- PNG DESCRIÇÃO 1 TEXTO
        SetDiscordRichPresenceAsset('capa')
		SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/BRhMcVGRWT/")
		SetDiscordRichPresenceAction(1, "Instagram", "https://www.instagram.com/aztlanrp/")
		SetRichPresence("Players Online: 38 de 680")	
        -- SetRichPresence("Cidadões Online: "..#players "1024")
		
    end
end)


local started = false
RegisterCommand("manobras", function()
    started = not started 
    if started then
        TriggerEvent("Notify","sucesso","Você ativou as manobras",10000,"bottom")
        Citizen.CreateThread(function()
            while started do
                local timeIdle = 999
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(ped)
                local speed = GetEntitySpeed(vehicle) * 3.6 
                if IsPedOnAnyBike(ped) then
                    if speed >= 20 then
                        timeIdle = 5
        
                        while not HasAnimDictLoaded("rcmextreme2atv") do
                            Citizen.Wait(0)
                            RequestAnimDict("rcmextreme2atv")
                        end
        
                        if IsControlJustPressed(0,174) or IsControlJustPressed(0,108) then -- Seta esquerda ou numpad 4
                            TaskPlayAnim(ped, "rcmextreme2atv", "idle_b", 8.0, -8.0, -1, 32, 0, false, false, false)
                        elseif IsControlJustPressed(0,175) or IsControlJustPressed(0,107) then
                            TaskPlayAnim(ped, "rcmextreme2atv", "idle_c", 8.0, -8.0, -1, 32, 0, false, false, false)
                        elseif IsControlJustPressed(0,173) or IsControlJustPressed(0,110) then
                            TaskPlayAnim(ped, "rcmextreme2atv", "idle_d", 8.0, -8.0, -1, 32, 0, false, false, false)
                        elseif IsControlJustPressed(0,27) or IsControlJustPressed(0,111) then
                            TaskPlayAnim(ped, "rcmextreme2atv", "idle_e", 8.0, -8.0, -1, 32, 0, false, false, false)
                        end
                    end
                end
        
                Citizen.Wait(timeIdle)
            end
        end)
    else
        TriggerEvent("Notify","sucesso","Você desativou as manobras",10000,"bottom")
    end
end)
------------------------------------------------------------------------------------------------------------------------
--------[ MORRER E FICAR DEITADO ]---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
--     while true do
--     Wait(300)
--     local ped = PlayerPedId()
--         if GetEntityHealth(ped) <= 101 then    
--             if not IsEntityPlayingAnim(ped,"mini@cpr@char_b@cpr_str","cpr_kol_idle",3) then            
--             	vRP.playAnim(false,{{"mini@cpr@char_b@cpr_str","cpr_kol_idle"}},true)
--             end
--         end
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ VTUNING ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vtuning",function(source,args)
	local vehicle = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(vehicle) then
		local motor = GetVehicleMod(vehicle,11)
		local freio = GetVehicleMod(vehicle,12)
		local transmissao = GetVehicleMod(vehicle,13)
		local suspensao = GetVehicleMod(vehicle,15)
		local blindagem = GetVehicleMod(vehicle,16)
		local body = GetVehicleBodyHealth(vehicle)
		local engine = GetVehicleEngineHealth(vehicle)
		local fuel = GetVehicleFuelLevel(vehicle)

		if motor == -1 then
			motor = "Desativado"
		elseif motor == 0 then
			motor = "Nível 1 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 1 then
			motor = "Nível 2 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 2 then
			motor = "Nível 3 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 3 then
			motor = "Nível 4 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 4 then
			motor = "Nível 5 / "..GetNumVehicleMods(vehicle,11)
		end

		if freio == -1 then
			freio = "Desativado"
		elseif freio == 0 then
			freio = "Nível 1 / "..GetNumVehicleMods(vehicle,12)
		elseif freio == 1 then
			freio = "Nível 2 / "..GetNumVehicleMods(vehicle,12)
		elseif freio == 2 then
			freio = "Nível 3 / "..GetNumVehicleMods(vehicle,12)
		end

		if transmissao == -1 then
			transmissao = "Desativado"
		elseif transmissao == 0 then
			transmissao = "Nível 1 / "..GetNumVehicleMods(vehicle,13)
		elseif transmissao == 1 then
			transmissao = "Nível 2 / "..GetNumVehicleMods(vehicle,13)
		elseif transmissao == 2 then
			transmissao = "Nível 3 / "..GetNumVehicleMods(vehicle,13)
		elseif transmissao == 3 then
			transmissao = "Nível 4 / "..GetNumVehicleMods(vehicle,13)
		end

		if suspensao == -1 then
			suspensao = "Desativado"
		elseif suspensao == 0 then
			suspensao = "Nível 1 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 1 then
			suspensao = "Nível 2 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 2 then
			suspensao = "Nível 3 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 3 then
			suspensao = "Nível 4 / "..GetNumVehicleMods(vehicle,15)
		end

		if blindagem == -1 then
			blindagem = "Desativado"
		elseif blindagem == 0 then
			blindagem = "Nível 1 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 1 then
			blindagem = "Nível 2 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 2 then
			blindagem = "Nível 3 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 3 then
			blindagem = "Nível 4 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 4 then
			blindagem = "Nível 5 / "..GetNumVehicleMods(vehicle,16)
		end

		TriggerEvent("Notify","importante","<b>Motor:</b> "..motor.."<br><b>Freio:</b> "..freio.."<br><b>Transmissão:</b> "..transmissao.."<br><b>Suspensão:</b> "..suspensao.."<br><b>Blindagem:</b> "..blindagem.."<br><b>Chassi:</b> "..parseInt(body/10).."%<br><b>Engine:</b> "..parseInt(engine/10).."%<br><b>Gasolina:</b> "..parseInt(fuel).."%",15000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ANDAR ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("homem",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@confident")
	end
end)

RegisterCommand("mulher",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_f@heels@c")
	end
end)

RegisterCommand("depressivo",function(source,args)
	if not prisioneiro then
		vRP.loadAnimSet("move_m@depressed@a")
	end
end)

RegisterCommand("depressiva",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_f@depressed@a")
	end
end)

RegisterCommand("empresario",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@business@a")
	end
end)

RegisterCommand("determinado",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@brave@a")
	end	
end)

RegisterCommand("descontraido",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@casual@a")
	end
end)

RegisterCommand("farto",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@fat@a")
	end
end)

RegisterCommand("estiloso",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@hipster@a")
	end
end)

RegisterCommand("ferido",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@injured")
	end
end)

RegisterCommand("nervoso",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@hurry@a")
	end
end)

RegisterCommand("desleixado",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@hobo@a")
	end
end)

RegisterCommand("infeliz",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@sad@a")
	end
end)

RegisterCommand("musculoso",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@muscle@a")
	end
end)

RegisterCommand("desligado",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@shadyped@a")
	end
end)

RegisterCommand("fadiga",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@buzzed")
	end
end)

RegisterCommand("apressado",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@hurry_butch@a")
	end
end)

RegisterCommand("descolado",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@money")
	end
end)

RegisterCommand("corridinha",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@quick")
	end
end)

RegisterCommand("piriguete",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_f@maneater")
	end
end)

RegisterCommand("petulante",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_f@sassy")
	end
end)

RegisterCommand("arrogante",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_f@arrogant@a")
	end
end)

RegisterCommand("bebado",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@drunk@slightlydrunk")
	end
end)

RegisterCommand("bebado2",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@drunk@verydrunk")
	end
end)

RegisterCommand("bebado3",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@drunk@moderatedrunk")
	end
end)

RegisterCommand("irritado",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@fire")
	end
end)

RegisterCommand("intimidado",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_m@intimidation@cop@unarmed")
	end
end)

RegisterCommand("poderosa",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_f@handbag")
	end
end)

RegisterCommand("chateado",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_f@injured")
	end
end)

RegisterCommand("estilosa",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_f@posh@")
	end
end)

RegisterCommand("sensual",function(source,args)
	if not prisioneiro then
	vRP.loadAnimSet("move_f@sexy@a")
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ SALÁRIO ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(45*60000)
		TriggerServerEvent('salario:pagamento2')
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORONHADA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
    	local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
       		DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
           	DisableControlAction(1, 142, true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ATIRAR DE DENTRO DO CARRO MECHE A CAMERA ]-------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3)
		local ped = PlayerPedId()
	   	local shot = IsPedShooting(ped)
		if shot == 1 and IsPedInAnyVehicle(ped) then
			ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06) -- só alterar o valor --
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AGACHAR
-----------------------------------------------------------------------------------------------------------------------------------------
local agachar = false
RegisterKeyMapping("agachar","Agachar","keyboard","LCONTROL")
RegisterCommand("agachar",function(source,args)
    if not cancelando and not vRP.isHandCuffed() then
        if not IsPauseMenuActive() then
            local ped = PlayerPedId()
            if GetEntityHealth(ped) > 101 and not cancelando and not IsPedInAnyVehicle(PlayerPedId()) then
				RequestAnimSet("move_ped_crouched")
				while not HasAnimSetLoaded("move_ped_crouched") do
					Citizen.Wait(1)
				end

				if agachar then
					ResetPedMovementClipset(ped,0.25)
					agachar = false
				else
					SetPedMovementClipset(ped,"move_ped_crouched",0.25)
					agachar = true
					-- blockFireAgachar()
                end
            end
        end
    end
end)

-- function blockFireAgachar()
-- 	Citizen.CreateThread(function()
-- 		while agachar do
-- 			local sleep = 500
-- 			if IsPedArmed(PlayerPedId(), 6) and not IsPedInAnyVehicle(PlayerPedId()) then
-- 				sleep = 0
--				DisablePlayerFiring(PlayerPedId(), true)
-- 			end
-- 			Citizen.Wait(sleep)
-- 		end
-- 	end)
-- end

RegisterNetEvent("SyncDoorsEveryone")
AddEventHandler("SyncDoorsEveryone",function(veh,doors)
	SetVehicleDoorsLocked(veh,doors)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONCOLOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cor",function(source,args)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    if src.checkMasterPerm() then
        if weapon and parseInt(args[1]) then
            SetPedWeaponTintIndex(ped,weapon,parseInt(args[1]))
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ATTACHS ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setattachs')
AddEventHandler('setattachs',function(source,args)
	local ped = PlayerPedId()
	
	if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_COMBATPISTOL") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPISTOL"),GetHashKey("COMPONENT_AT_PI_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPISTOL"),GetHashKey("COMPONENT_COMBATPISTOL_CLIP_02"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_FLSH_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_COMP"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_RAIL"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_MUZZLE_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_CR_BARREL_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_COMBATPDW") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_SCOPE_SMALL"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_AR_FLSH"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_MUZZLE_05"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_BARREL_02"))
		
	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE"),GetHashKey("COMPONENT_AT_SCOPE_MACRO"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))
		
	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTSMG"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTSMG"),GetHashKey("COMPONENT_AT_SCOPE_MACRO"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTSMG"),GetHashKey("COMPONENT_AT_AR_SUPP_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTSMG"),GetHashKey("COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PUMPSHOTGUN") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PUMPSHOTGUN"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PUMPSHOTGUN"),GetHashKey("COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))

      elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") then
    	GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE_MK2"),GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE_MK2"),GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE_MK2"),GetHashKey("COMPONENT_AT_MUZZLE_05"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE_MK2"),GetHashKey("COMPONENT_AT_SC_BARREL_02"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE") then
        GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))
		
	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_AT_SCOPE_MACRO_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_AT_PI_SUPP"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_SMG_VARMOD_LUXE"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SNIPERRIFLE") then
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SNIPERRIFLE"),GetHashKey("COMPONENT_AT_AR_SUPP_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SNIPERRIFLE"),GetHashKey("COMPONENT_AT_SCOPE_MAX"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SNIPERRIFLE"),GetHashKey("COMPONENT_SNIPERRIFLE_VARMOD_LUXE"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SNIPERRIFLE"),GetHashKey("COMPONENT_SNIPERRIFLE_CLIP_01"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_APPISTOL") then
	      GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_APPISTOL"),GetHashKey("COMPONENT_AT_PI_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_APPISTOL"),GetHashKey("COMPONENT_AT_PI_SUPP"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_APPISTOL"),GetHashKey("COMPONENT_APPISTOL_CLIP_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_APPISTOL"),GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE"))

	elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") then
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ BEBIDAS ENERGETICAS ]----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local energetico = false
RegisterNetEvent('energeticos')
AddEventHandler('energeticos',function(status)
	energetico = status
	if energetico then
		SetRunSprintMultiplierForPlayer(PlayerId(),1.30)
	else
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		if energetico then
			RestorePlayerStamina(PlayerId(),1.0)
		end
		Citizen.Wait(sleep)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ STAMINA INFINITA ]-------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread( function()
--     while true do
--     Citizen.Wait(1000)
--         RestorePlayerStamina(PlayerId(), 1.0)
--     end
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ CANCELANDO O F6 ]--------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local cancelando = false
RegisterNetEvent('cancelando')
AddEventHandler('cancelando',function(status)
    cancelando = status
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		if cancelando then
			sleep = 1
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,29,true)
			DisableControlAction(0,38,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,137,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,169,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,245,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,344,true)			
		end
		Citizen.Wait(sleep)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ABRIR CAPO DO VEICULO ]--------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("capo",function(source,args)
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("tryhood",VehToNet(vehicle))
	end
end)

RegisterNetEvent("synchood")
AddEventHandler("synchood",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,4)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if isopen == 0 then
					SetVehicleDoorOpen(v,4,0,0)
				else
					SetVehicleDoorShut(v,4,0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ABRE E FECHA OS VIDROS ]-------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local vidros = false
RegisterCommand("vidros",function(source,args)
	local v = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(v) then
		if NetworkHasControlOfEntity(v) then
			if vidros then
				vidros = false
				RollUpWindow(v,0)
				RollUpWindow(v,1)
				RollUpWindow(v,2)
				RollUpWindow(v,3)
			else
				vidros = true
				RollDownWindows(v)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ABRIR PORTAS DO VEICULO ]------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("portas",function(source,args)
	local v = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(v) then
		local door = parseInt(args[1])
		local isopen = GetVehicleDoorAngleRatio(v,0) and GetVehicleDoorAngleRatio(v,1)
		if NetworkHasControlOfEntity(v) then
			if door > 0 and door <= 6 then
				if GetVehicleDoorAngleRatio(v,door-1) == 0 then
					SetVehicleDoorOpen(v,door-1,0,0)
				else
					SetVehicleDoorShut(v,door-1,0)
				end
			else
				if isopen == 0 then
					SetVehicleDoorOpen(v,0,0,0)
					SetVehicleDoorOpen(v,1,0,0)
					SetVehicleDoorOpen(v,2,0,0)
					SetVehicleDoorOpen(v,3,0,0)
					SetVehicleDoorOpen(v,4,0,0)
					SetVehicleDoorOpen(v,5,0,0)
				else
					SetVehicleDoorShut(v,0,0)
 					SetVehicleDoorShut(v,1,0)
 					SetVehicleDoorShut(v,2,0)
 					SetVehicleDoorShut(v,3,0)
					SetVehicleDoorShut(v,4,0)
					SetVehicleDoorShut(v,5,0)
				end
			end
		end
	end
end)

RegisterNetEvent("syncdoors")
AddEventHandler("syncdoors",function(index,door)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,0) and GetVehicleDoorAngleRatio(v,1)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if door == "1" then
					if GetVehicleDoorAngleRatio(v,0) == 0 then
						SetVehicleDoorOpen(v,0,0,0)
					else
						SetVehicleDoorShut(v,0,0)
					end
				elseif door == "2" then
					if GetVehicleDoorAngleRatio(v,1) == 0 then
						SetVehicleDoorOpen(v,1,0,0)
					else
						SetVehicleDoorShut(v,1,0)
					end
				elseif door == "3" then
					if GetVehicleDoorAngleRatio(v,2) == 0 then
						SetVehicleDoorOpen(v,2,0,0)
					else
						SetVehicleDoorShut(v,2,0)
					end
				elseif door == "4" then
					if GetVehicleDoorAngleRatio(v,3) == 0 then
						SetVehicleDoorOpen(v,3,0,0)
					else
						SetVehicleDoorShut(v,3,0)
					end
				elseif door == nil then
					if isopen == 0 then
						SetVehicleDoorOpen(v,0,0,0)
						SetVehicleDoorOpen(v,1,0,0)
						SetVehicleDoorOpen(v,2,0,0)
						SetVehicleDoorOpen(v,3,0,0)
					else
						SetVehicleDoorShut(v,0,0)
						SetVehicleDoorShut(v,1,0)
						SetVehicleDoorShut(v,2,0)
						SetVehicleDoorShut(v,3,0)
					end
				end
			end
		end
	end
end)

RegisterNetEvent("synctrunk")
AddEventHandler("synctrunk",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,5)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if isopen == 0 then
					SetVehicleDoorOpen(v,5,0,0)
				else
					SetVehicleDoorShut(v,5,0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMASCARA
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterNetEvent('setmascara')
-- AddEventHandler('setmascara',function(modelo,cor)
-- 	local ped = PlayerPedId()
-- 	if GetEntityHealth(ped) > 101 then
-- 		print('teste 1')
-- 		if modelo == nil then
-- 			print('teste 2')
-- 			vRP._playAnim(true,{{"missfbi4","takeoff_mask"}},false)
-- 			Wait(1100)
-- 			ClearPedTasks(ped)
-- 			SetPedComponentVariation(ped,1,0,0,2)
-- 			return
-- 		end
-- 		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") or GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
-- 			print('teste 3')
-- 			vRP._playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps"}},false)
-- 			Wait(1500)
-- 			ClearPedTasks(ped)
-- 			SetPedComponentVariation(ped,1,parseInt(modelo),parseInt(cor),2)
-- 		end
-- 	end
-- end)
RegisterNetEvent("mascara")
AddEventHandler("mascara",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		vRP.playAnim(true,{{"misscommon@std_take_off_masks","take_off_mask_ps",1}},false)
		Wait(1700)
		ClearPedTasks(ped)
		SetPedComponentVariation(ped,1,0,0,2)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") or GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		vRP.playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps",1}},false)
		Wait(1700)
		ClearPedTasks(ped)
		SetPedComponentVariation(ped,1,parseInt(index),parseInt(color),2)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBLUSA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("blusa")
AddEventHandler("blusa",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		SetPedComponentVariation(ped,8,15,0,2)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
		Wait(5000)
		SetPedComponentVariation(ped,8,parseInt(index),parseInt(color),2)
		ClearPedTasks(ped)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
		Wait(5000)
		SetPedComponentVariation(ped,8,parseInt(index),parseInt(color),2)
		ClearPedTasks(ped)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('mochila')
AddEventHandler('mochila',function(modelo,cor)
	local ped = PlayerPedId()
    if GetEntityHealth(ped) > 101 then
        if not modelo then
            vRP._playAnim(true,{{"missmic4","michael_tux_fidget"}},false)
            Wait(2500)
            ClearPedTasks(ped)
            SetPedComponentVariation(ped,5,15,0,2)
            return
        end
        if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
            vRP._playAnim(true,{{"missmic4","michael_tux_fidget"}},false)
            Wait(2500)
            ClearPedTasks(ped)
            SetPedComponentVariation(ped,5,parseInt(modelo),parseInt(cor),2)
        elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
            vRP._playAnim(true,{{"missmic4","michael_tux_fidget"}},false)
            Wait(2500)
            ClearPedTasks(ped)
            SetPedComponentVariation(ped,5,parseInt(modelo),parseInt(cor),2)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCOLETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("colete")
AddEventHandler("colete",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		SetPedComponentVariation(ped,11,15,0,2)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
		Wait(5000)
		SetPedComponentVariation(ped,9,parseInt(index),parseInt(color),2)
		ClearPedTasks(ped)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
		Wait(5000)
		SetPedComponentVariation(ped,9,parseInt(index),parseInt(color),2)
		ClearPedTasks(ped)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETJAQUETA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("jaqueta")
AddEventHandler("jaqueta",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		SetPedComponentVariation(ped,11,15,0,2)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
		Wait(5000)
		SetPedComponentVariation(ped,11,parseInt(index),parseInt(color),2)
		ClearPedTasks(ped)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
		Wait(5000)
		SetPedComponentVariation(ped,11,parseInt(index),parseInt(color),2)
		ClearPedTasks(ped)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMAOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('maos')
AddEventHandler('maos',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if not modelo then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,3,15,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,3,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,3,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCALCA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('calca')
AddEventHandler('calca',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if not modelo then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				vRP._playAnim(true,{{"clothingtrousers","try_trousers_neutral_c"}},false)
				Wait(2500)
				ClearPedTasks(ped)
				SetPedComponentVariation(ped,4,18,0,2)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				vRP._playAnim(true,{{"clothingtrousers","try_trousers_neutral_c"}},false)
				Wait(2500)
				ClearPedTasks(ped)
				SetPedComponentVariation(ped,4,15,0,2)
			end
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"clothingtrousers","try_trousers_neutral_c"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,4,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"clothingtrousers","try_trousers_neutral_c"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,4,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETACESSORIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('acessorios')
AddEventHandler('acessorios',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if not modelo then
			SetPedComponentVariation(ped,7,0,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,7,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,7,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSAPATOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('sapatos')
AddEventHandler('sapatos',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101  and not IsPedInAnyVehicle(ped) then
		if not modelo then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				vRP._playAnim(false,{{"clothingshoes","try_shoes_positive_d"}},false)
				Wait(2200)
				SetPedComponentVariation(ped,6,34,0,2)
				Wait(500)
				ClearPedTasks(ped)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				vRP._playAnim(false,{{"clothingshoes","try_shoes_positive_d"}},false)
				Wait(2200)
				SetPedComponentVariation(ped,6,35,0,2)
				Wait(500)
				ClearPedTasks(ped)
			end
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(false,{{"clothingshoes","try_shoes_positive_d"}},false)
			Wait(2200)
			SetPedComponentVariation(ped,6,parseInt(modelo),parseInt(cor),2)
			Wait(500)
			ClearPedTasks(ped)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(false,{{"clothingshoes","try_shoes_positive_d"}},false)
			Wait(2200)
			SetPedComponentVariation(ped,6,parseInt(modelo),parseInt(cor),2)
			Wait(500)
			ClearPedTasks(ped)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCHAPEU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('chapeu')
AddEventHandler('chapeu',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if not modelo then
			vRP._playAnim(true,{{"veh@common@fp_helmet@","take_off_helmet_stand"}},false)
			Wait(700)
			ClearPedProp(ped,0)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") and parseInt(modelo) ~= 39 then
			vRP._playAnim(true,{{"veh@common@fp_helmet@","put_on_helmet"}},false)
			Wait(1700)
			SetPedPropIndex(ped,0,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") and parseInt(modelo) ~= 38 then
			vRP._playAnim(true,{{"veh@common@fp_helmet@","put_on_helmet"}},false)
			Wait(1700)
			SetPedPropIndex(ped,0,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('oculos')
AddEventHandler('oculos',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if not modelo then
			vRP._playAnim(true,{{"mini@ears_defenders","takeoff_earsdefenders_idle"}},false)
			Wait(500)
			ClearPedTasks(ped)
			ClearPedProp(ped,1)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps"}},false)
			Wait(800)
			ClearPedTasks(ped)
			SetPedPropIndex(ped,1,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps"}},false)
			Wait(800)
			ClearPedTasks(ped)
			SetPedPropIndex(ped,1,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TOW ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local reboque = nil
local rebocado = nil
RegisterCommand('tow',function(source,args)
    local vehicle = GetPlayersLastVehicle()
    local vehicletow = IsVehicleModel(vehicle,GetHashKey("flatbed"))

    if vehicletow and not IsPedInAnyVehicle(PlayerPedId()) then
        rebocado = getVehicleInDirection(GetEntityCoords(PlayerPedId()),GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,5.0,0.0))
        if IsEntityAVehicle(vehicle) and IsEntityAVehicle(rebocado) then
            TriggerServerEvent("trytow",VehToNet(vehicle),VehToNet(rebocado))
        end
    end
end)

RegisterNetEvent('synctow')
AddEventHandler('synctow',function(vehid,rebid)
    if NetworkDoesNetworkIdExist(vehid) and NetworkDoesNetworkIdExist(rebid) then
        local vehicle = NetToVeh(vehid)
        local rebocado = NetToVeh(rebid)
        if DoesEntityExist(vehicle) and DoesEntityExist(rebocado) then
            if reboque == nil then
                if vehicle ~= rebocado then
                    local min,max = GetModelDimensions(GetEntityModel(rebocado))
                    AttachEntityToEntity(rebocado,vehicle,GetEntityBoneIndexByName(vehicle,"bodyshell"),0,-2.2,0.4-min.z,0,0,0,1,1,0,1,0,1)
                    reboque = rebocado
                end
            else
                AttachEntityToEntity(reboque,vehicle,20,-0.5,-15.0,-0.3,0.0,0.0,0.0,false,false,true,false,20,true)
                DetachEntity(reboque,false,false)
                PlaceObjectOnGroundProperly(reboque)
                reboque = nil
                rebocado = nil
            end
        end
    end
end)

function getVehicleInDirection(coordsfrom,coordsto)
	local handle = CastRayPointToPoint(coordsfrom.x,coordsfrom.y,coordsfrom.z,coordsto.x,coordsto.y,coordsto.z,10,PlayerPedId(),false)
	local a,b,c,d,vehicle = GetRaycastResult(handle)
	return vehicle
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ REPARAR ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('reparar')
AddEventHandler('reparar',function()
	local vehicle = vRP.getNearestVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("tryreparar",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncreparar')
AddEventHandler('syncreparar',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local fuel = GetVehicleFuelLevel(v)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleFixed(v)
				SetVehicleDirtLevel(v,0.0)
				SetVehicleUndriveable(v,false)
				Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
				SetVehicleOnGroundProperly(v)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ REPARAR MOTOR ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('repararmotor')
AddEventHandler('repararmotor',function()
	local vehicle = vRP.getNearestVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("trymotor",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncmotor')
AddEventHandler('syncmotor',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleEngineHealth(v,1000.0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SEQUESTRO 2 ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local sequestrado = nil
RegisterCommand("sequestro2",function(source,args)
	local ped = PlayerPedId()
	local random,npc = FindFirstPed()
	repeat
		local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),GetEntityCoords(npc),true)
		if not IsPedAPlayer(npc) and distancia <= 3 and not IsPedInAnyVehicle(npc) then
			vehicle = vRP.getNearestVehicle(7)
			if IsEntityAVehicle(vehicle) then
				if vRP.getCarroClass(vehicle) then
					if sequestrado then
						AttachEntityToEntity(sequestrado,vehicle,GetEntityBoneIndexByName(vehicle,"bumper_r"),0.6,-1.2,-0.6,60.0,-90.0,180.0,false,false,false,true,2,true)
						DetachEntity(sequestrado,true,true)
						SetEntityVisible(sequestrado,true)
						SetEntityInvincible(sequestrado,false)
						Citizen.InvokeNative(0xAD738C3085FE7E11,sequestrado,true,true)
						ClearPedTasksImmediately(sequestrado)
						sequestrado = nil
					elseif not sequestrado then
						Citizen.InvokeNative(0xAD738C3085FE7E11,npc,true,true)
						AttachEntityToEntity(npc,vehicle,GetEntityBoneIndexByName(vehicle,"bumper_r"),0.6,-0.4,-0.1,60.0,-90.0,180.0,false,false,false,true,2,true)
						SetEntityVisible(npc,false)
						SetEntityInvincible(npc,true)
						sequestrado = npc
						complet = true
					end
					TriggerServerEvent("trymala",VehToNet(vehicle))
				end
			end
		end
		complet,npc = FindNextPed(random)
	until not complet
	EndFindPed(random)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ HASH ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("checkhash",function(source,args)
    local ped = PlayerPedId()
    if ped then
        local xesquedele = GetHashKey("mp_m_freemode_01")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ EMPURRAR ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc,moveFunc,disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = { handle = iter, destructor = disposeFunc }
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next,id = moveFunc(iter)
		until not next

		enum.destructor,enum.handle = nil,nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle,FindNextVehicle,EndFindVehicle)
end

function GetVeh()
    local vehicles = {}
    for vehicle in EnumerateVehicles() do
        table.insert(vehicles,vehicle)
    end
    return vehicles
end

function GetClosestVeh(coords)
	local vehicles = GetVeh()
	local closestDistance = -1
	local closestVehicle = -1
	local coords = coords

	if coords == nil then
		local ped = PlayerPedId()
		coords = GetEntityCoords(ped)
	end

	for i=1,#vehicles,1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance = GetDistanceBetweenCoords(vehicleCoords,coords.x,coords.y,coords.z,true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end
	return closestVehicle,closestDistance
end

local First = vector3(0.0,0.0,0.0)
local Second = vector3(5.0,5.0,5.0)
local Vehicle = { Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil }

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local closestVehicle,Distance = GetClosestVeh()
		if Distance < 6.1 and not IsPedInAnyVehicle(ped) then
			Vehicle.Coords = GetEntityCoords(closestVehicle)
			Vehicle.Dimensions = GetModelDimensions(GetEntityModel(closestVehicle),First,Second)
			Vehicle.Vehicle = closestVehicle
			Vehicle.Distance = Distance
			if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
				Vehicle.IsInFront = false
			else
				Vehicle.IsInFront = true
			end
		else
			Vehicle = { Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil }
		end
		Citizen.Wait(500)
	end
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(500)
		if Vehicle.Vehicle ~= nil then
			local ped = PlayerPedId()
			if IsControlPressed(0,244) and GetEntityHealth(ped) > 100 and IsVehicleSeatFree(Vehicle.Vehicle,-1) and not IsEntityInAir(ped) and not IsPedBeingStunned(ped) and not IsEntityAttachedToEntity(ped,Vehicle.Vehicle) and not (GetEntityRoll(Vehicle.Vehicle) > 75.0 or GetEntityRoll(Vehicle.Vehicle) < -75.0) then
				RequestAnimDict('missfinale_c2ig_11')
				TaskPlayAnim(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0,-8.0,-1,35,0,0,0,0)
				NetworkRequestControlOfEntity(Vehicle.Vehicle)

				if Vehicle.IsInFront then
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y*-1+0.1,Vehicle.Dimensions.z+1.0,0.0,0.0,180.0,0.0,false,false,true,false,true)
				else
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y-0.3,Vehicle.Dimensions.z+1.0,0.0,0.0,0.0,0.0,false,false,true,false,true)
				end

				while true do
					Citizen.Wait(5)
					if IsDisabledControlPressed(0,34) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,11,100)
					end

					if IsDisabledControlPressed(0,9) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,10,100)
					end

					if Vehicle.IsInFront then
						SetVehicleForwardSpeed(Vehicle.Vehicle,-1.0)
					else
						SetVehicleForwardSpeed(Vehicle.Vehicle,1.0)
					end

					if not IsDisabledControlPressed(0,244) then
						DetachEntity(ped,false,false)
						StopAnimTask(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0)
						break
					end
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- /SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skin",function(source,args)
	if not args[1] then
		TriggerEvent('Notify', 'aviso', 'Escolha qual componente você quer equipar.<br><br> Skins :<br>- <b>preta</b><br>- <b>verde</b><br>- <b>marrom</b><br>- <b>vermelha</b><br>- <b>branca</b><br>- <b>amarela</b><br>- <b>azul</b><br>- <b>cinza</b><br>- <b>rosa</b><br>- <b>laranja</b>')
	else
	local ped = PlayerPedId()
	local NomeComp = string.lower(args[1])
	local arma = GetSelectedPedWeapon(ped)
	if NomeComp == 'preta' then
		if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO"))
			GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_SLIDE"))
			TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
		end
		elseif NomeComp == 'verde' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_02"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_02_SLIDE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		elseif NomeComp == 'marrom' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_03"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_03_SLIDE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		elseif NomeComp == 'vermelha' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_04"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_04_SLIDE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		elseif NomeComp == 'branca' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_05"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_05_SLIDE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		elseif NomeComp == 'amarela' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_06"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_06_SLIDE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		elseif NomeComp == 'azul' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_07"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_07_SLIDE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		elseif NomeComp == 'cinza' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_08"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_08_SLIDE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		elseif NomeComp == 'rosa' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_09"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_09_SLIDE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		elseif NomeComp == 'laranja' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ADVANCEDRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("CCOMPONENT_PISTOL_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SMG_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_10"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_PISTOL_MK2_CAMO_10_SLIDE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		elseif NomeComp == 'eua' then
			if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") then
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01"))
				GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"))
				TriggerEvent('Notify', 'sucesso', '<b>Skin</b> equipada.')
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ UPDATE ROUPAS ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("updateRoupas")
AddEventHandler("updateRoupas",function(custom)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if custom[1] == -1 then
			SetPedComponentVariation(ped,1,0,0,2)
		else
			SetPedComponentVariation(ped,1,custom[1],custom[2],2)
		end

		if custom[3] == -1 then
			SetPedComponentVariation(ped,5,0,0,2)
		else
			SetPedComponentVariation(ped,5,custom[3],custom[4],2)
		end

		if custom[5] == -1 then
			SetPedComponentVariation(ped,7,0,0,2)
		else
			SetPedComponentVariation(ped,7,custom[5],custom[6],2)
		end

		if custom[7] == -1 then
			SetPedComponentVariation(ped,3,15,0,2)
		else
			SetPedComponentVariation(ped,3,custom[7],custom[8],2)
		end

		if custom[9] == -1 then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				SetPedComponentVariation(ped,4,18,0,2)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				SetPedComponentVariation(ped,4,15,0,2)
			end
		else
			SetPedComponentVariation(ped,4,custom[9],custom[10],2)
		end

		if custom[11] == -1 then
			SetPedComponentVariation(ped,8,15,0,2)
		else
			SetPedComponentVariation(ped,8,custom[11],custom[12],2)
		end

		if custom[13] == -1 then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				SetPedComponentVariation(ped,6,34,0,2)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				SetPedComponentVariation(ped,6,35,0,2)
			end
		else
			SetPedComponentVariation(ped,6,custom[13],custom[14],2)
		end

		if custom[15] == -1 then
			SetPedComponentVariation(ped,11,15,0,2)
		else
			SetPedComponentVariation(ped,11,custom[15],custom[16],2)
		end

		if custom[17] == -1 then
			SetPedComponentVariation(ped,9,0,0,2)
		else
			SetPedComponentVariation(ped,9,custom[17],custom[18],2)
		end

		if custom[19] == -1 then
			SetPedComponentVariation(ped,10,0,0,2)
		else
			SetPedComponentVariation(ped,10,custom[19],custom[20],2)
		end

		if custom[21] == -1 then
			ClearPedProp(ped,0)
		else
			SetPedPropIndex(ped,0,custom[21],custom[22],2)
		end

		if custom[23] == -1 then
			ClearPedProp(ped,1)
		else
			SetPedPropIndex(ped,1,custom[23],custom[24],2)
		end

		if custom[25] == -1 then
			ClearPedProp(ped,2)
		else
			SetPedPropIndex(ped,2,custom[25],custom[26],2)
		end

		if custom[27] == -1 then
			ClearPedProp(ped,6)
		else
			SetPedPropIndex(ped,6,custom[27],custom[28],2)
		end

		if custom[29] == -1 then
			ClearPedProp(ped,7)
		else
			SetPedPropIndex(ped,7,custom[29],custom[30],2)
		end
	end
end)


RegisterNetEvent("rbgcar")
AddEventHandler("rbgcar",function()
    rgbColor()
end)

local r = 255
local g = 0
local b = 0
local rgbStatus = 1

function rgbColor()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
     if IsEntityAVehicle(vehicle) then      
        if rgbStatus == 1 then 
            g = g + 1  
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)        
            if g == 255 then 
                rgbStatus = 2
            end 
        elseif rgbStatus == 2 then 
            r = r - 1     
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)        
            if r < 130 then 
                b = b + 1
            end 
    
            if r == 0 then 
                rgbStatus = 3
            end 
        elseif rgbStatus == 3 then 
            b = b + 1  
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)        
            if b == 255 then 
                rgbStatus = 4
            end
        elseif rgbStatus == 4 then 
            g = g - 1    
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)        
            if g < 130 then 
                r = r + 1
            end
            if g == 0 then 
                rgbStatus = 5
            end
        elseif rgbStatus == 5 then 
            r = r + 1
            
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)  
            if r == 255 then 
                rgbStatus = 6
            end
        elseif rgbStatus == 6 then 
            b = b - 1
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)  

            if b < 130 then 
                g = g + 1
            end 

            if b == 0 then 
                rgbStatus = 1
            end
        end  
       
        Citizen.Wait(4)
        rgbColor()
    end    
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DRAWTEXT3DS ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
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

RegisterCommand('limpar', function(source, args, rawCommand)
    local ped = PlayerPedId()
    if not IsEntityPlayingAnim(ped, "anim@heists@ornate_bank@grab_cash_heels","grab", 3)  then
        if not IsEntityPlayingAnim(ped, "oddjobs@shop_robbery@rob_till","loop", 3) then
            if not IsEntityPlayingAnim(ped, "amb@world_human_sunbathe@female@back@idle_a","idle_a", 3) then
                TriggerServerEvent('chuveiro')
				TriggerEvent("Notify","negado","Você está limpo.")
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR MOTOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('repararmotorr')
AddEventHandler('repararmotorr',function()
	local vehicle = vRP.getNearestVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("trymotor",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncmotorr')
AddEventHandler('syncmotor',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleEngineHealth(v,1000.0)
			end
		end
	end
end)


RegisterNetEvent('repararpneuss')
AddEventHandler('repararpneuss',function(vehicle)
    TriggerServerEvent("trypneus",VehToNet(vehicle))
end)

RegisterNetEvent('syncpneus')
AddEventHandler('syncpneus',function(index)
    if NetworkDoesNetworkIdExist(index) then
        local v = NetToEnt(index)
        if DoesEntityExist(v) then
            for i = 0,5 do
                SetVehicleTyreFixed(v,i)
            end
        end
    end
end)

---novos

RegisterNetEvent('reparar')
AddEventHandler('reparar',function()
	local veh = vRP.getNearestVehicle(5)
	if veh then
		if NetworkHasControlOfEntity(veh) then
			SetVehicleFixed(veh)
			SetVehicleOnGroundProperly(veh)
			SetVehicleDirtLevel(veh,0.0)
			SetVehicleUndriveable(veh,false)
		end
	end
end)

RegisterNetEvent('repararmotor')
AddEventHandler('repararmotor',function()
	local veh = vRP.getNearestVehicle(5)
	if veh then
		if NetworkHasControlOfEntity(veh) then
			SetVehicleEngineHealth(veh,1000.0)
		end
	end
end)

RegisterNetEvent('repararpneus')
AddEventHandler('repararpneus',function()
	local veh = vRP.getNearestVehicle(5)
	if veh then
		if NetworkHasControlOfEntity(veh) then
			for i = 0,5 do
				SetVehicleTyreFixed(veh,i)
			end
		end
	end
end)

RegisterCommand('+indicatorlights',function(source,args)
    local ped = PlayerPedId()
   -- local isIn = IsPedInAnyVehicle(ped,false)
	local vehicle = vRP.getNearestVehicle(5)
    if vehicle then
    -- local vehicle = GetVehiclePedIsIn(ped, false)
		if NetworkHasControlOfEntity(vehicle) then
			local lights = GetVehicleIndicatorLights(vehicle)
			if args[1] == 'up' then
				SetVehicleIndicatorLights(vehicle,0,true)
				SetVehicleIndicatorLights(vehicle,1,true)
			elseif args[1] == 'left' then
				SetVehicleIndicatorLights(vehicle,1,true)
				SetVehicleIndicatorLights(vehicle,0,false)
			elseif args[1] == 'right' then
				SetVehicleIndicatorLights(vehicle,0,true)
				SetVehicleIndicatorLights(vehicle,1,false)
			elseif args[1] == 'off' and lights >= 0 then
				SetVehicleIndicatorLights(vehicle,0,false)
				SetVehicleIndicatorLights(vehicle,1,false)
			end
		end
    end
end)

RegisterKeyMapping("+indicatorlights up","Pisca-Alerta","keyboard","UP")
RegisterKeyMapping("+indicatorlights off","Desligar Luzes","keyboard","DOWN")
RegisterKeyMapping("+indicatorlights left","Seta Esquerda","keyboard","LEFT")
RegisterKeyMapping("+indicatorlights right","Seta Direita","keyboard","RIGHT")

----------------------------------------------------------------------------------------------------------------------------------------
-- /NPC CONTROL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
    SetVehicleDensityMultiplierThisFrame(0.2) --Seleciona densidade do trafico
    SetPedDensityMultiplierThisFrame(0.1) --seleciona a densidade de Npc
    SetRandomVehicleDensityMultiplierThisFrame(1.0) --seleciona a densidade de viaturas estacionadas a andar etc
    SetParkedVehicleDensityMultiplierThisFrame(1.0) --seleciona a densidade de viaturas estacionadas
    SetScenarioPedDensityMultiplierThisFrame(0.2, 0.2) --seleciona a densidade de Npc a andar pela cidade
    SetGarbageTrucks(true) --Desactiva os Camioes do Lixo de dar Spawn Aleatoriamente
    SetRandomBoats(false) --Desactiva os Barcos de dar Spawn na agua
    SetCreateRandomCops(false) --Desactiva a Policia a andar pela cidade
    SetCreateRandomCopsNotOnScenarios(false) --Para o Spanw Aleatorio de Policias Fora do Cenario
    SetCreateRandomCopsOnScenarios(false) --Para o Spanw Aleatorio de Policias no Cenario
    DisablePlayerVehicleRewards(PlayerId()) --Nao mexer --> Impossibilita que os players possam ganhar armas nas viaturas da policia e ems
    RemoveAllPickupsOfType(0xDF711959) --Carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) --Pistol
    RemoveAllPickupsOfType(0xA9355DCD) --Pumpshotgun
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
    RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
    --HideHudComponentThisFrame(14)-- Remover Mira
    RemoveMultiplayerHudCash(0x968F270E39141ECA) -- Remove o Dinheiro Original do Gta
    RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0) --Remove o Dinheiro Original do Gta Que esta no Banco
    for i = 1, 15 do
    EnableDispatchService(i, false)-- Disabel Dispatch
      end
    end

end)

