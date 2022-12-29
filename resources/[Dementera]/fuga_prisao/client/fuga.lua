local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local cFG = module("fuga_prisao", "config")
local loc =  math.random(1,11)
local pontos = cFG.pontos
local procurando = false
local preso = false 

vSERVER = Tunnel.getInterface("fuga_presao")

RegisterNUICallback("ButtonClick", function(data, cb)
	if data.action == "fecharFliper" then
        jogando = false 
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'fecharFliper'})
        ClearPedTasks(PlayerPedId())
    end
end)

Citizen.CreateThread(function()	
	while config.posicaoDinamica do
		if not procurando then 
			local skips = 1000
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(cFG.iniciar[loc].x , cFG.iniciar[loc].y, cFG.iniciar[loc].z)
			local distance = GetDistanceBetweenCoords(cFG.iniciar[loc].x, cFG.iniciar[loc].y,cdz,x,y,z,true)
			if distance <= 10.0 then		    
				skips = 1
				DrawMarker(25,cFG.iniciar[loc].x, cFG.iniciar[loc].y, cFG.iniciar[loc].z -0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
					if distance <= 1.8 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA PROCURAR",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38)  then	
							procurando = true
							local source = source
							vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}},true)
							SetTimeout(cFG.tempoAnimacao,function()
								vRP._stopAnim(false)
								if cFG.percent >=  math.random(1,100) then
									vSERVER.itemEncontrado()
								else 
									vSERVER.nadaEncontrado()
								end 
								loc =  math.random(1,11)
								procurando = false
							end)
						end
					end
			end		
		end
		Citizen.Wait(skips)
	end
end)

Citizen.CreateThread(function()	
	while not config.posicaoDinamica do
		if not procurando then
			local skips = 1000
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(cFG.iniciar[loc].x , cFG.iniciar[loc].y, cFG.iniciar[loc].z)
			local distance = GetDistanceBetweenCoords(cFG.iniciar[loc].x, cFG.iniciar[loc].y,cdz,x,y,z,true)
			if distance <= 10.0 then		    
				skips = 1
				DrawMarker(25,cFG.iniciar[loc].x, cFG.iniciar[loc].y, cFG.iniciar[loc].z -0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
					if distance <= 1.8 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA PROCURAR",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38)  then	
							procurando = true
							local source = source
							vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}},true)
							SetTimeout(cFG.tempoAnimacao,function()
								vRP._stopAnim(false)
								if cFG.percent >=  math.random(1,100) then
									vSERVER.itemEncontrado()
								else 
									vSERVER.nadaEncontrado()
								end 
								loc =  math.random(1,11)
								procurando = false
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
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local bowz,cdz = GetGroundZFor_3dCoord(cFG.fuga[1].x , cFG.fuga[1].y, cFG.fuga[1].z)
		local distance = GetDistanceBetweenCoords(cFG.fuga[1].x, cFG.fuga[1].y,cdz,x,y,z,true)
		if distance <= 10.0 then		    
			skips = 1
			DrawMarker(25,cFG.fuga[1].x, cFG.fuga[1].y, cFG.fuga[1].z -0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
			if distance <= 1.8 then
				drawTxt("PRESSIONE  ~b~E~w~  PARA FUGIR",4,0.5,0.93,0.50,255,255,255,180)
				if IsControlJustPressed(0,38) and vSERVER.validaItem()  then	
					local source = source
					vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}},true)
					SetNuiFocus(true,true)
					SendNUIMessage({action = "abrindo"})
				end
			end
		end
		Citizen.Wait(skips)
	end
end)

RegisterNUICallback("ButtonClick", function( data, res) 
	if data.action == "quebrou" then 
	  SetNuiFocus(false,false)
	  ClearPedTasks( PlayerPedId());
	end 
 end)
   
 RegisterNUICallback("succeed", function( data, res) 
	SetNuiFocus(false,false)
	local source = source
	vRP._stopAnim(false)
	vSERVER.fuga()
 end)
   
 RegisterNUICallback("failed", function( data, res) 
	SetNuiFocus(false,false)
	local source = source
	vRP._stopAnim(false)
	vSERVER.presoTravado()
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
