-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
local Tunnel = module("vrp","lib/Tunnel")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Nexus = {}
Tunnel.bindInterface("gm", Nexus)

vRP.prepare("donate/get","SELECT * FROM groups_donates WHERE user_id = @user_id AND groupname = @groupname")
vRP.prepare('donate/update','REPLACE INTO groups_donates(user_id,groupname,donate) VALUES(@user_id,@groupname,@donate)')
vRP.prepare('control/get_money','SELECT money FROM groups_control WHERE name = @name')

vRP.prepare('control/getMaps','SELECT * FROM groups_maps')
vRP.prepare('control/getMapsOrg','SELECT * FROM groups_maps WHERE name = @name')
vRP.prepare('control/insertMap','INSERT INTO groups_maps(name,maps) VALUES (@name,@maps)')
vRP.prepare('control/updateMap','UPDATE groups_maps SET maps = @maps WHERE name = @name')

vRP.prepare('control/update_money','UPDATE groups_control SET money = @money WHERE name = @name')
vRP.prepare('control/Create','INSERT INTO groups_control(name,money) VALUES (@name,@money)')

open = {}

function vRP.getUsersByGroup(perm)
	local users = {}
	for k,v in pairs(vRP.getUsers()) do
		if vRP.hasGroup(tonumber(k),perm) then
			table.insert(users,tonumber(k))
		end
	end
	return users
end

RegisterCommand('ilegal', function(source,args,rawCommand)
	print('entrou aqui ')
	local source = source
	local user_id = vRP.getUserId(source)
	local mygroup = nil
	for k,v in pairs(config.organizations) do
		for l,w in pairs(v.groups) do
			if vRP.hasGroup(user_id,w) then
				open[user_id] = k
				mygroup = w
			end
		end
	end
	if open[user_id] then
		local group_members = {}
		local members_list = {}
		local num_members = {}
		local members_get = {}
		local org_money = vRP.query('control/get_money', {name = open[user_id]})
		local money = 0
		if org_money[1] then
			money = org_money[1].money
		end
		for k,v in pairs(config.organizations[open[user_id]].groups) do
			local member = vRP.getUsersByGroup(v)
			for l,w in pairs(member) do
				local allname = vRP.getUserIdentity(w)
				local donates = vRP.query("donate/get",{user_id = w, groupname = open[user_id]}) or {}
				local stats = vRP.getUserSource(w)
				local status = 1
				if stats then
					status = 0
				end
				local d_value = 0
				if donates[1] then
					d_value = donates[1].donate
				end
				local temp_tbl = {
					name = allname.name..' '..allname.firstname,
					user_id = w,
					org_group = v,
					last_login = "Indisponível",
					donated_money = d_value,
					status = status
				}
				table.insert(members_list,temp_tbl)		
			end
		end

		local is_mod = false
		for k,v in pairs(config.organizations[open[user_id]].modGroups) do
			if mygroup == v then
				is_mod = true
			end
		end

		local is_owner = false
		if config.organizations[open[user_id]].ownerGroup == mygroup then
			is_owner = true
		end
		TriggerClientEvent("gm:openUI", source, open[user_id], mygroup, members_list, is_mod, is_owner, user_id, money)
	else
		TriggerClientEvent('Notify',source,'vermelho','Você não é líder de uma organização')
	end
end)


function Nexus.SyncIpls()
	local source = source
	local maps = vRP.query('control/getMaps', {})
	if maps[1] then
		for k,v in pairs(maps) do
			local ipls = json.decode(v.maps)
			for l,w in pairs(ipls) do
				TriggerClientEvent("gm:setipl", source, l, w, v.name)
			end
		end
	end
end

function Nexus.buyMap(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local mapinfos = config.organizations[open[user_id]].mapImprovements[id]
		local org_money = vRP.query('control/get_money', { name = open[user_id]})
		if org_money[1] and (org_money[1].money >= mapinfos.price) then
			local new = org_money[1].money - mapinfos.price
			local maps = vRP.query('control/getMapsOrg', { name = open[user_id] })
			if maps[1] then
				local info = json.decode(maps[1].maps)
				info[mapinfos.ipl] = true
				vRP.execute('control/updateMap', {maps = json.encode(info), name = open[user_id]})
			else
				local info = {}
				info[mapinfos.ipl] = true
				vRP.execute('control/insertMap', {maps = json.encode(info), name = open[user_id]})
			end
			vRP.execute('control/update_money', {money = new, name = open[user_id]})
			TriggerClientEvent("gm:setipl", -1, mapinfos.ipl, true, open[user_id])
			return true
		else
			TriggerClientEvent('Notify',source,'sucesso','A organização não possui fundos o suficiente para isso!')
			return false
		end
		return false
	end
end


function Nexus.inviteMember(id,id_group)
	local source = source
	local user_id = vRP.getUserId(source)
	local nsource = vRP.getUserSource(parseInt(id))
	if nsource then
		local group = config.organizations[open[user_id]].groups[id_group]
		if vRP.request(nsource, 'Você foi convidado para entrar para uma organização, deseja entrar?', 30) then
			vRP.addUserGroup(user_id,group)
			TriggerClientEvent("Notify",source,"sucesso","Passaporte <b>"..vRP.format(id).."</b> adicionado com sucesso.",5000)
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Pedido recusado",5000)
		end
	else
		TriggerClientEvent("Notify",source,"negado","Usuário ERRADO ou encontra-se OFFLINE",5000)
	end
end


vRP.prepare("donate/del","DELETE FROM groups_donates WHERE user_id = @user_id AND groupname = @groupname")

removeGroupDemitido = function(id, user_id)
	local group = vRP.query('vRP/get_perm', {user_id = id})
	local mygroup = nil
	for k,v in pairs(group) do
		for l,w in pairs(config.organizations[open[user_id]].groups) do
			if v.permiss == w then
				mygroup = { group = w, id = l }
			end
		end
	end

	if mygroup ~= nil and mygroup.id  then
		vRP.execute("vRP/del_group",{ user_id = parseInt(id), permiss = mygroup.group })
		vRP.execute('donate/del', { user_id = id, groupname = open[user_id] })
		open[user_id] = nil
		TriggerClientEvent("gm:closeUI",vRP.getUserSource(user_id))
		return true, nil
	end
	return false
end

function removeGroup(id, user_id)
	local mygroup = nil
	for l,w in pairs(config.organizations[open[user_id]].groups) do
		if vRP.hasGroup(parseInt(id),w) then
			mygroup = { group = w, id = l }
		end
	end
	
	if mygroup.id == #config.organizations[open[user_id]].groups then
		vRP.removeUserGroup(parseInt(id),mygroup.group)
		vRP.execute('donate/del', { user_id = id, groupname = open[user_id] })
		open[user_id] = nil
		TriggerClientEvent("gm:closeUI",vRP.getUserSource(user_id))
		return true, nil
	else
		local value = mygroup.id + 1
		local newgroup = config.organizations[open[user_id]].groups[value]
		vRP.removeUserGroup(parseInt(id),mygroup.group)
		vRP.addUserGroup(parseInt(id),newgroup)
		open[user_id] = nil
		TriggerClientEvent("gm:closeUI",vRP.getUserSource(user_id))
		return true, newgroup
	end
	return false
end

function addGroup(id, user_id)
	local mygroup = nil
	for l,w in pairs(config.organizations[open[user_id]].groups) do
		if vRP.hasGroup(parseInt(id),w) then
			mygroup = { group = w, id = l }
		end
	end
	if mygroup.group == config.organizations[open[user_id]].groups[1] then
		TriggerClientEvent("Notify",vRP.getUserSource(user_id),"negado","Esse usuário já esta no maior cargo!",5000)
		return false
	else
		local value = mygroup.id - 1
		local newgroup = config.organizations[open[user_id]].groups[value]
		vRP.removeUserGroup(parseInt(id),mygroup.group)
		vRP.addUserGroup(parseInt(id),newgroup)
		open[user_id] = nil
		TriggerClientEvent("gm:closeUI",vRP.getUserSource(user_id))
		return true, newgroup
	end
	return false
end

function Nexus.unpromote(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return removeGroup(id, user_id)
	end
end

function Nexus.demitido(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return removeGroupDemitido(id, user_id)
	end
end

function Nexus.promote(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return addGroup(id, user_id)
	end
end

function Nexus.donateMoney(qtd)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.getBankMoney(user_id) >= qtd then
		local value = vRP.query('donate/get', {user_id = user_id, groupname = open[user_id]})
		local org_money = vRP.query('control/get_money', {name = open[user_id]})
		local newvalue = qtd
		if org_money[1] then
			newvalue = newvalue + org_money[1].money
		else
			vRP.execute('control/Create', {money = 0, name = open[user_id]})
		end
		local donate = qtd
		if value[1] then
			donate = donate + value[1].donate
		end
		vRP.setBankMoney(user_id,vRP.getBankMoney(user_id)-qtd)
		vRP.execute('control/update_money', {money = newvalue, name = open[user_id]})
		vRP.execute('donate/update', {donate = donate, groupname = open[user_id], user_id = user_id})
		TriggerClientEvent("Notify",source ,"importante","Dinheiro doado",10000)
		return true
	end
end

function Nexus.transactionMoney(qtd, nuser_id)
	local source = source
	local uplayer = vRP.getUserSource(nuser_id)
	local user_id = vRP.getUserId(source)
	local org_money = vRP.query('control/get_money', {name = open[user_id]})
	if org_money[1].money >= qtd then		
		local newvalue = qtd
		if org_money[1] then
			newvalue =  org_money[1].money - newvalue 
		else
			vRP.execute('control/Create', {money = 0, name = open[user_id]})
		end
		local donate = qtd
		local value = vRP.query('donate/get', {user_id = user_id, groupname = open[user_id]})
		if value[1] then
			donate = qtd - donate 
		else 
			donate = 0 - qtd
		end
		
		vRP.setBankMoney(nuser_id,vRP.getBankMoney(nuser_id)+qtd)
		vRP.execute('control/update_money', {money = newvalue, name = open[user_id]})
		vRP.execute('donate/update', {donate = donate, groupname = open[user_id], user_id = user_id})
		TriggerClientEvent("Notify",uplayer,"importante","Um doador te enviou <b>" .. qtd .. " dolares</b>.",10000)
		TriggerClientEvent("Notify",source ,"importante","Dinheiro enviado",10000)
						
		return true
	end
end


RegisterServerEvent("gm:closeUI")
AddEventHandler("gm:closeUI",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		open[user_id] = nil
	end
end)