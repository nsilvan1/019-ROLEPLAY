local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
hel = Tunnel.getInterface("mecanico",hel)
--------------------------------------------------------------------- 
--------------------------------------------------------------------- 
local blips = false
local servico = false
local carrinho = 0
local selecionado = 0
local processo = false
local spawn = false
local segundos = 0
local CoordenadaX = 898.74
local CoordenadaY = -899.15
local CoordenadaZ = 27.79

---------------------------------------------------------------------
-- CARROS
---------------------------------------------------------------------
local carros = {
    [1] = { ['model'] = "rebel"},
    [2] = { ['model'] = "ratloader"},
    [3] = { ['model'] = "panto"},
    [4] = { ['model'] = "picador"},
    [5] = { ['model'] = "tornado4"},
    [6] = { ['model'] = "clique"},
    [7] = { ['model'] = "cheburek"},
    [8] = { ['model'] = "emperor2"},
    [9] = { ['model'] = "rhapsody"},
    [10] = { ['model'] = "bfinjection"},
    [11] = { ['model'] = "voodoo2"}
}

---------------------------------------------------------------------
-- SPAWN CARROS
---------------------------------------------------------------------
local locs = {
    [1] = { ['x'] = -942.78, ['y'] = -179.59, ['z'] = 41.88 ,['h'] = 212.83 },
    [2] = { ['x'] = -997.27, ['y'] = -1603.17, ['z'] = 4.47, ['h'] = 270.62 },
    [3] = { ['x'] = 1150.07, ['y'] = -782.67, ['z'] = 57.6, ['h'] = 179.09 },
    [4] = { ['x'] = 316.21, ['y'] = 345.63, ['z'] = 104.71, ['h'] = 291.46 },
    [5] = { ['x'] = -2351.72, ['y'] = 291.01, ['z'] = 168.99, ['h'] = 110.56 },
    [6] = { ['x'] = -71.37, ['y'] = 903.76, ['z'] = 235.14, ['h'] = 94.55 },
    [7] = { ['x'] = 737.05, ['y'] = 2527.53, ['z'] = 73.23, ['h'] = 87.60 },
    [8] = { ['x'] = 1691.5, ['y'] = 3286.07, ['z'] = 41.15, ['h'] = 214.78 },
    [9] = { ['x'] = 1782.65, ['y'] = 4607.66, ['z'] = 36.7, ['h'] = 5.43 },
    [10] = { ['x'] = 122.2, ['y'] = 6594.57, ['z'] = 31.54, ['h'] = 74.50},
    [11] = { ['x'] = -2195.54, ['y'] = 4245.95, ['z'] = 47.84, ['h'] = 96.45 },
    [12] = { ['x'] = -3081.48, ['y'] = 222.19, ['z'] = 13.53, ['h'] = 230.59 },
}

---------------------------------------------------------------------
-- ENTRAR EM SERVIÇO
---------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timedistance = 1000
        local ped = PlayerPedId()
        local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),CoordenadaX,CoordenadaY,CoordenadaZ)

        if distance <= 2 and not servico then
            timedistance = 4
			DrawText3D(CoordenadaX,CoordenadaY,CoordenadaZ, "~g~E~w~ PARA INICIAR ~g~SERVIÇO~w~")
            if IsControlJustPressed(0,38) then
                servico = true
                selecionado = 1
                carrinho = math.random(1,4)
                CriandoBlipMec(locs,selecionado)
                TriggerEvent("Notify","sucesso","Você iniciou a rota de serviços!")
            end
        end
        Citizen.Wait(timedistance)
    end

end)

Citizen.CreateThread(function()
    while true do
        local timedistance = 1000
        if servico then
            timedistance = 4
            local ped = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(ped))
            local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z,x,y,z,true)

            if distance <= 50 then
                if not spawn then
                    spawSuprimento(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z,locs[selecionado].h)
                    spawn = true
                end
                DrawText3D(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z + 1, "~g~E~w~ PARA REPARAR O ~g~VEICULO~w~")
                if distance <= 2.5 then
                    if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) and not processo then
                        TriggerEvent('cancelando',true)
                        TriggerEvent("progress",10000,"Reparando")
						vRP._playAnim(false,{task='WORLD_HUMAN_WELDING'},true)
                        SetTimeout(10000, function()
                            processo = true
                            segundos = 0
                            local nvehicle = vRP.getNearestVehicle(2)
                            hel.checkPayment()
                            vRP._stopAnim(false)
                            DeleteVehicle(nvehicle)
                        end)
                        selecionado = selecionado + 1
                        RemoveBlip(blips)
                        if selecionado == 12 then
                            selecionado = 1
                        end
                        CriandoBlipMec(locs,selecionado)
                        TriggerEvent("Notify","importante","Vá até o próximo local para arrumar o veículo!")
                        spawn = false
                    end
                end
                if distance > 20 then
                    timedistance = 1000
                end
            end
        end
        Citizen.Wait(timedistance)
    end
end)

---------------------------------------------------------------------
-- Sair de serviço
---------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
        local timedistance = 1000
        if servico then
            timedistance = 4
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			drawTxt("PRESSIONE ~g~F7 ~w~PARA FINALIZAR O EXPEDIENTE",4,0.260,0.905,0.5,255,255,255,200)
			drawTxt("~w~ PROSSIGA ATE O SEU DESTINO ",4,0.260,0.929,0.5,255,255,255,200)
			if IsControlJustPressed(0,168) then
				RemoveBlip(blips)
                blips = nil
                servico = false
				selecionado = 0
				TriggerEvent("Notify","aviso","Você saiu de serviço.")
			end
        end
        Citizen.Wait(timedistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timedistance = 1000
		if processo then
			segundos = segundos - 1
			if segundos <= 0 then
				processo = false
				ClearPedTasks(PlayerPedId())
				TriggerEvent('cancelando',false)
			end
		end
		Citizen.Wait(timedistance)
	end
end)

---------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
	local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 50)
end

function spawSuprimento(x,y,z,h) --SPAWNA VEICULO NA COORDENADA By: Muamba#0001
    carrinho = math.random(1,10)

    local vhash = GetHashKey(carros[carrinho].model)

    while not HasModelLoaded(vhash) do
        RequestModel(vhash)
        Citizen.Wait(10)
    end

    if HasModelLoaded(vhash) then
        local nveh = CreateVehicle(vhash,x,y,z,h,true,true)
          SetVehicleDoorsLocked(nveh,4)
		  SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
        local netveh = VehToNet(nveh)
    end
end


function CriandoBlipMec(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,162)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Reparo de veículos")
	EndTextCommandSetBlipName(blips)
end
