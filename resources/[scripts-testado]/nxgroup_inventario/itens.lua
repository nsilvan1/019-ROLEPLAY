local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
local cfg = module("vrp","cfg/groups")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vTASKBAR = Tunnel.getInterface('np-taskbarskill')
itens = {}

local idgens = Tools.newIDGenerator()
local groups = cfg.groups

local bandagem = {}
local actived = {}
local pick = {}

local webhooklockpick = "https://discord.com/api/webhooks/1058407547108868137/D77ucFFeJe3d4lNVbGbsCjX12Mz4nJWIN5bLCarxFzcQgiFb_o1KWYUqi4v-1TJR2KQG"

--[ BANDAGEM ]---------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(bandagem) do
			if v > 0 then
				bandagem[k] = v - 1
			end
		end
	end
end)

itens.usaveis = {
    ['jogodepneu'] = function(source,user_id) 
        if not vRPclient.isInVehicle(source) then
            local vehicle = vRPclient.getNearestVehicle(source,3)
            if vehicle then
                if vRP.hasPermission(user_id,"mecanico.permissao") then
                    local taskre = vTASKBAR.taskLockpick(source)
                    if taskre then
                        TriggerClientEvent('cancelando',source,true)
                        vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                        TriggerClientEvent("progress",source,10000,"Reparando Pneus")
                        SetTimeout(10000,function()
                            TriggerClientEvent('cancelando',source,false)
                            TriggerClientEvent('repararpneus',source,vehicle)
                            vRPclient._stopAnim(source,false)
                        end)
                    end
                else
                    local taskre = vTASKBAR.taskLockpick(source)
                    if taskre then
                        if vRP.tryGetInventoryItem(user_id,"jogodepneu",1) then
                            TriggerClientEvent('Creative:Update',source,'updateMochila')
                            TriggerClientEvent('cancelando',source,true)
                            vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                            TriggerClientEvent("progress",source,20000,"Reparando Pneus")
                            SetTimeout(20000,function()
                                TriggerClientEvent('cancelando',source,false)
                                TriggerClientEvent('repararpneus',source,vehicle)
                                vRPclient._stopAnim(source,false)
                            end)
                        end
                    end
                end
            end
        end
    end,

    ['tiocoin'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"tiocoin",1) then
            TriggerClientEvent("Notify",source,"sucesso","Bora trabalhar e fazer dinheiro moço!",8000)
        end
    end,

	['cocaina'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"cocaina",1) then
            vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
            TriggerClientEvent('cancelando',source,true)
            TriggerClientEvent("progress",source,10000,"Cheirando Cocaina")
            SetTimeout(10000,function()
                vRPclient._stopAnim(source,false)
                TriggerClientEvent('cancelando',source,false)
                vRPclient.playScreenEffect(source,"RaceTurbo",120)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",120)
                TriggerClientEvent("Notify",source,"sucesso","Cocaína utilizada com sucesso.",8000)
            end)
        end
    end,

    ['lsd'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"lsd",1) then
            vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
            TriggerClientEvent('cancelando',source,true)
            TriggerClientEvent("progress",source,10000,"Usando LSD")
            SetTimeout(10000,function()
                vRPclient._stopAnim(source,false)
                TriggerClientEvent('cancelando',source,false)
                vRPclient.playScreenEffect(source,"RaceTurbo",120)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",120)
                TriggerClientEvent("Notify",source,"sucesso","LSD  utilizado com sucesso.",8000)
            end)
        end
    end,

    ['maconha'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"maconha",1) then
            vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
            TriggerClientEvent("progress",source,10000,"Fumando Maconha")
            SetTimeout(10000,function()
                vRPclient._stopAnim(source,false)
                vRPclient.playScreenEffect(source,"RaceTurbo",180)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                TriggerClientEvent("Notify",source,"sucesso","Maconha utilizada com sucesso.",8000)
            end)
        end
    end,

    ['metanfetamina'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"metanfetamina",1) then
            TriggerClientEvent('EG:UpdateInv',source,'updateMochila')
            vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
            TriggerClientEvent("progress",source,10000,"Usando Meta")
            SetTimeout(10000,function()
                vRPclient._stopAnim(source,false)
                vRPclient.playScreenEffect(source,"RaceTurbo",180)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                TriggerClientEvent("Notify",source,"sucesso","Metanfetamina utilizada com sucesso.",8000)
            end)
        end	
    end,

    ['energetico'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"energetico",1) then
            TriggerClientEvent('cancelando',source,true)
            vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
            TriggerClientEvent("progress",source,10000,"Bebendo Energetico")
            SetTimeout(10000,function()
                TriggerClientEvent('energeticos',source,true)
                TriggerClientEvent('cancelando',source,false)
                vRPclient._DeletarObjeto(source)
                TriggerClientEvent("Notify",source,"sucesso","Energético utilizado com sucesso.",8000)
            end)
            SetTimeout(60000,function()
                TriggerClientEvent('energeticos',source,false)
                TriggerClientEvent("Notify",source,"importante","O efeito do energético passou e o coração voltou a bater normalmente.",8000)
            end)
        end
    end,

    ['conhaque'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"conhaque",1) then
            TriggerClientEvent('EG:UpdateInv',source,'updateMochila')
            TriggerClientEvent('cancelando',source,true)
            vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
            TriggerClientEvent("progress",source,30000,"Bebendo Conhaque")
            SetTimeout(30000,function()
                vRPclient.playScreenEffect(source,"RaceTurbo",180)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                TriggerClientEvent('cancelando',source,false)
                vRPclient._DeletarObjeto(source)
                TriggerClientEvent("Notify",source,"sucesso","Conhaque utilizado com sucesso.",8000)
            end)
        end
    end,

    ['absinto'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"absinto",1) then
            TriggerClientEvent('cancelando',source,true)
            vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
            TriggerClientEvent("progress",source,30000,"bebendo")
            SetTimeout(30000,function()
                vRPclient.playScreenEffect(source,"RaceTurbo",180)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                TriggerClientEvent('cancelando',source,false)
                vRPclient._DeletarObjeto(source)
                TriggerClientEvent("Notify",source,"sucesso","Absinto utilizado com sucesso.",8000)
            end)
        end
    end,

    ['whisky'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"whisky",1) then
            TriggerClientEvent('EG:UpdateInv',source,'updateMochila')
            TriggerClientEvent('cancelando',source,true)
            vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422)
            TriggerClientEvent("progress",source,30000,"Bebendo Whisky")
            SetTimeout(30000,function()
                vRPclient.playScreenEffect(source,"RaceTurbo",180)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                TriggerClientEvent('cancelando',source,false)
                vRPclient._DeletarObjeto(source)
                TriggerClientEvent("Notify",source,"sucesso","Whisky utilizado com sucesso.",8000)
            end)
        end
    end,

    ['vodka'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"vodka",1) then
            TriggerClientEvent('EG:UpdateInv',source,'updateMochila')
            TriggerClientEvent('cancelando',source,true)
            vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
            TriggerClientEvent("progress",source,30000,"Bebendo Vodka")
            SetTimeout(30000,function()
                vRPclient.playScreenEffect(source,"RaceTurbo",180)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                TriggerClientEvent('cancelando',source,false)
                vRPclient._DeletarObjeto(source)
                TriggerClientEvent("Notify",source,"sucesso","Vodka utilizada com sucesso.",8000)
            end)
        end
    end,

    ['tequila'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"tequila",1) then
            TriggerClientEvent('cancelando',source,true)
            vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
            TriggerClientEvent("progress",source,30000,"Bebendo Tequila")
            SetTimeout(30000,function()
                vRPclient.playScreenEffect(source,"RaceTurbo",180)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                TriggerClientEvent('cancelando',source,false)
                vRPclient._DeletarObjeto(source)
                TriggerClientEvent("Notify",source,"sucesso","Tequila utilizada com sucesso.",8000)
            end)
        end
    end,

    ['cerveja'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"cerveja",1) then
            TriggerClientEvent('cancelando',source,true)
            vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
            TriggerClientEvent("progress",source,30000,"Bebendo Cerveja")
            SetTimeout(30000,function()
                vRPclient.playScreenEffect(source,"RaceTurbo",180)
                vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                TriggerClientEvent('cancelando',source,false)
                vRPclient._DeletarObjeto(source)
                TriggerClientEvent("Notify",source,"sucesso","Cerveja utilizada com sucesso.",8000)
            end)
        end
    end,

    ['garrafavazia'] = function(source,user_id)
        local src = source
        TriggerClientEvent("waterfilter:use",source,1)
    end,

    ['agua'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "agua", 1) then
            vRP.giveInventoryItem(user_id,"garrafavazia",1)
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "ba_prop_club_water_bottle", 49, 28422)
            vRP.varyThirst(user_id,-50)
            TriggerClientEvent("progress", src, 10000, "Bebendo Agua")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,
    ['garrafadeleite'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "garrafadeleite", 1) then
            vRP.giveInventoryItem(user_id,"garrafavazia",1)
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "ba_prop_club_water_bottle", 49, 28422)
            vRP.varyThirst(user_id,-50)
            TriggerClientEvent("progress", src, 10000, "Bebendo Leite")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['coca'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "coca", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "ba_prop_club_water_bottle", 49, 28422)
            vRP.varyThirst(user_id,-50)
            TriggerClientEvent("progress", src, 10000, "Bebendo Coca Cola")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['cafe'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "cafe", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "prop_food_coffee", 49, 28422)
            vRP.varyThirst(user_id,-100)
            TriggerClientEvent("progress", src, 10000, "Bebendo Cafe")
            SetTimeout(10000,function()
                TriggerClientEvent('energeticos',source,true)
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
                TriggerClientEvent("Notify",source,"sucesso","Café utilizado com sucesso.",8000)
            end)
            SetTimeout(60000,function()
                TriggerClientEvent('energeticos',source,false)
                TriggerClientEvent("Notify",source,"importante","O efeito do café passou e o coração voltou a bater normalmente.",8000)
            end)
        end
    end,

    ['toddynho'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "toddynho", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "toddynho", 49, 28422)
            vRP.varyThirst(user_id,-35)
            TriggerClientEvent("progress", src, 10000, "Bebendo Toddynho")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['laranja'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "laranja", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "mp_player_inteat@burger", "mp_player_int_eat_burger", "prop_cs_burger_01", 49, 60309)
            vRP.varyThirst(user_id,-25)
            TriggerClientEvent("progress", src, 10000, "Chupando uma Laranja")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['hamburguer'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "hamburguer", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "mp_player_inteat@burger", "mp_player_int_eat_burger", "prop_cs_burger_01", 49, 60309)
            vRP.varyHunger(user_id,-50)
            TriggerClientEvent("progress", src, 10000, "Comendo Hamburguer")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['sanduiche'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "sanduiche", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "mp_player_inteat@burger", "mp_player_int_eat_burger", "prop_cs_burger_01", 49, 60309)
            vRP.varyHunger(user_id,-50)
            TriggerClientEvent("progress", src, 10000, "Comendo Sanduiche")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['taco'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "taco", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "mp_player_inteat@burger", "mp_player_int_eat_burger", "prop_cs_burger_01", 49, 60309)
            vRP.varyHunger(user_id,-50)
            TriggerClientEvent("progress", src, 10000, "Comendo Taco")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['tomate'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "tomate", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "mp_player_inteat@burger", "mp_player_int_eat_burger", "prop_cs_burger_01", 49, 60309)
            vRP.varyHunger(user_id,-25)
            TriggerClientEvent("progress", src, 10000, "Comendo Tomate")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['pizza'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "pizza", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "mp_player_inteat@burger", "mp_player_int_eat_burger", "prop_cs_burger_01", 49, 60309)
            vRP.varyHunger(user_id,-50)
            TriggerClientEvent("progress", src, 10000, "Comendo Pizza")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['biscoito'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "biscoito", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "mp_player_inteat@burger", "mp_player_int_eat_burger", "prop_cs_burger_01", 49, 60309)
            vRP.varyHunger(user_id,-50)
            TriggerClientEvent("progress", src, 10000, "Comendo Biscoito")
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['chocolate'] = function(source,user_id)
        local src = source
        if vRP.tryGetInventoryItem(user_id, "chocolate", 1) then
            TriggerClientEvent("cancelando", src, true)
            vRPclient._CarregarObjeto(src, "mp_player_inteat@burger", "mp_player_int_eat_burger",  "prop_choc_ego", 49, 60309)
            TriggerClientEvent("progress", src, 10000, "Comendo Chocolate")
            vRP.varyHunger(user_id,-25)
            SetTimeout(10000,function()
                TriggerClientEvent("cancelando", src, false)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['mochila'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"mochila",1) then
            vRP.varyExp(user_id,"physical","strength",650)
            TriggerClientEvent("Notify",source,"sucesso","Mochila utilizada com sucesso.",8000)
        end
    end,
    -- ['notebook'] = function(source,user_id)
    --     if vRP.tryGetInventoryItem(user_id,"notebook",1) then
    --         TriggerClientEvent("tksNote:open", source)
    --     end
    -- end,

    ['scanerMotor'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"scanerMotor",1) then
            TriggerClientEvent("tksNote:open", source)
        end
    end,


    ['colete'] = function(source,user_id)
        if vRP.tryGetInventoryItem(user_id,"colete",1) then
            vRPclient.setArmour(source,100)
        end
    end,

    ['capuz'] = function(source,user_id) 
        if vRP.tryGetInventoryItem(user_id,"capuz",1) then
            local nplayer = vRPclient.getNearestPlayer(source,2)
            if nplayer then
                vRPclient.setCapuz(nplayer)
                vRP.closeMenu(nplayer)
                TriggerClientEvent("Notify",source,"sucesso","Capuz utilizado com sucesso.",8000)
            end
        end
    end,

    ['repairkit'] = function(source,user_id) 
        if not vRPclient.isInVehicle(source) then
            local vehicle = vRPclient.getNearestVehicle(source,3.5)
            if vehicle then
                if vRP.hasPermission(user_id,"mecanico.permissao") then
                    TriggerClientEvent('cancelando',source,true)
                    vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                    TriggerClientEvent("progress",source,30000,"Reparando veículo")
                    SetTimeout(30000,function()
                        TriggerClientEvent('cancelando',source,false)
                        TriggerClientEvent('reparar',source)
                        vRPclient._stopAnim(source,false)
                    end)
                else
                    if vRP.tryGetInventoryItem(user_id,"repairkit",1) then
                        local taskre = vTASKBAR.taskLockpick(source)
                        if taskre then
                            TriggerClientEvent('cancelando',source,true)
                            vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                            TriggerClientEvent("progress",source,30000,"Reparando veículo")
                            SetTimeout(30000,function()
                                TriggerClientEvent('cancelando',source,false)
                                TriggerClientEvent('reparar',source)
                                vRPclient._stopAnim(source,false)
                            end)
                        end
                    end
                end
            end
        end
    end,

    -- ['repairkit'] = function(source,user_id) 
    --     if not vRPclient.isInVehicle(source) then
    --         local vehicle = vRPclient.getNearestVehicle(source,3.5)
    --         if vehicle then
    --             if vRP.hasPermission(user_id,"mecanico.permissao") then
    --                 actived[user_id] = true
    --                 TriggerClientEvent('cancelando',source,true)
    --                 vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
    --                 TriggerClientEvent("progress",source,30000,"Reparando Veículo")
    --                 SetTimeout(30000,function()
    --                     actived[user_id] = nil
    --                     TriggerClientEvent('cancelando',source,false)
    --                     TriggerClientEvent('reparar',source)
    --                     vRPclient._stopAnim(source,false)
    --                 end)
    --             else
    --                 if vRP.tryGetInventoryItem(user_id,"repairkit",1) then
    --                     actived[user_id] = true
    --                     TriggerClientEvent('EG:UpdateInv',source,'updateMochila')
    --                     TriggerClientEvent('cancelando',source,true)
    --                     vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
    --                     TriggerClientEvent("progress",source,30000,"Reparando Veículo")
    --                     SetTimeout(30000,function()
    --                         actived[user_id] = nil
    --                         TriggerClientEvent('cancelando',source,false)
    --                         TriggerClientEvent('reparar',source)
    --                         vRPclient._stopAnim(source,false)
    --                     end)
    --                 end
    --             end
    --         end
    --     end
    -- end,


    ['placa'] = function(source,user_id) 
        if vRPclient.GetVehicleSeat(source) then
            if vRP.tryGetInventoryItem(user_id,"placa",1) then
                local placa = vRP.generatePlate()
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("vehicleanchor",source)
                TriggerClientEvent("progress",source,59500,"Clonando a Placa")
                SetTimeout(60000,function()
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("cloneplates",source,placa)
                    TriggerClientEvent("Notify",source,"sucesso","Placa clonada com sucesso.",8000)
                end)
            end
        end
    end,

    ['militec'] = function(source,user_id) 
        if not vRPclient.isInVehicle(source) then
            local vehicle = vRPclient.getNearestVehicle(source,3.5)
            if vehicle then
                if vRP.hasPermission(user_id,"mecanico.permissao") then
                    actived[user_id] = true
                    TriggerClientEvent('cancelando',source,true)
                    vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                    TriggerClientEvent("progress",source,30000,"Reparando o Motor")
                    SetTimeout(30000,function()
                        actived[user_id] = nil
                        TriggerClientEvent('cancelando',source,false)
                        TriggerClientEvent('repararmotor',source,vehicle)
                        vRPclient._stopAnim(source,false)
                    end)
                else
                    if vRP.tryGetInventoryItem(user_id,"militec",1) then
                        actived[user_id] = true
                        TriggerClientEvent('cancelando',source,true)
                        vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                        TriggerClientEvent("progress",source,30000,"Reparando o Motor")
                        SetTimeout(30000,function()
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            TriggerClientEvent('repararmotor',source,vehicle)
                            vRPclient._stopAnim(source,false)
                        end)
                    end
                end
            end
        end
    end,

    ['dorfrex'] = function(source,user_id) 
        local src = source
        if vRP.tryGetInventoryItem(user_id,"dorfrex",1) then
            actived[user_id] = true
            vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)
            TriggerClientEvent("progress",source,10000,"Tomando Dorfrex")

            SetTimeout(10000,function()
                actived[user_id] = nil
                vRPclient._stopAnim(source,false)
                TriggerClientEvent("remedios",source)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['bandagem'] = function(source,user_id) 
        local src = source
        if vRP.tryGetInventoryItem(user_id,"bandagem",1) then
            actived[user_id] = true
            vRPclient._CarregarObjeto(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)
            TriggerClientEvent("progress",source,10000,"Usando Bandagem")
            SetTimeout(10000,function()
                actived[user_id] = nil
                vRPclient._stopAnim(source,false)
                TriggerClientEvent("remedios2",source)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['paracetamil'] = function(source,user_id) 
        local src = source
        if vRP.tryGetInventoryItem(user_id,"paracetamil",1) then
            actived[user_id] = true
            vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)
            TriggerClientEvent("progress",source,10000,"Tomando Paracetamil")

            SetTimeout(10000,function()
                actived[user_id] = nil
                vRPclient._stopAnim(source,false)
                TriggerClientEvent("remedios2",source)
                vRPclient._DeletarObjeto(src)
            end)
        end
    end,

    ['buscopom'] = function(source,user_id) 
        local src = source
        if vRP.tryGetInventoryItem(user_id,"buscopom",1) then
            actived[user_id] = true
            vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)
            TriggerClientEvent("progress",source,10000,"Tomando Buscopom")

            SetTimeout(10000,function()
                actived[user_id] = nil
                vRPclient._stopAnim(source,false)
                TriggerClientEvent("remedios2",source)
                vRPclient._DeletarObjeto(src)
                TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Buscopom</b>.")
            end)
        end
    end,

 
    ['lockpick'] = function(source,user_id) 
        -- local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
        local vehicle,mNet,mPlaca,mName,mLock,mBanido,trunk,mModel,mStreet = vRPclient.vehList(source,7)
        local policia = vRP.getUsersByPermission("policia.permissao")

        if #policia < 0 then
            TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "Policiais insuficientes em serviço.", 5000)
            return true
        end

        if vRP.hasPermission(user_id,"policia.permissao") then
            TriggerEvent("setPlateEveryone",mPlaca)
            SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(mNet), 1)
            TriggerClientEvent("vrp_sound:source",user_id,'lock',0.5)
            return
        end

        if vRP.getInventoryItemAmount(user_id,"lockpick") >= 1 and vehicle then
                local taskre = vTASKBAR.taskLockpick(source)
                if taskre then
                    if vRP.hasPermission(user_id,"mecanico.permissao") then
                        TriggerEvent("setPlateEveryone",mPlaca)
                        SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(mNet), 1)
                        return
                    end

                    TriggerClientEvent('cancelando',source,true)
                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                    TriggerClientEvent("progress",source,3000,"Passando Lockpick")

                    SetTimeout(3000,function()
                        TriggerClientEvent('cancelando',source,false)
                        vRPclient._stopAnim(source,false)

                        if math.random(100) >= 50 then
                            if vRP.tryGetInventoryItem(user_id,"lockpick",1) then
                                TriggerEvent("setPlateEveryone",mPlaca)
                                SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(mNet), 1)
                                local x,y,z = vRPclient.getPosition(source)
                                SendWebhookMessage(webhooklockpick,"```prolog\n[ID]: "..user_id.."\n[VEICULO]:"..mName.."\n [PLACA]:"..mPlaca.." \n[COORDENADA]:"..x..","..y..","..z.." \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S  \r```"))
                                SendWebhookMessage(webhooklockpick,"```prolog\n[ID]: "..user_id.."\n[VEICULO]:"..mName.."\n[SUCESSO] \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S  \r```"))
                                TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
                            end
                        else
                            TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "Roubo do veículo falhou e as autoridades foram acionadas.", 5000)
                            local policia = vRP.getUsersByPermission("policia.permissao")
                            local x,y,z = vRPclient.getPosition(source)
                            for k,v in pairs(policia) do
                                local player = vRP.getUserSource(parseInt(v))
                                if player then
                                    async(function()
                                        local id = idgens:gen()
                                        vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
                                        SendWebhookMessage(webhooklockpick,"```prolog\n[ID]: "..user_id.."\n[VEICULO]:"..mName.." \n[COORDENADA]:"..x..","..y..","..z.." \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S  \r```"))
                                        SendWebhookMessage(webhooklockpick,"```prolog\n[ID]: "..user_id.."\n[VEICULO]:"..mName.."\n[ERRO] \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S  \r```"))
                                        TriggerClientEvent('chatMessage',player,"[911 - ROUBO VEÍCULO]",{64,64,255},"Roubo na ^1"..mStreet.."^0 do veículo ^1"..mModel.."^0 de placa ^1"..mPlaca.."^0 verifique o ocorrido.")
                                        pick[id] = vRPclient.addBlip(player,x,y,z,10,5,"Ocorrência",0.5,false)
                                        TriggerClientEvent("NotifyPush", player, { code = 20, title = "Ocorrência em andamento", text = "Roubo de veículo", x = x ,y = y , z = z , rgba = {140,35,35} })
                                        SetTimeout(40000,function() vRPclient.removeBlip(player,pick[id]) idgens:free(id) end)
                                    end)
                                end
                            end
                        end
                    end)
                else
                    if vRP.tryGetInventoryItem(user_id,"lockpick",1) then
                        SendWebhookMessage(webhooklockpick,"```prolog\n[ID]: "..user_id.."\n[VEICULO]:"..mName.."\n[QUEBROU] \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S  \r```"))
                        TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "Roubo do veículo falhou", 5000)
                    end 
                end

        end
    end,

    ['masterpick'] = function(source,user_id) 
        -- local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
        local vehicle,mNet,mPlaca,mName,mLock,mBanido,trunk,mModel,mStreet = vRPclient.vehList(source,7)
        local policia = vRP.getUsersByPermission("policia.permissao")

        if #policia < 0 then
            TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "Policiais insuficientes em serviço.", 5000)
            return true
        end

        if vRP.hasPermission(user_id,"policia.permissao") then
            TriggerEvent("setPlateEveryone",mPlaca)
            SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(mNet), 1)
            TriggerClientEvent("vrp_sound:source",user_id,'lock',0.5)
            return
        end

        if vRP.getInventoryItemAmount(user_id,"masterpick") >= 1 and vehicle then
                -- local taskre = vTASKBAR.taskLockpick(source)
                -- if taskre then
                    if vRP.hasPermission(user_id,"mecanico.permissao") then
                        TriggerEvent("setPlateEveryone",mPlaca)
                        SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(mNet), 1)
                        return
                    end

                    TriggerClientEvent('cancelando',source,true)
                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                    TriggerClientEvent("progress",source,3000,"Passando Masterpick")

                    SetTimeout(3000,function()
                        TriggerClientEvent('cancelando',source,false)
                        vRPclient._stopAnim(source,false)

                        if vRP.tryGetInventoryItem(user_id,"masterpick",1) then
                            TriggerEvent("setPlateEveryone",mPlaca)
                            SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(mNet), 1)
                            local x,y,z = vRPclient.getPosition(source)
                            SendWebhookMessage(webhooklockpick,"```prolog\n[ID]: "..user_id.."\n[VEICULO]:"..mName.."\n[PLACA]:"..mPlaca.." \n[COORDENADA]:"..x..","..y..","..z.." \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S  \r```"))
                            SendWebhookMessage(webhooklockpick,"```prolog\n[ID]: "..user_id.."\n[VEICULO]:"..mName.."\n[SUCESSO] \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S  \r```"))
                            TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
                        end
                        
                    end)
                    
                -- else
                --     if vRP.tryGetInventoryItem(user_id,"masterpick",1) then
                --         SendWebhookMessage(webhooklockpick,"```prolog\n[ID]: "..user_id.."\n[VEICULO]:"..mName.."\n[QUEBROU] \n"..os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S  \r```"))
                --         TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "Roubo do veículo falhou", 5000)
                --     end 
                -- end
        end
    end,
}

return itens