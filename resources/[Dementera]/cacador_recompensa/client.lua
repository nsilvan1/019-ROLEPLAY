local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vSERVER = Tunnel.getInterface("cacador_recompensa")
local cFG = module("cacador_recompensa", "config")
open = false

RegisterCommand('cacador', function()
	if vSERVER.ValidationUserRemote() then 
		open = true
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "cacador" })
	end
end)  


RegisterNUICallback("ButtonClick", function(data, cb)
	if data.action == "fecharCaca" then
		config.stopanim()
        open = false
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'fecharCaca'})
        ClearPedTasks(PlayerPedId())
    end
end)


RegisterNetEvent('Procurado:IniciouProcura')
AddEventHandler('Procurado:IniciouProcura', function(time)
    TriggerEvent('wanted:startWanted',99999999999)
end)

RegisterNetEvent('tirandoprocurado')
AddEventHandler('tirandoprocurado', function()
    TriggerEvent('wanted:removeWanted')
end)
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
        -- elite.addList()
        TriggerEvent('Notify', 'aviso', textovcestaprocurado)
    end
end)
------------------------------------------------------------------------------------
-- removeWanted
------------------------------------------------------------------------------------
RegisterNetEvent('wanted:removeWanted')
AddEventHandler('wanted:removeWanted', function(time)
    if wantedSeconds > 0 then
        TriggerEvent('Notify', 'sucesso', textonprocurado)
        wantedSeconds = 0
        wanted = false
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--     local sleep = 1000
--     if wanted then
--         sleep = 100
--         vSERVER.chamouPolicia1() -- Faz a função de chaamar a polícia
--         if Avisar then -- If para decidir de o player vai ou não saber se a polícia foi chamada
--             TriggerEvent('Notify', 'aviso',textolocalizado)
--         end
--     end
--     Wait(sleep)
-- end)

------------------------------------------------------------------------------------
-- Verifica se está procurado
------------------------------------------------------------------------------------
RegisterNetEvent('Procurado:ChecarProcurados')
AddEventHandler('Procurado:ChecarProcurados', function()
    if wanted then
        vSERVER.chamouPolicia1() -- Faz a função de chaamar a polícia
        if Avisar then -- If para decidir de o player vai ou não saber se a polícia foi chamada
            TriggerEvent('Notify', 'aviso',textolocalizado)
        end
    end
end)
------------------------------------------------------------------------------------
-- Tentou Hacker o sistema
------------------------------------------------------------------------------------
-- RegisterNetEvent('Procurado:falhouHacker')
-- AddEventHandler('Procurado:falhouHacker', function()
--     if wanted then
--         if AvisarHack then -- If para chamar a polícia ou se falhar o hack
--             print('aqui?')
--             vSERVER.chamouPolicia2()
--             TriggerEvent('Notify', 'aviso',textolocalizado2)
--         end
--     end
-- end)
------------------------------------------------------------------------------------
-- Faz a verificação se está procurado de tempo em tempo
------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if wanted then
            sleep = 5
            drawTxt(textoprocurado, 5, 0.925, 0.101, 0.40, 255, 255, 255, 10)
        end
        Wait(sleep)
    end
end)
------------------------------------------------------------------------------------
-- thread Cooldown
------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if wanted then
            if wantedSeconds > 0 then
                wantedSeconds = wantedSeconds - 1
            elseif wantedSeconds == 0 then
                TriggerEvent('Notify', 'sucesso', textonprocurado)
                wantedSeconds = 0
                wanted = false
            end
        end
        Wait(1000)
    end
end)
------------------------------------------------------------------------------------
-- thread Blip para tirar o hacker
------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        for k,v in pairs(config.blipCoords) do
            local distance = #(pedCoords - v['coords'])
            if distance <= 3 then
                idle = 5
                DrawMarker(21, v['coords'].x, v['coords'].y, v['coords'].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255, 0, 0,100,0,0,0,1) 
                if distance < 3 then
                    DrawText3D(v['coords'].x,v['coords'].y,v['coords'].z-0.25, textoInBlip)
                    if IsControlJustPressed(0,config.tecla) then
                        if useTaskbar then
                            TriggerServerEvent("item_r_Procurado")
                        end
                        if nTaskbar then
                            TriggerServerEvent("item_r_ProcuradoSimples")
                        end
                    end
                end
            end
		end
		Citizen.Wait(idle)
	end
end)


------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        for k,v in pairs(config.BlipAcesso) do
            local distance = #(pedCoords - v['coords'])
            if distance <= 3 then
                idle = 5
                DrawMarker(21, v['coords'].x, v['coords'].y, v['coords'].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255, 0, 0,100,0,0,0,1) 
                if distance < 3 then
                    drawTxt(textoInBlipCacador,4,0.5,0.93,0.50,255,255,255,180)
                    if IsControlJustPressed(0,config.tecla) and vSERVER.ValidationUser()  then	
						config.startanim()
                        open = true
                        SetNuiFocus(true,true)
                        SendNUIMessage({ action = "cacador" })
                    end
                end
            end
		end
		Citizen.Wait(idle)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestPassport",function(data,cb)
 	local passport = vSERVER.getPass(data.user_id)
	if passport then
 		cb({ passport = passport})
	end
end)

RegisterNUICallback("requestCacadores",function(data,cb)
   local cacadores = vSERVER.getCacadores()
	if cacadores then
      	cb({ cacadores = cacadores})
	end
end)

RegisterNUICallback("requestProcurados",function(data,cb)
	local procurados = vSERVER.getProcurados()
	 if procurados then
		   cb({ procurados = procurados})
	 end
 end)

RegisterNUICallback("addCacador",function(data,cb)
	vSERVER.addCacador(data.user_id, data.hierarquia_id)
	return
end)

RegisterNUICallback("updateCacador",function(data,cb)
	vSERVER.updateCacador( data.id, data.status)
	local cacadores = vSERVER.getCacadores()
	if cacadores then
      	cb({ cacadores = cacadores})
	end
end)

RegisterNUICallback("updateHierarquiaCacador",function(data,cb)
	vSERVER.updateHierarquiaCacador( data.id, data.hierarquia_id)
	local cacadores = vSERVER.getCacadores()
	if cacadores then
      	cb({ cacadores = cacadores})
	end
end)

RegisterNUICallback("postCacadorHierarquia",function(data,cb)
	vSERVER.insertHierarquia( data.nome, data.id, data.altera)
end)

RegisterNUICallback("getHierarquia",function(data,cb)
	local hierarquia = 	vSERVER.getHierarquia()
	if hierarquia then
      	cb({ hierarquia = hierarquia})
	end
end)

RegisterNUICallback("permiteAlterar",function(data,cb)
	local alterar = vSERVER.permiteAlterar()
	if alterar then
      	cb({ alterar = 'S'})
	else 
		cb({ alterar = 'N'})
	end
end)

RegisterNUICallback("permitePolicia",function(data,cb)
	local permissao = vSERVER.permitirPolicia()
	  	cb({ permissao = permissao})
end)



RegisterNUICallback("insertRecompensa",function(data,cb)
	vSERVER.insertRecompensa(data.user_id, data.recompensa, data.motivo)
end)

RegisterNUICallback("updateRecompensa",function(data,cb)
	vSERVER.updateRecompensa(data.id, data.recompensa)
end)

RegisterNUICallback("removeProcurado",function(data,cb)
	vSERVER.removeProcurado(data.id)
end)

RegisterNUICallback("pagamentoRecompensa",function(data,cb)
	vSERVER.pagamentoRecompensa(data.valor, data.id, data.passaporte)
end)

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

DrawText3D = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	-- local x,y,z = table.unpack(coords)
    
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