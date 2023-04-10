local Tunnel               = module("vrp", "lib/Tunnel")
local Proxy                = module("vrp", "lib/Proxy")
local cooldown             = false
vRP                        = Proxy.getInterface("vRP")
yRPS                       = Tunnel.getInterface(GetCurrentResourceName())
yRPSCL                     = {}
opened_group               = nil
groupData                  = {}
storeInfo                  = {}
delay                      = false
Tunnel.bindInterface(GetCurrentResourceName(), yRPSCL)
Proxy.addInterface(GetCurrentResourceName(), yRPSCL)

function yRPSCL.getCoolDown()
    return cooldown
end

function yRPSCL.init(data)
    if not cooldown then
        cooldown = true 
            groupData = data
            SendNUIMessage({
                show = true,
                group_stats = groupData
            })
            SetNuiFocus(true, true)
            TransitionToBlurred(300)
        SetTimeout(cfg.cooldown, function() cooldown = false end)
    else
        TriggerEvent("Notify", "negado","Espere alguns segundos para abrir o Gerenciador de Membros novamente.") 
    end
end

function yRPSCL.update(data)
    groupData = data
    SendNUIMessage({
        update = true,
        group_stats = groupData
    })
end


function GetCoordsInFrontOfPed(ped, dist)
    local forward, _, _, position = GetEntityMatrix(ped)
    return (forward * dist) + position
end


leaveGarageSet = function(id,tipo,custom)
    selecting = false
    deleteCam()
    DeleteVehicle(vehicle)
    yRPS.buy_store(id,tipo,custom)
end

-- RegisterKeyMapping('+groupcontrol', 'Abrir gerenciador de membros', 'keyboard', cfg.key)

RegisterNUICallback("promote", function(data,cb) 
    if yRPS.promote(data.dados.id,data.newgroup) then
        for k,v in pairs(groupData.members_list) do
            if v.id == data.dados.id then
                groupData.members_list[k].group = data.newgroup
            end
        end
        cb(groupData.members_list)
    end
end)

RegisterNUICallback("demote", function(data,cb)
    yRPS.demote(data.id,groupData.members_list[1].group)
    for k,v in pairs(groupData.members_list) do
        if v.id == data.id then
            groupData.members_list[k] = nil
        end
    end
    cb(groupData.members_list)
end)

RegisterNUICallback("comprarlevel", function(data,cb)
    print('oi')
end)

RegisterNUICallback("invite", function(data,cb) 
    if not delay then 
        delay = true 
        SetTimeout(3000, function() delay = false end)
        yRPS.invite(data.id,data.group)
    else 
        TriggerEvent("Notify", "negado","Espere alguns segundos para convidar alguém novamente.") 
        cb(false)
    end
end)

RegisterNUICallback("buy", function(data,cb) 
    if data.tipo == 'set_garage' then 
        if storeInfo[data.productType].dependentes[data.productId].preco < groupData.money then 
            TriggerEventInternal("groupcontrol:close", 0, 0)
            setGarage(data.productId,data.productType)
        else 
            TriggerEvent("Notify","negado","Dinheiro insuficiente!")
            cb(false)
        end

    elseif data.tipo == "set_public_garage" then 
        if storeInfo[data.productType].dependentes[data.productId].preco < groupData.money then 
            TriggerEventInternal("groupcontrol:close", 0, 0)
            setGarage(data.productId,data.productType)
        else 
            TriggerEvent("Notify","negado","Dinheiro insuficiente!")
            cb(false)
        end
    else 
    cb(yRPS.buy_store(data.productId,data.productType))
    end 
end)

RegisterNetEvent("close")
AddEventHandler("close",function() 
    TransitionFromBlurred(300)
    opened_group = nil
    SetNuiFocus(false, false)
end)

RegisterNUICallback("close", function(data,cb)
    yRPS.close()
    TransitionFromBlurred(300)
    opened_group = nil
    SetNuiFocus(false, false)
end)


RegisterNUICallback("loadIpls", function()
    CreateThread(function() 
        while not yRPS do Wait(1) end
        local data = yRPS.get_ipl_list()
        for i = 1,#data do 
            RequestIpl(data[i])
        end
    end)
end)

RegisterNetEvent("groupcontrol:requestIpl")
AddEventHandler("groupcontrol:requestIpl",function(ipl) 
    RequestIpl(ipl)
end)


