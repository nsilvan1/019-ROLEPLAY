-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY CSS,MENSAGEM,TEMPO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Notify")
AddEventHandler("Notify",function(css,message,delay)
	if not delay then delay = 9000 end
	SendNUIMessage({ css = css,  message = message, delay = delay })
end)

RegisterCommand("teste",function(source,args)
	TriggerEvent('Notify', 'sucesso', "Seu Carro foi <b>Destrancado</b>")
	TriggerEvent('Notify', 'negado',"Seu Carro foi <b>Destrancado</b>")
	TriggerEvent('Notify', 'importante',"Seu Carro foi <b>Destrancado</b>")	
	TriggerEvent('Notify', 'aviso', "Seu Carro foi <b>Destrancado</b>")	
end)