config = {}

config.recebeChamados = "policia.permissao"

config.permissaoComando = { -- Permissão para poder dar o /cacador em qualquer lugar
	'manager.permissao', 
	"admin.permissao",
	'comandante.permissao',
	'policial.permissao'
}
config.permissaoBlip = { -- Permissão para acessar o painel APENAS no blip
	'manager.permissao',
	'comandante.permissao'
}

config.permissaoPolicia = { -- Permissão para acessar o painel APENAS para policial
	'policial.permissao',
}

config.permissaoAlterar = { -- Permissão que pode adicionar mais pessoas ao painel, alterar o cargo dessa pessoa e adicionar a lista de procurado
	'manager.permissao',
	'comandante.permissao'
}

textoInBlipCacador = 'PRESSIONE  ~b~E~w~  PARA VERIFICAR OS PROCURADOS'
textoInBlip = '[~r~E~w~] PARA ~r~INICIAR~w~ A INVASÃO' -- Texto que aparece no BLIP de hack

textoprocurado = '⭐⭐⭐⭐⭐' -- Texto que vai aparecer na tela do jogador caso esteja procurado
textonprocurado = 'Você não está mas procurado, aproveite.' -- Texto para informar que o player não está mais procurado
textolocalizado = 'Um cidadão o reconheceu da lista de procurados, sua localizacao foi enviada pra policia.' -- Notify que aparece ao procurado, quando é denunciado a polícia
textolocalizado2 = 'Você falhou ao tentar hackear os sistemas, a polícia está a caminho, fuja' -- Notify que aparece ao procurado, quando é denunciado a polícia
textovcestaprocurado = 'Você está procurado pela polícia.'
config.tecla = 38 -- Botão que o player vai usar para fazer o hack

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
-------- [ Configurações básicas de funcionamento ] ------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
Avisar = true -- Coloque "false" se não quiser que o Procurado saiba todas as vezes que a polícia for notificada
nTaskbar = false -- Se você quiser sem taskbar (A baixo deixe false)
AvisarHack = true -- Coloque "false" se não quiser que o chame a polícia caso falhe na tentativa de hacker o sistema para tirar o procurado
useTaskbar = true -- Se você quer ou não usar a taskbar para hacker o sistema

config.item = 'pendrive' -- Item necessário para usar no BLIP procurado
config.amount = 1 -- Quantidade necessária desse item
----------------------------------------------------------------------------------------------------------------------------
-------- [ Onde os blips ficarão para entrar no computador ] ---------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.BlipAcesso = { -- Local onde terá acesso ao painel via BLIP
	{ ['coords'] = vector3(-126.0, -641.71, 168.85) }, 
}
----------------------------------------------------------------------------------------------------------------------------
-------- [ Onde os blips ficarão para hackear o sistema ] ------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.blipCoords = {
	{ ['coords'] = vector3(1275.83, -1710.52, 54.78) }, 
	{ ['coords'] = vector3(1272.34, -1711.6, 54.78) },
}

----------------------------------------------------------------------------------------------------------------------------
-------- [ CONFIGURAÇÃO DE ANIMAÇÃO DO ACESSO DA POLÍCIA ] -----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.startanim = function(source)
    vRP._playAnim(false, {{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop"}},true)
end
    
config.stopanim = function(source)
    vRP._stopAnim(false)
end
----------------------------------------------------------------------------------------------------------------------------
-------- [ CONFIGURAÇÃO DE ANIMAÇÃO DO SISTEMA DE HACKE ] ------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.startanim2 = function(source)
    vRPclient._playAnim(source, false, {{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop"}},true)
end
    
config.stopanim2 = function(source)
    vRPclient._stopAnim(source, false)
end
