
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
config = {}
config.rangeDistance = 200 -- Distancia se o player se afastar muito voltar para a arena

config.locArenas = { -- Localizações das arenas
    vec3(707.11,-966.94,30.42)
}

config.keys = {
    scoreboard = 137, -- CAPS
    spawn = 20, -- SPAWNAR
}

config.drawMarker = function(coords) -- DRAWMARKER DO BLIP DA ARENA
    DrawMarker(0,coords,0,0,0,0,0,130.0, 0.5,0.5,0.5, 12,200, 0,155 ,1,0,0,1)
end

config.drawTxt = function()
    drawTxt("VOCÊ ESTÁ MORTO PRESSIONE ~g~Z~w~ PARA SPAWNAR",4,0.5,0.93,0.50,255,255,255,255)
end

--[[ -- COLOQUE ISSO NAS FUNCOES DE CLIENTS
    local in_arena = false

    RegisterNetEvent("mirtin_survival:updateArena")
    AddEventHandler("mirtin_survival:updateArena", function(boolean)
        in_arena = boolean
    end)
]]
