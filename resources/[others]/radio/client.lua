local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vSERVER = Tunnel.getInterface('radio')

---
local privateChannel = {
  {channel = 1, perm = "ac.permissao"},
  {channel = 171, perm = "bratva.permissao"},
  -- {channel = 2, perm = "policiatoogle.permissao"},
  -- {channel = 3, perm = "policiatoogle.permissao"},
  -- {channel = 4, perm = "policiatoogle.permissao"},
  -- {channel = 5, perm = "paramedico.permissao"},
  -- {channel = 6, perm = "paramedico.permissao"},
  -- {channel = 7, perm = "mecanico.permissao"},
  -- {channel = 8, perm = "vagos.permissao"},
  -- {channel = 9, perm = "vagos.permissao"},
  -- {channel = 10, perm = "ballas.permissao"},
  -- {channel = 11, perm = "ballas.permissao"},
  -- {channel = 12, perm = "groove.permissao"},
  -- {channel = 13, perm = "groove.permissao"},
  -- {channel = 14, perm = "yakuza.permissao"},
  -- {channel = 15, perm = "yakuza.permissao"},
  -- {channel = 16, perm = "bratva.permissao"},
  -- {channel = 17, perm = "bratva.permissao"},
  -- {channel = 18, perm = "bloods.permissao"},
  -- {channel = 19, perm = "bloods.permissao"},
  -- {channel = 20, perm = "motoclub.permissao"},
  -- {channel = 21, perm = "motoclub.permissao"},
  -- {channel = 22, perm = "hells.permissao"},
  -- {channel = 23, perm = "hells.permissao"},
  -- {channel = 24, perm = "ms13.permissao"},
  -- {channel = 25, perm = "ms13.permissao"},
  -- {channel = 26, perm = "aztecas.permissao"},
  -- {channel = 27, perm = "aztecas.permissao"},
  -- {channel = 28, perm = "pb.permissao"},
  -- {channel = 29, perm = "pb.permissao"},
  -- {channel = 30, perm = "cartel.permissao"},
  -- {channel = 31, perm = "cartel.permissao"},
  -- {channel = 32, perm = "elements.permissao"},
  -- {channel = 33, perm = "elements.permissao"},
  -- {channel = 34, perm = "tdr.permissao"},
  -- {channel = 35, perm = "tdr.permissao"},
  -- {channel = 36, perm = "vagos2.permissao"},
  -- {channel = 37, perm = "vagos2.permissao"},
  -- {channel = 38, perm = "ballas2.permissao"},
  -- {channel = 39, perm = "ballas2.permissao"},
  -- {channel = 40, perm = "Groove2.permissao"},
  -- {channel = 41, perm = "Groove2.permissao"},
  -- {channel = 42, perm = "aztecas2.permissao"},
  -- {channel = 43, perm = "aztecas2.permissao"},
  -- {channel = 44, perm = "cosanostra2.permissao"},
  -- {channel = 45, perm = "cosanostra2.permissao"},
  -- {channel = 46, perm = "bloods2.permissao"},
  -- {channel = 47, perm = "bloods2.permissao"},
  -- {channel = 48, perm = "motoclub2.permissao"},
  -- {channel = 49, perm = "motoclub2.permissao"},
  -- {channel = 50, perm = "hells2.permissao"},
  -- {channel = 51, perm = "hells2.permissao"},
  -- {channel = 52, perm = "tequila1.permissao"},
  -- {channel = 53, perm = "tequila1.permissao"},
  -- {channel = 54, perm = "bahamas2.permissao"},
  -- {channel = 55, perm = "bahamas2.permissao"},
  -- {channel = 56, perm = "pb2.permissao"},
  -- {channel = 57, perm = "pb2.permissao"},
  -- {channel = 58, perm = "ada2.permissao"},
  -- {channel = 59, perm = "ada2.permissao"},
  -- {channel = 60, perm = "elements2.permissao"},
  -- {channel = 61, perm = "elements2.permissao"},
  -- {channel = 62, perm = "tdr2.permissao"},
  -- {channel = 63, perm = "tdr2.permissao"},
  -- {channel = 64, perm = "azul.permissao"},
  -- {channel = 65, perm = "azul.permissao"},
  -- {channel = 66, perm = "bahamaslav.permissao"},
  -- {channel = 67, perm = "bahamaslav.permissao"},
  -- {channel = 68, perm = "redline.permissao"},
  -- {channel = 69, perm = "redline.permissao"},
  -- {channel = 70, perm = "chamadosp.permissao"},
  -- {channel = 71, perm = "blacksuits.permissao"},
  -- {channel = 72, perm = "blacksuits.permissao"},
  -- {channel = 73, perm = "policiatoogle.permissao"},
  -- {channel = 74, perm = "policiatoogle.permissao"},
}

local GuiOpened = false

RegisterCommand("radio", function() if vSERVER.hasRadio() then--
    openGui()
       else
   TriggerEvent("nyo_notify", "#8B0000", "Negado", "Você não possui um rádio", 5000) 
  end
  Wait(1)
end)

RegisterNetEvent('radioGui')
AddEventHandler('radioGui', function()
  if vSERVER.hasRadio() then
    openGui()
  else
    TriggerEvent("nyo_notify", "#8B0000", "Negado", "Você não possui um rádio", 5000) 
  end
  Wait(1)
end)

-- --------------------------------------------------------------------------------------------------------------------------------
-- -- CHANGEVOLUME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("changevolume", function(data,cb)
	if parseInt(data["volume"]) ~= radioVolume then 
		radioVolume = parseInt(data["volume"])
		exports["pma-voice"]:setRadioVolume(parseInt(radioVolume))
	end
end)

function checkPermission(data)
  if privateChannel then
    for k, v in pairs(privateChannel) do
      local selectedChannel = tonumber(data) or nil
      if selectedChannel then
        if tonumber(v.channel) == selectedChannel then
          if not vSERVER.hasPermission(v.perm) then
          TriggerEvent("Notify","negado","Você não tem permissão para entrar nessa frequencia.")
            return false
          end
        end
      end
    end
  end
  return true
end

function openGui()
  if not GuiOpened then
    GuiOpened = true
    SetNuiFocus(true,true)
  	radioShow = true
	  SendNUIMessage({ show = true })
  else
    GuiOpened = false
    SetNuiFocus(false,false)
    radioShow = false
    SendNUIMessage({ show = false })
  end
  TriggerEvent("animation:radio",GuiOpened)
  --ExecuteCommand("hud")
end


RegisterNUICallback('click', function(data, cb)
  PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("activeFrequency", function(data,cb)
	local frequency = parseInt(data["freq"])
	if checkPermission(frequency) then
		exports["pma-voice"]:setRadioChannel(frequency)
		exports["pma-voice"]:setVoiceProperty('radioEnabled',true)
		-- TriggerEvent("hud:RadioDisplay",parseInt(frequency))
    	 TriggerEvent('hud:channel',parseInt(frequency)) -- Nao mexer, deixar hud:channel

		TriggerEvent("Notify","aviso","Conectado <b>"..frequency..".00</b> MHz.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INATIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("inativeFrequency", function(data,cb)
	local frequency = parseInt(data["freq"])
	exports["pma-voice"]:removePlayerFromRadio()
	-- TriggerEvent("hud:RadioDisplay","")
	-- TriggerEvent('hud:channel',"N.A")
	TriggerEvent('nation_hud:channel',"N.A")
  TriggerEvent("Notify","aviso","Desconectado")
end)

RegisterNUICallback('closeRadio', function(data, cb)
  TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.6)
  GuiOpened = false
  SetNuiFocus(false,false)
  SendNUIMessage({ show = false })
  TriggerEvent("animation:radio",GuiOpened)
  vRP._DeletarObjeto()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTSERVERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_radio:outServers")
AddEventHandler("vrp_radio:outServers",function()
	exports["pma-voice"]:removePlayerFromRadio()
	exports["pma-voice"]:setVoiceProperty('radioEnabled',false)
	-- TriggerEvent('hud:channel','N.A')
  TriggerEvent('nation_hud:channel','N.A')

end)

Citizen.CreateThread(function()

  while GuiOpened do
    -- if GuiOpened then
      Citizen.Wait(1)
      DisableControlAction(0, 1, GuiOpened) -- LookLeftRight
      DisableControlAction(0, 2, GuiOpened) -- LookUpDown
      DisableControlAction(0, 14, GuiOpened) -- INPUT_WEAPON_WHEEL_NEXT
      DisableControlAction(0, 15, GuiOpened) -- INPUT_WEAPON_WHEEL_PREV
      DisableControlAction(0, 16, GuiOpened) -- INPUT_SELECT_NEXT_WEAPON
      DisableControlAction(0, 17, GuiOpened) -- INPUT_SELECT_PREV_WEAPON
      DisableControlAction(0, 99, GuiOpened) -- INPUT_VEH_SELECT_NEXT_WEAPON
      DisableControlAction(0, 100, GuiOpened) -- INPUT_VEH_SELECT_PREV_WEAPON
      DisableControlAction(0, 115, GuiOpened) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
      DisableControlAction(0, 116, GuiOpened) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
      DisableControlAction(0, 142, GuiOpened) -- MeleeAttackAlternate
      DisableControlAction(0, 106, GuiOpened) -- VehicleMouseControlOverride
    -- else
    --   Citizen.Wait(20)
    -- end    
  end
end)

RegisterNetEvent('animation:radio')
AddEventHandler('animation:radio', function(enable)
  local lPed = PlayerPedId()
  inPhone = enable

  RequestAnimDict("cellphone@")
  while not HasAnimDictLoaded("cellphone@") do
    Citizen.Wait(0)
  end

  local intrunk = false
  if not intrunk then
    TaskPlayAnim(lPed, "cellphone@", "cellphone_text_in", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
  end
  Citizen.Wait(300)
  if inPhone then
    Citizen.Wait(150)
    while inPhone do

      local dead = false
      if dead then
        closeGui()
        inPhone = false
      end
      local intrunk = false
      if not intrunk and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_text_read_base", 3) and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_swipe_screen", 3) then
        TaskPlayAnim(lPed, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
      end    
      Citizen.Wait(1)
    end
    local intrunk = false
    if not intrunk then
      ClearPedTasks(PlayerPedId())
    end
  else
    local intrunk = false
    if not intrunk then
      Citizen.Wait(100)
      ClearPedTasks(PlayerPedId())
      TaskPlayAnim(lPed, "cellphone@", "cellphone_text_out", 2.0, 1.0, 5.0, 49, 0, 0, 0, 0)
      Citizen.Wait(400)
      Citizen.Wait(400)
      ClearPedTasks(PlayerPedId())
    end
  end
end)

RegisterCommand("volume",function(source,args)
  if tonumber(args[1]) <= 100 and tonumber(args[1]) >= 10 then
      local volume = tonumber(args[1])
      exports["pma-voice"]:setRadioVolume(volume/100)
  TriggerEvent("nyo_notify", "#009933", "Sucesso", "<b>Volume:</b> "..volume.."%", 4000)
  end
end)