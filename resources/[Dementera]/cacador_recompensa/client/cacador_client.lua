local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vSERVER = Tunnel.getInterface("cacador_recompensa")

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
        open = false
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'fecharCaca'})
        ClearPedTasks(PlayerPedId())
    end
end)

Citizen.CreateThread(function()	
	while true do
		local skips = 1000
		if not servico and not desmanche then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(-125.95, -641.45, 168.85)
			local distance = GetDistanceBetweenCoords(-125.95, -641.45,cdz,x,y,z,true)
        	if distance <= 10.0 then		    
			skips = 1
			DrawMarker(25,-125.95, -641.45, 168.85 -0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
				if distance <= 1.8 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA VERIFICAR OS PRODURADOS",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and vSERVER.ValidationUser()  then	
                        open = true
                        SetNuiFocus(true,true)
                        SendNUIMessage({ action = "cacador" })
					end
				end
			end
		end
		Citizen.Wait(skips)
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


RegisterNUICallback("insertRecompensa",function(data,cb)
		vSERVER.insertRecompensa(data.user_id, data.recompensa)
	
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