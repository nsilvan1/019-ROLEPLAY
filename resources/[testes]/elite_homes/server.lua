local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
-- local sanitizes = module("cfg/sanitizes")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("elite_homes",src)
vCLIENT = Tunnel.getInterface("elite_homes")


vRP.prepare('elite/elite_homes',
    [[
		CREATE TABLE IF NOT EXISTS `elite_homes` (
			`home` varchar(50) DEFAULT NULL,
			`interior` varchar(50) DEFAULT NULL,
			`bau` int(11) DEFAULT NULL,
			`valor` int(11) DEFAULT NULL,
			`valor_acresc` int(11) DEFAULT NULL,
			`qtd_chaves` int(11) DEFAULT NULL,
			`transferivel` int(11) DEFAULT NULL,
			`disponivel` int(11) DEFAULT NULL,
			`x` text DEFAULT NULL,
			`y` text DEFAULT NULL,
			`z` text DEFAULT NULL
		  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]]
)
vRP.prepare('elite/elite_homes_garages',
    [[
		CREATE TABLE IF NOT EXISTS `elite_homes_garage` (
			`user_id` int(11) DEFAULT NULL,
			`home` varchar(15) DEFAULT NULL,
			`garagem` tinytext CHARACTER SET latin1 DEFAULT NULL,
			`spawn` tinytext CHARACTER SET latin1 DEFAULT NULL
		  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]]
)
vRP.prepare('elite/elite_homes_permissions',
    [[
		CREATE TABLE IF NOT EXISTS `elite_homes_permissions` (
			`owner` int(11) NOT NULL,
			`user_id` int(11) NOT NULL,
			`home` varchar(15) NOT NULL DEFAULT '',
			`interior` varchar(50) DEFAULT '',
			`garage` int(11) NOT NULL,
			`chestSize` int(5) DEFAULT 150,
			`tax` varchar(24) NOT NULL DEFAULT '',
			`slotsChest` int(11) NOT NULL DEFAULT 15
		  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    ]]
)
vRP.prepare('elite/elite_apartment',
    [[
		CREATE TABLE IF NOT EXISTS `elite_apartment` (
			`Apartamentos` tinytext DEFAULT NULL,
			`Donos` tinyint(2) DEFAULT NULL,
			`Moradores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{}',
			`price` mediumint(8) unsigned DEFAULT NULL COMMENT 'Max Price 16777000',
			`bau` smallint(4) DEFAULT NULL,
			`x` tinytext DEFAULT NULL,
			`y` tinytext DEFAULT NULL,
			`z` tinytext DEFAULT NULL
		  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]]
)

CreateThread(function()
    vRP.execute('elite/elite_homes')
    vRP.execute('elite/elite_homes_garages')
    vRP.execute('elite/elite_homes_permissions')
    vRP.execute('elite/elite_apartment')
end)



local timer = false

--[ WEBHOOK ]-----------------------------------------------------------------------------------------------------------------

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Thomes/Garageeventype'] = 'application/json' })
	end
end

vRP._prepare("homes/get_homeuser","SELECT * FROM elite_homes_permissions WHERE user_id = @user_id AND home = @home")
vRP._prepare("homes/get_homeuserid","SELECT * FROM elite_homes_permissions WHERE user_id = @user_id")
vRP._prepare("homes/get_homeuserowner","SELECT * FROM elite_homes_permissions WHERE user_id = @user_id AND home = @home AND owner = 1")
vRP._prepare("homes/get_homeuseridowner","SELECT * FROM elite_homes_permissions WHERE home = @home AND owner = 1")
vRP._prepare("homes/get_homeuseridco_owner","SELECT * FROM elite_homes_permissions WHERE user_id = @user_id AND home = @home AND owner = 0")
vRP._prepare("homes/get_homepermissions","SELECT * FROM elite_homes_permissions WHERE home = @home")
vRP._prepare("homes/add_permissions","INSERT IGNORE INTO elite_homes_permissions(home,user_id) VALUES(@home,@user_id)")
vRP._prepare("homes/buy_permissions","INSERT IGNORE INTO elite_homes_permissions(home,user_id,owner,tax,garage) VALUES(@home,@user_id,1,@tax,1)")
vRP._prepare("homes/count_homepermissions","SELECT COUNT(*) as qtd FROM elite_homes_permissions WHERE home = @home")
vRP._prepare("homes/upd_permissions","UPDATE elite_homes_permissions SET garage = 1 WHERE home = @home AND user_id = @user_id")
vRP._prepare("homes/rem_permissions","DELETE FROM elite_homes_permissions WHERE home = @home AND user_id = @user_id")
vRP._prepare("homes/rem_allpermissions","DELETE FROM elite_homes_permissions WHERE home = @home")
vRP._prepare("homes/chest_Size","SELECT chestSize FROM elite_homes_permissions WHERE home = @home AND owner =1")
vRP._prepare("homes/chest_UPDATE","UPDATE elite_homes_permissions SET chestSize = @chestSize WHERE home = @home AND owner = 1")

vRP._prepare("homes/create_house","INSERT INTO elite_homes(home,interior,bau,valor,qtd_chaves,transferivel,disponivel,x,y,z) VALUES(@home,@interior,@bau,@valor,@qtd_chaves,@transferivel,@disponivel,@x,@y,@z)")
------------ Garagem da casa -------------
vRP._prepare('homes/GarageCreate','INSERT INTO elite_homes_garage(user_id,home,garagem,spawn) VALUES(@user_id,@home,@garagem,@spawn) ')
vRP._prepare('homes/GarageSelect','SELECT garagem,spawn FROM elite_homes_garage WHERE user_id = @user_id AND home = @home ')
vRP._prepare('homes/GarageUpdate','UPDATE elite_homes_garage SET garagem = @garagem,spawn = @spawn WHERE user_id = @user_id AND home = @home ')
vRP._prepare('homes/Garage','SELECT * FROM elite_homes_garage')
-------------------------------------------------
--Selecionar o interior
vRP._prepare('homes/UserHouserInterior','SELECT interior FROM elite_homes_permissions WHERE user_id = @user_id AND home = @home ')
vRP._prepare('homes/HouseCustomData','SELECT * FROM elite_homes WHERE home = @home ')
vRP._prepare('homes/GetAllHouse','SELECT * FROM elite_homes')
vRP._prepare('homes/ChangeInterior','UPDATE elite_homes_permissions SET interior = @interior WHERE user_id = @user_id AND home = @home')


-------------------------------------------------

local homeEnter = {}
local chestOpen = {}
local unlocked = {}

local antidumphomes = {}
local useridhomeopen = {}
rota = {}

function src.AttBlipHomes(interior)
	return config.Interiores[interior]['location']
end 

blipHome = {}
function src.updateListHomeBlip()
	local consultando = vRP.query('homes/GetAllHouse',{})
	if #consultando > 0 then 
		for k,v in pairs(consultando) do
			blipHome[v.home] = v
		end
		return blipHome
	end 
end

function src.HouseDoor(home)
	local user_id = vRP.getUserId(source)
	if user_id then 
		local consult = vRP.query('homes/HouseCustomData',{ home = home })
		local infoHouse = consult[1]
	
		if infoHouse then
			local x,y,z = infoHouse.x,infoHouse.y,infoHouse.z
			return x,y,z
		end 
	end
end

function src.HouseChest(interior,home)
	local user_id = vRP.getUserId(source)
	if user_id then 
		local consult = vRP.query('homes/HouseCustomData',{ home = home })
		local infoHouse = consult[1]
	
		if infoHouse then
			local bau = infoHouse.bau
			return config.Interiores[interior]['vault'].x,config.Interiores[interior]['vault'].y,config.Interiores[interior]['vault'].z,bau,config.Interiores[interior]['armario'].x,config.Interiores[interior]['armario'].y,config.Interiores[interior]['armario'].z
		end 
	end
end

function src.InteriorTypeSet(home)
	local user_id = vRP.getUserId(source)
	local typeInt = ''
	if user_id then
		local myHomes = vRP.query("homes/get_homeuseridowner",{ home = home })
		if myHomes[1] then
			local HomeCustom = vRP.query('homes/HouseCustomData',{ home = home })
			local customHome = HomeCustom[1]

			if myHomes[1].interior ~= "" then 
				typeInt = myHomes[1].interior
			else 
				typeInt = customHome.interior
			end 
			local cds = config.Interiores[typeInt]['location']
			local xH,yH,zH,hH = cds.x,cds.y,cds.z,cds.h

			return xH,yH,zH,hH,typeInt
		end 
	end 
end


AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myHomes = vRP.query("homes/get_homeuserid",{ user_id = parseInt(user_id) }) --porra
		if parseInt(#myHomes) >= 1 then
			for k,v in pairs(myHomes) do
				local cdsH = vRP.query('homes/HouseCustomData', { home = v.home } )
				vCLIENT.setBlipsOwner(source,v.home, tonumber(cdsH[1].x),tonumber(cdsH[1].y),tonumber(cdsH[1].z))
				Citizen.Wait(10)
			end
		end
	end
end)
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- 	APARTAMENTO E CASA CRIAR
---------------------------------------------------------------------------
---------------------------------------------------------------------------

vRP._prepare('apartamento/SELECTAll','SELECT * FROM elite_apartment') --UNCHECK
vRP._prepare('apartamento/INSERT','INSERT INTO elite_apartment(Apartamentos,Donos,Moradores,price,bau,x,y,z) VALUES(@Apartamentos,@Donos,@Moradores,@price,@bau,@x,@y,@z)') --UNCHECK
vRP._prepare('apartamento/SELECT_APLocal','SELECT Apartamentos,x,y,z FROM elite_apartment') -- CHECK

vRP._prepare('apartamento/price','SELECT price FROM elite_apartment WHERE Apartamentos = @Apartamentos') -- CHECK
vRP._prepare('apartamento/SELECT_QTDOwner','SELECT Donos FROM elite_apartment WHERE Apartamentos = @Apartamentos') -- CHECK
vRP._prepare("apartamento/UPDATE_QTDOwner","UPDATE elite_apartment SET Donos = Donos + 1 WHERE Apartamentos = @Apartamentos") -- CHECK

vRP._prepare('apartamento/SELECTMorador','SELECT Moradores FROM elite_apartment WHERE Apartamentos = @Apartamentos') --CHECK
vRP._prepare('apartamento/newOwner','UPDATE elite_apartment SET Moradores = @Moradores WHERE Apartamentos = @Apartamentos') --CHECK

vRP._prepare('apartamento/LOCATION','SELECT x,y,z FROM elite_apartment WHERE Apartamentos = @Apartamentos') -- CHECK

vRP._prepare('inHome/out-inside','UPDATE vrp_user_identities SET inHome = @inHome WHERE user_id = @user_id') -- WORKING
vRP._prepare('inHome/inside','SELECT inHome FROM vrp_user_identities WHERE user_id = @user_id') -- WORKING
vRP._prepare('inHome/bugandoHomes','UPDATE vrp_user_identities SET BugHomeIN = 1 WHERE user_id = @user_id') -- WORKING

RegisterCommand('testao',function(source)
	local consult = vRP.query('apartamento/LOCATION',{ Apartamentos = 'Officer' })[1]
		local cds = { tonumber(consult.x), tonumber(consult.y), tonumber(consult.z)}
		print(json.encode(cds))
end)
-----------------------------------------
-- Entrar no Apartamento
-----------------------------------------
insideAP = {}
resposta = {}
function src.APjoin(data,inside)
	local source = source 
	local user_id = vRP.getUserId(source)

	if inside then 
		local moradorID = tonumber(data[1])
		if not vRP.getUserSource(moradorID) then 
			TriggerClientEvent('Notify',source,evento_aviso,'<b>[ INTERFONANDO ]</b>',5000)
			TriggerClientEvent("vrp_sound:source",source,'interfone',0.5)
			Wait(7000)
			TriggerClientEvent('Notify',source,evento_aviso,'O morador <b>não</b> atendeu o <b>intefone</b>',5000)
			vRPclient._stopAnim(source, false)
			return
		end

		local APname = data[2]
		if user_id then 
			local consult = vRP.query('apartamento/SELECTMorador',{ Apartamentos = APname})[1]
			local Owner = json.decode(consult.Moradores)
			local APbloco = Owner[tostring(moradorID)] -- Selecionar o ap selecionado
			
			if next(APbloco) == nil then 
				return --TriggerClientEvent('Notify',source,evento_aviso,'Nenhum morador registrado neste AP')
			else 
				if moradorID == user_id then -- É o dono, pode liberar 
					SetPlayerRoutingBucket(source,user_id)
					insideAP[user_id] = { inside = true, AP = APname}
					vRP.execute('inHome/out-inside', { user_id = user_id, inHome = 1 })
					return true
				else 
					for id,liberado in pairs(APbloco.moradores) do 
						if tonumber(id) == user_id then -- é inquilino, pode verificar a fundo
							if liberado == true then 
								SetPlayerRoutingBucket(source,moradorID)
								insideAP[user_id] = { inside = true, AP = APname}
								vRP.execute('inHome/out-inside', { user_id = user_id, inHome = 1 })
								return true
							else 
								return false,TriggerClientEvent('Notify',source,evento_aviso, 'O morador mudou a fechadura!')
							end 
						end 
						Citizen.Wait(10)	 
					end  

					local player = vRP.getUserSource(moradorID)
					local identity = vRP.getUserIdentity(user_id)
					if player then 
						if not resposta[user_id] then
							TriggerClientEvent('Notify',source,evento_aviso,'<b>[ INTERFONANDO ]</b>',5000)
							TriggerClientEvent('Notify',source,evento_aviso, 'Você tocou a campainha, espere alguem te liberar!')
							TriggerClientEvent("Notify",player,evento_aviso,"<b>"..identity.name.." "..identity.firstname.."</b> tocou o interfone da prédio <b>"..tostring(APname).."</b>.<br>Deseja permitir a entrada do mesmo?",10000)
							
							TriggerClientEvent("vrp_sound:source",player,'interfone',0.5)
							TriggerClientEvent("vrp_sound:source",source,'interfone',0.5)
							local ok = vRP.request(player,"Permitir acesso a residência?",30)
							if ok then
								resposta[user_id] = true
								insideAP[user_id] = { inside = true, AP = APname}
								SetPlayerRoutingBucket(source,moradorID)
								vRP.execute('inHome/out-inside', { user_id = user_id, inHome = 1 })
								vRPclient._stopAnim(source, false)
								return true
							else 
								TriggerClientEvent('Notify',source,evento_aviso,'O morador <b>não</b> atendeu o <b>intefone</b>',5000)
								vRPclient._stopAnim(source, false)
							end
						end
					end 
					
				end 
			end 
		end
	else	
		if insideAP[user_id] ~= nil then 
			local consult = vRP.query('apartamento/LOCATION',{ Apartamentos = insideAP[user_id].AP })[1]
			local cds = { tonumber(consult.x), tonumber(consult.y), tonumber(consult.z)}
			
			insideAP[user_id] = nil
			SetPlayerRoutingBucket(source,0) -- Volta pra sessão original
			vRP.execute('inHome/out-inside', { user_id = user_id, inHome = 0 })
			return true,cds
		end 
	end 
end

kick = {}
RegisterCommand("sessao",function(source)
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id then
		if insideAP[user_id] == nil then 
			local quest = vRP.request(source, 'Tem certeza de que você está bugado dentro do interior?', 15)
			if quest then 
				local consult = vRP.query('inHome/inside', { user_id = user_id })[1]
				local inHome = consult.inHome
				if inHome then 
					TriggerClientEvent('Notify',source,evento_aviso,'Te colocando na sessão correta!')
					vRP.execute('inHome/out-inside', { user_id = user_id, inHome = 0 })
					vCLIENT.PutMeBackToTheWorld(source)
					SetPlayerRoutingBucket(source,0)
					if kick[user_id] ~= nil then 
						kick[user_id] = nil
					end 
				elseif kick[user_id] == nil then
					kick[user_id] = true
					TriggerClientEvent('Notify',source,evento_aviso,'Você não está bugado dentro do interior!. Na próxima você será kikado!')
				else 
					kick[user_id] = nil
					vRP.execute('inHome/bugandoHomes',{ user_id = user_id })
					vRP.kick(source,'Vai bugar na casa do caralho!')
					local identity = vRP.getUserIdentity(user_id)
					local ped = GetPlayerPed(source)
					local cdszin = GetEntityCoords(ped)
					SendWebhookMessage(config.bugRotear,"```prolog\n [O Cidadão ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[Tentou bugar o homes]\n[CDS]: X = "..cdszin.x..", Y = "..cdszin.y..", Z = "..cdszin.z..' '..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end 
			end 
		end
	end 
end)
-----------------------------------------
-----------------------------------------
-----------------------------------------
-- Puxando localizações do banco de dados
-----------------------------------------
function src.APlocations()
	local consult = vRP.query('apartamento/SELECT_APLocal')
	return consult
end
--------------
function src.PermADM()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then 
		if vRP.hasPermission(user_id, config.admpermissao) then 
			return true,user_id
		end 
	end 
	return false,user_id
end

function src.prompt(text,placeHolder)
	local source = source 
	local box = vRP.prompt(source,text,placeHolder)
	return box 
end 

function src.FinishChoices(choices)
	local source = source 
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local player = GetPlayerPed(source)
    local crds = GetEntityCoords(player)
	if user_id then 
		if choices[1]['typer'] == 'casinha' then 
			local exist = vRP.query('homes/HouseCustomData', { home = choices[1].nameH })
			if exist[1] ~= nil then TriggerClientEvent('Notify',source,evento_negado,'Já existe uma casa com este nome!') return end 
			local preco = vRP.prompt(source,'Informe o preço desta casa:','')
			if preco == '' then TriggerClientEvent('Notify',source,evento_aviso,'Você não informou o preço da casa!') return end 
			for source,v in pairs(choices) do
				TriggerClientEvent('Notify',source,evento_sucesso,'Casa: '..v.nameH..', criada com <b>sucesso!</b>')
				SendWebhookMessage(config.criarcasa,"```prolog\n[O CIDADÃO]: "..user_id.." "..identity.name.." "..identity.firstname.." CRIOU UMA CASA\n[LOCAL]: X = "..crds.x..", Y = "..crds.y..", Z = "..crds.z..'\n[COM O NOME]: '..v.nameH..'\n[INTERIOR]: '..v.interior..'\n[PREÇO]: R$'..preco..' '..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				vRP.execute('homes/create_house', { home = v.nameH, interior = v.interior, bau = tonumber(v.bau), valor = tonumber(preco), qtd_chaves = 2,transferivel = 0,disponivel = 1,x = tostring(v.cds.x), y = tostring(v.cds.y), z = tostring(v.cds.z)})
			end  

		elseif choices[1]['typer'] == 'apartamento' then
			local exist = vRP.query('apartamento/SELECTMorador', { Apartamentos = choices[1].interior })
			if exist[1] ~= nil then TriggerClientEvent('Notify',source,evento_negado,'Já existe um apartamento com este interior/nome!') return end 
			local preco = vRP.prompt(source,'Informe o preço deste apartamento!','')
			if preco == '' then TriggerClientEvent('Notify',source,evento_aviso,'Você não informou o preço do apartamento!') return end 

			for source,v in pairs(choices) do
				SendWebhookMessage(config.criarap,"```prolog\n[O CIDADÃO]: "..user_id.." "..identity.name.." "..identity.firstname.." [CRIOU UM APARTAMENTO]\n[LOCAL]: X = "..crds.x..", Y = "..crds.y..", Z = "..crds.z..'\n[COM O INTERIOR]: '..v.interior..'\n[PREÇO]: R$'..preco..' '..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				TriggerClientEvent('Notify',source,evento_sucesso,'Apartamento: '..v.interior..', criado com <b>sucesso!</b>')
				vRP.execute('apartamento/INSERT', { Apartamentos = v.interior, Donos = v.qtd, Moradores = '{}', price = tonumber(preco), bau = tonumber(v.bau), x = tostring(v.cds.x), y = tostring(v.cds.y), z = tostring(v.cds.z)})
			end 
		end
	end 
end 

function src.BuyApartment(apname)
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id then 
		local consult = vRP.query('apartamento/SELECT_QTDOwner', { Apartamentos = apname })[1].Donos
		if consult < 5 then 
			TriggerClientEvent('dynamic:closeSystem2',source)
			local preco = vRP.query('apartamento/price', { Apartamentos = apname })[1].price
			local aceitar = vRP.request(source, 'Deseja comprar o imóvel por: <b>R$: '..preco..' reais</b>', 30)
			if aceitar then
				if vRP.tryFullPayment(user_id,preco,true) then 
					local exist = vRP.query('apartamento/SELECTMorador', { Apartamentos = apname })[1].Moradores
					local TableExist = json.decode(exist)
				
					for owner,table in pairs(TableExist) do 
						if tonumber(owner) == user_id then 
							TriggerClientEvent('Notify',source,evento_aviso,'Você já tem um apartamento aqui!')
							return 
						end 
					end 
					TableExist[tostring(user_id)] = {['Moradores'] = '{}'}
					vRP.execute('apartamento/newOwner', { Apartamentos = apname, Moradores = json.encode(TableExist) })
					vRP.execute('apartamento/UPDATE_QTDOwner', { Apartamentos = apname })
					TriggerClientEvent('Notify',source,evento_sucesso,'Você comprou um apartamento com sucesso!')
				else 
					TriggerClientEvent('Notify',source,evento_aviso,'Dinheiro insuficiente!')
				end 
			end 
		else 
			TriggerClientEvent('Notify',source,evento_aviso,'Todos os apartamentos foram comprados!')
			TriggerClientEvent('dynamic:closeSystem2',source)
		end 
	end 
end 

function src.IsOwner(apname)
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id then 
		local exist = vRP.query('apartamento/SELECTMorador', { Apartamentos = apname })[1].Moradores
		local TableExist = json.decode(exist)
		
		for owner,table in pairs(TableExist) do 
			if tonumber(owner) == user_id then 
				return true 
			end 
		end 
	end 
	return false 
end 

function src.SellApartment(escolha)
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id then 
		local preco = vRP.query('apartamento/price', { Apartamentos = escolha[2] })[1].price
		if escolha[1] == 'prefeitura' then 
			local newPrice = preco*0.65
			local aceitar = vRP.request(source, 'Deseja vender o imóvel para a prefeitura por: <b>R$: '..newPrice..' reais</b>', 30)
			if aceitar then 
				if config.IsMoneyItem then 
					vRP.giveInventoryItem(user_id,config.NameItemMoney,newPrice,true)
				else 
					vRP.giveBankMoney(user_id,newPrice)
				end
				TriggerClientEvent('Notify',source,evento_sucesso,'Você vendeu seu imóvel para prefeitura com sucesso!')
				TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
			end 
		elseif escolha[1] == 'player' then
			local id = vRP.prompt(source,'Informe o ID do cidadão para o qual deseja vender seu imóvel: ', '')
			if id == '' then TriggerClientEvent('Notify',source,evento_aviso,'Por favor, informe o ID do cidadão!') return end 
			
			local player = vRP.getUserSource(parseInt(id))
			if not player then
				TriggerClientEvent('Notify',source,evento_aviso,'O cidadão não está na cidade!')
				return 
			end 

			local newPrice = preco*0.80
			local identity = vRP.getUserIdentity(parseInt(id))
			local Myidentity = vRP.getUserIdentity(parseInt(user_id))
			local aceitar = vRP.request(source, 'Deseja vender o imóvel para o cidadão:'..identity.name..', '..identity.firstname..' por: <b>R$: '..newPrice..' reais</b>', 30)

			if aceitar then 
				local comprar = vRP.request(player, 'Deseja comprar o imóvel do cidadão:'..Myidentity.name..', '..Myidentity.firstname..' por: <b>R$: '..newPrice..' reais</b>', 30)
				if comprar then 
					local hasMoney = false 
					if config.IsMoneyItem then 
						if vRP.tryGetInventoryItem(parseInt(id), config.NameItemMoney, newPrice,true) then 
							hasMoney = true 
							vRP.giveInventoryItem(user_id,config.NameItemMoney,newPrice,true)	
						end 
					else 
						if vRP.tryFullPayment(parseInt(id),newPrice) then 
							hasMoney = true 
							vRP.giveBankMoney(user_id,newPrice)
						end 
					end
					if hasMoney then 
						local exist = vRP.query('apartamento/SELECTMorador', { Apartamentos = escolha[2] })[1].Moradores
						local TableExist = json.decode(exist)
						TableExist[tostring(user_id)] = nil 
						TableExist[tostring(id)] = {['Moradores'] = {}}

						vRP.execute('apartamento/newOwner', { Apartamentos = escolha[2], Moradores = json.encode(TableExist) })
						TriggerClientEvent('Notify',source,evento_sucesso,'Você vendeu seu imóvel para: '..identity.name..', '..identity.firstname..' com sucesso!')
						TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
						TriggerClientEvent("vrp_sound:source",player,'coins',0.5)
					else 
						TriggerClientEvent('Notify',source,evento_negado,'O cidadão não tem dinheiro suficiente para a compra!')
						TriggerClientEvent('Notify',player,evento_negado,'Você não tem dinheiro!')
					end 
				end 
			end 
		end 
	end 
end 

function src.Ciente()
	local source = source 
	local ok =  vRP.request(source,'A localização da casa será puxada a partir do local de onde você estiver no momento em que clicar em finalizar!, Está ciente?',30)
	return ok 
end 

function src.getApartamento(apName)
	local Consult = vRP.query('apartamento/SELECTMorador', { Apartamentos = apName })
	local data = Consult[1].Moradores -- Peguei a string
	local ToTable = json.decode(data) -- string

	return ToTable
end 

function src.GetName(user_id)
	local identity = vRP.getUserIdentity(user_id)
	return identity.name..', '..identity.firstname
end 
---------------------------------------------------------------------------
---------------------------------------------------------------------------
showOnMap = false 
RegisterNetEvent('BlipHomesList')
AddEventHandler('BlipHomesList',function()
	TriggerClientEvent('dynamic:closeSystem2',source)
	local source = source
	local blipagem = {}

	showOnMap = not showOnMap
	if showOnMap then 
		local allHouses = vRP.query('homes/GetAllHouse', {})
		if #allHouses > 0 then 
			for k,v in pairs(allHouses) do
				local UserHouse = vRP.query('homes/get_homeuseridowner',{ home = v.home })
				if UserHouse[1] then
					v.transferivel = 'sold'
					blipagem[v.home] = v
				else 
					blipagem[v.home] = v
				end 
			end
		end
	end 
	vCLIENT.setBlipsHomes(source,showOnMap,blipagem)
end)


function src.OwnerOrVisit(home)
	local user_id = vRP.getUserId(source)
	if user_id then 
		local homeResult = vRP.query("homes/get_homeuser",{ user_id = user_id, home = home })
		if #homeResult > 0 then 
			if homeResult[1].owner == 1 then 
				return 'dono'
			elseif homeResult[1].owner == 0 then 
				return 'morador'
			end 
		else 
			return 'visitante'
		end
		return  
	end
	return 
end 

local answered = {}

function src.checkPermissions(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			if not vRP.searchReturn(source,user_id) then
				local homeResult = vRP.query("homes/get_homepermissions",{ home = tostring(homeName) })
				local vrpHomes = vRP.query('homes/HouseCustomData',{ home = homeName })
				if parseInt(#homeResult) >= 1 then
					local myResult = vRP.query("homes/get_homeuser",{ user_id = parseInt(user_id), home = tostring(homeName) })
					local resultOwner = vRP.query("homes/get_homeuseridowner",{ home = tostring(homeName) })
					local resultCoOwner = vRP.query('homes/get_homeuseridco_owner',{user_id = user_id, home = homeName})
					if myResult[1] then
						if resultCoOwner[1] then 
							if parseInt(os.time()) <= parseInt((resultOwner[1].tax)+24*15*60*60) then
								rota[user_id] = resultOwner[1].user_id
								return true
							end
						end 

						if parseInt(os.time()) >= parseInt(resultOwner[1].tax+24*18*60*60) then

							local cows = vRP.getSData("chest:"..tostring(homeName))
							local rows = json.decode(cows) or {}
							if rows then
								vRP.execute("losanjos/rem_srv_data",{ dkey = "chest:"..tostring(homeName) })
							end

							vRP.execute("homes/rem_allpermissions",{ home = tostring(homeName) })
							TriggerClientEvent("Notify",source,evento_aviso,"A <b>Property Tax</b> venceu por <b>3 dias</b> e a casa foi vendida.",10000)
							return false
						elseif parseInt(os.time()) <= parseInt(resultOwner[1].tax+24*15*60*60) then
							rota[user_id] = user_id
							return true
						else
							TriggerClientEvent("Notify",source,evento_aviso,"A <b>Property Tax</b> da residência está atrasada.",10000)
							return false
						end
					else
						if parseInt(os.time()) >= parseInt(resultOwner[1].tax+24*18*60*60) and vrpHomes[1].valor < 5000000 then

							local cows = vRP.getSData("chest:"..tostring(homeName))
							local rows = json.decode(cows) or {}
							if rows then
								vRP.execute("losanjos/rem_srv_data",{ dkey = "chest:"..tostring(homeName) })
							end

							vRP.execute("homes/rem_allpermissions",{ home = tostring(homeName) })
							return false
						end

						if parseInt(os.time()) >= parseInt(resultOwner[1].tax+24*15*60*60) and vrpHomes[1].valor < 5000000 then
							TriggerClientEvent("Notify",source,evento_aviso,"A <b>Property Tax</b> da residência está atrasada.",10000)
							return false
						end

						answered[user_id] = nil
						for k,v in pairs(homeResult) do
							TriggerClientEvent("Notify",source,evento_aviso,"Essa casa tem dono, você tocou o interfone!",10000)
							local player = vRP.getUserSource(parseInt(v.user_id))
							if player then
								if not answered[user_id] then
									TriggerClientEvent("Notify",player,evento_aviso,"<b>"..identity.name.." "..identity.firstname.."</b> tocou o interfone da residência <b>"..tostring(homeName).."</b>.<br>Deseja permitir a entrada do mesmo?",10000)
									local ok = vRP.request(player,"Permitir acesso a residência?",30)
									if ok then
										answered[user_id] = true
										rota[user_id] = v.user_id 
										return true
									end
								end
							end
							Citizen.Wait(10)
						end
					end
				else
					if true then 
						local ok = vRP.request(source,"Deseja efetuar a compra da residência <b>"..tostring(homeName).."</b> por <b>$"..vRP.format(parseInt(vrpHomes[1].valor)).."</b> ?",30)
						if ok then
							local preco = parseInt(vrpHomes[1].valor)

							if vRP.tryPayment(user_id,parseInt(preco)) then
								vRP.execute("homes/buy_permissions",{ home = tostring(homeName), user_id = parseInt(user_id), tax = parseInt(os.time()) })
								SendWebhookMessage(config.buyhomes,"```prolog\n [O Cidadão ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[Comprou]: "..tostring(homeName).."\n[VALOR]: $"..vRP.format(parseInt(vrpHomes[1].valor)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								TriggerClientEvent("Notify",source,evento_sucesso,"A residência <b>"..tostring(homeName).."</b> foi comprada com sucesso.",10000)
							else
								TriggerClientEvent("Notify",source,evento_negado,"Dinheiro insuficiente.",10000)		
							end
						end
						return false
					end
				end
			end
		end
	end
	return false
end
function src.checkIntPermissions(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			local myResult = vRP.query("homes/get_homeuser",{ user_id = parseInt(user_id), home = tostring(homeName) })
			if myResult[1] or vRP.hasPermission(user_id,config.policePerm) then
				if not timer then
					timer = true

					SetTimeout(3000,function()
						timer = false
					end)

					return true
				end
			end
		end
	end
	return false
end
function src.ArmarioPlayer(home,option,cloth)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local homeName = vCLIENT.getHomeStatistics(source)
		local myResult = vRP.query("homes/get_homeuser",{ user_id = parseInt(user_id), home = tostring(home) })
		if myResult[1] then
			local data = vRP.getSData("outfit:"..tostring(home))
			local result = json.decode(data) or {}
			if result then
				if option == "save" then
					local custom = vRPclient.getCustomPlayer(source)
					if custom then
						local clothname = vRP.prompt(source,'Qual nome do Outfit? (nada de acento ou espaço)','')
						if clothname == '' then return end 
						local outname = tostring(clothname)
						if result[outname] == nil and string.len(outname) > 0 then
							result[outname] = custom
							vRP.setSData("outfit:"..tostring(homeName),json.encode(result))
							TriggerClientEvent("Notify",source,evento_sucesso,"Outfit <b>"..outname.."</b> adicionado com sucesso.",10000)
						else
							TriggerClientEvent("Notify",source,evento_aviso,"Nome escolhido já existe na lista de <b>Outfits</b>.",10000)
						end
					end
				elseif option == "rem" then
					local outname = cloth
					if result[outname] ~= nil and string.len(outname) > 0 then
						result[outname] = nil
						vRP.setSData("outfit:"..tostring(homeName),json.encode(result))
						TriggerClientEvent("Notify",source,evento_sucesso,"Outfit <b>"..outname.."</b> removido com sucesso.",10000)
					else
						TriggerClientEvent("Notify",source,evento_negado,"Nome escolhido não encontrado na lista de <b>Outfits</b>.",10000)
					end
				elseif option == "apply" and option then
					local outname = cloth
					if result[outname] ~= nil and string.len(outname) > 0 then
						TriggerClientEvent("updateRoupas",source,result[outname])
						TriggerClientEvent("Notify",source,evento_sucesso,"Outfit <b>"..outname.."</b> aplicado com sucesso.",10000)
					else
						TriggerClientEvent("Notify",source,evento_negado,"Nome escolhido não encontrado na lista de <b>Outfits</b>.",10000)
					end
				else
					return result
				end
			end 
		end
	end
end

function src.antidumphomes(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if not antidumphomes[homeName] then
		antidumphomes[homeName] = true
		return true
	end
	return false
end

function src.chestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if useridhomeopen[user_id] then
		antidumphomes[useridhomeopen[user_id]] = false
		useridhomeopen[user_id] = nil
	end
end

AddEventHandler("vRP:playerLeave",function(user_id,source)
	if useridhomeopen[user_id] then
		antidumphomes[useridhomeopen[user_id]] = false
		useridhomeopen[user_id] = nil
	end
end)
function src.returnWeight(home)
    if home then    
        local chest = vRP.query("C2N/chestSize",{home = home})
        if chest[1] ~= nil then
            return chest[1]['chestSize'] -- (DEU ERRO AQUI)
        end
        local bau = vRP.query("C2N/bauSize",{home = home})
        if bau[1] ~= nil then
            return table[1]['bau']
        end
        return nil
    end
end
function src.openChestcustom(homename)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local pesoBau = nil
		local chestPeso = vRP.query('homes/HouseCustomData',{home = homename})
		local size = vRP.query('homes/chest_Size',{home = homename})
		if size[1].chestSize ~= 0 then 
			pesoBau = size[1].chestSize
		else
			pesoBau = chestPeso[1].bau
		end 

		chestcustomopenserver(homename,pesoBau)

	end
end

function src.openChest(homename1)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	
	if user_id then
		chestOpen[user_id] = homename1
		local myinventory = {}
		local mychestopen = {}
		local mychestname = homename1
		if mychestname ~= nil then
			useridhomeopen[user_id] = mychestname
			local inv = vRP.getInventory(parseInt(user_id))
			if inv then
				for k,v in pairs(inv) do

					v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.peso = vRP.getItemWeight(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.key = v.item
					v.slot = k
					myinventory[k] = v
				
				end
			end
			local data = vRP.getSData("homesVault:"..mychestname)
			
			local sdata = json.decode(data) or {}
			local pesoBau = nil
			local chestPeso = vRP.query('homes/HouseCustomData',{home = homename1})
			local size = vRP.query('homes/chest_Size',{home = homename1})
			if size[1].chestSize ~= 0 then 
				pesoBau = size[1].chestSize
			else
				pesoBau = chestPeso[1].bau
			end 
			if data then
				for k,v in pairs(sdata) do
					table.insert(mychestopen,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
				end
			end
			return myinventory,mychestopen,vRP.computeInvWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeChestWeight(sdata),pesoBau,{ identity.name.." "..identity.firstname,parseInt(user_id),identity.phone,identity.registration,vRP.getBankMoney(user_id) }
		end
	end
	return false
end
function src.GettAllInterior()
	return config.Interiores
end 

function src.ChangeInterior(home,interior)
	local user_id = vRP.getUserId(source)
	local aceita = vRP.request(source, "Deseja pagar: "..config.Interiores[interior]['price']..', para aplicar o interior: '..interior, 30)
	if aceita == '' then return end 
	if user_id then
		local ownerHomes = vRP.query("homes/get_homeuseridowner",{ home = home })
		if ownerHomes[1] then 	
			if aceita then 
				if vRP.tryPayment(user_id,config.Interiores[interior]['price']) then 
					vRP.execute('homes/ChangeInterior',{user_id = user_id, interior = interior, home = home})
					return true 
				end
				return false 
			end
			return false 
		end
		return false 
	end
	return false 
end 

RegisterNetEvent("elite_homes:populateSlot")
AddEventHandler("elite_homes:populateSlot",function(item,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,item,amount,false,slot) then

			local weapons = vRP.getWeaponsId(user_id)

			for k, v in pairs(weapons) do
	
				local ammoType = getAmmoTypeByWeapon(item)

				if v.weapon == ammoType then
					vRP.execute("vRP/del_weapon", { user_id = user_id, weapon = ammoType })
					vRP.giveInventoryItem(user_id,ammoType,v.ammo,false) 
					TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
					break														
				end
			end


			vRP.giveInventoryItem(user_id,item,amount,false,target)
			TriggerClientEvent("elite_homes:Update",source,"updateVault")
		end
	end
end)

RegisterNetEvent("elite_homes:updateSlot")
AddEventHandler("elite_homes:updateSlot",function(item,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id,item,amount,false,slot) then
					vRP.giveInventoryItem(user_id,item,amount,false,target)
				end
			else
				vRP.swapSlot(user_id,slot,target)
			end
		end

		TriggerClientEvent("elite_homes:Update",source,"updateVault")
	end
end)

RegisterNetEvent("elite_homes:sumSlot")
AddEventHandler("elite_homes:sumSlot",function(itemName,slot,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(slot)].item == itemName then
				if vRP.tryChestItem(user_id,"chest:"..tostring(chestOpen[parseInt(user_id)]),itemName,amount,slot) then
					TriggerClientEvent("vrp_chest:Update",source,"updateChest")
				end
			end
		end
	end
end)
function src.storeItem(homeName,itemName,slot,amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then

			local chestPeso = vRP.query('homes/HouseCustomData',{home = homeName})
			if vRP.storeChestItem(user_id,"homesVault:"..tostring(homeName),itemName,amount,chestPeso[1].bau,slot,"homes") then
				TriggerClientEvent("elite_homes:Update",source,"updateVault")
			end
		end
	end
end
function src.RouteBuck()
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id then 
		if GetPlayerRoutingBucket(source) == 0 then 
			SetPlayerRoutingBucket(source,rota[user_id])
		else
			rota[user_id] = nil
			SetPlayerRoutingBucket(source,0)
		end
	end 
end 
function src.takeItem(homeName,itemName,slot,amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRP.tryChestItem(user_id,"homesVault:"..tostring(homeName),itemName,amount,slot,"homes") then
				TriggerClientEvent("elite_homes:Update",source,"updateVault")
			end
		end
	end
end

function src.checkPolice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,config.policePerm) then
			return true
		end
		return false
	end
end

RegisterCommand('darcasa' ,function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = vRP.getUserId(parseInt(args[2]))
	if vRP.hasPermission(user_id,config.permissaoadd) then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
			local identitynu = vRP.getUserIdentity(nuser_id)
			vRP.execute("homes/buy_permissions",{ home = args[1], user_id = parseInt(args[2]), tax = parseInt(os.time()) })
			PerformHttpRequest(config.darcasa, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 	------------------------------------------------------------
					title = "REGISTRO DE RESIDÊNCIA ADICIONADA⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
					thumbnail = {
						url = 'https://media.discordapp.net/attachments/902679973129773137/1007152238684282940/Composicao_1_6.gif'
					}, 
					fields = {
						{ 
							name = "**COLABORADOR DA EQUIPE:**",
							value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
						},
						{
							name = "**INFORMAÇÕES:**",
							value = "**[ Modelo: "..args[1].." ][ Player ID: "..args[2].." ]**\n⠀"
						}
					}, 
					}
				}
			}), { ['Content-Type'] = 'application/json' })
            TriggerClientEvent("Notify",source,evento_sucesso,"Voce adicionou a residência <b>"..args[1].."</b> para o Passaporte: <b>"..parseInt(args[2]).."</b>.")
        end
    end
end)

RegisterCommand('remcasa',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = vRP.getUserId(parseInt(args[2]))
	if vRP.hasPermission(user_id,config.permissaorem) then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
			local identitynu = vRP.getUserIdentity(nuser_id)
			vRP.execute("homes/rem_permissions",{ home = args[1], user_id = parseInt(args[2]) })
			PerformHttpRequest(config.remcasa, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 	------------------------------------------------------------
					title = "REGISTRO DE RESIDÊNCIA REMOVIDA⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
					thumbnail = {
						url = 'https://media.discordapp.net/attachments/902679973129773137/1007152238684282940/Composicao_1_6.gif'
					}, 
					fields = {
						{ 
							name = "**COLABORADOR DA EQUIPE:**",
							value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
						},
						{
							name = "**INFORMAÇÕES:**",
							value = "**[ Modelo: "..args[1].." ][ Player ID: "..args[2].." ]**\n⠀"
						}
					}, 
					}
				}
			}), { ['Content-Type'] = 'application/json' })
	        TriggerClientEvent("Notify",source,evento_sucesso,"Você removeu a residência <b>"..args[1].."</b> do Passaporte: <b>"..parseInt(args[2]).."</b>.")
        end
    end
end)

RegisterNetEvent('HomesOptions2')
AddEventHandler('HomesOptions2',function(home,option,idplayer)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vrpHomes = vRP.query('homes/HouseCustomData',{home = home})
		if #vrpHomes > 0 then 
			if option == "add" then
				local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = home })
				if myHomes[1] then
					local puser = vRP.prompt(source,'Informe o número do passaporte do cidadão: ','')
					if puser == '' then return end 
					local totalResidents = vRP.query("homes/count_homepermissions",{ home = home })

					if parseInt(totalResidents[1].qtd) >= vrpHomes[1].qtd_chaves then
						TriggerClientEvent("Notify",source,evento_negado,"A residência "..home.." atingiu o máximo de moradores.",10000)
						return
					end
					
					vRP.execute("homes/add_permissions",{ home = home, user_id = tonumber(puser) })
					
					local identity = vRP.getUserIdentity(tonumber(puser))
					if identity then
						
						TriggerClientEvent("Notify",source,evento_sucesso,"Permissão na residência <b>"..home.."</b> adicionada para <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
						SendWebhookMessage(config.addhomes,"```prolog\n [O Cidadão ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RECEBU PERMISSÃO NA CASA]: "..home.."\n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					end
				end
			elseif option == "rem" then
				local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = home })
				if myHomes[1] then
					local userHomes = vRP.query("homes/get_homeuser",{ user_id = idplayer, home = home })
					if userHomes[1] then
						
						vRP.execute("homes/rem_permissions",{ home = home, user_id = idplayer })
						local identity = vRP.getUserIdentity(idplayer)
						if identity then
							TriggerClientEvent("Notify", source, evento_aviso,"Permissão na residência <b>"..home.."</b> removida de <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
							SendWebhookMessage(config.remhomes,"```prolog\n [O Cidadão ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[PERDEU A PERMISSÃO NA CASA]: "..home.."\n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						end
					end
				end

			elseif option == "garage" then
				local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = home })
				if myHomes[1] then
					if idplayer == nil then return end 
					local userHomes = vRP.query("homes/get_homeuser",{ user_id = idplayer, home = home })
					if userHomes[1] then
						if vRP.tryPayment(user_id,parseInt(config.addgarage)) then
							vRP.execute("homes/upd_permissions",{ home = home, user_id = idplayer })
							local identity = vRP.getUserIdentity(idplayer)
							if identity then
								TriggerClientEvent("Notify",source,evento_sucesso,"Adicionado a permissão da garagem a <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
								SendWebhookMessage(config.addpermgarage,"```prolog\n [O Cidadão [ID: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RECEBU PERMISSÃO NA GARAGEM DA CASA]: "..home.."\n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							end
						else
							TriggerClientEvent("Notify",source,evento_negado,"Dinheiro insuficiente.",10000)
						end
					end
				end
			elseif option == "transfer" then
				local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = home })
				if myHomes[1] then
					if idplayer == nil then return end 
					local identity = vRP.getUserIdentity(idplayer)
					if identity then
						local ok = vRP.request(source,"Transferir a residência <b>"..home.."</b> para <b>"..identity.name.." "..identity.firstname.."</b> ?",30)
						if ok then
							vRP.execute("homes/rem_allpermissions",{ home = home })
							vRP.execute("homes/buy_permissions",{ home = home, user_id = idplayer, tax = parseInt(myHomes[1].tax) })
							TriggerClientEvent("Notify", source, evento_aviso,"Transferiu a residência <b>"..home.."</b> para <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
							SendWebhookMessage(config.transfer,"```prolog\n [O Cidadão ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RECEBU A CASA]: "..home.."\n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						end
					end
				end
			elseif option == "tax" then
				local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = home })
				if myHomes[1] then
					print(json.encode(myHomes))
					local house_price = parseInt(vrpHomes[1].valor)
					local house_tax = config.taxas
					if house_price >= 9999999 then
						house_tax = config.taxvip
					end
					if vRP.tryPayment(user_id,parseInt(house_price * house_tax)) then
						vRP.execute("homes/rem_permissions",{ home = home, user_id = parseInt(myHomes[1].user_id) })
						vRP.execute("homes/buy_permissions",{ home = home, user_id = parseInt(myHomes[1].user_id), tax = parseInt(os.time()) })
						TriggerClientEvent("Notify",source,evento_sucesso,"Pagamento de <b>$"..vRP.format(parseInt(house_price * house_tax)).." dólares</b> efetuado com sucesso.",10000)
						SendWebhookMessage(15,"```prolog\n [O Cidadão ID]: "..user_id.." \n[PAGOU O IPTU DE]: "..(parseInt(house_price * house_tax)).."\n[DA CASA]: "..home.."\n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					else
						TriggerClientEvent("Notify",source,evento_negado,"Dinheiro insuficiente.",10000)
					end
				end
			elseif option == 'taxConsult' then
					local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = home })
					if myHomes[1] then
						for k,v in pairs(myHomes) do
							print(json.encode(myHomes))
							local ownerHomes = vRP.query("homes/get_homeuseridowner",{ home = home })
							if ownerHomes[1] then
								local house_price = parseInt(vrpHomes[1].valor)
								local house_tax = 0.03
	
	
								if parseInt(os.time()) >= parseInt(ownerHomes[1].tax+24*15*60*60) then
									TriggerClientEvent("Notify",source,evento_negado,"<b>Residência:</b> "..v.home.."<br><b>Property Tax:</b> Atrasado<br>Valor: <b>$"..vRP.format(parseInt(house_price * house_tax)).." dólares</b>",20000)
								else
									TriggerClientEvent("Notify", source, evento_aviso,"<b>Residência:</b> "..v.home.."<br>Taxa em: "..vRP.getDayHours(parseInt(86400*15-(os.time()-ownerHomes[1].tax))).."<br>Valor: <b>$"..vRP.format(parseInt(house_price * house_tax)).." dólares</b>",20000)
								end
								Citizen.Wait(10)
							end
						end
					end
				end
			else 
				TriggerClientEvent('Notify',source,evento_aviso,'Desculpe, não achei informações sobre esta casa!')
			end 
		end
	end)

function src.updateGarage(home,BlipGaragem,vehSpawn,heading)
	local user_id = vRP.getUserId(source)
	if user_id then
		local consultar = vRP.query('homes/GarageSelect',{user_id = user_id, home = home})
		local BlipGaragem = {['x'] = BlipGaragem.x, ['y'] = BlipGaragem.y, ['z'] = BlipGaragem.z }
		local vehSpawn = { ['x'] = vehSpawn.x, ['y'] = vehSpawn.y, ['z'] = vehSpawn.z, ['h'] = heading }
		if #consultar > 0 then 
			vRP.execute('homes/GarageUpdate',{user_id = user_id, home = home,
				garagem = json.encode(BlipGaragem), 
				spawn  = json.encode(vehSpawn)
			})
		else 
			vRP.execute('homes/GarageCreate',{user_id = user_id, home = home, 
				garagem = json.encode(BlipGaragem), 
				spawn  = json.encode(vehSpawn)
			})
		end
	end
end

function src.houseChangesPay(option,value,home)
	local source = source
	local user_id = vRP.getUserId(source)
	
	if user_id and option ~= '' then 
		if option == 'ChangeGarage' then
			local request = vRP.request(source,'Deseja fazer a modificação? Valor R$'..config.garagevalor,30)
			if not request then return false end 
			-- local valor = config.garagevalor
			if vRP.tryPayment(user_id,parseInt(config.garagevalor)) then
				TriggerClientEvent('Notify',source,evento_sucesso,'A localização da garagem foi <b>atualizada</b>',3000)
				return true
			end 
		elseif option == 'MoreBau' then
			local info = config.chest[value]
			valor = info.valor
			local size = vRP.query('homes/chest_Size',{ home = home })
			local oldSize = vRP.request(source,'<b>Atualizar tamanho do bau de: </b>'..size[1].chestSize..'<b>, para: </b>'..info.size..'<b>, Valor: R$</b>'..info.valor,30)

			if oldSize then 
				if info.valor and vRP.tryPayment(user_id,info.valor) then 
					TriggerClientEvent('Notify',source,evento_sucesso,'O tamanho do bau foi aumentado com <b>sucesso</b>',3000)
					vRP.execute('homes/chest_UPDATE',{user_id = user_id, chestSize = info.size, home = home})
					return true
				end
			end   
		end
		return false 
	end
	return false 
end

function src.ListarMoradores(home)
	local moradores = {}
	local user_id = vRP.getUserId(source)
	local vrpHomes = vRP.query('homes/HouseCustomData',{home = home})
	if #vrpHomes > 0 then
		local userHomes = vRP.query("homes/get_homepermissions",{ home = home })
		if parseInt(#userHomes) > 1 then
			for k,v in pairs(userHomes) do
				if v.user_id ~= user_id then
					local identity = vRP.getUserIdentity(v.user_id)
					moradores[v.user_id] = {user_id = v.user_id, name = identity.name, firstname = identity.firstname}
				end
				Citizen.Wait(10)
			end
			return moradores
		else
			return 'nada'
		end
	end
end 


AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	print(resourceName,'^2INICIADO^0')
	Wait(10000)
	print( "[+] ^2Autenticado^0 - Qualquer dúvida entre em contato com -> ^4DoSantos#2208.")
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	print(resourceName,'^1PARADO^0')
end)