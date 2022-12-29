local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vSERVER = Tunnel.getInterface("eg_desmanche")
vSERVER2 = Tunnel.getInterface("vrp_admin")
--------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
--------------------------------------------------------------------------------------------------------------
local veh = nil

local desmanchando = false
local pegou_ferramentas = false
local pegou_peca = false
local pegou_item = false
local vendendo = false

local indice = 0
local quantidade_de_pecas_do_veiculo = 0
local quantidade_pecas_removidas = 0
local modelHash = 0

local coordenadasPartes_Veiculo = {}
local PecasRemovidas = {}

local itemNaMao = ''
local placa = ''
local nomeCarro = ''
local modeloCarro = ''

local permissao = "desmanche.permissao" -- Permissão para desmanchar
local tempo_remover_pecas = 3000 -- Tempo em milisegundos que o player demora para remover a peça do veículo
local coordenadas_locais_desmanche = {
    [1] = { ['x'] = 1564.04, ['y'] = -2164.27, ['z'] = 77.54 }, --- MC 1564.04,-2164.27,-2164.27
    [2] = { ['x'] = 1512.0, ['y'] = -2098.14, ['z'] = 76.8 }, --- MC2
	[3] = { ['x'] = 1275.38, ['y'] = -2559.54, ['z'] = 43.27 }, --- HELLS
    [4] = { ['x'] = 1361.14, ['y'] = -2601.83, ['z'] = 50.12 }, --- HELLS2
}

local coordenadas_locais_ferramentas = {
    [1] = { ['x'] = -1077.71, ['y'] = -1675.68, ['z'] = 4.58, ['h'] = 211.56 },
    [2] = { ['x'] = 3727.15, ['y'] = 4539.13, ['z'] = 33.08, ['h'] = 211.56 },
    [3] = { ['x'] = -288.33, ['y'] = 2966.09, ['z'] = 30.88 },
}

-- H é a direção para qual o player vai olhar ao entregar a peça.
local coordenadas_locais_guardarPecas = {
    [1] = { ['x'] = -1076.31, ['y'] = -1679.43, ['z'] = 4.58, ['h'] = 303 }, 
    [2] = { ['x'] = 3724.02, ['y'] = 4546.7, ['z'] = 32.89, ['h'] = 303 }, 
    [3] = { ['x'] = -281.03, ['y'] = 2965.03, ['z'] = 30.88 }, 
}
-- Coordenadas dos locais onde o player poderá vender as peças desmontadas.
-- IMPORTANTE: DEIXAR NA MESMA ORDEM DOS LOCAIS DE DESMANCHE.
-- Exemplo: No PRIMEIRO local de desmanche o player poderá vender as peças no PRIMEIRO local de venda abaixo.
local coordenadas_locais_venda = {
    [1] = { ['x'] = -1079.86, ['y'] = -1679.59, ['z'] = 4.58 },
    [2] = { ['x'] = 3723.48, ['y'] = 4537.66, ['z'] = 33.09 },
    [3] = { ['x'] = -282.7, ['y'] = 2957.13, ['z'] = 30.88 },
}

-- Coordenada do local onde o player poderá vender as peças extras obtidas ao finalizar o processo de desmanche.
local coordenada_venda_pecas_extra = {
    [1] = { ['x'] = 846.82, ['y'] = -936.82, ['z'] = 26.53 },
}

-- Bom, pode ser que no seu servidor os nomes dos itens sejam diferentes. Neste caso terá que mexer aqui:
local itens = {
    ['rodaDeCarro'] = "jogodepneu",
    ['portaDeCarro'] = "jogodepneu",
    ['rodaDeMoto'] = "jogodepneu",
}

-- À direita logo abaixo temos os objetos que o player carrega na mão durante o processo de desmanche
-- Existem diversos modelos de rodas/portas, etc que o player pode pegar.
-- Se quiser alterar você pode encontrar os objetos em: https://gta-objects.xyz/objects
-- No site acima pesquise por: door, wheel, etc para encontrar o prop desejado. Escolha o que quiser testar e substitua o nome à direta.
local props = {
    ['portas'] = 'imp_prop_impexp_car_door_04a',
    ['rodas'] = 'prop_tornado_wheel',
}

----------------------
-- INICIAR DESMANCHE
----------------------
Citizen.CreateThread(function()
    while true do
        local eGSleep = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if not desmanchando then
            -- Percorrer por todos os locais de desmanche
            for k,v in pairs(coordenadas_locais_desmanche) do
                -- Encontrar local de desmanche que o player está mais próximo
                if Vdist(x,y,z,v.x,v.y,v.z) <= 10 then
                    eGSleep = 1
                    indice = k
                    iniciarProcesso(indice) -- Chama a função que mostra as marcações no chão e inicia o desmanche
                end
            end
        end
        Citizen.Wait(eGSleep)
    end
end)

-----------------------
-- PEGANDO FERRAMENTAS
-----------------------
Citizen.CreateThread(function()
    while true do
        local eGSleep = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))

        if desmanchando and not pegou_ferramentas then
            eGSleep = 1
            DrawMarker(27,coordenadas_locais_ferramentas[indice].x,coordenadas_locais_ferramentas[indice].y,coordenadas_locais_ferramentas[indice].z-0.9,0,0,0,0.0,0,0,0.9,0.9,0.8,0,200,0,70,0,1,0,1)
            DrawMarker(2,coordenadas_locais_ferramentas[indice].x,coordenadas_locais_ferramentas[indice].y,coordenadas_locais_ferramentas[indice].z-0.4,0,0,0,0.0,0,0,0.4,0.4,0.4,255,255,255,70,1,1,0,0)
            
            if Vdist(x,y,z,coordenadas_locais_ferramentas[indice].x,coordenadas_locais_ferramentas[indice].y,coordenadas_locais_ferramentas[indice].z) <= 2 then
                drawTxtF("PRESSIONE  ~g~E~w~  PARA PEGAR AS FERRAMENTAS",4,0.5,0.93,0.50,255,255,255,180)
                if IsControlJustPressed(0,38) then
                    TriggerEvent("Notify","importante","Você está pegando as ferramentas.")
                    SetEntityHeading(ped, coordenadas_locais_ferramentas[indice].h)
                    vRP.playAnim(false, {{"amb@medic@standing@kneel@idle_a", "idle_a"}}, true)
                    pegou_ferramentas = true
                    TriggerEvent('Notify', 'sucesso', 'Você pegou as ferramentas, desmanche o veículo!')
                    ClearPedTasks(ped)
                end
            end
        end
        Citizen.Wait(eGSleep)
    end
end)

------------------------
-- DESMANCHANDO VEÍCULO
------------------------
Citizen.CreateThread(function()
    while true do
        local eGSleep = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if desmanchando and pegou_ferramentas and not vendendo then
            eGSleep = 1
            local classe = GetVehicleClass(veh) -- Pegar classe do veículo
            if classe ~= 8 then -- Se for CARRO
                local pD = GetEntityBoneIndexByName(veh,"handle_dside_f")
                coordenadasPartes_Veiculo['Porta_Direita'] = GetWorldPositionOfEntityBone(veh, pD)
                local pE = GetEntityBoneIndexByName(veh,"handle_pside_f")
                coordenadasPartes_Veiculo['Porta_Esquerda'] = GetWorldPositionOfEntityBone(veh, pE )
                coordenadasPartes_Veiculo['Roda_EsquerdaFrente'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_lf"))
                coordenadasPartes_Veiculo['Roda_DireitaFrente'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_rf"))
                coordenadasPartes_Veiculo['Roda_EsquerdaTras'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_lr"))
                coordenadasPartes_Veiculo['Roda_DireitaTras'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_rr"))
                if pD == -1 and pE == -1 then
                    quantidade_de_pecas_do_veiculo = 4
                else
                    quantidade_de_pecas_do_veiculo = 6
                end
            else -- se for MOTO
                coordenadasPartes_Veiculo['Roda_Frente'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_lf"))
                coordenadasPartes_Veiculo['Roda_Tras'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_lr"))
                -- coordenadasPartes_Veiculo['Banco'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"bodyshell _dummy"))
                quantidade_de_pecas_do_veiculo = 2
            end
            -- Rodar por vetor de coordenadas das partes do veículo a serem removidas
            for k , v in pairs(coordenadasPartes_Veiculo) do
                local xVeh,yVeh,zVeh = table.unpack(v)
                local dist = Vdist(x,y,z,xVeh,yVeh,zVeh)
                -- Se não removeu a peça atual e não está com nenhuma peça na mão
                if not PecasRemovidas[k] and not pegou_peca then
                    if dist <= 8 then
                        DrawMarker(21, xVeh,yVeh,zVeh+1, 0, 0, 0, 180.0, 0, 0, 0.4, 0.4, 0.4, 20, 133, 92, 150, 0, 0, 0, 1)
                        if dist <= 2.5 then
                            drawTxtF("~w~Pressione ~g~[E] ~w~para remover as peças.")

                            if dist < 1.1 then
                                if IsControlJustPressed(0, 38) then
                                    if k == 'Capo' or k == 'pMalas' then
                                        vRP.playAnim(false, {{"mini@repair" , "fixing_a_player"}}, true)
                                        Citizen.Wait(5000)
                                        ClearPedTasks(ped)
                                    elseif k == 'Porta_Direita' or k == 'Porta_Esquerda' then
                                        vRP._playAnim(false,{task='WORLD_HUMAN_WELDING'},true)
                                        Citizen.Wait(tempo_remover_pecas)
                                        ClearPedTasks(ped)
                                        vRP._CarregarObjeto("anim@heists@box_carry@","idle",props['portas'],50,28422)
                                        pegou_item = vSERVER.entregaItem(itens['portaDeCarro'])
                                        itemNaMao = itens['portaDeCarro']
                                        pegou_peca = true

                                        if k == 'Porta_Direita' then
                                            SetVehicleDoorBroken(veh, 0, true)
                                        elseif k == 'Porta_Esquerda' then
                                            SetVehicleDoorBroken(veh, 1, true)
                                        end
                                    elseif k == 'Roda_DireitaFrente' or k == 'Roda_EsquerdaFrente' or k == 'Roda_DireitaTras' or k == 'Roda_EsquerdaTras' or k == 'Roda_Frente' or k == 'Roda_Tras' then
                                        vRP.playAnim(false, {{"amb@medic@standing@tendtodead@idle_a" , "idle_a"}}, true)
                                        Citizen.Wait(tempo_remover_pecas)
                                        ClearPedTasks(ped)
                                        vRP._CarregarObjeto("anim@heists@box_carry@","idle",props['rodas'],50,28422)
                                        if k == 'Roda_Frente' or k == 'Roda_Tras' then
                                            pegou_item = vSERVER.entregaItem(itens['rodaDeMoto'])
                                            itemNaMao = itens['rodaDeMoto']
                                        else
                                            pegou_item = vSERVER.entregaItem(itens['rodaDeCarro'])
                                            itemNaMao = itens['rodaDeCarro']
                                        end
                                        pegou_peca = true
                                        if classe ~= 8 then
                                            if k == 'Roda_EsquerdaFrente' then
                                                SetVehicleTyreBurst(veh, 0, true, 1000)
                                            elseif k == 'Roda_DireitaFrente' then
                                                SetVehicleTyreBurst(veh, 1, true, 1000)
                                            elseif k == 'Roda_EsquerdaTras' then
                                                SetVehicleTyreBurst(veh, 4, true, 1000)
                                            elseif k == 'Roda_DireitaTras' then
                                                SetVehicleTyreBurst(veh, 5, true, 1000)
                                            end
                                        else
                                            if k == 'Roda_Frente' then
                                                SetVehicleTyreBurst(veh, 0, true, 1000)
                                            elseif k == 'Roda_Tras' then
                                                SetVehicleTyreBurst(veh, 4, true, 1000)
                                            end
                                        end
                                    else
                                        vRP.playAnim(false, {{"amb@medic@standing@tendtodead@idle_a" , "idle_a"}}, true)
                                        Citizen.Wait(5000)
                                        ClearPedTasks(ped)
                                    end

                                    if k == 'Capo' then
                                        SetVehicleDoorBroken(veh, 4, true)
                                    end
                                    Wait(5000)
                                    PecasRemovidas[k] = true
                                    quantidade_pecas_removidas = quantidade_pecas_removidas + 1
                                    if quantidade_pecas_removidas == quantidade_de_pecas_do_veiculo then
                                        TriggerEvent('Notify','importante','Você desmanchou o veículo! Venda as peças no computador.')
                                        vendendo = true
                                        coordenadasPartes_Veiculo = {}
                                        PecasRemovidas = {}
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(eGSleep)
    end
end)

-------------------
-- GUARDANDO PEÇAS
-------------------
Citizen.CreateThread(function()
    while true do
        local eGSleep = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if pegou_peca and not vendendo then
            eGSleep = 1
            -- Passa por todas as coordenadas dos locais de guardar peças
            for k,v in pairs(coordenadas_locais_guardarPecas) do
                local dist = Vdist(x,y,z,v.x,v.y,v.z)
                if dist <= 20 then
                    -- Marker flutuante
                    DrawMarker(21,v.x,v.y,v.z-0.25,0,0,0,0.0,0,0,0.4,0.4,0.4,255,255,255,100,1,1,0,0)
                    DrawMarker(27,v.x,v.y,v.z-0.9,0,0,0,0.0,0,0,0.7,0.7,0.4,0,200,0,150,0,1,0,1)
                    if dist <= 1.5 then
                    drawTxtF("PRESSIONE  ~g~E~w~  PARA GUARDAR A PEÇA",4,0.5,0.93,0.50,255,255,255,180)
                        if IsControlJustPressed(0,38) then
                            RequestAnimDict("anim@heists@money_grab@briefcase")
                            while not HasAnimDictLoaded("anim@heists@money_grab@briefcase") do
                                Citizen.Wait(0) 
                            end
                            TaskPlayAnim(ped,"anim@heists@money_grab@briefcase","put_down_case",100.0,200.0,0.3,120,0.2,0,0,0)
                            Wait(500)
                            vRP._DeletarObjeto()
                            ClearPedTasks(ped)
                            if pegou_item then
                                vSERVER.removeItem(itemNaMao)
                            end
                            pegou_peca = false
                        end
                    end
                end
            end
        end
        Citizen.Wait(eGSleep)
    end
end)

------------------------------------------------------------
-- FINALIZANDO OPERAÇÃO DE DESMANCHE | RECEBENDO O DINHEIRO
------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local eGSleep = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if desmanchando and not pegou_peca and quantidade_pecas_removidas == quantidade_de_pecas_do_veiculo and indice ~= 0 and vendendo then
            eGSleep = 1
            xVenda = coordenadas_locais_venda[indice].x
            yVenda = coordenadas_locais_venda[indice].y
            zVenda = coordenadas_locais_venda[indice].z
            local dist = Vdist(x,y,z,xVenda,yVenda,zVenda)
            if dist <= 10 then
                DrawMarker(21,xVenda,yVenda,zVenda-0.25,0,0,0,0.0,0,0,0.4,0.4,0.4,255,255,255,100,1,1,0,0)
                DrawMarker(27,xVenda,yVenda,zVenda-0.9,0,0,0,0.0,0,0,0.7,0.7,0.4,0, 200, 0,150,0,1,0,1)
                if dist <= 1 then
                    if IsControlJustPressed(0,38) then
                        vRP.playAnim(false, {{"anim@heists@prison_heistig1_p1_guard_checks_bus", "loop"}}, true)
                        ClearPedTasks(ped)
                        local classe = GetVehicleClass(veh)
                        vSERVER2.deleteVehicles(veh)
                        vSERVER.GerarPagamento(placa, modelHash)
                        vendendo = false
                        reseta()
                        TriggerEvent('Notify','sucesso','Você vendeu as peças no mercado livre.')
                    end
                end
            end
        end
        Citizen.Wait(eGSleep)
    end
end)

------------------------------------------------------------
-- CANCELAR DESMANCHE (TECLA F7)
------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local eGSleep = 1000
        if desmanchando then
            eGSleep = 1
            if IsControlJustPressed(0,168) then
                if veh then 
                    FreezeEntityPosition(veh,false)
                end
                vendendo = false
                reseta()
                TriggerEvent('Notify','importante','O desmanche foi cancelado.')
            end
        end
        Citizen.Wait(eGSleep)
    end
end)

----------------------------------------------------------------------------------------
-- FUNÇÕES !!!
----------------------------------------------------------------------------------------
function iniciarProcesso(index)
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
    if IsPedInAnyVehicle(ped,true) then
        DrawMarker(27,coordenadas_locais_desmanche[index].x,coordenadas_locais_desmanche[index].y,coordenadas_locais_desmanche[index].z-0.96,0,0,0,0,0,0,4.1,4.1,0.5,255,255,255,100,0,0,0,1)
        if Vdist(x,y,z,coordenadas_locais_desmanche[index].x,coordenadas_locais_desmanche[index].y,coordenadas_locais_desmanche[index].z) <= 2 then
            drawTxtF("PRESSIONE  ~g~E~w~  PARA ~g~DESMANCHAR~w~ O VEÍCULO",4,0.5,0.93,0.50,255,255,255,180)
            if IsControlJustPressed(0,38) then
                veh = GetVehiclePedIsIn(ped, false)
                placa = GetVehicleNumberPlateText(veh)
                nomeCarro = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                modeloCarro = GetLabelText(nomeCarro)
                if vSERVER.checkPermission(permissao) then
                    if GetPedInVehicleSeat(veh,-1) == ped then
                        modelHash = GetEntityModel(veh)
                        if vSERVER.checkVeh(modelHash) then -- Verifica se o veículo está na lista das configs
                            if vSERVER.checkProprietario(placa,modelHash) then-- Verifica se o veículo pode ser desmanchado
                                FreezeEntityPosition(veh, true)
                                TriggerEvent("Notify","importante","Para desmanchar, pegue as ferramentas ao lado!")
                                desmanchando = true
                            else
                                TriggerEvent("Notify","importante","Veículo não encontrado na lista de proprietário.")
                            end
                        else
                            TriggerEvent("Notify","importante","Este veículo não pode ser desmanchado.")
                        end
                    else
                        TriggerEvent("Notify","importante","Vá para o assento do motorista para iniciar o processo.")
                    end
                else
                    TriggerEvent("Notify","importante","Você não possui permissão para desmanchar veículos!")
                end
            end
        end
    end
end


function drawTxtF(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

-- PARA RESETAR AS VARIÁVEIS 
function reseta()
    veh = nil
    desmanchando = false
    pegou_ferramentas = false
    pegou_peca = false
    pegou_item = false
    quantidade_de_pecas_do_veiculo = 0
    quantidade_pecas_removidas = 0
    modelHash = 0
    PecasRemovidas = {}
    itemNaMao = ''
    placa = ''
    nomeCarro = ''
    modeloCarro = ''
end