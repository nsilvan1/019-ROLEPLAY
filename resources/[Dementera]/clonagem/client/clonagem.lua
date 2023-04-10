local Tunnel = module('vrp', "lib/Tunnel")
local Proxy = module('vrp',"lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vSERVER = Tunnel.getInterface("clonagem_server")
local cFG = module("clonagem", "config")
local blips = false


Citizen.CreateThread(function()
    while true do 
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local bows, cdz = GetGroundZFor_3dCoord(cFG.inicio[1].x, cFG.inicio[1].y, cFG.inicio[1].z)
        local distance = GetDistanceBetweenCoords(cFG.inicio[1].x, cFG.inicio[1].y, cdz, coords.x, coords.y, coords.z)
        if distance <= 10.0 then	
            skips = 1 	    
			DrawMarker(25,cFG.inicio[1].x, cFG.inicio[1].y, cFG.inicio[1].z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
			if distance <= 2  and IsPedInAnyVehicle(ped) then 
				drawTxt("PRESSIONE  ~b~E~w~  PARA SOLICITAR A CLONAGEM ",4,0.5,0.93,0.50,255,255,255,180)
                if IsControlJustPressed(0,38)  then	
					vSERVER.insertSolicitacaoCloned()
                end
            end
        else 
            skips = 1000
        end 
      Citizen.Wait(skips)
    end
end)


function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Clonagem")
	EndTextCommandSetBlipName(blips)
end


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