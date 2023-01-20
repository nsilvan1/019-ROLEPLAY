--------------------------------------------------------
-- connection
--------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
zer = Tunnel.getInterface("wanted")
--------------------------------------------------------
-- Como usar
--------------------------------------------------------
--[[
    a funcao 'wanted:startWanted',10 starta o procurado
    a funcao 'wanted:removeWanted' cancela o procurado
    a funcao 'wanted:checkWanted' verifica se o mesmo esta procurado ou n, caso esteja sera enviada a localizacao pra policia


    puxe a funcao de start nos roubos e acoes q vc quer q deixe no procurado (puxe usando o TriggerClientEvent).
    puxe a funcao de verificar nos lugares q vc quer q seja emetido o alerta pra policia ao acessar.
]]
------------------------------------------------------------------------------------
-- variavery
------------------------------------------------------------------------------------
local wanted = false
local wantedSeconds = 0
------------------------------------------------------------------------------------
-- startWanted
------------------------------------------------------------------------------------
RegisterNetEvent('wanted:startWanted')
AddEventHandler('wanted:startWanted', function(time)
    if wantedSeconds == 0 then
        juia = tonumber(time)
        wantedSeconds = juia
        wanted = true
        zer.addList()
        TriggerEvent('Notify', 'aviso', 'Você está procurado por ' .. wantedSeconds .. ' segundos.')
    end
end)
------------------------------------------------------------------------------------
-- removeWanted
------------------------------------------------------------------------------------
RegisterNetEvent('wanted:removeWanted')
AddEventHandler('wanted:removeWanted', function()
    if wantedSeconds > 0 then
        TriggerEvent('Notify', 'sucesso', 'Você não está mas procurado, aproveite.')
        wantedSeconds = 0
        wanted = false
    end
end)
------------------------------------------------------------------------------------
-- verifyWanted
------------------------------------------------------------------------------------
RegisterNetEvent('wanted:checkWanted')
AddEventHandler('wanted:checkWanted', function()
    if wanted then
        TriggerEvent('Notify', 'aviso','Um dos pedestres o reconheceu da lista de procurados, sua localizacao foi enviada pra policia.')
        zer.policeActiveLocation()
    end
end)
------------------------------------------------------------------------------------
-- threadWanted
------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if wanted then
            sleep = 5
            drawTxt("Segundos de Procurado " .. wantedSeconds .. " restantes", 4, 0.27, 0.92, 0.5, 255, 255, 255, 255)
        end
        Wait(sleep)
    end
end)
------------------------------------------------------------------------------------
-- threadCooldown
------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if wanted then
            if wantedSeconds > 0 then
                wantedSeconds = wantedSeconds - 1
            elseif wantedSeconds == 0 then
                TriggerEvent('Notify', 'sucesso', 'Você não está mas procurado, aproveite.')
                wantedSeconds = 0
                wanted = false
            end
        end
        Wait(1000)
    end
end)
------------------------------------------------------------------------------------
-- functions
------------------------------------------------------------------------------------
function drawTxt(text, font, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
