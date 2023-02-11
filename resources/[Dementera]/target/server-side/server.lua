local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("vrp_player",src)
Proxy.addInterface("vrp_player",src)

check = {}
Tunnel.bindInterface("target",check)


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ APREENDER ]----------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	"celular",
	"radio",
	"roupas",
	"dinheiro-sujo",
	"algema",
	"lockpick",
	"capuz",
	"placa",
	"c4",
	"metanfetamina",
	"meta-alta",
	"composito-alta",
	"nitrato-amonia",
	"pecadearma",
	"pecadefuzil",
	"hidroxido-sodio",
	"coca-alta",
	"pasta-alta",
	"acido-sulfurico",
	"folhas-coca",
	"maconha-alta",
	"maconha",
	"cocaina",
	"canabis-alta",
	"pecadearma",
	"molas",
	"placa-metal",
	"gatilho",
	"capsulas",
	"polvora",
	"wbody|WEAPON_FLARE",
	"wbody|WEAPON_KNIFE",
	"wbody|WEAPON_DAGGER",
	"wbody|WEAPON_KNUCKLE",
	"wbody|WEAPON_MACHETE",
	"wbody|WEAPON_SWITCHBLADE",
	"wbody|WEAPON_WRENCH",
	"wbody|WEAPON_HAMMER",
	"wbody|WEAPON_GOLFCLUB",
	"wbody|WEAPON_CROWBAR",
	"wbody|WEAPON_HATCHET",
	"wbody|WEAPON_FLASHLIGHT",
	"wbody|WEAPON_BAT",
	"wbody|WEAPON_BOTTLE",
	"wbody|WEAPON_BATTLEAXE",
	"wbody|WEAPON_POOLCUE",
	"wbody|WEAPON_STONE_HATCHET",
	"wbody|WEAPON_NIGHTSTICK",
	"wbody|WEAPON_COMBATPISTOL",
	"wbody|WEAPON_PISTOL_MK2",
	"wbody|WEAPON_PISTOL",
	"wbody|WEAPON_SNSPISTOL",
	"wbody|WEAPON_STUNGUN",
	"wbody|WEAPON_ASSAULTRIFLE",
	"wbody|WEAPON_CARBINERIFLE",
	"wbody|WEAPON_SPECIALCARBINE",
	"wbody|WEAPON_SMG",
	"wbody|WEAPON_MACHINEPISTOL",

	"wammo|WEAPON_FLARE",
	"wammo|WEAPON_COMBATPISTOL",
	"wammo|WEAPON_PISTOL_MK2",
	"wammo|WEAPON_PISTOL",
	"wammo|WEAPON_SNSPISTOL",
	"wammo|WEAPON_PISTOL50",
	"wammo|WEAPON_STUNGUN",
	"wammo|WEAPON_ASSAULTRIFLE",
	"wammo|WEAPON_CARBINERIFLE",
	"wammo|WEAPON_SPECIALCARBINE",
	"wammo|WEAPON_SMG",
	"wammo|WEAPON_MACHINEPISTOL",
	"wammo|WEAPON_PUMPSHOTGUN_MK2",
	"wbody|WEAPON_MICROSMG",
	
	"wammo|WEAPON_MUSKET"
}

-- sair do porta mala
RegisterServerEvent("chuveiro")
AddEventHandler("chuveiro",function()
    local source = source
    vRPclient._setCustomization(source,vRPclient.getCustomization(source))
    vRP.removeCloak(source)
end)

-- utiliar repairKit
RegisterServerEvent("useRepairKit")
AddEventHandler("useRepairKit",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.tryGetInventoryItem(user_id,"repairkit",1) then
		-- local taskre = vTASKBAR.taskLockpick(source)
		-- if taskre then
			TriggerClientEvent('cancelando',source,true)
			vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
			TriggerClientEvent("progress",source,30000,"Reparando veículo")
			SetTimeout(30000,function()
				TriggerClientEvent('cancelando',source,false)
				TriggerClientEvent('reparar',source)
				vRPclient._stopAnim(source,false)
			end)
		-- end
	else 
		TriggerClientEvent("nyo_notify",source, "#008000", "importante", "Você não tem o kit de reparo!", 5000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ reanimar ]-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("re")
AddEventHandler('re',function()
	local source = source
	local nplayer = vRPclient.getNearestPlayer(source,10)
	local user_id = vRP.getUserId(nplayer)
    if nplayer then
		if vRPclient.isInComa(nplayer) then
			local identity_user = vRP.getUserIdentity(user_id)
			local nuser_id = vRP.getUserId(nplayer)
			local identity_coma = vRP.getUserIdentity(nuser_id)
			local set_user = "Policia"
			if vRP.hasPermission(user_id,"paramedico.permissao") then
				set_user = "Paramedico"
			end
			TriggerClientEvent('cancelando',source,true)
			vRPclient._playAnim(source,false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
			TriggerClientEvent("progress",source,30000,"reanimando")
			SetTimeout(30000,function()
				vRPclient.killGod(nplayer)
				vRPclient._stopAnim(source,false)
				TriggerClientEvent("resetBleeding",nplayer)
				TriggerClientEvent('cancelando',source,false)
			end)
		else
			TriggerClientEvent("Notify",source,"importante","A pessoa precisa estar em coma para prosseguir.")
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRATAMENTO ]-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("tratamento")
AddEventHandler('tratamento',function()
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"paramedico.permissao") then
        local nplayer = vRPclient.getNearestPlayer(source,3)
        if nplayer then
			if not vRPclient.isComa(nplayer) then
				TriggerClientEvent("tratamento",nplayer)
				TriggerClientEvent("Notify",source,"sucesso","Tentando tratar o paciente.",10000)
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ tratamentoRapido ]-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("tratamentoRapido")
AddEventHandler('tratamentoRapido',function()
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"paramedico.permissao") then
        local nplayer = vRPclient.getNearestPlayer(source,3)
        if nplayer then
			TriggerClientEvent("tratamentoRapido",nplayer)
			TriggerClientEvent("Notify",source,"sucesso","Tentando tratar o paciente.",10000)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ Revistar PM ]-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local roubando = {}
local acaoRoubo = {}
RegisterServerEvent("SV:REVISTAR")
AddEventHandler('SV:REVISTAR',function()
	local source = source
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local user_id = vRP.getUserId(source)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		TriggerClientEvent("EG:ROUBAR",source)
		TriggerClientEvent("EG:SENDOROUBADO",nplayer,true)
		roubando[user_id] = nuser_id
		acaoRoubo[user_id] = 'SAQUEOU'
		guardarArmas(nuser_id)
	else
		TriggerClientEvent("Notify",source,"negado","Não existem pessoas próximas de você para REVISTAR.")
	end
end)


RegisterServerEvent("SV:apreender")
AddEventHandler('SV:apreender',function()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local user_id = vRP.getUserId(source)

		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			local identity = vRP.getUserIdentity(user_id)
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local nidentity = vRP.getUserIdentity(nuser_id)
				local itens_apreendidos = {}
				local weapons = vRPclient.replaceWeapons(nplayer,{})
				local inv = vRP.getInventory(nuser_id)

				for k,v in pairs(itemlist) do
					local sub_items = { v }
					if string.sub(v,1,1) == "*" then
						local idname = string.sub(v,2)
						sub_items = {}
						for fidname,_ in pairs(inv) do
							if splitString(fidname,"|")[1] == idname then
								table.insert(sub_items,fidname)
							end
						end
					end

					for _,idname in pairs(sub_items) do
						local amount = vRP.getInventoryItemAmount(nuser_id,idname)
						if amount > 0 then
							local item_name = idname
							if item_name then 
								if vRP.tryGetInventoryItem(nuser_id,idname,amount,true) then
									table.insert(itens_apreendidos, "[ITEM]: "..vRP.itemNameList(idname).." [QUANTIDADE]: "..amount)
								end
							end
						end
					end
				end
				local apreendidos = table.concat(itens_apreendidos, "\n")
				
				SendWebhookMessage(webhookpoliciaapreendidos,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APREENDEU DE]:  "..nuser_id.." "..nidentity.name.." "..nidentity.firstname.."\n" .. apreendidos ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

				TriggerClientEvent("Notify",nplayer,"importante","Todos os seus pertences foram apreendidos.")
				TriggerClientEvent("Notify",source,"importante","Apreendeu todos os pertences da pessoa.")
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ FUNÇÕES checagem paramedico Em serviço]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function check.checkServicesParamedic()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"paramedico.permissao") then
			return true
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--[ FUNÇÕES checagem paramedico Em serviço]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function check.checkServicesPolice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			return true
		end
	end
end

local nation = Tunnel.getInterface("nation_paintball")
local wCooldown = {}
local network_delay = {}
local policeItems = {
	["WEAPON_COMBATPISTOL"] = true,
	["WEAPON_NIGHTSTICK"] = true,
	["WEAPON_COMBATPDW"] = true,
	["WEAPON_STUNGUN"] = true,
	["WEAPON_PUMPSHOTGUN"] = true,
	["WEAPON_CARBINERIFLE"] = true,
	["WEAPON_CARBINERIFLE_MK2"] = true,
	["WEAPON_SMG"] = true,
	["WEAPON_APPISTOL"] = true,
}

function guardarArmas(id)
	local source = vRP.getUserSource(id)
	local user_id = id
	if not network_delay[source] then
		network_delay[source] = true
		SetTimeout(3000, function()
			network_delay[source] = nil
		end)
		local identity = vRP.getUserIdentity(user_id)
		if user_id then
			local weapons = vRPclient.replaceWeapons(source,{})
			for k,v in pairs(weapons) do
				if not policeItems[k] then 
					wCooldown[user_id] = 10
					vRP.giveInventoryItem(user_id,"wbody|"..k,1)
					if v.ammo > 0 then
						vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
					end
				end
			end
			TriggerClientEvent('save:database',source)
			Wait(3000)
			wCooldown[user_id] = nil
		end
	end
end