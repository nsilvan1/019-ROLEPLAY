local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

Klaus = {}
Tunnel.bindInterface("FD_login", Klaus)
vSERVER = Tunnel.getInterface("FD_login")

local cupom = "Bagunca | 20%OFF"
local site = "store.cidadenexus.com"
local qrcode = "https://cdn.discordapp.com/attachments/818021764856545280/1016936728268898304/nexusrp.png"


local cam = nil

function f(n)
	n = n + 0.00000
	return n
end

function setCamHeight(height)
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,f(height)))
end

local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	local bank, money ,name = vSERVER.login()
	local tempoOnline = LocalPlayer.state.onlineTime or 0
	local bank = bank or 0
	local palyer = money or 0
	local namep = name or "ID"

	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true, tempoOnline = tempoOnline, bank = bank, palyer = palyer, cupom = cupom, site = site, qrcode = qrcode,namep = namep})
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })

		local pos = GetEntityCoords(PlayerPedId())

		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
				
		SetCamCoord(cam,vector3(pos.x,pos.y,f(1000)))
		SetCamRot(cam,-f(90),f(0),f(0),2)
		SetCamActive(cam,true)
		StopCamPointing(cam)
		RenderScriptCams(true,true,0,0,0,0)
	
		local altura = 1000
		while altura > 50 do
			if altura <= 300 then
				altura = altura - 6
			elseif altura >= 301 and altura <= 700 then
				altura = altura - 4
			else
				altura = altura - 2
			end
	
			setCamHeight(altura)
			Citizen.Wait(10)
		end
		
		DestroyCam(cam, true)
	
		SetEntityInvincible(PlayerPedId(),false)
		SetEntityVisible(PlayerPedId(),true)
		FreezeEntityPosition(PlayerPedId(),false)
	
		SetCamActive(cam,false)
		StopCamPointing(cam)
		RenderScriptCams(0,0,0,0,0,0)
		SetFocusEntity(PlayerPedId())
	end
end

RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "garagem01" then
		SetEntityCoords(PlayerPedId(),-302.59,-884.39,31.09,1,0,0,1)
	elseif data == "garagem02" then
		SetEntityCoords(PlayerPedId(),318.82,2622.06,44.47,1,0,0,1)
	elseif data == "garagem03" then
		SetEntityCoords(PlayerPedId(),-772.81,5596.25,33.48,1,0,0,1)
	elseif data == "hospital01" then
		SetEntityCoords(PlayerPedId(),1148.39,-1517.37,34.85,1,0,0,1)
	elseif data == "metro" then
		SetEntityCoords(PlayerPedId(),-206.11,-1013.50,30.13,1,0,0,1)
	elseif data == "aeroporto" then
		SetEntityCoords(PlayerPedId(),-1027.65,-2493.39,13.85,1,0,0,1)
	elseif data == "hospitaln" then
		SetEntityCoords(PlayerPedId(),-665.55,306.78,83.09,1,0,0,1)
	elseif data == "localiza" then
	end
	ToggleActionMenu()
end)

RegisterNetEvent('vrp:ToogleLoginMenu')
AddEventHandler('vrp:ToogleLoginMenu',function()

	SetEntityInvincible(PlayerPedId(),false)
	SetEntityVisible(PlayerPedId(),false)
	FreezeEntityPosition(PlayerPedId(),true)
	SetPedDiesInWater(PlayerPedId(),false)

	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
		
		local pos = GetEntityCoords(PlayerPedId())
		SetCamCoord(cam,vector3(pos.x,pos.y,f(1000)))
		SetCamRot(cam,-f(90),f(0),f(0),2)
		SetCamActive(cam,true)
		StopCamPointing(cam)
		RenderScriptCams(true,true,0,0,0,0)
	end
	
	ToggleActionMenu()
end)

