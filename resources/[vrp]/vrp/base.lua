local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local config = module("nxgroup_inventario", "config")

vRP = {}
Proxy.addInterface("vRP",vRP)

tvRP = {}
Tunnel.bindInterface("vRP",tvRP)
vRPclient = Tunnel.getInterface("vRP")

vRP.users = {}
vRP.rusers = {}
vRP.user_tables = {}
vRP.user_tmp_tables = {}
vRP.user_sources = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------

local webhookentrada = "https://discord.com/api/webhooks/1055814312192643072/feKHWncHUH1F4UzBv_dZtX25drQmG8vFt7sFER4yuY0rj2Db4naJ0yQHMdBM4E8E0bzC"
local webhookentradaIP = "https://discord.com/api/webhooks/1055814437619114024/-fC_RkIZGPBsPaognYn-N0U3sk1hZHpYmjuf5F_03oYFXX6CwL730M-GKuRzZpeicgF4"
local webhooksaida = "https://discord.com/api/webhooks/1055814624714440704/NEdX7PPVLquIIce_4HnwVL5OL0r5MZQzujbnUgmHIp-IyYlyHMgHKhiedRVz55CmWGKu"
local webhooksaidaIP = "https://discord.com/api/webhooks/1055814740724686928/gBQrLdnQkavM3cFh1Yuhjcfrr5RRzF4nKZHUBoVwhki12ECr9hfG5yvD-HOKvmZgwMzT"
local webhookjoinmoney = "https://discord.com/api/webhooks/1055815035995291720/-028CCdUiFw9GQ13uipjq5XBr-WWIa2sIq5AAMc_Otm7_---mMzGGaRqT7TaklgWzKb7"
local webhooksaidamoney = "https://discord.com/api/webhooks/1055815240803164232/7kA_WPBkisfaX5egu2-u4zGKxXDNoy9fJBa9Zm-hzJ8MImY_pjGVDvIS-JO9m58zjyDO"

local webhookquitarma = "https://discord.com/api/webhooks/1055815302966952037/Eq94GkPdD7YQHNYIHyVmCCOOiEySdlXfaEnmPWTTsvD8I7H_o8AnqQ4hnReqU1JJ9nSG"
local webhookQuitVida = "https://discord.com/api/webhooks/1055815343802695701/QLTpWpHxkRsWSWcDhTV33EOycy6EF8Y-omuqTlijXHfkdKLmkQqWrWpPNalLZL9Z5CLt"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- BANCO DE DADOS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local db_drivers = {}
local db_driver
local cached_prepares = {}
local cached_queries = {}
local prepared_queries = {}
local db_initialized = false
local ignoreWhitelist = false

function vRP.registerDBDriver(name,on_init,on_prepare,on_query)
	if not db_drivers[name] then
		db_drivers[name] = { on_init,on_prepare,on_query }
		db_driver = db_drivers[name]
		db_initialized = true

		for _,prepare in pairs(cached_prepares) do
			on_prepare(table.unpack(prepare,1,table.maxn(prepare)))
		end

		for _,query in pairs(cached_queries) do
			query[2](on_query(table.unpack(query[1],1,table.maxn(query[1]))))
		end

		cached_prepares = nil
		cached_queries = nil
	end
end

function vRP.prepare(name,query)
	prepared_queries[name] = true

	if db_initialized then
		db_driver[2](name,query)
	else
		table.insert(cached_prepares,{ name,query })
	end
end

function vRP.query(name,params,mode)
	if not mode then mode = "query" end

	if db_initialized then
		return db_driver[3](name,params or {},mode)
	else
		local r = async()
		table.insert(cached_queries,{{ name,params or {},mode },r })
		return r:wait()
	end
end

function vRP.execute(name,params)
	return vRP.query(name,params,"execute")
end

function vRP.setUData(user_id,key,value)
	exports["oxmysql"]:executeSync([[
		REPLACE INTO `vrp_user_data`(`user_id`,`dkey`,`dvalue`) VALUES(?,?,?)
	]],{ 
		user_id,key,value
	})
end

function vRP.getUData(user_id,key,cbr)
	local rows = exports["oxmysql"]:singleSync("SELECT `dvalue` FROM `vrp_user_data` WHERE `user_id` = ? AND `dkey` = ? ", { user_id,key })
	if rows then 
		return rows.dvalue
	end
	return ""
end

function vRP.remUData(user_id,key)
	vRP.execute("vRP/rem_u_data",{ user_id = parseInt(user_id), key = key })
end

function vRP.setSData(key,value)
	exports["oxmysql"]:executeSync([[
		REPLACE INTO `vrp_srv_data`(`dkey`,`dvalue`) VALUES(?,?)
	]],{ 
		key,value
	})
end

function vRP.remSrvdata(dkey)
	vRP.execute("creative/rem_srv_data",{ dkey = dkey })
end

function vRP.getSData(key, cbr)
	local rows = exports["oxmysql"]:singleSync("SELECT `dvalue` FROM `vrp_srv_data` WHERE `dkey` = ?", { key })
	if rows then 
		return rows.dvalue
	end
	return ""
end

function vRP.getUserIdByIdentifier(ids)
	local rows = vRP.query("vRP/userid_byidentifier", {identifier = ids})
	if #rows > 0 then
		return rows[1].user_id
	else
		return -1
	end
end

function vRP.getUserIdByIdentifiers(ids)
	if ids and #ids then
		for i=1,#ids do
			if (string.find(ids[i],"ip:") == nil) then
				local rows = vRP.query("vRP/userid_byidentifier",{ identifier = ids[i] })
				if #rows > 0 then
					return rows[1].user_id
				end
			end
		end

		local rows = exports["oxmysql"]:executeSync([[INSERT INTO vrp_users(whitelisted,banned) VALUES(false,false)]])
		if rows then
			local user_id = rows.insertId

			for l,w in pairs(ids) do
				if (string.find(w,"ip:") == nil) then
					vRP.execute("vRP/add_identifier",{ user_id = user_id, identifier = w })
				end
			end
			return user_id
		end
	end
end

-- MATHLEGTH
-----------------------------------------------------------------------------------------------------------------------------------------
function mathLegth(n)
    return math.ceil(n*100) / 100
end
-- SAVE CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateHomes(user_id,x,y,z)
    if not vRP.getUserSource(parseInt(user_id)) then 
        local data = json.decode(vRP.getUData(user_id,"vRP:datatable")) or {}
        data.position = { x = mathLegth(x), y = mathLegth(y), z = mathLegth(z) }
        vRP.setUData(user_id,"vRP:datatable",json.encode(data))
    else
        vRP.user_tables[parseInt(user_id)]["position"] = { x = mathLegth(x), y = mathLegth(y), z = mathLegth(z) }
    end
end


function vRP.format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end


						   											  -- VALUES(true,false)") WL DESATIVADA
vRP.prepare("vRP/create_user","INSERT INTO vrp_users(whitelisted,banned) VALUES(false,false)") -- WL ATIVA
vRP.prepare("vRP/add_identifier","INSERT INTO vrp_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
vRP.prepare("vRP/userid_byidentifier","SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier")
vRP.prepare("vRP/set_userdata","REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
vRP.prepare("vRP/get_userdata","SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key")
vRP.prepare("vRP/set_srvdata","REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)")
vRP.prepare("vRP/get_srvdata","SELECT dvalue FROM vrp_srv_data WHERE dkey = @key")
vRP.prepare("vRP/get_banned","SELECT banned FROM vrp_users WHERE id = @user_id")
vRP.prepare("vRP/set_banned","UPDATE vrp_users SET banned = @banned WHERE id = @user_id")
vRP.prepare("vRP/get_whitelisted","SELECT whitelisted FROM vrp_users WHERE id = @user_id and whitelisted = 1")
vRP.prepare("vRP/set_whitelisted","UPDATE vrp_users SET whitelisted = @whitelisted WHERE id = @user_id")

function vRP.toggleWhitelistStatus()
	ignoreWhitelist = not ignoreWhitelist
	return not ignoreWhitelist
end

function vRP.getPlayerEndpoint(player)
	return GetPlayerEP(player) or "0.0.0.0"
end

function vRP.isBanned(user_id, cbr)
	local rows = vRP.query("vRP/get_banned",{ user_id = user_id })
	if #rows > 0 then
		return rows[1].banned
	else
		return false
	end
end

function vRP.setBanned(user_id,banned)
	vRP.execute("vRP/set_banned",{ user_id = user_id, banned = banned })
end

function vRP.isWhitelisted(user_id, cbr)
	local rows = vRP.query("vRP/get_whitelisted",{ user_id = user_id })
	if #rows > 0 then
		return rows[1].whitelisted
	else
		return false
	end
end

function vRP.setWhitelisted(user_id,whitelisted)
	vRP.execute("vRP/set_whitelisted",{ user_id = user_id, whitelisted = whitelisted })
end

function vRP.checkWhitelist(user_id)
	if ignoreWhitelist then
		vRP.execute("vRP/set_whitelisted",{ user_id = user_id, whitelisted = true })
		return true
	else
		return false
	end
end

function vRP.getUserDataTable(user_id)
	return vRP.user_tables[user_id]
end

function vRP.getUserTmpTable(user_id)
	return vRP.user_tmp_tables[user_id]
end

function vRP.getUserId(source)
	if source ~= nil then
		local ids = GetPlayerIdentifiers(source)
		if ids ~= nil and #ids > 0 then
			return vRP.users[ids[1]]
		end
	end
	return nil
end

function vRP.getUsers()
	local users = {}
	for k,v in pairs(vRP.user_sources) do
		users[k] = v
	end
	return users
end

function vRP.getUserSource(user_id)
	return vRP.user_sources[user_id]
end

function vRP.kick(source,reason)
	DropPlayer(source,reason)
end

function vRP.dropPlayer(source,reason, data)
	local source = source
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(source)))
	local user_id = vRP.getUserId(source)
	local banco = vRP.getBankMoney(user_id)
	local HandMoney = vRP.getMoney(user_id)

	local sdata = vRP.getUserDataTable(user_id)
	if sdata and (data.coords and data.coords ~= vec3(0.0,0.0,0.0)) then 
		-- if data.health then 
		-- 	sdata.health = data.health 
		-- end
		if data.armour then 
			sdata.colete = data.armour 
		end
		if data.coords then 
			sdata.position = {x = data.coords.x, y = data.coords.y, z = data.coords.z} 
		end
	end

	if user_id then
		if user_id and source then
			TriggerEvent("vRP:playerLeave",user_id,source)
			local ped = GetPlayerPed(source)
			local health = GetEntityHealth(ped)

			if sdata.health then
				SendWebhookMessage(webhookQuitVida,"```prolog\n[ID]: "..user_id.."  \n[VIDA QUE SAIU DO SERVIDOR]: "..sdata.health..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

				if sdata.health == 0 then
					
					if reason ~= "Server shutting down: SIGHUP received" and reason ~= "Você foi vitima do terremoto." then				
						for k,v in pairs(sdata.inventory) do
							local qtd_item = v.amount
							if  config.itemlist[k].type == "equipar" or config.itemlist[k].type == "recarregar" then
								SendWebhookMessage(webhookquitarma,"```prolog\n[ID]: "..user_id.."  \n[MOTIVO]: " .. reason .. "\n[ITEM]: "..k.." \n[QUANTIDADE]: " .. qtd_item .. " "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								vRP.tryGetInventoryItem(user_id,k,v.amount)
							end
						end
						for k,v in pairs(sdata.weapons) do
							vRP.remove_weapon_table(user_id,k)
							SendWebhookMessage(webhookquitarma,"```prolog\n[ID]: "..user_id.."  \n[MOTIVO]: " .. reason .. "\n[ARMA]: "..k.." \n[MUNICAO]: " ..v.ammo.. " "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						end
					end
				end
			end


			SendWebhookMessage(webhooksaida,"```prolog\n[ID]: "..user_id.." \n[=========SAIU DO SERVIDOR=========]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."\n[MOTIVO]: "..reason.."\n COORDENADAS: "..x..","..y..","..z.." \r``` ")
			SendWebhookMessage(webhooksaidamoney,"```prolog\n[=========PLAYER DROP=========] \n[ID]:" ..user_id.. "\n[BANCO]" ..banco.. " \n[DINHEIRO]"..HandMoney.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."  \n \r```")
			
			if GetPlayerEndpoint(source) ~= nil then
				SendWebhookMessage(webhooksaidaIP,"```prolog\n[ID]: "..user_id.." \n[IP]: "..GetPlayerEndpoint(source).." \n[=========SAIU DO SERVIDOR=========]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."\n COORDENADAS: "..x..","..y..","..z.."\r```")
			end
			
			local identity = vRP.getUserIdentity(user_id)

			if vRP.hasGroup(user_id,"policia") then
				vRP.addUserGroup(user_id,"paisana-policia")

				SendWebhookMessage(webhookpoliciaponto,"```prolog\n[ID]: "..user_id.." \n[=========SAIU DE SERVICO=========]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."\r```")


			elseif vRP.hasGroup(user_id,"paramedico") then
				vRP.addUserGroup(user_id,"paisana-paramedico")

				SendWebhookMessage(webhookemsponto,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[=========SAIU DE SERVICO=========]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."\r```")

			end
		end
		
		vRP.setUData(user_id,"vRP:datatable",json.encode(sdata))

		vRP.users[vRP.rusers[user_id]] = nil
		vRP.rusers[user_id] = nil
		vRP.user_tables[user_id] = nil
		vRP.user_tmp_tables[user_id] = nil
		vRP.user_sources[user_id] = nil
	end
end

function task_save_datatables()
	SetTimeout(300*1000,task_save_datatables)
	local count = 0
	for k,v in pairs(vRP.user_tables) do
		count = count + 1
		vRP.setUData(k,"vRP:datatable",json.encode(v))
	end

	print("Contas Salvas: "..count)
end

async(function()
	task_save_datatables()
end)

-- tempBan = Proxy.getInterface('muamba_tempBan')

-- AddEventHandler("queue:playerConnecting",function(source,ids,name,setKickReason,deferrals)
-- 	deferrals.defer()
-- 	local source = source
-- 	local ids = ids

-- 	if ids ~= nil and #ids > 0 then
-- 		deferrals.update("Carregando identidades.")
-- 		local user_id = vRP.getUserIdByIdentifiers(ids)
-- 		local nsource = vRP.getUserSource(user_id)
-- 		if(nsource~=nil)then
-- 		  if(GetPlayerName(nsource)~=nil)then
-- 			deferrals.done("Você está bugado, reinicie o fivem!")
-- 			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
-- 			return
-- 		  end
-- 		end

-- 		if user_id then
-- 			deferrals.update("Carregando banimentos.")

-- 			-- TriggerEvent("testebantemp",user_id,source)
-- 			-- Wait(1000)

-- 			-- local check,time = exports.thunder_tempban:checkBan(user_id, source)	
-- 			-- if not check then
				
-- 				if not vRP.isBanned(user_id) then
-- 					deferrals.update("Carregando whitelist.")
-- 						-- --local check,date = tempBan.checkBan(user_id)
-- 						-- local check = true
-- 						-- if check then
-- 							if vRP.rusers[user_id] == nil then
-- 								deferrals.update("Carregando banco de dados.")
-- 								local sdata = vRP.getUData(user_id,"vRP:datatable")

-- 								vRP.users[ids[1]] = user_id
-- 								vRP.rusers[user_id] = ids[1]
-- 								vRP.user_tables[user_id] = {}
-- 								vRP.user_tmp_tables[user_id] = {}
-- 								vRP.user_sources[user_id] = source

-- 								local data = json.decode(sdata)
-- 								if type(data) == "table" then vRP.user_tables[user_id] = data end

-- 								local tmpdata = vRP.getUserTmpTable(user_id)
-- 								tmpdata.spawns = 0

-- 								TriggerEvent("vRP:playerJoin",user_id,source,name)
-- 								SendWebhookMessage(webhookentrada,"```prolog\n [ID]: "..user_id.."  \n[=========ENTROU NO SERVIDOR=========]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."\r```")
-- 								deferrals.done()
-- 							else

-- 								if(vRP.user_sources[user_id]~=nil)then
-- 									if(GetPlayerName(vRP.user_sources[user_id])~=nil)then
-- 									deferrals.done("[MQCU] Você está bugado, reinicie o fivem!")
-- 									TriggerEvent("queue:playerConnectingRemoveQueues",ids)
-- 									return
-- 									end
-- 								end
								
-- 								local tmpdata = vRP.getUserTmpTable(user_id)
-- 								tmpdata.spawns = 0


-- 								TriggerEvent("vRP:playerRejoin",user_id,source,name)
-- 								deferrals.done()
-- 							end
-- 					else
-- 						deferrals.done("Mande seu ID nosso Discord! [ discord.gg/cidadethunder ][ ID: "..user_id.." ]")
-- 						TriggerEvent("queue:playerConnectingRemoveQueues",ids)
-- 					end
-- 				else
-- 					deferrals.done("Você foi banido! [ Compre seu unban: discord.gg/cidadethunder ] [ ID: "..user_id.." ] ")
-- 					--print(user_id)
-- 					TriggerEvent("queue:playerConnectingRemoveQueues",ids)
-- 				end
-- 		else
-- 			deferrals.done("Ocorreu um problema de identificação.")
-- 			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
-- 		end
-- 		deferrals.done("Ocorreu um problema de identidade.")
-- 		TriggerEvent("queue:playerConnectingRemoveQueues",ids)
-- 	end)

-- AddEventHandler("playerDropped",function(reason)
-- 	local source = source
-- 	local ped = GetPlayerPed(source)

-- 	vRP.dropPlayer(source,reason,{
-- 		-- health = GetEntityHealth(ped),
-- 		armour = GetPedArmour(ped),
-- 		coords = GetEntityCoords(ped),
-- 	})
-- end)

AddEventHandler("queue:playerConnecting",function(source,ids,name,setKickReason,deferrals)
	deferrals.defer()
	local source = source
	local ids = ids

	if ids ~= nil and #ids > 0 then
		deferrals.update("Carregando...")
		local user_id = vRP.getUserIdByIdentifiers(ids)
		if user_id then
			deferrals.update("Verificando se você está banido.")
			if not vRP.isBanned(user_id) then
				deferrals.update("Verificando seu IP...")
				if vRP.isWhitelisted(user_id) then
					if vRP.rusers[user_id] == nil then
						deferrals.update("Carregando banco de dados.")
						local sdata = vRP.getUData(user_id,"vRP:datatable")

						vRP.users[ids[1]] = user_id
						vRP.rusers[user_id] = ids[1]
						vRP.user_tables[user_id] = {}
						vRP.user_tmp_tables[user_id] = {}
						vRP.user_sources[user_id] = source

						local data = json.decode(sdata)
						if type(data) == "table" then vRP.user_tables[user_id] = data end

						local tmpdata = vRP.getUserTmpTable(user_id)
						tmpdata.spawns = 0

						TriggerEvent("vRP:playerJoin",user_id,source,name)
						SendWebhookMessage(webhookjoins,"```prolog\n[ID]: "..user_id.." \n[IP]: "..GetPlayerEndpoint(source).." \n[ENTROU NO SERVIDOR]: "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						deferrals.done()
					else
						local tmpdata = vRP.getUserTmpTable(user_id)
						tmpdata.spawns = 0

						TriggerEvent("vRP:playerRejoin",user_id,source,name)
						deferrals.done()
					end
				else
					deferrals.done("[AZTLAN] Entre no nosso Discord: https://discord.gg/tSxveGVB9q e libere seu ID:"..user_id)
					TriggerEvent("queue:playerConnectingRemoveQueues",ids)
				end
			else
				deferrals.done("[AZTLAN] Você foi banido entre em nosso discord para recorrer. https://discord.gg/tSxveGVB9q")
				--print(user_id)
				TriggerEvent("queue:playerConnectingRemoveQueues",ids)
			end
		else
			deferrals.done("Ocorreu um problema de identificação.")
			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
		end
	else
		deferrals.done("Ocorreu um problema de identidade.")
		TriggerEvent("queue:playerConnectingRemoveQueues",ids)
	end
end)

RegisterServerEvent("vRPcli:playerSpawned")
AddEventHandler("vRPcli:playerSpawned",function()
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.user_sources[user_id] = source
		local tmp = vRP.getUserTmpTable(user_id)
		tmp.spawns = tmp.spawns+1
		local first_spawn = (tmp.spawns == 1)

		if first_spawn then
			Tunnel.setDestDelay(source,0)
		end
		TriggerEvent("vRP:playerSpawn",user_id,source,first_spawn)
	end
end)


function vRP.getDayHours(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)

    if days > 0 then
        return string.format("<b>%d Dias</b> e <b>%d Horas</b>",days,hours)
    else
        return string.format("<b>%d Horas</b>",hours)
    end
end

function vRP.getMinSecs(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds/60)
    seconds = seconds - minutes * 60

    if minutes > 0 then
        return string.format("<b>%d Minutos</b> e <b>%d Segundos</b>",minutes,seconds)
    else
        return string.format("<b>%d Segundos</b>",seconds)
    end
end

vRP.removeWeaponDataTable = function(user_id,weapon)
	if user_id then
		if vRP.user_tables[user_id].weapons and vRP.user_tables[user_id].weapons[weapon] then
			vRP.user_tables[user_id].weapons[weapon] = nil
			return true
		else
			return false
		end
	end
end
vRP.getWeaponsDataTable = function(user_id)
	if user_id then
		if vRP.user_tables[user_id].weapons then
			return vRP.user_tables[user_id].weapons
		end
	end
end

vRP.remove_weapon_table = function(user_id,index)
    if vRP.user_tables[user_id].weapons then
        for k,v in pairs(vRP.user_tables[user_id].weapons) do
            vRP.user_tables[user_id].weapons[index] = nil
        end
        vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))
    end
end