local Tunnel               = module("vrp", "lib/Tunnel")
local Proxy                = module("vrp", "lib/Proxy")
local cooldown             = false
vRP                        = Proxy.getInterface("vRP")
yRPS                       = Tunnel.getInterface(GetCurrentResourceName())
vRPS 					   = {}
src                        = {}
Proxy.addInterface(GetCurrentResourceName(), vRPS)
Tunnel.bindInterface(GetCurrentResourceName(), src)

vRP.prepare('control/update_members','UPDATE groups_control SET num_members = @members WHERE name = @name')
vRP.prepare('control/getgroup','SELECT * FROM groups_control WHERE name = @name')
vRP.prepare('control/getallgroups','SELECT * FROM groups_control')
vRP.prepare("donate/get","SELECT * FROM groups_donates WHERE user_id = @user_id AND groupname = @groupname")
vRP.prepare('donate/get','SELECT donate FROM groups_donates WHERE user_id = @user_id AND groupname = @groupname')
vRP.prepare('donate/update','REPLACE INTO groups_donates(user_id,groupname,donate) VALUES(@user_id,@groupname,@donate)')
vRP.prepare('control/get_money','SELECT money FROM groups_control WHERE name = @name')
vRP.prepare('control/update_money','UPDATE groups_control SET money = @money WHERE name = @name')
vRP.prepare("control/get_ip","SELECT * FROM account WHERE steam = @steam")

local open = {}
local Perm = {}
local user_groups = {}
local opened = {}

RegisterCommand('org', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	for k,v in pairs(cfg.emps) do
		if vRP.hasPermission(user_id,v.perm) then
			open[user_id] = k
			Perm[user_id] = v.perm
		end
	end
	if open[user_id] then
		for kk,_data in pairs(cfg.emps) do
			if vRP.hasPermission(user_id,_data.perm) then
				local group = kk
				local group_data = vRP.query('control/getgroup',{name = group})[1]
				local group_members = {}
				local members_list = {}
				local num_members = {}
				local members_get = {}
				local roles = json.decode(group_data.roles) or {}	
				group_data.roles = roles
				for a,b in pairs(roles) do
					group_members[b] = {}
					--print(a,b)
					table.insert(group_members[b],a)
					-- if hasGroup(user_id,b) then 
					-- 	print(a)
					-- 	--table.insert(group_members[b],d)
					-- end
					-- local teste = vRP.query('creative/get_id_by_perm',{perm = b})
					-- group_members[b] = {}
					-- for c,d in pairs(teste) do
					-- 	table.insert(group_members[b],d)
					-- end
				end
				for k,v in pairs(group_members) do
					for c,d in pairs(v) do
						if not members_get[d] then
							members_get[d] = true
							local allname = vRP.getUserIdentity(d)
							local donates = vRP.query("donate/get",{user_id = d, groupname = group}) or {}
							local d_value = 0
							local nuser_id = tonumber(d)
							local target = vRP.getUserSource(parseInt(nuser_id))
							local steam = vRP.getSteam(target)
							local GetIP = vRP.query("control/get_ip",{ steam = steam })

							num_members[d] = true
							if donates[1] then
								d_value = donates[1].donate
							end
							local temp_tbl = {
								name = allname.firstname,
								id = d,
								group = k,
								login = GetIP[1].last_login,
								donates = d_value
							}
							table.insert(members_list,temp_tbl)
						end
					end
				end
				group_data.members_list = members_list
				yRPS.init(source,group_data)
				local qtd = #members_list
				vRP.execute('control/update_members',{ members = qtd, name = group})
			end
		end
	else
		TriggerClientEvent('Notify',source,'vermelho','Você não é líder de uma organização')
	end
end)

function src.promote(id,group)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,cfg.emps[open[user_id]].perm) or vRP.hasPermission(user_id,'Owner') then
		local groups = ""
		local groups = removeGroup(id).." "..group
		-- print(group)
		vRP.execute("vRP/add_group",{ user_id = id, permiss = group })
		local painel_set = ""
		SendWebhookMessage(painel_set,"```ini\n[PASSAPORTE]: "..user_id.."\n[SETOU]: "..id.."\n[GRUPOS]: "..groups..""..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```")
		TriggerClientEvent("Notify",source,"sucesso","Passaporte <b>"..vRP.format(id).."</b> adicionado com sucesso.",5000)
		return true
	end
end

function src.invite(id,group)
	local source = source
	local user_id = vRP.getUserId(source)
	local nsource = vRP.getUserSource(parseInt(id))
	if nsource then
		if vRP.hasPermission(user_id,cfg.emps[open[user_id]].perm) or vRP.hasPermission(user_id,'Owner') then
			if vRP.request(nsource, 'Você foi convidado para entrar para uma organização, deseja entrar?', 30) then
				local groups = ""
				local groups = removeGroup(id).." "..group
				vRP.addUserGroup(id,group)
				-- local painel_set = "httGY-YzxIm9g7ONmDOR5dEmqZ4O6PjzXOf8LI5DjIBwNbp4BNq5bfNAyuTe9q9"
				-- SendWebhookMessage(painel_set,"```ini\n[PASSAPORTE]: "..user_id.."\n[SETOU]: "..id.."\n[GRUPOS]: "..groups..""..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```")
				TriggerClientEvent("Notify",source,"sucesso","Passaporte <b>"..vRP.format(id).."</b> adicionado com sucesso.",5000)
				return true
			else
				TriggerClientEvent("Notify",source,"negado","Pedido recusado",5000)
			end
		else
			TriggerClientEvent("Notify",source,"negado","Sem permissão.",5000)
		end
	else
		TriggerClientEvent("Notify",source,"negado","Usuário ERRADO ou encontra-se OFFLINE",5000)
	end
end

vRP.prepare("donate/del","DELETE FROM groups_donates WHERE user_id = @user_id AND groupname = @groupname")
function src.demote(id,group)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,cfg.emps[open[user_id]].perm) then
		removeGroup(id,group)
		vRP.execute('donate/del', { user_id = id, groupname = open[user_id] })
		local painel_set = "WEBHOOK AQUI"
		SendWebhookMessage(painel_set,"```ini\n[PASSAPORTE]: "..user_id.."\n[DEMITIU]: "..id.."\n[GRUPO]: "..open[user_id]..""..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```")
	end
end

function src.close()
	local source = source
	local user_id = vRP.getUserId(source)
	open[user_id] = nil
end

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function removeGroup(id,group)
	local grouplist = ""
	local vips1 = {"bronze","prata","ouro","platina","diamante","magnata","gs"}
	local vips2 = {}
	for k,v in pairs(vips1) do
		if vRP.hasPermission(id, v) then
			table.insert(vips2, {v})
		end
	end
	vRP.removeUserGroup(id,group)
	if #vips2 > 0 then 
		for k,v in pairs(vips2) do
			vRP.execute("vRP/add_group",{ user_id = id, permiss = v[1] })
			grouplist = grouplist.." "..v[1]
		end
	end
	return grouplist
end

function vRPS.addMoney(id,qtd,org)
	local value = vRP.query('donate/get', {user_id = id, groupname = org})
	local org_money = vRP.query('control/get_money', {user_id = id, name = org})[1].money + qtd
	local donate = qtd
	if value[1] then
		donate = donate + value[1].donate
	end
	vRP.execute('control/update_money', {money = org_money, name = org})
	vRP.execute('donate/update', {donate = donate, groupname = org, user_id = id})
end
	

vRP.prepare('groups/insert','REPLACE INTO groups_control(name,type,num_members,money,roles,max_members) VALUES(@name,@type,@num_members,@money,@roles,@max_members)')
vRP.prepare('groups/SELECT','SELECT id,groups FROM vrp_users')

Citizen.CreateThread(function()
	groupst = {}

	groupst.policia = {"coronel"}

	for k,v in pairs(groupst) do
		vRP.execute('groups/insert', {name = k, type = "ILEGAL", num_members = 15, money = 0, roles = tostring(json.encode(v)), max_members = 20})
	end
	--user_groups = vRP.query('groups/SELECT')
	local user_groups_list = vRP.query('control/getallgroups')
	--for a,b in pairs(user_groups) do
		-- if #b.groups > 2 then 
		-- 	for k,v in pairs(json.decode(b.groups)) do
		-- 		if vRP.hasGroup(1707,k) then
		-- 			print(type(a),k)
		-- 		end
		-- 	end
		-- end
		-- for k,v in pairs(user_groups_list) do
		-- 	print
		-- for a,b in pairs(v) do
		-- 	print(a,b)
		-- end
		-- user_groups_list['staff'] = {}
		-- for a,b in pairs(user_groups) do
		-- 	if b and b.groups[] then
		-- 		print(json.encode(b))
		-- 		-- local groupstbl = vRP.getUserGroups(parseInt(a))
		-- 		-- if groupstbl ~= nil then
		-- 		-- 	for u,v in pairs(groupstbl) do
		-- 		-- 		print(u,v)
		-- 		-- 	end
		-- 		-- end
		-- 		-- for x,y in pairs(b) do
		-- 		-- 	if groupstbl and groupstbl[x] ~= nil then
		-- 		-- 		print(x,y)
		-- 		-- 	end
		-- 		-- end
		-- 	end
		-- end

	--end
	-- print(json.encode(user_groups))
end)