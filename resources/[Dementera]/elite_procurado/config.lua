config = {}

----------------------------------------------------------------------------------------------------------------------------
-------- [ Configurações dos textos ] --------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
textoInBlip = '[~r~E~w~] PARA ~r~INICIAR~w~ A INVASÃO' -- Texto que aparece no BLIP de hack

textoprocurado = '⭐⭐⭐⭐⭐' -- Texto que vai aparecer na tela do jogador caso esteja procurado
textonprocurado = 'Você não está mas procurado, aproveite.' -- Texto para informar que o player não está mais procurado
textolocalizado = 'Um cidadão o reconheceu da lista de procurados, sua localizacao foi enviada pra policia.' -- Notify que aparece ao procurado, quando é denunciado a polícia
textolocalizado2 = 'Você falhou ao tentar hackear os sistemas, a polícia está a caminho, fuja' -- Notify que aparece ao procurado, quando é denunciado a polícia
textovcestaprocurado = 'Você está procurado pela polícia.'
config.tecla = 38 -- Botão que o player vai usar para fazer o hack
----------------------------------------------------------------------------------------------------------------------------
-------- [ Configurações básicas de funcionamento ] ------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
Avisar = true -- Coloque "false" se não quiser que o Procurado saiba todas as vezes que a polícia for notificada
nTaskbar = false -- Se você quiser sem taskbar (A baixo deixe false)
AvisarHack = true -- Coloque "false" se não quiser que o chame a polícia caso falhe na tentativa de hacker o sistema para tirar o procurado
useTaskbar = true -- Se você quer ou não usar a taskbar para hacker o sistema

config.item = 'pendrive' -- Item necessário para usar no BLIP procurado
config.amount = 1 -- Quantidade necessária desse item

----------------------------------------------------------------------------------------------------------------------------
-------- [ Onde os blips ficarão para hackear o sistema ] ------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.blipCoords = {
	{ ['coords'] = vector3(1275.83, -1710.52, 54.78) }, 
	-- { ['coords'] = vector3(1272.34, -1711.6, 54.78) },
}

----------------------------------------------------------------------------------------------------------------------------
-------- [ Notify entregue a polícia ] -------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.titulo = 'Procurado Avistado' -- Título da Notify
config.codigo = 'Procurado' -- Código na Notify
config.textonotify = 'Uma Pessoa procurada, foi avistada, corra até o local' -- Texto maior que aparece em baixo na Notify

config.titulo2 = 'Tentativa de Hack' -- Título da Notify
config.codigo2 = 'Invasão de sistema' -- Código na Notify
config.textonotify2 = 'Uma Pessoa procurada, tentou invadir nossos sistemas' -- Texto maior que aparece em baixo na Notify

----------------------------------------------------------------------------------------------------------------------------
-------- [ Permissões para executar devidas ações ] ------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.addprocurado = 'policia.permissao' -- Permissão para adicionar o player como procurado
config.remprocurado = 'policia.permissao' -- Permissão para tirar o player de procurado
config.checkprocurado = 'policia.permissao' -- Permissão para verificar se o player está ou não procurar
config.policiapermissao = 'policia.permissao' -- Permissão que vai receber os chamados quando um procurado for avistado

----------------------------------------------------------------------------------------------------------------------------
-------- [ LOGS DO SCRIPT ] ------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.hackerfail = "SEU WEBHOOK" -- Log caso o player NÃO consiga hacker o sistema da polícia
config.hackersucess = "SEU WEBHOOK" -- Log caso o player consiga hacker o sistema da polícia
config.logaddprocurado = "SEU WEBHOOK" -- Log para quando alguém adicionar um procurado
config.logremprocurado = "SEU WEBHOOK" -- Log para quando alguém remover um procurado
config.logconsultaprocurado = "SEU WEBHOOK" -- Log para quando alguém verificar listagem de procurados
----------------------------------------------------------------------------------------------------------------------------
-------- [ CONFIGURAÇÃO DE ANIMAÇÃO ] --------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.startanim = function(source)
    vRPclient._playAnim(source, false, {{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop"}},true)
end
    
config.stopanim = function(source)
    vRPclient._stopAnim(source, false)
end

----------------------------------------------------------------------------------------------------------------------------
-------- [ CONFIGURAÇÃO DO SCRIPT ] ----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- Evento para usar o item para remover de procurado

    -- TriggerEvent('item_r_ProcuradoSimples',source) -- Para retirar apenas usando o TimeOut sem taskbar
    -- TriggerEvent('item_r_Procurado',source) -- Para retirar o procurado com Taskbar (Minigame)

-- Evento para verificar se está procurado

    -- TriggerEvent('Procurado:ChecarProcurados') -- No client-side do script que quiser que faça a verificação
    -- TriggerClientEvent('Procurado:ChecarProcurados',user_id) -- No server-side do script que quiser que faça a verificação

-- Evento para adicionar procurado
    -- TriggerClientEvent('Procurado:IniciouProcura',user_id,true) -- No server-side do script que quiser que adicione como procurado (Geralmente em roubos)
    -- TriggerEvent('Procurado:IniciouProcura',true) -- No client-side do script que quiser que adicione como procurado (Geralmente em roubos)

-- Evento para remover procurado
    -- TriggerEvent('Procurado:rProcurado',source,true)  -- No server-side do script que quiser que retire o procurado

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
    -- [ Caso queira usar em algo mais específico, aqui tem um modelo simples (Sem necessidade já que existe os eventos a cima) ] 

--     local value = vRP.getUData(parseInt(user_id),"vRP:Procurado")
--     local tempo = json.decode(value) or 0
--     if tempo == 0 then
--         -- Se receber 0 Não está procurado
--         return
--     end
    
--     if tempo > 0 then
--         -- Se receber maior que 0 está procurado
--     end
-- ----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------