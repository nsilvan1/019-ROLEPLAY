local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
PL = {}
Tunnel.bindInterface("nxgroup-id", PL)
vSERVER = Tunnel.getInterface("nxgroup-id")
local timer = false 

function PL.idclient(user_id) 
    local id = tonumber(user_id) or 0
	FreezeEntityPosition(PlayerPedId(),true)
    timer = true 
    timerid()
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'open',status = 0,id = id});
end

function timerid()
    Citizen.CreateThread(function()
        while timer do
            if vSERVER.checkid() then 
                timer = false
                FreezeEntityPosition(PlayerPedId(),false)
                SetNuiFocus(false, false)
                SendNUIMessage({action = 'close', status = 1}); 
            end
            Citizen.Wait(20000)
        end
    end)
end 

