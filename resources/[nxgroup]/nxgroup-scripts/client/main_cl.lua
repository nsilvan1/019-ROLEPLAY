local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface("vRP")

Tunnel.bindInterface("nxgroup-scripts", func)
vSERVER = Tunnel.getInterface("nxgroup-scripts")

-- RegisterNUICallback('dev_tools',function()
--    func.Punicao()
-- end)

--NEXUS_NOTIFY

function Alert(title, message, time, type)
	title = type
	SendNUIMessage({
		action = 'open',
		title = title,
		type = type,
		message = message,
		time = time,
	})
end

RegisterNetEvent("Notify")
AddEventHandler("Notify",function(title,message,time)
    if time == nil then
        time = 5000
    end
    Alert(title, message, time, title)
end)


RegisterNetEvent('nyo_notify')
AddEventHandler('nyo_notify', function(color, title, message, time)
	if time == nil then
		time = 5000
	end
	type = title
	Alert(title, message, time, type)
end)

-- VRP_LOGHACKS

Citizen.CreateThread(function()
	while true do
		local p = 1000
        p = 5
		if IsControlJustPressed(0,178) then -- DELETE
			vSERVER.buttonSetaBaixo()
		end
        if IsControlJustPressed(0,348) then -- SCROLL2
			vSERVER.buttonfUm()
		end
        Wait(p)
	end
end)

-- VRP_SOUNDS

RegisterNetEvent('vrp_sound:source')
AddEventHandler('vrp_sound:source',function(sound,volume)
	SendNUIMessage({ transactionType = 'playSound', transactionFile = sound, transactionVolume = volume })
end)

RegisterNetEvent('vrp_sound:distance')
AddEventHandler('vrp_sound:distance',function(playerid,maxdistance,sound,volume)
	local lCoords = GetEntityCoords(ped)
	local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerid)))
	local distance  = Vdist(lCoords.x,lCoords.y,lCoords.z,eCoords.x,eCoords.y,eCoords.z)
	if distance <= maxdistance then
		SendNUIMessage({ transactionType = 'playSound', transactionFile = sound, transactionVolume = volume })
	end
end)

RegisterNetEvent('vrp_sound:fixed')
AddEventHandler('vrp_sound:fixed',function(playerid,x2,y2,z2,maxdistance,sound,volume)
	local ped = ped
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local distance = GetDistanceBetweenCoords(x2,y2,z2,x,y,z,true)
	if distance <= maxdistance then
		SendNUIMessage({ transactionType = 'playSound', transactionFile = sound, transactionVolume = volume })
	end
end) 

local Metro = PolyZone:Create({
    vector2(218.98,-1602.22),
    vector2(178.22,-1649.18),
    vector2(216.49,-1687.13),
    vector2(255.27,-1632.21),
  
}, {
    name="Metro",
    minZ=28.20,
    maxZ=60.0,
    debugGrid=false,
    gridDivisions=25
})


local Prisao = PolyZone:Create({
    vector2(1821.43,2472.89),
    vector2(1542.96,2466.68),
    vector2(1647.51,2755.05),
    vector2(1846.35,2702.29),
  
}, {
    name="Prisao",
    minZ=44.20,
    maxZ=70.0,
    debugGrid=false,
    gridDivisions=25
})

local Concessionaria = PolyZone:Create({
    vector2(-71.23,-1122.02),
    vector2(-53.18,-1070.24),
    vector2(-1.61,-1081.73),
    vector2(-15.09,-1120.14),
  
}, {
    name="Concessionaria",
    minZ=24.20,
    maxZ=40.0,
    debugGrid=false,
    gridDivisions=25
})

local hospital = PolyZone:Create({
    vector2(-757.73,369.04),
    vector2(-614.32,356.96),
    vector2(-622.55,262.52),
    vector2(-752.77,271.97),
  
}, {
    name="hospital",
    minZ=70.0,
    maxZ=150.0,
    debugGrid=false,
    gridDivisions=25
})

local hospitalgaragens = PolyZone:Create({
    vector2(-736.76,429.38),
    vector2(-627.95,419.69),
    vector2(-639.66,349.29),
    vector2(-736.38,377.19),
  
}, {
    name="hospitalgaragens",
    minZ=70.0,
    maxZ=76.0,
    debugGrid=false,
    gridDivisions=25
})

local Praca = PolyZone:Create({
    vector2(111.01, -1023.23),
    vector2(200.48, -1057.78),
    vector2(267.73, -871.75),
    vector2(178.92,  -839.59),

}, {
    name="Praca",
    minZ=22.25,
    maxZ=70.0,
    debugGrid=false,
    gridDivisions=25
})

local LifeInvader = PolyZone:Create({
    vector2(-1044.14,-211.49),
    vector2(-1104.3,-243.04),
    vector2(-1132.48,-267.19),
    vector2(-1132.57,-274.56),
    vector2(-1128.27,-280.24),
    vector2(-1094.84,-272.24),
    vector2(-1080.5,-266.36),
    vector2(-1015.26,-230.76),
    vector2(-1017.36,-219.83),
    vector2(-1044.14,-211.49),

}, {
    name="LifeInvader",
    minZ=32.25,
    maxZ=59.5,
    debugGrid=false,
    gridDivisions=25
})

local entra = PolyZone:Create({
    vector2(-212.19,-1885.41),
    vector2(-280.24,-1839.11),
    vector2(-340.13,-1946.96),
    vector2(-272.1,-2012.62),

}, {
    name="entra",
    minZ=22.25,
    maxZ=70.0,
    debugGrid=false,
    gridDivisions=25
})

-- local hospitalnovo = PolyZone:Create({
-- 	vector2(1241.74,-1456.16),
--     vector2(1101.47,-1455.9),
-- 	vector2(1096.69,-1455.29),
--     vector2(1098.16,-1515.33),
--     vector2(1112.26,-1514.92),
--     vector2(1110.65,-1523.2),
--     vector2(1133.27,-1523.14),
--     vector2(1145.27,-1526.19),
--     vector2(1154.53,-1532.36),
--     vector2(1153.89,-1581.03), 
--     vector2(1153.65,-1593.58),
--     vector2(1144.02,-1598.04),
--     vector2(1144.28,-1583.72),
--     vector2(1131.77,-1585.89),
--     vector2(1131.47,-1598.97),
--     vector2(1116.61,-1598.28),
 
-- 	vector2(1120.45,-1630.41),
--     vector2(1149.55,-1630.7),
-- 	vector2(1215.47, -1539.4),

-- }, {
--     name="hospitalnovo",
--     minZ=22.25,
--     maxZ=80.0,
--     debugGrid=false,
--     gridDivisions=25
-- })

local hospitalnovo = PolyZone:Create({
    vector2(1249.89,-1502.37),
	vector2(1245.97,-1454.47),
    vector2(1096.64,-1454.71),
	vector2(1096.18, -1533.0),
	vector2(1120.45,-1630.41),
    vector2(1149.55,-1630.7),
	vector2(1220.42,-1540.64),

}, {
    name="hospitalnovo",
    minZ=22.25,
    maxZ=80.0,
    debugGrid=false,
    gridDivisions=25
})

-- local hospitalnovode = PolyZone:Create({
--     vector2(1147.32,-1529.09),  
--     vector2(1153.5,-1532.81), 
--     vector2(1151.9,-1595.14),
--     vector2(1144.25,-1583.51), 
--     vector2(1131.87,-1585.77), 
--     vector2(1124.74,-1598.15),  
--     vector2(1113.75,-1532.7),
--     vector2(1097.93,-1527.56),
-- 	vector2(1098.02,-1516.82),
--     vector2(1109.49,-1516.92),
--     vector2(1110.65,-1523.21),
--     vector2(1133.45,-1525.22), 

-- }, {
--     name="hospitalnovode",
--     minZ=22.25,
--     maxZ=40.0,
--     debugGrid=false,
--     gridDivisions=100
-- })


local Safezone = false
local lastSafeZone = false

-- CreateThread(function()
-- 	local VEHS                       = {}
-- 	local PlayerPedId                = PlayerPedId
-- 	local parsedVehicles             = 0
-- 	local GetVehiclePedIsIn          = GetVehiclePedIsIn
-- 	local IsVehicleSeatFree          = IsVehicleSeatFree
-- 	local SetEntityNoCollisionEntity = SetEntityNoCollisionEntity
-- 	while true do
-- 		local ply    = PlayerPedId()
-- 		local plyVeh = GetVehiclePedIsIn(ply)
-- 		local v      = GetGamePool('CVehicle')
-- 		for i = 1, #v do
-- 			local result = (plyVeh ~= 0 or IsVehicleSeatFree(v[i], -1))
-- 			if VEHS[v[i]] ~= result then
-- 				VEHS[v[i]]     = result
-- 				parsedVehicles += 1
-- 				SetEntityNoCollisionEntity(ply, v[i], result)
-- 				SetEntityNoCollisionEntity(v[i], ply, result)
-- 			end
-- 		end
-- 		if parsedVehicles > 250 then
-- 			VEHS           = {}
-- 			parsedVehicles = 0
-- 		end
-- 		Wait(1000)
-- 	end
-- end)

-- CreateThread(function()
--     local VEHS                       = {}
--     local parsedVehicles             = 0
--     while true do
--         local ply    = PlayerPedId()
--         local coords = GetEntityCoords(ply)
--         if Praca:isPointInside(coords) then
--             local plyVeh = GetVehiclePedIsIn(ply)
--             local v      = GetGamePool('CVehicle')
--             for i = 1, #v do
--                 local result = (plyVeh ~= 0 or IsVehicleSeatFree(v[i], -1))
--                 if VEHS[v[i]] ~= result then
--                     VEHS[v[i]]     = result
--                     parsedVehicles += 1
--                     SetEntityNoCollisionEntity(ply, v[i], result)
--                     SetEntityNoCollisionEntity(v[i], ply, result)
--                 end
--             end
--             if parsedVehicles > 250 then
--                 VEHS           = {}
--                 parsedVehicles = 0
--             end
--         end
--         Wait(1000)
--     end
-- end)
-------------------------------------
local VEHS = {}

Citizen.CreateThread(function()
	while true do
        Safezone = false
        local ot = 1000
        local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
	    local parsedVehicles             = 0
	    local GetVehiclePedIsIn          = GetVehiclePedIsIn
	    local IsVehicleSeatFree          = IsVehicleSeatFree
	    local SetEntityNoCollisionEntity = SetEntityNoCollisionEntity

        ot = 5
		-- if hospitalnovode:isPointInside(coords)  then  
        --     Safezone = true
        --     -- teste(1)
        --     hospidimecao(1)
        if hospital:isPointInside(coords) or entra:isPointInside(coords) or Prisao:isPointInside(coords) or Concessionaria:isPointInside(coords) or hospitalgaragens:isPointInside(coords) or Praca:isPointInside(coords) or hospitalnovo:isPointInside(coords) or LifeInvader:isPointInside(coords) then  
            Safezone = true
            -- teste(1)
        end

        if lastSafeZone ~= Safezone then
            TriggerServerEvent('saquear:safe', Safezone)
        end
        lastSafeZone = Safezone

        if Safezone then
            ClearPlayerWantedLevel(PlayerId())

            DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
            DisableControlAction(1, 45, true) -- disable reload
            DisableControlAction(2, 80, true) -- disable reload
            DisableControlAction(2, 140, true) -- disable reload
            DisableControlAction(2, 250, true) -- disable reload
            DisableControlAction(2, 263, true) -- disable reload
            DisableControlAction(2, 310, true) -- disable reload
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(1, 143, true)
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(0, 58, true) -- disable weapon
                    
            DisablePlayerFiring(ped, true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
            DisableControlAction(0, 106, true) -- Disable in-game mouse controls

            -- -- if ped ~= nil then
            --     SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
            -- -- end
            
            local plyVeh = GetVehiclePedIsIn(ped, false)
            if plyVeh == 0 then
                --if GetPedInVehicleSeat(plyVeh, -1) == ped then
                    local v      = GetGamePool('CVehicle')
                    for i = 1, #v do
                        local result = (v[i] ~= 0 or IsVehicleSeatFree(v[i], -1))
                        if #(coords - GetEntityCoords(v[i], false)) < 10 then
                            SetEntityNoCollisionEntity(ped, v[i], result)
                            SetEntityNoCollisionEntity(v[i], ped, result)
                        end
                    end                
                --end
            end
        end

        Citizen.Wait(ot)
	end
end)

local un = 0

function teste(n)
    if n > un then
     un = n
        Citizen.CreateThread(function()
            TriggerServerEvent('saquear:safe', true)
            while Safezone do
                Citizen.Wait(500)
            end
            TriggerServerEvent('saquear:safe', false)
            un = 0
        end)
    end
end

local hun = 0

function hospidimecao(hn)
    if hn > hun then
     hun = hn
        Citizen.CreateThread(function()
            TriggerServerEvent('hospital:d', true)
            while Safezone do
                Wait(50)
            end
            TriggerServerEvent('hospital:d', false)
            hun = 0
        end)
    end
end

---------------------------------------------
-- local morto = false
-- local hson = true
-- -- local weapons = clientCFG.weapon_hs

-- local weapon_hs = { -- ARMAS QUE VÃO MATAR COM UM TIRO NA CABEÇA (INDEPENDENTE DA DISTÂNCIA)
-- 	"WEAPON_NAVYREVOLVER",
-- 	"WEAPON_MILITARYRIFLE",
-- 	"WEAPON_HAZARDCAN",
-- 	"WEAPON_GADGETPISTOL",
-- 	"WEAPON_COMBATSHOTGUN",
-- 	"WEAPON_CERAMICPISTOL",			   
-- 	"GADGET_PARACHUTE",
-- 	"WEAPON_KNIFE",
-- 	"WEAPON_KNUCKLE",
-- 	"WEAPON_NIGHTSTICK",
-- 	"WEAPON_HAMMER",
-- 	"WEAPON_BAT",
-- 	"WEAPON_GOLFCLUB",
-- 	"WEAPON_CROWBAR",
-- 	"WEAPON_BOTTLE",
-- 	"WEAPON_DAGGER",
-- 	"WEAPON_HATCHET",
-- 	"WEAPON_MACHETE",
-- 	"WEAPON_FLASHLIGHT",
-- 	"WEAPON_SWITCHBLADE",
-- 	"WEAPON_POOLCUE",
-- 	"WEAPON_PIPEWRENCH",
-- 	"WEAPON_STONE_HATCHET",
-- 	"WEAPON_WRENCH",
-- 	"WEAPON_BATTLEAXE",
-- 	"WEAPON_AUTOSHOTGUN",
-- 	"WEAPON_GRENADE",
-- 	"WEAPON_STICKYBOMB",
-- 	"WEAPON_PROXMINE",
-- 	"WEAPON_BZGAS",
-- 	"WEAPON_SMOKEGRENADE",
-- 	"WEAPON_MOLOTOV",
-- 	"WEAPON_FIREEXTINGUISHER",
-- 	"WEAPON_PETROLCAN",
-- 	"WEAPON_CERAMICPISTOL",
-- 	"WEAPON_MILITARYRIFLE",
-- 	"WEAPON_GADGETPISTOL",
-- 	"WEAPON_NAVYREVOLVER",
-- 	"WEAPON_SNOWBALL",
-- 	"WEAPON_FLARE",
-- 	"WEAPON_BALL",
-- 	"WEAPON_PISTOL",
-- 	"WEAPON_PISTOL_MK2",
-- 	"WEAPON_COMBATPISTOL",
-- 	"WEAPON_APPISTOL",
-- 	"WEAPON_REVOLVER",
-- 	"WEAPON_REVOLVER_MK2",
-- 	"WEAPON_DOUBLEACTION",
-- 	"WEAPON_PISTOL50",
-- 	"WEAPON_SNSPISTOL",
-- 	"WEAPON_SNSPISTOL_MK2",
-- 	"WEAPON_HEAVYPISTOL",
-- 	"WEAPON_VINTAGEPISTOL",
-- 	"WEAPON_STUNGUN",
-- 	"WEAPON_FLAREGUN",
-- 	"WEAPON_MARKSMANPISTOL",
-- 	"WEAPON_RAYPISTOL",
-- 	"WEAPON_HEAVYSNIPER_MK2",
-- 	"WEAPON_MICROSMG",
-- 	"WEAPON_MINISMG",
-- 	"WEAPON_SMG",
-- 	"WEAPON_SMG_MK2",
-- 	"WEAPON_ASSAULTSMG",
-- 	"WEAPON_COMBATPDW",
-- 	"WEAPON_GUSENBERG",
-- 	"WEAPON_MACHINEPISTOL",
-- 	"WEAPON_MG",
-- 	"WEAPON_COMBATMG",
-- 	"WEAPON_COMBATMG_MK2",
-- 	"WEAPON_RAYCARBINE",
-- 	"WEAPON_ASSAULTRIFLE",
-- 	"WEAPON_ASSAULTRIFLE_MK2",
-- 	"WEAPON_CARBINERIFLE",
-- 	"WEAPON_CARBINERIFLE_MK2",
-- 	"WEAPON_ADVANCEDRIFLE",
-- 	"WEAPON_SPECIALCARBINE",
-- 	"WEAPON_SPECIALCARBINE_MK2",
-- 	"WEAPON_BULLPUPRIFLE",
-- 	"WEAPON_BULLPUPRIFLE_MK2",
-- 	"WEAPON_COMPACTRIFLE",
-- 	"WEAPON_PUMPSHOTGUN",
-- 	"WEAPON_PUMPSHOTGUN_MK2",
-- 	"WEAPON_SWEEPERSHOTGUN",
-- 	"WEAPON_SAWNOFFSHOTGUN",
-- 	"WEAPON_BULLPUPSHOTGUN",
-- 	"WEAPON_ASSAULTSHOTGUN",
-- 	"WEAPON_COMBATSHOTGUN",
-- 	"WEAPON_MUSKET",
-- 	"WEAPON_HEAVYSHOTGUN",
-- 	"WEAPON_DBSHOTGUN",
-- 	"WEAPON_SNIPERRIFLE",
-- 	"WEAPON_HEAVYSNIPER",
-- 	"WEAPON_HEAVYSNIPER_MK2",
-- 	"WEAPON_MARKSMANRIFLE",
-- 	"WEAPON_MARKSMANRIFLE_MK2",
-- 	"WEAPON_GRENADELAUNCHER",
-- 	"WEAPON_GRENADELAUNCHER_SMOKE",
-- 	"WEAPON_RPG",
-- 	"WEAPON_MINIGUN",
-- 	"WEAPON_FIREWORK",
-- 	"WEAPON_RAILGUN",
-- 	"WEAPON_HOMINGLAUNCHER",
-- 	"WEAPON_COMPACTLAUNCHER",
-- 	"WEAPON_RAYMINIGUN",
-- 	"WEAPON_HEAVYRIFLE",
-- 	"WEAPON_EMPLAUNCHER",
-- 	"WEAPON_FERTILIZERCAN",
-- 	"WEAPON_STUNGUN_MP",
-- 	"WEAPON_PIPEBOMB",
-- }

-- local weapons = weapon_hs
-- -- local arena = Tunnel.getInterface("nxgroup_arena")

-- local in_arena = false

-- RegisterNetEvent("mirtin_survival:updateArena")
-- AddEventHandler("mirtin_survival:updateArena", function(boolean)
--     in_arena = boolean
-- end)

-- local dimensaoOk = false

-- RegisterNetEvent("passandoDimensao")
-- AddEventHandler("passandoDimensao", function(dimensao)
--     dimensaoOk = true
-- end)


-- AddEventHandler("gameEventTriggered",function(name,args)
--     if name == "CEventNetworkEntityDamage" then
-- 		if IsPedAPlayer(args[1]) then 
-- 			 local a, b = GetPedLastDamageBone(args[1])
-- 			 if GetEntityHealth(args[1]) <= parseInt(101) then
-- 				morto = true
-- 			 end
            
--             TriggerServerEvent("pegandoDimensao", source)
--             if dimensaoOk then
--                 if b == 31086 and morto == false and hson then
--                     for k,v in pairs(weapons) do 
--                         local headshot = HasPedBeenDamagedByWeapon(args[1], GetHashKey(v), 2)
--                         if headshot then
--                             morto = true
--                         end
--                     end
--                 end
--                 if (morto and PlayerPedId() == args[2] and IsPedAPlayer(args[1])) then
--                     local index = NetworkGetPlayerIndexFromPed(args[1])
--                     local source = GetPlayerServerId(index)
--                     local weapon = args[7]
--                     TriggerServerEvent("core_killsystem:playerdeath",source,weapon,mortescript)
--                 end
--             end

-- 			morto = false
-- 		end
--     end
-- end)

RegisterNetEvent("gm:setiplsc", function(iplnames)
    for _, iplname in pairs(iplnames) do
        RequestIpl(iplname)
    end
end)

RegisterNetEvent("gm:setiplc", function(iplname,state)
    print(iplname)
    if state then
        print("colocou")
        RequestIpl(iplname)
    else
        print("tiro")
        RemoveIpl(iplname) 
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- AGACHAR
-----------------------------------------------------------------------------------------------------------------------------------------
-- local tempoagachar = 0
-- local agachar = false
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1000)
--         if tempoagachar > 0 then
--             tempoagachar = tempoagachar - 1
--         end
--     end
-- end)

-- Citizen.CreateThread(function()
--     while true do
--        sleep = 1000
--         local ped = PlayerPedId()
--         DisableControlAction(0,36,true)
--         if not IsPedInAnyVehicle(ped) then
--             sleep = 5
--             RequestAnimSet("move_ped_crouched")
--             RequestAnimSet("move_ped_crouched_strafing")
--             if IsDisabledControlJustPressed(0,36) then
--                 if agachar then
--                     ResetPedStrafeClipset(ped)
--                     ResetPedMovementClipset(ped,0.25)
--                     agachar = false
--                 else
--                     if tempoagachar == 0 then 
--                     SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
--                     SetPedMovementClipset(ped,"move_ped_crouched",0.25)
--                     agachar = true
--                     tempoagachar = 5
--                     end
--                 end
--             end
--         end
--         Citizen.Wait(sleep)
--     end
-- end)
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         local ped = PlayerPedId()
--         local player = PlayerId()
--         if agachar then 
--             DisablePlayerFiring(player, true)
--         end
--     end
-- end)