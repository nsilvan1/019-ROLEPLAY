RegisterNetEvent('vrp_sound:source')
AddEventHandler('vrp_sound:source',function(sound,volume)
	SendNUIMessage({ transactionType = 'playSound', transactionFile = sound, transactionVolume = volume })
end)

RegisterNetEvent('vrp_sound:distance')
AddEventHandler('vrp_sound:distance',function(playerid,maxdistance,sound,volume)
	local lCoords = GetEntityCoords(PlayerPedId())
	local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerid)))
	local distance  = Vdist(lCoords.x,lCoords.y,lCoords.z,eCoords.x,eCoords.y,eCoords.z)
	if distance <= maxdistance then
		SendNUIMessage({ transactionType = 'playSound', transactionFile = sound, transactionVolume = volume })
	end
end)

RegisterNetEvent('vrp_sound:fixed')
AddEventHandler('vrp_sound:fixed',function(playerid,x2,y2,z2,maxdistance,sound,volume)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local distance = GetDistanceBetweenCoords(x2,y2,z2,x,y,z,true)
	if distance <= maxdistance then
		SendNUIMessage({ transactionType = 'playSound', transactionFile = sound, transactionVolume = volume })
	end
end) 


function stringsplit(inputstr,sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {} ; i = 1
	for str in string.gmatch(inputstr,"([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

local function starts_with(str,start)
   return str:sub(1,#start) == start
end