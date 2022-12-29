local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
klaus = {}
Tunnel.bindInterface("nxgroup_tempban", klaus)
vSERVER = Tunnel.getInterface("nxgroup_tempban")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Nui = false

RegisterCommand("bantemp", function()
    if vSERVER.bante() then
        Nui = true
        SetNuiFocus(true, true)
        SendNUIMessage({action = true})
    end
end)

RegisterNUICallback("closeNui", function(data)
    Nui = false
    SetNuiFocus(false, false)
    SendNUIMessage({action = false})
end)

RegisterNUICallback("closeTempbanNui", function(data)
    SetNuiFocus(false, false)
    Nui = false
end) 

RegisterNUICallback("sendInformations", function(data)
    vSERVER.tempban(data.id, data.tempo)
    SendNUIMessage({action = false})
    SetNuiFocus(false, false)
    
    Nui = false
end)



