-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterCommand("cl", function(source, args, rawcmd)
    TriggerClientEvent("yaga_antcl:show", source)
end)

AddEventHandler("playerDropped", function(reason)
    local crds = GetEntityCoords(GetPlayerPed(source))
    local id = vRP.getUserId(source)
    if not id or id == nil then
        id = "NAO OBTEVE"
    end
    local identifier = ""
    if Config.UseSteam then
        identifier = GetPlayerIdentifier(source, 0)
    else
        identifier = GetPlayerIdentifier(source, 1)
    end
    TriggerClientEvent("yaga_antcl", -1, id, crds, identifier, reason)
    if Config.LogSystem then
        SendLog(id, crds, identifier, reason)
    end
end)

function SendLog(id, crds, identifier, reason)
    local identity = vRP.getUserIdentity(id)
    print("id:"..id)
    print("COORDS: "..crds.x..","..crds.y..","..crds.z)
    print("identifier:"..identifier)
    print("reason:"..reason)
    print(""..os.date("Data: %d/%m/%Y - %H:%M:%S"))
    sendLog('LogCL',"JOGADOR SAIU: ["..id.."] "..identity.name.." "..identity.firstname.." \n[LOCAL]: "..crds.x..","..crds.y..","..crds.z.."\n[IDENTIFICADOR]: "..identifier.."\n[MOTIVO]: "..reason.." "..os.date("\nData: %d/%m/%Y - %H:%M:%S"),true)
end