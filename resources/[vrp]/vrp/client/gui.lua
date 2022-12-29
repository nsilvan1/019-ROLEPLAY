local menu_state = {}

function tvRP.openMenuData(menudata)
	SendNUIMessage({ act = "open_menu", menudata = menudata })
end

function tvRP.closeMenu()
	SendNUIMessage({ act = "close_menu" })
end

function tvRP.getMenuState()
	return menu_state
end


local menu_celular = false
RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	menu_celular = status
	if not IsPedInAnyVehicle(PlayerPedId()) then
		DisplayRadar(true)
	end
end)

local hacker_digital = false
RegisterNetEvent("status:hacker_digital")
AddEventHandler("status:hacker_digital",function(status2)
	hacker_digital = status2
end)

local agachar = false
function tvRP.getAgachar()
    return agachar
end

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if menu_celular then
			idle = 5
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,16,true)
			DisableControlAction(0,17,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,29,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,170,true)				
			DisableControlAction(0,182,true)	
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,245,true)
			--DisableControlAction(0,249,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,344,true)			
		end
		Citizen.Wait(idle)
	end
end)

function tvRP.prompt(title,default_text)
	SendNUIMessage({ act = "prompt", title = title, text = tostring(default_text) })
	SetNuiFocus(true)
end

function tvRP.request(id,text,time)
	SendNUIMessage({ act = "request", id = id, text = tostring(text), time = time })
end

RegisterNUICallback("menu",function(data,cb)
	if data.act == "close" then
		vRPserver._closeMenu(data.id)
	elseif data.act == "valid" then
		vRPserver._validMenuChoice(data.id,data.choice,data.mod)
	end
end)

RegisterNUICallback("menu_state",function(data,cb)
	menu_state = data
end)

RegisterNUICallback("prompt",function(data,cb)
	if data.act == "close" then
		SetNuiFocus(false)
		vRPserver._promptResult(data.result)
	end
end)

RegisterNUICallback("request",function(data,cb)
	if data.act == "response" then
		vRPserver._requestResult(data.id,data.ok)
	end
end)

RegisterNUICallback("init",function(data,cb)
	SendNUIMessage({ act = "cfg", cfg = {} })
	TriggerEvent("vRP:NUIready")
end)

function tvRP.setDiv(name,css,content)
	SendNUIMessage({ act = "set_div", name = name, css = css, content = content })
end

function tvRP.setDivContent(name,content)
	SendNUIMessage({ act = "set_div_content", name = name, content = content })
end

function tvRP.removeDiv(name)
	SendNUIMessage({ act = "remove_div", name = name })
end

local apontar = false
local object = nil

function tvRP.loadAnimSet(dict)
	RequestAnimSet(dict)
	while not HasAnimSetLoaded(dict) do
		Citizen.Wait(10)
	end
	SetPedMovementClipset(PlayerPedId(),dict,0.25)
end

function tvRP.CarregarAnim(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

function tvRP.CarregarObjeto(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
	local ped = PlayerPedId()

	RequestModel(GetHashKey(prop))
	while not HasModelLoaded(GetHashKey(prop)) do
		Citizen.Wait(10)
	end

	if pos1 then
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),pos1,pos2,pos3,pos4,pos5,pos6,true,true,true,true,1,true)
	else
		tvRP.CarregarAnim(dict)
		TaskPlayAnim(ped,dict,anim,3.0,3.0,-1,flag,0,0,0,0)
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),0.0,0.0,0.0,0.0,0.0,0.0,false,false,true,false,2,true)
	end
	Citizen.InvokeNative(0xAD738C3085FE7E11,object,true,true)
end

function tvRP.DeletarObjeto()
    tvRP.stopAnim(true)
    TriggerEvent("binoculos")
    if DoesEntityExist(object) then
        TriggerServerEvent("trydeleteobj",ObjToNet(object))
        object = nil
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COOLDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
local cooldown = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(1)
-- 		local ped = PlayerPedId()

-- 		if menu_state.opened then
-- 			DisableControlAction(0,75)
-- 		end

-- 		if IsControlJustPressed(0,172) then SendNUIMessage({ act = "event", event = "UP" }) if menu_state.opened then tvRP.playSound("NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET") end end
-- 		if IsControlJustPressed(0,173) then SendNUIMessage({ act = "event", event = "DOWN" }) if menu_state.opened then tvRP.playSound("NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET") end end
-- 		if IsControlJustPressed(0,174) then SendNUIMessage({ act = "event", event = "LEFT" }) if menu_state.opened then tvRP.playSound("NAV_LEFT_RIGHT","HUD_FRONTEND_DEFAULT_SOUNDSET") end end
-- 		if IsControlJustPressed(0,175) then SendNUIMessage({ act = "event", event = "RIGHT" }) if menu_state.opened then tvRP.playSound("NAV_LEFT_RIGHT","HUD_FRONTEND_DEFAULT_SOUNDSET") end end
-- 		if IsControlJustPressed(0,176) then SendNUIMessage({ act = "event", event = "SELECT" }) if menu_state.opened then tvRP.playSound("SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET") end end
-- 		if IsControlJustPressed(0,177) then SendNUIMessage({ act = "event", event = "CANCEL" }) end
-- 		if IsControlJustPressed(0,246) then SendNUIMessage({ act = "event", event = "Y" }) end
-- 		if IsControlJustPressed(0,303) then SendNUIMessage({ act = "event", event = "U" }) end

-- 		-- CRUZAR O BRACO (F1)
-- 		if IsControlJustPressed(0,288) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				if IsEntityPlayingAnim(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss",3) then
-- 					tvRP.DeletarObjeto()
-- 				else
-- 					tvRP.playAnim(true,{{"anim@heists@heist_corona@single_team","single_team_loop_boss"}},true)
-- 				end
--         	end
-- 		end

-- 		-- AGUARDAR (F2)
-- 		if IsControlJustPressed(0,289) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				if IsEntityPlayingAnim(ped,"mini@strip_club@idles@bouncer@base","base",3) then
-- 					tvRP.DeletarObjeto()
-- 				else
-- 					tvRP.playAnim(true,{{"mini@strip_club@idles@bouncer@base","base"}},true)
-- 				end
--         	end
-- 		end

-- 		-- DEDO DO MEIO (F3)
-- 		if IsControlJustPressed(0,170) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				if IsEntityPlayingAnim(ped,"anim@mp_player_intupperfinger","idle_a_fp",3) then
-- 					tvRP.DeletarObjeto()
-- 				else
-- 					tvRP.playAnim(true,{{"anim@mp_player_intupperfinger","idle_a_fp"}},true)
-- 				end
--         	end
-- 		end

-- 		-- PUTO (F5)
-- 		if IsControlJustPressed(0,166) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				tvRP.playAnim(true,{{"misscarsteal4@actor","actor_berating_loop"}},false)
--         	end
-- 		end

-- 		-- PARA TODAS AS ANIMAÇÕES (F6)
-- 		if IsControlJustPressed(0,167) then
-- 			if cooldown < 1 then
-- 				cooldown = 8
-- 				if GetEntityHealth(ped) > 101 then
-- 					if not menu_state.opened then
-- 						tvRP.DeletarObjeto()
-- 						ClearPedTasks(ped)
-- 					end
-- 				end
-- 			end
-- 		end

-- 		-- MÃOS NA CABEÇA (F10)
-- 		if IsControlJustPressed(0,57) then
-- 			if GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				if IsEntityPlayingAnim(ped,"random@arrests@busted","idle_a",3) then
-- 					tvRP.DeletarObjeto()
-- 				else
-- 					tvRP.DeletarObjeto()
-- 					tvRP.playAnim(true,{{"random@arrests@busted","idle_a"}},true)
-- 				end
--         	end
-- 		end

-- 		-- BLZ (DEL)
-- 		if IsControlJustPressed(0,178) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				tvRP.playAnim(true,{{"anim@mp_player_intincarthumbs_upbodhi@ps@","enter"}},false)
--         	end
-- 		end

-- 		-- ASSOBIAR (ARROW DOWN)
-- 		if IsControlJustPressed(0,187) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				tvRP.playAnim(true,{{"rcmnigel1c","hailing_whistle_waive_a"}},false)
--         	end
-- 		end

-- 		-- JOIA (ARROW LEFT)
-- 		if IsControlJustPressed(0,189) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				tvRP.playAnim(true,{{"anim@mp_player_intupperthumbs_up","enter"}},false)
--         	end
-- 		end

-- 		-- FACEPALM (ARROW RIGHT)
-- 		if IsControlJustPressed(0,190) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				tvRP.playAnim(true,{{"anim@mp_player_intcelebrationmale@face_palm","face_palm"}},false)
--         	end
-- 		end

-- 		-- SAUDACAO (ARROW UP)
-- 		if IsControlJustPressed(0,188) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				tvRP.playAnim(true,{{"anim@mp_player_intcelebrationmale@salute","salute"}},false)
--         	end
-- 		end

-- 		-- LEVANTAR A MAO (X)
-- 		if IsControlJustPressed(0,73) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_celular then
-- 				--SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
-- 				if IsEntityPlayingAnim(ped,"random@mugging3","handsup_standing_base",3) then
-- 					tvRP.DeletarObjeto()
-- 				else
-- 					tvRP.playAnim(true,{{"random@mugging3","handsup_standing_base"}},true)
-- 				end
--         	end
-- 		end

		-- -- LIGAR O MOTOR (Z)
		-- if IsControlJustPressed(0,20) then
		-- 	if IsPedInAnyVehicle(ped) then
		-- 		local vehicle = GetVehiclePedIsIn(ped,false)
		-- 		if GetPedInVehicleSeat(vehicle,-1) == ped then
		-- 			tvRP.DeletarObjeto()
		-- 			local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle)
		-- 			SetVehicleEngineOn(vehicle,not running,true,true)
		-- 			if running then
		-- 				SetVehicleUndriveable(vehicle,true)
		-- 			else
		-- 				SetVehicleUndriveable(vehicle,false)
		-- 			end
		-- 		end
		-- 	end
		-- end

-- 		-- APONTAR O DEDO (B)
-- 		if IsControlJustPressed(0,29) then
-- 			if GetEntityHealth(ped) > 101 and not menu_celular then
-- 				tvRP.CarregarAnim("anim@mp_point")
-- 				if not apontar then
-- 					SetPedCurrentWeaponVisible(ped,0,1,1,1)
-- 					SetPedConfigFlag(ped,36,1)
-- 					Citizen.InvokeNative(0x2D537BA194896636,ped,"task_mp_pointing",0.5,0,"anim@mp_point",24)
--                 	apontar = true
--             	else
--             		Citizen.InvokeNative(0xD01015C7316AE176,ped,"Stop")
-- 					if not IsPedInjured(ped) then
-- 						ClearPedSecondaryTask(ped)
-- 					end
-- 					if not IsPedInAnyVehicle(ped) then
-- 						SetPedCurrentWeaponVisible(ped,1,1,1,1)
-- 					end
-- 					SetPedConfigFlag(ped,36,0)
-- 					ClearPedSecondaryTask(ped)
--                 	apontar = false
--             	end
--         	end
---		end
-- 	end
-- end)

RegisterCommand("zkeybind:menu:up",function(source,args)
	SendNUIMessage({ act = "event", event = "UP" })
	if menu_state.opened then
		tvRP.playSound("NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET") 
	end 
end)
RegisterCommand("zkeybind:menu:down",function(source,args)
	SendNUIMessage({ act = "event", event = "DOWN" })
	if menu_state.opened then
		tvRP.playSound("NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET")
	end 
end)
RegisterCommand("zkeybind:menu:left",function(source,args)
	SendNUIMessage({ act = "event", event = "LEFT" })
	if menu_state.opened then
		tvRP.playSound("NAV_LEFT_RIGHT","HUD_FRONTEND_DEFAULT_SOUNDSET")
	end 
end)
RegisterCommand("zkeybind:menu:right",function(source,args)
	SendNUIMessage({ act = "event", event = "RIGHT" })
	if menu_state.opened then
		tvRP.playSound("NAV_LEFT_RIGHT","HUD_FRONTEND_DEFAULT_SOUNDSET")
	end 
end)
RegisterCommand("zkeybind:menu:confirm",function(source,args)
	SendNUIMessage({ act = "event", event = "SELECT" })
	if menu_state.opened then
		tvRP.playSound("SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET")
	end 
end)
RegisterCommand("zkeybind:menu:cancel",function(source,args)
	SendNUIMessage({ act = "event", event = "CANCEL" })
end)
RegisterCommand("zkeybind:request:yes",function(source,args)
	SendNUIMessage({ act = "event", event = "Y" })
end)
RegisterCommand("zkeybind:request:no",function(source,args)
	SendNUIMessage({ act = "event", event = "U" })
end)
-- [F1] Cross arms
RegisterCommand("zkeybind:crossArms",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			if IsEntityPlayingAnim(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss",3) then
				tvRP.DeletarObjeto()
			else
				tvRP.playAnim(true,{{"anim@heists@heist_corona@single_team","single_team_loop_boss"}},true)
			end
		end
	end
end)
-- [F2] Wait Position
RegisterCommand("zkeybind:waitPosition",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			if IsEntityPlayingAnim(ped,"mini@strip_club@idles@bouncer@base","base",3) then
				tvRP.DeletarObjeto()
			else
				tvRP.playAnim(true,{{"mini@strip_club@idles@bouncer@base","base"}},true)
			end
		end
	end
end)
-- [F3] Middle Finger
RegisterCommand("zkeybind:middleFinger",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			if IsEntityPlayingAnim(ped,"anim@mp_player_intupperfinger","idle_a_fp",3) then
				tvRP.DeletarObjeto()
			else
				tvRP.playAnim(true,{{"anim@mp_player_intupperfinger","idle_a_fp"}},true)
			end
		end
	end
end)
-- [F5] Middle Finger
RegisterCommand("zkeybind:pissedOff",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			if IsEntityPlayingAnim(ped,"misscarsteal4@actor","actor_berating_loop",3) then
				tvRP.DeletarObjeto()
			else
				tvRP.playAnim(true,{{"misscarsteal4@actor","actor_berating_loop"}},true)
			end
		end
	end
end)

-- 	PUTO (F5)
-- 		if IsControlJustPressed(0,166) then
-- 			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
-- 				tvRP.playAnim(true,{{"misscarsteal4@actor","actor_berating_loop"}},false)
--         	end
-- 		end
-- -- CreateThread(function()
-- 	while true do
-- 		Wait(5)
-- 		local ped = PlayerPedId()
-- 		if IsControlJustPressed(0,167) then
-- 			if cooldown < 1 then
-- 				cooldown = 10
-- 				if GetEntityHealth(ped) > 101 then
-- 					if not menu_state.opened then
-- 						tvRP.DeletarObjeto()
-- 						ClearPedTasks(ped)
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end)

RegisterCommand("keybindCancel", function()
	local ped = PlayerPedId()	
		if cooldown < 1 then
				cooldown = 10
			if GetEntityHealth(ped) > 101 and not menu_celular then
				if not menu_state.opened then
				tvRP.DeletarObjeto()
				ClearPedTasks(ped)
				end
			end
		end
end)

-- [F10] Hands behind head
RegisterCommand("zkeybind:handsHead",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			if IsEntityPlayingAnim(ped,"random@arrests@busted","idle_a",3) then
				tvRP.DeletarObjeto()
			else
				tvRP.DeletarObjeto()
				tvRP.playAnim(true,{{"random@arrests@busted","idle_a"}},true)
			end
		end
	end
end)
-- [DEL] Ok
RegisterCommand("zkeybind:okayAnim",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			tvRP.playAnim(true,{{"anim@mp_player_intincarthumbs_upbodhi@ps@","enter"}},false)
		end
	end
end)
-- [DOWN] Whistle
RegisterCommand("zkeybind:whistle",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			tvRP.playAnim(true,{{"rcmnigel1c","hailing_whistle_waive_a"}},false)
		end
	end
end)
-- [LEFT] Ok part2
RegisterCommand("zkeybind:okay2Anim",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			tvRP.playAnim(true,{{"anim@mp_player_intupperthumbs_up","enter"}},false)
		end
	end
end)
-- [RIGHT] Facepalm
RegisterCommand("zkeybind:facepalm",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			tvRP.playAnim(true,{{"anim@mp_player_intcelebrationmale@face_palm","face_palm"}},false)
		end
	end
end)
-- [UP] Salute
RegisterCommand("zkeybind:salute",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular then
			tvRP.playAnim(true,{{"anim@mp_player_intcelebrationmale@salute","salute"}},false)
		end
	end
end)
-- [X] Hands up
RegisterCommand("zkeybind:handsUp",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_celular then
			--SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
			if IsEntityPlayingAnim(ped,"random@mugging3","handsup_standing_base",3) then
				tvRP.DeletarObjeto()
			else
				tvRP.playAnim(true,{{"random@mugging3","handsup_standing_base"}},true)
			end
		end
	end
end)

-- [Z] Turn vehicle on
RegisterCommand("zkeybind:turnOnVeh",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped,false)
			if GetPedInVehicleSeat(vehicle,-1) == ped then
				tvRP.DeletarObjeto()
				local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle)
				SetVehicleEngineOn(vehicle,not running,true,true)
				if running then
					SetVehicleUndriveable(vehicle,true)
				else
					SetVehicleUndriveable(vehicle,false)
				end
			end
		end
	end
end)

-- [B] Point finger
RegisterCommand("zkeybind:pointFinger",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 and not menu_celular then
			tvRP.CarregarAnim("anim@mp_point")
			if not apontar then
				SetPedCurrentWeaponVisible(ped,0,1,1,1)
				SetPedConfigFlag(ped,36,1)
				Citizen.InvokeNative(0x2D537BA194896636,ped,"task_mp_pointing",0.5,0,"anim@mp_point",24)
				apontar = true
			else
				Citizen.InvokeNative(0xD01015C7316AE176,ped,"Stop")
				if not IsPedInjured(ped) then
					ClearPedSecondaryTask(ped)
				end
				if not IsPedInAnyVehicle(ped) then
					SetPedCurrentWeaponVisible(ped,1,1,1,1)
				end
				SetPedConfigFlag(ped,36,0)
				ClearPedSecondaryTask(ped)
				apontar = false
			end
		end
	end
end)

--- Actions and animations
RegisterKeyMapping("keybindCancel","Cancelar animações","keyboard","f6")

RegisterKeyMapping("zkeybind:pointFinger","Ação: Apontar dedo","keyboard","b")
-- RegisterKeyMapping("zkeybind:turnOnVeh","Ação: Ligar veículo","keyboard","z")
RegisterKeyMapping("zkeybind:handsUp","Ação: Mãos pra cima","keyboard","x")
RegisterKeyMapping("zkeybind:salute","Animação: Saudação","keyboard","up")
RegisterKeyMapping("zkeybind:facepalm","Animação: Vergonha","keyboard","right")
RegisterKeyMapping("zkeybind:okay2Anim","Animação: Okay","keyboard","left")
RegisterKeyMapping("zkeybind:whistle","Animação: Assobiar","keyboard","down")
RegisterKeyMapping("zkeybind:okayAnim","Animação: Joia","keyboard","delete")
RegisterKeyMapping("zkeybind:handsHead","Ação: Mãos na cabeça","keyboard","f10")
RegisterKeyMapping("zkeybind:pissedOff","Animação: Indignado","keyboard","f5")
RegisterKeyMapping("zkeybind:middleFinger","Animação: Dedos do meio","keyboard","f3")
RegisterKeyMapping("zkeybind:waitPosition","Animação: Esperar","keyboard","f2")
RegisterKeyMapping("zkeybind:crossArms","Animação: Cruzar braços","keyboard","f1")
-- Native vRP menu
RegisterKeyMapping("zkeybind:menu:up","Menu: Opção acima","keyboard","up")
RegisterKeyMapping("zkeybind:menu:down","Menu: Opção abaixo","keyboard","down")
RegisterKeyMapping("zkeybind:menu:left","Menu: Esquerda","keyboard","left")
RegisterKeyMapping("zkeybind:menu:right","Menu: Direita","keyboard","right")
RegisterKeyMapping("zkeybind:menu:confirm","Menu: Confirmar","keyboard","return")
RegisterKeyMapping("zkeybind:menu:cancel","Menu: Cancelar","keyboard","back")
-- Native vRP request
RegisterKeyMapping("zkeybind:request:yes","Requisição: Confirmar","keyboard","y")
RegisterKeyMapping("zkeybind:request:no","Requisição: Negar","keyboard","u")

local anims = {
	{ dict = "random@mugging3","handsup_standing_base", anim = "handsup_standing_base" },
	{ dict = "random@arrests@busted", anim = "idle_a" },
	{ dict = "anim@heists@heist_corona@single_team", anim = "single_team_loop_boss" },
	{ dict = "mini@strip_club@idles@bouncer@base", anim = "base" },
	{ dict = "anim@mp_player_intupperfinger", anim = "idle_a_fp" },
	{ dict = "random@arrests", anim = "generic_radio_enter" },
	{ dict = "mp_player_int_upperpeace_sign", anim = "mp_player_int_peace_sign" }
}

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		for _,block in pairs(anims) do
			if IsEntityPlayingAnim(PlayerPedId(),block.dict,block.anim,3) or object then
				idle = 5
			    BlockWeaponWheelThisFrame()
				DisableControlAction(0,16,true)
				DisableControlAction(0,17,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,137,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
			end
		end
		Citizen.Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIM ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}
Config.WeaponList = {
	--ARMAS DE MAO
	"WEAPON_KNIFE",
	"WEAPON_DAGGER",
	"WEAPON_MACHETE",
	"WEAPON_SWITCHBLADE",
	"WEAPON_WRENCH",
	"WEAPON_HAMMER",
	"WEAPON_GOLFCLUB",
	"WEAPON_CROWBAR",
	"WEAPON_HATCHET",
	"WEAPON_BAT",
	"WEAPON_BOTTLE",
	"WEAPON_BATTLEAXE",
	"WEAPON_POOLCUE",
	"WEAPON_STONE_HATCHET",

	--ARMAS DE FOGO(PISTOLA)
	"WEAPON_COMBATPISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_REVOLVER",
	"WEAPON_PISTOL",
	"WEAPON_SNSPISTOL",
	"WEAPON_RAYPISTOL",

	--ARMAS DE FOGO(SUB)
	"WEAPON_SMG",
	"WEAPON_MACHINEPISTOL",

	--ARMAS DE FOGO(FUZIL)
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_CARBINERIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_HEAVYSNIPER_MK2",
}

local LastWeapon = nil
local block = false
Citizen.CreateThread(function()
	local time = 500
	while true do
		
		local ped = PlayerPedId()
		if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped) then
			for i=1,#Config.WeaponList do
				time = 200
				tvRP.CarregarAnim("reaction@intimidation@1h")
				if not holstered and LastWeapon ~= nil and LastWeapon ~= GetHashKey(Config.WeaponList[i]) and GetSelectedPedWeapon(ped) == GetHashKey(Config.WeaponList[i]) then
					
					block = true
					SetCurrentPedWeapon(ped,-1569615261,true)
					TaskPlayAnim(ped,"reaction@intimidation@1h","intro",8.0,8.0,-1,48,10,0,0,0)

					Citizen.Wait(1200)
					SetCurrentPedWeapon(ped,GetHashKey(Config.WeaponList[i]),true)
					Citizen.Wait(1300)
					ClearPedTasks(ped)
					holstered = true
					block = false
				end

				if holstered and LastWeapon ~= nil and LastWeapon == GetHashKey(Config.WeaponList[i]) and GetSelectedPedWeapon(ped) == -1569615261 then
					block = true
					SetCurrentPedWeapon(ped,GetHashKey(Config.WeaponList[i]),true)
					TaskPlayAnim(ped,"reaction@intimidation@1h","outro",8.0,8.0,-1,48,10,0,0,0)

					Citizen.Wait(1400)
					SetCurrentPedWeapon(ped,-1569615261,true)
					Citizen.Wait(600)
					ClearPedTasks(ped)
					holstered = false
					block = false
				end
			end
			LastWeapon = GetSelectedPedWeapon(ped)
		end
		Citizen.Wait(time)
	end
end)

Citizen.CreateThread(function()
	while true do
		sleep = 1000
		if block then
			sleep = 5
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,25,true)
		end
		Citizen.Wait(sleep)
	end
end)


-- local holster = false

-- local weapons = {
-- 	"WEAPON_KNIFE",
-- 	"WEAPON_HATCHET",
-- 	"WEAPON_PISTOL",
-- 	"WEAPON_PISTOL50",
-- 	"WEAPON_REVOLVER",
-- 	"WEAPON_COMBATPISTOL",
-- 	"WEAPON_FLASHLIGHT",
-- 	"WEAPON_NIGHTSTICK",
-- 	"WEAPON_STUNGUN",
-- 	"WEAPON_COMPACTRIFLE",
-- 	"WEAPON_APPISTOL",
-- 	"WEAPON_HEAVYPISTOL",
-- 	"WEAPON_MACHINEPISTOL",
-- 	"WEAPON_SMG_MK2",
-- 	"WEAPON_MICROSMG",
-- 	"WEAPON_MINISMG",
-- 	"WEAPON_SNSPISTOL",
-- 	"WEAPON_SNSPISTOL_MK2",
-- 	"WEAPON_VINTAGEPISTOL",
-- 	"WEAPON_CARBINERIFLE",
-- 	"WEAPON_SMG",
-- 	"WEAPON_PUMPSHOTGUN",
-- 	"WEAPON_PUMPSHOTGUN_MK2",
-- 	"WEAPON_ASSAULTRIFLE",
-- 	"WEAPON_ASSAULTRIFLE_MK2",
-- 	"WEAPON_SPECIALCARBINE_MK2",
-- 	"WEAPON_MILITARYRIFLE",
-- 	"WEAPON_ASSAULTSMG",
-- 	"WEAPON_GUSENBERG",
-- 	"WEAPON_REVOLVER_MK2",
-- 	"WEAPON_PISTOL_MK2",
-- 	"WEAPON_MACHINEPISTOL"
-- }

-- Citizen.CreateThread(function()
-- 	while true do
-- 		local timeDistance = 100
-- 		local ped = PlayerPedId()
-- 		if DoesEntityExist(ped) and GetEntityHealth(ped) > 101 and not IsPedInAnyVehicle(ped) then
-- 			if CheckWeapon(ped) then
-- 				if not holster then
-- 					timeDistance = 4
-- 					if not IsEntityPlayingAnim(ped,"amb@world_human_sunbathe@female@back@idle_a","idle_a",3) then
-- 						loadAnimDict("rcmjosh4")
-- 						TaskPlayAnim(ped,"rcmjosh4","josh_leadout_cop2",3.0,2.0,-1,48,10,0,0,0)
-- 						Citizen.Wait(450)
-- 						ClearPedTasks(ped)
-- 					end
-- 					holster = true
-- 				end
-- 			elseif not CheckWeapon(ped) then
-- 				if holster then
-- 					timeDistance = 4
-- 					if not IsEntityPlayingAnim(ped,"amb@world_human_sunbathe@female@back@idle_a","idle_a",3) then
-- 						loadAnimDict("weapons@pistol@")
-- 						TaskPlayAnim(ped,"weapons@pistol@","aim_2_holster",3.0,2.0,-1,48,10,0,0,0)
-- 						Citizen.Wait(450)
-- 						ClearPedTasks(ped)
-- 					end
-- 					holster = false
-- 				end
-- 			end
-- 		end

-- 		if GetEntityHealth(ped) <= 101 and holster then
-- 			holster = false
-- 			SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
-- 		end
-- 		Citizen.Wait(timeDistance)
-- 	end
-- end)

function CheckWeapon(ped)
	for i = 1,#weapons do
		if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(10)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO DO APONTAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local time = 250
		local ped = PlayerPedId()
		if apontar then
			time = 4
			local camPitch = GetGameplayCamRelativePitch()
			if camPitch < -70.0 then
				camPitch = -70.0
			elseif camPitch > 42.0 then
				camPitch = 42.0
			end
			camPitch = (camPitch + 70.0) / 112.0

			local camHeading = GetGameplayCamRelativeHeading()
			local cosCamHeading = Cos(camHeading)
			local sinCamHeading = Sin(camHeading)
			if camHeading < -180.0 then
				camHeading = -180.0
			elseif camHeading > 180.0 then
				camHeading = 180.0
			end
			camHeading = (camHeading + 180.0) / 360.0

			local blocked = 0
			local nn = 0
			local coords = GetOffsetFromEntityInWorldCoords(ped,(cosCamHeading*-0.2)-(sinCamHeading*(0.4*camHeading+0.3)),(sinCamHeading*-0.2)+(cosCamHeading*(0.4*camHeading+0.3)),0.6)
			local ray = Cast_3dRayPointToPoint(coords.x,coords.y,coords.z-0.2,coords.x,coords.y,coords.z+0.2,0.4,95,ped,7);
			nn,blocked,coords,coords = GetRaycastResult(ray)

			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Pitch",camPitch)
			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Heading",camHeading*-1.0+1.0)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isBlocked",blocked)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isFirstPerson",Citizen.InvokeNative(0xEE778F8C7E1142E2,Citizen.InvokeNative(0x19CAFA3C87F7C2FF))==4)
		end
		Citizen.Wait(time)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCCLEAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncclean")
AddEventHandler("syncclean",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleDirtLevel(v,0.0)
				SetVehicleUndriveable(v,false)
				tvRP.DeletarObjeto()
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDELETEPED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncdeleteped")
AddEventHandler("syncdeleteped",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToPed(index)
		if DoesEntityExist(v) then
			Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
			SetPedAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
			DeletePed(v)
		end
	end
end)