local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPNserver = Tunnel.getInterface("lotus_login")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnSalvo = nil
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "garagem01" then
		print("spawn delegacia")
		vRP.teleport(2531.95,-384.35,92.99)
	elseif data == "garagem02" then
		print("spawn hospital")
		vRP.teleport(-445.46,-362.86,33.51)
	elseif data == "garagem03" then
		print("spawn sandy")
		vRP.teleport(330.22,2621.45,44.48) 
	elseif data == "garagem04" then
		print("spawn garagemls")
		vRP.teleport(59.11,-866.72,30.55)
	elseif data == "garagem05" then
		print("spawn paleto")
		vRP.teleport(-781.84,5578.71,33.48)
	elseif data == "salvo" then
		print("login saved")
	end
	ToggleActionMenu()
	TriggerEvent("ToogleBackCharacter")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE LOGIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('vrp:ToogleLoginMenu')
AddEventHandler('vrp:ToogleLoginMenu',function()
	print("Open Menu")
	ToggleActionMenu()
end)

-- RegisterCommand("tstapz",function(source,args)
-- 	menuactive = true
-- 	if menuactive then
-- 		SetNuiFocus(true,true)
-- 		SendNUIMessage({ showmenu = true })
-- 	else
-- 		SetNuiFocus(false)
-- 		SendNUIMessage({ hidemenu = true })
-- 	end
-- end)