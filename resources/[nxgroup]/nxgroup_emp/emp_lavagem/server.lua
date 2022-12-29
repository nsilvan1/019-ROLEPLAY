local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

eG = {}
Tunnel.bindInterface("egEventss",eG)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookdlavagem = ""
function eG.lavarDinheiro()
    local source = source
    local user_id = vRP.getUserId(source)
    local banco = vRP.getBankMoney(user_id)
    local valor = vRP.prompt(source,"Quanto dinheiro você deseja lavar:","")
    local taxaMaquina = 0.90

    if vRP.hasPermission(user_id, "lavagem.permissao") then
        if valor == "" then 
            return TriggerClientEvent("Notify",source,"negado","Você precisa colocar um valor para confirmar sua solicitação.")
        end
        
        if vRP.getInventoryItemAmount(user_id,"dinheiro-sujo") >= parseInt(valor) then
            TriggerClientEvent("progress",source,10000,"Lavando Dinheiro")
            vRPclient._playAnim(source,false,{{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop"}},true)
            vRP.tryGetInventoryItem(user_id,"dinheiro-sujo",parseInt(valor))
            SetTimeout(10000,function()
                local valorfinal
                parseInt(valorfinal)
                valorfinal = valor * taxaMaquina
                vRPclient._stopAnim(source,false)
                vRP.setBankMoney(user_id,banco + valorfinal)
                TriggerClientEvent("Notify",source,"sucesso","Você lavou <b>$"..valor.."</b> dólares.\n E recebeu <b>$"..valorfinal.."</b> de dinheiro limpo.")
                SendWebhookMessage(webhookdlavagem,"```prolog\n[ID]: "..user_id.." \n[LAVOU]: "..valor.." Dólares sujos "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."\r```")
            end)
        else
            TriggerClientEvent("Notify",source,"negado","Você não tem <b>dinheiro sujo</b> suficiente na mochila.")
        end
    else
        TriggerClientEvent("Notify",source,"negado","Você não trabalha em nenhuma lavagem.")
    end
end