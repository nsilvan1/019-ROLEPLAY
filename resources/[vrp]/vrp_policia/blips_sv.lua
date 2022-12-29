local systemBlips = {}
local updateBlips = 1

RegisterServerEvent("eblips:add")
AddEventHandler("eblips:add", function(person)
	systemBlips[person.src] = person
	TriggerClientEvent("eblips:toggle", person.src, true)
end)

RegisterServerEvent("eblips:remove")
AddEventHandler("eblips:remove", function(src)
	systemBlips[src] = nil
	TriggerClientEvent("eblips:toggle", src, false)
end)

AddEventHandler("playerDropped", function()
	if systemBlips[source] then
		systemBlips[source] = nil
	end
end)

Citizen.CreateThread(function()
	local lastUpdateTime = os.time()
	while true do
		if os.difftime(os.time(), lastUpdateTime) >= updateBlips then
			for id, info in pairs(systemBlips) do
				systemBlips[id].coords = GetEntityCoords(GetPlayerPed(id))
				TriggerClientEvent("eblips:updateAll", id, systemBlips)
			end
			lastUpdateTime = os.time()
		end
		Wait(200)
	end
end)