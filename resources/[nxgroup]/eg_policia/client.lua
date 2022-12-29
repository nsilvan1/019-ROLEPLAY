local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local cFG = module("eg_policia", "config")

vRP = Proxy.getInterface("vRP")
eGServer = Tunnel.getInterface("eg_policia")

eG = {}
Tunnel.bindInterface("eg_policia",eG)
-------------------------------------------------------------------
-- VARIAVEIS ------------------------------------------------------
-------------------------------------------------------------------
local data = {}
local bateponto = 0
local currentResourceName = GetCurrentResourceName()

function SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
end

function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  vRP._DeletarObjeto()
  vRP._stopAnim(false)
  cb({})
end)

RegisterCommand('tabletpolicia', function()
  -- if eGServer.checkPermission() and eGServer.checkAuth() then
  if eGServer.checkPermission() then
    if valueToNui() ~= 0 then
      vRP._CarregarObjeto("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,28422)
      toggleNuiFrame(true)
    end
  end
end)  

data[1] = cFG.nomePolicia
data[2] = cFG.imgPolicia
data[8] = bateponto
data[9] = cFG.codigoPenal
data[10] = cFG.armasArsenal
data[11] = cFG.patentes
data[12] = cFG.unidades
data[19] = cFG.viaturas

function valueToNui()
  data[3], data[4], data[5], data[6], data[13], data[14], data[15], data[16], data[17] = eGServer.getFuncionarios()
  data[18] = eGServer.getSexo()
  if data[3] == 0 then
    return 0
  end
  data[7] = eGServer.getAcao()
  SendReactMessage('setData',data)
end

RegisterNUICallback('baterPonto', function(data)
  if data.data == true then
    bateponto = 1
    eGServer.setPonto(true)
  else
    bateponto = 0
    eGServer.setPonto(false)
  end
end)

RegisterNUICallback('multar', function(data)
  eGServer.multar(data)
end)

RegisterNUICallback('editarFuncionario', function(data)
  eGServer.editarFuncionario(data)
  local funcionarioTable = eGServer.getOnlyFuncionariosTable()
  SendReactMessage('updateFuncionario',funcionarioTable)
end)

RegisterNUICallback('cadastrarFuncionario', function(data)
  eGServer.cadastrarFuncionario(data.id)
  local funcionarioTable = eGServer.getOnlyFuncionariosTable()
  SendReactMessage('updateFuncionario',funcionarioTable)
end)

RegisterNUICallback('exonerarFuncionario', function(data)
  eGServer.exonerarFuncionario(data.id, data.desc)
  local funcionarioTable = eGServer.getOnlyFuncionariosTable()
  SendReactMessage('updateFuncionario',funcionarioTable)
end)

RegisterNUICallback('getProcurado', function(data)
  local procurado,multas,registro = eGServer.getProcurado(data.id)
  local data = {}
  data[1] = procurado
  data[2] = multas
  data[3] = registro
  SendReactMessage('setProcurado',data)
end)

RegisterNUICallback('finalizarAcao', function(data)
  eGServer.finalizarAcao(data.data, data.participantes, data.result, data.desc)
  local acao = eGServer.getAcao()
  SendReactMessage('updateAcoes',acao)
end)

RegisterNUICallback('getGun', function(data)
  local far = false
  if cFG.armamentoNaDP then
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
    for k,v in pairs(cFG.arsenal) do
      local distanceArsenal = Vdist(x,y,z,v[1],v[2],v[3])
      if distanceArsenal <= cFG.distanciaArmamento then
        eGServer.getGun(data.arma)
        return
      else
        far = true
      end
    end
    if far then
      eGServer.farDP()
    end
  else
    eGServer.getGun(data.arma)
  end
end)

RegisterNUICallback('setPreso', function(data)
  local preso = eGServer.setPreso(data)
  SendReactMessage('updatePreso')
end)

local prisioneiroo = false
local reducaopenal = false
RegisterNetEvent('EG:prisioneiro')
AddEventHandler('EG:prisioneiro',function(status)
	prisioneiroo = status
	reducaopenal = false
	local ped = PlayerPedId()
	if prisioneiroo then
    eGServer.eGprison_lock()
    iniciarPrisao()
    --iniciarTrabalhos()
		FreezeEntityPosition(ped,true)
		SetEntityVisible(ped,false,false)
		SetTimeout(5000,function()
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true,false)
		end)
	end
end)

function iniciarPrisao()
  Citizen.CreateThread(function()
    while prisioneiroo do
      local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),cFG.localPrisao.x,cFG.localPrisao.y,cFG.localPrisao.z,true)
      if distance >= cFG.localPrisao.raio then
        SetEntityCoords(PlayerPedId(),cFG.localPrisao.x,cFG.localPrisao.y,cFG.localPrisao.z)
        TriggerEvent("Notify","aviso","O agente penitenciário encontrou você tentando escapar.")
      end
      Citizen.Wait(5000)
    end
  end)
end

function iniciarTrabalhos()
  Citizen.CreateThread(function()
    local ui = GetMinimapAnchor()
    local reducaopenal = false
    while prisioneiroo and cFG.trabalhosPrisao do
      local egsleep = 1000
      local ped = PlayerPedId()
      if cFG.trabalhoCaixa then
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),cFG.trabalhoPegarCaixa[1],cFG.trabalhoPegarCaixa[2],cFG.trabalhoPegarCaixa[3],true)
        local distance2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),cFG.trabalhoEntregarCaixa[1],cFG.trabalhoEntregarCaixa[2],cFG.trabalhoEntregarCaixa[3],true)

        if distance <= 50 and not reducaopenal then
          egsleep = 5
          cFG.drawMarker(cFG.trabalhoPegarCaixa[1],cFG.trabalhoPegarCaixa[2],cFG.trabalhoPegarCaixa[3])
          if distance <= 2 then
            drawTxt2(ui.right_x+0.25,ui.bottom_y-0.100,0.50,"PRESSIONE  ~r~E~w~  PARA TRABALHAR ENTREGANDO CAIXAS")
            if IsControlJustPressed(0,38) then
              reducaopenal = true
              TriggerEvent('EG:cancelando',true)
              vRP._CarregarObjeto("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
            end
          end
        end

        if reducaopenal then
          egsleep = 5
          cFG.drawMarker(cFG.trabalhoEntregarCaixa[1],cFG.trabalhoEntregarCaixa[2],cFG.trabalhoEntregarCaixa[3])
          if distance2 > 2 then
            drawTxt2(ui.right_x+0.25,ui.bottom_y-0.100,0.50,"ENTREGUE A CAIXA DO  ~r~OUTRO~w~  LADO DO PÁTIO")
          end
          if distance2 <= 2 then
            drawTxt2(ui.right_x+0.25,ui.bottom_y-0.100,0.50,"PRESSIONE  ~r~E~w~  PARA ENTREGAR A CAIXA")
            if IsControlJustPressed(0,38) then
              reducaopenal = false
              vRP._DeletarObjeto()
              TriggerEvent('EG:cancelando',false)
              TriggerServerEvent("diminuirpena157")
            end
          end
        end
      end
      Citizen.Wait(egsleep)
    end
  end)
end

-------------------------------------------------------------------------------
--[ CANCELANDO O F6 ]----------------------------------------------------------
-------------------------------------------------------------------------------
local cancelando = false
RegisterNetEvent('EG:cancelando')
AddEventHandler('EG:cancelando',function(status)
    cancelando = status
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		if cancelando then
			sleep = 1
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,21,true)
			DisableControlAction(0,22,true)
			DisableControlAction(0,29,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,137,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,169,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,245,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,344,true)			
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(cFG.tempoPagamento*60000)
		TriggerServerEvent('salario:pagamento:policial')
	end
end)

---------------------------------------------------------------------------------
-- FUNCOES  ---------------------------------------------------------------------
---------------------------------------------------------------------------------
function drawTxt2(x,y,scale,text)
	SetTextFont(4)
	SetTextScale(scale,scale)
	SetTextColour(255,255,255,255)
	SetTextEdge(2,0,0,0,255)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function GetMinimapAnchor()
	local safezone = GetSafeZoneSize()
	local safezone_x = 1.0 / 20.0
	local safezone_y = 1.0 / 20.0
	local aspect_ratio = GetAspectRatio(0)
	local res_x, res_y = GetActiveScreenResolution()
	local xscale = 1.0 / res_x
	local yscale = 1.0 / res_y
	local Minimap = {}
	Minimap.width = xscale * (res_x / (4 * aspect_ratio))
	Minimap.height = yscale * (res_y / 5.674)
	Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
	Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
	Minimap.right_x = Minimap.left_x + Minimap.width
	Minimap.top_y = Minimap.bottom_y - Minimap.height
	Minimap.x = Minimap.left_x
	Minimap.y = Minimap.top_y
	Minimap.xunit = xscale
	Minimap.yunit = yscale
	return Minimap
end