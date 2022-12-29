local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
func = Tunnel.getInterface("vrp_trafico")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local locais = {
-----------------------------------------------------------------------------------------------------------------------------------------
-- [ FARM HOSPITAL ]
-----------------------------------------------------------------------------------------------------------------------------------------
	{ ['id'] = 1, ['x'] = -729.01, ['y'] = 348.88, ['z'] = 83.09, ['text'] = "PRODUZIR PARACETAMIL", ['perm'] = "paramedico.permissao" },
	{ ['id'] = 2, ['x'] = -715.91, ['y'] = 350.18, ['z'] = 83.09, ['text'] = "PRODUZIR VOLTAROM", ['perm'] = "paramedico.permissao" },
	{ ['id'] = 3, ['x'] = -449.65, ['y'] = -325.05, ['z'] = 34.92, ['text'] = "PRODUZIR DORFREX", ['perm'] = "paramedico.permissao" },
	
	{ ['id'] = 4, ['x'] = 1140.06, ['y'] = -1564.98, ['z'] = 35.39, ['text'] = "PRODUZIR PARACETAMIL", ['perm'] = "paramedico.permissao" },
	{ ['id'] = 5, ['x'] = 1140.05, ['y'] = -1565.94, ['z'] = 35.39, ['text'] = "PRODUZIR VOLTAROM", ['perm'] = "paramedico.permissao" },
	{ ['id'] = 6, ['x'] = 1140.08, ['y'] = -1567.09, ['z'] = 35.39, ['text'] = "PRODUZIR DORFREX", ['perm'] = "paramedico.permissao" },
-----------------------------------------------------------------------------------------------------------------------------------------
-- [ FARM BENNYS ]
-----------------------------------------------------------------------------------------------------------------------------------------
	{ ['id'] = 7, ['x'] = 2725.15, ['y'] = 3482.03, ['z'] = 55.71, ['text'] = "PRODUZIR KIT REPAROS", ['perm'] = "mecanico.permissao" },
	{ ['id'] = 8, ['x'] = 2720.93, ['y'] = 3471.7, ['z'] = 55.71, ['text'] = "PRODUZIR KIT REPAROS", ['perm'] = "mecanico.permissao" },
	{ ['id'] = 9, ['x'] = 2719.12, ['y'] = 3467.13, ['z'] = 55.71, ['text'] = "PRODUZIR KIT REPAROS", ['perm'] = "mecanico.permissao" },
}

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		for k,v in pairs(locais) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			if distance <= 2.0 and not processo then
				idle = 5
				draw3DText(v.x, v.y, v.z, "PRESSIONE  ~r~E~w~  PARA "..v.text,4,0.5,0.93,0.50,255,255,255,180)
				if IsControlJustPressed(0,38) and func.checkPermission(v.perm) then
					if func.checkPayment(v.id) then
						TriggerEvent('cancelando',true)
						processo = true
						segundos = 5
					end
				end
			end
		end
		if processo then
			timing = 5
			drawTxtD("AGUARDE ~g~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR O PROCESSO",4,0.5,0.90,0.50,255,255,255,180)
		end
		Citizen.Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTAGEM --
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 then
			segundos = segundos - 1
			if segundos == 0 then
				processo = false
				TriggerEvent('cancelando',false)
				ClearPedTasks(PlayerPedId())
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxtD(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function draw3DText(x,y,z, text)
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
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end