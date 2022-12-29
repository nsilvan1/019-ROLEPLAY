local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")


eG = {}
Tunnel.bindInterface("vrp_animacoes",eG)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /e
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e",function(source,args,rawCommand)
	local source = source
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local nplayer = vRPclient.getNearestPlayer(source,3)	
		
		if args[1] == "fumar" then
		vRP.antiflood(source,"Flodando animação de fumar pra cair todos no limbo",4)
		elseif args[1] == "fumar2" then
		vRP.antiflood(source,"Flodando animação de fumar pra cair todos no limbo",4)
		elseif args[1] == "fumar3" then
		vRP.antiflood(source,"Flodando animação de fumar pra cair todos no limbo",4)
		elseif args[1] == "tragar" then
		vRP.antiflood(source,"Flodando animação de tragar pra cair todos no limbo",4)
		elseif args[1] == "beber" then
		vRP.antiflood(source,"Flodando animação de beber pra cair todos no limbo",4)
		elseif args[1] == "beber2" then
		vRP.antiflood(source,"Flodando animação de beber pra cair todos no limbo",4)
		elseif args[1] == "beber3" then
		vRP.antiflood(source,"Flodando animação de beber pra cair todos no limbo",4)
		elseif args[1] == "beber4" then
		vRP.antiflood(source,"Flodando animação de beber pra cair todos no limbo",4)
		elseif args[1] == "beber5" then
		vRP.antiflood(source,"Flodando animação de beber pra cair todos no limbo",4)
		elseif args[1] == "beber6" then
		vRP.antiflood(source,"Flodando animação de beber pra cair todos no limbo",4)
		elseif args[1] == "beber7" then
		vRP.antiflood(source,"Flodando animação de beber pra cair todos no limbo",4)
		elseif args[1] == "beber8" then
		vRP.antiflood(source,"Flodando animação de beber pra cair todos no limbo",4)
		elseif args[1] == "musica" then
		vRP.antiflood(source,"Flodando animação de musica pra cair todos no limbo",4)
		elseif args[1] == "musica2" then
		vRP.antiflood(source,"Flodando animação de musica pra cair todos no limbo",4)
		elseif args[1] == "musica3" then
		vRP.antiflood(source,"Flodando animação de musica pra cair todos no limbo",4)
		elseif args[1] == "musica4" then
		vRP.antiflood(source,"Flodando animação de musica pra cair todos no limbo",4)
		elseif args[1] == "ligar" then
		vRP.antiflood(source,"Flodando animação de ligar pra cair todos no limbo",4)
		end

		if nplayer and not vRPclient.isInVehicle(nplayer) and not vRPclient.isHandcuffed(nplayer) and vRPclient.getHealth(nplayer) > 101 then
			if args[1] == "beijar" then
				TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "importante","Aguardando a pessoa próxima aceitar a animação.", 5000)
				if vRP.request(nplayer,"Deseja beijar <b>"..identity["name"].." "..identity["firstname"].."</b> ?",5) then
					TriggerClientEvent("syncAnim",source,1.3)
					TriggerClientEvent("syncAnimAll",source,"beijar")
					TriggerClientEvent("syncAnimAll",nplayer,"beijar")
				else
					TriggerClientEvent("Notify",source,"Negado", "importante","A pessoa negou o beijo.", 5000)
				end
			elseif args[1] == "abracar" then
				TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "importante","Aguardando a pessoa próxima aceitar a animação.", 5000)
				if vRP.request(nplayer,"Deseja abraçar <b>"..identity["name"].." "..identity["firstname"].."</b> ?",5) then
					TriggerClientEvent("syncAnim",source,0.8)
					TriggerClientEvent("syncAnimAll",source,"abracar")
					TriggerClientEvent("syncAnimAll",nplayer,"abracar")
				else
					TriggerClientEvent("Notify",source,"Negado", "importante","A pessoa negou o abraço.", 5000)
				end
			elseif args[1] == "abracar2" then
				TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "importante","Aguardando a pessoa próxima aceitar a animação.", 5000)
				if vRP.request(nplayer,"Deseja abraçar <b>"..identity["name"].." "..identity["firstname"].."</b> ?",5) then
					TriggerClientEvent("syncAnim",source,1.2)
					TriggerClientEvent("syncAnimAll",source,"abracar2")
					TriggerClientEvent("syncAnimAll",nplayer,"abracar2")
				else
					TriggerClientEvent("Notify",source,"Negado", "importante","A pessoa negou o abraço.", 5000)
				end
			elseif args[1] == "abracar3" then
				TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "importante","Aguardando a pessoa próxima aceitar a animação.", 5000)
				if vRP.request(nplayer,"Deseja abraçar <b>"..identity["name"].." "..identity["firstname"].."</b> ?",5) then
					TriggerClientEvent("syncAnim",source,0.8)
					TriggerClientEvent("syncAnimAll",source,"abracar3")
					TriggerClientEvent("syncAnimAll",nplayer,"abracar3")
				else
					TriggerClientEvent("Notify",source,"Negado", "importante","A pessoa negou o abraço.", 5000)
				end
			elseif args[1] == "abracar4" then
				TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "importante","Aguardando a pessoa próxima aceitar a animação.", 5000)
				if vRP.request(nplayer,"Deseja abraçar <b>"..identity["name"].." "..identity["firstname"].."</b> ?",5) then
					TriggerClientEvent("syncAnim",source,1.4)
					TriggerClientEvent("syncAnimAll",source,"abracar4")
					TriggerClientEvent("syncAnimAll",nplayer,"abracar4")
				else
					TriggerClientEvent("Notify",source,"Negado", "importante","A pessoa negou o abraço.", 5000)
				end
			elseif args[1] == "dancar257" then
				TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "importante","Aguardando a pessoa próxima aceitar a animação.", 5000)
				if vRP.request(nplayer,"Deseja dançar com <b>"..identity["name"].." "..identity["firstname"].."</b> ?",5) then
					TriggerClientEvent("syncAnim",source,1.0)
					TriggerClientEvent("syncAnimAll",source,"dancar257")
					TriggerClientEvent("syncAnimAll",nplayer,"dancar257")
					-- Citizen.Wait(13000)
					vRPclient._DeletarObjeto(source)
					vRPclient._DeletarObjeto(nplayer)
				else
					TriggerClientEvent("Notify",source,"Negado", "importante","A pessoa negou a dança.", 5000)
				end
			elseif args[1] == "dancar258" then
				TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "importante","Aguardando a pessoa próxima aceitar a animação.", 5000)
				if vRP.request(nplayer,"Deseja dançar com <b>"..identity["name"].." "..identity["firstname"].."</b> ?",5) then
					TriggerClientEvent("syncAnim",source,1.0)
					TriggerClientEvent("syncAnimAll",source,"dancar258")
					TriggerClientEvent("syncAnimAll",nplayer,"dancar258")
					-- Citizen.Wait(12000)
					vRPclient._DeletarObjeto(source)
					vRPclient._DeletarObjeto(nplayer)
				else
					TriggerClientEvent("Notify",source,"Negado", "importante","A pessoa negou a dança.", 5000)
				end
			elseif args[1] == "dancar259" then
				TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "importante","Aguardando a pessoa próxima aceitar a animação.", 5000)
				if vRP.request(nplayer,"Deseja dançar com <b>"..identity["name"].." "..identity["firstname"].."</b> ?",5) then
					TriggerClientEvent("syncAnim",source,1.0)
					TriggerClientEvent("syncAnimAll",source,"dancar259")
					TriggerClientEvent("syncAnimAll",nplayer,"dancar259")
					-- Citizen.Wait(11000)
					vRPclient._DeletarObjeto(source)
					vRPclient._DeletarObjeto(nplayer)
				else
					TriggerClientEvent("Notify",source,"Negado", "importante","A pessoa negou a dança.", 5000)
				end
			elseif args[1] == "casal" then
				TriggerClientEvent("nyo_notify",source, "#FFA500","Alerta", "importante","Aguardando a pessoa próxima aceitar a animação.", 5000)
				if vRP.request(nplayer,"Deseja casal com <b>"..identity["name"].." "..identity["firstname"].."</b> ?",5) then
					TriggerClientEvent("syncAnim",source,0.3)
					TriggerClientEvent("syncAnimAll",source,"casal",1)
					TriggerClientEvent("syncAnimAll",nplayer,"casal",2)
				else
					TriggerClientEvent("Notify",source,"Negado", "importante","A pessoa negou o casal.", 5000)
				end
			end		
		end
		TriggerClientEvent("emotes",source,args[1])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /e2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('e2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			TriggerClientEvent("emotes",nplayer,args[1])
		end
	end
end)

RegisterCommand('e3',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local nplayer = vRPclient.getNearestPlayers(source,30)
		for k,v in pairs(nplayer) do 
			TriggerClientEvent("emotes",k,args[1])
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
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC PARTICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trySyncParticle")
AddEventHandler("trySyncParticle",function(asset,v)
    TriggerClientEvent("startSyncParticle",-1,asset,v)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOP SYNC PARTICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryStopParticle")
AddEventHandler("tryStopParticle",function(v)
    TriggerClientEvent("stopSyncParticle",-1,v)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKS ANIM
-----------------------------------------------------------------------------------------------------------------------------------------
local ac_webhook = ""

function banir(user_id)
	source = vRP.getUserSource(user_id)
	if source ~= nil then
		local ped = GetPlayerPed(source) 
		local loc = GetEntityCoords(ped) 
		local reason = "ANTI HACK: 	localização:	"..loc.x..","..loc.y..","..loc.z
		vRP.setBanned(user_id,true)					
		local temp = os.date("%x  %X")
		local msg = "Puxando todos players!"
		PerformHttpRequest(ac_webhook, function(err, text, headers) end, 'POST', json.encode({content = "ANTI HACK	[ID]: "..user_id.."		"..temp.."[BAN]		[MOTIVO:"..msg.."]	"..reason}), { ['Content-Type'] = 'application/json' }) 		
		TriggerClientEvent("vrp_sound:source",source,"ban",1.0)
		Citizen.Wait(4000)
		source = vRP.getUserSource(user_id)
		vRP.kick(source,"Tentativa de bug!")						
	end
end

------------------------------------------------------------
--  CARREGAR NO OMBRO
----------------------------------------------------------------
RegisterServerEvent('cmg2_animations:syncSCRIPTFODIDO')
AddEventHandler('cmg2_animations:syncSCRIPTFODIDO', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	local source = source
	vRP.antiflood(source,"cmg2_animations:syncSCRIPTFODIDO",8)
	local user_id = vRP.getUserId(source)
	if(target~=0 or targetSrc~=0)then
		banir(user_id)
		return
	end
	if vRPclient.isInVehicle(source) then
		TriggerClientEvent("Notify",source,"negado","Você não pode carregar de dentro do carro.")
		return
	end

	targetSrc = vRPclient.getNearestPlayer(source,3)

	animationLib		= "missfinale_c2mcs_1"
	animationLib2		= "nm"
	animation 			= "fin_c2_mcs_1_camman"
	animation2			= "firemans_carry"
	distans 			= 0.15
	distans2 			= 0.27
	height 				= 0.63
	length 				= 100000
	spin 				= 0.0			
	controlFlagSrc 		= 49
	controlFlagTarget 	= 33
	animFlagTarget 		= 1
		
	if vRP.getInventoryItemAmount(user_id,'corda') >= 1 then
		TriggerClientEvent('cmg2_animations:syncTargetSCRIPTFODIDO', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
		TriggerClientEvent('cmg2_animations:syncMeSCRIPTFODIDO', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
		return
	end
	if targetSrc ~= nil and vRPclient.isInComa(targetSrc) then
		TriggerClientEvent('cmg2_animations:syncTargetSCRIPTFODIDO', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
		TriggerClientEvent('cmg2_animations:syncMeSCRIPTFODIDO', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
	else 
		TriggerClientEvent("Notify",source,"importante","Você não pode carregar uma pessoa viva.")
	end
end)

RegisterServerEvent('cmg2_animations:stopSCRIPTFODIDO')
AddEventHandler('cmg2_animations:stopSCRIPTFODIDO', function(targetSrc)
	vRP.antiflood(source,"cmg2_animations:stopSCRIPTFODIDO",8)
	local user_id = vRP.getUserId(source)
	if(targetSrc~=0)then
		banir(user_id)
		return
	end
	targetSrc = vRPclient.getNearestPlayer(source,3)
	if targetSrc ~= nil then
	TriggerClientEvent('cmg2_animations:cl_stopSCRIPTFODIDO', targetSrc)
	end
end)

------------------------------------------------------------
--  CARREGAR NO COLO
----------------------------------------------------------------
RegisterServerEvent('cmg2_animations:syncSCRIPTFODIDO3')
AddEventHandler('cmg2_animations:syncSCRIPTFODIDO3', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	vRP.antiflood(source,"cmg2_animations:syncSCRIPTFODIDO",8)
	local user_id = vRP.getUserId(source)
	if(target~=0 or targetSrc~=0)then
		banir(user_id)
		return
	end
	if vRPclient.isInVehicle(source) then
		TriggerClientEvent("Notify",source,"negado","Você não pode carregar de dentro do carro.")
		return
	end
	targetSrc = vRPclient.getNearestPlayer(source,3)

	animationLib		= "anim@heists@box_carry@"
	animationLib2		= "oddjobs@assassinate@vice@sex"
	animation 			= "idle"
	animation2			= "frontseat_carsex_base_f"
	distans 			= 0.40
	distans2 			= 0.05
	height 				= 0.15
	length 				= 100000
	spin 				= 95.0			
	controlFlagSrc 		= 49
	controlFlagTarget 	= 33
	animFlagTarget 		= 1
		
	if targetSrc ~= nil then
		TriggerClientEvent('cmg2_animations:syncTargetSCRIPTFODIDO', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
		TriggerClientEvent('cmg2_animations:syncMeSCRIPTFODIDO', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
	else 
		if vRP.getInventoryItemAmount(user_id,'corda') > 1 then
			TriggerClientEvent('cmg2_animations:syncTargetSCRIPTFODIDO', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
			TriggerClientEvent('cmg2_animations:syncMeSCRIPTFODIDO', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
		else
			TriggerClientEvent("Notify",source,"importante","Você não pode carregar uma pessoa viva.")	
		end
	end
end)

RegisterServerEvent('cmg2_animations:stopSCRIPTFODIDO3')
AddEventHandler('cmg2_animations:stopSCRIPTFODIDO3', function(targetSrc)
	vRP.antiflood(source,"cmg2_animations:stopSCRIPTFODIDO",8)
	local user_id = vRP.getUserId(source)
	if(targetSrc~=0)then
		banir(user_id)
		return
	end
	targetSrc = vRPclient.getNearestPlayer(source,3)
	if targetSrc ~= nil then
	TriggerClientEvent('cmg2_animations:cl_stopSCRIPTFODIDO', targetSrc)
	end
end)




------------------------------------------------------------
-- PEGAR DE REFEM
----------------------------------------------------------------

RegisterServerEvent('cmg3_animations:syncSCRIPTFODIDO')
AddEventHandler('cmg3_animations:syncSCRIPTFODIDO', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	vRP.antiflood(source,"cmg3_animations:syncSCRIPTFODIDO",8)
	local user_id = vRP.getUserId(source)
	if(target~=0 or targetSrc~=0)then
		banir(user_id)
		return
	end
	
	targetSrc = vRPclient.getNearestPlayer(source,3)
	
	animationLib = 'anim@gangops@hostage@'
	animation = 'perp_idle'
	animationLib2 = 'anim@gangops@hostage@'
	animation2 = 'victim_idle'
	distans = 0.11
	distans2 = -0.24 
	height = 0.0
	spin = 0.0		
	length = 100000
	controlFlagSrc = 49
	controlFlagTarget = 49
	animFlagTarget = 50
	attachFlag = true
	
	
	TriggerClientEvent('cmg3_animations:syncTargetSCRIPTFODIDO', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cmg3_animations:syncMeSCRIPTFODIDO', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('release_cmg3_animations:syncSCRIPTFODIDO')
AddEventHandler('release_cmg3_animations:syncSCRIPTFODIDO', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	vRP.antiflood(source,"cmg3_animations:syncSCRIPTFODIDO",8)
	local user_id = vRP.getUserId(source)
	if(target~=0 or targetSrc~=0)then
		banir(user_id)
		return
	end
	
	targetSrc = vRPclient.getNearestPlayer(source,3)
	
	animationLib = 'reaction@shove'
	animation = 'shove_var_a'
	animationLib2 = 'reaction@shove'
	animation2 = 'shoved_back'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 100000
	controlFlagSrc = 120
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	
	TriggerClientEvent('cmg3_animations:syncTargetSCRIPTFODIDO', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cmg3_animations:syncMeSCRIPTFODIDO', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('killHostage_cmg3_animations:syncSCRIPTFODIDO')
AddEventHandler('killHostage_cmg3_animations:syncSCRIPTFODIDO', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	vRP.antiflood(source,"cmg3_animations:syncSCRIPTFODIDO",8)
	local user_id = vRP.getUserId(source)
	if(target~=0 or targetSrc~=0)then
		banir(user_id)
		return
	end
	
	targetSrc = vRPclient.getNearestPlayer(source,3)
	
	animationLib = 'anim@gangops@hostage@'
	animation = 'perp_fail'
	animationLib2 = 'anim@gangops@hostage@'
	animation2 = 'victim_fail'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 0.2
	controlFlagSrc = 168
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	
	TriggerClientEvent('cmg3_animations:syncTargetSCRIPTFODIDO', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cmg3_animations:syncMeSCRIPTFODIDO', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg3_animations:stopSCRIPTFODIDO')
AddEventHandler('cmg3_animations:stopSCRIPTFODIDO', function(targetSrc)
	vRP.antiflood(source,"cmg3_animations:stopSCRIPTFODIDO",8)
	local user_id = vRP.getUserId(source)
	if(targetSrc~=0)then
		banir(user_id)
		return
	end
	targetSrc = vRPclient.getNearestPlayer(source,3)
	
	TriggerClientEvent('cmg3_animations:cl_stopSCRIPTFODIDO', targetSrc)
end)



------------------------------------------------------------
-- CAVALINHO
----------------------------------------------------------------
RegisterServerEvent('cmg2_animations:syncSCRIPTFODIDO_2')
AddEventHandler('cmg2_animations:syncSCRIPTFODIDO_2', function(target, animationLib, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)	
	vRP.antiflood(source,"cmg2_animations:syncSCRIPTFODIDO_2",8)
	local user_id = vRP.getUserId(source)
	if(target~=0 or targetSrc~=0)then
		banir(user_id)
		return
	end
	targetSrc = vRPclient.getNearestPlayer(source,3)
	
	animationLib = 'anim@arena@celeb@flat@paired@no_props@'
	animation = 'piggyback_c_player_a'
	animation2 = 'piggyback_c_player_b'
	distans = -0.07
	distans2 = 0.0
	height = 0.45
	spin = 0.0		
	length = 100000
	controlFlagSrc = 49
	controlFlagTarget = 33
	animFlagTarget = 1
	
	TriggerClientEvent('cmg2_animations:syncTargetSCRIPTFODIDO_2', targetSrc, source, animationLib, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncMeSCRIPTFODIDO_2', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stopSCRIPTFODIDO_2')
AddEventHandler('cmg2_animations:stopSCRIPTFODIDO_2', function(targetSrc)
	vRP.antiflood(source,"cmg3_animations:stopSCRIPTFODIDO",8)
	local user_id = vRP.getUserId(source)
	if(targetSrc~=0)then
		banir(user_id)
		return
	end
	targetSrc = vRPclient.getNearestPlayer(source,3)
	
	if targetSrc ~= nil then
	TriggerClientEvent('cmg2_animations:cl_stopSCRIPTFODIDO_2', targetSrc)
	end
end)

------------------------------------------------------------
-- TODDYNHO
----------------------------------------------------------------

RegisterCommand('webbandido', function(source)
	TriggerClientEvent( 'webbandido', source )
end)
