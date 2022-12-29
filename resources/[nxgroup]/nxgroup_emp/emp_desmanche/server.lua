local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

eG = {}
Tunnel.bindInterface("eg_desmanche",eG)
 
local webhookDesmanchado = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

vRP._prepare("vRP/setDetido", "UPDATE vrp_user_vehicles SET detido = @detido, time = @time, ipva = @ipva WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/set_detido", "UPDATE vrp_user_vehicles SET detido = @detido, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("eG/getCarro", "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")


function eG.checkVeh(vehicleHash)
  local vehicle = exports['nyo_modules']:getVehicleInfo(vehicleHash)
  if vehicle then
    if not vehicle.banned then
      return true
    else
      return false
    end
  else
    return false
  end
end

local desmanchando = {} 
function eG.checkProprietario(placa,vehicle)
  local source = source
  local user_id = vRP.getUserByRegistration(placa)
  local vehicle = exports['nyo_modules']:getVehicleInfo(vehicle)
  local hasCar = vRP.execute("eG/getCarro", {user_id = user_id, vehicle = vehicle.modelname}) or 0
  if hasCar[1] then
    if hasCar[1].detido == 0 then
      if desmanchando[placa] then
        TriggerClientEvent("Notify", source, "aviso", "Alguem já está desmanchando esse veículo.")
        return false
      else
        desmanchando[placa] = true
        return true
      end
    else
      TriggerClientEvent("Notify", source, "aviso", "Alguem já está desmanchando esse veículo.")
      return false
    end
  end    
  return false
end

function eG.checkPermission(perm)
  return vRP.hasPermission(vRP.getUserId(source), perm)
end

function eG.entregaItem(item)
  vRP.giveInventoryItem(vRP.getUserId(source), item, 1)
  return true
end

function eG.removeItem(item)
  if vRP.getUserId(source) then
    vRP.tryGetInventoryItem(vRP.getUserId(source), item, 1)
  end
  return true
end

function eG.GerarPagamento(placa, vehHash)
  local source = source
  local user_id = vRP.getUserId(source)
  local identity = vRP.getUserIdentity(user_id)

  local vehicle = exports['nyo_modules']:getVehicleInfo(vehHash)
  local idProprietario = vRP.getUserByRegistration(placa)
  local vehDesmanchado = vehicle.modelname
  local valorDesmanche = vehicle.price * 0.1
  local sourceProprietario = vRP.getUserSource(idProprietario)
  desmanchando[placa] = false

  vRP.execute("vRP/setDetido", {detido = 1, time = "0", user_id = idProprietario, vehicle = vehDesmanchado, ipva = parseInt(os.time()) })
  vRP.giveInventoryItem(vRP.getUserId(source), "dinheiro-sujo", valorDesmanche)

  SendWebhookMessage(webhookDesmanchado,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DESMANCHOU]: "..vehicle.name.." [SPAWN]: "..vehDesmanchado.." [PLACA]:"..placa.." \n[DINHEIRO SUJO RECEBIDO]: "..valorDesmanche.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

  if vRP.getUserByRegistration(a) and vRP.getUserSource((vRP.getUserByRegistration(a))) then
    TriggerClientEvent("Notify", sourceProprietario, "aviso", "AVISO DA SEGURADORA: Seu veículo foi desmanchado. Você deverá pagar uma taxa significativa para obter o veículo: <b>" .. vehicle.modelo .. "</b> de volta.")
  end
  return true
end

