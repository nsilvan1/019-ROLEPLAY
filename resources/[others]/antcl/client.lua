local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local show3DText = false
local displaying = false
local showing = {}


RegisterNetEvent("yaga_antcl:show")
AddEventHandler("yaga_antcl:show", function()
    show3DText = true
end)

RegisterNetEvent("yaga_antcl")
AddEventHandler("yaga_antcl", function(id, crds, identifier, reason)   

    local pcoords = GetEntityCoords(PlayerPedId())
    if GetDistanceBetweenCoords(crds.x, crds.y, crds.z, pcoords.x, pcoords.y, pcoords.z, true) < 30.0 then
        table.insert(showing, {id = id, crds = crds, reason = reason, timeCl = GetGameTimer()})
    end
end)

Citizen.CreateThread(function()
    local sleepx = 5
    while true do
        if #showing > 0 and show3DText then
            sleepx = 5
            local timeNow = GetGameTimer()
            for k, v in pairs(showing) do
                DrawText3DSecond(v.crds.x, v.crds.y, v.crds.z+0.15, "Player deu CL")
                DrawText3D(v.crds.x, v.crds.y, v.crds.z, "ID: "..v.id.." \nMotivo: "..v.reason)
                if (timeNow - v.timeCl) > 15000 then
                    table.remove(showing, k)
                end
            end
        else
            sleepx = 2000
            show3DText = false
        end
        Citizen.Wait(sleepx)
    end
end)


function DrawText3DSecond(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(Config.AlertTextColor.r, Config.AlertTextColor.g, Config.AlertTextColor.b, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(Config.TextColor.r, Config.TextColor.g, Config.TextColor.b, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end