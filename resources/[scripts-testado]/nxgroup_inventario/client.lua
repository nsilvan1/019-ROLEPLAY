local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPNserver = Tunnel.getInterface("nxgroup_inventario")

func = {}
Proxy.addInterface("nxgroup_inventario",func)
Tunnel.bindInterface("nxgroup_inventario",func)
local config = module("nxgroup_inventario", "config")
--[ VARIÁVEIS ]--------------------------------------------------------------------------------------------------------------------------
local trunkinvOpen = false
local invOpen = false
local chestOpen = nil
local chestTimer = 0
local roubando = nil
local sendoRoubado = false

RegisterNUICallback("invClose",function(data)
	invOpen = false
	if chestOpen then
		vRPNserver.trunkChestClose()
		vRPNserver.closeChest()
		chestOpen = nil
	end
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "hideMenu" })
	StopScreenEffect("MenuMGSelectionIn")
end)

RegisterNUICallback("invClose2",function(data)
	invOpen = false
	if chestOpen then
		vRPNserver.closeChest()
		chestOpen = nil
	end
	if roubando then
		vRPNserver.closeRoubo()
		roubando = nil
	end
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "hideMenu" })
	StopScreenEffect("MenuMGSelectionIn")
end)
 
-- FUNÇÃO PARA FECHAR O INV SE CAIR A NET -----------------
AddEventHandler("core_connection:close",function(data)
	invOpen = false
	if chestOpen then
		vRPNserver.closeChest()
	end
	if roubando then
		vRPNserver.closeRoubo()
		roubando = nil
	end
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "hideMenu" })
	StopScreenEffect("MenuMGSelectionIn")
end)
-----------------------------------------------------------------------
--[ ABRIR INVENTARIO ]-------------------------------------------------
-----------------------------------------------------------------------
RegisterKeyMapping("moc","Abrir a mochila","keyboard","OEM_3")
local cdmoc = GetGameTimer()
RegisterCommand("moc",function()
    local ped = PlayerPedId()
    if GetEntityHealth(ped) > 101 and not vRP.isHandcuffed() and not IsPedBeingStunned(ped) and not IsPlayerFreeAiming(ped) then
      if not sendoRoubado then
        if GetGameTimer() >= cdmoc then
          if invOpen == false then
            cdmoc = GetGameTimer() + 2000
            invOpen = true
            SetNuiFocus(true,true)
            StartScreenEffect("MenuMGSelectionIn", 0, true)
            SendNUIMessage({ action = "showMenu" })
          end
        else
          TriggerEvent("nyo_notify", "#FFA500","Importante", "Você nâo pode abrir o inventario muito rapido", 5000)
        end 
      else
        TriggerEvent("Notify","negado","Você não pode abrir o inventário neste momento")
      end
    end
end)

RegisterKeyMapping("bautr","Abrir o bau carro","keyboard","PAGEUP")
local cdbau = GetGameTimer()
RegisterCommand("bautr",function()
  if GetGameTimer() >= cdbau then
    local ped = PlayerPedId()
    if not vRP.isHandcuffed() and not IsPedBeingStunned(ped) and not IsPlayerFreeAiming(PlayerId()) and GetEntityHealth(PlayerPedId()) > 101 then
      if vRPNserver.trunkChestOpen() then
        trunkChestOpened = true
      end
      cdbau = GetGameTimer() + 3000
    end
  else
		TriggerEvent("nyo_notify", "#FFA500","Importante", "Você nâo pode abrir do porta mala muito rapido", 5000)
	end
end)

-- Citizen.CreateThread(function(source)
-- 	local source = source
--     while true do
--         Citizen.Wait(5)
--         local ped = PlayerPedId()
--         if IsControlJustPressed(0,243) then
-- 			if GetEntityHealth(ped) >= 101 and not vRP.isHandcuffed() and not IsPedBeingStunned(ped) and not IsPlayerFreeAiming(ped) then
-- 				if not sendoRoubado then
-- 					if invOpen == false then
-- 						invOpen = true
-- 						SetNuiFocus(true,true)
-- 						StartScreenEffect("MenuMGSelectionIn", 0, true)
-- 						SendNUIMessage({ action = "showMenu" })
-- 					end
-- 				else
-- 					TriggerEvent("Notify","negado","Você não pode abrir o inventário quando está sendo roubado")
-- 				end
-- 			end
--         end
-- 		if IsControlJustPressed(0,10) and not vRP.isHandcuffed() and not IsPedBeingStunned(ped) and not IsPlayerFreeAiming(PlayerId()) and GetEntityHealth(PlayerPedId()) > 101 then
-- 			vRPNserver.trunkChestOpen()
-- 		end
--     end
-- end)

RegisterNUICallback("requestMochila",function(data,cb)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local dropItems = {}
	local inventario,peso,maxpeso,b1,b2,b3,b4,weapons = vRPNserver.Mochila()
	if inventario then
		cb({ inventario = inventario, drop = dropItems,peso = peso, maxpeso = maxpeso, b1 = b1, b2 = b2, b3 = b3, b4 = b4, weapons = weapons,images = config.images})
	end
end)

RegisterNUICallback("requestIdentity",function(data,cb)
	local ped = PlayerPedId()
	local identity = vRPNserver.getIdentity()
	cb({infos = identity})
end)



local ub = GetGameTimer()
RegisterKeyMapping("bind1","Bind 1","keyboard","1")
RegisterCommand("bind1",function()
  if GetGameTimer() >= ub then
    vRPNserver.useBind(1)
    ub = GetGameTimer() + 3000
  else
		TriggerEvent("nyo_notify", "#FFA500","Importante", "Você nâo pode usar as bind muito rapido", 5000)
  end
end)

local ub2 = GetGameTimer()
RegisterKeyMapping("bind2","Bind 2","keyboard","2")
RegisterCommand("bind2",function()
  if GetGameTimer() >= ub2 then
    vRPNserver.useBind(2)
    ub2 = GetGameTimer() + 3000
  else
		TriggerEvent("nyo_notify", "#FFA500","Importante", "Você nâo pode usar as bind muito rapido", 5000)
  end
end)

local ub3 = GetGameTimer()
RegisterKeyMapping("bind3","Bind 3","keyboard","3")
RegisterCommand("bind3",function()
  if GetGameTimer() >= ub3 then
    vRPNserver.useBind(3)
    ub3 = GetGameTimer() + 3000
  else
		TriggerEvent("nyo_notify", "#FFA500","Importante", "Você nâo pode usar as bind muito rapido", 5000)
  end
end)

local ub4 = GetGameTimer()
RegisterKeyMapping("bind4","Bind 4","keyboard","4")
RegisterCommand("bind4",function()
  if GetGameTimer() >= ub4 then
    vRPNserver.useBind(4)
    ub4 = GetGameTimer() + 3000
  else
		TriggerEvent("nyo_notify", "#FFA500","Importante", "Você nâo pode usar as bind muito rapido", 5000)
  end
end)

RegisterNUICallback("bindItem",function(data)
	vRPNserver.tryBind(data)
end)

RegisterNUICallback("unEquip",function(data)
	vRPNserver.unEquip(data)
	SendNUIMessage({ action = "updateMochila" })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BAU DE FACS --------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(data,cb)
	local inventario,inventario2,peso,maxpeso,peso2,maxpeso2 = vRPNserver.openChest(tostring(chestOpen))
	if inventario then
		cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2, infos = infos})
	end
end)

RegisterNUICallback("takeItem",function(data)
	vRPNserver.takeItem(tostring(chestOpen),data.item,data.amount)
end)

RegisterNUICallback("storeItem",function(data)
	vRPNserver.storeItem(tostring(chestOpen),data.item,data.amount)
end)

local chest = config.chest
Citizen.CreateThread(function()
	while true do
		local egsleep = 1000
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		for k,v in pairs(chest) do
			local distance = Vdist(x,y,z,v[2],v[3],v[4])
			if distance <= 2.0 and chestTimer <= 0 then
				egsleep = 4
				config.drawMarker(v[2],v[3],v[4])
				if IsControlJustPressed(0,38) then
					chestTimer = 2
					if vRPNserver.checkIntPermissions(v[1]) and vRPNserver.chestInUse(v[1]) then
						chestOpen = v[1]
						SetNuiFocus(true,true)
						StartScreenEffect("MenuMGSelectionIn", 0, true)
						SendNUIMessage({ action = "updateChest" })
					end
				end
			end
		end
		Citizen.Wait(egsleep)
	end
end)

local chestPeso = 100
function func.openHouseChest(chest,weight)
	if vRPNserver.chestInUse(chest) then
		chestTimer = 3
		chestOpen = chest
		chestPeso = weight
		SetNuiFocus(true,true)
		StartScreenEffect("MenuMGSelectionIn", 0, true)
		SendNUIMessage({ action = "updateHomeChest" })
	end
end

RegisterNUICallback("requestHomeChest",function(data,cb)
	local inventario,inventario2,peso,maxpeso = vRPNserver.openHomeChest(tostring(chestOpen),chestPeso)
	if inventario then
		cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, maxpeso2 = chestPeso, infos = infos})
	end
end)

RegisterNUICallback("storeHomeItem",function(data)
	vRPNserver.storeHomeItem(tostring(chestOpen),data.item,data.amount)
end)

RegisterNUICallback("takeHomeItem",function(data)
	vRPNserver.takeHomeItem(tostring(chestOpen),data.item,data.amount)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST ---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("trunkchest:Open")
AddEventHandler("trunkchest:Open",function(data)
	if not trunkinvOpen and vRPNserver.chestInUse(data) then
		chestOpen = data
		SetNuiFocus(true,true)
		StartScreenEffect("MenuMGSelectionIn", 0, true)
		SendNUIMessage({ action = "updateTrunkChest" })
	end
end)

RegisterNUICallback("takeTrunkItem",function(data)
	vRPNserver.takeTrunkchestItem(data.item,data.amount)
end)

RegisterNUICallback("storeTrunkItem",function(data)
	vRPNserver.storeTrunkItem(data.item,data.amount)
end)

RegisterNUICallback("requestTrunkChest",function(data,cb)
	local inventario,inventario2,peso,maxpeso,peso2,maxpeso2 = vRPNserver.trunkChest()
	if inventario then
		cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2 })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DROPITEM ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dropItem",function(data)
	vRPNserver.dropItem(data.item,data.amount)
	SendNUIMessage({ action = "showMenu" })
end)

local dropList = {}
RegisterNetEvent('DropSystem:remove')
AddEventHandler('DropSystem:remove',function(id)
	if dropList[id] ~= nil then
		dropList[id] = nil
	end
end)

RegisterNetEvent('DropSystem:createForAll')
AddEventHandler('DropSystem:createForAll',function(id,marker)
	dropList[id] = marker
end)

local cooldown = false
Citizen.CreateThread(function()
	while true do
		local egSleep = 1000
		for k,v in pairs(dropList) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local ui = GetMinimapAnchor()
			if distance <= 5 then
				egSleep = 5
				DrawMarker(25, v.x, v.y, cdz+0.01, 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.5, 255, 255, 255, 50, 0, 0, 2, 0, 0, 0, 0)
				DrawMarker(20, v.x, v.y, cdz+0.10, 0, 0, 0, 0, 180.0, 130.0, 0.6, 0.8, 0.5, 155,0,0, 220, 0, 0, 0, 0)
				drawTxt2(ui.right_x+0.25,ui.bottom_y-0.100,"PRESSIONE ~r~E~w~ PARA PEGAR (~r~"..v.count.."x~w~)~r~ "..v.name)
				
				if IsControlJustPressed(0,38) and distance <= 2 then
					vRPNserver.takeDropItem(k)
				end
			end
		end
		Citizen.Wait(egSleep)
	end
end)

RegisterNUICallback("sendItem",function(data)
	vRPNserver.sendItem(data.item,data.amount)
end)

RegisterNUICallback("useItem",function(data)
	vRPNserver.useItem(data.item,data.type,data.amount)
end)

RegisterNetEvent("EG:UpdateInv")
AddEventHandler("EG:UpdateInv",function(action)
	SendNUIMessage({ action = action })
end)
---------------------------------------------------------------------------------------------------------------------------------------
-- LOJA DE DEPARTAMENTOS --------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("buyItem",function(data)
	vRPNserver.tryBuyItem(data.item,data.amount,data.shop,data.method)
	SendNUIMessage({ action = "updateShop", name = data.shop })
end)

RegisterNUICallback("sellItem",function(data)
	vRPNserver.trySellItem(data.item,data.amount,data.shop,data.method)
	SendNUIMessage({ action = "updateShop", name = data.shop })
end)


RegisterNUICallback("requestShop",function(data,cb)
	local inventoryShop,inventario,weight,maxweight,infos = vRPNserver.requestShop(data.shop)
	if inventoryShop then
		cb({ shops = inventoryShop, inventario = inventario, weight = weight, maxweight = maxweight, infos = infos })
	end
end)

local shopList = config.shopList
Citizen.CreateThread(function()
	while true do
		local egsleep = 1000
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
		    for k,v in pairs(shopList) do
			local distance = Vdist(x,y,z,v[1],v[2],v[3])
			if distance <= 2.0 then
				egsleep = 4
				config.drawMarker(v[1],v[2],v[3])
				if IsControlJustPressed(0,38) then
					SetNuiFocus(true,true)
                	StartScreenEffect("MenuMGSelectionIn", 0, true)
					SendNUIMessage({ action = "updateShop", name = tostring(v[4])})
				end
			end
		end
		Citizen.Wait(egsleep)
	end
end)

RegisterNUICallback("requestRevistar",function(data,cb)
	local inventario,nInventario = vRPNserver.Revistar()
	cb({ inventario = inventario, nInventario = nInventario })
end)

RegisterNetEvent("EG:REVISTAR")
AddEventHandler("EG:REVISTAR",function()
	SetNuiFocus(true,true)
	StartScreenEffect("MenuMGSelectionIn", 0, true)
	SendNUIMessage({ action = "updateRevistar", name = "REVISTAR"})
end)

RegisterNetEvent("EG:ROUBAR")
AddEventHandler("EG:ROUBAR",function()
	roubando = true
	SetNuiFocus(true,true)
	StartScreenEffect("MenuMGSelectionIn", 0, true)
	SendNUIMessage({ action = "updateRevistar", name = "ROUBAR"})
end)

RegisterNetEvent("EG:SENDOROUBADO")
AddEventHandler("EG:SENDOROUBADO",function(value)
	sendoRoubado = value
end)

RegisterNUICallback("requestRoubar",function(data,cb)
	vRPNserver.Roubar(data)
end)

---------------------------------------------------------------------------------------------------------------------------------------
-- CLONAR PLACAS ----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('cloneplates')
AddEventHandler('cloneplates',function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    local clonada = GetVehicleNumberPlateText(vehicle)
    if IsEntityAVehicle(vehicle) then
        PlateIndex = GetVehicleNumberPlateText(vehicle)
        SetVehicleNumberPlateText(vehicle,"CLONADA")
        -- FreezeEntity(vehicle,false)
        if clonada == CLONADA then 
            SetVehicleNumberPlateText(vehicle,PlateIndex)
            PlateIndex = nil
        end
    end
end)

local usandoRemedios = false
RegisterNetEvent("remedios2")
AddEventHandler("remedios2",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    local armour = GetPedArmour(ped)

    SetEntityHealth(ped,health)
    TriggerEvent("AnthonyoLindo",armour)
    

	if usandoRemedios then
		return
	end

	usandoRemedios = true
	if usandoRemedios then
		repeat
			Citizen.Wait(600)
			if GetEntityHealth(ped) > 102 then
				SetEntityHealth(ped,GetEntityHealth(ped)+3)
			end
		until GetEntityHealth(ped) >= 400
			TriggerEvent("Notify","sucesso","A bandagem acabou de fazer efeito.",8000)
			usandoRemedios = false
	end
end)

RegisterNetEvent("remedios")
AddEventHandler("remedios",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    local armour = GetPedArmour(ped)

    SetEntityHealth(ped,health)
    TriggerEvent("AnthonyoLindo",armour)
    

	if usandoRemedios then
		return
	end

	usandoRemedios = true
	if usandoRemedios then
		repeat
			Citizen.Wait(600)
			if GetEntityHealth(ped) > 201 then
				SetEntityHealth(ped,GetEntityHealth(ped)+3)
			end
		until GetEntityHealth(ped) >= 400
			TriggerEvent("Notify","sucesso","O remédio acabou de fazer efeito.",8000)
			usandoRemedios = false
	end
end)

---------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES ----------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if chestTimer > 0 then
			chestTimer = chestTimer - 1
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

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function drawTxt2(x,y,text,r,g,b)
	SetTextFont(4)
	SetTextScale(0.48,0.48)
	SetTextColour(255,255,255,190)
	SetTextEdge(2,0,0,0,255)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function GetMinimapAnchor()
	local safezone = GetSafeZoneSize()
	local safezone_x = 1.0 / 20.0
	local safezone_y = 1.0 / 20.0
	local aspect_ratio = GetAspectRatio(0)
	local res_x, res_y = GetActiveScreenResolution()
	local xscale = 1.0 / res_x
	local yscale = 1.0 / res_y
	local Minimap = {}
	Minimap.width = xscale * (res_x / (4 * aspect_ratio))
	Minimap.height = yscale * (res_y / 5.674)
	Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
	Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
	Minimap.right_x = Minimap.left_x + Minimap.width
	Minimap.top_y = Minimap.bottom_y - Minimap.height
	Minimap.x = Minimap.left_x
	Minimap.y = Minimap.top_y
	Minimap.xunit = xscale
	Minimap.yunit = yscale
	return Minimap
end

local pedlist = {
	{ ['x'] = -1866.3, ['y'] = 2065.6, ['z'] = 135.44, ['h'] = 188.51, ['hash'] = 0x46E39E63, ['hash2'] = "u_m_o_finguru_01" },
   }

CreateThread(function()
	for k,v in pairs(pedlist) do
		RequestModel(GetHashKey(v.hash2))
		while not HasModelLoaded(GetHashKey(v.hash2)) do Wait(100) end
		ped = CreatePed(4,v.hash,v.x,v.y,v.z-1,v.h,false,true)
		peds = ped
		FreezeEntityPosition(ped,true)
		SetEntityInvincible(ped,true)
		SetBlockingOfNonTemporaryEvents(ped,true)
	end
end)