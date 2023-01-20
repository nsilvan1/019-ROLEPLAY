-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy  = module('vrp', 'lib/Proxy')
local cfg    = module("ps_tify","config")
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
psRP = {}
Tunnel.bindInterface("ps_tify",psRP)

vRP.prepare("InsertMusic",
			"INSERT INTO spf_playlist_msic(id_playlist,video_url) VALUES(@id_playlist, @url)")	
vRP.prepare("InsertPlaylist",
			"INSERT INTO spf_playlist(nome,id_xbl) VALUES(@name, @id_xbl)")	
	
vRP.prepare("getXbl",
			"SELECT x.identifier FROM vw_identifi x  WHERE x.user_id = @user_id")	
-----------------------------------------------------------------------------------------------------------------------------------------
-- startRadio
-----------------------------------------------------------------------------------------------------------------------------------------

function psRP.inserUrlPlaylist(idPlaylist, url, name)
	vRP.execute("InsertMusic",{ id_playlist = idPlaylist, url = url })	
	TriggerClientEvent("Notify",source,"sucesso","Musica adicionada na playlist "..name)
end

function psRP.InsertPlaylist(name, id_xbl)
	vRP.execute("InsertPlaylist",{ name = name, id_xbl = id_xbl })	
	TriggerClientEvent("Notify",source,"sucesso","Playlist criada com sucesso.")
end

function psRP.buscaIdentifier()
	local source = source
	local user_id = vRP.getUserId(source)
	local identifier 
	local rows,affected = vRP.query("getXbl",{ user_id = user_id})
	if #rows > 0 then
		
		identifier = rows[1].identifier
    end 
	return identifier
end


function psRP.check()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
		if vehicle and placa then
			local placa_user_id = nil
			if not cfg.Summerz then
				placa_user_id = vRP.getUserByRegistration(placa)
			else
				placa_user_id = vRP.getVehiclePlate(placa)
			end
			if user_id == placa_user_id then
				local check = true
				if cfg.checks.item then
					check = cfg.checkItemTablet(user_id, cfg.itemtablet)

					if check ~= true then
						return false
					end
				end

				if cfg.checks.permission then 
					for k, v in pairs(cfg.permissions) do
						if vRP.hasPermission(user_id,v) then
							check = true
						end
					end
				end

				if not cfg.checks.item and not cfg.checks.permission then
					check = true
				end

				if check then
					return true, placa, vnetid
				else
					return false, nil
				end
			else
				return false, nil
			end
		else
			return false, nil
		end
	else
		return false, nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- startRadio
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.checkPermissions(index)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = cfg.Zones[index]
		if data.permissions ~= nil then
			for k, v in pairs(data.permissions) do
				if vRP.hasPermission(user_id,v) then
					return true
				end
			end
			return false
		end
		return false
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ChangeVolume
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:ChangeVolume")
AddEventHandler("ps_tify:ChangeVolume", function(vol, nome)
    local somafter = false
    local rangeafter = false
    for i = 1, #cfg.Zones do
        local v = cfg.Zones[i]
        if nome == v.name then
            local vadi = v.volume + vol
            if vadi <= 1.01 and vadi >= -0.001 then
				if vadi < 0.005 then
					vadi = 0.0
				end
                if v.popo then
                    v.range = (v.volume*cfg.DistanceToVolume)
                else
					if vadi >= 0.05 then
						v.range = (vadi*v.range)/v.volume
					end
                end
                v.volume = vadi
                somafter = v.volume
                rangeafter = v.range
            end
        end
    end
    if somafter and rangeafter then
        TriggerClientEvent("ps_tify:ChangeVolume",-1,somafter,rangeafter, nome)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ChangeLoop
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:ChangeLoop")
AddEventHandler("ps_tify:ChangeLoop", function(nome,tip)
	local loopstate
	for i = 1, #cfg.Zones do
		local v = cfg.Zones[i]
		if nome == v.name then
			v.loop = tip
			loopstate = v.loop
		end
	end
	if loopstate ~= nil then
		TriggerClientEvent("ps_tify:ChangeLoop",-1,loopstate, nome)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ChangeState
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:ChangeState")
AddEventHandler("ps_tify:ChangeState", function(type, nome)
	for i = 1, #cfg.Zones do
		local v = cfg.Zones[i]
		if nome == v.name then
			v.isplaying = type
		end
	end
	TriggerClientEvent("ps_tify:ChangeState",-1,type, nome)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ChangePosition
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:ChangePosition")
AddEventHandler("ps_tify:ChangePosition", function(quanti, nome)
	for i = 1, #cfg.Zones do
		local v = cfg.Zones[i]
		if nome == v.name then
			v.deftime = v.deftime+quanti
			if v.deftime < 0 then
				v.deftime = 0
			end
		end
	end
	TriggerClientEvent("ps_tify:ChangePosition",-1,quanti, nome)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ModifyURL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:ModifyURL")
AddEventHandler("ps_tify:ModifyURL", function(data)
	local _data = data
	local zena = false
	for i = 1, #cfg.Zones do
		local v = cfg.Zones[i]
		if _data.name == v.name then
			v.deflink = _data.link
			if _data.popo then
				v.popo = _data.popo
			end
			v.deftime = 0
			v.isplaying = true
			v.loop = _data.loop
			zena = v
		end
	end
	if zena then
		TriggerClientEvent("ps_tify:ModifyURL",-1,zena)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- countTime
-----------------------------------------------------------------------------------------------------------------------------------------
function countTime()
    SetTimeout(1000, countTime)
    for i = 1, #cfg.Zones do
		local v = cfg.Zones[i]
        if v.isplaying then
            v.deftime = v.deftime + 1
        end
    end
end

SetTimeout(1000, countTime)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AddVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:AddVehicle")
AddEventHandler("ps_tify:AddVehicle", function(vehdata)
    local Data = {}
    Data.name = vehdata.plate
    Data.coords = vehdata.coords
    Data.range = vehdata.volume * cfg.DistanceToVolume
    Data.volume = vehdata.volume
    Data.deflink = vehdata.link
    Data.isplaying = true
    Data.loop = vehdata.loop
    Data.deftime = 0
    Data.popo = vehdata.popo
    table.insert(cfg.Zones, Data)
    TriggerClientEvent('ps_tify:AddVehicle', math.floor(-1), cfg.Zones[#cfg.Zones])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GetDate
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_tify:GetDate")
AddEventHandler("ps_tify:GetDate", function()
    TriggerClientEvent("ps_tify:SendData", math.floor(-1), cfg.Zones)
end)