local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vSERVER = Tunnel.getInterface('pma-radio')

local privateChannel = {
	{channel = 190, perm = "revistar.permissao"},
	{channel = 191, perm = "revistar.permissao"},
	{channel = 192, perm = "cmcde.permissao"},
	{channel = 193, perm = "revistar.permissao"},
	{channel = 194, perm = "revistar.permissao"},
	{channel = 195, perm = "revistar.permissao"},
	{channel = 196, perm = "revistar.permissao"},
	{channel = 197, perm = "revistar.permissao"},
	{channel = 198, perm = "revistar.permissao"},
	{channel = 199, perm = "revistar.permissao"},
}
local GuiOpened = false

RegisterNetEvent("radio:check")
AddEventHandler("radio:check",function()
	if vSERVER.hasRadio() then
		openGui()
	else
		TriggerEvent("Notify","negado","Você não possui um <b>Rádio.</b>")
	end
	Wait(1)
end)
 
RegisterCommand("radio", function()
	print(vSERVER.hasRadio())
	if vSERVER.hasRadio() then
		openGui()
	else
		TriggerEvent("Notify","negado","Você não possui um <b>Rádio.</b>")
	end
	Wait(1)
end)

RegisterNetEvent('radioGui')
AddEventHandler('radioGui', function()
	if vSERVER.hasRadio() then
		openGui()
	else
		TriggerEvent("Notify","negado","Você não possui um <b>Rádio.</b>")
	end
	Wait(1)
end)

RegisterNetEvent('ChannelSet')
AddEventHandler('ChannelSet', function(chan)
	SendNUIMessage({set = true, setChannel = chan})
end)

RegisterNetEvent('radio:resetNuiCommand')
AddEventHandler('radio:resetNuiCommand', function()
    SendNUIMessage({reset = true})
end)

function checkPermission(data)
	if privateChannel then
		for k, v in pairs(privateChannel) do
			local selectedChannel = tonumber(data.channel) or nil
			if selectedChannel then
				if tonumber(v.channel) == selectedChannel then
					if not vSERVER.hasPermission(v.perm) then
						TriggerEvent("Notify","negado","Você não tem permissão para entrar nessa frequência.")
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
		SetNuiFocus(false,false)
		SetNuiFocus(true,true)
		SendNUIMessage({open = true})
	else
		GuiOpened = false
		SetNuiFocus(false,false)
		SendNUIMessage({open = false})
	end
	vRP._CarregarObjeto("cellphone@","cellphone_text_in","prop_cs_hand_radio",50,28422)
end

RegisterNUICallback('click', function(data, cb)
	TriggerEvent("vrp_sound:source",'click-radio',1.0)
end)

local volume = 0

RegisterNUICallback('volumeUp', function(data, cb)
	volume = exports["pma-voice"]:getRadioVolume()
	volume = parseInt(volume*100)
	if volume <= 90 then
		volume = parseInt(volume+10)
		exports["pma-voice"]:setRadioVolume(volume)
		TriggerEvent("Notify","sucesso","Volume do rádio: <b>"..parseInt(volume).."%</b>",3000)
	else
		exports["pma-voice"]:setRadioVolume(100)
		TriggerEvent("Notify","sucesso","Volume do rádio: <b>100 %</b>",3000)
	end
end)

RegisterNUICallback('volumeDown', function(data, cb)
	volume = exports["pma-voice"]:getRadioVolume()
	volume = parseInt(volume*100)
	if volume >= 0 then
		volume = parseInt(volume-10)
		exports["pma-voice"]:setRadioVolume(volume)
		TriggerEvent("Notify","sucesso","Volume do rádio: <b>"..parseInt(vol).."%</b>",3000)
	else
		exports["pma-voice"]:setRadioVolume(10)
		TriggerEvent("Notify","sucesso","Volume do rádio: <b>10 %</b>",3000)
	end
end)

RegisterNUICallback('cleanClose', function(data, cb)
	TriggerEvent("vrp_sound:source",'click-radio',1.0)
	GuiOpened = false
	SetNuiFocus(false,false)
	SendNUIMessage({open = false})
	vRP._DeletarObjeto(source)
	vRP.DeletarObjeto()
end)

RegisterNUICallback('poweredOn', function(data, cb)
	if checkPermission(data) then
		TriggerEvent("vrp_sound:source",'click-radio',1.0)
		local fuckingidiot = tonumber(data.channel)
		if fuckingidiot == nil then
			fuckingidiot = 0
		end
		local newChannel = fuckingidiot
		if fuckingidiot < 10 and fuckingidiot > 0 then
			newChannel = fuckingidiot
		end
		if newChannel == 0 then
			TriggerEvent("radio:outServers")
			exports["pma-voice"]:removePlayerFromRadio()
			exports["pma-voice"]:setVoiceProperty('radioEnabled',false)
		else
			TriggerEvent("Notify","sucesso","Você entrou na frequência: <b>"..newChannel.."</b>.",3000)
			exports["pma-voice"]:setRadioChannel(newChannel)
			exports["pma-voice"]:setVoiceProperty('radioEnabled',true)
		end
	end
end)

RegisterNUICallback('poweredOff', function(data, cb)
	TriggerEvent("radio:outServers")
	exports["pma-voice"]:removePlayerFromRadio()
	exports["pma-voice"]:setVoiceProperty('radioEnabled',false)
end)

RegisterNUICallback('close', function(data, cb)
	if checkPermission(data) then
		TriggerEvent("vrp_sound:source",'click-radio',1.0)
		local fuckingidiot = tonumber(data.channel)
		if fuckingidiot == nil then
			fuckingidiot = 0
		end
		local newChannel = fuckingidiot
		if fuckingidiot < 10 and fuckingidiot > 0 then
			newChannel = fuckingidiot
		end
		if newChannel == 0 then
			TriggerEvent("radio:outServers")
			exports["pma-voice"]:removePlayerFromRadio()
			exports["pma-voice"]:setVoiceProperty('radioEnabled',false)
		else
			TriggerEvent("Notify","sucesso","Você entrou na frequência: <b>"..newChannel.."</b>.",3000)
			exports["pma-voice"]:setRadioChannel(newChannel)
			exports["pma-voice"]:setVoiceProperty('radioEnabled',true)
		end
		GuiOpened = false
		SetNuiFocus(false,false)
		SendNUIMessage({open = false})
		vRP._DeletarObjeto(source)
		vRP.DeletarObjeto()
	end
end)

Citizen.CreateThread(function()
	while true do
		if GuiOpened then
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
		else
			Citizen.Wait(20)
		end    
	end
end)

RegisterNetEvent("radio:outServers")
AddEventHandler("radio:outServers",function()
	exports["pma-voice"]:SetRadioChannel(0)
	exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
	TriggerEvent("Notify","sucesso","Você saiu de <b>todas</b> as frequências.",3000)
end)

AddEventHandler("onClientResourceStart", function(resName)
	if GetCurrentResourceName() ~= resName and "pma-voice" ~= resName then
		return
	end
	exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
end)