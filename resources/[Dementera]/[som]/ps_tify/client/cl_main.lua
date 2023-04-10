 -----------------------------------------------------------------------------------------------------------------------------------------
 -- VRP
 -----------------------------------------------------------------------------------------------------------------------------------------
 local Tunnel = module('vrp', 'lib/Tunnel')
 local Proxy  = module('vrp', 'lib/Proxy')
 local cfg    = module("ps_tify","config")
 vRP = Proxy.getInterface("vRP")
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- CONEXÃƒO
 -----------------------------------------------------------------------------------------------------------------------------------------
 psRP = {}
 Tunnel.bindInterface("ps_tify", psRP)
 Proxy.addInterface("ps_tify", psRP)
 vSERVER = Tunnel.getInterface("ps_tify")
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- VARIABLES
 -----------------------------------------------------------------------------------------------------------------------------------------
 local Music         = {}
 local datasoundinfo = {}
 local nuiaberto     = false
 local myjob         = nil
 local nameopen      = nil
 local SoundsPlaying = {}
 local linkurl = ''
 local Looping = ''
 local shown = false
 local identifier = ''
 local plate = ''
 local urlYoutube = 'https://www.youtube.com/watch?v='
 local fecharplaylist = false 
 Zones = {}
 xSound = exports.xsound
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- GetDate
 -----------------------------------------------------------------------------------------------------------------------------------------
 Citizen.CreateThread(function()
 	TriggerServerEvent("ps_tify:GetDate")
 end)
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- RegisterNUICallback
 -----------------------------------------------------------------------------------------------------------------------------------------
 RegisterNUICallback("action", function(data)
 	local _source = source
 	local nameid  = nameopen
 	local check, plate, netid = vSERVER.check()
 	if check then
		nameid = plate
 	else
 		return false
 	end
	print(data.action)
 	if data.action == "seturl" then
 		SetUrl(data.link,nameid, netid)
 	elseif data.action == "play" then
		SetUrl(urlYoutube..data.link,nameid, netid)
 		if xSound:soundExists(nameid) then
 			if xSound:isPaused(nameid) then
				
 				TriggerServerEvent("ps_tify:ChangeState", true, nameid)
 				local esperar = 0
 				while nuiaberto do
 					Wait(1000)
 					if xSound:isPlaying(nameid) then
 						SendNUIMessage({
 							action = "TimeVid",
 							total = xSound:getMaxDuration(nameid),
 							played = xSound:getTimeStamp(nameid),
 						})
 					else
 						esperar = esperar +1
 					end
 					if esperar >= 5 then
						SendNUIMessage({
							action = "NextMusic"
						})
 						break
 					end
 				end
 			end
 		end
 	elseif data.action == "pause" then
		print("entrou no pause")
 		if xSound:soundExists(nameid) then
 			if xSound:isPlaying(nameid) then
 				TriggerServerEvent("ps_tify:ChangeState", false, nameid)
 			end
 		end
 	elseif data.action == "exit" then
		print('exit')
		shown = true
		show(false)
		nuiaberto = false
	elseif data.action == "closeplaylist" then		
		print('close')
		fecharplaylist = true
		nuiaberto = false
 	elseif data.action == "volumeup" then
 		ApplySound(0.05,nameid)
 	elseif data.action == "volumedown" then
 		ApplySound(-0.05,nameid)
 	elseif data.action == "loop" then
 		if xSound:soundExists(nameid) then
 			datasoundinfo.loop = not xSound:isLooped(nameid)
 			TriggerServerEvent("ps_tify:ChangeLoop",nameid,datasoundinfo.loop)
 		else
 			datasoundinfo.loop = not datasoundinfo.loop
 		end
 		if type(datasoundinfo.loop) ~= "table" then
 			local loop = ('<b>Looping:</b> '.. firstToUpper(tostring(datasoundinfo.loop)))
 			SendNUIMessage({
 				action = "changetextl",
 				text = loop,
 			})
 		end
 	elseif data.action == "forward" then
 		if xSound:soundExists(nameid) then
 			TriggerServerEvent("ps_tify:ChangePosition", 10, nameid)
 		end
 	elseif data.action == "back" then
 		if xSound:soundExists(nameid) then
 			TriggerServerEvent("ps_tify:ChangePosition", -10, nameid)
 		end
 	end
 end)
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- ApplySound
 -----------------------------------------------------------------------------------------------------------------------------------------
 function ApplySound(quanti,plate)
 	local exis = false
 	local som = datasoundinfo.volume
 	if xSound:soundExists(plate) and xSound:isPlaying(plate) then
 		exis = true
 		som = xSound:getVolume(plate)
 		datasoundinfo.volume = som
 	end
 	local vadi = som + quanti
 	if vadi <= 1.01 and vadi >= -0.001 and exis then
 		if vadi < 0.005 then
 			vadi = 0.0
 		end
 		datasoundinfo.volume = vadi
 		local volume = (math.floor((vadi*100) - 0.1+1))
 		SendNUIMessage({
             action = "changetextv",
             volume = volume,
         })
 		TriggerServerEvent("ps_tify:ChangeVolume", quanti, plate)
 	end
 end
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- firstToUpper
 -----------------------------------------------------------------------------------------------------------------------------------------
 function firstToUpper(str)
     return (str:gsub("^%l", string.upper))
 end
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- SetUrl
 -----------------------------------------------------------------------------------------------------------------------------------------
 function SetUrl(url,nid, netid)
 	local nome = nid
 	if url then
 		local encontrad = false
 		for i = 1, #Zones do
 			local v = Zones[i]
 			if v.name == nome then
 				encontrad = true
 			end
 		end
 		if encontrad then
 			local vehdata = {}
 			vehdata.name = nome
 			vehdata.link = url
 			vehdata.loop = datasoundinfo.loop
 			vehdata.popo = netid
 			TriggerServerEvent("ps_tify:ModifyURL",vehdata)
 		else
 			local veh = NetToVeh(netid)
 			local cordsveh = GetEntityCoords(veh)
 			local netidd = netid
 			local vehdata = {}
 			vehdata.plate = nome
 			vehdata.coords = cordsveh
 			vehdata.link = url
 			vehdata.popo = netidd
 			vehdata.volume = datasoundinfo.volume
 			vehdata.loop = datasoundinfo.loop
 			TriggerServerEvent("ps_tify:AddVehicle",vehdata)
 		end
 	end

	 SendNUIMessage({
 		action = "TimeVid",
 	})

 	if xSound:soundExists(nome) then
 		SendNUIMessage({
 			action = "TimeVid",
 			total = xSound:getMaxDuration(nome),
 			played = xSound:getTimeStamp(nome),
 		})
 	end
 	local esperar = 0
 	while nuiaberto do
 		Wait(1000)
 		if xSound:soundExists(nome) then
 			if xSound:isPlaying(nome) then
 				SendNUIMessage({
 					action = "TimeVid",
 					total = xSound:getMaxDuration(nome),
 					played = xSound:getTimeStamp(nome),
 				})
 			else
 				esperar = esperar +1
 			end
 		else
 			esperar = esperar +1
 		end
 		if esperar >= 4 then
			SendNUIMessage({
				action = "NextMusic"
			})
 			break
 		end
 	end
 end
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- open
 -----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("openCar",function(source,args)	
	show(true)
end)

 RegisterKeyMapping("openCar","Abrir Som Automotivo","keyboard", cfg.OpenTablet)
 RegisterNetEvent("ps_tify:ShowNui")
 AddEventHandler("ps_tify:ShowNui", function()
 	show(true)
 end)
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- show
 -----------------------------------------------------------------------------------------------------------------------------------------
 function show(checkvehicle, nomecenas)
 	shown = not shown
 	local nome = nomecenas
	local playSound = false
	local total = 0 
	local player = 0
 	if checkvehicle then
 		local check, plate = vSERVER.check()
 		if check then
 			nome = plate
 		else
 			return false
 		end
 	end
	print(shown)
	print(nome)
     if shown and nome then
		print(1)
 		nuiaberto = true
 		datasoundinfo = {volume = 0.2, loop = false}
 	
 		if xSound:soundExists(nome) then
 			datasoundinfo.volume = xSound:getVolume(nome)
 			datasoundinfo.loop = xSound:isLooped(nome)
 			if xSound:isPlaying(nome) then
				playSound = true
 				linkurl = xSound:getLink(nome)
				total = xSound:getMaxDuration(nome)
				player = xSound:getTimeStamp(nome)
 			end
 		end
         SetNuiFocus(true, true)
 		local volume = (math.floor((datasoundinfo.volume*100) - 0.1+1))
 		if type(datasoundinfo.loop) ~= "table" then
 			local Looping = ('<b>Looping:</b> '.. firstToUpper(tostring(datasoundinfo.loop)))
 			SendNUIMessage({
 				action = "changetextl",
 				loop = Looping,
 			})
 		end
		getIdXbl()
 		SendNUIMessage({
             action = "openUI",
			 volume = volume,
			 loop = loop,
			 linkurl = linkurl,
			 token = "4n2B23iftLamiQUQU9Pqf2b0Cvps8pfwdk4rK84u3sH2f2sl3I92l3aspdhd",
			 license = "V1X7-6QKB-26DL-TPYR",
			 youtube = cfg.YouTubeKey,
			 playSound = playSound,
			 idXbl = identifier,
			 total = total,
			 played = player
         })
		 fecharplaylist = false
 		local esperar = 0
 		while nuiaberto do
 			Wait(1000)
 			if xSound:soundExists(nome) then
 				if xSound:isPlaying(nome) then	
 					SendNUIMessage({
 						action = "TimeVid",
 						total = xSound:getMaxDuration(nome),
 						played = xSound:getTimeStamp(nome),
 					})
 				else
					esperar = esperar +1
 				end
 			else
 				esperar = esperar +1
 			end
 			if esperar >= 4 then
					SendNUIMessage({
						action = "NextMusic"
					})
 				break
 			end
 		end
 		cfg.starttablet()
     elseif nuiaberto then
		print(2)
 		nameopen = nil
 		nuiaberto = false
         SetNuiFocus(false, false)
         SendNUIMessage({
            action = "closeUI",
 			data = datasoundinfo
         })
		--  verificaMusica()
 		cfg.stoptablet()
 	end
 end

 function verificaMusica()
	local check, plate = vSERVER.check()
	local esperar = 0
	while not fecharplaylist do
		Wait(1000)
		if xSound:soundExists(plate) then
			if xSound:isPlaying(plate) then	
				SendNUIMessage({
					action = "TimeVid",
					total = xSound:getMaxDuration(plate),
					played = xSound:getTimeStamp(plate),
				})
			else
				esperar = esperar +1
			end
		else
			esperar = esperar +1
		end
		if esperar >= 4 then
			SendNUIMessage({
					action = "NextMusic"
				})
			shown = not shown
			-- nuiaberto = not nuiaberto
			show(false)			
			break
		end
	end
 end
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- AddVehicle
 -----------------------------------------------------------------------------------------------------------------------------------------
 RegisterNetEvent("ps_tify:AddVehicle")
 AddEventHandler("ps_tify:AddVehicle", function(data)
 	table.insert(Zones, data)
 	local v = data
 	if xSound:soundExists(v.name) then
 		xSound:Destroy(v.name)
 	end
 	local avancartodos = v.volume
 	xSound:PlayUrlPos(v.name, v.deflink, avancartodos, v.coords, v.loop,{
 		onPlayStart = function(event)
 			xSound:setTimeStamp(v.name, v.deftime)
 			xSound:Distance(v.name,v.range)
 		end,
 	})
 	table.insert(SoundsPlaying, #Zones)
 	StartMusicLoop(#Zones)
 end)
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- ModifyURL
 -----------------------------------------------------------------------------------------------------------------------------------------
 RegisterNetEvent("ps_tify:ModifyURL")
 AddEventHandler("ps_tify:ModifyURL", function(data)
 	local v = data
 	local avancartodos = v.volume
 	if xSound:soundExists(v.name) then
 		if not xSound:isDynamic(v.name) then
 			xSound:setSoundDynamic(v.name,true)
 		end
 		Wait(100)
 		xSound:setVolumeMax(v.name,0.0)
 		xSound:setSoundURL(v.name, v.deflink)
 		Wait(100)
 		xSound:Position(v.name, v.coords)
 		xSound:setSoundLoop(v.name,v.loop)
 		Wait(200)
 		xSound:setTimeStamp(v.name,0)
 		xSound:setVolumeMax(v.name,avancartodos)
 									 
 	else
 		xSound:PlayUrlPos(v.name, v.deflink, avancartodos, v.coords, v.loop, {
 			onPlayStart = function(event)
 				xSound:setTimeStamp(v.name, v.deftime)
 				xSound:Distance(v.name,v.range)
 			end,
 		})
 	end
 	local iss = nil
 	for i = 1, #Zones do
 		local b = Zones[i]
 		if v.name == b.name then
 			if b.popo then
 				iss = i
 			end
 			b.deflink = v.deflink
 			b.deftime = 0
 			b.isplaying = v.isplaying
 			b.loop = v.loop
 			if v.popo then
 				b.popo = v.popo
 			end
 		end
 	end
 	local encontrads = false
 	for i = 1, #SoundsPlaying do
 		local v = SoundsPlaying[i]
 		if v == iss then
 			encontrads = true
 		end
 	end
 	local esperar = 0
 	while nuiaberto do
 		Wait(1000)
 		if xSound:soundExists(v.name) then
 			local pped = PlayerPedId()
 			local coordss = GetEntityCoords(pped)
 			local geraldist = #(coordss-xSound:getPosition(v.name))
 			if xSound:isPlaying(v.name) and (geraldist <= 3 or not v.popo) then
 				SendNUIMessage({
 					action = "TimeVid",
 					total = xSound:getMaxDuration(v.name),
 					played = xSound:getTimeStamp(v.name),
 				})
 			else
 				esperar = esperar +1
 			end
 		else
 			esperar = esperar +1
 		end
 		if esperar >= 4 then
			SendNUIMessage({
				action = "NextMusic"
			})
 			break
 		end
 	end
 	if not encontrads and iss then
 		table.insert(SoundsPlaying, iss)
 		StartMusicLoop(iss)
 	end
 end)
 -----------------------------------------------------------------------------------------------------------------------------------------
 -- ChangeState
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:ChangeState")
AddEventHandler("ps_tify:ChangeState", function(tipo, nome)
	if tipo and xSound:soundExists(nome) then
		xSound:Resume(nome)
	elseif xSound:soundExists(nome) then
		xSound:Pause(nome)
	end
	local iss = nil
	for i = 1, #Zones do
		local v = Zones[i]
		if v.name == nome then
			if v.popo then
				iss = i
			end
			v.isplaying = tipo
		end
	end
	if tipo and iss then
		table.insert(SoundsPlaying, iss)
		StartMusicLoop(iss)
	elseif iss then
		for i = 1, #SoundsPlaying do
			local v = SoundsPlaying[i]
			if v == iss then
				table.remove(SoundsPlaying, i)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ChangePosition
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:ChangePosition")
AddEventHandler("ps_tify:ChangePosition", function(quanti, nome)
	local tempapply
	for i = 1, #Zones do
		local v = Zones[i]
		if v.name == nome then
			v.deftime = v.deftime + quanti
			if v.deftime < 0 then
				v.deftime = 0
			end
        	tempapply = v.deftime
		end
	end
	if xSound:soundExists(nome) then
		xSound:setTimeStamp(nome,tempapply)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ChangeLoop
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:ChangeLoop")
AddEventHandler("ps_tify:ChangeLoop", function(tipo, nome)
	if xSound:soundExists(nome) then
		xSound:setSoundLoop(nome,tipo)
	end
	for i = 1, #Zones do
		local v = Zones[i]
		if v.name == nome then
			v.loop = tipo
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ChangeVolume
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:ChangeVolume")
AddEventHandler("ps_tify:ChangeVolume", function(som, range, nome)
	local carroe
	local crds
    for i = 1, #Zones do
        local v = Zones[i]
        if nome == v.name then
            v.volume = som
            v.range = range
			carroe = v.popo
			crds = v.coords
        end
    end
	if xSound:soundExists(nome) then
		xSound:Distance(nome,range)
		if not carroe and crds then
			xSound:setVolumeMax(nome,som)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- countTime
-----------------------------------------------------------------------------------------------------------------------------------------
function countTime()
    SetTimeout(2000, countTime)
    for i = 1, #Zones do
		local v = Zones[i]
		if v.isplaying then
			v.deftime = v.deftime + 2
		end
    end
end

SetTimeout(2000, countTime)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SendData
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:SendData")
AddEventHandler("ps_tify:SendData", function(data)
    Zones = data
    for i = 1, #Zones do
		local v = Zones[i]
		if v.isplaying then
			if xSound:soundExists(v.name) then
				xSound:Destroy(v.name)
			end
			local avancartodos = v.volume
			xSound:PlayUrlPos(v.name, v.deflink, avancartodos, v.coords, v.loop,
			{
				onPlayStart = function(event)
					xSound:setTimeStamp(v.name, v.deftime)
					xSound:Distance(v.name,v.range)
				end,
			})
			if v.popo then
				table.insert(SoundsPlaying, i)
				StartMusicLoop(i)
			end
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Threads
-----------------------------------------------------------------------------------------------------------------------------------------
local plpedloop
local pploop
local coordsped

Citizen.CreateThread(function()
	local poschanged = true
	while true do
		Wait(500)
		plpedloop = PlayerPedId()
		pploop = GetVehiclePedIsIn(plpedloop,false)
		coordsped = GetEntityCoords(plpedloop)
	end
end)

function StartMusicLoop(i)
	while not xSound:soundExists(Zones[i].name) do
		Wait(10)
	end
	Citizen.CreateThread(function()
		local poschanged = true
		while true do
			local sleep = 100
			local v = Zones[i]
			if v == nil then
				return
			end
			if v.isplaying and xSound:soundExists(v.name) then
				local carrofound = false
				if NetworkDoesEntityExistWithNetworkId(v.popo)then
					local carro = NetworkGetEntityFromNetworkId(v.popo)
					if GetEntityType(carro) == 2 then
						if GetVehicleNumberPlateText(carro) == v.name then
							carrofound = true
							local cordsveh = GetEntityCoords(carro)
							local geraldist = #(cordsveh-coordsped)
							if geraldist <= v.range+50 then
								local avolume = xSound:getVolume(v.name)
								local dina = xSound:isDynamic(v.name)
								local getpos = v.coords
								local getposdif = #(getpos-cordsveh)
								if avolume <= 0.001 then
									sleep = 1000
								end
								if pploop == carro then
									if dina then
										xSound:setSoundDynamic(v.name,false)
									end
									if avolume ~= v.volume then
										xSound:setVolume(v.name,v.volume)
									end
									if getposdif >= 5.0 or poschanged then
										poschanged = false
										v.coords = cordsveh
										xSound:Position(v.name, cordsveh)
									else
										sleep = sleep+150
									end
								else	
									if not dina then
										xSound:setSoundDynamic(v.name,true)
									end
									if avolume ~= v.volume then
										xSound:setVolumeMax(v.name,v.volume)
									end
									if geraldist >= v.range+20 then
										sleep = (geraldist*100)/3
									end
									if sleep <= 10000 then
										local speedcar = GetEntitySpeed(carro)*3.6
										if speedcar <= 2.0 then
											sleep = sleep+2500
										elseif speedcar <= 5.0 then
											sleep = sleep+1000
										elseif speedcar <= 10.0 then
											sleep = sleep+100
										end
									end
									if getposdif >= 1.0 or poschanged then
										poschanged = false
										v.coords = cordsveh
										xSound:Position(v.name, cordsveh)
									else
										sleep = sleep+150
									end
								end
							else
								if not xSound:isDynamic(v.name) then
									xSound:setSoundDynamic(v.name,true)
								end
								xSound:setVolumeMax(v.name,0.0)
								if not poschanged then
									xSound:Position(v.name, vector3(350.0,0.0,-150.0))
									poschanged = true
								end
								sleep = (geraldist*100)/2
							end
						end
					end
				end
				if not carrofound then
					if not xSound:isDynamic(v.name) then
						xSound:setSoundDynamic(v.name,true)
					end
					--xSound:setVolumeMax(v.name,0.0)
					if not poschanged then
						xSound:Position(v.name, vector3(350.0,0.0,-150.0))
						poschanged = true
					end
					Wait(5000)
				end
			else
				if xSound:soundExists(v.name) then
					if not xSound:isDynamic(v.name) then
						xSound:setSoundDynamic(v.name,true)
					end
					xSound:setVolumeMax(v.name,0.0)
					if not poschanged then
						xSound:Position(v.name, vector3(350.0,0.0,-150.0))
						poschanged = true
					end
				end
				v.isplaying = false
				for j = 1, #SoundsPlaying do
					local k = SoundsPlaying[j]
					if k == i then
						table.remove(SoundsPlaying, j)
					end
				end
				break
			end
			if sleep > 10000 then
				sleep = 10000
			end
			Wait(sleep)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		local dormir = 2000
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i = 1, #cfg.Zones do
			local v = cfg.Zones[i]
			local distance = #(coords - v.changemusicblip)
			if distance <= 10 then
				dormir = 500
				if distance <= 3 then
					dormir = 5
					drawTxt("PRESSIONE [~r~E~w~] PARA TROCAR DE MÃšSICA",4,0.5,0.92,0.35,255,255,255,180)
					DrawMarker(23, v.changemusicblip.x, v.changemusicblip.y, v.changemusicblip.z-0.97,0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
					if IsControlJustReleased(0, 38) then
						if vSERVER.checkPermissions(i) then
							nameopen = v.name
							show(false, v.name)
							Wait(1000)
						end
					end
				end
			end
		end
		Wait(dormir)
	end
end)


RegisterNUICallback("inserUrlPlaylist",function(data,cb)
	vSERVER.inserUrlPlaylist(data.idPlaylist, data.url)
end)

RegisterNUICallback("InsertPlaylist",function(data,cb)
	getIdXbl()
	vSERVER.InsertPlaylist(data.name,identifier)
	TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..vRP.format(parseInt(randmoney)).." rupias.")
end)

function getIdXbl()
	identifier = vSERVER.buscaIdentifier()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- drawTxt
-----------------------------------------------------------------------------------------------------------------------------------------
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