local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("vrp_player",src)
Proxy.addInterface("vrp_player",src)

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