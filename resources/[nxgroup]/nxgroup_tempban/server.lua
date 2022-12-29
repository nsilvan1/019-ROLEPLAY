
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

klaus = {}
Tunnel.bindInterface("nxgroup_tempban",klaus)

function getTimeFunction(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds/60)
    seconds = seconds - minutes * 60
	
	local segundos = "SEGUNDO"
	local minutos = "MINUTO"
    
	if seconds > 1 then
		segundos = "SEGUNDOS"
	end
	if seconds > 1 then
		minutos = "MINUTOS"
	end
	if days > 0 then
        return days.." DIA(S) "..hours.." HORA(S) "..minutes.." MINUTO(S) E "..string.format("%.f",seconds).." "..segundos
    elseif hours > 0 then
        return hours.." HORA "..minutes.." "..minutos.." E "..string.format("%.f",seconds).." "..segundos
    elseif minutes > 0 then
        return minutes.." "..minutos.." E "..string.format("%.f",seconds).." "..segundos
    elseif seconds > 0 then
        return string.format("%.f",seconds).." "..segundos
    end
end

vRP.prepare("klaus/getTempban", "SELECT * FROM nxgroup_tempban WHERE user_id = @user_id")
vRP.prepare("klaus/addTempban"," INSERT IGNORE INTO nxgroup_tempban(user_id,tempban) VALUES(@user_id,@tempban)")
vRP.prepare("klaus/remTempban"," DELETE FROM nxgroup_tempban WHERE user_id = @user_id")
vRP.prepare("klaus/setTempban","UPDATE nxgroup_tempban SET tempban = @tempban WHERE user_id = @user_id")


local table = {
	['valor1'] = 24,
	['valor2'] = 48,
	['valor3'] = 72,
	['valor4'] = 10000,
}

function klaus.tempban(id, tempo)
	local nuser_id = vRP.getUserId(source)
	local nuser_id = vRP.getUserSource(parseInt(id))
	if vRP.hasPermission(nuser_id,"ceo.permissao") then
		if id and tempo then
			vRP.execute("klaus/addTempban",{ user_id = parseInt(id), tempban = 0})
			vRP.execute("klaus/setTempban",{ user_id = parseInt(id), tempban = os.time()+(parseInt(table[tempo])*60*60) })
			TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte <b>"..id.."</b> da cidade.")
		--	vRP.kick(nuser_id,"Você tomou temp-ban de "..tempo.." horas, Motivo: "..descricao)
			TriggerClientEvent("Notify",source,"sucesso","Voce kikou o passaporte <b>"..id.."</b> da cidade.")
		end
	end
end

AddEventHandler("queue:playerConnecting", function(source,ids,name,setKickReason,deferrals)
	local user_id = vRP.getUserIdByIdentifiers(ids)
	local klaustempban,klaustempban2 = vRP.query("klaus/getTempban", {user_id = user_id})
	if klaustempban2 == 1 then
		local tempo = parseInt(tonumber(klaustempban[1].tempban))
		if parseInt(tempo) >= parseInt(os.time()) then
			local tempo2 = (parseInt(tempo)-parseInt(os.time()))
			deferrals.done("Você tomou temp-ban, falta: "..getTimeFunction(tempo2).."")
			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
		else
			vRP.execute("klaus/remTempban",{ user_id = user_id })
		end
	end
end)


RegisterCommand('remtempban',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ceo.permissao") then
        if args[1] then
			vRP.execute("klaus/remTempban",{ user_id = parseInt(args[1]) })
			TriggerClientEvent("Notify",source,"sucesso","Voce removeu o ID: "..args[1].." do tempban.") 
        end
    end
end)

function klaus.bante()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.hasPermission(user_id, "ceo.permissao")
	end
end