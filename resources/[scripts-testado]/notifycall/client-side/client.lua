-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local showBlips = {}
local timeBlips = {}
local numberBlips = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	RegisterKeyMapping("ocorrencias","Abrir as notificações","keyboard","f1")
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ocorrencias",function(source,args)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		SendNUIMessage({ action = "showAll" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFYPUSH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("NotifyPush")
AddEventHandler("NotifyPush",function(data)
	data["street"] = GetStreetNameFromHashKey(GetStreetNameAtCoord(data["x"],data["y"],data["z"]))

	SendNUIMessage({ action = "notify", data = data })

	numberBlips = numberBlips + 1

	timeBlips[numberBlips] = 60
	showBlips[numberBlips] = AddBlipForRadius(data["x"],data["y"],data["z"],150.0)
	SetBlipColour(showBlips[numberBlips],data["blipColor"])
	SetBlipAlpha(showBlips[numberBlips],150)

	if data["code"] == "QRT" then
		TriggerEvent("vrp_sound:source",'deathcop',0.7)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(timeBlips) do
			if timeBlips[k] > 0 then
				timeBlips[k] = timeBlips[k] - 1

				if timeBlips[k] <= 0 then
					RemoveBlip(showBlips[k])
					showBlips[k] = nil
					timeBlips[k] = nil
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOn",function()
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSOFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOff",function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("setWay",function(data)
	SetNewWaypoint(data["x"] + 0.0001,data["y"] + 0.0001)
	SendNUIMessage({ action = "hideAll" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("phoneCall",function(data)
	SendNUIMessage({ action = "hideAll" })
	TriggerEvent("gcPhone:callNotifyPush",data.phone)
end)

RegisterCommand("marsteste", function(source, args, rawCommand)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(source)))
	TriggerEvent("NotifyPush", { code = 20, title = "Tráfico", text = "Venda de drogas", x = x ,y = y , z = z , rgba = {140,35,35} })
end)