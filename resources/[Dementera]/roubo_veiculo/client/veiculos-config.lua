local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

Tunnel.bindInterface("roubo_veiculo_server",veiculoSever)
vSERVER = Tunnel.getInterface("roubo_veiculo_server")

rouboCarro = {}
Tunnel.bindInterface("roubo_veiculo_client",rouboCarro)

-------------------variaveis 
local servico = false
local emservico = false
local desmanche = false
local spawn = false
local processo = false
local blips = false
local clonado = false 
local carrinho = 0
local location = 0
local npcLocal = true ---colocar false somente se tiver o tablet do dementera

------------------- objetos 
local npc = {  {['x'] = 210.32, ['y'] = -1989.76, ['z'] = 19.74, ['hash'] = 0x94562DD7, ['hashId'] = 'a_m_m_farmer_01'}}
local npc2 = {  {['x'] = 185.82, ['y'] = -688.16, ['z'] = 33.13, ['hash'] = 0x94562DD7, ['hashId'] = 'a_m_m_farmer_01'}}

local iniciar = {	[1] = { ['x'] = 210.32, ['y'] = -1989.76, ['z'] = 19.72 },
                    [2] = { ['x'] = 224.39, ['y'] = -1983.66, ['z'] = 19.74 },
					[3] = {['x'] = 103.33, ['y'] = 6623.35, ['z'] = 31.83},
					[4] = {['x'] = 185.82, ['y'] = -688.16, ['z'] = 33.13}}
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

----------------------------- 

Citizen.CreateThread(function()	
	while true do
		local skips = 1000
		 if not servico and not desmanche then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(iniciar[1].x,iniciar[1].y,iniciar[1].z)
			local distance = GetDistanceBetweenCoords(iniciar[1].x,iniciar[1].y,cdz,x,y,z,true)
        	if distance <= 10.0 then		    
			skips = 1
			DrawMarker(25,iniciar[1].x,iniciar[1].y,iniciar[1].z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
				if distance <= 1.8 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR A LISTA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38)  then	
						if vSERVER.configEmpCarro() then 
							location = math.random(1,12)
							carrinho = math.random(1,10)
							vSERVER.iniciaEmprego()
						-- 	RemoveBlip(blips)	
							spawn = false
							vSERVER.checkKey(carros[carrinho].model)					
							CriandoBlip(locs,location)
							servico = true
							emservico = true
							SetTimeout(80000, function()
								RemoveBlip(blips)								
							end)	
						else 
							vSERVER.checkError('CARRO')
						end 
					end
				end
			end
		end
		Citizen.Wait(skips)
	end
end)

Citizen.CreateThread(function()
    while true do
        local timedistance = 1000
        if servico then
            timedistance = 4
            local ped = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[location].x,locs[location].y,locs[location].z)
            local distance = GetDistanceBetweenCoords(locs[location].x,locs[location].y,cdz,x,y,z,true)

            if distance <= 50 then
                if not spawn then
                    spawSuprimento(locs[location].x,locs[location].y,locs[location].z,locs[location].h)
                    spawn = true
                end
				DrawMarker(25,iniciar[1].x,iniciar[1].y,iniciar[1].z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
                if distance <= 2.5 then
					local ped = PlayerPedId()
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR O ROUBO ",4,0.5,0.93,0.50,255,255,255,180)					
					if IsControlJustPressed(0,38) and IsPedInAnyVehicle(ped) then
						RemoveBlip(blips)
					    CriandoBlip(iniciar,2)
						servico = false
						desmanche = true
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

Citizen.CreateThread(function()	
	while true do
		local skips = 1000
		 if desmanche then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(iniciar[2].x,iniciar[2].y,iniciar[2].z)
			local distance = GetDistanceBetweenCoords(iniciar[2].x,iniciar[2].y,cdz,x,y,z,true)
        	if distance <= 10.0 then		    
			skips = 1
			DrawMarker(25,iniciar[2].x,iniciar[2].y,iniciar[2].z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
				if distance <= 2.5 and IsPedInAnyVehicle(ped) then
					    local ped = PlayerPedId()
						drawTxt("PRESSIONE  ~b~E~w~  PARA ENTREGAR O VEICULO OU  ~b~G~w~  PARA CLONAR",4,0.5,0.93,0.50,255,255,255,180)
						emservico = false
						 if IsControlJustPressed(0,47) then
							if not vSERVER.validaCarrosClonados(carros[carrinho].model) then 
							   clonado = true							   
							   desmanche = false
						 	   RemoveBlip(blips)
						 	   CriandoBlip(iniciar,3)
							   vSERVER.endEmpJog()
						    end
						 end 
						if IsControlJustPressed(0,38) then							
							local nvehicle = vRP.getNearestVehicle(2)
							RemoveBlip(blips)	
						 	servico = false	
							desmanche = false					 	
							 SetTimeout(10000, function()
								vSERVER.checkPayment()	
								vRP._stopAnim(false)
								DeleteVehicle(nvehicle)
								vSERVER.endEmpJog()
								
							 end)	
						end
				end
			end
		end
		Citizen.Wait(skips)
	end
end)

Citizen.CreateThread(function()	
	while true do
		local skips = 1000
		 if clonado then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(iniciar[3].x,iniciar[3].y,iniciar[3].z)
			local distance = GetDistanceBetweenCoords(iniciar[3].x,iniciar[3].y,cdz,x,y,z,true)
        	if distance <= 10.0 then		    
			skips = 1
			DrawMarker(25,iniciar[3].x,iniciar[3].y,iniciar[3].z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
				if distance <= 2.5 and IsPedInAnyVehicle(ped) then
					    local ped = PlayerPedId()
						drawTxt("PRESSIONE  ~b~E~w~  PARA CLONAR",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then							
							RemoveBlip(blips)	
							vSERVER.insertCloned(carros[carrinho].model)
							clonado = false 
						 	servico = false						 	
							
						end
				end
			end
		end
		Citizen.Wait(skips)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if emservico then
		    drawTxt("PRESSIONE ~g~F7 ~w~PARA FINALIZAR O EMPREGO ILEGAL",4,0.260,0.905,0.5,255,255,255,200)
			if IsControlJustPressed(0,168) then
				emservico = false
				RemoveBlip(blips)
				servico = false
				emservico = false
				desmanche = false
				spawn = false
				processo = false
				blips = false
				clonado = false 
			end
		end
	end
end)
--- sem o tablet 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if npcLocal and not emservico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(iniciar[4].x,iniciar[4].y,iniciar[4].z)
			local distance = GetDistanceBetweenCoords(iniciar[4].x,iniciar[4].y,cdz,x,y,z,true)
        	if distance <= 2.0 then	
		    drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR O EMRPEGO ILEGAL",4,0.260,0.905,0.5,255,255,255,200)
				if IsControlJustPressed(0,38) then
				   vSERVER.iniciaEmpregoInformal()
				   CriandoBlip(iniciar,1)
				   emservico = true
				end
			end
		end
	end
end)

---------------------------------

function spawSuprimento(x,y,z,h) --SPAWNA VEICULO NA COORDENADA By: Muamba#0001

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
--- ze 1
Citizen.CreateThread(function()	
	for k, v in pairs(npc) do 
		RequestModel(v.hashId)
		while not HasModelLoaded(GetHashKey(v.hashId)) do 
		 Wait(100) 
		end
		local americano = CreatePed(4,v.hash,v.x,v.y,v.z-1,149.43,false,true)
		FreezeEntityPosition(americano,true)
		SetEntityInvincible(americano,true)
		SetBlockingOfNonTemporaryEvents(americano,true)
	end
end)
--- ze 2
Citizen.CreateThread(function()	
	if npcLocal then
		for k, v in pairs(npc2) do 
			RequestModel(v.hashId)
			while not HasModelLoaded(GetHashKey(v.hashId)) do 
			Wait(100) 
			end
			local americano = CreatePed(4,v.hash,v.x,v.y,v.z-1,149.43,false,true)
			FreezeEntityPosition(americano,true)
			SetEntityInvincible(americano,true)
			SetBlockingOfNonTemporaryEvents(americano,true)
		end
	end 
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

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Emprego Informal")
	EndTextCommandSetBlipName(blips)
end