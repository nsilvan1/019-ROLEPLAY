local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
local cFG = module("eg_policia", "config")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

eG = {}
Tunnel.bindInterface("eg_policia",eG)
-------------------------------------------------------------------
-- WEBHOOK ------------------------------------------------------
-------------------------------------------------------------------
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
--------------------------------------------------------------------------
-- SQL -------------------------------------------------------------------
--------------------------------------------------------------------------
vRP.prepare ("EG/getIdentidade", "SELECT * FROM vrp_user_identities WHERE user_id = @user_id")
vRP.prepare ("EG/getIdentidade2", "SELECT * FROM vrp_users WHERE id = @user_id")
vRP.prepare ("EG/getAllFuncionarios", "SELECT * FROM eg_policia_funcionarios")
vRP.prepare ("EG/getFuncionarios", "SELECT * FROM eg_policia_funcionarios WHERE exonerado = 0")
vRP.prepare ("EG/getNaCorporacao", "SELECT * FROM eg_policia_funcionarios WHERE user_id = @id AND exonerado = 0")
vRP.prepare ("EG/getSomaPontos", "SELECT SUM(pontos) FROM eg_policia_pontos WHERE user_id = @user_id AND contabilizado = 0")
vRP.prepare ("EG/getPontos", "SELECT * FROM eg_policia_pontos WHERE user_id = @user_id AND TIMESTAMP >= CURRENT_DATE()-7 AND contabilizado = 0")
vRP.prepare ("EG/setPontos", "UPDATE eg_policia_funcionarios SET pontuacao = @pontuacao WHERE user_id = @user_id")

vRP.prepare ("EG/cadastrarFuncionario", "INSERT INTO eg_policia_funcionarios(user_id,value,nome,label) VALUES(@user_id,@user_id,@nome,@nome)")
vRP.prepare ("EG/editarFuncionario", "UPDATE eg_policia_funcionarios SET exonerado = 0 WHERE user_id = @user_id")
vRP.prepare ("EG/editarName", "UPDATE eg_policia_funcionarios SET label = @name, nome = @name WHERE user_id = @user_id")
vRP.prepare ("EG/editarPatente", "UPDATE eg_policia_funcionarios SET patente = @patente WHERE user_id = @user_id")
vRP.prepare ("EG/editarUnidade", "UPDATE eg_policia_funcionarios SET unidade = @unidade WHERE user_id = @user_id")
vRP.prepare ("EG/editarAdv", "UPDATE eg_policia_funcionarios SET advertencia = @adv WHERE user_id = @user_id")
vRP.prepare ("EG/editarPontuacao", "UPDATE eg_policia_funcionarios SET pontuacao = @pontuacao WHERE user_id = @user_id")
vRP.prepare ("EG/exonerarFuncionario", "UPDATE eg_policia_funcionarios SET exonerado = 1, motivo = @descricao WHERE user_id = @user_id")

vRP.prepare ("EG/abrirPonto", "INSERT INTO eg_policia_bate_ponto(user_id) VALUES(@user_id)")
vRP.prepare ("EG/fecharPonto", "UPDATE eg_policia_bate_ponto SET ativo = 1 WHERE user_id = @user_id ORDER BY id DESC limit 1")

vRP.prepare ("EG/registrar","INSERT INTO eg_policia(user_id,type,valor,police_id,text) VALUES(@user_id,@type,@valor,@police_id,@text)")
vRP.prepare ("EG/getCountPrisoes", "SELECT COUNT(id) FROM eg_policia WHERE type = 2 AND police_id = @user_id")
vRP.prepare ("EG/getCountPrisoesHoje", "SELECT COUNT(id) FROM eg_policia WHERE type = 2 AND horario >= CURRENT_DATE()-1 ")
vRP.prepare ("EG/getRegistroProcurado", "SELECT * FROM eg_policia WHERE user_id = @user_id and type = 2 and ativo = 0")
vRP.prepare ("EG/limparFicha", "UPDATE eg_policia SET ativo = 1 WHERE user_id = @user_id")

vRP.prepare ("EG/porte", "UPDATE vrp_user_identities SET licensa = 1 WHERE user_id = @user_id")
vRP.prepare ("EG/tirarPorte", "UPDATE vrp_user_identities SET licensa = 0 WHERE user_id = @user_id")
vRP.prepare ("EG/foragido", "UPDATE vrp_user_identities SET foragido = 1 WHERE user_id = @user_id")
vRP.prepare ("EG/tirarForagido", "UPDATE vrp_user_identities SET foragido = 0 WHERE user_id = @user_id")
vRP.prepare ("EG/porte2", "UPDATE vrp_users SET licensa = 1 WHERE user_id = @user_id")
vRP.prepare ("EG/tirarPorte2", "UPDATE vrp_users SET licensa = 0 WHERE user_id = @user_id")
vRP.prepare ("EG/foragido2", "UPDATE vrp_users SET foragido = 1 WHERE user_id = @user_id")
vRP.prepare ("EG/tirarForagido2", "UPDATE vrp_users SET foragido = 0 WHERE user_id = @user_id")

vRP.prepare ("EG/inserirPontuação", "INSERT INTO eg_policia_pontos(user_id,pontos,descricao) VALUES(@user_id,@pontos,@descricaoPontuacao)")
vRP.prepare ("EG/inserirRelatorio", "INSERT INTO eg_policia_relatorios(user_id,type,nuser_id,descricao) VALUES(@user_id,@type,@nuser_id,@descricao)")
vRP.prepare ("EG/getAcao", "SELECT * FROM eg_policia_acao WHERE concluido = 0")
vRP.prepare ("EG/finalizarAcao", "UPDATE eg_policia_acao SET participantes=@participante, resultado=@resultado, descricao=@descricao, concluido=1 WHERE id=@id")

vRP.prepare ("EG/zerarPontuacao", "UPDATE eg_policia_pontos SET contabilizado = 1 WHERE contabilizado = 0")
vRP.prepare ("EG/zerarAcao", "UPDATE eg_policia_acao SET concluido = 2 WHERE concluido = 0")

vRP.prepare ("EG/createEgPolicia", "CREATE TABLE IF NOT EXISTS `eg_policia` (`id` int(11) NOT NULL AUTO_INCREMENT,`type` int(11) DEFAULT NULL,`user_id` int(11) DEFAULT NULL,`police_id` int(11) DEFAULT NULL,`text` varchar(1000) NOT NULL,`valor` decimal(10,0) NOT NULL,`horario` timestamp NULL DEFAULT current_timestamp(),`img` varchar(100) DEFAULT NULL,`ativo` int(11) DEFAULT 0, PRIMARY KEY (`id`)) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;")
vRP.prepare ("EG/createEgAcoes", "CREATE TABLE IF NOT EXISTS `eg_policia_acao` (`id` int(11) NOT NULL AUTO_INCREMENT, `user_id` int(11) DEFAULT NULL,`text` varchar(1000) NOT NULL,`valor` decimal(10,0) NOT NULL,`horario` timestamp NULL DEFAULT current_timestamp(),`qtdPoliciais` int(11) DEFAULT NULL,`participantes` varchar(100) DEFAULT '{}',`resultado` varchar(50) DEFAULT NULL,`descricao` varchar(500) DEFAULT NULL,`x` float DEFAULT NULL,`y` float DEFAULT NULL,`z` float DEFAULT NULL,`concluido` int(11) DEFAULT 0,PRIMARY KEY (`id`)) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;")
vRP.prepare ("EG/createEgBatePonto", "CREATE TABLE IF NOT EXISTS `eg_policia_bate_ponto` (`id` int(11) NOT NULL AUTO_INCREMENT,`user_id` int(11) DEFAULT NULL,`horario` timestamp NULL DEFAULT current_timestamp(),`horario2` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),`ativo` int(11) DEFAULT NULL,PRIMARY KEY (`id`)) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;")
vRP.prepare ("EG/createEgFuncionarios", "CREATE TABLE IF NOT EXISTS `eg_policia_funcionarios` (`id` int(11) NOT NULL AUTO_INCREMENT,`user_id` int(11) DEFAULT NULL, `value` int(11) DEFAULT NULL,`nome` varchar(100) DEFAULT NULL,`label` varchar(100) DEFAULT NULL,`patente` varchar(100) DEFAULT 'Aluno',`unidade` varchar(100) DEFAULT '-',`pontuacao` int(11) DEFAULT 0,`advertencia` int(11) DEFAULT 0,`exonerado` int(11) DEFAULT 0,`motivo` varchar(100) DEFAULT '0',PRIMARY KEY (`id`)) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=latin1;")
vRP.prepare ("EG/createEgPontos", "CREATE TABLE IF NOT EXISTS `eg_policia_pontos` (`id` int(11) NOT NULL AUTO_INCREMENT, `user_id` int(11) DEFAULT NULL,  `pontos` int(11) DEFAULT NULL,  `descricao` varchar(200) DEFAULT NULL,  `timestamp` timestamp NULL DEFAULT current_timestamp(), `contabilizado` int(11) DEFAULT 0, PRIMARY KEY (`id`) ) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;")
vRP.prepare ("EG/createEgRelatorios", "CREATE TABLE IF NOT EXISTS `eg_policia_relatorios` (`id` int(11) NOT NULL AUTO_INCREMENT, `user_id` int(11) DEFAULT NULL, `nuser_id` int(11) DEFAULT NULL, `type` int(11) DEFAULT NULL, `descricao` varchar(50) DEFAULT NULL, `timestamp` timestamp NULL DEFAULT current_timestamp(), PRIMARY KEY (`id`)) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;")
--------------------------------------------------------------------------
-- CRIAR TABELAS ---------------------------------------------------------
--------------------------------------------------------------------------
Citizen.CreateThread( function()
    vRP.execute("EG/createEgAcoes")
    vRP.execute("EG/createEgPontos")
    vRP.execute("EG/createEgPolicia")
    vRP.execute("EG/createEgBatePonto")
    vRP.execute("EG/createEgFuncionarios")
    vRP.execute("EG/createEgRelatorios")
end)
--------------------------------------------------------------------------
-- COMANDOS --------------------------------------------------------------
--------------------------------------------------------------------------
local authPolice = true
RegisterCommand('limparFicha',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,cFG.permComando) then
        if args[1] then
            TriggerClientEvent("Notify",source,"sucesso","Ficha do pasaporte "..args[1].." foi limpa!")
            vRP.execute("EG/limparFicha", {user_id = args[1]})
        end
	end
end)

RegisterCommand('zerarPontuacao',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,cFG.permComando) then
        TriggerClientEvent("Notify",source,"sucesso","Você zerou todas pontuações pendentes.")
        vRP.execute("EG/zerarPontuacao")
        SendWebhookMessage(cFG.webhookZerarTabelas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ZEROU A PONTUAÇÃO DE TODO MUNDO]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end)

RegisterCommand('porte',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,cFG.permComando) then
        vRP.execute("EG/porte", {user_id = args[1]})
        TriggerClientEvent("Notify",source,"sucesso","Você deu porte para o passaporte "..args[1]..".")
    end
end)

RegisterCommand('tirarPorte',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,cFG.permComando) then
        vRP.execute("EG/tirarPorte", {user_id = args[1]})
        TriggerClientEvent("Notify",source,"sucesso","Você retirou o porte do passaporte "..args[1]..".")
    end
end)

RegisterCommand('foragido',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,cFG.permComando) then
        vRP.execute("EG/foragido", {user_id = args[1]})
        TriggerClientEvent("Notify",source,"sucesso","Você deixou o passaporte "..args[1].." como foragido.")
    end
end)

RegisterCommand('tirarForagido',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,cFG.permComando) then
        vRP.execute("EG/tiraroFragido", {user_id = args[1]})
        TriggerClientEvent("Notify",source,"sucesso","Você tirou o passaporte "..args[1].." como foragido.")
    end
end)

RegisterCommand('zerarAcao',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,cFG.permComando) then
        TriggerClientEvent("Notify",source,"sucesso","Você zerou todas ações pendentes.")
        vRP.execute("EG/zerarAcao")
        SendWebhookMessage(cFG.webhookZerarTabelas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ZEROU TODAS AÇÕES PENDENTES]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end)

RegisterCommand('pena',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
	local tempo = json.decode(value) or 0
    if tempo < 0 then
        TriggerClientEvent("Notify",source,"importante","Você está livre!")
    else
        TriggerClientEvent("Notify",source,"importante","Você ainda tem: <b>"..tempo.." meses</b> de pena pra cumprir.")
    end
end)

RegisterCommand("atualizarPontos",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,cFG.permComando) then
        local funcionarios = vRP.query("EG/getAllFuncionarios")
        for k,v in pairs(funcionarios) do
            local pontosBD = vRP.query("EG/getSomaPontos", {user_id = v.user_id})
            local pontos = json.encode(pontosBD[1])
            pontos = string.sub(pontos, 16, -2)
            if parseInt(pontos) == 0 then
                pontos = json.encode(pontosBD[1])
                pontos = string.sub(pontos, 17, -3)
            end
            pontos = parseInt(pontos)
            pontos = pontos or 0
            vRP.execute("EG/setPontos", {user_id = v.user_id, pontuacao = pontos})
        end
        TriggerClientEvent("Notify",source,"importante","Pontuação de todos oficiais foi computada!.")
    end
end)
--------------------------------------------------------------------------
-- FUNCOES ---------------------------------------------------------------
--------------------------------------------------------------------------
function eG.getAcao()
    local sql = vRP.query("EG/getAcao")
    return sql
end

function eG.getFuncionarios()
    if authPolice == true then
        local source = source
        local user_id = vRP.getUserId(source)
        local funcionarios = vRP.query("EG/getAllFuncionarios")
        if cFG.vrp_user_identities then
            local identity = vRP.query("EG/getIdentidade", {user_id = user_id})
            local funcionarios2 = vRP.query("EG/getFuncionarios")
            local nome = identity[1].name.." "..identity[1].firstname
            local licensa = identity[1].licensa
            local usuario
            local pontosBD = vRP.query("EG/getSomaPontos", {user_id = user_id})
            local prisoes = vRP.query("EG/getCountPrisoes", {user_id = user_id})
            local prisoesHoje = vRP.query("EG/getCountPrisoesHoje")
            
            local pontos = json.encode(pontosBD[1])
            pontos = string.sub(pontos, 16, -2)
            if parseInt(pontos) == 0 then
                pontos = json.encode(pontosBD[1])
                pontos = string.sub(pontos, 17, -3)
            end
            pontos = parseInt(pontos)
            pontos = pontos or 0
            
            prisoes = json.encode(prisoes[1])
            prisoes = string.sub(prisoes, 14, -2)
            prisoes = parseInt(prisoes)
            prisoes = prisoes or 0
        
            prisoesHoje = json.encode(prisoesHoje[1])
            prisoesHoje = string.sub(prisoesHoje, 14, -2)
            prisoesHoje = parseInt(prisoesHoje)
            prisoesHoje = prisoesHoje or 0
        
            vRP.execute("EG/setPontos", {user_id = user_id, pontuacao = pontos})
            
            local allPontos = vRP.query("EG/getPontos", {user_id = user_id})
            local dataAtual = os.time() * 1000
            
            local pontosGraph = {}
            pontosGraph[1] = 0
            pontosGraph[2] = 0
            pontosGraph[3] = 0
            pontosGraph[4] = 0
            pontosGraph[5] = 0
            pontosGraph[6] = 0
            pontosGraph[7] = 0
        
            for k,v in pairs(allPontos) do
                if v.timestamp > dataAtual - 86400000 then
                    pontosGraph[1] = v.pontos + pontosGraph[1]
                elseif v.timestamp > dataAtual - 172800000 then
                    pontosGraph[2] = v.pontos + pontosGraph[2]
                elseif v.timestamp > dataAtual - 259200000 then
                    pontosGraph[3] = v.pontos + pontosGraph[3]
                elseif v.timestamp > dataAtual - 345600000 then
                    pontosGraph[4] = v.pontos + pontosGraph[4]
                elseif v.timestamp > dataAtual - 432000000 then
                    pontosGraph[5] = v.pontos + pontosGraph[5]
                elseif v.timestamp > dataAtual - 518400000 then
                    pontosGraph[6] = v.pontos + pontosGraph[6]
                elseif v.timestamp > dataAtual - 604800000 then
                    pontosGraph[7] = v.pontos + pontosGraph[7]
                end
            end
        
            for k,v in pairs(funcionarios) do
                if v.user_id == user_id then
                    usuario = v
                end
            end
        
            if usuario == nil then
                TriggerClientEvent("Notify",source,"negado","Você ainda não está cadastrado no TABLET.")
                return 0
            end
        
            local isComandante = 0
            if vRP.hasPermission(user_id,cFG.permComando) then
                isComandante = 1
            end
        
            return nome, identity, usuario, funcionarios2, isComandante, pontos, pontosGraph, prisoes, prisoesHoje
        else
            local identity = vRP.query("EG/getIdentidade2", {user_id = user_id})
            local funcionarios2 = vRP.query("EG/getFuncionarios")
            local nome = identity[1].name.." "..identity[1].firstname
            local licensa = identity[1].licensa
            local usuario
            local pontosBD = vRP.query("EG/getSomaPontos", {user_id = user_id})
            local prisoes = vRP.query("EG/getCountPrisoes", {user_id = user_id})
            local prisoesHoje = vRP.query("EG/getCountPrisoesHoje")
            
            local pontos = json.encode(pontosBD[1])
            pontos = string.sub(pontos, 16, -2)
            if parseInt(pontos) == 0 then
                pontos = json.encode(pontosBD[1])
                pontos = string.sub(pontos, 17, -3)
            end
            pontos = parseInt(pontos)
            pontos = pontos or 0
            
            prisoes = json.encode(prisoes[1])
            prisoes = string.sub(prisoes, 14, -2)
            prisoes = parseInt(prisoes)
            prisoes = prisoes or 0
        
            prisoesHoje = json.encode(prisoesHoje[1])
            prisoesHoje = string.sub(prisoesHoje, 14, -2)
            prisoesHoje = parseInt(prisoesHoje)
            prisoesHoje = prisoesHoje or 0
        
            vRP.execute("EG/setPontos", {user_id = user_id, pontuacao = pontos})
            
            local allPontos = vRP.query("EG/getPontos", {user_id = user_id})
            local dataAtual = os.time() * 1000
            
            local pontosGraph = {}
            pontosGraph[1] = 0
            pontosGraph[2] = 0
            pontosGraph[3] = 0
            pontosGraph[4] = 0
            pontosGraph[5] = 0
            pontosGraph[6] = 0
            pontosGraph[7] = 0
        
            for k,v in pairs(allPontos) do
                if v.timestamp > dataAtual - 86400000 then
                    pontosGraph[1] = v.pontos + pontosGraph[1]
                elseif v.timestamp > dataAtual - 172800000 then
                    pontosGraph[2] = v.pontos + pontosGraph[2]
                elseif v.timestamp > dataAtual - 259200000 then
                    pontosGraph[3] = v.pontos + pontosGraph[3]
                elseif v.timestamp > dataAtual - 345600000 then
                    pontosGraph[4] = v.pontos + pontosGraph[4]
                elseif v.timestamp > dataAtual - 432000000 then
                    pontosGraph[5] = v.pontos + pontosGraph[5]
                elseif v.timestamp > dataAtual - 518400000 then
                    pontosGraph[6] = v.pontos + pontosGraph[6]
                elseif v.timestamp > dataAtual - 604800000 then
                    pontosGraph[7] = v.pontos + pontosGraph[7]
                end
            end
        
            for k,v in pairs(funcionarios) do
                if v.user_id == user_id then
                    usuario = v
                end
            end
        
            if usuario == nil then
                TriggerClientEvent("Notify",source,"negado","Você ainda não está cadastrado no TABLET.")
                return 0
            end
        
            local isComandante = 0
            if vRP.hasPermission(user_id,cFG.permComando) then
                isComandante = 1
            end
        
            return nome, identity, usuario, funcionarios2, isComandante, pontos, pontosGraph, prisoes, prisoesHoje
        end
    end
end

function eG.getOnlyFuncionariosTable()
    local funcionarios = vRP.query("EG/getFuncionarios")
    return funcionarios
end

function eG.setPonto(ponto)
    local source = source
    local user_id = vRP.getUserId(source)
    
    if ponto == false then
        vRP.execute("EG/fecharPonto", {user_id = user_id})
        TriggerClientEvent("Notify",source,"sucesso","Você <b>FECHOU</b> a folha de ponto.")
    else
        vRP.execute("EG/abrirPonto", {user_id = user_id})
        TriggerClientEvent("Notify",source,"sucesso","Você <b>ABRIU</b> a folha de ponto.")
    end
end

function eG.cadastrarFuncionario(id)
    local source = source
    local user_id = vRP.getUserId(source)
    if cFG.vrp_user_identities then
        local identity = vRP.query("EG/getIdentidade", {user_id = id})
        local nidentity = vRP.query("EG/getNaCorporacao", {id = id})
        if identity[1] ~= nil then
            if nidentity[1] == nil then
                local nome = identity[1].name.." "..identity[1].firstname
                vRP.addUserGroup(parseInt(id),cFG.permPolicia)
                vRP.execute("EG/cadastrarFuncionario", {user_id = id, nome = nome})
                vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 1, nuser_id = id, descricao = "Contratado"})
                TriggerClientEvent("Notify",source,"sucesso","Você contratou o policial: <b>"..nome.."</b>.")
            else
                vRP.addUserGroup(parseInt(id),cFG.permPolicia)
                vRP.execute("EG/editarFuncionario", {user_id = id})
                vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 3, nuser_id = id, descricao = "RE-Contratado"})
                TriggerClientEvent("Notify",source,"sucesso","Policial RE-Contratado para corporação")
            end
        else
            TriggerClientEvent("Notify",source,"negado","Usuário não encontrado!")
        end
    else
        local identity = vRP.query("EG/getIdentidade2", {user_id = id})
        local nidentity = vRP.query("EG/getNaCorporacao", {id = id})
        if identity[1] ~= nil then
            if nidentity[1] == nil then
                local nome = identity[1].name.." "..identity[1].firstname
                vRP.addUserGroup(parseInt(id),cFG.permPolicia)
                vRP.execute("EG/cadastrarFuncionario", {user_id = id, nome = nome})
                vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 1, nuser_id = id, descricao = "Contratado"})
                TriggerClientEvent("Notify",source,"sucesso","Você contratou o policial: <b>"..nome.."</b>.")
            else
                vRP.addUserGroup(parseInt(id),cFG.permPolicia)
                vRP.execute("EG/editarFuncionario", {user_id = id})
                vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 3, nuser_id = id, descricao = "RE-Contratado"})
                TriggerClientEvent("Notify",source,"sucesso","Policial RE-Contratado para corporação")
            end
        else
            TriggerClientEvent("Notify",source,"negado","Usuário não encontrado!")
        end
    end
end

function eG.exonerarFuncionario(id, desc)
    local source = source
    local user_id = vRP.getUserId(source)

    local nidentity = vRP.query("EG/getNaCorporacao", {id = id})

    if nidentity[1] ~= nil then
        local nplayer = vRP.getUserSource(parseInt(id))
        if nplayer then
            vRP.removeUserGroup(parseInt(id),cFG.permPolicia)
        else
            local data = json.decode(vRP.getUData(parseInt(id), "vRP:datatable"))
            if data.groups then
                data.groups[cFG.permPolicia] = nil
            end
            vRP.setUData(parseInt(id),"vRP:datatable",json.encode(data))
        end
        vRP.execute("EG/exonerarFuncionario", {user_id = id, descricao = desc})
        vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 2, nuser_id = id, descricao = "Exonerado"})
        TriggerClientEvent("Notify",source,"sucesso","Você exonerou o ID: <b>"..id.."</b>.")
    else
        TriggerClientEvent("Notify",source,"negado","Policial não encontrado!")
    end
end

function eG.editarFuncionario(data)
    local source = source
    local user_id = vRP.getUserId(source)

    if data.name ~= "" then
        vRP.execute("EG/editarName", {user_id = data.id, name = data.name})
        vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 3, nuser_id = data.id, descricao = "Nome"})
        SendWebhookMessage(cFG.webhookEdit,"```prolog\n[ID]: "..user_id.." \n[ALTEROU O NOME DO ID]: "..data.id.." [PARA]: "..data.name..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        TriggerClientEvent("Notify",source,"sucesso","Você alterou o <b>NOME</b>.")
    end
    if data.unidade ~= "" then
        vRP.execute("EG/editarUnidade", {user_id = data.id, unidade = data.unidade.unidade})
        vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 3, nuser_id = data.id, descricao = "Unidade"})
        SendWebhookMessage(cFG.webhookEdit,"```prolog\n[ID]: "..user_id.." \n[ALTEROU A UNIDADE DO ID]: "..data.id.." [PARA]: "..data.unidade.unidade..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        TriggerClientEvent("Notify",source,"sucesso","Você alterou a <b>UNIDADE</b>.")
    end
    if data.patente ~= "" then
        if data.patente.group then
            vRP.addUserGroup(parseInt(data.id),data.patente.group)
        end
        vRP.execute("EG/editarPatente", {user_id = data.id, patente = data.patente.patente})
        vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 3, nuser_id = data.id, descricao = "Patente"})
        SendWebhookMessage(cFG.webhookEdit,"```prolog\n[ID]: "..user_id.." \n[ALTEROU A PATENTE DO ID]: "..data.id.." [PARA]: "..data.patente.patente..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        TriggerClientEvent("Notify",source,"sucesso","Você alterou a <b>PATENTE</b>.")
    end
    if data.adv ~= "" then
        vRP.execute("EG/editarAdv", {user_id = data.id, adv = data.adv})
        vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 3, nuser_id = data.id, descricao = "Adv"})
        SendWebhookMessage(cFG.webhookEdit,"```prolog\n[ID]: "..user_id.." \n[ALTEROU AS ADV DO ID]: "..data.id.." [PARA]: "..data.adv.." ADVS"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        TriggerClientEvent("Notify",source,"sucesso","Você alterou as <b>ADVERTÊNCIAS</b>.")
    end
    if data.pontuacao ~= "" then
        vRP.execute("EG/inserirPontuação", {user_id = data.id, pontos = data.pontuacao, descricaoPontuacao = "Pontuação Adicionada"})
        vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 3, nuser_id = data.id, descricao = "Pontuação Adicionada"})
        SendWebhookMessage(cFG.webhookEdit,"```prolog\n[ID]: "..user_id.." \n[ALTEROU A PONTUACAO DO ID]: "..data.id.." [PARA]: "..data.pontuacao.." PONTOS"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        TriggerClientEvent("Notify",source,"sucesso","Você alterou a <b>PONTUACAO</b>.")
    end
end

function eG.getProcurado(id)
    local source = source
    local user_id = vRP.getUserId(source)
    if id then
        local value = vRP.getUData(parseInt(id),"vRP:multas")
        local multas = json.decode(value) or 0
        if cFG.vrp_user_identities then
            local procurado = vRP.query("EG/getIdentidade", {user_id = id})
            local registroPrisoes = vRP.query("EG/getRegistroProcurado", {user_id = id})
            return procurado[1],multas,registroPrisoes
        else
            local procurado = vRP.query("EG/getIdentidade2", {user_id = id})
            local registroPrisoes = vRP.query("EG/getRegistroProcurado", {user_id = id})
            return procurado[1],multas,registroPrisoes
        end
    end
end

function eG.multar(data)
    local source = source
    local user_id = vRP.getUserId(source)

    local value = vRP.getUData(parseInt(data.id),"vRP:multas")
    local multas = json.decode(value) or 0

    if data.id == "" then
        TriggerClientEvent("Notify",source,"negado","Você não registrou o passaporte.")
        return
    end
    if parseInt(data.amount) < 0 then
        TriggerClientEvent("Notify",source,"negado","Você não pode aplicar multa negativa.")
        return
    end
    if parseInt(data.amount) == 0 then
        TriggerClientEvent("Notify",source,"negado","Você não pode aplicar multa de $0.")
        return
    end
    if data.motivo == "" then
        TriggerClientEvent("Notify",source,"negado","Você precisa de um motivo para multar.")
        return
    end
    vRP.setUData(parseInt(data.id),"vRP:multas",json.encode(multas+parseInt(data.amount)))
    
    local oficialid = vRP.getUserIdentity(user_id)
    local identity = vRP.getUserIdentity(parseInt(data.id))
    TriggerClientEvent("Notify",source,"sucesso","Multa aplicada com sucesso.")

    vRP.execute("EG/registrar", {user_id = data.id, type = 1,valor = data.amount, police_id = user_id, text = data.motivo })
    SendWebhookMessage(cFG.webhookMultas,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============MULTOU==============] \n[PASSAPORTE]: "..data.id.." "..identity.name.." "..identity.firstname.." \n[VALOR]: $"..data.amount.." \n[MOTIVO]: "..data.motivo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

end

function eG.setPreso(data)
    local source = source
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(parseInt(data.id))
    local crimes = data.desc
    local multa = 0
    local tempoPreso = 0
    local idsParticipante = {}
    
    if authPolice == true then
        if data.preso.value ~= nil then
            if data.preso.value == 0 then
                tempoPreso = 0
            else
                tempoPreso = data.totalTempoPreso * data.preso.value
                tempoPreso = parseInt(tempoPreso)
            end
        else
            TriggerClientEvent("Notify",source,"negado","% do valor tempo preso inválida.")
            return
        end
            
        if data.multa.value ~= nil then
            if data.multa.value == 0 then
                multa = 0
            else
                multa = data.totalMulta * data.multa.value
                multa = parseInt(multa)

                local value = vRP.getUData(parseInt(data.id),"vRP:multas")
                local multas = json.decode(value) or 0
                vRP.setUData(parseInt(data.id),"vRP:multas",json.encode(multa+parseInt(multas)))
                
                local oficialid = vRP.getUserIdentity(user_id)
                local identity = vRP.getUserIdentity(parseInt(data.id))
                vRP.execute("EG/registrar", {user_id = data.id, type = 1, valor = multa, police_id = user_id, text = 'Ao ser preso' })
                TriggerClientEvent("Notify",source,"sucesso","Multa aplicada com sucesso.")
                SendWebhookMessage(cFG.webhookMultas,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============MULTOU==============] \n[PASSAPORTE]: "..data.id.." "..identity.name.." "..identity.firstname.." \n[VALOR]: $"..multa.." \n[MOTIVO]: "..crimes.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            end
        else
            TriggerClientEvent("Notify",source,"negado","% do valor da multa inválida.")
            return
        end
            
        if data.participantes[1] ~= nil then
            for k,v in pairs(data.participantes) do
                idsParticipante[k] = v.user_id 
                vRP.execute("EG/inserirPontuação", {user_id = v.user_id, pontos = cFG.pontuacao.prender, descricaoPontuacao = "Prisão Efetuada"})
            end
        else
            TriggerClientEvent("Notify",source,"negado","Policiais participantes inválidos.")
            return
        end
            
        if player then
            if tempoPreso > 0 then
                local oficial = vRP.getUserIdentity(user_id)
                local identity = vRP.getUserIdentity(parseInt(data.id))
                local nplayer = vRP.getUserSource(parseInt(data.id))

                vRP.setUData(parseInt(data.id),"vRP:prisao",json.encode(tempoPreso))
                vRPclient.setHandcuffed(player,false)
                TriggerClientEvent('EG:prisioneiro',player,true)
                vRPclient.teleport(player,1680.1,2513.0,45.5)
                eGprison_lock(parseInt(data.id))
                TriggerClientEvent('EG:prision:cut',player)
                TriggerClientEvent('EG:prision:cut',player)
                TriggerClientEvent('removealgemas',player)
                TriggerClientEvent("vrp_sound:source",player,'jaildoor',0.7)
                TriggerClientEvent("vrp_sound:source",source,'jaildoor',0.7)
                
                TriggerClientEvent("Notify",source,"sucesso","Prisão efetuada com sucesso.")
                TriggerClientEvent("Notify",source,"importante","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b> de bonificação.")
                TriggerClientEvent("Notify",nplayer,"importante","Você foi preso por <b>"..tempoPreso.." meses</b>.<br><b>Motivo:</b> "..crimes..".")
                vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
                
                SendWebhookMessage(cFG.webhookRelatorioPrisao,"```prolog\n[OFICIAL]: "..user_id.." "..oficial.name.." "..oficial.firstname.." \n[==============PRENDEU==============] \n[PASSAPORTE]: "..data.id.." "..identity.name.." "..identity.firstname.." \n[TEMPO]: "..parseInt(tempoPreso).." Meses \n[CRIMES]: "..crimes.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                vRP.execute("EG/registrar", {user_id = data.id, type = 2,valor = tempoPreso, police_id = user_id, text = crimes })
                SetTimeout(1000,function()
                    local model = vRPclient.getModelPlayer(nplayer)
                    if model == "mp_m_freemode_01" then
                        TriggerClientEvent("updateRoupas",nplayer,{ -1,0,-1,0,0,0,15,0,64,6,15,0,1,0,238,0,-1,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 })
                    elseif model == "mp_f_freemode_01" then
                        TriggerClientEvent("updateRoupas",nplayer,{ -1,0,0,0,0,0,4,0,101,6,7,0,1,1,247,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 })
                    end
                end)
            end
        else
            TriggerClientEvent("Notify",source,"negado","Pessoa não encontrada")
        end
    end
end

function eG.getSexo()
    local source = source
    while true do
        local old_custom = vRPclient.getCustomization(source)
        if old_custom.modelhash == 1885233650 then
            return cFG.fardamentosMasculino
        else
            return cFG.fardamentosFeminino
        end
    end
end

function eGprison_lock(target_id)
	local player = vRP.getUserSource(parseInt(target_id))
    local preso = true
	if player then
        SetTimeout(60000,function()
            local value = vRP.getUData(parseInt(target_id),"vRP:prisao")
            local tempo = json.decode(value) or 0
            if parseInt(tempo) >= 1 then
                TriggerClientEvent("Notify",player,"importante","Ainda vai passar <b>"..parseInt(tempo).." meses</b> preso.")
                vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(parseInt(tempo)-1))
                eGprison_lock(parseInt(target_id))
            elseif parseInt(tempo) == 0 then
                TriggerClientEvent('EG:prisioneiro',player,false) 
                TriggerClientEvent('EG:cancelando',player,false)
                vRPclient.teleport(player,cFG.localPrisao.xSaida,cFG.localPrisao.ySaida,cFG.localPrisao.zSaida)
                vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(-1))
                TriggerClientEvent("Notify",player,"importante","Sua sentença terminou, esperamos não ve-lo novamente.")
            end
            vRPclient.PrisionGod(player)
        end)
	end
end

function eG.eGprison_lock()
    local player = source
    local target_id = vRP.getUserId(player)

    local preso = true
	if player then
        SetTimeout(60000,function()
            local value = vRP.getUData(parseInt(target_id),"vRP:prisao")
            local tempo = json.decode(value) or 0
            if parseInt(tempo) >= 1 then
                TriggerClientEvent("Notify",player,"importante","Ainda vai passar <b>"..parseInt(tempo).." meses</b> preso.")
                vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(parseInt(tempo)-1))
                eGprison_lock(parseInt(target_id))
            elseif parseInt(tempo) == 0 then
                TriggerClientEvent('EG:prisioneiro',player,false)
                TriggerClientEvent('EG:cancelando',player,false)
                vRPclient.teleport(player,cFG.localPrisao.xSaida,cFG.localPrisao.ySaida,cFG.localPrisao.zSaida)
                vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(-1))
                TriggerClientEvent("Notify",player,"importante","Sua sentença terminou, esperamos não ve-lo novamente.")
            end
            vRPclient.PrisionGod(player)
        end)
	end
end

function eG.finalizarAcao(acao,participantes,result,desc)
    local source = source
    local user_id = vRP.getUserId(source)
    local resultado = result.value
    local participante = {}
    local nomeParticipante = {}
    local id = acao.id
    local pontos = 0
    local descricaoPontuacao = ""
    if result.value == "Vitória" then
        pontos = cFG.pontuacao.vitoriaAcao
        descricaoPontuacao = "Vitória em ação"
    elseif result.value == "Empate" then
        pontos = cFG.pontuacao.empateAcao
        descricaoPontuacao = "Empate em ação"
    else
        pontos = cFG.pontuacao.derrotaAcao
        descricaoPontuacao = "Derrota em ação"
    end

    for k,v in pairs(participantes) do
        participante[k] = v.user_id 
        nomeParticipante[k] = v.user_id.." | "..v.nome

        vRP.giveBankMoney(v.user_id, 5000)
        TriggerClientEvent("Notify",vRP.getUserSource(v.user_id),"sucesso","Você ganhou <b>$5000</b> por ter participado da ação <b>"..acao.text.."</b>.")
        vRP.execute("EG/inserirPontuação", {user_id = v.user_id, pontos = pontos, descricaoPontuacao = descricaoPontuacao})
    end
    nomeParticipante = json.encode(nomeParticipante)
    participante = json.encode(participante)    

    SendWebhookMessage(cFG.webhookRelatorioAcao,"```lua\n[ACAO]: "..acao.text.."\n[STATUS]: "..resultado.."\n[PARTICIPANTES]: "..nomeParticipante.."\n[DESCRICAO]: "..desc..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    vRP.execute("EG/finalizarAcao", {participante = participante, resultado = resultado, descricao = desc, id = id})
    vRP.execute("EG/inserirRelatorio", {user_id = user_id, type = 4, nuser_id = 0, descricao = "Criou um relatório de ação"})
end

function eG.getGun(data)
    local source = source
    local user_id = vRP.getUserId(source)
    
    if authPolice == true then
        if vRP.hasPermission(user_id,cFG.permPolicia) then
            local funcionario = vRP.query("EG/getNaCorporacao", {id = user_id})
            local patentes = json.decode(data.patentes)
            local patentePessoa = 0
            local liberado = 0
            for k,v in pairs(cFG.patentes) do
                if funcionario[1].patente == v.patente then
                    patentePessoa = v.value
                end
            end
            for k,v in pairs(patentes) do
                if patentePessoa == v then
                    liberado = 1
                end
            end
            if liberado == 1 then
                if vRP.tryFullPayment(user_id,data.preco) then
                    if data.spawn == 'item' then
                        local item = string.lower(data.arma)
                        vRP.giveInventoryItem(user_id,item,data.municao)	
                        TriggerClientEvent("Notify",source,"sucesso","Você comprou um(a) <b>"..data.arma.."</b> por $<b>"..data.preco.."</b>.")
                        SendWebhookMessage(cFG.webhookArma,"```prolog\n[ID]: "..user_id.." \n[COMPROU UM(A)]: "..data.arma.." [QUANTIDADE]: "..data.municao.." [POR]:"..data.preco..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                    else
                        vRPclient.giveWeapons(source,{[data.spawn] = { ammo = data.municao }})
                        TriggerClientEvent("Notify",source,"sucesso","Você pegou uma <b>"..data.arma.."</b> por $<b>"..data.preco.."</b>.")
                        SendWebhookMessage(cFG.webhookArma,"```prolog\n[ID]: "..user_id.." \n[PEGOU UMA]: "..data.arma.." [COM]: "..data.municao.." BALLAS [POR]:"..data.preco..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                    end
                else
                    TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
                end
            else
                TriggerClientEvent("Notify",source,"negado","Patente não condiz com a arma.")
            end
        else
            TriggerClientEvent("Notify",source,"negado","Você está fora de serviço!.")
        end
    end
end

function eG.farDP()
    TriggerClientEvent("Notify",source,"negado","Você está longe do <b>ARSENAL</b>.")
end

function eG.checkPermission()
    local source = source
    local user_id = vRP.getUserId(source)
    
    if authPolice == true then
        if vRP.hasPermission(user_id,cFG.permPolicia) then
            return true
        else
            TriggerClientEvent("Notify",source,"negado","Você não tem permissão.")
        end
    else
        TriggerClientEvent("Notify",source,"negado","SCRIPT NAO AUTENTICADO.")
    end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local player = vRP.getUserSource(parseInt(user_id))
	if player then
		SetTimeout(30000,function()
			local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
			local tempo = json.decode(value) or -1

			if tempo == -1 then
				return
			end

			if tempo > 0 then
				TriggerClientEvent('EG:prisioneiro',player,true)
				vRPclient.teleport(player,1680.1,2513.0,46.5)
				eGprison_lock(parseInt(user_id))
			end
		end)
	end
end)

RegisterServerEvent("diminuirpena157")
AddEventHandler("diminuirpena157",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
	local tempo = json.decode(value) or 0
	if tempo >= cFG.tempoMinimoPena then
		vRP.setUData(parseInt(user_id),"vRP:prisao",json.encode(parseInt(tempo)-cFG.reducaoPorCaixa))
		TriggerClientEvent("Notify",source,"importante","Sua pena foi reduzida em <b>"..cFG.reducaoPorCaixa.." meses</b>, continue o trabalho.")
	else
		TriggerClientEvent("Notify",source,"importante","Atingiu o limite da redução de pena, não precisa mais trabalhar.")
	end
end)

RegisterServerEvent('salario:pagamento:policial')
AddEventHandler('salario:pagamento:policial',function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
        if vRP.hasPermission(user_id,cFG.permPolicia) then
            local funcionario = vRP.query("EG/getNaCorporacao", {id = user_id})
            funcionario = funcionario[1]
            if funcionario then
                for k,v in pairs(cFG.patentes) do
                    if funcionario.patente == v.patente then
                        TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
                        TriggerClientEvent("Notify",source,"importante","Obrigado por colaborar com a cidade, seu salario de <b>"..v.patente.." $"..vRP.format(parseInt(v.salario)).." dólares</b> foi depositado.")
                        vRP.giveBankMoney(user_id,parseInt(v.salario))
                        SendWebhookMessage(cFG.webhookSalarios,"```prolog\n\n[ID]:"..user_id.." \n[VALOR]: "..vRP.format(parseInt(v.salario)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                    end
                end
            end
        end
	end
end)
--------------------------------------------------------------------------
-- AUTHENTICATE SYSTEM ---------------------------------------------------
--------------------------------------------------------------------------
local token = cFG.token
local script = GetCurrentResourceName()
local resultados, ip
local FalhaAuthWebhook = ""