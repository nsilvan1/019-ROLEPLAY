local contador = {}

function vRPReceiver.requestBank()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.getBankMoney(user_id)
	end
end

function vRPReceiver.requestFines()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local fines = {}
		local consult = vRP.getFines(user_id)
		for k,v in pairs(consult) do
			if parseInt(v.oficial) == 0 then
				table.insert(fines,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = "Governo", date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			else
				local identity = vRP.getUserIdentity(parseInt(v.oficial))
				table.insert(fines,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = tostring(identity.name.." "..identity.firstname), date = v.data, price = parseInt(v.price), text = tostring(v.text) })
			end
		end
		return fines
	end
end

function vRPReceiver.finesPayment(id,price)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.rembankmoney(user_id,parseInt(price)) then
			TriggerClientEvent("vrp_bank:Update",source,"requestFines")
			vRP.delFines(parseInt(id))
		else
			vRPSend.returnotify(source,true,"<b>Dinheiro insuficiente na sua conta bancária.</b>.")
		end
	end
end

function vRPReceiver.requestMySalarys()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local salario = vRP.getSalary(user_id)
		if salario[1] then
			local salary = { id = salario[1].id, user_id = parseInt(salario[1].user_id),  date = salario[1].date, price = parseInt(salario[1].price) }
			return salary
		else
			return false
		end
	end
end

function vRPReceiver.salaryPayment(id,price)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		TriggerClientEvent("vrp_bank:Update",source,"requestMySalarys")
		vRP.execute("vRP/del_salary",{user_id = parseInt(user_id) })
		vRP.setBankMoney(user_id,vRP.getBankMoney(user_id)+tonumber(price))
		vRP.log(cfg.webhookbanco,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU SEU SALARIO DE]: $"..vRP.format(parseInt(price)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		vRPSend.returnotify(source,true,"<b>Salario Tranferido Para a Conta Bancaria</b>.")
	end
end

function vRPReceiver.requestInvoices()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local invoices = {}
		local consult = vRP.getInvoice(user_id)
		for k,v in pairs(consult) do
			if v.nuser_id == 0 then
				table.insert(invoices,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = parseInt(v.nuser_id), name = "Governament", date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			else
				local identity = vRP.getUserIdentity(v.nuser_id)
				table.insert(invoices,{ id = v.id, user_id = parseInt(v.user_id), nuser_id = parseInt(v.nuser_id), name = tostring(identity.name.." "..identity.firstname), date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			end
		end
		return invoices
	end
end

function vRPReceiver.requestMyInvoices()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local invoices = {}
		local consult = vRP.getMyInvoice(user_id)
		for k,v in pairs(consult) do
			local identity = vRP.getUserIdentity(v.user_id)
			if identity then
				table.insert(invoices,{ name = tostring(identity.name.." "..identity.firstname), date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			end
		end
		return invoices
	end
end

function vRPReceiver.invoicesPayment(id,price,nuser_id)
	local source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(parseInt(nuser_id))
	if user_id then
		if vRP.getBankMoney(user_id) >= parseInt(price) then
			if parseInt(nuser_id) > 0 then
				vRP.setBankMoney(user_id,vRP.getBankMoney(user_id)-parseInt(price))
				if player then
					vRP.setBankMoney(nuser_id,vRP.getBankMoney(nuser_id)+parseInt(price))
					TriggerClientEvent("Notify",player,"sucesso","Você recebeu o pagamento de uma fatura no valor de "..vRP.format(parseInt(price)).."",5000)
				else
					local rows = vRP.query("vRP/get_money",{ id = nuser_id })
					if #rows > 0 then
						vRP.execute("vRP/set_money",{ id = nuser_id, bank = rows[1].bank + parseInt(price) })
					end
				end
			end
			TriggerClientEvent("vrp_bank:Update",source,"requestInvoices")
			vRP.execute("vRP/del_invoice",{ id = parseInt(id), user_id = parseInt(user_id) })
		else
			TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente na sua conta bancária.",5000)
		end
	end
end

function vRPReceiver.bankDeposit(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if parseInt(amount) > 0 then
			if vRP.tryGetInventoryItem(user_id,"dolares",parseInt(amount),true) then
				vRP.setBankMoney(user_id,vRP.getBankMoney(user_id)+parseInt(amount))
				vRP.log(cfg.webhookbanco,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DEPOSITOU]: $"..vRP.format(parseInt(amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				TriggerClientEvent("vrp_bank:Update",source,"requestInicio")
				vRPSend.returnotify(source,true,"<b>Dinheiro Depositado</b>.")
			else
				vRPSend.returnotify(source,false,"<b>Quantia Insuficiente em mão</b>.")
			end
		end
	end
end

function vRPReceiver.bankWithdraw(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	if user_id then
		local getInvoice = vRP.getInvoice(user_id)
		if getInvoice[1] ~= nil then
			vRPSend.returnotify(source,false,"Encontramos faturas pendentes.")
			return
		end
		local getFines = vRP.getFines(user_id)
		if getFines[1] ~= nil then
			vRPSend.returnotify(source,false,"Encontramos multas pendentes.")
			return
		end
		if parseInt(amount) > 0 then
			if vRP.computeInvWeight(user_id) + vRP.itemWeightList("dolares") * parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then
				if vRP.tryWithdraw(user_id,parseInt(amount)) then
					TriggerClientEvent("vrp_bank:Update",source,"requestInicio")
					vRP.log(cfg.webhookbanco,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SACOU]: $"..vRP.format(parseInt(amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					vRPSend.returnotify(source,true,"Valor Retirado com Sucesso!")
				else
					vRPSend.returnotify(source,false,"Dinheiro insuficiente na sua conta bancária.")
				end
			else
				vRPSend.returnotify(source,false,"Mochila cheia.")
			end
		end
	end
end

function vRPReceiver.transferir(to,amountt)
    local source = source
    local user_id = vRP.getUserId(source)
    local nuser_id = vRP.getUserSource(tonumber(to))
    local amount =  tonumber(amountt)
    if amount <= 0 then return end
	
    local identity = vRP.getUserIdentity(user_id)
    local nuidentity = vRP.getUserIdentity(tonumber(to))

    if nuser_id ~= nil then
        if tonumber(to) == user_id then
            return vRPSend.returnotify(source,false,"Você não pode transferir para si mesmo.")
        else
            local myBank = vRP.getBankMoney(user_id)
            local tax = parseInt(7/100*amount)
            local pagtax = parseInt(amount+tax)

            if myBank >= pagtax then
                vRP.setBankMoney(user_id,myBank-pagtax)
                vRP.giveBankMoney(tonumber(to),amount)
                vRP.log(cfg.webhookbanco,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU CELULAR]: $"..vRP.format(parseInt(amount)).."\n[PARA]:"..tonumber(to).."  "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                TriggerClientEvent('Notify',nuser_id,'sucesso','Você recebeu <b>$'..amount..'</b> de <b>'..identity.name..' '..identity.firstname..'</b>, passaporte: '..tostring(user_id))
              	vRPSend.returnotify(source,true,"Você transferiu <b>$"..amountt.."</b> para <b>"..nuidentity.name.." "..nuidentity.firstname.."</b>, passaporte: "..tostring(to))
				TriggerClientEvent("vrp_bank:Update",source,"requestInicio")
            else
				vRPSend.returnotify(source,false,"<b>Saldo insuficiente</b>.")
            end
        end
    else
        return vRPSend.returnotify(source,false,"Passaporte invalido.")
    end
end

RegisterNetEvent("Q_player:salary")
AddEventHandler("Q_player:salary",function()
	local source = source
	setSalario(source)
end)

function setSalario(source)
	local user_id = vRP.getUserId(source)
	if user_id then
		if cfg.darCoins then
			vRP.addCoinsId(user_id,cfg.coins)
			TriggerClientEvent("Notify",source,"financeiro","Você recebeu <b>"..vRP.format(parseInt(cfg.coins)).."</b> Coins<br> Por jogar em nosso servidor!",8000)
		end
		
		Citizen.Wait(1000)
		for _,v in pairs(cfg.salario) do
			if vRP.hasGroup(user_id,v.group) then
				vRP.setSalary(parseInt(user_id),v.salario)
				TriggerClientEvent("Notify",source,"financeiro","Você recebeu <b>"..vRP.format(parseInt(v.salario)).."</b> de salario de <b>"..v.nome.."</b>.",8000)
				if v.servico and contador[user_id] == nil then
					contador[user_id] = true
					for _,j in pairs(cfg.soldo) do
						if vRP.hasPermission(user_id,j.perm..".permissao") then
							vRP.setSalary(parseInt(user_id),j.salario)
							TriggerClientEvent("Notify",source,"financeiro","Você recebeu <b>"..vRP.format(parseInt(j.salario)).."</b> de salario de <b>"..j.nome.."</b>.",8000)
						end
					end
				end
			end
			Citizen.Wait(100)
		end
		contador[user_id] = nil
	end
end

RegisterCommand('salario', function(source)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.hasPermission(user_id,"admin.permissao") then
		setSalario(source)
	end
end)

RegisterCommand("fatura",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local nuser_id = vRP.prompt(source,"Passaporte:","")
		if nuser_id == "" or parseInt(nuser_id) <= 0 or parseInt(nuser_id) == user_id then
			TriggerClientEvent("Notify",source,"negado","Não pode Cobrar a si mesmo!.",5000)
			return
		end

		local price = vRP.prompt(source,"Valor:","")
		if price == "" or parseInt(price) <= 0 then
			return
		end

		local reason = vRP.prompt(source,"Motivo:","")
		if reason == "" then
			return
		end

		local nplayer = vRP.getUserSource(parseInt(nuser_id))
		if nplayer then
			local identity = vRP.getUserIdentity(user_id)
			local answered = vRP.request(nplayer,"Deseja aceitar a fatura no valor de <b>$"..vRP.format(parseInt(price)).." dólares</b>?",30)
			if answered then
				vRP.setInvoice(parseInt(nuser_id),parseInt(price),parseInt(user_id),tostring(reason))
				TriggerClientEvent("Notify",source,"sucesso","Fatura aceita com sucesso.",5000)
			else
				TriggerClientEvent("Notify",source,"negado","Fatura rejeitada pelo cliente.",5000)
			end
		end
	end
end)