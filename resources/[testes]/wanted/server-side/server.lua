------------------------------------------------------------------------------------
-- connection
------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
------------------------------------------------------------------------------------
-- connect
------------------------------------------------------------------------------------
zer = {}
Tunnel.bindInterface('wanted', zer)
local idgens = Tools.newIDGenerator()
------------------------------------------------------------------------------------
-- sendLocPolice
------------------------------------------------------------------------------------
local list = {}
function zer.policeActiveLocation()
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local x, y, z = vRPclient.getPosition(user_id)
    local polices = vRP.getUsersByPermission("founder")
    for l, w in pairs(polices) do
        local player = vRP.getUserSource(parseInt(w))
        async(function()
            local id = idgens:gen()
            list[id] = vRPclient.addBlip(player, x, y, z, 429, 1, "Um Procurado pela policia foi avistado", 0.5, false)
            TriggerClientEvent("Notify", player, "importante",
                "Um procurado foi avistado, Informacoes do mesmo: <b>[ " .. identity.name .. ' ' .. identity.firstname ..
                    ' ]', 15000)
            vRPclient._playSound(player, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
            SetTimeout(10000, function()
                vRPclient.removeBlip(player, list[id])
                idgens:free(id)
            end)
        end)
        vRPclient.playSound(source, "Event_Message_Purple", "GTAO_FM_Events_Soundset")
    end
end
