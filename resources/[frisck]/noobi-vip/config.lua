-----------------------------------------------------------------------------------------------------------------------------------------
--Created By Noobi#1994----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

Config = {} -- Não Altere

Config.aviso = "Este script é gratuido, não compre e nem venda ele, vamos tentar mudar um pouco a comunidade e ser mais unidos e honestos" -- Não Altere

-----------------------------------------------------------------------------------------------------------------------------------------
--WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------

Config.comwebhook = true --Caso não queira webhook, colocar false
Config.webhook = "https://discord.com/api/webhooks/1053085359975698552/s3zqQc9FOLvyW5NfuYtnSAAn98CtiLd221pmV0vCN1xoY2gMj_WzZenZcUk6bQsjhrkb" -- Webhook Discord para enviar log de VIP`s enviados.

-----------------------------------------------------------------------------------------------------------------------------------------
--SETUP
-----------------------------------------------------------------------------------------------------------------------------------------
Config.permissaoadmin = "ceo.permissao" --Nome da permissão admin para usar o comando de teste
Config.carroinicial = false --Habilita doação de carro para iniciantes (Para desligar, colocar false)
Config.carrosiniciais = {"kuruma","akuma",} --(Quantidade ilimitada)
Config.nomedovip = "VipOuro" --Nome do group do seu plano VIP
Config.permissaodovip = "ouro.permissao" --Nome da permissão do seu plano VIP
Config.tempodovip = 10 --Colocar números inteiros em dias
Config.removervip = true --Utilizar nosso sistema para remover o VIP inicial após expirar. Útil para frameworks que não possuem nativamente essa função
Config.iteminicial = true--Habilita doação de itens para iniciantes (Para desligar, colocar false)
Config.itensiniciais = { --sempre colocar o nome do item cadastrado em sua base e depois "=" e a quantidade na frente.(Quantidade ilimitada)
    mochila = 3,
    celular = 1,
    roupa = 1,
    radio = 1,
}
Config.dinheiroadicional = true --Habilita doação de dinheiro adicional para iniciantes (Para desligar, colocar false)
Config.dinheiroadicionalqtd = 50000 --Colocar números inteiros
Config.direitoacasa = false --Habilita doação de casa para iniciantes (Para desligar, colocar false) SÓ FUNCIONA CASO SEU SCRIPT CEDA A CASA ATRAVÉS DE UM CARGO TEMPORÁRIO.
Config.casabeneficio = "direitohome10kk" --Nome do cargo que da direito a casa.
Config.mostrarNUI = true --Habilita para player receber mensagem do VIP inicial (Para desligar, colocar false)
Config.delayNUI = 1500 --Colocar números inteiros e em milissegundos, esse tempo define quanto tempo aNUI vai demorar para aparecer para o player.


-----------------------------------------------------------------------------------------------------------------------------------------
--COMANDO
-----------------------------------------------------------------------------------------------------------------------------------------

--Para adicionar um VIP temporario manualmente, basta digitar /viptemp <id> SE A PESSOA JÁ TEVE UM VIP TEMP NA SUA CIDADE, O COMANDO NÃO FUNCIONARÁ
