local Tunnel = module('vrp', "lib/Tunnel")
local Proxy = module('vrp',"lib/Proxy")
local cFG = module("clonagem", "config")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
cnCL = {}
Tunnel.bindInterface("clonagem_server",cnCL)

vRP.prepare("insertSolicitacaoCloned",
             "INSERT INTO vehicle_cloned_solicit(user_id, vehicle, dataInicio,dataCloned, dataFim) VALUES(@user_id, @vehicle, NOW(), ADDDATE(NOW(), INTERVAL @minut MINUTE) ,ADDDATE(NOW(), INTERVAL @days DAY) )")
vRP.prepare("insertCloned",
             "INSERT INTO vehicle_cloned(user_id, vehicle, dataInicio, dataFim) VALUES(@user_id, @vehicle, NOW(), ADDDATE(NOW(), INTERVAL @days DAY) )")
vRP.prepare("queryValidateCloned",
             "SELECT * FROM vehicle_cloned_solicit x WHERE x.dataCloned <= NOW() AND vehicle = @vehicle AND user_id = @user_id")
vRP.prepare("queryCloned",
             "SELECT * FROM vehicle_cloned_solicit x WHERE vehicle = @vehicle AND user_id = @user_id")
vRP.prepare("queryLimitCloned",
             "SELECT * FROM vehicle_cloned x WHERE  user_id = @user_id")             
vRP.prepare("queryValidate",
             " SELECT * FROM vehicle_cloned x WHERE x.dataFim >= NOW() AND vehicle = @vehicle AND user_id = @user_id")             
             
vRP.prepare("addUserVehicle",[[
                INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,detido,time,engine,body,fuel,ipva) 
                VALUES(@user_id,@vehicle,0,0,1000,1000,100,0);]])          



function cnCL.insertSolicitacaoCloned ()
    local pago = false
    local source = source
    local user_id = vRP.getUserId(source)
    local vehicle, vnetid, placa, vname, lock, banned =
    vRPclient.vehList(source, 7)
    local puser_id = vRP.getUserByRegistration(placa)
    local type = vRP.vehicleType(vname)  
    if type == "work" then
        TriggerClientEvent("Notify",source,"negado","Você não pode clonar veículos de trabalho")
    else 
        local rows,affected = vRP.query("queryLimitCloned",{ user_id = user_id })
        if #rows <= cFG.limiteCloned then
            local rows,affected = vRP.query("queryCloned",{ user_id = user_id, vehicle = vname })
            if #rows > 0 then
                local rows,affected = vRP.query("queryValidateCloned",{ user_id = user_id, vehicle = vname })
                if #rows > 0 then
                    local rows,affected = vRP.query("queryValidate",{ user_id = user_id, vehicle = vname })
                    if #rows <= 0 then
                    vRP.execute("insertCloned",{ user_id = user_id, vehicle = vname, days = cFG.daysCloned })
                    vRP.execute("addUserVehicle", { user_id = user_id, vehicle = vname})
                    TriggerClientEvent("Notify",source,"sucesso","O veículo " .. vname .. " foi clonado com sucesso ")        
                    else 
                    TriggerClientEvent("Notify",source,"negado","Este veiculo " .. vname .. " já foi clonado ")
                    end 
                else
                    TriggerClientEvent("Notify",source,"negado","Este veiculo " .. vname .. " ainda não está liberado para a clonagem ")
                end 
            else 
                
                if puser_id == user_id then                 
                    TriggerClientEvent("Notify",source,"negado","Você não pode clonar o seu proprio veiculo "..vname)
                -- elseif  puser_id == nil then 
                --     TriggerClientEvent("Notify",source,"negado","Você não pode clonar veiculos de americanos ")
                else 
                    if cFG.pagamento ==  'Dinheiro' then 
                        if vRP.tryFullPayment(user_id, cFG.valor) then 
                            TriggerClientEvent("Notify",source,"sucesso","O pagamento de ".. cFG.valor .. " realizado com sucesso")        
                            pago = true
                        else 
                            TriggerClientEvent("Notify", source,"negado", "Você não possui dinheiro suficiente para pagar uma clonagem" )
                        end
                    elseif cFG.pagamento ==  'Sujo'  then
                        if vRP.tryGetInventoryItem(user_id,"dinheirosujo",cFG.valor) then 
                            TriggerClientEvent("Notify",source,"sucesso","O pagamento de ".. cFG.valor .. " realizado com sucesso")        
                            pago = true
                        else
                            TriggerClientEvent("Notify",source,"negado","Dinheiro sujo <b>insuficiente</b>.")
                        end
                    end 
                    if pago then 
                        TriggerClientEvent("Notify",source,"sucesso","O pagamento de ".. cFG.valor .. " realizado com sucesso")        
                        vRP.execute("insertSolicitacaoCloned",{ user_id = user_id,  vehicle= vname ,minut = cFG.minut,  days = cFG.days })
                        TriggerClientEvent("Notify",source,"sucesso","A solicitacao de clonagem do veículo " .. vname .. " foi recebida e estará disponivel em " ..cFG.minut .. " minutos.")        
                    end
                end;
            end
        else 
            TriggerClientEvent("Notify",source,"negado","Você não pode mais clonar veiculos ")
        end 
    end
end