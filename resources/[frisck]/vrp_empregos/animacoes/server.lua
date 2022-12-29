local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- /e
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('e', function(source,args,rawCommand)
	TriggerClientEvent("emotes",source,args[1])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /e2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('e2', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"medico.permissao") or vRP.hasPermission(user_id,"ceo.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			TriggerClientEvent("emotes",nplayer,args[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEIJAR PEDINDO PRA OUTRA PESSOA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("beijar",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRPclient.getNearestPlayer(source,2)
    if nplayer then
        local request = vRP.request(nplayer,"Deseja bejiar?",10)
        if request then
            vRPclient.playAnim(source,true,{{"mp_ped_interaction","kisses_guy_a"}},false)    
            vRPclient.playAnim(nplayer,true,{{"mp_ped_interaction","kisses_guy_b"}},false)
        end
    end
end)

RegisterCommand("abracar",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRPclient.getNearestPlayer(source,2)
    if nplayer then
        local request = vRP.request(nplayer,"Deseja Abracar?",10)
        if request then
            vRPclient.playAnim(source,true,{{"mp_ped_interaction","hugs_guy_a"}},false)    
            vRPclient.playAnim(nplayer,true,{{"mp_ped_interaction","hugs_guy_b"}},false)
        end
    end
end)

RegisterCommand("namoro",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRPclient.getNearestPlayer(source,2)
    if nplayer then
        local request = vRP.request(nplayer,"Deseja Abracar?",10)
        if request then
            vRPclient.playAnim(source,false,{{"misscarsteal2chad_goodbye","chad_armsaround_chad"}},false)    
            vRPclient.playAnim(nplayer,false,{{"misscarsteal2chad_goodbye","chad_armsaround_girl"}},false)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PANO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryclean")
AddEventHandler("tryclean",function(nveh)
	TriggerClientEvent("syncclean",-1,nveh)
end)