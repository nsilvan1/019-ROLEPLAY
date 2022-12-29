local ativando = false
local currentBlips = {}

RegisterNetEvent("eblips:toggle")
AddEventHandler("eblips:toggle",function(status)
	ativando = status
	if not ativando then
		RemoveAnyExistingEmergencyBlips()
	end
end)

RegisterNetEvent("eblips:updateAll")
AddEventHandler("eblips:updateAll", function(activeEmergencyPersonnel)
	if ativando then
		RemoveAnyExistingEmergencyBlips()
		RefreshBlips(activeEmergencyPersonnel)
	end
end)

function RemoveAnyExistingEmergencyBlips()
	for i = #currentBlips, 1, -1 do
		local b = currentBlips[i]
		if b ~= 0 then
			RemoveBlip(b)
			table.remove(currentBlips, i)
		end
	end
end

function RefreshBlips(activeEmergencyPersonnel)
	local myServerId = GetPlayerServerId(PlayerId())
	for src, info in pairs(activeEmergencyPersonnel) do
		if src ~= myServerId then
			if info and info.coords then
				local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
				SetBlipSprite(blip, 1)
				SetBlipColour(blip, info.color)
				SetBlipAsShortRange(blip, true)
				SetBlipDisplay(blip, 4)
				SetBlipShowCone(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(info.name)
				EndTextCommandSetBlipName(blip)
				table.insert(currentBlips, blip)
			end
		end
	end
end
