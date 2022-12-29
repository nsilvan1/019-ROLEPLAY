local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")


cnCR = {}
Tunnel.bindInterface("cacador_recompensa",cnCR)

-----------------------------------------------------------------------------------------------------------------------------------------
-- Busca
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("queryPassport",
             "SELECT * FROM vrp_user_identities WHERE user_id = @user_id")	
vRP.prepare("queryCacador",
             "SELECT * FROM vw_cacador")	
vRP.prepare("queryCacadorAtivo",
             "SELECT * FROM vw_cacador Where user_id = @user_id and ativo = 'S'")	             
vRP.prepare("queryProcurados",
             "SELECT * FROM vw_procurado")	
vRP.prepare("queryHierarquia",
             "SELECT * FROM cacador_hierarquia")	
                          
             
-----------------------------------------------------------------------------------------------------------------------------------------
-- Update/inserts
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("insertCacador",
             "INSERT INTO cacador_user (user_id, ativo, hierarquia_id) VALUES ( @user_id, 'S', @hierarquia_id) ")	

vRP.prepare("updateCacador",
             "UPDATE cacador_user set ativo = @ativo where id = @id ")	        

vRP.prepare("updateHierarquiaCacador",
             "UPDATE cacador_user set hierarquia_id = @hierarquia_id where id = @id ")	                    
             
vRP.prepare("insertCacadorHierarquia",
             "INSERT INTO cacador_hierarquia (nome, altera) VALUES ( @nome, 'N') ")	

vRP.prepare("updateCacadorHierarquia",
             "UPDATE cacador_hierarquia set nome = @nome, altera = @altera where id = @id ")	                   

vRP.prepare("insertProcurado",
             "INSERT INTO tbl_policia_procurado (user_id, recompensa) VALUES ( @user_id, @recompensa) ")	

vRP.prepare("removeProcurado",
             "DELETE FROM tbl_policia_procurado where id = @id ")	
             
-----------------------------------------------------------------------------------------------------------------------------------------
-- getPassport
-----------------------------------------------------------------------------------------------------------------------------------------
function cnCR.getPass(user_id)
	return vRP.query("queryPassport", {user_id = user_id})
end	

function cnCR.addCacador (user_id, hierarquia_id)
    vRP.execute('insertCacador', {user_id = user_id, hierarquia_id = hierarquia_id})
    return true    
end

function cnCR.updateCacador (id, status)
    vRP.execute('updateCacador', {ativo = status, id = id})
    return true    
end

function cnCR.updateHierarquiaCacador (id, hierarquia_id)
    vRP.execute('updateHierarquiaCacador', {hierarquia_id = hierarquia_id , id = id})
    return true    
end

function cnCR.getCacadores()
    return vRP.query("queryCacador", {})
end

function cnCR.getProcurados()
    return vRP.query("queryProcurados", {})
end

function cnCR.insertHierarquia(nome, id, altera)
    if id > 0 then 
        vRP.execute('updateCacadorHierarquia', {nome = nome, id = id, altera = altera})
    else 
       vRP.execute('insertCacadorHierarquia', {nome = nome})
    end
end 

function cnCR.getHierarquia()
    return vRP.query("queryHierarquia", {})
end

function cnCR.insertRecompensa(user_id, recompensa)
    return vRP.execute("insertProcurado", {user_id = user_id, recompensa = recompensa })
end

function cnCR.removeProcurado(id)
    vRP.execute("removeProcurado", {id = id })
end

function cnCR.pagamentoRecompensa(valor, id, user_id )
    vRP.giveMoney(user_id,parseInt(valor))
    TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..vRP.format(parseInt(valor)).." dolar.")			
    vRP.execute("removeProcurado", {id = id })
end 

function cnCR.ValidationUser( )
    local validado = false
    local source = source
    local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("queryCacadorAtivo",{ user_id = user_id })
    if #rows > 0  then
        validado = true
    elseif vRP.hasPermission(user_id, "admin.permissao") or
        vRP.hasPermission(user_id, "policia.permissao") then 
            validado = true
    end
    return validado
end 

function cnCR.ValidationUserRemote( )
    local validado = false
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "admin.permissao") or
        vRP.hasPermission(user_id, "policia.permissao") then 
            validado = true
    end
    return validado
end 

function cnCR.permiteAlterar( )
    local Alterar = false
    local source = source
    local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("queryCacadorAtivo",{ user_id = user_id })
    if vRP.hasPermission(user_id, "admin.permissao") or
       vRP.hasPermission(user_id, "policia.permissao") then
        Alterar = true
    elseif  #rows > 0  then
        if rows[1].permite_alterar == 'S' then 
           Alterar = true
        end
    end
    return Alterar
end 