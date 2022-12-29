local _IsPedInAnyVehicle = false
local lastVehicle = nil
local polmav_hash = GetHashKey("polmav")
local helibpm_hash = GetHashKey("helibpm")
local paramedicoheli_hash = GetHashKey("paramedicoheli")
local helicoter = GetHashKey("helicoter")

AddEventHandler("gameEventTriggered", function(eventName,args) 
	if eventName == "CEventNetworkPlayerEnteredVehicle" then 
		local selectedPed = args[1]
		if args[1] == PlayerId() then 
			_IsPedInAnyVehicle = true 
			vehicle = args[2]

			Drift()
			moto()
			motox()
			REMOVEWEAPON()
			rodarPoliceRadar()
			lugarcar()

		 	if IsVehicleModel(vehicle,polmav_hash) or IsVehicleModel(vehicle,helibpm_hash) or IsVehicleModel(vehicle,paramedicoheli_hash) or IsVehicleModel(vehicle,helicoter) then   
				runHelicam()
			end

			while IsPedInAnyVehicle(PlayerPedId()) do
				Wait(100)
			end
			_IsPedInAnyVehicle = false 
		end
	end
end)

REMOVEWEAPON = function()
	Citizen.CreateThread(function()
		local sleep = 1000
		while _IsPedInAnyVehicle do
			local ped = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(PlayerPedId())
				if GetPedInVehicleSeat(vehicle,-1) == ped then
					sleep = 5
					local speed = GetEntitySpeed(vehicle)*2.236936
					if speed >= 40 then
						
						SetPlayerCanDoDriveBy(PlayerId(),false)
					else
						SetPlayerCanDoDriveBy(PlayerId(),true)
					end
				end
			Citizen.Wait(sleep)
		end
	end)
end

moto = function()
	Citizen.CreateThread(function()
		while _IsPedInAnyVehicle do
			Citizen.Wait(2)
			local veh = GetVehiclePedIsUsing(PlayerPedId())
			if veh ~= 0 then 
				SetPedConfigFlag(PlayerPedId(),35,false) 
			end
		end
	end)
end

motox = function()
	Citizen.CreateThread(function()
		while _IsPedInAnyVehicle do
			local timeDistance = 500
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped)
			if (GetPedInVehicleSeat(vehicle, -1) == ped or GetPedInVehicleSeat(vehicle, 0) == ped) and GetVehicleClass(vehicle) == 8 then
				timeDistance = 4
				DisableControlAction(0, 345, true)
			end
			Citizen.Wait(timeDistance)
		end
	end)
	
end


Drift = function()
	Citizen.CreateThread(function()
		while _IsPedInAnyVehicle do
				local msec    = 100
				local ped = PlayerPedId()
					local vehicle = GetVehiclePedIsIn(PlayerPedId())
						local speed = GetEntitySpeed(vehicle)*2.236936
						if GetPedInVehicleSeat(vehicle,-1) == ped 
							and (GetEntityModel(vehicle) ~= GetHashKey("coach") 
								and GetEntityModel(vehicle) ~= GetHashKey("bus") 
								and GetEntityModel(vehicle) ~= GetHashKey("youga2") 
								and GetEntityModel(vehicle) ~= GetHashKey("ratloader") 
								and GetEntityModel(vehicle) ~= GetHashKey("taxi") 
								and GetEntityModel(vehicle) ~= GetHashKey("boxville4") 
								and GetEntityModel(vehicle) ~= GetHashKey("trash2") 
								and GetEntityModel(vehicle) ~= GetHashKey("tiptruck") 
								and GetEntityModel(vehicle) ~= GetHashKey("rebel") 
								and GetEntityModel(vehicle) ~= GetHashKey("speedo") 
								and GetEntityModel(vehicle) ~= GetHashKey("phantom") 
								and GetEntityModel(vehicle) ~= GetHashKey("packer") 
								and GetEntityModel(vehicle) ~= GetHashKey("paramedicoambu")) then
								if speed <= 100.0 then
								if IsControlPressed(1,21) then
									SetVehicleReduceGrip(vehicle,true)
								else
									SetVehicleReduceGrip(vehicle,false)
								end
							end    
						end
			Wait(msec)
		end
	end)
end


local radar = {
	shown  = false,
	freeze = false,
	info   = "INICIANDO O SISTEMA DO RADAR",
	info2  = "INICIANDO O SISTEMA DO RADAR"
}

rodarPoliceRadar = function()
	Citizen.CreateThread(function()
		while true do
			local msec = 1000
			if _IsPedInAnyVehicle then 
				local ped = PlayerPedId()
			if IsPedInAnyPoliceVehicle(ped) or GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'amg45' or
			                                   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'cls63sp' or 
											   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'maseratinfp' or 
			                                   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'shelby500' or 
			                                   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'pol718' or 
											   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'mbsprinter' or 
			                                   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'VRdm1200' or 
											   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'VRrs6av' or 
											   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'WRclassxv2' or 
											   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'wrafricat' or 
											   GetEntityModel(GetVehiclePedIsIn(ped, false)) == 'risegolf' then
				msec = 5
				if IsControlJustPressed(1,306) then
					if radar.shown then
						radar.shown = false
					else
						radar.shown = true
					end
				end
				
				if IsControlJustPressed(1, 301) then
					if radar.freeze then
						radar.freeze = false
					else
						radar.freeze = true
					end
				end
				
				if radar.shown then
					if radar.freeze == false then
						local coordA        = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.0, 1.0)
						local coordB        = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 105.0, 0.0)
						local frontcar      = StartShapeTestCapsule(coordA, coordB, 3.0, 10, vehicle, 7)
						local _, _, _, _, e = GetShapeTestResult(frontcar)
						
						if IsEntityAVehicle(e) then
							local fmodel  = GetDisplayNameFromVehicleModel(GetEntityModel(e))
							local fvspeed = GetEntitySpeed(e) * 2.236936
							local fplate  = GetVehicleNumberPlateText(e)
							radar.info    = string.format("~y~PLACA: ~w~%s   ~y~MODELO: ~w~%s   ~y~VELOCIDADE: ~w~%s MPH", fplate, fmodel, math.ceil(fvspeed))
						end
						
						local bcoordB       = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -105.0, 0.0)
						local rearcar       = StartShapeTestCapsule(coordA, bcoordB, 3.0, 10, vehicle, 7)
						local _, _, _, _, j = GetShapeTestResult(rearcar)
						
						if IsEntityAVehicle(j) then
							local bmodel  = GetDisplayNameFromVehicleModel(GetEntityModel(j))
							local bvspeed = GetEntitySpeed(j) * 2.236936
							local bplate  = GetVehicleNumberPlateText(j)
							radar.info2   = string.format("~y~PLACA: ~w~%s   ~y~MODELO: ~w~%s   ~y~VELOCIDADE: ~w~%s MPH", bplate, bmodel, math.ceil(bvspeed))
						end
					end
					drawTxt(radar.info, 4, 0.50, 0.83, 0.50, 255, 255, 255, 180)
					drawTxt(radar.info2, 4, 0.50, 0.87, 0.50, 255, 255, 255, 180)
				end
			else 
				break
			end
			else 
				radar.shown = false
				break
			end
			Wait(msec)
		end
	end)
end
function drawTxt(text, font, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for i = 1, 120 do
		EnableDispatchService(i, false)
	end
end)


local fov_max = 80.0
local fov_min = 10.0
local zoomspeed = 2.0
local speed_lr = 3.0
local speed_ud = 3.0
local helicam = false
local fov = (fov_max+fov_min)*0.5

runHelicam = function()
	Citizen.CreateThread(function()
		while _IsPedInAnyVehicle do
			local msec = 1000
			if IsPlayerInPolmav() then
				msec = 5
				local heli = GetVehiclePedIsIn(PlayerPedId())
				SetVehicleRadioEnabled(heli,false)
				if IsHeliHighEnough(heli) then
					if IsControlJustPressed(0,51) then
						PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
						helicam = true
					end
					if IsControlJustPressed(0,154) then
						if GetPedInVehicleSeat(heli,1) == PlayerPedId() or GetPedInVehicleSeat(heli,2) == PlayerPedId() then
							PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
							TaskRappelFromHeli(PlayerPedId(),1)
						end
					end
				end
			end

			if helicam then
				msec = 5
				SetTimecycleModifier("heliGunCam")
				SetTimecycleModifierStrength(0.3)
				local scaleform = RequestScaleformMovie("HELI_CAM")
				while not HasScaleformMovieLoaded(scaleform) do
					Citizen.Wait(10)
				end
				local heli = GetVehiclePedIsIn(PlayerPedId())
				local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA",true)
				AttachCamToEntity(cam,heli,0.0,0.0,-1.5,true)
				SetCamRot(cam,0.0,0.0,GetEntityHeading(heli))
				SetCamFov(cam,fov)
				RenderScriptCams(true, false, 0, 1, 0)
				PushScaleformMovieFunction(scaleform,"SET_CAM_LOGO")
				PushScaleformMovieFunctionParameterInt(0)
				PopScaleformMovieFunctionVoid()
				while helicam and not IsEntityDead(PlayerPedId()) and (GetVehiclePedIsIn(PlayerPedId()) == heli) and IsHeliHighEnough(heli) do
					if IsControlJustPressed(0,51) then
						PlaySoundFrontend(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",false)
						helicam = false
					end

					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam,zoomvalue)
					HandleZoom(cam)
					HideHUDThisFrame()
					PushScaleformMovieFunction(scaleform,"SET_ALT_FOV_HEADING")
					PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
					PushScaleformMovieFunctionParameterFloat(zoomvalue)
					PushScaleformMovieFunctionParameterFloat(GetCamRot(cam,2).z)
					PopScaleformMovieFunctionVoid()
					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					Citizen.Wait(10)
				end
				helicam = false
				ClearTimecycleModifier()
				fov = (fov_max+fov_min)*0.5
				RenderScriptCams(false,false,0,1,0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam,false)
				SetNightvision(false)
				SetSeethrough(false)
			end
			Wait(msec)
		end
	end)
end
function IsPlayerInPolmav()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	return IsVehicleModel(vehicle,polmav_hash) or IsVehicleModel(vehicle,helibpm_hash) or IsVehicleModel(vehicle,paramedicoheli_hash) or IsVehicleModel(vehicle,helicoter)
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 1.5
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
end

function CheckInputRotation(cam,zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0,220)
	local rightAxisY = GetDisabledControlNormal(0,221)
	local rotation = GetCamRot(cam,2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z+rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0,rotation.x+rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)),-89.5)
		SetCamRot(cam,new_x,0.0,new_z,2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(0,241) then
		fov = math.max(fov-zoomspeed,fov_min)
	end
	if IsControlJustPressed(0,242) then
		fov = math.min(fov+zoomspeed,fov_max)
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then
		fov = current_fov
	end
	SetCamFov(cam,current_fov+(fov-current_fov)*0.05)
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0),10,GetVehiclePedIsIn(PlayerPedId()),0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit > 0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num,math.cos(z)*num,math.sin(x))
end


local disableShuffle = true
function disableSeatShuffle(flag)
    disableShuffle = flag
end
function lugarcar()
	Citizen.CreateThread(function()
		local sleep = 1000
		while _IsPedInAnyVehicle do
			if disableShuffle then
				sleep = 5
				if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
					if GetIsTaskActive(GetPlayerPed(-1), 165) then
						SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
					end
				end
			end
			Citizen.Wait(sleep)
		end
	end)
end

function SeatShuffle()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        disableSeatShuffle(false)
        Citizen.Wait(5000)
        disableSeatShuffle(true)
    else
        CancelEvent()
    end
end

lugares = {-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30}

for k,v in pairs(lugares) do
    RegisterCommand("p"..k, function(source, args)
        if vRP.isHandcuffed() then
            return
        end
        local ped = PlayerPedId()
        SetPedConfigFlag(ped, 184, true)
        SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped), v)
		SeatShuffle()
    end)
end