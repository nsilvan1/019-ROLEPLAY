------------------------------------------------------------------------------------
-- connection
------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

------------------------------------------------------------------------------------
-- exports
------------------------------------------------------------------------------------
puxarID = function(source)
    return vRP.getUserId(source)
end

pegarIdentidade = function(user_id)
    return vRP.getUserIdentity(user_id)
end

temPermissao = function(user_id, permission)
    return vRP.hasPermission(user_id, permission)
end

PermissoesDeUsers = function(user_id, permission)
    return vRP.getUsersByPermission(user_id, permission)
end

promptdepergunta = function(title,default_text)
    return vRP.prompt(title,default_text)
end

pegarServerData = function(key, cbr)
    return vRP.getSData(key, cbr)
end

pegarUserData = function(user_id, key, cbr)
    return vRP.getUData(user_id, key, cbr)
end

setarUserData = function(user_id, key, cbr)
    return vRP.setUData(user_id, key, cbr)
end

pegarPosicao = function(source) -- Pegar a posição do player para o NotifyPush
    return vRPclient.getPosition(source)
end

puxarItemDoInventario = function(user_id,idname,amount,notify,slot)
    return vRP.tryGetInventoryItem(user_id,idname,amount,notify,slot)
end

verificarItemInventario = function(user_id,amount)
    return vRP.getInventoryItemAmount(user_id,amount)
end

