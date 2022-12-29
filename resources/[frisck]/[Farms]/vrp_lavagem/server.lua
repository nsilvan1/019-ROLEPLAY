local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
LemP = {}
Tunnel.bindInterface("vrp_lavagem",LemP)
local idgens = Tools.newIDGenerator()
local blips = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookyakuza = "https://discord.com/api/webhooks/891704600120406086/-deXGknAQYQStyJWvhh_FE7pV928fnvgVvujKBSLko3unuc4ODhUlFTlGuEEcHa1iarI"


function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECAR DINHEIRO SUJO
-----------------------------------------------------------------------------------------------------------------------------------------
function LemP.checkDinheiro()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"notafalsa") >= 10000  then
			return true 
		else
			TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente ou você não tem o item para Lavagem.") 
			return false
		end
	end
end

function LemP.checkPayment()
    local source = source
    local user_id = vRP.getUserId(source)
    local policia = vRP.getUsersByPermission("vanilla.permissao")
    if user_id then
		if vRP.tryGetInventoryItem(user_id,"notafalsa",100000)  then
                vRP.giveMoney(user_id,parseInt(100000*("1.")))
            end
        end
    end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAMANDO POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
function LemP.lavagLemPolicia(id,x,y,z,head)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
			TriggerClientEvent('iniciandolavagem',source,head,x,y,z)
			vRPclient._playAnim(source,false,{{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop"}},true)
			local random = math.random(100)
			if random >= 50 then
				vRPclient.setStandBY(source,parseInt(60))
				for l,w in pairs(policia) do
					local player = vRP.getUserSource(parseInt(w))
					if player then
						async(function()
							local ids = idgens:gen()
							blips[ids] = vRPclient.addBlip(player,x,y,z,1,59,"Ocorrencia",0.5,true)
							--TriggerClientEvent('chatMessage',player,"911",{64,64,255},"^1Lavagem^0 de dinheiro em andamento.")
							TriggerClientEvent("NotifyPush",{ code = 10, title = "Ocorrência em andamento", x = x, y = y, z = z, badge = "Lavagem de dinheiro." })
							SetTimeout(15000,function() vRPclient.removeBlip(player,blips[ids]) idgens:free(ids) end)
						end)
					end
				end
			end	
		end
	end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function LemP.checkPolice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		if #policia < 0 then
			TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.",8000)
			return false
		end
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO
-----------------------------------------------------------------------------------------------------------------------------------------
function LemP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"vanilla.permissao")
end

function LemP.webhookyakuza ()
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	return SendWebhookMessage(webhookyakuza,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[QUANTIA]: 100.000 "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
end