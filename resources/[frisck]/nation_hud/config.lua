-- coloque no seu arquivo server.cfg --> setr game_enableFlyThroughWindscreen true

config = {

    getHealth = function(ped) -- calculo da vida
        return ((GetEntityHealth(ped) - 100) * 100 / 220) / 100 -- para vida de 100 até 400
    end,

    getArmour = function(ped) -- calculo do colete
        return GetPedArmour(ped) / 100
    end,

    getSpeed = function(veh) -- calculo da velocidade do velocimetro
        return math.floor(GetEntitySpeed(veh) * 3.6) -- km/h
    end,

    radarOnlyInVehicle = true, -- mostrar minimapa apenas dentro do veiculo
    radarOnSeatbelt = false, -- mostrar minimapa apenas com o cinto 

    keys = { -- teclas
        seatbelt = "G", -- cinto
        leftIndicator = 'LEFT', -- seta esquerda
        rightIndicator = 'RIGHT', -- seta direita
        bothIndicators = 'DOWN' -- pisca
    },

    tokovoip = true, -- se usa tokovoip coloca true

    voiceModes = { -- é o nome da classe no css (se alterar aqui, tem que alterar o nome da classe no style.css tbm)
        [1] = "whisper",
        [2] = "default",
        [3] = "shout"
    },

    defaultVoiceMode = 2, -- modo do voip que vai ser iniciado com a hud

    stress = false, -- true se quiser trocar a stamina pelo stress

    esx_status = false, -- ESX status


}

local keys = config.keys

function checkVehicleLights()
    local fkeys = {
        leftIndicator = 1,
        rightIndicator = 0,
        bothIndicators = 3
    }
    for k,v in pairs(fkeys) do
        local f = function()
            if inVehicle and DoesEntityExist(vehicle) then
                activateVehicleLights(vehicle, v)
            end
        end
        RegisterCommand('nation_hud:'..k,f)
        RegisterKeyMapping('nation_hud:'..k, "", "keyboard", keys[k])
    end
end

local toggleSeatbelt = function()
    if inVehicle and vehicleHudOn and hasSeatbelt then
        seatbeltOn = not seatbeltOn
        updateSeatbelt(seatbeltOn, true)
        if config.radarOnSeatbelt then checkRadar(seatbeltOn) end
        SetPedConfigFlag(ped, 32, not seatbeltOn)
    end
end

RegisterCommand('nation_hud:seatbelt',toggleSeatbelt)
RegisterKeyMapping("nation_hud:seatbelt", "", "keyboard", keys.seatbelt or "G")






function checkRadar(bool) -- funcao que verifica se o minimapa deve ser exibido / ocultado
    if not config.radarOnlyInVehicle then DisplayRadar(true) return end
    local vehicle = GetVehiclePedIsIn(ped, false)
    local hasSeatbelt = doesVehicleHasSeatbelt(vehicle)
    if config.radarOnSeatbelt then
        if bool and (seatbeltOn or not hasSeatbelt) and IsPedInAnyVehicle(ped,false) then
            DisplayRadar(true)
        else
            DisplayRadar(false)
        end
        return
    end
    DisplayRadar(bool)
end

function getTime() -- retorna o tempo em formato (horas:minutos)
    local hours = GetClockHours()
    local minutes = GetClockMinutes()
    if hours <= 9 then
        hours = "0"..hours
    end
    if minutes <= 9 then
        minutes = "0"..minutes
    end
    return hours..":"..minutes
end



--- handler do comando da hud ---
hud = true
local toggleHud = function()
    hud = not hud
    TriggerEvent('nation_hud:updateHud', hud)
end
-------------------------------------

function hideComponents() -- esconder elementos padroes do GTA
    local components = {
        1,2,3,4,6,7,8,9,13,17,20 
     }
     for _, component in ipairs(components) do
         HideHudComponentThisFrame(component)
     end
end


local checkSeatbelt = function(ped,veh, beltSpeed) -- joga o player pra fora do veiculo ao colidir e extiver sem cinto (por padrão nao é utilizado)
	local speed = GetEntitySpeed(veh) * 3.6
    if seatbeltOn then return speed end
	if speed ~= beltSpeed then
		if (beltSpeed - speed) >= 30 and not seatbeltOn then
            local entCoords = GetOffsetFromEntityInWorldCoords(veh,0.0,7.0,0.0)
            SetEntityHealth(ped,GetEntityHealth(ped)-50)
            TaskLeaveVehicle(ped,veh,4160)
            SetPedToRagdoll(ped,5000,5000,0,0,0,0)
		end
		beltSpeed = speed
	end
    return beltSpeed
end


local checkComponents = function()
    local tokovoip = config.tokovoip
    local player = PlayerId()
    local currentTalking = false
    while true do
		Wait(1)
        if not tokovoip then
            local talking = NetworkIsPlayerTalking(player)
            if currentTalking ~= talking then
                currentTalking = talking
                TriggerEvent("nation_hud:updateTalking", currentTalking)
            end
        end
        if inVehicle and hasSeatbelt then
            --beltSpeed = checkSeatbelt(ped, vehicle, beltSpeed) -- descomentar caso nao use o setr game_enableFlyThroughWindscreen true no cfg
            if seatbeltOn then
                DisableControlAction(1,75,true) -- não deixa sair do veiculo enquanto estiver de cinto
            end
        end
        hideComponents() -- desbilitar componentes do GTA V
	end
end

local startUpdateVehicleSpeed = function() -- thread utilizada para atualizar a velocidade do veiculo no velocimetro
    local getSpeed = config.getSpeed
    local currentSpeed = getSpeed(vehicle)
    local currentRPM = GetVehicleCurrentRpm(vehicle) * 100
    updateVehicleSpeed(currentSpeed)
    while vehicleHudOn and inVehicle do
        local speed = getSpeed(vehicle)
        --[[ local rpm = GetVehicleCurrentRpm(vehicle) * 100
        if currentSpeed ~= speed or currentRPM ~= rpm then
            currentSpeed = speed
            currentRPM = rpm
            updateVehicleSpeed(currentSpeed, currentRPM)
        end ]]
        if currentSpeed ~= speed then
            currentSpeed = speed
            updateVehicleSpeed(currentSpeed, currentSpeed)
        end
        Wait(250)
    end
end



function doesVehicleHasSeatbelt(veh)
    local vehClass = GetVehicleClass(veh or vehicle)
    return (vehClass >= 0 and vehClass <= 7) or (vehClass >= 9 and vehClass <= 12) or (vehClass >= 17 and vehClass <= 20)
end


startVehicle = function() -- executada toda vez que entra em um veiculo
    vehicle = GetVehiclePedIsIn(ped, false)
    beltSpeed = 0
    updateSeatbelt(seatbeltOn, false)
    if not DoesEntityExist(vehicle) then return end
    CreateThread(startUpdateVehicleSpeed) 
    hasSeatbelt = doesVehicleHasSeatbelt(vehicle)
    SetFlyThroughWindscreenParams(25.0, 2.0, 15.0, 15.0)
    SetPedConfigFlag(ped, 32, hasSeatbelt)
end


function statusVehicle(bool)
    seatbeltOn = false
    if bool then
        vehicleHudOn = true
        startVehicle()
        checkRadar(true) 
        TriggerEvent("nation_hud:updateVehicleHud", true)
    else
        inVehicle = false
        vehicleHudOn = false
        checkRadar(false) 
        TriggerEvent("nation_hud:updateVehicleHud", false)
        updateIndicatorLights(0)
    end
end

checkPlayerLevels = function()
    Wait(1000)
    local getHealth = config.getHealth
    local getArmour = config.getArmour
    ped = PlayerPedId()
    player = PlayerId()
    local currentHealth = getHealth(ped)
    local currentShield = getArmour(ped)
    local currentStamina = (100 - GetPlayerSprintStaminaRemaining(player)) / 100
    local currentFuel = 0.0
    local currentEngineHealth = 0.0
    local vehicleEngineOn = false
    local vehicleLocked = false
    local vehicleLightsOn = false
    local vehicleIndicatorLights = 0
    local currentVehicle = GetVehiclePedIsIn(ped)
    local x,y,z = table.unpack(GetEntityCoords(ped))
    local currentStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
    local currentTime = getTime()
    setHealth(currentHealth)
    setArmour(currentShield)
    TriggerEvent("nation_hud:setVoipMode", config.defaultVoiceMode)
    TriggerEvent("nation_hud:setHunger", 1.0)
    TriggerEvent("nation_hud:setThirst", 1.0)
    TriggerEvent("nation_hud:setStress", 0)
    setStamina(currentStamina)
    updateStreet(currentStreet)
    updateTime(currentTime)
    vehicleHudOn = false
    checkRadar(false)
    checkVehicleLights()
    while true do
        ped = PlayerPedId()
        x,y,z = table.unpack(GetEntityCoords(ped))
        local time = getTime()
        local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
        local health = getHealth(ped)
        local shield = getArmour(ped)
        local stamina = (100 - GetPlayerSprintStaminaRemaining(player)) / 100
        if currentHealth ~= health then
            currentHealth = health
            setHealth(currentHealth)
        end
        if currentShield ~= shield then
            currentShield = shield
            setArmour(currentShield)
        end
        if currentStamina ~= stamina and not config.stress then
            currentStamina = stamina
            setStamina(currentStamina)
        end
        if currentStreet ~= street then
            currentStreet = street
            updateStreet(currentStreet)
        end
        if currentTime ~= time then
            currentTime = time
            updateTime(currentTime)
        end
        inVehicle = IsPedInAnyVehicle(ped,false)

        if inVehicle and not vehicleHudOn then statusVehicle(true)
        elseif (not inVehicle and vehicleHudOn) or (inVehicle and GetVehiclePedIsIn(ped) ~= vehicle) then statusVehicle(false) end

        if vehicleHudOn then
            local veh = vehicle
            if veh and DoesEntityExist(veh) then
                local fuel = GetVehicleFuelLevel(veh) / 100
                local engineHealth = GetVehicleEngineHealth(veh) / 1000
                local lock = GetVehicleDoorLockStatus(veh) >= 2
                local engineOn = GetIsVehicleEngineRunning(veh)
                local _, lightsOn, highbeams = GetVehicleLightsState(veh)
                local indicadorLights = GetVehicleIndicatorLights(veh)
                if highbeams and highbeams > 0 then lightsOn = true end
                if currentFuel ~= fuel then
                    currentFuel = fuel
                    updateFuel(currentFuel)
                end
                if currentEngineHealth ~= engineHealth then
                    currentEngineHealth = engineHealth
                    updateEngineHealth(currentEngineHealth)
                end
                if vehicleLocked ~= lock then
                    vehicleLocked = lock
                    updateLockStatus(vehicleLocked)
                end
                if vehicleEngineOn ~= engineOn then
                    vehicleEngineOn = engineOn
                    updateEngineStatus(vehicleEngineOn)
                end
                if vehicleLightsOn ~= lightsOn then
                    vehicleLightsOn = lightsOn
                    updateLights(vehicleLightsOn)
                end
                if vehicleIndicatorLights ~= indicadorLights then
                    vehicleIndicatorLights = indicadorLights
                    updateIndicatorLights(vehicleIndicatorLights)
                end
            end
        end
        if IsPauseMenuActive() then 
			if not isPauseMenu then
				isPauseMenu = not isPauseMenu
				TriggerEvent('nation_hud:updateHud', false)
			end
		else
			if isPauseMenu then
				isPauseMenu = not isPauseMenu
				TriggerEvent('nation_hud:updateHud', true)
			end
		end
        Wait(500)
    end
end



StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE");
SetAudioFlag("PoliceScannerDisabled",true); 


RegisterCommand('hud', toggleHud) -- comando de mostrar / esconder a hud


local progress = function(time) -- progressbar
    TriggerEvent("nation_hud:progressbar", time)
end

RegisterNetEvent('progress') AddEventHandler('progress',progress)
RegisterNetEvent('Progress') AddEventHandler('Progress',progress) -- creative v3


--[[ RegisterCommand('progress',function(source,args)
    progress(args[1] or 5000)
end) ]]



local needsDamage = function()
    local hunger = 1
    local thirst = 1
    local stress = 0
    RegisterNetEvent('nation_hud:setHunger')
    AddEventHandler('nation_hud:setHunger',function(h)
        hunger = h
    end)
    RegisterNetEvent('nation_hud:setThirst')
    AddEventHandler('nation_hud:setThirst',function(t)
        thirst = t
    end)
    RegisterNetEvent('nation_hud:setStress')
    AddEventHandler('nation_hud:setStress',function(s)
        stress = s
    end)
    local applyDamage = function(damage, ped, health)
        SetFlash(0,0,500,1000,500)
        SetEntityHealth(ped,health+damage)
    end
    local checkDamage = function(value, ped, health)
        if not value then return end
        if value >= 0.1 and value <= 0.2 then
            applyDamage(-1, ped, health)
        elseif value <= 0.09 then
            applyDamage(-2, ped, health)
        end
    end
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if health > 101 then
            checkDamage(hunger, ped, health)
            checkDamage(thirst, ped, health)
        end
        if stress >= 0.8 then
            ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.15)
            if math.floor(math.random(3)) >= 3 and not IsPedInAnyVehicle(ped) then
                SetPedToRagdoll(ped,5000,5000,0,0,0,0)
                TriggerServerEvent("vrp_inventory:Cancel")
            end
        elseif stress >= 0.6 and stress <= 0.79 then
            ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.09)
            if math.floor(math.random(3)) >= 3 and not IsPedInAnyVehicle(ped) then
                SetPedToRagdoll(ped,4000,4000,0,0,0,0)
                TriggerServerEvent("vrp_inventory:Cancel")
            end
        end
        Citizen.Wait(5000)
    end
end

CreateThread(checkComponents) -- importante
CreateThread(needsDamage) -- tomar dano de fome / sede

--------------- ESX STATUS --------------

local esx_status = function(status)
    local hunger = 1
    local thirst = 1
    for k,v in ipairs(status) do
        if v.name == "hunger" then hunger = v.percent end
        if v.name == "thirst" then thirst = v.percent end
    end
    TriggerEvent("nation_hud:setHunger", hunger / 100)
    TriggerEvent("nation_hud:setThirst", thirst / 100)
end

if config.esx_status then
    RegisterNetEvent("esx_status:onTick") AddEventHandler("esx_status:onTick", esx_status)
end

