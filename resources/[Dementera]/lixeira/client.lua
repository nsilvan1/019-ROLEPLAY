-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("commands",cRP)
vSERVER = Tunnel.getInterface("commands")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIXEIRAS
-----------------------------------------------------------------------------------------------------------------------------------------
local trashCans = {
    {"prop_bin_01a"},
    {"prop_bin_03a"},
    {"prop_bin_05a"},
    {"prop_dumpster_01a"},
    {"prop_dumpster_02a"},
    {"prop_dumpster_02b"},
    {"prop_dumpster_4a"},
    {"prop_dumpster_4b"}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTRASHCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        for k, v in pairs(trashCans) do
            local trash = GetClosestObjectOfType(plyCoords["x"],plyCoords["y"],plyCoords["z"],1.0,GetHashKey(v[1]),true,true,true)
            SetEntityAsMissionEntity(trash,true,true)
            if DoesEntityExist(trash) then
                trashCoords = GetEntityCoords(trash,0)
            end
        end
    end 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADPPLAYERCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(10)
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        if trashCoords ~= nil then
            local distance = GetDistanceBetweenCoords(plyCoords["x"], plyCoords["y"], plyCoords["z"], trashCoords["x"], trashCoords["y"], trashCoords["z"])
            if distance > 2 then
                trashCoords = nil
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCOORDSTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        if trashCoords ~= nil then
            if (GetDistanceBetweenCoords(plyCoords["x"], plyCoords["y"], plyCoords["z"], trashCoords["x"], trashCoords["y"], trashCoords["z"] < 1)) and (not IsPedInAnyVehicle(ply)) then
                text3D(trashCoords["x"], trashCoords["y"], trashCoords["z"]+1.5,"~g~E~w~   VASCULHAR",150)
                if (GetDistanceBetweenCoords(plyCoords["x"], plyCoords["y"], plyCoords["z"], trashCoords["x"], trashCoords["y"], trashCoords["z"] < 0.5)) then
                    if IsControlPressed(1,38) then
                        TriggerEvent("Notify","sucesso","Você esta procurando algo na lixeira....")
                        TriggerEvent("progress",15000,"PROCURANDO")
                        TriggerEvent('cancelando',true)
                        trashAnim()
                        Citizen.Wait(15000)
                        ClearPedTasks(PlayerPedId())
                        TriggerEvent('cancelando',false)
                        vSERVER.searchTrash()
                    end
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function text3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMAÇÃO DE PEGAR O LIXO
-----------------------------------------------------------------------------------------------------------------------------------------
function trashAnim()
    TaskStartScenarioInPlace(PlayerPedId(),"PROP_HUMAN_BUM_BIN",0,true)
end
