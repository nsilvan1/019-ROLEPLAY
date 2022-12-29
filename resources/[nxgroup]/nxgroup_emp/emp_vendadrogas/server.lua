local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

eG = {}
Tunnel.bindInterface("egEventss",eG)

local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local configAviaozinho = 700 --700
local bonusPolicia = 25 --50
local drogasPrice = {
    {"maconha",1200,1500,1,5,"motoclub.permissao"},
    {"cocaina",1200,1500,1,5,"gde.permissao"},
    {"metanfetamina",1200,1500,1,5,"ada.permissao"},
    {"lsd",1200,1500,1,5,nil},
    {"lancaperfume",1500,1800,1,5,nil},
}

function eG.receberVendaDroga(bonus)
    local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,'maconha') <= 0 and 
        vRP.getInventoryItemAmount(user_id,'cocaina') <= 0 and 
        vRP.getInventoryItemAmount(user_id,'metanfetamina') <= 0 and 
        vRP.getInventoryItemAmount(user_id, 'lancaperfume') <= 0 and 
        vRP.getInventoryItemAmount(user_id, 'lsd') <= 0 then
			TriggerClientEvent("Notify",source,"negado","Número insuficiente de <b>Drogas</b>.")
            return false
		else
            local aux = 0
            local qtd = 0
            local qtdSalvo = 0
            local valorDaDroga = 0
            local pagamento = 0
            local totalPagamento = 0
            local valorAdicionalDaDroga = 0
            local string = ""

            local policia = vRP.getUsersByPermission("policia.permissao")
            valorAdicionalDaDroga = bonusPolicia * #policia
            
            if not vRP.hasPermission(user_id,"ilegal.permissao") then
                valorAdicionalDaDroga = valorAdicionalDaDroga + configAviaozinho
            end

            for k,v in pairs(drogasPrice) do
                qtd = parseInt(math.random(v[4],v[5]))
                valorDaDroga = parseInt(math.random(v[2],v[3]))
                if vRP.getInventoryItemAmount(user_id,v[1]) >= qtd then
                    if vRP.tryGetInventoryItem(user_id,v[1],qtd) then
                        aux = aux + 1
                        qtdSalvo = qtd
                        pagamento = (valorDaDroga + valorAdicionalDaDroga) * qtd
                        string = string.."<br>"..qtd.." "..v[1].." "
				        -- TriggerClientEvent("Notify",source,"sucesso","Você vendeu <b>"..qtd.." "..v[1].."</b> por <b>$"..pagamento.."</b>.",10000)
                        totalPagamento = totalPagamento + pagamento
                    end
                end
            end
            
            if aux == 1 then
                local qtdExtra = 2
                for k,v in pairs(drogasPrice) do
                    if vRP.getInventoryItemAmount(user_id,v[1]) >= qtdExtra then
                        if vRP.tryGetInventoryItem(user_id,v[1],qtdExtra) then
                            aux = aux + 1
                            pagamento = (valorDaDroga + valorAdicionalDaDroga) * qtdExtra
                            string = "<br>"..qtdSalvo+qtdExtra.." "..v[1].." "
                            -- TriggerClientEvent("Notify",source,"sucesso","Você vendeu <b>"..qtdSalvo.." "..v[1].."</b> por <b>$"..pagamento.."</b>.",10000)
                            totalPagamento = totalPagamento + pagamento
                        end
                    end
                end
            end


			if totalPagamento > 0 then
				vRP.giveInventoryItem(user_id, "dinheiro-sujo", totalPagamento)
				TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..totalPagamento.." dólares</b> por "..string.."",10000)
				return true
			end	
		end
	end
	return false
end 

local blips = {}
function eG.marcarOcorrencia(ocorrencia)
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	local identity = vRP.getUserIdentity(user_id)
    local chance = math.random(1,100)

	if user_id then
        if chance > 60 then 
            TriggerClientEvent("Notify",source,"importante","Tome cuidado, algum morador te avistou entregando e avisou a polícia!",10000)
            exports['vrp_policia']:marcar_ocorrencia(source,'Recebemos uma denuncia de Venda de Drogas, verifique o ocorrido',84)
        end
    end
end