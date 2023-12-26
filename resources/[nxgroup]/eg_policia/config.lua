config = {}

config.token = "f9ca4de24953d4bfbb6b2d06d4152cd7"

config.webhookZerarTabelas = "https://discord.com/api/webhooks/1058404921042546768/sENE_LADZPgGKgWsCnU67tFtLnpfpb_rfT-xhKTf6eVsdKQwJTZG8zRVo81g8wADgQEA"

config.vrp_user_identities = true --CONFIG PRA CHECAR SE A BASE USA A TABELA VRP_USER_IDENTITIES

config.nomePolicia = "019RP police"
config.imgPolicia = "https://cdn.discordapp.com/attachments/852246277667160104/1161113218698182776/Logo_019.png?ex=65371df3&is=6524a8f3&hm=753c9ca157da66359b40f6257d44aadf1b7de0cfe901f2dfd04021581b576dd6&"

config.permComando = "policia.permissao"
config.permPolicia = "policia.permissao"
config.permPoliciaSalario= "policia.permissao"
config.tempoPagamento = 35 -- TEMPO EM MINUTOS

config.armamentoNaDP = true -- TRUE SO VAI PEGAR ARMAS NA DP / FALSE PEGA DE QUALQUER LUGAR
config.arsenal = {{-1103.5,-824.41,14.29},{2505.37,-346.24,93.87},{452.4,-980.5,30.69},{-1082.45,-819.72,13.57}} --PODE POR TODAS AS CDS DE ARSENAIS QUE VAI PODER TIRAR ARMAS
config.distanciaArmamento = 10 -- DISTANCIA EM METROS DA POSICAO X Y Z ACIMA

--CONFIGURAÇÃO ADQUIRIDA A CADA AÇÃO 
config.pontuacao = { prender = 3, empateAcao = 4, vitoriaAcao = 5, derrotaAcao = 3, batePonto = 0 }

config.localPrisao = { x = 1680.1, y = 2513.0, z = 45.5, raio = 150, xSaida = 1850.5, ySaida = 2604.0, zSaida = 45.5 }
config.trabalhosPrisao = true -- FUNÇÃO QUE HABILITA TRABALHOS NA PRISÃO
config.trabalhoCaixa = true -- HABILITA O TRABALHO DE CARREGADOR DE CAIXA SE ESTIVER PRESO
config.trabalhoPegarCaixa = {1669.53,2487.75,45.83}
config.trabalhoEntregarCaixa = {1691.3,2565.86,45.57}
config.tempoMinimoPena = 10 -- TEMPO MINIMO QUE PODE TRABALHAR NA PRISÃO
config.reducaoPorCaixa = 2  -- TEMPO EM MESES QUE CADA CAIXA ENTREGA VAI DIMINUIR NA PRISAO

config.drawMarker = function(x,y,z) -- FUNÇÃO PARA STARTAR OS TRABALHOS NA PRISÃO
	DrawMarker(27,x,y,z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,201, 0, 0,155,0,0,0,1)
	DrawMarker(42,x,y,z-0.4,0,0,0,0,0,0,1.0,1.0,1.0,201, 0, 0,155,0,0,0,1)
end

config.codigoPenal = {
    { art="Art. 31", crime="Assédio Moral e Fisico", servicos=10, multa=10000, fianca=40000, obs="Necessita Prova" },
    { art="Art. 32", crime="Danos a Terceiro/Patrimônio", servicos=20, multa=10000, fianca=25000, obs="" },
    { art="Art. 33", crime="Uso de mascara", servicos=0, multa=50000, fianca=0, obs="" },
    { art="Art. 34", crime="Uso de equipamento da policia", servicos=0, multa=10000, fianca=0, obs="" },
    { art="Art. 35", crime="Apologia ao crime", servicos=15, multa=5000, fianca=0, obs="Sem fiança" },
    { art="Art. 36", crime="Falso testemunho", servicos=15, multa=10000, fianca=0, obs="" },
    { art="Art. 37", crime="Resistencia a prisão", servicos=15, multa=6000, fianca=0, obs="Sem Fiança" },
    { art="Art. 38", crime="Omissão de socorro", servicos=5, multa=10000, fianca=50000, obs="Necessita Prova" },
    { art="Art. 39", crime="Dano ao patrimonio", servicos=5, multa=6000, fianca=5000, obs="Valor por unidade" },
    { art="Art. 40", crime="Difamação", servicos=0, multa=10000, fianca=0, obs="" },
    { art="Art. 41", crime="Furto", servicos=10, multa=5000, fianca=15000, obs="" },
    { art="Art. 42", crime="Obstrução de Justiça", servicos=30, multa=10000, fianca=50000, obs="" },
    { art="Art. 43", crime="Agressão corporal culposa", servicos=20, multa=5000, fianca=15000, obs="Sem intenção de matar" },
    { art="Art. 44", crime="Agressão corporal dolosa", servicos=40, multa=10000, fianca=0, obs="C/ INT. De Matar - Sem fiança" },
    { art="Art. 45", crime="Injuria", servicos=30, multa=15000, fianca=20000, obs="" },
    { art="Art. 46", crime="Ameaça", servicos=35, multa=15000, fianca=0, obs="Sem fiança - Necessita prova" },
    { art="Art. 47", crime="Incitação ao crime", servicos=20, multa=10000, fianca=20000, obs="" },
    { art="Art. 48", crime="Fuga", servicos=10, multa=5000, fianca=10000, obs="" },
    { art="Art. 49", crime="Roubo a caixa bancário", servicos=20, multa=30000, fianca=10000, obs="" },
    { art="Art. 50", crime="Desobediência", servicos=15, multa=8000, fianca=32000, obs="" },
    { art="Art. 51", crime="Extorção", servicos=15, multa=0, fianca=0, obs="Sem fiança" },
    { art="Art. 52", crime="Falsidade ideologica", servicos=10, multa=0, fianca=0, obs="Sem fiança" },
    { art="Art. 53", crime="Calúnia", servicos=10, multa=0, fianca=20000, obs="Necessita prova" },
    { art="Art. 54", crime="Suborno", servicos=10, multa=0, fianca=0, obs="Necessita prova - Sem fiança" },
    { art="Art. 55", crime="Atentado ao pudor", servicos=30, multa=10000, fianca=0, obs="Sem fiança" },
    { art="Art. 56", crime="Poluição Sonora", servicos=0, multa=10000, fianca=0, obs="" },
    { art="Art. 57", crime="Roubo/Furto de carro oficial da cidade", servicos=30, multa=10000, fianca=0, obs="Sem fiança" },
    { art="Art. 58", crime="Roubo/Furto de veículos", servicos=20, multa=6000, fianca=0, obs="Sem fiança" },
    { art="Art. 59", crime="Abuso de autoridade", servicos=30, multa=15000, fianca=10000, obs="" },
    { art="Art. 60", crime="Homicídio Doloso", servicos=85, multa=10000, fianca=0, obs="Sem fiança" },
    { art="Art. 61", crime="Homicídio Culposo", servicos=50, multa=5000, fianca=0, obs="Sem fiança" },
    { art="Art. 62", crime="Tentativa de Homicídio", servicos=45, multa=5000, fianca=0, obs="Sem fiança" },
    { art="Art. 63", crime="Latrocínio", servicos=110, multa=30000, fianca=0, obs="Sem fiança" },
    { art="Art. 64", crime="Sequestro", servicos=25, multa=10000, fianca=0, obs="Valor por refém - Sem fiança" },
    { art="Art. 67", crime="Associação ao tráfico/contrabando", servicos=10, multa=2000, fianca=3000, obs="" },
    { art="Art. 68", crime="Maconha/LSD", servicos=5, multa=2000, fianca=3000, obs="Valor a cada 3 unidades" },
    { art="Art. 68.1", crime="Cocaína", servicos=5, multa=2000, fianca=3000, obs="Valor a cada 3 unidades" },
    { art="Art. 68.2", crime="Metanfetamina", servicos=5, multa=2000, fianca=3000, obs="Valor a cada 3 unidade" },
    { art="Art. 69", crime="Dinheiro Sujo", servicos=3, multa=1000, fianca=2000, obs="Valor a cada 10.000" },
    { art="Art. 70", crime="Lockpick/Peça de arma", servicos=15, multa=2000, fianca=3000, obs="Valor por unidade" },
    { art="Art. 71", crime="Portar algema/capuz", servicos=15, multa=3000, fianca=5000, obs="Valor por unidade" },
    { art="Art. 71.1", crime="Tráfico de material balistico", servicos=15, multa=1000, fianca=5000, obs="Valor por unidade" },
    { art="Art. 72", crime="Porte de armade baixo calibre s/porte", servicos=25, multa=10000, fianca=20000, obs="Valor de multa/fiança a cada 10 balas" },
    { art="Art. 73", crime="Porte de armade alto calibre s/porte", servicos=40, multa=10000, fianca=0, obs="Valor de multa a cada 10 balas - Sem fiança" },
    { art="Art. 74", crime="Mal uso de arma de fogo c/porte", servicos=30, multa=15000, fianca=15000, obs="Porte caçado" },
    { art="Art. 45 I", crime="Dirigir sem atenção", servicos=0, multa=3000, fianca=0, obs="" },
    { art="Art. 45 II", crime="Estacionar em acostamento", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 45 III", crime="Luz alta em vias iluminadas", servicos=0, multa=3000, fianca=0, obs="" },
    { art="Art. 45 IV", crime="Usar buzina prolongada", servicos=0, multa=3000, fianca=0, obs="" }, 
    { art="Art. 46 I", crime="Atirar objetos do veiculo", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 46 II", crime="Ficar sem combustivel em via publíca", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 46 III", crime="Transitar ao lado de outro veiculo", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 46 IV", crime="Transitar em velocidade inferior a metade da máxima", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 46 V", crime="Usar alarme ou aparelho que produz som perturbante", servicos=0, multa=10000, fianca=0, obs="" },
    { art="Art. 46 VI", crime="Estacionar em local proibido", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 46 VII", crime="Exceder limite de velocidade  em até 30%", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 46 VIII", crime="Ultrapassar o sinal vermelho", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 47 I", crime="Deixar de usar cinto", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 47 II", crime="Deixar de prestar socorro a vitima de acidente", servicos=0, multa=7000, fianca=0, obs="" },
    { art="Art. 47 III", crime="Fazer ou deixar que se faça reparos em vias rapidas", servicos=0, multa=6000, fianca=0, obs="" },
    { art="Art. 47 IV", crime="Transitar na contra mão", servicos=0, multa=10000, fianca=0, obs="" },
    { art="Art. 47 V", crime="Transitar em marcha ré", servicos=0, multa=80000, fianca=0, obs="" },
    { art="Art. 47 VI", crime="Desobedecer ordens emanadas da autoridade competente", servicos=0, multa=8000, fianca=0, obs="" },
    { art="Art. 47 VII", crime="Deixar de reduzir a velocidade onde o trânsito esteja controlado", servicos=0, multa=6000, fianca=0, obs="" },
    { art="Art. 47 VIII", crime="Conduzir o veículo em mal estado de conservação", servicos=0, multa=10000, fianca=0, obs="" },
    { art="Art. 47 IX", crime="Evardir-se para não pagar pedágio", servicos=0, multa=6000, fianca=0, obs="" },
    { art="Art. 47 X", crime="Deixar de usar  capacete", servicos=0, multa=5000, fianca=0, obs="" },
    { art="Art. 47 XI", crime="Exceder o limite de velocidade em até 70% da velocidade permitida", servicos=0, multa=10000, fianca=0, obs="" },
    { art="Art. 48 I", crime="Transitar pela contramão em via de sentido único", servicos=0, multa=10000, fianca=0, obs="" },
    { art="Art. 48 II", crime="Deixar de dar passagem a veículo de socorro", servicos=0, multa=10000, fianca=0, obs="" },
    { art="Art. 48 III", crime="Exceder o limite de velocidade  acima de 70% da velocidade permitida", servicos=0, multa=15000, fianca=0, obs="" },
    { art="Art. 86", crime="Praticar homicio culposo", servicos=30, multa=0, fianca=0, obs="" },
    { art="Art. 86 I", crime="Praticar homicio culposo na faixa de pedestres", servicos=40, multa=0, fianca=0, obs="" },
    { art="Art. 86 II", crime="Praticar homicio culposo e não prestar socorro", servicos=50, multa=0, fianca=0, obs="" },
    { art="Art.  86 III", crime="Praticar homicio culposo no exercício de função ou atividade", servicos=60, multa=0, fianca=0, obs="" },
    { art="Art. 87", crime="Praticar lesão corporal culposa", servicos=30, multa=0, fianca=0, obs="" },
    { art="Art. 87 I", crime="Conduzir com capacidade psicomotora alterada", servicos=50, multa=0, fianca=0, obs="" },
    { art="Art. 87 II", crime="Crime acima e o condutor alegar dependencia", servicos=40, multa=0, fianca=0, obs="" },
    { art="Art. 88", crime="Deixar de prestar socorro imediato a vítima em caso de acidente", servicos=40, multa=0, fianca=0, obs="" },
    { art="Art. 89", crime="Afastar-se o condutor do veículo no acidente para não ser responsabilizado", servicos=30, multa=15000, fianca=0, obs="" },
    { art="Art. 90", crime="Expor outros a danos por estar sob influência de álcool", servicos=40, multa=20000, fianca=0, obs="" },
    { art="Art. 91", crime="Corrida ilegal", servicos=30, multa=30000, fianca=0, obs="" },
    { art="Art. 91 I", crime="Crime acima e resultar em lesão corporal de outra pessoa", servicos=40, multa=30000, fianca=0, obs="" },
    { art="Art. 91 II", crime="Crime acima e resultar em morte de outra pessoa", servicos=50, multa=30000, fianca=0, obs="" },
    { art="Art. 92", crime="Trafegar em velocidade incompativel perto de hospitais, praça, dp, etc...", servicos=20, multa=10000, fianca=0, obs="" },
    { art="Art. 93", crime="Modificar o local do acidente para induzir aoerro a autoridade policial", servicos=40, multa=10000, fianca=0, obs="" },
}

config.armasArsenal = {
    -- { arma="Bandagem", spawn="item", municao=1, preco=10000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://mushinfinity.com.br/img/inventario/bandagem.png" },
    -- { arma="Radio", spawn="item", municao=1, preco=5000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://mushinfinity.com.br/img/inventario/radio.png" },
    -- { arma="Mochila", spawn="item", municao=1, preco=10000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://mushinfinity.com.br/img/inventario/mochila.png" },
    -- { arma="Energetico", spawn="item", municao=1, preco=7000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://mushinfinity.com.br/img/inventario/energetico.png" },
    -- { arma="Lanterna", spawn="WEAPON_FLASHLIGHT", municao=0, preco=500, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://mushinfinity.com.br/img/inventario/lanterna.png" },
    -- { arma="Cacetete", spawn="WEAPON_NIGHTSTICK", municao=0, preco=500, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://mushinfinity.com.br/img/inventario/cassetete.png" },
    -- { arma="Taser", spawn="WEAPON_STUNGUN", municao=0, preco=500, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://mushinfinity.com.br/img/inventario/taser.png" },
    -- { arma="Glock", spawn="WEAPON_COMBATPISTOL", municao=100, preco=1000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://mushinfinity.com.br/img/inventario/wbody-WEAPON_COMBATPISTOL.png" },
    -- { arma="Sig Sauer", spawn="WEAPON_COMBATPDW", municao=200, preco=2000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13]", img="https://mushinfinity.com.br/img/inventario/wbody-WEAPON_COMBATPDW.png" },
    -- { arma="MP5", spawn="WEAPON_ASSAULTSMG", municao=200, preco=3000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12]", img="https://mushinfinity.com.br/img/inventario/wbody-WEAPON_SMG.png" },
    -- { arma="Shotgun", spawn="WEAPON_PUMPSHOTGUN", municao=60, preco=5000, patentes="[1,2,3,4,5,6,7,8,9,10]", img="https://mushinfinity.com.br/img/inventario/wbody-WEAPON_PUMPSHOTGUN.png" },
    -- { arma="Five Seven", spawn="WEAPON_PISTOL_MK2", municao=100, preco=5000, patentes="[1,2,3,4,5,6,7,8,9,10]", img="https://mushinfinity.com.br/img/inventario/fiveseven.png" },
    -- { arma="M4A4", spawn="WEAPON_CARBINERIFLE", municao=200, preco=5000, patentes="[1,2,3,4,5,6,7,8,9,10]", img="https://mushinfinity.com.br/img/inventario/m4a4.png" },
    -- { arma="M4A4 MK2", spawn="WEAPON_CARBINERIFLE_MK2", municao=200, preco=8000, patentes="[1,2,3,4,5,6,7,8,9,10]", img="https://mushinfinity.com.br/img/inventario/m4a4mk2.png" },

    { arma="Bandagem", spawn="item", municao=1, preco=2500, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://i.imgur.com/MWR8YJb.png" },
   { arma="Radio", spawn="item", municao=1, preco=5000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://i.imgur.com/dYpXVPk.png" },
   { arma="Mochila", spawn="item", municao=1, preco=10000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://i.imgur.com/PwmnpUN.png" },
   { arma="Energetico", spawn="item", municao=1, preco=3000, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://i.imgur.com/IFkI8LD.png" },
   { arma="Lanterna", spawn="WEAPON_FLASHLIGHT", municao=0, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://i.imgur.com/viRBtIV.png" },
   { arma="Cacetete", spawn="WEAPON_NIGHTSTICK", municao=0, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://i.imgur.com/4eEztMx.png" },
   { arma="Taser", spawn="WEAPON_STUNGUN", municao=0, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://i.imgur.com/38UmHk5.png" },
   { arma="Glock", spawn="WEAPON_COMBATPISTOL", municao=100, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13,14]", img="https://i.imgur.com/S6HAGtA.png" },
--    { arma="Sig Sauer", spawn="WEAPON_COMBATPDW", municao=200, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10,11,12,13]", img="https://i.imgur.com/ufxshNl.png" },
--    { arma="MP5", spawn="WEAPON_ASSAULTSMG", municao=200, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10,11,12]", img="https://i.imgur.com/GuUENqj.png" },
--    { arma="Shotgun", spawn="WEAPON_PUMPSHOTGUN", municao=60, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10]", img="https://mushinfinity.com.br/img/inventario/wbody-WEAPON_PUMPSHOTGUN.png" },
-- --    { arma="Five Seven", spawn="WEAPON_PISTOL_MK2", municao=100, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10]", img="https://i.imgur.com/OOQYPZP.png" },
--    { arma="M4A4", spawn="WEAPON_CARBINERIFLE", municao=200, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10]", img="https://i.imgur.com/bLrkEiY.png" },
--    { arma="M4A4 MK2", spawn="WEAPON_CARBINERIFLE_MK2", municao=200, preco=0, patentes="[1,2,3,4,5,6,7,8,9,10]", img="https://i.imgur.com/bLrkEiY.png" },
}


config.patentes = {
    -- {value = 1,  patente = "Comandante", label ="Comandante", salario=8000},
    -- {value = 2,  patente = "Sub. Comandante", label ="Sub. Comandante", salario=7900},
    -- {value = 3,  patente = "Coronel", label ="Coronel", salario=7800},
    -- {value = 4,  patente = "T. Coronel", label ="T. Coronel", salario=7700},
    -- {value = 5,  patente = "Major",      label ="Major", salario=7600},
    -- {value = 6,  patente = "Capitão",    label ="Capitão", salario=7500},
    -- {value = 7,  patente = "1. Tenente",  label ="1. Tenente", salario=7400},
    -- {value = 8,  patente = "2. Tenente",  label ="2. Tenente", salario=7300},
    -- {value = 9,  patente = "Asp. Oficial",  label ="Asp. Oficial", salario=7200},
    -- {value = 10,  patente = "Sub. Tenente",label ="Sub. Tenente", salario=7100},
    -- {value = 11,  patente = "1. Sargento", label ="1. Sargento", salario=7000},
    -- {value = 12,  patente = "2. Sargento",label ="2. Sargento", salario=6900},
    -- {value = 13, patente = "3. Sargento", label ="3. Sargento", salario=6800},
    -- {value = 14, patente = "Cabo",       label ="Cabo", salario=6700},
    -- {value = 15, patente = "Soldado",    label ="Soldado", salario=6600},
    -- {value = 16, patente = "Recruta",    label ="Recruta", salario=6500},

    {value = 1,  patente = "Comandante", label ="Comandante", salario=8000},
    {value = 2,  patente = "Sub. Comandante", label ="Sub. Comandante", salario=7900},
    {value = 3,  patente = "Coronel", label ="Coronel", salario=7800},
    {value = 4,  patente = "T. Coronel", label ="T. Coronel", salario=7700},
    {value = 5,  patente = "Major",      label ="Major", salario=7600},
    {value = 6,  patente = "Capitão",    label ="Capitão", salario=7500},
    {value = 7,  patente = "1. Tenente",  label ="1. Tenente", salario=7400},
    {value = 8,  patente = "2. Tenente",  label ="2. Tenente", salario=7300},
    {value = 9,  patente = "Asp. Oficial",  label ="Asp. Oficial", salario=7200},
    {value = 10,  patente = "Sub. Tenente",label ="Sub. Tenente", salario=7100},
    {value = 11,  patente = "1. Sargento", label ="1. Sargento", salario=7000},
    {value = 12,  patente = "2. Sargento",label ="2. Sargento", salario=6900},
    {value = 13, patente = "3. Sargento", label ="3. Sargento", salario=6800},
    {value = 14, patente = "Cabo",       label ="Cabo", salario=6700},
    {value = 15, patente = "Soldado",    label ="Soldado", salario=6600},
    {value = 16, patente = "Recruta",    label ="Recruta", salario=5000},
}
config.unidades = {
    -- {value = 1, unidade = "C.O.D",      label="C.O.D"},
    -- {value = 2, unidade = "C.I.A",      label="C.I.A"},
    -- {value = 3, unidade = "TATICA",     label="TATICA"},
    -- {value = 4, unidade = "SPEED",      label="SPEED"},
    -- {value = 5, unidade = "-",          label="-"},
    -- {value = 6, unidade = "GAT",        label="GAT"},
}

config.viaturas = {
    {value = 1, patente= "ALUNOS E PRAÇAS", vtr = "amg45"},
    {value = 2, patente= "GRADUADOS", vtr = "amg45 / VRrs6av"},
    {value = 3, patente= "OFICIAIS", vtr = "amg45 / VRrs6av"},
    {value = 4, patente= "ALTO COMANDO", vtr = "cls63sp"},
    {value = 5, patente= "G.T.M", vtr = ""},
    {value = 6, patente= "TÁTICA", vtr = ""},
    {value = 7, patente= "G.R.A.E.R", vtr = ""},
    {value = 8, patente= "SPEED", vtr = "maseratinfp"},
    {value = 9, patente= "D.I.C", vtr = ""},
}

config.fardamentosMasculino = {
    {value = 1, patente= "Aluno", roupa = ""},
    {value = 2, patente= "Soldado", roupa = ""},
    {value = 3, patente= "Cabo", roupa = ""},
    {value = 4, patente= "3° Sargento", roupa = ""},
    {value = 5, patente= "2° Sargento", roupa = ""},
    {value = 6, patente= "1° Sargento", roupa = ""},
    {value = 7, patente= "SUB TENENTE", roupa = ""},
    {value = 8, patente= "2º TENENTE", roupa = ""},
    {value = 9, patente= "1º TENENTE", roupa = ""},
    {value = 10, patente= "CAPITÃO", roupa = ""},
    {value = 11, patente= "MAJOR", roupa = ""},
    {value = 12, patente= "ALTO COMANDO", roupa = ""},
    {value = 13, patente= "ALTO COMANDO", roupa = ""},
    {value = 14, patente= "ALTO COMANDO", roupa = ""},
    {value = 15, patente= "TÁTICA", roupa = ""},
    {value = 16, patente= "G.T.M", roupa = ""},
    {value = 17, patente= "SPEED", roupa = ""},
    {value = 18, patente= "G.R.A.E.R", roupa = ""},
}

config.fardamentosFeminino = {
    {value = 1, patente= "Aluno", roupa = ""},
    {value = 2, patente= "Soldado", roupa = ""},
    {value = 3, patente= "Cabo", roupa = ""},
    {value = 4, patente= "3° Sargento", roupa = ""},
    {value = 5, patente= "2° Sargento", roupa = ""},
    {value = 6, patente= "1° Sargento", roupa = ""},
    {value = 7, patente= "SUB TENENTE", roupa = ""},
    {value = 8, patente= "2º TENENTE", roupa = ""},
    {value = 9, patente= "1º TENENTE", roupa = ""},
    {value = 10, patente= "CAPITÃO", roupa = ""},
    {value = 11, patente= "MAJOR", roupa = ""},
    {value = 12, patente= "ALTO COMANDO", roupa = ""},
    {value = 13, patente= "ALTO COMANDO", roupa = ""},
    {value = 14, patente= "ALTO COMANDO", roupa = ""},
    {value = 15, patente= "TÁTICA", roupa = ""},
    {value = 16, patente= "G.T.M", roupa = ""},
    {value = 17, patente= "SPEED", roupa = ""},
    {value = 18, patente= "G.R.A.E.R", roupa = ""},
}

return config